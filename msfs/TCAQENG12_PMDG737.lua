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

---- eng_starter_select
local pswheng1 = QmdevPosSwitchInit("(L:switch_119_73X, number)", 10, "11902 (>K:ROTOR_BRAKE)",
    "11901 (>K:ROTOR_BRAKE)",
    500)
local pswheng2 = QmdevPosSwitchInit("(L:switch_121_73X, number)", 10, "12102 (>K:ROTOR_BRAKE)",
    "12101 (>K:ROTOR_BRAKE)",
    500)

function eng_starter_select(idx)
    if idx == 0 then
        --uluaCmdOnce(dr_cmd_ign1)
        tcaqeng12:CfgPSw(6, pswheng1, 0)
        tcaqeng12:CfgPSw(7, pswheng1, 10)
        tcaqeng12:CfgPSw(8, pswheng1, 20)
    else
        --uluaCmdOnce(dr_cmd_ign2)
        tcaqeng12:CfgPSw(6, pswheng2, 0)
        tcaqeng12:CfgPSw(7, pswheng2, 10)
        tcaqeng12:CfgPSw(8, pswheng2, 20)
    end
end

eng_starter_select(0)
tcaqeng12:CfgFc(4, 'eng_starter_select(0)')
tcaqeng12:CfgFc(5, 'eng_starter_select(1)')
