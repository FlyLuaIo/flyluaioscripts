# FlyLuaIO Lua API Developer Guide

This document describes the Lua scripting framework in the `flyluaioscripts` repository, used to map FlyLuaIO hardware panels to flight simulators.

**Naming:** **FlyLuaIO** (plugin namespace `cpuwolf/flyluaio/`) is the current project name and the successor to **qmdev**. Class names (`Qmdev`), filenames (`Qmdev.lua`), IDs (`QmdevId`), and C API symbols (`uluaQmdevConfig`, etc.) are kept for backward compatibility.

**Supported simulators**

- X-Plane 11 / 12
- Microsoft Flight Simulator 2020 / 2024

**Runtime**

Scripts are loaded by the [FlyLuaIO](https://github.com/cpuwolf/flyluaio) plugin. Runtime APIs such as `ulua*`, `ilua*`, `iDataRef`, `GlobalFrameLoopManager`, and helpers defined in the plugin entry script (`init.lua`) are not part of this repository.

---

## Table of Contents

1. [Overview](#1-overview)
2. [Directory Structure](#2-directory-structure)
3. [Writing Profile Scripts](#3-writing-profile-scripts)
4. [OOP Foundation (`com/oop`)](#4-oop-foundation-comoop)
5. [Core Device Classes (`com/sim`)](#5-core-device-classes-comsim)
6. [Hardware Device Classes (`com/sim/qm`)](#6-hardware-device-classes-comsimqm)
7. [Extension Packages (`com/sim/wf`, `com/sim/mf`)](#7-extension-packages-comsimwf-comsimmf)
8. [Configuration APIs](#8-configuration-apis)
9. [Position Switch (PID) APIs](#9-position-switch-pid-apis)
10. [Runtime Globals (`init.lua`)](#10-runtime-globals-initlua)
11. [Data Reference System](#11-data-reference-system)
12. [Best Practices](#12-best-practices)
13. [Troubleshooting](#13-troubleshooting)
14. [Device JSON schemas](#14-device-json-schemas)
15. [Runtime helpers appendix](#15-runtime-helpers-appendix)

---

## 1. Overview

FlyLuaIO is a hardware control framework for flight simulators. The **flyluaioscripts** repository provides Lua scripts that bridge USB HID hardware with X-Plane and MSFS.

The framework uses Lua scripts to do three things:

1. **Detect hardware** — Confirm the USB HID device is connected and not already claimed.
2. **Bind buttons/encoders** — Map physical inputs to datarefs, commands, or RPN expressions.
3. **Sync displays and LEDs** — Read simulator values and drive panel digits, backlight, and indicators.

Typical workflow:

```
Hardware detection → Aircraft/add-on filter → Key binding (Cfg*) → Display/LED binding (Get*/Set*) → Register frame loop
```

You typically:

1. Use the shared framework under `com/` (`com/oop`, `com/sim`, `com/sim/qm`, etc.).
2. Create aircraft-specific profiles under `xp/` (X-Plane) or `msfs/` (MSFS).
3. Map hardware (MCP, CDU, FCU, G1000, overhead panel, etc.) using the configuration APIs.

**Main features**

- Embedded Lua scripting for hardware control and simulator I/O
- Hardware abstraction implemented as Lua classes
- Cross-simulator shared core
- Modular design: one profile file per hardware–aircraft pair
- Factory helpers (`Class.Open()`) and frame loop manager for LED/display refresh

> **Note:** Files under `com/` marked `Don't modify this file` are framework core. Put custom logic in `xp/` or `msfs/` profiles.

---

## 2. Directory Structure

```text
flyluaioscripts/
├── xp/                          # X-Plane aircraft profiles
│   ├── QCDU_Toliss.lua
│   ├── QMCP737C_ZIBO738.lua
│   └── z_QMCP737C_GA.lua
├── msfs/                        # MSFS aircraft profiles
│   ├── QCDU_INIBUILD_A3xx.lua
│   └── z_QMCP737C_GA.lua
└── com/
    ├── oop/
    │   ├── Object.lua
    │   ├── class.lua
    │   ├── include.lua
    │   └── package.lua
    └── sim/
        ├── Qmdev.lua            # Core device base class (legacy name)
        ├── QmReload.lua         # Hot-reload helper
        ├── qm/                  # Hardware device classes
        │   ├── Hcbravo.lua
        │   ├── Qmcp737c.lua
        │   ├── Qfcu.lua
        │   ├── Qcdu.lua / Qcdua.lua / Qcduaf.lua
        │   ├── Qcdub.lua / Qcdubf.lua
        │   ├── Qgmc710.lua
        │   ├── Qg1kmfd.lua / Qg1kpfd.lua
        │   ├── Qmovha.lua
        │   ├── Qmpe.lua
        │   ├── Stkmulti.lua / Stkradio.lua / Stkswitch.lua
        │   ├── Vkbgunut.lua
        │   └── Wwagp.lua / Wwecam.lua
        ├── wf/                  # Wingflex / third-party adapters
        │   ├── Wfdap500.lua
        │   ├── Wffcuc.lua
        │   └── Wingflex.lua
        └── mf/                  # MobiFlight integration
            ├── MobiFlight.lua
            ├── CfMega.lua
            └── CfNano.lua
```

- `com/` is **shared** by X-Plane and MSFS.
- `xp/` and `msfs/` hold **aircraft-specific mapping** scripts.
- The plugin entry script (`init.lua`) registers globals such as `iDataRef`, hardware detection, and `GlobalFrameLoopManager`.
- HID datarefs use the `cpuwolf/flyluaio/` namespace (e.g. `cpuwolf/flyluaio/QFCU/ledsl/aprt`).

### Profile Naming Conventions

| Pattern | Meaning | Example |
|---------|---------|---------|
| `{DEVICE}_{AIRCRAFT/ADDON}.lua` | Full mapping for a specific aircraft | `QCDU_Toliss.lua` |
| `z_{DEVICE}_GA.lua` | General Aviation fallback | `z_QMCP737C_GA.lua` |
| `z_{DEVICE}_no_msfs.lua` | Disable on MSFS | `z_WWAGP_no_msfs.lua` |

---

## 3. Writing Profile Scripts

### 3.1 Standard Template

```lua
-- 1. Aircraft/add-on filter (optional)
if ilua_require_zibo() then return end

-- 2. Hardware detection (must keep)
local qmcp737c = com.sim.qm.Qmcp737c.Open()
if not qmcp737c then return end

uluaLog("QMCP737C for zibo 738")

-- 3. Wait for add-on datarefs (optional)
if uluaFind("laminar/B738/autopilot/course_pilot") == nil then
    ilua_req_reload()
    return
end

-- 4. Button / encoder binding
qmcp737c:CfgEncFull(0, 1, "laminar/B738/autopilot/course_pilot", 1, 5, 0, 0, 360)
qmcp737c:CfgCmd(6, "laminar/B738/autopilot/change_over_press")

-- 5. Display / LED binding
qmcp737c:GetCrs1("laminar/B738/autopilot/course_pilot")
qmcp737c:GetHdg("laminar/B738/autopilot/mcp_hdg_dial")

-- 6. Frame loop (optional)
function qmcp737c_zibo_loop()
    if uluaGet(qmcp737c_battery_on) > 0 then
        qmcp737c:LoopMcp()
    else
        qmcp737c:OffMcp()
    end
end

GlobalFrameLoopManager:add(qmcp737c_zibo_loop)
```

### 3.2 Instantiating Devices

**Recommended — factory helper:**

```lua
local qcdua = com.sim.qm.Qcdua.Open()
if not qcdua then return end
```

**Legacy — still valid:**

```lua
local qfcu = com.sim.qm.Qfcu:new()
if not qfcu:Init() then return end
```

`Qmdev.Open(class, ...)` creates an instance, calls `Init(...)`, and returns `nil` on failure. Do not instantiate `com.sim.Qmdev` directly.

### 3.3 X-Plane vs MSFS

| Scenario | X-Plane | MSFS |
|----------|---------|------|
| Button commands | dataref paths | RPN or B events |
| Read/write | `sim/...` datarefs | `A:` / `L:` SimVars |
| Aircraft filtering | `ilua_require_zibo()`, `PLANE_ICAO` | `ilua_require_inibuild_a3xx_family()` |

---

## 4. OOP Foundation (`com/oop`)

Device classes use `oop.class(ParentClass)` for inheritance.

```lua
local Qmcp737c = oop.class(com.sim.Qmdev)

function Qmcp737c:init()
    self.QmdevId = 2
end
```

| File | Purpose |
|------|---------|
| `Object.lua` | Class creation, inheritance, `init`, `onDestroy` |
| `class.lua` | `oop.class(...)` factory |
| `package.lua` | Lazy loading by package name |
| `include.lua` | Exports `oop.class` and `oop.package` |

Modules are accessed as `com.sim.qm.Qcdua` without manual `require`.

Extension packages: `oop.package('com.sim.wf')`, `oop.package('com.sim.mf')`.

---

## 5. Core Device Classes (`com/sim`)

### 5.1 `Qmdev` — Core Base Class

Shared base for all FlyLuaIO hardware devices. Provides:

- Device config (`QmdevId`, `FastTurnsPerSecond`, `MaxBrightness`)
- Key tracking (`KeyTable`)
- Encoder / button mapping
- Bit / LED state (`Bits`)
- Position-switch helpers (`CfgPSw`, etc.)

```lua
function Qmdev:init()
    self.QmdevId = 0
    self.FastTurnsPerSecond = 40
    self.MaxBrightness = 100
    self.KeyTable = {}
    self.Bits = {}
end

function Qmdev:CfgInit(ftpsdefval, maxBright)
    -- Optional overrides
end
```

#### Key Tracking

```lua
Qmdev:AddKey(KeyIdx)   -- Register key index; logs if already assigned
```

#### Bit / LED Helpers

```lua
Qmdev:GetBit(idx, dpath, revert, base)
Qmdev:SetBit(idx, idr, valbase, val)
Qmdev:FreshBit(idx, val)
Qmdev:FreshBits()
```

#### Utility Methods

```lua
Qmdev:AddTogMenu(menuEn, menuCh, globalvarstr)
Qmdev:swap16(val)       -- Swap high/low byte of 16-bit value
Qmdev:scaleValue(x)     -- Map 0..1024 to -16383..16384
```

### 5.2 `QmReload`

Deferred reload without restarting the plugin.

```lua
local reload = com.sim.QmReload:new()
reload:Req(delayms)   -- Schedule reload (default 1000 ms; keeps longest pending delay)
reload:Exec()         -- Call from main loop
```

Global helper:

```lua
ilua_req_reload(delayms)
```

---

## 6. Hardware Device Classes (`com/sim/qm`)

Each device class inherits from `Qmdev` or an intermediate base such as `Qcdu`, and exposes `Class.Open(...)`.

| Class | QmdevId | Role |
|-------|---------|------|
| `Qgmc710` | 1 | GMC 710 / GA MCP |
| `Qmcp737c` | 2 | Boeing 737 MCP |
| `Qg1kpfd` | 3 | G1000 PFD |
| `Qg1kmfd` | 4 | G1000 MFD |
| `Qcdub` | 5 | B737 Captain CDU |
| `Qcdua` | 6 | A320 Captain CDU |
| `Qfcu` | 7 | Airbus FCU |
| `Qmpe` | 8 | Radio / audio / ECAM panel |
| `Qmovha` | 9 | Airbus overhead panel |
| `Qcduaf` | 0x40000006 | A320 FO CDU |
| `Qcdubf` | — | B737 FO CDU |
| `Wwagp` | 0x3AEBEE64 | Autothrottle panel |
| `Hcbravo` | 0xE2F65B0 | Honeycomb Bravo throttle |
| `Stkradio` | 0x67E6B0B | Radio stack |
| `Stkmulti` / `Stkswitch` | — | Multi-function / switch stacks |
| `Wwecam` | — | ECAM panel |
| `Vkbgunut` | — | VKB Gunfighter |

### 6.1 CDU Example — A320 Captain (`Qcdua`)

```lua
local qcdua = com.sim.qm.Qcdua.Open()
if not qcdua then return end

qcdua:CfgCmd(0, "AirbusFBW/MCDU1LSK1L")
qcdua:GetFm1("cpuwolf/flyluaio/QCDU-A320/condbtn[0]")
qcdua:GetBkl("AirbusFBW/PanelBrightnessLevel", 60)
qcdua:GetScreenBrt("AirbusFBW/DUBrightness[6]")

function CDU_LED_UPD()
    qcdua:SetLeds()
    qcdua:SetScreenBrt()
    qcdua:SetBkl()
end
GlobalFrameLoopManager:add(CDU_LED_UPD)
```

CDU LED helpers: `GetMenu/SetMenu`, `GetFail/SetFail`, `GetFmgc/SetFmgc`, `GetFm1/SetFm1`, `GetInd/SetInd`, `GetRdy/SetRdy`, `GetFm2/SetFm2`, `SetLeds`, `SetBkl`, `Off`.

Inheritance: `Qcdu` → `Qcdua` / `Qcduaf` (A320), `Qcdub` / `Qcdubf` (B737).

### 6.2 MSFS RPN Example

```lua
qcdua:CfgRpn(0, '1 (>L:INI_MCDU1_LSK1L)')
qcdua:CfgRpn(1, '1 (>L:INI_MCDU1_LSK2L)')
```

---

## 7. Extension Packages (`com/sim/wf`, `com/sim/mf`)

### `com/sim/wf` — Wingflex Adapters

- `Wfdap500.lua`, `Wffcuc.lua`, `Wingflex.lua`

### `com/sim/mf` — MobiFlight Integration

- `MobiFlight.lua` — base MobiFlight device class
- `CfMega.lua` / `CfNano.lua` — board-specific configs

---

## 8. Configuration APIs

All methods are on `Qmdev` and inherited by hardware classes.

### 8.1 Encoders

```lua
Qmdev:CfgEncFull(DecKey, IncKey, Rpnstr, SlowStep, FastStep, StepMode, MinStep, MaxStep)
Qmdev:CfgEncTypeFull(DataType, DecKey, IncKey, Rpnstr, ...)  -- e.g. "a", "f", "B:"
Qmdev:CfgEnc(DecKey, IncKey, Rpnstr)                          -- defaults
```

### 8.2 Buttons

```lua
Qmdev:CfgCmd(KeyIdx, CmdPressStr, CmdReleaseStr)
Qmdev:CfgRpn(KeyIdx, RpnPressStr, RpnReleaseStr)
Qmdev:CfgAnalog(KeyIdx, storeRpn, baseline, scale [, clampLo, clampHi [, postOffset]])
-- Lua: v = clamp((baseline - adc) / scale - postOffset, lo, hi); defaults lo=0 hi=1 postOffset=0
Qmdev:PollAnalogs() -- FrameLoop when AnalogInput ADC changes
Qmdev:CfgVal(KeyIdx, ValStr, PressInt, ReleaseInt)
Qmdev:CfgValT(KeyIdx, ValStr, value0, value1)
Qmdev:CfgTog(KeyIdx, BeventStr, RpnStr)
Qmdev:CfgFc(KeyIdx, FuncPressStr, FuncReleaseStr, FuncFastStr)
Qmdev:CfgLongFc(KeyIdx, WaitMs, LongPressFunc, ShortPressFunc, InitPressFunc)
-- LongPressFunc etc. must be Lua functions, not strings
-- CfgAnalog requires self.ProductName (device class init); hub writes ADC via setAnalogByName
```

### 8.3 Aircraft Guards

Low-level (exit when pattern **not** found):

```lua
if ilua_is_acfpath_excluded("toliss") then return end
if ilua_is_acftitle_excluded("A3") then return end
if PLANE_ICAO ~= "A320" then return end
```

Positive match:

```lua
if ilua_acfpath_matches("FlyByWire") then ... end
if ilua_acftitle_matches("B73") then ... end
```

High-level (exit when aircraft does **not** match):

```lua
if ilua_require_zibo() then return end
if ilua_require_ff320() then return end
if ilua_require_fbw_a3xx() then return end
if ilua_require_pmdg_737() then return end
if ilua_require_msfs() then return end
if ilua_require_msfs(false) then return end   -- XP-only script
```

See the plugin `init.lua` for the full `ilua_require_*` list.

---

## 9. Position Switch (PID) APIs

For multi-position physical switches (overhead panel, etc.).

```lua
local idx = QmdevPosSwitchInit(statusPath, step, incCmd, decCmd, delay, decaccu)

device:CfgPSw(KeyIdx, idx, pressExpect)
device:CfgPSw(KeyIdx, idx, pressExpect, releaseExpect)
device:CfgPSwTog(KeyIdx, idx, posA, posB)

QmdevPosSwitchSet(idx, expectPos)
device:GetPSw(idx)
device:PSwDelay(idx, timeout, expectPos)
device:PSwTog(idx, timeout, posA, posB)
```

Example:

```lua
local pswh1 = QmdevPosSwitchInit("1-sim/anim/lightStrobeT", 1,
    "1-sim/command/strobeLightSwitch_trigger",
    "1-sim/command/strobeLightSwitch_trigger", 1000)
qmovha:CfgPSw(0, pswh1, 1)
qmovha:CfgPSw(1, pswh1, 0)
```

---

## 10. Runtime Globals (`init.lua`)

Defined in the FlyLuaIO plugin entry script, not in `flyluaioscripts/`.

### 10.1 Hardware Detection

| Function | Device |
|----------|--------|
| `ilua_hw_qgmc710_absent` | QGMC710 |
| `ilua_hw_qmcp737c_absent` | QMCP737C |
| `ilua_hw_qfcu_absent` | QFCU |
| `ilua_hw_qcdu_b737_absent` | QCDU B737 Captain |
| `ilua_hw_qcdu_b737_1_absent` | QCDU B737 FO |
| `ilua_hw_qcdu_a320_absent` | QCDU A320 Captain |
| `ilua_hw_qcdu_a320_1_absent` | QCDU A320 FO |
| `ilua_hw_qg1k_pfd_absent` | QG1K PFD |
| `ilua_hw_qg1k_mfd_absent` | QG1K MFD |
| `ilua_hw_qmpe_absent` | QMPE |
| `ilua_hw_qmovh_a_absent` | QMOVH-A |

`ilua_hw_assigned_*` flags prevent double-binding when multiple profiles load.

### 10.2 Frame Loop Manager

```lua
GlobalFrameLoopManager:add(function() device:SetLeds() end)
GlobalFrameLoopManager:tick()
GlobalFrameLoopManager:has_active_loops()
GlobalFrameLoopManager:remove(func)
```

Prefer `GlobalFrameLoopManager` over legacy `uluaAddDoLoop`.

### 10.3 QLCD (CDU Screen IPC)

```lua
ilua_qlcd_set_airplane(idx)
ilua_qlcd_set_brightness(brt)
```

### 10.4 Core I/O

```lua
uluaLog(msg)
uluaFind(path)
uluaGet(handle) / uluaSet(handle, value)
uluaCmdOnce(handle)
uluaWriteCmd(cmdStr)
uluaQmdevConfig(qmdevId, configStr)
uluaQmdevRegisterKey(qmdevId, keyIdx, press, release, fast)
uluasetTimeout(code, delayMs)
uluaclearTimeout(handle)
uluagetTimestamp()
```

### 10.5 Utilities

```lua
ilua_bool_ternary(value1, value, revert)
ilua_file_exists(path)
ilua_get_path(str)
IndexAllocator.new() / :alloc() / :free()
```

---

## 11. Data Reference System

### 11.1 `iDataRef`

Wraps a dataref (X-Plane) or simvar (MSFS) with change tracking.

```lua
local dr = iDataRef:New(pathstr, defval, bool_revert, bool_base)
-- Returns nil if uluaFind(pathstr) fails
```

| Method | Description |
|--------|-------------|
| `Set(newval)` | Write to simulator |
| `Get()` | Read and cache |
| `Changed()` | Compare cached vs last (epsilon 0.001) |
| `Update()` | Commit current as last |
| `Invalid(val)` | Reset last value |
| `Delta(val)` | Return `val - val_last` |
| `GetOld()` | Last cached value |
| `GetChanged()` | `Get()` then return whether changed |
| `ChangedUpdate()` | `Get()` + if changed, `Update()` and return true |
| `GetBit()` / `GetOldBit()` | Bool threshold helpers |

```lua
local heading = iDataRef:New("sim/cockpit/autopilot/heading")
if heading:ChangedUpdate() then
    -- handle update
end
```

### 11.2 Common Paths

**X-Plane:** `sim/cockpit/autopilot/heading`, `sim/cockpit/autopilot/altitude`, `sim/cockpit/electrical/avionics_on`

**MSFS:** `A:HEADING INDICATOR, degrees`, `A:ALTITUDE INDICATOR, feet`, `L:XMLVAR_AirSpeedIsInMach`

---

## 12. Best Practices

1. **Keep the hardware detection block** at the top of every profile.
2. **Use `ilua_require_*`** when available instead of manual ICAO checks.
3. **Bind with `Get*` in setup; push in frame loop** via `SetLeds()`, `SetBkl()`, `LoopMcp()`, etc.
4. **Defer reload** when datarefs are not ready: `ilua_req_reload()` then `return`.
5. **Unique `KeyIdx`** per device — duplicate assignments log "already assigned".
6. **Use `ChangedUpdate()`** in loops; call `FreshAlt()` / `FreshBkl()` / `FreshBits()` after aircraft swaps.
7. **Copy existing profiles** in `xp/` or `msfs/` before writing new mappings.

| Scenario | Method |
|----------|--------|
| X-Plane commands | `CfgCmd` |
| MSFS LVar / B events | `CfgRpn` |
| Fixed values | `CfgVal` / `CfgValT` |
| Encoders | `CfgEncFull` |
| Multi-position switches | `CfgPSw` + `QmdevPosSwitchInit` |
| Short/long press | `CfgLongFc` |
| Custom logic | `CfgFc` |

---

## 13. Troubleshooting

| Symptom | Likely cause | Fix |
|---------|--------------|-----|
| Profile exits immediately | `ilua_require_*` mismatch | Check `AIRCRAFT_PATH`, `PLANE_ICAO`, guards |
| `Open()` returns nil | Hardware absent or already assigned | Check USB; `ilua_hw_assigned_*` |
| LEDs stuck | Missing frame loop | `GlobalFrameLoopManager:add(...)` |
| `iDataRef:New` returns nil | Dataref not published yet | `ilua_req_reload()` |
| "already assigned" log | Duplicate `KeyIdx` | Use unique indices |
| Position switch overshoots | `delay` too short | Increase delay in `QmdevPosSwitchInit` |
| MSFS buttons ineffective | X-Plane syntax used | Use `CfgRpn` with `L:` / `B:` |

With FlyLuaIO logging enabled, `uluaLog()` output appears in the plugin log window.

---

## 14. Device JSON schemas

| Kind | Path | Notes |
|------|------|-------|
| USB HID panels | `joysticks/joystick-config.schema.json` | Required `$schema` on HID JSON |
| MobiFlight boards | `mobiflight/mobiflight-config.schema.json` | Channel `Name` is not always the hardware `DeviceName`; follow working siblings such as `CfNano.json` / `KayeRoof.json` |

`Display Module` entries use a `LedModule` child key (see `CfNano.json`). WinWing LCD/LED framing belongs in `joysticks/*.json`, not MobiFlight JSON.

---

## 15. Runtime helpers appendix

These symbols are provided by the FlyLuaIO plugin entry script (`init.lua`), not by files in this repository. Signatures are stable for profile authors:

| Group | Examples |
|-------|----------|
| Logging / dataref I/O | `uluaLog`, `uluaFind`, `uluaGet`, `uluaSet`, `uluaCmdOnce`, `uluaWriteCmd` |
| Aircraft gates | `ilua_require_zibo`, `ilua_require_toliss`, `ilua_require_fenix_a320`, `ilua_require_pmdg_737`, `ilua_require_msfs`, … |
| Hardware helpers | `ilua_hw_qmcp737c_absent`, `ilua_hw_qfcu_absent`, … (prefer `Class.Open()`) |
| Reload / match | `ilua_req_reload`, `ilua_acfpath_matches`, `ilua_acftitle_matches` |
| Frame loop | `GlobalFrameLoopManager:add` / `remove` / `tick` / `has_active_loops` |
| Typed dataref | `iDataRef:New` / `Get` / `Set` / `Changed` / … |

Do not invent undocumented `ilua_require_*` names; copy gates from an existing profile for the same aircraft family.
