-- *****************************************************************
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-08-11
-- WinWing PAP3 MCP for PMDG 737 (USB HID WwPap3)
-- MSFS RPN from: PMDG-737.mfproj (WINCTRL 3N PAP only)
-- *****************************************************************

if ilua_require_pmdg_737() then return end

-- Do not remove below lines: hardware detection
local wwpap3 = com.sim.qm.Wwpap3.Open()
if not wwpap3 then return end
-- Do not remove above lines: hardware detection

uluaLog('Wwpap3 for PMDG737')

-------------------- Input Keys Binding ---------------------
-- Mode buttons (Button 1..17 → bits 0..16)
wwpap3:CfgRpn(0, '38101 (>K:ROTOR_BRAKE)')  -- N1
wwpap3:CfgRpn(1, '38201 (>K:ROTOR_BRAKE)')  -- SPEED
wwpap3:CfgRpn(2, '38601 (>K:ROTOR_BRAKE)')  -- VNAV
wwpap3:CfgRpn(3, '39101 (>K:ROTOR_BRAKE)')  -- LVL CHG
wwpap3:CfgRpn(4, '39201 (>K:ROTOR_BRAKE)')  -- HDG SEL
wwpap3:CfgRpn(5, '39701 (>K:ROTOR_BRAKE)')  -- LNAV
wwpap3:CfgRpn(6, '39601 (>K:ROTOR_BRAKE)')  -- VOR LOC
wwpap3:CfgRpn(7, '39301 (>K:ROTOR_BRAKE)')  -- APP
wwpap3:CfgRpn(8, '39401 (>K:ROTOR_BRAKE)')  -- ALT HOLD
wwpap3:CfgRpn(9, '39501 (>K:ROTOR_BRAKE)')  -- V/S
wwpap3:CfgRpn(10, '40201 (>K:ROTOR_BRAKE)') -- CMD A
wwpap3:CfgRpn(11, '40401 (>K:ROTOR_BRAKE)') -- CWS A
wwpap3:CfgRpn(12, '40301 (>K:ROTOR_BRAKE)') -- CMD B
wwpap3:CfgRpn(13, '40501 (>K:ROTOR_BRAKE)') -- CWS B
wwpap3:CfgRpn(14, '38301 (>K:ROTOR_BRAKE)') -- C/O
wwpap3:CfgRpn(15, '38701 (>K:ROTOR_BRAKE)') -- SPD INTV
wwpap3:CfgRpn(16, '88501 (>K:ROTOR_BRAKE)') -- ALT INTV

-- Encoders as button pairs (DEC/INC)
wwpap3:CfgRpn(17, '37608 (>K:ROTOR_BRAKE)') -- L CRS DEC
wwpap3:CfgRpn(18, '37607 (>K:ROTOR_BRAKE)') -- L CRS INC
wwpap3:CfgRpn(19, '38408 (>K:ROTOR_BRAKE)') -- SPD DEC
wwpap3:CfgRpn(20, '38407 (>K:ROTOR_BRAKE)') -- SPD INC
wwpap3:CfgRpn(21, '39008 (>K:ROTOR_BRAKE)') -- HDG DEC
wwpap3:CfgRpn(22, '39007 (>K:ROTOR_BRAKE)') -- HDG INC
wwpap3:CfgRpn(23, '40008 (>K:ROTOR_BRAKE)') -- ALT DEC
wwpap3:CfgRpn(24, '40007 (>K:ROTOR_BRAKE)') -- ALT INC
wwpap3:CfgRpn(25, '40908 (>K:ROTOR_BRAKE)') -- R CRS DEC
wwpap3:CfgRpn(26, '40907 (>K:ROTOR_BRAKE)') -- R CRS INC

-- FD Capt / FO maintained (Buttons 28..31 → bits 27..30)
-- PMDG-737.mfproj guards: Button 28/30 fire when switch==100, Button 29/31 when ==0
wwpap3:CfgRpn(27, '(L:switch_378_73X, number) 0 != if{ 37801 (>K:ROTOR_BRAKE) }')
wwpap3:CfgRpn(28, '(L:switch_378_73X, number) 0 == if{ 37801 (>K:ROTOR_BRAKE) }')
wwpap3:CfgRpn(29, '(L:switch_407_73X, number) 0 != if{ 40701 (>K:ROTOR_BRAKE) }')
wwpap3:CfgRpn(30, '(L:switch_407_73X, number) 0 == if{ 40701 (>K:ROTOR_BRAKE) }')

