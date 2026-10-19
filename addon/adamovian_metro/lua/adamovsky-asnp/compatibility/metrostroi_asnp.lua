if SERVER then return end
local ASNP = AdamovskyASNP

function ASNP.IsSelected(train)
    if not IsValid(train) or not Metrostroi then return false end
    local setup = Metrostroi.ASNPSetup
    local id = train:GetNW2Int("Announcer", 1)
    return istable(setup) and istable(setup[id])
        and setup[id].name == ASNP.AnnouncerName
end

local function LocalizePrinter(system)
    if not system or not isfunction(system.PrintText) or system.AdamovskyLocalized then return false end
    local original = system.PrintText
    system.PrintText = function(self, x, y, value, inverse)
        if self.Train and ASNP.IsSelected(self.Train) then
            value = ASNP.Translate(value)
        end
        return original(self, x, y, value, inverse)
    end
    system.AdamovskyLocalized = true
    return true
end

function ASNP.InstallLocalization()
    if not Metrostroi then return false end
    -- Some variants copy system methods on train initialization rather than
    -- referencing Metrostroi.BaseSystems dynamically.
    local installed = false
    if Metrostroi.BaseSystems then
        installed = LocalizePrinter(Metrostroi.BaseSystems["81_71_ASNP"]) or installed
    end
    for _, train in ipairs(ents.FindByClass("gmod_subway_*")) do
        if train.ASNP then installed = LocalizePrinter(train.ASNP) or installed end
    end
    return installed
end

timer.Create("AdamovskyASNP_Localization", 1, 0, function()
    ASNP.InstallLocalization()
end)
