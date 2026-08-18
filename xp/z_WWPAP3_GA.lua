-- *****************************************************************
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-08-08_03_55_08UTC
-- *****************************************************************

-- Do not remove below lines: hardware detection
local wwpap3 = com.sim.qm.Wwpap3.Open()
if not wwpap3 then return end
-- Do not remove above lines: hardware detection

uluaLog('Wwpap3 for GA')

-------------------- Input Keys Binding (X-Plane common GA) --------------------
-- Mode buttons (bits 0..16)
wwpap3:CfgCmd(0, 'sim/autopilot/n1_hold')        -- N1
wwpap3:CfgCmd(1, 'sim/autopilot/airspeed_hold')  -- SPEED
wwpap3:CfgCmd(2, 'sim/autopilot/level_change')   -- VNAV (share LVL CHG)
wwpap3:CfgCmd(3, 'sim/autopilot/level_change')   -- LVL CHG
wwpap3:CfgCmd(4, 'sim/autopilot/heading_hold')   -- HDG SEL
wwpap3:CfgCmd(5, 'sim/autopilot/nav_hold')       -- LNAV
wwpap3:CfgCmd(6, 'sim/autopilot/nav_hold')       -- VOR LOC
wwpap3:CfgCmd(7, 'sim/autopilot/approach')       -- APP
wwpap3:CfgCmd(8, 'sim/autopilot/altitude_hold')  -- ALT HOLD
wwpap3:CfgCmd(9, 'sim/autopilot/vertical_speed') -- V/S
wwpap3:CfgCmd(10, 'sim/autopilot/servos_toggle') -- CMD A
wwpap3:CfgCmd(11, 'sim/none/none')               -- CWS A (no GA standard)
wwpap3:CfgCmd(12, 'sim/autopilot/servos_toggle') -- CMD B
wwpap3:CfgCmd(13, 'sim/none/none')               -- CWS B (no GA standard)
wwpap3:CfgCmd(14, 'sim/none/none')               -- C/O (no GA standard)
wwpap3:CfgCmd(15, 'sim/none/none')               -- SPD INTV (no GA standard)
wwpap3:CfgCmd(16, 'sim/none/none')               -- ALT INTV (no GA standard)

-- Encoders as button pairs (DEC/INC)
wwpap3:CfgCmd(17, 'sim/radios/obs1_down')        -- L CRS DEC
wwpap3:CfgCmd(18, 'sim/radios/obs1_up')          -- L CRS INC
wwpap3:CfgCmd(19, 'sim/autopilot/airspeed_down') -- SPD DEC
wwpap3:CfgCmd(20, 'sim/autopilot/airspeed_up')   -- SPD INC
wwpap3:CfgCmd(21, 'sim/autopilot/heading_down')  -- HDG DEC
wwpap3:CfgCmd(22, 'sim/autopilot/heading_up')    -- HDG INC
wwpap3:CfgCmd(23, 'sim/autopilot/altitude_down') -- ALT DEC
wwpap3:CfgCmd(24, 'sim/autopilot/altitude_up')   -- ALT INC
wwpap3:CfgCmd(25, 'sim/radios/obs2_down')        -- R CRS DEC
wwpap3:CfgCmd(26, 'sim/radios/obs2_up')          -- R CRS INC

-- FD Capt / FO toggle (bits 27..30)
wwpap3:CfgCmd(27, 'sim/autopilot/flight_director_toggle') -- FD Capt ON
wwpap3:CfgCmd(28, 'sim/autopilot/flight_director_toggle') -- FD Capt OFF
wwpap3:CfgCmd(29, 'sim/autopilot/flight_director_toggle') -- FD Fo ON
wwpap3:CfgCmd(30, 'sim/autopilot/flight_director_toggle') -- FD Fo OFF

-- A/P disengage paddle (bits 31/32)
wwpap3:CfgCmd(31, 'sim/autopilot/servos_off_any')
wwpap3:CfgCmd(32, 'sim/autopilot/servos_off_any')

-- Bank angle buttons 33..37: no GA standard binding, keep unbound

-- VS wheel (bits 38/39)
wwpap3:CfgCmd(38, 'sim/autopilot/vertical_speed_down') -- VS DEC
wwpap3:CfgCmd(39, 'sim/autopilot/vertical_speed_up')   -- VS INC

