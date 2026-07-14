## FlyLuaIo Lua API Developer Guide

> **Naming note:** **FlyLuaIo** (plugin namespace `cpuwolf/flyluaio/`) is the current project name.  
> **Qmdev** is the legacy name still used in source code — class names (`Qmdev`), filenames (`Qmdev.lua`), IDs (`QmdevId`), and C API symbols (`uluaQmdevConfig`, etc.) are kept for backward compatibility.

### Table of Contents
1. Overview
2. Architecture
3. Core Device Classes (`com/sim`)
4. Hardware Abstraction Classes (`com/sim/qm`)
5. Extension Packages (`com/sim/wf`, `com/sim/mf`)
6. Configuration APIs
7. Position Switch (PID) APIs
8. Runtime Globals (`init.lua`)
9. Data Reference System
10. Best Practices
11. Troubleshooting
12. Changelog

---

## 1. Overview

**FlyLuaIo** is a hardware control framework for flight simulators.  
The **flyluaioscripts** repository provides Lua scripts that bridge USB HID hardware devices with:

- **X-Plane 11 / 12**
- **Microsoft Flight Simulator 2020 / 2024**

You typically:

1. Use the shared device framework under `com/` (`com/oop`, `com/sim`, `com/sim/qm`, etc.).
2. Create aircraft-specific configuration files under `xp/` (X-Plane) or `msfs/` (MSFS).
3. Map your hardware (MCP, CDU, FCU, G1000, overhead panel, etc.) to aircraft systems using the configuration APIs.

### Main Features

- **Embedded Lua scripting engine** for hardware control and simulator communication.
- **Hardware abstraction layer** implemented in Lua classes.
- **Cross-simulator support** with a single shared core.
- **Modular design**: each hardware–aircraft pair has its own Lua profile file.
- **Factory helpers** (`Class.Open()`) and **frame loop manager** for LED/display refresh.

---

## 2. Architecture

The repository is organized as follows:

```text
flyluaioscripts/
├── xp/                      # X-Plane 11/12 aircraft-specific profiles
│   └── *.lua                # One file per hardware–aircraft combination
├── msfs/                    # MSFS 2020/2024 aircraft-specific profiles
│   └── *.lua                # One file per hardware–aircraft combination
└── com/
    ├── oop/                 # Object-oriented helpers for Lua
    │   ├── Object.lua
    │   ├── class.lua
    │   ├── include.lua
    │   └── package.lua
    └── sim/                 # Shared simulator-agnostic core
        ├── Qmdev.lua        # Core device base class (legacy name; FlyLuaIo framework)
        ├── QmReload.lua     # Reload / helper utilities
        ├── qm/              # QuickMade hardware classes
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
        ├── wf/              # Wingflex / third-party hardware adapters
        │   ├── Wfdap500.lua
        │   ├── Wffcuc.lua
        │   └── Wingflex.lua
        └── mf/              # MobiFlight integration
            ├── MobiFlight.lua
            ├── CfMega.lua
            └── CfNano.lua
```

- The `com/` tree is **shared** by both X-Plane and MSFS.
- The `xp/` and `msfs/` directories contain **aircraft-specific logic and mapping**.
- Simulator entry scripts (`init.lua`) register global helpers such as `iDataRef`, hardware detection, and `GlobalFrameLoopManager`.
- HID datarefs are published under the `cpuwolf/flyluaio/` namespace (e.g. `cpuwolf/flyluaio/QFCU/ledsl/aprt`).

### File Naming Convention

```
<hardware_name>_<aircraft_model_name>.lua
```

Example: `QMCP737C_ZIBO738.lua` — QMCP737C hardware mapped for ZIBO 737-800.

---

## 3. Core Device Classes (`com/sim`)

### 3.1 `Qmdev` – Core Base Class (legacy name)

`com.sim.Qmdev` is the shared base class for all FlyLuaIo hardware devices.  
The name **Qmdev** comes from the earlier project; it remains in code and is not renamed.
It contains:

