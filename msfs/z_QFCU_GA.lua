-- **********************************************************************************************************--
-- FlyLuaIO QFCU Driver for MSFS General Aviation (GA)
-- Author: Wei Shuai <cpuwolf@gmail.com>
-- Email:  cpuwolf@gmail.com
-- **********************************************************************************************************--
-- 来源：msfs/z_QMCP737C_GA.lua 的 GA dataref / command 集，重映射到 QFCU 键位。
-- 提取到的可复用 GA 命令集（原样搬运，未改单位/大小写）：
--   K: AP_SPD_VAR_INC/DEC/SET, FLIGHT_LEVEL_CHANGE, HEADING_BUG_INC/DEC/SET,
--      AP_PANEL_HEADING_HOLD, AP_ALT_VAR_INC/DEC/SET_ENGLISH, AP_ALT_HOLD,
--      AP_PANEL_VS_HOLD, AP_VS_VAR_INC/DEC/SET_ENGLISH, AP_PITCH_REF_INC_UP/DN,
--      AP_NAV1_HOLD, AP_APR_HOLD, AP_MASTER, AUTOPILOT_DISENGAGE_TOGGLE,
--      TOGGLE_FLIGHT_DIRECTOR, GEAR_DOWN/UP
--   H: AP_UP/AP_DN, AS1000_PFD_CRS_*, AS1000_PFD_BARO_*, AS1000_PFD_COM_*, AS1000_PFD_NAV_*
--   A: AUTOPILOT MASTER / FLIGHT DIRECTOR ACTIVE:1 / AUTOTHROTTLE ACTIVE /
--      NAV1 LOCK / FLIGHT LEVEL CHANGE / APPROACH HOLD / ALTITUDE LOCK /
--      VERTICAL HOLD / HEADING LOCK / AIRSPEED HOLD VAR / HEADING LOCK DIR /
--      ALTITUDE LOCK VAR / VERTICAL HOLD VAR / HEADING INDICATOR /
--      AIRSPEED INDICATED / CIRCUIT AVIONICS ON / LIGHT POTENTIOMETER:3
-- 取舍：QFCU 面板没有 COM/NAV 旋钮，AS1000_PFD_COM_*/NAV_* 按约定舍弃。
-- ######################  Edit part  #####################
-- 此处调整背光最大亮度, 值越小越暗, 环保省电不刺眼
local MaxBrightness = 40
-- ######################  End edit  ######################

if ilua_require_msfs() then
    return
end

-- Do not remove below lines: hardware detection
local qfcu = com.sim.qm.Qfcu.Open()
if not qfcu then return end
-- Do not remove above lines: hardware detection

uluaLog("QFCU for GA")

-- ===========================================================
-- 按键绑定（KeyIdx 见 docs/ai/device-pins/qfcu.md）
-- ===========================================================

-- ---- FCU 半区：自动飞行 ----
-- SPD
qfcu:CfgRpn(0, "(>K:AP_SPD_VAR_DEC)") -- SPD DEC
qfcu:CfgRpn(1, "(>K:AP_SPD_VAR_INC)") -- SPD INC
-- SPD PUSH：FLC + 用当前空速设定目标（与源 z_QMCP737C_GA.lua KeyIdx 9 一致）
qfcu:CfgRpn(2, "(>K:FLIGHT_LEVEL_CHANGE) (A:AIRSPEED INDICATED, knots) (>K:AP_SPD_VAR_SET)")
qfcu:CfgRpn(3, "(>K:AUTOPILOT_DISENGAGE_TOGGLE)") -- SPD PULL：断开/接管 AP

-- HDG
qfcu:CfgRpn(4, "1 (>K:HEADING_BUG_DEC)")                              -- HDG DEC
qfcu:CfgRpn(5, "1 (>K:HEADING_BUG_INC)")                              -- HDG INC
qfcu:CfgRpn(6, "(A:HEADING INDICATOR, degrees) (>K:HEADING_BUG_SET)") -- HDG PUSH：同步机头
qfcu:CfgRpn(7, "(>K:AP_PANEL_HEADING_HOLD)")                          -- HDG PULL：HDG 保持

