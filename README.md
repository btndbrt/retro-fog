# Retro Fog (Resource Pack)

Retro Fog makes distance fog look like it did back in the alpha days: the fog starts much closer to you, so the world fades out the way it used to.

## Supported versions

| Minecraft version | Vanilla | Sodium |
| --- | --- | --- |
| 26.3 | Yes | Yes, Sodium 0.9.x, no extra mod |
| 1.21.11 | Yes | Yes, Sodium 0.8.x + [Sodium Core Shader Support](https://modrinth.com/mod/sodium-core-shader-support) |
| 26.1 - 26.2 | Should work (same shaders as 1.21.11), not tested | Should work with Sodium 0.9.x, not tested |

One zip covers all of these: the `mc_1_21_11` folder is an overlay that Minecraft loads automatically on 1.21.11 - 26.2, because the vanilla fog shader is written differently there than in 26.3.

Versions 1.21.6 - 1.21.8 are covered by the original [Classic Fog](https://github.com/sydist/classic-fog), which this pack is based on.

## Vanilla Tweaks

On Minecraft 26.1 - 26.3 the pack also includes these textures and sounds from [Vanilla Tweaks](https://vanillatweaks.net/), which bring back older looks:

Old Fireflies, Old Spawn Eggs, Blue Widgets Highlight, Poppy To Rose, Old Wool Colors, Classic Minecraft Logo, Bed Icons, Oarless Boats, Old XP Sounds, Old Water, Old Ice, Old Netherrack, Old Sponge Texture, Snoutless Pigs, Snoutless Cows, Old Ghasts, Old Enchant Glint, 1.11 Shulker Boxes, Old Clouds (4.8.2)

They live in the `vanillatweaks/` overlay, which only loads on 26.x, so 1.21.11 gets the fog only. To change the selection or update, download a new zip from the [Vanilla Tweaks picker](https://vanillatweaks.net/picker/resource-packs/) and run:

```bash
tools/update-vanillatweaks.sh ~/Downloads/VanillaTweaks_<...>.zip
```

## Installation

1. Download the latest release zip.
2. Put the zip (don't unzip it) into your `.minecraft/resourcepacks` folder.
3. In Minecraft, go to Options > Resource Packs and enable Retro Fog.

## Sodium

Retro Fog ships a Sodium version of the fog shader in `assets/sodium`. The same file works on Sodium 0.8.x (1.21.11) and 0.9.x (26.x).

- **26.3:** Sodium 0.9.x lets resource packs override its shaders directly, so no extra mod is needed.
- **1.21.11:** Sodium 0.8.x needs the [Sodium Core Shader Support](https://modrinth.com/mod/sodium-core-shader-support) mod. `assets/sodiumcoreshadersupport/versions.json` lists the Sodium releases the pack was checked against.

Sodium rewrites its internal shaders between versions, so a new Sodium release may need a pack update.

## Credits

Retro Fog is a continuation of [Classic Fog by sydist](https://github.com/sydist/classic-fog), which is no longer updated. The original idea and fog shader are theirs; this project keeps the pack working on newer Minecraft versions.

Credits:
Vanilla Tweaks: https://vanillatweaks.net/

## License

The fog is released into the public domain under The Unlicense, the same as the original. The `vanillatweaks/` files are not: they are used under the [Vanilla Tweaks terms](https://vanillatweaks.net/terms/). See [LICENSE.md](LICENSE.md).
