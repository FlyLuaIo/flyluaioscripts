-- *****************************************************************
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-10-26
-- *****************************************************************
-- QMOVH-A x Bluebird Simulations B757 (MSFS 2020/2024)
-- LVar source: qmdevother/docs/bb757.html (B757_OVHD_* / BBS757_* / B757_PED_FIRE_*)
--
-- The QMOVH-A key indices 0..87 are fixed by hardware and follow the B737
-- overhead panel layout (see msfs/QMOVH_A_PMDG737.lua). This profile wires
-- every physical key to the matching B757 overhead function:
--   * 3-position switches = one key index per detent, grouped
--     (0/41/1, 4/42/5, 8/44/9, 22/49/23 ...)
--   * keys 50..53 are B737-only GPWS keys, remapped to B757 hydraulic pumps
--   * B757 functions that the hardware cannot express (5-position ENG START
--     selectors, STBY POWER, BUS TIE, GEN DRIVE DISC, pressurization knobs,
--     center hydraulic pumps, ...) are listed unbound at the end of the file
--
if ilua_require_bluebird_757() then return end

-- Do not remove below lines: hardware detection
local qmovha = com.sim.qm.Qmovha.Open()
if not qmovha then return end
-- Do not remove above lines: hardware detection

uluaLog("QMOVH-A of Bluebird B757")
-- ===========================================================
-- button binding

-- POS/STROBE: B757 has ON/OFF only; the AUTO detent is treated as ON
qmovha:CfgRpn(0, "1 (>L:B757_OVHD_STROBE)")
qmovha:CfgRpn(41, "1 (>L:B757_OVHD_STROBE)")
qmovha:CfgRpn(1, "0 (>L:B757_OVHD_STROBE)")

-- BEACON lights
qmovha:CfgRpn(2, "1 (>L:B757_OVHD_BEACON_LIGHT)", "0 (>L:B757_OVHD_BEACON_LIGHT)")

-- WING lights
qmovha:CfgRpn(3, "1 (>L:B757_OVHD_WING_LIGHTS)", "0 (>L:B757_OVHD_WING_LIGHTS)")

-- NAV & LOGO 0:NAV+LOGO 1:NAV 2:OFF
qmovha:CfgRpn(4, "1 (>L:B757_OVHD_NAV_LIGHTS) 1 (>L:B757_OVHD_LOGO_BUTTON)")
qmovha:CfgRpn(42, "1 (>L:B757_OVHD_NAV_LIGHTS) 0 (>L:B757_OVHD_LOGO_BUTTON)")
qmovha:CfgRpn(5, "0 (>L:B757_OVHD_NAV_LIGHTS) 0 (>L:B757_OVHD_LOGO_BUTTON)")

-- NOSE LANDING / TAXI light
qmovha:CfgRpn(6, "1 (>L:B757_OVHD_NOSE_LANDING_LIGHT)")
qmovha:CfgRpn(45, "1 (>L:B757_OVHD_NOSE_LANDING_LIGHT)")
qmovha:CfgRpn(7, "0 (>L:B757_OVHD_NOSE_LANDING_LIGHT)")

-- R LANDING lights (no RETRACT detent on B757: center and down are both OFF)
qmovha:CfgRpn(8, "1 (>L:B757_OVHD_RIGHT_LANDING_LIGHT)")
qmovha:CfgRpn(44, "0 (>L:B757_OVHD_RIGHT_LANDING_LIGHT)")
qmovha:CfgRpn(9, "0 (>L:B757_OVHD_RIGHT_LANDING_LIGHT)")
-- L LANDING lights
qmovha:CfgRpn(10, "1 (>L:B757_OVHD_LEFT_LANDING_LIGHT)")
qmovha:CfgRpn(43, "0 (>L:B757_OVHD_LEFT_LANDING_LIGHT)")
qmovha:CfgRpn(11, "0 (>L:B757_OVHD_LEFT_LANDING_LIGHT)")

