-- INTERRUPTOR: Mude para false para desligar manualmente ou use o botão
getgenv().ScriptAtivo = true 

local player = game.Players.LocalPlayer
local rs = game:GetService("ReplicatedStorage")

-- 1. Botão Visual para Desligar (Mobile/PC)
local function criarBotaoSair()
    local sg = Instance.new("ScreenGui", player.PlayerGui)
    sg.Name = "ControleScript"
    local btn = Instance.new("TextButton", sg)
    btn.Size = UDim2.new(0, 100, 0, 50)
    btn.Position = UDim2.new(0, 10, 0.5, 0)
    btn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    btn.Text = "DESLIGAR"
    btn.TextColor3 = Color3.new(1, 1, 1)
    
    btn.MouseButton1Click:Connect(function()
        getgenv().ScriptAtivo = false
        sg:Destroy()
        print("🛑 Script encerrado pelo usuário.")
    end)
end

-- 2. Teleporte Blink (Anti-Kick)
local function safeTeleport(targetCFrame)
    if not getgenv().ScriptAtivo then return end
    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.Velocity = Vector3.new(0,0,0)
        hrp.CFrame = targetCFrame + Vector3.new(0, 3, 0)
        task.wait(0.6) -- Delay seguro contra Security Kick
    end
end

-- 3. Loop com Verificação de Atividade
task.spawn(function()
    criarBotaoSair()
    
    while getgenv().ScriptAtivo do
        -- Parte das Frutas
        pcall(function()
            for _, tool in pairs(workspace:GetChildren()) do
                if not getgenv().ScriptAtivo then break end
                if tool:IsA("Tool") and (tool.Name:find("Fruit") or tool:FindFirstChild("Handle")) then
                    tool.Handle.CFrame = player.Character.HumanoidRootPart.CFrame
                    task.wait(0.5)
                    player.Character.Humanoid:EquipTool(tool)
                    rs.Remotes.CommF_:InvokeServer("StoreFruit", tool.Name, tool)
                end
            end
        end)

        -- Parte dos Baús
        pcall(function()
            for _, v in pairs(workspace:GetDescendants()) do
                if not getgenv().ScriptAtivo then break end
                if v:IsA("TouchTransmitter") and v.Parent.Name:find("Chest") then
                    safeTeleport(v.Parent.CFrame)
                    firetouchinterest(player.Character.HumanoidRootPart, v.Parent, 0)
                    firetouchinterest(player.Character.HumanoidRootPart, v.Parent, 1)
                end
            end
        end)
        
        task.wait(1)
    end
end)
