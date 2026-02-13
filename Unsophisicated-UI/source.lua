local Unsophisicated = {}

function Unsophisicated:CreateWindow(windowName, buttonText)
    buttonText = buttonText or windowName or "Menu"

    local UserInputService = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")
    local TextService = game:GetService("TextService")
    local RunService = game:GetService("RunService")

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "UnsophisicatedUI"
    ScreenGui.Parent = game.CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false

    -- === TOGGLE BUTTON (draggable, custom text) ===
    local buttonWidth = TextService:GetTextSize(buttonText, 20, Enum.Font.GothamBold, Vector2.new(0, 0)).X + 40
    local buttonHeight = 50 -- slightly taller for easier touch
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Name = "ToggleButton"
    ToggleButton.BackgroundColor3 = Color3.fromRGB(120, 80, 200)
    ToggleButton.Size = UDim2.new(0, buttonWidth, 0, buttonHeight)
    ToggleButton.Position = UDim2.new(0.5, -buttonWidth/2, 0, 15)
    ToggleButton.Font = Enum.Font.GothamBold
    ToggleButton.Text = buttonText
    ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleButton.TextSize = 20
    ToggleButton.ZIndex = 10
    ToggleButton.AutoButtonColor = false
    ToggleButton.Parent = ScreenGui

    -- Rounded pill shape
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(1, 0)
    ToggleCorner.Parent = ToggleButton

    -- Shadow effect
    local ToggleShadow = Instance.new("Frame")
    ToggleShadow.Name = "Shadow"
    ToggleShadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    ToggleShadow.BackgroundTransparency = 0.7
    ToggleShadow.Size = UDim2.new(1, 6, 1, 6)
    ToggleShadow.Position = UDim2.new(0, -3, 0, -3)
    ToggleShadow.ZIndex = 9
    ToggleShadow.Parent = ToggleButton
    local ShadowCorner = Instance.new("UICorner")
    ShadowCorner.CornerRadius = UDim.new(1, 0)
    ShadowCorner.Parent = ToggleShadow

    -- === DRAG HANDLER (reusable) ===
    local function makeDraggable(dragHandle, targetFrame)
        local dragging = false
        local dragStart, startPos

        local function updatePosition(input)
            if not dragging then return end
            local delta = input.Position - dragStart
            targetFrame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end

        dragHandle.InputBegan:Connect(function(input, processed)
            if processed then return end
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = targetFrame.Position

                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)

        UserInputService.InputChanged:Connect(function(input, processed)
            if not dragging or processed then return end
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                updatePosition(input)
            end
        end)
    end

    -- Make toggle button draggable
    makeDraggable(ToggleButton, ToggleButton)

    -- === MAIN WINDOW ===
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
    MainFrame.Size = UDim2.new(0, 400, 0, 450) -- slightly wider
    MainFrame.Visible = true
    MainFrame.Parent = ScreenGui

    -- Rounded corners
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 12)
    MainCorner.Parent = MainFrame

    -- Title Bar (only draggable part)
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    TitleBar.BorderSizePixel = 0
    TitleBar.Size = UDim2.new(1, 0, 0, 40)
    TitleBar.Parent = MainFrame

    local TitleBarCorner = Instance.new("UICorner")
    TitleBarCorner.CornerRadius = UDim.new(0, 12)
    TitleBarCorner.Parent = TitleBar

    -- Gradient on title bar
    local Gradient = Instance.new("UIGradient")
    Gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 60)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 30))
    })
    Gradient.Rotation = 90
    Gradient.Parent = TitleBar

    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.Size = UDim2.new(0, 200, 1, 0)
    Title.Font = Enum.Font.GothamBold
    Title.Text = windowName
    Title.TextColor3 = Color3.fromRGB(220, 220, 255)
    Title.TextSize = 16
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TitleBar

    -- Make title bar drag the main window
    makeDraggable(TitleBar, MainFrame)

    -- Tab Bar
    local TabBar = Instance.new("Frame")
    TabBar.Name = "TabBar"
    TabBar.BackgroundTransparency = 1
    TabBar.Position = UDim2.new(0, 10, 0, 50)
    TabBar.Size = UDim2.new(1, -20, 0, 40)
    TabBar.Parent = MainFrame

    local TabBarLayout = Instance.new("UIListLayout")
    TabBarLayout.Parent = TabBar
    TabBarLayout.FillDirection = Enum.FillDirection.Horizontal
    TabBarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabBarLayout.Padding = UDim.new(0, 8)

    -- Content Area
    local ContentArea = Instance.new("Frame")
    ContentArea.Name = "ContentArea"
    ContentArea.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    ContentArea.BorderSizePixel = 0
    ContentArea.Position = UDim2.new(0, 10, 0, 100)
    ContentArea.Size = UDim2.new(1, -20, 1, -110)
    ContentArea.Parent = MainFrame

    local ContentCorner = Instance.new("UICorner")
    ContentCorner.CornerRadius = UDim.new(0, 8)
    ContentCorner.Parent = ContentArea

    -- Toggle button click to show/hide main window
    ToggleButton.MouseButton1Click:Connect(function()
        MainFrame.Visible = not MainFrame.Visible
        -- Slight color change to indicate state
        local targetColor = MainFrame.Visible and Color3.fromRGB(120, 80, 200) or Color3.fromRGB(80, 60, 150)
        TweenService:Create(ToggleButton, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
    end)

    -- Helper to create element frames
    local function CreateElement(name, height)
        local Element = Instance.new("Frame")
        Element.Name = name
        Element.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        Element.BorderSizePixel = 0
        Element.Size = UDim2.new(1, -10, 0, height)

        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 6)
        Corner.Parent = Element

        return Element
    end

    local Window = {}
    local currentTab = nil

    function Window:AddTab(tabName)
        -- Tab button
        local TabButton = Instance.new("TextButton")
        TabButton.Name = tabName
        TabButton.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
        TabButton.AutoButtonColor = false
        local textWidth = TextService:GetTextSize(tabName, 14, Enum.Font.Gotham, Vector2.new(0, 0)).X
        TabButton.Size = UDim2.new(0, textWidth + 30, 0, 30)
        TabButton.Font = Enum.Font.Gotham
        TabButton.Text = tabName
        TabButton.TextColor3 = Color3.fromRGB(200, 200, 220)
        TabButton.TextSize = 14
        TabButton.Parent = TabBar

        local ButtonCorner = Instance.new("UICorner")
        ButtonCorner.CornerRadius = UDim.new(1, 0)
        ButtonCorner.Parent = TabButton

        -- Tab content (scrolling frame)
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = tabName
        TabContent.BackgroundTransparency = 1
        TabContent.Size = UDim2.new(1, -10, 1, -10)
        TabContent.Position = UDim2.new(0, 5, 0, 5)
        TabContent.Visible = false
        TabContent.ScrollBarThickness = 4
        TabContent.ScrollBarImageColor3 = Color3.fromRGB(120, 120, 160)
        TabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
        TabContent.Parent = ContentArea

        local TabContentLayout = Instance.new("UIListLayout")
        TabContentLayout.Parent = TabContent
        TabContentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        TabContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        TabContentLayout.Padding = UDim.new(0, 8)

        if not currentTab then
            currentTab = TabContent
            TabContent.Visible = true
            TabButton.BackgroundColor3 = Color3.fromRGB(120, 80, 200)
            TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        end

        TabButton.MouseButton1Click:Connect(function()
            if currentTab == TabContent then return end
            currentTab.Visible = false
            for _, btn in ipairs(TabBar:GetChildren()) do
                if btn:IsA("TextButton") then
                    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
                    btn.TextColor3 = Color3.fromRGB(200, 200, 220)
                end
            end
            TabContent.Visible = true
            currentTab = TabContent
            TabButton.BackgroundColor3 = Color3.fromRGB(120, 80, 200)
            TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        end)

        local Tab = {}

        function Tab:AddButton(config)
            local Element = CreateElement("Button", 40)
            Element.LayoutOrder = #TabContent:GetChildren()
            Element.Parent = TabContent

            local Button = Instance.new("TextButton")
            Button.Name = "Action"
            Button.BackgroundColor3 = Color3.fromRGB(100, 70, 180)
            Button.Size = UDim2.new(1, -20, 1, -10)
            Button.Position = UDim2.new(0, 10, 0, 5)
            Button.Font = Enum.Font.GothamBold
            Button.Text = config.Text
            Button.TextColor3 = Color3.fromRGB(255, 255, 255)
            Button.TextSize = 14
            Button.Parent = Element

            local ButtonCorner = Instance.new("UICorner")
            ButtonCorner.CornerRadius = UDim.new(0, 6)
            ButtonCorner.Parent = Button

            -- Hover effect
            Button.MouseEnter:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(130, 90, 210)}):Play()
            end)
            Button.MouseLeave:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(100, 70, 180)}):Play()
            end)

            Button.MouseButton1Click:Connect(config.Callback or function() end)
        end

        function Tab:AddToggle(config)
            local Element = CreateElement("Toggle", 40)
            Element.LayoutOrder = #TabContent:GetChildren()
            Element.Parent = TabContent

            local Label = Instance.new("TextLabel")
            Label.Name = "Title"
            Label.BackgroundTransparency = 1
            Label.Position = UDim2.new(0, 15, 0, 0)
            Label.Size = UDim2.new(0, 200, 1, 0)
            Label.Font = Enum.Font.Gotham
            Label.Text = config.Text
            Label.TextColor3 = Color3.fromRGB(220, 220, 240)
            Label.TextSize = 14
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = Element

            local ToggleContainer = Instance.new("Frame")
            ToggleContainer.Name = "Container"
            ToggleContainer.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
            ToggleContainer.Position = UDim2.new(1, -70, 0.5, -12)
            ToggleContainer.Size = UDim2.new(0, 50, 0, 24)
            ToggleContainer.Parent = Element

            local ContainerCorner = Instance.new("UICorner")
            ContainerCorner.CornerRadius = UDim.new(1, 0)
            ContainerCorner.Parent = ToggleContainer

            local Indicator = Instance.new("Frame")
            Indicator.Name = "Indicator"
            Indicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Indicator.BorderSizePixel = 0
            Indicator.Size = UDim2.new(0, 20, 0, 20)
            Indicator.Position = UDim2.new(0, 2, 0.5, -10)
            Indicator.Parent = ToggleContainer

            local IndicatorCorner = Instance.new("UICorner")
            IndicatorCorner.CornerRadius = UDim.new(1, 0)
            IndicatorCorner.Parent = Indicator

            local state = config.Default or false

            local function update()
                if state then
                    TweenService:Create(Indicator, TweenInfo.new(0.2), {Position = UDim2.new(1, -22, 0.5, -10)}):Play()
                    TweenService:Create(ToggleContainer, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(140, 100, 230)}):Play()
                else
                    TweenService:Create(Indicator, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -10)}):Play()
                    TweenService:Create(ToggleContainer, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 80)}):Play()
                end
            end
            update()

            ToggleContainer.InputBegan:Connect(function(input, processed)
                if processed then return end
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    state = not state
                    update()
                    if config.Callback then config.Callback(state) end
                end
            end)
        end

        function Tab:AddSlider(config)
            local Element = CreateElement("Slider", 55)
            Element.LayoutOrder = #TabContent:GetChildren()
            Element.Parent = TabContent

            local Label = Instance.new("TextLabel")
            Label.Name = "Title"
            Label.BackgroundTransparency = 1
            Label.Position = UDim2.new(0, 15, 0, 8)
            Label.Size = UDim2.new(0, 200, 0, 20)
            Label.Font = Enum.Font.Gotham
            Label.Text = config.Text
            Label.TextColor3 = Color3.fromRGB(220, 220, 240)
            Label.TextSize = 14
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = Element

            local ValueDisplay = Instance.new("TextLabel")
            ValueDisplay.Name = "Value"
            ValueDisplay.BackgroundTransparency = 1
            ValueDisplay.Position = UDim2.new(1, -70, 0, 8)
            ValueDisplay.Size = UDim2.new(0, 60, 0, 20)
            ValueDisplay.Font = Enum.Font.GothamBold
            ValueDisplay.Text = tostring(config.Default or config.Min)
            ValueDisplay.TextColor3 = Color3.fromRGB(180, 150, 255)
            ValueDisplay.TextSize = 14
            ValueDisplay.TextXAlignment = Enum.TextXAlignment.Right
            ValueDisplay.Parent = Element

            local Track = Instance.new("Frame")
            Track.Name = "Track"
            Track.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
            Track.Position = UDim2.new(0, 15, 0, 32)
            Track.Size = UDim2.new(1, -30, 0, 6)
            Track.Parent = Element

            local TrackCorner = Instance.new("UICorner")
            TrackCorner.CornerRadius = UDim.new(1, 0)
            TrackCorner.Parent = Track

            local Fill = Instance.new("Frame")
            Fill.Name = "Fill"
            Fill.BackgroundColor3 = Color3.fromRGB(140, 100, 230)
            Fill.Size = UDim2.new(0, 0, 1, 0)
            Fill.Parent = Track

            local FillCorner = Instance.new("UICorner")
            FillCorner.CornerRadius = UDim.new(1, 0)
            FillCorner.Parent = Fill

            local Thumb = Instance.new("Frame")
            Thumb.Name = "Thumb"
            Thumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Thumb.Size = UDim2.new(0, 16, 0, 16)
            Thumb.Position = UDim2.new(0, -8, 0.5, -8)
            Thumb.Parent = Track

            local ThumbCorner = Instance.new("UICorner")
            ThumbCorner.CornerRadius = UDim.new(1, 0)
            ThumbCorner.Parent = Thumb

            local min = config.Min or 0
            local max = config.Max or 100
            local step = config.Step or 1
            local value = config.Default or min
            local dragging = false

            local function updateValueFromPos(inputPos)
                local trackSize = Track.AbsoluteSize.X
                if trackSize == 0 then return end
                local rel = math.clamp(inputPos, 0, trackSize)
                local range = max - min
                local raw = min + (rel / trackSize) * range
                value = math.floor((raw - min) / step + 0.5) * step + min
                value = math.clamp(value, min, max)

                local fill = (value - min) / range * trackSize
                Fill.Size = UDim2.new(0, fill, 1, 0)
                Thumb.Position = UDim2.new(0, fill - 8, 0.5, -8)
                ValueDisplay.Text = tostring(value)

                if config.Callback then config.Callback(value) end
            end

            Track.InputBegan:Connect(function(input, processed)
                if processed then return end
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    updateValueFromPos(input.Position.X - Track.AbsolutePosition.X)

                    input.Changed:Connect(function()
                        if input.UserInputState == Enum.UserInputState.End then
                            dragging = false
                        end
                    end)
                end
            end)

            UserInputService.InputChanged:Connect(function(input, processed)
                if not dragging or processed then return end
                if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                    updateValueFromPos(input.Position.X - Track.AbsolutePosition.X)
                end
            end)

            -- initial value
            local initFill = ((value - min) / (max - min)) * Track.AbsoluteSize.X
            Fill.Size = UDim2.new(0, initFill, 1, 0)
            Thumb.Position = UDim2.new(0, initFill - 8, 0.5, -8)
        end

        return Tab
    end

    return Window
end

return Unsophisicated
