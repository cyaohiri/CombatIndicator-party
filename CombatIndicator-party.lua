local _G = _G or getfenv(0)

-- Function to update combat status icons for party members
local function UpdatePartyCombatIcons()
    for i = 1, GetNumPartyMembers() do
        local unit = "party" .. i
        local frame = _G["PartyMemberFrame" .. i]

        if UnitAffectingCombat(unit) then
            frame.combatIcon:Show()
        else
            frame.combatIcon:Hide()
        end
    end
end

local function EventHandler()
    if event == "PLAYER_ENTERING_WORLD" then 
        -- Create and position combat icons
        for i = 1, MAX_PARTY_MEMBERS do
            local frame = _G["PartyMemberFrame" .. i]
            local combatIcon = frame:CreateTexture(nil, "OVERLAY")
            combatIcon:SetTexture("Interface\\Icons\\ABILITY_DUALWIELD")
            combatIcon:SetWidth(24)
            combatIcon:SetHeight(24)
            combatIcon:SetPoint("TOPLEFT", frame, "TOPRIGHT", 2, -2)
            combatIcon:Hide()
            frame.combatIcon = combatIcon
        end
    end
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:SetScript("OnEvent", EventHandler)

local lastUpdate = GetTime()
frame:SetScript("OnUpdate", function()
    -- Poll the party members' combat status twice a second
    if GetNumPartyMembers() == 0 then
        return
    end
    elapsed = GetTime() - lastUpdate
    if elapsed >= 0.5 then 
        lastUpdate = GetTime()
        UpdatePartyCombatIcons()
    end
end)
