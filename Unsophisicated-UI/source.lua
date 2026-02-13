-- Unsophisicated UI
-- A simple Roblox UI library inspired by Ozen UI
-- Elements: Button, Toggle, Slider

local Unsophisicated = {}

function Unsophisicated:CreateWindow(name)
    local UserInputService = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")
    local TextService = game:GetService("TextService")
    local RunService = game:GetService("RunService")
    
    -- Main GUI
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "UnsophisicatedUI"
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
        TabButton.Size = UDim2.new(0, TextService:GetTextSize(tabName, 12, Enum.Font.Gotham, Vector2.new(0, 0)).X + 20, 0, 25)
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

        function Tab:AddButton(config)
            -- config: {Text = "Button", Callback = function() end}
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

        function Tab:AddToggle(config)
            -- config: {Text = "Toggle", Default = false, Callback = function(state) end}
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

            -- Pill shape
            local ContainerCorner = Instance.new("UICorner")
            ContainerCorner.CornerRadius = UDim.new(1, 0)
            ContainerCorner.Parent = ToggleContainer

            local ToggleIndicator = Instance.new("Frame")
            ToggleIndicator.Name = "Indicator"
            ToggleIndicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ToggleIndicator.BorderSizePixel = 0
            ToggleIndicator.Position = UDim2.new(0, 2, 0, 2)
            ToggleIndicator.Size = UDim2.new(0, 16, 0, 16)
            ToggleIndicator.Parent = ToggleContainer

            local IndicatorCorner = Instance.new("UICorner")
            IndicatorCorner.CornerRadius = UDim.new(1, 0)
            IndicatorCorner.Parent = ToggleIndicator

            local ToggleState = config.Default or false

            local function updateToggle()
                if ToggleState then
                    TweenService:Create(ToggleIndicator, TweenInfo.new(0.2), {Position = UDim2.new(1, -18, 0, 2)}):Play()
                    TweenService:Create(ToggleContainer, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 170, 255)}):Play()
                else
                    TweenService:Create(ToggleIndicator, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0, 2)}):Play()
                    TweenService:Create(ToggleContainer, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
                end
            end

            -- Set initial state
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
            -- config: {Text = "Slider", Min = 0, Max = 100, Default = 50, Step = 1, Callback = function(value) end}
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

            local function updateValue(inputPos)
                local trackSize = Track.AbsoluteSize.X
                if trackSize == 0 then return end
                local relativePos = math.clamp(inputPos, 0, trackSize)
                local valueRange = max - min
                local rawValue = min + (relativePos / trackSize) * valueRange
                -- Snap to step
                currentValue = math.floor((rawValue - min) / step + 0.5) * step + min
                currentValue = math.clamp(currentValue, min, max)

                local fillWidth = (currentValue - min) / valueRange * trackSize
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
            local initialFill = ((currentValue - min) / (max - min)) * Track.AbsoluteSize.X
            Fill.Size = UDim2.new(0, initialFill, 1, 0)
            Thumb.Position = UDim2.new(0, initialFill - 6, 0.5, -6)
        end

        return Tab
    end

    return Window
end

return Unsophisicated
