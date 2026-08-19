-- *****************************************************************
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-08-12
-- WinWing PDC3N (captain / 3N L) for PMDG 737 (USB HID WwPdc3n)
-- MSFS RPN from: PMDG-737.mfproj (WINCTRL 3N PDC L only)
-- *****************************************************************

if ilua_require_pmdg_737() then return end

-- Do not remove below lines: hardware detection
local wwpdc3n = com.sim.qm.Wwpdc3n.Open()
if not wwpdc3n then return end
-- Do not remove above lines: hardware detection

uluaLog('Wwpdc3n for PMDG737 (capt)')

-------------------- Input Keys Binding ---------------------
-- Push buttons (Button 1..9 -> bits 0..8)
wwpdc3n:CfgRpn(0, '36301 (>K:ROTOR_BRAKE)') -- FPV
wwpdc3n:CfgRpn(1, '36401 (>K:ROTOR_BRAKE)') -- MTRS
wwpdc3n:CfgRpn(2, '36901 (>K:ROTOR_BRAKE)') -- WXR
wwpdc3n:CfgRpn(3, '37001 (>K:ROTOR_BRAKE)') -- STA
wwpdc3n:CfgRpn(4, '37101 (>K:ROTOR_BRAKE)') -- WPT
wwpdc3n:CfgRpn(5, '37201 (>K:ROTOR_BRAKE)') -- ARPT
wwpdc3n:CfgRpn(6, '37301 (>K:ROTOR_BRAKE)') -- DATA
wwpdc3n:CfgRpn(7, '37401 (>K:ROTOR_BRAKE)') -- POS
wwpdc3n:CfgRpn(8, '37501 (>K:ROTOR_BRAKE)') -- TERR


-- VOR1 selector (Buttons 10..12 -> bits 9..11: VOR / OFF / ADF)
local pswh_efisvor1 = QmdevPosSwitchInit("(L:switch_358_73X, number)", 10, "35801 (>K:ROTOR_BRAKE)",
	"35802 (>K:ROTOR_BRAKE)", 300)
wwpdc3n:CfgPSw(9, pswh_efisvor1, 0)
wwpdc3n:CfgPSw(10, pswh_efisvor1, 50)
wwpdc3n:CfgPSw(11, pswh_efisvor1, 100)

-- VOR2 selector (Buttons 13..15 -> bits 12..14: VOR / OFF / ADF)
local pswh_efisvor2 = QmdevPosSwitchInit("(L:switch_368_73X, number)", 10, "36801 (>K:ROTOR_BRAKE)",
	"36802 (>K:ROTOR_BRAKE)", 300)
wwpdc3n:CfgPSw(12, pswh_efisvor2, 0)
wwpdc3n:CfgPSw(13, pswh_efisvor2, 50)
wwpdc3n:CfgPSw(14, pswh_efisvor2, 100)

-- Push buttons (Buttons 16..19 -> bits 15..18)
wwpdc3n:CfgRpn(15, '35701 (>K:ROTOR_BRAKE)') -- MINS push (RST)
wwpdc3n:CfgRpn(16, '36001 (>K:ROTOR_BRAKE)') -- CTR
wwpdc3n:CfgRpn(17, '36201 (>K:ROTOR_BRAKE)') -- TFC
wwpdc3n:CfgRpn(18, '36701 (>K:ROTOR_BRAKE)') -- BARO push (STD)

-- MINS/BARO fast-repeat knobs (Buttons 20..23 -> bits 19..22)
-- mfproj FULL variants accumulate L:CAMinsKnob / L:CABaroKnob, reset on release
wwpdc3n:CfgRpn(19, '(L:CAMinsKnob,number) 50 - -50 max (>L:CAMinsKnob,number)', '0 (>L:CAMinsKnob,number)')
wwpdc3n:CfgRpn(20, '(L:CAMinsKnob,number) 50 + 50 min (>L:CAMinsKnob,number)', '0 (>L:CAMinsKnob,number)')


