local ASNP = AdamovskyASNP
ASNP.AnnouncerName = "Adamovsky ASNP"

function ASNP.Register()
    if not ASNP.IsMetrostroiReady() then return false end
    if not ASNP.IsLooplineMap() then return false end
    local sounds = ASNP.BuildSounds()
    local routes = ASNP.BuildLoopline()
    if not sounds or not routes then return false end
    Metrostroi.AddANSPAnnouncer(ASNP.AnnouncerName, sounds, routes)
    return true
end
