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
-- Get/Set mode: datarefs registered once; FrameLoop Set* writes only on
-- ChangedUpdate edges (no per-frame USB HID traffic in steady state)
wwursa:GetBkl('AirbusFBW/PanelBrightnessLevel', 255)
wwursa:GetOverallBkl('sim/cockpit/electrical/avionics_on', 1)
wwursa:GetFault1('AirbusFBW/OHPLightsATA70_Raw[10]')
wwursa:GetFire1('AirbusFBW/OHPLightsATA70_Raw[11]')
wwursa:GetFault2('AirbusFBW/OHPLightsATA70_Raw[12]')
wwursa:GetFire2('AirbusFBW/OHPLightsATA70_Raw[13]')

local dr_power = iDataRef:New('sim/cockpit/electrical/avionics_on')
local dr_annun = iDataRef:New('AirbusFBW/AnnunMode')
local dr_trim = iDataRef:New('AirbusFBW/YawTrimPosition')

--====vibration
-- XP datarefs cannot express the FNX RPN (SIM ON GROUND * GROUND SPEED * 10),
-- so ground-roll micro-vibration runs as an explicit loop with local throttling
local dr_onground = iDataRef:New('sim/flightmodel/failures/onground_any')
local dr_gs = iDataRef:New('sim/flightmodel/position/groundspeed')
local ch_vib = iChange:New(0)

function Wwursa_Toliss_Vib_Loop()
	local vib = 0
	if dr_onground:Get() ~= 0 then
		vib = math.floor(dr_gs:Get())
		if vib > 255 then vib = 255 end
	end
	if ch_vib:ChangedUpdate(vib) then
		wwursa:SendLedCmd(wwursa.LEDS_VIBL, vib)
		wwursa:SendLedCmd(wwursa.LEDS_VIBR, vib)
	end
end

local was_powered = false
local was_test = false

GlobalFrameLoopManager:add(function()
	local hasPower = dr_power:Get() ~= 0
	local test = dr_annun:Get() == 2

	-- power edge: falling edge zeroes backlight once; rising edge forces resync
	if hasPower ~= was_powered then
		was_powered = hasPower
		if not hasPower then
			wwursa:SendLedCmd(wwursa.LEDS_BKL, 0)
			return
		end
		wwursa:FreshBkl()
		wwursa:FreshBits()
	end
	if not hasPower then
		return
	end

	-- test edge: entering forces all annunciations on once; leaving resyncs bits
	if test ~= was_test then
		was_test = test
		if test then
			wwursa:SetFault1(nil, 1)
			wwursa:SetFire1(nil, 1)
			wwursa:SetFault2(nil, 1)
			wwursa:SetFire2(nil, 1)
		else
			wwursa:FreshBits()
		end
	end
	if not test then
		wwursa:Setleds() -- boolean LEDs (FIRE/FAULT), ChangedUpdate throttled
	end

	wwursa:SetBkl()
	wwursa:SetOverallBkl()
	wwursa:setLcdText(wwursa:formatTrimText(dr_trim:Get(), test))
	Wwursa_Toliss_Vib_Loop()
end)
