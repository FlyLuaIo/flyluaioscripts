## Qmdev Lua API Developer Guide

### Table of Contents
1. Overview
2. Architecture
3. Base Classes (`com/oop`)
4. Core Device Classes (`com/sim`)
5. Hardware Abstraction Classes (`com/sim/qm`)
6. Configuration APIs
7. Data Reference System
8. Best Practices
9. Troubleshooting
10. Changelog

---

## 1. Overview

Qmdev is a hardware control framework for flight simulators.  
It uses Lua scripts to bridge USB HID hardware devices with:

- **X-Plane 11 / 12**
- **Microsoft Flight Simulator 2020 / 2024**

You typically:

1. Use the shared device framework under `com/` (`com/oop`, `com/sim`, `com/sim/qm`).
2. Create aircraft‑specific configuration files under `xp/` (X‑Plane) or `msfs/` (MSFS).
3. Map your hardware (MCP, CDU, FCU, G1000, etc.) to aircraft systems using the configuration APIs.

### Main Features

- **Embedded Lua scripting engine** for hardware control and simulator communication.
- **Hardware abstraction layer** implemented in Lua classes.
- **Cross‑simulator support** with a single shared core.
- **Modular design**: each hardware–aircraft pair has its own Lua profile file.

---

## 2. Architecture

The repository is organized as follows:

```text
root/
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
        ├── Qmdev.lua        # Core device base class
        ├── QmReload.lua     # Reload / helper utilities
        └── qm/              # Concrete hardware classes
            ├── Qmcp737c.lua
            ├── Qfcu.lua
            ├── Qcdu.lua
            ├── Qcdua.lua
            ├── Qcduaf.lua
            ├── Qcdub.lua
            ├── Qcdubf.lua
            ├── Qgmc710.lua
            ├── Qg1kmfd.lua
            ├── Qg1kpfd.lua
            ├── Qmovha.lua
            └── Qmpe.lua
```

- The `com/` tree is **shared** by both X‑Plane and MSFS.
- The `xp/` and `msfs/` directories contain **aircraft‑specific logic and mapping**.

---

## 3. Base Classes (`com/oop`)

These files implement a small object‑oriented layer in Lua and are used by all higher‑level components.

### `Object.lua`

Provides core OOP features:

- Class creation
- Inheritance
- Method dispatch

Typical usage:

```lua
local Object = require("com.oop.Object")

local MyClass = Object:extend()

function MyClass:new(name)
    self.name = name
end

function MyClass:hello()
    print("Hello, " .. (self.name or "world"))
end
```

### `class.lua`

Helper utilities to simplify defining classes.  
In the existing framework, it is used internally by `Object.lua` and higher‑level modules.

### `include.lua`

Simple module include helper for splitting code into multiple files and reusing common pieces.

### `package.lua`

Implements basic package and module loading utilities for the framework, abstracting away Lua’s built‑in `package` details.

---

## 4. Core Device Classes (`com/sim`)

### 4.1 `Qmdev` – Core Base Class

`Qmdev` is the base class for all hardware devices.  
It contains:

- Device‑level configuration
- Common encoder / button mapping logic
- Data reference helpers
- Bit / LED state management

#### Constructor

```lua
local qmdev = com.sim.Qmdev:new()
```

#### Initialization

```lua
-- Initialize the device with default values
function Qmdev:init()
    self.QmdevId = 0                 -- Device ID
    self.FastTurnsPerSecond = 40     -- Threshold for "fast" encoder rotations
    self.MaxBrightness = 100         -- Maximum display / LED brightness
    self.KeyTable = {}               -- Key definitions
    self.Bits = {}                   -- Bit / LED states
end

-- Configure initialization parameters
function Qmdev:CfgInit(ftpsdefval, maxBright)
    -- ftpsdefval: default fast-turns-per-second threshold
    -- maxBright : maximum brightness value
end
```

### 4.2 Other Core Helpers

#### `QmReload.lua`

Provides helpers to reload Lua configuration without restarting the whole plugin.

Typical responsibilities:

- Reload mapping files when they change.
- Reset device state and re‑initialize.

Exact usage depends on your integration in X‑Plane or MSFS, but usually it is called from your bootstrap / entry script.

---

## 5. Hardware Abstraction Classes (`com/sim/qm`)

Each physical hardware device has a corresponding class under `com/sim/qm/`.  
These classes inherit from `Qmdev` and expose device‑specific configuration helpers.

Below are examples of commonly used classes.

### 5.1 Qcdua – A320 Captain CDU

