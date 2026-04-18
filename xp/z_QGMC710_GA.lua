--**********************************************************************************************************--
-- PC Driver for QGMC710
-- Author: QuickMade
-- Email:  409050332@qq.com
-- Website: https://space.bilibili.com/323386663/
-- Build:  2018-12-6

-- Send 3 Bytes:
-- 1st Byte
---- B7  B6  B5 B4   B3   B2  B1  B0
---- BL  FLC VS YD XFR_R BANK NAV HDG
-- 2nd Byte
---- B7 B6  B5   B4   B3   B2  B1  B0
---- X  X  VNV  ALT  AP  XFR_L BC  APR
-- 3rd Byte
---- B7 B6 B5 B4 B3 B2 B1 B0
----  Brightness
--
-- Notes:
-- BL:backlight  1=PC control ; 0=Manual control
---- When BL=1 , 3rd byte is the brightness value  0-255

--**********************Copyright***********************--

-- modified by Wei Shuai <cpuwolf@gmail.com>
-- 2021-12-30 tested on Hot Start TBM-900 v1.1.13
--######################  Edit part  #####################
--此处调整加速点, 值越小,越容易进入加速模式,可根据自己的手感调节
local FastTurnsPerSecond = 30 --How many spins per second  is considered FAST?

-- Do not remove below lines: hardware detection
local qgmc710 = com.sim.qm.Qgmc710:new()
if not qgmc710:Init() then
    return
end
-- Do not remove above lines: hardware detection

uluaLog("QGMC710 for GA")
qgmv710_xp_cockpit_led = uluaFind('sim/cockpit/electrical/cockpit_lights')

local qgmv710_xp_flc_led
local qgmv710_xp_vs_led
local qgmv710_xp_yd_led
local qgmv710_xp_xfr_r_led
local qgmv710_xp_bank_led
local qgmv710_xp_nav_led
local qgmv710_xp_hdg_led

local qgmv710_xp_vnv_led
local qgmv710_xp_alt_led
local qgmv710_xp_ap_led
local qgmv710_xp_xfr_l_led
local qgmv710_xp_bc_led
local qgmv710_xp_apr_led

if PLANE_ICAO == 'TBM9' then
    qgmv710_xp_flc_led = uluaFind('tbm900/lights/ap/flc')
    qgmv710_xp_vs_led = uluaFind('tbm900/lights/ap/vs')
    qgmv710_xp_yd_led = uluaFind('tbm900/lights/ap/yd')
    qgmv710_xp_xfr_r_led = uluaFind('tbm900/lights/ap/comp_right')
    qgmv710_xp_bank_led = uluaFind('tbm900/lights/ap/bank')
    qgmv710_xp_nav_led = uluaFind('tbm900/lights/ap/nav')
    qgmv710_xp_hdg_led = uluaFind('tbm900/lights/ap/hdg')

    qgmv710_xp_vnv_led = uluaFind('tbm900/lights/ap/vnv')
    qgmv710_xp_alt_led = uluaFind('tbm900/lights/ap/alt')
    qgmv710_xp_ap_led = uluaFind('tbm900/lights/ap/ap')
    qgmv710_xp_xfr_l_led = uluaFind('tbm900/lights/ap/comp_left')
    qgmv710_xp_bc_led = uluaFind('tbm900/lights/ap/bc')
    qgmv710_xp_apr_led = uluaFind('tbm900/lights/ap/apr')
elseif PLANE_ICAO == 'C172' then
    qgmv710_xp_flc_led = uluaFind('sim/cockpit2/autopilot/speed_status')
    qgmv710_xp_vs_led = uluaFind('sim/cockpit2/autopilot/vvi_status')
    qgmv710_xp_yd_led = uluaFind('sim/cockpit/switches/yaw_damper_on')
    qgmv710_xp_xfr_r_led = uluaFind('sim/cockpit2/autopilot/nav_status')
    qgmv710_xp_bank_led = uluaFind('sim/cockpit2/autopilot/heading_status')
    qgmv710_xp_nav_led = uluaFind('sim/cockpit2/autopilot/nav_status')
    qgmv710_xp_hdg_led = uluaFind('sim/cockpit2/autopilot/heading_status')

    qgmv710_xp_vnv_led = uluaFind('sim/cockpit2/autopilot/vnav_status')
    qgmv710_xp_alt_led = uluaFind('sim/cockpit2/autopilot/altitude_hold_status')
    qgmv710_xp_ap_led = uluaFind('sim/cockpit2/autopilot/servos_on')
    qgmv710_xp_xfr_l_led = uluaFind('sim/cockpit2/autopilot/nav_status')
    qgmv710_xp_bc_led = uluaFind('sim/cockpit2/autopilot/backcourse_status')
    qgmv710_xp_apr_led = uluaFind('sim/cockpit2/autopilot/approach_status')
