local ASNP = AdamovskyASNP

ASNP.Language = {}

ASNP.Language.Stations = {
    [651] = "Pervoaprelskaya",
    [652] = "Park",
    [653] = "Metrostroiteley",
    [654] = "Morskaya",
    [655] = "Slavnaya Strana",
    [656] = "Pionerskaya"
}

ASNP.Language.Interface = {
    welcome = "Welcome",
    select_route = "Select Route",
    select_line = "Select Line",
    select_direction = "Select Direction",
    select_station = "Select Station",
    arrival = "Arrival",
    departure = "Departure",
    announcing = "Announcing",
    error = "Error"
}

function ASNP.Translate(key)
    return ASNP.Language.Interface[key] or key
end

function ASNP.GetStationName(id)
    return ASNP.Language.Stations[id]
        or tostring(id)
end
