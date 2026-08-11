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
-- ENG MASTER 1/2 (Buttons 1..4 → bits 0..3)
wwursa:CfgRpn(0, '1 (>L:S_ENG_MASTER_1)')
wwursa:CfgRpn(1, '0 (>L:S_ENG_MASTER_1)')
wwursa:CfgRpn(2, '1 (>L:S_ENG_MASTER_2)')
wwursa:CfgRpn(3, '0 (>L:S_ENG_MASTER_2)')
-- ENG MODE CRANK / NORM / START (Buttons 7..9 → bits 6..8)
wwursa:CfgRpn(6, '0 (>L:S_ENG_MODE)')
wwursa:CfgRpn(7, '1 (>L:S_ENG_MODE)')
wwursa:CfgRpn(8, '2 (>L:S_ENG_MODE)')
-- A/THR disconnect L/R (Buttons 10..11 → bits 9..10)
wwursa:CfgRpn(9,
	'(L:S_FC_THR_INST_DISCONNECT1) ++ (>L:S_FC_THR_INST_DISCONNECT1)',
	'(L:S_FC_THR_INST_DISCONNECT1) s0 2 % 0 != if{ l0 ++ (>L:S_FC_THR_INST_DISCONNECT1) }')
wwursa:CfgRpn(10,
	'(L:S_FC_THR_INST_DISCONNECT2) ++ (>L:S_FC_THR_INST_DISCONNECT2)',
	'(L:S_FC_THR_INST_DISCONNECT2) s0 2 % 0 != if{ l0 ++ (>L:S_FC_THR_INST_DISCONNECT2) }')
-- Rudder trim RST / L / R (Buttons 25/26/28 → bits 24/25/27)
wwursa:CfgRpn(24, '1 (>L:S_FC_RUDDER_TRIM_RESET)', '0 (>L:S_FC_RUDDER_TRIM_RESET)')
-- rocker: press direction, release center (mfproj release kept same value — corrected)
wwursa:CfgRpn(25, '0 (>L:S_FC_RUDDER_TRIM)', '1 (>L:S_FC_RUDDER_TRIM)')
wwursa:CfgRpn(27, '2 (>L:S_FC_RUDDER_TRIM)', '1 (>L:S_FC_RUDDER_TRIM)')
-- Parking brake OFF / ON (Buttons 29..30 → bits 28..29)
wwursa:CfgRpn(28, '0 (>L:S_MIP_PARKING_BRAKE)')
wwursa:CfgRpn(29, '1 (>L:S_MIP_PARKING_BRAKE)')
-- Flaps 4..0 (Buttons 31..35 → bits 30..34)
wwursa:CfgRpn(30, '4 (>L:S_FC_FLAPS)')
wwursa:CfgRpn(31, '3 (>L:S_FC_FLAPS)')
wwursa:CfgRpn(32, '2 (>L:S_FC_FLAPS)')
wwursa:CfgRpn(33, '1 (>L:S_FC_FLAPS)')
wwursa:CfgRpn(34, '0 (>L:S_FC_FLAPS)')
-- Spoiler arm while held (Button 39 → bit 38)
wwursa:CfgRpn(38, '0 (>L:A_FC_SPEEDBRAKE)', '1 (>L:A_FC_SPEEDBRAKE)')
-- Analog axes (throttle / spoiler) stay in sim / HID assignment — not CfgRpn

-------------------- Output ---------------------
local dr_bkl = iDataRef:New('(L:A_PED_LIGHTING_PEDESTAL)')
local dr_lcd_pwr = iDataRef:New('(L:B_FCU_POWER, Number)')
local dr_lcd_lit = iDataRef:New('(L:A_FCU_LIGHTING_TEXT, Number)')
local dr_annun = iDataRef:New('(L:S_OH_IN_LT_ANN_LT)') -- 0 DIM 1 BRT 2 test
local dr_trim = iDataRef:New('(L:N_FC_RUDDER_TRIM_DECIMAL, Number)')
local dr_fault1 = iDataRef:New('(L:I_ENG_FAULT_1)')
local dr_fire1 = iDataRef:New('(L:I_ENG_FIRE_1)')
local dr_fault2 = iDataRef:New('(L:I_ENG_FAULT_2)')
local dr_fire2 = iDataRef:New('(L:I_ENG_FIRE_2)')

GlobalFrameLoopManager:add(function()
	local test = (dr_annun:Get() or 0) == 2
	local ped = dr_bkl:Get() or 0
	if ped < 0 then ped = 0 elseif ped > 1 then ped = 1 end
	local lcdPwr = dr_lcd_pwr:Get() or 0
	local lcdLit = dr_lcd_lit:Get() or 0
	if lcdLit < 0 then lcdLit = 0 elseif lcdLit > 1 then lcdLit = 1 end
	local hasLcd = lcdPwr ~= 0
	local bkl = math.floor(ped * 255)
	local lcdBkl = hasLcd and math.floor(lcdLit * 255) or 0

	wwursa:SendLedCmd(wwursa.LEDS_BKL, bkl)
	wwursa:SendLedCmd(wwursa.LEDS_MAKER, lcdBkl)

	if test then
		wwursa:SendLedCmd(wwursa.LEDS_FAULT1, 1)
		wwursa:SendLedCmd(wwursa.LEDS_FIRE1, 1)
		wwursa:SendLedCmd(wwursa.LEDS_FAULT2, 1)
		wwursa:SendLedCmd(wwursa.LEDS_FIRE2, 1)
		wwursa:setLcdText(wwursa:formatTrimText(0, true))
		return
	end

	wwursa:SendLedCmd(wwursa.LEDS_FAULT1, ((dr_fault1:Get() or 0) ~= 0) and 1 or 0)
	wwursa:SendLedCmd(wwursa.LEDS_FIRE1, ((dr_fire1:Get() or 0) ~= 0) and 1 or 0)
	wwursa:SendLedCmd(wwursa.LEDS_FAULT2, ((dr_fault2:Get() or 0) ~= 0) and 1 or 0)
	wwursa:SendLedCmd(wwursa.LEDS_FIRE2, ((dr_fire2:Get() or 0) ~= 0) and 1 or 0)
	wwursa:SendLedCmd(wwursa.LEDS_VIBL, 0)
	wwursa:SendLedCmd(wwursa.LEDS_VIBR, 0)

	-- mfproj: (L:N_FC_RUDDER_TRIM_DECIMAL) 10 /
	local trim = (dr_trim:Get() or 0) / 10
	wwursa:setLcdText(wwursa:formatTrimText(trim, false))
end)
