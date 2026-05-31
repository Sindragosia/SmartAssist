local addonName = ...

local CURRENT_VERSION = "1.0.1"
local UPDATE_URL = "https://github.com/Sindragosia/SmartAssist/releases/latest"

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")

frame:SetScript("OnEvent", function()
    C_Timer.After(2, function()
        print("|cff00ff00" .. addonName .. " chargé (v" .. CURRENT_VERSION .. ")|r")
        print("|cffffff00Vérifie les mises à jour :|r " .. UPDATE_URL)
    end)
end)