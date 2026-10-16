-- *****************************************************************
-- FlyLuaIO MobiFlight miniFCU (miniFCU + miniEFIS) for MSFS
-- FlyByWire A320neo / A321neo（FBW A3xx 家族）—— Headwind A330 (a339x) 同为 FBW 内核，同档覆盖
-- created by Wei Shuai <cpuwolf@gmail.com>
-- *****************************************************************
-- 来源与依据（可追溯）：
--   * 事件名 / L 变量 / A 变量：msfs/data/QFCU_FBW_A320NX.lua（QFCU 同机型档，MSFS 实测通过）
--     每条绑定后的 [Q#] 标注该功能在 QFCU 面板上的 KeyIdx，便于与 QFCU 档逐条对照。
--   * 硬件通道契约：mobiflight/MiniFCU.json（按键 bit 0–46、编码器 bit 47–66、
--     6 个 Output pin、26 条 CustomDevice 通道）。
--   * 通道语义 / 编码器位序：xp/MINIFCU_Toliss.lua（真机 miniFCU 在 X-Plane 上手工调过并实测）。
-- 编码器位序（沿用 XP 档，勿改）：每轴 4 bit，前 2 bit = 减，后 2 bit = 加。
--   ALT 47/48 减 · 49/50 加；SPD 51/52 · 53/54；HDG 55/56 · 57/58；VS 59/60 · 61/62；BARO 63/64 · 65/66
--   ⚠ BARO 在 xp/MINIFCU_Toliss.lua 里只绑了 63(减)/65(加) 两个 bit，本档按 JSON 的
--     MapToBits 绑满 4 个 bit（与 xp/z_MINIFCU_GA.lua 一致）。若真机上气压旋钮一格走两格，
--     把 64/66 两行注释掉即可。
-- 机型边界：
--   * A380 在本档排除 —— FBW A380 的显示变量命名空间不同（QFCU 档里 A380 用
--     A32NX_AUTOPILOT_SPEED_SELECTED / XMLVAR_Baro1_Mode，A320 用 A32NX_FCU_AFS_* /
--     A32NX_FCU_EFIS_L_*），需单独出 MINIFCU_FBW_A380.lua。
--   * LVFR A3XX 在本档排除 —— 它有自己的一套事件（见 QFCU_LVFR_A3XX.lua），
--     两者 gate 都能匹配 LVFR 机型，若不排除谁先加载就由谁绑定。
-- 已知取舍（待真机验证）：
--   1. 未做断电门控：QFCU 档会在 AC BUS 掉电时关 LCD，miniFCU 硬件无背光/熄灭通道，
--      XP 档也没有做，这里保持一致；如需冷舱熄灭请先确认硬件的“空屏”通道。
--   2. bit 25（CHRONO）：QFCU 面板无此键，来源改用 msfs/data/QMPE_FBW_A320NX.lua 的 H 事件。
--   3. QFCU 面板有两个 EFIS 半区（机长/副驾），miniFCU 只有机长半区，故 QFCU 的
--      51/52/53（右气压）与 56–79（右 EFIS）不移植。
-- *****************************************************************

if ilua_require_msfs() then
	return
end
if ilua_require_fbw_a3xx() then return end
-- A380 / LVFR 另有专属档，这里显式排除，避免两个 profile 争抢同一台硬件
if not ilua_is_acfpath_excluded('A380') then return end
if not ilua_is_acfpath_excluded('lvfr') then return end

-- Do not remove below lines: hardware detection
local minifcu = com.sim.mf.MiniFCU.Open()
if not minifcu then return end
-- Do not remove above lines: hardware detection

uluaLog('MobiFlight MiniFCU for FlyByWire A3xx')

-- ===========================================================
-- INPUT：FCU 半区（bit 0–17）

-- SPD/MACH 显示切换 [Q55]
minifcu:CfgRpn(0, '(>K:A32NX.FCU_SPD_MACH_TOGGLE_PUSH)')
-- HDG/TRK ↔ VS/FPA 切换 [Q54]
minifcu:CfgRpn(1, '(>K:A32NX.FCU_TRK_FPA_TOGGLE_PUSH)')
-- AP1 [Q10]
minifcu:CfgRpn(2, '(>K:A32NX.FCU_AP_1_PUSH)')
-- AP2 [Q9]
minifcu:CfgRpn(3, '(>K:A32NX.FCU_AP_2_PUSH)')
-- METRIC ALT [Q14]
minifcu:CfgRpn(4, '(>K:A32NX.FCU_METRIC_ALT_TOGGLE_PUSH)')
-- A/THR [Q11]
minifcu:CfgRpn(5, '(>K:A32NX.FCU_ATHR_PUSH)')
-- EXPED [Q12]
minifcu:CfgRpn(6, '(>K:A32NX.FCU_EXPED_PUSH)')
-- LOC [Q8]
minifcu:CfgRpn(7, '(>K:A32NX.FCU_LOC_PUSH)')
-- APPR [Q13]
minifcu:CfgRpn(8, '(>K:A32NX.FCU_APPR_PUSH)')
-- SPD PUSH/PULL [Q2 / Q3]
minifcu:CfgRpn(9, '(>K:A32NX.FCU_SPD_PUSH)')
minifcu:CfgRpn(10, '(>K:A32NX.FCU_SPD_PULL)')
-- HDG PUSH/PULL [Q6 / Q7]
minifcu:CfgRpn(11, '(>K:A32NX.FCU_HDG_PUSH)')
minifcu:CfgRpn(12, '(>K:A32NX.FCU_HDG_PULL)')
-- ALT PUSH/PULL [Q18 / Q19]
minifcu:CfgRpn(13, '(>K:A32NX.FCU_ALT_PUSH)')
minifcu:CfgRpn(14, '(>K:A32NX.FCU_ALT_PULL)')
-- VS PUSH/PULL [Q22 / Q23]
minifcu:CfgRpn(15, '(>K:A32NX.FCU_VS_PUSH)')
minifcu:CfgRpn(16, '(>K:A32NX.FCU_VS_PULL)')
-- ALT 100/1000 [Q15]：miniFCU 是瞬时按键 —— 按住 = 1000 ft 步长，松开回 100 ft
--   （与 xp/MINIFCU_Toliss.lua 的 ALT100_1000 按下 1 / 松开 0 同语义；
--     QFCU 面板该键是拨杆，所以 QFCU 档的按下 0 / 松开 1 不能照抄）
minifcu:CfgRpn(17, '1 (>L:A32NX_FCU_ALT_INCREMENT_1000)', '0 (>L:A32NX_FCU_ALT_INCREMENT_1000)')

-- ===========================================================
-- INPUT：EFIS 半区机长侧（bit 18–46）

-- 导航点过滤键 [Q35–Q39]
minifcu:CfgRpn(18, '(>K:A32NX.FCU_EFIS_L_CSTR_PUSH)')
minifcu:CfgRpn(19, '(>K:A32NX.FCU_EFIS_L_WPT_PUSH)')
minifcu:CfgRpn(20, '(>K:A32NX.FCU_EFIS_L_VORD_PUSH)')
minifcu:CfgRpn(21, '(>K:A32NX.FCU_EFIS_L_NDB_PUSH)')
minifcu:CfgRpn(22, '(>K:A32NX.FCU_EFIS_L_ARPT_PUSH)')
-- FD / LS [Q40 / Q41]
minifcu:CfgRpn(23, '(>K:A32NX.FCU_EFIS_L_FD_PUSH)')
minifcu:CfgRpn(24, '(>K:A32NX.FCU_EFIS_L_LS_PUSH)')
-- CHRONO：QFCU 面板无此键，来源 msfs/data/QMPE_FBW_A320NX.lua:301
minifcu:CfgRpn(25, '(>H:A32NX_EFIS_L_CHRONO_PUSHED)')

-- ROSE 模式键 [Q24–Q28]：LS/VOR/NAV/ARC/PLN 对应 EFIS_MODE 0–4
-- （A380 用 A32NX_EFIS_L_ND_MODE，见 MINIFCU_FBW_A380.lua）
minifcu:CfgRpn(26, '0 (>L:A32NX_FCU_EFIS_L_EFIS_MODE)') -- LS
minifcu:CfgRpn(27, '1 (>L:A32NX_FCU_EFIS_L_EFIS_MODE)') -- VOR
minifcu:CfgRpn(28, '2 (>L:A32NX_FCU_EFIS_L_EFIS_MODE)') -- NAV
minifcu:CfgRpn(29, '3 (>L:A32NX_FCU_EFIS_L_EFIS_MODE)') -- ARC
minifcu:CfgRpn(30, '4 (>L:A32NX_FCU_EFIS_L_EFIS_MODE)') -- PLN

-- 距离 [Q29–Q34]：10/20/40/80/160/320 → RANGE 0–5
minifcu:CfgRpn(31, '0 (>L:A32NX_FCU_EFIS_L_EFIS_RANGE)') -- 10
minifcu:CfgRpn(32, '1 (>L:A32NX_FCU_EFIS_L_EFIS_RANGE)') -- 20
minifcu:CfgRpn(33, '2 (>L:A32NX_FCU_EFIS_L_EFIS_RANGE)') -- 40
minifcu:CfgRpn(34, '3 (>L:A32NX_FCU_EFIS_L_EFIS_RANGE)') -- 80
minifcu:CfgRpn(35, '4 (>L:A32NX_FCU_EFIS_L_EFIS_RANGE)') -- 160
minifcu:CfgRpn(36, '5 (>L:A32NX_FCU_EFIS_L_EFIS_RANGE)') -- 320

-- VOR/ADF 选择 1 与 2 [Q42–Q45]
--   QFCU 是两档拨杆（按下 = ADF/VOR，松开 = 0），miniFCU 是 ADF / OFF / VOR 三个独立按键，
--   所以这里只发按下，OFF 键显式写 0。NAVAID_x_MODE：1 = ADF，2 = VOR。
minifcu:CfgRpn(37, '1 (>L:A32NX_FCU_EFIS_L_NAVAID_1_MODE)') -- ADF 1
minifcu:CfgRpn(38, '0 (>L:A32NX_FCU_EFIS_L_NAVAID_1_MODE)') -- OFF 1
minifcu:CfgRpn(39, '2 (>L:A32NX_FCU_EFIS_L_NAVAID_1_MODE)') -- VOR 1
minifcu:CfgRpn(40, '1 (>L:A32NX_FCU_EFIS_L_NAVAID_2_MODE)') -- ADF 2
minifcu:CfgRpn(41, '0 (>L:A32NX_FCU_EFIS_L_NAVAID_2_MODE)') -- OFF 2
minifcu:CfgRpn(42, '2 (>L:A32NX_FCU_EFIS_L_NAVAID_2_MODE)') -- VOR 2

-- 气压单位 [Q50]：1 = inHg，0 = hPa（QFCU 是单键拨杆，miniFCU 是两个独立按键，故只发按下）
minifcu:CfgRpn(43, '0 (>L:A32NX_FCU_EFIS_L_BARO_IS_INHG)') -- HPA
minifcu:CfgRpn(44, '1 (>L:A32NX_FCU_EFIS_L_BARO_IS_INHG)') -- INHG
-- 气压旋钮拉 / 按 [Q49 / Q48]
minifcu:CfgRpn(45, '(>K:A32NX.FCU_EFIS_L_BARO_PULL)')
minifcu:CfgRpn(46, '(>K:A32NX.FCU_EFIS_L_BARO_PUSH)')

-- ===========================================================
-- INPUT：编码器（bit 47–66）

-- ALT 编码器 [Q16 / Q17]
minifcu:CfgRpn(47, '(>K:A32NX.FCU_ALT_DEC)')
minifcu:CfgRpn(48, '(>K:A32NX.FCU_ALT_DEC)')
minifcu:CfgRpn(49, '(>K:A32NX.FCU_ALT_INC)')
minifcu:CfgRpn(50, '(>K:A32NX.FCU_ALT_INC)')

-- SPD 编码器 [Q0 / Q1]：mach 模式下走 AP_MACH_VAR
local spd_dec_rpn = '(L:XMLVAR_AirSpeedIsInMach) if{ 1 (>K:AP_MACH_VAR_DEC) } els{ 1 (>K:AP_SPD_VAR_DEC) } (>H:A320_Neo_CDU_AP_DEC_SPEED)'
local spd_inc_rpn = '(L:XMLVAR_AirSpeedIsInMach) if{ 1 (>K:AP_MACH_VAR_INC) } els{ 1 (>K:AP_SPD_VAR_INC) } (>H:A320_Neo_CDU_AP_INC_SPEED)'
minifcu:CfgRpn(51, spd_dec_rpn)
minifcu:CfgRpn(52, spd_dec_rpn)
minifcu:CfgRpn(53, spd_inc_rpn)
minifcu:CfgRpn(54, spd_inc_rpn)

-- HDG 编码器 [Q4 / Q5]
minifcu:CfgRpn(55, '(>K:A32NX.FCU_HDG_DEC)')
minifcu:CfgRpn(56, '(>K:A32NX.FCU_HDG_DEC)')
minifcu:CfgRpn(57, '(>K:A32NX.FCU_HDG_INC)')
minifcu:CfgRpn(58, '(>K:A32NX.FCU_HDG_INC)')

-- VS 编码器 [Q20 / Q21]
minifcu:CfgRpn(59, '(>K:A32NX.FCU_VS_DEC)')
minifcu:CfgRpn(60, '(>K:A32NX.FCU_VS_DEC)')
minifcu:CfgRpn(61, '(>K:A32NX.FCU_VS_INC)')
minifcu:CfgRpn(62, '(>K:A32NX.FCU_VS_INC)')

-- BARO 编码器（机长侧）[Q46 / Q47]
minifcu:CfgRpn(63, '(>K:A32NX.FCU_EFIS_L_BARO_DEC)')
minifcu:CfgRpn(64, '(>K:A32NX.FCU_EFIS_L_BARO_DEC)')
minifcu:CfgRpn(65, '(>K:A32NX.FCU_EFIS_L_BARO_INC)')
minifcu:CfgRpn(66, '(>K:A32NX.FCU_EFIS_L_BARO_INC)')

-- ===========================================================
-- 显示源（帧循环里直接读；只在 Lua 里需要算的才登记 iDataRef）
-- ⚠ 不要把运算塞进注册表达式：那些表达式是 sim 侧求值的，每帧每通道都算会拖帧数。

-- FCU
local dr_is_mach     = iDataRef:New('(L:A32NX_FCU_AFS_DISPLAY_MACH_MODE,Bool)') -- 1 = 显示 MACH
local dr_spd_display = iDataRef:New('(L:A32NX_FCU_AFS_DISPLAY_SPD_MACH_VALUE)') -- SPD 模式 = kts；MACH 模式 = 马赫（0.xx）
local dr_spd_dashed  = iDataRef:New('(L:A32NX_FCU_SPD_MANAGED_DASHES)')
local dr_vs          = iDataRef:New('(L:A32NX_AUTOPILOT_VS_SELECTED)')
local dr_trkfpa      = iDataRef:New('(L:A32NX_TRK_FPA_MODE_ACTIVE)') -- 1 = TRK/FPA

-- EFIS 机长侧气压：DISPLAY_BARO_MODE STD:0 QNH:1 QFE:2；IS_INHG 1 = inHg
local dr_baro_mode   = iDataRef:New('(L:A32NX_FCU_EFIS_L_DISPLAY_BARO_MODE)')
local dr_baro_inhg   = iDataRef:New('(L:A32NX_FCU_EFIS_L_BARO_IS_INHG)')
local dr_baro_value  = iDataRef:New('(L:A32NX_FCU_EFIS_L_DISPLAY_BARO_VALUE)') -- 当前显示单位下的值

-- ===========================================================
-- OUTPUT：6 个 LED pin
minifcu:GetAp1('(L:A32NX_AUTOPILOT_1_ACTIVE)')
minifcu:GetAp2('(L:A32NX_AUTOPILOT_2_ACTIVE)')
minifcu:GetAthr('(L:A32NX_AUTOTHRUST_STATUS)') -- 0 = off，非 0 = 接通
minifcu:GetLoc('(L:A32NX_FCU_LOC_LIGHT_ON)')
minifcu:GetAppr('(L:A32NX_FCU_APPR_LIGHT_ON)')
minifcu:GetExped('(L:A32NX_FMA_EXPEDITE_MODE)')

-- ===========================================================
-- OUTPUT：miniFCU LCD（CustomDevice 24 通道 = 14 FCU + 12 EFIS，全部保留）

-- MT 0 SPD 值（kts；MACH 模式或虚线时 0）
minifcu:GetFcuSpdValue('(L:A32NX_FCU_AFS_DISPLAY_SPD_MACH_VALUE)')
-- MT 1 MACH 值（马赫 × 100；SPD 模式或虚线时 0）
minifcu:GetFcuMachValue('(L:A32NX_FCU_AFS_DISPLAY_SPD_MACH_VALUE)')
-- MT 2 SPD/MACH 模式（1 = mach）
minifcu:GetFcuSpdMachMode('(L:A32NX_FCU_AFS_DISPLAY_MACH_MODE,Bool)')
-- MT 3 SPD dashed
minifcu:GetFcuSpdDashes('(L:A32NX_FCU_SPD_MANAGED_DASHES)')
-- MT 4 SPD managed 点
minifcu:GetFcuSpdDot('(L:A32NX_FCU_SPD_MANAGED_DOT)')
-- MT 5 HDG 值
minifcu:GetFcuHdgValue('(L:A32NX_AUTOPILOT_HEADING_SELECTED)')
-- MT 6 HDG dashed
minifcu:GetFcuHdgDashes('(L:A32NX_FCU_HDG_MANAGED_DASHES)')
-- MT 7 HDG managed 点
minifcu:GetFcuHdgDot('(L:A32NX_FCU_HDG_MANAGED_DOT)')
-- MT 8 ALT 值（ft / 100）
minifcu:GetFcuAltValue('(A:AUTOPILOT ALTITUDE LOCK VAR:3, Feet)', 0.01)
-- MT 9 ALT managed 点
minifcu:GetFcuAltDot('(L:A32NX_FCU_ALT_MANAGED)')
-- MT 10 VS 值（fpm；TRK/FPA 模式下由帧循环置 0）
minifcu:GetFcuVsValue('(L:A32NX_AUTOPILOT_VS_SELECTED)')
-- MT 11 FPA 值（量纲 FPA × 1000，由默认 scale 提供；非 TRK/FPA 模式由帧循环置 0）
minifcu:GetFcuFpaValue('(L:A32NX_AUTOPILOT_FPA_SELECTED)')
-- MT 12 VS dashed
minifcu:GetFcuVsDashes('(L:A32NX_FCU_VS_MANAGED)')
-- MT 13 HDG/TRK 模式（1 = TRK）
minifcu:GetFcuHdgTrkMode('(L:A32NX_TRK_FPA_MODE_ACTIVE)')

-- MT 0 CSTR / MT 1 WPT / MT 2 VORD / MT 3 NDB / MT 4 ARPT（EFIS_L_OPTION 等值比较，与 QFCU 档同源）
minifcu:GetEfisCstr('(L:A32NX_EFIS_L_OPTION, enum) 1 ==')
minifcu:GetEfisWpt('(L:A32NX_EFIS_L_OPTION, enum) 4 ==')
minifcu:GetEfisVord('(L:A32NX_EFIS_L_OPTION, enum) 2 ==')
minifcu:GetEfisNdb('(L:A32NX_EFIS_L_OPTION, enum) 8 ==')
minifcu:GetEfisArpt('(L:A32NX_EFIS_L_OPTION, enum) 16 ==')
-- MT 5 FD / MT 6 LS
minifcu:GetFcuFdValue('(A:AUTOPILOT FLIGHT DIRECTOR ACTIVE:1, Bool)')
minifcu:GetFcuLsValue('(L:BTN_LS_1_FILTER_ACTIVE)')
-- MT 7 QNH 标签 / MT 8 STD 标志（判据在帧循环里做：非 STD 即亮，与 xp/MINIFCU_Toliss.lua 一致）
minifcu:GetEfisBaroQnnh1('(L:A32NX_FCU_EFIS_L_DISPLAY_BARO_MODE)')
minifcu:GetEfisBaroStd1('(L:A32NX_FCU_EFIS_L_DISPLAY_BARO_MODE)')
-- MT 9 inHg/hPa（1 = inHg）
minifcu:GetEfisBaroInhgHpaUnit('(L:A32NX_FCU_EFIS_L_BARO_IS_INHG)')
-- MT 10 BARO inHg（×100）/ MT 11 BARO hPa：DISPLAY_BARO_VALUE 是“当前单位下的值”，
--   帧循环里按当前单位换算（切单位不读陈旧值），不额外清 STD（STD 由 MT8 标签接管）
minifcu:GetEfisBaroInhg('(L:A32NX_FCU_EFIS_L_DISPLAY_BARO_VALUE)')
minifcu:GetEfisBaro('(L:A32NX_FCU_EFIS_L_DISPLAY_BARO_VALUE)')

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
	local spd_val  = dr_spd_display:Get()

	-- MT 2：SPD/MACH 模式
	minifcu:SetFcuSpdMachMode()

	-- MT 1：MACH 值（马赫 × 100；仅 MACH 模式且非虚线）
	if is_mach >= 1 and spd_dash < 1 then
		minifcu:SetFcuMachValue(spd_val * 100 + 0.5)
	else
		minifcu:SetFcuMachValue(0)
	end

	-- MT 0：SPD 值（仅 SPD 模式且非虚线；源就是 kts，直接走注册值）
	if is_mach < 1 and spd_dash < 1 then
		minifcu:SetFcuSpdValue()
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

	-- MT 8 / MT 9：ALT（ft/100 由注册时的 scale 0.01 提供）
	minifcu:SetFcuAltValue()
	minifcu:SetFcuAltDot()

	-- MT 10 / MT 11 / MT 12：VS 与 FPA 互斥（TRK/FPA 模式下 VS 灭、FPA 亮）
	local is_fpa = (dr_trkfpa:Get() >= 1)
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

	-- ---- EFIS 半区 ----
	minifcu:SetEfisCstr()
	minifcu:SetEfisWpt()
	minifcu:SetEfisVord()
	minifcu:SetEfisNdb()
	minifcu:SetEfisArpt()
	minifcu:SetFcuFdValue()
	minifcu:SetFcuLsValue()

	-- 气压：单位 / STD / QNH 标签 + 两个值通道（两个值都算，切单位时不会读到陈旧值）
	local baro_mode = dr_baro_mode:Get() -- 0 = STD
	local baro_inhg = dr_baro_inhg:Get() -- 1 = inHg
	local baro_val  = dr_baro_value:Get()

	minifcu:SetEfisBaroInhgHpaUnit()
	minifcu:SetEfisBaroStd1(baro_mode == 0 and 1 or 0)
	minifcu:SetEfisBaroQnnh1(baro_mode ~= 0 and 1 or 0)

	if baro_inhg >= 1 then
		minifcu:SetEfisBaroInhg(math.floor(baro_val * 100 + 0.5))
		minifcu:SetEfisBaro(math.floor(baro_val * 33.8638895 + 0.5))
	else
		minifcu:SetEfisBaro(math.floor(baro_val + 0.5))
		minifcu:SetEfisBaroInhg(math.floor(baro_val * 100 / 33.8638895 + 0.5))
	end
end)
