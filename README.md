# Adamovian Metro

Content addon for Garry's Mod / Metrostroi, including Adamovian skins and announcements for ASNP and RPI (legacy RRI).

## Installation

Install [Metrostroi Expanded (MEX)](https://github.com/adamcir/Metrostroi_Expanded) alongside Metrostroi. Copy `addon/adamovian_metro/` to `garrysmod/addons/adamovian_metro/` or use a script in `tools/`. The addon does not need its own announcer autorun loader.

## Shared announcement audio

All recordings are located in **`sound/adamovsky_announcer/`**:

```text
sound/adamovsky_announcer/
  common/
  mus/loopline/
  suburb/
```

The 16 mono PCM 16-bit 44.1 kHz WAVs have been digitally boosted by approximately **+4.2 to +5.1 dB RMS** using a soft-peak limiter (avoids hard clipping). ASNP and RPI both use the boosted recordings. Do not repeatedly reapply gain to these files. Do not install or retain an older `sound/adamovsky_asnp/` copy.

## Announcer definitions

```text
lua/mex_asnp/languages/ad.lua
lua/mex_asnp/lines/loopline.lua
lua/mex_asnp/lines/suburb_construct.lua
lua/mex_rpi/lines/adamovian.lua
```

MEX discovers these automatically via its `MEXASNP.RegisterPack()` and `MEXRPI.RegisterPack()` APIs. The RPI definitions use `sourceASNP` to inherit each route's station IDs, order, timing and audio, instead of duplicating that data. No Lua file is needed in `lua/autorun/` for RPI.

| Map | Stations | Route |
| --- | --- | --- |
| `gm_mus_loopline_*` | 651, 652, 653, 654, 655, 656 | Loop Line |
| `gm_suburb_construct*` | 101 (Depo), 102 (Centrum), 103 (Prumyslova), 104 (Luka) | Suburb line A (circular) |

**Suburb circuit:** Depo is a regular passenger station, not a non-passenger depot or a forced terminus. Both ASNP and RPI loop 101 → 102 → 103 → 104 → 101, including arrival/departure announcements at Depo. The same circuit works in reverse.\n\n**ASNP:** Select *Adamovsky ASNP* from the supported train's announcer list.

**RPI/RRI:** Use an RRI-equipped train and enable its existing RRI option. MEX loads the matching Adamovian cassette, including directional departure, arrival and terminal announcements. Stock Metrostroi supports only one RRI cassette configuration per map, so a custom RPI pack replaces the map's default RRI audio, not the selectable ASNP entries.

## Checking the installation

Run `mex_rpi_status` in the GMod console to view the current RPI pack and missing audio. ASNP diagnostics are provided by MEX. Respawn existing RRI trains after updating so they do not retain stale announcer tables.

MEX RPI API documentation: [MEX RPI README](https://github.com/adamcir/Metrostroi_Expanded/blob/main/lua/metrostroi_expanded/rpi/README.md).
