local Neutron = {}
Neutron.__index = Neutron

-- Theme definitions
Neutron.Themes = {
    SeaTheme = {
        Main = Color3.fromRGB(0, 102, 204),
        Secondary = Color3.fromRGB(0, 76, 153),
        Text = Color3.fromRGB(240, 240, 240),
        Background = Color3.fromRGB(40, 40, 50),
        Hover = Color3.fromRGB(0, 122, 204)
    },
    DarkTheme = {
        Main = Color3.fromRGB(30, 30, 30),
        Secondary = Color3.fromRGB(20, 20, 20),
        Text = Color3.fromRGB(220, 220, 220),
        Background = Color3.fromRGB(15, 15, 15),
        Hover = Color3.fromRGB(50, 50, 50)
    },
    GrapeTheme = {
        Main = Color3.fromRGB(106, 13, 173),
        Secondary = Color3.fromRGB(74, 20, 140),
        Text = Color3.fromRGB(240, 240, 240),
        Background = Color3.fromRGB(40, 30, 60),
        Hover = Color3.fromRGB(126, 33, 193)
    },
    FireTheme = {
        Main = Color3.fromRGB(220, 80, 20),
        Secondary = Color3.fromRGB(180, 60, 10),
        Text = Color3.fromRGB(240, 240, 240),
        Background = Color3.fromRGB(50, 35, 30),
        Hover = Color3.fromRGB(240, 100, 40)
    },
    ForestTheme = {
        Main = Color3.fromRGB(24, 130, 70),
        Secondary = Color3.fromRGB(19, 90, 47),
        Text = Color3.fromRGB(240, 240, 240),
        Background = Color3.fromRGB(30, 40, 35),
        Hover = Color3.fromRGB(34, 150, 90)
    }
}

function Neutron.new(options)
    local self = setmetatable({}, Neutron)
    
    -- Default options
    self.options = options or {}
    self.theme = options.Theme or "DarkTheme"
    self.name = options.Name or "Neutron UI"
    self.tabs = {}
    self.currentTab = nil
    
    -- Check if on mobile
    self.isMobile = (game:GetService("UserInputService").TouchEnabled and not game:GetService("UserInputService").KeyboardEnabled)
    
    -- Create the main UI container
    self:CreateUI()
    
    return self
end

function Neutron:CreateUI()
    -- Create ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "NeutronUI"
    screenGui.Parent = game:GetService("CoreGui")
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.ResetOnSpawn = false
    
    -- Adjust size based on device
    local width = self.isMobile and 400 or 450
    local height = self.isMobile and 400 or 350
    
    -- Main frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, width, 0, height)
    mainFrame.Position = UDim2.new(0.5, -width/2, 0.5, -height/2)
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    mainFrame.BackgroundColor3 = Neutron.Themes[self.theme].Background
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = mainFrame
    
    -- Title bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, self.isMobile and 40 or 30)
    titleBar.Position = UDim2.new(0, 0, 0, 0)
    titleBar.BackgroundColor3 = Neutron.Themes[self.theme].Main
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 8)
    titleCorner.Parent = titleBar
    
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, -50, 1, 0)
    title.Position = UDim2.new(0, 10, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = self.name
    title.TextColor3 = Neutron.Themes[self.theme].Text
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Font = Enum.Font.GothamBold
    title.TextSize = self.isMobile and 16 or 14
    title.Parent = titleBar
    
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, self.isMobile and 40 or 30, 0, self.isMobile and 40 or 30)
    closeButton.Position = UDim2.new(1, - (self.isMobile and 40 or 30), 0, 0)
    closeButton.BackgroundTransparency = 1
    closeButton.Text = "X"
    closeButton.TextColor3 = Neutron.Themes[self.theme].Text
    closeButton.Font = Enum.Font.GothamBold
    closeButton.TextSize = self.isMobile and 18 or 14
    closeButton.Parent = titleBar
    
    closeButton.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)
    
    -- Tab container
    local tabContainer = Instance.new("Frame")
    tabContainer.Name = "TabContainer"
    tabContainer.Size = UDim2.new(1, -20, 0, self.isMobile and 40 or 30)
    tabContainer.Position = UDim2.new(0, 10, 0, self.isMobile and 45 or 35)
    tabContainer.BackgroundTransparency = 1
    tabContainer.Parent = mainFrame
    
    local tabListLayout = Instance.new("UIListLayout")
    tabListLayout.Name = "TabListLayout"
    tabListLayout.FillDirection = Enum.FillDirection.Horizontal
    tabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabListLayout.Padding = UDim.new(0, 5)
    tabListLayout.Parent = tabContainer
    
    -- Content container
    local contentContainer = Instance.new("Frame")
    contentContainer.Name = "ContentContainer"
    contentContainer.Size = UDim2.new(1, -20, 1, - (self.isMobile and 90 or 70))
    contentContainer.Position = UDim2.new(0, 10, 0, self.isMobile and 90 or 70)
    contentContainer.BackgroundTransparency = 1
    contentContainer.ClipsDescendants = true
    contentContainer.Parent = mainFrame
    
    local contentListLayout = Instance.new("UIListLayout")
    contentListLayout.Name = "ContentListLayout"
    contentListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentListLayout.Padding = UDim.new(0, 8)
    contentListLayout.Parent = contentContainer
    
    self.screenGui = screenGui
    self.mainFrame = mainFrame
    self.tabContainer = tabContainer
    self.contentContainer = contentContainer
