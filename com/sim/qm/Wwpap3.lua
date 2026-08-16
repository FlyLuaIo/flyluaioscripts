-- *****************************************************************
-- Don't modify this file, unless you know what you are doing
-- Most of the code are auto generated
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-08-08_03_55_08UTC
-- *****************************************************************

local Wwpap3 = oop.class(com.sim.Qmdev)
function Wwpap3:init()
	self.QmdevId = 0x3A3C0513
	self.FastTurnsPerSecond = 5
	if _G.ilua_hw_assigned_wwpap3 == nil then
		self.PackageConter = 0
		self.LcdText = nil
		_G.ilua_hw_assigned_wwpap3 = 0
		self.LEDS_BKL = 0
		self.LEDS_LCDBKL = 1
		self.LEDS_LEDBKL = 2
		self.LEDS_N1 = 3
		self.LEDS_SPEED = 4
		self.LEDS_VNAV = 5
		self.LEDS_LVLCHG = 6
		self.LEDS_HDGSEL = 7
		self.LEDS_LNAV = 8
		self.LEDS_VORLOC = 9
		self.LEDS_APP = 10
		self.LEDS_ALTHLD = 11
		self.LEDS_VS = 12
		self.LEDS_CMDA = 13
		self.LEDS_CWSA = 14
		self.LEDS_CMDB = 15
		self.LEDS_CWSB = 16
		self.LEDS_ATARM = 17
		self.LEDS_MACAPT = 18
		self.LEDS_MAFO = 19
		self.LEDS_ATSOL = 30
		self.ledIds = {
			self.LEDS_BKL,
			self.LEDS_LCDBKL,
			self.LEDS_LEDBKL,
			self.LEDS_N1,
			self.LEDS_SPEED,
			self.LEDS_VNAV,
			self.LEDS_LVLCHG,
			self.LEDS_HDGSEL,
			self.LEDS_LNAV,
			self.LEDS_VORLOC,
			self.LEDS_APP,
			self.LEDS_ALTHLD,
			self.LEDS_VS,
			self.LEDS_CMDA,
			self.LEDS_CWSA,
			self.LEDS_CMDB,
			self.LEDS_CWSB,
			self.LEDS_ATARM,
			self.LEDS_MACAPT,
			self.LEDS_MAFO,
			self.LEDS_ATSOL
		}
		self._lcdInited = false
		self._lastLcdPayload = nil
	end
end

function Wwpap3:absent(FastTurnsPerSecond)
	if not uluaFind('cpuwolf/flyluaio/WwPap3/leds/ledCmd') then
		return true
	end
	_G.idr_wwpap3_hid_leds_ledcmd = uluaFind('cpuwolf/flyluaio/WwPap3/leds/ledCmd')
	_G.idr_wwpap3_hid_init_seqnum = uluaFind('cpuwolf/flyluaio/WwPap3/init/seqNum')
	_G.idr_wwpap3_hid_lcd_seqnum = uluaFind('cpuwolf/flyluaio/WwPap3/lcd/seqNum')
	_G.idr_wwpap3_hid_lcd_lcd1 = uluaFind('cpuwolf/flyluaio/WwPap3/lcd/lcd1')
	_G.idr_wwpap3_hid_lcd_lcd2 = uluaFind('cpuwolf/flyluaio/WwPap3/lcd/lcd2')
	_G.idr_wwpap3_hid_lcd_lcd3 = uluaFind('cpuwolf/flyluaio/WwPap3/lcd/lcd3')
	_G.idr_wwpap3_hid_lcd_lcd4 = uluaFind('cpuwolf/flyluaio/WwPap3/lcd/lcd4')
	_G.idr_wwpap3_hid_lcd_lcd5 = uluaFind('cpuwolf/flyluaio/WwPap3/lcd/lcd5')
	_G.idr_wwpap3_hid_lcd_lcd6 = uluaFind('cpuwolf/flyluaio/WwPap3/lcd/lcd6')
	_G.idr_wwpap3_hid_lcd_lcd7 = uluaFind('cpuwolf/flyluaio/WwPap3/lcd/lcd7')
	_G.idr_wwpap3_hid_lcd_lcd8 = uluaFind('cpuwolf/flyluaio/WwPap3/lcd/lcd8')
	_G.idr_wwpap3_hid_empty_seqnum = uluaFind('cpuwolf/flyluaio/WwPap3/empty/seqNum')
	_G.idr_wwpap3_hid_finish_seqnum = uluaFind('cpuwolf/flyluaio/WwPap3/finish/seqNum')
	_G.idr_wwpap3_hid_config_value = uluaFind('cpuwolf/flyluaio/WwPap3/config/configValue')
	_G.idr_wwpap3_hid_invalid = uluaFind('cpuwolf/flyluaio/WwPap3/invalid')
	_G.idr_wwpap3_hid_fastkeypersec = uluaFind('cpuwolf/flyluaio/WwPap3/fastkeypersec')
	uluaSet(_G.idr_wwpap3_hid_fastkeypersec, FastTurnsPerSecond)

	self:sendDeviceConfig()
	self:ensureLcdInit()
	self:SetBkl(0, 0)
	self:SetLcdBkl(0, 0)
	self:SetLedBkl(0, 0)
	self:setMcpDisplay({
		displayEnabled = false,
		displayTest = false,
		showLabels = false,
		showCourse = true,
		speed = 0,
		spdMach = false,
		speedVisible = false,
		heading = 0,
		headingVisible = true,
		altitude = 0,
		altitudeVisible = true,
		verticalSpeed = 0,
		verticalSpeedVisible = false,
		crsCapt = 0,
		crsFo = 0,
		digitA = false,
		digitB = false,
	})
	return false
