-- *****************************************************************
-- Don't modify this file, unless you know what you are doing
-- Most of the code are auto generated
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-04-21_09_27_02UTC
-- *****************************************************************
local bit = require("bit")

local Wffcuc = oop.class(com.sim.Qmdev)
function Wffcuc:init()
	self.QmdevId = 0x2AD269AD
	self.FastTurnsPerSecond = 10
	self.counter = 0
	self.timestamp = uluagetTimestamp()
	self.ms = 800
	if _G.ilua_hw_assigned_wffcuc == nil then
		_G.ilua_hw_assigned_wffcuc = 0
	end
end

function Wffcuc:absent(FastTurnsPerSecond)
	if not uluaFind('cpuwolf/flyluaio/WfFcuc/leds/bits') then
		return true
	end
	_G.idr_wffcuc_hid_leds_bits = uluaFind('cpuwolf/flyluaio/WfFcuc/leds/bits')
	_G.idr_wffcuc_hid_leds_bkl = uluaFind('cpuwolf/flyluaio/WfFcuc/leds/bkl')
	_G.idr_wffcuc_hid_leds_lcdbkl = uluaFind('cpuwolf/flyluaio/WfFcuc/leds/lcdbkl')
	_G.idr_wffcuc_hid_leds_spdval = uluaFind('cpuwolf/flyluaio/WfFcuc/leds/SpdVal')
	_G.idr_wffcuc_hid_leds_hdgval = uluaFind('cpuwolf/flyluaio/WfFcuc/leds/HdgVal')
	_G.idr_wffcuc_hid_leds_altval = uluaFind('cpuwolf/flyluaio/WfFcuc/leds/AltVal')
	_G.idr_wffcuc_hid_leds_vsval = uluaFind('cpuwolf/flyluaio/WfFcuc/leds/VsVal')
	_G.idr_wffcuc_hid_leds_loc = uluaFind('cpuwolf/flyluaio/WfFcuc/leds/loc')
	_G.idr_wffcuc_hid_leds_ap1 = uluaFind('cpuwolf/flyluaio/WfFcuc/leds/ap1')
	_G.idr_wffcuc_hid_leds_ap2 = uluaFind('cpuwolf/flyluaio/WfFcuc/leds/ap2')
	_G.idr_wffcuc_hid_leds_athr = uluaFind('cpuwolf/flyluaio/WfFcuc/leds/athr')
	_G.idr_wffcuc_hid_leds_exped = uluaFind('cpuwolf/flyluaio/WfFcuc/leds/exped')
	_G.idr_wffcuc_hid_leds_appr = uluaFind('cpuwolf/flyluaio/WfFcuc/leds/appr')
	_G.idr_wffcuc_hid_leds_spdmang = uluaFind('cpuwolf/flyluaio/WfFcuc/leds/SpdMang')
	_G.idr_wffcuc_hid_leds_spddash = uluaFind('cpuwolf/flyluaio/WfFcuc/leds/SpdDash')
	_G.idr_wffcuc_hid_leds_hdgmang = uluaFind('cpuwolf/flyluaio/WfFcuc/leds/HdgMang')
	_G.idr_wffcuc_hid_leds_hdgdash = uluaFind('cpuwolf/flyluaio/WfFcuc/leds/HdgDash')
	_G.idr_wffcuc_hid_leds_altmang = uluaFind('cpuwolf/flyluaio/WfFcuc/leds/AltMang')
	_G.idr_wffcuc_hid_leds_vsdash = uluaFind('cpuwolf/flyluaio/WfFcuc/leds/VsDash')
	_G.idr_wffcuc_hid_leds_spdmach = uluaFind('cpuwolf/flyluaio/WfFcuc/leds/SpdMach')
	_G.idr_wffcuc_hid_leds_hdgtrk = uluaFind('cpuwolf/flyluaio/WfFcuc/leds/HdgTrk')
	_G.idr_wffcuc_hid_leds_test = uluaFind('cpuwolf/flyluaio/WfFcuc/leds/test')
	_G.idr_wffcuc_hid_leds_resv = uluaFind('cpuwolf/flyluaio/WfFcuc/leds/resv')
	_G.idr_wffcuc_hid_leds_power = uluaFind('cpuwolf/flyluaio/WfFcuc/leds/power')
	_G.idr_wffcuc_hid_invalid = uluaFind('cpuwolf/flyluaio/WfFcuc/invalid')
	_G.idr_wffcuc_hid_fastkeypersec = uluaFind('cpuwolf/flyluaio/WfFcuc/fastkeypersec')
	-- rotary encorders
	self.dr_axis = {}
	self.dr_axis[1] = iDataRef:New('cpuwolf/flyluaio/WfFcuc/axisesmap[0]')
	self.dr_axis[2] = iDataRef:New('cpuwolf/flyluaio/WfFcuc/axisesmap[1]')
	self.dr_axis[3] = iDataRef:New('cpuwolf/flyluaio/WfFcuc/axisesmap[2]')
	self.dr_axis[4] = iDataRef:New('cpuwolf/flyluaio/WfFcuc/axisesmap[3]')
	self.dr_axis_cmd_dec = {}
	self.dr_axis_cmd_inc = {}
	self.dr_axis_drf_dec = {}
	self.dr_axis_drf_inc = {}
	self.dr_axis_rpn_dec = {}
	self.dr_axis_rpn_inc = {}
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
-- leds resv

