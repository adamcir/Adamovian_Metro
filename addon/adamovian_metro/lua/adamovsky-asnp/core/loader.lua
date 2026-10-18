local ASNP = AdamovskyASNP

ASNP.Ready = false

function ASNP.IsMetrostroiReady()
    return Metrostroi ~= nil
        and isfunction(Metrostroi.AddANSPAnnouncer)
        and istable(Metrostroi.ASNPSetup)
end

function ASNP.Initialize()
    if ASNP.Ready then return true end
    if not ASNP.IsMetrostroiReady() then
        return false
    end

    if not ASNP.Register then
        return false
    end

    local success = ASNP.Register()

    if success then
        ASNP.Ready = true

        print("[Adamovsky ASNP] Initialized")
    end

    return success
end

hook.Add("InitPostEntity", "AdamovskyASNP_Init", function()
    local attempts = 0

    timer.Create("AdamovskyASNP_Load", 1, 30, function()
        attempts = attempts + 1

        if ASNP.Initialize() then
            timer.Remove("AdamovskyASNP_Load")
        elseif attempts >= 30 then
            ErrorNoHalt(
                "[Adamovsky ASNP] Initialization failed\n"
            )
        end
    end)
end)
