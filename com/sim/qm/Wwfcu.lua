
-- *****************************************************************
-- Don't modify this file, unless you know what you are doing
-- Most of the code are auto generated
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-08-08_03_55_08UTC
-- *****************************************************************

local Wwfcu = oop.class(com.sim.Qmdev)
function Wwfcu:init()
	self.QmdevId = 0x073B8C7B
	self.FastTurnsPerSecond = 5
	if _G.ilua_hw_assigned_wwfcu == nil then
		_G.ilua_hw_assigned_wwfcu = 0
		self.LEDS_BKL = 0
		self.LEDS_SCRBKL = 1
		self.LEDS_LEDBKL = 2
		self.LEDS_LOC = 3
		self.LEDS_AP1 = 5
		self.LEDS_AP2 = 7
		self.LEDS_ATHR = 9
		self.LEDS_EXPED = 11
		self.LEDS_APPR = 13
		self.LEDS_EXPEDBKL = 30
		self.ledIds = {
			self.LEDS_BKL,
			self.LEDS_SCRBKL,
			self.LEDS_LEDBKL,
			self.LEDS_LOC,
			self.LEDS_AP1,
			self.LEDS_AP2,
			self.LEDS_ATHR,
			self.LEDS_EXPED,
			self.LEDS_APPR,
			self.LEDS_EXPEDBKL
		}
	end
end

function Wwfcu:absent(FastTurnsPerSecond)
	if not uluaFind('cpuwolf/flyluaio/WwFcu/leds/ledCmd') then
		return true
	end
	_G.idr_wwfcu_hid_leds_ledcmd = uluaFind('cpuwolf/flyluaio/WwFcu/leds/ledCmd')
	_G.idr_wwfcu_hid_lcd_seqnum = uluaFind('cpuwolf/flyluaio/WwFcu/lcd/seqNum')
	_G.idr_wwfcu_hid_lcd_spd = uluaFind('cpuwolf/flyluaio/WwFcu/lcd/spd')
	_G.idr_wwfcu_hid_lcd_hdg = uluaFind('cpuwolf/flyluaio/WwFcu/lcd/hdg')
	_G.idr_wwfcu_hid_lcd_alt = uluaFind('cpuwolf/flyluaio/WwFcu/lcd/alt')
	_G.idr_wwfcu_hid_lcd_vs = uluaFind('cpuwolf/flyluaio/WwFcu/lcd/vs')
	_G.idr_wwfcu_hid_finish_seqnum = uluaFind('cpuwolf/flyluaio/WwFcu/finish/seqNum')
	_G.idr_wwfcu_hid_invalid = uluaFind('cpuwolf/flyluaio/WwFcu/invalid')
	_G.idr_wwfcu_hid_fastkeypersec = uluaFind('cpuwolf/flyluaio/WwFcu/fastkeypersec')
	uluaSet(_G.idr_wwfcu_hid_fastkeypersec, FastTurnsPerSecond)
	return false
end

function Wwfcu:Init(FastTurnsPerSecond)
	local ftps = FastTurnsPerSecond == nil and self.FastTurnsPerSecond or FastTurnsPerSecond
	if self:absent(ftps) then
		return false
	end
	if _G.ilua_hw_assigned_wwfcu == 1 then
		return false
	end
	_G.ilua_hw_assigned_wwfcu = 1
	return true
end

function Wwfcu.Open(...)
	return com.sim.Qmdev.Open(Wwfcu, ...)
end

-- ========
-- LEDS BKL
function Wwfcu:GetBkl(dpath, revert, base)
	self:GetBit(self.LEDS_BKL, dpath, revert, base)
end

function Wwfcu:SetBkl(valbase, val)
	self:SendBit(self.LEDS_BKL, valbase, val)
end
-- ========
-- LEDS SCRBKL
function Wwfcu:GetScrBkl(dpath, revert, base)
	self:GetBit(self.LEDS_SCRBKL, dpath, revert, base)
end

function Wwfcu:SetScrBkl(valbase, val)
	self:SendBit(self.LEDS_SCRBKL, valbase, val)
end
-- ========
-- LEDS LEDBKL
function Wwfcu:GetLedBkl(dpath, revert, base)
	self:GetBit(self.LEDS_LEDBKL, dpath, revert, base)
end

function Wwfcu:SetLedBkl(valbase, val)
	self:SendBit(self.LEDS_LEDBKL, valbase, val)
end
-- ========
-- LEDS LOC
function Wwfcu:GetLoc(dpath, revert, base)
	self:GetBit(self.LEDS_LOC, dpath, revert, base)
end

function Wwfcu:SetLoc(valbase, val)
	self:SendBit(self.LEDS_LOC, valbase, val)
end
-- ========
-- LEDS AP1
function Wwfcu:GetAp1(dpath, revert, base)
	self:GetBit(self.LEDS_AP1, dpath, revert, base)
end

function Wwfcu:SetAp1(valbase, val)
	self:SendBit(self.LEDS_AP1, valbase, val)
end
-- ========
-- LEDS AP2
function Wwfcu:GetAp2(dpath, revert, base)
	self:GetBit(self.LEDS_AP2, dpath, revert, base)
end

function Wwfcu:SetAp2(valbase, val)
	self:SendBit(self.LEDS_AP2, valbase, val)
end
-- ========
-- LEDS ATHR
function Wwfcu:GetAthr(dpath, revert, base)
	self:GetBit(self.LEDS_ATHR, dpath, revert, base)
end

function Wwfcu:SetAthr(valbase, val)
	self:SendBit(self.LEDS_ATHR, valbase, val)
end
-- ========
-- LEDS EXPED
function Wwfcu:GetExped(dpath, revert, base)
	self:GetBit(self.LEDS_EXPED, dpath, revert, base)
end

function Wwfcu:SetExped(valbase, val)
	self:SendBit(self.LEDS_EXPED, valbase, val)
end
-- ========
-- LEDS APPR
function Wwfcu:GetAppr(dpath, revert, base)
	self:GetBit(self.LEDS_APPR, dpath, revert, base)
end

function Wwfcu:SetAppr(valbase, val)
	self:SendBit(self.LEDS_APPR, valbase, val)
end
-- ========
-- LEDS EXPEDBKL
function Wwfcu:GetExpedBkl(dpath, revert, base)
	self:GetBit(self.LEDS_EXPEDBKL, dpath, revert, base)
end

function Wwfcu:SetExpedBkl(valbase, val)
	self:SendBit(self.LEDS_EXPEDBKL, valbase, val)
end

function Wwfcu:Setleds(valbase, val)
	self:SetBkl(valbase, val)
	self:SetScrBkl(valbase, val)
	self:SetLedBkl(valbase, val)
	self:SetLoc(valbase, val)
	self:SetAp1(valbase, val)
	self:SetAp2(valbase, val)
	self:SetAthr(valbase, val)
	self:SetExped(valbase, val)
	self:SetAppr(valbase, val)
	self:SetExpedBkl(valbase, val)
end
return Wwfcu
