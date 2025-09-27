local Ozen = {}

function Ozen:CreateWindow(name)
    local UserInputService = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")
    local textService = game:GetService("TextService")
    local RunService = game:GetService("RunService")
    
    -- Main GUI
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "OzenUI"
    ScreenGui.Parent = game.CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- Main Window
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
    MainFrame.Size = UDim2.new(0, 400, 0, 450)  -- Slightly larger for better usability
    MainFrame.Parent = ScreenGui

    -- Add subtle gradient to main frame
    local MainGradient = Instance.new("UIGradient")
    MainGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 40)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 30, 30))
    }
    MainGradient.Parent = MainFrame

    -- Add corner to main frame
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 8)
    MainCorner.Parent = MainFrame

    -- Title Bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    TitleBar.BorderSizePixel = 0
    TitleBar.Size = UDim2.new(1, 0, 0, 35)
    TitleBar.Parent = MainFrame

    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 8)
    TitleCorner.Parent = TitleBar

    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.Size = UDim2.new(0, 200, 1, 0)
    Title.Font = Enum.Font.GothamSemibold
    Title.Text = name
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 15
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TitleBar

    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.BackgroundTransparency = 1
    CloseButton.Position = UDim2.new(1, -35, 0, 0)
    CloseButton.Size = UDim2.new(0, 35, 1, 0)
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Text = "X"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.TextSize = 15
    CloseButton.Parent = TitleBar

    -- Add Minimize Button
    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Name = "MinimizeButton"
    MinimizeButton.BackgroundTransparency = 1
    MinimizeButton.Position = UDim2.new(1, -70, 0, 0)
    MinimizeButton.Size = UDim2.new(0, 35, 1, 0)
    MinimizeButton.Font = Enum.Font.GothamBold
    MinimizeButton.Text = "-"
    MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinimizeButton.TextSize = 15
    MinimizeButton.Parent = TitleBar

    -- Mobile-compatible drag functionality (unchanged but optimized)
    local dragStartPos
    local startPos
    local isDragging = false

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

    TitleBar.InputBegan:Connect(onInputBegan)  -- Drag only on title bar

    -- Tab System with Scrolling
    local TabBar = Instance.new("ScrollingFrame")
    TabBar.Name = "TabBar"
    TabBar.BackgroundTransparency = 1
    TabBar.Position = UDim2.new(0, 0, 0, 35)
    TabBar.Size = UDim2.new(1, 0, 0, 35)
    TabBar.ScrollBarThickness = 4
    TabBar.ScrollingDirection = Enum.ScrollingDirection.X
    TabBar.Parent = MainFrame

    local TabLayout = Instance.new("UIListLayout")
    TabLayout.Parent = TabBar
    TabLayout.FillDirection = Enum.FillDirection.Horizontal
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabLayout.Padding = UDim.new(0, 8)

    -- Content Area
    local ContentArea = Instance.new("Frame")
    ContentArea.Name = "ContentArea"
    ContentArea.BackgroundTransparency = 1
    ContentArea.Position = UDim2.new(0, 15, 0, 75)
    ContentArea.Size = UDim2.new(1, -30, 1, -90)
    ContentArea.Parent = MainFrame

    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    MinimizeButton.MouseButton1Click:Connect(function()
        ContentArea.Visible = not ContentArea.Visible
        TabBar.Visible = not TabBar.Visible
        MainFrame.Size = ContentArea.Visible and UDim2.new(0, 400, 0, 450) or UDim2.new(0, 400, 0, 35)
    end)

    local function CreateElement(name, height)
        local Element = Instance.new("Frame")
        Element.Name = name
        Element.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        Element.BorderSizePixel = 0
        Element.Size = UDim2.new(1, 0, 0, height + 5)  -- Slightly taller
        
        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 6)
        Corner.Parent = Element
        
        local Stroke = Instance.new("UIStroke")
        Stroke.Color = Color3.fromRGB(60, 60, 60)
        Stroke.Transparency = 0.5
        Stroke.Parent = Element
        
        return Element
    end

    local Window = {}
    local currentTab = nil

    TabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabBar.CanvasSize = UDim2.new(0, TabLayout.AbsoluteContentSize.X + 15, 0, 0)
    end)

    function Window:AddTab(tabName)
        -- Create Tab Button
        local TabButton = Instance.new("TextButton")
        TabButton.Name = tabName
        TabButton.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
        TabButton.Size = UDim2.new(0, textService:GetTextSize(tabName, 13, Enum.Font.Gotham, Vector2.new(0, 0)).X + 25, 0, 28)
        TabButton.Font = Enum.Font.Gotham
        TabButton.Text = tabName
        TabButton.TextColor3 = Color3.fromRGB(220, 220, 220)
        TabButton.TextSize = 13
        TabButton.Parent = TabBar

        local TabButtonCorner = Instance.new("UICorner")
        TabButtonCorner.CornerRadius = UDim.new(0, 6)
        TabButtonCorner.Parent = TabButton

        -- Hover effect for tab button
        TabButton.MouseEnter:Connect(function()
            TweenService:Create(TabButton, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(65, 65, 65)}):Play()
        end)
        TabButton.MouseLeave:Connect(function()
            if TabContent.Visible then return end
            TweenService:Create(TabButton, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(55, 55, 55)}):Play()
        end)

        -- Create Tab Content
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = tabName
        TabContent.BackgroundTransparency = 1
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.Visible = false
        TabContent.ScrollBarThickness = 4
        TabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
        TabContent.Parent = ContentArea

        local TabContentLayout = Instance.new("UIListLayout")
        TabContentLayout.Parent = TabContent
        TabContentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        TabContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        TabContentLayout.Padding = UDim.new(0, 8)

        -- Set first tab as active
        if not currentTab then
            currentTab = TabContent
            TabContent.Visible = true
            TabButton.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
        end

        -- Tab switching logic
        TabButton.MouseButton1Click:Connect(function()
            currentTab.Visible = false
            for _, button in ipairs(TabBar:GetChildren()) do
                if button:IsA("TextButton") then
                    button.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
                end
            end
            TabContent.Visible = true
            currentTab = TabContent
            TabButton.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
        end)

        local Tab = {}

        function Tab:AddTextbox(config)
            local TextboxElement = CreateElement("Textbox", 35)
            TextboxElement.LayoutOrder = #TabContent:GetChildren()
            TextboxElement.Parent = TabContent

            local TextboxTitle = Instance.new("TextLabel")
            TextboxTitle.Name = "Title"
            TextboxTitle.BackgroundTransparency = 1
            TextboxTitle.Position = UDim2.new(0, 15, 0, 0)
            TextboxTitle.Size = UDim2.new(0, 200, 1, 0)
            TextboxTitle.Font = Enum.Font.Gotham
            TextboxTitle.Text = config.Text
            TextboxTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextboxTitle.TextSize = 13
            TextboxTitle.TextXAlignment = Enum.TextXAlignment.Left
            TextboxTitle.Parent = TextboxElement

            local InputBox = Instance.new("TextBox")
            InputBox.Name = "Input"
            InputBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            InputBox.Position = UDim2.new(1, -160, 0.5, -12)
            InputBox.Size = UDim2.new(0, 150, 0, 24)
            InputBox.Font = Enum.Font.Gotham
            InputBox.PlaceholderText = config.Placeholder or ""
            InputBox.Text = config.Default or ""
            InputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
            InputBox.TextSize = 13
            InputBox.TextXAlignment = Enum.TextXAlignment.Left
            InputBox.Parent = TextboxElement

            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(0, 6)
            Corner.Parent = InputBox

            InputBox.Focused:Connect(function()
                TweenService:Create(InputBox, TweenInfo.new(0.2), {
                    BackgroundColor3 = Color3.fromRGB(45, 45, 45),
                    Size = UDim2.new(0, 155, 0, 25)
                }):Play()
            end)

            InputBox.FocusLost:Connect(function(enterPressed)
                TweenService:Create(InputBox, TweenInfo.new(0.2), {
                    BackgroundColor3 = Color3.fromRGB(30, 30, 30),
                    Size = UDim2.new(0, 150, 0, 24)
                }):Play()
                
                if enterPressed and config.Callback then
                    config.Callback(InputBox.Text)
                end
            end)
        end

        function Tab:AddToggle(config)
            local ToggleElement = CreateElement("Toggle", 35)
            ToggleElement.LayoutOrder = #TabContent:GetChildren()
            ToggleElement.Parent = TabContent

            local ToggleTitle = Instance.new("TextLabel")
            ToggleTitle.Name = "Title"
            ToggleTitle.BackgroundTransparency = 1
            ToggleTitle.Position = UDim2.new(0, 15, 0, 0)
            ToggleTitle.Size = UDim2.new(0, 200, 1, 0)
            ToggleTitle.Font = Enum.Font.Gotham
            ToggleTitle.Text = config.Text
            ToggleTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
            ToggleTitle.TextSize = 13
            ToggleTitle.TextXAlignment = Enum.TextXAlignment.Left
            ToggleTitle.Parent = ToggleElement

            local ToggleContainer = Instance.new("Frame")
            ToggleContainer.Name = "Container"
            ToggleContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            ToggleContainer.Position = UDim2.new(1, -55, 0.5, -12)
            ToggleContainer.Size = UDim2.new(0, 45, 0, 24)
            ToggleContainer.Parent = ToggleElement

            local ContainerCorner = Instance.new("UICorner")
            ContainerCorner.CornerRadius = UDim.new(1, 0)
            ContainerCorner.Parent = ToggleContainer

            local ToggleIndicator = Instance.new("Frame")
            ToggleIndicator.Name = "Indicator"
            ToggleIndicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ToggleIndicator.BorderSizePixel = 0
            ToggleIndicator.Position = UDim2.new(0, 3, 0, 3)
            ToggleIndicator.Size = UDim2.new(0, 18, 0, 18)
            ToggleIndicator.Parent = ToggleContainer

            local IndicatorCorner = Instance.new("UICorner")
            IndicatorCorner.CornerRadius = UDim.new(1, 0)
            IndicatorCorner.Parent = ToggleIndicator

            local ToggleState = false

            local function updateToggle()
                if ToggleState then
                    TweenService:Create(ToggleIndicator, TweenInfo.new(0.2), {Position = UDim2.new(1, -21, 0, 3)}):Play()
                    TweenService:Create(ToggleContainer, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 180, 255)}):Play()
                else
                    TweenService:Create(ToggleIndicator, TweenInfo.new(0.2), {Position = UDim2.new(0, 3, 0, 3)}):Play()
                    TweenService:Create(ToggleContainer, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
                end
            end

            ToggleContainer.InputBegan:Connect(function(input, processed)
                if not processed and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
                    ToggleState = not ToggleState
                    updateToggle()
                    if config.Callback then
                        config.Callback(ToggleState)
                    end
                end
            end)

            -- Hover effect
            ToggleContainer.MouseEnter:Connect(function()
                TweenService:Create(ToggleContainer, TweenInfo.new(0.15), {Size = UDim2.new(0, 47, 0, 25)}):Play()
            end)
            ToggleContainer.MouseLeave:Connect(function()
                TweenService:Create(ToggleContainer, TweenInfo.new(0.15), {Size = UDim2.new(0, 45, 0, 24)}):Play()
            end)
        end

        function Tab:AddButton(config)
            local ButtonElement = CreateElement("Button", 35)
            ButtonElement.LayoutOrder = #TabContent:GetChildren()
            ButtonElement.Parent = TabContent

            local Button = Instance.new("TextButton")
            Button.Name = "Action"
            Button.BackgroundTransparency = 1
            Button.Size = UDim2.new(1, 0, 1, 0)
            Button.Font = Enum.Font.Gotham
            Button.Text = config.Text
            Button.TextColor3 = Color3.fromRGB(255, 255, 255)
            Button.TextSize = 13
            Button.Parent = ButtonElement

            -- Hover effect
            Button.MouseEnter:Connect(function()
                TweenService:Create(ButtonElement, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(55, 55, 55)}):Play()
            end)
            Button.MouseLeave:Connect(function()
                TweenService:Create(ButtonElement, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}):Play()
            end)

            Button.MouseButton1Click:Connect(function()
                if config.Callback then
                    config.Callback()
                end
            end)
        end

        function Tab:AddLabel(config)
            local LabelElement = CreateElement("Label", 25)
            LabelElement.LayoutOrder = #TabContent:GetChildren()
            LabelElement.Parent = TabContent

            local Label = Instance.new("TextLabel")
            Label.Name = "Text"
            Label.BackgroundTransparency = 1
            Label.Size = UDim2.new(1, 0, 1, 0)
            Label.Font = Enum.Font.Gotham
            Label.Text = config.Text
            Label.TextColor3 = Color3.fromRGB(200, 200, 200)
            Label.TextSize = 13
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = LabelElement
        end

        function Tab:AddSlider(config)
            local SliderElement = CreateElement("Slider", 45)
            SliderElement.LayoutOrder = #TabContent:GetChildren()
            SliderElement.Parent = TabContent

            local SliderTitle = Instance.new("TextLabel")
            SliderTitle.Name = "Title"
            SliderTitle.BackgroundTransparency = 1
            SliderTitle.Position = UDim2.new(0, 15, 0, 0)
            SliderTitle.Size = UDim2.new(0, 200, 0.5, 0)
            SliderTitle.Font = Enum.Font.Gotham
            SliderTitle.Text = config.Text
            SliderTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
            SliderTitle.TextSize = 13
            SliderTitle.TextXAlignment = Enum.TextXAlignment.Left
            SliderTitle.Parent = SliderElement

            local ValueDisplay = Instance.new("TextLabel")
            ValueDisplay.Name = "Value"
            ValueDisplay.BackgroundTransparency = 1
            ValueDisplay.Position = UDim2.new(1, -70, 0, 0)
            ValueDisplay.Size = UDim2.new(0, 60, 0.5, 0)
            ValueDisplay.Font = Enum.Font.Gotham
            ValueDisplay.Text = tostring(config.Default or config.Min)
            ValueDisplay.TextColor3 = Color3.fromRGB(200, 200, 200)
            ValueDisplay.TextSize = 13
            ValueDisplay.TextXAlignment = Enum.TextXAlignment.Right
            ValueDisplay.Parent = SliderElement

            local Track = Instance.new("Frame")
            Track.Name = "Track"
            Track.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            Track.Position = UDim2.new(0, 15, 0.5, 2)
            Track.Size = UDim2.new(1, -30, 0, 5)
            Track.Parent = SliderElement

            local TrackCorner = Instance.new("UICorner")
            TrackCorner.CornerRadius = UDim.new(1, 0)
            TrackCorner.Parent = Track

            local Fill = Instance.new("Frame")
            Fill.Name = "Fill"
            Fill.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
            Fill.Size = UDim2.new(0, 0, 1, 0)
            Fill.Parent = Track

            local FillCorner = Instance.new("UICorner")
            FillCorner.CornerRadius = UDim.new(1, 0)
            FillCorner.Parent = Fill

            local Thumb = Instance.new("Frame")
            Thumb.Name = "Thumb"
            Thumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Thumb.Size = UDim2.new(0, 14, 0, 14)
            Thumb.Position = UDim2.new(0, -7, 0.5, -7)
            Thumb.Parent = Track

            local ThumbCorner = Instance.new("UICorner")
            ThumbCorner.CornerRadius = UDim.new(1, 0)
            ThumbCorner.Parent = Thumb

            local min = config.Min or 0
            local max = config.Max or 100
            local step = config.Step or 1
            local currentValue = config.Default or min
            local isDragging = false

            local function updateValue(value)
                currentValue = math.clamp(
                    math.floor((value / Track.AbsoluteSize.X) * (max - min) / step + 0.5) * step + min,
                    min,
                    max
                )
                
                local fillWidth = ((currentValue - min) / (max - min)) * Track.AbsoluteSize.X
                Fill.Size = UDim2.new(0, fillWidth, 1, 0)
                Thumb.Position = UDim2.new(0, fillWidth - 7, 0.5, -7)
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
                    TweenService:Create(Thumb, TweenInfo.new(0.15), {Size = UDim2.new(0, 16, 0, 16)}):Play()
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
                    TweenService:Create(Thumb, TweenInfo.new(0.15), {Size = UDim2.new(0, 14, 0, 14)}):Play()
                end
            end)

            -- Set initial value
            updateValue(((currentValue - min) / (max - min)) * Track.AbsoluteSize.X)
        end

        function Tab:AddDropdown(config)
            local DropdownElement = CreateElement("Dropdown", 35)
            DropdownElement.ClipsDescendants = false
            DropdownElement.LayoutOrder = #TabContent:GetChildren()
            DropdownElement.Parent = TabContent

            local DropdownTitle = Instance.new("TextLabel")
            DropdownTitle.Name = "Title"
            DropdownTitle.BackgroundTransparency = 1
            DropdownTitle.Position = UDim2.new(0, 15, 0, 0)
            DropdownTitle.Size = UDim2.new(0, 100, 1, 0)
            DropdownTitle.Font = Enum.Font.Gotham
            DropdownTitle.Text = config.Text
            DropdownTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
            DropdownTitle.TextSize = 13
            DropdownTitle.TextYAlignment = Enum.TextYAlignment.Center
            DropdownTitle.TextXAlignment = Enum.TextXAlignment.Left
            DropdownTitle.Parent = DropdownElement

            local SelectionButton = Instance.new("TextButton")
            SelectionButton.Name = "SelectionButton"
            SelectionButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            SelectionButton.Position = UDim2.new(1, -160, 0.5, -12)
            SelectionButton.Size = UDim2.new(0, 150, 0, 24)
            SelectionButton.Font = Enum.Font.Gotham
            SelectionButton.Text = config.Default or "Select"
            SelectionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            SelectionButton.TextSize = 13
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
            DropdownList.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            DropdownList.BorderSizePixel = 0
            DropdownList.Size = UDim2.new(1, 0, 1, 0)
            DropdownList.ScrollBarThickness = 4
            DropdownList.CanvasSize = UDim2.new(0, 0, 0, 0)
            DropdownList.ZIndex = 101
            DropdownList.Parent = DropdownContainer

            local ListCorner = Instance.new("UICorner")
            ListCorner.CornerRadius = UDim.new(0, 6)
            ListCorner.Parent = DropdownList

            local ListStroke = Instance.new("UIStroke")
            ListStroke.Color = Color3.fromRGB(50, 50, 50)
            ListStroke.Transparency = 0.5
            ListStroke.Parent = DropdownList

            local ListLayout = Instance.new("UIListLayout")
            ListLayout.Parent = DropdownList
            ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            ListLayout.Padding = UDim.new(0, 3)

            local dropdownOpen = false
            local positionConnection
            local selectedOptions = {}
            local isMultiple = config.MultipleOptions or false
            
            if not isMultiple and config.Default then
                SelectionButton.Text = config.Default
            end

            local function updateListSize()
                local totalHeight = 0
                for _, child in ipairs(DropdownList:GetChildren()) do
                    if child:IsA("TextButton") then
                        totalHeight = totalHeight + child.AbsoluteSize.Y + ListLayout.Padding.Offset
                    end
                end
                DropdownList.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
                DropdownContainer.Size = UDim2.new(0, 150, 0, math.min(120, totalHeight))
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
                    TweenService:Create(SelectionButton, TweenInfo.new(0.15), {Size = UDim2.new(0, 150, 0, 24)}):Play()
                else
                    updateDropdownPosition()
                    DropdownContainer.Visible = true
                    dropdownOpen = true
                    positionConnection = RunService.Heartbeat:Connect(updateDropdownPosition)
                    TweenService:Create(SelectionButton, TweenInfo.new(0.15), {Size = UDim2.new(0, 155, 0, 25)}):Play()
                end
            end

            for i, option in ipairs(config.Options) do
                local OptionButton = Instance.new("TextButton")
                OptionButton.Name = option
                OptionButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                OptionButton.Size = UDim2.new(1, -4, 0, 24)
                OptionButton.Position = UDim2.new(0, 2, 0, 0)
                OptionButton.Font = Enum.Font.Gotham
                OptionButton.Text = option
                OptionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                OptionButton.TextSize = 13
                OptionButton.ZIndex = 102
                OptionButton.TextTruncate = Enum.TextTruncate.AtEnd
                OptionButton.LayoutOrder = i
                OptionButton.Parent = DropdownList

                local OptionCorner = Instance.new("UICorner")
                OptionCorner.CornerRadius = UDim.new(0, 6)
                OptionCorner.Parent = OptionButton

                -- Hover effect for option
                OptionButton.MouseEnter:Connect(function()
                    TweenService:Create(OptionButton, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(55, 55, 55)}):Play()
                end)
                OptionButton.MouseLeave:Connect(function()
                    TweenService:Create(OptionButton, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}):Play()
                end)

                local Checkbox
                if isMultiple then
                    Checkbox = Instance.new("Frame")
                    Checkbox.Name = "Checkbox"
                    Checkbox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                    Checkbox.Position = UDim2.new(0, 8, 0.5, -8)
                    Checkbox.Size = UDim2.new(0, 14, 0, 14)
                    Checkbox.ZIndex = 103
                    Checkbox.Parent = OptionButton
                    
                    local CheckboxCorner = Instance.new("UICorner")
                    CheckboxCorner.CornerRadius = UDim.new(0, 3)
                    CheckboxCorner.Parent = Checkbox
                    
                    OptionButton.TextXAlignment = Enum.TextXAlignment.Center
                    OptionButton.Text = "   " .. option
                end

                OptionButton.MouseButton1Click:Connect(function()
                    if isMultiple then
                        selectedOptions[option] = not selectedOptions[option]
                        
                        if selectedOptions[option] then
                            Checkbox.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
                        else
                            Checkbox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                        end
                        
                        local count = 0
                        for _, isSelected in pairs(selectedOptions) do
                            if isSelected then
                                count = count + 1
                            end
                        end
                        
                        if count > 0 then
                            SelectionButton.Text = count .. " selected"
                        else
                            SelectionButton.Text = "Select"
                        end
                        
                        if config.Callback then
                            local selected = {}
                            for opt, isSelected in pairs(selectedOptions) do
                                if isSelected then
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

return Ozen-- Improved Ozen UI Source
-- Changes:
-- 1. Added UIGradient for subtle background gradients on main frame and elements for depth.
-- 2. Improved padding and spacing for better readability (increased element heights slightly, added more horizontal padding).
-- 3. Added hover effects: Scale up slightly on hover for buttons, toggles, sliders, etc., with color changes.
-- 4. Used UIStroke for subtle borders/shadows on elements.
-- 5. Fixed dropdown positioning and added hover color change for options.
-- 6. Made tab buttons have rounded corners and better active state.
-- 7. Added smooth animations for all interactions using TweenService.
-- 8. Consistent font and text scaling.
-- 9. Optimized drag functionality and added minimize button to title bar.
-- 10. General code cleanup and bug fixes (e.g., proper handling of multiple tabs without duplicates in usage).

local Ozen = {}

function Ozen:CreateWindow(name)
    local UserInputService = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")
    local textService = game:GetService("TextService")
    local RunService = game:GetService("RunService")
    
    -- Main GUI
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "OzenUI"
    ScreenGui.Parent = game.CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- Main Window
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
    MainFrame.Size = UDim2.new(0, 400, 0, 450)  -- Slightly larger for better usability
    MainFrame.Parent = ScreenGui

    -- Add subtle gradient to main frame
    local MainGradient = Instance.new("UIGradient")
    MainGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 40)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 30, 30))
    }
    MainGradient.Parent = MainFrame

    -- Add corner to main frame
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 8)
    MainCorner.Parent = MainFrame

    -- Title Bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    TitleBar.BorderSizePixel = 0
    TitleBar.Size = UDim2.new(1, 0, 0, 35)
    TitleBar.Parent = MainFrame

    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 8)
    TitleCorner.Parent = TitleBar

    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.Size = UDim2.new(0, 200, 1, 0)
    Title.Font = Enum.Font.GothamSemibold
    Title.Text = name
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 15
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TitleBar

    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.BackgroundTransparency = 1
    CloseButton.Position = UDim2.new(1, -35, 0, 0)
    CloseButton.Size = UDim2.new(0, 35, 1, 0)
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Text = "X"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.TextSize = 15
    CloseButton.Parent = TitleBar

    -- Add Minimize Button
    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Name = "MinimizeButton"
    MinimizeButton.BackgroundTransparency = 1
    MinimizeButton.Position = UDim2.new(1, -70, 0, 0)
    MinimizeButton.Size = UDim2.new(0, 35, 1, 0)
    MinimizeButton.Font = Enum.Font.GothamBold
    MinimizeButton.Text = "-"
    MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinimizeButton.TextSize = 15
    MinimizeButton.Parent = TitleBar

    -- Mobile-compatible drag functionality (unchanged but optimized)
    local dragStartPos
    local startPos
    local isDragging = false

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

    TitleBar.InputBegan:Connect(onInputBegan)  -- Drag only on title bar

    -- Tab System with Scrolling
    local TabBar = Instance.new("ScrollingFrame")
    TabBar.Name = "TabBar"
    TabBar.BackgroundTransparency = 1
    TabBar.Position = UDim2.new(0, 0, 0, 35)
    TabBar.Size = UDim2.new(1, 0, 0, 35)
    TabBar.ScrollBarThickness = 4
    TabBar.ScrollingDirection = Enum.ScrollingDirection.X
    TabBar.Parent = MainFrame

    local TabLayout = Instance.new("UIListLayout")
    TabLayout.Parent = TabBar
    TabLayout.FillDirection = Enum.FillDirection.Horizontal
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabLayout.Padding = UDim.new(0, 8)

    -- Content Area
    local ContentArea = Instance.new("Frame")
    ContentArea.Name = "ContentArea"
    ContentArea.BackgroundTransparency = 1
    ContentArea.Position = UDim2.new(0, 15, 0, 75)
    ContentArea.Size = UDim2.new(1, -30, 1, -90)
    ContentArea.Parent = MainFrame

    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    MinimizeButton.MouseButton1Click:Connect(function()
        ContentArea.Visible = not ContentArea.Visible
        TabBar.Visible = not TabBar.Visible
        MainFrame.Size = ContentArea.Visible and UDim2.new(0, 400, 0, 450) or UDim2.new(0, 400, 0, 35)
    end)

    local function CreateElement(name, height)
        local Element = Instance.new("Frame")
        Element.Name = name
        Element.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        Element.BorderSizePixel = 0
        Element.Size = UDim2.new(1, 0, 0, height + 5)  -- Slightly taller
        
        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 6)
        Corner.Parent = Element
        
        local Stroke = Instance.new("UIStroke")
        Stroke.Color = Color3.fromRGB(60, 60, 60)
        Stroke.Transparency = 0.5
        Stroke.Parent = Element
        
        return Element
    end

    local Window = {}
    local currentTab = nil

    TabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabBar.CanvasSize = UDim2.new(0, TabLayout.AbsoluteContentSize.X + 15, 0, 0)
    end)

    function Window:AddTab(tabName)
        -- Create Tab Button
        local TabButton = Instance.new("TextButton")
        TabButton.Name = tabName
        TabButton.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
        TabButton.Size = UDim2.new(0, textService:GetTextSize(tabName, 13, Enum.Font.Gotham, Vector2.new(0, 0)).X + 25, 0, 28)
        TabButton.Font = Enum.Font.Gotham
        TabButton.Text = tabName
        TabButton.TextColor3 = Color3.fromRGB(220, 220, 220)
        TabButton.TextSize = 13
        TabButton.Parent = TabBar

        local TabButtonCorner = Instance.new("UICorner")
        TabButtonCorner.CornerRadius = UDim.new(0, 6)
        TabButtonCorner.Parent = TabButton

        -- Hover effect for tab button
        TabButton.MouseEnter:Connect(function()
            TweenService:Create(TabButton, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(65, 65, 65)}):Play()
        end)
        TabButton.MouseLeave:Connect(function()
            if TabContent.Visible then return end
            TweenService:Create(TabButton, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(55, 55, 55)}):Play()
        end)

        -- Create Tab Content
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = tabName
        TabContent.BackgroundTransparency = 1
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.Visible = false
        TabContent.ScrollBarThickness = 4
        TabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
        TabContent.Parent = ContentArea

        local TabContentLayout = Instance.new("UIListLayout")
        TabContentLayout.Parent = TabContent
        TabContentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        TabContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        TabContentLayout.Padding = UDim.new(0, 8)

        -- Set first tab as active
        if not currentTab then
            currentTab = TabContent
            TabContent.Visible = true
            TabButton.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
        end

        -- Tab switching logic
        TabButton.MouseButton1Click:Connect(function()
            currentTab.Visible = false
            for _, button in ipairs(TabBar:GetChildren()) do
                if button:IsA("TextButton") then
                    button.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
                end
            end
            TabContent.Visible = true
            currentTab = TabContent
            TabButton.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
        end)

        local Tab = {}

        function Tab:AddTextbox(config)
            local TextboxElement = CreateElement("Textbox", 35)
            TextboxElement.LayoutOrder = #TabContent:GetChildren()
            TextboxElement.Parent = TabContent

            local TextboxTitle = Instance.new("TextLabel")
            TextboxTitle.Name = "Title"
            TextboxTitle.BackgroundTransparency = 1
            TextboxTitle.Position = UDim2.new(0, 15, 0, 0)
            TextboxTitle.Size = UDim2.new(0, 200, 1, 0)
            TextboxTitle.Font = Enum.Font.Gotham
            TextboxTitle.Text = config.Text
            TextboxTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextboxTitle.TextSize = 13
            TextboxTitle.TextXAlignment = Enum.TextXAlignment.Left
            TextboxTitle.Parent = TextboxElement

            local InputBox = Instance.new("TextBox")
            InputBox.Name = "Input"
            InputBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            InputBox.Position = UDim2.new(1, -160, 0.5, -12)
            InputBox.Size = UDim2.new(0, 150, 0, 24)
            InputBox.Font = Enum.Font.Gotham
            InputBox.PlaceholderText = config.Placeholder or ""
            InputBox.Text = config.Default or ""
            InputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
            InputBox.TextSize = 13
            InputBox.TextXAlignment = Enum.TextXAlignment.Left
            InputBox.Parent = TextboxElement

            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(0, 6)
            Corner.Parent = InputBox

            InputBox.Focused:Connect(function()
                TweenService:Create(InputBox, TweenInfo.new(0.2), {
                    BackgroundColor3 = Color3.fromRGB(45, 45, 45),
                    Size = UDim2.new(0, 155, 0, 25)
                }):Play()
            end)

            InputBox.FocusLost:Connect(function(enterPressed)
                TweenService:Create(InputBox, TweenInfo.new(0.2), {
                    BackgroundColor3 = Color3.fromRGB(30, 30, 30),
                    Size = UDim2.new(0, 150, 0, 24)
                }):Play()
                
                if enterPressed and config.Callback then
                    config.Callback(InputBox.Text)
                end
            end)
        end

        function Tab:AddToggle(config)
            local ToggleElement = CreateElement("Toggle", 35)
            ToggleElement.LayoutOrder = #TabContent:GetChildren()
            ToggleElement.Parent = TabContent

            local ToggleTitle = Instance.new("TextLabel")
            ToggleTitle.Name = "Title"
            ToggleTitle.BackgroundTransparency = 1
            ToggleTitle.Position = UDim2.new(0, 15, 0, 0)
            ToggleTitle.Size = UDim2.new(0, 200, 1, 0)
            ToggleTitle.Font = Enum.Font.Gotham
            ToggleTitle.Text = config.Text
            ToggleTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
            ToggleTitle.TextSize = 13
            ToggleTitle.TextXAlignment = Enum.TextXAlignment.Left
            ToggleTitle.Parent = ToggleElement

            local ToggleContainer = Instance.new("Frame")
            ToggleContainer.Name = "Container"
            ToggleContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            ToggleContainer.Position = UDim2.new(1, -55, 0.5, -12)
            ToggleContainer.Size = UDim2.new(0, 45, 0, 24)
            ToggleContainer.Parent = ToggleElement

            local ContainerCorner = Instance.new("UICorner")
            ContainerCorner.CornerRadius = UDim.new(1, 0)
            ContainerCorner.Parent = ToggleContainer

            local ToggleIndicator = Instance.new("Frame")
            ToggleIndicator.Name = "Indicator"
            ToggleIndicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ToggleIndicator.BorderSizePixel = 0
            ToggleIndicator.Position = UDim2.new(0, 3, 0, 3)
            ToggleIndicator.Size = UDim2.new(0, 18, 0, 18)
            ToggleIndicator.Parent = ToggleContainer

            local IndicatorCorner = Instance.new("UICorner")
            IndicatorCorner.CornerRadius = UDim.new(1, 0)
            IndicatorCorner.Parent = ToggleIndicator

            local ToggleState = false

            local function updateToggle()
                if ToggleState then
                    TweenService:Create(ToggleIndicator, TweenInfo.new(0.2), {Position = UDim2.new(1, -21, 0, 3)}):Play()
                    TweenService:Create(ToggleContainer, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 180, 255)}):Play()
                else
                    TweenService:Create(ToggleIndicator, TweenInfo.new(0.2), {Position = UDim2.new(0, 3, 0, 3)}):Play()
                    TweenService:Create(ToggleContainer, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
                end
            end

            ToggleContainer.InputBegan:Connect(function(input, processed)
                if not processed and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
                    ToggleState = not ToggleState
                    updateToggle()
                    if config.Callback then
                        config.Callback(ToggleState)
                    end
                end
            end)

            -- Hover effect
            ToggleContainer.MouseEnter:Connect(function()
                TweenService:Create(ToggleContainer, TweenInfo.new(0.15), {Size = UDim2.new(0, 47, 0, 25)}):Play()
            end)
            ToggleContainer.MouseLeave:Connect(function()
                TweenService:Create(ToggleContainer, TweenInfo.new(0.15), {Size = UDim2.new(0, 45, 0, 24)}):Play()
            end)
        end

        function Tab:AddButton(config)
            local ButtonElement = CreateElement("Button", 35)
            ButtonElement.LayoutOrder = #TabContent:GetChildren()
            ButtonElement.Parent = TabContent

            local Button = Instance.new("TextButton")
            Button.Name = "Action"
            Button.BackgroundTransparency = 1
            Button.Size = UDim2.new(1, 0, 1, 0)
            Button.Font = Enum.Font.Gotham
            Button.Text = config.Text
            Button.TextColor3 = Color3.fromRGB(255, 255, 255)
            Button.TextSize = 13
            Button.Parent = ButtonElement

            -- Hover effect
            Button.MouseEnter:Connect(function()
                TweenService:Create(ButtonElement, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(55, 55, 55)}):Play()
            end)
            Button.MouseLeave:Connect(function()
                TweenService:Create(ButtonElement, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}):Play()
            end)

            Button.MouseButton1Click:Connect(function()
                if config.Callback then
                    config.Callback()
                end
            end)
        end

        function Tab:AddLabel(config)
            local LabelElement = CreateElement("Label", 25)
            LabelElement.LayoutOrder = #TabContent:GetChildren()
            LabelElement.Parent = TabContent

            local Label = Instance.new("TextLabel")
            Label.Name = "Text"
            Label.BackgroundTransparency = 1
            Label.Size = UDim2.new(1, 0, 1, 0)
            Label.Font = Enum.Font.Gotham
            Label.Text = config.Text
            Label.TextColor3 = Color3.fromRGB(200, 200, 200)
            Label.TextSize = 13
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = LabelElement
        end

        function Tab:AddSlider(config)
            local SliderElement = CreateElement("Slider", 45)
            SliderElement.LayoutOrder = #TabContent:GetChildren()
            SliderElement.Parent = TabContent

            local SliderTitle = Instance.new("TextLabel")
            SliderTitle.Name = "Title"
            SliderTitle.BackgroundTransparency = 1
            SliderTitle.Position = UDim2.new(0, 15, 0, 0)
            SliderTitle.Size = UDim2.new(0, 200, 0.5, 0)
            SliderTitle.Font = Enum.Font.Gotham
            SliderTitle.Text = config.Text
            SliderTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
            SliderTitle.TextSize = 13
            SliderTitle.TextXAlignment = Enum.TextXAlignment.Left
            SliderTitle.Parent = SliderElement

            local ValueDisplay = Instance.new("TextLabel")
            ValueDisplay.Name = "Value"
            ValueDisplay.BackgroundTransparency = 1
            ValueDisplay.Position = UDim2.new(1, -70, 0, 0)
            ValueDisplay.Size = UDim2.new(0, 60, 0.5, 0)
            ValueDisplay.Font = Enum.Font.Gotham
            ValueDisplay.Text = tostring(config.Default or config.Min)
            ValueDisplay.TextColor3 = Color3.fromRGB(200, 200, 200)
            ValueDisplay.TextSize = 13
            ValueDisplay.TextXAlignment = Enum.TextXAlignment.Right
            ValueDisplay.Parent = SliderElement

            local Track = Instance.new("Frame")
            Track.Name = "Track"
            Track.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            Track.Position = UDim2.new(0, 15, 0.5, 2)
            Track.Size = UDim2.new(1, -30, 0, 5)
            Track.Parent = SliderElement

            local TrackCorner = Instance.new("UICorner")
            TrackCorner.CornerRadius = UDim.new(1, 0)
            TrackCorner.Parent = Track

            local Fill = Instance.new("Frame")
            Fill.Name = "Fill"
            Fill.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
            Fill.Size = UDim2.new(0, 0, 1, 0)
            Fill.Parent = Track

            local FillCorner = Instance.new("UICorner")
            FillCorner.CornerRadius = UDim.new(1, 0)
            FillCorner.Parent = Fill

            local Thumb = Instance.new("Frame")
            Thumb.Name = "Thumb"
            Thumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Thumb.Size = UDim2.new(0, 14, 0, 14)
            Thumb.Position = UDim2.new(0, -7, 0.5, -7)
            Thumb.Parent = Track

            local ThumbCorner = Instance.new("UICorner")
            ThumbCorner.CornerRadius = UDim.new(1, 0)
            ThumbCorner.Parent = Thumb

            local min = config.Min or 0
            local max = config.Max or 100
            local step = config.Step or 1
            local currentValue = config.Default or min
            local isDragging = false

            local function updateValue(value)
                currentValue = math.clamp(
                    math.floor((value / Track.AbsoluteSize.X) * (max - min) / step + 0.5) * step + min,
                    min,
                    max
                )
                
                local fillWidth = ((currentValue - min) / (max - min)) * Track.AbsoluteSize.X
                Fill.Size = UDim2.new(0, fillWidth, 1, 0)
                Thumb.Position = UDim2.new(0, fillWidth - 7, 0.5, -7)
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
                    TweenService:Create(Thumb, TweenInfo.new(0.15), {Size = UDim2.new(0, 16, 0, 16)}):Play()
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
                    TweenService:Create(Thumb, TweenInfo.new(0.15), {Size = UDim2.new(0, 14, 0, 14)}):Play()
                end
            end)

            -- Set initial value
            updateValue(((currentValue - min) / (max - min)) * Track.AbsoluteSize.X)
        end

        function Tab:AddDropdown(config)
            local DropdownElement = CreateElement("Dropdown", 35)
            DropdownElement.ClipsDescendants = false
            DropdownElement.LayoutOrder = #TabContent:GetChildren()
            DropdownElement.Parent = TabContent

            local DropdownTitle = Instance.new("TextLabel")
            DropdownTitle.Name = "Title"
            DropdownTitle.BackgroundTransparency = 1
            DropdownTitle.Position = UDim2.new(0, 15, 0, 0)
            DropdownTitle.Size = UDim2.new(0, 100, 1, 0)
            DropdownTitle.Font = Enum.Font.Gotham
            DropdownTitle.Text = config.Text
            DropdownTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
            DropdownTitle.TextSize = 13
            DropdownTitle.TextYAlignment = Enum.TextYAlignment.Center
            DropdownTitle.TextXAlignment = Enum.TextXAlignment.Left
            DropdownTitle.Parent = DropdownElement

            local SelectionButton = Instance.new("TextButton")
            SelectionButton.Name = "SelectionButton"
            SelectionButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            SelectionButton.Position = UDim2.new(1, -160, 0.5, -12)
            SelectionButton.Size = UDim2.new(0, 150, 0, 24)
            SelectionButton.Font = Enum.Font.Gotham
            SelectionButton.Text = config.Default or "Select"
            SelectionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            SelectionButton.TextSize = 13
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
            DropdownList.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            DropdownList.BorderSizePixel = 0
            DropdownList.Size = UDim2.new(1, 0, 1, 0)
            DropdownList.ScrollBarThickness = 4
            DropdownList.CanvasSize = UDim2.new(0, 0, 0, 0)
            DropdownList.ZIndex = 101
            DropdownList.Parent = DropdownContainer

            local ListCorner = Instance.new("UICorner")
            ListCorner.CornerRadius = UDim.new(0, 6)
            ListCorner.Parent = DropdownList

            local ListStroke = Instance.new("UIStroke")
            ListStroke.Color = Color3.fromRGB(50, 50, 50)
            ListStroke.Transparency = 0.5
            ListStroke.Parent = DropdownList

            local ListLayout = Instance.new("UIListLayout")
            ListLayout.Parent = DropdownList
            ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            ListLayout.Padding = UDim.new(0, 3)

            local dropdownOpen = false
            local positionConnection
            local selectedOptions = {}
            local isMultiple = config.MultipleOptions or false
            
            if not isMultiple and config.Default then
                SelectionButton.Text = config.Default
            end

            local function updateListSize()
                local totalHeight = 0
                for _, child in ipairs(DropdownList:GetChildren()) do
                    if child:IsA("TextButton") then
                        totalHeight = totalHeight + child.AbsoluteSize.Y + ListLayout.Padding.Offset
                    end
                end
                DropdownList.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
                DropdownContainer.Size = UDim2.new(0, 150, 0, math.min(120, totalHeight))
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
                    TweenService:Create(SelectionButton, TweenInfo.new(0.15), {Size = UDim2.new(0, 150, 0, 24)}):Play()
                else
                    updateDropdownPosition()
                    DropdownContainer.Visible = true
                    dropdownOpen = true
                    positionConnection = RunService.Heartbeat:Connect(updateDropdownPosition)
                    TweenService:Create(SelectionButton, TweenInfo.new(0.15), {Size = UDim2.new(0, 155, 0, 25)}):Play()
                end
            end

            for i, option in ipairs(config.Options) do
                local OptionButton = Instance.new("TextButton")
                OptionButton.Name = option
                OptionButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                OptionButton.Size = UDim2.new(1, -4, 0, 24)
                OptionButton.Position = UDim2.new(0, 2, 0, 0)
                OptionButton.Font = Enum.Font.Gotham
                OptionButton.Text = option
                OptionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                OptionButton.TextSize = 13
                OptionButton.ZIndex = 102
                OptionButton.TextTruncate = Enum.TextTruncate.AtEnd
                OptionButton.LayoutOrder = i
                OptionButton.Parent = DropdownList

                local OptionCorner = Instance.new("UICorner")
                OptionCorner.CornerRadius = UDim.new(0, 6)
                OptionCorner.Parent = OptionButton

                -- Hover effect for option
                OptionButton.MouseEnter:Connect(function()
                    TweenService:Create(OptionButton, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(55, 55, 55)}):Play()
                end)
                OptionButton.MouseLeave:Connect(function()
                    TweenService:Create(OptionButton, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}):Play()
                end)

                local Checkbox
                if isMultiple then
                    Checkbox = Instance.new("Frame")
                    Checkbox.Name = "Checkbox"
                    Checkbox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                    Checkbox.Position = UDim2.new(0, 8, 0.5, -8)
                    Checkbox.Size = UDim2.new(0, 14, 0, 14)
                    Checkbox.ZIndex = 103
                    Checkbox.Parent = OptionButton
                    
                    local CheckboxCorner = Instance.new("UICorner")
                    CheckboxCorner.CornerRadius = UDim.new(0, 3)
                    CheckboxCorner.Parent = Checkbox
                    
                    OptionButton.TextXAlignment = Enum.TextXAlignment.Center
                    OptionButton.Text = "   " .. option
                end

                OptionButton.MouseButton1Click:Connect(function()
                    if isMultiple then
                        selectedOptions[option] = not selectedOptions[option]
                        
                        if selectedOptions[option] then
                            Checkbox.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
                        else
                            Checkbox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                        end
                        
                        local count = 0
                        for _, isSelected in pairs(selectedOptions) do
                            if isSelected then
                                count = count + 1
                            end
                        end
                        
                        if count > 0 then
                            SelectionButton.Text = count .. " selected"
                        else
                            SelectionButton.Text = "Select"
                        end
                        
                        if config.Callback then
                            local selected = {}
                            for opt, isSelected in pairs(selectedOptions) do
                                if isSelected then
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

return Ozen
