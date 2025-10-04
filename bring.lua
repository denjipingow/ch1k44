-- Gui to Lua
-- Version: 3.2 - ONLY UNANCHORED PARTS - INFINITE RANGE

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
Box.PlaceholderText = "Target Player"
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
Label.Text = "Bring UNANCHORED Parts [∞ RANGE]"
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
Button.Text = "Bring To Target | Off"
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

local targetCharacter
local targetHumanoidRootPart
local targetPlayer

mainStatus = true
UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
	if input.KeyCode == Enum.KeyCode.RightControl and not gameProcessedEvent then
		mainStatus = not mainStatus
		Main.Visible = mainStatus
	end
end)

local Folder = Instance.new("Folder", Workspace)
Folder.Name = "BringPartsFolder"
local Part = Instance.new("Part", Folder)
local Attachment1 = Instance.new("Attachment", Part)
Part.Anchored = true
Part.CanCollide = false
Part.Transparency = 1
Part.Size = Vector3.new(0.1, 0.1, 0.1)

-- STORAGE UNTUK PARTS YANG SUDAH DIMODIFIKASI
local ModifiedParts = {}

-- EXTREME NETWORK SETTINGS - INFINITE RANGE
if not getgenv().Network then
	getgenv().Network = {
		BaseParts = {},
		Velocity = Vector3.new(14462.62424, 14462.62424, 14462.62424),
		SimulationRadius = math.huge * 9e9
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
			sethiddenproperty(LocalPlayer, "SimulationRadius", math.huge * 9e9)
			sethiddenproperty(LocalPlayer, "MaxSimulationRadius", math.huge * 9e9)
			
			for _, Part in pairs(Network.BaseParts) do
				if Part:IsDescendantOf(Workspace) then
					Part.Velocity = Network.Velocity
				end
			end
		end)
	end

	EnablePartControl()
end

-- FUNGSI CEK APAKAH PART ADALAH BAGIAN DARI CHARACTER
local function IsPartOfCharacter(part)
	local parent = part.Parent
	if parent then
		-- Cek apakah parent punya Humanoid (character)
		if parent:FindFirstChildOfClass("Humanoid") then
			return true
		end
		-- Cek apakah parent adalah character dari player manapun
		for _, player in pairs(Players:GetPlayers()) do
			if player.Character and part:IsDescendantOf(player.Character) then
				return true
			end
		end
	end
	return false
end

-- BLACKLIST - Parts yang TIDAK boleh diambil
local BlacklistedNames = {
	"Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg",
	"HumanoidRootPart", "Handle", "UpperTorso", "LowerTorso",
	"LeftUpperArm", "LeftLowerArm", "LeftHand", "RightUpperArm", 
	"RightLowerArm", "RightHand", "LeftUpperLeg", "LeftLowerLeg",
	"LeftFoot", "RightUpperLeg", "RightLowerLeg", "RightFoot"
}

local function IsBlacklisted(partName)
	for _, name in pairs(BlacklistedNames) do
		if partName == name then
			return true
		end
	end
	return false
end

