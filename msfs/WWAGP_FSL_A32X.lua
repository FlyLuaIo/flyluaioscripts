-- *****************************************************************
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-04-20
-- *****************************************************************

if ilua_require_fslabs_a32x() then return end

-- Do not remove below lines: hardware detection
local wwagp = com.sim.qm.Wwagp:new()
if not wwagp:Init() then
	return
end
-- Do not remove above lines: hardware detection

uluaLog('WinWing AGP for FSLabs A32X')

--================================ Output key binding
-- BRK FAN
wwagp:CfgRpn(0, '75155 (>K:ROTOR_BRAKE)', '75155 2 + (>K:ROTOR_BRAKE)')
wwagp:CfgRpn(1, '75155 (>K:ROTOR_BRAKE)', '75155 2 + (>K:ROTOR_BRAKE)')
-- autobrake
wwagp:CfgRpn(2, "75159 (>K:ROTOR_BRAKE)", "75159 2 + (>K:ROTOR_BRAKE)")
wwagp:CfgRpn(3, "75163 (>K:ROTOR_BRAKE)", "75163 2 + (>K:ROTOR_BRAKE)")
wwagp:CfgRpn(4, "75167 (>K:ROTOR_BRAKE)", "75167 2 + (>K:ROTOR_BRAKE)")
-- SKID
wwagp:CfgRpn(5, '75171 (>K:ROTOR_BRAKE)', '75171 2 + (>K:ROTOR_BRAKE)')
wwagp:CfgRpn(6, '75171 (>K:ROTOR_BRAKE)', '75171 2 + (>K:ROTOR_BRAKE)')
-- RST
wwagp:CfgRpn(8, '75135 (>K:ROTOR_BRAKE)', '75135 2 + (>K:ROTOR_BRAKE)')
-- CHR
wwagp:CfgRpn(11, '75139 (>K:ROTOR_BRAKE)', '75139 2 + (>K:ROTOR_BRAKE)')
-- DATE
wwagp:CfgRpn(14, '75143 (>K:ROTOR_BRAKE)', '75143 2 + (>K:ROTOR_BRAKE)')

wwagp:CfgRpn(16, '2 (>L:INI_CLOCK_GPS_STATE)')
wwagp:CfgRpn(17, '1 (>L:INI_CLOCK_GPS_STATE)')
wwagp:CfgRpn(18, '0 (>L:INI_CLOCK_GPS_STATE)')

wwagp:CfgRpn(19, '75150 1 + (>K:ROTOR_BRAKE)', '75151 1 + (>K:ROTOR_BRAKE)')
wwagp:CfgRpn(21, '75151 1 + (>K:ROTOR_BRAKE)', '75151 2 + (>K:ROTOR_BRAKE)')


-- Terrain FO:75092
wwagp:CfgRpn(22, "75088 (>K:ROTOR_BRAKE)", "75088 2 + (>K:ROTOR_BRAKE)")

wwagp:CfgRpn(23, '(>K:GEAR_UP)', '(>K:GEAR_DOWN)')



