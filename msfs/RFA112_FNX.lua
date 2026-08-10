-- *****************************************************************
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-08-11
-- MobiFlight RfA112 / Rowsfire A112 for Fenix A320 (weather radar)
-- MSFS bindings from: Rowsfire A112-FENIX A320-RADAR.mfproj
-- *****************************************************************
if ilua_require_fenix_a320() then return end

-- Do not remove below lines: hardware detection
local rfa112 = com.sim.mf.RfA112.Open()
if not rfa112 then return end
-- Do not remove above lines: hardware detection

uluaLog('MobiFlight RfA112 for Fenix A320 radar')

-- ===========================================================
-- AnalogInput: CfgAnalog(bit, store, baseline, scale [, lo, hi [, postOffset]])
-- value = (baseline - adc) / scale [- postOffset], clamp default [0,1]

---- MAIN PNL flood (bit 0 / DeviceName MAINPNL)
rfa112:CfgAnalog(0, '(>L:A_MIP_LIGHTING_FLOOD_MAIN)', 220, 219)

---- MAIN PNL&PED pedestal light (bit 1 / DeviceName MAINPNL&PED)
rfa112:CfgAnalog(1, '(>L:A_PED_LIGHTING_PEDESTAL)', 220, 219)

---- GAIN (bit 2 / DeviceName GAIN)
rfa112:CfgAnalog(2, '(>L:A_WR_GAIN)', 230, 22.7778, -5, 4, 5)

---- TILT (bit 3 / DeviceName TILI)
rfa112:CfgAnalog(3, '(>L:A_WR_TILT)', 220, 4.8333, -15, 15, 15)

-- ===========================================================
-- button binding (keysmap bits from mobiflight/rf_a112.json)

-- WX (bit 4)
rfa112:CfgRpn(4, '0 (>L:S_WR_MODE)')

-- WX+T (bit 5)
rfa112:CfgRpn(5, '1 (>L:S_WR_MODE)')

-- WX+T+HZD (bit 6)
rfa112:CfgRpn(6, '2 (>L:S_WR_MODE)')

-- MAP (bit 7)
rfa112:CfgRpn(7, '3 (>L:S_WR_MODE)')

-- MULTISCAN (bit 8)
rfa112:CfgRpn(8, '0 (>L:S_WR_MULTISCAN)', '1 (>L:S_WR_MULTISCAN)')

-- GCS (bit 9)
rfa112:CfgRpn(9, '0 (>L:S_WR_GCS)', '1 (>L:S_WR_GCS)')

-- SYS 1 (bit 10)
rfa112:CfgRpn(10, '0 (>L:S_WR_SYS)', '1 (>L:S_WR_SYS)')

-- SYS 2 (bit 11)
rfa112:CfgRpn(11, '2 (>L:S_WR_SYS)', '1 (>L:S_WR_SYS)')

-- PWS (bit 12)
rfa112:CfgRpn(12, '0 (>L:S_WR_PRED_WS)', '1 (>L:S_WR_PRED_WS)')

-- ===========================================================
-- Read data for lights (Get* — keep all channels)

-- MIP-LT (PWM pedestal light → 0–255)
rfa112:GetMipLt('(L:A_PED_LIGHTING_PEDESTAL) 255 *', 1)

GlobalFrameLoopManager:add(function()
	rfa112:PollAnalogs()
	rfa112:SetMipLt()
end)
