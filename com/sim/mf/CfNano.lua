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
	self:InitLedModule()
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

function CfNano:InitLedModule()
	_G.idr_cfnano_mf_segment_mask = uluaFind('cpuwolf/mf/CfNano/segment/0/mask')
	_G.idr_cfnano_mf_segment_points = uluaFind('cpuwolf/mf/CfNano/segment/0/points')
	_G.idr_cfnano_mf_segment_commit = uluaFind('cpuwolf/mf/CfNano/segment/0/commit')
	_G.idr_cfnano_mf_segment_ga_eng_rpm = uluaFind('cpuwolf/mf/CfNano/segment/0/text')
	_G.idr_cfnano_mf_segment_brightness = uluaFind('cpuwolf/mf/CfNano/segment/0/brightness')

	uluaSet(_G.idr_cfnano_mf_segment_mask, 63)
	uluaSet(_G.idr_cfnano_mf_segment_points, 8)
	uluaSet(_G.idr_cfnano_mf_segment_brightness, 1)
	self.segment_commit_seq = 0
end

function CfNano:CommitSegment()
	self.segment_commit_seq = (self.segment_commit_seq or 0) + 1
	uluaSet(_G.idr_cfnano_mf_segment_commit, self.segment_commit_seq)
end

-- ========
-- segment GA ENG RPM

function CfNano:GetGaEngRpm(dpath)
	self.d_ga_eng_rpm = iDataRef:New(dpath)
end

function CfNano:SetGaEngRpm(val)
	if val == nil then
		val = self.d_ga_eng_rpm:Get()
		if self.d_ga_eng_rpm:ChangedUpdate() then
			uluaSet(_G.idr_cfnano_mf_segment_ga_eng_rpm, val)
			self:CommitSegment()
		end
	else
		uluaSet(_G.idr_cfnano_mf_segment_ga_eng_rpm, val)
		self:CommitSegment()
	end
end

function CfNano:FreshGaEngRpm()
	self.d_ga_eng_rpm:Invalid(-1)
end

return CfNano
