-- KOAS ZONE PREMIUM EDITION
-- Monochrome UI with Player Stats

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Get game info
local gameInfo = {
    name = "Loading...",
    placeId = game.PlaceId
}

pcall(function()
    gameInfo.name = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
end)

-- State
local state = {
    tankEnabled = false,
    reachEnabled = false,
    visualizeHitbox = false,
    reachDistance = 8,
    hitboxParts = {},
    connections = {},
    originalHealth = humanoid.Health or 100,
    keybinds = {
        toggleUI = Enum.KeyCode.RightControl,
        reachIncrease = Enum.KeyCode.J,
        reachDecrease = Enum.KeyCode.K,
        toggleReach = Enum.KeyCode.Q,
        toggleTank = Enum.KeyCode.Z
    }
}

-- Splash Screen
local splashGui = Instance.new("ScreenGui")
splashGui.Name = "KoasSplash"
splashGui.Parent = player:WaitForChild("PlayerGui")
splashGui.ResetOnSpawn = false
splashGui.IgnoreGuiInset = true

local splashBg = Instance.new("Frame")
splashBg.Parent = splashGui
splashBg.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
splashBg.BorderSizePixel = 0
splashBg.Size = UDim2.new(1, 0, 1, 0)

local splashText = Instance.new("TextLabel")
splashText.Parent = splashBg
splashText.BackgroundTransparency = 1
splashText.Position = UDim2.new(0.5, 0, 0.5, -20)
splashText.AnchorPoint = Vector2.new(0.5, 0.5)
splashText.Size = UDim2.new(0, 600, 0, 80)
splashText.Font = Enum.Font.GothamBold
splashText.Text = "KOAS ZONE"
splashText.TextColor3 = Color3.fromRGB(255, 255, 255)
splashText.TextSize = 1
splashText.TextTransparency = 1

local splashSubtext = Instance.new("TextLabel")
splashSubtext.Parent = splashBg
splashSubtext.BackgroundTransparency = 1
splashSubtext.Position = UDim2.new(0.5, 0, 0.5, 40)
splashSubtext.AnchorPoint = Vector2.new(0.5, 0)
splashSubtext.Size = UDim2.new(0, 400, 0, 30)
splashSubtext.Font = Enum.Font.Gotham
splashSubtext.Text = "PREMIUM EDITION"
splashSubtext.TextColor3 = Color3.fromRGB(150, 150, 150)
splashSubtext.TextSize = 16
splashSubtext.TextTransparency = 1

