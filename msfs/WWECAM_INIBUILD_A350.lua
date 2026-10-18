-- *****************************************************************
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-10-18_12_37_56UTC
-- *****************************************************************
-- Wwecam for Inibuild A350
-- ported from msfs/QMPE_INIBUILD_A350.lua (ECAM part only)
-- WWECAM key map (keep in sync with xp/WWECAM_Toliss.lua):
--  1:TO CONFIG  3:EMER CANCEL(TODO)  4:ENG    5:BLEED  6:PRESS  7:ELEC
--  8:HYD        9:FUEL        10:APU   11:COND  12:DOOR  13:WHEEL
-- 14:FCTL      15:ALL         16:CLR(L) 18:STS  19:RCL   21:CLR(R)

if ilua_require_inibuild_a350() then return end

-- Do not remove below lines: hardware detection
local wwecam = com.sim.qm.Wwecam.Open()
if not wwecam then return end
-- Do not remove above lines: hardware detection

uluaLog("Wwecam for Inibuild A350")

--------------------Input Keys Binding ---------------------

-- TO CONFIG (MSFS2020 用 B: 直写，2024 用 PUSH/RELEASE)
if MSFS_VERSION == 0 then
    wwecam:CfgVal(1, "B:AIRLINER_ECAM_TO_CONFIG", 2, 1)
else
    wwecam:CfgRpn(1, "2 (>B:AIRLINER_ECAM_TO_CONFIG_PUSH)", "1 (>B:AIRLINER_ECAM_TO_CONFIG_RELEASE)")
end

-- EMER CANCEL
-- TODO: QMPE_INIBUILD_A350 没有 EMER CANCEL 绑定，先留空

-- ENG / BLEED / PRESS
wwecam:CfgRpn(4, "1 (>L:PUSH_ECAM_ENG)")
wwecam:CfgRpn(5, "1 (>L:PUSH_ECAM_BLEED)")
wwecam:CfgRpn(6, "1 (>L:PUSH_ECAM_PRESS)")

-- ELEC: AC/DC 两页轮流
-- 0:ELEC AC  1:ELEC DC
local iniA330_ecam_elec_acdc = 0
local function flip_ecam_ac_dc()
    iniA330_ecam_elec_acdc = 1 - iniA330_ecam_elec_acdc
    if iniA330_ecam_elec_acdc == 0 then
        wwecam:CfgRpn(7, "1 (>L:PUSH_ECAM_ELEC_AC)")
    else
        wwecam:CfgRpn(7, "1 (>L:PUSH_ECAM_ELEC_DC)")
    end
end

flip_ecam_ac_dc() -- start with AC
wwecam:CfgFc(7, "flip_ecam_ac_dc()")

-- HYD / FUEL
wwecam:CfgRpn(8, "1 (>L:PUSH_ECAM_HYD)")
wwecam:CfgRpn(9, "1 (>L:PUSH_ECAM_FUEL)")

-- APU (release 有单独事件) / COND / DOOR / WHEEL / FCTL
wwecam:CfgRpn(10, "1 (>L:PUSH_ECAM_APU)", "1 (>L:INI_PUSH_ECAM_APU_RELEASE)")
wwecam:CfgRpn(11, "1 (>L:PUSH_ECAM_COND)")
wwecam:CfgRpn(12, "1 (>L:PUSH_ECAM_DOOR)")
wwecam:CfgRpn(13, "1 (>L:PUSH_ECAM_WHEEL)")
wwecam:CfgRpn(14, "1 (>L:PUSH_ECAM_FCTL)")

-- ALL
wwecam:CfgRpn(15, "1 (>L:PUSH_ECAM_ALL)", "0 (>L:PUSH_ECAM_ALL)")

-- CLR left (MSFS2020: LVar / 2024: B: 事件)，CLR right 复制 key 16
local function bind_clr(key)
    if MSFS_VERSION == 0 then
        wwecam:CfgRpn(key, "1 (>L:PUSH_ECAM_CLR)")
    else
        wwecam:CfgRpn(key, "1 (>B:AIRLINER_ECAM_CLEAR_LEFT_Push)", "1 (>B:AIRLINER_ECAM_CLEAR_LEFT_Release)")
    end
end
bind_clr(16)
bind_clr(21)

-- STS / RCL
wwecam:CfgRpn(18, "1 (>L:PUSH_ECAM_STS)", "0 (>L:PUSH_ECAM_STS)")
wwecam:CfgRpn(19, "1 (>L:PUSH_ECAM_RCL)", "0 (>L:PUSH_ECAM_RCL)")

--------------------Output lights ---------------------
-- =====ECAM
local PIDX = "(L:INI_ECAM_ACTIVE_PAGE) "
local function page_is(n)
    return PIDX .. tostring(n) .. " =="
end

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

-- QMPE 的 scale 原样借用；Wwecam 亮度字节是 0~255，实机偏亮/偏暗就调这个数
wwecam:GetBkl("(L:INI_CKPT_LT_INTEG, Percent)", 0.3)

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

local dr_power = iDataRef:New("(L:INI_ELEC_AC_ESS_SHED_BUS_IS_POWERED, number)") -- 0: OFF 1: ON
local dr_test = iDataRef:New("(L:INI_ANNLT_SWITCH, number)") -- 0: TEST 1: BRT 2: DIM
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
        end
        fresh_ecam()
    end

    -- brightness
    wwecam:SetBkl()
    wwecam:SetEcam()
end)
