-- player datastore, server/client

local DataStoreService = game:GetService("DataStoreService")
local Http = game:GetService("HttpService")

local PlayerData = {}

local DataStore = DataStoreService:GetDataStore("StoredData")

function PlayerData.write(data, _then)
	local success, err = pcall(function()
		DataStore:SetAsync(data.username, Http:JSONEncode(data))
	end)
	
	if err then
		error(err)
	elseif success then
		print("data written")
	end

	if _then then
		_then()
	end
end

function PlayerData.read(username)
	return DataStore:GetAsync(username)
end

return PlayerData
