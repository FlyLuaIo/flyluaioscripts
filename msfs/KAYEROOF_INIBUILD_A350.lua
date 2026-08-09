-- *****************************************************************
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-08-08
-- MobiFlight KayeRoof / Kaye Roof for iniBuilds A350
-- MSFS RPN from: INI A350 顶板包含PAP3.mfproj (Kaye Roof)
-- *****************************************************************
if ilua_require_inibuild_a350() then return end

-- Do not remove below lines: hardware detection
local kayeroof = com.sim.mf.KayeRoof.Open()
if not kayeroof then return end
-- Do not remove above lines: hardware detection

uluaLog('MobiFlight KayeRoof for iniBuilds A350')

-- ===========================================================
-- button binding (keysmap bits from mobiflight/KayeRoof.json)

---- LIGHT BRT (Encoder MapToBits 54..57; INI integ LT — not in mfproj, same LVar as QMOVH-A)
kayeroof:CfgRpn(54, '(L:INI_CKPT_LT_INTEG) 5 + 100 min (>L:INI_CKPT_LT_INTEG)')
kayeroof:CfgRpn(55, '(L:INI_CKPT_LT_INTEG) 5 - 0 max (>L:INI_CKPT_LT_INTEG)')
kayeroof:CfgRpn(56, '(L:INI_CKPT_LT_INTEG) 5 + 100 min (>L:INI_CKPT_LT_INTEG)')
kayeroof:CfgRpn(57, '(L:INI_CKPT_LT_INTEG) 5 - 0 max (>L:INI_CKPT_LT_INTEG)')

-- GNADIRS_1 OFF / NAV / ATT (bits 0..2) → IRS1
kayeroof:CfgRpn(0, '0 (>L:INI_IRS1_STATE)')
kayeroof:CfgRpn(1, '1 (>L:INI_IRS1_STATE)')
kayeroof:CfgRpn(2, '2 (>L:INI_IRS1_STATE)')

-- GNADIRS_3 OFF / NAV / ATT (bits 3..5) → IRS2
kayeroof:CfgRpn(3, '0 (>L:INI_IRS2_STATE)')
kayeroof:CfgRpn(4, '1 (>L:INI_IRS2_STATE)')
kayeroof:CfgRpn(5, '2 (>L:INI_IRS2_STATE)')

-- GNADIRS_2 OFF / NAV / ATT (bits 6..8) → IRS3
kayeroof:CfgRpn(6, '0 (>L:INI_IRS3_STATE)')
kayeroof:CfgRpn(7, '1 (>L:INI_IRS3_STATE)')
kayeroof:CfgRpn(8, '2 (>L:INI_IRS3_STATE)')

-- APU BLEED (bit 9)
kayeroof:CfgRpn(9, '(L:INI_AIR_BLEED_APU) ! (>L:INI_AIR_BLEED_APU)')

-- ELEC PUMP (bit 10)
kayeroof:CfgRpn(10, '(L:INI_HYD_ELEC2_STATE) ! (>L:INI_HYD_ELEC2_STATE)')

-- WING / ENG1 / ENG2 anti-ice (bits 11..13)
kayeroof:CfgRpn(11, '(L:INI_WING_ANTI_ICE1_STATE) ! (>L:INI_WING_ANTI_ICE1_STATE)')
kayeroof:CfgRpn(12, '(L:INI_ENG_ANTI_ICE1_STATE) ! (>L:INI_ENG_ANTI_ICE1_STATE)')
kayeroof:CfgRpn(13, '(L:INI_ENG_ANTI_ICE2_STATE) ! (>L:INI_ENG_ANTI_ICE2_STATE)')

-- GND CTL (bit 14)
kayeroof:CfgRpn(14, '(L:INI_GND_CTL) ! (>L:INI_GND_CTL)')

-- CREW SUPPLY (bit 15)
kayeroof:CfgRpn(15, '(L:INI_CREW_SUPPLY) ! (>L:INI_CREW_SUPPLY)')

