-- *****************************************************************
-- Don't modify this file, unless you know what you are doing
-- Most of the code are auto generated
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-08-08_03_55_08UTC
-- *****************************************************************

local Wwtcas = oop.class(com.sim.Qmdev)
function Wwtcas:init()
	self.QmdevId = 0x13CA5335
	self.FastTurnsPerSecond = 5
	if _G.ilua_hw_assigned_wwtcas == nil then
		self.PackageConter = 0
		self.LcdText = nil
		_G.ilua_hw_assigned_wwtcas = 0
		self.LEDS_BKL = 0
		self.LEDS_LCDBKL = 1
		self.LEDS_LEDBKL = 2
		self.LEDS_ATCFAIL = 3
		self.ledIds = {
			self.LEDS_ATCFAIL
		}
	end
end

function Wwtcas:absent(FastTurnsPerSecond)
	if not uluaFind('cpuwolf/flyluaio/WwTcas/leds/ledCmd') then
		return true
	end
	_G.idr_wwtcas_hid_leds_ledcmd = uluaFind('cpuwolf/flyluaio/WwTcas/leds/ledCmd')
	_G.idr_wwtcas_hid_lcd_seqnum = uluaFind('cpuwolf/flyluaio/WwTcas/lcd/seqNum')
	_G.idr_wwtcas_hid_lcd_lcd1 = uluaFind('cpuwolf/flyluaio/WwTcas/lcd/lcd1')
	_G.idr_wwtcas_hid_lcd_lcd2 = uluaFind('cpuwolf/flyluaio/WwTcas/lcd/lcd2')
	_G.idr_wwtcas_hid_lcd_lcd3 = uluaFind('cpuwolf/flyluaio/WwTcas/lcd/lcd3')
	_G.idr_wwtcas_hid_lcd_lcd4 = uluaFind('cpuwolf/flyluaio/WwTcas/lcd/lcd4')
	_G.idr_wwtcas_hid_lcd_lcd5 = uluaFind('cpuwolf/flyluaio/WwTcas/lcd/lcd5')
	_G.idr_wwtcas_hid_lcd_lcd6 = uluaFind('cpuwolf/flyluaio/WwTcas/lcd/lcd6')
	_G.idr_wwtcas_hid_lcd_lcd7 = uluaFind('cpuwolf/flyluaio/WwTcas/lcd/lcd7')
	_G.idr_wwtcas_hid_finish_seqnum = uluaFind('cpuwolf/flyluaio/WwTcas/finish/seqNum')
	_G.idr_wwtcas_hid_invalid = uluaFind('cpuwolf/flyluaio/WwTcas/invalid')
	_G.idr_wwtcas_hid_fastkeypersec = uluaFind('cpuwolf/flyluaio/WwTcas/fastkeypersec')
	uluaSet(_G.idr_wwtcas_hid_fastkeypersec, FastTurnsPerSecond)
	return false
end

function Wwtcas:Init(FastTurnsPerSecond)
	local ftps = FastTurnsPerSecond == nil and self.FastTurnsPerSecond or FastTurnsPerSecond
	if self:absent(ftps) then
		return false
	end
	if _G.ilua_hw_assigned_wwtcas == 1 then
		return false
	end
	_G.ilua_hw_assigned_wwtcas = 1
	return true
end

function Wwtcas.Open(...)
	return com.sim.Qmdev.Open(Wwtcas, ...)
end

function Wwtcas:SendLedCmd(LedId, value)
	local combinedValue = (math.floor(value) * 256) + LedId
	uluaSet(_G.idr_wwtcas_hid_leds_ledcmd, combinedValue)
end

function Wwtcas:SendBit(idx, valbase, val)
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
-- Backlight
function Wwtcas:GetBkl(dpath, scale)
	self.d_bkl_scale = scale == nil and 30 or scale
	self.d_bkl = iDataRef:New(dpath)
end

function Wwtcas:SetBkl(val)
	if val == nil then
		if self.d_bkl:ChangedUpdate() then
			val = self.d_bkl:GetOld() * self.d_bkl_scale
			self:SendLedCmd(self.LEDS_BKL, val)
		end
	else
		self:SendLedCmd(self.LEDS_BKL, val)
	end
end

function Wwtcas:FreshBkl()
	self.d_bkl:Invalid(-1)
end

