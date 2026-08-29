-- *****************************************************************
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-08-08_03_55_08UTC
-- *****************************************************************
if ilua_require_inibuild_a350() then return end

-- Do not remove below lines: hardware detection
local wwpdc3n = com.sim.qm.Wwpdc3n.Open()
if not wwpdc3n then return end
-- Do not remove above lines: hardware detection

uluaLog('Wwpdc3n for iniBuilds A350')
--[[
wwpdc3n:GetBkl('')
]] --

-- WXR R
wwpdc3n:CfgRpn(2, '1 (>L:INI_EFIS_BSK_2_FO)')
-- VOR 1 L/R ON
wwpdc3n:CfgRpn(9, '1 (>L:INI_CPT_VOR1_ACTIVE) 1 (>L:INI_FO_VOR1_ACTIVE)')
-- ADF 1 L/R OFF & VOR 1 L/R OFF
wwpdc3n:CfgRpn(10,
    '0 (>L:INI_CPT_ADF1_ACTIVE) 0 (>L:INI_FO_ADF1_ACTIVE) 0 (>L:INI_CPT_VOR1_ACTIVE) 0 (>L:INI_FO_VOR1_ACTIVE)')
-- ADF 1 L/R ON
wwpdc3n:CfgRpn(11, '1 (>L:INI_CPT_ADF1_ACTIVE) 1 (>L:INI_FO_ADF1_ACTIVE)')
-- VOR 2 L/R ON
wwpdc3n:CfgRpn(12, '1 (>L:INI_CPT_VOR2_ACTIVE) 1 (>L:INI_FO_VOR2_ACTIVE)')
-- ADF 2 L/R OFF & VOR 2 L/R OFF
wwpdc3n:CfgRpn(13,
'0 (>L:INI_CPT_ADF2_ACTIVE) 0 (>L:INI_FO_ADF2_ACTIVE) 0 (>L:INI_CPT_VOR2_ACTIVE) 0 (>L:INI_FO_VOR2_ACTIVE)')
-- ADF 2 L/R ON
wwpdc3n:CfgRpn(14, '1 (>L:INI_CPT_ADF2_ACTIVE) 1 (>L:INI_FO_ADF2_ACTIVE)')
-- TRAF L/R
wwpdc3n:CfgRpn(17, '1 (>L:INI_EFIS_BSK_4_CPT) 1 (>L:INI_EFIS_BSK_4_FO)')
-- RANGE ZOOM
wwpdc3n:CfgRpn(31, '(L:INI_MAP_RANGE_CAPT_SWITCH) -- 0 max 11 min (>L:INI_MAP_RANGE_CAPT_SWITCH)')
-- RANGE 10
wwpdc3n:CfgRpn(32, '(L:INI_MAP_RANGE_CAPT_SWITCH) ++ 0 max 11 min (>L:INI_MAP_RANGE_CAPT_SWITCH)')

GlobalFrameLoopManager:add(function()
end)
