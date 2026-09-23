-- *****************************************************************
-- created by Wei Shuai <cpuwolf@gmail.com> 2024-05-16
-- *****************************************************************
if ilua_require_inibuild_a350() then return end

-- Do not remove below lines: hardware detection
local qmpe = com.sim.qm.Qmpe.Open()
if not qmpe then return end
-- Do not remove above lines: hardware detection

uluaLog("QMPE for Inibuild A350")

-- A350
-- 0:ELEC AC  1:ELEC DC
local iniA330_ecam_elec_acdc = 0

-- ===========================================================
-- button binding

-- RMP 
-- Power On/Off
qmpe:CfgRpn(4, "(L:INI_RMP_CPT_OFF) 100 * (>B:AIRLINER_RMP_BRT_1_Set)")
qmpe:CfgRpn(32, "(L:INI_RMP_CPT_OFF) 100 * (>B:AIRLINER_RMP_BRT_1_Set)")
-- VHF1
qmpe:CfgRpn(7, "1 (>L:INI_SELECTED_RADIO_CPT)")
-- VHF2
-- qmpe:CfgRpn(6, "2 (>L:INI_SELECTED_RADIO_CPT)")

-- VHF1 RX
qmpe:CfgTog(10, "B:AIRLINER_RMP_VHF1_VOL_1_Button", "(L:INI_RMP1_1_RECEIVE_SEL)")
-- VHF2 RX
qmpe:CfgTog(11, "B:AIRLINER_RMP_VHF2_VOL_1_Button", "(L:INI_RMP1_2_RECEIVE_SEL)")
-- INT RX
qmpe:CfgTog(12, "B:AIRLINER_RMP_INT_VOL_1_Button", "(L:INI_RMP1_8_RECEIVE_SEL)")
-- CAB RX
qmpe:CfgTog(13, "B:AIRLINER_RMP_CAB_VOL_1_Button", "(L:INI_RMP1_11_RECEIVE_SEL)")
-- PA RX
qmpe:CfgTog(14, "B:AIRLINER_RMP_PA_VOL_1_Button", "(L:INI_RMP1_9_RECEIVE_SEL)")
-- VHF1 TX
qmpe:CfgRpn(15, "1 (>L:INI_RMP1_TRANSMIT_CHANNEL)")
-- VHF2 TX
qmpe:CfgRpn(24, "2 (>L:INI_RMP1_TRANSMIT_CHANNEL)")
-- INT TX
qmpe:CfgRpn(25, "8 (>L:INI_RMP1_TRANSMIT_CHANNEL)")
-- CAB TX
qmpe:CfgRpn(26, "11 (>L:INI_RMP1_TRANSMIT_CHANNEL)")
-- PA TX, Airbus PA send is not latched
if MSFS_VERSION == 0 then
    qmpe:CfgVal(27, "B:AIRLINER_RMP_PA_CALL_1", 2, 1)
else
    qmpe:CfgRpn(27, "2 (>B:AIRLINER_RMP_PA_CALL_1_PUSH)", "1 (>B:AIRLINER_RMP_PA_CALL_1_RELEASE)")
end

-- VHF1 RX volume
qmpe:CfgFc(16, 'uluaSet(uluaFind("B:AIRLINER_RMP_VHF1_VOL_1"), uluaGet(uluaFind("(L:INI_RMP1_1_VOLUME)"))-5)')
qmpe:CfgFc(17, 'uluaSet(uluaFind("B:AIRLINER_RMP_VHF1_VOL_1"), uluaGet(uluaFind("(L:INI_RMP1_1_VOLUME)"))+5)')

-- VHF2 RX volume
qmpe:CfgFc(18, 'uluaSet(uluaFind("B:AIRLINER_RMP_VHF2_VOL_1"), uluaGet(uluaFind("(L:INI_RMP1_2_VOLUME)"))-5)')
qmpe:CfgFc(19, 'uluaSet(uluaFind("B:AIRLINER_RMP_VHF2_VOL_1"), uluaGet(uluaFind("(L:INI_RMP1_2_VOLUME)"))+5)')

-- INT RX volume
qmpe:CfgFc(20, 'uluaSet(uluaFind("B:AIRLINER_RMP_INT_VOL_1"), uluaGet(uluaFind("(L:INI_RMP1_8_VOLUME)"))-5)')
qmpe:CfgFc(21, 'uluaSet(uluaFind("B:AIRLINER_RMP_INT_VOL_1"), uluaGet(uluaFind("(L:INI_RMP1_8_VOLUME)"))+5)')

