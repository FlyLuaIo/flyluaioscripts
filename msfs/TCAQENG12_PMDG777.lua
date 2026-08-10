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

-- SET SPOILERS ARM
--tcaqeng12:CfgRpn(39, '679201 (>K:ROTOR_BRAKE)')
-- SPOILERS DOWN
--tcaqeng12:CfgRpn(38, '679101 (>K:ROTOR_BRAKE)')
---- ENG STSRT
-- ENG L IDEL/CUTOFF
tcaqeng12:CfgRpn(2, '(L:switch_520_a) 100 == if{ 52001 (>K:ROTOR_BRAKE) }',
	'(L:switch_520_a) 0 == if{ 52001 (>K:ROTOR_BRAKE) }')
-- ENG R IDEL/CUTOFF
tcaqeng12:CfgRpn(3, '(L:switch_521_a) 100 == if{ 52101 (>K:ROTOR_BRAKE) }',
	'(L:switch_521_a) 0 == if{ 52101 (>K:ROTOR_BRAKE) }')
---- AUTOBREAK
-- RTO --21号UP (这个是当松开有动作的脚本不知道怎么写)
--tcaqeng12:CfgRpn(X, '0 (L:switch_292_a) - 10 div s0:1 l0 0 > if{ 29207 (>K:ROTOR_BRAKE) l0 -- s0 g1 } l0 0 < if{ 29208 (>K:ROTOR_BRAKE) l0 ++ s0 g1 }')
-- OFF --21号DOWN
tcaqeng12:CfgRpn(21,
	'10 (L:switch_292_a) - 10 div s0:1 l0 0 > if{ 29207 (>K:ROTOR_BRAKE) l0 -- s0 g1 } l0 0 < if{ 29208 (>K:ROTOR_BRAKE) l0 ++ s0 g1 }')
-- 1  -- 22号DOWN (因为会同时触发21号UP，所以这里需要做个延时生效)
tcaqeng12:CfgRpn(22,
	'30 (L:switch_292_a) - 10 div s0:1 l0 0 > if{ 29207 (>K:ROTOR_BRAKE) l0 -- s0 g1 } l0 0 < if{ 29208 (>K:ROTOR_BRAKE) l0 ++ s0 g1 }')
-- 2  -- 23号DOWN
tcaqeng12:CfgRpn(23,
	'40 (L:switch_292_a) - 10 div s0:1 l0 0 > if{ 29207 (>K:ROTOR_BRAKE) l0 -- s0 g1 } l0 0 < if{ 29208 (>K:ROTOR_BRAKE) l0 ++ s0 g1 }')
-- 3  -- 24号DOWN
tcaqeng12:CfgRpn(24,
	'50 (L:switch_292_a) - 10 div s0:1 l0 0 > if{ 29207 (>K:ROTOR_BRAKE) l0 -- s0 g1 } l0 0 < if{ 29208 (>K:ROTOR_BRAKE) l0 ++ s0 g1 }')
-- MAX  -- 25号DOWN
tcaqeng12:CfgRpn(25,
	'70 (L:switch_292_a) - 10 div s0:1 l0 0 > if{ 29207 (>K:ROTOR_BRAKE) l0 -- s0 g1 } l0 0 < if{ 29208 (>K:ROTOR_BRAKE) l0 ++ s0 g1 }')

--我上面的脚本不是最好的，想用你下面AGP的脚本，但是这个是按键，不是旋钮，我不会改
-- autobrake
--local dr_autobrake = iDataRef:New('(L:switch_292_a, number)')
--local pswh_autobrake = QmdevPosSwitchInit("(L:switch_292_a, number)", 10, "29207 (>K:ROTOR_BRAKE)",
--"29208 (>K:ROTOR_BRAKE)", 100)

--function autobrake_low()
--if dr_autobrake:Get() == 10 then
--QmdevPosSwitchSet(pswh_autobrake, 30)
--else
--QmdevPosSwitchSet(pswh_autobrake, 10)
---end
--end

--function autobrake_med()
--if dr_autobrake:Get() == 10 then
--QmdevPosSwitchSet(pswh_autobrake, 40)
--else
--QmdevPosSwitchSet(pswh_autobrake, 10)
--end
--end

--tcaqeng12:CfgFc(2, 'autobrake_low()')
--tcaqeng12:CfgFc(3, 'autobrake_med()')

--function key_max_long_func()
--if dr_autobrake:Get() == 10 then
--QmdevPosSwitchSet(pswh_autobrake, 0)
--else
--QmdevPosSwitchSet(pswh_autobrake, 10)
--end
--end

--function key_max_short_func()
--if dr_autobrake:Get() == 10 then
--QmdevPosSwitchSet(pswh_autobrake, 70)
--else
--QmdevPosSwitchSet(pswh_autobrake, 10)
--end
--end
--tcaqeng12:CfgLongFc(4, 1000, key_max_long_func, key_max_short_func)
