-- Suburb Construct ASNP line. MEX owns registration and playback.
MEXASNP.RegisterPack("adamovian_suburb_construct", {
    name = "Adamovsky ASNP",
    language = "ad",
    maps = {"gm_suburb_construct"},
    lineName = "Suburb line A",
    -- Closed passenger loop: Depo -> Centrum -> Prumyslova -> Luka -> Depo.
    -- Depo (101) is a normal served station, NOT a special depot/terminal.
    loop = true,
    continuousLoop = true, -- every station is served; no terminal announcements
    soundRoot = "adamovsky_announcer",
    sounds = {
        gong_1 = {"common/gong_1.wav", 2.5},
        arr = {"common/arr.wav", 3.0},
        next = {"common/next.wav", 4.0},
        doors_closing = {"common/doors_closing.wav", 3.8},
        last = {"common/last.wav", 4.5},
        announcer_ready = {"common/announcer_ready.wav", 3.3},
        station_101 = {"suburb/101.wav", 3},
        station_102 = {"suburb/102.wav", 3},
        station_103 = {"suburb/103.wav", 3},
        station_104 = {"suburb/104.wav", 3}
    },
    stations = {
        {id=101, name="Depo"}, -- ordinary stop: announces arrival AND departure
        {id=102, name="Centrum"},
        {id=103, name="Prumyslova"},
        {id=104, name="Luka"}
    }
})
