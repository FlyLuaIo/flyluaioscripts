-- *****************************************************************
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-04-21_09_15_13UTC
-- *****************************************************************


if ilua_is_acftitle_excluded("A3") or ilua_is_acfpath_excluded("toliss") then
	if ilua_is_acftitle_excluded("A2") or ilua_is_acfpath_excluded("toliss") then
		return
	end
end

-- Do not remove below lines: hardware detection
local wffcuc = com.sim.qm.Wffcuc:new()
if not wffcuc:Init() then
	return
end
-- Do not remove above lines: hardware detection

uluaLog('Wffcuc for Toliss')

wffcuc:CfgCmdAxis(1, 'sim/autopilot/vertical_speed_down', 'sim/autopilot/vertical_speed_up')
wffcuc:CfgCmdAxis(2, 'sim/autopilot/altitude_down', 'sim/autopilot/altitude_up')
wffcuc:CfgCmdAxis(3, 'sim/autopilot/heading_down', 'sim/autopilot/heading_up')
wffcuc:CfgCmdAxis(4, 'sim/autopilot/airspeed_down', 'sim/autopilot/airspeed_up')

wffcuc:CfgCmd(0, "sim/GPS/g430n2_msg", "sim/autopilot/knots_mach_toggle")
wffcuc:CfgCmd(1, "sim/GPS/g430n2_msg", "AirbusFBW/PushSPDSel")
wffcuc:CfgCmd(2, "sim/GPS/g430n2_msg", "AirbusFBW/PullSPDSel")
wffcuc:CfgCmd(3, "sim/GPS/g430n2_msg", "toliss_airbus/dispcommands/HeadingTrackModeSwitch")
wffcuc:CfgCmd(4, "sim/GPS/g430n2_msg", "AirbusFBW/PushHDGSel")
wffcuc:CfgCmd(5, "sim/GPS/g430n2_msg", "AirbusFBW/PullHDGSel")
wffcuc:CfgVal(6, "AirbusFBW/ALT100_1000", 0, 1)
wffcuc:CfgCmd(8, "sim/GPS/g430n2_msg", "AirbusFBW/PushAltitude")
wffcuc:CfgCmd(9, "sim/GPS/g430n2_msg", "AirbusFBW/PullAltitude")
wffcuc:CfgCmd(10, "sim/GPS/g430n2_msg", "AirbusFBW/PushVSSel")
wffcuc:CfgCmd(11, "sim/GPS/g430n2_msg", "AirbusFBW/PullVSSel")
wffcuc:CfgCmd(12, "sim/GPS/g430n2_msg", "toliss_airbus/dispcommands/MetricAltitudeSwitch")
wffcuc:CfgCmd(13, "sim/GPS/g430n2_msg", "toliss_airbus/ap1_push")
wffcuc:CfgCmd(14, "sim/GPS/g430n2_msg", "toliss_airbus/ap2_push")
wffcuc:CfgCmd(15, "sim/GPS/g430n2_msg", "AirbusFBW/ATHRbutton")
wffcuc:CfgCmd(16, "sim/GPS/g430n2_msg", "AirbusFBW/LOCbutton")
wffcuc:CfgCmd(17, "sim/GPS/g430n2_msg", "AirbusFBW/EXPEDbutton")
wffcuc:CfgCmd(18, "sim/GPS/g430n2_msg", "AirbusFBW/APPRbutton")

-- LCD display
wffcuc:GetSpd('sim/cockpit2/autopilot/airspeed_dial_kts_mach')
wffcuc:GetHdg('sim/cockpit/autopilot/heading_mag')
wffcuc:GetAlt('sim/cockpit/autopilot/altitude')
wffcuc:GetVs('sim/cockpit/autopilot/vertical_velocity')

-- brightness
wffcuc:GetBkl("AirbusFBW/PanelBrightnessLevel", 200) -- 0~1
wffcuc:GetLcdBkl('AirbusFBW/SupplLightLevelRehostats[1]', 250)

-- LEDs
wffcuc:GetLoc('AirbusFBW/LOCilluminated')
wffcuc:GetAp1('AirbusFBW/AP1Engage')
wffcuc:GetAp2('AirbusFBW/AP2Engage')
wffcuc:GetAthr('AirbusFBW/ATHRmode')
wffcuc:GetExped('AirbusFBW/APVerticalMode')
wffcuc:GetAppr('AirbusFBW/APPRilluminated')
wffcuc:GetSpdmang('AirbusFBW/SPDmanaged')
wffcuc:GetSpddash('AirbusFBW/SPDdashed')
wffcuc:GetHdgmang('AirbusFBW/HDGmanaged')
wffcuc:GetHdgdash('AirbusFBW/HDGdashed')
wffcuc:GetAltmang('AirbusFBW/ALTmanaged')
wffcuc:GetVsdash('AirbusFBW/VSdashed')
wffcuc:GetSpdmach('sim/cockpit2/autopilot/airspeed_is_mach')
wffcuc:GetHdgtrk('AirbusFBW/HDGTRKmode')
wffcuc:GetTest('cpuwolf/flyluaio/WfFcuc/condbtn[0]')
wffcuc:GetPower('AirbusFBW/FCUAvail')

-- annun test mode
local dr_test_set = iDataRef:New('cpuwolf/flyluaio/WfFcuc/condbtn[0]')
local dr_test = iDataRef:New("AirbusFBW/AnnunMode") -- 0: DIM 1: BRT 2: test mode



function Wffcuc_Toliss_Loop_Upd()
	-- expert code: test mode
	local b_test
	if dr_test:ChangedUpdate() then
		b_test = dr_test:GetOld()
		if b_test == 2 then
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
	if b_test == 2 then
		--test mode don't need refresh data
		wffcuc:SetLeds(0.1, 1)
	else
		--wffcuc:SetLeds(0.1)
		wffcuc:SetLoc(0.1)
		wffcuc:SetAp1(0.1)
		wffcuc:SetAp2(0.1)
		wffcuc:SetAthr(0.1)
		wffcuc:SetExped(110)
		wffcuc:SetAppr(0.1)
		wffcuc:SetSpdmang(0.1)
		wffcuc:SetSpddash(0.1)
		wffcuc:SetHdgmang(0.1)
		wffcuc:SetHdgdash(0.1)
		wffcuc:SetAltmang(0.1)
		wffcuc:SetVsdash(0.1)
		wffcuc:SetSpdmach(0.1)
		wffcuc:SetHdgtrk(0.1)
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

GlobalFrameLoopManager:add(Wffcuc_Toliss_Loop_Upd)
