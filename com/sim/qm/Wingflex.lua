-- *****************************************************************
-- Don't modify this file, unless you know what you are doing
-- Most of the code are auto generated
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-05-25
-- *****************************************************************

local Wingflex = oop.class(com.sim.Qmdev)
function Wingflex:init()
	self.FastTurnsPerSecond = 10
	self.counter = 0
	self.timestamp = uluagetTimestamp()
	self.ms = 800
end


-- ========
-- wingFlex old firmware force update interval < 1000ms
function Wingflex:NeedFresh()
	local stp = uluagetTimestamp()
	if stp - self.timestamp > self.ms then
		self.timestamp = stp
		self.counter = (self.counter + 1) % 2
		return true
	end
	return false
end

return Wingflex