-- BAT1 / BAT2 (bits 16..17) — sync EMER bat with main (mfproj dual configs on same pin)
kayeroof:CfgRpn(16,
	'(L:INI_BATTERY_1_SWITCH) ! (>L:INI_BATTERY_1_SWITCH) (L:INI_BATTERY_1_SWITCH) (>L:INI_BATTERY_EMER1_SWITCH)')
kayeroof:CfgRpn(17,
	'(L:INI_BATTERY_2_SWITCH) ! (>L:INI_BATTERY_2_SWITCH) (L:INI_BATTERY_2_SWITCH) (>L:INI_BATTERY_EMER2_SWITCH)')

-- Fuel pumps / MODE SEL / XFEED (bits 18..25)
-- RTK1=inner / RTK2=outer (mfproj LED DeviceName + QMOVH-A mapping)
kayeroof:CfgRpn(18, '(L:INI_OUTER_TANK_LEFT) ! (>L:INI_OUTER_TANK_LEFT)')
kayeroof:CfgRpn(19, '(L:INI_INNER_TANK_LEFT) ! (>L:INI_INNER_TANK_LEFT)')
kayeroof:CfgRpn(20, '(L:INI_CENTER_TANK_LEFT) ! (>L:INI_CENTER_TANK_LEFT)')
kayeroof:CfgRpn(21, '(L:INI_CENTER_TANK_RIGHT) ! (>L:INI_CENTER_TANK_RIGHT)')
kayeroof:CfgRpn(22, '(L:INI_FUEL_CTR_TANK_FEED_MAN) ! (>L:INI_FUEL_CTR_TANK_FEED_MAN)')
kayeroof:CfgRpn(23, '(L:INI_INNER_TANK_RIGHT) ! (>L:INI_INNER_TANK_RIGHT)')
kayeroof:CfgRpn(24, '(L:INI_OUTER_TANK_RIGHT) ! (>L:INI_OUTER_TANK_RIGHT)')
kayeroof:CfgRpn(25, '(L:INI_XFEED_TRANSFER_ON) ! (>L:INI_XFEED_TRANSFER_ON)')

-- MASTER SW / START (bits 26..27)
kayeroof:CfgRpn(26, '(L:INI_APU_MASTER_SWITCH) ! (>L:INI_APU_MASTER_SWITCH)')
kayeroof:CfgRpn(27, '(L:INI_APU_START_BUTTON) ! (>L:INI_APU_START_BUTTON)')

-- Fire / CVR tests (bits 28..31) — press/release
kayeroof:CfgRpn(28, '1 (>L:INI_FIRE_TEST)', '0 (>L:INI_FIRE_TEST)')
kayeroof:CfgRpn(29, '1 (>L:INI_FIRE_TEST)', '0 (>L:INI_FIRE_TEST)')
kayeroof:CfgRpn(30, '1 (>L:INI_CALLS_PURS)', '0 (>L:INI_CALLS_PURS)')
kayeroof:CfgRpn(31, '1 (>L:INI_FIRE_TEST)', '0 (>L:INI_FIRE_TEST)')

-- EMER EXIT LT (bits 32..33)
kayeroof:CfgRpn(32, '2 (>L:INI_EMER_EXIT_SWITCH)', '1 (>L:INI_EMER_EXIT_SWITCH)')
kayeroof:CfgRpn(33, '0 (>L:INI_EMER_EXIT_SWITCH)', '1 (>L:INI_EMER_EXIT_SWITCH)')

-- SEAT BELTS (bit 34)
kayeroof:CfgRpn(34, '2 (>L:INI_SEATBELTS_SWITCH)', '0 (>L:INI_SEATBELTS_SWITCH)')

-- NO SMOKING (bits 35..36)
kayeroof:CfgRpn(35, '0 (>L:INI_NO_SMOKING_SWITCH)', '1 (>L:INI_NO_SMOKING_SWITCH)')
kayeroof:CfgRpn(36, '2 (>L:INI_NO_SMOKING_SWITCH)', '1 (>L:INI_NO_SMOKING_SWITCH)')

