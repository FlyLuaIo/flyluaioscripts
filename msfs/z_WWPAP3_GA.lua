-- *****************************************************************
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-08-08_03_55_08UTC
-- *****************************************************************
if ilua_require_msfs() then
    return
end
-- Do not remove below lines: hardware detection
local wwpap3 = com.sim.qm.Wwpap3.Open()
if not wwpap3 then return end
-- Do not remove above lines: hardware detection

uluaLog('Wwpap3 for GA')

-------------------- Input Keys Binding (RPN from QMCP737C GA) ---------------------
-- Mode buttons (bits 0..16)
wwpap3:CfgRpn(0, '(>K:AP_N1_HOLD)')                                                            -- N1
wwpap3:CfgRpn(1, '(>K:AP_MANAGED_SPEED_HOLD)')                                                 -- SPEED
wwpap3:CfgRpn(2, '(>K:FLIGHT_LEVEL_CHANGE) (A:AIRSPEED INDICATED, knots) (>K:AP_SPD_VAR_SET)') -- VNAV
wwpap3:CfgRpn(3, '(>K:FLIGHT_LEVEL_CHANGE)')                                                   -- LVL CHG
wwpap3:CfgRpn(4, '(>K:AP_PANEL_HEADING_HOLD)')                                                 -- HDG SEL
wwpap3:CfgRpn(5, '(>K:AP_NAV1_HOLD)')                                                          -- LNAV
wwpap3:CfgRpn(6, '(>K:AP_NAV1_HOLD)')                                                          -- VOR LOC
wwpap3:CfgRpn(7, '(>K:AP_APR_HOLD)')                                                           -- APP
wwpap3:CfgRpn(8, '(>K:AP_ALT_HOLD)')                                                           -- ALT HOLD
wwpap3:CfgRpn(9, '(>K:AP_PANEL_VS_HOLD)')                                                      -- V/S
wwpap3:CfgRpn(10, '(>K:AP_MASTER)')                                                            -- CMD A
wwpap3:CfgRpn(11, '(>K:AP_MASTER)')                                                            -- CWS A
wwpap3:CfgRpn(12, '(>K:AP_MASTER)')                                                            -- CMD B
wwpap3:CfgRpn(13, '(>K:AP_MASTER)')                                                            -- CWS B
wwpap3:CfgRpn(14, '(>K:AP_SPEED_SLOT_INDEX_SET)')                                              -- C/O
wwpap3:CfgRpn(15, '(A:AIRSPEED INDICATED, knots) (>K:AP_SPD_VAR_SET)')                         -- SPD INTV
wwpap3:CfgRpn(16, '(A:INDICATED ALTITUDE, feet) (>K:AP_ALT_VAR_SET)')                          -- ALT INTV

-- Encoders as button pairs (DEC/INC)
wwpap3:CfgRpn(17, '(>H:AS1000_PFD_CRS_DEC)') -- L CRS DEC
wwpap3:CfgRpn(18, '(>H:AS1000_PFD_CRS_INC)') -- L CRS INC
wwpap3:CfgRpn(19, '1 (>K:AP_SPD_VAR_DEC)')   -- SPD DEC
wwpap3:CfgRpn(20, '1 (>K:AP_SPD_VAR_INC)')   -- SPD INC
wwpap3:CfgRpn(21, '1 (>K:HEADING_BUG_DEC)')  -- HDG DEC
wwpap3:CfgRpn(22, '1 (>K:HEADING_BUG_INC)')  -- HDG INC
wwpap3:CfgRpn(23, '100 (>K:AP_ALT_VAR_DEC)') -- ALT DEC
wwpap3:CfgRpn(24, '100 (>K:AP_ALT_VAR_INC)') -- ALT INC
wwpap3:CfgRpn(25, '(>H:AS1000_PFD_CRS_DEC)') -- R CRS DEC
wwpap3:CfgRpn(26, '(>H:AS1000_PFD_CRS_INC)') -- R CRS INC

