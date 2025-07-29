local Neutron = {}
Neutron.__index = Neutron

-- Bootstrap Icons CDN
local ICON_CDN = "https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/icons/%s.png"

-- Theme Configuration
local THEME = {
    Primary = Color3.fromRGB(40, 40, 50),
    Secondary = Color3.fromRGB(30, 30, 40),
    Accent = Color3.fromRGB(100, 70, 200),
    Text = Color3.fromRGB(240, 240, 240),
    Border = Color3.fromRGB(60, 60, 70),
    ToggleOn = Color3.fromRGB(80, 180, 80),
    ToggleOff = Color3.fromRGB(100, 100, 100),
    SliderBar = Color3.fromRGB(70, 70, 90),
    SliderHandle = Color3.fromRGB(150, 120, 220)
}

-- Tab metatable
local Tab = {}
Tab.__index = Tab

-- Creates rounded corners for UI elements
local function applyCorner(instance, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = instance
    return corner
end

-- UI Elements
function Tab:AddButton(text, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -20, 0, 35)
    button.Text = text
    button.Font = Enum.Font.Gotham
    button.TextSize = 14
    button.TextColor3 = THEME.Text
    button.BackgroundColor3 = THEME.Accent
    button.AutoButtonColor = false
    button.Parent = self.Content
    
    applyCorner(button, 6)
    
    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = THEME.Accent:lerp(Color3.new(1, 1, 1), 0.2)
    end)
    
    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = THEME.Accent
    end)
    
    button.MouseButton1Click:Connect(callback)
    
    return button
end

function Tab:AddLabel(text)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 0, 20)
    label.Text = text
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextColor3 = THEME.Text
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = self.Content
    return label
end

function Tab:AddToggle(text, default, callback)
    local toggle = {}
    toggle.Value = default or false
    
    -- Container
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -20, 0, 30)
    container.BackgroundTransparency = 1
    container.Parent = self.Content
    
    -- Label
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Text = text
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextColor3 = THEME.Text
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    
    -- Toggle background (as TextButton for click events)
    local toggleBg = Instance.new("TextButton")
    toggleBg.Size = UDim2.new(0, 50, 0, 25)
    toggleBg.Position = UDim2.new(1, -50, 0.5, -12)
    toggleBg.BackgroundColor3 = THEME.ToggleOff
    toggleBg.AutoButtonColor = false
    toggleBg.Text = ""
    toggleBg.Parent = container
    applyCorner(toggleBg, 12)
    
    -- Toggle handle
    local toggleHandle = Instance.new("Frame")
    toggleHandle.Size = UDim2.new(0, 21, 0, 21)
    toggleHandle.Position = UDim2.new(0, 2, 0.5, -10)
    toggleHandle.BackgroundColor3 = Color3.new(1, 1, 1)
    toggleHandle.Parent = toggleBg
    applyCorner(toggleHandle, 10)
    
    -- Update toggle state
    local function updateToggle()
        if toggle.Value then
            toggleBg.BackgroundColor3 = THEME.ToggleOn
            toggleHandle.Position = UDim2.new(1, -23, 0.5, -10)
        else
            toggleBg.BackgroundColor3 = THEME.ToggleOff
            toggleHandle.Position = UDim2.new(0, 2, 0.5, -10)
        end
        if callback then callback(toggle.Value) end
    end
    
    -- Click handler
    toggleBg.MouseButton1Click:Connect(function()
        toggle.Value = not toggle.Value
        updateToggle()
    end)
    
    -- Initialize
    updateToggle()
    
    return toggle
end

