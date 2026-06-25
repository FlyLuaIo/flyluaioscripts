-- *****************************************************************
-- created by Wei Shuai <cpuwolf@gmail.com> 2024-05-16
-- Modify by Carson Lou <carsonlu@sohu.com> 2025-7-25
-- *****************************************************************
if ilua_require_pmdg_737() then return end

-- Do not remove below lines: hardware detection
local qmpe = com.sim.qm.Qmpe:new()
if not qmpe:Init() then
    return
end
-- Do not remove above lines: hardware detection

uluaLog("QMPE for PMDG737")

qmpe:AddTogMenu("RMP2 as NAV", "RMP2用于NAV", "g_qmpe_pmdg737_use_nav")

-- ===========================================================
-- button binding

-- RMP

-- Power On/Off
qmpe:CfgRpn(4, "90301 (>K:ROTOR_BRAKE)")

local lua_nav1_or_nav2 = 0 -- NAV1 default value
if g_qmpe_pmdg737_use_nav ~= 0 then
    --NAV1/NAV2
    qmpe:CfgRpn(28, "(>K:NAV1_RADIO_FRACT_DEC)")
    qmpe:CfgRpn(29, "(>K:NAV1_RADIO_FRACT_INC)")

    qmpe:CfgRpn(30, "(>K:NAV1_RADIO_WHOLE_DEC)")
    qmpe:CfgRpn(31, "(>K:NAV1_RADIO_WHOLE_INC)")
    qmpe:CfgRpn(33, "(>K:NAV1_RADIO_SWAP)")
    uluaWriteCmd(tostring(lua_nav1_or_nav2) .. " (>L:A32NX_RMP_R_SELECTED_MODE)")
    function set_nav1_nav2()
        uluaWriteCmd(tostring(lua_nav1_or_nav2) .. " (>L:A32NX_RMP_R_SELECTED_MODE)")
        if lua_nav1_or_nav2 == 0 then
            qmpe:CfgRpn(28, "(>K:NAV1_RADIO_FRACT_DEC)")
            qmpe:CfgRpn(29, "(>K:NAV1_RADIO_FRACT_INC)")

            qmpe:CfgRpn(30, "(>K:NAV1_RADIO_WHOLE_DEC)")
            qmpe:CfgRpn(31, "(>K:NAV1_RADIO_WHOLE_INC)")
            qmpe:CfgRpn(33, "(>K:NAV1_RADIO_SWAP)")
        else
            qmpe:CfgRpn(28, "(>K:NAV2_RADIO_FRACT_DEC)")
            qmpe:CfgRpn(29, "(>K:NAV2_RADIO_FRACT_INC)")

            qmpe:CfgRpn(30, "(>K:NAV2_RADIO_WHOLE_DEC)")
            qmpe:CfgRpn(31, "(>K:NAV2_RADIO_WHOLE_INC)")
            qmpe:CfgRpn(33, "(>K:NAV2_RADIO_SWAP)")
        end
    end

    function flip_nav1_nav2()
        lua_nav1_or_nav2 = 1 - lua_nav1_or_nav2
        set_nav1_nav2()
    end

    qmpe:CfgFc(32, "flip_nav1_nav2()")
else
    qmpe:CfgRpn(32, "(L:A32NX_RMP_R_TOGGLE_SWITCH) ! (>L:A32NX_RMP_R_TOGGLE_SWITCH)")
end
-- VHF1
qmpe:CfgRpn(7, "90401 (>K:ROTOR_BRAKE)")
-- VHF2
qmpe:CfgRpn(6, "90601 (>K:ROTOR_BRAKE)")
-- VHF1 RX
-- qmpe:CfgRpn(10, "(A:COM RECEIVE:1, Bool) ! (>K:COM1_RECEIVE_SELECT)")
qmpe:CfgRpn(10, "73901 (>K:ROTOR_BRAKE)")
-- VHF2 RX
-- qmpe:CfgRpn(11, "(A:COM RECEIVE:2, Bool) ! (>K:COM2_RECEIVE_SELECT)")
qmpe:CfgRpn(11, "74001 (>K:ROTOR_BRAKE)")
-- INT RX
qmpe:CfgRpn(12, "(L:S_ASP_INT_REC_LATCH) ! (>L:S_ASP_INT_REC_LATCH)")
-- CAB RX
qmpe:CfgRpn(13, "(L:S_ASP_CAB_REC_LATCH) ! (>L:S_ASP_CAB_REC_LATCH)")
-- PA RX
-- qmpe:CfgRpn(14, "(L:S_ASP_PA_REC_LATCH) ! (>L:S_ASP_PA_REC_LATCH)")
-- WX+T
qmpe:CfgRpn(14, "91601 (>K:ROTOR_BRAKE) , 92001 (>K:ROTOR_BRAKE)")


