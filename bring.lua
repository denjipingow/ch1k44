-- Gui to Lua
-- Version: 3.2 MASSIVE EDITION

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
Label.Text = "MASSIVE Bring Parts - FayintXHub"
Label.TextColor3 = Color3.fromRGB(255, 0, 0)
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
Button.Text = "MASSIVE | OFF"
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

local mainStatus = true
UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
	if input.KeyCode == Enum.KeyCode.RightControl and not gameProcessedEvent then
		mainStatus = not mainStatus
		Main.Visible = mainStatus
	end
end)

-- Multiple target parts untuk tarikan masif
local targetFolder = Instance.new("Folder", Workspace)
targetFolder.Name = "MassiveBringTarget_FayintX"

-- Membuat multiple anchor points untuk tarikan yang lebih kuat
local targetParts = {}
local targetAttachments = {}

for i = 1, 10 do -- 10 anchor points untuk tarikan super masif
	local targetPart = Instance.new("Part", targetFolder)
	local targetAttachment = Instance.new("Attachment", targetPart)
	targetPart.Anchored = true
	targetPart.CanCollide = false
	targetPart.Transparency = 1
	targetPart.Size = Vector3.new(0.01, 0.01, 0.01)
	targetPart.Name = "MassiveAnchor" .. i
	
	table.insert(targetParts, targetPart)
	table.insert(targetAttachments, targetAttachment)
end

