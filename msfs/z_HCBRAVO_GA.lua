--**********************Copyright***********************--
-- modified by Wei Shuai <cpuwolf@gmail.com>
-- 2026-03-12
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
hcbravo:CfgCmd(0, "(>K:AP_PANEL_HEADING_HOLD)")


-- Output Led lights
hcbravo:GetHdg("(A:AUTOPILOT HEADING LOCK,Bool)")
hcbravo:GetNav("(A:AUTOPILOT NAV1 LOCK,Bool)")

function HCBRAVO_GA_LED_UPD()
    hcbravo:SetHdg()
    hcbravo:SetNav()
end

uluaAddDoLoop("HCBRAVO_GA_LED_UPD()")