-- RUNWAY TURNOFF lights (L and R together)
qmovha:CfgRpn(12, "1 (>L:B757_OVHD_RWY_TURN_L) 1 (>L:B757_OVHD_RWY_TURN_R)",
    "0 (>L:B757_OVHD_RWY_TURN_L) 0 (>L:B757_OVHD_RWY_TURN_R)")

-- OVHD INTEG LT KNOB  16: brighter 17: dimmer (0~20)
qmovha:CfgRpn(16, "(L:B757_FLOOD_OVHD_KNOB, number) 2 + 20 min (>L:B757_FLOOD_OVHD_KNOB, number)")
qmovha:CfgRpn(17, "(L:B757_FLOOD_OVHD_KNOB, number) 2 - 0 max (>L:B757_FLOOD_OVHD_KNOB, number)")

-- SEAT BELTS: 2-position switch; the B757 AUTO(1) detent is unreachable
qmovha:CfgRpn(13, "2 (>L:B757_OVHD_SEATBELTS_SWITCH)", "0 (>L:B757_OVHD_SEATBELTS_SWITCH)")

-- NO SMOKING 0:ON 1:AUTO 2:OFF
qmovha:CfgRpn(14, "2 (>L:B757_OVHD_NO_SMOKING_SWITCH)")
qmovha:CfgRpn(48, "1 (>L:B757_OVHD_NO_SMOKING_SWITCH)")
qmovha:CfgRpn(15, "0 (>L:B757_OVHD_NO_SMOKING_SWITCH)")

-- DOME 0:BRT 1:DIM 2:OFF (FLOOD_DOME_KNOB is continuous 0~20)
qmovha:CfgRpn(18, "20 (>L:B757_FLOOD_DOME_KNOB)")
qmovha:CfgRpn(46, "10 (>L:B757_FLOOD_DOME_KNOB)")
qmovha:CfgRpn(19, "0 (>L:B757_FLOOD_DOME_KNOB)")

-- ANN LT / WARNING IND 0:BRT 1:DIM 2:DIM (B757 only has DIM/BRT)
qmovha:CfgRpn(20, "1 (>L:OVHD_TEST_LTS)")
qmovha:CfgRpn(47, "0 (>L:OVHD_TEST_LTS) 11 (>L:B757_OVHD_WARNING_IND_SWITCH)")
qmovha:CfgRpn(21, "0 (>L:B757_OVHD_WARNING_IND_SWITCH)")

-- EMER EXIT LT 0:ON 1:ARMED 2:OFF (this LVar is named PASS_OXY_Toggle in the model)
qmovha:CfgRpn(22, "0 (>L:B757_OVHD_SWITCH_GAURD) 2 (>L:B757_OVHD_PASS_OXY_Toggle_Switch_CLICK)")
qmovha:CfgRpn(49, "1 (>L:B757_OVHD_SWITCH_GAURD) 1 (>L:B757_OVHD_PASS_OXY_Toggle_Switch_CLICK)")
qmovha:CfgRpn(23, "1 (>L:B757_OVHD_SWITCH_GAURD) 0 (>L:B757_OVHD_PASS_OXY_Toggle_Switch_CLICK)")

-- WIPER 0:OFF 1:LOW 2:HIGH (if the direction is inverted, swap the values of 24 and 26)
qmovha:CfgRpn(24, "0 (>L:B757_OVHD_WIPER_SWITCH)")
qmovha:CfgRpn(25, "1 (>L:B757_OVHD_WIPER_SWITCH)")
qmovha:CfgRpn(26, "2 (>L:B757_OVHD_WIPER_SWITCH)")

-- APU
---- start: the START detent returns to ON after 1 second in the model
qmovha:CfgRpn(30, "2 (>L:B757_OVHD_APU_SWITCH)")
---- master 0:OFF 1:ON
qmovha:CfgRpn(31, "(L:B757_OVHD_APU_SWITCH) ! (>L:B757_OVHD_APU_SWITCH)")

