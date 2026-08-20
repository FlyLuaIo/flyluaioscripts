-- *****************************************************************
-- Don't modify this file, unless you know what you are doing
-- Most of the code are auto generated
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-08-08_03_55_08UTC
-- *****************************************************************

local Wwursa = oop.class(com.sim.Qmdev)
function Wwursa:init()
	self.QmdevId = 0x247CC218
	self.FastTurnsPerSecond = 5
	if _G.ilua_hw_assigned_wwursa == nil then
		self.PackageConter = 0
		self.LcdText = nil
		_G.ilua_hw_assigned_wwursa = 0
		self.LEDS_BKL = 0
		self.LEDS_OVERALLBKL = 2 -- OVERALL_LEDS_AND_LCD_BRIGHTNESS master gate (JSON name "Maker")
		self.LEDS_FAULT1 = 3
		self.LEDS_FIRE1 = 4
		self.LEDS_FAULT2 = 5
		self.LEDS_FIRE2 = 6
		self.LEDS_VIBL = 14
		self.LEDS_VIBR = 16
		self.ledIds = {
			self.LEDS_BKL,
			self.LEDS_OVERALLBKL,
			self.LEDS_FAULT1,
			self.LEDS_FIRE1,
			self.LEDS_FAULT2,
			self.LEDS_FIRE2,
			self.LEDS_VIBL,
			self.LEDS_VIBR
		}
	end
end

function Wwursa:absent(FastTurnsPerSecond)
	if not uluaFind('cpuwolf/flyluaio/WwUrsa/leds/ledCmd') then
		return true
	end
	_G.idr_wwursa_hid_leds_ledcmd = uluaFind('cpuwolf/flyluaio/WwUrsa/leds/ledCmd')
	_G.idr_wwursa_hid_pac_ledcmd = uluaFind('cpuwolf/flyluaio/WwUrsa/pac/ledCmd')
	_G.idr_wwursa_hid_lcd_seqnum = uluaFind('cpuwolf/flyluaio/WwUrsa/lcd/seqNum')
	_G.idr_wwursa_hid_lcd_lcd1 = uluaFind('cpuwolf/flyluaio/WwUrsa/lcd/lcd1')
	_G.idr_wwursa_hid_lcd_lcd2 = uluaFind('cpuwolf/flyluaio/WwUrsa/lcd/lcd2')
	_G.idr_wwursa_hid_lcd_lcd3 = uluaFind('cpuwolf/flyluaio/WwUrsa/lcd/lcd3')
	_G.idr_wwursa_hid_lcd_lcd4 = uluaFind('cpuwolf/flyluaio/WwUrsa/lcd/lcd4')
	_G.idr_wwursa_hid_lcd_lcd5 = uluaFind('cpuwolf/flyluaio/WwUrsa/lcd/lcd5')
	_G.idr_wwursa_hid_lcd_lcd6 = uluaFind('cpuwolf/flyluaio/WwUrsa/lcd/lcd6')
	_G.idr_wwursa_hid_lcd_lcd7 = uluaFind('cpuwolf/flyluaio/WwUrsa/lcd/lcd7')
	_G.idr_wwursa_hid_lcd_lcd8 = uluaFind('cpuwolf/flyluaio/WwUrsa/lcd/lcd8')
	_G.idr_wwursa_hid_lcd_lcd9 = uluaFind('cpuwolf/flyluaio/WwUrsa/lcd/lcd9')
	_G.idr_wwursa_hid_finish_seqnum = uluaFind('cpuwolf/flyluaio/WwUrsa/finish/seqNum')
	_G.idr_wwursa_hid_invalid = uluaFind('cpuwolf/flyluaio/WwUrsa/invalid')
	_G.idr_wwursa_hid_fastkeypersec = uluaFind('cpuwolf/flyluaio/WwUrsa/fastkeypersec')
	uluaSet(_G.idr_wwursa_hid_fastkeypersec, FastTurnsPerSecond)
	return false
end

function Wwursa:Init(FastTurnsPerSecond)
	local ftps = FastTurnsPerSecond == nil and self.FastTurnsPerSecond or FastTurnsPerSecond
	if self:absent(ftps) then
		return false
	end
	if _G.ilua_hw_assigned_wwursa == 1 then
		return false
	end
	_G.ilua_hw_assigned_wwursa = 1
	self:setLcdText('  ')
	return true
end

function Wwursa.Open(...)
	return com.sim.Qmdev.Open(Wwursa, ...)
end

function Wwursa:SendLedCmdPac(LedId, value)
	value = math.floor(value)
	if value < 0 then value = 0 elseif value > 255 then value = 255 end
	local combinedValue = (math.floor(value) * 256) + LedId
	uluaSet(_G.idr_wwursa_hid_pac_ledcmd, combinedValue)
end

