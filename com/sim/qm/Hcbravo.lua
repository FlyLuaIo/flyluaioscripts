
-- *****************************************************************
-- Don't modify this file, Most of the code is auto generated
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-03-25_12_44_33UTC
-- *****************************************************************

local Hcbravo = oop.class(com.sim.Qmdev)
function Hcbravo:init()
    self.QmdevId = 0xE2F65B0
	self.FastTurnsPerSecond = 5
	if _G.ilua_hw_assigned_hcbravo == nil then
		_G.ilua_hw_assigned_hcbravo = 0
	end
end

function Hcbravo:absent(FastTurnsPerSecond)
	if not uluaFind('cpuwolf/qmdev/HCBravo/LED/int') then
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
	uluaSet(idr_hcbravo_hid_fastkeypersec, FastTurnsPerSecond)
	return false
end

function Hcbravo:Init(FastTurnsPerSecond)
	local ftps = FastTurnsPerSecond == nil and self.FastTurnsPerSecond or FastTurnsPerSecond
	if self:absent(ftps) then
		return false
	end
	if _G.ilua_hw_assigned_hcbravo == 1 then
		return false
	end
	_G.ilua_hw_assigned_hcbravo = 1
	return true
end

-- ========
-- LED AP_hdg

function Hcbravo:GetHdg(dpath)
	self:GetBit(1, dpath)
end

function Hcbravo:SetHdg(valbase, val)
	self:SetBit(1, _G.idr_hcbravo_hid_led_ap_hdg, valbase, val)
end

-- ========
-- LED AP_nav

function Hcbravo:GetNav(dpath)
	self:GetBit(2, dpath)
end

function Hcbravo:SetNav(valbase, val)
	self:SetBit(2, _G.idr_hcbravo_hid_led_ap_nav, valbase, val)
end

-- ========
-- LED AP_apr

function Hcbravo:GetApr(dpath)
	self:GetBit(3, dpath)
end

function Hcbravo:SetApr(valbase, val)
	self:SetBit(3, _G.idr_hcbravo_hid_led_ap_apr, valbase, val)
end

-- ========
-- LED AP_rev

function Hcbravo:GetRev(dpath)
	self:GetBit(4, dpath)
end

function Hcbravo:SetRev(valbase, val)
	self:SetBit(4, _G.idr_hcbravo_hid_led_ap_rev, valbase, val)
end

-- ========
-- LED AP_alt

function Hcbravo:GetAlt(dpath)
	self:GetBit(5, dpath)
end

function Hcbravo:SetAlt(valbase, val)
	self:SetBit(5, _G.idr_hcbravo_hid_led_ap_alt, valbase, val)
end

-- ========
-- LED AP_vs

function Hcbravo:GetVs(dpath)
	self:GetBit(6, dpath)
end

function Hcbravo:SetVs(valbase, val)
	self:SetBit(6, _G.idr_hcbravo_hid_led_ap_vs, valbase, val)
end

-- ========
-- LED AP_ias

function Hcbravo:GetIas(dpath)
	self:GetBit(7, dpath)
end

function Hcbravo:SetIas(valbase, val)
	self:SetBit(7, _G.idr_hcbravo_hid_led_ap_ias, valbase, val)
end

-- ========
-- LED AP_autopilot

function Hcbravo:GetAutopilot(dpath)
	self:GetBit(8, dpath)
end

function Hcbravo:SetAutopilot(valbase, val)
	self:SetBit(8, _G.idr_hcbravo_hid_led_ap_autopilot, valbase, val)
end

-- ========
-- LED Gear_LeftGreen

function Hcbravo:GetLeftgreen(dpath)
	self:GetBit(9, dpath)
end

function Hcbravo:SetLeftgreen(valbase, val)
	self:SetBit(9, _G.idr_hcbravo_hid_led_gear_leftgreen, valbase, val)
end

-- ========
-- LED Gear_LeftRed

function Hcbravo:GetLeftred(dpath)
	self:GetBit(10, dpath)
end

