local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- == CONFIGURATION & STATE ==
local state = {
    tankEnabled = false,
    reachEnabled = false,
    visualizeHitbox = false,
    damageMultiplier = 1,
    damageReduction = 50,
    reachDistance = 8,
    hitboxParts = {},
    connections = {},
    originalHealth = 100
}

-- == SPLASH SCREEN ==
local splashGui = Instance.new("ScreenGui")
splashGui.Name = "KoasSplash"
splashGui.Parent = player:WaitForChild("PlayerGui")
splashGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
splashGui.ResetOnSpawn = false
splashGui.IgnoreGuiInset = true

local splashBg = Instance.new("Frame")
splashBg.Parent = splashGui
splashBg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
splashBg.BorderSizePixel = 0
splashBg.Size = UDim2.new(1, 0, 1, 0)

local splashText = Instance.new("TextLabel")
splashText.Parent = splashBg
splashText.BackgroundTransparency = 1
splashText.Position = UDim2.new(0.5, 0, 0.5, 0)
splashText.AnchorPoint = Vector2.new(0.5, 0.5)
splashText.Size = UDim2.new(0, 0, 0, 100)
splashText.Font = Enum.Font.GothamBold
splashText.Text = "KOAS ZONE"
splashText.TextColor3 = Color3.fromRGB(255, 255, 255)
splashText.TextSize = 1
splashText.TextTransparency = 1