end

function Wwpap3:Init(FastTurnsPerSecond)
	local ftps = FastTurnsPerSecond == nil and self.FastTurnsPerSecond or FastTurnsPerSecond
	if self:absent(ftps) then
		return false
	end
	if _G.ilua_hw_assigned_wwpap3 == 1 then
		return false
	end
	_G.ilua_hw_assigned_wwpap3 = 1
	return true
end

function Wwpap3.Open(...)
	return com.sim.Qmdev.Open(Wwpap3, ...)
end

-- ========
-- Device Config (PAP3-MCP firmware configuration)
-- Standard config sequence: 4 frames with device-specific parameters
-- Sequence must be sent BEFORE LCD init frame
-- ========
function Wwpap3:SendConfigParam(configType, deviceParam, configValue)
	local val = configValue * 256 * 256 + deviceParam * 256 + configType
	uluaSet(_G.idr_wwpap3_hid_config_value, val)
end

function Wwpap3:sendDeviceConfig()
	self:SendConfigParam(0x01, 0x00, 0x00)
	self:SendConfigParam(0x01, 0x01, 0x00)
	self:SendConfigParam(0x01, 0x02, 0x00)
	self:SendConfigParam(0x01, 0x03, 0x00)
	-- 时间间隔 ~4ms，在 absent() 中依次发送
	self:SendConfigParam(0x04, 0x05, 0x9C)
	self:SendConfigParam(0x04, 0x05, 0xA0)
	self:SendConfigParam(0x04, 0x05, 0xA4)
	self:SendConfigParam(0x04, 0x05, 0x04)
	self:SendConfigParam(0x01, 0x18, 0x00)
end

function Wwpap3:SendLedCmd(LedId, value)
	local combinedValue = (value * 256) + LedId
	uluaSet(_G.idr_wwpap3_hid_leds_ledcmd, combinedValue)
end

function Wwpap3:SendBit(idx, valbase, val)
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
function Wwpap3:GetBkl(dpath, scale)
	self.d_bkl_scale = scale == nil and 30 or scale
	self.d_bkl = iDataRef:New(dpath)
end

function Wwpap3:SetBkl(valbase, val)
	if val == nil then
		if self.d_bkl:ChangedUpdate() then
			val = self.d_bkl:GetOld() * self.d_bkl_scale
			self:SendLedCmd(self.LEDS_BKL, val)
		end
	else
		self:SendLedCmd(self.LEDS_BKL, val)
	end
end

-- ========
-- LEDS LCDBKL
function Wwpap3:GetLcdBkl(dpath, scale)
	self.d_lcdbkl_scale = scale == nil and 180 or scale
	self.d_lcdbkl = iDataRef:New(dpath)
