-- *****************************************************************
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-08-10
-- MobiFlight CfNano / cfmfnano for PMDG 737
-- Segment: PMDG char[] → 6-digit number (GA ENG RPM)
-- *****************************************************************
if ilua_require_pmdg_737() then return end

-- Do not remove below lines: hardware detection
local cfnano = com.sim.mf.CfNano.Open()
if not cfnano then return end
-- Do not remove above lines: hardware detection

uluaLog('MobiFlight CfNano for PMDG 737')

-- PMDG char[] (ASCII per index) → number
local function pmdg_open_chars(path, n)
	local drs = {}
	for i = 0, n - 1 do
		local dr = iDataRef:New(string.format('%s[%d]', path, i))
		if not dr then return nil end
		drs[i] = dr
	end
	return drs
end

local function pmdg_chars_getnum(drs, n)
	local t = {}
	for i = 0, n - 1 do
		local c = drs[i]:Get()
		if c and c ~= 0 then
			t[#t + 1] = string.char(math.floor(c))
		end
	end
	return tonumber(table.concat(t)) or 0
end

local function pmdg_chars_changed(drs, n)
	local ch = false
	for i = 0, n - 1 do
		if drs[i]:ChangedUpdate() then ch = true end
	end
	return ch
end

-- AIR FLT ALT ("35500") fits 6 digits as-is
local dr_flt_alt = pmdg_open_chars('pmdg/ng3/data/AIR_DisplayFltAlt', 6)

GlobalFrameLoopManager:add(function()
	if dr_flt_alt and pmdg_chars_changed(dr_flt_alt, 6) then
		cfnano:SetGaEngRpm(pmdg_chars_getnum(dr_flt_alt, 6))
	end
end)
