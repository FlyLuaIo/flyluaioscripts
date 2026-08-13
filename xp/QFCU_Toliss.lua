-- **********************************************************************************************************--
-- QFCU Driver for Toliss
-- Author: QuickMade
-- Email:  409050332@qq.com
-- Website: https://space.bilibili.com/323386663/
-- Build:  2021-02-10  test with Toliss A321,A319,A346 Xplane 11.53
-- **********************************************************************************************************--
-- modified by Wei Shuai <cpuwolf@gmail.com> 2021-04-25
-- 2021-12-30 tested on Toliss A319 v1.6.3
-- ######################  Edit part  #####################
-- 此处调整加速点, 值越小,越容易进入加速模式,可根据自己的手感调节
local FastTurnsPerSecond = 40 -- How many spins per second  is considered FAST?
--
local MaxBrightness = 100     -- Max brightness set   /背光的最大亮度设定,调小些够用就好,环保省电不刺眼.

-- ###############################################################################################

if ilua_require_toliss() then return end

-- Do not remove below lines: hardware detection
local qfcu = com.sim.qm.Qfcu.Open()
if not qfcu then return end
-- Do not remove above lines: hardware detection

uluaLog("QFCU for Toliss")
qfcu:CfgInit(FastTurnsPerSecond, MaxBrightness)

-- ===========================================================
-- button binding
qfcu:CfgEncFull(16, 17, "cpuwolf/flyluaio/QFCU/condbtn[16]", 100, 100, 0, -39500, 39500)
qfcu:CfgEncFull(46, 47, "cpuwolf/flyluaio/QFCU/condbtn[46]", 1, 10, 0, -39500, 39500)
qfcu:CfgEncFull(78, 79, "cpuwolf/flyluaio/QFCU/condbtn[78]", 1, 10, 0, -39500, 39500)

qfcu:CfgCmd(0, "sim/GPS/g430n2_msg", "sim/autopilot/airspeed_down")
qfcu:CfgCmd(1, "sim/GPS/g430n2_msg", "sim/autopilot/airspeed_up")
qfcu:CfgCmd(2, "sim/GPS/g430n2_msg", "AirbusFBW/PushSPDSel")
qfcu:CfgCmd(3, "sim/GPS/g430n2_msg", "AirbusFBW/PullSPDSel")
qfcu:CfgCmd(4, "sim/GPS/g430n2_msg", "sim/autopilot/heading_down")
qfcu:CfgCmd(5, "sim/GPS/g430n2_msg", "sim/autopilot/heading_up")
qfcu:CfgCmd(6, "sim/GPS/g430n2_msg", "AirbusFBW/PushHDGSel")
qfcu:CfgCmd(7, "sim/GPS/g430n2_msg", "AirbusFBW/PullHDGSel")
qfcu:CfgCmd(8, "sim/GPS/g430n2_msg", "AirbusFBW/LOCbutton")
qfcu:CfgCmd(9, "sim/GPS/g430n2_msg", "toliss_airbus/ap2_push")
qfcu:CfgCmd(10, "sim/GPS/g430n2_msg", "toliss_airbus/ap1_push")
qfcu:CfgCmd(11, "sim/GPS/g430n2_msg", "AirbusFBW/ATHRbutton")
qfcu:CfgCmd(12, "sim/GPS/g430n2_msg", "AirbusFBW/EXPEDbutton")
qfcu:CfgCmd(13, "sim/GPS/g430n2_msg", "AirbusFBW/APPRbutton")
qfcu:CfgCmd(14, "sim/GPS/g430n2_msg", "toliss_airbus/dispcommands/MetricAltitudeSwitch")
qfcu:CfgVal(15, "AirbusFBW/ALT100_1000", 0, 1)
qfcu:CfgCmd(18, "sim/GPS/g430n2_msg", "AirbusFBW/PushAltitude")
qfcu:CfgCmd(19, "sim/GPS/g430n2_msg", "AirbusFBW/PullAltitude")
qfcu:CfgCmd(20, "sim/GPS/g430n2_msg", "sim/autopilot/vertical_speed_down")
qfcu:CfgCmd(21, "sim/GPS/g430n2_msg", "sim/autopilot/vertical_speed_up")
qfcu:CfgCmd(22, "sim/GPS/g430n2_msg", "AirbusFBW/PushVSSel")
qfcu:CfgCmd(23, "sim/GPS/g430n2_msg", "AirbusFBW/PullVSSel")

