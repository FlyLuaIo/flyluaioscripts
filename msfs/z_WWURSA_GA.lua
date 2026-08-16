-- *****************************************************************
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-08-08_03_55_08UTC
-- *****************************************************************
if ilua_require_msfs() then
    return
end
-- Do not remove below lines: hardware detection
local wwursa = com.sim.qm.Wwursa.Open()
if not wwursa then return end
-- Do not remove above lines: hardware detection

uluaLog('Wwursa for GA')

--====vibration
wwursa:GetVibL('(A:SIM ON GROUND,Bool) (A:GPS GROUND SPEED,Meters per second) * 10 *')
wwursa:GetVibR('(A:SIM ON GROUND,Bool) (A:GPS GROUND SPEED,Meters per second) * 10 *')

--====rudder trim LCD
-- setLcdText caches text internally; USB write only when text changes
local dr_trim = iDataRef:New('(A:RUDDER TRIM PCT,Percent)')

function Wwursa_GA_LCD_Loop()
    wwursa:setLcdText(wwursa:formatTrimText(dr_trim:Get(), false))
end

--====backlight
-- generic MSFS instrument dimming; SetBkl() is ChangedUpdate throttled
wwursa:GetBkl('(A:LIGHT POTENTIOMETER:3, Percent)', 255)
-- GetOverallBkl drives Throttle ch2 (overall brightness master gate) which
-- mirrors to PAC ch2 (LCD brightness); binary on/off per dimming > 0
wwursa:GetOverallBkl('(A:LIGHT POTENTIOMETER:3, Percent)', 255)




GlobalFrameLoopManager:add(function()
    wwursa:SetBkl()
    wwursa:SetOverallBkl()
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
    wwursa:SetVibL()
    wwursa:SetVibR()
    Wwursa_GA_LCD_Loop()
end)
