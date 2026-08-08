-- *****************************************************************
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-08-08
-- MobiFlight KayeRoof / Kaye Roof for GA
-- *****************************************************************

-- Do not remove below lines: hardware detection
local kayeroof = com.sim.mf.KayeRoof:new()
if not kayeroof:Init() then
	return
end
-- Do not remove above lines: hardware detection

uluaLog('MobiFlight KayeRoof for GA')

-- INPUT key bindings (keysmap bits from mobiflight/KayeRoof.json)

---- LIGHT BRT
-- inner
kayeroof:CfgCmd(54, "sim/operation/test_none")
kayeroof:CfgCmd(55, "sim/operation/test_none")
-- outer
kayeroof:CfgCmd(56, "sim/operation/test_none")
kayeroof:CfgCmd(57, "sim/operation/test_none")

-- GNADIRS_1_OFF (Button, bit 0)
kayeroof:CfgCmd(0, "sim/operation/test_none")

-- GNADIRS_1_NAV (Button, bit 1)
kayeroof:CfgCmd(1, "sim/operation/test_none")

-- GNADIRS_1_ATT (Button, bit 2)
kayeroof:CfgCmd(2, "sim/operation/test_none")

-- GNADIRS_3_OFF (Button, bit 3)
kayeroof:CfgCmd(3, "sim/operation/test_none")

-- GNADIRS_3_NAV (Button, bit 4)
kayeroof:CfgCmd(4, "sim/operation/test_none")

-- GNADIRS_3_ATT (Button, bit 5)
kayeroof:CfgCmd(5, "sim/operation/test_none")

-- GNADIRS_2_OFF (Button, bit 6)
kayeroof:CfgCmd(6, "sim/operation/test_none")

-- GNADIRS_2_NAV (Button, bit 7)
kayeroof:CfgCmd(7, "sim/operation/test_none")

-- GNADIRS_2_ATT (Button, bit 8)
kayeroof:CfgCmd(8, "sim/operation/test_none")

-- APU BLEED (Button, bit 9)
kayeroof:CfgCmd(9, "sim/operation/test_none")

-- ELEC PUMP (Button, bit 10)
kayeroof:CfgCmd(10, "sim/operation/test_none")

-- WING (Button, bit 11)
kayeroof:CfgCmd(11, "sim/operation/test_none")

-- ENG1 (Button, bit 12)
kayeroof:CfgCmd(12, "sim/operation/test_none")

-- ENG2 (Button, bit 13)
kayeroof:CfgCmd(13, "sim/operation/test_none")

-- GND CTL (Button, bit 14)
kayeroof:CfgCmd(14, "sim/operation/test_none")

-- CREW SUPPLY (Button, bit 15)
kayeroof:CfgCmd(15, "sim/operation/test_none")

-- BAT1 (Button, bit 16)
kayeroof:CfgCmd(16, "sim/operation/test_none")

-- BAT2 (Button, bit 17)
kayeroof:CfgCmd(17, "sim/operation/test_none")

-- LTK PUMPS1 (Button, bit 18)
kayeroof:CfgCmd(18, "sim/operation/test_none")

-- LTK PUMPS2 (Button, bit 19)
kayeroof:CfgCmd(19, "sim/operation/test_none")

-- PUMP1 (Button, bit 20)
kayeroof:CfgCmd(20, "sim/operation/test_none")

-- PUMP2 (Button, bit 21)
kayeroof:CfgCmd(21, "sim/operation/test_none")

-- MODE SEL (Button, bit 22)
kayeroof:CfgCmd(22, "sim/operation/test_none")

-- RTKPUMPS1 (Button, bit 23)
kayeroof:CfgCmd(23, "sim/operation/test_none")

-- RTKPUMPS2 (Button, bit 24)
kayeroof:CfgCmd(24, "sim/operation/test_none")

-- XFEED (Button, bit 25)
kayeroof:CfgCmd(25, "sim/operation/test_none")