-- FUNGSI FORCE PART - HANYA UNANCHORED PARTS
local function ForcePart(v)
	-- FILTER KETAT - HANYA UNANCHORED PARTS
	if not v:IsA("BasePart") then 
		return -- Bukan BasePart
	end
	
	if v.Anchored then 
		return -- ANCHORED - SKIP!
	end
	
	-- CEK BLACKLIST
	if IsBlacklisted(v.Name) then
		return -- Part dalam blacklist
	end
	
	-- CEK APAKAH BAGIAN DARI CHARACTER
	if IsPartOfCharacter(v) then
		return -- Bagian dari character player
	end
	
	-- CEK PARENT
	local parent = v.Parent
	if not parent then 
		return -- Tidak punya parent
	end
	
	-- SKIP jika parent punya Humanoid
	if parent:FindFirstChildOfClass("Humanoid") then
		return
	end
	
	-- SKIP jika parent adalah character
	if parent:FindFirstChild("Head") and parent:FindFirstChild("Humanoid") then
		return
	end
	
	-- SKIP folder script
	if v:IsDescendantOf(Folder) then
		return
	end
	
	-- CEK APAKAH PART SUDAH PERNAH DIMODIFIKASI
	if ModifiedParts[v] then
		local data = ModifiedParts[v]
		if data.AlignPosition then
			data.AlignPosition.Enabled = true
		end
		if data.Torque then
			data.Torque.Enabled = true
		end
		-- BOOST VELOCITY MENUJU TARGET PLAYER
		if targetHumanoidRootPart then
			local direction = (targetHumanoidRootPart.Position - v.Position).Unit
			v.Velocity = direction * 50000
		end
		return
	end
	
	-- DOUBLE CHECK - PASTIKAN UNANCHORED
	if v.Anchored == true then
		return -- Safety check kedua
	end
	
	-- SETUP PART - HANYA UNANCHORED
	v.CanCollide = false
	v.Massless = true
	v.CustomPhysicalProperties = PhysicalProperties.new(0.001, 0, 0, 0, 0)
	
	-- TORQUE EXTREME
	local Torque = v:FindFirstChild("ExtremeTorque")
	if not Torque then
		Torque = Instance.new("Torque")
		Torque.Name = "ExtremeTorque"
		Torque.Torque = Vector3.new(100000000, 100000000, 100000000)
		Torque.Parent = v
	end
	
	local Attachment2 = v:FindFirstChild("ExtremeAttachment")
	if not Attachment2 then
		Attachment2 = Instance.new("Attachment")
		Attachment2.Name = "ExtremeAttachment"
		Attachment2.Parent = v
	end
	
	-- ALIGN POSITION - MENUJU TARGET PLAYER
	local AlignPosition = v:FindFirstChild("ExtremeAlign")
	if not AlignPosition then
		AlignPosition = Instance.new("AlignPosition")
		AlignPosition.Name = "ExtremeAlign"
		
		AlignPosition.MaxForce = math.huge * 9e9
		AlignPosition.MaxVelocity = math.huge
		AlignPosition.Responsiveness = 200000
		AlignPosition.ApplyAtCenterOfMass = true
		AlignPosition.ReactionForceEnabled = false
		AlignPosition.RigidityEnabled = true
		
		AlignPosition.Attachment0 = Attachment2
		AlignPosition.Attachment1 = Attachment1
		AlignPosition.Parent = v
	else
		AlignPosition.MaxForce = math.huge * 9e9
		AlignPosition.Responsiveness = 200000
		AlignPosition.Attachment1 = Attachment1
	end
	
	Torque.Attachment0 = Attachment2
	
	-- BOOST INITIAL VELOCITY MENUJU TARGET PLAYER
	if targetHumanoidRootPart then
		local direction = (targetHumanoidRootPart.Position - v.Position).Unit
		v.Velocity = direction * 50000
		v.AssemblyLinearVelocity = direction * 50000
	end
	
	ModifiedParts[v] = {
		AlignPosition = AlignPosition,
		Torque = Torque,
		Attachment = Attachment2
	}
	
	print("[UNANCHORED] Bringing part:", v.Name, "| Parent:", v.Parent.Name)
end

local blackHoleActive = false
local DescendantAddedConnection
local UpdateConnection
local VelocityBoostConnection
local AnchorCheckConnection

