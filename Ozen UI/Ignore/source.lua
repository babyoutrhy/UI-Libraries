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
    MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
    MainFrame.Size = UDim2.new(0, 350, 0, 400)
    MainFrame.Parent = ScreenGui

    -- Title Bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    TitleBar.BorderSizePixel = 0
    TitleBar.Size = UDim2.new(1, 0, 0, 30)
    TitleBar.Parent = MainFrame

    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.Size = UDim2.new(0, 200, 1, 0)
    Title.Font = Enum.Font.Gotham
    Title.Text = name
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 14
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TitleBar

    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.BackgroundTransparency = 1
    CloseButton.Position = UDim2.new(1, -30, 0, 0)
    CloseButton.Size = UDim2.new(0, 30, 1, 0)
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Text = "X"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.TextSize = 14
    CloseButton.Parent = TitleBar

    -- Mobile-compatible drag functionality
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

    MainFrame.InputBegan:Connect(onInputBegan)
    TitleBar.InputBegan:Connect(onInputBegan)

    -- Tab System with Scrolling
    local TabBar = Instance.new("ScrollingFrame")
    TabBar.Name = "TabBar"
    TabBar.BackgroundTransparency = 1
    TabBar.Position = UDim2.new(0, 0, 0, 30)
    TabBar.Size = UDim2.new(1, 0, 0, 30)
    TabBar.ScrollBarThickness = 3
    TabBar.ScrollingDirection = Enum.ScrollingDirection.X
    TabBar.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Left
    TabBar.Parent = MainFrame

    local TabLayout = Instance.new("UIListLayout")
    TabLayout.Parent = TabBar
    TabLayout.FillDirection = Enum.FillDirection.Horizontal
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabLayout.Padding = UDim.new(0, 5)

    -- Content Area
    local ContentArea = Instance.new("Frame")
    ContentArea.Name = "ContentArea"
    ContentArea.BackgroundTransparency = 1
    ContentArea.Position = UDim2.new(0, 10, 0, 70)
    ContentArea.Size = UDim2.new(1, -20, 1, -80)
    ContentArea.Parent = MainFrame

    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    local function CreateElement(name, height)
        local Element = Instance.new("Frame")
        Element.Name = name
        Element.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        Element.BorderSizePixel = 0
        Element.Size = UDim2.new(1, 0, 0, height)
        
        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 4)
        Corner.Parent = Element
        
        return Element
    end

    local Window = {}
    local currentTab = nil

    TabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabBar.CanvasSize = UDim2.new(0, TabLayout.AbsoluteContentSize.X + 10, 0, 0)
    end)

    function Window:AddTab(tabName)
        -- Create Tab Button
        local TabButton = Instance.new("TextButton")
        TabButton.Name = tabName
        TabButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        TabButton.Size = UDim2.new(0, textService:GetTextSize(tabName, 12, Enum.Font.Gotham, Vector2.new(0, 0)).X + 20, 0, 25)
        TabButton.Font = Enum.Font.Gotham
        TabButton.Text = tabName
        TabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
        TabButton.TextSize = 12
        TabButton.Parent = TabBar

        -- Create Tab Content
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = tabName
        TabContent.BackgroundTransparency = 1
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.Visible = false
        TabContent.ScrollBarThickness = 5
        TabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
        TabContent.Parent = ContentArea

        local TabContentLayout = Instance.new("UIListLayout")
        TabContentLayout.Parent = TabContent
        TabContentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        TabContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        TabContentLayout.Padding = UDim.new(0, 5)

        -- Set first tab as active
        if not currentTab then
            currentTab = TabContent
            TabContent.Visible = true
            TabButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
        end

        -- Tab switching logic
        TabButton.MouseButton1Click:Connect(function()
            currentTab.Visible = false
            for _, button in ipairs(TabBar:GetChildren()) do
                if button:IsA("TextButton") then
                    button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                end
            end
            TabContent.Visible = true
            currentTab = TabContent
            TabButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
        end)

        local Tab = {}

