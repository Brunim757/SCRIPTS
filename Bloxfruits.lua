--[[ 
👑 SUPREME HUB ELITE V21 - BLOX FRUITS
⚡ Motor: God Speed Heartbeat + Auto Chest + Status HUD + Server Info
🔄 Auto-Rejoin: Reconecta em caso de Kick/Crash
📱 Webhook Fixo: Integrado
]]

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")

getgenv().Supreme = {
    Enabled = false,
    ChestFarm = false,
    Webhook = "https://discord.com/api/webhooks/1466207661639864362/E8Emrn_rC15_LJRjZuE0tM3y7JdsbvA8_vBDofO0OWnQ5Batq7KlqxuhwiCXx9cwhsSt",
    FruitsFound = 0,
    StartTime = os.time(),
    ThemeColor = Color3.fromRGB(0, 255, 150),
    Logs = {}
}

-- AUTO REJOIN
game:GetService("CoreGui").RobloxPromptGui.promptOverlay.ChildAdded:Connect(function(child)
    if child.Name == "ErrorPrompt" and child:FindFirstChild("MessageArea") then
        task.wait(5)
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, player)
    end
end)

-- WEBHOOK
local function sendWebhook(msg)
    local proxyURL = getgenv().Supreme.Webhook:gsub("discord.com", "webhook.lewisakura.moe")
    pcall(function()
        (request or http_request)({
            Url = proxyURL, Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode({content = msg, username = "Supreme Elite V21"})
        })
    end)
end

-- GUI estilo Rayfield com Tabs
local sg = Instance.new("ScreenGui", player.PlayerGui); sg.Name = "SupremeV21"; sg.ResetOnSpawn = false
local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 560, 0, 360); main.Position = UDim2.new(0.5, -280, 0.5, -180)
main.BackgroundColor3 = Color3.fromRGB(18, 18, 18); Instance.new("UICorner", main).CornerRadius = UDim.new(0,8)
Instance.new("UIStroke", main).Color = getgenv().Supreme.ThemeColor; Instance.new("UIStroke", main).Thickness = 2

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,40); title.Text = "👑 Supreme Hub Elite V21"; title.TextColor3 = getgenv().Supreme.ThemeColor
title.BackgroundTransparency = 1; title.Font = Enum.Font.GothamBold; title.TextSize = 20

local tabs = Instance.new("Frame", main)
tabs.Size = UDim2.new(1,0,0,30); tabs.Position = UDim2.new(0,0,0,40); tabs.BackgroundTransparency = 1
local tabLayout = Instance.new("UIListLayout", tabs); tabLayout.FillDirection = Enum.FillDirection.Horizontal; tabLayout.Padding = UDim.new(0,8)

local content = Instance.new("Frame", main)
content.Size = UDim2.new(1,-20,1,-80); content.Position = UDim2.new(0,10,0,70)
content.BackgroundTransparency = 1

local function clearContent() for _, v in pairs(content:GetChildren()) do if v:IsA("GuiObject") then v:Destroy() end end end

local function addToggle(name, cfg)
    local b = Instance.new("TextButton", content)
    b.Size = UDim2.new(1, -10, 0, 45)
    b.Text = name..": "..(getgenv().Supreme[cfg] and "ON" or "OFF")
    b.BackgroundColor3 = getgenv().Supreme[cfg] and Color3.fromRGB(0, 150, 100) or Color3.fromRGB(40, 40, 40)
    b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.GothamBold; b.TextSize = 16
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,6)
    b.MouseButton1Click:Connect(function()
        getgenv().Supreme[cfg] = not getgenv().Supreme[cfg]
        b.Text = name..": "..(getgenv().Supreme[cfg] and "ON" or "OFF")
        b.BackgroundColor3 = getgenv().Supreme[cfg] and Color3.fromRGB(0, 150, 100) or Color3.fromRGB(40, 40, 40)
    end)
end

local function showDashboard()
    clearContent()
    addToggle("⚡ GOD SPEED MAGNET", "Enabled")
    addToggle("💰 AUTO CHEST FARM", "ChestFarm")
    local reportBtn = Instance.new("TextButton", content)
    reportBtn.Size = UDim2.new(1,-10,0,40); reportBtn.Text = "📤 Enviar Relatório"
    reportBtn.BackgroundColor3 = Color3.fromRGB(30,30,30); reportBtn.TextColor3 = Color3.new(1,1,1)
    reportBtn.Font = Enum.Font.GothamBold; reportBtn.TextSize = 16; Instance.new("UICorner", reportBtn).CornerRadius = UDim.new(0,6)
    reportBtn.MouseButton1Click:Connect(function() sendWebhook("📊 Relatório: "..table.concat(getgenv().Supreme.Logs, "\n")) end)
