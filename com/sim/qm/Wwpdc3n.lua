
-- *****************************************************************
-- Don't modify this file, unless you know what you are doing
-- Most of the code are auto generated
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-08-08_03_55_08UTC
-- *****************************************************************

local Wwpdc3n = oop.class(com.sim.Qmdev)
function Wwpdc3n:init()
	self.QmdevId = 0x0FF5DEBA
	self.FastTurnsPerSecond = 5
	if _G.ilua_hw_assigned_wwpdc3n == nil then
		_G.ilua_hw_assigned_wwpdc3n = 0
		self.LEDS_BKL = 0
		self.ledIds = {
			self.LEDS_BKL
		}
	end
end

function Wwpdc3n:absent(FastTurnsPerSecond)
	if not uluaFind('cpuwolf/flyluaio/WwPdc3n/leds/ledCmd') then
		return true
	end
	_G.idr_wwpdc3n_hid_leds_ledcmd = uluaFind('cpuwolf/flyluaio/WwPdc3n/leds/ledCmd')
	_G.idr_wwpdc3n_hid_invalid = uluaFind('cpuwolf/flyluaio/WwPdc3n/invalid')
	_G.idr_wwpdc3n_hid_fastkeypersec = uluaFind('cpuwolf/flyluaio/WwPdc3n/fastkeypersec')
	uluaSet(_G.idr_wwpdc3n_hid_fastkeypersec, FastTurnsPerSecond)
	return false
end

function Wwpdc3n:Init(FastTurnsPerSecond)
	local ftps = FastTurnsPerSecond == nil and self.FastTurnsPerSecond or FastTurnsPerSecond
	if self:absent(ftps) then
		return false
	end
	if _G.ilua_hw_assigned_wwpdc3n == 1 then
		return false
	end
	_G.ilua_hw_assigned_wwpdc3n = 1
	return true
end

function Wwpdc3n.Open(...)
	return com.sim.Qmdev.Open(Wwpdc3n, ...)
end

-- ========
-- LEDS BKL
function Wwpdc3n:GetBkl(dpath, revert, base)
	self:GetBit(self.LEDS_BKL, dpath, revert, base)
end

function Wwpdc3n:SetBkl(valbase, val)
	self:SendBit(self.LEDS_BKL, valbase, val)
end

function Wwpdc3n:Setleds(valbase, val)
	self:SetBkl(valbase, val)
end
return Wwpdc3n
