-- *****************************************************************
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-05-11_08_43_45UTC
-- *****************************************************************

-- Do not remove below lines: hardware detection
local wfdap500 = com.sim.qm.Wingflex.Wfdap500:new()
if not wfdap500:Init() then
	return
end
-- Do not remove above lines: hardware detection

uluaLog('wingflex DAP 500 for GA')

--INPUT key bindings

wfdap500:CfgEncFull(0, 1, 'sim/cockpit/autopilot/heading_mag', 1, 10, 0, 0, 360)
wfdap500:CfgCmd(2, 'sim/autopilot/heading_sync')

wfdap500:CfgCmd(3, 'sim/autopilot/nose_down')
wfdap500:CfgCmd(4, 'sim/autopilot/nose_up')

wfdap500:CfgEncFull(5, 6, 'sim/cockpit/autopilot/altitude', 100, 500, 0, 0, 360)
-- ALT push
wfdap500:CfgCmd(7, 'sim/none/none')

wfdap500:CfgCmd(8, 'sim/autopilot/heading')
wfdap500:CfgCmd(9, 'sim/autopilot/approach')
wfdap500:CfgCmd(10, 'sim/autopilot/NAV')

-- TRK
wfdap500:CfgCmd(11, 'sim/none/none')

wfdap500:CfgCmd(12, 'sim/autopilot/servos_toggle')
wfdap500:CfgCmd(13, 'sim/autopilot/fdir_toggle')
wfdap500:CfgCmd(14, 'sim/autopilot/level_change')
wfdap500:CfgCmd(15, 'sim/systems/yaw_damper_toggle')
--IAS
wfdap500:CfgCmd(16, 'sim/none/none')
--VNAV
wfdap500:CfgCmd(17, 'sim/autopilot/vnav')
--VS
wfdap500:CfgCmd(18, 'sim/autopilot/vertical_speed')
wfdap500:CfgCmd(19, 'sim/autopilot/altitude_hold')

-- OUTPUT data

wfdap500:GetApr('sim/cockpit2/autopilot/approach_status')
wfdap500:GetNav('sim/cockpit2/autopilot/nav_status')
wfdap500:GetTrk('cpuwolf/flyluaio/WfDap500/condbtn[0]')
wfdap500:GetHdg('sim/cockpit2/autopilot/heading_status')
wfdap500:GetAp('sim/cockpit2/autopilot/servos_on')
wfdap500:GetFd('sim/cockpit2/autopilot/flight_director_mode')
wfdap500:GetLvl('sim/cockpit2/autopilot/speed_status')
wfdap500:GetYd('sim/cockpit/switches/yaw_damper_on')
wfdap500:GetIas('sim/cockpit2/autopilot/speed_status')
wfdap500:GetVnav('sim/cockpit2/autopilot/vnav_status')
wfdap500:GetVs('sim/cockpit2/autopilot/vvi_status')
wfdap500:GetAlt('sim/cockpit2/autopilot/altitude_hold_status')

-- backlight
wfdap500:GetBkl('sim/cockpit/electrical/cockpit_lights', 250)

GlobalFrameLoopManager:add(function()
	wfdap500:SetLeds()
	--set backlight
	wfdap500:SetBkl()
end)
