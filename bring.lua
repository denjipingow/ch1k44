-- Gui to Lua
-- Version: 3.3 with adjustable controls

-- Instances:

local Gui = Instance.new("ScreenGui")
local Main = Instance.new("Frame")
local Box = Instance.new("TextBox")
local UITextSizeConstraint = Instance.new("UITextSizeConstraint")
local Label = Instance.new("TextLabel")
local UITextSizeConstraint_2 = Instance.new("UITextSizeConstraint")
local Button = Instance.new("TextButton")
local UITextSizeConstraint_3 = Instance.new("UITextSizeConstraint")

-- New Controls
local ForceLabel = Instance.new("TextLabel")
local ForceBox = Instance.new("TextBox")
local ResponseLabel = Instance.new("TextLabel")
local ResponseBox = Instance.new("TextBox")

--Properties:

Gui.Name = "Gui"
Gui.Parent = gethui()
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Main.Name = "Main"
Main.Parent = Gui
Main.BackgroundColor3 = Color3.fromRGB(75, 75, 75)
Main.BorderColor3 = Color3.fromRGB(0, 0, 0)
Main.BorderSizePixel = 0
Main.Position = UDim2.new(0.335954279, 0, 0.442361975, 0) -- Adjusted position
Main.Size = UDim2.new(0.240350261, 0, 0.266880623, 0) -- Increased height for new controls
Main.Active = true
Main.Draggable = true

-- Box
Box.Name = "Box"
Box.Parent = Main
Box.BackgroundColor3 = Color3.fromRGB(95, 95, 95)
Box.BackgroundTransparency = 0.5
Box.BorderColor3 = Color3.fromRGB(0, 0, 0)
Box.BorderSizePixel = 0
Box.Position = UDim2.new(0.0980926454, 0, 0.13, 0)
Box.Size = UDim2.new(0.801089942, 0, 0.18, 0)
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
Label.Size = UDim2.new(1, 0, 0.1, 0)
Label.FontFace = Font.new("rbxasset://fonts/families/Nunito.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
Label.Text = "Bring Unanchored Parts by FayintXHub"
Label.TextColor3 = Color3.fromRGB(255, 255, 255)
Label.TextScaled = true
Label.TextSize = 14.000
Label.TextWrapped = true

-- Force Label
ForceLabel.Name = "ForceLabel"
ForceLabel.Parent = Main
ForceLabel.BackgroundColor3 = Color3.fromRGB(95, 95, 95)
ForceLabel.BackgroundTransparency = 1
ForceLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
ForceLabel.BorderSizePixel = 0
ForceLabel.Position = UDim2.new(0.05, 0, 0.33, 0)
ForceLabel.Size = UDim2.new(0.4, 0, 0.1, 0)
ForceLabel.Font = Enum.Font.Nunito
ForceLabel.Text = "Force:"
ForceLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
ForceLabel.TextScaled = true
ForceLabel.TextSize = 14.000
ForceLabel.TextWrapped = true
ForceLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Force Box
ForceBox.Name = "ForceBox"
ForceBox.Parent = Main
ForceBox.BackgroundColor3 = Color3.fromRGB(95, 95, 95)
ForceBox.BackgroundTransparency = 0.5
ForceBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
ForceBox.BorderSizePixel = 0
ForceBox.Position = UDim2.new(0.45, 0, 0.33, 0)
ForceBox.Size = UDim2.new(0.45, 0, 0.1, 0)
ForceBox.Font = Enum.Font.SourceSansSemibold
ForceBox.PlaceholderText = "10000-999999"
ForceBox.Text = "50000"
ForceBox.TextColor3 = Color3.fromRGB(255, 255, 255)
ForceBox.TextScaled = true
ForceBox.TextSize = 20.000
ForceBox.TextWrapped = true

-- Response Label
ResponseLabel.Name = "ResponseLabel"
ResponseLabel.Parent = Main
ResponseLabel.BackgroundColor3 = Color3.fromRGB(95, 95, 95)
ResponseLabel.BackgroundTransparency = 1
ResponseLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
ResponseLabel.BorderSizePixel = 0
ResponseLabel.Position = UDim2.new(0.05, 0, 0.45, 0)
ResponseLabel.Size = UDim2.new(0.4, 0, 0.1, 0)
ResponseLabel.Font = Enum.Font.Nunito
ResponseLabel.Text = "Speed:"
ResponseLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
ResponseLabel.TextScaled = true
ResponseLabel.TextSize = 14.000
ResponseLabel.TextWrapped = true
ResponseLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Response Box
ResponseBox.Name = "ResponseBox"
ResponseBox.Parent = Main
ResponseBox.BackgroundColor3 = Color3.fromRGB(95, 95, 95)
ResponseBox.BackgroundTransparency = 0.5
ResponseBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
ResponseBox.BorderSizePixel = 0
ResponseBox.Position = UDim2.new(0.45, 0, 0.45, 0)
ResponseBox.Size = UDim2.new(0.45, 0, 0.1, 0)
ResponseBox.Font = Enum.Font.SourceSansSemibold
ResponseBox.PlaceholderText = "1-200"
ResponseBox.Text = "200"
ResponseBox.TextColor3 = Color3.fromRGB(255, 255, 255)
ResponseBox.TextScaled = true
ResponseBox.TextSize = 20.000
ResponseBox.TextWrapped = true

-- Button
Button.Name = "Button"
Button.Parent = Main
Button.BackgroundColor3 = Color3.fromRGB(95, 95, 95)
Button.BackgroundTransparency = 0.5
Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
Button.BorderSizePixel = 0
Button.Position = UDim2.new(0.183284417, 0, 0.58, 0)
Button.Size = UDim2.new(0.629427791, 0, 0.15, 0)
Button.Font = Enum.Font.Nunito
Button.Text = "Bring | Off"
Button.TextColor3 = Color3.fromRGB(255, 255, 255)
Button.TextScaled = true
Button.TextSize = 28.000
Button.TextWrapped = true

-- Info Label
local InfoLabel = Instance.new("TextLabel")
InfoLabel.Name = "InfoLabel"
InfoLabel.Parent = Main
InfoLabel.BackgroundColor3 = Color3.fromRGB(95, 95, 95)
InfoLabel.BackgroundTransparency = 1
InfoLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
InfoLabel.BorderSizePixel = 0
InfoLabel.Position = UDim2.new(0, 0, 0.75, 0)
InfoLabel.Size = UDim2.new(1, 0, 0.25, 0)
InfoLabel.Font = Enum.Font.Nunito
InfoLabel.Text = "Force: Higher = Stronger Pull\nSpeed: Higher = Faster Response\nPress Right Ctrl to hide/show"
InfoLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
InfoLabel.TextScaled = true
InfoLabel.TextSize = 10.000
InfoLabel.TextWrapped = true

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

-- Store references to AlignPositions for realtime updates
local activeAlignPositions = {}
local activeTorques = {}

-- Default values
local currentMaxForce = 50000
local currentResponsiveness = 200

local mainStatus = true
UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
	if input.KeyCode == Enum.KeyCode.RightControl and not gameProcessedEvent then
		mainStatus = not mainStatus
		Main.Visible = mainStatus
	end
end)

