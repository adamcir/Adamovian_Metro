local ASNP = AdamovskyASNP

-- Editable station names. These are placeholders pending the approved
-- Adamovian dictionary; do not mistake transliterations for translations.
ASNP.Language = ASNP.Language or {}
ASNP.Language.Stations = {
    [651] = "Pervoaprelskaya",
    [652] = "Park",
    [653] = "Metrostroiteley",
    [654] = "Morskaya",
    [655] = "Slavnaya Strana",
    [656] = "Pionerskaya"
}

-- Exact display strings as emitted by Metrostroi 81_71_ASNP.
-- Replace values with confirmed Adamovian equivalents. The keys must
-- remain unchanged. Keeping a fallback avoids broken menus.
ASNP.Language.Display = {
    ["Map not supported"] = "Mapa nepodporovana",
    ["Карта не поддерживается"] = "Mapa nepodporovana",
    ["Нажмите \"MENU\""] = "Stiskni MENU",
    ["для начала настройки"] = "Pro nastaveni",
    ["Client error"] = "Chyba klienta",
    ["No announcer at client"] = "Informator nenalezen",
    ["No line at client"] = "Linka nenalezena",
    ["Выбор N маршрута"] = "Vyber cislo trasy",
    ["Выбор линии (кол)"] = "Vyber okruzni linky",
    ["Выбор линии   -"] = "Vyber linky",
    ["Нет названия"] = "Bez nazvu",
    ["Выбор пути"] = "Vyber koleje",
    ["Текущая станция   -"] = "Aktualni stanice",
    ["Выбор ст. оборота -"] = "Vyber konecne",
    ["Кольцевой"] = "Okruzni",
    ["Выбор приб / отпр"] = "Prijezd / odjezd",
    ["Отпр."] = "Odj.",
    ["Приб."] = "Prij.",
    ["ПЕРЕД ОТПРАВЛЕНИЕМ"] = "PRED ODJEZDEM",
    ["НАЖМИ КНОПКУ   ОБЪЯВИТЬ"] = "STISKNI HLASENI",
    ["<<<  ИДЕТ ОБЪЯВЛЕНИЕ >>>"] = "<<< PROBIHA HLASENI >>>",
    ["Бл.Л"] = "Bl.L",
    ["Бл.П"] = "Bl.P"
}

-- ASNP variants also use these labels (some are not identical to stock strings).
-- Keep each row within the 24-character display.
local extra = {
    ["Номер маршрута:"] = "Cislo trasy:",
    ["Номер маршрута"] = "Cislo trasy",
    ["Маршрут"] = "Trasa",
    ["Нажмите \"MENU\""] = "Stiskni MENU",
    ["нажмите \"MENU\""] = "Stiskni MENU",
    ["нажмите \"+\" или \"-\""] = "Stiskni + nebo -",
    ["нажмите + или -"] = "Stiskni + nebo -",
    ["Нажмите + или -"] = "Stiskni + nebo -",
    ["Путь"] = "Kolej",
    ["Путь:"] = "Kolej:",
    ["Конечная станция"] = "Konecna stanice",
    ["Проверьте данные"] = "Zkontroluj udaje",
    ["Кольцевой"] = "Okruh",
    ["Нажмите"] = "Stiskni",
    ["нажмите"] = "stiskni",
    ["для начала настройки"] = "Pro nastaveni",
    ["Выбор"] = "Vyber",
    ["станция"] = "stanice",
    ["Станция"] = "Stanice",
    ["маршрута"] = "trasy",
    ["маршрут"] = "trasa",
    ["начала"] = "zacatku",
    ["настройки"] = "nastaveni",
    ["пути"] = "koleje",
    ["Меню"] = "Menu",
    ["МЕНЮ"] = "MENU",
    ["Объявить"] = "Hlaseni",
    ["ОБЪЯВИТЬ"] = "HLASENI"
}
for original, replacement in pairs(extra) do
    ASNP.Language.Display[original] = replacement
end

function ASNP.Translate(value)
    if type(value) ~= "string" then return value end
    local exact = ASNP.Language.Display[value]
    if exact then return exact end
    -- Other Metrostroi builds combine labels dynamically.
    -- Replace known fragments without modifying other train announcers.
    local result = value
    for from, to in pairs(ASNP.Language.Display) do
        if string.find(result, from, 1, true) then
            result = string.gsub(result, string.PatternSafe(from), function() return to end)
        end
    end
    -- Do not leave untranslated Cyrillic on the Adamovsky display.
    -- GMod supports utf8.codes, but not utf8.sub on every build.
    local upper = {"А","Б","В","Г","Д","Е","Ё","Ж","З","И","Й","К","Л","М","Н","О","П","Р","С","Т","У","Ф","Х","Ц","Ч","Ш","Щ","Ъ","Ы","Ь","Э","Ю","Я"}
    local lower = {"а","б","в","г","д","е","ё","ж","з","и","й","к","л","м","н","о","п","р","с","т","у","ф","х","ц","ч","ш","щ","ъ","ы","ь","э","ю","я"}
    local trans = {"A","B","V","G","D","E","Jo","Zh","Z","I","J","K","L","M","N","O","P","R","S","T","U","F","H","C","Ch","Sh","Shch","","Y","","E","Ju","Ja"}
    for i = 1, #upper do
        result = string.Replace(result, upper[i], trans[i])
        result = string.Replace(result, lower[i], string.lower(trans[i]))
    end
    return result
end

function ASNP.GetStationName(id)
    return ASNP.Language.Stations[id] or tostring(id)
end
