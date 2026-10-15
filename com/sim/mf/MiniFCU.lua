-- *****************************************************************
-- Don't modify this file, unless you know what you are doing
-- Most of the code are auto generated
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-10-15
-- source: mobiflight/MiniFCU.json
-- *****************************************************************

local MiniFCU = oop.class(com.sim.mf.MobiFlight)
function MiniFCU:init()
	-- MF bridge assigns qmdev_id at connect (see log). Fallback: ProductName + ModuleSerial from JSON.
	self.QmdevId = 0x397A6614
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
	_G.idr_minifcu_mf_custom_toliss_fcu_spd_value = uluaFind('cpuwolf/mf/MiniFCU/custom/0/0/value')
	_G.idr_minifcu_mf_custom_toliss_fcu_mach_value = uluaFind('cpuwolf/mf/MiniFCU/custom/0/1/value')
	_G.idr_minifcu_mf_custom_toliss_fcu_spd_mach_mode = uluaFind('cpuwolf/mf/MiniFCU/custom/0/2/value')
	_G.idr_minifcu_mf_custom_toliss_fcu_spd_dashes = uluaFind('cpuwolf/mf/MiniFCU/custom/0/3/value')
	_G.idr_minifcu_mf_custom_toliss_fcu_spd_dot = uluaFind('cpuwolf/mf/MiniFCU/custom/0/4/value')
	_G.idr_minifcu_mf_custom_toliss_fcu_hdg_value = uluaFind('cpuwolf/mf/MiniFCU/custom/0/5/value')
	_G.idr_minifcu_mf_custom_toliss_fcu_hdg_dashes = uluaFind('cpuwolf/mf/MiniFCU/custom/0/6/value')
	_G.idr_minifcu_mf_custom_toliss_fcu_hdg_dot = uluaFind('cpuwolf/mf/MiniFCU/custom/0/7/value')
	_G.idr_minifcu_mf_custom_toliss_fcu_alt_value = uluaFind('cpuwolf/mf/MiniFCU/custom/0/8/value')
	_G.idr_minifcu_mf_custom_toliss_fcu_alt_dot = uluaFind('cpuwolf/mf/MiniFCU/custom/0/9/value')
	_G.idr_minifcu_mf_custom_toliss_fcu_vs_value = uluaFind('cpuwolf/mf/MiniFCU/custom/0/10/value')
	_G.idr_minifcu_mf_custom_toliss_fcu_fpa_value = uluaFind('cpuwolf/mf/MiniFCU/custom/0/11/value')
	_G.idr_minifcu_mf_custom_toliss_fcu_vs_dashes = uluaFind('cpuwolf/mf/MiniFCU/custom/0/12/value')
	_G.idr_minifcu_mf_custom_toliss_fcu_hdg_trk_mode = uluaFind('cpuwolf/mf/MiniFCU/custom/0/13/value')
	_G.idr_minifcu_mf_custom_toliss_efis_cstr = uluaFind('cpuwolf/mf/MiniFCU/custom/1/0/value')
	_G.idr_minifcu_mf_custom_toliss_efis_wpt = uluaFind('cpuwolf/mf/MiniFCU/custom/1/1/value')
	_G.idr_minifcu_mf_custom_toliss_efis_vord = uluaFind('cpuwolf/mf/MiniFCU/custom/1/2/value')
	_G.idr_minifcu_mf_custom_toliss_efis_ndb = uluaFind('cpuwolf/mf/MiniFCU/custom/1/3/value')
	_G.idr_minifcu_mf_custom_toliss_efis_arpt = uluaFind('cpuwolf/mf/MiniFCU/custom/1/4/value')
	_G.idr_minifcu_mf_custom_toliss_fcu_fd_value = uluaFind('cpuwolf/mf/MiniFCU/custom/1/5/value')
	_G.idr_minifcu_mf_custom_toliss_fcu_ls_value = uluaFind('cpuwolf/mf/MiniFCU/custom/1/6/value')
	_G.idr_minifcu_mf_custom_toliss_efis_baro_qnnh_1 = uluaFind('cpuwolf/mf/MiniFCU/custom/1/7/value')
	_G.idr_minifcu_mf_custom_toliss_efis_baro_std_1 = uluaFind('cpuwolf/mf/MiniFCU/custom/1/8/value')
	_G.idr_minifcu_mf_custom_toliss_efis_baro_inhg_hpa_unit = uluaFind('cpuwolf/mf/MiniFCU/custom/1/9/value')
	_G.idr_minifcu_mf_custom_toliss_efis_baro_inhg = uluaFind('cpuwolf/mf/MiniFCU/custom/1/10/value')
	_G.idr_minifcu_mf_custom_toliss_efis_baro = uluaFind('cpuwolf/mf/MiniFCU/custom/1/11/value')
	uluaSet(_G.idr_minifcu_hid_fastkeypersec, FastTurnsPerSecond)

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
-- output AP1 (output/0/state, pin AP1)

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
-- output AP2 (output/1/state, pin AP2)

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
-- output APPR (output/2/state, pin APPR)

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
-- output ATHR (output/3/state, pin ATHR)

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
-- output EXPED (output/4/state, pin EXPED)

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
-- output LOC (output/5/state, pin LOC)

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
-- custom device TOLISS - FCU - SPD - VALUE (custom/0/0/value, MessageType 0)