-- ANTI ICE
---- ENG2 (right engine)
qmovha:CfgRpn(32, "(L:B757_OVHD_ANTI_ICE_R_ENG_BUTTON) ! (>L:B757_OVHD_ANTI_ICE_R_ENG_BUTTON)")
---- ENG1 (left engine)
qmovha:CfgRpn(33, "(L:B757_OVHD_ANTI_ICE_L_ENG_BUTTON) ! (>L:B757_OVHD_ANTI_ICE_L_ENG_BUTTON)")
---- WING
qmovha:CfgRpn(37, "(L:B757_OVHD_ANTI_ICE_WING_BUTTON) ! (>L:B757_OVHD_ANTI_ICE_WING_BUTTON)")

-- AIR COND
---- PACK L: toggles between 0:OFF and 1:AUTO (2~4 = STBY N/C/W, not reachable)
qmovha:CfgRpn(34,
    "(L:B757_OVHD_SEL_L_PACK_SWITCH) 0 == if{ 1 (>L:B757_OVHD_SEL_L_PACK_SWITCH) } els{ 0 (>L:B757_OVHD_SEL_L_PACK_SWITCH) }")
---- APU BLEED
qmovha:CfgRpn(35, "(L:B757_OVHD_APU_BUTTON) ! (>L:B757_OVHD_APU_BUTTON)")
---- PACK R
qmovha:CfgRpn(36,
    "(L:B757_OVHD_SEL_R_PACK_SWITCH) 0 == if{ 1 (>L:B757_OVHD_SEL_R_PACK_SWITCH) } els{ 0 (>L:B757_OVHD_SEL_R_PACK_SWITCH) }")

---- ISOLATION VALVE 0:OPEN 1:OPEN (AUTO detent treated as OPEN) 2:CLOSE
qmovha:CfgRpn(27, "1 (>L:B757_OVHD_ISOLATION_BUTTON)")
qmovha:CfgRpn(28, "1 (>L:B757_OVHD_ISOLATION_BUTTON)")
qmovha:CfgRpn(29, "0 (>L:B757_OVHD_ISOLATION_BUTTON)")

-- CREW OXYGEN: the B757 overhead has no CREW SUPPLY switch,
-- remapped to the (guarded) passenger oxygen bottle button
qmovha:CfgRpn(38, "1 (>L:B757_OVHD_PASS_OXY_BUTTON)", "0 (>L:B757_OVHD_PASS_OXY_BUTTON)")

-- CALLS (ground call)
qmovha:CfgRpn(40, "1 (>L:B757_OVHD_GND_CALL_BUTTON)", "0 (>L:B757_OVHD_GND_CALL_BUTTON)")

-- HYDRAULIC PUMPS (B737 GPWS TERR/SYS/FLAPS3/GND CTL keys; the B757 has no
-- GPWS switches on the overhead panel)
---- L ENG PUMP
qmovha:CfgRpn(50, "(L:B757_OVHD_L_ENG_HYD_PUMPS_BUTTON) ! (>L:B757_OVHD_L_ENG_HYD_PUMPS_BUTTON)")
---- R ENG PUMP
qmovha:CfgRpn(51, "(L:B757_OVHD_R_ENG_HYD_PUMPS_BUTTON) ! (>L:B757_OVHD_R_ENG_HYD_PUMPS_BUTTON)")
---- L ELEC PUMP
qmovha:CfgRpn(52, "(L:B757_OVHD_L_ENG_ELEC_PUMPS_BUTTON) ! (>L:B757_OVHD_L_ENG_ELEC_PUMPS_BUTTON)")
---- R ELEC PUMP
qmovha:CfgRpn(53, "(L:B757_OVHD_R_ENG_ELEC_PUMPS_BUTTON) ! (>L:B757_OVHD_R_ENG_ELEC_PUMPS_BUTTON)")
-- center hydraulic pumps C1/C2 (B757_OVHD_C_ENG1_HYD_PUMPS_BUTTON / C_ENG2_...)
-- have no free key index

