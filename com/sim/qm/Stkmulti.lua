local Stkmulti = oop.class(com.sim.Qmdev)
function Stkmulti:init()
	self.QmdevId = 0x2AC8334B
	self.FastTurnsPerSecond = 5
	if _G.ilua_hw_assigned_stkmulti == nil then
		_G.ilua_hw_assigned_stkmulti = 0
	end
end

function Stkmulti:absent(FastTurnsPerSecond)
	if not uluaFind('cpuwolf/qmdev/StkMulti/Up/up1') then
		return true
	end
	_G.idr_stkmulti_hid_up_up1 = uluaFind('cpuwolf/qmdev/StkMulti/Up/up1')
	_G.idr_stkmulti_hid_up_up2 = uluaFind('cpuwolf/qmdev/StkMulti/Up/up2')
	_G.idr_stkmulti_hid_up_up3 = uluaFind('cpuwolf/qmdev/StkMulti/Up/up3')
	_G.idr_stkmulti_hid_up_up4 = uluaFind('cpuwolf/qmdev/StkMulti/Up/up4')
	_G.idr_stkmulti_hid_up_up5 = uluaFind('cpuwolf/qmdev/StkMulti/Up/up5')
	_G.idr_stkmulti_hid_up_down1 = uluaFind('cpuwolf/qmdev/StkMulti/Up/down1')
	_G.idr_stkmulti_hid_up_down2 = uluaFind('cpuwolf/qmdev/StkMulti/Up/down2')
	_G.idr_stkmulti_hid_up_down3 = uluaFind('cpuwolf/qmdev/StkMulti/Up/down3')
	_G.idr_stkmulti_hid_up_down4 = uluaFind('cpuwolf/qmdev/StkMulti/Up/down4')
	_G.idr_stkmulti_hid_up_down5 = uluaFind('cpuwolf/qmdev/StkMulti/Up/down5')
	_G.idr_stkmulti_hid_up_leds = uluaFind('cpuwolf/qmdev/StkMulti/Up/leds')
	_G.idr_stkmulti_hid_up_ap_ap = uluaFind('cpuwolf/qmdev/StkMulti/Up/AP_ap')
	_G.idr_stkmulti_hid_up_ap_hdg = uluaFind('cpuwolf/qmdev/StkMulti/Up/AP_hdg')
	_G.idr_stkmulti_hid_up_ap_nav = uluaFind('cpuwolf/qmdev/StkMulti/Up/AP_nav')
	_G.idr_stkmulti_hid_up_ap_ias = uluaFind('cpuwolf/qmdev/StkMulti/Up/AP_ias')
	_G.idr_stkmulti_hid_up_ap_alt = uluaFind('cpuwolf/qmdev/StkMulti/Up/AP_alt')
	_G.idr_stkmulti_hid_up_ap_vs = uluaFind('cpuwolf/qmdev/StkMulti/Up/AP_vs')
	_G.idr_stkmulti_hid_up_ap_apr = uluaFind('cpuwolf/qmdev/StkMulti/Up/AP_apr')
	_G.idr_stkmulti_hid_up_ap_rev = uluaFind('cpuwolf/qmdev/StkMulti/Up/AP_rev')
	_G.idr_stkmulti_hid_invalid = uluaFind('cpuwolf/qmdev/StkMulti/invalid')
	_G.idr_stkmulti_hid_fastkeypersec = uluaFind('cpuwolf/qmdev/StkMulti/fastkeypersec')
	return false
end

function Stkmulti:Init()
	if self:absent(self.FastTurnsPerSecond) then
		return false
	end
	if _G.ilua_hw_assigned_stkmulti == 1 then
		return false
	end
	_G.ilua_hw_assigned_stkmulti = 1
	return true
end

-- ========
-- Up AP_ap

function Stkmulti:GetAp(dpath)
	self:GetBit(1, dpath)
end

function Stkmulti:SetAp(valbase, val)
	self:SetBit(1, _G.idr_stkmulti_hid_up_ap_ap, valbase, val)
end

-- ========
-- Up AP_hdg

function Stkmulti:GetHdg(dpath)
	self:GetBit(2, dpath)
end

function Stkmulti:SetHdg(valbase, val)
	self:SetBit(2, _G.idr_stkmulti_hid_up_ap_hdg, valbase, val)
end

-- ========
-- Up AP_nav

function Stkmulti:GetNav(dpath)
	self:GetBit(3, dpath)
end

function Stkmulti:SetNav(valbase, val)
	self:SetBit(3, _G.idr_stkmulti_hid_up_ap_nav, valbase, val)
end

-- ========
-- Up AP_ias

function Stkmulti:GetIas(dpath)
	self:GetBit(4, dpath)
end

function Stkmulti:SetIas(valbase, val)
	self:SetBit(4, _G.idr_stkmulti_hid_up_ap_ias, valbase, val)
end

-- ========
-- Up AP_alt

function Stkmulti:GetAlt(dpath)
	self:GetBit(5, dpath)
end

function Stkmulti:SetAlt(valbase, val)
	self:SetBit(5, _G.idr_stkmulti_hid_up_ap_alt, valbase, val)
end

-- ========
-- Up AP_vs

function Stkmulti:GetVs(dpath)
	self:GetBit(6, dpath)
end

function Stkmulti:SetVs(valbase, val)
	self:SetBit(6, _G.idr_stkmulti_hid_up_ap_vs, valbase, val)
end

-- ========
-- Up AP_apr

function Stkmulti:GetApr(dpath)
	self:GetBit(7, dpath)
end

function Stkmulti:SetApr(valbase, val)
	self:SetBit(7, _G.idr_stkmulti_hid_up_ap_apr, valbase, val)
end

-- ========
-- Up AP_rev

function Stkmulti:GetRev(dpath)
	self:GetBit(8, dpath)
end

function Stkmulti:SetRev(valbase, val)
	self:SetBit(8, _G.idr_stkmulti_hid_up_ap_rev, valbase, val)
end

function Stkmulti:SetUp(valbase, val)
	self:SetAp(valbase, val)
	self:SetHdg(valbase, val)
	self:SetNav(valbase, val)
	self:SetIas(valbase, val)
	self:SetAlt(valbase, val)
	self:SetVs(valbase, val)
	self:SetApr(valbase, val)
	self:SetRev(valbase, val)
end

--[[
stkmulti:GetAp('')
stkmulti:GetHdg('')
stkmulti:GetNav('')
stkmulti:GetIas('')
stkmulti:GetAlt('')
stkmulti:GetVs('')
stkmulti:GetApr('')
stkmulti:GetRev('')
]]--

return Stkmulti