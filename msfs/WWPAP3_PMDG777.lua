-- *****************************************************************
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-08-11
-- WinWing PAP3 MCP for PMDG 777 (USB HID WwPap3)
-- MSFS RPN from: PMDG 777 WINWING PAP3 MCP and PFP3N.mfproj (PMDG777_WinWingFCUTCA only)
-- *****************************************************************

if ilua_require_pmdg_777() then return end

-- Do not remove below lines: hardware detection
local wwpap3 = com.sim.qm.Wwpap3.Open()
if not wwpap3 then return end
-- Do not remove above lines: hardware detection

uluaLog('Wwpap3 for PMDG777')

-------------------- Input Keys Binding ---------------------
-- Mode buttons (777 labels on PAP3 positions)
wwpap3:CfgRpn(0, '20601 (>K:ROTOR_BRAKE)')   -- CLB CON (N1 slot)
wwpap3:CfgRpn(1, '20701 (>K:ROTOR_BRAKE)')   -- SPEED
wwpap3:CfgRpn(2, '21201 (>K:ROTOR_BRAKE)')   -- VNAV
wwpap3:CfgRpn(3, '21301 (>K:ROTOR_BRAKE)')   -- FLCH (LVL CHG slot)
wwpap3:CfgRpn(4, '21801 (>K:ROTOR_BRAKE)')   -- HDG SEL
wwpap3:CfgRpn(5, '21101 (>K:ROTOR_BRAKE)')   -- LNAV
wwpap3:CfgRpn(6, '22701 (>K:ROTOR_BRAKE)')   -- LOC
wwpap3:CfgRpn(7, '22801 (>K:ROTOR_BRAKE)')   -- APP
wwpap3:CfgRpn(8, '22601 (>K:ROTOR_BRAKE)')   -- ALT HOLD
wwpap3:CfgRpn(9, '22301 (>K:ROTOR_BRAKE)')   -- V/S
wwpap3:CfgRpn(10, '20301 (>K:ROTOR_BRAKE)')  -- A/P (CMD A slot)
wwpap3:CfgRpn(14, '20801 (>K:ROTOR_BRAKE)')  -- IAS/MACH (C/O slot)
wwpap3:CfgRpn(15, '210001 (>K:ROTOR_BRAKE)') -- SPD INTV
wwpap3:CfgRpn(16, '225101 (>K:ROTOR_BRAKE)') -- ALT INTV

-- Encoders as button pairs
wwpap3:CfgRpn(19, '21008 (>K:ROTOR_BRAKE)')  -- SPD DEC
wwpap3:CfgRpn(20, '21007 (>K:ROTOR_BRAKE)')  -- SPD INC
wwpap3:CfgRpn(21, '218008 (>K:ROTOR_BRAKE)') -- HDG DEC
wwpap3:CfgRpn(22, '218007 (>K:ROTOR_BRAKE)') -- HDG INC
wwpap3:CfgRpn(23, '225008 (>K:ROTOR_BRAKE)') -- ALT DEC
wwpap3:CfgRpn(24, '225007 (>K:ROTOR_BRAKE)') -- ALT INC
-- ALT INCR 1000 (Button 27 → bit 26; mfproj press+release)
wwpap3:CfgRpn(26, '22501 (>K:ROTOR_BRAKE)', '22501 (>K:ROTOR_BRAKE)')

-- FD Capt / FO maintained (Buttons 28..31 → bits 27..30)
-- Sync: ON turns on if off; OFF turns off if on (mfproj RPN was name-swapped)
wwpap3:CfgRpn(27, '(L:switch_202_a) 0 == if{ 20201 (>K:ROTOR_BRAKE) }')
wwpap3:CfgRpn(28, '(L:switch_202_a) 0 != if{ 20201 (>K:ROTOR_BRAKE) }')
wwpap3:CfgRpn(29, '(L:switch_230_a) 0 == if{ 23001 (>K:ROTOR_BRAKE) }')
wwpap3:CfgRpn(30, '(L:switch_230_a) 0 != if{ 23001 (>K:ROTOR_BRAKE) }')

wwpap3:CfgRpn(38, '22207 (>K:ROTOR_BRAKE)') -- VS DEC
wwpap3:CfgRpn(39, '22208 (>K:ROTOR_BRAKE)') -- VS INC

