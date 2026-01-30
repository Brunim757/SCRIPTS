-- 👑 SUPREME HUB ELITE V28 — OMEGA EDITION
-- Full | Stable | Rayfield-like | Mobile + PC

repeat task.wait() until game:IsLoaded()

-- SERVICES
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local StarterGui = game:GetService("StarterGui")

-- ================= CONFIG =================
getgenv().Supreme = {
    -- FARM
    Magnet = true,
    ESP = false,
    AutoStore = true,
    AutoEquip = true,
    AutoChest = false,

    -- PLAYER
    NoClip = false,
    God = false,
    AntiKB = false,
    WalkSpeed = 16,
    JumpPower = 50,

    -- SERVER
    ServerHop = false,
    SmartHop = true,
    HopDelay = 45,

    -- MISC
    FPSBoost = false
}

-- ================= LOADING SCREEN =================
local loadGui = Instance.new("ScreenGui", player.PlayerGui)
loadGui.IgnoreGuiInset = true

local bg = Instance.new("Frame", loadGui)
bg.Size = UDim2.fromScale(1,1)
bg.BackgroundColor3 = Color3.fromRGB(10,10,15)

local title = Instance.new("TextLabel", bg)
title.Size = UDim2.new(1,0,0,60)
title.Position = UDim2.new(0,0,0.4,0)
title.Text = "SUPREME HUB"
title.Font = Enum.Font.GothamBlack
title.TextSize = 36
title.TextColor3 = Color3.fromRGB(0,200,255)
title.BackgroundTransparency = 1

local loading = Instance.new("TextLabel", bg)
loading.Size = UDim2.new(1,0,0,40)
loading.Position = UDim2.new(0,0,0.48,0)
loading.Text = "loading..."
loading.Font = Enum.Font.Gotham
loading.TextSize = 18
loading.TextColor3 = Color3.fromRGB(180,180,200)
loading.BackgroundTransparency = 1

task.wait(2)
loadGui:Destroy()

-- ================= GUI ROOT =================
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "SupremeV28"
gui.ResetOnSpawn = false

-- MAIN WINDOW
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0,620,0,480)
main.Position = UDim2.new(0.5,-310,0.5,-240)
main.BackgroundColor3 = Color3.fromRGB(18,18,24)
main.Active = true
main.Draggable = true
Instance.new("UICorner", main)

-- HEADER
local header = Instance.new("TextLabel", main)
header.Size = UDim2.new(1,0,0,42)
header.Text = "👑 SUPREME HUB ELITE V28 — OMEGA"
header.Font = Enum.Font.GothamBold
header.TextSize = 20
header.TextColor3 = Color3.fromRGB(0,200,255)
header.BackgroundTransparency = 1

-- MINIMIZE BUTTON
local mini = Instance.new("TextButton", main)
mini.Size = UDim2.new(0,36,0,36)
mini.Position = UDim2.new(1,-40,0,4)
mini.Text = "–"
mini.Font = Enum.Font.GothamBold
mini.TextSize = 22
mini.BackgroundColor3 = Color3.fromRGB(30,30,40)
mini.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", mini)

-- BUBBLE
local bubble = Instance.new("TextButton", gui)
bubble.Size = UDim2.new(0,55,0,55)
bubble.Position = UDim2.new(0,20,0.5,-25)
bubble.Text = "👑"
bubble.Visible = false
bubble.BackgroundColor3 = Color3.fromRGB(0,180,255)
bubble.TextSize = 24
Instance.new("UICorner", bubble)

mini.MouseButton1Click:Connect(function()
    main.Visible = false
    bubble.Visible = true
end)

bubble.MouseButton1Click:Connect(function()
    main.Visible = true
    bubble.Visible = false
end)

-- ================= TABS =================
local tabs = Instance.new("Frame", main)
tabs.Position = UDim2.new(0,10,0,50)
tabs.Size = UDim2.new(0,130,1,-60)
tabs.BackgroundColor3 = Color3.fromRGB(24,24,30)
Instance.new("UICorner", tabs)

local pages = Instance.new("Frame", main)
pages.Position = UDim2.new(0,150,0,50)
pages.Size = UDim2.new(1,-160,1,-60)
pages.BackgroundTransparency = 1

-- Função para criar páginas com CanvasSize automático
local function newPage(name)
    local p = Instance.new("ScrollingFrame", pages)
    p.Name = name
    p.Visible = false
    p.CanvasSize = UDim2.new(0,0,0,0)
    p.ScrollBarThickness = 3
    p.BackgroundTransparency = 1

    local layout = Instance.new("UIListLayout", p)
    layout.Padding = UDim.new(0,10)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.SortOrder = Enum.SortOrder.LayoutOrder

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        p.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y + 10)
    end)

    return p
end