task.spawn(function()
    for _ = 1, 3 do
        TweenService:Create(splashText, TweenInfo.new(0.15), {TextTransparency = 0}):Play()
        task.wait(0.15)
        TweenService:Create(splashText, TweenInfo.new(0.15), {TextTransparency = 1}):Play()
        task.wait(0.15)
    end

    TweenService:Create(splashText, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
    TweenService:Create(
        splashText,
        TweenInfo.new(1, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {TextSize = 80, Size = UDim2.new(0, 600, 0, 100)}
    ):Play()

    task.wait(1.5)

    TweenService:Create(splashBg, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
    TweenService:Create(splashText, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
    task.wait(0.5)
    splashGui:Destroy()
end)

task.wait(3)

-- == UI CREATION ==
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "KoasZoneHub"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true

-- main floating frame (no black full‑screen background)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Parent = screenGui
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.Position = UDim2.new(0.5, -260, 0.5, -230)
mainFrame.Size = UDim2.new(0, 520, 0, 480)
mainFrame.ClipsDescendants = true

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 18)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Thickness = 1.4
mainStroke.Color = Color3.fromRGB(255, 255, 255)
mainStroke.Transparency = 0.75
mainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
mainStroke.Parent = mainFrame

local mainPadding = Instance.new("UIPadding")
mainPadding.Parent = mainFrame
mainPadding.PaddingLeft = UDim.new(0, 14)
mainPadding.PaddingRight = UDim.new(0, 14)
mainPadding.PaddingTop = UDim.new(0, 12)
mainPadding.PaddingBottom = UDim.new(0, 12)

-- Title bar
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Parent = mainFrame
titleBar.BackgroundTransparency = 1
titleBar.Size = UDim2.new(1, 0, 0, 48)

local titleLayout = Instance.new("UIListLayout")
titleLayout.FillDirection = Enum.FillDirection.Horizontal
titleLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
titleLayout.VerticalAlignment = Enum.VerticalAlignment.Center
titleLayout.Padding = UDim.new(0, 10)
titleLayout.Parent = titleBar

local titleLeft = Instance.new("Frame")
titleLeft.Name = "TitleLeft"
titleLeft.Parent = titleBar
titleLeft.BackgroundTransparency = 1
titleLeft.Size = UDim2.new(1, -120, 1, 0)

local leftLayout = Instance.new("UIListLayout")
leftLayout.FillDirection = Enum.FillDirection.Horizontal
leftLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
leftLayout.VerticalAlignment = Enum.VerticalAlignment.Center
leftLayout.Padding = UDim.new(0, 10)
leftLayout.Parent = titleLeft

local logo = Instance.new("Frame")
logo.Name = "Logo"
logo.Parent = titleLeft
logo.Size = UDim2.new(0, 32, 0, 32)
logo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
logo.BackgroundTransparency = 0.85

local logoCorner = Instance.new("UICorner")
logoCorner.CornerRadius = UDim.new(0, 10)
logoCorner.Parent = logo

local logoStroke = Instance.new("UIStroke")
logoStroke.Color = Color3.fromRGB(255, 255, 255)
logoStroke.Transparency = 0.4
logoStroke.Thickness = 1
logoStroke.Parent = logo

local logoLabel = Instance.new("TextLabel")
logoLabel.Parent = logo
logoLabel.BackgroundTransparency = 1
logoLabel.Size = UDim2.new(1, 0, 1, 0)
logoLabel.Font = Enum.Font.GothamBold
logoLabel.Text = "K"
logoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
logoLabel.TextScaled = true

local titleTextContainer = Instance.new("Frame")
titleTextContainer.Name = "TitleTextContainer"
titleTextContainer.Parent = titleLeft
titleTextContainer.BackgroundTransparency = 1
titleTextContainer.Size = UDim2.new(1, -42, 1, 0)

local titleTextLayout = Instance.new("UIListLayout")
titleTextLayout.FillDirection = Enum.FillDirection.Vertical
titleTextLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
titleTextLayout.VerticalAlignment = Enum.VerticalAlignment.Center
titleTextLayout.Parent = titleTextContainer

local titleLabel = Instance.new("TextLabel")
titleLabel.Parent = titleTextContainer
titleLabel.BackgroundTransparency = 1
titleLabel.Size = UDim2.new(1, 0, 0, 22)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Text = "KOAS ZONE"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 22
titleLabel.TextXAlignment = Enum.TextXAlignment.Left

local subtitleLabel = Instance.new("TextLabel")
subtitleLabel.Parent = titleTextContainer
subtitleLabel.BackgroundTransparency = 1
subtitleLabel.Size = UDim2.new(1, 0, 0, 18)
subtitleLabel.Font = Enum.Font.Gotham
subtitleLabel.Text = "Combat Enhancer"
subtitleLabel.TextColor3 = Color3.fromRGB(160, 160, 160)
subtitleLabel.TextSize = 14
subtitleLabel.TextXAlignment = Enum.TextXAlignment.Left

local titleRight = Instance.new("Frame")
titleRight.Name = "TitleRight"
titleRight.Parent = titleBar
titleRight.BackgroundTransparency = 1
titleRight.Size = UDim2.new(0, 110, 1, 0)

local rightLayout = Instance.new("UIListLayout")
rightLayout.FillDirection = Enum.FillDirection.Horizontal
rightLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
rightLayout.VerticalAlignment = Enum.VerticalAlignment.Center
rightLayout.Padding = UDim.new(0, 6)
rightLayout.Parent = titleRight

local function createTitleButton(text, baseColor)
    local btn = Instance.new("TextButton")
    btn.BackgroundColor3 = baseColor
    btn.BorderSizePixel = 0
    btn.Size = UDim2.new(0, 34, 0, 34)
    btn.Font = Enum.Font.GothamBold
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 20
    btn.AutoButtonColor = false

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = btn

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {
            BackgroundColor3 = baseColor:lerp(Color3.fromRGB(255, 255, 255), 0.15),
            Size = UDim2.new(0, 37, 0, 37)
        }):Play()
    end)

    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {
            BackgroundColor3 = baseColor,
            Size = UDim2.new(0, 34, 0, 34)
        }):Play()
    end)

    return btn
end

local minimizeButton = createTitleButton("−", Color3.fromRGB(60, 60, 60))
minimizeButton.Name = "MinimizeButton"
minimizeButton.Parent = titleRight

local closeButton = createTitleButton("×", Color3.fromRGB(90, 40, 40))
closeButton.Name = "CloseButton"
closeButton.Parent = titleRight

local isMinimized = false

closeButton.MouseButton1Click:Connect(function()
    TweenService:Create(
        mainFrame,
        TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.In),
        {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1}
    ):Play()
    task.wait(0.25)
    screenGui:Destroy()
end)

minimizeButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        TweenService:Create(
            mainFrame,
            TweenInfo.new(0.25, Enum.EasingStyle.Quad),
            {Size = UDim2.new(0, 520, 0, 70)}
        ):Play()
    else
        TweenService:Create(
            mainFrame,
            TweenInfo.new(0.25, Enum.EasingStyle.Quad),
            {Size = UDim2.new(0, 520, 0, 480)}
        ):Play()
    end
