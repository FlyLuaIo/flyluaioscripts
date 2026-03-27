-- *****************************************************************
-- Don't modify this file, unless you know what you are doing
-- Most of the code are auto generated
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-03-26_23_34_59UTC
-- *****************************************************************

local Wwecam = oop.class(com.sim.Qmdev)
function Wwecam:init()
	self.QmdevId = 0xC305EEB
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
	if not uluaFind('cpuwolf/qmdev/WwEcam/leds/ledCmd') then
		return true
	end
	_G.idr_wwecam_hid_leds_ledcmd = uluaFind('cpuwolf/qmdev/WwEcam/leds/ledCmd')
	_G.idr_wwecam_hid_invalid = uluaFind('cpuwolf/qmdev/WwEcam/invalid')
	_G.idr_wwecam_hid_fastkeypersec = uluaFind('cpuwolf/qmdev/WwEcam/fastkeypersec')
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

function Wwecam:SendLedCmd(LedId, value)
	local combinedValue = (LedId * 256) + value
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
function Wwecam:GetEEng(dpath)
	self.d_ec_eng = iDataRef:New(dpath)
end

function Wwecam:SetEEng(valbase, val)
	valbase = valbase == nil and 0 or valbase
	if val == nil then
		if self.d_ec_eng:ChangedUpdate() then
			val = self.d_ec_eng:GetOld()
			self:SendLedCmd(self.LED_ENG, ilua_bool_ternary(val, valbase))
		end
	else
		self:SendLedCmd(self.LED_ENG, ilua_bool_ternary(val, valbase))
	end
end

-- ECAM BLEED
function Wwecam:GetEBleed(dpath)
	self.d_ec_bleed = iDataRef:New(dpath)
end

function Wwecam:SetEBleed(valbase, val)
	valbase = valbase == nil and 0 or valbase
	if val == nil then
		if self.d_ec_bleed:ChangedUpdate() then
			val = self.d_ec_bleed:GetOld()
			self:SendLedCmd(self.LED_BLEED, ilua_bool_ternary(val, valbase))
		end
	else
		self:SendLedCmd(self.LED_BLEED, ilua_bool_ternary(val, valbase))
	end
end

-- ECAM PRESS
function Wwecam:GetEPress(dpath)
	self.d_ec_press = iDataRef:New(dpath)
end

function Wwecam:SetEPress(valbase, val)
	valbase = valbase == nil and 0 or valbase
	if val == nil then
		if self.d_ec_press:ChangedUpdate() then
			val = self.d_ec_press:GetOld()
			self:SendLedCmd(self.LED_PRESS, ilua_bool_ternary(val, valbase))
		end
	else
		self:SendLedCmd(self.LED_PRESS, ilua_bool_ternary(val, valbase))
	end
end

-- ECAM ELEC
function Wwecam:GetEElec(dpath)
	self.d_ec_elec = iDataRef:New(dpath)
end

function Wwecam:SetEElec(valbase, val)
	valbase = valbase == nil and 0 or valbase
	if val == nil then
		if self.d_ec_elec:ChangedUpdate() then
			val = self.d_ec_elec:GetOld()
			self:SendLedCmd(self.LED_ELEC, ilua_bool_ternary(val, valbase))
		end
	else
		self:SendLedCmd(self.LED_ELEC, ilua_bool_ternary(val, valbase))
	end
end

-- ECAM ELEC AC DC
function Wwecam:GetEElecAcDc(dpath, d_dc_path)
	self.d_ec_elec = iDataRef:New(dpath)
	self.d_ec_elec_dc = iDataRef:New(d_dc_path)
end

function Wwecam:SetEElecAcDc(valbase, val)
	valbase = valbase == nil and 0 or valbase
	local val_dc
	if val == nil then
		if self.d_ec_elec:ChangedUpdate() or self.d_ec_elec_dc:ChangedUpdate() then
			val = self.d_ec_elec:GetOld()
			val_dc = self.d_ec_elec_dc:GetOld()
			val = (val + val_dc) / 2
			self:SendLedCmd(self.LED_ELEC, ilua_bool_ternary(val, valbase))
		end
	else
		val = (val + val_dc) / 2
		self:SendLedCmd(self.LED_ELEC, ilua_bool_ternary(val, valbase))
	end
end

-- ECAM HYD
function Wwecam:GetEHyd(dpath)
	self.d_ec_hyd = iDataRef:New(dpath)
end

function Wwecam:SetEHyd(valbase, val)
	valbase = valbase == nil and 0 or valbase
	if val == nil then
		if self.d_ec_hyd:ChangedUpdate() then
			val = self.d_ec_hyd:GetOld()
			self:SendLedCmd(self.LED_HYD, ilua_bool_ternary(val, valbase))
		end
	else
		self:SendLedCmd(self.LED_HYD, ilua_bool_ternary(val, valbase))
	end
end

-- ECAM FUEL
function Wwecam:GetEFuel(dpath)
	self.d_ec_fuel = iDataRef:New(dpath)
end

