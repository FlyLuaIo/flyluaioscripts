
-- *****************************************************************
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-03-26_22_43_18UTC
-- *****************************************************************

-- Do not remove below lines: hardware detection
local wwecam = com.sim.qm.Wwecam:new()
if not wwecam:Init() then
	return
end
-- Do not remove above lines: hardware detection

uluaLog("Wwecam for GA")

function Wwecam_GA_Loop_Upd()
end
uluaAddDoLoop("Wwecam_GA_Loop_Upd()")