-- MASTER SW (Button, bit 26)
kayeroof:CfgCmd(26, "sim/operation/test_none")

-- START (Button, bit 27)
kayeroof:CfgCmd(27, "sim/operation/test_none")

-- ENG1_FIRE_TEST (Button, bit 28)
kayeroof:CfgCmd(28, "sim/operation/test_none")

-- APU_FIRE_TEST (Button, bit 29)
kayeroof:CfgCmd(29, "sim/operation/test_none")

-- CVR_TEST (Button, bit 30)
kayeroof:CfgCmd(30, "sim/operation/test_none")

-- ENG2_FIRE_TEST (Button, bit 31)
kayeroof:CfgCmd(31, "sim/operation/test_none")

-- EMER EXIT LT_ON (Button, bit 32)
kayeroof:CfgCmd(32, "sim/operation/test_none")

-- EMER EXIT LT_OFF (Button, bit 33)
kayeroof:CfgCmd(33, "sim/operation/test_none")

-- SEAT BELTS_OFF (Button, bit 34)
kayeroof:CfgCmd(34, "sim/operation/test_none")

-- NO SMOKING_OFF (Button, bit 35)
kayeroof:CfgCmd(35, "sim/operation/test_none")

-- NO SMOKING_ON (Button, bit 36)
kayeroof:CfgCmd(36, "sim/operation/test_none")

-- EXT LT_STORBE_ON (Button, bit 37)
kayeroof:CfgCmd(37, "sim/operation/test_none")

-- EXT LT_STORBE_OFF (Button, bit 38)
kayeroof:CfgCmd(38, "sim/operation/test_none")

-- EXT LT_BEACON_ON (Button, bit 39)
kayeroof:CfgCmd(39, "sim/operation/test_none")

-- EXT LT_BEACON_OFF (Button, bit 40)
kayeroof:CfgCmd(40, "sim/operation/test_none")

-- EXT LT_WING_ON (Button, bit 41)
kayeroof:CfgCmd(41, "sim/operation/test_none")

-- EXT LT_WING_OFF (Button, bit 42)
kayeroof:CfgCmd(42, "sim/operation/test_none")

-- EXT LT_NAV_NAV (Button, bit 43)
kayeroof:CfgCmd(43, "sim/operation/test_none")

-- EXT LT_NAV_OFF (Button, bit 44)
kayeroof:CfgCmd(44, "sim/operation/test_none")

-- EXT LT_RWY TURN_ON (Button, bit 45)
kayeroof:CfgCmd(45, "sim/operation/test_none")

-- EXT LT_RWY TURN_OFF (Button, bit 46)
kayeroof:CfgCmd(46, "sim/operation/test_none")

-- EXT LT_LAND_L_ON (Button, bit 47)
kayeroof:CfgCmd(47, "sim/operation/test_none")

-- EXT LT_LAND_L_PETPACT (Button, bit 48)
kayeroof:CfgCmd(48, "sim/operation/test_none")

-- EXT LT_LAND_R_ON (Button, bit 49)
kayeroof:CfgCmd(49, "sim/operation/test_none")

-- EXT LT_LAND_R_PETPACT (Button, bit 50)
kayeroof:CfgCmd(50, "sim/operation/test_none")

-- EXT LT_NOSE_TO (Button, bit 51)
kayeroof:CfgCmd(51, "sim/operation/test_none")

-- EXT LT_NOSE_OFF (Button, bit 52)
kayeroof:CfgCmd(52, "sim/operation/test_none")

-- EXT PWR (Button, bit 53)
kayeroof:CfgCmd(53, "sim/operation/test_none")

-- OUTPUT data

-- output FIRE L → output/0/state (0/1)
kayeroof:GetFireL('sim/flightmodel/engine/ENGN_N1_', 1)

-- output ANTI_ICE_ENG2_UP → output/1/state (0/1)
kayeroof:GetAntiIceEng2Up('sim/flightmodel/engine/ENGN_N1_', 1)