-- Part target untuk menarik objek
local targetFolder = Instance.new("Folder", Workspace)
targetFolder.Name = "BringPartTarget_FayintX"
local targetPart = Instance.new("Part", targetFolder)
local targetAttachment = Instance.new("Attachment", targetPart)
targetPart.Anchored = true
targetPart.CanCollide = false
targetPart.Transparency = 1
targetPart.Size = Vector3.new(0.1, 0.1, 0.1)

-- Function to validate and get number from input
local function getValidNumber(text, min, max, default)
	local num = tonumber(text)
	if num then
		if min and num < min then
			return min
		elseif max and num > max then
			return max
		else
			return num
		end
	end
	return default
end

-- Update all active AlignPositions when values change
local function updateAllAlignPositions()
	for alignPos, _ in pairs(activeAlignPositions) do
		if alignPos and alignPos.Parent then
			alignPos.MaxForce = currentMaxForce
			alignPos.MaxVelocity = currentMaxForce / 100  -- Scale MaxVelocity with MaxForce
			alignPos.Responsiveness = currentResponsiveness
		else
			activeAlignPositions[alignPos] = nil
		end
	end
end

-- Force Box input handler
ForceBox.FocusLost:Connect(function(enterPressed)
	local newForce = getValidNumber(ForceBox.Text, 1000, 999999, 50000)
	currentMaxForce = newForce
	ForceBox.Text = tostring(newForce)
	updateAllAlignPositions()
	print("Force updated to:", newForce)
end)

-- Response Box input handler
ResponseBox.FocusLost:Connect(function(enterPressed)
	local newResponse = getValidNumber(ResponseBox.Text, 1, 200, 200)
	currentResponsiveness = newResponse
	ResponseBox.Text = tostring(newResponse)
	updateAllAlignPositions()
	print("Responsiveness updated to:", newResponse)
end)

