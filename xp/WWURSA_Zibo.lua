-- *****************************************************************
-- WwUrsa for Zibo B738 (ported from WINCTRL zibo-ursa-minor-throttle-profile)
-- *****************************************************************

if ilua_require_zibo() then return end

-- Do not remove below lines: hardware detection
local wwursa = com.sim.qm.Wwursa.Open()
if not wwursa then return end
-- Do not remove above lines: hardware detection

uluaLog('Wwursa for Zibo')

-------------------- Input Keys Binding ---------------------
wwursa:CfgCmd(0, 'laminar/B738/engine/mixture1_idle')
wwursa:CfgCmd(1, 'laminar/B738/engine/mixture1_cutoff')
wwursa:CfgCmd(2, 'laminar/B738/engine/mixture2_idle')
wwursa:CfgCmd(3, 'laminar/B738/engine/mixture2_cutoff')


local pswheng1 = QmdevPosSwitchInit("laminar/B738/engine/starter1_pos", 1,
	"laminar/B738/knob/eng1_start_right",
	"laminar/B738/knob/eng1_start_left", 500)
local pswheng2 = QmdevPosSwitchInit("laminar/B738/engine/starter2_pos", 1,
	"laminar/B738/knob/eng2_start_right",
	"laminar/B738/knob/eng2_start_left", 500)
local dr_cmd_ign1 = uluaFind('laminar/B738/toggle_switch/eng_start_source_left')
local dr_cmd_ign2 = uluaFind('laminar/B738/toggle_switch/eng_start_source_right')
function eng_starter_select(idx)
	if idx == 0 then
		uluaCmdOnce(dr_cmd_ign1)
		wwursa:CfgPSw(6, pswheng1, 0)
		wwursa:CfgPSw(7, pswheng1, 1)
		wwursa:CfgPSw(8, pswheng1, 2)
	else
		uluaCmdOnce(dr_cmd_ign2)
		wwursa:CfgPSw(6, pswheng2, 0)
		wwursa:CfgPSw(7, pswheng2, 1)
		wwursa:CfgPSw(8, pswheng2, 2)
	end
end

eng_starter_select(0)
wwursa:CfgFc(4, 'eng_starter_select(0)')
wwursa:CfgFc(5, 'eng_starter_select(1)')

wwursa:CfgCmd(9, 'laminar/B738/autopilot/left_at_dis_press')
wwursa:CfgCmd(10, 'laminar/B738/autopilot/right_at_dis_press')

wwursa:CfgCmd(24, 'sim/flight_controls/rudder_trim_center')
wwursa:CfgCmd(25, 'sim/flight_controls/rudder_trim_left')
wwursa:CfgCmd(27, 'sim/flight_controls/rudder_trim_right')

local pswh28 = QmdevPosSwitchInit("laminar/B738/parking_brake_pos", 1,
	"laminar/B738/push_button/park_brake_on_off",
	"laminar/B738/push_button/park_brake_on_off")
-- Parking Brake
wwursa:CfgPSw(28, pswh28, 0, 1)


wwursa:CfgVal(30, "laminar/B738/flt_ctrls/flap_lever", 1, nil)
wwursa:CfgVal(31, "laminar/B738/flt_ctrls/flap_lever", 0.372, nil)
wwursa:CfgVal(32, "laminar/B738/flt_ctrls/flap_lever", 0.25, nil)
wwursa:CfgVal(33, "laminar/B738/flt_ctrls/flap_lever", 0.125, nil)
wwursa:CfgVal(34, "laminar/B738/flt_ctrls/flap_lever", 0, nil)

wwursa:CfgVal(37, "laminar/B738/flt_ctrls/speedbrake_lever", 0, 0.0889)

