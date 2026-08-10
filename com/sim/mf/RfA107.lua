-- *****************************************************************
-- Don't modify this file, unless you know what you are doing
-- Most of the code are auto generated
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-08-10
-- source: mobiflight/rf_a107.json
-- *****************************************************************

local RfA107 = oop.class(com.sim.mf.MobiFlight)
function RfA107:init()
	-- MF bridge assigns qmdev_id at connect (see log). Fallback: ProductName + ModuleSerial from JSON.
	self.QmdevId = 0x500002
	self.FastTurnsPerSecond = 5
	if _G.ilua_hw_assigned_rfa107 == nil then
		_G.ilua_hw_assigned_rfa107 = 0
	end
end

function RfA107:absent(FastTurnsPerSecond)
	if not uluaFind('cpuwolf/flyluaio/RfA107/keysmap[0]') then
		return true
	end
	_G.idr_rfa107_hid_invalid = uluaFind('cpuwolf/flyluaio/RfA107/invalid')
	_G.idr_rfa107_hid_fastkeypersec = uluaFind('cpuwolf/flyluaio/RfA107/fastkeypersec')
	_G.idr_rfa107_mf_output_ir1_1 = uluaFind('cpuwolf/mf/RfA107/output/0/state')
	_G.idr_rfa107_mf_output_adirs_on_bat = uluaFind('cpuwolf/mf/RfA107/output/1/state')
	_G.idr_rfa107_mf_output_eng1_fire_1 = uluaFind('cpuwolf/mf/RfA107/output/2/state')
	_G.idr_rfa107_mf_output_aup_fire_led = uluaFind('cpuwolf/mf/RfA107/output/3/state')
	_G.idr_rfa107_mf_output_eng2_fire_1 = uluaFind('cpuwolf/mf/RfA107/output/4/state')
	_G.idr_rfa107_mf_output_ldg_flap3_2 = uluaFind('cpuwolf/mf/RfA107/output/5/state')
	_G.idr_rfa107_mf_output_rcdr_gnd_ctl_2 = uluaFind('cpuwolf/mf/RfA107/output/6/state')
	_G.idr_rfa107_mf_output_oxygen_crew_supply_2 = uluaFind('cpuwolf/mf/RfA107/output/7/state')
	_G.idr_rfa107_mf_output_pump_l_stby_1 = uluaFind('cpuwolf/mf/RfA107/output/8/state')
	_G.idr_rfa107_mf_output_ir1_2 = uluaFind('cpuwolf/mf/RfA107/output/9/state')
	_G.idr_rfa107_mf_output_ir3_1 = uluaFind('cpuwolf/mf/RfA107/output/10/state')
	_G.idr_rfa107_mf_output_ir3_2 = uluaFind('cpuwolf/mf/RfA107/output/11/state')
	_G.idr_rfa107_mf_output_ir2_1 = uluaFind('cpuwolf/mf/RfA107/output/12/state')
	_G.idr_rfa107_mf_output_ir2_2 = uluaFind('cpuwolf/mf/RfA107/output/13/state')
	_G.idr_rfa107_mf_output_pump_l_main_1 = uluaFind('cpuwolf/mf/RfA107/output/14/state')
	_G.idr_rfa107_mf_output_pump_l_main_2 = uluaFind('cpuwolf/mf/RfA107/output/15/state')
	_G.idr_rfa107_mf_output_pump_r_main_1 = uluaFind('cpuwolf/mf/RfA107/output/16/state')
	_G.idr_rfa107_mf_output_pump_l_stby_2 = uluaFind('cpuwolf/mf/RfA107/output/17/state')
	_G.idr_rfa107_mf_output_pump_l_1 = uluaFind('cpuwolf/mf/RfA107/output/18/state')
	_G.idr_rfa107_mf_output_pump_l_2 = uluaFind('cpuwolf/mf/RfA107/output/19/state')
	_G.idr_rfa107_mf_output_pump_center_tank_1 = uluaFind('cpuwolf/mf/RfA107/output/20/state')
	_G.idr_rfa107_mf_output_pump_center_tank_2 = uluaFind('cpuwolf/mf/RfA107/output/21/state')
	_G.idr_rfa107_mf_output_pump_r_1 = uluaFind('cpuwolf/mf/RfA107/output/22/state')
	_G.idr_rfa107_mf_output_pump_r_2 = uluaFind('cpuwolf/mf/RfA107/output/23/state')
	_G.idr_rfa107_mf_output_external_pwr_1 = uluaFind('cpuwolf/mf/RfA107/output/24/state')
	_G.idr_rfa107_mf_output_pump_r_main_2 = uluaFind('cpuwolf/mf/RfA107/output/25/state')
	_G.idr_rfa107_mf_output_pump_r_stby_1 = uluaFind('cpuwolf/mf/RfA107/output/26/state')
	_G.idr_rfa107_mf_output_pump_r_stby_2 = uluaFind('cpuwolf/mf/RfA107/output/27/state')
	_G.idr_rfa107_mf_output_bat1_off = uluaFind('cpuwolf/mf/RfA107/output/28/state')
	_G.idr_rfa107_mf_output_bat1_1 = uluaFind('cpuwolf/mf/RfA107/output/29/state')
	_G.idr_rfa107_mf_output_bat2_2 = uluaFind('cpuwolf/mf/RfA107/output/30/state')
	_G.idr_rfa107_mf_output_bat2_1 = uluaFind('cpuwolf/mf/RfA107/output/31/state')
	_G.idr_rfa107_mf_output_pack2_1 = uluaFind('cpuwolf/mf/RfA107/output/32/state')
	_G.idr_rfa107_mf_output_external_pwr_2 = uluaFind('cpuwolf/mf/RfA107/output/33/state')
	_G.idr_rfa107_mf_output_probe_window_heat_2 = uluaFind('cpuwolf/mf/RfA107/output/34/state')
	_G.idr_rfa107_mf_output_pack1_1 = uluaFind('cpuwolf/mf/RfA107/output/35/state')
	_G.idr_rfa107_mf_output_pack1_2 = uluaFind('cpuwolf/mf/RfA107/output/36/state')
	_G.idr_rfa107_mf_output_apu_bleed_1 = uluaFind('cpuwolf/mf/RfA107/output/37/state')
	_G.idr_rfa107_mf_output_apu_bleed_2 = uluaFind('cpuwolf/mf/RfA107/output/38/state')
	_G.idr_rfa107_mf_output_anti_ice_eng2_1 = uluaFind('cpuwolf/mf/RfA107/output/39/state')
	_G.idr_rfa107_mf_output_pack2_2 = uluaFind('cpuwolf/mf/RfA107/output/40/state')
	_G.idr_rfa107_mf_output_apu_mastersw_1 = uluaFind('cpuwolf/mf/RfA107/output/41/state')
	_G.idr_rfa107_mf_output_apu_mastersw_2 = uluaFind('cpuwolf/mf/RfA107/output/42/state')
	_G.idr_rfa107_mf_output_anti_ice_wing_1 = uluaFind('cpuwolf/mf/RfA107/output/43/state')
	_G.idr_rfa107_mf_output_anti_ice_wing_2 = uluaFind('cpuwolf/mf/RfA107/output/44/state')
	_G.idr_rfa107_mf_output_anti_ice_eng1_1 = uluaFind('cpuwolf/mf/RfA107/output/45/state')
	_G.idr_rfa107_mf_output_anti_ice_eng1_2 = uluaFind('cpuwolf/mf/RfA107/output/46/state')
	_G.idr_rfa107_mf_output_anti_ice_eng2_2 = uluaFind('cpuwolf/mf/RfA107/output/47/state')
	_G.idr_rfa107_mf_output_apu_start_1 = uluaFind('cpuwolf/mf/RfA107/output/48/state')
	_G.idr_rfa107_mf_output_apu_start_2 = uluaFind('cpuwolf/mf/RfA107/output/49/state')
	_G.idr_rfa107_mf_output_emer_exit_lt = uluaFind('cpuwolf/mf/RfA107/output/50/state')
	_G.idr_rfa107_mf_output_a107_backlight = uluaFind('cpuwolf/mf/RfA107/output/51/state')
	uluaSet(_G.idr_rfa107_hid_fastkeypersec, FastTurnsPerSecond)
	self:InitLedModule()
	return false
