-- *****************************************************************
-- Don't modify this file, unless you know what you are doing
-- Most of the code are auto generated
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-03-26_23_34_59UTC
-- *****************************************************************

local Wwecam = oop.class(com.sim.Qmdev)
function Wwecam:init()
	self.QmdevId = 0x3D7A214C
	self.FastTurnsPerSecond = 5
	if _G.ilua_hw_assigned_wwecam == nil then
		_G.ilua_hw_assigned_wwecam = 0
	end
	self.LED_BACKLIGHT = 0
	self.LED_ALL_BRIGHTNESS = 1
	self.LED_EMER_BRIGHTNESS = 3
	self.LED_ENG = 4
	self.LED_BLEED = 5
	self.LED_PRESS = 6
	self.LED_ELEC = 7
	self.LED_HYD = 8
	self.LED_FUEL = 9
	self.LED_APU = 10
	self.LED_COND = 11
	self.LED_DOOR = 12
	self.LED_WHEEL = 13
	self.LED_FCTL = 14
	self.LED_CLR_L = 15
	self.LED_STS = 16
	self.LED_CLR_R = 17
	self.ledIds = { self.LED_ENG, self.LED_BLEED, self.LED_PRESS,
		self.LED_ELEC, self.LED_HYD, self.LED_FUEL, self.LED_APU,
		self.LED_COND, self.LED_DOOR, self.LED_WHEEL, self.LED_FCTL,
		self.LED_CLR_L, self.LED_STS, self.LED_CLR_R }
end

function Wwecam:absent(FastTurnsPerSecond)
	if not uluaFind('cpuwolf/flyluaio/WwEcam/leds/ledCmd') then
		return true
	end
	_G.idr_wwecam_hid_leds_ledcmd = uluaFind('cpuwolf/flyluaio/WwEcam/leds/ledCmd')
	_G.idr_wwecam_hid_invalid = uluaFind('cpuwolf/flyluaio/WwEcam/invalid')
	_G.idr_wwecam_hid_fastkeypersec = uluaFind('cpuwolf/flyluaio/WwEcam/fastkeypersec')
	uluaSet(_G.idr_wwecam_hid_fastkeypersec, FastTurnsPerSecond)
	return false
end

function Wwecam:Init(FastTurnsPerSecond)
	local ftps = FastTurnsPerSecond == nil and self.FastTurnsPerSecond or FastTurnsPerSecond
	if self:absent(ftps) then
		return false
	end
	if _G.ilua_hw_assigned_wwecam == 1 then
		return false
	end
	_G.ilua_hw_assigned_wwecam = 1
	return true
end

function Wwecam.Open(...)
	return com.sim.Qmdev.Open(Wwecam, ...)
end

function Wwecam:SendLedCmd(LedId, value)
	local combinedValue = (math.floor(value) * 256) + LedId
	uluaSet(_G.idr_wwecam_hid_leds_ledcmd, combinedValue)
end

function Wwecam:PowerOff()
	self:SendLedCmd(self.LED_BACKLIGHT, 0)
	self:SendLedCmd(self.LED_EMER_BRIGHTNESS, 0)
	self:SendLedCmd(self.LED_ALL_BRIGHTNESS, 0)
	for i = 1, #self.ledIds do
		self:SendLedCmd(self.ledIds[i], 0)
	end
end

function Wwecam:SetTest()
	self:SetBrt(128)
	self:SendLedCmd(self.LED_ALL_BRIGHTNESS, 255)
	for i = 1, #self.ledIds do
		self:SendLedCmd(self.ledIds[i], 1)
	end
end

function Wwecam:SetBrt(val)
	self:SendLedCmd(self.LED_BACKLIGHT, val)
	self:SendLedCmd(self.LED_EMER_BRIGHTNESS, val)
end

-- ========
-- Backlight
function Wwecam:GetBkl(dpath, scale)
	self.d_bkl_scale = scale == nil and 30 or scale
	self.d_bkl = iDataRef:New(dpath)
end

function Wwecam:SetBkl(val)
	if val == nil then
		val = self.d_bkl:Get() * self.d_bkl_scale
		if self.d_bkl:ChangedUpdate() then
			self:SetBrt(val)
		end
	else
		self:SetBrt(val)
	end
end

function Wwecam:FreshBkl()
	self.d_bkl:Invalid(-1)
end

-- =========================ECAM
-- ========
-- ECAM ENG
function Wwecam:GetEEng(dpath, revert, base)
	self.d_ec_eng = iDataRef:New(dpath, nil, revert, base)
end

function Wwecam:SetEEng(valbase, val)
	local d = self.d_ec_eng
	if valbase ~= nil then d.bool_base = valbase end
	local on
	if val == nil then
		if not d:ChangedUpdate() then return end
		on = d:GetOldBit()
	else
		on = ilua_bool_ternary(val, d.bool_base, d.bool_revert)
	end
	self:SendLedCmd(self.LED_ENG, on)
end