-- EXT LT STROBE (bits 37..38)
kayeroof:CfgRpn(37, '2 (>L:INI_LIGHTS_STROBE)', '1 (>L:INI_LIGHTS_STROBE)')
kayeroof:CfgRpn(38, '0 (>L:INI_LIGHTS_STROBE)', '1 (>L:INI_LIGHTS_STROBE)')

-- EXT LT BEACON (bits 39..40)
kayeroof:CfgRpn(39, '1 (>L:INI_LIGHTS_BEACON)')
kayeroof:CfgRpn(40, '0 (>L:INI_LIGHTS_BEACON)')

-- EXT LT WING (bits 41..42)
kayeroof:CfgRpn(41, '1 (>L:INI_LIGHTS_WING)')
kayeroof:CfgRpn(42, '0 (>L:INI_LIGHTS_WING)')

-- EXT LT NAV (bits 43..44) — mfproj writes LOGO + NAV together
kayeroof:CfgRpn(43, '0 (>L:INI_LIGHTS_LOGO) 0 (>L:INI_LIGHTS_NAV)', '1 (>L:INI_LIGHTS_LOGO) 1 (>L:INI_LIGHTS_NAV)')
kayeroof:CfgRpn(44, '2 (>L:INI_LIGHTS_LOGO) 2 (>L:INI_LIGHTS_NAV)', '1 (>L:INI_LIGHTS_LOGO) 1 (>L:INI_LIGHTS_NAV)')

-- EXT LT RWY TURN (bits 45..46) — mfproj uses LANDING LVar
kayeroof:CfgRpn(45, '1 (>L:INI_LIGHTS_LANDING)')
kayeroof:CfgRpn(46, '0 (>L:INI_LIGHTS_LANDING)')

-- EXT LT LAND L bits (47..48) — mfproj maps NO MOBILE signs here
kayeroof:CfgRpn(47, '0 (>L:INI_SIGNS_NO_MOBILE)', '1 (>L:INI_SIGNS_NO_MOBILE)')
kayeroof:CfgRpn(48, '2 (>L:INI_SIGNS_NO_MOBILE)', '1 (>L:INI_SIGNS_NO_MOBILE)')

-- EXT LT LAND R (bits 49..50) — not present in mfproj Kaye Roof inputs

-- EXT LT NOSE (bits 51..52)
kayeroof:CfgRpn(51, '2 (>L:INI_LIGHTS_NOSE)', '1 (>L:INI_LIGHTS_NOSE)')
kayeroof:CfgRpn(52, '0 (>L:INI_LIGHTS_NOSE)', '1 (>L:INI_LIGHTS_NOSE)')

-- EXT PWR (bit 53) — toggle A/B when GPU available (mfproj dual configs on same pin)
kayeroof:CfgRpn(53,
	'(L:INI_GPU_AVAIL) 1 == if{ (L:INI_GEN_EXT_A_ONLINE) ! (>L:INI_GEN_EXT_A_ONLINE) } (L:INI_GPU_AVAIL) 1 == if{ (L:INI_GEN_EXT_B_ONLINE) ! (>L:INI_GEN_EXT_B_ONLINE) }')

-- IR2 / IR3 / IR1 buttons (bits 58..60 ← Multiplexer 1:4/5/6)
kayeroof:CfgRpn(58, '(L:INI_IR2_STATE) ! (>L:INI_IR2_STATE)') -- IR2_BUTTON
kayeroof:CfgRpn(59, '(L:INI_IR3_STATE) ! (>L:INI_IR3_STATE)') -- IR3_BUTTON
kayeroof:CfgRpn(60, '(L:INI_IR1_STATE) ! (>L:INI_IR1_STATE)') -- IR1_BUTTON

-- ===========================================================
-- Read data for lights (Get* — keep all channels)

