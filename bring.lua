-- Gui to Lua
-- Version: 3.2 - Multiple Bring Methods

-- Instances:

local Gui = Instance.new("ScreenGui")
local Main = Instance.new("Frame")
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

-- Label
Label.Name = "Label"
Label.Parent = Main
Label.BackgroundColor3 = Color3.fromRGB(95, 95, 95)
Label.BackgroundTransparency = 0.5
Label.BorderColor3 = Color3.fromRGB(0, 0, 0)
Label.BorderSizePixel = 0
Label.Size = UDim2.new(1, 0, 0.35, 0)
Label.FontFace = Font.new("rbxasset://fonts/families/Nunito.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
Label.Text = "Bring All Players by FayintXHub"
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
Button.Position = UDim2.new(0.183284417, 0, 0.5, 0)
Button.Size = UDim2.new(0.629427791, 0, 0.4, 0)
Button.Font = Enum.Font.Nunito
Button.Text = "Bring Players | Off"
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

mainStatus = true
UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
	if input.KeyCode == Enum.KeyCode.RightControl and not gameProcessedEvent then
		mainStatus = not mainStatus
		Main.Visible = mainStatus
	end
end)

local Folder = Instance.new("Folder", Workspace)
Folder.Name = "BringFolder"
local Part = Instance.new("Part", Folder)
local Attachment1 = Instance.new("Attachment", Part)
Part.Anchored = true
Part.CanCollide = false
Part.Transparency = 1
Part.Size = Vector3.new(0.1, 0.1, 0.1)

if not getgenv().Network then
	getgenv().Network = {
		BaseParts = {},
		Velocity = Vector3.new(14.46262424, 14.46262424, 14.46262424)
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
			sethiddenproperty(LocalPlayer, "SimulationRadius", math.huge)
			for _, Part in pairs(Network.BaseParts) do
				if Part:IsDescendantOf(Workspace) then
					Part.Velocity = Network.Velocity
				end
			end
		end)
	end

	EnablePartControl()
end

local bringActive = false
local bringLoop = nil

local function ClearBringObjects(character)
	if not character then return end
	
	for _, part in ipairs(character:GetDescendants()) do
		if part:IsA("BasePart") then
			-- Remove all bring-related objects
			for _, child in ipairs(part:GetChildren()) do
				if child.Name:match("Bring") or child:IsA("BodyPosition") or 
				   child:IsA("BodyVelocity") or child:IsA("BodyGyro") or
				   child:IsA("AlignPosition") or child:IsA("AlignOrientation") or
				   child:IsA("Torque") or child:IsA("VectorForce") then
					child:Destroy()
				end
			end
		end
	end
end

