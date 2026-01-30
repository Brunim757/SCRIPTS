--[[
👑 SUPREME HUB ELITE V21 - IMPROVED EDITION
⚡ Magnet, AutoChest parado, ESP, NoClip, GodSpeed
🎨 GUI Profissional, segura e organizada
🚀 Loading Screen incluído
⚠️ Aviso: Usar AutoChest pode causar kick por segurança
]]

repeat task.wait() until game:IsLoaded()

-- SERVICES
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")

-- ================= GLOBAL SETTINGS =================
getgenv().Supreme = {
    Magnet = true,
    ChestFarm = false,
    ESP = false,
    NoClip = false,
    GodSpeed = false,
    WalkSpeed = 16,
    JumpPower = 50,
    FruitsFound = 0,
    ChestsFound = 0,
    StartTime = os.time(),
    ThemeColor = Color3.fromRGB(0,255,150),
    Themes = {["Green"]=Color3.fromRGB(0,255,150), ["Blue"]=Color3.fromRGB(0,150,255), ["Red"]=Color3.fromRGB(255,50,50)},
    Debug = true
}

-- ================= SAFE CALL =================
local function safeCall(func)
    local ok, err = pcall(func)
    if not ok and getgenv().Supreme.Debug then
        warn("[SupremeHub] Error: "..tostring(err))
    end
end

-- ================= LOADING SCREEN =================
local sgLoading = Instance.new("ScreenGui", player.PlayerGui)
sgLoading.Name = "SupremeLoading"; sgLoading.ResetOnSpawn=false

local loadingFrame = Instance.new("Frame", sgLoading)
loadingFrame.Size = UDim2.new(0,400,0,150)
loadingFrame.Position = UDim2.new(0.5,-200,0.5,-75)
loadingFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
Instance.new("UICorner", loadingFrame)

local title = Instance.new("TextLabel", loadingFrame)
title.Size = UDim2.new(1,0,0,70)
title.Position = UDim2.new(0,0,0,10)
title.BackgroundTransparency = 1
title.Text = "Supreme Hub"
title.TextColor3 = getgenv().Supreme.ThemeColor
title.TextScaled = true
title.Font = Enum.Font.SourceSansBold

local subtitle = Instance.new("TextLabel", loadingFrame)
subtitle.Size = UDim2.new(1,0,0,50)
subtitle.Position = UDim2.new(0,0,0,80)
subtitle.BackgroundTransparency = 1
subtitle.Text = "Loading..."
subtitle.TextColor3 = Color3.fromRGB(200,200,200)
subtitle.TextScaled = true
subtitle.Font = Enum.Font.SourceSans

task.wait(2)
sgLoading:Destroy() -- remove loading

-- ================= DRAGGABLE FUNCTION =================
local function makeDraggable(frame)
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    frame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

-- ================= GUI SETUP =================
local sg = Instance.new("ScreenGui", player.PlayerGui)
sg.Name = "SupremeV21"; sg.ResetOnSpawn=false

-- MINI BUTTON
local ball = Instance.new("Frame", sg)
ball.Size = UDim2.new(0,50,0,50); ball.Position = UDim2.new(0,10,0.5,0)
ball.BackgroundColor3 = Color3.fromRGB(15,15,15); ball.Visible = false
Instance.new("UICorner", ball).CornerRadius = UDim.new(1,0)
local ballBtn = Instance.new("TextButton", ball)
ballBtn.Size = UDim2.new(1,0,1,0); ballBtn.Text="👑"; ballBtn.TextColor3=Color3.new(1,1,1); ballBtn.TextSize=26; ballBtn.BackgroundTransparency=1
makeDraggable(ball)

-- MAIN DASHBOARD
local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0,550,0,420); main.Position = UDim2.new(0.5,-275,0.5,-210)
main.BackgroundColor3 = Color3.fromRGB(20,20,20); main.Active=true
Instance.new("UICorner", main)
makeDraggable(main)

-- SIDE NAVIGATION
local side = Instance.new("Frame", main)
side.Size = UDim2.new(0,140,1,0); side.BackgroundColor3 = Color3.fromRGB(35,35,35)
Instance.new("UICorner", side)

-- CONTENT SCROLL
local content = Instance.new("ScrollingFrame", main)
content.Size = UDim2.new(1,-160,1,-20); content.Position = UDim2.new(0,150,0,10)
content.BackgroundTransparency = 1; content.ScrollBarThickness = 3

local function clearContent()
    for _, v in pairs(content:GetChildren()) do
        if v:IsA("GuiObject") then v:Destroy() end
    end
end

