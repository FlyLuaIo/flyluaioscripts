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
	-- Mode 1
	self.dr_mode1_com1 = iDataRef:New('cpuwolf/qmdev/StkRadio/keysmap[0]')
	self.dr_mode1_com2 = iDataRef:New('cpuwolf/qmdev/StkRadio/keysmap[1]')
	self.dr_mode1_nav1 = iDataRef:New('cpuwolf/qmdev/StkRadio/keysmap[2]')
	self.dr_mode1_nav2 = iDataRef:New('cpuwolf/qmdev/StkRadio/keysmap[3]')
	self.dr_mode1_adf = iDataRef:New('cpuwolf/qmdev/StkRadio/keysmap[4]')
	self.dr_mode1_dme = iDataRef:New('cpuwolf/qmdev/StkRadio/keysmap[5]')
	self.dr_mode1_xpdr = iDataRef:New('cpuwolf/qmdev/StkRadio/keysmap[6]')
	-- Mode 2
	self.dr_mode2_com1 = iDataRef:New('cpuwolf/qmdev/StkRadio/keysmap[7]')
	self.dr_mode2_com2 = iDataRef:New('cpuwolf/qmdev/StkRadio/keysmap[8]')
	self.dr_mode2_nav1 = iDataRef:New('cpuwolf/qmdev/StkRadio/keysmap[9]')
	self.dr_mode2_nav2 = iDataRef:New('cpuwolf/qmdev/StkRadio/keysmap[10]')
	self.dr_mode2_adf = iDataRef:New('cpuwolf/qmdev/StkRadio/keysmap[11]')
	self.dr_mode2_dme = iDataRef:New('cpuwolf/qmdev/StkRadio/keysmap[12]')
	self.dr_mode2_xpdr = iDataRef:New('cpuwolf/qmdev/StkRadio/keysmap[13]')
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
	local digits = {}
	local s = tostring(math.floor(num))

	for i = 1, #s do
		local char = s:sub(i, i)
		-- Ignore minus signs for negative numbers
		if char:match("%d") then
			table.insert(digits, tonumber(char))
		end
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
		for i = 1, 5 - len do
			-- blank
			table.insert(digits, 1, 15)
		end
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

function Stkradio:getDigiCom1(a, s)
	-- =====RMP radio
	self.dr_com1a = iDataRef:New(a)
	self.digi_com1a = {}
	self.dr_com1s = iDataRef:New(s)
	self.digi_com1s = {}
end

function Stkradio:getDigiCom2(a, s)
	self.dr_com2a = iDataRef:New(a)
	self.digi_com2a = {}
	self.dr_com2s = iDataRef:New(s)
	self.digi_com2s = {}
end

function Stkradio:getDigiNav1(a, s)
	--nav
	self.dr_nav1a = iDataRef:New(a)
	self.digi_nav1a = {}
	self.dr_nav1s = iDataRef:New(s)
	self.digi_nav1s = {}
end

function Stkradio:getDigiNav2(a, s)
	self.dr_nav2a = iDataRef:New(a)
	self.digi_nav2a = {}
	self.dr_nav2s = iDataRef:New(s)
	self.digi_nav2s = {}
end

function Stkradio:getDigiAdf(a, s)
	-- adf
	self.dr_adfa = iDataRef:New(a)
	self.digi_adfa = {}
	self.dr_adfs = iDataRef:New(s)
	self.digi_adfs = {}
end

function Stkradio:getDigiDme(d1, d2)
	-- dme
	self.dr_dmea = iDataRef:New(d1)
	self.digi_dmea = {}
	self.dr_dmes = iDataRef:New(d2)
	self.digi_dmes = {}
end

function Stkradio:getDigiXpdr(xp)
	-- transponder
	self.dr_xpdr = iDataRef:New(xp)
	self.digi_xpdr = {}
end

