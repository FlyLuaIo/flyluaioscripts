
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
		_G.ilua_hw_assigned_wwtcas = 0
		self.LEDS_BKL = 0
		self.LEDS_LCDBKL = 1
		self.LEDS_LEDBKL = 2
		self.LEDS_ATCFAIL = 3
		self.ledIds = {
			self.LEDS_BKL,
			self.LEDS_LCDBKL,
			self.LEDS_LEDBKL,
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

-- ========
-- LEDS BKL
function Wwtcas:GetBkl(dpath, revert, base)
	self:GetBit(self.LEDS_BKL, dpath, revert, base)
end

function Wwtcas:SetBkl(valbase, val)
	self:SendBit(self.LEDS_BKL, valbase, val)
end
-- ========
-- LEDS LCDBKL
function Wwtcas:GetLcdBkl(dpath, revert, base)
	self:GetBit(self.LEDS_LCDBKL, dpath, revert, base)
end

function Wwtcas:SetLcdBkl(valbase, val)
	self:SendBit(self.LEDS_LCDBKL, valbase, val)
end
-- ========
-- LEDS LEDBKL
function Wwtcas:GetLedBkl(dpath, revert, base)
	self:GetBit(self.LEDS_LEDBKL, dpath, revert, base)
end

function Wwtcas:SetLedBkl(valbase, val)
	self:SendBit(self.LEDS_LEDBKL, valbase, val)
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
	self:SetBkl(valbase, val)
	self:SetLcdBkl(valbase, val)
	self:SetLedBkl(valbase, val)
	self:SetAtcFail(valbase, val)
end
return Wwtcas
