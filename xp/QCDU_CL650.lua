-- *****************************************************************
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-04-16
-- *****************************************************************

if ilua_is_acfpath_excluded("cl650") then
    return
end


-- Do not remove below lines: hardware detection
local qcdub = com.sim.qm.Qcdub:new()
if not qcdub:Init() then
    return
end
-- Do not remove above lines: hardware detection

uluaLog("QCDU-B737 for CL650")

ilua_qlcd_set_airplane(100)

-- Configure button bindings using Qcdub class
qcdub:CfgCmd(0, "CL650/CDU/1/lsk_l1")
qcdub:CfgCmd(1, "CL650/CDU/1/lsk_l2")
qcdub:CfgCmd(2, "CL650/CDU/1/lsk_l3")
qcdub:CfgCmd(3, "CL650/CDU/1/lsk_l4")
qcdub:CfgCmd(4, "CL650/CDU/1/lsk_l5")
qcdub:CfgCmd(5, "CL650/CDU/1/lsk_l6")
qcdub:CfgCmd(6, "CL650/CDU/1/lsk_r1")
qcdub:CfgCmd(7, "CL650/CDU/1/lsk_r2")
qcdub:CfgCmd(8, "CL650/CDU/1/lsk_r3")
qcdub:CfgCmd(9, "CL650/CDU/1/lsk_r4")
qcdub:CfgCmd(10, "CL650/CDU/1/lsk_r5")
qcdub:CfgCmd(11, "CL650/CDU/1/lsk_r6")
qcdub:CfgCmd(12, "CL650/CDU/1/idx")
qcdub:CfgCmd(13, "CL650/CDU/1/fpln")
qcdub:CfgCmd(14, "CL650/CDU/1/perf")
qcdub:CfgCmd(15, "CL650/CDU/1/mfd_adv")
qcdub:CfgCmd(16, "CL650/CDU/1/mfd_data")
qcdub:CfgCmd(17, "CL650/CDU/1/dspl_menu")
qcdub:CfgCmd(18, "CL650/CDU/1/legs")
qcdub:CfgCmd(19, "CL650/CDU/1/dep_arr")
qcdub:CfgCmd(20, "CL650/CDU/1/tun")
qcdub:CfgCmd(21, "CL650/CDU/1/Key_PROG")
qcdub:CfgCmd(22, "CL650/CDU/1/exec")
qcdub:CfgCmd(23, "CL650/CDU/1/Key_TRS")
qcdub:CfgCmd(24, "CL650/CDU/1/dir")
qcdub:CfgCmd(25, "CL650/CDU/1/prev")
qcdub:CfgCmd(26, "CL650/CDU/1/next")
qcdub:CfgCmd(27, "CL650/CDU/1/char_1")
qcdub:CfgCmd(28, "CL650/CDU/1/char_2")
qcdub:CfgCmd(29, "CL650/CDU/1/char_3")
qcdub:CfgCmd(30, "CL650/CDU/1/char_4")
qcdub:CfgCmd(31, "CL650/CDU/1/char_5")
qcdub:CfgCmd(32, "CL650/CDU/1/char_6")
qcdub:CfgCmd(33, "CL650/CDU/1/char_7")
qcdub:CfgCmd(34, "CL650/CDU/1/char_8")
qcdub:CfgCmd(35, "CL650/CDU/1/char_9")
qcdub:CfgCmd(36, "CL650/CDU/1/char_period")
qcdub:CfgCmd(37, "CL650/CDU/1/char_0")
qcdub:CfgCmd(38, "CL650/CDU/1/char_plus_minus")
qcdub:CfgCmd(39, "CL650/CDU/1/char_A")
qcdub:CfgCmd(40, "CL650/CDU/1/char_B")
qcdub:CfgCmd(41, "CL650/CDU/1/char_C")
qcdub:CfgCmd(42, "CL650/CDU/1/char_D")
qcdub:CfgCmd(43, "CL650/CDU/1/char_E")
qcdub:CfgCmd(44, "CL650/CDU/1/char_F")
qcdub:CfgCmd(45, "CL650/CDU/1/char_G")
qcdub:CfgCmd(46, "CL650/CDU/1/char_H")
qcdub:CfgCmd(47, "CL650/CDU/1/char_I")
qcdub:CfgCmd(48, "CL650/CDU/1/char_J")
qcdub:CfgCmd(49, "CL650/CDU/1/char_K")
qcdub:CfgCmd(50, "CL650/CDU/1/char_L")
qcdub:CfgCmd(51, "CL650/CDU/1/char_M")
qcdub:CfgCmd(52, "CL650/CDU/1/char_N")
qcdub:CfgCmd(53, "CL650/CDU/1/char_O")
qcdub:CfgCmd(54, "CL650/CDU/1/char_P")
qcdub:CfgCmd(55, "CL650/CDU/1/char_Q")
qcdub:CfgCmd(56, "CL650/CDU/1/char_R")
qcdub:CfgCmd(57, "CL650/CDU/1/char_S")
qcdub:CfgCmd(58, "CL650/CDU/1/char_T")
qcdub:CfgCmd(59, "CL650/CDU/1/char_U")
qcdub:CfgCmd(60, "CL650/CDU/1/char_V")
qcdub:CfgCmd(61, "CL650/CDU/1/char_W")
qcdub:CfgCmd(62, "CL650/CDU/1/char_X")
qcdub:CfgCmd(63, "CL650/CDU/1/char_Y")
qcdub:CfgCmd(64, "CL650/CDU/1/char_Z")
qcdub:CfgCmd(65, "CL650/CDU/1/char_space")
qcdub:CfgCmd(66, "CL650/CDU/1/clr_del")
qcdub:CfgCmd(67, "CL650/CDU/1/char_slash")
qcdub:CfgCmd(68, "CL650/CDU/1/clr_del")

qcdub:CfgVal(69, "CL650/CDU/N/brt", -1, 0)
qcdub:CfgVal(70, "CL650/CDU/N/brt", 1, 0)

-- DataRef setup for LED indicators
local dr_CDU_ERJ_exec = uluaFind("sim/cockpit/g1000/g1000_n2_eis")
local dr_CDU_ERJ_msg = uluaFind("sim/cockpit/g1000/g1000_n2_eis")
local dr_CDU_ERJ_brightness = uluaFind("sim/cockpit2/electrical/panel_brightness_ratio[2]") -- 0-1
qcdub:GetScreenBrt('CL650/CDU/1/screen/brt')                                           -- 0-1

-- LED Update Function
-- DONT use this name "CDU_CL650_LED_UPD" again
-- it must be unique across all .sec and lua files
function CDU_CL650_LED_UPD()
    qcdub:SetMsg(nil, math.floor(uluaGet(dr_CDU_ERJ_msg) + 0.5))
    qcdub:SetExec(nil, math.floor(uluaGet(dr_CDU_ERJ_exec) + 0.5))
    qcdub:SetScreenBrt()
    local brightness = math.floor(uluaGet(dr_CDU_ERJ_brightness) * 60)
    qcdub:SetBkl(brightness)
end

uluaAddDoLoop("CDU_CL650_LED_UPD()")
