-- *****************************************************************
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-10-18_12_37_56UTC
-- *****************************************************************
-- Wwecam for Inibuild A340
-- ported from msfs/QMPE_INIBUILD_A340.lua (ECAM part only)
-- WWECAM key map (keep in sync with xp/WWECAM_Toliss.lua):
--  1:TO CONFIG  3:EMER CANCEL(TODO)  4:ENG    5:BLEED  6:PRESS  7:ELEC
--  8:HYD        9:FUEL        10:APU   11:COND  12:DOOR  13:WHEEL
-- 14:FCTL      15:ALL         16:CLR(L) 18:STS  19:RCL   21:CLR(R)

if ilua_require_inibuild_a340() then return end

-- Do not remove below lines: hardware detection
local wwecam = com.sim.qm.Wwecam.Open()
if not wwecam then return end
-- Do not remove above lines: hardware detection

uluaLog("Wwecam for Inibuild A340")

--------------------Input Keys Binding ---------------------

-- TO CONFIG
wwecam:CfgVal(1, "B:AIRLINER_ECAM_TOCONFIG", 2, 0)

-- EMER CANCEL
-- TODO: QMPE_INIBUILD_A340 没有 EMER CANCEL 绑定；HubHop 的 IniBuilds/A340-300 没有 ECAM 区，查不到，先留空

-- ENG / BLEED / PRESS
wwecam:CfgVal(4, "B:AIRLINER_ECAM_ENG", 2, 0)
wwecam:CfgVal(5, "B:AIRLINER_ECAM_BLEED", 2, 0)
wwecam:CfgVal(6, "B:AIRLINER_ECAM_PRESS", 2, 0)

-- ELEC: A340 有独立的 AC/DC 键，一个 WWECAM 键轮流触发
-- 0:ELEC AC  1:ELEC DC
local iniA330_ecam_elec_acdc = 0
local function flip_ecam_ac_dc()
    iniA330_ecam_elec_acdc = 1 - iniA330_ecam_elec_acdc
    if iniA330_ecam_elec_acdc == 0 then
        wwecam:CfgVal(7, "B:AIRLINER_ECAM_ELAC", 2, 0)
    else
        wwecam:CfgVal(7, "B:AIRLINER_ECAM_ELDC", 2, 0)
    end
end

flip_ecam_ac_dc() -- start with AC
wwecam:CfgFc(7, "flip_ecam_ac_dc()")

-- HYD / FUEL
wwecam:CfgVal(8, "B:AIRLINER_ECAM_HYD", 2, 0)
wwecam:CfgVal(9, "B:AIRLINER_ECAM_FUEL", 2, 0)

-- APU / COND / DOOR / WHEEL / FCTL
wwecam:CfgVal(10, "B:AIRLINER_ECAM_APU", 2, 0)
wwecam:CfgVal(11, "B:AIRLINER_ECAM_COND", 2, 0)
wwecam:CfgVal(12, "B:AIRLINER_ECAM_DOOR", 2, 0)
wwecam:CfgVal(13, "B:AIRLINER_ECAM_WHEEL", 2, 0)
wwecam:CfgVal(14, "B:AIRLINER_ECAM_FCTL", 2, 0)

-- ALL
wwecam:CfgVal(15, "B:AIRLINER_ECAM_ALL", 2, 0)

-- CLR left / CLR right: QMPE has a single CLR button, key 21 copies key 16
wwecam:CfgVal(16, "B:AIRLINER_ECAM_CLR", 2, 0)
wwecam:CfgVal(21, "B:AIRLINER_ECAM_CLR", 2, 0)

-- STS / RCL
wwecam:CfgVal(18, "B:AIRLINER_ECAM_STS", 2, 0)
wwecam:CfgVal(19, "B:AIRLINER_ECAM_RCL", 2, 0)

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

wwecam:GetEClrL("(L:INI_ATLEASTONEMASTERCAUTION, Bool)")
wwecam:GetEClrR("(L:INI_ATLEASTONEMASTERCAUTION, Bool)")
wwecam:GetESts(page_is(14))

-- 亮度必须落在 Wwecam 的单字节 0~255：源 0~100 → 2.55；源 0~1 → 255
-- （QMPE 的 0.3/30/100 是它自己通道的刻度，照搬会溢出：50*30=1500 → 串到 LED id，实测会乱灯）
wwecam:GetBkl("(A:LIGHT POTENTIOMETER:15, Percent)", 2.55)

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
        end
        fresh_ecam()
    end

    -- brightness
    wwecam:SetBkl()
    wwecam:SetEcam()
end)