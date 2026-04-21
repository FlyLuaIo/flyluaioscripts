
-- *****************************************************************
-- Don't modify this file, unless you know what you are doing
-- Most of the code are auto generated
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-04-21_09_27_02UTC
-- *****************************************************************

local Wffcuc = oop.class(com.sim.Qmdev)
function Wffcuc:init()
	self.QmdevId = 0x XXXXXX
	self.FastTurnsPerSecond = 5
	if _G.ilua_hw_assigned_wffcuc == nil then
		_G.ilua_hw_assigned_wffcuc = 0
	end
end

function Wffcuc:absent(FastTurnsPerSecond)
	if not uluaFind('cpuwolf/qmdev/WfFcuc/leds/bits') then
		return true
	end
	_G.idr_wffcuc_hid_leds_bits = uluaFind('cpuwolf/qmdev/WfFcuc/leds/bits')
	_G.idr_wffcuc_hid_leds_bkl = uluaFind('cpuwolf/qmdev/WfFcuc/leds/bkl')
	_G.idr_wffcuc_hid_leds_lcdbkl = uluaFind('cpuwolf/qmdev/WfFcuc/leds/lcdbkl')
	_G.idr_wffcuc_hid_leds_spdval = uluaFind('cpuwolf/qmdev/WfFcuc/leds/SpdVal')
	_G.idr_wffcuc_hid_leds_hdgval = uluaFind('cpuwolf/qmdev/WfFcuc/leds/HdgVal')
	_G.idr_wffcuc_hid_leds_altval = uluaFind('cpuwolf/qmdev/WfFcuc/leds/AltVal')
	_G.idr_wffcuc_hid_leds_vsval = uluaFind('cpuwolf/qmdev/WfFcuc/leds/VsVal')
	_G.idr_wffcuc_hid_leds_loc = uluaFind('cpuwolf/qmdev/WfFcuc/leds/loc')
	_G.idr_wffcuc_hid_leds_ap1 = uluaFind('cpuwolf/qmdev/WfFcuc/leds/ap1')
	_G.idr_wffcuc_hid_leds_ap2 = uluaFind('cpuwolf/qmdev/WfFcuc/leds/ap2')
	_G.idr_wffcuc_hid_leds_athr = uluaFind('cpuwolf/qmdev/WfFcuc/leds/athr')
	_G.idr_wffcuc_hid_leds_exped = uluaFind('cpuwolf/qmdev/WfFcuc/leds/exped')
	_G.idr_wffcuc_hid_leds_appr = uluaFind('cpuwolf/qmdev/WfFcuc/leds/appr')
	_G.idr_wffcuc_hid_leds_spdmang = uluaFind('cpuwolf/qmdev/WfFcuc/leds/SpdMang')
	_G.idr_wffcuc_hid_leds_spddash = uluaFind('cpuwolf/qmdev/WfFcuc/leds/SpdDash')
	_G.idr_wffcuc_hid_leds_hdgmang = uluaFind('cpuwolf/qmdev/WfFcuc/leds/HdgMang')
	_G.idr_wffcuc_hid_leds_hdgdash = uluaFind('cpuwolf/qmdev/WfFcuc/leds/HdgDash')
	_G.idr_wffcuc_hid_leds_altmang = uluaFind('cpuwolf/qmdev/WfFcuc/leds/AltMang')
	_G.idr_wffcuc_hid_leds_vsdash = uluaFind('cpuwolf/qmdev/WfFcuc/leds/VsDash')
	_G.idr_wffcuc_hid_leds_spdmach = uluaFind('cpuwolf/qmdev/WfFcuc/leds/SpdMach')
	_G.idr_wffcuc_hid_leds_hdgtrk = uluaFind('cpuwolf/qmdev/WfFcuc/leds/HdgTrk')
	_G.idr_wffcuc_hid_leds_test = uluaFind('cpuwolf/qmdev/WfFcuc/leds/test')
	_G.idr_wffcuc_hid_leds_power = uluaFind('cpuwolf/qmdev/WfFcuc/leds/power')
	_G.idr_wffcuc_hid_invalid = uluaFind('cpuwolf/qmdev/WfFcuc/invalid')
	_G.idr_wffcuc_hid_fastkeypersec = uluaFind('cpuwolf/qmdev/WfFcuc/fastkeypersec')
	uluaSet(_G.idr_wffcuc_hid_fastkeypersec, FastTurnsPerSecond)
	return false
end

function Wffcuc:Init(FastTurnsPerSecond)
	local ftps = FastTurnsPerSecond == nil and self.FastTurnsPerSecond or FastTurnsPerSecond
	if self:absent(ftps) then
		return false
	end
	if _G.ilua_hw_assigned_wffcuc == 1 then
		return false
	end
	_G.ilua_hw_assigned_wffcuc = 1
	return true
end

-- ========
-- leds loc

function Wffcuc:GetLoc(dpath)
	self:GetBit(1, dpath)
end

function Wffcuc:SetLoc(valbase, val)
	self:SetBit(1, _G.idr_wffcuc_hid_leds_loc, valbase, val)
