-- *****************************************************************
-- WwFcu (FCU-only) for Toliss — subset of WINCTRL toliss-fcu-efis-profile
-- *****************************************************************

if ilua_require_toliss() then return end

-- Do not remove below lines: hardware detection
local wwfcu = com.sim.qm.Wwfcu.Open()
if not wwfcu then return end
-- Do not remove above lines: hardware detection

uluaLog('Wwfcu for Toliss')

wwfcu:CfgCmd(0, 'toliss_airbus/ias_mach_button_push')
wwfcu:CfgCmd(1, 'AirbusFBW/LOCbutton')
wwfcu:CfgCmd(2, 'toliss_airbus/hdgtrk_button_push')
wwfcu:CfgValT(3, 'AirbusFBW/AP1Engage')
wwfcu:CfgValT(4, 'AirbusFBW/AP2Engage')
wwfcu:CfgCmd(5, 'AirbusFBW/ATHRbutton')
wwfcu:CfgCmd(6, 'AirbusFBW/EXPEDbutton')
wwfcu:CfgCmd(7, 'toliss_airbus/metric_alt_button_push')
wwfcu:CfgCmd(8, 'AirbusFBW/APPRbutton')
wwfcu:CfgCmd(9, 'sim/autopilot/airspeed_down')
wwfcu:CfgCmd(10, 'sim/autopilot/airspeed_up')
wwfcu:CfgCmd(11, 'AirbusFBW/PushSPDSel')
wwfcu:CfgCmd(12, 'AirbusFBW/PullSPDSel')
wwfcu:CfgCmd(13, 'sim/autopilot/heading_down')
wwfcu:CfgCmd(14, 'sim/autopilot/heading_up')
wwfcu:CfgCmd(15, 'AirbusFBW/PushHDGSel')
wwfcu:CfgCmd(16, 'AirbusFBW/PullHDGSel')
wwfcu:CfgCmd(17, 'sim/autopilot/altitude_down')
wwfcu:CfgCmd(18, 'sim/autopilot/altitude_up')
wwfcu:CfgCmd(19, 'AirbusFBW/PushAltitude')
wwfcu:CfgCmd(20, 'AirbusFBW/PullAltitude')
wwfcu:CfgCmd(21, 'sim/autopilot/vertical_speed_down')
wwfcu:CfgCmd(22, 'sim/autopilot/vertical_speed_up')
wwfcu:CfgCmd(23, 'AirbusFBW/PushVSSel')
wwfcu:CfgCmd(24, 'AirbusFBW/PullVSSel')
wwfcu:CfgVal(25, 'AirbusFBW/ALT100_1000', 0)
wwfcu:CfgVal(26, 'AirbusFBW/ALT100_1000', 1)

local dr_power = iDataRef:New('AirbusFBW/FCUAvail')
local dr_annun = iDataRef:New('AirbusFBW/AnnunMode')
local dr_light = iDataRef:New('AirbusFBW/SupplLightLevelRehostats[0]')
local dr_scr = iDataRef:New('AirbusFBW/SupplLightLevelRehostats[1]')
local dr_ap1 = iDataRef:New('AirbusFBW/AP1Engage')
local dr_ap2 = iDataRef:New('AirbusFBW/AP2Engage')
local dr_athr = iDataRef:New('AirbusFBW/ATHRmode')
local dr_loc = iDataRef:New('AirbusFBW/LOCilluminated')
local dr_appr = iDataRef:New('AirbusFBW/APPRilluminated')
local dr_exped = iDataRef:New('AirbusFBW/OHPLightsATA31_Raw[49]')
local dr_alt_lt = iDataRef:New('AirbusFBW/OHPLightsATA31_Raw[51]')

local dr_spd = iDataRef:New('sim/cockpit2/autopilot/airspeed_dial_kts_mach')
local dr_mach = iDataRef:New('sim/cockpit/autopilot/airspeed_is_mach')
local dr_spd_dash = iDataRef:New('AirbusFBW/SPDdashed')
local dr_hdg = iDataRef:New('sim/cockpit/autopilot/heading_mag')
local dr_hdg_dash = iDataRef:New('AirbusFBW/HDGdashed')
local dr_vs = iDataRef:New('sim/cockpit/autopilot/vertical_velocity')
local dr_vs_dash = iDataRef:New('AirbusFBW/VSdashed')
local dr_hdgtrk = iDataRef:New('AirbusFBW/HDGTRKmode')
local dr_spd_mgd = iDataRef:New('AirbusFBW/SPDmanaged')
local dr_hdg_mgd = iDataRef:New('AirbusFBW/HDGmanaged')
local dr_alt_mgd = iDataRef:New('AirbusFBW/ALTmanaged')
local dr_alt = uluaFind('toliss_airbus/pfdoutputs/general/ap_altitude_reference')
		and iDataRef:New('toliss_airbus/pfdoutputs/general/ap_altitude_reference')
		or iDataRef:New('sim/cockpit/autopilot/altitude')

