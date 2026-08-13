-- *****************************************************************
-- Don't modify this file
-- created by Wei Shuai <cpuwolf@gmail.com> 2024-05-25
-- *****************************************************************
-- USB write protection contract:
-- every uluaSet(idr_qfcu_hid_*) is a USB hardware write and must be protected:
--   1. dataref driven paths (no-arg Set*) -> wrapped in ChangedUpdate()
--   2. value driven paths (explicit args / one-shot power-off) -> Qfcu:_SetChg() write cache
-- *****************************************************************
local Qfcu = oop.class(com.sim.Qmdev)

function Qfcu:init()
    self.QmdevId = 7
    self.WCache = {}
    -- uluaLog('Qfcu:init'..self.QmdevId)
end

function Qfcu:Init()
    if ilua_hw_qfcu_absent(self.FastTurnsPerSecond) then
        return false
    end
    if ilua_hw_assigned_qfcu == 1 then
        return false
    end
    ilua_hw_assigned_qfcu = 1
    _G.qfcu_dev = self
    return true
end

function Qfcu.Open(...)
    return com.sim.Qmdev.Open(Qfcu, ...)
end

-- Output side write cache: skip USB write when value unchanged.
function Qfcu:_SetChg(key, idr, val)
    if self.WCache[key] ~= val then
        self.WCache[key] = val
        uluaSet(idr, val)
    end
end

-- ========================= Spd
-- IAS Digi: iasmode 1~6 (dashed/managed/mach combinations)
function Qfcu:GetSpd(d_air, d_dash, d_mach, d_mgd)
    self.d_spd = iDataRef:New(d_air)
    self.d_spd_dash = iDataRef:New(d_dash)
    self.d_spd_mach = iDataRef:New(d_mach)
    self.d_spd_mgd = iDataRef:New(d_mgd)
end

function Qfcu:SetSpd()
    -- evaluate all sources first (no or-chain short-circuit)
    local c1 = self.d_spd:ChangedUpdate()
    local c2 = self.d_spd_dash:ChangedUpdate()
    local c3 = self.d_spd_mach:ChangedUpdate()
    local c4 = self.d_spd_mgd:ChangedUpdate()
    if c1 or c2 or c3 or c4 then
        local air = self.d_spd:GetOld()
        local dash = self.d_spd_dash:GetOld()
        local mach = self.d_spd_mach:GetOldBit()
        local mgd = self.d_spd_mgd:GetOldBit()
        if dash == 1 then
            self:_SetChg('iasmode', idr_qfcu_hid_iasmode, mach == 1 and 4 or 2)
        elseif mgd == 1 then
            if mach == 1 then
                self:_SetChg('iasval', idr_qfcu_hid_iasval_f, air)
                self:_SetChg('iasmode', idr_qfcu_hid_iasmode, 6)
            else
                self:_SetChg('iasmode', idr_qfcu_hid_iasmode, 5)
                self:_SetChg('iasval', idr_qfcu_hid_iasval_i, math.floor(air + 0.5))
            end
        else
            if mach == 1 then
                self:_SetChg('iasval', idr_qfcu_hid_iasval_f, air)
                self:_SetChg('iasmode', idr_qfcu_hid_iasmode, 3)
            else
                self:_SetChg('iasmode', idr_qfcu_hid_iasmode, 1)
                self:_SetChg('iasval', idr_qfcu_hid_iasval_i, math.floor(air + 0.5))
            end
        end
    end
end

-- ========================= Hdg
-- HDG Digi: hdgmode 1/2/3 (dashed/managed)
function Qfcu:GetHdg(d_hdg, d_dash, d_mgd)
    self.d_hdg = iDataRef:New(d_hdg)
    self.d_hdg_dash = iDataRef:New(d_dash)
    self.d_hdg_mgd = iDataRef:New(d_mgd)
end

