-- *****************************************************************
-- MobiFlight MiniFCU for Toliss A319/A32X
-- *****************************************************************

if ilua_require_toliss() then return end

-- Do not remove below lines: hardware detection
local minifcu = com.sim.mf.MiniFCU.Open()
if not minifcu then return end
-- Do not remove above lines: hardware detection

uluaLog('MobiFlight MiniFCU for Toliss')

-- ===================== DataRefs =====================

-- FCU LCD source datarefs (read directly in FrameLoop for conditional logic)
local dr_is_mach    = iDataRef:New("sim/cockpit/autopilot/airspeed_is_mach")
local dr_ias        = iDataRef:New("sim/cockpit/autopilot/airspeed")
local dr_spd_dashed = iDataRef:New("AirbusFBW/SPDdashed")
local dr_hdg        = iDataRef:New("sim/cockpit/autopilot/heading_mag")
local dr_hdg_dashed = iDataRef:New("AirbusFBW/HDGdashed")
local dr_alt        = iDataRef:New("sim/cockpit/autopilot/altitude")
local dr_vs         = iDataRef:New("sim/cockpit/autopilot/vertical_velocity")
local dr_hdgtrk     = iDataRef:New("AirbusFBW/HDGTRKmode")

-- EXPED LED needs raw APVerticalMode for == 113 comparison
local dr_vmode      = iDataRef:New("AirbusFBW/APVerticalMode")

-- EFIS source datarefs (read directly for baro math)
local dr_baro       = iDataRef:New("sim/cockpit/misc/barometer_setting")
local dr_baro_unit  = iDataRef:New("AirbusFBW/BaroUnitCapt")
local dr_baro_std   = iDataRef:New("AirbusFBW/BaroStdCapt")

-- Cold and dark : FCU power (same source as xp/QFCU_Toliss.lua) — 0 = FCU unpowered
local dr_fcu_avail  = iDataRef:New("AirbusFBW/FCUAvail")
-- ANN LT test mode, same source as xp/QFCU_Toliss.lua: 0 = DIM, 1 = BRT, 2 = TEST
local dr_annun_mode = iDataRef:New("AirbusFBW/AnnunMode")

-- ===================== Baro encoder helper =====================
local baro_cmd_down = uluaFind("sim/instruments/barometer_down")
local baro_cmd_up   = uluaFind("sim/instruments/barometer_up")
local function minifcu_baro_enc_left()
	if dr_baro_unit:Get() == 1 then
		-- inHg mode
		uluaCmdOnce(baro_cmd_down)
	else
		-- hPa mode
		local hpa = dr_baro:Get()
		dr_baro:Set(hpa - 1)
	end
end

local function minifcu_baro_enc_right()
	if dr_baro_unit:Get() == 1 then
		uluaCmdOnce(baro_cmd_up)
	else
		local hpa = dr_baro:Get()
		dr_baro:Set(hpa + 1)
	end
end

-- ===================== INPUT: FCU Buttons (bit 0–17) =====================

-- SPD/MACH toggle
minifcu:CfgCmd(0, "toliss_airbus/ias_mach_button_push")
-- HDG/TRK toggle
minifcu:CfgCmd(1, "toliss_airbus/hdgtrk_button_push")
-- AP1
minifcu:CfgCmd(2, "toliss_airbus/ap1_push")
-- AP2
minifcu:CfgCmd(3, "toliss_airbus/ap2_push")
-- METRIC ALT
minifcu:CfgCmd(4, "toliss_airbus/metric_alt_button_push")
-- ATHR
minifcu:CfgCmd(5, "AirbusFBW/ATHRbutton")
-- EXPED
minifcu:CfgCmd(6, "AirbusFBW/EXPEDbutton")
-- LOC
minifcu:CfgCmd(7, "AirbusFBW/LOCbutton")
-- APPR
minifcu:CfgCmd(8, "AirbusFBW/APPRbutton")
-- SPD PUSH
minifcu:CfgCmd(9, "AirbusFBW/PushSPDSel")
-- SPD PULL
minifcu:CfgCmd(10, "AirbusFBW/PullSPDSel")
-- HDG PUSH
minifcu:CfgCmd(11, "AirbusFBW/PushHDGSel")
-- HDG PULL
minifcu:CfgCmd(12, "AirbusFBW/PullHDGSel")
-- ALT PUSH
minifcu:CfgCmd(13, "AirbusFBW/PushAltitude")
-- ALT PULL
minifcu:CfgCmd(14, "AirbusFBW/PullAltitude")
-- VS PUSH
minifcu:CfgCmd(15, "AirbusFBW/PushVSSel")
-- VS PULL
minifcu:CfgCmd(16, "AirbusFBW/PullVSSel")
-- ALT 100/1000 toggle
minifcu:CfgVal(17, "AirbusFBW/ALT100_1000", 1, 0)