end

function RfA107:Init(FastTurnsPerSecond)
	local ftps = FastTurnsPerSecond == nil and self.FastTurnsPerSecond or FastTurnsPerSecond
	if self:absent(ftps) then
		return false
	end
	if _G.ilua_hw_assigned_rfa107 == 1 then
		return false
	end
	_G.ilua_hw_assigned_rfa107 = 1
	return true
end

function RfA107.Open(...)
	return com.sim.Qmdev.Open(RfA107, ...)
end

-- Display Module / LedModule "BAT 1+2" → segment/0 (CfNano / KayeRoof baseline)
function RfA107:InitLedModule()
	_G.idr_rfa107_mf_segment_mask = uluaFind('cpuwolf/mf/RfA107/segment/0/mask')
	_G.idr_rfa107_mf_segment_points = uluaFind('cpuwolf/mf/RfA107/segment/0/points')
	_G.idr_rfa107_mf_segment_commit = uluaFind('cpuwolf/mf/RfA107/segment/0/commit')
	_G.idr_rfa107_mf_segment_bat_1_2 = uluaFind('cpuwolf/mf/RfA107/segment/0/text')
	_G.idr_rfa107_mf_segment_brightness = uluaFind('cpuwolf/mf/RfA107/segment/0/brightness')

	-- 6-digit dual BAT display; DP on digits 1 and 4 (BAT2 / BAT1)
	uluaSet(_G.idr_rfa107_mf_segment_mask, 63)
	uluaSet(_G.idr_rfa107_mf_segment_points, 18)
	uluaSet(_G.idr_rfa107_mf_segment_brightness, 100)
	self.segment_commit_seq = 0
end

function RfA107:CommitSegment()
	self.segment_commit_seq = (self.segment_commit_seq or 0) + 1
	uluaSet(_G.idr_rfa107_mf_segment_commit, self.segment_commit_seq)
end

-- ========
-- segment BAT 1+2 (mfproj BAT1 VOLT + BAT2 VOLT → one LedModule)

local function pack_bat12_volts(v_bat1, v_bat2)
	-- mfproj: Round($,1); pack BAT1 in high 3 digits, BAT2 in low 3
	local n1 = math.floor((v_bat1 or 0) * 10 + 0.5)
	local n2 = math.floor((v_bat2 or 0) * 10 + 0.5)
	if n1 < 0 then n1 = 0 elseif n1 > 999 then n1 = 999 end
	if n2 < 0 then n2 = 0 elseif n2 > 999 then n2 = 999 end
	return n1 * 1000 + n2
end

function RfA107:GetBat12(dpath_bat1, dpath_bat2)
	self.d_bat12_1 = iDataRef:New(dpath_bat1)
	self.d_bat12_2 = iDataRef:New(dpath_bat2)
end

function RfA107:SetBat12(val)
	if val == nil then
		local v1 = self.d_bat12_1:Get()
		local v2 = self.d_bat12_2:Get()
		local changed = self.d_bat12_1:ChangedUpdate()
		changed = self.d_bat12_2:ChangedUpdate() or changed
		if changed then
			uluaSet(_G.idr_rfa107_mf_segment_bat_1_2, pack_bat12_volts(v1, v2))
			self:CommitSegment()
		end
	else
		uluaSet(_G.idr_rfa107_mf_segment_bat_1_2, val)
		self:CommitSegment()
	end
end

function RfA107:FreshBat12()
	self.d_bat12_1:Invalid(-1)
	self.d_bat12_2:Invalid(-1)
end

-- ========
-- output_shifter IR1-1 (output/0/state, pin 0)

-- Channel state 0–255 ↔ kSetPin (0=LOW, 255=HIGH, 1–254=PWM)

function RfA107:GetIr11(dpath, scale)
	self.d_ir1_1_scale = scale == nil and 255 or scale
	self.d_ir1_1 = iDataRef:New(dpath)
end

function RfA107:SetIr11(val)
	if val == nil then
		val = self.d_ir1_1:Get() * self.d_ir1_1_scale
		if self.d_ir1_1:ChangedUpdate() then
			uluaSet(_G.idr_rfa107_mf_output_ir1_1, val)
		end
	else
		uluaSet(_G.idr_rfa107_mf_output_ir1_1, val)
	end
end

function RfA107:FreshIr11()
	self.d_ir1_1:Invalid(-1)
end

-- ========
-- output_shifter ADIRS ON BAT (output/1/state, pin 1)

-- Channel state 0–255 ↔ kSetPin (0=LOW, 255=HIGH, 1–254=PWM)

function RfA107:GetAdirsOnBat(dpath, scale)
	self.d_adirs_on_bat_scale = scale == nil and 255 or scale
	self.d_adirs_on_bat = iDataRef:New(dpath)
end

function RfA107:SetAdirsOnBat(val)
	if val == nil then
		val = self.d_adirs_on_bat:Get() * self.d_adirs_on_bat_scale
		if self.d_adirs_on_bat:ChangedUpdate() then
			uluaSet(_G.idr_rfa107_mf_output_adirs_on_bat, val)
		end
	else
		uluaSet(_G.idr_rfa107_mf_output_adirs_on_bat, val)
	end
end

function RfA107:FreshAdirsOnBat()
	self.d_adirs_on_bat:Invalid(-1)
end

-- ========
-- output_shifter ENG1-FIRE-1 (output/2/state, pin 2)

-- Channel state 0–255 ↔ kSetPin (0=LOW, 255=HIGH, 1–254=PWM)

function RfA107:GetEng1Fire1(dpath, scale)
	self.d_eng1_fire_1_scale = scale == nil and 255 or scale
	self.d_eng1_fire_1 = iDataRef:New(dpath)
end

function RfA107:SetEng1Fire1(val)
	if val == nil then
		val = self.d_eng1_fire_1:Get() * self.d_eng1_fire_1_scale
		if self.d_eng1_fire_1:ChangedUpdate() then
			uluaSet(_G.idr_rfa107_mf_output_eng1_fire_1, val)
		end
	else
		uluaSet(_G.idr_rfa107_mf_output_eng1_fire_1, val)
	end
end

function RfA107:FreshEng1Fire1()
	self.d_eng1_fire_1:Invalid(-1)
end

-- ========
-- output_shifter AUP-FIRE-LED (output/3/state, pin 3)

-- Channel state 0–255 ↔ kSetPin (0=LOW, 255=HIGH, 1–254=PWM)

function RfA107:GetAupFireLed(dpath, scale)
	self.d_aup_fire_led_scale = scale == nil and 255 or scale
	self.d_aup_fire_led = iDataRef:New(dpath)
end

