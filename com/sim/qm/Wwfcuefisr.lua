-- *****************************************************************
-- Don't modify this file, unless you know what you are doing
-- Most of the code are auto generated
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-08-08_03_55_08UTC
-- *****************************************************************

local Wwfcuefisr = oop.class(com.sim.qm.Wwfcu)
function Wwfcuefisr:init()
	self.QmdevId = 0x03376321
	if _G.ilua_hw_assigned_wwfcuefisr == nil then
		_G.ilua_hw_assigned_wwfcuefisr = 0
		self.ledIds = {
			self.LEDS_LOC,
			self.LEDS_AP1,
			self.LEDS_AP2,
			self.LEDS_ATHR,
			self.LEDS_EXPED,
			self.LEDS_APPR,
			self.LEDS_EXPEDBKL,
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
-- Backlight
function Wwfcuefisr:GetBkl(dpath, scale)
	self.d_bkl_scale = scale == nil and 30 or scale
	self.d_bkl = iDataRef:New(dpath)
end

function Wwfcuefisr:SetBkl(val)
	if val == nil then
		if self.d_bkl:ChangedUpdate() then
			val = self.d_bkl:GetOld() * self.d_bkl_scale
			self:SendLedCmd(self.LEDS_BKL, val)
		end
	else
		self:SendLedCmd(self.LEDS_BKL, val)
	end
end

function Wwfcuefisr:FreshBkl()
	self.d_bkl:Invalid(-1)
end

-- ========
-- Scr Backlight
function Wwfcuefisr:GetScrBkl(dpath, scale)
	self.d_scrbkl_scale = scale == nil and 30 or scale
	self.d_scrbkl = iDataRef:New(dpath)
end

function Wwfcuefisr:SetScrBkl(val)
	if val == nil then
		if self.d_scrbkl:ChangedUpdate() then
			val = self.d_scrbkl:GetOld() * self.d_scrbkl_scale
			self:SendLedCmd(self.LEDS_SCRBKL, val)
		end
	else
		self:SendLedCmd(self.LEDS_SCRBKL, val)
	end
end

function Wwfcuefisr:FreshScrBkl()
	self.d_scrbkl:Invalid(-1)
end

-- ========
-- Led Backlight
function Wwfcuefisr:GetLedBkl(dpath, scale)
	self.d_ledbkl_scale = scale == nil and 30 or scale
	self.d_ledbkl = iDataRef:New(dpath)
end

function Wwfcuefisr:SetLedBkl(val)
	if val == nil then
		if self.d_ledbkl:ChangedUpdate() then
			val = self.d_ledbkl:GetOld() * self.d_ledbkl_scale
			self:SendLedCmd(self.LEDS_LEDBKL, val)
		end
	else
		self:SendLedCmd(self.LEDS_LEDBKL, val)
	end
end

function Wwfcuefisr:FreshLedBkl()
	self.d_ledbkl:Invalid(-1)
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
function Wwfcuefisr:GetBkl(dpath, scale)
	self.d_bkl_scale = scale == nil and 30 or scale
	self.d_bkl = iDataRef:New(dpath)
end

function Wwfcuefisr:SetBkl(val)
	if val == nil then
		if self.d_bkl:ChangedUpdate() then
			val = self.d_bkl:GetOld() * self.d_bkl_scale
			self:SendLedCmd(self.LEDSR_BKL, val)
		end
	else
		self:SendLedCmd(self.LEDSR_BKL, val)
	end
end

function Wwfcuefisr:FreshBkl()
	self.d_bkl:Invalid(-1)
end

-- ========
-- LEDSR SCRBKL
function Wwfcuefisr:GetScrBkl(dpath, scale)
	self.d_scrbkl_scale = scale == nil and 30 or scale
	self.d_scrbkl = iDataRef:New(dpath)
end

function Wwfcuefisr:SetScrBkl(val)
	if val == nil then
		if self.d_scrbkl:ChangedUpdate() then
			val = self.d_scrbkl:GetOld() * self.d_scrbkl_scale
			self:SendLedCmd(self.LEDSR_SCRBKL, val)
		end
	else
		self:SendLedCmd(self.LEDSR_SCRBKL, val)
	end
end

function Wwfcuefisr:FreshScrBkl()
	self.d_scrbkl:Invalid(-1)
end

-- ========
-- LEDSR LEDBKL
function Wwfcuefisr:GetLedBkl(dpath, scale)
	self.d_ledbkl_scale = scale == nil and 30 or scale
	self.d_ledbkl = iDataRef:New(dpath)
end

function Wwfcuefisr:SetLedBkl(val)
	if val == nil then
		if self.d_ledbkl:ChangedUpdate() then
			val = self.d_ledbkl:GetOld() * self.d_ledbkl_scale
			self:SendLedCmd(self.LEDSR_LEDBKL, val)
		end
	else
		self:SendLedCmd(self.LEDSR_LEDBKL, val)
	end
end

function Wwfcuefisr:FreshLedBkl()
	self.d_ledbkl:Invalid(-1)
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
	self:SetFd(valbase, val)
	self:SetLs(valbase, val)
	self:SetCstr(valbase, val)
	self:SetWpt(valbase, val)
	self:SetVord(valbase, val)
	self:SetNdb(valbase, val)
	self:SetArpt(valbase, val)
end

return Wwfcuefisr
