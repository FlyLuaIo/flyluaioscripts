
-- *****************************************************************
-- Don't modify this file, unless you know what you are doing
-- Most of the code are auto generated
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-08-08_03_55_08UTC
-- *****************************************************************

local Wwpdc3mr = oop.class(com.sim.Qmdev)
function Wwpdc3mr:init()
	self.QmdevId = 0x0AF4FEF1
	self.FastTurnsPerSecond = 5
	if _G.ilua_hw_assigned_wwpdc3mr == nil then
		_G.ilua_hw_assigned_wwpdc3mr = 0
		self.LEDS_BKL = 0
		self.ledIds = {
			self.LEDS_BKL
		}
	end
end

function Wwpdc3mr:absent(FastTurnsPerSecond)
	if not uluaFind('cpuwolf/flyluaio/WwPdc3mR/leds/ledCmd') then
		return true
	end
	_G.idr_wwpdc3mr_hid_leds_ledcmd = uluaFind('cpuwolf/flyluaio/WwPdc3mR/leds/ledCmd')
	_G.idr_wwpdc3mr_hid_invalid = uluaFind('cpuwolf/flyluaio/WwPdc3mR/invalid')
	_G.idr_wwpdc3mr_hid_fastkeypersec = uluaFind('cpuwolf/flyluaio/WwPdc3mR/fastkeypersec')
	uluaSet(_G.idr_wwpdc3mr_hid_fastkeypersec, FastTurnsPerSecond)
	return false
end

function Wwpdc3mr:Init(FastTurnsPerSecond)
	local ftps = FastTurnsPerSecond == nil and self.FastTurnsPerSecond or FastTurnsPerSecond
	if self:absent(ftps) then
		return false
	end
	if _G.ilua_hw_assigned_wwpdc3mr == 1 then
		return false
	end
	_G.ilua_hw_assigned_wwpdc3mr = 1
	return true
end

function Wwpdc3mr.Open(...)
	return com.sim.Qmdev.Open(Wwpdc3mr, ...)
end

function Wwpdc3mr:SendLedCmd(LedId, value)
	local combinedValue = (LedId * 256) + value
	uluaSet(_G.idr_wwpdc3mr_hid_leds_ledcmd, combinedValue)
end

function Wwpdc3mr:SendBit(idx, valbase, val)
	valbase = valbase == nil and 0 or valbase
	if val == nil then
		hdl = self.Bits[idx + 1]
		if hdl:ChangedUpdate() then
			val = hdl:GetOldBit()
			self:SendLedCmd(idx, val)
		end
	else
		self:SendLedCmd(idx, ilua_bool_ternary(val, valbase))
	end
end

-- ========
-- LEDS BKL
function Wwpdc3mr:GetBkl(dpath, revert, base)
	self:GetBit(self.LEDS_BKL, dpath, revert, base)
end

function Wwpdc3mr:SetBkl(valbase, val)
	self:SendBit(self.LEDS_BKL, valbase, val)
end

function Wwpdc3mr:Setleds(valbase, val)
	self:SetBkl(valbase, val)
end
return Wwpdc3mr
