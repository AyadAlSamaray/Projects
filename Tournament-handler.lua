local module = {}

module.RegisteredPlayers = {} -- Players who are registered for the tournament
module.Participants = {} -- Players who are currently participating in the tournament
module.FightingPlayers = {} -- Players who are currently in a fight
local PlayerDataHandler = require(game.ServerScriptService.PlayerData:WaitForChild("PlayerDataHandler"))

function module.Enter(player)
	table.insert(module.RegisteredPlayers, player)
	print(player.Name .. " has been added")
end

function module.Exit(player)
	for i, p in ipairs(module.RegisteredPlayers) do
		if p == player then
			table.remove(module.RegisteredPlayers, i)
			print(player.Name .. " has been removed")
			break
		end
	end
end

--local loop

--loop = task.defer(function()
--	local dots = 0

--	while #module.RegisteredPlayers <= 6 do
--		task.wait()
--		if game.Workspace.Zones.Tournament:GetAttribute("Started") then
--			dots = dots + 1

--			if dots > 3 then
--				dots = 0
--			end

--			local waitingText = "Waiting" .. string.rep(".", dots)
--			game.Workspace.Zones.Tournament.BillboardGui.Wait.Text = waitingText

--			task.wait(1)
--		end
--	end
--end)

function module.StartTournament(player)
	if #module.RegisteredPlayers >= 4 then
		task.wait(1)
		if game.Workspace.Zones.Tournament:GetAttribute("EnoughPlayers") then return end
		local UI = game.Workspace.Zones.Tournament:WaitForChild("BillboardGui")
		local connection
		local connection2
		game.Workspace.Zones.Tournament.BillboardGui.Wait.Visible = false
		
		connection = task.defer(function()
			local timer = 300
			UI.TextLabel.Visible = true
			game.Workspace.Zones.Tournament:SetAttribute("EnoughPlayers", true)
			while timer > 0 do
				task.wait(1)
				timer -= 1
				UI.TextLabel.Text = timer
			end

			if timer == 0 and #module.RegisteredPlayers >= 2 then
				task.cancel(connection2)
				print("Timer reached 0. Starting tournament.")
				game.Workspace.Zones.Tournament.CanQuery = false
				UI.TextLabel.Text = ""

				for i, v in pairs(game.Workspace.Tournament_Barriers:GetChildren()) do
					v.CanCollide = true
				end

				module.Participants = table.move(module.RegisteredPlayers, 1, #module.RegisteredPlayers, 1, module.Participants)
				module.RegisteredPlayers = {}
				print(module.Participants, module.RegisteredPlayers)
				local SpectatorArea = game.Workspace.Zones.Tournament.Spectate 

				if table.find(module.Participants, player) then
					local character = player.Character
					if character then
						character.HumanoidRootPart.CFrame = SpectatorArea.CFrame
					end
				end

				while #module.Participants >= 2 do
					local player1 = table.remove(module.Participants, 1)
					local player2 = table.remove(module.Participants, 1)

					print("Player 1: " .. player1.Name)
					print("Player 2: " .. player2.Name)

					local Fighter1 = game.Workspace.Zones.Tournament.Fighter1
					local Fighter2 = game.Workspace.Zones.Tournament.Fighter2

					table.insert(module.FightingPlayers, player1)
					table.insert(module.FightingPlayers, player2)

					game.Workspace.Alive[player1.Name].HumanoidRootPart.CFrame = Fighter1.CFrame
					game.Workspace.Alive[player2.Name].HumanoidRootPart.CFrame = Fighter2.CFrame

					game.Workspace.Alive[player1.Name].Humanoid.Health = 100 + (PlayerDataHandler:Get(game.Players[player1.Name], "Durability") * 2.75) -- might need to be changed based on if dura scaling does
					game.Workspace.Alive[player2.Name].Humanoid.Health = 100 + (PlayerDataHandler:Get(game.Players[player2.Name], "Durability") * 2.75) -- might need to be changed based on if dura scaling does
					game.Players[player1.Name].PlayerGui.HUD.Frame.Stamina.ActualStamina.Value = PlayerDataHandler:Get(game.Players[player1.Name], "Stamina") * 1.35 -- might need to be changed based on if stam scaling does
					game.Players[player2.Name].PlayerGui.HUD.Frame.Stamina.ActualStamina.Value = PlayerDataHandler:Get(game.Players[player2.Name], "Stamina") * 1.35


					while true do
						task.wait(1)
						if game.Workspace.Alive[player1.Name]:GetAttribute("Ragdolled") then
							game:GetService("CollectionService"):RemoveTag(game.Workspace.Alive[player1.Name], "Ragdoll")
							game.Workspace.Alive[player1.Name]:SetAttribute("Lost", true)
							for i, p in ipairs(module.Participants) do
								if p == player1 then
									table.remove(module.Participants, i)
									game.Workspace.Alive[player1.Name].HumanoidRootPart.CFrame = SpectatorArea.CFrame
									break
								end
							end
							for i, p in ipairs(module.FightingPlayers) do
								if p == player1 then
									table.remove(module.FightingPlayers, i)
									game.Workspace.Alive[player1.Name].HumanoidRootPart.CFrame = SpectatorArea.CFrame
									break
								end
							end
							break
						end
						if game.Workspace.Alive[player2.Name]:GetAttribute("Ragdolled")then
							game:GetService("CollectionService"):RemoveTag(game.Workspace.Alive[player2.Name], "Ragdoll")
							game.Workspace.Alive[player2.Name]:SetAttribute("Lost", true)
							print(player2.Name .. " lost.")
							for i, p in ipairs(module.Participants) do
								if p == player2 then
									table.remove(module.Participants, i)
									game.Workspace.Alive[player2.Name].HumanoidRootPart.CFrame = SpectatorArea.CFrame
									break
								end
							end
							for i, p in ipairs(module.FightingPlayers) do
								if p == player2 then
									table.remove(module.FightingPlayers, i)
									game.Workspace.Alive[player2.Name].HumanoidRootPart.CFrame = SpectatorArea.CFrame
									break
								end
							end
							break
						end
					end

					local winner

					if not game.Workspace.Alive[player1.Name]:GetAttribute("Lost") then
						winner = player1
					elseif not game.Workspace.Alive[player2.Name]:GetAttribute("Lost") then
						winner = player2
					end

					if winner then
						table.insert(module.Participants, winner)
						print("Winner: ", winner.Name)
						game.Workspace.Alive[winner.Name].HumanoidRootPart.CFrame = SpectatorArea.CFrame
					end


					--give tournament rewards, cash, stats, hair reroll, eye reroll
				end

				if #module.Participants == 1 then
					local overallWinner = module.Participants[1]
					print("The overall winner of the tournament is: " .. overallWinner.Name)
					for i, v in pairs(game.Workspace.Tournament_Barriers:GetChildren()) do
						v.CanCollide = false
					end
					for i, v in pairs(game.Workspace.Alive:GetChildren()) do
						v:SetAttribute("Lost", false)
					end
					local Effect = game.ReplicatedStorage.Remotes.Effect
					game.Players[overallWinner.Name].PlayerGui.Winner:Play()
					Effect:FireAllClients("Reward", game.Workspace.Alive[overallWinner.Name].HumanoidRootPart)
					local randomizedReward = math.random(1, 40)
					if randomizedReward < 40 then
						PlayerDataHandler:Add(game.Players[overallWinner.Name], "Cash", 500)
						PlayerDataHandler:Add(game.Players[overallWinner.Name], "Strength", 1)
						PlayerDataHandler:Add(game.Players[overallWinner.Name], "Durability", 1)
						PlayerDataHandler:Add(game.Players[overallWinner.Name], "Stamina", 0.5)
					elseif randomizedReward == 40 then
						local randomReroll = math.random(1, 2)
						if randomReroll == 1 then
							PlayerDataHandler:AddItem(game.Players[overallWinner.Name], "Inventory", "Hair Color Reroll")
						elseif randomReroll == 2 then
							PlayerDataHandler:AddItem(game.Players[overallWinner.Name], "Inventory", "Eye Color Reroll")
						end
					end
					game.Workspace.Zones.Tournament.CanQuery = false
					game.Workspace.Zones.Tournament.Ring.Parent = game.ServerStorage.MISC
					game.Workspace.Zones.Tournament.BillboardGui.TextLabel.Visible = false
					game.Workspace.Zones.Tournament:SetAttribute("EnoughPlayers", false)
					game.Workspace.Zones.Tournament:SetAttribute("Started", false)
				end

				module.FightingPlayers = {}
			else
				game.Workspace.Zones.Tournament.CanQuery = false
				game.Workspace.Zones.Tournament.Ring.Parent = game.ServerStorage.MISC
				game.Workspace.Zones.Tournament.BillboardGui.TextLabel.Visible = false
				game.Workspace.Zones.Tournament:SetAttribute("Started", false)
				game.Workspace.Zones.Tournament:SetAttribute("EnoughPlayers", false)
				for i, v in pairs(game.Workspace.Tournament_Barriers:GetChildren()) do
					v.CanCollide = false
				end
			end
		end)

		connection2 = task.defer(function()
			while true do
				task.wait(1)
				if #module.RegisteredPlayers < 1 then
					UI.TextLabel.Text = ""
					UI.TextLabel.Visible = false
					game.Workspace.Zones.Tournament:SetAttribute("Started", false)
					game.Workspace.Zones.Tournament:SetAttribute("EnoughPlayers", false)
					task.cancel(connection)
				end
			end
		end)
	end
end

return module