-- WINDOW HEAT (B737 PROBE HEAT / WINDOW HEAT keys): left and right group,
-- each key drives both the FWD and the SIDE window heat channel
qmovha:CfgRpn(55,
    "(L:B757_OVHD_L_FWD_WINDOW_HEAT_BUTTON) ! (>L:B757_OVHD_L_FWD_WINDOW_HEAT_BUTTON) (L:B757_OVHD_L_FWD_WINDOW_HEAT_BUTTON) (>L:B757_OVHD_L_SIDE_WINDOW_HEAT_BUTTON)")
qmovha:CfgRpn(56,
    "(L:B757_OVHD_R_FWD_WINDOW_HEAT_BUTTON) ! (>L:B757_OVHD_R_FWD_WINDOW_HEAT_BUTTON) (L:B757_OVHD_R_FWD_WINDOW_HEAT_BUTTON) (>L:B757_OVHD_R_SIDE_WINDOW_HEAT_BUTTON)")

-- APU GEN (B737 key 57 is ADIRU / miscellaneous)
qmovha:CfgRpn(57, "(L:B757_OVHD_APU_GEN_BUTTON) ! (>L:B757_OVHD_APU_GEN_BUTTON)")

-- ELEC
---- GEN CONT L
qmovha:CfgRpn(58, "(L:B757_OVHD_L_GEN_CONT_BUTTON) ! (>L:B757_OVHD_L_GEN_CONT_BUTTON)")
---- BATTERY
qmovha:CfgRpn(59, "(L:B757_OVHD_BATTERY_BUTTON) ! (>L:B757_OVHD_BATTERY_BUTTON)")
---- UTIL BUS L+R (B737 IFE/PASS SEATS & CABIN/UTILITY key)
qmovha:CfgRpn(60,
    "(L:B757_OVHD_L_UTIL_BUS_BUTTON) ! (>L:B757_OVHD_L_UTIL_BUS_BUTTON) (L:B757_OVHD_L_UTIL_BUS_BUTTON) (>L:B757_OVHD_R_UTIL_BUS_BUTTON)")
---- EXT PWR (momentary button)
qmovha:CfgRpn(61, "1 (>L:B757_OVHD_EXT_PWR_BUTTON)", "0 (>L:B757_OVHD_EXT_PWR_BUTTON)")
---- GEN CONT R
qmovha:CfgRpn(62, "(L:B757_OVHD_R_GEN_CONT_BUTTON) ! (>L:B757_OVHD_R_GEN_CONT_BUTTON)")

-- FUEL
---- L FWD
qmovha:CfgRpn(54, "(L:B757_OVHD_L_PUMPS_FWD_BUTTON) ! (>L:B757_OVHD_L_PUMPS_FWD_BUTTON)")
---- L AFT
qmovha:CfgRpn(68, "(L:B757_OVHD_L_PUMPS_AFT_BUTTON) ! (>L:B757_OVHD_L_PUMPS_AFT_BUTTON)")
---- C LEFT
qmovha:CfgRpn(67, "(L:B757_OVHD_C_PUMPS_L_BUTTON) ! (>L:B757_OVHD_C_PUMPS_L_BUTTON)")
---- C RIGHT
qmovha:CfgRpn(65, "(L:B757_OVHD_C_PUMPS_R_BUTTON) ! (>L:B757_OVHD_C_PUMPS_R_BUTTON)")
---- R FWD
qmovha:CfgRpn(64, "(L:B757_OVHD_R_PUMPS_FWD_BUTTON) ! (>L:B757_OVHD_R_PUMPS_FWD_BUTTON)")
---- R AFT
qmovha:CfgRpn(63, "(L:B757_OVHD_R_PUMPS_AFT_BUTTON) ! (>L:B757_OVHD_R_PUMPS_AFT_BUTTON)")
---- XFEED FWD+AFT kept in sync
qmovha:CfgRpn(66,
    "(L:B757_OVHD_XFEED_PUMPS_FWD_BUTTON) ! (>L:B757_OVHD_XFEED_PUMPS_FWD_BUTTON) (L:B757_OVHD_XFEED_PUMPS_FWD_BUTTON) (>L:B757_OVHD_XFEED_PUMPS_AFT_BUTTON)")

