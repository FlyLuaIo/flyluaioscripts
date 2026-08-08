
-- *****************************************************************
-- Don't modify this file, unless you know what you are doing
-- Most of the code are auto generated
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-08-08_03_55_08UTC
-- *****************************************************************

local Wwfcuefis = oop.class(com.sim.Qmdev)
function Wwfcuefis:init()
	self.QmdevId = 0x06D3042B
	self.FastTurnsPerSecond = 5
	if _G.ilua_hw_assigned_wwfcuefis == nil then
		_G.ilua_hw_assigned_wwfcuefis = 0
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
		self.LEDSL_BKL = 0
		self.LEDSL_SCRBKL = 1
		self.LEDSL_LEDBKL = 2
		self.LEDSL_FD = 3
		self.LEDSL_LS = 4
		self.LEDSL_CSTR = 5
		self.LEDSL_WPT = 6
		self.LEDSL_VORD = 7
		self.LEDSL_NDB = 8
		self.LEDSL_ARPT = 9
		self.ledIds = {
			self.LEDSL_BKL,
			self.LEDSL_SCRBKL,
			self.LEDSL_LEDBKL,
			self.LEDSL_FD,
			self.LEDSL_LS,
			self.LEDSL_CSTR,
			self.LEDSL_WPT,
			self.LEDSL_VORD,
			self.LEDSL_NDB,
			self.LEDSL_ARPT
		}
	end
end

function Wwfcuefis:absent(FastTurnsPerSecond)
	if not uluaFind('cpuwolf/flyluaio/WwFcuEfis/leds/ledCmd') then
		return true
	end
	_G.idr_wwfcuefis_hid_leds_ledcmd = uluaFind('cpuwolf/flyluaio/WwFcuEfis/leds/ledCmd')
	_G.idr_wwfcuefis_hid_ledsr_ledcmd = uluaFind('cpuwolf/flyluaio/WwFcuEfis/ledsR/ledCmd')
	_G.idr_wwfcuefis_hid_ledsl_ledcmd = uluaFind('cpuwolf/flyluaio/WwFcuEfis/ledsL/ledCmd')
	_G.idr_wwfcuefis_hid_lcd_seqnum = uluaFind('cpuwolf/flyluaio/WwFcuEfis/lcd/seqNum')
	_G.idr_wwfcuefis_hid_lcd_spd = uluaFind('cpuwolf/flyluaio/WwFcuEfis/lcd/spd')
	_G.idr_wwfcuefis_hid_lcd_hdg = uluaFind('cpuwolf/flyluaio/WwFcuEfis/lcd/hdg')
	_G.idr_wwfcuefis_hid_lcd_alt = uluaFind('cpuwolf/flyluaio/WwFcuEfis/lcd/alt')
	_G.idr_wwfcuefis_hid_lcd_vs = uluaFind('cpuwolf/flyluaio/WwFcuEfis/lcd/vs')
	_G.idr_wwfcuefis_hid_finish_seqnum = uluaFind('cpuwolf/flyluaio/WwFcuEfis/finish/seqNum')
	_G.idr_wwfcuefis_hid_lcdr_seqnum = uluaFind('cpuwolf/flyluaio/WwFcuEfis/lcdR/seqNum')
	_G.idr_wwfcuefis_hid_lcdr_baro = uluaFind('cpuwolf/flyluaio/WwFcuEfis/lcdR/baro')
	_G.idr_wwfcuefis_hid_lcdr_flag = uluaFind('cpuwolf/flyluaio/WwFcuEfis/lcdR/flag')
	_G.idr_wwfcuefis_hid_finishr_seqnum = uluaFind('cpuwolf/flyluaio/WwFcuEfis/finishR/seqNum')
	_G.idr_wwfcuefis_hid_lcdl_seqnum = uluaFind('cpuwolf/flyluaio/WwFcuEfis/lcdL/seqNum')
	_G.idr_wwfcuefis_hid_lcdl_baro = uluaFind('cpuwolf/flyluaio/WwFcuEfis/lcdL/baro')
	_G.idr_wwfcuefis_hid_lcdl_flag = uluaFind('cpuwolf/flyluaio/WwFcuEfis/lcdL/flag')
	_G.idr_wwfcuefis_hid_finishl_seqnum = uluaFind('cpuwolf/flyluaio/WwFcuEfis/finishL/seqNum')
	_G.idr_wwfcuefis_hid_invalid = uluaFind('cpuwolf/flyluaio/WwFcuEfis/invalid')
	_G.idr_wwfcuefis_hid_fastkeypersec = uluaFind('cpuwolf/flyluaio/WwFcuEfis/fastkeypersec')
	uluaSet(_G.idr_wwfcuefis_hid_fastkeypersec, FastTurnsPerSecond)
	return false
end

function Wwfcuefis:Init(FastTurnsPerSecond)
	local ftps = FastTurnsPerSecond == nil and self.FastTurnsPerSecond or FastTurnsPerSecond
	if self:absent(ftps) then
		return false
	end
	if _G.ilua_hw_assigned_wwfcuefis == 1 then
		return false
	end
	_G.ilua_hw_assigned_wwfcuefis = 1
	return true