function RfA107:SetAupFireLed(val)
	if val == nil then
		val = self.d_aup_fire_led:Get() * self.d_aup_fire_led_scale
		if self.d_aup_fire_led:ChangedUpdate() then
			uluaSet(_G.idr_rfa107_mf_output_aup_fire_led, val)
		end
	else
		uluaSet(_G.idr_rfa107_mf_output_aup_fire_led, val)
	end
end

function RfA107:FreshAupFireLed()
	self.d_aup_fire_led:Invalid(-1)
end

-- ========
-- output_shifter ENG2-FIRE-1 (output/4/state, pin 4)

-- Channel state 0–255 ↔ kSetPin (0=LOW, 255=HIGH, 1–254=PWM)

function RfA107:GetEng2Fire1(dpath, scale)
	self.d_eng2_fire_1_scale = scale == nil and 255 or scale
	self.d_eng2_fire_1 = iDataRef:New(dpath)
end

function RfA107:SetEng2Fire1(val)
	if val == nil then
		val = self.d_eng2_fire_1:Get() * self.d_eng2_fire_1_scale
		if self.d_eng2_fire_1:ChangedUpdate() then
			uluaSet(_G.idr_rfa107_mf_output_eng2_fire_1, val)
		end
	else
		uluaSet(_G.idr_rfa107_mf_output_eng2_fire_1, val)
	end
end

function RfA107:FreshEng2Fire1()
	self.d_eng2_fire_1:Invalid(-1)
end

-- ========
-- output_shifter LDG FLAP3-2 (output/5/state, pin 5)

-- Channel state 0–255 ↔ kSetPin (0=LOW, 255=HIGH, 1–254=PWM)

function RfA107:GetLdgFlap32(dpath, scale)
	self.d_ldg_flap3_2_scale = scale == nil and 255 or scale
	self.d_ldg_flap3_2 = iDataRef:New(dpath)
end

function RfA107:SetLdgFlap32(val)
	if val == nil then
		val = self.d_ldg_flap3_2:Get() * self.d_ldg_flap3_2_scale
		if self.d_ldg_flap3_2:ChangedUpdate() then
			uluaSet(_G.idr_rfa107_mf_output_ldg_flap3_2, val)
		end
	else
		uluaSet(_G.idr_rfa107_mf_output_ldg_flap3_2, val)
	end
end

function RfA107:FreshLdgFlap32()
	self.d_ldg_flap3_2:Invalid(-1)
end

-- ========
-- output_shifter RCDR GND CTL-2 (output/6/state, pin 6)

-- Channel state 0–255 ↔ kSetPin (0=LOW, 255=HIGH, 1–254=PWM)

function RfA107:GetRcdrGndCtl2(dpath, scale)
	self.d_rcdr_gnd_ctl_2_scale = scale == nil and 255 or scale
	self.d_rcdr_gnd_ctl_2 = iDataRef:New(dpath)
end

function RfA107:SetRcdrGndCtl2(val)
	if val == nil then
		val = self.d_rcdr_gnd_ctl_2:Get() * self.d_rcdr_gnd_ctl_2_scale
		if self.d_rcdr_gnd_ctl_2:ChangedUpdate() then
			uluaSet(_G.idr_rfa107_mf_output_rcdr_gnd_ctl_2, val)
		end
	else
		uluaSet(_G.idr_rfa107_mf_output_rcdr_gnd_ctl_2, val)
	end
end

function RfA107:FreshRcdrGndCtl2()
	self.d_rcdr_gnd_ctl_2:Invalid(-1)
end

-- ========
-- output_shifter OXYGEN CREW SUPPLY-2 (output/7/state, pin 7)

-- Channel state 0–255 ↔ kSetPin (0=LOW, 255=HIGH, 1–254=PWM)

function RfA107:GetOxygenCrewSupply2(dpath, scale)
	self.d_oxygen_crew_supply_2_scale = scale == nil and 255 or scale
	self.d_oxygen_crew_supply_2 = iDataRef:New(dpath)
end

function RfA107:SetOxygenCrewSupply2(val)
	if val == nil then
		val = self.d_oxygen_crew_supply_2:Get() * self.d_oxygen_crew_supply_2_scale
		if self.d_oxygen_crew_supply_2:ChangedUpdate() then
			uluaSet(_G.idr_rfa107_mf_output_oxygen_crew_supply_2, val)
		end
	else
		uluaSet(_G.idr_rfa107_mf_output_oxygen_crew_supply_2, val)
	end
end

function RfA107:FreshOxygenCrewSupply2()
	self.d_oxygen_crew_supply_2:Invalid(-1)
end

-- ========
-- output_shifter PUMP-L-STBY-1 (output/8/state, pin 8)

-- Channel state 0–255 ↔ kSetPin (0=LOW, 255=HIGH, 1–254=PWM)

function RfA107:GetPumpLStby1(dpath, scale)
	self.d_pump_l_stby_1_scale = scale == nil and 255 or scale
	self.d_pump_l_stby_1 = iDataRef:New(dpath)
end

function RfA107:SetPumpLStby1(val)
	if val == nil then
		val = self.d_pump_l_stby_1:Get() * self.d_pump_l_stby_1_scale
		if self.d_pump_l_stby_1:ChangedUpdate() then
			uluaSet(_G.idr_rfa107_mf_output_pump_l_stby_1, val)
		end
	else
		uluaSet(_G.idr_rfa107_mf_output_pump_l_stby_1, val)
	end
end

function RfA107:FreshPumpLStby1()
	self.d_pump_l_stby_1:Invalid(-1)
end

-- ========
-- output_shifter IR1-2 (output/9/state, pin 9)

-- Channel state 0–255 ↔ kSetPin (0=LOW, 255=HIGH, 1–254=PWM)

function RfA107:GetIr12(dpath, scale)
	self.d_ir1_2_scale = scale == nil and 255 or scale
	self.d_ir1_2 = iDataRef:New(dpath)
end

function RfA107:SetIr12(val)
	if val == nil then
		val = self.d_ir1_2:Get() * self.d_ir1_2_scale
		if self.d_ir1_2:ChangedUpdate() then
			uluaSet(_G.idr_rfa107_mf_output_ir1_2, val)
		end
	else
		uluaSet(_G.idr_rfa107_mf_output_ir1_2, val)
	end
end

function RfA107:FreshIr12()
	self.d_ir1_2:Invalid(-1)
end

-- ========
-- output_shifter IR3-1 (output/10/state, pin 10)

-- Channel state 0–255 ↔ kSetPin (0=LOW, 255=HIGH, 1–254=PWM)

function RfA107:GetIr31(dpath, scale)
	self.d_ir3_1_scale = scale == nil and 255 or scale
	self.d_ir3_1 = iDataRef:New(dpath)
end

function RfA107:SetIr31(val)
	if val == nil then
		val = self.d_ir3_1:Get() * self.d_ir3_1_scale
		if self.d_ir3_1:ChangedUpdate() then
			uluaSet(_G.idr_rfa107_mf_output_ir3_1, val)
		end
	else
		uluaSet(_G.idr_rfa107_mf_output_ir3_1, val)
	end
end

function RfA107:FreshIr31()
	self.d_ir3_1:Invalid(-1)
end

-- ========
-- output_shifter IR3-2 (output/11/state, pin 11)

-- Channel state 0–255 ↔ kSetPin (0=LOW, 255=HIGH, 1–254=PWM)

function RfA107:GetIr32(dpath, scale)
	self.d_ir3_2_scale = scale == nil and 255 or scale
	self.d_ir3_2 = iDataRef:New(dpath)
