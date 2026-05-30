local L = {}

if GetLocale() == "frFR" then
    L.MACRO_UPDATED = "Macro '%s' mise à jour pour lancer %s sur : %s"
    L.NO_TANK = "Aucun tank trouvé dans le groupe ou raid."
    L.SPELL_NOT_FOUND = "Erreur : sort introuvable."
else
    -- Anglais par défaut
    L.MACRO_UPDATED = "Macro '%s' updated to cast %s on: %s"
    L.NO_TANK = "No tank found in the party or raid."
    L.SPELL_NOT_FOUND = "Error: spell not found."
end
