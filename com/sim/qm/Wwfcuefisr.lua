
-- *****************************************************************
-- Don't modify this file, unless you know what you are doing
-- Most of the code are auto generated
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-08-08_03_55_08UTC
-- *****************************************************************

local Wwfcuefisr = oop.class(com.sim.Qmdev)
function Wwfcuefisr:init()
	self.QmdevId = 0x03376321
	self.FastTurnsPerSecond = 5
	if _G.ilua_hw_assigned_wwfcuefisr == nil then
		self.PackageConter = 0
		self.LcdText = nil
		_G.ilua_hw_assigned_wwfcuefisr = 0
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
		self.LEDSR_BKL = 0
		self.LEDSR_SCRBKL = 1
		self.LEDSR_LEDBKL = 2
		self.LEDSR_FD = 3
		self.LEDSR_LS = 4
		self.LEDSR_CSTR = 5
		self.LEDSR_WPT = 6
		self.LEDSR_VORD = 7
		self.LEDSR_NDB = 8
		self.LEDSR_ARPT = 9
		self.ledIds = {
			self.LEDSR_BKL,
			self.LEDSR_SCRBKL,
			self.LEDSR_LEDBKL,
			self.LEDSR_FD,
			self.LEDSR_LS,
			self.LEDSR_CSTR,
			self.LEDSR_WPT,
			self.LEDSR_VORD,
			self.LEDSR_NDB,
			self.LEDSR_ARPT
		}
	end
end

function Wwfcuefisr:absent(FastTurnsPerSecond)
	if not uluaFind('cpuwolf/flyluaio/WwFcuEfisR/leds/ledCmd') then
		return true
	end
	_G.idr_wwfcuefisr_hid_leds_ledcmd = uluaFind('cpuwolf/flyluaio/WwFcuEfisR/leds/ledCmd')
	_G.idr_wwfcuefisr_hid_ledsr_ledcmd = uluaFind('cpuwolf/flyluaio/WwFcuEfisR/ledsR/ledCmd')
	_G.idr_wwfcuefisr_hid_lcd_seqnum = uluaFind('cpuwolf/flyluaio/WwFcuEfisR/lcd/seqNum')
	_G.idr_wwfcuefisr_hid_lcd_spd = uluaFind('cpuwolf/flyluaio/WwFcuEfisR/lcd/spd')
	_G.idr_wwfcuefisr_hid_lcd_hdg = uluaFind('cpuwolf/flyluaio/WwFcuEfisR/lcd/hdg')
	_G.idr_wwfcuefisr_hid_lcd_alt = uluaFind('cpuwolf/flyluaio/WwFcuEfisR/lcd/alt')
	_G.idr_wwfcuefisr_hid_lcd_vs = uluaFind('cpuwolf/flyluaio/WwFcuEfisR/lcd/vs')
	_G.idr_wwfcuefisr_hid_finish_seqnum = uluaFind('cpuwolf/flyluaio/WwFcuEfisR/finish/seqNum')
	_G.idr_wwfcuefisr_hid_lcdr_seqnum = uluaFind('cpuwolf/flyluaio/WwFcuEfisR/lcdR/seqNum')
	_G.idr_wwfcuefisr_hid_lcdr_baro = uluaFind('cpuwolf/flyluaio/WwFcuEfisR/lcdR/baro')
	_G.idr_wwfcuefisr_hid_lcdr_flag = uluaFind('cpuwolf/flyluaio/WwFcuEfisR/lcdR/flag')
	_G.idr_wwfcuefisr_hid_finishr_seqnum = uluaFind('cpuwolf/flyluaio/WwFcuEfisR/finishR/seqNum')
	_G.idr_wwfcuefisr_hid_invalid = uluaFind('cpuwolf/flyluaio/WwFcuEfisR/invalid')
	_G.idr_wwfcuefisr_hid_fastkeypersec = uluaFind('cpuwolf/flyluaio/WwFcuEfisR/fastkeypersec')
	uluaSet(_G.idr_wwfcuefisr_hid_fastkeypersec, FastTurnsPerSecond)
	return false
end

