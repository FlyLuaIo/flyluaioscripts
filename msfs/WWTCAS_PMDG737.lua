-- *****************************************************************
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-09-11
-- *****************************************************************
if ilua_require_pmdg_737() then return end

-- Do not remove below lines: hardware detection
local wwtcas = com.sim.qm.Wwtcas.Open()
if not wwtcas then return end
-- Do not remove above lines: hardware detection

uluaLog('Wwtcas for PMDG 737')

-- XDRD IDENT
wwtcas:CfgRpn(9, "(>K:XPNDR_IDENT_ON)")

-- XPDR STBY/AUTO/ON
local xpdr_tara = QmdevPosSwitchInit("(L:switch_800_73X, number)", 10, "80007 (>K:ROTOR_BRAKE)",
    "80008 (>K:ROTOR_BRAKE)", 300)
wwtcas:CfgPSw(10, xpdr_tara, 0)
wwtcas:CfgPSw(11, xpdr_tara, 30)

-- ALT RPTG OFF/ON
wwtcas:CfgPSw(15, xpdr_tara, 10)


-- TCAS STBY/TA/TARA
wwtcas:CfgPSw(21, xpdr_tara, 0)
wwtcas:CfgPSw(22, xpdr_tara, 30)
wwtcas:CfgPSw(23, xpdr_tara, 40)

-- ===========================================================
-- Read data
-- =====XPDR
-- Expert: FBW own logic
-- @ AUTO CLR = false
-- @ TIMEOUT = 2s
wwtcas:FakeXpdrInit(false, 2)
local b_xpdr_act = iDataRef:New("(A:TRANSPONDER CODE:1, Number)")
local function xpdr_update()
    if wwtcas:FakeXpdrIsTimeOut() or b_xpdr_act:ChangedUpdate() then
        -- wwtcas:FakeXpdrCopy()
        wwtcas:FakeXpdrClear()
    end
    local xpdr_stby, stdr_num = wwtcas:FakeXpdrGet()
    if stdr_num == 0 then
        wwtcas:setLcdText(wwtcas:EncXpdr(b_xpdr_act:Get()))
    elseif stdr_num == 4 then
        local bc016 = wwtcas:XpdrBc016(xpdr_stby)
        uluaWriteCmd(tostring(bc016) .. " (>K:XPNDR_SET)")
    else
        wwtcas:setLcdText(wwtcas:EncXpdr(xpdr_stby, stdr_num))
    end
end

wwtcas:GetBkl("(L:BL_Pedestal)", 200)                    -- 0~1
wwtcas:GetLcdBkl("(A:CIRCUIT AVIONICS ON,Bool)", 200)   -- 0~1
wwtcas:GetLedBkl("(A:CIRCUIT AVIONICS ON,Bool)", 200)   -- 0~1
--[[
wwtcas:GetAtcFail('')
]] --
GlobalFrameLoopManager:add(function()
    wwtcas:SetBkl()
    wwtcas:SetLcdBkl()
    wwtcas:SetLedBkl()
    xpdr_update()
end)
