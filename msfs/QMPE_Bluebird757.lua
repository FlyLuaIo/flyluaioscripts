-- *****************************************************************
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-10-26
-- *****************************************************************
-- QMPE x Bluebird Simulations B757 (MSFS 2020/2024)
-- LVar source: qmdevother/docs/bb757.html
--   B757_PED_NAV_1/2/3_* (radio tuning panels), B757_VHF_L/C/R_*_INC,
--   B757_VOR_*/B757_ILS_*/B757_ADF_*_INC, B757_PED_COMHEAD_*_SWAP_BUTTON,
--   B757_PED_TCAS_*, B757_PED_AUDIO_1_* (captain audio panel), BBS_RTP_*_LIGHTS
--
-- QMPE is a pedestal radio unit: left RMP + right RMP + ATC/XPDR keypad + ACP.
-- The B757 pedestal has three radio tuning panels (RTP 1/2/3) and three VHFs
-- (L/C/R), so:
--   * RMP1 (left unit)  -> RTP 1 (captain), VHF L / VHF C select
--   * RMP2 (right unit) -> RTP 3 (first officer), VHF R / VHF C select
--   * the knob step request goes to the radio that this RTP currently shows,
--     read from the model bit flags in BBS_RTP_L_LIGHTS / BBS_RTP_R_LIGHTS
--     (2 = VHF L, 4 = VHF C, 8 = VHF R, 16 = HF L, 32 = AM, 64 = HF R)
--   * ACP buttons -> B757_PED_AUDIO_1 receiver lights / PTT
--   * XPDR keypad -> B757_PED_TCAS_* mode keys, squawk via (>K:XPNDR_SET)
-- Keys with no B757 counterpart are listed unbound at the end of the binding
-- section.
--
if ilua_require_bluebird_757() then return end

-- Do not remove below lines: hardware detection
local qmpe = com.sim.qm.Qmpe.Open()
if not qmpe then return end
-- Do not remove above lines: hardware detection

uluaLog("QMPE of Bluebird B757")

-- ===========================================================
-- helpers

-- which radio each RTP is currently displaying (bit flags from the model)
g_bb757_rtp1 = iDataRef:New("(L:BBS_RTP_L_LIGHTS)")
g_bb757_rtp3 = iDataRef:New("(L:BBS_RTP_R_LIGHTS)")

-- per radio: { bit flag, WHOLE_INC LVar, FRAC_INC LVar }
local RTP_VHF = {
    { 2, "B757_VHF_L_WHOLE_INC", "B757_VHF_L_FRAC_INC" },
    { 4, "B757_VHF_C_WHOLE_INC", "B757_VHF_C_FRAC_INC" },
    { 8, "B757_VHF_R_WHOLE_INC", "B757_VHF_R_FRAC_INC" },
}

local function bb757_bit(f, bit)
    return f == bit
end

-- one knob detent: dir = +1/-1, whole = true for the 1 MHz knob
-- fallback = index in RTP_VHF used when the RTP shows a radio that has no
-- INC LVar (HF L / HF R / AM)
function qmpe_bluebird757_rtp_step(flagdr, dir, whole, fallback)
    local f = flagdr:Get()
    for _, e in ipairs(RTP_VHF) do
        if bb757_bit(f, e[1]) then
            uluaWriteCmd(dir .. " (>L:" .. (whole and e[2] or e[3]) .. ")")
            return
        end
    end
    local e = RTP_VHF[fallback]
    uluaWriteCmd(dir .. " (>L:" .. (whole and e[2] or e[3]) .. ")")
end

-- ===========================================================
-- button binding

