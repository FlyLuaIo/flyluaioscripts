-- *****************************************************************
-- WwPap3 for FF777 V2 (ported from WINCTRL ff777-pap3-mcp-profile)
-- *****************************************************************

if ilua_require_ff777(true) then return end

-- Do not remove below lines: hardware detection
local wwpap3 = com.sim.qm.Wwpap3.Open()
if not wwpap3 then return end
-- Do not remove above lines: hardware detection

uluaLog('Wwpap3 for FF777 V2')

-- FF777 SASL may not be ready at first load. Same pair of datarefs the
-- WINCTRL profile uses in IsEligible().
if uluaFind("1-sim/ckpt/mcpApLButton/anim") == nil
    or uluaFind("1-sim/output/mcp/ok") == nil then
    ilua_req_reload()
    return
end

-------------------- Input Keys Binding ---------------------
-- Mode buttons (buttonDefs, EXECUTE_CMD_ONCE)
wwpap3:CfgCmd(0, '1-sim/command/mcpClbButton_button')   -- CLB (THR REF) / N1
wwpap3:CfgCmd(1, '1-sim/command/mcpAtButton_button')    -- SPEED
wwpap3:CfgCmd(2, '1-sim/command/mcpVnavButton_button')  -- VNAV
wwpap3:CfgCmd(3, '1-sim/command/mcpFlchButton_button')  -- FLCH (LVL CHG)
wwpap3:CfgCmd(4, '1-sim/command/mcpHdgCelButton_button')-- HDG SEL
wwpap3:CfgCmd(5, '1-sim/command/mcpLnavButton_button')  -- LNAV
wwpap3:CfgCmd(6, '1-sim/command/mcpLocButton_button')   -- LOC (VORLOC)
wwpap3:CfgCmd(7, '1-sim/command/mcpAppButton_button')   -- APP
wwpap3:CfgCmd(8, '1-sim/command/mcpAltHoldButton_button')-- ALT HOLD
wwpap3:CfgCmd(9, '1-sim/command/mcpVsButton_button')    -- V/S
wwpap3:CfgCmd(10, '1-sim/command/mcpApLButton_button')  -- CMD A
wwpap3:CfgCmd(11, '1-sim/command/mcpApLButton_button')  -- CWS A (no separate CWS on FF777)
wwpap3:CfgCmd(12, '1-sim/command/mcpApRButton_button')  -- CMD B
wwpap3:CfgCmd(13, '1-sim/command/mcpApRButton_button')  -- CWS B (no separate CWS on FF777)
wwpap3:CfgCmd(14, '1-sim/command/mcpIasMachButton_button') -- C/O (IAS/MACH)
wwpap3:CfgCmd(15, '1-sim/command/mcpSpdRotary_push')    -- SPD INTV
wwpap3:CfgCmd(16, '1-sim/command/mcpAltRotary_push')    -- ALT INTV

-- Encoders as button pairs. FF777 has no CRS on the MCP (it's on the EFIS
-- panel), so keys 17/18 and 25/26 stay unbound.
wwpap3:CfgCmd(19, '1-sim/command/mcpSpdRotary_rotary-') -- SPD DEC
wwpap3:CfgCmd(20, '1-sim/command/mcpSpdRotary_rotary+') -- SPD INC
wwpap3:CfgCmd(21, '1-sim/command/mcpHdgRotary_rotary-') -- HDG DEC
wwpap3:CfgCmd(22, '1-sim/command/mcpHdgRotary_rotary+') -- HDG INC
wwpap3:CfgCmd(23, '1-sim/command/mcpAltRotary_rotary-') -- ALT DEC
wwpap3:CfgCmd(24, '1-sim/command/mcpAltRotary_rotary+') -- ALT INC
wwpap3:CfgCmd(38, '1-sim/command/mcpVsRotary_rotary-')  -- VS DEC
wwpap3:CfgCmd(39, '1-sim/command/mcpVsRotary_rotary+')  -- VS INC

-- Maintained switches (WINCTRL handleSwitchChanged; hardware key indices per
-- product-pap3-mcp.cpp switchDefs). Position switches fire the _trigger
-- command until the anim dataref matches the hardware position (maybeToggle).
-- FD CAPT (byte 0x04 bit 0x08 -> key 27, pressed = ON)
local pswh_fdl = QmdevPosSwitchInit("1-sim/ckpt/mcpFdLSwitch/anim", 1,
    "1-sim/command/mcpFdLSwitch_trigger", "1-sim/command/mcpFdLSwitch_trigger", 300)
