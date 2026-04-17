-- *****************************************************************
-- Don't modify this file, unless you know what you are doing
-- Most of the code are auto generated
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-03-28_13_57_28UTC
-- *****************************************************************

local bit = require("bit")
local Wwagp = oop.class(com.sim.Qmdev)

function Wwagp:init()
	self.QmdevId = 0x3AEBEE64
	self.FastTurnsPerSecond = 5
	if _G.ilua_hw_assigned_wwagp == nil then
		_G.ilua_hw_assigned_wwagp = 0
		self.PackageConter = 0
		self.LcdText = ""
		-- 1. Character to 7-Segment Bitmask Mapping
		self.SEGMENT_MAP = {
			['0'] = 0x3F,
			['1'] = 0x06,
			['2'] = 0x5B,
			['3'] = 0x4F,
			['4'] = 0x66,
			['5'] = 0x6D,
			['6'] = 0x7D,
			['7'] = 0x07,
			['8'] = 0x7F,
			['9'] = 0x6F,
			['A'] = 0x77,
			['B'] = 0x7C,
			['C'] = 0x39,
			['D'] = 0x5E,
			['E'] = 0x79,
			['F'] = 0x71,
			['G'] = 0x3D,
			['H'] = 0x76,
			['L'] = 0x38,
			['P'] = 0x73,
			['S'] = 0x6D,
			['U'] = 0x3E,
			[' '] = 0x00,
			['-'] = 0x40,
			['_'] = 0x08
		}
		self.LED_BACKLIGHT = 0
		self.LED_LCD_BRIGHTNESS = 1
		self.LED_OVERALL_LEDS_BRIGHTNESS = 2
		self.LEDS_ULOCKL = 3
		self.LEDS_ULOCKN = 4
		self.LEDS_ULOCKR = 5
		self.LEDS_BRAKEHOT = 6
		self.LEDS_LOCKL = 7
		self.LEDS_LOCKN = 8
		self.LEDS_LOCKR = 9
		self.LEDS_BRAKEON = 10
		self.LEDS_LOWD = 11
		self.LEDS_MEDD = 12
		self.LEDS_MAXD = 13
		self.LEDS_LOW = 14
		self.LEDS_MED = 15
		self.LEDS_MAX = 16
		self.LEDS_TERR = 17
		self.LEDS_LEVER = 18
		self.ledIds = {
			self.LEDS_ULOCKL,
			self.LEDS_ULOCKN,
			self.LEDS_ULOCKR,
			self.LEDS_BRAKEHOT,
			self.LEDS_LOCKL,
			self.LEDS_LOCKN,
			self.LEDS_LOCKR,
			self.LEDS_BRAKEON,
			self.LEDS_LOWD,
			self.LEDS_MEDD,
			self.LEDS_MAXD,
			self.LEDS_LOW,
			self.LEDS_MED,
			self.LEDS_MAX,
			self.LEDS_TERR,
			self.LEDS_LEVER
		}
	end
end

function Wwagp:absent(FastTurnsPerSecond)
	if not uluaFind('cpuwolf/qmdev/WwAgp/leds/ledCmd') then
		return true
	end
	_G.idr_wwagp_hid_leds_ledcmd = uluaFind('cpuwolf/qmdev/WwAgp/leds/ledCmd')
	_G.idr_wwagp_hid_lcd_seqnum = uluaFind('cpuwolf/qmdev/WwAgp/lcd/seqNum')
	_G.idr_wwagp_hid_lcd_lcd1 = uluaFind('cpuwolf/qmdev/WwAgp/lcd/lcd1')
	_G.idr_wwagp_hid_lcd_lcd2 = uluaFind('cpuwolf/qmdev/WwAgp/lcd/lcd2')
	_G.idr_wwagp_hid_lcd_lcd3 = uluaFind('cpuwolf/qmdev/WwAgp/lcd/lcd3')
	_G.idr_wwagp_hid_lcd_lcd4 = uluaFind('cpuwolf/qmdev/WwAgp/lcd/lcd4')
	_G.idr_wwagp_hid_lcd_lcd5 = uluaFind('cpuwolf/qmdev/WwAgp/lcd/lcd5')
	_G.idr_wwagp_hid_lcd_lcd6 = uluaFind('cpuwolf/qmdev/WwAgp/lcd/lcd6')
	_G.idr_wwagp_hid_lcd_lcd7 = uluaFind('cpuwolf/qmdev/WwAgp/lcd/lcd7')
	_G.idr_wwagp_hid_lcd_lcd8 = uluaFind('cpuwolf/qmdev/WwAgp/lcd/lcd8')
	_G.idr_wwagp_hid_finish_seqnum = uluaFind('cpuwolf/qmdev/WwAgp/finish/seqNum')
	_G.idr_wwagp_hid_invalid = uluaFind('cpuwolf/qmdev/WwAgp/invalid')
	_G.idr_wwagp_hid_fastkeypersec = uluaFind('cpuwolf/qmdev/WwAgp/fastkeypersec')
	uluaSet(_G.idr_wwagp_hid_fastkeypersec, FastTurnsPerSecond)
	return false
