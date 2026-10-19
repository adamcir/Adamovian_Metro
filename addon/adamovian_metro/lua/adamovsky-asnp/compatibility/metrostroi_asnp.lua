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

-- Boost only our voice recordings at playback time. No WAVs are modified.
-- Original train audio, UI noises and other announcers remain untouched.
local function InstallVolume()
    local stored = scripted_ents.GetStored("gmod_subway_base")
    local base = stored and stored.t
    if not base or not isfunction(base.PlayOnceFromPos) or base.AdamovskyVolumeWrapped then return end
    local original = base.PlayOnceFromPos
    base.PlayOnceFromPos = function(self, soundID, soundPath, volume, ...)
        if isstring(soundPath) and string.StartWith(soundPath, "adamovsky_asnp/") then
            local multiplier = GetConVar("adamovsky_asnp_volume")
            local gain = multiplier and multiplier:GetFloat() or 2
            volume = math.Clamp((volume or 1) * gain, 0, 1)
        end
        return original(self, soundID, soundPath, volume, ...)
    end
    base.AdamovskyVolumeWrapped = true
end

CreateClientConVar("adamovsky_asnp_volume", "2", true, false,
    "Adamovsky ASNP playback volume multiplier (1-4)", 1, 4)
timer.Create("AdamovskyASNP_Volume", 1, 0, InstallVolume)
