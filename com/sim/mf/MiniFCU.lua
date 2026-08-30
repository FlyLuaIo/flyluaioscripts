-- *****************************************************************
-- Don't modify this file, unless you know what you are doing
-- Most of the code are auto generated
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-08-30
-- source: mobiflight/MiniFCU.json
-- *****************************************************************

local MiniFCU = oop.class(com.sim.mf.MobiFlight)
function MiniFCU:init()
	-- MF bridge assigns qmdev_id at connect (see log). Fallback: ProductName + ModuleSerial from JSON.
	self.QmdevId = 0x3D141F89
	self.FastTurnsPerSecond = 5
	if _G.ilua_hw_assigned_minifcu == nil then
		_G.ilua_hw_assigned_minifcu = 0
	end
end

function MiniFCU:absent(FastTurnsPerSecond)
	if not uluaFind('cpuwolf/flyluaio/MiniFCU/keysmap[0]') then
		return true
	end
	_G.idr_minifcu_hid_invalid = uluaFind('cpuwolf/flyluaio/MiniFCU/invalid')
	_G.idr_minifcu_hid_fastkeypersec = uluaFind('cpuwolf/flyluaio/MiniFCU/fastkeypersec')
	_G.idr_minifcu_mf_output_ap1 = uluaFind('cpuwolf/mf/MiniFCU/output/0/state')
	_G.idr_minifcu_mf_output_ap2 = uluaFind('cpuwolf/mf/MiniFCU/output/1/state')
	_G.idr_minifcu_mf_output_appr = uluaFind('cpuwolf/mf/MiniFCU/output/2/state')
	_G.idr_minifcu_mf_output_athr = uluaFind('cpuwolf/mf/MiniFCU/output/3/state')
	_G.idr_minifcu_mf_output_exped = uluaFind('cpuwolf/mf/MiniFCU/output/4/state')
	_G.idr_minifcu_mf_output_loc = uluaFind('cpuwolf/mf/MiniFCU/output/5/state')
	uluaSet(_G.idr_minifcu_hid_fastkeypersec, FastTurnsPerSecond)
	self:InitLedModule()

	return false
end

function MiniFCU:Init(FastTurnsPerSecond)
	local ftps = FastTurnsPerSecond == nil and self.FastTurnsPerSecond or FastTurnsPerSecond
	if self:absent(ftps) then
		return false
	end
	if _G.ilua_hw_assigned_minifcu == 1 then
		return false
	end
	_G.ilua_hw_assigned_minifcu = 1
	return true
end

function MiniFCU.Open(...)
	return com.sim.Qmdev.Open(MiniFCU, ...)
end

-- ========
-- output AP1 (output/0/state)

-- Channel state 0–255 ↔ kSetPin (0=LOW, 255=HIGH, 1–254=PWM)

function MiniFCU:GetAp1(dpath, scale)
	self.d_ap1_scale = scale == nil and 255 or scale
	self.d_ap1 = iDataRef:New(dpath)
end

function MiniFCU:SetAp1(val)
	if val == nil then
		val = self.d_ap1:Get() * self.d_ap1_scale
		if self.d_ap1:ChangedUpdate() then
			uluaSet(_G.idr_minifcu_mf_output_ap1, val)
		end
	else
		uluaSet(_G.idr_minifcu_mf_output_ap1, val)
	end
end

function MiniFCU:FreshAp1()
	self.d_ap1:Invalid(-1)
end

-- ========
-- output AP2 (output/1/state)

-- Channel state 0–255 ↔ kSetPin (0=LOW, 255=HIGH, 1–254=PWM)

function MiniFCU:GetAp2(dpath, scale)
	self.d_ap2_scale = scale == nil and 255 or scale
	self.d_ap2 = iDataRef:New(dpath)
end

function MiniFCU:SetAp2(val)
	if val == nil then
		val = self.d_ap2:Get() * self.d_ap2_scale
		if self.d_ap2:ChangedUpdate() then
			uluaSet(_G.idr_minifcu_mf_output_ap2, val)
		end
	else
		uluaSet(_G.idr_minifcu_mf_output_ap2, val)
	end
end

function MiniFCU:FreshAp2()
	self.d_ap2:Invalid(-1)
end

-- ========
-- output APPR (output/2/state)

-- Channel state 0–255 ↔ kSetPin (0=LOW, 255=HIGH, 1–254=PWM)

function MiniFCU:GetAppr(dpath, scale)
	self.d_appr_scale = scale == nil and 255 or scale
	self.d_appr = iDataRef:New(dpath)
