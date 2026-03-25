
-- *****************************************************************
-- Don't modify this file, Most of the code is auto generated
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-03-25_12_39_31UTC
-- *****************************************************************

local Stkradio = oop.class(com.sim.Qmdev)
function Stkradio:init()
    self.QmdevId = 0x67E6B0B
	self.FastTurnsPerSecond = 5
	if _G.ilua_hw_assigned_stkradio == nil then
		_G.ilua_hw_assigned_stkradio = 0
	end
end

function Stkradio:absent(FastTurnsPerSecond)
	if not uluaFind('cpuwolf/qmdev/StkRadio/Radios/com1act1') then
		return true
	end
	_G.idr_stkradio_hid_radios_com1act1 = uluaFind('cpuwolf/qmdev/StkRadio/Radios/com1act1')
	_G.idr_stkradio_hid_radios_com1act2 = uluaFind('cpuwolf/qmdev/StkRadio/Radios/com1act2')
	_G.idr_stkradio_hid_radios_com1act3 = uluaFind('cpuwolf/qmdev/StkRadio/Radios/com1act3')
	_G.idr_stkradio_hid_radios_com1act4 = uluaFind('cpuwolf/qmdev/StkRadio/Radios/com1act4')
	_G.idr_stkradio_hid_radios_com1act5 = uluaFind('cpuwolf/qmdev/StkRadio/Radios/com1act5')
	_G.idr_stkradio_hid_radios_com1stb1 = uluaFind('cpuwolf/qmdev/StkRadio/Radios/com1stb1')
	_G.idr_stkradio_hid_radios_com1stb2 = uluaFind('cpuwolf/qmdev/StkRadio/Radios/com1stb2')
	_G.idr_stkradio_hid_radios_com1stb3 = uluaFind('cpuwolf/qmdev/StkRadio/Radios/com1stb3')
	_G.idr_stkradio_hid_radios_com1stb4 = uluaFind('cpuwolf/qmdev/StkRadio/Radios/com1stb4')
	_G.idr_stkradio_hid_radios_com1stb5 = uluaFind('cpuwolf/qmdev/StkRadio/Radios/com1stb5')
	_G.idr_stkradio_hid_radios_com2act1 = uluaFind('cpuwolf/qmdev/StkRadio/Radios/com2act1')
	_G.idr_stkradio_hid_radios_com2act2 = uluaFind('cpuwolf/qmdev/StkRadio/Radios/com2act2')
	_G.idr_stkradio_hid_radios_com2act3 = uluaFind('cpuwolf/qmdev/StkRadio/Radios/com2act3')
	_G.idr_stkradio_hid_radios_com2act4 = uluaFind('cpuwolf/qmdev/StkRadio/Radios/com2act4')
	_G.idr_stkradio_hid_radios_com2act5 = uluaFind('cpuwolf/qmdev/StkRadio/Radios/com2act5')
	_G.idr_stkradio_hid_radios_com2stb1 = uluaFind('cpuwolf/qmdev/StkRadio/Radios/com2stb1')
	_G.idr_stkradio_hid_radios_com2stb2 = uluaFind('cpuwolf/qmdev/StkRadio/Radios/com2stb2')
	_G.idr_stkradio_hid_radios_com2stb3 = uluaFind('cpuwolf/qmdev/StkRadio/Radios/com2stb3')
	_G.idr_stkradio_hid_radios_com2stb4 = uluaFind('cpuwolf/qmdev/StkRadio/Radios/com2stb4')
	_G.idr_stkradio_hid_radios_com2stb5 = uluaFind('cpuwolf/qmdev/StkRadio/Radios/com2stb5')
	_G.idr_stkradio_hid_invalid = uluaFind('cpuwolf/qmdev/StkRadio/invalid')
	_G.idr_stkradio_hid_fastkeypersec = uluaFind('cpuwolf/qmdev/StkRadio/fastkeypersec')
	return false
end

function Stkradio:Init()
	if self:absent(self.FastTurnsPerSecond) then
		return false
	end
	if _G.ilua_hw_assigned_stkradio == 1 then
		return false
	end
	_G.ilua_hw_assigned_stkradio = 1
	return true
end

return Stkradio