-- FD Capt / FO maintained (bits 27..30)
wwpap3:CfgRpn(27,
    '(A:AUTOPILOT FLIGHT DIRECTOR ACTIVE:1, Bool) if{ 1 (>K:TOGGLE_FLIGHT_DIRECTOR) }')
wwpap3:CfgRpn(28,
    '(A:AUTOPILOT FLIGHT DIRECTOR ACTIVE:1, Bool) ! if{ 1 (>K:TOGGLE_FLIGHT_DIRECTOR) }')
wwpap3:CfgRpn(29,
    '(A:AUTOPILOT FLIGHT DIRECTOR ACTIVE:2, Bool) if{ 2 (>K:TOGGLE_FLIGHT_DIRECTOR) }')
wwpap3:CfgRpn(30,
    '(A:AUTOPILOT FLIGHT DIRECTOR ACTIVE:2, Bool) ! if{ 2 (>K:TOGGLE_FLIGHT_DIRECTOR) }')

-- A/P disengage paddle (bits 31/32)
wwpap3:CfgRpn(31, '(>K:AUTOPILOT_DISENGAGE_TOGGLE)')
wwpap3:CfgRpn(32, '(>K:AUTOPILOT_DISENGAGE_TOGGLE)')

-- Bank angle buttons 33..37: no GA standard binding, keep unbound

wwpap3:CfgRpn(38,
    "(A:AUTOPILOT VERTICAL HOLD, Bool) if{ (>K:AP_VS_VAR_DEC) (>H:AP_UP) }"
    .. " (A:AUTOPILOT FLIGHT LEVEL CHANGE, Bool) if{ (>K:AP_SPD_VAR_INC) }"
    .. " (A:AUTOPILOT PITCH HOLD, Bool) if{ (>K:AP_PITCH_REF_INC_DN) }",
    "") -- VS DEC
wwpap3:CfgRpn(39,
    "(A:AUTOPILOT VERTICAL HOLD, Bool) if{ (>K:AP_VS_VAR_INC) (>H:AP_DN) }"
    .. " (A:AUTOPILOT FLIGHT LEVEL CHANGE, Bool) if{ (>K:AP_SPD_VAR_DEC) }"
    .. " (A:AUTOPILOT PITCH HOLD, Bool) if{ (>K:AP_PITCH_REF_INC_UP) }",
    "") -- VS INC

-- A/T ARM ON/OFF (bits 40/41)
wwpap3:CfgRpn(40, '(A:AUTOTHROTTLE ACTIVE, Bool) ! if{ (>K:AUTOPILOT_AUTOTHROTTLE_TOGGLE) }')
wwpap3:CfgRpn(41, '(A:AUTOTHROTTLE ACTIVE, Bool) if{ (>K:AUTOPILOT_AUTOTHROTTLE_TOGGLE) }')

-------------------- Output LEDs (sources from QMCP737C GA) ---------------------
wwpap3:GetN1('(A:AUTOTHROTTLE ACTIVE,Bool)')
wwpap3:GetSpeed('(A:AUTOTHROTTLE ACTIVE,Bool)')
wwpap3:GetVnav('(A:AUTOPILOT VERTICAL HOLD, Bool)')
wwpap3:GetLvlChg('(A:AUTOPILOT FLIGHT LEVEL CHANGE, bool)')
wwpap3:GetHdgSel('(A:AUTOPILOT HEADING LOCK,Bool)')
wwpap3:GetLnav('(L:AP_LNAV_ARMED)')
wwpap3:GetVorLoc('(A:AUTOPILOT NAV1 LOCK,Bool)')
wwpap3:GetApp('(A:AUTOPILOT APPROACH HOLD,Bool)')
wwpap3:GetAltHld('(A:AUTOPILOT ALTITUDE LOCK, Bool)')
wwpap3:GetVs('(A:AUTOPILOT VERTICAL HOLD, Bool)')
wwpap3:GetCmdA('(A:AUTOPILOT MASTER, Bool)')
wwpap3:GetCwsA('0')
wwpap3:GetCmdB('(A:AUTOPILOT MASTER, Bool)')
wwpap3:GetCwsB('0')
wwpap3:GetAtArm('(A:AUTOTHROTTLE ACTIVE,Bool)')
wwpap3:GetMaCapt('(A:AUTOPILOT FLIGHT DIRECTOR ACTIVE:1, Bool)')
wwpap3:GetMaFo('(A:AUTOPILOT FLIGHT DIRECTOR ACTIVE:2, Bool)')
wwpap3:GetAtSol('(A:AUTOTHROTTLE ACTIVE,Bool)')

