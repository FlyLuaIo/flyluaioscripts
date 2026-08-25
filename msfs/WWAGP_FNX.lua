-- *****************************************************************
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-08-11
-- WinWing AGP for Fenix A320 (USB HID WwAgp)
-- MSFS RPN from: Fenix-A320 AGP and ECAM.mfproj (Winwing AGP only)
-- *****************************************************************

if ilua_require_fenix_a320() then return end

-- Do not remove below lines: hardware detection
local wwagp = com.sim.qm.Wwagp.Open()
if not wwagp then return end
-- Do not remove above lines: hardware detection

uluaLog('WinWing AGP for Fenix')

--================================ Output key binding
-- BRK FAN (Button 1 → bit 0)
wwagp:CfgRpn(0, '1 (>L:S_MIP_BRAKE_FAN)', '0 (>L:S_MIP_BRAKE_FAN)')
-- autobrake LO / MED / MAX (Buttons 3..5 → bits 2..4)
wwagp:CfgRpn(2, '1 (>L:S_MIP_AUTOBRAKE_LO)', '0 (>L:S_MIP_AUTOBRAKE_LO)')
wwagp:CfgRpn(3, '1 (>L:S_MIP_AUTOBRAKE_MED)', '0 (>L:S_MIP_AUTOBRAKE_MED)')
wwagp:CfgRpn(4, '1 (>L:S_MIP_AUTOBRAKE_MAX)', '0 (>L:S_MIP_AUTOBRAKE_MAX)')
-- A/SKID ON / OFF (Buttons 6..7 → bits 5..6); press only (mfproj release mistyped AUTOBRAKE_LO)
wwagp:CfgRpn(5, '1 (>L:S_FC_MIP_ANTI_SKID)')
wwagp:CfgRpn(6, '0 (>L:S_FC_MIP_ANTI_SKID)')
-- RST / CHR / DATE (Buttons 9 / 12 / 15 → bits 8 / 11 / 14)
wwagp:CfgRpn(8, '1 (>L:S_MIP_CLOCK_RST)', '0 (>L:S_MIP_CLOCK_RST)')
wwagp:CfgRpn(11, '1 (>L:S_MIP_CLOCK_CHR)', '0 (>L:S_MIP_CLOCK_CHR)')
wwagp:CfgRpn(14, '1 (>L:S_MIP_CLOCK_SET)', '0 (>L:S_MIP_CLOCK_SET)')
-- DATE DEC / INC (Buttons 14 / 16 → bits 13 / 15)
wwagp:CfgRpn(13, '(L:E_MIP_CLOCK_SET) -- (>L:E_MIP_CLOCK_SET)')
wwagp:CfgRpn(15, '(L:E_MIP_CLOCK_SET) ++ (>L:E_MIP_CLOCK_SET)')
-- UTC selector GPS / INT / SET (Buttons 17..19 → bits 16..18)
wwagp:CfgRpn(16, '0 (>L:S_MIP_CLOCK_UTC)')
wwagp:CfgRpn(17, '1 (>L:S_MIP_CLOCK_UTC)')
wwagp:CfgRpn(18, '2 (>L:S_MIP_CLOCK_UTC)')
-- ET RUN / STP / RST (Buttons 20..22 → bits 19..21)
wwagp:CfgRpn(19, '0 (>L:S_MIP_CLOCK_ET)')
wwagp:CfgRpn(20, '1 (>L:S_MIP_CLOCK_ET)')
wwagp:CfgRpn(21, '2 (>L:S_MIP_CLOCK_ET)')
-- TERR ON ND both CPT+FO (Button 23 → bit 22)
wwagp:CfgRpn(22,
	'1 (>L:S_MIP_GPWS_TERRAIN_ON_ND_CAPT) 1 (>L:S_MIP_GPWS_TERRAIN_ON_ND_FO)',
	'0 (>L:S_MIP_GPWS_TERRAIN_ON_ND_CAPT) 0 (>L:S_MIP_GPWS_TERRAIN_ON_ND_FO)')
-- Gear up / down (Buttons 24 / 25 → bits 23 / 24)
wwagp:CfgRpn(23, '0 (>L:S_MIP_GEAR)')
wwagp:CfgRpn(24, '1 (>L:S_MIP_GEAR)')

