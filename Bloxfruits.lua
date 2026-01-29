--[[ 
👑 SUPREME HUB V12 – MOBILE EDITION (DRAGGABLE BALL)
📱 Menu Lateral + Aba Update + Botão Bolinha Flutuante
]]

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")

getgenv().SupremeConfig = {
    Enabled = false,
    FactoryFarm = true,
    Webhook = "https://discord.com/api/webhooks/1466207661639864362/E8Emrn_rC15_LJRjZuE0tM3y7JdsbvA8_vBDofO0OWnQ5Batq7KlqxuhwiCXx9cwhsSt"
}

-- ================= FUNÇÃO ARRASTAR (MOBILE SAFE) =================
local function makeDraggable(frame)
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
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

-- ================= GUI CUSTOM V12 =================
local sg = Instance.new("ScreenGui", player.PlayerGui); sg.ResetOnSpawn = false; sg.Name = "SupremeHub"

-- Criando a Bolinha (Minimizado)
local ball = Instance.new("Frame", sg)
ball.Size = UDim2.new(0, 50, 0, 50); ball.Position = UDim2.new(0, 10, 0.5, 0)
ball.BackgroundColor3 = Color3.fromRGB(20, 20, 20); ball.Visible = false
ball.ZIndex = 10; Instance.new("UICorner", ball).CornerRadius = UDim.new(1, 0)
local ballStroke = Instance.new("UIStroke", ball); ballStroke.Color = Color3.fromRGB(0, 255, 150); ballStroke.Thickness = 2
local ballIcon = Instance.new("TextLabel", ball)
ballIcon.Size = UDim2.new(1, 0, 1, 0); ballIcon.Text = "👑"; ballIcon.TextColor3 = Color3.new(1,1,1); ballIcon.TextSize = 25; ballIcon.BackgroundTransparency = 1
local ballBtn = Instance.new("TextButton", ball)
ballBtn.Size = UDim2.new(1, 0, 1, 0); ballBtn.BackgroundTransparency = 1; ballBtn.Text = ""

-- Menu Principal
local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 350, 0, 250); main.Position = UDim2.new(0.5, -175, 0.4, 0)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 15); main.BorderSizePixel = 0
Instance.new("UICorner", main); Instance.new("UIStroke", main).Color = Color3.fromRGB(0, 255, 150)

makeDraggable(main)
makeDraggable(ball)

-- Menu Lateral e Conteúdo
local menu = Instance.new("Frame", main); menu.Size = UDim2.new(0, 100, 1, 0); menu.BackgroundColor3 = Color3.fromRGB(25, 25, 25); Instance.new("UICorner", menu)
local content = Instance.new("Frame", main); content.Size = UDim2.new(1, -110, 1, -10); content.Position = UDim2.new(0, 105, 0, 5); content.BackgroundTransparency = 1

local function clear() for _, v in pairs(content:GetChildren()) do v:Destroy() end end

local function showMain()
    clear()
    local l = Instance.new("UIListLayout", content); l.Padding = UDim.new(0,8)
    local function createTgl(txt, cfg)
        local b = Instance.new("TextButton", content)
        b.Size = UDim2.new(1, 0, 0, 40); b.BackgroundColor3 = getgenv().SupremeConfig[cfg] and Color3.fromRGB(0,150,0) or Color3.fromRGB(150,0,0)
        b.Text = txt..": "..(getgenv().SupremeConfig[cfg] and "ON" or "OFF"); b.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", b)
        b.MouseButton1Click:Connect(function()
            getgenv().SupremeConfig[cfg] = not getgenv().SupremeConfig[cfg]
            b.Text = txt..": "..(getgenv().SupremeConfig[cfg] and "ON" or "OFF")
            b.BackgroundColor3 = getgenv().SupremeConfig[cfg] and Color3.fromRGB(0,150,0) or Color3.fromRGB(150,0,0)
        end)
    end
    createTgl("FRUIT MAGNET", "Enabled")
    createTgl("AUTO FACTORY", "FactoryFarm")
    
    local min = Instance.new("TextButton", content); min.Size = UDim2.new(1, 0, 0, 40); min.Text = "MINIMIZAR HUB"; min.BackgroundColor3 = Color3.fromRGB(40,40,40); min.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", min)
    min.MouseButton1Click:Connect(function() main.Visible = false; ball.Visible = true end)
end

local function showUpdates()
    clear()
    local log = Instance.new("TextLabel", content); log.Size = UDim2.new(1, 0, 1, 0); log.BackgroundTransparency = 1; log.TextColor3 = Color3.new(0.8, 0.8, 0.8); log.TextSize = 13; log.Font = "SourceSansItalic"; log.TextXAlignment = "Left"; log.TextYAlignment = "Top"; log.TextWrapped = true
    log.Text = "🚀 [VERSÃO V12]\n\n• BOTÃO BOLINHA: Arraste o menu ou a bolinha para qualquer lugar.\n• DRAGGABLE SYSTEM: Otimizado para Delta Mobile.\n• AUTO FACTORY: Ataca o Core no Sea 2.\n• MAGNET: Coleta instantânea de qualquer fruta."
end

local b1 = Instance.new("TextButton", menu); b1.Size = UDim2.new(1, -10, 0, 35); b1.Position = UDim2.new(0, 5, 0, 10); b1.Text = "INÍCIO"; b1.BackgroundColor3 = Color3.fromRGB(40,40,40); b1.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", b1); b1.MouseButton1Click:Connect(showMain)
local b2 = Instance.new("TextButton", menu); b2.Size = UDim2.new(1, -10, 0, 35); b2.Position = UDim2.new(0, 5, 0, 50); b2.Text = "UPDATE"; b2.BackgroundColor3 = Color3.fromRGB(40,40,40); b2.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", b2); b2.MouseButton1Click:Connect(showUpdates)

ballBtn.MouseButton1Click:Connect(function() main.Visible = true; ball.Visible = false end)
showMain()

-- ================= LÓGICA DE COLETA & FÁBRICA =================
task.spawn(function()
    while true do
        task.wait(0.1)
        if getgenv().SupremeConfig.Enabled then
            for _, tool in pairs(workspace:GetChildren()) do
                if tool:IsA("Tool") and tool:FindFirstChild("Handle") and tool.Name:lower():find("fruit") then
                    local char = player.Character
                    if char and char:FindFirstChild("HumanoidRootPart") then
                        tool.Handle.CanCollide = false
                        repeat tool.Handle.CFrame = char.HumanoidRootPart.CFrame; char.Humanoid:EquipTool(tool); task.wait() until tool.Parent == char or not getgenv().SupremeConfig.Enabled
                        task.spawn(function() task.wait(0.6); RS.Remotes.CommF_:InvokeServer("StoreFruit", tool.Name) end)
                    end
                end
            end
        end
        if getgenv().SupremeConfig.FactoryFarm then
            local f = workspace:FindFirstChild("Factory"); local core = f and f:FindFirstChild("Core")
            if core and core:FindFirstChild("Humanoid") and core.Humanoid.Health > 0 then
                player.Character.HumanoidRootPart.CFrame = core.CFrame * CFrame.new(0, 15, 0)
                RS.Remotes.CommF_:InvokeServer("Attack", core)
            end
        end
    end
end)
