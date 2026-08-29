# flyluaioscripts

Lua hardware mapping profiles for [FlyLuaIO](https://github.com/cpuwolf/flyluaio) — the successor to qmdev.

FlyLuaIO bridges USB HID cockpit panels to **X-Plane 11/12** and **Microsoft Flight Simulator 2020/2024**. This repository contains the shared Lua framework and aircraft-specific profile scripts loaded by the FlyLuaIO plugin.

## Performance note (plugin runtime)

FlyLuaIO’s **embedded LuaJIT** is not the same performance model as typical market LuaJIT plugins (**XLua**, **SASL**, **FlyWithLua**), which usually run Lua every frame on the X-Plane sim / flight-loop thread. FlyLuaIO runs script work on a dedicated worker path; the product claim is **ZERO X-Plane FPS impact**. (This repo only ships scripts; the runtime lives in the plugin.)

## Requirements

- [FlyLuaIO](https://github.com/cpuwolf/flyluaio) plugin installed in your simulator
  - Download: <https://gitee.com/FlyLuaIo/flyluaio/releases>
- Supported FlyLuaIO hardware (MCP, CDU, FCU, G1000, overhead panel, etc.)

## Repository layout

```text
flyluaioscripts/
├── com/          Shared framework (OOP, Qmdev base class, hardware drivers)
├── xp/           X-Plane aircraft profiles
├── msfs/         MSFS aircraft profiles
├── joysticks/    USB HID device JSON (+ joystick-config.schema.json)
├── mobiflight/   MobiFlight device JSON (+ mobiflight-config.schema.json)
└── LUA_API_DEVELOPER_GUIDE.md
```

| Directory | Purpose |
|-----------|---------|
| `com/oop/` | Lua OOP infrastructure |
| `com/sim/qm/` | Hardware device classes (Qmcp737c, Qcdua, Qfcu, …) |
| `com/sim/wf/` | Wingflex / third-party adapters |
| `com/sim/mf/` | MobiFlight device classes (CfMega, CfNano, KayeRoof, RfA107, RfA112) |
| `xp/` | X-Plane mapping scripts (`{DEVICE}_{AIRCRAFT}.lua`) |
| `msfs/` | MSFS mapping scripts |
| `joysticks/` | HID panel configs validated by `joystick-config.schema.json` |
| `mobiflight/` | MobiFlight device JSON configs (see [MobiFlight](#mobiflight) below) |

Profile naming:

- `{DEVICE}_{AIRCRAFT/ADDON}.lua` — aircraft-specific mapping
- `z_{DEVICE}_GA.lua` — General Aviation fallback
- `z_{DEVICE}_no_msfs.lua` — disable on MSFS

## MobiFlight

FlyLuaIO supports [MobiFlight](https://mobiflight.com/) hardware modules as an alternative to USB HID panels — especially useful for custom home-cockpit builds with Arduino-based boards.

**Supported devices:**

| Device class | Hardware | Description |
|---|---|---|
| `CfMega` | MobiFlight Mega | Full-featured board (256 KB flash, many I/O pins) |
| `CfNano` | MobiFlight Nano | Compact board (Pro Micro based) |
| `KayeRoof` | KayeRoof custom board | Large overhead panel |
| `RfA107` | Rowsfire A107 | Overhead panel module |
| `RfA112` | Rowsfire A112 | Overhead panel module |

Each device has a JSON definition in `mobiflight/` (validated by `mobiflight-config.schema.json`) and a generated Lua class in `com/sim/mf/`. Aircraft-specific binding scripts live under `msfs/` (prefix `CF*`, `RF*`, `KAYEROOF_*`).

For XP generic / GA fallback, see `xp/z_*_GA.lua` files.

## Documentation

Full API reference, examples, and troubleshooting:

**[LUA_API_DEVELOPER_GUIDE.md](./LUA_API_DEVELOPER_GUIDE.md)**

Device JSON schemas:

- [joysticks/joystick-config.schema.json](./joysticks/joystick-config.schema.json)
- [mobiflight/mobiflight-config.schema.json](./mobiflight/mobiflight-config.schema.json)

Codegen that turns device JSON into Lua classes lives in the private sibling tooling that maintains this tree (not required for end users who only load profiles).

## Quick start

1. Install the FlyLuaIO plugin and connect your hardware.
2. Place or symlink this repository where the plugin loads scripts from.
3. Find a profile for your hardware and aircraft under `xp/` or `msfs/`.
4. To add a new mapping, copy the closest existing profile and adjust dataref paths and aircraft guards.

Minimal profile skeleton:

```lua
local device = com.sim.qm.Qmcp737c.Open()
if not device then return end

device:CfgCmd(0, "sim/autopilot/heading_down")
GlobalFrameLoopManager:add(function() device:LoopMcp() end)
```

## Notes

- Files under `com/` marked `Don't modify this file` are framework core.
- Runtime APIs (`ulua*`, `ilua*`, `iDataRef`, `GlobalFrameLoopManager`) are provided by the FlyLuaIO plugin, not this repository.
- Legacy code identifiers such as `Qmdev` and `uluaQmdevConfig` are retained from the qmdev era for compatibility.