else
    qgmv710_xp_flc_led = uluaFind('sim/cockpit2/autopilot/speed_status')
    qgmv710_xp_vs_led = uluaFind('sim/cockpit2/autopilot/vvi_status')
    qgmv710_xp_yd_led = uluaFind('sim/cockpit/switches/yaw_damper_on')
    qgmv710_xp_xfr_r_led = uluaFind('sim/cockpit2/autopilot/nav_status')
    qgmv710_xp_bank_led = uluaFind('sim/cockpit2/autopilot/heading_status')
    qgmv710_xp_nav_led = uluaFind('sim/cockpit2/autopilot/nav_status')
    qgmv710_xp_hdg_led = uluaFind('sim/cockpit2/autopilot/heading_status')

    qgmv710_xp_vnv_led = uluaFind('sim/cockpit2/autopilot/vnav_status')
    qgmv710_xp_alt_led = uluaFind('sim/cockpit2/autopilot/altitude_hold_status')
    qgmv710_xp_ap_led = uluaFind('sim/cockpit2/autopilot/servos_on')
    qgmv710_xp_xfr_l_led = uluaFind('sim/cockpit2/autopilot/nav_status')
    qgmv710_xp_bc_led = uluaFind('sim/cockpit2/autopilot/backcourse_status')
    qgmv710_xp_apr_led = uluaFind('sim/cockpit2/autopilot/approach_status')
end


if PLANE_ICAO == 'B350' then
    qgmc710:CfgEncFull(18, 19, 'sim/cockpit/autopilot/heading', 1, 10, 0, 0, 360)
    qgmc710:CfgEncFull(20, 21, 'sim/cockpit/radios/nav1_obs_degm', 1, 10, 2, 0, 360)
    qgmc710:CfgEncFull(22, 23, 'sim/cockpit/autopilot/altitude', 100, 500, 0, 0, 360)
    qgmc710:CfgEncFull(26, 27, 'sim/cockpit/radios/nav2_obs_degm', 1, 10, 2, 0, 360)
    qgmc710:CfgCmd(0, 'KA350/cmd/cPanel/flightCP/hdg')
    qgmc710:CfgCmd(1, 'KA350/cmd/cPanel/flightCP/appr')
    qgmc710:CfgCmd(2, 'KA350/cmd/cPanel/flightCP/nav')
    qgmc710:CfgCmd(3, 'KA350/cmd/cPanel/pilotDisplayCP/crsPre')
    qgmc710:CfgCmd(4, 'KA350/cmd/cPanel/pilotDisplayCP/crsAct')
    qgmc710:CfgCmd(5, 'KA350/cmd/cPanel/flightCP/alt')
    qgmc710:CfgCmd(6, 'KA350/cmd/cPanel/flightCP/vs')
    qgmc710:CfgCmd(7, 'tbm900/actuators/ap/flc')
    qgmc710:CfgCmd(8, 'KA350/cmd/cPanel/flightCP/bc')
    qgmc710:CfgCmd(9, 'KA350/cmd/cPanel/autopilotCP/softRide')
    qgmc710:CfgCmd(10, 'KA350/cmd/cPanel/autopilotCP/apEng')
    qgmc710:CfgCmd(11, 'KA350/cmd/cPanel/autopilotCP/yawEng')
    qgmc710:CfgCmd(12, 'KA350/cmd/cPanel/flightCP/altSel')
    qgmc710:CfgCmd(13, 'KA350/cmd/cPanel/flightCP/ias')
    qgmc710:CfgCmd(14, 'sim/autopilot/heading_sync')
    qgmc710:CfgCmd(15, 'KA350/cmd/cPanel/efisSCP/courseDirect')
    qgmc710:CfgCmd(16, 'sim/GPS/g1000n3_hdg_sync')
    qgmc710:CfgCmd(17, 'KA350/cmd/cPanel/efisSCP/navData')
    qgmc710:CfgCmd(18, 'KA350/cmd/cPanel/efisSCP/headingInc')
    qgmc710:CfgCmd(19, 'KA350/cmd/cPanel/efisSCP/headingDec')
    qgmc710:CfgCmd(20, 'KA350/cmd/cPanel/efisSCP/courseInc')
    qgmc710:CfgCmd(21, 'KA350/cmd/cPanel/efisSCP/courseDec')
    qgmc710:CfgCmd(22, 'sim/none/none')
    qgmc710:CfgCmd(23, 'sim/none/none')
    qgmc710:CfgCmd(24, 'KA350/cmd/cPanel/autopilotCP/pitchSwitchDec')
    qgmc710:CfgCmd(25, 'KA350/cmd/cPanel/autopilotCP/pitchSwitchInc')
