-- *****************************************************************
-- FlyLuaIO MobiFlight MiniFCU (miniFCU + miniEFIS) for X-Plane
-- FlightFactor A320 Ultimate（FF320）
-- created by Wei Shuai <cpuwolf@gmail.com>
-- *****************************************************************
-- 来源与依据（可追溯）：
--   * 按键 / 显示源：xp/QFCU_FF320.lua（QFCU 同机型档，FF320 v1.7.2-2692 上实测）
--     ——每条绑定后的 [Q#] 标注该功能在 QFCU 面板上的 KeyIdx，便于逐条对照。
--   * 硬件通道契约：mobiflight/MiniFCU.json（按键 bit 0–46 + 67、编码器 bit 47–66、6 个 Output pin、
--     26 条 CustomDevice 通道）。
--   * 设备 API：com/sim/mf/MiniFCU.lua。
--   * 通道语义 / 编码器位序：xp/MINIFCU_Toliss.lua（真机 miniFCU 在 X-Plane 上实测过）。
--   * 通道数值量纲：由 QFCU 档的 HID 写入换算反推（见下方每条注释），QFCU 档在 FF320 上是实测过的。
-- 编码器位序（勿改）：每轴 4 bit，前 2 bit = 减，后 2 bit = 加。
--   ALT 47/48 减 · 49/50 加；SPD 51/52 · 53/54；HDG 55/56 · 57/58；VS 59/60 · 61/62；BARO 63/64 · 65/66
--
-- ★ 前提：FF320 只向第三方插件公开 publish.txt 里列出的 dataref。
--   本档读取的 a320/Aircraft/FMGS/FCU1/* 全部已包含在 qtifw-qmdev 的
--   packages/com.cpuwolf.ff320/data/tmp/ff320/publish.txt 中（安装包会写进 FF320 的 data/publish.txt），
--   与 QFCU 档的需求完全一致，不需要额外加行。
--
-- ★ 与 QFCU 档的差异（逐条给出依据，实机复核时对照这一节）：
--   1. 副驾驶半区不移植：QFCU 的 EFIS FO（KeyIdx 51–53、56–79）在 miniFCU 上只有机长侧一套
--      → 本档只做 EFIS 左半区（QFCU 24–50）。
--   2. ADF / OFF / VOR [Q42–Q45]：QFCU 是两档拨杆（按下 = ADF/VOR，松开 = OFF），
--      miniFCU 是 3 个独立键 → 三键各写自己的 enum 值 ADF=0 / OFF=1 / VOR=2，OFF 键显式写 1。
--   3. BARO 单位 [Q50]：QFCU 是拨杆（按下 0 = inHg，松开 1 = hPa），miniFCU 是独立的两键
--      → bit43(hPa) 写 1、bit44(inHg) 写 0。
--   4. ALT 100/1000 [Q15]：QFCU 按下 0 / 松开 1；miniFCU 语义相反（按住 = 1000 ft）
--      → CfgVal(17, FCU_AltitudeStep, 1, 0)，即按住 = 1（1000 ft），松开 = 0（100 ft）。
--      依据 a320/Panel/FCU_AltitudeStep 的取值约定 0 = 100 ft、1 = 1000 ft（QFCU 档按下 0 即 100 ft）。
--   5. SPD / HDG / ALT / VS 的 dash + managed 点：QFCU 用 HID mode 枚举一次性表达，miniFCU 拆成
--      dashes / dot 两条通道 → 由 FF 的 *Managed 三态（-1 预选 / 0 手动 / 1 managed）在帧循环里换算：
--      dashes = (v == 1)，dot = (v ~= 0)，与 A320 真机「managed 显示虚线 + 点、预选显示数值 + 点」一致。
--   6. ALT 没有 dashes 通道（MiniFCU.json 的 26 条 CustomDevice 里就没有 ALT dashes），
--      managed 只由 MT9 点体现（与 xp/MINIFCU_XP_A333.lua 的同一取舍）。
--   7. EXPED [Q12]：FF320 有 ExpediteLight，直接取灯。
--   8. 不做断电 / 背光门控：QFCU 档按 a320/Panel/LightShield 等信标做亮度与小屏熄灭，miniFCU
--      硬件没有背光 / 熄灭通道（与 xp/MINIFCU_Toliss.lua、x/MINIFCU_XP_A333.lua 一致）。
--   9. ROSE 模式键 [Q24–Q28]：FF320 的 EFIS_NavModeL 只有 0..4 五档（A320 的 ROSE 无第 6 档 ENG），
--      miniFCU 的 bit67 ROSE_HIDDEN 在该机型上没有对应档位 → 不绑。
--  10. bit 25（CHRONO）：QFCU 面板没有这个键，本档也不绑（FF320 的 chrono 命令名未查实，
--      FF320 未安装在本机，无法从 xlua/obj 核对；查到后在这里补一条 CfgCmd 即可）→ TODO。
--
-- 已知待实机复核（QFCU 档反推的量纲，本机没装 FF320，无法从飞机自带脚本核对）：
--   * MT11 FPA：QFCU 档把 TRK/FPA 模式下的 a320/Aircraft/FMGS/FCU1/Vertical 写成 abs(v)*100 进
--     vs_trkval 通道（该通道量纲为 FPA×1000）→ 推断 Vertical 在 FPA 模式下的量纲是 FPA×10，
--     故这里取 scale 100（得到 FPA×1000）。若实机显示差 10 倍，改这一处 scale 即可。
--   * MT0–MT4 EFIS 导航点过滤灯：QFCU 档用 ternary(NavTypeL, 1/2/4/8/16) 判断，即把 NavTypeL 当
--     位掩码用（而它自己的注释写「1:CSTR 2:WPT 3:VORD 4:NDB 5:APRT」，两者矛盾，注释更可能是错的）。
--     本档按位掩码实现（= QFCU 实际行为）；若实机灯不亮/乱亮，说明它是枚举，把 filterbit() 换成等值判断。
-- *****************************************************************

if ilua_require_ff320() then return end

-- Do not remove below lines: hardware detection
local minifcu = com.sim.mf.MiniFCU.Open()
if not minifcu then return end
-- Do not remove above lines: hardware detection

uluaLog('MobiFlight MiniFCU for FlightFactor A320')

-- ===================== DataRefs（帧循环里要读原值和换算的几个） =====================

local dr_speed       = iDataRef:New("a320/Aircraft/FMGS/FCU1/Speed")        -- SPD 模式 = kts；MACH 模式 = 马赫×100
local dr_is_mach     = iDataRef:New("a320/Aircraft/FMGS/FCU1/SpeedIsMach")  -- 1 = MACH
local dr_spd_managed = iDataRef:New("a320/Aircraft/FMGS/FCU1/SpeedManaged") -- -1 预选 / 0 手动 / 1 managed
local dr_hdg         = iDataRef:New("a320/Aircraft/FMGS/FCU1/Lateral")      -- 度
local dr_hdg_managed = iDataRef:New("a320/Aircraft/FMGS/FCU1/LateralManaged")
local dr_alt         = iDataRef:New("a320/Aircraft/FMGS/FCU1/Altitude")     -- 单位 = 100 ft
local dr_alt_managed = iDataRef:New("a320/Aircraft/FMGS/FCU1/AltitudeManaged")
local dr_vs          = iDataRef:New("a320/Aircraft/FMGS/FCU1/Vertical")     -- 单位 = 100 fpm（FPA 模式 = FPA×10）
local dr_vs_managed  = iDataRef:New("a320/Aircraft/FMGS/FCU1/VerticalManaged")
local dr_trkmode     = iDataRef:New("a320/Aircraft/FMGS/FCU1/Mode")         -- 0 = HDG/VS, 1 = TRK/FPA
local dr_navtype     = iDataRef:New("a320/Aircraft/FMGS/FCU1/NavTypeL")     -- 导航点过滤（位掩码，见文件头）
local dr_baro        = iDataRef:New("a320/Aircraft/FMGS/FCU1/BaroL")        -- 当前显示单位的数值
local dr_baro_unit   = iDataRef:New("a320/Aircraft/FMGS/FCU1/BaroTypeL")    -- 0 = inHg, 1 = hPa
local dr_baro_mode   = iDataRef:New("a320/Aircraft/FMGS/FCU1/BaroModeL")    -- 1 = QFE, 2 = QNH, <=0 = STD

-- ===================== INPUT：FCU 半区（bit 0–17） =====================

-- SPD/MACH 显示切换 [Q55]
minifcu:CfgCmd(0, "a320/Panel/FCU_Mach_button")
-- HDG/TRK ↔ VS/FPA 切换 [Q54]
minifcu:CfgCmd(1, "a320/Panel/FCU_Mode_button")
-- AP1 [Q10]
minifcu:CfgCmd(2, "a320/Panel/FCU_AutoPilot1_button")
-- AP2 [Q9]
minifcu:CfgCmd(3, "a320/Panel/FCU_AutoPilot2_button")
-- METRIC ALT [Q14]
minifcu:CfgCmd(4, "a320/Panel/FCU_Metric_button")
-- A/THR [Q11]
minifcu:CfgCmd(5, "a320/Panel/FCU_AutoThrust_button")
-- EXPED [Q12]
minifcu:CfgCmd(6, "a320/Panel/FCU_Expedite_button")
-- LOC [Q8]
minifcu:CfgCmd(7, "a320/Panel/FCU_Localizer_button")
-- APPR [Q13]
minifcu:CfgCmd(8, "a320/Panel/FCU_Approach_button")
-- SPD PUSH / PULL [Q2 / Q3]
minifcu:CfgCmd(9, "a320/Panel/FCU_SpeedMode_switch_push")
minifcu:CfgCmd(10, "a320/Panel/FCU_SpeedMode_switch_pull")
-- HDG PUSH / PULL [Q6 / Q7]
minifcu:CfgCmd(11, "a320/Panel/FCU_LateralMode_switch_push")
minifcu:CfgCmd(12, "a320/Panel/FCU_LateralMode_switch_pull")
-- ALT PUSH / PULL [Q18 / Q19]
minifcu:CfgCmd(13, "a320/Panel/FCU_AltitudeMode_switch_push")
minifcu:CfgCmd(14, "a320/Panel/FCU_AltitudeMode_switch_pull")
-- VS PUSH / PULL [Q22 / Q23]
minifcu:CfgCmd(15, "a320/Panel/FCU_VerticalMode_switch_push")
minifcu:CfgCmd(16, "a320/Panel/FCU_VerticalMode_switch_pull")
-- ALT 100/1000 [Q15]：miniFCU 是瞬时键 —— 按住 = 1000 ft，松开 = 100 ft（见文件头第 4 条）
minifcu:CfgVal(17, "a320/Panel/FCU_AltitudeStep", 1, 0)

-- ===================== INPUT：EFIS 半区机长侧（bit 18–46） =====================

-- 导航点过滤键 [Q35–Q39]
minifcu:CfgCmd(18, "a320/Panel/EFIS_NavType1L_button") -- CSTR
minifcu:CfgCmd(19, "a320/Panel/EFIS_NavType2L_button") -- WPT
minifcu:CfgCmd(20, "a320/Panel/EFIS_NavType3L_button") -- VORD
minifcu:CfgCmd(21, "a320/Panel/EFIS_NavType4L_button") -- NDB
minifcu:CfgCmd(22, "a320/Panel/EFIS_NavType5L_button") -- ARPT
-- FD [Q40]
minifcu:CfgCmd(23, "a320/Panel/EFIS_FlightDirL_button")
-- LS [Q41]
minifcu:CfgCmd(24, "a320/Panel/EFIS_LandSysL_button")
-- CHRONO（bit 25）：FF320 的 chrono 命令名未查实 → 暂不绑（见文件头第 10 条）

-- ROSE 模式键 [Q24–Q28]：0=LS 1=VOR 2=NAV 3=ARC 4=PLAN（FF320 无第 6 档 → bit67 不绑）
minifcu:CfgVal(26, "a320/Panel/EFIS_NavModeL", 0) -- ROSE LS
minifcu:CfgVal(27, "a320/Panel/EFIS_NavModeL", 1) -- ROSE VOR
minifcu:CfgVal(28, "a320/Panel/EFIS_NavModeL", 2) -- ROSE NAV
minifcu:CfgVal(29, "a320/Panel/EFIS_NavModeL", 3) -- ROSE ARC
minifcu:CfgVal(30, "a320/Panel/EFIS_NavModeL", 4) -- ROSE PLAN

-- 距离 [Q29–Q34]：10/20/40/80/160/320 NM → EFIS_NavRangeL 0..5
minifcu:CfgVal(31, "a320/Panel/EFIS_NavRangeL", 0)
minifcu:CfgVal(32, "a320/Panel/EFIS_NavRangeL", 1)
minifcu:CfgVal(33, "a320/Panel/EFIS_NavRangeL", 2)
minifcu:CfgVal(34, "a320/Panel/EFIS_NavRangeL", 3)
minifcu:CfgVal(35, "a320/Panel/EFIS_NavRangeL", 4)
minifcu:CfgVal(36, "a320/Panel/EFIS_NavRangeL", 5)

-- VOR/ADF 选择 1 与 2 [Q42–Q45]：miniFCU 是 ADF / OFF / VOR 三个独立键 → 各写自己的值（见文件头第 2 条）
minifcu:CfgVal(37, "a320/Panel/EFIS_NavReciver1L", 0) -- ADF 1
minifcu:CfgVal(38, "a320/Panel/EFIS_NavReciver1L", 1) -- OFF 1
minifcu:CfgVal(39, "a320/Panel/EFIS_NavReciver1L", 2) -- VOR 1
minifcu:CfgVal(40, "a320/Panel/EFIS_NavReciver2L", 0) -- ADF 2
minifcu:CfgVal(41, "a320/Panel/EFIS_NavReciver2L", 1) -- OFF 2
minifcu:CfgVal(42, "a320/Panel/EFIS_NavReciver2L", 2) -- VOR 2

-- 气压单位 [Q50]：0 = inHg, 1 = hPa（见文件头第 3 条）
minifcu:CfgVal(43, "a320/Panel/EFIS_BaroTypeL", 1) -- hPa
minifcu:CfgVal(44, "a320/Panel/EFIS_BaroTypeL", 0) -- inHg
-- 气压旋钮拉 / 按 [Q49 / Q48]
minifcu:CfgCmd(45, "a320/Panel/EFIS_BaroModeL_switch_pull")
minifcu:CfgCmd(46, "a320/Panel/EFIS_BaroModeL_switch_push")

-- ===================== INPUT：编码器（bit 47–66） =====================

-- ALT 编码器 [Q16 / Q17]
minifcu:CfgCmd(47, "a320/Panel/FCU_Altitude_switch-")
minifcu:CfgCmd(48, "a320/Panel/FCU_Altitude_switch-")
minifcu:CfgCmd(49, "a320/Panel/FCU_Altitude_switch+")
minifcu:CfgCmd(50, "a320/Panel/FCU_Altitude_switch+")

-- SPD 编码器 [Q0 / Q1]
minifcu:CfgCmd(51, "a320/Panel/FCU_Speed_switch-")
minifcu:CfgCmd(52, "a320/Panel/FCU_Speed_switch-")
minifcu:CfgCmd(53, "a320/Panel/FCU_Speed_switch+")
minifcu:CfgCmd(54, "a320/Panel/FCU_Speed_switch+")

-- HDG 编码器 [Q4 / Q5]
minifcu:CfgCmd(55, "a320/Panel/FCU_Lateral_switch-")
minifcu:CfgCmd(56, "a320/Panel/FCU_Lateral_switch-")
minifcu:CfgCmd(57, "a320/Panel/FCU_Lateral_switch+")
minifcu:CfgCmd(58, "a320/Panel/FCU_Lateral_switch+")

-- VS 编码器 [Q20 / Q21]（TRK/FPA 模式下 FF320 自己把这条命令解释为 FPA +/-）
minifcu:CfgCmd(59, "a320/Panel/FCU_Vertical_switch-")
minifcu:CfgCmd(60, "a320/Panel/FCU_Vertical_switch-")
minifcu:CfgCmd(61, "a320/Panel/FCU_Vertical_switch+")
minifcu:CfgCmd(62, "a320/Panel/FCU_Vertical_switch+")

-- BARO 编码器 [Q46 / Q47]：绑满 4 bit；若实机一格走两格，注释掉 64 / 66 两行
minifcu:CfgCmd(63, "a320/Panel/EFIS_BaroL_switch-")
minifcu:CfgCmd(64, "a320/Panel/EFIS_BaroL_switch-")
minifcu:CfgCmd(65, "a320/Panel/EFIS_BaroL_switch+")
minifcu:CfgCmd(66, "a320/Panel/EFIS_BaroL_switch+")

-- ===================== OUTPUT：6 个 LED pin =====================

minifcu:GetAp1("a320/Aircraft/FMGS/FCU1/AutoPilotLight1")
minifcu:GetAp2("a320/Aircraft/FMGS/FCU1/AutoPilotLight2")
minifcu:GetAthr("a320/Aircraft/FMGS/FCU1/AutoThrustLight")
minifcu:GetLoc("a320/Aircraft/FMGS/FCU1/LocalizerLight")
minifcu:GetAppr("a320/Aircraft/FMGS/FCU1/ApproachLight")
minifcu:GetExped("a320/Aircraft/FMGS/FCU1/ExpediteLight")

-- ============ OUTPUT：miniFCU LCD（CustomDevice，14 条） ============

-- MT 0 SPD 值（kts；MACH 模式或虚线时由帧循环置 0）
minifcu:GetFcuSpdValue("a320/Aircraft/FMGS/FCU1/Speed")
-- MT 1 MACH 值（源已是马赫×100；SPD 模式或虚线时由帧循环置 0）
minifcu:GetFcuMachValue("a320/Aircraft/FMGS/FCU1/Speed", 1)
-- MT 2 SPD/MACH 模式（1 = mach）
minifcu:GetFcuSpdMachMode("a320/Aircraft/FMGS/FCU1/SpeedIsMach")
-- MT 3 SPD 虚线（*Managed == 1 才是 managed 虚线）
minifcu:GetFcuSpdDashes("a320/Aircraft/FMGS/FCU1/SpeedManaged")
-- MT 4 SPD managed 点（*Managed ~= 0：预选与 managed 都点）
minifcu:GetFcuSpdDot("a320/Aircraft/FMGS/FCU1/SpeedManaged")
-- MT 5 HDG 值（360 → 0 由面板处理）
minifcu:GetFcuHdgValue("a320/Aircraft/FMGS/FCU1/Lateral")
-- MT 6 HDG 虚线
minifcu:GetFcuHdgDashes("a320/Aircraft/FMGS/FCU1/LateralManaged")
-- MT 7 HDG managed 点
minifcu:GetFcuHdgDot("a320/Aircraft/FMGS/FCU1/LateralManaged")
-- MT 8 ALT 值（源单位 = 100 ft → 通道要 ft/100，故 scale 1）
minifcu:GetFcuAltValue("a320/Aircraft/FMGS/FCU1/Altitude", 1)
-- MT 9 ALT managed 点
minifcu:GetFcuAltDot("a320/Aircraft/FMGS/FCU1/AltitudeManaged")
-- MT 10 VS 值（源单位 = 100 fpm → ×100 得 fpm；TRK/FPA 模式下由帧循环置 0）
minifcu:GetFcuVsValue("a320/Aircraft/FMGS/FCU1/Vertical", 100)
-- MT 11 FPA 值（通道量纲 FPA×1000；见文件头「待实机复核」）
minifcu:GetFcuFpaValue("a320/Aircraft/FMGS/FCU1/Vertical", 100)
-- MT 12 VS 虚线
minifcu:GetFcuVsDashes("a320/Aircraft/FMGS/FCU1/VerticalManaged")
-- MT 13 HDG/TRK 模式（1 = TRK）
minifcu:GetFcuHdgTrkMode("a320/Aircraft/FMGS/FCU1/Mode")

-- ============ OUTPUT：miniEFIS LED 与 LCD（CustomDevice，12 条） ============

-- MT 0–4：CSTR / WPT / VORD / NDB / ARPT（NavTypeL 位掩码，见文件头「待实机复核」）
minifcu:GetEfisCstr("a320/Aircraft/FMGS/FCU1/NavTypeL")
minifcu:GetEfisWpt("a320/Aircraft/FMGS/FCU1/NavTypeL")
minifcu:GetEfisVord("a320/Aircraft/FMGS/FCU1/NavTypeL")
minifcu:GetEfisNdb("a320/Aircraft/FMGS/FCU1/NavTypeL")
minifcu:GetEfisArpt("a320/Aircraft/FMGS/FCU1/NavTypeL")
-- MT 5 / MT 6：FD / LS（FlightDirL 0 = 亮 → revert）
minifcu:GetFcuFdValue("a320/Aircraft/FMGS/FCU1/FlightDirL", true)
minifcu:GetFcuLsValue("a320/Aircraft/FMGS/FCU1/LandSysL")
-- MT 7 QNH 标签（非 STD 即亮）/ MT 8 STD 标志（1 = STD）
minifcu:GetEfisBaroQnnh1("a320/Aircraft/FMGS/FCU1/BaroModeL")
minifcu:GetEfisBaroStd1("a320/Aircraft/FMGS/FCU1/BaroModeL", true)
-- MT 9 单位（1 = inHg；BaroTypeL 0 = inHg → 帧循环里取反）
minifcu:GetEfisBaroInhgHpaUnit("a320/Aircraft/FMGS/FCU1/BaroTypeL")
-- MT 10 BARO inHg（×100）/ MT 11 BARO hPa（BaroL 随单位变化，两个值都在帧循环里算）
minifcu:GetEfisBaroInhg("a320/Aircraft/FMGS/FCU1/BaroL")
minifcu:GetEfisBaro("a320/Aircraft/FMGS/FCU1/BaroL")

-- ===================== 帧循环 =====================

-- NavTypeL 位掩码 → 单个过滤灯的亮灭（见文件头「待实机复核」）
local function filterbit(val, mask)
	if val >= mask and math.floor(val) % (mask * 2) >= mask then
		return 1
	end
	return 0
end

GlobalFrameLoopManager:add(function()
	-- ---- 6 个 LED pin ----
	minifcu:SetAp1()
	minifcu:SetAp2()
	minifcu:SetAthr()
	minifcu:SetLoc()
	minifcu:SetAppr()
	minifcu:SetExped()

	-- ---- FCU LCD：SPD / MACH ----
	local is_mach = dr_is_mach:Get()
	local spd_managed = dr_spd_managed:Get()
	local spd_val = dr_speed:Get()

	minifcu:SetFcuSpdMachMode()

	if spd_managed == 1 then
		-- managed：只显示虚线（数值通道置 0）
		minifcu:SetFcuSpdValue(0)
		minifcu:SetFcuMachValue(0)
	elseif is_mach == 1 then
		minifcu:SetFcuSpdValue(0)
		minifcu:SetFcuMachValue(spd_val) -- 源已是马赫×100
	else
		minifcu:SetFcuSpdValue(spd_val)
		minifcu:SetFcuMachValue(0)
	end
	minifcu:SetFcuSpdDashes(spd_managed == 1 and 1 or 0)
	minifcu:SetFcuSpdDot(spd_managed ~= 0 and 1 or 0)

	-- ---- FCU LCD：HDG ----
	local hdg_managed = dr_hdg_managed:Get()
	minifcu:SetFcuHdgValue(dr_hdg:Get())
	minifcu:SetFcuHdgDashes(hdg_managed == 1 and 1 or 0)
	minifcu:SetFcuHdgDot(hdg_managed ~= 0 and 1 or 0)

	-- ---- FCU LCD：ALT（ft/100）----
	minifcu:SetFcuAltValue(dr_alt:Get())
	minifcu:SetFcuAltDot(dr_alt_managed:Get() ~= 0 and 1 or 0)

	-- ---- FCU LCD：VS / FPA 互斥 ----
	local is_trk = dr_trkmode:Get()
	local vval = dr_vs:Get() -- 100 fpm（TRK/FPA 模式下 = FPA×10）
	minifcu:SetFcuVsDashes(dr_vs_managed:Get() == 1 and 1 or 0)
	if is_trk >= 1 then
		minifcu:SetFcuVsValue(0)
		minifcu:SetFcuFpaValue(vval * 100) -- FPA×10 → FPA×1000
	else
		minifcu:SetFcuVsValue(vval * 100) -- 100 fpm → fpm
		minifcu:SetFcuFpaValue(0)
	end
	minifcu:SetFcuHdgTrkMode()

	-- ---- miniEFIS ----
	local navtype = dr_navtype:Get()
	minifcu:SetEfisCstr(filterbit(navtype, 1))
	minifcu:SetEfisWpt(filterbit(navtype, 2))
	minifcu:SetEfisVord(filterbit(navtype, 4))
	minifcu:SetEfisNdb(filterbit(navtype, 8))
	minifcu:SetEfisArpt(filterbit(navtype, 16))
	minifcu:SetFcuFdValue()
	minifcu:SetFcuLsValue()

	-- ---- miniEFIS：气压 ----
	local baro_unit = dr_baro_unit:Get() -- 0 = inHg, 1 = hPa
	local baro_mode = dr_baro_mode:Get() -- <=0 = STD, 1 = QFE, 2 = QNH
	local baro = dr_baro:Get()           -- 当前显示单位的数值

	minifcu:SetEfisBaroInhgHpaUnit(baro_unit == 0 and 1 or 0)
	minifcu:SetEfisBaroStd1()                             -- 源 <=0 → 1（revert）
	minifcu:SetEfisBaroQnnh1(baro_mode > 0 and 1 or 0)    -- 非 STD 即亮

	-- 两个值都算（切单位不读陈旧值）；取整后写 int 通道
	if baro_unit == 1 then -- 当前是 hPa
		minifcu:SetEfisBaro(math.floor(baro + 0.5))
		minifcu:SetEfisBaroInhg(math.floor(baro / 33.8638895 * 100 + 0.5))
	else -- 当前是 inHg
		minifcu:SetEfisBaroInhg(math.floor(baro * 100 + 0.5))
		minifcu:SetEfisBaro(math.floor(baro * 33.8638895 + 0.5))
	end
end)