- Device-level configuration (`QmdevId`, `FastTurnsPerSecond`, `MaxBrightness`)
- Key assignment tracking (`KeyTable`)
- Encoder / button mapping logic
- Bit / LED state management (`Bits`)
- Position-switch (PID) helpers (`CfgPSw`, etc.)

#### Construction Patterns

**Pattern A – explicit init (legacy, still valid):**

```lua
local qfcu = com.sim.qm.Qfcu:new()
if not qfcu:Init() then return end
```

**Pattern B – factory helper (recommended):**

```lua
local qcdua = com.sim.qm.Qcdua.Open()
if not qcdua then return end
```

`Qmdev.Open(class, ...)` creates an instance, calls `Init(...)`, and returns `nil` on failure.

#### Initialization

```lua
function Qmdev:init()
    self.QmdevId = 0
    self.FastTurnsPerSecond = 40   -- Threshold for "fast" encoder rotations
    self.MaxBrightness = 100       -- Maximum display / LED brightness
    self.KeyTable = {}             -- Key definitions
    self.Bits = {}                 -- Bit / LED states
end

function Qmdev:CfgInit(ftpsdefval, maxBright)
    -- ftpsdefval: default fast-turns-per-second threshold
    -- maxBright : maximum brightness value
end
```

#### Key Tracking

```lua
Qmdev:AddKey(KeyIdx)   -- Register a key index; logs if already assigned
```

#### Bit / LED Helpers

```lua
Qmdev:GetBit(idx, dpath, revert, base)  -- Bind simulator dataref to bit slot
Qmdev:SetBit(idx, idr, valbase, val)    -- Push bit change to HID handle
Qmdev:FreshBit(idx, val)                -- Invalidate one bit slot
Qmdev:FreshBits()                       -- Invalidate all bit slots
```

#### Utility Methods

```lua
Qmdev:AddTogMenu(menuEn, menuCh, globalvarstr)  -- Add GUI toggle menu entry
Qmdev:swap16(val)                               -- Swap high/low byte of 16-bit value
Qmdev:scaleValue(x)                             -- Map 0..1024 to -16383..16384
```

### 3.2 `QmReload` (legacy name)

Provides deferred reload of FlyLuaIo Lua profiles without restarting the whole plugin.

```lua
local reload = com.sim.QmReload:new()

reload:Req(delayms)   -- Schedule reload (default 1000 ms; keeps longest pending delay)
reload:Exec()         -- Called from main loop; fires reload command when due
```

Global helper (defined in `init.lua`):

```lua
ilua_req_reload(delayms)   -- Uses global ilua_qmReload instance
```

---

## 4. Hardware Abstraction Classes (`com/sim/qm`)

Each physical hardware device has a corresponding class under `com/sim/qm/`.  
These classes inherit from `Qmdev` (legacy base class) or an intermediate base such as `Qcdu`, and expose device-specific configuration helpers.

| Class | `QmdevId` | Role |
|-------|-----------|------|
| `Hcbravo` | `0xE2F65B0` | Honeycomb Bravo throttle quadrant |
| `Qmcp737c` | 2 | Boeing 737 MCP |
| `Qcdu` | 5 | CDU base (backlight / screen brightness) |
| `Qcdua` / `Qcduaf` | 6 | A320 Captain / FO CDU |
| `Qcdub` / `Qcdubf` | — | B737 Captain / FO CDU |
| `Qgmc710` | — | GA / TBM-style MCP |
| `Qfcu` | 7 | Airbus FCU |
| `Qg1kpfd` / `Qg1kmfd` | — | G1000 PFD / MFD |
| `Qmpe` | — | Radio / audio / ECAM panel |
| `Qmovha` | — | Airbus overhead panel |

All hardware classes expose `Class.Open(...)` as a shorthand for `Qmdev.Open(Class, ...)`.

### 4.1 Qcdua – A320 Captain CDU