--====backlight
wwagp:GetBkl('(L:VC_PED_Dimmer)', 2)                      -- 0~100
wwagp:GetDigiBkl('(L:FSL_MCDU_Right_Powered, Bool)', 200) -- 0~1
wwagp:GetLedBkl('(L:FSL_MCDU_Right_Powered, Bool)', 200)  -- 0~1
--================================ Input LED/LCD ===
wwagp:GetUlockL('(L:VC_MIP_GEAR_LH_Button_TOP)')
wwagp:GetUlockN('(L:VC_MIP_GEAR_NS_Button_TOP)')
wwagp:GetUlockR('(L:VC_MIP_GEAR_RH_Button_TOP)')
wwagp:GetBrakeHot('(L:VC_MIP_BRAKES_FAN_Button_TOP)')
wwagp:GetLockL('(L:VC_MIP_GEAR_LH_Button_BOT)')
wwagp:GetLockN('(L:VC_MIP_GEAR_NS_Button_BOT)')
wwagp:GetLockR('(L:VC_MIP_GEAR_RH_Button_BOT)')
wwagp:GetBrakeOn('(L:VC_MIP_BRAKES_FAN_Button_BOT)')
wwagp:GetLowD('(L:VC_MIP_BRAKES_AUTOBRK_LO_Button_TOP)')
wwagp:GetMedD('(L:VC_MIP_BRAKES_AUTOBRK_MED_Button_TOP)')
wwagp:GetMaxD('(L:VC_MIP_BRAKES_AUTOBRK_MAX_Button_TOP)')
wwagp:GetLow('(L:VC_MIP_BRAKES_AUTOBRK_LO_Button_BOT)')
wwagp:GetMed('(L:VC_MIP_BRAKES_AUTOBRK_MED_Button_BOT)')
wwagp:GetMax('(L:VC_MIP_BRAKES_AUTOBRK_MAX_Button_BOT)')
wwagp:GetTerr('(L:VC_MIP_CPT_TERR_ON_ND_Button_BOT)')
wwagp:GetLever('(L:AB_GEARLEVER_ARROW_LIGHT)')



--====LCD
local dr_chrono_min = iDataRef:New('(L:FSL_MIP_CLOCK_CHR_MIN)')
local dr_chrono = iDataRef:New('(L:FSL_MIP_CLOCK_CHR_SEC)')

local dr_utc_year = iDataRef:New('(E:ZULU YEAR, number)')
local dr_utc_mon = iDataRef:New('(E:ZULU MONTH OF YEAR, number)')
local dr_utc_day = iDataRef:New('(E:ZULU DAY OF MONTH, number)')

local dr_utc_sec = iDataRef:New('(E:ZULU TIME, second)')

local dr_et_hr = iDataRef:New('(L:FSL_MIP_CLOCK_ET_HR)')
local dr_et_min = iDataRef:New('(L:FSL_MIP_CLOCK_ET_MIN)')

local dr_utc_is_date = iDataRef:New('(L:VC_MIP_CHRONO_DATE_SET_Button)')

local gChrono = ''
local gUtc = ''
local elapsed_time = ''
function Wwagp_GA_LCD_Loop()
	--Chrone
	if dr_chrono:ChangedUpdate() or dr_chrono_min:ChangedUpdate() then
		local chr_sec = dr_chrono:GetOld()
		local chr_min = dr_chrono_min:GetOld()
		if chr_min > 98000 then
			gChrono = '     '
		else
			gChrono = string.format('%02d:%02d', chr_min, chr_sec)
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
	if dr_et_hr:ChangedUpdate() or dr_et_min:ChangedUpdate() then
		local h = math.floor(dr_et_hr:GetOld())
		local m = math.floor(dr_et_min:GetOld())
		if h > 98000 then
			elapsed_time = '     '
		else
			elapsed_time = string.format('%02d:%02d', h, m)
		end
	end

	-- Write to hardware
	wwagp:setLcdStr(gChrono, gUtc, elapsed_time)
end

-- =====Annunciator test
local dr_test = iDataRef:New('(L:VC_OVHD_INTLT_AnnLt_Switch)')    -- 0: DIM 10: BRT 20: test mode
local dr_power = iDataRef:New('(L:FSL_MCDU_Right_Powered, Bool)') -- 0: OFF 1: ON

function Wwagp_Fsl_Loop_Upd()
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
		if b_test == 20 then
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

	if b_test == 20 then
		--test mode don't need refresh data
		return
	end
	wwagp:SetBkl()
	wwagp:SetDigiBkl()
	wwagp:SetLedBkl()
	Wwagp_GA_LCD_Loop()
	-- update LEDs
	wwagp:Setleds()
end

GlobalFrameLoopManager:add(Wwagp_Fsl_Loop_Upd)
