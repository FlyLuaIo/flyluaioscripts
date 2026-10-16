-- *****************************************************************
-- FlyLuaIO MobiFlight miniFCU (miniFCU + miniEFIS) for MSFS
-- FlyByWire A380 (a380x)
-- created by Wei Shuai <cpuwolf@gmail.com>
-- *****************************************************************
-- 来源与依据（可追溯）：
--   * 事件名 / L 变量 / A 变量：msfs/data/QFCU_FBW_A320NX.lua 里的 **A380 分支**
--     （该档用 isFBWA380 = 不排除 acfpath "A380" 判定，A380 的显示与 EFIS 变量与 A320 不同）
--     每条绑定后的 [Q#] 标注该功能在 QFCU 面板上的 KeyIdx。
--   * 与 MINIFCU_FBW_A320NX.lua 的差异（都是 FBW A380 本身的差异，不是随手改的）：
--     - SPD 显示源：(L:A32NX_AUTOPILOT_SPEED_SELECTED)（A320 用 (L:A32NX_FCU_AFS_DISPLAY_SPD_MACH_VALUE)）
--     - SPD/MACH 模式：(A:AUTOPILOT MANAGED SPEED IN MACH,Bool)（A320 用 (L:A32NX_FCU_AFS_DISPLAY_MACH_MODE)）
--     - ND 模式/距离：(L:A32NX_EFIS_L_ND_MODE) 0–4 / (L:A32NX_EFIS_L_ND_RANGE) 1–6
--       （A320 用 A32NX_FCU_EFIS_L_EFIS_MODE 0–4 / _EFIS_RANGE 0–5）
--     - EFIS 过滤键：(L:A380X_EFIS_L_CSTR_BUTTON_IS_ON) / (L:A380X_EFIS_L_ACTIVE_FILTER) /
--       (L:A380X_EFIS_L_ARPT_BUTTON_IS_ON)（A320 用 A32NX.FCU_EFIS_L_*_PUSH 事件）
--     - FD/LS：(L:A380X_EFIS_L_VV_BUTTON_IS_ON) / (L:A380X_EFIS_L_LS_BUTTON_IS_ON)
--       （A380 这个键是 VV 而不是 FD，保留参考档语义）
--     - 气压：(L:XMLVAR_Baro1_Mode) + (L:XMLVAR_Baro_Selector_HPA_1)
--       （A320 用 A32NX_FCU_EFIS_L_DISPLAY_BARO_MODE / _BARO_IS_INHG）
--   * 硬件通道契约：mobiflight/MiniFCU.json；通道语义 / 编码器位序：xp/MINIFCU_Toliss.lua
-- 编码器位序（勿改）：每轴 4 bit，前 2 bit = 减，后 2 bit = 加。
--   ALT 47/48 · 49/50；SPD 51/52 · 53/54；HDG 55/56 · 57/58；VS 59/60 · 61/62；BARO 63/64 · 65/66
-- 已知取舍（待真机验证）：
--   1. 未做断电门控（同 A320 档：miniFCU 硬件无背光/熄灭通道）。
--   2. MT 1（MACH 值）：A380 分支里马赫与速度共用 A32NX_AUTOPILOT_SPEED_SELECTED
--      （参考档也是同一变量喂 QFCU 的 iasval_i / iasval_f），故本档按“该值在马赫模式下即马赫”处理，
--      ×100 后送 MT1；若真机显示不对，改为按 QFCU 的 +0.005 浮点语义处理。
--   3. 气压值通道：参考档 A380 分支在非 HPA 时给 inHg*100、HPA 时给 mbar；本档统一从
--      (A:KOHLSMAN SETTING HG, inHg) 换算两个值（inHg×100 / ×33.8638895），切单位不会读到陈旧值。
--   4. QFCU 面板的副驾 EFIS 半区（56–79）与副驾气压（51–53）不移植（miniFCU 只有一个 EFIS）。
--   5. bit 25（CHRONO）：A380 分支没有对应事件；FBW A380 是否支持 A32NX_EFIS_L_CHRONO_PUSHED
--      未在参考档中验证 —— TODO：真机确认后再补，先不绑。
-- *****************************************************************

if ilua_require_msfs() then
	return
end
if ilua_require_fbw_a380() then return end

-- Do not remove below lines: hardware detection
local minifcu = com.sim.mf.MiniFCU.Open()
if not minifcu then return end
-- Do not remove above lines: hardware detection

uluaLog('MobiFlight MiniFCU for FlyByWire A380')

-- ===========================================================
-- INPUT：FCU 半区（bit 0–17）

-- SPD/MACH 显示切换 [Q55]
minifcu:CfgRpn(0, '(>K:A32NX.FCU_SPD_MACH_TOGGLE_PUSH)')
-- HDG/TRK ↔ VS/FPA 切换 [Q54]
minifcu:CfgRpn(1, '(>K:A32NX.FCU_TRK_FPA_TOGGLE_PUSH)')
-- AP1 [Q10] / AP2 [Q9]
minifcu:CfgRpn(2, '(>K:A32NX.FCU_AP_1_PUSH)')
minifcu:CfgRpn(3, '(>K:A32NX.FCU_AP_2_PUSH)')
-- METRIC ALT [Q14]
minifcu:CfgRpn(4, '(>K:A32NX.FCU_METRIC_ALT_TOGGLE_PUSH)')
-- A/THR [Q11]
minifcu:CfgRpn(5, '(>K:A32NX.FCU_ATHR_PUSH)')
-- EXPED [Q12]
minifcu:CfgRpn(6, '(>K:A32NX.FCU_EXPED_PUSH)')
-- LOC [Q8] / APPR [Q13]
minifcu:CfgRpn(7, '(>K:A32NX.FCU_LOC_PUSH)')
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
--   （QFCU 面板该键是拨杆，所以 QFCU 档的按下 0 / 松开 1 不能照抄）
minifcu:CfgRpn(17, '1 (>L:A32NX_FCU_ALT_INCREMENT_1000)', '0 (>L:A32NX_FCU_ALT_INCREMENT_1000)')

-- ===========================================================
-- INPUT：EFIS 半区机长侧（bit 18–46）

-- 过滤键 [Q35–Q39]：A380 用 BUTTON_IS_ON / ACTIVE_FILTER 自翻转（照抄参考档 A380 分支表达式）
minifcu:CfgRpn(18, '(L:A380X_EFIS_L_CSTR_BUTTON_IS_ON) 1 == if{ 0 } els{ 1 } (>L:A380X_EFIS_L_CSTR_BUTTON_IS_ON)') -- CSTR
minifcu:CfgRpn(19, '(L:A380X_EFIS_L_ACTIVE_FILTER) 1 == if{ 0 } els{ 1 } (>L:A380X_EFIS_L_ACTIVE_FILTER)')        -- WPT
minifcu:CfgRpn(20, '(L:A380X_EFIS_L_ACTIVE_FILTER) 2 == if{ 0 } els{ 2 } (>L:A380X_EFIS_L_ACTIVE_FILTER)')        -- VOR D
minifcu:CfgRpn(21, '(L:A380X_EFIS_L_ACTIVE_FILTER) 3 == if{ 0 } els{ 3 } (>L:A380X_EFIS_L_ACTIVE_FILTER)')        -- NDB
minifcu:CfgRpn(22, '(L:A380X_EFIS_L_ARPT_BUTTON_IS_ON) 1 == if{ 0 } els{ 1 } (>L:A380X_EFIS_L_ARPT_BUTTON_IS_ON)') -- ARPT
-- FD（A380 上是 VV）/ LS [Q40 / Q41]
minifcu:CfgRpn(23, '(L:A380X_EFIS_L_VV_BUTTON_IS_ON) ! (>L:A380X_EFIS_L_VV_BUTTON_IS_ON)')
minifcu:CfgRpn(24, '(L:A380X_EFIS_L_LS_BUTTON_IS_ON) ! (>L:A380X_EFIS_L_LS_BUTTON_IS_ON)')
-- bit 25 CHRONO：A380 分支无对应事件，未绑定（TODO，见文件头取舍 5）

-- ROSE 模式键 [Q24–Q28]：LS/VOR/NAV/ARC/PLN → A32NX_EFIS_L_ND_MODE 0–4
minifcu:CfgRpn(26, '0 (>L:A32NX_EFIS_L_ND_MODE)') -- LS
minifcu:CfgRpn(27, '1 (>L:A32NX_EFIS_L_ND_MODE)') -- VOR
minifcu:CfgRpn(28, '2 (>L:A32NX_EFIS_L_ND_MODE)') -- NAV
minifcu:CfgRpn(29, '3 (>L:A32NX_EFIS_L_ND_MODE)') -- ARC
minifcu:CfgRpn(30, '4 (>L:A32NX_EFIS_L_ND_MODE)') -- PLN

-- 距离 [Q29–Q34]：10/20/40/80/160/320 → A32NX_EFIS_L_ND_RANGE 1–6（A380 枚举从 1 起）
minifcu:CfgRpn(31, '1 (>L:A32NX_EFIS_L_ND_RANGE)') -- 10
minifcu:CfgRpn(32, '2 (>L:A32NX_EFIS_L_ND_RANGE)') -- 20
minifcu:CfgRpn(33, '3 (>L:A32NX_EFIS_L_ND_RANGE)') -- 40
minifcu:CfgRpn(34, '4 (>L:A32NX_EFIS_L_ND_RANGE)') -- 80
minifcu:CfgRpn(35, '5 (>L:A32NX_EFIS_L_ND_RANGE)') -- 160
minifcu:CfgRpn(36, '6 (>L:A32NX_EFIS_L_ND_RANGE)') -- 320

-- VOR/ADF 选择 1 与 2 [Q42–Q45]
--   QFCU 是两档拨杆（按下 = ADF/VOR，松开 = 0），miniFCU 是 ADF / OFF / VOR 三个独立按键，
--   所以只发按下，OFF 键显式写中位 0。NAVAID_x_MODE：1 = ADF，2 = VOR（参考档取值）。
minifcu:CfgRpn(37, '1 (>L:A32NX_FCU_EFIS_L_NAVAID_1_MODE)') -- ADF 1
minifcu:CfgRpn(38, '0 (>L:A32NX_FCU_EFIS_L_NAVAID_1_MODE)') -- OFF 1
minifcu:CfgRpn(39, '2 (>L:A32NX_FCU_EFIS_L_NAVAID_1_MODE)') -- VOR 1
minifcu:CfgRpn(40, '1 (>L:A32NX_FCU_EFIS_L_NAVAID_2_MODE)') -- ADF 2
minifcu:CfgRpn(41, '0 (>L:A32NX_FCU_EFIS_L_NAVAID_2_MODE)') -- OFF 2
minifcu:CfgRpn(42, '2 (>L:A32NX_FCU_EFIS_L_NAVAID_2_MODE)') -- VOR 2

-- 气压单位 [Q50]：A380 用 (L:XMLVAR_Baro_Selector_HPA_1)，1 = hPa、0 = inHg
--   （参考档按下写 0、松开写 1；miniFCU 两个按键各发一个明确值）
minifcu:CfgRpn(43, '1 (>L:XMLVAR_Baro_Selector_HPA_1)') -- HPA
minifcu:CfgRpn(44, '0 (>L:XMLVAR_Baro_Selector_HPA_1)') -- INHG
-- 气压旋钮拉 / 按 [Q49 / Q48]（A380 走 EFIS_CP_BARO_PULL/PUSH_1）
minifcu:CfgRpn(45, '(>H:A380X_EFIS_CP_BARO_PULL_1)')
minifcu:CfgRpn(46, '(>H:A380X_EFIS_CP_BARO_PUSH_1)')

-- ===========================================================
-- INPUT：编码器（bit 47–66）

-- ALT 编码器 [Q16 / Q17]
minifcu:CfgRpn(47, '(>K:A32NX.FCU_ALT_DEC)')
minifcu:CfgRpn(48, '(>K:A32NX.FCU_ALT_DEC)')
minifcu:CfgRpn(49, '(>K:A32NX.FCU_ALT_INC)')
minifcu:CfgRpn(50, '(>K:A32NX.FCU_ALT_INC)')

-- SPD 编码器 [Q0 / Q1]：mach 模式下走 AP_MACH_VAR（与参考档共用同一 RPN）
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

-- BARO 编码器（机长侧）[Q46 / Q47]：A380 分支要判 XMLVAR_Baro1_Mode 才动作（照抄参考档表达式）
local baro_dec_rpn = '(L:XMLVAR_Baro1_Mode) 2 != (L:XMLVAR_Baro1_Mode) 3 != and if{ (L:XMLVAR_Baro_Selector_HPA_1) if{ 1 (A:KOHLSMAN SETTING MB:1, mbars) -- 16 * (>K:2:KOHLSMAN_SET) } els{ 1 (>K:KOHLSMAN_DEC) } }'
local baro_inc_rpn = '(L:XMLVAR_Baro1_Mode) 2 != (L:XMLVAR_Baro1_Mode) 3 != and if{ (L:XMLVAR_Baro_Selector_HPA_1) if{ 1 (A:KOHLSMAN SETTING MB:1, mbars) ++ 16 * (>K:2:KOHLSMAN_SET) } els{ 1 (>K:KOHLSMAN_INC) } }'
minifcu:CfgRpn(63, baro_dec_rpn)
minifcu:CfgRpn(64, baro_dec_rpn)
minifcu:CfgRpn(65, baro_inc_rpn)
minifcu:CfgRpn(66, baro_inc_rpn)

-- ===========================================================
-- 显示源（帧循环里直接读）

-- FCU（A380 分支的源）
local dr_is_mach = iDataRef:New('(A:AUTOPILOT MANAGED SPEED IN MACH,Bool)') -- 1 = 显示 MACH
local dr_spd      = iDataRef:New('(L:A32NX_AUTOPILOT_SPEED_SELECTED)')      -- 速度 / 马赫共用
local dr_spd_dashed = iDataRef:New('(L:A32NX_FCU_SPD_MANAGED_DASHES)')
local dr_hdg        = iDataRef:New('(L:A32NX_AUTOPILOT_HEADING_SELECTED)')
local dr_hdg_dashed = iDataRef:New('(L:A32NX_FCU_HDG_MANAGED_DASHES)')
local dr_vs         = iDataRef:New('(L:A32NX_AUTOPILOT_VS_SELECTED)')
local dr_fpa        = iDataRef:New('(L:A32NX_AUTOPILOT_FPA_SELECTED)')
local dr_trkfpa     = iDataRef:New('(L:A32NX_TRK_FPA_MODE_ACTIVE)')

-- EFIS 机长侧气压（A380：XMLVAR_Baro1_Mode >= 2 为 STD；XMLVAR_Baro_Selector_HPA_1 = 1 → hPa）
local dr_baro_mode = iDataRef:New('(L:XMLVAR_Baro1_Mode)')
local dr_baro_hpa  = iDataRef:New('(L:XMLVAR_Baro_Selector_HPA_1)')
local dr_baro_inhg = iDataRef:New('(A:KOHLSMAN SETTING HG, inHg)')

-- ===========================================================
-- OUTPUT：6 个 LED pin
minifcu:GetAp1('(L:A32NX_AUTOPILOT_1_ACTIVE)')
minifcu:GetAp2('(L:A32NX_AUTOPILOT_2_ACTIVE)')
minifcu:GetAthr('(L:A32NX_AUTOTHRUST_STATUS)')
minifcu:GetLoc('(L:A32NX_FCU_LOC_LIGHT_ON)')
minifcu:GetAppr('(L:A32NX_FCU_APPR_LIGHT_ON)')
minifcu:GetExped('(L:A32NX_FMA_EXPEDITE_MODE)')

-- ===========================================================
-- OUTPUT：miniFCU LCD（14 FCU + 12 EFIS 通道全部保留）

-- MT 0 SPD 值 / MT 1 MACH 值（同一源，按模式取用）
minifcu:GetFcuSpdValue('(L:A32NX_AUTOPILOT_SPEED_SELECTED)')
minifcu:GetFcuMachValue('(L:A32NX_AUTOPILOT_SPEED_SELECTED)', 100)
-- MT 2 SPD/MACH 模式 / MT 3 dashed / MT 4 dot
minifcu:GetFcuSpdMachMode('(A:AUTOPILOT MANAGED SPEED IN MACH,Bool)')
minifcu:GetFcuSpdDashes('(L:A32NX_FCU_SPD_MANAGED_DASHES)')
minifcu:GetFcuSpdDot('(L:A32NX_FCU_SPD_MANAGED_DOT)')
-- MT 5 / 6 / 7 HDG
minifcu:GetFcuHdgValue('(L:A32NX_AUTOPILOT_HEADING_SELECTED)')
minifcu:GetFcuHdgDashes('(L:A32NX_FCU_HDG_MANAGED_DASHES)')
minifcu:GetFcuHdgDot('(L:A32NX_FCU_HDG_MANAGED_DOT)')
-- MT 8 / 9 ALT
minifcu:GetFcuAltValue('(A:AUTOPILOT ALTITUDE LOCK VAR:3, Feet)', 0.01)
minifcu:GetFcuAltDot('(L:A32NX_FCU_ALT_MANAGED)')
-- MT 10 / 11 / 12 VS 与 FPA
minifcu:GetFcuVsValue('(L:A32NX_AUTOPILOT_VS_SELECTED)')
minifcu:GetFcuFpaValue('(L:A32NX_AUTOPILOT_FPA_SELECTED)')
minifcu:GetFcuVsDashes('(L:A32NX_FCU_VS_MANAGED)')
-- MT 13 HDG/TRK 模式
minifcu:GetFcuHdgTrkMode('(L:A32NX_TRK_FPA_MODE_ACTIVE)')

-- EFIS LED：A380 用位与测试（A320 档是 == 测试）
minifcu:GetEfisCstr('(L:A32NX_EFIS_L_OPTION) 1 &')
minifcu:GetEfisWpt('(L:A32NX_EFIS_L_OPTION) 4 &')
minifcu:GetEfisVord('(L:A32NX_EFIS_L_OPTION) 2 &')
minifcu:GetEfisNdb('(L:A32NX_EFIS_L_OPTION) 8 &')
minifcu:GetEfisArpt('(L:A32NX_EFIS_L_OPTION) 16 &')
minifcu:GetFcuFdValue('(L:A380X_EFIS_L_VV_BUTTON_IS_ON)')
minifcu:GetFcuLsValue('(L:A380X_EFIS_L_LS_BUTTON_IS_ON)')
-- MT 7 QNH 标签 / MT 8 STD 标志（源：XMLVAR_Baro1_Mode，帧循环里判定）
minifcu:GetEfisBaroQnnh1('(L:XMLVAR_Baro1_Mode)')
minifcu:GetEfisBaroStd1('(L:XMLVAR_Baro1_Mode)')
-- MT 9 单位（1 = inHg；源 XMLVAR_Baro_Selector_HPA_1 为 1 时表示 hPa）
minifcu:GetEfisBaroInhgHpaUnit('(L:XMLVAR_Baro_Selector_HPA_1)')
-- MT 10 / 11 两个值都在帧循环里从 inHg 换算
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
	local is_mach  = dr_is_mach:Get()
	local spd_dash = dr_spd_dashed:Get()
	local spd_val  = dr_spd:Get()

	-- MT 2：SPD/MACH 模式
	minifcu:SetFcuSpdMachMode(is_mach >= 1 and 1 or 0)
	-- MT 1 / MT 0：MACH 值（×100）与 SPD 值（kts），互斥且 dashed 时置 0
	if is_mach >= 1 and spd_dash < 1 then
		minifcu:SetFcuMachValue(math.floor(spd_val * 100 + 0.5))
		minifcu:SetFcuSpdValue(0)
	elseif is_mach < 1 and spd_dash < 1 then
		minifcu:SetFcuMachValue(0)
		minifcu:SetFcuSpdValue(math.floor(spd_val + 0.5))
	else
		minifcu:SetFcuMachValue(0)
		minifcu:SetFcuSpdValue(0)
	end
	-- MT 3 / MT 4
	minifcu:SetFcuSpdDashes()
	minifcu:SetFcuSpdDot()
	-- MT 5 / 6 / 7
	minifcu:SetFcuHdgValue()
	minifcu:SetFcuHdgDashes()
	minifcu:SetFcuHdgDot()
	-- MT 8 / 9
	minifcu:SetFcuAltValue()
	minifcu:SetFcuAltDot()
	-- MT 10 / 11 / 12
	local is_fpa = (dr_trkfpa:Get() >= 1)
	minifcu:SetFcuVsDashes()
	if is_fpa then
		minifcu:SetFcuVsValue(0)
		minifcu:SetFcuFpaValue(dr_fpa:Get())
	else
		minifcu:SetFcuVsValue(dr_vs:Get())
		minifcu:SetFcuFpaValue(0)
	end
	-- MT 13
	minifcu:SetFcuHdgTrkMode()

	-- ---- EFIS 半区 ----
	minifcu:SetEfisCstr()
	minifcu:SetEfisWpt()
	minifcu:SetEfisVord()
	minifcu:SetEfisNdb()
	minifcu:SetEfisArpt()
	minifcu:SetFcuFdValue()
	minifcu:SetFcuLsValue()

	-- 气压：A380 用 XMLVAR_Baro1_Mode（>= 2 视为 STD），单位由 XMLVAR_Baro_Selector_HPA_1 决定
	local baro_mode = dr_baro_mode:Get()
	local baro_hpa  = dr_baro_hpa:Get()
	local baro_inhg = dr_baro_inhg:Get()
	local is_std = (baro_mode == 2 or baro_mode == 3)

	minifcu:SetEfisBaroStd1(is_std and 1 or 0)
	minifcu:SetEfisBaroQnnh1(is_std and 0 or 1)
	-- MT 9：1 = inHg（HPA_1 为 1 表示 hPa）
	minifcu:SetEfisBaroInhgHpaUnit(baro_hpa >= 1 and 0 or 1)
	-- MT 10 / MT 11：两个值都算，切单位不读陈旧值
	minifcu:SetEfisBaroInhg(math.floor(baro_inhg * 100 + 0.5))
	minifcu:SetEfisBaro(math.floor(baro_inhg * 33.8638895 + 0.5))
end)
