-- *****************************************************************
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-10-26
-- *****************************************************************
-- QMOVH-A x Bluebird Simulations B757 (MSFS 2020/2024)
-- LVar 来源: qmdevother/docs/bb757.html (B757_OVHD_* / BBS757_* / B757_PED_FIRE_*)
--
-- QMOVH-A 的物理键位是 B737 顶板布局(键索引 0..87 由硬件固定, 见
-- msfs/QMOVH_A_PMDG737.lua)。本档把每个物理键接到 757 顶板对应功能:
--   * 3 档开关 = 上/中/下三个键索引成组 (0/41/1, 4/42/5, 8/44/9, 22/49/23 ...)
--   * B737 专用的 GPWS 键(50..53) 在 757 上改接液压泵
--   * 硬件表达不了的 757 功能列在文件末尾(ENG START 5 档选择器 / STBY POWER /
--     BUS TIE / GEN DRIVE DISC / 增压旋钮 / 中央液压泵 等)
--
-- Do not remove below lines: aircraft detection (Bluebird B757-200 / B757-300)
-- AIRCRAFT_PATH = MSFS "AircraftLoaded" 完整路径, 含包目录与机型目录,
-- 例如 .../Community/bluebird-simulations-b757/SimObjects/Airplanes/B752/...
if ilua_is_acfpath_excluded("b75") then return end

-- Do not remove below lines: hardware detection
local qmovha = com.sim.qm.Qmovha.Open()
if not qmovha then return end
-- Do not remove above lines: hardware detection

uluaLog("QMOVH-A of Bluebird B757")
-- ===========================================================
-- button binding

-- POS/STROBE  757 只有 ON/OFF, 中档(AUTO)按 ON 处理
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

-- R LANDING lights (757 无 RETRACT 档, 中/下两档都是 OFF)
qmovha:CfgRpn(8, "1 (>L:B757_OVHD_RIGHT_LANDING_LIGHT)")
qmovha:CfgRpn(44, "0 (>L:B757_OVHD_RIGHT_LANDING_LIGHT)")
qmovha:CfgRpn(9, "0 (>L:B757_OVHD_RIGHT_LANDING_LIGHT)")
-- L LANDING lights
qmovha:CfgRpn(10, "1 (>L:B757_OVHD_LEFT_LANDING_LIGHT)")
qmovha:CfgRpn(43, "0 (>L:B757_OVHD_LEFT_LANDING_LIGHT)")
qmovha:CfgRpn(11, "0 (>L:B757_OVHD_LEFT_LANDING_LIGHT)")

-- RUNWAY TURNOFF lights (L+R 同时)
qmovha:CfgRpn(12, "1 (>L:B757_OVHD_RWY_TURN_L) 1 (>L:B757_OVHD_RWY_TURN_R)",
    "0 (>L:B757_OVHD_RWY_TURN_L) 0 (>L:B757_OVHD_RWY_TURN_R)")

-- OVHD INTEG LT KNOB  16: 加亮 17: 减暗 (0~20)
qmovha:CfgRpn(16, "(L:B757_FLOOD_OVHD_KNOB, number) 2 + 20 min (>L:B757_FLOOD_OVHD_KNOB, number)")
qmovha:CfgRpn(17, "(L:B757_FLOOD_OVHD_KNOB, number) 2 - 0 max (>L:B757_FLOOD_OVHD_KNOB, number)")

-- SEAT BELTS  2 档开关; 757 的 AUTO(1) 档硬件不可达
qmovha:CfgRpn(13, "2 (>L:B757_OVHD_SEATBELTS_SWITCH)", "0 (>L:B757_OVHD_SEATBELTS_SWITCH)")

-- NO SMOKING 0:ON 1:AUTO 2:OFF
qmovha:CfgRpn(14, "2 (>L:B757_OVHD_NO_SMOKING_SWITCH)")
qmovha:CfgRpn(48, "1 (>L:B757_OVHD_NO_SMOKING_SWITCH)")
qmovha:CfgRpn(15, "0 (>L:B757_OVHD_NO_SMOKING_SWITCH)")

