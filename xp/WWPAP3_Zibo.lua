-- *****************************************************************
-- WwPap3 for Zibo B738 (ported from WINCTRL zibo-pap3-mcp-profile)
-- *****************************************************************

if ilua_require_zibo() then return end

-- Do not remove below lines: hardware detection
local wwpap3 = com.sim.qm.Wwpap3.Open()
if not wwpap3 then return end
-- Do not remove above lines: hardware detection

uluaLog('Wwpap3 for Zibo')

-------------------- Input Keys Binding ---------------------
wwpap3:CfgCmd(0, 'laminar/B738/autopilot/n1_press')
wwpap3:CfgCmd(1, 'laminar/B738/autopilot/speed_press')
wwpap3:CfgCmd(2, 'laminar/B738/autopilot/vnav_press')
wwpap3:CfgCmd(3, 'laminar/B738/autopilot/lvl_chg_press')
wwpap3:CfgCmd(4, 'laminar/B738/autopilot/hdg_sel_press')
wwpap3:CfgCmd(5, 'laminar/B738/autopilot/lnav_press')
wwpap3:CfgCmd(6, 'laminar/B738/autopilot/vorloc_press')
wwpap3:CfgCmd(7, 'laminar/B738/autopilot/app_press')
wwpap3:CfgCmd(8, 'laminar/B738/autopilot/alt_hld_press')
wwpap3:CfgCmd(9, 'laminar/B738/autopilot/vs_press')
wwpap3:CfgCmd(10, 'laminar/B738/autopilot/cmd_a_press')
wwpap3:CfgCmd(11, 'laminar/B738/autopilot/cws_a_press')
wwpap3:CfgCmd(12, 'laminar/B738/autopilot/cmd_b_press')
wwpap3:CfgCmd(13, 'laminar/B738/autopilot/cws_b_press')
wwpap3:CfgCmd(14, 'laminar/B738/autopilot/change_over_press')
wwpap3:CfgCmd(15, 'laminar/B738/autopilot/spd_interv')
wwpap3:CfgCmd(16, 'laminar/B738/autopilot/alt_interv')

-- Encoders (hardware also exposes as button pairs)
wwpap3:CfgCmd(17, 'laminar/B738/autopilot/course_pilot_dn')
wwpap3:CfgCmd(18, 'laminar/B738/autopilot/course_pilot_up')
wwpap3:CfgCmd(19, 'sim/autopilot/airspeed_down')
wwpap3:CfgCmd(20, 'sim/autopilot/airspeed_up')
wwpap3:CfgCmd(21, 'sim/autopilot/heading_down')
wwpap3:CfgCmd(22, 'sim/autopilot/heading_up')
wwpap3:CfgCmd(23, 'laminar/B738/autopilot/altitude_dn')
wwpap3:CfgCmd(24, 'laminar/B738/autopilot/altitude_up')
wwpap3:CfgCmd(25, 'laminar/B738/autopilot/course_copilot_dn')
wwpap3:CfgCmd(26, 'laminar/B738/autopilot/course_copilot_up')
wwpap3:CfgCmd(38, 'sim/autopilot/vertical_speed_down')
wwpap3:CfgCmd(39, 'sim/autopilot/vertical_speed_up')

-- Maintained switches / bank angle (button indices match WINCTRL)
wwpap3:CfgVal(27, "laminar/B738/switches/autopilot/fd_ca", 1, 0)
wwpap3:CfgVal(29, "laminar/B738/switches/autopilot/fd_fo", 1, 0)

local pswh71 = QmdevPosSwitchInit("laminar/B738/autopilot/disconnect_pos", 1, "laminar/B738/autopilot/disconnect_toggle",
	"laminar/B738/autopilot/disconnect_toggle", 500)
wwpap3:CfgPSw(32, pswh71, 1, 0)
function wwpap3_zibo_bank(target)
	local dr = uluaFind('laminar/B738/autopilot/bank_angle_pos')
	if not dr then return end
	local cur = uluaGet(dr)
	local cmd = uluaFind(target > cur and 'laminar/B738/autopilot/bank_angle_up' or
		'laminar/B738/autopilot/bank_angle_dn')
	local steps = math.abs(target - cur)
	for _ = 1, steps do uluaCmdOnce(cmd) end
end

wwpap3:CfgFc(33, 'wwpap3_zibo_bank(0)')
wwpap3:CfgFc(34, 'wwpap3_zibo_bank(1)')
wwpap3:CfgFc(35, 'wwpap3_zibo_bank(2)')
wwpap3:CfgFc(36, 'wwpap3_zibo_bank(3)')
wwpap3:CfgFc(37, 'wwpap3_zibo_bank(4)')
wwpap3:CfgVal(40, "laminar/B738/switches/autopilot/at_arm", 1, 0)

