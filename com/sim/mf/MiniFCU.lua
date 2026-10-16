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
	_G.idr_minifcu_mf_custom_fcu_spd_value = uluaFind('cpuwolf/mf/MiniFCU/custom/0/0/value')
	_G.idr_minifcu_mf_custom_fcu_mach_value = uluaFind('cpuwolf/mf/MiniFCU/custom/0/1/value')
	_G.idr_minifcu_mf_custom_fcu_spd_mach_mode = uluaFind('cpuwolf/mf/MiniFCU/custom/0/2/value')
	_G.idr_minifcu_mf_custom_fcu_spd_dashes = uluaFind('cpuwolf/mf/MiniFCU/custom/0/3/value')
	_G.idr_minifcu_mf_custom_fcu_spd_dot = uluaFind('cpuwolf/mf/MiniFCU/custom/0/4/value')
	_G.idr_minifcu_mf_custom_fcu_hdg_value = uluaFind('cpuwolf/mf/MiniFCU/custom/0/5/value')
	_G.idr_minifcu_mf_custom_fcu_hdg_dashes = uluaFind('cpuwolf/mf/MiniFCU/custom/0/6/value')
	_G.idr_minifcu_mf_custom_fcu_hdg_dot = uluaFind('cpuwolf/mf/MiniFCU/custom/0/7/value')
	_G.idr_minifcu_mf_custom_fcu_alt_value = uluaFind('cpuwolf/mf/MiniFCU/custom/0/8/value')
	_G.idr_minifcu_mf_custom_fcu_alt_dot = uluaFind('cpuwolf/mf/MiniFCU/custom/0/9/value')
	_G.idr_minifcu_mf_custom_fcu_vs_value = uluaFind('cpuwolf/mf/MiniFCU/custom/0/10/value')
	_G.idr_minifcu_mf_custom_fcu_fpa_value = uluaFind('cpuwolf/mf/MiniFCU/custom/0/11/value')
	_G.idr_minifcu_mf_custom_fcu_vs_dashes = uluaFind('cpuwolf/mf/MiniFCU/custom/0/12/value')
	_G.idr_minifcu_mf_custom_fcu_hdg_trk_mode = uluaFind('cpuwolf/mf/MiniFCU/custom/0/13/value')
	_G.idr_minifcu_mf_custom_efis_cstr = uluaFind('cpuwolf/mf/MiniFCU/custom/1/0/value')
	_G.idr_minifcu_mf_custom_efis_wpt = uluaFind('cpuwolf/mf/MiniFCU/custom/1/1/value')
	_G.idr_minifcu_mf_custom_efis_vord = uluaFind('cpuwolf/mf/MiniFCU/custom/1/2/value')
	_G.idr_minifcu_mf_custom_efis_ndb = uluaFind('cpuwolf/mf/MiniFCU/custom/1/3/value')
	_G.idr_minifcu_mf_custom_efis_arpt = uluaFind('cpuwolf/mf/MiniFCU/custom/1/4/value')
	_G.idr_minifcu_mf_custom_fcu_fd_value = uluaFind('cpuwolf/mf/MiniFCU/custom/1/5/value')
	_G.idr_minifcu_mf_custom_fcu_ls_value = uluaFind('cpuwolf/mf/MiniFCU/custom/1/6/value')
	_G.idr_minifcu_mf_custom_efis_baro_qnnh_1 = uluaFind('cpuwolf/mf/MiniFCU/custom/1/7/value')
	_G.idr_minifcu_mf_custom_efis_baro_std_1 = uluaFind('cpuwolf/mf/MiniFCU/custom/1/8/value')
	_G.idr_minifcu_mf_custom_efis_baro_inhg_hpa_unit = uluaFind('cpuwolf/mf/MiniFCU/custom/1/9/value')
	_G.idr_minifcu_mf_custom_efis_baro_inhg = uluaFind('cpuwolf/mf/MiniFCU/custom/1/10/value')
	_G.idr_minifcu_mf_custom_efis_baro = uluaFind('cpuwolf/mf/MiniFCU/custom/1/11/value')
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

