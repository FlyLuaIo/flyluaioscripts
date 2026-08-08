-- *****************************************************************
-- Don't modify this file, unless you know what you are doing
-- Most of the code are auto generated
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-08-08
-- source: mobiflight/KayeRoof.json
-- *****************************************************************

local KayeRoof = oop.class(com.sim.mf.MobiFlight)
function KayeRoof:init()
	-- MF bridge assigns qmdev_id at connect (see log). Fallback: ProductName + ModuleSerial from JSON.
	self.QmdevId = 0x242B0D94
	self.FastTurnsPerSecond = 5
	if _G.ilua_hw_assigned_kayeroof == nil then
		_G.ilua_hw_assigned_kayeroof = 0
	end
end

function KayeRoof:absent(FastTurnsPerSecond)
	if not uluaFind('cpuwolf/flyluaio/KayeRoof/keysmap[0]') then
		return true
	end
	_G.idr_kayeroof_hid_invalid = uluaFind('cpuwolf/flyluaio/KayeRoof/invalid')
	_G.idr_kayeroof_hid_fastkeypersec = uluaFind('cpuwolf/flyluaio/KayeRoof/fastkeypersec')
	_G.idr_kayeroof_mf_output_fire_l = uluaFind('cpuwolf/mf/KayeRoof/output/0/state')
	_G.idr_kayeroof_mf_output_anti_ice_eng2_up = uluaFind('cpuwolf/mf/KayeRoof/output/1/state')
	_G.idr_kayeroof_mf_output_anti_ice_eng1_down = uluaFind('cpuwolf/mf/KayeRoof/output/2/state')
	_G.idr_kayeroof_mf_output_anti_ice_eng2_down = uluaFind('cpuwolf/mf/KayeRoof/output/3/state')
	_G.idr_kayeroof_mf_output_anti_ice_wing_down = uluaFind('cpuwolf/mf/KayeRoof/output/4/state')
	_G.idr_kayeroof_mf_output_apu_bleed_down = uluaFind('cpuwolf/mf/KayeRoof/output/5/state')
	_G.idr_kayeroof_mf_output_ext_pwr_down = uluaFind('cpuwolf/mf/KayeRoof/output/6/state')
	_G.idr_kayeroof_mf_output_elec_pump_down = uluaFind('cpuwolf/mf/KayeRoof/output/7/state')
	_G.idr_kayeroof_mf_output_fire_c = uluaFind('cpuwolf/mf/KayeRoof/output/8/state')
	_G.idr_kayeroof_mf_output_bat1_down = uluaFind('cpuwolf/mf/KayeRoof/output/9/state')
	_G.idr_kayeroof_mf_output_bat2_up = uluaFind('cpuwolf/mf/KayeRoof/output/10/state')
	_G.idr_kayeroof_mf_output_bat2_down = uluaFind('cpuwolf/mf/KayeRoof/output/11/state')
	_G.idr_kayeroof_mf_output_fire_r = uluaFind('cpuwolf/mf/KayeRoof/output/12/state')
	_G.idr_kayeroof_mf_output_ir1_lower = uluaFind('cpuwolf/mf/KayeRoof/output/13/state')
	_G.idr_kayeroof_mf_output_ir1_up = uluaFind('cpuwolf/mf/KayeRoof/output/14/state')
	_G.idr_kayeroof_mf_output_ir2_lower = uluaFind('cpuwolf/mf/KayeRoof/output/15/state')
	_G.idr_kayeroof_mf_output_ir3_lower = uluaFind('cpuwolf/mf/KayeRoof/output/16/state')
	_G.idr_kayeroof_mf_output_ext_pwr_up = uluaFind('cpuwolf/mf/KayeRoof/output/17/state')
	_G.idr_kayeroof_mf_output_anti_ice_wing_up = uluaFind('cpuwolf/mf/KayeRoof/output/18/state')
	_G.idr_kayeroof_mf_output_apu_bleed_up = uluaFind('cpuwolf/mf/KayeRoof/output/19/state')
	_G.idr_kayeroof_mf_output_elec_pump_up = uluaFind('cpuwolf/mf/KayeRoof/output/20/state')
	_G.idr_kayeroof_mf_output_anti_ice_eng1_up = uluaFind('cpuwolf/mf/KayeRoof/output/21/state')
	_G.idr_kayeroof_mf_output_crew_supply = uluaFind('cpuwolf/mf/KayeRoof/output/22/state')
	_G.idr_kayeroof_mf_output_gnd_ctl = uluaFind('cpuwolf/mf/KayeRoof/output/23/state')
	_G.idr_kayeroof_mf_output_bat1_up = uluaFind('cpuwolf/mf/KayeRoof/output/24/state')
	_G.idr_kayeroof_mf_output_ltk_pumps_1_up = uluaFind('cpuwolf/mf/KayeRoof/output/25/state')
	_G.idr_kayeroof_mf_output_ltk_pumps_2_down = uluaFind('cpuwolf/mf/KayeRoof/output/26/state')
	_G.idr_kayeroof_mf_output_ir3_up = uluaFind('cpuwolf/mf/KayeRoof/output/27/state')
	_G.idr_kayeroof_mf_output_ir2_up = uluaFind('cpuwolf/mf/KayeRoof/output/28/state')
	_G.idr_kayeroof_mf_output_rtk_pumps_1_up = uluaFind('cpuwolf/mf/KayeRoof/output/29/state')
	_G.idr_kayeroof_mf_output_ltk_pumps_1_down = uluaFind('cpuwolf/mf/KayeRoof/output/30/state')
	_G.idr_kayeroof_mf_output_ltk_pumps_2_up = uluaFind('cpuwolf/mf/KayeRoof/output/31/state')
	_G.idr_kayeroof_mf_output_pump_1_up = uluaFind('cpuwolf/mf/KayeRoof/output/32/state')
	_G.idr_kayeroof_mf_output_mode_sel_down = uluaFind('cpuwolf/mf/KayeRoof/output/33/state')
	_G.idr_kayeroof_mf_output_pump_2_down = uluaFind('cpuwolf/mf/KayeRoof/output/34/state')
	_G.idr_kayeroof_mf_output_pump_1_down = uluaFind('cpuwolf/mf/KayeRoof/output/35/state')
	_G.idr_kayeroof_mf_output_start_down = uluaFind('cpuwolf/mf/KayeRoof/output/36/state')
	_G.idr_kayeroof_mf_output_pump_2_up = uluaFind('cpuwolf/mf/KayeRoof/output/37/state')
	_G.idr_kayeroof_mf_output_mode_sel_up = uluaFind('cpuwolf/mf/KayeRoof/output/38/state')
	_G.idr_kayeroof_mf_output_rtk_pumps_2_down = uluaFind('cpuwolf/mf/KayeRoof/output/39/state')
	_G.idr_kayeroof_mf_output_rtk_pumps_1_down = uluaFind('cpuwolf/mf/KayeRoof/output/40/state')
	_G.idr_kayeroof_mf_output_rtk_pumps_2_up = uluaFind('cpuwolf/mf/KayeRoof/output/41/state')
	_G.idr_kayeroof_mf_output_x_feed_up = uluaFind('cpuwolf/mf/KayeRoof/output/42/state')
	_G.idr_kayeroof_mf_output_x_feed_down = uluaFind('cpuwolf/mf/KayeRoof/output/43/state')
	_G.idr_kayeroof_mf_output_master_sw_up = uluaFind('cpuwolf/mf/KayeRoof/output/44/state')
	_G.idr_kayeroof_mf_output_master_sw_down = uluaFind('cpuwolf/mf/KayeRoof/output/45/state')
	_G.idr_kayeroof_mf_output_start_up = uluaFind('cpuwolf/mf/KayeRoof/output/46/state')
	_G.idr_kayeroof_mf_output_bat1v = uluaFind('cpuwolf/mf/KayeRoof/output/47/state')
	_G.idr_kayeroof_mf_output_bat2v = uluaFind('cpuwolf/mf/KayeRoof/output/48/state')
	_G.idr_kayeroof_mf_output_backlight = uluaFind('cpuwolf/mf/KayeRoof/output/49/state')
	uluaSet(_G.idr_kayeroof_hid_fastkeypersec, FastTurnsPerSecond)

	return false
