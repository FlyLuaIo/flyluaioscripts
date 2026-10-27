-- *****************************************************************
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-10-27
-- *****************************************************************
-- QMCP737C x Bluebird Simulations B757 (MSFS 2020/2024)
-- LVar source: qmdevother/docs/bb757.html
--
-- The QMCP737C hardware is a 737-shaped combo unit (MCP + EFIS + radio +
-- exterior lights + gear/flaps/autobrake). The B757 MCP has no N1 LIMIT, no
-- ALTN/STBY, no FPV/STA/MTRS buttons and only 7 flap gates, so a few hardware
-- keys have no 757 equivalent; those are left unbound and listed at the end.
--
-- Key mapping notes (737 panel name -> B757 function):
--   0/1   CRS1 DEC/INC    -> B757_MCP_CRS_1_KNOB (0..35, x10 = degrees)
--   2     F/D ON HOLD     -> BBS_FD1_SWITCH toggle
--   3     A/T ARM         -> BBS_AUTO_THROTTLE toggle
--   7     N1              -> THR (A/T engage button)
--   9     LVL CHG         -> FLCH
--   14    HDG PUSH SYNC   -> snap BBS_AP_TARGET_HEADING to present heading
--   18    ALT PUSH DIR    -> AP_PANEL_ALTITUDE_HOLD
--   22    ALT HLD         -> B757_MCP_HOLD_1_BUTTON
--   29    ALT INTV        -> B757_MCP_HOLD_2_BUTTON
--   31    CMD B           -> CMD_2 (the model also has CMD_3, no hardware key)
--   32/33 MIN DEC/INC     -> B757_ADI_1_DH_REF (0..29)
--   34-55 EFIS            -> B757_ADI_1_* buttons / CTR_KNOB / Range_Index
--   56-61 VHF             -> VHF_L / VHF_R via *_WHOLE_INC / *_FRAC_INC
--   64-69 NAV             -> B757_MCP_FREQ_1_*_KNOB + K:NAV1_RADIO_SWAP
--   72-82 exterior lights -> overhead light switches
--   83/84 gear            -> B757_GEAR_HANDLE_POS_DELTA (+-0.03)
--   85-90 autobrake        -> BBS_AUTOBRAKE_KNOB (0 RTO / 1 OFF / 3-5 / 7 MAX)
--   91-97 flaps            -> B757_FC_FLAP_LEVER (0/17/41/67/95/125/150)
--   100-103 speed brake    -> B757_FC_SPOILER_LEVER (0 / 10 / 54 / 100)
if ilua_require_bluebird_757() then return end

-- Do not remove below lines: hardware detection
local qmcp737c = com.sim.qm.Qmcp737c.Open()
if not qmcp737c then return end
-- Do not remove above lines: hardware detection

uluaLog("QMCP737C of Bluebird B757")

-- last value pushed to each HID channel; clearing it forces a full redraw
local shown = {}
local function force_refresh()
    shown = {}
end

-- ===========================================================
-- rotary / dial keys

-- CRS1 (0..35 wrap)
qmcp737c:CfgRpn(0, "(L:B757_MCP_CRS_1_KNOB, number) 1 - dup 0 < if{ drop 35 } (>L:B757_MCP_CRS_1_KNOB, number)")
qmcp737c:CfgRpn(1, "(L:B757_MCP_CRS_1_KNOB, number) 1 + dup 35 > if{ drop 0 } (>L:B757_MCP_CRS_1_KNOB, number)")
-- flight director left
qmcp737c:CfgRpn(2, "(L:BBS_FD1_SWITCH) ! (>L:BBS_FD1_SWITCH)")
-- autothrottle arm
qmcp737c:CfgRpn(3, "(L:BBS_AUTO_THROTTLE) ! (>L:BBS_AUTO_THROTTLE)")
-- IAS / MACH knob
qmcp737c:CfgRpn(4, "(>K:AP_SPD_VAR_DEC)")
qmcp737c:CfgRpn(5, "(>K:AP_SPD_VAR_INC)")
-- MACH push (IAS/MACH changeover)
qmcp737c:CfgRpn(6, "1 (>L:B757_MCP_AP_SPD_MACH_SW)", "0 (>L:B757_MCP_AP_SPD_MACH_SW)")

