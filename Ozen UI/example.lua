local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/rhywme/UI-Libraries/main/Ozen%20UI/source.lua"))()
local Window = Library:CreateWindow("Ozen UI")

-- Add multiple tabs
local MainTab = Window:AddTab("Main")
local CombatTab = Window:AddTab("Combat")
local PlayerTab = Window:AddTab("Player Settings")
local WorldTab = Window:AddTab("World Mods")
local MiscTab = Window:AddTab("Miscellaneous")

-- Add elements to tabs
MainTab:AddToggle({
    Text = "Auto-Farm",
    Callback = function(state) 
      print("Auto-Farm:", state) 
    end
})

CombatTab:AddButton({
    Text = "Kill All",
    Callback = function() 
      print("Executing all enemies") 
    end
})

PlayerTab:AddLabel({
    Text = "Speed: Normal"
})