function Wffcuc:GetResv(dpath)
	self:GetBit(16, dpath)
end

function Wffcuc:SetResv(valbase, val)
	self:SetBit(16, _G.idr_wffcuc_hid_leds_resv, valbase, val)
end

-- ========
-- leds power

function Wffcuc:GetPower(dpath)
	self:GetBit(17, dpath)
end

function Wffcuc:SetPower(valbase, val)
	self:SetBit(17, _G.idr_wffcuc_hid_leds_power, valbase, val)
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
end

-- ========
-- wingFlex old firmware force update interval < 1000ms

function Wffcuc:ForceFresh()
	local stp = uluagetTimestamp()
	if stp - self.timestamp > self.ms then
		self.timestamp = stp
		self.counter = (self.counter + 1) % 2
		uluaSet(_G.idr_wffcuc_hid_leds_resv, self.counter)
	end
end

-- ========
-- Backlight
function Wffcuc:GetBkl(dpath, scale)
	self.d_bkl_scale = scale == nil and 30 or scale
	self.d_bkl = iDataRef:New(dpath)
end

function Wffcuc:SetBkl(val)
	if val == nil then
		val = self.d_bkl:Get() * self.d_bkl_scale
		if self.d_bkl:ChangedUpdate() then
			uluaSet(idr_wffcuc_hid_leds_bkl, val)
		end
	else
		uluaSet(idr_wffcuc_hid_leds_bkl, val)
	end
end

function Wffcuc:FreshBkl()
	self.d_bkl:Invalid(-1)
end

-- ========
-- LCD Backlight
function Wffcuc:GetLcdBkl(dpath, scale)
	self.d_lcdbkl_scale = scale == nil and 30 or scale
	self.d_lcdbkl = iDataRef:New(dpath)
end

function Wffcuc:SetLcdBkl(val)
	if val == nil then
		val = self.d_lcdbkl:Get() * self.d_lcdbkl_scale
		if self.d_lcdbkl:ChangedUpdate() then
			uluaSet(idr_wffcuc_hid_leds_lcdbkl, val)
		end
	else
		uluaSet(idr_wffcuc_hid_leds_lcdbkl, val)
	end
end

function Wffcuc:FreshLcdBkl()
	self.d_lcdbkl:Invalid(-1)
end

-- ========
-- Spd
function Wffcuc:GetSpd(dpath)
	self.d_spd = iDataRef:New(dpath)
end

function Wffcuc:SetSpd(val)
	if val == nil then
		val = self.d_spd:Get()
		if self.d_spd:ChangedUpdate() then
			if val < 1 then
				val = val * 100
			end
			uluaSet(idr_wffcuc_hid_leds_spdval, self:swap16(val))
		end
	else
		uluaSet(idr_wffcuc_hid_leds_spdval, self:swap16(val))
	end
end

function Wffcuc:FreshSpd()
	self.d_spd:Invalid(-1)
end

-- ========
-- Hdg
function Wffcuc:GetHdg(dpath)
	self.d_hdg = iDataRef:New(dpath)
end

