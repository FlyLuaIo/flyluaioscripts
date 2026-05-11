-- *****************************************************************
-- Don't modify this file, unless you know what you are doing
-- Most of the code are auto generated
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-05-11_08_31_31UTC
-- *****************************************************************

local Wfdap500 = oop.class(com.sim.Qmdev)
function Wfdap500:init()
	self.QmdevId = 0x2C94C7A3
	self.FastTurnsPerSecond = 5
	if _G.ilua_hw_assigned_wfdap500 == nil then
		_G.ilua_hw_assigned_wfdap500 = 0
	end
end

function Wfdap500:absent(FastTurnsPerSecond)
	if not uluaFind('cpuwolf/flyluaio/WfDap500/leds/bits') then
		return true
	end
	_G.idr_wfdap500_hid_leds_bits = uluaFind('cpuwolf/flyluaio/WfDap500/leds/bits')
	_G.idr_wfdap500_hid_leds_bkl = uluaFind('cpuwolf/flyluaio/WfDap500/leds/bkl')
	_G.idr_wfdap500_hid_leds_apr = uluaFind('cpuwolf/flyluaio/WfDap500/leds/apr')
	_G.idr_wfdap500_hid_leds_nav = uluaFind('cpuwolf/flyluaio/WfDap500/leds/nav')
	_G.idr_wfdap500_hid_leds_trk = uluaFind('cpuwolf/flyluaio/WfDap500/leds/trk')
	_G.idr_wfdap500_hid_leds_hdg = uluaFind('cpuwolf/flyluaio/WfDap500/leds/hdg')
	_G.idr_wfdap500_hid_leds_ap = uluaFind('cpuwolf/flyluaio/WfDap500/leds/ap')
	_G.idr_wfdap500_hid_leds_fd = uluaFind('cpuwolf/flyluaio/WfDap500/leds/fd')
	_G.idr_wfdap500_hid_leds_lvl = uluaFind('cpuwolf/flyluaio/WfDap500/leds/lvl')
	_G.idr_wfdap500_hid_leds_yd = uluaFind('cpuwolf/flyluaio/WfDap500/leds/yd')
	_G.idr_wfdap500_hid_leds_ias = uluaFind('cpuwolf/flyluaio/WfDap500/leds/ias')
	_G.idr_wfdap500_hid_leds_vnav = uluaFind('cpuwolf/flyluaio/WfDap500/leds/vnav')
	_G.idr_wfdap500_hid_leds_vs = uluaFind('cpuwolf/flyluaio/WfDap500/leds/vs')
	_G.idr_wfdap500_hid_leds_alt = uluaFind('cpuwolf/flyluaio/WfDap500/leds/alt')
	_G.idr_wfdap500_hid_invalid = uluaFind('cpuwolf/flyluaio/WfDap500/invalid')
	_G.idr_wfdap500_hid_fastkeypersec = uluaFind('cpuwolf/flyluaio/WfDap500/fastkeypersec')
	uluaSet(_G.idr_wfdap500_hid_fastkeypersec, FastTurnsPerSecond)
	return false
end

function Wfdap500:Init(FastTurnsPerSecond)
	local ftps = FastTurnsPerSecond == nil and self.FastTurnsPerSecond or FastTurnsPerSecond
	if self:absent(ftps) then
		return false
	end
	if _G.ilua_hw_assigned_wfdap500 == 1 then
		return false
	end
	_G.ilua_hw_assigned_wfdap500 = 1
	return true
end

-- ========
-- leds apr

function Wfdap500:GetApr(dpath)
	self:GetBit(1, dpath)
end

function Wfdap500:SetApr(valbase, val)
	self:SetBit(1, _G.idr_wfdap500_hid_leds_apr, valbase, val)
end

-- ========
-- leds nav

function Wfdap500:GetNav(dpath)
	self:GetBit(2, dpath)
end

function Wfdap500:SetNav(valbase, val)
	self:SetBit(2, _G.idr_wfdap500_hid_leds_nav, valbase, val)
end

-- ========
-- leds trk

