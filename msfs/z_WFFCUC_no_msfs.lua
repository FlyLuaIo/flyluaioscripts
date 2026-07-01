-- *****************************************************************
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-04-23
-- *****************************************************************
if ilua_require_msfs(false) then
	return
end

-- Do not remove below lines: hardware detection
local wffcuc = com.sim.wf.Wffcuc.Open()
if not wffcuc then return end
-- Do not remove above lines: hardware detection

-- offline lua running, check MSFS is off
if uluaFind("(A:CIRCUIT AVIONICS ON,Bool)") == nil then
	wffcuc.ms = 30
end

uluaLog('Wffcuc for offline clock')


wffcuc:GetVs('cpuwolf/flyluaio/WfFcuc/condbtn[1]')
-- brightness
wffcuc:GetBkl("cpuwolf/flyluaio/WfFcuc/condbtn[1]", 0.1) -- 0~1
wffcuc:GetLcdBkl('cpuwolf/flyluaio/WfFcuc/condbtn[2]', 250)

-- LEDs
wffcuc:GetVsdash('cpuwolf/flyluaio/WfFcuc/condbtn[0]')
-- power
wffcuc:GetTest('cpuwolf/flyluaio/WfFcuc/condbtn[1]')
wffcuc:GetPower('cpuwolf/flyluaio/WfFcuc/condbtn[0]')
local dr_power = iDataRef:New('cpuwolf/flyluaio/WfFcuc/condbtn[0]')
local dr_light = iDataRef:New('cpuwolf/flyluaio/WfFcuc/condbtn[2]')

GlobalFrameLoopManager:add(function()
	local dateTable = os.date("*t")
	local hour      = dateTable.hour
	local min       = dateTable.min
	local sec       = dateTable.sec
	dr_power:Set(1)
	dr_light:Set(1)
	wffcuc:SetVsdash()
	wffcuc:SetTest()
	wffcuc:SetPower()
	-- LCD display
	wffcuc:SetSpd(hour)
	wffcuc:SetHdg(min)
	wffcuc:SetAlt(sec)
	wffcuc:SetVs()
	-- backlight
	wffcuc:SetBkl()
	wffcuc:SetLcdBkl()
	--force refresh
	wffcuc:ForceFresh()
end)
