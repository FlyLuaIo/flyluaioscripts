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

--- eng_starter_select
local pswheng1 = QmdevPosSwitchInit("(L:switch_94_a, number)", 100, "9402 (>K:ROTOR_BRAKE)",
	"9401 (>K:ROTOR_BRAKE)",
	500)

local pswheng2 = QmdevPosSwitchInit("(L:switch_95_a, number)", 100, "9502 (>K:ROTOR_BRAKE)",
	"9501 (>K:ROTOR_BRAKE)",
	500)

function eng_starter_select(idx)
	if idx == 0 then
		--uluaCmdOnce(dr_cmd_ign1)
		wwursa:CfgPSw(6, pswheng1, 0)
		wwursa:CfgPSw(7, pswheng1, 100)
		wwursa:CfgPSw(8, pswheng1, 100)
	else
		--uluaCmdOnce(dr_cmd_ign2)
		wwursa:CfgPSw(6, pswheng2, 0)
		wwursa:CfgPSw(7, pswheng2, 100)
		wwursa:CfgPSw(8, pswheng2, 100)
	end
end

eng_starter_select(0)
wwursa:CfgFc(4, 'eng_starter_select(0)')
wwursa:CfgFc(5, 'eng_starter_select(1)')

-- ====backlight / LEDs
wwursa:GetBkl('(L:BL_Pedestal, number)', 255)
wwursa:GetOverallBkl('(A:CIRCUIT GENERAL PANEL ON, Bool)', 255)
wwursa:GetFault1('0')
wwursa:GetFault2('0')
wwursa:GetFire1('(A:ENG FIRE:1,Bool)')
wwursa:GetFire2('(A:ENG FIRE:2,Bool)')

-- ====vibration
wwursa:GetVibL('(A:SIM ON GROUND,Bool) (A:GPS GROUND SPEED,Meters per second) * 10 *')
wwursa:GetVibR('(A:SIM ON GROUND,Bool) (A:GPS GROUND SPEED,Meters per second) * 10 *')

-- ====LCD
local dr_trim = iDataRef:New(
	'(L:myRudderTimer) 0 > (L:RudderTrimKnob, number) 0 != and if{ (E:SIMULATION TIME, second) (L:myRudderTimer) 0.5 + > if{ 0 (>L:RudderTrimKnob, number) 0 (>L:myRudderTimer) } }')

GlobalFrameLoopManager:add(function()
	wwursa:SetBkl()
	wwursa:SetOverallBkl()
	wwursa:Setleds() -- boolean LEDs only (FAULT/FIRE)
	wwursa:SetVibL()
	wwursa:SetVibR()
	wwursa:setLcdText(wwursa:formatTrimText(dr_trim:Get(), false))
end)
