local ASNP = AdamovskyASNP

-- Common phrases are shared across all maps. Map folders contain ONLY
-- station-name recordings (e.g. mus/loopline/651.wav).
-- Fallback durations; real WAV lengths are calculated from RIFF headers at registration.
ASNP.SoundDefinitions = {
    click1 = {"common/click1.wav", 0.5, "subway_announcers/asnp/boiko_new/click1.mp3"},
    click2 = {"common/click2.wav", 0.3, "subway_announcers/asnp/boiko_new/click2.mp3"},
    click3 = {"common/click3.wav", 0.3, "subway_announcers/asnp/boiko_new/click3.mp3"},
    announcer_ready = {"common/announcer_ready.wav", 3.295479},
    doors_closing = {"common/doors_closing.wav", 3.782542},
    last = {"common/last.wav", 4.425625},
    arr = {"common/arr.wav", 3.0},
    gong_1 = {"common/gong_1.wav", 2.5},
    next = {"common/next.wav", 4.0}
}

for id = 651, 656 do
    ASNP.SoundDefinitions["station_" .. id] = {
        "mus/loopline/" .. id .. ".wav", 3.0
    }
end

-- Metrostroi schedules the next phrase using sounds[key][2]. The old
-- hardcoded 1.5 seconds cut off "next.wav" before it finished playing.
-- Read the actual WAV duration on each realm to avoid future timing bugs.
local function ReadUInt32(data, offset)
    local a, b, c, d = string.byte(data, offset, offset + 3)
    if not d then return nil end
    return a + b * 256 + c * 65536 + d * 16777216
end

local function GetWavDuration(path)
    local bytes = file.Read("sound/" .. path, "GAME")
    if not bytes or #bytes < 44 then return nil end
    if string.sub(bytes, 1, 4) ~= "RIFF" or string.sub(bytes, 9, 12) ~= "WAVE" then
        return nil
    end

    local position, byteRate, dataSize = 13, nil, nil
    while position + 7 <= #bytes do
        local kind = string.sub(bytes, position, position + 3)
        local size = ReadUInt32(bytes, position + 4)
        if not size then break end
        local payload = position + 8
        if kind == "fmt " and size >= 16 and payload + 11 <= #bytes then
            byteRate = ReadUInt32(bytes, payload + 8)
        elseif kind == "data" then
            dataSize = size
        end
        if byteRate and dataSize then break end
        -- RIFF chunks are padded to even sizes.
        position = payload + size + (size % 2)
    end
    if byteRate and byteRate > 0 and dataSize and dataSize > 0 then
        return dataSize / byteRate
    end
    return nil
end

function ASNP.BuildSounds()
    -- Keep the announcer available to both ASNP and legacy announcer spawners.
    -- Several 81-717/81-718 variants explicitly hide entries with asnp=true.
    local sounds = {}
    for key, def in pairs(ASNP.SoundDefinitions) do
        local own = "adamovsky_asnp/" .. def[1]
        local path = file.Exists("sound/" .. own, "GAME") and own or def[3]
        if path then
            local duration = GetWavDuration(path) or def[2]
            -- A small pause prevents the next file from starting on the last syllable.
            sounds[key] = {path, duration + 0.25}
        else
            print("[Adamovsky ASNP] Missing audio: " .. own)
        end
    end
    return sounds
end
