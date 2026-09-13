-- Winwing FCU, standalone or with left EFIS, for Fenix A319/A320/A321.
-- Local repair 2026-09-07. Uses the installed Fenix cockpit LVAR interface.
-- Input numbers: MobiFlight winwing_fcu_efisl.joystick.json (one-based -> zero-based).
if ilua_require_fenix_a320() then return end

local fcu = com.sim.qm.Wwfcuefisl.Open()
local deviceName = 'WwFcuEfisL'
if not fcu then
    fcu = com.sim.qm.Wwfcu.Open()
    deviceName = 'WwFcu'
end
if not fcu then return end
uluaLog('Winwing FCU for Fenix: ' .. deviceName .. ' [local repair 2026-09-07]')

-- Momentary switches, including release; encoders use the same counters as
-- Fenix's own MSFS 2024 Cockpit_Behavior.xml / Inputs.xml.
local switches = {
    'S_FCU_SPD_MACH', 'S_FCU_LOC', 'S_FCU_HDGVS_TRKFPA',
    'S_FCU_AP1', 'S_FCU_AP2', 'S_FCU_ATHR', 'S_FCU_EXPED',
    'S_FCU_METRIC_ALT', 'S_FCU_APPR'
}
for i, name in ipairs(switches) do
    fcu:CfgRpn(i - 1, '1 (>L:' .. name .. ')', '0 (>L:' .. name .. ')')
end
local knobs = {
    {9, 'E_FCU_SPEED'},
    {13, 'E_FCU_HEADING'},
    {17, 'E_FCU_ALTITUDE'},
    {21, 'E_FCU_VS'}
}
for _, knob in ipairs(knobs) do
    local key, encoder = unpack(knob)
    fcu:CfgRpn(key, '(L:' .. encoder .. ') -- (>L:' .. encoder .. ')')
    fcu:CfgRpn(key + 1, '(L:' .. encoder .. ') ++ (>L:' .. encoder .. ')')
    -- SimAppPro 1.17.5 / SimLogic 1.2.56, fnx_32x/FCU_2024:
    -- one InputEvent Set(value=1) on press, no action on release.
    -- Use both native actions so Fenix also updates the knob animation state.
    local event = 'B:FNX320_INPUT_KNOB_PUSHPULL_' .. encoder
    fcu:CfgVal(key + 2, event .. '_PUSH', 1)
    fcu:CfgVal(key + 3, event .. '_PULL', 1)
end
fcu:CfgRpn(25, '0 (>L:S_FCU_ALTITUDE_SCALE)')
fcu:CfgRpn(26, '1 (>L:S_FCU_ALTITUDE_SCALE)')

local refs = {}
local function ref(name)
    if not refs[name] then refs[name] = uluaFind('(L:' .. name .. ')') end
    return refs[name]
end
local inputs = {
    'B_FCU_POWER', 'A_FCU_LIGHTING', 'A_FCU_LIGHTING_TEXT',
    'N_FCU_SPEED', 'N_FCU_HEADING', 'N_FCU_ALTITUDE', 'N_FCU_VS',
    'B_FCU_SPEED_DASHED', 'B_FCU_HEADING_DASHED', 'B_FCU_VERTICALSPEED_DASHED',
    'B_FCU_SPEED_MACH', 'B_FCU_TRACK_FPA_MODE',
    'I_FCU_SPEED_MANAGED', 'I_FCU_HEADING_MANAGED', 'I_FCU_ALTITUDE_MANAGED',
    'I_FCU_LOC', 'I_FCU_AP1', 'I_FCU_AP2', 'I_FCU_ATHR', 'I_FCU_EXPED', 'I_FCU_APPR'
}
for _, name in ipairs(inputs) do ref(name) end
local function get(name) return tonumber(uluaGet(refs[name])) or 0 end
local function clamp(value, low, high) return math.min(high, math.max(low, value)) end
local function digits(value, count)
    return string.format('%0' .. count .. 'd', math.floor(math.abs(value) + 0.5))
end
local ledCache = {}
local function led(index, value)
    value = math.floor(clamp(value, 0, 255))
    if ledCache[index] ~= value then
        -- Numeric FCU component indices bypass the EFIS class's duplicate
        -- Get/SetBkl names (which address EFIS logical LED indices).
        fcu:SendLedCmd(index, value)
        ledCache[index] = value
    end
