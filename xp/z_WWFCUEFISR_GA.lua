
-- *****************************************************************
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-08-08_03_55_08UTC
-- *****************************************************************

-- Do not remove below lines: hardware detection
local wwfcuefisr = com.sim.qm.Wwfcuefisr.Open()
if not wwfcuefisr then return end
-- Do not remove above lines: hardware detection

uluaLog('Wwfcuefisr for GA')
--[[
wwfcuefisr:GetBkl('')
wwfcuefisr:GetScrBkl('')
wwfcuefisr:GetLedBkl('')
wwfcuefisr:GetLoc('')
wwfcuefisr:GetAp1('')
wwfcuefisr:GetAp2('')
wwfcuefisr:GetAthr('')
wwfcuefisr:GetExped('')
wwfcuefisr:GetAppr('')
wwfcuefisr:GetExpedBkl('')
wwfcuefisr:GetBkl('')
wwfcuefisr:GetScrBkl('')
wwfcuefisr:GetLedBkl('')
wwfcuefisr:GetFd('')
wwfcuefisr:GetLs('')
wwfcuefisr:GetCstr('')
wwfcuefisr:GetWpt('')
wwfcuefisr:GetVord('')
wwfcuefisr:GetNdb('')
wwfcuefisr:GetArpt('')
]]--


GlobalFrameLoopManager:add(function()
end)
