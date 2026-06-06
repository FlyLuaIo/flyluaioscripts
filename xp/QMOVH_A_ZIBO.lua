-- *****************************************************************
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-06-05
-- *****************************************************************

if ilua_is_acftitle_excluded("B73") then
    return
end

if uluaFind("laminar/B738/EFIS_control/cpt/minimums_dn") == nil or uluaFind("laminar/B738/EFIS_control/cpt/minimums") == nil then
    uluaLog("this is not zibo 738")
    return
end

-- Do not remove below lines: hardware detection
local qmovha = com.sim.qm.Qmovha:new()
if not qmovha:Init() then
    return
end
-- Do not remove above lines: hardware detection

uluaLog("QMOVH-A for ZIBO 738")

local zibo_xp11 = false
if uluaFind("sim/cockpit2/electrical/GPU_generator_on") == nil then
    -- X-Plane 11
    zibo_xp11 = true
end

-- ===========================================================
-- button binding
-- Strobe
qmovha:CfgCmd(0, "sim/lights/strobe_lights_on")
qmovha:CfgCmd(41, "sim/lights/strobe_lights_on")
qmovha:CfgCmd(1, "sim/lights/strobe_lights_off")

-- beacon  lights
qmovha:CfgVal(2, "sim/cockpit/electrical/beacon_lights_on", 1, 0)

-- Wing lights
qmovha:CfgVal(3, "laminar/B738/toggle_switch/wing_light", 1, 0)

-- NAV lights
local pswh4 = QmdevPosSwitchInit("laminar/B738/toggle_switch/position_light_pos", 1,
    "laminar/B738/toggle_switch/position_light_up",
    "laminar/B738/toggle_switch/position_light_down")
qmovha:CfgPSw(4, pswh4, 1)
qmovha:CfgPSw(42, pswh4, -1)
qmovha:CfgPSw(5, pswh4, 0)

-- Taxi lights
qmovha:CfgCmd(6, "laminar/B738/toggle_switch/taxi_light_brightness_on")
qmovha:CfgCmd(45, "laminar/B738/toggle_switch/taxi_light_brightness_on")
qmovha:CfgCmd(7, "laminar/B738/toggle_switch/taxi_light_brightness_off")


-- R Landing lights
--qmovha:CfgCmd(8, "sim/lights/landing_02_light_on")
--qmovha:CfgCmd(44, "sim/lights/landing_02_light_off")
--qmovha:CfgCmd(9, "sim/lights/landing_02_light_off")

qmovha:CfgVal(8, "laminar/B738/switch/land_lights_right_pos", 1, 0)
qmovha:CfgCmd(8, "laminar/B738/switch/land_lights_ret_right_on", "laminar/B738/switch/land_lights_ret_right_off")

-- L Landing lights
--qmovha:CfgCmd(10, "sim/lights/landing_01_light_on")
--qmovha:CfgCmd(43, "sim/lights/landing_01_light_off")
--qmovha:CfgCmd(11, "sim/lights/landing_01_light_off")
qmovha:CfgVal(10, "laminar/B738/switch/land_lights_left_pos", 1, 0)
qmovha:CfgCmd(10, "laminar/B738/switch/land_lights_ret_left_on", "laminar/B738/switch/land_lights_ret_left_off")
-- Runway Turn Off lights
local dr_qmovh_zibo_rwy1 = iDataRef:New("laminar/B738/toggle_switch/rwy_light_left")
local dr_qmovh_zibo_rwy2 = iDataRef:New("laminar/B738/toggle_switch/rwy_light_right")
function rwy_action(val)
    dr_qmovh_zibo_rwy1:Set(val)
    dr_qmovh_zibo_rwy2:Set(val)
end

qmovha:CfgFc(12, "rwy_action(1)", "rwy_action(0)")

