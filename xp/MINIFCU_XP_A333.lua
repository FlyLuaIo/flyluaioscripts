-- *****************************************************************
-- FlyLuaIO MobiFlight MiniFCU (miniFCU + miniEFIS) for X-Plane 12
-- Laminar Research Airbus A330-300（stock A333）
-- created by Wei Shuai <cpuwolf@gmail.com>
-- *****************************************************************
-- 来源与依据（可追溯）：
--   * 按键 / 显示源：xp/QFCU_XP_A333.lua（QFCU 同机型档）；每条绑定后的 [Q#] 标注该功能在 QFCU
--     面板上的 KeyIdx，便于与 QFCU 档逐条对照。
--   * 硬件通道契约：mobiflight/MiniFCU.json（按键 bit 0–46、编码器 bit 47–66、6 个 Output pin、
--     26 条 CustomDevice 通道）。
--   * 设备 API：com/sim/mf/MiniFCU.lua。
--   * 通道语义 / 编码器位序：xp/MINIFCU_Toliss.lua（真机 miniFCU 在 X-Plane 上手工调过并实测）。
--   * XP12 A333 原厂源（本档「修正」部分的依据，全部可在本机 X-Plane 12 内查证）：
--       - Aircraft/Laminar Research/Airbus A330-300/plugins/xlua/scripts/A333.*/*.lua
--       - Aircraft/Laminar Research/Airbus A330-300/objects/cockpit/A330_cockpit.obj（ATTR_manip_command）
--       - Resources/plugins/DataRefs.txt（sim dataref 注册表，5647 条）
-- 编码器位序（勿改）：每轴 4 bit，前 2 bit = 减，后 2 bit = 加。
--   ALT 47/48 减 · 49/50 加；SPD 51/52 · 53/54；HDG 55/56 · 57/58；VS 59/60 · 61/62；BARO 63/64 · 65/66
--
-- ★ 与 QFCU 档的差异（逐条给出依据，实机复核时对照这一节）：
--   1. QFCU 档的 LOC/AP1/AP2/A-THR/EXPED/APPR/METRIC/FD/LS 用的是 sim/custom/xap/fcu/*（XP11 A330 那套）。
--      XP12 A333 里查不到任何 xap：自带 xlua 无引用，DataRefs.txt 里 sim/custom/xap 0 条。
--      本档改用 A333 面板 obj 上写明的原厂绑定（见下方每条注释）。
--   2. FD LED：QFCU 档读 laminar/A333/PFD/FMAs/flight_dir_12_status —— A333 里没有这个名字
--      （xlua 只建了 laminar/A333/annun/capt_flight_director_on），本档改用后者。
--   3. FPA 值：QFCU 档把 sim/cockpit2/autopilot/trk_fpa 当角度用，而它实际是 0/1 模式枚举
--      （DataRefs.txt："0 = HDG/VS, 1 = TRK/FPA"）；真实 FPA 角度是 sim/cockpit2/autopilot/fpa（度）。
--   4. HDG 虚线：QFCU 档用 laminar/A333/autopilot/knobs/heading_push_pos（瞬时 -1/0/1 的按下量），
--      真实标志是 sim/cockpit2/EFIS/EFIS_hdg_hidden_pilot（A333.autopilot.lua:876 维护，1 = 数字隐藏）。
--   5. ALT managed 点：QFCU 档用 altitude_mode==3 反推；真实标志是 laminar/A333/lvl_ch_dot
--      （A333.autopilot.lua:887：fms_vnav==1 and vertical_mode~=6）。
--   6. BARO STD：QFCU 档直接写 sim/cockpit2/gauges/actuators/barometer_setting_is_std_pilot；
--      本档用 A333 自己的 laminar/A333/pull|push/baro/capt_std 命令（A333.switches.lua:5757-5759）。
--   7. ALT 100/1000 [Q15]：miniFCU 是瞬时键 —— 按住 = 1000 ft（alt_step_right）、松开 = 100（alt_step_left），
--      与 xp/MINIFCU_Toliss.lua 已验证写法同语义；QFCU 面板该键是拨杆（按下 100 / 松开 1000），方向相反。
--   8. 断电门控 / ANN LT 测试：QFCU 档的 power 是 XP11 A330 遗留的 sim/custom/xap/elec/acess
--      （XP12 里不存在）→ 本档改用 sim/cockpit/electrical/avionics_on（与 xp/z_QFCU_GA.lua 同源）；
--      TEST 判据 laminar/a333/switches/ann_light_pos == 2（A333 xlua 的面板开关，命令
--      laminar/A333/toggle_switch/ann_lt_up|dn）。熄屏走 CustomDevice 的 -1，TEST 用图案逼近，
--      做法同 xp/MINIFCU_Toliss.lua。亮度仍不移植：miniFCU 没有亮度通道。
--   9. 只做 XP12.40+ 单分支：QFCU 档的老分支整套依赖 sim/custom/xap/*，本机无法核实，故不移植。
--  10. ROSE 选择器 [Q24–Q28]：miniFCU 5 个独立键 → laminar/A333/knobs/EFIS_mode_pos_capt 0..4 =
--      LS / VOR / NAV / ARC / PLAN（A333.switches.lua:6272-6297）。A333 还有第 6 档 5 = ENG(ECAM on EFIS)，
--      miniFCU 面板没有这个键，故不接。
--  11. bit 25（CHRONO）：QFCU 面板无此键，本档接 A333 EFIS 上的 sim/instruments/chrono1_start_stop
--      （obj 里的 "Chrono START / STOP"）。
--  12. EXPED [Q12]：A330 真机没有 EXPED 键，QFCU 档把它接到 sim/custom/xap/fcu/push_alt。本档映射到
--      sim/autopilot/level_change（LVL/CH = altitude_mode 5），EXPED LED 跟着该模式亮。
--
-- 已知取舍（待真机验证）：
--   * SPD dot / HDG dot 用与「虚线」同一个标志：A333 没有单独的 managed 点数据源，真机 FCU 上 dashes 与
--     dot 本来就同时出现，这里保持一致。
--   * ALT 通道没有 dashes 通道（26 条 CustomDevice 里就没有），managed 只由 MT9 点体现。
--   * BARO 编码器按 JSON 绑满 4 bit（与 xp/z_MINIFCU_GA.lua 一致）；真机上若一格气压走两格，
--     把 64 / 66 两行注释掉即可（xp/MINIFCU_Toliss.lua 就是只绑 63/65 的写法）。
-- *****************************************************************

if ilua_require_plane_icao("A333") then return end

-- Do not remove below lines: hardware detection
local minifcu = com.sim.mf.MiniFCU.Open()
if not minifcu then return end
-- Do not remove above lines: hardware detection

uluaLog('MobiFlight MiniFCU for Laminar A330-300')

-- ===================== DataRefs（帧循环里需要读原值的几个） =====================

local dr_is_mach    = iDataRef:New("sim/cockpit2/autopilot/airspeed_is_mach")                      -- 1 = MACH 显示
local dr_spd_dashed = iDataRef:New("sim/cockpit2/autopilot/vnav_speed_window_open")                -- 0 = 虚线（managed）
local dr_vs         = iDataRef:New("sim/cockpit/autopilot/vertical_velocity")                      -- fpm
local dr_trkfpa     = iDataRef:New("sim/cockpit2/autopilot/trk_fpa")                               -- 1 = TRK/FPA
local dr_alt_mode   = iDataRef:New("sim/cockpit2/autopilot/altitude_mode")                         -- 5 = level change
local dr_baro       = iDataRef:New("sim/cockpit/misc/barometer_setting")                           -- 英寸汞柱
local dr_baro_unit  = iDataRef:New("laminar/A333/barometer/capt_inHg_hPa_pos")                     -- 0 = inHg, 1 = hPa
local dr_baro_std   = iDataRef:New("sim/cockpit2/gauges/actuators/barometer_setting_is_std_pilot") -- 1 = STD

-- ===================== INPUT：FCU 半区（bit 0–17） =====================

-- SPD/MACH 显示切换 [Q55]
minifcu:CfgCmd(0, "sim/autopilot/knots_mach_toggle")
-- HDG/TRK ↔ VS/FPA 切换 [Q54]
minifcu:CfgCmd(1, "sim/autopilot/trkfpa")
-- AP1 [Q10]：A333 面板 obj 上 AP1 键就是 sim/autopilot/servos_toggle（A333 再 wrap 成 Airbus AP1 逻辑）
minifcu:CfgCmd(2, "sim/autopilot/servos_toggle")
-- AP2 [Q9]
minifcu:CfgCmd(3, "sim/autopilot/servos2_toggle")
-- METRIC ALT [Q14]
minifcu:CfgCmd(4, "laminar/A333/autopilot/metric_alt_push")
-- A/THR [Q11]
minifcu:CfgCmd(5, "laminar/A333/autopilot/a_thr_toggle")
-- EXPED [Q12]：A330 无 EXPED，映射到 LVL/CH
minifcu:CfgCmd(6, "sim/autopilot/altitude_hold")
-- LOC [Q8]
minifcu:CfgCmd(7, "sim/autopilot/NAV")
-- APPR [Q13]
minifcu:CfgCmd(8, "sim/autopilot/approach")
-- SPD PUSH / PULL [Q2 / Q3]
minifcu:CfgCmd(9, "laminar/A333/autopilot/speed_knob_push")
minifcu:CfgCmd(10, "laminar/A333/autopilot/speed_knob_pull")
-- HDG PUSH / PULL [Q6 / Q7]
minifcu:CfgCmd(11, "laminar/A333/autopilot/heading_knob_push")
minifcu:CfgCmd(12, "laminar/A333/autopilot/heading_knob_pull")
-- ALT PUSH / PULL [Q18 / Q19]
minifcu:CfgCmd(13, "laminar/A333/autopilot/altitude_knob_push")
minifcu:CfgCmd(14, "laminar/A333/autopilot/altitude_knob_pull")
-- VS PUSH / PULL [Q22 / Q23]
minifcu:CfgCmd(15, "laminar/A333/autopilot/vertical_knob_push")
minifcu:CfgCmd(16, "laminar/A333/autopilot/vertical_knob_pull")
-- ALT 100/1000 [Q15]：按住 = 1000 ft 步长，松开 = 100 ft（见文件头第 7 条）
minifcu:CfgCmd(17, "laminar/A333/autopilot/alt_step_right", "laminar/A333/autopilot/alt_step_left")

-- ===================== INPUT：EFIS 半区机长侧（bit 18–46） =====================

-- 导航点过滤键 [Q35–Q39]
minifcu:CfgCmd(18, "laminar/A333/buttons/capt_EFIS_CSTR")
minifcu:CfgCmd(19, "sim/instruments/EFIS_fix")
minifcu:CfgCmd(20, "sim/instruments/EFIS_vor")
minifcu:CfgCmd(21, "sim/instruments/EFIS_ndb")
minifcu:CfgCmd(22, "sim/instruments/EFIS_apt")
-- FD [Q40]：obj 里 FD 键就是 sim/autopilot/fdir_command_bars_toggle（A333 用 replace_command 接管）
minifcu:CfgCmd(23, "sim/autopilot/fdir_command_bars_toggle")
-- LS [Q41]
minifcu:CfgCmd(24, "laminar/A333/buttons/capt_ils_bars_push")
-- CHRONO：QFCU 面板无此键，接 A333 EFIS 上的计时器（见文件头第 11 条）
minifcu:CfgCmd(25, "sim/instruments/chrono1_start_stop")

-- ROSE 模式键 [Q24–Q28]：0=LS 1=VOR 2=NAV 3=ARC 4=PLAN（A333 第 6 档 ENG 在 miniFCU 上无对应键）
local pswh24 = QmdevPosSwitchInit("laminar/A333/knobs/EFIS_mode_pos_capt", 1, "laminar/A333/knobs/capt_EFIS_knob_right",
	"laminar/A333/knobs/capt_EFIS_knob_left", 1300)
minifcu:CfgPSw(26, pswh24, 0)
minifcu:CfgPSw(27, pswh24, 1)
minifcu:CfgPSw(28, pswh24, 2)
minifcu:CfgPSw(29, pswh24, 3)
minifcu:CfgPSw(30, pswh24, 4)
minifcu:CfgPSw(67, pswh24, 5)

-- 距离 [Q29–Q34]：10/20/40/80/160/320 NM → sim/cockpit2/EFIS/map_range 0–5
--   （A333 自己面板的距离旋钮也是 0..5，见 obj 的 ATTR_manip_axis_knob rotate_large 0.000 5.000 1.000）
minifcu:CfgVal(31, "sim/cockpit2/EFIS/map_range", 0)
minifcu:CfgVal(32, "sim/cockpit2/EFIS/map_range", 1)
minifcu:CfgVal(33, "sim/cockpit2/EFIS/map_range", 2)
minifcu:CfgVal(34, "sim/cockpit2/EFIS/map_range", 3)
minifcu:CfgVal(35, "sim/cockpit2/EFIS/map_range", 4)
minifcu:CfgVal(36, "sim/cockpit2/EFIS/map_range", 5)

-- VOR/ADF 选择 1 与 2 [Q42–Q45]：miniFCU 是 ADF / OFF / VOR 三个独立按键，
--   QFCU 是两档拨杆（按下 = ADF/VOR，松开 = OFF）→ 这里三个键各写自己的值，OFF 键显式写 1。
--   enum：0 = ADF、1 = OFF、2 = VOR（DataRefs.txt:4146-4149）
minifcu:CfgVal(37, "sim/cockpit2/EFIS/EFIS_1_selection_pilot", 0) -- ADF 1
minifcu:CfgVal(38, "sim/cockpit2/EFIS/EFIS_1_selection_pilot", 1) -- OFF 1
minifcu:CfgVal(39, "sim/cockpit2/EFIS/EFIS_1_selection_pilot", 2) -- VOR 1
minifcu:CfgVal(40, "sim/cockpit2/EFIS/EFIS_2_selection_pilot", 0) -- ADF 2
minifcu:CfgVal(41, "sim/cockpit2/EFIS/EFIS_2_selection_pilot", 1) -- OFF 2
minifcu:CfgVal(42, "sim/cockpit2/EFIS/EFIS_2_selection_pilot", 2) -- VOR 2

-- 气压单位 [Q50]：A333 是 inHg / hPa 两个命令（各把 capt_inHg_hPa_pos 写 0 / 1）
minifcu:CfgCmd(43, "laminar/A333/knob/baro/capt_hPa")
minifcu:CfgCmd(44, "laminar/A333/knob/baro/capt_inHg")
-- 气压旋钮拉 / 按 [Q49 / Q48]
minifcu:CfgCmd(45, "laminar/A333/pull/baro/capt_std")
minifcu:CfgCmd(46, "laminar/A333/push/baro/capt_std")

-- ===================== INPUT：编码器（bit 47–66） =====================

-- ALT 编码器 [Q16 / Q17]
minifcu:CfgCmd(47, "sim/autopilot/altitude_down")
minifcu:CfgCmd(48, "sim/autopilot/altitude_down")
minifcu:CfgCmd(49, "sim/autopilot/altitude_up")
minifcu:CfgCmd(50, "sim/autopilot/altitude_up")

-- SPD 编码器 [Q0 / Q1]
minifcu:CfgCmd(51, "sim/autopilot/airspeed_down")
minifcu:CfgCmd(52, "sim/autopilot/airspeed_down")
minifcu:CfgCmd(53, "sim/autopilot/airspeed_up")
minifcu:CfgCmd(54, "sim/autopilot/airspeed_up")

-- HDG 编码器 [Q4 / Q5]
minifcu:CfgCmd(55, "sim/autopilot/heading_down")
minifcu:CfgCmd(56, "sim/autopilot/heading_down")
minifcu:CfgCmd(57, "sim/autopilot/heading_up")
minifcu:CfgCmd(58, "sim/autopilot/heading_up")

-- VS 编码器 [Q20 / Q21]：TRK/FPA 模式下 A333 自己把这两个命令 wrap 成 FPA +/-（A333.autopilot.lua:654-696）
minifcu:CfgCmd(59, "sim/autopilot/vertical_speed_down")
minifcu:CfgCmd(60, "sim/autopilot/vertical_speed_down")
minifcu:CfgCmd(61, "sim/autopilot/vertical_speed_up")
minifcu:CfgCmd(62, "sim/autopilot/vertical_speed_up")

-- BARO 编码器 [Q46 / Q47]：绑满 4 bit（见文件头「已知取舍」）
minifcu:CfgCmd(63, "sim/instruments/barometer_down")
minifcu:CfgCmd(64, "sim/instruments/barometer_down")
minifcu:CfgCmd(65, "sim/instruments/barometer_up")
minifcu:CfgCmd(66, "sim/instruments/barometer_up")

-- ===================== OUTPUT：6 个 LED pin =====================

minifcu:GetAp1("laminar/A333/annun/autopilot/ap1_mode", false, 0.1)
minifcu:GetAp2("laminar/A333/annun/autopilot/ap2_mode", false, 0.1)
minifcu:GetAthr("laminar/A333/annun/autopilot/a_thr_mode")
minifcu:GetLoc("laminar/A333/annun/autopilot/loc_mode")
minifcu:GetAppr("laminar/A333/annun/autopilot/appr_mode")
-- EXPED LED：跟着 LVL/CH（altitude_mode == 5）亮，判据在帧循环里给
minifcu:GetExped("sim/cockpit2/autopilot/altitude_mode", false, 5)

-- ============ OUTPUT：miniFCU LCD（CustomDevice，14 条） ============

-- MT 0 SPD 值（kts；MACH 模式或虚线时为 0）
minifcu:GetFcuSpdValue("sim/cockpit2/autopilot/airspeed_dial_kts")
-- MT 1 MACH 值（马赫 × 100；SPD 模式或虚线时为 0）
minifcu:GetFcuMachValue("sim/cockpit2/autopilot/airspeed_dial_kts_mach", 100)
-- MT 2 SPD/MACH 模式（1 = mach）
minifcu:GetFcuSpdMachMode("sim/cockpit2/autopilot/airspeed_is_mach")
-- MT 3 SPD 虚线（源 0 = 虚线 → revert）
minifcu:GetFcuSpdDashes("sim/cockpit2/autopilot/vnav_speed_window_open", true)
-- MT 4 SPD managed 点（与虚线同一标志，见文件头「已知取舍」）
minifcu:GetFcuSpdDot("sim/cockpit2/autopilot/vnav_speed_window_open", true)
-- MT 5 HDG 值（360 → 0 由面板处理）
minifcu:GetFcuHdgValue("sim/cockpit/autopilot/heading_mag")
-- MT 6 HDG 虚线（1 = 数字隐藏）
minifcu:GetFcuHdgDashes("sim/cockpit2/EFIS/EFIS_hdg_hidden_pilot")
-- MT 7 HDG managed 点（与虚线同一标志）
minifcu:GetFcuHdgDot("sim/cockpit2/EFIS/EFIS_hdg_hidden_pilot")
-- MT 8 ALT 值（ft / 100，scale 在 Get 里给）
minifcu:GetFcuAltValue("sim/cockpit/autopilot/altitude", 0.01)
-- MT 9 ALT managed 点
minifcu:GetFcuAltDot("laminar/A333/lvl_ch_dot")
-- MT 10 VS 值（fpm；TRK/FPA 模式下由帧循环置 0）
minifcu:GetFcuVsValue("sim/cockpit/autopilot/vertical_velocity")
-- MT 11 FPA 值（度；通道量纲 FPA × 1000 由默认 scale 给，非 TRK/FPA 模式置 0）
minifcu:GetFcuFpaValue("sim/cockpit2/autopilot/fpa")
-- MT 12 VS 虚线（源 0 = 虚线 → revert）
minifcu:GetFcuVsDashes("laminar/A333/autopilot/vvi_fpa_window_open", true)
-- MT 13 HDG/TRK 模式（1 = TRK）
minifcu:GetFcuHdgTrkMode("sim/cockpit2/autopilot/trk_fpa")

-- ============ OUTPUT：miniEFIS LED 与 LCD（CustomDevice，12 条） ============

-- MT 0–4：CSTR / WPT / VORD / NDB / ARPT
minifcu:GetEfisCstr("sim/cockpit2/EFIS/EFIS_data_on")
minifcu:GetEfisWpt("sim/cockpit2/EFIS/EFIS_fix_on")
minifcu:GetEfisVord("sim/cockpit2/EFIS/EFIS_vor_on")
minifcu:GetEfisNdb("sim/cockpit2/EFIS/EFIS_ndb_on")
minifcu:GetEfisArpt("sim/cockpit2/EFIS/EFIS_airport_on")
-- MT 5 / MT 6：FD / LS
minifcu:GetFcuFdValue("laminar/A333/annun/capt_flight_director_on")
minifcu:GetFcuLsValue("laminar/A333/annun/captain_ls_bars_on")
-- MT 7 QNH 标签（非 STD 即亮，判据在帧循环里给）
minifcu:GetEfisBaroQnnh1("sim/cockpit2/gauges/actuators/barometer_setting_is_std_pilot")
-- MT 8 STD 标志（1 = STD）
minifcu:GetEfisBaroStd1("sim/cockpit2/gauges/actuators/barometer_setting_is_std_pilot")
-- MT 9 单位（1 = inHg；A333 的 capt_inHg_hPa_pos 0 = inHg，故帧循环里取反）
minifcu:GetEfisBaroInhgHpaUnit("laminar/A333/barometer/capt_inHg_hPa_pos")
-- MT 10 BARO inHg（英寸汞柱 ×100）/ MT 11 BARO hPa（×33.864）
minifcu:GetEfisBaroInhg("sim/cockpit/misc/barometer_setting")
minifcu:GetEfisBaro("sim/cockpit/misc/barometer_setting")

-- ===================== 帧循环 =====================

-- ===========================================================
-- 冷舱 / 熄屏 + ANN LT 测试模式（与 xp/MINIFCU_Toliss.lua 同一套做法）
-- 两个源都逐字取自本机型的 QFCU 参考档（dr_qfcu_fcu_power / dr_qfcu_fcu_test）。

-- 断电判定源：QFCU 档按「值 > 0 = 通电」工作
local dr_fcu_avail  = iDataRef:New('sim/cockpit/electrical/avionics_on')
-- ANN LT 开关：0 = DIM / 1 = BRT / 2 = test mode → 测试态 = 2
local dr_annun_mode = iDataRef:New('laminar/a333/switches/ann_light_pos')

-- 断电 = 1 → kSetCustomDevice 32,<设备序号>,-1,0;（Connector MESSAGE_STOP 熄屏）；
-- 回 0 时插件会强制把该设备的每个通道重发一遍。Get*(path, revert=true)：
-- 源是「> 0 = 通电」，取反后通道值 1 = 熄灭。
minifcu:GetFcuPower('sim/cockpit/electrical/avionics_on', true)
minifcu:GetEfisPower('sim/cockpit/electrical/avionics_on', true)

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
	local annun_test = fcu_powered and dr_annun_mode:GetOld() == 2
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
	-- EXPED LED：LVL/CH（altitude_mode == 5）亮
	minifcu:SetExped()

	-- ---- FCU LCD ----
	local is_mach = dr_is_mach:Get()
	local spd_dash = dr_spd_dashed:Get()

	-- MT 2：SPD/MACH 模式
	minifcu:SetFcuSpdMachMode()

	-- MT 1：MACH 值（仅 MACH 模式且非虚线）
	if is_mach >= 1 and spd_dash >= 1 then
		minifcu:SetFcuMachValue()
	else
		minifcu:SetFcuMachValue(0)
	end

	-- MT 0：SPD 值（仅 SPD 模式且非虚线）
	if is_mach < 1 and spd_dash >= 1 then
		minifcu:SetFcuSpdValue()
	else
		minifcu:SetFcuSpdValue(0)
	end

	-- MT 3 / MT 4：SPD 虚线与 managed 点
	minifcu:SetFcuSpdDashes()
	minifcu:SetFcuSpdDot()

	-- MT 5 / MT 6 / MT 7：HDG
	minifcu:SetFcuHdgValue()
	minifcu:SetFcuHdgDashes()
	minifcu:SetFcuHdgDot()

	-- MT 8 / MT 9：ALT（ft/100 由注册时的 scale 0.01 给）
	minifcu:SetFcuAltValue()
	minifcu:SetFcuAltDot()

	-- MT 10 / MT 11 / MT 12：VS 与 FPA 互斥（TRK/FPA 模式下 VS 灭、FPA 亮）
	minifcu:SetFcuVsDashes()
	if dr_trkfpa:Get() >= 1 then
		minifcu:SetFcuVsValue(0)
		minifcu:SetFcuFpaValue()
	else
		minifcu:SetFcuVsValue(dr_vs:Get())
		minifcu:SetFcuFpaValue(0)
	end

	-- MT 13：HDG/TRK 模式
	minifcu:SetFcuHdgTrkMode()

	-- ---- miniEFIS ----
	minifcu:SetEfisCstr()
	minifcu:SetEfisWpt()
	minifcu:SetEfisVord()
	minifcu:SetEfisNdb()
	minifcu:SetEfisArpt()
	minifcu:SetFcuFdValue()
	minifcu:SetFcuLsValue()

	-- 气压：单位 / STD / QNH 标签 + 两个值通道（两个值都算，切单位不读陈旧值）
	local baro_unit = dr_baro_unit:Get() -- 0 = inHg, 1 = hPa
	local baro_std  = dr_baro_std:Get() -- 1 = STD
	local baro      = dr_baro:Get()   -- 英寸汞柱

	minifcu:SetEfisBaroInhgHpaUnit(baro_unit == 0 and 1 or 0)
	minifcu:SetEfisBaroStd1()
	minifcu:SetEfisBaroQnnh1(baro_std == 0 and 1 or 0)
	minifcu:SetEfisBaroInhg(math.floor(baro * 100 + 0.5))
	minifcu:SetEfisBaro(math.floor(baro * 33.864 + 0.5))
end)