end)

-- Divider under title
local divider = Instance.new("Frame")
divider.Name = "Divider"
divider.Parent = mainFrame
divider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
divider.BackgroundTransparency = 0.8
divider.BorderSizePixel = 0
divider.Position = UDim2.new(0, 0, 0, 52)
divider.Size = UDim2.new(1, 0, 0, 1)

-- == PLAYER INFO HEADER ==
local playerInfo = Instance.new("Frame")
playerInfo.Name = "PlayerInfo"
playerInfo.Parent = mainFrame
playerInfo.BackgroundTransparency = 1
playerInfo.Position = UDim2.new(0, 0, 0, 56)
playerInfo.Size = UDim2.new(1, 0, 0, 80)

local infoLayout = Instance.new("UIListLayout")
infoLayout.FillDirection = Enum.FillDirection.Horizontal
infoLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
infoLayout.VerticalAlignment = Enum.VerticalAlignment.Center
infoLayout.Padding = UDim.new(0, 10)
infoLayout.Parent = playerInfo

-- avatar circle
local avatarHolder = Instance.new("Frame")
avatarHolder.Name = "AvatarHolder"
avatarHolder.Parent = playerInfo
avatarHolder.BackgroundTransparency = 1
avatarHolder.Size = UDim2.new(0, 64, 0, 64)

local avatarImage = Instance.new("ImageLabel")
avatarImage.Parent = avatarHolder
avatarImage.BackgroundTransparency = 1
avatarImage.Size = UDim2.new(1, 0, 1, 0)
avatarImage.ScaleType = Enum.ScaleType.Crop

local avatarCorner = Instance.new("UICorner")
avatarCorner.CornerRadius = UDim.new(1, 0)
avatarCorner.Parent = avatarImage

local avatarStroke = Instance.new("UIStroke")
avatarStroke.Color = Color3.fromRGB(255, 255, 255)
avatarStroke.Transparency = 0.4
avatarStroke.Thickness = 1
avatarStroke.Parent = avatarImage

-- load avatar headshot
local thumbType = Enum.ThumbnailType.HeadShot
local thumbSize = Enum.ThumbnailSize.Size100x100
local content, _ = Players:GetUserThumbnailAsync(player.UserId, thumbType, thumbSize)
avatarImage.Image = content  -- Roblox API provides thumbnail URL

-- text info
local infoTextFrame = Instance.new("Frame")
infoTextFrame.Name = "InfoText"
infoTextFrame.Parent = playerInfo
infoTextFrame.BackgroundTransparency = 1
infoTextFrame.Size = UDim2.new(1, -80, 1, 0)

local infoTextLayout = Instance.new("UIListLayout")
infoTextLayout.FillDirection = Enum.FillDirection.Vertical
infoTextLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
infoTextLayout.VerticalAlignment = Enum.VerticalAlignment.Center
infoTextLayout.Parent = infoTextFrame

local nameLabel = Instance.new("TextLabel")
nameLabel.Parent = infoTextFrame
nameLabel.BackgroundTransparency = 1
nameLabel.Size = UDim2.new(1, 0, 0, 22)
nameLabel.Font = Enum.Font.GothamBold
nameLabel.Text = player.Name .. "  |  ID: " .. player.UserId
nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
nameLabel.TextSize = 18
nameLabel.TextXAlignment = Enum.TextXAlignment.Left

local extraLabel1 = Instance.new("TextLabel")
extraLabel1.Parent = infoTextFrame
extraLabel1.BackgroundTransparency = 1
extraLabel1.Size = UDim2.new(1, 0, 0, 18)
extraLabel1.Font = Enum.Font.Gotham
extraLabel1.TextColor3 = Color3.fromRGB(180, 180, 180)
extraLabel1.TextSize = 13
extraLabel1.TextXAlignment = Enum.TextXAlignment.Left
extraLabel1.Text = "Health: loading..."

