--[[
	The checkpoint counter that shows at the top of the screen.
	
	Props:
		Required:
		- Value: State<number>
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlayerScripts = game:GetService("StarterPlayer").StarterPlayerScripts

local Fusion = require(ReplicatedStorage.Fusion)
local New = Fusion.New
local Children = Fusion.Children

local Backplate = require(PlayerScripts.Backplate)
local NumberSpinner = require(PlayerScripts.NumberSpinner)

local function CheckpointUI(props)
	return Backplate {
		Position = UDim2.new(0.5, 0, 0, 8),
		Size = UDim2.fromOffset(200, 75),
		AnchorPoint = Vector2.new(.5, 0),
		
		[Children] = NumberSpinner {
			Size = UDim2.fromScale(1, 1),
			
			Value = props.Value,
			NumDigits = 3,
			
			Font = "Gotham",
			TextColor3 = Color3.new(1, 1, 1)
		}
	}
end

return CheckpointUI