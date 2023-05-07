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
------**Function to create the LeftScreen GUI**------
local function LeftScreen(props)
	if props.Name == nil or props.isClicked == nil then
		return
	end
	print(props.Name) -- This is a prop passed in from Main.client.lua

	if LocalPlayer.PlayerGui:FindFirstChild(props.Name) then
		return LocalPlayer.PlayerGui[props.Name]
	end

	local isClicked = props.isClicked --- This is to check if the button is clicked or not
	local CurrentGUI = props.CurrentGUI --- This is to check the state of the current GUI
	local isInitialLoad = Value(true) --- This is to check if the GUI is loaded for the first time or not

	------Calculate position based on the InitialLoad and isClicked state------
	local PositionGUI = Computed(function()
		if isInitialLoad:get() then --- If the GUI is loaded for the first time, then set the position to the left
			return UDim2.new(0.48, 0, -0.3, 6)
		else
			return isClicked:get() and UDim2.new(0.42, 0, 0.34, 6) or UDim2.new(0.48, 0, -0.3, 6)
		end
	end)

	------Calculate size based on the InitialLoad and isClicked state------
	local SizeGUI = Computed(function()
		if isInitialLoad:get() then --- If the GUI is loaded for the first time, then set the size to the left
			return UDim2.new(0.05, 0, 0.03, 0)
		else
			return isClicked:get() and UDim2.new(0, 200, 0, 104) or UDim2.new(0.05, 0, 0.03, 0)
		end
	end)

	------Return a screenGui containing the middlescreen frame and exit button------
	return New("ScreenGui")({

		Name = props.Name,
		ResetOnSpawn = false,
		Parent = LocalPlayer:WaitForChild("PlayerGui"),

		[Children] = New("Frame")({

			Name = "Frame",
			Position = Tween(PositionGUI, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)),
			Size = Tween(SizeGUI, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)),
			BackgroundColor3 = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255)),

			[Children] = {
				New("TextButton")({

					Name = "ExitButton",
					Text = "X",
					Position = UDim2.new(1, -20, 0, 0),
					Size = UDim2.new(0, 20, 0, 20),
					BackgroundColor3 = Color3.fromRGB(255, 0, 0),
					TextColor3 = Color3.fromRGB(255, 255, 255),
					Font = Enum.Font.SourceSansBold,
					TextSize = 14,

					[OnEvent("MouseButton1Click")] = function()
						print("ExitButton")
						CurrentGUI:set("None")
					end,
				}),
			},
		}),
	}),
		-- This is to set the GUI to the left when the GUI is loaded for the first time
		isInitialLoad:set(false)
end

return LeftScreen
