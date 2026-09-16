-- *****************************************************************
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-09-16
-- *****************************************************************
if ilua_require_inibuild_a380() then return end

-- Do not remove below lines: hardware detection
local qmovha = com.sim.qm.Qmovha.Open()
if not qmovha then return end
-- Do not remove above lines: hardware detection

uluaLog("QMOVH-A of Inibuild A380")

-- ===========================================================
-- buttons binding
-- POS/Strobe
qmovha:CfgVal(0, "B:AIRLINER_LIGHTS_EXT_STROBE", 0, nil)
qmovha:CfgVal(41, "B:AIRLINER_LIGHTS_EXT_STROBE", 1, nil)
qmovha:CfgVal(1, "B:AIRLINER_LIGHTS_EXT_STROBE", 2, nil)

-- BEACON lights
qmovha:CfgVal(2, "B:AIRLINER_LIGHTS_EXT_BEACON", 0, 1)

-- Wing lights
qmovha:CfgVal(3, "B:AIRLINER_LIGHTS_EXT_WING", 0, 1)

-- NAV&Logo lights
qmovha:CfgVal(4, "B:AIRLINER_LIGHTS_EXT_LOGO", 0, nil)
qmovha:CfgVal(42, "B:AIRLINER_LIGHTS_EXT_LOGO", 1, nil)
qmovha:CfgVal(5, "B:AIRLINER_LIGHTS_EXT_LOGO", 2, nil)

-- Nose lights
qmovha:CfgVal(6, "B:AIRLINER_LIGHTS_EXT_NOSE", 0, nil)
qmovha:CfgVal(45, "B:AIRLINER_LIGHTS_EXT_NOSE", 1, nil)
qmovha:CfgVal(7, "B:AIRLINER_LIGHTS_EXT_NOSE", 2, nil)

-- R Landing lights
qmovha:CfgVal(8, "B:AIRLINER_LIGHTS_EXT_LANDING", 0, nil)
qmovha:CfgVal(44, "B:AIRLINER_LIGHTS_EXT_LANDING", 1, nil)
qmovha:CfgVal(9, "B:AIRLINER_LIGHTS_EXT_LANDING", 1, nil)
-- L Landing lights
qmovha:CfgRpn(10, "0 (>B:AIRLINER_LIGHTS_EXT_LANDING_Set)")
qmovha:CfgRpn(43, "1 (>B:AIRLINER_LIGHTS_EXT_LANDING_Set)")
qmovha:CfgRpn(11, "1 (>B:AIRLINER_LIGHTS_EXT_LANDING_Set)")

-- Runway Turn Off lights
qmovha:CfgVal(12, "B:AIRLINER_LIGHTS_EXT_TURNOFF", 0, 1)

-- OVHD INTEG LT KNOBS  BRT <-> OFF
qmovha:CfgRpn(17, "1 (>B:AIRLINER_PED_INTEG_LT_Dec)")
qmovha:CfgRpn(16, "1 (>B:AIRLINER_PED_INTEG_LT_Inc)")

-- SEAT BELTS
qmovha:CfgVal(13, "B:AIRLINER_SIGNS_SEAT_BELTS", 0, 2)
-- NO SMOKING
qmovha:CfgVal(14, "B:AIRLINER_SIGNS_NO_MOBILE", 0, nil)
qmovha:CfgVal(48, "B:AIRLINER_SIGNS_NO_MOBILE", 1, nil)
qmovha:CfgVal(15, "B:AIRLINER_SIGNS_NO_MOBILE", 2, nil)

-- DOME
qmovha:CfgRpn(18, "0 (>B:AIRLINER_LIGHTS_INT_STORM_Set)")
qmovha:CfgRpn(46, "1 (>B:AIRLINER_LIGHTS_INT_STORM_Set)")
qmovha:CfgRpn(19, "1 (>B:AIRLINER_LIGHTS_INT_STORM_Set)")

-- ANN LT
qmovha:CfgVal(20, "B:AIRLINER_LIGHTS_INT_ANN_LT", 0, nil)
qmovha:CfgVal(47, "B:AIRLINER_LIGHTS_INT_ANN_LT", 1, nil)
qmovha:CfgVal(21, "B:AIRLINER_LIGHTS_INT_ANN_LT", 2, nil)

