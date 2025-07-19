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

local antiFlingEnabled = false
local antiFlingConnection = nil

local function enableAntiFling()
    antiFlingConnection = RunService.Heartbeat:Connect(function()
        if not antiFlingEnabled then
            if antiFlingConnection then
                antiFlingConnection:Disconnect()
                antiFlingConnection = nil
            end
            return
        end
        local character = LocalPlayer.Character
        if character then
            local hrp = character:FindFirstChild("HumanoidRootPart")
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if hrp and humanoid then
                local currentVel = hrp.Velocity
                hrp.Velocity = Vector3.new(currentVel.X * 0.5, currentVel.Y, currentVel.Z * 0.5)
                hrp.RotVelocity = Vector3.new(0, 0, 0)
                if currentVel.Magnitude > 100 and humanoid:GetState() ~= Enum.HumanoidStateType.Jumping then
                    hrp.Velocity = Vector3.new(currentVel.X * 0.3, currentVel.Y, currentVel.Z * 0.3)
                end
            end
        end
        task.wait(0.1)
    end)
end

local function disableAntiFling()
    if antiFlingConnection then
        antiFlingConnection:Disconnect()
        antiFlingConnection = nil
    end
end

Tabs.Random:Toggle({
    Title = "Antifling",
    Value = false,
    Callback = function(state)
        antiFlingEnabled = state
        if state then
            if not antiFlingConnection or not antiFlingConnection.Connected then
                enableAntiFling()
            end
        else
            disableAntiFling()
        end
    end
})
