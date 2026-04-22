-- *****************************************************************
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-04-21_09_15_13UTC
-- *****************************************************************


if ilua_is_acftitle_excluded("A3") or ilua_is_acfpath_excluded("toliss") then
	if ilua_is_acftitle_excluded("A2") or ilua_is_acfpath_excluded("toliss") then
		return
	end
end

-- Do not remove below lines: hardware detection
local wffcuc = com.sim.qm.Wffcuc:new()
if not wffcuc:Init() then
	return
end
-- Do not remove above lines: hardware detection

uluaLog('Wffcuc for Toliss')

wffcuc:GetLoc('AirbusFBW/FCUAvail')
wffcuc:GetAp1('AirbusFBW/FCUAvail')
wffcuc:GetAp2('AirbusFBW/FCUAvail')
wffcuc:GetAthr('AirbusFBW/FCUAvail')
wffcuc:GetExped('AirbusFBW/FCUAvail')
wffcuc:GetAppr('AirbusFBW/FCUAvail')
wffcuc:GetSpdmang('AirbusFBW/FCUAvail')
wffcuc:GetSpddash('AirbusFBW/FCUAvail')
wffcuc:GetHdgmang('AirbusFBW/FCUAvail')
wffcuc:GetHdgdash('AirbusFBW/FCUAvail')
wffcuc:GetAltmang('AirbusFBW/FCUAvail')
wffcuc:GetVsdash('AirbusFBW/FCUAvail')
wffcuc:GetSpdmach('AirbusFBW/FCUAvail')
wffcuc:GetHdgtrk('AirbusFBW/FCUAvail')
wffcuc:GetTest('AirbusFBW/AnnunMode')
wffcuc:GetPower('AirbusFBW/FCUAvail')


local counter = 0
function Wffcuc_Toliss_Loop_Upd()
	wffcuc:SetLeds()
	counter = (counter + 1) % 256
	uluaSet(_G.idr_wffcuc_hid_invalid, counter)
end

uluaAddDoLoop('Wffcuc_Toliss_Loop_Upd()')
