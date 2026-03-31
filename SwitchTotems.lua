SwitchTotemsFrame = CreateFrame("Frame", "SwitchTotems")
local addonEnabled = false

local function tableContains(tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

function SwitchTotemsFrame:OnEvent(event, ...)
    if event == "ADDON_LOADED" then
        local addonName = ...
        if addonName == "SwitchTotems" then
            self:Init()
            self:UnregisterEvent(event)
        end
    elseif event == "CHAT_MSG_RAID_BOSS_EMOTE" 
        or event == "CHAT_MSG_BG_SYSTEM_NEUTRAL" 
    then
        local msg = ...
        if msg == 'The Arena battle has begun!' then
            print('arena begin')
            local hasSlow = false
            local type, cnt = self:GetArenaSize()
            for i = 1, cnt do
                local arenaObj = "arena" .. i
                if UnitExists(arenaObj) then
                    local class, _ = UnitClass(arenaObj)
                    if tableContains({"Priest", "Warrior", "Warlock"}, class) then
                        self:SetDefaultTotems()
                        return
                    elseif tableContains({"Death Knight", "Rogue", "Mage", "Shaman"}, class) then
                        hasSlow = true
                    end
                else
                    -- rogue or druid so it's still good
                    hasSlow = true
                end
            end

            if hasSlow then
                self:SetEarthbindTotem()
            else
                self:SetStrengthTotem()
            end
        end
    elseif event == "PLAYER_ENTERING_WORLD" then
        self:SetDefaultTotems()
    end
end

SwitchTotemsFrame:SetScript("OnEvent", SwitchTotemsFrame.OnEvent)
SwitchTotemsFrame:RegisterEvent("ADDON_LOADED")

function SwitchTotemsFrame:Init()
    if UnitClass("player") == "Shaman" then
        addonEnabled = true
        self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
        self:RegisterEvent("CHAT_MSG_BG_SYSTEM_NEUTRAL")
        self:RegisterEvent("PLAYER_ENTERING_WORLD")
    end
end

function SwitchTotemsFrame:GetArenaSize()
    local status, mapName, instanceID, lowestlevel, highestlevel, teamSize, registeredMatch = GetBattlefieldStatus(1);
    if teamSize == nil then teamSize = '0' end
    return status, teamSize
end

function SwitchTotemsFrame:SetDefaultTotems()
    -- set tremor as default
    print('SwitchTotems! Set tremor')
    SetMultiCastSpell(134, 8143)
    SetMultiCastSpell(142, 8143)
end

function SwitchTotemsFrame:SetEarthbindTotem()
    print('SwitchTotems! Set earth')
    SetMultiCastSpell(134, 2484)
    SetMultiCastSpell(142, 2484)
end

function SwitchTotemsFrame:SetStrengthTotem()
    print('SwitchTotems! Set strength')
    SetMultiCastSpell(134, 58643)
    SetMultiCastSpell(142, 58643)
end