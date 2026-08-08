
-- *****************************************************************
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-08-08_03_55_08UTC
-- *****************************************************************

-- Do not remove below lines: hardware detection
local wwursa = com.sim.qm.Wwursa.Open()
if not wwursa then return end
-- Do not remove above lines: hardware detection

uluaLog('Wwursa for GA')
--[[
wwursa:GetBkl('')
wwursa:GetMaker('')
wwursa:GetFault1('')
wwursa:GetFire1('')
wwursa:GetFault2('')
wwursa:GetFire2('')
wwursa:GetVibL('')
wwursa:GetVibR('')
wwursa:GetBkl('')
wwursa:GetLcdBkl('')
]]--


GlobalFrameLoopManager:add(function()
end)
