-- *****************************************************************
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-10-18_12_37_56UTC
-- *****************************************************************
-- Wwecam for Fenix A320
-- ported from msfs/QMPE_Fnx.lua (ECAM part only)
-- WWECAM key map (keep in sync with xp/WWECAM_Toliss.lua):
--  1:TO CONFIG  3:EMER CANCEL(TODO)  4:ENG    5:BLEED  6:PRESS  7:ELEC
--  8:HYD        9:FUEL        10:APU   11:COND  12:DOOR  13:WHEEL
-- 14:FCTL      15:ALL         16:CLR(L) 18:STS  19:RCL   21:CLR(R)

if ilua_require_fenix_a320() then return end

-- Do not remove below lines: hardware detection
local wwecam = com.sim.qm.Wwecam.Open()
if not wwecam then return end
-- Do not remove above lines: hardware detection

uluaLog("Wwecam for Fenix A320")

--------------------Input Keys Binding ---------------------

-- TO CONFIG
wwecam:CfgRpn(1, "1 (>L:S_ECAM_TO)", "0 (>L:S_ECAM_TO)")

-- EMER CANCEL
-- TODO: QMPE_Fnx 没有 EMER CANCEL 绑定（Fenix 的 ECP 也没有单独事件），先留空

-- ENG
wwecam:CfgRpn(4, "1 (>L:S_ECAM_ENGINE)", "0 (>L:S_ECAM_ENGINE)")
-- BLEED
wwecam:CfgRpn(5, "1 (>L:S_ECAM_BLEED)", "0 (>L:S_ECAM_BLEED)")
-- PRESS
wwecam:CfgRpn(6, "1 (>L:S_ECAM_CAB_PRESS)", "0 (>L:S_ECAM_CAB_PRESS)")

-- ELEC (Fenix 只有一个 ELEC 键，没有 AC/DC 分开)
wwecam:CfgRpn(7, "1 (>L:S_ECAM_ELEC)", "0 (>L:S_ECAM_ELEC)")
-- HYD
wwecam:CfgRpn(8, "1 (>L:S_ECAM_HYD)", "0 (>L:S_ECAM_HYD)")
-- FUEL
wwecam:CfgRpn(9, "1 (>L:S_ECAM_FUEL)", "0 (>L:S_ECAM_FUEL)")

-- APU
wwecam:CfgRpn(10, "1 (>L:S_ECAM_APU)", "0 (>L:S_ECAM_APU)")
-- COND
wwecam:CfgRpn(11, "1 (>L:S_ECAM_COND)", "0 (>L:S_ECAM_COND)")
-- DOOR
wwecam:CfgRpn(12, "1 (>L:S_ECAM_DOOR)", "0 (>L:S_ECAM_DOOR)")
-- WHEEL
wwecam:CfgRpn(13, "1 (>L:S_ECAM_WHEEL)", "0 (>L:S_ECAM_WHEEL)")
-- FCTL
wwecam:CfgRpn(14, "1 (>L:S_ECAM_FCTL)", "0 (>L:S_ECAM_FCTL)")

-- ALL
wwecam:CfgRpn(15, "1 (>L:S_ECAM_ALL)", "0 (>L:S_ECAM_ALL)")

-- CLR left / CLR right: QMPE has a single CLR button, key 21 copies key 16
wwecam:CfgRpn(16, "1 (>L:S_ECAM_CLR_LEFT)", "0 (>L:S_ECAM_CLR_LEFT)")
wwecam:CfgRpn(21, "1 (>L:S_ECAM_CLR_LEFT)", "0 (>L:S_ECAM_CLR_LEFT)")

-- STS
wwecam:CfgRpn(18, "1 (>L:S_ECAM_STATUS)", "0 (>L:S_ECAM_STATUS)")
-- RCL
wwecam:CfgRpn(19, "1 (>L:S_ECAM_RCL)", "0 (>L:S_ECAM_RCL)")

--------------------Output lights ---------------------
-- =====ECAM
wwecam:GetEEng("(L:I_ECAM_ENGINE)")
wwecam:GetEBleed("(L:I_ECAM_BLEED)")
wwecam:GetEPress("(L:I_ECAM_CAB_PRESS)")
wwecam:GetEElec("(L:I_ECAM_ELEC)")
wwecam:GetEHyd("(L:I_ECAM_HYD)")
wwecam:GetEFuel("(L:I_ECAM_FUEL)")

wwecam:GetEApu("(L:I_ECAM_APU)")
wwecam:GetECond("(L:I_ECAM_COND)")
wwecam:GetEDoor("(L:I_ECAM_DOOR)")
wwecam:GetEWheel("(L:I_ECAM_WHEEL)")
wwecam:GetEFctl("(L:I_ECAM_FCTL)")

wwecam:GetEClrL("(L:I_ECAM_CLR_LEFT)")
wwecam:GetEClrR("(L:I_ECAM_CLR_LEFT)")
wwecam:GetESts("(L:I_ECAM_STATUS)")

-- QMPE 的 scale 原样借用；Wwecam 亮度字节是 0~255，实机偏亮/偏暗就调这个数
wwecam:GetBkl("(L:N_PED_LIGHTING_PEDESTAL)", 30)

-- =====Annunciator test
-- PowerOff()/SetTest() 只改硬件，Lua 侧的灯值没变就不会重写；
-- 这两处把 14 个灯的缓存作废，下一帧 SetEcam() 会整块重刷
local function fresh_ecam()
    wwecam.d_ec_eng:Invalid(-1)
    wwecam.d_ec_bleed:Invalid(-1)
    wwecam.d_ec_press:Invalid(-1)
    wwecam.d_ec_elec:Invalid(-1)
    wwecam.d_ec_hyd:Invalid(-1)
    wwecam.d_ec_fuel:Invalid(-1)
    wwecam.d_ec_apu:Invalid(-1)
    wwecam.d_ec_cond:Invalid(-1)
    wwecam.d_ec_door:Invalid(-1)
    wwecam.d_ec_wheel:Invalid(-1)
    wwecam.d_ec_fctl:Invalid(-1)
    wwecam.d_ec_clr_l:Invalid(-1)
    wwecam.d_ec_clr_r:Invalid(-1)
    wwecam.d_ec_sts:Invalid(-1)
end

local dr_power = iDataRef:New("(L:B_ELEC_BUS_POWER_DC_BAT, Bool)") -- 0: OFF 1: ON
local dr_test = iDataRef:New("(L:S_OH_IN_LT_ANN_LT)") -- 0: DIM 1: BRT 2: TEST
local TEST_MODE = 2

GlobalFrameLoopManager:add(function()
    -- expert code: cold and dark
    if dr_power:ChangedUpdate() then
        if dr_power:Get() == 0 then
            wwecam:PowerOff()
            return
        else
            wwecam:FreshBkl()
            fresh_ecam()
        end
    end

    -- expert code: test mode
    if dr_test:ChangedUpdate() then
        if dr_test:Get() == TEST_MODE then
            wwecam:SetTest()
            return
        end
        fresh_ecam()
    end

    -- brightness
    wwecam:SetBkl()
    wwecam:SetEcam()
end)
