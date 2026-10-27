-- *****************************************************************
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-10-27
-- *****************************************************************
-- QCDU x Bluebird Simulations B757 (MSFS 2020/2024) -- captain CDU
-- LVar source: qmdevother/docs/bb757.html (B757_CDU_1_* / B757_CDU1_*_decal)
--
-- QCDU hardware comes in two key layouts; the Boeing-style unit is the
-- Qcdub class (A320-style is Qcdua). The Bluebird 757 CDU is Boeing-style:
--   left LSK 1..6, right LSK 1..6, 12 page keys, keypad, SP / DEL / / / CLR
--
-- Bluebird page-key mapping (the model has no CLB / CRZ / DES / N1 LIMIT
-- pages, it exposes four extra keys instead, so keys 14/15/16/23 carry those;
-- swap the pairs below if you prefer a different order):
--   CLB(14) -> VNAV      CRZ(15) -> NAV RAD
--   DES(16) -> ATC       N1 LIMIT(23) -> FMC COMM
--
-- CDU screen: the QCDU display is rendered by mcduhub, which loads a per-addon
-- page based on ilua_qlcd_set_airplane(idx). The id enum in mcduhub
-- (mcduhub/AirplaneAutoSwitch.h) has FSL/FNX/FBW/PMDG/IFLY/ASO_73M/TLS only --
-- no Bluebird 757 entry yet, and the model exposes no per-character CDU screen
-- LVars, so there is nothing to feed a screen with today. This profile selects
-- index 0 (= mcduhub default page) so a previous aircraft's CDU is not left on
-- screen; wire a real index here once mcduhub knows how to render the 757 CDU.
if ilua_require_bluebird_757() then return end

-- Do not remove below lines: hardware detection
local qcdub = com.sim.qm.Qcdub.Open()
if not qcdub then return end
-- Do not remove above lines: hardware detection

uluaLog("QCDU of Bluebird B757")

-- 0 = mcduhub default page (no Bluebird CDU page exists yet)
ilua_qlcd_set_airplane(0)

-- ===========================================================
-- DataRef setup
local dr_CDU_bb757_exec = uluaFind("(L:FMC_EXEC_ACTIVE_1)")
local dr_CDU_bb757_msg = uluaFind("(L:B757_CDU1_MSG_decal)")
local dr_CDU_bb757_fail = uluaFind("(L:B757_CDU1_FAIL_decal)")
local dr_CDU_bb757_dspy = uluaFind("(L:B757_CDU1_DSPY_decal)")
local dr_CDU_bb757_ofst = uluaFind("(L:B757_CDU1_OFST_decal)")
-- single CDU brightness output in the model, range 0.1~1.5
local dr_CDU_bb757_brightness = uluaFind("(L:B757_CDU_BRIGHTNESS_L, number)")

-- ===========================================================
-- button binding
-- every key LVar is a momentary pushbutton: 0 = released, 1 = held

-- left line select keys
qcdub:CfgRpn(0, "1 (>L:B757_CDU_1_L1)", "0 (>L:B757_CDU_1_L1)")
qcdub:CfgRpn(1, "1 (>L:B757_CDU_1_L2)", "0 (>L:B757_CDU_1_L2)")
qcdub:CfgRpn(2, "1 (>L:B757_CDU_1_L3)", "0 (>L:B757_CDU_1_L3)")
qcdub:CfgRpn(3, "1 (>L:B757_CDU_1_L4)", "0 (>L:B757_CDU_1_L4)")
qcdub:CfgRpn(4, "1 (>L:B757_CDU_1_L5)", "0 (>L:B757_CDU_1_L5)")
qcdub:CfgRpn(5, "1 (>L:B757_CDU_1_L6)", "0 (>L:B757_CDU_1_L6)")
-- right line select keys
qcdub:CfgRpn(6, "1 (>L:B757_CDU_1_R1)", "0 (>L:B757_CDU_1_R1)")
qcdub:CfgRpn(7, "1 (>L:B757_CDU_1_R2)", "0 (>L:B757_CDU_1_R2)")
qcdub:CfgRpn(8, "1 (>L:B757_CDU_1_R3)", "0 (>L:B757_CDU_1_R3)")
qcdub:CfgRpn(9, "1 (>L:B757_CDU_1_R4)", "0 (>L:B757_CDU_1_R4)")
qcdub:CfgRpn(10, "1 (>L:B757_CDU_1_R5)", "0 (>L:B757_CDU_1_R5)")
qcdub:CfgRpn(11, "1 (>L:B757_CDU_1_R6)", "0 (>L:B757_CDU_1_R6)")

