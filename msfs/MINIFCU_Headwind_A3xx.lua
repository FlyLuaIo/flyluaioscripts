-- *****************************************************************
-- FlyLuaIO MobiFlight miniFCU (miniFCU + miniEFIS) for MSFS
-- Headwind A330-900 (a339x / headwindsim-aircraft-a330-900)
-- created by Wei Shuai <cpuwolf@gmail.com>
-- *****************************************************************
-- 来源与依据（可追溯）：
--   * 事件名 / L 变量 / A 变量：msfs/data/QFCU_Headwind_A3xx.lua（QFCU 同机型档，MSFS 实测通过）
--     每条绑定后的 [Q#] 标注该功能在 QFCU 面板上的 KeyIdx，便于与 QFCU 档逐条对照。
--   * 硬件通道契约：mobiflight/MiniFCU.json（按键 bit 0–46、编码器 bit 47–66、
--     6 个 Output pin、26 条 CustomDevice 通道）。
--   * 通道语义 / 编码器位序：xp/MINIFCU_Toliss.lua（真机 miniFCU 在 X-Plane 上手工调过并实测）。
-- 参考档里的三条路径与本档取舍：
--   * 本档取 Headwind A330 实际走的那条 = isFBWA380 为 false 且 isFBWA320dev 为 true 的分支。
--     依据：参考档第 46 行把 isFBWA320dev 初始化成 true，全文只有继续置 true 的赋值，
--     从没有置 false 的地方 —— 所以 "stable"（isFBWA320dev 为 false）那一支是死代码，
--     Headwind A330 走的就是 else 那一支（A32NX.FCU_* 事件族 + A32NX_FCU_EFIS_L_* 变量族）。
--   * A380 分支（isFBWA380）丢弃：Headwind A330 的机模路径不含 A380，不会走这一支；
--     且 FBW A380 有专属 miniFCU 档，其显示变量命名空间也不同。
--   * "stable" A320 分支丢弃：如上，永不执行（其余事件名逐字保留在参考档里，本档不引用）。
-- 编码器位序（沿用 XP 档，勿改）：每轴 4 bit，前 2 bit = 减，后 2 bit = 加。
--   ALT 47/48 · 49/50；SPD 51/52 · 53/54；HDG 55/56 · 57/58；VS 59/60 · 61/62；BARO 63/64 · 65/66
-- 已知取舍（待真机验证）：
--   1. 断电 / ANN LT 测试：与参考档同源 —— (L:A32NX_ELEC_AC_1_BUS_IS_POWERED) 断电熄屏、
--      (L:A32NX_OVHD_INTLT_ANN) == 0 进 TEST（做法同 xp/MINIFCU_Toliss.lua）。亮度没有通道，不移植。
--   2. bit 25（CHRONO）：QFCU 面板无此键，参考档里也没有对应的计时事件 → 本档接 FBW 代码基座的
--      A32NX EFIS 计时器 H 事件（Headwind A330-900 = FBW A32NX 派生，与 MINIFCU_FBW_A320NX.lua 同源）。
--      TODO: 待真机确认该机模确实注册了 A32NX_EFIS_L_CHRONO_PUSHED。
--   3. QFCU 面板有两个 EFIS 半区（机长 / 副驾），miniFCU 只有机长半区，故 QFCU 的
--      51/52/53（副驾气压）与 56–79（副驾 EFIS）不移植。
--   4. SPD/MACH：参考档把速度与马赫都从同一个变量读（马赫模式下该变量是马赫小数），
--      故 MT0 送整数节、MT1 按 ×100 送马赫。
--   5. 气压：参考档的显示气压值在 inHg 模式下是 29.92 这类小数、在 hPa 模式下是 1013，
--      所以两个值通道各自换算，切单位时不会读到上一次的陈旧值。
-- *****************************************************************

if ilua_require_msfs() then
	return
end
if ilua_require_headwind_a3xx() then return end

-- Do not remove below lines: hardware detection
local minifcu = com.sim.mf.MiniFCU.Open()
if not minifcu then return end
-- Do not remove above lines: hardware detection

uluaLog('MobiFlight MiniFCU for Headwind A3xx')

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
--   （QFCU 面板该键是拨杆，参考档按下写 0 / 松开写 1，语义相反，故按变量名反写）
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
-- bit 25（CHRONO）：接 FBW 代码基座的 EFIS 计时器 H 事件（同 MINIFCU_FBW_A320NX.lua，待真机确认）
minifcu:CfgRpn(25, '(>H:A32NX_EFIS_L_CHRONO_PUSHED)')

-- ROSE 模式键 [Q24–Q28]：LS/VOR/NAV/ARC/PLN → EFIS_MODE 0–4
minifcu:CfgRpn(26, '0 (>L:A32NX_FCU_EFIS_L_EFIS_MODE)')
minifcu:CfgRpn(27, '1 (>L:A32NX_FCU_EFIS_L_EFIS_MODE)')
minifcu:CfgRpn(28, '2 (>L:A32NX_FCU_EFIS_L_EFIS_MODE)')
minifcu:CfgRpn(29, '3 (>L:A32NX_FCU_EFIS_L_EFIS_MODE)')
minifcu:CfgRpn(30, '4 (>L:A32NX_FCU_EFIS_L_EFIS_MODE)')

-- 距离 [Q29–Q34]：10/20/40/80/160/320 → EFIS_RANGE 0–5
minifcu:CfgRpn(31, '0 (>L:A32NX_FCU_EFIS_L_EFIS_RANGE)')
minifcu:CfgRpn(32, '1 (>L:A32NX_FCU_EFIS_L_EFIS_RANGE)')
minifcu:CfgRpn(33, '2 (>L:A32NX_FCU_EFIS_L_EFIS_RANGE)')
minifcu:CfgRpn(34, '3 (>L:A32NX_FCU_EFIS_L_EFIS_RANGE)')
minifcu:CfgRpn(35, '4 (>L:A32NX_FCU_EFIS_L_EFIS_RANGE)')
minifcu:CfgRpn(36, '5 (>L:A32NX_FCU_EFIS_L_EFIS_RANGE)')

-- VOR/ADF 选择 1 与 2 [Q42–Q45]：QFCU 是两档拨杆（按下 / 松开各一个值），
--   miniFCU 是 ADF / OFF / VOR 三个独立按键 → 只发按下边沿，OFF 键显式写 0。
--   NAVAID_x_MODE：1 = ADF、2 = VOR（取值逐字取自参考档；OFF 取自参考档的 release 值）
minifcu:CfgRpn(37, '1 (>L:A32NX_FCU_EFIS_L_NAVAID_1_MODE)') -- ADF 1
minifcu:CfgRpn(38, '0 (>L:A32NX_FCU_EFIS_L_NAVAID_1_MODE)') -- OFF 1
minifcu:CfgRpn(39, '2 (>L:A32NX_FCU_EFIS_L_NAVAID_1_MODE)') -- VOR 1
minifcu:CfgRpn(40, '1 (>L:A32NX_FCU_EFIS_L_NAVAID_2_MODE)') -- ADF 2
minifcu:CfgRpn(41, '0 (>L:A32NX_FCU_EFIS_L_NAVAID_2_MODE)') -- OFF 2
minifcu:CfgRpn(42, '2 (>L:A32NX_FCU_EFIS_L_NAVAID_2_MODE)') -- VOR 2

-- 气压单位 [Q50]：参考档是单键拨杆（按下 = 1、松开 = 0）写 BARO_IS_INHG，
--   即 1 = inHg、0 = hPa → miniFCU 是两个独立按键（bit 43 = HPA、44 = INHG），各发一次
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

-- SPD 编码器 [Q0 / Q1]：马赫模式下走 AP_MACH_VAR（RPN 逐字取自参考档第 121–124 行）
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
-- 显示源（帧循环里直接读）

-- FCU（显示源逐条对应参考档 dev 分支里的读取变量）
local dr_is_mach    = iDataRef:New('(L:A32NX_FCU_AFS_DISPLAY_MACH_MODE)') -- 1 = 显示 MACH
local dr_spd_val    = iDataRef:New('(L:A32NX_AUTOPILOT_SPEED_SELECTED)') -- SPD 模式 = 节；MACH 模式 = 马赫
local dr_spd_dashed = iDataRef:New('(L:A32NX_FCU_SPD_MANAGED_DASHES)')
local dr_vs_val     = iDataRef:New('(L:A32NX_AUTOPILOT_VS_SELECTED)')
local dr_trkfpa     = iDataRef:New('(L:A32NX_TRK_FPA_MODE_ACTIVE)') -- 1 = TRK/FPA

-- EFIS 机长侧气压：DISPLAY_BARO_MODE STD:0 QNH:1 QFE:2；IS_INHG 1 = inHg
local dr_baro_mode  = iDataRef:New('(L:A32NX_FCU_EFIS_L_DISPLAY_BARO_MODE)')
local dr_baro_inhg  = iDataRef:New('(L:A32NX_FCU_EFIS_L_BARO_IS_INHG)')
local dr_baro_val   = iDataRef:New('(L:A32NX_FCU_EFIS_L_DISPLAY_BARO_VALUE)') -- 当前显示单位下的值

-- ===========================================================
-- OUTPUT：6 个 LED pin
minifcu:GetAp1('(L:A32NX_AUTOPILOT_1_ACTIVE)')
minifcu:GetAp2('(L:A32NX_AUTOPILOT_2_ACTIVE)')
minifcu:GetAthr('(L:A32NX_AUTOTHRUST_STATUS)') -- 0 = off，非 0 = 接通
minifcu:GetLoc('(L:A32NX_FCU_LOC_LIGHT_ON)')
minifcu:GetAppr('(L:A32NX_FCU_APPR_LIGHT_ON)')
minifcu:GetExped('(L:A32NX_FMA_EXPEDITE_MODE)')

-- ===========================================================
-- OUTPUT：miniFCU LCD（CustomDevice 24 通道 = 14 FCU + 12 EFIS）

-- MT 0 SPD 值（节）
minifcu:GetFcuSpdValue('(L:A32NX_AUTOPILOT_SPEED_SELECTED)')
-- MT 1 MACH 值（马赫 × 100）
minifcu:GetFcuMachValue('(L:A32NX_AUTOPILOT_SPEED_SELECTED)', 100)
-- MT 2 SPD/MACH 模式（1 = mach）
minifcu:GetFcuSpdMachMode('(L:A32NX_FCU_AFS_DISPLAY_MACH_MODE)')
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
-- MT 10 VS 值（fpm，TRK/FPA 模式下改为送 FPA）
minifcu:GetFcuVsValue('(L:A32NX_AUTOPILOT_VS_SELECTED)')
-- MT 11 FPA 值（FPA × 1000；源是度 → 默认 scale 1000）
minifcu:GetFcuFpaValue('(L:A32NX_AUTOPILOT_FPA_SELECTED)')
-- MT 12 VS dashed
minifcu:GetFcuVsDashes('(L:A32NX_FCU_VS_MANAGED)')
-- MT 13 HDG/TRK 模式（1 = TRK）
minifcu:GetFcuHdgTrkMode('(L:A32NX_TRK_FPA_MODE_ACTIVE)')

-- MT 0 CSTR / MT 1 WPT / MT 2 VORD / MT 3 NDB / MT 4 ARPT（EFIS_L_OPTION 位测试，与参考档同源）
minifcu:GetEfisCstr('(L:A32NX_EFIS_L_OPTION, enum) 1 ==')
minifcu:GetEfisWpt('(L:A32NX_EFIS_L_OPTION, enum) 4 ==')
minifcu:GetEfisVord('(L:A32NX_EFIS_L_OPTION, enum) 2 ==')
minifcu:GetEfisNdb('(L:A32NX_EFIS_L_OPTION, enum) 8 ==')
minifcu:GetEfisArpt('(L:A32NX_EFIS_L_OPTION, enum) 16 ==')
-- MT 5 FD / MT 6 LS
minifcu:GetFcuFdValue('(A:AUTOPILOT FLIGHT DIRECTOR ACTIVE:1, Bool)')
minifcu:GetFcuLsValue('(L:BTN_LS_1_FILTER_ACTIVE)')
-- MT 7 QNH 标签（QNH = 1）/ MT 8 STD 标志（STD = 0）
minifcu:GetEfisBaroQnnh1('(L:A32NX_FCU_EFIS_L_DISPLAY_BARO_MODE) 0 ~=')  -- 非 STD 即亮（与 xp/MINIFCU_Toliss.lua:212 约定一致）
minifcu:GetEfisBaroStd1('(L:A32NX_FCU_EFIS_L_DISPLAY_BARO_MODE) 0 ==')
-- MT 9 inHg/hPa（1 = inHg）
minifcu:GetEfisBaroInhgHpaUnit('(L:A32NX_FCU_EFIS_L_BARO_IS_INHG)')
-- MT 10 BARO inHg（×100）/ MT 11 BARO hPa（值在帧循环里换算后写入）
minifcu:GetEfisBaroInhg('(L:A32NX_FCU_EFIS_L_DISPLAY_BARO_VALUE)')
minifcu:GetEfisBaro('(L:A32NX_FCU_EFIS_L_DISPLAY_BARO_VALUE)')

-- ===========================================================
-- 帧循环

-- ===========================================================
-- 冷舱 / 熄屏 + ANN LT 测试模式（与 xp/MINIFCU_Toliss.lua 同一套做法）
-- 两个源都逐字取自本机型的 QFCU 参考档（dr_qfcu_fcu_power / dr_qfcu_fcu_test）。

-- 断电判定源：QFCU 档按「值 > 0 = 通电」工作
local dr_fcu_avail  = iDataRef:New('(L:A32NX_ELEC_AC_1_BUS_IS_POWERED, Bool)')
-- ANN LT 开关：2 = DIM / 1 = BRT / 0 = test mode → 测试态 = 0
local dr_annun_mode = iDataRef:New('(L:A32NX_OVHD_INTLT_ANN,enum)')

-- 断电 = 1 → kSetCustomDevice 32,<设备序号>,-1,0;（Connector MESSAGE_STOP 熄屏）；
-- 回 0 时插件会强制把该设备的每个通道重发一遍。Get*(path, revert=true)：
-- 源是「> 0 = 通电」，取反后通道值 1 = 熄灭。
minifcu:GetFcuPower('(L:A32NX_ELEC_AC_1_BUS_IS_POWERED, Bool)', true)
minifcu:GetEfisPower('(L:A32NX_ELEC_AC_1_BUS_IS_POWERED, Bool)', true)

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
	local spd_val  = dr_spd_val:Get()

	-- MT 2：SPD/MACH 模式
	minifcu:SetFcuSpdMachMode(is_mach >= 1 and 1 or 0)

	-- MT 1：MACH 值（参考档在马赫模式下把该变量当马赫小数用，故 ×100）
	if is_mach >= 1 and spd_dash < 1 then
		minifcu:SetFcuMachValue(math.floor(spd_val * 100 + 0.5))
	else
		minifcu:SetFcuMachValue(0)
	end

	-- MT 0：SPD 值（节；dashed 或马赫模式时置 0，与 QFCU 档的 dashes 行为一致）
	if is_mach < 1 and spd_dash < 1 then
		minifcu:SetFcuSpdValue(math.floor(spd_val + 0.5))
	else
		minifcu:SetFcuSpdValue(0)
	end

	-- MT 3 / MT 4：SPD dashed 与 managed 点
	minifcu:SetFcuSpdDashes()
	minifcu:SetFcuSpdDot()

	-- MT 5 / MT 6 / MT 7：HDG
	minifcu:SetFcuHdgValue()
	minifcu:SetFcuHdgDashes()
	minifcu:SetFcuHdgDot()

	-- MT 8 / MT 9：ALT
	minifcu:SetFcuAltValue()
	minifcu:SetFcuAltDot()

	-- MT 10 / MT 11 / MT 12：VS 与 FPA 互斥（TRK/FPA 模式下显示 FPA）
	local is_fpa = (dr_trkfpa:Get() >= 1)
	minifcu:SetFcuVsDashes()
	if is_fpa then
		minifcu:SetFcuVsValue(0)
		minifcu:SetFcuFpaValue()
	else
		minifcu:SetFcuVsValue(dr_vs_val:Get())
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

	-- 气压：STD / QNH 标签 / 单位 / 两个值通道（两个值都算，切单位时不会读到上一次的陈旧值）
	local baro_mode = dr_baro_mode:Get() -- 0 = STD，1 = QNH，2 = QFE
	local baro_inhg = dr_baro_inhg:Get() -- 1 = inHg
	local baro_val  = dr_baro_val:Get()

	minifcu:SetEfisBaroInhgHpaUnit(baro_inhg >= 1 and 1 or 0)
	minifcu:SetEfisBaroStd1(baro_mode == 0 and 1 or 0)
	minifcu:SetEfisBaroQnnh1(baro_mode == 0 and 0 or 1)  -- 非 STD 即亮；QFE 下硬件无 QFE 通道，仍显示 QNH 标签

	if baro_inhg >= 1 then
		minifcu:SetEfisBaroInhg(math.floor(baro_val * 100 + 0.5))
		minifcu:SetEfisBaro(math.floor(baro_val * 33.8638895 + 0.5))
	else
		minifcu:SetEfisBaro(math.floor(baro_val + 0.5))
		minifcu:SetEfisBaroInhg(math.floor(baro_val * 100 / 33.8638895 + 0.5))
	end
end)
