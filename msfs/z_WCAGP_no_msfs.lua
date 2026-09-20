-- *****************************************************************
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-04-21
-- *****************************************************************

-- This scripts only runs when MSFS is not running

if ilua_require_msfs(false) then
	return
end

-- Do not remove below lines: hardware detection
local wcagp = com.sim.qm.Wcagp.Open()
if not wcagp then return end
-- Do not remove above lines: hardware detection



uluaLog('WinCtrl AGP offline clock')

local dr_digilight = iDataRef:New('cpuwolf/flyluaio/WwAgp/condbtn[10]')

-- wcagp:CfgEncFull(13, 15, 'cpuwolf/flyluaio/WwAgp/condbtn[10]', 10, 100, 2, 100, 250)


wcagp:GetBkl('cpuwolf/flyluaio/WwAgp/condbtn[9]', 1)
wcagp:GetDigiBkl('cpuwolf/flyluaio/WwAgp/condbtn[10]', 1)
wcagp:GetLedBkl('cpuwolf/flyluaio/WwAgp/condbtn[10]', 1)

wcagp:GetUlockL("cpuwolf/flyluaio/WwAgp/condbtn[9]")
wcagp:GetUlockN("cpuwolf/flyluaio/WwAgp/condbtn[9]")
wcagp:GetUlockR("cpuwolf/flyluaio/WwAgp/condbtn[9]")
wcagp:GetBrakeHot('cpuwolf/flyluaio/WwAgp/condbtn[9]')
wcagp:GetLockL("cpuwolf/flyluaio/WwAgp/condbtn[9]")
wcagp:GetLockN("cpuwolf/flyluaio/WwAgp/condbtn[9]")
wcagp:GetLockR("cpuwolf/flyluaio/WwAgp/condbtn[9]")
wcagp:GetBrakeOn('cpuwolf/flyluaio/WwAgp/keysmap[0]')
wcagp:GetLowD('cpuwolf/flyluaio/WwAgp/condbtn[9]')
wcagp:GetMedD('cpuwolf/flyluaio/WwAgp/condbtn[9]')
wcagp:GetMaxD('cpuwolf/flyluaio/WwAgp/condbtn[9]')
wcagp:GetLow('cpuwolf/flyluaio/WwAgp/condbtn[9]')
wcagp:GetMed('cpuwolf/flyluaio/WwAgp/condbtn[9]')
wcagp:GetMax('cpuwolf/flyluaio/WwAgp/condbtn[9]')
wcagp:GetTerr('cpuwolf/flyluaio/WwAgp/condbtn[9]')
wcagp:GetLever('cpuwolf/flyluaio/WwAgp/condbtn[9]')

local dr_utc_is_date = iDataRef:New('cpuwolf/flyluaio/WwAgp/keysmap[14]')
local dr_is_utc = iDataRef:New('cpuwolf/flyluaio/WwAgp/keysmap[17]')


--================================ When MSFS is not runinng, offline lua code
wcagp:FakeChrInit(2)
wcagp:FakeEtInit()
local systemtimestr = os.date("%H:%M:%S")
GlobalFrameLoopManager:add(function()
	dr_digilight:Set(200)
	wcagp:SetBkl()
	wcagp:SetDigiBkl()
	wcagp:SetLedBkl()
	--set LEDs
	wcagp:Setleds()
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
	wcagp:setLcdStr(wcagp:FakeChrShow(), systemtimestr, wcagp:FakeEtShow())
end)
