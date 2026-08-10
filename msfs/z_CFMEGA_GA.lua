-- *****************************************************************
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-08-11
-- MobiFlight CfMega / MF Mega Pro for GA (MSFS)
-- *****************************************************************
if ilua_require_msfs() then
	return
end

-- Do not remove below lines: hardware detection
local cfmega = com.sim.mf.CfMega.Open()
if not cfmega then return end
-- Do not remove above lines: hardware detection

uluaLog('MobiFlight CfMega for GA (MSFS)')

-- INPUT key bindings (keysmap bits from mobiflight/CfMega.json)

---- G1000 analog (AnalogInput Axis / MapToBit 10 → panel pot 0..100)
-- (0 - adc) / -10.23 ≈ adc/10.23; clamp [0,100]
cfmega:CfgAnalog(10, '(>K:LIGHT_POTENTIOMETER_1_SET)', 0, -10.23, 0, 100)

---- G1000 FMS inner → COM1 fine (833)
cfmega:CfgRpn(0, '(>K:COM_RADIO_FRACT_DEC)')
cfmega:CfgRpn(1, '(>K:COM_RADIO_FRACT_DEC)')
cfmega:CfgRpn(2, '(>K:COM_RADIO_FRACT_INC)')
cfmega:CfgRpn(3, '(>K:COM_RADIO_FRACT_INC)')

---- G1000 FMS outer → COM1 coarse
cfmega:CfgRpn(4, '(>K:COM_RADIO_WHOLE_DEC)')
cfmega:CfgRpn(5, '(>K:COM_RADIO_WHOLE_DEC)')
cfmega:CfgRpn(6, '(>K:COM_RADIO_WHOLE_INC)')
cfmega:CfgRpn(7, '(>K:COM_RADIO_WHOLE_INC)')

-- G1000 FMS push (Button, bit 8)
cfmega:CfgRpn(8, '(>K:COM_STBY_RADIO_SWAP)')

-- G1000 ENT (Button, bit 9)
cfmega:CfgRpn(9, '(>H:AS1000_PFD_ENT_Push)')

-- OUTPUT data

-- ENG RPM stepper
cfmega:GetEngRpm('(A:GENERAL ENG RPM:1, rpm)', 1)

GlobalFrameLoopManager:add(function()
	cfmega:PollAnalogs()
	cfmega:SetEngRpm()
end)
