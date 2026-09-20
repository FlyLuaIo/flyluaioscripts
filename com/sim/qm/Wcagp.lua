-- *****************************************************************
-- Don't modify this file, unless you know what you are doing
-- Most of the code are auto generated
-- created by Wei Shuai <cpuwolf@gmail.com> 2026-09-20
-- *****************************************************************

local Wcagp = oop.class(com.sim.qm.Wwagp)

function Wcagp:init()
	uluaLog('Wcagp:init')
	self.QmdevId = 0x158040CC
end

function Wcagp.Open(...)
	return com.sim.Qmdev.Open(Wcagp, ...)
end

return Wcagp