end

function Wwpap3:SetLcdBkl(valbase, val)
	if val == nil then
		if self.d_lcdbkl:ChangedUpdate() then
			val = self.d_lcdbkl:GetOld() * self.d_lcdbkl_scale
			self:SendLedCmd(self.LEDS_LCDBKL, val)
		end
	else
		self:SendLedCmd(self.LEDS_LCDBKL, val)
	end
end

-- ========
-- LEDS LEDBKL
function Wwpap3:GetLedBkl(dpath, scale)
	self.d_ledbkl_scale = scale == nil and 180 or scale
	self.d_ledbkl = iDataRef:New(dpath)
end

function Wwpap3:SetLedBkl(valbase, val)
	if val == nil then
		if self.d_ledbkl:ChangedUpdate() then
			val = self.d_ledbkl:GetOld() * self.d_ledbkl_scale
			self:SendLedCmd(self.LEDS_LEDBKL, val ~= 0 and 255 or 0)
		end
	else
		self:SendLedCmd(self.LEDS_LEDBKL, val ~= 0 and 255 or 0)
	end
end

-- ========
-- LEDS N1
function Wwpap3:GetN1(dpath, revert, base)
	self:GetBit(self.LEDS_N1, dpath, revert, base)
end

function Wwpap3:SetN1(valbase, val)
	self:SendBit(self.LEDS_N1, valbase, val)
end

-- ========
-- LEDS SPEED
function Wwpap3:GetSpeed(dpath, revert, base)
	self:GetBit(self.LEDS_SPEED, dpath, revert, base)
end

function Wwpap3:SetSpeed(valbase, val)
	self:SendBit(self.LEDS_SPEED, valbase, val)
end

-- ========
-- LEDS VNAV
function Wwpap3:GetVnav(dpath, revert, base)
	self:GetBit(self.LEDS_VNAV, dpath, revert, base)
end

function Wwpap3:SetVnav(valbase, val)
	self:SendBit(self.LEDS_VNAV, valbase, val)
end

-- ========
-- LEDS LVLCHG
function Wwpap3:GetLvlChg(dpath, revert, base)
	self:GetBit(self.LEDS_LVLCHG, dpath, revert, base)
end

function Wwpap3:SetLvlChg(valbase, val)
	self:SendBit(self.LEDS_LVLCHG, valbase, val)
end

-- ========
-- LEDS HDGSEL
function Wwpap3:GetHdgSel(dpath, revert, base)
	self:GetBit(self.LEDS_HDGSEL, dpath, revert, base)
end

function Wwpap3:SetHdgSel(valbase, val)
	self:SendBit(self.LEDS_HDGSEL, valbase, val)
end

-- ========
-- LEDS LNAV
function Wwpap3:GetLnav(dpath, revert, base)
	self:GetBit(self.LEDS_LNAV, dpath, revert, base)
end

function Wwpap3:SetLnav(valbase, val)
	self:SendBit(self.LEDS_LNAV, valbase, val)
end

-- ========
-- LEDS VORLOC
function Wwpap3:GetVorLoc(dpath, revert, base)
	self:GetBit(self.LEDS_VORLOC, dpath, revert, base)
end

function Wwpap3:SetVorLoc(valbase, val)
	self:SendBit(self.LEDS_VORLOC, valbase, val)
end

-- ========
-- LEDS APP
function Wwpap3:GetApp(dpath, revert, base)
	self:GetBit(self.LEDS_APP, dpath, revert, base)
end

function Wwpap3:SetApp(valbase, val)
	self:SendBit(self.LEDS_APP, valbase, val)
end

-- ========
-- LEDS ALTHLD
function Wwpap3:GetAltHld(dpath, revert, base)
	self:GetBit(self.LEDS_ALTHLD, dpath, revert, base)
end

function Wwpap3:SetAltHld(valbase, val)
	self:SendBit(self.LEDS_ALTHLD, valbase, val)
end

-- ========
-- LEDS VS
function Wwpap3:GetVs(dpath, revert, base)
	self:GetBit(self.LEDS_VS, dpath, revert, base)
end

function Wwpap3:SetVs(valbase, val)
	self:SendBit(self.LEDS_VS, valbase, val)
end