elseif PLANE_ICAO == 'TBM9' then
    qgmc710:CfgEncFull(18, 19, 'tbm900/knobs/ap/hdg', 1, 10, 0, 0, 360)
    qgmc710:CfgEncFull(20, 21, 'tbm900/knobs/ap/crs1', 1, 10, 0, 0, 360)
    qgmc710:CfgEncFull(22, 23, 'tbm900/knobs/ap/alt', 100, 500, 0, 0, 360)
    qgmc710:CfgEncFull(26, 27, 'tbm900/knobs/ap/crs2', 1, 10, 0, 0, 360)
    qgmc710:CfgCmd(0, 'tbm900/actuators/ap/hdg')
    qgmc710:CfgCmd(1, 'tbm900/actuators/ap/apr')
    qgmc710:CfgCmd(2, 'tbm900/actuators/ap/nav')
    qgmc710:CfgCmd(3, 'tbm900/actuators/ap/fd')
    qgmc710:CfgCmd(4, 'tbm900/actuators/ap/xfr')
    qgmc710:CfgCmd(5, 'tbm900/actuators/ap/alt')
    qgmc710:CfgCmd(6, 'tbm900/actuators/ap/vs')
    qgmc710:CfgCmd(7, 'tbm900/actuators/ap/flc')
    qgmc710:CfgCmd(8, 'tbm900/actuators/ap/bc')
    qgmc710:CfgCmd(9, 'tbm900/actuators/ap/bank')
    qgmc710:CfgCmd(10, 'tbm900/actuators/ap/ap')
    qgmc710:CfgCmd(11, 'tbm900/actuators/ap/yd')
    qgmc710:CfgCmd(12, 'tbm900/actuators/ap/vnv')
    qgmc710:CfgCmd(13, 'tbm900/actuators/ap/spd')
    qgmc710:CfgCmd(14, 'tbm900/actuators/ap/hdg_sync')
    qgmc710:CfgCmd(15, 'tbm900/actuators/ap/crs1_dr')
    qgmc710:CfgCmd(16, 'sim/GPS/g1000n3_hdg_sync')
    qgmc710:CfgCmd(17, 'tbm900/actuators/ap/crs2_dr')
    qgmc710:CfgCmd(18, 'sim/none/none')
    qgmc710:CfgCmd(19, 'sim/none/none')
    qgmc710:CfgCmd(20, 'sim/none/none')
    qgmc710:CfgCmd(21, 'sim/none/none')
    qgmc710:CfgCmd(22, 'sim/none/none')
    qgmc710:CfgCmd(23, 'sim/none/none')
    qgmc710:CfgCmd(24, 'tbm900/actuators/ap/nose_up')
    qgmc710:CfgCmd(25, 'tbm900/actuators/ap/nose_down')
