
-- *****************************************************************
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-08-08_03_55_08UTC
-- *****************************************************************
if ilua_require_msfs() then
    return
end
-- Do not remove below lines: hardware detection
local wwpap3 = com.sim.qm.Wwpap3.Open()
if not wwpap3 then return end
-- Do not remove above lines: hardware detection

uluaLog('Wwpap3 for GA')
--[[
wwpap3:GetBkl('')
wwpap3:GetLcdBkl('')
wwpap3:GetLedBkl('')
wwpap3:GetN1('')
wwpap3:GetSpeed('')
wwpap3:GetVnav('')
wwpap3:GetLvlChg('')
wwpap3:GetHdgSel('')
wwpap3:GetLnav('')
wwpap3:GetVorLoc('')
wwpap3:GetApp('')
wwpap3:GetAltHld('')
wwpap3:GetVs('')
wwpap3:GetCmdA('')
wwpap3:GetCwsA('')
wwpap3:GetCmdB('')
wwpap3:GetCwsB('')
wwpap3:GetAtArm('')
wwpap3:GetMaCapt('')
wwpap3:GetMaFo('')
wwpap3:GetAtSol('')
]]--


GlobalFrameLoopManager:add(function()
end)