function MiniFCU:GetAp1(dpath, revert, base)
	self.d_ap1 = iDataRef:New(dpath, nil, revert, base)
end

function MiniFCU:SetAp1(val)
	if val == nil then
		val = self.d_ap1:GetBit() * 255
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

function MiniFCU:GetAp2(dpath, revert, base)
	self.d_ap2 = iDataRef:New(dpath, nil, revert, base)
end

function MiniFCU:SetAp2(val)
	if val == nil then
		val = self.d_ap2:GetBit() * 255
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

function MiniFCU:GetAppr(dpath, revert, base)
	self.d_appr = iDataRef:New(dpath, nil, revert, base)
end

function MiniFCU:SetAppr(val)
	if val == nil then
		val = self.d_appr:GetBit() * 255
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

function MiniFCU:GetAthr(dpath, revert, base)
	self.d_athr = iDataRef:New(dpath, nil, revert, base)
end

function MiniFCU:SetAthr(val)
	if val == nil then
		val = self.d_athr:GetBit() * 255
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

function MiniFCU:GetExped(dpath, revert, base)
	self.d_exped = iDataRef:New(dpath, nil, revert, base)
end

function MiniFCU:SetExped(val)
	if val == nil then
		val = self.d_exped:GetBit() * 255
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

function MiniFCU:GetLoc(dpath, revert, base)
	self.d_loc = iDataRef:New(dpath, nil, revert, base)
end

function MiniFCU:SetLoc(val)
	if val == nil then
		val = self.d_loc:GetBit() * 255
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
-- custom device FCU - SPD - VALUE (custom/0/0/value, MessageType 0)

function MiniFCU:GetFcuSpdValue(dpath, scale)
	self.d_fcu_spd_value_scale = scale == nil and 1 or scale
	self.d_fcu_spd_value = iDataRef:New(dpath)
end

function MiniFCU:SetFcuSpdValue(val)
	if val == nil then
		val = self.d_fcu_spd_value:Get() * self.d_fcu_spd_value_scale
		if self.d_fcu_spd_value:ChangedUpdate() then
			uluaSet(_G.idr_minifcu_mf_custom_fcu_spd_value, val)
		end
	else
		uluaSet(_G.idr_minifcu_mf_custom_fcu_spd_value, val)
	end
end

function MiniFCU:FreshFcuSpdValue()
	self.d_fcu_spd_value:Invalid(-1)
end

-- ========
-- custom device FCU - MACH - VALUE (custom/0/1/value, MessageType 1)

function MiniFCU:GetFcuMachValue(dpath, scale)
	self.d_fcu_mach_value_scale = scale == nil and 1 or scale
	self.d_fcu_mach_value = iDataRef:New(dpath)
end

function MiniFCU:SetFcuMachValue(val)
	if val == nil then
		val = self.d_fcu_mach_value:Get() * self.d_fcu_mach_value_scale
		if self.d_fcu_mach_value:ChangedUpdate() then
			uluaSet(_G.idr_minifcu_mf_custom_fcu_mach_value, val)
		end
	else
		uluaSet(_G.idr_minifcu_mf_custom_fcu_mach_value, val)
	end
end

function MiniFCU:FreshFcuMachValue()
	self.d_fcu_mach_value:Invalid(-1)
end

-- ========
-- custom device FCU - SPD/MACH - MODE (custom/0/2/value, MessageType 2)

function MiniFCU:GetFcuSpdMachMode(dpath, scale)
	self.d_fcu_spd_mach_mode_scale = scale == nil and 1 or scale
	self.d_fcu_spd_mach_mode = iDataRef:New(dpath)
end

function MiniFCU:SetFcuSpdMachMode(val)
	if val == nil then
		val = self.d_fcu_spd_mach_mode:Get() * self.d_fcu_spd_mach_mode_scale
		if self.d_fcu_spd_mach_mode:ChangedUpdate() then
			uluaSet(_G.idr_minifcu_mf_custom_fcu_spd_mach_mode, val)
		end
	else
		uluaSet(_G.idr_minifcu_mf_custom_fcu_spd_mach_mode, val)
	end
end

