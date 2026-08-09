-- *****************************************************************
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-08-08
-- MobiFlight KayeRoof / Kaye Roof for GA
-- Generic XP bindings (stock datarefs/commands). Panel semantics from
-- FENIX A320 Kaye Roof mfproj, mapped like z_QMOVH_A_GA.lua.
-- *****************************************************************

-- Do not remove below lines: hardware detection
local kayeroof = com.sim.mf.KayeRoof.Open()
if not kayeroof then return end
-- Do not remove above lines: hardware detection

uluaLog('MobiFlight KayeRoof for GA')

-- Always-off annunciator (unused A320 fault / upper LEDs)
local LED_OFF = 'sim/cockpit2/annunciators/electric_trim_off'

-- INPUT key bindings (keysmap bits from mobiflight/KayeRoof.json)

---- LIGHT BRT (Encoder MapToBits 54..57)
kayeroof:CfgEncFull(54, 55, 'sim/cockpit/electrical/instrument_brightness', 0.05, 0.1, 1, 0.0, 1.0)
kayeroof:CfgEncFull(56, 57, 'sim/cockpit/electrical/instrument_brightness', 0.05, 0.1, 1, 0.0, 1.0)

-- GNADIRS / IR mode (no stock ADIRS — leave unused)
-- GNADIRS_1_OFF / NAV / ATT (bits 0..2)
kayeroof:CfgCmd(0, 'sim/operation/test_none')
kayeroof:CfgCmd(1, 'sim/operation/test_none')
kayeroof:CfgCmd(2, 'sim/operation/test_none')
-- GNADIRS_3_OFF / NAV / ATT (bits 3..5) — Fenix IR2
kayeroof:CfgCmd(3, 'sim/operation/test_none')
kayeroof:CfgCmd(4, 'sim/operation/test_none')
kayeroof:CfgCmd(5, 'sim/operation/test_none')
-- GNADIRS_2_OFF / NAV / ATT (bits 6..8) — Fenix IR3
kayeroof:CfgCmd(6, 'sim/operation/test_none')
kayeroof:CfgCmd(7, 'sim/operation/test_none')
kayeroof:CfgCmd(8, 'sim/operation/test_none')

-- APU BLEED (Button, bit 9)
kayeroof:CfgValT(9, 'sim/cockpit2/bleedair/actuators/apu_bleed')

-- ELEC PUMP (Button, bit 10) — yellow elec hyd pump
kayeroof:CfgValT(10, 'sim/cockpit2/hydraulics/actuators/electric_hydraulic_pump_on')

-- WING anti-ice (Button, bit 11)
kayeroof:CfgValT(11, 'sim/cockpit2/ice/ice_surface_heat_on')

-- ENG1 / ENG2 anti-ice (bits 12..13)
kayeroof:CfgValT(12, 'sim/cockpit2/ice/ice_inlet_heat_on_per_engine[0]')
kayeroof:CfgValT(13, 'sim/cockpit2/ice/ice_inlet_heat_on_per_engine[1]')

-- GND CTL (Button, bit 14) — no GA CVR ground-control equivalent
kayeroof:CfgCmd(14, 'sim/operation/test_none')

-- CREW SUPPLY (Button, bit 15)
kayeroof:CfgValT(15, 'sim/cockpit2/oxygen/actuators/o2_valve_on')

-- BAT1 / BAT2 (bits 16..17)
kayeroof:CfgValT(16, 'sim/cockpit/electrical/battery_on')
kayeroof:CfgValT(17, 'sim/cockpit2/electrical/battery_array_on[1]')

-- LTK / CTR / RTK fuel pumps + mode / xfeed (bits 18..25)
kayeroof:CfgValT(18, 'sim/cockpit2/engine/actuators/fuel_pump_on[0]')
kayeroof:CfgValT(19, 'sim/cockpit2/engine/actuators/fuel_pump_on[1]')
kayeroof:CfgValT(20, 'sim/cockpit2/engine/actuators/fuel_pump_on[2]')
kayeroof:CfgValT(21, 'sim/cockpit2/engine/actuators/fuel_pump_on[3]')
-- MODE SEL (Button, bit 22)
kayeroof:CfgCmd(22, 'sim/operation/test_none')
kayeroof:CfgValT(23, 'sim/cockpit2/engine/actuators/fuel_pump_on[4]')
kayeroof:CfgValT(24, 'sim/cockpit2/engine/actuators/fuel_pump_on[5]')
kayeroof:CfgValT(25, 'sim/cockpit2/engine/actuators/fuel_pump_on[7]')

-- MASTER SW (Button, bit 26) — APU master → avionics (same as QMOVH-A GA)
kayeroof:CfgCmd(26, 'sim/systems/avionics_toggle')

-- START (Button, bit 27) — APU start → cross-tie toggle (same as QMOVH-A GA)
kayeroof:CfgValT(27, 'sim/cockpit2/electrical/cross_tie')

