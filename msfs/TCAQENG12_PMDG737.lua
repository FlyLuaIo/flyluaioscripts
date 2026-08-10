-- *****************************************************************
-- created by Carson Lou @ QQ 2026-08-09
-- *****************************************************************
if ilua_require_pmdg_737() then return end

-- Do not remove below lines: hardware detection
local tcaqeng12 = com.sim.qm.Tcaqeng12.Open()
if not tcaqeng12 then return end
-- Do not remove above lines: hardware detection

uluaLog('TCA Q-Eng 1&2 for PMDG 737')

-- ===========================================================
-- button binding

-- SET SPOILERS ARM/DOWN
tcaqeng12:CfgRpn(24, '(L:switch_679_73X) 0 == if{ 679201 (>K:ROTOR_BRAKE) }', '679101 (>K:ROTOR_BRAKE)')

---- ENG STSRT
-- ENG L IDEL/CUTOFF
tcaqeng12:CfgRpn(2, '(L:switch_688_73X) 100 == if{ 68801 (>K:ROTOR_BRAKE) }',
    '(L:switch_688_73X) 0 == if{ 68801 (>K:ROTOR_BRAKE) }')
-- ENG R IDEL/CUTOFF
tcaqeng12:CfgRpn(3, '(L:switch_689_73X) 100 == if{ 68901 (>K:ROTOR_BRAKE) }',
    '(L:switch_689_73X) 0 == if{ 68901 (>K:ROTOR_BRAKE) }')

---- AUTOBREAK
local pswh15 = QmdevPosSwitchInit("(L:switch_460_73X, number)", 10, "46007 (>K:ROTOR_BRAKE)", "46008 (>K:ROTOR_BRAKE)",
    100)
tcaqeng12:CfgPSw(21, pswh15, 10, 0)
tcaqeng12:CfgPSw(22, pswh15, 20)
tcaqeng12:CfgPSw(23, pswh15, 30)
