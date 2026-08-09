-- *****************************************************************
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-08-08
-- MobiFlight KayeRoof / Kaye Roof for PMDG 777
-- MSFS RPN from: 2024 PMDG777灯光.mfproj (Kaye Roof)
-- *****************************************************************
if ilua_require_pmdg_777() then return end

-- Do not remove below lines: hardware detection
local kayeroof = com.sim.mf.KayeRoof.Open()
if not kayeroof then return end
-- Do not remove above lines: hardware detection

uluaLog('MobiFlight KayeRoof for PMDG 777')

-- ===========================================================
-- button binding (keysmap bits from mobiflight/KayeRoof.json)
-- Note: this mfproj remaps many Airbus-labelled bits to 777 functions.

---- LIGHT BRT (Encoder MapToBits 54..57; mfproj onLeft=+, onRight=-)
kayeroof:CfgRpn(54, '(L:OH_MASTER_BRIGHT_ROTATE, number) 1 + 100 min (>L:OH_MASTER_BRIGHT_ROTATE)')
kayeroof:CfgRpn(55, '(L:OH_MASTER_BRIGHT_ROTATE, number) 1 - 0 max (>L:OH_MASTER_BRIGHT_ROTATE)')
kayeroof:CfgRpn(56, '(L:OH_MASTER_BRIGHT_ROTATE, number) 1 + 100 min (>L:OH_MASTER_BRIGHT_ROTATE)')
kayeroof:CfgRpn(57, '(L:OH_MASTER_BRIGHT_ROTATE, number) 1 - 0 max (>L:OH_MASTER_BRIGHT_ROTATE)')

