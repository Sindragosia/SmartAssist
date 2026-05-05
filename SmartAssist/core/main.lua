SLASH_CASTTANK1 = "/casttank"

SlashCmdList["CASTTANK"] = function()
  local macroName = "DetournTank"
  local icon = "INV_MISC_QUESTIONMARK"
  local found = false

  -- Cherche dans le groupe ou raid
  local max = IsInRaid() and 40 or 4
  local prefix = IsInRaid() and "raid" or "party"

  for i = 1, max do
    local unit = prefix..i
    if UnitExists(unit) and UnitGroupRolesAssigned(unit) == "TANK" then
      local name = GetUnitName(unit, true)
      if name then
        local body = "/cast [@"..name.."] Détournement"
        local id = GetMacroIndexByName(macroName)

        if id == 0 then
          CreateMacro(macroName, icon, body, false)
        else
          EditMacro(id, macroName, icon, body)
        end

        print("Macro '"..macroName.."' mise à jour pour caster sur : "..name)
        found = true
      end
      break
    end
  end

  if not found then
    print("Aucun tank trouvé dans le groupe ou raid.")
  end
end