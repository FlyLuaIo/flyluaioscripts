
-- *****************************************************************
-- Don't modify this file, unless you know what you are doing
-- Most of the code are auto generated
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-08-08_03_55_08UTC
-- *****************************************************************

local Wwfcuefis = oop.class(com.sim.Qmdev)
function Wwfcuefis:init()
	self.QmdevId = 0x06D3042B
	self.FastTurnsPerSecond = 5
	if _G.ilua_hw_assigned_wwfcuefis == nil then
		self.PackageConter = 0
		self.LcdText = nil
		_G.ilua_hw_assigned_wwfcuefis = 0
		self.LEDS_BKL = 0
		self.LEDS_SCRBKL = 1
		self.LEDS_LEDBKL = 2
		self.LEDS_LOC = 3
		self.LEDS_AP1 = 5
		self.LEDS_AP2 = 7
		self.LEDS_ATHR = 9
		self.LEDS_EXPED = 11
		self.LEDS_APPR = 13
		self.LEDS_EXPEDBKL = 30
		self.ledIds = {
			self.LEDS_BKL,
			self.LEDS_SCRBKL,
			self.LEDS_LEDBKL,
			self.LEDS_LOC,
			self.LEDS_AP1,
			self.LEDS_AP2,
			self.LEDS_ATHR,
			self.LEDS_EXPED,
			self.LEDS_APPR,
			self.LEDS_EXPEDBKL
		}
		self.LEDSR_BKL = 0
		self.LEDSR_SCRBKL = 1
		self.LEDSR_LEDBKL = 2
		self.LEDSR_FD = 3
		self.LEDSR_LS = 4
		self.LEDSR_CSTR = 5
		self.LEDSR_WPT = 6
		self.LEDSR_VORD = 7
		self.LEDSR_NDB = 8
		self.LEDSR_ARPT = 9
		self.ledIds = {
			self.LEDSR_BKL,
			self.LEDSR_SCRBKL,
			self.LEDSR_LEDBKL,
			self.LEDSR_FD,
			self.LEDSR_LS,
			self.LEDSR_CSTR,
			self.LEDSR_WPT,
			self.LEDSR_VORD,
			self.LEDSR_NDB,
			self.LEDSR_ARPT
		}
		self.LEDSL_BKL = 0
		self.LEDSL_SCRBKL = 1
		self.LEDSL_LEDBKL = 2
		self.LEDSL_FD = 3
		self.LEDSL_LS = 4
		self.LEDSL_CSTR = 5
		self.LEDSL_WPT = 6
		self.LEDSL_VORD = 7
		self.LEDSL_NDB = 8
		self.LEDSL_ARPT = 9
		self.ledIds = {
			self.LEDSL_BKL,
			self.LEDSL_SCRBKL,
			self.LEDSL_LEDBKL,
			self.LEDSL_FD,
			self.LEDSL_LS,
			self.LEDSL_CSTR,
			self.LEDSL_WPT,
			self.LEDSL_VORD,
			self.LEDSL_NDB,
			self.LEDSL_ARPT
		}
	end
end