```lua
local qcdua = com.sim.qm.Qcdua.Open()
if not qcdua then return end

-- Button mapping
qcdua:CfgCmd(0, "AirbusFBW/MCDU1LSK1L")
qcdua:CfgCmd(1, "AirbusFBW/MCDU1LSK2L")

-- LED feedback (Get* binds dataref; Set* pushes to HID in loop)
qcdua:GetFm1("cpuwolf/flyluaio/QCDU-A320/condbtn[0]")
qcdua:GetInd("cpuwolf/flyluaio/QCDU-A320/condbtn[0]")
qcdua:GetRdy("cpuwolf/flyluaio/QCDU-A320/condbtn[0]")

-- Brightness
qcdua:GetBkl("AirbusFBW/MCDUIntegBrightness[0]", 40)
qcdua:GetScreenBrt("AirbusFBW/DUBrightness[6]")

function CDU_LED_UPD()
    qcdua:SetLeds()
    qcdua:SetScreenBrt()
    qcdua:SetBkl()
end
GlobalFrameLoopManager:add(CDU_LED_UPD)
```

`Qcdua` LED helpers: `GetMenu/SetMenu`, `GetFail/SetFail`, `GetFmgc/SetFmgc`, `GetFm1/SetFm1`, `GetInd/SetInd`, `GetRdy/SetRdy`, `GetFm2/SetFm2`, `SetLeds`, `SetBkl`, `Off`.

### 4.2 Qcduaf – A320 First Officer CDU

Same API as `Qcdua`, but uses FO HID handles (`idr_qcdu_a320_1_*`).  
`Qcduaf` omits redundant `Get*` wrappers; use inherited methods from `Qcdua`.

### 4.3 Qcdub – Boeing 737 Captain CDU

```lua
local qcdub = com.sim.qm.Qcdub.Open()
if not qcdub then return end

qcdub:CfgCmd(0, "laminar/B738/button/fmc1_1L")
qcdub:CfgEncFull(69, 70, "laminar/B738/electric/instrument_brightness[10]",
    0.05, 0.05, 1, 0.05, 1.0)
qcdub:GetScreenBrt("laminar/B738/electric/instrument_brightness[10]")
```

`Qcdub` LED helpers: `GetMsg/SetMsg`, `GetOfst/SetOfst`, `GetCall/SetCall`, `GetFail/SetFail`, `GetExec/SetExec`, `SetLeds`, `SetBkl`, `Off`.

### 4.4 Qfcu – Airbus FCU

```lua
local qfcu = com.sim.qm.Qfcu.Open()
if not qfcu then return end

qfcu:GetAlt("A:AUTOPILOT ALTITUDE LOCK VAR:3")
qfcu:GetAp1("L:XMLVAR_Autopilot_1_Status")
qfcu:SetMidLeds()
```

Key method groups: altitude (`GetAlt/SetAlt/FreshAlt`), baro (`SetLBaro/SetRBaro`), AP/ATHR/LOC LEDs, left/right EFIS LEDs, `SetLedsOff`, `SetDigiOff`.

### 4.5 Qmcp737c – Boeing 737 MCP

```lua
local qmcp737c = com.sim.qm.Qmcp737c.Open()
if not qmcp737c then return end

qmcp737c:GetCrs1("sim/cockpit/autopilot/heading")
qmcp737c:CfgEncFull(0, 1, "sim/cockpit/autopilot/heading", 1, 5, 2, 0, 360)
```

Key method groups: course/IAS/HDG/ALT/VS displays, VHF/NAV radio, MCP LEDs, `LoopMcp`, `OffMcp`.

### 4.6 Qmovha – Airbus Overhead Panel

Supports physical multi-position switches via `CfgPSw` / `CfgPSwTog` (see Section 7).  
Key method groups: backlight, dim/bright, upper/lower LED banks, `FreshAllled`, `Off`.

### 4.7 Qmpe – Radio / ECAM Panel

Large API covering RMP, transponder, ACP, ECAM pages, backlight, and warning lights.  
See `docs/context7-api-index.json` for the full method list.

---

## 5. Extension Packages (`com/sim/wf`, `com/sim/mf`)

### `com/sim/wf` – Wingflex Adapters

Third-party or alternate hardware bridges:

- `Wfdap500.lua`
- `Wffcuc.lua`
- `Wingflex.lua`

### `com/sim/mf` – MobiFlight Integration

