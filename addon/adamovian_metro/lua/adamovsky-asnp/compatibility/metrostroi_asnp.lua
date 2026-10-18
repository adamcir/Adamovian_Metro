if SERVER then return end
local ASNP = AdamovskyASNP

function ASNP.IsSelected(train)
    if not IsValid(train) or not Metrostroi then return false end
    local setup = Metrostroi.ASNPSetup
    local id = train:GetNW2Int("Announcer", 1)
    return istable(setup) and istable(setup[id])
        and setup[id].name == ASNP.AnnouncerName
end

function ASNP.InstallLocalization()
    if not Metrostroi or not Metrostroi.BaseSystems then return false end
    local system = Metrostroi.BaseSystems["81_71_ASNP"]
    if not system or not isfunction(system.PrintText) then return false end
    if system.AdamovskyLocalized then return true end
    local original = system.PrintText
    system.PrintText = function(self, x, y, value, inverse)
        if ASNP.IsSelected(self.Train) then
            value = ASNP.Translate(value)
        end
        return original(self, x, y, value, inverse)
    end
    system.AdamovskyLocalized = true
    return true
end

hook.Add("Think", "AdamovskyASNP_Localization", function()
    if ASNP.InstallLocalization() then
        hook.Remove("Think", "AdamovskyASNP_Localization")
    end
end)
