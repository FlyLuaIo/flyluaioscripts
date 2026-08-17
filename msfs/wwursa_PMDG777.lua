-- *****************************************************************
-- created by Carson Lou @ QQ 2026-08-09
-- *****************************************************************
if ilua_require_pmdg_777() then return end

-- Do not remove below lines: hardware detection
local wwursa = com.sim.qm.Wwursa.Open()
if not wwursa then return end
-- Do not remove above lines: hardware detection

uluaLog('URSA Throttle L for PMDG 777')

-- ===========================================================
-- button binding

-- SET SPOILERS ARM
wwursa:CfgRpn(38, '(L:switch_498_a) 0 == if{ 498201 (>K:ROTOR_BRAKE) }')
-- SPOILERS DOWN
wwursa:CfgRpn(37, '(L:switch_498_a) 200 == if{ 498201 (>K:ROTOR_BRAKE) }')

-- Rudder trim RST / L / R (Buttons 24/25/27 → bits 24/25/27)
wwursa:CfgRpn(24, '72901 (>K:ROTOR_BRAKE)')

wwursa:CfgRpn(25,
	'-15 (>L:RudderTrimKnob, number)',
	'0 (>L:RudderTrimKnob, number)')
wwursa:CfgRpn(27,
	'15 (>L:RudderTrimKnob, number)',
	'0 (>L:RudderTrimKnob, number)')

--parking brake (PMDG 777 ROTOR_BRAKE code unverified; use standard K event)
wwursa:CfgRpn(28, '(>K:PARKING_BRAKES)')

---- ENG STSRT
-- ENG L IDEL
wwursa:CfgRpn(0, '(L:switch_520_a) 100 == if{ 52001 (>K:ROTOR_BRAKE) }')
-- ENG L CUTOFF
wwursa:CfgRpn(1, '(L:switch_520_a) 0 == if{ 52001 (>K:ROTOR_BRAKE) }')
-- ENG R IDEL
wwursa:CfgRpn(2, '(L:switch_521_a) 100 == if{ 52101 (>K:ROTOR_BRAKE) }')
-- ENG R CUTOFF
wwursa:CfgRpn(3, '(L:switch_521_a) 0 == if{ 52101 (>K:ROTOR_BRAKE) }')

-- TODO: bits 25/27 (TOGA press/release): PMDG 777 ROTOR_BRAKE code unverified

-- ====rudder trim LCD
-- setLcdText caches text internally; USB write only when text changes
local dr_trim = iDataRef:New(
	'(L:myRudderTimer) 0 > (L:RudderTrimKnob, number) 0 != and if{ (E:SIMULATION TIME, second) (L:myRudderTimer) 0.5 + > if{ 0 (>L:RudderTrimKnob, number) 0 (>L:myRudderTimer) } }')

function Wwursa_PMDG777_LCD_Loop()
	wwursa:setLcdText(wwursa:formatTrimText(dr_trim:Get(), false))
end

-- ====backlight
-- panel brightness ratio scaled to 0-255, gated by battery power;
-- local cache: USB write only when computed value changes
local dr_power = iDataRef:New('(A:CIRCUIT GENERAL PANEL ON, Bool)')
local dr_panel = iDataRef:New('(L:BL_Pedestal, number)')
local bkl_last = -1

function Wwursa_PMDG777_Bkl_Loop()
	local hasPower = dr_power:Get() ~= 0
	local ratio = dr_panel:Get()
	if ratio < 0 then ratio = 0 elseif ratio > 1 then ratio = 1 end
	local bkl = hasPower and math.floor(ratio * 255) or 0
	if bkl ~= bkl_last then
		bkl_last = bkl
		wwursa:SendLedCmd(wwursa.LEDS_BKL, bkl)
		wwursa:SendLedCmd(wwursa.LEDS_OVERALLBKL, hasPower and 255 or 0)
	end
end

-- ====fault/fire LEDs
-- annunciator binaries, edge-detected (no per-frame USB HID traffic)
local dr_fire1 = iDataRef:New('(A:ENG FIRE:1,Bool)')
local dr_fire2 = iDataRef:New('(A:ENG FIRE:2,Bool)')
local fault1_last, fire1_last = -1, -1
local fault2_last, fire2_last = -1, -1

function Wwursa_PMDG777_Led_Loop()
	local fault1, fault2 = 0, 0
	local fire1 = dr_fire1:Get() ~= 0 and 1 or 0
	local fire2 = dr_fire2:Get() ~= 0 and 1 or 0
	if fault1 ~= fault1_last then
		fault1_last = fault1
		wwursa:SendLedCmd(wwursa.LEDS_FAULT1, fault1)
	end
	if fire1 ~= fire1_last then
		fire1_last = fire1
		wwursa:SendLedCmd(wwursa.LEDS_FIRE1, fire1)
	end
	if fault2 ~= fault2_last then
		fault2_last = fault2
		wwursa:SendLedCmd(wwursa.LEDS_FAULT2, fault2)
	end
	if fire2 ~= fire2_last then
		fire2_last = fire2
		wwursa:SendLedCmd(wwursa.LEDS_FIRE2, fire2)
	end
end

-- ====vibration
-- ground-roll micro-vibration: intensity = groundspeed, gated by on-ground,
-- explicit SendLedCmd with local throttling (no per-frame USB HID traffic)
local dr_onground = iDataRef:New('(A:SIM ON GROUND,Bool)')
local dr_gs = iDataRef:New('(A:GPS GROUND SPEED,Meters per second)')
local vib_l_last = 0
local vib_r_last = 0

function Wwursa_PMDG777_Vib_Loop()
	local vib_l, vib_r = 0, 0
	if dr_onground:Get() ~= 0 then
		local gs = dr_gs:Get()
		vib_l = math.floor(gs)
		vib_r = math.floor(gs)
		if vib_l > 255 then vib_l = 255 end
		if vib_r > 255 then vib_r = 255 end
	end
	if vib_l ~= vib_l_last then
		vib_l_last = vib_l
		wwursa:SendLedCmd(wwursa.LEDS_VIBL, vib_l)
	end
	if vib_r ~= vib_r_last then
		vib_r_last = vib_r
		wwursa:SendLedCmd(wwursa.LEDS_VIBR, vib_r)
	end
end

GlobalFrameLoopManager:add(function()
	Wwursa_PMDG777_Bkl_Loop()
	Wwursa_PMDG777_Led_Loop()
	Wwursa_PMDG777_Vib_Loop()
	-- setLcdText caches text internally; USB write only when text changes
	Wwursa_PMDG777_LCD_Loop()
end)
