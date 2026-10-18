local ASNP = AdamovskyASNP

-- Common phrases are shared across all maps. Map folders contain ONLY
-- station-name recordings (e.g. loopline/651.wav).
-- Durations are placeholders until actual recordings are measured.
ASNP.SoundDefinitions = {
    click1 = {"common/click1.wav", 0.5, "subway_announcers/asnp/boiko_new/click1.mp3"},
    click2 = {"common/click2.wav", 0.3, "subway_announcers/asnp/boiko_new/click2.mp3"},
    click3 = {"common/click3.wav", 0.3, "subway_announcers/asnp/boiko_new/click3.mp3"},
    announcer_ready = {"common/announcer_ready.wav", 3.295479},
    doors_closing = {"common/doors_closing.wav", 3.782542},
    last = {"common/last.wav", 4.425625},
    arr = {"common/arr.wav", 1.5},
    next = {"common/next.wav", 1.5}
}

for id = 651, 656 do
    ASNP.SoundDefinitions["station_" .. id] = {
        "loopline/" .. id .. ".wav", 1.5
    }
end

function ASNP.BuildSounds()
    -- Keep the announcer available to both ASNP and legacy announcer spawners.
    -- Several 81-717/81-718 variants explicitly hide entries with asnp=true.
    local sounds = {}
    for key, def in pairs(ASNP.SoundDefinitions) do
        local own = "adamovsky_asnp/" .. def[1]
        local path = file.Exists("sound/" .. own, "GAME") and own or def[3]
        if path then
            sounds[key] = {path, def[2]}
        else
            print("[Adamovsky ASNP] Missing audio: " .. own)
        end
    end
    return sounds
end
