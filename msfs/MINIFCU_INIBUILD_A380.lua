-- *****************************************************************
-- FlyLuaIO MobiFlight miniFCU (miniFCU + miniEFIS) for MSFS
-- iniBuilds A380（gate: ilua_require_inibuild_a380()，acfpath "a38" + "inibuild"）
-- created by Wei Shuai <cpuwolf@gmail.com>
-- *****************************************************************
-- 来源与依据（可追溯）：
--   * 事件名 / L 变量 / B 事件 / 显示表达式：msfs/data/QFCU_INIBUILD_A380.lua（同机型 QFCU 档，MSFS 实测通过）。
--     每条绑定后的 [Q#] 标注该功能在 QFCU 面板上的 KeyIdx，便于与 QFCU 档逐条对照。
--   * 硬件通道契约：mobiflight/MiniFCU.json（按键 bit 0–46、编码器 bit 47–66、
--     6 个 Output pin、26 条 CustomDevice 通道）。
--   * 通道语义 / 编码器位序：xp/MINIFCU_Toliss.lua（真机 miniFCU 在 X-Plane 上手工调过并实测）。
--   * iniBuilds 变量清单旁证：docs/cpuwolf.ini380.lvars.txt / docs/cpuwolf.ini380.bevents.txt。
-- 编码器位序（沿用 XP 档，勿改）：每轴 4 bit，前 2 bit = 减，后 2 bit = 加。
--   ALT 47/48 减 · 49/50 加；SPD 51/52 · 53/54；HDG 55/56 · 57/58；VS 59/60 · 61/62；BARO 63/64 · 65/66
-- 已知取舍（待真机验证）：
--   1. 断电门控 / ANN LT 测试：与参考档同源 —— (L:INI_battery_on) 断电熄屏、
--      (L:INI_ANNLT_SWITCH) == 0 进 TEST，做法同 xp/MINIFCU_Toliss.lua。
--   2. bit 25（CHRONO）：参考档里没有对应事件 → 来源改用同机型 QMPE 档
--      （flyluaioscripts/msfs/QMPE_INIBUILD_A380.lua:150 的 L:INI_CPT_CHRONO_BUTTON）。
--   3. QFCU 面板有两个 EFIS 半区（机长/副驾），miniFCU 只有机长半区，故 QFCU 的
--      51/52/53（副驾气压）与 56–79（副驾 EFIS）不移植。
--   4. 五个旋钮（ALT / SPD / HDG / VS / 机长气压）：参考档用 qfcu:CfgEnc(DecKey, IncKey, "B:AIRLINER_*_KNOB")。
--      CfgEnc 现在在 MF 设备上可用（C++ MF 边沿累加，commit afb3e9e2，真机验证）→ 本档逐轴照抄
--      CfgEnc，每轴两条规则 (start,start+2) + (start+1,start+3)（原因见编码器一节）。
--   5. ALT 100/1000（QFCU 15 → miniFCU 17）：参考档是拨杆 —— QmdevPosSwitchInit 把
--      (L:INI_ALTITUDE_STATE) 拉到物理档位，CfgPSw(15, psw, 0, 1) = 按下期望 0、松开期望 1。
--      miniFCU 是瞬时按键，按 §规格 反写成期望 1 / 0（按下 = 1000 ft 步长，松开 = 100 ft），
--      沿用参考档同一个变量名与同一个 B 事件（_Toggle / 非 _Toggle 随 MSFS_VERSION 分支）。
--   6. ADF/OFF/VOR（QFCU 42–45 → miniFCU 37–42）：QFCU 是两档拨杆，miniFCU 是三个独立按键。
--      MSFS2024 分支（参考档 press/release 语义）：37/39/40/42 取对应 QFCU 键的 press，
--      38/41（OFF 1/2）取 release；MSFS2020 分支参考档用 B:AIRLINER_EFIS_BSK_*_LEFT 单一事件
--      （A380 的该事件是 cstr→…循环切换），三个按键发同一个事件，逐个按可循环到想要的位。
--   7. 气压单位（QFCU 50 → miniFCU 43 HPA / 44 INHG）：参考档是单键拨杆
--      CfgRpn(50, "0 (>L:XMLVAR_Baro_Selector_HPA_1)", "1 (>...)")。按参考档的气压读取表达式
--      （XMLVAR_Baro_Selector_HPA_1 为 0 时读 inHg、为 1 时读 mbar）可知 1 = hPa、0 = inHg，
--      故 43（HPA 键）写 1、44（INHG 键）写 0，各自只发一次。
--   8. 气压 STD 判据：参考档用 (L:XMLVAR_Baro1_Mode) == 2 或 == 3 视为 STD；
--      参考档的机长气压显示表达式在 mode > 2 时返回 99（由 STD 标志接管显示）。
--   9. 参考档对 EXPED、SPD/HDG/ALT/VS 的 PUSH/PULL 用的是 CfgVal(..., 1, 0)（按下发 1、松开发 0），
--      本档照抄成对 CfgVal（同一 B 事件、同一对值），保证与参考档逐字一致。
--      注：A380 的 B 事件表（docs/cpuwolf.ini380.bevents.txt）里没有 EXPED 事件，参考档是把 QFCU 的
--      EXPED 拨杆键映射到 B:AIRLINER_FCU_ALT 的 push(1)/pull(0)；miniFCU 是瞬时按键 → 按一下会先 push
--      再 pull。若真机表现怪，把 6 号键改成只发 press（1）即可。
--  10. MT 8（ALT 值）：参考档把 (L:INI_ALTITUDE_DIAL) 原样送 QFCU 的高度通道，本档按 ft 处理，
--      GetFcuAltValue(path, 0.01) 得 ft/100。若真机高度差 100 倍，把 0.01 改成 1。
--  11. MT 11（FPA 值）：参考档的 QFCU FPA 通道是 abs(floor(fpa*1000)) 并另发符号通道；
--      miniFCU 的 MT11 通道量纲同样是 FPA × 1000 → GetFcuFpaValue 用默认 scale 1000，
--      帧循环里 SetFcuFpaValue() 不传值（源 L:INI_FPA_DIAL 是度）。
-- *****************************************************************

if ilua_require_msfs() then
	return
end
if ilua_require_inibuild_a380() then return end

-- Do not remove below lines: hardware detection
local minifcu = com.sim.mf.MiniFCU.Open()
if not minifcu then return end
-- Do not remove above lines: hardware detection

uluaLog('MobiFlight MiniFCU for iniBuilds A380')

-- ===========================================================
-- INPUT：FCU 半区（bit 0–17）

-- SPD/MACH 显示切换 [Q55]
minifcu:CfgRpn(0, '1 (>L:INI_SPD_MACH_BUTTON)')
-- HDG/TRK ↔ VS/FPA 切换 [Q54]
minifcu:CfgRpn(1, '1 (>L:INI_FCU_HDG_VS_COMMAND)')
-- AP1 [Q10] / AP2 [Q9]
minifcu:CfgRpn(2, '1 (>L:INI_AP1_BUTTON)')
minifcu:CfgRpn(3, '1 (>L:INI_AP2_BUTTON)')
-- METRIC ALT [Q14]
minifcu:CfgRpn(4, '(L:INI_FCU_METRIC_STATE) ! (>L:INI_FCU_METRIC_STATE)')
-- A/THR [Q11]
minifcu:CfgRpn(5, '1 (>L:AP8_BUTTON)')
-- EXPED [Q12]（参考档是 CfgVal：按下发 1、松开发 0）
minifcu:CfgVal(6, 'B:AIRLINER_FCU_ALT', 1, 0)
-- LOC [Q8] / APPR [Q13]
minifcu:CfgRpn(7, '1 (>L:AP6_BUTTON)')
minifcu:CfgRpn(8, '1 (>L:AP7_BUTTON)')
-- SPD PUSH/PULL [Q2 / Q3]
minifcu:CfgVal(9, 'B:AIRLINER_FCU_SPD_KNOB_Push', 1, 0)
minifcu:CfgVal(10, 'B:AIRLINER_FCU_SPD_KNOB_Pull', 1, 0)
-- HDG PUSH/PULL [Q6 / Q7]
minifcu:CfgVal(11, 'B:AIRLINER_FCU_HDG_KNOB_Push', 1, 0)
minifcu:CfgVal(12, 'B:AIRLINER_FCU_HDG_KNOB_Pull', 1, 0)
-- ALT PUSH/PULL [Q18 / Q19]
minifcu:CfgVal(13, 'B:AIRLINER_FCU_ALT_KNOB_Push', 1, 0)
minifcu:CfgVal(14, 'B:AIRLINER_FCU_ALT_KNOB_Pull', 1, 0)
-- VS PUSH/PULL [Q22 / Q23]
minifcu:CfgVal(15, 'B:AIRLINER_FCU_VS_KNOB_Push', 1, 0)
minifcu:CfgVal(16, 'B:AIRLINER_FCU_VS_KNOB_Pull', 1, 0)
-- ALT 100/1000 [Q15]：miniFCU 是瞬时按键 —— 按住 = 1000 ft 步长，松开回 100 ft
--   （参考档 CfgPSw(15, psw, 0, 1)：按下期望 0 / 松开期望 1，这里按规格反过来写 1 / 0；
--     变量名与 B 事件逐字沿用参考档，MSFS_VERSION 分支同参考档）
if MSFS_VERSION == 1 then
	local pswh17 = QmdevPosSwitchInit('(L:INI_ALTITUDE_STATE)', 1, '(>B:AIRLINER_FCU_ALT_SELECTOR_Toggle)',
		'(>B:AIRLINER_FCU_ALT_SELECTOR_Toggle)', 2000)
	minifcu:CfgPSw(17, pswh17, 1, 0)
else
	local pswh17 = QmdevPosSwitchInit('(L:INI_ALTITUDE_STATE)', 1, '(>B:AIRLINER_FCU_ALT_SELECTOR)',
		'(>B:AIRLINER_FCU_ALT_SELECTOR)', 2000)
	minifcu:CfgPSw(17, pswh17, 1, 0)
end

-- ===========================================================
-- INPUT：EFIS 半区机长侧（bit 18–46）

-- 导航点过滤键 [Q35–Q39]
minifcu:CfgRpn(18, '1 (>L:INI_EFIS_CPT_CSTR_BUTTON)')  -- CSTR
minifcu:CfgRpn(19, '1 (>L:INI_EFIS_CPT_FIXES_BUTTON)') -- WPT
minifcu:CfgRpn(20, '1 (>L:INI_EFIS_CPT_VOR_BUTTON)')   -- VOR D
minifcu:CfgRpn(21, '1 (>L:INI_EFIS_CPT_NDB_BUTTON)')   -- NDB
minifcu:CfgRpn(22, '1 (>L:INI_EFIS_CPT_ARPT_BUTTON)')  -- ARPT
-- VV（参考档 A380 这个键是 VV，不是 FD；照抄 CfgVal 含 release = nil）[Q40]
minifcu:CfgVal(23, 'B:AIRLINER_EFIS_VV_LEFT', 1, nil)
-- LS [Q41]
minifcu:CfgRpn(24, '(L:INI_LS_CAPTAIN, Bool) ! (>L:INI_LS_CAPTAIN)')
-- bit 25 CHRONO：参考档里没有对应事件 → 来源 msfs/QMPE_INIBUILD_A380.lua:150
minifcu:CfgRpn(25, '1 (>L:INI_CPT_CHRONO_BUTTON)')

-- ROSE 模式键 [Q24–Q28]：LS/VOR/NAV/ARC/PLN → INI_MAP_MODE_CAPT_SWITCH 0–4
minifcu:CfgRpn(26, '0 (>L:INI_MAP_MODE_CAPT_SWITCH)') -- Q24 LS
minifcu:CfgRpn(27, '1 (>L:INI_MAP_MODE_CAPT_SWITCH)') -- Q25 VOR
minifcu:CfgRpn(28, '2 (>L:INI_MAP_MODE_CAPT_SWITCH)') -- Q26 NAV
minifcu:CfgRpn(29, '3 (>L:INI_MAP_MODE_CAPT_SWITCH)') -- Q27 ARC
minifcu:CfgRpn(30, '4 (>L:INI_MAP_MODE_CAPT_SWITCH)') -- Q28 PLN

-- 距离 [Q29–Q34]：10/20/40/80/160/320 → INI_MAP_RANGE_CAPT_SWITCH 5–10（照抄参考档取值）
minifcu:CfgRpn(31, '5 (>L:INI_MAP_RANGE_CAPT_SWITCH)')  -- Q29 10
minifcu:CfgRpn(32, '6 (>L:INI_MAP_RANGE_CAPT_SWITCH)')  -- Q30 20
minifcu:CfgRpn(33, '7 (>L:INI_MAP_RANGE_CAPT_SWITCH)')  -- Q31 40
minifcu:CfgRpn(34, '8 (>L:INI_MAP_RANGE_CAPT_SWITCH)')  -- Q32 80
minifcu:CfgRpn(35, '9 (>L:INI_MAP_RANGE_CAPT_SWITCH)')  -- Q33 160
minifcu:CfgRpn(36, '10 (>L:INI_MAP_RANGE_CAPT_SWITCH)') -- Q34 320

-- VOR/ADF 选择 1 与 2 [Q42–Q45]：QFCU 是两档拨杆，miniFCU 是 ADF / OFF / VOR 三个独立按键
if MSFS_VERSION == 1 then
	-- 37（ADF 1）= Q42 press；38（OFF 1）= Q42 的 release；39（VOR 1）= Q43 press；40/41/42 = Q44/Q45
	minifcu:CfgRpn(37, '0 (>L:INI_VOR_ADF1_CAPT_STATE)') -- [Q42] ADF 1
	minifcu:CfgRpn(38, '(L:INI_CPT_VOR1_ACTIVE) 0 != if{ 1 (>B:AIRLINER_EFIS_BSK_1_LEFT_Toggle) }') -- [Q42] OFF 1
	minifcu:CfgRpn(39, '(L:INI_CPT_VOR1_ACTIVE) 1 != if{ 1 (>B:AIRLINER_EFIS_BSK_1_LEFT_Toggle) }') -- [Q43] VOR 1
	minifcu:CfgRpn(40, '0 (>L:INI_VOR_ADF2_CAPT_STATE)') -- [Q44] ADF 2
	minifcu:CfgRpn(41, '(L:INI_CPT_VOR2_ACTIVE) 0 != if{ 1 (>B:AIRLINER_EFIS_BSK_5_LEFT_Toggle) }') -- [Q44] OFF 2
	minifcu:CfgRpn(42, '(L:INI_CPT_VOR2_ACTIVE) 1 != if{ 1 (>B:AIRLINER_EFIS_BSK_5_LEFT_Toggle) }') -- [Q45] VOR 2
else
	-- MSFS2020：参考档在两个档位都发同一个 B 事件（循环切换），三个按键各发一次同一事件
	minifcu:CfgVal(37, 'B:AIRLINER_EFIS_BSK_1_LEFT', 1) -- [Q42] ADF 1
	minifcu:CfgVal(38, 'B:AIRLINER_EFIS_BSK_1_LEFT', 1) -- [Q42] OFF 1
	minifcu:CfgVal(39, 'B:AIRLINER_EFIS_BSK_1_LEFT', 1) -- [Q43] VOR 1
	minifcu:CfgVal(40, 'B:AIRLINER_EFIS_BSK_5_LEFT', 1) -- [Q44] ADF 2
	minifcu:CfgVal(41, 'B:AIRLINER_EFIS_BSK_5_LEFT', 1) -- [Q44] OFF 2
	minifcu:CfgVal(42, 'B:AIRLINER_EFIS_BSK_5_LEFT', 1) -- [Q45] VOR 2
end

-- 气压单位 [Q50]：参考档 (L:XMLVAR_Baro_Selector_HPA_1) 为 1 时读 mbar（hPa）、为 0 时读 inHg
--   → 43（HPA 键）写 1（= 参考档 release 值）、44（INHG 键）写 0（= 参考档 press 值）
minifcu:CfgRpn(43, '1 (>L:XMLVAR_Baro_Selector_HPA_1)') -- HPA
minifcu:CfgRpn(44, '0 (>L:XMLVAR_Baro_Selector_HPA_1)') -- INHG
-- 气压旋钮拉 / 按 [Q49 / Q48]
if MSFS_VERSION == 1 then
	minifcu:CfgVal(45, 'B:AIRLINER_EFIS_QNH_PRESSURE_SELECTOR_LEFT_PULL', 1, 0) -- [Q49] PULL
	minifcu:CfgVal(46, 'B:AIRLINER_EFIS_QNH_PRESSURE_SELECTOR_LEFT_PUSH', 1, 0) -- [Q48] PUSH
else
	minifcu:CfgRpn(45, '1 (>L:INI_1_ALTIMETER_PULL_COMMAND)') -- [Q49] PULL
	minifcu:CfgRpn(46, '1 (>L:INI_1_ALTIMETER_PUSH_COMMAND)') -- [Q48] PUSH
end

-- ===========================================================
-- INPUT：编码器（bit 47–66）
-- 参考档这些轴用 qfcu:CfgEnc(dec_bit, inc_bit, "B:<事件>") 表达（QFCU 固件的 ROTATE 配置：
-- 把本次旋转的带符号累加增量当作输入事件的参数发出去）。
-- ✅ CfgEnc 现在在 MF 设备上可用（C++ MF 边沿累加 Mfcfgqmdev::accumulateEncoderRotate，
--    commit afb3e9e2，真机验证）→ 本节与参考档同构：逐轴照抄 qfcu:CfgEnc(dec, inc, "B:<事件>")。
-- ⚠ 每轴两条规则，按 JSON 的 MapToBits 语义成对：MapToBits = [dec, dec-fast, inc, inc-fast]，
--    MF hub 把固件上报的 direction 直接当该数组下标（mfhub/mfcfg.cpp encoder_direction_to_index：
--    0 = 减、1 = 快减、2 = 加、3 = 快加），accumulateEncoderRotate 再按
--    sign = bit==keydec ? -1 : +1 定方向。所以 dec/inc 位之间隔着 fast 位：
--      CfgEnc(start,   start+2, 'B:<事件>')   -- dec / inc
--      CfgEnc(start+1, start+3, 'B:<事件>')   -- fast 孪生对
--    写成相邻对 (start,start+1) 会把快减位当 inc → 方向错。

-- ALT 编码器 [Q16 / Q17]
minifcu:CfgEnc(47, 49, 'B:AIRLINER_FCU_ALT_KNOB')
minifcu:CfgEnc(48, 50, 'B:AIRLINER_FCU_ALT_KNOB')

-- SPD 编码器 [Q0 / Q1]
minifcu:CfgEnc(51, 53, 'B:AIRLINER_FCU_SPD_KNOB')
minifcu:CfgEnc(52, 54, 'B:AIRLINER_FCU_SPD_KNOB')

-- HDG 编码器 [Q4 / Q5]
minifcu:CfgEnc(55, 57, 'B:AIRLINER_FCU_HDG_KNOB')
minifcu:CfgEnc(56, 58, 'B:AIRLINER_FCU_HDG_KNOB')

-- VS 编码器 [Q20 / Q21]
minifcu:CfgEnc(59, 61, 'B:AIRLINER_FCU_VS_KNOB')
minifcu:CfgEnc(60, 62, 'B:AIRLINER_FCU_VS_KNOB')

-- BARO 编码器（机长侧）[Q46 / Q47]
minifcu:CfgEnc(63, 65, 'B:AIRLINER_EFIS_QNH_PRESSURE_SELECTOR_LEFT')
minifcu:CfgEnc(64, 66, 'B:AIRLINER_EFIS_QNH_PRESSURE_SELECTOR_LEFT')


-- ===========================================================
-- 显示源（帧循环里直接读）

-- FCU（源与判据逐条取自参考档的 digi_disp_set_SPD/HDG/ALT/VS）
local dr_spd        = iDataRef:New('(L:INI_AIRSPEED_DIAL)') -- SPD 模式 = kts；MACH 模式 = 马赫
local dr_spd_preset = iDataRef:New('(L:INI_PRESET_DIAL)')   -- managed 时的显示值（230 或 0.71 MACH）
local dr_is_mach    = iDataRef:New('(L:INI_Airspeed_is_mach)')
local dr_spd_dashed = iDataRef:New('(L:INI_FCU_SPD_DASHED)')
local dr_is_spdmgd  = iDataRef:New('(L:INI_managed_speed)')
local dr_hdg        = iDataRef:New('(L:INI_HEADING_DIAL)')
local dr_trk        = iDataRef:New('(L:INI_TRK_DIAL)')
local dr_hdgtrk     = iDataRef:New('(L:INI_TRACK_FPA_STATE)') -- 1 = TRK/FPA
local dr_hdg_dashed = iDataRef:New('(L:INI_FCU_HDG_DASHED)')
local dr_is_hdgmgd  = iDataRef:New(
	'(L:FMGS_lateral_law) 3 >= (L:FMGS_lateral_law) 0 == (L:INI_DEP_RUNWAY_LENGTH) 1 > && || (L:FCU_HDG_TIMER) 0 == &&')
local dr_alt_dot    = iDataRef:New(
	'(L:FMGS_vertical_mode) 20 >= (L:FMGS_vertical_mode) 23 <= && (L:FMGS_vertical_mode) 40 >= || (L:FMGS_vertical_mode) 0 == (L:INI_PITCH_MODE_ARM) 3 == && || (L:FMGS_vertical_mode) 10 == (L:INI_REST_WPT_ALT) (A:INDICATED ALTITUDE,Feet) - abs 100 < && || (>L:MfAltDot) (L:MfAltDot)')
local dr_vs         = iDataRef:New('(L:INI_VVI_DIAL)')
local dr_vs_dashed  = iDataRef:New('(L:INI_FCU_VS_DASHED)')

-- EFIS 机长侧气压：1 = hPa、0 = inHg；XMLVAR_Baro1_Mode 2 或 3 为 STD（参考档判据）
-- 值通道直接用参考档的表达式：mode > 2 时给 99（由 STD 标志接管显示），
-- 否则按单位给 inHg×100（0.005 偏置后 near）或 mbar（near）
local dr_baro = iDataRef:New(
	'(L:XMLVAR_Baro1_Mode) 2 > if{ 99 } els{ (L:XMLVAR_Baro_Selector_HPA_1,bool) ! if{ (A:KOHLSMAN SETTING HG, inHg) 0.005 - 100 * near } els{ (A:KOHLSMAN SETTING HG, mbar) near } }')
local dr_baro_unit = iDataRef:New('(L:XMLVAR_Baro_Selector_HPA_1)') -- 1 = hPa
local dr_baro_std  = iDataRef:New('(L:XMLVAR_Baro1_Mode)')

-- ===========================================================
-- OUTPUT：6 个 LED pin（源取自参考档）
minifcu:GetAp1('(L:INI_ap1_on)')
minifcu:GetAp2('(L:INI_ap2_on)')
minifcu:GetAthr('(L:INI_ATHR_LIGHT)')
minifcu:GetLoc('(L:INI_MCU_LOC_LIGHT)')
minifcu:GetAppr('(L:INI_APPROACH_BUTTON)')
minifcu:GetExped('(L:INI_LEVEL_OFF_LIGHT, Bool)')

-- ===========================================================
-- OUTPUT：miniFCU LCD（CustomDevice 24 通道 = 14 FCU + 12 EFIS，全部保留）

-- MT 0 SPD 值（kts，SPD 模式且非 dashed）
minifcu:GetFcuSpdValue('(L:INI_AIRSPEED_DIAL)')
-- MT 1 MACH 值（马赫 × 100）
minifcu:GetFcuMachValue('(L:INI_AIRSPEED_DIAL)', 100)
-- MT 2 SPD/MACH 模式（1 = mach）
minifcu:GetFcuSpdMachMode('(L:INI_Airspeed_is_mach)')
-- MT 3 SPD dashed
minifcu:GetFcuSpdDashes('(L:INI_FCU_SPD_DASHED)')
-- MT 4 SPD managed 点
minifcu:GetFcuSpdDot('(L:INI_managed_speed)')
-- MT 5 HDG 值
minifcu:GetFcuHdgValue('(L:INI_HEADING_DIAL)')
-- MT 6 HDG dashed
minifcu:GetFcuHdgDashes('(L:INI_FCU_HDG_DASHED)')
-- MT 7 HDG managed 点
minifcu:GetFcuHdgDot(
	'(L:FMGS_lateral_law) 3 >= (L:FMGS_lateral_law) 0 == (L:INI_DEP_RUNWAY_LENGTH) 1 > && || (L:FCU_HDG_TIMER) 0 == &&')
-- MT 8 ALT 值（ft / 100）
minifcu:GetFcuAltValue('(L:INI_ALTITUDE_DIAL)', 0.01)
-- MT 9 ALT managed 点
minifcu:GetFcuAltDot(
	'(L:FMGS_vertical_mode) 20 >= (L:FMGS_vertical_mode) 23 <= && (L:FMGS_vertical_mode) 40 >= || (L:FMGS_vertical_mode) 0 == (L:INI_PITCH_MODE_ARM) 3 == && || (L:FMGS_vertical_mode) 10 == (L:INI_REST_WPT_ALT) (A:INDICATED ALTITUDE,Feet) - abs 100 < && || (>L:MfAltDot) (L:MfAltDot)')
-- MT 10 VS 值（fpm，带符号；TRK/FPA 模式下由 MT 11 接管）
minifcu:GetFcuVsValue('(L:INI_VVI_DIAL)')
-- MT 11 FPA 值（FPA × 1000；源 INI_FPA_DIAL 是度 → 默认 scale 1000）
minifcu:GetFcuFpaValue('(L:INI_FPA_DIAL)')
-- MT 12 VS dashed
minifcu:GetFcuVsDashes('(L:INI_FCU_VS_DASHED)')
-- MT 13 HDG/TRK 模式（1 = TRK）
minifcu:GetFcuHdgTrkMode('(L:INI_TRACK_FPA_STATE)')

-- MT 0 CSTR / MT 1 WPT / MT 2 VORD / MT 3 NDB / MT 4 ARPT（源取自参考档 GetLCstr..GetLArpt）
minifcu:GetEfisCstr('(L:INI_SHOW_CONSTRAINTS)')
minifcu:GetEfisWpt('(L:INI_SHOW_FIXES)')
minifcu:GetEfisVord('(L:INI_SHOW_VORS)')
minifcu:GetEfisNdb('(L:INI_SHOW_NDBS)')
minifcu:GetEfisArpt('(L:INI_SHOW_AIRPORTS)')
-- MT 5 VV / MT 6 LS
minifcu:GetFcuFdValue('(L:INI_VV_LEFT)')
minifcu:GetFcuLsValue('(L:INI_LS_CAPTAIN)')
-- MT 7 QNH 标签（非 STD 时为 1）/ MT 8 STD 标志
minifcu:GetEfisBaroQnnh1('(L:XMLVAR_Baro1_Mode)')
minifcu:GetEfisBaroStd1('(L:XMLVAR_Baro1_Mode)')
-- MT 9 inHg/hPa（1 = inHg；源 XMLVAR_Baro_Selector_HPA_1 为 1 时表示 hPa）
minifcu:GetEfisBaroInhgHpaUnit('(L:XMLVAR_Baro_Selector_HPA_1)')
-- MT 10 BARO inHg（×100）/ MT 11 BARO hPa（两个值都在帧循环里换算后写入）
minifcu:GetEfisBaroInhg(
	'(L:XMLVAR_Baro1_Mode) 2 > if{ 99 } els{ (L:XMLVAR_Baro_Selector_HPA_1,bool) ! if{ (A:KOHLSMAN SETTING HG, inHg) 0.005 - 100 * near } els{ (A:KOHLSMAN SETTING HG, mbar) near } }')
minifcu:GetEfisBaro(
	'(L:XMLVAR_Baro1_Mode) 2 > if{ 99 } els{ (L:XMLVAR_Baro_Selector_HPA_1,bool) ! if{ (A:KOHLSMAN SETTING HG, inHg) 0.005 - 100 * near } els{ (A:KOHLSMAN SETTING HG, mbar) near } }')

-- ===========================================================
-- 帧循环

-- ===========================================================
-- 冷舱 / 熄屏 + ANN LT 测试模式（与 xp/MINIFCU_Toliss.lua 同一套做法）
-- 两个源都逐字取自本机型的 QFCU 参考档（dr_qfcu_fcu_power / dr_qfcu_fcu_test）。

-- 断电判定源：QFCU 档按「值 > 0 = 通电」工作
local dr_fcu_avail  = iDataRef:New('(L:INI_battery_on, number)')
-- ANN LT 开关：0 = TEST / 1 = BRT / 2 = DIM → 测试态 = 0
local dr_annun_mode = iDataRef:New('(L:INI_ANNLT_SWITCH, number)')

-- 断电 = 1 → kSetCustomDevice 32,<设备序号>,-1,0;（Connector MESSAGE_STOP 熄屏）；
-- 回 0 时插件会强制把该设备的每个通道重发一遍。Get*(path, revert=true)：
-- 源是「> 0 = 通电」，取反后通道值 1 = 熄灭。
minifcu:GetFcuPower('(L:INI_battery_on, number)', true)
minifcu:GetEfisPower('(L:INI_battery_on, number)', true)

GlobalFrameLoopManager:add(function()
	-- ---- 冷舱熄屏 + ANN LT 测试模式（见本文件上方同名小节）----
	minifcu:SetFcuPower()
	minifcu:SetEfisPower()

	-- 断电 / 上电：iDataRef 自带变化检测。ChangedUpdate 内部已 Get 过，
	-- 取值一律用 GetOld 读缓存，不要再 Get 触发一次 dataref 读取。
	local fcu_changed = dr_fcu_avail:ChangedUpdate()
	local fcu_powered = dr_fcu_avail:GetOld() >= 1
	if fcu_changed then
		if not fcu_powered then
			-- 6 个 LED 是 GPIO pin，不在 custom device 里：-1 只熄 LCD，这里单独关灯
			minifcu:AllLedsOff()
		end
		minifcu:FreshAll()
	end

	-- TEST 模式：QFCU 靠面板旋钮让硬件把段码 / 灯全点亮，Lua 只做亮度与重绘；
	-- miniFCU 没有亮度通道，段码自检只能用图案逼近；退出 TEST 时作废缓存，下一帧重写真实值。
	local annun_changed = dr_annun_mode:ChangedUpdate()
	local annun_test = fcu_powered and dr_annun_mode:GetOld() == 0
	if annun_changed then
		if annun_test then
			minifcu:TestPattern()
		end
		minifcu:FreshAll()
	end

	if not fcu_powered then
		-- 屏已熄：这时候再转发数值会把 LCD 重新点亮（来电后插件自己会全量重发）
		return
	end
	if annun_test then
		-- TEST 期间冻住 LCD：灯已由 minifcu:TestPattern() 写死，数字保持图案值
		return
	end

	-- ---- 6 个 LED pin ----
	minifcu:SetAp1()
	minifcu:SetAp2()
	minifcu:SetAthr()
	minifcu:SetLoc()
	minifcu:SetAppr()
	minifcu:SetExped()

	-- ---- FCU LCD ----
	local is_mach  = dr_is_mach:Get()
	local spd_dash = dr_spd_dashed:Get()
	local is_mgd   = dr_is_spdmgd:Get()
	local spd_val  = dr_spd:Get()
	local spd_pre  = dr_spd_preset:Get()

	-- MT 2：SPD/MACH 模式；MT 3：dashed；MT 4：managed 点
	minifcu:SetFcuSpdMachMode(is_mach >= 1 and 1 or 0)
	minifcu:SetFcuSpdDashes(spd_dash >= 1 and 1 or 0)
	minifcu:SetFcuSpdDot(is_mgd >= 1 and 1 or 0)

	-- MT 1 / MT 0：MACH（×100）与 SPD（kts）互斥
	--   参考档：managed 时显示 preset，非 managed 时马赫加 0.005 再显示
	if is_mach >= 1 then
		local mach = spd_val
		if is_mgd >= 1 then
			mach = spd_pre
		else
			mach = spd_val + 0.005
		end
		minifcu:SetFcuMachValue(math.floor(mach * 100 + 0.5))
		minifcu:SetFcuSpdValue(0)
	elseif spd_dash < 1 then
		local spd = spd_val
		if is_mgd >= 1 then
			spd = spd_pre
		end
		minifcu:SetFcuSpdValue(math.floor(spd + 0.5))
		minifcu:SetFcuMachValue(0)
	else
		minifcu:SetFcuSpdValue(0)
		minifcu:SetFcuMachValue(0)
	end

	-- MT 5 / MT 6 / MT 7：HDG（TRK/FPA 模式下取 INI_TRK_DIAL）
	local hdgtrk   = dr_hdgtrk:Get()
	local is_fpa   = (hdgtrk == 1)
	local hdg_val  = dr_hdg:Get()
	if is_fpa then
		hdg_val = dr_trk:Get()
	end
	minifcu:SetFcuHdgValue(math.floor(hdg_val))
	minifcu:SetFcuHdgDashes(dr_hdg_dashed:Get() >= 1 and 1 or 0)
	minifcu:SetFcuHdgDot(dr_is_hdgmgd:Get() >= 1 and 1 or 0)

	-- MT 8 / MT 9：ALT（值用注册时 0.01 的比例折算成 ft/100）
	minifcu:SetFcuAltValue()
	minifcu:SetFcuAltDot(dr_alt_dot:Get() > 0 and 1 or 0)

	-- MT 10 / MT 11 / MT 12：VS 与 FPA 互斥（TRK/FPA 模式下显示 FPA）
	minifcu:SetFcuVsDashes(dr_vs_dashed:Get() >= 1 and 1 or 0)
	if is_fpa then
		minifcu:SetFcuVsValue(0)
		minifcu:SetFcuFpaValue()
	else
		minifcu:SetFcuVsValue(dr_vs:Get())
		minifcu:SetFcuFpaValue(0)
	end

	-- MT 13：HDG/TRK 模式（1 = TRK）
	minifcu:SetFcuHdgTrkMode(is_fpa and 1 or 0)

	-- ---- EFIS 半区 ----
	minifcu:SetEfisCstr()
	minifcu:SetEfisWpt()
	minifcu:SetEfisVord()
	minifcu:SetEfisNdb()
	minifcu:SetEfisArpt()
	minifcu:SetFcuFdValue()
	minifcu:SetFcuLsValue()

	-- 气压：STD / QNH 标签 / 单位 / 两个值通道（两个值都算，切单位时不会读到陈旧值）
	local baro_mode = dr_baro_std:Get()  -- (L:XMLVAR_Baro1_Mode)
	local baro_hpa  = dr_baro_unit:Get() -- (L:XMLVAR_Baro_Selector_HPA_1) 1 = hPa
	local baro_raw  = dr_baro:Get()
	local is_std    = (baro_mode == 2 or baro_mode == 3) -- 参考档判据

	minifcu:SetEfisBaroStd1(is_std and 1 or 0)
	minifcu:SetEfisBaroQnnh1(is_std and 0 or 1)
	-- MT 9：1 = inHg（变量为 1 时表示 hPa）
	minifcu:SetEfisBaroInhgHpaUnit(baro_hpa >= 1 and 0 or 1)

	if baro_hpa >= 1 then
		-- 源为 hPa 整数
		minifcu:SetEfisBaro(math.floor(baro_raw + 0.5))
		minifcu:SetEfisBaroInhg(math.floor(baro_raw * 100 / 33.8638895 + 0.5))
	else
		-- 源为 inHg × 100
		minifcu:SetEfisBaroInhg(math.floor(baro_raw + 0.5))
		minifcu:SetEfisBaro(math.floor(baro_raw * 33.8638895 / 100 + 0.5))
	end
end)