function Qfcu:SetHdg()
    local c1 = self.d_hdg:ChangedUpdate()
    local c2 = self.d_hdg_dash:ChangedUpdate()
    local c3 = self.d_hdg_mgd:ChangedUpdate()
    if c1 or c2 or c3 then
        local dash = self.d_hdg_dash:Get()
        local mgd = self.d_hdg_mgd:Get()
        if dash == 1 then
            self:_SetChg('hdgmode', idr_qfcu_hid_hdgmode, 2)
        else
            self:_SetChg('hdgval', idr_qfcu_hid_hdgval_i, self.d_hdg:Get() % 360)
            self:_SetChg('hdgmode', idr_qfcu_hid_hdgmode, mgd == 1 and 3 or 1)
        end
    end
end

-- ========================= Vs
-- VS/TRK Digi: vsmode / vs_trkmode + invalid channel
function Qfcu:GetVs(d_vs, d_trk, d_dash)
    self.d_vs = iDataRef:New(d_vs)
    self.d_vs_trk = iDataRef:New(d_trk)
    self.d_vs_dash = iDataRef:New(d_dash)
end

function Qfcu:SetVs()
    local c1 = self.d_vs:ChangedUpdate()
    local c2 = self.d_vs_trk:ChangedUpdate()
    local c3 = self.d_vs_dash:ChangedUpdate()
    if c1 or c2 or c3 then
        local vs = self.d_vs:Get()
        local trk = self.d_vs_trk:Get()
        local dash = self.d_vs_dash:Get()
        if trk == 1 then
            if dash == 1 then
                self:_SetChg('vstrkmode', idr_qfcu_hid_vs_trkmode, 2)
            else
                self:_SetChg('vstrkval', idr_qfcu_hid_vs_trkval_i, math.abs(vs))
                self:_SetChg('vstrkmode', idr_qfcu_hid_vs_trkmode, vs < 0 and 3 or 1)
            end
            self:_SetChg('invalid', idr_qfcu_hid_invalid, 4)
        else
            if dash == 1 then
                self:_SetChg('vsmode', idr_qfcu_hid_vsmode, 2)
            else
                self:_SetChg('vsval', idr_qfcu_hid_vsval_i, math.abs(vs))
                self:_SetChg('vsmode', idr_qfcu_hid_vsmode, vs < 0 and 3 or 1)
            end
            self:_SetChg('invalid', idr_qfcu_hid_invalid, 3)
        end
    end
end

-- ========================= Alt
-- Alt
function Qfcu:GetAlt(dpath, d_mgdpath)
    self.d_alt = iDataRef:New(dpath)
    self.d_mgd = iDataRef:New(d_mgdpath)
end

function Qfcu:_SetAlt(dot, val)
    if val > 0 then
        self:_SetChg('altval', idr_qfcu_hid_altval_i, val)
        self:_SetChg('altmode', idr_qfcu_hid_altmode, dot > 0 and 2 or 1)
    else
        self:_SetChg('altmode', idr_qfcu_hid_altmode, 0)
    end
end

-- SetAlt(dot)       : dataref driven, ChangedUpdate protected
-- SetAlt(dot, val)  : value driven, write cache protected
function Qfcu:SetAlt(val)
    if val == nil then
        if self.d_alt:ChangedUpdate() or self.d_mgd:ChangedUpdate() then
            self:_SetAlt(self.d_mgd:GetOldBit(), self.d_alt:GetOld())
        end
    else
        self:_SetAlt(self.d_mgd:GetBit(), val)
    end
end

function Qfcu:FreshAlt()
    self.d_alt:Invalid(-1000000)
end

-- ======== L EFIS
-- Baro sources for no-arg SetLBaro()
function Qfcu:GetLBaro(d_baro, d_unit, d_std)
    self.d_lbaro = iDataRef:New(d_baro)
    self.d_lbaro_unit = iDataRef:New(d_unit)
    self.d_lbaro_std = iDataRef:New(d_std)
end

