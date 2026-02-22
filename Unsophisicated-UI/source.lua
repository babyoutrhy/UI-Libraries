local Unsophisicated = {}

-- Services
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local TextService = game:GetService("TextService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

-- Utility functions
local function tween(object, goal, duration, easingStyle, easingDirection)
    duration = duration or 0.3
    easingStyle = easingStyle or Enum.EasingStyle.Exponential
    easingDirection = easingDirection or Enum.EasingDirection.Out
    local t = TweenService:Create(object, TweenInfo.new(duration, easingStyle, easingDirection), goal)
    t:Play()
    return t
end

local function CreateShadow(parent, sizeOffset, transparency)
    local shadow = Instance.new("Frame")
    shadow.Name = "Shadow"
    shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    shadow.BackgroundTransparency = transparency or 0.7
    shadow.Size = UDim2.new(1, sizeOffset, 1, sizeOffset)
    shadow.Position = UDim2.new(0, -sizeOffset/2, 0, -sizeOffset/2)
    shadow.ZIndex = -1
    shadow.Parent = parent
    local corner = Instance.new("UICorner")
    local parentCorner = parent:FindFirstChildOfClass("UICorner")
    corner.CornerRadius = parentCorner and parentCorner.CornerRadius or UDim.new(0, 8)
    corner.Parent = shadow
    return shadow
end

-- Cleanup old GUI
if CoreGui:FindFirstChild("UnsophisicatedUI_Modern") then
    CoreGui:FindFirstChild("UnsophisicatedUI_Modern"):Destroy()
end

-- Main GUI holder
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UnsophisicatedUI_Modern"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

-- Notifications container
local Notifications = Instance.new("Frame")
Notifications.Name = "Notifications"
Notifications.BackgroundTransparency = 1
Notifications.Size = UDim2.new(0, 320, 0, 0)
Notifications.Position = UDim2.new(1, -330, 0, 10)
Notifications.Parent = ScreenGui

local NotificationLayout = Instance.new("UIListLayout")
NotificationLayout.Parent = Notifications
NotificationLayout.SortOrder = Enum.SortOrder.LayoutOrder
NotificationLayout.Padding = UDim.new(0, 8)
NotificationLayout.VerticalAlignment = Enum.VerticalAlignment.Top

-- Notification function
function Unsophisicated:Notify(config)
    config = config or {}
    local title = config.Title or "Notification"
    local content = config.Content or ""
    local duration = config.Duration or 4
    local icon = config.Icon or "info" -- not used for now

    local notif = Instance.new("Frame")
    notif.Name = "Notification"
    notif.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    notif.BackgroundTransparency = 0.15
    notif.BorderSizePixel = 0
    notif.Size = UDim2.new(1, 0, 0, 0)
    notif.Parent = Notifications

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = notif

    CreateShadow(notif, 8, 0.7)

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.BackgroundTransparency = 1
    titleLabel.Size = UDim2.new(1, -20, 0, 20)
    titleLabel.Position = UDim2.new(0, 10, 0, 8)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 14
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = notif

    local contentLabel = Instance.new("TextLabel")
    contentLabel.Name = "Content"
    contentLabel.BackgroundTransparency = 1
    contentLabel.Size = UDim2.new(1, -20, 0, 0)
    contentLabel.Position = UDim2.new(0, 10, 0, 28)
    contentLabel.Font = Enum.Font.Gotham
    contentLabel.Text = content
    contentLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
    contentLabel.TextSize = 12
    contentLabel.TextWrapped = true
    contentLabel.TextXAlignment = Enum.TextXAlignment.Left
    contentLabel.Parent = notif

    local contentHeight = contentLabel.TextBounds.Y
    contentLabel.Size = UDim2.new(1, -20, 0, contentHeight)
    notif.Size = UDim2.new(1, 0, 0, contentHeight + 40)

    notif.Position = UDim2.new(0, 0, 0, -notif.AbsoluteSize.Y)
    tween(notif, {Position = UDim2.new(0, 0, 0, 0)}, 0.4, Enum.EasingStyle.Back)

    task.wait(duration)

    tween(notif, {Position = UDim2.new(0, 0, 0, -notif.AbsoluteSize.Y)}, 0.4, Enum.EasingStyle.Back, function()
        notif:Destroy()
    end)
end

-- Main window creation
function Unsophisicated:CreateWindow(title)
    title = title or "Unsophisicated UI"

    -- Main window frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.new(0.5, -300, 0.5, -250)
    MainFrame.Size = UDim2.new(0, 600, 0, 500)
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 12)
    MainCorner.Parent = MainFrame

    CreateShadow(MainFrame, 12, 0.8)

    -- Title bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
    TitleBar.BorderSizePixel = 0
    TitleBar.Size = UDim2.new(1, 0, 0, 45)
    TitleBar.Parent = MainFrame

    local TitleBarCorner = Instance.new("UICorner")
    TitleBarCorner.CornerRadius = UDim.new(0, 12)
    TitleBarCorner.Parent = TitleBar
    -- Mask bottom corners
    local bottomMask = Instance.new("Frame")
    bottomMask.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
    bottomMask.BorderSizePixel = 0
    bottomMask.Size = UDim2.new(1, 0, 0, 10)
    bottomMask.Position = UDim2.new(0, 0, 1, -10)
    bottomMask.Parent = TitleBar
    bottomMask.ZIndex = 2

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "Title"
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position = UDim2.new(0, 15, 0, 0)
    TitleLabel.Size = UDim2.new(0, 200, 1, 0)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Text = title
    TitleLabel.TextColor3 = Color3.fromRGB(220, 220, 240)
    TitleLabel.TextSize = 16
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TitleBar

