-- 👑 SUPREME HUB ELITE V27 — COSMIC SUPREMACY

repeat task.wait() until game:IsLoaded()

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local RS = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local StarterGui = game:GetService("StarterGui")
local VirtualUser = game:GetService("VirtualUser")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer

--------------------------------------------------
-- CONFIG
--------------------------------------------------
getgenv().Supreme = {
    Magnet = true,
    ESP = false,
    AutoEquip = true,
    AutoStore = true,
    Chest = false,

    NoClip = false,
    WalkSpeed = 16,

    Hop = false,
    SmartHop = true,
    HopDelay = 45
}

--------------------------------------------------
-- LOADING SCREEN
--------------------------------------------------
local loadingGui = Instance.new("ScreenGui", player.PlayerGui)
loadingGui.IgnoreGuiInset = true

local bg = Instance.new("Frame", loadingGui)
bg.Size = UDim2.new(1,0,1,0)
bg.BackgroundColor3 = Color3.fromRGB(10,10,14)

local title = Instance.new("TextLabel", bg)
title.Size = UDim2.new(1,0,0,80)
title.Position = UDim2.new(0,0,0.45,0)
title.Text = "SUPREME HUB"
title.Font = Enum.Font.GothamBlack
title.TextSize = 42
title.TextColor3 = Color3.fromRGB(0,180,255)
title.BackgroundTransparency = 1

local sub = Instance.new("TextLabel", bg)
sub.Size = UDim2.new(1,0,0,40)
sub.Position = UDim2.new(0,0,0.55,0)
sub.Text = "loading..."
sub.Font = Enum.Font.Gotham
sub.TextSize = 18
sub.TextColor3 = Color3.fromRGB(200,200,210)
sub.BackgroundTransparency = 1

bg.BackgroundTransparency = 1
title.TextTransparency = 1
sub.TextTransparency = 1

TweenService:Create(bg, TweenInfo.new(0.6), {BackgroundTransparency = 0}):Play()
TweenService:Create(title, TweenInfo.new(0.6), {TextTransparency = 0}):Play()
TweenService:Create(sub, TweenInfo.new(0.6), {TextTransparency = 0}):Play()

task.wait(1.8)

TweenService:Create(bg, TweenInfo.new(0.6), {BackgroundTransparency = 1}):Play()
TweenService:Create(title, TweenInfo.new(0.6), {TextTransparency = 1}):Play()
TweenService:Create(sub, TweenInfo.new(0.6), {TextTransparency = 1}):Play()

task.wait(0.6)
loadingGui:Destroy()

--------------------------------------------------
-- NOTIFY
--------------------------------------------------
local function notify(t, d)
    StarterGui:SetCore("SendNotification", {
        Title = t,
        Text = d,
        Duration = 4
    })
end

--------------------------------------------------
-- GUI
--------------------------------------------------
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.ResetOnSpawn = false

-- MAIN
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0,620,0,460)
main.Position = UDim2.new(0.5,-310,0.5,-230)
main.BackgroundColor3 = Color3.fromRGB(18,18,22)
main.Active = true
main.Draggable = true
Instance.new("UICorner", main)
Instance.new("UIStroke", main).Color = Color3.fromRGB(0,180,255)

-- HEADER
local header = Instance.new("TextLabel", main)
header.Size = UDim2.new(1,0,0,42)
header.Text = "👑 SUPREME HUB ELITE V27 — COSMIC SUPREMACY"
header.Font = Enum.Font.GothamBold
header.TextSize = 17
header.TextColor3 = Color3.fromRGB(0,180,255)
header.BackgroundTransparency = 1

-- MINIMIZE
local min = Instance.new("TextButton", header)
min.Size = UDim2.new(0,30,0,24)
min.Position = UDim2.new(1,-38,0.5,-12)
min.Text = "–"
min.Font = Enum.Font.GothamBold
min.BackgroundColor3 = Color3.fromRGB(30,30,36)
Instance.new("UICorner", min)

-- ORB
local orb = Instance.new("Frame", gui)
orb.Size = UDim2.new(0,52,0,52)
orb.Position = UDim2.new(0,15,0.5,0)
orb.Visible = false
orb.Active = true
orb.Draggable = true
orb.BackgroundColor3 = Color3.fromRGB(20,20,26)
orb.ZIndex = 50
Instance.new("UICorner", orb).CornerRadius = UDim.new(1,0)
Instance.new("UIStroke", orb).Color = Color3.fromRGB(0,180,255)

local orbBtn = Instance.new("TextButton", orb)
orbBtn.Size = UDim2.new(1,0,1,0)
orbBtn.Text = "👑"
orbBtn.TextSize = 24
orbBtn.BackgroundTransparency = 1

min.MouseButton1Click:Connect(function()
    main.Visible = false
    orb.Visible = true
end)

orbBtn.MouseButton1Click:Connect(function()
    main.Visible = true
    orb.Visible = false
end)

--------------------------------------------------
-- CONTENT
--------------------------------------------------
local tabs = Instance.new("Frame", main)
tabs.Position = UDim2.new(0,10,0,50)
tabs.Size = UDim2.new(0,120,1,-60)
tabs.BackgroundColor3 = Color3.fromRGB(22,22,28)
Instance.new("UICorner", tabs)

local pages = Instance.new("Frame", main)
pages.Position = UDim2.new(0,140,0,50)
pages.Size = UDim2.new(1,-150,1,-60)
pages.BackgroundTransparency = 1

