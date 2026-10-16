-- *****************************************************************
-- FlyLuaIO MobiFlight miniFCU (miniFCU + miniEFIS) for MSFS
-- iniBuilds A310-300（iniBuilds A310 客机 / 货机同一机模档）
-- created by Wei Shuai <cpuwolf@gmail.com>
-- *****************************************************************
-- 来源与依据（可追溯）：
--   * B 事件名 / L 变量 / A 变量：msfs/data/QFCU_INIBUILD_A310.lua（QFCU 同机型档，MSFS 实测通过），
--     每条绑定后的 [Q#] 标注该功能在 QFCU 面板上的 KeyIdx，便于与 QFCU 档逐条对照。
--   * 硬件通道契约：mobiflight/MiniFCU.json（按键 bit 0–46、编码器 bit 47–66、
--     6 个 Output pin、26 条 CustomDevice 通道）。
--   * 通道语义 / 编码器位序：xp/MINIFCU_Toliss.lua（真机 miniFCU 在 X-Plane 上手工调过并实测）。
-- 编码器位序（沿用 XP 档，勿改）：每轴 4 bit，前 2 bit = 减，后 2 bit = 加。
--   ALT 47/48 减 · 49/50 加；SPD 51/52 · 53/54；HDG 55/56 · 57/58；VS 59/60 · 61/62；BARO 63/64 · 65/66
--
-- iniBuilds A310 侧命名与判据（全部出自参考档 msfs/data/QFCU_INIBUILD_A310.lua，勿改名）：
--   * 按键与旋钮走 B 事件（InputEvent）：B:INSTRUMENT_{SPEED,HEADING,ALT,VS}_KNOB_*；
--     FCU / EFIS 开关量走 S_FCU_ 前缀与 A310_ 前缀的 L 变量。参考档的 CfgVal(bit, "B:...", 1, 0) 语义是
--     「按下写 1 / 松开写 0」，本档逐字照抄（CfgVal 由 Qmdev 基类提供，miniFCU 继承同一基类）。
--   * 四个 B 事件旋钮在参考档里是 qfcu:CfgEnc(dec_bit, inc_bit, "B:..._Knob")（一个 InputEvent 收 ±delta）。
--     ⚠ CfgEnc 在 MF 设备上不可用（真机验证）→ 本档每 bit 一条 CfgRpn，发机模的分向事件
--     <事件>_Dec / <事件>_Inc（参数 1）；若真机某轴不动则回退成向基事件发增量（见编码器一节）。
--   * 气压三件套：
--     L:XMLVAR_Baro_Selector_HPA_1 —— 0 = inHg，1 = hPa（判据：参考档显示表达式
--       "(L:XMLVAR_Baro_Selector_HPA_1,bool) ! if{ inHg*100 } els{ mbar }"，以及 LED 段
--       "if qfcu_c_barounit == 0 then -- dot mode:29.92"）；
--     L:XMLVAR_Baro1_Mode —— 参考档注释 "QFE:0 QNH:1 STD:3"，帧循环里 2 或 3 都当 STD；
--     L:S_FCU_EFIS1_BARO_MODE —— 0 = inHg，1 = hPa（与同族 Fenix 档 msfs/data/QFCU_FNX_A3XX.lua
--       的 "-- HPA:1 inHG:0" 是同一变量名、同一极性）。
--   * 显示源全是参考档 digi_disp_set_* 里实际读的那几个量；SPD 窗三分支（dashes / mach / preset）、
--     VS 与 FPA 互斥（L:A310_FPA_SELECTED）、ALT 单位（L:A310_Altitude_Dial 是英尺）逐条对齐。
-- 已知取舍（待真机验证）：
--   1. 气压单位两个键 [Q50]：规格的机械映射是「43 ← press 值(0) / 44 ← release 值(1)」，但参考档 50 的
--      press / release 写的是同一个变量 L:S_FCU_EFIS1_BARO_MODE，该变量 0/1 的语义另有旁证（见上）；
--      本档按语义分配 —— bit 43（HPA 键）= '1 (>...)', bit 44（INHG 键）= '0 (>...)'。
--      若真机上两个键表现相反，把这两条的值对调即可（变量名不变）。
--   2. bit 15（VS PUSH）：参考档 QFCU 22 是 VS 归零命令 (L:S_FCU_VERTICAL_SPEED) -- (>L:S_FCU_VERTICAL_SPEED)，
--      照抄；同一键的另一个写法 qfcu:CfgVal(22, "B:AUTOPILOT_VerticalSpeed_Zero", 1, 0) 在参考档里被
--      作者注释掉（主动禁用），故不采用。
--   3. bit 25（CHRONO）：参考档没有这个键、也没有计时器事件 → 不绑定（TODO）。
--   4. MT4（SPD managed 点）/ MT7（HDG managed 点）：参考档只给 SPD dashes 与 HDG dashes，没有
--      managed 点源 → 注册 '0'（TODO），不猜变量。
--   5. 未做断电门控与亮度：参考档在 AC 掉电 / 亮度归零时清屏关灯（digi_disp_powoff_*），miniFCU 硬件
--      没有背光 / 熄灭通道，XP 档与 msfs/MINIFCU_FBW_A320NX.lua 也没做，这里保持一致。
--   6. QFCU 面板有两个 EFIS 半区（机长 / 副驾），miniFCU 只有机长半区，故 QFCU 的
--      51/52/53（副驾气压）与 56–79（副驾 EFIS）不移植；S_FCU_EFIS2_* / __EFIS_FO_* / I_FCU_EFIS2_* 一概不引用。
-- *****************************************************************

if ilua_require_msfs() then
	return
end
if ilua_require_inibuild_a310() then return end

-- Do not remove below lines: hardware detection
local minifcu = com.sim.mf.MiniFCU.Open()
if not minifcu then return end
-- Do not remove above lines: hardware detection

uluaLog('MobiFlight MiniFCU for iniBuilds A310')

-- ===========================================================
-- INPUT：FCU 半区（bit 0–17）

-- SPD/MACH 显示切换 [Q55]
minifcu:CfgRpn(0, '1 (>L:A310_SPD_MACH_BUTTON)')
-- HDG/TRK ↔ VS/FPA 切换 [Q54]
minifcu:CfgRpn(1, '1 (>L:A310_CPT_FPA_COMMAND)')
-- AP1 [Q10]
minifcu:CfgRpn(2, '1 (>L:A310_AP1_BUTTON)')
-- AP2 [Q9]
minifcu:CfgRpn(3, '1 (>L:A310_AP2_BUTTON)')
-- METRIC ALT [Q14]：参考档是成对写（press 1 / release 0），照抄
minifcu:CfgRpn(4, '1 (>L:S_FCU_METRIC_ALT)', '0 (>L:S_FCU_METRIC_ALT)')
-- A/THR [Q11]
minifcu:CfgRpn(5, '1 (>L:AP8_BUTTON)')
-- EXPED [Q12]
minifcu:CfgRpn(6, '1 (>L:AP3_BUTTON)')
-- LOC [Q8]
minifcu:CfgRpn(7, '1 (>L:A310_FCU_MANAGED_HEADING_BUTTON)')
-- APPR [Q13]
minifcu:CfgRpn(8, '1 (>L:AP7_BUTTON)')
-- SPD PUSH / PULL [Q2 / Q3]：B 事件注入，参数与参考档逐字一致
minifcu:CfgVal(9, 'B:INSTRUMENT_SPEED_KNOB_Push', 1, 0)
minifcu:CfgVal(10, 'B:INSTRUMENT_SPEED_KNOB_Pull', 1, 0)
-- HDG PUSH / PULL [Q6 / Q7]
minifcu:CfgVal(11, 'B:INSTRUMENT_HEADING_KNOB_Push', 1, 0)
minifcu:CfgVal(12, 'B:INSTRUMENT_HEADING_KNOB_Pull', 1, 0)
-- ALT PUSH / PULL [Q18 / Q19]
minifcu:CfgVal(13, 'B:INSTRUMENT_ALT_KNOB_Push', 1, 0)
minifcu:CfgVal(14, 'B:INSTRUMENT_ALT_KNOB_Pull', 1, 0)
-- VS PUSH（VS 归零）[Q22]：参考档 22 写的是 (L:S_FCU_VERTICAL_SPEED) -- (>L:S_FCU_VERTICAL_SPEED)，照抄
minifcu:CfgRpn(15, '(L:S_FCU_VERTICAL_SPEED) -- (>L:S_FCU_VERTICAL_SPEED)')
-- VS PULL [Q23]
minifcu:CfgVal(16, 'B:INSTRUMENT_VS_KNOB_Pull', 1, 0)
-- ALT 100/1000 [Q15]：miniFCU 是瞬时按键 —— 按住 = 1000 ft 步长，松开回 100 ft
--   （参考档是拨杆：press 写 0 = 100 ft，release 写 1 = 1000 ft，故两个值对调，变量名不变）
minifcu:CfgRpn(17, '1 (>L:S_FCU_ALTITUDE_SCALE)', '0 (>L:S_FCU_ALTITUDE_SCALE)')

-- ===========================================================
-- INPUT：EFIS 半区机长侧（bit 18–46）

-- 导航点过滤键 [Q35–Q39]
minifcu:CfgRpn(18, '1 (>L:A310_EFIS_CPT_CSTR_BUTTON)')
minifcu:CfgRpn(19, '1 (>L:A310_EFIS_CPT_FIXES_BUTTON)')
minifcu:CfgRpn(20, '1 (>L:A310_EFIS_CPT_VOR_BUTTON)')
minifcu:CfgRpn(21, '1 (>L:A310_EFIS_CPT_NDB_BUTTON)')
minifcu:CfgRpn(22, '1 (>L:A310_EFIS_CPT_ARPT_BUTTON)')
-- FD / LS [Q40 / Q41]：成对写，照抄
minifcu:CfgRpn(23, '1 (>L:S_FCU_EFIS1_FD)', '0 (>L:S_FCU_EFIS1_FD)')
minifcu:CfgRpn(24, '1 (>L:S_FCU_EFIS1_LS)', '0 (>L:S_FCU_EFIS1_LS)')
-- TODO bit 25（CHRONO）：QFCU 面板无此键，参考档里也没有计时器事件 → 保持空绑定，不瞎猜事件名。

-- ROSE 模式键 [Q24–Q28]：LS/VOR/NAV/ARC/PLN 对应 EFIS_MODE 0–4
minifcu:CfgRpn(26, '0 (>L:A310_map_mode_capt_switch)') -- LS
minifcu:CfgRpn(27, '1 (>L:A310_map_mode_capt_switch)') -- VOR
minifcu:CfgRpn(28, '2 (>L:A310_map_mode_capt_switch)') -- NAV
minifcu:CfgRpn(29, '3 (>L:A310_map_mode_capt_switch)') -- ARC
minifcu:CfgRpn(30, '4 (>L:A310_map_mode_capt_switch)') -- PLN

-- 距离 [Q29–Q34]：10/20/40/80/160/320 → RANGE 0–5
minifcu:CfgRpn(31, '0 (>L:A310_map_range_capt_switch)') -- 10
minifcu:CfgRpn(32, '1 (>L:A310_map_range_capt_switch)') -- 20
minifcu:CfgRpn(33, '2 (>L:A310_map_range_capt_switch)') -- 40
minifcu:CfgRpn(34, '3 (>L:A310_map_range_capt_switch)') -- 80
minifcu:CfgRpn(35, '4 (>L:A310_map_range_capt_switch)') -- 160
minifcu:CfgRpn(36, '5 (>L:A310_map_range_capt_switch)') -- 320

-- VOR/ADF 选择 1 与 2 [Q42–Q45]
--   QFCU 是两档拨杆（按下 = ADF/VOR，松开 = 中间位），miniFCU 是 ADF / OFF / VOR 三个独立按键 →
--   这里只发按下。两个 NAV 状态变量（S_FCU_EFIS1_NAV1 / S_FCU_EFIS1_NAV2）三态 = 0 = ADF，1 = 中间位(OFF)，
--   2 = VOR（QFCU 档 42→press 0、release 1；43→press 2、release 1，两边 release 都是那个中间值 1）。
minifcu:CfgRpn(37, '0 (>L:S_FCU_EFIS1_NAV1)') -- ADF 1  [Q42 press]
minifcu:CfgRpn(38, '1 (>L:S_FCU_EFIS1_NAV1)') -- OFF 1  [Q42/Q43 release]
minifcu:CfgRpn(39, '2 (>L:S_FCU_EFIS1_NAV1)') -- VOR 1  [Q43 press]
minifcu:CfgRpn(40, '0 (>L:S_FCU_EFIS1_NAV2)') -- ADF 2  [Q44 press]
minifcu:CfgRpn(41, '1 (>L:S_FCU_EFIS1_NAV2)') -- OFF 2  [Q44/Q45 release]
minifcu:CfgRpn(42, '2 (>L:S_FCU_EFIS1_NAV2)') -- VOR 2  [Q45 press]

-- 气压单位 [Q50]：QFCU 是单键拨杆（press 0 / release 1，同一个变量 L:S_FCU_EFIS1_BARO_MODE），
--   miniFCU 是两个独立按键 → 各只发按下。变量 0/1 = inHg/hPa（判据见文件头），故：
minifcu:CfgRpn(43, '1 (>L:S_FCU_EFIS1_BARO_MODE)') -- HPA
minifcu:CfgRpn(44, '0 (>L:S_FCU_EFIS1_BARO_MODE)') -- INHG
-- 气压旋钮 拉 / 按 [Q49 / Q48]
minifcu:CfgRpn(45, '(L:S_FCU_EFIS1_BARO_STD) ++ (>L:S_FCU_EFIS1_BARO_STD)')
minifcu:CfgRpn(46, '(L:S_FCU_EFIS1_BARO_STD) -- (>L:S_FCU_EFIS1_BARO_STD)')

-- ===========================================================
-- INPUT：编码器（bit 47–66）
-- 参考档这些轴用 qfcu:CfgEnc(dec_bit, inc_bit, "B:<事件>") 表达（QFCU 固件的 ROTATE 配置：
-- 把本次旋转的带符号累加增量当作输入事件的参数发出去）。
-- ⚠ CfgEnc 在 MF 设备（miniFCU）上不可用 —— 真机验证的结论，不要再用 CfgEnc 镜像这类写法。
-- 本档改为每 bit 一条 CfgRpn，发机模自己的分向事件 <事件>_Dec / <事件>_Inc（参数 1）：
--   47/48 = 减、49/50 = 加（每轴 4 bit，位序见文件头）。
-- ⚠ 若真机上某轴不动，说明该机型没有 _Dec/_Inc 分向事件 → 回退成向基事件发增量值：
--   '-1 (>B:<事件>)' / '1 (>B:<事件>)'（MSFS 侧 MSFSSetDatad 会把 RPN 值当事件参数发出）。

-- ALT 编码器 [Q16 / Q17]
minifcu:CfgRpn(47, '1 (>B:INSTRUMENT_ALT_KNOB_Knob_Dec)')
minifcu:CfgRpn(48, '1 (>B:INSTRUMENT_ALT_KNOB_Knob_Dec)')
minifcu:CfgRpn(49, '1 (>B:INSTRUMENT_ALT_KNOB_Knob_Inc)')
minifcu:CfgRpn(50, '1 (>B:INSTRUMENT_ALT_KNOB_Knob_Inc)')

-- SPD 编码器 [Q0 / Q1]
minifcu:CfgRpn(51, '1 (>B:INSTRUMENT_SPEED_KNOB_Knob_Dec)')
minifcu:CfgRpn(52, '1 (>B:INSTRUMENT_SPEED_KNOB_Knob_Dec)')
minifcu:CfgRpn(53, '1 (>B:INSTRUMENT_SPEED_KNOB_Knob_Inc)')
minifcu:CfgRpn(54, '1 (>B:INSTRUMENT_SPEED_KNOB_Knob_Inc)')

-- HDG 编码器 [Q4 / Q5]
minifcu:CfgRpn(55, '1 (>B:INSTRUMENT_HEADING_KNOB_Knob_Dec)')
minifcu:CfgRpn(56, '1 (>B:INSTRUMENT_HEADING_KNOB_Knob_Dec)')
minifcu:CfgRpn(57, '1 (>B:INSTRUMENT_HEADING_KNOB_Knob_Inc)')
minifcu:CfgRpn(58, '1 (>B:INSTRUMENT_HEADING_KNOB_Knob_Inc)')

-- VS 编码器 [Q20 / Q21]
minifcu:CfgRpn(59, '1 (>B:INSTRUMENT_VS_KNOB_Knob_Dec)')
minifcu:CfgRpn(60, '1 (>B:INSTRUMENT_VS_KNOB_Knob_Dec)')
minifcu:CfgRpn(61, '1 (>B:INSTRUMENT_VS_KNOB_Knob_Inc)')
minifcu:CfgRpn(62, '1 (>B:INSTRUMENT_VS_KNOB_Knob_Inc)')

-- BARO 编码器（机长侧）[Q46 / Q47]：参考档本身就是 RPN（不是 CfgEnc），逐字复制
minifcu:CfgRpn(63, '(L:E_FCU_EFIS1_BARO) -- (>L:E_FCU_EFIS1_BARO)')
minifcu:CfgRpn(64, '(L:E_FCU_EFIS1_BARO) -- (>L:E_FCU_EFIS1_BARO)')
minifcu:CfgRpn(65, '(L:E_FCU_EFIS1_BARO) ++ (>L:E_FCU_EFIS1_BARO)')
minifcu:CfgRpn(66, '(L:E_FCU_EFIS1_BARO) ++ (>L:E_FCU_EFIS1_BARO)')

-- ===========================================================
-- 显示源（帧循环里直接读；iDataRef:New 找不到路径会返回 nil，统一用 safe_get 兜底）

local function safe_get(dr)
	if dr == nil then
		return 0
	end
	return dr:Get()
end

-- FCU 窗
local dr_spd_dial    = iDataRef:New('(L:A310_Airspeed_Dial)')      -- SPD 模式 = kts（参考档 iasval_i）
local dr_spd_preset  = iDataRef:New('(L:A310_PRESET_SPEED)')       -- 非 0 时优先显示（参考档同逻辑）
local dr_mach_x100   = iDataRef:New('(A:AUTOPILOT MACH HOLD VAR, Number) 100 * near') -- 马赫 × 100
local dr_spd_mach    = iDataRef:New('(L:A310_Airspeed_is_mach,Bool)')                 -- 1 = MACH 模式
local dr_spd_dashed  = iDataRef:New('(L:A310_managed_speed)')      -- 1 = 虚线（managed）
local dr_hdg         = iDataRef:New('(L:A310_HEADING_DIAL)')
local dr_hdg_dashed  = iDataRef:New('(L:A32NX_FCU_HDG_MANAGED_DASHES)')
local dr_alt         = iDataRef:New('(L:A310_Altitude_Dial)')      -- 英尺
local dr_alt_managed = iDataRef:New('(L:A32NX_FCU_ALT_MANAGED)')
local dr_vs          = iDataRef:New('(L:A310_vvi_dial)')           -- fpm，带符号
local dr_fpa         = iDataRef:New('(L:A310_FPA_SET)')            -- 度（参考档 ×1000 喂 QFCU 的 TRK 窗）
local dr_vs_dashed   = iDataRef:New('(L:A32NX_FCU_VS_MANAGED)')
local dr_trkfpa      = iDataRef:New('(L:A310_FPA_SELECTED)')       -- 1 = TRK/FPA

-- EFIS 机长侧气压：单位 0 = inHg / 1 = hPa；BARO1_MODE 参考档注释 QFE:0 QNH:1 STD:3（2 或 3 = STD）
local dr_baro_unit   = iDataRef:New('(L:XMLVAR_Baro_Selector_HPA_1)')
local dr_baro_mode   = iDataRef:New('(L:XMLVAR_Baro1_Mode)')
local dr_baro_inhg   = iDataRef:New('(A:KOHLSMAN SETTING HG, inHg)')
local dr_baro_mbar   = iDataRef:New('(A:KOHLSMAN SETTING HG, mbar)')

-- ===========================================================
-- OUTPUT：6 个 LED pin
minifcu:GetAp1('(L:A310_ap1_on)')                       -- [Q10]
minifcu:GetAp2('(L:A310_ap2_on)')                       -- [Q9]
minifcu:GetAthr('(L:__ATHR_ButtonIsPressed, Bool)')     -- [Q11]
minifcu:GetLoc('(L:A310_MCU_NAV_LIGHT, Bool)')          -- [Q8]
minifcu:GetAppr('(L:A310_MCU_LAND_LIGHT, Bool)')        -- [Q13]（参考档该行写成 "(>L:..."，是笔误，这里用 (L:）
minifcu:GetExped('(L:A310_MCU_PROFILE_LIGHT)')          -- [Q12]

-- ===========================================================
-- OUTPUT：miniFCU LCD（CustomDevice 26 通道 = 14 FCU + 12 EFIS，全部注册）

-- MT 0 SPD 值（kts，仅 SPD 模式且非空屏）
minifcu:GetFcuSpdValue('(L:A310_Airspeed_Dial)')
-- MT 1 MACH 值（马赫 × 100；参考档源表达式已含 100 *，故 scale 用默认 1）
minifcu:GetFcuMachValue('(A:AUTOPILOT MACH HOLD VAR, Number) 100 * near')
-- MT 2 SPD/MACH 模式（1 = mach）
minifcu:GetFcuSpdMachMode('(L:A310_Airspeed_is_mach,Bool)')
-- MT 3 SPD dashed
minifcu:GetFcuSpdDashes('(L:A310_managed_speed)')
-- MT 4 SPD managed 点 —— TODO：参考档没有 managed 点源（A310 的 SPD 只有虚线态）
minifcu:GetFcuSpdDot('0')
-- MT 5 HDG 值
minifcu:GetFcuHdgValue('(L:A310_HEADING_DIAL)')
-- MT 6 HDG dashed
minifcu:GetFcuHdgDashes('(L:A32NX_FCU_HDG_MANAGED_DASHES)')
-- MT 7 HDG managed 点 —— TODO：参考档只给 HDG 虚线态，没有 managed 点源
minifcu:GetFcuHdgDot('0')
-- MT 8 ALT 值（ft / 100；源 L:A310_Altitude_Dial 是英尺，scale 0.01 与 MINIFCU_FBW_A320NX / XP 档一致）
minifcu:GetFcuAltValue('(L:A310_Altitude_Dial)', 0.01)
-- MT 9 ALT managed 点
minifcu:GetFcuAltDot('(L:A32NX_FCU_ALT_MANAGED)')
-- MT 10 VS 值（fpm，带符号；参考档把 |VS| 写进 vsval_i、符号写进 vsmode，miniFCU 通道本身带符号）
minifcu:GetFcuVsValue('(L:A310_vvi_dial)')
-- MT 11 FPA 值（度；参考档 ×1000 才进 QFCU 的 TRK 窗，这里按度直接用）
minifcu:GetFcuFpaValue('(L:A310_FPA_SET)')
-- MT 12 VS dashed
minifcu:GetFcuVsDashes('(L:A32NX_FCU_VS_MANAGED)')
-- MT 13 HDG/TRK 模式（1 = TRK）
minifcu:GetFcuHdgTrkMode('(L:A310_FPA_SELECTED)')

-- MT 0–4 CSTR / WPT / VORD / NDB / ARPT（参考档 LED 段读的 __EFIS_*_CPTIsPressed）
minifcu:GetEfisCstr('(L:__EFIS_CSTR_CPTIsPressed, Bool)')
minifcu:GetEfisWpt('(L:__EFIS_WPT_CPTIsPressed, Bool)')
minifcu:GetEfisVord('(L:__EFIS_VOR_CPTIsPressed, Bool)')
minifcu:GetEfisNdb('(L:__EFIS_NDB_CPTIsPressed, Bool)')
minifcu:GetEfisArpt('(L:__EFIS_ARPT_CPTIsPressed, Bool)')
-- MT 5 FD / MT 6 LS
minifcu:GetFcuFdValue('(L:I_FCU_EFIS1_FD)')
minifcu:GetFcuLsValue('(L:I_FCU_EFIS1_LS)')
-- MT 7 QNH 标签（非 STD 时为 1）/ MT 8 STD 标志（值在帧循环里由 BARO1_MODE 判定）
minifcu:GetEfisBaroQnnh1('(L:XMLVAR_Baro1_Mode)')
minifcu:GetEfisBaroStd1('(L:XMLVAR_Baro1_Mode)')
-- MT 9 inHg/hPa（1 = inHg，值在帧循环里由 L:XMLVAR_Baro_Selector_HPA_1 判定）
minifcu:GetEfisBaroInhgHpaUnit('(L:XMLVAR_Baro_Selector_HPA_1)')
-- MT 10 BARO inHg（×100）/ MT 11 BARO hPa：两个值都由 A:KOHLSMAN SETTING HG 现算（切单位不读陈旧值）
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
	local is_mach    = safe_get(dr_spd_mach)   -- 1 = MACH
	local spd_dash   = safe_get(dr_spd_dashed) -- 1 = 虚线
	local spd_dial   = safe_get(dr_spd_dial)
	local spd_preset = safe_get(dr_spd_preset)

	-- MT 2：SPD/MACH 模式
	minifcu:SetFcuSpdMachMode(is_mach >= 1 and 1 or 0)

	-- MT 1：MACH 值（参考档源已是 马赫×100；SPD 模式或虚线时置 0）
	if is_mach >= 1 and spd_dash < 1 then
		minifcu:SetFcuMachValue(math.floor(safe_get(dr_mach_x100) + 0.5))
	else
		minifcu:SetFcuMachValue(0)
	end

	-- MT 0：SPD 值（kts；参考档：预置速度非 0 时优先显示，mach / 虚线时置 0）
	if is_mach < 1 and spd_dash < 1 then
		local v = spd_dial
		if spd_preset ~= 0 then
			v = spd_preset
		end
		minifcu:SetFcuSpdValue(math.floor(v + 0.5))
	else
		minifcu:SetFcuSpdValue(0)
	end

	-- MT 3 / MT 4：dashed 与 managed 点（MT4 无源，见上）
	minifcu:SetFcuSpdDashes()
	minifcu:SetFcuSpdDot(0) -- TODO: 参考档无 managed 点源

	-- MT 5 / MT 6 / MT 7：HDG
	minifcu:SetFcuHdgValue()
	minifcu:SetFcuHdgDashes()
	minifcu:SetFcuHdgDot(0) -- TODO: 参考档无 managed 点源

	-- MT 8 / MT 9：ALT（GetFcuAltValue 的 scale = 0.01，源是英尺 → 通道拿到的就是 ft/100）
	minifcu:SetFcuAltValue()
	minifcu:SetFcuAltDot()

	-- MT 10 / MT 11 / MT 12：VS 与 FPA 互斥（参考档 digi_disp_set_VS 同一分支判据）
	local is_fpa = (safe_get(dr_trkfpa) >= 1)
	minifcu:SetFcuVsDashes()
	if is_fpa then
		minifcu:SetFcuVsValue(0)
		minifcu:SetFcuFpaValue(safe_get(dr_fpa))
	else
		minifcu:SetFcuVsValue(safe_get(dr_vs))
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

	-- 气压：单位 / STD / QNH 标签 + 两个值通道
	local baro_unit = safe_get(dr_baro_unit) -- 0 = inHg，1 = hPa
	local baro_mode = safe_get(dr_baro_mode) -- 参考档注释 QFE:0 QNH:1 STD:3
	local baro_inhg = safe_get(dr_baro_inhg) -- 机长侧气压（inHg）
	local baro_mbar = safe_get(dr_baro_mbar) -- 机长侧气压（hPa）

	-- MT 9：1 = inHg
	minifcu:SetEfisBaroInhgHpaUnit(baro_unit < 1 and 1 or 0)
	-- MT 8 / MT 7：参考档把 2 与 3 都当 STD（"if qfcu_c_barostd == 2 or qfcu_c_barostd == 3 then -- std"）
	local is_std = (baro_mode >= 2) and 1 or 0
	minifcu:SetEfisBaroStd1(is_std)
	minifcu:SetEfisBaroQnnh1(1 - is_std)
	-- MT 10 / MT 11：inHg × 100 与 hPa 整数（换算常量与参考档 / MINIFCU_FBW_A320NX.lua 一致）
	minifcu:SetEfisBaroInhg(math.floor(baro_inhg * 100 + 0.5))
	minifcu:SetEfisBaro(math.floor(baro_mbar + 0.5))
end)
