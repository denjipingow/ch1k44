-- Gui to Lua
-- Version: 4.0 (VOID TELEPORT - ULTIMATE PERFORMANCE EDITION)

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local HttpService = game:GetService("HttpService")
local Stats = game:GetService("Stats")

-- Performance Monitor
local PERFORMANCE_MODE = true
local MAX_PARTS_PER_FRAME = 10
local FRAME_BUDGET = 1/60 * 0.5 -- Use only 50% of frame time

-- Instances:
local Gui = Instance.new("ScreenGui")
local Main = Instance.new("Frame")

--Properties:
Gui.Name = "VoidTeleportGUI"
Gui.Parent = gethui and gethui() or game:GetService("CoreGui")
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.ResetOnSpawn = false
Gui.DisplayOrder = 999

-- Glass Effect Background Blur
local BlurFrame = Instance.new("Frame")
BlurFrame.Name = "BlurFrame"
BlurFrame.Parent = Gui
BlurFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
BlurFrame.BackgroundTransparency = 0.95
BlurFrame.BorderSizePixel = 0
BlurFrame.Position = UDim2.new(0.335954279, -2, 0.542361975, -2)
BlurFrame.Size = UDim2.new(0.240350261, 4, 0.18, 4)
BlurFrame.ZIndex = 0

local BlurCorner = Instance.new("UICorner")
BlurCorner.CornerRadius = UDim.new(0, 16)
BlurCorner.Parent = BlurFrame

-- Main Frame dengan Glass Effect
Main.Name = "Main"
Main.Parent = Gui
Main.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Main.BackgroundTransparency = 0.85
Main.BorderSizePixel = 0
Main.Position = UDim2.new(0.335954279, 0, 0.542361975, 0)
Main.Size = UDim2.new(0.240350261, 0, 0.18, 0)
Main.Active = true
Main.Draggable = true
Main.ZIndex = 1

-- Corner Radius
local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = Main

-- Gradient untuk Glass Effect
local MainGradient = Instance.new("UIGradient")
MainGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(240, 240, 255))
}
MainGradient.Rotation = 90
MainGradient.Transparency = NumberSequence.new{
	NumberSequenceKeypoint.new(0, 0.3),
	NumberSequenceKeypoint.new(1, 0.1)
}
MainGradient.Parent = Main

-- Stroke untuk Border Glass
local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(255, 255, 255)
MainStroke.Thickness = 1
MainStroke.Transparency = 0.7
MainStroke.Parent = Main

-- Shadow Frame
local ShadowFrame = Instance.new("Frame")
ShadowFrame.Name = "Shadow"
ShadowFrame.Parent = Gui
ShadowFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ShadowFrame.BackgroundTransparency = 0.8
ShadowFrame.BorderSizePixel = 0
ShadowFrame.Position = UDim2.new(0.335954279, 3, 0.542361975, 3)
ShadowFrame.Size = UDim2.new(0.240350261, 0, 0.18, 0)
ShadowFrame.ZIndex = 0

local ShadowCorner = Instance.new("UICorner")
ShadowCorner.CornerRadius = UDim.new(0, 14)
ShadowCorner.Parent = ShadowFrame

-- Title Label
local Label = Instance.new("TextLabel")
Label.Name = "Label"
Label.Parent = Main
Label.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Label.BackgroundTransparency = 0.9
Label.BorderSizePixel = 0
Label.Size = UDim2.new(1, 0, 0.22, 0)
Label.Font = Enum.Font.SourceSans
Label.Text = "VOID TELEPORT PRO"
Label.TextColor3 = Color3.fromRGB(50, 50, 50)
Label.TextScaled = true
Label.TextSize = 14.000
Label.ZIndex = 2

local LabelCorner = Instance.new("UICorner")
LabelCorner.CornerRadius = UDim.new(0, 14)
LabelCorner.Parent = Label

