-- *****************************************************************
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-08-10
-- MobiFlight RfA107 / Rowsfire A107 V3 for GA
-- *****************************************************************

-- Do not remove below lines: hardware detection
local rfa107 = com.sim.mf.RfA107.Open()
if not rfa107 then return end
-- Do not remove above lines: hardware detection

uluaLog('MobiFlight RfA107 for GA')

-- INPUT key bindings (keysmap bits from mobiflight/rf_a107.json)

-- FIRE-APU (Button, bit 0)
rfa107:CfgCmd(0, "sim/operation/test_none")

-- FIRE-ENG1 (Button, bit 1)
rfa107:CfgCmd(1, "sim/operation/test_none")

-- CALLS ALL (Button, bit 2)
rfa107:CfgCmd(2, "sim/operation/test_none")

-- FIRE TEST ENG2 (Button, bit 3)
rfa107:CfgCmd(3, "sim/operation/test_none")

-- FIRE TEST APU (Button, bit 4)
rfa107:CfgCmd(4, "sim/operation/test_none")

-- FIRE TEST ENG1 (Button, bit 5)
rfa107:CfgCmd(5, "sim/operation/test_none")

-- PUMPS-R STBY (Button, bit 6)
rfa107:CfgCmd(6, "sim/operation/test_none")

-- PUMPS-R MAIN (Button, bit 7)
rfa107:CfgCmd(7, "sim/operation/test_none")

-- PUMPS-R (Button, bit 8)
rfa107:CfgCmd(8, "sim/operation/test_none")

-- PUMP-CENTER TANK (Button, bit 9)
rfa107:CfgCmd(9, "sim/operation/test_none")

-- PUMPS-L (Button, bit 10)
rfa107:CfgCmd(10, "sim/operation/test_none")

-- PUMPS -L STBY (Button, bit 11)
rfa107:CfgCmd(11, "sim/operation/test_none")

-- PUMPS -L  MAIN (Button, bit 12)
rfa107:CfgCmd(12, "sim/operation/test_none")

-- EXT POWER (Button, bit 13)
rfa107:CfgCmd(13, "sim/operation/test_none")

-- BAT2 (Button, bit 14)
rfa107:CfgCmd(14, "sim/operation/test_none")

-- BAT1 (Button, bit 15)
rfa107:CfgCmd(15, "sim/operation/test_none")

-- STROBE OFF/AUTO (Button, bit 16)
rfa107:CfgCmd(16, "sim/operation/test_none")

-- STROBE AUTO/ON (Button, bit 17)
rfa107:CfgCmd(17, "sim/operation/test_none")

-- BEACON (Button, bit 18)
rfa107:CfgCmd(18, "sim/operation/test_none")

-- WING (Button, bit 19)
rfa107:CfgCmd(19, "sim/operation/test_none")

-- NAV&LOGO OFF/1 (Button, bit 20)
rfa107:CfgCmd(20, "sim/operation/test_none")

-- NAV&LOGO 1/2 (Button, bit 21)
rfa107:CfgCmd(21, "sim/operation/test_none")

-- RWY TURN OFF ON (Button, bit 22)
rfa107:CfgCmd(22, "sim/operation/test_none")

-- LAND-L RTRCT/OFF (Button, bit 23)
rfa107:CfgCmd(23, "sim/operation/test_none")

-- LAND-L OFF/ON (Button, bit 24)
rfa107:CfgCmd(24, "sim/operation/test_none")

-- LAND-R RTRCT/OFF (Button, bit 25)
rfa107:CfgCmd(25, "sim/operation/test_none")

-- LAND-R OFF/ON (Button, bit 26)
rfa107:CfgCmd(26, "sim/operation/test_none")

-- NOSE TAXI/TO (Button, bit 27)
rfa107:CfgCmd(27, "sim/operation/test_none")

-- NOSE OFF/TAXI (Button, bit 28)
rfa107:CfgCmd(28, "sim/operation/test_none")

-- SEATBELTS ON (Button, bit 29)
rfa107:CfgCmd(29, "sim/operation/test_none")