-- ======== L EFIS
-- Baro Digi IN/HPA/STD = 1/2/3
-- SetLBaro()        : dataref driven, ChangedUpdate protected
-- SetLBaro(mode,val): value driven, write cache protected
function Qfcu:SetLBaro(mode, val)
    if mode == nil then
        local c1 = self.d_lbaro:ChangedUpdate()
        local c2 = self.d_lbaro_unit:ChangedUpdate()
        local c3 = self.d_lbaro_std:ChangedUpdate()
        if c1 or c2 or c3 then
            if self.d_lbaro_std:Get() == 1 then
                self:SetLBaro(3)
            elseif self.d_lbaro_unit:Get() == 1 then -- hPa mode
                self:SetLBaro(2, math.floor(self.d_lbaro:Get() * 33.8638895 + 0.5))
            else
                self:SetLBaro(1, math.floor(self.d_lbaro:Get() * 100 + 0.5))
            end
        end
        return
    end
    if mode == 1 or mode == 2 then
        self:_SetChg('lefisval', idr_qfcu_hid_lefisval_i, val)
    end
    self:_SetChg('lefismode', idr_qfcu_hid_lefismode, mode)
end

-- ======== R EFIS
-- Baro sources for no-arg SetRBaro()
function Qfcu:GetRBaro(d_baro, d_unit, d_std)
    self.d_rbaro = iDataRef:New(d_baro)
    self.d_rbaro_unit = iDataRef:New(d_unit)
    self.d_rbaro_std = iDataRef:New(d_std)
end

-- ======== R EFIS
-- Baro Digi IN/HPA/STD = 1/2/3
-- SetRBaro()        : dataref driven, ChangedUpdate protected
-- SetRBaro(mode,val): value driven, write cache protected
function Qfcu:SetRBaro(mode, val)
    if mode == nil then
        local c1 = self.d_rbaro:ChangedUpdate()
        local c2 = self.d_rbaro_unit:ChangedUpdate()
        local c3 = self.d_rbaro_std:ChangedUpdate()
        if c1 or c2 or c3 then
            if self.d_rbaro_std:Get() == 1 then
                self:SetRBaro(3)
            elseif self.d_rbaro_unit:Get() == 1 then -- hPa mode
                self:SetRBaro(2, math.floor(self.d_rbaro:Get() * 33.8638895 + 0.5))
            else
                self:SetRBaro(1, math.floor(self.d_rbaro:Get() * 100 + 0.5))
            end
        end
        return
    end
    if mode == 1 or mode == 2 then
        self:_SetChg('refisval', idr_qfcu_hid_refisval_i, val)
    end
    self:_SetChg('refismode', idr_qfcu_hid_refismode, mode)
end

-- ========================= Backlight
-- Panel backlight + display brightness
function Qfcu:GetBkl(d_light, d_disp)
    self.d_light = iDataRef:New(d_light)
    self.d_disp = iDataRef:New(d_disp)
end

function Qfcu:SetBkl()
    local c1 = self.d_light:ChangedUpdate()
    local c2 = self.d_disp:ChangedUpdate()
    if c1 or c2 then
        self:_SetChg('brightval', idr_qfcu_hid_brightval_i, math.floor(self.d_light:Get() * self.MaxBrightness))
        self:_SetChg('dispbrightval', idr_qfcu_hid_dispbrightval_i, math.floor(self.d_disp:Get() * 100 / 25))
    end
end

-- Annunciator test mode -> indicator brightness
function Qfcu:GetBrt(d_test)
    self.d_test = iDataRef:New(d_test)
end

function Qfcu:SetBrt()
    if self.d_test:ChangedUpdate() then
        local test = self.d_test:Get()
        self:_SetChg('indbrightval', idr_qfcu_hid_indbrightval_i, test + 1)
        if test ~= 2 then
            self:SetInv(-1)
            self:FreshDigi()
        end
    end
end

-- Invalid channel (value driven, write cache protected)
function Qfcu:SetInv(val)
    self:_SetChg('invalid', idr_qfcu_hid_invalid, val)
