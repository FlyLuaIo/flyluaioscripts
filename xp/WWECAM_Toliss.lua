-- *****************************************************************
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-03-26_22_43_18UTC
-- *****************************************************************

if ilua_is_acftitle_excluded("A3") or ilua_is_acfpath_excluded("toliss") then
	if ilua_is_acftitle_excluded("A2") or ilua_is_acfpath_excluded("toliss") then
		return
	end
end

-- Do not remove below lines: hardware detection
local wwecam = com.sim.qm.Wwecam:new()
if not wwecam:Init() then
	return
end
-- Do not remove above lines: hardware detection

-- 0:ELEC AC  1:ELEC DC
local iniA330_ecam_elec_acdc = 0

-- A330
local isINIA330 = false
local isINIA340 = false
if not ilua_is_acftitle_excluded("A33") then
	isINIA330 = true
	uluaLog("- Wwecam Toliss A33X")
elseif not ilua_is_acftitle_excluded("A34") then
	isINIA340 = true
	uluaLog("- Wwecam Toliss A34X")
end

uluaLog("Wwecam for Toliss")

--------------------Input Key Binding ---------------------
function flip_ecam_ac_dc()
	-- uluaLog(string.format("flip_ecam_ac_dc=%d", iniA330_ecam_elec_acdc))
	iniA330_ecam_elec_acdc = 1 - iniA330_ecam_elec_acdc
	if iniA330_ecam_elec_acdc == 0 then
		wwecam:CfgValT(7, "AirbusFBW/SDELEC")
	else
		wwecam:CfgValT(7, "AirbusFBW/SDELECDC")
	end
end

if not isINIA330 and not isINIA340 then
	wwecam:CfgValT(7, "AirbusFBW/SDELEC")
else
	flip_ecam_ac_dc()
	wwecam:CfgFc(7, "", "flip_ecam_ac_dc()")
end


--------------------Output lights ---------------------
-- =====ECAM
wwecam:GetEEng("AirbusFBW/OHPLightsATA31[30]")
wwecam:GetEBleed("AirbusFBW/OHPLightsATA31[31]")
wwecam:GetEPress("AirbusFBW/OHPLightsATA31[32]")

if not isINIA330 and not isINIA340 then
	wwecam:GetEElec("AirbusFBW/OHPLightsATA31[33]")
else
	wwecam:GetEElecAcDc("AirbusFBW/OHPLightsATA31[33]", "AirbusFBW/OHPLightsATA31[52]")
end

wwecam:GetEHyd("AirbusFBW/OHPLightsATA31[34]")
wwecam:GetEFuel("AirbusFBW/OHPLightsATA31[35]")

wwecam:GetEApu("AirbusFBW/OHPLightsATA31[36]")
wwecam:GetECond("AirbusFBW/OHPLightsATA31[37]")
wwecam:GetEDoor("AirbusFBW/OHPLightsATA31[38]")
wwecam:GetEWheel("AirbusFBW/OHPLightsATA31[39]")
wwecam:GetEFctl("AirbusFBW/OHPLightsATA31[40]")

wwecam:GetEClrL("AirbusFBW/OHPLightsATA31[42]")
wwecam:GetEClrR("AirbusFBW/OHPLightsATA31[43]")
wwecam:GetESts("AirbusFBW/OHPLightsATA31[41]")

function Wwecam_Toliss_Loop_Upd()
	if not isINIA330 and not isINIA340 then
		wwecam:SetEcam()
	else
		wwecam:SetEcamAcDc()
	end
end

uluaAddDoLoop("Wwecam_Toliss_Loop_Upd()")
