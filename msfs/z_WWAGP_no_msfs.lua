-- *****************************************************************
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-04-21
-- *****************************************************************

-- This scripts only runs when MSFS is not running

if uluaFind("(A:CIRCUIT AVIONICS ON,Bool)") ~= nil then
	return
end

-- Do not remove below lines: hardware detection
local wwagp = com.sim.qm.Wwagp:new()
if not wwagp:Init() then
	return
end
-- Do not remove above lines: hardware detection



uluaLog('WinWing AGP offline clock')

local dr_digilight = iDataRef:New('cpuwolf/qmdev/WwAgp/condbtn[10]')
dr_digilight:Set(200)

wwagp:CfgEncFull(13, 15, 'cpuwolf/qmdev/WwAgp/condbtn[10]', 10, 100, 1, 100, 200)

wwagp:GetDigiBkl('cpuwolf/qmdev/WwAgp/condbtn[10]', 1)

local dr_utc_is_date = iDataRef:New('cpuwolf/qmdev/WwAgp/keysmap[14]')
local dr_is_utc = iDataRef:New('cpuwolf/qmdev/WwAgp/keysmap[17]')


--================================ When MSFS is not runinng, offline lua code
local systemtimestr = os.date("%H:%M:%S")
function Wwagp_sdk_off_LCD_Loop()
	wwagp:SetDigiBkl()
	local is_utc = dr_is_utc:Get()
	if dr_utc_is_date:Get() > 0 then
		if is_utc > 0 then
			systemtimestr = os.date("!%m.%d.%y")
		else
			systemtimestr = os.date("%m.%d.%y")
		end
	else
		if is_utc > 0 then
			systemtimestr = os.date("!%H:%M:%S")
		else
			systemtimestr = os.date("%H:%M:%S")
		end
	end

	-- Write to hardware
	wwagp:setLcdStr("     ", systemtimestr, "     ")
end

uluaAddDoLoop('Wwagp_sdk_off_LCD_Loop()')
