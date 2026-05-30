local addonName, ns = ...

local L = ns.L or {}

local lastPetHit = 0

local frame = CreateFrame("Frame")
frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

local function GetPetStatus()
    local hasPet = UnitExists("pet")
    local petAlive = hasPet and not UnitIsDeadOrGhost("pet")
    local hasPetTarget = UnitExists("pettarget")
    local petAttacking = hasPet and UnitAffectingCombat("pet")
    local recentlyHit = (GetTime() - lastPetHit) <= 2

    return {
        hasPet = hasPet,
        petAlive = petAlive,
        hasPetTarget = hasPetTarget,
        petAttacking = petAttacking,
        inMeleeRange = recentlyHit,
    }
end

frame:SetScript("OnEvent", function()
    local _, subEvent, _, sourceGUID = CombatLogGetCurrentEventInfo()

    if not UnitExists("pet") then return end

    if sourceGUID == UnitGUID("pet") then
        if subEvent == "SWING_DAMAGE"
        or subEvent == "SWING_MISSED"
        or subEvent == "SPELL_DAMAGE"
        or subEvent == "SPELL_MISSED" then
            lastPetHit = GetTime()
        end
    end
end)

SLASH_PETSTATUS1 = "/petstatus"

SlashCmdList["PETSTATUS"] = function()
    local status = GetPetStatus()

    if not status.hasPet then
        print("Aucun familier invoqué.")
        return
    end

    if not status.petAlive then
        print("Familier invoqué, mais mort.")
        return
    end

    print("Familier invoqué et vivant.")

    if status.hasPetTarget then
        print("Le familier a une cible.")
    else
        print("Le familier n'a pas de cible.")
    end

    if status.petAttacking then
        print("Le familier est en combat.")
    else
        print("Le familier n'est pas en combat.")
    end

    if status.inMeleeRange then
        print("Le familier est à portée : il vient de toucher ou tenter de toucher une cible.")
    else
        print("Portée non confirmée : le familier n'a pas tapé récemment.")
    end
end

ns.GetPetStatus = GetPetStatus
