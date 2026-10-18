-- *****************************************************************
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-10-18_12_37_56UTC
-- *****************************************************************
-- Wwecam for PMDG777
-- ported from msfs/QMPE_PMDG777.lua (ECAM part only)
-- WWECAM key map (keep in sync with xp/WWECAM_Toliss.lua):
--  1:TO CONFIG  3:EMER CANCEL(TODO)  4:ENG    5:BLEED  6:PRESS  7:ELEC
--  8:HYD        9:FUEL        10:APU   11:COND  12:DOOR  13:WHEEL
-- 14:FCTL      15:ALL         16:CLR(L) 18:STS  19:RCL   21:CLR(R)

if ilua_require_pmdg_777() then return end

-- Do not remove below lines: hardware detection
local wwecam = com.sim.qm.Wwecam.Open()
if not wwecam then return end
-- Do not remove above lines: hardware detection

uluaLog("Wwecam for PMDG777")

--------------------Input Keys Binding ---------------------

-- TO CONFIG 位（QMPE 原样：21601 ROTOR_BRAKE）
wwecam:CfgRpn(1, "21601 (>K:ROTOR_BRAKE)")

-- EMER CANCEL
-- TODO: 777 没有 EMER CANCEL 按钮，QMPE/HubHop 都没有可映射项，先留空

-- 页面键：press 打 ROTOR_BRAKE，release 再写当前页记号线
wwecam:CfgRpn(4, "23401 (>K:ROTOR_BRAKE)", "0 (>L:A32NX_ECAM_SD_CURRENT_PAGE_INDEX) 23404 (>K:ROTOR_BRAKE)")
wwecam:CfgRpn(5, "23901 (>K:ROTOR_BRAKE)", "1 (>L:A32NX_ECAM_SD_CURRENT_PAGE_INDEX) 23904 (>K:ROTOR_BRAKE)")
wwecam:CfgRpn(6, "24501 (>K:ROTOR_BRAKE)", "2 (>L:A32NX_ECAM_SD_CURRENT_PAGE_INDEX) 24504 (>K:ROTOR_BRAKE)")
wwecam:CfgRpn(7, "23601 (>K:ROTOR_BRAKE)", "3 (>L:A32NX_ECAM_SD_CURRENT_PAGE_INDEX) 23604 (>K:ROTOR_BRAKE)")
wwecam:CfgRpn(8, "23701 (>K:ROTOR_BRAKE)", "4 (>L:A32NX_ECAM_SD_CURRENT_PAGE_INDEX) 23704 (>K:ROTOR_BRAKE)")
wwecam:CfgRpn(9, "23801 (>K:ROTOR_BRAKE)", "5 (>L:A32NX_ECAM_SD_CURRENT_PAGE_INDEX) 23804 (>K:ROTOR_BRAKE)")

wwecam:CfgRpn(10, "23501 (>K:ROTOR_BRAKE)", "6 (>L:A32NX_ECAM_SD_CURRENT_PAGE_INDEX) 23504 (>K:ROTOR_BRAKE)")
wwecam:CfgRpn(11, "23901 (>K:ROTOR_BRAKE)", "7 (>L:A32NX_ECAM_SD_CURRENT_PAGE_INDEX) 23904 (>K:ROTOR_BRAKE)")
wwecam:CfgRpn(12, "24001 (>K:ROTOR_BRAKE)", "8 (>L:A32NX_ECAM_SD_CURRENT_PAGE_INDEX) 24004 (>K:ROTOR_BRAKE)")
wwecam:CfgRpn(13, "24101 (>K:ROTOR_BRAKE)", "9 (>L:A32NX_ECAM_SD_CURRENT_PAGE_INDEX) 24104 (>K:ROTOR_BRAKE)")
wwecam:CfgRpn(14, "24201 (>K:ROTOR_BRAKE)", "10 (>L:A32NX_ECAM_SD_CURRENT_PAGE_INDEX) 24204 (>K:ROTOR_BRAKE)")

-- check list (ALL)
wwecam:CfgRpn(15, "24401 (>K:ROTOR_BRAKE)", "24404 (>K:ROTOR_BRAKE)")

-- CLR left / CLR right: QMPE 里 ALL 和 CLR 用的是同一个 code，key 21 复制 key 16
wwecam:CfgRpn(16, "24401 (>K:ROTOR_BRAKE)")
wwecam:CfgRpn(21, "24401 (>K:ROTOR_BRAKE)")

-- STS（QMPE 原样：和 APU 键同一个 code）
wwecam:CfgRpn(18, "23501 (>K:ROTOR_BRAKE)", "23504 (>K:ROTOR_BRAKE)")
-- RCL
wwecam:CfgRpn(19, "24701 (>K:ROTOR_BRAKE)")

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
wwecam:GetBkl("(A:LIGHT POTENTIOMETER:85, Percent)", 2.55) -- 0~100

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

local dr_power = iDataRef:New("(L:Battery)") -- 0: OFF >0: ON
local dr_test = iDataRef:New("(L:switch_118_a,number)") -- 0: TEST 50: BRT 100: DIM
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