
-- *****************************************************************
-- Don't modify this file, unless you know what you are doing
-- Most of the code are auto generated
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-08-08_03_55_08UTC
-- *****************************************************************

local Wwpap3 = oop.class(com.sim.Qmdev)
function Wwpap3:init()
	self.QmdevId = 0x0939BE95
	self.FastTurnsPerSecond = 5
	if _G.ilua_hw_assigned_wwpap3 == nil then
		_G.ilua_hw_assigned_wwpap3 = 0
		self.LEDS_BKL = 0
		self.LEDS_LCDBKL = 1
		self.LEDS_LEDBKL = 2
		self.LEDS_N1 = 3
		self.LEDS_SPEED = 4
		self.LEDS_VNAV = 5
		self.LEDS_LVLCHG = 6
		self.LEDS_HDGSEL = 7
		self.LEDS_LNAV = 8
		self.LEDS_VORLOC = 9
		self.LEDS_APP = 10
		self.LEDS_ALTHLD = 11
		self.LEDS_VS = 12
		self.LEDS_CMDA = 13
		self.LEDS_CWSA = 14
		self.LEDS_CMDB = 15
		self.LEDS_CWSB = 16
		self.LEDS_ATARM = 17
		self.LEDS_MACAPT = 18
		self.LEDS_MAFO = 19
		self.LEDS_ATSOL = 30
		self.ledIds = {
			self.LEDS_BKL,
			self.LEDS_LCDBKL,
			self.LEDS_LEDBKL,
			self.LEDS_N1,
			self.LEDS_SPEED,
			self.LEDS_VNAV,
			self.LEDS_LVLCHG,
			self.LEDS_HDGSEL,
			self.LEDS_LNAV,
			self.LEDS_VORLOC,
			self.LEDS_APP,
			self.LEDS_ALTHLD,
			self.LEDS_VS,
			self.LEDS_CMDA,
			self.LEDS_CWSA,
			self.LEDS_CMDB,
			self.LEDS_CWSB,
			self.LEDS_ATARM,
			self.LEDS_MACAPT,
			self.LEDS_MAFO,
			self.LEDS_ATSOL
		}
	end
end

function Wwpap3:absent(FastTurnsPerSecond)
	if not uluaFind('cpuwolf/flyluaio/WwPap3/leds/ledCmd') then
		return true
	end
	_G.idr_wwpap3_hid_leds_ledcmd = uluaFind('cpuwolf/flyluaio/WwPap3/leds/ledCmd')
	_G.idr_wwpap3_hid_init_seqnum = uluaFind('cpuwolf/flyluaio/WwPap3/init/seqNum')
	_G.idr_wwpap3_hid_lcd_seqnum = uluaFind('cpuwolf/flyluaio/WwPap3/lcd/seqNum')
	_G.idr_wwpap3_hid_lcd_lcd1 = uluaFind('cpuwolf/flyluaio/WwPap3/lcd/lcd1')
	_G.idr_wwpap3_hid_lcd_lcd2 = uluaFind('cpuwolf/flyluaio/WwPap3/lcd/lcd2')
	_G.idr_wwpap3_hid_lcd_lcd3 = uluaFind('cpuwolf/flyluaio/WwPap3/lcd/lcd3')
	_G.idr_wwpap3_hid_lcd_lcd4 = uluaFind('cpuwolf/flyluaio/WwPap3/lcd/lcd4')
	_G.idr_wwpap3_hid_lcd_lcd5 = uluaFind('cpuwolf/flyluaio/WwPap3/lcd/lcd5')
	_G.idr_wwpap3_hid_lcd_lcd6 = uluaFind('cpuwolf/flyluaio/WwPap3/lcd/lcd6')
	_G.idr_wwpap3_hid_lcd_lcd7 = uluaFind('cpuwolf/flyluaio/WwPap3/lcd/lcd7')
	_G.idr_wwpap3_hid_lcd_lcd8 = uluaFind('cpuwolf/flyluaio/WwPap3/lcd/lcd8')
	_G.idr_wwpap3_hid_empty_seqnum = uluaFind('cpuwolf/flyluaio/WwPap3/empty/seqNum')
	_G.idr_wwpap3_hid_finish_seqnum = uluaFind('cpuwolf/flyluaio/WwPap3/finish/seqNum')
	_G.idr_wwpap3_hid_invalid = uluaFind('cpuwolf/flyluaio/WwPap3/invalid')
	_G.idr_wwpap3_hid_fastkeypersec = uluaFind('cpuwolf/flyluaio/WwPap3/fastkeypersec')
	uluaSet(_G.idr_wwpap3_hid_fastkeypersec, FastTurnsPerSecond)
	return false