-- AP 模式
qfcu:CfgRpn(8, "(>K:AP_NAV1_HOLD)")                   -- LOC
qfcu:CfgRpn(9, "(>K:AP_MASTER)")                      -- AP2
qfcu:CfgRpn(10, "(>K:AP_MASTER)")                     -- AP1
qfcu:CfgRpn(11, "(>K:AUTOPILOT_AUTOTHROTTLE_TOGGLE)") -- A/THR
qfcu:CfgRpn(12, "(>K:AP_BC_HOLD)")                    -- EXPED：GA 无加速爬升，改为反向进近 BC
qfcu:CfgRpn(13, "(>K:AP_APR_HOLD)")                   -- APPR
qfcu:CfgRpn(14, "(>K:YAW_DAMPER_TOGGLE)")             -- METRIC ALT：GA 无米制，改为偏航阻尼 YD

-- ALT
-- 15 切换旋钮步长（100 / 1000），16/17 按步长增减
qfcu:CfgRpn(15, "(L:CPUWOLF_QFCU_GA_ALT1000, bool) ! (>L:CPUWOLF_QFCU_GA_ALT1000, bool)")
qfcu:CfgRpn(16, "(L:CPUWOLF_QFCU_GA_ALT1000, bool) if{ 1000 } els{ 100 } (>K:AP_ALT_VAR_DEC)")
qfcu:CfgRpn(17, "(L:CPUWOLF_QFCU_GA_ALT1000, bool) if{ 1000 } els{ 100 } (>K:AP_ALT_VAR_INC)")
qfcu:CfgRpn(18, "(>K:AP_ALT_HOLD)") -- ALT PUSH：高度保持
-- ALT PULL：接管当前飞机高度作为目标高度
qfcu:CfgRpn(19, "(A:PLANE ALTITUDE, feet) near (>K:AP_ALT_VAR_SET_ENGLISH)")

-- VS（20/21 与源 z_QMCP737C_GA.lua KeyIdx 24/25 逐字一致）
qfcu:CfgRpn(20,
    "(A:AUTOPILOT VERTICAL HOLD, Bool) if{ (>K:AP_VS_VAR_DEC) (>H:AP_UP) } (A:AUTOPILOT FLIGHT LEVEL CHANGE, Bool) if{ (>K:AP_SPD_VAR_INC) } (A:AUTOPILOT PITCH HOLD, Bool) if{ (>K:AP_PITCH_REF_INC_DN) }")
qfcu:CfgRpn(21,
    "(A:AUTOPILOT VERTICAL HOLD, Bool) if{ (>K:AP_VS_VAR_INC) (>H:AP_DN) } (A:AUTOPILOT FLIGHT LEVEL CHANGE, Bool) if{ (>K:AP_SPD_VAR_DEC) } (A:AUTOPILOT PITCH HOLD, Bool) if{ (>K:AP_PITCH_REF_INC_UP) }")
qfcu:CfgRpn(22, "(>K:AP_PANEL_VS_HOLD)") -- VS PUSH：VS 保持
-- VS PULL：接管当前垂直速度作为目标
qfcu:CfgRpn(23, "(A:VERTICAL SPEED, feet per minute) near (>K:AP_VS_VAR_SET_ENGLISH)")

-- 54/55：GA 无 TRK/FPA 与 MACH 速度选择，降级为 FD / SPD-MACH 显示切换
qfcu:CfgRpn(54, "(>K:TOGGLE_FLIGHT_DIRECTOR)")          -- HDG/TRK VS/FPV → FD
qfcu:CfgRpn(55, "(>K:AP_MANAGED_SPEED_IN_MACH_TOGGLE)") -- SPD/MACH

