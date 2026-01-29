local player = game.Players.LocalPlayer
local rs = game:GetService("ReplicatedStorage")
local runService = game:GetService("RunService")

-- Função Roubada: Teleporte Sem Velocidade (Bypass)
local function teleportRoubado(targetCFrame)
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        -- Desativa detecção de queda/velocidade temporariamente
        char.Humanoid:ChangeState(Enum.HumanoidStateType.Physics)
        char.HumanoidRootPart.CFrame = targetCFrame
        task.wait(0.1) -- Delay mínimo para o servidor aceitar a posição
        char.Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
    end
end

-- Função Fruit Master (Puxa, Equipa e Guarda)
local function ultraFruit()
    for _, fruit in pairs(workspace:GetChildren()) do
        if fruit:IsA("Tool") and (fruit.Name:find("Fruit") or fruit:FindFirstChild("Handle")) then
            -- 1. Puxa a fruta pra você
            fruit.Handle.CFrame = player.Character.HumanoidRootPart.CFrame
            task.wait(0.2)
            
            -- 2. Equipa e tenta guardar usando o Remote Oficial
            player.Character.Humanoid:EquipTool(fruit)
            local fruitName = fruit:GetAttribute("FruitName") or fruit.Name
            
            pcall(function()
                -- Remote que comunica direto com o servidor do Blox Fruits
                rs.Remotes.CommF_:InvokeServer("StoreFruit", fruitName, fruit)
            end)
            print("💎 Fruta Roubada e Guardada: " .. fruit.Name)
        end
    end
end

-- Função Chest Aura (Limpa o mapa rápido)
local function ultraChest()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("TouchTransmitter") and v.Parent.Name:find("Chest") then
            local chest = v.Parent
            if chest:IsA("BasePart") then
                -- Teleporta instantâneo
                teleportRoubado(chest.CFrame)
                -- Simula o toque no baú
                firetouchinterest(player.Character.HumanoidRootPart, chest, 0)
                firetouchinterest(player.Character.HumanoidRootPart, chest, 1)
                task.wait(0.1)
            end
        end
    end
end

-- Loop de Alta Velocidade
task.spawn(function()
    while true do
        pcall(ultraFruit)
        pcall(ultraChest)
        task.wait(0.5) -- Meio segundo para o Anti-Cheat não acumular logs
    end
end)
