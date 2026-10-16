-- *****************************************************************
-- FlyLuaIO MobiFlight miniFCU (miniFCU + miniEFIS) for MSFS General Aviation
-- created by Wei Shuai <cpuwolf@gmail.com>
-- *****************************************************************
-- 来源与依据（可追溯）：
--   * FCU 半区 K 事件 / A 变量集合：msfs/z_QFCU_GA.lua（QFCU 的 GA 档，MSFS 实测通过），
--     每条绑定后的 [Q#] 标注该功能在 QFCU 面板上的 KeyIdx。
--   * miniEFIS 半区：QFCU 只有一个 EFIS 半区，其 GA 档映射的是 G1000 PFD
--     （AS1000_PFD_* H 事件），这里按同一约定搬到 miniFCU 的机长 EFIS 键位。
--   * 硬件通道契约：mobiflight/MiniFCU.json（按键 bit 0–46、编码器 bit 47–66）。
--   * 编码器位序 / 显示通道语义：xp/z_MINIFCU_GA.lua（真机 miniFCU 在 X-Plane 上实测）。
-- 编码器位序（沿用 XP 档，勿改）：每轴 4 bit，前 2 bit = 减，后 2 bit = 加。
--   ALT 47/48 减 · 49/50 加；SPD 51/52 · 53/54；HDG 55/56 · 57/58；VS 59/60 · 61/62；BARO 63/64 · 65/66
-- 已知取舍（待真机验证）：
--   1. 无电源门控：QFCU 档用 (A:CIRCUIT AVIONICS ON) 控制自身背光通道，miniFCU 硬件无
--      背光/熄灭通道，XP 档也没做，这里保持一致。
--   2. MT 1（MACH 值）/ MT 2（SPD/MACH 模式）：stock 机型没有“选定马赫”的可靠变量
--      （QFCU GA 档也不显示马赫），置 0 并在下面标 TODO。
--   3. MT 8（STD 标志）：stock/G1000 没有可靠的 STD 状态变量，固定 0 并标 TODO；
--      MT 7（QNH 标签）固定 1。
--   4. bit 25（CHRONO）、bit 41/42（OFF 2 / VOR 2）：QFCU GA 档没有对应 G1000 功能，
--      保持空绑定并标 TODO，避免瞎猜。
--   5. EFIS 的 CSTR/WPT/VORD/NDB/ARPT/FD/LS 这 7 个灯：GA 没有导航点过滤概念，
--      沿用 msfs/z_QFCU_GA.lua 的约定 —— 借 AP 模式标志点灯（见下方注释）。
-- *****************************************************************

if ilua_require_msfs() then
	return
end

-- Do not remove below lines: hardware detection
local minifcu = com.sim.mf.MiniFCU.Open()
if not minifcu then return end
-- Do not remove above lines: hardware detection

uluaLog('MobiFlight MiniFCU for MSFS GA')

-- ===========================================================
-- INPUT：FCU 半区（bit 0–17）

-- SPD/MACH [Q55]
minifcu:CfgRpn(0, '(>K:AP_MANAGED_SPEED_IN_MACH_TOGGLE)')
-- HDG/TRK ↔ VS/FPA [Q54]：GA 无 TRK/FPA，降级为 FD 开关
minifcu:CfgRpn(1, '(>K:TOGGLE_FLIGHT_DIRECTOR)')
-- AP1 / AP2 [Q10 / Q9]：stock 机型只有一个 AP 主开关
minifcu:CfgRpn(2, '(>K:AP_MASTER)')
minifcu:CfgRpn(3, '(>K:AP_MASTER)')
-- METRIC ALT [Q14]：GA 无米制，降级为偏航阻尼 YD
minifcu:CfgRpn(4, '(>K:YAW_DAMPER_TOGGLE)')
-- A/THR [Q11]
minifcu:CfgRpn(5, '(>K:AUTOPILOT_AUTOTHROTTLE_TOGGLE)')
-- EXPED [Q12]：GA 无加速爬升，降级为反向进近 BC
minifcu:CfgRpn(6, '(>K:AP_BC_HOLD)')
-- LOC / APPR [Q8 / Q13]
minifcu:CfgRpn(7, '(>K:AP_NAV1_HOLD)')
minifcu:CfgRpn(8, '(>K:AP_APR_HOLD)')
-- SPD PUSH [Q2]：FLC + 用当前空速设定目标；SPD PULL [Q3]：断开/接管 AP
minifcu:CfgRpn(9, '(>K:FLIGHT_LEVEL_CHANGE) (A:AIRSPEED INDICATED, knots) (>K:AP_SPD_VAR_SET)')
minifcu:CfgRpn(10, '(>K:AUTOPILOT_DISENGAGE_TOGGLE)')
-- HDG PUSH [Q6]：同步机头；HDG PULL [Q7]：HDG 保持
minifcu:CfgRpn(11, '(A:HEADING INDICATOR, degrees) (>K:HEADING_BUG_SET)')
minifcu:CfgRpn(12, '(>K:AP_PANEL_HEADING_HOLD)')
-- ALT PUSH [Q18]：高度保持；ALT PULL [Q19]：接管当前飞机高度作为目标
minifcu:CfgRpn(13, '(>K:AP_ALT_HOLD)')
minifcu:CfgRpn(14, '(A:PLANE ALTITUDE, feet) near (>K:AP_ALT_VAR_SET_ENGLISH)')
-- VS PUSH [Q22]：VS 保持；VS PULL [Q23]：接管当前垂直速度作为目标
minifcu:CfgRpn(15, '(>K:AP_PANEL_VS_HOLD)')
minifcu:CfgRpn(16, '(A:VERTICAL SPEED, feet per minute) near (>K:AP_VS_VAR_SET_ENGLISH)')
-- ALT 100/1000 [Q15]：miniFCU 是瞬时按键 —— 按住 = 1000 ft 步长，松开回 100 ft
--   （LVAR 名与 QFCU GA 档分开，避免两个设备互相覆盖）
minifcu:CfgRpn(17, '1 (>L:CPUWOLF_MINIFCU_GA_ALT1000, bool)', '0 (>L:CPUWOLF_MINIFCU_GA_ALT1000, bool)')

-- ===========================================================
-- INPUT：miniEFIS 半区（bit 18–46）→ G1000 PFD

-- 导航点过滤键 → PFD 软键 6–12 [Q35–Q41]
minifcu:CfgRpn(18, '(>H:AS1000_PFD_SOFTKEYS_6)')  -- CSTR
minifcu:CfgRpn(19, '(>H:AS1000_PFD_SOFTKEYS_7)')  -- WPT
minifcu:CfgRpn(20, '(>H:AS1000_PFD_SOFTKEYS_8)')  -- VOR D
minifcu:CfgRpn(21, '(>H:AS1000_PFD_SOFTKEYS_9)')  -- NDB
minifcu:CfgRpn(22, '(>H:AS1000_PFD_SOFTKEYS_10)') -- ARPT
minifcu:CfgRpn(23, '(>H:AS1000_PFD_SOFTKEYS_11)') -- FD
minifcu:CfgRpn(24, '(>H:AS1000_PFD_SOFTKEYS_12)') -- LS
-- bit 25 CHRONO：QFCU GA 档无对应 G1000 功能，暂不绑定（TODO：确认机型可用的事件后再补）

-- ROSE 模式键 → PFD 软键 1–5 [Q24–Q28]
minifcu:CfgRpn(26, '(>H:AS1000_PFD_SOFTKEYS_1)') -- LS
minifcu:CfgRpn(27, '(>H:AS1000_PFD_SOFTKEYS_2)') -- VOR
minifcu:CfgRpn(28, '(>H:AS1000_PFD_SOFTKEYS_3)') -- NAV
minifcu:CfgRpn(29, '(>H:AS1000_PFD_SOFTKEYS_4)') -- ARC
minifcu:CfgRpn(30, '(>H:AS1000_PFD_SOFTKEYS_5)') -- PLN

-- 距离 / 光标 [Q29–Q34]
minifcu:CfgRpn(31, '(>H:AS1000_PFD_RANGE_DEC)')      -- RANGE 10
minifcu:CfgRpn(32, '(>H:AS1000_PFD_RANGE_INC)')      -- RANGE 20
minifcu:CfgRpn(33, '(>H:AS1000_PFD_JOYSTICK_UP)')    -- RANGE 40
minifcu:CfgRpn(34, '(>H:AS1000_PFD_JOYSTICK_DOWN)')  -- RANGE 80
minifcu:CfgRpn(35, '(>H:AS1000_PFD_JOYSTICK_LEFT)')  -- RANGE 160
minifcu:CfgRpn(36, '(>H:AS1000_PFD_JOYSTICK_RIGHT)') -- RANGE 320

-- VOR/ADF 选择键 → PFD 功能键 [Q42–Q45]
minifcu:CfgRpn(37, '(>H:AS1000_PFD_DIRECTTO)') -- ADF 1
minifcu:CfgRpn(38, '(>H:AS1000_PFD_FPL_Push)') -- OFF 1
minifcu:CfgRpn(39, '(>H:AS1000_PFD_PROC_Push)') -- VOR 1
minifcu:CfgRpn(40, '(>H:AS1000_PFD_MENU_Push)') -- ADF 2
-- bit 41 / 42（OFF 2 / VOR 2）：QFCU GA 档的 4 个功能键已用完，暂不绑定
-- （TODO：需要时映射到 AS1000_PFD_ENT_Push / CLR_Push 之类，先确认机型支持）

-- 气压单位（Asobo G1000 变量：1 = hPa，0 = inHg）
minifcu:CfgRpn(43, '1 (>L:XMLVAR_Baro_Selector_HPA_1, bool)') -- HPA
minifcu:CfgRpn(44, '0 (>L:XMLVAR_Baro_Selector_HPA_1, bool)') -- INHG
-- 气压旋钮拉（回到真实 QNH，mbars×16）/ 按（STD 29.92）[Q49 / Q48]
minifcu:CfgRpn(45, '(A:SEA LEVEL PRESSURE, millibars) 16 * (>K:KOHLSMAN_SET)')
minifcu:CfgRpn(46, '(>K:BAROMETRIC_STD_PRESSURE)')

-- ===========================================================
-- INPUT：编码器（bit 47–66）

-- ALT 编码器 [Q16 / Q17]：步长由 bit 17 的瞬时状态决定
minifcu:CfgRpn(47, '(L:CPUWOLF_MINIFCU_GA_ALT1000, bool) if{ 1000 } els{ 100 } (>K:AP_ALT_VAR_DEC)')
minifcu:CfgRpn(48, '(L:CPUWOLF_MINIFCU_GA_ALT1000, bool) if{ 1000 } els{ 100 } (>K:AP_ALT_VAR_DEC)')
minifcu:CfgRpn(49, '(L:CPUWOLF_MINIFCU_GA_ALT1000, bool) if{ 1000 } els{ 100 } (>K:AP_ALT_VAR_INC)')
minifcu:CfgRpn(50, '(L:CPUWOLF_MINIFCU_GA_ALT1000, bool) if{ 1000 } els{ 100 } (>K:AP_ALT_VAR_INC)')

-- SPD 编码器 [Q0 / Q1]
minifcu:CfgRpn(51, '(>K:AP_SPD_VAR_DEC)')
minifcu:CfgRpn(52, '(>K:AP_SPD_VAR_DEC)')
minifcu:CfgRpn(53, '(>K:AP_SPD_VAR_INC)')
minifcu:CfgRpn(54, '(>K:AP_SPD_VAR_INC)')

-- HDG 编码器 [Q4 / Q5]
minifcu:CfgRpn(55, '1 (>K:HEADING_BUG_DEC)')
minifcu:CfgRpn(56, '1 (>K:HEADING_BUG_DEC)')
minifcu:CfgRpn(57, '1 (>K:HEADING_BUG_INC)')
minifcu:CfgRpn(58, '1 (>K:HEADING_BUG_INC)')

-- VS 编码器 [Q20 / Q21]：与源 z_QFCU_GA.lua 逐字一致（按当前 AP 垂直模式分流）
local vs_dec_rpn = '(A:AUTOPILOT VERTICAL HOLD, Bool) if{ (>K:AP_VS_VAR_DEC) (>H:AP_UP) } (A:AUTOPILOT FLIGHT LEVEL CHANGE, Bool) if{ (>K:AP_SPD_VAR_INC) } (A:AUTOPILOT PITCH HOLD, Bool) if{ (>K:AP_PITCH_REF_INC_DN) }'
local vs_inc_rpn = '(A:AUTOPILOT VERTICAL HOLD, Bool) if{ (>K:AP_VS_VAR_INC) (>H:AP_DN) } (A:AUTOPILOT FLIGHT LEVEL CHANGE, Bool) if{ (>K:AP_SPD_VAR_DEC) } (A:AUTOPILOT PITCH HOLD, Bool) if{ (>K:AP_PITCH_REF_INC_UP) }'
minifcu:CfgRpn(59, vs_dec_rpn)
minifcu:CfgRpn(60, vs_dec_rpn)
minifcu:CfgRpn(61, vs_inc_rpn)
minifcu:CfgRpn(62, vs_inc_rpn)

-- BARO 编码器 [Q46 / Q47]
minifcu:CfgRpn(63, '(>H:AS1000_PFD_BARO_DEC)')
minifcu:CfgRpn(64, '(>H:AS1000_PFD_BARO_DEC)')
minifcu:CfgRpn(65, '(>H:AS1000_PFD_BARO_INC)')
minifcu:CfgRpn(66, '(>H:AS1000_PFD_BARO_INC)')

-- ===========================================================
-- 显示源（帧循环里直接读）

-- FCU 数字显示
local d_spd     = iDataRef:New('(A:AUTOPILOT AIRSPEED HOLD VAR, knot)')
local d_hdg     = iDataRef:New('(A:AUTOPILOT HEADING LOCK DIR, Degrees)')
local d_vs      = iDataRef:New('(A:AUTOPILOT VERTICAL HOLD VAR, Feet/minute)')
local d_vs_hold = iDataRef:New('(A:AUTOPILOT VERTICAL HOLD, Bool)')

-- 气压：inHg 两位小数 / hPa 整数（表达式与本仓 GA 档同源）
local d_baro_inhg = iDataRef:New('(A:KOHLSMAN SETTING HG, inHg)')
-- 单位选择变量只在 Asobo G1000 上存在；缺失时按 inHg 显示
local d_baro_hpa_unit = iDataRef:New('(L:XMLVAR_Baro_Selector_HPA_1, bool)')

-- ===========================================================
-- OUTPUT：6 个 LED pin
-- GA 只有一套 AP：AP1/AP2 都跟主开关，LOC/EXPED 跟 NAV1/LEVEL CHANGE
minifcu:GetAp1('(A:AUTOPILOT MASTER, Bool)')
minifcu:GetAp2('(A:AUTOPILOT MASTER, Bool)')
minifcu:GetAthr('(A:AUTOTHROTTLE ACTIVE, Bool)')
minifcu:GetLoc('(A:AUTOPILOT NAV1 LOCK, Bool)')
minifcu:GetAppr('(A:AUTOPILOT APPROACH HOLD, Bool)')
minifcu:GetExped('(A:AUTOPILOT FLIGHT LEVEL CHANGE, Bool)')

-- ===========================================================
-- OUTPUT：miniFCU LCD（14 FCU + 12 EFIS 通道全部保留）

-- MT 0 SPD 值（kts；未选择速度时由 MT 3 走 dashed）
minifcu:GetFcuSpdValue('(A:AUTOPILOT AIRSPEED HOLD VAR, knot)')
-- MT 1 MACH 值 —— TODO：stock 机型无“选定马赫”变量，固定 0（QFCU GA 档也不显示马赫）
minifcu:GetFcuMachValue('(A:AUTOPILOT AIRSPEED HOLD VAR, knot)')
-- MT 2 SPD/MACH 模式 —— TODO：同上，固定 0（显示 SPD 标签）
minifcu:GetFcuSpdMachMode('(A:AUTOPILOT AIRSPEED HOLD VAR, knot)')
-- MT 3 SPD dashed（未选择速度 = 0 时显示虚线，与 QFCU GA 档同判据）
minifcu:GetFcuSpdDashes('(A:AUTOPILOT AIRSPEED HOLD VAR, knot)')
-- MT 4 SPD managed 点：GA 无 managed 概念，帧循环里写 0
minifcu:GetFcuSpdDot('(A:AUTOPILOT AIRSPEED HOLD VAR, knot)')
-- MT 5 HDG 值
minifcu:GetFcuHdgValue('(A:AUTOPILOT HEADING LOCK DIR, Degrees)')
-- MT 6 HDG dashed：GA 无虚线，帧循环里写 0
minifcu:GetFcuHdgDashes('(A:AUTOPILOT HEADING LOCK DIR, Degrees)')
-- MT 7 HDG managed 点：帧循环里写 0
minifcu:GetFcuHdgDot('(A:AUTOPILOT HEADING LOCK DIR, Degrees)')
-- MT 8 ALT 值（ft / 100）
minifcu:GetFcuAltValue('(A:AUTOPILOT ALTITUDE LOCK VAR, Feet)', 0.01)
-- MT 9 ALT managed 点：帧循环里写 0
minifcu:GetFcuAltDot('(A:AUTOPILOT ALTITUDE LOCK VAR, Feet)')
-- MT 10 VS 值（仅 VS 保持时显示，否则 MT 12 走 dashed）
minifcu:GetFcuVsValue('(A:AUTOPILOT VERTICAL HOLD VAR, Feet/minute)')
-- MT 11 FPA 值：GA 无 FPA，帧循环里写 0
minifcu:GetFcuFpaValue('(A:AUTOPILOT VERTICAL HOLD VAR, Feet/minute)')
-- MT 12 VS dashed（未保持 VS 时显示虚线）
minifcu:GetFcuVsDashes('(A:AUTOPILOT VERTICAL HOLD, Bool)')
-- MT 13 HDG/TRK 模式：GA 无 TRK，帧循环里写 0
minifcu:GetFcuHdgTrkMode('(A:AUTOPILOT HEADING LOCK DIR, Degrees)')

-- EFIS LED：GA 没有导航点过滤灯，沿用 msfs/z_QFCU_GA.lua 的约定，借 AP 模式标志点灯
minifcu:GetEfisCstr('(A:AUTOPILOT ALTITUDE LOCK, Bool)')            -- CSTR ← ALT 保持
minifcu:GetEfisWpt('(A:AUTOPILOT VERTICAL HOLD, Bool)')             -- WPT  ← VS 保持
minifcu:GetEfisVord('(A:AUTOPILOT HEADING LOCK, Bool)')             -- VOR D ← HDG 保持
minifcu:GetEfisNdb('(A:AUTOPILOT FLIGHT LEVEL CHANGE, Bool)')       -- NDB  ← FLC
minifcu:GetEfisArpt('(A:AUTOPILOT NAV1 LOCK, Bool)')                -- ARPT ← NAV1 截获
minifcu:GetFcuFdValue('(A:AUTOPILOT FLIGHT DIRECTOR ACTIVE:1, Bool)')
minifcu:GetFcuLsValue('(A:AUTOPILOT APPROACH HOLD, Bool)')          -- LS ← APPR
-- MT 7 QNH 标签：GA 固定 1（始终 QNH），帧循环里写
minifcu:GetEfisBaroQnnh1('(A:KOHLSMAN SETTING HG, inHg)')
-- MT 8 STD 标志 —— TODO：stock/G1000 无可靠 STD 状态变量，固定 0
minifcu:GetEfisBaroStd1('(A:KOHLSMAN SETTING HG, inHg)')
-- MT 9 inHg/hPa（1 = inHg）；变量可能不存在，帧循环里兜底
minifcu:GetEfisBaroInhgHpaUnit('(L:XMLVAR_Baro_Selector_HPA_1, bool)')
-- MT 10 BARO inHg（×100）/ MT 11 BARO hPa —— 两个值都在帧循环里从 inHg 现算
minifcu:GetEfisBaroInhg('(A:KOHLSMAN SETTING HG, inHg)')
minifcu:GetEfisBaro('(A:KOHLSMAN SETTING HG, inHg)')

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
	local spd = d_spd:Get()
	local vs  = d_vs:Get()
	local vs_hold = d_vs_hold:Get()

	-- 未选择速度 → 虚线（判据与 msfs/z_QFCU_GA.lua 一致：AP 速度变量为 0 即未选择）
	local spd_selected = (spd > 0)
	if spd_selected then
		minifcu:SetFcuSpdValue(math.floor(spd + 0.5))
		minifcu:SetFcuSpdDashes(0)
	else
		minifcu:SetFcuSpdValue(0)
		minifcu:SetFcuSpdDashes(1)
	end

	-- MT 1 / MT 2 / MT 4：GA 无马赫与 managed，固定 0
	minifcu:SetFcuMachValue(0)
	minifcu:SetFcuSpdMachMode(0)
	minifcu:SetFcuSpdDot(0)

	-- MT 5 / MT 6 / MT 7：HDG（GA 无虚线、无 managed 点）
	minifcu:SetFcuHdgValue()
	minifcu:SetFcuHdgDashes(0)
	minifcu:SetFcuHdgDot(0)

	-- MT 8 / MT 9：ALT（GA 无 managed 点）
	minifcu:SetFcuAltValue()
	minifcu:SetFcuAltDot(0)

	-- MT 10 / MT 11 / MT 12：VS 与 FPA（GA 无 FPA）
	minifcu:SetFcuFpaValue(0)
	if vs_hold > 0 then
		minifcu:SetFcuVsValue(vs)
		minifcu:SetFcuVsDashes(0)
	else
		minifcu:SetFcuVsValue(0)
		minifcu:SetFcuVsDashes(1)
	end

	-- MT 13：GA 无 TRK
	minifcu:SetFcuHdgTrkMode(0)

	-- ---- EFIS 半区 ----
	minifcu:SetEfisCstr()
	minifcu:SetEfisWpt()
	minifcu:SetEfisVord()
	minifcu:SetEfisNdb()
	minifcu:SetEfisArpt()
	minifcu:SetFcuFdValue()
	minifcu:SetFcuLsValue()

	-- 气压：单位 / STD / QNH 标签 + 两个值通道（都算，切单位时不会读到上一次的陈旧值）
	local baro_inhg = d_baro_inhg:Get()
	local hpa_unit = 0
	if d_baro_hpa_unit ~= nil then
		hpa_unit = d_baro_hpa_unit:Get() -- 1 = 显示 hPa
	end

	-- MT 9：1 = inHg（变量不存在时按 inHg 显示，与 QFCU GA 档注释一致）
	minifcu:SetEfisBaroInhgHpaUnit(hpa_unit >= 1 and 0 or 1)
	-- MT 8 / MT 7：GA 固定“非 STD / QNH”
	minifcu:SetEfisBaroStd1(0)
	minifcu:SetEfisBaroQnnh1(1)
	-- MT 10 / MT 11
	minifcu:SetEfisBaroInhg(math.floor(baro_inhg * 100 + 0.5))
	minifcu:SetEfisBaro(math.floor(baro_inhg * 33.8638895 + 0.5))
end)