-- VHF1 TX
-- qmpe:CfgRpn(15, "(>K:COM1_TRANSMIT_SELECT)")
qmpe:CfgRpn(15, "73401 (>K:ROTOR_BRAKE) , 73404 (>K:ROTOR_BRAKE)")
-- VHF2 TX
-- qmpe:CfgRpn(24, "(>K:COM2_TRANSMIT_SELECT)")
qmpe:CfgRpn(24, "73501 (>K:ROTOR_BRAKE) , 73504 (>K:ROTOR_BRAKE)")
-- INT TX
qmpe:CfgRpn(25, "1 (>L:S_ASP_INT_SEND)", "0 (>L:S_ASP_INT_SEND)")
-- CAB TX
qmpe:CfgRpn(26, "1 (>L:S_ASP_CAB_SEND)", "0 (>L:S_ASP_CAB_SEND)")
-- PA TX nop, Airbus PA send is not latched
qmpe:CfgRpn(27, "1 (>L:S_ASP_PA_SEND)", "0 (>L:S_ASP_PA_SEND)")

-- VHF1 RX volume
qmpe:CfgRpn(16, "(L:XMLVAR_COM_1_Volume_VHF_L) 0.01 - 0 max (>L:XMLVAR_COM_1_Volume_VHF_L)")
qmpe:CfgRpn(17, "(L:XMLVAR_COM_1_Volume_VHF_L) 0.01 + 1 min (>L:XMLVAR_COM_1_Volume_VHF_L)")
-- VHF2 RX volume
qmpe:CfgRpn(18, "(L:XMLVAR_COM_1_Volume_VHF_C) 0.01 - 0 max (>L:XMLVAR_COM_1_Volume_VHF_C)")
qmpe:CfgRpn(19, "(L:XMLVAR_COM_1_Volume_VHF_C) 0.01 + 1 min (>L:XMLVAR_COM_1_Volume_VHF_C)")
-- INT RX volume
-- qmpe:CfgRpn(20, "(L:A_ASP_INT_VOLUME) 0.05 - 0 max (>L:A_ASP_INT_VOLUME)")
-- qmpe:CfgRpn(21, "(L:A_ASP_INT_VOLUME) 0.05 + 1 min (>L:A_ASP_INT_VOLUME)")
-- OVHD FLT ALT
qmpe:CfgRpn(20, "21808 (>K:ROTOR_BRAKE)")
qmpe:CfgRpn(21, "21807 (>K:ROTOR_BRAKE)")
-- CAB RX volume
-- qmpe:CfgRpn(22, "(L:A_ASP_CAB_VOLUME) 0.05 - 0 max (>L:A_ASP_CAB_VOLUME)")
-- qmpe:CfgRpn(23, "(L:A_ASP_CAB_VOLUME) 0.05 + 1 min (>L:A_ASP_CAB_VOLUME)")
qmpe:CfgRpn(8, "92308 (>K:ROTOR_BRAKE) , 92208 (>K:ROTOR_BRAKE)")
qmpe:CfgRpn(9, "92307 (>K:ROTOR_BRAKE) , 92207 (>K:ROTOR_BRAKE)")
-- OVHD LDG ALT
qmpe:CfgRpn(22, "22008 (>K:ROTOR_BRAKE)")
qmpe:CfgRpn(23, "22007 (>K:ROTOR_BRAKE)")
-- PA volume
-- qmpe:CfgRpn(8, "(L:A_ASP_PA_VOLUME) 0.05 - 0 max (>L:A_ASP_PA_VOLUME)")
-- qmpe:CfgRpn(9, "(L:A_ASP_PA_VOLUME) 0.05 + 1 min (>L:A_ASP_PA_VOLUME)")
if g_qmpe_pmdg737_use_nav == 0 then
    -- RMP2
    -- VHF1
    qmpe:CfgRpn(34, "(>H:A32NX_RMP_R_VHF1_BUTTON_PRESSED)")
    -- VHF2
    qmpe:CfgRpn(35, "(>H:A32NX_RMP_R_VHF2_BUTTON_PRESSED)")
