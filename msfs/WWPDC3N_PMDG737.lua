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

-- Rotary seek helper: step switch_XXX toward target position
-- (mfproj Range/Mode/VOR rotary RPN, collected per skill note)
local function wwpdc3n_seek_rpn(sw, div, upCmd, dnCmd, target)
	return string.format('%d (L:%s,number) - %d div s0 :1 l0 0 > if{ %d (>K:ROTOR_BRAKE) l0 -- s0 g1 }',
		target, sw, div, upCmd) ..
		string.format(' l0 0 < if{ %d (>K:ROTOR_BRAKE) l0 ++ s0 g1 }', dnCmd)
end

-- VOR1 selector (Buttons 10..12 -> bits 9..11: VOR / OFF / ADF)
wwpdc3n:CfgRpn(9, wwpdc3n_seek_rpn('switch_358_73X', 50, 35801, 35802, 0))
wwpdc3n:CfgRpn(10, wwpdc3n_seek_rpn('switch_358_73X', 50, 35801, 35802, 50))
wwpdc3n:CfgRpn(11, wwpdc3n_seek_rpn('switch_358_73X', 50, 35801, 35802, 100))

-- VOR2 selector (Buttons 13..15 -> bits 12..14: VOR / OFF / ADF)
wwpdc3n:CfgRpn(12, wwpdc3n_seek_rpn('switch_368_73X', 50, 36801, 36802, 0))
wwpdc3n:CfgRpn(13, wwpdc3n_seek_rpn('switch_368_73X', 50, 36801, 36802, 50))
wwpdc3n:CfgRpn(14, wwpdc3n_seek_rpn('switch_368_73X', 50, 36801, 36802, 100))

-- Push buttons (Buttons 16..19 -> bits 15..18)
wwpdc3n:CfgRpn(15, '35701 (>K:ROTOR_BRAKE)') -- MINS push (RST)
wwpdc3n:CfgRpn(16, '36001 (>K:ROTOR_BRAKE)') -- CTR
wwpdc3n:CfgRpn(17, '36201 (>K:ROTOR_BRAKE)') -- TFC
wwpdc3n:CfgRpn(18, '36701 (>K:ROTOR_BRAKE)') -- BARO push (STD)

-- MINS/BARO fast-repeat knobs (Buttons 20..23 -> bits 19..22)
-- mfproj FULL variants accumulate L:CAMinsKnob / L:CABaroKnob, reset on release
wwpdc3n:CfgRpn(19, '(L:CAMinsKnob,number) 1 - -50 max (>L:CAMinsKnob,number)', '0 (>L:CAMinsKnob,number)')
wwpdc3n:CfgRpn(20, '(L:CAMinsKnob,number) 1 + 50 min (>L:CAMinsKnob,number)', '0 (>L:CAMinsKnob,number)')
wwpdc3n:CfgRpn(21, '(L:CABaroKnob,number) 1 - -50 max (>L:CABaroKnob,number)', '0 (>L:CABaroKnob,number)')
wwpdc3n:CfgRpn(22, '(L:CABaroKnob,number) 1 + 50 min (>L:CABaroKnob,number)', '0 (>L:CABaroKnob,number)')

-- MINS RADIO/BARO selector (Buttons 24/25 -> bits 23/24)
wwpdc3n:CfgRpn(23, '(L:switch_356_73X,number) 0 != if{ 35601 (>K:ROTOR_BRAKE) }') -- RADIO
wwpdc3n:CfgRpn(24, '(L:switch_356_73X,number) 0 == if{ 35601 (>K:ROTOR_BRAKE) }') -- BARO

-- BARO IN/HPA selector (Buttons 26/27 -> bits 25/26)
wwpdc3n:CfgRpn(25, '(L:switch_366_73X,number) 0 != if{ 36601 (>K:ROTOR_BRAKE) }') -- IN
wwpdc3n:CfgRpn(26, '(L:switch_366_73X,number) 0 == if{ 36601 (>K:ROTOR_BRAKE) }') -- HPA

