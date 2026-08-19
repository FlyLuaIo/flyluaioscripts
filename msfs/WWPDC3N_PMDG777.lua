-- *****************************************************************
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-08-19
-- WinWing PDC3N (captain / 3N L) for PMDG 777 (USB HID WwPdc3n)
-- MSFS RPN from: PMDG 777 WINWING PAP3 MCP and PFP3N.mfproj (ND controller section)
-- *****************************************************************

if ilua_require_pmdg_777() then return end

-- Do not remove below lines: hardware detection
local wwpdc3n = com.sim.qm.Wwpdc3n.Open()
if not wwpdc3n then return end
-- Do not remove above lines: hardware detection

uluaLog('Wwpdc3n for PMDG777 (capt)')

-------------------- Input Keys Binding ---------------------
-- Push buttons (Button 1..9 -> bits 0..8)
-- Note: 777 uses different keycodes than 737; using standard NAV keys where available
wwpdc3n:CfgRpn(0, '19301 (>K:ROTOR_BRAKE)') -- FPV
wwpdc3n:CfgRpn(1, '19401 (>K:ROTOR_BRAKE)') -- MTRS
wwpdc3n:CfgRpn(2, '19501 (>K:ROTOR_BRAKE)') -- WXR
wwpdc3n:CfgRpn(3, '19601 (>K:ROTOR_BRAKE)') -- STA
wwpdc3n:CfgRpn(4, '19701 (>K:ROTOR_BRAKE)') -- WPT
wwpdc3n:CfgRpn(5, '19801 (>K:ROTOR_BRAKE)') -- ARPT
wwpdc3n:CfgRpn(6, '19901 (>K:ROTOR_BRAKE)') -- DATA
wwpdc3n:CfgRpn(7, '20001 (>K:ROTOR_BRAKE)') -- POS
wwpdc3n:CfgRpn(8, '20101 (>K:ROTOR_BRAKE)') -- TERR

-- VOR1 selector (Buttons 10..12 -> bits 9..11: VOR / OFF / ADF)
local pswh_efisvor1 = QmdevPosSwitchInit("(L:switch_184_a, number)", 50, "18401 (>K:ROTOR_BRAKE)",
	"18402 (>K:ROTOR_BRAKE)", 300)
wwpdc3n:CfgPSw(9, pswh_efisvor1, 0)
wwpdc3n:CfgPSw(10, pswh_efisvor1, 50)
wwpdc3n:CfgPSw(11, pswh_efisvor1, 100)

-- VOR2 selector (Buttons 13..15 -> bits 12..14: VOR / OFF / ADF)
local pswh_efisvor2 = QmdevPosSwitchInit("(L:switch_189_a, number)", 50, "18901 (>K:ROTOR_BRAKE)",
	"18902 (>K:ROTOR_BRAKE)", 300)
wwpdc3n:CfgPSw(12, pswh_efisvor2, 0)
wwpdc3n:CfgPSw(13, pswh_efisvor2, 50)
wwpdc3n:CfgPSw(14, pswh_efisvor2, 100)

-- Push buttons (Buttons 16..19 -> bits 15..18)
wwpdc3n:CfgRpn(15, '18101 (>K:ROTOR_BRAKE)') -- MINS push (CAP)
wwpdc3n:CfgRpn(16, '18601 (>K:ROTOR_BRAKE)') -- CTR
wwpdc3n:CfgRpn(17, '18801 (>K:ROTOR_BRAKE)') -- TFC
wwpdc3n:CfgRpn(18, '19201 (>K:ROTOR_BRAKE)') -- BARO push (STD)

-- MINS/BARO fast-repeat knobs (Buttons 20..23 -> bits 19..22)
-- 777 variant: accumulate L:CAMinsKnob / L:CABaroKnob, reset on release
wwpdc3n:CfgRpn(19, '(L:CAMinsKnob, number) 50 - -50 max (>L:CAMinsKnob, number)', '0 (>L:CAMinsKnob, number)')
wwpdc3n:CfgRpn(20, '(L:CAMinsKnob, number) 50 + 50 min (>L:CAMinsKnob, number)', '0 (>L:CAMinsKnob, number)')