end

function Wwagp:Init(FastTurnsPerSecond)
	local ftps = FastTurnsPerSecond == nil and self.FastTurnsPerSecond or FastTurnsPerSecond
	if self:absent(ftps) then
		return false
	end
	if _G.ilua_hw_assigned_wwagp == 1 then
		return false
	end
	_G.ilua_hw_assigned_wwagp = 1
	return true
end

function Wwagp:Next()
	local val = self.PackageConter
	self.PackageConter = (self.PackageConter + 1) % 256
	return val
end

function Wwagp:SendLedCmd(LedId, value)
	local val = math.floor(value) % 255
	local combinedValue = (val * 256) + LedId
	uluaSet(_G.idr_wwagp_hid_leds_ledcmd, combinedValue)
end

-- ========
-- Backlight
function Wwagp:GetBkl(dpath, scale)
	self.d_bkl_scale = scale == nil and 30 or scale
	self.d_bkl = iDataRef:New(dpath)
end

function Wwagp:SetBkl(val)
	if val == nil then
		if self.d_bkl:ChangedUpdate() then
			val = self.d_bkl:GetOld() * self.d_bkl_scale
			self:SendLedCmd(self.LED_BACKLIGHT, val)
		end
	else
		self:SendLedCmd(self.LED_BACKLIGHT, val)
	end
end

function Wwagp:FreshBkl()
	self.d_bkl:Invalid(-1)
end

-- ========
-- Leds Backlight
function Wwagp:GetLedBkl(dpath, scale)
	self.d_ledbkl_scale = scale == nil and 30 or scale
	self.d_ledbkl = iDataRef:New(dpath)
end

function Wwagp:SetLedBkl(val)
	if val == nil then
		if self.d_ledbkl:ChangedUpdate() then
			val = self.d_ledbkl:GetOld() * self.d_ledbkl_scale
			self:SendLedCmd(self.LED_OVERALL_LEDS_BRIGHTNESS, val)
		end
	else
		self:SendLedCmd(self.LED_OVERALL_LEDS_BRIGHTNESS, val)
	end
end

function Wwagp:FreshLedBkl()
	self.d_ledbkl:Invalid(-1)
end

-- Digis Backlight
function Wwagp:GetDigiBkl(dpath, scale)
	self.d_digibkl_scale = scale == nil and 30 or scale
	self.d_digibkl = iDataRef:New(dpath)
end

function Wwagp:SetDigiBkl(val)
	if val == nil then
		if self.d_digibkl:ChangedUpdate() then
			val = self.d_digibkl:GetOld() * self.d_digibkl_scale
			self:SendLedCmd(self.LED_LCD_BRIGHTNESS, val)
		end
	else
		self:SendLedCmd(self.LED_LCD_BRIGHTNESS, val)
		self.d_digibkl:Invalid(-1)
	end
end

function Wwagp:FreshDigiBkl()
	self.d_digibkl:Invalid(-1)
end

function Wwagp:PowerOff()
	self:SendLedCmd(self.LED_BACKLIGHT, 0)
	self:SendLedCmd(self.LED_LCD_BRIGHTNESS, 0)
	self:SendLedCmd(self.LED_OVERALL_LEDS_BRIGHTNESS, 0)
	for i = 1, #self.ledIds do
		self:SendLedCmd(self.ledIds[i], 0)
	end