-- EFIS Capt
qfcu:CfgVal(24, "AirbusFBW/NDmodeCapt", 0, nil)
qfcu:CfgVal(25, "AirbusFBW/NDmodeCapt", 1, nil)
qfcu:CfgVal(26, "AirbusFBW/NDmodeCapt", 2, nil)
qfcu:CfgVal(27, "AirbusFBW/NDmodeCapt", 3, nil)
qfcu:CfgVal(28, "AirbusFBW/NDmodeCapt", 4, nil)
qfcu:CfgVal(29, "AirbusFBW/NDrangeCapt", 0, nil)
qfcu:CfgVal(30, "AirbusFBW/NDrangeCapt", 1, nil)
qfcu:CfgVal(31, "AirbusFBW/NDrangeCapt", 2, nil)
qfcu:CfgVal(32, "AirbusFBW/NDrangeCapt", 3, nil)
qfcu:CfgVal(33, "AirbusFBW/NDrangeCapt", 4, nil)
qfcu:CfgVal(34, "AirbusFBW/NDrangeCapt", 5, nil)
qfcu:CfgValT(35, "AirbusFBW/NDShowCSTRCapt")
qfcu:CfgValT(36, "AirbusFBW/NDShowWPTCapt")
qfcu:CfgValT(37, "AirbusFBW/NDShowVORDCapt")
qfcu:CfgValT(38, "AirbusFBW/NDShowNDBCapt")
qfcu:CfgValT(39, "AirbusFBW/NDShowARPTCapt")
qfcu:CfgCmd(40, "sim/GPS/g430n2_msg", "toliss_airbus/fd1_push")
qfcu:CfgCmd(41, "sim/GPS/g430n2_msg", "toliss_airbus/dispcommands/CaptLSButtonPush")
qfcu:CfgVal(42, "sim/cockpit2/EFIS/EFIS_1_selection_pilot", 0, 1)
qfcu:CfgVal(43, "sim/cockpit2/EFIS/EFIS_1_selection_pilot", 2, 1)
qfcu:CfgVal(44, "sim/cockpit2/EFIS/EFIS_2_selection_pilot", 0, 1)
qfcu:CfgVal(45, "sim/cockpit2/EFIS/EFIS_2_selection_pilot", 2, 1)
qfcu:CfgVal(48, "AirbusFBW/BaroStdCapt", 0, nil)
qfcu:CfgVal(49, "AirbusFBW/BaroStdCapt", 1, 1)
-- inHg/hPa
qfcu:CfgVal(50, "AirbusFBW/BaroUnitCapt", 0, 1)

-- EFIS FO
qfcu:CfgVal(51, "AirbusFBW/BaroStdFO", 0, nil)
qfcu:CfgVal(52, "AirbusFBW/BaroStdFO", 1, 1)
-- inHg/hPa
qfcu:CfgVal(53, "AirbusFBW/BaroUnitFO", 0, 1)
qfcu:CfgCmd(54, "sim/GPS/g430n2_msg", "toliss_airbus/dispcommands/HeadingTrackModeSwitch")
qfcu:CfgCmd(55, "sim/GPS/g430n2_msg", "sim/autopilot/knots_mach_toggle")
qfcu:CfgVal(56, "AirbusFBW/NDmodeFO", 0, nil)
qfcu:CfgVal(57, "AirbusFBW/NDmodeFO", 1, nil)
qfcu:CfgVal(58, "AirbusFBW/NDmodeFO", 2, nil)
qfcu:CfgVal(59, "AirbusFBW/NDmodeFO", 3, nil)
qfcu:CfgVal(60, "AirbusFBW/NDmodeFO", 4, nil)
qfcu:CfgVal(61, "AirbusFBW/NDrangeFO", 0, nil)
qfcu:CfgVal(62, "AirbusFBW/NDrangeFO", 1, nil)
qfcu:CfgVal(63, "AirbusFBW/NDrangeFO", 2, nil)
qfcu:CfgVal(64, "AirbusFBW/NDrangeFO", 3, nil)
qfcu:CfgVal(65, "AirbusFBW/NDrangeFO", 4, nil)
qfcu:CfgVal(66, "AirbusFBW/NDrangeFO", 5, nil)
qfcu:CfgValT(67, "AirbusFBW/NDShowCSTRFO")
qfcu:CfgValT(68, "AirbusFBW/NDShowWPTFO")
qfcu:CfgValT(69, "AirbusFBW/NDShowVORDFO")
qfcu:CfgValT(70, "AirbusFBW/NDShowNDBFO")
qfcu:CfgValT(71, "AirbusFBW/NDShowARPTFO")
qfcu:CfgCmd(72, "sim/GPS/g430n2_msg", "toliss_airbus/fd2_push")
qfcu:CfgCmd(73, "sim/GPS/g430n2_msg", "toliss_airbus/dispcommands/CoLSButtonPush")
qfcu:CfgVal(74, "sim/cockpit2/EFIS/EFIS_1_selection_copilot", 0, 1)
qfcu:CfgVal(75, "sim/cockpit2/EFIS/EFIS_1_selection_copilot", 2, 1)
qfcu:CfgVal(76, "sim/cockpit2/EFIS/EFIS_2_selection_copilot", 0, 1)
qfcu:CfgVal(77, "sim/cockpit2/EFIS/EFIS_2_selection_copilot", 2, 1)

