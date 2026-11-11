# Rewind Edition (Resource Pack)

Rewind Edition brings back the look and feel of old Minecraft in modern versions:

- **Old fog:** distance fog looks like it did in the alpha days. It starts much closer to you, so the world fades out the way it used to.
- **Old textures and sounds:** a selection of [Vanilla Tweaks](https://vanillatweaks.net/) that restore older looks, like the old water, clouds, logo, ores and wool colours, plus the netherite armor from [Programmer Art+](https://github.com/Crackers0106/Programmer-Art-Plus).

Formerly **Retro Fog**, a continuation of [Classic Fog by sydist](https://github.com/sydist/classic-fog).

## Supported versions

| Minecraft version | Fog | Old textures and sounds | Sodium | Tested |
| --- | --- | --- | --- | --- |
| 26.3 | Yes | Yes | Sodium 0.9.x, no extra mod | Not yet |
| 26.1 - 26.2 | Yes | Yes | Sodium 0.9.x, no extra mod | Not yet |
| 1.21.11 | Yes | Yes | Sodium 0.8.x + [Sodium Core Shader Support](https://modrinth.com/mod/sodium-core-shader-support) | Not yet |
| 1.21.9 - 1.21.10 | Yes | Yes | Sodium 0.7.x + Sodium Core Shader Support | Not yet |
| 1.21.6 - 1.21.8 | Yes | Yes | Sodium 0.6.13 / 0.7.x + Sodium Core Shader Support | Not yet |

None of these combinations have been tested with the current version of the pack yet. Versions before 1.21.6 are not supported: their fog works completely differently.

One zip covers all of these. Minecraft picks the right parts automatically:

- `fog_1_21_6_to_1_21_8/` and `fog_1_21_9_to_26_2/` hold the fog shader for older versions, because the vanilla fog shader is written differently there than in 26.3.
- `sodium_0_7/` holds the fog shader for Sodium 0.6.13 - 0.7.x (Minecraft 1.21.6 - 1.21.10), which differs slightly from the one in Sodium 0.8 and newer.
- `vanillatweaks/` holds the old textures and sounds for 26.1 - 26.3, and `vanillatweaks_1_21/` the same for 1.21.6 - 1.21.11 (Vanilla Tweaks makes separate downloads for each).
- `programmer_art_plus/` holds the netherite armor from Programmer Art+, for 1.21.6 - 26.3.

## Installation

1. Download the latest release zip.
2. Put the zip (don't unzip it) into your `.minecraft/resourcepacks` folder.
3. In Minecraft, go to Options > Resource Packs and enable the pack.

## What's included from Vanilla Tweaks

Old Fireflies, Old Spawn Eggs, Blue Widgets Highlight, Poppy To Rose, Old Wool Colors, Classic Minecraft Logo, Classic Panorama, Bed Icons, Oarless Boats, Old XP Sounds, Old Water, Old Ice, Old Ores, Old Netherrack, Old Redstone Torch, Old Sponge Texture, Snoutless Pigs, Snoutless Cows, Kinda Classic Sheep, Old Ghasts, Old Enchant Glint, 1.11 Shulker Boxes, Old Clouds

On 1.21.6 - 1.21.11 the same tweaks are included, except Old Sponge Texture.

Textures are only changed where Vanilla Tweaks has a tweak for them; everything else stays as in vanilla Minecraft.

## From Programmer Art+

Netherite armor (worn and inventory icons) comes from [Programmer Art+](https://github.com/Crackers0106/Programmer-Art-Plus) instead of Vanilla Tweaks. Programmer Art+ has no baby version of the armor, so baby players keep the vanilla look.

## Sodium

The pack ships Sodium versions of the fog shader: `assets/sodium` for Sodium 0.8 and newer, and `sodium_0_7/` for Sodium 0.6.13 - 0.7.x.

- **26.x:** Sodium 0.9.x lets resource packs override its shaders directly, so no extra mod is needed.
- **1.21.6 - 1.21.11:** Sodium needs the [Sodium Core Shader Support](https://modrinth.com/mod/sodium-core-shader-support) mod. `assets/sodiumcoreshadersupport/versions.json` lists the Sodium releases the pack's shaders were made for.

Sodium rewrites its internal shaders between versions, so a new Sodium release may need a pack update.

## Building

```bash
./build.sh          # version from git describe
./build.sh 1.1.0    # explicit version
```

Needs `zip` (`sudo apt install zip`). The pack goes to `dist/RewindEdition-<version>.zip`; repo-only files like this README, `build.sh` and `tools/` are left out.

## Updating the Vanilla Tweaks

To add more tweaks or update to a new Vanilla Tweaks release, download a zip from the [Vanilla Tweaks picker](https://vanillatweaks.net/picker/resource-packs/) and run:

```bash
tools/update-vanillatweaks.sh ~/Downloads/VanillaTweaks_<...>.zip
```

The script reads the zip's Minecraft version and puts it in the right folder: `vanillatweaks/` for 26.x, `vanillatweaks_1_21/` for 1.21. It **adds** the zip's tweaks to the ones already there; nothing is removed. To start over with only the zip's tweaks, use `--replace`. The combined lists are kept in each folder's `Selected Packs.txt`; update the list above to match. Needs `jq` (`sudo apt install jq`).

## Credits

- **Fog:** [Classic Fog by sydist](https://github.com/sydist/classic-fog), which is no longer updated. The original idea and fog shader are theirs; this project keeps the pack working on newer Minecraft versions.
- **Old textures and sounds:**

  ```
  Credits:
  Vanilla Tweaks: https://vanillatweaks.net/
  ```
- **Netherite armor:** [Programmer Art+](https://github.com/Crackers0106/Programmer-Art-Plus) by Crackers0106, used under [CC BY 4.0](licenses/CC-BY-4.0.txt).

## License

The fog is released into the public domain under The Unlicense, the same as the original. The `vanillatweaks/` and `vanillatweaks_1_21/` files are not: they are used under the [Vanilla Tweaks terms](https://vanillatweaks.net/terms/). The `programmer_art_plus/` files are CC BY 4.0 by Crackers0106. See [LICENSE.md](LICENSE.md).
