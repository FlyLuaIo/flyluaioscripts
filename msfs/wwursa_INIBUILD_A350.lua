-- *****************************************************************
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-08-21
-- WinWing URSA Minor Throttle for IniBuild A350 (USB HID WwUrsa)
-- MSFS RPN from: iB_A350 WW_URSA_MINOR.mfproj
-- *****************************************************************
if ilua_require_inibuild_a350() then return end

-- Do not remove below lines: hardware detection
local wwursa = com.sim.qm.Wwursa.Open()
if not wwursa then return end
-- Do not remove above lines: hardware detection

uluaLog('URSA Throttle L for IniBuild A350')

-- ===========================================================
-- button binding (Button N → bit N-1)

-- ENG MASTER 1/2 ON/OFF (Buttons 1..4 → bits 0..3)
wwursa:CfgRpn(0, '(>B:AIRLINER_ENG_MASTER_1_ON)')
wwursa:CfgRpn(1, '(>B:AIRLINER_ENG_MASTER_1_OFF)')
wwursa:CfgRpn(2, '(>B:AIRLINER_ENG_MASTER_2_ON)')
wwursa:CfgRpn(3, '(>B:AIRLINER_ENG_MASTER_2_OFF)')
-- ENG MODE CRANK / NORM / START (Buttons 7..9 → bits 6..8)
wwursa:CfgRpn(6, '0 (>L:INI_IGNITION_KNOB)')
wwursa:CfgRpn(7, '1 (>L:INI_IGNITION_KNOB)')
wwursa:CfgRpn(8, '2 (>L:INI_IGNITION_KNOB)')
-- A/THR disconnect L/R (Buttons 10..11 → bits 9..10)
wwursa:CfgRpn(9, '(>B:AIRLINER_ENG_THROTTLE_ATHR_DISC_LEFT_TOGGLE)')
wwursa:CfgRpn(10, '(>B:AIRLINER_ENG_THROTTLE_ATHR_DISC_RIGHT_TOGGLE)')

-- SPOILER ARM (Button 39 → bit 38)
wwursa:CfgRpn(38,
	'(>K:SPOILERS_ARM_ON)',
	'(>K:SPOILERS_ARM_OFF)')

-- Rudder trim RST / L / R (Buttons 25/26/28 → bits 24/25/27)
wwursa:CfgRpn(24, '(>B:AIRLINER_RUDDER_TRIM_RESET_TOGGLE)')
-- rocker: press direction, release center
wwursa:CfgRpn(25, '2 (>L:XMLVAR_RUDDERTRIM_SWITCH_1)', '1 (>L:XMLVAR_RUDDERTRIM_SWITCH_1)')
wwursa:CfgRpn(27, '0 (>L:XMLVAR_RUDDERTRIM_SWITCH_1)', '1 (>L:XMLVAR_RUDDERTRIM_SWITCH_1)')

-- Parking brake OFF / ON (Buttons 29..30 → bits 28..29, both toggle)
wwursa:CfgRpn(28, '(>K:PARKING_BRAKES)')
wwursa:CfgRpn(29, '(>K:PARKING_BRAKES)')

-- Flaps 4..0 (Buttons 31..35 → bits 30..34)
wwursa:CfgRpn(30, '(>K:FLAPS_DOWN)')
wwursa:CfgRpn(31, '(>K:FLAPS_3)')
wwursa:CfgRpn(32, '(>K:FLAPS_2)')
wwursa:CfgRpn(33, '(>K:FLAPS_1)')
wwursa:CfgRpn(34, '(>K:FLAPS_UP)')

-- Autobrake DEC (short) / INC (long hold) + ARM (Button 5..6 → bits 4..5)
wwursa:CfgRpn(4, '1 (>L:INI_RWY_COND_BRK_ACTION_SELECTOR_DEC)')
wwursa:CfgRpn(5, '1 (>L:INI_AUTOBRAKE_ARMED_CMD)')

-- ====backlight / LEDs
wwursa:GetBkl('(L:INI_CKPT_LT_INTEG)', 255)
wwursa:GetOverallBkl('(L:INI_CKPT_LT_INTEG)', 255)
wwursa:GetFault1('(L:INI_ENG_1_FAULT) 1 ==')
wwursa:GetFault2('(L:INI_ENG_2_FAULT) 1 ==')
wwursa:GetFire1('(L:INI_ENG_1_FIRE) 1 == (L:INI_FIRE_TEST) 1 == or')
wwursa:GetFire2('(L:INI_ENG_2_FIRE) 1 == (L:INI_FIRE_TEST) 1 == or')

-- ====vibration
wwursa:GetVibL('(A:SIM ON GROUND,Bool) (A:GPS GROUND SPEED,Meters per second) * 10 *')
wwursa:GetVibR('(A:SIM ON GROUND,Bool) (A:GPS GROUND SPEED,Meters per second) * 10 *')

-- ====LCD
local dr_trim = iDataRef:New('(L:RUDDER_TRIM_ACTUAL_ANGLE)')

GlobalFrameLoopManager:add(function()
	wwursa:SetBkl()
	wwursa:SetOverallBkl()
	wwursa:Setleds() -- boolean LEDs only (FAULT/FIRE)
	wwursa:SetVibL()
	wwursa:SetVibR()
	wwursa:setLcdText(wwursa:formatTrimText(dr_trim:Get(), false))
end)
