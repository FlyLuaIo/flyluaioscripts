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


-- 6:DEC 5:INC
function stkmulti_mode_cfg_alt()
	stkmulti:CfgCmd(6, 'sim/autopilot/altitude_down', 'sim/operation/test_none')
	stkmulti:CfgCmd(5, 'sim/autopilot/altitude_up', 'sim/operation/test_none')
end

function stkmulti_mode_cfg_vs()
	stkmulti:CfgCmd(6, 'sim/autopilot/vertical_speed_down', 'sim/operation/test_none')
	stkmulti:CfgCmd(5, 'sim/autopilot/vertical_speed_up', 'sim/operation/test_none')
end

function stkmulti_mode_cfg_ias()
	stkmulti:CfgCmd(6, 'sim/autopilot/airspeed_down', 'sim/operation/test_none')
	stkmulti:CfgCmd(5, 'sim/autopilot/airspeed_up', 'sim/operation/test_none')
end

function stkmulti_mode_cfg_hdg()
	stkmulti:CfgCmd(6, 'sim/autopilot/heading_down', 'sim/operation/test_none')
	stkmulti:CfgCmd(5, 'sim/autopilot/heading_up', 'sim/operation/test_none')
end

function stkmulti_mode_cfg_crs()
	stkmulti:CfgCmd(6, 'sim/radios/obs_HSI_down', 'sim/operation/test_none')
	stkmulti:CfgCmd(5, 'sim/radios/obs_HSI_up', 'sim/operation/test_none')
end

-- 0:ALT 1:VS 2:IAS 3:HDG 4:CRS
stkmulti:CfgFc(0, 'stkmulti_mode_cfg_alt()')
stkmulti:CfgFc(1, 'stkmulti_mode_cfg_vs()')
stkmulti:CfgFc(2, 'stkmulti_mode_cfg_ias()')
stkmulti:CfgFc(3, 'stkmulti_mode_cfg_hdg()')
stkmulti:CfgFc(4, 'stkmulti_mode_cfg_crs()')

local dr_mode_alt = iDataRef:New('cpuwolf/qmdev/StkMulti/keysmap[0]')
local dr_mode_vs = iDataRef:New('cpuwolf/qmdev/StkMulti/keysmap[1]')
local dr_mode_ias = iDataRef:New('cpuwolf/qmdev/StkMulti/keysmap[2]')
local dr_mode_hdg = iDataRef:New('cpuwolf/qmdev/StkMulti/keysmap[3]')
local dr_mode_crs = iDataRef:New('cpuwolf/qmdev/StkMulti/keysmap[4]')

--AP
stkmulti:CfgCmd(7, 'sim/autopilot/servos_toggle')

--HDG
stkmulti:CfgCmd(8, 'sim/autopilot/heading')
--NAV
stkmulti:CfgCmd(9, 'sim/autopilot/NAV')
--IAS
stkmulti:CfgCmd(10, 'sim/autopilot/airspeed_sync')
--ALT
stkmulti:CfgCmd(11, 'sim/autopilot/altitude_hold')
--VS
stkmulti:CfgCmd(12, 'sim/autopilot/vertical_speed')
--APR
stkmulti:CfgCmd(13, 'sim/autopilot/approach')
--REV
stkmulti:CfgCmd(14, 'sim/autopilot/back_course')

--AUTO THROTTLE
stkmulti:CfgCmd(15, 'sim/autopilot/autothrottle_arm', 'sim/autopilot/autothrottle_off')

-- flap down
stkmulti:CfgCmd(17, 'sim/flight_controls/flaps_down')
-- flap up
stkmulti:CfgCmd(16, 'sim/flight_controls/flaps_up')

-- trim down
stkmulti:CfgCmd(18, 'sim/flight_controls/pitch_trim_down')
-- trim up
stkmulti:CfgCmd(19, 'sim/flight_controls/pitch_trim_up')



stkmulti:GetAp('sim/cockpit2/autopilot/servos_on')
stkmulti:GetHdg('sim/cockpit2/autopilot/heading_status')
stkmulti:GetNav('sim/cockpit2/autopilot/nav_status')
stkmulti:GetIas('sim/cockpit2/autopilot/speed_status')
stkmulti:GetAlt('sim/cockpit2/autopilot/altitude_hold_status')
stkmulti:GetVs('sim/cockpit2/autopilot/vvi_status')
stkmulti:GetApr('sim/cockpit2/autopilot/approach_status')
stkmulti:GetRev('sim/cockpit/autopilot/backcourse_on')


local dr_alt = iDataRef:New("sim/cockpit2/autopilot/altitude_dial_ft")
local dr_vs = iDataRef:New("sim/cockpit2/autopilot/vvi_dial_fpm")
local dr_ias = iDataRef:New("sim/cockpit2/autopilot/airspeed_dial_kts_mach")
local dr_hdg = iDataRef:New("sim/cockpit/autopilot/heading_mag")
local d_crs = iDataRef:New('sim/cockpit/radios/nav1_obs_degm')

function Stkmulti_GA_Loop_Upd()
	if dr_mode_alt:Get() > 0 then
		stkmulti:setUp(stkmulti:encUIntDigits(dr_alt:Get()))
		stkmulti:setDn(stkmulti:encIntDigits(dr_vs:Get()))
	elseif dr_mode_vs:Get() > 0 then
		stkmulti:setUp(stkmulti:encUIntDigits(dr_alt:Get()))
		stkmulti:setDn(stkmulti:encIntDigits(dr_vs:Get()))
	elseif dr_mode_ias:Get() > 0 then
		stkmulti:setUp(stkmulti:encUIntDigits(dr_ias:Get()))
		stkmulti:setDn(stkmulti:encIntDigits(dr_vs:Get()))
	elseif dr_mode_hdg:Get() > 0 then
		stkmulti:setUp(stkmulti:encUIntDigits(dr_hdg:Get()))
		stkmulti:setDn(stkmulti:encIntDigits(dr_vs:Get()))
	elseif dr_mode_crs:Get() > 0 then
		stkmulti:setUp(stkmulti:encUIntDigits(d_crs:Get()))
		stkmulti:setDn(stkmulti:encIntDigits(dr_vs:Get()))
	end
	stkmulti:SetLeds()
end

uluaAddDoLoop("Stkmulti_GA_Loop_Upd()")