function MiniFCU:GetTolissFcuSpdValue(dpath, scale)
	self.d_toliss_fcu_spd_value_scale = scale == nil and 1 or scale
	self.d_toliss_fcu_spd_value = iDataRef:New(dpath)
end

function MiniFCU:SetTolissFcuSpdValue(val)
	if val == nil then
		val = self.d_toliss_fcu_spd_value:Get() * self.d_toliss_fcu_spd_value_scale
		if self.d_toliss_fcu_spd_value:ChangedUpdate() then
			uluaSet(_G.idr_minifcu_mf_custom_toliss_fcu_spd_value, val)
		end
	else
		uluaSet(_G.idr_minifcu_mf_custom_toliss_fcu_spd_value, val)
	end
end

function MiniFCU:FreshTolissFcuSpdValue()
	self.d_toliss_fcu_spd_value:Invalid(-1)
end

-- ========
-- custom device TOLISS - FCU - MACH - VALUE (custom/0/1/value, MessageType 1)

function MiniFCU:GetTolissFcuMachValue(dpath, scale)
	self.d_toliss_fcu_mach_value_scale = scale == nil and 1 or scale
	self.d_toliss_fcu_mach_value = iDataRef:New(dpath)
end

function MiniFCU:SetTolissFcuMachValue(val)
	if val == nil then
		val = self.d_toliss_fcu_mach_value:Get() * self.d_toliss_fcu_mach_value_scale
		if self.d_toliss_fcu_mach_value:ChangedUpdate() then
			uluaSet(_G.idr_minifcu_mf_custom_toliss_fcu_mach_value, val)
		end
	else
		uluaSet(_G.idr_minifcu_mf_custom_toliss_fcu_mach_value, val)
	end
end

function MiniFCU:FreshTolissFcuMachValue()
	self.d_toliss_fcu_mach_value:Invalid(-1)
end

-- ========
-- custom device TOLISS - FCU - SPD/MACH - MODE (custom/0/2/value, MessageType 2)

function MiniFCU:GetTolissFcuSpdMachMode(dpath, scale)
	self.d_toliss_fcu_spd_mach_mode_scale = scale == nil and 1 or scale
	self.d_toliss_fcu_spd_mach_mode = iDataRef:New(dpath)
end

function MiniFCU:SetTolissFcuSpdMachMode(val)
	if val == nil then
		val = self.d_toliss_fcu_spd_mach_mode:Get() * self.d_toliss_fcu_spd_mach_mode_scale
		if self.d_toliss_fcu_spd_mach_mode:ChangedUpdate() then
			uluaSet(_G.idr_minifcu_mf_custom_toliss_fcu_spd_mach_mode, val)
		end
	else
		uluaSet(_G.idr_minifcu_mf_custom_toliss_fcu_spd_mach_mode, val)
	end
end

function MiniFCU:FreshTolissFcuSpdMachMode()
	self.d_toliss_fcu_spd_mach_mode:Invalid(-1)
end

-- ========
-- custom device TOLISS - FCU - SPD - DASHES (custom/0/3/value, MessageType 3)

function MiniFCU:GetTolissFcuSpdDashes(dpath, scale)
	self.d_toliss_fcu_spd_dashes_scale = scale == nil and 1 or scale
	self.d_toliss_fcu_spd_dashes = iDataRef:New(dpath)
end

function MiniFCU:SetTolissFcuSpdDashes(val)
	if val == nil then
		val = self.d_toliss_fcu_spd_dashes:Get() * self.d_toliss_fcu_spd_dashes_scale
		if self.d_toliss_fcu_spd_dashes:ChangedUpdate() then
			uluaSet(_G.idr_minifcu_mf_custom_toliss_fcu_spd_dashes, val)
		end
	else
		uluaSet(_G.idr_minifcu_mf_custom_toliss_fcu_spd_dashes, val)
	end
end

function MiniFCU:FreshTolissFcuSpdDashes()
	self.d_toliss_fcu_spd_dashes:Invalid(-1)
end

-- ========
-- custom device TOLISS - FCU - SPD - DOT (custom/0/4/value, MessageType 4)

function MiniFCU:GetTolissFcuSpdDot(dpath, scale)
	self.d_toliss_fcu_spd_dot_scale = scale == nil and 1 or scale
	self.d_toliss_fcu_spd_dot = iDataRef:New(dpath)
end

function MiniFCU:SetTolissFcuSpdDot(val)
	if val == nil then
		val = self.d_toliss_fcu_spd_dot:Get() * self.d_toliss_fcu_spd_dot_scale
		if self.d_toliss_fcu_spd_dot:ChangedUpdate() then
			uluaSet(_G.idr_minifcu_mf_custom_toliss_fcu_spd_dot, val)
		end
	else
		uluaSet(_G.idr_minifcu_mf_custom_toliss_fcu_spd_dot, val)
	end
end

function MiniFCU:FreshTolissFcuSpdDot()
	self.d_toliss_fcu_spd_dot:Invalid(-1)
end

-- ========
-- custom device TOLISS - FCU - HDG - VALUE (custom/0/5/value, MessageType 5)

