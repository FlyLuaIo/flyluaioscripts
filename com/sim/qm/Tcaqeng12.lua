
-- *****************************************************************
-- Don't modify this file, unless you know what you are doing
-- Most of the code are auto generated
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-08-06_21_26_18UTC
-- *****************************************************************

local Tcaqeng12 = oop.class(com.sim.Qmdev)
function Tcaqeng12:init()
	self.QmdevId = 0x2C94C7A1
	self.FastTurnsPerSecond = 5
	if _G.ilua_hw_assigned_tcaqeng12 == nil then
		_G.ilua_hw_assigned_tcaqeng12 = 0
	end
end

function Tcaqeng12:absent(FastTurnsPerSecond)
	if not uluaFind('cpuwolf/flyluaio/TcaQEng12/invalid') then
		return true
	end
	_G.idr_tcaqeng12_hid_invalid = uluaFind('cpuwolf/flyluaio/TcaQEng12/invalid')
	_G.idr_tcaqeng12_hid_fastkeypersec = uluaFind('cpuwolf/flyluaio/TcaQEng12/fastkeypersec')
	uluaSet(_G.idr_tcaqeng12_hid_fastkeypersec, FastTurnsPerSecond)
	return false
end

function Tcaqeng12:Init(FastTurnsPerSecond)
	local ftps = FastTurnsPerSecond == nil and self.FastTurnsPerSecond or FastTurnsPerSecond
	if self:absent(ftps) then
		return false
	end
	if _G.ilua_hw_assigned_tcaqeng12 == 1 then
		return false
	end
	_G.ilua_hw_assigned_tcaqeng12 = 1
	return true
end

function Tcaqeng12.Open(...)
	return com.sim.Qmdev.Open(Tcaqeng12, ...)
end

return Tcaqeng12
