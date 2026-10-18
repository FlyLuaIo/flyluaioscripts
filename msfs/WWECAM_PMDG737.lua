-- *****************************************************************
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-10-18_12_37_56UTC
-- *****************************************************************
-- Wwecam for PMDG737
-- ported from msfs/QMPE_PMDG737.lua (ECAM part only)
-- WWECAM key map (keep in sync with xp/WWECAM_Toliss.lua):
--  1:TO CONFIG  3:EMER CANCEL(TODO)  4:ENG    5:BLEED  6:PRESS  7:ELEC
--  8:HYD        9:FUEL        10:APU   11:COND  12:DOOR  13:WHEEL
-- 14:FCTL      15:ALL         16:CLR(L) 18:STS  19:RCL   21:CLR(R)

if ilua_require_pmdg_737() then return end

-- Do not remove below lines: hardware detection
local wwecam = com.sim.qm.Wwecam.Open()
if not wwecam then return end
-- Do not remove above lines: hardware detection

uluaLog("Wwecam for PMDG737")

--------------------Input Keys Binding ---------------------

-- HUD / TO CONFIG 位（QMPE 原样：97901 ROTOR_BRAKE）
wwecam:CfgRpn(1, "97901 (>K:ROTOR_BRAKE)")

-- EMER CANCEL
-- TODO: 737 没有 EMER CANCEL 按钮，QMPE/HubHop 都没有可映射项，先留空

-- MFD ENG BUTTON：QMPE 是两步写（先 46300+1，再写页面索引 20）
-- 全局函数名加 wwecam_ 前缀，避免和 QMPE_PMDG737.lua 里的同名全局函数互相覆盖
function wwecam_pmdg737_eng_step2()
    uluaWriteCmd("20 (>L:A32NX_ECAM_SD_CURRENT_PAGE_INDEX)")
end

function wwecam_pmdg737_eng_step1()
    uluaWriteCmd("46300 1 + (>K:ROTOR_BRAKE)")
    uluasetTimeout("wwecam_pmdg737_eng_step2()", 100)
end

wwecam:CfgFc(4, "wwecam_pmdg737_eng_step1()", '')

-- 页面记号线（LED 靠它判断当前页）
wwecam:CfgRpn(5, "1 (>L:A32NX_ECAM_SD_CURRENT_PAGE_INDEX)")
wwecam:CfgRpn(6, "2 (>L:A32NX_ECAM_SD_CURRENT_PAGE_INDEX)")
wwecam:CfgRpn(7, "3 (>L:A32NX_ECAM_SD_CURRENT_PAGE_INDEX)")

-- 注意：QMPE 在这两个位置上挂的不是 HYD/FUEL 页，而是 737 的
-- CHOCKS TOGGLE（8=HYD 键）和 GND PWR（9=FUEL 键）；照原样搬，要改就改这两行
wwecam:CfgRpn(8, "62301 (>K:ROTOR_BRAKE) , 61601 (>K:ROTOR_BRAKE) , 61201 (>K:ROTOR_BRAKE) , 61701 (>K:ROTOR_BRAKE)")
wwecam:CfgRpn(9, "62301 (>K:ROTOR_BRAKE) , 61601 (>K:ROTOR_BRAKE) , 61201 (>K:ROTOR_BRAKE) , 60701 (>K:ROTOR_BRAKE)")

wwecam:CfgRpn(10, "6 (>L:A32NX_ECAM_SD_CURRENT_PAGE_INDEX)")
wwecam:CfgRpn(11, "7 (>L:A32NX_ECAM_SD_CURRENT_PAGE_INDEX)")
wwecam:CfgRpn(12, "8 (>L:A32NX_ECAM_SD_CURRENT_PAGE_INDEX)")
wwecam:CfgRpn(13, "9 (>L:A32NX_ECAM_SD_CURRENT_PAGE_INDEX)")
wwecam:CfgRpn(14, "10 (>L:A32NX_ECAM_SD_CURRENT_PAGE_INDEX)")

-- ALL
wwecam:CfgRpn(15, "1 (>L:A32NX_ECAM_ALL_Push_IsDown)", "0 (>L:A32NX_ECAM_ALL_Push_IsDown)")

-- CLR left / CLR right: QMPE has a single CLR button, key 21 copies key 16
wwecam:CfgRpn(16, "1 (>L:A32NX_BTN_CLR)", "0 (>L:A32NX_BTN_CLR)")
wwecam:CfgRpn(21, "1 (>L:A32NX_BTN_CLR)", "0 (>L:A32NX_BTN_CLR)")

-- MFD SYS BUTTON（STS 键）
wwecam:CfgRpn(18,
    "(L:A32NX_ECAM_SD_CURRENT_PAGE_INDEX) 11 != if{ 11 (>L:A32NX_ECAM_SD_CURRENT_PAGE_INDEX) } els{ -1 (>L:A32NX_ECAM_SD_CURRENT_PAGE_INDEX) } (>H:A32NX_SD_PAGE_CHANGED)  46200 1 + (>K:ROTOR_BRAKE)")

-- RCL
wwecam:CfgRpn(19, "1 (>L:A32NX_BTN_RCL)", "0 (>L:A32NX_BTN_RCL)")

--------------------Output lights ---------------------
-- =====ECAM
-- PMDG 没有真正的 ECAM，QMPE 用 A32NX_ECAM_SD_CURRENT_PAGE_INDEX 当"当前页"记号线，
-- 这里原样沿用
local PIDX = "(L:A32NX_ECAM_SD_CURRENT_PAGE_INDEX) "
local function page_is(n)
    return PIDX .. tostring(n) .. " =="
end

wwecam:GetEEng(page_is(20))
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

wwecam:GetEClrL(page_is(12))
wwecam:GetEClrR(page_is(12))
wwecam:GetESts(page_is(11))

-- 亮度必须落在 Wwecam 的单字节 0~255：源 0~100 → 2.55；源 0~1 → 255
-- （QMPE 的 0.3/30/100 是它自己通道的刻度，照搬会溢出：50*30=1500 → 串到 LED id，实测会乱灯）
if MSFS_VERSION == 0 then
    wwecam:GetBkl("(L:BL_Pedestal)", 2.55)                     -- 0~100
else
    wwecam:GetBkl("(L:PED_PANEL_LIGHT_CONTROL, number)", 0.85) -- 0~300 → 255/300
end

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

local dr_power = iDataRef:New("pmdg/ng3/data/MCP_indication_powered") -- 0: OFF >0: ON
local dr_test = iDataRef:New("(L:switch_346_73X,number)") -- 100: DIM 50: BRT 0: TEST
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