-- INSTANT TOGGLE - BRING TO TARGET
local function toggleBlackHole()
	blackHoleActive = not blackHoleActive
	if blackHoleActive then
		Button.Text = "Bringing to " .. targetPlayer.Name
		
		-- INSTANT SCAN - HANYA UNANCHORED
		local descendants = Workspace:GetDescendants()
		local count = 0
		for i = 1, #descendants do
			local v = descendants[i]
			if v:IsA("BasePart") and not v.Anchored then
				ForcePart(v)
				count = count + 1
			end
		end
		print("Found " .. count .. " unanchored parts")

		-- MONITOR PARTS BARU - HANYA UNANCHORED
		DescendantAddedConnection = Workspace.DescendantAdded:Connect(function(v)
			if v:IsA("BasePart") and not v.Anchored then
				ForcePart(v)
			end
		end)

		-- UPDATE POSISI TARGET PLAYER SETIAP FRAME
		UpdateConnection = RunService.Heartbeat:Connect(function()
			if targetHumanoidRootPart and targetHumanoidRootPart.Parent then
				local cf = targetHumanoidRootPart.CFrame
				Attachment1.WorldCFrame = cf
				Part.CFrame = cf
			else
				if targetPlayer and targetPlayer.Character then
					targetCharacter = targetPlayer.Character
					targetHumanoidRootPart = targetCharacter:FindFirstChild("HumanoidRootPart")
				end
			end
		end)
		
		-- VELOCITY BOOST + ANCHOR CHECK
		VelocityBoostConnection = RunService.Heartbeat:Connect(function()
			if targetHumanoidRootPart and targetHumanoidRootPart.Parent then
				for part, data in pairs(ModifiedParts) do
					if part:IsDescendantOf(Workspace) and data.AlignPosition.Enabled then
						
						-- CEK JIKA PART TIBA-TIBA ANCHORED - DISABLE
						if part.Anchored then
							data.AlignPosition.Enabled = false
							data.Torque.Enabled = false
							print("[ANCHORED DETECTED] Disabled:", part.Name)
							continue
						end
						
						local distance = (targetHumanoidRootPart.Position - part.Position).Magnitude
						
						if distance > 100 then
							local direction = (targetHumanoidRootPart.Position - part.Position).Unit
							local boostMultiplier = math.min(distance / 10, 10000)
							part.Velocity = direction * (50000 * boostMultiplier)
							part.AssemblyLinearVelocity = direction * (50000 * boostMultiplier)
							
							if distance > 1000 then
								data.AlignPosition.Responsiveness = 500000
							elseif distance > 500 then
								data.AlignPosition.Responsiveness = 300000
							else
								data.AlignPosition.Responsiveness = 200000
							end
						end
					end
				end
			end
		end)
		
		-- ANCHOR MONITOR - CEK PERUBAHAN ANCHOR
		AnchorCheckConnection = RunService.Heartbeat:Connect(function()
			for part, data in pairs(ModifiedParts) do
				if part.Anchored and data.AlignPosition.Enabled then
					-- Part di-anchor, disable
					data.AlignPosition.Enabled = false
					data.Torque.Enabled = false
				elseif not part.Anchored and not data.AlignPosition.Enabled and blackHoleActive then
					-- Part di-unanchor, enable kembali
					data.AlignPosition.Enabled = true
					data.Torque.Enabled = true
				end
			end
		end)
		
	else
		Button.Text = "Bring To Target | Off"
		
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
		if VelocityBoostConnection then
			VelocityBoostConnection:Disconnect()
		end
		if AnchorCheckConnection then
			AnchorCheckConnection:Disconnect()
		end
	end
end

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

local function VDOYZQL_fake_script()
	local script = Instance.new('Script', Box)

	script.Parent.FocusLost:Connect(function(enterPressed)
		if enterPressed then
			targetPlayer = getPlayer(Box.Text)
			if targetPlayer then
				Box.Text = targetPlayer.Name
				print("Target Player:", targetPlayer.Name)
			else
				print("Player not found")
			end
		end
	end)
end
coroutine.wrap(VDOYZQL_fake_script)()

local function JUBNQKI_fake_script()
	local script = Instance.new('Script', Button)

	script.Parent.MouseButton1Click:Connect(function()
		if targetPlayer then
			targetCharacter = targetPlayer.Character
			if targetCharacter then
				targetHumanoidRootPart = targetCharacter:FindFirstChild("HumanoidRootPart")
				if targetHumanoidRootPart then
					toggleBlackHole()
				else
					print("Target HumanoidRootPart not found")
				end
			else
				local conn
				conn = targetPlayer.CharacterAdded:Connect(function(char)
					targetCharacter = char
					targetHumanoidRootPart = targetCharacter:FindFirstChild("HumanoidRootPart")
					if targetHumanoidRootPart and not blackHoleActive then
						toggleBlackHole()
					end
					conn:Disconnect()
				end)
				print("Waiting for target character...")
			end
		else
			print("Please select a target player first")
		end
	end)
end
coroutine.wrap(JUBNQKI_fake_script)()

RunService.Heartbeat:Connect(function()
	if targetPlayer and targetPlayer.Character and not targetHumanoidRootPart then
		targetCharacter = targetPlayer.Character
		targetHumanoidRootPart = targetCharacter:FindFirstChild("HumanoidRootPart")
	end
	
	if targetHumanoidRootPart and not targetHumanoidRootPart.Parent then
		if targetPlayer and targetPlayer.Character then
			targetCharacter = targetPlayer.Character
			targetHumanoidRootPart = targetCharacter:FindFirstChild("HumanoidRootPart")
		end
	end
	
	sethiddenproperty(LocalPlayer, "SimulationRadius", math.huge * 9e9)
end)

Players.PlayerRemoving:Connect(function(player)
	if player == targetPlayer then
		if blackHoleActive then
			toggleBlackHole()
		end
		print("Target player left the game")
		Box.Text = ""
		targetPlayer = nil
		targetCharacter = nil
		targetHumanoidRootPart = nil
	end
end)
