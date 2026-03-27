-- *****************************************************************
-- Don't modify this file, unless you know what you are doing
-- Most of the code are auto generated
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-03-26_05_12_35UTC
-- *****************************************************************

local Stkradio = oop.class(com.sim.Qmdev)
function Stkradio:init()
	self.QmdevId = 0x67E6B0B
	self.FastTurnsPerSecond = 5
	if _G.ilua_hw_assigned_stkradio == nil then
		_G.ilua_hw_assigned_stkradio = 0
	end
end

function Stkradio:absent(FastTurnsPerSecond)
	if not uluaFind('cpuwolf/qmdev/StkRadio/Radios/com1act1') then
		return true
	end
	_G.idr_stkradio_hid_radios_com1act1 = uluaFind('cpuwolf/qmdev/StkRadio/Radios/com1act1')
	_G.idr_stkradio_hid_radios_com1act2 = uluaFind('cpuwolf/qmdev/StkRadio/Radios/com1act2')
	_G.idr_stkradio_hid_radios_com1act3 = uluaFind('cpuwolf/qmdev/StkRadio/Radios/com1act3')
	_G.idr_stkradio_hid_radios_com1act4 = uluaFind('cpuwolf/qmdev/StkRadio/Radios/com1act4')
	_G.idr_stkradio_hid_radios_com1act5 = uluaFind('cpuwolf/qmdev/StkRadio/Radios/com1act5')
	_G.idr_stkradio_hid_radios_com1stb1 = uluaFind('cpuwolf/qmdev/StkRadio/Radios/com1stb1')
	_G.idr_stkradio_hid_radios_com1stb2 = uluaFind('cpuwolf/qmdev/StkRadio/Radios/com1stb2')
	_G.idr_stkradio_hid_radios_com1stb3 = uluaFind('cpuwolf/qmdev/StkRadio/Radios/com1stb3')
	_G.idr_stkradio_hid_radios_com1stb4 = uluaFind('cpuwolf/qmdev/StkRadio/Radios/com1stb4')
	_G.idr_stkradio_hid_radios_com1stb5 = uluaFind('cpuwolf/qmdev/StkRadio/Radios/com1stb5')
	_G.idr_stkradio_hid_radios_com2act1 = uluaFind('cpuwolf/qmdev/StkRadio/Radios/com2act1')
	_G.idr_stkradio_hid_radios_com2act2 = uluaFind('cpuwolf/qmdev/StkRadio/Radios/com2act2')
	_G.idr_stkradio_hid_radios_com2act3 = uluaFind('cpuwolf/qmdev/StkRadio/Radios/com2act3')
	_G.idr_stkradio_hid_radios_com2act4 = uluaFind('cpuwolf/qmdev/StkRadio/Radios/com2act4')
	_G.idr_stkradio_hid_radios_com2act5 = uluaFind('cpuwolf/qmdev/StkRadio/Radios/com2act5')
	_G.idr_stkradio_hid_radios_com2stb1 = uluaFind('cpuwolf/qmdev/StkRadio/Radios/com2stb1')
	_G.idr_stkradio_hid_radios_com2stb2 = uluaFind('cpuwolf/qmdev/StkRadio/Radios/com2stb2')
	_G.idr_stkradio_hid_radios_com2stb3 = uluaFind('cpuwolf/qmdev/StkRadio/Radios/com2stb3')
	_G.idr_stkradio_hid_radios_com2stb4 = uluaFind('cpuwolf/qmdev/StkRadio/Radios/com2stb4')
	_G.idr_stkradio_hid_radios_com2stb5 = uluaFind('cpuwolf/qmdev/StkRadio/Radios/com2stb5')
	_G.idr_stkradio_hid_invalid = uluaFind('cpuwolf/qmdev/StkRadio/invalid')
	_G.idr_stkradio_hid_fastkeypersec = uluaFind('cpuwolf/qmdev/StkRadio/fastkeypersec')
	uluaSet(_G.idr_stkradio_hid_fastkeypersec, FastTurnsPerSecond)
	return false
end

function Stkradio:Init(FastTurnsPerSecond)
	local ftps = FastTurnsPerSecond == nil and self.FastTurnsPerSecond or FastTurnsPerSecond
	if self:absent(ftps) then
		return false
	end
	if _G.ilua_hw_assigned_stkradio == 1 then
		return false
	end
	_G.ilua_hw_assigned_stkradio = 1
	return true
end