-- FIRE L / C / R
kayeroof:GetFireL('(L:INI_FIRE_ENG_1_FIRE) (L:INI_FIRE_TEST) 1 == or (L:INI_ANNLT_SWITCH) 2 == + 1 min (L:INI_GENERAL_LIGHT_MULTIPLIER) * 0.1 * (L:INI_DC_LIGHTS_FAILURE) 10 * *') -- ENG1 FIRE
kayeroof:GetFireC('(L:INI_FIRE_APU_FIRE) (L:INI_FIRE_TEST) 1 == or (L:INI_ANNLT_SWITCH) 2 == + 1 min (L:INI_GENERAL_LIGHT_MULTIPLIER) * 0.1 * (L:INI_DC_LIGHTS_FAILURE) 10 * *') -- APU FIRE
kayeroof:GetFireR('(L:INI_FIRE_ENG_2_FIRE) (L:INI_FIRE_TEST) 1 == or (L:INI_ANNLT_SWITCH) 2 == + 1 min (L:INI_GENERAL_LIGHT_MULTIPLIER) * 0.1 * (L:INI_DC_LIGHTS_FAILURE) 10 * *') -- ENG2 FIRE

-- Anti-ice (mfproj Transformation: fault/state && AC ESS SHED powered)
kayeroof:GetAntiIceEng2Up('(L:INI_ENG_ANTI_ICE2_FAULT) 1 == (L:INI_ELEC_AC_ESS_SHED_BUS_IS_POWERED) 1 == and') -- ENG2 AI FAULT
kayeroof:GetAntiIceEng1Down('(L:INI_ENG_ANTI_ICE1_STATE) 1 == (L:INI_ELEC_AC_ESS_SHED_BUS_IS_POWERED) 1 == and') -- ENG1 AI ON
kayeroof:GetAntiIceEng2Down('(L:INI_ENG_ANTI_ICE2_STATE) 1 == (L:INI_ELEC_AC_ESS_SHED_BUS_IS_POWERED) 1 == and') -- ENG2 AI ON
kayeroof:GetAntiIceWingDown('(L:INI_WING_ANTI_ICE1_STATE) 1 == (L:INI_ELEC_AC_ESS_SHED_BUS_IS_POWERED) 1 == and') -- WING AI ON
kayeroof:GetAntiIceWingUp('(L:INI_WING_ANTI_ICE1_FAULT) 1 == (L:INI_ELEC_AC_ESS_SHED_BUS_IS_POWERED) 1 == and') -- WING AI FAULT
kayeroof:GetAntiIceEng1Up('(L:INI_ENG_ANTI_ICE1_FAULT) 1 == (L:INI_ELEC_AC_ESS_SHED_BUS_IS_POWERED) 1 == and') -- ENG1 AI FAULT

-- APU BLEED / EXT PWR / ELEC PUMP
kayeroof:GetApuBleedDown('(L:INI_AIR_BLEED_APU) 1 == (L:INI_ELEC_AC_ESS_SHED_BUS_IS_POWERED) 1 == and') -- APU BLEED ON
kayeroof:GetApuBleedUp('(L:INI_AIR_BLEED_APU_FAULT) 1 == (L:INI_ELEC_AC_ESS_SHED_BUS_IS_POWERED) 1 == and') -- APU BLEED FAULT
kayeroof:GetExtPwrDown('(L:INI_GEN_EXT_A_ONLINE)') -- EXT PWR ON
kayeroof:GetExtPwrUp('(L:INI_GPU_AVAIL) 1 == (L:INI_GEN_EXT_B_ONLINE) 0 == and (L:INI_ANNLT_SWITCH) 2 == + 1 min (L:INI_GENERAL_LIGHT_MULTIPLIER) * 1 5 * * (L:INI_GPU_AVAIL) (L:INI_AC_LIGHTS_FAILURE) || *') -- EXT PWR AVAIL
kayeroof:GetElecPumpDown('(L:INI_HYD_ELEC2_STATE) 0 == (L:INI_ANNLT_SWITCH) 2 == + 1 min (L:INI_GENERAL_LIGHT_MULTIPLIER) * 1 5 * * (L:INI_AC_LIGHTS_FAILURE) *') -- ELEC PUMP ON
kayeroof:GetElecPumpUp('(L:INI_GND_HYD_GREEN_ELEC_PUMP_FAULT) 1 == (L:INI_ANNLT_SWITCH) 2 == + 1 min (L:INI_GENERAL_LIGHT_MULTIPLIER) * 1 5 * * (L:INI_AC_LIGHTS_FAILURE) *') -- ELEC PUMP FAULT

