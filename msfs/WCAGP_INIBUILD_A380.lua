-- *****************************************************************
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-04-16
-- *****************************************************************

if ilua_require_inibuild_a380() then return end

-- Do not remove below lines: hardware detection
local wcagp = com.sim.qm.Wcagp.Open()
if not wcagp then return end
-- Do not remove above lines: hardware detection

uluaLog('WinCtrl AGP for Inibuild A380')

--================================ Output key binding
--
wcagp:CfgRpn(0, "(L:INI_BRAKE_FAN_ON) ! (>L:INI_BRAKE_FAN_ON)", "(L:INI_BRAKE_FAN_ON) ! (>L:INI_BRAKE_FAN_ON)")

-- autobrake
wcagp:CfgRpn(2,
	"(L:INI_LG_ABRK_LEVEL, number) 2 != if{ 2 (>L:INI_LG_ABRK_LEVEL, number) } els{ 0 (>L:INI_LG_ABRK_LEVEL, number) }")
wcagp:CfgRpn(3,
	"(L:INI_LG_ABRK_LEVEL, number) 3 != if{ 3 (>L:INI_LG_ABRK_LEVEL, number) } els{ 0 (>L:INI_LG_ABRK_LEVEL, number) }")
local drf_brk_pos = iDataRef:New("(L:INI_LG_ABRK_LEVEL, number)")
function key_brkmax_long_end_func()
	uluaWriteCmd('1 (>B:AIRLINER_MIP_LG_ABRK_RTO_Set)')
end

function key_brkmax_long_func()
	uluaWriteCmd('0 (>L:INI_LG_ABRK_LEVEL, number)')
	uluasetTimeout('key_brkmax_long_end_func()', 2000)
end

function key_brkmax_short_func()
	if drf_brk_pos:Get() == 5 then
		uluaWriteCmd('0 (>L:INI_LG_ABRK_LEVEL, number)')
	else
		uluaWriteCmd('5 (>L:INI_LG_ABRK_LEVEL, number)')
	end
end

wcagp:CfgLongFc(4, 1000, key_brkmax_long_func, key_brkmax_short_func)

wcagp:CfgRpn(5, '0 (>L:INI_ANTISKID_SWITCH)')
wcagp:CfgRpn(6, '1 (>L:INI_ANTISKID_SWITCH)')
wcagp:CfgRpn(8, '1 (>L:INI_CHR_RESET_COMMAND)')
wcagp:CfgRpn(11, '1 (>L:INI_CHR_START_COMMAND)')
wcagp:CfgRpn(14, '1 (>L:INI_CLOCK_DATE_BUTTON)', '0 (>L:INI_CLOCK_DATE_BUTTON)')

wcagp:CfgRpn(16, '0 (>L:INI_CLOCK_GPS_STATE)')
wcagp:CfgRpn(17, '1 (>L:INI_CLOCK_GPS_STATE)')
wcagp:CfgRpn(18, '2 (>L:INI_CLOCK_GPS_STATE)')

wcagp:CfgRpn(19, '0 (>L:INI_CLOCK_RUN_STATE)')
wcagp:CfgRpn(20, '1 (>L:INI_CLOCK_RUN_STATE)')
wcagp:CfgRpn(21, '2 (>L:INI_CLOCK_RUN_STATE)')

wcagp:CfgRpn(22, "(L:INI_TERR_ON_CAPT) ! (>L:INI_TERR_ON_CAPT)")
wcagp:CfgRpn(23, '(>K:GEAR_UP)', '(>K:GEAR_DOWN)')



--====backlight
wcagp:GetBkl("(L:INI_CKPT_LT_INTEG)", 2.4)          -- 0~100
wcagp:GetDigiBkl("(L:INI_battery_on, number)", 200) -- 0~1
wcagp:GetLedBkl("(L:INI_battery_on, number)", 200)  -- 0~1
--================================ Input LED/LCD ===
wcagp:GetUlockL("(L:INI_GEAR1_UNLK_LIGHT)")
wcagp:GetUlockN("(L:INI_GEAR0_UNLK_LIGHT) (L:INI_GEAR3_UNLK_LIGHT) or")
wcagp:GetUlockR("(L:INI_GEAR2_UNLK_LIGHT)")
wcagp:GetBrakeHot('(L:INI_BRAKES_HOT)')
wcagp:GetLockL("(L:INI_GEAR1_POSITION) 50 ==")
wcagp:GetLockN("(L:INI_GEAR0_POSITION) 50 == (L:INI_GEAR3_POSITION) 50 == and")
wcagp:GetLockR("(L:INI_GEAR2_POSITION) 50 ==")
wcagp:GetBrakeOn('(L:INI_BRAKE_FAN_ON)')
wcagp:GetLowD('(L:INI_AUTOBRAKE_LOW_DECEL)')
wcagp:GetMedD('(L:INI_AUTOBRAKE_MED_DECEL)')
wcagp:GetMaxD('(L:INI_AUTOBRAKE_LEVEL) 4 == (L:INI_AUTOBRAKE_ARMED) and')
wcagp:GetLow('(L:INI_LG_ABRK_LEVEL) 2 ==')
wcagp:GetMed('(L:INI_LG_ABRK_LEVEL) 3 ==')
wcagp:GetMax(
	'(L:INI_AUTOBRAKE_LEVEL) 4 == (L:INI_AUTOBRAKE_ARMED) and (L:INI_LG_ABRK_LEVEL) 5 == or')