-- bit 0 GNADIRS_1_OFF ← PMDG777 L START START
kayeroof:CfgRpn(0, '(L:switch_94_a) if{ 9401 (>K:ROTOR_BRAKE) }')
-- bit 1 GNADIRS_1_NAV ← PMDG777 L START NORM
kayeroof:CfgRpn(1, '(L:switch_94_a) ! if{ 9407 (>K:ROTOR_BRAKE) }')
-- bit 3 GNADIRS_3_OFF ← PMDG777 R START START
kayeroof:CfgRpn(3, '(L:switch_95_a) if{ 9501 (>K:ROTOR_BRAKE) }')
-- bit 4 GNADIRS_3_NAV ← PMDG777 R START NORM
kayeroof:CfgRpn(4, '(L:switch_95_a) ! if{ 9507 (>K:ROTOR_BRAKE) }')
-- bit 5 GNADIRS_3_ATT ← PMDG777 R ELEC ON
kayeroof:CfgRpn(5, '100 (L:switch_38_a) - 50 div s0 :1 l0 0 > if{ 3807 (>K:ROTOR_BRAKE) l0 -- s0 g1 } l0 0 < if{ 3808 (>K:ROTOR_BRAKE) l0 ++ s0 g1 }')
-- bit 6 GNADIRS_2_OFF ← PMDG777 C1/C2/L ELEC/R ELEC AIR OFF
kayeroof:CfgRpn(6, '0 (L:switch_36_a) - 50 div s0 :1 l0 0 > if{ 3607 (>K:ROTOR_BRAKE) l0 -- s0 g1 } l0 0 < if{ 3608 (>K:ROTOR_BRAKE) l0 ++ s0 g1 } 0 (L:switch_37_a) - 50 div s0 :1 l0 0 > if{ 3707 (>K:ROTOR_BRAKE) l0 -- s0 g1 } l0 0 < if{ 3708 (>K:ROTOR_BRAKE) l0 ++ s0 g1 } 0 (L:switch_38_a) - 50 div s0 :1 l0 0 > if{ 3807 (>K:ROTOR_BRAKE) l0 -- s0 g1 } l0 0 < if{ 3808 (>K:ROTOR_BRAKE) l0 ++ s0 g1 } 0 (L:switch_35_a) - 50 div s0 :1 l0 0 > if{ 3507 (>K:ROTOR_BRAKE) l0 -- s0 g1 } l0 0 < if{ 3508 (>K:ROTOR_BRAKE) l0 ++ s0 g1 }')
-- bit 7 GNADIRS_2_NAV ← PMDG777 C1/C2/L ELEC/R ELEC AIR AUTO
kayeroof:CfgRpn(7, '50 (L:switch_36_a) - 50 div s0 :1 l0 0 > if{ 3607 (>K:ROTOR_BRAKE) l0 -- s0 g1 } l0 0 < if{ 3608 (>K:ROTOR_BRAKE) l0 ++ s0 g1 } 50 (L:switch_37_a) - 50 div s0 :1 l0 0 > if{ 3707 (>K:ROTOR_BRAKE) l0 -- s0 g1 } l0 0 < if{ 3708 (>K:ROTOR_BRAKE) l0 ++ s0 g1 } 50 (L:switch_38_a) - 50 div s0 :1 l0 0 > if{ 3807 (>K:ROTOR_BRAKE) l0 -- s0 g1 } l0 0 < if{ 3808 (>K:ROTOR_BRAKE) l0 ++ s0 g1 } 50 (L:switch_35_a) - 50 div s0 :1 l0 0 > if{ 3507 (>K:ROTOR_BRAKE) l0 -- s0 g1 } l0 0 < if{ 3508 (>K:ROTOR_BRAKE) l0 ++ s0 g1 }')
-- bit 8 GNADIRS_2_ATT ← PMDG777 C1/C2/L ELEC/R ELEC AIR ON
kayeroof:CfgRpn(8, '100 (L:switch_36_a) - 50 div s0 :1 l0 0 > if{ 3607 (>K:ROTOR_BRAKE) l0 -- s0 g1 } l0 0 < if{ 3608 (>K:ROTOR_BRAKE) l0 ++ s0 g1 } 100 (L:switch_37_a) - 50 div s0 :1 l0 0 > if{ 3707 (>K:ROTOR_BRAKE) l0 -- s0 g1 } l0 0 < if{ 3708 (>K:ROTOR_BRAKE) l0 ++ s0 g1 } 100 (L:switch_35_a) - 50 div s0 :1 l0 0 > if{ 3507 (>K:ROTOR_BRAKE) l0 -- s0 g1 } l0 0 < if{ 3508 (>K:ROTOR_BRAKE) l0 ++ s0 g1 } 100 (L:switch_38_a) - 50 div s0 :1 l0 0 > if{ 3807 (>K:ROTOR_BRAKE) l0 -- s0 g1 } l0 0 < if{ 3808 (>K:ROTOR_BRAKE) l0 ++ s0 g1 }')
-- bit 14 GND CTL ← PMDG777 SECONDARY EXT PWR TOGGLE
kayeroof:CfgRpn(14, '701 (>K:ROTOR_BRAKE)')
-- bit 16 BAT1 ← PMDG777 BATTERY TOGGLE
kayeroof:CfgRpn(16, '101 (>K:ROTOR_BRAKE)')
-- bit 17 BAT2 ← PMDG777 CABIN TOGGLE + PMDG777  IFE TOGGLE
kayeroof:CfgRpn(17, '1801 (>K:ROTOR_BRAKE) 1701 (>K:ROTOR_BRAKE)')
-- bit 18 LTK PUMPS1 ← PMDG777 L PUMPS FWD TOGGLE
kayeroof:CfgRpn(18, '10301 (>K:ROTOR_BRAKE)')
-- bit 19 LTK PUMPS2 ← PMDG777 L PUMPS AFT TOGGLE
kayeroof:CfgRpn(19, '10501 (>K:ROTOR_BRAKE)')
-- bit 20 PUMP1 ← PMDG777 CENTER PUMPS L TOGGLE
kayeroof:CfgRpn(20, '10901 (>K:ROTOR_BRAKE)')
-- bit 21 PUMP2 ← PMDG777 CENTER PUMPS R TOGGLE
kayeroof:CfgRpn(21, '11001 (>K:ROTOR_BRAKE)')
-- bit 23 RTKPUMPS1 ← PMDG777 R PUMPS FWD TOGGLE
kayeroof:CfgRpn(23, '10401 (>K:ROTOR_BRAKE)')
-- bit 24 RTKPUMPS2 ← PMDG777 R PUMPS AFT TOGGLE
kayeroof:CfgRpn(24, '10601 (>K:ROTOR_BRAKE)')
-- bit 26 MASTER SW ← PMDG777 APU ON/OFF
kayeroof:CfgRpn(26, '(L:switch_03_a, number) 0 == if{ 307 (>K:ROTOR_BRAKE) } els{ 308 (>K:ROTOR_BRAKE) }')
-- bit 27 START ← PMDG777 APU START
kayeroof:CfgRpn(27, '100 (L:switch_03_a) - 50 div s0 :1 l0 0 > if{ 307 (>K:ROTOR_BRAKE) l0 -- s0 g1 } l0 0 < if{ 308 (>K:ROTOR_BRAKE) l0 ++ s0 g1 }')
-- bit 28 ENG1_FIRE_TEST ← PMDG777 C1 AIR AUTO/OFF
kayeroof:CfgRpn(28, '50 (L:switch_37_a) - 50 div s0 :1 l0 0 > if{ 3707 (>K:ROTOR_BRAKE) l0 -- s0 g1 } l0 0 < if{ 3708 (>K:ROTOR_BRAKE) l0 ++ s0 g1 }')
-- bit 29 APU_FIRE_TEST ← PMDG777 C1 ELEC TOGGLE
kayeroof:CfgRpn(29, '4001 (>K:ROTOR_BRAKE) 4101 (>K:ROTOR_BRAKE)')
-- bit 31 ENG2_FIRE_TEST ← PMDG777 C2 ELEC TOGGLE
kayeroof:CfgRpn(31, '4101 (>K:ROTOR_BRAKE)')
-- bit 32 EMER EXIT LT_ON ← PMDG777 SEAT BELTS ON/AUTO
kayeroof:CfgRpn(32, '100 (L:switch_30_a) - 50 div s0 :1 l0 0 > if{ 3007 (>K:ROTOR_BRAKE) l0 -- s0 g1 } l0 0 < if{ 3008 (>K:ROTOR_BRAKE) l0 ++ s0 g1 }', '50 (L:switch_30_a) - 50 div s0 :1 l0 0 > if{ 3007 (>K:ROTOR_BRAKE) l0 -- s0 g1 } l0 0 < if{ 3008 (>K:ROTOR_BRAKE) l0 ++ s0 g1 }')
-- bit 33 EMER EXIT LT_OFF ← PMDG777 SEAT BELTS OFF/AUTO
kayeroof:CfgRpn(33, '0 (L:switch_30_a) - 50 div s0 :1 l0 0 > if{ 3007 (>K:ROTOR_BRAKE) l0 -- s0 g1 } l0 0 < if{ 3008 (>K:ROTOR_BRAKE) l0 ++ s0 g1 }', '50 (L:switch_30_a) - 50 div s0 :1 l0 0 > if{ 3007 (>K:ROTOR_BRAKE) l0 -- s0 g1 } l0 0 < if{ 3008 (>K:ROTOR_BRAKE) l0 ++ s0 g1 }')
-- bit 35 NO SMOKING_OFF ← PMDG777 NO SMOKING OFF/AUTO
kayeroof:CfgRpn(35, '0 (L:switch_29_a) - 50 div s0 :1 l0 0 > if{ 2907 (>K:ROTOR_BRAKE) l0 -- s0 g1 } l0 0 < if{ 2908 (>K:ROTOR_BRAKE) l0 ++ s0 g1 }', '50 (L:switch_29_a) - 50 div s0 :1 l0 0 > if{ 2907 (>K:ROTOR_BRAKE) l0 -- s0 g1 } l0 0 < if{ 2908 (>K:ROTOR_BRAKE) l0 ++ s0 g1 }')
-- bit 36 NO SMOKING_ON ← PMDG777 NO SMOKING ON/AUTO
kayeroof:CfgRpn(36, '100 (L:switch_29_a) - 50 div s0 :1 l0 0 > if{ 2907 (>K:ROTOR_BRAKE) l0 -- s0 g1 } l0 0 < if{ 2908 (>K:ROTOR_BRAKE) l0 ++ s0 g1 }', '50 (L:switch_29_a) - 50 div s0 :1 l0 0 > if{ 2907 (>K:ROTOR_BRAKE) l0 -- s0 g1 } l0 0 < if{ 2908 (>K:ROTOR_BRAKE) l0 ++ s0 g1 }')
-- bit 38 EXT LT_STORBE_OFF ← PMDG777 STROBE LIGHT ON/OFF
kayeroof:CfgRpn(38, '(L:switch_122_a) if{ 12201 (>K:ROTOR_BRAKE) }', '(L:switch_122_a) ! if{ 12201 (>K:ROTOR_BRAKE) }')
-- bit 39 EXT LT_BEACON_ON ← PMDG777 BEACON LIGHT ON/OFF
kayeroof:CfgRpn(39, '(L:switch_114_a) ! if{ 11401 (>K:ROTOR_BRAKE) }', '(L:switch_114_a) if{ 11401 (>K:ROTOR_BRAKE) }')
-- bit 41 EXT LT_WING_ON ← PMDG777 WING LIGHT ON/OFF
kayeroof:CfgRpn(41, '(L:switch_117_a) ! if{ 11701 (>K:ROTOR_BRAKE) }', '(L:switch_117_a) if{ 11701 (>K:ROTOR_BRAKE) }')
-- bit 43 EXT LT_NAV_NAV ← PMDG777 LOGO&NAV ON/OFF
kayeroof:CfgRpn(43, '(L:switch_116_a) ! if{ 11601 (>K:ROTOR_BRAKE) }', '(L:switch_116_a) if{ 11601 (>K:ROTOR_BRAKE) }')
-- bit 44 EXT LT_NAV_OFF ← PMDG777 NAV LIGHT ON/OFF
kayeroof:CfgRpn(44, '(L:switch_115_a) if{ 11501 (>K:ROTOR_BRAKE) }', '(L:switch_115_a) ! if{ 11501 (>K:ROTOR_BRAKE) }')
-- bit 47 EXT LT_LAND_L_ON ← PMDG777 LEFT/NOSE LANDING LIGHTS ON
kayeroof:CfgRpn(47, '(L:switch_22_a) ! if{ 2201 (>K:ROTOR_BRAKE) } (L:switch_23_a) ! if{ 2301 (>K:ROTOR_BRAKE) }')
-- bit 48 EXT LT_LAND_L_PETPACT ← PMDG777 LEFT/NOSE LANDING LIGHTS OFF
kayeroof:CfgRpn(48, '(L:switch_22_a) if{ 2201 (>K:ROTOR_BRAKE) } (L:switch_23_a) if{ 2301 (>K:ROTOR_BRAKE) }')
-- bit 49 EXT LT_LAND_R_ON ← PMDG777 RIGHT LANDING LIGHTS ON
kayeroof:CfgRpn(49, '(L:switch_24_a) ! if{ 2401 (>K:ROTOR_BRAKE) }')
-- bit 50 EXT LT_LAND_R_PETPACT ← PMDG777 RIGHT LANDING LIGHTS OFF
kayeroof:CfgRpn(50, '(L:switch_24_a) if{ 2401 (>K:ROTOR_BRAKE) }')
-- bit 51 EXT LT_NOSE_TO ← PMDG777 RUNWAY TURNOFF LIGHT ON/OFF
kayeroof:CfgRpn(51, '(L:switch_119_a) ! if{ 11901 (>K:ROTOR_BRAKE) } (L:switch_120_a) ! if{ 12001 (>K:ROTOR_BRAKE) }', '(L:switch_119_a) if{ 11901 (>K:ROTOR_BRAKE) } (L:switch_120_a) if{ 12001 (>K:ROTOR_BRAKE) }')
-- bit 52 EXT LT_NOSE_OFF ← PMDG777 TAXI LIGHT ON/OFF
kayeroof:CfgRpn(52, '(L:switch_121_a) if{ 12101 (>K:ROTOR_BRAKE) }', '(L:switch_121_a) ! if{ 12101 (>K:ROTOR_BRAKE) }')
-- bit 53 EXT PWR ← PMDG777 PRIMARY EXT PWR TOGGLE
kayeroof:CfgRpn(53, '801 (>K:ROTOR_BRAKE)')