function Tab:AddSlider(text, min, max, default, callback)
    local slider = {}
    slider.Value = default or min
    
    -- Container
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -20, 0, 50)
    container.BackgroundTransparency = 1
    container.Parent = self.Content
    
    -- Label
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Text = text
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextColor3 = THEME.Text
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    
    -- Value display
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0, 60, 0, 20)
    valueLabel.Position = UDim2.new(1, -60, 0, 0)
    valueLabel.Text = tostring(slider.Value)
    valueLabel.Font = Enum.Font.Gotham
    valueLabel.TextSize = 14
    valueLabel.TextColor3 = THEME.Text
    valueLabel.BackgroundTransparency = 1
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = container
    
    -- Slider track (as TextButton for click events)
    local track = Instance.new("TextButton")
    track.Size = UDim2.new(1, 0, 0, 5)
    track.Position = UDim2.new(0, 0, 1, -15)
    track.BackgroundColor3 = THEME.SliderBar
    track.AutoButtonColor = false
    track.Text = ""
    track.Parent = container
    applyCorner(track, 3)
    
    -- Slider fill
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.BackgroundColor3 = THEME.Accent
    fill.Parent = track
    applyCorner(fill, 3)
    
    -- Slider handle
    local handle = Instance.new("TextButton")
    handle.Size = UDim2.new(0, 20, 0, 20)
    handle.Position = UDim2.new(0, -10, 0.5, -10)
    handle.BackgroundColor3 = THEME.SliderHandle
    handle.AutoButtonColor = false
    handle.Text = ""
    handle.Parent = track
    applyCorner(handle, 10)
    
    -- Update slider position
    local function updateSlider(value)
        slider.Value = math.clamp(value, min, max)
        local percent = (slider.Value - min) / (max - min)
        fill.Size = UDim2.new(percent, 0, 1, 0)
        handle.Position = UDim2.new(percent, -10, 0.5, -10)
        valueLabel.Text = tostring(math.floor(slider.Value))
        if callback then callback(slider.Value) end
    end
    
    -- Drag logic
    local dragging = false
    local function onInput(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
        end
    end
    
    local function endDrag()
        dragging = false
    end
    
    local function updateDrag(input)
        if dragging then
            local pos = Vector2.new(input.Position.X, input.Position.Y)
            local relativeX = (pos.X - track.AbsolutePosition.X) / track.AbsoluteSize.X
            local value = min + (max - min) * math.clamp(relativeX, 0, 1)
            updateSlider(value)
        end
    end
    
    handle.MouseButton1Down:Connect(onInput)
    handle.TouchLongPress:Connect(onInput)
    
    game:GetService("UserInputService").InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            endDrag()
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateDrag(input)
        end
    end)
    
    track.MouseButton1Click:Connect(function()
        local mousePos = game:GetService("UserInputService"):GetMouseLocation()
        local relativeX = (mousePos.X - track.AbsolutePosition.X) / track.AbsoluteSize.X
        local value = min + (max - min) * math.clamp(relativeX, 0, 1)
        updateSlider(value)
    end)
    
    -- Initialize
    updateSlider(slider.Value)
    
    return slider
end

