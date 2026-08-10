-- *****************************************************************
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-08-08
-- MobiFlight KayeRoof / Kaye Roof for PMDG 737
-- MSFS RPN from: 2024 PMDG737灯光.mfproj (Kaye Roof)
-- *****************************************************************
if ilua_require_pmdg_737() then return end

-- Do not remove below lines: hardware detection
local kayeroof = com.sim.mf.KayeRoof.Open()
if not kayeroof then return end
-- Do not remove above lines: hardware detection

uluaLog('MobiFlight KayeRoof for PMDG 737')

-- ===========================================================
-- button binding (keysmap bits from mobiflight/KayeRoof.json)
-- Note: this mfproj remaps many Airbus-labelled bits to 737 functions.

---- LIGHT BRT (Encoder MapToBits 54..57; mfproj onLeft=+, onRight=-)
kayeroof:CfgRpn(54, '(L:OH_PANEL_LIGHT_CONTROL, number) 3 + 300 min (>L:OH_PANEL_LIGHT_CONTROL, number) (L:CA_MAIN_PANEL_LIGHT_CONTROL, number) 3 + 300 min (>L:CA_MAIN_PANEL_LIGHT_CONTROL, number) (L:PED_PANEL_LIGHT_CONTROL, number) 3 + 300 min (>L:PED_PANEL_LIGHT_CONTROL, number)')
kayeroof:CfgRpn(57, '(L:OH_PANEL_LIGHT_CONTROL, number) 3 - 0 max (>L:OH_PANEL_LIGHT_CONTROL, number) (L:CA_MAIN_PANEL_LIGHT_CONTROL, number) 3 - 0 max (>L:CA_MAIN_PANEL_LIGHT_CONTROL, number) (L:PED_PANEL_LIGHT_CONTROL, number) 3 - 0 max (>L:PED_PANEL_LIGHT_CONTROL, number)')
kayeroof:CfgRpn(55, '(L:OH_PANEL_LIGHT_CONTROL, number) 3 + 300 min (>L:OH_PANEL_LIGHT_CONTROL, number) (L:CA_MAIN_PANEL_LIGHT_CONTROL, number) 3 + 300 min (>L:CA_MAIN_PANEL_LIGHT_CONTROL, number) (L:PED_PANEL_LIGHT_CONTROL, number) 3 + 300 min (>L:PED_PANEL_LIGHT_CONTROL, number)')
kayeroof:CfgRpn(56, '(L:OH_PANEL_LIGHT_CONTROL, number) 3 - 0 max (>L:OH_PANEL_LIGHT_CONTROL, number) (L:CA_MAIN_PANEL_LIGHT_CONTROL, number) 3 - 0 max (>L:CA_MAIN_PANEL_LIGHT_CONTROL, number) (L:PED_PANEL_LIGHT_CONTROL, number) 3 - 0 max (>L:PED_PANEL_LIGHT_CONTROL, number)')