-- ECAM BLEED
function Wwecam:GetEBleed(dpath, revert, base)
	self.d_ec_bleed = iDataRef:New(dpath, nil, revert, base)
end

function Wwecam:SetEBleed(valbase, val)
	local d = self.d_ec_bleed
	if valbase ~= nil then d.bool_base = valbase end
	local on
	if val == nil then
		if not d:ChangedUpdate() then return end
		on = d:GetOldBit()
	else
		on = ilua_bool_ternary(val, d.bool_base, d.bool_revert)
	end
	self:SendLedCmd(self.LED_BLEED, on)
end

-- ECAM PRESS
function Wwecam:GetEPress(dpath, revert, base)
	self.d_ec_press = iDataRef:New(dpath, nil, revert, base)
end

function Wwecam:SetEPress(valbase, val)
	local d = self.d_ec_press
	if valbase ~= nil then d.bool_base = valbase end
	local on
	if val == nil then
		if not d:ChangedUpdate() then return end
		on = d:GetOldBit()
	else
		on = ilua_bool_ternary(val, d.bool_base, d.bool_revert)
	end
	self:SendLedCmd(self.LED_PRESS, on)
end

-- ECAM ELEC
function Wwecam:GetEElec(dpath, revert, base)
	self.d_ec_elec = iDataRef:New(dpath, nil, revert, base)
end

function Wwecam:SetEElec(valbase, val)
	local d = self.d_ec_elec
	if valbase ~= nil then d.bool_base = valbase end
	local on
	if val == nil then
		if not d:ChangedUpdate() then return end
		on = d:GetOldBit()
	else
		on = ilua_bool_ternary(val, d.bool_base, d.bool_revert)
	end
	self:SendLedCmd(self.LED_ELEC, on)
end

-- ECAM ELEC AC DC
function Wwecam:GetEElecAcDc(dpath, dpath_dc, revert, base)
	self.d_ec_elec = iDataRef:New(dpath, nil, revert, base)
	self.d_ec_elec_dc = iDataRef:New(dpath_dc, nil, revert, base)
end

function Wwecam:SetEElecAcDc(valbase, val)
	local d = self.d_ec_elec
	local ddc = self.d_ec_elec_dc
	if valbase ~= nil then d.bool_base = valbase end
	local on
	if val == nil then
		local changed = d:ChangedUpdate()
		changed = ddc:ChangedUpdate() or changed
		if not changed then return end
		on = ilua_bool_ternary((d:GetOld() + ddc:GetOld()) / 2, d.bool_base, d.bool_revert)
	else
		on = ilua_bool_ternary(val, d.bool_base, d.bool_revert)
	end
	self:SendLedCmd(self.LED_ELEC, on)
end

-- ECAM HYD
function Wwecam:GetEHyd(dpath, revert, base)
	self.d_ec_hyd = iDataRef:New(dpath, nil, revert, base)
end

function Wwecam:SetEHyd(valbase, val)
	local d = self.d_ec_hyd
	if valbase ~= nil then d.bool_base = valbase end
	local on
	if val == nil then
		if not d:ChangedUpdate() then return end
		on = d:GetOldBit()
	else
		on = ilua_bool_ternary(val, d.bool_base, d.bool_revert)
	end
	self:SendLedCmd(self.LED_HYD, on)
end

-- ECAM FUEL
function Wwecam:GetEFuel(dpath, revert, base)
	self.d_ec_fuel = iDataRef:New(dpath, nil, revert, base)
end

function Wwecam:SetEFuel(valbase, val)
	local d = self.d_ec_fuel
	if valbase ~= nil then d.bool_base = valbase end
	local on
	if val == nil then
		if not d:ChangedUpdate() then return end
		on = d:GetOldBit()
	else
		on = ilua_bool_ternary(val, d.bool_base, d.bool_revert)
	end
	self:SendLedCmd(self.LED_FUEL, on)
end

-- ECAM FCTL
function Wwecam:GetEFctl(dpath, revert, base)
	self.d_ec_fctl = iDataRef:New(dpath, nil, revert, base)
end

function Wwecam:SetEFctl(valbase, val)
	local d = self.d_ec_fctl
	if valbase ~= nil then d.bool_base = valbase end
	local on
	if val == nil then
		if not d:ChangedUpdate() then return end
		on = d:GetOldBit()
	else
		on = ilua_bool_ternary(val, d.bool_base, d.bool_revert)
	end
	self:SendLedCmd(self.LED_FCTL, on)
end

-- ECAM APU
function Wwecam:GetEApu(dpath, revert, base)
	self.d_ec_apu = iDataRef:New(dpath, nil, revert, base)
end

function Wwecam:SetEApu(valbase, val)
	local d = self.d_ec_apu
	if valbase ~= nil then d.bool_base = valbase end
	local on
	if val == nil then
		if not d:ChangedUpdate() then return end
		on = d:GetOldBit()
	else
		on = ilua_bool_ternary(val, d.bool_base, d.bool_revert)
	end
	self:SendLedCmd(self.LED_APU, on)