-- ========
-- Lcd Backlight
function Wwtcas:GetLcdBkl(dpath, scale)
	self.d_lcdbkl_scale = scale == nil and 30 or scale
	self.d_lcdbkl = iDataRef:New(dpath)
end

function Wwtcas:SetLcdBkl(val)
	if val == nil then
		if self.d_lcdbkl:ChangedUpdate() then
			val = self.d_lcdbkl:GetOld() * self.d_lcdbkl_scale
			self:SendLedCmd(self.LEDS_LCDBKL, val)
		end
	else
		self:SendLedCmd(self.LEDS_LCDBKL, val)
	end
end

function Wwtcas:FreshLcdBkl()
	self.d_lcdbkl:Invalid(-1)
end

-- ========
-- Led Backlight
function Wwtcas:GetLedBkl(dpath, scale)
	self.d_ledbkl_scale = scale == nil and 30 or scale
	self.d_ledbkl = iDataRef:New(dpath)
end

function Wwtcas:SetLedBkl(val)
	if val == nil then
		if self.d_ledbkl:ChangedUpdate() then
			val = self.d_ledbkl:GetOld() * self.d_ledbkl_scale
			self:SendLedCmd(self.LEDS_LEDBKL, val)
		end
	else
		self:SendLedCmd(self.LEDS_LEDBKL, val)
	end
end

function Wwtcas:FreshLedBkl()
	self.d_ledbkl:Invalid(-1)
end

-- ========
-- LEDS ATCFAIL
function Wwtcas:GetAtcFail(dpath, revert, base)
	self:GetBit(self.LEDS_ATCFAIL, dpath, revert, base)
end

function Wwtcas:SetAtcFail(valbase, val)
	self:SendBit(self.LEDS_ATCFAIL, valbase, val)
end

function Wwtcas:Setleds(valbase, val)
	self:SetAtcFail(valbase, val)
end

function Wwtcas:Next()
	local val = self.PackageConter or 1
	self.PackageConter = (val % 255) + 1
	return val
end

function Wwtcas:IsLcdTextChanged(newtext)
	if newtext ~= self.LcdText then
		self.LcdText = newtext
		return true
	end
	return false
end

-- 4-digit squawk → 7 segment planes (lcd1..lcd7), then finish commit
function Wwtcas:setLcdText(code)
	if code == nil then
		code = ''
	end
	code = string.sub(tostring(code) .. '    ', 1, 4)
	if not self:IsLcdTextChanged(code) then
		return
	end
	local segmap = {
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
		[' '] = 0x00,
		['-'] = 0x40
	}
	local planes = { 0, 0, 0, 0, 0, 0, 0 }
	for dig = 0, 3 do
		local mask = segmap[code:sub(dig + 1, dig + 1)] or 0
		for seg = 0, 6 do
			if bit.band(mask, bit.lshift(1, seg)) ~= 0 then
				planes[seg + 1] = bit.bor(planes[seg + 1], bit.lshift(1, dig))
			end
		end
	end
	local pc = self:Next()
	uluaSet(_G.idr_wwtcas_hid_lcd_lcd1, planes[1])
	uluaSet(_G.idr_wwtcas_hid_lcd_lcd2, planes[2])
	uluaSet(_G.idr_wwtcas_hid_lcd_lcd3, planes[3])
	uluaSet(_G.idr_wwtcas_hid_lcd_lcd4, planes[4])
	uluaSet(_G.idr_wwtcas_hid_lcd_lcd5, planes[5])
	uluaSet(_G.idr_wwtcas_hid_lcd_lcd6, planes[6])
	uluaSet(_G.idr_wwtcas_hid_lcd_lcd7, planes[7])
	uluaSet(_G.idr_wwtcas_hid_lcd_seqnum, pc)
	uluaSet(_G.idr_wwtcas_hid_finish_seqnum, pc)
end

-- ========================= XPDR
-- XPDR code 1~4 digi
-- conver number to string
function Wwtcas:EncXpdr(xcode, diginum)
	local val = xcode
	local txt = tostring(xcode)
	diginum = diginum == nil and 4 or diginum
	if xcode < 1000 and diginum >= 4 then
		val = val + 9000
		txt = '0' .. txt
	end
	if xcode < 100 and diginum >= 3 then
		val = val + 900
		txt = '0' .. txt
	end
	if xcode < 10 and diginum >= 2 then
		val = val + 90
		txt = '0' .. txt
	end
	if xcode == 0 and diginum == 1 then
		val = 9
		txt = '0'
	end
	if xcode < 0 or diginum == 0 then
		val = 9
		txt = ''
	end
	return txt