local extraLabel2 = Instance.new("TextLabel")
extraLabel2.Parent = infoTextFrame
extraLabel2.BackgroundTransparency = 1
extraLabel2.Size = UDim2.new(1, 0, 0, 18)
extraLabel2.Font = Enum.Font.Gotham
extraLabel2.TextColor3 = Color3.fromRGB(150, 150, 150)
extraLabel2.TextSize = 13
extraLabel2.TextXAlignment = Enum.TextXAlignment.Left
extraLabel2.Text = "Game: " .. (game.Name ~= "" and game.Name or "Unnamed place")

-- update health display
task.spawn(function()
    local hum = character:FindFirstChildOfClass("Humanoid")
    if hum then
        extraLabel1.Text = "Health: " .. math.floor(hum.Health) .. " / " .. math.floor(hum.MaxHealth)
        hum.HealthChanged:Connect(function(h)
            extraLabel1.Text = "Health: " .. math.floor(h) .. " / " .. math.floor(hum.MaxHealth)
        end)
    else
        extraLabel1.Text = "Health: N/A"
    end
end)

-- second divider under player info
local divider2 = Instance.new("Frame")
divider2.Name = "Divider2"
divider2.Parent = mainFrame
divider2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
divider2.BackgroundTransparency = 0.85
divider2.BorderSizePixel = 0
divider2.Position = UDim2.new(0, 0, 0, 140)
divider2.Size = UDim2.new(1, 0, 0, 1)

-- Content Frame
local contentFrame = Instance.new("ScrollingFrame")
contentFrame.Name = "ContentFrame"
contentFrame.Parent = mainFrame
contentFrame.Active = true
contentFrame.BackgroundTransparency = 1
contentFrame.BorderSizePixel = 0
contentFrame.Position = UDim2.new(0, 4, 0, 148)
contentFrame.Size = UDim2.new(1, -8, 1, -160)
contentFrame.ScrollBarThickness = 4
contentFrame.ScrollBarImageColor3 = Color3.fromRGB(160, 160, 160)
contentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)

local contentLayout = Instance.new("UIListLayout")
contentLayout.Parent = contentFrame
contentLayout.Padding = UDim.new(0, 10)
contentLayout.SortOrder = Enum.SortOrder.LayoutOrder

contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    contentFrame.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 10)
end)

-- card helper
local function createCard()
    local container = Instance.new("Frame")
    container.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    container.BackgroundTransparency = 0.1
    container.BorderSizePixel = 0
    container.Size = UDim2.new(1, 0, 0, 70)

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = container

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Transparency = 0.85
    stroke.Thickness = 1
    stroke.Parent = container

    local pad = Instance.new("UIPadding")
    pad.Parent = container
    pad.PaddingLeft = UDim.new(0, 18)
    pad.PaddingRight = UDim.new(0, 18)
    pad.PaddingTop = UDim.new(0, 10)
    pad.PaddingBottom = UDim.new(0, 10)

    local hoverHighlight = Instance.new("Frame")
    hoverHighlight.Parent = container
    hoverHighlight.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    hoverHighlight.BackgroundTransparency = 1
    hoverHighlight.BorderSizePixel = 0
    hoverHighlight.Size = UDim2.new(1, 0, 1, 0)
    hoverHighlight.ZIndex = 0

    local hoverCorner = Instance.new("UICorner")
    hoverCorner.CornerRadius = UDim.new(0, 12)
    hoverCorner.Parent = hoverHighlight

    container.MouseEnter:Connect(function()
        TweenService:Create(hoverHighlight, TweenInfo.new(0.15), {BackgroundTransparency = 0.93}):Play()
    end)
    container.MouseLeave:Connect(function()
        TweenService:Create(hoverHighlight, TweenInfo.new(0.15), {BackgroundTransparency = 1}):Play()
    end)

    return container
end