-- ===================== INPUT: EFIS Buttons (bit 18–46) =====================

-- EFIS display push buttons
minifcu:CfgCmd(18, "toliss_airbus/dispcommands/CaptCstrPushButton")
minifcu:CfgCmd(19, "toliss_airbus/dispcommands/CaptWptPushButton")
minifcu:CfgCmd(20, "toliss_airbus/dispcommands/CaptVorDPushButton")
minifcu:CfgCmd(21, "toliss_airbus/dispcommands/CaptNdbPushButton")
minifcu:CfgCmd(22, "toliss_airbus/dispcommands/CaptArptPushButton")
minifcu:CfgCmd(23, "toliss_airbus/fd1_push")
minifcu:CfgCmd(24, "toliss_airbus/dispcommands/CaptLSButtonPush")
minifcu:CfgCmd(25, "AirbusFBW/CaptChronoButton")

-- ND mode selector (direct value set)
minifcu:CfgVal(26, "AirbusFBW/NDmodeCapt", 0)
minifcu:CfgVal(27, "AirbusFBW/NDmodeCapt", 1)
minifcu:CfgVal(28, "AirbusFBW/NDmodeCapt", 2)
minifcu:CfgVal(29, "AirbusFBW/NDmodeCapt", 3)
minifcu:CfgVal(30, "AirbusFBW/NDmodeCapt", 4)
minifcu:CfgVal(67, "AirbusFBW/NDmodeCapt", 5)

-- ND range selector
minifcu:CfgVal(31, "AirbusFBW/NDrangeCapt", 0)
minifcu:CfgVal(32, "AirbusFBW/NDrangeCapt", 1)
minifcu:CfgVal(33, "AirbusFBW/NDrangeCapt", 2)
minifcu:CfgVal(34, "AirbusFBW/NDrangeCapt", 3)
minifcu:CfgVal(35, "AirbusFBW/NDrangeCapt", 4)
minifcu:CfgVal(36, "AirbusFBW/NDrangeCapt", 5)

-- VOR/ADF selectors (1 and 2)
minifcu:CfgVal(37, "ckpt/fcu/adf1Left/anim", 0)
minifcu:CfgVal(38, "ckpt/fcu/adf1Left/anim", 1)
minifcu:CfgVal(39, "ckpt/fcu/adf1Left/anim", 2)
minifcu:CfgVal(40, "ckpt/fcu/adf2Left/anim", 0)
minifcu:CfgVal(41, "ckpt/fcu/adf2Left/anim", 1)
minifcu:CfgVal(42, "ckpt/fcu/adf2Left/anim", 2)

-- Baro unit select
minifcu:CfgVal(43, "AirbusFBW/BaroUnitCapt", 1) -- hPa
minifcu:CfgVal(44, "AirbusFBW/BaroUnitCapt", 0) -- inHg
-- Baro knob
minifcu:CfgCmd(45, "toliss_airbus/capt_baro_pull")
minifcu:CfgCmd(46, "toliss_airbus/capt_baro_push")

-- ===================== INPUT: Encoders (bit 47–66) =====================

