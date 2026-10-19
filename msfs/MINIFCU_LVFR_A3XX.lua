-- *****************************************************************
-- FlyLuaIO MobiFlight miniFCU (miniFCU + miniEFIS) for MSFS
-- LatinVFR A3XX（A320ceo / A321ceo 家族，机模路径含 lvfr）
-- created by Wei Shuai <cpuwolf@gmail.com>
-- *****************************************************************
-- 来源与依据（可追溯）：
--   * 事件名 / B 事件 / L 变量 / A 变量：flyluaioscripts/msfs/QFCU_LVFR_A3XX.lua
--     （QFCU 同机型档，公开树，已实测）。每条绑定后的 [Q#] 标注该功能在 QFCU 面板上的
--     KeyIdx，便于与参考档逐条对照；参考档用 CfgFc + Lua 辅助函数的地方，
--     注释里保留其函数调用原文。
--   * 硬件通道契约：mobiflight/MiniFCU.json（按键 bit 0–46、编码器 bit 47–66、
--     6 个 Output pin、26 条 CustomDevice 通道）。
--   * 通道语义 / 编码器位序：xp/MINIFCU_Toliss.lua（真机 miniFCU 在 X-Plane 上实测）。
-- 编码器位序（沿用 XP 档，勿改）：每轴 4 bit，前 2 bit = 减，后 2 bit = 加。
--   ALT 47/48 减 · 49/50 加；SPD 51/52 · 53/54；HDG 55/56 · 57/58；VS 59/60 · 61/62；BARO 63/64 · 65/66
-- 与参考档的三类按键机制差异（只改机制，不改语义、不改事件名）：
--   1. CfgVal(B 事件, 按下值, 松开值)：miniFCU 与 QFCU 走同一套设备级 DFKEY 机制
--      （设备基类 Qmdev 的 CfgVal），逐字照抄，只改 bit 号。
--   2. CfgEnc(减bit, 加bit, "B:...")：CfgEnc 现在在 MF 设备上可用（C++ MF 边沿累加，
--      commit afb3e9e2，真机验证）→ 本档逐轴照抄 CfgEnc，每轴两条规则 (start,start+2) + (start+1,start+3)（原因见编码器一节）。
--   3. CfgFc(bit, Lua 片段)：参考档用 LvfrRoseModeSet / LvfrRangeSet 等 Lua 辅助函数
--      uluaSet(uluaFind("B:..."), n) 写 B 事件。本档不搬这些函数（miniFCU 成品档
--      统一用 CfgRpn），改成等价 RPN `n (>B:...)` —— 设备侧两者都是把同一个值送进
--      同一个 B 事件，语义不变。
-- 机型边界：
--   * gate 用 ilua_require_lvfr_a3xx()（与 QFCU_LVFR_A3XX.lua / QCDU_LVFR_A3XX.lua 一致）。
--     MINIFCU_FBW_A320NX.lua 里用 ilua_is_acfpath_excluded('lvfr') 显式排除了本机型，
--     两档不会争抢同一台硬件。
-- 已知取舍（待真机验证）：
--   1. 断电门控：与参考档同源 —— (L:A320_Neo_BAT_ScreenLuminosity) 为 0 即熄屏
--      （CustomDevice 的 -1 = MESSAGE_STOP），做法同 xp/MINIFCU_Toliss.lua。
--      参考档把这个亮度值当 annun test 用（3 - 值），不是真正的 ANN LT 开关 → 本档不做 TEST。
--   2. QFCU 面板有两个 EFIS 半区（机长/副驾），miniFCU 只有机长半区，故参考档的
--      51/52/53（副驾气压）与 56–79（副驾 EFIS）不移植。
--   3. bit 25（CHRONO）：QFCU 面板无此键，参考档里也没有计时事件 → 不绑定（TODO）。
--   4. bit 17（ALT 100/1000）[Q15]：参考档是拨杆（按下写 100 / 松开写 1000），
--      miniFCU 是瞬时按键 —— 按住 = 1000、松开 = 100，所以按下/松开两个值对调写，
--      变量名仍是参考档的 (L:XMLVAR_Autopilot_Altitude_Increment)。
--   5. ADF/OFF/VOR 两组 [Q42–Q45]：参考档是两档拨杆（按下 = ADF/VOR，松开 = 中位），
--      miniFCU 是 ADF / OFF / VOR 三个独立按键 → 全部只发按下边沿；参考档自己给出的
--      三态值是 0 = ADF（按下）/ 1 = 中位 OFF（松开）/ 2 = VOR（按下），OFF 键用 1。
--   6. 气压单位 [Q50]：参考档单键拨杆「按下 0 / 松开 1」，而参考档自己的显示逻辑是
--      (L:XMLVAR_Baro_Selector_HPA_1) == 1 → 显示 mbar（即 hPa）→ 所以 miniFCU 的
--      bit 43（HPA，见 MiniFCU.json）发 1、bit 44（INHG）发 0，各自只发按下边沿。
--   7. 气压显示源：参考档用一条 RPN 表达式按单位切换显示值，miniFCU 的 MT10/MT11
--      要求两个值都算（切单位不能读到陈旧值），故直接读参考档用到的两个源
--      (A:KOHLSMAN SETTING HG, inHg) 与 (A:KOHLSMAN SETTING HG, mbar)，每帧都写。
--   8. MT11（FPA）：参考档没有 FPA 值源（它的 fpa_vs 接的其实是 TRK/FPA 标志位
--      (L:XMLVAR_TRK_FPA_MODE_ACTIVE)），故 MT11 固定 0（TODO：找到真源再补）；
--      TRK/FPA 模式下 MT10 也置 0（与 MINIFCU_FBW_A320NX.lua 同一处理）。
--   9. LED pin：参考档把 LOC 灯接 (A:AUTOPILOT APPROACH HOLD,Bool)、APPR 灯接
--      (A:AUTOPILOT GLIDESLOPE ARM,Bool)，本档逐字继承该配对；若真机上两个灯互换，
--      只改这两行即可。
-- *****************************************************************

if ilua_require_msfs() then
	return
end
if ilua_require_lvfr_a3xx() then return end

-- Do not remove below lines: hardware detection
local minifcu = com.sim.mf.MiniFCU.Open()
if not minifcu then return end
-- Do not remove above lines: hardware detection

uluaLog('MobiFlight MiniFCU for LatinVFR A3XX')

-- ===========================================================
-- INPUT：FCU 半区（bit 0–17）

-- SPD/MACH 显示切换 [Q55]：参考档 CfgFc 55 = 1 - (A:AUTOPILOT MANAGED SPEED IN MACH,Bool)
minifcu:CfgRpn(0, '1 (A:AUTOPILOT MANAGED SPEED IN MACH,Bool) - (>B:AUTOPILOT_SpeedToggle_Mode)')
-- HDG/TRK ↔ VS/FPA 切换 [Q54]：参考档 CfgFc 54 = 1 - (L:XMLVAR_TRK_FPA_MODE_ACTIVE)
minifcu:CfgRpn(1, '1 (L:XMLVAR_TRK_FPA_MODE_ACTIVE) - (>B:AIRLINER_HDG_TRK)')
-- AP1 [Q10]
minifcu:CfgVal(2, 'B:AUTOPILOT_AP_1', 1, 0)
-- AP2 [Q9]
minifcu:CfgVal(3, 'B:AUTOPILOT_AP_2', 1, 0)
-- METRIC ALT [Q14]
minifcu:CfgVal(4, 'B:AIRLINER_Metric_Alt', 1, 0)
-- A/THR [Q11]
minifcu:CfgVal(5, 'B:AUTOPILOT_AutoThrottle_1', 1, 0)
-- EXPED [Q12]
minifcu:CfgVal(6, 'B:AUTOPILOT_Expedite_Mode', 1, 0)
-- LOC [Q8]
minifcu:CfgVal(7, 'B:AUTOPILOT_Localizer_Button', 1, 0)
-- APPR [Q13]
minifcu:CfgVal(8, 'B:AUTOPILOT_Approach_Button', 1, 0)
-- SPD PUSH/PULL [Q2 / Q3]
minifcu:CfgVal(9, 'B:AUTOPILOT_Speed_Managed', 1, 0)
minifcu:CfgVal(10, 'B:AUTOPILOT_Speed_Selected', 1, 0)
-- HDG PUSH/PULL [Q6 / Q7]
minifcu:CfgVal(11, 'B:AUTOPILOT_Heading_Managed', 1, 0)
minifcu:CfgVal(12, 'B:AUTOPILOT_Heading_Selected', 1, 0)
-- ALT PUSH/PULL [Q18 / Q19]
minifcu:CfgVal(13, 'B:AUTOPILOT_Altitude_Managed', 1, 0)
minifcu:CfgVal(14, 'B:AUTOPILOT_Altitude_Selected', 1, 0)
-- VS PUSH/PULL [Q22 / Q23]
minifcu:CfgVal(15, 'B:AUTOPILOT_VerticalSpeed_Zero', 1, 0)
minifcu:CfgVal(16, 'B:AUTOPILOT_VerticalSpeed_Hold', 1, 0)
-- ALT 100/1000 [Q15]：miniFCU 是瞬时按键 —— 按住 = 1000 ft 步长，松开回 100 ft；
--   参考档（拨杆）是按下 100 / 松开 1000，故两个值对调，变量名照抄
minifcu:CfgRpn(17, '1000 (>L:XMLVAR_Autopilot_Altitude_Increment)',
	'100 (>L:XMLVAR_Autopilot_Altitude_Increment)')

-- ===========================================================
-- INPUT：EFIS 半区机长侧（bit 18–46）

-- 导航点过滤键 [Q35–Q39]：参考档 CfgFc 35–39 = 1 - (L:BTN_CSTR_FILTER_ACTIVE)（各自对应键）写对应 B 事件
minifcu:CfgRpn(18, '1 (L:BTN_CSTR_FILTER_ACTIVE) - (>B:AIRLINER_CSTR)') -- CSTR
minifcu:CfgRpn(19, '1 (L:BTN_WPT_FILTER_ACTIVE) - (>B:AIRLINER_WPT)')   -- WPT
minifcu:CfgRpn(20, '1 (L:BTN_VORD_FILTER_ACTIVE) - (>B:AIRLINER_VORD)') -- VOR D
minifcu:CfgRpn(21, '1 (L:BTN_NDB_FILTER_ACTIVE) - (>B:AIRLINER_NDB)')   -- NDB
minifcu:CfgRpn(22, '1 (L:BTN_ARPT_FILTER_ACTIVE) - (>B:AIRLINER_ARPT)') -- ARPT
-- FD [Q40]：参考档就是 K 事件，逐字照抄
minifcu:CfgRpn(23, '(>K:TOGGLE_FLIGHT_DIRECTOR)')
-- LS [Q41]：参考档 CfgFc 41 = 1 - (L:BTN_LS_FILTER_ACTIVE)
minifcu:CfgRpn(24, '1 (L:BTN_LS_FILTER_ACTIVE) - (>B:AIRLINER_LS)')
-- bit 25 CHRONO：QFCU 面板无此键，参考档无对应事件，不绑定（TODO，见文件头取舍 3）

-- EFIS ROSE 模式键 [Q24–Q28]：参考档 CfgFc 24–28 调 LvfrRoseModeSet(0..4)
--   （函数体 = uluaSet(uluaFind("B:AIRLINER_ROSE_Mode"), dnum)）
minifcu:CfgRpn(26, '0 (>B:AIRLINER_ROSE_Mode)') -- LS
minifcu:CfgRpn(27, '1 (>B:AIRLINER_ROSE_Mode)') -- VOR
minifcu:CfgRpn(28, '2 (>B:AIRLINER_ROSE_Mode)') -- NAV
minifcu:CfgRpn(29, '3 (>B:AIRLINER_ROSE_Mode)') -- ARC
minifcu:CfgRpn(30, '4 (>B:AIRLINER_ROSE_Mode)') -- PLN

-- 距离 [Q29–Q34]：参考档 CfgFc 29–34 调 LvfrRangeSet(0..5)
--   （函数体 = uluaSet(uluaFind("B:AIRLINER_ND_Range_1"), dnum)）
minifcu:CfgRpn(31, '0 (>B:AIRLINER_ND_Range_1)') -- 10
minifcu:CfgRpn(32, '1 (>B:AIRLINER_ND_Range_1)') -- 20
minifcu:CfgRpn(33, '2 (>B:AIRLINER_ND_Range_1)') -- 40
minifcu:CfgRpn(34, '3 (>B:AIRLINER_ND_Range_1)') -- 80
minifcu:CfgRpn(35, '4 (>B:AIRLINER_ND_Range_1)') -- 160
minifcu:CfgRpn(36, '5 (>B:AIRLINER_ND_Range_1)') -- 320

-- VOR/ADF 选择 1 与 2 [Q42–Q45]
--   参考档：CfgVal(42, "B:AIRLINER_L_VOR_ADF_1", 0, 1) / CfgVal(43, "B:AIRLINER_L_VOR_ADF_1", 2, 1)
--   → 三态值 0 = ADF（按下）、1 = OFF（松开）、2 = VOR（按下）。miniFCU 是三个独立按键，
--   全部只发按下边沿（OFF 键发参考档的松开值 1）。
minifcu:CfgRpn(37, '0 (>B:AIRLINER_L_VOR_ADF_1)') -- ADF 1 [Q42 按下]
minifcu:CfgRpn(38, '1 (>B:AIRLINER_L_VOR_ADF_1)') -- OFF 1 [Q42 / Q43 松开]
minifcu:CfgRpn(39, '2 (>B:AIRLINER_L_VOR_ADF_1)') -- VOR 1 [Q43 按下]
minifcu:CfgRpn(40, '0 (>B:AIRLINER_L_VOR_ADF_2)') -- ADF 2 [Q44 按下]
minifcu:CfgRpn(41, '1 (>B:AIRLINER_L_VOR_ADF_2)') -- OFF 2 [Q44 / Q45 松开]
minifcu:CfgRpn(42, '2 (>B:AIRLINER_L_VOR_ADF_2)') -- VOR 2 [Q45 按下]

-- 气压单位 [Q50]：参考档单键拨杆（CfgRpn 50 按下 0 / 松开 1），其中 1 = hPa
--   （参考档自己的显示逻辑：(L:XMLVAR_Baro_Selector_HPA_1) == 1 → 显示 mbar）
--   → miniFCU bit 43 = HPA 发 1、bit 44 = INHG 发 0，各自只发按下边沿
minifcu:CfgRpn(43, '1 (>L:XMLVAR_Baro_Selector_HPA_1)') -- HPA  [Q50 松开值]
minifcu:CfgRpn(44, '0 (>L:XMLVAR_Baro_Selector_HPA_1)') -- INHG [Q50 按下值]
-- 气压旋钮拉 / 按 [Q49 / Q48]：与参考档同机制，逐字照抄
minifcu:CfgVal(45, 'B:AUTOPILOT_Baro_1_STD', 1, 0) -- PULL
minifcu:CfgVal(46, 'B:AUTOPILOT_Baro_1_QNH', 0, 1) -- PUSH

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

-- ALT 编码器 [Q16 减 / Q17 加]
minifcu:CfgEnc(47, 49, 'B:AUTOPILOT_Altitude')
minifcu:CfgEnc(48, 50, 'B:AUTOPILOT_Altitude')

-- SPD 编码器 [Q0 减 / Q1 加]
minifcu:CfgEnc(51, 53, 'B:AUTOPILOT_Speed')
minifcu:CfgEnc(52, 54, 'B:AUTOPILOT_Speed')

-- HDG 编码器 [Q4 减 / Q5 加]
minifcu:CfgEnc(55, 57, 'B:AUTOPILOT_Heading')
minifcu:CfgEnc(56, 58, 'B:AUTOPILOT_Heading')

-- VS 编码器 [Q20 减 / Q21 加]
minifcu:CfgEnc(59, 61, 'B:AUTOPILOT_VerticalSpeed')
minifcu:CfgEnc(60, 62, 'B:AUTOPILOT_VerticalSpeed')

-- BARO 编码器（机长侧）[Q47 减 / Q46 加]
minifcu:CfgEnc(63, 65, 'B:AUTOPILOT_Baro_1')
minifcu:CfgEnc(64, 66, 'B:AUTOPILOT_Baro_1')


-- ===========================================================
-- 显示源（帧循环里直接读）

-- FCU（源与参考档逐条对应）
local dr_spd_kts    = iDataRef:New('(A:AUTOPILOT AIRSPEED HOLD VAR:1,Knots)')
local dr_spd_mach   = iDataRef:New('(A:AUTOPILOT MACH HOLD VAR:1,Number)')
local dr_is_mach    = iDataRef:New('(A:AUTOPILOT MANAGED SPEED IN MACH,Bool)')
local dr_spd_dashed = iDataRef:New('(L:A32NX_FCU_SPD_MANAGED_DASHES)')
local dr_vs         = iDataRef:New('(A:AUTOPILOT VERTICAL HOLD VAR,Feet/minute)')
local dr_trkfpa     = iDataRef:New('(L:XMLVAR_TRK_FPA_MODE_ACTIVE)')

-- EFIS 机长侧气压：参考档注释 QFE:0 QNH:1 STD:2/3（2 或 3 走 STD 显示）
local dr_baro_mode = iDataRef:New('(L:XMLVAR_Baro1_Mode)')
local dr_baro_hpa  = iDataRef:New('(L:XMLVAR_Baro_Selector_HPA_1)') -- 1 = hPa
local dr_baro_inhg = iDataRef:New('(A:KOHLSMAN SETTING HG, inHg)')
local dr_baro_mbar = iDataRef:New('(A:KOHLSMAN SETTING HG, mbar)')

-- ===========================================================
-- OUTPUT：6 个 LED pin
minifcu:GetAp1('(L:XMLVAR_Autopilot_1_Status)')
minifcu:GetAp2('(L:XMLVAR_Autopilot_2_Status)')
minifcu:GetAthr('(A:AUTOTHROTTLE ACTIVE,Bool)')
-- 参考档 LOC 灯 ← (A:AUTOPILOT APPROACH HOLD,Bool)，APPR 灯 ← (A:AUTOPILOT GLIDESLOPE ARM,Bool)
minifcu:GetLoc('(A:AUTOPILOT APPROACH HOLD,Bool)')
minifcu:GetAppr('(A:AUTOPILOT GLIDESLOPE ARM,Bool)')
minifcu:GetExped('(L:A32NX_FMA_EXPEDITE_MODE)')

-- ===========================================================
-- OUTPUT：miniFCU LCD（14 FCU + 12 EFIS 通道全部保留）

-- MT 0 SPD 值（kts，仅 SPD 模式且非 dashed 时有效）
minifcu:GetFcuSpdValue('(A:AUTOPILOT AIRSPEED HOLD VAR:1,Knots)')
-- MT 1 MACH 值（马赫 × 100）
minifcu:GetFcuMachValue('(A:AUTOPILOT MACH HOLD VAR:1,Number)', 100)
-- MT 2 SPD/MACH 模式（1 = mach）
minifcu:GetFcuSpdMachMode('(A:AUTOPILOT MANAGED SPEED IN MACH,Bool)')
-- MT 3 SPD dashed
minifcu:GetFcuSpdDashes('(L:A32NX_FCU_SPD_MANAGED_DASHES)')
-- MT 4 SPD managed 点
minifcu:GetFcuSpdDot('(L:A32NX_FCU_SPD_MANAGED_DOT)')
-- MT 5 HDG 值
minifcu:GetFcuHdgValue('(A:AUTOPILOT HEADING LOCK DIR:1, degrees)')
-- MT 6 HDG dashed
minifcu:GetFcuHdgDashes('(L:A32NX_FCU_HDG_MANAGED_DASHES)')
-- MT 7 HDG managed 点
minifcu:GetFcuHdgDot('(L:A32NX_FCU_HDG_MANAGED_DOT)')
-- MT 8 ALT 值（ft / 100，参考档 ALT 源是 (L:HUD_AP_SELECTED_ALTITUDE)）
minifcu:GetFcuAltValue('(L:HUD_AP_SELECTED_ALTITUDE)', 0.01)
-- MT 9 ALT managed 点
minifcu:GetFcuAltDot('(L:A32NX_FCU_ALT_MANAGED)')
-- MT 10 VS 值（fpm，带符号；TRK/FPA 模式下帧循环里置 0）
minifcu:GetFcuVsValue('(A:AUTOPILOT VERTICAL HOLD VAR,Feet/minute)')
-- MT 11 FPA 值 —— TODO：参考档没有 FPA 值源（fpa_vs 接的是 TRK/FPA 标志位），帧循环里固定写 0
--   通道量纲本应是 FPA × 1000（见 MINIFCU_FBW_A320NX.lua），没有真源时写 0 不受影响
minifcu:GetFcuFpaValue('(L:XMLVAR_TRK_FPA_MODE_ACTIVE)')
-- MT 12 VS dashed
minifcu:GetFcuVsDashes('(L:A32NX_FCU_VS_MANAGED)')
-- MT 13 HDG/TRK 模式（1 = TRK）
minifcu:GetFcuHdgTrkMode('(L:XMLVAR_TRK_FPA_MODE_ACTIVE)')

-- EFIS LED：源与参考档逐条对应
minifcu:GetEfisCstr('(L:BTN_CSTR_FILTER_ACTIVE)')
minifcu:GetEfisWpt('(L:BTN_WPT_FILTER_ACTIVE)')
minifcu:GetEfisVord('(L:BTN_VORD_FILTER_ACTIVE)')
minifcu:GetEfisNdb('(L:BTN_NDB_FILTER_ACTIVE)')
minifcu:GetEfisArpt('(L:BTN_ARPT_FILTER_ACTIVE)')
minifcu:GetFcuFdValue('(A:AUTOPILOT FLIGHT DIRECTOR ACTIVE:1, Bool)')
minifcu:GetFcuLsValue('(L:BTN_LS_FILTER_ACTIVE)')
-- MT 7 QNH 标签（非 STD 时 1）/ MT 8 STD 标志（STD 时 1）：源 (L:XMLVAR_Baro1_Mode)，帧循环里判定
minifcu:GetEfisBaroQnnh1('(L:XMLVAR_Baro1_Mode)')
minifcu:GetEfisBaroStd1('(L:XMLVAR_Baro1_Mode)')
-- MT 9 inHg/hPa（1 = inHg；源 (L:XMLVAR_Baro_Selector_HPA_1) = 1 表示 hPa）
minifcu:GetEfisBaroInhgHpaUnit('(L:XMLVAR_Baro_Selector_HPA_1)')
-- MT 10 BARO inHg（×100）/ MT 11 BARO hPa：两个值每帧都算，切单位不读陈旧值
minifcu:GetEfisBaroInhg('(A:KOHLSMAN SETTING HG, inHg)')
minifcu:GetEfisBaro('(A:KOHLSMAN SETTING HG, mbar)')

-- ===========================================================
-- 帧循环

-- ===========================================================
-- 冷舱 / 熄屏（与 xp/MINIFCU_Toliss.lua 同一套做法；本机型参考档没有 ANN LT 测试源，只做断电）
-- 源逐字取自本机型的 QFCU 参考档 dr_qfcu_fcu_power。

-- 断电判定源：QFCU 档按「值 > 0 = 通电」工作
local dr_fcu_avail  = iDataRef:New('(L:A320_Neo_BAT_ScreenLuminosity, number)')

-- 断电 = 1 → kSetCustomDevice 32,<设备序号>,-1,0;（Connector MESSAGE_STOP 熄屏）；
-- 回 0 时插件会强制把该设备的每个通道重发一遍。Get*(path, revert=true)：
-- 源是「> 0 = 通电」，取反后通道值 1 = 熄灭。
minifcu:GetFcuPower('(L:A320_Neo_BAT_ScreenLuminosity, number)', true)
minifcu:GetEfisPower('(L:A320_Neo_BAT_ScreenLuminosity, number)', true)

GlobalFrameLoopManager:add(function()
	-- ---- 冷舱熄屏 + ANN LT 测试模式（见本文件上方同名小节）----
	minifcu:SetFcuPower()
	minifcu:SetEfisPower()

	-- 断电 / 上电：iDataRef 自带变化检测。ChangedUpdate 内部已 Get 过，
	-- 取值一律用 GetOld 读缓存，不要再 Get 触发一次 dataref 读取。
	local fcu_changed = dr_fcu_avail:ChangedUpdate()
	local fcu_powered = dr_fcu_avail:GetOld() > 0
	if fcu_changed then
		if not fcu_powered then
			-- 6 个 LED 是 GPIO pin，不在 custom device 里：-1 只熄 LCD，这里单独关灯
			minifcu:AllLedsOff()
		end
		minifcu:FreshAll()
	end

	if not fcu_powered then
		-- 屏已熄：这时候再转发数值会把 LCD 重新点亮（来电后插件自己会全量重发）
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

	-- MT 2：SPD/MACH 模式
	minifcu:SetFcuSpdMachMode(is_mach >= 1 and 1 or 0)

	-- MT 1：MACH 值（mach × 100；非 MACH 模式或 dashed 时置 0）
	if is_mach >= 1 and spd_dash < 1 then
		minifcu:SetFcuMachValue(math.floor(dr_spd_mach:Get() * 100 + 0.5))
	else
		minifcu:SetFcuMachValue(0)
	end

	-- MT 0：SPD 值（MACH 模式或 dashed 时置 0）
	if is_mach < 1 and spd_dash < 1 then
		minifcu:SetFcuSpdValue(math.floor(dr_spd_kts:Get() + 0.5))
	else
		minifcu:SetFcuSpdValue(0)
	end

	-- MT 3 / MT 4：dashed 与 managed 点
	minifcu:SetFcuSpdDashes()
	minifcu:SetFcuSpdDot()

	-- MT 5 / MT 6 / MT 7：HDG（值 + dashed + managed 点，与 MINIFCU_FBW_A320NX.lua 同处理）
	minifcu:SetFcuHdgValue()
	minifcu:SetFcuHdgDashes()
	minifcu:SetFcuHdgDot()

	-- MT 8 / MT 9：ALT
	minifcu:SetFcuAltValue()
	minifcu:SetFcuAltDot()

	-- MT 10 / MT 11 / MT 12：VS 与 FPA 互斥（本机型无 FPA 值源）
	local is_trkfpa = (dr_trkfpa:Get() >= 1)
	minifcu:SetFcuVsDashes()
	if is_trkfpa then
		minifcu:SetFcuVsValue(0)
	else
		minifcu:SetFcuVsValue(dr_vs:Get())
	end
	minifcu:SetFcuFpaValue(0) -- TODO：参考档无 FPA 值源

	-- MT 13：HDG/TRK 模式
	minifcu:SetFcuHdgTrkMode()

	-- ---- EFIS 半区 ----
	minifcu:SetEfisCstr()
	minifcu:SetEfisWpt()
	minifcu:SetEfisVord()
	minifcu:SetEfisNdb()
	minifcu:SetEfisArpt()
	minifcu:SetFcuFdValue()
	minifcu:SetFcuLsValue()

	-- 气压：STD 判定（XMLVAR_Baro1_Mode 2/3 = STD）/ 单位 / 两个值通道都算
	local baro_mode = dr_baro_mode:Get()
	local baro_hpa  = dr_baro_hpa:Get()
	local is_std    = (baro_mode == 2 or baro_mode == 3)

	minifcu:SetEfisBaroStd1(is_std and 1 or 0)
	minifcu:SetEfisBaroQnnh1(is_std and 0 or 1)
	-- MT 9：1 = inHg（HPA_1 为 1 表示 hPa）
	minifcu:SetEfisBaroInhgHpaUnit(baro_hpa >= 1 and 0 or 1)
	-- MT 10 / MT 11：每帧都写，切单位不会读到上一次的陈旧值
	minifcu:SetEfisBaroInhg(math.floor(dr_baro_inhg:Get() * 100 + 0.5))
	minifcu:SetEfisBaro(math.floor(dr_baro_mbar:Get() + 0.5))
end)
