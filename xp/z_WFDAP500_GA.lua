
-- *****************************************************************
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-05-11_08_31_31UTC
-- *****************************************************************

-- Do not remove below lines: hardware detection
local wfdap500 = com.sim.qm.Wfdap500:new()
if not wfdap500:Init() then
	return
end
-- Do not remove above lines: hardware detection

uluaLog('Wfdap500 for GA')
--[[
wfdap500:GetApr('')
wfdap500:GetNav('')
wfdap500:GetTrk('')
wfdap500:GetHdg('')
wfdap500:GetAp('')
wfdap500:GetFd('')
wfdap500:GetLvl('')
wfdap500:GetYd('')
wfdap500:GetIas('')
wfdap500:GetVnav('')
wfdap500:GetVs('')
wfdap500:GetAlt('')
]]--


function Wfdap500_GA_Loop_Upd()
	-- wfdap500:SetLeds()
end
uluaAddDoLoop('Wfdap500_GA_Loop_Upd()')
