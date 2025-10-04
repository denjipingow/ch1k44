-- Gui to Lua
-- Version: 3.2

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

-- Part target untuk menarik objek
local targetFolder = Instance.new("Folder", Workspace)
targetFolder.Name = "BringPartTarget_FayintX"
local targetPart = Instance.new("Part", targetFolder)
local targetAttachment = Instance.new("Attachment", targetPart)
targetPart.Anchored = true
targetPart.CanCollide = false
targetPart.Transparency = 1
targetPart.Size = Vector3.new(0.1, 0.1, 0.1)

-- SUPER EXTREME FORCE VALUES
local SUPER_FORCE = math.huge -- INFINITE FORCE
local SUPER_VELOCITY = math.huge -- INFINITE VELOCITY
local SUPER_POWER = 10^308 -- MAXIMUM FLOAT VALUE

-- Fungsi untuk INSTANT SUPER FORCE
local function InstantSuperForce(v)
	-- HANYA UNANCHORED PARTS
	if v:IsA("BasePart") 
		and not v.Anchored 
		and not v.Parent:FindFirstChildOfClass("Humanoid")
		and not v.Parent:FindFirstChild("Head")
		and v.Name ~= "Handle"
		and not v:IsDescendantOf(targetFolder)
	then
		-- INSTANT CLEAR ALL CONSTRAINTS
		pcall(function()
			for _, x in ipairs(v:GetChildren()) do
				if x:IsA("BodyMover") or x:IsA("Constraint") then
					x:Destroy()
				end
			end
		end)
		
		-- FORCE PROPERTIES
		pcall(function()
			v.CanCollide = false
			v.CanTouch = false
			v.CanQuery = false
			v.Massless = true -- Make part massless for easier movement
			v.CustomPhysicalProperties = PhysicalProperties.new(0.01, 0, 0, 0, 0) -- Minimum physical properties
		end)
		
		-- CREATE MULTIPLE ATTACHMENTS FOR MULTIPLE FORCES
		local attachments = {}
		for i = 1, 5 do -- 5 ATTACHMENTS FOR 5× FORCE
			local att = Instance.new("Attachment", v)
			att.Name = "ForceAttachment"..i
			table.insert(attachments, att)
		end
		
		-- APPLY MULTIPLE ALIGN POSITIONS (5× FORCE)
		for i, att in ipairs(attachments) do
			local alignPos = Instance.new("AlignPosition", v)
			alignPos.Name = "SuperForce"..i
			alignPos.MaxForce = SUPER_FORCE
			alignPos.MaxVelocity = SUPER_VELOCITY
			alignPos.Responsiveness = 200
			alignPos.RigidityEnabled = false
			alignPos.ApplyAtCenterOfMass = true
			alignPos.Mode = Enum.PositionAlignmentMode.OneAttachment
			alignPos.Attachment0 = att
			alignPos.Position = humanoidRootPart.Position
		end
		
		-- BODY VELOCITY WITH INFINITE FORCE
		local bodyVel = Instance.new("BodyVelocity", v)
		bodyVel.MaxForce = Vector3.new(SUPER_FORCE, SUPER_FORCE, SUPER_FORCE)
		bodyVel.Velocity = Vector3.new(0, 0, 0)
		
		-- BODY POSITION WITH INFINITE FORCE
		local bodyPos = Instance.new("BodyPosition", v)
		bodyPos.MaxForce = Vector3.new(SUPER_FORCE, SUPER_FORCE, SUPER_FORCE)
		bodyPos.P = SUPER_POWER
		bodyPos.D = SUPER_POWER / 100
		bodyPos.Position = humanoidRootPart.Position
		
		-- ROCKET PROPULSION AS ADDITIONAL FORCE
		pcall(function()
			local rocket = Instance.new("RocketPropulsion", v)
			rocket.Target = humanoidRootPart
			rocket.MaxSpeed = SUPER_VELOCITY
			rocket.MaxThrust = SUPER_FORCE
			rocket.MaxTorque = Vector3.new(SUPER_FORCE, SUPER_FORCE, SUPER_FORCE)
			rocket.ThrustP = SUPER_POWER
			rocket.ThrustD = SUPER_POWER / 100
			rocket:Fire()
		end)
		
		-- INSTANT UPDATE LOOP FOR THIS PART
		spawn(function()
			while v.Parent and bringActive do
				pcall(function()
					if humanoidRootPart then
						local targetPos = humanoidRootPart.Position
						
						-- Update all AlignPositions
						for i = 1, 5 do
							local ap = v:FindFirstChild("SuperForce"..i)
							if ap then
								ap.Position = targetPos
								ap.MaxForce = SUPER_FORCE
								ap.MaxVelocity = SUPER_VELOCITY
							end
						end
						
						-- Update BodyPosition
						if v:FindFirstChild("BodyPosition") then
							v.BodyPosition.Position = targetPos
							v.BodyPosition.MaxForce = Vector3.new(SUPER_FORCE, SUPER_FORCE, SUPER_FORCE)
						end
						
						-- Update BodyVelocity with direction
						if v:FindFirstChild("BodyVelocity") then
							local direction = (targetPos - v.Position)
							if direction.Magnitude > 0.1 then
								v.BodyVelocity.Velocity = direction.Unit * 999999
							else
								v.BodyVelocity.Velocity = Vector3.new(0, 0, 0)
							end
						end
						
						-- TELEPORT IF TOO FAR (INSTANT BRING)
						if (v.Position - targetPos).Magnitude > 100 then
							v.CFrame = humanoidRootPart.CFrame
						end
					end
				end)
				RunService.Heartbeat:Wait() -- Fastest possible update
			end
		end)
	end
