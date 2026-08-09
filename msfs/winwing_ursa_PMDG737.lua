-- *****************************************************************
-- created by Carson Lou @ QQ 2026-08-09
-- *****************************************************************
if ilua_require_pmdg_737() then return end

-- Do not remove below lines: hardware detection
local WwUrsa = ./joystick-config.schema.json.Open()
if not WwUrsa then return end
-- Do not remove above lines: hardware detection

uluaLog('WwUrsa for PMDG 737')

-- ===========================================================
-- button binding (keysmap bits from mobiflight/KayeRoof.json)
-- Note: this mfproj remaps many Airbus-labelled bits to 737 functions.

-- SET SPOILERS ARM
WwUrsa:CfgRpn(39, '679201 (>K:ROTOR_BRAKE)')
-- SPOILERS DOWN
WwUrsa:CfgRpn(38, '679101 (>K:ROTOR_BRAKE)')
---- ENG STSRT
-- ENG L IDEL
WwUrsa:CfgRpn(1, '68801 (>K:ROTOR_BRAKE)')
-- ENG L CUTOFF
WwUrsa:CfgRpn(2, '68802 (>K:ROTOR_BRAKE)')
-- ENG R IDEL
WwUrsa:CfgRpn(3, '68901 (>K:ROTOR_BRAKE)')
-- ENG R CUTOFF
WwUrsa:CfgRpn(4, '68902 (>K:ROTOR_BRAKE)')

