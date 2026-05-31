local addonName, ns = ...
local L = ns.L

PetAlertDB = PetAlertDB or {}

local CHECK_DELAY = 2.5
local lastPetHit = 0
local lastState = nil
local unlocked = false

local icons = {
    NO_PET = 132161,
    DEAD_PET = 132116,
    NO_TARGET = 132212,
    FAR = 132179,
    OK = 132225,
}

local colors = {
    NO_PET = {0.35, 0.35,0.35},
    DEAD_PET = {1, 0.1, 0.1},
    NO_TARGET = {1, 0.45, 0},
    FAR = {1, 0.9, 0},
    OK = {0.1, 1, 0.1}
}

local frame = CreateFrame("Frame", "PetAlertFrame", UIParent)
frame:SetSize(64, 64)
frame:SetMovable(true)
frame:EnableMouse(false)
frame: RegisterForDrag("LeftButton")
frame:hide()

frame.icon = frame:CreateTexture(nil, "ARTWORK")
frame.icon:SetAllPoints()
frame.icon:SetTexture(icons.OK)

frame.bg = frame:CreateTexture(nil, "BACKGROUND")
frame.bg:SetPoint("TOPLEFT", -4, 4)
frame.bg:SetPoint("BOTTOMRIGHT", 4, -4)
frame.bg:SetTexture(0, 0, 0, 0.55)

frame.text = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
frame.text:SetPoint("TOP", frame, "BOTTOM", 0, -6)
frame.text: SetText("PetAlert")

frame:SetScript("OnDragStart", function(self)
    if unlocked then
        self:StartMoving()
    end
end)

frame:SetScript("OnDragStop", function(self)
    self:StopMovingOrSizing()

    local point, _, relPoint, x, y = self:GetPoint()

    PetAlertDB.point = point
    PetAlertDB.relPoint = relPoint
    PetAlertDB.x = x
    PetAlertDB.y = y
end)

local function IsHunter()
    return select(2, UnitClass("player")) == "HUNTER"
end

local function SaveDefaults()
    PetAlertDB.point = PetAlertDB.point or "CENTER"
    PetAlertDB.relPoint = PetAlertDB.relPoint or "CENTER"
    PetAlertDB.x = PetAlertDB.x or 0
    PetAlertDB.y = PetAlertDB.y or -120
    PetAlertDB.scale = PetAlertDB.scale or 1
    PetAlertDB.sound = PetAlertDB.sound ~= false
end

local function ApplyPosition()
    frame:ClearAllPoints()
    frame:SetPoint(
        PetAlertDB.point,
        UIParent,
        PetAlertDB.relPoint, 
        PetAlertDB.x, 
        PetAlertDB.y
    )

    frame:SetScale(PetAlertDB.scale or 1)
end

local function GetPetState()
    if not IsHunter() then
        return "HIDE"
    end

    if not UnitExists("pet") then
        return "NO_PET"
    end

    if UnitIsDeadOrGhost("pet") then
        return "DEAD_PET"
    end

    if UnitAffectingCombat("player") then
        if not UnitExists("target") then
            return "NO_TARGET"
        end

        local recentyHit = GetTime() - lastPetHit < CHECK_DELAY
        if recentyHit then
            return "FAR"
        end
    end

    return "OK"
end

local function GetTextForState(state)
    if state == "NO_PET" then
        return L.NO_PET
    elseif state == "DEAD_PET" then
        return L.DEAD_PET
    elseif state == "NO_TARGET" then
        return L.NO_TARGET
    elseif state == "FAR" then
        return L.FAR
    else
        return L.OK
    end
end

local function PlayStateSound(state)
    if not PetAlertDB.sound then return end

    if state == "NO_PET" then
        PlaySound(132161, "Master")
    elseif state == "DEAD_PET" then
        PlaySound(132116, "Master")
    elseif state == "NO_TARGET" then
        PlaySound(132212, "Master")
    elseif state == "FAR" then
        PlaySound(132179, "Master")
    end
end

local function UpdatePetAlert()
    local state = GetPetState()

    if state == "HIDE" then
        frame:Hide()
        lastState = state
        return
    end

    if state == "OK" then
        frame:Hide()
    else
        frame:Show()
    end

    frame.icon:SetTexture(icons[state] or icons.OK)

    local r, g, b = unpack(colors[state] or colors.OK)
    frame.bg:SetVertexColor(r, g, b)
    frame.text:SetText(GetTextForState(state))

    if state ~= lastState then
        PlayStateSound(state)
        lastState = state
    end
end

local event = CreateFrame("Frame")
eventFrame:RegisterEvent("PLAYER_LOGIN")
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
eventFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
eventFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
eventFrame:RegisterEvent("UNIT_PET")
eventFrame:RegisterEvent("UNIT_HEALTH")
eventFrame:RegisterEvent("UNIT_TARGET")
eventFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

eventFrame:SetScript("OnEvent", function(_, event, unit)
    if event == "UNIT_HEALTH" and unit ~= "pet" then return end
    if event == "UNIT_PET" and unit ~= "player" then return end
    if event == "UNIT_TARGET" and unit ~= "pet" then return end

    if event == "PLAYER_LOGIN" then
        SaveDefaults()
        ApplyPosition()
    end
    if event == "COMBAT_LOG_EVENT_UNFILTERED" then
        local _, subEvent, _, sourceGUID = CombatLogGetCurrentEventInfo()

        if UnitExists("pet") and sourceGUID == UnitGUID("pet") then
            if subEvent == "SWING_DAMAGE"
            or subEvent == "SWING_MISSED"
            or subEvent == "SPELL_DAMAGE"
            or subEvent == "SPELL_MISSED"
            or subEvent == "RANGE_DAMAGE"
            or subEvent == "RANGE_MISSED" then
                lastPetHit = GetTime()
            end
        end
     end

     updatePetAlert()
end)

local elapsed = 0
eventFrame:SetScript("OnUpdate", function(_, delta)
    elapsed = elapsed + delta

    if elapsed >= CHECK_DELAY then
        UpdatePetAlert()
        elapsed = 0

        if lastState == "FAR" then
            frame:setAlpha(0.45 + math.abs(math.sin(GetTime() * 5)) *0.55)
        else
            frame:setAlpha(1)   
        end

        UpdatePetAlert()
    end
end)

ns.PetAlert = {
    frame = frame,

    lock = function()
        unlocked = false
        frame:EnableMouse(false)
        updatePetAlert()
        print(L.LOCKED)
    end,

    unlock = function()
        unlocked = true
        frame:EnableMouse(true)
        updatePetAlert()
        print(L.UNLOCKED)
    end,

    reset = function()
        PetAlertDB.point = "CENTER"
        PetAlertDB.relPoint = "CENTER"
        PetAlertDB.x = 0
        PetAlertDB.y = -120
        ApplyPosition()
        print(L.RESET)
    end,

    Test = function()
        unlocked = true
        frame:EnableMouse(true)
        frame:Show()
        frame.icon:SetTexture(icons.FAR)
        frame.icon:SetVertexColor(1, 0.9, 0)
        frame.text:SetText(L.FAR)
    end,

    ToggleSound = function()
        PetAlertDB.sound = not PetAlertDB.sound
        print("PetAlert sound " .. (PetAlertDB.sound and "ON" or "OFF"))
    end,
}