-- CAB RX volume
qmpe:CfgFc(22, 'uluaSet(uluaFind("B:AIRLINER_RMP_CAB_VOL_1"), uluaGet(uluaFind("(L:INI_RMP1_11_VOLUME)"))-5)')
qmpe:CfgFc(23, 'uluaSet(uluaFind("B:AIRLINER_RMP_CAB_VOL_1"), uluaGet(uluaFind("(L:INI_RMP1_11_VOLUME)"))+5)')

-- PA volume
qmpe:CfgFc(8, 'uluaSet(uluaFind("B:AIRLINER_RMP_PA_VOL_1"), uluaGet(uluaFind("(L:INI_RMP1_9_VOLUME)"))-5)')
qmpe:CfgFc(9, 'uluaSet(uluaFind("B:AIRLINER_RMP_PA_VOL_1"), uluaGet(uluaFind("(L:INI_RMP1_9_VOLUME)"))+5)')

-- RMP2
-- VHF1
-- qmpe:CfgRpn(34, "1 (>L:INI_SELECTED_RADIO_FO)")
-- VHF2
qmpe:CfgRpn(35, "2 (>L:INI_SELECTED_RADIO_FO)")

-- weather SYS 1/OFF/2
qmpe:CfgRpn(36, "1 (>L:INI_WXR_SYS)")
-- 80 is middle key
qmpe:CfgRpn(80, "-1 (>L:INI_WXR_SYS)")
qmpe:CfgRpn(37, "2 (>L:INI_WXR_SYS)")

-- weather PWS off/auto
qmpe:CfgRpn(38, "0 (>L:INI_WXR_ON)", "1 (>L:INI_WXR_ON)")
-- 39 is right key
qmpe:CfgRpn(39, "1 (>L:INI_WXR_ON)")

-- XPDR STBY/TA/TARA
qmpe:CfgRpn(40, "0 (>L:INI_tcas_mode_pedestal)")
qmpe:CfgRpn(41, "1 (>L:INI_tcas_mode_pedestal)")
qmpe:CfgRpn(81, "2 (>L:INI_tcas_mode_pedestal)")

-- XPDR STBY/AUTO/ON
qmpe:CfgRpn(42, "0 (>L:INI_TCAS_STBY_STATE)")
qmpe:CfgRpn(43, "1 (>L:INI_TCAS_STBY_STATE)")
qmpe:CfgRpn(82, "2 (>L:INI_TCAS_STBY_STATE)")

-- CAUT
qmpe:CfgRpn(44, "1 (>L:INI_MASTER_CAUTION_COMMAND)", "0 (>L:INI_MASTER_CAUTION_COMMAND)")
-- WARN
qmpe:CfgRpn(79, "1 (>L:INI_MASTER_WARNING_COMMAND)", "0 (>L:INI_MASTER_WARNING_COMMAND)")

-- INTEG LT Push
qmpe:CfgRpn(45, "1 (>L:A32NX_DCDU_ATC_MSG_ACK)")

-- INTEG LT
qmpe:CfgRpn(46, "(L:INI_CKPT_LT_INTEG) 5 - 0 max (>L:INI_CKPT_LT_INTEG)")
qmpe:CfgRpn(47, "(L:INI_CKPT_LT_INTEG) 5 + 100 min (>L:INI_CKPT_LT_INTEG)")

-- ECAM
-- TO CONFIG
if MSFS_VERSION == 0 then
    qmpe:CfgVal(78, "B:AIRLINER_ECAM_TO_CONFIG", 2, 1)
else
    qmpe:CfgRpn(78, "2 (>B:AIRLINER_ECAM_TO_CONFIG_PUSH)", "1 (>B:AIRLINER_ECAM_TO_CONFIG_RELEASE)")
end

qmpe:CfgRpn(48, "1 (>L:PUSH_ECAM_ENG)")
qmpe:CfgRpn(49, "1 (>L:PUSH_ECAM_BLEED)")
qmpe:CfgRpn(50, "1 (>L:PUSH_ECAM_PRESS)")

function flip_ecam_ac_dc()
    iniA330_ecam_elec_acdc = 1 - iniA330_ecam_elec_acdc
    if iniA330_ecam_elec_acdc == 0 then
        qmpe:CfgRpn(51, "1 (>L:PUSH_ECAM_ELEC_AC)")
    else
        qmpe:CfgRpn(51, "1 (>L:PUSH_ECAM_ELEC_DC)")
    end
end

