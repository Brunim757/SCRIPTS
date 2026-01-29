--[[ 
👑 SUPREME HUB V10 – INSTANT MAGNET
⚡ Coleta Instantânea (Sem Delay para Drops)
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
    Webhook = "https://discord.com" -- Coloque seu Webhook aqui
}

-- ================= NOTIFICADOR =================
local function Notify(msg)
    local notifyGui = player.PlayerGui:FindFirstChild("SupremeNotify") or Instance.new("ScreenGui", player.PlayerGui)
    notifyGui.Name = "SupremeNotify"
    local label = Instance.new("TextLabel", notifyGui)
    label.Size = UDim2.new(0, 280, 0, 35)
    label.Position = UDim2.new(0.5, -140, 0, 30)
    label.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    label.TextColor3 = Color3.fromRGB(0, 255, 150)
    label.Text = "🍎 " .. msg
    label.Font = Enum.Font.SourceSansBold
    label.TextSize = 16
    Instance.new("UICorner", label)
    task.delay(2, function() if label then label:Destroy() end end)
end

-- ================= WEBHOOK PROXY =================
local function sendWebhook(msg)
    if getgenv().SupremeConfig.Webhook == "" or getgenv().SupremeConfig.Webhook == "https://discord.com" then return end
    local proxyURL = getgenv().SupremeConfig.Webhook:gsub("discord.com", "webhook.lewisakura.moe")
    local req = (syn and syn.request) or request or http_request
    if req then
        pcall(function()
            req({
                Url = proxyURL,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = HttpService:JSONEncode({content = msg, username = "Supreme Instant"})
            })
        end)
    end
end

-- ================= GUI NATIVA =================
local sg = Instance.new("ScreenGui", player.PlayerGui)
sg.Name = "SupremeCustomGUI"
sg.ResetOnSpawn = false

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 200, 0, 220)
main.Position = UDim2.new(0.5, -100, 0.3, 0)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
main.Active, main.Draggable = true, true
Instance.new("UICorner", main)

local function createBtn(name, pos, color, callback)
    local btn = Instance.new("TextButton", main)
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.Position = UDim2.new(0.05, 0, 0, pos)
    btn.Text, btn.BackgroundColor3 = name, color
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSansBold
    btn.MouseButton1Click:Connect(function() callback(btn) end)
    Instance.new("UICorner", btn)
    return btn
end

local powerBtn = createBtn("STATUS: OFF", 45, Color3.fromRGB(150, 50, 50), function(btn)
    getgenv().SupremeConfig.Enabled = not getgenv().SupremeConfig.Enabled
    btn.Text = getgenv().SupremeConfig.Enabled and "STATUS: ON" or "STATUS: OFF"
    btn.BackgroundColor3 = getgenv().SupremeConfig.Enabled and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(150, 50, 50)
end)

createBtn("METODO: MAGNET", 90, Color3.fromRGB(50, 50, 50), function(btn)
    getgenv().SupremeConfig.Method = (getgenv().SupremeConfig.Method == "Magnet" and "Tween" or "Magnet")
    btn.Text = "METODO: " .. getgenv().SupremeConfig.Method:upper()
end)

local webInput = Instance.new("TextBox", main)
webInput.Size = UDim2.new(0.9, 0, 0, 30); webInput.Position = UDim2.new(0.05, 0, 0, 135)
webInput.PlaceholderText = "Webhook URL"; webInput.Text = getgenv().SupremeConfig.Webhook
webInput.BackgroundColor3 = Color3.fromRGB(5, 5, 5); webInput.TextColor3 = Color3.new(1,1,1)
webInput.TextScaled = true
webInput.FocusLost:Connect(function() getgenv().SupremeConfig.Webhook = webInput.Text end)

-- ================= LÓGICA DE VELOCIDADE MÁXIMA =================
task.spawn(function()
    while true do
        task.wait(0.1) -- Verificação ultra rápida
        if getgenv().SupremeConfig.Enabled then
            local char = player.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            
            if hrp then
                for _, tool in pairs(workspace:GetChildren()) do
                    if tool:IsA("Tool") and tool:FindFirstChild("Handle") and tool.Name:lower():find("fruit") then
                        local fruitName = tool.Name
                        Notify("⚡ PEGANDO AGORA: " .. fruitName)
                        
                        -- MAGNET INSTANTÂNEO
                        if getgenv().SupremeConfig.Method == "Magnet" then
                            tool.Handle.CanCollide = false
                            -- Força a posição continuamente até equipar
                            local grabTime = tick()
                            repeat
                                tool.Handle.CFrame = hrp.CFrame
                                char.Humanoid:EquipTool(tool)
                                task.wait()
                            until tool.Parent == char or tick() - grabTime > 1.5
                        else
                            -- TWEEN RÁPIDO
                            local dist = (hrp.Position - tool.Handle.Position).Magnitude
                            local tw = TweenService:Create(hrp, TweenInfo.new(dist/100, Enum.EasingStyle.Linear), {CFrame = tool.Handle.CFrame})
                            tw:Play()
                            tw.Completed:Wait()
                            char.Humanoid:EquipTool(tool)
                        end

                        -- TENTA GUARDAR EM SEGUNDO PLANO PARA NÃO PARAR O LOOP
                        task.spawn(function()
                            task.wait(0.3) -- Espera mínima para o server aceitar
                            if RS.Remotes.CommF_:InvokeServer("StoreFruit", fruitName) then
                                sendWebhook("✅ **Guardada:** " .. fruitName)
                                Notify("Sucesso: " .. fruitName)
                            else
                                sendWebhook("⚠️ **Falha/Cheio:** " .. fruitName)
                            end
                        end)
                    end
                end
            end
        end
    end
end)

-- Anti-AFK
player.Idled:Connect(function() VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new()) end)
Notify("Supreme Instant Hub Pronto!")