-- Fire / CVR tests (bits 28..31) — no stock fire-test commands
kayeroof:CfgCmd(28, 'sim/operation/test_none')
kayeroof:CfgCmd(29, 'sim/operation/test_none')
kayeroof:CfgCmd(30, 'sim/operation/test_none')
kayeroof:CfgCmd(31, 'sim/operation/test_none')

-- EMER EXIT LT (bits 32..33)
kayeroof:CfgCmd(32, 'sim/lights/generic_lights_on')
kayeroof:CfgCmd(33, 'sim/lights/generic_lights_off')

-- SEAT BELTS (bit 34) — Fenix only exposes OFF detent here
kayeroof:CfgCmd(34, 'sim/systems/seatbelt_sign_toggle')

-- NO SMOKING (bits 35..36)
kayeroof:CfgCmd(35, 'sim/systems/no_smoking_toggle')
kayeroof:CfgCmd(36, 'sim/systems/no_smoking_toggle')

-- EXT LT STROBE (bits 37..38)
kayeroof:CfgCmd(37, 'sim/lights/strobe_lights_on')
kayeroof:CfgCmd(38, 'sim/lights/strobe_lights_off')

-- EXT LT BEACON (bits 39..40)
kayeroof:CfgCmd(39, 'sim/lights/beacon_lights_on')
kayeroof:CfgCmd(40, 'sim/lights/beacon_lights_off')

-- EXT LT WING (bits 41..42)
kayeroof:CfgCmd(41, 'sim/lights/strobe_lights_on', 'sim/lights/strobe_lights_off')
kayeroof:CfgCmd(42, 'sim/lights/strobe_lights_off')

-- EXT LT NAV (bits 43..44)
kayeroof:CfgCmd(43, 'sim/lights/nav_lights_on')
kayeroof:CfgCmd(44, 'sim/lights/nav_lights_off')

-- EXT LT RWY TURN (bits 45..46) — map to taxi
kayeroof:CfgCmd(45, 'sim/lights/taxi_lights_on')
kayeroof:CfgCmd(46, 'sim/lights/taxi_lights_off')

-- EXT LT LAND L (bits 47..48)
kayeroof:CfgCmd(47, 'sim/lights/landing_01_light_on')
kayeroof:CfgCmd(48, 'sim/lights/landing_01_light_off')

-- EXT LT LAND R (bits 49..50)
kayeroof:CfgCmd(49, 'sim/lights/landing_02_light_on')
kayeroof:CfgCmd(50, 'sim/lights/landing_02_light_off')

-- EXT LT NOSE (bits 51..52) — T.O / OFF → taxi
kayeroof:CfgCmd(51, 'sim/lights/taxi_lights_on')
kayeroof:CfgCmd(52, 'sim/lights/taxi_lights_off')

-- EXT PWR (Button, bit 53)
kayeroof:CfgValT(53, 'sim/cockpit/electrical/gpu_on')

-- IR2 / IR3 / IR1 buttons (bits 58..60 ← Multiplexer 1:4/5/6; no stock ADIRS)
kayeroof:CfgCmd(58, 'sim/operation/test_none')
kayeroof:CfgCmd(59, 'sim/operation/test_none')
kayeroof:CfgCmd(60, 'sim/operation/test_none')

-- OUTPUT data (Fenix I_OH_* → nearest stock XP; upper/fault LEDs left off)

-- FIRE L / C / R
kayeroof:GetFireL('sim/cockpit2/annunciators/engine_fires[0]')
kayeroof:GetFireC(LED_OFF)
kayeroof:GetFireR('sim/cockpit2/annunciators/engine_fires[1]')

-- Anti-ice ENG/WING (UP = unused fault, DOWN = on)
kayeroof:GetAntiIceEng1Up(LED_OFF)
kayeroof:GetAntiIceEng1Down('sim/cockpit2/ice/ice_inlet_heat_on_per_engine[0]')
kayeroof:GetAntiIceEng2Up(LED_OFF)
kayeroof:GetAntiIceEng2Down('sim/cockpit2/ice/ice_inlet_heat_on_per_engine[1]')
kayeroof:GetAntiIceWingUp(LED_OFF)
kayeroof:GetAntiIceWingDown('sim/cockpit2/ice/ice_surface_heat_on')

-- APU BLEED
kayeroof:GetApuBleedUp(LED_OFF)
kayeroof:GetApuBleedDown('sim/cockpit2/bleedair/actuators/apu_bleed')

-- EXT PWR
kayeroof:GetExtPwrUp(LED_OFF)
kayeroof:GetExtPwrDown('sim/cockpit/electrical/gpu_on')

-- ELEC PUMP
kayeroof:GetElecPumpUp(LED_OFF)
kayeroof:GetElecPumpDown('sim/cockpit2/hydraulics/actuators/electric_hydraulic_pump_on')

-- BAT1 / BAT2
kayeroof:GetBat1Up(LED_OFF)
kayeroof:GetBat1Down('sim/cockpit/electrical/battery_on')
kayeroof:GetBat2Up(LED_OFF)
kayeroof:GetBat2Down('sim/cockpit2/electrical/battery_array_on[1]')

