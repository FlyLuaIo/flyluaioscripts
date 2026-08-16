
-- *****************************************************************
-- Don't modify this file, unless you know what you are doing
-- Most of the code are auto generated
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-08-08_03_55_08UTC
-- *****************************************************************

local Wwfcuefisl = oop.class(com.sim.Qmdev)
function Wwfcuefisl:init()
	self.QmdevId = 0x0926AC01
	self.FastTurnsPerSecond = 5
	if _G.ilua_hw_assigned_wwfcuefisl == nil then
		self.PackageConter = 0
		self.LcdText = nil
		_G.ilua_hw_assigned_wwfcuefisl = 0
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

function Wwfcuefisl:absent(FastTurnsPerSecond)
	if not uluaFind('cpuwolf/flyluaio/WwFcuEfisL/leds/ledCmd') then
		return true
	end
	_G.idr_wwfcuefisl_hid_leds_ledcmd = uluaFind('cpuwolf/flyluaio/WwFcuEfisL/leds/ledCmd')
	_G.idr_wwfcuefisl_hid_ledsl_ledcmd = uluaFind('cpuwolf/flyluaio/WwFcuEfisL/ledsL/ledCmd')
	_G.idr_wwfcuefisl_hid_lcd_seqnum = uluaFind('cpuwolf/flyluaio/WwFcuEfisL/lcd/seqNum')
	_G.idr_wwfcuefisl_hid_lcd_spd = uluaFind('cpuwolf/flyluaio/WwFcuEfisL/lcd/spd')
	_G.idr_wwfcuefisl_hid_lcd_hdg = uluaFind('cpuwolf/flyluaio/WwFcuEfisL/lcd/hdg')
	_G.idr_wwfcuefisl_hid_lcd_alt = uluaFind('cpuwolf/flyluaio/WwFcuEfisL/lcd/alt')
	_G.idr_wwfcuefisl_hid_lcd_vs = uluaFind('cpuwolf/flyluaio/WwFcuEfisL/lcd/vs')
	_G.idr_wwfcuefisl_hid_finish_seqnum = uluaFind('cpuwolf/flyluaio/WwFcuEfisL/finish/seqNum')
	_G.idr_wwfcuefisl_hid_lcdl_seqnum = uluaFind('cpuwolf/flyluaio/WwFcuEfisL/lcdL/seqNum')
	_G.idr_wwfcuefisl_hid_lcdl_baro = uluaFind('cpuwolf/flyluaio/WwFcuEfisL/lcdL/baro')
	_G.idr_wwfcuefisl_hid_lcdl_flag = uluaFind('cpuwolf/flyluaio/WwFcuEfisL/lcdL/flag')
	_G.idr_wwfcuefisl_hid_finishl_seqnum = uluaFind('cpuwolf/flyluaio/WwFcuEfisL/finishL/seqNum')
	_G.idr_wwfcuefisl_hid_invalid = uluaFind('cpuwolf/flyluaio/WwFcuEfisL/invalid')
	_G.idr_wwfcuefisl_hid_fastkeypersec = uluaFind('cpuwolf/flyluaio/WwFcuEfisL/fastkeypersec')
	uluaSet(_G.idr_wwfcuefisl_hid_fastkeypersec, FastTurnsPerSecond)
	return false
end

function Wwfcuefisl:Init(FastTurnsPerSecond)
	local ftps = FastTurnsPerSecond == nil and self.FastTurnsPerSecond or FastTurnsPerSecond
	if self:absent(ftps) then
		return false
	end
	if _G.ilua_hw_assigned_wwfcuefisl == 1 then
		return false
	end
	_G.ilua_hw_assigned_wwfcuefisl = 1
	return true
end

function Wwfcuefisl.Open(...)
	return com.sim.Qmdev.Open(Wwfcuefisl, ...)
end

function Wwfcuefisl:SendLedCmd(LedId, value)
	local combinedValue = (value * 256) + LedId
	uluaSet(_G.idr_wwfcuefisl_hid_leds_ledcmd, combinedValue)
end

function Wwfcuefisl:SendBit(idx, valbase, val)
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

function Wwfcuefisl:SendLedCmdL(LedId, value)
	local combinedValue = (value * 256) + LedId
	uluaSet(_G.idr_wwfcuefisl_hid_ledsl_ledcmd, combinedValue)
end

-- ========
-- LEDS BKL
function Wwfcuefisl:GetBkl(dpath, revert, base)
	self:GetBit(self.LEDS_BKL, dpath, revert, base)
end

function Wwfcuefisl:SetBkl(valbase, val)
	self:SendBit(self.LEDS_BKL, valbase, val)
end
-- ========
-- LEDS SCRBKL
function Wwfcuefisl:GetScrBkl(dpath, revert, base)
	self:GetBit(self.LEDS_SCRBKL, dpath, revert, base)
end

function Wwfcuefisl:SetScrBkl(valbase, val)
	self:SendBit(self.LEDS_SCRBKL, valbase, val)
end
-- ========
-- LEDS LEDBKL
function Wwfcuefisl:GetLedBkl(dpath, revert, base)
	self:GetBit(self.LEDS_LEDBKL, dpath, revert, base)
end

function Wwfcuefisl:SetLedBkl(valbase, val)
	self:SendBit(self.LEDS_LEDBKL, valbase, val)
end
-- ========
-- LEDS LOC
function Wwfcuefisl:GetLoc(dpath, revert, base)
	self:GetBit(self.LEDS_LOC, dpath, revert, base)