end

function MiniFCU:SetAppr(val)
	if val == nil then
		val = self.d_appr:Get() * self.d_appr_scale
		if self.d_appr:ChangedUpdate() then
			uluaSet(_G.idr_minifcu_mf_output_appr, val)
		end
	else
		uluaSet(_G.idr_minifcu_mf_output_appr, val)
	end
end

function MiniFCU:FreshAppr()
	self.d_appr:Invalid(-1)
end

-- ========
-- output ATHR (output/3/state)

-- Channel state 0–255 ↔ kSetPin (0=LOW, 255=HIGH, 1–254=PWM)

function MiniFCU:GetAthr(dpath, scale)
	self.d_athr_scale = scale == nil and 255 or scale
	self.d_athr = iDataRef:New(dpath)
end

function MiniFCU:SetAthr(val)
	if val == nil then
		val = self.d_athr:Get() * self.d_athr_scale
		if self.d_athr:ChangedUpdate() then
			uluaSet(_G.idr_minifcu_mf_output_athr, val)
		end
	else
		uluaSet(_G.idr_minifcu_mf_output_athr, val)
	end
end

function MiniFCU:FreshAthr()
	self.d_athr:Invalid(-1)
end

-- ========
-- output EXPED (output/4/state)

-- Channel state 0–255 ↔ kSetPin (0=LOW, 255=HIGH, 1–254=PWM)

function MiniFCU:GetExped(dpath, scale)
	self.d_exped_scale = scale == nil and 255 or scale
	self.d_exped = iDataRef:New(dpath)
end

function MiniFCU:SetExped(val)
	if val == nil then
		val = self.d_exped:Get() * self.d_exped_scale
		if self.d_exped:ChangedUpdate() then
			uluaSet(_G.idr_minifcu_mf_output_exped, val)
		end
	else
		uluaSet(_G.idr_minifcu_mf_output_exped, val)
	end
end

function MiniFCU:FreshExped()
	self.d_exped:Invalid(-1)
end

-- ========
-- output LOC (output/5/state)

-- Channel state 0–255 ↔ kSetPin (0=LOW, 255=HIGH, 1–254=PWM)

function MiniFCU:GetLoc(dpath, scale)
	self.d_loc_scale = scale == nil and 255 or scale
	self.d_loc = iDataRef:New(dpath)
end

function MiniFCU:SetLoc(val)
	if val == nil then
		val = self.d_loc:Get() * self.d_loc_scale
		if self.d_loc:ChangedUpdate() then
			uluaSet(_G.idr_minifcu_mf_output_loc, val)
		end
	else
		uluaSet(_G.idr_minifcu_mf_output_loc, val)
	end
end

function MiniFCU:FreshLoc()
	self.d_loc:Invalid(-1)
end

-- ========
-- LedModule: 2 LCD segments (miniFCU LCD = segment/0, miniEFIS LED and LCD = segment/1)
-- codegen does not handle Display Module; hand-written below (CfNano baseline).