-- bit 0 GNADIRS_1_OFF ← PMDG737 ENG START L GND
kayeroof:CfgRpn(0, '0 (L:switch_119_73X) - 10 div s0 :1 l0 0 > if{ 11907 (>K:ROTOR_BRAKE) l0 -- s0 g1 } l0 0 < if{ 11908 (>K:ROTOR_BRAKE) l0 ++ s0 g1 }')
-- bit 1 GNADIRS_1_NAV ← PMDG737 ENG START L OFF
kayeroof:CfgRpn(1, '10 (L:switch_119_73X) - 10 div s0 :1 l0 0 > if{ 11907 (>K:ROTOR_BRAKE) l0 -- s0 g1 } l0 0 < if{ 11908 (>K:ROTOR_BRAKE) l0 ++ s0 g1 }')
-- bit 2 GNADIRS_1_ATT ← PMDG737 ENG START L CONT
kayeroof:CfgRpn(2, '20 (L:switch_119_73X) - 10 div s0 :1 l0 0 > if{ 11907 (>K:ROTOR_BRAKE) l0 -- s0 g1 } l0 0 < if{ 11908 (>K:ROTOR_BRAKE) l0 ++ s0 g1 }')
-- bit 3 GNADIRS_3_OFF ← PMDG737 ENG START R GND
kayeroof:CfgRpn(3, '0 (L:switch_121_73X) - 10 div s0 :1 l0 0 > if{ 12107 (>K:ROTOR_BRAKE) l0 -- s0 g1 } l0 0 < if{ 12108 (>K:ROTOR_BRAKE) l0 ++ s0 g1 }')
-- bit 4 GNADIRS_3_NAV ← PMDG737 ENG START R OFF
kayeroof:CfgRpn(4, '10 (L:switch_121_73X) - 10 div s0 :1 l0 0 > if{ 12107 (>K:ROTOR_BRAKE) l0 -- s0 g1 } l0 0 < if{ 12108 (>K:ROTOR_BRAKE) l0 ++ s0 g1 }')
-- bit 5 GNADIRS_3_ATT ← PMDG737 ENG START R CONT
kayeroof:CfgRpn(5, '20 (L:switch_121_73X) - 10 div s0 :1 l0 0 > if{ 12107 (>K:ROTOR_BRAKE) l0 -- s0 g1 } l0 0 < if{ 12108 (>K:ROTOR_BRAKE) l0 ++ s0 g1 }')
-- bit 6 GNADIRS_2_OFF ← PMDG737 IRS L/R OFF
kayeroof:CfgRpn(6, '0 (L:switch_255_73X) - 10 div s0 :1 l0 0 > if{ 25507 (>K:ROTOR_BRAKE) l0 -- s0 g1 } l0 0 < if{ 25508 (>K:ROTOR_BRAKE) l0 ++ s0 g1 } 0 (L:switch_256_73X) - 10 div s0 :1 l0 0 > if{ 25607 (>K:ROTOR_BRAKE) l0 -- s0 g1 } l0 0 < if{ 25608 (>K:ROTOR_BRAKE) l0 ++ s0 g1 }')
-- bit 7 GNADIRS_2_NAV ← PMDG737 IRS L/R NAV
kayeroof:CfgRpn(7, '20 (L:switch_255_73X) - 10 div s0 :1 l0 0 > if{ 25507 (>K:ROTOR_BRAKE) l0 -- s0 g1 } l0 0 < if{ 25508 (>K:ROTOR_BRAKE) l0 ++ s0 g1 } 20 (L:switch_256_73X) - 10 div s0 :1 l0 0 > if{ 25607 (>K:ROTOR_BRAKE) l0 -- s0 g1 } l0 0 < if{ 25608 (>K:ROTOR_BRAKE) l0 ++ s0 g1 }')
-- bit 8 GNADIRS_2_ATT ← PMDG737 IRS L/R ATT
kayeroof:CfgRpn(8, '30 (L:switch_255_73X) - 10 div s0 :1 l0 0 > if{ 25507 (>K:ROTOR_BRAKE) l0 -- s0 g1 } l0 0 < if{ 25508 (>K:ROTOR_BRAKE) l0 ++ s0 g1 } 30 (L:switch_256_73X) - 10 div s0 :1 l0 0 > if{ 25607 (>K:ROTOR_BRAKE) l0 -- s0 g1 } l0 0 < if{ 25608 (>K:ROTOR_BRAKE) l0 ++ s0 g1 }')
-- bit 9 APU BLEED ← PMDG737 APU BLEED TOGGLE
kayeroof:CfgRpn(9, '21101 (>K:ROTOR_BRAKE)')
-- bit 10 ELEC PUMP ← PMDG737 APU GEN 1&2 ON
kayeroof:CfgRpn(10, '2901 (>K:ROTOR_BRAKE) 2801 (>K:ROTOR_BRAKE)')
-- bit 11 WING ← PMDG737 WING ANTI-ICE ON/OFF
kayeroof:CfgRpn(11, '15601 (>K:ROTOR_BRAKE)')
-- bit 12 ENG1 ← PMDG737 ENG1 ANTI-ICE ON/OFF
kayeroof:CfgRpn(12, '15701 (>K:ROTOR_BRAKE)')
-- bit 13 ENG2 ← PMDG737 ENG2 ANTI-ICE ON/OFF
kayeroof:CfgRpn(13, '15801 (>K:ROTOR_BRAKE)')
-- bit 14 GND CTL ← PMDG737 GRD PWR OFF
kayeroof:CfgRpn(14, '1702 (>K:ROTOR_BRAKE)')
-- bit 15 CREW SUPPLY ← PMDG737 GEN 1 ON
kayeroof:CfgRpn(15, '2701 (>K:ROTOR_BRAKE)')
-- bit 16 BAT1 ← PMDG737 BAT ON/OFF
kayeroof:CfgRpn(16, '201 (>K:ROTOR_BRAKE)')
-- bit 17 BAT2 ← PMDG737 EMER EXIT LIGHTS ARM/OFF
kayeroof:CfgRpn(17, '10101 (>K:ROTOR_BRAKE)')
-- bit 18 LTK PUMPS1 ← PMDG737 FUEL PUMPS AFT L ON/OFF
kayeroof:CfgRpn(18, '3701 (>K:ROTOR_BRAKE)')
-- bit 19 LTK PUMPS2 ← PMDG737 FUEL PUMPS FWD L ON/OFF
kayeroof:CfgRpn(19, '3801 (>K:ROTOR_BRAKE)')
-- bit 20 PUMP1 ← PMDG737 FUEL PUMPS CTR L ON/OFF
kayeroof:CfgRpn(20, '4501 (>K:ROTOR_BRAKE)')
-- bit 21 PUMP2 ← PMDG737 FUEL PUMPS CTR R ON/OFF
kayeroof:CfgRpn(21, '4601 (>K:ROTOR_BRAKE)')
-- bit 22 MODE SEL ← PMDG737 HYD PUMPS ELEC 1 ON/OFF
kayeroof:CfgRpn(22, '16801 (>K:ROTOR_BRAKE)')
-- bit 23 RTKPUMPS1 ← PMDG737 FUEL PUMPS FWD R ON/OFF
kayeroof:CfgRpn(23, '3901 (>K:ROTOR_BRAKE)')
-- bit 24 RTKPUMPS2 ← PMDG737 FUEL PUMPS AFT R ON/OFF
kayeroof:CfgRpn(24, '4001 (>K:ROTOR_BRAKE)')
-- bit 25 XFEED ← PMDG737 HYD PUMPS ELEC 2 ON/OFF
kayeroof:CfgRpn(25, '16701 (>K:ROTOR_BRAKE)')
-- bit 26 MASTER SW ← PMDG737 APU ON/OFF
kayeroof:CfgRpn(26, '(L:switch_118_73X) 0 == if{ 11801 (>K:ROTOR_BRAKE) } els{ 11802 (>K:ROTOR_BRAKE) }')
-- bit 27 START ← PMDG737 APU START
kayeroof:CfgRpn(27, '100 (L:switch_118_73X,number) - 50 div s0 :1 l0 0 > if{ 11801 (>K:ROTOR_BRAKE) l0 -- s0 g1 } l0 0 < if{ 11802 (>K:ROTOR_BRAKE) l0 ++ s0 g1 }', '50 (L:switch_118_73X,number) - 50 div s0 :1 l0 0 > if{ 11801 (>K:ROTOR_BRAKE) l0 -- s0 g1 } l0 0 < if{ 11802 (>K:ROTOR_BRAKE) l0 ++ s0 g1 }')
-- bit 28 ENG1_FIRE_TEST ← PMDG737 YAW DAMPER ON/OFF
kayeroof:CfgRpn(28, '6301 (>K:ROTOR_BRAKE)')
-- bit 29 APU_FIRE_TEST ← PMDG737 PROBE A ON/OFF
kayeroof:CfgRpn(29, '14001 (>K:ROTOR_BRAKE)')
-- bit 30 CVR_TEST ← PMDG737 GEN 2 ON
kayeroof:CfgRpn(30, '3001 (>K:ROTOR_BRAKE)')
-- bit 31 ENG2_FIRE_TEST ← PMDG737 PROBE B ON/OFF
kayeroof:CfgRpn(31, '14101 (>K:ROTOR_BRAKE)')
-- bit 32 EMER EXIT LT_ON ← PMDG737 ISOLATION VALVE CLOSE/AUTO
kayeroof:CfgRpn(32, '(L:switch_202_73X, number) s0 l0 50 == if{ 20202 (>K:ROTOR_BRAKE) } l0 100 == if{ 20202 (>K:ROTOR_BRAKE) 20202 (>K:ROTOR_BRAKE) }', '(L:switch_202_73X, number) s0 l0 0 == if{ 20201 (>K:ROTOR_BRAKE) } l0 100 == if{ 20202 (>K:ROTOR_BRAKE) }')
-- bit 33 EMER EXIT LT_OFF ← PMDG737 ISOLATION VALVE OPEN/AUTO
kayeroof:CfgRpn(33, '(L:switch_202_73X, number) s0 l0 50 == if{ 20201 (>K:ROTOR_BRAKE) } l0 0 == if{ 20201 (>K:ROTOR_BRAKE) 20201 (>K:ROTOR_BRAKE) }', '(L:switch_202_73X, number) s0 l0 0 == if{ 20201 (>K:ROTOR_BRAKE) } l0 100 == if{ 20202 (>K:ROTOR_BRAKE) }')
-- bit 34 SEAT BELTS_OFF ← PMDG737 NOSMOKING ON/OFF
kayeroof:CfgRpn(34, '100 (L:switch_103_73X, number) == if{ 10302 (>K:ROTOR_BRAKE) }', '0 (L:switch_103_73X, number) == if{ 10301 (>K:ROTOR_BRAKE) }')
-- bit 35 NO SMOKING_OFF ← PMDG737 SEATBELTS AUTO/OFF
kayeroof:CfgRpn(35, '(L:switch_104_73X, number) s0 l0 50 == if{ 10402 (>K:ROTOR_BRAKE) } l0 100 == if{ 10402 (>K:ROTOR_BRAKE) 10402 (>K:ROTOR_BRAKE) }', '(L:switch_104_73X, number) s0 l0 0 == if{ 10401 (>K:ROTOR_BRAKE) } l0 100 == if{ 10402 (>K:ROTOR_BRAKE) }')
-- bit 36 NO SMOKING_ON ← PMDG737 SEATBELTS ON/AUTO
kayeroof:CfgRpn(36, '(L:switch_104_73X, number) s0 l0 50 == if{ 10401 (>K:ROTOR_BRAKE) } l0 0 == if{ 10401 (>K:ROTOR_BRAKE) 10401 (>K:ROTOR_BRAKE) }', '(L:switch_104_73X, number) s0 l0 0 == if{ 10401 (>K:ROTOR_BRAKE) } l0 100 == if{ 10402 (>K:ROTOR_BRAKE) }')
-- bit 37 EXT LT_STORBE_ON ← PMDG737 POSITION STEADY&STROBE/OFF
kayeroof:CfgRpn(37, '0 (L:switch_123_73X,number) - 50 div s0 :1 l0 0 > if{ 12301 (>K:ROTOR_BRAKE) l0 -- s0 g1 } l0 0 < if{ 12302 (>K:ROTOR_BRAKE) l0 ++ s0 g1 }', '50 (L:switch_123_73X,number) - 50 div s0 :1 l0 0 > if{ 12301 (>K:ROTOR_BRAKE) l0 -- s0 g1 } l0 0 < if{ 12302 (>K:ROTOR_BRAKE) l0 ++ s0 g1 }')
-- bit 38 EXT LT_STORBE_OFF ← PMDG737 POSITION STEADY/OFF
kayeroof:CfgRpn(38, '100 (L:switch_123_73X,number) - 50 div s0 :1 l0 0 > if{ 12301 (>K:ROTOR_BRAKE) l0 -- s0 g1 } l0 0 < if{ 12302 (>K:ROTOR_BRAKE) l0 ++ s0 g1 }', '50 (L:switch_123_73X,number) - 50 div s0 :1 l0 0 > if{ 12301 (>K:ROTOR_BRAKE) l0 -- s0 g1 } l0 0 < if{ 12302 (>K:ROTOR_BRAKE) l0 ++ s0 g1 }')
-- bit 39 EXT LT_BEACON_ON ← PMDG737 ANTI COLLISION ON(BEACON)
kayeroof:CfgRpn(39, '0 (L:switch_124_73X, number) == if{ 12401 (>K:ROTOR_BRAKE) }')
-- bit 40 EXT LT_BEACON_OFF ← PMDG737 ANTI COLLISION OFF(BEACON)
kayeroof:CfgRpn(40, '100 (L:switch_124_73X, number) == if{ 12401 (>K:ROTOR_BRAKE) }')
-- bit 41 EXT LT_WING_ON ← PMDG737 WING LIGHT ON
kayeroof:CfgRpn(41, '0 (L:switch_125_73X, number) == if{ 12501 (>K:ROTOR_BRAKE) }')
-- bit 42 EXT LT_WING_OFF ← PMDG737 WING LIGHT OFF
kayeroof:CfgRpn(42, '100 (L:switch_125_73X, number) == if{ 12501 (>K:ROTOR_BRAKE) }')
-- bit 43 EXT LT_NAV_NAV ← PMDG737 WHEEL WELL LIGHT ON/OFF
kayeroof:CfgRpn(43, '0 (L:switch_126_73X, number) == if{ 12601 (>K:ROTOR_BRAKE) }', '100 (L:switch_126_73X, number) == if{ 12601 (>K:ROTOR_BRAKE) }')
-- bit 44 EXT LT_NAV_OFF ← PMDG737 LOGO LIGHT ON/OFF
kayeroof:CfgRpn(44, '100 (L:switch_122_73X, number) == if{ 12201 (>K:ROTOR_BRAKE) }', '0 (L:switch_122_73X, number) == if{ 12201 (>K:ROTOR_BRAKE) }')
-- bit 45 EXT LT_RWY TURN_ON ← PMDG737 LANDING LIGHT BOTH ON/OFF
kayeroof:CfgRpn(45, '0 (L:switch_113_73X, number) == if{ 11301 (>K:ROTOR_BRAKE) } 0 (L:switch_114_73X, number) == if{ 11401 (>K:ROTOR_BRAKE) }', '100 (L:switch_113_73X, number) == if{ 11301 (>K:ROTOR_BRAKE) } 100 (L:switch_114_73X, number) == if{ 11401 (>K:ROTOR_BRAKE) }')
-- bit 47 EXT LT_LAND_L_ON ← PMDG737 L PACK OFF/AUTO
kayeroof:CfgRpn(47, '(L:switch_200_73X, number) s0 l0 50 == if{ 20002 (>K:ROTOR_BRAKE) } l0 100 == if{ 20002 (>K:ROTOR_BRAKE) 20002 (>K:ROTOR_BRAKE) }', '(L:switch_200_73X, number) s0 l0 0 == if{ 20001 (>K:ROTOR_BRAKE) } l0 100 == if{ 20002 (>K:ROTOR_BRAKE) }')
-- bit 48 EXT LT_LAND_L_PETPACT ← PMDG737 L PACK AUTO/HIGH
kayeroof:CfgRpn(48, '(L:switch_200_73X, number) s0 l0 50 == if{ 20001 (>K:ROTOR_BRAKE) } l0 0 == if{ 20001 (>K:ROTOR_BRAKE) 20001 (>K:ROTOR_BRAKE) }', '(L:switch_200_73X, number) s0 l0 0 == if{ 20001 (>K:ROTOR_BRAKE) } l0 100 == if{ 20002 (>K:ROTOR_BRAKE) }')
-- bit 49 EXT LT_LAND_R_ON ← PMDG737 R PACK OFF/AUTO
kayeroof:CfgRpn(49, '(L:switch_201_73X, number) s0 l0 50 == if{ 20102 (>K:ROTOR_BRAKE) } l0 100 == if{ 20102 (>K:ROTOR_BRAKE) 20102 (>K:ROTOR_BRAKE) }', '(L:switch_201_73X, number) s0 l0 0 == if{ 20101 (>K:ROTOR_BRAKE) } l0 100 == if{ 20102 (>K:ROTOR_BRAKE) }')
-- bit 50 EXT LT_LAND_R_PETPACT ← PMDG737 R PACK AUTO/HIGH
kayeroof:CfgRpn(50, '(L:switch_201_73X, number) s0 l0 50 == if{ 20101 (>K:ROTOR_BRAKE) } l0 0 == if{ 20101 (>K:ROTOR_BRAKE) 20101 (>K:ROTOR_BRAKE) }', '(L:switch_201_73X, number) s0 l0 0 == if{ 20101 (>K:ROTOR_BRAKE) } l0 100 == if{ 20102 (>K:ROTOR_BRAKE) }')
-- bit 51 EXT LT_NOSE_TO ← PMDG737 RUNWAY TURNOFF LIGHT BOTH ON/OFF
kayeroof:CfgRpn(51, '0 (L:switch_115_73X, number) == if{ 11501 (>K:ROTOR_BRAKE) } 0 (L:switch_116_73X, number) == if{ 11601 (>K:ROTOR_BRAKE) }', '100 (L:switch_115_73X, number) == if{ 11501 (>K:ROTOR_BRAKE) } 100 (L:switch_116_73X, number) == if{ 11601 (>K:ROTOR_BRAKE) }')
-- bit 52 EXT LT_NOSE_OFF ← PMDG737 TAXI LIGHT ON/OFF
kayeroof:CfgRpn(52, '100 (L:switch_117_73X, number) == if{ 11701 (>K:ROTOR_BRAKE) }', '0 (L:switch_117_73X, number) == if{ 11701 (>K:ROTOR_BRAKE) }')
-- bit 53 EXT PWR ← PMDG737 GRD PWR ON
kayeroof:CfgRpn(53, '1701 (>K:ROTOR_BRAKE)')
--WINDOW HEAT
kayeroof:CfgRpn(60, '13601 (>K:ROTOR_BRAKE) , 13501 (>K:ROTOR_BRAKE)')
kayeroof:CfgRpn(59, '13801 (>K:ROTOR_BRAKE)')
kayeroof:CfgRpn(58, '13901 (>K:ROTOR_BRAKE)')

