
-- *****************************************************************
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-08-06_21_26_18UTC
-- *****************************************************************

-- Do not remove below lines: hardware detection
local tcaqeng12 = com.sim.qm.Tcaqeng12.Open()
if not tcaqeng12 then return end
-- Do not remove above lines: hardware detection

uluaLog('Tcaqeng12 for GA')

GlobalFrameLoopManager:add(function()
end)