- `MobiFlight.lua` – base MobiFlight device class
- `CfMega.lua` / `CfNano.lua` – board-specific configs

Load via `oop.package('com.sim.wf')` / `oop.package('com.sim.mf')` in the entry script.

---

## 6. Configuration APIs

All configuration methods are defined on the `Qmdev` base class and inherited by hardware classes.

### 6.1 Encoder Configuration

#### Full encoder configuration

```lua
Qmdev:CfgEncFull(
    DecKey,     -- Decrement key index
    IncKey,     -- Increment key index
    Rpnstr,     -- RPN, dataref, or B: event string
    SlowStep,   -- Step size for slow rotation (default 1)
    FastStep,   -- Step size for fast rotation (default 1)
    StepMode,   -- Step mode (default 0)
    MinStep,    -- Minimum allowed value (default 0)
    MaxStep     -- Maximum allowed value (default 99999)
)
```

#### Typed encoder (MSFS B: events, etc.)

```lua
Qmdev:CfgEncTypeFull(
    DataType,   -- Encoder data type prefix (e.g. "a", "f", "B:")
    DecKey, IncKey, Rpnstr,
    SlowStep, FastStep, StepMode, MinStep, MaxStep
)
```

`CfgEncFull` is equivalent to `CfgEncTypeFull("a", ...)`.

#### Simplified encoder

```lua
Qmdev:CfgEnc(DecKey, IncKey, Rpnstr)
```

### 6.2 Button Configuration

#### Toggle button

```lua
Qmdev:CfgTog(KeyIdx, BeventStr, RpnStr)
-- Toggles BeventStr based on current value of RpnStr
```

#### Function button

```lua
Qmdev:CfgFc(KeyIdx, FuncPressStr, FuncReleaseStr, FuncFastStr)
-- FuncPressStr   : Lua code executed on press
-- FuncReleaseStr : Lua code executed on release (optional)
-- FuncFastStr    : Lua code executed on fast repeat (optional)
```

#### Long-press function button

```lua
Qmdev:CfgLongFc(KeyIdx, WaitMs, LongPressFunc, ShortPressFunc, InitPressFunc)
-- LongPressFunc, ShortPressFunc, InitPressFunc must be Lua functions (not strings)
```

#### RPN button

```lua
Qmdev:CfgRpn(KeyIdx, RpnPressStr, RpnReleaseStr)
-- Delegates to CfgCmd
```

#### Command button

```lua
Qmdev:CfgCmd(KeyIdx, CmdPressStr, CmdReleaseStr)
-- Simulator command / dataref path on press / release
```

#### Value button

```lua
Qmdev:CfgVal(KeyIdx, ValStr, PressInt, ReleaseInt)
-- ValStr    : dataref (XP) or B: event (MSFS)
-- PressInt  : integer written on press (optional)
-- ReleaseInt: integer written on release (optional)
```

#### Toggle value button

```lua
Qmdev:CfgValT(KeyIdx, ValStr, value0, value1)
-- Writes value0 or value1 to ValStr on each press (touch-style toggle)
```

### 6.3 Aircraft Type Checks

Low-level path/title guards (return `true` when the pattern is **not** found — i.e. script should exit):

```lua
if ilua_is_acfpath_excluded("toliss") then return end
if ilua_is_acftitle_excluded("A3") then return end
if PLANE_ICAO ~= "A320" then return end
if PLANE_TAILNUMBER ~= "D-AXLA" then return end
```

Positive-match helpers:

```lua
if ilua_acfpath_matches("FlyByWire") then ... end
if ilua_acftitle_matches("B73") then ... end
```

High-level aircraft guards (return `true` when the aircraft does **not** match — script should exit):

```lua
if ilua_require_ff320() then return end
if ilua_require_zibo() then return end
if ilua_require_fbw_a3xx() then return end
if ilua_require_pmdg_737() then return end
if ilua_require_msfs() then return end      -- exit if not running in MSFS
if ilua_require_msfs(false) then return end -- exit if running in MSFS (XP-only script)
```

See `init.lua` for the full list of `ilua_require_*` helpers.

---

## 7. Position Switch (PID) APIs

