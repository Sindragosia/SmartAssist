local addonName, ns = ...

ns.L = {}

local L = ns.L

if GetLocale() == "frFR" then
    L.NO_TANK = "Aucun tank trouvé dans le groupe ou raid."

    L.NO_PET = "Familier Absent"
    L.DEAD_PET = "Familier Mort"
    L.NO_TARGET = "Sans cible"
    L.FAR = "Familier trop loin"
    L.OK = "OK"
    L.LOCKED = "PetAlert est verrouillé. Utilisez /petalert pour le déverrouiller."
    L.UNLOCKED = "PetAlert est déverrouillé. Utilisez /petalert pour le verrouiller."
    L.RESET = "Réinitialiser les positions de PetAlert"
    L.SCALE = "Taille de PetAlert (0.5 - 2.0)"
else
    L.NO_TANK = "No tank found in the party or raid."

    L.NO_PET = "No pet found."
    L.DEAD_PET = "Dead pet found."
    L.NO_TARGET = "No target found."
    L.FAR = "Pet too far away."
    L.OK = "OK"
    L.LOCKED = "PetAlert is locked. Use /petalert to unlock it."
    L.UNLOCKED = "PetAlert is unlocked. Use /petalert to lock it."
    L.RESET = "Reset PetAlert positions"
    L.SCALE = "PetAlert scale (0.5 - 2.0)"