local P_Main    = newPage("Main")
local P_Fruits  = newPage("Fruits")
local P_Chest   = newPage("Chest")
local P_Player  = newPage("Player")
local P_Server  = newPage("Server")
local P_Updates = newPage("Updates")
P_Main.Visible = true

-- Função para criar abas
local function tab(name, page, order)
    local b = Instance.new("TextButton", tabs)
    b.Size = UDim2.new(1,-10,0,36)
    b.Position = UDim2.new(0,5,0,5 + (order-1)*40)
    b.Text = name
    b.Font = Enum.Font.GothamBold
    b.TextSize = 13
    b.BackgroundColor3 = Color3.fromRGB(34,34,44)
    b.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function()
        for _,v in pairs(pages:GetChildren()) do v.Visible = false end
        page.Visible = true
    end)
end

tab("MAIN",P_Main,1)
tab("FRUITS",P_Fruits,2)
tab("CHEST",P_Chest,3)
tab("PLAYER",P_Player,4)
tab("SERVER",P_Server,5)
tab("UPDATES",P_Updates,6)

-- ================= UI ELEMENTS =================
local function toggle(parent,text,flag)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(0.95,0,0,40)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 14
    Instance.new("UICorner", b)
    local function refresh()
        b.Text = text.." : "..(getgenv().Supreme[flag] and "ON" or "OFF")
        b.BackgroundColor3 = getgenv().Supreme[flag] and Color3.fromRGB(0,160,200) or Color3.fromRGB(40,40,50)
        b.TextColor3 = Color3.new(1,1,1)
    end
    refresh()
    b.MouseButton1Click:Connect(function()
        getgenv().Supreme[flag] = not getgenv().Supreme[flag]
        refresh()
    end)
end

local function info(parent,text)
    local t = Instance.new("TextLabel", parent)
    t.Size = UDim2.new(0.95,0,0,38)
    t.BackgroundTransparency = 1
    t.TextWrapped = true
    t.Text = text
    t.Font = Enum.Font.Gotham
    t.TextSize = 13
    t.TextColor3 = Color3.fromRGB(200,200,210)
end

-- ================= CONTENT =================
toggle(P_Main,"🧲 Fruit Magnet","Magnet")
toggle(P_Main,"👁 Fruit ESP","ESP")
toggle(P_Main,"📦 Auto Store Fruits","AutoStore")
toggle(P_Main,"🖐 Auto Equip","AutoEquip")

toggle(P_Chest,"💰 Auto Chest Farm","AutoChest")

toggle(P_Player,"👻 NoClip","NoClip")
toggle(P_Player,"🛡 God Mode","God")
toggle(P_Player,"🧲 Anti Knockback","AntiKB")

toggle(P_Server,"🔁 Server Hop","ServerHop")
toggle(P_Server,"🧠 Smart Hop","SmartHop")

info(P_Updates,"V28 OMEGA")
info(P_Updates,"• UI Rayfield-like estável")
info(P_Updates,"• Minimize em bolinha funcional")
info(P_Updates,"• Todas abas funcionando")
info(P_Updates,"• Magnet ONLY (sem teleport)")
info(P_Updates,"• NoClip corrigido")
info(P_Updates,"• Performance e estabilidade")

-- ================= CORE LOGIC =================
local lastFruit = os.clock()

RunService.Heartbeat:Connect(function()
    local c = player.Character
    if not c then return end
    local hrp = c:FindFirstChild("HumanoidRootPart")
    local hum = c:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end

    hum.WalkSpeed = getgenv().Supreme.WalkSpeed
    hum.JumpPower = getgenv().Supreme.JumpPower

    for _,t in pairs(workspace:GetChildren()) do
        if t:IsA("Tool") and t.Name:lower():find("fruit") and t:FindFirstChild("Handle") then
            lastFruit = os.clock()
            if getgenv().Supreme.Magnet then
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

RunService.Stepped:Connect(function()
    local c = player.Character
    if not c then return end
    if getgenv().Supreme.NoClip then
        for _,p in pairs(c:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = false end
        end
    end
    if getgenv().Supreme.AntiKB then
        pcall(function() c.HumanoidRootPart.Velocity = Vector3.zero end)
    end
    if getgenv().Supreme.God then
        pcall(function() c.Humanoid.Health = math.huge end)
    end
end)

task.spawn(function()
    while task.wait(getgenv().Supreme.HopDelay) do
        if getgenv().Supreme.ServerHop then
            if not getgenv().Supreme.SmartHop or os.clock()-lastFruit > getgenv().Supreme.HopDelay then
                TeleportService:Teleport(game.PlaceId)
            end
        end
    end
end)

player.Idled:Connect(function()
    VirtualUser:ClickButton2(Vector2.new())
end)

StarterGui:SetCore("SendNotification",{
    Title="Supreme Hub V28",
    Text="Carregado com sucesso 👑",
    Duration=5
})
