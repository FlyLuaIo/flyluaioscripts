-- *****************************************************************
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-04-23
-- *****************************************************************
if uluaFind("(A:CIRCUIT AVIONICS ON,Bool)") == nil then
	return
end

-- Do not remove below lines: hardware detection
local wffcuc = com.sim.wf.Wffcuc:new()
if not wffcuc:Init() then
	return
end
-- Do not remove above lines: hardware detection

uluaLog('Wffcuc for GA')

wffcuc:CfgRpnAxis(1,
	"(A:AUTOPILOT VERTICAL HOLD, Bool) if{ (>K:AP_VS_VAR_DEC) (>H:AP_UP) } (A:AUTOPILOT FLIGHT LEVEL CHANGE, Bool) if{ (>K:AP_SPD_VAR_INC) } (A:AUTOPILOT PITCH HOLD, Bool) if{ (>K:AP_PITCH_REF_INC_DN) }",
	"(A:AUTOPILOT VERTICAL HOLD, Bool) if{ (>K:AP_VS_VAR_INC) (>H:AP_DN) } (A:AUTOPILOT FLIGHT LEVEL CHANGE, Bool) if{ (>K:AP_SPD_VAR_DEC) } (A:AUTOPILOT PITCH HOLD, Bool) if{ (>K:AP_PITCH_REF_INC_UP) }")
wffcuc:CfgRpnAxis(2, '100 (>K:AP_ALT_VAR_DEC)', '100 (>K:AP_ALT_VAR_INC)')
wffcuc:CfgRpnAxis(3, '(>K:HEADING_BUG_DEC)', '(>K:HEADING_BUG_INC)')
--[[
wffcuc:CfgRpn(21, '(>K:HEADING_BUG_DEC)')
wffcuc:CfgRpn(22, '(>K:HEADING_BUG_INC)')
wffcuc:CfgRpn(23, '100 (>K:AP_ALT_VAR_DEC)')
wffcuc:CfgRpn(24, '100 (>K:AP_ALT_VAR_INC)')
wffcuc:CfgRpn(25,
	"(A:AUTOPILOT VERTICAL HOLD, Bool) if{ (>K:AP_VS_VAR_DEC) (>H:AP_UP) } (A:AUTOPILOT FLIGHT LEVEL CHANGE, Bool) if{ (>K:AP_SPD_VAR_INC) } (A:AUTOPILOT PITCH HOLD, Bool) if{ (>K:AP_PITCH_REF_INC_DN) }")
wffcuc:CfgRpn(26,
	"(A:AUTOPILOT VERTICAL HOLD, Bool) if{ (>K:AP_VS_VAR_INC) (>H:AP_DN) } (A:AUTOPILOT FLIGHT LEVEL CHANGE, Bool) if{ (>K:AP_SPD_VAR_DEC) } (A:AUTOPILOT PITCH HOLD, Bool) if{ (>K:AP_PITCH_REF_INC_UP) }")
]]--
	
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



GlobalFrameLoopManager:add(function()
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
	wffcuc:LoopAxis(1)
	wffcuc:LoopAxis(2)
	wffcuc:LoopAxis(3)
	wffcuc:LoopAxis(4)
end)
