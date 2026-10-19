-- *****************************************************************
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-10-18_12_37_56UTC
-- *****************************************************************
-- Wwecam for Inibuild A320 / A330 / BelugaX
-- ported from msfs/data/QMPE_INIBUILD_A3xx.lua (ECAM part only)
-- WWECAM key map (keep in sync with xp/WWECAM_Toliss.lua):
--  1:TO CONFIG  3:EMER CANCEL(TODO)  4:ENG    5:BLEED  6:PRESS  7:ELEC
--  8:HYD        9:FUEL        10:APU   11:COND  12:DOOR  13:WHEEL
-- 14:FCTL      15:ALL         16:CLR(L) 18:STS  19:RCL   21:CLR(R)

if ilua_require_inibuild_a3xx_family() then return end

-- Do not remove below lines: hardware detection
local wwecam = com.sim.qm.Wwecam.Open()
if not wwecam then return end
-- Do not remove above lines: hardware detection

uluaLog("Wwecam for Inibuild A320/A330")

-- A330
local isINIA330 = false
if not ilua_is_acfpath_excluded("A330") then
    isINIA330 = true
    uluaLog("- Wwecam Inibuild A330")
end

if not ilua_is_acfpath_excluded("belugax") then
    isINIA330 = true
    uluaLog("- Wwecam Inibuild belugax")
end

-- 0:ELEC AC  1:ELEC DC
local iniA330_ecam_elec_acdc = 0

--------------------Input Keys Binding ---------------------

-- TO CONFIG
wwecam:CfgRpn(1, "1 (>L:PUSH_ECAM_TOCONFIG)", "0 (>L:PUSH_ECAM_TOCONFIG)")

-- EMER CANCEL
-- TODO: QMPE_INIBUILD（A320/A330/BelugaX）没有 EMER CANCEL 绑定，先留空
-- HubHop 查过：IniBuilds/A320 与 /A330 的 ECAM 区都没有 EMER CANCEL preset（A330 只有 B:AIRLINER_ECAM_CLR_ON）

-- ENG
wwecam:CfgRpn(4, "1 (>L:PUSH_ECAM_ENG)")
-- BLEED
wwecam:CfgRpn(5, "1 (>L:PUSH_ECAM_BLEED)")
-- PRESS
wwecam:CfgRpn(6, "1 (>L:PUSH_ECAM_PRESS)")

-- ELEC: A330/BelugaX have separate AC/DC buttons
local function flip_ecam_ac_dc()
    iniA330_ecam_elec_acdc = 1 - iniA330_ecam_elec_acdc
    if iniA330_ecam_elec_acdc == 0 then
        wwecam:CfgRpn(7, "1 (>L:PUSH_ECAM_ELEC_AC)")
    else
        wwecam:CfgRpn(7, "1 (>L:PUSH_ECAM_ELEC_DC)")
    end
end

if isINIA330 then
    flip_ecam_ac_dc() -- start with AC
    wwecam:CfgFc(7, "flip_ecam_ac_dc()")
else
    wwecam:CfgRpn(7, "1 (>L:PUSH_ECAM_ELEC_AC)")
end

-- HYD
wwecam:CfgRpn(8, "1 (>L:PUSH_ECAM_HYD)")
-- FUEL
wwecam:CfgRpn(9, "1 (>L:PUSH_ECAM_FUEL)")

-- APU (release has its own event)
wwecam:CfgRpn(10, "1 (>L:PUSH_ECAM_APU)", "1 (>L:INI_PUSH_ECAM_APU_RELEASE)")
-- COND
wwecam:CfgRpn(11, "1 (>L:PUSH_ECAM_COND)")
-- DOOR
wwecam:CfgRpn(12, "1 (>L:PUSH_ECAM_DOOR)")
-- WHEEL
wwecam:CfgRpn(13, "1 (>L:PUSH_ECAM_WHEEL)")
-- FCTL
wwecam:CfgRpn(14, "1 (>L:PUSH_ECAM_FCTL)")

