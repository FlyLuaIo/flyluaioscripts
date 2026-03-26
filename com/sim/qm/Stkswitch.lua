
-- *****************************************************************
-- Don't modify this file, unless you know what you are doing
-- Most of the code are auto generated
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-03-26_10_40_00UTC
-- *****************************************************************

local Stkswitch = oop.class(com.sim.Qmdev)
function Stkswitch:init()
	self.QmdevId = 0x1E0888B9
	self.FastTurnsPerSecond = 5
	if _G.ilua_hw_assigned_stkswitch == nil then
		_G.ilua_hw_assigned_stkswitch = 0
	end
end

function Stkswitch:absent(FastTurnsPerSecond)
	if not uluaFind('cpuwolf/qmdev/StkSwitch/LED/int') then
		return true
	end
	_G.idr_stkswitch_hid_led_int = uluaFind('cpuwolf/qmdev/StkSwitch/LED/int')
	_G.idr_stkswitch_hid_led_greenn = uluaFind('cpuwolf/qmdev/StkSwitch/LED/GreenN')
	_G.idr_stkswitch_hid_led_greenl = uluaFind('cpuwolf/qmdev/StkSwitch/LED/GreenL')
	_G.idr_stkswitch_hid_led_greenr = uluaFind('cpuwolf/qmdev/StkSwitch/LED/GreenR')
	_G.idr_stkswitch_hid_led_redn = uluaFind('cpuwolf/qmdev/StkSwitch/LED/RedN')
	_G.idr_stkswitch_hid_led_redl = uluaFind('cpuwolf/qmdev/StkSwitch/LED/RedL')
	_G.idr_stkswitch_hid_led_redr = uluaFind('cpuwolf/qmdev/StkSwitch/LED/RedR')
	_G.idr_stkswitch_hid_invalid = uluaFind('cpuwolf/qmdev/StkSwitch/invalid')
	_G.idr_stkswitch_hid_fastkeypersec = uluaFind('cpuwolf/qmdev/StkSwitch/fastkeypersec')
	uluaSet(_G.idr_stkswitch_hid_fastkeypersec, FastTurnsPerSecond)
	return false
end

function Stkswitch:Init(FastTurnsPerSecond)
	local ftps = FastTurnsPerSecond == nil and self.FastTurnsPerSecond or FastTurnsPerSecond
	if self:absent(ftps) then
		return false
	end
	if _G.ilua_hw_assigned_stkswitch == 1 then
		return false
	end
	_G.ilua_hw_assigned_stkswitch = 1
	return true
end

-- ========
-- LED GreenN

function Stkswitch:GetGreenn(dpath)
	self:GetBit(1, dpath)
end

function Stkswitch:SetGreenn(valbase, val)
	self:SetBit(1, _G.idr_stkswitch_hid_led_greenn, valbase, val)
end

-- ========
-- LED GreenL

function Stkswitch:GetGreenl(dpath)
	self:GetBit(2, dpath)
end

function Stkswitch:SetGreenl(valbase, val)
	self:SetBit(2, _G.idr_stkswitch_hid_led_greenl, valbase, val)
end

-- ========
-- LED GreenR

function Stkswitch:GetGreenr(dpath)
	self:GetBit(3, dpath)
end

function Stkswitch:SetGreenr(valbase, val)
	self:SetBit(3, _G.idr_stkswitch_hid_led_greenr, valbase, val)
end

-- ========
-- LED RedN

function Stkswitch:GetRedn(dpath)
	self:GetBit(4, dpath)
end

function Stkswitch:SetRedn(valbase, val)
	self:SetBit(4, _G.idr_stkswitch_hid_led_redn, valbase, val)
end

-- ========
-- LED RedL

function Stkswitch:GetRedl(dpath)
	self:GetBit(5, dpath)
end

function Stkswitch:SetRedl(valbase, val)
	self:SetBit(5, _G.idr_stkswitch_hid_led_redl, valbase, val)
end

-- ========
-- LED RedR

function Stkswitch:GetRedr(dpath)
	self:GetBit(6, dpath)
end

function Stkswitch:SetRedr(valbase, val)
	self:SetBit(6, _G.idr_stkswitch_hid_led_redr, valbase, val)
end

function Stkswitch:SetLed(valbase, val)
	self:SetGreenn(valbase, val)
	self:SetGreenl(valbase, val)
	self:SetGreenr(valbase, val)
	self:SetRedn(valbase, val)
	self:SetRedl(valbase, val)
	self:SetRedr(valbase, val)
end

return Stkswitch
