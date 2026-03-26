
-- *****************************************************************
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-03-26_07_32_41UTC
-- *****************************************************************

-- Do not remove below lines: hardware detection
local stkradio = com.sim.qm.Stkradio:new()
if not stkradio:Init() then
	return
end
-- Do not remove above lines: hardware detection

uluaLog("Stkradio for GA")

function Stkradio_GA_Loop_Upd()
end
uluaAddDoLoop("Stkradio_GA_Loop_Upd()")
