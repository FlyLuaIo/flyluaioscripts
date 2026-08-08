
-- *****************************************************************
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-08-08_03_55_08UTC
-- *****************************************************************

-- Do not remove below lines: hardware detection
local wwfcuefisl = com.sim.qm.Wwfcuefisl.Open()
if not wwfcuefisl then return end
-- Do not remove above lines: hardware detection

uluaLog('Wwfcuefisl for GA')
--[[
wwfcuefisl:GetBkl('')
wwfcuefisl:GetScrBkl('')
wwfcuefisl:GetLedBkl('')
wwfcuefisl:GetLoc('')
wwfcuefisl:GetAp1('')
wwfcuefisl:GetAp2('')
wwfcuefisl:GetAthr('')
wwfcuefisl:GetExped('')
wwfcuefisl:GetAppr('')
wwfcuefisl:GetExpedBkl('')
wwfcuefisl:GetBkl('')
wwfcuefisl:GetScrBkl('')
wwfcuefisl:GetLedBkl('')
wwfcuefisl:GetFd('')
wwfcuefisl:GetLs('')
wwfcuefisl:GetCstr('')
wwfcuefisl:GetWpt('')
wwfcuefisl:GetVord('')
wwfcuefisl:GetNdb('')
wwfcuefisl:GetArpt('')
]]--


GlobalFrameLoopManager:add(function()
end)
