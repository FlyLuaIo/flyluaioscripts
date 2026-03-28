-- *****************************************************************
-- Don't modify this file, unless you know what you are doing
-- Most of the code are auto generated
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-03-28_11_04_16UTC
-- *****************************************************************

local Wwagp = oop.class(com.sim.Qmdev)
function Wwagp:init()
	self.QmdevId = 0xC305EEB
	self.FastTurnsPerSecond = 5
	if _G.ilua_hw_assigned_wwagp == nil then
		_G.ilua_hw_assigned_wwagp = 0
		self.PackageConter = 0
	end
end

function Wwagp:absent(FastTurnsPerSecond)
	if not uluaFind('cpuwolf/qmdev/WwAgp/leds/ledCmd') then
		return true
	end
	_G.idr_wwagp_hid_leds_ledcmd = uluaFind('cpuwolf/qmdev/WwAgp/leds/ledCmd')
	_G.idr_wwagp_hid_lcd_seqnum = uluaFind('cpuwolf/qmdev/WwAgp/lcd/seqNum')
	_G.idr_wwagp_hid_lcd_chr = uluaFind('cpuwolf/qmdev/WwAgp/lcd/Chr')
	_G.idr_wwagp_hid_lcd_utc = uluaFind('cpuwolf/qmdev/WwAgp/lcd/Utc')
	_G.idr_wwagp_hid_lcd_et = uluaFind('cpuwolf/qmdev/WwAgp/lcd/Et')
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

-- 1. Character to 7-Segment Bitmask Mapping
local SEGMENT_MAP = {
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

-- 2. Parsing Logic (Ported from ProductAGP::parseSegment)
local function parseSegment(text, expectedLength)
	local digits = ""
	local localColonMask = 0

	for i = 1, #text do
		local char = text:sub(i, i)
		if char == ":" or char == "." then
			local pos = #digits
			if expectedLength >= 6 then
				if char == ":" then localColonMask = localColonMask | (1 << (pos - 1)) end
				localColonMask = localColonMask | (1 << pos)
			else
				if char == ":" then localColonMask = localColonMask | (1 << pos) end
				localColonMask = localColonMask | (1 << (pos + 1))
			end
		else
			digits = digits .. char
		end
	end

	local padding = expectedLength - #digits
	if padding > 0 then
		localColonMask = localColonMask << padding
		digits = string.rep(" ", padding) .. digits
	elseif padding < 0 then
		digits = digits:sub(-expectedLength)
	end

	return digits, localColonMask
end

-- 3. Main Packet Construction
local function encodeDisplay(chrono, utc, elapsed)
	-- Initialize 32-byte packet (index 1 to 56)
	local packet = {}
	for i = 0, 56 do packet[i] = 0x00 end


	-- B. Define the Scattered Row Offsets
	local rowOffsets = { 25, 29, 33, 37, 41, 45, 49, 53 }

	-- C. Parse Input Strings
	local d1, m1 = parseSegment(chrono, 4)
	local d2, m2 = parseSegment(utc, 6)
	local d3, m3 = parseSegment(elapsed, 4)

	local allDigits = d1 .. d2 .. d3
	-- Combine into a 14-bit mask shifted by offsets 0, 4, 10
	local colonMask = m1 | (m2 << 4) | (m3 << 10)

	-- D. Encode into Scattered Packet Bytes
	for digitIdx = 0, 13 do
		local char = allDigits:sub(digitIdx + 1, digitIdx + 1):upper()
		local charMask = SEGMENT_MAP[char] or 0

		-- Byte offset inside row: 0 for digits 0-7, 1 for digits 8-13
		local columnOffset = math.floor(digitIdx / 8)
		local bitPos = digitIdx % 8

		-- Segments A-G (Rows 0-6)
		for segIdx = 0, 6 do
			if (charMask & (1 << segIdx)) ~= 0 then
				local targetByte = rowOffsets[segIdx + 1] + columnOffset
				packet[targetByte] = packet[targetByte]| (1 << bitPos)
			end
		end

		-- Colons/Dots (Row 7)
		if (colonMask & (1 << digitIdx)) ~= 0 then
			local targetByte = rowOffsets[8] + columnOffset
			packet[targetByte] = packet[targetByte]| (1 << bitPos)
		end
	end
	for i = 1, 24 do
		table.remove(packet, 1) -- Removes index 1 and shifts others [1]
	end
	return packet
end

--[[
-- Example usage:
local finalPacket = encodeDisplay("12:34", "123456", "00:01", 1)

-- Debug print: only show the scattered bytes containing digit data
for i, v in ipairs(finalPacket) do
    print(string.format("Byte %02d: 0x%02X", i, v))
end
]] --

--First Digit Data starts at: packet[25]
--Last Digit Data ends at: packet[54] (specifically, the high bits of the colon row).
--Total Span: 30 bytes of the packet are involved in display data, though only 16 of those bytes actually contain digit bits.
function Wwagp:setLcdStr(chrono, utc, elapsed)
	local result = encodeDisplay(chrono, utc, elapsed)
	local pcounter = self:Next()
	chrnum = result
	uluaSet(_G.idr_wwagp_hid_lcd_chr, chrnum)
	uluaSet(_G.idr_wwagp_hid_lcd_seqnum, pcounter)
	uluaSet(_G.idr_wwagp_hid_finish_seqnum, pcounter)
end

return Wwagp