-- BAT1 / BAT2 (mfproj BAT_2_UP used BATTERY_1_FAULT — corrected to BATTERY_2_FAULT)
kayeroof:GetBat1Down('(L:INI_BATTERY_1_SWITCH) 0 == (L:INI_ELEC_AC_ESS_SHED_BUS_IS_POWERED) 1 == and') -- BAT1 OFF
kayeroof:GetBat1Up('(L:INI_BATTERY_1_FAULT)') -- BAT1 FAULT
kayeroof:GetBat2Up('(L:INI_BATTERY_2_FAULT)') -- BAT2 FAULT
kayeroof:GetBat2Down('(L:INI_BATTERY_2_SWITCH) 0 == (L:INI_ELEC_AC_ESS_SHED_BUS_IS_POWERED) 1 == and') -- BAT2 OFF

-- IR1..3
kayeroof:GetIr1Lower('(L:INI_IR1_STATE) ! (L:INI_ANNLT_SWITCH) 2 == + 1 min (L:INI_GENERAL_LIGHT_MULTIPLIER) * 1 5 * * (L:INI_AC_LIGHTS_FAILURE) *') -- IR1 ALIGN
kayeroof:GetIr1Up('(L:INI_IR1_FAULT) (L:INI_ANNLT_SWITCH) 2 == + 1 min (L:INI_GENERAL_LIGHT_MULTIPLIER) * 1 5 * * (L:INI_AC_LIGHTS_FAILURE) *') -- IR1 FAULT
kayeroof:GetIr2Lower('(L:INI_IR2_STATE) ! (L:INI_ANNLT_SWITCH) 2 == + 1 min (L:INI_GENERAL_LIGHT_MULTIPLIER) * 1 5 * * (L:INI_AC_LIGHTS_FAILURE) *') -- IR2 ALIGN
kayeroof:GetIr2Up('(L:INI_IR2_FAULT) (L:INI_ANNLT_SWITCH) 2 == + 1 min (L:INI_GENERAL_LIGHT_MULTIPLIER) * 1 5 * * (L:INI_AC_LIGHTS_FAILURE) *') -- IR2 FAULT
kayeroof:GetIr3Lower('(L:INI_IR3_STATE) ! (L:INI_ANNLT_SWITCH) 2 == + 1 min (L:INI_GENERAL_LIGHT_MULTIPLIER) * 1 5 * * (L:INI_AC_LIGHTS_FAILURE) *') -- IR3 ALIGN
kayeroof:GetIr3Up('(L:INI_IR3_FAULT) (L:INI_ANNLT_SWITCH) 2 == + 1 min (L:INI_GENERAL_LIGHT_MULTIPLIER) * 1 5 * * (L:INI_AC_LIGHTS_FAILURE) *') -- IR3 FAULT

-- CREW SUPPLY / GND CTL
kayeroof:GetCrewSupply('(L:INI_CREW_SUPPLY) 0 == (L:INI_ANNLT_SWITCH) 2 == + 1 min (L:INI_GENERAL_LIGHT_MULTIPLIER) * 1 5 * * (L:INI_AC_LIGHTS_FAILURE) *') -- CREW OXY OFF
kayeroof:GetGndCtl('(L:INI_GND_CTL) 1 == (L:INI_ANNLT_SWITCH) 2 == + 1 min (L:INI_GENERAL_LIGHT_MULTIPLIER) * 1 5 * * (L:INI_AC_LIGHTS_FAILURE) *') -- GND CTL ON