spawn(function()
    for i = 1, 2 do
        TweenService:Create(splashText, TweenInfo.new(0.2), {TextTransparency = 0}):Play()
        TweenService:Create(splashSubtext, TweenInfo.new(0.2), {TextTransparency = 0}):Play()
        task.wait(0.2)
        TweenService:Create(splashText, TweenInfo.new(0.2), {TextTransparency = 1}):Play()
        TweenService:Create(splashSubtext, TweenInfo.new(0.2), {TextTransparency = 1}):Play()
        task.wait(0.2)
    end

    TweenService:Create(splashText, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
    TweenService:Create(splashSubtext, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
    TweenService:Create(splashText, TweenInfo.new(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        TextSize = 64
    }):Play()

    task.wait(1.5)

    TweenService:Create(splashBg, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
    TweenService:Create(splashText, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
    TweenService:Create(splashSubtext, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
    task.wait(0.4)
    splashGui:Destroy()
end)

task.wait(2.5)

-- Main GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "KoasZoneHub"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true

local mainFrame = Instance.new("Frame")
mainFrame.Parent = screenGui
mainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
mainFrame.BorderSizePixel = 0
mainFrame.Position = UDim2.new(0.5, -300, 0.5, -280)
mainFrame.Size = UDim2.new(0, 600, 0, 560)
mainFrame.ClipsDescendants = true

Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 14)

local stroke = Instance.new("UIStroke")
stroke.Thickness = 1
stroke.Color = Color3.fromRGB(60, 60, 60)
stroke.Transparency = 0.4
stroke.Parent = mainFrame

-- User Info Panel
local userPanel = Instance.new("Frame")
userPanel.Parent = mainFrame
userPanel.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
userPanel.Size = UDim2.new(1, 0, 0, 110)

Instance.new("UICorner", userPanel).CornerRadius = UDim.new(0, 14)

local panelStroke = Instance.new("UIStroke")
panelStroke.Thickness = 1
panelStroke.Color = Color3.fromRGB(40, 40, 40)
panelStroke.Transparency = 0.6
panelStroke.Parent = userPanel

-- Avatar
local avatar = Instance.new("ImageLabel")
avatar.Parent = userPanel
avatar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
avatar.Position = UDim2.new(0, 15, 0, 15)
avatar.Size = UDim2.new(0, 80, 0, 80)
avatar.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. player.UserId .. "&width=150&height=150&format=png"

Instance.new("UICorner", avatar).CornerRadius = UDim.new(0, 10)

local avatarStroke = Instance.new("UIStroke")
avatarStroke.Thickness = 2
avatarStroke.Color = Color3.fromRGB(255, 255, 255)
avatarStroke.Transparency = 0.85
avatarStroke.Parent = avatar

-- User Details
local detailsFrame = Instance.new("Frame")
detailsFrame.Parent = userPanel
detailsFrame.BackgroundTransparency = 1
detailsFrame.Position = UDim2.new(0, 105, 0, 15)
detailsFrame.Size = UDim2.new(1, -125, 1, -30)

local detailsLayout = Instance.new("UIListLayout")
detailsLayout.Parent = detailsFrame
detailsLayout.Padding = UDim.new(0, 3)

local function createLabel(text, bold, size)
    local label = Instance.new("TextLabel")
    label.Parent = detailsFrame
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, 0, 0, size or 18)
    label.Font = bold and Enum.Font.GothamBold or Enum.Font.Gotham
    label.Text = text
    label.TextColor3 = bold and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(160, 160, 160)
    label.TextSize = bold and 16 or 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextTruncate = Enum.TextTruncate.AtEnd
    return label
end

createLabel("@" .. player.Name, true, 20)
createLabel("ID: " .. player.UserId, false)
createLabel("Game: " .. gameInfo.name, false)

-- Health Bar
local healthFrame = Instance.new("Frame")
healthFrame.Parent = detailsFrame
healthFrame.BackgroundTransparency = 1
healthFrame.Size = UDim2.new(1, 0, 0, 22)

local healthLabel = Instance.new("TextLabel")
healthLabel.Parent = healthFrame
healthLabel.BackgroundTransparency = 1
healthLabel.Size = UDim2.new(0, 50, 1, 0)
healthLabel.Font = Enum.Font.GothamBold
healthLabel.Text = "HP"
healthLabel.TextColor3 = Color3.fromRGB(160, 160, 160)
healthLabel.TextSize = 12
healthLabel.TextXAlignment = Enum.TextXAlignment.Left

local healthBg = Instance.new("Frame")
healthBg.Parent = healthFrame
healthBg.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
healthBg.BorderSizePixel = 0
healthBg.Position = UDim2.new(0, 35, 0, 4)
healthBg.Size = UDim2.new(1, -40, 0, 14)

Instance.new("UICorner", healthBg).CornerRadius = UDim.new(1, 0)

local healthBar = Instance.new("Frame")
healthBar.Parent = healthBg
healthBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
healthBar.BorderSizePixel = 0
healthBar.Size = UDim2.new(1, 0, 1, 0)

Instance.new("UICorner", healthBar).CornerRadius = UDim.new(1, 0)

local healthText = Instance.new("TextLabel")
healthText.Parent = healthBg
healthText.BackgroundTransparency = 1
healthText.Size = UDim2.new(1, 0, 1, 0)
healthText.Font = Enum.Font.GothamBold
healthText.Text = "100/100"
healthText.TextColor3 = Color3.fromRGB(0, 0, 0)
healthText.TextSize = 10
healthText.ZIndex = 2

-- Update health
spawn(function()
    while task.wait(0.1) do
        if humanoid and humanoid.Parent then
            local pct = humanoid.Health / humanoid.MaxHealth
            healthBar.Size = UDim2.new(pct, 0, 1, 0)
            healthText.Text = math.floor(humanoid.Health) .. "/" .. math.floor(humanoid.MaxHealth)
            
            if pct > 0.6 then
                healthBar.BackgroundColor3 = Color3.fromRGB(200, 255, 200)
            elseif pct > 0.3 then
                healthBar.BackgroundColor3 = Color3.fromRGB(255, 220, 100)
            else
                healthBar.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
            end
        end
    end
end)

-- Title
local title = Instance.new("TextLabel")
title.Parent = mainFrame
title.BackgroundTransparency = 1
title.Position = UDim2.new(0, 0, 0, 120)
title.Size = UDim2.new(1, 0, 0, 40)
title.Font = Enum.Font.GothamBold
title.Text = "KOAS ZONE"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 22

-- Controls
local controls = Instance.new("Frame")
controls.Parent = mainFrame
controls.BackgroundTransparency = 1
controls.Position = UDim2.new(1, -90, 0, 8)
controls.Size = UDim2.new(0, 85, 0, 30)

local controlLayout = Instance.new("UIListLayout")
controlLayout.Parent = controls
controlLayout.FillDirection = Enum.FillDirection.Horizontal
controlLayout.Padding = UDim.new(0, 8)

local function createBtn(txt, color)
    local btn = Instance.new("TextButton")
    btn.Parent = controls
    btn.BackgroundColor3 = color
    btn.Size = UDim2.new(0, 30, 0, 30)
    btn.Font = Enum.Font.GothamBold
    btn.Text = txt
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 16
    btn.AutoButtonColor = false
    
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    
    local s = Instance.new("UIStroke")
    s.Thickness = 1
    s.Color = Color3.fromRGB(255, 255, 255)
    s.Transparency = 0.8
    s.Parent = btn
    
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = color:lerp(Color3.fromRGB(255, 255, 255), 0.2)}):Play()
    end)
    
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = color}):Play()
    end)
    
    return btn