end

function KayeRoof:Init(FastTurnsPerSecond)
	local ftps = FastTurnsPerSecond == nil and self.FastTurnsPerSecond or FastTurnsPerSecond
	if self:absent(ftps) then
		return false
	end
	if _G.ilua_hw_assigned_kayeroof == 1 then
		return false
	end
	_G.ilua_hw_assigned_kayeroof = 1
	return true
end

function KayeRoof.Open(...)
	return com.sim.Qmdev.Open(KayeRoof, ...)
end

-- ========
-- output FIRE L (output/0/state)

-- Channel state is 0/1 (bitLength=1 in mfcfg)

function KayeRoof:GetFireL(dpath, scale)
	self.d_fire_l_scale = scale == nil and 1 or scale
	self.d_fire_l = iDataRef:New(dpath)
end

function KayeRoof:SetFireL(val)
	if val == nil then
		val = self.d_fire_l:Get() * self.d_fire_l_scale
		if self.d_fire_l:ChangedUpdate() then
			uluaSet(_G.idr_kayeroof_mf_output_fire_l, val)
		end
	else
		uluaSet(_G.idr_kayeroof_mf_output_fire_l, val)
	end
end

function KayeRoof:FreshFireL()
	self.d_fire_l:Invalid(-1)
end

-- ========
-- output ANTI_ICE_ENG2_UP (output/1/state)

-- Channel state is 0/1 (bitLength=1 in mfcfg)

function KayeRoof:GetAntiIceEng2Up(dpath, scale)
	self.d_anti_ice_eng2_up_scale = scale == nil and 1 or scale
	self.d_anti_ice_eng2_up = iDataRef:New(dpath)
end

function KayeRoof:SetAntiIceEng2Up(val)
	if val == nil then
		val = self.d_anti_ice_eng2_up:Get() * self.d_anti_ice_eng2_up_scale
		if self.d_anti_ice_eng2_up:ChangedUpdate() then
			uluaSet(_G.idr_kayeroof_mf_output_anti_ice_eng2_up, val)
		end
	else
		uluaSet(_G.idr_kayeroof_mf_output_anti_ice_eng2_up, val)
	end
end

function KayeRoof:FreshAntiIceEng2Up()
	self.d_anti_ice_eng2_up:Invalid(-1)
end

-- ========
-- output ANTI_ICE_ENG1_DOWN (output/2/state)

-- Channel state is 0/1 (bitLength=1 in mfcfg)

function KayeRoof:GetAntiIceEng1Down(dpath, scale)
	self.d_anti_ice_eng1_down_scale = scale == nil and 1 or scale
	self.d_anti_ice_eng1_down = iDataRef:New(dpath)
end

function KayeRoof:SetAntiIceEng1Down(val)
	if val == nil then
		val = self.d_anti_ice_eng1_down:Get() * self.d_anti_ice_eng1_down_scale
		if self.d_anti_ice_eng1_down:ChangedUpdate() then
			uluaSet(_G.idr_kayeroof_mf_output_anti_ice_eng1_down, val)
		end
	else
		uluaSet(_G.idr_kayeroof_mf_output_anti_ice_eng1_down, val)
	end
end

function KayeRoof:FreshAntiIceEng1Down()
	self.d_anti_ice_eng1_down:Invalid(-1)
end

-- ========
-- output ANTI_ICE_ENG2_DOWN (output/3/state)

-- Channel state is 0/1 (bitLength=1 in mfcfg)

function KayeRoof:GetAntiIceEng2Down(dpath, scale)
	self.d_anti_ice_eng2_down_scale = scale == nil and 1 or scale
	self.d_anti_ice_eng2_down = iDataRef:New(dpath)
end

function KayeRoof:SetAntiIceEng2Down(val)
	if val == nil then
		val = self.d_anti_ice_eng2_down:Get() * self.d_anti_ice_eng2_down_scale
		if self.d_anti_ice_eng2_down:ChangedUpdate() then
			uluaSet(_G.idr_kayeroof_mf_output_anti_ice_eng2_down, val)
		end
	else
		uluaSet(_G.idr_kayeroof_mf_output_anti_ice_eng2_down, val)
	end
end

function KayeRoof:FreshAntiIceEng2Down()
	self.d_anti_ice_eng2_down:Invalid(-1)
end

-- ========
-- output ANTI_ICE_WING_DOWN (output/4/state)

-- Channel state is 0/1 (bitLength=1 in mfcfg)

function KayeRoof:GetAntiIceWingDown(dpath, scale)
	self.d_anti_ice_wing_down_scale = scale == nil and 1 or scale
	self.d_anti_ice_wing_down = iDataRef:New(dpath)
end