-- N1 key -> THR (autothrottle engage)
qmcp737c:CfgRpn(7, "1 (>L:B757_MCP_THR_BUTTON_PRESS)", "0 (>L:B757_MCP_THR_BUTTON_PRESS)")
-- SPEED
qmcp737c:CfgRpn(8, "1 (>L:B757_MCP_SPD_BUTTON_PRESS)", "0 (>L:B757_MCP_SPD_BUTTON_PRESS)")
-- LVL CHG -> FLCH
qmcp737c:CfgRpn(9, "1 (>L:B757_MCP_FLCH_BUTTON_PRESS)", "0 (>L:B757_MCP_FLCH_BUTTON_PRESS)")
-- SPD INTV
qmcp737c:CfgRpn(10, "1 (>L:B757_MCP_IAS_MACH_KNOB_BUTTON)", "0 (>L:B757_MCP_IAS_MACH_KNOB_BUTTON)")
-- VNAV
qmcp737c:CfgRpn(11, "1 (>L:B757_MCP_VNAV_BUTTON_PRESS)", "0 (>L:B757_MCP_VNAV_BUTTON_PRESS)")

-- HDG knob: the model lets us write the selected heading directly
qmcp737c:CfgRpn(12, "(L:BBS_AP_TARGET_HEADING, number) 1 - dup 0 < if{ drop 359 } (>L:BBS_AP_TARGET_HEADING, number)")
qmcp737c:CfgRpn(13, "(L:BBS_AP_TARGET_HEADING, number) 1 + dup 360 >= if{ drop 0 } (>L:BBS_AP_TARGET_HEADING, number)")
-- HDG push = sync bug to present heading
qmcp737c:CfgRpn(14, "(A:PLANE HEADING DEGREES GYRO, degrees) near (>L:BBS_AP_TARGET_HEADING, number)")
-- HDG SEL
qmcp737c:CfgRpn(15, "1 (>L:B757_MCP_HDG_SEL)", "0 (>L:B757_MCP_HDG_SEL)")

-- ALT knob
qmcp737c:CfgRpn(16, "(>K:AP_ALT_VAR_DEC)")
qmcp737c:CfgRpn(17, "(>K:AP_ALT_VAR_INC)")
-- ALT push = altitude hold
qmcp737c:CfgRpn(18, "(>K:AP_PANEL_ALTITUDE_HOLD)")

-- LNAV / LOC / APP
qmcp737c:CfgRpn(19, "1 (>L:B757_MCP_LNAV_BUTTON_PRESS)", "0 (>L:B757_MCP_LNAV_BUTTON_PRESS)")
qmcp737c:CfgRpn(20, "1 (>L:B757_MCP_LOC_BUTTON_PRESS)", "0 (>L:B757_MCP_LOC_BUTTON_PRESS)")
qmcp737c:CfgRpn(21, "1 (>L:B757_MCP_APP_BUTTON_PRESS)", "0 (>L:B757_MCP_APP_BUTTON_PRESS)")
-- ALT HLD / ALT INTV -> the two HOLD buttons of the model
qmcp737c:CfgRpn(22, "1 (>L:B757_MCP_HOLD_1_BUTTON_PRESS)", "0 (>L:B757_MCP_HOLD_1_BUTTON_PRESS)")
qmcp737c:CfgRpn(29, "1 (>L:B757_MCP_HOLD_2_BUTTON_PRESS)", "0 (>L:B757_MCP_HOLD_2_BUTTON_PRESS)")
-- VS mode + wheel
qmcp737c:CfgRpn(23, "1 (>L:B757_MCP_VS_BUTTON_PRESS)", "0 (>L:B757_MCP_VS_BUTTON_PRESS)")
qmcp737c:CfgRpn(24, "(>K:AP_VS_VAR_DEC)")
qmcp737c:CfgRpn(25, "(>K:AP_VS_VAR_INC)")

-- CRS2 (0..35 wrap); the B757 CRS knob has no push function
qmcp737c:CfgRpn(26, "(L:B757_MCP_CRS_2_KNOB, number) 1 - dup 0 < if{ drop 35 } (>L:B757_MCP_CRS_2_KNOB, number)")
qmcp737c:CfgRpn(27, "(L:B757_MCP_CRS_2_KNOB, number) 1 + dup 35 > if{ drop 0 } (>L:B757_MCP_CRS_2_KNOB, number)")

