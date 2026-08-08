-- *****************************************************************
-- WwFcuEfis for Toliss (ported from WINCTRL toliss-fcu-efis-profile)
-- *****************************************************************

if ilua_require_toliss() then return end

-- Do not remove below lines: hardware detection
local ww = com.sim.qm.Wwfcuefis.Open()
if not ww then return end
-- Do not remove above lines: hardware detection

uluaLog('Wwfcuefis for Toliss')

-------------------- FCU Keys ---------------------
ww:CfgCmd(0, 'toliss_airbus/ias_mach_button_push')
ww:CfgCmd(1, 'AirbusFBW/LOCbutton')
ww:CfgCmd(2, 'toliss_airbus/hdgtrk_button_push')
ww:CfgValT(3, 'AirbusFBW/AP1Engage')
ww:CfgValT(4, 'AirbusFBW/AP2Engage')
ww:CfgCmd(5, 'AirbusFBW/ATHRbutton')
ww:CfgCmd(6, 'AirbusFBW/EXPEDbutton')
ww:CfgCmd(7, 'toliss_airbus/metric_alt_button_push')
ww:CfgCmd(8, 'AirbusFBW/APPRbutton')
ww:CfgCmd(9, 'sim/autopilot/airspeed_down')
ww:CfgCmd(10, 'sim/autopilot/airspeed_up')
ww:CfgCmd(11, 'AirbusFBW/PushSPDSel')
ww:CfgCmd(12, 'AirbusFBW/PullSPDSel')
ww:CfgCmd(13, 'sim/autopilot/heading_down')
ww:CfgCmd(14, 'sim/autopilot/heading_up')
ww:CfgCmd(15, 'AirbusFBW/PushHDGSel')
ww:CfgCmd(16, 'AirbusFBW/PullHDGSel')
ww:CfgCmd(17, 'sim/autopilot/altitude_down')
ww:CfgCmd(18, 'sim/autopilot/altitude_up')
ww:CfgCmd(19, 'AirbusFBW/PushAltitude')
ww:CfgCmd(20, 'AirbusFBW/PullAltitude')
ww:CfgCmd(21, 'sim/autopilot/vertical_speed_down')
ww:CfgCmd(22, 'sim/autopilot/vertical_speed_up')
ww:CfgCmd(23, 'AirbusFBW/PushVSSel')
ww:CfgCmd(24, 'AirbusFBW/PullVSSel')
ww:CfgVal(25, 'AirbusFBW/ALT100_1000', 0)
ww:CfgVal(26, 'AirbusFBW/ALT100_1000', 1)

-------------------- EFIS Capt (L) ---------------------
ww:CfgCmd(32, 'toliss_airbus/fd1_push')
ww:CfgCmd(33, 'toliss_airbus/dispcommands/CaptLSButtonPush')
ww:CfgValT(34, 'AirbusFBW/NDShowCSTRCapt')
ww:CfgValT(35, 'AirbusFBW/NDShowWPTCapt')
ww:CfgValT(36, 'AirbusFBW/NDShowVORDCapt')
ww:CfgValT(37, 'AirbusFBW/NDShowNDBCapt')
ww:CfgValT(38, 'AirbusFBW/NDShowARPTCapt')
ww:CfgCmd(39, 'toliss_airbus/capt_baro_push')
ww:CfgCmd(40, 'toliss_airbus/capt_baro_pull')

function wwfcuefis_toliss_baro_capt(delta)
	if uluaGet(uluaFind('AirbusFBW/BaroStdCapt')) ~= 0 then return end
	local dr = uluaFind('sim/cockpit2/gauges/actuators/barometer_setting_in_hg_pilot')
	local baro = uluaGet(dr)
	local hpa = uluaGet(uluaFind('AirbusFBW/BaroUnitCapt')) ~= 0
	if hpa then
		baro = (baro * 33.8639 + delta) / 33.8639
	else
		baro = baro + delta * 0.01
	end
	uluaSet(dr, baro)
