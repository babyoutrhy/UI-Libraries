-- [[ Ozen UI ] --

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/rhywme/UI-Libraries/main/Ozen%20UI/source.lua"))()
local Window = Library:CreateWindow("Ozen UI")

-- [[ Add multiple tabs ]] --

-- You can add as many tabs as you want, just make sure to use unique names for each tab.

local Tab1 = Window:AddTab("Tab 1")
local Tab2 = Window:AddTab("Tab 2")
local Tab3 = Window:AddTab("Tab 3")
local Tab4 = Window:AddTab("Tab 4")
local Tab5 = Window:AddTab("Tab 5")
local Tab6 = Window:AddTab("Tab 6")
local Tab5 = Window:AddTab("Tab 7")
local Tab6 = Window:AddTab("Tab 8")

-- [[ Add elements to tabs ]] --

-- Label

Tab1:AddLabel({
    Text = "Ozen UI was made by rhy"
})

-- Toggle

Tab1:AddToggle({
    Text = "Toggle",
    Callback = function(state)
        print("Toggle set to:", state) 
    end
})


-- Dropdown

Tab1:AddDropdown({
    Text = "Multi Select",
    Options = {"Option 1", "Option 2", "Option 3", "Option 4", "Option 5", "Option 6", "Option 7", "Option 8", "Option 9", "Option 10"},
    MultipleOptions = true,
    Callback = function(selected)
        if type(selected) == "table" then
            print("Selected:", table.concat(selected, ", ")) -- Multiple selections
        else
            print("Selected:", selected) -- Single selection
        end
    end
})


-- Button

Tab1:AddButton({
    Text = "Button",
    Callback = function() 
        print("Button clicked!")
    end
})

-- Textbox

Tab1:AddTextbox({
    Text = "Textbox",
    Placeholder = "Enter text",
    Default = "Enter text",
    Callback = function(text)
	print(text)
    end
})

-- Slider

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