end

local minBtn = createBtn("−", Color3.fromRGB(40, 40, 40))
local closeBtn = createBtn("×", Color3.fromRGB(80, 30, 30))

local isMin = false
minBtn.MouseButton1Click:Connect(function()
    isMin = not isMin
    TweenService:Create(mainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
        Size = UDim2.new(0, 600, 0, isMin and 110 or 560)
    }):Play()
end)

closeBtn.MouseButton1Click:Connect(function()
    TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0)
    }):Play()
    task.wait(0.3)
    screenGui:Destroy()
end)

-- Divider
local div = Instance.new("Frame")
div.Parent = mainFrame
div.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
div.BackgroundTransparency = 0.6
div.BorderSizePixel = 0
div.Position = UDim2.new(0, 20, 0, 165)
div.Size = UDim2.new(1, -40, 0, 1)

-- Content
local content = Instance.new("ScrollingFrame")
content.Parent = mainFrame
content.BackgroundTransparency = 1
content.BorderSizePixel = 0
content.Position = UDim2.new(0, 20, 0, 180)
content.Size = UDim2.new(1, -40, 1, -200)
content.ScrollBarThickness = 3
content.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
content.CanvasSize = UDim2.new(0, 0, 0, 0)

local contentLayout = Instance.new("UIListLayout")
contentLayout.Parent = content
contentLayout.Padding = UDim.new(0, 10)

contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    content.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 10)
end)