function KayeRoof:SetAntiIceWingDown(val)
	if val == nil then
		val = self.d_anti_ice_wing_down:Get() * self.d_anti_ice_wing_down_scale
		if self.d_anti_ice_wing_down:ChangedUpdate() then
			uluaSet(_G.idr_kayeroof_mf_output_anti_ice_wing_down, val)
		end
	else
		uluaSet(_G.idr_kayeroof_mf_output_anti_ice_wing_down, val)
	end
end

function KayeRoof:FreshAntiIceWingDown()
	self.d_anti_ice_wing_down:Invalid(-1)
end

-- ========
-- output APU BLEED DOWN (output/5/state)

-- Channel state is 0/1 (bitLength=1 in mfcfg)

function KayeRoof:GetApuBleedDown(dpath, scale)
	self.d_apu_bleed_down_scale = scale == nil and 1 or scale
	self.d_apu_bleed_down = iDataRef:New(dpath)
end

function KayeRoof:SetApuBleedDown(val)
	if val == nil then
		val = self.d_apu_bleed_down:Get() * self.d_apu_bleed_down_scale
		if self.d_apu_bleed_down:ChangedUpdate() then
			uluaSet(_G.idr_kayeroof_mf_output_apu_bleed_down, val)
		end
	else
		uluaSet(_G.idr_kayeroof_mf_output_apu_bleed_down, val)
	end
end

function KayeRoof:FreshApuBleedDown()
	self.d_apu_bleed_down:Invalid(-1)
end

-- ========
-- output EXT PWR DOWN (output/6/state)

-- Channel state is 0/1 (bitLength=1 in mfcfg)

function KayeRoof:GetExtPwrDown(dpath, scale)
	self.d_ext_pwr_down_scale = scale == nil and 1 or scale
	self.d_ext_pwr_down = iDataRef:New(dpath)
end

function KayeRoof:SetExtPwrDown(val)
	if val == nil then
		val = self.d_ext_pwr_down:Get() * self.d_ext_pwr_down_scale
		if self.d_ext_pwr_down:ChangedUpdate() then
			uluaSet(_G.idr_kayeroof_mf_output_ext_pwr_down, val)
		end
	else
		uluaSet(_G.idr_kayeroof_mf_output_ext_pwr_down, val)
	end
end

function KayeRoof:FreshExtPwrDown()
	self.d_ext_pwr_down:Invalid(-1)
end

-- ========
-- output ELEC PUMP DOWN (output/7/state)

-- Channel state is 0/1 (bitLength=1 in mfcfg)

function KayeRoof:GetElecPumpDown(dpath, scale)
	self.d_elec_pump_down_scale = scale == nil and 1 or scale
	self.d_elec_pump_down = iDataRef:New(dpath)
end

function KayeRoof:SetElecPumpDown(val)
	if val == nil then
		val = self.d_elec_pump_down:Get() * self.d_elec_pump_down_scale
		if self.d_elec_pump_down:ChangedUpdate() then
			uluaSet(_G.idr_kayeroof_mf_output_elec_pump_down, val)
		end
	else
		uluaSet(_G.idr_kayeroof_mf_output_elec_pump_down, val)
	end
end

function KayeRoof:FreshElecPumpDown()
	self.d_elec_pump_down:Invalid(-1)
end

-- ========
-- output FIRE C (output/8/state)

-- Channel state is 0/1 (bitLength=1 in mfcfg)

function KayeRoof:GetFireC(dpath, scale)
	self.d_fire_c_scale = scale == nil and 1 or scale
	self.d_fire_c = iDataRef:New(dpath)
end

function KayeRoof:SetFireC(val)
	if val == nil then
		val = self.d_fire_c:Get() * self.d_fire_c_scale
		if self.d_fire_c:ChangedUpdate() then
			uluaSet(_G.idr_kayeroof_mf_output_fire_c, val)
		end
	else
		uluaSet(_G.idr_kayeroof_mf_output_fire_c, val)
	end
end

function KayeRoof:FreshFireC()
	self.d_fire_c:Invalid(-1)
end

-- ========
-- output BAT1_DOWN (output/9/state)

-- Channel state is 0/1 (bitLength=1 in mfcfg)

function KayeRoof:GetBat1Down(dpath, scale)
	self.d_bat1_down_scale = scale == nil and 1 or scale
	self.d_bat1_down = iDataRef:New(dpath)
end

function KayeRoof:SetBat1Down(val)
	if val == nil then
		val = self.d_bat1_down:Get() * self.d_bat1_down_scale
		if self.d_bat1_down:ChangedUpdate() then
			uluaSet(_G.idr_kayeroof_mf_output_bat1_down, val)
		end
	else
		uluaSet(_G.idr_kayeroof_mf_output_bat1_down, val)
	end
end

function KayeRoof:FreshBat1Down()
	self.d_bat1_down:Invalid(-1)
end

-- ========
-- output BAT2_UP (output/10/state)

-- Channel state is 0/1 (bitLength=1 in mfcfg)

function KayeRoof:GetBat2Up(dpath, scale)
	self.d_bat2_up_scale = scale == nil and 1 or scale
	self.d_bat2_up = iDataRef:New(dpath)
end

function KayeRoof:SetBat2Up(val)
	if val == nil then
		val = self.d_bat2_up:Get() * self.d_bat2_up_scale
		if self.d_bat2_up:ChangedUpdate() then
			uluaSet(_G.idr_kayeroof_mf_output_bat2_up, val)
		end
	else
		uluaSet(_G.idr_kayeroof_mf_output_bat2_up, val)
	end
end

function KayeRoof:FreshBat2Up()
	self.d_bat2_up:Invalid(-1)
end

-- ========
-- output BAT2_DOWN (output/11/state)

-- Channel state is 0/1 (bitLength=1 in mfcfg)

function KayeRoof:GetBat2Down(dpath, scale)
	self.d_bat2_down_scale = scale == nil and 1 or scale
	self.d_bat2_down = iDataRef:New(dpath)
end

function KayeRoof:SetBat2Down(val)
	if val == nil then
		val = self.d_bat2_down:Get() * self.d_bat2_down_scale
		if self.d_bat2_down:ChangedUpdate() then
			uluaSet(_G.idr_kayeroof_mf_output_bat2_down, val)
		end
	else
		uluaSet(_G.idr_kayeroof_mf_output_bat2_down, val)
	end
end

function KayeRoof:FreshBat2Down()
	self.d_bat2_down:Invalid(-1)
end

-- ========
-- output FIRE R (output/12/state)

-- Channel state is 0/1 (bitLength=1 in mfcfg)

function KayeRoof:GetFireR(dpath, scale)
	self.d_fire_r_scale = scale == nil and 1 or scale
	self.d_fire_r = iDataRef:New(dpath)