-- Fungsi untuk memaksa part bergerak ke target (HANYA UNANCHORED PARTS)
local function ForcePart(v)
	-- PENGECEKAN EKSPLISIT: Hanya proses part yang TIDAK anchored
	if v:IsA("BasePart") 
		and v.Anchored == false  -- PENGECEKAN EKSPLISIT: Part harus unanchored
		and not v.Parent:FindFirstChildOfClass("Humanoid")
		and not v.Parent:FindFirstChild("Head")
		and v.Name ~= "Handle"
		and not v:IsDescendantOf(targetFolder)
	then
		-- Double check untuk memastikan part tidak anchored
		if v.Anchored == true then
			return -- Skip jika part anchored
		end
		
		-- Clean up old movers
		for _, x in ipairs(v:GetChildren()) do
			if x:IsA("BodyMover") or x:IsA("RocketPropulsion") or x:IsA("AlignPosition") or x:IsA("Torque") then
				if activeAlignPositions[x] then
					activeAlignPositions[x] = nil
				end
				if activeTorques[x] then
					activeTorques[x] = nil
				end
				x:Destroy()
			end
		end
		
		v.CanCollide = false
		
		local alignPosition = Instance.new("AlignPosition", v)
		local attachmentInPart = v:FindFirstChildOfClass("Attachment") or Instance.new("Attachment", v)
		
		-- Use current values from UI
		alignPosition.MaxForce = currentMaxForce
		alignPosition.MaxVelocity = currentMaxForce / 100
		alignPosition.Responsiveness = currentResponsiveness
		alignPosition.Attachment0 = attachmentInPart
		alignPosition.Attachment1 = targetAttachment
		
		-- Store reference for realtime updates
		activeAlignPositions[alignPosition] = true
		
		local torque = Instance.new("Torque", v)
		torque.Torque = Vector3.new(math.huge, math.huge, math.huge)
		torque.Attachment0 = attachmentInPart
		
		-- Store torque reference
		activeTorques[torque] = true
	end
end

local bringActive = false
local descendantAddedConnection

local function toggleBring()
	bringActive = not bringActive
	if bringActive then
		Button.Text = "Bring | On"
		Button.TextColor3 = Color3.fromRGB(0, 255, 0) -- Green when on
		
		-- Clear old references
		activeAlignPositions = {}
		activeTorques = {}
		
		-- Hanya proses unanchored parts
		for _, v in ipairs(Workspace:GetDescendants()) do
			if v:IsA("BasePart") and v.Anchored == false then  -- PENGECEKAN TAMBAHAN
				task.spawn(ForcePart, v)
			end
		end

		descendantAddedConnection = Workspace.DescendantAdded:Connect(function(v)
			if bringActive and v:IsA("BasePart") and v.Anchored == false then  -- PENGECEKAN TAMBAHAN
				task.spawn(ForcePart, v)
			end
		end)

		spawn(function()
			while bringActive and task.wait() do
				if humanoidRootPart then
					targetAttachment.WorldCFrame = humanoidRootPart.CFrame
				end
			end
		end)
	else
		Button.Text = "Bring | Off"
		Button.TextColor3 = Color3.fromRGB(255, 255, 255) -- White when off
		
		if descendantAddedConnection then
			descendantAddedConnection:Disconnect()
			descendantAddedConnection = nil
		end
		
		-- Clear references
		activeAlignPositions = {}
		activeTorques = {}
		
		for _, v in ipairs(Workspace:GetDescendants()) do
			if v:IsA("AlignPosition") and v.Attachment1 == targetAttachment then
				v:Destroy()
			end
			if v:IsA("Torque") and v.Parent and not v.Parent:FindFirstChildOfClass("Humanoid") then
				local attachment = v.Attachment0
				if attachment and attachment.Parent == v.Parent and v.Attachment1 == nil then
					v:Destroy()
				end
			end
		end
	end
end

local function getPlayer(name)
	local lowerName = string.lower(name)
	for _, p in pairs(Players:GetPlayers()) do
		local lowerPlayer = string.lower(p.Name)
		if string.find(lowerPlayer, lowerName) then
			return p
		elseif string.find(string.lower(p.DisplayName), lowerName) then
			return p
		end
	end
end

local player = nil

Box.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		player = getPlayer(Box.Text)
		if player then
			Box.Text = player.Name
			print("Player target set to:", player.Name)
		else
			print("Player not found")
		end
	end
end)

Button.MouseButton1Click:Connect(function()
	if player then
		character = player.Character or player.CharacterAdded:Wait()
		humanoidRootPart = character:WaitForChild("HumanoidRootPart")
		toggleBring()
	else
		print("Player target is not selected")
	end
end)
