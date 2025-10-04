-- Gui to Lua
-- Version: 3.2 - Modified to Bring All Players (Real Position)

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
local Part = Instance.new("Part", Folder)
local Attachment1 = Instance.new("Attachment", Part)
Part.Anchored = true
Part.CanCollide = false
Part.Transparency = 1

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

local function BringPlayerCharacter(character)
	if not character then return end
	
	-- Skip if it's local player
	if character == LocalPlayer.Character then return end
	
	local hrp = character:FindFirstChild("HumanoidRootPart")
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	
	if not hrp then return end
	
	-- Disable humanoid physics
	if humanoid then
		humanoid:ChangeState(11) -- Physics state
		humanoid.PlatformStand = true
	end
	
	-- Add to network control
	Network.RetainPart(hrp)
	
	-- Remove all body movers and constraints
	for _, child in ipairs(hrp:GetChildren()) do
		if child:IsA("BodyMover") or child:IsA("RocketPropulsion") or 
		   child:IsA("AlignPosition") or child:IsA("Torque") then
			child:Destroy()
		end
	end
	
	-- Clean existing attachments except the original ones
	for _, child in ipairs(hrp:GetChildren()) do
		if child:IsA("Attachment") and child.Name ~= "RootAttachment" and 
		   child.Name ~= "RootRigAttachment" then
			child:Destroy()
		end
	end
	
	-- Create new constraints
	hrp.CanCollide = false
	hrp.Massless = true
	
	local Torque = Instance.new("Torque")
	Torque.Name = "BringTorque"
	Torque.Torque = Vector3.new(100000, 100000, 100000)
	Torque.Parent = hrp
	
	local AlignPosition = Instance.new("AlignPosition")
	AlignPosition.Name = "BringAlign"
	AlignPosition.MaxForce = math.huge
	AlignPosition.MaxVelocity = math.huge
	AlignPosition.Responsiveness = 200
	AlignPosition.ApplyAtCenterOfMass = true
	AlignPosition.ReactionForceEnabled = false
	AlignPosition.RigidityEnabled = true
	AlignPosition.Parent = hrp
	
	local Attachment2 = Instance.new("Attachment")
	Attachment2.Name = "BringAttachment"
	Attachment2.Parent = hrp
	
	Torque.Attachment0 = Attachment2
	AlignPosition.Attachment0 = Attachment2
	AlignPosition.Attachment1 = Attachment1
	
	-- Disable all other body parts collision
	for _, part in ipairs(character:GetDescendants()) do
		if part:IsA("BasePart") then
			part.CanCollide = false
			if part.Name ~= "HumanoidRootPart" then
				part.Massless = true
			end
		end
	end
end

local function StopBringing()
	-- Clean up all players
	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character then
			local character = player.Character
			local hrp = character:FindFirstChild("HumanoidRootPart")
			local humanoid = character:FindFirstChildOfClass("Humanoid")
			
			if hrp then
				-- Remove constraints
				for _, child in ipairs(hrp:GetChildren()) do
					if child.Name == "BringAttachment" or child.Name == "BringAlign" or 
					   child.Name == "BringTorque" then
						child:Destroy()
					end
				end
				
				-- Re-enable collision
				hrp.CanCollide = true
				hrp.Massless = false
			end
			
			-- Reset humanoid
			if humanoid then
				humanoid.PlatformStand = false
				humanoid:ChangeState(3) -- Running state
			end
			
			-- Re-enable collision for all body parts
			for _, part in ipairs(character:GetDescendants()) do
				if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
					part.Massless = false
					if part.Name == "Head" or part.Name:match("Leg") or 
					   part.Name:match("Arm") or part.Name:match("Torso") then
						part.CanCollide = false -- Keep these false for normal roblox behavior
					end
				end
			end
		end
	end
	
	-- Clear network parts related to players
	local newBaseParts = {}
	for _, part in pairs(Network.BaseParts) do
		if part.Name ~= "HumanoidRootPart" then
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
		BringPlayerCharacter(player.Character)
	end
	
	-- Handle character respawn
	if playerConnections[player] then
		playerConnections[player]:Disconnect()
	end
	
	playerConnections[player] = player.CharacterAdded:Connect(function(character)
		if bringActive then
			wait(0.5) -- Wait for character to load
			BringPlayerCharacter(character)
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
		
		-- Update attachment position continuously
		playerConnections.UpdatePosition = RunService.RenderStepped:Connect(function()
			if bringActive and myCharacter and myHRP then
				Attachment1.WorldCFrame = myHRP.CFrame
			end
		end)
	else
		Button.Text = "Bring Players | Off"
		StopBringing()
		
		-- Disconnect all connections
		for key, connection in pairs(playerConnections) do
			connection:Disconnect()
		end
		playerConnections = {}
	end
end

Button.MouseButton1Click:Connect(function()
	toggleBring()
end)