end

function Wwagp:SendBit(idx, valbase, val)
	valbase = valbase == nil and 0 or valbase
	if val == nil then
		hdl = self.Bits[idx + 1]
		if hdl:ChangedUpdate() then
			val = hdl:GetOld()
			-- uluaLog(string.format("SendBit=%f", val))
			self:SendLedCmd(idx, ilua_bool_ternary(val, valbase, self.RevertBits[idx + 1]))
		end
	else
		self:SendLedCmd(idx, ilua_bool_ternary(val, valbase))
	end
end

-- ========
-- LEDS ULOCKL
function Wwagp:GetUlockL(dpath)
	self:GetBit(self.LEDS_ULOCKL, dpath)
end

function Wwagp:SetUlockL(valbase, val)
	self:SendBit(self.LEDS_ULOCKL, valbase, val)
end

-- ========
-- LEDS ULOCKN
function Wwagp:GetUlockN(dpath)
	self:GetBit(self.LEDS_ULOCKN, dpath)
end

function Wwagp:SetUlockN(valbase, val)
	self:SendBit(self.LEDS_ULOCKN, valbase, val)
end

-- ========
-- LEDS ULOCKR
function Wwagp:GetUlockR(dpath)
	self:GetBit(self.LEDS_ULOCKR, dpath)
end

function Wwagp:SetUlockR(valbase, val)
	self:SendBit(self.LEDS_ULOCKR, valbase, val)
end

-- ========
-- LEDS BRAKEHOT
function Wwagp:GetBrakeHot(dpath)
	self:GetBit(self.LEDS_BRAKEHOT, dpath)
end

function Wwagp:SetBrakeHot(valbase, val)
	self:SendBit(self.LEDS_BRAKEHOT, valbase, val)
end

-- ========
-- LEDS LOCKL
function Wwagp:GetLockL(dpath)
	self:GetBit(self.LEDS_LOCKL, dpath)
end

function Wwagp:SetLockL(valbase, val)
	self:SendBit(self.LEDS_LOCKL, valbase, val)
end

-- ========
-- LEDS LOCKN
function Wwagp:GetLockN(dpath)
	self:GetBit(self.LEDS_LOCKN, dpath)
end

function Wwagp:SetLockN(valbase, val)
	self:SendBit(self.LEDS_LOCKN, valbase, val)
end

-- ========
-- LEDS LOCKR
function Wwagp:GetLockR(dpath)
	self:GetBit(self.LEDS_LOCKR, dpath)
end

function Wwagp:SetLockR(valbase, val)
	self:SendBit(self.LEDS_LOCKR, valbase, val)
end

-- ========
-- LEDS BRAKEON
function Wwagp:GetBrakeOn(dpath)
	self:GetBit(self.LEDS_BRAKEON, dpath)
end

function Wwagp:SetBrakeOn(valbase, val)
	self:SendBit(self.LEDS_BRAKEON, valbase, val)
end

-- ========
-- LEDS LOWD
function Wwagp:GetLowD(dpath)
	self:GetBit(self.LEDS_LOWD, dpath)
end

function Wwagp:SetLowD(valbase, val)
	self:SendBit(self.LEDS_LOWD, valbase, val)
end

-- ========
-- LEDS MEDD
function Wwagp:GetMedD(dpath)
	self:GetBit(self.LEDS_MEDD, dpath)
end

function Wwagp:SetMedD(valbase, val)
	self:SendBit(self.LEDS_MEDD, valbase, val)
end

-- ========
-- LEDS MAXD
function Wwagp:GetMaxD(dpath)
	self:GetBit(self.LEDS_MAXD, dpath)
end

function Wwagp:SetMaxD(valbase, val)
	self:SendBit(self.LEDS_MAXD, valbase, val)
end

-- ========
-- LEDS LOW
function Wwagp:GetLow(dpath)
	self:GetBit(self.LEDS_LOW, dpath)
end

function Wwagp:SetLow(valbase, val)
	self:SendBit(self.LEDS_LOW, valbase, val)
end

-- ========
-- LEDS MED
function Wwagp:GetMed(dpath)
	self:GetBit(self.LEDS_MED, dpath)
end