else
    function force_nav1_nav2(val)
        lua_nav1_or_nav2 = val
        set_nav1_nav2()
    end

    qmpe:CfgFc(34, "force_nav1_nav2(0)")
    qmpe:CfgFc(35, "force_nav1_nav2(1)")
end

-- weather SYS 1/OFF/2
qmpe:CfgRpn(36, "0 (>L:XMLVAR_A320_WeatherRadar_Sys)")
-- 80 is middle key
qmpe:CfgRpn(80, "1 (>L:XMLVAR_A320_WeatherRadar_Sys)")
qmpe:CfgRpn(37, "2 (>L:XMLVAR_A320_WeatherRadar_Sys)")

-- weather PWS off/auto
qmpe:CfgRpn(38, "0 (>L:A32NX_SWITCH_RADAR_PWS_POSITION)")
-- 39 is right key
qmpe:CfgRpn(39, "1 (>L:A32NX_SWITCH_RADAR_PWS_POSITION)")

-- XPDR STBY/TA/TARA
local xpdr_tara = QmdevPosSwitchInit("(L:switch_800_73X, number)", 10, "80007 (>K:ROTOR_BRAKE)",
    "80008 (>K:ROTOR_BRAKE)", 100)
qmpe:CfgPSw(40, xpdr_tara, 10)
qmpe:CfgPSw(41, xpdr_tara, 30)
qmpe:CfgPSw(81, xpdr_tara, 40)
-- XPDR STBY/AUTO/ON
local xpdr_onmode = QmdevPosSwitchInit("(L:switch_1299_73X, number)", 50, "129907 (>K:ROTOR_BRAKE)",
    "129908 (>K:ROTOR_BRAKE)", 100)
qmpe:CfgPSw(42, xpdr_onmode, 0)
qmpe:CfgPSw(43, xpdr_onmode, 100)
qmpe:CfgPSw(82, xpdr_onmode, 50)

-- CAUT
-- MASTER CAUTION
qmpe:CfgRpn(44, "34801 (>K:ROTOR_BRAKE)")
-- WARN: FIRE WARN BELL CUTOUT
qmpe:CfgRpn(79, "34701 (>K:ROTOR_BRAKE)")

-- INTEG LT Push
qmpe:CfgRpn(45, "1 (>L:A32NX_DCDU_ATC_MSG_ACK)")

-- INTEG LT
-- FLOOD BRIGHT
if MSFS_VERSION == 0 then
    qmpe:CfgRpn(46, "75608 (>K:ROTOR_BRAKE) , 33808 (>K:ROTOR_BRAKE) , 33708 (>K:ROTOR_BRAKE) , 9408 (>K:ROTOR_BRAKE)")
    qmpe:CfgRpn(47, "75607 (>K:ROTOR_BRAKE) , 33807 (>K:ROTOR_BRAKE) , 33707 (>K:ROTOR_BRAKE) , 9407 (>K:ROTOR_BRAKE)")
else
    if g_qmpe_pmdg737_use_nav ~= 0 then
        qmpe:CfgRpn(46,
            "(L:OH_CB_PANEL_LIGHT_CONTROL, number) 20 - 0 max (>L:OH_CB_PANEL_LIGHT_CONTROL, number) (L:CA_BACKGROUND_BRT_CONTROL, number) 20 - 0 max (>L:CA_BACKGROUND_BRT_CONTROL, number) (L:CA_AFDS_FLOOD_LIGHT_CONTROL, number) 20 - 0 max (>L:CA_AFDS_FLOOD_LIGHT_CONTROL, number) (L:PED_FLOOD_LIGHT_CONTROL, number) 20 - 0 max (>L:PED_FLOOD_LIGHT_CONTROL, number)")
        qmpe:CfgRpn(47,
            "(L:OH_CB_PANEL_LIGHT_CONTROL, number) 3 + 300 min (>L:OH_CB_PANEL_LIGHT_CON, number) (L:CA_BACKGROUND_BRT_CONTROL, number) 3 + 300 min (>L:CA_BACKGROUND_BRT_CONTROL, number) (L:CA_AFDS_FLOOD_LIGHT_CONTROL, number) 3 + 300 min (>L:CA_AFDS_FLOOD_LIGHT_CONTROL, number) (L:PED_FLOOD_LIGHT_CONTROL, number) 3 + 300 min (>L:PED_FLOOD_LIGHT_CONTROL, number)")
    else
        qmpe:CfgRpn(46,
            "(L:PED_PANEL_LIGHT_CONTROL, number) 6 - 0 max (>L:PED_PANEL_LIGHT_CONTROL, number) (L:CA_MAIN_PANEL_LIGHT_CONTROL, number) 6 - 0 max (>L:CA_MAIN_PANEL_LIGHT_CONTROL, number)")
        qmpe:CfgRpn(47,
            "(L:PED_PANEL_LIGHT_CONTROL, number) 6 + 300 min (>L:PED_PANEL_LIGHT_CONTROL, number) (L:CA_MAIN_PANEL_LIGHT_CONTROL, number) 6 + 300 min (>L:CA_MAIN_PANEL_LIGHT_CONTROL, number)")
    end
