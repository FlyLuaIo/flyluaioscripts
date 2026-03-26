
-- *****************************************************************
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-03-26_07_04_49UTC
-- *****************************************************************

-- Do not remove below lines: hardware detection
local stkradio = com.sim.qm.Stkradio:new()
if not stkradio:Init() then
	return
end
-- Do not remove above lines: hardware detection

uluaLog("Stkradio for GA")