function MiniFCU:FreshFcuSpdMachMode()
	self.d_fcu_spd_mach_mode:Invalid(-1)
end

-- ========
-- custom device FCU - SPD - DASHES (custom/0/3/value, MessageType 3)

function MiniFCU:GetFcuSpdDashes(dpath, scale)
	self.d_fcu_spd_dashes_scale = scale == nil and 1 or scale
	self.d_fcu_spd_dashes = iDataRef:New(dpath)
end

function MiniFCU:SetFcuSpdDashes(val)
	if val == nil then
		val = self.d_fcu_spd_dashes:Get() * self.d_fcu_spd_dashes_scale
		if self.d_fcu_spd_dashes:ChangedUpdate() then
			uluaSet(_G.idr_minifcu_mf_custom_fcu_spd_dashes, val)
		end
	else
		uluaSet(_G.idr_minifcu_mf_custom_fcu_spd_dashes, val)
	end
end

function MiniFCU:FreshFcuSpdDashes()
	self.d_fcu_spd_dashes:Invalid(-1)
end

-- ========
-- custom device FCU - SPD - DOT (custom/0/4/value, MessageType 4)

function MiniFCU:GetFcuSpdDot(dpath, scale)
	self.d_fcu_spd_dot_scale = scale == nil and 1 or scale
	self.d_fcu_spd_dot = iDataRef:New(dpath)
end

function MiniFCU:SetFcuSpdDot(val)
	if val == nil then
		val = self.d_fcu_spd_dot:Get() * self.d_fcu_spd_dot_scale
		if self.d_fcu_spd_dot:ChangedUpdate() then
			uluaSet(_G.idr_minifcu_mf_custom_fcu_spd_dot, val)
		end
	else
		uluaSet(_G.idr_minifcu_mf_custom_fcu_spd_dot, val)
	end
end

function MiniFCU:FreshFcuSpdDot()
	self.d_fcu_spd_dot:Invalid(-1)
end

-- ========
-- custom device FCU - HDG - VALUE (custom/0/5/value, MessageType 5)

function MiniFCU:GetFcuHdgValue(dpath, scale)
	self.d_fcu_hdg_value_scale = scale == nil and 1 or scale
	self.d_fcu_hdg_value = iDataRef:New(dpath)
end

function MiniFCU:SetFcuHdgValue(val)
	if val == nil then
		val = self.d_fcu_hdg_value:Get() * self.d_fcu_hdg_value_scale
		if self.d_fcu_hdg_value:ChangedUpdate() then
			uluaSet(_G.idr_minifcu_mf_custom_fcu_hdg_value, val)
		end
	else
		uluaSet(_G.idr_minifcu_mf_custom_fcu_hdg_value, val)
	end
end

function MiniFCU:FreshFcuHdgValue()
	self.d_fcu_hdg_value:Invalid(-1)
end

-- ========
-- custom device FCU - HDG - DASHES (custom/0/6/value, MessageType 6)

function MiniFCU:GetFcuHdgDashes(dpath, scale)
	self.d_fcu_hdg_dashes_scale = scale == nil and 1 or scale
	self.d_fcu_hdg_dashes = iDataRef:New(dpath)
end

function MiniFCU:SetFcuHdgDashes(val)
	if val == nil then
		val = self.d_fcu_hdg_dashes:Get() * self.d_fcu_hdg_dashes_scale
		if self.d_fcu_hdg_dashes:ChangedUpdate() then
			uluaSet(_G.idr_minifcu_mf_custom_fcu_hdg_dashes, val)
		end
	else
		uluaSet(_G.idr_minifcu_mf_custom_fcu_hdg_dashes, val)
	end
end

function MiniFCU:FreshFcuHdgDashes()
	self.d_fcu_hdg_dashes:Invalid(-1)
end

-- ========
-- custom device FCU - HDG - DOT (custom/0/7/value, MessageType 7)

function MiniFCU:GetFcuHdgDot(dpath, scale)
	self.d_fcu_hdg_dot_scale = scale == nil and 1 or scale
	self.d_fcu_hdg_dot = iDataRef:New(dpath)
