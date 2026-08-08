-- *****************************************************************
-- WwPdc3n (captain / 3N L) for Zibo B738
-- Ported from WINCTRL zibo-pdc-profile (3N button index column)
-- *****************************************************************

if ilua_require_zibo() then return end

-- Do not remove below lines: hardware detection
local wwpdc3n = com.sim.qm.Wwpdc3n.Open()
if not wwpdc3n then return end
-- Do not remove above lines: hardware detection

uluaLog('Wwpdc3n for Zibo (capt)')

local side = 'capt'
local pilot = 'pilot'
local cptFo = 'cpt'

function wwpdc3n_zibo_seek(posRef, dnCmd, upCmd, target)
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

-------------------- Input Keys Binding ---------------------
wwpdc3n:CfgCmd(0, 'laminar/B738/EFIS_control/' .. side .. '/push_button/fpv_press')
wwpdc3n:CfgCmd(1, 'laminar/B738/EFIS_control/' .. side .. '/push_button/mtrs_press')
wwpdc3n:CfgCmd(2, 'laminar/B738/EFIS_control/' .. side .. '/push_button/wxr_press')
wwpdc3n:CfgCmd(3, 'laminar/B738/EFIS_control/' .. side .. '/push_button/sta_press')
wwpdc3n:CfgCmd(4, 'laminar/B738/EFIS_control/' .. side .. '/push_button/wpt_press')
wwpdc3n:CfgCmd(5, 'laminar/B738/EFIS_control/' .. side .. '/push_button/arpt_press')
wwpdc3n:CfgCmd(6, 'laminar/B738/EFIS_control/' .. side .. '/push_button/data_press')
wwpdc3n:CfgCmd(7, 'laminar/B738/EFIS_control/' .. side .. '/push_button/pos_press')
wwpdc3n:CfgCmd(8, 'laminar/B738/EFIS_control/' .. side .. '/push_button/terr_press')

wwpdc3n:CfgFc(9, 'wwpdc3n_zibo_seek("laminar/B738/EFIS_control/capt/vor1_off_pos","laminar/B738/EFIS_control/capt/vor1_off_dn","laminar/B738/EFIS_control/capt/vor1_off_up",1)')
wwpdc3n:CfgFc(10, 'wwpdc3n_zibo_seek("laminar/B738/EFIS_control/capt/vor1_off_pos","laminar/B738/EFIS_control/capt/vor1_off_dn","laminar/B738/EFIS_control/capt/vor1_off_up",0)')
wwpdc3n:CfgFc(11, 'wwpdc3n_zibo_seek("laminar/B738/EFIS_control/capt/vor1_off_pos","laminar/B738/EFIS_control/capt/vor1_off_dn","laminar/B738/EFIS_control/capt/vor1_off_up",-1)')
wwpdc3n:CfgFc(12, 'wwpdc3n_zibo_seek("laminar/B738/EFIS_control/capt/vor2_off_pos","laminar/B738/EFIS_control/capt/vor2_off_dn","laminar/B738/EFIS_control/capt/vor2_off_up",1)')
wwpdc3n:CfgFc(13, 'wwpdc3n_zibo_seek("laminar/B738/EFIS_control/capt/vor2_off_pos","laminar/B738/EFIS_control/capt/vor2_off_dn","laminar/B738/EFIS_control/capt/vor2_off_up",0)')
wwpdc3n:CfgFc(14, 'wwpdc3n_zibo_seek("laminar/B738/EFIS_control/capt/vor2_off_pos","laminar/B738/EFIS_control/capt/vor2_off_dn","laminar/B738/EFIS_control/capt/vor2_off_up",-1)')

wwpdc3n:CfgCmd(15, 'laminar/B738/EFIS_control/' .. side .. '/push_button/rst_press')
wwpdc3n:CfgCmd(16, 'laminar/B738/EFIS_control/' .. side .. '/push_button/ctr_press')
wwpdc3n:CfgCmd(17, 'laminar/B738/EFIS_control/' .. side .. '/push_button/tfc_press')
wwpdc3n:CfgCmd(18, 'laminar/B738/EFIS_control/' .. side .. '/push_button/std_press')

wwpdc3n:CfgCmd(19, 'laminar/B738/pfd/dh_' .. pilot .. '_dn')
wwpdc3n:CfgCmd(20, 'laminar/B738/pfd/dh_' .. pilot .. '_up')
wwpdc3n:CfgCmd(21, 'laminar/B738/' .. pilot .. '/barometer_down')
wwpdc3n:CfgCmd(22, 'laminar/B738/' .. pilot .. '/barometer_up')

-- mins RADIO/BARO: up/dn inverted in Zibo (WINCTRL note)
wwpdc3n:CfgFc(23, 'wwpdc3n_zibo_seek("laminar/B738/EFIS_control/cpt/minimums","laminar/B738/EFIS_control/cpt/minimums_up","laminar/B738/EFIS_control/cpt/minimums_dn",0)')
wwpdc3n:CfgFc(24, 'wwpdc3n_zibo_seek("laminar/B738/EFIS_control/cpt/minimums","laminar/B738/EFIS_control/cpt/minimums_up","laminar/B738/EFIS_control/cpt/minimums_dn",1)')
wwpdc3n:CfgFc(25, 'wwpdc3n_zibo_seek("laminar/B738/EFIS_control/capt/baro_in_hpa","laminar/B738/EFIS_control/capt/baro_in_hpa_dn","laminar/B738/EFIS_control/capt/baro_in_hpa_up",0)')
wwpdc3n:CfgFc(26, 'wwpdc3n_zibo_seek("laminar/B738/EFIS_control/capt/baro_in_hpa","laminar/B738/EFIS_control/capt/baro_in_hpa_dn","laminar/B738/EFIS_control/capt/baro_in_hpa_up",1)')

wwpdc3n:CfgVal(27, 'laminar/B738/EFIS_control/' .. side .. '/map_mode_pos', 0)
wwpdc3n:CfgVal(28, 'laminar/B738/EFIS_control/' .. side .. '/map_mode_pos', 1)
wwpdc3n:CfgVal(29, 'laminar/B738/EFIS_control/' .. side .. '/map_mode_pos', 2)
wwpdc3n:CfgVal(30, 'laminar/B738/EFIS_control/' .. side .. '/map_mode_pos', 3)

wwpdc3n:CfgVal(31, 'laminar/B738/EFIS/' .. side .. '/map_range', 0)
wwpdc3n:CfgVal(32, 'laminar/B738/EFIS/' .. side .. '/map_range', 1)
wwpdc3n:CfgVal(33, 'laminar/B738/EFIS/' .. side .. '/map_range', 2)
wwpdc3n:CfgVal(34, 'laminar/B738/EFIS/' .. side .. '/map_range', 3)
wwpdc3n:CfgVal(35, 'laminar/B738/EFIS/' .. side .. '/map_range', 4)
wwpdc3n:CfgVal(36, 'laminar/B738/EFIS/' .. side .. '/map_range', 5)
wwpdc3n:CfgVal(37, 'laminar/B738/EFIS/' .. side .. '/map_range', 6)
wwpdc3n:CfgVal(38, 'laminar/B738/EFIS/' .. side .. '/map_range', 7)

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
	wwpdc3n:SendLedCmd(wwpdc3n.LEDS_BKL, bkl)
end)