```lua
local qcdua = com.sim.qm.Qcdua:new()
if not qcdua:Init() then return end

-- Configure MCDU1 keys
qcdua:CfgCmd(0, "AirbusFBW/MCDU1LSK1L")
qcdua:CfgCmd(1, "AirbusFBW/MCDU1LSK2L")

-- Configure LED state
qcdua:GetFm1("cpuwolf/qmdev/QCDU-A320/condbtn[0]")
qcdua:GetInd("cpuwolf/qmdev/QCDU-A320/condbtn[0]")
qcdua:GetRdy("cpuwolf/qmdev/QCDU-A320/condbtn[0]")

-- Configure brightness
qcdua:GetBkl("AirbusFBW/MCDUIntegBrightness[0]", 40)
qcdua:GetScreenBrt("AirbusFBW/DUBrightness[6]")
```

### 5.2 Qcduaf – A320 First Officer CDU

```lua
local qcduaf = com.sim.qm.Qcduaf:new()
if not qcduaf:Init() then return end

-- Configure MCDU2 keys
qcduaf:CfgCmd(0, "AirbusFBW/MCDU2LSK1L")
qcduaf:CfgCmd(1, "AirbusFBW/MCDU2LSK2L")

-- Configure LED state
qcduaf:GetFm1("cpuwolf/qmdev/QCDU-A3201/condbtn[0]")
qcduaf:GetInd("cpuwolf/qmdev/QCDU-A3201/condbtn[0]")

-- Configure brightness
qcduaf:GetBkl("AirbusFBW/MCDUIntegBrightness[1]", 40)
qcduaf:GetScreenBrt("AirbusFBW/DUBrightness[7]")
```

### 5.3 Qcdub – Boeing 737 Captain CDU

```lua
local qcdub = com.sim.qm.Qcdub:new()
if not qcdub:Init() then return end

-- FMC1 key assignments
qcdub:CfgCmd(0, "laminar/B738/button/fmc1_1L")
qcdub:CfgCmd(1, "laminar/B738/button/fmc1_2L")

-- Encoder configuration for display brightness
qcdub:CfgEncFull(
    69, 70,
    "laminar/B738/electric/instrument_brightness[10]",
    0.05, 0.05, 1, 0.05, 1.0
)

-- Screen brightness feedback
qcdub:GetScreenBrt("laminar/B738/electric/instrument_brightness[10]")
```

### 5.4 Qcdubf – Boeing 737 First Officer CDU

```lua
local qcdubf = com.sim.qm.Qcdubf:new()
if not qcdubf:Init() then return end

-- FMC2 key assignments
qcdubf:CfgCmd(0, "laminar/B738/button/fmc2_1L")
qcdubf:CfgCmd(1, "laminar/B738/button/fmc2_2L")

-- Encoder configuration for display brightness
qcdubf:CfgEncFull(
    69, 70,
    "laminar/B738/electric/instrument_brightness[11]",
    0.05, 0.05, 1, 0.05, 1.0
)

-- Screen brightness feedback
qcdubf:GetScreenBrt("laminar/B738/electric/instrument_brightness[11]")
```

---

## 6. Configuration APIs

### 6.1 Encoder Configuration

#### Full encoder configuration

```lua
Qmdev:CfgEncFull(
    DecKey,     -- Decrement key index
    IncKey,     -- Increment key index
    Rpnstr,     -- RPN or dataref string
    SlowStep,   -- Step size for slow rotation (default 1)
    FastStep,   -- Step size for fast rotation (default 1)
    StepMode,   -- Step mode (default 0)
    MinStep,    -- Minimum allowed value (default 0)
    MaxStep     -- Maximum allowed value (default 99999)
)
```

#### Simplified encoder configuration

```lua
Qmdev:CfgEnc(DecKey, IncKey, Rpnstr)
-- Uses default step sizes and mode
```

### 6.2 Button Configuration

#### Toggle button

```lua
Qmdev:CfgTog(KeyIdx, BeventStr, RpnStr)
-- KeyIdx   : button index
-- BeventStr: base event (e.g. B event or sim command)
-- RpnStr   : RPN script to execute on toggle
```

#### Function button

```lua
Qmdev:CfgFc(KeyIdx, FuncPressStr, FuncReleaseStr)
-- KeyIdx       : button index
-- FuncPressStr : Lua code executed on press
-- FuncReleaseStr: Lua code executed on release (optional)
```

#### Long‑press function button

```lua
Qmdev:CfgLongFc(KeyIdx, WaitMs, LongPressFunc, ShortPressFunc, InitPressFunc)
-- KeyIdx        : button index
-- WaitMs        : long‑press threshold in milliseconds
-- LongPressFunc : function called on long press
-- ShortPressFunc: function called on short press
-- InitPressFunc : function called when key is initially pressed (optional)
```

