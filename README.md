# flyluaioscripts

Lua hardware mapping profiles for [FlyLuaIO](https://github.com/cpuwolf/flyluaio) — the successor to qmdev.

FlyLuaIO bridges USB HID cockpit panels to **X-Plane 11/12** and **Microsoft Flight Simulator 2020/2024**. This repository contains the shared Lua framework and aircraft-specific profile scripts loaded by the FlyLuaIO plugin.

## Requirements

- [FlyLuaIO](https://github.com/cpuwolf/flyluaio) plugin installed in your simulator
- Supported FlyLuaIO hardware (MCP, CDU, FCU, G1000, overhead panel, etc.)

## Repository layout

```text
flyluaioscripts/
├── com/          Shared framework (OOP, Qmdev base class, hardware drivers)
├── xp/           X-Plane aircraft profiles
├── msfs/         MSFS aircraft profiles
└── LUA_API_DEVELOPER_GUIDE.md
```

| Directory | Purpose |
|-----------|---------|
| `com/oop/` | Lua OOP infrastructure |
| `com/sim/qm/` | Hardware device classes (Qmcp737c, Qcdua, Qfcu, …) |
| `com/sim/wf/` | Wingflex / third-party adapters |
| `com/sim/mf/` | MobiFlight integration |
| `xp/` | X-Plane mapping scripts (`{DEVICE}_{AIRCRAFT}.lua`) |
| `msfs/` | MSFS mapping scripts |

Profile naming:

- `{DEVICE}_{AIRCRAFT/ADDON}.lua` — aircraft-specific mapping
- `z_{DEVICE}_GA.lua` — General Aviation fallback
- `z_{DEVICE}_no_msfs.lua` — disable on MSFS

## Documentation

Full API reference, examples, and troubleshooting:

**[LUA_API_DEVELOPER_GUIDE.md](./LUA_API_DEVELOPER_GUIDE.md)**

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