-- DOME 0:BRT 1:DIM 2:OFF (FLOOD_DOME_KNOB 0~20 连续值)
qmovha:CfgRpn(18, "20 (>L:B757_FLOOD_DOME_KNOB)")
qmovha:CfgRpn(46, "10 (>L:B757_FLOOD_DOME_KNOB)")
qmovha:CfgRpn(19, "0 (>L:B757_FLOOD_DOME_KNOB)")

-- ANN LT / WARNING IND 0:BRT 1:DIM 2:DIM (757 只有 DIM/BRT 两档)
qmovha:CfgRpn(20, "11 (>L:B757_OVHD_WARNING_IND_SWITCH)")
qmovha:CfgRpn(47, "0 (>L:B757_OVHD_WARNING_IND_SWITCH)")
qmovha:CfgRpn(21, "0 (>L:B757_OVHD_WARNING_IND_SWITCH)")

-- EMER EXIT LT 0:ON 1:ARMED 2:OFF (模型里这个 LVar 名叫 PASS_OXY_Toggle)
qmovha:CfgRpn(22, "2 (>L:B757_OVHD_PASS_OXY_Toggle_Switch_CLICK)")
qmovha:CfgRpn(49, "1 (>L:B757_OVHD_PASS_OXY_Toggle_Switch_CLICK)")
qmovha:CfgRpn(23, "0 (>L:B757_OVHD_PASS_OXY_Toggle_Switch_CLICK)")

-- WIPER 0:OFF 1:LOW 2:HIGH (如方向相反, 把 24 和 26 的值对调)
qmovha:CfgRpn(24, "0 (>L:B757_OVHD_WIPER_SWITCH)")
qmovha:CfgRpn(25, "1 (>L:B757_OVHD_WIPER_SWITCH)")
qmovha:CfgRpn(26, "2 (>L:B757_OVHD_WIPER_SWITCH)")

-- APU
---- start: START 档模型 1 秒后自动回 ON
qmovha:CfgRpn(30, "2 (>L:B757_OVHD_APU_SWITCH)")
---- master 0:OFF 1:ON
qmovha:CfgRpn(31, "1 (>L:B757_OVHD_APU_SWITCH)", "0 (>L:B757_OVHD_APU_SWITCH)")

-- ANTI ICE
---- ENG2 (右发)
qmovha:CfgRpn(32, "(L:B757_OVHD_ANTI_ICE_R_ENG_BUTTON) ! (>L:B757_OVHD_ANTI_ICE_R_ENG_BUTTON)")
---- ENG1 (左发)
qmovha:CfgRpn(33, "(L:B757_OVHD_ANTI_ICE_L_ENG_BUTTON) ! (>L:B757_OVHD_ANTI_ICE_L_ENG_BUTTON)")
---- WING
qmovha:CfgRpn(37, "(L:B757_OVHD_ANTI_ICE_WING_BUTTON) ! (>L:B757_OVHD_ANTI_ICE_WING_BUTTON)")

-- AIR COND
---- PACK L: 选择器 0:OFF 1:AUTO 之间切换 (2~4 = STBY N/C/W, 硬件不可达)
qmovha:CfgRpn(34,
    "(L:B757_OVHD_SEL_L_PACK_SWITCH) 0 == if{ 1 (>L:B757_OVHD_SEL_L_PACK_SWITCH) } els{ 0 (>L:B757_OVHD_SEL_L_PACK_SWITCH) }")
---- APU BLEED
qmovha:CfgRpn(35, "(L:B757_OVHD_APU_BUTTON) ! (>L:B757_OVHD_APU_BUTTON)")
---- PACK R
qmovha:CfgRpn(36,
    "(L:B757_OVHD_SEL_R_PACK_SWITCH) 0 == if{ 1 (>L:B757_OVHD_SEL_R_PACK_SWITCH) } els{ 0 (>L:B757_OVHD_SEL_R_PACK_SWITCH) }")