end

local function showLogs()
    clearContent()
    local log = Instance.new("TextLabel", content); log.Size = UDim2.new(1, 0, 1, 0)
    log.BackgroundTransparency = 1; log.TextColor3 = Color3.new(0.9, 0.9, 0.9); log.TextSize = 13
    log.Font = Enum.Font.Gotham; log.TextXAlignment = "Left"; log.TextYAlignment = "Top"; log.TextWrapped = true
    log.Text = table.concat(getgenv().Supreme.Logs, "\n")
end

local function showServerInfo()
    clearContent()
    local info = Instance.new("TextLabel", content)
    info.Size = UDim2.new(1,0,1,0); info.BackgroundTransparency = 1
    info.TextColor3 = Color3.new(0.9,0.9,0.9); info.Font = Enum.Font.Gotham; info.TextSize = 14
    RunService.Heartbeat:Connect(function()
        info.Text = "🌐 Server ID: "..game.JobId.."\n👥 Players: "..#Players:GetPlayers().."\n⏱ Ping: "..math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()).." ms"
    end)
end

local function addTab(name, func)
    local b = Instance.new("TextButton", tabs)
    b.Size = UDim2.new(0,120,1,0); b.Text = name
    b.BackgroundColor3 = Color3.fromRGB(35,35,35); b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamBold; b.TextSize = 14; Instance.new("UICorner", b).CornerRadius = UDim.new(0,6)
    b.MouseButton1Click:Connect(func)
end

addTab("Dashboard", showDashboard)
addTab("Logs", showLogs)
addTab("Server Info", showServerInfo)
showDashboard()

-- HUD Status
local statusHUD = Instance.new("TextLabel", main)
statusHUD.Size = UDim2.new(1,0,0,20); statusHUD.Position = UDim2.new(0,0,1,-20)
statusHUD.BackgroundTransparency = 1; statusHUD.TextColor3 = Color3.new(0.9,0.9,0.9)
statusHUD.Font = Enum.Font.Gotham; statusHUD.TextSize = 14
RunService.Heartbeat:Connect(function()
    local elapsed = os.time() - getgenv().Supreme.StartTime
    statusHUD.Text = "⏱ Tempo ativo: "..elapsed.."s | Frutas armazenadas: "..getgenv().Supreme.FruitsFound
end)

-- LÓGICA

-- 1. MOTOR FRUTAS
RunService.Heartbeat:Connect(function()
    if not getgenv().Supreme.Enabled then return end
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        for _, tool in pairs(workspace:GetChildren()) do
            if tool:IsA("Tool") and tool:FindFirstChild("Handle") and tool.Name:lower():find("fruit") then
                tool.Handle.CanCollide = false
                tool.Handle.Velocity = Vector3.new(0,0,0)
                tool.Handle.CFrame = char.HumanoidRootPart.CFrame
                char.Humanoid:EquipTool(tool)
                if tool.Parent == char then
                    RS.Remotes.CommF_:InvokeServer("StoreFruit", tool.Name)
                    getgenv().Supreme.FruitsFound += 1
                    table.insert(getgenv().Supreme.Logs, "🍇 Fruta armazenada: "..tool.Name)
                end
            end
        end
    end
end)

-- 2. AUTO CHEST FARM
task.spawn(function()
    while task.wait(0.5) do
        if getgenv().Supreme.ChestFarm then
            local char = player.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                for _, v in pairs(workspace:GetChildren()) do
                    if v.Name:find("Chest") and v:IsA("Part") then
                        char.HumanoidRootPart.CFrame = v.CFrame
                        table.insert(getgenv().Supreme.Logs, "💰 Chest coletado")
                        task.wait(0.2)
                    end
                end
            end
        end
    end
end)

-- Anti-AFK
player.Idled:Connect(function()
    game:GetService("VirtualUser"):CaptureController()
    game:GetService("VirtualUser"):ClickButton2(Vector2.new())
end)

-- Relatório inicial
sendWebhook("✅ Supreme Hub V21 Carregado! Monitorando servidor.")
