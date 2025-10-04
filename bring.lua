-- Gui to Lua
-- Version: 3.2 - BRING TO TARGET PLAYER - INFINITE RANGE

-- Instances:

local Gui = Instance.new("ScreenGui")
local Main = Instance.new("Frame")
local Box = Instance.new("TextBox")
local UITextSizeConstraint = Instance.new("UITextSizeConstraint")
local Label = Instance.new("TextLabel")
local UITextSizeConstraint_2 = Instance.new("UITextSizeConstraint")
local Button = Instance.new("TextButton")
local UITextSizeConstraint_3 = Instance.new("UITextSizeConstraint")

--Properties:

Gui.Name = "Gui"
Gui.Parent = gethui()
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Main.Name = "Main"
Main.Parent = Gui
Main.BackgroundColor3 = Color3.fromRGB(75, 75, 75)
Main.BorderColor3 = Color3.fromRGB(0, 0, 0)
Main.BorderSizePixel = 0
Main.Position = UDim2.new(0.335954279, 0, 0.542361975, 0)
Main.Size = UDim2.new(0.240350261, 0, 0.166880623, 0)
Main.Active = true
Main.Draggable = true

-- Box
Box.Name = "Box"
Box.Parent = Main
Box.BackgroundColor3 = Color3.fromRGB(95, 95, 95)
Box.BackgroundTransparency = 0.5
Box.BorderColor3 = Color3.fromRGB(0, 0, 0)
Box.BorderSizePixel = 0
Box.Position = UDim2.new(0.0980926454, 0, 0.218712583, 0)
Box.Size = UDim2.new(0.801089942, 0, 0.364963502, 0)
Box.FontFace = Font.new("rbxasset://fonts/families/SourceSansSemibold.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
Box.PlaceholderText = "Target Player"
Box.Text = ""
Box.TextColor3 = Color3.fromRGB(255, 255, 255)
Box.TextScaled = true
Box.TextSize = 31.000
Box.TextWrapped = true

-- Label
Label.Name = "Label"
Label.Parent = Main
Label.BackgroundColor3 = Color3.fromRGB(95, 95, 95)
Label.BackgroundTransparency = 0.5
Label.BorderColor3 = Color3.fromRGB(0, 0, 0)
Label.BorderSizePixel = 0
Label.Size = UDim2.new(1, 0, 0.160583943, 0)
Label.FontFace = Font.new("rbxasset://fonts/families/Nunito.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
Label.Text = "Bring Parts TO TARGET [∞ RANGE]"
Label.TextColor3 = Color3.fromRGB(255, 255, 255)
Label.TextScaled = true
Label.TextSize = 14.000
Label.TextWrapped = true

-- Button
Button.Name = "Button"
Button.Parent = Main
Button.BackgroundColor3 = Color3.fromRGB(95, 95, 95)
Button.BackgroundTransparency = 0.5
Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
Button.BorderSizePixel = 0
Button.Position = UDim2.new(0.183284417, 0, 0.656760991, 0)
Button.Size = UDim2.new(0.629427791, 0, 0.277372271, 0)
Button.Font = Enum.Font.Nunito
Button.Text = "Bring To Target | Off"
Button.TextColor3 = Color3.fromRGB(255, 255, 255)
Button.TextScaled = true
Button.TextSize = 28.000
Button.TextWrapped = true

UITextSizeConstraint_3.Parent = Button
UITextSizeConstraint_3.MaxTextSize = 28

-- Scripts:

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local targetCharacter
local targetHumanoidRootPart
local targetPlayer

mainStatus = true
UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
	if input.KeyCode == Enum.KeyCode.RightControl and not gameProcessedEvent then
		mainStatus = not mainStatus
		Main.Visible = mainStatus
	end
end)

local Folder = Instance.new("Folder", Workspace)
local Part = Instance.new("Part", Folder)
local Attachment1 = Instance.new("Attachment", Part)
Part.Anchored = true
Part.CanCollide = false
Part.Transparency = 1
Part.Size = Vector3.new(0.1, 0.1, 0.1)

-- STORAGE UNTUK PARTS YANG SUDAH DIMODIFIKASI
local ModifiedParts = {}

-- EXTREME NETWORK SETTINGS - INFINITE RANGE
if not getgenv().Network then
	getgenv().Network = {
		BaseParts = {},
		Velocity = Vector3.new(14462.62424, 14462.62424, 14462.62424),
		SimulationRadius = math.huge * 9e9
	}

	Network.RetainPart = function(Part)
		if Part:IsA("BasePart") and Part:IsDescendantOf(Workspace) then
			table.insert(Network.BaseParts, Part)
			Part.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0, 0, 0)
			Part.CanCollide = false
		end
	end

	local function EnablePartControl()
		LocalPlayer.ReplicationFocus = Workspace
		RunService.Heartbeat:Connect(function()
			sethiddenproperty(LocalPlayer, "SimulationRadius", math.huge * 9e9)
			sethiddenproperty(LocalPlayer, "MaxSimulationRadius", math.huge * 9e9)
			
			for _, Part in pairs(Network.BaseParts) do
				if Part:IsDescendantOf(Workspace) then
					Part.Velocity = Network.Velocity
				end
			end
		end)
	end

	EnablePartControl()
