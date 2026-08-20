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

wwursa:CfgRpn(25, '81101 (>K:ROTOR_BRAKE)', '81104 (>K:ROTOR_BRAKE)')
wwursa:CfgRpn(27, '81102 (>K:ROTOR_BRAKE)', '81104 (>K:ROTOR_BRAKE)')

--parking brake
wwursa:CfgRpn(28, '69301 (>K:ROTOR_BRAKE)', '69302 (>K:ROTOR_BRAKE)')
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


local pswheng1 = QmdevPosSwitchInit("(L:switch_119_73X, number)", 10, "11902 (>K:ROTOR_BRAKE)",
	"11901 (>K:ROTOR_BRAKE)",
	500)
local pswheng2 = QmdevPosSwitchInit("(L:switch_121_73X, number)", 10, "12102 (>K:ROTOR_BRAKE)",
	"12101 (>K:ROTOR_BRAKE)",
	500)

function eng_starter_select(idx)
	if idx == 0 then
		--uluaCmdOnce(dr_cmd_ign1)
		wwursa:CfgPSw(6, pswheng1, 0)
		wwursa:CfgPSw(7, pswheng1, 10)
		wwursa:CfgPSw(8, pswheng1, 20)
	else
		--uluaCmdOnce(dr_cmd_ign2)
		wwursa:CfgPSw(6, pswheng2, 0)
		wwursa:CfgPSw(7, pswheng2, 10)
		wwursa:CfgPSw(8, pswheng2, 20)
	end
end

eng_starter_select(0)
wwursa:CfgFc(4, 'eng_starter_select(0)')
wwursa:CfgFc(5, 'eng_starter_select(1)')
-- ====rudder trim LCD
-- setLcdText caches text internally; USB write only when text changes
local dr_trim = iDataRef:New('(L:RudderTrimTT,Percent)')

function Wwursa_PMDG737_LCD_Loop()
	wwursa:setLcdText(wwursa:formatTrimText(dr_trim:Get() * 0.6, false))
end

-- ====backlight
-- panel brightness ratio scaled to 0-255, gated by avionics power;
-- local cache: USB write only when computed value changes
local dr_power = iDataRef:New('pmdg/ng3/data/MCP_indication_powered')
local dr_panel = iDataRef:New('(L:BL_Pedestal)')
local ch_bkl = iChange:New(-1)

function Wwursa_PMDG737_Bkl_Loop()
	local hasPower = dr_power:Get() ~= 0
	local ratio = dr_panel:Get()
	local bkl = hasPower and math.floor(ratio * 255) or 0
	if ch_bkl:ChangedUpdate(bkl) then
		wwursa:SendLedCmd(wwursa.LEDS_BKL, bkl)
		wwursa:SendLedCmd(wwursa.LEDS_OVERALLBKL, hasPower and 255 or 0)
	end
end

-- ====fault/fire LEDs
-- annunciator binaries, edge-detected (no per-frame USB HID traffic)
local dr_fire1 = iDataRef:New('(A:ENG FIRE:1,Bool)')
local dr_fire2 = iDataRef:New('(A:ENG FIRE:2,Bool)')
local ch_fault1 = iChange:New(-1)
local ch_fire1 = iChange:New(-1)
local ch_fault2 = iChange:New(-1)
local ch_fire2 = iChange:New(-1)

function Wwursa_PMDG737_Led_Loop()
	local fault1, fault2 = 0, 0
	local fire1 = dr_fire1:Get() ~= 0 and 1 or 0
	local fire2 = dr_fire2:Get() ~= 0 and 1 or 0
	if ch_fault1:ChangedUpdate(fault1) then
		wwursa:SendLedCmd(wwursa.LEDS_FAULT1, fault1)
	end
	if ch_fire1:ChangedUpdate(fire1) then
		wwursa:SendLedCmd(wwursa.LEDS_FIRE1, fire1)
	end
	if ch_fault2:ChangedUpdate(fault2) then
		wwursa:SendLedCmd(wwursa.LEDS_FAULT2, fault2)
	end
	if ch_fire2:ChangedUpdate(fire2) then
		wwursa:SendLedCmd(wwursa.LEDS_FIRE2, fire2)
	end
end

-- ====vibration
-- ground-roll micro-vibration: intensity = groundspeed, gated by on-ground,
-- explicit SendLedCmd with local throttling (no per-frame USB HID traffic)
local dr_onground = iDataRef:New('(A:SIM ON GROUND,Bool)')
local dr_gs = iDataRef:New('(A:GPS GROUND SPEED,Meters per second)')
local ch_vib_l = iChange:New(0)
local ch_vib_r = iChange:New(0)

function Wwursa_PMDG737_Vib_Loop()
	local vib_l, vib_r = 0, 0
	if dr_onground:Get() ~= 0 then
		local gs = dr_gs:Get()
		vib_l = math.floor(gs)
		vib_r = math.floor(gs)
		if vib_l > 255 then vib_l = 255 end
		if vib_r > 255 then vib_r = 255 end
	end
	if ch_vib_l:ChangedUpdate(vib_l) then
		wwursa:SendLedCmd(wwursa.LEDS_VIBL, vib_l)
	end
	if ch_vib_r:ChangedUpdate(vib_r) then
		wwursa:SendLedCmd(wwursa.LEDS_VIBR, vib_r)
	end
end

GlobalFrameLoopManager:add(function()
	Wwursa_PMDG737_Bkl_Loop()
	Wwursa_PMDG737_Led_Loop()
	Wwursa_PMDG737_Vib_Loop()
	-- setLcdText caches text internally; USB write only when text changes
	Wwursa_PMDG737_LCD_Loop()
end)
