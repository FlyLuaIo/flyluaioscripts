-- *****************************************************************
-- Don't modify this file, unless you know what you are doing
-- Most of the code are auto generated
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-05-25
-- *****************************************************************

local MobiFlight = oop.class(com.sim.Qmdev)
function MobiFlight:init()
	self.FastTurnsPerSecond = 10
	self.counter = 0
	self.timestamp = uluagetTimestamp()
	self.ms = 800
end

return MobiFlight