-- EMER EXIT LT
qmovha:CfgVal(22, "B:AIRLINER_SIGNS_EMER_EXIT", 0, nil)
qmovha:CfgVal(49, "B:AIRLINER_SIGNS_EMER_EXIT", 1, nil)
qmovha:CfgVal(23, "B:AIRLINER_SIGNS_EMER_EXIT", 2, nil)

-- APU
---- start
qmovha:CfgRpn(30, "(L:INI_APU_START_BUTTON) ! (>L:INI_APU_START_BUTTON)")
---- master
qmovha:CfgRpn(31, "(L:INI_APU_MASTER_SWITCH) ! (>L:INI_APU_MASTER_SWITCH)")

-- ANTI ICE
---- ENG2
qmovha:CfgRpn(32,
    "(L:INI_ENG_ANTI_ICE4_STATE) ! (>L:INI_ENG_ANTI_ICE4_STATE) (L:INI_ENG_ANTI_ICE4_STATE) (>L:INI_ENG_ANTI_ICE3_STATE)")
---- ENG1
qmovha:CfgRpn(33,
    "(L:INI_ENG_ANTI_ICE1_STATE) ! (>L:INI_ENG_ANTI_ICE1_STATE) (L:INI_ENG_ANTI_ICE1_STATE) (>L:INI_ENG_ANTI_ICE2_STATE)")
---- WING
qmovha:CfgRpn(37, "(L:INI_WING_ANTI_ICE1_STATE) ! (>L:INI_WING_ANTI_ICE1_STATE)")

-- AIR COND
---- PACK1
qmovha:CfgRpn(34, "(L:INI_AIR_PACK1_BUTTON) ! (>L:INI_AIR_PACK1_BUTTON)")
---- APU BLEED
qmovha:CfgRpn(35, "(L:INI_AIR_BLEED_APU) ! (>L:INI_AIR_BLEED_APU)")
---- PACK2
qmovha:CfgRpn(36, "(L:INI_AIR_PACK2_BUTTON) ! (>L:INI_AIR_PACK2_BUTTON)")

---- XBLEED
qmovha:CfgRpn(27, "0 (>B:AIRLINER_XBLEED_0)")
qmovha:CfgRpn(28, "1 (>B:AIRLINER_XBLEED_1)")
qmovha:CfgRpn(29, "2 (>B:AIRLINER_XBLEED_2)")

-- WIPER
if MSFS_VERSION == 0 then
    qmovha:CfgVal(24, "B:AIRLINER_CPT_WIPER_SWITCH", 0)
    qmovha:CfgVal(25, "B:AIRLINER_CPT_WIPER_SWITCH", 1)
    qmovha:CfgVal(26, "B:AIRLINER_CPT_WIPER_SWITCH", 2)
else
    qmovha:CfgRpn(24, "0 (>B:AIRLINER_WIPER_LEFT_Set) 0 (>B:AIRLINER_WIPER_RIGHT_Set)")
    qmovha:CfgRpn(25, "1 (>B:AIRLINER_WIPER_LEFT_Set) 1 (>B:AIRLINER_WIPER_RIGHT_Set)")
    qmovha:CfgRpn(26, "2 (>B:AIRLINER_WIPER_LEFT_Set) 2 (>B:AIRLINER_WIPER_RIGHT_Set)")
end
-- OXYGEN CREW SUPPLY
qmovha:CfgRpn(38, "(L:INI_CREW_SUPPLY) ! (>L:INI_CREW_SUPPLY)")

-- CALLS ALL
qmovha:CfgRpn(40, "1 (>L:INI_CALLS_ALL)", "0 (>L:INI_CALLS_ALL)")
qmovha:CfgVal(40, "B:AIRLINER_CALLS_ALL", 2, 0)

-- GPWS
---- TERR
qmovha:CfgRpn(50, "(L:INI_GPWS_TERR_STATE) ! (>L:INI_GPWS_TERR_STATE)")
---- SYS
qmovha:CfgRpn(51, "(L:INI_GPWS_SYS_STATE) ! (>L:INI_GPWS_SYS_STATE)")
---- FLAPS3
qmovha:CfgRpn(52, "(L:INI_GPWS_FLAP_MODE) ! (>L:INI_GPWS_FLAP_MODE)")

