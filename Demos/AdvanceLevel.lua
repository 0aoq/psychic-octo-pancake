local debounce = false
local module = require(game.ReplicatedStorage.modules.Levels)

script.Parent.Touched:Connect(function(Part)
	if Part.Parent:FindFirstChild("Humanoid") then
		local Player = game:GetService("Players"):GetPlayerFromCharacter(Part.Parent)
		if not debounce then
			debounce = true
			
			module.Advance(Player)
			
			wait(2)
			debounce = false
		end
	end
end)