function Tab:AddTextbox(config)
    local TextboxElement = CreateElement("Textbox", 30)
    TextboxElement.LayoutOrder = #TabContent:GetChildren()
    TextboxElement.Parent = TabContent

    local TextboxTitle = Instance.new("TextLabel")
    TextboxTitle.Name = "Title"
    TextboxTitle.BackgroundTransparency = 1
    TextboxTitle.Position = UDim2.new(0, 10, 0, 0)
    TextboxTitle.Size = UDim2.new(0, 200, 1, 0)
    TextboxTitle.Font = Enum.Font.Gotham
    TextboxTitle.Text = config.Text
    TextboxTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextboxTitle.TextSize = 12
    TextboxTitle.TextXAlignment = Enum.TextXAlignment.Left
    TextboxTitle.Parent = TextboxElement

    local InputBox = Instance.new("TextBox")
    InputBox.Name = "Input"
    InputBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    InputBox.Position = UDim2.new(1, -150, 0.5, -10)
    InputBox.Size = UDim2.new(0, 140, 0, 20)
    InputBox.Font = Enum.Font.Gotham
    InputBox.PlaceholderText = config.Placeholder or ""
    InputBox.Text = config.Default or ""
    InputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    InputBox.TextSize = 12
    InputBox.TextXAlignment = Enum.TextXAlignment.Left
    InputBox.Parent = TextboxElement

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 4)
    Corner.Parent = InputBox

    InputBox.Focused:Connect(function()
        TweenService:Create(InputBox, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        }):Play()
    end)

    InputBox.FocusLost:Connect(function(enterPressed)
        TweenService:Create(InputBox, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        }):Play()
        
        if enterPressed and config.Callback then
            config.Callback(InputBox.Text)
        end
    end)
end

function Tab:AddToggle(config)
    local ToggleElement = CreateElement("Toggle", 30)
    ToggleElement.LayoutOrder = #TabContent:GetChildren()
    ToggleElement.Parent = TabContent

    local ToggleTitle = Instance.new("TextLabel")
    ToggleTitle.Name = "Title"
    ToggleTitle.BackgroundTransparency = 1
    ToggleTitle.Position = UDim2.new(0, 10, 0, 0)
    ToggleTitle.Size = UDim2.new(0, 200, 1, 0)
    ToggleTitle.Font = Enum.Font.Gotham
    ToggleTitle.Text = config.Text
    ToggleTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleTitle.TextSize = 12
    ToggleTitle.TextXAlignment = Enum.TextXAlignment.Left
    ToggleTitle.Parent = ToggleElement

    local ToggleContainer = Instance.new("Frame")
    ToggleContainer.Name = "Container"
    ToggleContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    ToggleContainer.Position = UDim2.new(1, -50, 0.5, -10)
    ToggleContainer.Size = UDim2.new(0, 40, 0, 20)
    ToggleContainer.Parent = ToggleElement

    -- Add UICorner to the toggle container (pill shape)
    local ContainerCorner = Instance.new("UICorner")
    ContainerCorner.CornerRadius = UDim.new(1, 0) -- Fully rounded ends
    ContainerCorner.Parent = ToggleContainer

    local ToggleIndicator = Instance.new("Frame")
    ToggleIndicator.Name = "Indicator"
    ToggleIndicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ToggleIndicator.BorderSizePixel = 0
    ToggleIndicator.Position = UDim2.new(0, 2, 0, 2)
    ToggleIndicator.Size = UDim2.new(0, 16, 0, 16)
    ToggleIndicator.Parent = ToggleContainer

    -- Add UICorner to the indicator (circle)
    local IndicatorCorner = Instance.new("UICorner")
    IndicatorCorner.CornerRadius = UDim.new(1, 0)
    IndicatorCorner.Parent = ToggleIndicator

    -- Rest of the toggle logic remains unchanged...
    local ToggleState = false

    local function updateToggle()
        if ToggleState then
            TweenService:Create(ToggleIndicator, TweenInfo.new(0.2), {Position = UDim2.new(1, -18, 0, 2)}):Play()
            TweenService:Create(ToggleContainer, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 170, 255)}):Play()
        else
            TweenService:Create(ToggleIndicator, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0, 2)}):Play()
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
end

