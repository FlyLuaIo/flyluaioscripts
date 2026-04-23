
-- *****************************************************************
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-04-23
-- *****************************************************************
if uluaFind("(A:CIRCUIT AVIONICS ON,Bool)") == nil then
	return
end

-- Do not remove below lines: hardware detection
local wffcuc = com.sim.qm.Wffcuc:new()
if not wffcuc:Init() then
	return
end
-- Do not remove above lines: hardware detection

uluaLog('Wffcuc for GA')

-- LCD display
wffcuc:GetSpd('(A:AUTOPILOT AIRSPEED HOLD VAR, knot)')
wffcuc:GetHdg('(A:AUTOPILOT HEADING LOCK DIR,Degrees)')
wffcuc:GetAlt('(A:AUTOPILOT ALTITUDE LOCK VAR,Feet)')
wffcuc:GetVs('(A:AUTOPILOT VERTICAL HOLD VAR,Feet/minute)')

-- brightness
wffcuc:GetBkl("(A:LIGHT POTENTIOMETER:3, Percent)", 200) -- 0~1
wffcuc:GetLcdBkl('(A:LIGHT POTENTIOMETER:3, Percent)', 250)

-- LEDs
wffcuc:GetLoc('(A:AUTOPILOT NAV1 LOCK,Bool)')
wffcuc:GetAp1('(A:AUTOPILOT MASTER, Bool)')
wffcuc:GetAp2('(A:AUTOPILOT MASTER, Bool)')
wffcuc:GetAthr('(A:AUTOPILOT ALTITUDE LOCK, Bool)')
wffcuc:GetExped('(A:AUTOPILOT FLIGHT LEVEL CHANGE, bool)')
wffcuc:GetAppr('(A:AUTOPILOT APPROACH HOLD,Bool)')
wffcuc:GetSpdmang('cpuwolf/flyluaio/WfFcuc/condbtn[1]')
wffcuc:GetSpddash('cpuwolf/flyluaio/WfFcuc/condbtn[1]')
wffcuc:GetHdgmang('cpuwolf/flyluaio/WfFcuc/condbtn[1]')
wffcuc:GetHdgdash('cpuwolf/flyluaio/WfFcuc/condbtn[1]')
wffcuc:GetAltmang('cpuwolf/flyluaio/WfFcuc/condbtn[1]')
wffcuc:GetVsdash('cpuwolf/flyluaio/WfFcuc/condbtn[1]')
wffcuc:GetSpdmach('cpuwolf/flyluaio/WfFcuc/condbtn[1]')
wffcuc:GetHdgtrk('cpuwolf/flyluaio/WfFcuc/condbtn[1]')
wffcuc:GetTest('cpuwolf/flyluaio/WfFcuc/condbtn[1]')
wffcuc:GetPower('(A:CIRCUIT AVIONICS ON,Bool)')



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
