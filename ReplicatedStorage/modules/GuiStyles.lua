local wait = require(game.ReplicatedStorage.modules.wait)

local module = {}

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

	if style.sizeX and style.sizeY then -- set size
		component.Size = UDim2.new(style.sizeX , 0, style.sizeY, 0)
	end

	component.Visible = not style.hidden or not false

	-- @param {boolean} Set if the display is flex, and align items accordingly
	if style.isFlex == true then
		local UiListLayout = Instance.new("UIListLayout", component)
		UiListLayout.HorizontalAlignment = Enum.HorizontalAlignment[style.alignX]
		UiListLayout.VerticalAlignment = Enum.VerticalAlignment[style.alignY]
		UiListLayout.SortOrder = Enum.SortOrder[style.flexOrder]
		UiListLayout.Padding = UDim.new(style.flexPadding or 0, 0)
	end

	-- @param {boolean} Apply a CSS box shadow to a gui object
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

	-- @this Handle button specific properties
	if component:IsA("TextButton") then
		component.MouseButton1Click:Connect(style.active or function() end)
		component.AutoButtonColor = style.autoColor
	end

	-- @this Handle text related properties
	style.fontFamily = style.fontFamily or "SourceSans"
	if component:IsA("TextLabel") or component:IsA("TextButton") then
		component.RichText = style.rich or component.RichText
		component.Text = style.content or component.Text
		component.TextScaled = style.scaledText or component.TextScaled
		component.TextColor3 = style.color or component.TextColor3
		component.Font = Enum.Font[style.fontFamily]
	end

	-- Events

	if style.onhover then
		component.MouseEnter:Connect(function()
			coroutine.wrap(style.onhover)(component)
		end)
	end

	if style.onunhover then
		component.MouseLeave:Connect(function()
			coroutine.wrap(style.onunhover)(component)
		end)
	end

	if style.active then
		if component:IsA("TextButton") then
			component.MouseButton1Click:Connect(function()
				coroutine.wrap(style.active)(component, style)
			end)
		end
	end

	if style.run then
		coroutine.wrap(style.run)(Instance.new("LocalScript", component), component)
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

-- @function Returns a table of all elements that match a className
function module.getElementsByClassName(container, className)
	local elements = {}

	for _,component in pairs(container:GetDescendants()) do
		if component:GetAttribute("class") == className then
			table.insert(elements, 0, component)
		end
	end

	return elements
end

-- @function @deprecated Apply a new style to the stylesheet ! Use nthChild or getElementsByClassName instead.
function module.style(styles, style, new)
	styles[style] = new
end

-- @function Get the element that is the specific number in the list
function module.nthChild(container, className, x, style)
	for i,v in pairs(module.getElementsByClassName(container, className)) do
		if i == x then
			module.applyStyles(v, style)
			v:SetAttribute("class", v:GetAttribute("class") .. i)
		end
	end
end

return module
