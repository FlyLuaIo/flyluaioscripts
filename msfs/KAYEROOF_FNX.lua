-- *****************************************************************
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-08-08
-- MobiFlight KayeRoof / Kaye Roof for Fenix A320
-- MSFS RPN from: FENIX A320 包含PAP3显示.mfproj (Kaye Roof)
-- *****************************************************************
if ilua_require_fenix_a320() then return end

-- Do not remove below lines: hardware detection
local kayeroof = com.sim.mf.KayeRoof.Open()
if not kayeroof then return end
-- Do not remove above lines: hardware detection

uluaLog('MobiFlight KayeRoof for Fenix')

-- ===========================================================
-- button binding (keysmap bits from mobiflight/KayeRoof.json)

---- LIGHT BRT (Encoder MapToBits 54..57; mfproj onLeft=+, onRight=-)
kayeroof:CfgRpn(54, '(L:A_OH_LIGHTING_OVD) 0.05 + 1 min (>L:A_OH_LIGHTING_OVD)')
kayeroof:CfgRpn(57, '(L:A_OH_LIGHTING_OVD) 0.05 - 0 max (>L:A_OH_LIGHTING_OVD)')
kayeroof:CfgRpn(55, '(L:A_OH_LIGHTING_OVD) 0.1 + 1 min (>L:A_OH_LIGHTING_OVD)')
kayeroof:CfgRpn(56, '(L:A_OH_LIGHTING_OVD) 0.1 - 0 max (>L:A_OH_LIGHTING_OVD)')

-- GNADIRS_1 OFF / NAV / ATT (bits 0..2) → IR1
kayeroof:CfgRpn(0, '0 (>L:S_OH_NAV_IR1_MODE)')
kayeroof:CfgRpn(1, '1 (>L:S_OH_NAV_IR1_MODE)')
kayeroof:CfgRpn(2, '2 (>L:S_OH_NAV_IR1_MODE)')

-- GNADIRS_3 OFF / NAV / ATT (bits 3..5) → IR2
kayeroof:CfgRpn(3, '0 (>L:S_OH_NAV_IR2_MODE)')
kayeroof:CfgRpn(4, '1 (>L:S_OH_NAV_IR2_MODE)')
kayeroof:CfgRpn(5, '2 (>L:S_OH_NAV_IR2_MODE)')

-- GNADIRS_2 OFF / NAV / ATT (bits 6..8) → IR3
kayeroof:CfgRpn(6, '0 (>L:S_OH_NAV_IR3_MODE)')
kayeroof:CfgRpn(7, '1 (>L:S_OH_NAV_IR3_MODE)')
kayeroof:CfgRpn(8, '2 (>L:S_OH_NAV_IR3_MODE)')

-- APU BLEED (bit 9)
kayeroof:CfgRpn(9, '(L:S_OH_PNEUMATIC_APU_BLEED) ! (>L:S_OH_PNEUMATIC_APU_BLEED)')

-- ELEC PUMP (bit 10)
kayeroof:CfgRpn(10, '(L:S_OH_HYD_YELLOW_ELEC_PUMP) 2 + (>L:S_OH_HYD_YELLOW_ELEC_PUMP)')

-- WING / ENG1 / ENG2 anti-ice (bits 11..13)
kayeroof:CfgRpn(11, '(L:S_OH_PNEUMATIC_WING_ANTI_ICE) ! (>L:S_OH_PNEUMATIC_WING_ANTI_ICE)')
kayeroof:CfgRpn(12, '(L:S_OH_PNEUMATIC_ENG1_ANTI_ICE) ! (>L:S_OH_PNEUMATIC_ENG1_ANTI_ICE)')
kayeroof:CfgRpn(13, '(L:S_OH_PNEUMATIC_ENG2_ANTI_ICE) ! (>L:S_OH_PNEUMATIC_ENG2_ANTI_ICE)')