function MiniFCU:GetTolissFcuHdgValue(dpath, scale)
	self.d_toliss_fcu_hdg_value_scale = scale == nil and 1 or scale
	self.d_toliss_fcu_hdg_value = iDataRef:New(dpath)
end

function MiniFCU:SetTolissFcuHdgValue(val)
	if val == nil then
		val = self.d_toliss_fcu_hdg_value:Get() * self.d_toliss_fcu_hdg_value_scale
		if self.d_toliss_fcu_hdg_value:ChangedUpdate() then
			uluaSet(_G.idr_minifcu_mf_custom_toliss_fcu_hdg_value, val)
		end
	else
		uluaSet(_G.idr_minifcu_mf_custom_toliss_fcu_hdg_value, val)
	end
end

function MiniFCU:FreshTolissFcuHdgValue()
	self.d_toliss_fcu_hdg_value:Invalid(-1)
end

-- ========
-- custom device TOLISS - FCU - HDG - DASHES (custom/0/6/value, MessageType 6)

function MiniFCU:GetTolissFcuHdgDashes(dpath, scale)
	self.d_toliss_fcu_hdg_dashes_scale = scale == nil and 1 or scale
	self.d_toliss_fcu_hdg_dashes = iDataRef:New(dpath)
end

function MiniFCU:SetTolissFcuHdgDashes(val)
	if val == nil then
		val = self.d_toliss_fcu_hdg_dashes:Get() * self.d_toliss_fcu_hdg_dashes_scale
		if self.d_toliss_fcu_hdg_dashes:ChangedUpdate() then
			uluaSet(_G.idr_minifcu_mf_custom_toliss_fcu_hdg_dashes, val)
		end
	else
		uluaSet(_G.idr_minifcu_mf_custom_toliss_fcu_hdg_dashes, val)
	end
end

function MiniFCU:FreshTolissFcuHdgDashes()
	self.d_toliss_fcu_hdg_dashes:Invalid(-1)
end

-- ========
-- custom device TOLISS - FCU - HDG - DOT (custom/0/7/value, MessageType 7)

function MiniFCU:GetTolissFcuHdgDot(dpath, scale)
	self.d_toliss_fcu_hdg_dot_scale = scale == nil and 1 or scale
	self.d_toliss_fcu_hdg_dot = iDataRef:New(dpath)
end

function MiniFCU:SetTolissFcuHdgDot(val)
	if val == nil then
		val = self.d_toliss_fcu_hdg_dot:Get() * self.d_toliss_fcu_hdg_dot_scale
		if self.d_toliss_fcu_hdg_dot:ChangedUpdate() then
			uluaSet(_G.idr_minifcu_mf_custom_toliss_fcu_hdg_dot, val)
		end
	else
		uluaSet(_G.idr_minifcu_mf_custom_toliss_fcu_hdg_dot, val)
	end
end

function MiniFCU:FreshTolissFcuHdgDot()
	self.d_toliss_fcu_hdg_dot:Invalid(-1)
end

-- ========
-- custom device TOLISS - FCU - ALT - VALUE (custom/0/8/value, MessageType 8)

function MiniFCU:GetTolissFcuAltValue(dpath, scale)
	self.d_toliss_fcu_alt_value_scale = scale == nil and 1 or scale
	self.d_toliss_fcu_alt_value = iDataRef:New(dpath)
end

function MiniFCU:SetTolissFcuAltValue(val)
	if val == nil then
		val = self.d_toliss_fcu_alt_value:Get() * self.d_toliss_fcu_alt_value_scale
		if self.d_toliss_fcu_alt_value:ChangedUpdate() then
			uluaSet(_G.idr_minifcu_mf_custom_toliss_fcu_alt_value, val)
		end
	else
		uluaSet(_G.idr_minifcu_mf_custom_toliss_fcu_alt_value, val)
	end
end

function MiniFCU:FreshTolissFcuAltValue()
	self.d_toliss_fcu_alt_value:Invalid(-1)
end

-- ========
-- custom device TOLISS - FCU - ALT - DOT (custom/0/9/value, MessageType 9)

function MiniFCU:GetTolissFcuAltDot(dpath, scale)
	self.d_toliss_fcu_alt_dot_scale = scale == nil and 1 or scale
	self.d_toliss_fcu_alt_dot = iDataRef:New(dpath)
end

function MiniFCU:SetTolissFcuAltDot(val)
	if val == nil then
		val = self.d_toliss_fcu_alt_dot:Get() * self.d_toliss_fcu_alt_dot_scale
		if self.d_toliss_fcu_alt_dot:ChangedUpdate() then
			uluaSet(_G.idr_minifcu_mf_custom_toliss_fcu_alt_dot, val)
		end
	else
		uluaSet(_G.idr_minifcu_mf_custom_toliss_fcu_alt_dot, val)
	end
end

function MiniFCU:FreshTolissFcuAltDot()
	self.d_toliss_fcu_alt_dot:Invalid(-1)
end

-- ========
-- custom device TOLISS - FCU - VS - VALUE (custom/0/10/value, MessageType 10)

function MiniFCU:GetTolissFcuVsValue(dpath, scale)
	self.d_toliss_fcu_vs_value_scale = scale == nil and 1 or scale
	self.d_toliss_fcu_vs_value = iDataRef:New(dpath)