function Wwagp:SetMed(valbase, val)
	self:SendBit(self.LEDS_MED, valbase, val)
end

-- ========
-- LEDS MAX
function Wwagp:GetMax(dpath)
	self:GetBit(self.LEDS_MAX, dpath)
end

function Wwagp:SetMax(valbase, val)
	self:SendBit(self.LEDS_MAX, valbase, val)
end

-- ========
-- LEDS TERR
function Wwagp:GetTerr(dpath)
	self:GetBit(self.LEDS_TERR, dpath)
end

function Wwagp:SetTerr(valbase, val)
	self:SendBit(self.LEDS_TERR, valbase, val)
end

-- ========
-- LEDS LEVER
function Wwagp:GetLever(dpath)
	self:GetBit(self.LEDS_LEVER, dpath)
end

function Wwagp:SetLever(valbase, val)
	self:SendBit(self.LEDS_LEVER, valbase, val)
end

function Wwagp:Setleds(valbase, val)
	self:SetUlockL(valbase, val)
	self:SetUlockN(valbase, val)
	self:SetUlockR(valbase, val)
	self:SetBrakeHot(valbase, val)
	self:SetLockL(valbase, val)
	self:SetLockN(valbase, val)
	self:SetLockR(valbase, val)
	self:SetBrakeOn(valbase, val)
	self:SetLowD(valbase, val)
	self:SetMedD(valbase, val)
	self:SetMaxD(valbase, val)
	self:SetLow(valbase, val)
	self:SetMed(valbase, val)
	self:SetMax(valbase, val)
	self:SetTerr(valbase, val)
	self:SetLever(valbase, val)
end

-- 2. Parsing Logic (Ported from ProductAGP::parseSegment)
function Wwagp:parseSegment(text, expectedLength)
	local digits = ""
	local localColonMask = 0

	for i = 1, #text do
		local char = text:sub(i, i)
		if char == ":" or char == "." then
			local pos = #digits
			if expectedLength >= 6 then
				if char == ":" then
					localColonMask = bit.bor(localColonMask, bit.lshift(1, pos - 1))
				end
				localColonMask = bit.bor(localColonMask, bit.lshift(1, pos))
			else
				if char == ":" then
					localColonMask = bit.bor(localColonMask, bit.lshift(1, pos))
				end
				localColonMask = bit.bor(localColonMask, bit.lshift(1, pos + 1))
			end
		else
			digits = digits .. char
		end
	end

	local padding = expectedLength - #digits
	if padding > 0 then
		localColonMask = bit.lshift(localColonMask, padding)
		digits = string.rep(" ", padding) .. digits
	elseif padding < 0 then
		digits = digits:sub(-expectedLength)
	end

	return digits, localColonMask
end

-- 3. Main Packet Construction (Updated for LuaJIT bit library)
function Wwagp:encodeDisplay(chrono, utc, elapsed)
	-- Initialize 32-byte packet (index 1 to 56)
	local packet = {}
	for i = 0, 56 do packet[i] = 0x00 end

	-- B. Define the Scattered Row Offsets
	local rowOffsets = { 25, 29, 33, 37, 41, 45, 49, 53 }

	-- C. Parse Input Strings
	local d1, m1 = self:parseSegment(chrono, 4)
	local d2, m2 = self:parseSegment(utc, 6)
	local d3, m3 = self:parseSegment(elapsed, 4)

	local allDigits = d1 .. d2 .. d3
	-- Combine into a 14-bit mask shifted by offsets 0, 4, 10
	local colonMask = bit.bor(m1, bit.lshift(m2, 4), bit.lshift(m3, 10))

	-- D. Encode into Scattered Packet Bytes
	for digitIdx = 0, 13 do
		local char = allDigits:sub(digitIdx + 1, digitIdx + 1):upper()
		local charMask = self.SEGMENT_MAP[char] or 0

		-- Byte offset inside row: 0 for digits 0-7, 1 for digits 8-13
		local columnOffset = math.floor(digitIdx / 8)
		local bitPos = digitIdx % 8

		-- Segments A-G (Rows 0-6)
		for segIdx = 0, 6 do
			if bit.band(charMask, bit.lshift(1, segIdx)) ~= 0 then
				local targetByte = rowOffsets[segIdx + 1] + columnOffset
				packet[targetByte] = bit.bor(packet[targetByte], bit.lshift(1, bitPos))
			end
		end

		-- Colons/Dots (Row 7)
		if bit.band(colonMask, bit.lshift(1, digitIdx)) ~= 0 then
			local targetByte = rowOffsets[8] + columnOffset
			packet[targetByte] = bit.bor(packet[targetByte], bit.lshift(1, bitPos))
		end
	end

	-- remove empty header
	for i = 1, 24 do
		table.remove(packet, 1) -- Removes index 1 and shifts others
	end
	return packet