-- CMD A / CMD B
qmcp737c:CfgRpn(30, "1 (>L:B757_MCP_CMD_1_BUTTON_PRESS)", "0 (>L:B757_MCP_CMD_1_BUTTON_PRESS)")
qmcp737c:CfgRpn(31, "1 (>L:B757_MCP_CMD_2_BUTTON_PRESS)", "0 (>L:B757_MCP_CMD_2_BUTTON_PRESS)")

-- ===========================================================
-- EFIS (the model only exposes the captain side)
-- minimums: B757_ADI_1_DH_REF 0..29
qmcp737c:CfgRpn(32, "(L:B757_ADI_1_DH_REF, number) 1 - dup 0 < if{ drop 29 } (>L:B757_ADI_1_DH_REF, number)")
qmcp737c:CfgRpn(33, "(L:B757_ADI_1_DH_REF, number) 1 + dup 29 > if{ drop 0 } (>L:B757_ADI_1_DH_REF, number)")
-- VOR1 ON / INOP
qmcp737c:CfgRpn(34, "1 (>L:B757_MCP_VORDME_1_BUTTON)", "0 (>L:B757_MCP_VORDME_1_BUTTON)")
qmcp737c:CfgRpn(35, "(L:B757_ADI_1_INOP_BUTTON) ! (>L:B757_ADI_1_INOP_BUTTON)")
-- WXR / STA (radar STA-MAP button)
qmcp737c:CfgRpn(38, "(L:B757_ADI_1_WXR_BUTTON) ! (>L:B757_ADI_1_WXR_BUTTON)")
qmcp737c:CfgRpn(39, "1 (>L:B757_PED_WX_L_MAP_BUTTON)", "0 (>L:B757_PED_WX_L_MAP_BUTTON)")
-- centre mode knob: 0 VOR / 1 APP / 2 MAP / 3 PLAN
qmcp737c:CfgRpn(41, "(L:B757_ADI_1_CTR_KNOB, number) 1 + dup 3 > if{ drop 0 } (>L:B757_ADI_1_CTR_KNOB, number)")
qmcp737c:CfgRpn(42, "(L:B757_ADI_1_CTR_KNOB, number) 1 - dup 0 < if{ drop 3 } (>L:B757_ADI_1_CTR_KNOB, number)")
-- WPT / ARPT / DATA / NAV AID
qmcp737c:CfgRpn(44, "(L:B757_ADI_1_WPT_BUTTON) ! (>L:B757_ADI_1_WPT_BUTTON)")
qmcp737c:CfgRpn(45, "(L:B757_ADI_1_APRT_BUTTON) ! (>L:B757_ADI_1_APRT_BUTTON)")
qmcp737c:CfgRpn(46, "(L:B757_ADI_1_DATA_BUTTON) ! (>L:B757_ADI_1_DATA_BUTTON)")
qmcp737c:CfgRpn(47, "(L:B757_ADI_1_NAV_AID_BUTTON) ! (>L:B757_ADI_1_NAV_AID_BUTTON)")
-- baro (no LVar in the model, use the standard sim events)
qmcp737c:CfgRpn(48, "(>K:KOHLSMAN_DEC)")
qmcp737c:CfgRpn(49, "(>K:KOHLSMAN_INC)")
qmcp737c:CfgRpn(50, "(>K:BAROMETRIC)")
-- ND range 0..5 (10/20/40/80/160/320 NM)
qmcp737c:CfgRpn(51, "(L:BBS_ND1_Range_Index, number) 1 - dup 0 < if{ drop 0 } (>L:BBS_ND1_Range_Index, number)")
qmcp737c:CfgRpn(52, "(L:BBS_ND1_Range_Index, number) 1 + dup 5 > if{ drop 5 } (>L:BBS_ND1_Range_Index, number)")
-- TERR
qmcp737c:CfgRpn(70, "(L:B757_ADI_1_TERR_BUTTON) ! (>L:B757_ADI_1_TERR_BUTTON)")
-- TFC
qmcp737c:CfgRpn(53, "1 (>L:B757_ADI_1_TFC_BUTTON)", "0 (>L:B757_ADI_1_TFC_BUTTON)")
-- VOR2
qmcp737c:CfgRpn(54, "1 (>L:B757_MCP_VORDME_2_BUTTON)", "0 (>L:B757_MCP_VORDME_2_BUTTON)")

