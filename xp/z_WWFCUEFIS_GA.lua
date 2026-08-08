
-- *****************************************************************
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-08-08_03_55_08UTC
-- *****************************************************************

-- Do not remove below lines: hardware detection
local wwfcuefis = com.sim.qm.Wwfcuefis.Open()
if not wwfcuefis then return end
-- Do not remove above lines: hardware detection

uluaLog('Wwfcuefis for GA')
--[[
wwfcuefis:GetBkl('')
wwfcuefis:GetScrBkl('')
wwfcuefis:GetLedBkl('')
wwfcuefis:GetLoc('')
wwfcuefis:GetAp1('')
wwfcuefis:GetAp2('')
wwfcuefis:GetAthr('')
wwfcuefis:GetExped('')
wwfcuefis:GetAppr('')
wwfcuefis:GetExpedBkl('')
wwfcuefis:GetBkl('')
wwfcuefis:GetScrBkl('')
wwfcuefis:GetLedBkl('')
wwfcuefis:GetFd('')
wwfcuefis:GetLs('')
wwfcuefis:GetCstr('')
wwfcuefis:GetWpt('')
wwfcuefis:GetVord('')
wwfcuefis:GetNdb('')
wwfcuefis:GetArpt('')
wwfcuefis:GetBkl('')
wwfcuefis:GetScrBkl('')
wwfcuefis:GetLedBkl('')
wwfcuefis:GetFd('')
wwfcuefis:GetLs('')
wwfcuefis:GetCstr('')
wwfcuefis:GetWpt('')
wwfcuefis:GetVord('')
wwfcuefis:GetNdb('')
wwfcuefis:GetArpt('')
]]--


GlobalFrameLoopManager:add(function()
end)