local function pad3(n)
	return string.format('%03d', n)
end

GlobalFrameLoopManager:add(function()
	local hasPower = dr_power:Get() ~= 0
	local annun = dr_annun:Get()
	local test = (annun == 2) and hasPower
	local bkl = hasPower and math.floor(math.max(0, math.min(1, dr_light:Get())) * 255) or 0
	local ledBkl = hasPower and ((annun == 0) and 60 or 255) or 0
	local scr = 0
	if hasPower then
		scr = math.floor(64 + math.max(0, math.min(1, dr_scr:Get())) * (255 - 64))
	end
	wwfcu:SendLedCmd(wwfcu.LEDS_BKL, bkl)
	wwfcu:SendLedCmd(wwfcu.LEDS_SCRBKL, scr)
	wwfcu:SendLedCmd(wwfcu.LEDS_LEDBKL, ledBkl)
	wwfcu:SendLedCmd(wwfcu.LEDS_EXPEDBKL, bkl)
	wwfcu:SendLedCmd(wwfcu.LEDS_AP1, (dr_ap1:Get() ~= 0 or test) and 1 or 0)
	wwfcu:SendLedCmd(wwfcu.LEDS_AP2, (dr_ap2:Get() ~= 0 or test) and 1 or 0)
	wwfcu:SendLedCmd(wwfcu.LEDS_ATHR, (dr_athr:Get() > 0 or test) and 1 or 0)
	wwfcu:SendLedCmd(wwfcu.LEDS_LOC, (dr_loc:Get() ~= 0 or test) and 1 or 0)
	wwfcu:SendLedCmd(wwfcu.LEDS_APPR, (dr_appr:Get() ~= 0 or test) and 1 or 0)
	wwfcu:SendLedCmd(wwfcu.LEDS_EXPED, (dr_exped:Get() > 0 or dr_alt_lt:Get() > 0 or test) and 1 or 0)

	-- FCU LCD (WINCTRL toliss-fcu-efis-profile::updateDisplayData)
	local spdMach = dr_mach:Get() ~= 0
	local spdStr
	if dr_spd:Get() > 0 and dr_spd_dash:Get() == 0 then
		if spdMach then
			spdStr = pad3(math.floor(dr_spd:Get() * 100 + 0.5))
		else
			spdStr = pad3(math.floor(dr_spd:Get()))
		end
	else
		spdStr = '---'
	end

	local hdgStr
	if dr_hdg:Get() >= 0 and dr_hdg_dash:Get() == 0 then
		hdgStr = pad3(math.floor(dr_hdg:Get()) % 360)
	else
		hdgStr = '---'
	end

	local alt = dr_alt:Get()
	local altStr = (alt >= 0) and string.format('%05d', math.floor(alt)) or '-----'

	local trk = dr_hdgtrk:Get() ~= 0
	local vsDash = dr_vs_dash:Get() ~= 0
	local vs = dr_vs:Get()
	local vsStr, vsSign, fpaComma, vsVert
	if vsDash then
		vsStr, vsSign, fpaComma, vsVert = '-----', false, trk, false
	elseif trk then
		local fpaTenths = math.floor(math.abs(vs / 1000.0) * 10 + 0.5)
		vsStr = string.format('%02d  ', fpaTenths)
		vsSign = vs >= 0
		fpaComma = true
		vsVert = false
	else
		local absVs = math.abs(math.floor(vs + 0.5))
		if absVs % 100 == 0 then
			vsStr = string.format('%02d##', math.floor(absVs / 100))
		else
			vsStr = string.format('%04d', absVs)
		end
		vsSign = vs >= 0
		fpaComma = false
		vsVert = true
	end

	wwfcu:setFcuDisplay({
		displayEnabled = hasPower,
		displayTest = test,
		speed = spdStr,
		heading = hdgStr,
		altitude = altStr,
		verticalSpeed = vsStr,
		spdMach = spdMach,
		spdManaged = dr_spd_mgd:Get() ~= 0,
		hdgManaged = dr_hdg_mgd:Get() ~= 0,
		altManaged = dr_alt_mgd:Get() ~= 0,
		headingTrk = trk,
		headingHdg = not trk,
		headingLat = true,
		vsMode = not trk,
		fpaMode = trk,
		vsIndication = not trk,
		fpaIndication = trk,
		vsSign = vsSign,
		fpaComma = fpaComma,
		vsVerticalLine = vsVert,
	})
end)
