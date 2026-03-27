-- *****************************************************************
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-03-26_07_32_41UTC
-- *****************************************************************

-- Do not remove below lines: hardware detection
local stkradio = com.sim.qm.Stkradio:new()
if not stkradio:Init() then
	return
end
-- Do not remove above lines: hardware detection

uluaLog("Stkradio for GA")



-- 13:DEC 12:INC
function stkradio_mode_cfg_com1(idn, iup, odn, oup, swap)
	---- RMP1
	-- inner
	stkradio:CfgCmd(idn, "sim/radios/stby_com1_fine_down_833")
	stkradio:CfgCmd(iup, "sim/radios/stby_com1_fine_up_833")
	-- outer
	stkradio:CfgCmd(odn, "sim/radios/stby_com1_coarse_down")
	stkradio:CfgCmd(oup, "sim/radios/stby_com1_coarse_up")
	-- flip
	stkradio:CfgCmd(swap, "sim/radios/com1_standy_flip")
end

function stkradio_mode_cfg_com2(idn, iup, odn, oup, swap)
	---- RMP2
	-- inner
	stkradio:CfgCmd(idn, "sim/radios/stby_com2_fine_down_833")
	stkradio:CfgCmd(iup, "sim/radios/stby_com2_fine_up_833")
	-- outer
	stkradio:CfgCmd(odn, "sim/radios/stby_com2_coarse_down")
	stkradio:CfgCmd(oup, "sim/radios/stby_com2_coarse_up")
	-- flip
	stkradio:CfgCmd(swap, "sim/radios/com2_standy_flip")
end

function stkradio_mode_cfg_nav1(idn, iup, odn, oup, swap)
	-- inner
	stkradio:CfgCmd(idn, 'sim/radios/stby_nav1_fine_down')
	stkradio:CfgCmd(iup, 'sim/radios/stby_nav1_fine_up')
	-- outer	
	stkradio:CfgCmd(odn, 'sim/radios/stby_nav1_coarse_down')
	stkradio:CfgCmd(oup, 'sim/radios/stby_nav1_coarse_up')
	-- flip	
	stkradio:CfgCmd(swap, 'sim/radios/nav1_standy_flip')
end

function stkradio_mode_cfg_nav2(idn, iup, odn, oup, swap)
	-- inner
	stkradio:CfgCmd(idn, 'sim/radios/stby_nav2_fine_down')
	stkradio:CfgCmd(iup, 'sim/radios/stby_nav2_fine_up')
	-- outer	
	stkradio:CfgCmd(odn, 'sim/radios/stby_nav2_coarse_down')
	stkradio:CfgCmd(oup, 'sim/radios/stby_nav2_coarse_up')
	-- flip	
	stkradio:CfgCmd(swap, 'sim/radios/nav2_standy_flip')
end

function stkradio_mode_cfg_adf(idn, iup, odn, oup, swap)
	-- inner
	stkradio:CfgCmd(idn, 'sim/radios/stby_adf1_ones_tens_down')
	stkradio:CfgCmd(iup, 'sim/radios/stby_adf1_ones_tens_up')
	-- outer	
	stkradio:CfgCmd(odn, 'sim/radios/stby_adf1_hundreds_thous_down')
	stkradio:CfgCmd(oup, 'sim/radios/stby_adf1_hundreds_thous_up')
	-- flip	
	stkradio:CfgCmd(swap, 'sim/radios/adf1_standy_flip')
end

function stkradio_mode_cfg_dme(idn, iup, odn, oup, swap)
	-- inner
	stkradio:CfgCmd(idn, 'sim/radios/obs1_down')
	stkradio:CfgCmd(iup, 'sim/radios/obs1_up')
	-- outer	
	stkradio:CfgCmd(odn, 'sim/operation/test_none')
	stkradio:CfgCmd(oup, 'sim/operation/test_none')
	-- flip	
	stkradio:CfgCmd(swap, 'sim/GPS/g430n1_cdi')
end

function stkradio_mode_cfg_xpdr(idn, iup, odn, oup, swap)
	-- inner
	stkradio:CfgCmd(idn, 'sim/transponder/transponder_34_down')
	stkradio:CfgCmd(iup, 'sim/transponder/transponder_34_up')
	-- outer	
	stkradio:CfgCmd(odn, 'sim/transponder/transponder_12_down')
	stkradio:CfgCmd(oup, 'sim/transponder/transponder_12_up')
	-- flip	
	stkradio:CfgCmd(swap, 'sim/transponder/transponder_ident')