---- ISOLATION VALVE 0:OPEN 1:OPEN(AUTO 档按 OPEN) 2:CLOSE
qmovha:CfgRpn(27, "1 (>L:B757_OVHD_ISOLATION_BUTTON)")
qmovha:CfgRpn(28, "1 (>L:B757_OVHD_ISOLATION_BUTTON)")
qmovha:CfgRpn(29, "0 (>L:B757_OVHD_ISOLATION_BUTTON)")

-- CREW OXYGEN: 757 顶板无 CREW SUPPLY 开关, 改接旅客氧气瓶按钮(带护盖)
qmovha:CfgRpn(38, "1 (>L:B757_OVHD_PASS_OXY_BUTTON)", "0 (>L:B757_OVHD_PASS_OXY_BUTTON)")

-- CALLS (地面呼叫)
qmovha:CfgRpn(40, "1 (>L:B757_OVHD_GND_CALL_BUTTON)", "0 (>L:B757_OVHD_GND_CALL_BUTTON)")

-- HYDRAULIC PUMPS (B737 的 GPWS TERR/SYS/FLAPS3/GND CTL 键位, 757 没有 GPWS 顶板开关)
---- L ENG PUMP
qmovha:CfgRpn(50, "(L:B757_OVHD_L_ENG_HYD_PUMPS_BUTTON) ! (>L:B757_OVHD_L_ENG_HYD_PUMPS_BUTTON)")
---- R ENG PUMP
qmovha:CfgRpn(51, "(L:B757_OVHD_R_ENG_HYD_PUMPS_BUTTON) ! (>L:B757_OVHD_R_ENG_HYD_PUMPS_BUTTON)")
---- L ELEC PUMP
qmovha:CfgRpn(52, "(L:B757_OVHD_L_ENG_ELEC_PUMPS_BUTTON) ! (>L:B757_OVHD_L_ENG_ELEC_PUMPS_BUTTON)")
---- R ELEC PUMP
qmovha:CfgRpn(53, "(L:B757_OVHD_R_ENG_ELEC_PUMPS_BUTTON) ! (>L:B757_OVHD_R_ENG_ELEC_PUMPS_BUTTON)")
-- 中央液压泵 C1/C2 (B757_OVHD_C_ENG1_HYD_PUMPS_BUTTON / C_ENG2_...) 无空闲键位

-- WINDOW HEAT (B737 的 PROBE HEAT / WINDOW HEAT 键): 左/右各带 FWD+SIDE 两路
qmovha:CfgRpn(55,
    "(L:B757_OVHD_L_FWD_WINDOW_HEAT_BUTTON) ! (>L:B757_OVHD_L_FWD_WINDOW_HEAT_BUTTON) (L:B757_OVHD_L_FWD_WINDOW_HEAT_BUTTON) (>L:B757_OVHD_L_SIDE_WINDOW_HEAT_BUTTON)")
qmovha:CfgRpn(56,
    "(L:B757_OVHD_R_FWD_WINDOW_HEAT_BUTTON) ! (>L:B757_OVHD_R_FWD_WINDOW_HEAT_BUTTON) (L:B757_OVHD_R_FWD_WINDOW_HEAT_BUTTON) (>L:B757_OVHD_R_SIDE_WINDOW_HEAT_BUTTON)")

-- APU GEN (B737 键位 57: ADIRU/杂项)
qmovha:CfgRpn(57, "(L:B757_OVHD_APU_GEN_BUTTON) ! (>L:B757_OVHD_APU_GEN_BUTTON)")

