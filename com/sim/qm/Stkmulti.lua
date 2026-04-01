-- *****************************************************************
-- Don't modify this file, unless you know what you are doing
-- Most of the code are auto generated
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-03-26_07_27_59UTC
-- *****************************************************************

local Stkmulti = oop.class(com.sim.Qmdev)
function Stkmulti:init()
	self.QmdevId = 0x2AC8334B
	self.FastTurnsPerSecond = 5
	if _G.ilua_hw_assigned_stkmulti == nil then
		_G.ilua_hw_assigned_stkmulti = 0
	end
end

function Stkmulti:absent(FastTurnsPerSecond)
	if not uluaFind('cpuwolf/qmdev/StkMulti/leds/up1') then
		return true
	end
	_G.idr_stkmulti_hid_leds_up1 = uluaFind('cpuwolf/qmdev/StkMulti/leds/up1')
	_G.idr_stkmulti_hid_leds_up2 = uluaFind('cpuwolf/qmdev/StkMulti/leds/up2')
	_G.idr_stkmulti_hid_leds_up3 = uluaFind('cpuwolf/qmdev/StkMulti/leds/up3')
	_G.idr_stkmulti_hid_leds_up4 = uluaFind('cpuwolf/qmdev/StkMulti/leds/up4')
	_G.idr_stkmulti_hid_leds_up5 = uluaFind('cpuwolf/qmdev/StkMulti/leds/up5')
	_G.idr_stkmulti_hid_leds_down1 = uluaFind('cpuwolf/qmdev/StkMulti/leds/down1')
	_G.idr_stkmulti_hid_leds_down2 = uluaFind('cpuwolf/qmdev/StkMulti/leds/down2')
	_G.idr_stkmulti_hid_leds_down3 = uluaFind('cpuwolf/qmdev/StkMulti/leds/down3')
	_G.idr_stkmulti_hid_leds_down4 = uluaFind('cpuwolf/qmdev/StkMulti/leds/down4')
	_G.idr_stkmulti_hid_leds_down5 = uluaFind('cpuwolf/qmdev/StkMulti/leds/down5')
	_G.idr_stkmulti_hid_leds_leds = uluaFind('cpuwolf/qmdev/StkMulti/leds/leds')
	_G.idr_stkmulti_hid_leds_ap_ap = uluaFind('cpuwolf/qmdev/StkMulti/leds/AP_ap')
	_G.idr_stkmulti_hid_leds_ap_hdg = uluaFind('cpuwolf/qmdev/StkMulti/leds/AP_hdg')
	_G.idr_stkmulti_hid_leds_ap_nav = uluaFind('cpuwolf/qmdev/StkMulti/leds/AP_nav')
	_G.idr_stkmulti_hid_leds_ap_ias = uluaFind('cpuwolf/qmdev/StkMulti/leds/AP_ias')
	_G.idr_stkmulti_hid_leds_ap_alt = uluaFind('cpuwolf/qmdev/StkMulti/leds/AP_alt')
	_G.idr_stkmulti_hid_leds_ap_vs = uluaFind('cpuwolf/qmdev/StkMulti/leds/AP_vs')
	_G.idr_stkmulti_hid_leds_ap_apr = uluaFind('cpuwolf/qmdev/StkMulti/leds/AP_apr')
	_G.idr_stkmulti_hid_leds_ap_rev = uluaFind('cpuwolf/qmdev/StkMulti/leds/AP_rev')
	_G.idr_stkmulti_hid_invalid = uluaFind('cpuwolf/qmdev/StkMulti/invalid')
	_G.idr_stkmulti_hid_fastkeypersec = uluaFind('cpuwolf/qmdev/StkMulti/fastkeypersec')
	uluaSet(_G.idr_stkmulti_hid_fastkeypersec, FastTurnsPerSecond)
	return false
end

function Stkmulti:Init(FastTurnsPerSecond)
	local ftps = FastTurnsPerSecond == nil and self.FastTurnsPerSecond or FastTurnsPerSecond
	if self:absent(ftps) then
		return false
	end
	if _G.ilua_hw_assigned_stkmulti == 1 then
		return false
	end
	_G.ilua_hw_assigned_stkmulti = 1
	return true
end

-- ========
-- leds AP_ap

function Stkmulti:GetAp(dpath)
	self:GetBit(1, dpath)
end

function Stkmulti:SetAp(valbase, val)
	self:SetBit(1, _G.idr_stkmulti_hid_leds_ap_ap, valbase, val)
end

-- ========
-- leds AP_hdg

function Stkmulti:GetHdg(dpath)
	self:GetBit(2, dpath)
end

function Stkmulti:SetHdg(valbase, val)
	self:SetBit(2, _G.idr_stkmulti_hid_leds_ap_hdg, valbase, val)