-- Card maker
local function createCard()
    local card = Instance.new("Frame")
    card.Parent = content
    card.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    card.BorderSizePixel = 0
    card.Size = UDim2.new(1, 0, 0, 70)
    
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 10)
    
    local s = Instance.new("UIStroke")
    s.Color = Color3.fromRGB(50, 50, 50)
    s.Transparency = 0.5
    s.Thickness = 1
    s.Parent = card
    
    local pad = Instance.new("UIPadding")
    pad.Parent = card
    pad.PaddingLeft = UDim.new(0, 18)
    pad.PaddingRight = UDim.new(0, 18)
    pad.PaddingTop = UDim.new(0, 10)
    pad.PaddingBottom = UDim.new(0, 10)
    
    local hover = Instance.new("Frame")
    hover.Parent = card
    hover.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    hover.BackgroundTransparency = 1
    hover.BorderSizePixel = 0
    hover.Size = UDim2.new(1, 0, 1, 0)
    hover.ZIndex = 0
    
    Instance.new("UICorner", hover).CornerRadius = UDim.new(0, 10)
    
    card.MouseEnter:Connect(function()
        TweenService:Create(hover, TweenInfo.new(0.2), {BackgroundTransparency = 0.96}):Play()
        TweenService:Create(s, TweenInfo.new(0.2), {Transparency = 0.2}):Play()
    end)
    
    card.MouseLeave:Connect(function()
        TweenService:Create(hover, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
        TweenService:Create(s, TweenInfo.new(0.2), {Transparency = 0.5}):Play()
    end)
    
    return card
end

local updateFeatures

-- Toggle creator
local function createToggle(txt, order, key, desc)
    local card = createCard()
    card.LayoutOrder = order
    
    local title = Instance.new("TextLabel")
    title.Parent = card
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, -90, 0, 20)
    title.Font = Enum.Font.GothamBold
    title.Text = txt
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 16
    title.TextXAlignment = Enum.TextXAlignment.Left
    
    local sub = Instance.new("TextLabel")
    sub.Parent = card
    sub.BackgroundTransparency = 1
    sub.Position = UDim2.new(0, 0, 0, 22)
    sub.Size = UDim2.new(1, -90, 0, 16)
    sub.Font = Enum.Font.Gotham
    sub.Text = desc
    sub.TextColor3 = Color3.fromRGB(130, 130, 130)
    sub.TextSize = 12
    sub.TextXAlignment = Enum.TextXAlignment.Left
    
    local toggleBg = Instance.new("Frame")
    toggleBg.Parent = card
    toggleBg.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    toggleBg.BorderSizePixel = 0
    toggleBg.AnchorPoint = Vector2.new(1, 0.5)
    toggleBg.Position = UDim2.new(1, 0, 0.5, 0)
    toggleBg.Size = UDim2.new(0, 55, 0, 26)
    toggleBg.ZIndex = 3
    
    Instance.new("UICorner", toggleBg).CornerRadius = UDim.new(1, 0)
    
    local toggleS = Instance.new("UIStroke")
    toggleS.Thickness = 1.5
    toggleS.Color = Color3.fromRGB(60, 60, 60)
    toggleS.Transparency = 0.5
    toggleS.Parent = toggleBg
    
    local circle = Instance.new("Frame")
    circle.Parent = toggleBg
    circle.BackgroundColor3 = Color3.fromRGB(160, 160, 160)
    circle.BorderSizePixel = 0
    circle.Position = UDim2.new(0, 3, 0.5, -10)
    circle.Size = UDim2.new(0, 20, 0, 20)
    circle.ZIndex = 4
    
    Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)
    
    local btn = Instance.new("TextButton")
    btn.Parent = toggleBg
    btn.BackgroundTransparency = 1
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.Text = ""
    btn.ZIndex = 5
    
    local status = Instance.new("TextLabel")
    status.Parent = card
    status.BackgroundTransparency = 1
    status.Position = UDim2.new(0, 0, 1, -14)
    status.Size = UDim2.new(1, -90, 0, 12)
    status.Font = Enum.Font.GothamBold
    status.Text = "• DISABLED"
    status.TextColor3 = Color3.fromRGB(90, 90, 90)
    status.TextSize = 10
    status.TextXAlignment = Enum.TextXAlignment.Left
    
    btn.MouseButton1Click:Connect(function()
        state[key] = not state[key]
        local t = TweenInfo.new(0.25, Enum.EasingStyle.Quad)
        
        if state[key] then
            TweenService:Create(toggleBg, t, {BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
            TweenService:Create(circle, t, {
                Position = UDim2.new(1, -23, 0.5, -10),
                BackgroundColor3 = Color3.fromRGB(18, 18, 18)
            }):Play()
            status.Text = "• ENABLED"
            status.TextColor3 = Color3.fromRGB(200, 200, 200)
        else
            TweenService:Create(toggleBg, t, {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
            TweenService:Create(circle, t, {
                Position = UDim2.new(0, 3, 0.5, -10),
                BackgroundColor3 = Color3.fromRGB(160, 160, 160)
            }):Play()
            status.Text = "• DISABLED"
            status.TextColor3 = Color3.fromRGB(90, 90, 90)
        end
        
        updateFeatures()
    end)
end

-- Slider creator
local function createSlider(txt, order, key, min, max, suffix, desc)
    local card = createCard()
    card.LayoutOrder = order
    card.Size = UDim2.new(1, 0, 0, 75)
    
    local title = Instance.new("TextLabel")
    title.Parent = card
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(0.5, 0, 0, 20)
    title.Font = Enum.Font.GothamBold
    title.Text = txt
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 15
    title.TextXAlignment = Enum.TextXAlignment.Left
    
    local sub = Instance.new("TextLabel")
    sub.Parent = card
    sub.BackgroundTransparency = 1
    sub.Position = UDim2.new(0, 0, 0, 20)
    sub.Size = UDim2.new(1, 0, 0, 16)
    sub.Font = Enum.Font.Gotham
    sub.Text = desc
    sub.TextColor3 = Color3.fromRGB(130, 130, 130)
    sub.TextSize = 12
    sub.TextXAlignment = Enum.TextXAlignment.Left
    
    local val = Instance.new("TextLabel")
    val.Name = "ValueLabel"
    val.Parent = card
    val.BackgroundTransparency = 1
    val.Position = UDim2.new(1, -80, 0, 0)
    val.Size = UDim2.new(0, 75, 0, 20)
    val.Font = Enum.Font.GothamBold
    val.Text = string.format("%.1f", state[key]) .. suffix
    val.TextColor3 = Color3.fromRGB(200, 200, 200)
    val.TextSize = 14
    val.TextXAlignment = Enum.TextXAlignment.Right
    
    local track = Instance.new("Frame")
    track.Name = "Track"
    track.Parent = card
    track.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    track.BorderSizePixel = 0
    track.Position = UDim2.new(0, 0, 1, -16)
    track.Size = UDim2.new(1, 0, 0, 5)
    
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)
    
    local frac = (state[key] - min) / (max - min)
    
    local fill = Instance.new("Frame")
    fill.Name = "Fill"
    fill.Parent = track
    fill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    fill.BorderSizePixel = 0
    fill.Size = UDim2.new(frac, 0, 1, 0)
    
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
    
    local sliderBtn = Instance.new("TextButton")
    sliderBtn.Name = "SliderButton"
    sliderBtn.Parent = track
    sliderBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    sliderBtn.BorderSizePixel = 0
    sliderBtn.Position = UDim2.new(frac, -7, 0.5, -7)
    sliderBtn.Size = UDim2.new(0, 14, 0, 14)
    sliderBtn.Text = ""
    sliderBtn.ZIndex = 2
    
    Instance.new("UICorner", sliderBtn).CornerRadius = UDim.new(1, 0)
    
    local drag = false
    
    sliderBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            drag = true
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if drag and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mouse = UserInputService:GetMouseLocation()
            local pos = (mouse.X - track.AbsolutePosition.X) / track.AbsoluteSize.X
            pos = math.clamp(pos, 0, 1)
            
            state[key] = min + (max - min) * pos
            sliderBtn.Position = UDim2.new(pos, -7, 0.5, -7)
            fill.Size = UDim2.new(pos, 0, 1, 0)
            val.Text = string.format("%.1f", state[key]) .. suffix
            
            updateFeatures()
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            drag = false
        end
    end)
    
    card:SetAttribute("StateKey", key)
    card:SetAttribute("Min", min)
    card:SetAttribute("Max", max)
    card:SetAttribute("Suffix", suffix)
    
    return card
end

-- Create controls
createToggle("Tank Mode", 1, "tankEnabled", "Invincibility while holding weapon")
createToggle("Reach Extended", 2, "reachEnabled", "Extended melee range")
createToggle("Visualize Hitbox", 3, "visualizeHitbox", "Show reach sphere (barely visible)")
local reachSlider = createSlider("Reach Distance", 4, "reachDistance", 5, 25, " studs", "Attack range distance")

-- Function to update slider visually from keybinds
local function updateSliderVisual(sliderCard)
    local key = sliderCard:GetAttribute("StateKey")
    local min = sliderCard:GetAttribute("Min")
    local max = sliderCard:GetAttribute("Max")
    local suffix = sliderCard:GetAttribute("Suffix")
    
    local val = sliderCard:FindFirstChild("ValueLabel")
    local track = sliderCard:FindFirstChild("Track")
    if not val or not track then return end
    
    local fill = track:FindFirstChild("Fill")
    local sliderBtn = track:FindFirstChild("SliderButton")
    if not fill or not sliderBtn then return end
    
    local frac = (state[key] - min) / (max - min)
    
    TweenService:Create(sliderBtn, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
        Position = UDim2.new(frac, -7, 0.5, -7)
    }):Play()
    
    TweenService:Create(fill, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
        Size = UDim2.new(frac, 0, 1, 0)
    }):Play()
    
    val.Text = string.format("%.1f", state[key]) .. suffix
    
    TweenService:Create(val, TweenInfo.new(0.1), {TextColor3 = Color3.fromRGB(100, 255, 100)}):Play()
    task.delay(0.2, function()
        TweenService:Create(val, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(200, 200, 200)}):Play()
    end)