--====backlight
wwpap3:GetBkl('(A:LIGHT POTENTIOMETER:3, Percent)', 1)
wwpap3:GetLcdBkl('(A:LIGHT POTENTIOMETER:3, Percent)', 1)
wwpap3:GetLedBkl('(A:LIGHT POTENTIOMETER:3, Percent)', 1)

--==== LCD data
local dr_avionics = iDataRef:New('(A:CIRCUIT AVIONICS ON,Bool)')
local dr_spd = iDataRef:New('(A:AUTOPILOT AIRSPEED HOLD VAR, knot)')
local dr_is_mach = iDataRef:New('(A:AUTOPILOT MANAGED SPEED IN MACH,Bool)')
local dr_hdg = iDataRef:New('(A:AUTOPILOT HEADING LOCK DIR,Degrees)')
local dr_alt = iDataRef:New('(A:AUTOPILOT ALTITUDE LOCK VAR,Feet)')
local dr_vs = iDataRef:New('(A:AUTOPILOT VERTICAL HOLD VAR,Feet/minute)')
local dr_vs_show = iDataRef:New('(A:AUTOPILOT VERTICAL HOLD,Bool)')
local dr_crs_l = iDataRef:New('(A:NAV OBS:1,Degrees)')
local dr_crs_r = iDataRef:New('(A:NAV OBS:2,Degrees)')

local wwpap3_was_powered = false

GlobalFrameLoopManager:add(function()
    local hasPower = dr_avionics:Get() ~= 0

    if not hasPower then
        -- power-loss: blackout once
        if wwpap3_was_powered then
            wwpap3_was_powered = false
            wwpap3:Setleds(0, 0)
            wwpap3:setMcpDisplay({ displayEnabled = false, displayTest = false })
        end
        return
    end

    if not wwpap3_was_powered then
        wwpap3_was_powered = true
        wwpap3:FreshBits()
    end

    -- backlight
    wwpap3:SetBkl()
    wwpap3:SetLcdBkl()
    wwpap3:SetLedBkl()

    -- Update LED indicators (panel internal change detection)
    wwpap3:SetN1()
    wwpap3:SetSpeed()
    wwpap3:SetVnav()
    wwpap3:SetLvlChg()
    wwpap3:SetHdgSel()
    wwpap3:SetLnav()
    wwpap3:SetVorLoc()
    wwpap3:SetApp()
    wwpap3:SetAltHld()
    wwpap3:SetVs()
    wwpap3:SetCmdA()
    wwpap3:SetCwsA()
    wwpap3:SetCmdB()
    wwpap3:SetCwsB()
    wwpap3:SetAtArm()
    wwpap3:SetMaCapt()
    wwpap3:SetMaFo()
    wwpap3:SetAtSol()

    -- LCD update (class internal change detection)
    local spd = dr_spd:Get() or 0
    local vs = dr_vs:Get()

    wwpap3:setMcpDisplay({
        displayEnabled = true,
        displayTest = false,
        showLabels = false,
        showCourse = true,
        speed = spd,
        spdMach = dr_is_mach:Get() ~= 0,
        speedVisible = true,
        heading = dr_hdg:Get(),
        headingVisible = true,
        altitude = dr_alt:Get(),
        altitudeVisible = true,
        verticalSpeed = vs,
        verticalSpeedVisible = (dr_vs_show:Get() ~= 0 and vs ~= 0),
        crsCapt = dr_crs_l:Get(),
        crsFo = dr_crs_r:Get(),
        digitA = false,
        digitB = false,
    })
end)