wwpdc3n:CfgRpn(21, '(L:CABaroKnob, number) 50 - -50 max (>L:CABaroKnob, number)', '0 (>L:CABaroKnob, number)')
wwpdc3n:CfgRpn(22, '(L:CABaroKnob, number) 50 + 50 min (>L:CABaroKnob, number)', '0 (>L:CABaroKnob, number)')

-- MINS RADIO/BARO selector (Buttons 24/25 -> bits 23/24)
-- 777: use long press toggle via key_36 style pattern
wwpdc3n:CfgRpn(23, '(L:switch_181_a, number) 0 != if{ 18101 (>K:ROTOR_BRAKE) }') -- RADIO
wwpdc3n:CfgRpn(24, '(L:switch_181_a, number) 0 == if{ 18101 (>K:ROTOR_BRAKE) }') -- BARO

-- BARO IN/HPA selector (Buttons 26/27 -> bits 25/26)
wwpdc3n:CfgRpn(25, '(L:switch_257_a, number) 0 != if{ 25701 (>K:ROTOR_BRAKE) }') -- IN
wwpdc3n:CfgRpn(26, '(L:switch_257_a, number) 0 == if{ 25701 (>K:ROTOR_BRAKE) }') -- HPA

-- MODE rotary (Buttons 28..31 -> bits 27..30: APP / VOR / MAP / PLN)
local pswh_efismode = QmdevPosSwitchInit("(L:switch_185_a, number)", 10, "18507 (>K:ROTOR_BRAKE)",
	"18508 (>K:ROTOR_BRAKE)", 300)
wwpdc3n:CfgPSw(27, pswh_efismode, 0)
wwpdc3n:CfgPSw(28, pswh_efismode, 10)
wwpdc3n:CfgPSw(29, pswh_efismode, 20)
wwpdc3n:CfgPSw(30, pswh_efismode, 30)

-- Range rotary (Buttons 32..39 -> bits 31..38: 5..640nm)
-- 777: 7 range positions like 737
local pswh_efisrange = QmdevPosSwitchInit("(L:switch_187_a, number)", 10, "18707 (>K:ROTOR_BRAKE)",
	"18708 (>K:ROTOR_BRAKE)", 300)
wwpdc3n:CfgPSw(31, pswh_efisrange, 0)
wwpdc3n:CfgPSw(32, pswh_efisrange, 0)
wwpdc3n:CfgPSw(33, pswh_efisrange, 10)
wwpdc3n:CfgPSw(34, pswh_efisrange, 20)
wwpdc3n:CfgPSw(35, pswh_efisrange, 30)
wwpdc3n:CfgPSw(36, pswh_efisrange, 40)
wwpdc3n:CfgPSw(37, pswh_efisrange, 50)
wwpdc3n:CfgPSw(38, pswh_efisrange, 60)

-- MINS / BARO knob turns (Buttons 40..45 -> bits 39..44)
-- onHold repeats the same ROTOR_BRAKE step (keysmap fast-repeat)
wwpdc3n:CfgRpn(39, '-1 (>L:CAMinsKnob, number)') -- MINS DEC
wwpdc3n:CfgRpn(40, '0 (>L:CAMinsKnob,number)')   -- MINS Neutral
wwpdc3n:CfgRpn(41, '1 (>L:CAMinsKnob, number)')  -- MINS INC
wwpdc3n:CfgRpn(42, '1 (>L:CABaroKnob,number)')   -- BARO DEC
wwpdc3n:CfgRpn(43, '0 (>L:CABaroKnob,number)')   -- BARO Neutral
wwpdc3n:CfgRpn(44, '1 (>L:CABaroKnob,number)')   -- BARO INC

-------------------- Backlight ---------------------
-- mfproj BACKLIGHT: uses panel brightness; HID BKL takes 0..255
wwpdc3n:GetBkl('(L:BL_MCP, number)', 255)

local dr_power
if uluaFind('pmdg/ng3/data/MCP_indication_powered') then
	dr_power = iDataRef:New('pmdg/ng3/data/MCP_indication_powered')
else
	dr_power = iDataRef:New('pmdg/ng3/data/ELEC_BusPowered[3]')
end


GlobalFrameLoopManager:add(function()
	-- Avoid flooding USB HID with unchanged backlight values
	-- if dr_power:ChangedUpdate() then
	-- 	wwpdc3n:SetBkl(0)
	-- end

	wwpdc3n:SetBkl()
end)
