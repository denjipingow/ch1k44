-- Gui to Lua
-- Version: 3.2 - Ultra Power Edition

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

-- ULTRA EXTREME FORCE VALUES (100× LIPAT)
local ULTRA_FORCE = 5000000 -- 100× dari 50,000
local ULTRA_VELOCITY = 50000 -- 100× dari 500
local ULTRA_POWER = 5000000
local ULTRA_RANGE = 200000 -- 1000× dari 200 (200,000 studs)
local TELEPORT_THRESHOLD = 15000 -- 1000× dari 15

-- Fungsi untuk apply ULTRA FORCE ke part (TIDAK VISUAL, REAL PHYSICS)
local function applyUltraForce(v)
	if not v:IsA("BasePart") then return end
	if v.Anchored then return end
	if v.Parent:FindFirstChildOfClass("Humanoid") then return end
	if v.Parent:FindFirstChild("Head") then return end
	if v.Name == "Handle" then return end
	
	-- Clear existing constraints
	pcall(function()
		for _, x in ipairs(v:GetChildren()) do
			if x:IsA("BodyMover") or x:IsA("Constraint") then
				x:Destroy()
			end
		end
	end)
	
	-- Set physical properties untuk REAL movement
	pcall(function()
		v.CanCollide = false
		v.CanTouch = false
		v.CanQuery = false
		v.CustomPhysicalProperties = PhysicalProperties.new(0.01, 0.1, 0, 0.5, 0.5)
	end)
	
	-- ULTRA BODY VELOCITY (REAL FORCE)
	local bodyVel = Instance.new("BodyVelocity")
	bodyVel.Name = "UltraBringVelocity"
	bodyVel.MaxForce = Vector3.new(ULTRA_FORCE, ULTRA_FORCE, ULTRA_FORCE)
	bodyVel.Velocity = Vector3.new(0, 0, 0)
	bodyVel.Parent = v
	
	-- ULTRA BODY POSITION (REAL FORCE)
	local bodyPos = Instance.new("BodyPosition")
	bodyPos.Name = "UltraBringPosition"
	bodyPos.MaxForce = Vector3.new(ULTRA_FORCE, ULTRA_FORCE, ULTRA_FORCE)
	bodyPos.P = ULTRA_POWER
	bodyPos.D = ULTRA_POWER / 50
	bodyPos.Position = humanoidRootPart.Position
	bodyPos.Parent = v
	
	-- ADDITIONAL BODY GYRO untuk stability
	local bodyGyro = Instance.new("BodyGyro")
	bodyGyro.Name = "UltraBringGyro"
	bodyGyro.MaxTorque = Vector3.new(ULTRA_FORCE, ULTRA_FORCE, ULTRA_FORCE)
	bodyGyro.P = ULTRA_POWER / 10
	bodyGyro.D = ULTRA_POWER / 100
	bodyGyro.Parent = v
end

local bringActive = false
local descendantAddedConnection
local updateConnections = {}