function Tab:AddButton(config)
    local ButtonElement = CreateElement("Button", 30)
    ButtonElement.LayoutOrder = #TabContent:GetChildren()
    ButtonElement.Parent = TabContent

    local Button = Instance.new("TextButton")
    Button.Name = "Action"
    Button.BackgroundTransparency = 1
    Button.Size = UDim2.new(1, 0, 1, 0)
    Button.Font = Enum.Font.Gotham
    Button.Text = config.Text
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 12
    Button.Parent = ButtonElement

    Button.MouseButton1Click:Connect(function()
        if config.Callback then
            config.Callback()
        end
    end)
end

function Tab:AddLabel(config)
    local LabelElement = CreateElement("Label", 20)
    LabelElement.LayoutOrder = #TabContent:GetChildren()
    LabelElement.Parent = TabContent

    local Label = Instance.new("TextLabel")
    Label.Name = "Text"
    Label.BackgroundTransparency = 1
    Label.Size = UDim2.new(1, 0, 1, 0)
    Label.Font = Enum.Font.Gotham
    Label.Text = config.Text
    Label.TextColor3 = Color3.fromRGB(200, 200, 200)
    Label.TextSize = 12
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = LabelElement
end

function Tab:AddSlider(config)
    local SliderElement = CreateElement("Slider", 40)
    SliderElement.LayoutOrder = #TabContent:GetChildren()
    SliderElement.Parent = TabContent

    local SliderTitle = Instance.new("TextLabel")
    SliderTitle.Name = "Title"
    SliderTitle.BackgroundTransparency = 1
    SliderTitle.Position = UDim2.new(0, 10, 0, 0)
    SliderTitle.Size = UDim2.new(0, 200, 0.5, 0)
    SliderTitle.Font = Enum.Font.Gotham
    SliderTitle.Text = config.Text
    SliderTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    SliderTitle.TextSize = 12
    SliderTitle.TextXAlignment = Enum.TextXAlignment.Left
    SliderTitle.Parent = SliderElement

    local ValueDisplay = Instance.new("TextLabel")
    ValueDisplay.Name = "Value"
    ValueDisplay.BackgroundTransparency = 1
    ValueDisplay.Position = UDim2.new(1, -60, 0, 0)
    ValueDisplay.Size = UDim2.new(0, 50, 0.5, 0)
    ValueDisplay.Font = Enum.Font.Gotham
    ValueDisplay.Text = tostring(config.Default or config.Min)
    ValueDisplay.TextColor3 = Color3.fromRGB(200, 200, 200)
    ValueDisplay.TextSize = 12
    ValueDisplay.TextXAlignment = Enum.TextXAlignment.Right
    ValueDisplay.Parent = SliderElement

    local Track = Instance.new("Frame")
    Track.Name = "Track"
    Track.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Track.Position = UDim2.new(0, 10, 0.5, 0)
    Track.Size = UDim2.new(1, -20, 0, 4)
    Track.Parent = SliderElement

    local Fill = Instance.new("Frame")
    Fill.Name = "Fill"
    Fill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    Fill.Size = UDim2.new(0, 0, 1, 0)
    Fill.Parent = Track

    local Thumb = Instance.new("Frame")
    Thumb.Name = "Thumb"
    Thumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Thumb.Size = UDim2.new(0, 12, 0, 12)
    Thumb.Position = UDim2.new(0, -6, 0.5, -6)
    Thumb.Parent = Track

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(1, 0)
    Corner.Parent = Thumb

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
        Thumb.Position = UDim2.new(0, fillWidth - 6, 0.5, -6)
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
    updateValue(((currentValue - min) / (max - min)) * Track.AbsoluteSize.X)
end