-- Fungsi untuk memaksa part bergerak ke target dengan kekuatan MASIF
local function ForcePart(v)
	if v:IsA("BasePart") 
		and not v.Anchored
		and not v.Parent:FindFirstChildOfClass("Humanoid")
		and not v.Parent:FindFirstChild("Head")
		and v.Name ~= "Handle"
		and not v:IsDescendantOf(targetFolder)
	then
		-- Hapus semua physics constraint yang ada
		for _, x in ipairs(v:GetChildren()) do
			if x:IsA("BodyMover") or x:IsA("RocketPropulsion") or x:IsA("AlignPosition") or x:IsA("Torque") or x:IsA("BodyVelocity") or x:IsA("BodyPosition") then
				x:Destroy()
			end
		end
		
		-- Nonaktifkan semua collision
		v.CanCollide = false
		v.CanTouch = false
		v.CanQuery = false
		
		-- Set properties untuk tarikan maksimal
		if v:IsA("Part") then
			v.CustomPhysicalProperties = PhysicalProperties.new(
				0.01, -- Density super ringan
				0, -- Friction nol
				0, -- Elasticity nol
				1, -- ElasticityWeight
				1  -- FrictionWeight
			)
		end
		
		-- Buat multiple AlignPosition untuk tarikan MASIF
		for i = 1, math.min(3, #targetAttachments) do -- 3 AlignPosition per part
			local alignPosition = Instance.new("AlignPosition", v)
			local attachmentInPart = Instance.new("Attachment", v)
			attachmentInPart.Name = "MassiveAttachment" .. i
			
			-- KONFIGURASI MASIF
			alignPosition.MaxForce = math.huge
			alignPosition.MaxVelocity = math.huge
			alignPosition.Responsiveness = 200 -- Maksimal responsiveness
			alignPosition.RigidityEnabled = true -- Enable rigidity untuk tarikan instant
			alignPosition.ApplyAtCenterOfMass = true
			alignPosition.Mode = Enum.PositionAlignmentMode.OneAttachment
			alignPosition.Attachment0 = attachmentInPart
			alignPosition.Attachment1 = targetAttachments[i]
		end
		
		-- BodyVelocity untuk boost kecepatan
		local bodyVelocity = Instance.new("BodyVelocity", v)
		bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
		bodyVelocity.Velocity = Vector3.new(0, 0, 0)
		
		-- BodyPosition sebagai backup
		local bodyPosition = Instance.new("BodyPosition", v)
		bodyPosition.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
		bodyPosition.D = 10000 -- Damping super tinggi
		bodyPosition.P = 1000000 -- Power super tinggi
		
		-- Anti-rotation dengan Torque masif
		local torque = Instance.new("Torque", v)
		torque.Torque = Vector3.new(math.huge, math.huge, math.huge)
		torque.Attachment0 = v:FindFirstChildOfClass("Attachment")
		
		-- BodyAngularVelocity untuk stop rotasi
		local bodyAngularVelocity = Instance.new("BodyAngularVelocity", v)
		bodyAngularVelocity.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
		bodyAngularVelocity.AngularVelocity = Vector3.new(0, 0, 0)
	end
end

local bringActive = false
local descendantAddedConnection
local heartbeatConnection

local function toggleBring()
	bringActive = not bringActive
	if bringActive then
		Button.Text = "MASSIVE | ON"
		Button.TextColor3 = Color3.fromRGB(0, 255, 0)
		
		-- Process semua parts yang ada
		for _, v in ipairs(Workspace:GetDescendants()) do
			task.spawn(ForcePart, v)
		end

		-- Auto-process parts baru
		descendantAddedConnection = Workspace.DescendantAdded:Connect(function(v)
			if bringActive then
				task.spawn(ForcePart, v)
			end
		end)

		-- Update posisi target dengan multiple threads
		spawn(function()
			while bringActive and task.wait() do
				if humanoidRootPart then
					local cf = humanoidRootPart.CFrame
					
					-- Update semua anchor points
					for i, attachment in ipairs(targetAttachments) do
						local offset = CFrame.new(
							math.sin(i * math.pi / 5) * 0.1,
							math.cos(i * math.pi / 5) * 0.1,
							0
						)
						attachment.WorldCFrame = cf * offset
					end
					
					-- Update BodyPosition & BodyVelocity untuk semua parts
					for _, v in ipairs(Workspace:GetDescendants()) do
						if v:IsA("BodyPosition") then
							v.Position = cf.Position
						elseif v:IsA("BodyVelocity") then
							local part = v.Parent
							if part and part:IsA("BasePart") then
								local direction = (cf.Position - part.Position).Unit
								v.Velocity = direction * 10000 -- Kecepatan masif
							end
						end
					end
				end
			end
		end)
		
		-- Extra heartbeat connection untuk update super cepat
		heartbeatConnection = RunService.Heartbeat:Connect(function()
			if bringActive and humanoidRootPart then
				local cf = humanoidRootPart.CFrame
				
				-- Force update posisi parts yang jauh
				for _, v in ipairs(Workspace:GetDescendants()) do
					if v:IsA("BasePart") and not v.Anchored and not v:IsDescendantOf(targetFolder) then
						local distance = (v.Position - cf.Position).Magnitude
						
						-- Teleport parts yang terlalu jauh
						if distance > 100 then
							v.CFrame = cf + Vector3.new(
								math.random(-5, 5),
								math.random(0, 10),
								math.random(-5, 5)
							)
						end
					end
				end
			end
		end)
		
	else
		Button.Text = "MASSIVE | OFF"
		Button.TextColor3 = Color3.fromRGB(255, 255, 255)
		
		if descendantAddedConnection then
			descendantAddedConnection:Disconnect()
			descendantAddedConnection = nil
		end
		
		if heartbeatConnection then
			heartbeatConnection:Disconnect()
			heartbeatConnection = nil
		end
		
		-- Cleanup semua physics objects
		for _, v in ipairs(Workspace:GetDescendants()) do
			if v:IsA("AlignPosition") or v:IsA("Torque") or v:IsA("BodyVelocity") or v:IsA("BodyPosition") or v:IsA("BodyAngularVelocity") then
				local parent = v.Parent
				if parent and not parent:FindFirstChildOfClass("Humanoid") then
					v:Destroy()
				end
			end
			
			-- Cleanup attachments
			if v:IsA("Attachment") and v.Name:match("MassiveAttachment") then
				v:Destroy()
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
			print("MASSIVE TARGET SET:", player.Name)
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
		print("SELECT TARGET FIRST!")
	end
end)
