-- Gui to Lua
-- Version: 3.2 - REAL BRING (NO ADMIN REQUIRED)

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

local mainStatus = true
UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
	if input.KeyCode == Enum.KeyCode.RightControl and not gameProcessedEvent then
		mainStatus = not mainStatus
		Main.Visible = mainStatus
	end
end)

-- REAL BRING WITHOUT ADMIN - Menggunakan Network Ownership
local function ForcePart(v)
	if v:IsA("BasePart") 
		and not v.Anchored
		and not v.Parent:FindFirstChildOfClass("Humanoid")
		and not v.Parent:FindFirstChild("Head")
		and v.Name ~= "Handle"
	then
		-- CEK apakah part bisa di-claim ownership
		local canOwn = pcall(function()
			if v:CanSetNetworkOwnership() then
				-- CLAIM NETWORK OWNERSHIP ke LocalPlayer
				v:SetNetworkOwnership(LocalPlayer)
			end
		end)
		
		if canOwn then
			-- Hapus semua constraint lama
			for _, x in ipairs(v:GetChildren()) do
				if x:IsA("BodyMover") or x:IsA("BodyPosition") or x:IsA("BodyVelocity") or x:IsA("BodyGyro") or x:IsA("AlignPosition") or x:IsA("Torque") then
					x:Destroy()
				end
			end
			
			v.CanCollide = false
			v.Massless = true
			
			-- BODYVELOCITY - Lebih smooth dan ter-replikasi dengan network ownership
			local bodyVelocity = Instance.new("BodyVelocity")
			bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
			bodyVelocity.Velocity = Vector3.new(0, 0, 0)
			bodyVelocity.P = 1250
			bodyVelocity.Parent = v
			
			-- BODYGYRO - Stabilitas rotasi
			local bodyGyro = Instance.new("BodyGyro")
			bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
			bodyGyro.P = 10000
			bodyGyro.D = 500
			bodyGyro.CFrame = v.CFrame
			bodyGyro.Parent = v
			
			-- Tag untuk tracking
			v:SetAttribute("FayintXBring", true)
		end
	end
end

local bringActive = false
local descendantAddedConnection
local updateConnection

local function toggleBring()
	bringActive = not bringActive
	if bringActive then
		Button.Text = "Bring | On"
		
		-- Apply ke semua parts yang bisa di-own
		for _, v in ipairs(Workspace:GetDescendants()) do
			task.spawn(ForcePart, v)
		end

		-- Monitor parts baru
		descendantAddedConnection = Workspace.DescendantAdded:Connect(function(v)
			if bringActive then
				task.wait(0.1) -- Wait for part to load
				task.spawn(ForcePart, v)
			end
		end)

		-- UPDATE LOOP menggunakan BodyVelocity untuk smooth movement
		updateConnection = RunService.Heartbeat:Connect(function(deltaTime)
			if humanoidRootPart and bringActive then
				local targetPos = humanoidRootPart.Position
				
				for _, v in ipairs(Workspace:GetDescendants()) do
					if v:IsA("BasePart") and v:GetAttribute("FayintXBring") then
						local bodyVel = v:FindFirstChildOfClass("BodyVelocity")
						if bodyVel and v.Parent then
							-- Hitung direction dan distance
							local direction = (targetPos - v.Position)
							local distance = direction.Magnitude
							
							if distance > 0.5 then
								-- Velocity berdasarkan jarak (semakin jauh semakin cepat)
								local speed = math.clamp(distance * 10, 50, 500)
								bodyVel.Velocity = direction.Unit * speed
							else
								-- Jika sudah dekat, perlambat
								bodyVel.Velocity = direction * 20
							end
							
							-- Update ownership terus menerus
							pcall(function()
								if v:CanSetNetworkOwnership() then
									v:SetNetworkOwnership(LocalPlayer)
								end
							end)
						end
					end
				end
			end
		end)
	else
		Button.Text = "Bring | Off"
		
		-- Disconnect semua connections
		if descendantAddedConnection then
			descendantAddedConnection:Disconnect()
			descendantAddedConnection = nil
		end
		
		if updateConnection then
			updateConnection:Disconnect()
			updateConnection = nil
		end
		
		-- Cleanup
		for _, v in ipairs(Workspace:GetDescendants()) do
			if v:IsA("BasePart") and v:GetAttribute("FayintXBring") then
				v:SetAttribute("FayintXBring", nil)
				
				-- Hapus BodyMovers
				for _, x in ipairs(v:GetChildren()) do
					if x:IsA("BodyVelocity") or x:IsA("BodyGyro") or x:IsA("BodyPosition") then
						x:Destroy()
					end
				end
				
				-- Release network ownership
				pcall(function()
					if v:CanSetNetworkOwnership() then
						v:SetNetworkOwnershipAuto()
					end
				end)
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
