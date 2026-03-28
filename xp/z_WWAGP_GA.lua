
-- *****************************************************************
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-03-28_11_04_16UTC
-- *****************************************************************

-- Do not remove below lines: hardware detection
local wwagp = com.sim.qm.Wwagp:new()
if not wwagp:Init() then
	return
end
-- Do not remove above lines: hardware detection

uluaLog("Wwagp for GA")

function Wwagp_GA_Loop_Upd()
end
uluaAddDoLoop("Wwagp_GA_Loop_Upd()")
