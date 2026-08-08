-- *****************************************************************
-- WwUrsa for FF777 V2 (ported from WINCTRL ff777-ursa-minor-throttle-profile)
-- *****************************************************************

if ilua_require_ff777(true) then return end

-- Do not remove below lines: hardware detection
local wwursa = com.sim.qm.Wwursa.Open()
if not wwursa then return end
-- Do not remove above lines: hardware detection

uluaLog('Wwursa for FF777 V2')

function wwursa_ff777_seek(posRef, dnCmd, upCmd, target)
	local dr = uluaFind(posRef)
	if not dr then return end
	local cur = uluaGet(dr)
	local cmdDn = uluaFind(dnCmd)
	local cmdUp = uluaFind(upCmd)
	if cur < target then
		for _ = cur, target - 1 do uluaCmdOnce(cmdUp) end
	elseif cur > target then
		for _ = target, cur - 1 do uluaCmdOnce(cmdDn) end
	end
end

_G.wwursa_ff777_flap_last = _G.wwursa_ff777_flap_last or {}
function wwursa_ff777_flap(cmd, token)
	if _G.wwursa_ff777_flap_last[cmd] == token then return end
	_G.wwursa_ff777_flap_last[cmd] = token
	local c = uluaFind(cmd)
	if c then uluaCmdOnce(c) end
end

-------------------- Input Keys Binding ---------------------
wwursa:CfgFc(0, 'wwursa_ff777_seek("1-sim/ckpt/cutoffLeftLever/anim","1-sim/command/cutoffLeftLever_trigger","1-sim/command/cutoffLeftLever_trigger",1)')
wwursa:CfgFc(1, 'wwursa_ff777_seek("1-sim/ckpt/cutoffLeftLever/anim","1-sim/command/cutoffLeftLever_trigger","1-sim/command/cutoffLeftLever_trigger",0)')
wwursa:CfgFc(2, 'wwursa_ff777_seek("1-sim/ckpt/cutoffRightLever/anim","1-sim/command/cutoffRightLever_trigger","1-sim/command/cutoffRightLever_trigger",1)')
wwursa:CfgFc(3, 'wwursa_ff777_seek("1-sim/ckpt/cutoffRightLever/anim","1-sim/command/cutoffRightLever_trigger","1-sim/command/cutoffRightLever_trigger",0)')

wwursa:CfgCmd(6, '1-sim/command/eecStartLeftSwitch_set_0')
wwursa:CfgCmd(7, '1-sim/command/eecStartLeftSwitch_set_1')
wwursa:CfgCmd(8, '1-sim/command/eecStartLeftSwitch_set_2')
wwursa:CfgCmd(9, '1-sim/command/apDiscLeftButton_button')
wwursa:CfgCmd(10, '1-sim/command/apDiscRightButton_button')

wwursa:CfgCmd(24, '1-sim/command/rudderTrimCancleButton_button')
wwursa:CfgCmd(25, '1-sim/command/rudderTrimRotary_rotary-')
wwursa:CfgCmd(27, '1-sim/command/rudderTrimRotary_rotary+')

wwursa:CfgFc(28, 'wwursa_ff777_seek("sim/flightmodel/controls/parkbrake","1-sim/command/parkbrake_trigger","1-sim/command/parkbrake_trigger",0)')
wwursa:CfgFc(29, 'wwursa_ff777_seek("sim/flightmodel/controls/parkbrake","1-sim/command/parkbrake_trigger","1-sim/command/parkbrake_trigger",1)')

wwursa:CfgFc(30, 'wwursa_ff777_flap("1-sim/command/flapLever_set_6",5)')
wwursa:CfgFc(31, 'wwursa_ff777_flap("1-sim/command/flapLever_set_5",4)')
wwursa:CfgFc(32, 'wwursa_ff777_flap("1-sim/command/flapLever_set_4",3)')
wwursa:CfgFc(33, 'wwursa_ff777_flap("1-sim/command/flapLever_set_2",2)')
wwursa:CfgFc(34, 'wwursa_ff777_flap("1-sim/command/flapLever_set_0",1)')

-------------------- Output ---------------------
local dr_bkl = iDataRef:New('1-sim/ckpt/lights/aisle')
local dr_power = iDataRef:New('1-sim/output/mcp/ok')
local dr_trim = iDataRef:New('sim/flightmodel/controls/vstab2_rud1def')
local dr_fault1 = iDataRef:New('1-sim/ckpt/lampsGlow/cutoffLeftLGT')
local dr_fault2 = iDataRef:New('1-sim/ckpt/lampsGlow/cutoffRightLGT')
local dr_fire1 = iDataRef:New('1-sim/ckpt/lampsGlow/engLeftFireDISCH')
local dr_fire2 = iDataRef:New('1-sim/ckpt/lampsGlow/engRightFireDISCH')

GlobalFrameLoopManager:add(function()
	local hasPower = dr_power:Get() ~= 0
	local bkl = hasPower and math.floor(math.max(0, math.min(1, dr_bkl:Get())) * 255) or 0
	wwursa:SendLedCmd(wwursa.LEDS_BKL, bkl)
	wwursa:SendLedCmd(wwursa.LEDS_MAKER, hasPower and 255 or 0)

	wwursa:SendLedCmd(wwursa.LEDS_FAULT1, dr_fault1:Get() ~= 0 and 1 or 0)
	wwursa:SendLedCmd(wwursa.LEDS_FAULT2, dr_fault2:Get() ~= 0 and 1 or 0)
	wwursa:SendLedCmd(wwursa.LEDS_FIRE1, dr_fire1:Get() ~= 0 and 1 or 0)
	wwursa:SendLedCmd(wwursa.LEDS_FIRE2, dr_fire2:Get() ~= 0 and 1 or 0)

	wwursa:setLcdText(wwursa:formatTrimText(dr_trim:Get(), false))
end)
