local ASNP = AdamovskyASNP

-- Each custom clip can be supplied later under sound/adamovsky_asnp/.
-- If not present, use existing Metrostroi audio (avoids missing-sound spam).
-- Lengths of custom recordings should be adjusted after recording.
ASNP.SoundDefinitions = {
    click1 = {"common/click1.wav", 0.5, "subway_announcers/asnp/boiko_new/click1.mp3"},
    click2 = {"common/click2.wav", 0.3, "subway_announcers/asnp/boiko_new/click2.mp3"},
    click3 = {"common/click3.wav", 0.3, "subway_announcers/asnp/boiko_new/click3.mp3"},
    doors_closing = {"common/doors_closing.wav", 3.782542, "subway_announcers/asnp/boiko_new/doors_closing.mp3"},
    announcer_ready = {"common/announcer_ready.wav", 3.295479, "subway_announcers/asnp/boiko_new/announcer_ready.mp3"},
    last = {"common/last.wav", 4.425625, "subway_announcers/asnp/boiko_new/spec_attention_last.mp3"}
}

local clips = {
    [651] = {"pervoaprelskaya.mp3", 1.186750},
    [652] = {"park_arr.mp3", 2.638146},
    [653] = {"metrostroiteley_arr.mp3", 3.264208},
    [654] = {"morskaya.mp3", 1.085170},
    [655] = {"slavnaya_strana_arr.mp3", 3.270875},
    [656] = {"pionerskaya_arr.mp3", 2.980854}
}
for id, entry in pairs(clips) do
    ASNP.SoundDefinitions["arr_" .. id] = {
        "loopline/arr_" .. id .. ".wav", entry[2],
        "subway_announcers/asnp/boiko_new/loopline/" .. entry[1]
    }
end
local nextClips = {
    [651] = {"pervoaprelskaya.mp3", 1.186750},
    [652] = {"metrostroiteley_next.mp3", 1.291229}, -- replacement until custom recording
    [653] = {"metrostroiteley_next.mp3", 1.291229},
    [654] = {"morskaya.mp3", 1.085170},
    [655] = {"slavnaya_strana_next.mp3", 1.365604},
    [656] = {"pionerskaya_next.mp3", 1.035500}
}
for id, entry in pairs(nextClips) do
    ASNP.SoundDefinitions["next_" .. id] = {
        "loopline/next_" .. id .. ".wav", entry[2],
        "subway_announcers/asnp/boiko_new/loopline/" .. entry[1]
    }
end

function ASNP.BuildSounds()
    local sounds = {asnp = true}
    for key, def in pairs(ASNP.SoundDefinitions) do
        local own = "adamovsky_asnp/" .. def[1]
        local path = file.Exists("sound/" .. own, "GAME") and own or def[3]
        if path then sounds[key] = {path, def[2]} end
    end
    return sounds
end
