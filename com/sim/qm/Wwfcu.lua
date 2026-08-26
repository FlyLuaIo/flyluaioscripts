
-- *****************************************************************
-- Don't modify this file, unless you know what you are doing
-- Most of the code are auto generated
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-08-08_03_55_08UTC
-- *****************************************************************

local Wwfcu = oop.class(com.sim.Qmdev)
function Wwfcu:init()
	self.QmdevId = 0x2BA2DB51
	self.FastTurnsPerSecond = 5
	if _G.ilua_hw_assigned_wwfcu == nil then
		self.PackageConter = 0
		self.LcdText = nil
		_G.ilua_hw_assigned_wwfcu = 0
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
	end
end

function Wwfcu:absent(FastTurnsPerSecond)
	if not uluaFind('cpuwolf/flyluaio/WwFcu/leds/ledCmd') then
		return true
	end
	_G.idr_wwfcu_hid_leds_ledcmd = uluaFind('cpuwolf/flyluaio/WwFcu/leds/ledCmd')
	_G.idr_wwfcu_hid_lcd_seqnum = uluaFind('cpuwolf/flyluaio/WwFcu/lcd/seqNum')
	_G.idr_wwfcu_hid_lcd_spd = uluaFind('cpuwolf/flyluaio/WwFcu/lcd/spd')
	_G.idr_wwfcu_hid_lcd_hdg = uluaFind('cpuwolf/flyluaio/WwFcu/lcd/hdg')
	_G.idr_wwfcu_hid_lcd_alt = uluaFind('cpuwolf/flyluaio/WwFcu/lcd/alt')
	_G.idr_wwfcu_hid_lcd_vs = uluaFind('cpuwolf/flyluaio/WwFcu/lcd/vs')
	_G.idr_wwfcu_hid_finish_seqnum = uluaFind('cpuwolf/flyluaio/WwFcu/finish/seqNum')
	_G.idr_wwfcu_hid_invalid = uluaFind('cpuwolf/flyluaio/WwFcu/invalid')
	_G.idr_wwfcu_hid_fastkeypersec = uluaFind('cpuwolf/flyluaio/WwFcu/fastkeypersec')
	uluaSet(_G.idr_wwfcu_hid_fastkeypersec, FastTurnsPerSecond)
	return false
end

function Wwfcu:Init(FastTurnsPerSecond)
	local ftps = FastTurnsPerSecond == nil and self.FastTurnsPerSecond or FastTurnsPerSecond
	if self:absent(ftps) then
		return false
	end
	if _G.ilua_hw_assigned_wwfcu == 1 then
		return false
	end
	_G.ilua_hw_assigned_wwfcu = 1
	return true
end

function Wwfcu.Open(...)
	return com.sim.Qmdev.Open(Wwfcu, ...)
end

function Wwfcu:SendLedCmd(LedId, value)
	local combinedValue = (math.floor(value) * 256) + LedId
	uluaSet(_G.idr_wwfcu_hid_leds_ledcmd, combinedValue)
end

function Wwfcu:SendBit(idx, valbase, val)
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

-- ========
-- LEDS BKL
function Wwfcu:GetBkl(dpath, revert, base)
	self:GetBit(self.LEDS_BKL, dpath, revert, base)
end

function Wwfcu:SetBkl(valbase, val)
	self:SendBit(self.LEDS_BKL, valbase, val)
end
-- ========
-- LEDS SCRBKL
function Wwfcu:GetScrBkl(dpath, revert, base)
	self:GetBit(self.LEDS_SCRBKL, dpath, revert, base)
end

function Wwfcu:SetScrBkl(valbase, val)
	self:SendBit(self.LEDS_SCRBKL, valbase, val)
end
-- ========
-- LEDS LEDBKL
function Wwfcu:GetLedBkl(dpath, revert, base)
	self:GetBit(self.LEDS_LEDBKL, dpath, revert, base)
end

function Wwfcu:SetLedBkl(valbase, val)
	self:SendBit(self.LEDS_LEDBKL, valbase, val)
end
-- ========
-- LEDS LOC
function Wwfcu:GetLoc(dpath, revert, base)
	self:GetBit(self.LEDS_LOC, dpath, revert, base)
end

function Wwfcu:SetLoc(valbase, val)
	self:SendBit(self.LEDS_LOC, valbase, val)
end
-- ========
-- LEDS AP1
function Wwfcu:GetAp1(dpath, revert, base)
	self:GetBit(self.LEDS_AP1, dpath, revert, base)
end

function Wwfcu:SetAp1(valbase, val)
	self:SendBit(self.LEDS_AP1, valbase, val)
end
-- ========
-- LEDS AP2
function Wwfcu:GetAp2(dpath, revert, base)
	self:GetBit(self.LEDS_AP2, dpath, revert, base)
end

function Wwfcu:SetAp2(valbase, val)
	self:SendBit(self.LEDS_AP2, valbase, val)
end
-- ========
-- LEDS ATHR
function Wwfcu:GetAthr(dpath, revert, base)
	self:GetBit(self.LEDS_ATHR, dpath, revert, base)
end

function Wwfcu:SetAthr(valbase, val)
	self:SendBit(self.LEDS_ATHR, valbase, val)
end
-- ========
-- LEDS EXPED
function Wwfcu:GetExped(dpath, revert, base)
	self:GetBit(self.LEDS_EXPED, dpath, revert, base)
end

function Wwfcu:SetExped(valbase, val)
	self:SendBit(self.LEDS_EXPED, valbase, val)
end
-- ========
-- LEDS APPR
function Wwfcu:GetAppr(dpath, revert, base)
	self:GetBit(self.LEDS_APPR, dpath, revert, base)
end

function Wwfcu:SetAppr(valbase, val)
	self:SendBit(self.LEDS_APPR, valbase, val)
end
-- ========
-- LEDS EXPEDBKL
function Wwfcu:GetExpedBkl(dpath, revert, base)
	self:GetBit(self.LEDS_EXPEDBKL, dpath, revert, base)
end

function Wwfcu:SetExpedBkl(valbase, val)
	self:SendBit(self.LEDS_EXPEDBKL, valbase, val)
end

function Wwfcu:Setleds(valbase, val)
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
-- FCU LCD (WINCTRL product-fcu-efis::sendFCUDisplay + SegmentDisplay)
function Wwfcu:Next()
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

function Wwfcu:setFcuDisplay(d)
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

	uluaSet(_G.idr_wwfcu_hid_lcd_spd, spd)
	uluaSet(_G.idr_wwfcu_hid_lcd_hdg, hdg)
	uluaSet(_G.idr_wwfcu_hid_lcd_alt, alt)
	uluaSet(_G.idr_wwfcu_hid_lcd_vs, vs)
	local pc = self:Next()
	uluaSet(_G.idr_wwfcu_hid_lcd_seqnum, pc)
	uluaSet(_G.idr_wwfcu_hid_finish_seqnum, pc)
end

return Wwfcu
