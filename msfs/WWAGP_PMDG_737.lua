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
---- BRK FAN as TERR
wwagp:CfgRpn(0,
	'(L:switch_506_73X, number) 100 != if{ 50601 (>K:ROTOR_BRAKE) } els{ 50604 (>K:ROTOR_BRAKE) } 50500 1 + (>K:ROTOR_BRAKE)',
	'50500 1 + (>K:ROTOR_BRAKE) (L:switch_506_73X, number) 0 != if{ 50601 (>K:ROTOR_BRAKE) }')

--AUTO BRAKE
local dr_autobrake = iDataRef:New('(L:switch_460_73X, number)')
local pswh_autobrake = QmdevPosSwitchInit("(L:switch_460_73X, number)", 10, "46007 (>K:ROTOR_BRAKE)",
	"46008 (>K:ROTOR_BRAKE)", 100)
function autobrake_low()
	if dr_autobrake:Get() == 10 then
		QmdevPosSwitchSet(pswh_autobrake, 20)
	else
		QmdevPosSwitchSet(pswh_autobrake, 10)
	end
end

function autobrake_med()
	if dr_autobrake:Get() == 10 then
		QmdevPosSwitchSet(pswh_autobrake, 30)
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

---- SYS
wwagp:CfgRpn(5, '50300 1 + (>K:ROTOR_BRAKE) (L:switch_504_73X, number) 0 != if{ 50401 (>K:ROTOR_BRAKE) }',
	'(L:switch_504_73X, number) 100 != if{ 50401 (>K:ROTOR_BRAKE) } els{ 50404 (>K:ROTOR_BRAKE) } 50300 1 + (>K:ROTOR_BRAKE)')

--Chrono
wwagp:CfgRpn(8, "314102 (>K:ROTOR_BRAKE)")
wwagp:CfgRpn(11, "31401 (>K:ROTOR_BRAKE)")

--ET
wwagp:CfgRpn(19, "32101 (>K:ROTOR_BRAKE)", "32101 (>K:ROTOR_BRAKE)")
wwagp:CfgRpn(21, "32001 (>K:ROTOR_BRAKE)")

-- TERR
wwagp:CfgRpn(22, "37501 (>K:ROTOR_BRAKE)")
wwagp:CfgRpn(23, '(>K:GEAR_UP)', '(>K:GEAR_DOWN)')


--====backlight
wwagp:GetBkl('(L:BL_MainCA, number) 100 * near', 2)
wwagp:GetDigiBkl("(A:LIGHT POTENTIOMETER:85, Percent)", 2) -- 0~100
wwagp:GetLedBkl("(A:LIGHT POTENTIOMETER:85, Percent)", 2)  -- 0~100
--================================ Input LED/LCD ===
wwagp:GetUlockL("(L:switch_451_73X, number)")
wwagp:GetUlockN("(L:switch_449_73X, number)")
wwagp:GetUlockR("(L:switch_452_73X, number)")
wwagp:GetBrakeHot('cpuwolf/flyluaio/WwAgp/condbtn[1]')
wwagp:GetLockL("(L:switch_453_73X, number)")
wwagp:GetLockN("(L:switch_450_73X, number)")
wwagp:GetLockR("(L:switch_454_73X, number)")
wwagp:GetBrakeOn('(L:switch_505_73X) 0 ==')
wwagp:GetLowD('cpuwolf/flyluaio/WwAgp/condbtn[1]')
wwagp:GetMedD('cpuwolf/flyluaio/WwAgp/condbtn[1]')
wwagp:GetMaxD('cpuwolf/flyluaio/WwAgp/condbtn[1]')
wwagp:GetLow('(L:switch_460_73X) 20 ==')
wwagp:GetMed('(L:switch_460_73X) 30 ==')
wwagp:GetMax('(L:switch_460_73X) 50 == (L:switch_460_73X) 0 == or')
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

wwagp:FakeChrInit()
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