-- FIRE
-- The B757 has no dedicated fire-bottle discharge LVar: the model selects
-- bottle 1/2 by rotating the handle left/right
-- (0 = left rotation, 1 = neutral, 2 = right rotation).
-- Written value returns to neutral after 400 ms.
function qmovha_bluebird757_agent(varname, dir)
    uluaWriteCmd(dir .. " (>L:" .. varname .. ")")
    uluasetTimeout("uluaWriteCmd('1 (>L:" .. varname .. ")')", 400)
end

---- ENG2 agent2
qmovha:CfgFc(69, "qmovha_bluebird757_agent('BBS757_ENG2_FIRE_HANDLE_ROTATION', 2)")
---- ENG2 agent1
qmovha:CfgFc(70, "qmovha_bluebird757_agent('BBS757_ENG2_FIRE_HANDLE_ROTATION', 0)")
---- ENG1 agent2
qmovha:CfgFc(71, "qmovha_bluebird757_agent('BBS757_ENG1_FIRE_HANDLE_ROTATION', 2)")
---- ENG1 agent1
qmovha:CfgFc(72, "qmovha_bluebird757_agent('BBS757_ENG1_FIRE_HANDLE_ROTATION', 0)")

---- fire handles: up = pulled (1), down = reset (0)
---- ENG1
qmovha:CfgRpn(82, "1 (>L:B757_ENGFIRE_1_SWITCH)", "0 (>L:B757_ENGFIRE_1_SWITCH)")
---- APU
qmovha:CfgRpn(83, "1 (>L:B757_APUFIRE_SWITCH)", "0 (>L:B757_APUFIRE_SWITCH)")
---- ENG2
qmovha:CfgRpn(84, "1 (>L:B757_ENGFIRE_2_SWITCH)", "0 (>L:B757_ENGFIRE_2_SWITCH)")

---- FIRE TEST: 85 engines / 86 cargo / 87 wheel well (three test buttons on B757)
qmovha:CfgRpn(85, "1 (>L:B757_PED_FIRE_ENG_BUTTON)", "0 (>L:B757_PED_FIRE_ENG_BUTTON)")
qmovha:CfgRpn(86, "1 (>L:B757_PED_FIRE_CARGO_BUTTON)", "0 (>L:B757_PED_FIRE_CARGO_BUTTON)")
qmovha:CfgRpn(87, "1 (>L:B757_PED_FIRE_WHLWELL_BUTTON)", "0 (>L:B757_PED_FIRE_WHLWELL_BUTTON)")

-- IRS 0:OFF 1:ALIGN 2:NAV (the B757 4th detent ATT(3) is not reachable)
---- IRS L (B737 ADIRU 1)
qmovha:CfgRpn(73, "0 (>L:B757_IRS_L_SWITCH)")
qmovha:CfgRpn(74, "2 (>L:B757_IRS_L_SWITCH)")
qmovha:CfgRpn(75, "3 (>L:B757_IRS_L_SWITCH)")
---- IRS R (B737 ADIRU 2)
qmovha:CfgRpn(76, "0 (>L:B757_IRS_R_SWITCH)")
qmovha:CfgRpn(77, "2 (>L:B757_IRS_R_SWITCH)")
qmovha:CfgRpn(78, "3 (>L:B757_IRS_R_SWITCH)")
---- IRS C (B737 ADIRU 3)
qmovha:CfgRpn(79, "0 (>L:B757_IRS_c_SWITCH)")
qmovha:CfgRpn(80, "2 (>L:B757_IRS_c_SWITCH)")
qmovha:CfgRpn(81, "3 (>L:B757_IRS_c_SWITCH)")

