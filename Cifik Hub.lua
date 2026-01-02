--====================================================
-- FLUENT UI LOAD
--====================================================

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Players = game:GetService("Players")
local player = Players.LocalPlayer

--====================================================
-- WINDOW
--====================================================

local Window = Fluent:CreateWindow({
    Title = "Prison Life Cifik's Gui",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Darker",
    MinimizeKey = Enum.KeyCode.RightShift
})

--====================================================
-- UTILS
--====================================================

local function getChar()
    return player.Character or player.CharacterAdded:Wait()
end

local function getRoot()
    return getChar():WaitForChild("HumanoidRootPart")
end

local function getHumanoid()
    return getChar():FindFirstChildOfClass("Humanoid")
end

local function isInmate()
    return player.Team and player.Team.Name == "Inmates"
end

local function teleport(pos)
    getRoot().CFrame = CFrame.new(pos)
end

local function teleportAndKill(pos)
    teleport(pos)
    task.wait(0.1)
    local hum = getHumanoid()
    if hum then
        hum.Health = 0
    end
end

--====================================================
-- POSITIONS
--====================================================

local POS = {
    Escape = Vector3.new(
        -973.4564208984375,
        108.32368469238281,
        2047.090087890625
    ),

    Kitchen = Vector3.new(
        787.959777832031250,
        99.989997863769531,
        2256.778564453125000
    ),

    GuardsSpawn = Vector3.new(
        853.968444824218750,
        99.989997863769531,
        2272.871826171875000
    ),

    SafeZone = Vector3.new(
        -324.756622314453125,
        64.239562988281250,
        2004.890625000000000
    ),

    Prison = Vector3.new(
        478.951019287109375,
        112.550506591796875,
        2398.451416015625000
    )


}



--====================================================
-- TABS
--====================================================

local InmatesTab = Window:AddTab({ Title = "Inmates", Icon = "user" })
local GuardsTab  = Window:AddTab({ Title = "Guards",  Icon = "shield" })
local TeleportTab = Window:AddTab({ Title = "Teleports",  Icon = "plane" })
--====================================================
-- INMATES : MANUAL ESCAPE
--====================================================

InmatesTab:AddButton({
    Title = "Escape Prison (Kills You)",
    Callback = function()
        teleportAndKill(POS.Escape)
    end
})

InmatesTab:AddButton({
    Title = "Safe Escape Prison",
    Callback = function()
        teleport(POS.Escape)
    end
})

--====================================================
-- AUTO ESCAPE CORE
--====================================================

local function setupAuto(toggleGetter, action)
    local connTeam, connChar

    local function check()
        if not toggleGetter() then return end
        if isInmate() then
            action()
        end
    end

    connTeam = player:GetPropertyChangedSignal("Team"):Connect(check)
    connChar = player.CharacterAdded:Connect(function()
        task.wait(0.2)
        check()
    end)

    task.wait(0.2)
    check()

    return function()
        if connTeam then connTeam:Disconnect() end
        if connChar then connChar:Disconnect() end
    end
end

--====================================================
-- AUTO ESCAPE (KILL)
--====================================================

local autoEscape = false
local stopAutoEscape

InmatesTab:AddToggle("AutoEscapeKill", {
    Title = "Auto Escape (Kills You)",
    Default = false,
    Callback = function(value)
        autoEscape = value

        if stopAutoEscape then
            stopAutoEscape()
            stopAutoEscape = nil
        end

        if value then
            stopAutoEscape = setupAuto(
                function() return autoEscape end,
                function() teleportAndKill(POS.Escape) end
            )
        end
    end
})

--====================================================
-- AUTO SAFE ESCAPE
--====================================================

local autoSafeEscape = false
local stopAutoSafeEscape

InmatesTab:AddToggle("AutoEscapeSafe", {
    Title = "Auto Safe Escape",
    Default = false,
    Callback = function(value)
        autoSafeEscape = value

        if stopAutoSafeEscape then
            stopAutoSafeEscape()
            stopAutoSafeEscape = nil
        end

        if value then
            stopAutoSafeEscape = setupAuto(
                function() return autoSafeEscape end,
                function() teleport(POS.Escape) end
            )
        end
    end
})

--====================================================
-- GUARDS (заглушки)
--====================================================

GuardsTab:AddToggle("AutoTaser", {
    Title = "Auto Taser",
    Default = false,
    Callback = function(v)
        Fluent:Notify({
            Title = "Coming Soon..",
            Duration = 3
        })
    end
})

GuardsTab:AddToggle("AutoArrest", {
    Title = "Auto Arrest",
    Default = false,
    Callback = function(v)
        Fluent:Notify({
            Title = "Coming Soon..",
            Duration = 3
        })
    end
})


--====================================================
-- Teleports
--====================================================

TeleportTab:AddButton({
    Title = "Teleport to Prison",
    Callback = function()
        teleport(POS.Prison)
    end
})

TeleportTab:AddButton({
    Title = "Teleport to Kitchen",
    Callback = function()
        teleport(POS.Kitchen)
    end
})

TeleportTab:AddButton({
    Title = "Teleport to Guards Spawn",
    Callback = function()
        teleport(POS.GuardsSpawn)
    end
})

TeleportTab:AddButton({
    Title = "Teleport to Safe Zone",
    Callback = function()
        teleport(POS.SafeZone)
    end
})

TeleportTab:AddButton({
    Title = "Teleport to Criminal Base",
    Callback = function()
        teleport(POS.Escape)
    end
})


--====================================================
-- FINISH
--====================================================

Fluent:Notify({
    Title = "Loaded",
    Content = "Cifik Hub Loaded",
    Duration = 3
})