end

-- digial 9 is hidden digi
-- return xcode, diginum
function Wwtcas:XpdrDecode9(xcode)
	local newcode = 0
	local diginum = 0
	local digis = {}
	-- extract 1234={1, 2, 3, 4}
	local val = math.floor(xcode / 1000)
	digis[1] = val
	xcode = xcode - val * 1000
	val = math.floor(xcode / 100)
	digis[2] = val
	xcode = xcode - val * 100
	val = math.floor(xcode / 10)
	digis[3] = val
	xcode = xcode - val * 10
	val = xcode
	digis[4] = val

	for i = 1, 4 do
		if digis[i] == 9 then
			break
		else
			diginum = diginum + 1
		end
	end

	for i = 1, diginum do
		newcode = newcode + (digis[i] * (10 ^ (diginum - i)))
	end

	return newcode, diginum
end

-- ========================= Fake tranponder
-- fake tranponder standby code
-- when you key in 1,2,3,4,5, "5" will clear "1234" by default
_G.WwtcasFakeXpdrKeyNumAutoClr = true
-- Fast CLR, when press CLR twice, will clear all
_G.WwtcasFakeXpdrFastClr = false
_G.WwtcasFakeXpdrFastClrTimeOut = 99999
_G.WwtcasFakeXpdrFastClrIdleTime = os.clock()
-- XPDR standby timeout
_G.WwtcasFakeXpdrKeyTimeOut = -1
_G.WwtcasFakeXpdrKeyIdleTime = os.clock()
-- XPDR standby code
_G.WwtcasFakeXpdrKeyNum = 0
_G.WwtcasFakeXpdrKeyTable = { 0, 0, 0, 0 }
-- global callback function
_G.WwtcasFakeXpdrKeyCallBackFunc = function(KeyCode)
	uluaLog('key press->' .. tostring(KeyCode))
	-- handle timeout
	if os.clock() - _G.WwtcasFakeXpdrKeyIdleTime > WwtcasFakeXpdrKeyTimeOut then
		if _G.WwtcasFakeXpdrKeyNumAutoClr then
			_G.WwtcasFakeXpdrKeyNum = 0
		end
		uluaLog('WwtcasFakeXpdr timeout\n')
	end

	-- handle keycode: we use 9 as CLR
	if KeyCode ~= 9 then
		if _G.WwtcasFakeXpdrKeyNum < 4 then
			_G.WwtcasFakeXpdrKeyNum = _G.WwtcasFakeXpdrKeyNum + 1
			_G.WwtcasFakeXpdrKeyTable[_G.WwtcasFakeXpdrKeyNum] = KeyCode
		else
			if _G.WwtcasFakeXpdrKeyNumAutoClr then
				_G.WwtcasFakeXpdrKeyNum = 1
				_G.WwtcasFakeXpdrKeyTable[_G.WwtcasFakeXpdrKeyNum] = KeyCode
			end
		end
		_G.WwtcasFakeXpdrFastClr = false
	else
		-- handle FAST CLR
		if _G.WwtcasFakeXpdrFastClr and os.clock() - _G.WwtcasFakeXpdrFastClrIdleTime < WwtcasFakeXpdrFastClrTimeOut then
			_G.WwtcasFakeXpdrKeyNum = 0
			uluaLog('WwtcasFakeXpdr FAST CLR\n')
			_G.WwtcasFakeXpdrFastClr = false
		else
			_G.WwtcasFakeXpdrFastClr = true
		end

		if _G.WwtcasFakeXpdrKeyNum > 0 then
			_G.WwtcasFakeXpdrKeyNum = _G.WwtcasFakeXpdrKeyNum - 1
		end
		-- update FAST CLR timer
		_G.WwtcasFakeXpdrFastClrIdleTime = os.clock()
	end
	-- reset timer
	_G.WwtcasFakeXpdrKeyIdleTime = os.clock()
end