-- ALT encoder
minifcu:CfgCmd(47, "sim/autopilot/altitude_down")
minifcu:CfgCmd(49, "sim/autopilot/altitude_up")
minifcu:CfgCmd(48, "sim/autopilot/altitude_down")
minifcu:CfgCmd(50, "sim/autopilot/altitude_up")
-- SPD encoder
minifcu:CfgCmd(51, "sim/autopilot/airspeed_down")
minifcu:CfgCmd(53, "sim/autopilot/airspeed_up")
minifcu:CfgCmd(52, "sim/autopilot/airspeed_down")
minifcu:CfgCmd(54, "sim/autopilot/airspeed_up")
-- HDG encoder
minifcu:CfgCmd(55, "sim/autopilot/heading_down")
minifcu:CfgCmd(57, "sim/autopilot/heading_up")
minifcu:CfgCmd(56, "sim/autopilot/heading_down")
minifcu:CfgCmd(58, "sim/autopilot/heading_up")
-- VS encoder
minifcu:CfgCmd(59, "sim/autopilot/vertical_speed_down")
minifcu:CfgCmd(61, "sim/autopilot/vertical_speed_up")
minifcu:CfgCmd(60, "sim/autopilot/vertical_speed_down")
minifcu:CfgCmd(62, "sim/autopilot/vertical_speed_up")
-- BARO encoder (hPa/inHg aware)
-- minifcu:CfgFc(63, "minifcu_baro_enc_left()")
-- minifcu:CfgFc(65, "minifcu_baro_enc_right()")
-- minifcu:CfgCmd(63, "sim/instruments/barometer_down")
-- minifcu:CfgCmd(65, "sim/instruments/barometer_up")
minifcu:CfgEncFull(63, 65, "cpuwolf/flyluaio/MiniFCU/condbtn[0]", 1, 1, 0, -39500, 39500)
minifcu:CfgEncFull(64, 66, "cpuwolf/flyluaio/MiniFCU/condbtn[0]", 1, 1, 0, -39500, 39500)
-- ===================== OUTPUT: LEDs =====================

minifcu:GetAp1('AirbusFBW/AP1Engage')
minifcu:GetAp2('AirbusFBW/AP2Engage')
minifcu:GetAthr('AirbusFBW/ATHRmode')
minifcu:GetLoc('AirbusFBW/LOCilluminated')
minifcu:GetAppr('AirbusFBW/APPRilluminated')

-- ============ OUTPUT: FCU LCD (miniFCU LCD custom device, kSetCustomDevice 32) ============

-- MT 2 (miniFCU LCD): SPD/MACH mode (1=mach, 0=ias)
minifcu:GetFcuSpdMachMode('sim/cockpit/autopilot/airspeed_is_mach')
-- MT 1 (miniFCU LCD): MACH value (ias * 100, shown when mach mode)
minifcu:GetFcuMachValue('sim/cockpit/autopilot/airspeed', 100)
-- MT 3 (miniFCU LCD): SPD dashes
minifcu:GetFcuSpdDashes('AirbusFBW/SPDdashed')
-- MT 0 (miniFCU LCD): SPD value (kts, shown when not mach & not dashed)
minifcu:GetFcuSpdValue('sim/cockpit/autopilot/airspeed')
-- MT 4 (miniFCU LCD): SPD dot (managed)
minifcu:GetFcuSpdDot('AirbusFBW/SPDmanaged')
-- MT 6 (miniFCU LCD): HDG dashes
minifcu:GetFcuHdgDashes('AirbusFBW/HDGdashed')
-- MT 5 (miniFCU LCD): HDG value (360→0)
minifcu:GetFcuHdgValue('sim/cockpit/autopilot/heading_mag')
-- MT 7 (miniFCU LCD): HDG dot (managed)
minifcu:GetFcuHdgDot('AirbusFBW/HDGmanaged')
-- MT 8 (miniFCU LCD): ALT value (ft / 100)
minifcu:GetFcuAltValue('sim/cockpit/autopilot/altitude')
-- MT 9 (miniFCU LCD): ALT dot (managed)
minifcu:GetFcuAltDot('AirbusFBW/ALTmanaged')
-- MT 12 (miniFCU LCD): VS dashes
minifcu:GetFcuVsDashes('AirbusFBW/VSdashed')
-- MT 10 (miniFCU LCD): VS value (shown when VS mode)
minifcu:GetFcuVsValue('sim/cockpit/autopilot/vertical_velocity')
-- MT 11 (miniFCU LCD): FPA value (shown when FPA mode) - channel unit is FPA * 1000,
--   the registered source is already in the unit the channel wants -> scale 1
minifcu:GetFcuFpaValue('sim/cockpit/autopilot/vertical_velocity', 1)
-- MT 13 (miniFCU LCD): HDG/TRK mode label
minifcu:GetFcuHdgTrkMode('AirbusFBW/HDGTRKmode')