end

function MiniFCU:SetTolissFcuVsValue(val)
	if val == nil then
		val = self.d_toliss_fcu_vs_value:Get() * self.d_toliss_fcu_vs_value_scale
		if self.d_toliss_fcu_vs_value:ChangedUpdate() then
			uluaSet(_G.idr_minifcu_mf_custom_toliss_fcu_vs_value, val)
		end
	else
		uluaSet(_G.idr_minifcu_mf_custom_toliss_fcu_vs_value, val)
	end
end

function MiniFCU:FreshTolissFcuVsValue()
	self.d_toliss_fcu_vs_value:Invalid(-1)
end

-- ========
-- custom device TOLISS - FCU - FPA VALUE (custom/0/11/value, MessageType 11)

function MiniFCU:GetTolissFcuFpaValue(dpath, scale)
	self.d_toliss_fcu_fpa_value_scale = scale == nil and 1 or scale
	self.d_toliss_fcu_fpa_value = iDataRef:New(dpath)
end

function MiniFCU:SetTolissFcuFpaValue(val)
	if val == nil then
		val = self.d_toliss_fcu_fpa_value:Get() * self.d_toliss_fcu_fpa_value_scale
		if self.d_toliss_fcu_fpa_value:ChangedUpdate() then
			uluaSet(_G.idr_minifcu_mf_custom_toliss_fcu_fpa_value, val)
		end
	else
		uluaSet(_G.idr_minifcu_mf_custom_toliss_fcu_fpa_value, val)
	end
end

function MiniFCU:FreshTolissFcuFpaValue()
	self.d_toliss_fcu_fpa_value:Invalid(-1)
end

-- ========
-- custom device TOLISS - FCU - VS - DASHES (custom/0/12/value, MessageType 12)

function MiniFCU:GetTolissFcuVsDashes(dpath, scale)
	self.d_toliss_fcu_vs_dashes_scale = scale == nil and 1 or scale
	self.d_toliss_fcu_vs_dashes = iDataRef:New(dpath)
end

function MiniFCU:SetTolissFcuVsDashes(val)
	if val == nil then
		val = self.d_toliss_fcu_vs_dashes:Get() * self.d_toliss_fcu_vs_dashes_scale
		if self.d_toliss_fcu_vs_dashes:ChangedUpdate() then
			uluaSet(_G.idr_minifcu_mf_custom_toliss_fcu_vs_dashes, val)
		end
	else
		uluaSet(_G.idr_minifcu_mf_custom_toliss_fcu_vs_dashes, val)
	end
end

function MiniFCU:FreshTolissFcuVsDashes()
	self.d_toliss_fcu_vs_dashes:Invalid(-1)
end

-- ========
-- custom device TOLISS - FCU - HDG/TRK MODE (custom/0/13/value, MessageType 13)

function MiniFCU:GetTolissFcuHdgTrkMode(dpath, scale)
	self.d_toliss_fcu_hdg_trk_mode_scale = scale == nil and 1 or scale
	self.d_toliss_fcu_hdg_trk_mode = iDataRef:New(dpath)
end

function MiniFCU:SetTolissFcuHdgTrkMode(val)
	if val == nil then
		val = self.d_toliss_fcu_hdg_trk_mode:Get() * self.d_toliss_fcu_hdg_trk_mode_scale
		if self.d_toliss_fcu_hdg_trk_mode:ChangedUpdate() then
			uluaSet(_G.idr_minifcu_mf_custom_toliss_fcu_hdg_trk_mode, val)
		end
	else
		uluaSet(_G.idr_minifcu_mf_custom_toliss_fcu_hdg_trk_mode, val)
	end
end

function MiniFCU:FreshTolissFcuHdgTrkMode()
	self.d_toliss_fcu_hdg_trk_mode:Invalid(-1)
end

-- ========
-- custom device TOLISS - EFIS - CSTR (custom/1/0/value, MessageType 0)

function MiniFCU:GetTolissEfisCstr(dpath, scale)
	self.d_toliss_efis_cstr_scale = scale == nil and 1 or scale
	self.d_toliss_efis_cstr = iDataRef:New(dpath)
end

function MiniFCU:SetTolissEfisCstr(val)
	if val == nil then
		val = self.d_toliss_efis_cstr:Get() * self.d_toliss_efis_cstr_scale
		if self.d_toliss_efis_cstr:ChangedUpdate() then
			uluaSet(_G.idr_minifcu_mf_custom_toliss_efis_cstr, val)
		end
	else
		uluaSet(_G.idr_minifcu_mf_custom_toliss_efis_cstr, val)
	end
end

function MiniFCU:FreshTolissEfisCstr()
	self.d_toliss_efis_cstr:Invalid(-1)
end

-- ========
-- custom device TOLISS - EFIS - WPT (custom/1/1/value, MessageType 1)

function MiniFCU:GetTolissEfisWpt(dpath, scale)
	self.d_toliss_efis_wpt_scale = scale == nil and 1 or scale
	self.d_toliss_efis_wpt = iDataRef:New(dpath)
end

