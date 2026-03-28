
-- *****************************************************************
-- Don't modify this file, unless you know what you are doing
-- Most of the code are auto generated
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-03-28_11_04_16UTC
-- *****************************************************************

local Wwagp = oop.class(com.sim.Qmdev)
function Wwagp:init()
	self.QmdevId = 0xC305EEB
	self.FastTurnsPerSecond = 5
	if _G.ilua_hw_assigned_wwagp == nil then
		_G.ilua_hw_assigned_wwagp = 0
	end
end

function Wwagp:absent(FastTurnsPerSecond)
	if not uluaFind('cpuwolf/qmdev/WwAgp/leds/ledCmd') then
		return true
	end
	_G.idr_wwagp_hid_leds_ledcmd = uluaFind('cpuwolf/qmdev/WwAgp/leds/ledCmd')
	_G.idr_wwagp_hid_lcd_seqnum = uluaFind('cpuwolf/qmdev/WwAgp/lcd/seqNum')
	_G.idr_wwagp_hid_lcd_chr = uluaFind('cpuwolf/qmdev/WwAgp/lcd/Chr')
	_G.idr_wwagp_hid_lcd_utc = uluaFind('cpuwolf/qmdev/WwAgp/lcd/Utc')
	_G.idr_wwagp_hid_lcd_et = uluaFind('cpuwolf/qmdev/WwAgp/lcd/Et')
	_G.idr_wwagp_hid_finish_seqnum = uluaFind('cpuwolf/qmdev/WwAgp/finish/seqNum')
	_G.idr_wwagp_hid_invalid = uluaFind('cpuwolf/qmdev/WwAgp/invalid')
	_G.idr_wwagp_hid_fastkeypersec = uluaFind('cpuwolf/qmdev/WwAgp/fastkeypersec')
	uluaSet(_G.idr_wwagp_hid_fastkeypersec, FastTurnsPerSecond)
	return false
end

function Wwagp:Init(FastTurnsPerSecond)
	local ftps = FastTurnsPerSecond == nil and self.FastTurnsPerSecond or FastTurnsPerSecond
	if self:absent(ftps) then
		return false
	end
	if _G.ilua_hw_assigned_wwagp == 1 then
		return false
	end
	_G.ilua_hw_assigned_wwagp = 1
	return true
end

return Wwagp
