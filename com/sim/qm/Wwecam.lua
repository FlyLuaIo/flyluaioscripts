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

-- =========================ECAM
-- ========
-- ECAM ENG
function Wwecam:GetEEng(dpath)
	self.d_ec_eng = iDataRef:New(dpath)
end

function Wwecam:SetEEng(valbase, val)
	valbase = valbase == nil and 0 or valbase
	if val == nil then
		val = self.d_ec_eng:Get()
		if self.d_ec_eng:ChangedUpdate() then
			uluaSet(idr_qmpe_hid_ec_eng, ilua_bool_ternary(val, valbase))
		end
	else
		uluaSet(idr_qmpe_hid_ec_eng, ilua_bool_ternary(val, valbase))
	end
end

-- ECAM BLEED
function Wwecam:GetEBleed(dpath)
	self.d_ec_bleed = iDataRef:New(dpath)
end

function Wwecam:SetEBleed(valbase, val)
	valbase = valbase == nil and 0 or valbase
	if val == nil then
		val = self.d_ec_bleed:Get()
		if self.d_ec_bleed:ChangedUpdate() then
			uluaSet(idr_qmpe_hid_ec_bleed, ilua_bool_ternary(val, valbase))
		end
	else
		uluaSet(idr_qmpe_hid_ec_bleed, ilua_bool_ternary(val, valbase))
	end
end

-- ECAM PRESS
function Wwecam:GetEPress(dpath)
	self.d_ec_press = iDataRef:New(dpath)
end

function Wwecam:SetEPress(valbase, val)
	valbase = valbase == nil and 0 or valbase
	if val == nil then
		val = self.d_ec_press:Get()
		if self.d_ec_press:ChangedUpdate() then
			uluaSet(idr_qmpe_hid_ec_press, ilua_bool_ternary(val, valbase))
		end
	else
		uluaSet(idr_qmpe_hid_ec_press, ilua_bool_ternary(val, valbase))
	end
end

-- ECAM ELEC
function Wwecam:GetEElec(dpath)
	self.d_ec_elec = iDataRef:New(dpath)
end

function Wwecam:SetEElec(valbase, val)
	valbase = valbase == nil and 0 or valbase
	if val == nil then
		val = self.d_ec_elec:Get()
		if self.d_ec_elec:ChangedUpdate() then
			uluaSet(idr_qmpe_hid_ec_elec, ilua_bool_ternary(val, valbase))
		end
	else
		uluaSet(idr_qmpe_hid_ec_elec, ilua_bool_ternary(val, valbase))
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
		val = self.d_ec_elec:Get()
		val_dc = self.d_ec_elec_dc:Get()

		if self.d_ec_elec:ChangedUpdate() or self.d_ec_elec_dc:ChangedUpdate() then
			val = (val + val_dc) / 2
			uluaSet(idr_qmpe_hid_ec_elec, ilua_bool_ternary(val, valbase))
		end
	else
		val = (val + val_dc) / 2
		uluaSet(idr_qmpe_hid_ec_elec, ilua_bool_ternary(val, valbase))
	end
end

-- ECAM HYD
function Wwecam:GetEHyd(dpath)
	self.d_ec_hyd = iDataRef:New(dpath)
end

function Wwecam:SetEHyd(valbase, val)
	valbase = valbase == nil and 0 or valbase
	if val == nil then
		val = self.d_ec_hyd:Get()
		if self.d_ec_hyd:ChangedUpdate() then
			uluaSet(idr_qmpe_hid_ec_hyd, ilua_bool_ternary(val, valbase))
		end
	else
		uluaSet(idr_qmpe_hid_ec_hyd, ilua_bool_ternary(val, valbase))
	end
end

-- ECAM FUEL
function Wwecam:GetEFuel(dpath)
	self.d_ec_fuel = iDataRef:New(dpath)
end

function Wwecam:SetEFuel(valbase, val)
	valbase = valbase == nil and 0 or valbase
	if val == nil then
		val = self.d_ec_fuel:Get()
		if self.d_ec_fuel:ChangedUpdate() then
			uluaSet(idr_qmpe_hid_ec_fuel, ilua_bool_ternary(val, valbase))
		end
	else
		uluaSet(idr_qmpe_hid_ec_fuel, ilua_bool_ternary(val, valbase))
	end
end

-- ECAM FCTL
function Wwecam:GetEFctl(dpath)
	self.d_ec_fctl = iDataRef:New(dpath)