-- GND CTL (bit 14)
kayeroof:CfgRpn(14, '(L:S_OH_RCRD_GND_CTL) ++ (>L:S_OH_RCRD_GND_CTL)')

-- CREW SUPPLY (bit 15)
kayeroof:CfgRpn(15, '(L:S_OH_OXYGEN_CREW_OXYGEN) ! (>L:S_OH_OXYGEN_CREW_OXYGEN)')

-- BAT1 / BAT2 (bits 16..17)
kayeroof:CfgRpn(16, '(L:S_OH_ELEC_BAT1) ! (>L:S_OH_ELEC_BAT1)')
kayeroof:CfgRpn(17, '(L:S_OH_ELEC_BAT2) ! (>L:S_OH_ELEC_BAT2)')

-- Fuel pumps / MODE SEL / XFEED (bits 18..25)
kayeroof:CfgRpn(18, '(L:S_OH_FUEL_LEFT_1) ! (>L:S_OH_FUEL_LEFT_1)')
kayeroof:CfgRpn(19, '(L:S_OH_FUEL_LEFT_2) ! (>L:S_OH_FUEL_LEFT_2)')
kayeroof:CfgRpn(20, '(L:S_OH_FUEL_CENTER_1) ! (>L:S_OH_FUEL_CENTER_1)')
kayeroof:CfgRpn(21, '(L:S_OH_FUEL_CENTER_2) ! (>L:S_OH_FUEL_CENTER_2)')
kayeroof:CfgRpn(22, '(L:S_OH_FUEL_MODE_SEL) ! (>L:S_OH_FUEL_MODE_SEL)')
kayeroof:CfgRpn(23, '(L:S_OH_FUEL_RIGHT_1) ! (>L:S_OH_FUEL_RIGHT_1)')
kayeroof:CfgRpn(24, '(L:S_OH_FUEL_RIGHT_2) ! (>L:S_OH_FUEL_RIGHT_2)')
kayeroof:CfgRpn(25, '(L:S_OH_FUEL_XFEED) ! (>L:S_OH_FUEL_XFEED)')

-- MASTER SW / START (bits 26..27)
kayeroof:CfgRpn(26, '(L:S_OH_ELEC_APU_MASTER) ! (>L:S_OH_ELEC_APU_MASTER)')
kayeroof:CfgRpn(27, '(L:S_OH_ELEC_APU_START) 2 + (>L:S_OH_ELEC_APU_START)')

-- Fire / CVR tests (bits 28..31) — press/release
kayeroof:CfgRpn(28, '1 (>L:S_OH_FIRE_ENG1_TEST)', '0 (>L:S_OH_FIRE_ENG1_TEST)')
kayeroof:CfgRpn(29, '1 (>L:S_OH_FIRE_APU_TEST)', '0 (>L:S_OH_FIRE_APU_TEST)')
kayeroof:CfgRpn(30, '1 (>L:S_OH_RCRD_TEST)', '0 (>L:S_OH_RCRD_TEST)')
kayeroof:CfgRpn(31, '1 (>L:S_OH_FIRE_ENG2_TEST)', '0 (>L:S_OH_FIRE_ENG2_TEST)')

-- EMER EXIT LT (bits 32..33)
kayeroof:CfgRpn(32, '2 (>L:S_OH_INT_LT_EMER)', '1 (>L:S_OH_INT_LT_EMER)')
kayeroof:CfgRpn(33, '0 (>L:S_OH_INT_LT_EMER)', '1 (>L:S_OH_INT_LT_EMER)')

-- SEAT BELTS (bit 34) — OFF detent; release → AUTO
kayeroof:CfgRpn(34, '0 (>L:S_OH_SIGNS)', '1 (>L:S_OH_SIGNS)')

-- NO SMOKING (bits 35..36)
kayeroof:CfgRpn(35, '0 (>L:S_OH_SIGNS_SMOKING)', '1 (>L:S_OH_SIGNS_SMOKING)')
kayeroof:CfgRpn(36, '2 (>L:S_OH_SIGNS_SMOKING)', '1 (>L:S_OH_SIGNS_SMOKING)')