local function ApplyMultipleBringMethods(character, targetCFrame)
	if not character then return end
	if character == LocalPlayer.Character then return end
	
	local hrp = character:FindFirstChild("HumanoidRootPart")
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	
	if not hrp then return end
	
	-- Clear existing objects first
	ClearBringObjects(character)
	
	-- METHOD 1: Network Ownership
	Network.RetainPart(hrp)
	
	-- Disable humanoid control
	if humanoid then
		humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, false)
		humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
		humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying, false)
		humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, false)
		humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp, false)
		humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, false)
		humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed, false)
		humanoid:SetStateEnabled(Enum.HumanoidStateType.Running, false)
		humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
		humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming, false)
		humanoid:ChangeState(11)
		humanoid.PlatformStand = true
	end
	
	-- Disable collisions
	for _, part in ipairs(character:GetDescendants()) do
		if part:IsA("BasePart") then
			part.CanCollide = false
			part.Massless = true
		end
	end
	
	hrp.CanCollide = false
	hrp.Massless = true
	
	-- METHOD 2: AlignPosition
	local Attachment2 = Instance.new("Attachment")
	Attachment2.Name = "BringAttachment"
	Attachment2.Parent = hrp
	
	local AlignPosition = Instance.new("AlignPosition")
	AlignPosition.Name = "BringAlign"
	AlignPosition.MaxForce = 9e9
	AlignPosition.MaxVelocity = 9e9
	AlignPosition.Responsiveness = 200
	AlignPosition.ApplyAtCenterOfMass = true
	AlignPosition.ReactionForceEnabled = false
	AlignPosition.RigidityEnabled = true
	AlignPosition.Attachment0 = Attachment2
	AlignPosition.Attachment1 = Attachment1
	AlignPosition.Parent = hrp
	
	-- METHOD 3: AlignOrientation
	local AlignOrientation = Instance.new("AlignOrientation")
	AlignOrientation.Name = "BringAlignOrientation"
	AlignOrientation.MaxTorque = 9e9
	AlignOrientation.MaxAngularVelocity = 9e9
	AlignOrientation.Responsiveness = 200
	AlignOrientation.RigidityEnabled = true
	AlignOrientation.Attachment0 = Attachment2
	AlignOrientation.Attachment1 = Attachment1
	AlignOrientation.Parent = hrp
	
	-- METHOD 4: BodyPosition
	local BodyPos = Instance.new("BodyPosition")
	BodyPos.Name = "BringBodyPosition"
	BodyPos.MaxForce = Vector3.new(9e9, 9e9, 9e9)
	BodyPos.D = 1250
	BodyPos.P = 10000
	BodyPos.Position = targetCFrame.Position
	BodyPos.Parent = hrp
	
	-- METHOD 5: BodyVelocity
	local BodyVel = Instance.new("BodyVelocity")
	BodyVel.Name = "BringBodyVelocity"
	BodyVel.MaxForce = Vector3.new(9e9, 9e9, 9e9)
	BodyVel.Velocity = Vector3.new(0, 0, 0)
	BodyVel.Parent = hrp
	
	-- METHOD 6: BodyGyro
	local BodyGyro = Instance.new("BodyGyro")
	BodyGyro.Name = "BringBodyGyro"
	BodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
	BodyGyro.D = 500
	BodyGyro.P = 3000
	BodyGyro.CFrame = targetCFrame
	BodyGyro.Parent = hrp
	
	-- METHOD 7: VectorForce
	local VectorForce = Instance.new("VectorForce")
	VectorForce.Name = "BringVectorForce"
	VectorForce.Force = Vector3.new(0, 0, 0)
	VectorForce.ApplyAtCenterOfMass = true
	VectorForce.RelativeTo = Enum.ActuatorRelativeTo.World
	VectorForce.Attachment0 = Attachment2
	VectorForce.Parent = hrp
	
	-- METHOD 8: Torque
	local Torque = Instance.new("Torque")
	Torque.Name = "BringTorque"
	Torque.Torque = Vector3.new(0, 0, 0)
	Torque.Attachment0 = Attachment2
	Torque.Parent = hrp
	
	-- Apply to all body parts for extra control
	for _, part in ipairs(character:GetDescendants()) do
		if part:IsA("BasePart") and part ~= hrp and part.Name ~= "HumanoidRootPart" then
			Network.RetainPart(part)
			
			local attach = Instance.new("Attachment")
			attach.Name = "BringAttachment2"
			attach.Parent = part
			
			local align = Instance.new("AlignPosition")
			align.Name = "BringAlign2"
			align.MaxForce = 9e9
			align.MaxVelocity = 9e9
			align.Responsiveness = 200
			align.Attachment0 = attach
			align.Attachment1 = Attachment1
			align.Parent = part
		end
	end
end

local function StopBringing()
	-- Stop the update loop
	if bringLoop then
		bringLoop:Disconnect()
		bringLoop = nil
	end
	
	-- Clean up all players
	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character then
			local character = player.Character
			local humanoid = character:FindFirstChildOfClass("Humanoid")
			
			ClearBringObjects(character)
			
			-- Reset humanoid
			if humanoid then
				humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, true)
				humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
				humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying, true)
				humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
				humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp, true)
				humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
				humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed, true)
				humanoid:SetStateEnabled(Enum.HumanoidStateType.Running, true)
				humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
				humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming, true)
				humanoid.PlatformStand = false
				humanoid:ChangeState(3)
			end
			
			-- Reset physics
			for _, part in ipairs(character:GetDescendants()) do
				if part:IsA("BasePart") then
					part.Massless = false
				end
			end
		end
	end
	
	-- Clear network parts related to players
	local newBaseParts = {}
	for _, part in pairs(Network.BaseParts) do
		if not part:FindFirstAncestorOfClass("Model") or 
		   not Players:GetPlayerFromCharacter(part:FindFirstAncestorOfClass("Model")) then
			table.insert(newBaseParts, part)
		end
	end
	Network.BaseParts = newBaseParts
