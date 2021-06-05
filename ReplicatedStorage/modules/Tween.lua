return function(instance, data, value)
	data.length = data.length or "1"
	data.style = data.style or "Quint"
	data.direction = data.direction or "InOut"
	
	game:GetService(
		"TweenService"
	):Create(
		instance, 
		TweenInfo.new(
			tonumber(data.length), 
			Enum.EasingStyle[data.style], 
			Enum.EasingDirection[data.direction]
		), 
		value
	):Play()
	
	--[[ 
	Tween(
		game.Workspace.Baseplate, 
		{
			length = "5",
			style = "Quint",
			direction = "InOut"
		},
		{
			Position = Vector3.new(0, 0, 10)
		}
	)
	]]
end