--====backlight
wwagp:GetBkl('(L:A_PED_LIGHTING_PEDESTAL)', 255)           -- 0~1
wwagp:GetDigiBkl('(L:B_ELEC_BUS_POWER_AC_ESS, Bool)', 200) -- 0~1
wwagp:GetLedBkl('(L:B_PED_RMP1_POWER, Bool)', 200)         -- 0~1
--================================ Input LED/LCD ===
-- Gear 1=L, 2=N, 3=R
wwagp:GetUlockL('(L:I_MIP_GEAR_1_U)')
wwagp:GetUlockN('(L:I_MIP_GEAR_2_U)')
wwagp:GetUlockR('(L:I_MIP_GEAR_3_U)')
wwagp:GetBrakeHot('(L:I_MIP_BRAKE_FAN_U)')
wwagp:GetLockL('(L:I_MIP_GEAR_1_L)')
wwagp:GetLockN('(L:I_MIP_GEAR_2_L)')
wwagp:GetLockR('(L:I_MIP_GEAR_3_L)')
wwagp:GetBrakeOn('(L:I_MIP_BRAKE_FAN_L)')
wwagp:GetLowD('(L:I_MIP_AUTOBRAKE_LO_U)')
wwagp:GetMedD('(L:I_MIP_AUTOBRAKE_MED_U)')
wwagp:GetMaxD('(L:I_MIP_AUTOBRAKE_MAX_U)')
wwagp:GetLow('(L:I_MIP_AUTOBRAKE_LO_L)')
wwagp:GetMed('(L:I_MIP_AUTOBRAKE_MED_L)')
wwagp:GetMax('(L:I_MIP_AUTOBRAKE_MAX_L)')
wwagp:GetTerr('(L:I_MIP_GPWS_TERRAIN_ON_ND_CAPT_L)')
wwagp:GetLever('cpuwolf/flyluaio/WwAgp/condbtn[1]')

--====LCD (packed N_* from mfproj LcdDisplay sources)
local dr_chrono = iDataRef:New('(L:N_MIP_CLOCK_CHRONO, Number)')
local dr_utc = iDataRef:New('(L:N_MIP_CLOCK_UTC, Number)')
local dr_et = iDataRef:New('(L:N_MIP_CLOCK_ELAPSED, Number)')

local gChrono = ''
local gUtc = ''
local elapsed_time = ''

local function fmt_mmss(v)
	local n = math.floor(tonumber(v) or 0)
	return string.format('%02d:%02d', math.floor(n / 100), n % 100)
end

local function fmt_hhmmss(v)
	local n = math.floor(tonumber(v) or 0)
	local h = math.floor(n / 10000)
	local m = math.floor(n / 100) % 100
	local s = n % 100
	return string.format('%02d:%02d:%02d', h, m, s)
end

function Wwagp_GA_LCD_Loop()
	if dr_chrono:ChangedUpdate() then
		local v = dr_chrono:GetOld()
		if v < 0 then
			gChrono = '     '
		else
			gChrono = fmt_mmss(v)
		end
	end

	if dr_utc:ChangedUpdate() then
		local v = dr_utc:GetOld()
		if v < 0 then
			gUtc = '     '
		else
			gUtc = fmt_hhmmss(v)
		end
	end

	if dr_et:ChangedUpdate() then
		local v = dr_et:GetOld()
		if v < 0 then
			elapsed_time = '     '
		else
			elapsed_time = fmt_mmss(v)
		end
	end

	wwagp:setLcdStr(gChrono, gUtc, elapsed_time)
end

-- =====Annunciator test
local dr_test = iDataRef:New('(L:S_OH_IN_LT_ANN_LT)')                -- 0: DIM 1: BRT 2: test
local dr_power = iDataRef:New('(L:B_ELEC_BUS_POWER_DC_BAT, Bool)')   -- 0: OFF 1: ON
local dr_acpower = iDataRef:New('(L:B_ELEC_BUS_POWER_AC_ESS, Bool)') -- 0: OFF 1: ON

GlobalFrameLoopManager:add(function()
	-- expert code: cold and dark
	local b_power
	if dr_power:ChangedUpdate() then
		b_power = dr_power:GetOld()
		if b_power == 0 then
			wwagp:PowerOff()
		else
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
	-- expert code: cold and dark
	local b_power_ac
	if dr_acpower:ChangedUpdate() then
		b_power_ac = dr_acpower:GetOld()
		if b_power_ac == 0 then
			wwagp:SetBkl(0)
		else
			wwagp:FreshBkl()
		end
	else
		b_power_ac = dr_acpower:Get()
	end
	if b_power_ac ~= 0 then
		wwagp:SetBkl()
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
	
	wwagp:SetDigiBkl()
	wwagp:SetLedBkl()
	Wwagp_GA_LCD_Loop()
	-- update LEDs
	wwagp:Setleds()
end)
