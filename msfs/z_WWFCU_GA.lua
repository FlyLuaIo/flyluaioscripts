
-- *****************************************************************
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-08-08_03_55_08UTC
-- *****************************************************************

-- Do not remove below lines: hardware detection
local wwfcu = com.sim.qm.Wwfcu.Open()
if not wwfcu then return end
-- Do not remove above lines: hardware detection

uluaLog('Wwfcu for GA')
--[[
wwfcu:GetBkl('')
wwfcu:GetScrBkl('')
wwfcu:GetLedBkl('')
wwfcu:GetLoc('')
wwfcu:GetAp1('')
wwfcu:GetAp2('')
wwfcu:GetAthr('')
wwfcu:GetExped('')
wwfcu:GetAppr('')
wwfcu:GetExpedBkl('')
]]--


GlobalFrameLoopManager:add(function()
end)