end

function Neutron:Tab(name)
    local tab = {}
    tab.name = name
    tab.elements = {}
    
    -- Create tab button
    local tabButton = Instance.new("TextButton")
    tabButton.Name = name .. "TabButton"
    tabButton.Size = UDim2.new(0, self.isMobile and 90 or 80, 1, 0)
    tabButton.BackgroundColor3 = Neutron.Themes[self.theme].Secondary
    tabButton.BorderSizePixel = 0
    tabButton.Text = name
    tabButton.TextColor3 = Neutron.Themes[self.theme].Text
    tabButton.Font = Enum.Font.Gotham
    tabButton.TextSize = self.isMobile and 14 or 12
    tabButton.Parent = self.tabContainer
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 5)
    corner.Parent = tabButton
    
    -- Create tab content
    local tabContent = Instance.new("ScrollingFrame")
    tabContent.Name = name .. "TabContent"
    tabContent.Size = UDim2.new(1, 0, 1, 0)
    tabContent.Position = UDim2.new(0, 0, 0, 0)
    tabContent.BackgroundTransparency = 1
    tabContent.BorderSizePixel = 0
    tabContent.ScrollBarThickness = 5
    tabContent.Visible = false
    tabContent.Parent = self.contentContainer
    
    local contentListLayout = Instance.new("UIListLayout")
    contentListLayout.Name = "ContentListLayout"
    contentListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentListLayout.Padding = UDim.new(0, 8)
    contentListLayout.Parent = tabContent
    
    contentListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tabContent.CanvasSize = UDim2.new(0, 0, 0, contentListLayout.AbsoluteContentSize.Y)
    end)
    
    tab.button = tabButton
    tab.content = tabContent
    
    -- Tab selection logic
    tabButton.MouseButton1Click:Connect(function()
        self:SelectTab(tab)
    end)
    
    -- Make this the first tab if none selected
    if not self.currentTab then
        self:SelectTab(tab)
    end
    
    table.insert(self.tabs, tab)
    
    return setmetatable(tab, {__index = self})
end

function Neutron:SelectTab(tab)
    -- Hide all tab contents
    for _, t in ipairs(self.tabs) do
        t.content.Visible = false
        t.button.BackgroundColor3 = Neutron.Themes[self.theme].Secondary
    end
    
    -- Show selected tab content
    tab.content.Visible = true
    tab.button.BackgroundColor3 = Neutron.Themes[self.theme].Main
    
    self.currentTab = tab
end

