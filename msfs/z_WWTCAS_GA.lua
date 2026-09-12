-- *****************************************************************
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-08-08_03_55_08UTC
-- *****************************************************************
if ilua_require_msfs() then
    return
end
-- Do not remove below lines: hardware detection
local wwtcas = com.sim.qm.Wwtcas.Open()
if not wwtcas then return end
-- Do not remove above lines: hardware detection

uluaLog('Wwtcas for GA')

-- XDRD IDENT
wwtcas:CfgRpn(9, "(>K:XPNDR_IDENT_ON)")


-- XPDR STBY/AUTO/ON
wwtcas:CfgRpn(10, "1 (>A:TRANSPONDER STATE:1, Enum)")
wwtcas:CfgRpn(11, "3 (>A:TRANSPONDER STATE:1, Enum)")
wwtcas:CfgRpn(12, "4 (>A:TRANSPONDER STATE:1, Enum)")


-- ALT RPTG OFF/ON
wwtcas:CfgRpn(15, "0 (>A:TRANSPONDER STATE:1, Enum)")
wwtcas:CfgRpn(16, "4 (>A:TRANSPONDER STATE:1, Enum)")


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

wwtcas:GetBkl("(A:LIGHT POTENTIOMETER:85, Percent)", 2) -- 0~100
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
