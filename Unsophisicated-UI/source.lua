local Unsophisicated = {}

function Unsophisicated:CreateWindow(windowName, buttonText)
    -- If buttonText not provided, use windowName or default to "Menu"
    buttonText = buttonText or windowName or "Menu"
    
    local UserInputService = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")
    local TextService = game:GetService("TextService")
    local RunService = game:GetService("RunService")

    -- Main GUI
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "UnsophisicatedUI"
    ScreenGui.Parent = game.CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false

    -- === TOP CENTER TOGGLE BUTTON (draggable, with custom text) ===
    local buttonWidth = TextService:GetTextSize(buttonText, 20, Enum.Font.GothamBold, Vector2.new(0, 0)).X + 40 -- padding
    local buttonHeight = 45
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Name = "ToggleButton"
    ToggleButton.BackgroundColor3 = Color3.fromRGB(120, 80, 200)
    ToggleButton.Size = UDim2.new(0, buttonWidth, 0, buttonHeight)
    ToggleButton.Position = UDim2.new(0.5, -buttonWidth/2, 0, 15) -- top center
    ToggleButton.Font = Enum.Font.GothamBold
    ToggleButton.Text = buttonText
    ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleButton.TextSize = 20
    ToggleButton.ZIndex = 10
    ToggleButton.Parent = ScreenGui

    -- Rounded corners (pill shape)
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(1, 0) -- fully rounded ends
    ToggleCorner.Parent = ToggleButton

    -- Subtle shadow
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

    -- Drag variables for toggle button
    local toggleDragStart, toggleStartPos, toggleDragging = nil, nil, false

    local function updateToggleInput(input)
        local delta = input.Position - toggleDragStart
        ToggleButton.Position = UDim2.new(
            toggleStartPos.X.Scale,
            toggleStartPos.X.Offset + delta.X,
            toggleStartPos.Y.Scale,
            toggleStartPos.Y.Offset + delta.Y
        )
    end

    local function onToggleInputBegan(input, processed)
        if not processed and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            toggleDragging = true
            toggleDragStart = input.Position
            toggleStartPos = ToggleButton.Position

            local conn
            conn = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    toggleDragging = false
                    conn:Disconnect()
                end
            end)
        end
    end

    ToggleButton.InputBegan:Connect(onToggleInputBegan)

    -- Connect to InputChanged for dragging
    UserInputService.InputChanged:Connect(function(input, processed)
        if toggleDragging and not processed then
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                updateToggleInput(input)
            end
        end
    end)

    -- === MAIN WINDOW ===
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
    MainFrame.Size = UDim2.new(0, 380, 0, 450)
    MainFrame.Visible = true
    MainFrame.Parent = ScreenGui

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 12)
    MainCorner.Parent = MainFrame

    local Shadow = Instance.new("Frame")
    Shadow.Name = "Shadow"
    Shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.BackgroundTransparency = 0.7
    Shadow.Size = UDim2.new(1, 8, 1, 8)
    Shadow.Position = UDim2.new(0, -4, 0, -4)
    Shadow.ZIndex = -1
    Shadow.Parent = MainFrame
    local ShadowCornerMain = Instance.new("UICorner")
    ShadowCornerMain.CornerRadius = UDim.new(0, 16)
    ShadowCornerMain.Parent = Shadow

    -- Title Bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    TitleBar.BorderSizePixel = 0
    TitleBar.Size = UDim2.new(1, 0, 0, 40)
    TitleBar.Parent = MainFrame

    local TitleBarCorner = Instance.new("UICorner")
    TitleBarCorner.CornerRadius = UDim.new(0, 12)
    TitleBarCorner.Parent = TitleBar

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

    -- Drag functionality for main window (same as before)
    local dragStartPos, startPos, isDragging = nil, nil, false

    local function updateInput(input)
        local delta = input.Position - dragStartPos
        MainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end

    local function onInputBegan(input, processed)
        if not processed and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            isDragging = true
            dragStartPos = input.Position
            startPos = MainFrame.Position

            local conn
            conn = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    isDragging = false
                    conn:Disconnect()
                end
            end)
        end
    end

    UserInputService.InputChanged:Connect(function(input, processed)
        if isDragging and not processed then
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                updateInput(input)
            end
        end
    end)

    MainFrame.InputBegan:Connect(onInputBegan)
    TitleBar.InputBegan:Connect(onInputBegan)

    -- Tab Bar
    local TabBar = Instance.new("Frame")
    TabBar.Name = "TabBar"
    TabBar.BackgroundTransparency = 1
    TabBar.Position = UDim2.new(0, 10, 0, 50)
    TabBar.Size = UDim2.new(1, -20, 0, 35)
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
    ContentArea.Position = UDim2.new(0, 10, 0, 95)
    ContentArea.Size = UDim2.new(1, -20, 1, -105)
    ContentArea.Parent = MainFrame

    local ContentCorner = Instance.new("UICorner")
    ContentCorner.CornerRadius = UDim.new(0, 8)
    ContentCorner.Parent = ContentArea

    -- Toggle functionality (click to show/hide main window)
    ToggleButton.MouseButton1Click:Connect(function()
        MainFrame.Visible = not MainFrame.Visible
        if MainFrame.Visible then
            TweenService:Create(ToggleButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(120, 80, 200)}):Play()
        else
            TweenService:Create(ToggleButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(80, 60, 150)}):Play()
        end
    end)

    -- Helper function to create elements
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
        -- Tab Button
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

        -- Tab Content
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
            local ButtonElement = CreateElement("Button", 40)
            ButtonElement.LayoutOrder = #TabContent:GetChildren()
            ButtonElement.Parent = TabContent

            local Button = Instance.new("TextButton")
            Button.Name = "Action"
            Button.BackgroundColor3 = Color3.fromRGB(100, 70, 180)
            Button.Size = UDim2.new(1, -20, 1, -10)
            Button.Position = UDim2.new(0, 10, 0, 5)
            Button.Font = Enum.Font.GothamBold
            Button.Text = config.Text
            Button.TextColor3 = Color3.fromRGB(255, 255, 255)
            Button.TextSize = 14
            Button.Parent = ButtonElement

            local ButtonCorner = Instance.new("UICorner")
            ButtonCorner.CornerRadius = UDim.new(0, 6)
            ButtonCorner.Parent = Button

            Button.MouseEnter:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(130, 90, 210)}):Play()
            end)
            Button.MouseLeave:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(100, 70, 180)}):Play()
            end)

            Button.MouseButton1Click:Connect(function()
                if config.Callback then
                    config.Callback()
                end
            end)
        end

        function Tab:AddToggle(config)
            local ToggleElement = CreateElement("Toggle", 40)
            ToggleElement.LayoutOrder = #TabContent:GetChildren()
            ToggleElement.Parent = TabContent

            local ToggleTitle = Instance.new("TextLabel")
            ToggleTitle.Name = "Title"
            ToggleTitle.BackgroundTransparency = 1
            ToggleTitle.Position = UDim2.new(0, 15, 0, 0)
            ToggleTitle.Size = UDim2.new(0, 200, 1, 0)
            ToggleTitle.Font = Enum.Font.Gotham
            ToggleTitle.Text = config.Text
            ToggleTitle.TextColor3 = Color3.fromRGB(220, 220, 240)
            ToggleTitle.TextSize = 14
            ToggleTitle.TextXAlignment = Enum.TextXAlignment.Left
            ToggleTitle.Parent = ToggleElement

            local ToggleContainer = Instance.new("Frame")
            ToggleContainer.Name = "Container"
            ToggleContainer.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
            ToggleContainer.Position = UDim2.new(1, -70, 0.5, -12)
            ToggleContainer.Size = UDim2.new(0, 50, 0, 24)
            ToggleContainer.Parent = ToggleElement

            local ContainerCorner = Instance.new("UICorner")
            ContainerCorner.CornerRadius = UDim.new(1, 0)
            ContainerCorner.Parent = ToggleContainer

            local ToggleIndicator = Instance.new("Frame")
            ToggleIndicator.Name = "Indicator"
            ToggleIndicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ToggleIndicator.BorderSizePixel = 0
            ToggleIndicator.Size = UDim2.new(0, 20, 0, 20)
            ToggleIndicator.Position = UDim2.new(0, 2, 0.5, -10)
            ToggleIndicator.Parent = ToggleContainer

            local IndicatorCorner = Instance.new("UICorner")
            IndicatorCorner.CornerRadius = UDim.new(1, 0)
            IndicatorCorner.Parent = ToggleIndicator

            local ToggleState = config.Default or false

            local function updateToggle()
                if ToggleState then
                    TweenService:Create(ToggleIndicator, TweenInfo.new(0.2), {Position = UDim2.new(1, -22, 0.5, -10)}):Play()
                    TweenService:Create(ToggleContainer, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(140, 100, 230)}):Play()
                else
                    TweenService:Create(ToggleIndicator, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -10)}):Play()
                    TweenService:Create(ToggleContainer, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 80)}):Play()
                end
            end

            updateToggle()

            ToggleContainer.InputBegan:Connect(function(input, processed)
                if not processed and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
                    ToggleState = not ToggleState
                    updateToggle()
                    if config.Callback then
                        config.Callback(ToggleState)
                    end
                end
            end)
        end

        function Tab:AddSlider(config)
            local SliderElement = CreateElement("Slider", 55)
            SliderElement.LayoutOrder = #TabContent:GetChildren()
            SliderElement.Parent = TabContent

            local SliderTitle = Instance.new("TextLabel")
            SliderTitle.Name = "Title"
            SliderTitle.BackgroundTransparency = 1
            SliderTitle.Position = UDim2.new(0, 15, 0, 8)
            SliderTitle.Size = UDim2.new(0, 200, 0, 20)
            SliderTitle.Font = Enum.Font.Gotham
            SliderTitle.Text = config.Text
            SliderTitle.TextColor3 = Color3.fromRGB(220, 220, 240)
            SliderTitle.TextSize = 14
            SliderTitle.TextXAlignment = Enum.TextXAlignment.Left
            SliderTitle.Parent = SliderElement

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
            ValueDisplay.Parent = SliderElement

            local Track = Instance.new("Frame")
            Track.Name = "Track"
            Track.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
            Track.Position = UDim2.new(0, 15, 0, 32)
            Track.Size = UDim2.new(1, -30, 0, 6)
            Track.Parent = SliderElement

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
            local currentValue = config.Default or min
            local isDragging = false

            local function updateValue(inputPos)
                local trackSize = Track.AbsoluteSize.X
                if trackSize == 0 then return end
                local relativePos = math.clamp(inputPos, 0, trackSize)
                local valueRange = max - min
                local rawValue = min + (relativePos / trackSize) * valueRange
                currentValue = math.floor((rawValue - min) / step + 0.5) * step + min
                currentValue = math.clamp(currentValue, min, max)

                local fillWidth = (currentValue - min) / valueRange * trackSize
                Fill.Size = UDim2.new(0, fillWidth, 1, 0)
                Thumb.Position = UDim2.new(0, fillWidth - 8, 0.5, -8)
                ValueDisplay.Text = tostring(currentValue)

                if config.Callback then
                    config.Callback(currentValue)
                end
            end

            local function inputChanged(input)
                if isDragging then
                    local mousePos = input.Position.X - Track.AbsolutePosition.X
                    updateValue(mousePos)
                end
            end

            Track.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    isDragging = true
                    updateValue(input.Position.X - Track.AbsolutePosition.X)
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                    inputChanged(input)
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    isDragging = false
                end
            end)

            -- Set initial value
            local initialFill = ((currentValue - min) / (max - min)) * Track.AbsoluteSize.X
            Fill.Size = UDim2.new(0, initialFill, 1, 0)
            Thumb.Position = UDim2.new(0, initialFill - 8, 0.5, -8)
        end

        return Tab
    end

    return Window
end

return Unsophisicated