-- ===========================================================
-- VHF radios: VHF L = COM1, VHF R = COM2, VHF C = COM3
-- key 60 selects which radio the tuning knobs drive (L -> R -> C -> L)
-- the *_INC LVars are step requests, so the value is written and cleared
-- again shortly after (a fast spin can drop a detent, acceptable in practice)
local vhf_sel = "L"

local function vhf_radio()
    if vhf_sel == "R" then return "B757_VHF_R" end
    if vhf_sel == "C" then return "B757_VHF_C" end
    return "B757_VHF_L"
end

function vhf_clear()
    uluaWriteCmd("0 (>L:B757_VHF_L_WHOLE_INC) 0 (>L:B757_VHF_L_FRAC_INC)")
    uluaWriteCmd("0 (>L:B757_VHF_R_WHOLE_INC) 0 (>L:B757_VHF_R_FRAC_INC)")
    uluaWriteCmd("0 (>L:B757_VHF_C_WHOLE_INC) 0 (>L:B757_VHF_C_FRAC_INC)")
end

function vhf_step(part, dir)
    uluaWriteCmd(string.format("%d (>L:%s_%s_INC)", dir, vhf_radio(), part))
    uluasetTimeout("vhf_clear()", 150)
end

function vhf_toggle()
    if vhf_sel == "L" then
        vhf_sel = "R"
    elseif vhf_sel == "R" then
        vhf_sel = "C"
    else
        vhf_sel = "L"
    end
    force_refresh() -- radio windows changed, redraw them at once
end

-- active/standby swap of the selected radio (COM3 has no swap button)
function comhead_press()
    if vhf_sel == "R" then
        uluaWriteCmd("1 (>L:B757_PED_COMHEAD_2_SWAP_BUTTON)")
        uluasetTimeout("uluaWriteCmd('0 (>L:B757_PED_COMHEAD_2_SWAP_BUTTON)')", 200)
    else
        uluaWriteCmd("1 (>L:B757_PED_COMHEAD_1_SWAP_BUTTON)")
        uluasetTimeout("uluaWriteCmd('0 (>L:B757_PED_COMHEAD_1_SWAP_BUTTON)')", 200)
    end
end

qmcp737c:CfgFc(56, "vhf_step('FRAC', -1)")
qmcp737c:CfgFc(57, "vhf_step('FRAC', 1)")
qmcp737c:CfgFc(58, "vhf_step('WHOLE', -1)")
qmcp737c:CfgFc(59, "vhf_step('WHOLE', 1)")
qmcp737c:CfgFc(60, "vhf_toggle()")
qmcp737c:CfgFc(61, "comhead_press()")

-- NAV tuning: FREQ knobs are 0..35 wrap (lower = fraction, upper = whole)
qmcp737c:CfgRpn(64, "(L:B757_MCP_FREQ_1_LWR_KNOB, number) 1 - dup 0 < if{ drop 35 } (>L:B757_MCP_FREQ_1_LWR_KNOB, number)")
qmcp737c:CfgRpn(65, "(L:B757_MCP_FREQ_1_LWR_KNOB, number) 1 + dup 35 > if{ drop 0 } (>L:B757_MCP_FREQ_1_LWR_KNOB, number)")
qmcp737c:CfgRpn(66, "(L:B757_MCP_FREQ_1_UPR_KNOB, number) 1 - dup 0 < if{ drop 35 } (>L:B757_MCP_FREQ_1_UPR_KNOB, number)")
qmcp737c:CfgRpn(67, "(L:B757_MCP_FREQ_1_UPR_KNOB, number) 1 + dup 35 > if{ drop 0 } (>L:B757_MCP_FREQ_1_UPR_KNOB, number)")

-- ===========================================================
-- autopilot disengage
qmcp737c:CfgRpn(71, "(>K:AUTOPILOT_OFF)")