-- ===========================================================
-- Read data for lights (Get* — keep all channels; unmapped → 0)

kayeroof:GetFireL('0')
kayeroof:GetAntiIceEng2Up('0')
kayeroof:GetAntiIceEng1Down('0')
kayeroof:GetAntiIceEng2Down('0')
kayeroof:GetAntiIceWingDown('0')
kayeroof:GetApuBleedDown('(L:APUStartup) 1 == (L:7X7XAPUInlet) 100 == and') -- APU BLEED / AVAIL
kayeroof:GetExtPwrDown('(L:switch_08_b)') -- PRIMARY EXT ON
kayeroof:GetElecPumpDown('0')
kayeroof:GetFireC('0')
kayeroof:GetBat1Down('(L:switch_01_c)') -- BAT
kayeroof:GetBat2Up('0')
kayeroof:GetBat2Down('(L:switch_18_c)') -- IFE/CABIN
kayeroof:GetFireR('0')
kayeroof:GetIr1Lower('(L:switch_59_a, bool) 100 ==') -- ADIRU
kayeroof:GetIr1Up('(L:switch_59_c)')
kayeroof:GetIr2Lower('(L:switch_46_a, bool) 100 ==') -- WIN HEAT
kayeroof:GetIr3Lower('0')
kayeroof:GetExtPwrUp('(L:switch_08_c)') -- PRIMARY EXT AVAIL
kayeroof:GetAntiIceWingUp('0')
kayeroof:GetApuBleedUp('0')
kayeroof:GetElecPumpUp('0')
kayeroof:GetAntiIceEng1Up('0')
kayeroof:GetCrewSupply('0')
kayeroof:GetGndCtl('(L:switch_07_b)') -- SECONDARY EXT
kayeroof:GetBat1Up('0')
kayeroof:GetLtkPumps1Up('(L:switch_103_c)') -- L FWD
kayeroof:GetLtkPumps2Down('0')
kayeroof:GetIr3Up('0')
kayeroof:GetIr2Up('(L:switch_46_c)')
kayeroof:GetRtkPumps1Up('(L:switch_104_c)') -- R FWD
kayeroof:GetLtkPumps1Down('0')
kayeroof:GetLtkPumps2Up('(L:switch_105_c)') -- L AFT
kayeroof:GetPump1Up('(L:switch_109_c)') -- CTR L
kayeroof:GetModeSelDown('0')
kayeroof:GetPump2Down('0')
kayeroof:GetPump1Down('0')
kayeroof:GetStartDown('0')
kayeroof:GetPump2Up('(L:switch_110_c)') -- CTR R
kayeroof:GetModeSelUp('0')
kayeroof:GetRtkPumps2Down('0')
kayeroof:GetRtkPumps1Down('0')
kayeroof:GetRtkPumps2Up('(L:switch_106_c)') -- R AFT
kayeroof:GetXFeedUp('0')
kayeroof:GetXFeedDown('0')
kayeroof:GetMasterSwUp('0')
kayeroof:GetMasterSwDown('(L:switch_03_a) 50 ==') -- APU MASTER
kayeroof:GetStartUp('(L:APUStartup) 1 == (L:7X7XAPUInlet) 100 == and') -- APU AVAIL
kayeroof:GetBat1v2('0') -- BAT2V|BAT1V PINS
kayeroof:GetBat12('0', '0') -- BAT 1+2 DISPLAY (no PMDG voltage mapping yet)
kayeroof:GetBacklight('(L:BL_Overhead, number)', 1) -- OVHD PANEL LT (0–100 → wire; mfproj interp 0–100→0–255)