-- ULTRA AGGRESSIVE FORCE LOOP (REAL PHYSICS)
local function ultraForceLoop()
	-- Multi-threaded ultra force application
	for threadId = 1, 5 do
		local updateConnection = RunService.Heartbeat:Connect(function()
			if not bringActive then return end
			if not humanoidRootPart or not humanoidRootPart.Parent then return end
			
			pcall(function()
				local targetPos = humanoidRootPart.Position
				local partsProcessed = 0
				
				for _, v in ipairs(Workspace:GetDescendants()) do
					if v:IsA("BasePart") and not v.Anchored then
						-- Cek jarak dalam ULTRA RANGE
						local distance = (v.Position - targetPos).Magnitude
						
						if distance <= ULTRA_RANGE then
							partsProcessed = partsProcessed + 1
							
							-- Apply force jika belum ada
							local bodyPos = v:FindFirstChild("UltraBringPosition")
							local bodyVel = v:FindFirstChild("UltraBringVelocity")
							local bodyGyro = v:FindFirstChild("UltraBringGyro")
							
							if not bodyPos or not bodyVel or not bodyGyro then
								task.spawn(applyUltraForce, v)
							else
								-- Update REAL forces
								bodyPos.Position = targetPos
								bodyPos.MaxForce = Vector3.new(ULTRA_FORCE, ULTRA_FORCE, ULTRA_FORCE)
								
								-- Calculate velocity dengan ULTRA SPEED
								local direction = (targetPos - v.Position)
								if direction.Magnitude > 1 then
									local speed = math.min(direction.Magnitude * 10, ULTRA_VELOCITY)
									bodyVel.Velocity = direction.Unit * speed
									bodyVel.MaxForce = Vector3.new(ULTRA_FORCE, ULTRA_FORCE, ULTRA_FORCE)
								else
									bodyVel.Velocity = Vector3.new(0, 0, 0)
								end
								
								-- Update gyro untuk stabilitas
								bodyGyro.CFrame = humanoidRootPart.CFrame
							end
							
							-- INSTANT TELEPORT jika terlalu jauh (REAL PULL)
							if distance > TELEPORT_THRESHOLD then
								v.CFrame = CFrame.new(targetPos + Vector3.new(
									math.random(-20, 20),
									math.random(-20, 20),
									math.random(-20, 20)
								))
								v.Velocity = Vector3.new(0, 0, 0)
								v.RotVelocity = Vector3.new(0, 0, 0)
							end
						end
					end
					
					-- Limit per frame untuk performance
					if partsProcessed >= 50 then
						break
					end
				end
			end)
		end)
		
		table.insert(updateConnections, updateConnection)
	end
end

local function toggleBring()
	bringActive = not bringActive
	if bringActive then
		Button.Text = "Bring | On"
		
		-- INSTANT APPLY TO ALL PARTS IN RANGE (MULTIPLE PASSES)
		for pass = 1, 3 do
			task.spawn(function()
				for _, v in ipairs(Workspace:GetDescendants()) do
					if v:IsA("BasePart") and not v.Anchored and humanoidRootPart then
						local distance = (v.Position - humanoidRootPart.Position).Magnitude
						if distance <= ULTRA_RANGE then
							task.spawn(applyUltraForce, v)
						end
					end
				end
			end)
			task.wait(0.05)
		end
		
		-- MONITOR NEW PARTS (ULTRA AGGRESSIVE)
		descendantAddedConnection = Workspace.DescendantAdded:Connect(function(v)
			if bringActive and v:IsA("BasePart") and humanoidRootPart then
				task.wait(0.05)
				local distance = (v.Position - humanoidRootPart.Position).Magnitude
				if distance <= ULTRA_RANGE then
					for i = 1, 2 do
						task.spawn(applyUltraForce, v)
					end
				end
			end
		end)
		
		-- START ULTRA FORCE LOOPS
		ultraForceLoop()
		
		-- ADDITIONAL TELEPORT LOOP untuk parts yang sangat jauh
		task.spawn(function()
			while bringActive do
				pcall(function()
					if humanoidRootPart then
						local targetPos = humanoidRootPart.Position
						for _, v in ipairs(Workspace:GetDescendants()) do
							if v:IsA("BasePart") and not v.Anchored then
								local distance = (v.Position - targetPos).Magnitude
								if distance > TELEPORT_THRESHOLD and distance <= ULTRA_RANGE then
									if v:FindFirstChild("UltraBringPosition") then
										-- FORCE TELEPORT untuk instant bring
										v.CFrame = CFrame.new(targetPos + Vector3.new(
											math.random(-15, 15),
											math.random(-15, 15),
											math.random(-15, 15)
										))
										v.Velocity = Vector3.new(0, 0, 0)
										v.RotVelocity = Vector3.new(0, 0, 0)
									end
								end
							end
						end
					end
				end)
				task.wait(0.1)
			end
		end)
		
	else
		Button.Text = "Bring | Off"
		
		-- DISCONNECT ALL
		if descendantAddedConnection then
			descendantAddedConnection:Disconnect()
		end
		
		for _, connection in ipairs(updateConnections) do
			connection:Disconnect()
		end
		updateConnections = {}
		
		-- AGGRESSIVE CLEANUP (REAL REMOVAL)
		for _, v in ipairs(Workspace:GetDescendants()) do
			pcall(function()
				if v.Name == "UltraBringVelocity" or v.Name == "UltraBringPosition" or v.Name == "UltraBringGyro" then
					v:Destroy()
				end
			end)
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