end
-- ECAM
-- HUD
qmpe:CfgRpn(78, "97901 (>K:ROTOR_BRAKE)")

-- MFD ENG BUTTON
-- qmpe:CfgRpn(48, "20 (>L:A32NX_ECAM_SD_CURRENT_PAGE_INDEX) 46300 1 + (>K:ROTOR_BRAKE)")

function pmdg737_eng_step2()
    uluaWriteCmd("20 (>L:A32NX_ECAM_SD_CURRENT_PAGE_INDEX)")
end

function pmdg737_eng_step1()
    uluaWriteCmd("46300 1 + (>K:ROTOR_BRAKE)")
    uluasetTimeout("pmdg737_eng_step2()", 100)
end

qmpe:CfgFc(48, "pmdg737_eng_step1()", '')

qmpe:CfgRpn(49, "1 (>L:A32NX_ECAM_SD_CURRENT_PAGE_INDEX)")
qmpe:CfgRpn(50, "2 (>L:A32NX_ECAM_SD_CURRENT_PAGE_INDEX)")
qmpe:CfgRpn(51, "3 (>L:A32NX_ECAM_SD_CURRENT_PAGE_INDEX)")

-- CHOCKS TOGGLE
qmpe:CfgRpn(52, "62301 (>K:ROTOR_BRAKE) , 61601 (>K:ROTOR_BRAKE) , 61201 (>K:ROTOR_BRAKE) , 61701 (>K:ROTOR_BRAKE)")

-- GND PWR COWN
qmpe:CfgRpn(53, "62301 (>K:ROTOR_BRAKE) , 61601 (>K:ROTOR_BRAKE) , 61201 (>K:ROTOR_BRAKE) , 60701 (>K:ROTOR_BRAKE)")

qmpe:CfgRpn(54, "6 (>L:A32NX_ECAM_SD_CURRENT_PAGE_INDEX)")
qmpe:CfgRpn(55, "7 (>L:A32NX_ECAM_SD_CURRENT_PAGE_INDEX)")
qmpe:CfgRpn(56, "8 (>L:A32NX_ECAM_SD_CURRENT_PAGE_INDEX)")
qmpe:CfgRpn(57, "9 (>L:A32NX_ECAM_SD_CURRENT_PAGE_INDEX)")
qmpe:CfgRpn(58, "10 (>L:A32NX_ECAM_SD_CURRENT_PAGE_INDEX)")

qmpe:CfgRpn(59, "1 (>L:A32NX_ECAM_ALL_Push_IsDown)", "0 (>L:A32NX_ECAM_ALL_Push_IsDown)")

qmpe:CfgRpn(60, "1 (>L:A32NX_BTN_CLR)", "0 (>L:A32NX_BTN_CLR)")

-- MFD SYS BUTTON
qmpe:CfgRpn(61,
    "(L:A32NX_ECAM_SD_CURRENT_PAGE_INDEX) 11 != if{ 11 (>L:A32NX_ECAM_SD_CURRENT_PAGE_INDEX) } els{ -1 (>L:A32NX_ECAM_SD_CURRENT_PAGE_INDEX) } (>H:A32NX_SD_PAGE_CHANGED)  46200 1 + (>K:ROTOR_BRAKE)")
qmpe:CfgRpn(62, "1 (>L:A32NX_BTN_RCL)", "0 (>L:A32NX_BTN_RCL)")

-- Terrain
qmpe:CfgRpn(63, "(L:A32NX_EFIS_TERR_L_ACTIVE,bool) ! (>L:A32NX_EFIS_TERR_L_ACTIVE)")

-- XDRD IDENT
-- qmpe:CfgRpn(64, "(>H:A320_Neo_ATC_BTN_IDENT)")
qmpe:CfgRpn(64, "80601 (>K:ROTOR_BRAKE)")
-- qmpe:CfgRpn(64, "(>K:XPNDR_IDENT_ON)")