-- RMP1 -> RTP 1 (captain)
---- inner knob: 25 kHz step
qmpe:CfgFc(0, "qmpe_bluebird757_rtp_step(g_bb757_rtp1, -1, false, 1)")
qmpe:CfgFc(1, "qmpe_bluebird757_rtp_step(g_bb757_rtp1, 1, false, 1)")
---- outer knob: 1 MHz step
qmpe:CfgFc(2, "qmpe_bluebird757_rtp_step(g_bb757_rtp1, -1, true, 1)")
qmpe:CfgFc(3, "qmpe_bluebird757_rtp_step(g_bb757_rtp1, 1, true, 1)")
---- RTP 1 power (OFF button is a maintained pushbutton)
qmpe:CfgRpn(4, "(L:B757_PED_NAV_1_OFF_BUTTON) ! (>L:B757_PED_NAV_1_OFF_BUTTON)")
---- transfer / swap active and standby
qmpe:CfgRpn(5, "1 (>L:B757_PED_COMHEAD_1_SWAP_BUTTON)", "0 (>L:B757_PED_COMHEAD_1_SWAP_BUTTON)")
---- select radio shown on RTP 1
qmpe:CfgRpn(6, "1 (>L:B757_PED_NAV_1_VHFR_BUTTON)", "0 (>L:B757_PED_NAV_1_VHFR_BUTTON)") -- VHF R
qmpe:CfgRpn(7, "1 (>L:B757_PED_NAV_1_VHFL_BUTTON)", "0 (>L:B757_PED_NAV_1_VHFL_BUTTON)") -- VHF L

-- ACP (captain audio panel 1)
---- receiver select: the model names these MIC_xx_LIGHT, state 0/1
qmpe:CfgRpn(10, "(L:B757_PED_AUDIO_1_MIC_L_LIGHT) ! (>L:B757_PED_AUDIO_1_MIC_L_LIGHT)")   -- VHF L
qmpe:CfgRpn(11, "(L:B757_PED_AUDIO_1_MIC_C_LIGHT) ! (>L:B757_PED_AUDIO_1_MIC_C_LIGHT)")   -- VHF C
qmpe:CfgRpn(12, "(L:B757_PED_AUDIO_1_MIC_R_LIGHT) ! (>L:B757_PED_AUDIO_1_MIC_R_LIGHT)")   -- VHF R
qmpe:CfgRpn(13, "(L:B757_PED_AUDIO_1_MIC_INT_LIGHT) ! (>L:B757_PED_AUDIO_1_MIC_INT_LIGHT)") -- INT
qmpe:CfgRpn(14, "(L:B757_PED_AUDIO_1_MIC_PA_LIGHT) ! (>L:B757_PED_AUDIO_1_MIC_PA_LIGHT)")  -- PA
---- PTT: hold to transmit
qmpe:CfgRpn(15, "1 (>L:B757_PED_AUDIO_1_PTT_SWITCH)", "0 (>L:B757_PED_AUDIO_1_PTT_SWITCH)")
---- boom / oxygen mask selector
qmpe:CfgRpn(24, "(L:B757_PED_AUDIO_1_BOOM_OXY_SWITCH) ! (>L:B757_PED_AUDIO_1_BOOM_OXY_SWITCH)")
---- voice / range switch 0:VOICE 1:BOTH 2:RANGE
qmpe:CfgRpn(36, "0 (>L:B757_PED_AUDIO_1_VOICE_RANGE_SWITCH)")
qmpe:CfgRpn(80, "1 (>L:B757_PED_AUDIO_1_VOICE_RANGE_SWITCH)")
qmpe:CfgRpn(37, "2 (>L:B757_PED_AUDIO_1_VOICE_RANGE_SWITCH)")

-- nav aid tuning on the four free ACP volume knobs
-- (the B757 model exposes no audio volume LVars, so these knobs had nothing
--  to drive; VOR L and ILS get both a 1 MHz and a 50 kHz knob)
qmpe:CfgRpn(16, "-1 (>L:B757_ILS_FREQ_WHOLE_INC)")     -- ILS whole
qmpe:CfgRpn(17, "1 (>L:B757_ILS_FREQ_WHOLE_INC)")
qmpe:CfgRpn(18, "-1 (>L:B757_ILS_FREQ_FRAC_INC)")      -- ILS frac
qmpe:CfgRpn(19, "1 (>L:B757_ILS_FREQ_FRAC_INC)")
qmpe:CfgRpn(20, "-1 (>L:B757_VOR_L_FREQ_WHOLE_INC)")   -- VOR L whole
qmpe:CfgRpn(21, "1 (>L:B757_VOR_L_FREQ_WHOLE_INC)")
qmpe:CfgRpn(22, "-1 (>L:B757_VOR_L_FREQ_FRAC_INC)")    -- VOR L frac
qmpe:CfgRpn(23, "1 (>L:B757_VOR_L_FREQ_FRAC_INC)")
qmpe:CfgRpn(8, "-1 (>L:B757_VOR_R_FREQ_WHOLE_INC)")    -- VOR R whole
qmpe:CfgRpn(9, "1 (>L:B757_VOR_R_FREQ_WHOLE_INC)")