-- Mode rotary (Buttons 28..31 -> bits 27..30: APP / VOR / MAP / PLN)
wwpdc3n:CfgRpn(27, wwpdc3n_seek_rpn('switch_359_73X', 10, 35907, 35908, 0))
wwpdc3n:CfgRpn(28, wwpdc3n_seek_rpn('switch_359_73X', 10, 35907, 35908, 10))
wwpdc3n:CfgRpn(29, wwpdc3n_seek_rpn('switch_359_73X', 10, 35907, 35908, 20))
wwpdc3n:CfgRpn(30, wwpdc3n_seek_rpn('switch_359_73X', 10, 35907, 35908, 30))

-- Range rotary (Buttons 32..39 -> bits 31..38: 5..640)
wwpdc3n:CfgRpn(31, wwpdc3n_seek_rpn('switch_361_73X', 10, 36107, 36108, 0))
wwpdc3n:CfgRpn(32, wwpdc3n_seek_rpn('switch_361_73X', 10, 36107, 36108, 10))
wwpdc3n:CfgRpn(33, wwpdc3n_seek_rpn('switch_361_73X', 10, 36107, 36108, 20))
wwpdc3n:CfgRpn(34, wwpdc3n_seek_rpn('switch_361_73X', 10, 36107, 36108, 30))
wwpdc3n:CfgRpn(35, wwpdc3n_seek_rpn('switch_361_73X', 10, 36107, 36108, 40))
wwpdc3n:CfgRpn(36, wwpdc3n_seek_rpn('switch_361_73X', 10, 36107, 36108, 50))
wwpdc3n:CfgRpn(37, wwpdc3n_seek_rpn('switch_361_73X', 10, 36107, 36108, 60))
wwpdc3n:CfgRpn(38, wwpdc3n_seek_rpn('switch_361_73X', 10, 36107, 36108, 70))

-- MINS / BARO knob turns (Buttons 40..45 -> bits 39..44)
-- onHold repeats the same ROTOR_BRAKE step (keysmap fast-repeat)
wwpdc3n:CfgRpn(39, '35508 (>K:ROTOR_BRAKE)') -- MINS DEC
wwpdc3n:CfgRpn(40, '0 (>L:CAMinsKnob,number)') -- MINS Neutral
wwpdc3n:CfgRpn(41, '35507 (>K:ROTOR_BRAKE)') -- MINS INC
wwpdc3n:CfgRpn(42, '36508 (>K:ROTOR_BRAKE)') -- BARO DEC
wwpdc3n:CfgRpn(43, '0 (>L:CABaroKnob,number)') -- BARO Neutral
wwpdc3n:CfgRpn(44, '36507 (>K:ROTOR_BRAKE)') -- BARO INC

-------------------- Backlight ---------------------
-- mfproj BACKLIGHT: (L:BL_MainCA, number) $*100; HID BKL takes 0..255
local dr_bkl = iDataRef:New('(L:BL_MainCA,number)')
local dr_power
if uluaFind('pmdg/ng3/data/MCP_indication_powered') then
	dr_power = iDataRef:New('pmdg/ng3/data/MCP_indication_powered')
else
	dr_power = iDataRef:New('pmdg/ng3/data/ELEC_BusPowered[3]')
end

local wwpdc3n_last_bkl = -1

GlobalFrameLoopManager:add(function()
	local bkl = 0
	if dr_power:Get() ~= 0 then
		bkl = math.floor((dr_bkl:Get() or 0) * 255)
		if bkl < 0 then bkl = 0 elseif bkl > 255 then bkl = 255 end
	end
	-- Avoid flooding USB HID with unchanged backlight values
	if bkl ~= wwpdc3n_last_bkl then
		wwpdc3n_last_bkl = bkl
		wwpdc3n:SendLedCmd(wwpdc3n.LEDS_BKL, bkl)
	end
end)