flip_ecam_ac_dc()
qmpe:CfgFc(51, "flip_ecam_ac_dc()")

qmpe:CfgRpn(52, "1 (>L:PUSH_ECAM_HYD)")
qmpe:CfgRpn(53, "1 (>L:PUSH_ECAM_FUEL)")

qmpe:CfgRpn(54, "1 (>L:PUSH_ECAM_APU)", "1 (>L:INI_PUSH_ECAM_APU_RELEASE)")
qmpe:CfgRpn(55, "1 (>L:PUSH_ECAM_COND)")
qmpe:CfgRpn(56, "1 (>L:PUSH_ECAM_DOOR)")
qmpe:CfgRpn(57, "1 (>L:PUSH_ECAM_WHEEL)")
qmpe:CfgRpn(58, "1 (>L:PUSH_ECAM_FCTL)")

qmpe:CfgRpn(59, "1 (>L:PUSH_ECAM_ALL)", "0 (>L:PUSH_ECAM_ALL)")

if MSFS_VERSION == 0 then
    qmpe:CfgRpn(60, "1 (>L:PUSH_ECAM_CLR)")
else
    qmpe:CfgRpn(60, "1 (>B:AIRLINER_ECAM_CLEAR_LEFT_Push)", "1 (>B:AIRLINER_ECAM_CLEAR_LEFT_Release)")
end

qmpe:CfgRpn(61, "1 (>L:PUSH_ECAM_STS)", "0 (>L:PUSH_ECAM_STS)")
qmpe:CfgRpn(62, "1 (>L:PUSH_ECAM_RCL)", "0 (>L:PUSH_ECAM_RCL)")

-- Terrain
qmpe:CfgRpn(63, "(L:INI_TERR_ON_CAPT) ! (>L:INI_TERR_ON_CAPT)")

-- XDRD IDENT
-- qmpe:CfgRpn(64, "(>H:A320_Neo_ATC_BTN_IDENT)")
qmpe:CfgRpn(64, "(>K:XPNDR_IDENT_ON)")

-- Chrone
qmpe:CfgRpn(65, "1 (>L:INI_CPT_CHRONO_BUTTON)")

-- XPRD ATC Keypad
qmpe:CfgRpn(66, "1 (>L:INI_TCAS_1_COMMAND)")
qmpe:CfgRpn(67, "1 (>L:INI_TCAS_2_COMMAND)")
qmpe:CfgRpn(68, "1 (>L:INI_TCAS_3_COMMAND)")
qmpe:CfgRpn(69, "1 (>L:INI_TCAS_4_COMMAND)")
qmpe:CfgRpn(70, "1 (>L:INI_TCAS_5_COMMAND)")
qmpe:CfgRpn(71, "1 (>L:INI_TCAS_6_COMMAND)")
qmpe:CfgRpn(72, "1 (>L:INI_TCAS_7_COMMAND)")
qmpe:CfgRpn(73, "1 (>L:INI_TCAS_0_COMMAND)")
qmpe:CfgRpn(74, "1 (>L:INI_TCAS_CLR_COMMAND)")
-- autobrake
qmpe:CfgRpn(75,
    "(L:INI_AUTOBRAKE_LEVEL, number) 1 != if{ 1 (>L:INI_AUTOBRAKE_LEVEL, number) } els{ 0 (>L:INI_AUTOBRAKE_LEVEL, number) }")
qmpe:CfgRpn(76,
    "(L:INI_AUTOBRAKE_LEVEL, number) 2 != if{ 2 (>L:INI_AUTOBRAKE_LEVEL, number) } els{ 0 (>L:INI_AUTOBRAKE_LEVEL, number) }")

qmpe:CfgVal(77, "B:AIRLINER_LDG_AUTO_BRK", 1)

---- RMP1

-- flip
qmpe:CfgRpn(5, "1 (>L:INI_CPT_VHF_TRANSFER_SWITCH_COMMAND)")

---- RMP2
-- flip

qmpe:CfgRpn(33, "1 (>L:INI_FO_VHF_TRANSFER_SWITCH_COMMAND)")
-- qmpe:CfgRpn(33, "(>K:COM2_STBY_RADIO_SWAP)")

-- ===========================================================
-- Read data

