local ASNP = AdamovskyASNP

ASNP.SoundDefinitions = {
    click1 = {
        "common/click1.wav", 0.3
    },

    click2 = {
        "common/click2.wav", 0.3
    },

    click3 = {
        "common/click3.wav", 0.3
    },

    doors_closing = {
        "common/doors_closing.wav", 2.5
    },

    announcer_ready = {
        "common/announcer_ready.wav", 2.0
    },

    next_651 = {
        "loopline/next_651.wav", 3.0
    },

    next_652 = {
        "loopline/next_652.wav", 3.0
    },

    next_653 = {
        "loopline/next_653.wav", 3.0
    },

    next_654 = {
        "loopline/next_654.wav", 3.0
    },

    next_655 = {
        "loopline/next_655.wav", 3.0
    },

    next_656 = {
        "loopline/next_656.wav", 3.0
    }
}

function ASNP.BuildSounds()
    local result = {
        asnp = true
    }

    for key, definition in pairs(ASNP.SoundDefinitions) do
        result[key] = {
            "adamovsky_asnp/" .. definition[1],
            definition[2]
        }
    end

    return result
end
