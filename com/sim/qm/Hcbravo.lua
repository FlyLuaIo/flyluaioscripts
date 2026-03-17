-- *****************************************************************
-- Don't modify this file
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-03-12
-- *****************************************************************
local Hcbravo = oop.class(com.sim.Qmdev)

function Hcbravo:init()
    self.QmdevId = 0x32129CCC
    _G.ilua_hw_assigned_hcbravo = 0
end

function Hcbravo:absent(FastTurnsPerSecond)
    if not uluaFind('cpuwolf/qmdev/HCBravo/LED/AP_autopilot') then
        return true
    end
    _G.idr_hcbravo_hid_led_int = uluaFind('cpuwolf/qmdev/HCBravo/LED/int')
    _G.idr_hcbravo_hid_led_ap_hdg = uluaFind('cpuwolf/qmdev/HCBravo/LED/AP_hdg')
    _G.idr_hcbravo_hid_led_ap_nav = uluaFind('cpuwolf/qmdev/HCBravo/LED/AP_nav')
    _G.idr_hcbravo_hid_led_ap_apr = uluaFind('cpuwolf/qmdev/HCBravo/LED/AP_apr')
    _G.idr_hcbravo_hid_led_ap_rev = uluaFind('cpuwolf/qmdev/HCBravo/LED/AP_rev')
    _G.idr_hcbravo_hid_led_ap_alt = uluaFind('cpuwolf/qmdev/HCBravo/LED/AP_alt')
    _G.idr_hcbravo_hid_led_ap_vs = uluaFind('cpuwolf/qmdev/HCBravo/LED/AP_vs')
    _G.idr_hcbravo_hid_led_ap_ias = uluaFind('cpuwolf/qmdev/HCBravo/LED/AP_ias')
    _G.idr_hcbravo_hid_led_ap_autopilot = uluaFind('cpuwolf/qmdev/HCBravo/LED/AP_autopilot')
    _G.idr_hcbravo_hid_led_gear_leftgreen = uluaFind('cpuwolf/qmdev/HCBravo/LED/Gear_LeftGreen')
    _G.idr_hcbravo_hid_led_gear_leftred = uluaFind('cpuwolf/qmdev/HCBravo/LED/Gear_LeftRed')
    _G.idr_hcbravo_hid_led_gear_centergreen = uluaFind('cpuwolf/qmdev/HCBravo/LED/Gear_CenterGreen')
    _G.idr_hcbravo_hid_led_gear_centerred = uluaFind('cpuwolf/qmdev/HCBravo/LED/Gear_CenterRed')
    _G.idr_hcbravo_hid_led_gear_rightgreen = uluaFind('cpuwolf/qmdev/HCBravo/LED/Gear_RightGreen')
    _G.idr_hcbravo_hid_led_gear_rightred = uluaFind('cpuwolf/qmdev/HCBravo/LED/Gear_RightRed')
    _G.idr_hcbravo_hid_led_light_masterwarn = uluaFind('cpuwolf/qmdev/HCBravo/LED/Light_MasterWarn')
    _G.idr_hcbravo_hid_led_light_enginefire = uluaFind('cpuwolf/qmdev/HCBravo/LED/Light_EngineFire')
    _G.idr_hcbravo_hid_led_light_lowoil = uluaFind('cpuwolf/qmdev/HCBravo/LED/Light_LowOil')
    _G.idr_hcbravo_hid_led_light_lowfuel = uluaFind('cpuwolf/qmdev/HCBravo/LED/Light_LowFuel')
    _G.idr_hcbravo_hid_led_light_antiice = uluaFind('cpuwolf/qmdev/HCBravo/LED/Light_Antiice')
    _G.idr_hcbravo_hid_led_light_starter = uluaFind('cpuwolf/qmdev/HCBravo/LED/Light_Starter')
    _G.idr_hcbravo_hid_led_light_apu = uluaFind('cpuwolf/qmdev/HCBravo/LED/Light_APU')
    _G.idr_hcbravo_hid_led_light_mastercaution = uluaFind('cpuwolf/qmdev/HCBravo/LED/Light_MasterCaution')
    _G.idr_hcbravo_hid_led_light_vacuum = uluaFind('cpuwolf/qmdev/HCBravo/LED/Light_Vacuum')
    _G.idr_hcbravo_hid_led_light_lowhydpressure = uluaFind('cpuwolf/qmdev/HCBravo/LED/Light_LowHydPressURE')
    _G.idr_hcbravo_hid_led_lights_auxfuelpump = uluaFind('cpuwolf/qmdev/HCBravo/LED/Lights_AuxFuelPump')
    _G.idr_hcbravo_hid_led_lights_parkingbrake = uluaFind('cpuwolf/qmdev/HCBravo/LED/Lights_ParkingBrake')
    _G.idr_hcbravo_hid_led_lights_lowvolts = uluaFind('cpuwolf/qmdev/HCBravo/LED/Lights_LowVolts')
    _G.idr_hcbravo_hid_led_lights_door = uluaFind('cpuwolf/qmdev/HCBravo/LED/Lights_door')
    _G.idr_hcbravo_hid_invalid = uluaFind('cpuwolf/qmdev/HCBravo/invalid')
    _G.idr_hcbravo_hid_fastkeypersec = uluaFind('cpuwolf/qmdev/HCBravo/fastkeypersec')
    return false
end

function Hcbravo:Init()
    if self.absent(self.FastTurnsPerSecond) then
        return false
    end
    if _G.ilua_hw_assigned_hcbravo == 1 then
        return false
    end
    _G.ilua_hw_assigned_hcbravo = 1
    return true
end

-- ========
-- Leds Hdg
function Hcbravo:GetHdg(dpath)
    self:GetBit(0, dpath)
end

function Hcbravo:SetHdg(valbase, val)
    self:SetBit(0, idr_hcbravo_hid_led_ap_hdg, valbase, val)
end

-- ========
-- Leds Nav
function Hcbravo:GetNav(dpath)
    self:GetBit(1, dpath)
end

function Hcbravo:SetNav(valbase, val)
    self:SetBit(1, idr_hcbravo_hid_led_ap_nav, valbase, val)
end

return Hcbravo