-- RMP2 -> RTP 3 (first officer)
---- inner knob: 25 kHz step
qmpe:CfgFc(28, "qmpe_bluebird757_rtp_step(g_bb757_rtp3, -1, false, 3)")
qmpe:CfgFc(29, "qmpe_bluebird757_rtp_step(g_bb757_rtp3, 1, false, 3)")
---- outer knob: 1 MHz step
qmpe:CfgFc(30, "qmpe_bluebird757_rtp_step(g_bb757_rtp3, -1, true, 3)")
qmpe:CfgFc(31, "qmpe_bluebird757_rtp_step(g_bb757_rtp3, 1, true, 3)")
---- RTP 3 power
qmpe:CfgRpn(32, "(L:B757_PED_NAV_3_OFF_BUTTON) ! (>L:B757_PED_NAV_3_OFF_BUTTON)")
---- transfer / swap active and standby
qmpe:CfgRpn(33, "1 (>L:B757_PED_COMHEAD_3_SWAP_BUTTON)", "0 (>L:B757_PED_COMHEAD_3_SWAP_BUTTON)")
---- select radio shown on RTP 3
qmpe:CfgRpn(34, "1 (>L:B757_PED_NAV_2_VHFL_BUTTON)", "0 (>L:B757_PED_NAV_2_VHFL_BUTTON)") -- VHF L
qmpe:CfgRpn(35, "1 (>L:B757_PED_NAV_2_VHFR_BUTTON)", "0 (>L:B757_PED_NAV_2_VHFR_BUTTON)") -- VHF R

-- ATC / TCAS panel
---- TCAS mode knob 0:STBY 1:ALT RPTG OFF 2:XPNDR 3:TA ONLY 4:TA/RA
qmpe:CfgRpn(42, "0 (>L:B757_PED_TCAS_MODE_KNOB)")
qmpe:CfgRpn(43, "1 (>L:B757_PED_TCAS_MODE_KNOB)")
qmpe:CfgRpn(40, "2 (>L:B757_PED_TCAS_MODE_KNOB)")
qmpe:CfgRpn(82, "2 (>L:B757_PED_TCAS_MODE_KNOB)")
qmpe:CfgRpn(41, "3 (>L:B757_PED_TCAS_MODE_KNOB)")
qmpe:CfgRpn(81, "4 (>L:B757_PED_TCAS_MODE_KNOB)")
---- transponder 1 / transponder 2 select
qmpe:CfgRpn(38, "0 (>L:B757_PED_TCAS_XPNDR_SWITCH)")
qmpe:CfgRpn(39, "1 (>L:B757_PED_TCAS_XPNDR_SWITCH)")
---- mode knob test push
qmpe:CfgRpn(45, "1 (>L:B757_PED_TCAS_MODE_KNOB_TEST)", "0 (>L:B757_PED_TCAS_MODE_KNOB_TEST)")
---- IDENT
qmpe:CfgRpn(64, "1 (>L:B757_PED_TCAS_IDENT_SWITCH)", "0 (>L:B757_PED_TCAS_IDENT_SWITCH)")

-- integ light brightness (main panel backlight knob, 0~20)
qmpe:CfgRpn(46, "(L:B757_MAIN_PANEL_BACKLIGHT_KNOB, number) 1 - 0 max (>L:B757_MAIN_PANEL_BACKLIGHT_KNOB, number)")
qmpe:CfgRpn(47, "(L:B757_MAIN_PANEL_BACKLIGHT_KNOB, number) 1 + 20 min (>L:B757_MAIN_PANEL_BACKLIGHT_KNOB, number)")