end

-- 0:COM1 1:COM2 2:NAV1 3:NAV2 4:ADF 5:DME 6:XPDR
stkradio:CfgFc(0, 'stkradio_mode_cfg_com1(17, 16, 19, 18, 14)')
stkradio:CfgFc(1, 'stkradio_mode_cfg_com2(17, 16, 19, 18, 14)')
stkradio:CfgFc(2, 'stkradio_mode_cfg_nav1(17, 16, 19, 18, 14)')
stkradio:CfgFc(3, 'stkradio_mode_cfg_nav2(17, 16, 19, 18, 14)')
stkradio:CfgFc(4, 'stkradio_mode_cfg_adf(17, 16, 19, 18, 14)')
stkradio:CfgFc(5, 'stkradio_mode_cfg_dme(17, 16, 19, 18, 14)')
stkradio:CfgFc(6, 'stkradio_mode_cfg_xpdr(17, 16, 19, 18, 14)')
local dr_mode1_com1 = iDataRef:New('cpuwolf/qmdev/StkRadio/keysmap[0]')
local dr_mode1_com2 = iDataRef:New('cpuwolf/qmdev/StkRadio/keysmap[1]')
local dr_mode1_nav1 = iDataRef:New('cpuwolf/qmdev/StkRadio/keysmap[2]')
local dr_mode1_nav2 = iDataRef:New('cpuwolf/qmdev/StkRadio/keysmap[3]')
local dr_mode1_adf = iDataRef:New('cpuwolf/qmdev/StkRadio/keysmap[4]')
local dr_mode1_dme = iDataRef:New('cpuwolf/qmdev/StkRadio/keysmap[5]')
local dr_mode1_xpdr = iDataRef:New('cpuwolf/qmdev/StkRadio/keysmap[6]')

-- 7:COM1 8:COM2 9:NAV1 10:NAV2 11:ADF 12:DME 13:XPDR
stkradio:CfgFc(7, 'stkradio_mode_cfg_com1(21, 20, 23, 22, 15)')
stkradio:CfgFc(8, 'stkradio_mode_cfg_com2(21, 20, 23, 22, 15)')
stkradio:CfgFc(9, 'stkradio_mode_cfg_nav1(21, 20, 23, 22, 15)')
stkradio:CfgFc(10, 'stkradio_mode_cfg_nav2(21, 20, 23, 22, 15)')
stkradio:CfgFc(11, 'stkradio_mode_cfg_adf(21, 20, 23, 22, 15)')
stkradio:CfgFc(12, 'stkradio_mode_cfg_dme(21, 20, 23, 22, 15)')
stkradio:CfgFc(13, 'stkradio_mode_cfg_xpdr(21, 20, 23, 22, 15)')
local dr_mode2_com1 = iDataRef:New('cpuwolf/qmdev/StkRadio/keysmap[7]')
local dr_mode2_com2 = iDataRef:New('cpuwolf/qmdev/StkRadio/keysmap[8]')
local dr_mode2_nav1 = iDataRef:New('cpuwolf/qmdev/StkRadio/keysmap[9]')
local dr_mode2_nav2 = iDataRef:New('cpuwolf/qmdev/StkRadio/keysmap[10]')
local dr_mode2_adf = iDataRef:New('cpuwolf/qmdev/StkRadio/keysmap[11]')
local dr_mode2_dme = iDataRef:New('cpuwolf/qmdev/StkRadio/keysmap[12]')
local dr_mode2_xpdr = iDataRef:New('cpuwolf/qmdev/StkRadio/keysmap[13]')

-- =====RMP radio
local dr_com1a = iDataRef:New("sim/cockpit2/radios/actuators/com1_frequency_hz_833")
local dr_com1s = iDataRef:New("sim/cockpit2/radios/actuators/com1_standby_frequency_hz_833")
local dr_com2a = iDataRef:New("sim/cockpit2/radios/actuators/com2_frequency_hz_833")
local dr_com2s = iDataRef:New("sim/cockpit2/radios/actuators/com2_standby_frequency_hz_833")
--nav
local dr_nav1a = iDataRef:New("sim/cockpit/radios/nav1_freq_hz")
local dr_nav1s = iDataRef:New("sim/cockpit/radios/nav1_stdby_freq_hz")
local dr_nav2a = iDataRef:New("sim/cockpit/radios/nav2_freq_hz")
local dr_nav2s = iDataRef:New("sim/cockpit/radios/nav2_stdby_freq_hz")
-- adf
local dr_adfa = iDataRef:New("sim/cockpit/radios/adf1_freq_hz")
local dr_adfs = iDataRef:New("sim/cockpit/radios/adf1_stdby_freq_hz")

