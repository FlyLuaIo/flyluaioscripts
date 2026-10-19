-- *****************************************************************
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-10-18_12_37_56UTC
-- *****************************************************************
-- Wwecam for FlightFactor A320 Ultimate
-- WWECAM key map (keep in sync with WWECAM_Toliss.lua):
--  1:TO CONFIG  3:EMER CANCEL(TODO)  4:ENG    5:BLEED  6:PRESS  7:ELEC
--  8:HYD        9:FUEL        10:APU   11:COND  12:DOOR  13:WHEEL
-- 14:FCTL      15:ALL         16:CLR(L) 18:STS  19:RCL   21:CLR(R)
-- (2/17/20 are not used by WWECAM_Toliss.lua either)

if ilua_require_ff320() then return end

-- Do not remove below lines: hardware detection
local wwecam = com.sim.qm.Wwecam.Open()
if not wwecam then return end
-- Do not remove above lines: hardware detection

uluaLog('Wwecam for FF320')

-- FF320 publishes its SDK commands/datarefs late, wait for them
if uluaFind("a320/Aircraft/Navigation/ATC/DisplayCode") == nil then
	-- FF320 is not ready yet
	ilua_req_reload()
	return
end

--------------------Input Keys Binding ---------------------

-- ECAM
-- TO CONFIG
wwecam:CfgCmd(1, 'a320/Pedestal/ECAM_Button1_button')
-- EMER CANCEL
-- TODO: QMPE_FF320 没有绑定 EMER CANCEL（FF320 侧也没验证过），先留空
-- 按钮编号顺序推测为 ECAM_Button2_button，实机确认后再打开下面一行
-- wwecam:CfgCmd(3, 'a320/Pedestal/ECAM_CancProt_switch+')
wwecam:CfgCmd(3, 'a320/Pedestal/ECAM_Button2_button')

-- ENG
wwecam:CfgCmd(4, 'a320/Pedestal/ECAM_Button3_button')
-- BLEED
wwecam:CfgCmd(5, 'a320/Pedestal/ECAM_Button4_button')
-- PRESS
wwecam:CfgCmd(6, 'a320/Pedestal/ECAM_Button5_button')

-- ELEC
wwecam:CfgCmd(7, 'a320/Pedestal/ECAM_Button6_button')
-- HYD
wwecam:CfgCmd(8, 'a320/Pedestal/ECAM_Button7_button')
-- FUEL
wwecam:CfgCmd(9, 'a320/Pedestal/ECAM_Button8_button')

-- APU
wwecam:CfgCmd(10, 'a320/Pedestal/ECAM_Button9_button')
-- COND
wwecam:CfgCmd(11, 'a320/Pedestal/ECAM_Button10_button')
-- DOOR
wwecam:CfgCmd(12, 'a320/Pedestal/ECAM_Button11_button')
-- WHEEL
wwecam:CfgCmd(13, 'a320/Pedestal/ECAM_Button12_button')
-- FCTL
wwecam:CfgCmd(14, 'a320/Pedestal/ECAM_Button13_button')

-- ALL
wwecam:CfgCmd(15, 'a320/Pedestal/ECAM_Button14_button')

-- CLR left
wwecam:CfgCmd(16, 'a320/Pedestal/ECAM_Button15_button')
-- STS
wwecam:CfgCmd(18, 'a320/Pedestal/ECAM_Button16_button')
-- RCL
wwecam:CfgCmd(19, 'a320/Pedestal/ECAM_Button17_button')

-- CLR right
-- FF320 has a single CLR button, QMPE has no separate F/O CLR command
wwecam:CfgCmd(21, 'a320/Pedestal/ECAM_Button15_button')

--------------------Output lights ---------------------
-- =====ECAM
wwecam:GetEEng('a320/Aircraft/Cockpit/Pedestal/ECAM_ButtonLight1/Intensity')
wwecam:GetEBleed('a320/Aircraft/Cockpit/Pedestal/ECAM_ButtonLight2/Intensity')
wwecam:GetEPress('a320/Aircraft/Cockpit/Pedestal/ECAM_ButtonLight3/Intensity')
wwecam:GetEElec('a320/Aircraft/Cockpit/Pedestal/ECAM_ButtonLight4/Intensity')
wwecam:GetEHyd('a320/Aircraft/Cockpit/Pedestal/ECAM_ButtonLight5/Intensity')
wwecam:GetEFuel('a320/Aircraft/Cockpit/Pedestal/ECAM_ButtonLight6/Intensity')

wwecam:GetEApu('a320/Aircraft/Cockpit/Pedestal/ECAM_ButtonLight7/Intensity')
wwecam:GetECond('a320/Aircraft/Cockpit/Pedestal/ECAM_ButtonLight8/Intensity')
wwecam:GetEDoor('a320/Aircraft/Cockpit/Pedestal/ECAM_ButtonLight9/Intensity')
wwecam:GetEWheel('a320/Aircraft/Cockpit/Pedestal/ECAM_ButtonLight10/Intensity')
wwecam:GetEFctl('a320/Aircraft/Cockpit/Pedestal/ECAM_ButtonLight11/Intensity')

wwecam:GetEClrL('a320/Aircraft/Cockpit/Pedestal/ECAM_ButtonLight12/Intensity')
wwecam:GetEClrR('a320/Aircraft/Cockpit/Pedestal/ECAM_ButtonLight12/Intensity')
wwecam:GetESts('a320/Aircraft/Cockpit/Pedestal/ECAM_ButtonLight13/Intensity')

wwecam:GetBkl("model/material/pedestal", 255)

-- =====Annunciator test
-- TODO: FF320 的 annunciator test 数据（Toliss 用 AirbusFBW/AnnunMode==2）尚未查证，
-- 查到后在下面的帧循环里加 SetTest() 分支
local dr_power = iDataRef:New("sim/cockpit2/switches/avionics_power_on") -- 0: OFF >0: ON

GlobalFrameLoopManager:add(function()
	-- expert code: cold and dark
	if dr_power:ChangedUpdate() then
		local b_power = dr_power:GetOld()
		if b_power == 0 then
			wwecam:PowerOff()
			return
		else
			wwecam:FreshBkl()
		end
	end

	-- brightness
	wwecam:SetBkl()
	wwecam:SetEcam()
end)
