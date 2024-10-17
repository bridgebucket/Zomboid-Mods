-- Local Globals

local player = nil
local LoadedEvents = false
local inBuilding = false
local AlreadyEnteredBuildings = {}
local oldhalzombiepos = {["X"] = nil, ["Y"] = nil, ["Z"] = nil}
local isClumsy = false



-- Start


function figureOutPlayer()
    if player == nil or player:isLocalPlayer() == false then
        player = getPlayer()
        playerdata = player:getModData()
        if LoadedEvents == false and player:HasTrait("Puppylike") then AddPupEvents() end
    end
end


-- local functions


function onBarkKey(key)
    if key ~= getCore():getKey("Shout") then return false end

    local dist = 2
    local gender = ""
    local voice = ""
    local pl = getPlayer()
    local BarkShout = ""

    if pl:isSneaking() then voice = "Whimper" else voice = "Bark" end
    if pl:getDescriptor():isFemale() then gender = "f" else gender = "m" end
    BarkShout = tostring(gender..voice)

    getSoundManager():PlayWorldSound(BarkShout, pl:getSquare(), 0, 0, 0, false); 
    addSound(pl, pl:getX(), pl:getY(), pl:getZ(), dist, 0);
        end

    local function BarkforShouts() Events.OnKeyPressed.Add(onBarkKey) end



-- local function applyPanic(panicAmo,stressAmo,playBreathing,forceAwake,Request)
--     if Request:isLocalPlayer() and Request:getPlayerNum() == 0 then
--         local panic = player=:getStats():getPanic() + panicAmo
--         local stress = player:getStats():getStress() + stressAmo
--         player:getStats():setPanic(panic)
--         player:getStats():setStress(stress)
--         if playBreathing == true then
--             if player:isFemale() then getSoundManager():PlaySound("female_heavybreathpanic", false, 5):setVolume(0.035)
--             else getSoundManager():PlaySound("male_heavybreathpanic", false, 5):setVolume(0.035) end
--         end
--         if forceAwake == true then player:forceAwake() end
--     end
-- end

-- local function applyDepression(depressionAmo,sanityAmo,playLowSanity,Request)
--     if Request:isLocalPlayer() and Request:getPlayerNum() == 0 then
--         local depression = player:getBodyDamage():getUnhappynessLevel() + depressionAmo
--         local sanity = player:getStats():getSanity() + sanityAmo
--         player:getBodyDamage():setUnhappynessLevel(depression)
--         player:getStats():setSanity(sanity)
--         if playLowSanity == true then
--             local randNum = ZombRand(4)+1
--             getSoundManager():PlaySound("insane"..randNum, false, 0):setVolume(0.25)
--         end
--     end
-- end



-- Checks

function CheckIfYouDied(deadPlayer)
    if deadPlayer == player and deadPlayer:isLocalPlayer() and deadPlayer:getPlayerNum() == 0 then RemoveSchizEvents() player = nil end
end

function MakeNewPlayer(_,newplayer)
    if newplayer:isLocalPlayer() and newplayer:getPlayerNum() == 0 and player == nil then figureOutPlayer()
    end
end

function ForcePlayerLoad()
    figureOutPlayer()
    RemovePupEvents()
    AddPupEvents()
end

-- Events

Events.OnGameStart.Add(figureOutPlayer)
Events.OnPlayerDeath.Add(CheckIfYouDied)
Events.OnCreatePlayer.Add(MakeNewPlayer)
Events.OnLoad.Add(FigureOutBuilding)


function AddPupEvents()
    Events.OnGameStart.Add(BarkforShouts)
    -- Translator:loadFiles("ARF")
    LoadedEvents = true
end

function RemovePupEvents()
    Events.OnGameStart.Remove(BarkforShouts)
    -- load previous translation file
    LoadedEvents = false
end