function Hcbravo:SetLeftred(valbase, val)
	self:SetBit(10, _G.idr_hcbravo_hid_led_gear_leftred, valbase, val)
end

-- ========
-- LED Gear_CenterGreen

function Hcbravo:GetCentergreen(dpath)
	self:GetBit(11, dpath)
end

function Hcbravo:SetCentergreen(valbase, val)
	self:SetBit(11, _G.idr_hcbravo_hid_led_gear_centergreen, valbase, val)
end

-- ========
-- LED Gear_CenterRed

function Hcbravo:GetCenterred(dpath)
	self:GetBit(12, dpath)
end

function Hcbravo:SetCenterred(valbase, val)
	self:SetBit(12, _G.idr_hcbravo_hid_led_gear_centerred, valbase, val)
end

-- ========
-- LED Gear_RightGreen

function Hcbravo:GetRightgreen(dpath)
	self:GetBit(13, dpath)
end

function Hcbravo:SetRightgreen(valbase, val)
	self:SetBit(13, _G.idr_hcbravo_hid_led_gear_rightgreen, valbase, val)
end

-- ========
-- LED Gear_RightRed

function Hcbravo:GetRightred(dpath)
	self:GetBit(14, dpath)
end

function Hcbravo:SetRightred(valbase, val)
	self:SetBit(14, _G.idr_hcbravo_hid_led_gear_rightred, valbase, val)
end

-- ========
-- LED Light_MasterWarn

function Hcbravo:GetMasterwarn(dpath)
	self:GetBit(15, dpath)
end

function Hcbravo:SetMasterwarn(valbase, val)
	self:SetBit(15, _G.idr_hcbravo_hid_led_light_masterwarn, valbase, val)
end

-- ========
-- LED Light_EngineFire

function Hcbravo:GetEnginefire(dpath)
	self:GetBit(16, dpath)
end

function Hcbravo:SetEnginefire(valbase, val)
	self:SetBit(16, _G.idr_hcbravo_hid_led_light_enginefire, valbase, val)
end

-- ========
-- LED Light_LowOil

function Hcbravo:GetLowoil(dpath)
	self:GetBit(17, dpath)
end

function Hcbravo:SetLowoil(valbase, val)
	self:SetBit(17, _G.idr_hcbravo_hid_led_light_lowoil, valbase, val)
end

-- ========
-- LED Light_LowFuel

function Hcbravo:GetLowfuel(dpath)
	self:GetBit(18, dpath)
end

function Hcbravo:SetLowfuel(valbase, val)
	self:SetBit(18, _G.idr_hcbravo_hid_led_light_lowfuel, valbase, val)
end

-- ========
-- LED Light_Antiice

function Hcbravo:GetAntiice(dpath)
	self:GetBit(19, dpath)
end

function Hcbravo:SetAntiice(valbase, val)
	self:SetBit(19, _G.idr_hcbravo_hid_led_light_antiice, valbase, val)
end

-- ========
-- LED Light_Starter

function Hcbravo:GetStarter(dpath)
	self:GetBit(20, dpath)
end

function Hcbravo:SetStarter(valbase, val)
	self:SetBit(20, _G.idr_hcbravo_hid_led_light_starter, valbase, val)
end

-- ========
-- LED Light_APU

function Hcbravo:GetApu(dpath)
	self:GetBit(21, dpath)
end

function Hcbravo:SetApu(valbase, val)
	self:SetBit(21, _G.idr_hcbravo_hid_led_light_apu, valbase, val)
end

-- ========
-- LED Light_MasterCaution

function Hcbravo:GetMastercaution(dpath)
	self:GetBit(22, dpath)
end

function Hcbravo:SetMastercaution(valbase, val)
	self:SetBit(22, _G.idr_hcbravo_hid_led_light_mastercaution, valbase, val)
end

-- ========
-- LED Light_Vacuum

function Hcbravo:GetVacuum(dpath)
	self:GetBit(23, dpath)
end

function Hcbravo:SetVacuum(valbase, val)
	self:SetBit(23, _G.idr_hcbravo_hid_led_light_vacuum, valbase, val)