end
local indicators = {
    {3, 'I_FCU_LOC'}, {5, 'I_FCU_AP1'}, {7, 'I_FCU_AP2'},
    {9, 'I_FCU_ATHR'}, {11, 'I_FCU_EXPED'}, {13, 'I_FCU_APPR'}
}
local previousPower = nil
local loggedData = false
local displayValues = {}
local displayInputs = {
    'N_FCU_SPEED', 'N_FCU_HEADING', 'N_FCU_ALTITUDE', 'N_FCU_VS',
    'B_FCU_SPEED_MACH', 'B_FCU_TRACK_FPA_MODE',
    'B_FCU_SPEED_DASHED', 'B_FCU_HEADING_DASHED', 'B_FCU_VERTICALSPEED_DASHED',
    'I_FCU_SPEED_MANAGED', 'I_FCU_HEADING_MANAGED', 'I_FCU_ALTITUDE_MANAGED'
}
GlobalFrameLoopManager:add(function()
    local power = get('B_FCU_POWER') > 0
    if power ~= previousPower then
        uluaLog('Winwing FCU Fenix power: ' .. (power and 'ON' or 'OFF'))
        previousPower = power
        fcu.LcdText = nil
        ledCache = {}
    end
    led(0, power and get('A_FCU_LIGHTING') * 255 or 0)
    led(1, power and clamp(get('A_FCU_LIGHTING_TEXT'), 0.1, 1) * 255 or 0)
    led(2, power and 200 or 0)
    led(30, power and get('A_FCU_LIGHTING') * 255 or 0)
    for _, item in ipairs(indicators) do
        led(item[1], power and (get(item[2]) > 0 and 1 or 0) or 0)
    end
    -- Poll at the original frequency; format/encode only changed display data.
    local displayChanged = fcu.LcdText == nil
    for _, name in ipairs(displayInputs) do
        local value = get(name)
        if displayValues[name] ~= value then
            displayValues[name] = value
            displayChanged = true
        end
    end
    if not displayChanged then return end
    local speed, heading, altitude, vs = displayValues.N_FCU_SPEED, displayValues.N_FCU_HEADING, displayValues.N_FCU_ALTITUDE, displayValues.N_FCU_VS
    local mach = displayValues.B_FCU_SPEED_MACH > 0
    local fpa = displayValues.B_FCU_TRACK_FPA_MODE > 0
    if power and altitude > 0 and not loggedData then
        uluaLog(string.format('Winwing FCU Fenix data: SPD=%s HDG=%s ALT=%s VS=%s', speed, heading, altitude, vs))
        loggedData = true
    end
    local speedText = digits(mach and (speed < 2 and speed * 100 or speed) or speed, 3)
    local headingText = digits(heading, 3)
    local vsText = fpa and ('  ' .. digits(vs / 100, 2)) or digits(vs, 4)
    if displayValues.B_FCU_SPEED_DASHED > 0 or speed < 0 then speedText = '---' end
    if displayValues.B_FCU_HEADING_DASHED > 0 or heading < 0 then headingText = '---' end
    if displayValues.B_FCU_VERTICALSPEED_DASHED > 0 then vsText = '----' end
    fcu:setFcuDisplay({
        displayEnabled = power, speed = speedText, heading = headingText,
        altitude = digits(altitude, 5), verticalSpeed = vsText,
        spdMach = mach, spdManaged = displayValues.I_FCU_SPEED_MANAGED > 0,
        hdgManaged = displayValues.I_FCU_HEADING_MANAGED > 0,
        altManaged = displayValues.I_FCU_ALTITUDE_MANAGED > 0,
        headingHdg = not fpa, headingTrk = fpa, headingLat = false,
        vsMode = not fpa, fpaMode = fpa, vsIndication = not fpa, fpaIndication = fpa,
        vsSign = vs < 0, vsVerticalLine = vs >= 0, fpaComma = fpa
    })
end)

-- The left EFIS is a component of the same USB device, with its own
-- component address, LED indices and segment encoding.
if deviceName ~= 'WwFcuEfisL' then return end
local efisButtons = {'FD', 'LS', 'CSTR', 'WPT', 'VORD', 'NDB', 'ARPT'}
for i, name in ipairs(efisButtons) do
    local variable = 'S_FCU_EFIS1_' .. name
    fcu:CfgRpn(31 + i, '1 (>L:' .. variable .. ')', '0 (>L:' .. variable .. ')')
    ref('I_FCU_EFIS1_' .. name)
end
fcu:CfgRpn(39, '(L:S_FCU_EFIS1_BARO_STD) -- (>L:S_FCU_EFIS1_BARO_STD)')
fcu:CfgRpn(40, '(L:S_FCU_EFIS1_BARO_STD) ++ (>L:S_FCU_EFIS1_BARO_STD)')
fcu:CfgRpn(41, '(L:E_FCU_EFIS1_BARO) -- (>L:E_FCU_EFIS1_BARO)')
fcu:CfgRpn(42, '(L:E_FCU_EFIS1_BARO) ++ (>L:E_FCU_EFIS1_BARO)')
-- Fenix: 0 = inHg, 1 = hPa; cockpit tooltip labels describe the next action.
fcu:CfgRpn(43, '0 (>L:S_FCU_EFIS1_BARO_MODE)') -- inHg
fcu:CfgRpn(44, '1 (>L:S_FCU_EFIS1_BARO_MODE)') -- hPa
for mode = 0, 4 do fcu:CfgRpn(45 + mode, mode .. ' (>L:S_FCU_EFIS1_ND_MODE)') end
for zoom = 0, 5 do fcu:CfgRpn(50 + zoom, zoom .. ' (>L:S_FCU_EFIS1_ND_ZOOM)') end
for pos = 0, 2 do
    fcu:CfgRpn(56 + pos, pos .. ' (>L:S_FCU_EFIS1_NAV1)')
    fcu:CfgRpn(59 + pos, pos .. ' (>L:S_FCU_EFIS1_NAV2)')