-------------------- Output ---------------------
local dr_power = iDataRef:New('sim/cockpit/electrical/avionics_on')
local dr_main = iDataRef:New('laminar/B738/electric/main_bus')
local dr_panel = iDataRef:New('laminar/B738/electric/panel_brightness[3]')
local dr_trim = iDataRef:New('sim/cockpit2/controls/rudder_trim')
local dr_fire1 = iDataRef:New('laminar/B738/annunciator/engine1_fire')
local dr_fire2 = iDataRef:New('laminar/B738/annunciator/engine2_fire')

--====backlight
-- panel brightness ratio scaled to 0-255, gated by avionics power;
-- local cache: USB write only when computed value changes
local bkl_last = -1

function wwursa_zibo_bkl_loop()
	local hasPower = dr_power:Get() ~= 0
	local hasMain = dr_main:Get() ~= 0
	local ratio = hasMain and dr_panel:Get() or 0.5
	if ratio < 0 then ratio = 0 elseif ratio > 1 then ratio = 1 end
	local bkl = hasPower and math.floor(ratio * 255) or 0
	if bkl ~= bkl_last then
		bkl_last = bkl
		wwursa:SendLedCmd(wwursa.LEDS_BKL, bkl)
		wwursa:SendLedCmd(wwursa.LEDS_OVERALLBKL, hasPower and 255 or 0)
	end
end

--====fault/fire LEDs
-- annunciator binaries, edge-detected (no per-frame USB HID traffic)
local fault1_last, fire1_last = -1, -1
local fault2_last, fire2_last = -1, -1

function wwursa_zibo_led_loop()
	local fault1, fire1 = 0, dr_fire1:Get() > 0 and 1 or 0
	local fault2, fire2 = 0, dr_fire2:Get() > 0 and 1 or 0
	if fault1 ~= fault1_last then
		fault1_last = fault1
		wwursa:SendLedCmd(wwursa.LEDS_FAULT1, fault1)
	end
	if fire1 ~= fire1_last then
		fire1_last = fire1
		wwursa:SendLedCmd(wwursa.LEDS_FIRE1, fire1)
	end
	if fault2 ~= fault2_last then
		fault2_last = fault2
		wwursa:SendLedCmd(wwursa.LEDS_FAULT2, fault2)
	end
	if fire2 ~= fire2_last then
		fire2_last = fire2
		wwursa:SendLedCmd(wwursa.LEDS_FIRE2, fire2)
	end
end

--====vibration
-- ground-roll micro-vibration: intensity = groundspeed, gated by on-ground,
-- explicit SendLedCmd with local throttling (no per-frame USB HID traffic)
local dr_onground = iDataRef:New('sim/flightmodel/failures/onground_any')
local dr_gs = iDataRef:New('sim/flightmodel/position/groundspeed')
local dr_l_tire = iDataRef:New('sim/flightmodel2/gear/tire_vertical_deflection_mtr[1]')
local dr_r_tire = iDataRef:New('sim/flightmodel2/gear/tire_vertical_deflection_mtr[2]')
local vib_l_last = 0
local vib_r_last = 0

function wwursa_zibo_vib_loop()
	local vib_l, vib_r = 0, 0
	if dr_onground:Get() ~= 0 then
		local gs = dr_gs:Get() * 10
		vib_l = math.floor(gs * dr_l_tire:Get())
		vib_r = math.floor(gs * dr_r_tire:Get())
		if vib_l > 255 then vib_l = 255 end
		if vib_r > 255 then vib_r = 255 end
	end
	if vib_l ~= vib_l_last then
		vib_l_last = vib_l
		wwursa:SendLedCmd(wwursa.LEDS_VIBL, vib_l)
	end
	if vib_r ~= vib_r_last then
		vib_r_last = vib_r
		wwursa:SendLedCmd(wwursa.LEDS_VIBR, vib_r)
	end
end

GlobalFrameLoopManager:add(function()
	wwursa_zibo_bkl_loop()
	wwursa_zibo_led_loop()
	wwursa_zibo_vib_loop()
	-- setLcdText caches text internally; USB write only when text changes
	wwursa:setLcdText(wwursa:formatTrimText(dr_trim:Get() * 17.5, false))
end)
