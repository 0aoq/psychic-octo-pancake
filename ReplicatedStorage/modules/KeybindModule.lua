-- keybind creator, client only

local UserInputService = game:GetService("UserInputService")

local keybinds = {}

function keybinds.set(key, _then)
	if game:GetService("RunService"):IsClient() then
		print("[&client]:", "(keybinds.set)", 'keybind "' .. key .. '" set.')

		UserInputService.InputEnded:Connect(function(input)
			if input.KeyCode == Enum.KeyCode[key] then
				_then()
			end
		end)
	else
		warn("[&server]:", "(err)", "KeybindModule.set cannot be called from server")
	end
end

return keybinds
