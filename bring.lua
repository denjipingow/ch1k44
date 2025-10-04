-- Gui to Lua
-- Version: 3.2

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
Label.Text = "Bring Parts by FayintXHub"
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
Button.Position = UDim2.new(0.183284417, 0, 0.45, 0)
Button.Size = UDim2.new(0.629427791, 0, 0.45, 0)
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

local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- Update character ketika respawn
LocalPlayer.CharacterAdded:Connect(function(char)
	character = char
	humanoidRootPart = character:WaitForChild("HumanoidRootPart")
end)

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
		-- Velocity 30x lipat: 14.46262424 * 30 = 433.8787272
		Velocity = Vector3.new(433.8787272, 433.8787272, 433.8787272)
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

local function ForcePart(v)
	-- HANYA UNANCHORED PARTS yang akan ditarik
	if v:IsA("BasePart") and not v.Anchored then
		-- Skip parts dari character/humanoid
		if v.Parent:FindFirstChildOfClass("Humanoid") or v.Parent:FindFirstChild("Head") or v.Name == "Handle" then
			return
		end
		
		-- Skip jika sudah memiliki AlignPosition dari script ini
		if v:FindFirstChild("AlignPosition") and v:FindFirstChild("Attachment") then
			return
		end
		
		-- Hapus body movers yang ada
		for _, x in ipairs(v:GetChildren()) do
			if x:IsA("BodyMover") or x:IsA("RocketPropulsion") then
				x:Destroy()
			end
		end
		
		-- Hapus attachment/constraint lama jika ada
		if v:FindFirstChild("Attachment") then
			v:FindFirstChild("Attachment"):Destroy()
		end
		if v:FindFirstChild("AlignPosition") then
			v:FindFirstChild("AlignPosition"):Destroy()
		end
		if v:FindFirstChild("Torque") then
			v:FindFirstChild("Torque"):Destroy()
		end
		
		v.CanCollide = false
		
		-- Torque 30x lipat: 100000 * 30 = 3000000
		local Torque = Instance.new("Torque", v)
		Torque.Torque = Vector3.new(3000000, 3000000, 3000000)
		
		local AlignPosition = Instance.new("AlignPosition", v)
		local Attachment2 = Instance.new("Attachment", v)
		
		Torque.Attachment0 = Attachment2
		AlignPosition.MaxForce = math.huge
		AlignPosition.MaxVelocity = math.huge
		-- Responsiveness 30x lipat: 200 * 30 = 6000
		AlignPosition.Responsiveness = 6000
		AlignPosition.Attachment0 = Attachment2
		AlignPosition.Attachment1 = Attachment1
	end
end

local blackHoleActive = false
local DescendantAddedConnection
local UpdateConnection

local function toggleBlackHole()
	blackHoleActive = not blackHoleActive
	if blackHoleActive then
		Button.Text = "Bring Parts | On"
		
		-- Apply ke semua unanchored parts yang ada
		for _, v in ipairs(Workspace:GetDescendants()) do
			if v:IsA("BasePart") and not v.Anchored then
				ForcePart(v)
			end
		end

		-- Monitor parts baru yang muncul
		DescendantAddedConnection = Workspace.DescendantAdded:Connect(function(v)
			if blackHoleActive and v:IsA("BasePart") and not v.Anchored then
				task.wait(0.1) -- Tunggu sebentar agar part fully loaded
				ForcePart(v)
			end
		end)

		-- Update posisi target secara real-time
		UpdateConnection = RunService.RenderStepped:Connect(function()
			if blackHoleActive and humanoidRootPart then
				-- Jarak 30x lipat: -50 * 30 = -1500 studs ke bawah
				Attachment1.WorldCFrame = humanoidRootPart.CFrame * CFrame.new(0, -1500, 0)
			end
		end)
	else
		Button.Text = "Bring Parts | Off"
		
		-- Disconnect semua connection
		if DescendantAddedConnection then
			DescendantAddedConnection:Disconnect()
		end
		if UpdateConnection then
			UpdateConnection:Disconnect()
		end
		
		-- Hapus semua AlignPosition dan Torque yang dibuat
		for _, v in ipairs(Workspace:GetDescendants()) do
			if v:IsA("BasePart") then
				if v:FindFirstChild("AlignPosition") then
					v:FindFirstChild("AlignPosition"):Destroy()
				end
				if v:FindFirstChild("Torque") then
					v:FindFirstChild("Torque"):Destroy()
				end
				if v:FindFirstChild("Attachment") then
					v:FindFirstChild("Attachment"):Destroy()
				end
			end
		end
	end
end

Button.MouseButton1Click:Connect(function()
	toggleBlackHole()
end)