end

function Wwpap3:Init(FastTurnsPerSecond)
	local ftps = FastTurnsPerSecond == nil and self.FastTurnsPerSecond or FastTurnsPerSecond
	if self:absent(ftps) then
		return false
	end
	if _G.ilua_hw_assigned_wwpap3 == 1 then
		return false
	end
	_G.ilua_hw_assigned_wwpap3 = 1
	return true
end

function Wwpap3.Open(...)
	return com.sim.Qmdev.Open(Wwpap3, ...)
end

-- ========
-- LEDS BKL
function Wwpap3:GetBkl(dpath, revert, base)
	self:GetBit(self.LEDS_BKL, dpath, revert, base)
end

function Wwpap3:SetBkl(valbase, val)
	self:SendBit(self.LEDS_BKL, valbase, val)
end
-- ========
-- LEDS LCDBKL
function Wwpap3:GetLcdBkl(dpath, revert, base)
	self:GetBit(self.LEDS_LCDBKL, dpath, revert, base)
end

function Wwpap3:SetLcdBkl(valbase, val)
	self:SendBit(self.LEDS_LCDBKL, valbase, val)
end
-- ========
-- LEDS LEDBKL
function Wwpap3:GetLedBkl(dpath, revert, base)
	self:GetBit(self.LEDS_LEDBKL, dpath, revert, base)
end

function Wwpap3:SetLedBkl(valbase, val)
	self:SendBit(self.LEDS_LEDBKL, valbase, val)
end
-- ========
-- LEDS N1
function Wwpap3:GetN1(dpath, revert, base)
	self:GetBit(self.LEDS_N1, dpath, revert, base)
end

function Wwpap3:SetN1(valbase, val)
	self:SendBit(self.LEDS_N1, valbase, val)
end
-- ========
-- LEDS SPEED
function Wwpap3:GetSpeed(dpath, revert, base)
	self:GetBit(self.LEDS_SPEED, dpath, revert, base)
end

function Wwpap3:SetSpeed(valbase, val)
	self:SendBit(self.LEDS_SPEED, valbase, val)
end
-- ========
-- LEDS VNAV
function Wwpap3:GetVnav(dpath, revert, base)
	self:GetBit(self.LEDS_VNAV, dpath, revert, base)
end

function Wwpap3:SetVnav(valbase, val)
	self:SendBit(self.LEDS_VNAV, valbase, val)
end
-- ========
-- LEDS LVLCHG
function Wwpap3:GetLvlChg(dpath, revert, base)
	self:GetBit(self.LEDS_LVLCHG, dpath, revert, base)
end

function Wwpap3:SetLvlChg(valbase, val)
	self:SendBit(self.LEDS_LVLCHG, valbase, val)
end
-- ========
-- LEDS HDGSEL
function Wwpap3:GetHdgSel(dpath, revert, base)
	self:GetBit(self.LEDS_HDGSEL, dpath, revert, base)
end

function Wwpap3:SetHdgSel(valbase, val)
	self:SendBit(self.LEDS_HDGSEL, valbase, val)
end
-- ========
-- LEDS LNAV
function Wwpap3:GetLnav(dpath, revert, base)
	self:GetBit(self.LEDS_LNAV, dpath, revert, base)
end

function Wwpap3:SetLnav(valbase, val)
	self:SendBit(self.LEDS_LNAV, valbase, val)
end
-- ========
-- LEDS VORLOC
function Wwpap3:GetVorLoc(dpath, revert, base)
	self:GetBit(self.LEDS_VORLOC, dpath, revert, base)
end

function Wwpap3:SetVorLoc(valbase, val)
	self:SendBit(self.LEDS_VORLOC, valbase, val)
end
-- ========
-- LEDS APP
function Wwpap3:GetApp(dpath, revert, base)
	self:GetBit(self.LEDS_APP, dpath, revert, base)