-- toggles
local function createToggle(text, layoutOrder, stateKey, description)
    local container = createCard()
    container.Name = text .. "Card"
    container.Parent = contentFrame
    container.LayoutOrder = layoutOrder

    local title = Instance.new("TextLabel")
    title.Parent = container
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, -120, 0, 22)
    title.Font = Enum.Font.GothamBold
    title.Text = text
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 18
    title.TextXAlignment = Enum.TextXAlignment.Left

    local subtitle = Instance.new("TextLabel")
    subtitle.Parent = container
    subtitle.BackgroundTransparency = 1
    subtitle.Position = UDim2.new(0, 0, 0, 24)
    subtitle.Size = UDim2.new(1, -120, 0, 20)
    subtitle.Font = Enum.Font.Gotham
    subtitle.Text = description or "Toggle this feature."
    subtitle.TextColor3 = Color3.fromRGB(145, 145, 145)
    subtitle.TextSize = 13
    subtitle.TextXAlignment = Enum.TextXAlignment.Left

    local toggleBg = Instance.new("Frame")
    toggleBg.Name = "ToggleBg"
    toggleBg.Parent = container
    toggleBg.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    toggleBg.BorderSizePixel = 0
    toggleBg.AnchorPoint = Vector2.new(1, 0.5)
    toggleBg.Position = UDim2.new(1, -4, 0.5, 0)
    toggleBg.Size = UDim2.new(0, 70, 0, 30)
    toggleBg.ZIndex = 3

    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(1, 0)
    toggleCorner.Parent = toggleBg

    local toggleCircle = Instance.new("Frame")
    toggleCircle.Name = "Circle"
    toggleCircle.Parent = toggleBg
    toggleCircle.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    toggleCircle.BorderSizePixel = 0
    toggleCircle.Position = UDim2.new(0, 3, 0.5, -12)
    toggleCircle.Size = UDim2.new(0, 24, 0, 24)
    toggleCircle.ZIndex = 4

    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(1, 0)
    circleCorner.Parent = toggleCircle

    local button = Instance.new("TextButton")
    button.Name = "Button"
    button.Parent = toggleBg
    button.BackgroundTransparency = 1
    button.Size = UDim2.new(1, 0, 1, 0)
    button.Text = ""
    button.ZIndex = 5

    local statusLabel = Instance.new("TextLabel")
    statusLabel.Parent = container
    statusLabel.BackgroundTransparency = 1
    statusLabel.Position = UDim2.new(0, 0, 1, -18)
    statusLabel.Size = UDim2.new(1, -120, 0, 16)
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.Text = "Disabled"
    statusLabel.TextColor3 = Color3.fromRGB(120, 120, 120)
    statusLabel.TextSize = 12
    statusLabel.TextXAlignment = Enum.TextXAlignment.Left

    button.MouseButton1Click:Connect(function()
        state[stateKey] = not state[stateKey]
        local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

        if state[stateKey] then
            TweenService:Create(toggleBg, tweenInfo, {BackgroundColor3 = Color3.fromRGB(200, 200, 200)}):Play()
            TweenService:Create(toggleCircle, tweenInfo, {
                Position = UDim2.new(1, -27, 0.5, -12),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            }):Play()
            statusLabel.Text = "Enabled"
            statusLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
        else
            TweenService:Create(toggleBg, tweenInfo, {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}):Play()
            TweenService:Create(toggleCircle, tweenInfo, {
                Position = UDim2.new(0, 3, 0.5, -12),
                BackgroundColor3 = Color3.fromRGB(200, 200, 200)
            }):Play()
            statusLabel.Text = "Disabled"
            statusLabel.TextColor3 = Color3.fromRGB(120, 120, 120)
        end

        updateFeatures()
    end)
end