-- OVHD INTEG LT
qmovha:CfgEncFull(17, 16, "laminar/B738/electric/panel_brightness[2]", 0.05, 0.05, 1, 0.0, 1.0)
-- SEAT BELTS
local pswh13 = QmdevPosSwitchInit("laminar/B738/toggle_switch/seatbelt_sign_pos", 1,
    "laminar/B738/toggle_switch/seatbelt_sign_dn",
    "laminar/B738/toggle_switch/seatbelt_sign_up")
qmovha:CfgPSw(13, pswh13, 1, 2)
-- NO SMOKING
local pswh14 = QmdevPosSwitchInit("laminar/B738/toggle_switch/no_smoking_pos", 1,
    "laminar/B738/toggle_switch/no_smoking_dn",
    "laminar/B738/toggle_switch/no_smoking_up")
qmovha:CfgPSw(14, pswh14, 2, 1)
qmovha:CfgPSw(15, pswh14, 0, 1)
-- DOME
-- ANN LT
local pswh20 = QmdevPosSwitchInit("laminar/B738/toggle_switch/bright_test", 1,
    "laminar/B738/toggle_switch/bright_test_up",
    "laminar/B738/toggle_switch/bright_test_dn")
qmovha:CfgPSw(20, pswh20, 1, 0)
qmovha:CfgPSw(21, pswh20, -1, 0)

-- EMER EXIT LT
local pswhemercover = QmdevPosSwitchInit("laminar/B738/button_switch/cover_position[9]", 1,
    "laminar/B738/button_switch_cover09",
    "laminar/B738/button_switch_cover09", 2000)
local pswhemer = QmdevPosSwitchInit("laminar/B738/toggle_switch/emer_exit_lights", 1,
    "laminar/B738/toggle_switch/emer_exit_lights_dn",
    "laminar/B738/toggle_switch/emer_exit_lights_up")
function emer_action(cover, val)
    qmovha:PSwDelay(pswhemercover, 0, cover)
    qmovha:PSwDelay(pswhemer, 800, val)
end

qmovha:CfgFc(22, "emer_action(1, 2)", "emer_action(0, 1)")
qmovha:CfgFc(23, "emer_action(1, 0)", "emer_action(0, 1)")

-- APU
local pswh30 = QmdevPosSwitchInit("laminar/B738/spring_toggle_switch/APU_start_pos", 1,
    "laminar/B738/spring_toggle_switch/APU_start_pos_dn",
    "laminar/B738/spring_toggle_switch/APU_start_pos_up")
-- APU Start
qmovha:CfgPSwTog(30, pswh30, 1, 2)
-- APU Master
qmovha:CfgPSwTog(31, pswh30, 0, 1)


-- ANTI ICE
qmovha:CfgValT(32, "laminar/B738/ice/eng2_heat_pos")
qmovha:CfgValT(33, "laminar/B738/ice/eng1_heat_pos")
qmovha:CfgValT(37, "laminar/B738/ice/wing_heat_pos")

-- AIR COND
local pswh34 = QmdevPosSwitchInit("laminar/B738/air/l_pack_pos", 1,
    "laminar/B738/toggle_switch/l_pack_dn",
    "laminar/B738/toggle_switch/l_pack_up")
qmovha:CfgPSwTog(34, pswh34, 0, 1)

--- APU BLEED
qmovha:CfgValT(35, "laminar/B738/toggle_switch/bleed_air_apu_pos", 0, 1)

local pswh36 = QmdevPosSwitchInit("laminar/B738/air/r_pack_pos", 1,
    "laminar/B738/toggle_switch/r_pack_dn",
    "laminar/B738/toggle_switch/r_pack_up")
qmovha:CfgPSwTog(36, pswh36, 0, 1)

--- isolation valve
qmovha:CfgVal(27, "laminar/B738/air/isolation_valve_pos", 0, nil)
qmovha:CfgVal(28, "laminar/B738/air/isolation_valve_pos", 1, nil)
qmovha:CfgVal(29, "laminar/B738/air/isolation_valve_pos", 2, nil)