#### RPN button

```lua
Qmdev:CfgRpn(KeyIdx, RpnPressStr, RpnReleaseStr)
-- RpnPressStr   : RPN executed on press
-- RpnReleaseStr : RPN executed on release (optional)
```

#### Command button

```lua
Qmdev:CfgCmd(KeyIdx, CmdPressStr, CmdReleaseStr)
-- Simulator command on press / release
```

#### Value button

```lua
Qmdev:CfgVal(KeyIdx, ValStr, PressInt, ReleaseInt)
-- ValStr   : dataref path
-- PressInt : integer value written on press (optional)
-- ReleaseInt: integer value written on release (optional)
```

#### Toggle value button

```lua
Qmdev:CfgValT(KeyIdx, ValStr， value0, value1)
-- Writes to ValStr when the button is active (touch‑style input)
```


### 6.3 Aircraft Type Checks

Use multiple checks to ensure a profile only runs on the intended aircraft:

```lua
-- ICAO code
if PLANE_ICAO ~= "A320" then return end

-- Tail number
if PLANE_TAILNUMBER ~= "D-AXLA" then return end

-- Path exclusion
if ilua_is_acfpath_excluded("toliss") then return end

-- Title exclusion
if ilua_is_acftitle_excluded("A3") then return end
```

---

## 7. Data Reference System

### 7.1 `iDataRef` Class

`iDataRef` is a helper that wraps a dataref (X‑Plane) or simvar (MSFS) and tracks value changes.

```lua
-- Create a data reference
local dataref = iDataRef:New("sim/cockpit/autopilot/heading")

-- Get the current value
local value = dataref:Get()

-- Detect changes
if dataref:ChangedUpdate() then
    -- Value changed; handle update
end

-- Mark as invalid
dataref:Invalid(-1)
```

### 7.2 Common Dataref / Simvar Paths

#### X-Plane

- `sim/cockpit/autopilot/heading` – AP heading
- `sim/cockpit/autopilot/altitude` – AP altitude
- `sim/cockpit/autopilot/airspeed` – AP airspeed
- `sim/cockpit/autopilot/vertical_velocity` – AP vertical speed
- `sim/cockpit/autopilot/autopilot_on` – AP master state

#### MSFS

- `A:HEADING INDICATOR, degrees` – Heading
- `A:ALTITUDE INDICATOR, feet` – Altitude
- `A:AIRSPEED INDICATED, knots` – Indicated airspeed
- `A:VERTICAL SPEED, feet per minute` – Vertical speed
- `L:XMLVAR_AirSpeedIsInMach` – Airspeed unit (Mach or knots)

---

## 8. Best Practices

### 8.1 Hardware Detection

Always verify that the hardware is present before configuring:

```lua
local qmcp737c = com.sim.qm.Qmcp737c:new()
if not qmcp737c:Init() then return end

-- G1000 hardware detection
if ilua_hw_qg1k_pfd_absent(FastTurnsPerSecond) then return end
```

### 8.2 Aircraft Type Checks

Use multiple checks to ensure your script only runs where intended:

```lua
-- Path checks
if ilua_is_acfpath_excluded("FlyByWire") or ilua_is_acfpath_excluded("A320") then return end

-- Title checks
if ilua_is_acftitle_excluded("A3") or ilua_is_acftitle_excluded("A2") then return end

-- ICAO checks
if PLANE_ICAO ~= "B738" and PLANE_ICAO ~= "B736" then return end

-- Tail number checks
if PLANE_TAILNUMBER ~= "ZB738" then return end
```

### 8.3 Choosing Configuration Methods

- **Traditional methods**: direct calls like `CfgRpn`, `CfgEncFull`, `CfgCmd` – best when you need fine‑grained control for a specific device.

```lua
-- Traditional configuration
qmcp737c:CfgRpn(0, "(>H:AS1000_PFD_CRS_DEC)")
qmcp737c:CfgEncFull(0, 1, "dataref", 0.05, 0.05, 1, 0.05, 1.0)
```

### 8.4 Error Handling and Logging

Use logging and defensive checks to simplify debugging:

```lua
-- Log important messages
uluaLog("QCDU-A320 for Toliss")

-- Check whether a critical dataref exists
if uluaFind("AirbusFBW/PanelBrightnessLevel") == nil then
    ilua_req_reload()
    return
end
```

### 8.5 Main Loop

- Register update functions with `uluaAddDoLoop`.
- Avoid heavy computations on every frame.
- Use `ChangedUpdate()` to only react when a value actually changes.
- Choose sensible update intervals.

---