end

function KayeRoof:SetFireR(val)
	if val == nil then
		val = self.d_fire_r:Get() * self.d_fire_r_scale
		if self.d_fire_r:ChangedUpdate() then
			uluaSet(_G.idr_kayeroof_mf_output_fire_r, val)
		end
	else
		uluaSet(_G.idr_kayeroof_mf_output_fire_r, val)
	end
end

function KayeRoof:FreshFireR()
	self.d_fire_r:Invalid(-1)
end

-- ========
-- output IR1_LOWER (output/13/state)

-- Channel state is 0/1 (bitLength=1 in mfcfg)

function KayeRoof:GetIr1Lower(dpath, scale)
	self.d_ir1_lower_scale = scale == nil and 1 or scale
	self.d_ir1_lower = iDataRef:New(dpath)
end

function KayeRoof:SetIr1Lower(val)
	if val == nil then
		val = self.d_ir1_lower:Get() * self.d_ir1_lower_scale
		if self.d_ir1_lower:ChangedUpdate() then
			uluaSet(_G.idr_kayeroof_mf_output_ir1_lower, val)
		end
	else
		uluaSet(_G.idr_kayeroof_mf_output_ir1_lower, val)
	end
end

function KayeRoof:FreshIr1Lower()
	self.d_ir1_lower:Invalid(-1)
end

-- ========
-- output IR1_UP (output/14/state)

-- Channel state is 0/1 (bitLength=1 in mfcfg)

function KayeRoof:GetIr1Up(dpath, scale)
	self.d_ir1_up_scale = scale == nil and 1 or scale
	self.d_ir1_up = iDataRef:New(dpath)
end

function KayeRoof:SetIr1Up(val)
	if val == nil then
		val = self.d_ir1_up:Get() * self.d_ir1_up_scale
		if self.d_ir1_up:ChangedUpdate() then
			uluaSet(_G.idr_kayeroof_mf_output_ir1_up, val)
		end
	else
		uluaSet(_G.idr_kayeroof_mf_output_ir1_up, val)
	end
end

function KayeRoof:FreshIr1Up()
	self.d_ir1_up:Invalid(-1)
end

-- ========
-- output IR2_LOWER (output/15/state)

-- Channel state is 0/1 (bitLength=1 in mfcfg)

function KayeRoof:GetIr2Lower(dpath, scale)
	self.d_ir2_lower_scale = scale == nil and 1 or scale
	self.d_ir2_lower = iDataRef:New(dpath)
end

function KayeRoof:SetIr2Lower(val)
	if val == nil then
		val = self.d_ir2_lower:Get() * self.d_ir2_lower_scale
		if self.d_ir2_lower:ChangedUpdate() then
			uluaSet(_G.idr_kayeroof_mf_output_ir2_lower, val)
		end
	else
		uluaSet(_G.idr_kayeroof_mf_output_ir2_lower, val)
	end
end

function KayeRoof:FreshIr2Lower()
	self.d_ir2_lower:Invalid(-1)
end

-- ========
-- output IR3_LOWER (output/16/state)

-- Channel state is 0/1 (bitLength=1 in mfcfg)

function KayeRoof:GetIr3Lower(dpath, scale)
	self.d_ir3_lower_scale = scale == nil and 1 or scale
	self.d_ir3_lower = iDataRef:New(dpath)
end

function KayeRoof:SetIr3Lower(val)
	if val == nil then
		val = self.d_ir3_lower:Get() * self.d_ir3_lower_scale
		if self.d_ir3_lower:ChangedUpdate() then
			uluaSet(_G.idr_kayeroof_mf_output_ir3_lower, val)
		end
	else
		uluaSet(_G.idr_kayeroof_mf_output_ir3_lower, val)
	end
end

function KayeRoof:FreshIr3Lower()
	self.d_ir3_lower:Invalid(-1)
end

-- ========
-- output EXT PWR UP (output/17/state)

-- Channel state is 0/1 (bitLength=1 in mfcfg)

function KayeRoof:GetExtPwrUp(dpath, scale)
	self.d_ext_pwr_up_scale = scale == nil and 1 or scale
	self.d_ext_pwr_up = iDataRef:New(dpath)
end

function KayeRoof:SetExtPwrUp(val)
	if val == nil then
		val = self.d_ext_pwr_up:Get() * self.d_ext_pwr_up_scale
		if self.d_ext_pwr_up:ChangedUpdate() then
			uluaSet(_G.idr_kayeroof_mf_output_ext_pwr_up, val)
		end
	else
		uluaSet(_G.idr_kayeroof_mf_output_ext_pwr_up, val)
	end
end

function KayeRoof:FreshExtPwrUp()
	self.d_ext_pwr_up:Invalid(-1)
end

-- ========
-- output ANTI_ICE_WING_UP (output/18/state)

-- Channel state is 0/1 (bitLength=1 in mfcfg)

function KayeRoof:GetAntiIceWingUp(dpath, scale)
	self.d_anti_ice_wing_up_scale = scale == nil and 1 or scale
	self.d_anti_ice_wing_up = iDataRef:New(dpath)
end

function KayeRoof:SetAntiIceWingUp(val)
	if val == nil then
		val = self.d_anti_ice_wing_up:Get() * self.d_anti_ice_wing_up_scale
		if self.d_anti_ice_wing_up:ChangedUpdate() then
			uluaSet(_G.idr_kayeroof_mf_output_anti_ice_wing_up, val)
		end
	else
		uluaSet(_G.idr_kayeroof_mf_output_anti_ice_wing_up, val)
	end
end

function KayeRoof:FreshAntiIceWingUp()
	self.d_anti_ice_wing_up:Invalid(-1)
end

-- ========
-- output APU BLEED UP (output/19/state)

-- Channel state is 0/1 (bitLength=1 in mfcfg)

function KayeRoof:GetApuBleedUp(dpath, scale)
	self.d_apu_bleed_up_scale = scale == nil and 1 or scale
	self.d_apu_bleed_up = iDataRef:New(dpath)
end

function KayeRoof:SetApuBleedUp(val)
	if val == nil then
		val = self.d_apu_bleed_up:Get() * self.d_apu_bleed_up_scale
		if self.d_apu_bleed_up:ChangedUpdate() then
			uluaSet(_G.idr_kayeroof_mf_output_apu_bleed_up, val)
		end
	else
		uluaSet(_G.idr_kayeroof_mf_output_apu_bleed_up, val)
	end
end

function KayeRoof:FreshApuBleedUp()
	self.d_apu_bleed_up:Invalid(-1)
