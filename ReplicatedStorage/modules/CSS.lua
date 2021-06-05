local module = {}

function module.applyStyles(component, style)
	-- Styles
	
	local borderRadius = style.borderRadius or 0
	local background = style.background or Color3.fromRGB(255, 255, 255)
	
	local posX = style.posX or UDim2.new(0, 0, 0, 0).X
	local posY = style.posY or UDim2.new(0, 0, 0, 0).Y
	local sizeX = style.sizeX or UDim2.new(0, 0, 0, 0).X
	local sizeY = style.sizeY or UDim2.new(0, 0, 0, 0).Y

	Instance.new("UICorner", component).CornerRadius = UDim.new(borderRadius, 0)
	component.BackgroundColor3 = background
	component.Position = UDim2.new(posX, 0, posY, 0)
	component.Size = UDim2.new(sizeX, 0, sizeY, 0)
	
	-- Events

	component.MouseEnter:Connect(style.onhover or function() end)
	component.MouseLeave:Connect(style.onunhover or function() end)

	if component:IsA("TextButton") then
		component.MouseButton1Click:Connect(style.active or function() end)
	end
end

function module.render(container, styles)	
	for _,component in pairs(container:GetDescendants()) do
		if component:IsA("Frame") or component:IsA("TextButton") then
			local style = styles[component:GetAttribute("class")]

			if style then
				module.applyStyles(component, style)
			end
		end
	end
end

function module.getElementByClassName(container, className)
	for _,component in pairs(container:GetDescendants()) do
		if component:GetAttribute("class") == className then
			return component
		end
	end
end

return module