-- =====XPDR
qmpe:GetXpdr("(A:TRANSPONDER CODE:1, Number)")
-- Expert: FBW own logic
-- @ AUTO CLR = false
-- @ TIMEOUT = 2s
qmpe:FakeXpdrInit(false, 2)
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
qmpe:GetR1vhf1("(L:INI_SELECTED_RADIO_CPT) 1 ==")
qmpe:GetR1vhf2("(L:INI_SELECTED_RADIO_CPT) 2 ==")
qmpe:GetR2vhf1("(L:INI_SELECTED_RADIO_FO) 1 ==")
qmpe:GetR2vhf2("(L:INI_SELECTED_RADIO_FO) 2 ==")
-- =====ACP
-- VHF1 TX LIGHT
qmpe:GetSVhf1("(L:INI_RMP1_TRANSMIT_CHANNEL) 1 ==")
-- VHF1 CALL LIGHT
qmpe:GetCVhf1("(L:I_ASP_VHF_1_CALL)")
-- VHF1 RX LIGHT
qmpe:GetRVhf1("(L:INI_RMP1_1_RECEIVE_SEL) 1 ==")
-- VHF2 TX LIGHT
qmpe:GetSVhf2("(L:INI_RMP1_TRANSMIT_CHANNEL) 2 ==")
-- VHF2 CALL LIGHT
qmpe:GetCVhf2("(L:I_ASP_VHF_2_CALL)")
-- VHF2 RX LIGHT
qmpe:GetRVhf2("(L:INI_RMP1_2_RECEIVE_SEL)")
-- MECH TX LIGHT
qmpe:GetSMech("(L:INI_RMP1_TRANSMIT_CHANNEL) 8 ==")
-- MECH CALL LIGHT
qmpe:GetCMech("(L:I_ASP_INT_CALL)")
-- MECH RX LIGHT
qmpe:GetRMech("(L:INI_RMP1_8_RECEIVE_SEL)")
-- ATT TX LIGHT
qmpe:GetSAtt("(L:INI_RMP1_TRANSMIT_CHANNEL) 11 ==")
-- ATT CALL LIGHT
qmpe:GetCAtt("(L:I_ASP_CAB_CALL)")
-- ATT RX LIGHT
qmpe:GetRAtt("(L:INI_RMP1_11_RECEIVE_SEL)")
-- PA TX LIGHT
qmpe:GetSPa("(L:INI_RMP1_PA_CHANNEL)")

-- PA RX LIGHT
qmpe:GetRPa("(L:INI_RMP1_9_RECEIVE_SEL)")

-- =====ECAM
qmpe:GetEEng("(L:INI_ECAM_ACTIVE_PAGE) 1 ==")
qmpe:GetEBleed("(L:INI_ECAM_ACTIVE_PAGE) 5 ==")
qmpe:GetEPress("(L:INI_ECAM_ACTIVE_PAGE) 7 ==")
-- AC or DC
qmpe:GetEElec("(L:INI_ECAM_ACTIVE_PAGE) 3 == (L:INI_ECAM_ACTIVE_PAGE) 4 == ||")

qmpe:GetEHyd("(L:INI_ECAM_ACTIVE_PAGE) 2 ==")
qmpe:GetEFuel("(L:INI_ECAM_ACTIVE_PAGE) 8 ==")

qmpe:GetEApu("(L:INI_ECAM_ACTIVE_PAGE) 9 ==")
qmpe:GetECond("(L:INI_ECAM_ACTIVE_PAGE) 6 ==")
qmpe:GetEDoor("(L:INI_ECAM_ACTIVE_PAGE) 11 ==")
qmpe:GetEWheel("(L:INI_ECAM_ACTIVE_PAGE) 12 ==")
qmpe:GetEFctl("(L:INI_ECAM_ACTIVE_PAGE) 10 ==")

qmpe:GetEClr("(L:INI_ECAM_CLR_LIGHT, Bool)")
qmpe:GetESts("(L:INI_ECAM_ACTIVE_PAGE) 14 ==")

-- =====MISC
qmpe:GetWarn("(L:INI_MASTER_WARNING_CAPT_BOTTOM)")
qmpe:GetCaut("(L:INI_MASTER_CAUTION_CAPT_BOTTOM)")

qmpe:GetMsg("(L:INI_ATC_MSG_LIGHT, bool)")
qmpe:GetFail("(L:I_XPDR_FAIL)")
qmpe:GetLand("(L:I_MIP_AUTOLAND_CAPT)")

qmpe:GetTerr("(L:INI_TERR_ON_CAPT)")

qmpe:GetLo("(L:INI_AUTOBRAKE_LEVEL) 1 ==")
qmpe:GetMed("(L:INI_AUTOBRAKE_LEVEL) 2 ==")
qmpe:GetMax("(L:INI_AUTOBRAKE_LEVEL) 3 ==")

