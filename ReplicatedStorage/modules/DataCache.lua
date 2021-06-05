return function(instance, data)
	local function create(directory)
		local val = Instance.new(data.__type .. "Value", directory)
		val.Value = data.value or data.defaultTo
		val.Name = data.name
		
		return val
	end
	
	if not instance:FindFirstChild(".cache") then
		local directory = Instance.new("Folder", instance)
		directory.Name = ".cache"
		
		return create(directory)
	else
		return create(instance:FindFirstChild(".cache"))
	end
end