local Controls = Instance.new("Frame")
Controls.Name = "Controls"
Controls.BackgroundTransparency = 1
Controls.Size = UDim2.new(0, 80, 1, 0)  -- slightly narrower
Controls.Position = UDim2.new(1, -85, 0, 0)
Controls.Parent = TitleBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "Close"
CloseBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
CloseBtn.Size = UDim2.new(0, 26, 0, 26)  -- smaller
CloseBtn.Position = UDim2.new(0, 48, 0.5, -13)  -- centered
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "X"  -- simple X
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 14
CloseBtn.Parent = Controls

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(1, 0)
CloseCorner.Parent = CloseBtn

local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Name = "Minimize"
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
MinimizeBtn.Size = UDim2.new(0, 26, 0, 26)
MinimizeBtn.Position = UDim2.new(0, 12, 0.5, -13)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.Text = "-"  -- simple hyphen
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.TextSize = 18
MinimizeBtn.Parent = Controls

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(1, 0)
MinCorner.Parent = MinimizeBtn

    -- Tab bar
    local TabBar = Instance.new("Frame")
    TabBar.Name = "TabBar"
    TabBar.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
    TabBar.BorderSizePixel = 0
    TabBar.Size = UDim2.new(1, 0, 0, 40)
    TabBar.Position = UDim2.new(0, 0, 0, 45)
    TabBar.Parent = MainFrame

    local TabBarLayout = Instance.new("UIListLayout")
    TabBarLayout.Parent = TabBar
    TabBarLayout.FillDirection = Enum.FillDirection.Horizontal
    TabBarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabBarLayout.Padding = UDim.new(0, 5)
    TabBarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    TabBarLayout.VerticalAlignment = Enum.VerticalAlignment.Center

    local TabPadding = Instance.new("UIPadding")
    TabPadding.Parent = TabBar
    TabPadding.PaddingLeft = UDim.new(0, 15)

    -- Content area
    local ContentArea = Instance.new("Frame")
    ContentArea.Name = "ContentArea"
    ContentArea.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
    ContentArea.BorderSizePixel = 0
    ContentArea.Position = UDim2.new(0, 0, 0, 85)
    ContentArea.Size = UDim2.new(1, 0, 1, -85)
    ContentArea.Parent = MainFrame

    local ContentCorner = Instance.new("UICorner")
    ContentCorner.CornerRadius = UDim.new(0, 12)
    ContentCorner.Parent = ContentArea

    local PageHolder = Instance.new("Frame")
    PageHolder.Name = "PageHolder"
    PageHolder.BackgroundTransparency = 1
    PageHolder.Size = UDim2.new(1, -20, 1, -20)
    PageHolder.Position = UDim2.new(0, 10, 0, 10)
    PageHolder.Parent = ContentArea

    -- Dragging
    local dragging = false
    local dragStart, startPos

    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)

    -- Window controls functionality
    CloseBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    local minimized = false
    local originalSize = MainFrame.Size
    MinimizeBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            tween(MainFrame, {Size = UDim2.new(0, 600, 0, 45)})
            ContentArea.Visible = false
            TabBar.Visible = false
        else
            tween(MainFrame, {Size = originalSize})
            ContentArea.Visible = true
            TabBar.Visible = true
        end
    end)

    -- Create element helper
    local function CreateElement(name, height)
        local element = Instance.new("Frame")
        element.Name = name
        element.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
        element.BorderSizePixel = 0
        element.Size = UDim2.new(1, -20, 0, height)
        element.Position = UDim2.new(0, 10, 0, 0)

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = element

        return element
    end

    -- Window object
    local Window = {}
    local currentTab = nil
    local tabs = {}