-- ======= OUTPUT: EFIS LED and LCD (miniEFIS LED and LCD custom device, 32) =======
minifcu:GetExped("AirbusFBW/APVerticalMode", false, 110)
-- MT 9 (miniEFIS LED and LCD): baro unit (inverted: BaroUnitCapt 1=hPa → show 0)
minifcu:GetEfisBaroInhgHpaUnit('AirbusFBW/BaroUnitCapt')
-- MT 8 (miniEFIS LED and LCD): baro STD flag
minifcu:GetEfisBaroStd1('AirbusFBW/BaroStdCapt')
-- MT 7 (miniEFIS LED and LCD): QNH label (constant 1 when baro not STD)
minifcu:GetEfisBaroQnnh1('AirbusFBW/BaroStdCapt')
-- MT 11 (miniEFIS LED and LCD): baro hPa value (inHg * 33.864, rounded)
minifcu:GetEfisBaro('sim/cockpit/misc/barometer_setting')
-- MT 10 (miniEFIS LED and LCD): baro inHg value (inHg * 100, rounded)
minifcu:GetEfisBaroInhg('sim/cockpit/misc/barometer_setting')
-- MT 0,1,2,3,4 (miniEFIS LED and LCD): EFIS display flags
minifcu:GetEfisCstr('AirbusFBW/NDShowCSTRCapt')
minifcu:GetEfisWpt('AirbusFBW/NDShowWPTCapt')
minifcu:GetEfisVord('AirbusFBW/NDShowVORDCapt')
minifcu:GetEfisNdb('AirbusFBW/NDShowNDBCapt')
minifcu:GetEfisArpt('AirbusFBW/NDShowARPTCapt')
-- MT 5,6 (miniEFIS LED and LCD): FD / LS
minifcu:GetFcuFdValue('AirbusFBW/FD1Engage')
minifcu:GetFcuLsValue('AirbusFBW/ILSonCapt')

-- ===================== Frame Loop =====================

-- Cold and dark: FCUAvail == 0 → blank both custom devices
--   (kSetCustomDevice 32,<device index>,-1,0; = Connector MESSAGE_STOP).
-- Source 0 means "off", so revert = true; Set*() without a value only writes on change.
minifcu:GetFcuPower('AirbusFBW/FCUAvail', true)
minifcu:GetEfisPower('AirbusFBW/FCUAvail', true)

-- Every output channel: Fresh*() drops the Lua-side change cache, so the first frame
-- after power-up writes all of them again even when the value never changed (the
-- plugin also re-sends the whole custom device after MESSAGE_STOP).
local minifcu_fresh_all = {
	'FreshAp1', 'FreshAp2', 'FreshAthr', 'FreshLoc', 'FreshAppr', 'FreshExped',
	'FreshFcuSpdValue', 'FreshFcuMachValue', 'FreshFcuSpdMachMode', 'FreshFcuSpdDashes',
	'FreshFcuSpdDot', 'FreshFcuHdgValue', 'FreshFcuHdgDashes', 'FreshFcuHdgDot',
	'FreshFcuAltValue', 'FreshFcuAltDot', 'FreshFcuVsValue', 'FreshFcuFpaValue',
	'FreshFcuVsDashes', 'FreshFcuHdgTrkMode',
	'FreshEfisCstr', 'FreshEfisWpt', 'FreshEfisVord', 'FreshEfisNdb', 'FreshEfisArpt',
	'FreshFcuFdValue', 'FreshFcuLsValue', 'FreshEfisBaroQnnh1', 'FreshEfisBaroStd1',
	'FreshEfisBaroInhgHpaUnit', 'FreshEfisBaroInhg', 'FreshEfisBaro',
}