end

function RfA107:SetIr32(val)
	if val == nil then
		val = self.d_ir3_2:Get() * self.d_ir3_2_scale
		if self.d_ir3_2:ChangedUpdate() then
			uluaSet(_G.idr_rfa107_mf_output_ir3_2, val)
		end
	else
		uluaSet(_G.idr_rfa107_mf_output_ir3_2, val)
	end
end

function RfA107:FreshIr32()
	self.d_ir3_2:Invalid(-1)
end

-- ========
-- output_shifter IR2-1 (output/12/state, pin 12)

-- Channel state 0–255 ↔ kSetPin (0=LOW, 255=HIGH, 1–254=PWM)

function RfA107:GetIr21(dpath, scale)
	self.d_ir2_1_scale = scale == nil and 255 or scale
	self.d_ir2_1 = iDataRef:New(dpath)
end

function RfA107:SetIr21(val)
	if val == nil then
		val = self.d_ir2_1:Get() * self.d_ir2_1_scale
		if self.d_ir2_1:ChangedUpdate() then
			uluaSet(_G.idr_rfa107_mf_output_ir2_1, val)
		end
	else
		uluaSet(_G.idr_rfa107_mf_output_ir2_1, val)
	end
end

function RfA107:FreshIr21()
	self.d_ir2_1:Invalid(-1)
end

-- ========
-- output_shifter IR2-2 (output/13/state, pin 13)

-- Channel state 0–255 ↔ kSetPin (0=LOW, 255=HIGH, 1–254=PWM)

function RfA107:GetIr22(dpath, scale)
	self.d_ir2_2_scale = scale == nil and 255 or scale
	self.d_ir2_2 = iDataRef:New(dpath)
end

function RfA107:SetIr22(val)
	if val == nil then
		val = self.d_ir2_2:Get() * self.d_ir2_2_scale
		if self.d_ir2_2:ChangedUpdate() then
			uluaSet(_G.idr_rfa107_mf_output_ir2_2, val)
		end
	else
		uluaSet(_G.idr_rfa107_mf_output_ir2_2, val)
	end
end

function RfA107:FreshIr22()
	self.d_ir2_2:Invalid(-1)
end

-- ========
-- output_shifter PUMP-L-MAIN-1 (output/14/state, pin 14)

-- Channel state 0–255 ↔ kSetPin (0=LOW, 255=HIGH, 1–254=PWM)

function RfA107:GetPumpLMain1(dpath, scale)
	self.d_pump_l_main_1_scale = scale == nil and 255 or scale
	self.d_pump_l_main_1 = iDataRef:New(dpath)
end

function RfA107:SetPumpLMain1(val)
	if val == nil then
		val = self.d_pump_l_main_1:Get() * self.d_pump_l_main_1_scale
		if self.d_pump_l_main_1:ChangedUpdate() then
			uluaSet(_G.idr_rfa107_mf_output_pump_l_main_1, val)
		end
	else
		uluaSet(_G.idr_rfa107_mf_output_pump_l_main_1, val)
	end
end

function RfA107:FreshPumpLMain1()
	self.d_pump_l_main_1:Invalid(-1)
end

-- ========
-- output_shifter PUMP-L-MAIN-2 (output/15/state, pin 15)

-- Channel state 0–255 ↔ kSetPin (0=LOW, 255=HIGH, 1–254=PWM)

function RfA107:GetPumpLMain2(dpath, scale)
	self.d_pump_l_main_2_scale = scale == nil and 255 or scale
	self.d_pump_l_main_2 = iDataRef:New(dpath)
end

function RfA107:SetPumpLMain2(val)
	if val == nil then
		val = self.d_pump_l_main_2:Get() * self.d_pump_l_main_2_scale
		if self.d_pump_l_main_2:ChangedUpdate() then
			uluaSet(_G.idr_rfa107_mf_output_pump_l_main_2, val)
		end
	else
		uluaSet(_G.idr_rfa107_mf_output_pump_l_main_2, val)
	end
end

function RfA107:FreshPumpLMain2()
	self.d_pump_l_main_2:Invalid(-1)
end

-- ========
-- output_shifter PUMP-R-MAIN-1 (output/16/state, pin 16)

-- Channel state 0–255 ↔ kSetPin (0=LOW, 255=HIGH, 1–254=PWM)

function RfA107:GetPumpRMain1(dpath, scale)
	self.d_pump_r_main_1_scale = scale == nil and 255 or scale
	self.d_pump_r_main_1 = iDataRef:New(dpath)
end

function RfA107:SetPumpRMain1(val)
	if val == nil then
		val = self.d_pump_r_main_1:Get() * self.d_pump_r_main_1_scale
		if self.d_pump_r_main_1:ChangedUpdate() then
			uluaSet(_G.idr_rfa107_mf_output_pump_r_main_1, val)
		end
	else
		uluaSet(_G.idr_rfa107_mf_output_pump_r_main_1, val)
	end
end

function RfA107:FreshPumpRMain1()
	self.d_pump_r_main_1:Invalid(-1)
end

-- ========
-- output_shifter PUMP-L-STBY-2 (output/17/state, pin 17)

-- Channel state 0–255 ↔ kSetPin (0=LOW, 255=HIGH, 1–254=PWM)

function RfA107:GetPumpLStby2(dpath, scale)
	self.d_pump_l_stby_2_scale = scale == nil and 255 or scale
	self.d_pump_l_stby_2 = iDataRef:New(dpath)
end

function RfA107:SetPumpLStby2(val)
	if val == nil then
		val = self.d_pump_l_stby_2:Get() * self.d_pump_l_stby_2_scale
		if self.d_pump_l_stby_2:ChangedUpdate() then
			uluaSet(_G.idr_rfa107_mf_output_pump_l_stby_2, val)
		end
	else
		uluaSet(_G.idr_rfa107_mf_output_pump_l_stby_2, val)
	end
end

function RfA107:FreshPumpLStby2()
	self.d_pump_l_stby_2:Invalid(-1)
end

-- ========
-- output_shifter PUMP-L-1 (output/18/state, pin 18)

-- Channel state 0–255 ↔ kSetPin (0=LOW, 255=HIGH, 1–254=PWM)

function RfA107:GetPumpL1(dpath, scale)
	self.d_pump_l_1_scale = scale == nil and 255 or scale
	self.d_pump_l_1 = iDataRef:New(dpath)
end

function RfA107:SetPumpL1(val)
	if val == nil then
		val = self.d_pump_l_1:Get() * self.d_pump_l_1_scale
		if self.d_pump_l_1:ChangedUpdate() then
			uluaSet(_G.idr_rfa107_mf_output_pump_l_1, val)
		end
	else
		uluaSet(_G.idr_rfa107_mf_output_pump_l_1, val)
	end
end

function RfA107:FreshPumpL1()
	self.d_pump_l_1:Invalid(-1)
end

-- ========
-- output_shifter PUMP-L-2 (output/19/state, pin 19)

-- Channel state 0–255 ↔ kSetPin (0=LOW, 255=HIGH, 1–254=PWM)

function RfA107:GetPumpL2(dpath, scale)
	self.d_pump_l_2_scale = scale == nil and 255 or scale
	self.d_pump_l_2 = iDataRef:New(dpath)
end