-- output ANTI_ICE_ENG1_DOWN → output/2/state (0/1)
kayeroof:GetAntiIceEng1Down('sim/flightmodel/engine/ENGN_N1_', 1)

-- output ANTI_ICE_ENG2_DOWN → output/3/state (0/1)
kayeroof:GetAntiIceEng2Down('sim/flightmodel/engine/ENGN_N1_', 1)

-- output ANTI_ICE_WING_DOWN → output/4/state (0/1)
kayeroof:GetAntiIceWingDown('sim/flightmodel/engine/ENGN_N1_', 1)

-- output APU BLEED DOWN → output/5/state (0/1)
kayeroof:GetApuBleedDown('sim/flightmodel/engine/ENGN_N1_', 1)

-- output EXT PWR DOWN → output/6/state (0/1)
kayeroof:GetExtPwrDown('sim/flightmodel/engine/ENGN_N1_', 1)

-- output ELEC PUMP DOWN → output/7/state (0/1)
kayeroof:GetElecPumpDown('sim/flightmodel/engine/ENGN_N1_', 1)

-- output FIRE C → output/8/state (0/1)
kayeroof:GetFireC('sim/flightmodel/engine/ENGN_N1_', 1)

-- output BAT1_DOWN → output/9/state (0/1)
kayeroof:GetBat1Down('sim/flightmodel/engine/ENGN_N1_', 1)

-- output BAT2_UP → output/10/state (0/1)
kayeroof:GetBat2Up('sim/flightmodel/engine/ENGN_N1_', 1)

-- output BAT2_DOWN → output/11/state (0/1)
kayeroof:GetBat2Down('sim/flightmodel/engine/ENGN_N1_', 1)

-- output FIRE R → output/12/state (0/1)
kayeroof:GetFireR('sim/flightmodel/engine/ENGN_N1_', 1)

-- output IR1_LOWER → output/13/state (0/1)
kayeroof:GetIr1Lower('sim/flightmodel/engine/ENGN_N1_', 1)

-- output IR1_UP → output/14/state (0/1)
kayeroof:GetIr1Up('sim/flightmodel/engine/ENGN_N1_', 1)

-- output IR2_LOWER → output/15/state (0/1)
kayeroof:GetIr2Lower('sim/flightmodel/engine/ENGN_N1_', 1)

-- output IR3_LOWER → output/16/state (0/1)
kayeroof:GetIr3Lower('sim/flightmodel/engine/ENGN_N1_', 1)

-- output EXT PWR UP → output/17/state (0/1)
kayeroof:GetExtPwrUp('sim/flightmodel/engine/ENGN_N1_', 1)

-- output ANTI_ICE_WING_UP → output/18/state (0/1)
kayeroof:GetAntiIceWingUp('sim/flightmodel/engine/ENGN_N1_', 1)

-- output APU BLEED UP → output/19/state (0/1)
kayeroof:GetApuBleedUp('sim/flightmodel/engine/ENGN_N1_', 1)

-- output ELEC PUMP UP → output/20/state (0/1)
kayeroof:GetElecPumpUp('sim/flightmodel/engine/ENGN_N1_', 1)

-- output ANTI_ICE_ENG1_UP → output/21/state (0/1)
kayeroof:GetAntiIceEng1Up('sim/flightmodel/engine/ENGN_N1_', 1)

-- output CREW SUPPLY → output/22/state (0/1)
kayeroof:GetCrewSupply('sim/flightmodel/engine/ENGN_N1_', 1)

-- output GND CTL → output/23/state (0/1)
kayeroof:GetGndCtl('sim/flightmodel/engine/ENGN_N1_', 1)

-- output BAT1_UP → output/24/state (0/1)
kayeroof:GetBat1Up('sim/flightmodel/engine/ENGN_N1_', 1)

-- output LTK PUMPS_1_UP → output/25/state (0/1)
kayeroof:GetLtkPumps1Up('sim/flightmodel/engine/ENGN_N1_', 1)

