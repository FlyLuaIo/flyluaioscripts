
-- *****************************************************************
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-03-26_07_27_59UTC
-- *****************************************************************

-- Do not remove below lines: hardware detection
local stkmulti = com.sim.qm.Stkmulti:new()
if not stkmulti:Init() then
	return
end
-- Do not remove above lines: hardware detection

uluaLog("Stkmulti for GA")

stkmulti:GetAp('sim/cockpit2/autopilot/servos_on')
stkmulti:GetHdg('sim/cockpit2/autopilot/heading_status')
stkmulti:GetNav('sim/cockpit2/autopilot/nav_status')
stkmulti:GetIas('sim/cockpit2/autopilot/speed_status')
stkmulti:GetAlt('sim/cockpit2/autopilot/altitude_hold_status')
stkmulti:GetVs('sim/cockpit2/autopilot/vvi_status')
stkmulti:GetApr('sim/cockpit2/autopilot/approach_status')
stkmulti:GetRev('sim/cockpit/autopilot/backcourse_on')


function Stkmulti_GA_Loop_Upd()
	stkmulti:SetLeds()
end
uluaAddDoLoop("Stkmulti_GA_Loop_Upd()")
