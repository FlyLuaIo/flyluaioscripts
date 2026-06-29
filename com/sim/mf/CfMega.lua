-- *****************************************************************
-- Don't modify this file, unless you know what you are doing
-- Most of the code are auto generated
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-06-29
-- source: mobiflight/CfMega.json
-- *****************************************************************

local CfMega = oop.class(com.sim.mf.MobiFlight)
function CfMega:init()
	-- MF bridge assigns qmdev_id at connect (see log). Fallback: ProductName + ModuleSerial from JSON.
    self.QmdevId = 0x27C0810B
	self.FastTurnsPerSecond = 5
	if _G.ilua_hw_assigned_cfmega == nil then
		_G.ilua_hw_assigned_cfmega = 0
	end
end

function CfMega:absent(FastTurnsPerSecond)
	if not uluaFind('cpuwolf/flyluaio/CfMega/keysmap[0]') then
		return true
	end
	_G.idr_cfmega_hid_invalid = uluaFind('cpuwolf/flyluaio/CfMega/invalid')
	_G.idr_cfmega_hid_fastkeypersec = uluaFind('cpuwolf/flyluaio/CfMega/fastkeypersec')
	_G.idr_cfmega_mf_stepper_eng_rpm = uluaFind('cpuwolf/mf/CfMega/stepper/0/position')
	uluaSet(_G.idr_cfmega_hid_fastkeypersec, FastTurnsPerSecond)

	return false
end

function CfMega:Init(FastTurnsPerSecond)
	local ftps = FastTurnsPerSecond == nil and self.FastTurnsPerSecond or FastTurnsPerSecond
	if self:absent(ftps) then
		return false
	end
	if _G.ilua_hw_assigned_cfmega == 1 then
		return false
	end
	_G.ilua_hw_assigned_cfmega = 1
	return true
end

-- ========
-- stepper ENG RPM

function CfMega:GetEngRpm(dpath, scale)
	self.d_eng_rpm_scale = scale == nil and 1 or scale
	self.d_eng_rpm = iDataRef:New(dpath)
end

function CfMega:SetEngRpm(val)
	if val == nil then
		val = self.d_eng_rpm:Get() * self.d_eng_rpm_scale
		if self.d_eng_rpm:ChangedUpdate() then
			uluaSet(_G.idr_cfmega_mf_stepper_eng_rpm, val)
		end
	else
		uluaSet(_G.idr_cfmega_mf_stepper_eng_rpm, val)
	end
end

function CfMega:FreshEngRpm()
	self.d_eng_rpm:Invalid(-1)
end

return CfMega