qmpe:GetBkl("(L:INI_CKPT_LT_INTEG, Percent)", 0.3) -- 0~100

qmpe:GetLock1("(A:GEAR POSITION:1, percent) 100 ==")
qmpe:GetLock2("(A:GEAR POSITION:0, percent) 100 ==")
qmpe:GetLock3("(A:GEAR POSITION:2, percent) 100 ==")

qmpe:GetUnlock1("(L:INI_GEAR2_UNLK_LIGHT)")
qmpe:GetUnlock2("(L:INI_GEAR1_UNLK_LIGHT)")
qmpe:GetUnlock3("(L:INI_GEAR3_UNLK_LIGHT)")

-- =====RMP radio
qmpe:GetRmp1("(A:COM ACTIVE FREQUENCY:1,KHz)", "(A:COM STANDBY FREQUENCY:1, KHz) near")
qmpe:GetRmp2("(A:COM ACTIVE FREQUENCY:2,KHz)", "(A:COM STANDBY FREQUENCY:2, KHz) near")

-- Expert: ini own logic
-- RMP1 expert mode
local dr_rmp_bus_power = iDataRef:New("(L:INI_ELEC_AC_ESS_SHED_BUS_IS_POWERED, number)", -1) -- 0: OFF 1: ON

local b_rmp1_power = iDataRef:New("(L:INI_RMP_CPT_OFF) 1 -")

local b_rmp1_sel = iDataRef:New("(L:INI_SELECTED_RADIO_CPT)")
local v_com1_a = iDataRef:New("(L:INI_COM1_FREQUENCY)")
local v_com2_a = iDataRef:New("(L:INI_COM2_FREQUENCY)")
local v_com1_s = iDataRef:New("(L:INI_COM1_STBY_FREQUENCY)")
local v_com2_s = iDataRef:New("(L:INI_COM2_STBY_FREQUENCY)")

local b_rmp1_vor_sel = iDataRef:New("(L:INI_COMM_VOR_CPT)")
local d_rmp1_vor_a = iDataRef:New("(L:INI_VOR1_FREQUENCY)")
local d_rmp1_vor_s = iDataRef:New("(L:INI_VOR1_STBY_FREQUENCY)")

local b_rmp1_ils_sel = iDataRef:New("(L:INI_COMM_LS_CPT)")
local d_rmp1_ils_a = iDataRef:New("(L:INI_ILS_FREQUENCY)")
local d_rmp1_ils_s = iDataRef:New("(L:INI_ILS_STBY_FREQUENCY)")

local b_rmp1_adf_sel = iDataRef:New("(L:INI_COMM_ADF_CPT)")
local d_rmp1_adf_a = iDataRef:New("(L:INI_ADF1_FREQUENCY)")
local d_rmp1_adf_s = iDataRef:New("(L:INI_ADF1_STBY_FREQUENCY)")

-- INI_COMM_VOR_CPT
-- INI_COMM_LS_CPT
-- INI_COMM_ADF_CPT

-- INI_VOR1_FREQUENCY
-- INI_ILS_FREQUENCY
-- INI_ADF1_FREQUENCY

-- INI_VOR1_STBY_FREQUENCY
-- INI_ILS_STBY_FREQUENCY
-- INI_ADF1_STBY_FREQUENCY
local dr_vhf1_act = iDataRef:New("(A:COM ACTIVE FREQUENCY:1,KHz)")
local dr_vhf1_stdby = iDataRef:New("(A:COM STANDBY FREQUENCY:1, KHz) near")

local function GenDigiRmpObject(idx)
    local key_idx = tostring(idx)
    local key_str = "B:AIRLINER_RMP_" .. key_idx .. "_1"
    return {
        idx = idx,
        str = key_str,
        event = uluaFind(key_str)
    }
end
local function GenDigiRmpKeyArray()
    local key_array = {}
    for i = 0, 9 do
        table.insert(key_array, GenDigiRmpObject(i))
    end
    return key_array