function Wffcuc:SetHdg(val)
	if val == nil then
		val = self.d_hdg:Get()
		if self.d_hdg:ChangedUpdate() then
			uluaSet(idr_wffcuc_hid_leds_hdgval, self:swap16(val))
		end
	else
		uluaSet(idr_wffcuc_hid_leds_hdgval, self:swap16(val))
	end
end

function Wffcuc:FreshHdg()
	self.d_hdg:Invalid(-1)
end

-- ========
-- Alt
function Wffcuc:GetAlt(dpath)
	self.d_alt = iDataRef:New(dpath)
end

function Wffcuc:SetAlt(val)
	if val == nil then
		val = self.d_alt:Get()
		if self.d_alt:ChangedUpdate() then
			uluaSet(idr_wffcuc_hid_leds_altval, self:swap16(val))
		end
	else
		uluaSet(idr_wffcuc_hid_leds_altval, self:swap16(val))
	end
end

function Wffcuc:FreshAlt()
	self.d_alt:Invalid(-1)
end

-- ========
-- Vs
function Wffcuc:GetVs(dpath)
	self.d_vs = iDataRef:New(dpath)
end

function Wffcuc:SetVs(val)
	if val == nil then
		val = self.d_vs:Get()
		if self.d_vs:ChangedUpdate() then
			uluaSet(idr_wffcuc_hid_leds_vsval, self:swap16(val))
		end
	else
		uluaSet(idr_wffcuc_hid_leds_vsval, self:swap16(val))
	end
end

function Wffcuc:FreshVs()
	self.d_vs:Invalid(-1)
end

-- =========
-- axis raw data process
function Wffcuc:DecAxis(val)
	-- 1. Use bit.band to force the double into a 32-bit integer
	-- and then mask it to just the lowest 16 bits.
	-- This handles negative doubles and large doubles correctly.
	local u16  = bit.band(val, 0xFFFF)

	-- 2. Extract and move the bytes
	local high = bit.rshift(u16, 8)                -- Move bits 9-16 to 1-8
	local low  = bit.band(bit.lshift(u16, 8), 0xFFFF) -- Move bits 1-8 to 9-16
	if low > 0 then
		-- couter clock rotation
		return 1, high
	else
		return 0, high
	end
end

function Wffcuc:CfgCmdAxis(idx, cmddec, cmdinc)
	self.dr_axis_cmd_dec[idx] = uluaFind(cmddec)
	self.dr_axis_cmd_inc[idx] = uluaFind(cmdinc)
end

function Wffcuc:CfgRpnAxis(idx, cmddec, cmdinc)
	self.dr_axis_rpn_dec[idx] = cmddec
	self.dr_axis_rpn_inc[idx] = cmdinc
end

function Wffcuc:LoopAxis(idx)
	-- axis vs
	if self.dr_axis[idx]:GetChanged() then
		local sign, newval = self:DecAxis(self.dr_axis[idx].val)
		local oldsign, oldval = self:DecAxis(self.dr_axis[idx].val_last)
		self.dr_axis[idx]:Update()
		local delta = newval - oldval
		-- 核心逻辑：将差值映射回 -128 到 127 之间
		-- 这模拟了 C++ 中 int8_t 的溢出行为
		local step = (delta + 128) % 256 - 128
		--WingFlex shitty FW noise filter
		local realstep = step > 0 and math.floor((step + 1) / 2) or math.floor((step - 1) / 2)
		-- uluaLog(string.format("cube axis [%d]=%d  %d", idx, newval, realstep))
		if realstep > 0 then
			for i = 1, realstep do
				if self.dr_axis_cmd_inc[idx] ~= nil then
					uluaCmdOnce(self.dr_axis_cmd_inc[idx])
				end
				if self.dr_axis_rpn_inc[idx] ~= nil then
					uluaWriteCmd(self.dr_axis_rpn_inc[idx])
				end
			end
		else
			for i = 1, (realstep * -1) do
				if self.dr_axis_cmd_dec[idx] ~= nil then
					uluaCmdOnce(self.dr_axis_cmd_dec[idx])
				end
				if self.dr_axis_rpn_dec[idx] ~= nil then
					uluaWriteCmd(self.dr_axis_rpn_dec[idx])
				end
			end
		end
	end
end

return Wffcuc
