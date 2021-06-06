local RunService = game:GetService("RunService")

-- custom wait module

--[[

local wait = require(game.ReplicatedStorage.modules.wait)

wait(1)
print("1 second has passed.")

]]

--[[
@function Custom wait module
@param {number} x: the time to wait
]]

return function(x)
    x = x or 0.0001 -- default x to 0.0001 if not chosen
    
    local begun = tick() -- get when the wait started
    
    while true do
        RunService.Stepped:Wait() -- wait for runservice to step (on frame)
        
        local passed = tick() - begun -- get the time that has passed
        if passed >= x then
            return passed, begun -- if the time passed if more or equal to the wait time return
        end
    end
end
