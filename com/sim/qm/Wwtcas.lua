
-- *****************************************************************
-- Don't modify this file, unless you know what you are doing
-- Most of the code are auto generated
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-08-08_03_55_08UTC
-- *****************************************************************

local Wwtcas = oop.class(com.sim.Qmdev)
function Wwtcas:init()
	self.QmdevId = 0x08702393
	self.FastTurnsPerSecond = 5
	if _G.ilua_hw_assigned_wwtcas == nil then
		self.PackageConter = 0
		self.LcdText = nil
		_G.ilua_hw_assigned_wwtcas = 0
		self.LEDS_BKL = 0
		self.LEDS_LCDBKL = 1
		self.LEDS_LEDBKL = 2
		self.LEDS_ATCFAIL = 3
		self.ledIds = {
			self.LEDS_ATCFAIL
		}
	end
end

function Wwtcas:absent(FastTurnsPerSecond)
	if not uluaFind('cpuwolf/flyluaio/WwTcas/leds/ledCmd') then
		return true
	end
	_G.idr_wwtcas_hid_leds_ledcmd = uluaFind('cpuwolf/flyluaio/WwTcas/leds/ledCmd')
	_G.idr_wwtcas_hid_lcd_seqnum = uluaFind('cpuwolf/flyluaio/WwTcas/lcd/seqNum')
	_G.idr_wwtcas_hid_lcd_lcd1 = uluaFind('cpuwolf/flyluaio/WwTcas/lcd/lcd1')
	_G.idr_wwtcas_hid_lcd_lcd2 = uluaFind('cpuwolf/flyluaio/WwTcas/lcd/lcd2')
	_G.idr_wwtcas_hid_lcd_lcd3 = uluaFind('cpuwolf/flyluaio/WwTcas/lcd/lcd3')
	_G.idr_wwtcas_hid_lcd_lcd4 = uluaFind('cpuwolf/flyluaio/WwTcas/lcd/lcd4')
	_G.idr_wwtcas_hid_lcd_lcd5 = uluaFind('cpuwolf/flyluaio/WwTcas/lcd/lcd5')
	_G.idr_wwtcas_hid_lcd_lcd6 = uluaFind('cpuwolf/flyluaio/WwTcas/lcd/lcd6')
	_G.idr_wwtcas_hid_lcd_lcd7 = uluaFind('cpuwolf/flyluaio/WwTcas/lcd/lcd7')
	_G.idr_wwtcas_hid_finish_seqnum = uluaFind('cpuwolf/flyluaio/WwTcas/finish/seqNum')
	_G.idr_wwtcas_hid_invalid = uluaFind('cpuwolf/flyluaio/WwTcas/invalid')
	_G.idr_wwtcas_hid_fastkeypersec = uluaFind('cpuwolf/flyluaio/WwTcas/fastkeypersec')
	uluaSet(_G.idr_wwtcas_hid_fastkeypersec, FastTurnsPerSecond)
	return false
end

function Wwtcas:Init(FastTurnsPerSecond)
	local ftps = FastTurnsPerSecond == nil and self.FastTurnsPerSecond or FastTurnsPerSecond
	if self:absent(ftps) then
		return false
	end
	if _G.ilua_hw_assigned_wwtcas == 1 then
		return false
	end
	_G.ilua_hw_assigned_wwtcas = 1
	return true
end

function Wwtcas.Open(...)
	return com.sim.Qmdev.Open(Wwtcas, ...)
end

function Wwtcas:SendLedCmd(LedId, value)
	local combinedValue = (math.floor(value) * 256) + LedId
	uluaSet(_G.idr_wwtcas_hid_leds_ledcmd, combinedValue)
end

function Wwtcas:SendBit(idx, valbase, val)
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

-- ========
-- Backlight
function Wwtcas:GetBkl(dpath, scale)
	self.d_bkl_scale = scale == nil and 30 or scale
	self.d_bkl = iDataRef:New(dpath)
end

function Wwtcas:SetBkl(val)
	if val == nil then
		if self.d_bkl:ChangedUpdate() then
			val = self.d_bkl:GetOld() * self.d_bkl_scale
			self:SendLedCmd(self.LEDS_BKL, val)
		end
	else
		self:SendLedCmd(self.LEDS_BKL, val)
	end
