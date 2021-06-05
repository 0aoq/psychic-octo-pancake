local PlayerData = require(game.ServerScriptService.modules.PlayerData)

local Http = game:GetService("HttpService")
local RunService = game:GetService("RunService")

game.Players.PlayerAdded:Connect(function(Player)
	local posval = Instance.new("StringValue", Player)
	posval.Name = "CharacterVector3"
	
	local run = false
	
	Player.CharacterAdded:Connect(function(char)
		if not run then
			run = true
			if PlayerData.read(Player.Name) == nil then
				PlayerData.write({
					username = Player.Name,
					userId = Player.UserId,
					map = {
						cframe = Player.Character.HumanoidRootPart.Value,
						placeid = game.PlaceId,
						gameid = game.GameId
					}
				})
			else
				local currentData = Http:JSONDecode(PlayerData.read(Player.Name))
				Player.Character.HumanoidRootPart.CFrame = CFrame.new(
					Vector3.new(currentData.map.cframe:match("(.+), (.+), (.+)")),
					Vector3.new(0, 0, 0)
				)
			end
		end
	end)
	
	local function service()
		RunService.Heartbeat:Connect(function()
			if Player.Character then
				posval.Value = tostring(Player.Character.HumanoidRootPart.Position)
			end
		end)
	end
	
	coroutine.wrap(service)()
end)

game.Players.PlayerRemoving:Connect(function(Player)
	local currentData = Http:JSONDecode(PlayerData.read(Player.Name))
	currentData.map.cframe = Player.CharacterVector3.Value
	PlayerData.write(currentData)
end)
