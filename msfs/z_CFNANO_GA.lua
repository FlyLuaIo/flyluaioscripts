-- *****************************************************************
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-06-29
-- MobiFlight CfNano / cfmfnano for GA
-- *****************************************************************

-- Do not remove below lines: hardware detection
local cfnano = com.sim.mf.CfNano:new()
if not cfnano:Init() then
	return
end
-- Do not remove above lines: hardware detection

uluaLog('MobiFlight CfNano for GA')

cfnano:GetGaEngRpm('(A:COM STANDBY FREQUENCY:1, KHz) near')

GlobalFrameLoopManager:add(function()
	cfnano:SetGaEngRpm()
end)

