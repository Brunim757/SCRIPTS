-- CONFIGURAÇÃO GLOBAL
getgenv().FruitScript = false
getgenv().ChestFarm = false
getgenv().MobFarm = false

local player = game.Players.LocalPlayer
local rs = game:GetService("ReplicatedStorage")
local ts = game:GetService("TweenService")

-- 1. INTERFACE DE AVISOS (Captura o retorno do servidor agora)
local function avisar(msg, cor)
    local gui = player.PlayerGui:FindFirstChild("FruitNotify") or Instance.new("ScreenGui", player.PlayerGui)
    gui.Name = "FruitNotify"
    local label = Instance.new("TextLabel", gui)
    label.Size = UDim2.new(0, 280, 0, 45)
    label.Position = UDim2.new(0.5, -140, 0.15, 0)
    label.BackgroundColor3 = cor or Color3.fromRGB(30, 30, 30)
    label.TextColor3 = Color3.new(1, 1, 1)
    label.Text = msg
    label.Font = Enum.Font.SourceSansBold
    label.TextSize = 18
    label.BorderSizePixel = 0
    game:GetService("Debris"):AddItem(label, 3)
end

-- 2. GUI ARRASTÁVEL E MINIMIZÁVEL (Mantida)
local function criarPainel()
    local sg = Instance.new("ScreenGui", player.PlayerGui)
    sg.Name = "PainelMovel"
    
    local main = Instance.new("Frame", sg)
    main.Size = UDim2.new(0, 180, 0, 240)
    main.Position = UDim2.new(0.1, 0, 0.4, 0)
    main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    main.Active = true
    main.Draggable = true 

    local miniBtn = Instance.new("TextButton", sg)
    miniBtn.Size = UDim2.new(0, 45, 0, 45)
    miniBtn.Position = main.Position
    miniBtn.Text = "MENU"
    miniBtn.Visible = false
    miniBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    miniBtn.Draggable = true

    local close = Instance.new("TextButton", main)
    close.Size = UDim2.new(0, 30, 0, 30)
    close.Position = UDim2.new(1, -30, 0, 0)
    close.Text = "_"
    close.TextColor3 = Color3.new(1,1,1)
    close.BackgroundTransparency = 0.5

    close.MouseButton1Click:Connect(function()
        main.Visible = false
        miniBtn.Position = main.Position
        miniBtn.Visible = true
    end)

    miniBtn.MouseButton1Click:Connect(function()
        main.Visible = true
        main.Position = miniBtn.Position
        miniBtn.Visible = false
    end)

    local function criarBotao(texto, pos, var)
        local btn = Instance.new("TextButton", main)
        btn.Size = UDim2.new(0, 160, 0, 40)
        btn.Position = pos
        btn.Text = texto .. ": OFF"
        btn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.MouseButton1Click:Connect(function()
            getgenv()[var] = not getgenv()[var]
            btn.Text = texto .. (getgenv()[var] and ": ON" or ": OFF")
            btn.BackgroundColor3 = getgenv()[var] and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
        end)
    end

    criarBotao("FRUTAS", UDim2.new(0, 10, 0, 40), "FruitScript")
    criarBotao("BAÚS", UDim2.new(0, 10, 0, 90), "ChestFarm")
    criarBotao("MOBS", UDim2.new(0, 10, 0, 140), "MobFarm")
end

-- 3. LOOP DE FARM E TELEPORTE
task.spawn(function()
    criarPainel()
    while true do
        pcall(function()
            local char = player.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end

            -- SNIPER FRUTAS (Teleporte e Verificação)
            if getgenv().FruitScript then
                for _, f in pairs(workspace:GetChildren()) do
                    if f:IsA("Tool") and (f.Name:find("Fruit") or f:FindFirstChild("Handle")) then
                        f.Handle.CFrame = hrp.CFrame
                        task.wait(0.3)
                        char.Humanoid:EquipTool(f)
                        task.wait(0.3)
                        
                        -- Tenta guardar e captura se funcionou
                        local nomeFruta = f:GetAttribute("FruitName") or f.Name
                        local guardou = rs.Remotes.CommF_:InvokeServer("StoreFruit", nomeFruta, f)
                        
                        if guardou then
                            avisar("✅ GUARDADA: " .. nomeFruta, Color3.new(0, 0.7, 0))
                        else
                            avisar("❌ JÁ POSSUI: " .. nomeFruta, Color3.new(0.7, 0, 0))
                        end
                    end
                end
            end

            -- FARM BAÚS (Busca Segura)
            if getgenv().ChestFarm then
                for _, v in pairs(workspace:GetDescendants()) do
                    if getgenv().ChestFarm and v.Name:find("Chest") and v:IsA("BasePart") and v.Transparency == 0 then
                        hrp.CFrame = v.CFrame
                        task.wait(2) -- Teleporte lento conforme pedido
                        firetouchinterest(hrp, v, 0)
                        firetouchinterest(hrp, v, 1)
                        break -- Pega um por vez para respeitar os 2 segundos
                    end
                end
            end

            -- FARM MOBS (Maior Level)
            if getgenv().MobFarm then
                local target, ml = nil, 0
                for _, m in pairs(workspace.Enemies:GetChildren()) do
                    if m:FindFirstChild("Humanoid") and m:FindFirstChild("Level") and m.Humanoid.Health > 0 then
                        if m.Level.Value > ml then ml = m.Level.Value; target = m end
                    end
                end
                
                if target and target:FindFirstChild("HumanoidRootPart") then
                    hrp.CFrame = target.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0)
                    game:GetService("VirtualUser"):Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                    task.wait(2)
                end
            end
        end)
        task.wait(1)
    end
end)