end

function Wwpap3:SetApp(valbase, val)
	self:SendBit(self.LEDS_APP, valbase, val)
end
-- ========
-- LEDS ALTHLD
function Wwpap3:GetAltHld(dpath, revert, base)
	self:GetBit(self.LEDS_ALTHLD, dpath, revert, base)
end

function Wwpap3:SetAltHld(valbase, val)
	self:SendBit(self.LEDS_ALTHLD, valbase, val)
end
-- ========
-- LEDS VS
function Wwpap3:GetVs(dpath, revert, base)
	self:GetBit(self.LEDS_VS, dpath, revert, base)
end

function Wwpap3:SetVs(valbase, val)
	self:SendBit(self.LEDS_VS, valbase, val)
end
-- ========
-- LEDS CMDA
function Wwpap3:GetCmdA(dpath, revert, base)
	self:GetBit(self.LEDS_CMDA, dpath, revert, base)
end

function Wwpap3:SetCmdA(valbase, val)
	self:SendBit(self.LEDS_CMDA, valbase, val)
end
-- ========
-- LEDS CWSA
function Wwpap3:GetCwsA(dpath, revert, base)
	self:GetBit(self.LEDS_CWSA, dpath, revert, base)
end

function Wwpap3:SetCwsA(valbase, val)
	self:SendBit(self.LEDS_CWSA, valbase, val)
end
-- ========
-- LEDS CMDB
function Wwpap3:GetCmdB(dpath, revert, base)
	self:GetBit(self.LEDS_CMDB, dpath, revert, base)
end

function Wwpap3:SetCmdB(valbase, val)
	self:SendBit(self.LEDS_CMDB, valbase, val)
end
-- ========
-- LEDS CWSB
function Wwpap3:GetCwsB(dpath, revert, base)
	self:GetBit(self.LEDS_CWSB, dpath, revert, base)
end

function Wwpap3:SetCwsB(valbase, val)
	self:SendBit(self.LEDS_CWSB, valbase, val)
end
-- ========
-- LEDS ATARM
function Wwpap3:GetAtArm(dpath, revert, base)
	self:GetBit(self.LEDS_ATARM, dpath, revert, base)
end

function Wwpap3:SetAtArm(valbase, val)
	self:SendBit(self.LEDS_ATARM, valbase, val)
end
-- ========
-- LEDS MACAPT
function Wwpap3:GetMaCapt(dpath, revert, base)
	self:GetBit(self.LEDS_MACAPT, dpath, revert, base)
end

function Wwpap3:SetMaCapt(valbase, val)
	self:SendBit(self.LEDS_MACAPT, valbase, val)
end
-- ========
-- LEDS MAFO
function Wwpap3:GetMaFo(dpath, revert, base)
	self:GetBit(self.LEDS_MAFO, dpath, revert, base)
end

function Wwpap3:SetMaFo(valbase, val)
	self:SendBit(self.LEDS_MAFO, valbase, val)
end
-- ========
-- LEDS ATSOL
function Wwpap3:GetAtSol(dpath, revert, base)
	self:GetBit(self.LEDS_ATSOL, dpath, revert, base)
end

function Wwpap3:SetAtSol(valbase, val)
	self:SendBit(self.LEDS_ATSOL, valbase, val)
end

function Wwpap3:Setleds(valbase, val)
	self:SetBkl(valbase, val)
	self:SetLcdBkl(valbase, val)
	self:SetLedBkl(valbase, val)
	self:SetN1(valbase, val)
	self:SetSpeed(valbase, val)
	self:SetVnav(valbase, val)
	self:SetLvlChg(valbase, val)
	self:SetHdgSel(valbase, val)
	self:SetLnav(valbase, val)
	self:SetVorLoc(valbase, val)
	self:SetApp(valbase, val)
	self:SetAltHld(valbase, val)
	self:SetVs(valbase, val)
	self:SetCmdA(valbase, val)
	self:SetCwsA(valbase, val)
	self:SetCmdB(valbase, val)
	self:SetCwsB(valbase, val)
	self:SetAtArm(valbase, val)
	self:SetMaCapt(valbase, val)
	self:SetMaFo(valbase, val)
	self:SetAtSol(valbase, val)
end
return Wwpap3