-- Chrone
-- qmpe:CfgRpn(65, "0 (>H:A32NX_EFIS_L_CHRONO_PUSHED)")
-- CLOCK
qmpe:CfgRpn(65, "31401 (>K:ROTOR_BRAKE) , 52301 (>K:ROTOR_BRAKE)")

-- XPRD ATC Keypad
qmpe:CfgRpn(66, "130101 (>K:ROTOR_BRAKE)", "130104 (>K:ROTOR_BRAKE)")
qmpe:CfgRpn(67, "130201 (>K:ROTOR_BRAKE)", "130204 (>K:ROTOR_BRAKE)")
qmpe:CfgRpn(68, "130301 (>K:ROTOR_BRAKE)", "130304 (>K:ROTOR_BRAKE)")
qmpe:CfgRpn(69, "130401 (>K:ROTOR_BRAKE)", "130404 (>K:ROTOR_BRAKE)")
qmpe:CfgRpn(70, "130501 (>K:ROTOR_BRAKE)", "130504 (>K:ROTOR_BRAKE)")
qmpe:CfgRpn(71, "130601 (>K:ROTOR_BRAKE)", "130604 (>K:ROTOR_BRAKE)")
qmpe:CfgRpn(72, "130701 (>K:ROTOR_BRAKE)", "130704 (>K:ROTOR_BRAKE)")
qmpe:CfgRpn(73, "130801 (>K:ROTOR_BRAKE)", "130804 (>K:ROTOR_BRAKE)")
qmpe:CfgRpn(74, "130901 (>K:ROTOR_BRAKE)", "130904 (>K:ROTOR_BRAKE)")

-- autobrake
local dr_autobrake = iDataRef:New('(L:switch_460_73X, number)')
local pswh_autobrake = QmdevPosSwitchInit("(L:switch_460_73X, number)", 10, "46007 (>K:ROTOR_BRAKE)",
    "46008 (>K:ROTOR_BRAKE)", 100)
function autobrake_low()
    if dr_autobrake:Get() == 10 then
        QmdevPosSwitchSet(pswh_autobrake, 20)
    else
        QmdevPosSwitchSet(pswh_autobrake, 10)
    end
end

function autobrake_med()
    if dr_autobrake:Get() == 10 then
        QmdevPosSwitchSet(pswh_autobrake, 30)
    else
        QmdevPosSwitchSet(pswh_autobrake, 10)
    end
end

function key_max_long_func()
    if dr_autobrake:Get() == 10 then
        QmdevPosSwitchSet(pswh_autobrake, 0)
    else
        QmdevPosSwitchSet(pswh_autobrake, 10)
    end
end

function key_max_short_func()
    if dr_autobrake:Get() == 10 then
        QmdevPosSwitchSet(pswh_autobrake, 70)
    else
        QmdevPosSwitchSet(pswh_autobrake, 10)
    end
end

if g_qmpe_pmdg737_use_nav == 0 then
    qmpe:CfgFc(75, 'autobrake_low()')
    qmpe:CfgFc(76, 'autobrake_med()')
    qmpe:CfgLongFc(77, 1000, key_max_long_func, key_max_short_func)
else
    --AP RST A/T RST FMC RST
    qmpe:CfgRpn(75, "33901 (>K:ROTOR_BRAKE)")
    qmpe:CfgRpn(76, "34001 (>K:ROTOR_BRAKE)")
    qmpe:CfgRpn(77, "34101 (>K:ROTOR_BRAKE)")
end
---- RMP1
-- inner
qmpe:CfgRpn(0, "72708 (>K:ROTOR_BRAKE)")
qmpe:CfgRpn(1, "72707 (>K:ROTOR_BRAKE)")
-- outer
qmpe:CfgRpn(2, "72608 (>K:ROTOR_BRAKE)")
qmpe:CfgRpn(3, "72607 (>K:ROTOR_BRAKE)")
-- flip
qmpe:CfgRpn(5, "72101 (>K:ROTOR_BRAKE)")

---- RMP2
if g_qmpe_pmdg737_use_nav == 0 then
    -- inner
    qmpe:CfgRpn(28, "(>K:COM2_RADIO_FRACT_DEC)")
    qmpe:CfgRpn(29, "(>K:COM2_RADIO_FRACT_INC)")
    -- outer
    qmpe:CfgRpn(30, "(>K:COM2_RADIO_WHOLE_DEC)")
    qmpe:CfgRpn(31, "(>K:COM2_RADIO_WHOLE_INC)")
    -- flip

    qmpe:CfgRpn(33, "(>K:COM2_RADIO_SWAP)")
