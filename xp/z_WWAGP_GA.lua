-- *****************************************************************
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-03-28_11_04_16UTC
-- *****************************************************************

-- Do not remove below lines: hardware detection
local wwagp = com.sim.qm.Wwagp:new()
if not wwagp:Init() then
	return
end
-- Do not remove above lines: hardware detection

uluaLog('Wwagp for GA')

--================================ Output key binding
wwagp:CfgCmd(8, 'sim/instruments/chrono1_reset')
wwagp:CfgCmd(11, 'sim/instruments/chrono1_start_stop')

wwagp:CfgCmd(23, 'sim/flight_controls/landing_gear_up', 'sim/flight_controls/landing_gear_down')

--================================ Input LED/LCD
wwagp:GetUnlockL("cpuwolf/qmdev/WwAgp/condbtn[1]")
wwagp:GetUnlockN("cpuwolf/qmdev/WwAgp/condbtn[1]")
wwagp:GetUnlockR("cpuwolf/qmdev/WwAgp/condbtn[1]")
wwagp:GetBrakeHot('cpuwolf/qmdev/WwAgp/condbtn[1]')
wwagp:GetLockL("sim/flightmodel2/gear/deploy_ratio[1]")
wwagp:GetLockN("sim/flightmodel2/gear/deploy_ratio[0]")
wwagp:GetLockR("sim/flightmodel2/gear/deploy_ratio[2]")
wwagp:GetBrakeOn('cpuwolf/qmdev/WwAgp/condbtn[1]')
wwagp:GetLowD('cpuwolf/qmdev/WwAgp/condbtn[1]')
wwagp:GetMedD('cpuwolf/qmdev/WwAgp/condbtn[1]')
wwagp:GetMaxD('cpuwolf/qmdev/WwAgp/condbtn[1]')
wwagp:GetLow('cpuwolf/qmdev/WwAgp/condbtn[1]')
wwagp:GetMed('cpuwolf/qmdev/WwAgp/condbtn[1]')
wwagp:GetMax('cpuwolf/qmdev/WwAgp/condbtn[1]')
wwagp:GetTerr('cpuwolf/qmdev/WwAgp/condbtn[1]')
wwagp:GetLever('cpuwolf/qmdev/WwAgp/condbtn[1]')

--====LCD
local dr_chrono = iDataRef:New('sim/cockpit2/clock_timer/chrono_time[0]')

local dr_utc_days = iDataRef:New('sim/time/local_date_days')

local dr_utc_hr = iDataRef:New('sim/cockpit2/clock_timer/zulu_time_hours')
local dr_utc_min = iDataRef:New('sim/cockpit2/clock_timer/zulu_time_minutes')
local dr_utc_sec = iDataRef:New('sim/cockpit2/clock_timer/zulu_time_seconds')

local dr_et_hr = iDataRef:New('sim/cockpit2/clock_timer/hobbs_time_hours')
local dr_et_min = iDataRef:New('sim/cockpit2/clock_timer/hobbs_time_minutes')

local dr_utc_is_date = iDataRef:New('cpuwolf/qmdev/WwAgp/keysmap[14]')

local chrono = ""
local utc = ""
local elapsed_time = ""
function Wwagp_GA_LCD_Loop()
	--Chrone
	if dr_chrono:ChangedUpdate() then
		local chr = dr_chrono:GetOld()
		if chr == 0 then
			chrone = "    "
		else
			chrono = wwagp:formatChronoStr(chr)
		end
	end

	-- UTC time
	if dr_utc_is_date:ChangedUpdate() then
		dr_utc_days:Invalid()
		dr_utc_hr:Invalid()
		dr_utc_min:Invalid()
		dr_utc_sec:Invalid()
	end
	if dr_utc_is_date:GetOld() then
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
	wwagp:setLcdStr(chrono, utc, elapsed_time)
	-- update LEDs
	wwagp:Setleds()
end

function Wwagp_GA_Loop_Upd()
	Wwagp_GA_LCD_Loop()
end

uluaAddDoLoop('Wwagp_GA_Loop_Upd()')