-- ===========================================================
-- Read data for lights (Get* — keep all channels; unmapped → 0)

kayeroof:GetFireL('(L:switch_64_73X, number) 0 >') -- ENG1 FIRE
kayeroof:GetAntiIceEng2Up('0') -- ENG2 AI FAULT
kayeroof:GetAntiIceEng1Down('(L:switch_157_73X, number)') -- ENG1 AI ON
kayeroof:GetAntiIceEng2Down('(L:switch_158_73X, number)') -- ENG2 AI ON
kayeroof:GetAntiIceWingDown('(L:switch_152_73X, number) 10 *') -- WING AI ON
kayeroof:GetApuBleedDown('(L:switch_211_73X, bool)') -- APU BLEED ON
kayeroof:GetExtPwrDown('0') -- EXT PWR ON
kayeroof:GetElecPumpDown('(L:switch_25_73X, number) 0 >') -- ELEC PUMP / HYD
kayeroof:GetFireC('(L:switch_142_73X, number) 0 >') -- APU FIRE
kayeroof:GetBat1Down('(L:switch_02_73X, number)') -- BAT
kayeroof:GetBat2Up('0')
kayeroof:GetBat2Down('(L:switch_102_73X, number) 0 >')
kayeroof:GetFireR('(L:switch_146_73X, number) 0 >') -- ENG2 FIRE
kayeroof:GetIr1Lower('(L:switch_132_73X, number) 0 >') -- IR L
kayeroof:GetIr1Up('(L:switch_128_73X, number) 0 >')
kayeroof:GetIr2Lower('(L:switch_134_73X, number) 0 >') -- IR R
kayeroof:GetIr3Lower('(L:switch_133_73X, number) 0 >') -- IR C
kayeroof:GetExtPwrUp('(L:switch_16_73X, number) 0 >') -- GRD PWR
kayeroof:GetAntiIceWingUp('0')
kayeroof:GetApuBleedUp('(L:VC_OVHD_AC_Eng_APU_Bleed_Button_TOP)')
kayeroof:GetElecPumpUp('0')
kayeroof:GetAntiIceEng1Up('0')
kayeroof:GetCrewSupply('(L:switch_26_73X, number) 0 >')
kayeroof:GetGndCtl('0')
kayeroof:GetBat1Up('0')
kayeroof:GetLtkPumps1Up('0')
kayeroof:GetLtkPumps2Down('(L:switch_42_73X, number) 0 >') -- FUEL FWD L
kayeroof:GetIr3Up('(L:switch_129_73X, number) 0 >')
kayeroof:GetIr2Up('(L:switch_130_73X, number) 0 >')
kayeroof:GetRtkPumps1Up('0')
kayeroof:GetLtkPumps1Down('(L:switch_41_73X, number) 0 >') -- FUEL AFT L
kayeroof:GetLtkPumps2Up('0')
kayeroof:GetPump1Up('(L:switch_47_73X, number) 0 >') -- CTR L
kayeroof:GetModeSelDown('0')
kayeroof:GetPump2Down('0')
kayeroof:GetPump1Down('0')
kayeroof:GetStartDown('(L:APU)') -- APU START
kayeroof:GetPump2Up('(L:switch_48_73X, number) 0 >') -- CTR R
kayeroof:GetModeSelUp('(L:switch_164_73X, number) 0 >')
kayeroof:GetRtkPumps2Down('(L:switch_44_73X, number) 0 >') -- FUEL AFT R
kayeroof:GetRtkPumps1Down('(L:switch_43_73X, number) 0 >') -- FUEL FWD R
kayeroof:GetRtkPumps2Up('0')
kayeroof:GetXFeedUp('(L:switch_163_73X, number) 0 >')
kayeroof:GetXFeedDown('0')
kayeroof:GetMasterSwUp('(L:INI_APU_MASTER_FAULT)')
kayeroof:GetMasterSwDown('(L:switch_118_73X) 50 >=') -- APU MASTER
kayeroof:GetStartUp('(L:APU_Volume) 100 >=') -- APU AVAIL
kayeroof:GetBat1v2('0') -- BAT2V|BAT1V PINS
kayeroof:GetBat12('pmdg/ng3/data/ELEC_MeterDisplayTop[1]', 'pmdg/ng3/data/ELEC_MeterDisplayTop[2]') -- BAT 1+2 DISPLAY (no PMDG voltage mapping yet)
kayeroof:GetBacklight('(L:BL_Overhead, number)', 255) -- OVHD PANEL LT (mfproj Interpolation 0–100 → 0–255)

