# psychic-octo-pancake
Roblox modules.

## Script Overview
This doesn't include every script. The scripts listed are not in any order.

### Levels

A basic level system for providing xp and levels with data saving for players.
Data is cached as values under the player.

Requires a remote event in replicated storage named `LevelRemote`
This can be used to create an exp counter textlabel,
```lua
function addCommas(str)
	str = tostring(str)
	return #str % 3 == 0 and str:reverse():gsub("(%d%d%d)", "%1,"):reverse():sub(2) or str:reverse():gsub("(%d%d%d)", "%1,"):reverse()
end

game.ReplicatedStorage.LevelRemote.OnClientEvent:Connect(function(args)
	if args.request == "UpdateText" then
		script.Parent.Text = "<b>" .. addCommas(args.__exp) .. "</b>/" .. addCommas(args.__exp_needed)
	end
end)
```
and a level counter with,
```lua
game.ReplicatedStorage.LevelRemote.OnClientEvent:Connect(function(args)
	if args.request == "UpdateText" then
		script.Parent.Text = "<b>Level</b>: " .. args.__level
	end
end)
```
EXP is added with the function `addEXP` which can take up to 4 arguments.
```lua
module.AddEXP(Player, {
  isMonster = true, -- if the exp adding is coming from a monster
  monsterLevel = 21, -- the level of said monster affects the exp given
				
  isQuest = false, -- if the exp adding is coming from a finished quest
  questLevel = nil -- the level of the quest affects the exp given
}
```

- https://www.roblox.com/library/6911019799/LevelsModule <br>
- [ServerScriptService/modules/Levels.lua](https://github.com/0aoq/psychic-octo-pancake/blob/main/ServerScriptService/modules/Levels.lua)

### ActivateModules

The only script that isn't a module script.
Runs the init function for every module that has it so that the module can run required starting actions.

- https://www.roblox.com/library/6910059168/ActivateModules <br>
- [ActivateModules.lua](https://github.com/0aoq/psychic-octo-pancake/blob/main/ActivateModules.lua)

### KeybindModule

A module for assigning keybinds to a set key.

Assign keys with the `set` function.
```lua
module.set("E", function()
  print('Key, "E", was pressed!')
end)
```

- https://www.roblox.com/library/6910069881/KeybindModule <br>
- [ReplicatedStorage/modules/KeybindModule.lua](https://github.com/0aoq/psychic-octo-pancake/blob/main/ReplicatedStorage/modules/KeybindModule.lua)


## Demos

### addEXP

[This demo](https://github.com/0aoq/psychic-octo-pancake/blob/main/Demos/AddEXP.lua) shows an example of adding exp to a user when they touch a part. <br>
The code is the same method as mentioned as the example in the [levels](https://github.com/0aoq/psychic-octo-pancake#levels) module.

### CharacterPos

[This demo](https://github.com/0aoq/psychic-octo-pancake/blob/main/Demos/CharacterPos.lua) shows how to create a character location saving system using the [PlayerData](https://github.com/0aoq/psychic-octo-pancake/blob/main/ServerScriptService/modules/PlayerData.lua) module. Whenever a player leaves the server their location is saved, once they rejoin they'll be teleported back to this location.