-- ========
-- LEDS CMDA
function Wwpap3:GetCmdA(dpath, revert, base)
	self:GetBit(self.LEDS_CMDA, dpath, revert, base)
end

function Wwpap3:SetCmdA(valbase, val)
	self:SendBit(self.LEDS_CMDA, valbase, val)
end

-- ========
-- LEDS CWSA
function Wwpap3:GetCwsA(dpath, revert, base)
	self:GetBit(self.LEDS_CWSA, dpath, revert, base)
end

function Wwpap3:SetCwsA(valbase, val)
	self:SendBit(self.LEDS_CWSA, valbase, val)
end

-- ========
-- LEDS CMDB
function Wwpap3:GetCmdB(dpath, revert, base)
	self:GetBit(self.LEDS_CMDB, dpath, revert, base)
end

function Wwpap3:SetCmdB(valbase, val)
	self:SendBit(self.LEDS_CMDB, valbase, val)
end

-- ========
-- LEDS CWSB
function Wwpap3:GetCwsB(dpath, revert, base)
	self:GetBit(self.LEDS_CWSB, dpath, revert, base)
end

function Wwpap3:SetCwsB(valbase, val)
	self:SendBit(self.LEDS_CWSB, valbase, val)
end

-- ========
-- LEDS ATARM
function Wwpap3:GetAtArm(dpath, revert, base)
	self:GetBit(self.LEDS_ATARM, dpath, revert, base)
end

function Wwpap3:SetAtArm(valbase, val)
	self:SendBit(self.LEDS_ATARM, valbase, val)
end

-- ========
-- LEDS MACAPT
function Wwpap3:GetMaCapt(dpath, revert, base)
	self:GetBit(self.LEDS_MACAPT, dpath, revert, base)
end

function Wwpap3:SetMaCapt(valbase, val)
	self:SendBit(self.LEDS_MACAPT, valbase, val)
end

-- ========
-- LEDS MAFO
function Wwpap3:GetMaFo(dpath, revert, base)
	self:GetBit(self.LEDS_MAFO, dpath, revert, base)
end

function Wwpap3:SetMaFo(valbase, val)
	self:SendBit(self.LEDS_MAFO, valbase, val)
end

-- ========
-- LEDS ATSOL
function Wwpap3:GetAtSol(dpath, revert, base)
	self:GetBit(self.LEDS_ATSOL, dpath, revert, base)
end

function Wwpap3:SetAtSol(valbase, val)
	self:SendBit(self.LEDS_ATSOL, valbase, val)
end

function Wwpap3:Setleds(valbase, val)
	self:SetBkl(valbase, val)
	self:SetLcdBkl(valbase, val)
	self:SetLedBkl(valbase, val)
	self:SetN1(valbase, val)
	self:SetSpeed(valbase, val)
	self:SetVnav(valbase, val)
	self:SetLvlChg(valbase, val)
	self:SetHdgSel(valbase, val)
	self:SetLnav(valbase, val)
	self:SetVorLoc(valbase, val)
	self:SetApp(valbase, val)
	self:SetAltHld(valbase, val)
	self:SetVs(valbase, val)
	self:SetCmdA(valbase, val)
	self:SetCwsA(valbase, val)
	self:SetCmdB(valbase, val)
	self:SetCwsB(valbase, val)
	self:SetAtArm(valbase, val)
	self:SetMaCapt(valbase, val)
	self:SetMaFo(valbase, val)
	self:SetAtSol(valbase, val)
end

-- ========
-- LCD (WINCTRL pap3-mcp-lcd-segments / product-pap3-mcp::sendLCDDisplay)
function Wwpap3:Next()
	local val = self.PackageConter or 1
	if val < 1 then val = 1 end
	self.PackageConter = (val % 255) + 1
	return val
end

function Wwpap3:ensureLcdInit()
	if self._lcdInited then return end
	self._lcdInited = true
	uluaSet(_G.idr_wwpap3_hid_init_seqnum, self:Next())
end

local function pap3_clamp(v, lo, hi)
	if v < lo then return lo end
	if v > hi then return hi end
	return v
end