-- A/P disengage paddle (Button 32 Up / Button 33 Down → bits 31/32)
wwpap3:CfgRpn(31, '(L:switch_406_73X) 100 == if{ 40601 (>K:ROTOR_BRAKE) }')
wwpap3:CfgRpn(32, '(L:switch_406_73X) 0 == if{ 40601 (>K:ROTOR_BRAKE) }')

-- Bank angle (Buttons 34..38 → bits 33..37); targets 0/10/20/30/40 per mfproj
local function wwpap3_pmdg_bank_rpn(target)
	return string.format(
		'%d (L:switch_389_73X,number) - 10 div s0 :1 l0 0 > if{ 38902 (>K:ROTOR_BRAKE) l0 -- s0 g1 } l0 0 < if{ 38901 (>K:ROTOR_BRAKE) l0 ++ s0 g1 }',
		target)
end
wwpap3:CfgRpn(33, wwpap3_pmdg_bank_rpn(0))
wwpap3:CfgRpn(34, wwpap3_pmdg_bank_rpn(10))
wwpap3:CfgRpn(35, wwpap3_pmdg_bank_rpn(20))
wwpap3:CfgRpn(36, wwpap3_pmdg_bank_rpn(30))
wwpap3:CfgRpn(37, wwpap3_pmdg_bank_rpn(40))

wwpap3:CfgRpn(38, '40107 (>K:ROTOR_BRAKE)') -- VS DEC
wwpap3:CfgRpn(39, '40108 (>K:ROTOR_BRAKE)') -- VS INC

-- A/T ARM (mfproj duplicated Button 41; PAP3 uses bits 40=ON / 41=OFF like Zibo)
wwpap3:CfgRpn(40, '(L:switch_380_73X, number) 0 == if{ 38001 (>K:ROTOR_BRAKE) }')
wwpap3:CfgRpn(41, '(L:switch_380_73X, number) 0 != if{ 38001 (>K:ROTOR_BRAKE) }')

-------------------- Output LEDs ---------------------
wwpap3:GetN1('(L:ngx_MCP_N1, number)')
wwpap3:GetSpeed('(L:ngx_MCP_Speed, number)')
wwpap3:GetVnav('(L:ngx_MCP_VNav, number)')
wwpap3:GetLvlChg('(L:ngx_MCP_LvlChg, number)')
wwpap3:GetHdgSel('(L:ngx_MCP_HdgSel, number)')
wwpap3:GetLnav('(L:ngx_MCP_LNav, number)')
wwpap3:GetVorLoc('(L:ngx_MCP_VORLock, number)')
wwpap3:GetApp('(L:ngx_MCP_App, number)')
wwpap3:GetAltHld('(L:ngx_MCP_AltHold, number)')
wwpap3:GetVs('(L:switch_3951_73X, number) 0 >')
wwpap3:GetCmdA('(L:switch_4021_73X, number) 0 >')
wwpap3:GetCwsA('(L:switch_4041_73X, number) 0 >')
wwpap3:GetCmdB('(L:switch_4031_73X, number) 0 >')
wwpap3:GetCwsB('(L:switch_4051_73X, number) 0 >')
wwpap3:GetAtArm('(L:switch_3801_73X, number) 0 >')
wwpap3:GetMaCapt('(L:ngx_MCP_FDLeft, Number)')
wwpap3:GetMaFo('(L:ngx_MCP_FDRight, Number)')
wwpap3:GetAtSol('(L:switch_3801_73X, number) 0 >') -- mfproj Solenoid

--====backlight (mfproj: BKL=BL_MainCA, LCD/LED=100% when battery on)
wwpap3:GetBkl('(L:BL_MainCA, number)', 255)
wwpap3:GetLcdBkl('(L:BL_MainCA, number)', 255)
wwpap3:GetLedBkl('(L:BL_MainCA, number)', 255)

--==== LCD / backlight
local dr_power
if uluaFind('pmdg/ng3/data/MCP_indication_powered') then
	dr_power = iDataRef:New('pmdg/ng3/data/MCP_indication_powered')
else
	dr_power = iDataRef:New('pmdg/ng3/data/ELEC_BusPowered[3]')
end
local dr_test = iDataRef:New('(L:switch_346_73X, number)')

local dr_spd = iDataRef:New('(L:ngx_SPDwindow, number)')
local dr_hdg = iDataRef:New('(L:ngx_HDGwindow, number)')
local dr_alt = iDataRef:New('(L:ngx_ALTwindow, number)')
local dr_vs
if uluaFind('pmdg/ng3/data/MCP_VertSpeed') then
	dr_vs = iDataRef:New('pmdg/ng3/data/MCP_VertSpeed')
else
	dr_vs = iDataRef:New('(L:ngx_VSwindow)')
