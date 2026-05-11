-- *****************************************************************
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-04-16
-- Modify by Carson Lou <carsonlu@sohu.com> 2026-05-09
-- *****************************************************************

if ilua_is_acfpath_excluded('PMDG') or ilua_is_acfpath_excluded('737') then
	return
end

-- Do not remove below lines: hardware detection
local wwagp = com.sim.qm.Wwagp:new()
if not wwagp:Init() then
	return
end
-- Do not remove above lines: hardware detection

uluaLog('WinWing AGP for PMDG737')

--================================ Output key binding
--
wwagp:CfgRpn(0, '(L:INI_BRAKE_FAN_ON) ! (>L:INI_BRAKE_FAN_ON)', '(L:INI_BRAKE_FAN_ON) ! (>L:INI_BRAKE_FAN_ON)')
-- autobrake
wwagp:CfgRpn(2,
'(L:switch_460_73X, number) 0 != if{ 0 (>L:switch_460_73X, number) } els{ 10 (>L:switch_460_73X, number) }')
wwagp:CfgRpn(3,
	'(L:switch_460_73X, number) 10 != if{ 10 (>L:switch_460_73X, number) } els{ 30 (>L:switch_460_73X, number) }')
wwagp:CfgRpn(4,
	'(L:INI_AUTOBRAKE_LEVEL, number) 4 != if{ 4 (>L:INI_AUTOBRAKE_LEVEL, number) } els{ 0 (>L:INI_AUTOBRAKE_LEVEL, number) }')

wwagp:CfgRpn(5, '1 (>L:INI_ANTISKID_SWITCH)')
wwagp:CfgRpn(6, '0 (>L:INI_ANTISKID_SWITCH)')
wwagp:CfgRpn(8, '1 (>L:INI_CHR_RESET_COMMAND)')
wwagp:CfgRpn(11, '1 (>L:INI_CHR_START_COMMAND)')
wwagp:CfgRpn(14, '1 (>L:INI_CLOCK_DATE_BUTTON)', '0 (>L:INI_CLOCK_DATE_BUTTON)')

wwagp:CfgRpn(16, '2 (>L:INI_CLOCK_GPS_STATE)')
wwagp:CfgRpn(17, '1 (>L:INI_CLOCK_GPS_STATE)')
wwagp:CfgRpn(18, '0 (>L:INI_CLOCK_GPS_STATE)')

wwagp:CfgRpn(19, '0 (>L:INI_CLOCK_RUN_STATE)')
wwagp:CfgRpn(20, '1 (>L:INI_CLOCK_RUN_STATE)')
wwagp:CfgRpn(21, '2 (>L:INI_CLOCK_RUN_STATE)')

wwagp:CfgRpn(22, '(L:INI_TERR_ON_CAPT) ! (>L:INI_TERR_ON_CAPT)')
wwagp:CfgRpn(23, '(>K:GEAR_UP)', '(>K:GEAR_DOWN)')



--====backlight
wwagp:GetBkl('(L:INI_POTENTIOMETER_14, Percent)', 1)                 -- 0~100
wwagp:GetDigiBkl('(L:INI_DC_ESSENTIAL_BUS_IS_POWERED, number)', 120) -- 0~1
wwagp:GetLedBkl('(L:INI_DC_ESSENTIAL_BUS_IS_POWERED, number)', 120)  -- 0~1
--================================ Input LED/LCD ===
wwagp:GetUlockL('(L:MSATR_GEAR_LEFT_UNLK_LT)')
wwagp:GetUlockN('(L:INI_GEAR0_UNLK_LIGHT) (L:INI_GEAR3_UNLK_LIGHT) or')
wwagp:GetUlockR('(L:INI_GEAR2_UNLK_LIGHT)')
wwagp:GetBrakeHot('(L:INI_BRAKES_HOT)')
wwagp:GetLockL('(A:GEAR LEFT POSITION, percent over 100)')
wwagp:GetLockN('(A:GEAR CENTER POSITION, percent over 100)')
wwagp:GetLockR('(L:INI_GEAR2_POSITION) 50 ==')
wwagp:GetBrakeOn('(L:INI_BRAKE_FAN_ON)')
wwagp:GetLowD('(L:INI_AUTOBRAKE_LOW_DECEL)')
wwagp:GetMedD('(L:INI_AUTOBRAKE_MED_DECEL)')
wwagp:GetMaxD('(L:INI_AUTOBRAKE_HI_DECEL)')
wwagp:GetLow('(L:INI_AUTOBRAKE_LEVEL) 5 ==')
wwagp:GetMed('(L:INI_AUTOBRAKE_LEVEL) 3 ==')
wwagp:GetMax('(L:INI_AUTOBRAKE_LEVEL) 4 ==')
wwagp:GetTerr('(L:INI_TERR_ON_CAPT)')
wwagp:GetLever('(L:INI_GEAR_DOWN_ARROW_LIGHT)')



