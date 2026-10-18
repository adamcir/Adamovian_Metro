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

-- Some third-party train spawners use a fixed announcer list instead of
-- reading Metrostroi.AnnouncementsASNP. Extend the list without replacing
-- the train's spawner or touching its original options.
function ASNP.PatchTrainSpawners()
    if not CLIENT or not ASNP.RegisteredID then return 0, 0 end
    local patched, supported = 0, 0
    for class, stored in pairs(scripted_ents.GetList() or {}) do
        if not string.StartWith(class, "gmod_subway_") then continue end
        local train = stored.t
        if not train or not istable(train.Spawner) then continue end
        for _, setting in ipairs(train.Spawner) do
            if setting[1] ~= "Announcer" or setting[3] ~= "List" then continue end
            supported = supported + 1
            -- Remember the original provider once per setting table. Some trains
            -- rebuild their scripted entity definitions during addon reloads.
            local original = setting.AdamovskyASNPOriginal
            if original == nil then
                original = setting[4]
                if not istable(original) and not isfunction(original) then break end
                setting.AdamovskyASNPOriginal = original
                setting[4] = function(...)
                    local result = isfunction(original) and original(...) or original
                    if not istable(result) then result = {} end
                    -- Never mutate shared fixed lists that belong to another addon.
                    local options = table.Copy(result)
                    local id = ASNP.RegisteredID
                    if id then options[id] = ASNP.AnnouncerName end
                    return options
                end
                patched = patched + 1
            end
        end
    end
    return patched, supported
end

if CLIENT then
    timer.Create("AdamovskyASNP_SpawnerCompatibility", 2, 0, function()
        ASNP.PatchTrainSpawners()
    end)
end

-- Local client diagnostics, without sv_cheats or lua_run_cl.
if CLIENT then
    concommand.Add("adamovsky_asnp_status", function()
        ASNP.Initialize()
        ASNP.PatchTrainSpawners()
        print("[Adamovsky ASNP] Version: " .. tostring(ASNP.Version))
        print("[Adamovsky ASNP] Map: " .. tostring(game.GetMap()))
        local tbl = Metrostroi and Metrostroi.AnnouncementsASNP
        local found = ASNP.RegisteredID
        if not found or not tbl or not tbl[found] or tbl[found].name ~= ASNP.AnnouncerName then
            found = nil
            for id, data in pairs(tbl or {}) do
                if istable(data) and data.name == ASNP.AnnouncerName then found = id break end
            end
        end
        print("[Adamovsky ASNP] Client announcer ID: " .. tostring(found))
        local total, ok = 0, 0
        for class, stored in pairs(scripted_ents.GetList() or {}) do
            if not string.StartWith(class, "gmod_subway_") then continue end
            local train = stored.t
            if not train or not istable(train.Spawner) then continue end
            for _, setting in ipairs(train.Spawner) do
                if setting[1] ~= "Announcer" or setting[3] ~= "List" then continue end
                total = total + 1
                local choices = isfunction(setting[4]) and setting[4]() or setting[4]
                local present = istable(choices) and found and choices[found] == ASNP.AnnouncerName or false
                if present then ok = ok + 1 end
                print("[Adamovsky ASNP] " .. class .. " spawnmenu includes announcer: " .. tostring(present))
            end
        end
        print("[Adamovsky ASNP] Compatible spawner menus: " .. ok .. "/" .. total)
    end)
end
