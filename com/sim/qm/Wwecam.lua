
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

return Wwecam
