-- SUPREME HUB ELITE V21 SLIM - BLOX FRUITS

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

-- DRAGGABLE
local function makeDraggable(frame)
    local dragging, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = frame.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                      startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    frame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
end

-- GUI
local sg = Instance.new("ScreenGui", player.PlayerGui); sg.Name = "SupremeV21"; sg.ResetOnSpawn = false

local ball = Instance.new("Frame", sg)
ball.Size = UDim2.new(0, 50, 0, 50); ball.Position = UDim2.new(0, 10, 0.5, 0)
ball.BackgroundColor3 = Color3.fromRGB(15, 15, 15); ball.Visible = false; ball.ZIndex = 100
Instance.new("UICorner", ball).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", ball).Color = getgenv().Supreme.ThemeColor
local ballBtn = Instance.new("TextButton", ball)
ballBtn.Size = UDim2.new(1, 0, 1, 0); ballBtn.Text = "👑"; ballBtn.TextColor3 = Color3.new(1,1,1)
ballBtn.TextSize = 24; ballBtn.BackgroundTransparency = 1
makeDraggable(ball)

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 520, 0, 340); main.Position = UDim2.new(0.5, -260, 0.5, -170)
main.BackgroundColor3 = Color3.fromRGB(18, 18, 18); Instance.new("UICorner", main).CornerRadius = UDim.new(0,8)
Instance.new("UIStroke", main).Color = getgenv().Supreme.ThemeColor
makeDraggable(main)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,40); title.Text = "👑 Supreme Hub Elite V21"; title.TextColor3 = getgenv().Supreme.ThemeColor
title.BackgroundTransparency = 1; title.Font = Enum.Font.GothamBold; title.TextSize = 20

local content = Instance.new("ScrollingFrame", main)
content.Size = UDim2.new(1,-20,1,-60); content.Position = UDim2.new(0,10,0,50)
content.BackgroundTransparency = 1; content.ScrollBarThickness = 4
Instance.new("UIListLayout", content).Padding = UDim.new(0,8)

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

-- Dashboard
addToggle("⚡ GOD SPEED MAGNET", "Enabled")
addToggle("💰 AUTO CHEST FARM", "ChestFarm")

local reportBtn = Instance.new("TextButton", content)
reportBtn.Size = UDim2.new(1,-10,0,40); reportBtn.Text = "📤 Enviar Relatório"
reportBtn.BackgroundColor3 = Color3.fromRGB(30,30,30); reportBtn.TextColor3 = Color3.new(1,1,1)
reportBtn.Font = Enum.Font.GothamBold; reportBtn.TextSize = 16; Instance.new("UICorner", reportBtn).CornerRadius = UDim.new(0,6)
reportBtn.MouseButton1Click:Connect(function() sendWebhook("📊 Relatório: "..table.concat(getgenv().Supreme.Logs, "\n")) end)

local minimizeBtn = Instance.new("TextButton", content)
minimizeBtn.Size = UDim2.new(1,-10,0,40); minimizeBtn.Text = "➖ Minimizar"
minimizeBtn.BackgroundColor3 = Color3.fromRGB(30,30,30); minimizeBtn.TextColor3 = Color3.new(1,1,1)
minimizeBtn.Font = Enum.Font.GothamBold; minimizeBtn.TextSize = 16; Instance.new("UICorner", minimizeBtn).CornerRadius = UDim.new(0,6)
minimizeBtn.MouseButton1Click:Connect(function() main.Visible = false; ball.Visible = true end)

ballBtn.MouseButton1Click:Connect(function() main.Visible = true; ball.Visible = false end)

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

-- 3. ANTI-AFK
player.Idled:Connect(function()
    game:GetService("VirtualUser"):CaptureController()
    game:GetService("VirtualUser"):ClickButton2(Vector2.new())
end)

-- 4. RELATÓRIO INICIAL
sendWebhook("✅ Supreme Hub V21 Slim Carregado! Monitorando servidor.")