-- key 39 is unused on the QMOVH-A (same as the PMDG737 / PMDG777 profiles)
-- -----------------------------------------------------------------------
-- B757 overhead functions the hardware cannot express (no free key index /
-- requires a 4~6 position selector), left unbound:
--   ENG START L/R (B757_OVHD_L/R_ENG_START_SWITCH: GND/AUTO/OFF/CONT/FLT, 5 positions)
--   ENGINE IGNITION (B757_OVHD_ENG_START_SWITCH: IGN 1/2/BOTH)
--   STBY POWER (B757_OVHD_STBY_POWER_SWITCH: OFF/AUTO/BAT)
--   BUS TIE L/R, GEN DRIVE DISC L/R, center hydraulic pumps C1/C2
--   PACK selector STBY N/C/W detents, YAW DAMPER L/R
--   RECIRC L/R, TRIM AIR, EQUIP, ENG LIMITER L/R, EEC L/R
--   CVR ERASE/TEST, pressurization (MODE SELECT / AUTO RATE / CABIN ALT / LDG ALT)
-- -----------------------------------------------------------------------

-- ===========================================================
-- Read data for lights

-- APU
qmovha:GetStartUp('(L:B757_OVHD_APU_RUN_DECAL)')
qmovha:GetStartDn('(L:B757_APU_STARTER_ON)')
qmovha:GetMswUp('(L:B757_OVHD_APU_FAULT_DECAL)')
qmovha:GetMswDn('(L:B757_OVHD_APU_SWITCH) 1 >=')

-- ELEC GEN L/R
qmovha:GetUpled2Gen1Up('(L:B757_OVHD_GENCONT_L_OFF_DECAL)')
qmovha:GetUpled2Gen1Dn('(L:B757_OVHD_APUGENEXTPWR_L_BUS_BUS_OFF_DECAL)')
qmovha:GetUpled2Gen2Up('(L:B757_OVHD_GENCONT_R_OFF_DECAL)')
qmovha:GetUpled2Gen2Dn('(L:B757_OVHD_APUGENEXTPWR_R_BUS_BUS_OFF_DECAL)')

-- BAT 1 = battery, BAT 2 = standby power
qmovha:GetUpled2Bat1Up('(L:B757_OVHD_STBYPOWER_BAT_OFF_DECAL)')
qmovha:GetUpled2Bat1Dn('(L:B757_OVHD_BATTERY_BUTTON) !')
qmovha:GetUpled2Bat2Up('(L:B757_OVHD_STBYPOWER_BAT_OFF2_DECAL)')
qmovha:GetUpled2Bat2Dn('(L:B757_OVHD_STBYPOWER_BAT_DISCH_DECAL)')

-- EXT PWR
qmovha:GetUpled2ExtUp('(L:B757_OVHD_APUGENEXTPWR_R_AVAIL_DECAL)')
qmovha:GetUpled2ExtDn('(L:B757_OVHD_EXT_PWR_BUTTON_ON)')

-- ANTI ICE (upper LED = valve indication, lower LED = switch not pressed in)
qmovha:GetEng2Up('(L:B757_OVHD_ANTI_ICE_WING_R_VALVE_DECAL)')
qmovha:GetEng2Dn('(L:B757_OVHD_ANTI_ICE_R_ENG_BUTTON_ON)')
qmovha:GetEng1Up('(L:B757_OVHD_ANTI_ICE_WING_L_VALVE_DECAL)')
qmovha:GetEng1Dn('(L:B757_OVHD_ANTI_ICE_L_ENG_BUTTON_ON)')
qmovha:GetWingUp('(L:B757_OVHD_ANTI_ICE_ENGL_VALVE_DECAL) (L:B757_OVHD_ANTI_ICE_ENGR_VALVE_DECAL) or')
qmovha:GetWingDn('(L:B757_OVHD_ANTI_ICE_WING_BUTTON_ON)')

