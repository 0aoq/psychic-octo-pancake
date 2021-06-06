local module = {}

function module.applyStyles(component, style)
	-- Styles

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
		boxshadow.Image = "rbxassetid://6918788732"
		
		if frame.Size.Y.Scale > 0.1 then
			boxshadow.Size = component.Size + UDim2.new(0.3, 0, 0.4, 0)
			boxshadow.ImageTransparency = style.boxShadowAlpha or 0
		else -- normal box shadow doesn't look good with objects that are too small
			boxshadow.Size = component.Size + UDim2.new(0.4, 0, 0.5, 0)
			boxshadow.ImageTransparency = style.boxShadowAlpha or 0.5
		end
		
		boxshadow.Position = component.Position + UDim2.new(-0.2, 0, -0.2, 0)
		
		boxshadow.Name = "BoxShadow"
		boxshadow.BackgroundTransparency = 1
		boxshadow.ZIndex = 1
		component.ZIndex = 2
	end
		
	-- Events

	component.MouseEnter:Connect(style.onhover or function() end)
	component.MouseLeave:Connect(style.onunhover or function() end)
	
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

function module.getElementByClassName(container, className)
	for _,component in pairs(container:GetDescendants()) do
		if component:GetAttribute("class") == className then
			return component
		end
	end
end

function module.style(styles, style, new)
	styles[style] = new
end

return module
