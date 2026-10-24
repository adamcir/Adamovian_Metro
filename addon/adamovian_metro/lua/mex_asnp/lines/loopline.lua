-- Adamovian Metro: content-only ASNP definition. MEX discovers this file.
MEXASNP.RegisterPack("adamovian_loopline", {
    name = "Adamovsky ASNP",
    language = "ad",
    maps = {"gm_mus_loopline_"},
    lineName = "Loop Line",
    loop = true,
    soundRoot = "adamovsky_asnp",
    sounds = {
        gong_1 = {"common/gong_1.wav", 2.5},
        arr = {"common/arr.wav", 3.0},
        next = {"common/next.wav", 4.0},
        doors_closing = {"common/doors_closing.wav", 3.8},
        last = {"common/last.wav", 4.5},
        announcer_ready = {"common/announcer_ready.wav", 3.3},
        station_651 = {"mus/loopline/651.wav", 3},
        station_652 = {"mus/loopline/652.wav", 3},
        station_653 = {"mus/loopline/653.wav", 3},
        station_654 = {"mus/loopline/654.wav", 3},
        station_655 = {"mus/loopline/655.wav", 3},
        station_656 = {"mus/loopline/656.wav", 3}
    },
    stations = {
        {id=651, name="Pervoaprelskaya"},
        {id=652, name="Park"},
        {id=653, name="Metrostroiteley"},
        {id=654, name="Morskaya"},
        {id=655, name="Slavnaya Strana"},
        {id=656, name="Pionerskaya"}
    }
})