-- ===========================================================
-- display sources registration
qfcu:GetSpd("sim/cockpit2/autopilot/airspeed_dial_kts_mach", "AirbusFBW/SPDdashed",
    "sim/cockpit2/autopilot/airspeed_is_mach", "AirbusFBW/SPDmanaged")
qfcu:GetHdg("sim/cockpit/autopilot/heading_mag", "AirbusFBW/HDGdashed", "AirbusFBW/HDGmanaged")
qfcu:GetVs("sim/cockpit/autopilot/vertical_velocity", "AirbusFBW/HDGTRKmode", "AirbusFBW/VSdashed")
qfcu:GetAlt("sim/cockpit/autopilot/altitude", "AirbusFBW/ALTmanaged")
qfcu:GetLBaro("sim/cockpit/misc/barometer_setting", "AirbusFBW/BaroUnitCapt", "AirbusFBW/BaroStdCapt")
qfcu:GetRBaro("sim/cockpit/misc/barometer_setting2", "AirbusFBW/BaroUnitFO", "AirbusFBW/BaroStdFO")

-- backlight sources (Toliss older builds miss FCUIntegralBrightness)
local bkl_light_path = "AirbusFBW/PanelBrightnessLevel"
if uluaFind("AirbusFBW/FCUIntegralBrightness") then
    bkl_light_path = "AirbusFBW/FCUIntegralBrightness"
end
qfcu:GetBkl(bkl_light_path, "AirbusFBW/SupplLightLevelRehostats[1]")
qfcu:GetBrt("AirbusFBW/AnnunMode") -- 0: DIM 1: BRT 2: test mode

-- ===========================================================
-- LED sources registration
-- FCU mid leds
qfcu:GetAp1("AirbusFBW/AP1Engage")
qfcu:GetAp2("AirbusFBW/AP2Engage")
qfcu:GetAthr("AirbusFBW/ATHRmode")
qfcu:GetLoc("AirbusFBW/LOCilluminated")
qfcu:GetAppr("AirbusFBW/APPRilluminated")
qfcu:GetExped("AirbusFBW/APVerticalMode", nil, 110)

-- EFIS Capt leds
qfcu:GetLCstr("AirbusFBW/NDShowCSTRCapt")
qfcu:GetLWpt("AirbusFBW/NDShowWPTCapt")
qfcu:GetLVord("AirbusFBW/NDShowVORDCapt")
qfcu:GetLNdb("AirbusFBW/NDShowNDBCapt")
qfcu:GetLArpt("AirbusFBW/NDShowARPTCapt")
qfcu:GetLFd("AirbusFBW/FD1Engage")
qfcu:GetLIls("AirbusFBW/ILSonCapt")

-- EFIS FO leds
qfcu:GetRCstr("AirbusFBW/NDShowCSTRFO")
qfcu:GetRWpt("AirbusFBW/NDShowWPTFO")
qfcu:GetRVord("AirbusFBW/NDShowVORDFO")
qfcu:GetRNdb("AirbusFBW/NDShowNDBFO")
qfcu:GetRArpt("AirbusFBW/NDShowARPTFO")
qfcu:GetRFd("AirbusFBW/FD2Engage")
qfcu:GetRIls("AirbusFBW/ILSonFO")