-- ANN LT TEST 图案（真机是段码自检：所有灯 + 所有数字段全亮）。
-- FCU/EFIS 两个 custom device 的通道分布见 mobiflight/MiniFCU.json：
--   0–13 FCU 显示、14 ANN LT；EFIS 0–6 是 CSTR/WPT/VORD/NDB/ARPT/FD/LS 七个按键灯。
-- 硬限制：MT8（ALT）是 ft/100 的整数通道，888 → 屏上 88800，写不出 88888。
local function minifcu_test_pattern()
	-- 六个指示范灯（GPIO output pin：0=LOW, 255=HIGH）
	minifcu:SetAp1(255)
	minifcu:SetAp2(255)
	minifcu:SetAthr(255)
	minifcu:SetLoc(255)
	minifcu:SetAppr(255)
	minifcu:SetExped(255)

	-- EFIS 按键灯（miniEFIS custom device，1=ON）
	minifcu:SetEfisCstr(1)
	minifcu:SetEfisWpt(1)
	minifcu:SetEfisVord(1)
	minifcu:SetEfisNdb(1)
	minifcu:SetEfisArpt(1)
	minifcu:SetFcuFdValue(1)
	minifcu:SetFcuLsValue(1)

	-- FCU 数字：SPD/MACH 与 VS/FPA 各自只能显示一个，测试取 SPD + VS
	minifcu:SetFcuSpdMachMode(0)
	minifcu:SetFcuSpdValue(888)
	minifcu:SetFcuSpdDashes(0)
	minifcu:SetFcuSpdDot(1)
	minifcu:SetFcuHdgValue(888)
	minifcu:SetFcuHdgDashes(0)
	minifcu:SetFcuHdgDot(1)
	minifcu:SetFcuAltValue(888)
	minifcu:SetFcuAltDot(1)
	minifcu:SetFcuVsValue(8800)
	minifcu:SetFcuFpaValue(0)
	minifcu:SetFcuVsDashes(0)
	minifcu:SetFcuHdgTrkMode(0)

	-- EFIS 气压：QNH 标签亮、STD 关（STD 亮会把 baro 数字换成 "STD"），hPa 模式
	minifcu:SetEfisBaroInhgHpaUnit(0)
	minifcu:SetEfisBaroStd1(0)
	minifcu:SetEfisBaroQnnh1(1)
	minifcu:SetEfisBaro(8888)
	minifcu:SetEfisBaroInhg(8888)
end

local ch_fcu_powered = iChange:New(nil)
local ch_annun_test = iChange:New(nil)