function MiniFCU:InitLedModule()
	-- segment 0: miniFCU LCD
	_G.idr_minifcu_mf_s0_mask        = uluaFind('cpuwolf/mf/MiniFCU/segment/0/mask')
	_G.idr_minifcu_mf_s0_points      = uluaFind('cpuwolf/mf/MiniFCU/segment/0/points')
	_G.idr_minifcu_mf_s0_commit      = uluaFind('cpuwolf/mf/MiniFCU/segment/0/commit')
	_G.idr_minifcu_mf_s0_brightness  = uluaFind('cpuwolf/mf/MiniFCU/segment/0/brightness')
	_G.idr_minifcu_mf_s0_spd_mode    = uluaFind('cpuwolf/mf/MiniFCU/segment/0/text')
	_G.idr_minifcu_mf_s0_mach_val    = uluaFind('cpuwolf/mf/MiniFCU/segment/1/text')
	_G.idr_minifcu_mf_s0_spd_dashes  = uluaFind('cpuwolf/mf/MiniFCU/segment/2/text')
	_G.idr_minifcu_mf_s0_spd_val     = uluaFind('cpuwolf/mf/MiniFCU/segment/3/text')
	_G.idr_minifcu_mf_s0_spd_dot     = uluaFind('cpuwolf/mf/MiniFCU/segment/4/text')
	_G.idr_minifcu_mf_s0_hdg_dashes  = uluaFind('cpuwolf/mf/MiniFCU/segment/5/text')
	_G.idr_minifcu_mf_s0_hdg_val     = uluaFind('cpuwolf/mf/MiniFCU/segment/6/text')
	_G.idr_minifcu_mf_s0_hdg_dot     = uluaFind('cpuwolf/mf/MiniFCU/segment/7/text')
	_G.idr_minifcu_mf_s0_alt_val     = uluaFind('cpuwolf/mf/MiniFCU/segment/8/text')
	_G.idr_minifcu_mf_s0_alt_dot     = uluaFind('cpuwolf/mf/MiniFCU/segment/9/text')
	_G.idr_minifcu_mf_s0_vs_dashes   = uluaFind('cpuwolf/mf/MiniFCU/segment/10/text')
	_G.idr_minifcu_mf_s0_vs_val      = uluaFind('cpuwolf/mf/MiniFCU/segment/11/text')
	_G.idr_minifcu_mf_s0_fpa_val     = uluaFind('cpuwolf/mf/MiniFCU/segment/12/text')
	_G.idr_minifcu_mf_s0_hdgtrk_mode = uluaFind('cpuwolf/mf/MiniFCU/segment/13/text')
	-- segment 1: miniEFIS LED and LCD
	_G.idr_minifcu_mf_s1_mask        = uluaFind('cpuwolf/mf/MiniFCU/segment/1/mask')
	_G.idr_minifcu_mf_s1_points      = uluaFind('cpuwolf/mf/MiniFCU/segment/1/points')
	_G.idr_minifcu_mf_s1_commit      = uluaFind('cpuwolf/mf/MiniFCU/segment/1/commit')
	_G.idr_minifcu_mf_s1_brightness  = uluaFind('cpuwolf/mf/MiniFCU/segment/1/brightness')
	_G.idr_minifcu_mf_s1_baro_unit   = uluaFind('cpuwolf/mf/MiniFCU/segment/14/text')
	_G.idr_minifcu_mf_s1_baro_std    = uluaFind('cpuwolf/mf/MiniFCU/segment/15/text')
	_G.idr_minifcu_mf_s1_qnh         = uluaFind('cpuwolf/mf/MiniFCU/segment/16/text')
	_G.idr_minifcu_mf_s1_baro_hpa    = uluaFind('cpuwolf/mf/MiniFCU/segment/17/text')
	_G.idr_minifcu_mf_s1_baro_inhg   = uluaFind('cpuwolf/mf/MiniFCU/segment/18/text')
	_G.idr_minifcu_mf_s1_cstr        = uluaFind('cpuwolf/mf/MiniFCU/segment/19/text')
	_G.idr_minifcu_mf_s1_wpt         = uluaFind('cpuwolf/mf/MiniFCU/segment/20/text')
	_G.idr_minifcu_mf_s1_vord        = uluaFind('cpuwolf/mf/MiniFCU/segment/21/text')
	_G.idr_minifcu_mf_s1_ndb         = uluaFind('cpuwolf/mf/MiniFCU/segment/22/text')
	_G.idr_minifcu_mf_s1_arpt        = uluaFind('cpuwolf/mf/MiniFCU/segment/23/text')
	_G.idr_minifcu_mf_s1_fd          = uluaFind('cpuwolf/mf/MiniFCU/segment/24/text')
	_G.idr_minifcu_mf_s1_ls          = uluaFind('cpuwolf/mf/MiniFCU/segment/25/text')

	uluaSet(_G.idr_minifcu_mf_s0_mask, 63)
	uluaSet(_G.idr_minifcu_mf_s0_points, 8)
	uluaSet(_G.idr_minifcu_mf_s0_brightness, 1)
	uluaSet(_G.idr_minifcu_mf_s1_mask, 63)
	uluaSet(_G.idr_minifcu_mf_s1_points, 8)
	uluaSet(_G.idr_minifcu_mf_s1_brightness, 1)
	self.segment_commit_seq = 0
end

function MiniFCU:CommitSegment(seg)
	self.segment_commit_seq = (self.segment_commit_seq or 0) + 1
	if seg == 0 then
		uluaSet(_G.idr_minifcu_mf_s0_commit, self.segment_commit_seq)
	else
		uluaSet(_G.idr_minifcu_mf_s1_commit, self.segment_commit_seq)
	end
end

-- ========
-- segment 0 (miniFCU LCD) — 14 display areas

function MiniFCU:GetSpdMode(dpath) self.d_spd_mode = iDataRef:New(dpath) end

