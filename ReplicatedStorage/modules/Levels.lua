local DataStoreService = game:GetService("DataStoreService")
local Http = game:GetService("HttpService")
local RunService = game:GetService("RunService")

local Levels = DataStoreService:GetDataStore("PlayerLevels")

local module = {}

module.initialized = false

function module.init()
	if RunService:IsServer() then
		local function util(Player)
			if Levels:GetAsync("User__" .. Player.UserId) then
				-- we need to store data inside of values and save on exit, instead of saving on change

				local level = module.cache(Player, "level", 1)
				module.cache(Player, "exp_needed", module.getEXPToNextLevel(level.Value))
				module.cache(Player, "exp", 0)
			else
				Levels:SetAsync("User__" .. Player.UserId, Http:JSONEncode(
					{
						level = 1,
						exp_needed = module.getEXPToNextLevel(1),
						exp = 0
					}
					))
				util(Player) -- rerun now that the player has the datastore entry
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

game:GetService("Players").PlayerRemoving:Connect(function(PLAYER)
	local exp_needed = PLAYER:FindFirstChild("exp_needed")
	local level = PLAYER:FindFirstChild("level")
	local exp = PLAYER:FindFirstChild("exp")
	
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
end)

function module.cache(Player, value, default)
	local val = Instance.new("NumberValue", Player)
	val.Name = value
	val.Value = Http:JSONDecode(Levels:GetAsync("User__" .. Player.UserId))[value] or default

	return val
end

function module.Advance(Player)
	if RunService:IsServer() then
		local level = Player:FindFirstChild("level")
		local exp_needed = Player:FindFirstChild("exp_needed")
		local exp = Player:FindFirstChild("exp")

		level.Value = level.Value + 1
		exp_needed.Value = module.getEXPToNextLevel(level.Value)
		exp.Value = 0
	end
end

if RunService:IsClient() then
	local Player = game:GetService("Players").LocalPlayer
	Player:Kick()
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
	local killsToLevel = 7 * (1 + questLevel^1.21 - questLevel^1.1)
	return module.getEXPToNextLevel(questLevel) * killsToLevel^-1
end

return module