wwpap3:CfgPSw(27, pswh_fdl, 1, 0)
-- FD FO (byte 0x04 bit 0x20 -> key 29, pressed = ON)
local pswh_fdr = QmdevPosSwitchInit("1-sim/ckpt/mcpFdRSwitch/anim", 1,
    "1-sim/command/mcpFdRSwitch_trigger", "1-sim/command/mcpFdRSwitch_trigger", 300)
wwpap3:CfgPSw(29, pswh_fdr, 1, 0)

-- AP DISC (byte 0x04 bit 0x80 = UP line, inverted -> key 31). WINCTRL only
-- handles this line to avoid double-toggling through both lines.
local pswh_apdisc = QmdevPosSwitchInit("1-sim/ckpt/mcpApDiscSwitch/anim", 1,
    "1-sim/command/mcpApDiscSwitch_trigger", "1-sim/command/mcpApDiscSwitch_trigger", 500)
-- pressed (bar down) -> disengaged, released -> engaged
wwpap3:CfgPSw(31, pswh_apdisc, 0, 1)

-- A/T ARM (byte 0x06 bit 0x01 ARMED / bit 0x02 DISARMED -> keys 40/41).
-- WINCTRL toggles BOTH left and right switch datarefs on each line; the
-- solenoid LED follows the arm state.
local psw_at_l = QmdevPosSwitchInit("1-sim/ckpt/mcpAtSwitchL/anim", 1,
    "1-sim/command/mcpAtSwitchL_trigger", "1-sim/command/mcpAtSwitchL_trigger", 500)
local psw_at_r = QmdevPosSwitchInit("1-sim/ckpt/mcpAtSwitchR/anim", 1,
    "1-sim/command/mcpAtSwitchR_trigger", "1-sim/command/mcpAtSwitchR_trigger", 500)
function wwpap3_ff777_at(arm)
    wwpap3:PSwDelay(psw_at_l, 0, arm)
    wwpap3:PSwDelay(psw_at_r, 50, arm)
    wwpap3:SetAtSol(0, arm)
end
wwpap3:CfgFc(40, 'wwpap3_ff777_at(1)') -- ARMED
wwpap3:CfgFc(41, 'wwpap3_ff777_at(0)') -- DISARMED

-- Bank angle: 5-position rotary (byte 0x05 bits 0x02..0x20 -> keys 33..37).
-- FF777 indices: 0=AUTO 1=5 2=10 4=20 5=25 (hardware skips 15°).
wwpap3:CfgCmd(33, '1-sim/command/mcpBankAngleSwitch_set_0') -- AUTO
wwpap3:CfgCmd(34, '1-sim/command/mcpBankAngleSwitch_set_1') -- 5°
wwpap3:CfgCmd(35, '1-sim/command/mcpBankAngleSwitch_set_2') -- 10°
wwpap3:CfgCmd(36, '1-sim/command/mcpBankAngleSwitch_set_4') -- 20°
wwpap3:CfgCmd(37, '1-sim/command/mcpBankAngleSwitch_set_5') -- 25°

-------------------- Output LEDs ---------------------
-- FF777 lamp glow datarefs, threshold > 0.5 (WINCTRL: status > 0.5 -> ON).
-- The FF777 profile does not monitor N1/SPEED/HDG SEL/CWS*/CMD B/MA*: those
-- LEDs stay unbound (off).
wwpap3:GetVnav('1-sim/ckpt/lampsGlow/mcpVNAV', nil, 0.5)
wwpap3:GetLvlChg('1-sim/ckpt/lampsGlow/mcpFLCH', nil, 0.5)
wwpap3:GetLnav('1-sim/ckpt/lampsGlow/mcpLNAV', nil, 0.5)
wwpap3:GetVorLoc('1-sim/ckpt/lampsGlow/mcpLOC', nil, 0.5)
wwpap3:GetApp('1-sim/ckpt/lampsGlow/mcpAPP', nil, 0.5)
wwpap3:GetAltHld('1-sim/ckpt/lampsGlow/mcpAltHOLD', nil, 0.5)
wwpap3:GetVs('1-sim/ckpt/lampsGlow/mcpVS', nil, 0.5)
wwpap3:GetCmdA('1-sim/ckpt/lampsGlow/mcpCaptAP', nil, 0.5)
wwpap3:GetAtArm('1-sim/ckpt/lampsGlow/mcpAT', nil, 0.5)