function Window:AddTab(tabName, iconAssetId)
    -- Tab button
    local TabButton = Instance.new("TextButton")
    TabButton.Name = tabName
    TabButton.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
    TabButton.AutoButtonColor = false
    local textWidth = TextService:GetTextSize(tabName, 14, Enum.Font.Gotham, Vector2.new(0, 0)).X
    TabButton.Size = UDim2.new(0, textWidth + (iconAssetId and 40 or 20), 0, 30)
    TabButton.Font = Enum.Font.Gotham
    TabButton.Text = tabName
    TabButton.TextColor3 = Color3.fromRGB(180, 180, 200)
    TabButton.TextSize = 14
    TabButton.Parent = TabBar

    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 6)
    ButtonCorner.Parent = TabButton

    if iconAssetId then
        local icon = Instance.new("ImageLabel")
        icon.BackgroundTransparency = 1
        icon.Size = UDim2.new(0, 16, 0, 16)
        icon.Position = UDim2.new(0, 5, 0.5, -8)
        icon.Image = "rbxassetid://" .. tostring(iconAssetId)
        icon.ImageColor3 = Color3.fromRGB(180, 180, 200)
        icon.Parent = TabButton
        TabButton.TextXAlignment = Enum.TextXAlignment.Center
        TabButton.Text = "   " .. tabName
    end

    -- Tab content (scrolling frame)
    local TabContent = Instance.new("ScrollingFrame")
    TabContent.Name = tabName
    TabContent.BackgroundTransparency = 1
    TabContent.Size = UDim2.new(1, 0, 1, 0)
    TabContent.Visible = false
    TabContent.ScrollBarThickness = 4
    TabContent.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 90)
    TabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
    TabContent.Parent = PageHolder

    local ContentLayout = Instance.new("UIListLayout")
    ContentLayout.Parent = TabContent
    ContentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ContentLayout.Padding = UDim.new(0, 8)

    if not currentTab then
        currentTab = TabContent
        TabContent.Visible = true
        TabButton.BackgroundColor3 = Color3.fromRGB(100, 80, 200)
        TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        if iconAssetId then
            TabButton.ImageLabel.ImageColor3 = Color3.fromRGB(255, 255, 255)
        end
    end

    TabButton.MouseButton1Click:Connect(function()
        if currentTab == TabContent then return end
        currentTab.Visible = false
        for _, btn in ipairs(TabBar:GetChildren()) do
            if btn:IsA("TextButton") then
                btn.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
                btn.TextColor3 = Color3.fromRGB(180, 180, 200)
                if btn:FindFirstChild("ImageLabel") then
                    btn.ImageLabel.ImageColor3 = Color3.fromRGB(180, 180, 200)
                end
            end
        end
        TabContent.Visible = true
        currentTab = TabContent
        TabButton.BackgroundColor3 = Color3.fromRGB(100, 80, 200)
        TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        if iconAssetId then
            TabButton.ImageLabel.ImageColor3 = Color3.fromRGB(255, 255, 255)
        end
    end)

    local function nextOrder()
        return #TabContent:GetChildren()
    end

    -- Tab methods
    local Tab = {
        Content = TabContent,  -- Expose the scrolling frame for direct manipulation
    }

    function Tab:AddSection(name)
        local header = Instance.new("TextLabel")
        header.Name = "SectionHeader"
        header.BackgroundTransparency = 1
        header.Size = UDim2.new(1, -20, 0, 20)
        header.Font = Enum.Font.GothamBold
        header.Text = name
        header.TextColor3 = Color3.fromRGB(150, 150, 170)
        header.TextSize = 12
        header.TextXAlignment = Enum.TextXAlignment.Left
        header.LayoutOrder = nextOrder()
        header.Parent = TabContent
    end

    function Tab:AddDivider()
        local divider = Instance.new("Frame")
        divider.Name = "Divider"
        divider.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
        divider.BorderSizePixel = 0
        divider.Size = UDim2.new(1, -20, 0, 1)
        divider.LayoutOrder = nextOrder()
        divider.Parent = TabContent
    end

    function Tab:AddButton(config)
        local height = config.Description and 50 or 40
        local element = CreateElement("Button", height)
        element.LayoutOrder = nextOrder()
        element.Parent = TabContent

        local title = Instance.new("TextLabel")
        title.Name = "Title"
        title.BackgroundTransparency = 1
        title.Position = UDim2.new(0, 15, 0, config.Description and 6 or 10)
        title.Size = UDim2.new(0, 200, 0, 20)
        title.Font = Enum.Font.GothamBold
        title.Text = config.Text
        title.TextColor3 = Color3.fromRGB(220, 220, 240)
        title.TextSize = 14
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.Parent = element

        if config.Description then
            local desc = Instance.new("TextLabel")
            desc.Name = "Description"
            desc.BackgroundTransparency = 1
            desc.Position = UDim2.new(0, 15, 0, 26)
            desc.Size = UDim2.new(0, 200, 0, 18)
            desc.Font = Enum.Font.Gotham
            desc.Text = config.Description
            desc.TextColor3 = Color3.fromRGB(150, 150, 170)
            desc.TextSize = 12
            desc.TextXAlignment = Enum.TextXAlignment.Left
            desc.Parent = element
        end

        local button = Instance.new("TextButton")
        button.Name = "Button"
        button.BackgroundColor3 = Color3.fromRGB(100, 80, 200)
        button.Size = UDim2.new(0, 100, 0, 28)
        button.Position = UDim2.new(1, -110, 0.5, -14)
        button.Font = Enum.Font.GothamBold
        button.Text = "Click"
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.TextSize = 14
        button.Parent = element

        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(0, 6)
        buttonCorner.Parent = button

        button.MouseEnter:Connect(function()
            tween(button, {BackgroundColor3 = Color3.fromRGB(120, 100, 220)})
        end)
        button.MouseLeave:Connect(function()
            tween(button, {BackgroundColor3 = Color3.fromRGB(100, 80, 200)})
        end)
        button.MouseButton1Click:Connect(config.Callback or function() end)
    end

    function Tab:AddToggle(config)
        local height = config.Description and 50 or 40
        local element = CreateElement("Toggle", height)
        element.LayoutOrder = nextOrder()
        element.Parent = TabContent

        local title = Instance.new("TextLabel")
        title.Name = "Title"
        title.BackgroundTransparency = 1
        title.Position = UDim2.new(0, 15, 0, config.Description and 6 or 10)
        title.Size = UDim2.new(0, 200, 0, 20)
        title.Font = Enum.Font.GothamBold
        title.Text = config.Text
        title.TextColor3 = Color3.fromRGB(220, 220, 240)
        title.TextSize = 14
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.Parent = element

        if config.Description then
            local desc = Instance.new("TextLabel")
            desc.Name = "Description"
            desc.BackgroundTransparency = 1
            desc.Position = UDim2.new(0, 15, 0, 26)
            desc.Size = UDim2.new(0, 200, 0, 18)
            desc.Font = Enum.Font.Gotham
            desc.Text = config.Description
            desc.TextColor3 = Color3.fromRGB(150, 150, 170)
            desc.TextSize = 12
            desc.TextXAlignment = Enum.TextXAlignment.Left
            desc.Parent = element
        end

        local toggleFrame = Instance.new("Frame")
        toggleFrame.Name = "Toggle"
        toggleFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
        toggleFrame.Size = UDim2.new(0, 50, 0, 24)
        toggleFrame.Position = UDim2.new(1, -60, 0.5, -12)
        toggleFrame.Parent = element

        local toggleCorner = Instance.new("UICorner")
        toggleCorner.CornerRadius = UDim.new(1, 0)
        toggleCorner.Parent = toggleFrame

        local indicator = Instance.new("Frame")
        indicator.Name = "Indicator"
        indicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        indicator.Size = UDim2.new(0, 20, 0, 20)
        indicator.Position = UDim2.new(0, 2, 0.5, -10)
        indicator.Parent = toggleFrame

        local indicatorCorner = Instance.new("UICorner")
        indicatorCorner.CornerRadius = UDim.new(1, 0)
        indicatorCorner.Parent = indicator

        local state = config.Default or false
        local function updateVisual()
            if state then
                tween(indicator, {Position = UDim2.new(1, -22, 0.5, -10)})
                tween(toggleFrame, {BackgroundColor3 = Color3.fromRGB(100, 80, 200)})
            else
                tween(indicator, {Position = UDim2.new(0, 2, 0.5, -10)})
                tween(toggleFrame, {BackgroundColor3 = Color3.fromRGB(60, 60, 70)})
            end
        end
        updateVisual()

        toggleFrame.InputBegan:Connect(function(input, processed)
            if processed then return end
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                state = not state
                updateVisual()
                if config.Callback then config.Callback(state) end
            end
        end)
    end

    function Tab:AddSlider(config)
        local element = CreateElement("Slider", 55)
        element.LayoutOrder = nextOrder()
        element.Parent = TabContent

        local title = Instance.new("TextLabel")
        title.Name = "Title"
        title.BackgroundTransparency = 1
        title.Position = UDim2.new(0, 15, 0, 8)
        title.Size = UDim2.new(0, 200, 0, 20)
        title.Font = Enum.Font.GothamBold
        title.Text = config.Text
        title.TextColor3 = Color3.fromRGB(220, 220, 240)
        title.TextSize = 14
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.Parent = element

        local valueDisplay = Instance.new("TextLabel")
        valueDisplay.Name = "Value"
        valueDisplay.BackgroundTransparency = 1
        valueDisplay.Position = UDim2.new(1, -70, 0, 8)
        valueDisplay.Size = UDim2.new(0, 60, 0, 20)
        valueDisplay.Font = Enum.Font.GothamBold
        valueDisplay.Text = tostring(config.Default or config.Min)
        valueDisplay.TextColor3 = Color3.fromRGB(180, 150, 255)
        valueDisplay.TextSize = 14
        valueDisplay.TextXAlignment = Enum.TextXAlignment.Right
        valueDisplay.Parent = element

        local track = Instance.new("Frame")
        track.Name = "Track"
        track.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
        track.Position = UDim2.new(0, 15, 0, 32)
        track.Size = UDim2.new(1, -30, 0, 6)
        track.Parent = element

        local trackCorner = Instance.new("UICorner")
        trackCorner.CornerRadius = UDim.new(1, 0)
        trackCorner.Parent = track

        local fill = Instance.new("Frame")
        fill.Name = "Fill"
        fill.BackgroundColor3 = Color3.fromRGB(100, 80, 200)
        fill.Size = UDim2.new(0, 0, 1, 0)
        fill.Parent = track

        local fillCorner = Instance.new("UICorner")
        fillCorner.CornerRadius = UDim.new(1, 0)
        fillCorner.Parent = fill

        local thumb = Instance.new("Frame")
        thumb.Name = "Thumb"
        thumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        thumb.Size = UDim2.new(0, 16, 0, 16)
        thumb.Position = UDim2.new(0, -8, 0.5, -8)
        thumb.Parent = track

        local thumbCorner = Instance.new("UICorner")
        thumbCorner.CornerRadius = UDim.new(1, 0)
        thumbCorner.Parent = thumb

        local min = config.Min or 0
        local max = config.Max or 100
        local step = config.Step or 1
        local value = config.Default or min
        local dragging = false
        local dragConnection

        local function updateValueFromPos(inputPos)
            local trackSize = track.AbsoluteSize.X
            if trackSize == 0 then return end
            local rel = math.clamp(inputPos, 0, trackSize)
            local range = max - min
            local raw = min + (rel / trackSize) * range
            value = math.floor((raw - min) / step + 0.5) * step + min
            value = math.clamp(value, min, max)

            local fillWidth = (value - min) / range * trackSize
            fill.Size = UDim2.new(0, fillWidth, 1, 0)
            thumb.Position = UDim2.new(0, fillWidth - 8, 0.5, -8)
            valueDisplay.Text = tostring(value)

            if config.Callback then config.Callback(value) end
        end

        track.InputBegan:Connect(function(input, processed)
            if processed then return end
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                updateValueFromPos(input.Position.X - track.AbsolutePosition.X)

                dragConnection = RunService.RenderStepped:Connect(function()
                    if not dragging then return end
                    local mousePos = UserInputService:GetMouseLocation()
                    updateValueFromPos(mousePos.X - track.AbsolutePosition.X)
                end)

                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                        if dragConnection then
                            dragConnection:Disconnect()
                            dragConnection = nil
                        end
                    end
                end)
            end
        end)

        -- initial value
        local initFill = ((value - min) / (max - min)) * track.AbsoluteSize.X
        fill.Size = UDim2.new(0, initFill, 1, 0)
        thumb.Position = UDim2.new(0, initFill - 8, 0.5, -8)
    end

    function Tab:AddLabel(config)
        local style = config.Style or 1
        local color = style == 1 and Color3.fromRGB(200, 200, 220) or (style == 2 and Color3.fromRGB(100, 150, 255) or Color3.fromRGB(255, 150, 150))
        local element = CreateElement("Label", 20)
        element.LayoutOrder = nextOrder()
        element.Parent = TabContent

        local label = Instance.new("TextLabel")
        label.Name = "Text"
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(1, -20, 1, 0)
        label.Position = UDim2.new(0, 10, 0, 0)
        label.Font = Enum.Font.Gotham
        label.Text = config.Text
        label.TextColor3 = color
        label.TextSize = 12
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = element

        return label
    end

    function Tab:AddTextbox(config)
        local element = CreateElement("Textbox", 40)
        element.LayoutOrder = nextOrder()
        element.Parent = TabContent

        local title = Instance.new("TextLabel")
        title.Name = "Title"
        title.BackgroundTransparency = 1
        title.Position = UDim2.new(0, 15, 0, 0)
        title.Size = UDim2.new(0, 150, 1, 0)
        title.Font = Enum.Font.GothamBold
        title.Text = config.Text
        title.TextColor3 = Color3.fromRGB(220, 220, 240)
        title.TextSize = 14
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.TextYAlignment = Enum.TextYAlignment.Center
        title.Parent = element

        local input = Instance.new("TextBox")
        input.Name = "Input"
        input.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
        input.Position = UDim2.new(1, -160, 0.5, -15)
        input.Size = UDim2.new(0, 150, 0, 30)
        input.Font = Enum.Font.Gotham
        input.PlaceholderText = config.Placeholder or ""
        input.PlaceholderColor3 = Color3.fromRGB(120, 120, 140)
        input.Text = config.Default or ""
        input.TextColor3 = Color3.fromRGB(255, 255, 255)
        input.TextSize = 14
        input.TextXAlignment = Enum.TextXAlignment.Center
        input.TextTruncate = Enum.TextTruncate.AtEnd
        input.ClearTextOnFocus = false
        input.Parent = element

        local inputCorner = Instance.new("UICorner")
        inputCorner.CornerRadius = UDim.new(0, 6)
        inputCorner.Parent = input

        input.Focused:Connect(function()
            tween(input, {BackgroundColor3 = Color3.fromRGB(40, 40, 50)})
        end)

        input.FocusLost:Connect(function(enterPressed)
            tween(input, {BackgroundColor3 = Color3.fromRGB(30, 30, 38)})
            if enterPressed and config.Callback then
                config.Callback(input.Text)
            end
        end)
    end

    function Tab:AddDropdown(config)
        local element = CreateElement("Dropdown", 40)
        element.ClipsDescendants = false
        element.LayoutOrder = nextOrder()
        element.Parent = TabContent

        local title = Instance.new("TextLabel")
        title.Name = "Title"
        title.BackgroundTransparency = 1
        title.Position = UDim2.new(0, 15, 0, 0)
        title.Size = UDim2.new(0, 150, 1, 0)
        title.Font = Enum.Font.GothamBold
        title.Text = config.Text
        title.TextColor3 = Color3.fromRGB(220, 220, 240)
        title.TextSize = 14
        title.TextYAlignment = Enum.TextYAlignment.Center
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.TextTruncate = Enum.TextTruncate.AtEnd
        title.Parent = element

        local selectBtn = Instance.new("TextButton")
        selectBtn.Name = "SelectButton"
        selectBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
        selectBtn.Position = UDim2.new(1, -160, 0.5, -15)
        selectBtn.Size = UDim2.new(0, 150, 0, 30)
        selectBtn.Font = Enum.Font.Gotham
        selectBtn.Text = "Select"
        selectBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        selectBtn.TextSize = 14
        selectBtn.TextTruncate = Enum.TextTruncate.AtEnd
        selectBtn.Parent = element

        local selectCorner = Instance.new("UICorner")
        selectCorner.CornerRadius = UDim.new(0, 6)
        selectCorner.Parent = selectBtn

        local dropdownContainer = Instance.new("Frame")
        dropdownContainer.Name = "DropdownContainer"
        dropdownContainer.BackgroundTransparency = 1
        dropdownContainer.Size = UDim2.new(0, 150, 0, 0)
        dropdownContainer.Visible = false
        dropdownContainer.ZIndex = 10
        dropdownContainer.Parent = ScreenGui

        local dropdownList = Instance.new("ScrollingFrame")
        dropdownList.Name = "DropdownList"
        dropdownList.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
        dropdownList.BorderSizePixel = 0
        dropdownList.Size = UDim2.new(1, 0, 1, 0)
        dropdownList.ScrollBarThickness = 4
        dropdownList.CanvasSize = UDim2.new(0, 0, 0, 0)
        dropdownList.ZIndex = 11
        dropdownList.Parent = dropdownContainer

        local listCorner = Instance.new("UICorner")
        listCorner.CornerRadius = UDim.new(0, 6)
        listCorner.Parent = dropdownList

        local listLayout = Instance.new("UIListLayout")
        listLayout.Parent = dropdownList
        listLayout.SortOrder = Enum.SortOrder.LayoutOrder
        listLayout.Padding = UDim.new(0, 2)

        local isOpen = false
        local isMultiple = config.MultipleOptions or false
        local selected = {}
        local posConnection

        -- Handle default selection
        if isMultiple then
            if type(config.Default) == "table" then
                for _, opt in ipairs(config.Default) do selected[opt] = true end
            end
            local count = 0 for _ in pairs(selected) do count = count + 1 end
            if count > 0 then selectBtn.Text = count .. " selected" end
        else
            if type(config.Default) == "string" then
                selectBtn.Text = config.Default
            end
        end

        local function updateListSize()
            local h = 0
            for _, child in ipairs(dropdownList:GetChildren()) do
                if child:IsA("TextButton") then
                    h = h + child.AbsoluteSize.Y + listLayout.Padding.Offset
                end
            end
            dropdownList.CanvasSize = UDim2.new(0, 0, 0, h)
            dropdownContainer.Size = UDim2.new(0, 150, 0, math.min(150, h))
        end

        local function updatePos()
            local btnPos = selectBtn.AbsolutePosition
            dropdownContainer.Position = UDim2.new(0, btnPos.X, 0, btnPos.Y + selectBtn.AbsoluteSize.Y + 2)
        end

        local function toggle()
            if isOpen then
                dropdownContainer.Visible = false
                isOpen = false
                if posConnection then posConnection:Disconnect() end
            else
                updatePos()
                dropdownContainer.Visible = true
                isOpen = true
                posConnection = RunService.Heartbeat:Connect(updatePos)
            end
        end

        for _, opt in ipairs(config.Options) do
            local optBtn = Instance.new("TextButton")
            optBtn.Name = opt
            optBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
            optBtn.Size = UDim2.new(1, -4, 0, 28)
            optBtn.Position = UDim2.new(0, 2, 0, 0)
            optBtn.Font = Enum.Font.Gotham
            optBtn.Text = opt
            optBtn.TextColor3 = Color3.fromRGB(220, 220, 240)
            optBtn.TextSize = 14
            optBtn.ZIndex = 12
            optBtn.Parent = dropdownList

            local optCorner = Instance.new("UICorner")
            optCorner.CornerRadius = UDim.new(0, 4)
            optCorner.Parent = optBtn

            if isMultiple then
                local check = Instance.new("Frame")
                check.Name = "Check"
                check.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
                check.Size = UDim2.new(0, 16, 0, 16)
                check.Position = UDim2.new(0, 6, 0.5, -8)
                check.ZIndex = 13
                check.Parent = optBtn

                local checkCorner = Instance.new("UICorner")
                checkCorner.CornerRadius = UDim.new(0, 3)
                checkCorner.Parent = check

                local checkMark = Instance.new("TextLabel")
                checkMark.Name = "CheckMark"
                checkMark.BackgroundTransparency = 1
                checkMark.Size = UDim2.new(1, 0, 1, 0)
                checkMark.Font = Enum.Font.GothamBold
                checkMark.Text = "✓"
                checkMark.TextColor3 = Color3.fromRGB(255, 255, 255)
                checkMark.TextSize = 12
                checkMark.Visible = selected[opt] or false
                checkMark.ZIndex = 14
                checkMark.Parent = check

                if selected[opt] then
                    check.BackgroundColor3 = Color3.fromRGB(100, 80, 200)
                end

                optBtn.TextXAlignment = Enum.TextXAlignment.Center
                optBtn.Text = "   " .. opt

                optBtn.MouseButton1Click:Connect(function()
                    selected[opt] = not selected[opt]
                    if selected[opt] then
                        check.BackgroundColor3 = Color3.fromRGB(100, 80, 200)
                        check.CheckMark.Visible = true
                    else
                        check.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
                        check.CheckMark.Visible = false
                    end
                    local count = 0 for _ in pairs(selected) do count = count + 1 end
                    selectBtn.Text = count > 0 and (count .. " selected") or "Select"
                    if config.Callback then
                        local list = {}
                        for opt, sel in pairs(selected) do if sel then table.insert(list, opt) end end
                        config.Callback(list)
                    end
                end)
            else
                optBtn.MouseButton1Click:Connect(function()
                    selectBtn.Text = opt
                    toggle()
                    if config.Callback then config.Callback(opt) end
                end)
            end
        end

        listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateListSize)
        updateListSize()
        selectBtn.MouseButton1Click:Connect(toggle)

        element.Destroying:Connect(function()
            if posConnection then posConnection:Disconnect() end
            dropdownContainer:Destroy()
        end)
    end

    function Tab:AddParagraph(config)
        local element = CreateElement("Paragraph", 60)
        element.LayoutOrder = nextOrder()
        element.Parent = TabContent

        local title = Instance.new("TextLabel")
        title.Name = "Title"
        title.BackgroundTransparency = 1
        title.Size = UDim2.new(1, -20, 0, 20)
        title.Position = UDim2.new(0, 10, 0, 6)
        title.Font = Enum.Font.GothamBold
        title.Text = config.Title or ""
        title.TextColor3 = Color3.fromRGB(220, 220, 240)
        title.TextSize = 14
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.Parent = element

        local content = Instance.new("TextLabel")
        content.Name = "Content"
        content.BackgroundTransparency = 1
        content.Size = UDim2.new(1, -20, 0, 0)
        content.Position = UDim2.new(0, 10, 0, 26)
        content.Font = Enum.Font.Gotham
        content.Text = config.Text or ""
        content.TextColor3 = Color3.fromRGB(160, 160, 180)
        content.TextSize = 12
        content.TextWrapped = true
        content.TextXAlignment = Enum.TextXAlignment.Left
        content.Parent = element

        local textHeight = content.TextBounds.Y
        content.Size = UDim2.new(1, -20, 0, textHeight)
        element.Size = UDim2.new(1, -20, 0, textHeight + 36)
    end

    function Tab:AddKeybind(config)
        local element = CreateElement("Keybind", 40)
        element.LayoutOrder = nextOrder()
        element.Parent = TabContent

        local title = Instance.new("TextLabel")
        title.Name = "Title"
        title.BackgroundTransparency = 1
        title.Position = UDim2.new(0, 15, 0, 0)
        title.Size = UDim2.new(0, 150, 1, 0)
        title.Font = Enum.Font.GothamBold
        title.Text = config.Text
        title.TextColor3 = Color3.fromRGB(220, 220, 240)
        title.TextSize = 14
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.TextYAlignment = Enum.TextYAlignment.Center
        title.Parent = element

        local bindFrame = Instance.new("Frame")
        bindFrame.Name = "BindFrame"
        bindFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
        bindFrame.Position = UDim2.new(1, -100, 0.5, -15)
        bindFrame.Size = UDim2.new(0, 90, 0, 30)
        bindFrame.Parent = element

        local bindCorner = Instance.new("UICorner")
        bindCorner.CornerRadius = UDim.new(0, 6)
        bindCorner.Parent = bindFrame

        local bindLabel = Instance.new("TextLabel")
        bindLabel.Name = "BindLabel"
        bindLabel.BackgroundTransparency = 1
        bindLabel.Size = UDim2.new(1, 0, 1, 0)
        bindLabel.Font = Enum.Font.Gotham
        bindLabel.Text = config.Default or "None"
        bindLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        bindLabel.TextSize = 14
        bindLabel.Parent = bindFrame

        local listening = false
        bindFrame.InputBegan:Connect(function(input, processed)
            if processed then return end
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                listening = true
                bindLabel.Text = "..."
            end
        end)

        UserInputService.InputBegan:Connect(function(input, processed)
            if not listening or processed then return end
            if input.UserInputType == Enum.UserInputType.Keyboard then
                local key = input.KeyCode
                if key ~= Enum.KeyCode.Unknown then
                    bindLabel.Text = key.Name
                    listening = false
                    if config.Callback then config.Callback(key) end
                end
            end
        end)
    end

    function Tab:AddColorPicker(config)
        local element = CreateElement("ColorPicker", 40)
        element.LayoutOrder = nextOrder()
        element.Parent = TabContent

        local title = Instance.new("TextLabel")
        title.Name = "Title"
        title.BackgroundTransparency = 1
        title.Position = UDim2.new(0, 15, 0, 0)
        title.Size = UDim2.new(0, 150, 1, 0)
        title.Font = Enum.Font.GothamBold
        title.Text = config.Text
        title.TextColor3 = Color3.fromRGB(220, 220, 240)
        title.TextSize = 14
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.TextYAlignment = Enum.TextYAlignment.Center
        title.Parent = element

        local display = Instance.new("Frame")
        display.Name = "Display"
        display.BackgroundColor3 = config.Default or Color3.fromRGB(255, 255, 255)
        display.Position = UDim2.new(1, -50, 0.5, -12)
        display.Size = UDim2.new(0, 40, 0, 24)
        display.Parent = element

        local displayCorner = Instance.new("UICorner")
        displayCorner.CornerRadius = UDim.new(0, 6)
        displayCorner.Parent = display

        local pickBtn = Instance.new("TextButton")
        pickBtn.Name = "PickButton"
        pickBtn.BackgroundTransparency = 1
        pickBtn.Size = UDim2.new(1, 0, 1, 0)
        pickBtn.Text = ""
        pickBtn.Parent = display

        local colors = {Color3.fromRGB(255,80,80), Color3.fromRGB(80,255,80), Color3.fromRGB(80,80,255), Color3.fromRGB(255,255,80), Color3.fromRGB(255,80,255), Color3.fromRGB(80,255,255)}
        local idx = 1
        for i, c in ipairs(colors) do
            if c == config.Default then idx = i break end
        end
        display.BackgroundColor3 = colors[idx]

        pickBtn.MouseButton1Click:Connect(function()
            idx = idx % #colors + 1
            local newColor = colors[idx]
            display.BackgroundColor3 = newColor
            if config.Callback then config.Callback(newColor) end
        end)
    end

    table.insert(tabs, Tab)
    return Tab
