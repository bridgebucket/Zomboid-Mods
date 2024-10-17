require "Farming/farming_vegetableconf"
local RTFarmTime = 60.0

local function calcIGTime(RTFarmTime)
	if SandboxVars.DayLength == 1 then
		IGTimePerDay = 15
	elseif SandboxVars.DayLength == 2 then
		IGTimePerDay = 30
	elseif SandboxVars.DayLength == 3 then
		IGTimePerDay = 60
	elseif SandboxVars.DayLength == 4 then
		IGTimePerDay = 120
	elseif SandboxVars.DayLength == 5 then
		IGTimePerDay = 180
	elseif SandboxVars.DayLength == 6 then
		IGTimePerDay = 240
	elseif SandboxVars.DayLength == 7 then
		IGTimePerDay = 300
	elseif SandboxVars.DayLength == 8 then
		IGTimePerDay = 720
	elseif SandboxVars.DayLength == 9 then
		IGTimePerDay = 1440
	end
	RTFarmTimeDec = RTFarmTime / IGTimePerDay
	local IGHours = RTFarmTimeDec * 24
	return IGHours
end

local function RTFarming_OnGameStart()
    if SandboxVars.RTFarming.EnableRTFarm then
        local RTFarmTime = SandboxVars.RTFarming.RTFarmTime
		local cropTime = calcIGTime(RTFarmTime) / 7
		print("RTFarming: Mod enabled! One full growth time is equal to   " .. RTFarmTime .. "   in minutes.\nTime in between crop phases should be   " .. cropTime .. "   or something similar.")
		-- local cropTime = (math.floor((calcIGTime(RTFarmTime) / 7)+0.5)) 
		-- ^^^ This rounds the hour down, I don't think it's needed but further testing is PROBABLY required. 
		-- Might update if I find out a 10x better way to do this
		farming_vegetableconf.props["Carrots"].timeToGrow = cropTime;
		farming_vegetableconf.props["Broccoli"].timeToGrow = cropTime;
		farming_vegetableconf.props["Radishes"].timeToGrow = cropTime;
		farming_vegetableconf.props["Strawberry plant"].timeToGrow = cropTime;
		farming_vegetableconf.props["Tomato"].timeToGrow = cropTime;
		farming_vegetableconf.props["Potatoes"].timeToGrow = cropTime;
		farming_vegetableconf.props["Cabbages"].timeToGrow = cropTime;
    end
end

Events.OnGameBoot.Add(RTFarming_OnGameStart)
Events.OnGameStart.Add(RTFarming_OnGameStart)