-- BaroStd -> QFE/QNH indicator leds (0: QNH, 1: both off)
local dr_barostd_c = iDataRef:New("AirbusFBW/BaroStdCapt")
local dr_barostd_f = iDataRef:New("AirbusFBW/BaroStdFO")

-- power / alt unit / encoders (Toliss specific)
local dr_power = iDataRef:New("AirbusFBW/FCUAvail")       -- 0: OFF  1: ON
local dr_alt_unit = iDataRef:New("AirbusFBW/ALT100_1000") -- 0: 100  1: 1000
local dr_alt_mgd = iDataRef:New("AirbusFBW/ALTmanaged")
local dr_alt = iDataRef:New("sim/cockpit/autopilot/altitude")
local dr_c_baro = iDataRef:New("sim/cockpit/misc/barometer_setting")
local dr_c_barounit = iDataRef:New("AirbusFBW/BaroUnitCapt")
local dr_f_baro = iDataRef:New("sim/cockpit/misc/barometer_setting2")
local dr_f_barounit = iDataRef:New("AirbusFBW/BaroUnitFO")

local dr_enc_alt = idr_qfcu_hid_condbtn_16
local dr_enc_baro_c = idr_qfcu_hid_condbtn_46
local dr_enc_baro_f = idr_qfcu_hid_condbtn_78

-- Fix altitude encoder (ALT100_1000 step, clamp 0~40000)
local function qfcu_toliss_fix_alt()
    if dr_enc_alt:ChangedUpdate() then
        local altstep = dr_enc_alt:Delta()
        local alt = dr_alt:Get()
        if dr_alt_unit:Get() == 1 then
            alt = alt + altstep * 10
        else
            alt = alt + altstep
        end
        if alt >= 0 and alt <= 40000 then
            dr_alt:Set(alt)
        end
    end
end

-- Fix baro encoder (hPa steps whole hPa, inHg steps 0.01)
local function qfcu_toliss_fix_baro(dr_enc, dr_baro, dr_unit)
    if dr_enc:ChangedUpdate() then
        local step = dr_enc:Delta()
        local baro = dr_baro:Get()
        if dr_unit:Get() == 1 then
            -- step in hPa, dataref holds inHg
            dr_baro:Set((baro * 33.8638895 + step) / 33.8638895)
        else
            dr_baro:Set(baro + step * 0.01)
        end
    end
end

-- ===========================================================
-- frame loop
local function qfcu_toliss_frame()
    qfcu_toliss_fix_alt()
    qfcu_toliss_fix_baro(dr_enc_baro_c, dr_c_baro, dr_c_barounit)
    qfcu_toliss_fix_baro(dr_enc_baro_f, dr_f_baro, dr_f_barounit)

    -- power edge
    if dr_power:ChangedUpdate() then
        if dr_power:Get() > 0 then
            qfcu:SetInv(-1)
            qfcu:FreshDigi()
        else
            qfcu:SetLedsOff()
            qfcu:SetDigiOff()
            qfcu:SetDigiBrtOff()
            qfcu:SetInv(-11)
        end
    end

    if dr_barostd_c:ChangedUpdate() then
        qfcu:SetLBaroMode(dr_barostd_c:Get() == 0 and 1 or 2)
    end
    if dr_barostd_f:ChangedUpdate() then
        qfcu:SetRBaroMode(dr_barostd_f:Get() == 0 and 1 or 2)
    end

    if dr_power:Get() > 0 then
        qfcu:SetBrt()
        qfcu:SetBkl()
        qfcu:SetMidLeds()
        qfcu:SetLeftLeds()
        qfcu:SetRightLeds()
        qfcu:SetSpd()
        qfcu:SetHdg()
        qfcu:SetAlt()
        qfcu:SetVs()
        qfcu:SetLBaro()
        qfcu:SetRBaro()
    end
end

-- boot gate: wait for FCU power or 5s, then start frame loop
local is_load = 0
local start_time = os.clock()
local function toliss_boot()
    if is_load == 1 then
        return
    end
    if os.clock() > start_time + 5 or dr_power:Get() > 0 then
        is_load = 1
        GlobalFrameLoopManager:add(qfcu_toliss_frame)
    end
end

GlobalFrameLoopManager:add(toliss_boot)