function RfA107:SetPumpL2(val)
	if val == nil then
		val = self.d_pump_l_2:Get() * self.d_pump_l_2_scale
		if self.d_pump_l_2:ChangedUpdate() then
			uluaSet(_G.idr_rfa107_mf_output_pump_l_2, val)
		end
	else
		uluaSet(_G.idr_rfa107_mf_output_pump_l_2, val)
	end
end

function RfA107:FreshPumpL2()
	self.d_pump_l_2:Invalid(-1)
end

-- ========
-- output_shifter PUMP-CENTER-TANK-1 (output/20/state, pin 20)

-- Channel state 0–255 ↔ kSetPin (0=LOW, 255=HIGH, 1–254=PWM)

function RfA107:GetPumpCenterTank1(dpath, scale)
	self.d_pump_center_tank_1_scale = scale == nil and 255 or scale
	self.d_pump_center_tank_1 = iDataRef:New(dpath)
end

function RfA107:SetPumpCenterTank1(val)
	if val == nil then
		val = self.d_pump_center_tank_1:Get() * self.d_pump_center_tank_1_scale
		if self.d_pump_center_tank_1:ChangedUpdate() then
			uluaSet(_G.idr_rfa107_mf_output_pump_center_tank_1, val)
		end
	else
		uluaSet(_G.idr_rfa107_mf_output_pump_center_tank_1, val)
	end
end

function RfA107:FreshPumpCenterTank1()
	self.d_pump_center_tank_1:Invalid(-1)
end

-- ========
-- output_shifter PUMP-CENTER-TANK-2 (output/21/state, pin 21)

-- Channel state 0–255 ↔ kSetPin (0=LOW, 255=HIGH, 1–254=PWM)

function RfA107:GetPumpCenterTank2(dpath, scale)
	self.d_pump_center_tank_2_scale = scale == nil and 255 or scale
	self.d_pump_center_tank_2 = iDataRef:New(dpath)
end

function RfA107:SetPumpCenterTank2(val)
	if val == nil then
		val = self.d_pump_center_tank_2:Get() * self.d_pump_center_tank_2_scale
		if self.d_pump_center_tank_2:ChangedUpdate() then
			uluaSet(_G.idr_rfa107_mf_output_pump_center_tank_2, val)
		end
	else
		uluaSet(_G.idr_rfa107_mf_output_pump_center_tank_2, val)
	end
end

function RfA107:FreshPumpCenterTank2()
	self.d_pump_center_tank_2:Invalid(-1)
end

-- ========
-- output_shifter PUMP-R-1 (output/22/state, pin 22)

-- Channel state 0–255 ↔ kSetPin (0=LOW, 255=HIGH, 1–254=PWM)

function RfA107:GetPumpR1(dpath, scale)
	self.d_pump_r_1_scale = scale == nil and 255 or scale
	self.d_pump_r_1 = iDataRef:New(dpath)
end

function RfA107:SetPumpR1(val)
	if val == nil then
		val = self.d_pump_r_1:Get() * self.d_pump_r_1_scale
		if self.d_pump_r_1:ChangedUpdate() then
			uluaSet(_G.idr_rfa107_mf_output_pump_r_1, val)
		end
	else
		uluaSet(_G.idr_rfa107_mf_output_pump_r_1, val)
	end
end

function RfA107:FreshPumpR1()
	self.d_pump_r_1:Invalid(-1)
end

-- ========
-- output_shifter PUMP-R-2 (output/23/state, pin 23)

-- Channel state 0–255 ↔ kSetPin (0=LOW, 255=HIGH, 1–254=PWM)

function RfA107:GetPumpR2(dpath, scale)
	self.d_pump_r_2_scale = scale == nil and 255 or scale
	self.d_pump_r_2 = iDataRef:New(dpath)
end

function RfA107:SetPumpR2(val)
	if val == nil then
		val = self.d_pump_r_2:Get() * self.d_pump_r_2_scale
		if self.d_pump_r_2:ChangedUpdate() then
			uluaSet(_G.idr_rfa107_mf_output_pump_r_2, val)
		end
	else
		uluaSet(_G.idr_rfa107_mf_output_pump_r_2, val)
	end
end

function RfA107:FreshPumpR2()
	self.d_pump_r_2:Invalid(-1)
end

-- ========
-- output_shifter EXTERNAL PWR-1 (output/24/state, pin 24)

-- Channel state 0–255 ↔ kSetPin (0=LOW, 255=HIGH, 1–254=PWM)

function RfA107:GetExternalPwr1(dpath, scale)
	self.d_external_pwr_1_scale = scale == nil and 255 or scale
	self.d_external_pwr_1 = iDataRef:New(dpath)
end

function RfA107:SetExternalPwr1(val)
	if val == nil then
		val = self.d_external_pwr_1:Get() * self.d_external_pwr_1_scale
		if self.d_external_pwr_1:ChangedUpdate() then
			uluaSet(_G.idr_rfa107_mf_output_external_pwr_1, val)
		end
	else
		uluaSet(_G.idr_rfa107_mf_output_external_pwr_1, val)
	end
end

function RfA107:FreshExternalPwr1()
	self.d_external_pwr_1:Invalid(-1)
end

-- ========
-- output_shifter PUMP-R-MAIN-2 (output/25/state, pin 25)

-- Channel state 0–255 ↔ kSetPin (0=LOW, 255=HIGH, 1–254=PWM)

function RfA107:GetPumpRMain2(dpath, scale)
	self.d_pump_r_main_2_scale = scale == nil and 255 or scale
	self.d_pump_r_main_2 = iDataRef:New(dpath)
end

function RfA107:SetPumpRMain2(val)
	if val == nil then
		val = self.d_pump_r_main_2:Get() * self.d_pump_r_main_2_scale
		if self.d_pump_r_main_2:ChangedUpdate() then
			uluaSet(_G.idr_rfa107_mf_output_pump_r_main_2, val)
		end
	else
		uluaSet(_G.idr_rfa107_mf_output_pump_r_main_2, val)
	end
end

function RfA107:FreshPumpRMain2()
	self.d_pump_r_main_2:Invalid(-1)
end

-- ========
-- output_shifter PUMP-R-STBY-1 (output/26/state, pin 26)

-- Channel state 0–255 ↔ kSetPin (0=LOW, 255=HIGH, 1–254=PWM)

function RfA107:GetPumpRStby1(dpath, scale)
	self.d_pump_r_stby_1_scale = scale == nil and 255 or scale
	self.d_pump_r_stby_1 = iDataRef:New(dpath)
end

function RfA107:SetPumpRStby1(val)
	if val == nil then
		val = self.d_pump_r_stby_1:Get() * self.d_pump_r_stby_1_scale
		if self.d_pump_r_stby_1:ChangedUpdate() then
			uluaSet(_G.idr_rfa107_mf_output_pump_r_stby_1, val)
		end
	else
		uluaSet(_G.idr_rfa107_mf_output_pump_r_stby_1, val)
	end
end

function RfA107:FreshPumpRStby1()
	self.d_pump_r_stby_1:Invalid(-1)
end

-- ========
-- output_shifter PUMP-R-STBY-2 (output/27/state, pin 27)

-- Channel state 0–255 ↔ kSetPin (0=LOW, 255=HIGH, 1–254=PWM)

function RfA107:GetPumpRStby2(dpath, scale)
	self.d_pump_r_stby_2_scale = scale == nil and 255 or scale
	self.d_pump_r_stby_2 = iDataRef:New(dpath)
end

