-- Gui to Lua
-- Version: 3.2 - EXTREME POWER (100x) - NO RESET - INSTANT

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
Box.PlaceholderText = "Player here"
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
Label.Text = "Bring Unanchored Parts [EXTREME - INSTANT]"
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
Button.Text = "Bring | Off"
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

local character
local humanoidRootPart

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

-- STORAGE UNTUK PARTS YANG SUDAH DIMODIFIKASI
local ModifiedParts = {}

if not getgenv().Network then
	getgenv().Network = {
		BaseParts = {},
		Velocity = Vector3.new(1446.262424, 1446.262424, 1446.262424)
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

-- FUNGSI FORCE PART INSTANT - NO DELAY
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
			return
		end
		
		-- INSTANT SETUP - SEMUA DIBUAT SEKALIGUS
		v.CanCollide = false
		v.Massless = true
		v.CustomPhysicalProperties = PhysicalProperties.new(0.01, 0, 0, 0, 0)
		
		local Torque = v:FindFirstChild("ExtremeTorque")
		if not Torque then
			Torque = Instance.new("Torque")
			Torque.Name = "ExtremeTorque"
			Torque.Torque = Vector3.new(10000000, 10000000, 10000000)
			Torque.Parent = v
		end
		
		local Attachment2 = v:FindFirstChild("ExtremeAttachment")
		if not Attachment2 then
			Attachment2 = Instance.new("Attachment")
			Attachment2.Name = "ExtremeAttachment"
			Attachment2.Parent = v
		end
		
		local AlignPosition = v:FindFirstChild("ExtremeAlign")
		if not AlignPosition then
			AlignPosition = Instance.new("AlignPosition")
			AlignPosition.Name = "ExtremeAlign"
			AlignPosition.MaxForce = math.huge * 100
			AlignPosition.MaxVelocity = math.huge
			AlignPosition.Responsiveness = 20000
			AlignPosition.ApplyAtCenterOfMass = true
			AlignPosition.ReactionForceEnabled = false
			AlignPosition.RigidityEnabled = true
			AlignPosition.Attachment0 = Attachment2
			AlignPosition.Attachment1 = Attachment1
			AlignPosition.Parent = v
		end
		
		Torque.Attachment0 = Attachment2
		
		-- SIMPAN REFERENCE
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

-- INSTANT TOGGLE - NO DELAY
local function toggleBlackHole()
	blackHoleActive = not blackHoleActive
	if blackHoleActive then
		Button.Text = "Bring | On [INSTANT]"
		
		-- INSTANT SCAN - BATCH PROCESSING
		local descendants = Workspace:GetDescendants()
		for i = 1, #descendants do
			ForcePart(descendants[i])
		end

		-- INSTANT MONITORING
		DescendantAddedConnection = Workspace.DescendantAdded:Connect(ForcePart)

		-- INSTANT UPDATE - SETIAP FRAME
		UpdateConnection = RunService.Heartbeat:Connect(function()
			if humanoidRootPart then
				local cf = humanoidRootPart.CFrame
				Attachment1.WorldCFrame = cf
				Part.CFrame = cf
			end
		end)
	else
		Button.Text = "Bring | Off"
		
		-- INSTANT DISABLE - NO LOOP DELAY
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
	end
end

-- INSTANT PLAYER SEARCH - NO WAIT
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

local player = nil

-- INSTANT PLAYER SELECTION
local function VDOYZQL_fake_script()
	local script = Instance.new('Script', Box)

	script.Parent.FocusLost:Connect(function(enterPressed)
		if enterPressed then
			player = getPlayer(Box.Text)
			if player then
				Box.Text = player.Name
			end
		end
	end)
end
coroutine.wrap(VDOYZQL_fake_script)()

-- INSTANT ACTIVATION
local function JUBNQKI_fake_script()
	local script = Instance.new('Script', Button)

	script.Parent.MouseButton1Click:Connect(function()
		if player then
			-- INSTANT CHARACTER GET - NO WAIT
			character = player.Character
			if character then
				humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
				if humanoidRootPart then
					toggleBlackHole()
				end
			else
				-- AUTO-CONNECT KETIKA CHARACTER MUNCUL
				local conn
				conn = player.CharacterAdded:Connect(function(char)
					character = char
					humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
					if humanoidRootPart and not blackHoleActive then
						toggleBlackHole()
					end
					conn:Disconnect()
				end)
			end
		end
	end)
end
coroutine.wrap(JUBNQKI_fake_script)()

-- AUTO-UPDATE HUMANOIDROOTPART SETIAP FRAME (NO DELAY)
RunService.Heartbeat:Connect(function()
	if player and player.Character and not humanoidRootPart then
		character = player.Character
		humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
	end
end)
