-- *****************************************************************
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-03-26_22_43_18UTC
-- *****************************************************************

if ilua_is_acftitle_excluded('A3') or ilua_is_acfpath_excluded('toliss') then
	if ilua_is_acftitle_excluded('A2') or ilua_is_acfpath_excluded('toliss') then
		return
	end
end

-- Do not remove below lines: hardware detection
local wwecam = com.sim.qm.Wwecam:new()
if not wwecam:Init() then
	return
end
-- Do not remove above lines: hardware detection


-- check Toliss old verion or new
local oldversion = false

local function check_verion()
	local file = ilua_get_path(AIRCRAFT_PATH) .. "skunkcrafts_updater.cfg"
	if not ilua_file_exists(file) then
		uluaLog("Toliss XP11 old version")
		oldversion = true
	else
		uluaLog("Toliss XP12 new version")
	end
end
check_verion()
-- 0:ELEC AC  1:ELEC DC
local iniA330_ecam_elec_acdc = 0

-- A330
local isINIA330 = false
local isINIA340 = false
if not ilua_is_acftitle_excluded('A33') then
	isINIA330 = true
	uluaLog('- Wwecam Toliss A33X')
elseif not ilua_is_acftitle_excluded('A34') then
	isINIA340 = true
	uluaLog('- Wwecam Toliss A34X')
end

uluaLog('Wwecam for Toliss')

--------------------Input Keys Binding ---------------------

-- ECAM
-- TO CONFIG
wwecam:CfgCmd(1, 'AirbusFBW/TOConfigPress')
-- EMER CANCEL
wwecam:CfgCmd(2, 'AirbusFBW/EmerCancel')

wwecam:CfgValT(4, 'AirbusFBW/SDENG')
wwecam:CfgValT(5, 'AirbusFBW/SDBLEED')
wwecam:CfgValT(6, 'AirbusFBW/SDPRESS')

function flip_ecam_ac_dc()
	-- uluaLog(string.format('flip_ecam_ac_dc=%d', iniA330_ecam_elec_acdc))
	iniA330_ecam_elec_acdc = 1 - iniA330_ecam_elec_acdc
	if iniA330_ecam_elec_acdc == 0 then
		wwecam:CfgValT(7, 'AirbusFBW/SDELEC')
	else
		wwecam:CfgValT(7, 'AirbusFBW/SDELECDC')
	end
end

if not isINIA330 and not isINIA340 then
	wwecam:CfgValT(7, 'AirbusFBW/SDELEC')
else
	flip_ecam_ac_dc()
	wwecam:CfgFc(7, '', 'flip_ecam_ac_dc()')
end

wwecam:CfgValT(8, 'AirbusFBW/SDHYD')
wwecam:CfgValT(9, 'AirbusFBW/SDFUEL')

wwecam:CfgValT(10, 'AirbusFBW/SDAPU')
wwecam:CfgValT(11, 'AirbusFBW/SDCOND')
wwecam:CfgValT(12, 'AirbusFBW/SDDOOR')
wwecam:CfgValT(13, 'AirbusFBW/SDWHEEL')
wwecam:CfgValT(14, 'AirbusFBW/SDFCTL')

wwecam:CfgCmd(15, 'AirbusFBW/ECAMAll')

wwecam:CfgCmd(16, 'AirbusFBW/ECP/CaptainClear')
wwecam:CfgValT(18, 'AirbusFBW/SDSTATUS')
wwecam:CfgCmd(19, 'AirbusFBW/ECAMRecall')

--------------------Output lights ---------------------
-- =====ECAM
wwecam:GetEEng('AirbusFBW/OHPLightsATA31[30]')
wwecam:GetEBleed('AirbusFBW/OHPLightsATA31[31]')
wwecam:GetEPress('AirbusFBW/OHPLightsATA31[32]')

if not isINIA330 and not isINIA340 then
	wwecam:GetEElec('AirbusFBW/OHPLightsATA31[33]')
else
	wwecam:GetEElecAcDc('AirbusFBW/OHPLightsATA31[33]', 'AirbusFBW/OHPLightsATA31[52]')
end

wwecam:GetEHyd('AirbusFBW/OHPLightsATA31[34]')
wwecam:GetEFuel('AirbusFBW/OHPLightsATA31[35]')

wwecam:GetEApu('AirbusFBW/OHPLightsATA31[36]')
wwecam:GetECond('AirbusFBW/OHPLightsATA31[37]')
wwecam:GetEDoor('AirbusFBW/OHPLightsATA31[38]')
wwecam:GetEWheel('AirbusFBW/OHPLightsATA31[39]')
wwecam:GetEFctl('AirbusFBW/OHPLightsATA31[40]')

wwecam:GetEClrL('AirbusFBW/OHPLightsATA31[42]')
wwecam:GetEClrR('AirbusFBW/OHPLightsATA31[43]')
wwecam:GetESts('AirbusFBW/OHPLightsATA31[41]')

wwecam:GetBkl("AirbusFBW/PanelBrightnessLevel", 90)

-- =====Annunciator test
local dr_test = iDataRef:New("AirbusFBW/AnnunMode") -- 0: DIM 1: BRT 2: test mode
local dr_power
local dr_bkl_power
if oldversion then
	dr_power = iDataRef:New("sim/cockpit2/switches/avionics_power_on")  -- 0: OFF >0: ON
	dr_bkl_power = iDataRef:New("sim/cockpit2/switches/avionics_power_on") -- 0: OFF >0: ON
else
	dr_power = iDataRef:New("AirbusFBW/DCBusVoltages[3]")               -- 0: OFF >0: ON
	dr_bkl_power = iDataRef:New("AirbusFBW/ACBusVoltages[0]")           -- 0: OFF >0: ON
end

function Wwecam_Toliss_Loop_Upd()
	-- expert code: cold and dark
	if dr_power:ChangedUpdate() then
		local b_power = dr_power:GetOld()
		if b_power == 0 then
			wwecam:PowerOff()
			return
		else
			wwecam:FreshBkl()
		end
	end

	-- expert code: test mode
	if dr_test:ChangedUpdate() then
		local b_test = dr_test:GetOLd()
		if b_test == 2 then
			wwecam:SetTest()
			return
		elseif b_test == 0 then
			-- DIM
		else
		end
	end

	if not isINIA330 and not isINIA340 then
		wwecam:SetEcam()
	else
		wwecam:SetEcamAcDc()
	end
	-- brightness
	wwecam:SetBkl()
end

uluaAddDoLoop('Wwecam_Toliss_Loop_Upd()')