end

function MiniFCU:SetFcuHdgDot(val)
	if val == nil then
		val = self.d_fcu_hdg_dot:Get() * self.d_fcu_hdg_dot_scale
		if self.d_fcu_hdg_dot:ChangedUpdate() then
			uluaSet(_G.idr_minifcu_mf_custom_fcu_hdg_dot, val)
		end
	else
		uluaSet(_G.idr_minifcu_mf_custom_fcu_hdg_dot, val)
	end
end

function MiniFCU:FreshFcuHdgDot()
	self.d_fcu_hdg_dot:Invalid(-1)
end

-- ========
-- custom device FCU - ALT - VALUE (custom/0/8/value, MessageType 8)

function MiniFCU:GetFcuAltValue(dpath, scale)
	self.d_fcu_alt_value_scale = scale == nil and 1 or scale
	self.d_fcu_alt_value = iDataRef:New(dpath)
end

function MiniFCU:SetFcuAltValue(val)
	if val == nil then
		val = self.d_fcu_alt_value:Get() * self.d_fcu_alt_value_scale
		if self.d_fcu_alt_value:ChangedUpdate() then
			uluaSet(_G.idr_minifcu_mf_custom_fcu_alt_value, val)
		end
	else
		uluaSet(_G.idr_minifcu_mf_custom_fcu_alt_value, val)
	end
end

function MiniFCU:FreshFcuAltValue()
	self.d_fcu_alt_value:Invalid(-1)
end

-- ========
-- custom device FCU - ALT - DOT (custom/0/9/value, MessageType 9)

function MiniFCU:GetFcuAltDot(dpath, scale)
	self.d_fcu_alt_dot_scale = scale == nil and 1 or scale
	self.d_fcu_alt_dot = iDataRef:New(dpath)
end

function MiniFCU:SetFcuAltDot(val)
	if val == nil then
		val = self.d_fcu_alt_dot:Get() * self.d_fcu_alt_dot_scale
		if self.d_fcu_alt_dot:ChangedUpdate() then
			uluaSet(_G.idr_minifcu_mf_custom_fcu_alt_dot, val)
		end
	else
		uluaSet(_G.idr_minifcu_mf_custom_fcu_alt_dot, val)
	end
end

function MiniFCU:FreshFcuAltDot()
	self.d_fcu_alt_dot:Invalid(-1)
end

-- ========
-- custom device FCU - VS - VALUE (custom/0/10/value, MessageType 10)

function MiniFCU:GetFcuVsValue(dpath, scale)
	self.d_fcu_vs_value_scale = scale == nil and 1 or scale
	self.d_fcu_vs_value = iDataRef:New(dpath)
end

function MiniFCU:SetFcuVsValue(val)
	if val == nil then
		val = self.d_fcu_vs_value:Get() * self.d_fcu_vs_value_scale
		if self.d_fcu_vs_value:ChangedUpdate() then
			uluaSet(_G.idr_minifcu_mf_custom_fcu_vs_value, val)
		end
	else
		uluaSet(_G.idr_minifcu_mf_custom_fcu_vs_value, val)
	end
end

function MiniFCU:FreshFcuVsValue()
	self.d_fcu_vs_value:Invalid(-1)
end

-- ========
-- custom device FCU - FPA VALUE (custom/0/11/value, MessageType 11)

function MiniFCU:GetFcuFpaValue(dpath, scale)
	self.d_fcu_fpa_value_scale = scale == nil and 1 or scale
	self.d_fcu_fpa_value = iDataRef:New(dpath)
end

function MiniFCU:SetFcuFpaValue(val)
	if val == nil then
		val = self.d_fcu_fpa_value:Get() * self.d_fcu_fpa_value_scale
		if self.d_fcu_fpa_value:ChangedUpdate() then
			uluaSet(_G.idr_minifcu_mf_custom_fcu_fpa_value, val)
		end
	else
		uluaSet(_G.idr_minifcu_mf_custom_fcu_fpa_value, val)
	end
end

function MiniFCU:FreshFcuFpaValue()
	self.d_fcu_fpa_value:Invalid(-1)