-- ALL
wwecam:CfgRpn(15, "1 (>L:PUSH_ECAM_ALL)", "0 (>L:PUSH_ECAM_ALL)")

-- CLR left / CLR right: QMPE has a single CLR button, key 21 copies key 16
wwecam:CfgRpn(16, "1 (>L:PUSH_ECAM_CLR)", "0 (>L:PUSH_ECAM_CLR)")
wwecam:CfgRpn(21, "1 (>L:PUSH_ECAM_CLR)", "0 (>L:PUSH_ECAM_CLR)")

-- STS
wwecam:CfgRpn(18, "1 (>L:PUSH_ECAM_STS)", "0 (>L:PUSH_ECAM_STS)")
-- RCL
wwecam:CfgRpn(19, "1 (>L:PUSH_ECAM_RCL)", "0 (>L:PUSH_ECAM_RCL)")

--------------------Output lights ---------------------
-- =====ECAM
local PIDX = "(L:INI_ECAM_ACTIVE_PAGE) "
local function page_is(n)
    return PIDX .. tostring(n) .. " =="
end

if isINIA330 then
    wwecam:GetEEng(page_is(1))
    wwecam:GetEBleed(page_is(5))
    wwecam:GetEPress(page_is(7))
    wwecam:GetEElec(page_is(3) .. " " .. page_is(4) .. " ||")
    wwecam:GetEHyd(page_is(2))
    wwecam:GetEFuel(page_is(8))

    wwecam:GetEApu(page_is(9))
    wwecam:GetECond(page_is(6))
    wwecam:GetEDoor(page_is(11))
    wwecam:GetEWheel(page_is(12))
    wwecam:GetEFctl(page_is(10))

    wwecam:GetEClrL("(L:INI_ECAM_CLR_LIGHT, Bool)")
    wwecam:GetEClrR("(L:INI_ECAM_CLR_LIGHT, Bool)")
    wwecam:GetESts(page_is(14))
else
    wwecam:GetEEng(page_is(1))
    wwecam:GetEBleed(page_is(4))
    wwecam:GetEPress(page_is(6))
    wwecam:GetEElec(page_is(3))
    wwecam:GetEHyd(page_is(2))
    wwecam:GetEFuel(page_is(7))

    wwecam:GetEApu(page_is(8))
    wwecam:GetECond(page_is(5))
    wwecam:GetEDoor(page_is(10))
    wwecam:GetEWheel(page_is(11))
    wwecam:GetEFctl(page_is(9))

    wwecam:GetEClrL("(L:INI_ECAM_CLR_LIGHT, Bool)")
    wwecam:GetEClrR("(L:INI_ECAM_CLR_LIGHT, Bool)")
    wwecam:GetESts(page_is(13))
end

-- 亮度必须落在 Wwecam 的单字节 0~255：源 0~100 → 2.55；源 0~1 → 255
-- （QMPE 的 0.3/30/100 是它自己通道的刻度，照搬会溢出：50*30=1500 → 串到 LED id，实测会乱灯）
wwecam:GetBkl("(A:LIGHT POTENTIOMETER:15, Percent)", 2.55) -- 0~100

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

local dr_power = iDataRef:New("(L:INI_DC_ESSENTIAL_BUS_IS_POWERED, number)") -- 0: OFF 1: ON
local dr_test = iDataRef:New("(L:INI_ANNLT_SWITCH, number)") -- 0: TEST 1: BRT 2: DIM
local TEST_MODE = 0

GlobalFrameLoopManager:add(function()
    -- expert code: cold and dark
    if dr_power:ChangedUpdate() then
        if dr_power:GetOld() == 0 then
            wwecam:PowerOff()
            return
        else
            wwecam:FreshBkl()
            fresh_ecam()
        end
    end

    -- expert code: test mode
    if dr_test:ChangedUpdate() then
        if dr_test:GetOld() == TEST_MODE then
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