end

-- Invalidate all registered display sources and clear write cache,
-- so next frame resends everything, then throttling resumes.
function Qfcu:FreshDigi()
    if self.d_spd then self.d_spd:Invalid(-1) end
    if self.d_hdg then self.d_hdg:Invalid(-1) end
    if self.d_alt then self.d_alt:Invalid(-1000000) end
    if self.d_vs_dash then self.d_vs_dash:Invalid(11) end
    if self.d_lbaro then self.d_lbaro:Invalid(-1) end
    if self.d_rbaro then self.d_rbaro:Invalid(-1) end
    self.WCache = {}
end

-- =========================Leds
-- ========
-- Leds Appr
function Qfcu:GetAppr(dpath, revert, base)
    self:GetBit(2, dpath, revert, base)
end

function Qfcu:SetAppr(valbase, val)
    self:SetBit(2, idr_qfcu_hid_ledsappr, valbase, val)
end

-- ========
-- Leds Exped
function Qfcu:GetExped(dpath, revert, base)
    self:GetBit(3, dpath, revert, base)
end

function Qfcu:SetExped(valbase, val)
    self:SetBit(3, idr_qfcu_hid_ledsexped, valbase, val)
end

-- ========
-- Leds Athr
function Qfcu:GetAthr(dpath, revert, base)
    self:GetBit(4, dpath, revert, base)
end

function Qfcu:SetAthr(valbase, val)
    self:SetBit(4, idr_qfcu_hid_ledsathr, valbase, val)
end

-- ========
-- Leds Ap2
function Qfcu:GetAp2(dpath, revert, base)
    self:GetBit(5, dpath, revert, base)
end

function Qfcu:SetAp2(valbase, val)
    self:SetBit(5, idr_qfcu_hid_ledsap2, valbase, val)
end

-- ========
-- Leds Ap1
function Qfcu:GetAp1(dpath, revert, base)
    self:GetBit(6, dpath, revert, base)
end

function Qfcu:SetAp1(valbase, val)
    self:SetBit(6, idr_qfcu_hid_ledsap1, valbase, val)
end

-- ========
-- Leds Loc
function Qfcu:GetLoc(dpath, revert, base)
    self:GetBit(7, dpath, revert, base)
end

function Qfcu:SetLoc(valbase, val)
    self:SetBit(7, idr_qfcu_hid_ledsloc, valbase, val)
end

-- ========
-- Leds mid part
function Qfcu:SetMidLeds()
    self:SetAp1()
    self:SetAp2()
    self:SetAthr()
    self:SetLoc()
    self:SetExped()
    self:SetAppr()
end

-- ========
-- Leds mid part
function Qfcu:FreshMidLeds()
    self:FreshBit(2)
    self:FreshBit(3)
    self:FreshBit(4)
    self:FreshBit(5)
    self:FreshBit(6)
    self:FreshBit(7)
end

-- ======== L EFIS
-- Leds LCstr
function Qfcu:GetLCstr(dpath, revert, base)
    self:GetBit(24, dpath, revert, base)
end

function Qfcu:SetLCstr(valbase, val)
    self:SetBit(24, idr_qfcu_hid_ledslcstr, valbase, val)
end

-- ======== L EFIS
-- Leds LWpt
function Qfcu:GetLWpt(dpath, revert, base)
    self:GetBit(25, dpath, revert, base)
end

function Qfcu:SetLWpt(valbase, val)
    self:SetBit(25, idr_qfcu_hid_ledslwpt, valbase, val)
end

-- ======== L EFIS
-- Leds LVord
function Qfcu:GetLVord(dpath, revert, base)
    self:GetBit(26, dpath, revert, base)
end

function Qfcu:SetLVord(valbase, val)
    self:SetBit(26, idr_qfcu_hid_ledslvord, valbase, val)
end

-- ======== L EFIS
-- Leds LNdb
function Qfcu:GetLNdb(dpath, revert, base)
    self:GetBit(27, dpath, revert, base)