end

-- ========
-- custom device FCU - VS - DASHES (custom/0/12/value, MessageType 12)

function MiniFCU:GetFcuVsDashes(dpath, revert, base)
	self.d_fcu_vs_dashes = iDataRef:New(dpath, nil, revert, base)
end

function MiniFCU:SetFcuVsDashes(val)
	if val == nil then
		val = self.d_fcu_vs_dashes:GetBit()
		if self.d_fcu_vs_dashes:ChangedUpdate() then
			uluaSet(_G.idr_minifcu_mf_custom_fcu_vs_dashes, val)
		end
	else
		uluaSet(_G.idr_minifcu_mf_custom_fcu_vs_dashes, val)
	end
end

function MiniFCU:FreshFcuVsDashes()
	self.d_fcu_vs_dashes:Invalid(-1)
end

-- ========
-- custom device FCU - HDG/TRK MODE (custom/0/13/value, MessageType 13)

function MiniFCU:GetFcuHdgTrkMode(dpath, scale)
	self.d_fcu_hdg_trk_mode_scale = scale == nil and 1 or scale
	self.d_fcu_hdg_trk_mode = iDataRef:New(dpath)
end

function MiniFCU:SetFcuHdgTrkMode(val)
	if val == nil then
		val = self.d_fcu_hdg_trk_mode:Get() * self.d_fcu_hdg_trk_mode_scale
		if self.d_fcu_hdg_trk_mode:ChangedUpdate() then
			uluaSet(_G.idr_minifcu_mf_custom_fcu_hdg_trk_mode, val)
		end
	else
		uluaSet(_G.idr_minifcu_mf_custom_fcu_hdg_trk_mode, val)
	end
end

function MiniFCU:FreshFcuHdgTrkMode()
	self.d_fcu_hdg_trk_mode:Invalid(-1)
end

-- ========
-- custom device EFIS - CSTR (custom/1/0/value, MessageType 0)

function MiniFCU:GetEfisCstr(dpath, scale)
	self.d_efis_cstr_scale = scale == nil and 1 or scale
	self.d_efis_cstr = iDataRef:New(dpath)
end

function MiniFCU:SetEfisCstr(val)
	if val == nil then
		val = self.d_efis_cstr:Get() * self.d_efis_cstr_scale
		if self.d_efis_cstr:ChangedUpdate() then
			uluaSet(_G.idr_minifcu_mf_custom_efis_cstr, val)
		end
	else
		uluaSet(_G.idr_minifcu_mf_custom_efis_cstr, val)
	end
end

function MiniFCU:FreshEfisCstr()
	self.d_efis_cstr:Invalid(-1)
end

-- ========
-- custom device EFIS - WPT (custom/1/1/value, MessageType 1)

function MiniFCU:GetEfisWpt(dpath, scale)
	self.d_efis_wpt_scale = scale == nil and 1 or scale
	self.d_efis_wpt = iDataRef:New(dpath)
end

function MiniFCU:SetEfisWpt(val)
	if val == nil then
		val = self.d_efis_wpt:Get() * self.d_efis_wpt_scale
		if self.d_efis_wpt:ChangedUpdate() then
			uluaSet(_G.idr_minifcu_mf_custom_efis_wpt, val)
		end
	else
		uluaSet(_G.idr_minifcu_mf_custom_efis_wpt, val)
	end
end

function MiniFCU:FreshEfisWpt()
	self.d_efis_wpt:Invalid(-1)
end

-- ========
-- custom device EFIS - VORD (custom/1/2/value, MessageType 2)

function MiniFCU:GetEfisVord(dpath, scale)
	self.d_efis_vord_scale = scale == nil and 1 or scale
	self.d_efis_vord = iDataRef:New(dpath)
end

function MiniFCU:SetEfisVord(val)
	if val == nil then
		val = self.d_efis_vord:Get() * self.d_efis_vord_scale
		if self.d_efis_vord:ChangedUpdate() then
			uluaSet(_G.idr_minifcu_mf_custom_efis_vord, val)
		end
	else
		uluaSet(_G.idr_minifcu_mf_custom_efis_vord, val)
	end