function Wwfcuefis:absent(FastTurnsPerSecond)
	if not uluaFind('cpuwolf/flyluaio/WwFcuEfis/leds/ledCmd') then
		return true
	end
	_G.idr_wwfcuefis_hid_leds_ledcmd = uluaFind('cpuwolf/flyluaio/WwFcuEfis/leds/ledCmd')
	_G.idr_wwfcuefis_hid_ledsr_ledcmd = uluaFind('cpuwolf/flyluaio/WwFcuEfis/ledsR/ledCmd')
	_G.idr_wwfcuefis_hid_ledsl_ledcmd = uluaFind('cpuwolf/flyluaio/WwFcuEfis/ledsL/ledCmd')
	_G.idr_wwfcuefis_hid_lcd_seqnum = uluaFind('cpuwolf/flyluaio/WwFcuEfis/lcd/seqNum')
	_G.idr_wwfcuefis_hid_lcd_spd = uluaFind('cpuwolf/flyluaio/WwFcuEfis/lcd/spd')
	_G.idr_wwfcuefis_hid_lcd_hdg = uluaFind('cpuwolf/flyluaio/WwFcuEfis/lcd/hdg')
	_G.idr_wwfcuefis_hid_lcd_alt = uluaFind('cpuwolf/flyluaio/WwFcuEfis/lcd/alt')
	_G.idr_wwfcuefis_hid_lcd_vs = uluaFind('cpuwolf/flyluaio/WwFcuEfis/lcd/vs')
	_G.idr_wwfcuefis_hid_finish_seqnum = uluaFind('cpuwolf/flyluaio/WwFcuEfis/finish/seqNum')
	_G.idr_wwfcuefis_hid_lcdr_seqnum = uluaFind('cpuwolf/flyluaio/WwFcuEfis/lcdR/seqNum')
	_G.idr_wwfcuefis_hid_lcdr_baro = uluaFind('cpuwolf/flyluaio/WwFcuEfis/lcdR/baro')
	_G.idr_wwfcuefis_hid_lcdr_flag = uluaFind('cpuwolf/flyluaio/WwFcuEfis/lcdR/flag')
	_G.idr_wwfcuefis_hid_finishr_seqnum = uluaFind('cpuwolf/flyluaio/WwFcuEfis/finishR/seqNum')
	_G.idr_wwfcuefis_hid_lcdl_seqnum = uluaFind('cpuwolf/flyluaio/WwFcuEfis/lcdL/seqNum')
	_G.idr_wwfcuefis_hid_lcdl_baro = uluaFind('cpuwolf/flyluaio/WwFcuEfis/lcdL/baro')
	_G.idr_wwfcuefis_hid_lcdl_flag = uluaFind('cpuwolf/flyluaio/WwFcuEfis/lcdL/flag')
	_G.idr_wwfcuefis_hid_finishl_seqnum = uluaFind('cpuwolf/flyluaio/WwFcuEfis/finishL/seqNum')
	_G.idr_wwfcuefis_hid_invalid = uluaFind('cpuwolf/flyluaio/WwFcuEfis/invalid')
	_G.idr_wwfcuefis_hid_fastkeypersec = uluaFind('cpuwolf/flyluaio/WwFcuEfis/fastkeypersec')
	uluaSet(_G.idr_wwfcuefis_hid_fastkeypersec, FastTurnsPerSecond)
	return false
end

function Wwfcuefis:Init(FastTurnsPerSecond)
	local ftps = FastTurnsPerSecond == nil and self.FastTurnsPerSecond or FastTurnsPerSecond
	if self:absent(ftps) then
		return false
	end
	if _G.ilua_hw_assigned_wwfcuefis == 1 then
		return false
	end
	_G.ilua_hw_assigned_wwfcuefis = 1
	return true
end

function Wwfcuefis.Open(...)
	return com.sim.Qmdev.Open(Wwfcuefis, ...)
end

function Wwfcuefis:SendLedCmd(LedId, value)
	local combinedValue = (LedId * 256) + value
	uluaSet(_G.idr_wwfcuefis_hid_leds_ledcmd, combinedValue)
end

function Wwfcuefis:SendBit(idx, valbase, val)
	valbase = valbase == nil and 0 or valbase
	if val == nil then
		hdl = self.Bits[idx + 1]
		if hdl:ChangedUpdate() then
			val = hdl:GetOldBit()
			self:SendLedCmd(idx, val)
		end
	else
		self:SendLedCmd(idx, ilua_bool_ternary(val, valbase))
	end
end

function Wwfcuefis:SendLedCmdR(LedId, value)
	local combinedValue = (LedId * 256) + value
	uluaSet(_G.idr_wwfcuefis_hid_ledsr_ledcmd, combinedValue)
end

function Wwfcuefis:SendLedCmdL(LedId, value)
	local combinedValue = (LedId * 256) + value
	uluaSet(_G.idr_wwfcuefis_hid_ledsl_ledcmd, combinedValue)
end

-- ========
-- LEDS BKL
function Wwfcuefis:GetBkl(dpath, revert, base)
	self:GetBit(self.LEDS_BKL, dpath, revert, base)
end

function Wwfcuefis:SetBkl(valbase, val)
	self:SendBit(self.LEDS_BKL, valbase, val)
end
-- ========
-- LEDS SCRBKL
function Wwfcuefis:GetScrBkl(dpath, revert, base)
	self:GetBit(self.LEDS_SCRBKL, dpath, revert, base)
end

function Wwfcuefis:SetScrBkl(valbase, val)
	self:SendBit(self.LEDS_SCRBKL, valbase, val)