function MiniFCU:SetTolissEfisWpt(val)
	if val == nil then
		val = self.d_toliss_efis_wpt:Get() * self.d_toliss_efis_wpt_scale
		if self.d_toliss_efis_wpt:ChangedUpdate() then
			uluaSet(_G.idr_minifcu_mf_custom_toliss_efis_wpt, val)
		end
	else
		uluaSet(_G.idr_minifcu_mf_custom_toliss_efis_wpt, val)
	end
end

function MiniFCU:FreshTolissEfisWpt()
	self.d_toliss_efis_wpt:Invalid(-1)
end

-- ========
-- custom device TOLISS - EFIS - VORD (custom/1/2/value, MessageType 2)

function MiniFCU:GetTolissEfisVord(dpath, scale)
	self.d_toliss_efis_vord_scale = scale == nil and 1 or scale
	self.d_toliss_efis_vord = iDataRef:New(dpath)
end

function MiniFCU:SetTolissEfisVord(val)
	if val == nil then
		val = self.d_toliss_efis_vord:Get() * self.d_toliss_efis_vord_scale
		if self.d_toliss_efis_vord:ChangedUpdate() then
			uluaSet(_G.idr_minifcu_mf_custom_toliss_efis_vord, val)
		end
	else
		uluaSet(_G.idr_minifcu_mf_custom_toliss_efis_vord, val)
	end
end

function MiniFCU:FreshTolissEfisVord()
	self.d_toliss_efis_vord:Invalid(-1)
end

-- ========
-- custom device TOLISS - EFIS - NDB (custom/1/3/value, MessageType 3)

function MiniFCU:GetTolissEfisNdb(dpath, scale)
	self.d_toliss_efis_ndb_scale = scale == nil and 1 or scale
	self.d_toliss_efis_ndb = iDataRef:New(dpath)
end

function MiniFCU:SetTolissEfisNdb(val)
	if val == nil then
		val = self.d_toliss_efis_ndb:Get() * self.d_toliss_efis_ndb_scale
		if self.d_toliss_efis_ndb:ChangedUpdate() then
			uluaSet(_G.idr_minifcu_mf_custom_toliss_efis_ndb, val)
		end
	else
		uluaSet(_G.idr_minifcu_mf_custom_toliss_efis_ndb, val)
	end
end

function MiniFCU:FreshTolissEfisNdb()
	self.d_toliss_efis_ndb:Invalid(-1)
end

-- ========
-- custom device TOLISS - EFIS - ARPT (custom/1/4/value, MessageType 4)

function MiniFCU:GetTolissEfisArpt(dpath, scale)
	self.d_toliss_efis_arpt_scale = scale == nil and 1 or scale
	self.d_toliss_efis_arpt = iDataRef:New(dpath)
end

function MiniFCU:SetTolissEfisArpt(val)
	if val == nil then
		val = self.d_toliss_efis_arpt:Get() * self.d_toliss_efis_arpt_scale
		if self.d_toliss_efis_arpt:ChangedUpdate() then
			uluaSet(_G.idr_minifcu_mf_custom_toliss_efis_arpt, val)
		end
	else
		uluaSet(_G.idr_minifcu_mf_custom_toliss_efis_arpt, val)
	end
end

function MiniFCU:FreshTolissEfisArpt()
	self.d_toliss_efis_arpt:Invalid(-1)
end

-- ========
-- custom device TOLISS - FCU - FD VALUE (custom/1/5/value, MessageType 5)

function MiniFCU:GetTolissFcuFdValue(dpath, scale)
	self.d_toliss_fcu_fd_value_scale = scale == nil and 1 or scale
	self.d_toliss_fcu_fd_value = iDataRef:New(dpath)
end

function MiniFCU:SetTolissFcuFdValue(val)
	if val == nil then
		val = self.d_toliss_fcu_fd_value:Get() * self.d_toliss_fcu_fd_value_scale
		if self.d_toliss_fcu_fd_value:ChangedUpdate() then
			uluaSet(_G.idr_minifcu_mf_custom_toliss_fcu_fd_value, val)
		end
	else
		uluaSet(_G.idr_minifcu_mf_custom_toliss_fcu_fd_value, val)
	end
end

function MiniFCU:FreshTolissFcuFdValue()
	self.d_toliss_fcu_fd_value:Invalid(-1)
end

-- ========
-- custom device TOLISS - FCU - LS VALUE (custom/1/6/value, MessageType 6)

function MiniFCU:GetTolissFcuLsValue(dpath, scale)
	self.d_toliss_fcu_ls_value_scale = scale == nil and 1 or scale
	self.d_toliss_fcu_ls_value = iDataRef:New(dpath)
end

function MiniFCU:SetTolissFcuLsValue(val)
	if val == nil then
		val = self.d_toliss_fcu_ls_value:Get() * self.d_toliss_fcu_ls_value_scale
		if self.d_toliss_fcu_ls_value:ChangedUpdate() then
			uluaSet(_G.idr_minifcu_mf_custom_toliss_fcu_ls_value, val)
		end
	else
		uluaSet(_G.idr_minifcu_mf_custom_toliss_fcu_ls_value, val)
	end
end

function MiniFCU:FreshTolissFcuLsValue()
	self.d_toliss_fcu_ls_value:Invalid(-1)
end

-- ========
-- custom device TOLISS - EFIS - BARO QNNH = 1 (custom/1/7/value, MessageType 7)