end

function MiniFCU:FreshEfisVord()
	self.d_efis_vord:Invalid(-1)
end

-- ========
-- custom device EFIS - NDB (custom/1/3/value, MessageType 3)

function MiniFCU:GetEfisNdb(dpath, scale)
	self.d_efis_ndb_scale = scale == nil and 1 or scale
	self.d_efis_ndb = iDataRef:New(dpath)
end

function MiniFCU:SetEfisNdb(val)
	if val == nil then
		val = self.d_efis_ndb:Get() * self.d_efis_ndb_scale
		if self.d_efis_ndb:ChangedUpdate() then
			uluaSet(_G.idr_minifcu_mf_custom_efis_ndb, val)
		end
	else
		uluaSet(_G.idr_minifcu_mf_custom_efis_ndb, val)
	end
end

function MiniFCU:FreshEfisNdb()
	self.d_efis_ndb:Invalid(-1)
end

-- ========
-- custom device EFIS - ARPT (custom/1/4/value, MessageType 4)

function MiniFCU:GetEfisArpt(dpath, scale)
	self.d_efis_arpt_scale = scale == nil and 1 or scale
	self.d_efis_arpt = iDataRef:New(dpath)
end

function MiniFCU:SetEfisArpt(val)
	if val == nil then
		val = self.d_efis_arpt:Get() * self.d_efis_arpt_scale
		if self.d_efis_arpt:ChangedUpdate() then
			uluaSet(_G.idr_minifcu_mf_custom_efis_arpt, val)
		end
	else
		uluaSet(_G.idr_minifcu_mf_custom_efis_arpt, val)
	end
end

function MiniFCU:FreshEfisArpt()
	self.d_efis_arpt:Invalid(-1)
end

-- ========
-- custom device FCU - FD VALUE (custom/1/5/value, MessageType 5)

function MiniFCU:GetFcuFdValue(dpath, scale)
	self.d_fcu_fd_value_scale = scale == nil and 1 or scale
	self.d_fcu_fd_value = iDataRef:New(dpath)
end

function MiniFCU:SetFcuFdValue(val)
	if val == nil then
		val = self.d_fcu_fd_value:Get() * self.d_fcu_fd_value_scale
		if self.d_fcu_fd_value:ChangedUpdate() then
			uluaSet(_G.idr_minifcu_mf_custom_fcu_fd_value, val)
		end
	else
		uluaSet(_G.idr_minifcu_mf_custom_fcu_fd_value, val)
	end
end

function MiniFCU:FreshFcuFdValue()
	self.d_fcu_fd_value:Invalid(-1)
end

-- ========
-- custom device FCU - LS VALUE (custom/1/6/value, MessageType 6)

function MiniFCU:GetFcuLsValue(dpath, scale)
	self.d_fcu_ls_value_scale = scale == nil and 1 or scale
	self.d_fcu_ls_value = iDataRef:New(dpath)
end

function MiniFCU:SetFcuLsValue(val)
	if val == nil then
		val = self.d_fcu_ls_value:Get() * self.d_fcu_ls_value_scale
		if self.d_fcu_ls_value:ChangedUpdate() then
			uluaSet(_G.idr_minifcu_mf_custom_fcu_ls_value, val)
		end
	else
		uluaSet(_G.idr_minifcu_mf_custom_fcu_ls_value, val)
	end
end

function MiniFCU:FreshFcuLsValue()
	self.d_fcu_ls_value:Invalid(-1)
end

-- ========
-- custom device EFIS - BARO QNNH = 1 (custom/1/7/value, MessageType 7)

function MiniFCU:GetEfisBaroQnnh1(dpath, scale)
	self.d_efis_baro_qnnh_1_scale = scale == nil and 1 or scale
	self.d_efis_baro_qnnh_1 = iDataRef:New(dpath)
end

function MiniFCU:SetEfisBaroQnnh1(val)
	if val == nil then
		val = self.d_efis_baro_qnnh_1:Get() * self.d_efis_baro_qnnh_1_scale
		if self.d_efis_baro_qnnh_1:ChangedUpdate() then
			uluaSet(_G.idr_minifcu_mf_custom_efis_baro_qnnh_1, val)
		end
	else
		uluaSet(_G.idr_minifcu_mf_custom_efis_baro_qnnh_1, val)
	end
