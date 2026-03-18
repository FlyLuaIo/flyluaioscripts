--**********************Copyright***********************--
-- modified by Wei Shuai <cpuwolf@gmail.com>
-- 2026-03-12
local FastTurnsPerSecond = 30 --How many spins per second  is considered FAST?
--########################################################


-- Do not remove below lines: hardware detection
local hcbravo = com.sim.qm.Hcbravo:new()
if not hcbravo:Init() then
    return
end
-- Do not remove above lines: hardware detection
uluaLog("HCBravo for GA")

-- Input Key binding
hcbravo:CfgCmd(0, "sim/autopilot/heading")


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
hcbravo:GetStarter('sim/cockpit2/engine/actuators/starter_parallel_series')
hcbravo:GetApu('sim/cockpit2/electrical/APU_running')
hcbravo:GetMastercaution('sim/cockpit2/annunciators/master_caution')
hcbravo:GetVacuum('sim/cockpit2/annunciators/low_vacuum')
hcbravo:GetLowhydpressure('sim/cockpit2/annunciators/hydraulic_pressure')
hcbravo:GetAuxfuelpump('sim/cockpit2/annunciators/fuel_pressure_low')
hcbravo:GetParkingbrake('sim/cockpit2/controls/parking_brake_ratio')
hcbravo:GetLowvolts('sim/cockpit2/annunciators/low_voltage')
hcbravo:GetDoor('sim/cockpit2/switches/door_open_ratio[0]')

function HCBRAVO_GA_LED_UPD()
    hcbravo:SetLed()
end

uluaAddDoLoop("HCBRAVO_GA_LED_UPD()")
