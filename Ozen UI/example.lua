local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/rhywme/UI-Libraries/main/Ozen%20UI/source.lua"))()
local Window = Library:CreateWindow("Ozen UI")

-- Add multiple tabs
local Tab1 = Window:AddTab("Main")
local Tab2 = Window:AddTab("Combat")
local Tab3 = Window:AddTab("Player Settings")
local Tab4 = Window:AddTab("World Mods")
local Tab5 = Window:AddTab("Miscellaneous")

-- Add elements to tabs
Tab1:AddToggle({
    Text = "Toggle",
    Callback = function(state) print("Toggle:", state) end
})

Tab2:AddButton({
    Text = "Button",
    Callback = function() print("Button clicked!") end
})

Tab3:AddLabel({
    Text = "This is an example of label."
})