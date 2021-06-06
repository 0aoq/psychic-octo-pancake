local RunService = game:GetService("RunService")

-- custom wait module

--[[

local wait = require(game.ReplicatedStorage.modules.wait)

wait(1)
print("1 second has passed.")

]]

return function(x)
	x = x or 1
	
	local begun = tick()
	
	while true do
		RunService.Stepped:Wait()
		
		local passed = tick() - begun
		if passed >= x then
			return passed, begun
		end
	end
end
