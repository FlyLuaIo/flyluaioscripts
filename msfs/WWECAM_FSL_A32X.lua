-- *****************************************************************
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-10-18_12_37_56UTC
-- *****************************************************************
-- Wwecam for FSLabs A32X
-- ported from msfs/data/QMPE_FSL_A32X.lua (ECAM part only)
-- WWECAM key map (keep in sync with xp/WWECAM_Toliss.lua):
--  1:TO CONFIG  3:EMER CANCEL(TODO)  4:ENG    5:BLEED  6:PRESS  7:ELEC
--  8:HYD        9:FUEL        10:APU   11:COND  12:DOOR  13:WHEEL
-- 14:FCTL      15:ALL         16:CLR(L) 18:STS  19:RCL   21:CLR(R)

if ilua_require_fslabs_a32x() then return end

-- Do not remove below lines: hardware detection
local wwecam = com.sim.qm.Wwecam.Open()
if not wwecam then return end
-- Do not remove above lines: hardware detection

uluaLog("Wwecam for FSLabs A32X")

--------------------Input Keys Binding ---------------------

-- ROTOR_BRAKE codes: press = code, release = code + 2
local function bind_ecam(key, code)
    wwecam:CfgRpn(key, string.format("%d (>K:ROTOR_BRAKE)", code),
        string.format("%d 2 + (>K:ROTOR_BRAKE)", code))
end

-- TO CONFIG
bind_ecam(1, 77034)

-- EMER CANCEL
-- TODO: QMPE_FSL 没有 EMER CANCEL 绑定；HubHop 没有 FSLabs 区，查不到，先留空
-- FSL 按钮 code 是连号的（TO CONFIG 77034、ENG 77048…），确认后补 bind_ecam(3, <code>)

bind_ecam(4, 77048)   -- ENG
bind_ecam(5, 77053)   -- BLEED
bind_ecam(6, 77058)   -- PRESS
bind_ecam(7, 77063)   -- ELEC
bind_ecam(8, 77068)   -- HYD
bind_ecam(9, 77073)   -- FUEL

bind_ecam(10, 77078)  -- APU
bind_ecam(11, 77083)  -- COND
bind_ecam(12, 77088)  -- DOOR
bind_ecam(13, 77093)  -- WHEEL
bind_ecam(14, 77098)  -- FCTL

bind_ecam(15, 77103)  -- ALL

bind_ecam(16, 77108)  -- CLR left
-- CLR right: QMPE has a single CLR button, key 21 copies key 16
bind_ecam(21, 77108)

bind_ecam(18, 77113)  -- STS
bind_ecam(19, 77118)  -- RCL

--------------------Output lights ---------------------
-- =====ECAM
wwecam:GetEEng("(L:VC_PED_ECP_ENG_Brt_Lt)")
wwecam:GetEBleed("(L:VC_PED_ECP_BLEED_Brt_Lt)")
wwecam:GetEPress("(L:VC_PED_ECP_PRESS_Brt_Lt)")
wwecam:GetEElec("(L:VC_PED_ECP_ELEC_Brt_Lt)")
wwecam:GetEHyd("(L:VC_PED_ECP_HYD_Brt_Lt)")
wwecam:GetEFuel("(L:VC_PED_ECP_FUEL_Brt_Lt)")

wwecam:GetEApu("(L:VC_PED_ECP_APU_Brt_Lt)")
wwecam:GetECond("(L:VC_PED_ECP_COND_Brt_Lt)")
wwecam:GetEDoor("(L:VC_PED_ECP_DOOR_Brt_Lt)")
wwecam:GetEWheel("(L:VC_PED_ECP_WHEEL_Brt_Lt)")
wwecam:GetEFctl("(L:VC_PED_ECP_FCTL_Brt_Lt)")

wwecam:GetEClrL("(L:VC_PED_ECP_CLR_L_Brt_Lt)")
wwecam:GetEClrR("(L:VC_PED_ECP_CLR_L_Brt_Lt)")
wwecam:GetESts("(L:VC_PED_ECP_STS_Brt_Lt)")

-- 亮度必须落在 Wwecam 的单字节 0~255：源 0~100 → 2.55；源 0~1 → 255
-- （QMPE 的 0.3/30/100 是它自己通道的刻度，照搬会溢出：50*30=1500 → 串到 LED id，实测会乱灯）
wwecam:GetBkl("(L:VC_PED_Dimmer)", 2.55) -- 0~100

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

local dr_power = iDataRef:New("(L:FSL_MCDU_Right_Powered, Bool)") -- 0: OFF 1: ON
local dr_test = iDataRef:New("(L:VC_OVHD_INTLT_AnnLt_Switch)") -- 0: DIM 10: BRT 20: TEST
local TEST_MODE = 20

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