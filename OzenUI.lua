local Library = {}

function Library:CreateWindow(name)
    local UserInputService = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")
    local textService = game:GetService("TextService")
    
    -- Main GUI
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "LibraryUI"
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

    -- Auto-scroll to keep active tab visible
    local function ensureTabVisible(tabButton)
        local tabPosition = tabButton.AbsolutePosition.X
        local tabSize = tabButton.AbsoluteSize.X
        local viewportStart = TabBar.AbsolutePosition.X
        local viewportEnd = viewportStart + TabBar.AbsoluteSize.X
        
        if tabPosition < viewportStart then
            TabBar.CanvasPosition = Vector2.new(
                TabBar.CanvasPosition.X - (viewportStart - tabPosition) - 5,
                0
            )
        elseif tabPosition + tabSize > viewportEnd then
            TabBar.CanvasPosition = Vector2.new(
                TabBar.CanvasPosition.X + (tabPosition + tabSize - viewportEnd) + 5,
                0
            )
        end
    end

    -- Drag functionality
    local dragging, dragInput, dragStart, startPos

    local function update(input)
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
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

    TitleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)

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
            ensureTabVisible(TabButton)
        end)

        local Tab = {}
        
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

            local ToggleIndicator = Instance.new("Frame")
            ToggleIndicator.Name = "Indicator"
            ToggleIndicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ToggleIndicator.BorderSizePixel = 0
            ToggleIndicator.Position = UDim2.new(0, 2, 0, 2)
            ToggleIndicator.Size = UDim2.new(0, 16, 0, 16)
            ToggleIndicator.Parent = ToggleContainer

            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(1, 0)
            Corner.Parent = ToggleIndicator

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

            ToggleContainer.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
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

        return Tab
    end

    return Window
end

return Library