-- AIR COND / BLEED
qmovha:GetPack1Up('(L:B757_OVHD_L_PACK_RESET_INOP_DECAL)')
qmovha:GetPack1Dn('(L:B757_OVHD_SEL_L_PACK_SWITCH) 0 ==')
qmovha:GetApubUp('(L:B757_OVHD_BLEED_APU_VALVE_DECAL)')
qmovha:GetApubDn('(L:B757_OVHD_APU_BUTTON)')
qmovha:GetPack2Up('(L:B757_OVHD_R_PACK_RESET_INOP_DECAL)')
qmovha:GetPack2Dn('(L:B757_OVHD_SEL_R_PACK_SWITCH) 0 ==')

-- CREW OXY -> passenger oxygen ON light
qmovha:GetCrew('(L:B757_OVHD_PASS_OXY_ON_DECAL)')

-- HYD PUMPS (wired to keys 50..53)
qmovha:GetUpled1TerrUp('(L:B757_OVHD_L_HYD_PUMPS_ENG_OVHT_DECAL)')
qmovha:GetUpled1TerrDn('(L:B757_OVHD_L_ENG_HYD_PUMPS_BUTTON) !')
qmovha:GetUpled1SysUp('(L:B757_OVHD_R_HYD_PUMPS_ENG_OVHT_DECAL)')
qmovha:GetUpled1SysDn('(L:B757_OVHD_R_ENG_HYD_PUMPS_BUTTON) !')
qmovha:GetUpled1Flap3('(L:B757_OVHD_L_HYD_PUMPS_ELEC_OVHT_DECAL)')
qmovha:GetUpled1Gndctl('(L:B757_OVHD_R_HYD_PUMPS_ELEC_OVHT_DECAL)')

-- IRS L/C/R (ADR1 / ADR2 / ADR3 LED channels)
qmovha:GetUpled1Adr1Up('(L:B757_OVHD_IRS_L_DCFAULT_DECAL)')
qmovha:GetUpled1Adr1Dn('(L:B757_IRS_L_SWITCH) 0 ==')
qmovha:GetUpled1Adr3Up('(L:B757_OVHD_IRS_R_DCFAULT_DECAL)')
qmovha:GetUpled1Adr3Dn('(L:B757_IRS_R_SWITCH) 0 ==')
qmovha:GetUpled1Adr2Up('(L:B757_OVHD_IRS_C_DCFAULT_DECAL)')
qmovha:GetUpled1Adr2Dn('(L:B757_IRS_C_SWITCH) 0 ==')
qmovha:GetUpled1Onbat(
    '(L:B757_OVHD_IRS_C_ONDC_DECAL) (L:B757_OVHD_IRS_L_ONDC_DECAL) or (L:B757_OVHD_IRS_R_ONDC_DECAL) or')

-- FUEL PUMPS L FWD/AFT, C L/R, R FWD/AFT
qmovha:GetUpled1Ltk1Up('(L:B757_OVHD_L_PUMPS_FWD_PRESS_DECAL)')
qmovha:GetUpled1Ltk1Dn('(L:B757_OVHD_L_PUMPS_FWD_BUTTON) !')
qmovha:GetUpled1Ltk2Up('(L:B757_OVHD_L_PUMPS_AFT_PRESS_DECAL)')
qmovha:GetUpled1Ltk2Dn('(L:B757_OVHD_L_PUMPS_AFT_BUTTON) !')
qmovha:GetUpled1CtklUp('(L:B757_OVHD_C_PUMPS_FWD_PRESS_DECAL)')
qmovha:GetUpled1CtklDn('(L:B757_OVHD_C_PUMPS_L_BUTTON) !')
qmovha:GetUpled1CtkrUp('(L:B757_OVHD_C_PUMPS_AFT_PRESS_DECAL)')
qmovha:GetUpled1CtkrDn('(L:B757_OVHD_C_PUMPS_R_BUTTON) !')
qmovha:GetUpled2Rtk1Up('(L:B757_OVHD_R_PUMPS_FWD_PRESS_DECAL)')
qmovha:GetUpled2Rtk1Dn('(L:B757_OVHD_R_PUMPS_FWD_BUTTON) !')
qmovha:GetUpled2Rtk2Up('(L:B757_OVHD_R_PUMPS_AFT_PRESS_DECAL)')
qmovha:GetUpled2Rtk2Dn('(L:B757_OVHD_R_PUMPS_AFT_BUTTON) !')
qmovha:GetUpled2XfeedUp('(L:B757_OVHD_XFEED_PUMPS_FWD_BUTTON)')
qmovha:GetUpled2XfeedDn('(L:B757_OVHD_XFEED_PUMPS_FWD_BUTTON) !')

