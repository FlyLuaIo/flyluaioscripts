-- *****************************************************************
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-04-21_09_15_13UTC
-- *****************************************************************


if ilua_is_acftitle_excluded("A3") or ilua_is_acfpath_excluded("toliss") then
	if ilua_is_acftitle_excluded("A2") or ilua_is_acfpath_excluded("toliss") then
		return
	end
end

-- Do not remove below lines: hardware detection
local wffcuc = com.sim.qm.Wffcuc:new()
if not wffcuc:Init() then
	return
end
-- Do not remove above lines: hardware detection

uluaLog('Wffcuc for Toliss')

-- LCD display
wffcuc:GetSpd('sim/cockpit2/autopilot/airspeed_dial_kts_mach')
wffcuc:GetHdg('sim/cockpit/autopilot/heading_mag')
wffcuc:GetAlt('sim/cockpit/autopilot/altitude')
wffcuc:GetVs('sim/cockpit/autopilot/vertical_velocity')

-- brightness
wffcuc:GetBkl("AirbusFBW/PanelBrightnessLevel", 200) -- 0~1
wffcuc:GetLcdBkl('AirbusFBW/SupplLightLevelRehostats[1]', 250)

-- LEDs
wffcuc:GetLoc('AirbusFBW/LOCilluminated')
wffcuc:GetAp1('AirbusFBW/AP1Engage')
wffcuc:GetAp2('AirbusFBW/AP2Engage')
wffcuc:GetAthr('AirbusFBW/ATHRmode')
wffcuc:GetExped('AirbusFBW/APVerticalMode')
wffcuc:GetAppr('AirbusFBW/APPRilluminated')
wffcuc:GetSpdmang('AirbusFBW/SPDmanaged')
wffcuc:GetSpddash('AirbusFBW/SPDdashed')
wffcuc:GetHdgmang('AirbusFBW/HDGmanaged')
wffcuc:GetHdgdash('AirbusFBW/HDGdashed')
wffcuc:GetAltmang('AirbusFBW/ALTmanaged')
wffcuc:GetVsdash('AirbusFBW/VSdashed')
wffcuc:GetSpdmach('sim/cockpit2/autopilot/airspeed_is_mach')
wffcuc:GetHdgtrk('AirbusFBW/HDGTRKmode')
wffcuc:GetTest('cpuwolf/flyluaio/WfFcuc/condbtn[0]')
wffcuc:GetPower('AirbusFBW/FCUAvail')

-- annun test mode
local dr_test_set = iDataRef:New('cpuwolf/flyluaio/WfFcuc/condbtn[0]')
local dr_test = iDataRef:New("AirbusFBW/AnnunMode") -- 0: DIM 1: BRT 2: test mode


function Wffcuc_Toliss_Loop_Upd()
	-- expert code: test mode
	local b_test
	if dr_test:ChangedUpdate() then
		b_test = dr_test:GetOld()
		if b_test == 2 then
			dr_test_set:Set(1)
		elseif b_test == 1 then
			-- DIM
			dr_test_set:Set(0)
			wffcuc:FreshBits()
		else
			wffcuc:FreshBits()
		end
	else
		b_test = dr_test:Get()
	end
	if b_test == 2 then
		--test mode don't need refresh data
		wffcuc:SetLeds(0.1, 1)
	else
		wffcuc:SetLeds(0.1)
	end
	wffcuc:SetTest()
	wffcuc:SetPower()
	-- LCD display
	wffcuc:SetSpd()
	wffcuc:SetHdg()
	wffcuc:SetAlt()
	wffcuc:SetVs()
	-- backlight
	wffcuc:SetBkl()
	wffcuc:SetLcdBkl()
	--force refresh
	wffcuc:ForceFresh()
end

uluaAddDoLoop('Wffcuc_Toliss_Loop_Upd()')
