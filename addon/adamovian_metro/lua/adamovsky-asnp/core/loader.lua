local ASNP = AdamovskyASNP

function ASNP.IsMetrostroiReady()
    return Metrostroi ~= nil
        and isfunction(Metrostroi.AddANSPAnnouncer)
        and istable(Metrostroi.ASNPSetup)
end

function ASNP.Initialize()
    if not ASNP.IsMetrostroiReady() or not ASNP.Register then return false end
    return ASNP.Register()
end

-- Metrostroi announcer tables must exist on both client and server.
hook.Add("InitPostEntity", "AdamovskyASNP_Init", function()
    local attempts = 0
    timer.Create("AdamovskyASNP_Load", 1, 60, function()
        attempts = attempts + 1
        if ASNP.Initialize() then
            timer.Remove("AdamovskyASNP_Load")
            print("[Adamovsky ASNP] Registered Loop Line")
        elseif attempts == 60 then
            ErrorNoHalt("[Adamovsky ASNP] Metrostroi/Loop Line unavailable\n")
        end
    end)
end)