function Wfdap500:GetTrk(dpath)
	self:GetBit(3, dpath)
end

function Wfdap500:SetTrk(valbase, val)
	self:SetBit(3, _G.idr_wfdap500_hid_leds_trk, valbase, val)
end

-- ========
-- leds hdg

function Wfdap500:GetHdg(dpath)
	self:GetBit(4, dpath)
end

function Wfdap500:SetHdg(valbase, val)
	self:SetBit(4, _G.idr_wfdap500_hid_leds_hdg, valbase, val)
end

-- ========
-- leds ap

function Wfdap500:GetAp(dpath)
	self:GetBit(5, dpath)
end

function Wfdap500:SetAp(valbase, val)
	self:SetBit(5, _G.idr_wfdap500_hid_leds_ap, valbase, val)
end

-- ========
-- leds fd

function Wfdap500:GetFd(dpath)
	self:GetBit(6, dpath)
end

function Wfdap500:SetFd(valbase, val)
	self:SetBit(6, _G.idr_wfdap500_hid_leds_fd, valbase, val)
end

-- ========
-- leds lvl

function Wfdap500:GetLvl(dpath)
	self:GetBit(7, dpath)
end

function Wfdap500:SetLvl(valbase, val)
	self:SetBit(7, _G.idr_wfdap500_hid_leds_lvl, valbase, val)
end

-- ========
-- leds yd

function Wfdap500:GetYd(dpath)
	self:GetBit(8, dpath)
end

function Wfdap500:SetYd(valbase, val)
	self:SetBit(8, _G.idr_wfdap500_hid_leds_yd, valbase, val)
end

-- ========
-- leds ias

function Wfdap500:GetIas(dpath)
	self:GetBit(9, dpath)
end

function Wfdap500:SetIas(valbase, val)
	self:SetBit(9, _G.idr_wfdap500_hid_leds_ias, valbase, val)
end

-- ========
-- leds vnav

function Wfdap500:GetVnav(dpath)
	self:GetBit(10, dpath)
end

function Wfdap500:SetVnav(valbase, val)
	self:SetBit(10, _G.idr_wfdap500_hid_leds_vnav, valbase, val)
end

-- ========
-- leds vs

function Wfdap500:GetVs(dpath)
	self:GetBit(11, dpath)
end

function Wfdap500:SetVs(valbase, val)
	self:SetBit(11, _G.idr_wfdap500_hid_leds_vs, valbase, val)
end

-- ========
-- leds alt

function Wfdap500:GetAlt(dpath)
	self:GetBit(12, dpath)
end

function Wfdap500:SetAlt(valbase, val)
	self:SetBit(12, _G.idr_wfdap500_hid_leds_alt, valbase, val)
end

function Wfdap500:SetLeds(valbase, val)
	self:SetApr(valbase, val)
	self:SetNav(valbase, val)
	self:SetTrk(valbase, val)
	self:SetHdg(valbase, val)
	self:SetAp(valbase, val)
	self:SetFd(valbase, val)
	self:SetLvl(valbase, val)
	self:SetYd(valbase, val)
	self:SetIas(valbase, val)
	self:SetVnav(valbase, val)
	self:SetVs(valbase, val)
	self:SetAlt(valbase, val)
end

-- ========
-- Backlight
function Wfdap500:GetBkl(dpath, scale)
	self.d_bkl_scale = scale == nil and 30 or scale
	self.d_bkl = iDataRef:New(dpath)
end

function Wfdap500:SetBkl(val)
	if val == nil then
		val = self.d_bkl:Get() * self.d_bkl_scale
		if self.d_bkl:ChangedUpdate() then
			uluaSet(idr_wfdap500_hid_leds_bkl, val)
		end
	else
		uluaSet(idr_wfdap500_hid_leds_bkl, val)
	end
end

function Wfdap500:FreshBkl()
	self.d_bkl:Invalid(-1)
end

-- ========
-- Test Mode
function Wfdap500:SetTest()
	uluaSet(idr_wfdap500_hid_leds_bits, 255)
end

return Wfdap500
