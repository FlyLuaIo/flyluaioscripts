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
local dr_crs = iDataRef:New('sim/cockpit/radios/nav1_obs_degm')
local digi_alt
local digi_vs
local digi_ias
local digi_hdg
local digi_crs
dr_alt:Invalid()
dr_vs:Invalid()
dr_ias:Invalid()
dr_hdg:Invalid()
dr_crs:Invalid()
function Stkmulti_GA_Loop_Upd()
	if dr_mode_alt:ChangedUpdate() or
		dr_mode_vs:ChangedUpdate() or
		dr_mode_ias:ChangedUpdate() or
		dr_mode_hdg:ChangedUpdate() or
		dr_mode_crs:ChangedUpdate() then
		dr_alt:Invalid()
		dr_vs:Invalid()
		dr_ias:Invalid()
		dr_hdg:Invalid()
		dr_crs:Invalid()
	end
	if dr_alt:ChangedUpdate() then
		digi_alt = stkmulti:encUIntDigits(dr_alt:GetOld())
	end
	if dr_vs:ChangedUpdate() then
		digi_vs = stkmulti:encIntDigits(dr_vs:GetOld())
	end
	if dr_ias:ChangedUpdate() then
		digi_ias = stkmulti:encUIntDigits(dr_ias:GetOld())
	end
	if dr_hdg:ChangedUpdate() then
		digi_hdg = stkmulti:encUIntDigits(dr_hdg:GetOld())
	end
	if dr_crs:ChangedUpdate() then
		digi_crs = stkmulti:encUIntDigits(dr_crs:GetOld())
	end
	--
	if dr_mode_alt:GetOld() > 0 then
		stkmulti:setUp(digi_alt)
		stkmulti:setDn(digi_vs)
	elseif dr_mode_vs:GetOld() > 0 then
		stkmulti:setUp(digi_alt)
		stkmulti:setDn(digi_vs)
	elseif dr_mode_ias:GetOld() > 0 then
		stkmulti:setUp(digi_ias)
		stkmulti:setDn(digi_vs)
	elseif dr_mode_hdg:GetOld() > 0 then
		stkmulti:setUp(digi_hdg)
		stkmulti:setDn(digi_vs)
	elseif dr_mode_crs:GetOld() > 0 then
		stkmulti:setUp(digi_crs)
		stkmulti:setDn(digi_vs)
	end
	stkmulti:SetLeds()
end

uluaAddDoLoop("Stkmulti_GA_Loop_Upd()")