end

-- FUNGSI FORCE PART - BRING TO TARGET PLAYER
local function ForcePart(v)
	if v:IsA("BasePart") 
		and not v.Anchored
		and not v.Parent:FindFirstChildOfClass("Humanoid") 
		and not v.Parent:FindFirstChild("Head") 
		and v.Name ~= "Handle" then
		
		-- CEK APAKAH PART SUDAH PERNAH DIMODIFIKASI
		if ModifiedParts[v] then
			local data = ModifiedParts[v]
			if data.AlignPosition then
				data.AlignPosition.Enabled = true
			end
			if data.Torque then
				data.Torque.Enabled = true
			end
			-- BOOST VELOCITY MENUJU TARGET PLAYER
			if targetHumanoidRootPart then
				local direction = (targetHumanoidRootPart.Position - v.Position).Unit
				v.Velocity = direction * 50000
			end
			return
		end
		
		-- INSTANT SETUP - EXTREME POWER
		v.CanCollide = false
		v.Massless = true
		v.CustomPhysicalProperties = PhysicalProperties.new(0.001, 0, 0, 0, 0)
		
		-- TORQUE EXTREME
		local Torque = v:FindFirstChild("ExtremeTorque")
		if not Torque then
			Torque = Instance.new("Torque")
			Torque.Name = "ExtremeTorque"
			Torque.Torque = Vector3.new(100000000, 100000000, 100000000)
			Torque.Parent = v
		end
		
		local Attachment2 = v:FindFirstChild("ExtremeAttachment")
		if not Attachment2 then
			Attachment2 = Instance.new("Attachment")
			Attachment2.Name = "ExtremeAttachment"
			Attachment2.Parent = v
		end
		
		-- ALIGN POSITION - MENUJU TARGET PLAYER
		local AlignPosition = v:FindFirstChild("ExtremeAlign")
		if not AlignPosition then
			AlignPosition = Instance.new("AlignPosition")
			AlignPosition.Name = "ExtremeAlign"
			
			AlignPosition.MaxForce = math.huge * 9e9
			AlignPosition.MaxVelocity = math.huge
			AlignPosition.Responsiveness = 200000
			AlignPosition.ApplyAtCenterOfMass = true
			AlignPosition.ReactionForceEnabled = false
			AlignPosition.RigidityEnabled = true
			
			AlignPosition.Attachment0 = Attachment2
			AlignPosition.Attachment1 = Attachment1 -- Mengarah ke target player
			AlignPosition.Parent = v
		else
			AlignPosition.MaxForce = math.huge * 9e9
			AlignPosition.Responsiveness = 200000
			AlignPosition.Attachment1 = Attachment1
		end
		
		Torque.Attachment0 = Attachment2
		
		-- BOOST INITIAL VELOCITY MENUJU TARGET PLAYER
		if targetHumanoidRootPart then
			local direction = (targetHumanoidRootPart.Position - v.Position).Unit
			v.Velocity = direction * 50000
			v.AssemblyLinearVelocity = direction * 50000
		end
		
		ModifiedParts[v] = {
			AlignPosition = AlignPosition,
			Torque = Torque,
			Attachment = Attachment2
		}
	end
end

local blackHoleActive = false
local DescendantAddedConnection
local UpdateConnection
local VelocityBoostConnection