end

--[[
-- Example usage:
local finalPacket = encodeDisplay("12:34", "12:34:56", "00:01", 1)

-- Debug print: only show the scattered bytes containing digit data
for i, v in ipairs(finalPacket) do
    print(string.format("Byte %02d: 0x%02X", i, v))
end
]] --

function Wwagp:formatChronoStr(chronosec)
	local chrono = ""
	local chrono_seconds = tonumber(chronosec) or 0

	if chrono_seconds > 0 then
		local total_seconds = math.floor(chrono_seconds)
		local mins = math.floor(total_seconds / 60) % 60
		local secs = total_seconds % 60
		chrono = string.format("%02d:%02d", mins, secs)
	end
	return chrono
end

function Wwagp:formatUTCdateStr(day_of_year)
	local utc = ""
	day_of_year = day_of_year + 1

	-- To calculate the date from day of year in Lua:
	local current_year = os.date("*t").year
	-- Get timestamp for January 1st of current year
	local jan1_ts = os.time({ year = current_year, month = 1, day = 1, hour = 12 })
	-- Add the days (seconds in a day = 86400)
	local target_ts = jan1_ts + (math.max(day_of_year - 1, 0) * 86400)
	local date_table = os.date("*t", target_ts)

	utc = string.format("%02d:%02d:%02d", date_table.month, date_table.day, date_table.year % 100)
	return utc
end

function Wwagp:IsLcdTextChanged(newtext)
	if newtext ~= self.LcdText then
		self.LcdText = newtext
		return true
	else
		return false
	end
end

--First Digit Data starts at: packet[25]
--Last Digit Data ends at: packet[54] (specifically, the high bits of the colon row).
--Total Span: 30 bytes of the packet are involved in display data, though only 16 of those bytes actually contain digit bits.
function Wwagp:setLcdStr(chrono, utc, elapsed)
	if not self:IsLcdTextChanged(chrono .. utc .. elapsed) then
		-- nothing is changed
		return
	end
	--uluaLog(chrono .. utc .. elapsed)
	local result = self:encodeDisplay(chrono, utc, elapsed)
	local pcounter = self:Next()

	uluaSet(_G.idr_wwagp_hid_lcd_lcd1, bit.bor(result[1], bit.lshift(result[2], 8)))
	uluaSet(_G.idr_wwagp_hid_lcd_lcd2, bit.bor(result[5], bit.lshift(result[6], 8)))
	uluaSet(_G.idr_wwagp_hid_lcd_lcd3, bit.bor(result[9], bit.lshift(result[10], 8)))
	uluaSet(_G.idr_wwagp_hid_lcd_lcd4, bit.bor(result[13], bit.lshift(result[14], 8)))
	uluaSet(_G.idr_wwagp_hid_lcd_lcd5, bit.bor(result[17], bit.lshift(result[18], 8)))
	uluaSet(_G.idr_wwagp_hid_lcd_lcd6, bit.bor(result[21], bit.lshift(result[22], 8)))
	uluaSet(_G.idr_wwagp_hid_lcd_lcd7, bit.bor(result[25], bit.lshift(result[26], 8)))
	uluaSet(_G.idr_wwagp_hid_lcd_lcd8, bit.bor(result[29], bit.lshift(result[30], 8)))
	uluaSet(_G.idr_wwagp_hid_lcd_seqnum, pcounter)
	uluaSet(_G.idr_wwagp_hid_finish_seqnum, pcounter)
end

function Wwagp:setLcdStrTest()
	self:setLcdStr("88:88", "88:88:88", "88:88")
end

return Wwagp
