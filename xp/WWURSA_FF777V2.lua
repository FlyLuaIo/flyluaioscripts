-- *****************************************************************
-- WwUrsa for FF777 V2
-- *****************************************************************

if ilua_require_ff777(true) then return end

-- Do not remove below lines: hardware detection
local wwursa = com.sim.qm.Wwursa.Open()
if not wwursa then return end
-- Do not remove above lines: hardware detection

uluaLog('Wwursa for FF777 V2')

_G.wwursa_ff777_flap_last = _G.wwursa_ff777_flap_last or {}
function wwursa_ff777_flap(cmd, token)
	if _G.wwursa_ff777_flap_last[cmd] == token then return end
	_G.wwursa_ff777_flap_last[cmd] = token
	local c = uluaFind(cmd)
	if c then uluaCmdOnce(c) end
end

-------------------- Input Keys Binding ---------------------
-- Cutoff levers (Buttons 1..4 -> bits 0..3)
local pswh_cutoffL = QmdevPosSwitchInit("1-sim/ckpt/cutoffLeftLever/anim", 1,
	"1-sim/command/cutoffLeftLever_trigger", "1-sim/command/cutoffLeftLever_trigger", 300)
wwursa:CfgPSw(0, pswh_cutoffL, 1) -- ON
wwursa:CfgPSw(1, pswh_cutoffL, 0) -- OFF

local pswh_cutoffR = QmdevPosSwitchInit("1-sim/ckpt/cutoffRightLever/anim", 1,
	"1-sim/command/cutoffRightLever_trigger", "1-sim/command/cutoffRightLever_trigger", 300)
wwursa:CfgPSw(2, pswh_cutoffR, 1) -- ON
wwursa:CfgPSw(3, pswh_cutoffR, 0) -- OFF

wwursa:CfgCmd(6, '1-sim/command/eecStartLeftSwitch_set_0')
wwursa:CfgCmd(7, '1-sim/command/eecStartLeftSwitch_set_1')
wwursa:CfgCmd(8, '1-sim/command/eecStartLeftSwitch_set_2')
wwursa:CfgCmd(9, '1-sim/command/apDiscLeftButton_button')
wwursa:CfgCmd(10, '1-sim/command/apDiscRightButton_button')

wwursa:CfgCmd(24, '1-sim/command/rudderTrimCancleButton_button')
wwursa:CfgCmd(25, '1-sim/command/rudderTrimRotary_rotary-')
wwursa:CfgCmd(27, '1-sim/command/rudderTrimRotary_rotary+')

-- Park brake (Buttons 29..30 -> bits 28..29)
local pswh_parkbrake = QmdevPosSwitchInit("sim/flightmodel/controls/parkbrake", 1,
	"1-sim/command/parkbrake_trigger", "1-sim/command/parkbrake_trigger", 2000)
wwursa:CfgPSw(28, pswh_parkbrake, 0) -- OFF
wwursa:CfgPSw(29, pswh_parkbrake, 1) -- ON

wwursa:CfgFc(30, 'wwursa_ff777_flap("1-sim/command/flapLever_set_6",5)')
wwursa:CfgFc(31, 'wwursa_ff777_flap("1-sim/command/flapLever_set_5",4)')
wwursa:CfgFc(32, 'wwursa_ff777_flap("1-sim/command/flapLever_set_4",3)')
wwursa:CfgFc(33, 'wwursa_ff777_flap("1-sim/command/flapLever_set_2",2)')
wwursa:CfgFc(34, 'wwursa_ff777_flap("1-sim/command/flapLever_set_0",1)')

-------------------- Output ---------------------
local dr_bkl = iDataRef:New('1-sim/ckpt/lights/aisle')
local dr_power = iDataRef:New('1-sim/output/mcp/ok')
local dr_trim = iDataRef:New('sim/flightmodel2/wing/rudder1_deg[11]')
local dr_fault1 = iDataRef:New('1-sim/ckpt/lampsGlow/cutoffLeftLGT')
local dr_fault2 = iDataRef:New('1-sim/ckpt/lampsGlow/cutoffRightLGT')
local dr_fire1 = iDataRef:New('1-sim/ckpt/lampsGlow/engLeftFireDISCH')
local dr_fire2 = iDataRef:New('1-sim/ckpt/lampsGlow/engRightFireDISCH')

GlobalFrameLoopManager:add(function()
	local hasPower = dr_power:Get() ~= 0
	local bkl = hasPower and math.floor(math.max(0, math.min(1, dr_bkl:Get())) * 255) or 0
	wwursa:SendLedCmd(wwursa.LEDS_BKL, bkl)
	wwursa:SendLedCmd(wwursa.LEDS_OVERALLBKL, hasPower and 255 or 0)

	wwursa:SendLedCmd(wwursa.LEDS_FAULT1, dr_fault1:Get() ~= 0 and 1 or 0)
	wwursa:SendLedCmd(wwursa.LEDS_FAULT2, dr_fault2:Get() ~= 0 and 1 or 0)
	wwursa:SendLedCmd(wwursa.LEDS_FIRE1, dr_fire1:Get() ~= 0 and 1 or 0)
	wwursa:SendLedCmd(wwursa.LEDS_FIRE2, dr_fire2:Get() ~= 0 and 1 or 0)

	wwursa:setLcdText(wwursa:formatTrimText(dr_trim:Get(), false))
end)