-- sliders
local function createSlider(text, layoutOrder, stateKey, min, max, suffix, description)
    local container = createCard()
    container.Name = text .. "Card"
    container.Parent = contentFrame
    container.LayoutOrder = layoutOrder
    container.Size = UDim2.new(1, 0, 0, 78)

    local label = Instance.new("TextLabel")
    label.Parent = container
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(0.55, 0, 0, 22)
    label.Font = Enum.Font.GothamBold
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 16
    label.TextXAlignment = Enum.TextXAlignment.Left

    local sub = Instance.new("TextLabel")
    sub.Parent = container
    sub.BackgroundTransparency = 1
    sub.Position = UDim2.new(0, 0, 0, 22)
    sub.Size = UDim2.new(1, -40, 0, 18)
    sub.Font = Enum.Font.Gotham
    sub.Text = description or "Drag to adjust."
    sub.TextColor3 = Color3.fromRGB(145, 145, 145)
    sub.TextSize = 13
    sub.TextXAlignment = Enum.TextXAlignment.Left

    local valueLabel = Instance.new("TextLabel")
    valueLabel.Parent = container
    valueLabel.BackgroundTransparency = 1
    valueLabel.Position = UDim2.new(1, -90, 0, 0)
    valueLabel.Size = UDim2.new(0, 80, 0, 22)
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.Text = string.format("%.1f", state[stateKey]) .. suffix
    valueLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    valueLabel.TextSize = 16
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right

    local sliderTrack = Instance.new("Frame")
    sliderTrack.Name = "Track"
    sliderTrack.Parent = container
    sliderTrack.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    sliderTrack.BorderSizePixel = 0
    sliderTrack.Position = UDim2.new(0, 0, 1, -18)
    sliderTrack.Size = UDim2.new(1, 0, 0, 6)

    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(1, 0)
    trackCorner.Parent = sliderTrack

    local fraction = (state[stateKey] - min) / (max - min)

    local sliderFill = Instance.new("Frame")
    sliderFill.Name = "Fill"
    sliderFill.Parent = sliderTrack
    sliderFill.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    sliderFill.BorderSizePixel = 0
    sliderFill.Size = UDim2.new(fraction, 0, 1, 0)

    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = sliderFill

    local sliderButton = Instance.new("TextButton")
    sliderButton.Name = "Button"
    sliderButton.Parent = sliderTrack
    sliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    sliderButton.BorderSizePixel = 0
    sliderButton.Position = UDim2.new(fraction, -8, 0.5, -8)
    sliderButton.Size = UDim2.new(0, 16, 0, 16)
    sliderButton.Text = ""
    sliderButton.AutoButtonColor = false
    sliderButton.ZIndex = 2

    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(1, 0)
    buttonCorner.Parent = sliderButton

    local dragging = false

    sliderButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = UserInputService:GetMouseLocation()
            local trackPos = sliderTrack.AbsolutePosition
            local trackSize = sliderTrack.AbsoluteSize
            local relativePos = math.clamp((mousePos.X - trackPos.X) / trackSize.X, 0, 1)

            state[stateKey] = min + (max - min) * relativePos
            sliderButton.Position = UDim2.new(relativePos, -8, 0.5, -8)
            sliderFill.Size = UDim2.new(relativePos, 0, 1, 0)
            valueLabel.Text = string.format("%.1f", state[stateKey]) .. suffix

            updateFeatures()
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

-- create controls
createToggle("Tank Mode", 1, "tankEnabled", "Massive resistance and anti‑death routines.")
createSlider("Damage Resistance", 2, "damageReduction", 0, 100, "%", "Percentage of damage blocked.")
createToggle("Reach Extended", 3, "reachEnabled", "Expands your melee hitbox radius.")
createToggle("Visualize Hitbox", 4, "visualizeHitbox", "Show reach hitbox as a white cube.")
createSlider("Damage Multiplier", 5, "damageMultiplier", 1, 10, "x", "Scales base damage dealt.")
createSlider("Reach Distance", 6, "reachDistance", 1, 20, " studs", "Size of the reach hitbox cube.")

-- draggable hub
local draggingFrame = false
local dragInput, dragStart, startPos

local function updateDrag(input)
    local delta = input.Position - dragStart
    TweenService:Create(
        mainFrame,
        TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)}
    ):Play()
end

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        draggingFrame = true
        dragStart = input.Position
        startPos = mainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                draggingFrame = false
            end
        end)
    end
end)

titleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and draggingFrame then
        updateDrag(input)
    end
end)

-- entrance animation
mainFrame.Size = UDim2.new(0, 0, 0, 0)
mainFrame.Visible = true
TweenService:Create(
    mainFrame,
    TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    {Size = UDim2.new(0, 520, 0, 480)}
):Play()

-- toggle with Right Shift
UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.RightShift then
        if mainFrame.Visible then
            TweenService:Create(
                mainFrame,
                TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.In),
                {Size = UDim2.new(0, 0, 0, 0)}
            ):Play()
            task.wait(0.25)
            mainFrame.Visible = false
        else
            mainFrame.Visible = true
            TweenService:Create(
                mainFrame,
                TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
                {Size = UDim2.new(0, 520, 0, 480)}
            ):Play()
        end
    end
end)

