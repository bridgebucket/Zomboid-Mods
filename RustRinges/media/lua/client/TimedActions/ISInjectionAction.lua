require "TimedActions/ISBaseTimedAction"

ISInjectionAction = ISBaseTimedAction:derive("ISInjectionAction")


function ISInjectionAction:isValid()
    local playerInv = self.character:getInventory()
    if not playerInv:contains(self.item) then
        return false
    end
    if self.character == self.otherPlayer then
        return false
    end
    return true
end

function ISInjectionAction:update()
    -- if self.item then
    --     self.item:setJobDelta(self:getJobDelta())
    -- end
end

function ISInjectionAction:start()
    -- if self.item then
        -- self.item:setJobType(getText("ContextMenu_InjectingRinge"))
        -- self.item:setJobDelta(0.0)
    -- end
    self:setActionAnim("MedicalCheck")
    -- self:setOverrideHandModels(self.item:getStaticModel(), nil)
    self.character:getEmitter():playSound("LANParty")
    if self.item:getFullType():contains("ThePristineCondition") or self.item:getFullType():contains("InstantReliefRinge") then
        self.character:getEmitter():playSound("NNEKA")
    end
end

function ISInjectionAction:stop()
    -- if self.item then
    --     self.item:setJobDelta(0.0)
    -- end
    ISBaseTimedAction.stop(self)
end

function ISInjectionAction:perform()
    -- if self.item then
	-- 	self.item:setJobDelta(0.0)
	-- end

    local iType = self.item:getFullType()

	if iType:contains("PercentTenRinge") or iType:contains("PercentTwentyfiveRinge") or iType:contains("PercentFiftyRinge") or iType:contains("PercentFullRinge") or iType:contains("PercentDeathRinge") then
        local bodyDamage = self.character:getBodyDamage()
        local oldHealth = bodyDamage:getOverallBodyHealth()
        local newHealth

        if iType:contains("PercentTenRinge") then
            if oldHealth >= 87 then
                newHealth = 10000000
            elseif oldHealth >= 80 then
                newHealth = 46
            elseif oldHealth >= 70 then
                newHealth = 45
            elseif oldHealth >= 60 then
                newHealth = 44
            elseif oldHealth >= 50 then
                newHealth = 44
            elseif oldHealth >= 40 then
                newHealth = 42
            elseif oldHealth >= 30 then
                newHealth = 42
            elseif oldHealth >= 20 then
                newHealth = 41
            elseif oldHealth >= 10 then
                newHealth = 41
            elseif oldHealth < 10 then
                newHealth = 40
            end
        elseif iType:contains("PercentTwentyfiveRinge") then
            if oldHealth >= 70.0 then
                newHealth = 10000000
            elseif oldHealth >= 58.0 then
                newHealth = 104
            elseif oldHealth >= 47.0 then
                newHealth = 92
            elseif oldHealth >= 23.0 then
                newHealth = 87
            elseif oldHealth < 23.0 then
                newHealth = 85
            end
        elseif iType:contains("PercentFiftyRinge") then
            if oldHealth >= 45.0 then
                newHealth = 10000000
            elseif oldHealth >= 25.0 then
                newHealth = 185
            elseif oldHealth < 25.0 then
                newHealth = 160
            end
        elseif iType:contains("PercentDeathRinge") then
            bodyDamage:ReduceGeneralHealth(100)
            newHealth = 0
        else
            newHealth = 10000000
        end
        bodyDamage:AddGeneralHealth(newHealth)
        self.character:getStats():setEndurance(self.character:getStats():getEndurance() + 100)
    end

	if iType:contains("ThePristineCondition") or iType:contains("ThePristineCondition35") then
        local bodyDamage = self.character:getBodyDamage()

        -- Fixes player condition...
        bodyDamage:RestoreToFullHealth()
        local PlayerBodyParts = bodyDamage:getBodyParts()
        for i = 0, PlayerBodyParts:size() - 1 do
            local bodyPart = PlayerBodyParts:get(i)
            bodyPart:setStiffness(0)
        end
        self.character:getStats():setEndurance(self.character:getStats():getEndurance() + 100)
        if iType:contains("ThePristineCondition35") then
            -- ...and removes zombie infection
            bodyDamage:setInfected(false)
            bodyDamage:setInfectionMortalityDuration(-1)
            bodyDamage:setInfectionTime(-1)
            bodyDamage:setInfectionLevel(0)
            local bodyParts = bodyDamage:getBodyParts()
            for i=bodyParts:size()-1, 0, -1  do
                local bodyPart = bodyParts:get(i)
                bodyPart:SetInfected(false)
            end
            bodyDamage:setInfected(false)
            print("A player took a Pristine Condition 3.5.")
        else
            -- ...and doesn't remove zombie infection
            bodyDamage:setInfected(true)
            bodyDamage:setInfectionLevel(0)
            print("A player took a Pristine Condition.")
	    end
    end
	if iType:contains("InstantReliefRinge") then
        local bodyDamage = self.character:getBodyDamage()
        bodyDamage:setInfected(false)
        bodyDamage:setInfectionMortalityDuration(-1)
        bodyDamage:setInfectionTime(-1)
        bodyDamage:setInfectionLevel(0)
        local bodyParts = bodyDamage:getBodyParts()
        for i=bodyParts:size()-1, 0, -1  do
            local bodyPart = bodyParts:get(i)
            bodyPart:SetInfected(false)
        end
        bodyDamage:setInfected(false)
        print("A player took an Instant Relief.")
    end
    print(self.item)
    self.item:getContainer():Remove(self.item)
    ISBaseTimedAction.perform(self)
end

function ISInjectionAction:new(character, item, time)
    local o = {}
    setmetatable(o, self)
    self.__index = self

    o.character = character
    o.stopOnWalk = false
    o.stopOnRun = true
    o.ignoreHandsWounds = true
    o.item = item
    o.maxTime = time
    if o.character:isTimedActionInstant() then
        o.maxTime = 1
    end
    return o
end
