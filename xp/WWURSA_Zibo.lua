-- *****************************************************************
-- WwUrsa for Zibo B738 (ported from WINCTRL zibo-ursa-minor-throttle-profile)
-- *****************************************************************

if ilua_require_zibo() then return end

-- Do not remove below lines: hardware detection
local wwursa = com.sim.qm.Wwursa.Open()
if not wwursa then return end
-- Do not remove above lines: hardware detection

uluaLog('Wwursa for Zibo')

function wwursa_zibo_seek(posRef, dnCmd, upCmd, target)
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

function wwursa_zibo_multi(...)
	for i = 1, select('#', ...) do
		local cmd = uluaFind((select(i, ...)))
		if cmd then uluaCmdOnce(cmd) end
	end
end

_G.wwursa_zibo_flap_last = _G.wwursa_zibo_flap_last or {}
function wwursa_zibo_flap(cmd, token)
	if _G.wwursa_zibo_flap_last[cmd] == token then return end
	_G.wwursa_zibo_flap_last[cmd] = token
	local c = uluaFind(cmd)
	if c then uluaCmdOnce(c) end
end

-------------------- Input Keys Binding ---------------------
wwursa:CfgCmd(0, 'laminar/B738/engine/mixture1_idle')
wwursa:CfgCmd(1, 'laminar/B738/engine/mixture1_cutoff')
wwursa:CfgCmd(2, 'laminar/B738/engine/mixture2_idle')
wwursa:CfgCmd(3, 'laminar/B738/engine/mixture2_cutoff')

wwursa:CfgFc(6, 'wwursa_zibo_multi("laminar/B738/rotary/eng1_start_grd","laminar/B738/rotary/eng2_start_grd")')
wwursa:CfgFc(7, 'wwursa_zibo_multi("laminar/B738/rotary/eng1_start_off","laminar/B738/rotary/eng2_start_off")')
wwursa:CfgFc(8, 'wwursa_zibo_multi("laminar/B738/rotary/eng1_start_cont","laminar/B738/rotary/eng2_start_cont")')

wwursa:CfgCmd(9, 'laminar/B738/autopilot/left_at_dis_press')
wwursa:CfgCmd(10, 'laminar/B738/autopilot/right_at_dis_press')

wwursa:CfgCmd(24, 'sim/flight_controls/rudder_trim_center')
wwursa:CfgCmd(25, 'sim/flight_controls/rudder_trim_left')
wwursa:CfgCmd(27, 'sim/flight_controls/rudder_trim_right')

wwursa:CfgFc(28, 'wwursa_zibo_seek("laminar/B738/parking_brake_pos","laminar/B738/push_button/park_brake_on_off","laminar/B738/push_button/park_brake_on_off",0)')
wwursa:CfgFc(29, 'wwursa_zibo_seek("laminar/B738/parking_brake_pos","laminar/B738/push_button/park_brake_on_off","laminar/B738/push_button/park_brake_on_off",1)')

wwursa:CfgFc(30, 'wwursa_zibo_flap("laminar/B738/push_button/flaps_30",5)')
wwursa:CfgFc(31, 'wwursa_zibo_flap("laminar/B738/push_button/flaps_25",4)')
wwursa:CfgFc(32, 'wwursa_zibo_flap("laminar/B738/push_button/flaps_15",3)')
wwursa:CfgFc(33, 'wwursa_zibo_flap("laminar/B738/push_button/flaps_5",2)')
wwursa:CfgFc(34, 'wwursa_zibo_flap("laminar/B738/push_button/flaps_0",1)')

-------------------- Output ---------------------
local dr_power = iDataRef:New('sim/cockpit/electrical/avionics_on')
local dr_main = iDataRef:New('laminar/B738/electric/main_bus')
local dr_panel = iDataRef:New('laminar/B738/electric/panel_brightness[3]')
local dr_trim = iDataRef:New('sim/flightmodel/controls/vstab2_rud1def')
local dr_fire1 = iDataRef:New('laminar/B738/annunciator/engine1_fire')
local dr_fire2 = iDataRef:New('laminar/B738/annunciator/engine2_fire')

GlobalFrameLoopManager:add(function()
	local hasPower = dr_power:Get() ~= 0
	local hasMain = dr_main:Get() ~= 0
	local ratio = hasMain and dr_panel:Get() or 0.5
	if ratio < 0 then ratio = 0 elseif ratio > 1 then ratio = 1 end
	local bkl = hasPower and math.floor(ratio * 255) or 0
	wwursa:SendLedCmd(wwursa.LEDS_BKL, bkl)
	wwursa:SendLedCmd(wwursa.LEDS_MAKER, hasPower and 255 or 0)

	wwursa:SendLedCmd(wwursa.LEDS_FAULT1, 0)
	wwursa:SendLedCmd(wwursa.LEDS_FIRE1, dr_fire1:Get() > 0 and 1 or 0)
	wwursa:SendLedCmd(wwursa.LEDS_FAULT2, 0)
	wwursa:SendLedCmd(wwursa.LEDS_FIRE2, dr_fire2:Get() > 0 and 1 or 0)

	wwursa:setLcdText(wwursa:formatTrimText(dr_trim:Get(), false))
end)
