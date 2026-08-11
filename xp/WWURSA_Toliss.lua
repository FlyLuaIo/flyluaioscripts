-- *****************************************************************
-- WwUrsa for Toliss (ported from WINCTRL toliss-ursa-minor-throttle-profile)
-- *****************************************************************

if ilua_require_toliss() then return end

-- Do not remove below lines: hardware detection
local wwursa = com.sim.qm.Wwursa.Open()
if not wwursa then return end
-- Do not remove above lines: hardware detection

uluaLog('Wwursa for Toliss')

-------------------- Input Keys Binding ---------------------
wwursa:CfgVal(0, 'AirbusFBW/ENG1MasterSwitch', 1)
wwursa:CfgVal(1, 'AirbusFBW/ENG1MasterSwitch', 0)
wwursa:CfgVal(2, 'AirbusFBW/ENG2MasterSwitch', 1)
wwursa:CfgVal(3, 'AirbusFBW/ENG2MasterSwitch', 0)
wwursa:CfgVal(6, 'AirbusFBW/ENGModeSwitch', 0)
wwursa:CfgVal(7, 'AirbusFBW/ENGModeSwitch', 1)
wwursa:CfgVal(8, 'AirbusFBW/ENGModeSwitch', 2)
wwursa:CfgCmd(9, 'sim/autopilot/autothrottle_off')
wwursa:CfgCmd(10, 'sim/autopilot/autothrottle_off')

wwursa:CfgCmd(24, 'sim/flight_controls/rudder_trim_center')
wwursa:CfgCmd(25, 'sim/flight_controls/rudder_trim_left')
wwursa:CfgCmd(27, 'sim/flight_controls/rudder_trim_right')

wwursa:CfgVal(28, 'AirbusFBW/ParkBrake', 0)
wwursa:CfgVal(29, 'AirbusFBW/ParkBrake', 1)

wwursa:CfgVal(30, 'AirbusFBW/FlapLeverRatio', 1.0)
wwursa:CfgVal(31, 'AirbusFBW/FlapLeverRatio', 0.75)
wwursa:CfgVal(32, 'AirbusFBW/FlapLeverRatio', 0.5)
wwursa:CfgVal(33, 'AirbusFBW/FlapLeverRatio', 0.25)
wwursa:CfgVal(34, 'AirbusFBW/FlapLeverRatio', 0)

-- Speedbrake armed while held
wwursa:CfgVal(38, 'sim/cockpit2/controls/speedbrake_ratio', -0.5, 0)

-------------------- Output ---------------------
local dr_bkl = iDataRef:New('AirbusFBW/PanelBrightnessLevel')
local dr_power = iDataRef:New('sim/cockpit/electrical/avionics_on')
local dr_annun = iDataRef:New('AirbusFBW/AnnunMode')
local dr_trim = iDataRef:New('AirbusFBW/YawTrimPosition')
local dr_f1 = iDataRef:New('AirbusFBW/OHPLightsATA70_Raw[10]')
local dr_fire1 = iDataRef:New('AirbusFBW/OHPLightsATA70_Raw[11]')
local dr_f2 = iDataRef:New('AirbusFBW/OHPLightsATA70_Raw[12]')
local dr_fire2 = iDataRef:New('AirbusFBW/OHPLightsATA70_Raw[13]')

GlobalFrameLoopManager:add(function()
	local hasPower = dr_power:Get() ~= 0
	local test = dr_annun:Get() == 2
	local bkl = hasPower and math.floor(math.max(0, math.min(1, dr_bkl:Get())) * 255) or 0
	wwursa:SendLedCmd(wwursa.LEDS_BKL, bkl)
	wwursa:SendLedCmd(wwursa.LEDS_OVERALLBKL, hasPower and 255 or 0)

	wwursa:SendLedCmd(wwursa.LEDS_FAULT1, (dr_f1:Get() > 0 or test) and 1 or 0)
	wwursa:SendLedCmd(wwursa.LEDS_FIRE1, (dr_fire1:Get() > 0 or test) and 1 or 0)
	wwursa:SendLedCmd(wwursa.LEDS_FAULT2, (dr_f2:Get() > 0 or test) and 1 or 0)
	wwursa:SendLedCmd(wwursa.LEDS_FIRE2, (dr_fire2:Get() > 0 or test) and 1 or 0)

	wwursa:setLcdText(wwursa:formatTrimText(dr_trim:Get(), test))
end)
