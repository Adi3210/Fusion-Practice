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

local LeftScreen = require(script.Parent:WaitForChild("LeftScreen"))
local MiddleScreen = require(script.Parent:WaitForChild("MiddleScreen"))
local RightScreen = require(script.Parent:WaitForChild("RightScreen"))

local CurrentGUI = Value("None") -- This is a state for the currently opened GUI

local function UpdateGUIState(GUIName: string)
	if CurrentGUI:get() == GUIName then
		CurrentGUI:set("None")
	else
		CurrentGUI:set(GUIName)
	end
end

------------Function-------------
----**Button function creates a button with hover and click functionality**----
local function Button(props: { Text: string, Position: UDim2, TiltDirection: number })
	local isHover = Value(false) -- This is a state if they are hovering or not

	-----Calculate Hover offset based on hover state-----
	local HoverOffset = Computed(function()
		return UDim2.new(0, 0, 0, 60) + (isHover:get() and UDim2.new(0, 0, 0, -60) or UDim2.new(0, 0, 0, 0))
	end)

	-----Calculate Tilt based on hover state----
	local Tilt = Computed(function()
		return isHover:get() and 10 * props.TiltDirection or 0
	end)

	----Create a Hover Area Frame with MouseEnter and MouseLeave events----
	local HoverArea = New("Frame")({
		Name = "HoverArea",
		Size = UDim2.new(0, 200, 0, 110),
		Position = UDim2.new(0, 0, 0, 5),
		BackgroundTransparency = 1,

		[OnEvent("MouseEnter")] = function() ---When the mouse enters the frame
			isHover:set(true)
		end,

		[OnEvent("MouseLeave")] = function() ---When the mouse leaves the frame
			isHover:set(false)
		end,
	})

	----Handle button click event function----
	local function HandleButtonClick(propsText, GuiName)
		UpdateGUIState(GuiName) -- Update the GUI state

		-- Create a single Computed function for isClicked
		local isClicked = Computed(function()
			return CurrentGUI:get() == GuiName
		end)

		-- Map the propsText to their respective screen functions
		local ScreenFunctionMap = {
			Left = LeftScreen,
			Middle = MiddleScreen,
			Right = RightScreen,
		}

		-- Call the corresponding screen function based on the propsText
		local ScreenFunction = ScreenFunctionMap[propsText]
		if ScreenFunction then
			ScreenFunction({
				Name = GuiName,
				isClicked = isClicked,
				CurrentGUI = CurrentGUI,
			})
		end
	end

	----Return a frame containing the Button and Hover Area------
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
				Position = Tween(HoverOffset, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)),
				Rotation = Tween(Tilt, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)),
				TextColor3 = Color3.fromRGB(0, 0, 0),
				TextSize = 14.000,
				TextScaled = true,
				[Children] = {
					New("UICorner")({
						CornerRadius = UDim.new(0, 5),
					}),
				},

				----Handle button click event----
				[OnEvent("MouseButton1Click")] = function()
					local GuiName = props.Text .. "Gui"
					HandleButtonClick(props.Text, GuiName)
				end,
			}),
			HoverArea,
		},
	})
end

---------Make a ScreenGui with 3 buttons---------
local ScreenGui = New("ScreenGui")({
	Name = "MainGui",
	ResetOnSpawn = false,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	DisplayOrder = 1,
	Parent = LocalPlayer:WaitForChild("PlayerGui"),

	[Children] = {
		LeftButton = Button({ Text = "Left", Position = UDim2.new(0.2, -100, 0.8, 0), TiltDirection = -1 }),
		RightButton = Button({ Text = "Right", Position = UDim2.new(0.6, 100, 0.8, 0), TiltDirection = 1 }),
		MiddleButton = Button({ Text = "Middle", Position = UDim2.new(0.4, 0, 0.8, 0), TiltDirection = 0 }),
	},
})
