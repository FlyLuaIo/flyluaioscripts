-- *****************************************************************
-- FlyLuaIO MobiFlight miniFCU (miniFCU + miniEFIS) for MSFS
-- Fenix A319 / A320 / A321（FNX320 家族）—— 只移植 QFCU 的 EFIS1（机长）半区
-- created by Wei Shuai <cpuwolf@gmail.com>
-- *****************************************************************
-- 来源与依据（可追溯）：
--   * B 事件名 / L 变量：msfs/data/QFCU_FNX_A3XX.lua（QFCU 同机型档，MSFS 实测通过），
--     每条绑定后的 [Q#] 标注该功能在 QFCU 面板上的 KeyIdx，便于与 QFCU 档逐条对照。
--   * 硬件通道契约：mobiflight/MiniFCU.json（按键 bit 0–46、编码器 bit 47–66、
--     6 个 Output pin、26 条 CustomDevice 通道）。
--   * 通道语义 / 编码器位序：xp/MINIFCU_Toliss.lua（真机 miniFCU 在 X-Plane 上手工调过并实测）。
-- 编码器位序（沿用 XP 档，勿改）：每轴 4 bit，前 2 bit = 减，后 2 bit = 加。
--   ALT 47/48 减 · 49/50 加；SPD 51/52 · 53/54；HDG 55/56 · 57/58；VS 59/60 · 61/62；BARO 63/64 · 65/66
-- Fenix 侧语义判据（全部出自参考档 msfs/data/QFCU_FNX_A3XX.lua，勿改）：
--   * 按键全部是 B 事件：1 (>B:FNX320_Input_Knob_PushPull_E_FCU_*)，与 QFCU 档逐字一致。
--   * S_FCU_* 是机模的开关状态量（按下写 1 / 松开写 0），QFCU 档用 CfgRpn(press, release) 成对写。
--   * L:S_FCU_EFIS1_BARO_MODE：0 = inHg，1 = hPa。
--     判据：QFCU 档注释 "-- HPA:1 inHG:0"，且帧循环里 `if qfcu_c_barounit == 1 then -- hpa mode: 1023`；
--     与 msfs/WWFCU_FNX.lua 的 "-- Fenix: 0 = inHg, 1 = hPa" 一致。
--   * L:I_FCU_EFIS1_QNH：1 = QNH（非 STD），0 = STD。
--     判据：QFCU 档 `qfcu_c_barostd = 1 - qfcu_c_barostd; if qfcu_c_barostd == 1 then -- std`，
--     以及 LED 段里 I_FCU_EFIS1_QNH == 0 时 QNH 与 QFE 灯同时熄灭（即 STD）。
--   * L:N_FCU_EFIS1_BARO_INCH 恒为 inHg：QFCU 档 hPa 分支由它 × 33.8638895 得到 hPa，
--     inHg 分支由它 × 100 得到 4 位数，故 MT10 / MT11 两个值都由它现算。
--   * L:N_FCU_SPEED：SPD 模式 = kts，MACH 模式 = 马赫（QFCU 档按 L:I_FCU_SPEED_MODE 分流）；
--     L:N_FCU_VS：VS 模式 = fpm，FPA 模式 = FPA×1000（QFCU 档同一条数据同时喂 VS / TRK 两个通道，
--     且注释写明 TRK 通道 "need 0.8*1000=800"；msfs/WWFCU_FNX.lua 也是 vs / 100 后按 2 位显示）
--     → MT10 直用原值（fpm），MT11 用 GetFcuFpaValue(path, 1)（通道量纲就是 FPA×1000）。
-- 已知取舍（待真机验证）：
--   1. 未做断电门控：QFCU 档在 FCU 掉电/亮度归零时会清屏（digi_disp_powoff_*），
--      miniFCU 硬件没有背光/熄灭通道，XP 档也没做，这里保持一致。
--   2. bit 25（CHRONO）：QFCU 面板无此键，参考档里也没有可用的计时器事件 → 不绑定（TODO）。
--   3. QFCU 面板有两个 EFIS 半区（机长 / 副驾），miniFCU 只有机长半区，故 QFCU 的
--      51/52/53（副驾气压）与 56–79（副驾 EFIS）不移植；I_FCU_EFIS2_* / S_FCU_EFIS2_* 一概不引用。
--   4. ALT 100/1000：QFCU 是拨杆（按下 = 0 → 100 ft，松开 = 1 → 1000 ft），miniFCU 是瞬时按键 ——
--      按住 = 1000 ft 步长，松开回 100 ft，所以 press / release 两个值对调，变量名不变。
--   5. ADF/OFF/VOR 与 BARO 单位：QFCU 是两档拨杆（按下 / 松开各一个值），miniFCU 是三个 / 两个
--      独立按键 → 只发按下。L:S_FCU_EFIS1_NAV1 与 _NAV2 的三态 = 0 ADF / 1 中间位(OFF) / 2 VOR
--      （QFCU 档 42/43 = NAV1、44/45 = NAV2，松开值都是 1 = OFF）；
--      BARO 单位按 miniFCU 键名分配：bit 43（HPA 键）= 1，bit 44（INHG 键）= 0
--      （与 xp/MINIFCU_Toliss.lua 的 43 = hPa / 44 = inHg 是同一约定）。
--   6. 编码器按 MSFS 版本分支（参考档同款）：MSFS2024 用机模的 _Knob_Dec / _Knob_Inc 分向事件；
--      MSFS2020 该版本只有带增量的 "Knob" 事件，则把 ±增量直接当参数发。⚠ CfgEnc 在 MF 设备上
--      不可用（真机验证），两个分支都用逐 bit 的 CfgRpn。细节见编码器那一节。
-- *****************************************************************

if ilua_require_msfs() then
	return
end
if ilua_require_fenix_a320() then return end

-- Do not remove below lines: hardware detection
local minifcu = com.sim.mf.MiniFCU.Open()
if not minifcu then return end
-- Do not remove above lines: hardware detection

uluaLog('MobiFlight MiniFCU for Fenix A3xx')

-- ===========================================================
-- INPUT：FCU 半区（bit 0–17）

-- SPD/MACH 显示切换 [Q55]
minifcu:CfgRpn(0, '1 (>L:S_FCU_SPD_MACH)', '0 (>L:S_FCU_SPD_MACH)')
-- HDG/TRK ↔ VS/FPA 切换 [Q54]
minifcu:CfgRpn(1, '1 (>L:S_FCU_HDGVS_TRKFPA)', '0 (>L:S_FCU_HDGVS_TRKFPA)')
-- AP1 [Q10]
minifcu:CfgRpn(2, '1 (>L:S_FCU_AP1)', '0 (>L:S_FCU_AP1)')
-- AP2 [Q9]
minifcu:CfgRpn(3, '1 (>L:S_FCU_AP2)', '0 (>L:S_FCU_AP2)')
-- METRIC ALT [Q14]
minifcu:CfgRpn(4, '1 (>L:S_FCU_METRIC_ALT)', '0 (>L:S_FCU_METRIC_ALT)')
-- A/THR [Q11]
minifcu:CfgRpn(5, '1 (>L:S_FCU_ATHR)', '0 (>L:S_FCU_ATHR)')
-- EXPED [Q12]
minifcu:CfgRpn(6, '1 (>L:S_FCU_EXPED)', '0 (>L:S_FCU_EXPED)')
-- LOC [Q8]
minifcu:CfgRpn(7, '1 (>L:S_FCU_LOC)', '0 (>L:S_FCU_LOC)')
-- APPR [Q13]
minifcu:CfgRpn(8, '1 (>L:S_FCU_APPR)', '0 (>L:S_FCU_APPR)')
-- SPD PUSH / PULL [Q2 / Q3]：QFCU 档用 CfgVal(B 事件, 1, 0)，miniFCU 是同一类 B 事件注入，逐字照抄
minifcu:CfgVal(9, 'B:FNX320_Input_Knob_PushPull_E_FCU_SPEED_Push', 1, 0)
minifcu:CfgVal(10, 'B:FNX320_Input_Knob_PushPull_E_FCU_SPEED_Pull', 1, 0)
-- HDG PUSH / PULL [Q6 / Q7]
minifcu:CfgVal(11, 'B:FNX320_Input_Knob_PushPull_E_FCU_HEADING_Push', 1, 0)
minifcu:CfgVal(12, 'B:FNX320_Input_Knob_PushPull_E_FCU_HEADING_Pull', 1, 0)
-- ALT PUSH / PULL [Q18 / Q19]
minifcu:CfgVal(13, 'B:FNX320_Input_Knob_PushPull_E_FCU_ALTITUDE_Push', 1, 0)
minifcu:CfgVal(14, 'B:FNX320_Input_Knob_PushPull_E_FCU_ALTITUDE_Pull', 1, 0)
-- VS PUSH / PULL [Q22 / Q23]
minifcu:CfgVal(15, 'B:FNX320_Input_Knob_PushPull_E_FCU_VS_Push', 1, 0)
minifcu:CfgVal(16, 'B:FNX320_Input_Knob_PushPull_E_FCU_VS_Pull', 1, 0)
-- ALT 100/1000 [Q15]：miniFCU 是瞬时按键 —— 按住 = 1000 ft 步长，松开回 100 ft
--   （参考档 15 是拨杆：press 写 0 = 100 ft，release 写 1 = 1000 ft，故这里两个值对调；
--     L:S_FCU_ALTITUDE_SCALE 的 0/1 含义见 msfs/WWFCU_FNX.lua 的 100 / 1000 两个键）
minifcu:CfgRpn(17, '1 (>L:S_FCU_ALTITUDE_SCALE)', '0 (>L:S_FCU_ALTITUDE_SCALE)')

-- ===========================================================
-- INPUT：EFIS 半区机长侧（bit 18–46）

-- 导航点过滤键 [Q35–Q39]
minifcu:CfgRpn(18, '1 (>L:S_FCU_EFIS1_CSTR)', '0 (>L:S_FCU_EFIS1_CSTR)')
minifcu:CfgRpn(19, '1 (>L:S_FCU_EFIS1_WPT)', '0 (>L:S_FCU_EFIS1_WPT)')
minifcu:CfgRpn(20, '1 (>L:S_FCU_EFIS1_VORD)', '0 (>L:S_FCU_EFIS1_VORD)')
minifcu:CfgRpn(21, '1 (>L:S_FCU_EFIS1_NDB)', '0 (>L:S_FCU_EFIS1_NDB)')
minifcu:CfgRpn(22, '1 (>L:S_FCU_EFIS1_ARPT)', '0 (>L:S_FCU_EFIS1_ARPT)')
-- FD / LS [Q40 / Q41]
minifcu:CfgRpn(23, '1 (>L:S_FCU_EFIS1_FD)', '0 (>L:S_FCU_EFIS1_FD)')
minifcu:CfgRpn(24, '1 (>L:S_FCU_EFIS1_LS)', '0 (>L:S_FCU_EFIS1_LS)')
-- bit 25（CHRONO）：QFCU 面板无此键，参考档里没有计时器事件，故不绑定
-- TODO：本机模机长计时器按钮有现成的公开来源（msfs/QMPE_Fnx.lua:129 的 S_MIP_CHRONO_CAPT 开关），
--   需要时把那个档一并加进 provenance 参考再绑定；现在保持空绑定，不瞎猜事件名

-- ROSE 模式键 [Q24–Q28]：LS/VOR/NAV/ARC/PLN 对应 ND_MODE 0–4
minifcu:CfgRpn(26, '0 (>L:S_FCU_EFIS1_ND_MODE)') -- LS
minifcu:CfgRpn(27, '1 (>L:S_FCU_EFIS1_ND_MODE)') -- VOR
minifcu:CfgRpn(28, '2 (>L:S_FCU_EFIS1_ND_MODE)') -- NAV
minifcu:CfgRpn(29, '3 (>L:S_FCU_EFIS1_ND_MODE)') -- ARC
minifcu:CfgRpn(30, '4 (>L:S_FCU_EFIS1_ND_MODE)') -- PLN

-- 距离 [Q29–Q34]：10/20/40/80/160/320 对应 ND_ZOOM 0–5
minifcu:CfgRpn(31, '0 (>L:S_FCU_EFIS1_ND_ZOOM)') -- 10
minifcu:CfgRpn(32, '1 (>L:S_FCU_EFIS1_ND_ZOOM)') -- 20
minifcu:CfgRpn(33, '2 (>L:S_FCU_EFIS1_ND_ZOOM)') -- 40
minifcu:CfgRpn(34, '3 (>L:S_FCU_EFIS1_ND_ZOOM)') -- 80
minifcu:CfgRpn(35, '4 (>L:S_FCU_EFIS1_ND_ZOOM)') -- 160
minifcu:CfgRpn(36, '5 (>L:S_FCU_EFIS1_ND_ZOOM)') -- 320

-- VOR/ADF 选择 1 与 2 [Q42–Q45]
--   QFCU 是两档拨杆（按下 = ADF 或 VOR，松开 = 中间位 OFF），miniFCU 是 ADF / OFF / VOR 三个独立按键，
--   所以只发按下边沿。L:S_FCU_EFIS1_NAV1 / _NAV2 的三态：0 = ADF，1 = OFF（松开值），2 = VOR。
minifcu:CfgRpn(37, '0 (>L:S_FCU_EFIS1_NAV1)') -- ADF 1 [Q42 按下值]
minifcu:CfgRpn(38, '1 (>L:S_FCU_EFIS1_NAV1)') -- OFF 1 [Q42 / Q43 松开值]
minifcu:CfgRpn(39, '2 (>L:S_FCU_EFIS1_NAV1)') -- VOR 1 [Q43 按下值]
minifcu:CfgRpn(40, '0 (>L:S_FCU_EFIS1_NAV2)') -- ADF 2 [Q44 按下值]
minifcu:CfgRpn(41, '1 (>L:S_FCU_EFIS1_NAV2)') -- OFF 2 [Q44 / Q45 松开值]
minifcu:CfgRpn(42, '2 (>L:S_FCU_EFIS1_NAV2)') -- VOR 2 [Q45 按下值]

-- 气压单位 [Q50]：QFCU 是单键拨杆（press = 0 = inHg，release = 1 = hPa），miniFCU 是两个独立按键，
--   按 miniFCU 键名分配 —— 43 键 HPA 发 1，44 键 INHG 发 0（判据见文件头）
minifcu:CfgRpn(43, '1 (>L:S_FCU_EFIS1_BARO_MODE)') -- HPA
minifcu:CfgRpn(44, '0 (>L:S_FCU_EFIS1_BARO_MODE)') -- INHG
-- 气压旋钮拉 / 按 [Q49 / Q48]
minifcu:CfgVal(45, 'B:FNX320_Input_Knob_PushPull_E_FCU_EFIS1_BARO_Pull', 1, 0)
minifcu:CfgVal(46, 'B:FNX320_Input_Knob_PushPull_E_FCU_EFIS1_BARO_Push', 1, 0)

-- ===========================================================
-- INPUT：编码器（bit 47–66）
-- 本机型参考档对编码器做了 MSFS 版本分支（参考档 6 处 `if MSFS_VERSION == 0`）：
--   * MSFS2024（MSFS_VERSION ~= 0）→ 机模提供 _Knob_Dec / _Knob_Inc 分向事件，
--     4 bit 各绑一条 CfgRpn，发参数 1（事件名逐字取自参考档）。
--   * MSFS2020（MSFS_VERSION == 0）→ 该版本只有带增量的 "Knob" 事件，方向靠参数表示，
--     故把 ±增量直接当事件参数发：-1 = 减、1 = 加（事件名逐字取自参考档）。
--     MSFS_VERSION 是插件 C++ 注入的 Lua 全局（core/luacore.cpp:1045 lua_setglobal，仅 MSFS 构建定义）。
-- ⚠ CfgEnc 在 MF 设备（miniFCU）上不可用 —— 真机验证的结论，两个分支都不再用 CfgEnc。
--   每轴 4 bit：47/48 = 减、49/50 = 加（见文件头位序说明）。
-- 回退：若 2020 下某轴不动或反向，可与 2024 分支对调（即改用 _Knob_Dec / _Knob_Inc）。

if MSFS_VERSION == 0 then
	-- ALT [Q16 / Q17]
	minifcu:CfgRpn(47, '-1 (>B:FNX320_Input_Knob_PushPull_E_FCU_ALTITUDE_Knob)')
	minifcu:CfgRpn(48, '-1 (>B:FNX320_Input_Knob_PushPull_E_FCU_ALTITUDE_Knob)')
	minifcu:CfgRpn(49, '1 (>B:FNX320_Input_Knob_PushPull_E_FCU_ALTITUDE_Knob)')
	minifcu:CfgRpn(50, '1 (>B:FNX320_Input_Knob_PushPull_E_FCU_ALTITUDE_Knob)')
	-- SPD [Q0 / Q1]
	minifcu:CfgRpn(51, '-1 (>B:FNX320_Input_Knob_PushPull_E_FCU_SPEED_Knob)')
	minifcu:CfgRpn(52, '-1 (>B:FNX320_Input_Knob_PushPull_E_FCU_SPEED_Knob)')
	minifcu:CfgRpn(53, '1 (>B:FNX320_Input_Knob_PushPull_E_FCU_SPEED_Knob)')
	minifcu:CfgRpn(54, '1 (>B:FNX320_Input_Knob_PushPull_E_FCU_SPEED_Knob)')
	-- HDG [Q4 / Q5]
	minifcu:CfgRpn(55, '-1 (>B:FNX320_Input_Knob_PushPull_E_FCU_HEADING_Knob)')
	minifcu:CfgRpn(56, '-1 (>B:FNX320_Input_Knob_PushPull_E_FCU_HEADING_Knob)')
	minifcu:CfgRpn(57, '1 (>B:FNX320_Input_Knob_PushPull_E_FCU_HEADING_Knob)')
	minifcu:CfgRpn(58, '1 (>B:FNX320_Input_Knob_PushPull_E_FCU_HEADING_Knob)')
	-- VS [Q20 / Q21]
	minifcu:CfgRpn(59, '-1 (>B:FNX320_Input_Knob_PushPull_E_FCU_VS_Knob)')
	minifcu:CfgRpn(60, '-1 (>B:FNX320_Input_Knob_PushPull_E_FCU_VS_Knob)')
	minifcu:CfgRpn(61, '1 (>B:FNX320_Input_Knob_PushPull_E_FCU_VS_Knob)')
	minifcu:CfgRpn(62, '1 (>B:FNX320_Input_Knob_PushPull_E_FCU_VS_Knob)')
	-- BARO 机长侧 [Q46 / Q47]
	minifcu:CfgRpn(63, '-1 (>B:FNX320_Input_Knob_PushPull_E_FCU_EFIS1_BARO_Knob)')
	minifcu:CfgRpn(64, '-1 (>B:FNX320_Input_Knob_PushPull_E_FCU_EFIS1_BARO_Knob)')
	minifcu:CfgRpn(65, '1 (>B:FNX320_Input_Knob_PushPull_E_FCU_EFIS1_BARO_Knob)')
	minifcu:CfgRpn(66, '1 (>B:FNX320_Input_Knob_PushPull_E_FCU_EFIS1_BARO_Knob)')
else
	-- ALT 编码器 [Q16 / Q17]：步长（100 / 1000）由机模侧的 L:S_FCU_ALTITUDE_SCALE 决定，B 事件自己处理
	minifcu:CfgRpn(47, '1 (>B:FNX320_Input_Knob_PushPull_E_FCU_ALTITUDE_Knob_Dec)')
	minifcu:CfgRpn(48, '1 (>B:FNX320_Input_Knob_PushPull_E_FCU_ALTITUDE_Knob_Dec)')
	minifcu:CfgRpn(49, '1 (>B:FNX320_Input_Knob_PushPull_E_FCU_ALTITUDE_Knob_Inc)')
	minifcu:CfgRpn(50, '1 (>B:FNX320_Input_Knob_PushPull_E_FCU_ALTITUDE_Knob_Inc)')

	-- SPD 编码器 [Q0 / Q1]：SPD / MACH 由机模侧的 L:S_FCU_SPD_MACH 决定，B 事件自己处理
	minifcu:CfgRpn(51, '1 (>B:FNX320_Input_Knob_PushPull_E_FCU_SPEED_Knob_Dec)')
	minifcu:CfgRpn(52, '1 (>B:FNX320_Input_Knob_PushPull_E_FCU_SPEED_Knob_Dec)')
	minifcu:CfgRpn(53, '1 (>B:FNX320_Input_Knob_PushPull_E_FCU_SPEED_Knob_Inc)')
	minifcu:CfgRpn(54, '1 (>B:FNX320_Input_Knob_PushPull_E_FCU_SPEED_Knob_Inc)')

	-- HDG 编码器 [Q4 / Q5]
	minifcu:CfgRpn(55, '1 (>B:FNX320_Input_Knob_PushPull_E_FCU_HEADING_Knob_Dec)')
	minifcu:CfgRpn(56, '1 (>B:FNX320_Input_Knob_PushPull_E_FCU_HEADING_Knob_Dec)')
	minifcu:CfgRpn(57, '1 (>B:FNX320_Input_Knob_PushPull_E_FCU_HEADING_Knob_Inc)')
	minifcu:CfgRpn(58, '1 (>B:FNX320_Input_Knob_PushPull_E_FCU_HEADING_Knob_Inc)')

	-- VS 编码器 [Q20 / Q21]：VS / FPA 由机模侧的 L:S_FCU_HDGVS_TRKFPA 决定，B 事件自己处理
	minifcu:CfgRpn(59, '1 (>B:FNX320_Input_Knob_PushPull_E_FCU_VS_Knob_Dec)')
	minifcu:CfgRpn(60, '1 (>B:FNX320_Input_Knob_PushPull_E_FCU_VS_Knob_Dec)')
	minifcu:CfgRpn(61, '1 (>B:FNX320_Input_Knob_PushPull_E_FCU_VS_Knob_Inc)')
	minifcu:CfgRpn(62, '1 (>B:FNX320_Input_Knob_PushPull_E_FCU_VS_Knob_Inc)')

	-- BARO 编码器（机长侧）[Q46 / Q47]：单位由机模侧的 L:S_FCU_EFIS1_BARO_MODE 决定
	minifcu:CfgRpn(63, '1 (>B:FNX320_Input_Knob_PushPull_E_FCU_EFIS1_BARO_Knob_Dec)')
	minifcu:CfgRpn(64, '1 (>B:FNX320_Input_Knob_PushPull_E_FCU_EFIS1_BARO_Knob_Dec)')
	minifcu:CfgRpn(65, '1 (>B:FNX320_Input_Knob_PushPull_E_FCU_EFIS1_BARO_Knob_Inc)')
	minifcu:CfgRpn(66, '1 (>B:FNX320_Input_Knob_PushPull_E_FCU_EFIS1_BARO_Knob_Inc)')
end

-- ===========================================================
-- 显示源（帧循环里直接读）

-- FCU
local dr_spd        = iDataRef:New('(L:N_FCU_SPEED)')      -- SPD 模式 = kts；MACH 模式 = 马赫（0.xx）
local dr_spd_mode   = iDataRef:New('(L:I_FCU_SPEED_MODE)') -- 1 = 显示 MACH
local dr_spd_dashed = iDataRef:New('(L:B_FCU_SPEED_DASHED)')
local dr_spd_mgd    = iDataRef:New('(L:I_FCU_SPEED_MANAGED)')
local dr_hdg        = iDataRef:New('(L:N_FCU_HEADING)')
local dr_hdg_dashed = iDataRef:New('(L:B_FCU_HEADING_DASHED)')
local dr_hdg_mgd    = iDataRef:New('(L:I_FCU_HEADING_MANAGED)')
local dr_alt        = iDataRef:New('(L:N_FCU_ALTITUDE)')
local dr_alt_mgd    = iDataRef:New('(L:I_FCU_ALTITUDE_MANAGED)')
local dr_vs         = iDataRef:New('(L:N_FCU_VS)')             -- VS 模式 = fpm；FPA 模式 = FPA×1000
local dr_vs_dashed  = iDataRef:New('(L:B_FCU_VERTICALSPEED_DASHED)')
local dr_trkfpa     = iDataRef:New('(L:I_FCU_TRACK_FPA_MODE)') -- 1 = TRK/FPA

-- EFIS 机长侧气压：BARO_MODE 0 = inHg，1 = hPa；BARO_INCH 恒为 inHg；QNH 1 = QNH，0 = STD
local dr_baro_mode  = iDataRef:New('(L:S_FCU_EFIS1_BARO_MODE)')
local dr_baro_inch  = iDataRef:New('(L:N_FCU_EFIS1_BARO_INCH)')
local dr_baro_qnh   = iDataRef:New('(L:I_FCU_EFIS1_QNH)')

-- ===========================================================
-- OUTPUT：6 个 LED pin
minifcu:GetAp1('(L:I_FCU_AP1)')
minifcu:GetAp2('(L:I_FCU_AP2)')
minifcu:GetAthr('(L:I_FCU_ATHR)')
minifcu:GetLoc('(L:I_FCU_LOC)')
minifcu:GetAppr('(L:I_FCU_APPR)')
minifcu:GetExped('(L:I_FCU_EXPED)')

-- ===========================================================
-- OUTPUT：miniFCU LCD（CustomDevice 通道 = 14 FCU + 12 EFIS，全部保留）

-- MT 0 SPD 值（kts）
minifcu:GetFcuSpdValue('(L:N_FCU_SPEED)')
-- MT 1 MACH 值（马赫 × 100）
minifcu:GetFcuMachValue('(L:N_FCU_SPEED)', 100)
-- MT 2 SPD/MACH 模式（1 = mach）
minifcu:GetFcuSpdMachMode('(L:I_FCU_SPEED_MODE)')
-- MT 3 SPD dashed
minifcu:GetFcuSpdDashes('(L:B_FCU_SPEED_DASHED)')
-- MT 4 SPD managed 点
minifcu:GetFcuSpdDot('(L:I_FCU_SPEED_MANAGED)')
-- MT 5 HDG 值
minifcu:GetFcuHdgValue('(L:N_FCU_HEADING)')
-- MT 6 HDG dashed
minifcu:GetFcuHdgDashes('(L:B_FCU_HEADING_DASHED)')
-- MT 7 HDG managed 点
minifcu:GetFcuHdgDot('(L:I_FCU_HEADING_MANAGED)')
-- MT 8 ALT 值（ft / 100）
minifcu:GetFcuAltValue('(L:N_FCU_ALTITUDE)', 0.01)
-- MT 9 ALT managed 点
minifcu:GetFcuAltDot('(L:I_FCU_ALTITUDE_MANAGED)')
-- MT 10 VS 值（fpm，TRK/FPA 模式下隐藏）
minifcu:GetFcuVsValue('(L:N_FCU_VS)')
-- MT 11 FPA 值：通道量纲 = FPA × 1000，而 N_FCU_VS 本身已是 FPA×1000 → GetFcuFpaValue(path, 1)
minifcu:GetFcuFpaValue('(L:N_FCU_VS)', 1)
-- MT 12 VS dashed
minifcu:GetFcuVsDashes('(L:B_FCU_VERTICALSPEED_DASHED)')
-- MT 13 HDG/TRK 模式（1 = TRK）
minifcu:GetFcuHdgTrkMode('(L:I_FCU_TRACK_FPA_MODE)')

-- MT 0 CSTR / MT 1 WPT / MT 2 VORD / MT 3 NDB / MT 4 ARPT（EFIS1 指示灯量）
minifcu:GetEfisCstr('(L:I_FCU_EFIS1_CSTR)')
minifcu:GetEfisWpt('(L:I_FCU_EFIS1_WPT)')
minifcu:GetEfisVord('(L:I_FCU_EFIS1_VORD)')
minifcu:GetEfisNdb('(L:I_FCU_EFIS1_NDB)')
minifcu:GetEfisArpt('(L:I_FCU_EFIS1_ARPT)')
-- MT 5 FD / MT 6 LS
minifcu:GetFcuFdValue('(L:I_FCU_EFIS1_FD)')
minifcu:GetFcuLsValue('(L:I_FCU_EFIS1_LS)')
-- MT 7 QNH 标签（非 STD 时为 1）
minifcu:GetEfisBaroQnnh1('(L:I_FCU_EFIS1_QNH)')
-- MT 8 STD 标志
minifcu:GetEfisBaroStd1('(L:I_FCU_EFIS1_QNH)')
-- MT 9 inHg/hPa（1 = inHg）
minifcu:GetEfisBaroInhgHpaUnit('(L:S_FCU_EFIS1_BARO_MODE)')
-- MT 10 BARO inHg（×100）/ MT 11 BARO hPa（值在帧循环里换算后写入）
minifcu:GetEfisBaroInhg('(L:N_FCU_EFIS1_BARO_INCH)')
minifcu:GetEfisBaro('(L:N_FCU_EFIS1_BARO_INCH)')

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
	local is_mach  = dr_spd_mode:Get() -- 0 = MACH
	local spd_dash = dr_spd_dashed:Get()
	local spd_val  = dr_spd:Get()   -- SPD 模式 = kts；MACH 模式 = 马赫

	-- MT 2：SPD/MACH 模式
	minifcu:SetFcuSpdMachMode(is_mach == 0 and 1 or 0)

	-- MT 1：MACH 值（马赫 × 100；SPD 模式或 dashed 时置 0，与 XP 档一致）
	if is_mach == 0 and spd_dash < 1 then
		minifcu:SetFcuMachValue(math.floor(spd_val))
	else
		minifcu:SetFcuMachValue(0)
	end

	-- MT 0：SPD 值（kts；mach 或 dashed 时置 0）
	if is_mach > 0 and spd_dash < 1 then
		minifcu:SetFcuSpdValue(math.floor(spd_val))
	else
		minifcu:SetFcuSpdValue(0)
	end

	-- MT 3 / MT 4：dashed 与 managed 点
	minifcu:SetFcuSpdDashes()
	minifcu:SetFcuSpdDot()

	-- MT 5 / MT 6 / MT 7：HDG
	minifcu:SetFcuHdgValue()
	minifcu:SetFcuHdgDashes()
	minifcu:SetFcuHdgDot()

	-- MT 8 / MT 9：ALT（GetFcuAltValue 的 scale = 0.01，直接读 N_FCU_ALTITUDE 就是 ft/100）
	minifcu:SetFcuAltValue()
	minifcu:SetFcuAltDot()

	-- MT 10 / MT 11 / MT 12：VS 与 FPA 互斥
	--   N_FCU_VS 在 TRK/FPA 模式下装的是 FPA×1000（QFCU 档把同一条数据同时喂 VS / TRK 两个通道，
	--   并注明 TRK 通道 "need 0.8*1000=800"；msfs/WWFCU_FNX.lua 也是 vs / 100 再按 2 位显示），
	--   而 MT11 通道量纲同为 FPA×1000 → 注册时传 1（不再自己 ÷1000），帧循环 SetFcuFpaValue() 不传值；
	--   若某天机模改成 FPA×100，把注册里那个 1 改成 10 即可
	local is_fpa = (dr_trkfpa:Get() >= 1)
	local vs_fpa = dr_vs:Get()
	minifcu:SetFcuVsDashes()
	if is_fpa then
		minifcu:SetFcuVsValue(0)
		minifcu:SetFcuFpaValue()
	else
		minifcu:SetFcuVsValue(vs_fpa)
		minifcu:SetFcuFpaValue(0)
	end

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

	-- 气压：单位 / STD / QNH 标签 + 两个值通道（两个值都由恒为 inHg 的源现算，切单位不会读到陈旧值）
	local baro_mode = dr_baro_mode:Get() -- 0 = inHg，1 = hPa
	local baro_qnh  = dr_baro_qnh:Get() -- 1 = QNH，0 = STD
	local baro_inch = dr_baro_inch:Get() -- inHg

	-- MT 9：1 = inHg
	minifcu:SetEfisBaroInhgHpaUnit(baro_mode >= 1 and 0 or 1)
	-- MT 8 / MT 7：STD 与 QNH 标签
	minifcu:SetEfisBaroStd1(baro_qnh < 1 and 1 or 0)
	minifcu:SetEfisBaroQnnh1(baro_qnh >= 1 and 1 or 0)
	-- MT 10 / MT 11：inHg × 100 与 hPa 整数（换算常量与 QFCU 档一致）
	minifcu:SetEfisBaroInhg(math.floor(baro_inch * 100 + 0.5))
	minifcu:SetEfisBaro(math.floor(baro_inch * 33.8638895 + 0.5))
end)