-- NO SMOKING OFF/AUTO (Button, bit 30)
rfa107:CfgCmd(30, "sim/operation/test_none")

-- FIRE-ENG2 (Button, bit 31)
rfa107:CfgCmd(31, "sim/operation/test_none")

-- ICE ENG2 (Button, bit 32)
rfa107:CfgCmd(32, "sim/operation/test_none")

-- ICE ENG1 (Button, bit 33)
rfa107:CfgCmd(33, "sim/operation/test_none")

-- ICE WING (Button, bit 34)
rfa107:CfgCmd(34, "sim/operation/test_none")

-- APU START (Button, bit 35)
rfa107:CfgCmd(35, "sim/operation/test_none")

-- APU MASTERSW (Button, bit 36)
rfa107:CfgCmd(36, "sim/operation/test_none")

-- PACK2 (Button, bit 37)
rfa107:CfgCmd(37, "sim/operation/test_none")

-- APU BLEED (Button, bit 38)
rfa107:CfgCmd(38, "sim/operation/test_none")

-- PACK1 (Button, bit 39)
rfa107:CfgCmd(39, "sim/operation/test_none")

-- PROBE WINDOW HEAT (Button, bit 40)
rfa107:CfgCmd(40, "sim/operation/test_none")

-- CREW OXYGEN SUPPLY (Button, bit 41)
rfa107:CfgCmd(41, "sim/operation/test_none")

-- GROUND CTL (Button, bit 42)
rfa107:CfgCmd(42, "sim/operation/test_none")

-- IR3 (Button, bit 43)
rfa107:CfgCmd(43, "sim/operation/test_none")

-- IR2 (Button, bit 44)
rfa107:CfgCmd(44, "sim/operation/test_none")

-- IR1 (Button, bit 45)
rfa107:CfgCmd(45, "sim/operation/test_none")

-- TERR (Button, bit 46)
rfa107:CfgCmd(46, "sim/operation/test_none")

-- LDGFLAP3 (Button, bit 47)
rfa107:CfgCmd(47, "sim/operation/test_none")

-- DOME LIGHT BRT (Button, bit 48)
rfa107:CfgCmd(48, "sim/operation/test_none")

-- DOME LIGHT DIM (Button, bit 49)
rfa107:CfgCmd(49, "sim/operation/test_none")

-- NO SMOKING AUTO/ON (Button, bit 50)
rfa107:CfgCmd(50, "sim/operation/test_none")

-- EMERGENCY EXIT OFF (Button, bit 51)
rfa107:CfgCmd(51, "sim/operation/test_none")

-- EMERGENCY EXIT ON (Button, bit 52)
rfa107:CfgCmd(52, "sim/operation/test_none")

-- ADIRS-1 OFF/NAV (Button, bit 53)
rfa107:CfgCmd(53, "sim/operation/test_none")

-- ADIRS-1 ATT (Button, bit 54)
rfa107:CfgCmd(54, "sim/operation/test_none")

-- ADIRS-3 OFF/NAV (Button, bit 55)
rfa107:CfgCmd(55, "sim/operation/test_none")

-- ADIRS-3 ATT (Button, bit 56)
rfa107:CfgCmd(56, "sim/operation/test_none")

-- ADIRS-2 OFF/NAV (Button, bit 57)
rfa107:CfgCmd(57, "sim/operation/test_none")

-- ADIRS-2 ATT (Button, bit 58)
rfa107:CfgCmd(58, "sim/operation/test_none")

-- AIR XBLEED CLOSE?AUTO (Button, bit 59)
rfa107:CfgCmd(59, "sim/operation/test_none")

-- AIR XBLEED AUTO/OPEN (Button, bit 60)
rfa107:CfgCmd(60, "sim/operation/test_none")

-- WIPER-FAST (Button, bit 61)
rfa107:CfgCmd(61, "sim/operation/test_none")

-- WIPER-OFF (Button, bit 62)
rfa107:CfgCmd(62, "sim/operation/test_none")

-- OUTPUT data

