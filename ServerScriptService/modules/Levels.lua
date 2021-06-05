local RunService = game:GetService("RunService")

local DataStoreService = game:GetService("DataStoreService")
local Http = game:GetService("HttpService")

local Levels = DataStoreService:GetDataStore("PlayerLevels")
local cache = require(game.ReplicatedStorage.modules.DataCache)

local module = {}

module.initialized = false

function module.init()
	if RunService:IsServer() then
		local function util(Player)
			if Levels:GetAsync("User__" .. Player.UserId) then
				-- we need to store data inside of values and save on exit, instead of saving on change

				local level = cache(Player, {
					name = "level",
					value = Http:JSONDecode(Levels:GetAsync("User__" .. Player.UserId)).level,
					default = 1,
					__type = "Number"
				})
				
				local exp_needed = cache(Player, {
					name = "exp_needed",
					value = Http:JSONDecode(Levels:GetAsync("User__" .. Player.UserId)).exp_needed,
					default = 100,
					__type = "Number"
				})
				
				local exp = cache(Player, {
					name = "exp",
					value = Http:JSONDecode(Levels:GetAsync("User__" .. Player.UserId)).exp,
					default = 0,
					__type = "Number"
				})
				
				delay(0.5, function()
					game.ReplicatedStorage.LevelRemote:FireClient(Player, {
						request = "UpdateText",
						__level = level.Value,
						__exp_needed = exp_needed.Value,
						__exp = exp.Value
					})
				end)
			else
				Levels:SetAsync("User__" .. Player.UserId, Http:JSONEncode({
					level = 1,
					exp_needed = module.getEXPToNextLevel(1),
					exp = 0
				}))
				util(Player) -- rerun now that the player has a datastore entry
			end
		end

		for _,Player in pairs(game:GetService("Players"):GetPlayers()) do
			util(Player)
		end

		game:GetService("Players").PlayerAdded:Connect(function(Player)
			util(Player)
		end)
	end
end

local function writeData(PLAYER)
	local cache = PLAYER:FindFirstChild(".cache")
	local exp_needed = cache:FindFirstChild("exp_needed")
	local level = cache:FindFirstChild("level")
	local exp = cache:FindFirstChild("exp")

	local playerLevel = Http:JSONDecode(Levels:GetAsync("User__" .. PLAYER.UserId))

	playerLevel.exp_needed = exp_needed.Value
	playerLevel.level = level.Value
	playerLevel.exp = exp.Value

	local success, err = pcall(function()
		Levels:SetAsync("User__" .. PLAYER.UserId, Http:JSONEncode(playerLevel))
	end)

	if err then
		error(err)
	elseif success then
		print("Player level updated.")
	end
end

game:GetService("Players").PlayerRemoving:Connect(function(PLAYER)
	writeData(PLAYER)
end)

--[[function module.cache(Player, value, default)
	local val = Instance.new("NumberValue", Player)
	val.Name = value
	val.Value = Http:JSONDecode(Levels:GetAsync("User__" .. Player.UserId))[value] or default

	return val
end]]

-- Level Utilities

function module.Advance(Player)
	if RunService:IsServer() then
		local cache = Player:FindFirstChild(".cache")
		local exp_needed = cache:FindFirstChild("exp_needed")
		local level = cache:FindFirstChild("level")
		local exp = cache:FindFirstChild("exp")

		level.Value = level.Value + 1
		exp_needed.Value = module.getEXPToNextLevel(level.Value)
		exp.Value = 0

		game.ReplicatedStorage.LevelRemote:FireClient(Player, {
			request = "UpdateText",
			__level = level.Value,
			__exp_needed = exp_needed.Value,
			__exp = exp.Value
		})

		writeData(Player)
	end
end

function module.AddEXP(Player, args)
	if RunService:IsServer() then
		local value = 100

		if args.isMonster then
			value = math.floor(module.getMonsterEXPFromLevel(args.monsterLevel) + 0.5)
		elseif args.isQuest then
			value = math.floor(module.getQuestEXPFromLevel(args.questLevel) + 0.5)
		else
			value = math.floor(module.getQuestEXPFromLevel(1) + 0.5)
		end
		
		local cache = Player:FindFirstChild(".cache")
		local level = cache:FindFirstChild("level")
		local exp_needed = cache:FindFirstChild("exp_needed")
		local exp = cache:FindFirstChild("exp")

		exp.Value = exp.Value + value

		game.ReplicatedStorage.LevelRemote:FireClient(Player, {
			request = "UpdateText",
			__level = level.Value,
			__exp_needed = exp_needed.Value,
			__exp = exp.Value
		})

		if exp.Value >= exp_needed.Value then
			module.Advance(Player)
		end
	end
end

-- Level EXP

function module.getEXPForLevel(level)
	return 14 + 5*(level - 2) + 4*(level - 2)^4
end

function module.getTotalAP(playerData)
	return playerData.level - 1
end

function module.getQuestGoldFromLevel(questLevel)
	return 100 + math.floor(questLevel ^ 1.18 * 300)
end

function module.getEXPToNextLevel(currentLevel)
	return module.getEXPForLevel(currentLevel + 1)
end

function module.getQuestEXPFromLevel(questLevel)
	return 10 + (module.getEXPToNextLevel(questLevel) * (1/1.5) * questLevel^(-1/6))
end

function module.getMonsterEXPFromLevel(questLevel)
	local killsToLevel = 7 * (1 + questLevel^1.3 - questLevel^1.1)
	return module.getEXPToNextLevel(questLevel) * killsToLevel^-1
end

return module
