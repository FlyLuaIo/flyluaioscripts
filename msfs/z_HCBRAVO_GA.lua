--**********************Copyright***********************--
-- modified by Wei Shuai <cpuwolf@gmail.com>
-- 2026-03-17
local FastTurnsPerSecond = 30 --How many spins per second  is considered FAST?
--########################################################
if ilua_require_msfs() then
    return
end

-- Do not remove below lines: hardware detection
local hcbravo = com.sim.qm.Hcbravo:new()
if not hcbravo:Init() then
    return
end
-- Do not remove above lines: hardware detection
uluaLog("HCBravo for GA")

hcbravo:AddTogMenu("use FLAPS as Spoiler/Parking", "襟翼当减速板/刹车", "g_hcbravo_flap_spoiler_park")

-- Input Key binding
hcbravo:CfgRpn(0, '(>K:AP_PANEL_HEADING_HOLD)')



if g_hcbravo_flap_spoiler_park == 0 then
    -- flap down
    hcbravo:CfgRpn(14, '(>K:FLAPS_INCR)')
    -- flap up
    hcbravo:CfgRpn(15, '(>K:FLAPS_DECR)')
else
    -- flap down
    hcbravo:CfgRpn(14, '(>K:PARKING_BRAKES)')
    -- flap up
    hcbravo:CfgRpn(15, '(>K:SPOILERS_ARM_TOGGLE)')
end

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
hcbravo:GetAlt('(A:AUTOPILOT ALTITUDE LOCK, Bool)')
hcbravo:GetVs('(A:AUTOPILOT VERTICAL HOLD, Bool)')
hcbravo:GetIas('')
hcbravo:GetAutopilot('(A:AUTOPILOT MASTER, Bool)')
hcbravo:GetLeftgreen('(A:GEAR LEFT POSITION, percent over 100)')
hcbravo:GetLeftred('')
hcbravo:GetCentergreen('(A:GEAR CENTER POSITION, percent over 100)')
hcbravo:GetCenterred('')
hcbravo:GetRightgreen('(A:GEAR RIGHT POSITION, percent over 100)')
hcbravo:GetRightred('')
hcbravo:GetMasterwarn('(A:MASTER WARNING ACTIVE,bool)')
hcbravo:GetEnginefire('')
hcbravo:GetLowoil('(A:WARNING OIL PRESSURE, Bool)')
hcbravo:GetLowfuel('(A:GENERAL ENG FUEL PRESSURE:index,Psi)')
hcbravo:GetAntiice('(A:ENG ANTI ICE:index,Bool)')
hcbravo:GetStarter('')
hcbravo:GetApu('')
hcbravo:GetMastercaution('(A:MASTER CAUTION ACTIVE,bool)')
hcbravo:GetVacuum('')
hcbravo:GetLowhydpressure('')
hcbravo:GetAuxfuelpump('')
hcbravo:GetParkingbrake('(A:BRAKE PARKING POSITION,Position)')
hcbravo:GetLowvolts('')
hcbravo:GetDoor('')

GlobalFrameLoopManager:add(function()
    hcbravo:SetLed()
end)