-- INSTANT TOGGLE - BRING TO TARGET
local function toggleBlackHole()
	blackHoleActive = not blackHoleActive
	if blackHoleActive then
		Button.Text = "Bring To " .. targetPlayer.Name .. " | On"
		
		-- INSTANT SCAN
		local descendants = Workspace:GetDescendants()
		for i = 1, #descendants do
			ForcePart(descendants[i])
		end

		-- INSTANT MONITORING
		DescendantAddedConnection = Workspace.DescendantAdded:Connect(ForcePart)

		-- UPDATE POSISI TARGET PLAYER SETIAP FRAME
		UpdateConnection = RunService.Heartbeat:Connect(function()
			if targetHumanoidRootPart and targetHumanoidRootPart.Parent then
				local cf = targetHumanoidRootPart.CFrame
				Attachment1.WorldCFrame = cf
				Part.CFrame = cf
			else
				-- AUTO-DETECT JIKA TARGET RESPAWN
				if targetPlayer and targetPlayer.Character then
					targetCharacter = targetPlayer.Character
					targetHumanoidRootPart = targetCharacter:FindFirstChild("HumanoidRootPart")
				end
			end
		end)
		
		-- VELOCITY BOOST MENUJU TARGET PLAYER
		VelocityBoostConnection = RunService.Heartbeat:Connect(function()
			if targetHumanoidRootPart and targetHumanoidRootPart.Parent then
				for part, data in pairs(ModifiedParts) do
					if part:IsDescendantOf(Workspace) and data.AlignPosition.Enabled then
						-- HITUNG JARAK KE TARGET PLAYER
						local distance = (targetHumanoidRootPart.Position - part.Position).Magnitude
						
						-- BOOST LEBIH KUAT UNTUK JARAK LEBIH JAUH
						if distance > 100 then
							local direction = (targetHumanoidRootPart.Position - part.Position).Unit
							local boostMultiplier = math.min(distance / 10, 10000)
							part.Velocity = direction * (50000 * boostMultiplier)
							part.AssemblyLinearVelocity = direction * (50000 * boostMultiplier)
							
							-- ADAPTIVE RESPONSIVENESS
							if distance > 1000 then
								data.AlignPosition.Responsiveness = 500000
							elseif distance > 500 then
								data.AlignPosition.Responsiveness = 300000
							else
								data.AlignPosition.Responsiveness = 200000
							end
						end
					end
				end
			end
		end)
		
	else
		Button.Text = "Bring To Target | Off"
		
		-- INSTANT DISABLE
		for part, data in pairs(ModifiedParts) do
			if data.AlignPosition then
				data.AlignPosition.Enabled = false
			end
			if data.Torque then
				data.Torque.Enabled = false
			end
		end
		
		if DescendantAddedConnection then
			DescendantAddedConnection:Disconnect()
		end
		if UpdateConnection then
			UpdateConnection:Disconnect()
		end
		if VelocityBoostConnection then
			VelocityBoostConnection:Disconnect()
		end
	end
end

-- INSTANT PLAYER SEARCH
local function getPlayer(name)
	local lowerName = string.lower(name)
	local players = Players:GetPlayers()
	for i = 1, #players do
		local p = players[i]
		if string.find(string.lower(p.Name), lowerName) or string.find(string.lower(p.DisplayName), lowerName) then
			return p
		end
	end
end

-- INSTANT PLAYER SELECTION
local function VDOYZQL_fake_script()
	local script = Instance.new('Script', Box)

	script.Parent.FocusLost:Connect(function(enterPressed)
		if enterPressed then
			targetPlayer = getPlayer(Box.Text)
			if targetPlayer then
				Box.Text = targetPlayer.Name
				print("Target Player:", targetPlayer.Name)
			else
				print("Player not found")
			end
		end
	end)
end
coroutine.wrap(VDOYZQL_fake_script)()

-- INSTANT ACTIVATION - BRING TO TARGET
local function JUBNQKI_fake_script()
	local script = Instance.new('Script', Button)

	script.Parent.MouseButton1Click:Connect(function()
		if targetPlayer then
			targetCharacter = targetPlayer.Character
			if targetCharacter then
				targetHumanoidRootPart = targetCharacter:FindFirstChild("HumanoidRootPart")
				if targetHumanoidRootPart then
					toggleBlackHole()
				else
					print("Target HumanoidRootPart not found")
				end
			else
				-- AUTO-CONNECT KETIKA TARGET CHARACTER MUNCUL
				local conn
				conn = targetPlayer.CharacterAdded:Connect(function(char)
					targetCharacter = char
					targetHumanoidRootPart = targetCharacter:FindFirstChild("HumanoidRootPart")
					if targetHumanoidRootPart and not blackHoleActive then
						toggleBlackHole()
					end
					conn:Disconnect()
				end)
				print("Waiting for target character...")
			end
		else
			print("Please select a target player first")
		end
	end)
end
coroutine.wrap(JUBNQKI_fake_script)()

-- AUTO-UPDATE TARGET HUMANOIDROOTPART + SIMULATION RADIUS
RunService.Heartbeat:Connect(function()
	-- UPDATE TARGET PLAYER POSITION
	if targetPlayer and targetPlayer.Character and not targetHumanoidRootPart then
		targetCharacter = targetPlayer.Character
		targetHumanoidRootPart = targetCharacter:FindFirstChild("HumanoidRootPart")
	end
	
	-- CEK JIKA TARGET RESPAWN
	if targetHumanoidRootPart and not targetHumanoidRootPart.Parent then
		if targetPlayer and targetPlayer.Character then
			targetCharacter = targetPlayer.Character
			targetHumanoidRootPart = targetCharacter:FindFirstChild("HumanoidRootPart")
		end
	end
	
	-- FORCE INFINITE SIMULATION RADIUS
	sethiddenproperty(LocalPlayer, "SimulationRadius", math.huge * 9e9)
end)

-- MONITOR TARGET PLAYER DISCONNECT
Players.PlayerRemoving:Connect(function(player)
	if player == targetPlayer then
		if blackHoleActive then
			toggleBlackHole() -- Auto-disable jika target disconnect
		end
		print("Target player left the game")
		Box.Text = ""
		targetPlayer = nil
		targetCharacter = nil
		targetHumanoidRootPart = nil
	end
end)