--====backlight (WINCTRL: BACKLIGHT = glareshield*255, LED overall >= 0.6)
wwpap3:GetBkl('1-sim/ckpt/lights/glareshield', 255)
-- LED_BKL: WINCTRL floor is max(ratio*255, 153); the Wwpap3 driver auto path
-- floors at 100 (explicit path is broken for >= 100, see driver SetLedBkl).
wwpap3:GetLedBkl('1-sim/ckpt/lights/glareshield', 255)
-- LCD_BKL: WINCTRL keeps it constant 180 while powered, sent once on power-on.

-------------------- LCD ---------------------
local dr_power     = iDataRef:New('1-sim/output/mcp/ok')
local dr_disp_power = iDataRef:New('sim/cockpit2/autopilot/autopilot_has_power')
local dr_spd       = iDataRef:New('1-sim/output/mcp/spd')
local dr_hdg       = iDataRef:New('1-sim/output/mcp/hdg')
local dr_alt       = iDataRef:New('1-sim/output/mcp/alt')
local dr_vs        = iDataRef:New('1-sim/output/mcp/vs')
local dr_spd_open  = iDataRef:New('1-sim/output/mcp/isSpdOpen')
local dr_vs_open   = iDataRef:New('1-sim/output/mcp/isVsOpen')
local dr_mach_trg  = iDataRef:New('1-sim/output/mcp/isMachTrg')
-- Reference only: 777 has no CRS window (showCourse = false), WINCTRL reads
-- these "for reference".
local dr_crs_c     = iDataRef:New('sim/cockpit/radios/nav1_obs_degm')
local dr_crs_f     = iDataRef:New('sim/cockpit/radios/nav2_obs_degm')

GlobalFrameLoopManager:add(function()
    local hasPower

    -- power edge: falling edge goes dark once (zero traffic while off);
    -- rising edge resyncs dimming and LED bits
    if dr_power:ChangedUpdate() then
        hasPower = dr_power:GetOld() ~= 0
        if not hasPower then
            wwpap3:SetBkl(0, 0)
            wwpap3:SetLcdBkl(0, 0)
            wwpap3:SetLedBkl(0, 0)
            wwpap3:setMcpDisplay({ displayEnabled = false })
            return
        end
        wwpap3:SetLcdBkl(0, 180) -- constant LCD backlight while powered
        wwpap3:FreshBkls()
        wwpap3:FreshBits()
    else
        hasPower = dr_power:Get()
    end
    if not hasPower then return end

    wwpap3:SetBkl()
    wwpap3:SetLedBkl()

    wwpap3:SetVnav()
    wwpap3:SetLvlChg()
    wwpap3:SetLnav()
    wwpap3:SetVorLoc()
    wwpap3:SetApp()
    wwpap3:SetAltHld()
    wwpap3:SetVs()
    wwpap3:SetCmdA()
    wwpap3:SetAtArm()

    -- LCD (WINCTRL ff777-pap3-mcp-profile::updateDisplayData)
    wwpap3:setMcpDisplay({
        displayEnabled = dr_disp_power:Get() ~= 0,
        displayTest = false,
        showLabels = true,              -- FF777 MCP has labels on display
        showDashesWhenInactive = false,
        showLabelsWhenInactive = true,  -- labels stay lit when window inactive
        showCourse = false,             -- course lives on the EFIS panel
        speed = dr_spd:Get(),
        spdMach = dr_mach_trg:Get() ~= 0, -- MACH flag: .XX rendering
        machDigits = 2,
        speedVisible = dr_spd_open:Get() ~= 0,
        heading = dr_hdg:Get(),
        headingVisible = true,
        altitude = dr_alt:Get(),
        altitudeVisible = true,
        verticalSpeed = dr_vs:Get(),
        verticalSpeedVisible = dr_vs_open:Get() ~= 0,
        crsCapt = dr_crs_c:Get(),
        crsFo = dr_crs_f:Get(),
        digitA = false,
        digitB = false,
    })
end)