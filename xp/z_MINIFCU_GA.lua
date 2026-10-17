-- *****************************************************************
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-10-15
-- MobiFlight MiniFCU / miniCOCKPIT miniFCU for GA
-- *****************************************************************

-- Do not remove below lines: hardware detection
local minifcu = com.sim.mf.MiniFCU.Open()
if not minifcu then return end
-- Do not remove above lines: hardware detection

uluaLog('MobiFlight MiniFCU for GA')

-- INPUT key bindings (keysmap bits from mobiflight/MiniFCU.json)

---- FCU - ALT - ENCODER
-- inner
minifcu:CfgCmd(47, "sim/autopilot/altitude_down")
minifcu:CfgCmd(48, "sim/autopilot/altitude_down")
-- outer
minifcu:CfgCmd(49, "sim/autopilot/altitude_up")
minifcu:CfgCmd(50, "sim/autopilot/altitude_up")

---- FCU - SPD - ENCODER
-- inner
minifcu:CfgCmd(51, "sim/autopilot/airspeed_down")
minifcu:CfgCmd(52, "sim/autopilot/airspeed_down")
-- outer
minifcu:CfgCmd(53, "sim/autopilot/airspeed_up")
minifcu:CfgCmd(54, "sim/autopilot/airspeed_up")

---- FCU - HDG - ENCODER
-- inner
minifcu:CfgCmd(55, "sim/autopilot/heading_down")
-- minifcu:CfgCmd(56, "sim/autopilot/heading_down")
-- outer
minifcu:CfgCmd(57, "sim/autopilot/heading_up")
-- minifcu:CfgCmd(58, "sim/autopilot/heading_up")
minifcu:CfgEncFull(56, 58, 'sim/cockpit/autopilot/heading_mag', 10, 10, 0, 0, 360)

---- FCU - VS - ENCODER
-- inner
minifcu:CfgCmd(59, "sim/autopilot/vertical_speed_down")
minifcu:CfgCmd(60, "sim/autopilot/vertical_speed_down")
-- outer
minifcu:CfgCmd(61, "sim/autopilot/vertical_speed_up")
minifcu:CfgCmd(62, "sim/autopilot/vertical_speed_up")

---- EFIS - BAR ENCODER HPA
-- inner
minifcu:CfgCmd(63, "sim/instruments/barometer_down")
minifcu:CfgCmd(64, "sim/instruments/barometer_down")
-- outer
minifcu:CfgCmd(65, "sim/instruments/barometer_up")
minifcu:CfgCmd(66, "sim/instruments/barometer_up")

-- FCU - SPD/MACH (Button, bit 0)
minifcu:CfgCmd(0, "sim/operation/test_none")

-- FCU - HDG/TRK (Button, bit 1)
minifcu:CfgCmd(1, "sim/operation/test_none")

-- FCU - AP1 - BUTTON (Button, bit 2)
minifcu:CfgCmd(2, "sim/autopilot/servos_toggle")

-- FCU - AP 2 - BUTTON (Button, bit 3)
minifcu:CfgCmd(3, "sim/autopilot/servos_toggle")

-- FCU - METRIC ALT Button (Button, bit 4)
minifcu:CfgCmd(4, "sim/operation/test_none")

-- FCU - ATHR - BUTTON (Button, bit 5)
minifcu:CfgCmd(5, "sim/operation/test_none")

-- FCU - EXPED - BUTTON (Button, bit 6)
minifcu:CfgCmd(6, "sim/autopilot/level_change")

-- FCU - LOC - BUTTON (Button, bit 7)
minifcu:CfgCmd(7, "sim/autopilot/NAV")

-- FCU - APPR - BUTTON (Button, bit 8)
minifcu:CfgCmd(8, "sim/autopilot/approach")

-- FCU - SPD - PUSH (Button, bit 9)
minifcu:CfgCmd(9, "sim/operation/test_none")

-- FCU - SPD - PULL (Button, bit 10)
minifcu:CfgCmd(10, "sim/operation/test_none")

-- FCU - HDG - PUSH (Button, bit 11)
minifcu:CfgCmd(11, "sim/autopilot/NAV")

-- FCU - HDG - PULL (Button, bit 12)
minifcu:CfgCmd(12, "sim/autopilot/heading")

-- FCU - ALT - PUSH (Button, bit 13)
minifcu:CfgCmd(13, "sim/autopilot/vnav")

-- FCU - ALT - PULL (Button, bit 14)
minifcu:CfgCmd(14, "sim/autopilot/altitude_hold")

-- FCU - VS - PUSH (Button, bit 15)
minifcu:CfgCmd(15, "sim/autopilot/return_to_level")

