AdamovskyASNP = AdamovskyASNP or {}

AdamovskyASNP.Version = "0.1.0"

local ROOT = "adamovsky_asnp/"

local modules = {
    "core/loader.lua",
    "core/registry.lua",
    "core/sounds.lua",
    "languages/adamovsky.lua",
    "maps/loopline.lua",
    "compatibility/metrostroi_asnp.lua"
}

for _, module in ipairs(modules) do
    local path = ROOT .. module

    if SERVER then
        AddCSLuaFile(path)
    end

    include(path)
end

print("[Adamovsky ASNP] Loaded v" ..
    AdamovskyASNP.Version)
    