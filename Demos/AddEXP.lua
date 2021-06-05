local debounce = false
local module = require(game.ServerScriptService.modules.Levels)

script.Parent.Touched:Connect(function(Part)
	if Part.Parent:FindFirstChild("Humanoid") then
		local Player = game:GetService("Players"):GetPlayerFromCharacter(Part.Parent)
		if not debounce then
			debounce = true
			
			module.AddEXP(Player, {
				isMonster = true,
				monsterLevel = 21,
				
				isQuest = false,
				questLevel = nil
			})
			
			wait(0.2)
			debounce = false
		end
	end
end)
