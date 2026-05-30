SLASH_CASTTANK1 = "/casttank"

local _, ns = ...
local L = ns.L

print(L.NO_TANK)

SlashCmdList["CASTTANK"] = function()
  local macroName = "DetournTank"
  local icon = "INV_MISC_QUESTIONMARK"
  local found = false

  -- Nom du sort automatiquement localisé selon la langue du jeu
  local spellName = C_Spell and C_Spell.GetSpellName
    and C_Spell.GetSpellName(34477)
    or GetSpellInfo(34477)

if not spellName then
    print(L.SPELL_NOT_FOUND)
    return
end

  local max = IsInRaid() and 40 or 4
  local prefix = IsInRaid() and "raid" or "party"

  for i = 1, max do
    local unit = prefix .. i

    if UnitExists(unit) and UnitGroupRolesAssigned(unit) == "TANK" then
      local name = GetUnitName(unit, true)

      if name then
        local body = "/cast [@" .. name .. "] " .. spellName
        local id = GetMacroIndexByName(macroName)

        if id == 0 then
          CreateMacro(macroName, icon, body, false)
        else
          EditMacro(id, macroName, icon, body)
        end

          print(string.format(
    L.MACRO_UPDATED,
    macroName,
    spellName,
    name
))
      end

      break
    end
  end

  if not found then
    print(L.NO_TANK)
  end
end
