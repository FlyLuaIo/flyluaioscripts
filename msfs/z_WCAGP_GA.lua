-- *****************************************************************
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-04-16
-- *****************************************************************

if ilua_require_msfs() then
	return
end

-- Do not remove below lines: hardware detection
local wcagp = com.sim.qm.Wcagp.Open()
if not wcagp then return end
-- Do not remove above lines: hardware detection

uluaLog('WinCtrl AGP for GA')

--================================ Output key binding
wcagp:CfgRpn(8, 'sim/instruments/chrono1_reset')
wcagp:CfgRpn(11, 'sim/instruments/chrono1_start_stop')

wcagp:CfgRpn(23, '(>K:GEAR_UP)', '(>K:GEAR_DOWN)')


--====backlight
wcagp:GetBkl('(A:LIGHT POTENTIOMETER:85, Percent)', 2)
wcagp:GetDigiBkl("(A:LIGHT POTENTIOMETER:85, Percent)", 2) -- 0~100
wcagp:GetLedBkl("(A:LIGHT POTENTIOMETER:85, Percent)", 2)  -- 0~100
--================================ Input LED/LCD ===
wcagp:GetUlockL("(L:MSATR_GEAR_LEFT_UNLK_LT)")
wcagp:GetUlockN("(L:MSATR_GEAR_NOSE_UNLK_LT)")
wcagp:GetUlockR("(L:MSATR_GEAR_RIGHT_UNLK_LT)")
wcagp:GetBrakeHot('cpuwolf/flyluaio/WwAgp/condbtn[1]')
wcagp:GetLockL("(A:GEAR LEFT POSITION, percent over 100)")
wcagp:GetLockN("(A:GEAR CENTER POSITION, percent over 100)")
wcagp:GetLockR("(A:GEAR RIGHT POSITION, percent over 100)")
wcagp:GetBrakeOn('cpuwolf/flyluaio/WwAgp/condbtn[1]')
wcagp:GetLowD('cpuwolf/flyluaio/WwAgp/condbtn[1]')
wcagp:GetMedD('cpuwolf/flyluaio/WwAgp/condbtn[1]')
wcagp:GetMaxD('cpuwolf/flyluaio/WwAgp/condbtn[1]')
wcagp:GetLow('(L:A32NX_AUTOBRAKES_ARMED_MODE, Number) 1 ==')
wcagp:GetMed('(L:A32NX_AUTOBRAKES_ARMED_MODE, Number) 2 ==')
wcagp:GetMax('(L:A32NX_AUTOBRAKES_ARMED_MODE, Number) 3 ==')
wcagp:GetTerr('(L:A32NX_EFIS_TERR_L_ACTIVE)')
wcagp:GetLever('cpuwolf/flyluaio/WwAgp/condbtn[1]')



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

wcagp:FakeChrInit(2)
wcagp:FakeEtInit()
function Wwagp_GA_LCD_Loop()
	--Chrone
	gChrono = wcagp:FakeChrShow()

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
	elapsed_time = wcagp:FakeEtShow()

	-- Write to hardware
	wcagp:setLcdStr(gChrono, gUtc, elapsed_time)
end

GlobalFrameLoopManager:add(function()
	wcagp:SetBkl()
	wcagp:SetDigiBkl()
	wcagp:SetLedBkl()
	Wwagp_GA_LCD_Loop()
	-- update LEDs
	wcagp:Setleds()
end)
