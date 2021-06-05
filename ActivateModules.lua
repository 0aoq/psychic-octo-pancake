local modules = {}

local ClientModules = game:GetService("ReplicatedStorage"):WaitForChild("modules", 1)
local ServerModules = game:GetService("ServerScriptService"):WaitForChild("modules", 1)

local directories = {ClientModules, ServerModules}

_G.ServerModulesRun = false

warn("[&sever@core]:", "(modules)", 'starting module initialization.')

local function activate(directory)
	for _, moduleScript in pairs(directory:GetDescendants()) do
		if moduleScript:IsA("ModuleScript") then
			print("[&sever@core]:", "(module require)", 'module "' .. moduleScript.Name .. '" required.')
			modules[moduleScript.Name] = require(moduleScript)
		end
	end
end


local function initialize()
	for moduleName, module in pairs(modules) do
		if typeof(module) == "table" and (module.init and not module.initialized) then
			print("[&sever@core]:", "(module initialize)", 'module "' .. moduleName .. '" initialized.')
			module.init(modules)
			module.initialized = true
		end
	end
end

for _,directory in pairs(directories) do
	activate(directory) -- first run
	
	directory.DescendantAdded:connect(function(moduleScript) -- future run(s)
		if moduleScript:IsA("ModuleScript") then
			print("[&sever@core]:", "(module require)", 'module "' .. moduleScript.Name .. '" required.')
			local module = require(moduleScript)
			modules[moduleScript.Name] = module
			
			if typeof(module) == "table" and module.init and _G.ServerModulesRun then
				print("[&sever@core]:", "(module initialize)", 'module "' .. moduleScript.Name .. '" initialized.')
				module.init(modules)
			end
		end
	end)
end


table.sort(modules, function(module1, module2)
	return (module1.priority or 10) < (module2.priority or 10)
end)

_G.ServerModulesRun = true
initialize()
warn("[&sever@core]:", "(modules)", 'all queued modules passed initialize!')
