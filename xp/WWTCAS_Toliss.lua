-- *****************************************************************
-- WwTcas for Toliss (ported from WINCTRL toliss-tcas-profile)
-- *****************************************************************

if ilua_require_toliss() then return end

-- Do not remove below lines: hardware detection
local wwtcas = com.sim.qm.Wwtcas.Open()
if not wwtcas then return end
-- Do not remove above lines: hardware detection

uluaLog('Wwtcas for Toliss')

local icao = PLANE_ICAO or ''
local isWide = (icao == 'A339' or icao == 'A346')

-------------------- Input Keys Binding ---------------------
wwtcas:CfgCmd(0, 'AirbusFBW/ATCCodeKey1')
wwtcas:CfgCmd(1, 'AirbusFBW/ATCCodeKey2')
wwtcas:CfgCmd(2, 'AirbusFBW/ATCCodeKey3')
wwtcas:CfgCmd(3, 'AirbusFBW/ATCCodeKey4')
wwtcas:CfgCmd(4, 'AirbusFBW/ATCCodeKey5')
wwtcas:CfgCmd(5, 'AirbusFBW/ATCCodeKey6')
wwtcas:CfgCmd(6, 'AirbusFBW/ATCCodeKey7')
wwtcas:CfgCmd(7, 'AirbusFBW/ATCCodeKey0')
wwtcas:CfgCmd(8, 'AirbusFBW/ATCCodeKeyCLR')
wwtcas:CfgCmd(9, 'sim/transponder/transponder_ident')

if isWide then
	wwtcas:CfgVal(10, 'AirbusFBW/XPDRPower', 0)
	wwtcas:CfgVal(11, 'AirbusFBW/XPDRPower', 1)
	wwtcas:CfgVal(12, 'AirbusFBW/XPDRPower', 2)
	wwtcas:CfgVal(13, 'AirbusFBW/XPDRSystem', 1)
	wwtcas:CfgVal(14, 'AirbusFBW/XPDRSystem', 2)
	wwtcas:CfgVal(15, 'AirbusFBW/XPDRAltitude', 0)
	wwtcas:CfgVal(16, 'AirbusFBW/XPDRAltitude', 1)
	wwtcas:CfgVal(17, 'AirbusFBW/XPDRTCASAltSelect', -1)
	wwtcas:CfgVal(18, 'AirbusFBW/XPDRTCASAltSelect', 0)
	wwtcas:CfgVal(19, 'AirbusFBW/XPDRTCASAltSelect', 1)
	wwtcas:CfgVal(21, 'AirbusFBW/XPDRTCASMode', 0)
	wwtcas:CfgVal(22, 'AirbusFBW/XPDRTCASMode', 1)
	wwtcas:CfgVal(23, 'AirbusFBW/XPDRTCASMode', 2)
else
	wwtcas:CfgVal(10, 'AirbusFBW/XPDRPower', 0)
	wwtcas:CfgVal(11, 'AirbusFBW/XPDRTCASMode', 0)
	wwtcas:CfgVal(12, 'AirbusFBW/XPDRTCASMode', 1)
	wwtcas:CfgVal(13, 'AirbusFBW/XPDRSystem', 1)
	wwtcas:CfgVal(14, 'AirbusFBW/XPDRSystem', 2)
	wwtcas:CfgVal(18, 'AirbusFBW/XPDRTCASAltSelect', 1)
	wwtcas:CfgVal(19, 'AirbusFBW/XPDRTCASAltSelect', 0)
	wwtcas:CfgVal(20, 'AirbusFBW/XPDRTCASAltSelect', 2)
	wwtcas:CfgVal(21, 'AirbusFBW/XPDRPower', 0)
	wwtcas:CfgVal(22, 'AirbusFBW/XPDRPower', 3)
	wwtcas:CfgVal(23, 'AirbusFBW/XPDRPower', 4)
end

-------------------- Output ---------------------
local dr_power = iDataRef:New('sim/cockpit/electrical/avionics_on')
local dr_annun = iDataRef:New('AirbusFBW/AnnunMode')
local dr_xpdr = iDataRef:New('AirbusFBW/XPDRString')

wwtcas:GetBkl('AirbusFBW/PanelBrightnessLevel', 250)
wwtcas:GetLcdBkl('sim/cockpit2/switches/avionics_power_on', 250) -- 0~1
wwtcas:GetLedBkl('sim/cockpit2/switches/avionics_power_on', 250) -- 0~1

wwtcas:GetAtcFail("AirbusFBW/OHPLightsATA31[1]", false, 0.1)

wwtcas:setLcdText('----')
GlobalFrameLoopManager:add(function()
	local hasPower
	if dr_power:ChangedUpdate() then
		hasPower = dr_power:GetOld() ~= 0
		if not hasPower then
			wwtcas:SetBkl(0)
			wwtcas:SetLcdBkl(0)
		else
			wwtcas:FreshBkl()
			wwtcas:FreshLcdBkl()
		end
	else
		hasPower = dr_power:Get() ~= 0
	end

	if not hasPower then
		return
	end

	wwtcas:SetBkl()
	wwtcas:SetLcdBkl()
	wwtcas:SetLedBkl()
	wwtcas:SetAtcFail()

	local test = (dr_annun:Get() == 2) and hasPower

	local code = tostring(dr_xpdr:Get())
	wwtcas:setLcdText(code)
end)