-- output_shifter IR1-1 → output/0/state, pin 0 (0/1)
rfa107:GetIr11('sim/flightmodel/engine/ENGN_N1_', 1)

-- output_shifter ADIRS ON BAT → output/1/state, pin 1 (0/1)
rfa107:GetAdirsOnBat('sim/flightmodel/engine/ENGN_N1_', 1)

-- output_shifter ENG1-FIRE-1 → output/2/state, pin 2 (0/1)
rfa107:GetEng1Fire1('sim/flightmodel/engine/ENGN_N1_', 1)

-- output_shifter AUP-FIRE-LED → output/3/state, pin 3 (0/1)
rfa107:GetAupFireLed('sim/flightmodel/engine/ENGN_N1_', 1)

-- output_shifter ENG2-FIRE-1 → output/4/state, pin 4 (0/1)
rfa107:GetEng2Fire1('sim/flightmodel/engine/ENGN_N1_', 1)

-- output_shifter LDG FLAP3-2 → output/5/state, pin 5 (0/1)
rfa107:GetLdgFlap32('sim/flightmodel/engine/ENGN_N1_', 1)

-- output_shifter RCDR GND CTL-2 → output/6/state, pin 6 (0/1)
rfa107:GetRcdrGndCtl2('sim/flightmodel/engine/ENGN_N1_', 1)

-- output_shifter OXYGEN CREW SUPPLY-2 → output/7/state, pin 7 (0/1)
rfa107:GetOxygenCrewSupply2('sim/flightmodel/engine/ENGN_N1_', 1)

-- output_shifter PUMP-L-STBY-1 → output/8/state, pin 8 (0/1)
rfa107:GetPumpLStby1('sim/flightmodel/engine/ENGN_N1_', 1)

-- output_shifter IR1-2 → output/9/state, pin 9 (0/1)
rfa107:GetIr12('sim/flightmodel/engine/ENGN_N1_', 1)

-- output_shifter IR3-1 → output/10/state, pin 10 (0/1)
rfa107:GetIr31('sim/flightmodel/engine/ENGN_N1_', 1)

-- output_shifter IR3-2 → output/11/state, pin 11 (0/1)
rfa107:GetIr32('sim/flightmodel/engine/ENGN_N1_', 1)

-- output_shifter IR2-1 → output/12/state, pin 12 (0/1)
rfa107:GetIr21('sim/flightmodel/engine/ENGN_N1_', 1)

-- output_shifter IR2-2 → output/13/state, pin 13 (0/1)
rfa107:GetIr22('sim/flightmodel/engine/ENGN_N1_', 1)

-- output_shifter PUMP-L-MAIN-1 → output/14/state, pin 14 (0/1)
rfa107:GetPumpLMain1('sim/flightmodel/engine/ENGN_N1_', 1)

-- output_shifter PUMP-L-MAIN-2 → output/15/state, pin 15 (0/1)
rfa107:GetPumpLMain2('sim/flightmodel/engine/ENGN_N1_', 1)

-- output_shifter PUMP-R-MAIN-1 → output/16/state, pin 16 (0/1)
rfa107:GetPumpRMain1('sim/flightmodel/engine/ENGN_N1_', 1)

-- output_shifter PUMP-L-STBY-2 → output/17/state, pin 17 (0/1)
rfa107:GetPumpLStby2('sim/flightmodel/engine/ENGN_N1_', 1)

-- output_shifter PUMP-L-1 → output/18/state, pin 18 (0/1)
rfa107:GetPumpL1('sim/flightmodel/engine/ENGN_N1_', 1)

-- output_shifter PUMP-L-2 → output/19/state, pin 19 (0/1)
rfa107:GetPumpL2('sim/flightmodel/engine/ENGN_N1_', 1)

-- output_shifter PUMP-CENTER-TANK-1 → output/20/state, pin 20 (0/1)
rfa107:GetPumpCenterTank1('sim/flightmodel/engine/ENGN_N1_', 1)

