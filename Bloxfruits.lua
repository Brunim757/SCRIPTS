-- 👑 SUPREME HUB ELITE V23.1 — NEBULA FIXED (MAGNET ONLY)

repeat task.wait() until game:IsLoaded()

-- SERVICES
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")
local StarterGui = game:GetService("StarterGui")

-- CONFIG
getgenv().Supreme = {
    Fruits = false,
    Magnet = true,
    ESP = false,
    Chest = false,
    Hop = false,
    SmartHop = true,

    NoClip = false,
    God = false,
    AntiKB = false,
    FPSBoost = false,

    AutoStore = true,
    AutoEquip = true,

    WalkSpeed = 16,
    JumpPower = 50,
    HopDelay = 45,

    Theme = Color3.fromRGB(0,200,255),
    Accent = Color3.fromRGB(0,120,160),

    Webhook = "https://discord.com/api/webhooks/1466207661639864362/E8EmrnrC15LJRjZuE0tM3y7JdsbvA8_vBDofO0OWnQ5Batq7KlqxuhwiCXx9cwhsSt"
}

-- AUTO REJOIN
game:GetService("CoreGui").RobloxPromptGui.promptOverlay.ChildAdded:Connect(function(c)
    if c.Name == "ErrorPrompt" then
        task.wait(4)
        TeleportService:Teleport(game.PlaceId)
    end
end)

-- NOTIFY
local function notify(txt)
    StarterGui:SetCore("SendNotification", {
        Title = "Supreme Hub V23.1",
        Text = txt,
        Duration = 4
    })
end

-- GUI ROOT
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "SupremeV23_1"
gui.ResetOnSpawn = false

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0,600,0,470)
main.Position = UDim2.new(0.5,-300,0.5,-235)
main.BackgroundColor3 = Color3.fromRGB(12,12,14)
main.Active = true
main.Draggable = true
Instance.new("UICorner", main)
local stroke = Instance.new("UIStroke", main)
stroke.Color = getgenv().Supreme.Theme

-- HEADER
local header = Instance.new("TextLabel", main)
header.Size = UDim2.new(1,0,0,45)
header.BackgroundTransparency = 1
header.Text = "👑 SUPREME HUB ELITE V23.1 — NEBULA FIXED"
header.TextColor3 = getgenv().Supreme.Theme
header.Font = Enum.Font.GothamBold
header.TextSize = 20

-- MINIMIZE BUTTON
local minimize = Instance.new("TextButton", header)
minimize.Size = UDim2.new(0,36,0,26)
minimize.Position = UDim2.new(1,-42,0.5,-13)
minimize.Text = "—"
minimize.Font = Enum.Font.GothamBold
minimize.TextSize = 18
minimize.TextColor3 = Color3.new(1,1,1)
minimize.BackgroundColor3 = Color3.fromRGB(35,35,40)
Instance.new("UICorner", minimize)

-- CONTAINERS
local tabs = Instance.new("Frame", main)
tabs.Position = UDim2.new(0,10,0,50)
tabs.Size = UDim2.new(0,120,1,-60)
tabs.BackgroundColor3 = Color3.fromRGB(18,18,22)
Instance.new("UICorner", tabs)

local pages = Instance.new("Frame", main)
pages.Position = UDim2.new(0,140,0,50)
pages.Size = UDim2.new(1,-150,1,-60)
pages.BackgroundTransparency = 1

minimize.MouseButton1Click:Connect(function()
    tabs.Visible = not tabs.Visible
    pages.Visible = not pages.Visible
end)

-- PAGE CREATOR (FIXED)
local function makePage(name)
    local f = Instance.new("ScrollingFrame")
    f.Name = name
    f.Parent = pages
    f.Visible = false
    f.Size = UDim2.new(1,0,1,0)
    f.CanvasSize = UDim2.new(0,0,0,900)
    f.ScrollBarThickness = 4
    f.BackgroundTransparency = 1

    local l = Instance.new("UIListLayout", f)
    l.Padding = UDim.new(0,10)
    l.HorizontalAlignment = Enum.HorizontalAlignment.Center

    return f
end

local P_Main = makePage("Main")
local P_Player = makePage("Player")
local P_Server = makePage("Server")
local P_Visual = makePage("Visual")
local P_Updates = makePage("Updates")
P_Main.Visible = true

-- TAB BUTTON
local tabY = 5
local function tabBtn(txt, page)
    local b = Instance.new("TextButton", tabs)
    b.Size = UDim2.new(1,-10,0,36)
    b.Position = UDim2.new(0,5,0,tabY)
    tabY += 40
    b.Text = txt
    b.Font = Enum.Font.GothamBold
    b.TextSize = 13
    b.TextColor3 = Color3.new(1,1,1)
    b.BackgroundColor3 = Color3.fromRGB(30,30,36)
    Instance.new("UICorner", b)

    b.MouseButton1Click:Connect(function()
        for _,p in pairs(pages:GetChildren()) do p.Visible = false end
        page.Visible = true
    end)
end

tabBtn("MAIN", P_Main)
tabBtn("PLAYER", P_Player)
tabBtn("SERVER", P_Server)
tabBtn("VISUAL", P_Visual)
tabBtn("UPDATES", P_Updates)

