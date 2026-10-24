-- Adamovian RPI announcements. MEX owns discovery, registration and playback.
-- Each cassette shares stations and WAV keys with its ASNP pack.
-- Metrostroi calls this legacy cassette system "RRI".
MEXRPI.RegisterPack("adamovian_loopline_rpi", {
    name = "Adamovsky RPI",
    sourceASNP = "adamovian_loopline"
})

MEXRPI.RegisterPack("adamovian_suburb_construct_rpi", {
    name = "Adamovsky RPI",
    sourceASNP = "adamovian_suburb_construct",
    -- Keep the whole circuit, including Depo 101, as regular stops.
    loop = true,
    continuousLoop = true
})