function MiniFCU:GetTolissEfisBaroQnnh1(dpath, scale)
	self.d_toliss_efis_baro_qnnh_1_scale = scale == nil and 1 or scale
	self.d_toliss_efis_baro_qnnh_1 = iDataRef:New(dpath)
end

function MiniFCU:SetTolissEfisBaroQnnh1(val)
	if val == nil then
		val = self.d_toliss_efis_baro_qnnh_1:Get() * self.d_toliss_efis_baro_qnnh_1_scale
		if self.d_toliss_efis_baro_qnnh_1:ChangedUpdate() then
			uluaSet(_G.idr_minifcu_mf_custom_toliss_efis_baro_qnnh_1, val)
		end
	else
		uluaSet(_G.idr_minifcu_mf_custom_toliss_efis_baro_qnnh_1, val)
	end
end

function MiniFCU:FreshTolissEfisBaroQnnh1()
	self.d_toliss_efis_baro_qnnh_1:Invalid(-1)
end

-- ========
-- custom device TOLISS - EFIS - BARO STD = 1 (custom/1/8/value, MessageType 8)

function MiniFCU:GetTolissEfisBaroStd1(dpath, scale)
	self.d_toliss_efis_baro_std_1_scale = scale == nil and 1 or scale
	self.d_toliss_efis_baro_std_1 = iDataRef:New(dpath)
end

function MiniFCU:SetTolissEfisBaroStd1(val)
	if val == nil then
		val = self.d_toliss_efis_baro_std_1:Get() * self.d_toliss_efis_baro_std_1_scale
		if self.d_toliss_efis_baro_std_1:ChangedUpdate() then
			uluaSet(_G.idr_minifcu_mf_custom_toliss_efis_baro_std_1, val)
		end
	else
		uluaSet(_G.idr_minifcu_mf_custom_toliss_efis_baro_std_1, val)
	end
end

function MiniFCU:FreshTolissEfisBaroStd1()
	self.d_toliss_efis_baro_std_1:Invalid(-1)
end

-- ========
-- custom device TOLISS - EFIS - BARO INHG/HPA - UNIT (custom/1/9/value, MessageType 9)

function MiniFCU:GetTolissEfisBaroInhgHpaUnit(dpath, scale)
	self.d_toliss_efis_baro_inhg_hpa_unit_scale = scale == nil and 1 or scale
	self.d_toliss_efis_baro_inhg_hpa_unit = iDataRef:New(dpath)
end

function MiniFCU:SetTolissEfisBaroInhgHpaUnit(val)
	if val == nil then
		val = self.d_toliss_efis_baro_inhg_hpa_unit:Get() * self.d_toliss_efis_baro_inhg_hpa_unit_scale
		if self.d_toliss_efis_baro_inhg_hpa_unit:ChangedUpdate() then
			uluaSet(_G.idr_minifcu_mf_custom_toliss_efis_baro_inhg_hpa_unit, val)
		end
	else
		uluaSet(_G.idr_minifcu_mf_custom_toliss_efis_baro_inhg_hpa_unit, val)
	end
end

function MiniFCU:FreshTolissEfisBaroInhgHpaUnit()
	self.d_toliss_efis_baro_inhg_hpa_unit:Invalid(-1)
end

-- ========
-- custom device TOLISS - EFIS - BARO INHG (custom/1/10/value, MessageType 10)

function MiniFCU:GetTolissEfisBaroInhg(dpath, scale)
	self.d_toliss_efis_baro_inhg_scale = scale == nil and 1 or scale
	self.d_toliss_efis_baro_inhg = iDataRef:New(dpath)
end

function MiniFCU:SetTolissEfisBaroInhg(val)
	if val == nil then
		val = self.d_toliss_efis_baro_inhg:Get() * self.d_toliss_efis_baro_inhg_scale
		if self.d_toliss_efis_baro_inhg:ChangedUpdate() then
			uluaSet(_G.idr_minifcu_mf_custom_toliss_efis_baro_inhg, val)
		end
	else
		uluaSet(_G.idr_minifcu_mf_custom_toliss_efis_baro_inhg, val)
	end
end

function MiniFCU:FreshTolissEfisBaroInhg()
	self.d_toliss_efis_baro_inhg:Invalid(-1)
end

-- ========
-- custom device TOLISS - EFIS - BARO (custom/1/11/value, MessageType 11)

function MiniFCU:GetTolissEfisBaro(dpath, scale)
	self.d_toliss_efis_baro_scale = scale == nil and 1 or scale
	self.d_toliss_efis_baro = iDataRef:New(dpath)
end

function MiniFCU:SetTolissEfisBaro(val)
	if val == nil then
		val = self.d_toliss_efis_baro:Get() * self.d_toliss_efis_baro_scale
		if self.d_toliss_efis_baro:ChangedUpdate() then
			uluaSet(_G.idr_minifcu_mf_custom_toliss_efis_baro, val)
		end
	else
		uluaSet(_G.idr_minifcu_mf_custom_toliss_efis_baro, val)
	end
end

function MiniFCU:FreshTolissEfisBaro()
	self.d_toliss_efis_baro:Invalid(-1)
end

