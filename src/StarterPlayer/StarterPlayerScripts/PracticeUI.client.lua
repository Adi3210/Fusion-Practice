------------Services--------------
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

------------Dependencies--------------
local Packages = ReplicatedStorage:WaitForChild("Packages")
local LocalPlayer = Players.LocalPlayer

------------Constants--------------
local Fusion = require(Packages.fusion)
local New, Computed, Value, Children, OnEvent, Tween =
	Fusion.New, Fusion.Computed, Fusion.Value, Fusion.Children, Fusion.OnEvent, Fusion.Tween

------------Function-------------
local function Button(props: { Text: string, Position: UDim2, TiltDirection: number })
	local isHover = Value(false)

	local hoverOffset = Tween(
		Computed(function()
			return isHover:get() and UDim2.new(0, 0, 0, -60) or UDim2.new(0, 0, 0, 0)
		end),
		TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	)

	local tilt = Tween(
		Computed(function()
			return isHover:get() and 10 * props.TiltDirection or 0
		end),
		TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	)

	local hoverArea = New("Frame")({
		Name = "HoverArea",
		Size = UDim2.new(0, 200, 0, 110),
		Position = UDim2.new(0, 0, 0, 5),
		BackgroundTransparency = 1,

		[OnEvent("MouseEnter")] = function()
			print("MouseEnter")
			isHover:set(true)
		end,

		[OnEvent("MouseLeave")] = function()
			print("MouseLeave")
			isHover:set(false)
		end,
	})

	return New("Frame")({
		Name = props.Text,
		Size = UDim2.new(0, 200, 0, 110),
		Position = props.Position,
		BackgroundTransparency = 1,

		[Children] = {
			New("TextButton")({
				Name = props.Text,
				BackgroundColor3 = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255)),
				Size = UDim2.new(0, 200, 0, 50),
				Font = Enum.Font.FredokaOne,
				Text = props.Text,
				Position = Computed(function()
					return UDim2.new(0, 0, 0, 60) + hoverOffset:get()
				end),
				Rotation = Computed(function()
					return tilt:get()
				end),
				TextColor3 = Color3.fromRGB(0, 0, 0),
				TextSize = 14.000,
				TextScaled = true,
				[Children] = {
					New("UICorner")({
						CornerRadius = UDim.new(0, 5),
					}),
				},
			}),
			hoverArea,
		},
	})
end
local ScreenGui = New("ScreenGui")({
	Name = "PracticeUI",
	ResetOnSpawn = false,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	DisplayOrder = 1,
	Parent = LocalPlayer.PlayerGui,

	[Children] = {
		LeftButton = Button({ Text = "Left", Position = UDim2.new(0.2, -100, 0.8, 0), TiltDirection = -1 }),
		RightButton = Button({ Text = "Right", Position = UDim2.new(0.6, 100, 0.8, 0), TiltDirection = 1 }),
		MiddleButton = Button({ Text = "Middle", Position = UDim2.new(0.4, 0, 0.8, 0), TiltDirection = 0 }),
	},
})