function RfA107:SetPumpRStby2(val)
	if val == nil then
		val = self.d_pump_r_stby_2:Get() * self.d_pump_r_stby_2_scale
		if self.d_pump_r_stby_2:ChangedUpdate() then
			uluaSet(_G.idr_rfa107_mf_output_pump_r_stby_2, val)
		end
	else
		uluaSet(_G.idr_rfa107_mf_output_pump_r_stby_2, val)
	end
end

function RfA107:FreshPumpRStby2()
	self.d_pump_r_stby_2:Invalid(-1)
end

-- ========
-- output_shifter BAT1 OFF (output/28/state, pin 28)

-- Channel state 0–255 ↔ kSetPin (0=LOW, 255=HIGH, 1–254=PWM)

function RfA107:GetBat1Off(dpath, scale)
	self.d_bat1_off_scale = scale == nil and 255 or scale
	self.d_bat1_off = iDataRef:New(dpath)
end

function RfA107:SetBat1Off(val)
	if val == nil then
		val = self.d_bat1_off:Get() * self.d_bat1_off_scale
		if self.d_bat1_off:ChangedUpdate() then
			uluaSet(_G.idr_rfa107_mf_output_bat1_off, val)
		end
	else
		uluaSet(_G.idr_rfa107_mf_output_bat1_off, val)
	end
end

function RfA107:FreshBat1Off()
	self.d_bat1_off:Invalid(-1)
end

-- ========
-- output_shifter BAT1-1 (output/29/state, pin 29)

-- Channel state 0–255 ↔ kSetPin (0=LOW, 255=HIGH, 1–254=PWM)

function RfA107:GetBat11(dpath, scale)
	self.d_bat1_1_scale = scale == nil and 255 or scale
	self.d_bat1_1 = iDataRef:New(dpath)
end

function RfA107:SetBat11(val)
	if val == nil then
		val = self.d_bat1_1:Get() * self.d_bat1_1_scale
		if self.d_bat1_1:ChangedUpdate() then
			uluaSet(_G.idr_rfa107_mf_output_bat1_1, val)
		end
	else
		uluaSet(_G.idr_rfa107_mf_output_bat1_1, val)
	end
end

function RfA107:FreshBat11()
	self.d_bat1_1:Invalid(-1)
end

-- ========
-- output_shifter BAT2-2 (output/30/state, pin 30)

-- Channel state 0–255 ↔ kSetPin (0=LOW, 255=HIGH, 1–254=PWM)

function RfA107:GetBat22(dpath, scale)
	self.d_bat2_2_scale = scale == nil and 255 or scale
	self.d_bat2_2 = iDataRef:New(dpath)
end

function RfA107:SetBat22(val)
	if val == nil then
		val = self.d_bat2_2:Get() * self.d_bat2_2_scale
		if self.d_bat2_2:ChangedUpdate() then
			uluaSet(_G.idr_rfa107_mf_output_bat2_2, val)
		end
	else
		uluaSet(_G.idr_rfa107_mf_output_bat2_2, val)
	end
end

function RfA107:FreshBat22()
	self.d_bat2_2:Invalid(-1)
end

-- ========
-- output_shifter BAT2-1 (output/31/state, pin 31)

-- Channel state 0–255 ↔ kSetPin (0=LOW, 255=HIGH, 1–254=PWM)

function RfA107:GetBat21(dpath, scale)
	self.d_bat2_1_scale = scale == nil and 255 or scale
	self.d_bat2_1 = iDataRef:New(dpath)
end

function RfA107:SetBat21(val)
	if val == nil then
		val = self.d_bat2_1:Get() * self.d_bat2_1_scale
		if self.d_bat2_1:ChangedUpdate() then
			uluaSet(_G.idr_rfa107_mf_output_bat2_1, val)
		end
	else
		uluaSet(_G.idr_rfa107_mf_output_bat2_1, val)
	end
end

function RfA107:FreshBat21()
	self.d_bat2_1:Invalid(-1)
end

-- ========
-- output_shifter PACK2-1 (output/32/state, pin 0)

-- Channel state 0–255 ↔ kSetPin (0=LOW, 255=HIGH, 1–254=PWM)

function RfA107:GetPack21(dpath, scale)
	self.d_pack2_1_scale = scale == nil and 255 or scale
	self.d_pack2_1 = iDataRef:New(dpath)
end

function RfA107:SetPack21(val)
	if val == nil then
		val = self.d_pack2_1:Get() * self.d_pack2_1_scale
		if self.d_pack2_1:ChangedUpdate() then
			uluaSet(_G.idr_rfa107_mf_output_pack2_1, val)
		end
	else
		uluaSet(_G.idr_rfa107_mf_output_pack2_1, val)
	end
end

function RfA107:FreshPack21()
	self.d_pack2_1:Invalid(-1)
end

-- ========
-- output_shifter EXTERNAL PWR-2 (output/33/state, pin 1)

-- Channel state 0–255 ↔ kSetPin (0=LOW, 255=HIGH, 1–254=PWM)

function RfA107:GetExternalPwr2(dpath, scale)
	self.d_external_pwr_2_scale = scale == nil and 255 or scale
	self.d_external_pwr_2 = iDataRef:New(dpath)
end

function RfA107:SetExternalPwr2(val)
	if val == nil then
		val = self.d_external_pwr_2:Get() * self.d_external_pwr_2_scale
		if self.d_external_pwr_2:ChangedUpdate() then
			uluaSet(_G.idr_rfa107_mf_output_external_pwr_2, val)
		end
	else
		uluaSet(_G.idr_rfa107_mf_output_external_pwr_2, val)
	end
end

function RfA107:FreshExternalPwr2()
	self.d_external_pwr_2:Invalid(-1)
end

-- ========
-- output_shifter PROBE WINDOW HEAT-2 (output/34/state, pin 3)

-- Channel state 0–255 ↔ kSetPin (0=LOW, 255=HIGH, 1–254=PWM)

function RfA107:GetProbeWindowHeat2(dpath, scale)
	self.d_probe_window_heat_2_scale = scale == nil and 255 or scale
	self.d_probe_window_heat_2 = iDataRef:New(dpath)
end

function RfA107:SetProbeWindowHeat2(val)
	if val == nil then
		val = self.d_probe_window_heat_2:Get() * self.d_probe_window_heat_2_scale
		if self.d_probe_window_heat_2:ChangedUpdate() then
			uluaSet(_G.idr_rfa107_mf_output_probe_window_heat_2, val)
		end
	else
		uluaSet(_G.idr_rfa107_mf_output_probe_window_heat_2, val)
	end
end

function RfA107:FreshProbeWindowHeat2()
	self.d_probe_window_heat_2:Invalid(-1)
end

-- ========
-- output_shifter PACK1-1 (output/35/state, pin 4)

-- Channel state 0–255 ↔ kSetPin (0=LOW, 255=HIGH, 1–254=PWM)

function RfA107:GetPack11(dpath, scale)
	self.d_pack1_1_scale = scale == nil and 255 or scale
	self.d_pack1_1 = iDataRef:New(dpath)
end

function RfA107:SetPack11(val)
	if val == nil then
		val = self.d_pack1_1:Get() * self.d_pack1_1_scale
		if self.d_pack1_1:ChangedUpdate() then
			uluaSet(_G.idr_rfa107_mf_output_pack1_1, val)
		end
	else
		uluaSet(_G.idr_rfa107_mf_output_pack1_1, val)
	end
end

function RfA107:FreshPack11()
	self.d_pack1_1:Invalid(-1)
end

-- ========
-- output_shifter PACK1-2 (output/36/state, pin 5)