function Neutron:Button(name, callback)
    local button = Instance.new("TextButton")
    button.Name = name .. "Button"
    button.Size = UDim2.new(1, 0, 0, self.isMobile and 45 or 30)
    button.BackgroundColor3 = Neutron.Themes[self.theme].Secondary
    button.BorderSizePixel = 0
    button.Text = name
    button.TextColor3 = Neutron.Themes[self.theme].Text
    button.Font = Enum.Font.Gotham
    button.TextSize = self.isMobile and 14 or 12
    button.Parent = self.currentTab.content
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 5)
    corner.Parent = button
    
    -- Hover effect
    button.MouseEnter:Connect(function()
        game:GetService("TweenService"):Create(
            button,
            TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {BackgroundColor3 = Neutron.Themes[self.theme].Hover}
        ):Play()
    end)
    
    button.MouseLeave:Connect(function()
        game:GetService("TweenService"):Create(
            button,
            TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {BackgroundColor3 = Neutron.Themes[self.theme].Secondary}
        ):Play()
    end)
    
    button.MouseButton1Click:Connect(function()
        callback()
    end)
    
    -- Touch support for mobile
    if self.isMobile then
        local touchCount = 0
        button.TouchTap:Connect(function()
            touchCount += 1
            if touchCount == 1 then
                callback()
                task.wait(0.5)
                touchCount = 0
            end
        end)
    end
    
    return button
end

function Neutron:Toggle(name, default, callback)
    local toggle = {}
    toggle.value = default or false
    
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Name = name .. "Toggle"
    toggleFrame.Size = UDim2.new(1, 0, 0, self.isMobile and 45 or 30)
    toggleFrame.BackgroundTransparency = 1
    toggleFrame.Parent = self.currentTab.content
    
    local toggleLabel = Instance.new("TextLabel")
    toggleLabel.Name = "ToggleLabel"
    toggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
    toggleLabel.Position = UDim2.new(0, 0, 0, 0)
    toggleLabel.BackgroundTransparency = 1
    toggleLabel.Text = name
    toggleLabel.TextColor3 = Neutron.Themes[self.theme].Text
    toggleLabel.Font = Enum.Font.Gotham
    toggleLabel.TextSize = self.isMobile and 14 or 12
    toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    toggleLabel.Parent = toggleFrame
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Name = "ToggleButton"
    toggleButton.Size = UDim2.new(0, self.isMobile and 60 or 40, 0, self.isMobile and 30 or 20)
    toggleButton.Position = UDim2.new(1, - (self.isMobile and 60 or 40), 0.5, - (self.isMobile and 15 or 10))
    toggleButton.AnchorPoint = Vector2.new(1, 0.5)
    toggleButton.BackgroundColor3 = toggle.value and Neutron.Themes[self.theme].Main or Neutron.Themes[self.theme].Secondary
    toggleButton.BorderSizePixel = 0
    toggleButton.Text = ""
    toggleButton.Parent = toggleFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, self.isMobile and 15 or 10)
    corner.Parent = toggleButton
    
    local toggleKnob = Instance.new("Frame")
    toggleKnob.Name = "ToggleKnob"
    toggleKnob.Size = UDim2.new(0, self.isMobile and 24 or 16, 0, self.isMobile and 24 or 16)
    toggleKnob.Position = UDim2.new(0, toggle.value and (self.isMobile and 32 or 20) or (self.isMobile and 4 or 2), 0.5, - (self.isMobile and 12 or 8))
    toggleKnob.AnchorPoint = Vector2.new(0, 0.5)
    toggleKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    toggleKnob.BorderSizePixel = 0
    toggleKnob.Parent = toggleButton
    
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(0, self.isMobile and 12 or 8)
    knobCorner.Parent = toggleKnob
    
    local function updateToggle()
        -- Animate toggle
        game:GetService("TweenService"):Create(
            toggleKnob,
            TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Position = UDim2.new(0, toggle.value and (self.isMobile and 32 or 20) or (self.isMobile and 4 or 2), 0.5, - (self.isMobile and 12 or 8))}
        ):Play()
        
        game:GetService("TweenService"):Create(
            toggleButton,
            TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {BackgroundColor3 = toggle.value and Neutron.Themes[self.theme].Main or Neutron.Themes[self.theme].Secondary}
        ):Play()
        
        callback(toggle.value)
    end
    
    toggleButton.MouseButton1Click:Connect(function()
        toggle.value = not toggle.value
        updateToggle()
    end)
    
    -- Touch support for mobile
    if self.isMobile then
        toggleButton.TouchTap:Connect(function()
            toggle.value = not toggle.value
            updateToggle()
        end)
    end
    
    return toggle
end