end

function Wwfcuefisl:SetLoc(valbase, val)
	self:SendBit(self.LEDS_LOC, valbase, val)
end
-- ========
-- LEDS AP1
function Wwfcuefisl:GetAp1(dpath, revert, base)
	self:GetBit(self.LEDS_AP1, dpath, revert, base)
end

function Wwfcuefisl:SetAp1(valbase, val)
	self:SendBit(self.LEDS_AP1, valbase, val)
end
-- ========
-- LEDS AP2
function Wwfcuefisl:GetAp2(dpath, revert, base)
	self:GetBit(self.LEDS_AP2, dpath, revert, base)
end

function Wwfcuefisl:SetAp2(valbase, val)
	self:SendBit(self.LEDS_AP2, valbase, val)
end
-- ========
-- LEDS ATHR
function Wwfcuefisl:GetAthr(dpath, revert, base)
	self:GetBit(self.LEDS_ATHR, dpath, revert, base)
end

function Wwfcuefisl:SetAthr(valbase, val)
	self:SendBit(self.LEDS_ATHR, valbase, val)
end
-- ========
-- LEDS EXPED
function Wwfcuefisl:GetExped(dpath, revert, base)
	self:GetBit(self.LEDS_EXPED, dpath, revert, base)
end

function Wwfcuefisl:SetExped(valbase, val)
	self:SendBit(self.LEDS_EXPED, valbase, val)
end
-- ========
-- LEDS APPR
function Wwfcuefisl:GetAppr(dpath, revert, base)
	self:GetBit(self.LEDS_APPR, dpath, revert, base)
end

function Wwfcuefisl:SetAppr(valbase, val)
	self:SendBit(self.LEDS_APPR, valbase, val)
end
-- ========
-- LEDS EXPEDBKL
function Wwfcuefisl:GetExpedBkl(dpath, revert, base)
	self:GetBit(self.LEDS_EXPEDBKL, dpath, revert, base)
end

function Wwfcuefisl:SetExpedBkl(valbase, val)
	self:SendBit(self.LEDS_EXPEDBKL, valbase, val)
end

function Wwfcuefisl:Setleds(valbase, val)
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
-- LEDSL BKL
function Wwfcuefisl:GetBkl(dpath, revert, base)
	self:GetBit(self.LEDSL_BKL, dpath, revert, base)
end

function Wwfcuefisl:SetBkl(valbase, val)
	self:SendBit(self.LEDSL_BKL, valbase, val)
end
-- ========
-- LEDSL SCRBKL
function Wwfcuefisl:GetScrBkl(dpath, revert, base)
	self:GetBit(self.LEDSL_SCRBKL, dpath, revert, base)
end

function Wwfcuefisl:SetScrBkl(valbase, val)
	self:SendBit(self.LEDSL_SCRBKL, valbase, val)
end
-- ========
-- LEDSL LEDBKL
function Wwfcuefisl:GetLedBkl(dpath, revert, base)
	self:GetBit(self.LEDSL_LEDBKL, dpath, revert, base)
end

function Wwfcuefisl:SetLedBkl(valbase, val)
	self:SendBit(self.LEDSL_LEDBKL, valbase, val)
end
-- ========
-- LEDSL FD
function Wwfcuefisl:GetFd(dpath, revert, base)
	self:GetBit(self.LEDSL_FD, dpath, revert, base)
end

function Wwfcuefisl:SetFd(valbase, val)
	self:SendBit(self.LEDSL_FD, valbase, val)
end
-- ========
-- LEDSL LS
function Wwfcuefisl:GetLs(dpath, revert, base)
	self:GetBit(self.LEDSL_LS, dpath, revert, base)
end

function Wwfcuefisl:SetLs(valbase, val)
	self:SendBit(self.LEDSL_LS, valbase, val)
end
-- ========
-- LEDSL CSTR
function Wwfcuefisl:GetCstr(dpath, revert, base)
	self:GetBit(self.LEDSL_CSTR, dpath, revert, base)
end

function Wwfcuefisl:SetCstr(valbase, val)
	self:SendBit(self.LEDSL_CSTR, valbase, val)
end
-- ========
-- LEDSL WPT
function Wwfcuefisl:GetWpt(dpath, revert, base)
	self:GetBit(self.LEDSL_WPT, dpath, revert, base)
end

function Wwfcuefisl:SetWpt(valbase, val)
	self:SendBit(self.LEDSL_WPT, valbase, val)
end
-- ========
-- LEDSL VORD
function Wwfcuefisl:GetVord(dpath, revert, base)
	self:GetBit(self.LEDSL_VORD, dpath, revert, base)
end

function Wwfcuefisl:SetVord(valbase, val)
	self:SendBit(self.LEDSL_VORD, valbase, val)
end
-- ========
-- LEDSL NDB
function Wwfcuefisl:GetNdb(dpath, revert, base)
	self:GetBit(self.LEDSL_NDB, dpath, revert, base)
end

function Wwfcuefisl:SetNdb(valbase, val)
	self:SendBit(self.LEDSL_NDB, valbase, val)
end
-- ========
-- LEDSL ARPT
function Wwfcuefisl:GetArpt(dpath, revert, base)
	self:GetBit(self.LEDSL_ARPT, dpath, revert, base)
end

function Wwfcuefisl:SetArpt(valbase, val)
	self:SendBit(self.LEDSL_ARPT, valbase, val)
end

function Wwfcuefisl:SetledsL(valbase, val)
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
return Wwfcuefisl