--====LCD
local dr_running_chrono = iDataRef:New('(L:INI_CHRONO_STARTED, number)')
local dr_chrono = iDataRef:New('(L:INI_CHRONO_UPPER, number)')

local dr_utc_year = iDataRef:New('(E:ZULU YEAR, number)')
local dr_utc_mon = iDataRef:New('(E:ZULU MONTH OF YEAR, number)')
local dr_utc_day = iDataRef:New('(E:ZULU DAY OF MONTH, number)')

local dr_utc_sec = iDataRef:New('(E:ZULU TIME, second)')

local dr_running_et = iDataRef:New('(L:INI_ET_STARTED, number)')
local dr_et_sec = iDataRef:New('(E:SIMULATION TIME, second)')

local dr_utc_is_date = iDataRef:New('(L:INI_CLOCK_DATE_BUTTON)')

local gChrono = ''
local gUtc = ''
local elapsed_time = ''
function Wwagp_GA_LCD_Loop()
	--Chrone
	if dr_chrono:ChangedUpdate() or dr_running_chrono:ChangedUpdate() then
		local chr = dr_chrono:GetOld()
		local chr_is_run = dr_running_chrono:GetOld()
		if chr_is_run == 0 then
			gChrono = '     '
		else
			gChrono = wwagp:formatChronoStr(chr)
		end
	end

	-- UTC time
	if dr_utc_is_date:ChangedUpdate() then
		dr_utc_year:Invalid()
		dr_utc_mon:Invalid()
		dr_utc_day:Invalid()
		dr_utc_sec:Invalid()
	end
	if dr_utc_is_date:GetOld() > 0 then
		if dr_utc_year:ChangedUpdate() or dr_utc_mon:ChangedUpdate() or dr_utc_day:ChangedUpdate() then
			local mm = dr_utc_mon:GetOld() % 12
			local yy = dr_utc_year:GetOld() % 100
			gUtc = string.format('%02d:%02d:%02d', mm, dr_utc_day:GetOld(), yy)
		end
	else
		if dr_utc_sec:ChangedUpdate() then
			local totalSeconds = math.floor(dr_utc_sec:GetOld())
			local h = math.floor(totalSeconds / 3600)
			local m = math.floor((totalSeconds % 3600) / 60)
			local s = totalSeconds % 60
			gUtc = string.format('%02d:%02d:%02d', h, m, s)
		end
	end

	-- ET
	if dr_et_sec:ChangedUpdate() or dr_running_et:ChangedUpdate() then
		local totalSeconds = math.floor(dr_et_sec:GetOld())
		local h = math.floor(totalSeconds / 3600)
		local m = math.floor((totalSeconds % 3600) / 60)
		local et_is_run = dr_running_et:GetOld()
		if et_is_run == 0 then
			elapsed_time = '     '
		else
			elapsed_time = string.format('%02d:%02d', h, m)
		end
	end

	-- Write to hardware
	wwagp:setLcdStr(gChrono, gUtc, elapsed_time)
end

-- =====Annunciator test
local dr_test = iDataRef:New('(L:INI_ANNLT_SWITCH, number)')                 -- 0: TEST 1:BRT: 2: DIM
local dr_power = iDataRef:New('(L:INI_DC_ESSENTIAL_BUS_IS_POWERED, number)') -- 0: OFF 1: ON

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
		if b_test == 0 then
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

	if b_test == 0 then
		--test mode don't need refresh data
		return
	end
	wwagp:SetBkl()
	wwagp:SetDigiBkl()
	wwagp:SetLedBkl()
	Wwagp_GA_LCD_Loop()
	-- update LEDs
	wwagp:Setleds()
end)
