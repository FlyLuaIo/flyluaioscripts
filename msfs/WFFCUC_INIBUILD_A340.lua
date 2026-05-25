-- *****************************************************************
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-04-24
-- *****************************************************************
if ilua_is_acfpath_excluded('a340') or ilua_is_acfpath_excluded('inibuild') then
	return
end

-- Do not remove below lines: hardware detection
local wffcuc = com.sim.wf.Wffcuc:new()
if not wffcuc:Init() then
	return
end
-- Do not remove above lines: hardware detection

uluaLog('Wffcuc for Inibuilds A340')

wffcuc:CfgRpnAxis(1, '1 (>B:AIRLINER_MCU_VS_Dec)', '1 (>B:AIRLINER_MCU_VS_Inc)')
wffcuc:CfgRpnAxis(2, '1 (>B:AIRLINER_MCU_ALT_Dec)', '1 (>B:AIRLINER_MCU_ALT_Inc)')
wffcuc:CfgRpnAxis(3, '1 (>B:AIRLINER_MCU_HDG_Dec)', '1 (>B:AIRLINER_MCU_HDG_Inc)')
wffcuc:CfgRpnAxis(4, '1 (>B:AIRLINER_MCU_SPEED_Dec)', '1 (>B:AIRLINER_MCU_SPEED_Inc)')

wffcuc:CfgRpn(0, "0 (>B:AIRLINER_SPDMACH_Set)")

wffcuc:CfgRpn(3, "1 (>L:INI_FCU_HDG_VS_COMMAND)")

-- 100~1000
local pswh6 = QmdevPosSwitchInit("(L:INI_ALTITUDE_STATE)", 1, "(>B:AIRLINER_MCU_ALTSELECT_Toggle)",
	"(>B:AIRLINER_MCU_ALTSELECT_Toggle)", 500)
wffcuc:CfgPSw(6, pswh6, 0, 1)

wffcuc:CfgRpn(12, "(L:INI_FCU_METRIC_STATE) ! (>L:INI_FCU_METRIC_STATE)")

-- LCD display
wffcuc:GetSpd('(L:INI_AIRSPEED_DIAL)')
wffcuc:GetHdg('(L:INI_HEADING_DIAL)')
wffcuc:GetAlt('(L:INI_ALTITUDE_DIAL)')
wffcuc:GetVs('(L:INI_VVI_DIAL)')

-- brightness
wffcuc:GetBkl('(A:LIGHT POTENTIOMETER:3, Percent)', 200) -- 0~1
wffcuc:GetLcdBkl('(A:LIGHT POTENTIOMETER:3, Percent)', 250)

-- LEDs
wffcuc:GetLoc('(L:INI_MCU_LOC_LIGHT)')
wffcuc:GetAp1('(L:INI_ap1_on)')
wffcuc:GetAp2('(L:INI_ap2_on)')
wffcuc:GetAthr('(L:INI_ATHR_LIGHT)')
wffcuc:GetExped('(A:AUTOPILOT FLIGHT LEVEL CHANGE, bool)')
wffcuc:GetAppr('(A:AUTOPILOT APPROACH HOLD,Bool)')
wffcuc:GetSpdmang('(L:INI_FCU_SPD_DOT)')
wffcuc:GetSpddash('(L:INI_FCU_SPD_DASHED)')
wffcuc:GetHdgmang('(L:INI_FCU_HDG_DOT)')
wffcuc:GetHdgdash('(L:INI_FCU_HDG_DASHED)')
wffcuc:GetAltmang(
'(L:FMGS_vertical_mode) 20 >= (L:FMGS_vertical_mode) 23 <= && (L:FMGS_vertical_mode) 40 >= || (L:FMGS_vertical_mode) 0 == (L:INI_PITCH_MODE_ARM) 3 == && || (L:FMGS_vertical_mode) 10 == (L:INI_REST_WPT_ALT) (A:INDICATED ALTITUDE,Feet) - abs 100 < && || (>L:MfAltDot) (L:MfAltDot)')
wffcuc:GetVsdash('(L:INI_FCU_VS_DASHED)')
wffcuc:GetSpdmach('(L:INI_Airspeed_is_mach)')
wffcuc:GetHdgtrk('(L:INI_TRACK_FPA_STATE)')
wffcuc:GetTest('cpuwolf/flyluaio/WfFcuc/condbtn[0]') -- 0: TEST 1:BRT: 2: DIM
wffcuc:GetPower('(L:INI_ELEC_AC_ESS_SHED_BUS_IS_POWERED, number)')

-- annun test mode
local dr_test_set = iDataRef:New('cpuwolf/flyluaio/WfFcuc/condbtn[0]')
local dr_test = iDataRef:New("(L:INI_ANNLT_SWITCH, number)", -1) -- 0: TEST 1:BRT: 2: DIM

function Wffcuc_ini340_Loop_Upd()
	-- expert code: test mode
	local b_test
	if dr_test:ChangedUpdate() then
		b_test = dr_test:GetOld()
		if b_test == 0 then
			dr_test_set:Set(1)
		elseif b_test == 1 then
			-- DIM
			dr_test_set:Set(0)
			wffcuc:FreshBits()
		else
			wffcuc:FreshBits()
		end
	else
		b_test = dr_test:Get()
	end
	if b_test == 0 then
		--test mode don't need refresh data
		wffcuc:SetLeds(0, 1)
	else
		wffcuc:SetLeds()
	end
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
end

GlobalFrameLoopManager:add(Wffcuc_ini340_Loop_Upd)