GlobalFrameLoopManager:add(function()
	kayeroof:SetFireL()
	kayeroof:SetAntiIceEng2Up()
	kayeroof:SetAntiIceEng1Down()
	kayeroof:SetAntiIceEng2Down()
	kayeroof:SetAntiIceWingDown()
	kayeroof:SetApuBleedDown()
	kayeroof:SetExtPwrDown()
	kayeroof:SetElecPumpDown()
	kayeroof:SetFireC()
	kayeroof:SetBat1Down()
	kayeroof:SetBat2Up()
	kayeroof:SetBat2Down()
	kayeroof:SetFireR()
	kayeroof:SetIr1Lower()
	kayeroof:SetIr1Up()
	kayeroof:SetIr2Lower()
	kayeroof:SetIr3Lower()
	kayeroof:SetExtPwrUp()
	kayeroof:SetAntiIceWingUp()
	kayeroof:SetApuBleedUp()
	kayeroof:SetElecPumpUp()
	kayeroof:SetAntiIceEng1Up()
	kayeroof:SetCrewSupply()
	kayeroof:SetGndCtl()
	kayeroof:SetBat1Up()
	kayeroof:SetLtkPumps1Up()
	kayeroof:SetLtkPumps2Down()
	kayeroof:SetIr3Up()
	kayeroof:SetIr2Up()
	kayeroof:SetRtkPumps1Up()
	kayeroof:SetLtkPumps1Down()
	kayeroof:SetLtkPumps2Up()
	kayeroof:SetPump1Up()
	kayeroof:SetModeSelDown()
	kayeroof:SetPump2Down()
	kayeroof:SetPump1Down()
	kayeroof:SetStartDown()
	kayeroof:SetPump2Up()
	kayeroof:SetModeSelUp()
	kayeroof:SetRtkPumps2Down()
	kayeroof:SetRtkPumps1Down()
	kayeroof:SetRtkPumps2Up()
	kayeroof:SetXFeedUp()
	kayeroof:SetXFeedDown()
	kayeroof:SetMasterSwUp()
	kayeroof:SetMasterSwDown()
	kayeroof:SetStartUp()
	kayeroof:SetBat1v2()
	kayeroof:SetBacklight()
	kayeroof:SetBat12()
end)