wcagp:GetTerr('(L:INI_TERR_ON_CAPT)')
wcagp:GetLever('(L:INI_GEAR_DOWN_ARROW_LIGHT)')



--====LCD
local dr_running_chrono = iDataRef:New('(L:INI_CHRONO_STARTED, number)')
local dr_chrono_sec = iDataRef:New('(L:INI_CHRONO_SECONDS, number)')
local dr_chrono_min = iDataRef:New('(L:INI_CHRONO_MINUTES, number)')

local dr_utc_year = iDataRef:New('(E:ZULU YEAR, number)')
local dr_utc_mon = iDataRef:New('(E:ZULU MONTH OF YEAR, number)')
local dr_utc_day = iDataRef:New('(E:ZULU DAY OF MONTH, number)')

local dr_utc_sec = iDataRef:New('(E:ZULU TIME, second)')

local dr_running_et = iDataRef:New('(L:INI_ET_STARTED, number)')
local dr_et_min = iDataRef:New('(L:INI_ET_MINUTE, number)')
local dr_et_hr = iDataRef:New('(L:INI_ET_HOUR, number)')

local dr_utc_is_date = iDataRef:New('(L:INI_CLOCK_DATE_BUTTON)')

local gChrono = ""
local gUtc = ""
local elapsed_time = ""
function Wwagp_GA_LCD_Loop()
	--Chrone
	if dr_chrono_sec:ChangedUpdate() or dr_running_chrono:ChangedUpdate() or dr_chrono_min:ChangedUpdate() then
		local chr = dr_chrono_sec:GetOld()
		local chr_min = dr_chrono_min:GetOld()
		local chr_is_run = dr_running_chrono:GetOld()
		if chr_is_run == 0 then
			gChrono = "     "
		else
			chr = chr + chr_min * 60
			gChrono = wcagp:formatChronoStr(chr)
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
			gUtc = string.format("%02d:%02d:%02d", mm, dr_utc_day:GetOld(), yy)
		end
	else
		if dr_utc_sec:ChangedUpdate() then
			local totalSeconds = math.floor(dr_utc_sec:GetOld())
			local h = math.floor(totalSeconds / 3600)
			local m = math.floor((totalSeconds % 3600) / 60)
			local s = totalSeconds % 60
			gUtc = string.format("%02d:%02d:%02d", h, m, s)
		end
	end

	-- ET
	if dr_et_min:ChangedUpdate() or dr_et_hr:ChangedUpdate() or dr_running_et:ChangedUpdate() then
		local m = math.floor(dr_et_min:GetOld())
		local h = math.floor(dr_et_hr:GetOld())
		local et_is_run = dr_running_et:GetOld()
		if et_is_run == 0 then
			elapsed_time = "     "
		else
			elapsed_time = string.format("%02d:%02d", h, m)
		end
	end

	-- Write to hardware
	wcagp:setLcdStr(gChrono, gUtc, elapsed_time)
end

-- =====Annunciator test
local dr_test = iDataRef:New("(L:INI_ANNLT_SWITCH, number)") -- 0: TEST 1:BRT: 2: DIM
local dr_power = iDataRef:New("(L:INI_battery_on, number)")  -- 0: OFF 1: ON

GlobalFrameLoopManager:add(function()
	-- expert code: cold and dark
	local b_power
	if dr_power:ChangedUpdate() then
		b_power = dr_power:GetOld()
		if b_power == 0 then
			wcagp:PowerOff()
			wcagp:FreshBkl()
			wcagp:FreshDigiBkl()
			wcagp:FreshLedBkl()
			wcagp:FreshBits()
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
			wcagp:setLcdStrTest()
			wcagp:SetBkl()
			wcagp:Setleds(0, 1)
		elseif b_test == 2 then
			-- DIM
			wcagp:SetLedBkl(30)
		else
			wcagp:FreshBkl()
			wcagp:FreshDigiBkl()
			wcagp:FreshLedBkl()
			wcagp:FreshBits()
		end
	else
		b_test = dr_test:Get()
	end

	if b_test == 0 then
		--test mode don't need refresh data
		return
	end
	wcagp:SetBkl()
	wcagp:SetDigiBkl()
	wcagp:SetLedBkl()
	Wwagp_GA_LCD_Loop()
	-- update LEDs
	wcagp:Setleds()
end)