function MiniFCU:SetSpdMode(val)
	if val == nil then
		val = self.d_spd_mode:Get()
		if not self.d_spd_mode:ChangedUpdate() then return end
	end
	uluaSet(_G.idr_minifcu_mf_s0_spd_mode, val)
	self:CommitSegment(0)
end

function MiniFCU:FreshSpdMode() self.d_spd_mode:Invalid(-1) end

function MiniFCU:GetMachVal(dpath) self.d_mach_val = iDataRef:New(dpath) end

function MiniFCU:SetMachVal(val)
	if val == nil then
		val = self.d_mach_val:Get()
		if not self.d_mach_val:ChangedUpdate() then return end
	end
	uluaSet(_G.idr_minifcu_mf_s0_mach_val, val)
	self:CommitSegment(0)
end

function MiniFCU:FreshMachVal() self.d_mach_val:Invalid(-1) end

function MiniFCU:GetSpdDashes(dpath) self.d_spd_dashes = iDataRef:New(dpath) end

function MiniFCU:SetSpdDashes(val)
	if val == nil then
		val = self.d_spd_dashes:Get()
		if not self.d_spd_dashes:ChangedUpdate() then return end
	end
	uluaSet(_G.idr_minifcu_mf_s0_spd_dashes, val)
	self:CommitSegment(0)
end

function MiniFCU:FreshSpdDashes() self.d_spd_dashes:Invalid(-1) end

function MiniFCU:GetSpdVal(dpath) self.d_spd_val = iDataRef:New(dpath) end

function MiniFCU:SetSpdVal(val)
	if val == nil then
		val = self.d_spd_val:Get()
		if not self.d_spd_val:ChangedUpdate() then return end
	end
	uluaSet(_G.idr_minifcu_mf_s0_spd_val, val)
	self:CommitSegment(0)
end

function MiniFCU:FreshSpdVal() self.d_spd_val:Invalid(-1) end

function MiniFCU:GetSpdDot(dpath) self.d_spd_dot = iDataRef:New(dpath) end

function MiniFCU:SetSpdDot(val)
	if val == nil then
		val = self.d_spd_dot:Get()
		if not self.d_spd_dot:ChangedUpdate() then return end
	end
	uluaSet(_G.idr_minifcu_mf_s0_spd_dot, val)
	self:CommitSegment(0)
end

function MiniFCU:FreshSpdDot() self.d_spd_dot:Invalid(-1) end

function MiniFCU:GetHdgDashes(dpath) self.d_hdg_dashes = iDataRef:New(dpath) end

function MiniFCU:SetHdgDashes(val)
	if val == nil then
		val = self.d_hdg_dashes:Get()
		if not self.d_hdg_dashes:ChangedUpdate() then return end
	end
	uluaSet(_G.idr_minifcu_mf_s0_hdg_dashes, val)
	self:CommitSegment(0)
end

function MiniFCU:FreshHdgDashes() self.d_hdg_dashes:Invalid(-1) end

function MiniFCU:GetHdgVal(dpath) self.d_hdg_val = iDataRef:New(dpath) end

function MiniFCU:SetHdgVal(val)
	if val == nil then
		val = self.d_hdg_val:Get()
		if not self.d_hdg_val:ChangedUpdate() then return end
	end
	uluaSet(_G.idr_minifcu_mf_s0_hdg_val, val)
	self:CommitSegment(0)
end

function MiniFCU:FreshHdgVal() self.d_hdg_val:Invalid(-1) end

function MiniFCU:GetHdgDot(dpath) self.d_hdg_dot = iDataRef:New(dpath) end

function MiniFCU:SetHdgDot(val)
	if val == nil then
		val = self.d_hdg_dot:Get()
		if not self.d_hdg_dot:ChangedUpdate() then return end
	end
	uluaSet(_G.idr_minifcu_mf_s0_hdg_dot, val)
	self:CommitSegment(0)
end

function MiniFCU:FreshHdgDot() self.d_hdg_dot:Invalid(-1) end

function MiniFCU:GetAltVal(dpath) self.d_alt_val = iDataRef:New(dpath) end

function MiniFCU:SetAltVal(val)
	if val == nil then
		val = self.d_alt_val:Get()
		if not self.d_alt_val:ChangedUpdate() then return end
	end
	uluaSet(_G.idr_minifcu_mf_s0_alt_val, val)
	self:CommitSegment(0)
end

function MiniFCU:FreshAltVal() self.d_alt_val:Invalid(-1) end