-- ========
-- 手工段：codegen 按 JSON 通道名生成 TolissFcu*/TolissEfis* 访问器，
-- 下面把它们映射成 Toliss 脚本使用的短名，z_MINIFCU_Toliss.lua 无需改动。
--
-- 通道 → 线上帧: 32,<设备序号>,<messageID>,<值>;  值一律是十进制字符串（设备端再定点显示）。
-- 缩放按 .mfproj 里 Connector 的 Modifiers 对齐（例: ALT 发 ft/100、inHg 发 value*100 取整），
-- 所以这些通道一律不设 Decimals —— 由调用方给出设备要的那把整数。
--
-- 设备序号：线上取"板上 type=17 设备的出现顺序"，与下面 JSON 分组的 0/1 序号通常一致但不保证；
-- JSON 顺序只用于命名。

-- SpdVal — miniFCU LCD (MessageType 0)
function MiniFCU:GetSpdVal(dpath, scale) return self:GetTolissFcuSpdValue(dpath, scale) end

function MiniFCU:SetSpdVal(val) return self:SetTolissFcuSpdValue(val) end

function MiniFCU:FreshSpdVal() return self:FreshTolissFcuSpdValue() end

-- MachVal — miniFCU LCD (MessageType 1)
function MiniFCU:GetMachVal(dpath, scale) return self:GetTolissFcuMachValue(dpath, scale) end

function MiniFCU:SetMachVal(val) return self:SetTolissFcuMachValue(val) end

function MiniFCU:FreshMachVal() return self:FreshTolissFcuMachValue() end

-- SpdMode — miniFCU LCD (MessageType 2)
function MiniFCU:GetSpdMode(dpath, scale) return self:GetTolissFcuSpdMachMode(dpath, scale) end

function MiniFCU:SetSpdMode(val) return self:SetTolissFcuSpdMachMode(val) end

function MiniFCU:FreshSpdMode() return self:FreshTolissFcuSpdMachMode() end

-- SpdDashes — miniFCU LCD (MessageType 3)
function MiniFCU:GetSpdDashes(dpath, scale) return self:GetTolissFcuSpdDashes(dpath, scale) end

function MiniFCU:SetSpdDashes(val) return self:SetTolissFcuSpdDashes(val) end

function MiniFCU:FreshSpdDashes() return self:FreshTolissFcuSpdDashes() end

-- SpdDot — miniFCU LCD (MessageType 4)
function MiniFCU:GetSpdDot(dpath, scale) return self:GetTolissFcuSpdDot(dpath, scale) end

function MiniFCU:SetSpdDot(val) return self:SetTolissFcuSpdDot(val) end

function MiniFCU:FreshSpdDot() return self:FreshTolissFcuSpdDot() end

-- HdgVal — miniFCU LCD (MessageType 5)
function MiniFCU:GetHdgVal(dpath, scale) return self:GetTolissFcuHdgValue(dpath, scale) end

function MiniFCU:SetHdgVal(val) return self:SetTolissFcuHdgValue(val) end

function MiniFCU:FreshHdgVal() return self:FreshTolissFcuHdgValue() end

-- HdgDashes — miniFCU LCD (MessageType 6)
function MiniFCU:GetHdgDashes(dpath, scale) return self:GetTolissFcuHdgDashes(dpath, scale) end

function MiniFCU:SetHdgDashes(val) return self:SetTolissFcuHdgDashes(val) end

function MiniFCU:FreshHdgDashes() return self:FreshTolissFcuHdgDashes() end

-- HdgDot — miniFCU LCD (MessageType 7)
function MiniFCU:GetHdgDot(dpath, scale) return self:GetTolissFcuHdgDot(dpath, scale) end

function MiniFCU:SetHdgDot(val) return self:SetTolissFcuHdgDot(val) end

function MiniFCU:FreshHdgDot() return self:FreshTolissFcuHdgDot() end

-- AltVal — miniFCU LCD (MessageType 8)
function MiniFCU:GetAltVal(dpath, scale) return self:GetTolissFcuAltValue(dpath, scale) end

function MiniFCU:SetAltVal(val) return self:SetTolissFcuAltValue(val) end

function MiniFCU:FreshAltVal() return self:FreshTolissFcuAltValue() end

-- AltDot — miniFCU LCD (MessageType 9)
function MiniFCU:GetAltDot(dpath, scale) return self:GetTolissFcuAltDot(dpath, scale) end

function MiniFCU:SetAltDot(val) return self:SetTolissFcuAltDot(val) end

function MiniFCU:FreshAltDot() return self:FreshTolissFcuAltDot() end

-- VsVal — miniFCU LCD (MessageType 10)
function MiniFCU:GetVsVal(dpath, scale) return self:GetTolissFcuVsValue(dpath, scale) end

function MiniFCU:SetVsVal(val) return self:SetTolissFcuVsValue(val) end

function MiniFCU:FreshVsVal() return self:FreshTolissFcuVsValue() end

-- FpaVal — miniFCU LCD (MessageType 11)
function MiniFCU:GetFpaVal(dpath, scale) return self:GetTolissFcuFpaValue(dpath, scale) end

function MiniFCU:SetFpaVal(val) return self:SetTolissFcuFpaValue(val) end

function MiniFCU:FreshFpaVal() return self:FreshTolissFcuFpaValue() end

