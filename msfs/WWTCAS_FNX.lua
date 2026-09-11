-- *****************************************************************
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-09-12
-- *****************************************************************
if ilua_require_fenix_a320() then return end

-- Do not remove below lines: hardware detection
local wwtcas = com.sim.qm.Wwtcas.Open()
if not wwtcas then return end
-- Do not remove above lines: hardware detection

uluaLog('Wwtcas for Fenix A3XX')

-- XPRD ATC Keypad
wwtcas:CfgRpn(0, "1 (>L:S_PED_ATC_1)", "0 (>L:S_PED_ATC_1)")
wwtcas:CfgRpn(1, "1 (>L:S_PED_ATC_2)", "0 (>L:S_PED_ATC_2)")
wwtcas:CfgRpn(2, "1 (>L:S_PED_ATC_3)", "0 (>L:S_PED_ATC_3)")
wwtcas:CfgRpn(3, "1 (>L:S_PED_ATC_4)", "0 (>L:S_PED_ATC_4)")
wwtcas:CfgRpn(4, "1 (>L:S_PED_ATC_5)", "0 (>L:S_PED_ATC_5)")
wwtcas:CfgRpn(5, "1 (>L:S_PED_ATC_6)", "0 (>L:S_PED_ATC_6)")
wwtcas:CfgRpn(6, "1 (>L:S_PED_ATC_7)", "0 (>L:S_PED_ATC_7)")
wwtcas:CfgRpn(7, "1 (>L:S_PED_ATC_0)", "0 (>L:S_PED_ATC_0)")
wwtcas:CfgRpn(8, "1 (>L:S_PED_ATC_CLR)", "0 (>L:S_PED_ATC_CLR)")

-- XDRD IDENT
wwtcas:CfgRpn(9, "1 (>L:S_XPDR_IDENT)", "0 (>L:S_XPDR_IDENT)")

-- XPDR STBY/AUTO/ON
wwtcas:CfgRpn(10, "0 (>L:S_XPDR_OPERATION)")
wwtcas:CfgRpn(11, "1 (>L:S_XPDR_OPERATION)")
wwtcas:CfgRpn(12, "2 (>L:S_XPDR_OPERATION)")

-- ATC SYS 1/2
wwtcas:CfgRpn(13, "0 (>L:S_XPDR_ATC)")
wwtcas:CfgRpn(14, "1 (>L:S_XPDR_ATC)")

-- ALT RPTG OFF/ON
wwtcas:CfgRpn(15, "0 (>L:S_XPDR_ALTREPORTING)")
wwtcas:CfgRpn(16, "1 (>L:S_XPDR_ALTREPORTING)")

-- TCAS THRT/ALL/ABV/BLW
wwtcas:CfgRpn(17, "0 (>L:S_TCAS_RANGE)")
wwtcas:CfgRpn(18, "1 (>L:S_TCAS_RANGE)")
wwtcas:CfgRpn(19, "2 (>L:S_TCAS_RANGE)")
wwtcas:CfgRpn(20, "3 (>L:S_TCAS_RANGE)")

-- TCAS STBY/TA/TARA
wwtcas:CfgRpn(21, "0 (>L:S_XPDR_MODE)")
wwtcas:CfgRpn(22, "1 (>L:S_XPDR_MODE)")
wwtcas:CfgRpn(23, "2 (>L:S_XPDR_MODE)")

-- ===========================================================
-- Read data

-- =====XPDR
-- Expert: Fenix own logic
local b_xpdr_fail = iDataRef:New("(L:I_XPDR_FAIL)")
local b_xpdr_power1 = iDataRef:New("(L:I_XPDR_ATC_1)")
local b_xpdr_power2 = iDataRef:New("(L:I_XPDR_ATC_2)")

-- XPDR
local b_xpdr_c_num = iDataRef:New("(L:N_PED_XPDR_CHAR_DISPLAYED)")
local b_xpdr_act = iDataRef:New("(L:N_FREQ_XPDR_SELECTED)")
local b_xpdr_stby = iDataRef:New("(L:N_FREQ_STANDBY_XPDR_SELECTED)")

local dr_test = iDataRef:New("(L:S_OH_IN_LT_ANN_LT)") -- 0: DIM 1: BRT 2: test mode
local function xpdr_update()
    -- if b_xpdr_fail:Get() == 1 or (b_xpdr_power1:Get() == 0 and b_xpdr_power2:Get() == 0) then
    --     wwtcas:setLcdText()
    --     return
    -- end
    if b_xpdr_power1:Get() == 0 and b_xpdr_power2:Get() == 0 then
        wwtcas:setLcdText()
        return
    end
    local stdr_num = b_xpdr_c_num:Get()

    local code
    if stdr_num == 4 then
        code = b_xpdr_act:Get()
    else
        code = b_xpdr_stby:Get()
    end
    if dr_test:Get() == 2 then
        wwtcas:setLcdText('8888')
    else
        wwtcas:setLcdText(wwtcas:EncXpdr(code, stdr_num))
    end
end

wwtcas:GetBkl("(L:N_PED_LIGHTING_PEDESTAL)", 125) -- 0~2
wwtcas:GetLcdBkl("(L:I_XPDR_ATC_1)", 200)         -- 0~1
wwtcas:GetLedBkl("(L:I_XPDR_ATC_1)", 200)         -- 0~1
wwtcas:GetAtcFail("(L:I_XPDR_FAIL)")



GlobalFrameLoopManager:add(function()
    wwtcas:SetBkl()
    wwtcas:SetLcdBkl()
    wwtcas:SetLedBkl()
    wwtcas:SetAtcFail()
    xpdr_update()
end)
