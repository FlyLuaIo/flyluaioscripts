-- *****************************************************************
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-06-29
-- MobiFlight CfNano / cfmfnano for GA
-- *****************************************************************

-- Do not remove below lines: hardware detection
local cfnano = com.sim.mf.CfNano.Open()
if not cfnano then return end
-- Do not remove above lines: hardware detection

uluaLog('MobiFlight CfNano for GA')

cfnano:GetGaEngRpm('sim/cockpit2/radios/actuators/com1_standby_frequency_hz_833')

GlobalFrameLoopManager:add(function()
	cfnano:SetGaEngRpm()
end)