end

-- ========
-- LED Light_LowHydPressURE

function Hcbravo:GetLowhydpressure(dpath)
	self:GetBit(24, dpath)
end

function Hcbravo:SetLowhydpressure(valbase, val)
	self:SetBit(24, _G.idr_hcbravo_hid_led_light_lowhydpressure, valbase, val)
end

-- ========
-- LED Lights_AuxFuelPump

function Hcbravo:GetAuxfuelpump(dpath)
	self:GetBit(25, dpath)
end

function Hcbravo:SetAuxfuelpump(valbase, val)
	self:SetBit(25, _G.idr_hcbravo_hid_led_lights_auxfuelpump, valbase, val)
end

-- ========
-- LED Lights_ParkingBrake

function Hcbravo:GetParkingbrake(dpath)
	self:GetBit(26, dpath)
end

function Hcbravo:SetParkingbrake(valbase, val)
	self:SetBit(26, _G.idr_hcbravo_hid_led_lights_parkingbrake, valbase, val)
end

-- ========
-- LED Lights_LowVolts

function Hcbravo:GetLowvolts(dpath)
	self:GetBit(27, dpath)
end

function Hcbravo:SetLowvolts(valbase, val)
	self:SetBit(27, _G.idr_hcbravo_hid_led_lights_lowvolts, valbase, val)
end

-- ========
-- LED Lights_door

function Hcbravo:GetDoor(dpath)
	self:GetBit(28, dpath)
end

function Hcbravo:SetDoor(valbase, val)
	self:SetBit(28, _G.idr_hcbravo_hid_led_lights_door, valbase, val)
end

function Hcbravo:SetLed(valbase, val)
	self:SetHdg(valbase, val)
	self:SetNav(valbase, val)
	self:SetApr(valbase, val)
	self:SetRev(valbase, val)
	self:SetAlt(valbase, val)
	self:SetVs(valbase, val)
	self:SetIas(valbase, val)
	self:SetAutopilot(valbase, val)
	self:SetLeftgreen(valbase, val)
	self:SetLeftred(valbase, val)
	self:SetCentergreen(valbase, val)
	self:SetCenterred(valbase, val)
	self:SetRightgreen(valbase, val)
	self:SetRightred(valbase, val)
	self:SetMasterwarn(valbase, val)
	self:SetEnginefire(valbase, val)
	self:SetLowoil(valbase, val)
	self:SetLowfuel(valbase, val)
	self:SetAntiice(valbase, val)
	self:SetStarter(valbase, val)
	self:SetApu(valbase, val)
	self:SetMastercaution(valbase, val)
	self:SetVacuum(valbase, val)
	self:SetLowhydpressure(valbase, val)
	self:SetAuxfuelpump(valbase, val)
	self:SetParkingbrake(valbase, val)
	self:SetLowvolts(valbase, val)
	self:SetDoor(valbase, val)
end

--[[
hcbravo:GetHdg('')
hcbravo:GetNav('')
hcbravo:GetApr('')
hcbravo:GetRev('')
hcbravo:GetAlt('')
hcbravo:GetVs('')
hcbravo:GetIas('')
hcbravo:GetAutopilot('')
hcbravo:GetLeftgreen('')
hcbravo:GetLeftred('')
hcbravo:GetCentergreen('')
hcbravo:GetCenterred('')
hcbravo:GetRightgreen('')
hcbravo:GetRightred('')
hcbravo:GetMasterwarn('')
hcbravo:GetEnginefire('')
hcbravo:GetLowoil('')
hcbravo:GetLowfuel('')
hcbravo:GetAntiice('')
hcbravo:GetStarter('')
hcbravo:GetApu('')
hcbravo:GetMastercaution('')
hcbravo:GetVacuum('')
hcbravo:GetLowhydpressure('')
hcbravo:GetAuxfuelpump('')
hcbravo:GetParkingbrake('')
hcbravo:GetLowvolts('')
hcbravo:GetDoor('')
]]--

return Hcbravo
