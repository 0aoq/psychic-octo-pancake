local module = require(game.ReplicatedStorage.modules.GuiStyles)
local Tween = require(game.ReplicatedStorage.modules.Tween)

local styles = {
	contextMenu = {
		background = Color3.fromRGB(15, 15, 15),
		borderRadius = 0.05,
		boxShadow = true,
		boxShadowStyle = 2,
		
		isFlex = true,
		alignX = "Center",
		alignY = "Center",
		flexOrder = "Name",
		flexPadding = 0.05,
	},
	
	context_options = {},
	
	context_option = {
		background = Color3.fromRGB(25, 25, 25),
		borderRadius = 0.2,
		
		onhover = function(self)
			pcall(function()
				Tween(
					self,
					{
						length = 0.2
					},
					{
						BackgroundColor3 = Color3.fromRGB(78, 34, 255)
					}
				)
			end)
		end,
		
		onunhover = function(self)
			pcall(function()
				Tween(
					self,
					{
						length = 0.2
					},
					{
						BackgroundColor3 = Color3.fromRGB(25, 25, 25)
					}
				)
			end)
		end,
		
		active = function(self)
			pcall(function()
				print("Clicked option: " .. self.TextLabel.Text)
			end)
		end,
	},
	
	context_option__text = {
		color = Color3.fromRGB(255, 255, 255),
		font = "Ubuntu"
	}
}

module.render(script.Parent, styles)

-- function

local Player = game:GetService("Players").LocalPlayer
local Mouse = Player:GetMouse()
local UserInputService = game:GetService("UserInputService")

local contextDebounce = false

UserInputService.InputEnded:Connect(function(input)
	if not contextDebounce then
		script.Parent.Frame.Visible = false
	end
end)

Mouse.Button2Down:Connect(function()
	script.Parent.Frame.Visible = true
	script.Parent.Frame.Position = UDim2.new(0, Mouse.X, 0, Mouse.Y)
	contextDebounce = true
	
	wait(0.1)
	contextDebounce = false
end)
