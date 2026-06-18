-- *****************************************************************
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-05-09
-- *****************************************************************

if ilua_is_acftitle_excluded("B77") then
	return
end

local file
file = AIRCRAFT_PATH .. "\\..\\plugins\\T7Avionics\\64\\win.xpl"
-- uluaLog(file)

if ilua_file_exists(file) then
	uluaLog("FF777 old")
	return
end

-- Do not remove below lines: hardware detection
local wwagp = com.sim.qm.Wwagp:new()
if not wwagp:Init() then
	return
end
-- Do not remove above lines: hardware detection

uluaLog('Wwagp for FF777 V2')

--================================ Output key binding

-- autobrake
local cmd_auto_rto = uluaFind('1-sim/command/autobrakeSwitch_set_0')
local cmd_auto_off = uluaFind('1-sim/command/autobrakeSwitch_set_1')
local cmd_auto_low = uluaFind('1-sim/command/autobrakeSwitch_set_3')
local cmd_auto_med = uluaFind('1-sim/command/autobrakeSwitch_set_4')
local cmd_auto_max = uluaFind('1-sim/command/autobrakeSwitch_set_7')
local drf_brk_pos = iDataRef:New('1-sim/output/autobrakes')

function key_low_func()
	if drf_brk_pos:Get() == 3 then
		uluaCmdOnce(cmd_auto_off)
	else
		uluaCmdOnce(cmd_auto_low)
	end
end

wwagp:CfgFc(2, "key_low_func()")

function key_med_func()
	if drf_brk_pos:Get() == 4 then
		uluaCmdOnce(cmd_auto_off)
	else
		uluaCmdOnce(cmd_auto_med)
	end
end

wwagp:CfgFc(3, "key_med_func()")

function key_max_long_func()
	if drf_brk_pos:Get() == 0 then
		uluaCmdOnce(cmd_auto_off)
	else
		uluaCmdOnce(cmd_auto_rto)
	end
end

function key_max_short_func()
	if drf_brk_pos:Get() == 7 then
		uluaCmdOnce(cmd_auto_off)
	else
		uluaCmdOnce(cmd_auto_max)
	end
end

wwagp:CfgLongFc(4, 1000, key_max_long_func, key_max_short_func)
wwagp:CfgCmd(8, '1-sim/command/cptTimerChrButton_button')
wwagp:CfgCmd(11, '1-sim/command/cptTimerChrButton_button')

wwagp:CfgCmd(19, '1-sim/command/cptTimerSetSwitch_set_2')
wwagp:CfgCmd(20, '1-sim/command/cptTimerSetSwitch_set_1')
wwagp:CfgCmd(21, '1-sim/command/cptTimerSetSwitch_set_0')

-- Terrain
wwagp:CfgCmd(22, "1-sim/command/cptHsiTerrButton_button")
wwagp:CfgCmd(23, 'sim/flight_controls/landing_gear_up', 'sim/flight_controls/landing_gear_down')


--====backlight
wwagp:GetBkl('sim/cockpit/electrical/cockpit_lights', 250)
wwagp:GetDigiBkl("sim/cockpit2/switches/avionics_power_on", 200) -- 0~1
wwagp:GetLedBkl("sim/cockpit2/switches/avionics_power_on", 200)  -- 0~1
--================================ Input LED/LCD ===
wwagp:GetUlockL("sim/cockpit2/annunciators/gear_unsafe")
wwagp:GetUlockN("sim/cockpit2/annunciators/gear_unsafe")
wwagp:GetUlockR("sim/cockpit2/annunciators/gear_unsafe")
wwagp:GetBrakeHot('cpuwolf/flyluaio/WwAgp/condbtn[1]')
wwagp:GetLockL("sim/aircraft/parts/acf_gear_deploy[1]", false, 0.01)
wwagp:GetLockN("sim/aircraft/parts/acf_gear_deploy[2]", false, 0.01)
wwagp:GetLockR("sim/aircraft/parts/acf_gear_deploy[3]", false, 0.01)
wwagp:GetBrakeOn('cpuwolf/flyluaio/WwAgp/condbtn[1]')
wwagp:GetLowD('cpuwolf/flyluaio/WwAgp/condbtn[1]')
wwagp:GetMedD('cpuwolf/flyluaio/WwAgp/condbtn[1]')
wwagp:GetMaxD('cpuwolf/flyluaio/WwAgp/condbtn[1]')
wwagp:GetLow('cpuwolf/flyluaio/WwAgp/condbtn[2]')
wwagp:GetMed('cpuwolf/flyluaio/WwAgp/condbtn[3]')
wwagp:GetMax('cpuwolf/flyluaio/WwAgp/condbtn[4]')
wwagp:GetTerr('cpuwolf/flyluaio/WwAgp/condbtn[1]')
wwagp:GetLever('cpuwolf/flyluaio/WwAgp/condbtn[1]')



--====LCD
local dr_chrono = iDataRef:New('1-sim/ckpt/clockHandL/anim') --0~360

local dr_utc_days = iDataRef:New('sim/time/local_date_days')

