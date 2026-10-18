-- *****************************************************************
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-10-18_12_37_56UTC
-- *****************************************************************
-- Wwecam for Aerosoft A340-600
-- ported from msfs/data/QMPE_AERO_A346.lua (ECAM part only)
-- WWECAM key map (keep in sync with xp/WWECAM_Toliss.lua):
--  1:TO CONFIG  3:EMER CANCEL(TODO)  4:ENG    5:BLEED  6:PRESS  7:ELEC
--  8:HYD        9:FUEL        10:APU   11:COND  12:DOOR  13:WHEEL
-- 14:FCTL      15:ALL         16:CLR(L) 18:STS  19:RCL   21:CLR(R)

if ilua_require_aerosoft_a346() then return end

-- Do not remove below lines: hardware detection
local wwecam = com.sim.qm.Wwecam.Open()
if not wwecam then return end
-- Do not remove above lines: hardware detection

uluaLog("Wwecam for Aerosoft A346")

--------------------Input Keys Binding ---------------------

-- TO CONFIG
wwecam:CfgRpn(1, "1 (>L:AB_ECAM_TOconf)", "0 (>L:AB_ECAM_TOconf)")

-- EMER CANCEL
-- TODO: QMPE_AERO_A346 没有 EMER CANCEL 绑定；HubHop 的 Aerosoft/A340-600 没有 ECAM 区，查不到，先留空

-- ENG
wwecam:CfgRpn(4, "1 (>L:AB_ECAM_ENG)", "0 (>L:AB_ECAM_ENG)")
-- BLEED
wwecam:CfgRpn(5, "1 (>L:AB_ECAM_BLEED)", "0 (>L:AB_ECAM_BLEED)")
-- PRESS
wwecam:CfgRpn(6, "1 (>L:AB_ECAM_PRESS)", "0 (>L:AB_ECAM_PRESS)")

-- ELEC: A340 has separate AC/DC buttons, one key toggles them
-- 0:ELEC AC  1:ELEC DC
local iniA330_ecam_elec_acdc = 0
local function flip_ecam_ac_dc()
    iniA330_ecam_elec_acdc = 1 - iniA330_ecam_elec_acdc
    if iniA330_ecam_elec_acdc == 0 then
        wwecam:CfgRpn(7, "1 (>L:AB_ECAM_EL_AC)", "0 (>L:AB_ECAM_EL_AC)")
    else
        wwecam:CfgRpn(7, "1 (>L:AB_ECAM_EL_DC)", "0 (>L:AB_ECAM_EL_DC)")
    end
end

flip_ecam_ac_dc() -- start with AC
wwecam:CfgFc(7, "flip_ecam_ac_dc()")

-- HYD
wwecam:CfgRpn(8, "1 (>L:AB_ECAM_HYD)", "0 (>L:AB_ECAM_HYD)")
-- FUEL
wwecam:CfgRpn(9, "1 (>L:AB_ECAM_FUEL)", "0 (>L:AB_ECAM_FUEL)")

-- APU
wwecam:CfgRpn(10, "1 (>L:AB_ECAM_APU)", "0 (>L:AB_ECAM_APU)")
-- COND
wwecam:CfgRpn(11, "1 (>L:AB_ECAM_COND)", "0 (>L:AB_ECAM_COND)")
-- DOOR
wwecam:CfgRpn(12, "1 (>L:AB_ECAM_DOOR)", "0 (>L:AB_ECAM_DOOR)")
-- WHEEL
wwecam:CfgRpn(13, "1 (>L:AB_ECAM_WHEEL)", "0 (>L:AB_ECAM_WHEEL)")
-- FCTL
wwecam:CfgRpn(14, "1 (>L:AB_ECAM_F_CTL)", "0 (>L:AB_ECAM_F_CTL)")

-- ALL
wwecam:CfgRpn(15, "1 (>L:AB_ECAM_ALL)", "0 (>L:AB_ECAM_ALL)")

-- CLR left / CLR right: QMPE has a single CLR button, key 21 copies key 16
wwecam:CfgRpn(16, "1 (>L:AB_ECAM_CLR_LEFT)", "0 (>L:AB_ECAM_CLR_LEFT)")
wwecam:CfgRpn(21, "1 (>L:AB_ECAM_CLR_LEFT)", "0 (>L:AB_ECAM_CLR_LEFT)")

-- STS
wwecam:CfgRpn(18, "1 (>L:AB_ECAM_STS)", "0 (>L:AB_ECAM_STS)")
-- RCL
wwecam:CfgRpn(19, "1 (>L:AB_ECAM_RCL)", "0 (>L:AB_ECAM_RCL)")

--------------------Output lights ---------------------
-- =====ECAM
wwecam:GetEEng("(L:AB_ECAM_ENG_light)")
wwecam:GetEBleed("(L:AB_ECAM_BLEED_light)")
wwecam:GetEPress("(L:AB_ECAM_PRESS_light)")
wwecam:GetEElec("(L:AB_ECAM_EL_AC_light) (L:AB_ECAM_EL_DC_light) or")
wwecam:GetEHyd("(L:AB_ECAM_HYD_light)")
wwecam:GetEFuel("(L:AB_ECAM_FUEL_light)")

wwecam:GetEApu("(L:AB_ECAM_APU_light)")
wwecam:GetECond("(L:AB_ECAM_COND_light)")
wwecam:GetEDoor("(L:AB_ECAM_DOOR_light)")
wwecam:GetEWheel("(L:AB_ECAM_WHEEL_light)")
wwecam:GetEFctl("(L:AB_ECAM_F_CTL_light)")

wwecam:GetEClrL("(L:AB_ECAM_CLR_LEFT_Light)")
wwecam:GetEClrR("(L:AB_ECAM_CLR_LEFT_Light)")
wwecam:GetESts("(L:AB_ECAM_STS_Light)")

-- 亮度必须落在 Wwecam 的单字节 0~255：源 0~100 → 2.55；源 0~1 → 255
-- （QMPE 的 0.3/30/100 是它自己通道的刻度，照搬会溢出：50*30=1500 → 串到 LED id，实测会乱灯）
wwecam:GetBkl("(L:TLS_INT_LT_MCDU1_INTEG_LT_LEVEL)", 2.55) -- 0~100

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

local dr_power = iDataRef:New("(L:TLS_FCU_AVAILABLE, Bool)") -- 0: OFF 1: ON
local dr_test = iDataRef:New("(L:AB_VC_OVH_ANN_LT_SW)") -- 0: TEST 1: BRT 2: DIM
local TEST_MODE = 0

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
        else
            fresh_ecam()
        end
    end

    -- brightness
    wwecam:SetBkl()
    wwecam:SetEcam()
end)