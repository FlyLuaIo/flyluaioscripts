-- *****************************************************************
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-03-26_10_40_00UTC
-- *****************************************************************

-- Do not remove below lines: hardware detection
local stkswitch = com.sim.qm.Stkswitch:new()
if not stkswitch:Init() then
	return
end
-- Do not remove above lines: hardware detection

uluaLog("Stkswitch for GA")


-- Magneto OFF
stkswitch:CfgCmd(13, 'sim/magnetos/magnetos_off')
-- Magneto R
stkswitch:CfgCmd(13, 'sim/magnetos/magnetos_right_1')
-- Magneto L
stkswitch:CfgCmd(13, 'sim/magnetos/magnetos_left_1')
-- Magneto BOTH
stkswitch:CfgCmd(13, 'sim/magnetos/magnetos_both')
-- Magneto START
stkswitch:CfgCmd(13, 'sim/ignition/engage_starter_1')

-- gear up, this config will not hard bind landing gear handler, you still press keyboard G to play with gear
stkswitch:CfgCmd(18, 'sim/flight_controls/landing_gear_up', 'sim/flight_controls/landing_gear_down')

stkswitch:GetGreenn('sim/flightmodel2/gear/deploy_ratio[0]')
stkswitch:GetGreenl('sim/flightmodel2/gear/deploy_ratio[1]')
stkswitch:GetGreenr('sim/flightmodel2/gear/deploy_ratio[2]')
stkswitch:GetRedn('sim/flightmodel2/gear/eagle_claw_angle_deg[0]')
stkswitch:GetRedl('sim/flightmodel2/gear/eagle_claw_angle_deg[1]')
stkswitch:GetRedr('sim/flightmodel2/gear/eagle_claw_angle_deg[2]')


function Stkswitch_GA_Loop_Upd()
	stkswitch:SetLed()
end

uluaAddDoLoop("Stkswitch_GA_Loop_Upd()")