end

-- Keybinds Section
local keybindsCard = createCard()
keybindsCard.LayoutOrder = 5
keybindsCard.Size = UDim2.new(1, 0, 0, 230)

local keybindsTitle = Instance.new("TextLabel")
keybindsTitle.Parent = keybindsCard
keybindsTitle.BackgroundTransparency = 1
keybindsTitle.Size = UDim2.new(1, 0, 0, 24)
keybindsTitle.Font = Enum.Font.GothamBold
keybindsTitle.Text = "KEYBINDS"
keybindsTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
keybindsTitle.TextSize = 18
keybindsTitle.TextXAlignment = Enum.TextXAlignment.Left

local keybindsSubtitle = Instance.new("TextLabel")
keybindsSubtitle.Parent = keybindsCard
keybindsSubtitle.BackgroundTransparency = 1
keybindsSubtitle.Position = UDim2.new(0, 0, 0, 24)
keybindsSubtitle.Size = UDim2.new(1, 0, 0, 18)
keybindsSubtitle.Font = Enum.Font.Gotham
keybindsSubtitle.Text = "Click any button to set a custom keybind"
keybindsSubtitle.TextColor3 = Color3.fromRGB(130, 130, 130)
keybindsSubtitle.TextSize = 12
keybindsSubtitle.TextXAlignment = Enum.TextXAlignment.Left

