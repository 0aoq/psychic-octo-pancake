local module = {}

module.initialized = false
module.removedPlayers = {}

function module.init()
	local function util(Player)
		local PlayerChats = 0
		Player.Chatted:Connect(function(msg)
			PlayerChats = PlayerChats + 1
			
			if PlayerChats > 5 then
				table.insert(module.removedPlayers, 1, Player.Name)
				Player:Kick("Removed from server: Chat flood.")
			end
			
			delay(2, function()
				PlayerChats = 0
			end)
		end)
	end
	
	for _,Player in pairs(game:GetService("Players"):GetPlayers()) do
		util(Player)
	end
	
	game:GetService("Players").PlayerAdded:Connect(function(Player)
		util(Player)
	end)
end

return module