-- FIRE handle lights (Fire1=ENG1 Firea=APU Fire2=ENG2)
qmovha:GetUpled1Fire2('(L:B757_R_ENG_FIRE_ACTIVE)')
qmovha:GetUpled1Firea('(L:B757_APU_FIRE_ACTIVE)')
qmovha:GetUpled1Fire1('(L:B757_L_ENG_FIRE_ACTIVE)')
-- the B757 model exposes no engine bottle SQUIB LVar: these 4 LEDs stay dark
qmovha:GetUpled2Eng1ag1('0')
qmovha:GetUpled2Eng1ag2('0')
qmovha:GetUpled2Eng2ag1('0')
qmovha:GetUpled2Eng2ag2('0')

-- panel backlight = B757_FLOOD_OVHD_KNOB (0~20 -> 0~100)
qmovha:GetBkl('(L:B757_FLOOD_OVHD_KNOB, number) 5 *', 1)

-- bright/dim: the B757 has DIM(0) / BRT(11) only
qmovha:GetBrtDim('(L:B757_OVHD_WARNING_IND_SWITCH, number)', 11)

-- overhead AC temperature display: left pack switch + flight deck temp selector
-- (18~30 degrees C)
qmovha:GetAirCond('(L:B757_OVHD_SEL_L_PACK_SWITCH, number) 0 ==',
    '(L:B757_OVHD_FLT_DK_ZONE_TEMP_SEL, number)', 1, 0)

-- lamp test (OVHD_TEST_LTS = 1) is handled by the hardware itself
local dr_test = iDataRef:New('(L:OVHD_TEST_LTS)')
local dr_bat = iDataRef:New('(L:B757_OVHD_BATTERY_BUTTON)')
local dr_ext = iDataRef:New('(L:B757_OVHD_EXT_PWR_BUTTON_ON)')
local state_test = 0

GlobalFrameLoopManager:add(function()
    -- expert code: test mode
    if dr_test:ChangedUpdate() then
        state_test = dr_test:GetOld() -- after ChangedUpdate use GetOld only, never Get
        if state_test >= 1 and (dr_bat:Get() >= 1 or dr_ext:Get() >= 1) then
            -- TEST
            uluaSet(idr_qmovh_a_hid_mode_off, 0)
            uluaSet(idr_qmovh_a_hid_mode_test, 1)
        else
            uluaSet(idr_qmovh_a_hid_mode_test, 0)
            -- leaving test: the Lua side values did not change, so Set*() would
            -- not rewrite them and the panel would stay on the test pattern
            qmovha:FreshAllled()
            qmovha:FreshBkl()
        end
    end

    if state_test >= 1 then
        -- TEST
        return
    end

    qmovha:SetStartUp()
    qmovha:SetStartDn()
    qmovha:SetMswUp()
    qmovha:SetMswDn()
    qmovha:SetEng2Up()
    qmovha:SetEng2Dn()
    qmovha:SetEng1Up()
    qmovha:SetEng1Dn()
    qmovha:SetPack1Up()
    qmovha:SetPack1Dn()
    qmovha:SetApubUp()
    qmovha:SetApubDn()
    qmovha:SetPack2Up()
    qmovha:SetPack2Dn()
    qmovha:SetWingUp()
    qmovha:SetWingDn()
    qmovha:SetCrew()
    --
    qmovha:SetUpled1()
    qmovha:SetUpled2()

    qmovha:SetBkl()
    qmovha:SetBrtDim()
    qmovha:SetAirCond()
end)
