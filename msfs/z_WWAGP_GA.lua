-- *****************************************************************
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-04-16
-- *****************************************************************

-- Do not remove below lines: hardware detection
local wwagp = com.sim.qm.Wwagp:new()
if not wwagp:Init() then
	return
end
-- Do not remove above lines: hardware detection

uluaLog('WinWing AGP for GA')

--================================ Output key binding
wwagp:CfgCmd(8, 'sim/instruments/chrono1_reset')
wwagp:CfgCmd(11, 'sim/instruments/chrono1_start_stop')

wwagp:CfgCmd(23, 'sim/flight_controls/landing_gear_up', 'sim/flight_controls/landing_gear_down')


--====backlight
wwagp:GetBkl('(A:LIGHT POTENTIOMETER:3, Percent)', 126)

--================================ Input LED/LCD ===
wwagp:GetUlockL("(L:MSATR_GEAR_LEFT_UNLK_LT)")
wwagp:GetUlockN("(L:MSATR_GEAR_NOSE_UNLK_LT)")
wwagp:GetUlockR("(L:MSATR_GEAR_RIGHT_UNLK_LT)")
wwagp:GetBrakeHot('cpuwolf/qmdev/WwAgp/condbtn[1]')
wwagp:GetLockL("(A:GEAR LEFT POSITION, percent over 100)")
wwagp:GetLockN("(A:GEAR CENTER POSITION, percent over 100)")
wwagp:GetLockR("(A:GEAR RIGHT POSITION, percent over 100)")
wwagp:GetBrakeOn('cpuwolf/qmdev/WwAgp/condbtn[1]')
wwagp:GetLowD('cpuwolf/qmdev/WwAgp/condbtn[1]')
wwagp:GetMedD('cpuwolf/qmdev/WwAgp/condbtn[1]')
wwagp:GetMaxD('cpuwolf/qmdev/WwAgp/condbtn[1]')
wwagp:GetLow('(L:A32NX_AUTOBRAKES_ARMED_MODE, Number) 1 ==')
wwagp:GetMed('(L:A32NX_AUTOBRAKES_ARMED_MODE, Number) 2 ==')
wwagp:GetMax('(L:A32NX_AUTOBRAKES_ARMED_MODE, Number) 3 ==')
wwagp:GetTerr('(L:A32NX_EFIS_TERR_L_ACTIVE)')
wwagp:GetLever('cpuwolf/qmdev/WwAgp/condbtn[1]')



--====LCD
local dr_chrono = iDataRef:New('(E:SIMULATION TIME, second)')

local dr_utc_days = iDataRef:New('(E:ZULU YEAR,number)')

local dr_utc_hr = iDataRef:New('(E:ZULU TIME,second)')
local dr_utc_min = iDataRef:New('(E:ZULU TIME,second)')
local dr_utc_sec = iDataRef:New('(E:ZULU TIME,second)')

local dr_et_hr = iDataRef:New('(E:SIMULATION TIME, second)')
local dr_et_min = iDataRef:New('(E:SIMULATION TIME, second)')

local dr_utc_is_date = iDataRef:New('cpuwolf/qmdev/WwAgp/keysmap[14]')

local gChrono = ""
local utc = ""
local elapsed_time = ""
function Wwagp_GA_LCD_Loop()
	--Chrone
	if dr_chrono:ChangedUpdate() then
		local chr = dr_chrono:GetOld()
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

function Wwagp_GA_Loop_Upd()
	wwagp:SetBkl()
	Wwagp_GA_LCD_Loop()
	-- update LEDs
	wwagp:Setleds()
end

uluaAddDoLoop('Wwagp_GA_Loop_Upd()')