-- EICAS / recall buttons
qmpe:CfgRpn(44, "1 (>L:B757_MAIN_RECALL_BUTTON)", "0 (>L:B757_MAIN_RECALL_BUTTON)")        -- CAUT key -> RECALL
qmpe:CfgRpn(79, "1 (>L:B757_EICAS_MAX_IND_BUTTON)", "0 (>L:B757_EICAS_MAX_IND_BUTTON)")    -- WARN key -> MAX IND reset
qmpe:CfgRpn(48, "1 (>L:BBS_EICAS_ENGINE_PAGE_REQUEST)", "0 (>L:BBS_EICAS_ENGINE_PAGE_REQUEST)")
qmpe:CfgRpn(61, "1 (>L:BBS_EICAS_STATUS_PAGE_REQUEST)", "0 (>L:BBS_EICAS_STATUS_PAGE_REQUEST)")

-- chronograph push
qmpe:CfgRpn(65, "1 (>L:B757_CHRONO_BUTTON_PRESS)", "0 (>L:B757_CHRONO_BUTTON_PRESS)")

-- autobrake: LO/MED/MAX keys set the 757 selectors 1/2/MAX AUTO
qmpe:CfgRpn(75, "3 (>L:BBS_AUTOBRAKE_KNOB)") -- selector 1
qmpe:CfgRpn(76, "4 (>L:BBS_AUTOBRAKE_KNOB)") -- selector 2
qmpe:CfgRpn(77, "7 (>L:BBS_AUTOBRAKE_KNOB)") -- MAX AUTO

-- ===========================================================
-- not bound on this profile
--   25/26/27 (ACP TX keys): the B757 model exposes no per-channel mic
--     selector, only the receiver lights and one PTT
--   49..60 (ECAM page keys): the B757 has no ECAM
--   62 (CLR key), 63 (TERR key), 78 (TO CONFIG key): no LVar on the B757
--   ADF L/R tuning: no free knob (inner/middle/outer x 2 would need 6 encoders)

-- ===========================================================
-- Read data

-- =====XPDR
qmpe:GetXpdr("(A:TRANSPONDER CODE:1, Number)")
-- no auto clear, 2 s idle timeout
qmpe:FakeXpdrInit(false, 2)
local b_xpdr_act = iDataRef:New("(A:TRANSPONDER CODE:1, Number)")
local xpdr_sent = -1
local xpdr_shown = -1
local function xpdr_update()
    if qmpe:FakeXpdrIsTimeOut() or b_xpdr_act:ChangedUpdate() then
        qmpe:FakeXpdrClear()
        xpdr_sent = -1
    end
    local xpdr_stby, stdr_num = qmpe:FakeXpdrGet()
    local shown
    if stdr_num == 0 then
        shown = qmpe:EncXpdr(b_xpdr_act:Get())
    elseif stdr_num == 4 then
        shown = qmpe:EncXpdr(xpdr_stby)
        -- send the squawk once per entry instead of every frame
        if xpdr_sent ~= xpdr_stby then
            xpdr_sent = xpdr_stby
            local bc016 = qmpe:XpdrBc016(xpdr_stby)
            uluaWriteCmd(tostring(bc016) .. " (>K:XPNDR_SET)")
        end
    else
        shown = qmpe:EncXpdr(xpdr_stby, stdr_num)
    end
    -- explicit SetXpdr() always writes the HID, so only call it on change
    if shown ~= xpdr_shown then
        xpdr_shown = shown
        qmpe:SetXpdr(shown)
    end
end

-- =====RMP mode leds (which radio each RTP shows)
qmpe:GetR1vhf1("(L:BBS_RTP_L_LIGHTS) 2 ==")
qmpe:GetR1vhf2("(L:BBS_RTP_L_LIGHTS) 8 ==")
qmpe:GetR2vhf1("(L:BBS_RTP_R_LIGHTS) 2 ==")
qmpe:GetR2vhf2("(L:BBS_RTP_R_LIGHTS) 8 ==")

