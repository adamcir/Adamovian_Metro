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

function ASNP.Translate(value)
    if type(value) ~= "string" then return value end
    return ASNP.Language.Display[value] or value
end

function ASNP.GetStationName(id)
    return ASNP.Language.Stations[id] or tostring(id)
end