function Stkradio:loopDigi()
	if self.dr_mode1_com1:ChangedUpdate() or
		self.dr_mode1_com2:ChangedUpdate() or
		self.dr_mode1_nav1:ChangedUpdate() or
		self.dr_mode1_nav2:ChangedUpdate() or
		self.dr_mode1_adf:ChangedUpdate() or
		self.dr_mode1_dme:ChangedUpdate() or
		self.dr_mode1_xpdr:ChangedUpdate() or
		self.dr_mode2_com1:ChangedUpdate() or
		self.dr_mode2_com2:ChangedUpdate() or
		self.dr_mode2_nav1:ChangedUpdate() or
		self.dr_mode2_nav2:ChangedUpdate() or
		self.dr_mode2_adf:ChangedUpdate() or
		self.dr_mode2_dme:ChangedUpdate() or
		self.dr_mode2_xpdr:ChangedUpdate() then
		self.dr_com1a:Invalid()
		self.dr_com1s:Invalid()
		self.dr_com2a:Invalid()
		self.dr_com2s:Invalid()
		self.dr_nav1a:Invalid()
		self.dr_nav1s:Invalid()
		self.dr_nav2a:Invalid()
		self.dr_nav2s:Invalid()
		self.dr_adfa:Invalid()
		self.dr_adfs:Invalid()
		self.dr_dmea:Invalid()
		self.dr_dmes:Invalid()
		self.dr_xpdr:Invalid()
	end

	if self.dr_com1a:ChangedUpdate() then
		digi_com1a = self:encRadioDigits(self.dr_com1a:GetOld())
	end
	if self.dr_com1s:ChangedUpdate() then
		digi_com1s = self:encRadioDigits(self.dr_com1s:GetOld())
	end
	if self.dr_com2a:ChangedUpdate() then
		digi_com2a = self:encRadioDigits(self.dr_com2a:GetOld())
	end
	if self.dr_com2s:ChangedUpdate() then
		digi_com2s = self:encRadioDigits(self.dr_com2s:GetOld())
	end
	if self.dr_nav1a:ChangedUpdate() then
		digi_nav1a = self:encRadioDigits(self.dr_nav1a:GetOld())
	end
	if self.dr_nav1s:ChangedUpdate() then
		digi_nav1s = self:encRadioDigits(self.dr_nav1s:GetOld())
	end
	if self.dr_nav2a:ChangedUpdate() then
		digi_nav2a = self:encRadioDigits(self.dr_nav2a:GetOld())
	end
	if self.dr_nav2s:ChangedUpdate() then
		digi_nav2s = self:encRadioDigits(self.dr_nav2s:GetOld())
	end
	if self.dr_adfa:ChangedUpdate() then
		digi_adfa = self:encRadioDigits(self.dr_adfa:GetOld())
	end
	if self.dr_adfs:ChangedUpdate() then
		digi_adfs = self:encRadioDigits(self.dr_adfs:GetOld())
	end
	if self.dr_dmea:ChangedUpdate() then
		digi_dmea = self:encFloatDigits(self.dr_dmea:GetOld())
	end
	if self.dr_dmes:ChangedUpdate() then
		digi_dmes = self:encFloatDigits(self.dr_dmes:GetOld())
	end
	if self.dr_xpdr:ChangedUpdate() then
		digi_xpdr = self:encIntDigits(self.dr_xpdr:GetOld())
	end

	-- update radio up
	if self.dr_mode1_com1:GetOld() > 0 then
		self:setCom1A(self.digi_com1a)
		self:setCom1S(self.digi_com1s)
	elseif self.dr_mode1_com2:GetOld() > 0 then
		self:setCom1A(self.digi_com2a)
		self:setCom1S(self.digi_com2s)
	elseif self.dr_mode1_nav1:GetOld() > 0 then
		self:setCom1A(self.digi_nav1a)
		self:setCom1S(self.digi_nav1s)
	elseif self.dr_mode1_nav2:GetOld() > 0 then
		self:setCom1A(self.digi_nav2a)
		self:setCom1S(self.digi_nav2s)
	elseif self.dr_mode1_adf:GetOld() > 0 then
		self:setCom1A(self.digi_adfa)
		self:setCom1S(self.digi_adfs)
	elseif self.dr_mode1_dme:GetOld() > 0 then
		self:setCom1A(self.digi_dmea)
		self:setCom1S(self.digi_dmes)
	elseif self.dr_mode1_xpdr:GetOld() > 0 then
		self:setCom1A(self.digi_xpdr)
		self:setCom1S(self.digi_xpdr)
	else -- initial power on
		self:setCom1A(self.digi_com1a)
		self:setCom1S(self.digi_com1s)
	end

	-- update radio down
	if self.dr_mode2_com1:GetOld() > 0 then
		self:setCom2A(self.digi_com1a)
		self:setCom2S(self.digi_com1s)
	elseif self.dr_mode2_com2:GetOld() > 0 then
		self:setCom2A(self.digi_com2a)
		self:setCom2S(self.digi_com2s)
	elseif self.dr_mode2_nav1:GetOld() > 0 then
		self:setCom2A(self.digi_nav1a)
		self:setCom2S(self.digi_nav1s)
	elseif self.dr_mode2_nav2:GetOld() > 0 then
		self:setCom2A(self.digi_nav2a)
		self:setCom2S(self.digi_nav2s)
	elseif self.dr_mode2_adf:GetOld() > 0 then
		self:setCom2A(self.digi_adfa)
		self:setCom2S(self.digi_adfs)
	elseif self.dr_mode2_dme:GetOld() > 0 then
		self:setCom2A(self.digi_dmea)
		self:setCom2S(self.digi_dmes)
	elseif self.dr_mode2_xpdr:GetOld() > 0 then
		self:setCom2A(self.digi_xpdr)
		self:setCom2S(self.digi_xpdr)
	else -- initial power on
		self:setCom2A(self.digi_com2a)
		self:setCom2S(self.digi_com2s)
	end
end

return Stkradio