-- ELEC
---- GEN CONT L
qmovha:CfgRpn(58, "(L:B757_OVHD_L_GEN_CONT_BUTTON) ! (>L:B757_OVHD_L_GEN_CONT_BUTTON)")
---- BATTERY
qmovha:CfgRpn(59, "(L:B757_OVHD_BATTERY_BUTTON) ! (>L:B757_OVHD_BATTERY_BUTTON)")
---- UTIL BUS L+R (B737 的 IFE/PASS SEATS & CABIN/UTILITY 键)
qmovha:CfgRpn(60,
    "(L:B757_OVHD_L_UTIL_BUS_BUTTON) ! (>L:B757_OVHD_L_UTIL_BUS_BUTTON) (L:B757_OVHD_L_UTIL_BUS_BUTTON) (>L:B757_OVHD_R_UTIL_BUS_BUTTON)")
---- EXT PWR (瞬时按钮)
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
---- XFEED FWD+AFT 同步
qmovha:CfgRpn(66,
    "(L:B757_OVHD_XFEED_PUMPS_FWD_BUTTON) ! (>L:B757_OVHD_XFEED_PUMPS_FWD_BUTTON) (L:B757_OVHD_XFEED_PUMPS_FWD_BUTTON) (>L:B757_OVHD_XFEED_PUMPS_AFT_BUTTON)")

-- FIRE
-- 757 没有独立的灭火瓶释放 LVar: 模型用把手左/右旋转选 1/2 号瓶
-- (0 = 左旋 1 = 中位 2 = 右旋)。写方向后 400ms 回中位。
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

---- 灭火把手: 抬起 = 拉出 1, 按下 = 复位 0
---- ENG1
qmovha:CfgRpn(82, "1 (>L:B757_ENGFIRE_1_SWITCH)", "0 (>L:B757_ENGFIRE_1_SWITCH)")
---- APU
qmovha:CfgRpn(83, "1 (>L:B757_APUFIRE_SWITCH)", "0 (>L:B757_APUFIRE_SWITCH)")
---- ENG2
qmovha:CfgRpn(84, "1 (>L:B757_ENGFIRE_2_SWITCH)", "0 (>L:B757_ENGFIRE_2_SWITCH)")

---- FIRE TEST: 85 发动机 / 86 货舱 / 87 轮舱 (757 是三个测试按钮)
qmovha:CfgRpn(85, "1 (>L:B757_PED_FIRE_ENG_BUTTON)", "0 (>L:B757_PED_FIRE_ENG_BUTTON)")
qmovha:CfgRpn(86, "1 (>L:B757_PED_FIRE_CARGO_BUTTON)", "0 (>L:B757_PED_FIRE_CARGO_BUTTON)")
qmovha:CfgRpn(87, "1 (>L:B757_PED_FIRE_WHLWELL_BUTTON)", "0 (>L:B757_PED_FIRE_WHLWELL_BUTTON)")

-- IRS 0:OFF 1:ALIGN 2:NAV (757 第 4 档 ATT(3) 硬件不可达)
---- IRS L (B737 ADIRU 1)
qmovha:CfgRpn(73, "0 (>L:B757_IRS_L_SWITCH)")
qmovha:CfgRpn(74, "1 (>L:B757_IRS_L_SWITCH)")
qmovha:CfgRpn(75, "2 (>L:B757_IRS_L_SWITCH)")
---- IRS C (B737 ADIRU 2)
qmovha:CfgRpn(76, "0 (>L:B757_IRS_C_SWITCH)")
qmovha:CfgRpn(77, "1 (>L:B757_IRS_C_SWITCH)")
qmovha:CfgRpn(78, "2 (>L:B757_IRS_C_SWITCH)")
---- IRS R (B737 ADIRU 3)
qmovha:CfgRpn(79, "0 (>L:B757_IRS_R_SWITCH)")
qmovha:CfgRpn(80, "1 (>L:B757_IRS_R_SWITCH)")
qmovha:CfgRpn(81, "2 (>L:B757_IRS_R_SWITCH)")

