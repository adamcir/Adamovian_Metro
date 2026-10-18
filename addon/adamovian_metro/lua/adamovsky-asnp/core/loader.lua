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

-- Local client diagnostics, without sv_cheats or lua_run_cl.
if CLIENT then
    concommand.Add("adamovsky_asnp_status", function()
        print("[Adamovsky ASNP] Version: " .. tostring(ASNP.Version))
        print("[Adamovsky ASNP] Map: " .. tostring(game.GetMap()))
        local tbl = Metrostroi and Metrostroi.AnnouncementsASNP
        local found
        for id, data in pairs(tbl or {}) do
            if istable(data) and data.name == ASNP.AnnouncerName then
                found = id
                print("[Adamovsky ASNP] Client announcer ID: " .. tostring(id) ..
                    ", asnp flag: " .. tostring(data.asnp))
            end
        end
        if not found then
            print("[Adamovsky ASNP] ERROR: Missing from client announcer table")
        end
        for class, data in pairs(scripted_ents.GetList() or {}) do
            if not string.find(class, "gmod_subway_81%-717") then continue end
            local train = data.t
            if not train or not istable(train.Spawner) then continue end
            for _, setting in ipairs(train.Spawner) do
                if setting[1] ~= "Announcer" then continue end
                local choices = isfunction(setting[4]) and setting[4]() or setting[4]
                print("[Adamovsky ASNP] " .. class ..
                    " spawnmenu includes announcer: " ..
                    tostring(istable(choices) and found and choices[found] == ASNP.AnnouncerName))
            end
        end
    end)
end