function Wwfcuefisr:Init(FastTurnsPerSecond)
	local ftps = FastTurnsPerSecond == nil and self.FastTurnsPerSecond or FastTurnsPerSecond
	if self:absent(ftps) then
		return false
	end
	if _G.ilua_hw_assigned_wwfcuefisr == 1 then
		return false
	end
	_G.ilua_hw_assigned_wwfcuefisr = 1
	return true
end

function Wwfcuefisr.Open(...)
	return com.sim.Qmdev.Open(Wwfcuefisr, ...)
end

function Wwfcuefisr:SendLedCmd(LedId, value)
	local combinedValue = (math.floor(value) * 256) + LedId
	uluaSet(_G.idr_wwfcuefisr_hid_leds_ledcmd, combinedValue)
end

function Wwfcuefisr:SendBit(idx, valbase, val)
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

function Wwfcuefisr:SendLedCmdR(LedId, value)
	local combinedValue = (math.floor(value) * 256) + LedId
	uluaSet(_G.idr_wwfcuefisr_hid_ledsr_ledcmd, combinedValue)
end

-- ========
-- LEDS BKL
function Wwfcuefisr:GetBkl(dpath, revert, base)
	self:GetBit(self.LEDS_BKL, dpath, revert, base)
end

function Wwfcuefisr:SetBkl(valbase, val)
	self:SendBit(self.LEDS_BKL, valbase, val)
end
-- ========
-- LEDS SCRBKL
function Wwfcuefisr:GetScrBkl(dpath, revert, base)
	self:GetBit(self.LEDS_SCRBKL, dpath, revert, base)
end

function Wwfcuefisr:SetScrBkl(valbase, val)
	self:SendBit(self.LEDS_SCRBKL, valbase, val)
end
-- ========
-- LEDS LEDBKL
function Wwfcuefisr:GetLedBkl(dpath, revert, base)
	self:GetBit(self.LEDS_LEDBKL, dpath, revert, base)
end

function Wwfcuefisr:SetLedBkl(valbase, val)
	self:SendBit(self.LEDS_LEDBKL, valbase, val)
end
-- ========
-- LEDS LOC
function Wwfcuefisr:GetLoc(dpath, revert, base)
	self:GetBit(self.LEDS_LOC, dpath, revert, base)
end

function Wwfcuefisr:SetLoc(valbase, val)
	self:SendBit(self.LEDS_LOC, valbase, val)
end
-- ========
-- LEDS AP1
function Wwfcuefisr:GetAp1(dpath, revert, base)
	self:GetBit(self.LEDS_AP1, dpath, revert, base)
end

function Wwfcuefisr:SetAp1(valbase, val)
	self:SendBit(self.LEDS_AP1, valbase, val)
end
-- ========
-- LEDS AP2
function Wwfcuefisr:GetAp2(dpath, revert, base)
	self:GetBit(self.LEDS_AP2, dpath, revert, base)
end

function Wwfcuefisr:SetAp2(valbase, val)
	self:SendBit(self.LEDS_AP2, valbase, val)
end
-- ========
-- LEDS ATHR
function Wwfcuefisr:GetAthr(dpath, revert, base)
	self:GetBit(self.LEDS_ATHR, dpath, revert, base)
end

function Wwfcuefisr:SetAthr(valbase, val)
	self:SendBit(self.LEDS_ATHR, valbase, val)
end
-- ========
-- LEDS EXPED
function Wwfcuefisr:GetExped(dpath, revert, base)
	self:GetBit(self.LEDS_EXPED, dpath, revert, base)
end

function Wwfcuefisr:SetExped(valbase, val)
	self:SendBit(self.LEDS_EXPED, valbase, val)
end
-- ========
-- LEDS APPR
function Wwfcuefisr:GetAppr(dpath, revert, base)
	self:GetBit(self.LEDS_APPR, dpath, revert, base)
end

function Wwfcuefisr:SetAppr(valbase, val)
	self:SendBit(self.LEDS_APPR, valbase, val)
end
-- ========
-- LEDS EXPEDBKL
function Wwfcuefisr:GetExpedBkl(dpath, revert, base)
	self:GetBit(self.LEDS_EXPEDBKL, dpath, revert, base)