-- FCU - VS - PULL (Button, bit 16)
minifcu:CfgCmd(16, "sim/autopilot/alt_vs")

-- FCU - ALT 100/1000 (Button, bit 17)
minifcu:CfgCmd(17, "sim/operation/test_none")

-- EFIS - CSTR (Button, bit 18)
minifcu:CfgCmd(18, "sim/operation/test_none")

-- EFIS - WPT (Button, bit 19)
minifcu:CfgCmd(19, "sim/operation/test_none")

-- EFIS - VORD (Button, bit 20)
minifcu:CfgCmd(20, "sim/operation/test_none")

-- EFIS - NDB (Button, bit 21)
minifcu:CfgCmd(21, "sim/operation/test_none")

-- EFIS - ARPT (Button, bit 22)
minifcu:CfgCmd(22, "sim/operation/test_none")

-- EFIS - FD (Button, bit 23)
minifcu:CfgCmd(23, "sim/autopilot/fdir_toggle")

-- EFIS - LS (Button, bit 24)
minifcu:CfgCmd(24, "sim/operation/test_none")

-- EFIS - CHRONO (Button, bit 25)：X-Plane 自带 1 号计时器（Commands.txt: sim/instruments/chrono1_start_stop）
minifcu:CfgCmd(25, "sim/instruments/chrono1_start_stop")

-- EFIS - ROSE LS (Button, bit 26)
minifcu:CfgCmd(26, "sim/operation/test_none")

-- EFIS - ROSE VOR (Button, bit 27)
minifcu:CfgCmd(27, "sim/operation/test_none")

-- EFIS - ROSE NAV (Button, bit 28)
minifcu:CfgCmd(28, "sim/operation/test_none")

-- EFIS - ROSE ARC (Button, bit 29)
minifcu:CfgCmd(29, "sim/operation/test_none")

-- EFIS - ROSE HIDDEN  (Button, bit 30)
minifcu:CfgCmd(30, "sim/operation/test_none")

-- EFIS - RANGE 10 (Button, bit 31)
minifcu:CfgCmd(31, "sim/operation/test_none")

-- EFIS - RANGE 20 (Button, bit 32)
minifcu:CfgCmd(32, "sim/operation/test_none")

-- EFIS - RANGE 40 (Button, bit 33)
minifcu:CfgCmd(33, "sim/operation/test_none")

-- EFIS - RANGE 80 (Button, bit 34)
minifcu:CfgCmd(34, "sim/operation/test_none")

-- EFIS - RANGE 160 (Button, bit 35)
minifcu:CfgCmd(35, "sim/operation/test_none")

-- EFIS - RANGE 320 (Button, bit 36)
minifcu:CfgCmd(36, "sim/operation/test_none")

-- EFIS - ADF 1 (Button, bit 37)
minifcu:CfgCmd(37, "sim/operation/test_none")

-- EFIS - OFF 1 (Button, bit 38)
minifcu:CfgCmd(38, "sim/operation/test_none")

-- EFIS - VOR 1 (Button, bit 39)
minifcu:CfgCmd(39, "sim/operation/test_none")

-- EFIS - ADF 2 (Button, bit 40)
minifcu:CfgCmd(40, "sim/operation/test_none")

-- EFIS - OFF 2 (Button, bit 41)
minifcu:CfgCmd(41, "sim/operation/test_none")

-- EFIS - VOR 2 (Button, bit 42)
minifcu:CfgCmd(42, "sim/operation/test_none")

-- EFIS - BARO UNIT HPA (Button, bit 43) → sim/physics/metric_press = 1（公制 = hPa）
minifcu:CfgVal(43, "sim/physics/metric_press", 1)

-- EFIS - BARO UNIT INHG (Button, bit 44) → sim/physics/metric_press = 0（inHg）
minifcu:CfgVal(44, "sim/physics/metric_press", 0)

-- EFIS - BARO PULL (Button, bit 45)
minifcu:CfgCmd(45, "sim/operation/test_none")

-- EFIS - BARO PUSH (Button, bit 46)
minifcu:CfgCmd(46, "sim/operation/test_none")

-- OUTPUT data

-- output AP1 → output/0/state, pin AP1 (0/1)
minifcu:GetAp1('sim/cockpit2/autopilot/servos_on')

-- output AP2 → output/1/state, pin AP2 (0/1)
minifcu:GetAp2('sim/cockpit2/autopilot/servos_on')

-- output APPR → output/2/state, pin APPR (0/1)
minifcu:GetAppr('sim/cockpit2/autopilot/approach_status')