function Wwecam:SetEFuel(valbase, val)
	valbase = valbase == nil and 0 or valbase
	if val == nil then
		if self.d_ec_fuel:ChangedUpdate() then
			val = self.d_ec_fuel:GetOld()
			self:SendLedCmd(self.LED_FUEL, ilua_bool_ternary(val, valbase))
		end
	else
		self:SendLedCmd(self.LED_FUEL, ilua_bool_ternary(val, valbase))
	end
end

-- ECAM FCTL
function Wwecam:GetEFctl(dpath)
	self.d_ec_fctl = iDataRef:New(dpath)
end

function Wwecam:SetEFctl(valbase, val)
	valbase = valbase == nil and 0 or valbase
	if val == nil then
		if self.d_ec_fctl:ChangedUpdate() then
			val = self.d_ec_fctl:GetOld()
			self:SendLedCmd(self.LED_FCTL, ilua_bool_ternary(val, valbase))
		end
	else
		self:SendLedCmd(self.LED_FCTL, ilua_bool_ternary(val, valbase))
	end
end

-- ECAM APU
function Wwecam:GetEApu(dpath)
	self.d_ec_apu = iDataRef:New(dpath)
end

function Wwecam:SetEApu(valbase, val)
	valbase = valbase == nil and 0 or valbase
	if val == nil then
		if self.d_ec_apu:ChangedUpdate() then
			val = self.d_ec_apu:GetOld()
			self:SendLedCmd(self.LED_APU, ilua_bool_ternary(val, valbase))
		end
	else
		self:SendLedCmd(self.LED_APU, ilua_bool_ternary(val, valbase))
	end
end

-- ECAM COND
function Wwecam:GetECond(dpath)
	self.d_ec_cond = iDataRef:New(dpath)
end

function Wwecam:SetECond(valbase, val)
	valbase = valbase == nil and 0 or valbase
	if val == nil then
		if self.d_ec_cond:ChangedUpdate() then
			val = self.d_ec_cond:GetOld()
			self:SendLedCmd(self.LED_COND, ilua_bool_ternary(val, valbase))
		end
	else
		self:SendLedCmd(self.LED_COND, ilua_bool_ternary(val, valbase))
	end
end

-- ECAM DOOR
function Wwecam:GetEDoor(dpath)
	self.d_ec_door = iDataRef:New(dpath)
end

function Wwecam:SetEDoor(valbase, val)
	valbase = valbase == nil and 0 or valbase
	if val == nil then
		if self.d_ec_door:ChangedUpdate() then
			val = self.d_ec_door:GetOld()
			self:SendLedCmd(self.LED_DOOR, ilua_bool_ternary(val, valbase))
		end
	else
		self:SendLedCmd(self.LED_DOOR, ilua_bool_ternary(val, valbase))
	end
end

-- ECAM WHEEL
function Wwecam:GetEWheel(dpath)
	self.d_ec_wheel = iDataRef:New(dpath)
end

function Wwecam:SetEWheel(valbase, val)
	valbase = valbase == nil and 0 or valbase
	if val == nil then
		if self.d_ec_wheel:ChangedUpdate() then
			val = self.d_ec_wheel:GetOld()
			self:SendLedCmd(self.LED_WHEEL, ilua_bool_ternary(val, valbase))
		end
	else
		self:SendLedCmd(self.LED_WHEEL, ilua_bool_ternary(val, valbase))
	end
end

-- ECAM CLR Left
function Wwecam:GetEClrL(dpath)
	self.d_ec_clr_l = iDataRef:New(dpath)
end

function Wwecam:SetEClrL(valbase, val)
	valbase = valbase == nil and 0 or valbase
	if val == nil then
		if self.d_ec_clr_l:ChangedUpdate() then
			val = self.d_ec_clr_l:GetOld()
			self:SendLedCmd(self.LED_CLR_L, ilua_bool_ternary(val, valbase))
		end
	else
		self:SendLedCmd(self.LED_CLR_L, ilua_bool_ternary(val, valbase))
	end
end

-- ECAM CLR Right
function Wwecam:GetEClrR(dpath)
	self.d_ec_clr_r = iDataRef:New(dpath)
end

function Wwecam:SetEClrR(valbase, val)
	valbase = valbase == nil and 0 or valbase
	if val == nil then
		if self.d_ec_clr_r:ChangedUpdate() then
			val = self.d_ec_clr_r:GetOld()
			self:SendLedCmd(self.LED_CLR_R, ilua_bool_ternary(val, valbase))
		end
	else
		self:SendLedCmd(self.LED_CLR_R, ilua_bool_ternary(val, valbase))
	end
end

-- ECAM STS
function Wwecam:GetESts(dpath)
	self.d_ec_sts = iDataRef:New(dpath)
end

function Wwecam:SetESts(valbase, val)
	valbase = valbase == nil and 0 or valbase
	if val == nil then
		if self.d_ec_sts:ChangedUpdate() then
			val = self.d_ec_sts:GetOld()
			self:SendLedCmd(self.LED_STS, ilua_bool_ternary(val, valbase))
		end
	else
		self:SendLedCmd(self.LED_STS, ilua_bool_ternary(val, valbase))
	end
end

-- ECAM all
function Wwecam:SetEcam(valbase)
	valbase = valbase == nil and 0 or valbase
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
	valbase = valbase == nil and 0 or valbase
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
