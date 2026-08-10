-- *****************************************************************
-- created by Carson Lou @ QQ 2026-08-09
-- *****************************************************************
if ilua_require_pmdg_777() then return end

-- Do not remove below lines: hardware detection
local wwursa = com.sim.qm.Wwursa.Open()
if not wwursa then return end
-- Do not remove above lines: hardware detection

uluaLog('URSA Throttle L for PMDG 777')

-- ===========================================================
-- button binding

-- SET SPOILERS ARM
wwursa:CfgRpn(38, '(L:switch_498_a) 0 == if{ 498201 (>K:ROTOR_BRAKE) ')
-- SPOILERS DOWN
wwursa:CfgRpn(37, '(L:switch_498_a) 200 == if{ 498201 (>K:ROTOR_BRAKE) ')
---- ENG STSRT
-- ENG L IDEL
wwursa:CfgRpn(0, '(L:switch_520_a) 100 == if{ 52001 (>K:ROTOR_BRAKE) }')
-- ENG L CUTOFF
wwursa:CfgRpn(1, '(L:switch_520_a) 0 == if{ 52001 (>K:ROTOR_BRAKE) }')
-- ENG R IDEL
wwursa:CfgRpn(2, '(L:switch_521_a) 100 == if{ 52101 (>K:ROTOR_BRAKE) }')
-- ENG R CUTOFF
wwursa:CfgRpn(3, '(L:switch_521_a) 0 == if{ 52101 (>K:ROTOR_BRAKE) }')
