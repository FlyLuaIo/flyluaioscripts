
-- *****************************************************************
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-08-08_03_55_08UTC
-- *****************************************************************

-- Do not remove below lines: hardware detection
local wwtcas = com.sim.qm.Wwtcas.Open()
if not wwtcas then return end
-- Do not remove above lines: hardware detection

uluaLog('Wwtcas for GA')
--[[
wwtcas:GetBkl('')
wwtcas:GetLcdBkl('')
wwtcas:GetLedBkl('')
wwtcas:GetAtcFail('')
]]--


GlobalFrameLoopManager:add(function()
end)