-- ---- 左 EFIS 半区：G1000 PFD ----
-- 24-28 ND 模式键 → PFD 软键 1-5
qfcu:CfgRpn(24, "(>H:AS1000_PFD_SOFTKEYS_1)")     -- ILS MAP MODE
qfcu:CfgRpn(25, "(>H:AS1000_PFD_SOFTKEYS_2)")     -- VOR MAP MODE
qfcu:CfgRpn(26, "(>H:AS1000_PFD_SOFTKEYS_3)")     -- NAV MAP MODE
qfcu:CfgRpn(27, "(>H:AS1000_PFD_SOFTKEYS_4)")     -- ARC MAP MODE
qfcu:CfgRpn(28, "(>H:AS1000_PFD_SOFTKEYS_5)")     -- PLN MAP MODE
-- 29-34 距离/光标
qfcu:CfgRpn(29, "(>H:AS1000_PFD_RANGE_DEC)")      -- RANGE 10
qfcu:CfgRpn(30, "(>H:AS1000_PFD_RANGE_INC)")      -- RANGE 20
qfcu:CfgRpn(31, "(>H:AS1000_PFD_JOYSTICK_UP)")    -- RANGE 40
qfcu:CfgRpn(32, "(>H:AS1000_PFD_JOYSTICK_DOWN)")  -- RANGE 80
qfcu:CfgRpn(33, "(>H:AS1000_PFD_JOYSTICK_LEFT)")  -- RANGE 160
qfcu:CfgRpn(34, "(>H:AS1000_PFD_JOYSTICK_RIGHT)") -- RANGE 320
-- 35-41 导航点过滤键 → PFD 软键 6-12
qfcu:CfgRpn(35, "(>H:AS1000_PFD_SOFTKEYS_6)")     -- LEFT CSTR
qfcu:CfgRpn(36, "(>H:AS1000_PFD_SOFTKEYS_7)")     -- LEFT WPT
qfcu:CfgRpn(37, "(>H:AS1000_PFD_SOFTKEYS_8)")     -- LEFT VOR D
qfcu:CfgRpn(38, "(>H:AS1000_PFD_SOFTKEYS_9)")     -- LEFT NDB
qfcu:CfgRpn(39, "(>H:AS1000_PFD_SOFTKEYS_10)")    -- LEFT ARPT
qfcu:CfgRpn(40, "(>H:AS1000_PFD_SOFTKEYS_11)")    -- LEFT FD
qfcu:CfgRpn(41, "(>H:AS1000_PFD_SOFTKEYS_12)")    -- LEFT ILS
-- 42-45 ADF/VOR 选择键 → PFD 功能键
qfcu:CfgRpn(42, "(>H:AS1000_PFD_DIRECTTO)")       -- ADF 1
qfcu:CfgRpn(43, "(>H:AS1000_PFD_FPL_Push)")       -- VOR 1
qfcu:CfgRpn(44, "(>H:AS1000_PFD_PROC_Push)")      -- ADF 2
qfcu:CfgRpn(45, "(>H:AS1000_PFD_MENU_Push)")      -- VOR 2
-- 46-50 左气压表
qfcu:CfgRpn(46, "(>H:AS1000_PFD_BARO_DEC)")       -- Left Baro DEC
qfcu:CfgRpn(47, "(>H:AS1000_PFD_BARO_INC)")       -- Left Baro INC
qfcu:CfgRpn(48, "(>K:BAROMETRIC_STD_PRESSURE)")   -- Left Baro PUSH：STD 29.92
-- Left Baro PULL：回到真实 QNH（同源的 A:KOHLSMAN SETTING 系列，mbars*16 与仓内 FBW profile 一致）
qfcu:CfgRpn(49, "(A:SEA LEVEL PRESSURE, millibars) 16 * (>K:KOHLSMAN_SET)")
-- Left Baro INHG/HPA：切换气压单位（Asobo G1000 变量）
qfcu:CfgRpn(50, "(L:XMLVAR_Baro_Selector_HPA_1, bool) ! (>L:XMLVAR_Baro_Selector_HPA_1, bool)")

