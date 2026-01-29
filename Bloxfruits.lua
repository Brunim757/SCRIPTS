--[[ 
👑 SUPREME HUB ELITE V15 - GOD SPEED EDITION
⚡ Velocidade de Resposta: 1ms | Anti-Steal Magnet
]]

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

getgenv().Supreme = {
    Enabled = false,
    Factory = true,
    Webhook = "https://discord.com/api/webhooks/1466207661639864362/E8Emrn_rC15_LJRjZuE0tM3y7JdsbvA8_vBDofO0OWnQ5Batq7KlqxuhwiCXx9cwhsSt",
    FruitsFound = 0,
    StartTime = os.time(),
    ThemeColor = Color3.fromRGB(255, 0, 100) -- Mudei para Rosa Neon para marcar a V15
}

-- ================= SISTEMA DE ARRASTE =================
local function makeDraggable(frame)
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = frame.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    frame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end)
end

-- ================= GUI ELITE V15 =================
local sg = Instance.new("ScreenGui", player.PlayerGui); sg.Name = "SupremeV15"; sg.ResetOnSpawn = false

local ball = Instance.new("Frame", sg)
ball.Size = UDim2.new(0, 50, 0, 50); ball.Position = UDim2.new(0, 10, 0.5, 0); ball.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
ball.Visible = false; ball.ZIndex = 100; Instance.new("UICorner", ball).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", ball).Color = getgenv().Supreme.ThemeColor
local ballBtn = Instance.new("TextButton", ball)
ballBtn.Size = UDim2.new(1, 0, 1, 0); ballBtn.Text = "⚡"; ballBtn.TextColor3 = Color3.new(1,1,1); ballBtn.TextSize = 24; ballBtn.BackgroundTransparency = 1
makeDraggable(ball)

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 480, 0, 300); main.Position = UDim2.new(0.5, -240, 0.5, -150)
main.BackgroundColor3 = Color3.fromRGB(12, 12, 12); main.Active = true; Instance.new("UICorner", main)
Instance.new("UIStroke", main).Color = getgenv().Supreme.ThemeColor
makeDraggable(main)

local side = Instance.new("Frame", main); side.Size = UDim2.new(0, 110, 1, 0); side.BackgroundColor3 = Color3.fromRGB(18, 18, 18); Instance.new("UICorner", side)
local content = Instance.new("ScrollingFrame", main); content.Size = UDim2.new(1, -130, 1, -70); content.Position = UDim2.new(0, 120, 0, 60); content.BackgroundTransparency = 1; content.ScrollBarThickness = 0

-- --- DASHBOARD ---
local function showHome()
    for _, v in pairs(content:GetChildren()) do if v:IsA("GuiObject") then v:Destroy() end end
    local l = Instance.new("UIListLayout", content); l.Padding = UDim.new(0,10)
    
    local function tgl(name, cfg)
        local b = Instance.new("TextButton", content)
        b.Size = UDim2.new(0.95, 0, 0, 40); b.Text = name..": "..(getgenv().Supreme[cfg] and "ON" or "OFF")
        b.BackgroundColor3 = getgenv().Supreme[cfg] and Color3.fromRGB(100, 0, 50) or Color3.fromRGB(30, 30, 30)
        b.TextColor3 = Color3.new(1,1,1); b.Font = "SourceSansBold"; Instance.new("UICorner", b)
        b.MouseButton1Click:Connect(function()
            getgenv().Supreme[cfg] = not getgenv().Supreme[cfg]
            b.Text = name..": "..(getgenv().Supreme[cfg] and "ON" or "OFF")
            b.BackgroundColor3 = getgenv().Supreme[cfg] and Color3.fromRGB(100, 0, 50) or Color3.fromRGB(30, 30, 30)
        end)
    end
    tgl("⚡ GOD SPEED MAGNET", "Enabled")
    tgl("🏭 AUTO FACTORY", "Factory")
    
    local m = Instance.new("TextButton", content); m.Size = UDim2.new(0.95, 0, 0, 40); m.Text = "MINIMIZAR"; m.BackgroundColor3 = Color3.fromRGB(20,20,20); m.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", m)
    m.MouseButton1Click:Connect(function() main.Visible = false; ball.Visible = true end)
end

local function nav(txt, pos, func)
    local b = Instance.new("TextButton", side); b.Size = UDim2.new(1, -10, 0, 35); b.Position = UDim2.new(0, 5, 0, pos)
    b.Text = txt; b.BackgroundColor3 = Color3.fromRGB(25,25,25); b.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(func)
end

nav("INICIO", 15, showHome)
ballBtn.MouseButton1Click:Connect(function() main.Visible = true; ball.Visible = false end)
showHome()

-- ================= LÓGICA DE VELOCIDADE DA LUZ =================
RunService.Heartbeat:Connect(function()
    if not getgenv().Supreme.Enabled then return end
    
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChild("Humanoid")
    
    if hrp and hum then
        for _, tool in pairs(workspace:GetChildren()) do
            if tool:IsA("Tool") and tool:FindFirstChild("Handle") and tool.Name:lower():find("fruit") then
                -- Força bruta: Traz a fruta mil vezes por segundo
                tool.Handle.CanCollide = false
                tool.Handle.Velocity = Vector3.new(0,0,0)
                tool.Handle.CFrame = hrp.CFrame
                
                -- Tenta equipar agressivamente
                hum:EquipTool(tool)
                
                -- Se a fruta entrou na mochila, tenta guardar imediatamente
                if tool.Parent == char or tool.Parent == player.Backpack then
                    task.spawn(function()
                        if RS.Remotes.CommF_:InvokeServer("StoreFruit", tool.Name) then
                            getgenv().Supreme.FruitsFound += 1
                        end
                    end)
                end
            end
        end
    end
end)

-- Auto Factory Solo
task.spawn(function()
    while task.wait(0.1) do
        if getgenv().Supreme.Factory then
            local core = workspace:FindFirstChild("Factory") and workspace.Factory:FindFirstChild("Core")
            if core and core:FindFirstChild("Humanoid") and core.Humanoid.Health > 0 then
                player.Character.HumanoidRootPart.CFrame = core.CFrame * CFrame.new(0, 15, 0)
                RS.Remotes.CommF_:InvokeServer("Attack", core)
            end
        end
    end
end)

player.Idled:Connect(function() game:GetService("VirtualUser"):CaptureController(); game:GetService("VirtualUser"):ClickButton2(Vector2.new()) end)