-- function keys
qcdub:CfgRpn(12, "1 (>L:B757_CDU_1_INIT)", "0 (>L:B757_CDU_1_INIT)")     -- INIT REF
qcdub:CfgRpn(13, "1 (>L:B757_CDU_1_RTE)", "0 (>L:B757_CDU_1_RTE)")       -- RTE
qcdub:CfgRpn(14, "1 (>L:B757_CDU_1_VNAV)", "0 (>L:B757_CDU_1_VNAV)")     -- CLB key -> VNAV
qcdub:CfgRpn(15, "1 (>L:B757_CDU_1_NAVRAD)", "0 (>L:B757_CDU_1_NAVRAD)") -- CRZ key -> NAV RAD
qcdub:CfgRpn(16, "1 (>L:B757_CDU_1_ATC)", "0 (>L:B757_CDU_1_ATC)")       -- DES key -> ATC
qcdub:CfgRpn(17, "1 (>L:B757_CDU_1_MENU)", "0 (>L:B757_CDU_1_MENU)")     -- MENU
qcdub:CfgRpn(18, "1 (>L:B757_CDU_1_LEGS)", "0 (>L:B757_CDU_1_LEGS)")     -- LEGS
qcdub:CfgRpn(19, "1 (>L:B757_CDU_1_DEPARR)", "0 (>L:B757_CDU_1_DEPARR)") -- DEP ARR
qcdub:CfgRpn(20, "1 (>L:B757_CDU_1_HOLD)", "0 (>L:B757_CDU_1_HOLD)")     -- HOLD
qcdub:CfgRpn(21, "1 (>L:B757_CDU_1_PROG)", "0 (>L:B757_CDU_1_PROG)")     -- PROG
qcdub:CfgRpn(22, "1 (>L:B757_CDU_1_EXEC)", "0 (>L:B757_CDU_1_EXEC)")     -- EXEC
qcdub:CfgRpn(23, "1 (>L:B757_CDU_1_FMCCOMM)", "0 (>L:B757_CDU_1_FMCCOMM)") -- N1 LIMIT -> FMC COMM
qcdub:CfgRpn(24, "1 (>L:B757_CDU_1_FIX)", "0 (>L:B757_CDU_1_FIX)")       -- FIX
qcdub:CfgRpn(25, "1 (>L:B757_CDU_1_PREV)", "0 (>L:B757_CDU_1_PREV)")     -- PREV PAGE
qcdub:CfgRpn(26, "1 (>L:B757_CDU_1_NEXT)", "0 (>L:B757_CDU_1_NEXT)")     -- NEXT PAGE

