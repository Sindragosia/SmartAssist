local addonName, ns = ...

ns.L = {}

local L = ns.L

if GetLocale() == "frFR" then
    L.NO_TANK = "Aucun tank trouvé dans le groupe ou raid."
else
    L.NO_TANK = "No tank found in the party or raid."
end