end
-- ========
-- LEDS LEDBKL
function Wwfcuefis:GetLedBkl(dpath, revert, base)
	self:GetBit(self.LEDS_LEDBKL, dpath, revert, base)
end

function Wwfcuefis:SetLedBkl(valbase, val)
	self:SendBit(self.LEDS_LEDBKL, valbase, val)
end
-- ========
-- LEDS LOC
function Wwfcuefis:GetLoc(dpath, revert, base)
	self:GetBit(self.LEDS_LOC, dpath, revert, base)
end

function Wwfcuefis:SetLoc(valbase, val)
	self:SendBit(self.LEDS_LOC, valbase, val)
end
-- ========
-- LEDS AP1
function Wwfcuefis:GetAp1(dpath, revert, base)
	self:GetBit(self.LEDS_AP1, dpath, revert, base)
end

function Wwfcuefis:SetAp1(valbase, val)
	self:SendBit(self.LEDS_AP1, valbase, val)
end
-- ========
-- LEDS AP2
function Wwfcuefis:GetAp2(dpath, revert, base)
	self:GetBit(self.LEDS_AP2, dpath, revert, base)
end

function Wwfcuefis:SetAp2(valbase, val)
	self:SendBit(self.LEDS_AP2, valbase, val)
end
-- ========
-- LEDS ATHR
function Wwfcuefis:GetAthr(dpath, revert, base)
	self:GetBit(self.LEDS_ATHR, dpath, revert, base)
end

function Wwfcuefis:SetAthr(valbase, val)
	self:SendBit(self.LEDS_ATHR, valbase, val)
end
-- ========
-- LEDS EXPED
function Wwfcuefis:GetExped(dpath, revert, base)
	self:GetBit(self.LEDS_EXPED, dpath, revert, base)
end

function Wwfcuefis:SetExped(valbase, val)
	self:SendBit(self.LEDS_EXPED, valbase, val)
end
-- ========
-- LEDS APPR
function Wwfcuefis:GetAppr(dpath, revert, base)
	self:GetBit(self.LEDS_APPR, dpath, revert, base)
end

function Wwfcuefis:SetAppr(valbase, val)
	self:SendBit(self.LEDS_APPR, valbase, val)
end
-- ========
-- LEDS EXPEDBKL
function Wwfcuefis:GetExpedBkl(dpath, revert, base)
	self:GetBit(self.LEDS_EXPEDBKL, dpath, revert, base)
end

function Wwfcuefis:SetExpedBkl(valbase, val)
	self:SendBit(self.LEDS_EXPEDBKL, valbase, val)
end

function Wwfcuefis:Setleds(valbase, val)
	self:SetBkl(valbase, val)
	self:SetScrBkl(valbase, val)
	self:SetLedBkl(valbase, val)
	self:SetLoc(valbase, val)
	self:SetAp1(valbase, val)
	self:SetAp2(valbase, val)
	self:SetAthr(valbase, val)
	self:SetExped(valbase, val)
	self:SetAppr(valbase, val)
	self:SetExpedBkl(valbase, val)
end
-- ========
-- LEDSR BKL
function Wwfcuefis:GetBkl(dpath, revert, base)
	self:GetBit(self.LEDSR_BKL, dpath, revert, base)
end

function Wwfcuefis:SetBkl(valbase, val)
	self:SendBit(self.LEDSR_BKL, valbase, val)
end
-- ========
-- LEDSR SCRBKL
function Wwfcuefis:GetScrBkl(dpath, revert, base)
	self:GetBit(self.LEDSR_SCRBKL, dpath, revert, base)
end

function Wwfcuefis:SetScrBkl(valbase, val)
	self:SendBit(self.LEDSR_SCRBKL, valbase, val)
end
-- ========
-- LEDSR LEDBKL
function Wwfcuefis:GetLedBkl(dpath, revert, base)
	self:GetBit(self.LEDSR_LEDBKL, dpath, revert, base)
end

function Wwfcuefis:SetLedBkl(valbase, val)
	self:SendBit(self.LEDSR_LEDBKL, valbase, val)
end
-- ========
-- LEDSR FD
function Wwfcuefis:GetFd(dpath, revert, base)
	self:GetBit(self.LEDSR_FD, dpath, revert, base)
end

