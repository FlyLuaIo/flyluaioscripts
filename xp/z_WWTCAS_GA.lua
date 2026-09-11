-- *****************************************************************
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-08-08_03_55_08UTC
-- *****************************************************************

-- Do not remove below lines: hardware detection
local wwtcas = com.sim.qm.Wwtcas.Open()
if not wwtcas then return end
-- Do not remove above lines: hardware detection

uluaLog('Wwtcas for GA')

-- XDRD IDENT
wwtcas:CfgCmd(9, 'sim/radios/transponder_ident')


-- ===========================================================
-- Read data
-- =====XPDR
-- Expert: Toliss own logic
local b_xpdr_power = iDataRef:New('sim/cockpit2/switches/avionics_power_on')

-- Expert: FBW own logic
-- @ AUTO CLR = false
-- @ TIMEOUT = 2s
wwtcas:FakeXpdrInit(false, 2)

local b_xpdr_act = iDataRef:New('sim/cockpit2/radios/actuators/transponder_code')

local function xpdr_update()
    if b_xpdr_power:Get() == 0 then
        wwtcas:setLcdText('    ')
        return
    end

    if wwtcas:FakeXpdrIsTimeOut() or b_xpdr_act:ChangedUpdate() then
        wwtcas:FakeXpdrClear()
    end
    local xpdr_stby, stdr_num = wwtcas:FakeXpdrGet()
    if stdr_num == 0 then
        -- force update
        wwtcas:setLcdText(wwtcas:EncXpdr(b_xpdr_act:Get(), 4))
    elseif stdr_num == 4 then
        b_xpdr_act:Set(xpdr_stby)
    else
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
