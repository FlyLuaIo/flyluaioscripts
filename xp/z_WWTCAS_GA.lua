-- *****************************************************************
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-08-08_03_55_08UTC
-- *****************************************************************

-- Do not remove below lines: hardware detection
local wwtcas = com.sim.qm.Wwtcas.Open()
if not wwtcas then return end
-- Do not remove above lines: hardware detection

uluaLog('Wwtcas for X-Plane GA')

-- XDRD IDENT
wwtcas:CfgCmd(9, 'sim/radios/transponder_ident')

-- XPDR STBY/AUTO/ON
wwtcas:CfgVal(10, 'sim/cockpit/radios/transponder_mode', 1)
wwtcas:CfgVal(11, 'sim/cockpit/radios/transponder_mode', 2)
wwtcas:CfgVal(12, 'sim/cockpit/radios/transponder_mode', 3)

-- ATC SYS 1/2
wwtcas:CfgVal(13, 'sim/cockpit2/radios/actuators/tcas_sys_select', 0)
wwtcas:CfgVal(14, 'sim/cockpit2/radios/actuators/tcas_sys_select', 1)


-- ALT RPTG OFF/ON
wwtcas:CfgVal(15, 'sim/cockpit/radios/transponder_mode', 0)
wwtcas:CfgVal(16, 'sim/cockpit/radios/transponder_mode', 3)

-- TCAS THRT/ALL/ABV/BLW
wwtcas:CfgVal(17, 'sim/cockpit2/radios/actuators/tcas_filter', 0)
wwtcas:CfgVal(18, 'sim/cockpit2/radios/actuators/tcas_filter', 1)
wwtcas:CfgVal(19, 'sim/cockpit2/radios/actuators/tcas_filter', 2)
wwtcas:CfgVal(20, 'sim/cockpit2/radios/actuators/tcas_filter', 3)

-- TCAS STBY/TA/TARA
wwtcas:CfgVal(21, 'sim/cockpit/radios/transponder_mode', 1)
wwtcas:CfgVal(22, 'sim/cockpit/radios/transponder_mode', 6)
wwtcas:CfgVal(23, 'sim/cockpit/radios/transponder_mode', 7)

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