end

function Qfcu:SetLNdb(valbase, val)
    self:SetBit(27, idr_qfcu_hid_ledslndb, valbase, val)
end

-- ======== L EFIS
-- Leds LArpt
function Qfcu:GetLArpt(dpath, revert, base)
    self:GetBit(28, dpath, revert, base)
end

function Qfcu:SetLArpt(valbase, val)
    self:SetBit(28, idr_qfcu_hid_ledslaprt, valbase, val)
end

-- ======== L EFIS
-- Leds LFd
function Qfcu:GetLFd(dpath, revert, base)
    self:GetBit(29, dpath, revert, base)
end

function Qfcu:SetLFd(valbase, val)
    self:SetBit(29, idr_qfcu_hid_ledslfd, valbase, val)
end

-- ======== L EFIS
-- Leds LIls
function Qfcu:GetLIls(dpath, revert, base)
    self:GetBit(30, dpath, revert, base)
end

function Qfcu:SetLIls(valbase, val)
    self:SetBit(30, idr_qfcu_hid_ledslls, valbase, val)
end

-- ========
-- Leds Left part
function Qfcu:SetLeftLeds()
    self:SetLCstr()
    self:SetLWpt()
    self:SetLVord()
    self:SetLNdb()
    self:SetLArpt()
    self:SetLFd()
    self:SetLIls()
end

-- ========
-- Leds Left part
function Qfcu:FreshLeftLeds()
    self:FreshBit(24)
    self:FreshBit(25)
    self:FreshBit(26)
    self:FreshBit(27)
    self:FreshBit(28)
    self:FreshBit(29)
    self:FreshBit(30)
end

-- ======== L EFIS
-- Baro Indicator QFE/QNH/OFF = 0/1/2
function Qfcu:SetLBaroMode(mode)
    if mode == 0 then
        self:_SetChg('ledslqfe', idr_qfcu_hid_ledslqfe, 1) -- qfe)
        self:_SetChg('ledslqhn', idr_qfcu_hid_ledslqhn, 0) -- qhn)
    elseif mode == 1 then
        self:_SetChg('ledslqfe', idr_qfcu_hid_ledslqfe, 0) -- qfe)
        self:_SetChg('ledslqhn', idr_qfcu_hid_ledslqhn, 1) -- qhn)
    elseif mode == 2 then
        self:_SetChg('ledslqfe', idr_qfcu_hid_ledslqfe, 0) -- qfe)
        self:_SetChg('ledslqhn', idr_qfcu_hid_ledslqhn, 0) -- qhn)
    end
end

-- ======== R EFIS
-- Leds RCstr
function Qfcu:GetRCstr(dpath, revert, base)
    self:GetBit(40, dpath, revert, base)
end

function Qfcu:SetRCstr(valbase, val)
    self:SetBit(40, idr_qfcu_hid_ledsrcstr, valbase, val)
end

-- ======== R EFIS
-- Leds RWpt
function Qfcu:GetRWpt(dpath, revert, base)
    self:GetBit(41, dpath, revert, base)
end

function Qfcu:SetRWpt(valbase, val)
    self:SetBit(41, idr_qfcu_hid_ledsrwpt, valbase, val)
end

-- ======== R EFIS
-- Leds RVord
function Qfcu:GetRVord(dpath, revert, base)
    self:GetBit(42, dpath, revert, base)
end

function Qfcu:SetRVord(valbase, val)
    self:SetBit(42, idr_qfcu_hid_ledsrvord, valbase, val)
end

-- ======== R EFIS
-- Leds RNdb
function Qfcu:GetRNdb(dpath, revert, base)
    self:GetBit(43, dpath, revert, base)
end

function Qfcu:SetRNdb(valbase, val)
    self:SetBit(43, idr_qfcu_hid_ledsrndb, valbase, val)
end

-- ======== R EFIS
-- Leds RArpt
function Qfcu:GetRArpt(dpath, revert, base)
    self:GetBit(44, dpath, revert, base)
