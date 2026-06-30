-- *****************************************************************
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-04-21
-- *****************************************************************

-- This scripts only runs when MSFS is not running

if ilua_require_msfs(false) then
	return
end

-- Do not remove below lines: hardware detection
local wwagp = com.sim.qm.Wwagp:new()
if not wwagp:Init() then
	return
end
-- Do not remove above lines: hardware detection



uluaLog('WinWing AGP offline clock')

local dr_digilight = iDataRef:New('cpuwolf/flyluaio/WwAgp/condbtn[10]')

-- wwagp:CfgEncFull(13, 15, 'cpuwolf/flyluaio/WwAgp/condbtn[10]', 10, 100, 2, 100, 250)


wwagp:GetBkl('cpuwolf/flyluaio/WwAgp/condbtn[9]', 1)
wwagp:GetDigiBkl('cpuwolf/flyluaio/WwAgp/condbtn[10]', 1)
wwagp:GetLedBkl('cpuwolf/flyluaio/WwAgp/condbtn[10]', 1)

wwagp:GetUlockL("cpuwolf/flyluaio/WwAgp/condbtn[9]")
wwagp:GetUlockN("cpuwolf/flyluaio/WwAgp/condbtn[9]")
wwagp:GetUlockR("cpuwolf/flyluaio/WwAgp/condbtn[9]")
wwagp:GetBrakeHot('cpuwolf/flyluaio/WwAgp/condbtn[9]')
wwagp:GetLockL("cpuwolf/flyluaio/WwAgp/condbtn[9]")
wwagp:GetLockN("cpuwolf/flyluaio/WwAgp/condbtn[9]")
wwagp:GetLockR("cpuwolf/flyluaio/WwAgp/condbtn[9]")
wwagp:GetBrakeOn('cpuwolf/flyluaio/WwAgp/keysmap[0]')
wwagp:GetLowD('cpuwolf/flyluaio/WwAgp/condbtn[9]')
wwagp:GetMedD('cpuwolf/flyluaio/WwAgp/condbtn[9]')
wwagp:GetMaxD('cpuwolf/flyluaio/WwAgp/condbtn[9]')
wwagp:GetLow('cpuwolf/flyluaio/WwAgp/condbtn[9]')
wwagp:GetMed('cpuwolf/flyluaio/WwAgp/condbtn[9]')
wwagp:GetMax('cpuwolf/flyluaio/WwAgp/condbtn[9]')
wwagp:GetTerr('cpuwolf/flyluaio/WwAgp/condbtn[9]')
wwagp:GetLever('cpuwolf/flyluaio/WwAgp/condbtn[9]')

local dr_utc_is_date = iDataRef:New('cpuwolf/flyluaio/WwAgp/keysmap[14]')
local dr_is_utc = iDataRef:New('cpuwolf/flyluaio/WwAgp/keysmap[17]')


--================================ When MSFS is not runinng, offline lua code
wwagp:FakeChrInit(2)
wwagp:FakeEtInit()
local systemtimestr = os.date("%H:%M:%S")
GlobalFrameLoopManager:add(function()
	dr_digilight:Set(200)
	wwagp:SetBkl()
	wwagp:SetDigiBkl()
	wwagp:SetLedBkl()
	--set LEDs
	wwagp:Setleds()
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
	wwagp:setLcdStr(wwagp:FakeChrShow(), systemtimestr, wwagp:FakeEtShow())
end)
