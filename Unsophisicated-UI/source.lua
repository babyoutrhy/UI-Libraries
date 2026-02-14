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

    local isMobile = UserInputService.TouchEnabled and not UserInputService.MouseEnabled
    local baseWidth = 400
    local baseHeight = 450

    local function getMobileScale()
        local viewportSize = workspace.CurrentCamera.ViewportSize
        local scaleX = viewportSize.X / 800
        local scaleY = viewportSize.Y / 1000
        return math.min(scaleX, scaleY, 1.2)
    end

    local buttonWidth = TextService:GetTextSize(buttonText, 20, Enum.Font.GothamBold, Vector2.new(0, 0)).X + 40
    local buttonHeight = 50
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

    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(1, 0)
    ToggleCorner.Parent = ToggleButton

    local ToggleShadow = Instance.new("Frame")
    ToggleShadow.Name = "ToggleShadow"
    ToggleShadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    ToggleShadow.BackgroundTransparency = 0.7
    ToggleShadow.Size = UDim2.new(1, 6, 1, 6)
    ToggleShadow.Position = UDim2.new(0, -3, 0, -3)
    ToggleShadow.ZIndex = 9
    ToggleShadow.Parent = ToggleButton
    local ShadowCorner = Instance.new("UICorner")
    ShadowCorner.CornerRadius = UDim.new(1, 0)
    ShadowCorner.Parent = ToggleShadow

    local toggleDragging = false
    local toggleDragInput
    local toggleDragStart
    local toggleStartPos

    local function updateTogglePosition(input)
        local delta = input.Position - toggleDragStart
        ToggleButton.Position = UDim2.new(
            toggleStartPos.X.Scale,
            toggleStartPos.X.Offset + delta.X,
            toggleStartPos.Y.Scale,
            toggleStartPos.Y.Offset + delta.Y
        )
    end

    ToggleButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            toggleDragging = true
            toggleDragStart = input.Position
            toggleStartPos = ToggleButton.Position
            toggleDragInput = input

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    toggleDragging = false
                end
            end)
        end
    end)

    ToggleButton.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            toggleDragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == toggleDragInput and toggleDragging then
            updateTogglePosition(input)
        end
    end)

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
    MainFrame.Size = UDim2.new(0, baseWidth, 0, baseHeight)
    MainFrame.Visible = true
    MainFrame.Parent = ScreenGui

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 12)
    MainCorner.Parent = MainFrame

    local Shadow = Instance.new("Frame")
    Shadow.Name = "MainShadow"
    Shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.BackgroundTransparency = 0.7
    Shadow.Size = UDim2.new(1, 8, 1, 8)
    Shadow.Position = UDim2.new(0, -4, 0, -4)
    Shadow.ZIndex = -1
    Shadow.Parent = MainFrame
    local ShadowCornerMain = Instance.new("UICorner")
    ShadowCornerMain.CornerRadius = UDim.new(0, 16)
    ShadowCornerMain.Parent = Shadow

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

    local mainDragging = false
    local mainDragInput
    local mainDragStart
    local mainStartPos

    local function updateMainPosition(input)
        local delta = input.Position - mainDragStart
        MainFrame.Position = UDim2.new(
            mainStartPos.X.Scale,
            mainStartPos.X.Offset + delta.X,
            mainStartPos.Y.Scale,
            mainStartPos.Y.Offset + delta.Y
        )
    end

    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            mainDragging = true
            mainDragStart = input.Position
            mainStartPos = MainFrame.Position
            mainDragInput = input

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    mainDragging = false
                end
            end)
        end
    end)

    TitleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            mainDragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == mainDragInput and mainDragging then
            updateMainPosition(input)
        end
    end)

    local function updateMainFrameScale()
        if isMobile then
            local newScale = getMobileScale()
            local newWidth = baseWidth * newScale
            local newHeight = baseHeight * newScale

            MainFrame.Size = UDim2.new(0, newWidth, 0, newHeight)
            MainFrame.Position = UDim2.new(0.5, -newWidth/2, 0.5, -newHeight/2)
        end
    end

    if isMobile then
        workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateMainFrameScale)
        updateMainFrameScale()
    end

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

    ToggleButton.MouseButton1Click:Connect(function()
        MainFrame.Visible = not MainFrame.Visible
        local targetColor = MainFrame.Visible and Color3.fromRGB(120, 80, 200) or Color3.fromRGB(80, 60, 150)
        TweenService:Create(ToggleButton, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
    end)

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
            local dragConnection

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

                    dragConnection = RunService.RenderStepped:Connect(function()
                        if not dragging then return end
                        local mousePos = UserInputService:GetMouseLocation()
                        updateValueFromPos(mousePos.X - Track.AbsolutePosition.X)
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

            local initFill = ((value - min) / (max - min)) * Track.AbsoluteSize.X
            Fill.Size = UDim2.new(0, initFill, 1, 0)
            Thumb.Position = UDim2.new(0, initFill - 8, 0.5, -8)
        end

        function Tab:AddDropdown(config)
            local DropdownElement = CreateElement("Dropdown", 40)
            DropdownElement.ClipsDescendants = false
            DropdownElement.LayoutOrder = #TabContent:GetChildren()
            DropdownElement.Parent = TabContent

            local DropdownTitle = Instance.new("TextLabel")
            DropdownTitle.Name = "Title"
            DropdownTitle.BackgroundTransparency = 1
            DropdownTitle.Position = UDim2.new(0, 15, 0, 0)
            DropdownTitle.Size = UDim2.new(0, 150, 1, 0)
            DropdownTitle.Font = Enum.Font.Gotham
            DropdownTitle.Text = config.Text
            DropdownTitle.TextColor3 = Color3.fromRGB(220, 220, 240)
            DropdownTitle.TextSize = 14
            DropdownTitle.TextYAlignment = Enum.TextYAlignment.Center
            DropdownTitle.TextXAlignment = Enum.TextXAlignment.Left
            DropdownTitle.Parent = DropdownElement

            local SelectionButton = Instance.new("TextButton")
            SelectionButton.Name = "SelectionButton"
            SelectionButton.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
            SelectionButton.Position = UDim2.new(1, -160, 0.5, -15)
            SelectionButton.Size = UDim2.new(0, 150, 0, 30)
            SelectionButton.Font = Enum.Font.Gotham
            SelectionButton.Text = "Select"
            SelectionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            SelectionButton.TextSize = 14
            SelectionButton.Parent = DropdownElement

            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(0, 6)
            Corner.Parent = SelectionButton

            local DropdownContainer = Instance.new("Frame")
            DropdownContainer.Name = "DropdownContainer"
            DropdownContainer.BackgroundTransparency = 1
            DropdownContainer.Size = UDim2.new(0, 150, 0, 0)
            DropdownContainer.Visible = false
            DropdownContainer.ZIndex = 100
            DropdownContainer.Parent = ScreenGui

            local DropdownList = Instance.new("ScrollingFrame")
            DropdownList.Name = "DropdownList"
            DropdownList.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
            DropdownList.BorderSizePixel = 0
            DropdownList.Size = UDim2.new(1, 0, 1, 0)
            DropdownList.ScrollBarThickness = 5
            DropdownList.CanvasSize = UDim2.new(0, 0, 0, 0)
            DropdownList.ZIndex = 101
            DropdownList.Parent = DropdownContainer

            local Corner2 = Instance.new("UICorner")
            Corner2.CornerRadius = UDim.new(0, 6)
            Corner2.Parent = DropdownList

            local DropdownShadow = Instance.new("Frame")
            DropdownShadow.Name = "DropdownShadow"
            DropdownShadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            DropdownShadow.BackgroundTransparency = 0.7
            DropdownShadow.Size = UDim2.new(1, 6, 1, 6)
            DropdownShadow.Position = UDim2.new(0, -3, 0, -3)
            DropdownShadow.ZIndex = 99
            DropdownShadow.Parent = DropdownContainer
            local DropShadowCorner = Instance.new("UICorner")
            DropShadowCorner.CornerRadius = UDim.new(0, 8)
            DropShadowCorner.Parent = DropdownShadow

            local ListLayout = Instance.new("UIListLayout")
            ListLayout.Parent = DropdownList
            ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            ListLayout.Padding = UDim.new(0, 2)

            local dropdownOpen = false
            local positionConnection
            local selectedOptions = {}
            local isMultiple = config.MultipleOptions or false

            if not isMultiple and type(config.Default) == "string" then
                SelectionButton.Text = config.Default
            elseif isMultiple and type(config.Default) == "table" then
                for _, opt in ipairs(config.Default) do
                    selectedOptions[opt] = true
                end
                local count = 0
                for _ in pairs(selectedOptions) do count = count + 1 end
                if count > 0 then
                    SelectionButton.Text = count .. " selected"
                end
            end

            local function updateListSize()
                local totalHeight = 0
                for _, child in ipairs(DropdownList:GetChildren()) do
                    if child:IsA("TextButton") then
                        totalHeight = totalHeight + child.AbsoluteSize.Y + ListLayout.Padding.Offset
                    end
                end
                DropdownList.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
                DropdownContainer.Size = UDim2.new(0, 150, 0, math.min(150, totalHeight))
            end

            local function updateDropdownPosition()
                local buttonPos = SelectionButton.AbsolutePosition
                DropdownContainer.Position = UDim2.new(
                    0,
                    buttonPos.X,
                    0,
                    buttonPos.Y + SelectionButton.AbsoluteSize.Y + 5
                )
            end

            local function toggleDropdown()
                if dropdownOpen then
                    DropdownContainer.Visible = false
                    dropdownOpen = false
                    if positionConnection then
                        positionConnection:Disconnect()
                        positionConnection = nil
                    end
                else
                    updateDropdownPosition()
                    DropdownContainer.Visible = true
                    dropdownOpen = true
                    positionConnection = RunService.Heartbeat:Connect(updateDropdownPosition)
                end
            end

            for i, option in ipairs(config.Options) do
                local OptionButton = Instance.new("TextButton")
                OptionButton.Name = option
                OptionButton.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
                OptionButton.Size = UDim2.new(1, -4, 0, 30)
                OptionButton.Position = UDim2.new(0, 2, 0, 0)
                OptionButton.Font = Enum.Font.Gotham
                OptionButton.Text = option
                OptionButton.TextColor3 = Color3.fromRGB(220, 220, 240)
                OptionButton.TextSize = 14
                OptionButton.ZIndex = 102
                OptionButton.TextTruncate = Enum.TextTruncate.AtEnd
                OptionButton.LayoutOrder = i
                OptionButton.Parent = DropdownList

                local OptionCorner = Instance.new("UICorner")
                OptionCorner.CornerRadius = UDim.new(0, 4)
                OptionCorner.Parent = OptionButton

                local Checkbox
                if isMultiple then
                    Checkbox = Instance.new("Frame")
                    Checkbox.Name = "Checkbox"
                    Checkbox.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
                    Checkbox.Position = UDim2.new(0, 8, 0.5, -8)
                    Checkbox.Size = UDim2.new(0, 16, 0, 16)
                    Checkbox.ZIndex = 103
                    Checkbox.Parent = OptionButton

                    local CheckboxCorner = Instance.new("UICorner")
                    CheckboxCorner.CornerRadius = UDim.new(0, 3)
                    CheckboxCorner.Parent = Checkbox

                    local Checkmark = Instance.new("TextLabel")
                    Checkmark.Name = "Checkmark"
                    Checkmark.BackgroundTransparency = 1
                    Checkmark.Size = UDim2.new(1, 0, 1, 0)
                    Checkmark.Font = Enum.Font.GothamBold
                    Checkmark.Text = "✓"
                    Checkmark.TextColor3 = Color3.fromRGB(255, 255, 255)
                    Checkmark.TextSize = 14
                    Checkmark.Visible = selectedOptions[option] or false
                    Checkmark.ZIndex = 104
                    Checkmark.Parent = Checkbox

                    if selectedOptions[option] then
                        Checkbox.BackgroundColor3 = Color3.fromRGB(140, 100, 230)
                    end

                    OptionButton.TextXAlignment = Enum.TextXAlignment.Center
                    OptionButton.Text = "   " .. option
                end

                OptionButton.MouseButton1Click:Connect(function()
                    if isMultiple then
                        selectedOptions[option] = not selectedOptions[option]
                        if Checkbox then
                            if selectedOptions[option] then
                                Checkbox.BackgroundColor3 = Color3.fromRGB(140, 100, 230)
                                Checkbox.Checkmark.Visible = true
                            else
                                Checkbox.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
                                Checkbox.Checkmark.Visible = false
                            end
                        end

                        local count = 0
                        for _ in pairs(selectedOptions) do count = count + 1 end
                        SelectionButton.Text = (count > 0) and (count .. " selected") or "Select"

                        if config.Callback then
                            local selected = {}
                            for opt, sel in pairs(selectedOptions) do
                                if sel then
                                    table.insert(selected, opt)
                                end
                            end
                            config.Callback(selected)
                        end
                    else
                        SelectionButton.Text = option
                        toggleDropdown()
                        if config.Callback then
                            config.Callback(option)
                        end
                    end
                end)
            end

            ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateListSize)
            updateListSize()

            SelectionButton.MouseButton1Click:Connect(toggleDropdown)

            DropdownElement.Destroying:Connect(function()
                if positionConnection then
                    positionConnection:Disconnect()
                end
                DropdownContainer:Destroy()
            end)
        end

        return Tab
    end

    return Window
end

return Unsophisicated