-- output_shifter PUMP-CENTER-TANK-2 → output/21/state, pin 21 (0/1)
rfa107:GetPumpCenterTank2('sim/flightmodel/engine/ENGN_N1_', 1)

-- output_shifter PUMP-R-1 → output/22/state, pin 22 (0/1)
rfa107:GetPumpR1('sim/flightmodel/engine/ENGN_N1_', 1)

-- output_shifter PUMP-R-2 → output/23/state, pin 23 (0/1)
rfa107:GetPumpR2('sim/flightmodel/engine/ENGN_N1_', 1)

-- output_shifter EXTERNAL PWR-1 → output/24/state, pin 24 (0/1)
rfa107:GetExternalPwr1('sim/flightmodel/engine/ENGN_N1_', 1)

-- output_shifter PUMP-R-MAIN-2 → output/25/state, pin 25 (0/1)
rfa107:GetPumpRMain2('sim/flightmodel/engine/ENGN_N1_', 1)

-- output_shifter PUMP-R-STBY-1 → output/26/state, pin 26 (0/1)
rfa107:GetPumpRStby1('sim/flightmodel/engine/ENGN_N1_', 1)

-- output_shifter PUMP-R-STBY-2 → output/27/state, pin 27 (0/1)
rfa107:GetPumpRStby2('sim/flightmodel/engine/ENGN_N1_', 1)

-- output_shifter BAT1 OFF → output/28/state, pin 28 (0/1)
rfa107:GetBat1Off('sim/flightmodel/engine/ENGN_N1_', 1)

-- output_shifter BAT1-1 → output/29/state, pin 29 (0/1)
rfa107:GetBat11('sim/flightmodel/engine/ENGN_N1_', 1)

-- output_shifter BAT2-2 → output/30/state, pin 30 (0/1)
rfa107:GetBat22('sim/flightmodel/engine/ENGN_N1_', 1)

-- output_shifter BAT2-1 → output/31/state, pin 31 (0/1)
rfa107:GetBat21('sim/flightmodel/engine/ENGN_N1_', 1)

-- output_shifter PACK2-1 → output/32/state, pin 0 (0/1)
rfa107:GetPack21('sim/flightmodel/engine/ENGN_N1_', 1)

-- output_shifter EXTERNAL PWR-2 → output/33/state, pin 1 (0/1)
rfa107:GetExternalPwr2('sim/flightmodel/engine/ENGN_N1_', 1)

-- output_shifter PROBE WINDOW HEAT-2 → output/34/state, pin 3 (0/1)
rfa107:GetProbeWindowHeat2('sim/flightmodel/engine/ENGN_N1_', 1)

-- output_shifter PACK1-1 → output/35/state, pin 4 (0/1)
rfa107:GetPack11('sim/flightmodel/engine/ENGN_N1_', 1)

-- output_shifter PACK1-2 → output/36/state, pin 5 (0/1)
rfa107:GetPack12('sim/flightmodel/engine/ENGN_N1_', 1)

-- output_shifter APU BLEED-1 → output/37/state, pin 6 (0/1)
rfa107:GetApuBleed1('sim/flightmodel/engine/ENGN_N1_', 1)

-- output_shifter APU BLEED-2 → output/38/state, pin 7 (0/1)
rfa107:GetApuBleed2('sim/flightmodel/engine/ENGN_N1_', 1)

-- output_shifter ANTI ICE ENG2-1 → output/39/state, pin 8 (0/1)
rfa107:GetAntiIceEng21('sim/flightmodel/engine/ENGN_N1_', 1)

-- output_shifter PACK2-2 → output/40/state, pin 9 (0/1)
rfa107:GetPack22('sim/flightmodel/engine/ENGN_N1_', 1)

-- output_shifter APU MASTERSW-1 → output/41/state, pin 10 (0/1)
rfa107:GetApuMastersw1('sim/flightmodel/engine/ENGN_N1_', 1)

-- output_shifter APU MASTERSW-2 → output/42/state, pin 11 (0/1)
rfa107:GetApuMastersw2('sim/flightmodel/engine/ENGN_N1_', 1)