-- WIPER
local pswwiperl = QmdevPosSwitchInit("laminar/B738/switches/left_wiper_pos", 1,
    "laminar/B738/knob/left_wiper_up",
    "laminar/B738/knob/left_wiper_dn")
local pswwiperr = QmdevPosSwitchInit("laminar/B738/switches/right_wiper_pos", 1,
    "laminar/B738/knob/right_wiper_up",
    "laminar/B738/knob/right_wiper_dn")
function wiper_action(val)
    qmovha:PSwDelay(pswwiperl, 0, val)
    qmovha:PSwDelay(pswwiperr, 100, val)
end

qmovha:CfgFc(24, "wiper_action(0)")
qmovha:CfgFc(25, "wiper_action(2)")
qmovha:CfgFc(26, "wiper_action(3)")

-- OXYGEN
--- as cecirc fan
local pswfanl = QmdevPosSwitchInit("laminar/B738/air/l_recirc_fan_pos", 1,
    "laminar/B738/toggle_switch/l_recirc_fan",
    "laminar/B738/toggle_switch/l_recirc_fan")
local pswfanr = QmdevPosSwitchInit("laminar/B738/air/r_recirc_fan_pos", 1,
    "laminar/B738/toggle_switch/r_recirc_fan",
    "laminar/B738/toggle_switch/r_recirc_fan")
function fan_action()
    qmovha:PSwTog(pswfanl, 0, 0, 1)
    qmovha:PSwTog(pswfanr, 500, 0, 1)
end

qmovha:CfgFc(38, "fan_action()")
-- CALLS
qmovha:CfgCmd(40, "laminar/B738/push_button/attend")

-- GPWS
--- hyd elec 1&2
local pswhydelecl = QmdevPosSwitchInit("laminar/B738/toggle_switch/electric_hydro_pumps1_pos", 1,
    "laminar/B738/toggle_switch/electric_hydro_pumps1",
    "laminar/B738/toggle_switch/electric_hydro_pumps1")
local pswhydelecr = QmdevPosSwitchInit("laminar/B738/toggle_switch/electric_hydro_pumps2_pos", 1,
    "laminar/B738/toggle_switch/electric_hydro_pumps2",
    "laminar/B738/toggle_switch/electric_hydro_pumps2")
function hydelec_action()
    qmovha:PSwTog(pswhydelecl, 0, 0, 1)
    qmovha:PSwTog(pswhydelecr, 500, 0, 1)
end

qmovha:CfgFc(50, "hydelec_action()")

--- hyd engine 1&2
local pswhydengl = QmdevPosSwitchInit("laminar/B738/annunciator/hyd_press_a", 1,
    "laminar/B738/toggle_switch/hydro_pumps1",
    "laminar/B738/toggle_switch/hydro_pumps1", 2000)
local pswhydengr = QmdevPosSwitchInit("laminar/B738/annunciator/hyd_press_b", 1,
    "laminar/B738/toggle_switch/hydro_pumps2",
    "laminar/B738/toggle_switch/hydro_pumps2", 2000)
function hydeng_action()
    qmovha:PSwTog(pswhydengl, 0, 0, 1)
    qmovha:PSwTog(pswhydengr, 500, 0, 1)
end

qmovha:CfgFc(51, "hydeng_action()")

qmovha:CfgValT(52, "AirbusFBW/GPWSSwitchArray[3]")
-- GND CTL CVR
--- as APU GEN
local pswapugenl = QmdevPosSwitchInit("laminar/B738/electrical/apu_power_bus1", 1,
    "laminar/B738/toggle_switch/apu_gen1_dn",
    "laminar/B738/toggle_switch/apu_gen1_up", 2000)
local pswapugenr = QmdevPosSwitchInit("laminar/B738/electrical/apu_power_bus2", 1,
    "laminar/B738/toggle_switch/apu_gen2_dn",
    "laminar/B738/toggle_switch/apu_gen2_up", 2000)
function apugen_action()
    qmovha:PSwTog(pswapugenl, 0, 0, 1)
    qmovha:PSwTog(pswapugenr, 500, 0, 1)
