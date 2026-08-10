-- *****************************************************************
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-08-11
-- MobiFlight RfA112 / Rowsfire A112 for GA
-- *****************************************************************

-- Do not remove below lines: hardware detection
local rfa112 = com.sim.mf.RfA112.Open()
if not rfa112 then return end
-- Do not remove above lines: hardware detection

uluaLog('MobiFlight RfA112 for GA')

-- INPUT key bindings (keysmap bits from mobiflight/rf_a112.json)
-- AnalogInput bits 0..3: CfgAnalog(bit, store, baseline, scale, lo, hi [, postOffset])

-- WX (Button, bit 4)
rfa112:CfgCmd(4, "sim/operation/test_none")

-- WX+T (Button, bit 5)
rfa112:CfgCmd(5, "sim/operation/test_none")

-- WX+T+HZD (Button, bit 6)
rfa112:CfgCmd(6, "sim/operation/test_none")

-- MAP (Button, bit 7)
rfa112:CfgCmd(7, "sim/operation/test_none")

-- MULTISCAN (Button, bit 8)
rfa112:CfgCmd(8, "sim/operation/test_none")

-- GCS (Button, bit 9)
rfa112:CfgCmd(9, "sim/operation/test_none")

-- SYS 1 (Button, bit 10)
rfa112:CfgCmd(10, "sim/operation/test_none")

-- SYS 2 (Button, bit 11)
rfa112:CfgCmd(11, "sim/operation/test_none")

-- PWS (Button, bit 12)
rfa112:CfgCmd(12, "sim/operation/test_none")

-- OUTPUT data

-- output MIP-LT → output/0/state (0–255 PWM)
rfa112:GetMipLt('sim/flightmodel/engine/ENGN_N1_', 1)

GlobalFrameLoopManager:add(function()
	rfa112:SetMipLt()
end)