function Wwfcuefis:SetFd(valbase, val)
	self:SendBit(self.LEDSR_FD, valbase, val)
end
-- ========
-- LEDSR LS
function Wwfcuefis:GetLs(dpath, revert, base)
	self:GetBit(self.LEDSR_LS, dpath, revert, base)
end

function Wwfcuefis:SetLs(valbase, val)
	self:SendBit(self.LEDSR_LS, valbase, val)
end
-- ========
-- LEDSR CSTR
function Wwfcuefis:GetCstr(dpath, revert, base)
	self:GetBit(self.LEDSR_CSTR, dpath, revert, base)
end

function Wwfcuefis:SetCstr(valbase, val)
	self:SendBit(self.LEDSR_CSTR, valbase, val)
end
-- ========
-- LEDSR WPT
function Wwfcuefis:GetWpt(dpath, revert, base)
	self:GetBit(self.LEDSR_WPT, dpath, revert, base)
end

function Wwfcuefis:SetWpt(valbase, val)
	self:SendBit(self.LEDSR_WPT, valbase, val)
end
-- ========
-- LEDSR VORD
function Wwfcuefis:GetVord(dpath, revert, base)
	self:GetBit(self.LEDSR_VORD, dpath, revert, base)
end

function Wwfcuefis:SetVord(valbase, val)
	self:SendBit(self.LEDSR_VORD, valbase, val)
end
-- ========
-- LEDSR NDB
function Wwfcuefis:GetNdb(dpath, revert, base)
	self:GetBit(self.LEDSR_NDB, dpath, revert, base)
end

function Wwfcuefis:SetNdb(valbase, val)
	self:SendBit(self.LEDSR_NDB, valbase, val)
end
-- ========
-- LEDSR ARPT
function Wwfcuefis:GetArpt(dpath, revert, base)
	self:GetBit(self.LEDSR_ARPT, dpath, revert, base)
end

function Wwfcuefis:SetArpt(valbase, val)
	self:SendBit(self.LEDSR_ARPT, valbase, val)
end

function Wwfcuefis:SetledsR(valbase, val)
	self:SetBkl(valbase, val)
	self:SetScrBkl(valbase, val)
	self:SetLedBkl(valbase, val)
	self:SetFd(valbase, val)
	self:SetLs(valbase, val)
	self:SetCstr(valbase, val)
	self:SetWpt(valbase, val)
	self:SetVord(valbase, val)
	self:SetNdb(valbase, val)
	self:SetArpt(valbase, val)
end
-- ========
-- LEDSL BKL
function Wwfcuefis:GetBkl(dpath, revert, base)
	self:GetBit(self.LEDSL_BKL, dpath, revert, base)
end

function Wwfcuefis:SetBkl(valbase, val)
	self:SendBit(self.LEDSL_BKL, valbase, val)
end
-- ========
-- LEDSL SCRBKL
function Wwfcuefis:GetScrBkl(dpath, revert, base)
	self:GetBit(self.LEDSL_SCRBKL, dpath, revert, base)
end

function Wwfcuefis:SetScrBkl(valbase, val)
	self:SendBit(self.LEDSL_SCRBKL, valbase, val)
end
-- ========
-- LEDSL LEDBKL
function Wwfcuefis:GetLedBkl(dpath, revert, base)
	self:GetBit(self.LEDSL_LEDBKL, dpath, revert, base)
end

function Wwfcuefis:SetLedBkl(valbase, val)
	self:SendBit(self.LEDSL_LEDBKL, valbase, val)
end
-- ========
-- LEDSL FD
function Wwfcuefis:GetFd(dpath, revert, base)
	self:GetBit(self.LEDSL_FD, dpath, revert, base)
end

function Wwfcuefis:SetFd(valbase, val)
	self:SendBit(self.LEDSL_FD, valbase, val)
end
-- ========
-- LEDSL LS
function Wwfcuefis:GetLs(dpath, revert, base)
	self:GetBit(self.LEDSL_LS, dpath, revert, base)
end

function Wwfcuefis:SetLs(valbase, val)
	self:SendBit(self.LEDSL_LS, valbase, val)
end
-- ========
-- LEDSL CSTR
function Wwfcuefis:GetCstr(dpath, revert, base)
	self:GetBit(self.LEDSL_CSTR, dpath, revert, base)
end