GlobalFrameLoopManager:add(function()
	-- expert code: cold and dark + ANN LT test mode
	minifcu:SetFcuPower()
	minifcu:SetEfisPower()

	local powered = dr_fcu_avail:Get() >= 1
	local annun_test = powered and dr_annun_mode:Get() == 2

	if ch_fcu_powered:ChangedUpdate(powered) then
		if not powered then
			-- The six LEDs are GPIO pins, not part of a custom device: kSetCustomDevice
			-- only blanks the LCDs, so switch them off here.
			minifcu:SetAp1(0)
			minifcu:SetAp2(0)
			minifcu:SetAthr(0)
			minifcu:SetLoc(0)
			minifcu:SetAppr(0)
			minifcu:SetExped(0)
		end
		for _, fresh in ipairs(minifcu_fresh_all) do
			minifcu[fresh](minifcu)
		end
	end

	-- Test mode: QFCU 靠面板旋钮让硬件把段码/灯全点亮，Lua 只做亮度与重绘
	-- (qfcu_fcu_test + 1)。miniFCU 没有亮度通道，段码自检只能用 pattern 逼近；
	-- 退出 TEST 时作废缓存，下一帧重写真实值。
	if ch_annun_test:ChangedUpdate(annun_test) then
		if annun_test then
			minifcu_test_pattern()
		end
		for _, fresh in ipairs(minifcu_fresh_all) do
			minifcu[fresh](minifcu)
		end
	end

	if not powered then
		-- Display is blanked; forwarding values now would light it back up.
		-- On power-up the plugin re-sends every field of both devices by itself.
		return
	end
	if annun_test then
		-- LEDs are held lit by the writes above, LCD keeps its last values.
		return
	end

	local baro_unit = dr_baro_unit:Get()
	local baro = dr_baro:Get()
	-- Fix Captain Baro
	if idr_minifcu_hid_condbtn_0:ChangedUpdate() then
		local smallstep = idr_minifcu_hid_condbtn_0:Delta()
		-- uluaLog(string.format("toliss baro step=%d", smallstep))
		if baro_unit == 1 then
			local inHg = baro * 33.8638895 + smallstep
			-- update hPa
			dr_baro:Set(inHg / 33.8638895)
		else
			local inHg = baro + smallstep * 0.01
			-- update inHg
			dr_baro:Set(inHg)
		end
	end

	-- Output LEDs
	minifcu:SetAp1()
	minifcu:SetAp2()
	minifcu:SetAthr()
	minifcu:SetLoc()
	minifcu:SetAppr()

	-- EXPED LED
	minifcu:SetExped()

	-- FCU LCD (miniFCU LCD custom device)
	local is_mach = dr_is_mach:Get()
	local spd_dash = dr_spd_dashed:Get()
	local ias = dr_ias:Get()

	-- MT 2 (miniFCU LCD): SPD/MACH mode
	minifcu:SetFcuSpdMachMode()

	-- MT 1 (miniFCU LCD): MACH value (ias * 100, only in mach mode)
	if is_mach >= 1 and spd_dash < 1 then
		minifcu:SetFcuMachValue(ias * 100 + 0.5)
	else
		minifcu:SetFcuMachValue(0)
	end

	-- MT 3 (miniFCU LCD): SPD dashes
	minifcu:SetFcuSpdDashes()

	-- MT 0 (miniFCU LCD): SPD value (only when not mach & not dashed)
	if is_mach < 1 and spd_dash < 1 then
		minifcu:SetFcuSpdValue()
	else
		minifcu:SetFcuSpdValue(0)
	end

	-- MT 4 (miniFCU LCD): SPD dot (managed)
	minifcu:SetFcuSpdDot()

	-- HDG
	minifcu:SetFcuHdgDashes()

	-- MT 5 (miniFCU LCD): HDG value (only when not dashed)
	minifcu:SetFcuHdgValue()


	-- MT 7 (miniFCU LCD): HDG dot
	minifcu:SetFcuHdgDot()

	-- MT 8 (miniFCU LCD): ALT value (ft / 100)
	minifcu:SetFcuAltValue(dr_alt:Get() / 100)

	-- MT 9 (miniFCU LCD): ALT dot
	minifcu:SetFcuAltDot()

	-- VS / FPA mode
	local is_fpa = (dr_hdgtrk:Get() >= 1)
	local vs = dr_vs:Get()

	-- MT 12 (miniFCU LCD): VS dashes
	minifcu:SetFcuVsDashes()

	if is_fpa then
		-- MT 10 (miniFCU LCD): VS value hidden
		minifcu:SetFcuVsValue(0)
		-- MT 11 (miniFCU LCD): FPA value shown
		minifcu:SetFcuFpaValue()
	else
		-- MT 10 (miniFCU LCD): VS value shown
		minifcu:SetFcuVsValue(vs)
		-- MT 11 (miniFCU LCD): FPA value hidden
		minifcu:SetFcuFpaValue(0)
	end

	-- MT 13 (miniFCU LCD): HDG/TRK mode
	minifcu:SetFcuHdgTrkMode()

	-- EFIS LED and LCD (miniEFIS LED and LCD custom device)


	-- MT 9 (miniEFIS LED and LCD): baro unit (inverted: hPa=1 → display 0)
	minifcu:SetEfisBaroInhgHpaUnit(baro_unit == 1 and 0 or 1)

	-- MT 8 (miniEFIS LED and LCD): baro STD
	minifcu:SetEfisBaroStd1()

	-- MT 7 (miniEFIS LED and LCD): QNH label (1 when not STD)
	local baro_std = dr_baro_std:Get()
	minifcu:SetEfisBaroQnnh1(baro_std == 0 and 1 or 0)

	-- MT 11 (miniEFIS LED and LCD): baro hPa (only in hPa mode)
	if baro_unit ~= 0 then
		minifcu:SetEfisBaro(math.floor(baro * 33.864 + 0.5))
	else
		minifcu:SetEfisBaroInhg(math.floor(baro * 100 + 0.5))
	end

	-- MT 0,1,2,3,4 (miniEFIS LED and LCD): EFIS flags
	minifcu:SetEfisCstr()
	minifcu:SetEfisWpt()
	minifcu:SetEfisVord()
	minifcu:SetEfisNdb()
	minifcu:SetEfisArpt()

	-- MT 5,6 (miniEFIS LED and LCD): FD / LS
	minifcu:SetFcuFdValue()
	minifcu:SetFcuLsValue()
end)
