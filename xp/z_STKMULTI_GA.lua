
-- *****************************************************************
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-03-26_07_27_59UTC
-- *****************************************************************

-- Do not remove below lines: hardware detection
local stkmulti = com.sim.qm.Stkmulti:new()
if not stkmulti:Init() then
	return
end
-- Do not remove above lines: hardware detection

uluaLog("Stkmulti for GA")
--[[
stkmulti:GetAp('')
stkmulti:GetHdg('')
stkmulti:GetNav('')
stkmulti:GetIas('')
stkmulti:GetAlt('')
stkmulti:GetVs('')
stkmulti:GetApr('')
stkmulti:GetRev('')
]]--


function Stkmulti_GA_Loop_Upd()
	-- stkmulti:SetLeds()
end
uluaAddDoLoop("Stkmulti_GA_Loop_Upd()")