end
for _, name in ipairs({'N_FCU_EFIS1_BARO_HPA', 'N_FCU_EFIS1_BARO_INCH',
    'B_FCU_EFIS1_BARO_INCH', 'B_FCU_EFIS1_BARO_STD', 'I_FCU_EFIS1_QNH'}) do ref(name) end
local baroRef = uluaFind('cpuwolf/flyluaio/WwFcuEfisL/lcdL/baro')
local baroFlagsRef = uluaFind('cpuwolf/flyluaio/WwFcuEfisL/lcdL/flag')
local baroSeqRef = uluaFind('cpuwolf/flyluaio/WwFcuEfisL/lcdL/seqNum')
local baroFinishRef = uluaFind('cpuwolf/flyluaio/WwFcuEfisL/finishL/seqNum')
-- EFIS digit bits: TL=1, middle=2, BL=4, bottom=8, top=16,
-- TR=32, BR=64, decimal=128. Bytes are ordered left to right.
local baroSegments = {
    ['0']=0x7D, ['1']=0x60, ['2']=0x3E, ['3']=0x7A, ['4']=0x63,
    ['5']=0x5B, ['6']=0x5F, ['7']=0x70, ['8']=0x7F, ['9']=0x7B,
    [' ']=0, ['S']=0x5B, ['t']=0x0F, ['d']=0x6E, ['-']=0x02
}
local leftLedCache, lastBaro, lastBaroFlags = {}, nil, nil
local function leftLed(index, value)
    value = math.floor(clamp(value, 0, 255))
    if leftLedCache[index] ~= value then
        fcu:SendLedCmdL(index, value)
        leftLedCache[index] = value
    end
end
local loggedBaro = false
local lastPressure, lastStandard, lastInches, lastQnh, lastPower
uluaLog('Winwing left EFIS for Fenix: 30 inputs, BARO display and LEDs')
GlobalFrameLoopManager:add(function()
    local power = get('B_FCU_POWER') > 0
    leftLed(0, power and get('A_FCU_LIGHTING') * 255 or 0)
    leftLed(1, power and clamp(get('A_FCU_LIGHTING_TEXT'), 0.1, 1) * 255 or 0)
    leftLed(2, power and 200 or 0)
    for i, name in ipairs(efisButtons) do
        leftLed(i + 2, power and (get('I_FCU_EFIS1_' .. name) > 0 and 1 or 0) or 0)
    end
    local standard = get('B_FCU_EFIS1_BARO_STD') > 0
    local inches = get('B_FCU_EFIS1_BARO_INCH') > 0
    local pressure = inches and get('N_FCU_EFIS1_BARO_INCH') or get('N_FCU_EFIS1_BARO_HPA')
    local qnh = get('I_FCU_EFIS1_QNH') > 0
    if pressure == lastPressure and standard == lastStandard and inches == lastInches
        and qnh == lastQnh and power == lastPower then return end
    lastPressure, lastStandard, lastInches, lastQnh, lastPower = pressure, standard, inches, qnh, power
    if inches and pressure < 100 then pressure = pressure * 100 end
    local text = digits(pressure, 4)
    local flags = qnh and 2 or 1
    if standard then text, flags = ' Std', 0 end
    if not power then text, flags = '    ', 0 end
    local packed, multiplier = 0, 1
    for i = 1, 4 do
        local value = baroSegments[text:sub(i,i)] or 0
        if power and not standard and inches and i == 2 then value = value + 128 end
        packed, multiplier = packed + value * multiplier, multiplier * 256
    end
    if packed ~= lastBaro or flags ~= lastBaroFlags then
        uluaSet(baroRef, packed)
        uluaSet(baroFlagsRef, flags)
        local sequence = fcu:Next()
        uluaSet(baroSeqRef, sequence)
        uluaSet(baroFinishRef, sequence)
        lastBaro, lastBaroFlags = packed, flags
    end
    if power and pressure > 0 and not loggedBaro then
        uluaLog('Winwing EFIS Fenix BARO: ' .. text .. (inches and ' inHg' or ' hPa'))
        loggedBaro = true
    end
end)
