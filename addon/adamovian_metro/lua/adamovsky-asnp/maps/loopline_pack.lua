-- Loop Line content pack. All audio and route choices live in Adamovian Metro.
-- MEX itself contains no hardcoded Adamovian stations or recordings.
local ASNP = AdamovskyASNP
local function RegisterWithMEX()
    if not MEXASNP or not MEXASNP.RegisterPack then return false end
    MEXASNP.RegisterLanguage("ad", include("adamovsky-asnp/languages/ad.lua"))
    MEXASNP.RegisterPack("adamovian_loopline", {
        name = "Adamovsky ASNP",
        language = "ad",
        maps = {"gm_mus_loopline_"},
        soundRoot = "adamovsky_asnp",
        sounds = {
            gong_1 = {"common/gong_1.wav",2.5},
            arr = {"common/arr.wav",3},
            next = {"common/next.wav",4},
            last = {"common/last.wav",4.5},
            doors_closing = {"common/doors_closing.wav",3.8},
            announcer_ready = {"common/announcer_ready.wav",3.3},
            station_651 = {"mus/loopline/651.wav",3},
            station_652 = {"mus/loopline/652.wav",3},
            station_653 = {"mus/loopline/653.wav",3},
            station_654 = {"mus/loopline/654.wav",3},
            station_655 = {"mus/loopline/655.wav",3},
            station_656 = {"mus/loopline/656.wav",3}
        },
        routes = ASNP.BuildLoopline
    })
    return true
end

if not RegisterWithMEX() then
    timer.Create("AdamovskyASNP_WaitForMEX",1,0,function()
        if RegisterWithMEX() then
            timer.Remove("AdamovskyASNP_WaitForMEX")
        end
    end)
end