-- @ FuncCbName: is string of a global function name
-- @ timeout: can be empty
function Wwtcas:FakeXpdrInit(autoclr, timeout, fastclrtm)
	_G.WwtcasFakeXpdrKeyNumAutoClr = autoclr == nil and true or autoclr
	_G.WwtcasFakeXpdrKeyTimeOut = timeout == nil and 99999 or timeout
	_G.WwtcasFakeXpdrFastClrTimeOut = fastclrtm == nil and -1 or fastclrtm

	-- XPRD ATC Keypad
	-- CLR faked as number 9
	-- zero faked as number 8
	self:CfgFc(0, "_G.WwtcasFakeXpdrKeyCallBackFunc(1)")
	self:CfgFc(1, "_G.WwtcasFakeXpdrKeyCallBackFunc(2)")
	self:CfgFc(2, "_G.WwtcasFakeXpdrKeyCallBackFunc(3)")
	self:CfgFc(3, "_G.WwtcasFakeXpdrKeyCallBackFunc(4)")
	self:CfgFc(4, "_G.WwtcasFakeXpdrKeyCallBackFunc(5)")
	self:CfgFc(5, "_G.WwtcasFakeXpdrKeyCallBackFunc(6)")
	self:CfgFc(6, "_G.WwtcasFakeXpdrKeyCallBackFunc(7)")
	self:CfgFc(7, "_G.WwtcasFakeXpdrKeyCallBackFunc(0)")
	self:CfgFc(8, "_G.WwtcasFakeXpdrKeyCallBackFunc(9)")
end

function Wwtcas:FakeXpdrClear()
	_G.WwtcasFakeXpdrKeyNum = 0
end

function Wwtcas:FakeXpdrCopy(xcode)
	xcode = xcode == nil and self.d_xpdr:Get() or xcode

	_G.WwtcasFakeXpdrKeyNum = 4
	-- extract 1234={1, 2, 3, 4}
	local val = math.floor(xcode / 1000)
	-- uluaLog('XPDR CPY1 ' .. tostring(val))
	_G.WwtcasFakeXpdrKeyTable[1] = val
	xcode = xcode - val * 1000
	val = math.floor(xcode / 100)
	-- uluaLog('XPDR CPY2 ' .. tostring(val))
	_G.WwtcasFakeXpdrKeyTable[2] = val
	xcode = xcode - val * 100
	val = math.floor(xcode / 10)
	-- uluaLog('XPDR CPY3 ' .. tostring(val))
	_G.WwtcasFakeXpdrKeyTable[3] = val
	xcode = xcode - val * 10
	val = xcode
	-- uluaLog('XPDR CPY4 ' .. tostring(val))
	_G.WwtcasFakeXpdrKeyTable[4] = val
end

function Wwtcas:XpdrBc016(xcode)
	local bc016 = 0
	-- extract 1234={1, 2, 3, 4}
	local val = math.floor(xcode / 1000)
	-- uluaLog('XPDR CPY1 ' .. tostring(val))
	bc016 = bc016 + val * 4096
	xcode = xcode - val * 1000
	val = math.floor(xcode / 100)
	-- uluaLog('XPDR CPY2 ' .. tostring(val))
	bc016 = bc016 + val * 256
	xcode = xcode - val * 100
	val = math.floor(xcode / 10)
	-- uluaLog('XPDR CPY3 ' .. tostring(val))
	bc016 = bc016 + val * 16
	xcode = xcode - val * 10
	val = xcode
	-- uluaLog('XPDR CPY4 ' .. tostring(val))
	bc016 = bc016 + val
	return bc016
end

function Wwtcas:FakeXpdrGet()
	local FakeXpdr = 0
	if _G.WwtcasFakeXpdrKeyNum > 0 then
		for i = 1, _G.WwtcasFakeXpdrKeyNum do
			-- uluaLog(tostring(i) .. '---' .. tostring(_G.WwtcasFakeXpdrKeyTable[i]))
			FakeXpdr = FakeXpdr + (_G.WwtcasFakeXpdrKeyTable[i] * (10 ^ (_G.WwtcasFakeXpdrKeyNum - i)))
		end
		-- uluaLog('XPDR ' .. tostring(FakeXpdr))
	end
	return FakeXpdr, _G.WwtcasFakeXpdrKeyNum
end

function Wwtcas:FakeXpdrIsTimeOut()
	return os.clock() - _G.WwtcasFakeXpdrKeyIdleTime > WwtcasFakeXpdrKeyTimeOut
end

return Wwtcas