-- output ATHR → output/3/state, pin ATHR (0/1)
minifcu:GetAthr('sim/cockpit2/autopilot/autothrottle_on')

-- output EXPED → output/4/state, pin EXPED (0/1)
minifcu:GetExped('sim/cockpit2/autopilot/altitude_mode', false, 4.9)

-- output LOC → output/5/state, pin LOC (0/1)
minifcu:GetLoc('sim/cockpit2/autopilot/nav_status')

-- MT 0 (miniFCU LCD): FcuSpdValue — SPD value（kts 整数）
minifcu:GetFcuSpdValue('sim/cockpit2/autopilot/airspeed_dial_kts_mach')

-- MT 1 (miniFCU LCD): FcuMachValue — MACH value（airspeed*100）
minifcu:GetFcuMachValue('sim/flightmodel/engine/ENGN_N1_')

-- MT 2 (miniFCU LCD): FcuSpdMachMode — SPD/MACH 模式（1=mach, 0=ias）
minifcu:GetFcuSpdMachMode('sim/flightmodel/engine/ENGN_N1_')

-- MT 3 (miniFCU LCD): FcuSpdDashes — SPD dashes（1）
minifcu:GetFcuSpdDashes('sim/flightmodel/engine/ENGN_N1_')

-- MT 4 (miniFCU LCD): FcuSpdDot — SPD dot（managed）
minifcu:GetFcuSpdDot('sim/flightmodel/engine/ENGN_N1_')

-- MT 5 (miniFCU LCD): FcuHdgValue — HDG value（360→0）
minifcu:GetFcuHdgValue('sim/cockpit/autopilot/heading_mag')

-- MT 6 (miniFCU LCD): FcuHdgDashes — HDG dashes（1）
minifcu:GetFcuHdgDashes('sim/cockpit2/switches/avionics_power_on')

-- MT 7 (miniFCU LCD): FcuHdgDot — HDG dot（managed）
minifcu:GetFcuHdgDot('sim/flightmodel/engine/ENGN_N1_')

-- MT 8 (miniFCU LCD): FcuAltValue — ALT value（ft/100）
minifcu:GetFcuAltValue('sim/cockpit2/autopilot/altitude_dial_ft', 0.01)

-- MT 9 (miniFCU LCD): FcuAltDot — ALT dot（managed）
minifcu:GetFcuAltDot('sim/flightmodel/engine/ENGN_N1_')

-- MT 10 (miniFCU LCD): FcuVsValue — VS value
minifcu:GetFcuVsValue('sim/cockpit2/autopilot/vvi_dial_fpm')

-- MT 11 (miniFCU LCD): FcuFpaValue — FPA value
minifcu:GetFcuFpaValue('sim/flightmodel/engine/ENGN_N1_')

-- MT 12 (miniFCU LCD): FcuVsDashes — VS dashes（1）
minifcu:GetFcuVsDashes('sim/cockpit2/autopilot/vvi_status', true)

-- MT 13 (miniFCU LCD): FcuHdgTrkMode — HDG/TRK 模式（1=TRK）
minifcu:GetFcuHdgTrkMode('sim/flightmodel/engine/ENGN_N1_')

-- MT 0 (miniEFIS LED and LCD): EfisCstr — CSTR 灯（1=on）
minifcu:GetEfisCstr('sim/flightmodel/engine/ENGN_N1_')

-- MT 1 (miniEFIS LED and LCD): EfisWpt — WPT 灯（1=on）
minifcu:GetEfisWpt('sim/flightmodel/engine/ENGN_N1_')

-- MT 2 (miniEFIS LED and LCD): EfisVord — VOR/D 灯（1=on）
minifcu:GetEfisVord('sim/flightmodel/engine/ENGN_N1_')

-- MT 3 (miniEFIS LED and LCD): EfisNdb — NDB 灯（1=on）
minifcu:GetEfisNdb('sim/flightmodel/engine/ENGN_N1_')

-- MT 4 (miniEFIS LED and LCD): EfisArpt — ARPT 灯（1=on）
minifcu:GetEfisArpt('sim/flightmodel/engine/ENGN_N1_')

-- MT 5 (miniEFIS LED and LCD): FcuFdValue — FD 灯（1=on）
minifcu:GetFcuFdValue('sim/cockpit/warnings/annunciators/flight_director')

-- MT 6 (miniEFIS LED and LCD): FcuLsValue — LS 灯（1=on）
minifcu:GetFcuLsValue('sim/flightmodel/engine/ENGN_N1_')

