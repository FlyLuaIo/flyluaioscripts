-- *****************************************************************
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-06-29
-- MobiFlight CfMega / G1000 for GA
-- *****************************************************************

-- Do not remove below lines: hardware detection
local cfmega = com.sim.mf.CfMega:new()
if not cfmega:Init() then
	return
end
-- Do not remove above lines: hardware detection

uluaLog('MobiFlight CfMega for GA')

-- INPUT key bindings (keysmap bits from mobiflight/CfMega.json)

---- G1000 FMS inner
-- inner
cfmega:CfgCmd(0, "sim/radios/stby_com1_fine_down_833")
cfmega:CfgCmd(1, "sim/radios/stby_com1_fine_up_833")
-- outer
cfmega:CfgCmd(2, "sim/radios/stby_com1_coarse_down")
cfmega:CfgCmd(3, "sim/radios/stby_com1_coarse_up")

---- G1000 Heading
-- inner
cfmega:CfgCmd(4, "sim/autopilot/heading_down")
cfmega:CfgCmd(5, "sim/autopilot/heading_up")
-- outer
cfmega:CfgCmd(6, "sim/autopilot/heading_down")
cfmega:CfgCmd(7, "sim/autopilot/heading_up")

---- G1000 FMS outer
-- inner
cfmega:CfgCmd(8, "sim/GPS/g1000n3_fms_outer_down")
cfmega:CfgCmd(9, "sim/GPS/g1000n3_fms_outer_up")
-- outer
cfmega:CfgCmd(10, "sim/GPS/g1000n3_fms_outer_down")
cfmega:CfgCmd(11, "sim/GPS/g1000n3_fms_outer_up")

-- G1000 FMS push (Button, bit 12)
cfmega:CfgCmd(12, "sim/GPS/g1000n3_cursor")

-- G1000 ENT (Button, bit 13)
cfmega:CfgCmd(13, "sim/GPS/g1000n3_ent")

-- OUTPUT data

-- ENG RPM stepper (scale may need tuning for your stepper module)
cfmega:GetEngRpm('sim/cockpit2/engine/indicators/N1_percent[0]', 10)

GlobalFrameLoopManager:add(function()
	cfmega:SetEngRpm()
end)