end

-- ECAM COND
function Wwecam:GetECond(dpath, revert, base)
	self.d_ec_cond = iDataRef:New(dpath, nil, revert, base)
end

function Wwecam:SetECond(valbase, val)
	local d = self.d_ec_cond
	if valbase ~= nil then d.bool_base = valbase end
	local on
	if val == nil then
		if not d:ChangedUpdate() then return end
		on = d:GetOldBit()
	else
		on = ilua_bool_ternary(val, d.bool_base, d.bool_revert)
	end
	self:SendLedCmd(self.LED_COND, on)
end

-- ECAM DOOR
function Wwecam:GetEDoor(dpath, revert, base)
	self.d_ec_door = iDataRef:New(dpath, nil, revert, base)
end

function Wwecam:SetEDoor(valbase, val)
	local d = self.d_ec_door
	if valbase ~= nil then d.bool_base = valbase end
	local on
	if val == nil then
		if not d:ChangedUpdate() then return end
		on = d:GetOldBit()
	else
		on = ilua_bool_ternary(val, d.bool_base, d.bool_revert)
	end
	self:SendLedCmd(self.LED_DOOR, on)
end

-- ECAM WHEEL
function Wwecam:GetEWheel(dpath, revert, base)
	self.d_ec_wheel = iDataRef:New(dpath, nil, revert, base)
end

function Wwecam:SetEWheel(valbase, val)
	local d = self.d_ec_wheel
	if valbase ~= nil then d.bool_base = valbase end
	local on
	if val == nil then
		if not d:ChangedUpdate() then return end
		on = d:GetOldBit()
	else
		on = ilua_bool_ternary(val, d.bool_base, d.bool_revert)
	end
	self:SendLedCmd(self.LED_WHEEL, on)
end

-- ECAM CLR Left
function Wwecam:GetEClrL(dpath, revert, base)
	self.d_ec_clr_l = iDataRef:New(dpath, nil, revert, base)
end

function Wwecam:SetEClrL(valbase, val)
	local d = self.d_ec_clr_l
	if valbase ~= nil then d.bool_base = valbase end
	local on
	if val == nil then
		if not d:ChangedUpdate() then return end
		on = d:GetOldBit()
	else
		on = ilua_bool_ternary(val, d.bool_base, d.bool_revert)
	end
	self:SendLedCmd(self.LED_CLR_L, on)
end

-- ECAM CLR Right
function Wwecam:GetEClrR(dpath, revert, base)
	self.d_ec_clr_r = iDataRef:New(dpath, nil, revert, base)
end

function Wwecam:SetEClrR(valbase, val)
	local d = self.d_ec_clr_r
	if valbase ~= nil then d.bool_base = valbase end
	local on
	if val == nil then
		if not d:ChangedUpdate() then return end
		on = d:GetOldBit()
	else
		on = ilua_bool_ternary(val, d.bool_base, d.bool_revert)
	end
	self:SendLedCmd(self.LED_CLR_R, on)
end

-- ECAM STS
function Wwecam:GetESts(dpath, revert, base)
	self.d_ec_sts = iDataRef:New(dpath, nil, revert, base)
end

function Wwecam:SetESts(valbase, val)
	local d = self.d_ec_sts
	if valbase ~= nil then d.bool_base = valbase end
	local on
	if val == nil then
		if not d:ChangedUpdate() then return end
		on = d:GetOldBit()
	else
		on = ilua_bool_ternary(val, d.bool_base, d.bool_revert)
	end
	self:SendLedCmd(self.LED_STS, on)
end

-- ECAM all
function Wwecam:SetEcam(valbase)
	-- valbase 为 nil 时保留各 dataref 自己绑定的阈值（Get* 的 base 参数）
	self:SetEEng(valbase)
	self:SetEBleed(valbase)
	self:SetEPress(valbase)
	self:SetEElec(valbase)
	self:SetEHyd(valbase)
	self:SetEFuel(valbase)
	self:SetEFctl(valbase)
	self:SetEApu(valbase)
	self:SetECond(valbase)
	self:SetEDoor(valbase)
	self:SetEWheel(valbase)
	self:SetEClrL(valbase)
	self:SetEClrR(valbase)
	self:SetESts(valbase)
end

function Wwecam:SetEcamAcDc(valbase)
	-- valbase 为 nil 时保留各 dataref 自己绑定的阈值（Get* 的 base 参数）
	self:SetEEng(valbase)
	self:SetEBleed(valbase)
	self:SetEPress(valbase)
	self:SetEElecAcDc(valbase)
	self:SetEHyd(valbase)
	self:SetEFuel(valbase)
	self:SetEFctl(valbase)
	self:SetEApu(valbase)
	self:SetECond(valbase)
	self:SetEDoor(valbase)
	self:SetEWheel(valbase)
	self:SetEClrL(valbase)
	self:SetEClrR(valbase)
	self:SetESts(valbase)
end

return Wwecam
