-- Sound IDs, die gemutet werden sollen
local soundIDs = {
    5769020,5768808,5768801,5768809,5768841,5768797,5768799,5768838,5768837,5768796,5769018,5768836,5768802,5769017,5769019,5769016,5768826,
    5769071,5768819,5768820,5768839,5768967,5768828,5769036,5768827,5768810,5768814,5768975,5768823,5768979,5768963,5768811,5768977,5768800,
    5768965,5768849,5769037,5769059,5768972,5768824,5768840,5768833,5768962,5768978,5768805,5769031,5769060,5768973,5768974,5768974,5768806,
    5769069,5768816,5768822,5769038,5768821,5768971,5768803,5769039,5768807,5768815,5768818,5768825,5769058,5768976,5768817,5769075,5768829,
    5768804,5768964,5768966
}

-- Brann und Magni Namen in verschiedenen Sprachen
local brannNames = {
    ["Brann Bronzebeard"] = true,
    ["Brann Bronzebart"] = true,
    ["Brann Barbabronce"] = true,
    ["Brann Barbe-de-Bronze"] = true,
    ["Brann Barbabronzea"] = true,
    ["Brann Barbabronze"] = true,
    ["Бранн Бронзобород"] = true,
    ["브란 브론즈비어드"] = true,
    ["布莱恩·铜须"] = true,
    ["Magni?"] = true,
    ["¿Magni?"] = true,
    ["Magni ?"] = true,
    ["Магни?"] = true,
    ["마그니?"] = true,
    ["麦格尼？"] = true
}

-- Funktion zum Blockieren der Chat-Blasen
local function BlockChatBubble(_, _, msg, npc)
    if IsInInstance() and brannNames[npc] then
        C_Timer.After(0.025, function()
            for _, bubble in ipairs(C_ChatBubbles.GetAllChatBubbles()) do
                local child = bubble:GetChildren()
                if child and child.String and child.String:GetText() == msg then
                    child:SetAlpha(0) -- Verstecke die Chat-Blase

                    -- Hook zum Anzeigen der Blase später wiederherstellen
                    child:HookScript("OnShow", function(self)
                        self:SetAlpha(1)
                    end)
                    break
                end
            end
        end)
        return true
    end
end

-- Funktion zum Stummschalten der Sound-Dateien
local function MuteSounds()
    for _, soundID in ipairs(soundIDs) do
        MuteSoundFile(soundID)
    end
end

-- Hauptinitialisierung
local function OnEvent(self, event)
    if event == "PLAYER_ENTERING_WORLD" then
        -- Filter für Chat-Events hinzufügen
        ChatFrame_AddMessageEventFilter("CHAT_MSG_MONSTER_SAY", BlockChatBubble)
        ChatFrame_AddMessageEventFilter("CHAT_MSG_MONSTER_YELL", BlockChatBubble)

        -- Sounds beim Laden der Welt stummschalten
        MuteSounds()
    end
end

-- Frame erstellen und Event-Handling setzen
local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:SetScript("OnEvent", OnEvent)
