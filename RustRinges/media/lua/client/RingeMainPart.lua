require "TimedActions/ISInjectionAction"

local handleOptionClicked = function(itemName, player)
    local injectionTime = 50
    ISTimedActionQueue.add(ISInjectionAction:new(player, itemName, injectionTime))
end

-- Adds the context menu option for injecting syringe.
local Items = {
    ["RustRinges.PercentTenRinge"] = true,
    ["RustRinges.PercentTwentyfiveRinge"] = true,
    ["RustRinges.PercentFiftyRinge"] = true,
    ["RustRinges.PercentFullRinge"] = true,
    ["RustRinges.PercentDeathRinge"] = true,
    ["RustRinges.InstantReliefRinge"] = true,
    ["RustRinges.ThePristineCondition"] = true,
    ["RustRinges.ThePristineCondition35"] = true,
}
---@type Callback_OnFillInventoryObjectContextMenu
local addContextOption = function(playerNum, context, items)
    local primaryItem = items[1]
    if not instanceof(primaryItem, "InventoryItem") then
        ---@cast primaryItem ContextMenuItemStack
        primaryItem = primaryItem.items[1]
    end

    if not Items[primaryItem:getFullType()] then return end

    context:addOption( "Inject Syringe", nil, function()
        handleOptionClicked(primaryItem, getPlayer(playerNum))
    end)
end

Events.OnFillInventoryObjectContextMenu.Add(addContextOption)