-- GND CTL CVR
qmovha:CfgRpn(53, "(L:INI_GND_CTL) ! (>L:INI_GND_CTL)")

-- ADIRS 2,3,1
qmovha:CfgRpn(55, "(L:INI_ADR2_BUTTON) ! (>L:INI_ADR2_BUTTON)")
qmovha:CfgRpn(56, "(L:INI_ADR3_BUTTON) ! (>L:INI_ADR3_BUTTON)")
qmovha:CfgRpn(57, "(L:INI_ADR1_BUTTON) ! (>L:INI_ADR1_BUTTON)")

-- IR1
qmovha:CfgVal(73, "B:AIRLINER_ADIRS_KNOB_1", 0)
qmovha:CfgVal(74, "B:AIRLINER_ADIRS_KNOB_1", 1)
qmovha:CfgVal(75, "B:AIRLINER_ADIRS_KNOB_1", 2)

-- IR3
qmovha:CfgVal(79, "B:AIRLINER_ADIRS_KNOB_3", 0)
qmovha:CfgVal(80, "B:AIRLINER_ADIRS_KNOB_3", 1)
qmovha:CfgVal(81, "B:AIRLINER_ADIRS_KNOB_3", 2)

-- IR2
qmovha:CfgVal(76, "B:AIRLINER_ADIRS_KNOB_2", 0)
qmovha:CfgVal(77, "B:AIRLINER_ADIRS_KNOB_2", 1)
qmovha:CfgVal(78, "B:AIRLINER_ADIRS_KNOB_2", 2)

-- BAT 1&2
---- GEN1
qmovha:CfgRpn(58, "(L:INI_GEN_1_SWITCH) ! (>L:INI_GEN_1_SWITCH) (L:INI_GEN_1_SWITCH) (>L:INI_GEN_2_SWITCH)")
---- BAT1
qmovha:CfgRpn(59,
    "(L:INI_BATTERY_1_SWITCH) ! (>L:INI_BATTERY_1_SWITCH)")
---- BAT2
qmovha:CfgRpn(60,
    "(L:INI_BATTERY_2_SWITCH) ! (>L:INI_BATTERY_2_SWITCH) (L:INI_BATTERY_2_SWITCH) (>L:INI_BATTERY_APU_SWITCH)")
---- GEN2
qmovha:CfgRpn(62, "(L:INI_GEN_4_SWITCH) ! (>L:INI_GEN_4_SWITCH) (L:INI_GEN_4_SWITCH) (>L:INI_GEN_3_SWITCH)")

-- EXT PWR
qmovha:CfgRpn(61,
    "(L:INI_GPU_AVAIL) 1 == if{ (L:INI_GEN_EXT_A_ONLINE) ! (>L:INI_GEN_EXT_A_ONLINE) } (L:INI_GPU_AVAIL) 1 == if{ (L:INI_GEN_EXT_B_ONLINE) ! (>L:INI_GEN_EXT_B_ONLINE) }")

-- FUEL
---- L1
qmovha:CfgRpn(54,
    "(L:INI_OUTER_TANK_LEFT) ! (>L:INI_OUTER_TANK_LEFT) (L:INI_OUTER_TANK_LEFT) (>L:INI_OUTER_TANK_LEFT_STBY_PUMP)")
---- L2
qmovha:CfgRpn(68,
    "(L:INI_INNER_TANK_LEFT) ! (>L:INI_INNER_TANK_LEFT) (L:INI_INNER_TANK_LEFT) (>L:INI_INNER_TANK_LEFT_STBY_PUMP)")
---- C1
qmovha:CfgRpn(67, "(L:INI_CENTER_TANK_LEFT) ! (>L:INI_CENTER_TANK_LEFT)")
---- C2
qmovha:CfgRpn(65, "(L:INI_CENTER_TANK_RIGHT) ! (>L:INI_CENTER_TANK_RIGHT)")
---- R1
qmovha:CfgRpn(64,
    "(L:INI_INNER_TANK_RIGHT) ! (>L:INI_INNER_TANK_RIGHT) (L:INI_INNER_TANK_RIGHT) (>L:INI_INNER_TANK_RIGHT_STBY_PUMP)")
