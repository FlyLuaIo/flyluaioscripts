
-- *****************************************************************
-- Don't modify this file, unless you know what you are doing
-- Most of the code are auto generated
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-03-26_22_43_18UTC
-- *****************************************************************

local Wwecam = oop.class(com.sim.Qmdev)
function Wwecam:init()
	self.QmdevId = 0xC305EEB
	self.FastTurnsPerSecond = 5
	if _G.ilua_hw_assigned_wwecam == nil then
		_G.ilua_hw_assigned_wwecam = 0
	end
end

function Wwecam:absent(FastTurnsPerSecond)
	if not uluaFind('cpuwolf/qmdev/WwEcam/leds/ledId') then
		return true
	end
	_G.idr_wwecam_hid_leds_ledid = uluaFind('cpuwolf/qmdev/WwEcam/leds/ledId')
	_G.idr_wwecam_hid_leds_brightness = uluaFind('cpuwolf/qmdev/WwEcam/leds/brightness')
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