end
-- qmpe:CfgRpn(33, "(>K:COM2_STBY_RADIO_SWAP)")

-- ===========================================================
-- Read data

-- =====XPDR
qmpe:GetXpdr("(A:TRANSPONDER CODE:1, Number)")
-- Expert: FBW own logic
-- @ AUTO CLR = false
qmpe:FakeXpdrInit()
local b_xpdr_act = iDataRef:New("(A:TRANSPONDER CODE:1, Number)")
local function xpdr_update()
    if qmpe:FakeXpdrIsTimeOut() or b_xpdr_act:ChangedUpdate() then
        -- qmpe:FakeXpdrCopy()
        qmpe:FakeXpdrClear()
    end
    local xpdr_stby, stdr_num = qmpe:FakeXpdrGet()
    if stdr_num == 0 then
        qmpe:SetXpdr(qmpe:EncXpdr(b_xpdr_act:Get()))
    elseif stdr_num == 4 then
        local bc016 = qmpe:XpdrBc016(xpdr_stby)
        uluaWriteCmd(tostring(bc016) .. " (>K:XPNDR_SET)")
    else
        qmpe:SetXpdr(qmpe:EncXpdr(xpdr_stby, stdr_num))
    end
end
-- =====RMP
qmpe:GetR1vhf1("(L:switch_9041_73X,number)")
qmpe:GetR1vhf2("(L:switch_9042_73X,number)")
if g_qmpe_pmdg737_use_nav == 0 then
    qmpe:GetR2vhf1("(L:A32NX_RMP_R_SELECTED_MODE) 1 ==")
    qmpe:GetR2vhf2("(A:CIRCUIT AVIONICS ON,Bool)")
else
    qmpe:GetR2vhf1("(L:A32NX_RMP_R_SELECTED_MODE) 0 ==")
    qmpe:GetR2vhf2("(L:A32NX_RMP_R_SELECTED_MODE) 1 ==")
end
-- =====ACP
-- VHF1 TX LIGHT
qmpe:GetSVhf1("(L:switch_7341_73X)")
-- VHF1 CALL LIGHT
qmpe:GetCVhf1("(L:I_ASP_VHF_1_CALL)")
-- VHF1 RX LIGHT
qmpe:GetRVhf1("(L:switch_7391_73X)")
-- VHF2 TX LIGHT
qmpe:GetSVhf2("(L:switch_7351_73X)")
-- VHF2 CALL LIGHT
qmpe:GetCVhf2("(L:I_ASP_VHF_2_CALL)")
-- VHF2 RX LIGHT
qmpe:GetRVhf2("(L:switch_7401_73X)")
-- MECH TX LIGHT
qmpe:GetSMech("(L:switch_7361_73X)")
-- MECH CALL LIGHT
qmpe:GetCMech("(L:I_ASP_INT_CALL)")
-- MECH RX LIGHT
qmpe:GetRMech("(L:switch_7431_73X)")
-- ATT TX LIGHT
qmpe:GetSAtt("(L:switch_7371_73X)")
-- ATT CALL LIGHT
qmpe:GetCAtt("(L:I_ASP_CAB_CALL)")
-- ATT RX LIGHT
qmpe:GetRAtt("(L:switch_7441_73X)")
-- PX TX LIGHT
qmpe:GetSPa("(L:switch_7381_73X)")
-- PA RX LIGHT
qmpe:GetRPa("(L:switch_7451_73X)")

-- =====ECAM
qmpe:GetEEng("(L:A32NX_ECAM_SD_CURRENT_PAGE_INDEX) 20 ==")
qmpe:GetEBleed("(L:A32NX_ECAM_SD_CURRENT_PAGE_INDEX) 1 ==")
qmpe:GetEPress("(L:A32NX_ECAM_SD_CURRENT_PAGE_INDEX) 2 ==")
qmpe:GetEElec("(L:A32NX_ECAM_SD_CURRENT_PAGE_INDEX) 3 ==")
qmpe:GetEHyd("(L:A32NX_ECAM_SD_CURRENT_PAGE_INDEX) 4 ==")
qmpe:GetEFuel("(L:A32NX_ECAM_SD_CURRENT_PAGE_INDEX) 5 ==")

