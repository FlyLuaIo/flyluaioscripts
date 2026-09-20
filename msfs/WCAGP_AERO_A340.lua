-- *****************************************************************
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-04-16
-- *****************************************************************

if ilua_require_aerosoft_a346() then return end

-- Do not remove below lines: hardware detection
local wcagp = com.sim.qm.Wcagp.Open()
if not wcagp then return end
-- Do not remove above lines: hardware detection

uluaLog('WinCtrl AGP for Aerosoft A346')

--================================ Output key binding
-- autobrake
wcagp:CfgRpn(2, "(L:AB_AutoBrake_Mode) 1 == if{ 0 } els{ 1 } (>L:AB_AutoBrake_Mode)")
wcagp:CfgRpn(3, "(L:AB_AutoBrake_Mode) 2 == if{ 0 } els{ 2 } (>L:AB_AutoBrake_Mode)")
local drf_brk_pos = iDataRef:New("(L:AB_AutoBrake_Mode)")
function key_brkmax_long_end_func()
	uluaWriteCmd('0 (>L:AB_VC_TO_PB_TRIG)')
end

function key_brkmax_long_func()
	uluaWriteCmd('1 (>L:AB_VC_TO_PB_TRIG)')
	uluasetTimeout('key_brkmax_long_end_func()', 200)
end

function key_brkmax_short_func()
	if drf_brk_pos:Get() == 5 then
		uluaWriteCmd('0 (>L:AB_AutoBrake_Mode)')
	else
		uluaWriteCmd('5 (>L:AB_AutoBrake_Mode)')
	end
end

wcagp:CfgLongFc(4, 1000, key_brkmax_long_func, key_brkmax_short_func)

wcagp:CfgRpn(5, '0 (>L:AB_ANTISKID)')
wcagp:CfgRpn(6, '1 (>L:AB_ANTISKID)')
wcagp:CfgRpn(8, '1 (>L:AB_MPL_CLOCK_RST)', '0 (>L:AB_MPL_CLOCK_RST)')
wcagp:CfgRpn(11, '1 (>L:AB_MPL_CLOCK_CHR)', '0 (>L:AB_MPL_CLOCK_CHR)')
wcagp:CfgRpn(14, '1 (>L:AB_MPL_CLOCK_DATE)', '0 (>L:AB_MPL_CLOCK_DATE)')

wcagp:CfgRpn(19, '0 (>L:AB_MPL_CLOCK_ET_SW)')
wcagp:CfgRpn(20, '1 (>L:AB_MPL_CLOCK_ET_SW)')
wcagp:CfgRpn(21, '2 (>L:AB_MPL_CLOCK_ET_SW)')

wcagp:CfgRpn(22, "(L:AB_MPL_ND_TERR) ! (>L:AB_MPL_ND_TERR)")
wcagp:CfgRpn(23, '(>K:GEAR_UP)', '(>K:GEAR_DOWN)')



--====backlight
wcagp:GetBkl('(L:TLS_INT_LT_MCDU1_INTEG_LT_LEVEL)', 100) --0~1
wcagp:GetDigiBkl("(L:TLS_FCU_AVAILABLE, Bool)", 120)     -- 0~1
wcagp:GetLedBkl("(L:TLS_FCU_AVAILABLE, Bool)", 120)      -- 0~1
--================================ Input LED/LCD ===
wcagp:GetUlockL("(L:AB_MPL_GEAR_UNLOCK_LIGHT_L)")
wcagp:GetUlockN("(L:AB_MPL_GEAR_UNLOCK_LIGHT_C) (L:AB_MPL_GEAR_UNLOCK_LIGHT_C2) or")
wcagp:GetUlockR("(L:AB_MPL_GEAR_UNLOCK_LIGHT_R)")
wcagp:GetBrakeHot('cpuwolf/flyluaio/WwAgp/condbtn[1]')
wcagp:GetLockL("(L:AB_MPL_GEAR_DOWN_LIGHT_L)")
wcagp:GetLockN("(L:AB_MPL_GEAR_DOWN_LIGHT_C) (L:AB_MPL_GEAR_DOWN_LIGHT_C2) and")
wcagp:GetLockR("(L:AB_MPL_GEAR_DOWN_LIGHT_R)")
wcagp:GetBrakeOn('cpuwolf/flyluaio/WwAgp/condbtn[1]')
wcagp:GetLowD('cpuwolf/flyluaio/WwAgp/condbtn[1]')
wcagp:GetMedD('cpuwolf/flyluaio/WwAgp/condbtn[1]')
wcagp:GetMaxD('cpuwolf/flyluaio/WwAgp/condbtn[1]')
wcagp:GetLow('(L:AB_AutoBrake_Mode) 1 ==')
wcagp:GetMed('(L:AB_AutoBrake_Mode) 2 ==')
wcagp:GetMax('(L:AB_VC_RTO_ON_LIGHT) (L:AB_AutoBrake_Mode) 5 == or')
wcagp:GetTerr('(L:AB_MPL_ND_TERR_LIGHT)')
wcagp:GetLever('(L:AB_GEARLEVER_ARROW_LIGHT)')



--====LCD
local dr_chrono = iDataRef:New('(E:SIMULATION TIME, second)')

local dr_utc_year = iDataRef:New('(E:ZULU YEAR, number)')
local dr_utc_mon = iDataRef:New('(E:ZULU MONTH OF YEAR, number)')
local dr_utc_day = iDataRef:New('(E:ZULU DAY OF MONTH, number)')

local dr_utc_sec = iDataRef:New('(E:ZULU TIME, second)')

local dr_et_sec = iDataRef:New('(E:SIMULATION TIME, second)')

local dr_utc_is_date = iDataRef:New('(L:AB_MPL_CLOCK_DATE)')

local gChrono = ""
local gUtc = ""
local elapsed_time = ""
function Wwagp_GA_LCD_Loop()
	--Chrone
	if dr_chrono:ChangedUpdate() then
		local chr = dr_chrono:GetOld()
		if math.floor(chr) == 0 then
			gChrono = "     "
		else
			gChrono = wcagp:formatChronoStr(chr)
			gChrono = "CPU"
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
	if dr_et_sec:ChangedUpdate() then
		local totalSeconds = math.floor(dr_et_sec:GetOld())
		local h = math.floor(totalSeconds / 3600)
		local m = math.floor((totalSeconds % 3600) / 60)
		elapsed_time = string.format("%02d:%02d", h, m)
	end
	elapsed_time = "UULF"

	-- Write to hardware
	wcagp:setLcdStr(gChrono, gUtc, elapsed_time)
end

-- =====Annunciator test
local dr_test = iDataRef:New("(L:AB_VC_OVH_ANN_LT_SW)")      -- 0: TEST 1:BRT: 2: DIM
local dr_power = iDataRef:New("(L:TLS_FCU_AVAILABLE, Bool)") -- 0: OFF 1: ON

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
