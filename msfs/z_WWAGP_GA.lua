-- *****************************************************************
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-04-16
-- *****************************************************************

if ilua_require_msfs() then
	return
end

-- Do not remove below lines: hardware detection
local wwagp = com.sim.qm.Wwagp.Open()
if not wwagp then return end
-- Do not remove above lines: hardware detection

uluaLog('WinWing AGP for GA')

--================================ Output key binding
wwagp:CfgRpn(8, 'sim/instruments/chrono1_reset')
wwagp:CfgRpn(11, 'sim/instruments/chrono1_start_stop')

wwagp:CfgRpn(23, '(>K:GEAR_UP)', '(>K:GEAR_DOWN)')


--====backlight
wwagp:GetBkl('(A:LIGHT POTENTIOMETER:85, Percent)', 2)
wwagp:GetDigiBkl("(A:LIGHT POTENTIOMETER:85, Percent)", 2) -- 0~100
wwagp:GetLedBkl("(A:LIGHT POTENTIOMETER:85, Percent)", 2)  -- 0~100
--================================ Input LED/LCD ===
wwagp:GetUlockL("(L:MSATR_GEAR_LEFT_UNLK_LT)")
wwagp:GetUlockN("(L:MSATR_GEAR_NOSE_UNLK_LT)")
wwagp:GetUlockR("(L:MSATR_GEAR_RIGHT_UNLK_LT)")
wwagp:GetBrakeHot('cpuwolf/flyluaio/WwAgp/condbtn[1]')
wwagp:GetLockL("(A:GEAR LEFT POSITION, percent over 100)")
wwagp:GetLockN("(A:GEAR CENTER POSITION, percent over 100)")
wwagp:GetLockR("(A:GEAR RIGHT POSITION, percent over 100)")
wwagp:GetBrakeOn('cpuwolf/flyluaio/WwAgp/condbtn[1]')
wwagp:GetLowD('cpuwolf/flyluaio/WwAgp/condbtn[1]')
wwagp:GetMedD('cpuwolf/flyluaio/WwAgp/condbtn[1]')
wwagp:GetMaxD('cpuwolf/flyluaio/WwAgp/condbtn[1]')
wwagp:GetLow('(L:A32NX_AUTOBRAKES_ARMED_MODE, Number) 1 ==')
wwagp:GetMed('(L:A32NX_AUTOBRAKES_ARMED_MODE, Number) 2 ==')
wwagp:GetMax('(L:A32NX_AUTOBRAKES_ARMED_MODE, Number) 3 ==')
wwagp:GetTerr('(L:A32NX_EFIS_TERR_L_ACTIVE)')
wwagp:GetLever('cpuwolf/flyluaio/WwAgp/condbtn[1]')



--====LCD
local dr_chrono = iDataRef:New('(E:SIMULATION TIME, second)')

local dr_utc_year = iDataRef:New('(E:ZULU YEAR, number)')
local dr_utc_mon = iDataRef:New('(E:ZULU MONTH OF YEAR, number)')
local dr_utc_day = iDataRef:New('(E:ZULU DAY OF MONTH, number)')

local dr_utc_sec = iDataRef:New('(E:ZULU TIME, second)')

local dr_et_sec = iDataRef:New('(E:SIMULATION TIME, second)')

local dr_utc_is_date = iDataRef:New('cpuwolf/flyluaio/WwAgp/keysmap[14]')

local gChrono = ""
local gUtc = ""
local elapsed_time = ""

wwagp:FakeChrInit(2)
wwagp:FakeEtInit()
function Wwagp_GA_LCD_Loop()
	--Chrone
	gChrono = wwagp:FakeChrShow()

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
	elapsed_time = wwagp:FakeEtShow()

	-- Write to hardware
	wwagp:setLcdStr(gChrono, gUtc, elapsed_time)
end

GlobalFrameLoopManager:add(function()
	wwagp:SetBkl()
	wwagp:SetDigiBkl()
	wwagp:SetLedBkl()
	Wwagp_GA_LCD_Loop()
	-- update LEDs
	wwagp:Setleds()
end)