function MiniFCU:GetAltDot(dpath) self.d_alt_dot = iDataRef:New(dpath) end

function MiniFCU:SetAltDot(val)
	if val == nil then
		val = self.d_alt_dot:Get()
		if not self.d_alt_dot:ChangedUpdate() then return end
	end
	uluaSet(_G.idr_minifcu_mf_s0_alt_dot, val)
	self:CommitSegment(0)
end

function MiniFCU:FreshAltDot() self.d_alt_dot:Invalid(-1) end

function MiniFCU:GetVsDashes(dpath) self.d_vs_dashes = iDataRef:New(dpath) end

function MiniFCU:SetVsDashes(val)
	if val == nil then
		val = self.d_vs_dashes:Get()
		if not self.d_vs_dashes:ChangedUpdate() then return end
	end
	uluaSet(_G.idr_minifcu_mf_s0_vs_dashes, val)
	self:CommitSegment(0)
end

function MiniFCU:FreshVsDashes() self.d_vs_dashes:Invalid(-1) end

function MiniFCU:GetVsVal(dpath) self.d_vs_val = iDataRef:New(dpath) end

function MiniFCU:SetVsVal(val)
	if val == nil then
		val = self.d_vs_val:Get()
		if not self.d_vs_val:ChangedUpdate() then return end
	end
	uluaSet(_G.idr_minifcu_mf_s0_vs_val, val)
	self:CommitSegment(0)
end

function MiniFCU:FreshVsVal() self.d_vs_val:Invalid(-1) end

function MiniFCU:GetFpaVal(dpath) self.d_fpa_val = iDataRef:New(dpath) end

function MiniFCU:SetFpaVal(val)
	if val == nil then
		val = self.d_fpa_val:Get()
		if not self.d_fpa_val:ChangedUpdate() then return end
	end
	uluaSet(_G.idr_minifcu_mf_s0_fpa_val, val)
	self:CommitSegment(0)
end

function MiniFCU:FreshFpaVal() self.d_fpa_val:Invalid(-1) end

function MiniFCU:GetHdgtrkMode(dpath) self.d_hdgtrk_mode = iDataRef:New(dpath) end

function MiniFCU:SetHdgtrkMode(val)
	if val == nil then
		val = self.d_hdgtrk_mode:Get()
		if not self.d_hdgtrk_mode:ChangedUpdate() then return end
	end
	uluaSet(_G.idr_minifcu_mf_s0_hdgtrk_mode, val)
	self:CommitSegment(0)
end

function MiniFCU:FreshHdgtrkMode() self.d_hdgtrk_mode:Invalid(-1) end

-- ========
-- segment 1 (miniEFIS LED and LCD) — 12 display areas

function MiniFCU:GetBaroUnit(dpath) self.d_baro_unit = iDataRef:New(dpath) end

function MiniFCU:SetBaroUnit(val)
	if val == nil then
		val = self.d_baro_unit:Get()
		if not self.d_baro_unit:ChangedUpdate() then return end
	end
	uluaSet(_G.idr_minifcu_mf_s1_baro_unit, val)
	self:CommitSegment(1)
end

function MiniFCU:FreshBaroUnit() self.d_baro_unit:Invalid(-1) end

function MiniFCU:GetBaroStd(dpath) self.d_baro_std = iDataRef:New(dpath) end

function MiniFCU:SetBaroStd(val)
	if val == nil then
		val = self.d_baro_std:Get()
		if not self.d_baro_std:ChangedUpdate() then return end
	end
	uluaSet(_G.idr_minifcu_mf_s1_baro_std, val)
	self:CommitSegment(1)
end

function MiniFCU:FreshBaroStd() self.d_baro_std:Invalid(-1) end

function MiniFCU:GetQnh(dpath) self.d_qnh = iDataRef:New(dpath) end

function MiniFCU:SetQnh(val)
	if val == nil then
		val = self.d_qnh:Get()
		if not self.d_qnh:ChangedUpdate() then return end
	end
	uluaSet(_G.idr_minifcu_mf_s1_qnh, val)
	self:CommitSegment(1)
end

function MiniFCU:FreshQnh() self.d_qnh:Invalid(-1) end

function MiniFCU:GetBaroHpa(dpath) self.d_baro_hpa = iDataRef:New(dpath) end

function MiniFCU:SetBaroHpa(val)
	if val == nil then
		val = self.d_baro_hpa:Get()
		if not self.d_baro_hpa:ChangedUpdate() then return end
	end
	uluaSet(_G.idr_minifcu_mf_s1_baro_hpa, val)
	self:CommitSegment(1)