-- keypad
qcdub:CfgRpn(27, "1 (>L:B757_CDU_1_NUM1)", "0 (>L:B757_CDU_1_NUM1)")
qcdub:CfgRpn(28, "1 (>L:B757_CDU_1_NUM2)", "0 (>L:B757_CDU_1_NUM2)")
qcdub:CfgRpn(29, "1 (>L:B757_CDU_1_NUM3)", "0 (>L:B757_CDU_1_NUM3)")
qcdub:CfgRpn(30, "1 (>L:B757_CDU_1_NUM4)", "0 (>L:B757_CDU_1_NUM4)")
qcdub:CfgRpn(31, "1 (>L:B757_CDU_1_NUM5)", "0 (>L:B757_CDU_1_NUM5)")
qcdub:CfgRpn(32, "1 (>L:B757_CDU_1_NUM6)", "0 (>L:B757_CDU_1_NUM6)")
qcdub:CfgRpn(33, "1 (>L:B757_CDU_1_NUM7)", "0 (>L:B757_CDU_1_NUM7)")
qcdub:CfgRpn(34, "1 (>L:B757_CDU_1_NUM8)", "0 (>L:B757_CDU_1_NUM8)")
qcdub:CfgRpn(35, "1 (>L:B757_CDU_1_NUM9)", "0 (>L:B757_CDU_1_NUM9)")
qcdub:CfgRpn(36, "1 (>L:B757_CDU_1_NUMPER)", "0 (>L:B757_CDU_1_NUMPER)")   -- decimal point
qcdub:CfgRpn(37, "1 (>L:B757_CDU_1_NUM0)", "0 (>L:B757_CDU_1_NUM0)")
qcdub:CfgRpn(38, "1 (>L:B757_CDU_1_NUMPLUS)", "0 (>L:B757_CDU_1_NUMPLUS)")  -- +/-

-- alphabet keys
qcdub:CfgRpn(39, "1 (>L:B757_CDU_1_KEYA)", "0 (>L:B757_CDU_1_KEYA)")
qcdub:CfgRpn(40, "1 (>L:B757_CDU_1_KEYB)", "0 (>L:B757_CDU_1_KEYB)")
qcdub:CfgRpn(41, "1 (>L:B757_CDU_1_KEYC)", "0 (>L:B757_CDU_1_KEYC)")
qcdub:CfgRpn(42, "1 (>L:B757_CDU_1_KEYD)", "0 (>L:B757_CDU_1_KEYD)")
qcdub:CfgRpn(43, "1 (>L:B757_CDU_1_KEYE)", "0 (>L:B757_CDU_1_KEYE)")
qcdub:CfgRpn(44, "1 (>L:B757_CDU_1_KEYF)", "0 (>L:B757_CDU_1_KEYF)")
qcdub:CfgRpn(45, "1 (>L:B757_CDU_1_KEYG)", "0 (>L:B757_CDU_1_KEYG)")
qcdub:CfgRpn(46, "1 (>L:B757_CDU_1_KEYH)", "0 (>L:B757_CDU_1_KEYH)")
qcdub:CfgRpn(47, "1 (>L:B757_CDU_1_KEYI)", "0 (>L:B757_CDU_1_KEYI)")
qcdub:CfgRpn(48, "1 (>L:B757_CDU_1_KEYJ)", "0 (>L:B757_CDU_1_KEYJ)")
qcdub:CfgRpn(49, "1 (>L:B757_CDU_1_KEYK)", "0 (>L:B757_CDU_1_KEYK)")
qcdub:CfgRpn(50, "1 (>L:B757_CDU_1_KEYL)", "0 (>L:B757_CDU_1_KEYL)")
qcdub:CfgRpn(51, "1 (>L:B757_CDU_1_KEYM)", "0 (>L:B757_CDU_1_KEYM)")
qcdub:CfgRpn(52, "1 (>L:B757_CDU_1_KEYN)", "0 (>L:B757_CDU_1_KEYN)")
qcdub:CfgRpn(53, "1 (>L:B757_CDU_1_KEYO)", "0 (>L:B757_CDU_1_KEYO)")
qcdub:CfgRpn(54, "1 (>L:B757_CDU_1_KEYP)", "0 (>L:B757_CDU_1_KEYP)")
qcdub:CfgRpn(55, "1 (>L:B757_CDU_1_KEYQ)", "0 (>L:B757_CDU_1_KEYQ)")
qcdub:CfgRpn(56, "1 (>L:B757_CDU_1_KEYR)", "0 (>L:B757_CDU_1_KEYR)")
qcdub:CfgRpn(57, "1 (>L:B757_CDU_1_KEYS)", "0 (>L:B757_CDU_1_KEYS)")
qcdub:CfgRpn(58, "1 (>L:B757_CDU_1_KEYT)", "0 (>L:B757_CDU_1_KEYT)")
qcdub:CfgRpn(59, "1 (>L:B757_CDU_1_KEYU)", "0 (>L:B757_CDU_1_KEYU)")
qcdub:CfgRpn(60, "1 (>L:B757_CDU_1_KEYV)", "0 (>L:B757_CDU_1_KEYV)")
qcdub:CfgRpn(61, "1 (>L:B757_CDU_1_KEYW)", "0 (>L:B757_CDU_1_KEYW)")
qcdub:CfgRpn(62, "1 (>L:B757_CDU_1_KEYX)", "0 (>L:B757_CDU_1_KEYX)")
qcdub:CfgRpn(63, "1 (>L:B757_CDU_1_KEYY)", "0 (>L:B757_CDU_1_KEYY)")
qcdub:CfgRpn(64, "1 (>L:B757_CDU_1_KEYZ)", "0 (>L:B757_CDU_1_KEYZ)")