local keybindsLayout = Instance.new("UIListLayout")
keybindsLayout.Parent = keybindsCard
keybindsLayout.Padding = UDim.new(0, 6)
keybindsLayout.SortOrder = Enum.SortOrder.LayoutOrder

keybindsTitle.LayoutOrder = 0
keybindsSubtitle.LayoutOrder = 1

local function createKeybindButton(name, stateKey, description, order)
    local container = Instance.new("Frame")
    container.Parent = keybindsCard
    container.BackgroundTransparency = 1
    container.Size = UDim2.new(1, 0, 0, 28)
    container.LayoutOrder = order
    
    local label = Instance.new("TextLabel")
    label.Parent = container
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(0.5, -5, 1, 0)
    label.Font = Enum.Font.Gotham
    label.Text = description
    label.TextColor3 = Color3.fromRGB(180, 180, 180)
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local button = Instance.new("TextButton")
    button.Parent = container
    button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    button.BorderSizePixel = 0
    button.Position = UDim2.new(0.5, 5, 0, 0)
    button.Size = UDim2.new(0.5, -5, 1, 0)
    button.Font = Enum.Font.GothamBold
    button.Text = state.keybinds[stateKey].Name
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 12
    button.AutoButtonColor = false
    
    Instance.new("UICorner", button).CornerRadius = UDim.new(0, 6)
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(60, 60, 60)
    stroke.Transparency = 0.5
    stroke.Thickness = 1
    stroke.Parent = button
    
    local listening = false
    
    button.MouseButton1Click:Connect(function()
        if listening then return end
        listening = true
        button.Text = "Press any key..."
        button.TextColor3 = Color3.fromRGB(255, 200, 100)
        TweenService:Create(button, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(50, 50, 30)}):Play()
        
        local conn
        conn = UserInputService.InputBegan:Connect(function(input, gpe)
            if gpe then return end
            if input.UserInputType == Enum.UserInputType.Keyboard then
                state.keybinds[stateKey] = input.KeyCode
                button.Text = input.KeyCode.Name
                button.TextColor3 = Color3.fromRGB(100, 255, 100)
                
                task.delay(0.3, function()
                    button.TextColor3 = Color3.fromRGB(255, 255, 255)
                end)
                
                TweenService:Create(button, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
                listening = false
                conn:Disconnect()
                
                pcall(function()
                    game:GetService("StarterGui"):SetCore("SendNotification", {
                        Title = "Keybind Set",
                        Text = description .. " → " .. input.KeyCode.Name,
                        Duration = 2
                    })
                end)
            end
        end)
    end)
    
    button.MouseEnter:Connect(function()
        if not listening then
            TweenService:Create(button, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
            TweenService:Create(stroke, TweenInfo.new(0.15), {Transparency = 0.2}):Play()
        end
    end)
    
    button.MouseLeave:Connect(function()
        if not listening then
            TweenService:Create(button, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
            TweenService:Create(stroke, TweenInfo.new(0.15), {Transparency = 0.5}):Play()
        end
    end)
end

createKeybindButton("Toggle UI", "toggleUI", "Toggle UI", 2)
createKeybindButton("Toggle Reach", "toggleReach", "Reach On/Off", 3)
createKeybindButton("Toggle Tank", "toggleTank", "Tank On/Off", 4)
createKeybindButton("Reach +1", "reachIncrease", "Increase Reach", 5)
createKeybindButton("Reach -1", "reachDecrease", "Decrease Reach", 6)

-- Draggable
local drag, dragStart, startPos

local function updateDrag(input)
    local delta = input.Position - dragStart
    mainFrame.Position = UDim2.new(
        startPos.X.Scale, startPos.X.Offset + delta.X,
        startPos.Y.Scale, startPos.Y.Offset + delta.Y
    )
end

userPanel.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        drag = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if drag and input.UserInputType == Enum.UserInputType.MouseMovement then
        updateDrag(input)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        drag = false
    end
end)

-- Entrance
mainFrame.Size = UDim2.new(0, 0, 0, 0)
mainFrame.Visible = true
TweenService:Create(mainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 600, 0, 560)
}):Play()