---- R2
qmovha:CfgRpn(63,
    "(L:INI_OUTER_TANK_RIGHT) ! (>L:INI_OUTER_TANK_RIGHT) (L:INI_OUTER_TANK_RIGHT) (>L:INI_OUTER_TANK_RIGHT_STBY_PUMP)")
---- XFEED
qmovha:CfgRpn(66, "(L:INI_XFEED_TRANSFER_ON) ! (>L:INI_XFEED_TRANSFER_ON)")

-- FIRE

---- eng2 agent2
qmovha:CfgRpn(69, "(L:INI_FIRE_ENG_2_AGENT_2_DISCH) ! (>L:INI_FIRE_ENG_2_AGENT_2_DISCH)")
---- eng2 agent1
qmovha:CfgRpn(70, "(L:INI_FIRE_ENG_2_AGENT_1_DISCH) ! (>L:INI_FIRE_ENG_2_AGENT_1_DISCH)")
---- eng1 agent2
qmovha:CfgRpn(71, "(L:INI_FIRE_ENG_1_AGENT_2_DISCH) ! (>L:INI_FIRE_ENG_1_AGENT_2_DISCH)")
---- eng1 agent1
qmovha:CfgRpn(72, "(L:INI_FIRE_ENG_1_AGENT_1_DISCH) ! (>L:INI_FIRE_ENG_1_AGENT_1_DISCH)")

---- ENG1
qmovha:CfgRpn(82, "1 (>B:AIRLINER_FIRE_ENG_1_Cover_Set) 1 (>L:INI_FIRE_ENG_1_FIRE_PB)", "0 (>L:INI_FIRE_ENG_1_FIRE_PB)")
---- APU
qmovha:CfgRpn(83, "1 (>B:AIRLINER_FIRE_APU_Cover_Set) 1 (>L:INI_FIRE_APU_FIRE_PB)", "0 (>L:INI_FIRE_APU_FIRE_PB)")
---- ENG2
qmovha:CfgRpn(84, "1 (>B:AIRLINER_FIRE_ENG_2_Cover_Set) 1 (>L:INI_FIRE_ENG_2_FIRE_PB)", "0 (>L:INI_FIRE_ENG_2_FIRE_PB)")

---- ENG1 Test
qmovha:CfgRpn(85, "1 (>B:AIRLINER_FIRE_TEST_PUSH)", "1 (>B:AIRLINER_FIRE_TEST_RELEASE)")
---- APU Test
qmovha:CfgRpn(86, "1 (>B:AIRLINER_FIRE_TEST_PUSH)", "1 (>B:AIRLINER_FIRE_TEST_RELEASE)")
---- ENG2 Test
qmovha:CfgRpn(87, "1 (>B:AIRLINER_FIRE_TEST_PUSH)", "1 (>B:AIRLINER_FIRE_TEST_RELEASE)")

-- ===========================================================
-- Read data for lights

qmovha:GetStartUp('(L:INI_APU_AVAILABLE)')
qmovha:GetStartDn('(L:INI_APU_AVAILABLE) 1 == if{ 0 } els{ (L:INI_APU_START_BUTTON) }')
qmovha:GetMswUp('(L:INI_APU_MASTER_FAULT)')
qmovha:GetMswDn('(L:INI_APU_MASTER_SWITCH)')

qmovha:GetUpled2Gen1Up('(L:INI_GEN_1_FAULT) (L:INI_GEN_2_FAULT) or')
qmovha:GetUpled2Gen1Dn('(L:INI_GEN_1_SWITCH) ! (L:INI_GEN_2_SWITCH) ! or')
qmovha:GetUpled2Gen2Up('(L:INI_GEN_4_FAULT) (L:INI_GEN_3_FAULT) or')
qmovha:GetUpled2Gen2Dn('(L:INI_GEN_4_SWITCH) ! (L:INI_GEN_3_SWITCH) ! or')

qmovha:GetUpled2Bat1Up('(L:INI_BATTERY_1_FAULT)')
qmovha:GetUpled2Bat1Dn('(L:INI_BATTERY_1_SWITCH) !')
qmovha:GetUpled2Bat2Up('(L:INI_BATTERY_2_FAULT)')
qmovha:GetUpled2Bat2Dn('(L:INI_BATTERY_2_SWITCH) !')
qmovha:GetUpled2ExtUp('(L:INI_GPU_AVAIL) (L:INI_GEN_EXT_A_ONLINE, Bool) ! and')
qmovha:GetUpled2ExtDn('(L:INI_GEN_EXT_A_ONLINE, Bool)')