end

function Wwfcuefis.Open(...)
	return com.sim.Qmdev.Open(Wwfcuefis, ...)
end

-- ========
-- LEDS BKL
function Wwfcuefis:GetBkl(dpath, revert, base)
	self:GetBit(self.LEDS_BKL, dpath, revert, base)
end

function Wwfcuefis:SetBkl(valbase, val)
	self:SendBit(self.LEDS_BKL, valbase, val)
end
-- ========
-- LEDS SCRBKL
function Wwfcuefis:GetScrBkl(dpath, revert, base)
	self:GetBit(self.LEDS_SCRBKL, dpath, revert, base)
end

function Wwfcuefis:SetScrBkl(valbase, val)
	self:SendBit(self.LEDS_SCRBKL, valbase, val)
end
-- ========
-- LEDS LEDBKL
function Wwfcuefis:GetLedBkl(dpath, revert, base)
	self:GetBit(self.LEDS_LEDBKL, dpath, revert, base)
end

function Wwfcuefis:SetLedBkl(valbase, val)
	self:SendBit(self.LEDS_LEDBKL, valbase, val)
end
-- ========
-- LEDS LOC
function Wwfcuefis:GetLoc(dpath, revert, base)
	self:GetBit(self.LEDS_LOC, dpath, revert, base)
end

function Wwfcuefis:SetLoc(valbase, val)
	self:SendBit(self.LEDS_LOC, valbase, val)
end
-- ========
-- LEDS AP1
function Wwfcuefis:GetAp1(dpath, revert, base)
	self:GetBit(self.LEDS_AP1, dpath, revert, base)
end

function Wwfcuefis:SetAp1(valbase, val)
	self:SendBit(self.LEDS_AP1, valbase, val)
end
-- ========
-- LEDS AP2
function Wwfcuefis:GetAp2(dpath, revert, base)
	self:GetBit(self.LEDS_AP2, dpath, revert, base)
end

function Wwfcuefis:SetAp2(valbase, val)
	self:SendBit(self.LEDS_AP2, valbase, val)
end
-- ========
-- LEDS ATHR
function Wwfcuefis:GetAthr(dpath, revert, base)
	self:GetBit(self.LEDS_ATHR, dpath, revert, base)
end

function Wwfcuefis:SetAthr(valbase, val)
	self:SendBit(self.LEDS_ATHR, valbase, val)
end
-- ========
-- LEDS EXPED
function Wwfcuefis:GetExped(dpath, revert, base)
	self:GetBit(self.LEDS_EXPED, dpath, revert, base)
end

function Wwfcuefis:SetExped(valbase, val)
	self:SendBit(self.LEDS_EXPED, valbase, val)
end
-- ========
-- LEDS APPR
function Wwfcuefis:GetAppr(dpath, revert, base)
	self:GetBit(self.LEDS_APPR, dpath, revert, base)
end

function Wwfcuefis:SetAppr(valbase, val)
	self:SendBit(self.LEDS_APPR, valbase, val)
end
-- ========
-- LEDS EXPEDBKL
function Wwfcuefis:GetExpedBkl(dpath, revert, base)
	self:GetBit(self.LEDS_EXPEDBKL, dpath, revert, base)
end

function Wwfcuefis:SetExpedBkl(valbase, val)
	self:SendBit(self.LEDS_EXPEDBKL, valbase, val)
end

function Wwfcuefis:Setleds(valbase, val)
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
function Wwfcuefis:GetBkl(dpath, revert, base)
	self:GetBit(self.LEDSR_BKL, dpath, revert, base)
end

function Wwfcuefis:SetBkl(valbase, val)
	self:SendBit(self.LEDSR_BKL, valbase, val)
end
-- ========
-- LEDSR SCRBKL
function Wwfcuefis:GetScrBkl(dpath, revert, base)
	self:GetBit(self.LEDSR_SCRBKL, dpath, revert, base)
end

function Wwfcuefis:SetScrBkl(valbase, val)
	self:SendBit(self.LEDSR_SCRBKL, valbase, val)
end
-- ========
-- LEDSR LEDBKL
function Wwfcuefis:GetLedBkl(dpath, revert, base)
	self:GetBit(self.LEDSR_LEDBKL, dpath, revert, base)
end

function Wwfcuefis:SetLedBkl(valbase, val)
	self:SendBit(self.LEDSR_LEDBKL, valbase, val)
end
-- ========
-- LEDSR FD
function Wwfcuefis:GetFd(dpath, revert, base)
	self:GetBit(self.LEDSR_FD, dpath, revert, base)
end

function Wwfcuefis:SetFd(valbase, val)
	self:SendBit(self.LEDSR_FD, valbase, val)
end
-- ========
-- LEDSR LS
function Wwfcuefis:GetLs(dpath, revert, base)
	self:GetBit(self.LEDSR_LS, dpath, revert, base)
end

