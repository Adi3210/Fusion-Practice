local Players = game:GetService("Players")
local PlayerScripts = game:GetService("StarterPlayer").StarterPlayerScripts
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Fusion)
local New = Fusion.New
local Children = Fusion.Children
local Value = Fusion.Value

local CheckpointUI = require(PlayerScripts.CheckpointUI)
local Confetti = require(PlayerScripts.Confetti)

-------------------------------
-- Sync up Checkpoint attribute

local checkpointReached = New "BindableEvent" {}

local currentCheckpoint = Value(Players.LocalPlayer:GetAttribute("Checkpoint"))
Players.LocalPlayer:GetAttributeChangedSignal("Checkpoint"):Connect(function()
	currentCheckpoint:set(Players.LocalPlayer:GetAttribute("Checkpoint"))
	checkpointReached:Fire()
end)

----------------
-- Build main UI

New "ScreenGui" {
	Parent = Players.LocalPlayer:FindFirstChildOfClass("PlayerGui"),
	IgnoreGuiInset = true,
	
	[Children] = {
		CheckpointUI {
			Value = currentCheckpoint	
		},
		
		Confetti {
			Event = checkpointReached.Event
		}
	}
}