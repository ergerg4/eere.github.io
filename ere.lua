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


local flingEnabled = false
local flingThread = nil

Tabs.Final:Toggle({
    Title = "Touch Fling",
    Default = false,
    Callback = function(state)
        flingEnabled = state
        if flingEnabled then
            if flingThread then return end
            flingThread = task.spawn(function()
                local Players = game:GetService("Players")
                local RunService = game:GetService("RunService")
                local flingPower = 2500
                local movel = 0.05

                local lp = Players.LocalPlayer
                local character = lp.Character or lp.CharacterAdded:Wait()
                local hrp = character:WaitForChild("HumanoidRootPart")

                while flingEnabled do
                    RunService.Heartbeat:Wait()
                    local originalVelocity = hrp.Velocity
                    hrp.Velocity = originalVelocity * 1.5 + Vector3.new(0, flingPower, 0)
                    RunService.RenderStepped:Wait()
                    hrp.Velocity = originalVelocity * 0.8
                    RunService.Stepped:Wait()
                    hrp.Velocity = originalVelocity + Vector3.new(0, movel, 0)
                    movel = -movel
                end
                flingThread = nil
            end)
        else
            -- Disabling the fling will stop the loop on the next check
            flingEnabled = false
            flingThread = nil
        end
    end
})


Tabs.Final:Button({
    Title = "Fling All Players",
    Callback = function()
        local Player = Players.LocalPlayer
        local Character = Player.Character
        local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
        local RootPart = Humanoid and Humanoid.RootPart
        
        if not Character or not Humanoid or not RootPart then return end
        
        local function SkidFling(TargetPlayer)
            local TCharacter = TargetPlayer.Character
            local THumanoid = TCharacter and TCharacter:FindFirstChildOfClass("Humanoid")
            local TRootPart = THumanoid and THumanoid.RootPart
            local THead = TCharacter and TCharacter:FindFirstChild("Head")
            local Accessory = TCharacter and TCharacter:FindFirstChildOfClass("Accessory")
            local Handle = Accessory and Accessory:FindFirstChild("Handle")
            
            if RootPart.Velocity.Magnitude < 50 then
                getgenv().OldPos = RootPart.CFrame
            end
            
            if THead then
                workspace.CurrentCamera.CameraSubject = THead
            elseif not THead and Handle then
                workspace.CurrentCamera.CameraSubject = Handle
            elseif THumanoid and TRootPart then
                workspace.CurrentCamera.CameraSubject = THumanoid
            end
            
            if not TCharacter:FindFirstChildWhichIsA("BasePart") then
                return
            end
            
            local FPos = function(BasePart, Pos, Ang)
                RootPart.CFrame = CFrame.new(BasePart.Position) * Pos * Ang
                Character:SetPrimaryPartCFrame(CFrame.new(BasePart.Position) * Pos * Ang)
                RootPart.Velocity = Vector3.new(9e7, 9e7 * 10, 9e7)
                RootPart.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
            end
            
            local SFBasePart = function(BasePart)
                local TimeToWait = 2
                local Time = tick()
                local Angle = 0

                repeat
                    if RootPart and THumanoid then
                        if BasePart.Velocity.Magnitude < 50 then
                            Angle = Angle + 100

                            FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle),0 ,0))
                            task.wait()

                            FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                            task.wait()

                            FPos(BasePart, CFrame.new(2.25, 1.5, -2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                            task.wait()

                            FPos(BasePart, CFrame.new(-2.25, -1.5, 2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                            task.wait()

                            FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection,CFrame.Angles(math.rad(Angle), 0, 0))
                            task.wait()

                            FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection,CFrame.Angles(math.rad(Angle), 0, 0))
                            task.wait()
                        else
                            FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
                            task.wait()

                            FPos(BasePart, CFrame.new(0, -1.5, -THumanoid.WalkSpeed), CFrame.Angles(0, 0, 0))
                            task.wait()

                            FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
                            task.wait()
                            
                            FPos(BasePart, CFrame.new(0, 1.5, TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(math.rad(90), 0, 0))
                            task.wait()

                            FPos(BasePart, CFrame.new(0, -1.5, -TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(0, 0, 0))
                            task.wait()

                            FPos(BasePart, CFrame.new(0, 1.5, TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(math.rad(90), 0, 0))
                            task.wait()

                            FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(math.rad(90), 0, 0))
                            task.wait()

                            FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
                            task.wait()

                            FPos(BasePart, CFrame.new(0, -1.5 ,0), CFrame.Angles(math.rad(-90), 0, 0))
                            task.wait()

                            FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
                            task.wait()
                        end
                    else
                        break
                    end
                until BasePart.Velocity.Magnitude > 500 or BasePart.Parent ~= TargetPlayer.Character or TargetPlayer.Parent ~= Players or not TargetPlayer.Character == TCharacter or THumanoid.Sit or Humanoid.Health <= 0 or tick() > Time + TimeToWait
            end
            
            workspace.FallenPartsDestroyHeight = 0/0
            
            local BV = Instance.new("BodyVelocity")
            BV.Name = "EpixVel"
            BV.Parent = RootPart
            BV.Velocity = Vector3.new(9e8, 9e8, 9e8)
            BV.MaxForce = Vector3.new(1/0, 1/0, 1/0)
            
            Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
            
            if TRootPart and THead then
                if (TRootPart.CFrame.p - THead.CFrame.p).Magnitude > 5 then
                    SFBasePart(THead)
                else
                    SFBasePart(TRootPart)
                end
            elseif TRootPart and not THead then
                SFBasePart(TRootPart)
            elseif not TRootPart and THead then
                SFBasePart(THead)
            elseif not TRootPart and not THead and Accessory and Handle then
                SFBasePart(Handle)
            end
            
            BV:Destroy()
            Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
            workspace.CurrentCamera.CameraSubject = Humanoid
            
            repeat
                RootPart.CFrame = getgenv().OldPos * CFrame.new(0, .5, 0)
                Character:SetPrimaryPartCFrame(getgenv().OldPos * CFrame.new(0, .5, 0))
                Humanoid:ChangeState("GettingUp")
                table.foreach(Character:GetChildren(), function(_, x)
                    if x:IsA("BasePart") then
                        x.Velocity, x.RotVelocity = Vector3.new(), Vector3.new()
                    end
                end)
                task.wait()
            until (RootPart.Position - getgenv().OldPos.p).Magnitude < 25
            workspace.FallenPartsDestroyHeight = getgenv().FPDH
        end
        
        -- Flings all players except yourself
        for _, target in ipairs(Players:GetPlayers()) do
            if target ~= Player and target.Character then
                SkidFling(target)
            end
        end
    end
})




local flingAllEnabled = false
local flingAllThread = nil
local savedOldPos = nil

Tabs.Final:Toggle({
    Title = "Fling All Players",
    Default = false,
    Callback = function(state)
        flingAllEnabled = state
        local Players = game:GetService("Players")
        local Player = Players.LocalPlayer

        if flingAllEnabled then
            -- Save your position safely ONCE
            local Character = Player.Character
            local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
            local RootPart = Humanoid and Character:FindFirstChild("HumanoidRootPart")
            if Character and Humanoid and RootPart then
                savedOldPos = RootPart.CFrame
            end

            -- Main loop
            flingAllThread = task.spawn(function()
                while flingAllEnabled do
                    for _, target in ipairs(Players:GetPlayers()) do
                        if target ~= Player and target.Character then
                            pcall(function()
                                -- SkidFling logic per target
                                local Character = Player.Character
                                local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
                                local RootPart = Humanoid and Character:FindFirstChild("HumanoidRootPart")
                                local TCharacter = target.Character
                                local THumanoid = TCharacter and TCharacter:FindFirstChildOfClass("Humanoid")
                                local TRootPart = THumanoid and TCharacter:FindFirstChild("HumanoidRootPart")
                                local THead = TCharacter and TCharacter:FindFirstChild("Head")
                                local Accessory = TCharacter and TCharacter:FindFirstChildOfClass("Accessory")
                                local Handle = Accessory and Accessory:FindFirstChild("Handle")
                                if not Character or not Humanoid or not RootPart then return end
                                if not TCharacter:FindFirstChildWhichIsA("BasePart") then return end
                                local FPos = function(BasePart, Pos, Ang)
                                    RootPart.CFrame = CFrame.new(BasePart.Position) * Pos * Ang
                                    Character:SetPrimaryPartCFrame(CFrame.new(BasePart.Position) * Pos * Ang)
                                    RootPart.Velocity = Vector3.new(9e7, 9e7 * 10, 9e7)
                                    RootPart.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
                                end
                                local SFBasePart = function(BasePart)
                                    local TimeToWait = 2
                                    local Time = tick()
                                    local Angle = 0
                                    repeat
                                        if RootPart and THumanoid then
                                            if BasePart.Velocity.Magnitude < 50 then
                                                Angle = Angle + 100
                                                FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle),0 ,0))
                                                task.wait()
                                                FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                                                task.wait()
                                                FPos(BasePart, CFrame.new(2.25, 1.5, -2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                                                task.wait()
                                                FPos(BasePart, CFrame.new(-2.25, -1.5, 2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                                                task.wait()
                                                FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection,CFrame.Angles(math.rad(Angle), 0, 0))
                                                task.wait()
                                                FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection,CFrame.Angles(math.rad(Angle), 0, 0))
                                                task.wait()
                                            else
                                                FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
                                                task.wait()
                                                FPos(BasePart, CFrame.new(0, -1.5, -THumanoid.WalkSpeed), CFrame.Angles(0, 0, 0))
                                                task.wait()
                                                FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
                                                task.wait()
                                                FPos(BasePart, CFrame.new(0, 1.5, TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(math.rad(90), 0, 0))
                                                task.wait()
                                                FPos(BasePart, CFrame.new(0, -1.5, -TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(0, 0, 0))
                                                task.wait()
                                                FPos(BasePart, CFrame.new(0, 1.5, TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(math.rad(90), 0, 0))
                                                task.wait()
                                                FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(math.rad(90), 0, 0))
                                                task.wait()
                                                FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
                                                task.wait()
                                                FPos(BasePart, CFrame.new(0, -1.5 ,0), CFrame.Angles(math.rad(-90), 0, 0))
                                                task.wait()
                                                FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
                                                task.wait()
                                            end
                                        else
                                            break
                                        end
                                    until BasePart.Velocity.Magnitude > 500 or BasePart.Parent ~= TargetPlayer.Character or target.Parent ~= Players or not target.Character == TCharacter or THumanoid.Sit or Humanoid.Health <= 0 or tick() > Time + TimeToWait
                                end
                                workspace.FallenPartsDestroyHeight = math.huge
                                local BV = Instance.new("BodyVelocity")
                                BV.Name = "EpixVel"
                                BV.Parent = RootPart
                                BV.Velocity = Vector3.new(9e8, 9e8, 9e8)
                                BV.MaxForce = Vector3.new(1/0, 1/0, 1/0)
                                Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
                                if TRootPart and THead then
                                    if (TRootPart.CFrame.p - THead.CFrame.p).Magnitude > 5 then
                                        SFBasePart(THead)
                                    else
                                        SFBasePart(TRootPart)
                                    end
                                elseif TRootPart and not THead then
                                    SFBasePart(TRootPart)
                                elseif not TRootPart and THead then
                                    SFBasePart(THead)
                                elseif not TRootPart and not THead and Accessory and Handle then
                                    SFBasePart(Handle)
                                end
                                BV:Destroy()
                                Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
                                workspace.CurrentCamera.CameraSubject = Humanoid
                                -- Don't restore position here, only on toggle off!
                            end)
                        end
                    end
                    task.wait(1) -- adjust time if needed, avoids spamming too hard
                end
            end)
        else
            -- Toggle OFF: Stop thread and restore position
            if flingAllThread then
                task.cancel(flingAllThread)
                flingAllThread = nil
            end
            -- Restore position ONLY if it was saved
            local Character = Player.Character
            local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
            local RootPart = Humanoid and Character:FindFirstChild("HumanoidRootPart")
            if savedOldPos and RootPart then
                RootPart.CFrame = savedOldPos
                Character:SetPrimaryPartCFrame(savedOldPos)
                Humanoid:ChangeState("GettingUp")
                for _, x in ipairs(Character:GetChildren()) do
                    if x:IsA("BasePart") then
                        x.Velocity, x.RotVelocity = Vector3.new(), Vector3.new()
                    end
                end
            end
        end
    end
})
