local Neutron = {}
Neutron.__index = Neutron

-- Bootstrap Icons CDN (replacing the images from SVG to png because Roblox doesn't support it, grr..)
local ICON_CDN = "https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/icons/%s.png"

-- Theme Configuration
local THEME = {
    Primary = Color3.fromRGB(40, 40, 50),
    Secondary = Color3.fromRGB(30, 30, 40),
    Accent = Color3.fromRGB(100, 70, 200),
    Text = Color3.fromRGB(240, 240, 240),
    Border = Color3.fromRGB(60, 60, 70)
}

-- Tab metatable
local Tab = {}
Tab.__index = Tab

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
    
    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = THEME.Accent:lerp(Color3.new(1, 1, 1), 0.2)
    end)
    
    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = THEME.Accent
    end)
    
    button.MouseButton1Click:Connect(callback)
    
    table.insert(self.Buttons, button)
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

function Neutron:CreateWindow(title)
    local self = setmetatable({}, Neutron)
    self.Tabs = {}
    
    -- Create main container
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "NeutronUI"
    self.ScreenGui.ResetOnSpawn = false
    
    -- Main frame
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Size = UDim2.new(0, 450, 0, 350)
    self.MainFrame.Position = UDim2.new(0.5, -225, 0.5, -175)
    self.MainFrame.BackgroundColor3 = THEME.Primary
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.Parent = self.ScreenGui
    
    -- Title bar
    self.TitleBar = Instance.new("Frame")
    self.TitleBar.Size = UDim2.new(1, 0, 0, 40)
    self.TitleBar.BackgroundColor3 = THEME.Secondary
    self.TitleBar.BorderSizePixel = 0
    self.TitleBar.Parent = self.MainFrame
    
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