end

function MiniFCU:FreshBaroHpa() self.d_baro_hpa:Invalid(-1) end

function MiniFCU:GetBaroInhg(dpath) self.d_baro_inhg = iDataRef:New(dpath) end

function MiniFCU:SetBaroInhg(val)
	if val == nil then
		val = self.d_baro_inhg:Get()
		if not self.d_baro_inhg:ChangedUpdate() then return end
	end
	uluaSet(_G.idr_minifcu_mf_s1_baro_inhg, val)
	self:CommitSegment(1)
end

function MiniFCU:FreshBaroInhg() self.d_baro_inhg:Invalid(-1) end

function MiniFCU:GetCstr(dpath) self.d_cstr = iDataRef:New(dpath) end

function MiniFCU:SetCstr(val)
	if val == nil then
		val = self.d_cstr:Get()
		if not self.d_cstr:ChangedUpdate() then return end
	end
	uluaSet(_G.idr_minifcu_mf_s1_cstr, val)
	self:CommitSegment(1)
end

function MiniFCU:FreshCstr() self.d_cstr:Invalid(-1) end

function MiniFCU:GetWpt(dpath) self.d_wpt = iDataRef:New(dpath) end

function MiniFCU:SetWpt(val)
	if val == nil then
		val = self.d_wpt:Get()
		if not self.d_wpt:ChangedUpdate() then return end
	end
	uluaSet(_G.idr_minifcu_mf_s1_wpt, val)
	self:CommitSegment(1)
end

function MiniFCU:FreshWpt() self.d_wpt:Invalid(-1) end

function MiniFCU:GetVord(dpath) self.d_vord = iDataRef:New(dpath) end

function MiniFCU:SetVord(val)
	if val == nil then
		val = self.d_vord:Get()
		if not self.d_vord:ChangedUpdate() then return end
	end
	uluaSet(_G.idr_minifcu_mf_s1_vord, val)
	self:CommitSegment(1)
end

function MiniFCU:FreshVord() self.d_vord:Invalid(-1) end

function MiniFCU:GetNdb(dpath) self.d_ndb = iDataRef:New(dpath) end

function MiniFCU:SetNdb(val)
	if val == nil then
		val = self.d_ndb:Get()
		if not self.d_ndb:ChangedUpdate() then return end
	end
	uluaSet(_G.idr_minifcu_mf_s1_ndb, val)
	self:CommitSegment(1)
end

function MiniFCU:FreshNdb() self.d_ndb:Invalid(-1) end

function MiniFCU:GetArpt(dpath) self.d_arpt = iDataRef:New(dpath) end

function MiniFCU:SetArpt(val)
	if val == nil then
		val = self.d_arpt:Get()
		if not self.d_arpt:ChangedUpdate() then return end
	end
	uluaSet(_G.idr_minifcu_mf_s1_arpt, val)
	self:CommitSegment(1)
end

function MiniFCU:FreshArpt() self.d_arpt:Invalid(-1) end

function MiniFCU:GetFd(dpath) self.d_fd = iDataRef:New(dpath) end

function MiniFCU:SetFd(val)
	if val == nil then
		val = self.d_fd:Get()
		if not self.d_fd:ChangedUpdate() then return end
	end
	uluaSet(_G.idr_minifcu_mf_s1_fd, val)
	self:CommitSegment(1)
end

function MiniFCU:FreshFd() self.d_fd:Invalid(-1) end

function MiniFCU:GetLs(dpath) self.d_ls = iDataRef:New(dpath) end

function MiniFCU:SetLs(val)
	if val == nil then
		val = self.d_ls:Get()
		if not self.d_ls:ChangedUpdate() then return end
	end
	uluaSet(_G.idr_minifcu_mf_s1_ls, val)
	self:CommitSegment(1)
end

function MiniFCU:FreshLs() self.d_ls:Invalid(-1) end

-- ========
-- convenience: batch Set* for all Output LEDs

function MiniFCU:SetLeds()
	self:SetAp1()
	self:SetAp2()
	self:SetAppr()
	self:SetAthr()
	self:SetExped()
	self:SetLoc()
end

function MiniFCU:SetLedsOff()
	self:SetAp1(0)
	self:SetAp2(0)
	self:SetAppr(0)
	self:SetAthr(0)
	self:SetExped(0)
	self:SetLoc(0)
end

return MiniFCU
