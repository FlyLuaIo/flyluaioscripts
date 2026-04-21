
-- *****************************************************************
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-04-21_09_04_30UTC
-- *****************************************************************

-- Do not remove below lines: hardware detection
local wffcuc = com.sim.qm.Wffcuc:new()
if not wffcuc:Init() then
	return
end
-- Do not remove above lines: hardware detection

uluaLog('Wffcuc for GA')
--[[
wffcuc:GetLoc('')
wffcuc:GetAp1('')
wffcuc:GetAp2('')
wffcuc:GetAthr('')
wffcuc:GetExped('')
wffcuc:GetAppr('')
wffcuc:GetMang('')
wffcuc:GetDash('')
wffcuc:GetMang('')
wffcuc:GetDash('')
wffcuc:GetMang('')
wffcuc:GetDash('')
wffcuc:GetMach('')
wffcuc:GetTrk('')
wffcuc:GetTest('')
wffcuc:GetPower('')
]]--


function Wffcuc_GA_Loop_Upd()
	-- wffcuc:SetLeds()
end
uluaAddDoLoop('Wffcuc_GA_Loop_Upd()')