-- Main Button
local Button = Instance.new("TextButton")
Button.Name = "Button"
Button.Parent = Main
Button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Button.BackgroundTransparency = 0.8
Button.BorderSizePixel = 0
Button.Position = UDim2.new(0.05, 0, 0.28, 0)
Button.Size = UDim2.new(0.9, 0, 0.3, 0)
Button.Font = Enum.Font.SourceSans
Button.Text = "ACTIVATE"
Button.TextColor3 = Color3.fromRGB(100, 100, 100)
Button.TextScaled = true
Button.ZIndex = 2

local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 10)
ButtonCorner.Parent = Button

local ButtonStroke = Instance.new("UIStroke")
ButtonStroke.Color = Color3.fromRGB(200, 200, 255)
ButtonStroke.Thickness = 1
ButtonStroke.Transparency = 0.5
ButtonStroke.Parent = Button

-- Info Container
local InfoContainer = Instance.new("Frame")
InfoContainer.Name = "InfoContainer"
InfoContainer.Parent = Main
InfoContainer.BackgroundTransparency = 1
InfoContainer.Position = UDim2.new(0.05, 0, 0.62, 0)
InfoContainer.Size = UDim2.new(0.9, 0, 0.35, 0)
InfoContainer.ZIndex = 2

-- Stats Grid
local StatsGrid = Instance.new("Frame")
StatsGrid.Name = "StatsGrid"
StatsGrid.Parent = InfoContainer
StatsGrid.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
StatsGrid.BackgroundTransparency = 0.95
StatsGrid.Size = UDim2.new(1, 0, 0.6, 0)
StatsGrid.ZIndex = 2

local StatsCorner = Instance.new("UICorner")
StatsCorner.CornerRadius = UDim.new(0, 8)
StatsCorner.Parent = StatsGrid

local StatsStroke = Instance.new("UIStroke")
StatsStroke.Color = Color3.fromRGB(255, 255, 255)
StatsStroke.Thickness = 0.5
StatsStroke.Transparency = 0.8
StatsStroke.Parent = StatsGrid

-- Performance Bar
local PerfBar = Instance.new("Frame")
PerfBar.Name = "PerfBar"
PerfBar.Parent = InfoContainer
PerfBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
PerfBar.BackgroundTransparency = 0.95
PerfBar.Position = UDim2.new(0, 0, 0.7, 0)
PerfBar.Size = UDim2.new(1, 0, 0.3, 0)
PerfBar.ZIndex = 2

local PerfCorner = Instance.new("UICorner")
PerfCorner.CornerRadius = UDim.new(0, 6)
PerfCorner.Parent = PerfBar

local PerfFill = Instance.new("Frame")
PerfFill.Name = "Fill"
PerfFill.Parent = PerfBar
PerfFill.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
PerfFill.BackgroundTransparency = 0.5
PerfFill.Size = UDim2.new(0, 0, 1, 0)
PerfFill.ZIndex = 3

local PerfFillCorner = Instance.new("UICorner")
PerfFillCorner.CornerRadius = UDim.new(0, 6)
PerfFillCorner.Parent = PerfFill

local PerfLabel = Instance.new("TextLabel")
PerfLabel.Parent = PerfBar
PerfLabel.BackgroundTransparency = 1
PerfLabel.Size = UDim2.new(1, 0, 1, 0)
PerfLabel.Font = Enum.Font.SourceSans
PerfLabel.Text = "Performance: 100%"
PerfLabel.TextColor3 = Color3.fromRGB(80, 80, 80)
PerfLabel.TextScaled = true
PerfLabel.TextTransparency = 0.3
PerfLabel.ZIndex = 4

-- Create Stat Labels
local function createStatLabel(name, position, text, color)
	local label = Instance.new("TextLabel")
	label.Name = name
	label.Parent = StatsGrid
	label.BackgroundTransparency = 1
	label.Position = position
	label.Size = UDim2.new(0.5, 0, 0.5, 0)
	label.Font = Enum.Font.SourceSans
	label.Text = text
	label.TextColor3 = color
	label.TextScaled = true
	label.TextTransparency = 0.1
	label.ZIndex = 3
	return label
end