-- dme
local dr_dmea = iDataRef:New("sim/cockpit/radios/nav1_dme_dist_m")
local dr_dmes = iDataRef:New("sim/cockpit/radios/nav2_dme_dist_m")
-- transponder
local dr_xpdr = iDataRef:New('sim/cockpit/radios/transponder_code')

function Stkradio_GA_Loop_Upd()
	-- update radio up
	if dr_mode1_com1:Get() > 0 then
		stkradio:setCom1A(stkradio:encRadioDigits(dr_com1a:Get()))
		stkradio:setCom1S(stkradio:encRadioDigits(dr_com1s:Get()))
	elseif dr_mode1_com2:Get() > 0 then
		stkradio:setCom1A(stkradio:encRadioDigits(dr_com2a:Get()))
		stkradio:setCom1S(stkradio:encRadioDigits(dr_com2s:Get()))
	elseif dr_mode1_nav1:Get() > 0 then
		stkradio:setCom1A(stkradio:encRadioDigits(dr_nav1a:Get()))
		stkradio:setCom1S(stkradio:encRadioDigits(dr_nav1s:Get()))
	elseif dr_mode1_nav2:Get() > 0 then
		stkradio:setCom1A(stkradio:encRadioDigits(dr_nav2a:Get()))
		stkradio:setCom1S(stkradio:encRadioDigits(dr_nav2s:Get()))
	elseif dr_mode1_adf:Get() > 0 then
		stkradio:setCom1A(stkradio:encRadioDigits(dr_adfa:Get()))
		stkradio:setCom1S(stkradio:encRadioDigits(dr_adfs:Get()))
	elseif dr_mode1_dme:Get() > 0 then
		stkradio:setCom1A(stkradio:encFloatDigits(dr_adfa:Get()))
		stkradio:setCom1S(stkradio:encFloatDigits(dr_adfs:Get()))
	elseif dr_mode1_xpdr:Get() > 0 then
		local d_xpdr = stkradio:encIntDigits(dr_xpdr:Get())
		stkradio:setCom1A(d_xpdr)
		stkradio:setCom1S(d_xpdr)
	end

	-- update radio down
	if dr_mode2_com1:Get() > 0 then
		stkradio:setCom2A(stkradio:encRadioDigits(dr_com1a:Get()))
		stkradio:setCom2S(stkradio:encRadioDigits(dr_com1s:Get()))
	elseif dr_mode2_com2:Get() > 0 then
		stkradio:setCom2A(stkradio:encRadioDigits(dr_com2a:Get()))
		stkradio:setCom2S(stkradio:encRadioDigits(dr_com2s:Get()))
	elseif dr_mode2_nav1:Get() > 0 then
		stkradio:setCom2A(stkradio:encRadioDigits(dr_nav1a:Get()))
		stkradio:setCom2S(stkradio:encRadioDigits(dr_nav1s:Get()))
	elseif dr_mode2_nav2:Get() > 0 then
		stkradio:setCom2A(stkradio:encRadioDigits(dr_nav2a:Get()))
		stkradio:setCom2S(stkradio:encRadioDigits(dr_nav2s:Get()))
	elseif dr_mode2_adf:Get() > 0 then
		stkradio:setCom2A(stkradio:encRadioDigits(dr_adfa:Get()))
		stkradio:setCom2S(stkradio:encRadioDigits(dr_adfs:Get()))
	elseif dr_mode2_dme:Get() > 0 then
		stkradio:setCom2A(stkradio:encFloatDigits(dr_adfa:Get()))
		stkradio:setCom2S(stkradio:encFloatDigits(dr_adfs:Get()))
	elseif dr_mode2_xpdr:Get() > 0 then
		local d_xpdr = stkradio:encIntDigits(dr_xpdr:Get())
		stkradio:setCom2A(d_xpdr)
		stkradio:setCom2S(d_xpdr)
	end
end

uluaAddDoLoop("Stkradio_GA_Loop_Upd()")