-- APU EGT stability (same as QMOVH_A_PMDG737): correct Start AVAIL / START when float EGT < 1000
local StabilityManager = {
	monitors = {}
}

function StabilityManager:addMonitor(name, initialValue, threshold, interval)
	self.monitors[name] = {
		lastValue = initialValue,
		threshold = threshold,
		interval = interval,
		lastCheckTime = os.time(),
		stableCount = 0,
		requiredStableChecks = 3
	}
end

function StabilityManager:update(name, currentValue)
	local monitor = self.monitors[name]
	if not monitor then return false end

	local currentTime = os.time()
	if currentTime - monitor.lastCheckTime < monitor.interval then
		return false
	end

	monitor.lastCheckTime = currentTime

	local delta = math.abs(currentValue - monitor.lastValue)
	monitor.lastValue = currentValue

	if delta <= monitor.threshold then
		monitor.stableCount = monitor.stableCount + 1
	else
		monitor.stableCount = 0
	end

	return monitor.stableCount >= monitor.requiredStableChecks
end

local dr_kayeroof_pmdg737_apu_egt = iDataRef:New("pmdg/ng3/data/APU_EGTNeedle")
local isstableapuegt = 0
local dr_apu_on = iDataRef:New('(L:APU)')

StabilityManager:addMonitor("EGT", 25.0, 2, 1)