end

function MiniFCU:FreshEfisBaroQnnh1()
	self.d_efis_baro_qnnh_1:Invalid(-1)
end

-- ========
-- custom device EFIS - BARO STD = 1 (custom/1/8/value, MessageType 8)

function MiniFCU:GetEfisBaroStd1(dpath, scale)
	self.d_efis_baro_std_1_scale = scale == nil and 1 or scale
	self.d_efis_baro_std_1 = iDataRef:New(dpath)
end

function MiniFCU:SetEfisBaroStd1(val)
	if val == nil then
		val = self.d_efis_baro_std_1:Get() * self.d_efis_baro_std_1_scale
		if self.d_efis_baro_std_1:ChangedUpdate() then
			uluaSet(_G.idr_minifcu_mf_custom_efis_baro_std_1, val)
		end
	else
		uluaSet(_G.idr_minifcu_mf_custom_efis_baro_std_1, val)
	end
end

function MiniFCU:FreshEfisBaroStd1()
	self.d_efis_baro_std_1:Invalid(-1)
end

-- ========
-- custom device EFIS - BARO INHG/HPA - UNIT (custom/1/9/value, MessageType 9)

function MiniFCU:GetEfisBaroInhgHpaUnit(dpath, scale)
	self.d_efis_baro_inhg_hpa_unit_scale = scale == nil and 1 or scale
	self.d_efis_baro_inhg_hpa_unit = iDataRef:New(dpath)
end

function MiniFCU:SetEfisBaroInhgHpaUnit(val)
	if val == nil then
		val = self.d_efis_baro_inhg_hpa_unit:Get() * self.d_efis_baro_inhg_hpa_unit_scale
		if self.d_efis_baro_inhg_hpa_unit:ChangedUpdate() then
			uluaSet(_G.idr_minifcu_mf_custom_efis_baro_inhg_hpa_unit, val)
		end
	else
		uluaSet(_G.idr_minifcu_mf_custom_efis_baro_inhg_hpa_unit, val)
	end
end

function MiniFCU:FreshEfisBaroInhgHpaUnit()
	self.d_efis_baro_inhg_hpa_unit:Invalid(-1)
end

-- ========
-- custom device EFIS - BARO INHG (custom/1/10/value, MessageType 10)

function MiniFCU:GetEfisBaroInhg(dpath, scale)
	self.d_efis_baro_inhg_scale = scale == nil and 1 or scale
	self.d_efis_baro_inhg = iDataRef:New(dpath)
end

function MiniFCU:SetEfisBaroInhg(val)
	if val == nil then
		val = self.d_efis_baro_inhg:Get() * self.d_efis_baro_inhg_scale
		if self.d_efis_baro_inhg:ChangedUpdate() then
			uluaSet(_G.idr_minifcu_mf_custom_efis_baro_inhg, val)
		end
	else
		uluaSet(_G.idr_minifcu_mf_custom_efis_baro_inhg, val)
	end
end

function MiniFCU:FreshEfisBaroInhg()
	self.d_efis_baro_inhg:Invalid(-1)
end

-- ========
-- custom device EFIS - BARO (custom/1/11/value, MessageType 11)

function MiniFCU:GetEfisBaro(dpath, scale)
	self.d_efis_baro_scale = scale == nil and 1 or scale
	self.d_efis_baro = iDataRef:New(dpath)
end

function MiniFCU:SetEfisBaro(val)
	if val == nil then
		val = self.d_efis_baro:Get() * self.d_efis_baro_scale
		if self.d_efis_baro:ChangedUpdate() then
			uluaSet(_G.idr_minifcu_mf_custom_efis_baro, val)
		end
	else
		uluaSet(_G.idr_minifcu_mf_custom_efis_baro, val)
	end
end

function MiniFCU:FreshEfisBaro()
	self.d_efis_baro:Invalid(-1)
end

return MiniFCU
