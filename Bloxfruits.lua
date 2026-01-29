-- SCRIPT MODO INSANO: SEM BLACKLIST + VOO ATRAVESSA TUDO
getgenv().ScriptAtivo = true
local player = game.Players.LocalPlayer
local rs = game:GetService("ReplicatedStorage")
local ts = game:GetService("TweenService")

-- 1. Interface de Status (Para você ver o que ele está perseguindo)
local function criarUI()
    local gui = player.PlayerGui:FindFirstChild("UltraFarm") or Instance.new("ScreenGui", player.PlayerGui)
    gui.Name = "UltraFarm"
    
    local main = Instance.new("Frame", gui)
    main.Size = UDim2.new(0, 200, 0, 80)
    main.Position = UDim2.new(0.5, -100, 0, 50)
    main.BackgroundColor3 = Color3.new(0, 0, 0)
    main.BackgroundTransparency = 0.3

    local btn = Instance.new("TextButton", main)
    btn.Size = UDim2.new(1, 0, 0.5, 0)
    btn.Text = "DESLIGAR TUDO"
    btn.BackgroundColor3 = Color3.new(0.6, 0, 0)
    btn.TextColor3 = Color3.new(1, 1, 1)

    local label = Instance.new("TextLabel", main)
    label.Size = UDim2.new(1, 0, 0.5, 0)
    label.Position = UDim2.new(0, 0, 0.5, 0)
    label.Text = "Buscando..."
    label.TextColor3 = Color3.new(1, 1, 1)
    label.BackgroundTransparency = 1

    btn.MouseButton1Click:Connect(function()
        getgenv().ScriptAtivo = false
        gui:Destroy()
    end)
    return label
end

local status = criarUI()

-- 2. Motor de Voo (Atravessa Paredes)
local function voar(alvo)
    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp or not getgenv().ScriptAtivo then return end

    local dist = (alvo.Position - hrp.Position).Magnitude
    local vel = 220 -- Velocidade máxima "roubada" (Limite do Anticheat)
    
    local tween = ts:Create(hrp, TweenInfo.new(dist/vel, Enum.EasingStyle.Linear), {CFrame = alvo})
    hrp.Velocity = Vector3.new(0,0,0) -- Zera física para evitar detecção
    tween:Play()
    tween.Completed:Wait()
end

-- 3. Loop de Coleta (Frutas e Baús Sem Memória)
task.spawn(function()
    while getgenv().ScriptAtivo do
        pcall(function()
            -- Busca Frutas no Workspace
            for _, fruit in pairs(workspace:GetChildren()) do
                if fruit:IsA("Tool") and fruit:FindFirstChild("Handle") then
                    status.Text = "🍎 FRUTA: " .. fruit.Name
                    voar(fruit.Handle.CFrame)
                    player.Character.Humanoid:EquipTool(fruit)
                    task.wait(0.2)
                    rs.Remotes.CommF_:InvokeServer("StoreFruit", fruit.Name, fruit)
                end
            end

            -- Busca Baús (Sem Blacklist, vai em todos que ver)
            for _, v in pairs(workspace:GetDescendants()) do
                if not getgenv().ScriptAtivo then break end
                if v:IsA("TouchTransmitter") and v.Parent.Name:find("Chest") then
                    local bau = v.Parent
                    -- Só vai se o baú for real/visível
                    if bau:IsA("BasePart") and bau.Transparency < 1 then
                        status.Text = "💰 BAÚ: " .. bau.Name
                        voar(bau.CFrame)
                        firetouchinterest(player.Character.HumanoidRootPart, bau, 0)
                        firetouchinterest(player.Character.HumanoidRootPart, bau, 1)
                        task.wait(0.1) -- Tempo mínimo para o server registrar
                    end
                end
            end
        end)
        task.wait(0.5)
    end
end)
