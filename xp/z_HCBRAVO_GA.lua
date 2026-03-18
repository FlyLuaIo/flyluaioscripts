--**********************Copyright***********************--
-- modified by Wei Shuai <cpuwolf@gmail.com>
-- 2026-03-12
local FastTurnsPerSecond = 4 --How many spins per second  is considered FAST?
--########################################################


-- Do not remove below lines: hardware detection
local hcbravo = com.sim.qm.Hcbravo:new()
if not hcbravo:Init() then
    return
end
-- Do not remove above lines: hardware detection
uluaLog('HCBravo for GA')

-- Input Key binding
hcbravo:CfgCmd(0, 'sim/autopilot/heading')

-- 13:DEC 12:INC
function hcbravo_mode_cfg_ias()
    hcbravo:CfgCmd(13, 'sim/autopilot/airspeed_down')
    hcbravo:CfgCmd(12, 'sim/autopilot/airspeed_up')
end
function hcbravo_mode_cfg_crs()
    hcbravo:CfgCmd(13, 'sim/radios/obs_HSI_down')
    hcbravo:CfgCmd(12, 'sim/radios/obs_HSI_up')
end
function hcbravo_mode_cfg_hdg()
    hcbravo:CfgCmd(13, 'sim/autopilot/heading_down')
    hcbravo:CfgCmd(12, 'sim/autopilot/heading_up')
end
function hcbravo_mode_cfg_vs()
    hcbravo:CfgCmd(13, 'sim/autopilot/vertical_speed_down')
    hcbravo:CfgCmd(12, 'sim/autopilot/vertical_speed_up')
end
function hcbravo_mode_cfg_alt()
    hcbravo:CfgCmd(13, 'sim/autopilot/altitude_down')
    hcbravo:CfgCmd(12, 'sim/autopilot/altitude_up')
end
-- 20:ALT 19:VS 18:HDG 17:CRS 16:IAS
hcbravo:CfgFc(16, 'hcbravo_mode_cfg_ias()')
hcbravo:CfgFc(17, 'hcbravo_mode_cfg_crs()')
hcbravo:CfgFc(18, 'hcbravo_mode_cfg_hdg()')
hcbravo:CfgFc(19, 'hcbravo_mode_cfg_vs()')
hcbravo:CfgFc(20, 'hcbravo_mode_cfg_alt()')

-- Output Led lights
hcbravo:GetHdg('sim/cockpit2/autopilot/heading_status')
hcbravo:GetNav('sim/cockpit2/autopilot/nav_status')
hcbravo:GetApr('sim/cockpit2/autopilot/approach_status')
hcbravo:GetRev('sim/cockpit/autopilot/backcourse_on')
hcbravo:GetAlt('sim/cockpit2/autopilot/altitude_hold_status')
hcbravo:GetVs('sim/cockpit2/autopilot/vvi_status')
hcbravo:GetIas('sim/cockpit2/autopilot/speed_status')
hcbravo:GetAutopilot('sim/cockpit2/autopilot/servos_on')
hcbravo:GetLeftgreen('sim/flightmodel2/gear/deploy_ratio[1]')
hcbravo:GetLeftred('sim/flightmodel2/gear/eagle_claw_angle_deg[1]')
hcbravo:GetCentergreen('sim/flightmodel2/gear/deploy_ratio[0]')
hcbravo:GetCenterred('sim/flightmodel2/gear/eagle_claw_angle_deg[0]')
hcbravo:GetRightgreen('sim/flightmodel2/gear/deploy_ratio[2]')
hcbravo:GetRightred('sim/flightmodel2/gear/eagle_claw_angle_deg[2]')
hcbravo:GetMasterwarn('sim/cockpit2/annunciators/master_warning')
hcbravo:GetEnginefire('sim/cockpit2/annunciators/engine_fire')
hcbravo:GetLowoil('sim/cockpit/warnings/annunciators/oil_pressure')
hcbravo:GetLowfuel('sim/cockpit2/annunciators/fuel_pressure')
hcbravo:GetAntiice('sim/cockpit2/ice/ice_prop_heat_on')
hcbravo:GetStarter('sim/flightmodel2/engines/starter_is_running[0]')
hcbravo:GetApu('sim/cockpit2/electrical/APU_running')
hcbravo:GetMastercaution('sim/cockpit2/annunciators/master_caution')
hcbravo:GetVacuum('sim/cockpit2/annunciators/low_vacuum')
hcbravo:GetLowhydpressure('sim/cockpit2/annunciators/hydraulic_pressure')
hcbravo:GetAuxfuelpump('sim/cockpit2/annunciators/fuel_pressure_low')
hcbravo:GetParkingbrake('sim/cockpit2/controls/parking_brake_ratio')
hcbravo:GetLowvolts('sim/cockpit2/annunciators/low_voltage')
hcbravo:GetDoor('sim/cockpit2/annunciators/cabin_door_open')

function HCBRAVO_GA_LED_UPD()
    hcbravo:SetLed()
end

uluaAddDoLoop('HCBRAVO_GA_LED_UPD()')