end

function Wwtcas:FreshBkl()
	self.d_bkl:Invalid(-1)
end

-- ========
-- Lcd Backlight
function Wwtcas:GetLcdBkl(dpath, scale)
	self.d_lcdbkl_scale = scale == nil and 30 or scale
	self.d_lcdbkl = iDataRef:New(dpath)
end

function Wwtcas:SetLcdBkl(val)
	if val == nil then
		if self.d_lcdbkl:ChangedUpdate() then
			val = self.d_lcdbkl:GetOld() * self.d_lcdbkl_scale
			self:SendLedCmd(self.LEDS_LCDBKL, val)
		end
	else
		self:SendLedCmd(self.LEDS_LCDBKL, val)
	end
end

function Wwtcas:FreshLcdBkl()
	self.d_lcdbkl:Invalid(-1)
end

-- ========
-- Led Backlight
function Wwtcas:GetLedBkl(dpath, scale)
	self.d_ledbkl_scale = scale == nil and 30 or scale
	self.d_ledbkl = iDataRef:New(dpath)
end

function Wwtcas:SetLedBkl(val)
	if val == nil then
		if self.d_ledbkl:ChangedUpdate() then
			val = self.d_ledbkl:GetOld() * self.d_ledbkl_scale
			self:SendLedCmd(self.LEDS_LEDBKL, val)
		end
	else
		self:SendLedCmd(self.LEDS_LEDBKL, val)
	end
end

function Wwtcas:FreshLedBkl()
	self.d_ledbkl:Invalid(-1)
end
-- ========
-- LEDS ATCFAIL
function Wwtcas:GetAtcFail(dpath, revert, base)
	self:GetBit(self.LEDS_ATCFAIL, dpath, revert, base)
end

function Wwtcas:SetAtcFail(valbase, val)
	self:SendBit(self.LEDS_ATCFAIL, valbase, val)
end

function Wwtcas:Setleds(valbase, val)
	self:SetAtcFail(valbase, val)
end

function Wwtcas:Next()
	local val = self.PackageConter or 1
	self.PackageConter = (val % 255) + 1
	return val
end

function Wwtcas:IsLcdTextChanged(newtext)
	if newtext ~= self.LcdText then
		self.LcdText = newtext
		return true
	end
	return false
end

-- 4-digit squawk → 7 segment planes (lcd1..lcd7), then finish commit
function Wwtcas:setLcdText(code)
	if code == nil then
		code = ''
	end
	code = string.sub(tostring(code) .. '    ', 1, 4)
	if not self:IsLcdTextChanged(code) then
		return
	end
	local segmap = {
		['0'] = 0x3F, ['1'] = 0x06, ['2'] = 0x5B, ['3'] = 0x4F, ['4'] = 0x66,
		['5'] = 0x6D, ['6'] = 0x7D, ['7'] = 0x07, ['8'] = 0x7F, ['9'] = 0x6F,
		[' '] = 0x00, ['-'] = 0x40
	}
	local planes = { 0, 0, 0, 0, 0, 0, 0 }
	for dig = 0, 3 do
		local mask = segmap[code:sub(dig + 1, dig + 1)] or 0
		for seg = 0, 6 do
			if bit.band(mask, bit.lshift(1, seg)) ~= 0 then
				planes[seg + 1] = bit.bor(planes[seg + 1], bit.lshift(1, dig))
			end
		end
	end
	local pc = self:Next()
	uluaSet(_G.idr_wwtcas_hid_lcd_lcd1, planes[1])
	uluaSet(_G.idr_wwtcas_hid_lcd_lcd2, planes[2])
	uluaSet(_G.idr_wwtcas_hid_lcd_lcd3, planes[3])
	uluaSet(_G.idr_wwtcas_hid_lcd_lcd4, planes[4])
	uluaSet(_G.idr_wwtcas_hid_lcd_lcd5, planes[5])
	uluaSet(_G.idr_wwtcas_hid_lcd_lcd6, planes[6])
	uluaSet(_G.idr_wwtcas_hid_lcd_lcd7, planes[7])
	uluaSet(_G.idr_wwtcas_hid_lcd_seqnum, pc)
	uluaSet(_G.idr_wwtcas_hid_finish_seqnum, pc)
end

return Wwtcas