-- 键 39 在 QMOVH-A 上未使用（与 PMDG737 / PMDG777 档一致）
-- -----------------------------------------------------------------------
-- 硬件无法表达的 757 顶板功能 (无空闲键位 / 需要 4~6 档选择器), 未绑定:
--   ENG START L/R (B757_OVHD_L/R_ENG_START_SWITCH: GND/AUTO/OFF/CONT/FLT 5 档)
--   ENGINE IGNITION (B757_OVHD_ENG_START_SWITCH: IGN 1/2/BOTH)
--   STBY POWER (B757_OVHD_STBY_POWER_SWITCH: OFF/AUTO/BAT)
--   BUS TIE L/R, GEN DRIVE DISC L/R, 中央液压泵 C1/C2
--   PACK 选择器 STBY N/C/W 档, YAW DAMPER L/R
--   RECIRC L/R, TRIM AIR, EQUIP, ENG LIMITER L/R, EEC L/R
--   CVR ERASE/TEST, 座舱增压 (MODE SELECT / AUTO RATE / CABIN ALT / LDG ALT)
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

-- BAT 1 = 电瓶, BAT 2 = 备用电源
qmovha:GetUpled2Bat1Up('(L:B757_OVHD_STBYPOWER_BAT_OFF_DECAL)')
qmovha:GetUpled2Bat1Dn('(L:B757_OVHD_BATTERY_BUTTON) !')
qmovha:GetUpled2Bat2Up('(L:B757_OVHD_STBYPOWER_BAT_OFF2_DECAL)')
qmovha:GetUpled2Bat2Dn('(L:B757_OVHD_STBYPOWER_BAT_DISCH_DECAL)')

-- EXT PWR
qmovha:GetUpled2ExtUp('(L:B757_OVHD_APUGENEXTPWR_R_AVAIL_DECAL)')
qmovha:GetUpled2ExtDn('(L:B757_OVHD_EXT_PWR_BUTTON_ON)')

-- ANTI ICE (上灯 = 活门指示, 下灯 = 开关未按入)
qmovha:GetEng2Up('(L:B757_OVHD_ANTI_ICE_ENGR_VALVE_DECAL)')
qmovha:GetEng2Dn('(L:B757_OVHD_ANTI_ICE_R_ENG_BUTTON) !')
qmovha:GetEng1Up('(L:B757_OVHD_ANTI_ICE_ENGL_VALVE_DECAL)')
qmovha:GetEng1Dn('(L:B757_OVHD_ANTI_ICE_L_ENG_BUTTON) !')
qmovha:GetWingUp('(L:B757_OVHD_ANTI_ICE_WING_VALVE_DECAL)')
qmovha:GetWingDn('(L:B757_OVHD_ANTI_ICE_WING_BUTTON) !')

-- AIR COND / BLEED
qmovha:GetPack1Up('(L:B757_OVHD_L_PACK_RESET_INOP_DECAL)')
qmovha:GetPack1Dn('(L:B757_OVHD_SEL_L_PACK_SWITCH) 0 ==')
qmovha:GetApubUp('(L:B757_OVHD_BLEED_APU_VALVE_DECAL)')
qmovha:GetApubDn('(L:B757_OVHD_APU_BUTTON) !')
qmovha:GetPack2Up('(L:B757_OVHD_R_PACK_RESET_INOP_DECAL)')
qmovha:GetPack2Dn('(L:B757_OVHD_SEL_R_PACK_SWITCH) 0 ==')

-- CREW OXY -> 旅客氧气 ON 灯
qmovha:GetCrew('(L:B757_OVHD_PASS_OXY_ON_DECAL)')

-- HYD PUMPS (对应 50..53 四个键)
qmovha:GetUpled1TerrUp('(L:B757_OVHD_L_HYD_PUMPS_ENG_OVHT_DECAL)')
qmovha:GetUpled1TerrDn('(L:B757_OVHD_L_ENG_HYD_PUMPS_BUTTON) !')
qmovha:GetUpled1SysUp('(L:B757_OVHD_R_HYD_PUMPS_ENG_OVHT_DECAL)')
qmovha:GetUpled1SysDn('(L:B757_OVHD_R_ENG_HYD_PUMPS_BUTTON) !')
qmovha:GetUpled1Flap3('(L:B757_OVHD_L_HYD_PUMPS_ELEC_OVHT_DECAL)')
qmovha:GetUpled1Gndctl('(L:B757_OVHD_R_HYD_PUMPS_ELEC_OVHT_DECAL)')

