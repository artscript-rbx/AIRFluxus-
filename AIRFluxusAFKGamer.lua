-- Services
local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Locale & translate
local locale = player.LocaleId
local translations = {
    ["en"] = {afkLabel="AFK AIRFluxus", afkButtonActive="Activate AFK", afkButtonInactive="Deactivate AFK"},
    ["id"] = {afkLabel="AFK AIRFluxus", afkButtonActive="Aktifkan AFK", afkButtonInactive="Nonaktifkan AFK"},
}
local function getLang()
    return translations[locale:sub(1,2)] or translations["en"]
end
local lang = getLang()

-- ScreenGui immortal
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AFK_GUI_Immortal_Max"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Pastikan GUI selalu ada
spawn(function()
    while true do
        if not screenGui.Parent then
            screenGui.Parent = player:WaitForChild("PlayerGui")
        end
        wait(1)
    end
end)

-- Frame modern ringkas
local afkFrame = Instance.new("Frame", screenGui)
afkFrame.Size = UDim2.new(0,280,0,180)
afkFrame.Position = UDim2.new(0.5,-140,0.5,-90)
afkFrame.BackgroundColor3 = Color3.fromRGB(20,20,30)
afkFrame.BackgroundTransparency = 0.2
Instance.new("UICorner", afkFrame).CornerRadius = UDim.new(0,20)
local stroke = Instance.new("UIStroke", afkFrame)
stroke.Thickness = 1.5
stroke.Transparency = 0.2

-- Layout & padding
local listLayout = Instance.new("UIListLayout", afkFrame)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0,6)
local padding = Instance.new("UIPadding", afkFrame)
padding.PaddingTop = UDim.new(0,8)
padding.PaddingBottom = UDim.new(0,8)
padding.PaddingLeft = UDim.new(0,12)
padding.PaddingRight = UDim.new(0,12)

-- Label AFK
local afkLabel = Instance.new("TextLabel", afkFrame)
afkLabel.Size = UDim2.new(1,0,0,28)
afkLabel.BackgroundTransparency = 1
afkLabel.Text = lang.afkLabel
afkLabel.TextScaled = true
afkLabel.Font = Enum.Font.Code
afkLabel.TextColor3 = Color3.fromRGB(0,255,255)
afkLabel.TextStrokeTransparency = 0.6
afkLabel.LayoutOrder = 1

-- Timer AFK
local timerLabel = Instance.new("TextLabel", afkFrame)
timerLabel.Size = UDim2.new(1,0,0,28)
timerLabel.BackgroundTransparency = 1
timerLabel.Text = "0 Hari 00:00:00"
timerLabel.TextScaled = true
timerLabel.Font = Enum.Font.Code
timerLabel.TextColor3 = Color3.fromRGB(0,255,255)
timerLabel.TextStrokeTransparency = 0.7
timerLabel.LayoutOrder = 2

-- Jam Dunia
local worldClock = Instance.new("TextLabel", afkFrame)
worldClock.Size = UDim2.new(1,0,0,24)
worldClock.BackgroundTransparency = 0.3
worldClock.BackgroundColor3 = Color3.fromRGB(0,0,0)
worldClock.Text = "--:--:--"
worldClock.TextScaled = true
worldClock.Font = Enum.Font.Code
worldClock.TextColor3 = Color3.fromRGB(0,255,255)
worldClock.TextStrokeTransparency = 0.5
worldClock.LayoutOrder = 3

-- Tombol AFK futuristik
local afkButton = Instance.new("TextButton", afkFrame)
afkButton.Size = UDim2.new(1,0,0,34)
afkButton.Text = lang.afkButtonActive
afkButton.TextScaled = true
afkButton.Font = Enum.Font.Code
afkButton.BackgroundColor3 = Color3.fromRGB(0,150,255)
afkButton.TextColor3 = Color3.fromRGB(255,255,255)
Instance.new("UICorner", afkButton).CornerRadius = UDim.new(0,10)
afkButton.LayoutOrder = 4