-- Throttle leds; dimming channels (<3) also mirror to PAC (WINCTRL setLedBrightness)
function Wwursa:SendLedCmd(LedId, value)
	value = math.floor(value)
	if value < 0 then value = 0 elseif value > 255 then value = 255 end
	local combinedValue = (math.floor(value) * 256) + LedId
	uluaSet(_G.idr_wwursa_hid_leds_ledcmd, combinedValue)
	if LedId < 3 then
		self:SendLedCmdPac(LedId, value)
	end
end

function Wwursa:SendBit(idx, valbase, val)
	valbase = valbase == nil and 0 or valbase
	if val == nil then
		hdl = self.Bits[idx + 1]
		if hdl:ChangedUpdate() then
			val = hdl:GetOldBit()
			self:SendLedCmd(idx, val)
		end
	else
		self:SendLedCmd(idx, ilua_bool_ternary(val, valbase))
	end
end

function Wwursa:Next()
	local val = self.PackageConter or 1
	if val < 1 then val = 1 end
	self.PackageConter = (val % 255) + 1
	return val
end

-- PAC trim LCD (WINCTRL product-ursa-minor-throttle::setLCDText)
-- rowOffsets {53,49,45,41,37,33,29,25,57} → lcd1..lcd9 (dot on lcd8, bit8 on lcd9); digitBits 0..3
function Wwursa:setLcdText(text)
	text = tostring(text or '')
	if text == self.LcdText then return end
	self.LcdText = text

	local segmap = {
		['0'] = 0x3F,
		['1'] = 0x06,
		['2'] = 0x5B,
		['3'] = 0x4F,
		['4'] = 0x66,
		['5'] = 0x6D,
		['6'] = 0x7D,
		['7'] = 0x07,
		['8'] = 0x7F,
		['9'] = 0x6F,
		['A'] = 0x77,
		['L'] = 0x38,
		[' '] = 0x00,
		['-'] = 0x40
	}

	local charsOnly = ''
	local dotsMask = 0
	for i = 1, #text do
		local c = text:sub(i, i)
		if c == '.' then
			if #charsOnly > 0 then
				dotsMask = bit.bor(dotsMask, bit.lshift(1, #charsOnly - 1))
			end
		elseif c == 'R' or c == 'r' then
			charsOnly = charsOnly .. 'A'
		else
			charsOnly = charsOnly .. c:upper()
		end
	end
	while #charsOnly < 4 do charsOnly = charsOnly .. ' ' end
	if #charsOnly > 4 then charsOnly = charsOnly:sub(1, 4) end
	-- "L1.2" style → insert space after side letter when 3 chars
	if #charsOnly == 3 and not tonumber(charsOnly:sub(1, 1)) then
		charsOnly = charsOnly:sub(1, 1) .. ' ' .. charsOnly:sub(2)
		local maskAfterFirst = bit.band(dotsMask, bit.bnot(1))
		local maskFirst = bit.band(dotsMask, 1)
		dotsMask = bit.bor(maskFirst, bit.lshift(maskAfterFirst, 1))
	end
	while #charsOnly < 4 do charsOnly = charsOnly .. ' ' end
	if #charsOnly > 4 then charsOnly = charsOnly:sub(1, 4) end

	-- planes[1..7]=segments A-G, planes[8]=dots, planes[9]=mask bit 8 (byte 57)
	local planes = { 0, 0, 0, 0, 0, 0, 0, 0, 0 }
	for dig = 0, 3 do
		local mask = segmap[charsOnly:sub(dig + 1, dig + 1)] or 0
		for seg = 0, 6 do
			if bit.band(mask, bit.lshift(1, seg)) ~= 0 then
				planes[seg + 1] = bit.bor(planes[seg + 1], bit.lshift(1, dig))
			end
		end
		if bit.band(bit.rshift(dotsMask, dig), 1) ~= 0 then
			planes[8] = bit.bor(planes[8], bit.lshift(1, dig))
		end
		if bit.band(mask, 0x100) ~= 0 then
			planes[9] = bit.bor(planes[9], bit.lshift(1, dig))
		end
	end

	local pc = self:Next()
	uluaSet(_G.idr_wwursa_hid_lcd_lcd1, planes[1])
	uluaSet(_G.idr_wwursa_hid_lcd_lcd2, planes[2])
	uluaSet(_G.idr_wwursa_hid_lcd_lcd3, planes[3])
	uluaSet(_G.idr_wwursa_hid_lcd_lcd4, planes[4])
	uluaSet(_G.idr_wwursa_hid_lcd_lcd5, planes[5])
	uluaSet(_G.idr_wwursa_hid_lcd_lcd6, planes[6])
	uluaSet(_G.idr_wwursa_hid_lcd_lcd7, planes[7])
	uluaSet(_G.idr_wwursa_hid_lcd_lcd8, planes[8])
	uluaSet(_G.idr_wwursa_hid_lcd_lcd9, planes[9])
	uluaSet(_G.idr_wwursa_hid_lcd_seqnum, pc)
	uluaSet(_G.idr_wwursa_hid_finish_seqnum, pc)
end

function Wwursa:formatTrimText(trim, test)
	if test then return 'R88.8' end
	trim = tonumber(trim) or 0
	local v = math.floor(math.abs(trim) * 10 + 0.5) / 10
	local side = (trim < 0) and 'L' or 'R'
	if v < 10 then
		return string.format('%s%.1f', side, v)
	else
		return string.format('%s%d.', side, math.floor(v))
	end
end

-- ========
-- Backlight (dimmable, LedId < 3 mirrors to PAC via SendLedCmd)
function Wwursa:GetBkl(dpath, scale)
	self.d_bkl_scale = scale == nil and 30 or scale
	self.d_bkl = iDataRef:New(dpath)
end

function Wwursa:SetBkl(val)
	if val == nil then
		if self.d_bkl:ChangedUpdate() then
			val = self.d_bkl:GetOld() * self.d_bkl_scale
			self:SendLedCmd(self.LEDS_BKL, val)
		end
	else
		self:SendLedCmd(self.LEDS_BKL, val)
	end
end

function Wwursa:FreshBkl()
	self.d_bkl:Invalid(-1)
end

-- ========
-- Overall brightness master gate (dimmable, LedId < 3 mirrors to PAC via SendLedCmd)
function Wwursa:GetOverallBkl(dpath, scale)
	self.d_ovb_scale = scale == nil and 30 or scale
	self.d_ovb = iDataRef:New(dpath)
end

function Wwursa:SetOverallBkl(val)
	if val == nil then
		if self.d_ovb:ChangedUpdate() then
			val = self.d_ovb:GetOld() * self.d_ovb_scale
			self:SendLedCmd(self.LEDS_OVERALLBKL, val ~= 0 and 255 or 0)
		end
	else
		self:SendLedCmd(self.LEDS_OVERALLBKL, val ~= 0 and 255 or 0)
	end
end

function Wwursa:FreshOverallBkl()
	self.d_ovb:Invalid(-1)
end

-- ========
-- LEDS FAULT1
function Wwursa:GetFault1(dpath, revert, base)
	self:GetBit(self.LEDS_FAULT1, dpath, revert, base)
end

function Wwursa:SetFault1(valbase, val)
	self:SendBit(self.LEDS_FAULT1, valbase, val)
end

-- ========
-- LEDS FIRE1
function Wwursa:GetFire1(dpath, revert, base)
	self:GetBit(self.LEDS_FIRE1, dpath, revert, base)
end

function Wwursa:SetFire1(valbase, val)
	self:SendBit(self.LEDS_FIRE1, valbase, val)
end

-- ========
-- LEDS FAULT2
function Wwursa:GetFault2(dpath, revert, base)
	self:GetBit(self.LEDS_FAULT2, dpath, revert, base)
end

function Wwursa:SetFault2(valbase, val)
	self:SendBit(self.LEDS_FAULT2, valbase, val)
end

-- ========
-- LEDS FIRE2
function Wwursa:GetFire2(dpath, revert, base)
	self:GetBit(self.LEDS_FIRE2, dpath, revert, base)
end

function Wwursa:SetFire2(valbase, val)
	self:SendBit(self.LEDS_FIRE2, valbase, val)
end

-- ========
-- LEDS VIBL (dimmable 0-255)
function Wwursa:GetVibL(dpath, scale)
	self.d_vibl_scale = scale == nil and 1 or scale
	self.d_vibl = iDataRef:New(dpath)
end

function Wwursa:SetVibL(val)
	if val == nil then
		if self.d_vibl:ChangedUpdate() then
			val = self.d_vibl:GetOld() * self.d_vibl_scale
			self:SendLedCmd(self.LEDS_VIBL, val)
		end
	else
		self:SendLedCmd(self.LEDS_VIBL, val)
	end
end

function Wwursa:FreshVibL()
	self.d_vibl:Invalid(-1)
end

-- ========
-- LEDS VIBR (dimmable 0-255)
function Wwursa:GetVibR(dpath, scale)
	self.d_vibr_scale = scale == nil and 1 or scale
	self.d_vibr = iDataRef:New(dpath)
end

function Wwursa:SetVibR(val)
	if val == nil then
		if self.d_vibr:ChangedUpdate() then
			val = self.d_vibr:GetOld() * self.d_vibr_scale
			self:SendLedCmd(self.LEDS_VIBR, val)
		end
	else
		self:SendLedCmd(self.LEDS_VIBR, val)
	end
end

function Wwursa:FreshVibR()
	self.d_vibr:Invalid(-1)
end

function Wwursa:Setleds(valbase, val)
	-- Boolean LEDs: standard SendBit path
	self:SetFault1(valbase, val)
	self:SetFire1(valbase, val)
	self:SetFault2(valbase, val)
	self:SetFire2(valbase, val)
end

return Wwursa