local PAP3_DIGIT = {
	[0] = 0x3F,
	[1] = 0x06,
	[2] = 0x5B,
	[3] = 0x4F,
	[4] = 0x66,
	[5] = 0x6D,
	[6] = 0x7D,
	[7] = 0x07,
	[8] = 0x7F,
	[9] = 0x6F
}
local PAP3_A, PAP3_B, PAP3_C = 0x01, 0x02, 0x04
local PAP3_D, PAP3_E, PAP3_F, PAP3_G = 0x08, 0x10, 0x20, 0x40
local PAP3_LETTER_A = bit.bor(PAP3_A, PAP3_B, PAP3_C, PAP3_E, PAP3_F, PAP3_G)
local PAP3_G0 = { 0x1D, 0x21, 0x25, 0x29, 0x2D, 0x31, 0x35 }
local PAP3_G1 = { 0x1E, 0x22, 0x26, 0x2A, 0x2E, 0x32, 0x36 }
local PAP3_G2 = { 0x1F, 0x23, 0x27, 0x2B, 0x2F, 0x33, 0x37 }
local PAP3_G3 = { 0x20, 0x24, 0x28, 0x2C, 0x30, 0x34, 0x38 }

local function pap3_apply(p, absOff, flag, on)
	if not on then return end
	local i = absOff - 0x19
	if i < 0 or i >= 32 then return end
	p[i + 1] = bit.bor(p[i + 1], flag)
end

local function pap3_drawMask(g, p, flag, m)
	pap3_apply(p, g[1], flag, bit.band(m, PAP3_G) ~= 0)
	pap3_apply(p, g[2], flag, bit.band(m, PAP3_F) ~= 0)
	pap3_apply(p, g[3], flag, bit.band(m, PAP3_E) ~= 0)
	pap3_apply(p, g[4], flag, bit.band(m, PAP3_D) ~= 0)
	pap3_apply(p, g[5], flag, bit.band(m, PAP3_C) ~= 0)
	pap3_apply(p, g[6], flag, bit.band(m, PAP3_B) ~= 0)
	pap3_apply(p, g[7], flag, bit.band(m, PAP3_A) ~= 0)
end

local function pap3_drawDigit(g, p, flag, digit)
	pap3_drawMask(g, p, flag, PAP3_DIGIT[pap3_clamp(digit, 0, 9)] or 0)
end

local function pap3_drawDash(g, p, flag)
	pap3_apply(p, g[1], flag, true)
end

local function pap3_pack32(payload)
	local out = {}
	for i = 0, 7 do
		local b0 = payload[i * 4 + 1] or 0
		local b1 = payload[i * 4 + 2] or 0
		local b2 = payload[i * 4 + 3] or 0
		local b3 = payload[i * 4 + 4] or 0
		out[i + 1] = b0 + b1 * 256 + b2 * 65536 + b3 * 16777216
	end
	return out
end

function Wwpap3:_lcdPayloadEquals(payload)
	local last = self._lastLcdPayload
	if not last then return false end
	for i = 1, 32 do
		if (payload[i] or 0) ~= (last[i] or 0) then return false end
	end
	return true
end

function Wwpap3:sendRawLcdPayload(payload)
	-- 如果 payload 没有变化，跳过发送（节流）
	if self:_lcdPayloadEquals(payload) then
		return
	end
	self._lastLcdPayload = payload

	-- self:ensureLcdInit()
	local words = pap3_pack32(payload)
	uluaSet(_G.idr_wwpap3_hid_lcd_lcd1, words[1])
	uluaSet(_G.idr_wwpap3_hid_lcd_lcd2, words[2])
	uluaSet(_G.idr_wwpap3_hid_lcd_lcd3, words[3])
	uluaSet(_G.idr_wwpap3_hid_lcd_lcd4, words[4])
	uluaSet(_G.idr_wwpap3_hid_lcd_lcd5, words[5])
	uluaSet(_G.idr_wwpap3_hid_lcd_lcd6, words[6])
	uluaSet(_G.idr_wwpap3_hid_lcd_lcd7, words[7])
	uluaSet(_G.idr_wwpap3_hid_lcd_lcd8, words[8])
	uluaSet(_G.idr_wwpap3_hid_lcd_seqnum, self:Next())
	uluaSet(_G.idr_wwpap3_hid_empty_seqnum, self:Next())
	uluaSet(_G.idr_wwpap3_hid_empty_seqnum, self:Next())
	uluaSet(_G.idr_wwpap3_hid_finish_seqnum, self:Next())