end
ww:CfgFc(41, 'wwfcuefis_toliss_baro_capt(-1)')
ww:CfgFc(42, 'wwfcuefis_toliss_baro_capt(1)')
ww:CfgVal(43, 'AirbusFBW/BaroUnitCapt', 0)
ww:CfgVal(44, 'AirbusFBW/BaroUnitCapt', 1)
ww:CfgVal(45, 'AirbusFBW/NDmodeCapt', 0)
ww:CfgVal(46, 'AirbusFBW/NDmodeCapt', 1)
ww:CfgVal(47, 'AirbusFBW/NDmodeCapt', 2)
ww:CfgVal(48, 'AirbusFBW/NDmodeCapt', 3)
ww:CfgVal(49, 'AirbusFBW/NDmodeCapt', 4)
ww:CfgVal(50, 'AirbusFBW/NDrangeCapt', 0)
ww:CfgVal(51, 'AirbusFBW/NDrangeCapt', 1)
ww:CfgVal(52, 'AirbusFBW/NDrangeCapt', 2)
ww:CfgVal(53, 'AirbusFBW/NDrangeCapt', 3)
ww:CfgVal(54, 'AirbusFBW/NDrangeCapt', 4)
ww:CfgVal(55, 'AirbusFBW/NDrangeCapt', 5)
ww:CfgVal(56, 'sim/cockpit2/EFIS/EFIS_1_selection_pilot', 0)
ww:CfgVal(57, 'sim/cockpit2/EFIS/EFIS_1_selection_pilot', 1)
ww:CfgVal(58, 'sim/cockpit2/EFIS/EFIS_1_selection_pilot', 2)
ww:CfgVal(59, 'sim/cockpit2/EFIS/EFIS_2_selection_pilot', 0)
ww:CfgVal(60, 'sim/cockpit2/EFIS/EFIS_2_selection_pilot', 1)
ww:CfgVal(61, 'sim/cockpit2/EFIS/EFIS_2_selection_pilot', 2)

-------------------- EFIS FO (R) ---------------------
ww:CfgCmd(64, 'toliss_airbus/fd2_push')
ww:CfgCmd(65, 'toliss_airbus/dispcommands/CoLSButtonPush')
ww:CfgValT(66, 'AirbusFBW/NDShowCSTRFO')
ww:CfgValT(67, 'AirbusFBW/NDShowWPTFO')
ww:CfgValT(68, 'AirbusFBW/NDShowVORDFO')
ww:CfgValT(69, 'AirbusFBW/NDShowNDBFO')
ww:CfgValT(70, 'AirbusFBW/NDShowARPTFO')
ww:CfgCmd(71, 'toliss_airbus/copilot_baro_push')
ww:CfgCmd(72, 'toliss_airbus/copilot_baro_pull')

function wwfcuefis_toliss_baro_fo(delta)
	if uluaGet(uluaFind('AirbusFBW/BaroStdFO')) ~= 0 then return end
	local dr = uluaFind('sim/cockpit2/gauges/actuators/barometer_setting_in_hg_copilot')
	local baro = uluaGet(dr)
	local hpa = uluaGet(uluaFind('AirbusFBW/BaroUnitFO')) ~= 0
	if hpa then
		baro = (baro * 33.8639 + delta) / 33.8639
	else
		baro = baro + delta * 0.01
	end
	uluaSet(dr, baro)
end
ww:CfgFc(73, 'wwfcuefis_toliss_baro_fo(-1)')
ww:CfgFc(74, 'wwfcuefis_toliss_baro_fo(1)')
ww:CfgVal(75, 'AirbusFBW/BaroUnitFO', 0)
ww:CfgVal(76, 'AirbusFBW/BaroUnitFO', 1)
ww:CfgVal(77, 'AirbusFBW/NDmodeFO', 0)
ww:CfgVal(78, 'AirbusFBW/NDmodeFO', 1)
ww:CfgVal(79, 'AirbusFBW/NDmodeFO', 2)
ww:CfgVal(80, 'AirbusFBW/NDmodeFO', 3)
ww:CfgVal(81, 'AirbusFBW/NDmodeFO', 4)
ww:CfgVal(82, 'AirbusFBW/NDrangeFO', 0)
ww:CfgVal(83, 'AirbusFBW/NDrangeFO', 1)
ww:CfgVal(84, 'AirbusFBW/NDrangeFO', 2)
ww:CfgVal(85, 'AirbusFBW/NDrangeFO', 3)
ww:CfgVal(86, 'AirbusFBW/NDrangeFO', 4)
ww:CfgVal(87, 'AirbusFBW/NDrangeFO', 5)
ww:CfgVal(88, 'sim/cockpit2/EFIS/EFIS_1_selection_copilot', 2)
ww:CfgVal(89, 'sim/cockpit2/EFIS/EFIS_1_selection_copilot', 1)
ww:CfgVal(90, 'sim/cockpit2/EFIS/EFIS_1_selection_copilot', 0)
ww:CfgVal(91, 'sim/cockpit2/EFIS/EFIS_2_selection_copilot', 2)
ww:CfgVal(92, 'sim/cockpit2/EFIS/EFIS_2_selection_copilot', 1)
ww:CfgVal(93, 'sim/cockpit2/EFIS/EFIS_2_selection_copilot', 0)