qmpe:GetEApu("(L:A32NX_ECAM_SD_CURRENT_PAGE_INDEX) 6 ==")
qmpe:GetECond("(L:A32NX_ECAM_SD_CURRENT_PAGE_INDEX) 7 ==")
qmpe:GetEDoor("(L:A32NX_ECAM_SD_CURRENT_PAGE_INDEX) 8 ==")
qmpe:GetEWheel("(L:A32NX_ECAM_SD_CURRENT_PAGE_INDEX) 9 ==")
qmpe:GetEFctl("(L:A32NX_ECAM_SD_CURRENT_PAGE_INDEX) 10 ==")

qmpe:GetEClr("(L:A32NX_ECAM_SD_CURRENT_PAGE_INDEX) 12 ==")
qmpe:GetESts("(L:A32NX_ECAM_SD_CURRENT_PAGE_INDEX) 11 ==")

-- =====MISC
qmpe:GetWarn("(L:switch_3471_73X, number)")
qmpe:GetCaut("(L:switch_3481_73X, number)")

qmpe:GetMsg("(L:A32NX_DCDU_ATC_MSG_WAITING, bool)")
qmpe:GetFail("(L:I_XPDR_FAIL)")
qmpe:GetLand("(L:I_MIP_AUTOLAND_CAPT)")

qmpe:GetTerr("(L:A32NX_EFIS_TERR_L_ACTIVE)")

if g_qmpe_pmdg737_use_nav == 0 then
    qmpe:GetLo('(L:switch_460_73X) 20 ==')
    qmpe:GetMed('(L:switch_460_73X) 30 ==')
    qmpe:GetMax('(L:switch_460_73X) 50 == (L:switch_460_73X) 0 == or')
else
    --AP RST A/T RST FMC RST
    qmpe:GetLo("pmdg/ng3/data/MAIN_annunAP_Amber[0]")
    qmpe:GetMed("pmdg/ng3/data/MAIN_annunAT_Amber[0]")
    qmpe:GetMax("pmdg/ng3/data/MAIN_annunFMC")
end
-- brightness
if MSFS_VERSION == 0 then
    qmpe:GetBkl("(A:LIGHT POTENTIOMETER:85, Percent)", 0.3) -- 0~100
else
    qmpe:GetBkl("(L:PED_PANEL_LIGHT_CONTROL, number)", 0.3) -- 0~300
end

qmpe:GetLock1("(A:GEAR LEFT POSITION, percent over 100)")
qmpe:GetLock2("(A:GEAR CENTER POSITION, percent over 100)")
qmpe:GetLock3("(A:GEAR RIGHT POSITION, percent over 100)")

qmpe:GetUnlock1("(L:MSATR_GEAR_LEFT_UNLK_LT)")
qmpe:GetUnlock2("(L:MSATR_GEAR_NOSE_UNLK_LT)")
qmpe:GetUnlock3("(L:MSATR_GEAR_RIGHT_UNLK_LT)")

-- =====RMP radio
qmpe:GetRmp1("(A:COM ACTIVE FREQUENCY:1,KHz)", "(A:COM STANDBY FREQUENCY:1, KHz) near")
if g_qmpe_pmdg737_use_nav ~= 0 then
    qmpe:GetRmp2("(A:NAV ACTIVE FREQUENCY:1,KHz)", "(A:NAV STANDBY FREQUENCY:1,KHz)")
else
    qmpe:GetRmp2("(A:COM ACTIVE FREQUENCY:2,KHz)", "(A:COM STANDBY FREQUENCY:2, KHz) near")
end

-- Expert: FBW own logic
-- RMP1 expert mode
local b_rmp1_power = iDataRef:New("(A:CIRCUIT AVIONICS ON,Bool)")
local b_rmp1_sel = iDataRef:New("(L:switch_9042_73X,number)")
local b_rmp2_sel = iDataRef:New("(L:A32NX_RMP_R_SELECTED_MODE)")
local v_nav1_a = iDataRef:New("(A:NAV ACTIVE FREQUENCY:1,KHz)")
local v_nav2_a = iDataRef:New("(A:NAV ACTIVE FREQUENCY:2,KHz)")
local v_nav1_s = iDataRef:New("(A:NAV STANDBY FREQUENCY:1,KHz)")
local v_nav2_s = iDataRef:New("(A:NAV STANDBY FREQUENCY:2,KHz)")

