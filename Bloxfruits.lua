--[[ 
👑 SUPREME HUB V10 – CUSTOM GUI + NOTIFIER
📱 Interface Nativa + Notificações no Topo + Magnet/Tween
]]

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")

getgenv().SupremeConfig = {
    Enabled = false,
    Method = "Magnet",
    Webhook = "https://discord.com"
}

-- ================= SISTEMA DE NOTIFICAÇÃO (TOPO) =================
local function Notify(msg)
    local notifyGui = player.PlayerGui:FindFirstChild("SupremeNotify") or Instance.new("ScreenGui", player.PlayerGui)
    notifyGui.Name = "SupremeNotify"
    
    local label = Instance.new("TextLabel", notifyGui)
    label.Size = UDim2.new(0, 300, 0, 40)
    label.Position = UDim2.new(0.5, -150, 0, -50) -- Começa fora da tela
    label.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    label.TextColor3 = Color3.fromRGB(0, 255, 127)
    label.Text = "🔔 " .. msg
    label.Font = Enum.Font.SourceSansBold
    label.TextSize = 18
    label.BorderSizePixel = 2
    
    -- Efeito de descer e subir
    label:TweenPosition(UDim2.new(0.5, -150, 0, 20), "Out", "Back", 0.5, true)
    task.delay(3, function()
        label:TweenPosition(UDim2.new(0.5, -150, 0, -50), "In", "Quad", 0.5, true)
        task.wait(0.6)
        label:Destroy()
    end)
end

-- ================= WEBHOOK =================
local function sendWebhook(msg)
    if getgenv().SupremeConfig.Webhook == "" then return end
    local proxyURL = getgenv().SupremeConfig.Webhook:gsub("discord.com", "webhook.lewisakura.moe")
    local req = (syn and syn.request) or request or http_request
    if req then
        pcall(function()
            req({
                Url = proxyURL,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = HttpService:JSONEncode({content = msg, username = "Supreme Hub"})
            })
        end)
    end
end

-- ================= GUI NATIVA =================
local sg = Instance.new("ScreenGui", player.PlayerGui)
sg.Name = "SupremeCustomGUI"
sg.ResetOnSpawn = false

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 220, 0, 220)
main.Position = UDim2.new(0.5, -110, 0.3, 0)
main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true

-- Arredondar bordas
local corner = Instance.new("UICorner", main)
corner.CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 35)
title.Text = "👑 SUPREME HUB V10"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Instance.new("UICorner", title).CornerRadius = UDim.new(0, 10)

local function createBtn(name, pos, color, callback)
    local btn = Instance.new("TextButton", main)
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.Position = UDim2.new(0.05, 0, 0, pos)
    btn.Text = name
    btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSansBold
    btn.MouseButton1Click:Connect(callback)
    Instance.new("UICorner", btn)
    return btn
end

-- Botões
local btnPower = createBtn("STATUS: OFF", 45, Color3.fromRGB(180, 50, 50), function(self)
    getgenv().SupremeConfig.Enabled = not getgenv().SupremeConfig.Enabled
    main:FindFirstChildOfClass("TextButton").Text = getgenv().SupremeConfig.Enabled and "STATUS: ON" or "STATUS: OFF"
    main:FindFirstChildOfClass("TextButton").BackgroundColor3 = getgenv().SupremeConfig.Enabled and Color3.fromRGB(50, 180, 50) or Color3.fromRGB(180, 50, 50)
end)

local btnMethod = createBtn("MÉTODO: MAGNET", 90, Color3.fromRGB(60, 60, 60), function(self)
    getgenv().SupremeConfig.Method = (getgenv().SupremeConfig.Method == "Magnet" and "Tween" or "Magnet")
    for _, v in pairs(main:GetChildren()) do
        if v:IsA("TextButton") and v.Text:find("MÉTODO") then v.Text = "MÉTODO: " .. getgenv().SupremeConfig.Method:upper() end
    end
end)

-- Campo de Webhook
local webInput = Instance.new("TextBox", main)
webInput.Size = UDim2.new(0.9, 0, 0, 30)
webInput.Position = UDim2.new(0.05, 0, 0, 135)
webInput.PlaceholderText = "Cole o Webhook aqui..."
webInput.Text = getgenv().SupremeConfig.Webhook
webInput.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
webInput.TextColor3 = Color3.new(0.8, 0.8, 0.8)
webInput.TextScaled = true
webInput.FocusLost:Connect(function() getgenv().SupremeConfig.Webhook = webInput.Text end)

local btnMin = createBtn("MINIMIZAR", 175, Color3.fromRGB(40, 40, 40), function()
    main.Visible = false
    local open = Instance.new("TextButton", sg)
    open.Size = UDim2.new(0, 45, 0, 45)
    open.Position = UDim2.new(0, 5, 0.5, 0)
    open.Text = "HUB"
    open.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    open.TextColor3 = Color3.new(0, 1, 0)
    Instance.new("UICorner", open).CornerRadius = UDim.new(1, 0)
    open.MouseButton1Click:Connect(function() main.Visible = true open:Destroy() end)
end)

-- ================= LÓGICA DE COLETA =================
task.spawn(function()
    while task.wait(3) do
        if getgenv().SupremeConfig.Enabled then
            for _, tool in pairs(workspace:GetChildren()) do
                if tool:IsA("Tool") and (tool.Name:lower():find("fruit") or tool:FindFirstChild("Handle")) then
                    local char = player.Character
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        Notify("Detectada: " .. tool.Name)
                        if getgenv().SupremeConfig.Method == "Magnet" then
                            local h = tool:FindFirstChild("Handle") or tool:FindFirstChildWhichIsA("Part")
                            if h then
                                h.CanCollide, h.CFrame = false, hrp.CFrame
                                task.wait(0.3)
                                char.Humanoid:EquipTool(tool)
                            end
                        else
                            local dist = (hrp.Position - tool.Handle.Position).Magnitude
                            TweenService:Create(hrp, TweenInfo.new(dist/60), {CFrame = tool.Handle.CFrame}):Play()
                            task.wait(dist/60 + 0.3)
                            char.Humanoid:EquipTool(tool)
                        end
                        task.wait(0.5)
                        local ok = RS.Remotes.CommF_:InvokeServer("StoreFruit", tool.Name)
                        sendWebhook(ok and "✅ **Pego:** " .. tool.Name or "⚠️ **Inventário Cheio:** " .. tool.Name)
                    end
                end
            end
        end
    end
end)

-- Anti-AFK
player.Idled:Connect(function() VirtualUser:CaptureController() VirtualUser:ClickButton2(Vector2.new()) end)
Notify("Supreme Hub Carregado!")
