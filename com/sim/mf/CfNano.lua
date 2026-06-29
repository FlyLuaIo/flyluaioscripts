-- *****************************************************************
-- Don't modify this file, unless you know what you are doing
-- Most of the code are auto generated
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-06-29
-- source: mobiflight/CfNano.json
-- *****************************************************************

local CfNano = oop.class(com.sim.mf.MobiFlight)
function CfNano:init()
	-- MF bridge assigns qmdev_id at connect (see log). Fallback: ProductName + ModuleSerial from JSON.
	self.QmdevId = 0x242B0D90
	self.FastTurnsPerSecond = 5
	if _G.ilua_hw_assigned_cfnano == nil then
		_G.ilua_hw_assigned_cfnano = 0
	end
end

function CfNano:absent(FastTurnsPerSecond)
	if not uluaFind('cpuwolf/flyluaio/CfNano/keysmap[0]') then
		return true
	end
	_G.idr_cfnano_hid_invalid = uluaFind('cpuwolf/flyluaio/CfNano/invalid')
	_G.idr_cfnano_hid_fastkeypersec = uluaFind('cpuwolf/flyluaio/CfNano/fastkeypersec')
	uluaSet(_G.idr_cfnano_hid_fastkeypersec, FastTurnsPerSecond)

	return false
end

function CfNano:Init(FastTurnsPerSecond)
	local ftps = FastTurnsPerSecond == nil and self.FastTurnsPerSecond or FastTurnsPerSecond
	if self:absent(ftps) then
		return false
	end
	if _G.ilua_hw_assigned_cfnano == 1 then
		return false
	end
	_G.ilua_hw_assigned_cfnano = 1
	return true
end

return CfNano