end
local evt_vhf1_keys = GenDigiRmpKeyArray()
local evt_vhf1_vhf_key = uluaFind("B:AIRLINER_RMP_VHF_1")
local evt_vhf1_ls1_key = uluaFind("B:AIRLINER_RMP_LSK1_1")
local evt_vhf1_ls2_key = uluaFind("B:AIRLINER_RMP_LSK2_1")
-- -1: VHF Key Press
-- -2: Right LINE 1 Key Press
-- -3: Right LINE 2 Key Press
local function DigiRmpKeyPress(key)
    if key >= 0 then
        local key_str = tostring(key)
        uluaLog("DigiRmpKeyPress: " .. key_str)
        if MSFS_VERSION == 1 then
            uluaWriteCmd("1 (>B:AIRLINER_RMP_" .. key_str .. "_1_TOGGLE)")
        else
            uluaSet(evt_vhf1_keys[key + 1].event, 1)
        end
    elseif key == -1 then
        uluaLog("DigiRmpKeyPress: VHF Key Press")
        if MSFS_VERSION == 1 then
            uluaWriteCmd("1 (>B:AIRLINER_RMP_VHF_1_TOGGLE)")
        else
            uluaSet(evt_vhf1_vhf_key, 1)
        end
    elseif key == -2 then
        uluaLog("DigiRmpKeyPress: Right LINE 1 Key Press")
        if MSFS_VERSION == 1 then
            uluaWriteCmd("1 (>B:AIRLINER_RMP_LSK1_1_TOGGLE)")
        else
            uluaSet(evt_vhf1_ls1_key, 1)
        end
    elseif key == -3 then
        uluaLog("DigiRmpKeyPress: Right LINE 2 Key Press")
        if MSFS_VERSION == 1 then
            uluaWriteCmd("1 (>B:AIRLINER_RMP_LSK2_1_TOGGLE)")
        else
            uluaSet(evt_vhf1_ls2_key, 1)
        end
    end
end

qmpe:DigiRmpVhf1StbyInit(dr_vhf1_stdby:Get(), DigiRmpKeyPress)

local function rmp1_update()
    -- power control
    local rmp1_pow = b_rmp1_power:Get()
    if rmp1_pow == 0 or dr_rmp_bus_power:Get() == 0 then
        qmpe:OffRmp1()
        return
    end
    -- flip frequency
    if dr_vhf1_stdby:ChangedUpdate() then
        qmpe:DigiRmpVhf1StbySet(dr_vhf1_stdby:Get())
    end

    -- use my internal standby frequency
    local vhf_val = qmpe:DigiRmpVhf1StbyGet()
    qmpe:SetRmp1(dr_vhf1_act:Get(), vhf_val)

    -- timeout write out to aircraft
    if qmpe:DigiRmpVhf1StbyIsTimeOut() then
        uluaLog("timeout1")
        qmpe:DigiRmpVhf1StbyTimeOutHandle()
    end

end
-- RMP2 expert mode

local dr_vhf2_act = iDataRef:New("(A:COM ACTIVE FREQUENCY:2,KHz)")
local dr_vhf2_stdby = iDataRef:New("(A:COM STANDBY FREQUENCY:2, KHz) near")

local b_rmp2_power = iDataRef:New("(L:INI_RMP_CPT_OFF) 1 -")
local b_rmp2_sel = iDataRef:New("(L:INI_SELECTED_RADIO_FO)")

qmpe:DigiRmpVhf2StbyInit(dr_vhf2_stdby:Get(), DigiRmpKeyPress)

local function rmp2_update()
    -- power control
    local rmp2_pow = b_rmp2_power:Get()
    if rmp2_pow == 0 or dr_rmp_bus_power:Get() == 0 then
        qmpe:OffRmp2()
        return
    end

    -- flip frequency
    if dr_vhf2_stdby:ChangedUpdate() then
        qmpe:DigiRmpVhf2StbySet(dr_vhf2_stdby:Get())
    end

    -- use my internal standby frequency
    local vhf_val = qmpe:DigiRmpVhf2StbyGet()
    qmpe:SetRmp2(dr_vhf2_act:Get(), vhf_val)

    -- timeout write out to aircraft
    if qmpe:DigiRmpVhf2StbyIsTimeOut() then
        uluaLog("timeout2")
        qmpe:DigiRmpVhf2StbyTimeOutHandle()
    end

end

-- =====Annunciator test
local dr_test = iDataRef:New("(L:INI_ANNLT_SWITCH, number)") -- 0: TEST 1:BRT: 2: DIM
local dr_power = iDataRef:New("(L:INI_ELEC_AC_ESS_SHED_BUS_IS_POWERED, number)") -- 0: OFF 1: ON

GlobalFrameLoopManager:add(function()
    -- expert code: cold and dark
    local b_power = dr_power:Get()
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
        elseif b_test == 2 then
            -- DIM
            qmpe:SetBklCtrl(1)
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
    qmpe:SetMisc()
end)
