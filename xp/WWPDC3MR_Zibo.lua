-- *****************************************************************
-- WwPdc3mR (FO / 3M R) for Zibo B738
-- *****************************************************************

if ilua_require_zibo() then return end

-- Do not remove below lines: hardware detection
local wwpdc3mr = com.sim.qm.Wwpdc3mr.Open()
if not wwpdc3mr then return end
-- Do not remove above lines: hardware detection

uluaLog('Wwpdc3mr for Zibo (FO)')

-------------------- Input Keys Binding (3M indices) ---------------------
wwpdc3mr:CfgCmd(0, 'laminar/B738/EFIS_control/fo/push_button/fpv_press')
wwpdc3mr:CfgCmd(1, 'laminar/B738/EFIS_control/fo/push_button/mtrs_press')
-- 2: 3M VSD unused
wwpdc3mr:CfgCmd(3, 'laminar/B738/EFIS_control/fo/push_button/wxr_press')
wwpdc3mr:CfgCmd(4, 'laminar/B738/EFIS_control/fo/push_button/sta_press')
wwpdc3mr:CfgCmd(5, 'laminar/B738/EFIS_control/fo/push_button/wpt_press')
wwpdc3mr:CfgCmd(6, 'laminar/B738/EFIS_control/fo/push_button/arpt_press')
wwpdc3mr:CfgCmd(7, 'laminar/B738/EFIS_control/fo/push_button/data_press')
wwpdc3mr:CfgCmd(8, 'laminar/B738/EFIS_control/fo/push_button/pos_press')
wwpdc3mr:CfgCmd(9, 'laminar/B738/EFIS_control/fo/push_button/terr_press')

-- VOR1 selector (Buttons 11..13 -> bits 10..12: VOR / OFF / ADF)
local pswh_vor1 = QmdevPosSwitchInit("laminar/B738/EFIS_control/fo/vor1_off_pos", 1,
	"laminar/B738/EFIS_control/fo/vor1_off_up", "laminar/B738/EFIS_control/fo/vor1_off_dn", 300)
wwpdc3mr:CfgPSw(10, pswh_vor1, 1)  -- VOR
wwpdc3mr:CfgPSw(11, pswh_vor1, 0)  -- OFF
wwpdc3mr:CfgPSw(12, pswh_vor1, -1) -- ADF

-- VOR2 selector (Buttons 14..16 -> bits 13..15: VOR / OFF / ADF)
local pswh_vor2 = QmdevPosSwitchInit("laminar/B738/EFIS_control/fo/vor2_off_pos", 1,
	"laminar/B738/EFIS_control/fo/vor2_off_up", "laminar/B738/EFIS_control/fo/vor2_off_dn", 300)
wwpdc3mr:CfgPSw(13, pswh_vor2, 1)  -- VOR
wwpdc3mr:CfgPSw(14, pswh_vor2, 0)  -- OFF
wwpdc3mr:CfgPSw(15, pswh_vor2, -1) -- ADF

wwpdc3mr:CfgCmd(16, 'laminar/B738/EFIS_control/fo/push_button/rst_press')
wwpdc3mr:CfgCmd(17, 'laminar/B738/EFIS_control/fo/push_button/ctr_press')
wwpdc3mr:CfgCmd(18, 'laminar/B738/EFIS_control/fo/push_button/tfc_press')
wwpdc3mr:CfgCmd(19, 'laminar/B738/EFIS_control/fo/push_button/std_press')
wwpdc3mr:CfgCmd(20, 'laminar/B738/EFIS_control/fo/map_range_dn')
wwpdc3mr:CfgCmd(21, 'laminar/B738/EFIS_control/fo/map_range_up')
wwpdc3mr:CfgCmd(22, 'laminar/B738/copilot/barometer_down')
wwpdc3mr:CfgCmd(23, 'laminar/B738/copilot/barometer_up')

-- mins RADIO/BARO: up/dn inverted in Zibo (WINCTRL note)
local pswh_mins = QmdevPosSwitchInit("laminar/B738/EFIS_control/fo/minimums", 1,
	"laminar/B738/EFIS_control/fo/minimums_dn", "laminar/B738/EFIS_control/fo/minimums_up", 300)
wwpdc3mr:CfgPSw(24, pswh_mins, 0) -- RADIO
wwpdc3mr:CfgPSw(25, pswh_mins, 1) -- BARO

local pswh_baro = QmdevPosSwitchInit("laminar/B738/EFIS_control/fo/baro_in_hpa", 1,
	"laminar/B738/EFIS_control/fo/baro_in_hpa_up", "laminar/B738/EFIS_control/fo/baro_in_hpa_dn", 300)
wwpdc3mr:CfgPSw(26, pswh_baro, 0) -- IN
wwpdc3mr:CfgPSw(27, pswh_baro, 1) -- HPA

wwpdc3mr:CfgVal(28, 'laminar/B738/EFIS_control/fo/map_mode_pos', 0)
wwpdc3mr:CfgVal(29, 'laminar/B738/EFIS_control/fo/map_mode_pos', 1)
wwpdc3mr:CfgVal(30, 'laminar/B738/EFIS_control/fo/map_mode_pos', 2)
wwpdc3mr:CfgVal(31, 'laminar/B738/EFIS_control/fo/map_mode_pos', 3)

wwpdc3mr:CfgCmd(32, 'laminar/B738/pfd/dh_copilot_dn')
wwpdc3mr:CfgCmd(36, 'laminar/B738/pfd/dh_copilot_up')

-------------------- Backlight ---------------------
local dr_power = iDataRef:New('sim/cockpit/electrical/avionics_on')
local dr_main = iDataRef:New('laminar/B738/electric/main_bus')
local dr_panel = iDataRef:New('laminar/B738/electric/panel_brightness[0]')

GlobalFrameLoopManager:add(function()
	local hasPower = dr_power:Get() ~= 0
	local hasMain = dr_main:Get() ~= 0
	local ratio = hasMain and dr_panel:Get() or 0.5
	if ratio < 0 then ratio = 0 elseif ratio > 1 then ratio = 1 end
	local bkl = hasPower and math.floor(ratio * 255) or 0
	wwpdc3mr:SendLedCmd(wwpdc3mr.LEDS_BKL, bkl)
end)