-- ===================== miniEFIS BARO（GA，已接通） =====================
-- 源：机长气压设定（英寸汞柱）+ XP 的 STD 状态 + XP 的「公制压力显示」偏好。
-- MT 10/11 的 scale 用默认 1：数值在 FrameLoop 里算好再写 dataref。
-- dataref 是 int、没有小数位，所以 ×100（inHg）/ ×33.864（hPa）必须自己四舍五入。

-- 机长气压设定，单位英寸汞柱（sim/cockpit2/gauges/actuators/barometer_setting_in_hg_pilot 的旧版）
local dr_baro_inhg    = iDataRef:New("sim/cockpit/misc/barometer_setting")
-- 0 = 正常（QNH），1 = STD
local dr_baro_std     = iDataRef:New("sim/cockpit2/gauges/actuators/barometer_setting_is_std_pilot")
-- 0 = inHg，1 = hPa（公制）
local dr_metric_press = iDataRef:New("sim/physics/metric_press")

-- MT 7 (miniEFIS LED and LCD): EfisBaroQnnh1 — QNH 标签（非 STD 时为 1）
minifcu:GetEfisBaroQnnh1("sim/cockpit2/gauges/actuators/barometer_setting_is_std_pilot")

-- MT 8 (miniEFIS LED and LCD): EfisBaroStd1 — STD 标志（1=on）
minifcu:GetEfisBaroStd1("sim/cockpit2/gauges/actuators/barometer_setting_is_std_pilot")

-- MT 9 (miniEFIS LED and LCD): EfisBaroInhgHpaUnit — inHg/hPa（1=inHg, 0=hPa）
minifcu:GetEfisBaroInhgHpaUnit("sim/physics/metric_press")

-- MT 10 (miniEFIS LED and LCD): EfisBaroInhg — BARO inHg（inHg*100 四舍五入）
minifcu:GetEfisBaroInhg("sim/cockpit/misc/barometer_setting")

-- MT 11 (miniEFIS LED and LCD): EfisBaro — BARO hPa（inHg*33.864 四舍五入）
minifcu:GetEfisBaro("sim/cockpit/misc/barometer_setting")

local dr_flc_mode = iDataRef:New("sim/cockpit2/autopilot/altitude_mode")

GlobalFrameLoopManager:add(function()
	-- 6 个 LED（源接好后再打开）
	minifcu:SetAp1()
	minifcu:SetAp2()
	minifcu:SetAppr()
	minifcu:SetAthr()
	minifcu:SetExped(dr_flc_mode:Get() == 5 and 1 or 0)
	-- minifcu:SetLoc()
	minifcu:SetFcuSpdValue()
	-- minifcu:SetFcuMachValue()
	-- minifcu:SetFcuSpdMachMode()
	-- minifcu:SetFcuSpdDashes()
	-- minifcu:SetFcuSpdDot(0)
	minifcu:SetFcuHdgDashes(0)
	minifcu:SetFcuHdgValue()
	minifcu:SetFcuHdgDot(0)
	minifcu:SetFcuAltValue()
	-- minifcu:SetFcuAltDot()

	minifcu:SetFcuVsDashes()
	minifcu:SetFcuVsValue()
	-- minifcu:SetFcuFpaValue()

	-- minifcu:SetFcuHdgTrkMode()
	-- minifcu:SetEfisCstr()
	-- minifcu:SetEfisWpt()
	-- minifcu:SetEfisVord()
	-- minifcu:SetEfisNdb()
	-- minifcu:SetEfisArpt()
	minifcu:SetFcuFdValue()
	-- minifcu:SetFcuLsValue()
	-- miniEFIS BARO：单位 / STD / QNH 标签 + 两个值通道
	local baro_inhg = dr_baro_inhg:Get()
	local baro_std  = dr_baro_std:Get()
	local metric    = dr_metric_press:Get()

	-- MT 9: 1 = inHg, 0 = hPa（metric_press: 1 = 公制/hPa）
	minifcu:SetEfisBaroInhgHpaUnit(metric == 1 and 0 or 1)
	-- MT 8: STD 标志（直接读 dataref，0/1）
	minifcu:SetEfisBaroStd1()
	-- MT 7: STD 时 QNH 标签灭
	minifcu:SetEfisBaroQnnh1(baro_std == 0 and 1 or 0)
	-- MT 10/11: 两个值都算，面板按单位标志取一个显示（切单位时不会读到上一次的陈旧值）
	minifcu:SetEfisBaroInhg(math.floor(baro_inhg * 100 + 0.5))
	minifcu:SetEfisBaro(math.floor(baro_inhg * 33.864 + 0.5))
	-- 26 条自定义设备通道（同上）
end)
