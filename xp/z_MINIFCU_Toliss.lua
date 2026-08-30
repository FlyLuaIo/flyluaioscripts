-- *****************************************************************
-- MobiFlight MiniFCU for Toliss A319/A32X
-- source: mfproj/XP_miniFCU_miniEFIS_Toliss_A319_A32X_pilote_v1.mfproj
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
local dr_vmode   = iDataRef:New("AirbusFBW/APVerticalMode")

-- EFIS source datarefs (read directly for baro math)
local dr_baro      = iDataRef:New("sim/cockpit/misc/barometer_setting")
local dr_baro_unit = iDataRef:New("AirbusFBW/BaroUnitCapt")
local dr_baro_std  = iDataRef:New("AirbusFBW/BaroStdCapt")

-- ===================== Baro encoder helper =====================

local function minifcu_baro_enc_left()
	if dr_baro_unit:Get() == 1 then
		-- inHg mode
		uluaCmdOnce(uluaFind("sim/instruments/barometer_down"))
	else
		-- hPa mode
		local hpa = dr_baro:Get()
		dr_baro:Set(hpa - 1)
	end
end

local function minifcu_baro_enc_right()
	if dr_baro_unit:Get() == 1 then
		uluaCmdOnce(uluaFind("sim/instruments/barometer_up"))
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
minifcu:CfgValT(17, "AirbusFBW/ALT100_1000")

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
minifcu:CfgVal(43, "AirbusFBW/BaroUnitCapt", 1)  -- hPa
minifcu:CfgVal(44, "AirbusFBW/BaroUnitCapt", 0)  -- inHg
-- Baro knob
minifcu:CfgCmd(45, "toliss_airbus/capt_baro_pull")
minifcu:CfgCmd(46, "toliss_airbus/capt_baro_push")

-- ===================== INPUT: Encoders (bit 47–66) =====================

-- ALT encoder
minifcu:CfgCmd(47, "sim/autopilot/altitude_down")
minifcu:CfgCmd(49, "sim/autopilot/altitude_up")
-- SPD encoder
minifcu:CfgCmd(51, "sim/autopilot/airspeed_down")
minifcu:CfgCmd(53, "sim/autopilot/airspeed_up")
-- HDG encoder
minifcu:CfgCmd(55, "sim/autopilot/heading_down")
minifcu:CfgCmd(57, "sim/autopilot/heading_up")
-- VS encoder
minifcu:CfgCmd(59, "sim/autopilot/vertical_speed_down")
minifcu:CfgCmd(61, "sim/autopilot/vertical_speed_up")
-- BARO encoder (hPa/inHg aware)
minifcu:CfgFc(63, "minifcu_baro_enc_left()")
minifcu:CfgFc(65, "minifcu_baro_enc_right()")

-- ===================== OUTPUT: LEDs =====================

minifcu:GetAp1('AirbusFBW/AP1Engage')
minifcu:GetAp2('AirbusFBW/AP2Engage')
minifcu:GetAthr('AirbusFBW/ATHRmode')
minifcu:GetLoc('AirbusFBW/LOCilluminated')
minifcu:GetAppr('AirbusFBW/APPRilluminated')

-- ===================== OUTPUT: FCU LCD segments =====================

-- segment 0: SPD/MACH mode (1=mach, 0=ias)
minifcu:GetSpdMode('sim/cockpit/autopilot/airspeed_is_mach')
-- segment 1: MACH value (ias * 100, shown when mach mode)
minifcu:GetMachVal('sim/cockpit/autopilot/airspeed')
-- segment 2: SPD dashes
minifcu:GetSpdDashes('AirbusFBW/SPDdashed')
-- segment 3: SPD value (kts, shown when not mach & not dashed)
minifcu:GetSpdVal('sim/cockpit/autopilot/airspeed')
-- segment 4: SPD dot (managed)
minifcu:GetSpdDot('AirbusFBW/SPDmanaged')
-- segment 5: HDG dashes
minifcu:GetHdgDashes('AirbusFBW/HDGdashed')
-- segment 6: HDG value (360→0)
minifcu:GetHdgVal('sim/cockpit/autopilot/heading_mag')
-- segment 7: HDG dot (managed)
minifcu:GetHdgDot('AirbusFBW/HDGmanaged')
-- segment 8: ALT value (ft / 100)
minifcu:GetAltVal('sim/cockpit/autopilot/altitude')
-- segment 9: ALT dot (managed)
minifcu:GetAltDot('AirbusFBW/ALTmanaged')
-- segment 10: VS dashes
minifcu:GetVsDashes('AirbusFBW/VSdashed')
-- segment 11: VS value (shown when VS mode)
minifcu:GetVsVal('sim/cockpit/autopilot/vertical_velocity')
-- segment 12: FPA value (shown when FPA mode)
minifcu:GetFpaVal('sim/cockpit/autopilot/vertical_velocity')
-- segment 13: HDG/TRK mode label
minifcu:GetHdgtrkMode('AirbusFBW/HDGTRKmode')

-- ===================== OUTPUT: EFIS LCD segments =====================

