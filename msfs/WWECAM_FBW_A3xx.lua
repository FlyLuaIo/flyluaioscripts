-- *****************************************************************
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-10-18_12_37_56UTC
-- *****************************************************************
-- Wwecam for FlyByWire A320neo / Headwind A330 / FBW A380
-- ported from msfs/data/QMPE_FBW_A320NX.lua (ECAM part only)
-- WWECAM key map (keep in sync with xp/WWECAM_Toliss.lua):
--  1:TO CONFIG  3:EMER CANCEL(TODO)  4:ENG    5:BLEED  6:PRESS  7:ELEC
--  8:HYD        9:FUEL        10:APU   11:COND  12:DOOR  13:WHEEL
-- 14:FCTL      15:ALL         16:CLR(L) 18:STS  19:RCL   21:CLR(R)

if ilua_require_fbw_a3xx() then return end

-- Do not remove below lines: hardware detection
local wwecam = com.sim.qm.Wwecam.Open()
if not wwecam then return end
-- Do not remove above lines: hardware detection

uluaLog("Wwecam for FBW")

-- A330
local isHEADWINDA330 = false
if not ilua_is_acfpath_excluded("A330") then
    isHEADWINDA330 = true
    uluaLog("- Wwecam Headwind A330")
end

-- A380
local isFBWA380 = false
if not ilua_is_acfpath_excluded("A380") then
    isFBWA380 = true
    uluaLog("- Wwecam FlyByWire A380")
end

--------------------Input Keys Binding ---------------------

-- TO CONFIG
if isHEADWINDA330 then
    wwecam:CfgVal(1, "B:A339X_PED_ECP_TO_CONF_TEST_PB", 1, 0)
else
    wwecam:CfgVal(1, "B:A32NX_PED_ECP_TO_CONF_TEST_PB", 1, 0)
end

-- EMER CANCEL
-- TODO: QMPE_FBW 没有 EMER CANCEL 绑定（FBW/Headwind/A380 三套都没验证过），先留空
-- 若后续确认 A32NX_PED_ECP_EMER_CANCEL_PB 之类的 B 事件，在这里补 CfgVal(3, ...)

-- 0:ELEC AC  1:ELEC DC
local iniA330_ecam_elec_acdc = 0

-- ECAM page keys (4..14)
local function bind_page(key, page_a320, page_a330, page_a380)
    local page = page_a320
    if isFBWA380 then
        page = page_a380
    elseif isHEADWINDA330 then
        page = page_a330
    end
    wwecam:CfgRpn(key, string.format("%d (>L:A32NX_ECAM_SD_CURRENT_PAGE_INDEX)", page))
end

bind_page(4, 0, 0, 0)       -- ENG
bind_page(5, 1, 1, 2)       -- BLEED
bind_page(6, 2, 2, 4)       -- PRESS

-- ELEC: A320 = page 3, A330 = 3/4 AC-DC flip, A380 = 6/7 AC-DC flip
local function flip_ecam_ac_dc()
    iniA330_ecam_elec_acdc = 1 - iniA330_ecam_elec_acdc
    local page
    if isFBWA380 then
        page = iniA330_ecam_elec_acdc == 0 and 6 or 7
    else
        page = iniA330_ecam_elec_acdc == 0 and 3 or 4
    end
    wwecam:CfgRpn(7, string.format("%d (>L:A32NX_ECAM_SD_CURRENT_PAGE_INDEX)", page))
end

if isHEADWINDA330 or isFBWA380 then
    flip_ecam_ac_dc() -- start with AC
    wwecam:CfgFc(7, "flip_ecam_ac_dc()")
else
    wwecam:CfgRpn(7, "3 (>L:A32NX_ECAM_SD_CURRENT_PAGE_INDEX)")
end

bind_page(8, 4, 5, 10)      -- HYD
bind_page(9, 5, 11, 8)      -- FUEL

bind_page(10, 6, 6, 1)      -- APU
bind_page(11, 7, 7, 3)      -- COND
bind_page(12, 8, 8, 5)      -- DOOR
bind_page(13, 9, 9, 9)      -- WHEEL
bind_page(14, 10, 10, 11)   -- FCTL

-- ALL
if isFBWA380 then
    wwecam:CfgRpn(15, "1 (>L:A32NX_ECAM_ALL_Push_IsDown)", "0 (>L:A32NX_ECAM_ALL_Push_IsDown)")
elseif isHEADWINDA330 then
    wwecam:CfgRpn(15, "1 (>L:A32NX_ECP_DISCRETE_OUT_ALL)", "0 (>L:A32NX_ECP_DISCRETE_OUT_ALL)")
else
    wwecam:CfgVal(15, "B:A32NX_PED_ECP_ALL_PB", 1, 0)
