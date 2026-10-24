-- Suburb Construct ASNP line. MEX owns registration and playback.
MEXASNP.RegisterPack("adamovian_suburb_construct", {
    name = "Adamovsky ASNP",
    language = "ad",
    maps = {"gm_suburb_construct"},
    lineName = "Suburb line A",
    loop = true,
    soundRoot = "adamovsky_asnp",
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
        {id=101, name="Depo"},
        {id=102, name="Centrum"},
        {id=103, name="Prumyslova"},
        {id=104, name="Luka"}
    }
})