-- ===========================================================
-- exterior lights (the B757 has no wheel-well or steady light)
qmcp737c:CfgRpn(72, "(L:B757_OVHD_NOSE_LANDING_LIGHT) ! (>L:B757_OVHD_NOSE_LANDING_LIGHT)")
qmcp737c:CfgRpn(73, "(L:B757_OVHD_RWY_TURN_R) ! (>L:B757_OVHD_RWY_TURN_R)")
qmcp737c:CfgRpn(74, "(L:B757_OVHD_RWY_TURN_L) ! (>L:B757_OVHD_RWY_TURN_L)")
qmcp737c:CfgRpn(76, "(L:B757_OVHD_WING_LIGHTS) ! (>L:B757_OVHD_WING_LIGHTS)")
qmcp737c:CfgRpn(77, "(L:B757_OVHD_BEACON_LIGHT) ! (>L:B757_OVHD_BEACON_LIGHT)")
qmcp737c:CfgRpn(79, "(L:B757_OVHD_STROBE) ! (>L:B757_OVHD_STROBE)")
qmcp737c:CfgRpn(80, "(L:B757_OVHD_RIGHT_LANDING_LIGHT) ! (>L:B757_OVHD_RIGHT_LANDING_LIGHT)")
qmcp737c:CfgRpn(81, "(L:B757_OVHD_LEFT_LANDING_LIGHT) ! (>L:B757_OVHD_LEFT_LANDING_LIGHT)")
qmcp737c:CfgRpn(82, "(L:B757_OVHD_LOGO_BUTTON) ! (>L:B757_OVHD_LOGO_BUTTON)")

-- ===========================================================
-- landing gear handle (+-0.03 per detent)
qmcp737c:CfgRpn(83, "0.03 (>L:B757_GEAR_HANDLE_POS_DELTA)", "0 (>L:B757_GEAR_HANDLE_POS_DELTA)")
qmcp737c:CfgRpn(84, "-0.03 (>L:B757_GEAR_HANDLE_POS_DELTA)", "0 (>L:B757_GEAR_HANDLE_POS_DELTA)")

-- autobrake: 0 RTO / 1 OFF / 3 = 1 / 4 = 2 / 5 = 3 / 7 = MAX
qmcp737c:CfgRpn(85, "0 (>L:BBS_AUTOBRAKE_KNOB, number)")
qmcp737c:CfgRpn(86, "1 (>L:BBS_AUTOBRAKE_KNOB, number)")
qmcp737c:CfgRpn(87, "3 (>L:BBS_AUTOBRAKE_KNOB, number)")
qmcp737c:CfgRpn(88, "4 (>L:BBS_AUTOBRAKE_KNOB, number)")
qmcp737c:CfgRpn(89, "5 (>L:BBS_AUTOBRAKE_KNOB, number)")
qmcp737c:CfgRpn(90, "7 (>L:BBS_AUTOBRAKE_KNOB, number)")

-- flaps: 0 UP / 17 = 1 / 41 = 5 / 67 = 15 / 95 = 20 / 125 = 25 / 150 = 30
qmcp737c:CfgRpn(91, "0 (>L:B757_FC_FLAP_LEVER, number)")
qmcp737c:CfgRpn(92, "17 (>L:B757_FC_FLAP_LEVER, number)")
qmcp737c:CfgRpn(93, "41 (>L:B757_FC_FLAP_LEVER, number)")
qmcp737c:CfgRpn(94, "67 (>L:B757_FC_FLAP_LEVER, number)")
qmcp737c:CfgRpn(95, "95 (>L:B757_FC_FLAP_LEVER, number)")
qmcp737c:CfgRpn(96, "125 (>L:B757_FC_FLAP_LEVER, number)")
qmcp737c:CfgRpn(97, "150 (>L:B757_FC_FLAP_LEVER, number)")

-- speed brake: 0 DOWN / 10 ARMED / 54 flight detent / 100 UP
qmcp737c:CfgRpn(100, "0 (>L:B757_FC_SPOILER_LEVER, number)")
qmcp737c:CfgRpn(101, "10 (>L:B757_FC_SPOILER_LEVER, number)")
qmcp737c:CfgRpn(102, "54 (>L:B757_FC_SPOILER_LEVER, number)")
qmcp737c:CfgRpn(103, "100 (>L:B757_FC_SPOILER_LEVER, number)")