end

function Window:CreateHomeTab()
    local home = self:AddTab("Home")
    local content = home.Content  -- the ScrollingFrame

    -- Profile section
    local profileFrame = Instance.new("Frame")
    profileFrame.Name = "Profile"
    profileFrame.BackgroundTransparency = 1
    profileFrame.Size = UDim2.new(1, -20, 0, 60)
    profileFrame.LayoutOrder = 1
    profileFrame.Parent = content

    local profileImage = Instance.new("ImageLabel")
    profileImage.Name = "ProfileImage"
    profileImage.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
    profileImage.Size = UDim2.new(0, 50, 0, 50)
    profileImage.Position = UDim2.new(0, 0, 0.5, -25)
    profileImage.Parent = profileFrame
    local imgCorner = Instance.new("UICorner")
    imgCorner.CornerRadius = UDim.new(1, 0)
    imgCorner.Parent = profileImage

    -- Load profile picture asynchronously
    task.spawn(function()
        local userId = Players.LocalPlayer.UserId
        local success, content, isReady = pcall(function()
            return Players:GetUserThumbnailAsync(userId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
        end)
        if success and content then
            profileImage.Image = content
        else
            profileImage.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png" -- fallback
        end
    end)

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "Name"
    nameLabel.BackgroundTransparency = 1
    nameLabel.Size = UDim2.new(1, -60, 0, 25)
    nameLabel.Position = UDim2.new(0, 60, 0, 5)
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.Text = Players.LocalPlayer.DisplayName .. " @" .. Players.LocalPlayer.Name
    nameLabel.TextColor3 = Color3.fromRGB(220, 220, 240)
    nameLabel.TextSize = 16
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.Parent = profileFrame

    -- Join date calculation
    local player = Players.LocalPlayer
    local joinTime = DateTime.now().UnixTimestamp - (player.AccountAge * 86400)
    local date = DateTime.fromUnixTimestamp(joinTime)
    local joinDateStr = date:FormatLocalTime("MM/DD/YYYY", "en-us")  -- corrected format

    local joinLabel = Instance.new("TextLabel")
    joinLabel.Name = "JoinDate"
    joinLabel.BackgroundTransparency = 1
    joinLabel.Size = UDim2.new(1, -60, 0, 20)
    joinLabel.Position = UDim2.new(0, 60, 0, 30)
    joinLabel.Font = Enum.Font.Gotham
    joinLabel.Text = "Joined: " .. joinDateStr
    joinLabel.TextColor3 = Color3.fromRGB(150, 150, 170)
    joinLabel.TextSize = 12
    joinLabel.TextXAlignment = Enum.TextXAlignment.Left
    joinLabel.Parent = profileFrame

    home:AddDivider()
    home:AddSection("Server Info")

    local playerCount = home:AddLabel({ Text = "Players: " .. #Players:GetPlayers() .. "/" .. Players.MaxPlayers })
    local ping = home:AddLabel({ Text = "Ping: 0ms" })
    local uptime = home:AddLabel({ Text = "Uptime: 00:00:00" })

    spawn(function()
        while true do
            task.wait(1)
            playerCount.Text = "Players: " .. #Players:GetPlayers() .. "/" .. Players.MaxPlayers
            ping.Text = "Ping: " .. math.floor(Players.LocalPlayer:GetNetworkPing() * 1000) .. "ms"
            local t = os.time()
            uptime.Text = "Uptime: " .. os.date("%X")
        end
    end)

    return home
end

    return Window
end

return Unsophisicated