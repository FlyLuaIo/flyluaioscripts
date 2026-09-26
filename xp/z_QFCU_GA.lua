-- **********************************************************************************************************--
-- FlyLuaIO QFCU Driver for X-Plane General Aviation (GA)
-- Author: Wei Shuai <cpuwolf@gmail.com>
-- Email:  cpuwolf@gmail.com
-- **********************************************************************************************************--
-- 与 msfs/z_QFCU_GA.lua 同构（同一套 KeyIdx 分工、同一套 LED/LCD 刷新流程），
-- 差异只在数据源：XP 用 sim/ dataref + sim/ 命令，G1000 用 sim/GPS/g1000n1_*（PFD）/ g1000n3_*（MFD）。
-- 命令来源（均为本仓既有 profile 已验证用法）：
--   AP      : xp/z_QMCP737C_GA.lua 的 sim/autopilot/* 命令集
--   G1000   : xp/QG1KPFD.lua (g1000n1_*) / xp/QG1KMFD.lua (g1000n3_*)
--   Baro    : xp/QFCU_Toliss.lua / xp/QFCU_JD330.lua 的 condbtn + inHg/hPa 双单位处理
-- 取舍：QFCU 面板没有 COM/NAV 旋钮，sim/radios/stby_com*、stby_nav* 不绑定。
-- ######################  Edit part  #####################
-- 此处调整背光最大亮度, 值越小越暗, 环保省电不刺眼
local MaxBrightness = 40
-- ######################  End edit  ######################

-- Do not remove below lines: hardware detection
local qfcu = com.sim.qm.Qfcu.Open()
if not qfcu then return end
-- Do not remove above lines: hardware detection

uluaLog("QFCU for GA")

-- ===========================================================
-- 按键绑定（KeyIdx 见 docs/ai/device-pins/qfcu.md）
-- ===========================================================

-- ---- FCU 半区：自动飞行 ----
-- SPD 旋钮（编码器）
qfcu:CfgEncFull(0, 1, "sim/cockpit2/autopilot/airspeed_dial_kts_mach", 1, 5, 0, 0, 500)
qfcu:CfgCmd(2, "sim/autopilot/level_change")   -- SPD PUSH：FLC
qfcu:CfgCmd(3, "sim/autopilot/servos_off_any") -- SPD PULL：断开/接管 AP

-- HDG 旋钮（编码器）
qfcu:CfgEncFull(4, 5, "sim/cockpit/autopilot/heading_mag", 1, 5, 0, 0, 360)
qfcu:CfgCmd(6, "sim/autopilot/heading_sync") -- HDG PUSH：同步机头
qfcu:CfgCmd(7, "sim/autopilot/heading")      -- HDG PULL：HDG 保持

-- AP 模式
qfcu:CfgCmd(8, "sim/autopilot/NAV")                  -- LOC
qfcu:CfgCmd(9, "sim/autopilot/servos_toggle")        -- AP2
qfcu:CfgCmd(10, "sim/autopilot/servos_toggle")       -- AP1
qfcu:CfgCmd(11, "sim/autopilot/autothrottle_toggle") -- A/THR
qfcu:CfgCmd(12, "sim/GPS/g1000n1_bc")                -- EXPED：GA 无加速爬升，改为反向进近 BC
qfcu:CfgCmd(13, "sim/autopilot/approach")            -- APPR
qfcu:CfgCmd(14, "sim/systems/yaw_damper_toggle")     -- METRIC ALT：GA 无米制，改为偏航阻尼 YD

-- ALT
-- 16/17 旋钮：慢转 100ft / 快转 1000ft（加速点见 Qmdev.FastTurnsPerSecond）
qfcu:CfgEncFull(16, 17, "sim/cockpit/autopilot/altitude", 100, 1000, 0, 0, 50000)
-- XP 没有 100/1000 步长状态可切，此键按源 xp/z_QMCP737C_GA.lua 默认机 KeyIdx 22 的用法做 ALT 预位
qfcu:CfgCmd(15, "sim/autopilot/altitude_arm")  -- ALT 100/1000 → ALT 预位
qfcu:CfgCmd(18, "sim/GPS/g1000n1_alt")         -- ALT PUSH：高度保持
qfcu:CfgCmd(19, "sim/autopilot/altitude_sync") -- ALT PULL：接管当前高度

-- VS 旋钮（编码器）
qfcu:CfgEncFull(20, 21, "sim/cockpit2/autopilot/vvi_dial_fpm", 100, 1000, 0, -9000, 9000)
qfcu:CfgCmd(22, "sim/autopilot/vertical_speed") -- VS PUSH：VS 保持
qfcu:CfgFc(23, "ga_qfcu_vs_pull()")             -- VS PULL：接管当前垂直速度

-- 54/55：GA 无 TRK/FPA 与 MACH 速度选择，降级为 FD / SPD-MACH 显示切换
qfcu:CfgCmd(54, "sim/GPS/g1000n1_fd")              -- HDG/TRK VS/FPV → FD
qfcu:CfgCmd(55, "sim/autopilot/knots_mach_toggle") -- SPD/MACH

-- ---- 左 EFIS 半区：G1000 PFD (g1000n1) ----
-- 24-28 ND 模式键 → PFD 软键 1-5
qfcu:CfgCmd(24, "sim/GPS/g1000n1_softkey1")   -- ILS MAP MODE
qfcu:CfgCmd(25, "sim/GPS/g1000n1_softkey2")   -- VOR MAP MODE
qfcu:CfgCmd(26, "sim/GPS/g1000n1_softkey3")   -- NAV MAP MODE
qfcu:CfgCmd(27, "sim/GPS/g1000n1_softkey4")   -- ARC MAP MODE
qfcu:CfgCmd(28, "sim/GPS/g1000n1_softkey5")   -- PLN MAP MODE
-- 29-34 距离/光标
qfcu:CfgCmd(29, "sim/GPS/g1000n1_range_down") -- RANGE 10
qfcu:CfgCmd(30, "sim/GPS/g1000n1_range_up")   -- RANGE 20
qfcu:CfgCmd(31, "sim/GPS/g1000n1_pan_up")     -- RANGE 40
qfcu:CfgCmd(32, "sim/GPS/g1000n1_pan_down")   -- RANGE 80
qfcu:CfgCmd(33, "sim/GPS/g1000n1_pan_left")   -- RANGE 160
qfcu:CfgCmd(34, "sim/GPS/g1000n1_pan_right")  -- RANGE 320
-- 35-41 导航点过滤键 → PFD 软键 6-12
qfcu:CfgCmd(35, "sim/GPS/g1000n1_softkey6")   -- LEFT CSTR
qfcu:CfgCmd(36, "sim/GPS/g1000n1_softkey7")   -- LEFT WPT
qfcu:CfgCmd(37, "sim/GPS/g1000n1_softkey8")   -- LEFT VOR D
qfcu:CfgCmd(38, "sim/GPS/g1000n1_softkey9")   -- LEFT NDB
qfcu:CfgCmd(39, "sim/GPS/g1000n1_softkey10")  -- LEFT ARPT
qfcu:CfgCmd(40, "sim/GPS/g1000n1_softkey11")  -- LEFT FD
qfcu:CfgCmd(41, "sim/GPS/g1000n1_softkey12")  -- LEFT ILS
-- 42-45 ADF/VOR 选择键 → PFD 功能键
qfcu:CfgCmd(42, "sim/GPS/g1000n1_direct")     -- ADF 1
qfcu:CfgCmd(43, "sim/GPS/g1000n1_fpl")        -- VOR 1
qfcu:CfgCmd(44, "sim/GPS/g1000n1_proc")       -- ADF 2
qfcu:CfgCmd(45, "sim/GPS/g1000n1_menu")       -- VOR 2
-- 46-50 左气压表（condbtn + Lua，支持 inHg/hPa 双单位）
qfcu:CfgCmd(46, 'sim/instruments/barometer_down', 'sim/operation/test_none')
qfcu:CfgCmd(47, 'sim/instruments/barometer_up', 'sim/operation/test_none')
qfcu:CfgCmd(48, "sim/instruments/barometer_2992") -- Left Baro PUSH：STD 29.92
qfcu:CfgFc(49, "ga_qfcu_baro_sync()")             -- Left Baro PULL：回到真实 QNH
qfcu:CfgFc(50, "ga_qfcu_baro_unit_toggle()")      -- Left Baro INHG/HPA：显示单位切换

-- ---- 右 EFIS 半区：G1000 MFD (g1000n3) ----
-- 56-60 ND 模式键 → MFD 软键 1-5
qfcu:CfgCmd(56, "sim/GPS/g1000n3_softkey1")   -- ILS MAP MODE
qfcu:CfgCmd(57, "sim/GPS/g1000n3_softkey2")   -- VOR MAP MODE
qfcu:CfgCmd(58, "sim/GPS/g1000n3_softkey3")   -- NAV MAP MODE
qfcu:CfgCmd(59, "sim/GPS/g1000n3_softkey4")   -- ARC MAP MODE
qfcu:CfgCmd(60, "sim/GPS/g1000n3_softkey5")   -- PLN MAP MODE
-- 61-66 距离/光标
qfcu:CfgCmd(61, "sim/GPS/g1000n3_range_down") -- RANGE 10
qfcu:CfgCmd(62, "sim/GPS/g1000n3_range_up")   -- RANGE 20
qfcu:CfgCmd(63, "sim/GPS/g1000n3_pan_up")     -- RANGE 40
qfcu:CfgCmd(64, "sim/GPS/g1000n3_pan_down")   -- RANGE 80
qfcu:CfgCmd(65, "sim/GPS/g1000n3_pan_left")   -- RANGE 160
qfcu:CfgCmd(66, "sim/GPS/g1000n3_pan_right")  -- RANGE 320
-- 67-73 导航点过滤键 → MFD 软键 6-12
qfcu:CfgCmd(67, "sim/GPS/g1000n3_softkey6")   -- Right CSTR
qfcu:CfgCmd(68, "sim/GPS/g1000n3_softkey7")   -- Right WPT
qfcu:CfgCmd(69, "sim/GPS/g1000n3_softkey8")   -- Right VOR D
qfcu:CfgCmd(70, "sim/GPS/g1000n3_softkey9")   -- Right NDB
qfcu:CfgCmd(71, "sim/GPS/g1000n3_softkey10")  -- Right ARPT
qfcu:CfgCmd(72, "sim/GPS/g1000n3_softkey11")  -- Right FD
qfcu:CfgCmd(73, "sim/GPS/g1000n3_softkey12")  -- Right ILS
-- 74-77 ADF/VOR 选择键 → MFD 功能键
qfcu:CfgCmd(74, "sim/GPS/g1000n3_direct")     -- ADF 1
qfcu:CfgCmd(75, "sim/GPS/g1000n3_fpl")        -- VOR 1
qfcu:CfgCmd(76, "sim/GPS/g1000n3_proc")       -- ADF 2
qfcu:CfgCmd(77, "sim/GPS/g1000n3_menu")       -- VOR 2
-- 78/79/51/52/53 右气压表（GA 只有一个气压表，与左侧作用于同一 sim/cockpit/misc/barometer_setting）
qfcu:CfgCmd(78, 'sim/instruments/barometer_down', 'sim/operation/test_none')
qfcu:CfgCmd(79, 'sim/instruments/barometer_up', 'sim/operation/test_none')
qfcu:CfgCmd(51, "sim/instruments/barometer_2992") -- Right Baro PUSH
qfcu:CfgFc(52, "ga_qfcu_baro_sync()")             -- Right Baro PULL
qfcu:CfgFc(53, "ga_qfcu_baro_unit_toggle()")      -- Right Baro INHG/HPA

-- ===========================================================
-- 数据读取
-- ===========================================================
local ga_power = iDataRef:New("sim/cockpit/electrical/avionics_on")
if ga_power == nil then
    uluaLog("QFCU for GA: no avionics power dataref")
    return
end

local ga_brightness = uluaFind("sim/cockpit/electrical/cockpit_lights[0]") -- 0~1

-- FCU 数字显示
local d_ias = uluaFind("sim/cockpit2/autopilot/airspeed_dial_kts_mach")
local d_ias_mach = uluaFind("sim/cockpit2/autopilot/airspeed_is_mach")
local d_hdg = uluaFind("sim/cockpit/autopilot/heading_mag")
local d_vs = uluaFind("sim/cockpit/autopilot/vertical_velocity")
local d_vs_hold = uluaFind("sim/cockpit2/autopilot/vvi_status")

-- 气压表：XP 侧 barometer_setting 恒为 inHg；hPa 由 Lua 换算（QFCU_Toliss/QFCU_JD330 同法）
local dr_baro_in = iDataRef:New("sim/cockpit/misc/barometer_setting")
local dr_baro_now = iDataRef:New("sim/weather/barometer_sealevel_inhg")
local dr_vs_dial = iDataRef:New("sim/cockpit2/autopilot/vvi_dial_fpm")
local dr_vs_now = iDataRef:New("sim/flightmodel/position/vh_ind_fpm")
-- 0: inHg  1: hPa（显示单位，仅影响 QFCU 的 LCD / LED）
local ga_qfcu_baro_hpa = 0

qfcu:GetAlt("sim/cockpit/autopilot/altitude")

-- LED：FCU 部分
qfcu:GetAp1("sim/cockpit2/autopilot/servos_on")
qfcu:GetAp2("sim/cockpit2/autopilot/flight_director_mode")
qfcu:GetAthr("sim/cockpit2/autopilot/autothrottle_on")
qfcu:GetLoc("sim/cockpit2/autopilot/nav_status")
qfcu:GetExped("sim/cockpit2/autopilot/vnav_status")
qfcu:GetAppr("sim/cockpit2/autopilot/approach_status")

-- LED：左右 EFIS（GA 只有一套 AP，右组镜像左组）
qfcu:GetLCstr("sim/cockpit2/autopilot/altitude_hold_status")
qfcu:GetLWpt("sim/cockpit2/autopilot/vvi_status")
qfcu:GetLVord("sim/cockpit2/autopilot/heading_mode")
qfcu:GetLNdb("sim/cockpit2/autopilot/speed_status")
qfcu:GetLArpt("sim/cockpit2/autopilot/nav_status")
qfcu:GetLFd("sim/cockpit2/autopilot/flight_director_mode")
qfcu:GetLIls("sim/cockpit2/autopilot/approach_status")

qfcu:GetRCstr("sim/cockpit2/autopilot/altitude_hold_status")
qfcu:GetRWpt("sim/cockpit2/autopilot/vvi_status")
qfcu:GetRVord("sim/cockpit2/autopilot/heading_mode")
qfcu:GetRNdb("sim/cockpit2/autopilot/speed_status")
qfcu:GetRArpt("sim/cockpit2/autopilot/nav_status")
qfcu:GetRFd("sim/cockpit2/autopilot/flight_director_mode")
qfcu:GetRIls("sim/cockpit2/autopilot/approach_status")

-- ===========================================================
-- 按键回调（CfgFc）
-- ===========================================================
-- VS PULL：把当前垂直速度写入 VS 目标值
function ga_qfcu_vs_pull()
    if dr_vs_dial == nil or dr_vs_now == nil then
        return
    end
    local vs = dr_vs_now:Get()
    if vs > 6000 then
        vs = 6000
    elseif vs < -6000 then
        vs = -6000
    end
    dr_vs_dial:Set(math.floor(vs / 100 + 0.5) * 100)
end

-- Baro PULL：回到真实 QNH
function ga_qfcu_baro_sync()
    if dr_baro_in == nil or dr_baro_now == nil then
        return
    end
    dr_baro_in:Set(dr_baro_now:Get())
end

-- Baro INHG/HPA：切换 QFCU 的显示单位
function ga_qfcu_baro_unit_toggle()
    ga_qfcu_baro_hpa = ga_qfcu_baro_hpa == 0 and 1 or 0
    uluaSet(idr_qfcu_hid_invalid, -1)
end

-- ===========================================================
-- 发送处理
-- ===========================================================
function ga_qfcu_digi_disp_set_SPD()
    local spd = uluaGet(d_ias)
    if spd > 0 then
        if uluaGet(d_ias_mach) > 0 and spd < 1 then
            -- Mach 模式：值本身即 Mach
            uluaSet(idr_qfcu_hid_iasval_f, spd)
            uluaSet(idr_qfcu_hid_iasmode, 3)
        else
            uluaSet(idr_qfcu_hid_iasval_i, math.floor(spd + 0.5))
            uluaSet(idr_qfcu_hid_iasmode, 1)
        end
    else
        -- 未选择速度：显示虚线
        uluaSet(idr_qfcu_hid_iasmode, 2)
    end
end

function ga_qfcu_digi_disp_set_HDG()
    uluaSet(idr_qfcu_hid_hdgval_i, uluaGet(d_hdg))
    uluaSet(idr_qfcu_hid_hdgmode, 1)
end

function ga_qfcu_digi_disp_set_ALT()
    qfcu:SetAlt()
end

function ga_qfcu_digi_disp_set_VS()
    if uluaGet(d_vs_hold) > 0 then
        local vs = uluaGet(d_vs)
        uluaSet(idr_qfcu_hid_vsval_i, math.abs(math.floor(vs + 0.5)))
        if vs < 0 then
            uluaSet(idr_qfcu_hid_vsmode, 3)
        else
            uluaSet(idr_qfcu_hid_vsmode, 1)
        end
    else
        -- VS 未保持：显示虚线
        uluaSet(idr_qfcu_hid_vsmode, 2)
    end
end

-- QNH/QFE 指示灯在 GA 上表示显示单位（1=HPA / 0=inHg）
function ga_qfcu_digi_disp_set_BARO()
    local inHg = dr_baro_in:Get()
    local mode, led_mode, val
    if ga_qfcu_baro_hpa == 1 then
        mode, led_mode = 2, 1
        val = math.floor(inHg * 33.8638895 + 0.5)
    else
        mode, led_mode = 1, 0
        val = math.floor(inHg * 100 + 0.5)
    end
    qfcu:SetLBaro(mode, val)
    qfcu:SetRBaro(mode, val)
    qfcu:SetLBaroMode(led_mode)
    qfcu:SetRBaroMode(led_mode)
end

local ga_qfcu_digi_disp_func_table = { ga_qfcu_digi_disp_set_SPD, ga_qfcu_digi_disp_set_HDG,
    ga_qfcu_digi_disp_set_ALT, ga_qfcu_digi_disp_set_VS, ga_qfcu_digi_disp_set_BARO }

local ga_qfcu_digi_disp_rr_idx = 0

function ga_qfcu_digi_disp_rr()
    for i = 1, #ga_qfcu_digi_disp_func_table do
        ga_qfcu_digi_disp_rr_idx = ga_qfcu_digi_disp_rr_idx % #ga_qfcu_digi_disp_func_table + 1
        ga_qfcu_digi_disp_func_table[ga_qfcu_digi_disp_rr_idx]()
    end
end

function ga_qfcu_digi_disp_set_Bright()
    local bright = uluaGet(ga_brightness)
    uluaSet(idr_qfcu_hid_brightval_i, math.floor(bright * MaxBrightness))
    uluaSet(idr_qfcu_hid_dispbrightval_i, math.floor(bright * 4))
end

function ga_qfcu_digi_disp_power_on()
    uluaSet(idr_qfcu_hid_indbrightval_i, 2)
    uluaSet(idr_qfcu_hid_invalid, -1)
    qfcu:FreshMidLeds()
    qfcu:FreshLeftLeds()
    qfcu:FreshRightLeds()
    qfcu:FreshAlt()
end

function ga_qfcu_digi_disp_power_off()
    -- update cache
    qfcu:FreshMidLeds()
    qfcu:FreshLeftLeds()
    qfcu:FreshRightLeds()
    qfcu:FreshAlt()
    -- real code
    qfcu:SetLedsOff()
    qfcu:SetDigiOff()
    uluaSet(idr_qfcu_hid_dispbrightval_i, 0)
    -- QFE/QNH 指示灯全灭：Qfcu:SetLBaroMode 用的 ledslqfe/ledslqhn 是 Qfcu.lua 共用符号，
    -- 而 idr_qfcu_hid_ledslqnhqfe / ledsrqnhqfe 只在 msfs/init.lua 里注册，XP 侧不能用
    qfcu:SetLBaroMode(2)
    qfcu:SetRBaroMode(2)
    qfcu:SetDigiBrtOff()
end

-- Baro 旋钮步长：按当前单位 0.01 inHg / 1 hPa（QFCU_Toliss 同法）
function ga_qfcu_baro_step(step)
    if dr_baro_in == nil then
        return
    end
    local inHg = dr_baro_in:Get()
    if ga_qfcu_baro_hpa == 1 then
        local hpa = math.floor(inHg * 33.8638895 + 0.5) + step
        dr_baro_in:Set(hpa * 0.02952998057228486)
    else
        dr_baro_in:Set(math.floor((inHg + step * 0.01) * 100 + 0.5) / 100)
    end
end

-- ===========================================================
-- 帧循环
-- ===========================================================
GlobalFrameLoopManager:add(function()
    if ga_power:ChangedUpdate() then
        if ga_power:Get() > 0 then
            ga_qfcu_digi_disp_power_on()
        else
            ga_qfcu_digi_disp_power_off()
        end
    end

    if ga_power:Get() <= 0 then
        return
    end

    ga_qfcu_digi_disp_set_Bright()

    qfcu:SetMidLeds()
    qfcu:SetLeftLeds()
    qfcu:SetRightLeds()

    ga_qfcu_digi_disp_rr()

    -- 左右气压表旋钮增量
    if idr_qfcu_hid_condbtn_46:Changed() then
        local step = idr_qfcu_hid_condbtn_46:Delta()
        idr_qfcu_hid_condbtn_46:Update()
        ga_qfcu_baro_step(step)
    end
    if idr_qfcu_hid_condbtn_78:Changed() then
        local step = idr_qfcu_hid_condbtn_78:Delta()
        idr_qfcu_hid_condbtn_78:Update()
        ga_qfcu_baro_step(step)
    end
end)

-- 脚本加载时同步一次电源状态（通电时直接点亮，避免等下一次状态跳变）
if ga_power:Get() > 0 then
    ga_qfcu_digi_disp_power_on()
else
    ga_qfcu_digi_disp_power_off()
end
