local ASNP = AdamovskyASNP

function ASNP.IsMetrostroiReady()
    return Metrostroi ~= nil
        and isfunction(Metrostroi.AddANSPAnnouncer)
        and istable(Metrostroi.ASNPSetup)
        and istable(Metrostroi.AnnouncementsASNP)
end

function ASNP.Initialize()
    if not ASNP.IsMetrostroiReady() or not ASNP.Register then return false end
    if not ASNP.IsLooplineMap() then return false end

    -- Registration is independent on client and server; only skip when
    -- the currently active Metrostroi tables already contain our entry.
    local entries = Metrostroi.AnnouncementsASNP
    local setups = Metrostroi.ASNPSetup
    for id, entry in ipairs(entries) do
        if entry.name == ASNP.AnnouncerName and istable(setups[id]) then
            ASNP.RegisteredID = id
            return true
        end
    end

    if ASNP.Register() then
        for id, entry in ipairs(entries) do
            if entry.name == ASNP.AnnouncerName then
                ASNP.RegisteredID = id
                print("[Adamovsky ASNP] Registered announcer #" .. id ..
                    (CLIENT and " (client)" or " (server)"))
                return true
            end
        end
    end
    return false
end

-- Try as soon as possible. InitPostEntity alone is too late for some
-- train spawners and never fires again after lua_openscript_cl reloads.
ASNP.Initialize()
timer.Simple(0, function()
    if not ASNP or not ASNP.Initialize then return end
    ASNP.Initialize()
end)

-- Retry only while Metrostroi has not finished defining its tables.
-- Keep a lightweight check to survive table resets / addon reloads.
timer.Create("AdamovskyASNP_EnsureRegistration", 1, 0, function()
    if not ASNP or not ASNP.Initialize then
        timer.Remove("AdamovskyASNP_EnsureRegistration")
        return
    end
    ASNP.Initialize()
end)
