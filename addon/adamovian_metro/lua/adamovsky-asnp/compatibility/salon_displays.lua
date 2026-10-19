-- Passenger saloon next-station display for Adamovsky ASNP.
-- Self-contained 3D2D boards; no train addon models/materials are edited.
local ASNP = AdamovskyASNP

local function CurrentStationInfo(train)
    local asnp = train.ASNP
    if not asnp or not isnumber(asnp.Station) or not isnumber(asnp.Line) then return end
    local definitions = Metrostroi and Metrostroi.ASNPSetup
    local id = train:GetNW2Int("Announcer", 1)
    local setup = definitions and definitions[id]
    if not setup or setup.name ~= ASNP.AnnouncerName then return end
    local route = setup[asnp.Line]
    local station = route and route[asnp.Station]
    if not station then return end
    local nextIndex = asnp.Station + (asnp.Path and -1 or 1)
    if route.Loop then
        nextIndex = (nextIndex - 1) % #route + 1
    end
    local nextStation = route[nextIndex]
    local arrived = asnp.Arrived ~= false
    -- ASNP: after the departure call the state becomes not-arrived and
    -- the station pointer moves as controlled by the original train system.
    local shown = arrived and station or (nextStation or station)
    return shown and shown[1], arrived
end

if SERVER then
    timer.Create("AdamovskyASNP_SalonSync", 0.5, 0, function()
        if not Metrostroi or not Metrostroi.ASNPSetup then return end
        for _, train in ipairs(ents.FindByClass("gmod_subway_*")) do
            if not IsValid(train) or not train.ASNP or not istable(train.WagonList) then continue end
            local station, arrived = CurrentStationInfo(train)
            local active = station ~= nil
            local name = active and ASNP.GetStationName(station) or ""
            for _, wagon in ipairs(train.WagonList) do
                if not IsValid(wagon) then continue end
                if wagon:GetNW2String("AdamovskySalonStation", "") ~= name then
                    wagon:SetNW2String("AdamovskySalonStation", name)
                end
                if wagon:GetNW2Bool("AdamovskySalonActive", false) ~= active then
                    wagon:SetNW2Bool("AdamovskySalonActive", active)
                end
                if wagon:GetNW2Bool("AdamovskySalonArrived", false) ~= arrived then
                    wagon:SetNW2Bool("AdamovskySalonArrived", arrived or false)
                end
            end
        end
    end)
    return
end

-- Client-side boards above saloon doorways. Tune positions to each model.
-- Units are Source units in the car's local coordinate system.
local layouts = {
    ["81%-717"] = {x = {-240, -80, 80, 240}, y = 49, z = 68},
    ["81%-718"] = {x = {-240, -80, 80, 240}, y = 49, z = 68},
    ["81%-720"] = {x = {-190, 0, 190}, y = 49, z = 68},
    ["81%-722"] = {x = {-190, 0, 190}, y = 49, z = 68},
    ["81%-760"] = {x = {-190, 0, 190}, y = 49, z = 68}, -- Oka
    ["81%-765"] = {x = {-190, 0, 190}, y = 49, z = 68}
}
local enabled = CreateClientConVar("adamovsky_asnp_salon", "1", true, false,
    "Show Adamovsky ASNP passenger displays in supported trains")
local opacity = CreateClientConVar("adamovsky_asnp_salon_brightness", "200", true, false,
    "Passenger display text brightness (50-255)", 50, 255)

surface.CreateFont("AdamovskyASNP_Salon", {
    font = "Trebuchet24", size = 30, weight = 650, extended = true
})
surface.CreateFont("AdamovskyASNP_SalonSmall", {
    font = "Trebuchet24", size = 18, weight = 500, extended = true
})

local function Layout(class)
    for pattern, data in pairs(layouts) do
        if string.find(class, pattern) then return data end
    end
end

local function DrawBoard(train, pos, ang, name, arrived)
    cam.Start3D2D(train:LocalToWorld(pos), train:LocalToWorldAngles(ang), 0.095)
        draw.RoundedBox(3, -152, -30, 304, 60, Color(16, 20, 18, 245))
        surface.SetDrawColor(50, 80, 52, 255)
        surface.DrawOutlinedRect(-149, -27, 298, 54, 1)
        local label = arrived and "STANICA TERAZ" or "STANICA NASLEDNA"
        draw.SimpleText(label, "AdamovskyASNP_SalonSmall", 0, -20,
            Color(135, opacity:GetInt(), 120), TEXT_ALIGN_CENTER)
        draw.SimpleText(name, "AdamovskyASNP_Salon", 0, -4,
            Color(155, opacity:GetInt(), 100), TEXT_ALIGN_CENTER)
    cam.End3D2D()
end

hook.Add("PostDrawTranslucentRenderables", "AdamovskyASNP_SalonDisplays", function(depth, skybox)
    if depth or skybox or not enabled:GetBool() then return end
    local player = LocalPlayer()
    if not IsValid(player) then return end
    local playerPos = player:EyePos()
    for _, train in ipairs(ents.FindByClass("gmod_subway_*")) do
        if not IsValid(train) or not train:GetNW2Bool("AdamovskySalonActive", false) then continue end
        if train:GetPos():DistToSqr(playerPos) > 850 * 850 then continue end
        local layout = Layout(train:GetClass())
        if not layout then continue end
        local name = train:GetNW2String("AdamovskySalonStation", "")
        if name == "" then continue end
        local arrived = train:GetNW2Bool("AdamovskySalonArrived", false)
        for _, x in ipairs(layout.x) do
            -- One display per side above each doorway, facing into saloon.
            DrawBoard(train, Vector(x, layout.y, layout.z), Angle(0, 90, 90), name, arrived)
            DrawBoard(train, Vector(x, -layout.y, layout.z), Angle(0, -90, 90), name, arrived)
        end
    end
end)