end

-- CLR left / CLR right: QMPE has a single CLR button, key 21 copies key 16
local function bind_clr(key)
    if isFBWA380 then
        wwecam:CfgVal(key, "B:A32NX_BTN_CLR", 1, 0)
    elseif isHEADWINDA330 then
        wwecam:CfgRpn(key, "1 (>L:A32NX_ECP_DISCRETE_OUT_CLR)", "0 (>L:A32NX_ECP_DISCRETE_OUT_CLR)")
    else
        wwecam:CfgVal(key, "B:A32NX_PED_ECP_CLR_1_PB", 1, 0)
    end
end
bind_clr(16)
bind_clr(21)

-- STS
if isFBWA380 then
    wwecam:CfgRpn(18, "14 (>L:A32NX_ECAM_SD_CURRENT_PAGE_INDEX)")
elseif isHEADWINDA330 then
    wwecam:CfgRpn(18, "13 (>L:A32NX_ECAM_SD_CURRENT_PAGE_INDEX)")
else
    wwecam:CfgVal(18, "B:A32NX_PED_ECP_STS_PB", 1, 0)
end

-- RCL
if isFBWA380 then
    wwecam:CfgVal(19, "B:A32NX_BTN_RCL", 1, 0)
elseif isHEADWINDA330 then
    wwecam:CfgRpn(19, "1 (>L:A32NX_ECP_DISCRETE_OUT_RCL)", "0 (>L:A32NX_ECP_DISCRETE_OUT_RCL)")
else
    wwecam:CfgVal(19, "B:A32NX_PED_ECP_RCL_PB", 1, 0)
end

--------------------Output lights ---------------------
-- =====ECAM
local PIDX = "(L:A32NX_ECAM_SD_CURRENT_PAGE_INDEX) "
local function page_is(n)
    return PIDX .. tostring(n) .. " =="
end

if isFBWA380 then
    wwecam:GetEEng(page_is(0))
    wwecam:GetEBleed(page_is(2))
    wwecam:GetEPress(page_is(4))
    wwecam:GetEElec(page_is(6) .. " " .. page_is(7) .. " ||")
    wwecam:GetEHyd(page_is(10))
    wwecam:GetEFuel(page_is(8))

    wwecam:GetEApu(page_is(1))
    wwecam:GetECond(page_is(3))
    wwecam:GetEDoor(page_is(5))
    wwecam:GetEWheel(page_is(9))
    wwecam:GetEFctl(page_is(11))

    wwecam:GetEClrL(page_is(13))
    wwecam:GetEClrR(page_is(13))
    wwecam:GetESts(page_is(14))
elseif isHEADWINDA330 then
    wwecam:GetEEng(page_is(0))
    wwecam:GetEBleed(page_is(1))
    wwecam:GetEPress(page_is(2))
    wwecam:GetEElec(page_is(3) .. " " .. page_is(4) .. " ||")
    wwecam:GetEHyd(page_is(5))
    wwecam:GetEFuel(page_is(11))

    wwecam:GetEApu(page_is(6))
    wwecam:GetECond(page_is(7))
    wwecam:GetEDoor(page_is(8))
    wwecam:GetEWheel(page_is(9))
    wwecam:GetEFctl(page_is(10))

    wwecam:GetEClrL(page_is(-1))
    wwecam:GetEClrR(page_is(-1))
    wwecam:GetESts(page_is(12))
else
    wwecam:GetEEng(page_is(0))
    wwecam:GetEBleed(page_is(1))
    wwecam:GetEPress(page_is(2))
    wwecam:GetEElec(page_is(3))
    wwecam:GetEHyd(page_is(4))
    wwecam:GetEFuel(page_is(5))

    wwecam:GetEApu(page_is(6))
    wwecam:GetECond(page_is(7))
    wwecam:GetEDoor(page_is(8))
    wwecam:GetEWheel(page_is(9))
    wwecam:GetEFctl(page_is(10))

    wwecam:GetEClrL("(L:A32NX_ECP_LIGHT_CLR_1)")
    wwecam:GetEClrR("(L:A32NX_ECP_LIGHT_CLR_1)")
    wwecam:GetESts(page_is(12))
end

-- QMPE 的 scale 原样借用；Wwecam 亮度字节是 0~255，实机偏亮/偏暗就调这个数
wwecam:GetBkl("(A:LIGHT POTENTIOMETER:85, Percent)", 0.3) -- 0~100

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

local dr_power = iDataRef:New("(L:A32NX_ELEC_AC_1_BUS_IS_POWERED, Bool)") -- 0: OFF 1: ON
local dr_test = iDataRef:New("(L:A32NX_OVHD_INTLT_ANN,enum)") -- 0: TEST 1: BRT 2: DIM
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