local v_com1_a = iDataRef:New("(A:COM ACTIVE FREQUENCY:1,KHz)")
local v_com2_a = iDataRef:New("(A:COM ACTIVE FREQUENCY:2,KHz)")
local v_com1_s = iDataRef:New("(A:COM STANDBY FREQUENCY:1,KHz)")
local v_com2_s = iDataRef:New("(A:COM STANDBY FREQUENCY:2,KHz)")
local function rmp1_update()
    -- power control
    local rmp1_pow = b_rmp1_power:Get()
    if rmp1_pow == 0 then
        qmpe:OffRmp1()
        return
    end

    if b_rmp1_sel:Get() > 0 then
        qmpe:SetRmp1(v_com2_a:Get(), v_com2_s:Get())
        b_rmp1_sel:Update()
    else
        if b_rmp1_sel:ChangedUpdate() then
            qmpe:FreshRmp1()
        end
        qmpe:SetRmp1()
    end
end
-- RMP2 expert mode
local b_rmp2_power = iDataRef:New("(A:CIRCUIT AVIONICS ON,Bool)")
local function rmp2_update()
    -- power control
    local rmp2_pow = b_rmp2_power:Get()
    if rmp2_pow == 0 then
        qmpe:OffRmp2()
        return
    end

    if g_qmpe_pmdg737_use_nav ~= 0 then
        if b_rmp2_sel:Get() == 1 then
            qmpe:SetRmp2(v_nav2_a:Get(), v_nav2_s:Get())
            b_rmp2_sel:Update()
        else
            if b_rmp2_sel:ChangedUpdate() then
                qmpe:FreshRmp2()
            end
            qmpe:SetRmp2()
        end
    else
        qmpe:SetRmp2()
    end
end

-- =====Annunciator test
local dr_test = iDataRef:New("(L:switch_346_73X,number)") -- 100: DIM 50: BRT 0: test mode
local qmcp737c_com_power = iDataRef:New("(A:AVIONICS MASTER SWITCH,Bool)")
local dr_power1 = iDataRef:New("(A:AVIONICS MASTER SWITCH,Bool)")
local dr_power = iDataRef:New("pmdg/ng3/data/MCP_indication_powered") -- 1 batt 2 AC bus
--#region

local dr_ann_ap_amber = iDataRef:New("pmdg/ng3/data/MAIN_annunAP_Amber[0]")
local dr_ann_at_amber = iDataRef:New("pmdg/ng3/data/MAIN_annunAT_Amber[0]")
local dr_ann_ap = iDataRef:New("pmdg/ng3/data/MAIN_annunAP[0]")
local dr_ann_at = iDataRef:New("pmdg/ng3/data/MAIN_annunAT[0]")
function Qmpe_pmdg_737_loop()
    -- expert code: cold and dark
    local b_power = dr_power:Get()
    local b_power1 = dr_power1:Get()
    if b_power == 0 then
        qmpe:Off()
        return
    else
        qmpe:FreshBkl()
    end
    -- expert code: test mode
    local b_test = dr_test:Get()
    if dr_test:ChangedUpdate() then
        if b_test == 0 then
            qmpe:SetBklMode(1)
            return
        else
            qmpe:SetBklMode(0)
            qmpe:SetBklCtrl(0)
            uluaSet(idr_qmpe_hid_invalid, -1)
        end
    end
    -- DATA

    -- RMP1/RMP2
    rmp1_update()
    rmp2_update()
    -- XPDR
    xpdr_update()
    -- LEDS
    qmpe:SetRmp()
    qmpe:SetAcp()
    qmpe:SetEcam()
    if uluaFind("pmdg/ng3/data/MAIN_annunFMC") == nil then
        qmpe:SetMisc()
    else
        qmpe:SetWarn()
        qmpe:SetCaut()

        qmpe:SetLock1()
        qmpe:SetLock2()
        qmpe:SetLock3()
        qmpe:SetUnlock1()
        qmpe:SetUnlock2()
        qmpe:SetUnlock3()

        qmpe:SetMsg()
        qmpe:SetFail()
        if g_qmpe_pmdg737_use_nav == 0 then
            qmpe:SetLo()
            qmpe:SetMed()
        else
            uluaSet(idr_qmpe_hid_misc_lo, ilua_bool_ternary(dr_ann_ap:Get() + dr_ann_ap_amber:Get(), 0))
            uluaSet(idr_qmpe_hid_misc_med, ilua_bool_ternary(dr_ann_at:Get() + dr_ann_at_amber:Get(), 0))
        end
        qmpe:SetMax()
        qmpe:SetTerr()
        qmpe:SetLand()

        -- brightness
        qmpe:SetBkl()
    end
end

GlobalFrameLoopManager:add(Qmpe_pmdg_737_loop)
