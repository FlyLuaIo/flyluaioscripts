--**********************Copyright***********************--
-- modified by Wei Shuai <cpuwolf@gmail.com>
-- 2026-03-17
local FastTurnsPerSecond = 30 --How many spins per second  is considered FAST?
--########################################################


-- Do not remove below lines: hardware detection
local hcbravo = com.sim.qm.Hcbravo:new()
if not hcbravo:Init() then
    return
end
-- Do not remove above lines: hardware detection
uluaLog("HCBravo for GA")

-- Input Key binding
hcbravo:CfgRpn(0, '(>K:AP_PANEL_HEADING_HOLD)')


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

function HCBRAVO_GA_LED_UPD()
    hcbravo:SetLed()
end

uluaAddDoLoop("HCBRAVO_GA_LED_UPD()")
