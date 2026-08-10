-- *****************************************************************
-- Don't modify this file, unless you know what you are doing
-- Most of the code are auto generated
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-08-06
-- source: mobiflight/rf_a112.json
-- *****************************************************************

local RfA112 = oop.class(com.sim.mf.MobiFlight)
function RfA112:init()
	-- MF bridge assigns qmdev_id at connect (see log). Fallback: ProductName + ModuleSerial from JSON.
	self.QmdevId = 0x242B0D91
	self.FastTurnsPerSecond = 5
	if _G.ilua_hw_assigned_rfa112 == nil then
		_G.ilua_hw_assigned_rfa112 = 0
	end
end

function RfA112:absent(FastTurnsPerSecond)
	if not uluaFind('cpuwolf/flyluaio/RfA112/keysmap[0]') then
		return true
	end
	_G.idr_rfa112_hid_invalid = uluaFind('cpuwolf/flyluaio/RfA112/invalid')
	_G.idr_rfa112_hid_fastkeypersec = uluaFind('cpuwolf/flyluaio/RfA112/fastkeypersec')
	_G.idr_rfa112_mf_output_mip_lt = uluaFind('cpuwolf/mf/RfA112/output/0/state')
	uluaSet(_G.idr_rfa112_hid_fastkeypersec, FastTurnsPerSecond)

	return false
end

function RfA112:Init(FastTurnsPerSecond)
	local ftps = FastTurnsPerSecond == nil and self.FastTurnsPerSecond or FastTurnsPerSecond
	if self:absent(ftps) then
		return false
	end
	if _G.ilua_hw_assigned_rfa112 == 1 then
		return false
	end
	_G.ilua_hw_assigned_rfa112 = 1
	return true
end

function RfA112.Open(...)
	return com.sim.Qmdev.Open(RfA112, ...)
end

-- ========
-- output MIP-LT (output/0/state)

-- Channel state is 0/1 (bitLength=1 in mfcfg)

function RfA112:GetMipLt(dpath, scale)
	self.d_mip_lt_scale = scale == nil and 1 or scale
	self.d_mip_lt = iDataRef:New(dpath)
end

function RfA112:SetMipLt(val)
	if val == nil then
		val = self.d_mip_lt:Get() * self.d_mip_lt_scale
		if self.d_mip_lt:ChangedUpdate() then
			uluaSet(_G.idr_rfa112_mf_output_mip_lt, val)
		end
	else
		uluaSet(_G.idr_rfa112_mf_output_mip_lt, val)
	end
end

function RfA112:FreshMipLt()
	self.d_mip_lt:Invalid(-1)
end

return RfA112
