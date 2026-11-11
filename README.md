# Rewind Edition (Resource Pack)

Rewind Edition brings back the look and feel of old Minecraft in modern versions:

- **Old fog:** distance fog looks like it did in the alpha days. It starts much closer to you, so the world fades out the way it used to.
- **Old textures and sounds** (26.x only): a selection of [Vanilla Tweaks](https://vanillatweaks.net/) that restore older looks, like the old water, clouds, logo and wool colours.

Formerly **Retro Fog**, a continuation of [Classic Fog by sydist](https://github.com/sydist/classic-fog).

## Supported versions

| Minecraft version | Fog | Old textures and sounds | Sodium | Tested |
| --- | --- | --- | --- | --- |
| 26.3 | Yes | Yes | Sodium 0.9.x, no extra mod | Not yet |
| 26.1 - 26.2 | Yes | Yes | Sodium 0.9.x, no extra mod | Not yet |
| 1.21.11 | Yes | No | Sodium 0.8.x + [Sodium Core Shader Support](https://modrinth.com/mod/sodium-core-shader-support) | Not yet |

None of these combinations have been tested with the current version of the pack yet.

One zip covers all of these. Minecraft picks the right parts automatically:

- `mc_1_21_11/` holds the fog shader for 1.21.11 - 26.2, because the vanilla fog shader is written differently there than in 26.3.
- `vanillatweaks/` holds the old textures and sounds, and only loads on 26.1 - 26.3.

Versions 1.21.6 - 1.21.8 are covered by the original [Classic Fog](https://github.com/sydist/classic-fog).

## Installation

1. Download the latest release zip.
2. Put the zip (don't unzip it) into your `.minecraft/resourcepacks` folder.
3. In Minecraft, go to Options > Resource Packs and enable the pack.

## What's included from Vanilla Tweaks

Old Fireflies, Old Spawn Eggs, Blue Widgets Highlight, Poppy To Rose, Old Wool Colors, Classic Minecraft Logo, Bed Icons, Oarless Boats, Old XP Sounds, Old Water, Old Ice, Old Netherrack, Old Sponge Texture, Snoutless Pigs, Snoutless Cows, Old Ghasts, Old Enchant Glint, 1.11 Shulker Boxes, Old Clouds (4.8.2)

Textures are only changed where Vanilla Tweaks has a tweak for them; everything else stays as in vanilla Minecraft.

## Sodium

The pack ships a Sodium version of the fog shader in `assets/sodium`. The same file works on Sodium 0.8.x (1.21.11) and 0.9.x (26.x).

- **26.x:** Sodium 0.9.x lets resource packs override its shaders directly, so no extra mod is needed.
- **1.21.11:** Sodium 0.8.x needs the [Sodium Core Shader Support](https://modrinth.com/mod/sodium-core-shader-support) mod. `assets/sodiumcoreshadersupport/versions.json` lists the Sodium releases the pack was checked against.

Sodium rewrites its internal shaders between versions, so a new Sodium release may need a pack update.

## Building

```bash
./build.sh          # version from git describe
./build.sh 1.1.0    # explicit version
```

Needs `zip` (`sudo apt install zip`). The pack goes to `dist/RewindEdition-<version>.zip`; repo-only files like this README, `build.sh` and `tools/` are left out.

## Updating the Vanilla Tweaks

To change the selection or update to a new Vanilla Tweaks release, download a new zip from the [Vanilla Tweaks picker](https://vanillatweaks.net/picker/resource-packs/) and run:

```bash
tools/update-vanillatweaks.sh ~/Downloads/VanillaTweaks_<...>.zip
```

The selected tweaks are listed in `vanillatweaks/Selected Packs.txt`. Update the list above to match.

## Credits

- **Fog:** [Classic Fog by sydist](https://github.com/sydist/classic-fog), which is no longer updated. The original idea and fog shader are theirs; this project keeps the pack working on newer Minecraft versions.
- **Old textures and sounds:**

  ```
  Credits:
  Vanilla Tweaks: https://vanillatweaks.net/
  ```

## License

The fog is released into the public domain under The Unlicense, the same as the original. The `vanillatweaks/` files are not: they are used under the [Vanilla Tweaks terms](https://vanillatweaks.net/terms/). See [LICENSE.md](LICENSE.md).