-- VsDashes — miniFCU LCD (MessageType 12)
function MiniFCU:GetVsDashes(dpath, scale) return self:GetTolissFcuVsDashes(dpath, scale) end

function MiniFCU:SetVsDashes(val) return self:SetTolissFcuVsDashes(val) end

function MiniFCU:FreshVsDashes() return self:FreshTolissFcuVsDashes() end

-- HdgtrkMode — miniFCU LCD (MessageType 13)
function MiniFCU:GetHdgtrkMode(dpath, scale) return self:GetTolissFcuHdgTrkMode(dpath, scale) end

function MiniFCU:SetHdgtrkMode(val) return self:SetTolissFcuHdgTrkMode(val) end

function MiniFCU:FreshHdgtrkMode() return self:FreshTolissFcuHdgTrkMode() end

-- Cstr — miniEFIS LED and LCD (MessageType 0)
function MiniFCU:GetCstr(dpath, scale) return self:GetTolissEfisCstr(dpath, scale) end

function MiniFCU:SetCstr(val) return self:SetTolissEfisCstr(val) end

function MiniFCU:FreshCstr() return self:FreshTolissEfisCstr() end

-- Wpt — miniEFIS LED and LCD (MessageType 1)
function MiniFCU:GetWpt(dpath, scale) return self:GetTolissEfisWpt(dpath, scale) end

function MiniFCU:SetWpt(val) return self:SetTolissEfisWpt(val) end

function MiniFCU:FreshWpt() return self:FreshTolissEfisWpt() end

-- Vord — miniEFIS LED and LCD (MessageType 2)
function MiniFCU:GetVord(dpath, scale) return self:GetTolissEfisVord(dpath, scale) end

function MiniFCU:SetVord(val) return self:SetTolissEfisVord(val) end

function MiniFCU:FreshVord() return self:FreshTolissEfisVord() end

-- Ndb — miniEFIS LED and LCD (MessageType 3)
function MiniFCU:GetNdb(dpath, scale) return self:GetTolissEfisNdb(dpath, scale) end

function MiniFCU:SetNdb(val) return self:SetTolissEfisNdb(val) end

function MiniFCU:FreshNdb() return self:FreshTolissEfisNdb() end

-- Arpt — miniEFIS LED and LCD (MessageType 4)
function MiniFCU:GetArpt(dpath, scale) return self:GetTolissEfisArpt(dpath, scale) end

function MiniFCU:SetArpt(val) return self:SetTolissEfisArpt(val) end

function MiniFCU:FreshArpt() return self:FreshTolissEfisArpt() end

-- Fd — miniEFIS LED and LCD (MessageType 5)
function MiniFCU:GetFd(dpath, scale) return self:GetTolissFcuFdValue(dpath, scale) end

function MiniFCU:SetFd(val) return self:SetTolissFcuFdValue(val) end

function MiniFCU:FreshFd() return self:FreshTolissFcuFdValue() end

-- Ls — miniEFIS LED and LCD (MessageType 6)
function MiniFCU:GetLs(dpath, scale) return self:GetTolissFcuLsValue(dpath, scale) end

function MiniFCU:SetLs(val) return self:SetTolissFcuLsValue(val) end

function MiniFCU:FreshLs() return self:FreshTolissFcuLsValue() end

-- Qnh — miniEFIS LED and LCD (MessageType 7)
function MiniFCU:GetQnh(dpath, scale) return self:GetTolissEfisBaroQnnh1(dpath, scale) end

function MiniFCU:SetQnh(val) return self:SetTolissEfisBaroQnnh1(val) end

function MiniFCU:FreshQnh() return self:FreshTolissEfisBaroQnnh1() end

-- BaroStd — miniEFIS LED and LCD (MessageType 8)
function MiniFCU:GetBaroStd(dpath, scale) return self:GetTolissEfisBaroStd1(dpath, scale) end

function MiniFCU:SetBaroStd(val) return self:SetTolissEfisBaroStd1(val) end

function MiniFCU:FreshBaroStd() return self:FreshTolissEfisBaroStd1() end

-- BaroUnit — miniEFIS LED and LCD (MessageType 9)
function MiniFCU:GetBaroUnit(dpath, scale) return self:GetTolissEfisBaroInhgHpaUnit(dpath, scale) end

function MiniFCU:SetBaroUnit(val) return self:SetTolissEfisBaroInhgHpaUnit(val) end

function MiniFCU:FreshBaroUnit() return self:FreshTolissEfisBaroInhgHpaUnit() end

-- BaroInhg — miniEFIS LED and LCD (MessageType 10)
function MiniFCU:GetBaroInhg(dpath, scale) return self:GetTolissEfisBaroInhg(dpath, scale) end

function MiniFCU:SetBaroInhg(val) return self:SetTolissEfisBaroInhg(val) end

function MiniFCU:FreshBaroInhg() return self:FreshTolissEfisBaroInhg() end

-- BaroHpa — miniEFIS LED and LCD (MessageType 11)
function MiniFCU:GetBaroHpa(dpath, scale) return self:GetTolissEfisBaro(dpath, scale) end

function MiniFCU:SetBaroHpa(val) return self:SetTolissEfisBaro(val) end

function MiniFCU:FreshBaroHpa() return self:FreshTolissEfisBaro() end

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
