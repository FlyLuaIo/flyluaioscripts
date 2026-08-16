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
local dr_l_tire = iDataRef:New('sim/flightmodel2/gear/tire_vertical_deflection_mtr[1]')
local dr_r_tire = iDataRef:New('sim/flightmodel2/gear/tire_vertical_deflection_mtr[2]')
local vib_l_last = 0
local vib_r_last = 0

function Wwursa_GA_Vib_Loop()
	local vib_l, vib_r = 0, 0
	if dr_onground:Get() ~= 0 then
		local gs = dr_gs:Get() * 10
		vib_l = math.floor(gs * dr_l_tire:Get())
		vib_r = math.floor(gs * dr_r_tire:Get())
		if vib_l > 255 then vib_l = 255 end
		if vib_r > 255 then vib_r = 255 end
	end
	if vib_l ~= vib_l_last then
		vib_l_last = vib_l
		wwursa:SendLedCmd(wwursa.LEDS_VIBL, vib_l)
	end
	if vib_r ~= vib_r_last then
		vib_r_last = vib_r
		wwursa:SendLedCmd(wwursa.LEDS_VIBR, vib_r)
	end
end

--====rudder trim LCD
-- setLcdText caches text internally; USB write only when text changes
local dr_trim = iDataRef:New('sim/cockpit2/controls/rudder_trim')

function Wwursa_GA_LCD_Loop()
	wwursa:setLcdText(wwursa:formatTrimText(dr_trim:Get(), false))
end

--====backlight
-- generic XP instrument dimming; SetBkl() is ChangedUpdate throttled
wwursa:GetBkl('sim/cockpit2/electrical/instrument_brightness_ratio[0]', 255)
-- GetOverallBkl drives Throttle ch2 (overall brightness master gate) which
-- mirrors to PAC ch2 (LCD brightness); binary on/off per dimming > 0
wwursa:GetOverallBkl('sim/cockpit2/electrical/instrument_brightness_ratio[0]', 255)

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
]] --


GlobalFrameLoopManager:add(function()
	wwursa:SetBkl()
	wwursa:SetOverallBkl()
	Wwursa_GA_Vib_Loop()
	Wwursa_GA_LCD_Loop()
end)