-- Toggle UI keybinds
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    
    if input.KeyCode == state.keybinds.toggleUI then
        mainFrame.Visible = not mainFrame.Visible
    end
    
    if input.KeyCode == state.keybinds.toggleReach then
        state.reachEnabled = not state.reachEnabled
        updateFeatures()
        
        pcall(function()
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Reach Extended",
                Text = state.reachEnabled and "ENABLED" or "DISABLED",
                Duration = 2
            })
        end)
    end
    
    if input.KeyCode == state.keybinds.toggleTank then
        state.tankEnabled = not state.tankEnabled
        updateFeatures()
        
        pcall(function()
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Tank Mode",
                Text = state.tankEnabled and "ENABLED" or "DISABLED",
                Duration = 2
            })
        end)
    end
    
    if input.KeyCode == state.keybinds.reachIncrease then
        if state.reachDistance < 25 then
            state.reachDistance = state.reachDistance + 1
            updateSliderVisual(reachSlider)
            
            pcall(function()
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "Reach Distance",
                    Text = "Increased to " .. state.reachDistance .. " studs",
                    Duration = 1.5
                })
            end)
        end
    end
    
    if input.KeyCode == state.keybinds.reachDecrease then
        if state.reachDistance > 5 then
            state.reachDistance = state.reachDistance - 1
            updateSliderVisual(reachSlider)
            
            pcall(function()
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "Reach Distance",
                    Text = "Decreased to " .. state.reachDistance .. " studs",
                    Duration = 1.5
                })
            end)
        end
    end
end)