local dr_utc_hr = iDataRef:New('sim/cockpit2/clock_timer/zulu_time_hours')
local dr_utc_min = iDataRef:New('sim/cockpit2/clock_timer/zulu_time_minutes')
local dr_utc_sec = iDataRef:New('sim/cockpit2/clock_timer/zulu_time_seconds')

local dr_et_hr = iDataRef:New('sim/cockpit2/clock_timer/hobbs_time_hours')
local dr_et_min = iDataRef:New('sim/cockpit2/clock_timer/hobbs_time_minutes')

local dr_utc_is_date = iDataRef:New('cpuwolf/flyluaio/WwAgp/keysmap[14]')

local gChrono = ""
local utc = ""
local elapsed_time = ""
function Wwagp_GA_LCD_Loop()
	--Chrone
	if dr_chrono:ChangedUpdate() then
		local chr = dr_chrono:GetOld() / 6
		if math.floor(chr) == 0 then
			gChrono = "     "
		else
			gChrono = wwagp:formatChronoStr(chr)
		end
	end

	-- UTC time
	if dr_utc_is_date:ChangedUpdate() then
		dr_utc_days:Invalid()
		dr_utc_hr:Invalid()
		dr_utc_min:Invalid()
		dr_utc_sec:Invalid()
	end
	if dr_utc_is_date:GetOld() > 0 then
		if dr_utc_days:ChangedUpdate() then
			utc = wwagp:formatUTCdateStr(dr_utc_days:GetOld())
		end
	else
		if dr_utc_hr:ChangedUpdate() or dr_utc_min:ChangedUpdate() or dr_utc_sec:ChangedUpdate() then
			utc = string.format("%02d:%02d:%02d", dr_utc_hr:GetOld(), dr_utc_min:GetOld(), dr_utc_sec:GetOld())
		end
	end

	-- ET
	if dr_et_hr:ChangedUpdate() or dr_et_min:ChangedUpdate() then
		elapsed_time = string.format("%02d:%02d", dr_et_hr:GetOld(), dr_et_min:GetOld())
	end

	-- Write to hardware
	wwagp:setLcdStr(gChrono, utc, elapsed_time)
end

local dr_test = iDataRef:New("sim/cockpit/warnings/annunciator_test_pressed") -- 0: normal 1:test
local dr_power = iDataRef:New("sim/cockpit2/switches/avionics_power_on")      -- 0: OFF 1: ON

local drf_brk_low = iDataRef:New('cpuwolf/flyluaio/WwAgp/condbtn[2]')
local drf_brk_mid = iDataRef:New('cpuwolf/flyluaio/WwAgp/condbtn[3]')
local drf_brk_max = iDataRef:New('cpuwolf/flyluaio/WwAgp/condbtn[4]')

GlobalFrameLoopManager:add(function()
	-- expert code: cold and dark
	local b_power
	if dr_power:ChangedUpdate() then
		b_power = dr_power:GetOld()
		if b_power == 0 then
			wwagp:PowerOff()
			wwagp:FreshBkl()
			wwagp:FreshDigiBkl()
			wwagp:FreshLedBkl()
			wwagp:FreshBits()
		end
	else
		b_power = dr_power:Get()
	end
	if b_power == 0 then
		return
	end
	-- expert code: test mode
	local b_test
	if dr_test:ChangedUpdate() then
		b_test = dr_test:GetOld()
		if b_test == 1 then
			wwagp:setLcdStrTest()
			wwagp:SetBkl()
			wwagp:Setleds(0, 1)
		elseif b_test == 2 then
			-- DIM
			wwagp:SetLedBkl(30)
		else
			wwagp:FreshBkl()
			wwagp:FreshDigiBkl()
			wwagp:FreshLedBkl()
			wwagp:FreshBits()
		end
	else
		b_test = dr_test:Get()
	end

	if b_test == 1 then
		--test mode don't need refresh data
		return
	end

	if drf_brk_pos:ChangedUpdate() then
		local pos = drf_brk_pos:GetOld()
		if pos == 3 then
			drf_brk_low:Set(1)
		else
			drf_brk_low:Set(0)
		end
		if pos == 4 then
			drf_brk_mid:Set(1)
		else
			drf_brk_mid:Set(0)
		end
		if pos == 0 then
			drf_brk_max:Set(1)
		elseif pos == 7 then
			drf_brk_max:Set(1)
		else
			drf_brk_max:Set(0)
		end
	end

	wwagp:SetBkl()
	wwagp:SetDigiBkl()
	wwagp:SetLedBkl()
	Wwagp_GA_LCD_Loop()
	-- update LEDs
	wwagp:SetUlockL(1)
	wwagp:SetUlockN(1)
	wwagp:SetUlockR(1)
	wwagp:SetBrakeHot()
	wwagp:SetLockL()
	wwagp:SetLockN()
	wwagp:SetLockR()
	wwagp:SetBrakeOn()
	wwagp:SetLowD()
	wwagp:SetMedD()
	wwagp:SetMaxD()
	wwagp:SetLow()
	wwagp:SetMed()
	wwagp:SetMax()
	wwagp:SetTerr()
	wwagp:SetLever()
end)