-- IRS L/C/R (ADR1/ADR2/ADR3 灯位)
qmovha:GetUpled1Adr1Up('(L:B757_OVHD_IRS_L_DCFAULT_DECAL)')
qmovha:GetUpled1Adr1Dn('(L:B757_IRS_L_SWITCH) 0 ==')
qmovha:GetUpled1Adr3Up('(L:B757_OVHD_IRS_R_DCFAULT_DECAL)')
qmovha:GetUpled1Adr3Dn('(L:B757_IRS_R_SWITCH) 0 ==')
qmovha:GetUpled1Adr2Up('(L:B757_OVHD_IRS_C_DCFAULT_DECAL)')
qmovha:GetUpled1Adr2Dn('(L:B757_IRS_C_SWITCH) 0 ==')
qmovha:GetUpled1Onbat('(L:B757_OVHD_STBYPOWER_BAT_DISCH_DECAL)')

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

-- FIRE 把手灯 (Fire1=ENG1 Firea=APU Fire2=ENG2)
qmovha:GetUpled1Fire2('(L:B757_R_ENG_FIRE_ACTIVE)')
qmovha:GetUpled1Firea('(L:B757_APU_FIRE_ACTIVE)')
qmovha:GetUpled1Fire1('(L:B757_L_ENG_FIRE_ACTIVE)')
-- 757 模型没有发动机灭火瓶 SQUIB 灯 LVar, 这 4 个灯位保持熄灭
qmovha:GetUpled2Eng1ag1('0')
qmovha:GetUpled2Eng1ag2('0')
qmovha:GetUpled2Eng2ag1('0')
qmovha:GetUpled2Eng2ag2('0')

-- 顶板亮度 = B757_FLOOD_OVHD_KNOB (0~20 -> 0~100)
qmovha:GetBkl('(L:B757_FLOOD_OVHD_KNOB, number) 5 *', 1)

-- 亮度/暗位: 757 只有 DIM(0) / BRT(11) 两档
qmovha:GetBrtDim('(L:B757_OVHD_WARNING_IND_SWITCH, number)', 11)

-- 顶板 AC 温度显示: 左组件开关 + 驾驶舱温度选择 (18~30 摄氏度)
qmovha:GetAirCond('(L:B757_OVHD_SEL_L_PACK_SWITCH, number) 0 ==',
    '(L:B757_OVHD_FLT_DK_ZONE_TEMP_SEL, number)', 1, 0)

-- 灯测试 (OVHD_TEST_LTS = 1) 时硬件自己点亮全部灯
local dr_test = iDataRef:New('(L:OVHD_TEST_LTS)')
local dr_bat = iDataRef:New('(L:B757_OVHD_BATTERY_BUTTON)')
local dr_ext = iDataRef:New('(L:B757_OVHD_EXT_PWR_BUTTON_ON)')
local state_test = 0

GlobalFrameLoopManager:add(function()
    -- expert code: test mode
    if dr_test:ChangedUpdate() then
        state_test = dr_test:GetOld() -- ChangedUpdate 之后只取 GetOld, 不再 Get
        if state_test >= 1 and (dr_bat:Get() >= 1 or dr_ext:Get() >= 1) then
            -- TEST
            uluaSet(idr_qmovh_a_hid_mode_off, 0)
            uluaSet(idr_qmovh_a_hid_mode_test, 1)
        else
            uluaSet(idr_qmovh_a_hid_mode_test, 0)
            -- 退出 test: Lua 侧灯值没变 -> Set* 不会重写, 必须逼整块重刷,
            -- 否则面板停在测试图案上
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