end

local playerConnections = {}

local function setupPlayerBring(player)
	if player == LocalPlayer then return end
	
	-- Handle current character
	if player.Character then
		local myChar = LocalPlayer.Character
		if myChar and myChar:FindFirstChild("HumanoidRootPart") then
			ApplyMultipleBringMethods(player.Character, myChar.HumanoidRootPart.CFrame)
		end
	end
	
	-- Handle character respawn
	if playerConnections[player] then
		playerConnections[player]:Disconnect()
	end
	
	playerConnections[player] = player.CharacterAdded:Connect(function(character)
		if bringActive then
			wait(1) -- Wait for character to fully load
			local myChar = LocalPlayer.Character
			if myChar and myChar:FindFirstChild("HumanoidRootPart") then
				ApplyMultipleBringMethods(character, myChar.HumanoidRootPart.CFrame)
			end
		end
	end)
end

local function toggleBring()
	bringActive = not bringActive
	
	if bringActive then
		Button.Text = "Bring Players | On"
		
		local myCharacter = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
		local myHRP = myCharacter:WaitForChild("HumanoidRootPart")
		
		-- Setup all current players
		for _, player in ipairs(Players:GetPlayers()) do
			setupPlayerBring(player)
		end
		
		-- Handle new players
		playerConnections.PlayerAdded = Players.PlayerAdded:Connect(function(player)
			if bringActive then
				setupPlayerBring(player)
			end
		end)
		
		-- Handle players leaving
		playerConnections.PlayerRemoving = Players.PlayerRemoving:Connect(function(player)
			if playerConnections[player] then
				playerConnections[player]:Disconnect()
				playerConnections[player] = nil
			end
		end)
		
		-- Continuous update loop - Updates position, forces, and CFrame
		bringLoop = RunService.Heartbeat:Connect(function()
			if bringActive and myCharacter and myHRP then
				local targetCFrame = myHRP.CFrame
				Attachment1.WorldCFrame = targetCFrame
				Part.CFrame = targetCFrame
				
				-- Update all players
				for _, player in ipairs(Players:GetPlayers()) do
					if player ~= LocalPlayer and player.Character then
						local char = player.Character
						local hrp = char:FindFirstChild("HumanoidRootPart")
						
						if hrp then
							-- Update BodyPosition
							local bodyPos = hrp:FindFirstChild("BringBodyPosition")
							if bodyPos then
								bodyPos.Position = targetCFrame.Position
							end
							
							-- Update BodyVelocity - pull toward player
							local bodyVel = hrp:FindFirstChild("BringBodyVelocity")
							if bodyVel then
								local direction = (targetCFrame.Position - hrp.Position).Unit
								bodyVel.Velocity = direction * 100
							end
							
							-- Update BodyGyro
							local bodyGyro = hrp:FindFirstChild("BringBodyGyro")
							if bodyGyro then
								bodyGyro.CFrame = targetCFrame
							end
							
							-- Update VectorForce
							local vectorForce = hrp:FindFirstChild("BringVectorForce")
							if vectorForce then
								local direction = (targetCFrame.Position - hrp.Position).Unit
								vectorForce.Force = direction * 50000
							end
							
							-- Direct CFrame manipulation (METHOD 9)
							pcall(function()
								hrp.CFrame = targetCFrame
							end)
							
							-- Direct Velocity manipulation (METHOD 10)
							pcall(function()
								hrp.Velocity = Vector3.new(0, 0, 0)
								hrp.RotVelocity = Vector3.new(0, 0, 0)
							end)
						end
					end
				end
			end
		end)
		
	else
		Button.Text = "Bring Players | Off"
		StopBringing()
		
		-- Disconnect all connections
		for key, connection in pairs(playerConnections) do
			if typeof(connection) == "RBXScriptConnection" then
				connection:Disconnect()
			end
		end
		playerConnections = {}
	end
end

Button.MouseButton1Click:Connect(function()
	toggleBring()
end)