else
    qgmc710:CfgEncFull(18, 19, 'sim/cockpit/autopilot/heading_mag', 1, 10, 0, 0, 360)
    qgmc710:CfgEncFull(20, 21, 'sim/cockpit2/radios/actuators/nav1_obs_deg_mag_pilot', 1, 10, 0, 0, 360)
    qgmc710:CfgEncFull(22, 23, 'sim/cockpit/autopilot/altitude', 100, 500, 0, 0, 360)
    qgmc710:CfgCmd(0, 'sim/autopilot/heading')
    qgmc710:CfgCmd(1, 'sim/autopilot/approach')
    qgmc710:CfgCmd(2, 'sim/autopilot/NAV')
    qgmc710:CfgCmd(3, 'sim/autopilot/fdir_toggle')
    qgmc710:CfgCmd(4, 'tbm900/actuators/ap/xfr')
    qgmc710:CfgCmd(5, 'sim/autopilot/altitude_hold')
    qgmc710:CfgCmd(6, 'sim/autopilot/vertical_speed')
    qgmc710:CfgCmd(7, 'sim/autopilot/level_change')
    qgmc710:CfgCmd(8, 'sim/autopilot/back_course')
    qgmc710:CfgCmd(9, 'sim/autopilot/bank_limit_toggle')
    qgmc710:CfgCmd(10, 'sim/autopilot/servos_toggle')
    qgmc710:CfgCmd(11, 'sim/systems/yaw_damper_toggle')
    qgmc710:CfgCmd(12, 'sim/autopilot/vnav')
    qgmc710:CfgCmd(13, 'sim/none/none')
    qgmc710:CfgCmd(14, 'sim/autopilot/heading_sync')
    qgmc710:CfgCmd(15, 'sim/none/none')
    qgmc710:CfgCmd(16, 'sim/GPS/g1000n3_hdg_sync')
    qgmc710:CfgCmd(17, 'sim/none/none')
    qgmc710:CfgCmd(18, 'sim/none/none')
    qgmc710:CfgCmd(19, 'sim/none/none')
    qgmc710:CfgCmd(20, 'sim/none/none')
    qgmc710:CfgCmd(21, 'sim/none/none')
    qgmc710:CfgCmd(22, 'sim/none/none')
    qgmc710:CfgCmd(23, 'sim/none/none')
    qgmc710:CfgCmd(24, 'sim/autopilot/nose_up')
    qgmc710:CfgCmd(25, 'sim/autopilot/nose_down')
    qgmc710:CfgCmd(26, 'sim/none/none')
    qgmc710:CfgCmd(27, 'sim/none/none')
end


function QGMC710_LED_UPD()
    uluaSet(idr_qgmc710_hid_ledflc, ilua_01_ternary(qgmv710_xp_flc_led, 0))
    uluaSet(idr_qgmc710_hid_ledvs, ilua_01_ternary(qgmv710_xp_vs_led, 0))
    uluaSet(idr_qgmc710_hid_ledyd, ilua_01_ternary(qgmv710_xp_yd_led, 0))
    uluaSet(idr_qgmc710_hid_ledxfrr, ilua_01_ternary(qgmv710_xp_xfr_r_led, 0))
    uluaSet(idr_qgmc710_hid_ledbank, ilua_01_ternary(qgmv710_xp_bank_led, 0))
    uluaSet(idr_qgmc710_hid_lednav, ilua_01_ternary(qgmv710_xp_nav_led, 0))
    uluaSet(idr_qgmc710_hid_ledhdg, ilua_01_ternary(qgmv710_xp_hdg_led, 0))
    uluaSet(idr_qgmc710_hid_ledvnav, ilua_01_ternary(qgmv710_xp_vnv_led, 0))
    uluaSet(idr_qgmc710_hid_ledalt, ilua_01_ternary(qgmv710_xp_alt_led, 1))
    uluaSet(idr_qgmc710_hid_ledap, ilua_01_ternary(qgmv710_xp_ap_led, 0))
    uluaSet(idr_qgmc710_hid_ledxfrl, ilua_01_ternary(qgmv710_xp_xfr_l_led, 0))
    uluaSet(idr_qgmc710_hid_ledbc, ilua_01_ternary(qgmv710_xp_bc_led, 0))
    uluaSet(idr_qgmc710_hid_ledapr, ilua_01_ternary(qgmv710_xp_apr_led, 0))

    local led_br = math.floor(uluaGet(qgmv710_xp_cockpit_led) * 255.0)
    uluaSet(idr_qgmc710_hid_bright, led_br)
end

uluaAddDoLoop('QGMC710_LED_UPD()')