function Wwfcuefis:SetCstr(valbase, val)
	self:SendBit(self.LEDSL_CSTR, valbase, val)
end
-- ========
-- LEDSL WPT
function Wwfcuefis:GetWpt(dpath, revert, base)
	self:GetBit(self.LEDSL_WPT, dpath, revert, base)
end

function Wwfcuefis:SetWpt(valbase, val)
	self:SendBit(self.LEDSL_WPT, valbase, val)
end
-- ========
-- LEDSL VORD
function Wwfcuefis:GetVord(dpath, revert, base)
	self:GetBit(self.LEDSL_VORD, dpath, revert, base)
end

function Wwfcuefis:SetVord(valbase, val)
	self:SendBit(self.LEDSL_VORD, valbase, val)
end
-- ========
-- LEDSL NDB
function Wwfcuefis:GetNdb(dpath, revert, base)
	self:GetBit(self.LEDSL_NDB, dpath, revert, base)
end

function Wwfcuefis:SetNdb(valbase, val)
	self:SendBit(self.LEDSL_NDB, valbase, val)
end
-- ========
-- LEDSL ARPT
function Wwfcuefis:GetArpt(dpath, revert, base)
	self:GetBit(self.LEDSL_ARPT, dpath, revert, base)
end

function Wwfcuefis:SetArpt(valbase, val)
	self:SendBit(self.LEDSL_ARPT, valbase, val)
end

function Wwfcuefis:SetledsL(valbase, val)
	self:SetBkl(valbase, val)
	self:SetScrBkl(valbase, val)
	self:SetLedBkl(valbase, val)
	self:SetFd(valbase, val)
	self:SetLs(valbase, val)
	self:SetCstr(valbase, val)
	self:SetWpt(valbase, val)
	self:SetVord(valbase, val)
	self:SetNdb(valbase, val)
	self:SetArpt(valbase, val)
end

-- ========
-- FCU LCD (WINCTRL product-fcu-efis::sendFCUDisplay + SegmentDisplay)
function Wwfcuefis:Next()
	local val = self.PackageConter or 1
	if val < 1 then val = 1 end
	self.PackageConter = (val % 255) + 1
	return val
end

local FCU_SEG = {
	['0']=0xFA,['1']=0x60,['2']=0xD6,['3']=0xF4,['4']=0x6C,
	['5']=0xBC,['6']=0xBE,['7']=0xE0,['8']=0xFE,['9']=0xFC,
	['A']=0xEE,['B']=0xFE,['C']=0x9A,['D']=0x76,['E']=0x9E,['F']=0x8E,
	['-']=0x04,['#']=0x36,[' ']=0x00
}

local function fcu_fix_len(s, n)
	s = tostring(s or '')
	if #s > n then s = s:sub(#s - n + 1) end
	while #s < n do s = ' ' .. s end
	return s
end