Multi-position physical switches (e.g. overhead panel) use a PID-style position tracker.

### 7.1 Global Init

```lua
local idx = QmdevPosSwitchInit(
    statusPath,   -- dataref / simvar to read current position
    step,         -- position step size
    incCmd,       -- command string when moving up
    decCmd,       -- command string when moving down (can equal incCmd for loop mode)
    delay,        -- ms between steps (default 100)
    decaccu       -- decimal accumulator threshold (default 0.1)
)
```

### 7.2 Binding to Hardware Keys

```lua
-- Press only
device:CfgPSw(KeyIdx, idx, pressExpect)

-- Press / release
device:CfgPSw(KeyIdx, idx, pressExpect, releaseExpect)

-- Toggle between two positions
device:CfgPSwTog(KeyIdx, idx, posA, posB)
```

### 7.3 Runtime Control

```lua
QmdevPosSwitchSet(idx, expectPos)          -- Move switch to target position
device:GetPSw(idx)                         -- Read current position
device:PSwDelay(idx, timeout, expectPos)   -- Delayed move
device:PSwTog(idx, timeout, posA, posB)    -- Toggle with delay
```

Example (overhead strobe switch):

```lua
local pswh1 = QmdevPosSwitchInit("1-sim/anim/lightStrobeT", 1,
    "1-sim/command/strobeLightSwitch_trigger",
    "1-sim/command/strobeLightSwitch_trigger", 1000)
qmovha:CfgPSw(0, pswh1, 1)
qmovha:CfgPSw(1, pswh1, 0)
```

---

## 8. Runtime Globals (`init.lua`)

These are defined in the simulator entry script (`init.lua`), not in `com/`.

### 8.1 Hardware Detection

Each device family has an `ilua_hw_*_absent(FastTurnsPerSecond)` function.  
Return value `true` means hardware is **not** connected.

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

Hardware assignment flags (`ilua_hw_assigned_*`) prevent double-binding when multiple profiles load.

### 8.2 Frame Loop Manager

```lua
GlobalFrameLoopManager:add(function()
    device:SetLeds()
    device:SetBkl()
end)

GlobalFrameLoopManager:tick()           -- Called from C++ each frame
GlobalFrameLoopManager:has_active_loops()
GlobalFrameLoopManager:remove(func)
```

Prefer `GlobalFrameLoopManager` over legacy `uluaAddDoLoop` for per-frame LED/display updates.

### 8.3 QLCD (CDU screen IPC)

```lua
ilua_qlcd_set_airplane(idx)   -- Select aircraft profile for QLCD
ilua_qlcd_set_brightness(brt) -- Push screen brightness to QLCD
```

### 8.4 Utilities

```lua
ilua_bool_ternary(value1, value, revert)  -- Threshold-to-bool helper
ilua_file_exists(path)
ilua_get_path(str)
IndexAllocator.new() / :alloc() / :free()
```

---

## 9. Data Reference System

### 9.1 `iDataRef` Class

`iDataRef` wraps a dataref (X-Plane) or simvar (MSFS) and tracks value changes.  
Defined in `init.lua`.

```lua
local dr = iDataRef:New(pathstr, defval, bool_revert, bool_base)
-- Returns nil if uluaFind(pathstr) fails
```

| Method | Description |
|--------|-------------|
| `Set(newval)` | Write value to simulator |
| `Get()` | Read and cache current value |
| `Changed()` | Compare cached vs last (epsilon 0.001) |
| `Update()` | Commit current value as last |
| `Invalid(val)` | Reset last value (default -1) |
| `Delta(val)` | Return `val - val_last` |
| `GetOld()` | Return last cached value |
| `GetChanged()` | `Get()` then return whether changed |
| `ChangedUpdate()` | `Get()` + if changed, `Update()` and return true |
| `GetBit()` | Bool threshold of current value |
| `GetOldBit()` | Bool threshold of last value |

Example:

```lua
local heading = iDataRef:New("sim/cockpit/autopilot/heading")
if heading:ChangedUpdate() then
    -- value changed; handle update
end
heading:Invalid(-1)
```