end

-- ========
-- output ELEC PUMP UP (output/20/state)

-- Channel state is 0/1 (bitLength=1 in mfcfg)

function KayeRoof:GetElecPumpUp(dpath, scale)
	self.d_elec_pump_up_scale = scale == nil and 1 or scale
	self.d_elec_pump_up = iDataRef:New(dpath)
end

function KayeRoof:SetElecPumpUp(val)
	if val == nil then
		val = self.d_elec_pump_up:Get() * self.d_elec_pump_up_scale
		if self.d_elec_pump_up:ChangedUpdate() then
			uluaSet(_G.idr_kayeroof_mf_output_elec_pump_up, val)
		end
	else
		uluaSet(_G.idr_kayeroof_mf_output_elec_pump_up, val)
	end
end

function KayeRoof:FreshElecPumpUp()
	self.d_elec_pump_up:Invalid(-1)
end

-- ========
-- output ANTI_ICE_ENG1_UP (output/21/state)

-- Channel state is 0/1 (bitLength=1 in mfcfg)

function KayeRoof:GetAntiIceEng1Up(dpath, scale)
	self.d_anti_ice_eng1_up_scale = scale == nil and 1 or scale
	self.d_anti_ice_eng1_up = iDataRef:New(dpath)
end

function KayeRoof:SetAntiIceEng1Up(val)
	if val == nil then
		val = self.d_anti_ice_eng1_up:Get() * self.d_anti_ice_eng1_up_scale
		if self.d_anti_ice_eng1_up:ChangedUpdate() then
			uluaSet(_G.idr_kayeroof_mf_output_anti_ice_eng1_up, val)
		end
	else
		uluaSet(_G.idr_kayeroof_mf_output_anti_ice_eng1_up, val)
	end
end

function KayeRoof:FreshAntiIceEng1Up()
	self.d_anti_ice_eng1_up:Invalid(-1)
end

-- ========
-- output CREW SUPPLY (output/22/state)

-- Channel state is 0/1 (bitLength=1 in mfcfg)

function KayeRoof:GetCrewSupply(dpath, scale)
	self.d_crew_supply_scale = scale == nil and 1 or scale
	self.d_crew_supply = iDataRef:New(dpath)
end

function KayeRoof:SetCrewSupply(val)
	if val == nil then
		val = self.d_crew_supply:Get() * self.d_crew_supply_scale
		if self.d_crew_supply:ChangedUpdate() then
			uluaSet(_G.idr_kayeroof_mf_output_crew_supply, val)
		end
	else
		uluaSet(_G.idr_kayeroof_mf_output_crew_supply, val)
	end
end

function KayeRoof:FreshCrewSupply()
	self.d_crew_supply:Invalid(-1)
end

-- ========
-- output GND CTL (output/23/state)

-- Channel state is 0/1 (bitLength=1 in mfcfg)

function KayeRoof:GetGndCtl(dpath, scale)
	self.d_gnd_ctl_scale = scale == nil and 1 or scale
	self.d_gnd_ctl = iDataRef:New(dpath)
end

function KayeRoof:SetGndCtl(val)
	if val == nil then
		val = self.d_gnd_ctl:Get() * self.d_gnd_ctl_scale
		if self.d_gnd_ctl:ChangedUpdate() then
			uluaSet(_G.idr_kayeroof_mf_output_gnd_ctl, val)
		end
	else
		uluaSet(_G.idr_kayeroof_mf_output_gnd_ctl, val)
	end
end

function KayeRoof:FreshGndCtl()
	self.d_gnd_ctl:Invalid(-1)
end

-- ========
-- output BAT1_UP (output/24/state)

-- Channel state is 0/1 (bitLength=1 in mfcfg)

function KayeRoof:GetBat1Up(dpath, scale)
	self.d_bat1_up_scale = scale == nil and 1 or scale
	self.d_bat1_up = iDataRef:New(dpath)
end

function KayeRoof:SetBat1Up(val)
	if val == nil then
		val = self.d_bat1_up:Get() * self.d_bat1_up_scale
		if self.d_bat1_up:ChangedUpdate() then
			uluaSet(_G.idr_kayeroof_mf_output_bat1_up, val)
		end
	else
		uluaSet(_G.idr_kayeroof_mf_output_bat1_up, val)
	end
end

function KayeRoof:FreshBat1Up()
	self.d_bat1_up:Invalid(-1)
end

-- ========
-- output LTK PUMPS_1_UP (output/25/state)

-- Channel state is 0/1 (bitLength=1 in mfcfg)

function KayeRoof:GetLtkPumps1Up(dpath, scale)
	self.d_ltk_pumps_1_up_scale = scale == nil and 1 or scale
	self.d_ltk_pumps_1_up = iDataRef:New(dpath)
end

function KayeRoof:SetLtkPumps1Up(val)
	if val == nil then
		val = self.d_ltk_pumps_1_up:Get() * self.d_ltk_pumps_1_up_scale
		if self.d_ltk_pumps_1_up:ChangedUpdate() then
			uluaSet(_G.idr_kayeroof_mf_output_ltk_pumps_1_up, val)
		end
	else
		uluaSet(_G.idr_kayeroof_mf_output_ltk_pumps_1_up, val)
	end
end

function KayeRoof:FreshLtkPumps1Up()
	self.d_ltk_pumps_1_up:Invalid(-1)
end

-- ========
-- output LTK PUMPS_2_DOWN (output/26/state)

-- Channel state is 0/1 (bitLength=1 in mfcfg)

function KayeRoof:GetLtkPumps2Down(dpath, scale)
	self.d_ltk_pumps_2_down_scale = scale == nil and 1 or scale
	self.d_ltk_pumps_2_down = iDataRef:New(dpath)
end

function KayeRoof:SetLtkPumps2Down(val)
	if val == nil then
		val = self.d_ltk_pumps_2_down:Get() * self.d_ltk_pumps_2_down_scale
		if self.d_ltk_pumps_2_down:ChangedUpdate() then
			uluaSet(_G.idr_kayeroof_mf_output_ltk_pumps_2_down, val)
		end
	else
		uluaSet(_G.idr_kayeroof_mf_output_ltk_pumps_2_down, val)
	end
end

function KayeRoof:FreshLtkPumps2Down()
	self.d_ltk_pumps_2_down:Invalid(-1)
end

-- ========
-- output IR3_UP (output/27/state)

-- Channel state is 0/1 (bitLength=1 in mfcfg)

