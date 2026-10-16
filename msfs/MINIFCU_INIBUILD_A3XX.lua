-- *****************************************************************
-- FlyLuaIO MobiFlight miniFCU (miniFCU + miniEFIS) for MSFS
-- iniBuilds A3xx 家族（A320 / A321 / A330 / belugax，gate: ilua_require_inibuild_a3xx_family()）
-- created by Wei Shuai <cpuwolf@gmail.com>
-- *****************************************************************
-- 来源与依据（可追溯）：
--   * 事件名 / B 事件 / L 变量 / A 变量：msfs/data/QFCU_INIBUILD_A3xx.lua（QFCU 同机型档，MSFS 实测通过）。
--     每条绑定后的 [Q#] 标注该功能在 QFCU 面板上的 KeyIdx，便于与 QFCU 档逐条对照。
--   * 机型分支：参考档用 ilua_is_acfpath_excluded("A330") / ("belugax") 判 isINIA330 ——
--     A330/belugax 的 SPD/HDG/ALT/VS 旋钮与推拉走 B:AIRLINER_MCU_*、气压旋钮走
--     B:AIRLINER_CPT_BARO_SET、EXPED 走 B:AIRLINER_ALT_PUSH；A320/A321 走
--     B:INSTRUMENT_FCU_*_Knob / B:INSTRUMENT_QNH_CPT_Knob 与 EXPEDITE 命令。
--     本档逐字保留同一分支（含 uluaLog 的分支名日志），不做简化。
--   * 硬件通道契约：mobiflight/MiniFCU.json（按键 bit 0–46、编码器 bit 47–66、
--     6 个 Output pin、26 条 CustomDevice 通道）。
--   * 通道语义 / 编码器位序：xp/MINIFCU_Toliss.lua（真机 miniFCU 在 X-Plane 上手工调过并实测）。
-- 编码器位序（沿用 XP 档，勿改）：每轴 4 bit，前 2 bit = 减，后 2 bit = 加。
--   ALT 47/48 减 · 49/50 加；SPD 51/52 · 53/54；HDG 55/56 · 57/58；VS 59/60 · 61/62；BARO 63/64 · 65/66
-- 已知取舍（待真机验证）：
--   1. 未做断电门控：QFCU 档用 INI_DC_ESSENTIAL_BUS_IS_POWERED / INI_ELEC_AC_ESS_SHED_BUS_IS_POWERED
--      控制 LCD 与背光、用 INI_POTENTIOMETER_16/17 调亮度；miniFCU 硬件无背光/熄灭通道
--      （XP 档也没做），这里保持一致。
--   2. QFCU 面板有两个 EFIS 半区（机长/副驾），miniFCU 只有机长半区，故 QFCU 的
--      51/52/53（副驾气压）与 56–79（副驾 EFIS）不移植。
--   3. 五个旋钮（ALT / SPD / HDG / VS / 机长气压）：参考档用 qfcu:CfgEnc(dec_bit, inc_bit, "B:..._Knob")。
--      ⚠ CfgEnc 在 MF 设备上不可用（真机验证）→ 本档每 bit 一条 CfgRpn，发机模的分向事件
--      <参考档事件名>_Dec / _Inc（参数 1），A330 与 A320/A321 两条分支各自沿用参考档的事件名。
--   4. SPD/HDG/ALT/VS 的 PUSH/PULL、EXPED 在参考档里是 CfgVal(..., 1, 0)（按下发 1、松开发 0），
--      本档照抄成对 CfgVal（同一 B 事件、同一对值），运行时即 DFKEY 的 press/release 边沿。
--   5. ALT 100/1000（QFCU 15 → miniFCU 17）：参考档是拨杆 —— 按下时若 (L:INI_ALTITUDE_STATE) != 0
--      就发 ALTITUDE_MODE_COMMAND，松开时若 == 0 再发一次。miniFCU 是瞬时按键
--      （按住 = 1000 ft 步长、松开回 100 ft），故按规格把两条 RPN 反写：press 用参考档的
--      release 那条、release 用参考档的 press 那条；变量名与命令逐字不变。
--   6. ADF/OFF/VOR（QFCU 42–45 → miniFCU 37–42）：QFCU 是两档拨杆（press / release 各一个值），
--      miniFCU 是 ADF / OFF / VOR 三个独立按键 → 只发 press 边沿：
--      37 = Q42 press(0)、38 = Q42/Q43 release(1 = 中位 OFF)、39 = Q43 press(2)，
--      40/41/42 同理对应 Q44/Q45。
--      INI_VOR_ADF{1,2}_CAPT_STATE：0 = ADF、1 = OFF、2 = VOR（照抄参考档取值，不是 0/1/2 的顺序）。
--   7. 气压单位（QFCU 50 → miniFCU 43 HPA / 44 INHG）：参考档是单键拨杆
--      CfgRpn(50, "0 (>L:XMLVAR_Baro_Selector_HPA_1)", "1 (>L:XMLVAR_Baro_Selector_HPA_1)")。
--      按参考档自己的气压读取表达式（该选择器为 0 时读 inHg×100、为 1 时读 mbar）可知
--      1 = hPa、0 = inHg，故 43（HPA 键）发参考档的 release 值 1、44（INHG 键）发 press 值 0，
--      两个键各自只发一次（不按字面的 press→43 / release→44 排，否则键面语义会反）。
--   8. 气压 STD 判据：(L:XMLVAR_Baro1_Mode) == 2 或 == 3 为 STD（参考档 digi_disp_set_L_EFIS
--      的判据写的就是 2 或 3），其余为 QNH；参考档的气压值表达式在 mode > 2 时返回 99，
--      由 STD 标志接管显示。
--   9. bit 25（CHRONO）：QFCU 面板无此键，参考档里也没有对应的计时事件 / L 变量 → 不绑定。
-- *****************************************************************

if ilua_require_msfs() then
	return
end
if ilua_require_inibuild_a3xx_family() then return end

-- Do not remove below lines: hardware detection
local minifcu = com.sim.mf.MiniFCU.Open()
if not minifcu then return end
-- Do not remove above lines: hardware detection

uluaLog('MobiFlight MiniFCU for iniBuilds A3xx')

-- 机型分支与参考档逐字一致：A330 与 belugax 共用 B:AIRLINER_MCU_* / B:AIRLINER_CPT_BARO_SET
local isINIA330 = false
if not ilua_is_acfpath_excluded('A330') then
	isINIA330 = true
	uluaLog('- MiniFCU Inibuild A330')
end
if not ilua_is_acfpath_excluded('belugax') then
	isINIA330 = true
	uluaLog('- MiniFCU Inibuild belugax')
end

-- ===========================================================
-- INPUT：FCU 半区（bit 0–17）

-- SPD/MACH 显示切换 [Q55]
minifcu:CfgRpn(0, '1 (>L:INI_SPD_MACH_BUTTON)') -- [Q55]
-- HDG/TRK ↔ VS/FPA 切换 [Q54]
minifcu:CfgRpn(1, '1 (>L:INI_FCU_HDG_VS_COMMAND)') -- [Q54]
-- AP1 [Q10]
minifcu:CfgRpn(2, '1 (>L:INI_AP1_BUTTON)') -- [Q10]
-- AP2 [Q9]
minifcu:CfgRpn(3, '1 (>L:INI_AP2_BUTTON)') -- [Q9]
-- METRIC ALT [Q14]
minifcu:CfgRpn(4, '(L:INI_FCU_METRIC_STATE) ! (>L:INI_FCU_METRIC_STATE)') -- [Q14]
-- A/THR [Q11]
minifcu:CfgRpn(5, '1 (>L:AP8_BUTTON)') -- [Q11]
-- EXPED [Q12]：A330/belugax 是 B 事件（CfgVal 按下 1 / 松开 0），A320/A321 是 EXPEDITE 命令
if isINIA330 then
	minifcu:CfgVal(6, 'B:AIRLINER_ALT_PUSH', 1, 0) -- [Q12] A330
else
	minifcu:CfgRpn(6, '1 (>L:A320_FCU_EXPEDITE_COMMAND)') -- [Q12] A320/A321
end
-- LOC [Q8]
minifcu:CfgRpn(7, '1 (>L:AP6_BUTTON)') -- [Q8]
-- APPR [Q13]
minifcu:CfgRpn(8, '1 (>L:AP7_BUTTON)') -- [Q13]

-- SPD PUSH / PULL [Q2 / Q3]：参考档 CfgVal(..., 1, 0) → 按下发 1、松开发 0
if isINIA330 then
	minifcu:CfgVal(9, 'B:AIRLINER_MCU_SPEED_Push', 1, 0) -- [Q2] A330
	minifcu:CfgVal(10, 'B:AIRLINER_MCU_SPEED_Pull', 1, 0) -- [Q3] A330
else
	minifcu:CfgVal(9, 'B:INSTRUMENT_FCU_SPD_Push', 1, 0) -- [Q2] A320/A321
	minifcu:CfgVal(10, 'B:INSTRUMENT_FCU_SPD_Pull', 1, 0) -- [Q3] A320/A321
end

-- HDG PUSH / PULL [Q6 / Q7]
if isINIA330 then
	minifcu:CfgVal(11, 'B:AIRLINER_MCU_HDG_Push', 1, 0) -- [Q6] A330
	minifcu:CfgVal(12, 'B:AIRLINER_MCU_HDG_Pull', 1, 0) -- [Q7] A330
else
	minifcu:CfgVal(11, 'B:INSTRUMENT_FCU_HDG_Push', 1, 0) -- [Q6] A320/A321
	minifcu:CfgVal(12, 'B:INSTRUMENT_FCU_HDG_Pull', 1, 0) -- [Q7] A320/A321
end

-- ALT PUSH / PULL [Q18 / Q19]
if isINIA330 then
	minifcu:CfgVal(13, 'B:AIRLINER_MCU_ALT_Push', 1, 0) -- [Q18] A330
	minifcu:CfgVal(14, 'B:AIRLINER_MCU_ALT_Pull', 1, 0) -- [Q19] A330
else
	minifcu:CfgVal(13, 'B:INSTRUMENT_FCU_ALT_Push', 1, 0) -- [Q18] A320/A321
	minifcu:CfgVal(14, 'B:INSTRUMENT_FCU_ALT_Pull', 1, 0) -- [Q19] A320/A321
end

-- VS PUSH / PULL [Q22 / Q23]
if isINIA330 then
	minifcu:CfgVal(15, 'B:AIRLINER_MCU_VS_Push', 1, 0) -- [Q22] A330
	minifcu:CfgVal(16, 'B:AIRLINER_MCU_VS_Pull', 1, 0) -- [Q23] A330
else
	minifcu:CfgVal(15, 'B:INSTRUMENT_FCU_VS_Push', 1, 0) -- [Q22] A320/A321
	minifcu:CfgVal(16, 'B:INSTRUMENT_FCU_VS_Pull', 1, 0) -- [Q23] A320/A321
end

-- ALT 100/1000 [Q15]：miniFCU 是瞬时按键 —— 按住 = 1000 ft 步长，松开回 100 ft。
--   参考档是拨杆（按下期望 INI_ALTITUDE_STATE != 0、松开期望 == 0），故两条 RPN 反写，
--   变量名与命令逐字沿用参考档（见文件头取舍 5）。
local alt_1000_rpn = '(L:INI_ALTITUDE_STATE) 0 == if{ 1 (>L:INI_FCU_ALTITUDE_MODE_COMMAND) }' -- [Q15] 按住 → 1000
local alt_100_rpn  = '(L:INI_ALTITUDE_STATE) 0 != if{ 1 (>L:INI_FCU_ALTITUDE_MODE_COMMAND) }' -- [Q15] 松开 → 100
minifcu:CfgRpn(17, alt_1000_rpn, alt_100_rpn) -- [Q15]

-- ===========================================================
-- INPUT：EFIS 半区机长侧（bit 18–46）

-- 导航点过滤键 [Q35–Q39]
minifcu:CfgRpn(18, '1 (>L:INI_EFIS_CPT_CSTR_BUTTON)')  -- [Q35] CSTR
minifcu:CfgRpn(19, '1 (>L:INI_EFIS_CPT_FIXES_BUTTON)') -- [Q36] WPT
minifcu:CfgRpn(20, '1 (>L:INI_EFIS_CPT_VOR_BUTTON)')   -- [Q37] VOR D
minifcu:CfgRpn(21, '1 (>L:INI_EFIS_CPT_NDB_BUTTON)')   -- [Q38] NDB
minifcu:CfgRpn(22, '1 (>L:INI_EFIS_CPT_ARPT_BUTTON)')  -- [Q39] ARPT
-- FD / LS [Q40 / Q41]：参考档是取反写入
minifcu:CfgRpn(23, '(L:INI_FD1_ON, Bool) ! (>L:INI_FD1_ON)')       -- [Q40] FD
minifcu:CfgRpn(24, '(L:INI_LS_CAPTAIN, Bool) ! (>L:INI_LS_CAPTAIN)') -- [Q41] LS
-- bit 25 CHRONO：QFCU 面板无此键，参考档里也没有对应的计时事件 / L 变量
-- TODO: 未绑定 —— 确认 iniBuilds A3xx 的 EFIS 计时/CHRONO 事件后再补（不瞎猜事件名）

-- ROSE 模式键 [Q24–Q28]：LS/VOR/NAV/ARC/PLN → INI_MAP_MODE_CAPT_SWITCH 0–4
minifcu:CfgRpn(26, '0 (>L:INI_MAP_MODE_CAPT_SWITCH)') -- [Q24] LS
minifcu:CfgRpn(27, '1 (>L:INI_MAP_MODE_CAPT_SWITCH)') -- [Q25] VOR
minifcu:CfgRpn(28, '2 (>L:INI_MAP_MODE_CAPT_SWITCH)') -- [Q26] NAV
minifcu:CfgRpn(29, '3 (>L:INI_MAP_MODE_CAPT_SWITCH)') -- [Q27] ARC
minifcu:CfgRpn(30, '4 (>L:INI_MAP_MODE_CAPT_SWITCH)') -- [Q28] PLN

-- 距离 [Q29–Q34]：10/20/40/80/160/320 → INI_MAP_RANGE_CAPT_SWITCH 0–5
minifcu:CfgRpn(31, '0 (>L:INI_MAP_RANGE_CAPT_SWITCH)') -- [Q29] 10
minifcu:CfgRpn(32, '1 (>L:INI_MAP_RANGE_CAPT_SWITCH)') -- [Q30] 20
minifcu:CfgRpn(33, '2 (>L:INI_MAP_RANGE_CAPT_SWITCH)') -- [Q31] 40
minifcu:CfgRpn(34, '3 (>L:INI_MAP_RANGE_CAPT_SWITCH)') -- [Q32] 80
minifcu:CfgRpn(35, '4 (>L:INI_MAP_RANGE_CAPT_SWITCH)') -- [Q33] 160
minifcu:CfgRpn(36, '5 (>L:INI_MAP_RANGE_CAPT_SWITCH)') -- [Q34] 320

-- VOR/ADF 选择 1 与 2 [Q42–Q45]：QFCU 是两档拨杆（press / release），miniFCU 是
--   ADF / OFF / VOR 三个独立按键 → 只发按下：ADF = 0、OFF = 中位 1、VOR = 2（见文件头取舍 6）
minifcu:CfgRpn(37, '0 (>L:INI_VOR_ADF1_CAPT_STATE)') -- [Q42] ADF 1
minifcu:CfgRpn(38, '1 (>L:INI_VOR_ADF1_CAPT_STATE)') -- [Q42/Q43] OFF 1（release 中位）
minifcu:CfgRpn(39, '2 (>L:INI_VOR_ADF1_CAPT_STATE)') -- [Q43] VOR 1
minifcu:CfgRpn(40, '0 (>L:INI_VOR_ADF2_CAPT_STATE)') -- [Q44] ADF 2
minifcu:CfgRpn(41, '1 (>L:INI_VOR_ADF2_CAPT_STATE)') -- [Q44/Q45] OFF 2（release 中位）
minifcu:CfgRpn(42, '2 (>L:INI_VOR_ADF2_CAPT_STATE)') -- [Q45] VOR 2

-- 气压单位 [Q50]：XMLVAR_Baro_Selector_HPA_1 = 1 → hPa、= 0 → inHg（见文件头取舍 7）。
--   miniFCU 是两个独立按键，故 43 只发 HPA 值、44 只发 INHG 值，各自只发按下边沿。
minifcu:CfgRpn(43, '1 (>L:XMLVAR_Baro_Selector_HPA_1)') -- [Q50] HPA
minifcu:CfgRpn(44, '0 (>L:XMLVAR_Baro_Selector_HPA_1)') -- [Q50] INHG
-- 气压旋钮拉 / 按 [Q49 / Q48]
minifcu:CfgRpn(45, '1 (>L:INI_1_ALTIMETER_PULL_COMMAND)') -- [Q49] PULL
minifcu:CfgRpn(46, '1 (>L:INI_1_ALTIMETER_PUSH_COMMAND)') -- [Q48] PUSH

-- ===========================================================
-- INPUT：编码器（bit 47–66）
-- 参考档这 5 个轴用 qfcu:CfgEnc(dec_bit, inc_bit, "B:<事件>") 表达（QFCU 固件的 ROTATE 配置：
-- 把本次旋转的带符号累加增量当作输入事件的参数发出去）。
-- ⚠ CfgEnc 在 MF 设备（miniFCU）上不可用 —— 真机验证的结论，不要再用 CfgEnc 镜像这类写法。
-- 本档改为每 bit 一条 CfgRpn，发机模自己的分向事件 <事件>_Dec / <事件>_Inc（参数 1）：
--   47/48 = 减、49/50 = 加（每轴 4 bit，位序见文件头）。
-- ⚠ 若真机上某轴不动，说明该机型没有 _Dec/_Inc 分向事件 → 回退成向基事件发增量值：
--   '-1 (>B:<事件>)' / '1 (>B:<事件>)'（MSFS 侧 MSFSSetDatad 会把 RPN 值当事件参数发出）。

-- ALT 编码器 [Q16 / Q17]
if isINIA330 then
	minifcu:CfgRpn(47, '1 (>B:AIRLINER_MCU_ALT_Dec)')
	minifcu:CfgRpn(48, '1 (>B:AIRLINER_MCU_ALT_Dec)')
	minifcu:CfgRpn(49, '1 (>B:AIRLINER_MCU_ALT_Inc)')
	minifcu:CfgRpn(50, '1 (>B:AIRLINER_MCU_ALT_Inc)')
else
	minifcu:CfgRpn(47, '1 (>B:INSTRUMENT_FCU_ALT_Knob_Dec)')
	minifcu:CfgRpn(48, '1 (>B:INSTRUMENT_FCU_ALT_Knob_Dec)')
	minifcu:CfgRpn(49, '1 (>B:INSTRUMENT_FCU_ALT_Knob_Inc)')
	minifcu:CfgRpn(50, '1 (>B:INSTRUMENT_FCU_ALT_Knob_Inc)')
end

-- SPD 编码器 [Q0 / Q1]
if isINIA330 then
	minifcu:CfgRpn(51, '1 (>B:AIRLINER_MCU_SPEED_Dec)')
	minifcu:CfgRpn(52, '1 (>B:AIRLINER_MCU_SPEED_Dec)')
	minifcu:CfgRpn(53, '1 (>B:AIRLINER_MCU_SPEED_Inc)')
	minifcu:CfgRpn(54, '1 (>B:AIRLINER_MCU_SPEED_Inc)')
else
	minifcu:CfgRpn(51, '1 (>B:INSTRUMENT_FCU_SPD_Knob_Dec)')
	minifcu:CfgRpn(52, '1 (>B:INSTRUMENT_FCU_SPD_Knob_Dec)')
	minifcu:CfgRpn(53, '1 (>B:INSTRUMENT_FCU_SPD_Knob_Inc)')
	minifcu:CfgRpn(54, '1 (>B:INSTRUMENT_FCU_SPD_Knob_Inc)')
end

-- HDG 编码器 [Q4 / Q5]
if isINIA330 then
	minifcu:CfgRpn(55, '1 (>B:AIRLINER_MCU_HDG_Dec)')
	minifcu:CfgRpn(56, '1 (>B:AIRLINER_MCU_HDG_Dec)')
	minifcu:CfgRpn(57, '1 (>B:AIRLINER_MCU_HDG_Inc)')
	minifcu:CfgRpn(58, '1 (>B:AIRLINER_MCU_HDG_Inc)')
else
	minifcu:CfgRpn(55, '1 (>B:INSTRUMENT_FCU_HDG_Knob_Dec)')
	minifcu:CfgRpn(56, '1 (>B:INSTRUMENT_FCU_HDG_Knob_Dec)')
	minifcu:CfgRpn(57, '1 (>B:INSTRUMENT_FCU_HDG_Knob_Inc)')
	minifcu:CfgRpn(58, '1 (>B:INSTRUMENT_FCU_HDG_Knob_Inc)')
end

-- VS 编码器 [Q20 / Q21]
if isINIA330 then
	minifcu:CfgRpn(59, '1 (>B:AIRLINER_MCU_VS_Dec)')
	minifcu:CfgRpn(60, '1 (>B:AIRLINER_MCU_VS_Dec)')
	minifcu:CfgRpn(61, '1 (>B:AIRLINER_MCU_VS_Inc)')
	minifcu:CfgRpn(62, '1 (>B:AIRLINER_MCU_VS_Inc)')
else
	minifcu:CfgRpn(59, '1 (>B:INSTRUMENT_FCU_VS_Knob_Dec)')
	minifcu:CfgRpn(60, '1 (>B:INSTRUMENT_FCU_VS_Knob_Dec)')
	minifcu:CfgRpn(61, '1 (>B:INSTRUMENT_FCU_VS_Knob_Inc)')
	minifcu:CfgRpn(62, '1 (>B:INSTRUMENT_FCU_VS_Knob_Inc)')
end

-- BARO 编码器（机长侧）[Q46 / Q47]
if isINIA330 then
	minifcu:CfgRpn(63, '1 (>B:AIRLINER_CPT_BARO_SET_Dec)')
	minifcu:CfgRpn(64, '1 (>B:AIRLINER_CPT_BARO_SET_Dec)')
	minifcu:CfgRpn(65, '1 (>B:AIRLINER_CPT_BARO_SET_Inc)')
	minifcu:CfgRpn(66, '1 (>B:AIRLINER_CPT_BARO_SET_Inc)')
else
	minifcu:CfgRpn(63, '1 (>B:INSTRUMENT_QNH_CPT_Knob_Dec)')
	minifcu:CfgRpn(64, '1 (>B:INSTRUMENT_QNH_CPT_Knob_Dec)')
	minifcu:CfgRpn(65, '1 (>B:INSTRUMENT_QNH_CPT_Knob_Inc)')
	minifcu:CfgRpn(66, '1 (>B:INSTRUMENT_QNH_CPT_Knob_Inc)')
end

-- ===========================================================
-- 显示源（帧循环里直接读）

-- FCU（源与判据取自参考档的 digi_disp_set_SPD / HDG / ALT / VS）
local dr_airspeed    = iDataRef:New('(L:INI_AIRSPEED_DIAL)') -- SPD 模式 = kts；MACH 模式 = 马赫（0.xx）
local dr_is_mach     = iDataRef:New('(L:INI_Airspeed_is_mach)') -- 1 = 显示 MACH
local dr_spd_dashed  = iDataRef:New('(L:INI_FCU_SPD_DASHED)')
local dr_is_spdmgd   = iDataRef:New('(L:INI_managed_speed)') -- managed 点
local dr_heading     = iDataRef:New('(L:INI_HEADING_DIAL)')
local dr_track       = iDataRef:New('(L:INI_TRK_DIAL)') -- TRK/FPA 模式下的显示值
local dr_hdgtrk      = iDataRef:New('(L:INI_TRACK_FPA_STATE)') -- 1 = TRK/FPA
local dr_hdg_dashed  = iDataRef:New('(L:INI_FCU_HDG_DASHED)')
local dr_hdg_dot     = iDataRef:New('(L:INI_FCU_HDG_DOT)')
local dr_alt         = iDataRef:New('(L:INI_ALTITUDE_DIAL)') -- ft（参考档 GetAlt 直送显示，即整数英尺）
local dr_alt_dot     = iDataRef:New('(L:INI_FCU_ALT_DOT)')
local dr_vs          = iDataRef:New('(L:INI_VVI_DIAL)') -- fpm（下降为负）
local dr_fpa         = iDataRef:New('(L:INI_FPA_DIAL)') -- 度（下降为负）
local dr_vs_dashed   = iDataRef:New('(L:INI_FCU_VS_DASHED)')

-- EFIS 机长侧气压：值表达式逐字取自参考档（选择器 0 = inHg×100、1 = mbar；mode > 2 时给 99，
--   由 STD 标志接管显示）；XMLVAR_Baro1_Mode 取 2 或 3 为 STD（参考档判据）
local dr_baro        = iDataRef:New(
	'(L:XMLVAR_Baro1_Mode) 2 > if{ 99 } els{ (L:XMLVAR_Baro_Selector_HPA_1,bool) ! if{ (A:KOHLSMAN SETTING HG, inHg) 0.005 - 100 * near } els{ (A:KOHLSMAN SETTING HG, mbar) near } }')
local dr_baro_unit   = iDataRef:New('(L:XMLVAR_Baro_Selector_HPA_1)') -- 1 = hPa，0 = inHg
local dr_baro_mode   = iDataRef:New('(L:XMLVAR_Baro1_Mode)')

-- ===========================================================
-- OUTPUT：6 个 LED pin（源取自参考档）
minifcu:GetAp1('(L:INI_ap1_on)')
minifcu:GetAp2('(L:INI_ap2_on)')
minifcu:GetAthr('(L:INI_ATHR_LIGHT)')
minifcu:GetLoc('(L:INI_MCU_LOC_LIGHT)')
minifcu:GetAppr('(L:INI_APPROACH_BUTTON)')
if isINIA330 then
	minifcu:GetExped('(L:INI_ALTITUDE_MEM_DIAL) (L:INI_ALTITUDE_DIAL) !=') -- [Q12] A330
else
	minifcu:GetExped('(L:INI_EXPEDITE_LIGHT)') -- [Q12] A320/A321
end

-- ===========================================================
-- OUTPUT：miniFCU LCD（CustomDevice 24 通道 = 14 FCU + 12 EFIS，全部保留）

-- MT 0 SPD 值（kts；MACH 模式或 dashed 时帧循环里置 0）
minifcu:GetFcuSpdValue('(L:INI_AIRSPEED_DIAL)')
-- MT 1 MACH 值（马赫 × 100）
minifcu:GetFcuMachValue('(L:INI_AIRSPEED_DIAL)', 100)
-- MT 2 SPD/MACH 模式（1 = mach）
minifcu:GetFcuSpdMachMode('(L:INI_Airspeed_is_mach)')
-- MT 3 SPD dashed
minifcu:GetFcuSpdDashes('(L:INI_FCU_SPD_DASHED)')
-- MT 4 SPD managed 点
minifcu:GetFcuSpdDot('(L:INI_managed_speed)')
-- MT 5 HDG 值（TRK/FPA 模式下帧循环取 INI_TRK_DIAL）
minifcu:GetFcuHdgValue('(L:INI_HEADING_DIAL)')
-- MT 6 HDG dashed
minifcu:GetFcuHdgDashes('(L:INI_FCU_HDG_DASHED)')
-- MT 7 HDG managed 点
minifcu:GetFcuHdgDot('(L:INI_FCU_HDG_DOT)')
-- MT 8 ALT 值（ft / 100）
minifcu:GetFcuAltValue('(L:INI_ALTITUDE_DIAL)', 0.01)
-- MT 9 ALT managed 点
minifcu:GetFcuAltDot('(L:INI_FCU_ALT_DOT)')
-- MT 10 VS 值（fpm，带符号；TRK/FPA 模式下由 MT 11 接管）
minifcu:GetFcuVsValue('(L:INI_VVI_DIAL)')
-- MT 11 FPA 值（度；TRK/FPA 模式下显示）
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
-- MT 5 FD / MT 6 LS
minifcu:GetFcuFdValue('(L:INI_FD1_ON)')
minifcu:GetFcuLsValue('(L:INI_LS_CAPTAIN)')
-- MT 7 QNH 标签（非 STD 时为 1）/ MT 8 STD 标志（参考档判据：mode == 2 或 3 才是 STD）
minifcu:GetEfisBaroQnnh1('(L:XMLVAR_Baro1_Mode) 2 <')
minifcu:GetEfisBaroStd1('(L:XMLVAR_Baro1_Mode) 2 >=')
-- MT 9 inHg/hPa（1 = inHg；源 XMLVAR_Baro_Selector_HPA_1 为 1 表示 hPa）
minifcu:GetEfisBaroInhgHpaUnit('(L:XMLVAR_Baro_Selector_HPA_1) 1 <')
-- MT 10 BARO inHg（×100）/ MT 11 BARO hPa（两个值都在帧循环里换算后写入）
minifcu:GetEfisBaroInhg(
	'(L:XMLVAR_Baro1_Mode) 2 > if{ 99 } els{ (L:XMLVAR_Baro_Selector_HPA_1,bool) ! if{ (A:KOHLSMAN SETTING HG, inHg) 0.005 - 100 * near } els{ (A:KOHLSMAN SETTING HG, mbar) near } }')
minifcu:GetEfisBaro(
	'(L:XMLVAR_Baro1_Mode) 2 > if{ 99 } els{ (L:XMLVAR_Baro_Selector_HPA_1,bool) ! if{ (A:KOHLSMAN SETTING HG, inHg) 0.005 - 100 * near } els{ (A:KOHLSMAN SETTING HG, mbar) near } }')

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
	local is_mach  = dr_is_mach:Get()
	local spd_dash = dr_spd_dashed:Get()
	local spd_val  = dr_airspeed:Get()

	-- MT 2：SPD/MACH 模式
	minifcu:SetFcuSpdMachMode(is_mach >= 1 and 1 or 0)

	-- MT 1：MACH 值（mach × 100；SPD 模式或 dashed 时置 0，与参考档 digi_disp_set_SPD 同判据）
	if is_mach >= 1 and spd_dash < 1 then
		minifcu:SetFcuMachValue(math.floor(spd_val * 100 + 0.5))
	else
		minifcu:SetFcuMachValue(0)
	end

	-- MT 0：SPD 值（kts；mach 或 dashed 时置 0）
	if is_mach < 1 and spd_dash < 1 then
		minifcu:SetFcuSpdValue(math.floor(spd_val + 0.5))
	else
		minifcu:SetFcuSpdValue(0)
	end

	-- MT 3 / MT 4：dashed 与 managed 点
	minifcu:SetFcuSpdDashes(spd_dash >= 1 and 1 or 0)
	minifcu:SetFcuSpdDot(dr_is_spdmgd:Get() >= 1 and 1 or 0)

	-- MT 5 / MT 6 / MT 7：HDG（TRK/FPA 模式下取 INI_TRK_DIAL，与参考档 digi_disp_set_HDG 一致）
	local hdgtrk  = dr_hdgtrk:Get()
	local is_fpa  = (hdgtrk == 1)
	local hdg_val = dr_heading:Get()
	if is_fpa then
		hdg_val = dr_track:Get()
	end
	minifcu:SetFcuHdgValue(math.floor(hdg_val + 0.5))
	minifcu:SetFcuHdgDashes(dr_hdg_dashed:Get() >= 1 and 1 or 0)
	minifcu:SetFcuHdgDot(dr_hdg_dot:Get() >= 1 and 1 or 0)

	-- MT 8 / MT 9：ALT（注册时用 0.01 的比例折算成 ft/100，与参考档同源）
	minifcu:SetFcuAltValue()
	minifcu:SetFcuAltDot(dr_alt_dot:Get() > 0 and 1 or 0)

	-- MT 10 / MT 11 / MT 12：VS 与 FPA 互斥（dashed 优先，其次 TRK/FPA）
	minifcu:SetFcuVsDashes(dr_vs_dashed:Get() >= 1 and 1 or 0)
	if dr_vs_dashed:Get() >= 1 then
		minifcu:SetFcuVsValue(0)
		minifcu:SetFcuFpaValue(0)
	elseif is_fpa then
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

	-- 气压：STD / QNH 标签 / 单位 / 两个值通道（两个值都算，切单位时不会读到上一次的陈旧值）
	local baro_mode = dr_baro_mode:Get() -- (L:XMLVAR_Baro1_Mode)
	local baro_unit = dr_baro_unit:Get() -- (L:XMLVAR_Baro_Selector_HPA_1)：1 = hPa
	local baro_raw  = dr_baro:Get()      -- 已按显示单位折算的显示值
	local is_std    = (baro_mode == 2 or baro_mode == 3) -- 参考档判据：2 或 3 = STD

	minifcu:SetEfisBaroStd1(is_std and 1 or 0)
	minifcu:SetEfisBaroQnnh1(is_std and 0 or 1)
	-- MT 9：1 = inHg（源变量为 1 时表示 hPa）
	minifcu:SetEfisBaroInhgHpaUnit(baro_unit >= 1 and 0 or 1)

	if baro_unit >= 1 then
		-- 源为 hPa/mbar 整数
		minifcu:SetEfisBaro(math.floor(baro_raw + 0.5))
		minifcu:SetEfisBaroInhg(math.floor(baro_raw * 100 / 33.8638895 + 0.5))
	else
		-- 源为 inHg × 100
		minifcu:SetEfisBaroInhg(math.floor(baro_raw + 0.5))
		minifcu:SetEfisBaro(math.floor(baro_raw * 33.8638895 / 100 + 0.5))
	end
end)