-- ---- 右 EFIS 半区：G1000 MFD ----
-- 56-60 ND 模式键 → MFD 软键 1-5
qfcu:CfgRpn(56, "(>H:AS1000_MFD_SOFTKEYS_1)")                                                   -- ILS MAP MODE
qfcu:CfgRpn(57, "(>H:AS1000_MFD_SOFTKEYS_2)")                                                   -- VOR MAP MODE
qfcu:CfgRpn(58, "(>H:AS1000_MFD_SOFTKEYS_3)")                                                   -- NAV MAP MODE
qfcu:CfgRpn(59, "(>H:AS1000_MFD_SOFTKEYS_4)")                                                   -- ARC MAP MODE
qfcu:CfgRpn(60, "(>H:AS1000_MFD_SOFTKEYS_5)")                                                   -- PLN MAP MODE
-- 61-66 距离/光标
qfcu:CfgRpn(61, "(>H:AS1000_MFD_RANGE_DEC)")                                                    -- RANGE 10
qfcu:CfgRpn(62, "(>H:AS1000_MFD_RANGE_INC)")                                                    -- RANGE 20
qfcu:CfgRpn(63, "(>H:AS1000_MFD_JOYSTICK_UP)")                                                  -- RANGE 40
qfcu:CfgRpn(64, "(>H:AS1000_MFD_JOYSTICK_DOWN)")                                                -- RANGE 80
qfcu:CfgRpn(65, "(>H:AS1000_MFD_JOYSTICK_LEFT)")                                                -- RANGE 160
qfcu:CfgRpn(66, "(>H:AS1000_MFD_JOYSTICK_RIGHT)")                                               -- RANGE 320
-- 67-73 导航点过滤键 → MFD 软键 6-12
qfcu:CfgRpn(67, "(>H:AS1000_MFD_SOFTKEYS_6)")                                                   -- Right CSTR
qfcu:CfgRpn(68, "(>H:AS1000_MFD_SOFTKEYS_7)")                                                   -- Right WPT
qfcu:CfgRpn(69, "(>H:AS1000_MFD_SOFTKEYS_8)")                                                   -- Right VOR D
qfcu:CfgRpn(70, "(>H:AS1000_MFD_SOFTKEYS_9)")                                                   -- Right NDB
qfcu:CfgRpn(71, "(>H:AS1000_MFD_SOFTKEYS_10)")                                                  -- Right ARPT
qfcu:CfgRpn(72, "(>H:AS1000_MFD_SOFTKEYS_11)")                                                  -- Right FD
qfcu:CfgRpn(73, "(>H:AS1000_MFD_SOFTKEYS_12)")                                                  -- Right ILS
-- 74-77 ADF/VOR 选择键 → MFD 功能键
qfcu:CfgRpn(74, "(>H:AS1000_MFD_DIRECTTO)")                                                     -- ADF 1
qfcu:CfgRpn(75, "(>H:AS1000_MFD_FPL_Push)")                                                     -- VOR 1
qfcu:CfgRpn(76, "(>H:AS1000_MFD_PROC_Push)")                                                    -- ADF 2
qfcu:CfgRpn(77, "(>H:AS1000_MFD_MENU_Push)")                                                    -- VOR 2
-- 78/79/51/52/53 右气压表（GA 只有一个气压表，与左侧作用于同一 A:KOHLSMAN）
qfcu:CfgRpn(78, "(>H:AS1000_PFD_BARO_DEC)")                                                     -- Right Baro DEC
qfcu:CfgRpn(79, "(>H:AS1000_PFD_BARO_INC)")                                                     -- Right Baro INC
qfcu:CfgRpn(51, "(>K:BAROMETRIC_STD_PRESSURE)")                                                 -- Right Baro PUSH
qfcu:CfgRpn(52, "(A:SEA LEVEL PRESSURE, millibars) 16 * (>K:KOHLSMAN_SET)")                     -- Right Baro PULL
qfcu:CfgRpn(53, "(L:XMLVAR_Baro_Selector_HPA_1, bool) ! (>L:XMLVAR_Baro_Selector_HPA_1, bool)") -- Right Baro INHG/HPA

-- ===========================================================
-- 数据读取
-- ===========================================================
local ga_power = iDataRef:New("(A:CIRCUIT AVIONICS ON, Bool)")
if ga_power == nil then
    uluaLog("QFCU for GA: no avionics power dataref")
    return
end

local ga_brightness = uluaFind("(A:LIGHT POTENTIOMETER:3, Percent)")

-- FCU 数字显示
local d_ias = uluaFind("(A:AUTOPILOT AIRSPEED HOLD VAR, knot)")
local d_hdg = uluaFind("(A:AUTOPILOT HEADING LOCK DIR, Degrees)")
local d_vs = uluaFind("(A:AUTOPILOT VERTICAL HOLD VAR, Feet/minute)")
local d_vs_hold = uluaFind("(A:AUTOPILOT VERTICAL HOLD, Bool)")

-- 气压表：inHg 两位小数 / HPA 整数（表达式与本仓 QFCU_* profile 同源）
local d_baro_in = uluaFind("(A:KOHLSMAN SETTING HG, inHg) 100 * near")
local d_baro_hpa = uluaFind("(A:KOHLSMAN SETTING MB, mbars) near")
-- 单位选择变量只在 Asobo G1000 上存在；缺失时按 inHg 显示
local d_baro_hpa_unit = iDataRef:New("(L:XMLVAR_Baro_Selector_HPA_1, bool)")

