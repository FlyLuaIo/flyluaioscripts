-- *****************************************************************
-- FlyLuaIO MobiFlight miniFCU (miniFCU + miniEFIS) for MSFS
-- iniBuilds A340
-- created by Wei Shuai <cpuwolf@gmail.com>
-- *****************************************************************
-- 来源与依据（可追溯）：
--   * 事件名 / L 变量 / A 变量：msfs/QFCU_INIBUILD_A340.lua（QFCU 同机型档）
--     每条绑定后的 [Q#] 标注该功能在 QFCU 面板上的 KeyIdx，便于与 QFCU 档逐条对照。
--   * 硬件通道契约：mobiflight/MiniFCU.json（按键 bit 0–46、编码器 bit 47–66、
--     6 个 Output pin、26 条 CustomDevice 通道）。
--   * 通道语义 / 编码器位序：xp/MINIFCU_Toliss.lua（真机 miniFCU 在 X-Plane 上手工调过并实测）。
-- 编码器位序（沿用 XP 档，勿改）：每轴 4 bit，前 2 bit = 减，后 2 bit = 加。
--   ALT 47/48 减 · 49/50 加；SPD 51/52 · 53/54；HDG 55/56 · 57/58；VS 59/60 · 61/62；BARO 63/64 · 65/66
-- 机型边界：
--   * iniBuilds 各机型共用 AIRLINER_MCU_* 事件，但 ilua_require_inibuild_a340() 只在机模路径
--     同时含 a340 与 inibuild 时才放行；其它 iniBuilds 机型（A300/A310/A320/A330…）路径里
--     没有 a340 会被排除，不会与它们争抢同一台硬件。
-- 已知取舍（待真机验证）：
--   1. 未做断电门控：QFCU 档用 (L:INI_ELEC_AC_ESS_SHED_BUS_IS_POWERED) 关 LCD，miniFCU
--      硬件无背光/熄灭通道，XP 档也没做，这里保持一致。
--   2. QFCU 面板有两个 EFIS 半区（机长/副驾），miniFCU 只有机长半区，故 QFCU 的
--      51/52/53（副驾气压）与 56–79（副驾 EFIS）不移植。
--   3. bit 17（ALT 100/1000）[Q15]：QFCU 该键是 100/1000 拨杆（QmdevPosSwitchInit +
--      CfgPSw(15, pswh15, 0, 1)），miniFCU 是瞬时按键 —— 按住 = 1000、松开 = 100，
--      所以 pos switch 的期望值反过来写 (1, 0)；驱动源仍是参考档的
--      (L:INI_ALTITUDE_STATE) + (>B:AIRLINER_MCU_ALTSELECT_Toggle)，不自造 LVAR。
--      （即假定 (L:INI_ALTITUDE_STATE) = 1 才是 1000 —— 待真机确认；若实际相反，
--        把 CfgPSw 的期望值改成 (0, 1) 即可，或改用 CfgPSwTog(17, pswh17, 1, 0)
--        做成“每按一次翻转 100/1000”。）
--   4. bit 25（CHRONO）：参考档（QFCU）里没有可用的计时事件 → 来源改用同机型 QMPE 档
--      （flyluaioscripts/msfs/QMPE_INIBUILD_A340.lua:163 的 L:INI_CPT_CHRONO_BUTTON）。
--   5. QFCU 12 在参考档里注释为 EXPED，但实际发出的是 B:AIRLINER_ALT_PUSH_Set
--      （参考档原文如此），本档按“只改 bit 号”的原则逐字继承。
--   6. ADF/VOR 两组 [Q42–Q45] 是两档拨杆（按下 = ADF/VOR，松开 = 中位），miniFCU 的
--      ADF / OFF / VOR 是三个独立按键 → 只发按下值，OFF 键用参考档的松开值。
--   7. 气压单位 [Q50]：QFCU 单键拨杆（按下 = 0，松开 = 1），miniFCU 的
--      bit 43 = HPA / bit 44 = INHG（见 MiniFCU.json）→ 43 发 1、44 发 0
--      （(L:XMLVAR_Baro_Selector_HPA_1) = 1 时参考档显示 mbar，即 hPa）。
--   8. QFCU 的 SPD 显示在 managed（有点）时用 (L:INI_PRESET_DIAL)，否则用
--      (L:INI_AIRSPEED_DIAL)，本档照搬这个判据（见帧循环 spd_show）。
-- *****************************************************************

if ilua_require_msfs() then
	return
end
if ilua_require_inibuild_a340() then return end

-- Do not remove below lines: hardware detection
local minifcu = com.sim.mf.MiniFCU.Open()
if not minifcu then return end
-- Do not remove above lines: hardware detection

uluaLog('MobiFlight MiniFCU for iniBuilds A340')

-- ===========================================================
-- INPUT：FCU 半区（bit 0–17）

-- SPD/MACH 显示切换 [Q55]
minifcu:CfgRpn(0, '0 (>B:AIRLINER_SPDMACH_Set)')
-- HDG/TRK ↔ VS/FPA 切换 [Q54]
minifcu:CfgRpn(1, '1 (>L:INI_FCU_HDG_VS_COMMAND)')
-- AP1 [Q10]
minifcu:CfgRpn(2, '0 (>B:AIRLINER_AP1_PUSH_Set)')
-- AP2 [Q9]
minifcu:CfgRpn(3, '0 (>B:AIRLINER_AP2_PUSH_Set)')
-- METRIC ALT [Q14]
minifcu:CfgRpn(4, '(L:INI_FCU_METRIC_STATE) ! (>L:INI_FCU_METRIC_STATE)')
-- A/THR [Q11]
minifcu:CfgRpn(5, '0 (>B:AIRLINER_ATHR_PUSH_Set)')
-- EXPED [Q12]：参考档该键（QFCU 面板标注 EXPED）实际发 ALT_PUSH_Set，逐字继承
minifcu:CfgRpn(6, '0 (>B:AIRLINER_ALT_PUSH_Set)')
-- LOC [Q8]
minifcu:CfgRpn(7, '0 (>B:AIRLINER_LOC_PUSH_Set)')
-- APPR [Q13]
minifcu:CfgRpn(8, '0 (>B:AIRLINER_APPR_PUSH_Set)')
-- SPD PUSH / PULL [Q2 / Q3]
minifcu:CfgVal(9, 'B:AIRLINER_MCU_SPEED_PUSH', 1, 0)
minifcu:CfgVal(10, 'B:AIRLINER_MCU_SPEED_PULL', 1, 0)
-- HDG PUSH / PULL [Q6 / Q7]
minifcu:CfgVal(11, 'B:AIRLINER_MCU_HDG_PUSH', 1, 0)
minifcu:CfgVal(12, 'B:AIRLINER_MCU_HDG_PULL', 1, 0)
-- ALT PUSH / PULL [Q18 / Q19]
minifcu:CfgVal(13, 'B:AIRLINER_MCU_ALT_PUSH', 1, 0)
minifcu:CfgVal(14, 'B:AIRLINER_MCU_ALT_PULL', 1, 0)
-- VS PUSH / PULL [Q22 / Q23]
minifcu:CfgVal(15, 'B:AIRLINER_MCU_VS_PUSH', 1, 0)
minifcu:CfgVal(16, 'B:AIRLINER_MCU_VS_PULL', 1, 0)
-- ALT 100/1000 [Q15]：QFCU 档是拨杆位置开关（期望值 0/1），miniFCU 是瞬时按键 ——
--   按住 = 1000 ft 步长、松开回 100 ft，故期望值写 (1, 0)（详见文件头取舍 3）
local pswh17 = QmdevPosSwitchInit('(L:INI_ALTITUDE_STATE)', 1, '(>B:AIRLINER_MCU_ALTSELECT_Toggle)',
	'(>B:AIRLINER_MCU_ALTSELECT_Toggle)', 500)
minifcu:CfgPSw(17, pswh17, 1, 0)

-- ===========================================================
-- INPUT：EFIS 半区机长侧（bit 18–46）

-- 导航点过滤键 [Q35–Q39]（副驾侧 Q67–71 不移植）
minifcu:CfgRpn(18, '1 (>L:INI_EFIS_CPT_CSTR_BUTTON)')
minifcu:CfgRpn(19, '1 (>L:INI_EFIS_CPT_FIXES_BUTTON)')
minifcu:CfgRpn(20, '1 (>L:INI_EFIS_CPT_VOR_BUTTON)')
minifcu:CfgRpn(21, '1 (>L:INI_EFIS_CPT_NDB_BUTTON)')
minifcu:CfgRpn(22, '1 (>L:INI_EFIS_CPT_ARPT_BUTTON)')
-- FD / LS [Q40 / Q41]
minifcu:CfgRpn(23, '0 (>B:AIRLINER_CPT_FD_Set)')
minifcu:CfgRpn(24, '0 (>B:AIRLINER_CPT_LS_Set)')
-- bit 25 CHRONO：参考档里没有可用的计时事件 → 来源 msfs/QMPE_INIBUILD_A340.lua:163
minifcu:CfgRpn(25, '1 (>L:INI_CPT_CHRONO_BUTTON)')

-- ROSE 模式键 [Q24–Q28]：LS/VOR/NAV/ARC/PLN 对应 ND 模式 0–4
minifcu:CfgRpn(26, '0 (>L:INI_MAP_MODE_CAPT_SWITCH)') -- LS
minifcu:CfgRpn(27, '1 (>L:INI_MAP_MODE_CAPT_SWITCH)') -- VOR
minifcu:CfgRpn(28, '2 (>L:INI_MAP_MODE_CAPT_SWITCH)') -- NAV
minifcu:CfgRpn(29, '3 (>L:INI_MAP_MODE_CAPT_SWITCH)') -- ARC
minifcu:CfgRpn(30, '4 (>L:INI_MAP_MODE_CAPT_SWITCH)') -- PLN

-- 距离 [Q29–Q34]：10/20/40/80/160/320 → 距离档位 0–5
minifcu:CfgRpn(31, '0 (>L:INI_MAP_RANGE_CAPT_SWITCH)') -- 10
minifcu:CfgRpn(32, '1 (>L:INI_MAP_RANGE_CAPT_SWITCH)') -- 20
minifcu:CfgRpn(33, '2 (>L:INI_MAP_RANGE_CAPT_SWITCH)') -- 40
minifcu:CfgRpn(34, '3 (>L:INI_MAP_RANGE_CAPT_SWITCH)') -- 80
minifcu:CfgRpn(35, '4 (>L:INI_MAP_RANGE_CAPT_SWITCH)') -- 160
minifcu:CfgRpn(36, '5 (>L:INI_MAP_RANGE_CAPT_SWITCH)') -- 320

-- VOR/ADF 选择 1 与 2 [Q42–Q45]：参考档是三态拨杆 ——
--   QFCU 42 按下 = 0 (>L:...VOR1_Set)，42/43 松开 = 1 (>B:...VOR1_Set)，
--   QFCU 43 按下 = 2 (>B:...VOR1_Set)（即 0 = ADF / 1 = 中位 / 2 = VOR）。
--   miniFCU 是 ADF / OFF / VOR 三个独立按键 → 各只发对应那一个值。
minifcu:CfgRpn(37, '0 (>L:AIRLINER_EFIS_CPT_VOR1_Set)') -- ADF 1 [Q42 按下]
minifcu:CfgRpn(38, '1 (>B:AIRLINER_EFIS_CPT_VOR1_Set)') -- OFF 1 [Q42/Q43 松开]
minifcu:CfgRpn(39, '2 (>B:AIRLINER_EFIS_CPT_VOR1_Set)') -- VOR 1 [Q43 按下]
minifcu:CfgRpn(40, '0 (>L:AIRLINER_EFIS_CPT_VOR2_Set)') -- ADF 2 [Q44 按下]
minifcu:CfgRpn(41, '1 (>B:AIRLINER_EFIS_CPT_VOR2_Set)') -- OFF 2 [Q44/Q45 松开]
minifcu:CfgRpn(42, '2 (>B:AIRLINER_EFIS_CPT_VOR2_Set)') -- VOR 2 [Q45 按下]

-- 气压单位 [Q50]：参考档是单键拨杆（按下 = 0，松开 = 1），miniFCU 是 HPA / INHG 两个
--   独立按键 → 43 只发 1（hPa）、44 只发 0（inHg）；判据见文件头取舍 7
minifcu:CfgRpn(43, '1 (>L:XMLVAR_Baro_Selector_HPA_1)') -- HPA  [Q50 松开值]
minifcu:CfgRpn(44, '0 (>L:XMLVAR_Baro_Selector_HPA_1)') -- INHG [Q50 按下值]
-- 气压旋钮拉 / 按 [Q49 / Q48]
minifcu:CfgVal(45, 'B:AIRLINER_CPT_BARO_SET_PULL', 1, 0)
minifcu:CfgVal(46, 'B:AIRLINER_CPT_BARO_SET_PUSH', 1, 0)

-- ===========================================================
-- INPUT：编码器（bit 47–66）

-- ALT 编码器 [Q16 / Q17]：步长（100/1000）由 sim 侧的 (L:INI_ALTITUDE_STATE) 决定
minifcu:CfgRpn(47, '1 (>B:AIRLINER_MCU_ALT_Dec)')
minifcu:CfgRpn(48, '1 (>B:AIRLINER_MCU_ALT_Dec)')
minifcu:CfgRpn(49, '1 (>B:AIRLINER_MCU_ALT_Inc)')
minifcu:CfgRpn(50, '1 (>B:AIRLINER_MCU_ALT_Inc)')

-- SPD 编码器 [Q0 / Q1]
minifcu:CfgRpn(51, '1 (>B:AIRLINER_MCU_SPEED_Dec)')
minifcu:CfgRpn(52, '1 (>B:AIRLINER_MCU_SPEED_Dec)')
minifcu:CfgRpn(53, '1 (>B:AIRLINER_MCU_SPEED_Inc)')
minifcu:CfgRpn(54, '1 (>B:AIRLINER_MCU_SPEED_Inc)')

-- HDG 编码器 [Q4 / Q5]
minifcu:CfgRpn(55, '1 (>B:AIRLINER_MCU_HDG_Dec)')
minifcu:CfgRpn(56, '1 (>B:AIRLINER_MCU_HDG_Dec)')
minifcu:CfgRpn(57, '1 (>B:AIRLINER_MCU_HDG_Inc)')
minifcu:CfgRpn(58, '1 (>B:AIRLINER_MCU_HDG_Inc)')

-- VS 编码器 [Q20 / Q21]
minifcu:CfgRpn(59, '1 (>B:AIRLINER_MCU_VS_Dec)')
minifcu:CfgRpn(60, '1 (>B:AIRLINER_MCU_VS_Dec)')
minifcu:CfgRpn(61, '1 (>B:AIRLINER_MCU_VS_Inc)')
minifcu:CfgRpn(62, '1 (>B:AIRLINER_MCU_VS_Inc)')

-- BARO 编码器（机长侧）[Q46 / Q47]
minifcu:CfgRpn(63, '1 (>B:AIRLINER_CPT_BARO_SET_Dec)')
minifcu:CfgRpn(64, '1 (>B:AIRLINER_CPT_BARO_SET_Dec)')
minifcu:CfgRpn(65, '1 (>B:AIRLINER_CPT_BARO_SET_Inc)')
minifcu:CfgRpn(66, '1 (>B:AIRLINER_CPT_BARO_SET_Inc)')

-- ===========================================================
-- 显示源（帧循环里直接读）

-- FCU
local dr_is_mach    = iDataRef:New('(L:INI_Airspeed_is_mach)') -- 1 = 显示 MACH
local dr_spd_dial   = iDataRef:New('(L:INI_AIRSPEED_DIAL)') -- 旋钮值：SPD 模式 = kts，MACH 模式 = 马赫
local dr_spd_preset = iDataRef:New('(L:INI_PRESET_DIAL)') -- 230 or 0.71 MACH（managed 时显示）
local dr_spd_dashed = iDataRef:New('(L:INI_FCU_SPD_DASHED)')
local dr_spd_dot    = iDataRef:New('(L:INI_FCU_SPD_DOT)')
local dr_heading    = iDataRef:New('(L:INI_HEADING_DIAL)')
local dr_track      = iDataRef:New('(L:INI_TRK_DIAL)')
local dr_hdgtrk     = iDataRef:New('(L:INI_TRACK_FPA_STATE)') -- 1 = TRK/FPA 模式
local dr_vs         = iDataRef:New('(L:INI_VVI_DIAL)')

-- EFIS 机长侧气压：(L:XMLVAR_Baro_Selector_HPA_1) 1 = hPa / 0 = inHg；
--   (L:XMLVAR_Baro1_Mode) 2 或 3 视为 STD（与参考档 SetLBaro(3) 的判据一致）
local dr_baro_mode = iDataRef:New('(L:XMLVAR_Baro1_Mode)')
local dr_baro_unit = iDataRef:New('(L:XMLVAR_Baro_Selector_HPA_1)')
local dr_baro_inhg = iDataRef:New('(A:KOHLSMAN SETTING HG, inHg)')
local dr_baro_mbar = iDataRef:New('(A:KOHLSMAN SETTING HG, mbar)')

-- ===========================================================
-- OUTPUT：6 个 LED pin
minifcu:GetAp1('(L:INI_ap1_on)')
minifcu:GetAp2('(L:INI_ap2_on)')
minifcu:GetAthr('(L:INI_ATHR_LIGHT)')
minifcu:GetLoc('(L:INI_MCU_LOC_LIGHT)')
minifcu:GetAppr('(L:INI_APPROACH_BUTTON)')
minifcu:GetExped('(L:INI_LEVEL_OFF_LIGHT, Bool)')

-- ===========================================================
-- OUTPUT：miniFCU LCD（CustomDevice 24 通道 = 14 FCU + 12 EFIS，全部保留）

-- MT 0 SPD 值（kts，仅 SPD 模式且非虚线时显示）
minifcu:GetFcuSpdValue('(L:INI_AIRSPEED_DIAL)')
-- MT 1 MACH 值（马赫 × 100）
minifcu:GetFcuMachValue('(L:INI_AIRSPEED_DIAL)', 100)
-- MT 2 SPD/MACH 模式（1 = mach，(L:INI_Airspeed_is_mach)）
minifcu:GetFcuSpdMachMode('(L:INI_Airspeed_is_mach)')
-- MT 3 SPD dashed
minifcu:GetFcuSpdDashes('(L:INI_FCU_SPD_DASHED)')
-- MT 4 SPD managed 点
minifcu:GetFcuSpdDot('(L:INI_FCU_SPD_DOT)')
-- MT 5 HDG 值
minifcu:GetFcuHdgValue('(L:INI_HEADING_DIAL)')
-- MT 6 HDG dashed
minifcu:GetFcuHdgDashes('(L:INI_FCU_HDG_DASHED)')
-- MT 7 HDG managed 点
minifcu:GetFcuHdgDot('(L:INI_FCU_HDG_DOT)')
-- MT 8 ALT 值（ft / 100）
minifcu:GetFcuAltValue('(L:INI_ALTITUDE_DIAL)', 0.01)
-- MT 9 ALT managed 点（与参考档同一条 RPN，求值副作用写入 (L:MfAltDot)）
minifcu:GetFcuAltDot(
	'(L:FMGS_vertical_mode) 20 >= (L:FMGS_vertical_mode) 23 <= && (L:FMGS_vertical_mode) 40 >= || (L:FMGS_vertical_mode) 0 == (L:INI_PITCH_MODE_ARM) 3 == && || (L:FMGS_vertical_mode) 10 == (L:INI_REST_WPT_ALT) (A:INDICATED ALTITUDE,Feet) - abs 100 < && || (>L:MfAltDot) (L:MfAltDot)')
-- MT 10 VS 值（fpm，带符号；TRK/FPA 模式下改为显示 FPA）
minifcu:GetFcuVsValue('(L:INI_VVI_DIAL)')
-- MT 11 FPA 值（FPA × 1000；源 INI_FPA_DIAL 是度 → 默认 scale 1000）
minifcu:GetFcuFpaValue('(L:INI_FPA_DIAL)')
-- MT 12 VS dashed
minifcu:GetFcuVsDashes('(L:INI_FCU_VS_DASHED)')
-- MT 13 HDG/TRK 模式（1 = TRK）
minifcu:GetFcuHdgTrkMode('(L:INI_TRACK_FPA_STATE)')

-- EFIS 机长侧 LED / LCD（副驾侧的 *_2 / INI_*_FO 变量不取）
minifcu:GetEfisCstr('(L:INI_SHOW_CONSTRAINTS)')
minifcu:GetEfisWpt('(L:INI_SHOW_FIXES)')
minifcu:GetEfisVord('(L:INI_SHOW_VORS)')
minifcu:GetEfisNdb('(L:INI_SHOW_NDBS)')
minifcu:GetEfisArpt('(L:INI_SHOW_AIRPORTS)')
minifcu:GetFcuFdValue('(L:INI_FD1_ON)')
minifcu:GetFcuLsValue('(L:INI_LS_CAPTAIN)')
-- MT 7 QNH 标签（非 STD 时为 1）
minifcu:GetEfisBaroQnnh1('(L:XMLVAR_Baro1_Mode)')
-- MT 8 STD 标志
minifcu:GetEfisBaroStd1('(L:XMLVAR_Baro1_Mode)')
-- MT 9 inHg/hPa（1 = inHg）
minifcu:GetEfisBaroInhgHpaUnit('(L:XMLVAR_Baro_Selector_HPA_1)')
-- MT 10 BARO inHg（×100）/ MT 11 BARO hPa（两个值各读各自的原始变量，切单位不会读到陈旧值）
minifcu:GetEfisBaroInhg('(A:KOHLSMAN SETTING HG, inHg)')
minifcu:GetEfisBaro('(A:KOHLSMAN SETTING HG, mbar)')

-- ===========================================================
-- 帧循环

GlobalFrameLoopManager:add(function()
	-- ---- 6 个 LED pin ----
	minifcu:SetAp1()
	minifcu:SetAp2()
	minifcu:SetAthr()
	minifcu:SetLoc()
	minifcu:SetAppr()
	minifcu:SetExped()

	-- ---- FCU LCD ----
	local is_mach    = dr_is_mach:Get()
	local spd_dash   = dr_spd_dashed:Get()
	local spd_dot    = dr_spd_dot:Get()
	local spd_dial   = dr_spd_dial:Get()
	local spd_preset = dr_spd_preset:Get()
	local is_fpa     = (dr_hdgtrk:Get() >= 1)

	-- MT 2：SPD/MACH 模式
	minifcu:SetFcuSpdMachMode(is_mach >= 1 and 1 or 0)

	-- 显示值：managed（有点）时参考档用 (L:INI_PRESET_DIAL)，否则用 (L:INI_AIRSPEED_DIAL)
	local spd_show = spd_dial
	if spd_dot >= 1 then
		spd_show = spd_preset
	end

	-- MT 1：MACH 值（mach × 100；非 MACH 模式或虚线时置 0）
	if is_mach >= 1 and spd_dash < 1 then
		minifcu:SetFcuMachValue(math.floor(spd_show * 100 + 0.5))
	else
		minifcu:SetFcuMachValue(0)
	end

	-- MT 0：SPD 值（kts；MACH 模式或虚线时置 0）
	if is_mach < 1 and spd_dash < 1 then
		minifcu:SetFcuSpdValue(math.floor(spd_show + 0.5))
	else
		minifcu:SetFcuSpdValue(0)
	end

	-- MT 3 / MT 4：虚线 与 managed 点
	minifcu:SetFcuSpdDashes()
	minifcu:SetFcuSpdDot()

	-- MT 5：HDG 值（TRK/FPA 模式下显示 TRK 值 —— 与参考档 digi_disp_set_HDG 一致）
	local hdg_val = dr_heading:Get()
	if is_fpa then
		hdg_val = dr_track:Get()
	end
	minifcu:SetFcuHdgValue(math.floor(hdg_val))
	-- MT 6 / MT 7：HDG dashed 与 managed 点
	minifcu:SetFcuHdgDashes()
	minifcu:SetFcuHdgDot()

	-- MT 8 / MT 9：ALT 值（ft / 100）与 managed 点
	minifcu:SetFcuAltValue()
	minifcu:SetFcuAltDot()

	-- MT 10 / MT 11 / MT 12：VS 与 FPA 互斥（TRK/FPA 模式下 VS 窗口显示 FPA）
	minifcu:SetFcuVsDashes()
	if is_fpa then
		minifcu:SetFcuVsValue(0)
		minifcu:SetFcuFpaValue()
	else
		minifcu:SetFcuVsValue(dr_vs:Get())
		minifcu:SetFcuFpaValue(0)
	end

	-- MT 13：HDG/TRK 模式
	minifcu:SetFcuHdgTrkMode()

	-- ---- EFIS 半区（机长）----
	minifcu:SetEfisCstr()
	minifcu:SetEfisWpt()
	minifcu:SetEfisVord()
	minifcu:SetEfisNdb()
	minifcu:SetEfisArpt()
	minifcu:SetFcuFdValue()
	minifcu:SetFcuLsValue()

	-- 气压：STD 判据与参考档一致（(L:XMLVAR_Baro1_Mode) == 2 或 3 视为 STD）；
	--   单位：(L:XMLVAR_Baro_Selector_HPA_1) 1 = hPa / 0 = inHg → MT 9 的 1 = inHg
	local baro_mode = dr_baro_mode:Get()
	local baro_hpa  = dr_baro_unit:Get()
	local baro_inhg = dr_baro_inhg:Get()
	local is_std    = (baro_mode == 2 or baro_mode == 3)

	minifcu:SetEfisBaroInhgHpaUnit(baro_hpa >= 1 and 0 or 1)
	minifcu:SetEfisBaroStd1(is_std and 1 or 0)
	minifcu:SetEfisBaroQnnh1(is_std and 0 or 1)

	-- MT 10 / MT 11：两个值都算（int 通道会截断，自己 floor(x + 0.5)）
	minifcu:SetEfisBaroInhg(math.floor(baro_inhg * 100 + 0.5))
	minifcu:SetEfisBaro(math.floor(dr_baro_mbar:Get() + 0.5))
end)