-- Channel state 0–255 ↔ kSetPin (0=LOW, 255=HIGH, 1–254=PWM)

function RfA107:GetPack12(dpath, scale)
	self.d_pack1_2_scale = scale == nil and 255 or scale
	self.d_pack1_2 = iDataRef:New(dpath)
end

function RfA107:SetPack12(val)
	if val == nil then
		val = self.d_pack1_2:Get() * self.d_pack1_2_scale
		if self.d_pack1_2:ChangedUpdate() then
			uluaSet(_G.idr_rfa107_mf_output_pack1_2, val)
		end
	else
		uluaSet(_G.idr_rfa107_mf_output_pack1_2, val)
	end
end

function RfA107:FreshPack12()
	self.d_pack1_2:Invalid(-1)
end

-- ========
-- output_shifter APU BLEED-1 (output/37/state, pin 6)

-- Channel state 0–255 ↔ kSetPin (0=LOW, 255=HIGH, 1–254=PWM)

function RfA107:GetApuBleed1(dpath, scale)
	self.d_apu_bleed_1_scale = scale == nil and 255 or scale
	self.d_apu_bleed_1 = iDataRef:New(dpath)
end

function RfA107:SetApuBleed1(val)
	if val == nil then
		val = self.d_apu_bleed_1:Get() * self.d_apu_bleed_1_scale
		if self.d_apu_bleed_1:ChangedUpdate() then
			uluaSet(_G.idr_rfa107_mf_output_apu_bleed_1, val)
		end
	else
		uluaSet(_G.idr_rfa107_mf_output_apu_bleed_1, val)
	end
end

function RfA107:FreshApuBleed1()
	self.d_apu_bleed_1:Invalid(-1)
end

-- ========
-- output_shifter APU BLEED-2 (output/38/state, pin 7)

-- Channel state 0–255 ↔ kSetPin (0=LOW, 255=HIGH, 1–254=PWM)

function RfA107:GetApuBleed2(dpath, scale)
	self.d_apu_bleed_2_scale = scale == nil and 255 or scale
	self.d_apu_bleed_2 = iDataRef:New(dpath)
end

function RfA107:SetApuBleed2(val)
	if val == nil then
		val = self.d_apu_bleed_2:Get() * self.d_apu_bleed_2_scale
		if self.d_apu_bleed_2:ChangedUpdate() then
			uluaSet(_G.idr_rfa107_mf_output_apu_bleed_2, val)
		end
	else
		uluaSet(_G.idr_rfa107_mf_output_apu_bleed_2, val)
	end
end

function RfA107:FreshApuBleed2()
	self.d_apu_bleed_2:Invalid(-1)
end

-- ========
-- output_shifter ANTI ICE ENG2-1 (output/39/state, pin 8)

-- Channel state 0–255 ↔ kSetPin (0=LOW, 255=HIGH, 1–254=PWM)

function RfA107:GetAntiIceEng21(dpath, scale)
	self.d_anti_ice_eng2_1_scale = scale == nil and 255 or scale
	self.d_anti_ice_eng2_1 = iDataRef:New(dpath)
end

function RfA107:SetAntiIceEng21(val)
	if val == nil then
		val = self.d_anti_ice_eng2_1:Get() * self.d_anti_ice_eng2_1_scale
		if self.d_anti_ice_eng2_1:ChangedUpdate() then
			uluaSet(_G.idr_rfa107_mf_output_anti_ice_eng2_1, val)
		end
	else
		uluaSet(_G.idr_rfa107_mf_output_anti_ice_eng2_1, val)
	end
end

function RfA107:FreshAntiIceEng21()
	self.d_anti_ice_eng2_1:Invalid(-1)
end

-- ========
-- output_shifter PACK2-2 (output/40/state, pin 9)

-- Channel state 0–255 ↔ kSetPin (0=LOW, 255=HIGH, 1–254=PWM)

function RfA107:GetPack22(dpath, scale)
	self.d_pack2_2_scale = scale == nil and 255 or scale
	self.d_pack2_2 = iDataRef:New(dpath)
end

function RfA107:SetPack22(val)
	if val == nil then
		val = self.d_pack2_2:Get() * self.d_pack2_2_scale
		if self.d_pack2_2:ChangedUpdate() then
			uluaSet(_G.idr_rfa107_mf_output_pack2_2, val)
		end
	else
		uluaSet(_G.idr_rfa107_mf_output_pack2_2, val)
	end
end

function RfA107:FreshPack22()
	self.d_pack2_2:Invalid(-1)
end

-- ========
-- output_shifter APU MASTERSW-1 (output/41/state, pin 10)

-- Channel state 0–255 ↔ kSetPin (0=LOW, 255=HIGH, 1–254=PWM)

function RfA107:GetApuMastersw1(dpath, scale)
	self.d_apu_mastersw_1_scale = scale == nil and 255 or scale
	self.d_apu_mastersw_1 = iDataRef:New(dpath)
end

function RfA107:SetApuMastersw1(val)
	if val == nil then
		val = self.d_apu_mastersw_1:Get() * self.d_apu_mastersw_1_scale
		if self.d_apu_mastersw_1:ChangedUpdate() then
			uluaSet(_G.idr_rfa107_mf_output_apu_mastersw_1, val)
		end
	else
		uluaSet(_G.idr_rfa107_mf_output_apu_mastersw_1, val)
	end
end

function RfA107:FreshApuMastersw1()
	self.d_apu_mastersw_1:Invalid(-1)
end

-- ========
-- output_shifter APU MASTERSW-2 (output/42/state, pin 11)

-- Channel state 0–255 ↔ kSetPin (0=LOW, 255=HIGH, 1–254=PWM)

function RfA107:GetApuMastersw2(dpath, scale)
	self.d_apu_mastersw_2_scale = scale == nil and 255 or scale
	self.d_apu_mastersw_2 = iDataRef:New(dpath)
end

function RfA107:SetApuMastersw2(val)
	if val == nil then
		val = self.d_apu_mastersw_2:Get() * self.d_apu_mastersw_2_scale
		if self.d_apu_mastersw_2:ChangedUpdate() then
			uluaSet(_G.idr_rfa107_mf_output_apu_mastersw_2, val)
		end
	else
		uluaSet(_G.idr_rfa107_mf_output_apu_mastersw_2, val)
	end
end

function RfA107:FreshApuMastersw2()
	self.d_apu_mastersw_2:Invalid(-1)
end

-- ========
-- output_shifter ANTI ICE WING-1 (output/43/state, pin 12)

-- Channel state 0–255 ↔ kSetPin (0=LOW, 255=HIGH, 1–254=PWM)

function RfA107:GetAntiIceWing1(dpath, scale)
	self.d_anti_ice_wing_1_scale = scale == nil and 255 or scale
	self.d_anti_ice_wing_1 = iDataRef:New(dpath)
end

function RfA107:SetAntiIceWing1(val)
	if val == nil then
		val = self.d_anti_ice_wing_1:Get() * self.d_anti_ice_wing_1_scale
		if self.d_anti_ice_wing_1:ChangedUpdate() then
			uluaSet(_G.idr_rfa107_mf_output_anti_ice_wing_1, val)
		end
	else
		uluaSet(_G.idr_rfa107_mf_output_anti_ice_wing_1, val)
	end
end

function RfA107:FreshAntiIceWing1()
	self.d_anti_ice_wing_1:Invalid(-1)
end

-- ========
-- output_shifter ANTI ICE WING-2 (output/44/state, pin 13)