-------------------- LEDs (manual; multi-bank Get* names collide in generator) ---------------------
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

local dr_fd_l = iDataRef:New('AirbusFBW/FD1Engage')
local dr_ls_l = iDataRef:New('AirbusFBW/ILSonCapt')
local dr_cstr_l = iDataRef:New('AirbusFBW/NDShowCSTRCapt')
local dr_wpt_l = iDataRef:New('AirbusFBW/NDShowWPTCapt')
local dr_vord_l = iDataRef:New('AirbusFBW/NDShowVORDCapt')
local dr_ndb_l = iDataRef:New('AirbusFBW/NDShowNDBCapt')
local dr_arpt_l = iDataRef:New('AirbusFBW/NDShowARPTCapt')

local dr_fd_r = iDataRef:New('AirbusFBW/FD2Engage')
local dr_ls_r = iDataRef:New('AirbusFBW/ILSonFO')
local dr_cstr_r = iDataRef:New('AirbusFBW/NDShowCSTRFO')
local dr_wpt_r = iDataRef:New('AirbusFBW/NDShowWPTFO')
local dr_vord_r = iDataRef:New('AirbusFBW/NDShowVORDFO')
local dr_ndb_r = iDataRef:New('AirbusFBW/NDShowNDBFO')
local dr_arpt_r = iDataRef:New('AirbusFBW/NDShowARPTFO')

local function on1(dr, test)
	return (dr:Get() ~= 0 or test) and 1 or 0
end

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
local dr_baro_l = iDataRef:New('sim/cockpit2/gauges/actuators/barometer_setting_in_hg_pilot')
local dr_baro_r = iDataRef:New('sim/cockpit2/gauges/actuators/barometer_setting_in_hg_copilot')
local dr_std_l = iDataRef:New('AirbusFBW/BaroStdCapt')
local dr_std_r = iDataRef:New('AirbusFBW/BaroStdFO')
local dr_unit_l = iDataRef:New('AirbusFBW/BaroUnitCapt')
local dr_unit_r = iDataRef:New('AirbusFBW/BaroUnitFO')

local function pad3(n)
	return string.format('%03d', n)
end

