-- *****************************************************************
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-04-16
-- Modify by Carson Lou <carsonlu@sohu.com> 2026-05-09
-- *****************************************************************

if ilua_is_acfpath_excluded('PMDG') or ilua_is_acfpath_excluded('777') then
	return
end

-- Do not remove below lines: hardware detection
local wwagp = com.sim.qm.Wwagp:new()
if not wwagp:Init() then
	return
end
-- Do not remove above lines: hardware detection

uluaLog('WinWing AGP for PMDG777')

--================================ Output key binding
--
--================================ Output key binding
-- BRK FAN as FLAP OVRD
wwagp:CfgRpn(0,
	'(L:switch_302_a, number) 100 != if{ 30201 (>K:ROTOR_BRAKE) } els{ 30203 (>K:ROTOR_BRAKE) } 30100 1 + (>K:ROTOR_BRAKE)',
	'30100 1 + (>K:ROTOR_BRAKE) (L:switch_302_a, number) 0 != if{ 30201 (>K:ROTOR_BRAKE) }')
-- autobrake
local dr_autobrake = iDataRef:New('(L:switch_292_a, number)')
local pswh_autobrake = QmdevPosSwitchInit("(L:switch_292_a, number)", 10, "29207 (>K:ROTOR_BRAKE)",
	"29208 (>K:ROTOR_BRAKE)", 100)

function autobrake_low()
	if dr_autobrake:Get() == 10 then
		QmdevPosSwitchSet(pswh_autobrake, 30)
	else
		QmdevPosSwitchSet(pswh_autobrake, 10)
	end
end

function autobrake_med()
	if dr_autobrake:Get() == 10 then
		QmdevPosSwitchSet(pswh_autobrake, 40)
	else
		QmdevPosSwitchSet(pswh_autobrake, 10)
	end
end

wwagp:CfgFc(2, 'autobrake_low()')
wwagp:CfgFc(3, 'autobrake_med()')

function key_max_long_func()
	if dr_autobrake:Get() == 10 then
		QmdevPosSwitchSet(pswh_autobrake, 0)
	else
		QmdevPosSwitchSet(pswh_autobrake, 10)
	end
end

function key_max_short_func()
	if dr_autobrake:Get() == 10 then
		QmdevPosSwitchSet(pswh_autobrake, 70)
	else
		QmdevPosSwitchSet(pswh_autobrake, 10)
	end
end

wwagp:CfgLongFc(4, 1000, key_max_long_func, key_max_short_func)
-- SKID
wwagp:CfgRpn(5, '29900 1 + (>K:ROTOR_BRAKE) (L:switch_300_a, number) 0 != if{ 30001 (>K:ROTOR_BRAKE) }',
	'(L:switch_300_a, number) 100 != if{ 30001 (>K:ROTOR_BRAKE) } els{ 30003 (>K:ROTOR_BRAKE) } 29900 1 + (>K:ROTOR_BRAKE)')
-- TERR
wwagp:CfgRpn(22, "20101 (>K:ROTOR_BRAKE)", "20104 (>K:ROTOR_BRAKE)")

wwagp:CfgRpn(23, '(>K:GEAR_UP)', '(>K:GEAR_DOWN)')


--====backlight
wwagp:GetBkl('(L:BL_MCP, number) 100 * near', 2)
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
wwagp:GetBrakeOn('(L:switch_301_a)')
wwagp:GetLowD('cpuwolf/flyluaio/WwAgp/condbtn[1]')
wwagp:GetMedD('cpuwolf/flyluaio/WwAgp/condbtn[1]')
wwagp:GetMaxD('cpuwolf/flyluaio/WwAgp/condbtn[1]')
wwagp:GetLow('(L:switch_292_a) 30 ==')
wwagp:GetMed('(L:switch_292_a) 40 ==')
wwagp:GetMax('(L:switch_292_a) 70 == (L:switch_292_a) 0 == or')
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
