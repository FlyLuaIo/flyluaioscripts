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

-- use honeycomb axis es
hcbravo:MapAxis()


--[[
local pswh8 = QmdevPosSwitchInit("(L:TLS_ENG_LEVER1POS)", 0.5, "(>L:TLS_ENG_LEVER1POS)",
    "(>L:TLS_ENG_LEVER1POS)", 1200)
local pswh9 = QmdevPosSwitchInit("(L:TLS_ENG_LEVER2POS)", 0.5, "(>L:TLS_ENG_LEVER2POS)",
    "(>L:TLS_ENG_LEVER2POS)", 1200)
local pswh10 = QmdevPosSwitchInit("(L:TLS_ENG_LEVER3POS)", 0.5, "(>L:TLS_ENG_LEVER3POS)",
    "(>L:TLS_ENG_LEVER3POS)", 1200)
local pswh11 = QmdevPosSwitchInit("(L:TLS_ENG_LEVER4POS)", 0.5, "(>L:TLS_ENG_LEVER4POS)",
    "(>L:TLS_ENG_LEVER4POS)", 1200)
local prestr = hcbravo:GenPSwStr(pswh8, nil) ..
    hcbravo:GenPSwStr(pswh9, nil) .. hcbravo:GenPSwStr(pswh10, nil) .. hcbravo:GenPSwStr(pswh11, nil)
local relstr = hcbravo:GenPSwStr(pswh8, 0) ..
    hcbravo:GenPSwStr(pswh9, 0) .. hcbravo:GenPSwStr(pswh10, 0) .. hcbravo:GenPSwStr(pswh11, 0)

hcbravo:CfgFc(8, prestr, relstr)
hcbravo:CfgFc(9, prestr .. "uluaWriteCmd('1 (>K:THROTTLE_REVERSE_THRUST_HOLD)')", relstr)
hcbravo:CfgFc(10, prestr, relstr)
hcbravo:CfgFc(11, prestr, relstr)
--]]

hcbravo:CfgRpn(9, '1 (>K:THROTTLE_REVERSE_THRUST_HOLD)',
    '0 (>K:THROTTLE_REVERSE_THRUST_HOLD) 1 (>K:THROTTLE_REVERSE_THRUST_TOGGLE)')

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

if g_hcbravo_enable_vr_functions == 1 then
    -- Big Switch 1 top
    hcbravo:CfgRpn(33, 'sim/VR/general/reset_view')

    -- Big Switch 2 top
    hcbravo:CfgRpn(35, 'sim/VR/toggle_vr')

    -- Big Switch 1 top
    hcbravo:CfgRpn(33, '1 (>A:CAMERA REQUEST ACTION)')

    -- Big Switch 7 top
    hcbravo:CfgRpn(45, 'sim/VR/toggle_3d_mouse_cursor')
else
    -- Big Switch 7 top
    hcbravo:CfgRpn(45, '1 (>K:PARKING_BRAKE_SET)', '0 (>K:PARKING_BRAKE_SET)')
end

-- 13:DEC 12:INC
function hcbravo_mode_cfg_ias()
    hcbravo:CfgRpn(13, '(L:ASAB_FCU_SPEED_DELTA) -- (>L:ASAB_FCU_SPEED_DELTA)')
    hcbravo:CfgRpn(12, '(L:ASAB_FCU_SPEED_DELTA) ++ (>L:ASAB_FCU_SPEED_DELTA)')
end

function hcbravo_mode_cfg_crs()
    hcbravo:CfgRpn(13, '(L:AB_MPL_Baro_CPT_Rotation, Number) 20 36 / - (>L:AB_MPL_Baro_CPT_Rotation)')
    hcbravo:CfgRpn(12, '(L:AB_MPL_Baro_CPT_Rotation, Number) 20 36 / + (>L:AB_MPL_Baro_CPT_Rotation)')
end

function hcbravo_mode_cfg_hdg()
    hcbravo:CfgRpn(13, '(L:ASAB_FCU_HDG_DELTA) -- (>L:ASAB_FCU_HDG_DELTA)')
    hcbravo:CfgRpn(12, '(L:ASAB_FCU_HDG_DELTA) ++ (>L:ASAB_FCU_HDG_DELTA)')
end

function hcbravo_mode_cfg_vs()
    hcbravo:CfgRpn(13, '(L:ASAB_FCU_VS_DELTA) -- (>L:ASAB_FCU_VS_DELTA)')
    hcbravo:CfgRpn(12, '(L:ASAB_FCU_VS_DELTA) ++ (>L:ASAB_FCU_VS_DELTA)')
end

function hcbravo_mode_cfg_alt()
    hcbravo:CfgRpn(13, '(L:ASAB_FCU_ALT_DELTA) -- (>L:ASAB_FCU_ALT_DELTA)')
    hcbravo:CfgRpn(12, '(L:ASAB_FCU_ALT_DELTA) ++ (>L:ASAB_FCU_ALT_DELTA)')
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
hcbravo:GetApu('(L:TLS_APU_N_OUT)')
hcbravo:GetMastercaution('(L:AB_MPL_Master_Caution_Light)')
hcbravo:GetVacuum('')
hcbravo:GetLowhydpressure('')
hcbravo:GetAuxfuelpump('')
hcbravo:GetParkingbrake('(A:BRAKE PARKING POSITION,Position)')
hcbravo:GetLowvolts('')
hcbravo:GetDoor('')



function HCBRAVO_Aero_A346_LED_UPD()
    hcbravo:SetLed()

    hcbravo:LoopAxis(1)
    hcbravo:LoopAxis(2)
    hcbravo:LoopAxis(3)
    hcbravo:LoopAxis(4)
end

GlobalFrameLoopManager:add(HCBRAVO_Aero_A346_LED_UPD)
