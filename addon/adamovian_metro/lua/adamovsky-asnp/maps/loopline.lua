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
                {"arr_" .. id},
                {"arr_" .. id}
            },
            dep = {
                {"doors_closing", "next_" .. nextID},
                {"doors_closing", "next_" .. prev}
            },
            arrlast = {
                {"arr_" .. id, "last"},
                {"arr_" .. id, "last"}
            }
        }
    end
    return {line}
end
