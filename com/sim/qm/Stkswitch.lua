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
	_G.idr_stkswitch_hid_led_green_n = uluaFind('cpuwolf/qmdev/StkSwitch/LED/Green_N')
	_G.idr_stkswitch_hid_led_green_l = uluaFind('cpuwolf/qmdev/StkSwitch/LED/Green_L')
	_G.idr_stkswitch_hid_led_green_r = uluaFind('cpuwolf/qmdev/StkSwitch/LED/Green_R')
	_G.idr_stkswitch_hid_led_red_n = uluaFind('cpuwolf/qmdev/StkSwitch/LED/Red_N')
	_G.idr_stkswitch_hid_led_red_l = uluaFind('cpuwolf/qmdev/StkSwitch/LED/Red_L')
	_G.idr_stkswitch_hid_led_red_r = uluaFind('cpuwolf/qmdev/StkSwitch/LED/Red_R')
	_G.idr_stkswitch_hid_invalid = uluaFind('cpuwolf/qmdev/StkSwitch/invalid')
	_G.idr_stkswitch_hid_fastkeypersec = uluaFind('cpuwolf/qmdev/StkSwitch/fastkeypersec')
	return false
end

function Stkswitch:Init()
	if self:absent(self.FastTurnsPerSecond) then
		return false
	end
	if _G.ilua_hw_assigned_stkswitch == 1 then
		return false
	end
	_G.ilua_hw_assigned_stkswitch = 1
	return true
end

-- ========
-- LED Green_N

function Stkswitch:GetN(dpath)
	self:GetBit(1, dpath)
end

function Stkswitch:SetN(valbase, val)
	self:SetBit(1, _G.idr_stkswitch_hid_led_green_n, valbase, val)
end

-- ========
-- LED Green_L

function Stkswitch:GetL(dpath)
	self:GetBit(2, dpath)
end

function Stkswitch:SetL(valbase, val)
	self:SetBit(2, _G.idr_stkswitch_hid_led_green_l, valbase, val)
end

-- ========
-- LED Green_R

function Stkswitch:GetR(dpath)
	self:GetBit(3, dpath)
end

function Stkswitch:SetR(valbase, val)
	self:SetBit(3, _G.idr_stkswitch_hid_led_green_r, valbase, val)
end

-- ========
-- LED Red_N

function Stkswitch:GetN(dpath)
	self:GetBit(4, dpath)
end

function Stkswitch:SetN(valbase, val)
	self:SetBit(4, _G.idr_stkswitch_hid_led_red_n, valbase, val)
end

-- ========
-- LED Red_L

function Stkswitch:GetL(dpath)
	self:GetBit(5, dpath)
end

function Stkswitch:SetL(valbase, val)
	self:SetBit(5, _G.idr_stkswitch_hid_led_red_l, valbase, val)
end

-- ========
-- LED Red_R

function Stkswitch:GetR(dpath)
	self:GetBit(6, dpath)
end

function Stkswitch:SetR(valbase, val)
	self:SetBit(6, _G.idr_stkswitch_hid_led_red_r, valbase, val)
end

function Stkswitch:SetLed(valbase, val)
	self:SetN(valbase, val)
	self:SetL(valbase, val)
	self:SetR(valbase, val)
	self:SetN(valbase, val)
	self:SetL(valbase, val)
	self:SetR(valbase, val)
end

--[[
stkswitch:GetN('')
stkswitch:GetL('')
stkswitch:GetR('')
stkswitch:GetN('')
stkswitch:GetL('')
stkswitch:GetR('')
]]--

return Stkswitch