-- Channel state 0–255 ↔ kSetPin (0=LOW, 255=HIGH, 1–254=PWM)

function RfA107:GetAntiIceWing2(dpath, scale)
	self.d_anti_ice_wing_2_scale = scale == nil and 255 or scale
	self.d_anti_ice_wing_2 = iDataRef:New(dpath)
end

function RfA107:SetAntiIceWing2(val)
	if val == nil then
		val = self.d_anti_ice_wing_2:Get() * self.d_anti_ice_wing_2_scale
		if self.d_anti_ice_wing_2:ChangedUpdate() then
			uluaSet(_G.idr_rfa107_mf_output_anti_ice_wing_2, val)
		end
	else
		uluaSet(_G.idr_rfa107_mf_output_anti_ice_wing_2, val)
	end
end

function RfA107:FreshAntiIceWing2()
	self.d_anti_ice_wing_2:Invalid(-1)
end

-- ========
-- output_shifter ANTI ICE ENG1-1 (output/45/state, pin 14)

-- Channel state 0–255 ↔ kSetPin (0=LOW, 255=HIGH, 1–254=PWM)

function RfA107:GetAntiIceEng11(dpath, scale)
	self.d_anti_ice_eng1_1_scale = scale == nil and 255 or scale
	self.d_anti_ice_eng1_1 = iDataRef:New(dpath)
end

function RfA107:SetAntiIceEng11(val)
	if val == nil then
		val = self.d_anti_ice_eng1_1:Get() * self.d_anti_ice_eng1_1_scale
		if self.d_anti_ice_eng1_1:ChangedUpdate() then
			uluaSet(_G.idr_rfa107_mf_output_anti_ice_eng1_1, val)
		end
	else
		uluaSet(_G.idr_rfa107_mf_output_anti_ice_eng1_1, val)
	end
end

function RfA107:FreshAntiIceEng11()
	self.d_anti_ice_eng1_1:Invalid(-1)
end

-- ========
-- output_shifter ANTI ICE ENG1-2 (output/46/state, pin 15)

-- Channel state 0–255 ↔ kSetPin (0=LOW, 255=HIGH, 1–254=PWM)

function RfA107:GetAntiIceEng12(dpath, scale)
	self.d_anti_ice_eng1_2_scale = scale == nil and 255 or scale
	self.d_anti_ice_eng1_2 = iDataRef:New(dpath)
end

function RfA107:SetAntiIceEng12(val)
	if val == nil then
		val = self.d_anti_ice_eng1_2:Get() * self.d_anti_ice_eng1_2_scale
		if self.d_anti_ice_eng1_2:ChangedUpdate() then
			uluaSet(_G.idr_rfa107_mf_output_anti_ice_eng1_2, val)
		end
	else
		uluaSet(_G.idr_rfa107_mf_output_anti_ice_eng1_2, val)
	end
end

function RfA107:FreshAntiIceEng12()
	self.d_anti_ice_eng1_2:Invalid(-1)
end

-- ========
-- output_shifter ANTI ICE ENG2-2 (output/47/state, pin 17)

-- Channel state 0–255 ↔ kSetPin (0=LOW, 255=HIGH, 1–254=PWM)

function RfA107:GetAntiIceEng22(dpath, scale)
	self.d_anti_ice_eng2_2_scale = scale == nil and 255 or scale
	self.d_anti_ice_eng2_2 = iDataRef:New(dpath)
end

function RfA107:SetAntiIceEng22(val)
	if val == nil then
		val = self.d_anti_ice_eng2_2:Get() * self.d_anti_ice_eng2_2_scale
		if self.d_anti_ice_eng2_2:ChangedUpdate() then
			uluaSet(_G.idr_rfa107_mf_output_anti_ice_eng2_2, val)
		end
	else
		uluaSet(_G.idr_rfa107_mf_output_anti_ice_eng2_2, val)
	end
end

function RfA107:FreshAntiIceEng22()
	self.d_anti_ice_eng2_2:Invalid(-1)
end

-- ========
-- output_shifter APU START-1 (output/48/state, pin 18)

-- Channel state 0–255 ↔ kSetPin (0=LOW, 255=HIGH, 1–254=PWM)

function RfA107:GetApuStart1(dpath, scale)
	self.d_apu_start_1_scale = scale == nil and 255 or scale
	self.d_apu_start_1 = iDataRef:New(dpath)
end

function RfA107:SetApuStart1(val)
	if val == nil then
		val = self.d_apu_start_1:Get() * self.d_apu_start_1_scale
		if self.d_apu_start_1:ChangedUpdate() then
			uluaSet(_G.idr_rfa107_mf_output_apu_start_1, val)
		end
	else
		uluaSet(_G.idr_rfa107_mf_output_apu_start_1, val)
	end
end

function RfA107:FreshApuStart1()
	self.d_apu_start_1:Invalid(-1)
end

-- ========
-- output_shifter APU START-2 (output/49/state, pin 19)

-- Channel state 0–255 ↔ kSetPin (0=LOW, 255=HIGH, 1–254=PWM)

function RfA107:GetApuStart2(dpath, scale)
	self.d_apu_start_2_scale = scale == nil and 255 or scale
	self.d_apu_start_2 = iDataRef:New(dpath)
end

function RfA107:SetApuStart2(val)
	if val == nil then
		val = self.d_apu_start_2:Get() * self.d_apu_start_2_scale
		if self.d_apu_start_2:ChangedUpdate() then
			uluaSet(_G.idr_rfa107_mf_output_apu_start_2, val)
		end
	else
		uluaSet(_G.idr_rfa107_mf_output_apu_start_2, val)
	end
end

function RfA107:FreshApuStart2()
	self.d_apu_start_2:Invalid(-1)
end

-- ========
-- output_shifter EMER EXIT LT (output/50/state, pin 22)

-- Channel state 0–255 ↔ kSetPin (0=LOW, 255=HIGH, 1–254=PWM)

function RfA107:GetEmerExitLt(dpath, scale)
	self.d_emer_exit_lt_scale = scale == nil and 255 or scale
	self.d_emer_exit_lt = iDataRef:New(dpath)
end

function RfA107:SetEmerExitLt(val)
	if val == nil then
		val = self.d_emer_exit_lt:Get() * self.d_emer_exit_lt_scale
		if self.d_emer_exit_lt:ChangedUpdate() then
			uluaSet(_G.idr_rfa107_mf_output_emer_exit_lt, val)
		end
	else
		uluaSet(_G.idr_rfa107_mf_output_emer_exit_lt, val)
	end
end

function RfA107:FreshEmerExitLt()
	self.d_emer_exit_lt:Invalid(-1)
end

-- ========
-- output A107 BACKLIGHT (output/51/state)

-- Channel state 0–255 ↔ kSetPin (0=LOW, 255=HIGH, 1–254=PWM)

function RfA107:GetA107Backlight(dpath, scale)
	self.d_a107_backlight_scale = scale == nil and 255 or scale
	self.d_a107_backlight = iDataRef:New(dpath)
end

function RfA107:SetA107Backlight(val)
	if val == nil then
		val = self.d_a107_backlight:Get() * self.d_a107_backlight_scale
		if self.d_a107_backlight:ChangedUpdate() then
			uluaSet(_G.idr_rfa107_mf_output_a107_backlight, val)
		end
	else
		uluaSet(_G.idr_rfa107_mf_output_a107_backlight, val)
	end
end

function RfA107:FreshA107Backlight()
	self.d_a107_backlight:Invalid(-1)
end

return RfA107