-- IR1..3 (no ADIRS)
kayeroof:GetIr1Lower(LED_OFF)
kayeroof:GetIr1Up(LED_OFF)
kayeroof:GetIr2Lower(LED_OFF)
kayeroof:GetIr2Up(LED_OFF)
kayeroof:GetIr3Lower(LED_OFF)
kayeroof:GetIr3Up(LED_OFF)

-- CREW SUPPLY / GND CTL
kayeroof:GetCrewSupply('sim/cockpit2/oxygen/actuators/o2_valve_on')
kayeroof:GetGndCtl(LED_OFF)

-- Fuel pumps LTK / CTR / RTK / XFEED / MODE SEL
kayeroof:GetLtkPumps1Up(LED_OFF)
kayeroof:GetLtkPumps1Down('sim/cockpit2/engine/actuators/fuel_pump_on[0]')
kayeroof:GetLtkPumps2Up(LED_OFF)
kayeroof:GetLtkPumps2Down('sim/cockpit2/engine/actuators/fuel_pump_on[1]')
kayeroof:GetPump1Up(LED_OFF)
kayeroof:GetPump1Down('sim/cockpit2/engine/actuators/fuel_pump_on[2]')
kayeroof:GetPump2Up(LED_OFF)
kayeroof:GetPump2Down('sim/cockpit2/engine/actuators/fuel_pump_on[3]')
kayeroof:GetRtkPumps1Up(LED_OFF)
kayeroof:GetRtkPumps1Down('sim/cockpit2/engine/actuators/fuel_pump_on[4]')
kayeroof:GetRtkPumps2Up(LED_OFF)
kayeroof:GetRtkPumps2Down('sim/cockpit2/engine/actuators/fuel_pump_on[5]')
kayeroof:GetXFeedUp(LED_OFF)
kayeroof:GetXFeedDown('sim/cockpit2/engine/actuators/fuel_pump_on[7]')
kayeroof:GetModeSelUp(LED_OFF)
kayeroof:GetModeSelDown(LED_OFF)

-- APU MASTER / START (same pairing as QMOVH-A GA)
kayeroof:GetMasterSwUp(LED_OFF)
kayeroof:GetMasterSwDown('sim/cockpit/electrical/avionics_on')
kayeroof:GetStartUp(LED_OFF)
kayeroof:GetStartDown('sim/cockpit2/electrical/cross_tie')

-- BAT voltage digits (channel is 0/1 in mfcfg — show battery on)
kayeroof:GetBat1v('sim/cockpit/electrical/battery_on')
kayeroof:GetBat2v('sim/cockpit2/electrical/battery_array_on[1]')

-- BACKLIGHT (Fenix A_OH_LIGHTING_OVD * 100)
kayeroof:GetBacklight('sim/cockpit/electrical/instrument_brightness', 100)

GlobalFrameLoopManager:add(function()
	kayeroof:SetFireL()
	kayeroof:SetAntiIceEng2Up()
	kayeroof:SetAntiIceEng1Down()
	kayeroof:SetAntiIceEng2Down()
	kayeroof:SetAntiIceWingDown()
	kayeroof:SetApuBleedDown()
	kayeroof:SetExtPwrDown()
	kayeroof:SetElecPumpDown()
	kayeroof:SetFireC()
	kayeroof:SetBat1Down()
	kayeroof:SetBat2Up()
	kayeroof:SetBat2Down()
	kayeroof:SetFireR()
	kayeroof:SetIr1Lower()
	kayeroof:SetIr1Up()
	kayeroof:SetIr2Lower()
	kayeroof:SetIr3Lower()
	kayeroof:SetExtPwrUp()
	kayeroof:SetAntiIceWingUp()
	kayeroof:SetApuBleedUp()
	kayeroof:SetElecPumpUp()
	kayeroof:SetAntiIceEng1Up()
	kayeroof:SetCrewSupply()
	kayeroof:SetGndCtl()
	kayeroof:SetBat1Up()
	kayeroof:SetLtkPumps1Up()
	kayeroof:SetLtkPumps2Down()
	kayeroof:SetIr3Up()
	kayeroof:SetIr2Up()
	kayeroof:SetRtkPumps1Up()
	kayeroof:SetLtkPumps1Down()
	kayeroof:SetLtkPumps2Up()
	kayeroof:SetPump1Up()
	kayeroof:SetModeSelDown()
	kayeroof:SetPump2Down()
	kayeroof:SetPump1Down()
	kayeroof:SetStartDown()
	kayeroof:SetPump2Up()
	kayeroof:SetModeSelUp()
	kayeroof:SetRtkPumps2Down()
	kayeroof:SetRtkPumps1Down()
	kayeroof:SetRtkPumps2Up()
	kayeroof:SetXFeedUp()
	kayeroof:SetXFeedDown()
	kayeroof:SetMasterSwUp()
	kayeroof:SetMasterSwDown()
	kayeroof:SetStartUp()
	kayeroof:SetBat1v()
	kayeroof:SetBat2v()
	kayeroof:SetBacklight()
end)
