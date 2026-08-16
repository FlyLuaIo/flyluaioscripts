-- *****************************************************************
-- created by Carson Lou @ QQ 2026-08-09
-- *****************************************************************
if ilua_require_pmdg_737() then return end

-- Do not remove below lines: hardware detection
local wwursa = com.sim.qm.Wwursa.Open()
if not wwursa then return end
-- Do not remove above lines: hardware detection

uluaLog('URSA Throttle L for PMDG 737')

-- ===========================================================
-- button binding

-- SET SPOILERS ARM
wwursa:CfgRpn(38, '(L:switch_679_73X) 0 == if{ 679201 (>K:ROTOR_BRAKE) }')
-- SPOILERS DOWN
wwursa:CfgRpn(37, '679101 (>K:ROTOR_BRAKE)')
---- ENG STSRT
-- ENG L IDEL
wwursa:CfgRpn(0, '(L:switch_688_73X) 100 == if{ 68801 (>K:ROTOR_BRAKE) }')
-- ENG L CUTOFF
wwursa:CfgRpn(1, '(L:switch_688_73X) 0 == if{ 68801 (>K:ROTOR_BRAKE) }')
-- ENG R IDEL
wwursa:CfgRpn(2, '(L:switch_689_73X) 100 == if{ 68901 (>K:ROTOR_BRAKE) }')
-- ENG R CUTOFF
wwursa:CfgRpn(3, '(L:switch_689_73X) 0 == if{ 68901 (>K:ROTOR_BRAKE) }')

-- ====vibration
wwursa:GetVibL('(A:SIM ON GROUND,Bool) (A:GPS GROUND SPEED,Meters per second) * 10 *')
wwursa:GetVibR('(A:SIM ON GROUND,Bool) (A:GPS GROUND SPEED,Meters per second) * 10 *')

-- ====rudder trim LCD
-- setLcdText caches text internally; USB write only when text changes
local dr_trim = iDataRef:New('(A:RUDDER TRIM PCT,Percent)')

function Wwursa_PMDG737_LCD_Loop()
    wwursa:setLcdText(wwursa:formatTrimText(dr_trim:Get(), false))
end

-- ====backlight
-- generic MSFS instrument dimming; SetBkl() is ChangedUpdate throttled
wwursa:GetBkl('(A:LIGHT POTENTIOMETER:3, Percent)', 255)
-- GetOverallBkl drives Throttle ch2 (overall brightness master gate) which
-- mirrors to PAC ch2 (LCD brightness); binary on/off per dimming > 0
wwursa:GetOverallBkl('(A:LIGHT POTENTIOMETER:3, Percent)', 255)

GlobalFrameLoopManager:add(function()
    wwursa:SetBkl()
    wwursa:SetOverallBkl()
    wwursa:SetVibL()
    wwursa:SetVibR()
    Wwursa_PMDG737_LCD_Loop()
end)
