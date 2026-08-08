
-- *****************************************************************
-- Don't modify this file, unless you know what you are doing
-- Most of the code are auto generated
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-08-08_03_55_08UTC
-- *****************************************************************

local Wwursa = oop.class(com.sim.Qmdev)
function Wwursa:init()
	self.QmdevId = 0x06410BF7
	self.FastTurnsPerSecond = 5
	if _G.ilua_hw_assigned_wwursa == nil then
		_G.ilua_hw_assigned_wwursa = 0
		self.LEDS_BKL = 0
		self.LEDS_MAKER = 2
		self.LEDS_FAULT1 = 3
		self.LEDS_FIRE1 = 4
		self.LEDS_FAULT2 = 5
		self.LEDS_FIRE2 = 6
		self.LEDS_VIBL = 14
		self.LEDS_VIBR = 16
		self.ledIds = {
			self.LEDS_BKL,
			self.LEDS_MAKER,
			self.LEDS_FAULT1,
			self.LEDS_FIRE1,
			self.LEDS_FAULT2,
			self.LEDS_FIRE2,
			self.LEDS_VIBL,
			self.LEDS_VIBR
		}
		self.PAC_BKL = 0
		self.PAC_LCDBKL = 2
		self.ledIds = {
			self.PAC_BKL,
			self.PAC_LCDBKL
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
	return true
end

function Wwursa.Open(...)
	return com.sim.Qmdev.Open(Wwursa, ...)
end

-- ========
-- LEDS BKL
function Wwursa:GetBkl(dpath, revert, base)
	self:GetBit(self.LEDS_BKL, dpath, revert, base)
end

function Wwursa:SetBkl(valbase, val)
	self:SendBit(self.LEDS_BKL, valbase, val)
end
-- ========
-- LEDS MAKER
function Wwursa:GetMaker(dpath, revert, base)
	self:GetBit(self.LEDS_MAKER, dpath, revert, base)
end

function Wwursa:SetMaker(valbase, val)
	self:SendBit(self.LEDS_MAKER, valbase, val)
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
-- LEDS VIBL
function Wwursa:GetVibL(dpath, revert, base)
	self:GetBit(self.LEDS_VIBL, dpath, revert, base)
end

function Wwursa:SetVibL(valbase, val)
	self:SendBit(self.LEDS_VIBL, valbase, val)
end
-- ========
-- LEDS VIBR
function Wwursa:GetVibR(dpath, revert, base)
	self:GetBit(self.LEDS_VIBR, dpath, revert, base)
end

function Wwursa:SetVibR(valbase, val)
	self:SendBit(self.LEDS_VIBR, valbase, val)
end

function Wwursa:Setleds(valbase, val)
	self:SetBkl(valbase, val)
	self:SetMaker(valbase, val)
	self:SetFault1(valbase, val)
	self:SetFire1(valbase, val)
	self:SetFault2(valbase, val)
	self:SetFire2(valbase, val)
	self:SetVibL(valbase, val)
	self:SetVibR(valbase, val)
end
-- ========
-- PAC BKL
function Wwursa:GetBkl(dpath, revert, base)
	self:GetBit(self.PAC_BKL, dpath, revert, base)
end

function Wwursa:SetBkl(valbase, val)
	self:SendBit(self.PAC_BKL, valbase, val)
end
-- ========
-- PAC LCDBKL
function Wwursa:GetLcdBkl(dpath, revert, base)
	self:GetBit(self.PAC_LCDBKL, dpath, revert, base)
end

function Wwursa:SetLcdBkl(valbase, val)
	self:SendBit(self.PAC_LCDBKL, valbase, val)
end

function Wwursa:Setpac(valbase, val)
	self:SetBkl(valbase, val)
	self:SetLcdBkl(valbase, val)
end
return Wwursa
