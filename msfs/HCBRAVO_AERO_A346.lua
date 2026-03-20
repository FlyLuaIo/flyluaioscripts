--**********************Copyright***********************--
-- modified by Wei Shuai <cpuwolf@gmail.com>
-- 2026-03-20
local FastTurnsPerSecond = 30 --How many spins per second  is considered FAST?
--########################################################

if ilua_is_acfpath_excluded("pro") or ilua_is_acfpath_excluded("a34") then
    return
end

-- Do not remove below lines: hardware detection
local hcbravo = com.sim.qm.Hcbravo:new()
if not hcbravo:Init() then
    return
end
-- Do not remove above lines: hardware detection
uluaLog("HCBravo for Aerosoft A346")

-- Input Key binding
hcbravo:CfgRpn(0, '(>K:AP_PANEL_HEADING_HOLD)')

local pswh8 = QmdevPosSwitchInit("(L:TLS_ENG_LEVER1POS)", 0.5, "(>L:TLS_ENG_LEVER1POS)",
    "(>L:TLS_ENG_LEVER1POS)", 1000)
hcbravo:CfgPSw(8, pswh8, nil, 0)

local pswh9 = QmdevPosSwitchInit("(L:TLS_ENG_LEVER2POS)", 0.5, "(>L:TLS_ENG_LEVER2POS)",
    "(>L:TLS_ENG_LEVER2POS)", 1000)
hcbravo:CfgPSw(9, pswh9, nil, 0)

local pswh10 = QmdevPosSwitchInit("(L:TLS_ENG_LEVER3POS)", 0.5, "(>L:TLS_ENG_LEVER3POS)",
    "(>L:TLS_ENG_LEVER3POS)", 1000)
hcbravo:CfgPSw(10, pswh10, nil, 0)

local pswh11 = QmdevPosSwitchInit("(L:TLS_ENG_LEVER4POS)", 0.5, "(>L:TLS_ENG_LEVER4POS)",
    "(>L:TLS_ENG_LEVER4POS)", 1100)
hcbravo:CfgPSw(11, pswh11, nil, 0)

-- flap down
hcbravo:CfgRpn(14, '(>K:FLAPS_INCR)')
-- flap up
hcbravo:CfgRpn(15, '(>K:FLAPS_DECR)')

-- trim down
hcbravo:CfgRpn(21, '(>K:ELEV_TRIM_DN)')
-- trim up
hcbravo:CfgRpn(22, '(>K:ELEV_TRIM_UP)')

-- gear up, this config will not hard bind landing gear handler, you still press keyboard G to play with gear
hcbravo:CfgRpn(30, '(>K:GEAR_UP)', '(>K:GEAR_DOWN)')
-- gear down
-- hcbravo:CfgRpn(31, 'sim/flight_controls/landing_gear_down', 'sim/none/none')

if g_hcbravo_enable_vr_functions == 1 then
    -- Big Switch 1 top
    hcbravo:CfgRpn(33, 'sim/VR/general/reset_view')
    -- Big Switch 1 bottom
    --hcbravo:CfgRpn(34, 'sim/VR/general/reset_view')

    -- Big Switch 2 top
    hcbravo:CfgRpn(35, 'sim/VR/toggle_vr')
    -- Big Switch 2 bottom
    --hcbravo:CfgRpn(36, 'sim/VR/toggle_vr')

    -- Big Switch 1 top
    hcbravo:CfgRpn(33, 'sim/VR/general/reset_view')
    -- Big Switch 1 bottom
    --hcbravo:CfgRpn(34, 'sim/VR/general/reset_view')

    -- Big Switch 7 top
    hcbravo:CfgRpn(45, 'sim/VR/toggle_3d_mouse_cursor')
    -- Big Switch 7 bottom
    --hcbravo:CfgRpn(46, 'sim/VR/toggle_3d_mouse_cursor')
else
    -- Big Switch 7 top
    hcbravo:CfgRpn(45, '1 (>K:PARKING_BRAKE_SET)', '0 (>K:PARKING_BRAKE_SET)')
end

-- 13:DEC 12:INC
function hcbravo_mode_cfg_ias()
    hcbravo:CfgRpn(13, '(>K:AP_SPD_VAR_DEC)')
    hcbravo:CfgRpn(12, '(>K:AP_SPD_VAR_INC)')