-- EXT LT STROBE (bits 37..38)
kayeroof:CfgRpn(37, '2 (>L:S_OH_EXT_LT_STROBE)', '1 (>L:S_OH_EXT_LT_STROBE)')
kayeroof:CfgRpn(38, '0 (>L:S_OH_EXT_LT_STROBE)', '1 (>L:S_OH_EXT_LT_STROBE)')

-- EXT LT BEACON (bits 39..40)
kayeroof:CfgRpn(39, '1 (>L:S_OH_EXT_LT_BEACON)')
kayeroof:CfgRpn(40, '0 (>L:S_OH_EXT_LT_BEACON)')

-- EXT LT WING (bits 41..42)
kayeroof:CfgRpn(41, '1 (>L:S_OH_EXT_LT_WING)')
kayeroof:CfgRpn(42, '0 (>L:S_OH_EXT_LT_WING)')

-- EXT LT NAV (bits 43..44)
kayeroof:CfgRpn(43, '2 (>L:S_OH_EXT_LT_NAV_LOGO)', '1 (>L:S_OH_EXT_LT_NAV_LOGO)')
kayeroof:CfgRpn(44, '0 (>L:S_OH_EXT_LT_NAV_LOGO)', '1 (>L:S_OH_EXT_LT_NAV_LOGO)')

-- EXT LT RWY TURN (bits 45..46)
kayeroof:CfgRpn(45, '1 (>L:S_OH_EXT_LT_RWY_TURNOFF)')
kayeroof:CfgRpn(46, '0 (>L:S_OH_EXT_LT_RWY_TURNOFF)')

-- EXT LT LAND L (bits 47..48)
kayeroof:CfgRpn(47, '2 (>L:S_OH_EXT_LT_LANDING_L)', '1 (>L:S_OH_EXT_LT_LANDING_L)')
kayeroof:CfgRpn(48, '0 (>L:S_OH_EXT_LT_LANDING_L)', '1 (>L:S_OH_EXT_LT_LANDING_L)')

-- EXT LT LAND R (bits 49..50)
kayeroof:CfgRpn(49, '2 (>L:S_OH_EXT_LT_LANDING_R)', '1 (>L:S_OH_EXT_LT_LANDING_R)')
kayeroof:CfgRpn(50, '0 (>L:S_OH_EXT_LT_LANDING_R)', '1 (>L:S_OH_EXT_LT_LANDING_R)')

-- EXT LT NOSE (bits 51..52)
kayeroof:CfgRpn(51, '2 (>L:S_OH_EXT_LT_NOSE)', '1 (>L:S_OH_EXT_LT_NOSE)')
kayeroof:CfgRpn(52, '0 (>L:S_OH_EXT_LT_NOSE)', '1 (>L:S_OH_EXT_LT_NOSE)')

-- EXT PWR (bit 53)
kayeroof:CfgRpn(53, '1 (>L:S_OH_ELEC_EXT_PWR)', '0 (>L:S_OH_ELEC_EXT_PWR)')

-- ===========================================================
-- Read data for lights (Get* — keep all channels)

-- FIRE L / C / R
kayeroof:GetFireL('(L:I_OH_FIRE_ENG1_BUTTON)') -- ENG1 FIRE
kayeroof:GetFireC('(L:I_OH_FIRE_APU_BUTTON)')  -- APU FIRE
kayeroof:GetFireR('(L:I_OH_FIRE_ENG2_BUTTON)') -- ENG2 FIRE

