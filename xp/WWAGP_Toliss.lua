-- *****************************************************************
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-04-19
-- *****************************************************************
if ilua_is_acftitle_excluded('A3') or ilua_is_acfpath_excluded('toliss') then
	if ilua_is_acftitle_excluded('A2') or ilua_is_acfpath_excluded('toliss') then
		return
	end
end
-- Do not remove below lines: hardware detection
local wwagp = com.sim.qm.Wwagp:new()
if not wwagp:Init() then
	return
end
-- Do not remove above lines: hardware detection



-- 0:ELEC AC  1:ELEC DC
local iniA330_ecam_elec_acdc = 0

-- A330
local isINIA330 = false
local isINIA340 = false
if not ilua_is_acftitle_excluded('A33') then
	isINIA330 = true
	uluaLog('- Wwagp Toliss A33X')
elseif not ilua_is_acftitle_excluded('A34') then
	isINIA340 = true
	uluaLog('- Wwagp Toliss A34X')
else
	uluaLog('Wwagp for Toliss')
end

--================================ Output key binding
wwagp:CfgVal(0, 'AirbusFBW/BrakeFan', 1, 0)

if not isINIA340 then
	-- autobrake
	wwagp:CfgCmd(2, 'AirbusFBW/AbrkLo')
	wwagp:CfgCmd(3, 'AirbusFBW/AbrkMed')
	wwagp:CfgCmd(4, 'AirbusFBW/AbrkMax')
else
	-- autobrake
	wwagp:CfgValT(2, 'AirbusFBW/AutoBrkSel', 1, 0)
	wwagp:CfgValT(3, 'AirbusFBW/AutoBrkSel', 2, 0)
	--wwagp:CfgVal(4, 'AirbusFBW/AutoBrkSel', 5, nil)
	local cmd_auto_rto = uluaFind('AirbusFBW/AbrkMax')
	local drf_brk_pos = iDataRef:New('AirbusFBW/AutoBrkSel')
	function key_max_long_func()
		uluaCmdOnce(cmd_auto_rto)
	end

	function key_max_short_func()
		if drf_brk_pos:Get() == 5 then
			drf_brk_pos:Set(0)
		else
			drf_brk_pos:Set(5)
		end
	end

	wwagp:CfgLongFc(4, 1000, key_max_long_func, key_max_short_func)
end
wwagp:CfgVal(5, 'AirbusFBW/NWSnAntiSkid')

wwagp:CfgCmd(8, 'toliss_airbus/chrono/ChronoResetPush')
wwagp:CfgCmd(11, 'toliss_airbus/chrono/ChronoStartStopPush')

wwagp:CfgCmd(14, 'toliss_airbus/chrono/datePush')

wwagp:CfgVal(19, 'AirbusFBW/ClockETSwitch', 0, 1)
wwagp:CfgVal(21, 'AirbusFBW/ClockETSwitch', 2, 1)

-- Terrain
wwagp:CfgValT(22, 'AirbusFBW/TerrainSelectedND1')
wwagp:CfgCmd(23, 'sim/flight_controls/landing_gear_up', 'sim/flight_controls/landing_gear_down')


--====backlight
wwagp:GetBkl('AirbusFBW/PanelBrightnessLevel', 100)
wwagp:GetDigiBkl('sim/cockpit2/switches/avionics_power_on', 200) -- 0~1
wwagp:GetLedBkl('sim/cockpit2/switches/avionics_power_on', 200)  -- 0~1
--================================ Input LED/LCD ===
wwagp:GetUlockL('AirbusFBW/OHPLightsATA32[3]')
wwagp:GetUlockN('AirbusFBW/OHPLightsATA32[1]')
wwagp:GetUlockR('AirbusFBW/OHPLightsATA32[5]')
wwagp:GetBrakeHot('AirbusFBW/OHPLightsATA32[11]')
wwagp:GetLockL('AirbusFBW/OHPLightsATA32[2]')
wwagp:GetLockN('AirbusFBW/OHPLightsATA32[0]')
wwagp:GetLockR('AirbusFBW/OHPLightsATA32[4]')
wwagp:GetBrakeOn('AirbusFBW/OHPLightsATA32[10]')
wwagp:GetLowD('AirbusFBW/OHPLightsATA32[13]')
wwagp:GetMedD('AirbusFBW/OHPLightsATA32[15]')
wwagp:GetMaxD('AirbusFBW/OHPLightsATA32[17]')

