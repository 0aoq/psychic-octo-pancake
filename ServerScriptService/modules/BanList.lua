local DataStoreService = game:GetService("DataStoreService")
local DataStore = DataStoreService:GetDataStore("Moderation")

local module = {}

module.initialized = false

function init()
	local BanList = DataStore:GetAsync("BanList")

	game:GetService("Players").PlayerAdded:Connect(function(Player)
		for _,name in pairs(BanList) do
			if Player.Name ~= name then return end
			Player:Kick("You were banned.")
		end
	end)

	while true do
		wait(1)
		for _,Player in pairs(game:GetService("Players"):GetPlayers()) do
			for _,name in pairs(BanList) do
				if Player.Name ~= name then return end
				Player:Kick("You were banned.")
			end
		end
	end

	--[[
		CMD LINE

		local DataStoreService = game:GetService("DataStoreService")
		local DataStore = DataStoreService:GetDataStore("Moderation")
		
		DataStore:SetAsync("BanList", {
			"0a_oq",
		})
	]]
end

return module