-- Features (NEW REACH SYSTEM)
function updateFeatures()
    for key, conn in pairs(state.connections) do
        pcall(function()
            if type(conn) == "thread" then
                task.cancel(conn)
            elseif conn.Disconnect then
                conn:Disconnect()
            end
        end)
    end
    state.connections = {}
    
    for _, obj in pairs(workspace:GetChildren()) do
        if obj.Name == "SwordReachVisual" then
            obj:Destroy()
        end
    end
    for _, hitbox in ipairs(state.hitboxParts) do
        if hitbox and hitbox.Parent then
            hitbox:Destroy()
        end
    end
    state.hitboxParts = {}
    
    local char = player.Character
    if not char then return end
    local hum = char:FindFirstChild("Humanoid")
    if not hum then return end
    
    -- Tank Mode
    if state.tankEnabled then
        print("Tank Mode: ENABLED")
        state.connections.tankLoop = RunService.Stepped:Connect(function()
            if not state.tankEnabled then return end
            pcall(function()
                local hasTool = char:FindFirstChildOfClass("Tool") ~= nil
                for _, part in ipairs(char:GetChildren()) do
                    if part:IsA("Part") then
                        part.CanTouch = hasTool
                    end
                end
            end)
        end)
    end
    
    -- NEW Reach System (Breaks joints like the reference script)
    if state.reachEnabled then
        print("Reach Extended: ENABLED - Distance: " .. state.reachDistance)
        
        state.connections.reachLoop = RunService.Stepped:Connect(function()
            if not state.reachEnabled then return end
            
            pcall(function()
                local tool = char:FindFirstChildOfClass("Tool")
                local swordHandle = tool and tool:FindFirstChild("Handle")
                
                if not swordHandle then 
                    for _, obj in pairs(workspace:GetChildren()) do
                        if obj.Name == "SwordReachVisual" then
                            obj:Destroy()
                        end
                    end
                    state.hitboxParts = {}
                    return 
                end
                
                -- Visual hitbox (if enabled)
                if state.visualizeHitbox then
                    for _, obj in pairs(workspace:GetChildren()) do
                        if obj.Name == "SwordReachVisual" then
                            obj:Destroy()
                        end
                    end
                    
                    local visualSphere = Instance.new("Part")
                    visualSphere.Name = "SwordReachVisual"
                    visualSphere.Shape = Enum.PartType.Ball
                    visualSphere.Size = Vector3.new(state.reachDistance * 2, state.reachDistance * 2, state.reachDistance * 2)
                    visualSphere.Transparency = 0.85
                    visualSphere.Material = Enum.Material.ForceField
                    visualSphere.Color = Color3.fromRGB(255, 100, 100)
                    visualSphere.CanCollide = false
                    visualSphere.CanTouch = false
                    visualSphere.CanQuery = false
                    visualSphere.Massless = true
                    visualSphere.Anchored = true
                    visualSphere.Parent = workspace
                    
                    local myTorso = char:FindFirstChild("Torso") or char:FindFirstChild("HumanoidRootPart")
                    if myTorso then
                        visualSphere.CFrame = CFrame.new(myTorso.Position)
                    end
                    state.hitboxParts = {visualSphere}
                    
                    local visualConn
                    visualConn = RunService.Heartbeat:Connect(function()
                        if not visualSphere.Parent then 
                            visualConn:Disconnect() 
                            return 
                        end
                        if myTorso and myTorso.Parent then
                            visualSphere.CFrame = CFrame.new(myTorso.Position)
                        else
                            visualSphere:Destroy()
                            visualConn:Disconnect()
                        end
                    end)
                end
                
                -- REACH ATTACK LOGIC (Uses joint breaking like reference script)
                local myTorso = char:FindFirstChild("Torso") or char:FindFirstChild("HumanoidRootPart")
                if not myTorso then return end
                
                for _, v in pairs(Players:GetPlayers()) do 
                    if v ~= player and v.Character and v.Character ~= char then
                        local enemyTorso = v.Character:FindFirstChild("Torso") or v.Character:FindFirstChild("HumanoidRootPart")
                        local enemyLeftArm = v.Character:FindFirstChild("Left Arm")
                        local enemyLeftLeg = v.Character:FindFirstChild("Left Leg")
                        
                        if enemyTorso and (myTorso.Position - enemyTorso.Position).Magnitude <= state.reachDistance then
                            -- Break joints and teleport limbs (exact method from reference script)
                            for _, limbName in ipairs({"Left Arm", "Left Leg"}) do
                                local limb = v.Character:FindFirstChild(limbName)
                                if limb then
                                    limb:BreakJoints()
                                    limb.Transparency = 1
                                    limb.CanCollide = false
                                    limb.CFrame = myTorso.CFrame * CFrame.new(1, 0, -3.5)
                                end
                            end
                        end
                    end
                end
            end)
        end)
    end
end

task.wait(0.5)
updateFeatures()

player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoid = newChar:WaitForChild("Humanoid")
    state.hitboxParts = {}
    task.wait(0.5)
    updateFeatures()
end)

pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "KOAS ZONE PREMIUM",
        Text = "Loaded! Press Right Control to toggle UI.",
        Duration = 5,
    })
end)

print("━━━━━━━━━━━━━━━━━━━━━━━━━")
print("  KOAS ZONE PREMIUM")
print("━━━━━━━━━━━━━━━━━━━━━━━━━")
print("Right Control = Toggle UI")
print("Q = Toggle Reach | Z = Toggle Tank")
print("J = Reach +1 | K = Reach -1")
print("━━━━━━━━━━━━━━━━━━━━━━━━━")
