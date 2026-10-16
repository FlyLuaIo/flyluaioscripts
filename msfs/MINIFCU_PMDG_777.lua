-- *****************************************************************
-- FlyLuaIO MobiFlight miniFCU (miniFCU + miniEFIS) for MSFS
-- PMDG 777（波音 MCP 内核；用空客形状的 miniFCU + miniEFIS 面板做降级映射）
-- created by Wei Shuai <cpuwolf@gmail.com>
-- *****************************************************************
-- 来源与依据（可追溯）：
--   * 事件码 / L 变量：msfs/QFCU_PMDG_777.lua（QFCU 的 PMDG 777 档，MSFS 实测通过）。
--     参考档已经把空客面板键位映射到 PMDG 777 的 ROTOR_BRAKE 事件码上，本档沿用同一套映射：
--     只把 QFCU 的 KeyIdx 换成 miniFCU 的 KeyIdx，RPN payload 逐字复制（含 ROTOR_BRAKE 数字码），
--     payload 的写法一律不“改进”。每条绑定后的 [Q#] 标注该功能在 QFCU 面板上的 KeyIdx。
--   * 硬件通道契约：mobiflight/MiniFCU.json（按键 bit 0–46、编码器 bit 47–66、
--     6 个 Output pin、26 条 CustomDevice 通道）。
--   * 通道语义 / 编码器位序：xp/MINIFCU_Toliss.lua（真机 miniFCU 在 X-Plane 上手工调过并实测）。
-- 编码器位序（沿用 XP 档，勿改）：每轴 4 bit，前 2 bit = 减，后 2 bit = 加。
--   ALT 47/48 减 · 49/50 加；SPD 51/52 · 53/54；HDG 55/56 · 57/58；VS 59/60 · 61/62；BARO 63/64 · 65/66
--   参考档没有 QFCU 的 CfgEnc，所以这里用 4 条 CfgRpn（同方向两条逐字相同）。
-- 三种键位换算（与 msfs/MINIFCU_FBW_A320NX.lua 的既定做法一致）：
--   1. ALT 100/1000 [Q15]：miniFCU 是瞬时按键 —— 按住 = 1000 ft 步长、松开 = 100 ft；
--      参考档（QFCU 侧是拨杆）注释写的正是 100:press / 1000:release，所以两个 payload 对调。
--   2. ADF/OFF/VOR 两组 [Q42–Q45]：QFCU 是两档拨杆（press/release 各驱动一个档位），
--      miniFCU 是三个独立按键 → 37/39/40/42 只发 press，38/41（OFF）发 release（参考档里
--      100 = ADF 档、0 = VOR 档、50 = 中位/OFF，与参考档 RPN 的基准值一致）。
--   3. 气压单位 [Q50]：QFCU 单键拨杆（参考档注释：inHg = press、hPa = release），miniFCU 是
--      43 = HPA / 44 = INHG 两个独立按键 → 43 只发 release 值，44 只发 press 值（同 FBW 档的对应关系）。
-- 已知取舍（待真机验证）：
--   1. QFCU 面板有两个 EFIS 半区（机长/副驾），miniFCU 只有机长半区，故 QFCU 的
--      51/52/53（副驾气压）与 56–79（副驾 EFIS）不移植。
--   2. 参考档被注释掉的键一律不绑定，也不自己发明事件码：QFCU 8（LOC）、12（EXPED）、
--      14（METRIC ALT）、41（LS）、35–39（ND 过滤灯）、7（HDG PULL）、22（VS PUSH）、
--      49（BARO PULL）、26（ROSE NAV）→ miniFCU 对应 bit 4/6/7/12/15/18/19/20/21/22/24/28/45 留空。
--   3. 无断电/背光门控：参考档只用 (L:BL_MCP) 驱动 QFCU 自己的背光通道，miniFCU 硬件没有
--      背光/熄灭通道，XP 档也没做，这里保持一致。
--   4. 显示通道：参考档的帧循环只读 5 个源（(L:ngx_SPDwindow) / (L:ngx_HDGwindow) /
--      (L:ngx_ALTwindow) / (L:ngx_VSwindow) + LED 状态变量）。777 上没有对应源的小屏通道
--      （managed 点、dashes、MACH 之外的 FPA、HDG/TRK 模式、EFIS 过滤灯、全部气压通道）
--      一律注册 '0' 并在帧循环里写 0，逐条标 TODO —— 这是预期情况，不是缺陷。
--   5. ALT 100/1000 两个 payload 的判据都读参考档自己的 (L:switch_225_a)（PMDG 的档位回读），
--      miniFCU 不驱动该变量：真机上按住那一路（switch_225_a == 0）生效，松开那一路是死分支。
--      与参考档一致，不做改写。
-- *****************************************************************

if ilua_require_msfs() then
	return
end
if ilua_require_pmdg_777() then return end

-- Do not remove below lines: hardware detection
local minifcu = com.sim.mf.MiniFCU.Open()
if not minifcu then return end
-- Do not remove above lines: hardware detection

uluaLog('MobiFlight MiniFCU for PMDG777')

-- ===========================================================
-- INPUT：FCU 半区（bit 0–17）
minifcu:CfgRpn(0, '20801 (>K:ROTOR_BRAKE)') -- SPD/MACH 显示切换 [Q55]
minifcu:CfgRpn(1, '21601 (>K:ROTOR_BRAKE)') -- HDG/TRK ↔ VS/FPA 切换 [Q54]
minifcu:CfgRpn(2, '21201 (>K:ROTOR_BRAKE)') -- AP1（VNAV） [Q10]
minifcu:CfgRpn(3, '21101 (>K:ROTOR_BRAKE)') -- AP2（LNAV） [Q9]

-- bit 4（METRIC ALT）[Q14]：参考档该键被注释掉（777 没有米制高度），
-- 按规格不发明事件码 —— 留空。
minifcu:CfgRpn(5, '20401 (>K:ROTOR_BRAKE) 20501 (>K:ROTOR_BRAKE)') -- A/THR；原样保留参考档的两个 ROTOR_BRAKE 码 [Q11]

-- bit 6（EXPED）[Q12] / bit 7（LOC）[Q8]：参考档这两个键都被注释掉，留空。
minifcu:CfgRpn(8, '22801 (>K:ROTOR_BRAKE)') -- APPR（APP） [Q13]
minifcu:CfgRpn(9, '210001 (>K:ROTOR_BRAKE)') -- SPD 旋钮 PUSH [Q2]
minifcu:CfgRpn(10, '20701 (>K:ROTOR_BRAKE)') -- SPD 旋钮 PULL（A/T 按钮） [Q3]
minifcu:CfgRpn(11, '21801 (>K:ROTOR_BRAKE)') -- HDG 旋钮 PUSH [Q6]

-- bit 12（HDG PULL）[Q7]：参考档被注释掉，留空。
minifcu:CfgRpn(13, '225101 (>K:ROTOR_BRAKE)') -- ALT 旋钮 PUSH [Q18]
minifcu:CfgRpn(14, '21301 (>K:ROTOR_BRAKE)') -- ALT 旋钮 PULL（FLCH） [Q19]

-- bit 15（VS PUSH）[Q22]：参考档被注释掉，留空。
minifcu:CfgRpn(16, '22301 (>K:ROTOR_BRAKE)') -- VS 旋钮 PULL（VS/FPA 按钮） [Q23]

-- ALT 100/1000 [Q15]：miniFCU 是瞬时按键 —— 按住 = 1000 ft 步长，松开回 100 ft；
-- 参考档注释是 100:press / 1000:release（QFCU 侧是拨杆），所以两个 payload 对调。
minifcu:CfgRpn(17, '(L:switch_225_a) 0 == if{ 22501 (>K:ROTOR_BRAKE) }',
	'(L:switch_225_a) 0 != if{ 22501 (>K:ROTOR_BRAKE) }')

-- ===========================================================
-- INPUT：EFIS 半区机长侧（bit 18–46）

-- FD（机长）[Q40]
minifcu:CfgRpn(23, '20201 (>K:ROTOR_BRAKE)') -- FD（机长） [Q40]

-- bit 18–22（CSTR / WPT / VORD / NDB / ARPT）[Q35–Q39]：参考档这五个键全被注释掉（777 上没有
-- 可用的 ND 过滤灯事件码），按规格留空、不发明。
-- bit 24（LS）[Q41]：参考档该键被注释掉（只有一句注释里的 B:AIRLINER_LS 写法），留空。
-- bit 25（CHRONO）：QFCU 面板没有这个键，参考档也无源，留空。
-- bit 28（ROSE NAV）[Q26]：参考档这一档是空注释，留空。

-- ROSE 模式键 [Q24 / Q25 / Q27 / Q28]：payload 逐字照抄（驱动 PMDG 的 (L:switch_185_a) 档位）
minifcu:CfgRpn(26, '0 (L:switch_185_a) - 10 div s0 :1 l0 0 > if{ 18507 (>K:ROTOR_BRAKE) l0 -- s0 g1 } l0 0 < if{ 18508 (>K:ROTOR_BRAKE) l0 ++ s0 g1 }') -- ROSE 模式 LS [Q24]
minifcu:CfgRpn(27, '10 (L:switch_185_a) - 10 div s0 :1 l0 0 > if{ 18507 (>K:ROTOR_BRAKE) l0 -- s0 g1 } l0 0 < if{ 18508 (>K:ROTOR_BRAKE) l0 ++ s0 g1 }') -- ROSE 模式 VOR [Q25]
minifcu:CfgRpn(29, '20 (L:switch_185_a) - 10 div s0 :1 l0 0 > if{ 18507 (>K:ROTOR_BRAKE) l0 -- s0 g1 } l0 0 < if{ 18508 (>K:ROTOR_BRAKE) l0 ++ s0 g1 }') -- ROSE 模式 ARC [Q27]
minifcu:CfgRpn(30, '30 (L:switch_185_a) - 10 div s0 :1 l0 0 > if{ 18507 (>K:ROTOR_BRAKE) l0 -- s0 g1 } l0 0 < if{ 18508 (>K:ROTOR_BRAKE) l0 ++ s0 g1 }') -- ROSE 模式 PLN [Q28]
-- 距离键 [Q29–Q34]：payload 逐字照抄（驱动 PMDG 的 (L:switch_187_a) 档位）
minifcu:CfgRpn(31, '0 (L:switch_187_a) - 10 div s0 :1 l0 0 > if{ 18707 (>K:ROTOR_BRAKE) l0 -- s0 g1 } l0 0 < if{ 18708 (>K:ROTOR_BRAKE) l0 ++ s0 g1 }') -- RANGE 10 [Q29]
minifcu:CfgRpn(32, '10 (L:switch_187_a) - 10 div s0 :1 l0 0 > if{ 18707 (>K:ROTOR_BRAKE) l0 -- s0 g1 } l0 0 < if{ 18708 (>K:ROTOR_BRAKE) l0 ++ s0 g1 }') -- RANGE 20 [Q30]
minifcu:CfgRpn(33, '20 (L:switch_187_a) - 10 div s0 :1 l0 0 > if{ 18707 (>K:ROTOR_BRAKE) l0 -- s0 g1 } l0 0 < if{ 18708 (>K:ROTOR_BRAKE) l0 ++ s0 g1 }') -- RANGE 40 [Q31]
minifcu:CfgRpn(34, '30 (L:switch_187_a) - 10 div s0 :1 l0 0 > if{ 18707 (>K:ROTOR_BRAKE) l0 -- s0 g1 } l0 0 < if{ 18708 (>K:ROTOR_BRAKE) l0 ++ s0 g1 }') -- RANGE 80 [Q32]
minifcu:CfgRpn(35, '40 (L:switch_187_a) - 10 div s0 :1 l0 0 > if{ 18707 (>K:ROTOR_BRAKE) l0 -- s0 g1 } l0 0 < if{ 18708 (>K:ROTOR_BRAKE) l0 ++ s0 g1 }') -- RANGE 160 [Q33]
minifcu:CfgRpn(36, '50 (L:switch_187_a) - 10 div s0 :1 l0 0 > if{ 18707 (>K:ROTOR_BRAKE) l0 -- s0 g1 } l0 0 < if{ 18708 (>K:ROTOR_BRAKE) l0 ++ s0 g1 }') -- RANGE 320 [Q34]

-- ADF / OFF / VOR 两组 [Q42–Q45]：QFCU 是两档拨杆，miniFCU 是三个独立按键。
-- 参考档 42/43（NAV1）与 44/45（NAV2）的 press 基准值 100 = ADF 档、0 = VOR 档，
-- 两键共用的 release 基准值 50 = 中位（OFF）→ 所以 38/41 直接发 release 的 payload。
minifcu:CfgRpn(37, '100 (L:switch_184_a) - 50 div s0 :1 l0 0 > if{ 18401 (>K:ROTOR_BRAKE) l0 -- s0 g1 } l0 0 < if{ 18402 (>K:ROTOR_BRAKE) l0 ++ s0 g1 }') -- ADF 1 [Q42]
minifcu:CfgRpn(38, '50 (L:switch_184_a) - 50 div s0 :1 l0 0 > if{ 18401 (>K:ROTOR_BRAKE) l0 -- s0 g1 } l0 0 < if{ 18402 (>K:ROTOR_BRAKE) l0 ++ s0 g1 }') -- OFF 1 [Q42]
minifcu:CfgRpn(39, '0 (L:switch_184_a) - 50 div s0 :1 l0 0 > if{ 18401 (>K:ROTOR_BRAKE) l0 -- s0 g1 } l0 0 < if{ 18402 (>K:ROTOR_BRAKE) l0 ++ s0 g1 }') -- VOR 1 [Q43]
minifcu:CfgRpn(40, '100 (L:switch_189_a) - 50 div s0 :1 l0 0 > if{ 18901 (>K:ROTOR_BRAKE) l0 -- s0 g1 } l0 0 < if{ 18902 (>K:ROTOR_BRAKE) l0 ++ s0 g1 }') -- ADF 2 [Q44]
minifcu:CfgRpn(41, '50 (L:switch_189_a) - 50 div s0 :1 l0 0 > if{ 18901 (>K:ROTOR_BRAKE) l0 -- s0 g1 } l0 0 < if{ 18902 (>K:ROTOR_BRAKE) l0 ++ s0 g1 }') -- OFF 2 [Q44]
minifcu:CfgRpn(42, '0 (L:switch_189_a) - 50 div s0 :1 l0 0 > if{ 18901 (>K:ROTOR_BRAKE) l0 -- s0 g1 } l0 0 < if{ 18902 (>K:ROTOR_BRAKE) l0 ++ s0 g1 }') -- VOR 2 [Q45]

-- 气压单位 [Q50]：参考档注释 inHg:pressed / hPa:released，故 43(HPA) 取 release、44(INHG) 取 press。
minifcu:CfgRpn(43, '(L:switch_190_a) 0 == if{ 19001 (>K:ROTOR_BRAKE) }') -- HPA [Q50 release]
minifcu:CfgRpn(44, '(L:switch_190_a) 0 != if{ 19001 (>K:ROTOR_BRAKE) }') -- INHG [Q50 press]

-- bit 45（气压旋钮 PULL）[Q49]：参考档被注释掉，留空。
minifcu:CfgRpn(46, '19201 (>K:ROTOR_BRAKE)') -- 气压旋钮 PUSH（STD）[Q48]

-- ===========================================================
-- INPUT：编码器（bit 47–66）

-- ALT 编码器 [Q16 / Q17]
minifcu:CfgRpn(47, '225008 (>K:ROTOR_BRAKE)') -- ALT 减
minifcu:CfgRpn(48, '225008 (>K:ROTOR_BRAKE)') -- ALT 减
minifcu:CfgRpn(49, '225007 (>K:ROTOR_BRAKE)') -- ALT 加
minifcu:CfgRpn(50, '225007 (>K:ROTOR_BRAKE)') -- ALT 加

-- SPD 编码器 [Q0 / Q1]
minifcu:CfgRpn(51, '21008 (>K:ROTOR_BRAKE)') -- SPD 减
minifcu:CfgRpn(52, '21008 (>K:ROTOR_BRAKE)') -- SPD 减
minifcu:CfgRpn(53, '21007 (>K:ROTOR_BRAKE)') -- SPD 加
minifcu:CfgRpn(54, '21007 (>K:ROTOR_BRAKE)') -- SPD 加

-- HDG 编码器 [Q4 / Q5]
minifcu:CfgRpn(55, '218008 (>K:ROTOR_BRAKE)') -- HDG 减
minifcu:CfgRpn(56, '218008 (>K:ROTOR_BRAKE)') -- HDG 减
minifcu:CfgRpn(57, '218007 (>K:ROTOR_BRAKE)') -- HDG 加
minifcu:CfgRpn(58, '218007 (>K:ROTOR_BRAKE)') -- HDG 加

-- VS 编码器 [Q20 / Q21]：payload 逐字照抄参考档（注意参考档 VS 的 07/08 码与
-- SPD/HDG/ALT 的 07/08 码方向相反，这是参考档自身的写法，不做“修正”）。
minifcu:CfgRpn(59, '22207 (>K:ROTOR_BRAKE)') -- VS 减
minifcu:CfgRpn(60, '22207 (>K:ROTOR_BRAKE)') -- VS 减
minifcu:CfgRpn(61, '22208 (>K:ROTOR_BRAKE)') -- VS 加
minifcu:CfgRpn(62, '22208 (>K:ROTOR_BRAKE)') -- VS 加

-- 气压编码器（机长侧）[Q46 / Q47]：payload 里操作的是参考档自己的 CABaroKnob / myBaroTimer 累加器。
minifcu:CfgRpn(63, '(L:myBaroTimer) d 0 > if{(E:SIMULATION TIME, second) (L:myBaroTimer) > if{ 0 (>L:CABaroKnob, number) 0 (>L:FOBaroKnob, number) 0 (>L:myBaroTimer) } } (L:CABaroKnob, number) 5 - -50 max (>L:CABaroKnob, number)(E:SIMULATION TIME, second) 0.04 + (>L:myBaroTimer)') -- BARO 减
minifcu:CfgRpn(64, '(L:myBaroTimer) d 0 > if{(E:SIMULATION TIME, second) (L:myBaroTimer) > if{ 0 (>L:CABaroKnob, number) 0 (>L:FOBaroKnob, number) 0 (>L:myBaroTimer) } } (L:CABaroKnob, number) 5 - -50 max (>L:CABaroKnob, number)(E:SIMULATION TIME, second) 0.04 + (>L:myBaroTimer)') -- BARO 减
minifcu:CfgRpn(65, '(L:myBaroTimer) d 0 > if{(E:SIMULATION TIME, second) (L:myBaroTimer) > if{ 0 (>L:CABaroKnob, number) 0 (>L:FOBaroKnob, number) 0 (>L:myBaroTimer) } } (L:CABaroKnob, number) 5 +  50 min (>L:CABaroKnob, number) (E:SIMULATION TIME, second) 0.04 + (>L:myBaroTimer)') -- BARO 加
minifcu:CfgRpn(66, '(L:myBaroTimer) d 0 > if{(E:SIMULATION TIME, second) (L:myBaroTimer) > if{ 0 (>L:CABaroKnob, number) 0 (>L:FOBaroKnob, number) 0 (>L:myBaroTimer) } } (L:CABaroKnob, number) 5 +  50 min (>L:CABaroKnob, number) (E:SIMULATION TIME, second) 0.04 + (>L:myBaroTimer)') -- BARO 加

-- ===========================================================
-- 显示源（帧循环里读；iDataRef:New 找不到路径会返回 nil，统一用 safe_get 兜底）
-- 参考档帧循环真正读到的 FCU 窗口值只有下面 4 个，其余 miniFCU 通道在 777 上无源（见各条 TODO）。

local function safe_get(dr)
	if dr == nil then
		return 0
	end
	return dr:Get()
end

-- FCU 窗口值（参考档 digi_disp_set_SPD / HDG / ALT / VS 的源）
local dr_spd = iDataRef:New('(L:ngx_SPDwindow)')  -- SPD 模式 = kts，MACH 模式 = 0.xx；-1 = 空屏
local dr_hdg = iDataRef:New('(L:ngx_HDGwindow)')
local dr_alt = iDataRef:New('(L:ngx_ALTwindow)')  -- ft
local dr_vs  = iDataRef:New('(L:ngx_VSwindow)')   -- fpm（带符号）；-20000 = 空屏

-- ===========================================================
-- OUTPUT：6 个 LED pin

-- AP1 / AP2 / ATHR / APPR：源与参考档 LED 函数逐条一致
minifcu:GetAp1('(L:ngx_MCP_VNav)')        -- [Q10]
minifcu:GetAp2('(L:ngx_MCP_LNav)')        -- [Q9]
minifcu:GetAthr('(L:switch_204_a)', true) -- [Q11] revert：参考档 (v-100)*(-1)，即 0 = 接通
minifcu:GetAppr('(L:ngx_MCP_App)')        -- [Q13]
-- LOC / EXPED 灯 —— TODO：参考档没有可读源（QFCU 8 / 12 两个键都被注释掉），注册 '0' 并在帧循环写 0
minifcu:GetLoc('0')
minifcu:GetExped('0')

-- ===========================================================
-- OUTPUT：miniFCU LCD（CustomDevice 26 通道 = 14 FCU + 12 EFIS，全部注册）

-- MT 0 SPD 值（kts，仅 SPD 模式且非空屏）
minifcu:GetFcuSpdValue('(L:ngx_SPDwindow)')
-- MT 1 MACH 值（马赫 × 100）
minifcu:GetFcuMachValue('(L:ngx_SPDwindow)', 100)
-- MT 2 SPD/MACH 模式（1 = mach）：参考档用同一个窗口值的量级判断（< 1 = 马赫）
minifcu:GetFcuSpdMachMode('(L:ngx_SPDwindow)')
-- MT 3 SPD dashes：参考档用 -1 表示空屏
minifcu:GetFcuSpdDashes('(L:ngx_SPDwindow)')
-- MT 4 SPD managed 点 —— TODO：参考档帧循环没有 managed 点源（777 无 managed 概念）
minifcu:GetFcuSpdDot('0')
-- MT 5 HDG 值
minifcu:GetFcuHdgValue('(L:ngx_HDGwindow)')
-- MT 6 HDG dashes —— TODO：参考档始终给 hdgmode 1（777 的 MCP 航向窗没有虚线态）
minifcu:GetFcuHdgDashes('0')
-- MT 7 HDG managed 点 —— TODO：同上，777 无 managed 点
minifcu:GetFcuHdgDot('0')
-- MT 8 ALT 值（ft / 100；源是英尺，scale 0.01 与 MINIFCU_FBW_A320NX / XP 档一致）
minifcu:GetFcuAltValue('(L:ngx_ALTwindow)', 0.01)
-- MT 9 ALT managed 点 —— TODO：参考档始终给 altmode 1（777 的 MCP 高度窗无 managed 点）
minifcu:GetFcuAltDot('0')
-- MT 10 VS 值（fpm，带符号）：参考档把 |VS| 写进 vsval_i、符号写进 vsmode，miniFCU 通道本身带符号
minifcu:GetFcuVsValue('(L:ngx_VSwindow)')
-- MT 11 FPA 值 —— TODO：PMDG 777 没有 FPA（TRK/FPA 是空客概念）
minifcu:GetFcuFpaValue('0')
-- MT 12 VS dashes：参考档用 -20000 表示空屏
minifcu:GetFcuVsDashes('(L:ngx_VSwindow)')
-- MT 13 HDG/TRK 模式 —— TODO：参考档只有 [Q54] 的写绑定（21601），没有可读的 TRK 状态源
minifcu:GetFcuHdgTrkMode('0')

-- MT 0–4 CSTR / WPT / VORD / NDB / ARPT —— TODO：参考档 QFCU 35–39 全被注释掉，777 无源
minifcu:GetEfisCstr('0')
minifcu:GetEfisWpt('0')
minifcu:GetEfisVord('0')
minifcu:GetEfisNdb('0')
minifcu:GetEfisArpt('0')
-- MT 5 FD（机长）/ MT 6 LS
minifcu:GetFcuFdValue('(L:switch_202_a)', true) -- [Q40] revert：参考档 (v-100)*(-1)
-- MT 6 LS —— TODO：参考档 QFCU 41 的 LS 绑定被注释掉，只有一句注释里的 B:AIRLINER_LS 写法，
--   按规格不照搬、不发明 → 置 0
minifcu:GetFcuLsValue('0')
-- MT 7 QNH 标签 / MT 8 STD / MT 9 单位（1 = inHg）/ MT 10 inHg / MT 11 hPa
--   TODO：参考档没有任何可读的气压源 —— 它只把旋钮动作写进 (L:CABaroKnob) 累加器、
--   单位档位来自面板自己的 (L:switch_190_a)，777 侧没有 STD 标志、没有气压值、也没有
--   inHg/hPa 的单位状态可读，所以这 5 条通道全部置 0（不猜）。
minifcu:GetEfisBaroQnnh1('0')
minifcu:GetEfisBaroStd1('0')
minifcu:GetEfisBaroInhgHpaUnit('0')
minifcu:GetEfisBaroInhg('0')
minifcu:GetEfisBaro('0')

-- ===========================================================
-- 帧循环

GlobalFrameLoopManager:add(function()
	-- ---- 6 个 LED pin ----
	minifcu:SetAp1()
	minifcu:SetAp2()
	minifcu:SetAthr()
	minifcu:SetLoc(0)    -- TODO: 777 档无 LOC 灯源
	minifcu:SetAppr()
	minifcu:SetExped(0)  -- TODO: 777 档无 EXPED 灯源

	-- ---- FCU LCD ----
	local spd_val  = safe_get(dr_spd)
	local is_blank = (spd_val < 0)                              -- 参考档：-1 = 空屏（负值一律当空屏）
	local is_mach  = (not is_blank) and (spd_val < 1)           -- 参考档：iasmode 3 = 马赫

	-- MT 2：SPD/MACH 模式
	minifcu:SetFcuSpdMachMode(is_mach and 1 or 0)

	-- MT 1：MACH 值（马赫 × 100，仅马赫模式；参考档写的是 value + 0.005 的浮点通道）
	if is_mach then
		minifcu:SetFcuMachValue(math.floor(spd_val * 100 + 0.5))
	else
		minifcu:SetFcuMachValue(0)
	end

	-- MT 0：SPD 值（kts；马赫模式或空屏时置 0）
	if (not is_mach) and (not is_blank) then
		minifcu:SetFcuSpdValue(math.floor(spd_val + 0.5))
	else
		minifcu:SetFcuSpdValue(0)
	end

	-- MT 3 / MT 4：虚线（参考档 -1 = 空屏）；managed 点在 777 上无源
	minifcu:SetFcuSpdDashes(is_blank and 1 or 0)
	minifcu:SetFcuSpdDot(0)

	-- MT 5 / MT 6 / MT 7：HDG（参考档始终 hdgmode 1，无虚线、无 managed 点）
	minifcu:SetFcuHdgValue(math.floor(safe_get(dr_hdg) + 0.5))
	minifcu:SetFcuHdgDashes(0)
	minifcu:SetFcuHdgDot(0)

	-- MT 8 / MT 9：ALT（源是英尺，scale 0.01 → ft/100；777 无 managed 点）
	minifcu:SetFcuAltValue()
	minifcu:SetFcuAltDot(0)

	-- MT 10 / MT 11 / MT 12：VS 与 FPA（参考档 -20000 = 空屏；777 无 FPA）
	local vs_val   = safe_get(dr_vs)
	local vs_blank = (vs_val <= -20000)
	if vs_blank then
		minifcu:SetFcuVsValue(0)
	else
		minifcu:SetFcuVsValue(vs_val)  -- 通道本身带符号，参考档是 |VS| + mode 1/3 两段表达
	end
	minifcu:SetFcuFpaValue(0)
	minifcu:SetFcuVsDashes(vs_blank and 1 or 0)

	-- MT 13：777 无 TRK
	minifcu:SetFcuHdgTrkMode(0)

	-- ---- EFIS 半区 ----
	minifcu:SetEfisCstr(0)
	minifcu:SetEfisWpt(0)
	minifcu:SetEfisVord(0)
	minifcu:SetEfisNdb(0)
	minifcu:SetEfisArpt(0)
	minifcu:SetFcuFdValue()   -- revert 已注册：0 = FD 亮（与参考档 LED 一致）
	minifcu:SetFcuLsValue(0)  -- TODO: 777 档无 LS 源

	-- 气压：777 档没有可读源，5 条通道固定 0（见上面的 TODO）
	minifcu:SetEfisBaroQnnh1(0)
	minifcu:SetEfisBaroStd1(0)
	minifcu:SetEfisBaroInhgHpaUnit(0)
	minifcu:SetEfisBaroInhg(0)
	minifcu:SetEfisBaro(0)
end)
