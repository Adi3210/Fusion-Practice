--[[
	A simple backplate component.
	
	Props:
		Optional:
		- Position: UDim2
		- AnchorPoint: Vector2
		- Size: UDim2
		- [Children]
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Fusion)
local New = Fusion.New
local Children = Fusion.Children

local function Backplate(props)
	return New "Frame" {
		Position = props.Position,
		AnchorPoint = props.AnchorPoint,
		Size = props.Size,
		
		BackgroundColor3 = Color3.new(0, 0, 0),
		BackgroundTransparency = 0.25,
		
		[Children] = {
			New "UICorner" {
				CornerRadius = UDim.new(0, 8)
			},
			
			New "UIPadding" {
				PaddingBottom = UDim.new(0, 8),
				PaddingLeft = UDim.new(0, 8),
				PaddingRight = UDim.new(0, 8),
				PaddingTop = UDim.new(0, 8)
			},
			
			props[Children]
		}
	}
end

return Backplate