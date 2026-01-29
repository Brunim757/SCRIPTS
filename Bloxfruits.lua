-- CONFIGURAÇÃO GLOBAL
getgenv().FruitScript = false
getgenv().ChestFarm = false
getgenv().MobFarm = false

local player = game.Players.LocalPlayer
local rs = game:GetService("ReplicatedStorage")
local vu = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

-- Variável Global para o Log
getgenv().Logs = {}

-- 1. INTERFACE DE LOGS DEDICADA
local function addLog(msg, cor)
    table.insert(getgenv().Logs, 1, {msg = msg, cor = cor or Color3.new(1, 1, 1)})
    -- Limita o log a 100 mensagens
    while #getgenv().Logs > 100 do table.remove(getgenv().Logs, #getgenv().Logs) end
end

-- Função antiga de avisar para compatibilidade temporária
local function avisar(msg, cor)
    addLog("[AVISO] " .. msg, cor)
    -- Lógica visual antiga foi removida daqui para centralizar no log
end


-- 2. SERVER HOP (Corrigido o URL)
local function serverHop()
    addLog("Iniciando Server Hop...", Color3.new(1, 0.5, 0))
    local servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100")).data
    for _, v in pairs(servers) do
        if v.playing < v.maxTokens and v.id ~= game.JobId then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, v.id)
            return -- Para a função após o teleporte
        end
    end
    addLog("❌ Nenhum servidor vazio encontrado.", Color3.new(1, 0, 0))
end


-- 3. GUI PRINCIPAL E GUI DE LOG
local function criarPainel()
    local sg = Instance.new("ScreenGui", player.PlayerGui)
    sg.Name = "PainelPro"
    
    -- Main Panel
    local main = Instance.new("Frame", sg)
    main.Size = UDim2.new(0, 180, 0, 320) -- Aumentei para caber o botão de Log
    main.Position = UDim2.new(0.1, 0, 0.4, 0)
    main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    main.Active = true
    main.Draggable = true

    -- Minimizable Ball
    local ball = Instance.new("TextButton", sg)
    ball.Size = UDim2.new(0, 50, 0, 50)
    ball.Position = main.Position
    ball.Visible = false
    ball.Text = "MENU"
    ball.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    ball.TextColor3 = Color3.new(1, 1, 1)
    local corner = Instance.new("UICorner", ball)
    corner.CornerRadius = UDim.new(1, 0)
    ball.Draggable = true

    local close = Instance.new("TextButton", main)
    close.Size = UDim2.new(0, 30, 0, 30)
    close.Position = UDim2.new(1, -30, 0, 0)
    close.Text = "X"
    close.TextColor3 = Color3.new(1, 0, 0)
    close.BackgroundTransparency = 1
    close.MouseButton1Click:Connect(function() main.Visible = false ball.Position = main.Position ball.Visible = true end)
    ball.MouseButton1Click:Connect(function() main.Visible = true ball.Visible = false main.Position = ball.Position end)

    -- Log Panel
    local logPanel = Instance.new("Frame", sg)
    logPanel.Size = UDim2.new(0, 300, 0, 200)
    logPanel.Position = UDim2.new(0.5, 0, 0.4, 0)
    logPanel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    logPanel.BackgroundTransparency = 0.2
    logPanel.Active = true
    logPanel.Draggable = true
    logPanel.Visible = false

    local logText = Instance.new("TextLabel", logPanel)
    logText.Size = UDim2.new(1, -10, 1, -10)
    logText.Position = UDim2.new(0, 5, 0, 5)
    logText.BackgroundTransparency = 1
    logText.TextColor3 = Color3.new(1, 1, 1)
    logText.TextXAlignment = Enum.TextXAlignment.Left
    logText.TextYAlignment = Enum.TextYAlignment.Top
    logText.Font = Enum.Font.SourceSans
    logText.TextSize = 12
    logText.TextWrapped = true

    game:GetService("RunService").RenderStepped:Connect(function()
        if logPanel.Visible then
            local text = ""
            for _, entry in pairs(getgenv().Logs) do
                text = text .. "<font color='" .. string.format("#%06x", (entry.cor.R * 255 * 256 * 256 + entry.cor.G * 255 * 256 + entry.cor.B * 255)) .. "'>" .. entry.msg .. "</font>\n"
            end
            logText.Text = text
        end
    end)
    
    -- Função Criar Botão
    local function criarBotao(texto, pos, var, action)
        local btn = Instance.new("TextButton", main)
        btn.Size = UDim2.new(0, 160, 0, 40)
        btn.Position = pos
        btn.Text = texto .. (var and ": OFF" or "")
        btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.MouseButton1Click:Connect(function()
            if var then
                getgenv()[var] = not getgenv()[var]
                btn.Text = texto .. (getgenv()[var] and ": ON" or ": OFF")
                btn.BackgroundColor3 = getgenv()[var] and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
                addLog(texto .. " " .. (getgenv()[var] and "ativado." or "desativado."))
            elseif action then action() end
        end)
    end

    criarBotao("FRUTAS", UDim2.new(0, 10, 0, 40), "FruitScript")
    criarBotao("BAÚS", UDim2.new(0, 10, 0, 90), "ChestFarm")
    criarBotao("MOBS", UDim2.new(0, 10, 0, 140), "MobFarm")
    criarBotao("SERVER HOP", UDim2.new(0, 10, 0, 190), nil, serverHop)
    
    local logBtn = Instance.new("TextButton", main)
    logBtn.Size = UDim2.new(0, 160, 0, 40)
    logBtn.Position = UDim2.new(0, 10, 0, 240)
    logBtn.Text = "LOGS (Abrir/Fechar)"
    logBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 150)
    logBtn.TextColor3 = Color3.new(1, 1, 1)
    logBtn.MouseButton1Click:Connect(function()
        logPanel.Visible = not logPanel.Visible
    end)