### 9.2 Common Dataref / Simvar Paths

#### X-Plane

- `sim/cockpit/autopilot/heading`
- `sim/cockpit/autopilot/altitude`
- `sim/cockpit/autopilot/airspeed`
- `sim/cockpit/autopilot/vertical_velocity`
- `sim/cockpit/autopilot/autopilot_on`

#### MSFS

- `A:HEADING INDICATOR, degrees`
- `A:ALTITUDE INDICATOR, feet`
- `A:AIRSPEED INDICATED, knots`
- `A:VERTICAL SPEED, feet per minute`
- `L:XMLVAR_AirSpeedIsInMach`

---

## 10. Best Practices

### 10.1 Hardware Detection

Always verify that the hardware is present before configuring:

```lua
local qmcp737c = com.sim.qm.Qmcp737c.Open()
if not qmcp737c then return end
```

### 10.2 Aircraft Guards

Prefer high-level `ilua_require_*` helpers over manual ICAO checks when available:

```lua
if ilua_require_zibo() then return end
if ilua_require_ff320() then return end
```

### 10.3 LED / Display Refresh

Bind datarefs with `Get*` in setup; push to hardware in a loop function:

```lua
qcdua:GetFm1("a320/.../AnnuFM1_Light/Power")

function CDU_LED_UPD()
    qcdua:SetLeds()
    qcdua:SetBkl()
end
GlobalFrameLoopManager:add(CDU_LED_UPD)
```

### 10.4 Deferred Reload

When simulator datarefs are not yet available at profile load time:

```lua
if uluaFind("AirbusFBW/PanelBrightnessLevel") == nil then
    ilua_req_reload()
    return
end
```

### 10.5 Error Handling and Logging

```lua
uluaLog("QCDU-A320 for Toliss")
```

### 10.6 Performance

- Register update functions with `GlobalFrameLoopManager`.
- Avoid heavy computation every frame.
- Use `ChangedUpdate()` to react only when values actually change.
- Call `FreshAlt()` / `FreshBkl()` / `FreshBits()` after aircraft swaps to force re-sync.

---

## 11. Troubleshooting

| Symptom | Likely Cause | Fix |
|---------|--------------|-----|
| Profile exits immediately | `ilua_require_*` guard mismatch | Check `AIRCRAFT_PATH`, `PLANE_ICAO`, `PLANE_TAILNUMBER` |
| `Open()` returns nil | Hardware not connected or already assigned | Verify USB; check `ilua_hw_assigned_*` flag |
| LEDs stuck / stale | Missing frame loop | Add `GlobalFrameLoopManager:add(...)` |
| `iDataRef:New` returns nil | Dataref not yet published | `ilua_req_reload()` and return early |
| Key already assigned log | Duplicate `KeyIdx` in same device | Use unique key indices per `Cfg*` call |
| Position switch overshoots | `delay` too short in `QmdevPosSwitchInit` | Increase delay (e.g. 1000 ms) |

---

## 12. Changelog

### 2026-07 – Rebrand to FlyLuaIo

- Project/framework name updated from **Qmdev** to **FlyLuaIo** in documentation.
- Code identifiers (`Qmdev`, `QmdevId`, `QmdevPosSwitch*`, `uluaQmdev*`) remain unchanged for compatibility.

### 2026-07 – Documentation sync with codebase

- Document `Class.Open()` factory pattern.
- Add `CfgEncTypeFull`, `CfgPSw` / position-switch APIs, `AddTogMenu`, `swap16`, `scaleValue`.
- Add `com/sim/wf`, `com/sim/mf`, and new `qm` classes (`Hcbravo`, `Stk*`, `Vkbgunut`, `Ww*`).
- Document `GlobalFrameLoopManager`, `ilua_require_*` guards, and full `iDataRef` API.
- Update CDU examples to use `SetLeds()` + frame loop pattern.

### 2024-05 – OOP refactor (Qmdev era)

- Introduced `com/oop` class system and `Qmdev` base class.
- Hardware classes moved under `com/sim/qm/`.
- Added `iDataRef` change-tracking helpers.