local UnanchoredLabel = createStatLabel("Unanchored", UDim2.new(0, 0, 0, 0), "◆ 0", Color3.fromRGB(100, 200, 100))
local AnchoredLabel = createStatLabel("Anchored", UDim2.new(0.5, 0, 0, 0), "◇ 0", Color3.fromRGB(200, 150, 100))
local TeleportedLabel = createStatLabel("Teleported", UDim2.new(0, 0, 0.5, 0), "✦ 0", Color3.fromRGB(200, 100, 100))
local QueueLabel = createStatLabel("Queue", UDim2.new(0.5, 0, 0.5, 0), "⧗ 0", Color3.fromRGB(150, 150, 200))

-- ========================================
-- ADVANCED SYSTEM CORE
-- ========================================

local LocalPlayer = Players.LocalPlayer
local player = LocalPlayer
local character
local humanoidRootPart

-- System State
local SystemState = {
	Active = false,
	Performance = 100,
	FrameTime = 0,
	ProcessedCount = 0,
	QueueCount = 0,
	TotalScanned = 0,
	LastCleanup = 0,
	LastScan = 0
}

-- Advanced Configuration
local Config = {
	-- Performance
	MaxPartsPerFrame = 10,
	MaxQueueSize = 1000,
	ScanInterval = 0.5,
	CleanupInterval = 5,
	FrameBudget = 1/60 * 0.5,
	
	-- Force Settings
	ForceMultiplier = 50,
	MaxForce = 9e9 * 50,
	MaxVelocity = 9e9 * 50,
	Responsiveness = 10000,
	
	-- Void Positions
	VoidDistance = 999999,
	VoidSpread = 10000,
	
	-- Smart Detection
	MaxScanDistance = math.huge,
	PriorityRadius = 500,
	ChunkSize = 100
}

-- Void Position Generator
local VoidGenerator = {
	index = 1,
	positions = {}
}

function VoidGenerator:Initialize()
	self.positions = {}
	local d = Config.VoidDistance
	
	-- Generate void positions in 3D grid
	for x = -1, 1 do
		for y = -1, 1 do
			for z = -1, 1 do
				if x ~= 0 or y ~= 0 or z ~= 0 then
					table.insert(self.positions, Vector3.new(x * d, y * d, z * d))
				end
			end
		end
	end
end