function KayeRoof:GetIr3Up(dpath, scale)
	self.d_ir3_up_scale = scale == nil and 1 or scale
	self.d_ir3_up = iDataRef:New(dpath)
end

function KayeRoof:SetIr3Up(val)
	if val == nil then
		val = self.d_ir3_up:Get() * self.d_ir3_up_scale
		if self.d_ir3_up:ChangedUpdate() then
			uluaSet(_G.idr_kayeroof_mf_output_ir3_up, val)
		end
	else
		uluaSet(_G.idr_kayeroof_mf_output_ir3_up, val)
	end
end

function KayeRoof:FreshIr3Up()
	self.d_ir3_up:Invalid(-1)
end

-- ========
-- output IR2_UP (output/28/state)

-- Channel state is 0/1 (bitLength=1 in mfcfg)

function KayeRoof:GetIr2Up(dpath, scale)
	self.d_ir2_up_scale = scale == nil and 1 or scale
	self.d_ir2_up = iDataRef:New(dpath)
end

function KayeRoof:SetIr2Up(val)
	if val == nil then
		val = self.d_ir2_up:Get() * self.d_ir2_up_scale
		if self.d_ir2_up:ChangedUpdate() then
			uluaSet(_G.idr_kayeroof_mf_output_ir2_up, val)
		end
	else
		uluaSet(_G.idr_kayeroof_mf_output_ir2_up, val)
	end
end

function KayeRoof:FreshIr2Up()
	self.d_ir2_up:Invalid(-1)
end

-- ========
-- output RTK PUMPS_1_UP (output/29/state)

-- Channel state is 0/1 (bitLength=1 in mfcfg)

function KayeRoof:GetRtkPumps1Up(dpath, scale)
	self.d_rtk_pumps_1_up_scale = scale == nil and 1 or scale
	self.d_rtk_pumps_1_up = iDataRef:New(dpath)
end

function KayeRoof:SetRtkPumps1Up(val)
	if val == nil then
		val = self.d_rtk_pumps_1_up:Get() * self.d_rtk_pumps_1_up_scale
		if self.d_rtk_pumps_1_up:ChangedUpdate() then
			uluaSet(_G.idr_kayeroof_mf_output_rtk_pumps_1_up, val)
		end
	else
		uluaSet(_G.idr_kayeroof_mf_output_rtk_pumps_1_up, val)
	end
end

function KayeRoof:FreshRtkPumps1Up()
	self.d_rtk_pumps_1_up:Invalid(-1)
end

-- ========
-- output LTK PUMPS_1_DOWN (output/30/state)

-- Channel state is 0/1 (bitLength=1 in mfcfg)

function KayeRoof:GetLtkPumps1Down(dpath, scale)
	self.d_ltk_pumps_1_down_scale = scale == nil and 1 or scale
	self.d_ltk_pumps_1_down = iDataRef:New(dpath)
end

function KayeRoof:SetLtkPumps1Down(val)
	if val == nil then
		val = self.d_ltk_pumps_1_down:Get() * self.d_ltk_pumps_1_down_scale
		if self.d_ltk_pumps_1_down:ChangedUpdate() then
			uluaSet(_G.idr_kayeroof_mf_output_ltk_pumps_1_down, val)
		end
	else
		uluaSet(_G.idr_kayeroof_mf_output_ltk_pumps_1_down, val)
	end
end

function KayeRoof:FreshLtkPumps1Down()
	self.d_ltk_pumps_1_down:Invalid(-1)
end

-- ========
-- output LTK PUMPS_2_UP (output/31/state)

-- Channel state is 0/1 (bitLength=1 in mfcfg)

function KayeRoof:GetLtkPumps2Up(dpath, scale)
	self.d_ltk_pumps_2_up_scale = scale == nil and 1 or scale
	self.d_ltk_pumps_2_up = iDataRef:New(dpath)
end

function KayeRoof:SetLtkPumps2Up(val)
	if val == nil then
		val = self.d_ltk_pumps_2_up:Get() * self.d_ltk_pumps_2_up_scale
		if self.d_ltk_pumps_2_up:ChangedUpdate() then
			uluaSet(_G.idr_kayeroof_mf_output_ltk_pumps_2_up, val)
		end
	else
		uluaSet(_G.idr_kayeroof_mf_output_ltk_pumps_2_up, val)
	end
end

function KayeRoof:FreshLtkPumps2Up()
	self.d_ltk_pumps_2_up:Invalid(-1)
end

-- ========
-- output PUMP 1_UP (output/32/state)

-- Channel state is 0/1 (bitLength=1 in mfcfg)

function KayeRoof:GetPump1Up(dpath, scale)
	self.d_pump_1_up_scale = scale == nil and 1 or scale
	self.d_pump_1_up = iDataRef:New(dpath)
end

function KayeRoof:SetPump1Up(val)
	if val == nil then
		val = self.d_pump_1_up:Get() * self.d_pump_1_up_scale
		if self.d_pump_1_up:ChangedUpdate() then
			uluaSet(_G.idr_kayeroof_mf_output_pump_1_up, val)
		end
	else
		uluaSet(_G.idr_kayeroof_mf_output_pump_1_up, val)
	end
end

function KayeRoof:FreshPump1Up()
	self.d_pump_1_up:Invalid(-1)
end

-- ========
-- output MODE SEL_DOWN (output/33/state)

-- Channel state is 0/1 (bitLength=1 in mfcfg)

function KayeRoof:GetModeSelDown(dpath, scale)
	self.d_mode_sel_down_scale = scale == nil and 1 or scale
	self.d_mode_sel_down = iDataRef:New(dpath)
end

function KayeRoof:SetModeSelDown(val)
	if val == nil then
		val = self.d_mode_sel_down:Get() * self.d_mode_sel_down_scale
		if self.d_mode_sel_down:ChangedUpdate() then
			uluaSet(_G.idr_kayeroof_mf_output_mode_sel_down, val)
		end
	else
		uluaSet(_G.idr_kayeroof_mf_output_mode_sel_down, val)
	end
end

function KayeRoof:FreshModeSelDown()
	self.d_mode_sel_down:Invalid(-1)
end

-- ========
-- output PUMP 2_DOWN (output/34/state)

-- Channel state is 0/1 (bitLength=1 in mfcfg)

function KayeRoof:GetPump2Down(dpath, scale)
	self.d_pump_2_down_scale = scale == nil and 1 or scale
	self.d_pump_2_down = iDataRef:New(dpath)
end

