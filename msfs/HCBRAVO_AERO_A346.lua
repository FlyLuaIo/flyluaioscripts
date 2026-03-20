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

function HCBRAVO_Aero_A346_LED_UPD()
    hcbravo:SetLed()
end

uluaAddDoLoop("HCBRAVO_Aero_A346_LED_UPD()")
