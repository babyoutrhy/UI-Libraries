local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/rhywme/UI-Libraries/main/Ozen%20UI/source.lua"))()
local Window = Library:CreateWindow("Ozen UI")

-- Add multiple tabs
local Tab1 = Window:AddTab("Tab 1")
local Tab2 = Window:AddTab("Tab 2")
local Tab3 = Window:AddTab("Tab 3")
local Tab4 = Window:AddTab("Tab 4")
local Tab5 = Window:AddTab("Tab 5")
local Tab6 = Window:AddTab("Tab 6")
local Tab5 = Window:AddTab("Tab 7")
local Tab6 = Window:AddTab("Tab 8")

-- Add elements to tabs

Tab1:AddLabel({
    Text = "Ozen UI was made by rhy"
})

Tab1:AddToggle({
    Text = "Toggle",
    Callback = function(state) print("Toggle set to:", state) end
})

Tab1:AddButton({
    Text = "Button",
    Callback = function() print("Button clicked!") end
})

Tab1:AddSlider({
    Text = "Walk Speed",
    Min = 16,    -- Normal Roblox speed
    Max = 100,   -- Maximum allowed speed
    Step = 2,    -- Increment by 2 units
    Default = 16, -- Default to normal speed
    Callback = function(value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
    end
})
