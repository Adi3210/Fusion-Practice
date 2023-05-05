local Players = game:GetService("Players")

----------------------------------------
-- Initialise player data when they join

local function onPlayerJoin(player)
	player:SetAttribute("Checkpoint", 0)
	player.RespawnLocation = workspace.StartSpawn
end
for _, player in pairs(Players:GetPlayers()) do
	onPlayerJoin(player)
end
Players.PlayerAdded:Connect(onPlayerJoin)

---------------------------------------
-- Initialise checkpoints functionality

local function initCheckpoint(checkpoint)
	local checkpointNumber = tonumber(checkpoint.Name)
	
	checkpoint.Touched:Connect(function(otherPart)
		-- find the player who touched the checkpoint (if any)
		local touchedPlayer = nil
		for _, player in pairs(Players:GetPlayers()) do
			if player.Character ~= nil and player.Character:IsAncestorOf(otherPart) then
				touchedPlayer = player
				break
			end
		end
		
		if touchedPlayer == nil then
			-- touching part didn't belong to a player
			return
		end
		
		if touchedPlayer:GetAttribute("Checkpoint") ~= checkpointNumber - 1 then
			-- players must touch the previous checkpoint first
			return
		end
		
		touchedPlayer:SetAttribute("Checkpoint", checkpointNumber)
		touchedPlayer.RespawnLocation = checkpoint
	end)
end

for _, checkpoint in pairs(workspace.Checkpoints:GetChildren()) do
	initCheckpoint(checkpoint)
end