# SavingData

When saving data, you should make use of the `DataCache` module.
Data should only be saved in JSON format, and saved on PlayerRemoving.

Whenever data is changed, it should only change the cached version, then it should save the values of the cached items.
This method is used in the `Levels` module to save the player's level, but not fill up the data queue.

Data is saved using the PlayerRemoving function, then a seperate `write` function is called.
```lua
game:GetService("Players").PlayerRemoving:Connect(function(PLAYER)
	writeData(PLAYER)
end)
```
The `write` function then updates the datastore.
```lua
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
```
Data is saved as JSON objects because you cannot save tables into the datastore, and we want to store more than one value.

### Note
Make sure that all JSON objects are properly encoded and decoded, as a single mistake will cause data to not be saved when the player leaves, or it is requested. 
It will also **not** show an error in the output, so make sure you double check that data is encoded and decoded properly.