-- == FEATURE IMPLEMENTATION ==
function updateFeatures()
    -- Tank Mode
    if state.tankEnabled then
        local humanoid = character:FindFirstChild("Humanoid")
        local rootPart = character:FindFirstChild("HumanoidRootPart")

        if humanoid and rootPart then
            for connName, conn in pairs(state.connections) do
                if connName:match("^tank") and conn then
                    if type(conn) == "thread" then
                        task.cancel(conn)
                    elseif conn.Disconnect then
                        conn:Disconnect()
                    end
                    state.connections[connName] = nil
                end
            end

            for _, part in ipairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    if not part:GetAttribute("OriginalMassless") then
                        part:SetAttribute("OriginalMassless", part.Massless)
                        part:SetAttribute("OriginalCanCollide", part.CanCollide)
                    end
                    part.Massless = true
                    if not part:GetAttribute("TankCollisionSet") then
                        pcall(function()
                            part.CollisionGroup = "TankMode"
                        end)
                        part:SetAttribute("TankCollisionSet", true)
                    end
                end
            end

            humanoid.MaxHealth = math.huge
            task.wait()
            humanoid.Health = math.huge
            local refHealth = humanoid.Health

            state.connections.tankStepped = RunService.Stepped:Connect(function()
                if not state.tankEnabled then return end
                pcall(function()
                    if humanoid.Health <= 0 or humanoid:GetState() == Enum.HumanoidStateType.Dead then
                        humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
                        humanoid.Health = math.huge
                    elseif state.damageReduction >= 100 then
                        humanoid.Health = math.huge
                    elseif humanoid.Health < refHealth then
                        local damage = refHealth - humanoid.Health
                        humanoid.Health = humanoid.Health + (damage * state.damageReduction / 100)
                    end
                    refHealth = humanoid.Health
                end)
            end)

            state.connections.tankHeartbeat = RunService.Heartbeat:Connect(function()
                if not state.tankEnabled then return end
                pcall(function()
                    if humanoid.Health <= 0 then
                        humanoid.Health = math.huge
                        refHealth = math.huge
                    elseif state.damageReduction >= 100 and humanoid.Health ~= math.huge then
                        humanoid.Health = math.huge
                        refHealth = math.huge
                    end
                end)
            end)

            state.connections.tankState = humanoid.StateChanged:Connect(function(_, newState)
                if state.tankEnabled and newState == Enum.HumanoidStateType.Dead then
                    pcall(function()
                        humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
                        task.wait()
                        humanoid.Health = math.huge
                        refHealth = math.huge
                    end)
                end
            end)

            state.connections.tankDied = humanoid.Died:Connect(function()
                if state.tankEnabled then
                    pcall(function()
                        task.wait()
                        humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
                        humanoid.Health = math.huge
                        refHealth = math.huge
                    end)
                end
            end)

            state.connections.tankLoop = task.spawn(function()
                while state.tankEnabled do
                    local success = pcall(function()
                        if humanoid and humanoid.Parent then
                            if humanoid.Health <= 0 or humanoid:GetState() == Enum.HumanoidStateType.Dead then
                                humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
                                humanoid.Health = math.huge
                                refHealth = math.huge
                            elseif state.damageReduction >= 100 and humanoid.Health < math.huge then
                                humanoid.Health = math.huge
                                refHealth = math.huge
                            end
                        end
                    end)
                    if not success or not humanoid or not humanoid.Parent then
                        return
                    end
                    task.wait()
                end
            end)

            if not character:FindFirstChild("TankFF") then
                local ff = Instance.new("ForceField")
                ff.Name = "TankFF"
                ff.Visible = false
                ff.Parent = character
            end

            state.connections.tankChildAdded = character.ChildAdded:Connect(function(child)
                if state.tankEnabled and (child:IsA("Script") or child:IsA("LocalScript")) then
                    local n = child.Name:lower()
                    if n:find("damage") or n:find("hurt") or n:find("dmg") then
                        pcall(function()
                            child:Destroy()
                        end)
                    end
                end
            end)
        end
    else
        for connName, conn in pairs(state.connections) do
            if connName:match("^tank") then
                if type(conn) == "thread" then
                    pcall(function() task.cancel(conn) end)
                elseif conn and conn.Disconnect then
                    pcall(function() conn:Disconnect() end)
                end
                state.connections[connName] = nil
            end
        end

        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            pcall(function()
                humanoid.MaxHealth = 100
                humanoid.Health = 100
            end)
        end

        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                pcall(function()
                    if part:GetAttribute("OriginalMassless") ~= nil then
                        part.Massless = part:GetAttribute("OriginalMassless")
                        part.CanCollide = part:GetAttribute("OriginalCanCollide")
                        part:SetAttribute("OriginalMassless", nil)
                        part:SetAttribute("OriginalCanCollide", nil)
                        part:SetAttribute("TankCollisionSet", nil)
                    end
                    part.CollisionGroup = "Default"
                end)
            end
        end

        local ff = character:FindFirstChild("TankFF")
        if ff then pcall(function() ff:Destroy() end) end
    end

    -- Reach (visual only)
    if state.reachEnabled then
        for _, tool in ipairs(character:GetChildren()) do
            if tool:IsA("Tool") then
                local handle = tool:FindFirstChild("Handle")
                if handle and not handle:FindFirstChild("ReachHitbox") then
                    local hitbox = Instance.new("Part")
                    hitbox.Name = "ReachHitbox"
                    hitbox.Size = Vector3.new(state.reachDistance, state.reachDistance, state.reachDistance)
                    hitbox.CFrame = handle.CFrame
                    hitbox.Transparency = state.visualizeHitbox and 0.7 or 1
                    hitbox.Material = Enum.Material.ForceField
                    hitbox.Color = Color3.fromRGB(255, 255, 255)
                    hitbox.CanCollide = false
                    hitbox.Massless = true
                    hitbox.Anchored = false  -- no physics influence on character
                    hitbox.Parent = handle

                    local weld = Instance.new("WeldConstraint")
                    weld.Part0 = handle
                    weld.Part1 = hitbox
                    weld.Parent = hitbox

                    table.insert(state.hitboxParts, hitbox)

                    -- purely visual: NO .Touched damage handlers here
                end
            end
        end

        for _, hitbox in ipairs(state.hitboxParts) do
            if hitbox and hitbox.Parent then
                hitbox.Size = Vector3.new(state.reachDistance, state.reachDistance, state.reachDistance)
                hitbox.Transparency = state.visualizeHitbox and 0.7 or 1
            end
        end
    else
        for _, hitbox in ipairs(state.hitboxParts) do
            if hitbox and hitbox.Parent then
                hitbox:Destroy()
            end
        end
        state.hitboxParts = {}
    end

    if not state.reachEnabled and state.visualizeHitbox then
        state.visualizeHitbox = false
    end

    if state.visualizeHitbox then
        for _, hitbox in ipairs(state.hitboxParts) do
            if hitbox and hitbox.Parent then
                hitbox.Transparency = 0.7
            end
        end
    else
        for _, hitbox in ipairs(state.hitboxParts) do
            if hitbox and hitbox.Parent then
                hitbox.Transparency = 1
            end
        end
    end