end

function Wwpap3:setMcpDisplay(data)
	data = data or {}
	local enabled = data.displayEnabled ~= false
	local test = data.displayTest and true or false
	local key = table.concat({
		tostring(enabled), tostring(test),
		tostring(data.speed or 0), tostring(data.spdMach), tostring(data.speedVisible),
		tostring(data.heading or 0), tostring(data.headingVisible),
		tostring(data.altitude or 0), tostring(data.altitudeVisible),
		tostring(data.verticalSpeed or 0), tostring(data.verticalSpeedVisible),
		tostring(data.crsCapt or 0), tostring(data.crsFo or 0),
		tostring(data.digitA), tostring(data.digitB), tostring(data.showLabels)
	}, '|')
	if key == self.LcdText then return end
	self.LcdText = key

	local p = {}
	for i = 1, 32 do p[i] = 0 end

	if not enabled or test then
		local fill = (enabled and test) and 0xFF or 0x00
		for i = 1, 32 do p[i] = fill end
		self:sendRawLcdPayload(p)
		return
	end

	local showLabels = data.showLabels and true or false
	local digitA = data.digitA and true or false
	local digitB = data.digitB and true or false
	local showCourse = data.showCourse ~= false

	if data.speedVisible then
		local spd = tonumber(data.speed) or 0
		if data.spdMach then
			local mach = spd
			if mach >= 1.0 then mach = mach / 100.0 end
			mach = pap3_clamp(mach, 0.0, 0.9999)
			if (data.machDigits or 2) >= 3 then
				local three = pap3_clamp(math.floor(mach * 1000.0 + 0.5), 0, 999)
				pap3_drawDigit(PAP3_G0, p, 0x04, math.floor(three / 100) % 10)
				pap3_drawDigit(PAP3_G0, p, 0x02, math.floor(three / 10) % 10)
				pap3_drawDigit(PAP3_G0, p, 0x01, three % 10)
				pap3_apply(p, 0x1E, 0x80, true)
			else
				local two = pap3_clamp(math.floor(mach * 100.0 + 0.5), 0, 99)
				pap3_drawDigit(PAP3_G0, p, 0x02, math.floor(two / 10) % 10)
				pap3_drawDigit(PAP3_G0, p, 0x01, two % 10)
				pap3_apply(p, 0x19, 0x04, true)
				pap3_apply(p, 0x22, 0x80, digitA)
				pap3_apply(p, 0x1E, 0x80, digitA)
			end
			pap3_apply(p, 0x32, 0x80, showLabels)
			pap3_apply(p, 0x2E, 0x80, showLabels)
		else
			local ias = math.max(0, math.floor(spd + 0.5))
			local k = math.floor(ias / 1000) % 10
			local h = math.floor(ias / 100) % 10
			local t = math.floor(ias / 10) % 10
			local u = ias % 10
			local showK = k ~= 0
			local showH = showK or h ~= 0
			if showK then pap3_drawDigit(PAP3_G0, p, 0x08, k) end
			if showH then pap3_drawDigit(PAP3_G0, p, 0x04, h) end
			pap3_drawDigit(PAP3_G0, p, 0x02, t)
			pap3_drawDigit(PAP3_G0, p, 0x01, u)
			pap3_apply(p, 0x36, 0x80, showLabels)
			pap3_apply(p, 0x22, 0x80, digitA)
			pap3_apply(p, 0x1E, 0x80, digitA)
			if not showK then
				if digitA then pap3_drawMask(PAP3_G0, p, 0x08, PAP3_LETTER_A) end
				if digitB then pap3_drawDigit(PAP3_G0, p, 0x08, 8) end
			end
		end
	elseif data.showDashesWhenInactive then
		pap3_drawDash(PAP3_G0, p, 0x04)
		pap3_drawDash(PAP3_G0, p, 0x02)
		pap3_drawDash(PAP3_G0, p, 0x01)
		if data.showLabelsWhenInactive then pap3_apply(p, 0x36, 0x80, true) end
	end

	if showCourse then
		local crs = pap3_clamp(math.max(0, math.floor(tonumber(data.crsCapt) or 0)), 0, 999)
		pap3_drawDigit(PAP3_G0, p, 0x80, math.floor(crs / 100) % 10)
		pap3_drawDigit(PAP3_G0, p, 0x40, math.floor(crs / 10) % 10)
		pap3_drawDigit(PAP3_G0, p, 0x20, crs % 10)
	end

	if data.headingVisible ~= false then
		local heading = math.floor(tonumber(data.heading) or 0)
		local hdg = (heading >= 360) and 360 or pap3_clamp(heading, 0, 359)
		pap3_drawDigit(PAP3_G1, p, 0x40, math.floor(hdg / 100) % 10)
		pap3_drawDigit(PAP3_G1, p, 0x20, math.floor(hdg / 10) % 10)
		pap3_drawDigit(PAP3_G1, p, 0x10, hdg % 10)
		pap3_apply(p, 0x36, 0x08, showLabels)
		pap3_apply(p, 0x32, 0x08, showLabels)
	elseif data.showDashesWhenInactive then
		pap3_drawDash(PAP3_G1, p, 0x40)
		pap3_drawDash(PAP3_G1, p, 0x20)
		pap3_drawDash(PAP3_G1, p, 0x10)
		if data.showLabelsWhenInactive then
			pap3_apply(p, 0x36, 0x08, true)
			pap3_apply(p, 0x32, 0x08, true)
		end
	end

	if data.altitudeVisible ~= false then
		local alt = pap3_clamp(math.max(0, math.floor(tonumber(data.altitude) or 0)), 0, 99999)
		local d10k = math.floor(alt / 10000) % 10
		if d10k ~= 0 then pap3_drawDigit(PAP3_G1, p, 0x04, d10k) end
		pap3_drawDigit(PAP3_G1, p, 0x02, math.floor(alt / 1000) % 10)
		pap3_drawDigit(PAP3_G1, p, 0x01, math.floor(alt / 100) % 10)
		pap3_drawDigit(PAP3_G2, p, 0x80, math.floor(alt / 10) % 10)
		pap3_drawDigit(PAP3_G2, p, 0x40, alt % 10)
	end

	if data.verticalSpeedVisible then
		local v = math.floor(tonumber(data.verticalSpeed) or 0)
		local absV = pap3_clamp(math.abs(v), 0, 9999)
		if absV >= 1000 then pap3_drawDigit(PAP3_G2, p, 0x08, math.floor(absV / 1000) % 10) end
		if absV >= 100 then pap3_drawDigit(PAP3_G2, p, 0x04, math.floor(absV / 100) % 10) end
		if absV >= 10 or absV == 0 then pap3_drawDigit(PAP3_G2, p, 0x02, math.floor(absV / 10) % 10) end
		pap3_drawDigit(PAP3_G2, p, 0x01, absV % 10)
		local neg, pos = v < 0, v > 0
		pap3_apply(p, 0x1F, 0x10, neg or pos)
		pap3_apply(p, 0x2C, 0x80, pos)
		pap3_apply(p, 0x28, 0x80, pos)
		pap3_apply(p, 0x38, 0x80, showLabels)
	elseif data.showDashesWhenInactive then
		pap3_drawDash(PAP3_G2, p, 0x08)
		pap3_drawDash(PAP3_G2, p, 0x04)
		pap3_drawDash(PAP3_G2, p, 0x02)
		pap3_drawDash(PAP3_G2, p, 0x01)
		if data.showLabelsWhenInactive then pap3_apply(p, 0x38, 0x80, true) end
	elseif data.showLabelsWhenInactive then
		pap3_apply(p, 0x38, 0x80, true)
	end

	if showCourse then
		local crs = pap3_clamp(math.max(0, math.floor(tonumber(data.crsFo) or 0)), 0, 999)
		pap3_drawDigit(PAP3_G3, p, 0x40, math.floor(crs / 100) % 10)
		pap3_drawDigit(PAP3_G3, p, 0x20, math.floor(crs / 10) % 10)
		pap3_drawDigit(PAP3_G3, p, 0x10, crs % 10)
	end

	self:sendRawLcdPayload(p)
end

return Wwpap3