end

-- ========
-- leds AP_nav

function Stkmulti:GetNav(dpath)
	self:GetBit(3, dpath)
end

function Stkmulti:SetNav(valbase, val)
	self:SetBit(3, _G.idr_stkmulti_hid_leds_ap_nav, valbase, val)
end

-- ========
-- leds AP_ias

function Stkmulti:GetIas(dpath)
	self:GetBit(4, dpath)
end

function Stkmulti:SetIas(valbase, val)
	self:SetBit(4, _G.idr_stkmulti_hid_leds_ap_ias, valbase, val)
end

-- ========
-- leds AP_alt

function Stkmulti:GetAlt(dpath)
	self:GetBit(5, dpath)
end

function Stkmulti:SetAlt(valbase, val)
	self:SetBit(5, _G.idr_stkmulti_hid_leds_ap_alt, valbase, val)
end

-- ========
-- leds AP_vs

function Stkmulti:GetVs(dpath)
	self:GetBit(6, dpath)
end

function Stkmulti:SetVs(valbase, val)
	self:SetBit(6, _G.idr_stkmulti_hid_leds_ap_vs, valbase, val)
end

-- ========
-- leds AP_apr

function Stkmulti:GetApr(dpath)
	self:GetBit(7, dpath)
end

function Stkmulti:SetApr(valbase, val)
	self:SetBit(7, _G.idr_stkmulti_hid_leds_ap_apr, valbase, val)
end

-- ========
-- leds AP_rev

function Stkmulti:GetRev(dpath)
	self:GetBit(8, dpath)
end

function Stkmulti:SetRev(valbase, val)
	self:SetBit(8, _G.idr_stkmulti_hid_leds_ap_rev, valbase, val)
end

function Stkmulti:SetLeds(valbase, val)
	self:SetAp(valbase, val)
	self:SetHdg(valbase, val)
	self:SetNav(valbase, val)
	self:SetIas(valbase, val)
	self:SetAlt(valbase, val)
	self:SetVs(valbase, val)
	self:SetApr(valbase, val)
	self:SetRev(valbase, val)
end

-- 11850 -> {1, 1, 8, 5, 0}
-- 118255 -> {1, 1, 8, 2, 5, 5}
function Stkmulti:getDigits(num)
	-- Handle case for 0
	if num == 0 then return { 0 } end

	local digits = {}

	-- 1. Find the highest power of 10 (e.g., for 11850, power is 4)
	local power = math.floor(math.log(num, 10))

	-- 2. Iterate from the highest power down to 0
	for p = power, 0, -1 do
		local divisor = 10 ^ p

		-- Get the leftmost digit
		local digit = math.floor(num / divisor)
		table.insert(digits, digit)

		-- Update num to be the remainder
		num = num % divisor
	end

	return digits
end

function Stkmulti:encUIntDigits(intnum)
	local uint
	if intnum < 0 then
		uint = -1 * intnum
	else
		uint = intnum
	end
	local digits = self:getDigits(uint)
	local len = #digits
	if len < 5 then
		for i = 1, 5 - len do
			-- blank
			table.insert(digits, 1, 15)
		end
	end
	return digits
end

function Stkmulti:encIntDigits(intnum)
	local uint
	if intnum < 0 then
		uint = -1 * intnum
	else
		uint = intnum
	end
	local digits = self:getDigits(uint)
	local len = #digits
	if intnum < 0 then
		-- add -
		table.insert(digits, 1, 254)
		len = len + 1
	end
	if len < 5 then
		for i = 1, 5 - len do
			-- blank
			table.insert(digits, 1, 15)
		end
	end

	return digits
end

-- COM1 Active
function Stkmulti:setUp(digits)
	uluaSet(_G.idr_stkmulti_hid_leds_up1, digits[1])
	uluaSet(_G.idr_stkmulti_hid_leds_up2, digits[2])
	uluaSet(_G.idr_stkmulti_hid_leds_up3, digits[3])
	uluaSet(_G.idr_stkmulti_hid_leds_up4, digits[4])
	uluaSet(_G.idr_stkmulti_hid_leds_up5, digits[5])
end

-- COM1 Standby
function Stkmulti:setDn(digits)
	uluaSet(_G.idr_stkmulti_hid_leds_down1, digits[1])
	uluaSet(_G.idr_stkmulti_hid_leds_down2, digits[2])
	uluaSet(_G.idr_stkmulti_hid_leds_down3, digits[3])
	uluaSet(_G.idr_stkmulti_hid_leds_down4, digits[4])
	uluaSet(_G.idr_stkmulti_hid_leds_down5, digits[5])
end

return Stkmulti