-- A/T ARM ON/OFF (bits 40/41)
wwpap3:CfgCmd(40, 'sim/autopilot/autothrottle_toggle')
wwpap3:CfgCmd(41, 'sim/autopilot/autothrottle_toggle')

-------------------- Output LEDs (sources from QMCP737C GA) ---------------------
wwpap3:GetN1('sim/cockpit2/autopilot/TOGA_status')
wwpap3:GetSpeed('sim/cockpit2/autopilot/speed_status')
wwpap3:GetVnav('sim/cockpit2/autopilot/vnav_status')
wwpap3:GetLvlChg('sim/cockpit2/autopilot/speed_status')
wwpap3:GetHdgSel('sim/cockpit2/autopilot/heading_status')
wwpap3:GetLnav('sim/cockpit2/autopilot/nav_status')
wwpap3:GetVorLoc('sim/cockpit2/autopilot/nav_status')
wwpap3:GetApp('sim/cockpit2/autopilot/approach_status')
wwpap3:GetAltHld('sim/cockpit2/autopilot/altitude_hold_status')
wwpap3:GetVs('sim/cockpit2/autopilot/vvi_status')
wwpap3:GetCmdA('sim/cockpit2/autopilot/servos_on')
wwpap3:GetCwsA('sim/cockpit2/autopilot/servos_on')
wwpap3:GetCmdB('sim/cockpit2/autopilot/servos_on')
wwpap3:GetCwsB('sim/cockpit2/autopilot/servos_on')
wwpap3:GetAtArm('sim/cockpit2/autopilot/autothrottle_on')
wwpap3:GetMaCapt('sim/cockpit2/autopilot/flight_director_mode')
wwpap3:GetMaFo('sim/cockpit2/autopilot/flight_director_mode')
wwpap3:GetAtSol('sim/cockpit2/autopilot/autothrottle_on')

--====backlight
wwpap3:GetBkl('sim/cockpit/electrical/cockpit_lights', 255)
wwpap3:GetLcdBkl('sim/cockpit/electrical/cockpit_lights', 255)
wwpap3:GetLedBkl('sim/cockpit/electrical/cockpit_lights', 255)

--==== LCD data
local dr_avionics = iDataRef:New('sim/cockpit/electrical/avionics_on')
local dr_spd = iDataRef:New('sim/cockpit2/autopilot/airspeed_dial_kts_mach')
local dr_is_mach = iDataRef:New('sim/cockpit/autopilot/airspeed_is_mach')
local dr_hdg = iDataRef:New('sim/cockpit/autopilot/heading_mag')
local dr_alt = iDataRef:New('sim/cockpit2/autopilot/altitude_dial_ft')
local dr_vs = iDataRef:New('sim/cockpit2/autopilot/vvi_dial_fpm')
local dr_vs_show = iDataRef:New('sim/cockpit2/autopilot/vvi_status')
local dr_crs_l = iDataRef:New('sim/cockpit/radios/nav1_obs_degm')
local dr_crs_r = iDataRef:New('sim/cockpit/radios/nav2_obs_degm')

local ch_power = iChange:New(false)

GlobalFrameLoopManager:add(function()
    -- local hasPower = dr_avionics:Get() ~= 0

    -- if ch_power:ChangedUpdate(hasPower) then
    --     if hasPower then
    --         wwpap3:FreshBits()
    --     else
    --         -- power-loss: blackout
    --         wwpap3:Setleds(0, 0)
    --         wwpap3:setMcpDisplay({ displayEnabled = false, displayTest = false })
    --         return
    --     end
    -- end
    -- if not hasPower then
    --     return
    -- end

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
    local vs = dr_vs:Get() or 0

    wwpap3:setMcpDisplay({
        displayEnabled = true,
        displayTest = false,
        showLabels = false,
        showCourse = true,
        speed = spd,
        spdMach = dr_is_mach:Get() ~= 0,
        speedVisible = true,
        heading = dr_hdg:Get() or 0,
        headingVisible = true,
        altitude = dr_alt:Get() or 0,
        altitudeVisible = true,
        verticalSpeed = vs,
        verticalSpeedVisible = (dr_vs_show:Get() or 0) ~= 0,
        crsCapt = dr_crs_l:Get() or 0,
        crsFo = dr_crs_r:Get() or 0,
        digitA = false,
        digitB = false,
    })
end)