end
local has_vs_show = uluaFind('(L:ngx_MCP_VS)') ~= nil
local dr_vs_show = has_vs_show and iDataRef:New('(L:ngx_MCP_VS)') or nil
local dr_crs_l = iDataRef:New('(L:ngx_CRSwindowL, number)')
local dr_crs_r = iDataRef:New('(L:ngx_CRSwindowR, number)')

local dr_spd_blank = uluaFind('pmdg/ng3/data/MCP_IASBlank') and iDataRef:New('pmdg/ng3/data/MCP_IASBlank') or nil
local dr_digit_a
if uluaFind('pmdg/ng3/data/MCP_IASUnderspeedFlash') then
	dr_digit_a = iDataRef:New('pmdg/ng3/data/MCP_IASUnderspeedFlash')
else
	dr_digit_a = iDataRef:New('(L:ngx_SPDsymbols, number)')
end
local dr_digit_b
if uluaFind('pmdg/ng3/data/MCP_IASOverspeedFlash') then
	dr_digit_b = iDataRef:New('pmdg/ng3/data/MCP_IASOverspeedFlash')
else
	dr_digit_b = iDataRef:New('(L:ngx_SPDsymbols, number)')
end

local wwpap3_was_powered = false
local wwpap3_was_test = false

GlobalFrameLoopManager:add(function()
	local hasPower = dr_power:Get() ~= 0
	local testMode = dr_test:Get() or 50 -- 0 test, 50 normal, 100 dim (PMDG)

	-- Use panel built-in backlight methods (with change detection)
	if hasPower then
		if not wwpap3_was_powered then
			-- power restore / first frame: force all LEDs to re-sync once
			wwpap3_was_powered = true
			wwpap3_was_test = false
			wwpap3:FreshBits()
		end
		wwpap3:SetBkl()
		wwpap3:SetLcdBkl()
		wwpap3:SetLedBkl()
	else
		wwpap3_was_powered = false
		wwpap3_was_test = false
		wwpap3:Setleds(0, 0)
		wwpap3:setMcpDisplay({ displayEnabled = false, displayTest = false })
		return
	end

	-- Test mode (mfproj TST LGT: 9 mode annunciators + LCD test)
	if testMode == 0 then
		wwpap3_was_test = true
		wwpap3:SetN1(0, 1)
		wwpap3:SetSpeed(0, 1)
		wwpap3:SetVnav(0, 1)
		wwpap3:SetHdgSel(0, 1)
		wwpap3:SetVorLoc(0, 1)
		wwpap3:SetApp(0, 1)
		wwpap3:SetAltHld(0, 1)
		wwpap3:SetLnav(0, 1)
		wwpap3:SetLvlChg(0, 1)
		wwpap3:setMcpDisplay({ displayEnabled = true, displayTest = true })
		return
	elseif wwpap3_was_test then
		-- leaving test: force all annunciators to re-sync
		wwpap3_was_test = false
		wwpap3:FreshBits()
	end

	-- Update LED indicators (panel internal change detection)
	wwpap3:SetN1()
	wwpap3:SetSpeed()
	wwpap3:SetVnav()
	wwpap3:SetLvlChg()
	wwpap3:SetHdgSel()
	wwpap3:SetLnav()
	wwpap3:SetVorLoc()
	wwpap3:SetApp()
	wwpap3:SetAltHld()
	wwpap3:SetVs()
	wwpap3:SetCmdA()
	wwpap3:SetCwsA()
	wwpap3:SetCmdB()
	wwpap3:SetCwsB()
	wwpap3:SetAtArm()
	wwpap3:SetMaCapt()
	wwpap3:SetMaFo()
	wwpap3:SetAtSol()

	-- LCD update with change detection
	local spd = dr_spd:Get() or 0
	local spdVisible = true
	if dr_spd_blank then
		spdVisible = dr_spd_blank:Get() == 0
	end
	local vsShow = true
	if has_vs_show then
		vsShow = (dr_vs_show:Get() or 0) ~= 0
	end

	wwpap3:setMcpDisplay({
		displayEnabled = hasPower,
		displayTest = false,
		showLabels = false,
		showCourse = true,
		speed = spd,
		spdMach = spd > 0 and spd < 1,
		speedVisible = spdVisible,
		heading = dr_hdg:Get(),
		headingVisible = true,
		altitude = dr_alt:Get(),
		altitudeVisible = true,
		verticalSpeed = dr_vs:Get(),
		verticalSpeedVisible = vsShow,
		crsCapt = dr_crs_l:Get(),
		crsFo = dr_crs_r:Get(),
		digitA = (dr_digit_a:Get() or 0) ~= 0,
		digitB = (dr_digit_b:Get() or 0) ~= 0,
	})
end)
