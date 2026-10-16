-- *****************************************************************
-- FlyLuaIO MobiFlight miniFCU (miniFCU + miniEFIS) for MSFS
-- Aerosoft A340-600 (A346)
-- created by Wei Shuai <cpuwolf@gmail.com>
-- *****************************************************************
-- 来源与依据（可追溯）：
--   * 事件名 / L 变量 / B 事件：msfs/data/QFCU_AERO_A346.lua（QFCU 同机型档）
--     每条绑定后的 [Q#] 标注该功能在 QFCU 面板上的 KeyIdx，便于与 QFCU 档逐条对照。
--   * 硬件通道契约：mobiflight/MiniFCU.json（按键 bit 0–46、编码器 bit 47–66、
--     6 个 Output pin、26 条 CustomDevice 通道）。
--   * 通道语义 / 编码器位序：xp/MINIFCU_Toliss.lua（真机 miniFCU 在 X-Plane 上实测）。
-- 编码器位序（沿用 XP 档，勿改）：每轴 4 bit，前 2 bit = 减，后 2 bit = 加。
--   ALT 47/48 减 · 49/50 加；SPD 51/52 · 53/54；HDG 55/56 · 57/58；VS 59/60 · 61/62；BARO 63/64 · 65/66
--
-- ⚠ MSFS2020 / MSFS2024 双分支（判据 = 参考档 msfs/data/QFCU_AERO_A346.lua 的行号 + 分支条件）：
--   参考档里“同一个 QFCU bit 上出现两条 CfgRpn”（一条写 AB_xxx / ASAB_xxx 这类 LVAR 触发标志，
--   一条发 B:AUTOPILOT_xxx / B:INSTRUMENT_xxx 的 Push/Release 事件）**不是无条件共存**，
--   而是逐键成对包在 if 分支里：
--       if MSFS_VERSION == 0 then <L: 触发变量> else <B: 事件> end
--   出现的行号：16–22(bit 0/1)、24–30(bit 2/3)、32–38(bit 4/5)、40–46(bit 6/7)、48–52(bit 8)、
--   55–61(bit 9/10)、64–68(bit 11)、71–75(bit 12)、77–81(bit 13)、83–87(bit 14)、
--   91–97(bit 16/17)、99–105(bit 18/19)、107–113(bit 20/21)、115–121(bit 22/23)、
--   139–157(bit 35–41)、165–171(bit 46/47)、173–179(bit 48/49)、183–189(bit 51/52)、
--   193–203(bit 54/55)、219–238(bit 67–73)、248–254(bit 78/79)。
--   运行时两分支互斥：MSFS_VERSION == 0 → MSFS2020；!= 0 → MSFS2024。
--   因此本档**两个分支都保留**（与参考档一样用 if/else 包住），不存在“后者覆盖前者”。
--   无分支（无条件绑定）的键：bit 15（ALT 100/1000 步长）、24–28（ROSE 模式）、29–34（距离）、
--   42–45（ADF/OFF/VOR 拨杆）、50（气压单位）。
--
-- 已知取舍（待真机验证）：
--   1. 未做断电门控：参考档按 (L:TLS_FCU_AVAILABLE) 关 LCD / 背光（行 318、577–597），
--      miniFCU 硬件无背光 / 熄灭通道，xp/MINIFCU_Toliss.lua 也没做，这里保持一致。
--   2. QFCU 面板有副驾半区，miniFCU 只有一个 EFIS：QFCU 的 51/52/53（副驾气压）与
--      56–79（副驾 EFIS）不移植（参考档行 183–254）。
--   3. bit 25（CHRONO）：参考档（QFCU）没有这个键 —— TODO: 参考档无对应源，先不绑定；
--      将来需要时从同机型 QMPE 档取 H 事件（做法见 MINIFCU_FBW_A320NX.lua 的 CHRONO）。
--   4. MT 9（ALT managed 点）：参考档 digi_disp_set_ALT() 读的源是 (L:TLS_FCU_VS_MANAGED)
--      （行 274），变量名与 ALT 不符，疑似参考档复制粘贴遗留；本档按参考档逐字保留。
--   5. MT 10 / MT 11（VS / FPA）：参考档把符号编码进 QFCU 的 vsmode / vs_trkmode（行 445–473），
--      且 FPA 走 ×1000 定点；miniFCU 的 MT10 / MT11 自带符号、FPA 以“度”为单位
--      （见 MINIFCU_FBW_A320NX.lua），故这里直接送带符号的 (L:TLS_FCU_VS_WINDOW_VALUE)。
--   6. 气压两值都算（切单位不会读到上一次的陈旧值）：参考档只按当前单位取 SetLBaro 的那一个值
--      （行 485–493），本档按 miniFCU 的通道契约同时算 inHg 与 hPa（同 MINIFCU_FBW_A320NX.lua）。
-- *****************************************************************

if ilua_require_msfs() then
	return
end
if ilua_require_aerosoft_a346() then return end

-- Do not remove below lines: hardware detection
local minifcu = com.sim.mf.MiniFCU.Open()
if not minifcu then return end
-- Do not remove above lines: hardware detection

uluaLog('MobiFlight MiniFCU for Aerosoft A346')

-- ===========================================================
-- INPUT：FCU 半区（bit 0–17）

-- SPD/MACH 显示切换 [Q55]（参考档行 199–203：2020 用 L: 触发变量，2024 用 B: Push/Release）
if MSFS_VERSION == 0 then
	minifcu:CfgRpn(0, '1 (>L:AB_AP_SPDMACH_BTN_TRIG)', '0 (>L:AB_AP_SPDMACH_BTN_TRIG)')
else
	minifcu:CfgRpn(0, '1 (>B:AUTOPILOT_AB_AP_SPDMACH_KEY_Push)', '1 (>B:AUTOPILOT_AB_AP_SPDMACH_KEY_Release)')
end
-- HDG/TRK ↔ VS/FPA 切换 [Q54]（参考档行 193–197）
if MSFS_VERSION == 0 then
	minifcu:CfgRpn(1, '1 (>L:AB_AP_HDGTRK_BTN_TRIG)', '0 (>L:AB_AP_HDGTRK_BTN_TRIG)')
else
	minifcu:CfgRpn(1, '1 (>B:AUTOPILOT_AB_AP_HDGTRK_KEY_Push)', '1 (>B:AUTOPILOT_AB_AP_HDGTRK_KEY_Release)')
end
-- AP1 [Q10]（参考档行 55–61）
if MSFS_VERSION == 0 then
	minifcu:CfgRpn(2, '1 (>L:AB_AP_AP1_BTN_TRIG)', '0 (>L:AB_AP_AP1_BTN_TRIG)')
else
	minifcu:CfgRpn(2, '1 (>B:AUTOPILOT_AB_AP_AP1_KEY_Push)', '1 (>B:AUTOPILOT_AB_AP_AP1_KEY_Release)')
end
-- AP2 [Q9]（参考档行 55–61）
if MSFS_VERSION == 0 then
	minifcu:CfgRpn(3, '1 (>L:AB_AP_AP2_BTN_TRIG)', '0 (>L:AB_AP_AP2_BTN_TRIG)')
else
	minifcu:CfgRpn(3, '1 (>B:AUTOPILOT_AB_AP_AP2_KEY_Push)', '1 (>B:AUTOPILOT_AB_AP_AP2_KEY_Release)')
end
-- METRIC ALT [Q14]（参考档行 83–87）
if MSFS_VERSION == 0 then
	minifcu:CfgRpn(4, '1 (>L:AB_AP_METRIC_BTN_TRIG)', '0 (>L:AB_AP_METRIC_BTN_TRIG)')
else
	minifcu:CfgRpn(4, '1 (>B:AUTOPILOT_AB_AP_METRIC_KEY_Push)', '1 (>B:AUTOPILOT_AB_AP_METRIC_KEY_Release)')
end
-- A/THR [Q11]（参考档行 64–68）
if MSFS_VERSION == 0 then
	minifcu:CfgRpn(5, '1 (>L:AB_AP_ATHR_BTN_TRIG)', '0 (>L:AB_AP_ATHR_BTN_TRIG)')
else
	minifcu:CfgRpn(5, '1 (>B:AUTOPILOT_AB_AP_ATHR_KEY_Push)', '1 (>B:AUTOPILOT_AB_AP_ATHR_KEY_Release)')
end
-- EXPED [Q12]（参考档行 71–75：A346 的 EXPED 键即 QFCU 的 ALT 键）
if MSFS_VERSION == 0 then
	minifcu:CfgRpn(6, '1 (>L:AB_AP_ALT_BTN_TRIG)', '0 (>L:AB_AP_ALT_BTN_TRIG)')
else
	minifcu:CfgRpn(6, '1 (>B:AUTOPILOT_AB_AP_ALT_KEY_Push)', '1 (>B:AUTOPILOT_AB_AP_ALT_KEY_Release)')
end
-- LOC [Q8]（参考档行 48–52）
if MSFS_VERSION == 0 then
	minifcu:CfgRpn(7, '1 (>L:AB_AP_LOC_BTN_TRIG)', '0 (>L:AB_AP_LOC_BTN_TRIG)')
else
	minifcu:CfgRpn(7, '1 (>B:AUTOPILOT_AB_AP_LOC_KEY_Push)', '1 (>B:AUTOPILOT_AB_AP_LOC_KEY_Release)')
end
-- APPR [Q13]（参考档行 77–81）
if MSFS_VERSION == 0 then
	minifcu:CfgRpn(8, '1 (>L:AB_AP_APPR_BTN_TRIG)', '0 (>L:AB_AP_APPR_BTN_TRIG)')
else
	minifcu:CfgRpn(8, '1 (>B:AUTOPILOT_AB_AP_APPR_KEY_Push)', '1 (>B:AUTOPILOT_AB_AP_APPR_KEY_Release)')
end
-- SPD PUSH [Q2]（参考档行 24–30：managed / selected）
if MSFS_VERSION == 0 then
	minifcu:CfgRpn(9, '1 (>L:AB_AP_SPDmode)')
else
	minifcu:CfgRpn(9, '1 (>B:AUTOPILOT_Speed_Managed_Mode)')
end
-- SPD PULL [Q3]（参考档行 24–30）
if MSFS_VERSION == 0 then
	minifcu:CfgRpn(10, '-1 (>L:AB_AP_SPDmode)')
else
	minifcu:CfgRpn(10, '1 (>B:AUTOPILOT_Speed_Selected_Mode)')
end
-- HDG PUSH [Q6]（参考档行 40–46）
if MSFS_VERSION == 0 then
	minifcu:CfgRpn(11, '1 (>L:AB_AP_HDGmode)')
else
	minifcu:CfgRpn(11, '1 (>B:AUTOPILOT_Hdg_Managed_Mode)')
end
-- HDG PULL [Q7]（参考档行 40–46）
if MSFS_VERSION == 0 then
	minifcu:CfgRpn(12, '-1 (>L:AB_AP_HDGmode)')
else
	minifcu:CfgRpn(12, '1 (>B:AUTOPILOT_Hdg_Selected_Mode)')
end
-- ALT PUSH [Q18]（参考档行 99–105）
if MSFS_VERSION == 0 then
	minifcu:CfgRpn(13, '1 (>L:AB_AP_ALTmode)')
else
	minifcu:CfgRpn(13, '1 (>B:AUTOPILOT_Alt_Managed_Mode)')
end
-- ALT PULL [Q19]（参考档行 99–105）
if MSFS_VERSION == 0 then
	minifcu:CfgRpn(14, '-1 (>L:AB_AP_ALTmode)')
else
	minifcu:CfgRpn(14, '1 (>B:AUTOPILOT_Alt_Selected_Mode)')
end
-- VS PUSH [Q22]（参考档行 115–121）
if MSFS_VERSION == 0 then
	minifcu:CfgRpn(15, '1 (>L:AB_AP_VSmode)')
else
	minifcu:CfgRpn(15, '1 (>B:AUTOPILOT_VS_Managed_Mode)')
end
-- VS PULL [Q23]（参考档行 115–121）
if MSFS_VERSION == 0 then
	minifcu:CfgRpn(16, '-1 (>L:AB_AP_VSmode)')
else
	minifcu:CfgRpn(16, '1 (>B:AUTOPILOT_VS_Selected_Mode)')
end
-- ALT 100/1000 [Q15]：miniFCU 是瞬时按键 —— 按住 = 1000 ft 步长，松开回 100 ft。
--   参考档行 89 本来就是 press=1 / release=0（不是拨杆语义），故逐字保留同样的变量名。
minifcu:CfgRpn(17, '0 (>L:ASAB_AB_AP_ALTSTEP)', '1 (>L:ASAB_AB_AP_ALTSTEP)')

-- ===========================================================
-- INPUT：EFIS 半区机长侧（bit 18–46）

-- 导航点过滤键 [Q35–Q39]（参考档行 139–157）
if MSFS_VERSION == 0 then
	minifcu:CfgRpn(18, '1 (>L:AB_MPL_ND_CSTR_TRIG)', '0 (>L:AB_MPL_ND_CSTR_TRIG)') -- CSTR
else
	minifcu:CfgRpn(18, '1 (>B:INSTRUMENT_AB_MPL_ND_CSTR_KEY_Push)', '1 (>B:INSTRUMENT_AB_MPL_ND_CSTR_KEY_Release)') -- CSTR
end
if MSFS_VERSION == 0 then
	minifcu:CfgRpn(19, '1 (>L:AB_MPL_ND_WPT_TRIG)', '0 (>L:AB_MPL_ND_WPT_TRIG)') -- WPT
else
	minifcu:CfgRpn(19, '1 (>B:INSTRUMENT_AB_MPL_ND_WPT_KEY_Push)', '1 (>B:INSTRUMENT_AB_MPL_ND_WPT_KEY_Release)') -- WPT
end
if MSFS_VERSION == 0 then
	minifcu:CfgRpn(20, '1 (>L:AB_MPL_ND_VOR_TRIG)', '0 (>L:AB_MPL_ND_VOR_TRIG)') -- VOR D
else
	minifcu:CfgRpn(20, '1 (>B:INSTRUMENT_AB_MPL_ND_VOR_KEY_Push)', '1 (>B:INSTRUMENT_AB_MPL_ND_VOR_KEY_Release)') -- VOR D
end
if MSFS_VERSION == 0 then
	minifcu:CfgRpn(21, '1 (>L:AB_MPL_ND_NDB_TRIG)', '0 (>L:AB_MPL_ND_NDB_TRIG)') -- NDB
else
	minifcu:CfgRpn(21, '1 (>B:INSTRUMENT_AB_MPL_ND_NDB_KEY_Push)', '1 (>B:INSTRUMENT_AB_MPL_ND_NDB_KEY_Release)') -- NDB
end
if MSFS_VERSION == 0 then
	minifcu:CfgRpn(22, '1 (>L:AB_MPL_ND_ARPT_TRIG)', '0 (>L:AB_MPL_ND_ARPT_TRIG)') -- ARPT
else
	minifcu:CfgRpn(22, '1 (>B:INSTRUMENT_AB_MPL_ND_ARPT_KEY_Push)', '1 (>B:INSTRUMENT_AB_MPL_ND_ARPT_KEY_Release)') -- ARPT
end
-- FD / LS [Q40 / Q41]（参考档行 139–157：机长 FD / ILS 键）
if MSFS_VERSION == 0 then
	minifcu:CfgRpn(23, '1 (>L:AB_MPL_CPT_FD_BTN_TRIG)', '0 (>L:AB_MPL_CPT_FD_BTN_TRIG)') -- FD
else
	minifcu:CfgRpn(23, '1 (>B:INSTRUMENT_AB_MPL_CPT_FD_KEY_Push)', '1 (>B:INSTRUMENT_AB_MPL_CPT_FD_KEY_Release)') -- FD
end
if MSFS_VERSION == 0 then
	minifcu:CfgRpn(24, '1 (>L:AB_MPL_CPT_ILS_BTN_TRIG)', '0 (>L:AB_MPL_CPT_ILS_BTN_TRIG)') -- LS
else
	minifcu:CfgRpn(24, '1 (>B:INSTRUMENT_AB_MPL_CPT_ILS_KEY_Push)', '1 (>B:INSTRUMENT_AB_MPL_CPT_ILS_KEY_Release)') -- LS
end
-- bit 25 CHRONO：参考档（QFCU A346）无此键 —— TODO: 无对应源，先不绑定（见文件头取舍 3）

-- ROSE 模式键 [Q24–Q28]：LS/VOR/NAV/ARC/PLN → (L:AB_MPL_ND_Mode) 0–4（参考档行 124–128）
minifcu:CfgRpn(26, '0 (>L:AB_MPL_ND_Mode)') -- LS
minifcu:CfgRpn(27, '1 (>L:AB_MPL_ND_Mode)') -- VOR
minifcu:CfgRpn(28, '2 (>L:AB_MPL_ND_Mode)') -- NAV
minifcu:CfgRpn(29, '3 (>L:AB_MPL_ND_Mode)') -- ARC
minifcu:CfgRpn(30, '4 (>L:AB_MPL_ND_Mode)') -- PLN

-- 距离 [Q29–Q34]：10/20/40/80/160/320 → (L:AB_MPL_ND_Range) 0–5（参考档行 131–136）
minifcu:CfgRpn(31, '0 (>L:AB_MPL_ND_Range)') -- 10
minifcu:CfgRpn(32, '1 (>L:AB_MPL_ND_Range)') -- 20
minifcu:CfgRpn(33, '2 (>L:AB_MPL_ND_Range)') -- 40
minifcu:CfgRpn(34, '3 (>L:AB_MPL_ND_Range)') -- 80
minifcu:CfgRpn(35, '4 (>L:AB_MPL_ND_Range)') -- 160
minifcu:CfgRpn(36, '5 (>L:AB_MPL_ND_Range)') -- 320

-- VOR/ADF 选择 1 与 2 [Q42–Q45]（参考档行 159–163）
--   QFCU 是两档拨杆：42/44 按下 = ADF，松开回中位 1（OFF）；43/45 按下 = 0（VOR）。
--   miniFCU 是 ADF / OFF / VOR 三个独立按键 → 每个键只发一个明确值，不照抄 press/release：
--   (L:AB_MPL_ND_ARROW1) 取值：2 = ADF，1 = OFF（参考档 42/43 的 release 值），0 = VOR。
minifcu:CfgRpn(37, '2 (>L:AB_MPL_ND_ARROW1)') -- ADF 1（Q42 press）
minifcu:CfgRpn(38, '1 (>L:AB_MPL_ND_ARROW1)') -- OFF 1（Q42/Q43 release 中位）
minifcu:CfgRpn(39, '0 (>L:AB_MPL_ND_ARROW1)') -- VOR 1（Q43 press）
minifcu:CfgRpn(40, '2 (>L:AB_MPL_ND_ARROW2)') -- ADF 2（Q44 press）
minifcu:CfgRpn(41, '1 (>L:AB_MPL_ND_ARROW2)') -- OFF 2（Q44/Q45 release 中位）
minifcu:CfgRpn(42, '0 (>L:AB_MPL_ND_ARROW2)') -- VOR 2（Q45 press）

-- 气压单位 [Q50]（参考档行 181：press = 1、release = 0）
--   (L:AB_MPL_BARO_CPT_UNIT)：1 = inHg，0 = hPa（依据参考档行 488/491 的 SetLBaro 分支）。
--   QFCU 是单键拨杆，miniFCU 是两个独立按键 → 43 只发 release 值（hPa），44 只发 press 值（inHg）。
minifcu:CfgRpn(43, '0 (>L:AB_MPL_BARO_CPT_UNIT)') -- HPA
minifcu:CfgRpn(44, '1 (>L:AB_MPL_BARO_CPT_UNIT)') -- INHG
-- 气压旋钮拉 / 按 [Q49 / Q48]
--   参考档 2020 分支用 (L:AB_MPL_Baro_CPT_PushPull)（-1 = 按、1 = 拉），
--   2024 分支分别发 QNH / STD 的 B 事件；分支条件同参考档行 173–179。
if MSFS_VERSION == 0 then
	minifcu:CfgRpn(45, '1 (>L:AB_MPL_Baro_CPT_PushPull)') -- PULL
else
	minifcu:CfgRpn(45, '1 (>B:AUTOPILOT_Baro_1_STD_Mode)') -- PULL
end
if MSFS_VERSION == 0 then
	minifcu:CfgRpn(46, '-1 (>L:AB_MPL_Baro_CPT_PushPull)') -- PUSH
else
	minifcu:CfgRpn(46, '1 (>B:AUTOPILOT_Baro_1_QNH_Mode)') -- PUSH
end

-- ===========================================================
-- INPUT：编码器（bit 47–66）

-- ALT 编码器 [Q16 / Q17]（参考档行 91–97）
if MSFS_VERSION == 0 then
	minifcu:CfgRpn(47, '(L:ASAB_FCU_ALT_DELTA) -- (>L:ASAB_FCU_ALT_DELTA)')
	minifcu:CfgRpn(48, '(L:ASAB_FCU_ALT_DELTA) -- (>L:ASAB_FCU_ALT_DELTA)')
	minifcu:CfgRpn(49, '(L:ASAB_FCU_ALT_DELTA) ++ (>L:ASAB_FCU_ALT_DELTA)')
	minifcu:CfgRpn(50, '(L:ASAB_FCU_ALT_DELTA) ++ (>L:ASAB_FCU_ALT_DELTA)')
else
	minifcu:CfgRpn(47, '1 (>B:AUTOPILOT_ALT_Dec)')
	minifcu:CfgRpn(48, '1 (>B:AUTOPILOT_ALT_Dec)')
	minifcu:CfgRpn(49, '1 (>B:AUTOPILOT_ALT_Inc)')
	minifcu:CfgRpn(50, '1 (>B:AUTOPILOT_ALT_Inc)')
end

-- SPD 编码器 [Q0 / Q1]（参考档行 16–22）
if MSFS_VERSION == 0 then
	minifcu:CfgRpn(51, '(L:ASAB_FCU_SPEED_DELTA) -- (>L:ASAB_FCU_SPEED_DELTA)')
	minifcu:CfgRpn(52, '(L:ASAB_FCU_SPEED_DELTA) -- (>L:ASAB_FCU_SPEED_DELTA)')
	minifcu:CfgRpn(53, '(L:ASAB_FCU_SPEED_DELTA) ++ (>L:ASAB_FCU_SPEED_DELTA)')
	minifcu:CfgRpn(54, '(L:ASAB_FCU_SPEED_DELTA) ++ (>L:ASAB_FCU_SPEED_DELTA)')
else
	minifcu:CfgRpn(51, '1 (>B:AUTOPILOT_SPEED_Dec)')
	minifcu:CfgRpn(52, '1 (>B:AUTOPILOT_SPEED_Dec)')
	minifcu:CfgRpn(53, '1 (>B:AUTOPILOT_SPEED_Inc)')
	minifcu:CfgRpn(54, '1 (>B:AUTOPILOT_SPEED_Inc)')
end

-- HDG 编码器 [Q4 / Q5]（参考档行 32–38）
if MSFS_VERSION == 0 then
	minifcu:CfgRpn(55, '(L:ASAB_FCU_HDG_DELTA) -- (>L:ASAB_FCU_HDG_DELTA)')
	minifcu:CfgRpn(56, '(L:ASAB_FCU_HDG_DELTA) -- (>L:ASAB_FCU_HDG_DELTA)')
	minifcu:CfgRpn(57, '(L:ASAB_FCU_HDG_DELTA) ++ (>L:ASAB_FCU_HDG_DELTA)')
	minifcu:CfgRpn(58, '(L:ASAB_FCU_HDG_DELTA) ++ (>L:ASAB_FCU_HDG_DELTA)')
else
	minifcu:CfgRpn(55, '1 (>B:AUTOPILOT_HDG_Dec)')
	minifcu:CfgRpn(56, '1 (>B:AUTOPILOT_HDG_Dec)')
	minifcu:CfgRpn(57, '1 (>B:AUTOPILOT_HDG_Inc)')
	minifcu:CfgRpn(58, '1 (>B:AUTOPILOT_HDG_Inc)')
end

-- VS 编码器 [Q20 / Q21]（参考档行 107–113）
if MSFS_VERSION == 0 then
	minifcu:CfgRpn(59, '(L:ASAB_FCU_VS_DELTA) -- (>L:ASAB_FCU_VS_DELTA)')
	minifcu:CfgRpn(60, '(L:ASAB_FCU_VS_DELTA) -- (>L:ASAB_FCU_VS_DELTA)')
	minifcu:CfgRpn(61, '(L:ASAB_FCU_VS_DELTA) ++ (>L:ASAB_FCU_VS_DELTA)')
	minifcu:CfgRpn(62, '(L:ASAB_FCU_VS_DELTA) ++ (>L:ASAB_FCU_VS_DELTA)')
else
	minifcu:CfgRpn(59, '1 (>B:AUTOPILOT_VS_Dec)')
	minifcu:CfgRpn(60, '1 (>B:AUTOPILOT_VS_Dec)')
	minifcu:CfgRpn(61, '1 (>B:AUTOPILOT_VS_Inc)')
	minifcu:CfgRpn(62, '1 (>B:AUTOPILOT_VS_Inc)')
end

-- BARO 编码器（机长侧）[Q46 / Q47]（参考档行 165–171）
--   2020 分支：旋钮一步 = 20/36（参考档原式，按 Number 类型读出后回写）
if MSFS_VERSION == 0 then
	minifcu:CfgRpn(63, '(L:AB_MPL_Baro_CPT_Rotation, Number) 20 36 / - (>L:AB_MPL_Baro_CPT_Rotation)')
	minifcu:CfgRpn(64, '(L:AB_MPL_Baro_CPT_Rotation, Number) 20 36 / - (>L:AB_MPL_Baro_CPT_Rotation)')
	minifcu:CfgRpn(65, '(L:AB_MPL_Baro_CPT_Rotation, Number) 20 36 / + (>L:AB_MPL_Baro_CPT_Rotation)')
	minifcu:CfgRpn(66, '(L:AB_MPL_Baro_CPT_Rotation, Number) 20 36 / + (>L:AB_MPL_Baro_CPT_Rotation)')
else
	minifcu:CfgRpn(63, '1 (>B:AUTOPILOT_Baro_1_Dec)')
	minifcu:CfgRpn(64, '1 (>B:AUTOPILOT_Baro_1_Dec)')
	minifcu:CfgRpn(65, '1 (>B:AUTOPILOT_Baro_1_Inc)')
	minifcu:CfgRpn(66, '1 (>B:AUTOPILOT_Baro_1_Inc)')
end

-- ===========================================================
-- 显示源（帧循环里直接读；iDataRef:New 找不到路径会返回 nil，统一用 safe_get 兜底）

local function safe_get(dr)
	if dr == nil then
		return 0
	end
	return dr:Get()
end

-- FCU：SPD / MACH [Q0–Q3]（参考档行 260–277）
local dr_spd_win  = iDataRef:New('(L:TLS_FCU_SPD_WINDOW_VALUE)') -- 窗口值：kts 或 马赫（0.xx）；<0 表示 managed 无预设
local dr_spd_mgd  = iDataRef:New('(L:TLS_FCU_SPD_MANAGED)')     -- managed（虚点）
-- 马赫判定沿用参考档行 263 的原式：-1 <= v < 1 → Mach
local dr_is_mach  = iDataRef:New('(L:TLS_FCU_SPD_WINDOW_VALUE) -1 >= (L:TLS_FCU_SPD_WINDOW_VALUE) 1 < *')

-- FCU：HDG / TRK [Q4–Q7]（参考档行 264–266、277–278）
local dr_hdg_win  = iDataRef:New('(L:TLS_FCU_HDG_WINDOW_VALUE)')
local dr_hdg_mgd  = iDataRef:New('(L:TLS_FCU_HDG_MANAGED)')
local dr_trkfpa   = iDataRef:New('(L:TLS_FCU_TRK_FPA_MODE)') -- 参考档行 408：== 1 → TRK

-- FCU：ALT [Q15–Q19]（参考档行 268、274）
--   ALT 值通道的源在下面 GetFcuAltValue() 注册（scale 0.01 = ft/100），这里只留 managed 点
local dr_alt_dot  = iDataRef:New('(L:TLS_FCU_VS_MANAGED)')       -- 参考档原式（疑似复制遗留，见文件头取舍 4）

-- FCU：VS / FPA [Q20–Q23]（参考档行 270–271、275）
local dr_vs_win   = iDataRef:New('(L:TLS_FCU_VS_WINDOW_VALUE)') -- fpm 或 FPA 度；-100000 = 虚线（参考档行 445）

-- EFIS 机长侧气压 [Q46–Q50]（参考档行 288–292、485–493）
local dr_baro_val  = iDataRef:New('(L:TLS_EFIS_BARO_VALUE_CAPT)') -- 当前单位下的显示值；== 0 视为 STD（参考档行 485）
local dr_baro_unit = iDataRef:New('(L:AB_MPL_BARO_CPT_UNIT)')     -- 1 = inHg，0 = hPa（参考档行 488/491）

-- ===========================================================
-- OUTPUT：6 个 LED pin（参考档行 305–310）
minifcu:GetAp1('(L:AB_AP_AP1_LIGHT_ON)')
minifcu:GetAp2('(L:AB_AP_AP2_LIGHT_ON)')
minifcu:GetAthr('(L:AB_AP_ATHR_LIGHT_ON)')
minifcu:GetLoc('(L:AB_AP_LOC_LIGHT_ON)')
minifcu:GetAppr('(L:AB_AP_APPR_LIGHT_ON)')
minifcu:GetExped('(L:AB_AP_ALT_LIGHT_ON)') -- A346 的 EXPED 键 = QFCU 的 ALT 键灯

-- ===========================================================
-- OUTPUT：miniFCU LCD（14 FCU + 12 EFIS 通道全部保留）

-- MT 0 SPD 值（kts）
minifcu:GetFcuSpdValue('(L:TLS_FCU_SPD_WINDOW_VALUE)')
-- MT 1 MACH 值（马赫 × 100）
minifcu:GetFcuMachValue('(L:TLS_FCU_SPD_WINDOW_VALUE)', 100)
-- MT 2 SPD/MACH 模式（1 = mach）
minifcu:GetFcuSpdMachMode('(L:TLS_FCU_SPD_WINDOW_VALUE) -1 >= (L:TLS_FCU_SPD_WINDOW_VALUE) 1 < *')
-- MT 3 SPD dashed / MT 4 SPD managed 点
minifcu:GetFcuSpdDashes('(L:TLS_FCU_SPD_WINDOW_VALUE)')
minifcu:GetFcuSpdDot('(L:TLS_FCU_SPD_MANAGED)')
-- MT 5 / MT 6 / MT 7：HDG 值 / dashed / managed 点
minifcu:GetFcuHdgValue('(L:TLS_FCU_HDG_WINDOW_VALUE)')
minifcu:GetFcuHdgDashes('(L:TLS_FCU_HDG_WINDOW_VALUE)')
minifcu:GetFcuHdgDot('(L:TLS_FCU_HDG_MANAGED)')
-- MT 8 ALT 值（ft / 100）
minifcu:GetFcuAltValue('(L:TLS_FCU_ALT_WINDOW_VALUE)', 0.01)
-- MT 9 ALT managed 点
minifcu:GetFcuAltDot('(L:TLS_FCU_VS_MANAGED)')
-- MT 10 VS 值（fpm，带符号）/ MT 11 FPA 值（度）
minifcu:GetFcuVsValue('(L:TLS_FCU_VS_WINDOW_VALUE)')
minifcu:GetFcuFpaValue('(L:TLS_FCU_VS_WINDOW_VALUE)')
-- MT 12 VS dashed
minifcu:GetFcuVsDashes('(L:TLS_FCU_VS_WINDOW_VALUE)')
-- MT 13 HDG/TRK 模式（1 = TRK）
minifcu:GetFcuHdgTrkMode('(L:TLS_FCU_TRK_FPA_MODE)')

-- MT 0 CSTR / MT 1 WPT / MT 2 VORD / MT 3 NDB / MT 4 ARPT（参考档行 280–284 的灯变量）
minifcu:GetEfisCstr('(L:AB_MPL_ND_CSTR_LIGHT_ON)')
minifcu:GetEfisWpt('(L:AB_MPL_ND_WPT_LIGHT_ON)')
minifcu:GetEfisVord('(L:AB_MPL_ND_VOR_LIGHT_ON)')
minifcu:GetEfisNdb('(L:AB_MPL_ND_NDB_LIGHT_ON)')
minifcu:GetEfisArpt('(L:AB_MPL_ND_ARPT_LIGHT_ON)')
-- MT 5 FD / MT 6 LS（参考档行 285–286）
minifcu:GetFcuFdValue('(L:AB_MPL_CPT_FD_LIGHT_ON)')
minifcu:GetFcuLsValue('(L:AB_MPL_CPT_ILS_LIGHT_ON)')
-- MT 7 QNH 标签 / MT 8 STD 标志（源：TLS_EFIS_BARO_VALUE_CAPT，帧循环里判定）
minifcu:GetEfisBaroQnnh1('(L:TLS_EFIS_BARO_VALUE_CAPT)')
minifcu:GetEfisBaroStd1('(L:TLS_EFIS_BARO_VALUE_CAPT)')
-- MT 9 inHg/hPa（1 = inHg；源 AB_MPL_BARO_CPT_UNIT，参考档行 490）
minifcu:GetEfisBaroInhgHpaUnit('(L:AB_MPL_BARO_CPT_UNIT)')
-- MT 10 BARO inHg（×100）/ MT 11 BARO hPa（值在帧循环里换算后写入）
minifcu:GetEfisBaroInhg('(L:TLS_EFIS_BARO_VALUE_CAPT)')
minifcu:GetEfisBaro('(L:TLS_EFIS_BARO_VALUE_CAPT)')

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
	local spd_win  = safe_get(dr_spd_win)
	local spd_mgd  = safe_get(dr_spd_mgd)
	local is_mach  = safe_get(dr_is_mach)
	local hdg_win  = safe_get(dr_hdg_win)
	local hdg_mgd  = safe_get(dr_hdg_mgd)
	local trkfpa   = safe_get(dr_trkfpa)
	local alt_dot  = safe_get(dr_alt_dot)
	local vs_win   = safe_get(dr_vs_win)

	-- MT 3：SPD dashed —— 判据照抄参考档 digi_disp_set_SPD()（行 364–396）：
	--   managed 时窗口值 < 0 = 无预设（虚线）；非 managed 时窗口值 == 1 = 虚线
	local spd_dash = 0
	if spd_mgd == 1 then
		if spd_win < 0 then
			spd_dash = 1
		end
	else
		if spd_win == 1 then
			spd_dash = 1
		end
	end

	-- MT 2：SPD/MACH 模式
	minifcu:SetFcuSpdMachMode(is_mach == 1 and 1 or 0)

	-- MT 0 / MT 1：SPD 值（kts）与 MACH 值（×100），互斥且虚线时置 0
	if spd_dash == 1 then
		minifcu:SetFcuSpdValue(0)
		minifcu:SetFcuMachValue(0)
	elseif is_mach == 1 then
		-- 参考档行 387：mach 先 +0.005 再送通道；这里同样加 0.005 后取 ×100 整数
		minifcu:SetFcuSpdValue(0)
		minifcu:SetFcuMachValue(math.floor((spd_win + 0.005) * 100 + 0.5))
	elseif spd_mgd == 1 then
		-- 参考档行 377：managed 且非虚线时显示预设值，直接 floor（不 +0.5）
		minifcu:SetFcuSpdValue(math.floor(spd_win))
		minifcu:SetFcuMachValue(0)
	else
		-- 参考档行 391：普通模式 floor(v + 0.5)
		minifcu:SetFcuSpdValue(math.floor(spd_win + 0.5))
		minifcu:SetFcuMachValue(0)
	end

	-- MT 3 / MT 4：dashed 与 managed 点（虚线时不留点，与参考档行 364–380 一致）
	minifcu:SetFcuSpdDashes(spd_dash)
	minifcu:SetFcuSpdDot()

	-- MT 5 / MT 6 / MT 7：HDG（判据照抄参考档 digi_disp_set_HDG()，行 398–427）
	--   参考档在 TRK/FPA 模式下把 heading 换成 track，但两者读的是同一变量
	--   (L:TLS_FCU_HDG_WINDOW_VALUE)（行 264–265），故这里不需要额外取值。
	local hdg_dash = 0
	if hdg_mgd == 1 then
		if hdg_win < 0 then
			hdg_dash = 1
		end
	else
		if hdg_win == 1 then
			hdg_dash = 1
		end
	end
	if hdg_dash == 1 then
		minifcu:SetFcuHdgValue(0)
	else
		minifcu:SetFcuHdgValue(math.floor(hdg_win))
	end
	minifcu:SetFcuHdgDashes(hdg_dash)
	minifcu:SetFcuHdgDot()
	-- MT 13：HDG/TRK 模式（参考档行 408：== 1 → TRK）
	minifcu:SetFcuHdgTrkMode(trkfpa == 1 and 1 or 0)

	-- MT 8 / MT 9：ALT（参考档 digi_disp_set_ALT() 行 428–432：altdot > 0 → 点灯）
	minifcu:SetFcuAltValue()
	minifcu:SetFcuAltDot(alt_dot > 0 and 1 or 0)

	-- MT 12：VS dashed（参考档行 445：窗口值 == -100000 = 虚线）
	local vs_dash = (vs_win == -100000) and 1 or 0
	minifcu:SetFcuVsDashes(vs_dash)
	-- MT 10 / MT 11：VS 与 FPA 互斥（参考档行 446–472：TRK 模式走 FPA，否则走 VS）
	if vs_dash == 1 then
		minifcu:SetFcuVsValue(0)
		minifcu:SetFcuFpaValue(0)
	elseif trkfpa == 1 then
		minifcu:SetFcuVsValue(0)
		minifcu:SetFcuFpaValue(vs_win)
	else
		minifcu:SetFcuVsValue(vs_win)
		minifcu:SetFcuFpaValue(0)
	end

	-- ---- EFIS 半区 ----
	minifcu:SetEfisCstr()
	minifcu:SetEfisWpt()
	minifcu:SetEfisVord()
	minifcu:SetEfisNdb()
	minifcu:SetEfisArpt()
	minifcu:SetFcuFdValue()
	minifcu:SetFcuLsValue()

	-- 气压：STD / QNH 标签 / 单位 / 两个值通道
	--   STD 判据照抄参考档行 485（源变量 == 0 → STD，此时 SetLBaro(3) 显示 STD）；
	--   单位判据照抄参考档行 488/491（0 = hPa：原值即 hPa；非 0 = inHg：原值即 inHg × 100）。
	local baro_val  = safe_get(dr_baro_val)
	local baro_unit = safe_get(dr_baro_unit)
	local is_std    = (baro_val == 0)

	minifcu:SetEfisBaroStd1(is_std and 1 or 0)
	minifcu:SetEfisBaroQnnh1(is_std and 0 or 1)
	minifcu:SetEfisBaroInhgHpaUnit(baro_unit >= 1 and 1 or 0)

	-- 两个值都算，切单位时不会读到上一次的陈旧值（取同 MINIFCU_FBW_A320NX.lua 的换算方式）
	if baro_unit >= 1 then
		minifcu:SetEfisBaroInhg(math.floor(baro_val * 100 + 0.5))
		minifcu:SetEfisBaro(math.floor(baro_val * 33.8638895 + 0.5))
	else
		minifcu:SetEfisBaro(math.floor(baro_val + 0.5))
		minifcu:SetEfisBaroInhg(math.floor(baro_val * 100 / 33.8638895 + 0.5))
	end
end)