function VoidGenerator:GetNext()
	local pos = self.positions[self.index]
	self.index = (self.index % #self.positions) + 1
	
	-- Add random offset
	local offset = Vector3.new(
		math.random(-Config.VoidSpread, Config.VoidSpread),
		math.random(-Config.VoidSpread, Config.VoidSpread),
		math.random(-Config.VoidSpread, Config.VoidSpread)
	)
	
	return pos + offset
end

VoidGenerator:Initialize()

-- Part Manager
local PartManager = {
	queue = {},
	active = {},
	processed = {},
	blacklist = {},
	stats = {
		anchored = 0,
		unanchored = 0,
		teleported = 0,
		queued = 0
	}
}

-- Optimized Part Validator
function PartManager:IsValid(part)
	-- Quick checks first
	if not part or not part:IsA("BasePart") then return false end
	if part.Anchored then return false end
	if not part.Parent then return false end
	if self.processed[part] then return false end
	if self.blacklist[part] then return false end
	
	-- Check if it's a character part
	local parent = part.Parent
	if parent:FindFirstChildOfClass("Humanoid") then
		return false
	end
	
	-- Check if it's player's character
	if character and part:IsDescendantOf(character) then
		return false
	end
	
	-- Check all players' characters
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr.Character and part:IsDescendantOf(plr.Character) then
			return false
		end
	end
	
	-- Skip important parts
	local name = part.Name:lower()
	if name:find("base") or name:find("spawn") or name:find("camera") then
		self.blacklist[part] = true
		return false
	end
	
	return true
end

-- Queue Management
function PartManager:AddToQueue(part)
	if #self.queue >= Config.MaxQueueSize then
		return false
	end
	
	if not self:IsValid(part) then
		return false
	end
	
	table.insert(self.queue, part)
	self.stats.queued = #self.queue
	return true
end

function PartManager:ProcessQueue(budget)
	local startTime = tick()
	local processed = 0
	
	while #self.queue > 0 and processed < Config.MaxPartsPerFrame do
		if tick() - startTime > budget then
			break
		end
		
		local part = table.remove(self.queue, 1)
		
		if part and part.Parent and self:IsValid(part) then
			self:TeleportPart(part)
			processed = processed + 1
		end
	end
	
	self.stats.queued = #self.queue
	return processed
end

-- Advanced Teleportation System
function PartManager:TeleportPart(part)
	local success = pcall(function()
		if not self:IsValid(part) then return end
		
		-- Mark as processed
		self.processed[part] = true
		
		-- Clean old body movers
		for _, child in ipairs(part:GetChildren()) do
			if child:IsA("BodyMover") or child:IsA("AlignPosition") or child:IsA("AlignOrientation") then
				child:Destroy()
			end
		end
		
		-- Setup part properties
		part.CanCollide = false
		part.Massless = true
		part.CustomPhysicalProperties = PhysicalProperties.new(0.001, 0, 0, 0, 0)
		
		-- Get void position
		local voidPos = VoidGenerator:GetNext()
		
		-- Create attachment
		local attachment = part:FindFirstChildOfClass("Attachment") or Instance.new("Attachment", part)
		
		-- AlignPosition for precise control
		local alignPos = Instance.new("AlignPosition")
		alignPos.MaxForce = Config.MaxForce
		alignPos.MaxVelocity = Config.MaxVelocity
		alignPos.Responsiveness = Config.Responsiveness
		alignPos.RigidityEnabled = true
		alignPos.Mode = Enum.PositionAlignmentMode.OneAttachment
		alignPos.Position = voidPos
		alignPos.Attachment0 = attachment
		alignPos.Parent = part
		
		-- BodyVelocity for initial push
		local bodyVel = Instance.new("BodyVelocity")
		bodyVel.MaxForce = Vector3.new(Config.MaxForce, Config.MaxForce, Config.MaxForce)
		bodyVel.Velocity = (voidPos - part.Position).Unit * Config.MaxVelocity
		bodyVel.Parent = part
		
		-- Store active part data
		self.active[part] = {
			alignPos = alignPos,
			bodyVel = bodyVel,
			attachment = attachment,
			voidPos = voidPos,
			startTime = tick()
		}
		
		-- Update stats
		self.stats.teleported = self.stats.teleported + 1
		self.stats.unanchored = math.max(0, self.stats.unanchored - 1)
		
		-- Auto cleanup on destroy
		part.AncestryChanged:Connect(function(_, parent)
			if not parent then
				self:CleanupPart(part)
			end
		end)
		
		-- Schedule cleanup after 10 seconds
		task.delay(10, function()
			if self.active[part] then
				if bodyVel and bodyVel.Parent then
					bodyVel:Destroy()
				end
				if self.active[part] then
					self.active[part].bodyVel = nil
				end
			end
		end)
	end)
	
	if not success then
		self.processed[part] = nil
	end
end

function PartManager:CleanupPart(part)
	local data = self.active[part]
	if data then
		pcall(function()
			if data.alignPos then data.alignPos:Destroy() end
			if data.bodyVel then data.bodyVel:Destroy() end
		end)
		
		self.active[part] = nil
		self.stats.teleported = math.max(0, self.stats.teleported - 1)
	end
	
	self.processed[part] = nil
end

function PartManager:CleanupAll()
	for part, _ in pairs(self.active) do
		self:CleanupPart(part)
	end
	
	self.queue = {}
	self.active = {}
	self.processed = {}
	self.stats.teleported = 0
	self.stats.queued = 0
end

-- Scanner System
local Scanner = {
	running = false,
	connections = {}
}

function Scanner:ScanWorkspace()
	local parts = {}
	local count = 0
	
	-- Use GetDescendants with limit
	for _, obj in ipairs(Workspace:GetDescendants()) do
		if count >= Config.ChunkSize then
			break
		end
		
		if obj:IsA("BasePart") then
			if obj.Anchored then
				PartManager.stats.anchored = PartManager.stats.anchored + 1
			else
				PartManager.stats.unanchored = PartManager.stats.unanchored + 1
				
				if PartManager:IsValid(obj) then
					table.insert(parts, obj)
					count = count + 1
				end
			end
		end
	end
	
	return parts
end

function Scanner:Start()
	if self.running then return end
	self.running = true
	
	-- Initial scan
	task.spawn(function()
		local parts = self:ScanWorkspace()
		for _, part in ipairs(parts) do
			PartManager:AddToQueue(part)
		end
	end)
	
	-- Listen for new parts
	self.connections.added = Workspace.DescendantAdded:Connect(function(obj)
		if obj:IsA("BasePart") and not obj.Anchored then
			PartManager:AddToQueue(obj)
		end
	end)
	
	-- Periodic rescan
	self.connections.scan = task.spawn(function()
		while self.running do
			task.wait(Config.ScanInterval)
			
			if tick() - SystemState.LastScan > Config.ScanInterval then
				SystemState.LastScan = tick()
				
				local parts = self:ScanWorkspace()
				for _, part in ipairs(parts) do
					PartManager:AddToQueue(part)
				end
			end
		end
	end)
end

function Scanner:Stop()
	self.running = false
	
	for _, connection in pairs(self.connections) do
		if typeof(connection) == "RBXScriptConnection" then
			connection:Disconnect()
		elseif typeof(connection) == "thread" then
			task.cancel(connection)
		end
	end
	
	self.connections = {}
end

-- Performance Monitor
local PerformanceMonitor = {
	samples = {},
	maxSamples = 30
}

function PerformanceMonitor:Update(frameTime)
	table.insert(self.samples, frameTime)
	if #self.samples > self.maxSamples then
		table.remove(self.samples, 1)
	end
	
	local avg = 0
	for _, time in ipairs(self.samples) do
		avg = avg + time
	end
	avg = avg / #self.samples
	
	local targetTime = 1/60
	SystemState.Performance = math.min(100, (targetTime / avg) * 100)
	
	-- Adjust processing based on performance
	if SystemState.Performance < 50 then
		Config.MaxPartsPerFrame = math.max(1, Config.MaxPartsPerFrame - 1)
	elseif SystemState.Performance > 80 then
		Config.MaxPartsPerFrame = math.min(20, Config.MaxPartsPerFrame + 1)
	end
	
	return SystemState.Performance
end

-- UI Updates
local function UpdateUI()
	UnanchoredLabel.Text = string.format("◆ %d", PartManager.stats.unanchored)
	AnchoredLabel.Text = string.format("◇ %d", PartManager.stats.anchored)
	TeleportedLabel.Text = string.format("✦ %d", PartManager.stats.teleported)
	QueueLabel.Text = string.format("⧗ %d", PartManager.stats.queued)
	
	-- Update performance bar
	local perf = SystemState.Performance
	PerfFill.Size = UDim2.new(perf/100, 0, 1, 0)
	PerfLabel.Text = string.format("Performance: %d%%", math.floor(perf))
	
	-- Color based on performance
	if perf > 70 then
		PerfFill.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
	elseif perf > 40 then
		PerfFill.BackgroundColor3 = Color3.fromRGB(255, 200, 100)
	else
		PerfFill.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
	end
end

-- Main Loop
local mainLoop
local function StartSystem()
	if SystemState.Active then return end
	SystemState.Active = true
	
	-- Reset stats
	PartManager.stats = {
		anchored = 0,
		unanchored = 0,
		teleported = 0,
		queued = 0
	}
	
	-- Start scanner
	Scanner:Start()
	
	-- Main processing loop
	mainLoop = RunService.Heartbeat:Connect(function(deltaTime)
		local frameStart = tick()
		
		-- Process queue
		local processed = PartManager:ProcessQueue(Config.FrameBudget)
		SystemState.ProcessedCount = SystemState.ProcessedCount + processed
		
		-- Periodic cleanup
		if tick() - SystemState.LastCleanup > Config.CleanupInterval then
			SystemState.LastCleanup = tick()
			
			-- Clean up completed teleports
			for part, data in pairs(PartManager.active) do
				if not part.Parent then
					PartManager:CleanupPart(part)
				elseif tick() - data.startTime > 30 then
					-- Remove very old entries
					PartManager:CleanupPart(part)
				end
			end
		end
		
		-- Update performance
		local frameTime = tick() - frameStart
		PerformanceMonitor:Update(frameTime)
		
		-- Update UI
		UpdateUI()
	end)
	
	-- Update button
	Button.Text = "DEACTIVATE"
	TweenService:Create(Button, TweenInfo.new(0.3), {
		BackgroundTransparency = 0.6,
		TextColor3 = Color3.fromRGB(255, 100, 100)
	}):Play()
	
	TweenService:Create(ButtonStroke, TweenInfo.new(0.3), {
		Color = Color3.fromRGB(255, 100, 100),
		Transparency = 0.3
	}):Play()
end

local function StopSystem()
	if not SystemState.Active then return end
	SystemState.Active = false
	
	-- Stop scanner
	Scanner:Stop()
	
	-- Stop main loop
	if mainLoop then
		mainLoop:Disconnect()
		mainLoop = nil
	end
	
	-- Cleanup all parts
	PartManager:CleanupAll()
	
	-- Reset stats
	UpdateUI()
	
	-- Update button
	Button.Text = "ACTIVATE"
	TweenService:Create(Button, TweenInfo.new(0.3), {
		BackgroundTransparency = 0.8,
		TextColor3 = Color3.fromRGB(100, 100, 100)
	}):Play()
	
	TweenService:Create(ButtonStroke, TweenInfo.new(0.3), {
		Color = Color3.fromRGB(200, 200, 255),
		Transparency = 0.5
	}):Play()
end

-- Character Management
local function updateCharacter()
	character = player.Character or player.CharacterAdded:Wait()
	humanoidRootPart = character:WaitForChild("HumanoidRootPart", 10)
end

updateCharacter()
player.CharacterAdded:Connect(updateCharacter)

-- Button Events
Button.MouseButton1Click:Connect(function()
	if SystemState.Active then
		StopSystem()
	else
		StartSystem()
	end
end)

Button.MouseEnter:Connect(function()
	TweenService:Create(Button, TweenInfo.new(0.2), {
		BackgroundTransparency = 0.6
	}):Play()
end)

Button.MouseLeave:Connect(function()
	TweenService:Create(Button, TweenInfo.new(0.2), {
		BackgroundTransparency = SystemState.Active and 0.6 or 0.8
	}):Play()
end)

-- UI Toggle
local uiVisible = true
UserInputService.InputBegan:Connect(function(input, processed)
	if processed then return end
	
	if input.KeyCode == Enum.KeyCode.RightControl then
		uiVisible = not uiVisible
		
		TweenService:Create(Main, TweenInfo.new(0.3), {
			BackgroundTransparency = uiVisible and 0.85 or 1
		}):Play()
		
		for _, child in ipairs(Main:GetDescendants()) do
			if child:IsA("TextLabel") or child:IsA("TextButton") then
				TweenService:Create(child, TweenInfo.new(0.3), {
					TextTransparency = uiVisible and 0 or 1
				}):Play()
			end
		end
		
		Main.Active = uiVisible
	end
end)

-- Cleanup on leave
Players.PlayerRemoving:Connect(function(plr)
	if plr == player then
		StopSystem()
		if Gui then Gui:Destroy() end
	end
end)

-- Initial UI update
UpdateUI()

-- Notification
game:GetService("StarterGui"):SetCore("SendNotification", {
	Title = "Void Teleport Pro",
	Text = "Press Right Ctrl to toggle UI",
	Duration = 3
})