qfcu:GetAlt("(A:AUTOPILOT ALTITUDE LOCK VAR, Feet)")

-- LED：FCU 部分
qfcu:GetAp1("(A:AUTOPILOT MASTER, Bool)")
qfcu:GetAp2("(A:AUTOPILOT FLIGHT DIRECTOR ACTIVE:1, Bool)")
qfcu:GetAthr("(A:AUTOTHROTTLE ACTIVE, Bool)")
qfcu:GetLoc("(A:AUTOPILOT NAV1 LOCK, Bool)")
qfcu:GetExped("(A:AUTOPILOT FLIGHT LEVEL CHANGE, Bool)")
qfcu:GetAppr("(A:AUTOPILOT APPROACH HOLD, Bool)")

-- LED：左右 EFIS（GA 只有一套 AP，右组镜像左组）
qfcu:GetLCstr("(A:AUTOPILOT ALTITUDE LOCK, Bool)")
qfcu:GetLWpt("(A:AUTOPILOT VERTICAL HOLD, Bool)")
qfcu:GetLVord("(A:AUTOPILOT HEADING LOCK, Bool)")
qfcu:GetLNdb("(A:AUTOPILOT FLIGHT LEVEL CHANGE, Bool)")
qfcu:GetLArpt("(A:AUTOPILOT NAV1 LOCK, Bool)")
qfcu:GetLFd("(A:AUTOPILOT FLIGHT DIRECTOR ACTIVE:1, Bool)")
qfcu:GetLIls("(A:AUTOPILOT APPROACH HOLD, Bool)")

qfcu:GetRCstr("(A:AUTOPILOT ALTITUDE LOCK, Bool)")
qfcu:GetRWpt("(A:AUTOPILOT VERTICAL HOLD, Bool)")
qfcu:GetRVord("(A:AUTOPILOT HEADING LOCK, Bool)")
qfcu:GetRNdb("(A:AUTOPILOT FLIGHT LEVEL CHANGE, Bool)")
qfcu:GetRArpt("(A:AUTOPILOT NAV1 LOCK, Bool)")
qfcu:GetRFd("(A:AUTOPILOT FLIGHT DIRECTOR ACTIVE:1, Bool)")
qfcu:GetRIls("(A:AUTOPILOT APPROACH HOLD, Bool)")

-- ===========================================================
-- 发送处理
-- ===========================================================
function ga_qfcu_digi_disp_set_SPD()
    local spd = uluaGet(d_ias)
    if spd > 0 then
        uluaSet(idr_qfcu_hid_iasval_i, math.floor(spd + 0.5))
        uluaSet(idr_qfcu_hid_iasmode, 1)
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

-- QNH/QFE 指示灯在 GA 上表示气压单位（1=HPA / 0=inHg）
local function ga_qfcu_baro_unit_mode()
    if d_baro_hpa_unit:Get() >= 0 then
        return 2, 1 -- HPA 数字, 指示灯 qhn
    end
    return 1, 0     -- inHg 数字, 指示灯 qfe
end

function ga_qfcu_digi_disp_set_BARO()
    local mode, led_mode = ga_qfcu_baro_unit_mode()
    local val
    if mode == 2 then
        val = math.floor(uluaGet(d_baro_hpa) + 0.5)
    else
        val = math.floor(uluaGet(d_baro_in) + 0.5)
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
    uluaSet(idr_qfcu_hid_brightval_i, math.floor(bright * MaxBrightness / 100))
    uluaSet(idr_qfcu_hid_dispbrightval_i, 2)
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
    uluaSet(idr_qfcu_hid_ledslqnhqfe, 0)
    uluaSet(idr_qfcu_hid_ledsrqnhqfe, 0)
    uluaSet(idr_qfcu_hid_dispbrightval_i, 0)
    qfcu:SetDigiBrtOff()
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
end)

-- 脚本加载时同步一次电源状态（通电时直接点亮，避免等下一次状态跳变）
if ga_power:Get() > 0 then
    ga_qfcu_digi_disp_power_on()
else
    ga_qfcu_digi_disp_power_off()
end