end

-- ========
-- leds ap1

function Wffcuc:GetAp1(dpath)
	self:GetBit(2, dpath)
end

function Wffcuc:SetAp1(valbase, val)
	self:SetBit(2, _G.idr_wffcuc_hid_leds_ap1, valbase, val)
end

-- ========
-- leds ap2

function Wffcuc:GetAp2(dpath)
	self:GetBit(3, dpath)
end

function Wffcuc:SetAp2(valbase, val)
	self:SetBit(3, _G.idr_wffcuc_hid_leds_ap2, valbase, val)
end

-- ========
-- leds athr

function Wffcuc:GetAthr(dpath)
	self:GetBit(4, dpath)
end

function Wffcuc:SetAthr(valbase, val)
	self:SetBit(4, _G.idr_wffcuc_hid_leds_athr, valbase, val)
end

-- ========
-- leds exped

function Wffcuc:GetExped(dpath)
	self:GetBit(5, dpath)
end

function Wffcuc:SetExped(valbase, val)
	self:SetBit(5, _G.idr_wffcuc_hid_leds_exped, valbase, val)
end

-- ========
-- leds appr

function Wffcuc:GetAppr(dpath)
	self:GetBit(6, dpath)
end

function Wffcuc:SetAppr(valbase, val)
	self:SetBit(6, _G.idr_wffcuc_hid_leds_appr, valbase, val)
end

-- ========
-- leds SpdMang

function Wffcuc:GetSpdmang(dpath)
	self:GetBit(7, dpath)
end

function Wffcuc:SetSpdmang(valbase, val)
	self:SetBit(7, _G.idr_wffcuc_hid_leds_spdmang, valbase, val)
end

-- ========
-- leds SpdDash

function Wffcuc:GetSpddash(dpath)
	self:GetBit(8, dpath)
end

function Wffcuc:SetSpddash(valbase, val)
	self:SetBit(8, _G.idr_wffcuc_hid_leds_spddash, valbase, val)
end

-- ========
-- leds HdgMang

function Wffcuc:GetHdgmang(dpath)
	self:GetBit(9, dpath)
end

function Wffcuc:SetHdgmang(valbase, val)
	self:SetBit(9, _G.idr_wffcuc_hid_leds_hdgmang, valbase, val)
end

-- ========
-- leds HdgDash

function Wffcuc:GetHdgdash(dpath)
	self:GetBit(10, dpath)
end

function Wffcuc:SetHdgdash(valbase, val)
	self:SetBit(10, _G.idr_wffcuc_hid_leds_hdgdash, valbase, val)
end

-- ========
-- leds AltMang

function Wffcuc:GetAltmang(dpath)
	self:GetBit(11, dpath)
end

function Wffcuc:SetAltmang(valbase, val)
	self:SetBit(11, _G.idr_wffcuc_hid_leds_altmang, valbase, val)
end

-- ========
-- leds VsDash

function Wffcuc:GetVsdash(dpath)
	self:GetBit(12, dpath)
end

function Wffcuc:SetVsdash(valbase, val)
	self:SetBit(12, _G.idr_wffcuc_hid_leds_vsdash, valbase, val)
end

-- ========
-- leds SpdMach

function Wffcuc:GetSpdmach(dpath)
	self:GetBit(13, dpath)
end

function Wffcuc:SetSpdmach(valbase, val)
	self:SetBit(13, _G.idr_wffcuc_hid_leds_spdmach, valbase, val)
end

-- ========
-- leds HdgTrk

function Wffcuc:GetHdgtrk(dpath)
	self:GetBit(14, dpath)
end

function Wffcuc:SetHdgtrk(valbase, val)
	self:SetBit(14, _G.idr_wffcuc_hid_leds_hdgtrk, valbase, val)
end

-- ========
-- leds test

function Wffcuc:GetTest(dpath)
	self:GetBit(15, dpath)
end

function Wffcuc:SetTest(valbase, val)
	self:SetBit(15, _G.idr_wffcuc_hid_leds_test, valbase, val)
end

-- ========
-- leds power

function Wffcuc:GetPower(dpath)
	self:GetBit(16, dpath)
end

function Wffcuc:SetPower(valbase, val)
	self:SetBit(16, _G.idr_wffcuc_hid_leds_power, valbase, val)
end

function Wffcuc:SetLeds(valbase, val)
	self:SetLoc(valbase, val)
	self:SetAp1(valbase, val)
	self:SetAp2(valbase, val)
	self:SetAthr(valbase, val)
	self:SetExped(valbase, val)
	self:SetAppr(valbase, val)
	self:SetSpdmang(valbase, val)
	self:SetSpddash(valbase, val)
	self:SetHdgmang(valbase, val)
	self:SetHdgdash(valbase, val)
	self:SetAltmang(valbase, val)
	self:SetVsdash(valbase, val)
	self:SetSpdmach(valbase, val)
	self:SetHdgtrk(valbase, val)
	self:SetTest(valbase, val)
	self:SetPower(valbase, val)
end

return Wffcuc