-- Anti-ice
kayeroof:GetAntiIceEng2Up('(L:I_OH_PNEUMATIC_ENG2_ANTI_ICE_U)')   -- ENG2 AI FAULT
kayeroof:GetAntiIceEng1Down('(L:I_OH_PNEUMATIC_ENG1_ANTI_ICE_L)') -- ENG1 AI ON
kayeroof:GetAntiIceEng2Down('(L:I_OH_PNEUMATIC_ENG2_ANTI_ICE_L)') -- ENG2 AI ON
kayeroof:GetAntiIceWingDown('(L:I_OH_PNEUMATIC_WING_ANTI_ICE_L)') -- WING AI ON
kayeroof:GetAntiIceWingUp('(L:I_OH_PNEUMATIC_WING_ANTI_ICE_U)')   -- WING AI FAULT
kayeroof:GetAntiIceEng1Up('(L:I_OH_PNEUMATIC_ENG1_ANTI_ICE_U)')   -- ENG1 AI FAULT

-- APU BLEED / EXT PWR / ELEC PUMP
kayeroof:GetApuBleedDown('(L:I_OH_PNEUMATIC_APU_BLEED_L)')  -- APU BLEED ON
kayeroof:GetApuBleedUp('(L:I_OH_PNEUMATIC_APU_BLEED_U)')    -- APU BLEED FAULT
kayeroof:GetExtPwrDown('(L:I_OH_ELEC_EXT_PWR_L)')           -- EXT PWR AVAIL/ON
kayeroof:GetExtPwrUp('(L:I_OH_ELEC_EXT_PWR_U)')             -- EXT PWR FAULT
kayeroof:GetElecPumpDown('(L:I_OH_HYD_YELLOW_ELEC_PUMP_L)') -- Y ELEC PUMP ON
kayeroof:GetElecPumpUp('(L:I_OH_HYD_YELLOW_ELEC_PUMP_U)')   -- Y ELEC PUMP FAULT

-- BAT1 / BAT2
kayeroof:GetBat1Down('(L:I_OH_ELEC_BAT1_L)') -- BAT1 ON
kayeroof:GetBat1Up('(L:I_OH_ELEC_BAT1_U)')   -- BAT1 FAULT
kayeroof:GetBat2Up('(L:I_OH_ELEC_BAT2_U)')   -- BAT2 FAULT
kayeroof:GetBat2Down('(L:I_OH_ELEC_BAT2_L)') -- BAT2 ON

-- IR1..3
kayeroof:GetIr1Lower('(L:I_OH_NAV_IR1_ALIGN)') -- IR1 ALIGN
kayeroof:GetIr1Up('(L:I_OH_NAV_IR1_SWITCH_U)') -- IR1 FAULT
kayeroof:GetIr2Lower('(L:I_OH_NAV_IR2_ALIGN)') -- IR2 ALIGN
kayeroof:GetIr2Up('(L:I_OH_NAV_IR2_SWITCH_U)') -- IR2 FAULT
kayeroof:GetIr3Lower('(L:I_OH_NAV_IR3_ALIGN)') -- IR3 ALIGN
kayeroof:GetIr3Up('(L:I_OH_NAV_IR3_SWITCH_U)') -- IR3 FAULT

-- CREW SUPPLY / GND CTL
kayeroof:GetCrewSupply('(L:I_OH_OXYGEN_CREW_OXYGEN_L)') -- CREW OXY OFF
kayeroof:GetGndCtl('(L:I_OH_RCRD_GND_CTL_L)')           -- GND CTL ON

