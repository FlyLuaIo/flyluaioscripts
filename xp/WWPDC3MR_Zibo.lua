-- *****************************************************************
-- WwPdc3mR (FO / 3M R) for Zibo B738
-- Ported from WINCTRL zibo-pdc-profile (3M button index column)
-- *****************************************************************

if ilua_require_zibo() then return end

-- Do not remove below lines: hardware detection
local wwpdc3mr = com.sim.qm.Wwpdc3mr.Open()
if not wwpdc3mr then return end
-- Do not remove above lines: hardware detection

uluaLog('Wwpdc3mr for Zibo (FO)')

function wwpdc3mr_zibo_seek(posRef, dnCmd, upCmd, target)
	local dr = uluaFind(posRef)
	if not dr then return end
	local cur = uluaGet(dr)
	local cmdDn = uluaFind(dnCmd)
	local cmdUp = uluaFind(upCmd)
	if cur < target then
		for _ = cur, target - 1 do uluaCmdOnce(cmdUp) end
	elseif cur > target then
		for _ = target, cur - 1 do uluaCmdOnce(cmdDn) end
	end
end

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

wwpdc3mr:CfgFc(10, 'wwpdc3mr_zibo_seek("laminar/B738/EFIS_control/fo/vor1_off_pos","laminar/B738/EFIS_control/fo/vor1_off_dn","laminar/B738/EFIS_control/fo/vor1_off_up",1)')
wwpdc3mr:CfgFc(11, 'wwpdc3mr_zibo_seek("laminar/B738/EFIS_control/fo/vor1_off_pos","laminar/B738/EFIS_control/fo/vor1_off_dn","laminar/B738/EFIS_control/fo/vor1_off_up",0)')
wwpdc3mr:CfgFc(12, 'wwpdc3mr_zibo_seek("laminar/B738/EFIS_control/fo/vor1_off_pos","laminar/B738/EFIS_control/fo/vor1_off_dn","laminar/B738/EFIS_control/fo/vor1_off_up",-1)')
wwpdc3mr:CfgFc(13, 'wwpdc3mr_zibo_seek("laminar/B738/EFIS_control/fo/vor2_off_pos","laminar/B738/EFIS_control/fo/vor2_off_dn","laminar/B738/EFIS_control/fo/vor2_off_up",1)')
wwpdc3mr:CfgFc(14, 'wwpdc3mr_zibo_seek("laminar/B738/EFIS_control/fo/vor2_off_pos","laminar/B738/EFIS_control/fo/vor2_off_dn","laminar/B738/EFIS_control/fo/vor2_off_up",0)')
wwpdc3mr:CfgFc(15, 'wwpdc3mr_zibo_seek("laminar/B738/EFIS_control/fo/vor2_off_pos","laminar/B738/EFIS_control/fo/vor2_off_dn","laminar/B738/EFIS_control/fo/vor2_off_up",-1)')

wwpdc3mr:CfgCmd(16, 'laminar/B738/EFIS_control/fo/push_button/rst_press')
wwpdc3mr:CfgCmd(17, 'laminar/B738/EFIS_control/fo/push_button/ctr_press')
wwpdc3mr:CfgCmd(18, 'laminar/B738/EFIS_control/fo/push_button/tfc_press')
wwpdc3mr:CfgCmd(19, 'laminar/B738/EFIS_control/fo/push_button/std_press')
wwpdc3mr:CfgCmd(20, 'laminar/B738/EFIS_control/fo/map_range_dn')
wwpdc3mr:CfgCmd(21, 'laminar/B738/EFIS_control/fo/map_range_up')
wwpdc3mr:CfgCmd(22, 'laminar/B738/copilot/barometer_down')
wwpdc3mr:CfgCmd(23, 'laminar/B738/copilot/barometer_up')

wwpdc3mr:CfgFc(24, 'wwpdc3mr_zibo_seek("laminar/B738/EFIS_control/fo/minimums","laminar/B738/EFIS_control/fo/minimums_up","laminar/B738/EFIS_control/fo/minimums_dn",0)')
wwpdc3mr:CfgFc(25, 'wwpdc3mr_zibo_seek("laminar/B738/EFIS_control/fo/minimums","laminar/B738/EFIS_control/fo/minimums_up","laminar/B738/EFIS_control/fo/minimums_dn",1)')
wwpdc3mr:CfgFc(26, 'wwpdc3mr_zibo_seek("laminar/B738/EFIS_control/fo/baro_in_hpa","laminar/B738/EFIS_control/fo/baro_in_hpa_dn","laminar/B738/EFIS_control/fo/baro_in_hpa_up",0)')
wwpdc3mr:CfgFc(27, 'wwpdc3mr_zibo_seek("laminar/B738/EFIS_control/fo/baro_in_hpa","laminar/B738/EFIS_control/fo/baro_in_hpa_dn","laminar/B738/EFIS_control/fo/baro_in_hpa_up",1)')

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