qmovha:GetEng2Up('(L:INI_ENG_ANTI_ICE3_FAULT)')
qmovha:GetEng2Dn('(L:INI_ENG_ANTI_ICE3_STATE)')
qmovha:GetEng1Up('(L:INI_ENG_ANTI_ICE1_FAULT)')
qmovha:GetEng1Dn('(L:INI_ENG_ANTI_ICE1_STATE)')
qmovha:GetWingUp('(L:INI_WING_ANTI_ICE1_FAULT)')
qmovha:GetWingDn('(L:INI_WING_ANTI_ICE1_STATE)')

qmovha:GetPack1Up('(L:INI_AIR_PACK1_FAULT)')
qmovha:GetPack1Dn('(L:INI_AIR_PACK1_BUTTON) !')
qmovha:GetApubUp('(L:VC_OVHD_AC_Eng_APU_Bleed_Button_TOP)')
qmovha:GetApubDn('(L:INI_AIR_BLEED_APU)')
qmovha:GetPack2Up('(L:INI_AIR_PACK2_FAULT)')
qmovha:GetPack2Dn('(L:INI_AIR_PACK2_BUTTON) !')

qmovha:GetCrew('(L:INI_CREW_SUPPLY) !')
qmovha:GetUpled1Gndctl('(L:INI_GND_CTL)')

qmovha:GetUpled1TerrUp('(L:VC_OVHD_GPWS_TERR_Button_TOP)')
qmovha:GetUpled1TerrDn('(L:INI_GPWS_TERR_STATE) !')
qmovha:GetUpled1SysUp('(L:VC_OVHD_GPWS_SYS_Button_TOP)')
qmovha:GetUpled1SysDn('(L:INI_GPWS_SYS_STATE) !')
qmovha:GetUpled1Flap3('(L:INI_GPWS_FLAP3_MODE)')

qmovha:GetUpled1Adr1Up('(L:INI_ADR1_FAULT)')
qmovha:GetUpled1Adr1Dn('(L:INI_ADR1_BUTTON) !')
qmovha:GetUpled1Adr3Up('(L:INI_ADR3_FAULT)')
qmovha:GetUpled1Adr3Dn('(L:INI_ADR3_BUTTON) !')
qmovha:GetUpled1Adr2Up('(L:INI_ADR2_FAULT)')
qmovha:GetUpled1Adr2Dn('(L:INI_ADR2_BUTTON) !')
qmovha:GetUpled1Onbat('(L:INI_IRS_ON_BATTERY)')

qmovha:GetUpled1Ltk1Up('(L:INI_INNER_PUMP_1_FAULT)')
qmovha:GetUpled1Ltk1Dn('(L:INI_OUTER_TANK_LEFT) !')
qmovha:GetUpled1Ltk2Up('(L:INI_INNER_PUMP_2_FAULT)')
qmovha:GetUpled1Ltk2Dn('(L:INI_INNER_TANK_LEFT) !')
qmovha:GetUpled1CtklUp('(L:INI_CENTER_TANK_LEFT_FAULT)')
qmovha:GetUpled1CtklDn('(L:INI_CENTER_TANK_LEFT) !')
qmovha:GetUpled1CtkrUp('(L:INI_CENTER_TANK_RIGHT_FAULT)')
qmovha:GetUpled1CtkrDn('(L:INI_CENTER_TANK_RIGHT) !')
qmovha:GetUpled2Rtk1Up('(L:INI_INNER_PUMP_3_FAULT)')
qmovha:GetUpled2Rtk1Dn('(L:INI_INNER_TANK_RIGHT) !')
qmovha:GetUpled2Rtk2Up('(L:INI_INNER_PUMP_4_FAULT)')
qmovha:GetUpled2Rtk2Dn('(L:INI_OUTER_TANK_RIGHT) !')
qmovha:GetUpled2XfeedUp(
    '(L:INI_XFEED_TRANSFER_OPEN) (L:INI_XFEED_TRANSFER2_OPEN) (L:INI_XFEED_TRANSFER3_OPEN) (L:INI_XFEED_TRANSFER4_OPEN) or')