-------------------- Output LEDs ---------------------
wwpap3:GetN1('laminar/B738/autopilot/n1_status1', nil, 0.5)
wwpap3:GetSpeed('laminar/B738/autopilot/speed_status1', nil, 0.5)
wwpap3:GetVnav('laminar/B738/autopilot/vnav_status1', nil, 0.5)
wwpap3:GetLvlChg('laminar/B738/autopilot/lvl_chg_status', nil, 0.5)
wwpap3:GetHdgSel('laminar/B738/autopilot/hdg_sel_status', nil, 0.5)
wwpap3:GetLnav('laminar/B738/autopilot/lnav_status', nil, 0.5)
wwpap3:GetVorLoc('laminar/B738/autopilot/vorloc_status', nil, 0.5)
wwpap3:GetApp('laminar/B738/autopilot/app_status', nil, 0.5)
wwpap3:GetAltHld('laminar/B738/autopilot/alt_hld_status', nil, 0.5)
wwpap3:GetVs('laminar/B738/autopilot/vs_status', nil, 0.5)
wwpap3:GetCmdA('laminar/B738/autopilot/cmd_a_status', nil, 0.5)
wwpap3:GetCwsA('laminar/B738/autopilot/cws_a_status', nil, 0.5)
wwpap3:GetCmdB('laminar/B738/autopilot/cmd_b_status', nil, 0.5)
wwpap3:GetCwsB('laminar/B738/autopilot/cws_b_status', nil, 0.5)
wwpap3:GetAtArm('laminar/B738/autopilot/autothrottle_status1', nil, 0.5)
wwpap3:GetMaCapt('laminar/B738/autopilot/master_capt_status', nil, 0.5)
wwpap3:GetMaFo('laminar/B738/autopilot/master_fo_status', nil, 0.5)
wwpap3:GetAtSol('laminar/B738/autopilot/autothrottle_arm_pos')

-- Panel dimming source for ChangedUpdate throttling; LCDBKL/LEDBKL are pure
-- power/test state channels driven explicitly on edges, see FrameLoop below
wwpap3:GetBkl('laminar/B738/electric/panel_brightness[0]', 255)
wwpap3:GetLcdBkl('laminar/B738/electric/panel_brightness[0]', 255)
wwpap3:GetLedBkl('laminar/B738/electric/panel_brightness[0]', 255)

local dr_power    = iDataRef:New('sim/cockpit/electrical/avionics_on')
local dr_main     = iDataRef:New('laminar/B738/electric/main_bus')
local dr_test     = iDataRef:New('laminar/B738/dspl_light_test')
local dr_spd      = iDataRef:New('laminar/B738/autopilot/mcp_speed_dial_kts_mach')
local dr_mach     = iDataRef:New('sim/cockpit/autopilot/airspeed_is_mach')
local dr_hdg      = iDataRef:New('laminar/B738/autopilot/mcp_hdg_dial')
local dr_alt      = iDataRef:New('laminar/B738/autopilot/mcp_alt_dial')
local dr_vs       = iDataRef:New('sim/cockpit2/autopilot/vvi_dial_fpm')
local dr_vs_show  = iDataRef:New('laminar/B738/autopilot/vvi_dial_show')
local dr_spd_show = iDataRef:New('laminar/B738/autopilot/show_ias')
local dr_crs_c    = iDataRef:New('laminar/B738/autopilot/course_pilot')
local dr_crs_f    = iDataRef:New('laminar/B738/autopilot/course_copilot')
local dr_digit_a  = iDataRef:New('laminar/B738/mcp/digit_A')
local dr_digit_b  = iDataRef:New('laminar/B738/mcp/digit_8')


GlobalFrameLoopManager:add(function()
	local hasPower
	local hasMain = dr_main:Get() ~= 0
	local testMode

	-- power edge: falling edge goes dark once (zero traffic while off);
	-- rising edge invalidates the dimming source and forces LED bits to resync
	if dr_power:ChangedUpdate() then
		hasPower = dr_power:GetOld() ~= 0
		if not hasPower then
			wwpap3:SetBkl(0, 0)
			wwpap3:SetLcdBkl(0, 0)
			wwpap3:SetLedBkl(0, 0)
			wwpap3:setMcpDisplay({ displayEnabled = false })
			return
		end
		wwpap3:FreshBkls()
		wwpap3:FreshBits()
	else
		hasPower = dr_power:Get()
	end
	if not hasPower then return end

	wwpap3:SetBkl()
	wwpap3:SetLcdBkl()
	wwpap3:SetLedBkl()

	-- test edge: entering floods all lamps once; leaving restores backlights
	if dr_test:ChangedUpdate() then
		testMode = dr_test:GetOld()
		if testMode >= 1 then
			wwpap3:Setleds(0, 1)
			wwpap3:setMcpDisplay({
				displayEnabled = (testMode ~= 2),
				displayTest = true,
			})
			return
		end
		wwpap3:FreshBkls()
		wwpap3:FreshBits()
	else
		testMode = dr_test:Get()
	end
	if testMode >= 1 then return end



	wwpap3:SetN1()
	wwpap3:SetSpeed()
	wwpap3:SetVnav()
	wwpap3:SetLvlChg()
	wwpap3:SetHdgSel()
	wwpap3:SetLnav()
	wwpap3:SetVorLoc()
	wwpap3:SetApp()
	wwpap3:SetAltHld()
	wwpap3:SetVs()
	wwpap3:SetCmdA()
	wwpap3:SetCwsA()
	wwpap3:SetCmdB()
	wwpap3:SetCwsB()
	wwpap3:SetAtArm()
	wwpap3:SetMaCapt()
	wwpap3:SetMaFo()
	wwpap3:SetAtSol()

	-- LCD (WINCTRL zibo-pap3-mcp-profile::updateDisplayData)
	wwpap3:setMcpDisplay({
		displayEnabled = (testMode ~= 2) and hasPower,
		displayTest = testMode >= 1,
		showLabels = false,
		showCourse = true,
		speed = dr_spd:Get(),
		spdMach = dr_mach:Get() ~= 0,
		speedVisible = dr_spd_show:Get() ~= 0,
		heading = dr_hdg:Get(),
		headingVisible = true,
		altitude = dr_alt:Get(),
		altitudeVisible = true,
		verticalSpeed = dr_vs:Get(),
		verticalSpeedVisible = dr_vs_show:Get() ~= 0,
		crsCapt = dr_crs_c:Get(),
		crsFo = dr_crs_f:Get(),
		digitA = dr_digit_a:Get() ~= 0,
		digitB = dr_digit_b:Get() ~= 0,
	})
end)