function KayeRoof:SetPump2Down(val)
	if val == nil then
		val = self.d_pump_2_down:Get() * self.d_pump_2_down_scale
		if self.d_pump_2_down:ChangedUpdate() then
			uluaSet(_G.idr_kayeroof_mf_output_pump_2_down, val)
		end
	else
		uluaSet(_G.idr_kayeroof_mf_output_pump_2_down, val)
	end
end

function KayeRoof:FreshPump2Down()
	self.d_pump_2_down:Invalid(-1)
end

-- ========
-- output PUMP 1_DOWN (output/35/state)

-- Channel state is 0/1 (bitLength=1 in mfcfg)

function KayeRoof:GetPump1Down(dpath, scale)
	self.d_pump_1_down_scale = scale == nil and 1 or scale
	self.d_pump_1_down = iDataRef:New(dpath)
end

function KayeRoof:SetPump1Down(val)
	if val == nil then
		val = self.d_pump_1_down:Get() * self.d_pump_1_down_scale
		if self.d_pump_1_down:ChangedUpdate() then
			uluaSet(_G.idr_kayeroof_mf_output_pump_1_down, val)
		end
	else
		uluaSet(_G.idr_kayeroof_mf_output_pump_1_down, val)
	end
end

function KayeRoof:FreshPump1Down()
	self.d_pump_1_down:Invalid(-1)
end

-- ========
-- output START_DOWN (output/36/state)

-- Channel state is 0/1 (bitLength=1 in mfcfg)

function KayeRoof:GetStartDown(dpath, scale)
	self.d_start_down_scale = scale == nil and 1 or scale
	self.d_start_down = iDataRef:New(dpath)
end

function KayeRoof:SetStartDown(val)
	if val == nil then
		val = self.d_start_down:Get() * self.d_start_down_scale
		if self.d_start_down:ChangedUpdate() then
			uluaSet(_G.idr_kayeroof_mf_output_start_down, val)
		end
	else
		uluaSet(_G.idr_kayeroof_mf_output_start_down, val)
	end
end

function KayeRoof:FreshStartDown()
	self.d_start_down:Invalid(-1)
end

-- ========
-- output PUMP 2_UP (output/37/state)

-- Channel state is 0/1 (bitLength=1 in mfcfg)

function KayeRoof:GetPump2Up(dpath, scale)
	self.d_pump_2_up_scale = scale == nil and 1 or scale
	self.d_pump_2_up = iDataRef:New(dpath)
end

function KayeRoof:SetPump2Up(val)
	if val == nil then
		val = self.d_pump_2_up:Get() * self.d_pump_2_up_scale
		if self.d_pump_2_up:ChangedUpdate() then
			uluaSet(_G.idr_kayeroof_mf_output_pump_2_up, val)
		end
	else
		uluaSet(_G.idr_kayeroof_mf_output_pump_2_up, val)
	end
end

function KayeRoof:FreshPump2Up()
	self.d_pump_2_up:Invalid(-1)
end

-- ========
-- output MODE SEL_UP (output/38/state)

-- Channel state is 0/1 (bitLength=1 in mfcfg)

function KayeRoof:GetModeSelUp(dpath, scale)
	self.d_mode_sel_up_scale = scale == nil and 1 or scale
	self.d_mode_sel_up = iDataRef:New(dpath)
end

function KayeRoof:SetModeSelUp(val)
	if val == nil then
		val = self.d_mode_sel_up:Get() * self.d_mode_sel_up_scale
		if self.d_mode_sel_up:ChangedUpdate() then
			uluaSet(_G.idr_kayeroof_mf_output_mode_sel_up, val)
		end
	else
		uluaSet(_G.idr_kayeroof_mf_output_mode_sel_up, val)
	end
end

function KayeRoof:FreshModeSelUp()
	self.d_mode_sel_up:Invalid(-1)
end

-- ========
-- output RTK PUMPS_2_DOWN (output/39/state)

-- Channel state is 0/1 (bitLength=1 in mfcfg)

function KayeRoof:GetRtkPumps2Down(dpath, scale)
	self.d_rtk_pumps_2_down_scale = scale == nil and 1 or scale
	self.d_rtk_pumps_2_down = iDataRef:New(dpath)
end

function KayeRoof:SetRtkPumps2Down(val)
	if val == nil then
		val = self.d_rtk_pumps_2_down:Get() * self.d_rtk_pumps_2_down_scale
		if self.d_rtk_pumps_2_down:ChangedUpdate() then
			uluaSet(_G.idr_kayeroof_mf_output_rtk_pumps_2_down, val)
		end
	else
		uluaSet(_G.idr_kayeroof_mf_output_rtk_pumps_2_down, val)
	end
end

function KayeRoof:FreshRtkPumps2Down()
	self.d_rtk_pumps_2_down:Invalid(-1)
end

-- ========
-- output RTK PUMPS_1_DOWN (output/40/state)

-- Channel state is 0/1 (bitLength=1 in mfcfg)

function KayeRoof:GetRtkPumps1Down(dpath, scale)
	self.d_rtk_pumps_1_down_scale = scale == nil and 1 or scale
	self.d_rtk_pumps_1_down = iDataRef:New(dpath)
end

function KayeRoof:SetRtkPumps1Down(val)
	if val == nil then
		val = self.d_rtk_pumps_1_down:Get() * self.d_rtk_pumps_1_down_scale
		if self.d_rtk_pumps_1_down:ChangedUpdate() then
			uluaSet(_G.idr_kayeroof_mf_output_rtk_pumps_1_down, val)
		end
	else
		uluaSet(_G.idr_kayeroof_mf_output_rtk_pumps_1_down, val)
	end
end

function KayeRoof:FreshRtkPumps1Down()
	self.d_rtk_pumps_1_down:Invalid(-1)
end

-- ========
-- output RTK PUMPS_2_UP (output/41/state)

-- Channel state is 0/1 (bitLength=1 in mfcfg)

function KayeRoof:GetRtkPumps2Up(dpath, scale)
	self.d_rtk_pumps_2_up_scale = scale == nil and 1 or scale
	self.d_rtk_pumps_2_up = iDataRef:New(dpath)
end

function KayeRoof:SetRtkPumps2Up(val)
	if val == nil then
		val = self.d_rtk_pumps_2_up:Get() * self.d_rtk_pumps_2_up_scale
		if self.d_rtk_pumps_2_up:ChangedUpdate() then
			uluaSet(_G.idr_kayeroof_mf_output_rtk_pumps_2_up, val)
		end
	else
		uluaSet(_G.idr_kayeroof_mf_output_rtk_pumps_2_up, val)
	end
end

function KayeRoof:FreshRtkPumps2Up()
	self.d_rtk_pumps_2_up:Invalid(-1)