qmovha:GetUpled2XfeedDn(
    '(L:INI_XFEED_TRANSFER_ON) (L:INI_XFEED_TRANSFER2_ON) (L:INI_XFEED_TRANSFER3_ON) (L:INI_XFEED_TRANSFER4_ON) or')

qmovha:GetUpled1Fire2('(L:INI_FIRE_TEST) (L:INI_FIRE_ENG_2_FIRE) or')
qmovha:GetUpled1Firea('(L:INI_APU_FIRE_TEST) (L:INI_FIRE_TEST) or') -- ini380 bug patch
qmovha:GetUpled1Fire1('(L:INI_FIRE_TEST) (L:INI_FIRE_ENG_1_FIRE) or')
qmovha:GetUpled2Eng1ag1('(L:INI_FIRE_TEST) (L:INI_ENG1_AGENT1_SQUIB) or')
qmovha:GetUpled2Eng1ag2('(L:INI_FIRE_TEST) (L:INI_ENG1_AGENT2_SQUIB) or')
qmovha:GetUpled2Eng2ag1('(L:INI_FIRE_TEST) (L:INI_ENG2_AGENT1_SQUIB) or')
qmovha:GetUpled2Eng2ag2('(L:INI_FIRE_TEST) (L:INI_ENG3_AGENT2_SQUIB) or')

qmovha:GetBkl('(L:INI_CKPT_LT_INTEG, Percent)', 0.5)                            -- 0~100

qmovha:GetBrtDim("(L:INI_ANNLT_SWITCH)", 1)                                     -- 2: DIM 1: BRT 0: test mode
-- Airbus cockpit on the overhead panel is approximately 18C~30C
qmovha:GetAirCond("(L:INI_PACK1_PERCENT)", "(L:INI_TEMP_KNOB1)", 0.12, 18)      --0~1, 0~100

local dr_test = iDataRef:New("(L:INI_ANNLT_SWITCH)")                            -- 2: DIM 1: BRT 0: test mode
local dr_ac_bus = iDataRef:New("(L:INI_ELEC_AC_ESS_SHED_BUS_IS_POWERED, BOOL)") -- 0: OFF 1: ON
local dr_dc_bus = iDataRef:New("(L:INI_battery_on, BOOL)")                      -- 0: OFF 1: ON