end

qmovha:CfgFc(53, "apugen_action()")

-- ADIRS 2,3,1
--- ADR2 as probe
local dr_qmovh_zibo_pitot1 = iDataRef:New("laminar/B738/toggle_switch/capt_probes_pos")
local dr_qmovh_zibo_pitot2 = iDataRef:New("laminar/B738/toggle_switch/fo_probes_pos")
function pitot_action()
    local val = 1 - dr_qmovh_zibo_pitot1:Get()
    dr_qmovh_zibo_pitot1:Set(val)
    dr_qmovh_zibo_pitot2:Set(val)
end

qmovha:CfgFc(55, "pitot_action()")

--- ADR3 as window heat
local dr_qmovh_zibo_winheat1 = iDataRef:New("laminar/B738/ice/window_heat_l_side_pos")
local dr_qmovh_zibo_winheat2 = iDataRef:New("laminar/B738/ice/window_heat_l_fwd_pos")
local dr_qmovh_zibo_winheat3 = iDataRef:New("laminar/B738/ice/window_heat_r_side_pos")
local dr_qmovh_zibo_winheat4 = iDataRef:New("laminar/B738/ice/window_heat_r_fwd_pos")
function winheat_action()
    local val = 1 - dr_qmovh_zibo_winheat1:Get()
    dr_qmovh_zibo_winheat1:Set(val)
    dr_qmovh_zibo_winheat2:Set(val)
    dr_qmovh_zibo_winheat3:Set(val)
    dr_qmovh_zibo_winheat4:Set(val)
end

qmovha:CfgFc(56, "winheat_action()")

--- ADR1: yaw damper
qmovha:CfgValT(57, "laminar/B738/toggle_switch/yaw_dumper_pos")

---- IR1
local pswh73 = QmdevPosSwitchInit("laminar/B738/engine/starter1_pos", 1,
    "laminar/B738/knob/eng1_start_right",
    "laminar/B738/knob/eng1_start_left", 500)
qmovha:CfgPSw(73, pswh73, 0)
qmovha:CfgPSw(74, pswh73, 1)
qmovha:CfgPSw(75, pswh73, 2)

---- IR3
local pswh79 = QmdevPosSwitchInit("laminar/B738/toggle_switch/irs_left", 1,
    "laminar/B738/toggle_switch/irs_L_right",
    "laminar/B738/toggle_switch/irs_L_left", 500)
local pswh80 = QmdevPosSwitchInit("laminar/B738/toggle_switch/irs_right", 1,
    "laminar/B738/toggle_switch/irs_R_right",
    "laminar/B738/toggle_switch/irs_R_left", 500)

function irs_action(val)
    qmovha:PSwDelay(pswh79, 0, val)
    qmovha:PSwDelay(pswh80, 100, val)
end

qmovha:CfgFc(79, "irs_action(0)")
qmovha:CfgFc(80, "irs_action(2)")
qmovha:CfgFc(81, "irs_action(3)")

---- IR2
local pswh76 = QmdevPosSwitchInit("laminar/B738/engine/starter2_pos", 1,
    "laminar/B738/knob/eng2_start_right",
    "laminar/B738/knob/eng2_start_left", 500)
qmovha:CfgPSw(76, pswh76, 0)
qmovha:CfgPSw(77, pswh76, 1)
qmovha:CfgPSw(78, pswh76, 2)

-- BAT 1&2
---- GEN1
local pswh58 = QmdevPosSwitchInit("sim/cockpit2/electrical/generator_on[0]", 1,
    "laminar/B738/toggle_switch/gen1_dn",
    "laminar/B738/toggle_switch/gen1_up", 800)
qmovha:CfgPSw(58, pswh58, 0, 1)
---- BAT1
local pswhbatcover = QmdevPosSwitchInit("laminar/B738/button_switch/cover_position[2]", 1,
    "laminar/B738/button_switch_cover02",
    "laminar/B738/button_switch_cover02", 1000)