-- ===========================================================
-- display / led data
local dr_test = iDataRef:New("(L:OVHD_TEST_LTS)")
local dr_bat = iDataRef:New("(L:B757_OVHD_BATTERY_BUTTON)")
local dr_ext = iDataRef:New("(L:B757_OVHD_EXT_PWR_BUTTON_ON)")

-- MCP windows
local d_crs1 = iDataRef:New("(L:B757_MCP_CRS_1_KNOB, number)")
local d_crs2 = iDataRef:New("(L:B757_MCP_CRS_2_KNOB, number)")
local d_hdg = iDataRef:New("(L:BBS_AP_TARGET_HEADING, number)")
local d_alt = iDataRef:New("(L:BBS_AP_TARGET_ALTITUDE, number)")
local d_vs = iDataRef:New("(L:BBS_AP_TARGET_VS, number)")
local d_vs_blank = iDataRef:New("(L:BBS_VS_BLANKED)")
-- the model publishes MCP speed only as drum animation LVars, so the selected
-- speed is taken from the standard simvars (verify in sim; if the model does
-- not write them the speed window stays blank)
local d_ias = iDataRef:New("(A:AUTOPILOT AIRSPEED HOLD VAR, knots)")
local d_mach = iDataRef:New("(A:AUTOPILOT MACH HOLD VAR, mach)")
local d_is_mach = iDataRef:New("(L:BBS_AIRSPEED_IN_MACH)")
local d_ias_blank = iDataRef:New("(L:BBS_IAS_BLANKED)")

-- radio windows
local d_com = iDataRef:New("(A:COM ACTIVE FREQUENCY:1, kHz)")
local d_coms = iDataRef:New("(A:COM STANDBY FREQUENCY:1, kHz)")
local d_com2 = iDataRef:New("(A:COM ACTIVE FREQUENCY:2, kHz)")
local d_com2s = iDataRef:New("(A:COM STANDBY FREQUENCY:2, kHz)")
local d_nav = iDataRef:New("(A:NAV ACTIVE FREQUENCY:1, MHz)")
local d_navs = iDataRef:New("(A:NAV STANDBY FREQUENCY:1, MHz)")
local d_nav2 = iDataRef:New("(A:NAV ACTIVE FREQUENCY:2, MHz)")
local d_nav2s = iDataRef:New("(A:NAV STANDBY FREQUENCY:2, MHz)")

-- leds
local led_app = iDataRef:New("(L:B757_MCP_APP_BUTTON)")
local led_alth = iDataRef:New("(L:B757_MCP_HOLD_1_BUTTON)")
local led_vs = iDataRef:New("(L:B757_MCP_VS_BUTTON)")
local led_cmda = iDataRef:New("(L:B757_MCP_CMD_1_BUTTON)")
local led_cmdb = iDataRef:New("(L:B757_MCP_CMD_2_BUTTON)")
local led_lgn = iDataRef:New("(L:B757_MAIN_light_landingGear_nose)")
local led_lgl = iDataRef:New("(L:B757_MAIN_light_landingGear_gear)")
local led_lgr = iDataRef:New("(L:B757_MAIN_light_landingGear_gear)")
local led_ma = iDataRef:New("(A:AUTOPILOT MASTER, Bool)")
local led_spd = iDataRef:New("(L:B757_MCP_SPD_BUTTON)")
local led_lvl = iDataRef:New("(L:B757_MCP_FLCH_BUTTON)")
local led_vnav = iDataRef:New("(L:B757_MCP_VNAV_BUTTON)")
local led_hdgs = iDataRef:New("(A:AUTOPILOT HEADING LOCK, Bool)")
local led_lnav = iDataRef:New("(L:B757_MCP_LNAV_BUTTON)")
local led_vorl = iDataRef:New("(L:B757_MCP_LOC_BUTTON)")
local led_at = iDataRef:New("(L:BBS_AUTO_THROTTLE)")
-- the B757 has no N1 mode, idr_qmcp737c_hid_ledn1 is always written as 0

-- panel brightness (0..20 knob -> 0..100)
local d_bright = iDataRef:New("(L:B757_MAIN_PANEL_FLOOD_KNOB, number)")

-- ===========================================================
-- write helper: only touch the HID when the value actually changes
local function setv(idr, val)
    if shown[idr] ~= val then
        shown[idr] = val
        uluaSet(idr, val)
    end
