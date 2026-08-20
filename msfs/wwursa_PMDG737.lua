-- *****************************************************************
-- created by Carson Lou @ QQ 2026-08-09
-- *****************************************************************
if ilua_require_pmdg_737() then return end

-- Do not remove below lines: hardware detection
local wwursa = com.sim.qm.Wwursa.Open()
if not wwursa then return end
-- Do not remove above lines: hardware detection

uluaLog('URSA Throttle L for PMDG 737')

-- ===========================================================
-- button binding

wwursa:CfgRpn(25, '81101 (>K:ROTOR_BRAKE)', '81104 (>K:ROTOR_BRAKE)')
wwursa:CfgRpn(27, '81102 (>K:ROTOR_BRAKE)', '81104 (>K:ROTOR_BRAKE)')

--parking brake
wwursa:CfgRpn(28, '69301 (>K:ROTOR_BRAKE)', '69302 (>K:ROTOR_BRAKE)')
-- SET SPOILERS ARM
wwursa:CfgRpn(38, '(L:switch_679_73X) 0 == if{ 679201 (>K:ROTOR_BRAKE) }')
-- SPOILERS DOWN
wwursa:CfgRpn(37, '679101 (>K:ROTOR_BRAKE)')
---- ENG STSRT
-- ENG L IDEL
wwursa:CfgRpn(0, '(L:switch_688_73X) 100 == if{ 68801 (>K:ROTOR_BRAKE) }')
-- ENG L CUTOFF
wwursa:CfgRpn(1, '(L:switch_688_73X) 0 == if{ 68801 (>K:ROTOR_BRAKE) }')
-- ENG R IDEL
wwursa:CfgRpn(2, '(L:switch_689_73X) 100 == if{ 68901 (>K:ROTOR_BRAKE) }')
-- ENG R CUTOFF
wwursa:CfgRpn(3, '(L:switch_689_73X) 0 == if{ 68901 (>K:ROTOR_BRAKE) }')


local pswheng1 = QmdevPosSwitchInit("(L:switch_119_73X, number)", 10, "11902 (>K:ROTOR_BRAKE)",
	"11901 (>K:ROTOR_BRAKE)",
	500)
local pswheng2 = QmdevPosSwitchInit("(L:switch_121_73X, number)", 10, "12102 (>K:ROTOR_BRAKE)",
	"12101 (>K:ROTOR_BRAKE)",
	500)

function eng_starter_select(idx)
	if idx == 0 then
		--uluaCmdOnce(dr_cmd_ign1)
		wwursa:CfgPSw(6, pswheng1, 0)
		wwursa:CfgPSw(7, pswheng1, 10)
		wwursa:CfgPSw(8, pswheng1, 20)
	else
		--uluaCmdOnce(dr_cmd_ign2)
		wwursa:CfgPSw(6, pswheng2, 0)
		wwursa:CfgPSw(7, pswheng2, 10)
		wwursa:CfgPSw(8, pswheng2, 20)
	end
end

eng_starter_select(0)
wwursa:CfgFc(4, 'eng_starter_select(0)')
wwursa:CfgFc(5, 'eng_starter_select(1)')
-- ====backlight / LEDs
wwursa:GetBkl('(L:BL_Pedestal)', 255)
wwursa:GetOverallBkl('pmdg/ng3/data/MCP_indication_powered', 255)
wwursa:GetFault1('(L:switch_695_73X, number)')
wwursa:GetFault2('(L:switch_706_73X, number)')
wwursa:GetFire1('(L:switch_700_73X, number)')
wwursa:GetFire2('(A:ENG FIRE:2,Bool)')

-- ====vibration
wwursa:GetVibL('(A:SIM ON GROUND,Bool) (A:GPS GROUND SPEED,Meters per second) * 10 *')
wwursa:GetVibR('(A:SIM ON GROUND,Bool) (A:GPS GROUND SPEED,Meters per second) * 10 *')

-- ====LCD
local dr_trim = iDataRef:New('(L:RudderTrimTT,Percent)')

GlobalFrameLoopManager:add(function()
	wwursa:SetBkl()
	wwursa:SetOverallBkl()
	wwursa:Setleds() -- boolean LEDs only (FAULT/FIRE)
	wwursa:SetVibL()
	wwursa:SetVibR()
	wwursa:setLcdText(wwursa:formatTrimText(dr_trim:Get() * 0.6, false))
end)
