
-- *****************************************************************
-- Don't modify this file, unless you know what you are doing
-- Most of the code are auto generated
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-03-25_22_27_50UTC
-- *****************************************************************

local Vkbgunut = oop.class(com.sim.Qmdev)
function Vkbgunut:init()
	self.QmdevId = 0x2C94C7A2
	self.FastTurnsPerSecond = 5
	if _G.ilua_hw_assigned_vkbgunut == nil then
		_G.ilua_hw_assigned_vkbgunut = 0
	end
end

function Vkbgunut:absent(FastTurnsPerSecond)
	if not uluaFind('cpuwolf/qmdev/VkbGunUT/invalid') then
		return true
	end
	_G.idr_vkbgunut_hid_invalid = uluaFind('cpuwolf/qmdev/VkbGunUT/invalid')
	_G.idr_vkbgunut_hid_fastkeypersec = uluaFind('cpuwolf/qmdev/VkbGunUT/fastkeypersec')
	uluaSet(_G.idr_vkbgunut_hid_fastkeypersec, FastTurnsPerSecond)
	return false
end

function Vkbgunut:Init(FastTurnsPerSecond)
	local ftps = FastTurnsPerSecond == nil and self.FastTurnsPerSecond or FastTurnsPerSecond
	if self:absent(ftps) then
		return false
	end
	if _G.ilua_hw_assigned_vkbgunut == 1 then
		return false
	end
	_G.ilua_hw_assigned_vkbgunut = 1
	return true
end

return Vkbgunut
