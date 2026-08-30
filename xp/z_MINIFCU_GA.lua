-- *****************************************************************
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-08-30
-- MobiFlight MiniFCU / miniCOCKPIT miniFCU for GA
-- *****************************************************************

-- Do not remove below lines: hardware detection
local minifcu = com.sim.mf.MiniFCU.Open()
if not minifcu then return end
-- Do not remove above lines: hardware detection

uluaLog('MobiFlight MiniFCU for GA')

-- INPUT key bindings (keysmap bits from mobiflight/MiniFCU.json)

---- TOLISS - FCU - ALT - ENCODER
-- inner
minifcu:CfgCmd(47, "sim/operation/test_none")
minifcu:CfgCmd(48, "sim/operation/test_none")
-- outer
minifcu:CfgCmd(49, "sim/operation/test_none")
minifcu:CfgCmd(50, "sim/operation/test_none")

---- TOLISS - FCU - SPD - ENCODER
-- inner
minifcu:CfgCmd(51, "sim/operation/test_none")
minifcu:CfgCmd(52, "sim/operation/test_none")
-- outer
minifcu:CfgCmd(53, "sim/operation/test_none")
minifcu:CfgCmd(54, "sim/operation/test_none")

---- TOLISS - FCU - HDG - ENCODER
-- inner
minifcu:CfgCmd(55, "sim/operation/test_none")
minifcu:CfgCmd(56, "sim/operation/test_none")
-- outer
minifcu:CfgCmd(57, "sim/operation/test_none")
minifcu:CfgCmd(58, "sim/operation/test_none")

---- TOLISS - FCU - VS - ENCODER
-- inner
minifcu:CfgCmd(59, "sim/operation/test_none")
minifcu:CfgCmd(60, "sim/operation/test_none")
-- outer
minifcu:CfgCmd(61, "sim/operation/test_none")
minifcu:CfgCmd(62, "sim/operation/test_none")

---- TOLISS - EFIS - BAR ENCODER HPA
-- inner
minifcu:CfgCmd(63, "sim/operation/test_none")
minifcu:CfgCmd(64, "sim/operation/test_none")
-- outer
minifcu:CfgCmd(65, "sim/operation/test_none")
minifcu:CfgCmd(66, "sim/operation/test_none")

-- TOLISS - FCU - SPD/MACH (Button, bit 0)
minifcu:CfgCmd(0, "sim/operation/test_none")

-- TOLISS - FCU - HDG/TRK (Button, bit 1)
minifcu:CfgCmd(1, "sim/operation/test_none")

-- TOLISS - FCU - AP1 - BUTTON (Button, bit 2)
minifcu:CfgCmd(2, "sim/operation/test_none")

-- TOLISS - FCU - AP 2 - BUTTON (Button, bit 3)
minifcu:CfgCmd(3, "sim/operation/test_none")

-- TOLISS - FCU - METRIC ALT Button (Button, bit 4)
minifcu:CfgCmd(4, "sim/operation/test_none")

-- TOLISS - FCU - ATHR - BUTTON (Button, bit 5)
minifcu:CfgCmd(5, "sim/operation/test_none")

-- TOLISS - FCU - EXPED - BUTTON (Button, bit 6)
minifcu:CfgCmd(6, "sim/operation/test_none")

-- TOLISS - FCU - LOC - BUTTON (Button, bit 7)
minifcu:CfgCmd(7, "sim/operation/test_none")

-- TOLISS - FCU - APPR - BUTTON (Button, bit 8)
minifcu:CfgCmd(8, "sim/operation/test_none")

-- TOLISS - FCU - SPD - PUSH (Button, bit 9)
minifcu:CfgCmd(9, "sim/operation/test_none")

-- TOLISS - FCU - SPD - PULL (Button, bit 10)
minifcu:CfgCmd(10, "sim/operation/test_none")

-- TOLISS - FCU - HDG - PUSH (Button, bit 11)
minifcu:CfgCmd(11, "sim/operation/test_none")

-- TOLISS - FCU - HDG - PULL (Button, bit 12)
minifcu:CfgCmd(12, "sim/operation/test_none")

-- TOLISS - FCU - ALT - PUSH (Button, bit 13)
minifcu:CfgCmd(13, "sim/operation/test_none")

-- TOLISS - FCU - ALT - PULL (Button, bit 14)
minifcu:CfgCmd(14, "sim/operation/test_none")

-- TOLISS - FCU - VS - PUSH (Button, bit 15)
minifcu:CfgCmd(15, "sim/operation/test_none")

-- TOLISS - FCU - VS - PULL (Button, bit 16)
minifcu:CfgCmd(16, "sim/operation/test_none")

-- TOLISS - FCU - ALT 100/1000 (Button, bit 17)
minifcu:CfgCmd(17, "sim/operation/test_none")

-- TOLISS - EFIS - CSTR (Button, bit 18)
minifcu:CfgCmd(18, "sim/operation/test_none")