-- Hover animation tombol
afkButton.MouseEnter:Connect(function()
    TweenService:Create(afkButton,TweenInfo.new(0.2),{BackgroundTransparency=0.1}):Play()
end)
afkButton.MouseLeave:Connect(function()
    TweenService:Create(afkButton,TweenInfo.new(0.2),{BackgroundTransparency=0}):Play()
end)

-- Progress bar smooth
local progressBar = Instance.new("Frame", afkFrame)
progressBar.Size = UDim2.new(0,0,0,5)
progressBar.Position = UDim2.new(0,0,1,-12)
progressBar.BackgroundColor3 = Color3.fromRGB(0,255,255)
Instance.new("UICorner", progressBar).CornerRadius = UDim.new(0,2)

-- Drag & drop stabil
local dragging, dragInput, mousePos, framePos
afkFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        mousePos = input.Position
        framePos = afkFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)
afkFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - mousePos
        afkFrame.Position = UDim2.new(
            framePos.X.Scale,
            framePos.X.Offset + delta.X,
            framePos.Y.Scale,
            framePos.Y.Offset + delta.Y
        )
    end
end)

-- RGB pelangi smooth
spawn(function()
    while true do
        local hue = tick()%10/10
        local color = Color3.fromHSV(hue,1,1)
        stroke.Color = color
        afkLabel.TextColor3 = color
        timerLabel.TextColor3 = color
        worldClock.TextColor3 = color
        afkButton.BackgroundColor3 = color
        progressBar.BackgroundColor3 = color
        wait(0.05)
    end
end)

-- AFK immortal maksimal: semua Humanoid
local afkActive = false
local afkTime = 0

local function formatTime(seconds)
    local days = math.floor(seconds/86400)
    local h = math.floor((seconds%86400)/3600)
    local m = math.floor((seconds%3600)/60)
    local s = math.floor(seconds%60)
    return string.format("%d Hari %02d:%02d:%02d", days, h, m, s)
end

local function animateTimer()
    local info = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tweenUp = TweenService:Create(timerLabel, info, {TextSize = timerLabel.TextSize + 2})
    tweenUp:Play()
    tweenUp.Completed:Connect(function()
        TweenService:Create(timerLabel, info, {TextSize = timerLabel.TextSize}):Play()
    end)
end

-- Tombol toggle AFK
afkButton.MouseButton1Click:Connect(function()
    afkActive = not afkActive
    if afkActive then
        afkButton.Text = lang.afkButtonInactive
        afkTime = 0
    else
        afkButton.Text = lang.afkButtonActive
    end
end)

-- Loop utama: timer, jam, progress, dan AFK immortal semua Humanoid
spawn(function()
    while true do
        if player.Character then
            local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
            local humanoids = {}
            for _, obj in pairs(player.Character:GetDescendants()) do
                if obj:IsA("Humanoid") then
                    table.insert(humanoids,obj)
                end
            end

            if afkActive then
                afkTime += 1
                timerLabel.Text = formatTime(afkTime)
                animateTimer()
                progressBar.Size = UDim2.new(math.min(afkTime/100,1),0,0,5)

                if rootPart then rootPart.Anchored = true end
                for _, h in pairs(humanoids) do
                    h.Health = h.MaxHealth
                    h.MaxHealth = math.huge
                    h.WalkSpeed = 0
                    h.JumpPower = 0
                end
            else
                if rootPart then rootPart.Anchored = false end
                for _, h in pairs(humanoids) do
                    h.MaxHealth = 100
                    h.Health = 100
                    h.WalkSpeed = 16
                    h.JumpPower = 50
                end
            end
        end
        -- Jam dunia real-time
        local dt = DateTime.now()
        worldClock.Text = dt:FormatLocalTime("HH:mm:ss","en-us")
        RunService.RenderStepped:Wait()
    end
end)
