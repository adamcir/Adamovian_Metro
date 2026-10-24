# Adamovian Metro

Content addon for Garry's Mod / Metrostroi, including the Adamovian 81-717 skin, Adamovsky ASNP announcements, and Adamovian RRI (legacy cassette announcements).

## Installation

Install Metrostroi and [Metrostroi Expanded (MEX)](https://github.com/adamcir/Metrostroi_Expanded). Copy `addon/adamovian_metro/` to `garrysmod/addons/adamovian_metro/`, or use a script in `tools/` to install it.

The WAV files are already in `sound/adamovsky_asnp/`; ASNP and RRI share them. No second sound pack is required.

## Announcement systems

- **ASNP**: MEX discovers `lua/mex_asnp/lines/*.lua`. Select **Adamovsky ASNP** in the supported train's announcer menu.
- **RRI (sometimes called RPI)**: `lua/autorun/adamovian_metro_rri.lua` registers the same station lists and WAVs for Metrostroi's older RRI/cassette system. On trains with an RRI option, select/enable RRI in the train spawner and use its ordinary controls / Program I button. This does not replace or enable RRI hardware on trains that only have ASNP.

Supported maps and station IDs:

| Map | Stations | Route |
| --- | --- | --- |
| `gm_mus_loopline_*` | 651, 652, 653, 654, 655, 656 | Loop Line |
| `gm_suburb_construct*` | 101, 102, 103, 104 | Suburb line A |

RRI supports both travel directions, arrival/departure announcements, doors closing, and the final-station phrase when a terminal is selected. The in-game sequence follows Metrostroi's RRI controls. Audio is mono WAV and is resolved from the existing ASNP sound directory.

**Metrostroi limitation:** Stock RRI offers one map-wide cassette configuration, unlike ASNP's selectable announcer packs. On supported maps, Adamovian Metro replaces the stock RRI cassette with Adamovian announcements. On other maps, stock RRI is left unchanged. ASNP selection remains separate.

## Diagnostics

Run `adamovsky_rri_status` in the GMod console. It shows the current map, which Adamovian pack was discovered, whether the RRI configuration is active, station count, and any missing WAV paths.

RRI setup is deferred until Metrostroi and MEX load the line definitions, and is reapplied if the map script replaces the cassette afterwards. Restart the map or respawn trains after installing/updating to ensure train systems load the new configuration.
