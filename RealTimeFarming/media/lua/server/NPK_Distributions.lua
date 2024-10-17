require "Items/Distributions"
require "Items/ProceduralDistributions"
local i, j, k, v

local distToRemoveFrom = {
    "CrateFarming",
    "CrateFertilizer",
    "GigamartFarming",
    "ToolStoreFarming",
}

local toRemove = {
    "Fertilizer",
    "FertilizerEmpty",
    "CrateFertilizer",
}

if SandboxVars.RTFarming.DisableNPK then
    print("RTFarming: Removal of fertilizer spawns is enabled!")
    for i = 1, #distToRemoveFrom do
        for j = 1, #toRemove do
            for k, v in ipairs(ProceduralDistributions.list[distToRemoveFrom[i]].items) do
                if(ProceduralDistributions.list[distToRemoveFrom[i]].items[k] == toRemove[j])
                then
                    table.remove(ProceduralDistributions.list[distToRemoveFrom[i]].items, k)
                    table.remove(ProceduralDistributions.list[distToRemoveFrom[i]].items, k+1)
                end
            end
        end
    end
else
    print("RTFarming: Removal of fertilizer spawns is disabled! Usage of fertilizer on Real-Time crops is not recommended. GLHF")
end