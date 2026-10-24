local ASNP = AdamovskyASNP

-- Station proper names are preserved until official Adamovian names are
-- approved. They are not treated as Russian words to transliterate.
ASNP.Language = ASNP.Language or {}
ASNP.Language.Stations = {
    [651] = "Pervoaprelskaya",
    [652] = "Park",
    [653] = "Metrostroiteley",
    [654] = "Morskaya",
    [655] = "Slavnaya Strana",
    [656] = "Pionerskaya"
}

-- Adamovsky is its own language. These display terms follow the vocabulary
-- in Adamovsky jazik 1.7 and the proposed ASNP glossary, not Russian phonetics.
-- Keys must match Metrostroi's native display strings exactly.
ASNP.Language.Display = {
    ["Map not supported"] = "Mapa neznama",
    ["Карта не поддерживается"] = "Mapa neznama",
    ["Нажмите \"MENU\""] = "Natisni MENU",
    ["для начала настройки"] = "Pusk nastavenja",
    ["Client error"] = "Problem klienta",
    ["No announcer at client"] = "Informator ne jest",
    ["No line at client"] = "Linija ne jest",
    ["Выбор N маршрута"] = "Vybor cisla trasy",
    ["Выбор линии (кол)"] = "Vybor liniji okruzne",
    ["Выбор линии   -"] = "Vybor liniji",
    ["Нет названия"] = "Bez nazva",
    ["Выбор пути"] = "Vybor koleji",
    ["Текущая станция   -"] = "Stanica teraz",
    ["Выбор ст. оборота -"] = "Vybor konceca",
    ["Кольцевой"] = "Okruzny",
    ["Выбор приб / отпр"] = "Prijazd / odjazd",
    ["Отпр."] = "Odjazd",
    ["Приб."] = "Prijazd",
    ["ПЕРЕД ОТПРАВЛЕНИЕМ"] = "PRED OD JAZDOM",
    ["НАЖМИ КНОПКУ   ОБЪЯВИТЬ"] = "NATISNI OBVESTENJE",
    ["<<<  ИДЕТ ОБЪЯВЛЕНИЕ >>>"] = "<<< OBVESTENJE >>>",
    ["Бл.Л"] = "Bl. L",
    ["Бл.П"] = "Bl. P",
    -- Additional labels in patched train ASNP variants.
    ["Номер маршрута:"] = "Cislo trasy:",
    ["Номер маршрута"] = "Cislo trasy",
    ["Маршрут"] = "Trasa",
    ["нажмите \"MENU\""] = "Natisni MENU",
    ["нажмите \"+\" или \"-\""] = "Vybor + ili -",
    ["нажмите + или -"] = "Vybor + ili -",
    ["Нажмите + или -"] = "Vybor + ili -",
    ["Путь"] = "Koleja",
    ["Путь:"] = "Koleja:",
    ["Конечная станция"] = "Stanica konecna",
    ["Проверьте данные"] = "Kontrola danych",
    ["От:"] = "Od:",
    ["До:"] = "Do:",
    ["\"+-\" выбор   \"MENU\" ввод"] = "+/- Vybor MENU potvrdi"
}

function ASNP.Translate(value)
    if not isstring(value) then return value end
    local direct = ASNP.Language.Display[value]
    if direct then return direct end
    -- Do not fabricate a 'translation' by transliterating Russian letters.
    -- Replace only known phrases, longest first, preserving numbers and names.
    local text = value
    local matches = {}
    for from, to in pairs(ASNP.Language.Display) do
        matches[#matches + 1] = {from, to}
    end
    table.sort(matches, function(a,b) return #a[1] > #b[1] end)
    for _, pair in ipairs(matches) do
        text = string.Replace(text, pair[1], pair[2])
    end
    -- Never show an unhandled Russian phrase in the Adamovsky interface.
    -- Report the missing translation in console for later dictionary review.
    if string.find(text, "[\208-\211][\128-\191]") then
        if not ASNP.UnknownDisplayText then ASNP.UnknownDisplayText = {} end
        if not ASNP.UnknownDisplayText[value] then
            ASNP.UnknownDisplayText[value] = true
            print("[Adamovsky ASNP] Missing Adamovsky translation: " .. value)
        end
        return "Slovo neznamo"
    end
    return text
end

function ASNP.GetStationName(id)
    return ASNP.Language.Stations[id] or tostring(id)
end