-- 11850 -> {1, 1, 8, 5, 0}
-- 118255 -> {1, 1, 8, 2, 5, 5}
function Stkradio:getDigits(num)
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

-- RMP1
function Stkradio:GetRmp1(dcom1, dcom1s, scale)
	self.d_rmp1_scale = scale == nil and 1 or scale
	self.d_rmp1 = iDataRef:New(dcom1)
	self.d_rmp1s = iDataRef:New(dcom1s)
end

function Stkradio:SetRmp1A(val)
	if val == nil then
		if self.d_rmp1:ChanedUpdate() then
			val = self.d_rmp1:GetOld()
			if val > 0 then
				self:setCom1A(val * self.d_rmp1_scale)
			end
		end
	else
		self:setCom1A(val)
	end
end

function Stkradio:SetRmp1S(val)
	if val == nil then
		if self.d_rmp1s:ChangedUpdate() then
			local val = self.d_rmp1s:GetOld()
			if val > 0 then
				self:setCom1S(val * self.d_rmp1_scale)
			end
		end
	else
		self:setCom1S(val)
	end
end

function Stkradio:encFloatDigits(floatnum, decmlong)
	decmlong = decmlong == nil and 1 or decmlong
	local intnum = math.floor(floatnum * (10 ^ decmlong))
	local digits = self:getDigits(intnum)
	local len = #digits
	if len < 5 then
		for i = 1, 5 - len do
			-- blank
			table.insert(digits, 1, 15)
			len = len + 1
		end
	else
		for i = 1, len - 5 do
			table.remove(digits, 1)
		end
	end
	local dotidx = len - decmlong
	if digits[dotidx] ~= 15 then
		digits[dotidx] = digits[dotidx] + 208
	else
		digits[dotidx] = 208
	end
	return digits
end

function Stkradio:encIntDigits(intnum)
	local digits = self:getDigits(intnum)
	local len = #digits
	if len < 5 then
		for i = 1, 5 - len do
			-- blank
			table.insert(digits, 1, 15)
		end
	else
		for i = 1, len - 5 do
			table.remove(digits, 1)
		end
	end
	return digits
end

-- automatic 5/6 digits detection
function Stkradio:encRadioDigits(freqint)
	local digits = self:getDigits(freqint)
	local len = #digits
	if len <= 5 then
		digits[3] = digits[3] + 208
	else
		table.remove(digits, 1)
		digits[2] = digits[2] + 208
	end
	return digits
end

-- COM1 Active
function Stkradio:setCom1A(digits)
	uluaSet(_G.idr_stkradio_hid_radios_com1act1, digits[1])
	uluaSet(_G.idr_stkradio_hid_radios_com1act2, digits[2])
	uluaSet(_G.idr_stkradio_hid_radios_com1act3, digits[3])
	uluaSet(_G.idr_stkradio_hid_radios_com1act4, digits[4])
	uluaSet(_G.idr_stkradio_hid_radios_com1act5, digits[5])
end

-- COM1 Standby
function Stkradio:setCom1S(digits)
	uluaSet(_G.idr_stkradio_hid_radios_com1stb1, digits[1])
	uluaSet(_G.idr_stkradio_hid_radios_com1stb2, digits[2])
	uluaSet(_G.idr_stkradio_hid_radios_com1stb3, digits[3])
	uluaSet(_G.idr_stkradio_hid_radios_com1stb4, digits[4])
	uluaSet(_G.idr_stkradio_hid_radios_com1stb5, digits[5])
end

-- COM2 Active
function Stkradio:setCom2A(digits)
	uluaSet(_G.idr_stkradio_hid_radios_com2act1, digits[1])
	uluaSet(_G.idr_stkradio_hid_radios_com2act2, digits[2])
	uluaSet(_G.idr_stkradio_hid_radios_com2act3, digits[3])
	uluaSet(_G.idr_stkradio_hid_radios_com2act4, digits[4])
	uluaSet(_G.idr_stkradio_hid_radios_com2act5, digits[5])
end

-- COM2 Standby
function Stkradio:setCom2S(digits)
	uluaSet(_G.idr_stkradio_hid_radios_com2stb1, digits[1])
	uluaSet(_G.idr_stkradio_hid_radios_com2stb2, digits[2])
	uluaSet(_G.idr_stkradio_hid_radios_com2stb3, digits[3])
	uluaSet(_G.idr_stkradio_hid_radios_com2stb4, digits[4])
	uluaSet(_G.idr_stkradio_hid_radios_com2stb5, digits[5])
end

return Stkradio