function Neutron:CreateWindow(title)
    local self = setmetatable({}, Neutron)
    self.Tabs = {}
    
    -- Create main container
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "NeutronUI"
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Main frame
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Size = UDim2.new(0, 450, 0, 350)
    self.MainFrame.Position = UDim2.new(0.5, -225, 0.5, -175)
    self.MainFrame.BackgroundColor3 = THEME.Primary
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.Parent = self.ScreenGui
    applyCorner(self.MainFrame, 8)
    
    -- Title bar (as TextButton for drag events)
    self.TitleBar = Instance.new("TextButton")
    self.TitleBar.Size = UDim2.new(1, 0, 0, 40)
    self.TitleBar.BackgroundColor3 = THEME.Secondary
    self.TitleBar.BorderSizePixel = 0
    self.TitleBar.AutoButtonColor = false
    self.TitleBar.Text = ""
    self.TitleBar.Parent = self.MainFrame
    
    -- Top corners only
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = self.TitleBar
    
    -- Title text
    self.Title = Instance.new("TextLabel")
    self.Title.Size = UDim2.new(1, -20, 1, 0)
    self.Title.Position = UDim2.new(0, 10, 0, 0)
    self.Title.BackgroundTransparency = 1
    self.Title.Text = title
    self.Title.TextColor3 = THEME.Text
    self.Title.Font = Enum.Font.GothamBold
    self.Title.TextSize = 18
    self.Title.TextXAlignment = Enum.TextXAlignment.Left
    self.Title.Parent = self.TitleBar
    
    -- Make window draggable
    local dragging = false
    local dragStart, frameStart
    
    self.TitleBar.MouseButton1Down:Connect(function(input)
        dragging = true
        dragStart = input.Position
        frameStart = self.MainFrame.Position
    end)
    
    self.TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            frameStart = self.MainFrame.Position
        end
    end)
    
    self.TitleBar.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            self.MainFrame.Position = UDim2.new(
                frameStart.X.Scale, 
                frameStart.X.Offset + delta.X,
                frameStart.Y.Scale,
                frameStart.Y.Offset + delta.Y
            )
        end
    end)
    
    self.TitleBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    -- Separators
    self:CreateSeparator(0)
    self:CreateSeparator(40)
    
    -- Tab container
    self.TabContainer = Instance.new("ScrollingFrame")
    self.TabContainer.Size = UDim2.new(0, 150, 1, -80)
    self.TabContainer.Position = UDim2.new(0, 0, 0, 40)
    self.TabContainer.BackgroundTransparency = 1
    self.TabContainer.ScrollBarThickness = 3
    self.TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    self.TabContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
    self.TabContainer.Parent = self.MainFrame
    
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Padding = UDim.new(0, 5)
    UIListLayout.Parent = self.TabContainer
    
    -- Content container
    self.ContentFrame = Instance.new("Frame")
    self.ContentFrame.Size = UDim2.new(1, -155, 1, -45)
    self.ContentFrame.Position = UDim2.new(0, 150, 0, 40)
    self.ContentFrame.BackgroundTransparency = 1
    self.ContentFrame.ClipsDescendants = true
    self.ContentFrame.Parent = self.MainFrame
    
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.Padding = UDim.new(0, 8)
    contentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    contentLayout.Parent = self.ContentFrame
    
    self.ScreenGui.Parent = game:GetService("CoreGui")
    return self
end

function Neutron:CreateSeparator(positionY)
    local separator = Instance.new("Frame")
    separator.Size = UDim2.new(1, 0, 0, 1)
    separator.Position = UDim2.new(0, 0, 0, positionY)
    separator.BackgroundColor3 = THEME.Border
    separator.BorderSizePixel = 0
    separator.Parent = self.MainFrame
    return separator
end

function Neutron:AddTab(name, iconName)
    local tab = setmetatable({
        Name = name,
        Icon = iconName,
        Buttons = {}
    }, Tab)
    
    -- Create tab button
    local tabButton = Instance.new("TextButton")
    tabButton.Size = UDim2.new(1, -10, 0, 35)
    tabButton.BackgroundColor3 = THEME.Secondary
    tabButton.AutoButtonColor = false
    tabButton.Text = ""
    tabButton.Parent = self.TabContainer
    
    applyCorner(tabButton, 6)
    
    -- Tab icon
    local icon = Instance.new("ImageLabel")
    icon.Size = UDim2.new(0, 20, 0, 20)
    icon.Position = UDim2.new(0, 10, 0.5, -10)
    icon.BackgroundTransparency = 1
    icon.Image = string.format(ICON_CDN, iconName)
    icon.Parent = tabButton
    
    -- Tab label
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -40, 1, 0)
    label.Position = UDim2.new(0, 40, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = THEME.Text
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = tabButton
    
    -- Create content frame
    tab.Content = Instance.new("Frame")
    tab.Content.Size = UDim2.new(1, 0, 1, 0)
    tab.Content.BackgroundTransparency = 1
    tab.Content.Visible = false
    tab.Content.Parent = self.ContentFrame
    
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.Padding = UDim.new(0, 8)
    contentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    contentLayout.Parent = tab.Content
    
    -- Selection logic
    tabButton.MouseButton1Click:Connect(function()
        self:SelectTab(tab)
    end)
    
    -- Default selection
    if #self.Tabs == 0 then
        self:SelectTab(tab)
    end
    
    table.insert(self.Tabs, tab)
    return tab
end

function Neutron:SelectTab(selectedTab)
    for _, tab in ipairs(self.Tabs) do
        tab.Content.Visible = (tab == selectedTab)
    end
end

-- Initialize library
return Neutron