end

function Wwecam:SetEFctl(valbase, val)
	valbase = valbase == nil and 0 or valbase
	if val == nil then
		val = self.d_ec_fctl:Get()
		if self.d_ec_fctl:ChangedUpdate() then
			uluaSet(idr_qmpe_hid_ec_fctl, ilua_bool_ternary(val, valbase))
		end
	else
		uluaSet(idr_qmpe_hid_ec_fctl, ilua_bool_ternary(val, valbase))
	end
end

-- ECAM APU
function Wwecam:GetEApu(dpath)
	self.d_ec_apu = iDataRef:New(dpath)
end

function Wwecam:SetEApu(valbase, val)
	valbase = valbase == nil and 0 or valbase
	if val == nil then
		val = self.d_ec_apu:Get()
		if self.d_ec_apu:ChangedUpdate() then
			uluaSet(idr_qmpe_hid_ec_apu, ilua_bool_ternary(val, valbase))
		end
	else
		uluaSet(idr_qmpe_hid_ec_apu, ilua_bool_ternary(val, valbase))
	end
end

-- ECAM COND
function Wwecam:GetECond(dpath)
	self.d_ec_cond = iDataRef:New(dpath)
end

function Wwecam:SetECond(valbase, val)
	valbase = valbase == nil and 0 or valbase
	if val == nil then
		val = self.d_ec_cond:Get()
		if self.d_ec_cond:ChangedUpdate() then
			uluaSet(idr_qmpe_hid_ec_cond, ilua_bool_ternary(val, valbase))
		end
	else
		uluaSet(idr_qmpe_hid_ec_cond, ilua_bool_ternary(val, valbase))
	end
end

-- ECAM DOOR
function Wwecam:GetEDoor(dpath)
	self.d_ec_door = iDataRef:New(dpath)
end

function Wwecam:SetEDoor(valbase, val)
	valbase = valbase == nil and 0 or valbase
	if val == nil then
		val = self.d_ec_door:Get()
		if self.d_ec_door:ChangedUpdate() then
			uluaSet(idr_qmpe_hid_ec_door, ilua_bool_ternary(val, valbase))
		end
	else
		uluaSet(idr_qmpe_hid_ec_door, ilua_bool_ternary(val, valbase))
	end
end

-- ECAM WHEEL
function Wwecam:GetEWheel(dpath)
	self.d_ec_wheel = iDataRef:New(dpath)
end

function Wwecam:SetEWheel(valbase, val)
	valbase = valbase == nil and 0 or valbase
	if val == nil then
		val = self.d_ec_wheel:Get()
		if self.d_ec_wheel:ChangedUpdate() then
			uluaSet(idr_qmpe_hid_ec_wheel, ilua_bool_ternary(val, valbase))
		end
	else
		uluaSet(idr_qmpe_hid_ec_wheel, ilua_bool_ternary(val, valbase))
	end
end

-- ECAM CLR
function Wwecam:GetEClr(dpath)
	self.d_ec_clr = iDataRef:New(dpath)
end

function Wwecam:SetEClr(valbase, val)
	valbase = valbase == nil and 0 or valbase
	if val == nil then
		val = self.d_ec_clr:Get()
		if self.d_ec_clr:ChangedUpdate() then
			uluaSet(idr_qmpe_hid_ec_clr, ilua_bool_ternary(val, valbase))
		end
	else
		uluaSet(idr_qmpe_hid_ec_clr, ilua_bool_ternary(val, valbase))
	end
end

-- ECAM STS
function Wwecam:GetESts(dpath)
	self.d_ec_sts = iDataRef:New(dpath)
end

function Wwecam:SetESts(valbase, val)
	valbase = valbase == nil and 0 or valbase
	if val == nil then
		val = self.d_ec_sts:Get()
		if self.d_ec_sts:ChangedUpdate() then
			uluaSet(idr_qmpe_hid_ec_sts, ilua_bool_ternary(val, valbase))
		end
	else
		uluaSet(idr_qmpe_hid_ec_sts, ilua_bool_ternary(val, valbase))
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
	self:SetEClr(valbase)
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
	self:SetEClr(valbase)
	self:SetESts(valbase)
end

-- set ECAM off
function Wwecam:OffEcam()
	uluaSet(idr_qmpe_hid_ec_int, 0)
end

return Wwecam