local function efis_baro(isStd, unitHpa, inHg)
	if isStd then
		return { displayEnabled = true, isStd = true, baro = 'STD ', unitIsInHg = false }
	end
	local isInHg = unitHpa == 0
	local v = math.floor(inHg * (isInHg and 100.0 or 33.8639) + 0.5)
	return {
		displayEnabled = true,
		isStd = false,
		baro = string.format('%4d', v),
		unitIsInHg = isInHg,
	}
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

	ww:SendLedCmd(ww.LEDS_BKL, bkl)
	ww:SendLedCmd(ww.LEDS_SCRBKL, scr)
	ww:SendLedCmd(ww.LEDS_LEDBKL, ledBkl)
	ww:SendLedCmd(ww.LEDS_EXPEDBKL, bkl)
	ww:SendLedCmdL(ww.LEDSL_BKL, bkl)
	ww:SendLedCmdL(ww.LEDSL_SCRBKL, scr)
	ww:SendLedCmdL(ww.LEDSL_LEDBKL, ledBkl)
	ww:SendLedCmdR(ww.LEDSR_BKL, bkl)
	ww:SendLedCmdR(ww.LEDSR_SCRBKL, scr)
	ww:SendLedCmdR(ww.LEDSR_LEDBKL, ledBkl)

	ww:SendLedCmd(ww.LEDS_AP1, on1(dr_ap1, test))
	ww:SendLedCmd(ww.LEDS_AP2, on1(dr_ap2, test))
	ww:SendLedCmd(ww.LEDS_ATHR, ((dr_athr:Get() > 0) or test) and 1 or 0)
	ww:SendLedCmd(ww.LEDS_LOC, on1(dr_loc, test))
	ww:SendLedCmd(ww.LEDS_APPR, on1(dr_appr, test))
	ww:SendLedCmd(ww.LEDS_EXPED, ((dr_exped:Get() > 0 or dr_alt_lt:Get() > 0) or test) and 1 or 0)

	ww:SendLedCmdL(ww.LEDSL_FD, on1(dr_fd_l, test))
	ww:SendLedCmdL(ww.LEDSL_LS, on1(dr_ls_l, test))
	ww:SendLedCmdL(ww.LEDSL_CSTR, on1(dr_cstr_l, test))
	ww:SendLedCmdL(ww.LEDSL_WPT, on1(dr_wpt_l, test))
	ww:SendLedCmdL(ww.LEDSL_VORD, on1(dr_vord_l, test))
	ww:SendLedCmdL(ww.LEDSL_NDB, on1(dr_ndb_l, test))
	ww:SendLedCmdL(ww.LEDSL_ARPT, on1(dr_arpt_l, test))

	ww:SendLedCmdR(ww.LEDSR_FD, on1(dr_fd_r, test))
	ww:SendLedCmdR(ww.LEDSR_LS, on1(dr_ls_r, test))
	ww:SendLedCmdR(ww.LEDSR_CSTR, on1(dr_cstr_r, test))
	ww:SendLedCmdR(ww.LEDSR_WPT, on1(dr_wpt_r, test))
	ww:SendLedCmdR(ww.LEDSR_VORD, on1(dr_vord_r, test))
	ww:SendLedCmdR(ww.LEDSR_NDB, on1(dr_ndb_r, test))
	ww:SendLedCmdR(ww.LEDSR_ARPT, on1(dr_arpt_r, test))

	local spdMach = dr_mach:Get() ~= 0
	local spdStr
	if dr_spd:Get() > 0 and dr_spd_dash:Get() == 0 then
		spdStr = spdMach and pad3(math.floor(dr_spd:Get() * 100 + 0.5)) or pad3(math.floor(dr_spd:Get()))
	else
		spdStr = '---'
	end
	local hdgStr = (dr_hdg:Get() >= 0 and dr_hdg_dash:Get() == 0) and pad3(math.floor(dr_hdg:Get()) % 360) or '---'
	local alt = dr_alt:Get()
	local altStr = (alt >= 0) and string.format('%05d', math.floor(alt)) or '-----'
	local trk = dr_hdgtrk:Get() ~= 0
	local vsDash = dr_vs_dash:Get() ~= 0
	local vs = dr_vs:Get()
	local vsStr, vsSign, fpaComma, vsVert
	if vsDash then
		vsStr, vsSign, fpaComma, vsVert = '-----', false, trk, false
	elseif trk then
		vsStr = string.format('%02d  ', math.floor(math.abs(vs / 1000.0) * 10 + 0.5))
		vsSign, fpaComma, vsVert = vs >= 0, true, false
	else
		local absVs = math.abs(math.floor(vs + 0.5))
		vsStr = (absVs % 100 == 0) and string.format('%02d##', math.floor(absVs / 100)) or string.format('%04d', absVs)
		vsSign, fpaComma, vsVert = vs >= 0, false, true
	end

	ww:setFcuDisplay({
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

	local left = efis_baro(dr_std_l:Get() ~= 0, dr_unit_l:Get(), dr_baro_l:Get())
	left.displayEnabled = hasPower
	left.displayTest = test
	local right = efis_baro(dr_std_r:Get() ~= 0, dr_unit_r:Get(), dr_baro_r:Get())
	right.displayEnabled = hasPower
	right.displayTest = test
	ww:setEfisDisplay('L', left)
	ww:setEfisDisplay('R', right)
end)