end

-- 4. LOOP PRINCIPAL
task.spawn(function()
    criarPainel()
    addLog("Script carregado com sucesso!", Color3.new(0, 1, 0))
    while true do
        task.wait(0.1)
        pcall(function()
            local char = player.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end

            -- FARM MOBS (Ataque de FRENTE e mais rápido)
            if getgenv().MobFarm then
                local inimigos = workspace:FindFirstChild("Enemies") or workspace
                for _, m in pairs(inimigos:GetChildren()) do
                    if m:FindFirstChild("Humanoid") and m.Humanoid.Health > 0 and m:FindFirstChild("HumanoidRootPart") then
                        -- Teleporta ligeiramente a frente do alvo e aponta para ele
                        hrp.CFrame = m.HumanoidRootPart.CFrame * CFrame.new(0, 0, 4) -- Distância frontal menor
                        hrp.CFrame = CFrame.new(hrp.Position, m.HumanoidRootPart.Position) -- Aponta
                        
                        local tool = char:FindFirstChildOfClass("Tool")
                        if tool then tool:Activate() end -- Ativa a skill da fruta/arma
                        vu:Button1Down(Vector2.new(0,0)) -- Mantém o ataque
                        task.wait(0.2) -- Loop mais rápido de ataque
                        break
                    end
                end
            end

            -- FARM BAÚS (Teleporte Seguro e Funcional)
            if getgenv().ChestFarm then
                local found = false
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("TouchTransmitter") and v.Parent.Name:find("Chest") then
                        local bau = v.Parent
                        if bau:IsA("BasePart") then
                            hrp.CFrame = bau.CFrame
                            found = true
                            break
                        end
                    end
                end
                if found then task.wait(1.5) end -- Apenas espera se achou um baú
            end

            -- FRUTAS (Auto-Store e Log)
            if getgenv().FruitScript then
                for _, f in pairs(workspace:GetChildren()) do
                    if f:IsA("Tool") and (f.Name:find("Fruit") or f:FindFirstChild("Handle")) then
                        hrp.CFrame = f.Handle.CFrame
                        task.wait(0.5)
                        char.Humanoid:EquipTool(f)
                        local guardou = rs.Remotes.CommF_:InvokeServer("StoreFruit", f.Name, f)
                        addLog(guardou and "✅ GUARDADA: " .. f.Name or "❌ JÁ POSSUI: " .. f.Name, guardou and Color3.new(0, 0.7, 0) or Color3.new(0.7, 0, 0))
                        task.wait(1)
                    end
                end
            end
        end)
    end
end)
