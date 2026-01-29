getgenv().ScriptAtivo = true
local player = game.Players.LocalPlayer
local rs = game:GetService("ReplicatedStorage")
local bauProcessando = {}

-- 1. Interface: Botão de Desligar + Notificações
local function criarInterface()
    local gui = Instance.new("ScreenGui", player.PlayerGui)
    gui.Name = "ControleHub"
    
    -- Botão de Desligar
    local btn = Instance.new("TextButton", gui)
    btn.Size = UDim2.new(0, 120, 0, 40)
    btn.Position = UDim2.new(0.5, -60, 0.05, 0)
    btn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    btn.Text = "PARAR SCRIPT"
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 18
    
    -- Label de Status/Notificação
    local status = Instance.new("TextLabel", gui)
    status.Size = UDim2.new(0, 300, 0, 30)
    status.Position = UDim2.new(0.5, -150, 0.12, 0)
    status.BackgroundColor3 = Color3.new(0, 0, 0)
    status.BackgroundTransparency = 0.5
    status.TextColor3 = Color3.new(1, 1, 1)
    status.Text = "Aguardando..."
    
    btn.MouseButton1Click:Connect(function()
        getgenv().ScriptAtivo = false
        gui:Destroy()
    end)
    
    return status
end

local statusLabel = criarInterface()

local function avisar(msg)
    statusLabel.Text = "[LOG]: " .. msg
end

-- 2. Teleporte de 2 Etapas (Evita Security Kick)
local function safeTeleport(targetCFrame)
    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
    if hrp and getgenv().ScriptAtivo then
        hrp.Velocity = Vector3.new(0,0,0)
        -- Passo 1: Chega perto (15 studs acima)
        hrp.CFrame = targetCFrame + Vector3.new(0, 15, 0)
        task.wait(0.6) -- Delay para o Anti-Cheat aceitar
        -- Passo 2: Encosta no baú
        hrp.CFrame = targetCFrame
        task.wait(0.2)
    end
end

-- 3. Loop Principal
task.spawn(function()
    while getgenv().ScriptAtivo do
        -- LÓGICA DE FRUTAS
        for _, tool in pairs(workspace:GetChildren()) do
            if tool:IsA("Tool") and tool:FindFirstChild("Handle") then
                avisar("🍇 Fruta: " .. tool.Name)
                tool.Handle.CFrame = player.Character.HumanoidRootPart.CFrame
                task.wait(0.5)
                player.Character.Humanoid:EquipTool(tool)
                rs.Remotes.CommF_:InvokeServer("StoreFruit", tool.Name, tool)
                task.wait(0.5)
            end
        end

        -- LÓGICA DE BAÚS (Respeita Respawn)
        for _, v in pairs(workspace:GetDescendants()) do
            if not getgenv().ScriptAtivo then break end
            
            if v:IsA("TouchTransmitter") and v.Parent.Name:find("Chest") then
                local bau = v.Parent
                -- Verifica se está fechado (Transparency 0) e fora da blacklist temporária
                if bau:IsA("BasePart") and bau.Transparency == 0 and not bauProcessando[bau] then
                    bauProcessando[bau] = true
                    avisar("💰 Baú Detectado!")
                    
                    safeTeleport(bau.CFrame)
                    firetouchinterest(player.Character.HumanoidRootPart, bau, 0)
                    firetouchinterest(player.Character.HumanoidRootPart, bau, 1)
                    
                    -- Libera o baú da lista após 10 segundos (tempo para ele sumir e resetar)
                    task.delay(10, function() bauProcessando[bau] = nil end)
                    task.wait(0.5)
                end
            end
        end
        task.wait(1)
    end
end)