-- =====ACP (captain audio panel 1)
-- TX light: only the PTT state is exposed by the model
qmpe:GetSVhf1("(L:B757_PED_AUDIO_1_PTT_SWITCH)")
qmpe:GetSVhf2("0")
qmpe:GetSMech("0")
qmpe:GetSAtt("0")
qmpe:GetSPa("0")
-- CALL lights: the B757 audio panel has no per-channel call light
qmpe:GetCVhf1("0")
qmpe:GetCVhf2("0")
qmpe:GetCMech("0")
qmpe:GetCAtt("0")
-- RX lights
qmpe:GetRVhf1("(L:B757_PED_AUDIO_1_MIC_L_LIGHT)")
qmpe:GetRVhf2("(L:B757_PED_AUDIO_1_MIC_C_LIGHT)")
qmpe:GetRMech("(L:B757_PED_AUDIO_1_MIC_INT_LIGHT)")
qmpe:GetRAtt("(L:B757_PED_AUDIO_1_MIC_R_LIGHT)")
qmpe:GetRPa("(L:B757_PED_AUDIO_1_MIC_PA_LIGHT)")

-- =====ECAM row: the B757 has no ECAM, all channels stay dark
qmpe:GetEEng("0")
qmpe:GetEBleed("0")
qmpe:GetEPress("0")
qmpe:GetEElec("0")
qmpe:GetEHyd("0")
qmpe:GetEFuel("0")
qmpe:GetEFctl("0")
qmpe:GetEApu("0")
qmpe:GetECond("0")
qmpe:GetEDoor("0")
qmpe:GetEWheel("0")
qmpe:GetEClr("0")
qmpe:GetESts("0")

-- =====MISC
qmpe:GetWarn("(L:BBS_CA_MASTER_WARNING)")
qmpe:GetCaut("(L:BBS_CA_MASTER_CAUTION)")

qmpe:GetMsg("0")
qmpe:GetFail("(L:B757_PED_TCAS_XPNDR_FAIL_SWITCH)")
qmpe:GetLand("0")
qmpe:GetTerr("0")

-- autobrake selector 1 / 2 / MAX AUTO
qmpe:GetLo("(L:BBS_AUTOBRAKE_KNOB) 3 ==")
qmpe:GetMed("(L:BBS_AUTOBRAKE_KNOB) 4 ==")
qmpe:GetMax("(L:BBS_AUTOBRAKE_KNOB) 7 ==")

-- gear: green = down and locked lamp, amber = in transit
qmpe:GetLock1("(L:B757_MAIN_light_landingGear_L)")
qmpe:GetLock2("(L:B757_MAIN_light_landingGear_nose)")
qmpe:GetLock3("(L:B757_MAIN_light_landingGear_R)")
qmpe:GetUnlock1("(L:BBS757_MAIN_GEAR_LEFT) 5 > (L:BBS757_MAIN_GEAR_LEFT) 195 < and")
qmpe:GetUnlock2("(L:BBS757_MAIN_GEAR_NOSE) 5 > (L:BBS757_MAIN_GEAR_NOSE) 255 < and")
qmpe:GetUnlock3("(L:BBS757_MAIN_GEAR_RIGHT) 5 > (L:BBS757_MAIN_GEAR_RIGHT) 195 < and")

-- backlight: main panel backlight knob 0~20 -> 0~100
qmpe:GetBkl("(L:B757_MAIN_PANEL_BACKLIGHT_KNOB, number) 5 *", 1)

-- =====RMP radio data
-- driver display handles (OffRmp1/OffRmp2 blank these on power loss);
-- RMP1 defaults to VHF L (COM1), RMP2 to VHF R (COM3)
qmpe:GetRmp1("(A:COM ACTIVE FREQUENCY:1,KHz)", "(A:COM STANDBY FREQUENCY:1,KHz)")
qmpe:GetRmp2("(A:COM ACTIVE FREQUENCY:3,KHz)", "(A:COM STANDBY FREQUENCY:3,KHz)")