wwpdc3n:CfgRpn(21, '(L:CABaroKnob,number) 50 - -50 max (>L:CABaroKnob,number)', '0 (>L:CABaroKnob,number)')
wwpdc3n:CfgRpn(22, '(L:CABaroKnob,number) 50 + 50 min (>L:CABaroKnob,number)', '0 (>L:CABaroKnob,number)')

-- MINS RADIO/BARO selector (Buttons 24/25 -> bits 23/24)
wwpdc3n:CfgRpn(23, '(L:switch_356_73X,number) 0 != if{ 35601 (>K:ROTOR_BRAKE) }') -- RADIO
wwpdc3n:CfgRpn(24, '(L:switch_356_73X,number) 0 == if{ 35601 (>K:ROTOR_BRAKE) }') -- BARO

-- BARO IN/HPA selector (Buttons 26/27 -> bits 25/26)
wwpdc3n:CfgRpn(25, '(L:switch_366_73X,number) 0 != if{ 36601 (>K:ROTOR_BRAKE) }') -- IN
wwpdc3n:CfgRpn(26, '(L:switch_366_73X,number) 0 == if{ 36601 (>K:ROTOR_BRAKE) }') -- HPA

-- Mode rotary (Buttons 28..31 -> bits 27..30: APP / VOR / MAP / PLN)
local pswh_efismode = QmdevPosSwitchInit("(L:switch_359_73X, number)", 10, "35907 (>K:ROTOR_BRAKE)",
	"35908 (>K:ROTOR_BRAKE)", 300)
wwpdc3n:CfgPSw(27, pswh_efismode, 0)
wwpdc3n:CfgPSw(28, pswh_efismode, 10)
wwpdc3n:CfgPSw(29, pswh_efismode, 20)
wwpdc3n:CfgPSw(30, pswh_efismode, 30)

-- Range rotary (Buttons 32..39 -> bits 31..38: 5..640)
local pswh_efisrange = QmdevPosSwitchInit("(L:switch_361_73X, number)", 10, "36107 (>K:ROTOR_BRAKE)",
	"36108 (>K:ROTOR_BRAKE)", 300)
wwpdc3n:CfgPSw(31, pswh_efisrange, 0)
wwpdc3n:CfgPSw(32, pswh_efisrange, 10)
wwpdc3n:CfgPSw(33, pswh_efisrange, 20)
wwpdc3n:CfgPSw(34, pswh_efisrange, 30)
wwpdc3n:CfgPSw(35, pswh_efisrange, 40)
wwpdc3n:CfgPSw(36, pswh_efisrange, 50)
wwpdc3n:CfgPSw(37, pswh_efisrange, 60)
wwpdc3n:CfgPSw(38, pswh_efisrange, 70)

-- MINS / BARO knob turns (Buttons 40..45 -> bits 39..44)
-- onHold repeats the same ROTOR_BRAKE step (keysmap fast-repeat)
wwpdc3n:CfgRpn(39, '35508 (>K:ROTOR_BRAKE)')   -- MINS DEC
wwpdc3n:CfgRpn(40, '0 (>L:CAMinsKnob,number)') -- MINS Neutral
wwpdc3n:CfgRpn(41, '35507 (>K:ROTOR_BRAKE)')   -- MINS INC
wwpdc3n:CfgRpn(42, '36508 (>K:ROTOR_BRAKE)')   -- BARO DEC
wwpdc3n:CfgRpn(43, '0 (>L:CABaroKnob,number)') -- BARO Neutral
wwpdc3n:CfgRpn(44, '36507 (>K:ROTOR_BRAKE)')   -- BARO INC

-------------------- Backlight ---------------------
-- mfproj BACKLIGHT: (L:BL_MainCA, number) $*100; HID BKL takes 0..255
wwpdc3n:GetBkl('(L:BL_MainCA,number)', 255)

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
