-- Adamovian Metro ASNP entry point. Does not modify other train addons.
AdamovskyASNP = AdamovskyASNP or {}
AdamovskyASNP.Version = "0.1.9"

local ROOT = "adamovsky-asnp/"
local modules = {
    "languages/adamovsky.lua",
    "core/sounds.lua",
    "maps/loopline.lua",
    "core/registry.lua",
    "core/loader.lua",
    "compatibility/metrostroi_asnp.lua"
}
for _, module in ipairs(modules) do
    local path = ROOT .. module
    if SERVER then AddCSLuaFile(path) end
    include(path)
end
print("[Adamovsky ASNP] Loaded v" .. AdamovskyASNP.Version)