-- output LTK PUMPS_2_DOWN → output/26/state (0/1)
kayeroof:GetLtkPumps2Down('sim/flightmodel/engine/ENGN_N1_', 1)

-- output IR3_UP → output/27/state (0/1)
kayeroof:GetIr3Up('sim/flightmodel/engine/ENGN_N1_', 1)

-- output IR2_UP → output/28/state (0/1)
kayeroof:GetIr2Up('sim/flightmodel/engine/ENGN_N1_', 1)

-- output RTK PUMPS_1_UP → output/29/state (0/1)
kayeroof:GetRtkPumps1Up('sim/flightmodel/engine/ENGN_N1_', 1)

-- output LTK PUMPS_1_DOWN → output/30/state (0/1)
kayeroof:GetLtkPumps1Down('sim/flightmodel/engine/ENGN_N1_', 1)

-- output LTK PUMPS_2_UP → output/31/state (0/1)
kayeroof:GetLtkPumps2Up('sim/flightmodel/engine/ENGN_N1_', 1)

-- output PUMP 1_UP → output/32/state (0/1)
kayeroof:GetPump1Up('sim/flightmodel/engine/ENGN_N1_', 1)

-- output MODE SEL_DOWN → output/33/state (0/1)
kayeroof:GetModeSelDown('sim/flightmodel/engine/ENGN_N1_', 1)

-- output PUMP 2_DOWN → output/34/state (0/1)
kayeroof:GetPump2Down('sim/flightmodel/engine/ENGN_N1_', 1)

-- output PUMP 1_DOWN → output/35/state (0/1)
kayeroof:GetPump1Down('sim/flightmodel/engine/ENGN_N1_', 1)

-- output START_DOWN → output/36/state (0/1)
kayeroof:GetStartDown('sim/flightmodel/engine/ENGN_N1_', 1)

-- output PUMP 2_UP → output/37/state (0/1)
kayeroof:GetPump2Up('sim/flightmodel/engine/ENGN_N1_', 1)

-- output MODE SEL_UP → output/38/state (0/1)
kayeroof:GetModeSelUp('sim/flightmodel/engine/ENGN_N1_', 1)

-- output RTK PUMPS_2_DOWN → output/39/state (0/1)
kayeroof:GetRtkPumps2Down('sim/flightmodel/engine/ENGN_N1_', 1)

-- output RTK PUMPS_1_DOWN → output/40/state (0/1)
kayeroof:GetRtkPumps1Down('sim/flightmodel/engine/ENGN_N1_', 1)

-- output RTK PUMPS_2_UP → output/41/state (0/1)
kayeroof:GetRtkPumps2Up('sim/flightmodel/engine/ENGN_N1_', 1)

-- output X FEED_UP → output/42/state (0/1)
kayeroof:GetXFeedUp('sim/flightmodel/engine/ENGN_N1_', 1)

-- output X FEED_DOWN → output/43/state (0/1)
kayeroof:GetXFeedDown('sim/flightmodel/engine/ENGN_N1_', 1)

-- output MASTER SW_UP → output/44/state (0/1)
kayeroof:GetMasterSwUp('sim/flightmodel/engine/ENGN_N1_', 1)

-- output MASTER SW_DOWN → output/45/state (0/1)
kayeroof:GetMasterSwDown('sim/flightmodel/engine/ENGN_N1_', 1)

-- output START_UP → output/46/state (0/1)
kayeroof:GetStartUp('sim/flightmodel/engine/ENGN_N1_', 1)

-- output BAT1V → output/47/state (0/1)
kayeroof:GetBat1v('sim/flightmodel/engine/ENGN_N1_', 1)

-- output BAT2V → output/48/state (0/1)
kayeroof:GetBat2v('sim/flightmodel/engine/ENGN_N1_', 1)

-- output BACKLIGHT → output/49/state (0/1)
kayeroof:GetBacklight('sim/flightmodel/engine/ENGN_N1_', 1)

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
	kayeroof:SetBat1v()
	kayeroof:SetBat2v()
	kayeroof:SetBacklight()
end)
