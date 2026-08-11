-- *****************************************************************
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-08-11
-- WinWing URSA Minor Throttle+PAC for Fenix A320 (USB HID WwUrsa)
-- MSFS RPN from: Fenix-A320 URSA MINOR Throttle and PAC.mfproj
-- *****************************************************************

if ilua_require_fenix_a320() then return end

-- Do not remove below lines: hardware detection
local wwursa = com.sim.qm.Wwursa.Open()
if not wwursa then return end
-- Do not remove above lines: hardware detection

uluaLog('Wwursa for Fenix')

-------------------- Input Keys Binding ---------------------
-- ENG MASTER 1/2 (Buttons 0..3 → bits 0..3)
wwursa:CfgRpn(0, '1 (>L:S_ENG_MASTER_1)')
wwursa:CfgRpn(1, '0 (>L:S_ENG_MASTER_1)')
wwursa:CfgRpn(2, '1 (>L:S_ENG_MASTER_2)')
wwursa:CfgRpn(3, '0 (>L:S_ENG_MASTER_2)')
-- ENG MODE CRANK / NORM / START (Buttons 6..8 → bits 6..8)
wwursa:CfgRpn(6, '0 (>L:S_ENG_MODE)')
wwursa:CfgRpn(7, '1 (>L:S_ENG_MODE)')
wwursa:CfgRpn(8, '2 (>L:S_ENG_MODE)')
-- A/THR disconnect L/R (Buttons 9..10 → bits 9..10)
wwursa:CfgRpn(9,
	'(L:S_FC_THR_INST_DISCONNECT1) ++ (>L:S_FC_THR_INST_DISCONNECT1)',
	'(L:S_FC_THR_INST_DISCONNECT1) s0 2 % 0 != if{ l0 ++ (>L:S_FC_THR_INST_DISCONNECT1) }')
wwursa:CfgRpn(10,
	'(L:S_FC_THR_INST_DISCONNECT2) ++ (>L:S_FC_THR_INST_DISCONNECT2)',
	'(L:S_FC_THR_INST_DISCONNECT2) s0 2 % 0 != if{ l0 ++ (>L:S_FC_THR_INST_DISCONNECT2) }')
-- Rudder trim RST / L / R (Buttons 24/25/27 → bits 24/25/27)
wwursa:CfgRpn(24, '1 (>L:S_FC_RUDDER_TRIM_RESET)', '0 (>L:S_FC_RUDDER_TRIM_RESET)')
-- rocker: press direction, release center (mfproj release kept same value — corrected)
wwursa:CfgRpn(25, '0 (>L:S_FC_RUDDER_TRIM)', '1 (>L:S_FC_RUDDER_TRIM)')
wwursa:CfgRpn(27, '2 (>L:S_FC_RUDDER_TRIM)', '1 (>L:S_FC_RUDDER_TRIM)')
-- Parking brake OFF / ON (Buttons 28..29 → bits 28..29)
wwursa:CfgRpn(28, '0 (>L:S_MIP_PARKING_BRAKE)')
wwursa:CfgRpn(29, '1 (>L:S_MIP_PARKING_BRAKE)')
-- Flaps 4..0 (Buttons 30..34 → bits 30..34)
wwursa:CfgRpn(30, '4 (>L:S_FC_FLAPS)')
wwursa:CfgRpn(31, '3 (>L:S_FC_FLAPS)')
wwursa:CfgRpn(32, '2 (>L:S_FC_FLAPS)')
wwursa:CfgRpn(33, '1 (>L:S_FC_FLAPS)')
wwursa:CfgRpn(34, '0 (>L:S_FC_FLAPS)')
-- Spoiler arm while held (Button 38 → bit 38)
wwursa:CfgRpn(38, '0 (>L:A_FC_SPEEDBRAKE)', '1 (>L:A_FC_SPEEDBRAKE)')
-- Analog axes (throttle / spoiler) stay in sim / HID assignment — not CfgRpn

--====backlight / LEDs
-- GetOverallBkl drives Throttle ch2 (OVERALL brightness master gate) which mirrors
-- to PAC ch2 (LCD brightness) via SendLedCmd; do NOT add GetLcdBkl (same target)
wwursa:GetBkl('(L:A_PED_LIGHTING_PEDESTAL)', 250)
wwursa:GetOverallBkl('(L:A_PED_LIGHTING_PEDESTAL)', 250)
wwursa:GetFault1('(L:I_ENG_FAULT_1)')
wwursa:GetFire1('(L:I_ENG_FIRE_1)')
wwursa:GetFault2('(L:I_ENG_FAULT_2)')
wwursa:GetFire2('(L:I_ENG_FIRE_2)')
wwursa:GetVibL('(A:SIM ON GROUND,Bool)')
wwursa:GetVibR('(A:SIM ON GROUND,Bool)')

--====LCD
local dr_trim = iDataRef:New('(L:N_FC_RUDDER_TRIM_DECIMAL, Number)')
local dr_test = iDataRef:New('(L:S_OH_IN_LT_ANN_LT)') -- 0: DIM 1: BRT 2: test
local dr_power = iDataRef:New('(L:B_ELEC_BUS_POWER_AC_ESS, Bool)')

function Wwursa_FNX_LCD_Loop()
	-- mfproj: (L:N_FC_RUDDER_TRIM_DECIMAL) 10 /
	local trim = (dr_trim:Get() or 0) / 10
	wwursa:setLcdText(wwursa:formatTrimText(trim, false))
end

GlobalFrameLoopManager:add(function()
--[[ 	-- expert code: cold and dark
	local b_power
	if dr_power:ChangedUpdate() then
		b_power = dr_power:GetOld()
		if b_power == 0 then
			wwursa:Setleds(0, true)
			wwursa:FreshBits()
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
		if b_test == 2 then
			wwursa:setLcdText(wwursa:formatTrimText(0, true))
			wwursa:Setleds(0, 1)
		elseif b_test == 0 then
			wwursa:SetOverallBkl(30)
		else
			wwursa:FreshBits()
		end
	else
		b_test = dr_test:Get()
	end

	if b_test == 2 then
		return
	end ]]

	Wwursa_FNX_LCD_Loop()
	wwursa:Setleds() -- covers SetBkl/SetOverallBkl (+PAC mirror) + all boolean LEDs
end)