-- output_shifter ANTI ICE WING-1 → output/43/state, pin 12 (0/1)
rfa107:GetAntiIceWing1('sim/flightmodel/engine/ENGN_N1_', 1)

-- output_shifter ANTI ICE WING-2 → output/44/state, pin 13 (0/1)
rfa107:GetAntiIceWing2('sim/flightmodel/engine/ENGN_N1_', 1)

-- output_shifter ANTI ICE ENG1-1 → output/45/state, pin 14 (0/1)
rfa107:GetAntiIceEng11('sim/flightmodel/engine/ENGN_N1_', 1)

-- output_shifter ANTI ICE ENG1-2 → output/46/state, pin 15 (0/1)
rfa107:GetAntiIceEng12('sim/flightmodel/engine/ENGN_N1_', 1)

-- output_shifter ANTI ICE ENG2-2 → output/47/state, pin 17 (0/1)
rfa107:GetAntiIceEng22('sim/flightmodel/engine/ENGN_N1_', 1)

-- output_shifter APU START-1 → output/48/state, pin 18 (0/1)
rfa107:GetApuStart1('sim/flightmodel/engine/ENGN_N1_', 1)

-- output_shifter APU START-2 → output/49/state, pin 19 (0/1)
rfa107:GetApuStart2('sim/flightmodel/engine/ENGN_N1_', 1)

-- output_shifter EMER EXIT LT → output/50/state, pin 22 (0/1)
rfa107:GetEmerExitLt('sim/flightmodel/engine/ENGN_N1_', 1)

-- output A107 BACKLIGHT → output/51/state (0/1)
rfa107:GetA107Backlight('sim/flightmodel/engine/ENGN_N1_', 1)

-- PAP3 LedModule BAT 1+2
rfa107:GetBat12('sim/flightmodel/engine/ENGN_N1_', 'sim/flightmodel/engine/ENGN_N1_')

GlobalFrameLoopManager:add(function()
	rfa107:SetIr11()
	rfa107:SetAdirsOnBat()
	rfa107:SetEng1Fire1()
	rfa107:SetAupFireLed()
	rfa107:SetEng2Fire1()
	rfa107:SetLdgFlap32()
	rfa107:SetRcdrGndCtl2()
	rfa107:SetOxygenCrewSupply2()
	rfa107:SetPumpLStby1()
	rfa107:SetIr12()
	rfa107:SetIr31()
	rfa107:SetIr32()
	rfa107:SetIr21()
	rfa107:SetIr22()
	rfa107:SetPumpLMain1()
	rfa107:SetPumpLMain2()
	rfa107:SetPumpRMain1()
	rfa107:SetPumpLStby2()
	rfa107:SetPumpL1()
	rfa107:SetPumpL2()
	rfa107:SetPumpCenterTank1()
	rfa107:SetPumpCenterTank2()
	rfa107:SetPumpR1()
	rfa107:SetPumpR2()
	rfa107:SetExternalPwr1()
	rfa107:SetPumpRMain2()
	rfa107:SetPumpRStby1()
	rfa107:SetPumpRStby2()
	rfa107:SetBat1Off()
	rfa107:SetBat11()
	rfa107:SetBat22()
	rfa107:SetBat21()
	rfa107:SetPack21()
	rfa107:SetExternalPwr2()
	rfa107:SetProbeWindowHeat2()
	rfa107:SetPack11()
	rfa107:SetPack12()
	rfa107:SetApuBleed1()
	rfa107:SetApuBleed2()
	rfa107:SetAntiIceEng21()
	rfa107:SetPack22()
	rfa107:SetApuMastersw1()
	rfa107:SetApuMastersw2()
	rfa107:SetAntiIceWing1()
	rfa107:SetAntiIceWing2()
	rfa107:SetAntiIceEng11()
	rfa107:SetAntiIceEng12()
	rfa107:SetAntiIceEng22()
	rfa107:SetApuStart1()
	rfa107:SetApuStart2()
	rfa107:SetEmerExitLt()
	rfa107:SetA107Backlight()
	rfa107:SetBat12()
end)