local pswhbat1 = QmdevPosSwitchInit("sim/cockpit2/switches/avionics_power_on", 1,
    "laminar/B738/switch/battery_dn",
    "laminar/B738/switch/battery_up")
function bat1_action()
    qmovha:PSwTog(pswhbatcover, 0, 0, 1)
    qmovha:PSwTog(pswhbat1, 200, 0, 1)
end

qmovha:CfgFc(59, "bat1_action()")


---- BAT2
qmovha:CfgValT(60, "sim/cockpit/electrical/battery_on")
---- GEN2
local pswh62 = QmdevPosSwitchInit("sim/cockpit2/electrical/generator_on[1]", 1,
    "laminar/B738/toggle_switch/gen2_dn",
    "laminar/B738/toggle_switch/gen2_up", 800)
qmovha:CfgPSw(62, pswh62, 0, 1)

-- EXT PWR
local pswh61 = QmdevPosSwitchInit("sim/cockpit/electrical/gpu_on", 1,
    "laminar/B738/toggle_switch/gpu_dn",
    "laminar/B738/toggle_switch/gpu_up", 1000)
qmovha:CfgPSw(61, pswh61, 0, 1)

-- FUEL
qmovha:CfgValT(54, "laminar/B738/fuel/fuel_tank_pos_lft1")
qmovha:CfgValT(68, "laminar/B738/fuel/fuel_tank_pos_lft2")

qmovha:CfgValT(67, "laminar/B738/fuel/fuel_tank_pos_ctr1")
qmovha:CfgValT(65, "laminar/B738/fuel/fuel_tank_pos_ctr2")

qmovha:CfgValT(64, "laminar/B738/fuel/fuel_tank_pos_rgt2")
qmovha:CfgValT(63, "laminar/B738/fuel/fuel_tank_pos_rgt1")

-- cross feed
local pswh66 = QmdevPosSwitchInit("laminar/B738/fuel/cross_feed_valve", 1,
    "laminar/B738/toggle_switch/crossfeed_valve_on",
    "laminar/B738/toggle_switch/crossfeed_valve_off", 800)
qmovha:CfgPSwTog(66, pswh66, 0, 1)

-- FIRE
---- eng1 agent2
qmovha:CfgValT(71, "laminar/B738/fire/engine01/ext_switch_arm", 1, 0)
---- eng1 agent1
qmovha:CfgValT(72, "laminar/B738/fire/engine01/ext_switch_arm", -1, 0)
---- eng1
local pswh82 = QmdevPosSwitchInit("laminar/B738/fire/engine01/ext_switch/pos_arm", 1,
    "laminar/B738/fire/engine01/ext_switch_arm",
    "laminar/B738/fire/engine01/ext_switch_arm", 5000)
qmovha:CfgPSw(82, pswh82, 1, 0)
---- APU fire
local pswh83 = QmdevPosSwitchInit("laminar/B738/fire/apu/ext_switch/pos_arm", 1,
    "laminar/B738/fire/apu/ext_switch_arm",
    "laminar/B738/fire/apu/ext_switch_arm", 7000)
qmovha:CfgPSw(83, pswh83, 1, 0)
---- eng2
local pswh84 = QmdevPosSwitchInit("laminar/B738/fire/engine02/ext_switch/pos_arm", 1,
    "laminar/B738/fire/engine02/ext_switch_arm",
    "laminar/B738/fire/engine02/ext_switch_arm", 5000)
qmovha:CfgPSw(84, pswh84, 1, 0)


-- ===========================================================
-- Read data
qmovha:GetMswUp('laminar/B738/annunciator/apu_low_oil')
qmovha:GetMswDn('laminar/B738/spring_toggle_switch/APU_start_pos')

qmovha:GetStartUp('laminar/B738/electrical/apu_bus_enable')
qmovha:GetStartDn('sim/cockpit/engine/APU_running')

qmovha:GetUpled2Gen1Up('laminar/B738/annunciator/source_off1')
qmovha:GetUpled2Gen1Dn('sim/cockpit/electrical/generator_on[0]', true)