-- SP / DEL / slash / CLR
qcdub:CfgRpn(65, "1 (>L:B757_CDU_1_KEYSP)", "0 (>L:B757_CDU_1_KEYSP)")
qcdub:CfgRpn(66, "1 (>L:B757_CDU_1_KEYDEL)", "0 (>L:B757_CDU_1_KEYDEL)")
qcdub:CfgRpn(67, "1 (>L:B757_CDU_1_KEYSLASH)", "0 (>L:B757_CDU_1_KEYSLASH)")
qcdub:CfgRpn(68, "1 (>L:B757_CDU_1_KEYCLR)", "0 (>L:B757_CDU_1_KEYCLR)")

-- brightness knob (B757_FMC_1_SCREEN_KNOB: 0~30, step 0.25)
qcdub:CfgRpn(69, "(L:B757_FMC_1_SCREEN_KNOB, number) 0.25 + 30 min (>L:B757_FMC_1_SCREEN_KNOB, number)")
qcdub:CfgRpn(70, "(L:B757_FMC_1_SCREEN_KNOB, number) 0.25 - 0 max (>L:B757_FMC_1_SCREEN_KNOB, number)")

-- ===========================================================
-- Leds
qcdub:GetMsg("(L:B757_CDU1_MSG_decal)")
qcdub:GetOfst("(L:B757_CDU1_OFST_decal)")
-- the B757 CDU has DSPY/FAIL/MSG/OFST annunciators, no CALL light
qcdub:GetCall("(L:B757_CDU1_DSPY_decal)")
qcdub:GetFail("(L:B757_CDU1_FAIL_decal)")
qcdub:GetExec("(L:FMC_EXEC_ACTIVE_1)")

-- key backlight and screen brightness: the model exposes one brightness output
-- (0.1~1.5), mapped to the 0~100 range both channels expect (x66)
qcdub:GetBkl("(L:B757_CDU_BRIGHTNESS_L, number)", 66)
qcdub:GetScreenBrt("(L:B757_CDU_BRIGHTNESS_L, number)", 66)

-- ===========================================================
-- Frame loop
-- the driver's setters are change-guarded when called without an explicit
-- value, so the no-argument forms are used to keep idle HID traffic at zero
local dr_bat = iDataRef:New("(L:B757_OVHD_BATTERY_BUTTON)")
local dr_ext = iDataRef:New("(L:B757_OVHD_EXT_PWR_BUTTON_ON)")
local powered_last = -1

GlobalFrameLoopManager:add(function()
    local powered = (dr_bat:Get() >= 1 or dr_ext:Get() >= 1) and 1 or 0
    if powered ~= powered_last then
        powered_last = powered
        if powered == 0 then
            qcdub:Off()
        else
            -- force a full refresh: Off() only changed the hardware, the Lua
            -- side values did not move, so the guarded setters would stay quiet
            qcdub:FreshBkl()
            qcdub:FreshScreenBrt()
        end
    end
    if powered == 0 then
        return
    end

    qcdub:SetLeds()
    qcdub:SetBkl()
    qcdub:SetScreenBrt()
end)