end

function Qfcu:SetRArpt(valbase, val)
    self:SetBit(44, idr_qfcu_hid_ledsraprt, valbase, val)
end

-- ======== R EFIS
-- Leds RFd
function Qfcu:GetRFd(dpath, revert, base)
    self:GetBit(45, dpath, revert, base)
end

function Qfcu:SetRFd(valbase, val)
    self:SetBit(45, idr_qfcu_hid_ledsrfd, valbase, val)
end

-- ======== R EFIS
-- Leds RIls
function Qfcu:GetRIls(dpath, revert, base)
    self:GetBit(46, dpath, revert, base)
end

function Qfcu:SetRIls(valbase, val)
    self:SetBit(46, idr_qfcu_hid_ledsrls, valbase, val)
end

-- ========
-- Leds Right part
function Qfcu:SetRightLeds()
    self:SetRCstr()
    self:SetRWpt()
    self:SetRVord()
    self:SetRNdb()
    self:SetRArpt()
    self:SetRFd()
    self:SetRIls()
end

-- ========
-- Leds Right part
function Qfcu:FreshRightLeds()
    self:FreshBit(40)
    self:FreshBit(41)
    self:FreshBit(42)
    self:FreshBit(43)
    self:FreshBit(44)
    self:FreshBit(45)
    self:FreshBit(46)
end

-- ======== R EFIS
-- Baro Indicator QFE/QNH/OFF = 0/1/2
function Qfcu:SetRBaroMode(mode)
    if mode == 0 then
        self:_SetChg('ledsrqfe', idr_qfcu_hid_ledsrqfe, 1) -- qfe)
        self:_SetChg('ledsrqhn', idr_qfcu_hid_ledsrqhn, 0) -- qhn)
    elseif mode == 1 then
        self:_SetChg('ledsrqfe', idr_qfcu_hid_ledsrqfe, 0) -- qfe)
        self:_SetChg('ledsrqhn', idr_qfcu_hid_ledsrqhn, 1) -- qhn)
    elseif mode == 2 then
        self:_SetChg('ledsrqfe', idr_qfcu_hid_ledsrqfe, 0) -- qfe)
        self:_SetChg('ledsrqhn', idr_qfcu_hid_ledsrqhn, 0) -- qhn)
    end
end

-- ========================= Power off one-shots
-- timer callback string target; routed through instance write cache
function QFCU_Off()
    if _G.qfcu_dev ~= nil then
        _G.qfcu_dev:_SetChg('indbrightval', idr_qfcu_hid_indbrightval_i, 0)
    end
end

function Qfcu:SetDigiBrtOff()
    self:_SetChg('brightval', idr_qfcu_hid_brightval_i, 0)
    self:_SetChg('indbrightval', idr_qfcu_hid_indbrightval_i, 1)
    uluasetTimeout("QFCU_Off()", 200)
end

function Qfcu:SetLedsOff()
    -- update cache
    self:FreshMidLeds()
    self:FreshLeftLeds()
    self:FreshRightLeds()

    -- real code
    self:_SetChg('ledsval', idr_qfcu_hid_ledsval_i, 0)
    self:_SetChg('ledslval', idr_qfcu_hid_ledslval_i, 0)
    self:_SetChg('ledsrval', idr_qfcu_hid_ledsrval_i, 0)
end

function Qfcu:SetDigiOff()
    -- real code
    self:_SetChg('iasmode', idr_qfcu_hid_iasmode, 0)
    self:_SetChg('hdgmode', idr_qfcu_hid_hdgmode, 0)
    self:_SetChg('altmode', idr_qfcu_hid_altmode, 0)
    self:_SetChg('vsmode', idr_qfcu_hid_vsmode, 0)
    self:_SetChg('refismode', idr_qfcu_hid_refismode, 0)
    self:_SetChg('lefismode', idr_qfcu_hid_lefismode, 0)
end

return Qfcu
