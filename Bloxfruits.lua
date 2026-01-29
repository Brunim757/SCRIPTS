local player = game.Players.LocalPlayer
local rs = game:GetService("ReplicatedStorage")
local starterGui = game:GetService("StarterGui")

-- Função para mandar avisos no canto da tela
local function avisar(titulo, msg)
    starterGui:SetCore("SendNotification", {
        Title = titulo;
        Text = msg;
        Duration = 3;
    })
end

-- Teleporte "Blink" (TP Quebrado para enganar o Anti-Cheat)
local function blinkTeleport(targetCFrame)
    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local distance = (targetCFrame.Position - hrp.Position).Magnitude
    if distance > 10 then
        local direction = (targetCFrame.Position - hrp.Position).Unit
        hrp.CFrame = hrp.CFrame + (direction * (distance * 0.5)) -- Salto intermediário
        task.wait(0.05)
    end
    hrp.CFrame = targetCFrame
end

-- Lógica da Fruta (Puxar + Guardar + Notificar)
local function processFruit()
    for _, fruit in pairs(workspace:GetChildren()) do
        if fruit:IsA("Tool") and (fruit.Name:find("Fruit") or fruit:FindFirstChild("Handle")) then
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            
            avisar("🍇 Fruta Detectada!", "Tentando coletar: " .. fruit.Name)
            
            -- Puxa e Equipa
            fruit.Handle.CFrame = hrp.CFrame
            task.wait(0.3)
            player.Character.Humanoid:EquipTool(fruit)
            
            -- Tenta Guardar
            local fruitName = fruit:GetAttribute("FruitName") or fruit.Name
            local success, _ = pcall(function()
                return rs.Remotes.CommF_:InvokeServer("StoreFruit", fruitName, fruit)
            end)
            
            if success then
                avisar("✅ Sucesso", fruit.Name .. " guardada no inventário!")
            else
                avisar("⚠️ Aviso", "Não deu para guardar " .. fruit.Name .. " (Já possui?)")
            end
            task.wait(0.5)
        end
    end
end

-- Farm de Baú (Com delay anti-kick)
local function farmChests()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("TouchTransmitter") and v.Parent.Name:find("Chest") then
            local chest = v.Parent
            if chest:IsA("BasePart") then
                blinkTeleport(chest.CFrame)
                firetouchinterest(player.Character.HumanoidRootPart, chest, 0)
                firetouchinterest(player.Character.HumanoidRootPart, chest, 1)
                task.wait(0.3) -- Delay vital para não ser expulso
            end
        end
    end
end

-- Start
avisar("🚀 Script Ativo", "Criando script de frutas e baús...")

task.spawn(function()
    while true do
        pcall(processFruit)
        pcall(farmChests)
        task.wait(1)
    end
end)