end

-- AGGRESSIVE CONTINUOUS FORCE APPLICATION
local function AggressiveContinuousForce()
	-- MULTIPLE LOOPS FOR MAXIMUM FORCE
	for loop = 1, 3 do -- 3 PARALLEL LOOPS
		spawn(function()
			while bringActive do
				pcall(function()
					for _, v in ipairs(Workspace:GetDescendants()) do
						if v:IsA("BasePart") and not v.Anchored then
							-- RE-APPLY IF MISSING FORCES
							if not v:FindFirstChild("SuperForce1") then
								task.spawn(InstantSuperForce, v)
							end
							
							-- FORCE UPDATE POSITION
							if humanoidRootPart and (v.Position - humanoidRootPart.Position).Magnitude > 50 then
								pcall(function()
									v.CFrame = humanoidRootPart.CFrame + Vector3.new(math.random(-5, 5), math.random(-5, 5), math.random(-5, 5))
								end)
							end
						end
					end
				end)
				if loop == 1 then
					RunService.Heartbeat:Wait()
				elseif loop == 2 then
					task.wait(0.05)
				else
					task.wait(0.1)
				end
			end
		end)
	end
end

local bringActive = false
local descendantAddedConnection
local heartbeatConnection

local function toggleBring()
	bringActive = not bringActive
	if bringActive then
		Button.Text = "Bring | On"
		
		-- INSTANT APPLY TO ALL PARTS (MULTIPLE TIMES)
		for iteration = 1, 3 do -- APPLY 3 TIMES FOR TRIPLE FORCE
			spawn(function()
				for _, v in ipairs(Workspace:GetDescendants()) do
					task.spawn(InstantSuperForce, v)
				end
			end)
			task.wait(0.01)
		end
		
		-- MONITOR NEW PARTS
		descendantAddedConnection = Workspace.DescendantAdded:Connect(function(v)
			if bringActive then
				for i = 1, 3 do -- APPLY 3 TIMES TO NEW PARTS
					task.spawn(InstantSuperForce, v)
				end
			end
		end)
		
		-- START AGGRESSIVE LOOPS
		AggressiveContinuousForce()
		
		-- HEARTBEAT CONNECTION FOR INSTANT UPDATES
		heartbeatConnection = RunService.Heartbeat:Connect(function()
			if humanoidRootPart then
				targetPart.CFrame = humanoidRootPart.CFrame
				targetAttachment.WorldCFrame = humanoidRootPart.CFrame
			end
		end)
		
		-- SUPER AGGRESSIVE MAIN LOOP
		spawn(function()
			while bringActive do
				pcall(function()
					-- FORCE ALL UNANCHORED PARTS EVERY FRAME
					for _, v in ipairs(Workspace:GetDescendants()) do
						if v:IsA("BasePart") and not v.Anchored and humanoidRootPart then
							-- INSTANT TELEPORT IF FAR
							if (v.Position - humanoidRootPart.Position).Magnitude > 200 then
								v.CFrame = humanoidRootPart.CFrame
							end
						end
					end
				end)
				RunService.Heartbeat:Wait()
			end
		end)
		
	else
		Button.Text = "Bring | Off"
		
		-- DISCONNECT ALL
		if descendantAddedConnection then
			descendantAddedConnection:Disconnect()
		end
		if heartbeatConnection then
			heartbeatConnection:Disconnect()
		end
		
		-- AGGRESSIVE CLEANUP
		for _, v in ipairs(Workspace:GetDescendants()) do
			pcall(function()
				if v:IsA("AlignPosition") or v:IsA("BodyVelocity") or v:IsA("BodyPosition") or v:IsA("RocketPropulsion") then
					if v.Parent and not v.Parent:FindFirstChildOfClass("Humanoid") then
						v:Destroy()
					end
				end
				if v.Name:match("ForceAttachment") then
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
