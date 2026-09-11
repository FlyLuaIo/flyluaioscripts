-- *****************************************************************
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-09-11
-- *****************************************************************

if ilua_require_ff320() then return end

-- Do not remove below lines: hardware detection
local wwtcas = com.sim.qm.Wwtcas.Open()
if not wwtcas then return end
-- Do not remove above lines: hardware detection

uluaLog('Wwtcas for FF320')

-- XPRD ATC Keypad
wwtcas:CfgCmd(0, "a320/Pedestal/ATC_Num1_button")
wwtcas:CfgCmd(1, "a320/Pedestal/ATC_Num2_button")
wwtcas:CfgCmd(2, "a320/Pedestal/ATC_Num3_button")
wwtcas:CfgCmd(3, "a320/Pedestal/ATC_Num4_button")
wwtcas:CfgCmd(4, "a320/Pedestal/ATC_Num5_button")
wwtcas:CfgCmd(5, "a320/Pedestal/ATC_Num6_button")
wwtcas:CfgCmd(6, "a320/Pedestal/ATC_Num7_button")
wwtcas:CfgCmd(7, "a320/Pedestal/ATC_Num8_button")
wwtcas:CfgCmd(8, "a320/Pedestal/ATC_Num9_button")

-- XDRD IDENT
wwtcas:CfgCmd(9, "sim/radios/transponder_ident")


-- XPDR STBY/AUTO/ON
wwtcas:CfgVal(10, "a320/Pedestal/ATC_Mode", 0, 1)
-- 43 is middle key reserved
-- wwtcas:CfgVal(43, "a320/Pedestal/ATC_Mode", 2, 3)
wwtcas:CfgVal(12, "a320/Pedestal/ATC_Mode", 2, 1)

-- ATC SYS 1/2
wwtcas:CfgVal(13, "a320/Pedestal/ATC_System", 0)
wwtcas:CfgVal(14, "a320/Pedestal/ATC_System", 1)

-- ALT RPTG OFF/ON
wwtcas:CfgVal(15, "a320/Pedestal/ATC_Alt", 0)
wwtcas:CfgVal(16, "a320/Pedestal/ATC_Alt", 1)

-- TCAS THRT/ALL/ABV/BLW
wwtcas:CfgVal(17, "a320/Pedestal/TCAS_Show", 0)
wwtcas:CfgVal(18, "a320/Pedestal/TCAS_Show", 1)
wwtcas:CfgVal(19, "a320/Pedestal/TCAS_Show", 2)
wwtcas:CfgVal(20, "a320/Pedestal/TCAS_Show", 3)

-- TCAS STBY/TA/TARA
wwtcas:CfgVal(21, "a320/Pedestal/TCAS_Traffic", 0, 1)
-- 41 is middle key reserved
-- wwtcas:CfgVal(41, "a320/Pedestal/TCAS_Traffic", 3, 0)
wwtcas:CfgVal(23, "a320/Pedestal/TCAS_Traffic", 2, 1)
-- ===========================================================
-- Read data
-- Expert: FF320 own logic
local b_xpdr_power = iDataRef:New("sim/cockpit2/switches/avionics_power_on")

local b_xpdr_act = iDataRef:New("a320/Aircraft/Navigation/ATC/DisplayCode")

local function xpdr_update()
    if b_xpdr_power:Get() == 0 then
        wwtcas:setLcdText()
        return
    end

    if b_xpdr_act:ChangedUpdate() then
        local d_xpdr = b_xpdr_act:Get()
        local xpdr_stby, stdr_num = wwtcas:XpdrDecode9(d_xpdr)
        wwtcas:setLcdText(wwtcas:EncXpdr(xpdr_stby, stdr_num))
    end
end


--====backlight
wwtcas:GetBkl('sim/cockpit/electrical/cockpit_lights', 250)
wwtcas:GetLcdBkl("sim/cockpit2/switches/avionics_power_on", 200) -- 0~1
wwtcas:GetLedBkl("sim/cockpit2/switches/avionics_power_on", 200) -- 0~1
--[[
wwtcas:GetAtcFail('')
]] --
GlobalFrameLoopManager:add(function()
    wwtcas:SetBkl()
    wwtcas:SetLcdBkl()
    wwtcas:SetLedBkl()
    xpdr_update()
end)