function Neutron:Slider(name, options, callback)
    local slider = {}
    slider.min = options.min or 0
    slider.max = options.max or 100
    slider.value = options.default or slider.min
    slider.precise = options.precise or false
    
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Name = name .. "Slider"
    sliderFrame.Size = UDim2.new(1, 0, 0, self.isMobile and 70 or 50)
    sliderFrame.BackgroundTransparency = 1
    sliderFrame.Parent = self.currentTab.content
    
    local sliderLabel = Instance.new("TextLabel")
    sliderLabel.Name = "SliderLabel"
    sliderLabel.Size = UDim2.new(1, 0, 0, self.isMobile and 25 or 20)
    sliderLabel.Position = UDim2.new(0, 0, 0, 0)
    sliderLabel.BackgroundTransparency = 1
    sliderLabel.Text = name .. ": " .. tostring(slider.value)
    sliderLabel.TextColor3 = Neutron.Themes[self.theme].Text
    sliderLabel.Font = Enum.Font.Gotham
    sliderLabel.TextSize = self.isMobile and 14 or 12
    sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
    sliderLabel.Parent = sliderFrame
    
    local track = Instance.new("Frame")
    track.Name = "Track"
    track.Size = UDim2.new(1, 0, 0, self.isMobile and 10 or 5)
    track.Position = UDim2.new(0, 0, 0, self.isMobile and 40 or 30)
    track.BackgroundColor3 = Neutron.Themes[self.theme].Secondary
    track.BorderSizePixel = 0
    track.Parent = sliderFrame
    
    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(0, 3)
    trackCorner.Parent = track
    
    local fill = Instance.new("Frame")
    fill.Name = "Fill"
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.Position = UDim2.new(0, 0, 0, 0)
    fill.BackgroundColor3 = Neutron.Themes[self.theme].Main
    fill.BorderSizePixel = 0
    fill.Parent = track
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 3)
    fillCorner.Parent = fill
    
    local knob = Instance.new("TextButton")
    knob.Name = "Knob"
    knob.Size = UDim2.new(0, self.isMobile and 20 or 15, 0, self.isMobile and 20 or 15)
    knob.Position = UDim2.new(0, 0, 0.5, - (self.isMobile and 10 or 7.5))
    knob.AnchorPoint = Vector2.new(0, 0.5)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.BorderSizePixel = 0
    knob.Text = ""
    knob.Parent = track
    
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(0, self.isMobile and 10 or 7.5)
    knobCorner.Parent = knob
    
    -- Update slider display
    local function updateSlider(value)
        slider.value = math.clamp(value, slider.min, slider.max)
        local percentage = (slider.value - slider.min) / (slider.max - slider.min)
        
        fill.Size = UDim2.new(percentage, 0, 1, 0)
        knob.Position = UDim2.new(percentage, 0, 0.5, - (self.isMobile and 10 or 7.5))
        sliderLabel.Text = name .. ": " .. (slider.precise and string.format("%.2f", slider.value) or tostring(math.floor(slider.value)))
        
        callback(slider.value)
    end
    
    -- Initialize slider
    updateSlider(slider.value)
    
    -- Slider interaction
    local dragging = false
    
    local function updateFromInput(input)
        local relativeX = (input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X
        local value = slider.min + (relativeX * (slider.max - slider.min))
        updateSlider(value)
    end
    
    knob.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    track.MouseButton1Down:Connect(function(input)
        updateFromInput(input)
        dragging = true
    end)
    
    game:GetService("UserInputService").InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateFromInput(input)
        end
    end)
    
    -- Touch support for mobile
    if self.isMobile then
        knob.TouchStarted:Connect(function()
            dragging = true
        end)
        
        track.TouchStarted:Connect(function(input)
            updateFromInput(input)
            dragging = true
        end)
        
        game:GetService("UserInputService").TouchEnded:Connect(function(input)
            dragging = false
        end)
    end
    
    return slider
end

function Neutron:Label(text)
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(1, 0, 0, self.isMobile and 25 or 20)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Neutron.Themes[self.theme].Text
    label.Font = Enum.Font.Gotham
    label.TextSize = self.isMobile and 14 or 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = self.currentTab.content
    
    return label
end

return Neutron
