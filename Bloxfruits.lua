-- Script Completo: Fruit Sniper Inteligente + Auto Chest Teleport
-- Teleporta frutas até você e teleporta você até os baús

local player = game.Players.LocalPlayer
local hrp = player.Character:WaitForChild("HumanoidRootPart")

-- Lista de frutas já coletadas
local collectedFruits = {}

-- 🍇 Função para frutas
function FruitSniper()
    for _, fruit in pairs(workspace:GetChildren()) do
        if fruit:IsA("Tool") and fruit:FindFirstChild("Handle") then
            if not collectedFruits[fruit.Name] then
                -- Teleporta fruta até você
                fruit.Handle.CFrame = hrp.CFrame + Vector3.new(0,3,0)
                collectedFruits[fruit.Name] = true
                print("🍇 Nova fruta coletada:", fruit.Name)
            else
                -- Já coletada, descarta
                fruit:Destroy()
                print("🗑️ Fruta duplicada descartada:", fruit.Name)
            end
        end
    end
end

-- 💰 Função para baús (teleporta você até cada baú)
function AutoChest()
    for _, chest in pairs(workspace:GetChildren()) do
        if chest.Name:lower():find("chest") then
            local target = nil
            if chest:IsA("Model") and chest:FindFirstChild("PrimaryPart") then
                target = chest.PrimaryPart
            elseif chest:FindFirstChild("HumanoidRootPart") then
                target = chest.HumanoidRootPart
            end
            if target then
                hrp.CFrame = target.CFrame + Vector3.new(0,3,0)
                wait(0.5) -- pequeno delay para coletar
                print("💰 Teleportado para baú:", chest.Name)
            end
        end
    end
end

-- 🔄 Loop automático
spawn(function()
    while true do
        FruitSniper()   -- pega frutas
        AutoChest()     -- teleporta para baús
        wait(5)         -- intervalo para não travar
    end
end)