function Wwfcuefis:SetLs(valbase, val)
	self:SendBit(self.LEDSR_LS, valbase, val)
end
-- ========
-- LEDSR CSTR
function Wwfcuefis:GetCstr(dpath, revert, base)
	self:GetBit(self.LEDSR_CSTR, dpath, revert, base)
end

function Wwfcuefis:SetCstr(valbase, val)
	self:SendBit(self.LEDSR_CSTR, valbase, val)
end
-- ========
-- LEDSR WPT
function Wwfcuefis:GetWpt(dpath, revert, base)
	self:GetBit(self.LEDSR_WPT, dpath, revert, base)
end

function Wwfcuefis:SetWpt(valbase, val)
	self:SendBit(self.LEDSR_WPT, valbase, val)
end
-- ========
-- LEDSR VORD
function Wwfcuefis:GetVord(dpath, revert, base)
	self:GetBit(self.LEDSR_VORD, dpath, revert, base)
end

function Wwfcuefis:SetVord(valbase, val)
	self:SendBit(self.LEDSR_VORD, valbase, val)
end
-- ========
-- LEDSR NDB
function Wwfcuefis:GetNdb(dpath, revert, base)
	self:GetBit(self.LEDSR_NDB, dpath, revert, base)
end

function Wwfcuefis:SetNdb(valbase, val)
	self:SendBit(self.LEDSR_NDB, valbase, val)
end
-- ========
-- LEDSR ARPT
function Wwfcuefis:GetArpt(dpath, revert, base)
	self:GetBit(self.LEDSR_ARPT, dpath, revert, base)
end

function Wwfcuefis:SetArpt(valbase, val)
	self:SendBit(self.LEDSR_ARPT, valbase, val)
end

function Wwfcuefis:SetledsR(valbase, val)
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
-- ========
-- LEDSL BKL
function Wwfcuefis:GetBkl(dpath, revert, base)
	self:GetBit(self.LEDSL_BKL, dpath, revert, base)
end

function Wwfcuefis:SetBkl(valbase, val)
	self:SendBit(self.LEDSL_BKL, valbase, val)
end
-- ========
-- LEDSL SCRBKL
function Wwfcuefis:GetScrBkl(dpath, revert, base)
	self:GetBit(self.LEDSL_SCRBKL, dpath, revert, base)
end

function Wwfcuefis:SetScrBkl(valbase, val)
	self:SendBit(self.LEDSL_SCRBKL, valbase, val)
end
-- ========
-- LEDSL LEDBKL
function Wwfcuefis:GetLedBkl(dpath, revert, base)
	self:GetBit(self.LEDSL_LEDBKL, dpath, revert, base)
end

function Wwfcuefis:SetLedBkl(valbase, val)
	self:SendBit(self.LEDSL_LEDBKL, valbase, val)
end
-- ========
-- LEDSL FD
function Wwfcuefis:GetFd(dpath, revert, base)
	self:GetBit(self.LEDSL_FD, dpath, revert, base)
end

function Wwfcuefis:SetFd(valbase, val)
	self:SendBit(self.LEDSL_FD, valbase, val)
end
-- ========
-- LEDSL LS
function Wwfcuefis:GetLs(dpath, revert, base)
	self:GetBit(self.LEDSL_LS, dpath, revert, base)
end

function Wwfcuefis:SetLs(valbase, val)
	self:SendBit(self.LEDSL_LS, valbase, val)
end
-- ========
-- LEDSL CSTR
function Wwfcuefis:GetCstr(dpath, revert, base)
	self:GetBit(self.LEDSL_CSTR, dpath, revert, base)
end

function Wwfcuefis:SetCstr(valbase, val)
	self:SendBit(self.LEDSL_CSTR, valbase, val)
end
-- ========
-- LEDSL WPT
function Wwfcuefis:GetWpt(dpath, revert, base)
	self:GetBit(self.LEDSL_WPT, dpath, revert, base)
end

function Wwfcuefis:SetWpt(valbase, val)
	self:SendBit(self.LEDSL_WPT, valbase, val)
end
-- ========
-- LEDSL VORD
function Wwfcuefis:GetVord(dpath, revert, base)
	self:GetBit(self.LEDSL_VORD, dpath, revert, base)
end

function Wwfcuefis:SetVord(valbase, val)
	self:SendBit(self.LEDSL_VORD, valbase, val)
end
-- ========
-- LEDSL NDB
function Wwfcuefis:GetNdb(dpath, revert, base)
	self:GetBit(self.LEDSL_NDB, dpath, revert, base)
end

function Wwfcuefis:SetNdb(valbase, val)
	self:SendBit(self.LEDSL_NDB, valbase, val)
end
-- ========
-- LEDSL ARPT
function Wwfcuefis:GetArpt(dpath, revert, base)
	self:GetBit(self.LEDSL_ARPT, dpath, revert, base)
end

function Wwfcuefis:SetArpt(valbase, val)
	self:SendBit(self.LEDSL_ARPT, valbase, val)
end

function Wwfcuefis:SetledsL(valbase, val)
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
return Wwfcuefis
