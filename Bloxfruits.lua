-- MANTENDO SUA CONFIGURAÇÃO GLOBAL ORIGINAL
getgenv().FruitScript = false
getgenv().ChestFarm = false
getgenv().MobFarm = false

local player = game.Players.LocalPlayer
local rs = game:GetService("ReplicatedStorage")

-- 1. SUA INTERFACE DE AVISOS ORIGINAL (SEM ALTERAÇÕES)
local function avisar(msg, cor)
    local gui = player.PlayerGui:FindFirstChild("FruitNotify") or Instance.new("ScreenGui", player.PlayerGui)
    gui.Name = "FruitNotify"
    local label = Instance.new("TextLabel", gui)
    label.Size = UDim2.new(0, 300, 0, 50)
    label.Position = UDim2.new(0.5, -150, 0.2, 0)
    label.BackgroundColor3 = cor or Color3.fromRGB(30, 30, 30)
    label.TextColor3 = Color3.new(1, 1, 1)
    label.Text = msg
    label.Font = Enum.Font.SourceSansBold
    label.TextSize = 20
    game:GetService("Debris"):AddItem(label, 3)
end

-- 2. NOVA GUI DE CONFIGURAÇÃO (PARA ATIVAR/DESATIVAR)
local function criarPainel()
    local sg = Instance.new("ScreenGui", player.PlayerGui)
    sg.Name = "PainelControle"
    
    local frame = Instance.new("Frame", sg)
    frame.Size = UDim2.new(0, 200, 0, 250)
    frame.Position = UDim2.new(0, 10, 0.3, 0)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    
    local function criarBotao(texto, pos, varGlobal)
        local btn = Instance.new("TextButton", frame)
        btn.Size = UDim2.new(0, 180, 0, 40)
        btn.Position = pos
        btn.Text = texto .. ": OFF"
        btn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
        btn.TextColor3 = Color3.new(1, 1, 1)
        
        btn.MouseButton1Click:Connect(function()
            getgenv()[varGlobal] = not getgenv()[varGlobal]
            btn.Text = texto .. (getgenv()[varGlobal] and ": ON" or ": OFF")
            btn.BackgroundColor3 = getgenv()[varGlobal] and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
        end)
    end

    criarBotao("SNIPER FRUTAS", UDim2.new(0, 10, 0, 10), "FruitScript")
    criarBotao("FARM BAÚS", UDim2.new(0, 10, 0, 60), "ChestFarm")
    criarBotao("FARM MOBS", UDim2.new(0, 10, 0, 110), "MobFarm")
    
    local btnHop = Instance.new("TextButton", frame)
    btnHop.Size = UDim2.new(0, 180, 0, 40)
    btnHop.Position = UDim2.new(0, 10, 0, 160)
    btnHop.Text = "TROCAR SERVER"
    btnHop.BackgroundColor3 = Color3.fromRGB(0, 0, 150)
    btnHop.TextColor3 = Color3.new(1, 1, 1)
    btnHop.MouseButton1Click:Connect(function()
        avisar("🔄 Trocando Servidor...", Color3.new(0, 0, 1))
        game:GetService("TeleportService"):Teleport(game.PlaceId, player)
    end)
end

-- 3. LOGICA INTEGRADA (MANTENDO SEU LOOP E ADICIONANDO REGRAS)
task.spawn(function()
    criarPainel()
    avisar("🚀 Menu Carregado!", Color3.new(0, 0.5, 0))
    
    while true do
        pcall(function()
            -- SNIPER DE FRUTAS (SUA LÓGICA ORIGINAL)
            if getgenv().FruitScript then
                for _, item in pairs(workspace:GetChildren()) do
                    if item:IsA("Tool") and (item.Name:find("Fruit") or item:FindFirstChild("Handle")) then
                        local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            item.Handle.CFrame = hrp.CFrame
                            task.wait(0.3)
                            player.Character.Humanoid:EquipTool(item)
                            local fruitName = item:GetAttribute("FruitName") or item.Name
                            task.wait(0.5)
                            local success = rs.Remotes.CommF_:InvokeServer("StoreFruit", fruitName, item)
                            if success then avisar("✅ GUARDADA: "..fruitName, Color3.new(0, 1, 0)) end
                        end
                    end
                end
            end

            -- TELEPORTE BAÚ (COM ESPERA DE 2 SEGUNDOS)
            if getgenv().ChestFarm then
                for _, v in pairs(workspace:GetDescendants()) do
                    if not getgenv().ChestFarm then break end
                    if v:IsA("TouchTransmitter") and v.Parent.Name:find("Chest") and v.Parent.Transparency == 0 then
                        player.Character.HumanoidRootPart.CFrame = v.Parent.CFrame
                        task.wait(2) -- SUA SOLICITAÇÃO: ESPERA 2 SEG
                        firetouchinterest(player.Character.HumanoidRootPart, v.Parent, 0)
                        firetouchinterest(player.Character.HumanoidRootPart, v.Parent, 1)
                    end
                end
            end

            -- AUTO FARM MOBS MAIS FORTES
            if getgenv().MobFarm then
                local target, maxLvl = nil, 0
                for _, mob in pairs(workspace.Enemies:GetChildren()) do
                    if mob:FindFirstChild("Level") and mob.Level.Value > maxLvl then
                        maxLvl = mob.Level.Value
                        target = mob
                    end
                end
                if target and target:FindFirstChild("HumanoidRootPart") then
                    player.Character.HumanoidRootPart.CFrame = target.HumanoidRootPart.CFrame * CFrame.new(0, 12, 0)
                    game:GetService("VirtualUser"):Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                    task.wait(2) -- ESPERA 2 SEG PARA NÃO DAR KICK
                end
            end
        end)
        task.wait(1)
    end
end)
