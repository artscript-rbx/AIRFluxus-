-- AIRFluxus ADMIN PANEL | FULL RGB FINAL
-- LocalScript | Client-side

-- SERVICES
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- PLAYER
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local cam = workspace.CurrentCamera

player.CharacterAdded:Connect(function(c)
	char = c
	hum = c:WaitForChild("Humanoid")
end)

-- STATE
local state = {
	Noclip=false, Jump=false, God=false, Fly=false,
	Zoom=false, ESP=false, AntiFling=false, AntiTroll=false
}

-- ================= GUI =================
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "AIRFluxus_UI"
gui.ResetOnSpawn = false

local main = Instance.new("Frame", gui)
main.Size = UDim2.fromScale(0,0)
main.Position = UDim2.fromScale(0.5,0.5)
main.AnchorPoint = Vector2.new(0.5,0.5)
main.BackgroundColor3 = Color3.fromRGB(18,18,18)
main.Active = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0,18)

local stroke = Instance.new("UIStroke", main)
stroke.Thickness = 2

TweenService:Create(
	main,
	TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
	{Size = UDim2.fromScale(0.36,0.6)}
):Play()

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,40)
title.Text = "AIRFluxus"
title.Font = Enum.Font.GothamBold
title.TextSize = 24
title.BackgroundTransparency = 1
title.TextXAlignment = Enum.TextXAlignment.Center

-- SCROLL
local scroll = Instance.new("ScrollingFrame", main)
scroll.Position = UDim2.new(0,10,0,50)
scroll.Size = UDim2.new(1,-20,1,-60)
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.CanvasSize = UDim2.new(0,0,0,0)
scroll.ScrollBarThickness = 6
scroll.BackgroundTransparency = 1

local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0,8)

-- BUTTON MAKER
local buttons = {}
local function makeButton(name)
	local b = Instance.new("TextButton", scroll)
	b.Size = UDim2.new(1,0,0,44)
	b.Text = name.." : OFF"
	b.Font = Enum.Font.Gotham
	b.TextSize = 14
	b.AutoButtonColor = false
	b.BackgroundColor3 = Color3.fromRGB(28,28,28)
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,12)
	table.insert(buttons, b)
	return b
end

-- BUTTONS (LENGKAP)
local noclipBtn = makeButton("NOCLIP")
local jumpBtn   = makeButton("INFINITY JUMP")
local godBtn    = makeButton("GODMODE")
local flyBtn    = makeButton("FLY")
local zoomBtn   = makeButton("INFINITY ZOOM")
local espBtn    = makeButton("PLAYER VISIBLE")
local flingBtn  = makeButton("ANTI FLING")
local trollBtn  = makeButton("ANTI TROLL")

-- ================= DRAG =================
local dragging, dragStart, startPos
main.InputBegan:Connect(function(i)
	if i.UserInputType==Enum.UserInputType.MouseButton1
	or i.UserInputType==Enum.UserInputType.Touch then
		dragging=true; dragStart=i.Position; startPos=main.Position
	end
end)
UIS.InputChanged:Connect(function(i)
	if dragging and (i.UserInputType==Enum.UserInputType.MouseMovement
	or i.UserInputType==Enum.UserInputType.Touch) then
		local d=i.Position-dragStart
		main.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y)
	end
end)
UIS.InputEnded:Connect(function() dragging=false end)

-- ================= FEATURES =================
-- NOCLIP
RunService.Stepped:Connect(function()
	if state.Noclip then
		for _,v in pairs(char:GetDescendants()) do
			if v:IsA("BasePart") then v.CanCollide=false end
		end
	end
end)
noclipBtn.MouseButton1Click:Connect(function()
	state.Noclip=not state.Noclip
	noclipBtn.Text="NOCLIP : "..(state.Noclip and "ON" or "OFF")
end)

-- INFINITY JUMP
UIS.JumpRequest:Connect(function()
	if state.Jump then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
end)
jumpBtn.MouseButton1Click:Connect(function()
	state.Jump=not state.Jump
	jumpBtn.Text="INFINITY JUMP : "..(state.Jump and "ON" or "OFF")
end)

-- GODMODE
godBtn.MouseButton1Click:Connect(function()
	state.God=not state.God
	hum.MaxHealth=state.God and math.huge or 100
	hum.Health=hum.MaxHealth
	godBtn.Text="GODMODE : "..(state.God and "ON" or "OFF")
end)

-- FLY
local bv,bg
flyBtn.MouseButton1Click:Connect(function()
	state.Fly=not state.Fly
	if state.Fly then
		bv=Instance.new("BodyVelocity",char.HumanoidRootPart)
		bv.MaxForce=Vector3.new(9e9,9e9,9e9)
		bg=Instance.new("BodyGyro",char.HumanoidRootPart)
		bg.MaxTorque=Vector3.new(9e9,9e9,9e9)
	else
		if bv then bv:Destroy() end
		if bg then bg:Destroy() end
	end
	flyBtn.Text="FLY : "..(state.Fly and "ON" or "OFF")
end)
RunService.RenderStepped:Connect(function()
	if state.Fly and bv and bg then
		bv.Velocity=cam.CFrame.LookVector*60
		bg.CFrame=cam.CFrame
	end
end)

-- ZOOM
zoomBtn.MouseButton1Click:Connect(function()
	state.Zoom=not state.Zoom
	player.CameraMaxZoomDistance=state.Zoom and math.huge or 128
	zoomBtn.Text="INFINITY ZOOM : "..(state.Zoom and "ON" or "OFF")
end)

-- ESP
espBtn.MouseButton1Click:Connect(function()
	state.ESP=not state.ESP
	for _,p in pairs(Players:GetPlayers()) do
		if p~=player and p.Character then
			local h=p.Character:FindFirstChild("Highlight")
			if state.ESP and not h then
				h=Instance.new("Highlight",p.Character)
				h.OutlineTransparency=1
			elseif not state.ESP and h then h:Destroy() end
		end
	end
	espBtn.Text="PLAYER VISIBLE : "..(state.ESP and "ON" or "OFF")
end)

-- ANTI FLING + TROLL
RunService.Heartbeat:Connect(function()
	for _,v in pairs(char:GetDescendants()) do
		if state.AntiFling and (v:IsA("BodyVelocity") or v:IsA("LinearVelocity")) then v:Destroy() end
		if state.AntiTroll and (v:IsA("WeldConstraint") or v:IsA("AlignPosition")) then v:Destroy() end
	end
end)
flingBtn.MouseButton1Click:Connect(function()
	state.AntiFling=not state.AntiFling
	flingBtn.Text="ANTI FLING : "..(state.AntiFling and "ON" or "OFF")
end)
trollBtn.MouseButton1Click:Connect(function()
	state.AntiTroll=not state.AntiTroll
	trollBtn.Text="ANTI TROLL : "..(state.AntiTroll and "ON" or "OFF")
end)

-- ================= RGB PELANGI =================
local hue = 0
local rgbSpeed = 0.25
RunService.RenderStepped:Connect(function(dt)
	hue = (hue + dt * rgbSpeed) % 1
	local col = Color3.fromHSV(hue,1,1)
	title.TextColor3 = col
	stroke.Color = col
	for _,b in pairs(buttons) do
		b.TextColor3 = col
		b.BackgroundColor3 = col:Lerp(Color3.fromRGB(15,15,15),0.7)
	end
end)
