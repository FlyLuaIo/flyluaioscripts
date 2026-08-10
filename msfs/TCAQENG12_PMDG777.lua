-- *****************************************************************
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-08-06_21_26_18UTC
-- *****************************************************************
if ilua_require_pmdg_777() then return end

-- Do not remove below lines: hardware detection
local tcaqeng12 = com.sim.qm.Tcaqeng12.Open()
if not tcaqeng12 then return end
-- Do not remove above lines: hardware detection

uluaLog('Tcaqeng12 for PMDG 777')

-- ===========================================================
-- button binding

-- SET SPOILERS ARM/DOWN
tcaqeng12:CfgRpn(24, '(L:switch_498_a) 0 == if{ 498201 (>K:ROTOR_BRAKE)',
    '(L:switch_498_a) 200 == if{ 498201 (>K:ROTOR_BRAKE)')

---- ENG STSRT
-- ENG L IDEL/CUTOFF
tcaqeng12:CfgRpn(2, '(L:switch_520_a) 100 == if{ 52001 (>K:ROTOR_BRAKE) }',
    '(L:switch_520_a) 0 == if{ 52001 (>K:ROTOR_BRAKE) }')
-- ENG R IDEL/CUTOFF
tcaqeng12:CfgRpn(3, '(L:switch_521_a) 100 == if{ 52101 (>K:ROTOR_BRAKE) }',
    '(L:switch_521_a) 0 == if{ 52101 (>K:ROTOR_BRAKE) }')
---- AUTOBREAK
local pswh15 = QmdevPosSwitchInit("(L:switch_292_a, number)", 10, "29207 (>K:ROTOR_BRAKE)", "29208 (>K:ROTOR_BRAKE)", 100)
tcaqeng12:CfgPSw(21, pswh15, 10, 0)
tcaqeng12:CfgPSw(22, pswh15, 40)
tcaqeng12:CfgPSw(23, pswh15, 50)
