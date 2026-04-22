
-- *****************************************************************
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-04-22_10_09_50UTC
-- *****************************************************************

-- Do not remove below lines: hardware detection
local wffcuc = com.sim.qm.Wffcuc:new()
if not wffcuc:Init() then
	return
end
-- Do not remove above lines: hardware detection

uluaLog('Wffcuc for GA')

-- LCD display
wffcuc:GetSpd('sim/cockpit2/autopilot/airspeed_dial_kts_mach')
wffcuc:GetHdg('sim/cockpit/autopilot/heading_mag')
wffcuc:GetAlt('sim/cockpit/autopilot/altitude')
wffcuc:GetVs('sim/cockpit/autopilot/vertical_velocity')

-- brightness
wffcuc:GetBkl("sim/cockpit/electrical/cockpit_lights", 200) -- 0~1
wffcuc:GetLcdBkl('sim/cockpit/electrical/cockpit_lights', 250)

-- LEDs
wffcuc:GetLoc('sim/cockpit2/autopilot/nav_status')
wffcuc:GetAp1('sim/cockpit2/autopilot/servos_on')
wffcuc:GetAp2('sim/cockpit2/autopilot/servos_on')
wffcuc:GetAthr('sim/cockpit2/autopilot/autothrottle_on')
wffcuc:GetExped('sim/cockpit2/autopilot/altitude_hold_status')
wffcuc:GetAppr('sim/cockpit2/autopilot/approach_status')
wffcuc:GetSpdmang('cpuwolf/flyluaio/WfFcuc/condbtn[1]')
wffcuc:GetSpddash('cpuwolf/flyluaio/WfFcuc/condbtn[1]')
wffcuc:GetHdgmang('cpuwolf/flyluaio/WfFcuc/condbtn[1]')
wffcuc:GetHdgdash('cpuwolf/flyluaio/WfFcuc/condbtn[1]')
wffcuc:GetAltmang('cpuwolf/flyluaio/WfFcuc/condbtn[1]')
wffcuc:GetVsdash('cpuwolf/flyluaio/WfFcuc/condbtn[1]')
wffcuc:GetSpdmach('cpuwolf/flyluaio/WfFcuc/condbtn[1]')
wffcuc:GetHdgtrk('cpuwolf/flyluaio/WfFcuc/condbtn[1]')
wffcuc:GetTest('sim/cockpit/warnings/annunciator_test_pressed')
wffcuc:GetPower('sim/cockpit2/switches/avionics_power_on')



function Wffcuc_GA_Loop_Upd()
	wffcuc:SetLeds()
	wffcuc:SetTest()
	wffcuc:SetPower()
	-- LCD display
	wffcuc:SetSpd()
	wffcuc:SetHdg()
	wffcuc:SetAlt()
	wffcuc:SetVs()
	-- backlight
	wffcuc:SetBkl()
	wffcuc:SetLcdBkl()
	--force refresh
	wffcuc:ForceFresh()
end
uluaAddDoLoop('Wffcuc_GA_Loop_Upd()')