qmovha:GetUpled2Bat1Up('laminar/B738/annunciator/bat_discharge')
qmovha:GetUpled2Bat1Dn('laminar/B738/electric/batbus_status', true)
qmovha:GetUpled2Bat2Up('sim/cockpit2/annunciators/electric_trim_off')
qmovha:GetUpled2Bat2Dn('sim/cockpit2/annunciators/electric_trim_off')

qmovha:GetUpled2ExtUp('laminar/B738/gpu_available')
if zibo_xp11 then
    -- X-Plane 11
    qmovha:GetUpled2ExtDn('sim/cockpit/electrical/gpu_on')
else
    qmovha:GetUpled2ExtDn('sim/cockpit2/electrical/GPU_generator_on')
end

qmovha:GetUpled2Gen2Up('laminar/B738/annunciator/source_off2')
qmovha:GetUpled2Gen2Dn('sim/cockpit/electrical/generator_on[1]', true)

qmovha:GetEng2Up('sim/cockpit2/annunciators/electric_trim_off')
if zibo_xp11 then
    -- X-Plane 11
    qmovha:GetEng2Dn('laminar/B738/antiice_sw[1]')
else
    qmovha:GetEng2Dn('laminar/B738/annunciator/cowl_ice_on_1_annun')
end
qmovha:GetEng1Up('sim/cockpit2/annunciators/electric_trim_off')
if zibo_xp11 then
    -- X-Plane 11
    qmovha:GetEng1Dn('laminar/B738/antiice_sw[0]')
else
    qmovha:GetEng1Dn('laminar/B738/annunciator/cowl_ice_on_0_annun')
end
qmovha:GetWingUp('sim/cockpit2/annunciators/electric_trim_off')
if zibo_xp11 then
    -- X-Plane 11
    qmovha:GetWingDn('laminar/B738/antiice_sw[2]')
else
    qmovha:GetWingDn('laminar/B738/annunciator/wing_ice_on_L_annun')
end
qmovha:GetPack1Up('sim/cockpit2/annunciators/electric_trim_off')
qmovha:GetPack1Dn('laminar/B738/air/l_pack_pos', true)
qmovha:GetApubUp('sim/cockpit2/annunciators/electric_trim_off')
qmovha:GetApubDn('laminar/B738/toggle_switch/bleed_air_apu_pos')
qmovha:GetPack2Up('sim/cockpit2/annunciators/electric_trim_off')
qmovha:GetPack2Dn('laminar/B738/air/r_pack_pos', true)

qmovha:GetCrew('sim/cockpit2/annunciators/electric_trim_off')
-- GND CTL as APU electric bus
qmovha:GetUpled1Gndctl('laminar/B738/electrical/apu_power_bus1')

-- GPWS: TERR as HYD ELEC, SYS as HYD eng
qmovha:GetUpled1TerrUp('laminar/B738/annunciator/hyd_el_press_a')
qmovha:GetUpled1TerrDn('laminar/B738/toggle_switch/electric_hydro_pumps1_pos', true)
qmovha:GetUpled1SysUp('laminar/B738/annunciator/hyd_press_a')
qmovha:GetUpled1SysDn('laminar/B738/toggle_switch/hydro_pumps1_pos', true)
qmovha:GetUpled1Flap3('sim/cockpit2/annunciators/electric_trim_off')

-- ADR1 as Yaw Damper
qmovha:GetUpled1Adr1Up('sim/cockpit2/annunciators/yaw_damper', true)
qmovha:GetUpled1Adr1Dn('laminar/B738/toggle_switch/yaw_dumper_pos', true)
-- ADR3 as window heat
qmovha:GetUpled1Adr3Up('sim/cockpit2/annunciators/electric_trim_off')
qmovha:GetUpled1Adr3Dn('laminar/B738/ice/window_heat_l_side_pos', true)
-- ADR2 as PROBE
qmovha:GetUpled1Adr2Up('laminar/B738/annunciator/capt_pitot_off')
qmovha:GetUpled1Adr2Dn('laminar/B738/toggle_switch/capt_probes_pos', true)

