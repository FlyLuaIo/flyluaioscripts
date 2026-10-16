-- *****************************************************************
-- FlyLuaIO MobiFlight miniFCU (miniFCU + miniEFIS) for MSFS
-- FlightSimLabs A32X（A318/A319/A320/A321 家族）
-- created by Wei Shuai <cpuwolf@gmail.com>
-- *****************************************************************
-- 来源与依据（可追溯）：
--   * 事件名 / L 变量：msfs/data/QFCU_FSL_A32X.lua（FSLabs A32X 的 QFCU 档，MSFS 实测）。
--     每条绑定后的 [Q#] 标注该功能在 QFCU 面板上的 KeyIdx，便于与参考档逐条对照。
--     FS Labs 在本参考档里输入用 FSL.EVENT 系列 K 事件、显示用 FSL_ / VC_GSLD_ 前缀的 L 变量，
--     这里逐字复制，未自行发明任何事件名或变量名。
--   * 硬件通道契约：mobiflight/MiniFCU.json（按键 bit 0–46、编码器 bit 47–66、
--     6 个 Output pin、26 条 CustomDevice 通道）。
--   * 通道语义 / 编码器位序：xp/MINIFCU_Toliss.lua（真机 miniFCU 在 X-Plane 上手工调过并实测）。
-- 编码器位序（沿用 XP 档，勿改）：每轴 4 bit，前 2 bit = 减，后 2 bit = 加。
--   ALT 47/48 减 · 49/50 加；SPD 51/52 · 53/54；HDG 55/56 · 57/58；VS 59/60 · 61/62；BARO 63/64 · 65/66
-- 三处与参考档语义不同的换算（参考档面板是拨杆，miniFCU 是独立按键）：
--   1. ALT 100/1000（Q15 → miniFCU 17）：参考档按下发 ALT.100、松开发 ALT.1000；
--      miniFCU 是瞬时按键 —— 按住 = 1000 ft、松开回 100 ft，故两个事件对调。
--   2. BCN1/BCN2（Q42–45 → miniFCU 37–42）：参考档按下 = ADF/VOR、松开 = OFF；
--      miniFCU 是 ADF / OFF / VOR 三个独立按键 → 只发按下，OFF 键显式发 OFF 事件。
--   3. 气压单位（Q50 → miniFCU 43 HPA / 44 INHG）：参考档按下 = INHG、松开 = HPA；
--      miniFCU 两个独立按键 → 只发按下边沿，43/44 各自只发自己的那一个事件。
-- 已知取舍（待真机验证）：
--   1. 未做断电门控：参考档在 AC BUS 掉电时关 LCD / 背光，miniFCU 硬件无背光与熄灭通道，
--      XP 档也没有做，这里保持一致；如需冷舱熄灭请先确认硬件的“空屏”通道。
--   2. bit 25（EFIS-CHRONO）：参考档（QFCU 面板）没有这个键，也没有任何 CHRONO 事件
--      → 有意保持空绑定（FBW 档是借 QMPE 档的 A32NX_EFIS_L_CHRONO_PUSHED 补上的，FSLabs 无等价来源）。
--   3. 参考档有两个 EFIS 半区：机长 Q24–Q50 与副驾 Q51–Q53、Q56–Q79。miniFCU 只有一个 EFIS 半区，
--      本档只移植机长侧；参考档里的 FSL.EVENT.EFIS.FO.* 与 FSL.EVENT.EFIS.FO.BARO.* 一律不移植。
--   4. 显示量的量纲（参考档写法 → miniFCU 通道）：
--      * MACH：参考档按 `math.floor(qfcu_airspeed) / 100` 显示马赫，说明 L:FSL_FCU_SPD 在 MACH 模式
--        里已经是“马赫 × 100”（0.78 → 78）→ MT1 直接用原值（FBW 档要再乘 100，这里不乘）。
--      * SPD：同一变量在 SPD 模式里就是 kts → MT0 直接用原值。
--      * ALT：MT8 用 ft × 0.01（= ft / 100），与 FBW 档一致。
--      * VS / FPA：参考档 VS 模式直接取 L:FSL_FCU_VS 当 fpm；TRK/FPA 模式取 `math.abs(c_vs * 100)`，
--        而参考档里那句注释（“idr_qfcu_hid_vs_trkval_i need 0.8*1000=800”，与 FBW/iniBuilds 档同源）
--        说明 QFCU 硬件要的是 FPA × 1000 —— 由此反推 L:FSL_FCU_VS 在 TRK/FPA 模式里存的是 FPA × 10
--        （0.8° → 8）。miniFCU MT11 要的是“度”，故帧循环里取原值 / 10。
--      * BARO：参考档注释 “3042, not 30.42” 说明 L:FSL_EFIS_CPT_BARO 存的是“当前单位下的显示数字”
--        （inHg 模式 2992 / hPa 模式 1013，参考档把它原样喂给 QFCU 的两位 BCD 窗）。两个值都在帧循环里换算，
--        切单位时不会读到上一次的陈旧值，并自己 math.floor(x + 0.5)（int 通道会截断）。
--      * BARO 单位：参考档里 FSL_EFIS_CPT_BARO_UNIT 的两处线索互相矛盾 —— dataref 旁的备注
--        “-- HPA:1 inHG:0” 是从 Fenix 档（QFCU_FNX_A3XX.lua 的 N_FCU_EFIS1_BARO_INCH / S_FCU_EFIS1_BARO_MODE）
--        原样抄来的；而 digi_disp_set_L_EFIS 里真正决定显示的那一个判断是 `qfcu_c_barounit == 0` → QFCU mode 2
--        （Qfcu.lua: SetLBaro mode 2 = HPA）。本档以“有效显示分支”为准：1 = inHg、0 = hPa，
--        正好等于 miniFCU MT9 的约定，所以 MT9 直接绑定原变量。若真机上 inHg/hPa 反了，
--        把 MT9 的注册改成 '(L:FSL_EFIS_CPT_BARO_UNIT) 0 ==' 并把帧循环里两个值分支对调即可。
--      * STD：参考档 `FSL_EFIS_CPT_BARO_STD == 1` → QFCU mode 3（STD），`== 0` → 点 QNH 灯；
--        两处判断一致，故 MT8 = 该变量本身、MT7（QNH 标签）= 取反。
-- *****************************************************************

if ilua_require_msfs() then
	return
end
if ilua_require_fslabs_a32x() then return end

-- Do not remove below lines: hardware detection
local minifcu = com.sim.mf.MiniFCU.Open()
if not minifcu then return end
-- Do not remove above lines: hardware detection

uluaLog('MobiFlight MiniFCU for FlightSimLabs A32X')

-- ===========================================================
-- INPUT：FCU 半区（bit 0–17）

-- SPD/MACH 显示切换 [Q55]
minifcu:CfgRpn(0, '(>K:FSL.EVENT.FCU.SPDMACH.PRESS)')
-- HDG/TRK ↔ VS/FPA 切换 [Q54]
minifcu:CfgRpn(1, '(>K:FSL.EVENT.FCU.HDGVS.PRESS)')
-- AP1 [Q10]
minifcu:CfgRpn(2, '(>K:FSL.EVENT.FCU.AP1.PRESS)')
-- AP2 [Q9]
minifcu:CfgRpn(3, '(>K:FSL.EVENT.FCU.AP2.PRESS)')
-- METRIC ALT [Q14]
minifcu:CfgRpn(4, '(>K:FSL.EVENT.FCU.METRIC.PRESS)')
-- A/THR [Q11]
minifcu:CfgRpn(5, '(>K:FSL.EVENT.FCU.ATHR.PRESS)')
-- EXPED [Q12]
minifcu:CfgRpn(6, '(>K:FSL.EVENT.FCU.EXPD.PRESS)')
-- LOC [Q8]
minifcu:CfgRpn(7, '(>K:FSL.EVENT.FCU.LOC.PRESS)')
-- APPR [Q13]
minifcu:CfgRpn(8, '(>K:FSL.EVENT.FCU.APPR.PRESS)')
-- SPD PUSH/PULL [Q2 / Q3]
minifcu:CfgRpn(9, '(>K:FSL.EVENT.FCU.SPD.PUSH)')
minifcu:CfgRpn(10, '(>K:FSL.EVENT.FCU.SPD.PULL)')
-- HDG PUSH/PULL [Q6 / Q7]
minifcu:CfgRpn(11, '(>K:FSL.EVENT.FCU.HDG.PUSH)')
minifcu:CfgRpn(12, '(>K:FSL.EVENT.FCU.HDG.PULL)')
-- ALT PUSH/PULL [Q18 / Q19]
minifcu:CfgRpn(13, '(>K:FSL.EVENT.FCU.ALT.PUSH)')
minifcu:CfgRpn(14, '(>K:FSL.EVENT.FCU.ALT.PULL)')
-- VS PUSH/PULL [Q22 / Q23]
minifcu:CfgRpn(15, '(>K:FSL.EVENT.FCU.VS.PUSH)')
minifcu:CfgRpn(16, '(>K:FSL.EVENT.FCU.VS.PULL)')
-- ALT 100/1000 [Q15]：miniFCU 是瞬时按键 —— 按住 = 1000 ft 步长，松开回 100 ft。
--   参考档该键是拨杆：按下 = ALT.100、松开 = ALT.1000，语义与 miniFCU 相反，故两事件对调
--   （同 xp/MINIFCU_Toliss.lua 的 ALT100_1000 按下 1 / 松开 0）。
minifcu:CfgRpn(17, '(>K:FSL.EVENT.FCU.ALT.1000)', '(>K:FSL.EVENT.FCU.ALT.100)')

-- ===========================================================
-- INPUT：EFIS 半区机长侧（bit 18–46）

-- 导航点过滤键 [Q35–Q39]
minifcu:CfgRpn(18, '(>K:FSL.EVENT.EFIS.CPT.CSTR.PB)') -- CSTR [Q35]
minifcu:CfgRpn(19, '(>K:FSL.EVENT.EFIS.CPT.WPT.PB)') -- WPT [Q36]
minifcu:CfgRpn(20, '(>K:FSL.EVENT.EFIS.CPT.VORD.PB)') -- VORD [Q37]
minifcu:CfgRpn(21, '(>K:FSL.EVENT.EFIS.CPT.NDB.PB)') -- NDB [Q38]
minifcu:CfgRpn(22, '(>K:FSL.EVENT.EFIS.CPT.ARPT.PB)') -- ARPT [Q39]
-- FD / LS [Q40 / Q41]
minifcu:CfgRpn(23, '(>K:FSL.EVENT.EFIS.CPT.FD.PB)') -- FD [Q40]
minifcu:CfgRpn(24, '(>K:FSL.EVENT.EFIS.CPT.LS.PB)') -- LS [Q41]
-- bit 25（EFIS-CHRONO）：参考档 QFCU 面板无此键，也没有 CHRONO 事件 → 有意不绑定
-- TODO：参考档无对应源（FSLabs 的计时器在 MIP 上，本档唯一的权威参考档里没有它的 L/K 变量），
--   需要时先把同类参考档（如 msfs/data/QMPE_FSL_A32X.lua）加进 provenance 参考再绑定，现在不瞎猜。

-- ROSE 模式键 [Q24–Q28]：LS/VOR/NAV/ARC/PLN 各一个独立事件
minifcu:CfgRpn(26, '(>K:FSL.EVENT.EFIS.CPT.MODE.LS)') -- LS [Q24]
minifcu:CfgRpn(27, '(>K:FSL.EVENT.EFIS.CPT.MODE.VOR)') -- VOR [Q25]
minifcu:CfgRpn(28, '(>K:FSL.EVENT.EFIS.CPT.MODE.NAV)') -- NAV [Q26]
minifcu:CfgRpn(29, '(>K:FSL.EVENT.EFIS.CPT.MODE.ARC)') -- ARC [Q27]
minifcu:CfgRpn(30, '(>K:FSL.EVENT.EFIS.CPT.MODE.PLAN)') -- PLN [Q28]

-- 距离 [Q29–Q34]：参考档是“先读 K 再写回”的自复位开关，RPN 逐字照抄
minifcu:CfgRpn(31, '(K:FSL.EVENT.EFIS.CPT.RANGE.10) 0 (>K:FSL.EVENT.EFIS.CPT.RANGE.10)') -- 10 [Q29]
minifcu:CfgRpn(32, '(K:FSL.EVENT.EFIS.CPT.RANGE.20) 1 (>K:FSL.EVENT.EFIS.CPT.RANGE.20)') -- 20 [Q30]
minifcu:CfgRpn(33, '(K:FSL.EVENT.EFIS.CPT.RANGE.40) 2 (>K:FSL.EVENT.EFIS.CPT.RANGE.40)') -- 40 [Q31]
minifcu:CfgRpn(34, '(K:FSL.EVENT.EFIS.CPT.RANGE.80) 3 (>K:FSL.EVENT.EFIS.CPT.RANGE.80)') -- 80 [Q32]
minifcu:CfgRpn(35, '(K:FSL.EVENT.EFIS.CPT.RANGE.160) 4 (>K:FSL.EVENT.EFIS.CPT.RANGE.160)') -- 160 [Q33]
minifcu:CfgRpn(36, '(K:FSL.EVENT.EFIS.CPT.RANGE.320) 5 (>K:FSL.EVENT.EFIS.CPT.RANGE.320)') -- 320 [Q34]

-- BCN1 / BCN2 [Q42–Q45]：参考档是两档拨杆（按下 = ADF/VOR，松开 = OFF），
--   miniFCU 是 ADF / OFF / VOR 三个独立按键 → 只发按下，OFF 键显式发 OFF 事件。
minifcu:CfgRpn(37, '(>K:FSL.EVENT.EFIS.CPT.BCN1.ADF)') -- ADF 1 [Q42 按下值]
minifcu:CfgRpn(38, '(>K:FSL.EVENT.EFIS.CPT.BCN1.OFF)') -- OFF 1 [Q42 / Q43 松开值]
minifcu:CfgRpn(39, '(>K:FSL.EVENT.EFIS.CPT.BCN1.VOR)') -- VOR 1 [Q43 按下值]
minifcu:CfgRpn(40, '(>K:FSL.EVENT.EFIS.CPT.BCN2.ADF)') -- ADF 2 [Q44 按下值]
minifcu:CfgRpn(41, '(>K:FSL.EVENT.EFIS.CPT.BCN2.OFF)') -- OFF 2 [Q44 / Q45 松开值]
minifcu:CfgRpn(42, '(>K:FSL.EVENT.EFIS.CPT.BCN2.VOR)') -- VOR 2 [Q45 按下值]

-- 气压单位 [Q50]：参考档是单键拨杆（按下 = INHG，松开 = HPA），miniFCU 是两个独立按键，
--   故只发按下边沿；bit 43 是 JSON 里的 “BARO UNIT HPA” 键、bit 44 是 “INHG” 键，
--   与 msfs/MINIFCU_FBW_A320NX.lua 的 43 = HPA / 44 = INHG 保持一致。
minifcu:CfgRpn(43, '(>K:FSL.EVENT.EFIS.CPT.BARO.HPA)') -- HPA [Q50 松开值]
minifcu:CfgRpn(44, '(>K:FSL.EVENT.EFIS.CPT.BARO.INHG)') -- INHG [Q50 按下值]
-- 气压旋钮拉 / 按 [Q49 / Q48]
minifcu:CfgRpn(45, '(>K:FSL.EVENT.EFIS.CPT.BARO.PULL)')
minifcu:CfgRpn(46, '(>K:FSL.EVENT.EFIS.CPT.BARO.PUSH)')

-- ===========================================================
-- INPUT：编码器（bit 47–66）

-- ALT 编码器 [Q16 / Q17]
minifcu:CfgRpn(47, '(>K:FSL.EVENT.FCU.ALT.DEC)')
minifcu:CfgRpn(48, '(>K:FSL.EVENT.FCU.ALT.DEC)')
minifcu:CfgRpn(49, '(>K:FSL.EVENT.FCU.ALT.INC)')
minifcu:CfgRpn(50, '(>K:FSL.EVENT.FCU.ALT.INC)')

-- SPD 编码器 [Q0 / Q1]：参考档不区分 kts / mach，事件本身按当前模式走
minifcu:CfgRpn(51, '(>K:FSL.EVENT.FCU.SPD.DEC)')
minifcu:CfgRpn(52, '(>K:FSL.EVENT.FCU.SPD.DEC)')
minifcu:CfgRpn(53, '(>K:FSL.EVENT.FCU.SPD.INC)')
minifcu:CfgRpn(54, '(>K:FSL.EVENT.FCU.SPD.INC)')

-- HDG 编码器 [Q4 / Q5]
minifcu:CfgRpn(55, '(>K:FSL.EVENT.FCU.HDG.DEC)')
minifcu:CfgRpn(56, '(>K:FSL.EVENT.FCU.HDG.DEC)')
minifcu:CfgRpn(57, '(>K:FSL.EVENT.FCU.HDG.INC)')
minifcu:CfgRpn(58, '(>K:FSL.EVENT.FCU.HDG.INC)')

-- VS 编码器 [Q20 / Q21]
minifcu:CfgRpn(59, '(>K:FSL.EVENT.FCU.VS.DEC)')
minifcu:CfgRpn(60, '(>K:FSL.EVENT.FCU.VS.DEC)')
minifcu:CfgRpn(61, '(>K:FSL.EVENT.FCU.VS.INC)')
minifcu:CfgRpn(62, '(>K:FSL.EVENT.FCU.VS.INC)')

-- BARO 编码器（机长侧）[Q46 / Q47]
minifcu:CfgRpn(63, '(>K:FSL.EVENT.EFIS.CPT.BARO.DEC)')
minifcu:CfgRpn(64, '(>K:FSL.EVENT.EFIS.CPT.BARO.DEC)')
minifcu:CfgRpn(65, '(>K:FSL.EVENT.EFIS.CPT.BARO.INC)')
minifcu:CfgRpn(66, '(>K:FSL.EVENT.EFIS.CPT.BARO.INC)')

-- ===========================================================
-- 显示源（帧循环里直接读；iDataRef:New 找不到路径会返回 nil，统一用 safe_get 兜底）

local function safe_get(dr)
	if dr == nil then
		return 0
	end
	return dr:Get()
end

-- FCU
local dr_spd          = iDataRef:New('(L:FSL_FCU_SPD)') -- SPD 模式 = kts；MACH 模式 = 马赫 × 100
local dr_is_mach      = iDataRef:New('(L:FSL_FCU_MACH_MODE)') -- 1 = 显示 MACH
local dr_spd_dashes   = iDataRef:New('(L:FSL_FCU_SPD_DASHED)')
local dr_spd_managed  = iDataRef:New('(L:FSL_FCU_SPD_MANAGED)')
local dr_hdg          = iDataRef:New('(L:FSL_FCU_HDG)')
local dr_hdg_dashes   = iDataRef:New('(L:FSL_FCU_HDG_DASHED)')
local dr_hdg_managed  = iDataRef:New('(L:FSL_FCU_HDG_MANAGED)')
local dr_alt          = iDataRef:New('(L:FSL_FCU_ALT)') -- ft
local dr_alt_managed  = iDataRef:New('(L:FSL_FCU_ALT_MANAGED)')
local dr_vs           = iDataRef:New('(L:FSL_FCU_VS)') -- VS 模式 = fpm；TRK/FPA 模式 = FPA × 10
local dr_vs_dashes    = iDataRef:New('(L:FSL_FCU_VS_DASHED)')
local dr_trk_fpa      = iDataRef:New('(L:FSL_FCU_TRKFPA)') -- 1 = TRK/FPA

-- EFIS 机长侧气压：UNIT 1 = inHg / 0 = hPa；STD 1 = STD；BARO = 当前单位下的显示数字
local dr_baro_unit    = iDataRef:New('(L:FSL_EFIS_CPT_BARO_UNIT)')
local dr_baro_std     = iDataRef:New('(L:FSL_EFIS_CPT_BARO_STD)')
local dr_baro         = iDataRef:New('(L:FSL_EFIS_CPT_BARO)') -- inHg 模式 2992 / hPa 模式 1013

-- ===========================================================
-- OUTPUT：6 个 LED pin
minifcu:GetAp1('(L:VC_GSLD_FCU_AP1_Brt_Lt)')
minifcu:GetAp2('(L:VC_GSLD_FCU_AP2_Brt_Lt)')
minifcu:GetAthr('(L:VC_GSLD_FCU_ATHR_Brt_Lt)')
minifcu:GetLoc('(L:VC_GSLD_FCU_LOC_Brt_Lt)')
minifcu:GetAppr('(L:VC_GSLD_FCU_APPR_Brt_Lt)')
minifcu:GetExped('(L:VC_GSLD_FCU_EXPED_Brt_Lt)')

-- ===========================================================
-- OUTPUT：miniFCU LCD（CustomDevice 26 通道 = 14 FCU + 12 EFIS，全部保留）

-- MT 0 SPD 值（kts，仅 SPD 模式且非 dashed）
minifcu:GetFcuSpdValue('(L:FSL_FCU_SPD)')
-- MT 1 MACH 值（参考档里已经是 马赫 × 100，故不再乘系数）
minifcu:GetFcuMachValue('(L:FSL_FCU_SPD)')
-- MT 2 SPD/MACH 模式（1 = mach）
minifcu:GetFcuSpdMachMode('(L:FSL_FCU_MACH_MODE)')
-- MT 3 SPD dashed
minifcu:GetFcuSpdDashes('(L:FSL_FCU_SPD_DASHED)')
-- MT 4 SPD managed 点
minifcu:GetFcuSpdDot('(L:FSL_FCU_SPD_MANAGED)')
-- MT 5 HDG 值
minifcu:GetFcuHdgValue('(L:FSL_FCU_HDG)')
-- MT 6 HDG dashed
minifcu:GetFcuHdgDashes('(L:FSL_FCU_HDG_DASHED)')
-- MT 7 HDG managed 点
minifcu:GetFcuHdgDot('(L:FSL_FCU_HDG_MANAGED)')
-- MT 8 ALT 值（ft / 100）
minifcu:GetFcuAltValue('(L:FSL_FCU_ALT)', 0.01)
-- MT 9 ALT managed 点
minifcu:GetFcuAltDot('(L:FSL_FCU_ALT_MANAGED)')
-- MT 10 VS 值（fpm，TRK/FPA 模式下隐藏）
minifcu:GetFcuVsValue('(L:FSL_FCU_VS)')
-- MT 11 FPA 值（度，TRK/FPA 模式下显示；帧循环里把 FPA × 10 还原成度）
minifcu:GetFcuFpaValue('(L:FSL_FCU_VS)')
-- MT 12 VS dashed
minifcu:GetFcuVsDashes('(L:FSL_FCU_VS_DASHED)')
-- MT 13 HDG/TRK 模式（1 = TRK）
minifcu:GetFcuHdgTrkMode('(L:FSL_FCU_TRKFPA)')

-- MT 0 CSTR / MT 1 WPT / MT 2 VORD / MT 3 NDB / MT 4 ARPT（参考档的 EFIS 灯变量，机长侧）
minifcu:GetEfisCstr('(L:VC_GSLD_CP_EFIS_CSTR_BRT_Lt)')
minifcu:GetEfisWpt('(L:VC_GSLD_CP_EFIS_WPT_BRT_Lt)')
minifcu:GetEfisVord('(L:VC_GSLD_CP_EFIS_VORD_BRT_Lt)')
minifcu:GetEfisNdb('(L:VC_GSLD_CP_EFIS_NDB_BRT_Lt)')
minifcu:GetEfisArpt('(L:VC_GSLD_CP_EFIS_ARPT_BRT_Lt)')
-- MT 5 FD / MT 6 LS
minifcu:GetFcuFdValue('(L:VC_GSLD_CP_EFIS_FD_BRT_Lt)')
minifcu:GetFcuLsValue('(L:VC_GSLD_CP_EFIS_LS_BRT_Lt)')
-- MT 7 QNH 标签 / MT 8 STD 标志：同一个 STD 变量，帧循环里按“STD 相反者”显式取值
minifcu:GetEfisBaroQnnh1('(L:FSL_EFIS_CPT_BARO_STD)')
minifcu:GetEfisBaroStd1('(L:FSL_EFIS_CPT_BARO_STD)')
-- MT 9 inHg/hPa（1 = inHg，与参考档 UNIT 变量的约定一致）
minifcu:GetEfisBaroInhgHpaUnit('(L:FSL_EFIS_CPT_BARO_UNIT)')
-- MT 10 BARO inHg（×100）/ MT 11 BARO hPa（两个值都在帧循环里换算后写入）
minifcu:GetEfisBaroInhg('(L:FSL_EFIS_CPT_BARO)')
minifcu:GetEfisBaro('(L:FSL_EFIS_CPT_BARO)')

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
	local is_mach  = safe_get(dr_is_mach)
	local spd_dash = safe_get(dr_spd_dashes)
	local spd_val  = safe_get(dr_spd)

	-- MT 2：SPD/MACH 模式
	minifcu:SetFcuSpdMachMode(is_mach >= 1 and 1 or 0)

	-- MT 1：MACH 值（参考档里已经是 马赫 × 100；SPD 模式或 dashed 时置 0，与 XP 档一致）
	if is_mach >= 1 and spd_dash < 1 then
		minifcu:SetFcuMachValue(math.floor(spd_val + 0.5))
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
	minifcu:SetFcuSpdDashes()
	minifcu:SetFcuSpdDot()

	-- MT 5 / MT 6 / MT 7：HDG
	minifcu:SetFcuHdgValue()
	minifcu:SetFcuHdgDashes()
	minifcu:SetFcuHdgDot()

	-- MT 8 / MT 9：ALT
	minifcu:SetFcuAltValue()
	minifcu:SetFcuAltDot()

	-- MT 10 / MT 11 / MT 12：VS 与 FPA 互斥
	local is_fpa = (safe_get(dr_trk_fpa) >= 1)
	minifcu:SetFcuVsDashes()
	if is_fpa then
		-- TRK/FPA 模式：L:FSL_FCU_VS 存 FPA × 10（见文件头说明），MT11 要的是度
		minifcu:SetFcuVsValue(0)
		minifcu:SetFcuFpaValue(safe_get(dr_vs) / 10)
	else
		-- VS 模式：带符号 fpm
		minifcu:SetFcuVsValue(safe_get(dr_vs))
		minifcu:SetFcuFpaValue(0)
	end

	-- MT 13：HDG/TRK 模式
	minifcu:SetFcuHdgTrkMode()

	-- ---- EFIS 半区（机长侧）----
	minifcu:SetEfisCstr()
	minifcu:SetEfisWpt()
	minifcu:SetEfisVord()
	minifcu:SetEfisNdb()
	minifcu:SetEfisArpt()
	minifcu:SetFcuFdValue()
	minifcu:SetFcuLsValue()

	-- 气压：STD / QNH 标签 / 单位 / 两个值通道（两个值都算，切单位时不会读到上一次的陈旧值）
	local baro_std  = safe_get(dr_baro_std) -- 1 = STD
	local baro_unit = safe_get(dr_baro_unit) -- 1 = inHg（见文件头说明）
	local baro_val  = safe_get(dr_baro) -- 当前单位下的显示数字：inHg 2992 / hPa 1013

	minifcu:SetEfisBaroInhgHpaUnit(baro_unit >= 1 and 1 or 0)
	minifcu:SetEfisBaroStd1(baro_std >= 1 and 1 or 0)
	minifcu:SetEfisBaroQnnh1(baro_std >= 1 and 0 or 1)

	if baro_unit >= 1 then
		-- inHg：原值就是 inHg × 100
		minifcu:SetEfisBaroInhg(math.floor(baro_val + 0.5))
		minifcu:SetEfisBaro(math.floor(baro_val * 33.8638895 / 100 + 0.5)) -- → hPa
	else
		-- hPa：原值就是 hPa 整数
		minifcu:SetEfisBaro(math.floor(baro_val + 0.5))
		minifcu:SetEfisBaroInhg(math.floor(baro_val * 100 / 33.8638895 + 0.5)) -- → inHg × 100
	end
end)