-- Fuel LTK / CTR / RTK / MODE / XFEED
kayeroof:GetLtkPumps1Up('(L:I_OH_FUEL_LEFT_1_U)')    -- L TK PUMP1 FAULT
kayeroof:GetLtkPumps2Down('(L:I_OH_FUEL_LEFT_2_L)')  -- L TK PUMP2 OFF
kayeroof:GetLtkPumps1Down('(L:I_OH_FUEL_LEFT_1_L)')  -- L TK PUMP1 OFF
kayeroof:GetLtkPumps2Up('(L:I_OH_FUEL_LEFT_2_U)')    -- L TK PUMP2 FAULT
kayeroof:GetPump1Up('(L:I_OH_FUEL_CENTER_1_U)')      -- CTR PUMP1 FAULT
kayeroof:GetPump1Down('(L:I_OH_FUEL_CENTER_1_L)')    -- CTR PUMP1 OFF
kayeroof:GetPump2Down('(L:I_OH_FUEL_CENTER_2_L)')    -- CTR PUMP2 OFF
kayeroof:GetPump2Up('(L:I_OH_FUEL_CENTER_2_U)')      -- CTR PUMP2 FAULT
kayeroof:GetModeSelDown('(L:I_OH_FUEL_MODE_SEL_L)')  -- MODE SEL OFF
kayeroof:GetModeSelUp('(L:I_OH_FUEL_MODE_SEL_U)')    -- MODE SEL FAULT
kayeroof:GetRtkPumps1Up('(L:I_OH_FUEL_RIGHT_1_U)')   -- R TK PUMP1 FAULT
kayeroof:GetRtkPumps1Down('(L:I_OH_FUEL_RIGHT_1_L)') -- R TK PUMP1 OFF
kayeroof:GetRtkPumps2Down('(L:I_OH_FUEL_RIGHT_2_L)') -- R TK PUMP2 OFF
kayeroof:GetRtkPumps2Up('(L:I_OH_FUEL_RIGHT_2_U)')   -- R TK PUMP2 FAULT
kayeroof:GetXFeedUp('(L:I_OH_FUEL_XFEED_U)')         -- X FEED FAULT
kayeroof:GetXFeedDown('(L:I_OH_FUEL_XFEED_L)')       -- X FEED ON

-- APU MASTER / START
kayeroof:GetMasterSwUp('(L:I_OH_ELEC_APU_MASTER_U)')   -- APU MASTER FAULT
kayeroof:GetMasterSwDown('(L:I_OH_ELEC_APU_MASTER_L)') -- APU MASTER ON
kayeroof:GetStartDown('(L:I_OH_ELEC_APU_START_L)')     -- APU START ON
kayeroof:GetStartUp('(L:I_OH_ELEC_APU_START_U)')       -- APU START AVAIL

-- BAT1V|BAT2V Output pins (mfproj Device "BAT2V|BAT1V", ≠ LedModule)
kayeroof:GetBat1v2('(L:N_ELEC_VOLT_BAT_1) 0 != (L:N_ELEC_VOLT_BAT_2) 0 != or') -- BAT2V|BAT1V PINS

-- BACKLIGHT (mfproj: A_OH_LIGHTING_OVD * 100)
kayeroof:GetBacklight('(L:A_OH_LIGHTING_OVD)', 255) -- OVHD INTEG LT

-- PAP3 LedModule "BAT 1+2": BAT1 + BAT2 voltages → one segment write
kayeroof:GetBat12('(L:N_ELEC_VOLT_BAT_1)', '(L:N_ELEC_VOLT_BAT_2)') -- BAT 1+2 DISPLAY

local dr_ac_bus = iDataRef:New("(L:B_ELEC_BUS_POWER_AC_ESS, Bool)")
local dr_dc_bus = iDataRef:New("(L:B_ELEC_BUS_POWER_DC_BAT, Bool)")

GlobalFrameLoopManager:add(function()
	-- expert code: cold and dark
    local b_ac_bus
    local b_dc_bus
	if dr_ac_bus:ChangedUpdate() then
		b_ac_bus = dr_ac_bus:GetOld()
		b_dc_bus = dr_dc_bus:GetOld()
		if b_ac_bus == 1 then
			-- kayeroof:SetLedsOff()
		-- else
			kayeroof:FreshBacklight()
			kayeroof:FreshBits()
		end
	else
		b_ac_bus = dr_ac_bus:Get()
		b_dc_bus = dr_dc_bus:Get()
	end

	kayeroof:SetLeds()
	if b_ac_bus == 1 then
		kayeroof:SetBacklight()
		kayeroof:SetBat12()
	else
		kayeroof:SetBacklight(0)
	end

end)