GlobalFrameLoopManager:add(function()
    -- expert code: test mode
    local b_ac_bus = dr_ac_bus:Get()
    local b_dc_bus = dr_dc_bus:Get()

    local b_test = dr_test:Get()
    if dr_test:ChangedUpdate() then
        if b_test == 0 and b_ac_bus == 1 then
            -- TEST
            uluaSet(idr_qmovh_a_hid_mode_off, 0)
            uluaSet(idr_qmovh_a_hid_mode_test, 1)
        else
            uluaSet(idr_qmovh_a_hid_mode_test, 0)
        end
    end

    if b_test == 0 then
        -- TEST
        return
    end
    qmovha:SetUpled2ExtUp()
    qmovha:SetUpled2ExtDn()

    if dr_ac_bus:ChangedUpdate() and b_ac_bus == 1 or b_dc_bus == 1 then
        qmovha:FreshAllled()
        qmovha:FreshBkl()
    end

    if b_ac_bus == 1 then
        qmovha:SetDnled()
        qmovha:SetUpled1()
        qmovha:SetUpled2Rtk1Up()
        qmovha:SetUpled2Rtk1Dn()
        qmovha:SetUpled2Rtk2Up()
        qmovha:SetUpled2Rtk2Dn()
        qmovha:SetUpled2Gen1Up()
        qmovha:SetUpled2Gen1Dn()
        qmovha:SetUpled2XfeedUp()
        qmovha:SetUpled2XfeedDn()
        qmovha:SetUpled2Bat1Up()
        qmovha:SetUpled2Bat1Dn()
        qmovha:SetUpled2Bat2Up()
        qmovha:SetUpled2Bat2Dn()
        qmovha:SetUpled2Gen2Up()
        qmovha:SetUpled2Gen2Dn()
        qmovha:SetUpled2Eng1ag1()
        qmovha:SetUpled2Eng1ag2()
        qmovha:SetUpled2Eng2ag1()
        qmovha:SetUpled2Eng2ag2()

        qmovha:SetBkl()
        qmovha:SetBrtDim()
        qmovha:SetAirCond()
    else
        qmovha:SetDnled(0, 0)

        if b_dc_bus == 0 then
            qmovha:SetUpled1TerrUp(0, 0)
            qmovha:SetUpled1TerrDn(0, 0)
            qmovha:SetUpled1SysUp(0, 0)
            qmovha:SetUpled1SysDn(0, 0)
            qmovha:SetUpled1Flap3(0, 0)
            qmovha:SetUpled1Gndctl(0, 0)
            qmovha:SetUpled1Ltk1Up(0, 0)
            qmovha:SetUpled1Ltk1Dn(0, 0)
            qmovha:SetUpled1Adr1Up(0, 0)
            qmovha:SetUpled1Adr1Dn(0, 0)
            qmovha:SetUpled1Adr3Up(0, 0)
            qmovha:SetUpled1Adr3Dn(0, 0)
            qmovha:SetUpled1Adr2Up(0, 0)
            qmovha:SetUpled1Adr2Dn(0, 0)
            qmovha:SetUpled1Ltk2Up(0, 0)
            qmovha:SetUpled1Ltk2Dn(0, 0)
            qmovha:SetUpled1CtklUp(0, 0)
            qmovha:SetUpled1CtklDn(0, 0)
            qmovha:SetUpled1CtkrUp(0, 0)
            qmovha:SetUpled1CtkrDn(0, 0)
            qmovha:SetUpled1Fire2(0, 0)
            qmovha:SetUpled1Firea(0, 0)
            qmovha:SetUpled1Fire1(0, 0)
            qmovha:SetUpled1Onbat(0, 0)

            qmovha:SetUpled2Rtk1Up(0, 0)
            qmovha:SetUpled2Rtk1Dn(0, 0)
            qmovha:SetUpled2Rtk2Up(0, 0)
            qmovha:SetUpled2Rtk2Dn(0, 0)
            qmovha:SetUpled2Gen1Up(0, 0)
            qmovha:SetUpled2Gen1Dn(0, 0)
            qmovha:SetUpled2XfeedUp(0, 0)
            qmovha:SetUpled2XfeedDn(0, 0)

            qmovha:SetUpled2Bat1Up(0, 0)
            qmovha:SetUpled2Bat1Dn(0, 0)
            qmovha:SetUpled2Bat2Up(0, 0)
            qmovha:SetUpled2Bat2Dn(0, 0)
            qmovha:SetUpled2Gen2Up(0, 0)
            qmovha:SetUpled2Gen2Dn(0, 0)
        else
            qmovha:SetUpled1Ltk1Up()
            qmovha:SetUpled1Ltk1Dn()
            qmovha:SetUpled1Fire2()
            qmovha:SetUpled1Firea()
            qmovha:SetUpled1Fire1()
            qmovha:SetUpled1Onbat()

            qmovha:SetUpled1Ltk2Up()
            qmovha:SetUpled1Ltk2Dn()
            qmovha:SetUpled1CtklUp()
            qmovha:SetUpled1CtklDn()
            qmovha:SetUpled1CtkrUp()
            qmovha:SetUpled1CtkrDn()

            qmovha:SetUpled2Rtk1Up()
            qmovha:SetUpled2Rtk1Dn()
            qmovha:SetUpled2Rtk2Up()
            qmovha:SetUpled2Rtk2Dn()
            qmovha:SetUpled2Gen1Up()
            qmovha:SetUpled2Gen1Dn()
            qmovha:SetUpled2XfeedUp()
            qmovha:SetUpled2XfeedDn()

            qmovha:SetUpled2Bat1Up()
            qmovha:SetUpled2Bat1Dn()
            qmovha:SetUpled2Bat2Up()
            qmovha:SetUpled2Bat2Dn()
            qmovha:SetUpled2Gen2Up()
            qmovha:SetUpled2Gen2Dn()
        end

        qmovha:SetUpled2Eng1ag1(0, 0)
        qmovha:SetUpled2Eng1ag2(0, 0)
        qmovha:SetUpled2Eng2ag1(0, 0)
        qmovha:SetUpled2Eng2ag2(0, 0)

        qmovha:SetBkl(0)
    end
end)