end

-- ========
-- output X FEED_UP (output/42/state)

-- Channel state is 0/1 (bitLength=1 in mfcfg)

function KayeRoof:GetXFeedUp(dpath, scale)
	self.d_x_feed_up_scale = scale == nil and 1 or scale
	self.d_x_feed_up = iDataRef:New(dpath)
end

function KayeRoof:SetXFeedUp(val)
	if val == nil then
		val = self.d_x_feed_up:Get() * self.d_x_feed_up_scale
		if self.d_x_feed_up:ChangedUpdate() then
			uluaSet(_G.idr_kayeroof_mf_output_x_feed_up, val)
		end
	else
		uluaSet(_G.idr_kayeroof_mf_output_x_feed_up, val)
	end
end

function KayeRoof:FreshXFeedUp()
	self.d_x_feed_up:Invalid(-1)
end

-- ========
-- output X FEED_DOWN (output/43/state)

-- Channel state is 0/1 (bitLength=1 in mfcfg)

function KayeRoof:GetXFeedDown(dpath, scale)
	self.d_x_feed_down_scale = scale == nil and 1 or scale
	self.d_x_feed_down = iDataRef:New(dpath)
end

function KayeRoof:SetXFeedDown(val)
	if val == nil then
		val = self.d_x_feed_down:Get() * self.d_x_feed_down_scale
		if self.d_x_feed_down:ChangedUpdate() then
			uluaSet(_G.idr_kayeroof_mf_output_x_feed_down, val)
		end
	else
		uluaSet(_G.idr_kayeroof_mf_output_x_feed_down, val)
	end
end

function KayeRoof:FreshXFeedDown()
	self.d_x_feed_down:Invalid(-1)
end

-- ========
-- output MASTER SW_UP (output/44/state)

-- Channel state is 0/1 (bitLength=1 in mfcfg)

function KayeRoof:GetMasterSwUp(dpath, scale)
	self.d_master_sw_up_scale = scale == nil and 1 or scale
	self.d_master_sw_up = iDataRef:New(dpath)
end

function KayeRoof:SetMasterSwUp(val)
	if val == nil then
		val = self.d_master_sw_up:Get() * self.d_master_sw_up_scale
		if self.d_master_sw_up:ChangedUpdate() then
			uluaSet(_G.idr_kayeroof_mf_output_master_sw_up, val)
		end
	else
		uluaSet(_G.idr_kayeroof_mf_output_master_sw_up, val)
	end
end

function KayeRoof:FreshMasterSwUp()
	self.d_master_sw_up:Invalid(-1)
end

-- ========
-- output MASTER SW_DOWN (output/45/state)

-- Channel state is 0/1 (bitLength=1 in mfcfg)

function KayeRoof:GetMasterSwDown(dpath, scale)
	self.d_master_sw_down_scale = scale == nil and 1 or scale
	self.d_master_sw_down = iDataRef:New(dpath)
end

function KayeRoof:SetMasterSwDown(val)
	if val == nil then
		val = self.d_master_sw_down:Get() * self.d_master_sw_down_scale
		if self.d_master_sw_down:ChangedUpdate() then
			uluaSet(_G.idr_kayeroof_mf_output_master_sw_down, val)
		end
	else
		uluaSet(_G.idr_kayeroof_mf_output_master_sw_down, val)
	end
end

function KayeRoof:FreshMasterSwDown()
	self.d_master_sw_down:Invalid(-1)
end

-- ========
-- output START_UP (output/46/state)

-- Channel state is 0/1 (bitLength=1 in mfcfg)

function KayeRoof:GetStartUp(dpath, scale)
	self.d_start_up_scale = scale == nil and 1 or scale
	self.d_start_up = iDataRef:New(dpath)
end

function KayeRoof:SetStartUp(val)
	if val == nil then
		val = self.d_start_up:Get() * self.d_start_up_scale
		if self.d_start_up:ChangedUpdate() then
			uluaSet(_G.idr_kayeroof_mf_output_start_up, val)
		end
	else
		uluaSet(_G.idr_kayeroof_mf_output_start_up, val)
	end
end

function KayeRoof:FreshStartUp()
	self.d_start_up:Invalid(-1)
end

-- ========
-- output BAT1V (output/47/state)

-- Channel state is 0/1 (bitLength=1 in mfcfg)

function KayeRoof:GetBat1v(dpath, scale)
	self.d_bat1v_scale = scale == nil and 1 or scale
	self.d_bat1v = iDataRef:New(dpath)
end

function KayeRoof:SetBat1v(val)
	if val == nil then
		val = self.d_bat1v:Get() * self.d_bat1v_scale
		if self.d_bat1v:ChangedUpdate() then
			uluaSet(_G.idr_kayeroof_mf_output_bat1v, val)
		end
	else
		uluaSet(_G.idr_kayeroof_mf_output_bat1v, val)
	end
end

function KayeRoof:FreshBat1v()
	self.d_bat1v:Invalid(-1)
end

-- ========
-- output BAT2V (output/48/state)

-- Channel state is 0/1 (bitLength=1 in mfcfg)

function KayeRoof:GetBat2v(dpath, scale)
	self.d_bat2v_scale = scale == nil and 1 or scale
	self.d_bat2v = iDataRef:New(dpath)
end

function KayeRoof:SetBat2v(val)
	if val == nil then
		val = self.d_bat2v:Get() * self.d_bat2v_scale
		if self.d_bat2v:ChangedUpdate() then
			uluaSet(_G.idr_kayeroof_mf_output_bat2v, val)
		end
	else
		uluaSet(_G.idr_kayeroof_mf_output_bat2v, val)
	end
end

function KayeRoof:FreshBat2v()
	self.d_bat2v:Invalid(-1)
end

-- ========
-- output BACKLIGHT (output/49/state)

-- Channel state is 0/1 (bitLength=1 in mfcfg)

function KayeRoof:GetBacklight(dpath, scale)
	self.d_backlight_scale = scale == nil and 1 or scale
	self.d_backlight = iDataRef:New(dpath)
end

function KayeRoof:SetBacklight(val)
	if val == nil then
		val = self.d_backlight:Get() * self.d_backlight_scale
		if self.d_backlight:ChangedUpdate() then
			uluaSet(_G.idr_kayeroof_mf_output_backlight, val)
		end
	else
		uluaSet(_G.idr_kayeroof_mf_output_backlight, val)
	end
end

function KayeRoof:FreshBacklight()
	self.d_backlight:Invalid(-1)
end

return KayeRoof