-- TOLISS - EFIS - WPT (Button, bit 19)
minifcu:CfgCmd(19, "sim/operation/test_none")

-- TOLISS - EFIS - VORD (Button, bit 20)
minifcu:CfgCmd(20, "sim/operation/test_none")

-- TOLISS - EFIS - NDB (Button, bit 21)
minifcu:CfgCmd(21, "sim/operation/test_none")

-- TOLISS - EFIS - ARPT (Button, bit 22)
minifcu:CfgCmd(22, "sim/operation/test_none")

-- TOLISS - EFIS - FD (Button, bit 23)
minifcu:CfgCmd(23, "sim/operation/test_none")

-- TOLISS - EFIS - LS (Button, bit 24)
minifcu:CfgCmd(24, "sim/operation/test_none")

-- TOLISS - EFIS - CHRONO (Button, bit 25)
minifcu:CfgCmd(25, "sim/operation/test_none")

-- TOLISS - EFIS - ROSE LS (Button, bit 26)
minifcu:CfgCmd(26, "sim/operation/test_none")

-- TOLISS - EFIS - ROSE VOR (Button, bit 27)
minifcu:CfgCmd(27, "sim/operation/test_none")

-- TOLISS - EFIS - ROSE NAV (Button, bit 28)
minifcu:CfgCmd(28, "sim/operation/test_none")

-- TOLISS - EFIS - ROSE ARC (Button, bit 29)
minifcu:CfgCmd(29, "sim/operation/test_none")

-- TOLISS - EFIS - ROSE HIDDEN  (Button, bit 30)
minifcu:CfgCmd(30, "sim/operation/test_none")

-- TOLISS - EFIS - RANGE 10 (Button, bit 31)
minifcu:CfgCmd(31, "sim/operation/test_none")

-- TOLISS - EFIS - RANGE 20 (Button, bit 32)
minifcu:CfgCmd(32, "sim/operation/test_none")

-- TOLISS - EFIS - RANGE 40 (Button, bit 33)
minifcu:CfgCmd(33, "sim/operation/test_none")

-- TOLISS - EFIS - RANGE 80 (Button, bit 34)
minifcu:CfgCmd(34, "sim/operation/test_none")

-- TOLISS - EFIS - RANGE 160 (Button, bit 35)
minifcu:CfgCmd(35, "sim/operation/test_none")

-- TOLISS - EFIS - RANGE 320 (Button, bit 36)
minifcu:CfgCmd(36, "sim/operation/test_none")

-- TOLISS - EFIS - ADF 1 (Button, bit 37)
minifcu:CfgCmd(37, "sim/operation/test_none")

-- TOLISS - EFIS - OFF 1 (Button, bit 38)
minifcu:CfgCmd(38, "sim/operation/test_none")

-- TOLISS - EFIS - VOR 1 (Button, bit 39)
minifcu:CfgCmd(39, "sim/operation/test_none")

-- TOLISS - EFIS - ADF 2 (Button, bit 40)
minifcu:CfgCmd(40, "sim/operation/test_none")

-- TOLISS - EFIS - OFF 2 (Button, bit 41)
minifcu:CfgCmd(41, "sim/operation/test_none")

-- TOLISS - EFIS - VOR 2 (Button, bit 42)
minifcu:CfgCmd(42, "sim/operation/test_none")

-- TOLISS - EFIS - BARO UNIT HPA (Button, bit 43)
minifcu:CfgCmd(43, "sim/operation/test_none")

-- TOLISS - EFIS - BARO UNIT INHG (Button, bit 44)
minifcu:CfgCmd(44, "sim/operation/test_none")

-- TOLISS - EFIS - BARO PULL (Button, bit 45)
minifcu:CfgCmd(45, "sim/operation/test_none")

-- TOLISS - EFIS - BARO PUSH (Button, bit 46)
minifcu:CfgCmd(46, "sim/operation/test_none")

-- OUTPUT data

-- output AP1 → output/0/state (0/1)
minifcu:GetAp1('sim/flightmodel/engine/ENGN_N1_', 1)

-- output AP2 → output/1/state (0/1)
minifcu:GetAp2('sim/flightmodel/engine/ENGN_N1_', 1)

-- output APPR → output/2/state (0/1)
minifcu:GetAppr('sim/flightmodel/engine/ENGN_N1_', 1)

-- output ATHR → output/3/state (0/1)
minifcu:GetAthr('sim/flightmodel/engine/ENGN_N1_', 1)

-- output EXPED → output/4/state (0/1)
minifcu:GetExped('sim/flightmodel/engine/ENGN_N1_', 1)

-- output LOC → output/5/state (0/1)
minifcu:GetLoc('sim/flightmodel/engine/ENGN_N1_', 1)

GlobalFrameLoopManager:add(function()
	-- minifcu:SetAp1()
	-- minifcu:SetAp2()
	-- minifcu:SetAppr()
	-- minifcu:SetAthr()
	-- minifcu:SetExped()
	-- minifcu:SetLoc()
end)