if not isINIA340 then
	wwagp:GetLow('AirbusFBW/OHPLightsATA32[12]')
	wwagp:GetMed('AirbusFBW/OHPLightsATA32[14]')
	wwagp:GetMax('AirbusFBW/OHPLightsATA32[16]')
else
	wwagp:GetLow('AirbusFBW/AutoBrkLo')
	wwagp:GetMed('AirbusFBW/AutoBrkMed')
	wwagp:GetMax('cpuwolf/flyluaio/WwAgp/condbtn[2]')
end
wwagp:GetTerr('AirbusFBW/OHPLightsATA34[24]')
wwagp:GetLever('cpuwolf/flyluaio/WwAgp/condbtn[1]')



--====LCD
local dr_chrono
if nil == uluaFind("AirbusFBW/ClockChronoValue") then
	-- XP11
	dr_chrono = iDataRef:New('sim/cockpit2/clock_timer/hobbs_time_seconds')
else
	dr_chrono = iDataRef:New('AirbusFBW/ClockChronoValue')
end

local dr_utc_days = iDataRef:New('sim/time/local_date_days')

local dr_utc_hr = iDataRef:New('sim/cockpit2/clock_timer/zulu_time_hours')
local dr_utc_min = iDataRef:New('sim/cockpit2/clock_timer/zulu_time_minutes')
local dr_utc_sec = iDataRef:New('sim/cockpit2/clock_timer/zulu_time_seconds')

local dr_running_et = iDataRef:New('AirbusFBW/ClockShowsET')
local dr_et_hr = iDataRef:New('AirbusFBW/ClockETHours')
local dr_et_min = iDataRef:New('AirbusFBW/ClockETMinutes')

local dr_utc_is_date = iDataRef:New('AirbusFBW/ChronoButtonAnimations[2]')

local gChrono = ''
local utc = ''
local elapsed_time = ''
function Wwagp_GA_LCD_Loop()
	--Chrone
	if dr_chrono:ChangedUpdate() then
		local chr = dr_chrono:GetOld()
		if chr == 0 then
			gChrono = '     '
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
			utc = string.format('%02d:%02d:%02d', dr_utc_hr:GetOld(), dr_utc_min:GetOld(), dr_utc_sec:GetOld())
		end
	end

	-- ET
	if dr_et_hr:ChangedUpdate() or dr_et_min:ChangedUpdate() or dr_running_et:ChangedUpdate() then
		local et_is_run = dr_running_et:GetOld()
		if et_is_run == 0 then
			elapsed_time = '     '
		else
			elapsed_time = string.format('%02d:%02d', dr_et_hr:GetOld(), dr_et_min:GetOld())
		end
	end

	-- Write to hardware
	wwagp:setLcdStr(gChrono, utc, elapsed_time)
end

local dr_test = iDataRef:New('AirbusFBW/AnnunMode')                      -- 0: normal 2:test
local dr_power = iDataRef:New('sim/cockpit2/switches/avionics_power_on') -- 0: OFF 1: ON
local drf_brk_sel
local drf_brk_max
local drf_brk_pos = iDataRef:New('cpuwolf/flyluaio/WwAgp/condbtn[2]')
if isINIA340 then
	drf_brk_sel = iDataRef:New('AirbusFBW/AutoBrkSel')
	drf_brk_max = iDataRef:New('AirbusFBW/AutoBrkMax')
end
function Wwagp_Toliss_Loop_Upd()
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
		if b_test == 2 then
			wwagp:setLcdStrTest()
			wwagp:SetBkl()
			wwagp:Setleds(0, 1)
		elseif b_test == 0 then
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

	if b_test == 2 then
		--test mode don't need refresh data
		return
	end
	wwagp:SetBkl()
	wwagp:SetDigiBkl()
	wwagp:SetLedBkl()
	Wwagp_GA_LCD_Loop()
	-- update LEDs
	if isINIA340 then
		if drf_brk_sel:ChangedUpdate() or drf_brk_max:ChangedUpdate() then
			if drf_brk_sel:GetOld() > 4 or drf_brk_max:GetOld() > 0 then
				drf_brk_pos:Set(1)
			else
				drf_brk_pos:Set(0)
			end
		end
	end
	wwagp:Setleds(0.1)
end

GlobalFrameLoopManager:add(Wwagp_Toliss_Loop_Upd)