end

local function b2i(idr)
    if idr:Get() > 0 then return 1 end
    return 0
end

-- ===========================================================
local last_power = -1
local last_test = -1
local blink = 0

GlobalFrameLoopManager:add(function()
    local powered = (dr_bat:Get() >= 1 or dr_ext:Get() >= 1) and 1 or 0
    local test = dr_test:Get()
    blink = 1 - blink

    if powered ~= last_power then
        last_power = powered
        force_refresh() -- full redraw after a power transition
    end
    if test ~= last_test then
        last_test = test
        force_refresh()
    end

    if powered == 0 then
        -- blank every window and the led block
        setv(idr_qmcp737c_hid_leds, 0)
        setv(idr_qmcp737c_hid_crs1mod, 0)
        setv(idr_qmcp737c_hid_crs2mod, 0)
        setv(idr_qmcp737c_hid_iasmod, 4)
        setv(idr_qmcp737c_hid_hdgmod, 0)
        setv(idr_qmcp737c_hid_altmod, 2)
        setv(idr_qmcp737c_hid_vsmod, 2)
        setv(idr_qmcp737c_hid_vhfa, 0)
        setv(idr_qmcp737c_hid_vhfs, 0)
        setv(idr_qmcp737c_hid_navamod, 0)
        setv(idr_qmcp737c_hid_navsmod, 0)
        setv(idr_qmcp737c_hid_bright, 0)
        setv(idr_qmcp737c_hid_dispbright, 0)
        setv(idr_qmcp737c_hid_brightmod, 2)
        return
    end

    -- brightness
    local bright = math.floor(d_bright:Get() * 5)
    if bright < 0 then bright = 0 end
    if bright > 100 then bright = 100 end
    if test == 0 then
        setv(idr_qmcp737c_hid_brightmod, 0)
        setv(idr_qmcp737c_hid_bright, bright)
        setv(idr_qmcp737c_hid_dispbright, bright)
    else
        -- lamp test: alternate all-on and blank
        if blink == 1 then
            setv(idr_qmcp737c_hid_brightmod, 1)
            setv(idr_qmcp737c_hid_bright, 100)
        else
            setv(idr_qmcp737c_hid_brightmod, 2)
            setv(idr_qmcp737c_hid_bright, 0)
        end
    end

    -- leds
    if test == 0 then
        setv(idr_qmcp737c_hid_leds, 0)
        setv(idr_qmcp737c_hid_ledapp, b2i(led_app))
        setv(idr_qmcp737c_hid_ledalth, b2i(led_alth))
        setv(idr_qmcp737c_hid_ledvs, b2i(led_vs))
        setv(idr_qmcp737c_hid_ledcmda, b2i(led_cmda))
        setv(idr_qmcp737c_hid_ledcmdb, b2i(led_cmdb))
        setv(idr_qmcp737c_hid_ledlgn, b2i(led_lgn))
        setv(idr_qmcp737c_hid_ledlgl, b2i(led_lgl))
        setv(idr_qmcp737c_hid_ledlgr, b2i(led_lgr))
        setv(idr_qmcp737c_hid_ledma, b2i(led_ma))
        setv(idr_qmcp737c_hid_ledn1, 0)
        setv(idr_qmcp737c_hid_ledspd, b2i(led_spd))
        setv(idr_qmcp737c_hid_ledlvl, b2i(led_lvl))
        setv(idr_qmcp737c_hid_ledvnav, b2i(led_vnav))
        setv(idr_qmcp737c_hid_ledhdgs, b2i(led_hdgs))
        setv(idr_qmcp737c_hid_ledlnav, b2i(led_lnav))
        setv(idr_qmcp737c_hid_ledvorl, b2i(led_vorl))
        setv(idr_qmcp737c_hid_ledat, b2i(led_at))
        if vhf_sel == "R" then
            setv(idr_qmcp737c_hid_ledvhf1, 0)
            setv(idr_qmcp737c_hid_ledvhf2, 1)
        else
            setv(idr_qmcp737c_hid_ledvhf1, 1)
            setv(idr_qmcp737c_hid_ledvhf2, 0)
        end
    else
        setv(idr_qmcp737c_hid_leds, 16777215)
    end

    -- MCP windows
    setv(idr_qmcp737c_hid_crs1, math.floor(d_crs1:Get() * 10 + 0.5))
    setv(idr_qmcp737c_hid_crs1mod, 1)
    setv(idr_qmcp737c_hid_crs2, math.floor(d_crs2:Get() * 10 + 0.5))
    setv(idr_qmcp737c_hid_crs2mod, 1)
    setv(idr_qmcp737c_hid_hdg, math.floor(d_hdg:Get() + 0.5))
    setv(idr_qmcp737c_hid_hdgmod, 1)
    setv(idr_qmcp737c_hid_alt, math.floor(d_alt:Get() + 0.5))
    setv(idr_qmcp737c_hid_altmod, 0)
    if d_vs_blank:Get() > 0 then
        setv(idr_qmcp737c_hid_vsmod, 2)
    else
        local vsv = math.floor(d_vs:Get() + 0.5)
        if vsv < 0 then
            setv(idr_qmcp737c_hid_vs, -vsv)
            setv(idr_qmcp737c_hid_vsmod, 1)
        else
            setv(idr_qmcp737c_hid_vs, vsv)
            setv(idr_qmcp737c_hid_vsmod, 0)
        end
    end

    -- speed window: Mach or knots, blank when the model blanks it
    if d_ias_blank:Get() > 0 then
        setv(idr_qmcp737c_hid_iasmod, 4)
    elseif d_is_mach:Get() > 0 then
        setv(idr_qmcp737c_hid_ias_f, math.floor(d_mach:Get() * 100 + 0.5))
        setv(idr_qmcp737c_hid_iasmod, 3)
    else
        setv(idr_qmcp737c_hid_ias_i, math.floor(d_ias:Get() + 0.5))
        setv(idr_qmcp737c_hid_iasmod, 0)
    end

    -- radio windows follow the selector
    if vhf_sel == "R" then
        setv(idr_qmcp737c_hid_vhfa, math.floor(d_com2:Get() + 0.5))
        setv(idr_qmcp737c_hid_vhfs, math.floor(d_com2s:Get() + 0.5))
    else
        setv(idr_qmcp737c_hid_vhfa, math.floor(d_com:Get() + 0.5))
        setv(idr_qmcp737c_hid_vhfs, math.floor(d_coms:Get() + 0.5))
    end
    setv(idr_qmcp737c_hid_nava, math.floor(d_nav:Get() * 100 + 0.5))
    setv(idr_qmcp737c_hid_navamod, 1)
    setv(idr_qmcp737c_hid_navs, math.floor(d_navs:Get() * 100 + 0.5))
    setv(idr_qmcp737c_hid_navsmod, 1)
end)