qmovha:GetUpled1Onbat('laminar/B738/annunciator/irs_on_dc_left')

qmovha:GetUpled1Ltk1Up('laminar/B738/annunciator/low_fuel_press_l1')
qmovha:GetUpled1Ltk1Dn('laminar/B738/fuel/fuel_tank_pos_lft1', true)
qmovha:GetUpled1Ltk2Up('laminar/B738/annunciator/low_fuel_press_l2')
qmovha:GetUpled1Ltk2Dn('laminar/B738/fuel/fuel_tank_pos_lft2', true)
qmovha:GetUpled1CtklUp('laminar/B738/annunciator/low_fuel_press_c1')
qmovha:GetUpled1CtklDn('laminar/B738/fuel/fuel_tank_pos_ctr1', true)
qmovha:GetUpled1CtkrUp('laminar/B738/annunciator/low_fuel_press_c2')
qmovha:GetUpled1CtkrDn('laminar/B738/fuel/fuel_tank_pos_ctr2', true)
qmovha:GetUpled2Rtk1Up('laminar/B738/annunciator/low_fuel_press_r2')
qmovha:GetUpled2Rtk1Dn('laminar/B738/fuel/fuel_tank_pos_rgt2', true)
qmovha:GetUpled2Rtk2Up('laminar/B738/annunciator/low_fuel_press_r1')
qmovha:GetUpled2Rtk2Dn('laminar/B738/fuel/fuel_tank_pos_rgt1', true)

qmovha:GetUpled2XfeedUp('laminar/B738/fuel/cross_feed_valve')
qmovha:GetUpled2XfeedDn('laminar/B738/knobs/cross_feed_pos')

qmovha:GetUpled1Fire2('laminar/B738/annunciator/engine2_fire')
qmovha:GetUpled1Firea('laminar/B738/annunciator/apu_fire')
qmovha:GetUpled1Fire1('laminar/B738/annunciator/engine1_fire')
qmovha:GetUpled2Eng1ag1('laminar/B738/fire/engine01/ext_switch/pos_arm')
qmovha:GetUpled2Eng1ag2('laminar/B738/fire/engine01/ext_switch/pos_arm')
qmovha:GetUpled2Eng2ag1('laminar/B738/fire/engine02/ext_switch/pos_arm')
qmovha:GetUpled2Eng2ag2('laminar/B738/fire/engine02/ext_switch/pos_arm')

qmovha:GetBkl('laminar/B738/electric/panel_brightness[2]', 100)                            -- 0~1

qmovha:GetBrtDim("laminar/B738/toggle_switch/bright_test", 1)                              -- 0: DIM 1: BRT 2: test mode
qmovha:GetAirCond("laminar/B738/indicators/duct_press_L", "laminar/B738/cabin_temp", 1, 2) --0~1, 16~28
local dr_test = iDataRef:New("laminar/B738/toggle_switch/bright_test")

GlobalFrameLoopManager:add(function()
    local b_test = dr_test:Get()
    if dr_test:ChangedUpdate() then
        if b_test == 1 then
            -- TEST
            uluaSet(idr_qmovh_a_hid_mode_off, 0)
            uluaSet(idr_qmovh_a_hid_mode_test, 1)
        else
            uluaSet(idr_qmovh_a_hid_mode_test, 0)
        end
        if b_test == -1 then
            -- DIM
            uluaSet(idr_qmovh_a_hid_dim_brtdim, 1)
            uluaSet(idr_qmovh_a_hid_mode_off, 0)
        elseif b_test == 0 then
            -- BRT
            uluaSet(idr_qmovh_a_hid_dim_brtdim, 0)
        end
    end
    if b_test == 1 then
        -- TEST
        return
    end
    qmovha:SetDnled()
    qmovha:SetUpled1()
    qmovha:SetUpled2()

    qmovha:SetBkl()
end)