end

function Wwfcuefisr:SetExpedBkl(valbase, val)
	self:SendBit(self.LEDS_EXPEDBKL, valbase, val)
end

function Wwfcuefisr:Setleds(valbase, val)
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
-- ========
-- LEDSR BKL
function Wwfcuefisr:GetBkl(dpath, revert, base)
	self:GetBit(self.LEDSR_BKL, dpath, revert, base)
end

function Wwfcuefisr:SetBkl(valbase, val)
	self:SendBit(self.LEDSR_BKL, valbase, val)
end
-- ========
-- LEDSR SCRBKL
function Wwfcuefisr:GetScrBkl(dpath, revert, base)
	self:GetBit(self.LEDSR_SCRBKL, dpath, revert, base)
end

function Wwfcuefisr:SetScrBkl(valbase, val)
	self:SendBit(self.LEDSR_SCRBKL, valbase, val)
end
-- ========
-- LEDSR LEDBKL
function Wwfcuefisr:GetLedBkl(dpath, revert, base)
	self:GetBit(self.LEDSR_LEDBKL, dpath, revert, base)
end

function Wwfcuefisr:SetLedBkl(valbase, val)
	self:SendBit(self.LEDSR_LEDBKL, valbase, val)
end
-- ========
-- LEDSR FD
function Wwfcuefisr:GetFd(dpath, revert, base)
	self:GetBit(self.LEDSR_FD, dpath, revert, base)
end

function Wwfcuefisr:SetFd(valbase, val)
	self:SendBit(self.LEDSR_FD, valbase, val)
end
-- ========
-- LEDSR LS
function Wwfcuefisr:GetLs(dpath, revert, base)
	self:GetBit(self.LEDSR_LS, dpath, revert, base)
end

function Wwfcuefisr:SetLs(valbase, val)
	self:SendBit(self.LEDSR_LS, valbase, val)
end
-- ========
-- LEDSR CSTR
function Wwfcuefisr:GetCstr(dpath, revert, base)
	self:GetBit(self.LEDSR_CSTR, dpath, revert, base)
end

function Wwfcuefisr:SetCstr(valbase, val)
	self:SendBit(self.LEDSR_CSTR, valbase, val)
end
-- ========
-- LEDSR WPT
function Wwfcuefisr:GetWpt(dpath, revert, base)
	self:GetBit(self.LEDSR_WPT, dpath, revert, base)
end

function Wwfcuefisr:SetWpt(valbase, val)
	self:SendBit(self.LEDSR_WPT, valbase, val)
end
-- ========
-- LEDSR VORD
function Wwfcuefisr:GetVord(dpath, revert, base)
	self:GetBit(self.LEDSR_VORD, dpath, revert, base)
end

function Wwfcuefisr:SetVord(valbase, val)
	self:SendBit(self.LEDSR_VORD, valbase, val)
end
-- ========
-- LEDSR NDB
function Wwfcuefisr:GetNdb(dpath, revert, base)
	self:GetBit(self.LEDSR_NDB, dpath, revert, base)
end

function Wwfcuefisr:SetNdb(valbase, val)
	self:SendBit(self.LEDSR_NDB, valbase, val)
end
-- ========
-- LEDSR ARPT
function Wwfcuefisr:GetArpt(dpath, revert, base)
	self:GetBit(self.LEDSR_ARPT, dpath, revert, base)
end

function Wwfcuefisr:SetArpt(valbase, val)
	self:SendBit(self.LEDSR_ARPT, valbase, val)
end

function Wwfcuefisr:SetledsR(valbase, val)
	self:SetBkl(valbase, val)
	self:SetScrBkl(valbase, val)
	self:SetLedBkl(valbase, val)
	self:SetFd(valbase, val)
	self:SetLs(valbase, val)
	self:SetCstr(valbase, val)
	self:SetWpt(valbase, val)
	self:SetVord(valbase, val)
	self:SetNdb(valbase, val)
	self:SetArpt(valbase, val)
end
return Wwfcuefisr