local function page(name)
    local f = Instance.new("ScrollingFrame", pages)
    f.Visible = false
    f.CanvasSize = UDim2.new(0,0,0,700)
    f.ScrollBarThickness = 4
    f.BackgroundTransparency = 1
    local l = Instance.new("UIListLayout", f)
    l.Padding = UDim.new(0,10)
    l.HorizontalAlignment = Enum.HorizontalAlignment.Center
    return f
end

local Farm = page("Farm")
local PlayerTab = page("Player")
local Server = page("Server")
local Info = page("Info")
Farm.Visible = true

local function tab(text, p)
    local b = Instance.new("TextButton", tabs)
    b.Size = UDim2.new(1,-10,0,34)
    b.Position = UDim2.new(0,5,0,5 + (#tabs:GetChildren()-1)*38)
    b.Text = text
    b.Font = Enum.Font.GothamBold
    b.TextSize = 13
    b.BackgroundColor3 = Color3.fromRGB(32,32,38)
    Instance.new("UICorner", b)

    b.MouseButton1Click:Connect(function()
        for _,v in pairs(pages:GetChildren()) do v.Visible = false end
        p.Visible = true
    end)
end

tab("FARM", Farm)
tab("PLAYER", PlayerTab)
tab("SERVER", Server)
tab("INFO", Info)

--------------------------------------------------
-- UI ELEMENTS
--------------------------------------------------
local function toggle(parent, text, flag)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(0.95,0,0,40)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 14
    Instance.new("UICorner", b)

    local function refresh()
        b.Text = text.." : "..(getgenv().Supreme[flag] and "ON" or "OFF")
        b.BackgroundColor3 = getgenv().Supreme[flag]
            and Color3.fromRGB(0,160,220)
            or Color3.fromRGB(34,34,40)
    end
    refresh()

    b.MouseButton1Click:Connect(function()
        getgenv().Supreme[flag] = not getgenv().Supreme[flag]
        refresh()
    end)
end

--------------------------------------------------
-- FARM
--------------------------------------------------
toggle(Farm,"🧲 Fruit Magnet","Magnet")
toggle(Farm,"👁 Fruit ESP","ESP")
toggle(Farm,"🖐 Auto Equip","AutoEquip")
toggle(Farm,"📦 Auto Store","AutoStore")
toggle(Farm,"💰 Auto Chest","Chest")

--------------------------------------------------
-- PLAYER
--------------------------------------------------
toggle(PlayerTab,"👻 NoClip","NoClip")

--------------------------------------------------
-- SERVER
--------------------------------------------------
toggle(Server,"🔁 Server Hop","Hop")
toggle(Server,"🧠 Smart Hop","SmartHop")

--------------------------------------------------
-- INFO
--------------------------------------------------
local info = Instance.new("TextLabel", Info)
info.Size = UDim2.new(0.95,0,0,200)
info.TextWrapped = true
info.Text =
"SUPREME HUB V27\n\n"..
"• UI Rayfield-like\n"..
"• Tela de loading animada\n"..
"• Fruit system completo\n"..
"• Smart Server Hop\n"..
"• Código limpo e estável\n\n"..
"Cosmic Supremacy Edition 👑"
info.Font = Enum.Font.Gotham
info.TextSize = 14
info.TextColor3 = Color3.fromRGB(200,200,210)
info.BackgroundTransparency = 1

--------------------------------------------------
-- CORE LOGIC
--------------------------------------------------
local lastFruit = os.clock()

RunService.Heartbeat:Connect(function()
    local c = player.Character
    local hrp = c and c:FindFirstChild("HumanoidRootPart")
    local hum = c and c:FindFirstChildOfClass("Humanoid")
    if not hrp then return end

    if hum then hum.WalkSpeed = getgenv().Supreme.WalkSpeed end

    for _,t in pairs(workspace:GetChildren()) do
        if t:IsA("Tool") and t:FindFirstChild("Handle")
        and t.Name:lower():find("fruit") then

            lastFruit = os.clock()

            if getgenv().Supreme.Magnet then
                t.Handle.CFrame = hrp.CFrame
                t.Handle.Velocity = Vector3.zero
            end

            if getgenv().Supreme.AutoEquip and hum then
                hum:EquipTool(t)
            end

            if getgenv().Supreme.AutoStore then
                pcall(function()
                    RS.Remotes.CommF_:InvokeServer("StoreFruit", t.Name)
                end)
            end

            if getgenv().Supreme.ESP and not t:FindFirstChild("Highlight") then
                local h = Instance.new("Highlight", t)
                h.FillColor = Color3.fromRGB(255,80,80)
                h.OutlineColor = Color3.new(1,1,1)
            end

            if not getgenv().Supreme.ESP and t:FindFirstChild("Highlight") then
                t.Highlight:Destroy()
            end
        end
    end
end)

--------------------------------------------------
-- NOCLIP REAL
--------------------------------------------------
RunService.Stepped:Connect(function()
    local c = player.Character
    if not c then return end
    for _,p in pairs(c:GetDescendants()) do
        if p:IsA("BasePart") then
            p.CanCollide = not getgenv().Supreme.NoClip
        end
    end
end)

--------------------------------------------------
-- SMART HOP
--------------------------------------------------
task.spawn(function()
    while task.wait(getgenv().Supreme.HopDelay) do
        if getgenv().Supreme.Hop then
            if not getgenv().Supreme.SmartHop
            or (os.clock()-lastFruit) > getgenv().Supreme.HopDelay then
                TeleportService:Teleport(game.PlaceId)
            end
        end
    end
end)

--------------------------------------------------
-- ANTI AFK
--------------------------------------------------
player.Idled:Connect(function()
    VirtualUser:ClickButton2(Vector2.new())
end)

notify("Supreme Hub V27","Cosmic Supremacy carregada 👑")
