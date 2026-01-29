-- Script Completo: Fruit Sniper Inteligente + Auto Chest
-- Teleporta frutas e baús até o jogador

local player = game.Players.LocalPlayer
local hrp = player.Character:WaitForChild("HumanoidRootPart")

-- Lista de frutas já coletadas
local collectedFruits = {}

-- 🍇 Função para puxar frutas
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

-- 💰 Função para puxar baús
function AutoChest()
    for _, chest in pairs(workspace:GetChildren()) do
        if chest.Name:lower():find("chest") then
            if chest:IsA("Model") and chest:FindFirstChild("PrimaryPart") then
                chest.PrimaryPart.CFrame = hrp.CFrame + Vector3.new(math.random(-5,5),0,math.random(-5,5))
                print("💰 Baú puxado:", chest.Name)
            elseif chest:FindFirstChild("HumanoidRootPart") then
                chest.HumanoidRootPart.CFrame = hrp.CFrame + Vector3.new(math.random(-5,5),0,math.random(-5,5))
                print("💰 Baú puxado:", chest.Name)
            end
        end
    end
end

-- 🔄 Loop automático
spawn(function()
    while true do
        FruitSniper()   -- puxa frutas
        AutoChest()     -- puxa baús
        wait(5)         -- intervalo para não travar
    end
end)
