require "ISUI/PlayerData/ISPlayerData"

local function beltDeathDestruction(player, item)
	if not item:isEquipped() then
		return
	end
	player:removeWornItem(item)
	local data = getPlayerData(player:getPlayerNum())
	if data then
		data.playerInventory:refreshBackpacks()
	end
end

local function playerSpawn(player)
	Events.OnPlayerUpdate.Remove(playerSpawn)
	if player:getHoursSurvived() > 0.1 then
		return
	end

	local belts = {}
	belts["Belt"] = true
	belts["Belt2"] = true
	table.insert(belts, "Belt")
	table.insert(belts, "Belt2")

	local inv = player:getInventory()
	local invItems = {}
	for i = 1, inv:getItems():size() do
		local item = inv:getItems():get(i-1)
		if #belts > 0 and belts[item:getType()] then
			table.insert(invItems, item)
		end
	end
	for k,v in pairs(invItems) do
		beltDeathDestruction(player, v)
		inv:Remove(v)
	end
	triggerEvent("OnClothingUpdated", player)
end

Events.OnCreatePlayer.Add(function()
	Events.OnPlayerUpdate.Add(playerSpawn)
end)
