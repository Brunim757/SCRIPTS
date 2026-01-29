-- CONFIGURAÇÃO GLOBAL
getgenv().FruitScript = false
getgenv().ChestFarm = false
getgenv().MobFarm = false

local player = game.Players.LocalPlayer
local rs = game:GetService("ReplicatedStorage")
local vu = game:GetService("VirtualUser")

-- 1. INTERFACE DE AVISOS
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

-- 2. GUI (Ajustada para Blox Fruits)
local function criarPainel()
    local sg = Instance.new("ScreenGui", player.PlayerGui)
    sg.Name = "PainelMovel"
    local main = Instance.new("Frame", sg)
    main.Size = UDim2.new(0, 180, 0, 240)
    main.Position = UDim2.new(0.1, 0, 0.4, 0)
    main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    main.Active = true
    main.Draggable = true 

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

-- 3. LOOP PRINCIPAL (CORREÇÃO BLOX FRUITS)
task.spawn(function()
    criarPainel()
    while true do
        task.wait(0.1)
        pcall(function()
            local char = player.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end

            -- FARM MOBS (Usa o item na mão)
            if getgenv().MobFarm then
                -- No Blox Fruits, os inimigos ficam na pasta 'Enemies' ou direto no Workspace
                local inimigos = workspace:FindFirstChild("Enemies") or workspace
                for _, m in pairs(inimigos:GetChildren()) do
                    if m:IsA("Model") and m:FindFirstChild("Humanoid") and m.Humanoid.Health > 0 then
                        repeat
                            if not getgenv().MobFarm then break end
                            -- Teleporta atrás/cima do mob para não morrer
                            hrp.CFrame = m.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0)
                            -- Ataca com o que estiver na mão
                            vu:CaptureController()
                            vu:ClickButton1(Vector2.new(850, 520))
                            task.wait(0.1)
                        until m.Humanoid.Health <= 0 or not getgenv().MobFarm
                    end
                end
            end

            -- FARM BAÚS (Busca profunda)
            if getgenv().ChestFarm then
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("TouchTransmitter") and v.Parent.Name:find("Chest") then
                        local bau = v.Parent
                        if bau:IsA("BasePart") then
                            hrp.CFrame = bau.CFrame
                            task.wait(0.5)
                        end
                    end
                end
            end

            -- SNIPER FRUTAS
            if getgenv().FruitScript then
                for _, f in pairs(workspace:GetChildren()) do
                    if f:IsA("Tool") and (f.Name:find("Fruit") or f:FindFirstChild("Handle")) then
                        hrp.CFrame = f.Handle.CFrame
                        task.wait(0.5)
                        char.Humanoid:EquipTool(f)
                        rs.Remotes.CommF_:InvokeServer("StoreFruit", f.Name, f)
                    end
                end
            end
        end)
    end
end)