-- ================= DASHBOARD CONTENT =================
local function showHome()
    clearContent()
    local layout = Instance.new("UIListLayout", content); layout.Padding = UDim.new(0,10)

    -- TOGGLES
    local function createToggle(name, cfg)
        local btn = Instance.new("TextButton", content)
        btn.Size = UDim2.new(0.95,0,0,45)
        btn.Text = name..": "..(getgenv().Supreme[cfg] and "ON" or "OFF")
        btn.BackgroundColor3 = getgenv().Supreme[cfg] and Color3.fromRGB(0,150,100) or Color3.fromRGB(50,50,50)
        btn.TextColor3 = Color3.new(1,1,1); btn.Font = Enum.Font.SourceSansBold
        Instance.new("UICorner", btn)
        btn.MouseButton1Click:Connect(function()
            getgenv().Supreme[cfg] = not getgenv().Supreme[cfg]
            btn.Text = name..": "..(getgenv().Supreme[cfg] and "ON" or "OFF")
            btn.BackgroundColor3 = getgenv().Supreme[cfg] and Color3.fromRGB(0,150,100) or Color3.fromRGB(50,50,50)
        end)
    end

    createToggle("🧲 MAGNET", "Magnet")
    createToggle("💰 AUTO CHEST FARM", "ChestFarm")
    createToggle("👁 FRUIT ESP", "ESP")
    createToggle("⚡ GOD SPEED", "GodSpeed")
    createToggle("👻 NOCLIP", "NoClip")

    -- EXTRA BUTTONS
    local function createButton(name, func)
        local btn = Instance.new("TextButton", content)
        btn.Size = UDim2.new(0.95,0,0,40); btn.Text=name
        btn.BackgroundColor3 = Color3.fromRGB(40,40,40); btn.TextColor3 = Color3.new(1,1,1)
        Instance.new("UICorner", btn)
        btn.MouseButton1Click:Connect(func)
    end

    createButton("MINIMIZAR DASHBOARD", function() main.Visible=false; ball.Visible=true end)
    createButton("RESETAR CONTADOR DE FRUTAS", function() getgenv().Supreme.FruitsFound=0; getgenv().Supreme.ChestsFound=0 end)

    -- FRUIT & CHEST COUNTER
    local counter = Instance.new("TextLabel", content)
    counter.Size = UDim2.new(0.95,0,0,30); counter.BackgroundTransparency=1
    counter.TextColor3 = getgenv().Supreme.ThemeColor; counter.Font = Enum.Font.SourceSansBold; counter.TextSize = 18

    -- AVISO DE SEGURANÇA
    local warning = Instance.new("TextLabel", content)
    warning.Size = UDim2.new(0.95,0,0,30); warning.BackgroundTransparency=1
    warning.TextColor3 = Color3.fromRGB(255,100,0); warning.Font = Enum.Font.SourceSansBold; warning.TextSize = 16
    warning.Text = "⚠️ Usar AutoChest pode causar kick por segurança!"

    task.spawn(function()
        while main.Visible do
            counter.Text = "Frutas: "..getgenv().Supreme.FruitsFound.." | Chests: "..getgenv().Supreme.ChestsFound
            task.wait(1)
        end
    end)
end

-- NAVIGATION
local function createNav(txt,pos,func)
    local btn = Instance.new("TextButton", side)
    btn.Size = UDim2.new(1,-10,0,40); btn.Position = UDim2.new(0,5,0,pos)
    btn.Text = txt; btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    btn.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(func)
end

createNav("DASHBOARD", 15, showHome)
ballBtn.MouseButton1Click:Connect(function() main.Visible=true; ball.Visible=false end)
showHome()

-- ================= CORE LOGIC =================
local lastPosition = nil

-- MAGNET + AUTO EQUIP + AUTO STORE
RunService.Heartbeat:Connect(function()
    if not getgenv().Supreme.Magnet then return end
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    safeCall(function()
        local hrp = char.HumanoidRootPart
        local hum = char:FindFirstChildOfClass("Humanoid")
        for _, tool in pairs(workspace:GetChildren()) do
            if tool:IsA("Tool") and tool:FindFirstChild("Handle") and tool.Name:lower():find("fruit") then
                tool.Handle.CanCollide = false
                tool.Handle.Velocity = Vector3.zero
                tool.Handle.CFrame = hrp.CFrame
                hum:EquipTool(tool)
                pcall(function() RS.Remotes.CommF:InvokeServer("StoreFruit", tool.Name) end)
                getgenv().Supreme.FruitsFound += 1
            end
        end
    end)
end)

-- AUTO CHEST PARADO COM TELEPORTE
task.spawn(function()
    while task.wait(0.5) do
        if getgenv().Supreme.ChestFarm then
            local char = player.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") then continue end
            safeCall(function()
                local hrp = char.HumanoidRootPart
                if not lastPosition then lastPosition = hrp.CFrame end
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("TouchTransmitter") and v.Parent.Name:find("Chest") then
                        hrp.CFrame = v.Parent.CFrame + Vector3.new(0,3,0)
                        getgenv().Supreme.ChestsFound += 1
                        task.wait(0.2)
                    end
                end
                hrp.CFrame = lastPosition
            end)
        end
    end
end)

-- WALK SPEED / JUMP POWER / NOCLIP / GODSPEED
RunService.Stepped:Connect(function()
    local char = player.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then return end

    hum.WalkSpeed = getgenv().Supreme.WalkSpeed
    hum.JumpPower = getgenv().Supreme.JumpPower

    if getgenv().Supreme.NoClip then
        for _, p in pairs(char:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = false end
        end
    end

    if getgenv().Supreme.GodSpeed then
        safeCall(function() hum.Health = math.huge end)
    end
end)

-- FRUIT ESP
task.spawn(function()
    while task.wait(1) do
        if getgenv().Supreme.ESP then
            for _, tool in pairs(workspace:GetChildren()) do
                if tool:IsA("Tool") and tool.Name:lower():find("fruit") and tool:FindFirstChild("Handle") then
                    if not tool:FindFirstChild("ESPBox") then
                        local box = Instance.new("BoxHandleAdornment")
                        box.Adornee = tool.Handle
                        box.Size = tool.Handle.Size + Vector3.new(0.5,0.5,0.5)
                        box.Color = BrickColor.new("Bright green")
                        box.AlwaysOnTop = true
                        box.ZIndex = 10
                        box.Name = "ESPBox"
                        box.Parent = tool.Handle
                    end
                end
            end
        end
    end
end)

-- ANTI IDLE
player.Idled:Connect(function()
    game:GetService("VirtualUser"):CaptureController()
    game:GetService("VirtualUser"):ClickButton2(Vector2.new())
end)

print("✅ Supreme Hub V21 IMPROVED carregado! Magnet, AutoChest, ESP, NoClip e GodSpeed funcionando com segurança. ⚠️ AutoChest pode causar kick!")
