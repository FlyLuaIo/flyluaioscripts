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

-- SET SPOILERS ARM
wwursa:CfgRpn(39, '679201 (>K:ROTOR_BRAKE)')
-- SPOILERS DOWN
wwursa:CfgRpn(38, '679101 (>K:ROTOR_BRAKE)')
---- ENG STSRT
-- ENG L IDEL
wwursa:CfgRpn(1, '68801 (>K:ROTOR_BRAKE)')
-- ENG L CUTOFF
wwursa:CfgRpn(2, '68802 (>K:ROTOR_BRAKE)')
-- ENG R IDEL
wwursa:CfgRpn(3, '68901 (>K:ROTOR_BRAKE)')
-- ENG R CUTOFF
wwursa:CfgRpn(4, '68902 (>K:ROTOR_BRAKE)')