-- ===========================================================
-- hardware keys with no B757 equivalent (left unbound on purpose):
--   28    CRS2 PUSH        - the B757 course knob has no push function
--   36    MIN PUSH         - no push on the minimums knob
--   37    FPV              - the B757 EFIS has no FPV button
--   40    APP VOR MAP PLN PUSH
--   43    MTRS
--   55    VOR2 INOP HOLD   - the model only exposes the captain EFIS
--   62/63 not present in the QMCP737C key table
--   68    NAV PUSH         - no NAV1/NAV2 select, NAV1 is always tuned
--   69    NAV SWAP         - (K:NAV1_RADIO_SWAP) is not verified against the
--                            B757 radio model, bind it only after a sim check
--   75    WHEEL WELL       - not installed on the B757
--   78    STEADY           - not installed on the B757
--   98/99 FLAPS 30/40     - the B757 flap lever stops at 30 (key 97)
--
-- Notes:
--  * VHF C (COM3) is reachable with key 60 (L -> R -> C -> L); the model has
--    no COM3 swap button, so key 61 only swaps COM1/COM2.
--  * MCP speed is read from (A:AUTOPILOT AIRSPEED HOLD VAR) / MACH HOLD VAR
--    because the model publishes the speed window only as drum animation
--    LVars. Check the speed window in the sim; blank it if the model does not
--    write those simvars.
--  * The B757 has no N1 mode, so idr_qmcp737c_hid_ledn1 is written as 0 and
--    the N1 key is used for THR (autothrottle engage).
