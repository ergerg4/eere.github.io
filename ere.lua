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


