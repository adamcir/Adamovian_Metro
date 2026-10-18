if SERVER then return end

local ASNP = AdamovskyASNP

function ASNP.IsSelected(train)
    if not IsValid(train) then return false end
    if not Metrostroi then return false end

    local id = train:GetNW2Int("Announcer", 1)
    local setup = Metrostroi.ASNPSetup

    return setup
        and setup[id]
        and setup[id].name == ASNP.AnnouncerName
end

function ASNP.InstallLocalization()
    if not Metrostroi then return false end
    if not Metrostroi.BaseSystems then return false end

    local system = Metrostroi.BaseSystems["81_71_ASNP"]

    if not system or not system.PrintText then
        return false
    end

    if system.AdamovskyLocalized then
        return true
    end

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
        hook.Remove(
            "Think",
            "AdamovskyASNP_Localization"
        )
    end
end)
