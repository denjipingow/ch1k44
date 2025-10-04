-- Gui to Lua
-- Version: 3.2 - REAL BRING (NOT VISUAL ONLY)

-- Instances:

local Gui = Instance.new("ScreenGui")
local Main = Instance.new("Frame")
local Label = Instance.new("TextLabel")
local Button = Instance.new("TextButton")

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

Label.Name = "Label"
Label.Parent = Main
Label.BackgroundColor3 = Color3.fromRGB(95, 95, 95)
Label.BackgroundTransparency = 0.5
Label.BorderColor3 = Color3.fromRGB(0, 0, 0)
Label.BorderSizePixel = 0
Label.Size = UDim2.new(1, 0, 0.35, 0)
Label.FontFace = Font.new("rbxasset://fonts/families/Nunito.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
Label.Text = "Real Bring - Server Replicated"
Label.TextColor3 = Color3.fromRGB(255, 255, 255)
Label.TextScaled = true
Label.TextSize = 14.000
Label.TextWrapped = true

Button.Name = "Button"
Button.Parent = Main
Button.BackgroundColor3 = Color3.fromRGB(95, 95, 95)
Button.BackgroundTransparency = 0.5
Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
Button.BorderSizePixel = 0
Button.Position = UDim2.new(0.183284417, 0, 0.5, 0)
Button.Size = UDim2.new(0.629427791, 0, 0.4, 0)
Button.Font = Enum.Font.Nunito
Button.Text = "Bring | Off"
Button.TextColor3 = Color3.fromRGB(255, 255, 255)
Button.TextScaled = true
Button.TextSize = 28.000
Button.TextWrapped = true

-- Scripts:

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

-- Toggle GUI
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessedEvent)
	if input.KeyCode == Enum.KeyCode.RightControl and not gameProcessedEvent then
		Main.Visible = not Main.Visible
	end
end)

-- Advanced Network Control
local function SetupNetworkOwnership()
	settings().Physics.AllowSleep = false
	settings().Physics.PhysicsEnvironmentalThrottle = Enum.EnviromentalPhysicsThrottle.Disabled
	
	LocalPlayer.MaximumSimulationRadius = math.pow(math.huge, math.huge)
	sethiddenproperty(LocalPlayer, "SimulationRadius", math.pow(math.huge, math.huge))
	
	RunService.Heartbeat:Connect(function()
		sethiddenproperty(LocalPlayer, "SimulationRadius", math.pow(math.huge, math.huge))
		LocalPlayer.ReplicationFocus = Workspace
	end)
end

SetupNetworkOwnership()

-- Aggressive Network Ownership Stealer
local function StealNetworkOwnership(part)
	if not part:IsA("BasePart") then return end
	
	-- Method 1: Direct ownership claim
	pcall(function()
		part:SetNetworkOwner(nil)
	end)
	
	pcall(function()
		part:SetNetworkOwner(LocalPlayer)
	end)
	
	-- Method 2: Velocity manipulation
	pcall(function()
		part.Velocity = Vector3.new(0, 0, 0)
		part.RotVelocity = Vector3.new(0, 0, 0)
		part.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
		part.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
	end)
	
	-- Method 3: Force properties
	pcall(function()
		part.CanCollide = false
		part.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0, 0, 0)
		part.Massless = true
	end)
end

local bringActive = false
local bringLoop = nil

-- Real Server-Side Bring
local function BringPlayerReal(player)
	if player == LocalPlayer then return end
	
	local character = player.Character
	if not character then return end
	
	local hrp = character:FindFirstChild("HumanoidRootPart")
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if not hrp then return end
	
	local myChar = LocalPlayer.Character
	if not myChar then return end
	local myHRP = myChar:FindFirstChild("HumanoidRootPart")
	if not myHRP then return end
	
	-- Steal network ownership of entire character
	for _, part in pairs(character:GetDescendants()) do
		if part:IsA("BasePart") then
			StealNetworkOwnership(part)
		end
	end
	
	-- Disable humanoid completely
	if humanoid then
		pcall(function()
			humanoid:ChangeState(11) -- Physics
			humanoid.PlatformStand = true
			humanoid.AutoRotate = false
			
			-- Disable all states
			for _, state in pairs(Enum.HumanoidStateType:GetEnumItems()) do
				pcall(function()
					humanoid:SetStateEnabled(state, false)
				end)
			end
		end)
	end
	
	-- Remove ALL constraints and movers
	for _, obj in pairs(hrp:GetChildren()) do
		if not obj:IsA("Attachment") or obj.Name:match("Bring") then
			if obj:IsA("BodyMover") or obj:IsA("Constraint") then
				obj:Destroy()
			end
		end
	end
	
	-- Clear existing bring objects
	for _, obj in pairs(hrp:GetChildren()) do
		if obj.Name:match("Bring") then
			obj:Destroy()
		end
	end
	
	-- Anchor method (most reliable for network replication)
	local anchorPart = Instance.new("Part")
	anchorPart.Name = "BringAnchor"
	anchorPart.Anchored = true
	anchorPart.CanCollide = false
	anchorPart.Transparency = 1
	anchorPart.Size = Vector3.new(0.1, 0.1, 0.1)
	anchorPart.Parent = hrp
	
	local weld = Instance.new("WeldConstraint")
	weld.Name = "BringWeld"
	weld.Part0 = anchorPart
	weld.Part1 = hrp
	weld.Parent = hrp
	
	-- AlignPosition method
	local att0 = Instance.new("Attachment")
	att0.Name = "BringAtt0"
	att0.Parent = hrp
	
	local att1 = myHRP:FindFirstChild("BringTarget") or Instance.new("Attachment")
	att1.Name = "BringTarget"
	att1.Parent = myHRP
	
	local align = Instance.new("AlignPosition")
	align.Name = "BringAlign"
	align.Attachment0 = att0
	align.Attachment1 = att1
	align.MaxForce = math.huge
	align.MaxVelocity = math.huge
	align.Responsiveness = 200
	align.RigidityEnabled = true
	align.ApplyAtCenterOfMass = true
	align.Parent = hrp
	
	-- BodyPosition method
	local bodyPos = Instance.new("BodyPosition")
	bodyPos.Name = "BringBodyPos"
	bodyPos.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
	bodyPos.P = 10000
	bodyPos.D = 1000
	bodyPos.Position = myHRP.Position
	bodyPos.Parent = hrp
	
	-- BodyGyro method
	local bodyGyro = Instance.new("BodyGyro")
	bodyGyro.Name = "BringBodyGyro"
	bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
	bodyGyro.P = 10000
	bodyGyro.D = 500
	bodyGyro.CFrame = myHRP.CFrame
	bodyGyro.Parent = hrp
	
	-- Apply to all parts
	for _, part in pairs(character:GetDescendants()) do
		if part:IsA("BasePart") and part ~= hrp then
			StealNetworkOwnership(part)
			part.CanCollide = false
			
			-- Weld to HRP
			local weld = Instance.new("WeldConstraint")
			weld.Name = "BringWeldPart"
			weld.Part0 = hrp
			weld.Part1 = part
			weld.Parent = part
		end
	end