-- Fuel LTK / CTR / RTK / MODE / XFEED
kayeroof:GetLtkPumps1Up('(L:INI_OUTER_TANK_LEFT) (L:INI_OUTER_TANK_LEFT_PUMP_ON) ! and (L:INI_OUTER_TANK_LEFT_FAULT) or (L:INI_ANNLT_SWITCH) 2 == + 1 min (L:INI_GENERAL_LIGHT_MULTIPLIER) * 1 5 * * (L:INI_DC_LIGHTS_FAILURE) *') -- L TK PUMP1 FAULT
kayeroof:GetLtkPumps2Down('(L:INI_INNER_TANK_LEFT) 0 == (L:INI_ANNLT_SWITCH) 2 == + 1 min (L:INI_GENERAL_LIGHT_MULTIPLIER) * 1 5 * * (L:INI_DC_LIGHTS_FAILURE) *') -- L TK PUMP2 OFF
kayeroof:GetLtkPumps1Down('(L:INI_OUTER_TANK_LEFT) 0 == (L:INI_ANNLT_SWITCH) 2 == + 1 min (L:INI_GENERAL_LIGHT_MULTIPLIER) * 1 5 * * (L:INI_DC_LIGHTS_FAILURE) *') -- L TK PUMP1 OFF
kayeroof:GetLtkPumps2Up('(L:INI_INNER_TANK_LEFT_FAULT) (L:INI_ANNLT_SWITCH) 2 == + 1 min (L:INI_GENERAL_LIGHT_MULTIPLIER) * 1 5 * * (L:INI_DC_LIGHTS_FAILURE) *') -- L TK PUMP2 FAULT
kayeroof:GetPump1Up('(L:INI_CENTER_TANK_LEFT_FAULT) (L:INI_ANNLT_SWITCH) 2 == + 1 min (L:INI_GENERAL_LIGHT_MULTIPLIER) * 1 5 * * (L:INI_DC_LIGHTS_FAILURE) *') -- CTR PUMP1 FAULT
kayeroof:GetPump1Down('(L:INI_CENTER_TANK_LEFT) 0 == (L:INI_ANNLT_SWITCH) 2 == + 1 min (L:INI_GENERAL_LIGHT_MULTIPLIER) * 1 5 * * (L:INI_DC_LIGHTS_FAILURE) *') -- CTR PUMP1 OFF
kayeroof:GetPump2Down('(L:INI_CENTER_TANK_RIGHT) 0 == (L:INI_ANNLT_SWITCH) 2 == + 1 min (L:INI_GENERAL_LIGHT_MULTIPLIER) * 1 5 * * (L:INI_DC_LIGHTS_FAILURE) *') -- CTR PUMP2 OFF
kayeroof:GetPump2Up('(L:INI_CENTER_TANK_RIGHT_FAULT) (L:INI_ANNLT_SWITCH) 2 == + 1 min (L:INI_GENERAL_LIGHT_MULTIPLIER) * 1 5 * * (L:INI_DC_LIGHTS_FAILURE) *') -- CTR PUMP2 FAULT
kayeroof:GetModeSelDown('(L:INI_FUEL_CTR_TANK_FEED_MAN) 1 == (L:INI_ANNLT_SWITCH) 2 == + 1 min (L:INI_GENERAL_LIGHT_MULTIPLIER) * 1 5 * * (L:INI_AC_LIGHTS_FAILURE) *') -- MODE SEL MAN
kayeroof:GetModeSelUp('0') -- MODE SEL FAULT (not in mfproj)
kayeroof:GetRtkPumps1Up('(L:INI_INNER_TANK_RIGHT) (L:INI_INNER_TANK_RIGHT_PUMP_ON) ! and (L:INI_INNER_TANK_RIGHT_FAULT) or (L:INI_ANNLT_SWITCH) 2 == + 1 min (L:INI_GENERAL_LIGHT_MULTIPLIER) * 1 5 * * (L:INI_DC_LIGHTS_FAILURE) *') -- R TK PUMP1 FAULT
kayeroof:GetRtkPumps1Down('(L:INI_INNER_TANK_RIGHT) 0 == (L:INI_ANNLT_SWITCH) 2 == + 1 min (L:INI_GENERAL_LIGHT_MULTIPLIER) * 1 5 * * (L:INI_DC_LIGHTS_FAILURE) *') -- R TK PUMP1 OFF
kayeroof:GetRtkPumps2Down('(L:INI_OUTER_TANK_RIGHT) 0 == (L:INI_ANNLT_SWITCH) 2 == + 1 min (L:INI_GENERAL_LIGHT_MULTIPLIER) * 1 5 * * (L:INI_DC_LIGHTS_FAILURE) *') -- R TK PUMP2 OFF
kayeroof:GetRtkPumps2Up('(L:INI_OUTER_TANK_RIGHT_FAULT) (L:INI_ANNLT_SWITCH) 2 == + 1 min (L:INI_GENERAL_LIGHT_MULTIPLIER) * 1 5 * * (L:INI_DC_LIGHTS_FAILURE) *') -- R TK PUMP2 FAULT
kayeroof:GetXFeedUp('(L:INI_XFEED_TRANSFER_OPEN) 1 == (L:INI_ANNLT_SWITCH) 2 == + 1 min (L:INI_GENERAL_LIGHT_MULTIPLIER) * 1 5 * * (L:INI_DC_LIGHTS_FAILURE) *') -- X FEED OPEN
kayeroof:GetXFeedDown('(L:INI_XFEED_TRANSFER_ON) 1 == (L:INI_ANNLT_SWITCH) 2 == + 1 min (L:INI_GENERAL_LIGHT_MULTIPLIER) * 1 5 * * (L:INI_DC_LIGHTS_FAILURE) *') -- X FEED ON

