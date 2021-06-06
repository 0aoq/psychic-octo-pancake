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
		
	-- Events

	component.MouseEnter:Connect(style.onhover or function() end)
	component.MouseLeave:Connect(style.onunhover or function() end)

	if component:IsA("TextButton") then
		component.MouseButton1Click:Connect(style.active or function() end)
	end

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
