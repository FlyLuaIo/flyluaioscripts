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

-- OVHD INTEG LT
qmovha:CfgEncFull(17, 16, "laminar/B738/electric/panel_brightness[2]", 0.05, 0.05, 1, 0.0, 1.0)

-- APU
local pswh30 = QmdevPosSwitchInit("laminar/B738/spring_toggle_switch/APU_start_pos", 1,
    "laminar/B738/spring_toggle_switch/APU_start_pos_dn",
    "laminar/B738/spring_toggle_switch/APU_start_pos_up")
-- APU Start
qmovha:CfgPSwTog(30, pswh30, 1, 2)
-- APU Master
qmovha:CfgPSwTog(31, pswh30, 0, 1)

-- BAT 1&2
---- GEN1
qmovha:CfgValT(58, "sim/cockpit2/electrical/generator_on[0]")
---- BAT1
qmovha:CfgValT(59, "sim/cockpit/electrical/battery_on")
---- BAT2
qmovha:CfgValT(60, "sim/cockpit/electrical/battery_on")
---- GEN2
qmovha:CfgValT(62, "sim/cockpit2/electrical/generator_on[1]")


-- FUEL
qmovha:CfgValT(54, "sim/cockpit2/engine/actuators/fuel_pump_on[0]")
qmovha:CfgValT(68, "sim/cockpit2/engine/actuators/fuel_pump_on[1]")

qmovha:CfgValT(67, "sim/cockpit2/engine/actuators/fuel_pump_on[2]")
qmovha:CfgValT(65, "sim/cockpit2/engine/actuators/fuel_pump_on[3]")

qmovha:CfgValT(64, "sim/cockpit2/engine/actuators/fuel_pump_on[4]")
qmovha:CfgValT(63, "sim/cockpit2/engine/actuators/fuel_pump_on[5]")

qmovha:CfgValT(66, "sim/cockpit2/engine/actuators/fuel_pump_on[7]")


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
qmovha:GetUpled2ExtDn('sim/cockpit2/electrical/GPU_generator_on')

qmovha:GetUpled2Gen2Up('laminar/B738/annunciator/source_off2')
qmovha:GetUpled2Gen2Dn('sim/cockpit/electrical/generator_on[1]', true)

qmovha:GetEng2Up('sim/cockpit2/annunciators/electric_trim_off')
qmovha:GetEng2Dn('laminar/B738/annunciator/cowl_ice_on_1_annun')
qmovha:GetEng1Up('sim/cockpit2/annunciators/electric_trim_off')
qmovha:GetEng1Dn('laminar/B738/annunciator/cowl_ice_on_0_annun')
qmovha:GetWingUp('sim/cockpit2/annunciators/electric_trim_off')
qmovha:GetWingDn('laminar/B738/annunciator/wing_ice_on_L_annun')

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

qmovha:GetUpled1Onbat('sim/cockpit2/annunciators/electric_trim_off')

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

qmovha:GetBkl('laminar/B738/electric/panel_brightness[2]', 100) -- 0~1


GlobalFrameLoopManager:add(function()
    qmovha:SetDnled()
    qmovha:SetUpled1()
    qmovha:SetUpled2()

    qmovha:SetBkl()
end)