end

function hcbravo_mode_cfg_crs()
    hcbravo:CfgRpn(13, '(>K:VOR1_OBI_DEC)')
    hcbravo:CfgRpn(12, '(>K:VOR1_OBI_INC)')
end

function hcbravo_mode_cfg_hdg()
    hcbravo:CfgRpn(13, '(>K:HEADING_BUG_DEC)')
    hcbravo:CfgRpn(12, '(>K:HEADING_BUG_INC)')
end

function hcbravo_mode_cfg_vs()
    hcbravo:CfgRpn(13, '(>K:AP_VS_VAR_DEC)')
    hcbravo:CfgRpn(12, '(>K:AP_VS_VAR_INC)')
end

function hcbravo_mode_cfg_alt()
    hcbravo:CfgRpn(13, '(>K:AP_ALT_VAR_DEC)')
    hcbravo:CfgRpn(12, '(>K:AP_ALT_VAR_INC)')
end

-- 20:ALT 19:VS 18:HDG 17:CRS 16:IAS
hcbravo:CfgFc(16, 'hcbravo_mode_cfg_ias()')
hcbravo:CfgFc(17, 'hcbravo_mode_cfg_crs()')
hcbravo:CfgFc(18, 'hcbravo_mode_cfg_hdg()')
hcbravo:CfgFc(19, 'hcbravo_mode_cfg_vs()')
hcbravo:CfgFc(20, 'hcbravo_mode_cfg_alt()')
-- Output Led lights
hcbravo:GetHdg('(A:AUTOPILOT HEADING LOCK,Bool)')
hcbravo:GetNav('(A:AUTOPILOT NAV1 LOCK,Bool)')
hcbravo:GetApr('(A:AUTOPILOT APPROACH HOLD,Bool)')
hcbravo:GetRev('')
hcbravo:GetAlt('(L:AB_AP_ALT_LIGHT_ON)')
hcbravo:GetVs('(A:AUTOPILOT VERTICAL HOLD, Bool)')
hcbravo:GetIas('(L:AB_AP_ATHR_LIGHT_ON)')
hcbravo:GetAutopilot('(L:AB_AP_AP1_LIGHT_ON) (L:AB_AP_AP2_LIGHT_ON) or')
hcbravo:GetLeftgreen('(L:AB_MPL_GEAR_DOWN_LIGHT_L)')
hcbravo:GetLeftred('(L:AB_MPL_GEAR_UNLOCK_LIGHT_L)')
hcbravo:GetCentergreen('(L:AB_MPL_GEAR_DOWN_LIGHT_C) (L:AB_MPL_GEAR_DOWN_LIGHT_C2) and')
hcbravo:GetCenterred('(L:AB_MPL_GEAR_UNLOCK_LIGHT_C) (L:AB_MPL_GEAR_UNLOCK_LIGHT_C2) or')
hcbravo:GetRightgreen('(L:AB_MPL_GEAR_DOWN_LIGHT_R)')
hcbravo:GetRightred('(L:AB_MPL_GEAR_UNLOCK_LIGHT_R)')
hcbravo:GetMasterwarn('(L:AB_MPL_Master_Warning_Light)')
hcbravo:GetEnginefire('')
hcbravo:GetLowoil('(A:WARNING OIL PRESSURE, Bool)')
hcbravo:GetLowfuel('(A:GENERAL ENG FUEL PRESSURE:index,Psi)')
hcbravo:GetAntiice('(A:ENG ANTI ICE:index,Bool)')
hcbravo:GetStarter('')
hcbravo:GetApu('')
hcbravo:GetMastercaution('(L:AB_MPL_Master_Caution_Light)')
hcbravo:GetVacuum('')
hcbravo:GetLowhydpressure('')
hcbravo:GetAuxfuelpump('')
hcbravo:GetParkingbrake('(A:BRAKE PARKING POSITION,Position)')
hcbravo:GetLowvolts('')
hcbravo:GetDoor('')

function HCBRAVO_Aero_A346_LED_UPD()
    hcbravo:SetLed()
end

uluaAddDoLoop("HCBRAVO_Aero_A346_LED_UPD()")
