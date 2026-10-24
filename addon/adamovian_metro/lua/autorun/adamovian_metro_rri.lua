-- Adamovian Metro RRI (legacy cassette announcer).
-- Reuses the exact station lists and WAVs registered by the MEX ASNP packs.
-- Metrostroi calls this system "RRI" (not ASNP).
if SERVER then AddCSLuaFile() end

AdamovianMetroRRI = AdamovianMetroRRI or {}
local RRI = AdamovianMetroRRI
RRI.Missing = RRI.Missing or {}

local PACK_IDS = {"adamovian_loopline", "adamovian_suburb_construct"}
local REGISTER_TIMER = "AdamovianMetro_RRI_Register"

local function FindPack()
    if not MEXASNP or not istable(MEXASNP.Packs) then return end
    local map = game.GetMap():lower()

    for _, id in ipairs(PACK_IDS) do
        local pack = MEXASNP.Packs[id]
        if istable(pack) then
            for _, prefix in ipairs(pack.maps or {}) do
                if string.StartWith(map, prefix:lower()) then
                    return id, pack
                end
            end
        end
    end
end

local function BuildSounds(pack)
    -- These are the cassette mechanism keys that Metrostroi's RRI always queues.
    -- Silent durations avoid dependencies on the stock Russian RRI sound pack.
    local sounds = {click_start = 0.01, click_end = 0.01}
    for key, info in pairs(pack.sounds or {}) do
        if istable(info) and isstring(info[1]) then
            local path = pack.soundRoot .. "/" .. info[1]
            if file.Exists("sound/" .. path, "GAME") then
                local duration = info[2] or 2
                if isfunction(MEXASNP.AudioDuration) then
                    duration = MEXASNP.AudioDuration(path, duration) or duration
                end
                sounds[key] = {path, math.max(0.1, duration) + 0.25}
            else
                -- Missing sounds must not enter RRI's playback queue as strings.
                sounds[key] = 0.01
                if not RRI.Missing[path] then
                    RRI.Missing[path] = true
                    print("[Adamovian RRI] Missing WAV: " .. path .. " (muted)")
                end
            end
        end
    end
    return sounds
end

local function Sequence(pack, keys, stationKey, isLast)
    local seq = {}
    local available = pack.sounds or {}
    if available.gong_1 then seq[#seq + 1] = "gong_1" end
    for _, key in ipairs(keys) do
        if available[key] then seq[#seq + 1] = key end
    end
    if stationKey and available[stationKey] then
        seq[#seq + 1] = stationKey
    end
    if isLast and available.last then seq[#seq + 1] = "last" end
    return seq
end

local function BuildRoute(id, pack)
    local stations = pack.stations
    if not istable(stations) or #stations < 2 then return end

    local line = {
        Name = "Adamovian - " .. (pack.lineName or pack.name or "Metro"),
        NameEn = "Adamovian - " .. (pack.lineName or pack.name or "Metro"),
        Loop = pack.loop == true,
        LED = pack.led or {5, 10, 5, 5, 5},
        AdamovianPackID = id,
    }

    for i, station in ipairs(stations) do
        local nextStation = stations[i % #stations + 1]
        local previousStation = stations[(i - 2) % #stations + 1]
        local current = "station_" .. tostring(station.id)

        local arrive = Sequence(pack, {"arr"}, current, false)
        local arriveLast = Sequence(pack, {"arr"}, current, true)
        local forward = Sequence(pack, {"doors_closing", "next"},
            "station_" .. tostring(nextStation.id), false)
        local backward = Sequence(pack, {"doors_closing", "next"},
            "station_" .. tostring(previousStation.id), false)

        -- RRI expects two direction-indexed arrays for each message.
        -- It advances on the physical Program I button, not the ASNP buttons.
        line[i] = {
            station.id, station.name, station.name,
            arr = {arrive, table.Copy(arrive)},
            dep = {forward, backward},
            arrlast = {arriveLast, table.Copy(arriveLast)}
        }
    end
    return {line}
end

function RRI.TryRegister()
    if not Metrostroi or not isfunction(Metrostroi.SetRRIAnnouncer) then return end
    local id, pack = FindPack()
    if not id then return end

    local existing = Metrostroi.RRISetup
    if istable(existing) and istable(existing[1])
        and existing[1].AdamovianPackID == id then
        RRI.ActivePack = id
        return
    end

    local routes = BuildRoute(id, pack)
    if not routes then return end

    Metrostroi.SetRRIAnnouncer(BuildSounds(pack), routes)
    RRI.ActivePack = id
    print("[Adamovian RRI] Loaded " .. routes[1].Name
        .. " (" .. tostring(#routes[1]) .. " stations) on " .. game.GetMap())
end

-- MEX discovers content packs after autorun. Checking also handles maps whose
-- stock Metrostroi RRI config is loaded later, without stacking registrations.
timer.Create(REGISTER_TIMER, 1, 0, RRI.TryRegister)
hook.Add("InitPostEntity", "AdamovianMetro_RRI_Init", function()
    timer.Simple(0, RRI.TryRegister)
end)

concommand.Add("adamovsky_rri_status", function()
    local id, pack = FindPack()
    local route = Metrostroi and Metrostroi.RRISetup and Metrostroi.RRISetup[1]
    local active = id and istable(route) and route.AdamovianPackID == id
    print("[Adamovian RRI] map=" .. game.GetMap()
        .. " | pack=" .. tostring(id or "none")
        .. " | active=" .. tostring(active or false))
    if active then
        print("[Adamovian RRI] line=" .. tostring(route.Name)
            .. " | stations=" .. tostring(#route)
            .. " | WAVs=" .. tostring(table.Count(pack.sounds or {})))
    elseif not MEXASNP then
        print("[Adamovian RRI] MEX ASNP loader is missing.")
    end
    for path in pairs(RRI.Missing) do
        print("[Adamovian RRI] missing: " .. path)
    end
end)