end

updateFeatures()

player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    state.hitboxParts = {}

    local humanoid = character:WaitForChild("Humanoid")
    state.originalHealth = humanoid.Health

    task.wait(0.1)
    updateFeatures()
end)

character.ChildAdded:Connect(function(child)
    if child:IsA("Tool") then
        task.wait(0.1)
        updateFeatures()
    end
end)

character.ChildRemoved:Connect(function(child)
    if child:IsA("Tool") then
        for i = #state.hitboxParts, 1, -1 do
            local hitbox = state.hitboxParts[i]
            if hitbox and not hitbox.Parent then
                table.remove(state.hitboxParts, i)
            end
        end
    end
end)

local function cleanup()
    for _, conn in pairs(state.connections) do
        if conn and conn.Disconnect then
            conn:Disconnect()
        end
    end
    for _, hitbox in ipairs(state.hitboxParts) do
        if hitbox and hitbox.Parent then
            hitbox:Destroy()
        end
    end
    if screenGui then
        screenGui:Destroy()
    end
end

StarterGui:SetCore("SendNotification", {
    Title = "KOAS ZONE",
    Text = "Loaded! Press Right Shift to toggle.",
    Duration = 5,
})

print("━━━━━━━━━━━━━━━━━━━━━━━━━")
print("   KOAS ZONE LOADED")
print("━━━━━━━━━━━━━━━━━━━━━━━━━")
print("Press Right Shift to toggle UI")
print("━━━━━━━━━━━━━━━━━━━━━━━━━")