end

-- Start bringing
local function StartBring()
	bringActive = true
	Button.Text = "Bring | On"
	
	-- Apply to all players
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer then
			spawn(function()
				BringPlayerReal(player)
			end)
		end
	end
	
	-- Handle respawns
	for _, player in pairs(Players:GetPlayers()) do
		player.CharacterAdded:Connect(function(char)
			if bringActive then
				wait(1)
				BringPlayerReal(player)
			end
		end)
	end
	
	-- Continuous update
	bringLoop = RunService.Heartbeat:Connect(function()
		if not bringActive then return end
		
		local myChar = LocalPlayer.Character
		if not myChar then return end
		local myHRP = myChar:FindFirstChild("HumanoidRootPart")
		if not myHRP then return end
		
		local targetPos = myHRP.Position
		local targetCF = myHRP.CFrame
		
		for _, player in pairs(Players:GetPlayers()) do
			if player ~= LocalPlayer and player.Character then
				local char = player.Character
				local hrp = char:FindFirstChild("HumanoidRootPart")
				
				if hrp then
					-- Continuously steal ownership
					StealNetworkOwnership(hrp)
					
					-- Update anchor position
					local anchor = hrp:FindFirstChild("BringAnchor")
					if anchor then
						anchor.CFrame = targetCF
					end
					
					-- Update BodyPosition
					local bodyPos = hrp:FindFirstChild("BringBodyPos")
					if bodyPos then
						bodyPos.Position = targetPos
					end
					
					-- Update BodyGyro
					local bodyGyro = hrp:FindFirstChild("BringBodyGyro")
					if bodyGyro then
						bodyGyro.CFrame = targetCF
					end
					
					-- Force CFrame (aggressive)
					pcall(function()
						hrp.CFrame = targetCF
						hrp.Velocity = Vector3.new(0, 0, 0)
						hrp.RotVelocity = Vector3.new(0, 0, 0)
						hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
						hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
					end)
					
					-- Maintain properties
					pcall(function()
						hrp.CanCollide = false
						hrp.Massless = true
						hrp.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0, 0, 0)
					end)
				end
			end
		end
	end)
end

-- Stop bringing
local function StopBring()
	bringActive = false
	Button.Text = "Bring | Off"
	
	if bringLoop then
		bringLoop:Disconnect()
		bringLoop = nil
	end
	
	-- Clean all players
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character then
			local char = player.Character
			local hrp = char:FindFirstChild("HumanoidRootPart")
			local humanoid = char:FindFirstChildOfClass("Humanoid")
			
			if hrp then
				-- Remove bring objects
				for _, obj in pairs(hrp:GetChildren()) do
					if obj.Name:match("Bring") then
						obj:Destroy()
					end
				end
			end
			
			-- Remove welds from all parts
			for _, part in pairs(char:GetDescendants()) do
				if part:IsA("BasePart") then
					for _, obj in pairs(part:GetChildren()) do
						if obj.Name:match("BringWeld") then
							obj:Destroy()
						end
					end
					
					pcall(function()
						part.Massless = false
					end)
				end
			end
			
			-- Reset humanoid
			if humanoid then
				pcall(function()
					humanoid.PlatformStand = false
					humanoid.AutoRotate = true
					humanoid:ChangeState(3)
					
					for _, state in pairs(Enum.HumanoidStateType:GetEnumItems()) do
						pcall(function()
							humanoid:SetStateEnabled(state, true)
						end)
					end
				end)
			end
		end
	end
end

-- Button click
Button.MouseButton1Click:Connect(function()
	if bringActive then
		StopBring()
	else
		StartBring()
	end
end)
