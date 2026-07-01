-- *****************************************************************
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-06-29
-- MobiFlight CfMega / MF Mega Pro for GA
-- *****************************************************************

-- Do not remove below lines: hardware detection
local cfmega = com.sim.mf.CfMega.Open()
if not cfmega then return end
-- Do not remove above lines: hardware detection

uluaLog('MobiFlight CfMega for GA')

-- INPUT key bindings (keysmap bits from mobiflight/CfMega.json)

---- G1000 FMS inner
-- inner
cfmega:CfgCmd(0, 'sim/radios/stby_com1_fine_down_833')
cfmega:CfgCmd(1, 'sim/radios/stby_com1_fine_down_833')
-- outer
cfmega:CfgCmd(2, 'sim/radios/stby_com1_fine_up_833')
cfmega:CfgCmd(3, 'sim/radios/stby_com1_fine_up_833')


---- G1000 FMS outer
-- inner
cfmega:CfgCmd(4, 'sim/radios/stby_com1_coarse_down_833')
cfmega:CfgCmd(5, 'sim/radios/stby_com1_coarse_down_833')
-- outer
cfmega:CfgCmd(6, 'sim/radios/stby_com1_coarse_up_833')
cfmega:CfgCmd(7, 'sim/radios/stby_com1_coarse_up_833')

-- G1000 FMS push (Button, bit 12)
cfmega:CfgCmd(8, 'sim/radios/com1_standy_flip')

-- G1000 ENT (Button, bit 13)
cfmega:CfgCmd(9, 'sim/GPS/g1000n1_ent')

-- OUTPUT data

-- ENG RPM stepper (scale may need tuning for your stepper module)
cfmega:GetEngRpm('sim/cockpit2/engine/indicators/engine_speed_rpm[0]', 1)

GlobalFrameLoopManager:add(function()
	cfmega:SetEngRpm()
end)