-- A/T: mfproj dual Button 41 → 20401+20501 (L/R); PAP3 bits 40/41
wwpap3:CfgRpn(40, '20401 (>K:ROTOR_BRAKE) 20501 (>K:ROTOR_BRAKE)')
wwpap3:CfgRpn(41, '20401 (>K:ROTOR_BRAKE) 20501 (>K:ROTOR_BRAKE)')

-------------------- Output LEDs ---------------------
-- mfproj has no CLB CON / SPEED / HDG SEL / CWS LEDs → '0'
wwpap3:GetN1('0')
wwpap3:GetSpeed('0')
wwpap3:GetVnav('(L:switch_2121_a, number)')
wwpap3:GetLvlChg('(L:switch_2131_a, number)') -- FLCH
wwpap3:GetHdgSel('0')
wwpap3:GetLnav('(L:switch_2111_a, number)')
wwpap3:GetVorLoc('(L:ngx_MCP_Loc, Number)')
wwpap3:GetApp('(L:ngx_MCP_App, Number)')
wwpap3:GetAltHld('(L:switch_2261_a)')
wwpap3:GetVs('(L:switch_2231_a)')
wwpap3:GetCmdA('(L:switch_2031_a, number)') -- AP L
wwpap3:GetCwsA('0')
wwpap3:GetCmdB('(L:switch_2291_a)')         -- AP R
wwpap3:GetCwsB('0')
wwpap3:GetAtArm('(L:switch_2071_a, number)')
wwpap3:GetMaCapt('(L:switch_202_a)')
wwpap3:GetMaFo('(L:switch_230_a)')
wwpap3:GetAtSol('(L:switch_204_a)')

--==== LCD / backlight
local dr_power = iDataRef:New('(L:Battery)')
local dr_bkl = iDataRef:New('(L:OH_GS_PANEL_LIGHT_CONTROL, number)')

local dr_spd = iDataRef:New('(L:ngx_SPDwindow, number)')
local dr_hdg = iDataRef:New('(L:ngx_HDGwindow, number)')
local dr_alt = iDataRef:New('(L:ngx_ALTwindow, number)')
local dr_vs = iDataRef:New('(L:ngx_VSwindow)')
local dr_vs_lit = iDataRef:New('(L:switch_2231_a)')
local dr_hdg_mode = iDataRef:New('(L:ngx_HDGmode)')

GlobalFrameLoopManager:add(function()
	local hasPower = (dr_power:Get() or 0) ~= 0
	local ratio = dr_bkl:Get() or 0
	if ratio < 0 then ratio = 0 elseif ratio > 1 then ratio = 1 end
	local bkl = hasPower and math.floor(ratio * 255) or 0
	local ledBkl = hasPower and 180 or 0
	wwpap3:SendLedCmd(wwpap3.LEDS_BKL, bkl)
	wwpap3:SendLedCmd(wwpap3.LEDS_LCDBKL, hasPower and 180 or 0)
	wwpap3:SendLedCmd(wwpap3.LEDS_LEDBKL, ledBkl)

	if not hasPower then
		wwpap3:SendLedCmd(wwpap3.LEDS_BKL, 0)
		wwpap3:SendLedCmd(wwpap3.LEDS_LCDBKL, 0)
		wwpap3:SendLedCmd(wwpap3.LEDS_LEDBKL, 0)
		wwpap3:Setleds(0, 0)
		wwpap3:setMcpDisplay({ displayEnabled = false, displayTest = false })
		return
	end

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

	local spd = dr_spd:Get() or 0
	local vsLit = (dr_vs_lit:Get() or 0) ~= 0
	-- ngx_HDGmode: show HDG/TRK label strip when in TRK (non-zero) if available
	local showLabels = (dr_hdg_mode:Get() or 0) ~= 0

	wwpap3:setMcpDisplay({
		displayEnabled = true,
		displayTest = false,
		showLabels = showLabels,
		showCourse = false, -- 777 MCP profile has no CRS windows
		speed = spd,
		spdMach = spd > 0 and spd < 1,
		speedVisible = true,
		heading = dr_hdg:Get(),
		headingVisible = true,
		altitude = dr_alt:Get(),
		altitudeVisible = true,
		verticalSpeed = dr_vs:Get(),
		verticalSpeedVisible = vsLit,
		crsCapt = 0,
		crsFo = 0,
		digitA = false,
		digitB = false,
	})
end)
