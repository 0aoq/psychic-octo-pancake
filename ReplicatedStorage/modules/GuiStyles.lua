local wait = require(game.ReplicatedStorage.modules.wait)

local module = {}

module.currentFocus = nil

function module.applyStyles(component, style)
	-- Styles
	
	if style.background == "rebeccapurple" then
		style.background = Color3.fromRGB(102, 51, 153)
	end
	
	if style.color == "rebeccapurple" then
		style.color = Color3.fromRGB(102, 51, 153)
	end

	Instance.new("UICorner", component).CornerRadius = UDim.new(style.borderRadius or 0, 0)
	component.BackgroundColor3 = style.background or component.BackgroundColor3
	component.BackgroundTransparency = style.alpha or component.BackgroundTransparency
	component.Position = style.pos or component.Position
	component.Name = style.name or component.Name
	
	if style.sizeX and style.sizeY then
		component.Size = UDim2.new(style.sizeX , 0, style.sizeY, 0)
	end
	
	component.Visible = not style.hidden or not false
	
	if style.isFlex == true then
		local UiListLayout = Instance.new("UIListLayout", component)
		UiListLayout.HorizontalAlignment = Enum.HorizontalAlignment[style.alignX]
		UiListLayout.VerticalAlignment = Enum.VerticalAlignment[style.alignY]
		UiListLayout.SortOrder = Enum.SortOrder[style.flexOrder]
		UiListLayout.Padding = UDim.new(style.flexPadding or 0, 0)
	end
	
	if style.boxShadow == true then
		local frame = Instance.new("Frame", component.Parent)
		component.Parent = frame
		frame.Name = component.Name
		frame.Size = component.Size
		frame.Position = component.Position
		frame.BackgroundTransparency = 1
		component.Size = UDim2.new(1, 0, 1, 0)
		component.Position = UDim2.new(0, 0, 0, 0)
		
		local boxshadow = Instance.new("ImageLabel", frame)
		
		style.boxShadowStyle = style.boxShadowStyle or 1
		if style.boxShadowStyle == 1 then
			boxshadow.Image = "rbxassetid://6919135242"
			
			if frame.Size.Y.Scale > 0.15 then
				boxshadow.Size = component.Size + UDim2.new(0.3, 0, 0.4, 0)
				boxshadow.ImageTransparency = style.boxShadowAlpha or 0
			else -- normal box shadow doesn't look good with objects that are too small
				boxshadow.Size = component.Size + UDim2.new(0.4, 0, 0.5, 0)
				boxshadow.ImageTransparency = style.boxShadowAlpha or 0.5
			end

			boxshadow.Position = component.Position + UDim2.new(-0.2, 0, -0.2, 0)
		else
			boxshadow.Image = "rbxassetid://6916236943"
			
			if frame.Size.Y.Scale > 0.15 then
				boxshadow.Size = component.Size + UDim2.new(0.2, 0, 0.2, 0)
				boxshadow.ImageTransparency = style.boxShadowAlpha or 0
			else -- normal box shadow doesn't look good with objects that are too small
				boxshadow.Size = component.Size + UDim2.new(0.2, 0, 0.3, 0)
				boxshadow.ImageTransparency = style.boxShadowAlpha or 0.65
			end

			boxshadow.Position = component.Position + UDim2.new(-0.1, 0, -0.1, 0)
		end
		
		boxshadow.Name = "BoxShadow"
		boxshadow.BackgroundTransparency = 1
		component.ZIndex = component.ZIndex + 1
		boxshadow.ZIndex = component.ZIndex - 1
		frame.ZIndex = component.ZIndex
	end
		
	-- Events

	component.MouseEnter:Connect(function()
		module.currentFocus = component
		
		if module.currentFocus == nil then module.applyStyles(component, style) return end
		
		wait(0.09)
		if style.onhover then
			style.onhover()
		end
	end)
	
	component.MouseLeave:Connect(function()
		if module.currentFocus == nil then module.applyStyles(component, style) return end
		
		if style.onunhover then
			style.onunhover()
		end
		
		wait(0.09)
		module.currentFocus = nil
	end)
	
	if component:IsA("TextButton") then
		component.MouseButton1Click:Connect(style.active or function() end)
		component.AutoButtonColor = style.autoColor
	end
	
	style.fontFamily = style.fontFamily or "SourceSans"
	if component:IsA("TextLabel") or component:IsA("TextButton") then
		component.RichText = style.rich or component.RichText
		component.Text = style.content or component.Text
		component.TextScaled = style.scaledText or component.TextScaled
		component.TextColor3 = style.color or component.TextColor3
		component.Font = Enum.Font[style.fontFamily]
	end
	
	if style.run then
		coroutine.wrap(style.run)(Instance.new("LocalScript", component))
	end
end

function module.render(container, styles)	
	for _,component in pairs(container:GetDescendants()) do
		if component:IsA("Frame") or component:IsA("TextButton") or component:IsA("TextLabel") then
			local style = styles[component:GetAttribute("class")]

			if style then
				module.applyStyles(component, style)
			end
		end
	end
end

function module.getElementsByClassName(container, className)
	local elements = {}
	
	for _,component in pairs(container:GetDescendants()) do
		if component:GetAttribute("class") == className then
			table.insert(elements, 0, component)
		end
	end
	
	return elements
end

function module.style(styles, style, new)
	styles[style] = new
end

return module