-- APU MASTER / START
kayeroof:GetMasterSwUp('(L:INI_APU_MASTER_FAULT) 1 == (L:INI_ANNLT_SWITCH) 2 == + 1 min (L:INI_GENERAL_LIGHT_MULTIPLIER) * 1 5 * * (L:INI_DC_LIGHTS_FAILURE) *') -- APU MASTER FAULT
kayeroof:GetMasterSwDown('(L:INI_APU_MASTER_SWITCH) 1 == (L:INI_ANNLT_SWITCH) 2 == + 1 min (L:INI_GENERAL_LIGHT_MULTIPLIER) * 1 5 * * (L:INI_DC_LIGHTS_FAILURE) *') -- APU MASTER ON
kayeroof:GetStartDown('(L:INI_APU_START_BUTTON) 1 == (L:INI_APU_AVAILABLE) 0 == and') -- APU START ON
kayeroof:GetStartUp('(L:INI_APU_AVAILABLE)') -- APU START AVAIL

-- BAT1V / BAT2V Output LEDs (mfproj display Round — LED channel uses voltage present)
kayeroof:GetBat1v('(L:INI_BATTERY_1_VOLTAGE) 0 !=') -- BAT1 VOLT PRESENT
kayeroof:GetBat2v('(L:INI_BATTERY_2_VOLTAGE) 0 !=') -- BAT2 VOLT PRESENT

-- BACKLIGHT (mfproj: bus powered → 255)
kayeroof:GetBacklight('(L:INI_ELEC_AC_ESS_SHED_BUS_IS_POWERED)', 255) -- OVHD BACKLIGHT

-- PAP3 LedModule "BAT 1+2" (same pattern as z_CFNANO_GA segment Get/Set)
-- mfproj: BAT2 digits 0..2 DP@1, BAT1 digits 3..5 DP@4; Round($,1) → pack 6 digits
local d_pap3_bat1 = iDataRef:New('(L:INI_BATTERY_1_VOLTAGE)')
local d_pap3_bat2 = iDataRef:New('(L:INI_BATTERY_2_VOLTAGE)')
local pap3_bat12_last = -1
local function pack_pap3_bat12(v1, v2)
	local n1 = math.floor((v1 or 0) * 10 + 0.5)
	local n2 = math.floor((v2 or 0) * 10 + 0.5)
	if n1 < 0 then n1 = 0 elseif n1 > 999 then n1 = 999 end
	if n2 < 0 then n2 = 0 elseif n2 > 999 then n2 = 999 end
	return n2 * 1000 + n1
end

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
	local packed = pack_pap3_bat12(d_pap3_bat1:Get(), d_pap3_bat2:Get())
	if packed ~= pap3_bat12_last then
		pap3_bat12_last = packed
		kayeroof:SetBat12(packed)
	end
end)
