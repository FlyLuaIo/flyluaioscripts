
-- *****************************************************************
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-08-08_03_55_08UTC
-- *****************************************************************

-- Do not remove below lines: hardware detection
local wwursa = com.sim.qm.Wwursa.Open()
if not wwursa then return end
-- Do not remove above lines: hardware detection

uluaLog('Wwursa for GA')

--====vibration
-- ground-roll micro-vibration: intensity = groundspeed, gated by on-ground,
-- explicit SendLedCmd with local throttling (no per-frame USB HID traffic)
local dr_onground = iDataRef:New('sim/flightmodel/failures/onground_any')
local dr_gs = iDataRef:New('sim/flightmodel/position/groundspeed')
local vib_last = 0

function Wwursa_GA_Vib_Loop()
	local vib = 0
	if dr_onground:Get() ~= 0 then
		vib = math.floor(dr_gs:Get())
		if vib > 255 then vib = 255 end
	end
	if vib ~= vib_last then
		vib_last = vib
		wwursa:SendLedCmd(wwursa.LEDS_VIBL, vib)
		wwursa:SendLedCmd(wwursa.LEDS_VIBR, vib)
	end
end

--====rudder trim LCD
-- setLcdText caches text internally; USB write only when text changes
local dr_trim = iDataRef:New('sim/cockpit2/controls/rudder_trim')

function Wwursa_GA_LCD_Loop()
	wwursa:setLcdText(wwursa:formatTrimText(dr_trim:Get(), false))
end

--[[
wwursa:GetBkl('')
wwursa:GetOverallBkl('')
wwursa:GetFault1('')
wwursa:GetFire1('')
wwursa:GetFault2('')
wwursa:GetFire2('')
wwursa:GetVibL('')
wwursa:GetVibR('')
wwursa:GetBkl('')
wwursa:GetLcdBkl('')
]]--


GlobalFrameLoopManager:add(function()
	Wwursa_GA_Vib_Loop()
	Wwursa_GA_LCD_Loop()
end)
