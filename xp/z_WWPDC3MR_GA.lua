
-- *****************************************************************
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-08-08_03_55_08UTC
-- *****************************************************************

-- Do not remove below lines: hardware detection
local wwpdc3mr = com.sim.qm.Wwpdc3mr.Open()
if not wwpdc3mr then return end
-- Do not remove above lines: hardware detection

uluaLog('Wwpdc3mr for GA')
--[[
wwpdc3mr:GetBkl('')
]]--


GlobalFrameLoopManager:add(function()
end)