-- UI ELEMENTS
local function toggle(parent, text, flag)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(0.95,0,0,42)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 14
    b.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", b)

    local function refresh()
        b.Text = text.." : "..(getgenv().Supreme[flag] and "ON" or "OFF")
        b.BackgroundColor3 = getgenv().Supreme[flag]
            and getgenv().Supreme.Accent
            or Color3.fromRGB(32,32,38)
    end
    refresh()

    b.MouseButton1Click:Connect(function()
        getgenv().Supreme[flag] = not getgenv().Supreme[flag]
        refresh()
    end)
end

local function info(parent, text)
    local t = Instance.new("TextLabel", parent)
    t.Size = UDim2.new(0.95,0,0,40)
    t.BackgroundTransparency = 1
    t.TextWrapped = true
    t.Text = text
    t.Font = Enum.Font.Gotham
    t.TextSize = 13
    t.TextColor3 = Color3.fromRGB(200,200,210)
end

-- MAIN
toggle(P_Main,"🧲 Fruit Magnet","Magnet")
toggle(P_Main,"⚡ God Speed Fruits","Fruits")
toggle(P_Main,"👁 ESP Fruits","ESP")
toggle(P_Main,"💰 Auto Chest","Chest")
toggle(P_Main,"📦 Auto Store","AutoStore")
toggle(P_Main,"🖐 Auto Equip","AutoEquip")

-- PLAYER
toggle(P_Player,"👻 NoClip","NoClip")
toggle(P_Player,"🛡 God Mode","God")
toggle(P_Player,"🧲 Anti Knockback","AntiKB")
toggle(P_Player,"🚀 FPS Boost","FPSBoost")

-- SERVER
toggle(P_Server,"🔁 Auto Server Hop","Hop")
toggle(P_Server,"🧠 Smart Hop","SmartHop")
info(P_Server,"Smart Hop troca de servidor só se nenhuma fruta spawnar.")

-- UPDATES
info(P_Updates,"V23.1 — Nebula Fixed")
info(P_Updates,"• GUI arrastável")
info(P_Updates,"• Minimizar funcional")
info(P_Updates,"• Abas corrigidas")
info(P_Updates,"• Magnet ONLY (sem teleport)")
info(P_Updates,"• Smart Hop estável")

-- KEYBIND
UIS.InputBegan:Connect(function(i,gp)
    if not gp and i.KeyCode == Enum.KeyCode.RightShift then
        main.Visible = not main.Visible
    end
end)

-- CORE LOOP (MAGNET)
local lastFruit = 0
RunService.Heartbeat:Connect(function()
    local c = player.Character
    if not c or not c:FindFirstChild("HumanoidRootPart") then return end
    local hrp = c.HumanoidRootPart
    local hum = c:FindFirstChildOfClass("Humanoid")

    hum.WalkSpeed = getgenv().Supreme.WalkSpeed
    hum.JumpPower = getgenv().Supreme.JumpPower

    for _,t in pairs(workspace:GetChildren()) do
        if t:IsA("Tool") and t.Name:lower():find("fruit") and t:FindFirstChild("Handle") then
            lastFruit = os.clock()
            if getgenv().Supreme.Magnet or getgenv().Supreme.Fruits then
                t.Handle.CFrame = hrp.CFrame
                t.Handle.Velocity = Vector3.zero
                if getgenv().Supreme.AutoEquip then hum:EquipTool(t) end
                if getgenv().Supreme.AutoStore then
                    pcall(function()
                        RS.Remotes.CommF_:InvokeServer("StoreFruit", t.Name)
                    end)
                end
            end
        end
    end
end)

-- NOCLIP / GOD / ANTIKB / FPS
RunService.Stepped:Connect(function()
    local c = player.Character
    if not c then return end

    if getgenv().Supreme.NoClip then
        for _,p in pairs(c:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = false end
        end
    end
    if getgenv().Supreme.God then
        pcall(function() c.Humanoid.Health = math.huge end)
    end
    if getgenv().Supreme.AntiKB then
        pcall(function() c.HumanoidRootPart.Velocity = Vector3.zero end)
    end
    if getgenv().Supreme.FPSBoost then
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    end
end)

-- AUTO CHEST
task.spawn(function()
    while task.wait(0.6) do
        if getgenv().Supreme.Chest then
            local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                for _,v in pairs(workspace:GetDescendants()) do
                    if v:IsA("BasePart") and v.Name:find("Chest") then
                        hrp.CFrame = v.CFrame
                        task.wait(0.12)
                    end
                end
            end
        end
    end
end)

-- SMART HOP
task.spawn(function()
    while task.wait(getgenv().Supreme.HopDelay) do
        if getgenv().Supreme.Hop then
            if not getgenv().Supreme.SmartHop or (os.clock() - lastFruit) > getgenv().Supreme.HopDelay then
                TeleportService:Teleport(game.PlaceId)
            end
        end
    end
end)

-- ANTI AFK
player.Idled:Connect(function()
    VirtualUser:ClickButton2(Vector2.new())
end)

notify("V23.1 Nebula FIXED carregada com sucesso 👑")