GlobalFrameLoopManager:add(function()
	local isapuon = dr_apu_on:Get()
	local currentTemp = dr_kayeroof_pmdg737_apu_egt:Get()
	if currentTemp > 350 then
		if StabilityManager:update("EGT", currentTemp) then
			isstableapuegt = 1
		end
	else
		isstableapuegt = 0
	end
	if isstableapuegt > 0 then
		isapuon = 0
	end

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
	kayeroof:SetPump2Up()
	kayeroof:SetModeSelUp()
	kayeroof:SetRtkPumps2Down()
	kayeroof:SetRtkPumps1Down()
	kayeroof:SetRtkPumps2Up()
	kayeroof:SetXFeedUp()
	kayeroof:SetXFeedDown()
	kayeroof:SetMasterSwUp()
	kayeroof:SetMasterSwDown()
	-- PMDG SDK float data correction path (QMOVH SetStartUp/SetStartDn)
	if currentTemp < 1000 then
		kayeroof:SetStartUp(isstableapuegt * 255)
		kayeroof:SetStartDown(isapuon * 255)
	else
		kayeroof:SetStartUp()
		kayeroof:SetStartDown()
	end
	kayeroof:SetBat1v2()
	kayeroof:SetBacklight()
	kayeroof:SetBat12()
end)