function Tab:AddDropdown(config)
    local DropdownElement = CreateElement("Dropdown", 30)
    DropdownElement.ClipsDescendants = false
    DropdownElement.LayoutOrder = #TabContent:GetChildren()
    DropdownElement.Parent = TabContent

    -- Title on left (centered vertically)
    local DropdownTitle = Instance.new("TextLabel")
    DropdownTitle.Name = "Title"
    DropdownTitle.BackgroundTransparency = 1
    DropdownTitle.Position = UDim2.new(0, 10, 0, 0)
    DropdownTitle.Size = UDim2.new(0, 100, 1, 0)
    DropdownTitle.Font = Enum.Font.Gotham
    DropdownTitle.Text = config.Text
    DropdownTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    DropdownTitle.TextSize = 12
    DropdownTitle.TextYAlignment = Enum.TextYAlignment.Center
    DropdownTitle.TextXAlignment = Enum.TextXAlignment.Left
    DropdownTitle.Parent = DropdownElement

    -- Selection button on right
    local SelectionButton = Instance.new("TextButton")
    SelectionButton.Name = "SelectionButton"
    SelectionButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    SelectionButton.Position = UDim2.new(1, -150, 0.5, -10)
    SelectionButton.Size = UDim2.new(0, 140, 0, 20)
    SelectionButton.Font = Enum.Font.Gotham
    SelectionButton.Text = config.Default or "Select"
    SelectionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    SelectionButton.TextSize = 12
    SelectionButton.Parent = DropdownElement

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 4)
    Corner.Parent = SelectionButton

    -- Create dropdown container
    local DropdownContainer = Instance.new("Frame")
    DropdownContainer.Name = "DropdownContainer"
    DropdownContainer.BackgroundTransparency = 1
    DropdownContainer.Size = UDim2.new(0, 140, 0, 0)
    DropdownContainer.Visible = false
    DropdownContainer.ZIndex = 100
    DropdownContainer.Parent = ScreenGui  -- Parent to top-level ScreenGui

    local DropdownList = Instance.new("ScrollingFrame")
    DropdownList.Name = "DropdownList"
    DropdownList.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    DropdownList.BorderSizePixel = 0
    DropdownList.Size = UDim2.new(1, 0, 1, 0)
    DropdownList.ScrollBarThickness = 5
    DropdownList.CanvasSize = UDim2.new(0, 0, 0, 0)
    DropdownList.ZIndex = 101
    DropdownList.Parent = DropdownContainer

    local Corner2 = Instance.new("UICorner")
    Corner2.CornerRadius = UDim.new(0, 4)
    Corner2.Parent = DropdownList

    local ListLayout = Instance.new("UIListLayout")
    ListLayout.Parent = DropdownList
    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ListLayout.Padding = UDim.new(0, 2)

    -- Create dropdown state
    local dropdownOpen = false
    local positionConnection
    
    local function updateListSize()
        local totalHeight = 0
        for _, child in ipairs(DropdownList:GetChildren()) do
            if child:IsA("TextButton") then
                totalHeight = totalHeight + child.AbsoluteSize.Y + ListLayout.Padding.Offset
            end
        end
        DropdownList.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
        DropdownContainer.Size = UDim2.new(0, 140, 0, math.min(100, totalHeight))
    end

    -- Update dropdown position to stick below button
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
            -- Close dropdown
            DropdownContainer.Visible = false
            dropdownOpen = false
            
            -- Disconnect position updater
            if positionConnection then
                positionConnection:Disconnect()
                positionConnection = nil
            end
        else
            -- Open dropdown
            updateDropdownPosition()
            DropdownContainer.Visible = true
            dropdownOpen = true
            
            -- Update position continuously
            positionConnection = RunService.Heartbeat:Connect(updateDropdownPosition)
        end
    end

    -- Create option buttons
    for i, option in ipairs(config.Options) do
        local OptionButton = Instance.new("TextButton")
        OptionButton.Name = option
        OptionButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        OptionButton.Size = UDim2.new(1, -4, 0, 20)
        OptionButton.Position = UDim2.new(0, 2, 0, 0)
        OptionButton.Font = Enum.Font.Gotham
        OptionButton.Text = option
        OptionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        OptionButton.TextSize = 12
        OptionButton.ZIndex = 102
        OptionButton.TextTruncate = Enum.TextTruncate.AtEnd
        OptionButton.LayoutOrder = i
        OptionButton.Parent = DropdownList

        local OptionCorner = Instance.new("UICorner")
        OptionCorner.CornerRadius = UDim.new(0, 4)
        OptionCorner.Parent = OptionButton

        OptionButton.MouseButton1Click:Connect(function()
            SelectionButton.Text = option
            toggleDropdown()
            if config.Callback then
                config.Callback(option)
            end
        end)
    end

    ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateListSize)
    updateListSize()

    SelectionButton.MouseButton1Click:Connect(toggleDropdown)
    
    -- Cleanup when element is destroyed
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
