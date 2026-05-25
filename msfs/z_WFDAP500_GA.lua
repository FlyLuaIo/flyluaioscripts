-- *****************************************************************
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-05-11_08_43_45UTC
-- *****************************************************************

-- Do not remove below lines: hardware detection
local wfdap500 = com.sim.wf.Wfdap500:new()
if not wfdap500:Init() then
	return
end
-- Do not remove above lines: hardware detection

uluaLog('wingflex DAP 500 for GA')

--INPUT key bindings

wfdap500:CfgRpn(0, '1 (>K:HEADING_BUG_DEC)')
wfdap500:CfgRpn(1, '1 (>K:HEADING_BUG_INC)')

wfdap500:CfgRpn(2, '(A:HEADING INDICATOR, degrees) (>K:HEADING_BUG_SET)')

wfdap500:CfgRpn(3,
	'(A:AUTOPILOT VERTICAL HOLD, Bool) if{ (>K:AP_VS_VAR_DEC) (>H:AP_UP) } (A:AUTOPILOT FLIGHT LEVEL CHANGE, Bool) if{ (>K:AP_SPD_VAR_INC) } (A:AUTOPILOT PITCH HOLD, Bool) if{ (>K:AP_PITCH_REF_INC_DN) }',
	'')
wfdap500:CfgRpn(4,
	'(A:AUTOPILOT VERTICAL HOLD, Bool) if{ (>K:AP_VS_VAR_INC) (>H:AP_DN) } (A:AUTOPILOT FLIGHT LEVEL CHANGE, Bool) if{ (>K:AP_SPD_VAR_DEC) } (A:AUTOPILOT PITCH HOLD, Bool) if{ (>K:AP_PITCH_REF_INC_UP) }',
	'')

wfdap500:CfgRpn(5, '100 (>K:AP_ALT_VAR_DEC)')
wfdap500:CfgRpn(6, '100 (>K:AP_ALT_VAR_INC)')
-- ALT push
wfdap500:CfgRpn(7, '(>K:AP_ALT_HOLD)')

wfdap500:CfgRpn(8, '(>K:AP_PANEL_HEADING_HOLD)')
wfdap500:CfgRpn(9, '(>K:AP_APR_HOLD)')
wfdap500:CfgRpn(10, '(>K:AP_NAV1_HOLD)')

-- TRK
wfdap500:CfgRpn(11, '(>K:AP_PANEL_HEADING_HOLD)')
-- AP
wfdap500:CfgRpn(12, '(>K:AP_MASTER)')
wfdap500:CfgRpn(13, '1 (>K:TOGGLE_FLIGHT_DIRECTOR)', '(>K:TOGGLE_FLIGHT_DIRECTOR)')
wfdap500:CfgRpn(14, '(>K:FLIGHT_LEVEL_CHANGE) (A:AIRSPEED INDICATED, knots) (>K:AP_SPD_VAR_SET)')
wfdap500:CfgRpn(15, '(>K:YAW_DAMPER_TOGGLE)')
--IAS
wfdap500:CfgRpn(16, '(A:AIRSPEED INDICATED, knots) (>K:AP_SPD_VAR_SET)')
--VNAV
wfdap500:CfgRpn(17, '(L:XMLVAR_VNAVButtonValue) ! (>L:XMLVAR_VNAVButtonValue)')
--VS
wfdap500:CfgRpn(18, '(>K:AP_PANEL_VS_HOLD)')
wfdap500:CfgRpn(19, '(>K:AP_ALT_HOLD)')

-- OUTPUT data

wfdap500:GetApr('(A:AUTOPILOT APPROACH HOLD,Bool)')
wfdap500:GetNav('(A:AUTOPILOT NAV1 LOCK,Bool)')
wfdap500:GetTrk('cpuwolf/flyluaio/WfDap500/condbtn[0]')
wfdap500:GetHdg('(A:AUTOPILOT HEADING LOCK,Bool)')
wfdap500:GetAp('(A:AUTOPILOT MASTER, Bool)')
wfdap500:GetFd('(A:AUTOPILOT FLIGHT DIRECTOR ACTIVE:1, Bool)')
wfdap500:GetLvl('(A:AUTOPILOT FLIGHT LEVEL CHANGE, bool)')
wfdap500:GetYd('(A:AUTOPILOT YAW DAMPER,Bool)')
wfdap500:GetIas('(A:AUTOTHROTTLE ACTIVE,Bool)')
wfdap500:GetVnav('(A:AUTOPILOT VERTICAL HOLD, Bool)')
wfdap500:GetVs('(A:AUTOPILOT VERTICAL HOLD, Bool)')
wfdap500:GetAlt('(A:AUTOPILOT ALTITUDE LOCK, Bool)')

-- backlight
wfdap500:GetBkl('(A:LIGHT POTENTIOMETER:3, Percent)', 2)

GlobalFrameLoopManager:add(function()
	wfdap500:SetLeds()
	--set backlight
	wfdap500:SetBkl()
	--force refresh
	wfdap500:ForceFresh()
end)