local dr_com1a = iDataRef:New("(A:COM ACTIVE FREQUENCY:1,KHz)")
local dr_com1s = iDataRef:New("(A:COM STANDBY FREQUENCY:1,KHz)")
local dr_com2a = iDataRef:New("(A:COM ACTIVE FREQUENCY:2,KHz)")
local dr_com2s = iDataRef:New("(A:COM STANDBY FREQUENCY:2,KHz)")
local dr_com3a = iDataRef:New("(A:COM ACTIVE FREQUENCY:3,KHz)")
local dr_com3s = iDataRef:New("(A:COM STANDBY FREQUENCY:3,KHz)")

local function bb757_rtp_radio(flagdr)
    local f = flagdr:Get()
    if bb757_bit(f, 4) then return 3 end
    if bb757_bit(f, 8) then return 2 end
    return 1
end

local function bb757_com_pair(sel)
    if sel == 2 then return dr_com2a, dr_com2s end
    if sel == 3 then return dr_com3a, dr_com3s end
    return dr_com1a, dr_com1s
end

-- only re-render the 7-seg display when the shown radio or the frequency changed
local rmp1_last = { sel = -1, a = -1, s = -1 }
local rmp3_last = { sel = -1, a = -1, s = -1 }

local function bb757_rmp_render(flagdr, last, setpair)
    local sel = bb757_rtp_radio(flagdr)
    local da, ds = bb757_com_pair(sel)
    local a, s = da:Get(), ds:Get()
    if sel ~= last.sel then
        last.sel = sel
        last.a, last.s = -1, -1
    end
    if math.abs(a - last.a) > 0.0005 or math.abs(s - last.s) > 0.0005 then
        last.a, last.s = a, s
        setpair(a, s)
    end
end

local function rmp1_update()
    bb757_rmp_render(g_bb757_rtp1, rmp1_last, function(a, s)
        qmpe:SetRmp1(a, s)
    end)
end

local function rmp3_update()
    bb757_rmp_render(g_bb757_rtp3, rmp3_last, function(a, s)
        qmpe:SetRmp2(a, s)
    end)
end

-- =====power / annunciator test
-- invalidate every LED dataref so the next update rewrites the whole panel
-- (needed after power loss and after the lamp test, otherwise the panel stays
--  dark/test-patterned because the Lua side values did not change)
local function bb757_fresh_leds()
    for k, v in pairs(qmpe) do
        if type(k) == "string" and k:match("^d_") and type(v) == "table" and v.Invalid ~= nil then
            v:Invalid(-1)
        end
    end
end

local dr_test = iDataRef:New("(L:OVHD_TEST_LTS)")
local dr_bat = iDataRef:New("(L:B757_OVHD_BATTERY_BUTTON)")
local dr_ext = iDataRef:New("(L:B757_OVHD_EXT_PWR_BUTTON_ON)")
local powered_last = -1
local state_test = -1

GlobalFrameLoopManager:add(function()
    -- cold and dark
    local powered = (dr_bat:Get() >= 1 or dr_ext:Get() >= 1) and 1 or 0
    if powered ~= powered_last then
        powered_last = powered
        if powered == 0 then
            qmpe:Off()
            state_test = -1
        else
            bb757_fresh_leds()
            qmpe:FreshBkl()
            qmpe:FreshXpdr()
            xpdr_shown = -1
        end
        -- force a full redraw of both 7-seg display pairs
        rmp1_last.sel, rmp3_last.sel = -1, -1
    end
    if powered == 0 then
        return
    end

    -- lamp test: all segments lit, hardware pattern
    if dr_test:ChangedUpdate() then
        state_test = dr_test:GetOld() -- after ChangedUpdate use GetOld only, never Get
        if state_test >= 1 then
            qmpe:SetBklMode(1)
            qmpe:SetTest()
        else
            qmpe:SetBklMode(0)
            qmpe:SetBklCtrl(0)
            uluaSet(idr_qmpe_hid_invalid, -1)
            bb757_fresh_leds()
            xpdr_shown = -1
            rmp1_last.sel, rmp3_last.sel = -1, -1
        end
    end
    if state_test >= 1 then
        return
    end

    -- data
    rmp1_update()
    rmp3_update()
    xpdr_update()

    -- leds
    qmpe:SetRmp()
    qmpe:SetAcp()
    qmpe:SetEcam()
    qmpe:SetMisc()
    qmpe:SetBkl()
end)