-- segment 14: baro unit (inverted: BaroUnitCapt 1=hPa → show 0)
minifcu:GetBaroUnit('AirbusFBW/BaroUnitCapt')
-- segment 15: baro STD flag
minifcu:GetBaroStd('AirbusFBW/BaroStdCapt')
-- segment 16: QNH label (constant 1 when baro not STD)
minifcu:GetQnh('AirbusFBW/BaroStdCapt')
-- segment 17: baro hPa value (inHg * 33.864, rounded)
minifcu:GetBaroHpa('sim/cockpit/misc/barometer_setting')
-- segment 18: baro inHg value (inHg * 100, rounded)
minifcu:GetBaroInhg('sim/cockpit/misc/barometer_setting')
-- segment 19–23: EFIS display flags
minifcu:GetCstr('AirbusFBW/NDShowCSTRCapt')
minifcu:GetWpt('AirbusFBW/NDShowWPTCapt')
minifcu:GetVord('AirbusFBW/NDShowVORDCapt')
minifcu:GetNdb('AirbusFBW/NDShowNDBCapt')
minifcu:GetArpt('AirbusFBW/NDShowARPTCapt')
-- segment 24–25: FD / LS
minifcu:GetFd('AirbusFBW/FD1Engage')
minifcu:GetLs('AirbusFBW/ILSonCapt')

-- ===================== Frame Loop =====================

GlobalFrameLoopManager:add(function()
	-- Output LEDs
	minifcu:SetAp1()
	minifcu:SetAp2()
	minifcu:SetAthr()
	minifcu:SetLoc()
	minifcu:SetAppr()

	-- EXPED LED: APVerticalMode == 113
	local exped_on = (dr_vmode:Get() == 113) and 1 or 0
	minifcu:SetExped(exped_on)

	-- FCU LCD segments
	local is_mach = dr_is_mach:Get()
	local spd_dash = dr_spd_dashed:Get()
	local ias = dr_ias:Get()

	-- segment 0: SPD/MACH mode
	minifcu:SetSpdMode(is_mach)

	-- segment 1: MACH value (ias * 100, only in mach mode)
	if is_mach >= 1 and spd_dash < 1 then
		minifcu:SetMachVal(ias * 100)
	else
		minifcu:SetMachVal(0)
	end

	-- segment 2: SPD dashes
	minifcu:SetSpdDashes()

	-- segment 3: SPD value (only when not mach & not dashed)
	if is_mach < 1 and spd_dash < 1 then
		minifcu:SetSpdVal()
	else
		minifcu:SetSpdVal(0)
	end

	-- segment 4: SPD dot (managed)
	minifcu:SetSpdDot()

	-- HDG
	local hdg_dash = dr_hdg_dashed:Get()
	local hdg_val = dr_hdg:Get()
	if hdg_val == 360 then hdg_val = 0 end

	-- segment 5: HDG dashes
	minifcu:SetHdgDashes()

	-- segment 6: HDG value (only when not dashed)
	if hdg_dash < 1 then
		minifcu:SetHdgVal(hdg_val)
	else
		minifcu:SetHdgVal(0)
	end

	-- segment 7: HDG dot
	minifcu:SetHdgDot()

	-- segment 8: ALT value (ft / 100)
	minifcu:SetAltVal(dr_alt:Get() / 100)

	-- segment 9: ALT dot
	minifcu:SetAltDot()

	-- VS / FPA mode
	local is_fpa = (dr_hdgtrk:Get() >= 1)
	local vs = dr_vs:Get()

	-- segment 10: VS dashes
	minifcu:SetVsDashes()

	if is_fpa then
		-- segment 11: VS value hidden
		minifcu:SetVsVal(0)
		-- segment 12: FPA value shown
		minifcu:SetFpaVal(vs)
	else
		-- segment 11: VS value shown
		minifcu:SetVsVal(vs)
		-- segment 12: FPA value hidden
		minifcu:SetFpaVal(0)
	end

	-- segment 13: HDG/TRK mode
	minifcu:SetHdgtrkMode()

	-- EFIS LCD segments
	local baro_unit = dr_baro_unit:Get()
	local baro = dr_baro:Get()

	-- segment 14: baro unit (inverted: hPa=1 → display 0)
	minifcu:SetBaroUnit(baro_unit == 1 and 0 or 1)

	-- segment 15: baro STD
	minifcu:SetBaroStd()

	-- segment 16: QNH label (1 when not STD)
	local baro_std = dr_baro_std:Get()
	minifcu:SetQnh(baro_std == 0 and 1 or 0)

	-- segment 17: baro hPa (only in hPa mode)
	if baro_unit == 0 then
		minifcu:SetBaroHpa(math.floor(baro * 33.864 + 0.5))
	else
		minifcu:SetBaroHpa(0)
	end

	-- segment 18: baro inHg (only in inHg mode)
	if baro_unit == 1 then
		minifcu:SetBaroInhg(math.floor(baro * 100 + 0.5))
	else
		minifcu:SetBaroInhg(0)
	end

	-- segment 19–23: EFIS flags
	minifcu:SetCstr()
	minifcu:SetWpt()
	minifcu:SetVord()
	minifcu:SetNdb()
	minifcu:SetArpt()

	-- segment 24–25: FD / LS
	minifcu:SetFd()
	minifcu:SetLs()
end)
