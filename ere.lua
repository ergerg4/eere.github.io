local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer


local Window = WindUI:CreateWindow({
    Folder = "Ringta Scripts",
    Title = "RINGTA",
    Icon = "star",
    Author = "discord.gg/ringta",
    Theme = "Dark",
    Size = UDim2.fromOffset(500, 350),
    Transparent = false,
    HasOutline = true,
})

Window:EditOpenButton({
    Title = "Open RINGTA SCRIPTS",
    Icon = "pointer",
    CornerRadius = UDim.new(0, 6),
    StrokeThickness = 2,
    Color = ColorSequence.new(Color3.fromRGB(200, 0, 255), Color3.fromRGB(0, 200, 255)),
    Draggable = true,
})

local Tabs = {
    Main = Window:Tab({ Title = "RedLight", Icon = "lightbulb" }),
    Player = Window:Tab({ Title = "Dalgona", Icon = "cookie" }),
    Tug = Window:Tab({ Title = "Tug Of War", Icon = "sword" }),
    Hide = Window:Tab({ Title = "Hide And Seek", Icon = "eye-off" }),
    Glass = Window:Tab({ Title = "Glass Bridge", Icon = "grid-2x2" }),
    Mingle = Window:Tab({ Title = "Mingle", Icon = "tent" }),
    Random = Window:Tab({ Title = "Random Features", Icon = "dices" }),
    Rebel = Window:Tab({ Title = "Rebel", Icon = "skull" }),
    Final = Window:Tab({ Title = "Final", Icon = "swords" }),
}


-- ESP Keys toggle for Hide tab, with 0.4s delay for refresh to reduce lag

local workspace = game:GetService("Workspace")
local keyHighlights = {}
local keyESPEnabled = false
local keyESPConnections = {}

local function KeyESP(keyModel)
    if not keyESPEnabled then return end
    if not keyModel or not keyModel:IsA("Model") or not keyModel.PrimaryPart then
        return
    end
    if keyHighlights[keyModel] then
        keyHighlights[keyModel]:Destroy()
        keyHighlights[keyModel] = nil
    end
    local highlight = Instance.new("Highlight")
    highlight.Name = "KeyESP"
    highlight.Adornee = keyModel
    highlight.FillColor = Color3.fromRGB(255, 255, 0)
    highlight.OutlineColor = Color3.fromRGB(255, 215, 0)
    highlight.FillTransparency = 0.3
    highlight.OutlineTransparency = 0
    highlight.Parent = keyModel
    keyHighlights[keyModel] = highlight
    local connection
    connection = keyModel.AncestryChanged:Connect(function(_, parent)
        if not parent or not keyModel:IsDescendantOf(game) then
            if highlight and highlight.Parent then
                highlight:Destroy()
            end
            if connection then
                connection:Disconnect()
            end
            keyHighlights[keyModel] = nil
        end
    end)
    keyESPConnections[keyModel] = connection
end

local refreshConnection = nil

local function SetupKeyESP()
    for key, highlight in pairs(keyHighlights) do
        if highlight and highlight.Parent then
            highlight:Destroy()
        end
    end
    table.clear(keyHighlights)
    for key, conn in pairs(keyESPConnections) do
        if conn then
            conn:Disconnect()
        end
    end
    table.clear(keyESPConnections)

    if refreshConnection then
        refreshConnection:Disconnect()
        refreshConnection = nil
    end

    if not keyESPEnabled then return end

    local lastScan = 0
    refreshConnection = game:GetService("RunService").Heartbeat:Connect(function()
        if not keyESPEnabled then
            if refreshConnection then
                refreshConnection:Disconnect()
                refreshConnection = nil
            end
            return
        end
        if tick() - lastScan >= 0.4 then
            lastScan = tick()
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj.Name:lower():find("key") and obj:IsA("Model") and obj.PrimaryPart then
                    if not keyHighlights[obj] then
                        KeyESP(obj)
                    end
                end
            end
        end
    end)

    if keyESPConnections.descendantAdded then
        keyESPConnections.descendantAdded:Disconnect()
        keyESPConnections.descendantAdded = nil
    end
    keyESPConnections.descendantAdded = workspace.DescendantAdded:Connect(function(obj)
        if obj.Name:lower():find("key") and obj:IsA("Model") and obj.PrimaryPart then
            KeyESP(obj)
        end
    end)
end

Tabs.Hide:Toggle({
    Title = "ESP Keys",
    Desc = "Highlights all keys in the workspace",
    Value = false,
    Callback = function(state)
        keyESPEnabled = state
        SetupKeyESP()
        if not state and refreshConnection then
            refreshConnection:Disconnect()
            refreshConnection = nil
        end
    end
})
