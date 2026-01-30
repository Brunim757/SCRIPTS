-- 👑 SUPREME HUB ELITE V23 — NEBULA EDITION (MAGNET ONLY | ULTRA POLISHED)

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
local TweenService = game:GetService("TweenService")

-- CONFIG
getgenv().Supreme = {
    Fruits = false,
    Magnet = true,        -- magnet padrão ON
    ESP = false,
    Chest = false,
    Hop = false,
    SmartHop = true,      -- só hopa se não achar fruta
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

-- WEBHOOK
local function webhook(msg)
    pcall(function()
        (request or http_request)({
            Url = getgenv().Supreme.Webhook:gsub("discord.com","webhook.lewisakura.moe"),
            Method = "POST",
            Headers = {["Content-Type"]="application/json"},
            Body = HttpService:JSONEncode({content = msg, username = "Supreme Hub V23"})
        })
    end)
end

-- NOTIFY
local function notify(txt)
    StarterGui:SetCore("SendNotification", {
        Title = "Supreme Hub V23",
        Text = txt,
        Duration = 4
    })
end

-- GUI ROOT
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "SupremeV23"
gui.ResetOnSpawn = false

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0,600,0,470)
main.Position = UDim2.new(0.5,-300,0.5,-235)
main.BackgroundColor3 = Color3.fromRGB(12,12,14)
main.Active = true
Instance.new("UICorner", main)
local stroke = Instance.new("UIStroke", main)
stroke.Color = getgenv().Supreme.Theme
stroke.Thickness = 1.5

-- HEADER
local header = Instance.new("TextLabel", main)
header.Size = UDim2.new(1,0,0,48)
header.BackgroundTransparency = 1
header.Text = "👑 SUPREME HUB ELITE V23 — NEBULA"
header.TextColor3 = getgenv().Supreme.Theme
header.Font = Enum.Font.GothamBold
header.TextSize = 22

-- TABS
local tabs = Instance.new("Frame", main)
tabs.Position = UDim2.new(0,10,0,52)
tabs.Size = UDim2.new(0,120,1,-62)
tabs.BackgroundColor3 = Color3.fromRGB(18,18,22)
Instance.new("UICorner", tabs)

local pages = Instance.new("Frame", main)
pages.Position = UDim2.new(0,140,0,52)
pages.Size = UDim2.new(1,-150,1,-62)
pages.BackgroundTransparency = 1

local function makePage(name)
    local f = Instance.new("ScrollingFrame", pages)
    f.Name = name
    f.Visible = false
    f.CanvasSize = UDim2.new(0,0,0,900)
    f.ScrollBarThickness = 3
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

local function tabBtn(txt, page)
    local b = Instance.new("TextButton", tabs)
    b.Size = UDim2.new(1,-10,0,36)
    b.Position = UDim2.new(0,5,0,5 + (#tabs:GetChildren()-1)*40)
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
        b.BackgroundColor3 = getgenv().Supreme[flag] and getgenv().Supreme.Accent or Color3.fromRGB(32,32,38)
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
toggle(P_Main, "🧲 Fruit Magnet", "Magnet")
toggle(P_Main, "⚡ God Speed Fruits", "Fruits")
toggle(P_Main, "👁 ESP Fruits", "ESP")
toggle(P_Main, "💰 Auto Chest", "Chest")
toggle(P_Main, "📦 Auto Store Fruits", "AutoStore")
toggle(P_Main, "🖐 Auto Equip", "AutoEquip")

-- PLAYER
toggle(P_Player, "👻 NoClip", "NoClip")
toggle(P_Player, "🛡 God Mode", "God")
toggle(P_Player, "🧲 Anti Knockback", "AntiKB")
toggle(P_Player, "🚀 FPS Boost", "FPSBoost")

-- SERVER
toggle(P_Server, "🔁 Auto Server Hop", "Hop")
toggle(P_Server, "🧠 Smart Hop", "SmartHop")
info(P_Server, "Smart Hop: só troca de server se nenhuma fruta spawnar.")

-- VISUAL
info(P_Visual, "Tema Nebula • UI refinada • Animações suaves")

-- UPDATES
info(P_Updates, "V23 — Nebula Edition")
info(P_Updates, "• UI com abas")
info(P_Updates, "• Smart Hop inteligente")
info(P_Updates, "• Magnet padrão ON (sem teleport)")
info(P_Updates, "• FPS Boost opcional")
info(P_Updates, "• Estabilidade e performance melhoradas")

-- KEYBIND
UIS.InputBegan:Connect(function(i,gp)
    if not gp and i.KeyCode == Enum.KeyCode.RightShift then
        main.Visible = not main.Visible
    end
end)

-- CORE LOOP (FRUITS + MAGNET)
local lastFruit = 0
RunService.Heartbeat:Connect(function()
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end

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
            if getgenv().Supreme.ESP and not t:FindFirstChild("Highlight") then
                local h = Instance.new("Highlight", t)
                h.FillColor = Color3.fromRGB(255,90,90)
                h.OutlineColor = Color3.new(1,1,1)
            end
        end
    end
end)

-- NOCLIP / GOD / ANTI KB / FPS
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

-- AUTO HOP (SMART)
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

notify("V23 Nebula carregada — Magnet ON, Smart Hop ativo ✨")
webhook("👑 Supreme Hub V23 Nebula iniciado")