local function fcu_encode(n, s)
	s = fcu_fix_len(s, n)
	local data = {}
	for i = 1, n do data[i] = 0 end
	for i = 1, math.min(n, #s) do
		local ch = s:sub(i, i):upper()
		data[n - i + 1] = FCU_SEG[ch] or 0
	end
	return data
end

local function fcu_swap_nibbles(v)
	return bit.bor(bit.lshift(bit.band(v, 0x0F), 4), bit.rshift(bit.band(v, 0xF0), 4))
end

local function fcu_encode_swapped(n, s)
	local data = fcu_encode(n, s)
	data[n + 1] = 0
	for i = 1, #data do data[i] = fcu_swap_nibbles(data[i]) end
	for i = 0, n - 1 do
		local a = n - i + 1
		local b = n - i
		data[a] = bit.bor(bit.band(data[a], 0x0F), bit.band(data[b], 0xF0))
		data[b] = bit.band(data[b], 0x0F)
	end
	return data
end

local function fcu_pack_le(bytes)
	local v = 0
	local mul = 1
	for i = 1, #bytes do
		v = v + (bytes[i] or 0) * mul
		mul = mul * 256
	end
	return v
end

function Wwfcuefis:setFcuDisplay(d)
	d = d or {}
	local key = table.concat({
		tostring(d.displayEnabled), tostring(d.displayTest),
		tostring(d.speed), tostring(d.heading), tostring(d.altitude), tostring(d.verticalSpeed),
		tostring(d.spdMach), tostring(d.spdManaged), tostring(d.hdgManaged), tostring(d.altManaged),
		tostring(d.headingHdg), tostring(d.headingTrk), tostring(d.headingLat),
		tostring(d.vsMode), tostring(d.fpaMode), tostring(d.vsSign), tostring(d.fpaComma),
		tostring(d.vsIndication), tostring(d.fpaIndication), tostring(d.vsVerticalLine)
	}, '|')
	if key == self.LcdText then return end
	self.LcdText = key

	local win = d.windows or 0x3FF
	local function win_on(bitv) return bit.band(win, bitv) ~= 0 end

	local speedData = fcu_encode(3, d.speed or '')
	local headingData = fcu_encode_swapped(3, d.heading or '')
	local altitudeData = fcu_encode_swapped(5, d.altitude or '')
	local vsData = fcu_encode_swapped(4, d.verticalSpeed or '')

	local flags = {}
	for i = 0, 16 do flags[i] = 0 end

	if win_on(1) then
		if d.spdMach then flags[1] = bit.bor(flags[1], 0x04) else flags[1] = bit.bor(flags[1], 0x08) end
	end
	if win_on(2) then
		if d.spdMach then flags[12] = bit.bor(flags[12], 0x01) end
		if d.spdManaged then flags[1] = bit.bor(flags[1], 0x02) end
	end
	if win_on(4) then
		if d.headingHdg then flags[0] = bit.bor(flags[0], 0x80) end
		if d.headingTrk then flags[0] = bit.bor(flags[0], 0x40) end
		if d.headingLat then flags[0] = bit.bor(flags[0], 0x20) end
	end
	if win_on(8) and d.hdgManaged then flags[0] = bit.bor(flags[0], 0x10) end
	if win_on(16) then
		if d.vsMode then flags[7] = bit.bor(flags[7], 0x04) end
		if d.fpaMode then flags[7] = bit.bor(flags[7], 0x01) end
		if d.headingHdg then flags[7] = bit.bor(flags[7], 0x08) end
		if d.headingTrk then flags[7] = bit.bor(flags[7], 0x02) end
	end
	if win_on(32) and (d.altIndication ~= false) then flags[6] = bit.bor(flags[6], 0x10) end
	if win_on(64) and d.altManaged then flags[11] = bit.bor(flags[11], 0x10) end
	if win_on(128) then
		if d.lvlChange ~= false then flags[4] = bit.bor(flags[4], 0x10) end
		if d.lvlChangeLeft ~= false then flags[5] = bit.bor(flags[5], 0x10) end
		if d.lvlChangeRight ~= false then flags[3] = bit.bor(flags[3], 0x10) end
	end
	if win_on(256) then
		if d.vsIndication then flags[10] = bit.bor(flags[10], 0x40) end
		if d.fpaIndication then flags[10] = bit.bor(flags[10], 0x80) end
	end
	if win_on(512) then
		if d.vsHorizontalLine ~= false then flags[2] = bit.bor(flags[2], 0x10) end
		if d.vsVerticalLine then flags[8] = bit.bor(flags[8], 0x20) end
		if d.fpaComma then flags[9] = bit.bor(flags[9], 0x10) end
		if d.vsSign then flags[8] = bit.bor(flags[8], 0x10) end
	end

	local offOrTest = (d.displayEnabled == false) or d.displayTest
	local fill = d.displayTest and 0xFF or 0
	local function blank(arr, n)
		for i = 1, n do arr[i] = fill end
	end
	if offOrTest or not win_on(2) then blank(speedData, 3) end
	if offOrTest or not win_on(8) then blank(headingData, 4) end
	if offOrTest or not win_on(64) then blank(altitudeData, 6) end
	if offOrTest or not win_on(512) then blank(vsData, 5) end
	if offOrTest then for i = 0, 16 do flags[i] = fill end end

	local spd = fcu_pack_le({
		speedData[3],
		bit.bor(speedData[2] or 0, flags[12]),
		speedData[1]
	})
	local hdg = fcu_pack_le({
		bit.bor(headingData[4] or 0, flags[1]),
		headingData[3] or 0,
		headingData[2] or 0,
		bit.bor(headingData[1] or 0, flags[0])
	})
	local alt = fcu_pack_le({
		bit.bor(altitudeData[6] or 0, flags[7]),
		bit.bor(altitudeData[5] or 0, flags[6]),
		bit.bor(altitudeData[4] or 0, flags[5]),
		bit.bor(altitudeData[3] or 0, flags[4]),
		bit.bor(altitudeData[2] or 0, flags[3]),
		bit.bor(altitudeData[1] or 0, vsData[5] or 0, flags[2])
	})
	local vs = fcu_pack_le({
		bit.bor(vsData[4] or 0, flags[9]),
		bit.bor(vsData[3] or 0, flags[8]),
		bit.bor(vsData[2] or 0, flags[11]),
		bit.bor(vsData[1] or 0, flags[10])
	})

	uluaSet(_G.idr_wwfcuefis_hid_lcd_spd, spd)
	uluaSet(_G.idr_wwfcuefis_hid_lcd_hdg, hdg)
	uluaSet(_G.idr_wwfcuefis_hid_lcd_alt, alt)
	uluaSet(_G.idr_wwfcuefis_hid_lcd_vs, vs)
	local pc = self:Next()
	uluaSet(_G.idr_wwfcuefis_hid_lcd_seqnum, pc)
	uluaSet(_G.idr_wwfcuefis_hid_finish_seqnum, pc)
end

local function fcu_encode_efis(n, s)
	local raw = fcu_encode(n, s)
	local result = {}
	for i = 1, n do
		local d = raw[i] or 0
		local r = 0
		if bit.band(d, 0x08) ~= 0 then r = bit.bor(r, 0x01) end
		if bit.band(d, 0x04) ~= 0 then r = bit.bor(r, 0x02) end
		if bit.band(d, 0x02) ~= 0 then r = bit.bor(r, 0x04) end
		if bit.band(d, 0x10) ~= 0 then r = bit.bor(r, 0x08) end
		if bit.band(d, 0x80) ~= 0 then r = bit.bor(r, 0x10) end
		if bit.band(d, 0x40) ~= 0 then r = bit.bor(r, 0x20) end
		if bit.band(d, 0x20) ~= 0 then r = bit.bor(r, 0x40) end
		if bit.band(d, 0x01) ~= 0 then r = bit.bor(r, 0x80) end
		result[i] = r
	end
	return result
end

function Wwfcuefis:setEfisDisplay(side, data)
	data = data or {}
	local key = 'EFIS' .. side .. '|' .. table.concat({
		tostring(data.displayEnabled), tostring(data.displayTest), tostring(data.isStd),
		tostring(data.baro), tostring(data.unitIsInHg), tostring(data.showQfe)
	}, '|')
	local cache = side == 'R' and '_efisRText' or '_efisLText'
	if key == self[cache] then return end
	self[cache] = key

	local baro_idr = side == 'R' and _G.idr_wwfcuefis_hid_lcdr_baro or _G.idr_wwfcuefis_hid_lcdl_baro
	local flag_idr = side == 'R' and _G.idr_wwfcuefis_hid_lcdr_flag or _G.idr_wwfcuefis_hid_lcdl_flag
	local seq_idr = side == 'R' and _G.idr_wwfcuefis_hid_lcdr_seqnum or _G.idr_wwfcuefis_hid_lcdl_seqnum
	local fin_idr = side == 'R' and _G.idr_wwfcuefis_hid_finishr_seqnum or _G.idr_wwfcuefis_hid_finishl_seqnum

	local baro, flag = 0, 0
	if data.displayEnabled == false then
		baro, flag = 0, 0
	elseif data.displayTest then
		local eight = 0x7F
		baro = fcu_pack_le({ eight, bit.bor(eight, 0x80), eight, eight })
		flag = 0xFF
	else
		local text = data.isStd and 'STD ' or fcu_fix_len(data.baro or '', 4)
		local bd = fcu_encode_efis(4, text)
		local b2 = data.unitIsInHg and 0x80 or 0
		local b0 = 0
		if not data.isStd then
			b0 = data.showQfe and 0x01 or 0x02
		end
		baro = fcu_pack_le({ bd[4], bit.bor(bd[3], b2), bd[2], bd[1] })
		flag = b0
	end
	uluaSet(baro_idr, baro)
	uluaSet(flag_idr, flag)
	local pc = self:Next()
	uluaSet(seq_idr, pc)
	uluaSet(fin_idr, pc)
end

return Wwfcuefis
