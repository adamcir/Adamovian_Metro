local ASNP = AdamovskyASNP

function ASNP.IsLooplineMap()
    local map = string.lower(game.GetMap() or "")
    return string.find(map, "gm_mus_loop", 1, true) ~= nil
end

function ASNP.BuildLoopline()
    local names = ASNP.GetStationName
    local ids = {651,652,653,654,655,656}
    local line = {Name = "Loop Line", Loop = true, LED = {5,10,5,5,5}}

    for index, id in ipairs(ids) do
        local prev = ids[(index - 2) % #ids + 1]
        local nextID = ids[index % #ids + 1]
        line[index] = {
            id, names(id), names(id),
            arr = {
                {"gong_1", "arr", "station_" .. id},
                {"gong_1", "arr", "station_" .. id}
            },
            dep = {
                {"gong_1", "doors_closing", "next", "station_" .. nextID},
                {"gong_1", "doors_closing", "next", "station_" .. prev}
            },
            arrlast = {
                {"gong_1", "arr", "station_" .. id, "last"},
                {"gong_1", "arr", "station_" .. id, "last"}
            }
        }
    end
    return {line}
end
