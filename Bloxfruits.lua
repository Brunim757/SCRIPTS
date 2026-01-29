-- CONFIGURAÇÃO GLOBAL
getgenv().FruitScript = false
getgenv().ChestFarm = false

local player = game.Players.LocalPlayer
local rs = game:GetService("ReplicatedStorage")
local ts = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

getgenv().Logs = {}

-- 1. SISTEMA DE LOGS MELHORADO
local function addLog(msg, cor)
    local hex = string.format("#%02X%02X%02X", cor.R*255, cor.G*255, cor.B*255)
    table.insert(getgenv().Logs, 1, "<font color='"..hex.."'>"..msg.."</font>")
    if #getgenv().Logs > 40 then table.remove(getgenv().Logs, #getgenv().Logs) end
end

-- 2. TWEEN + NOCLIP (Velocidade 300)
local function toTween(targetCFrame)
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local distance = (hrp.Position - targetCFrame.Position).Magnitude
    local duration = distance / 300
    
    -- Ativa NoClip durante o movimento
    local nc = game:GetService("RunService").Stepped:Connect(function()
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end)

    local tween = ts:Create(hrp, TweenInfo.new(duration, Enum.EasingStyle.Linear), {CFrame = targetCFrame})
    tween:Play()
    tween.Completed:Connect(function() nc:Disconnect() end)
    return tween
end

-- 3. SERVER HOP (Corrigido)
local function serverHop()
    addLog("Mudando de servidor...", Color3.new(1, 0.6, 0))
    pcall(function()
        local url = "https://games.roblox.com"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"
        local servers = HttpService:JSONDecode(game:HttpGet(url)).data
        for _, v in pairs(servers) do
            if v.playing < v.maxTokens and v.id ~= game.JobId then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, v.id)
            end
        end
    end)
end

-- 4. GUI (Painel + Bolinha + Log Transparente)
local function criarPainel()
    local sg = Instance.new("ScreenGui", player.PlayerGui)
    sg.Name = "SupremeHubV4"
    
    local main = Instance.new("Frame", sg)
    main.Size = UDim2.new(0, 180, 0, 260)
    main.Position = UDim2.new(0.1, 0, 0.4, 0)
    main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    main.Active = true
    main.Draggable = true
    Instance.new("UICorner", main)

    local ball = Instance.new("TextButton", sg)
    ball.Size = UDim2.new(0, 50, 0, 50)
    ball.Visible = false
    ball.Text = "MENU"
    ball.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    ball.TextColor3 = Color3.new(1, 1, 1)
    local bc = Instance.new("UICorner", ball)
    bc.CornerRadius = UDim.new(1, 0)
    ball.Draggable = true

    local logPanel = Instance.new("Frame", sg)
    logPanel.Size = UDim2.new(0, 260, 0, 160)
    logPanel.Position = UDim2.new(0.4, 0, 0.4, 0)
    logPanel.BackgroundColor3 = Color3.new(0, 0, 0)
    logPanel.BackgroundTransparency = 0.5
    logPanel.Visible = false
    logPanel.Draggable = true
    logPanel.Active = true
    
    local logLabel = Instance.new("TextLabel", logPanel)
    logLabel.Size = UDim2.new(1, -10, 1, -10)
    logLabel.Position = UDim2.new(0, 5, 0, 5)
    logLabel.BackgroundTransparency = 1
    logLabel.TextColor3 = Color3.new(1, 1, 1)
    logLabel.TextSize = 13
    logLabel.RichText = true
    logLabel.TextXAlignment = "Left"
    logLabel.TextYAlignment = "Top"
    logLabel.Font = Enum.Font.Code

    game:GetService("RunService").RenderStepped:Connect(function()
        if logPanel.Visible then
            logLabel.Text = table.concat(getgenv().Logs, "\n")
        end
    end)

    local function criarBotao(txt, pos, var, act)
        local b = Instance.new("TextButton", main)
        b.Size = UDim2.new(0, 160, 0, 35)
        b.Position = pos
        b.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        b.Text = txt .. (var and ": OFF" or "")
        b.TextColor3 = Color3.new(1, 1, 1)
        b.MouseButton1Click:Connect(function()
            if var then
                getgenv()[var] = not getgenv()[var]
                b.Text = txt .. (getgenv()[var] and ": ON" or ": OFF")
                b.BackgroundColor3 = getgenv()[var] and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(40, 40, 40)
            else act() end
        end)
    end

    criarBotao("FRUTAS", UDim2.new(0, 10, 0, 40), "FruitScript")
    criarBotao("BAÚS", UDim2.new(0, 10, 0, 85), "ChestFarm")
    criarBotao("SERVER HOP", UDim2.new(0, 10, 0, 130), nil, serverHop)
    criarBotao("LOGS", UDim2.new(0, 10, 0, 175), nil, function() logPanel.Visible = not logPanel.Visible end)
    
    local x = Instance.new("TextButton", main)
    x.Size = UDim2.new(0, 30, 0, 30)
    x.Position = UDim2.new(1, -30, 0, 0)
    x.Text = "X"
    x.BackgroundTransparency = 1
    x.TextColor3 = Color3.new(1,0,0)
    x.MouseButton1Click:Connect(function() main.Visible = false ball.Visible = true ball.Position = main.Position end)
    ball.MouseButton1Click:Connect(function() main.Visible = true ball.Visible = false main.Position = ball.Position end)
end

-- 5. LOOP DE EXECUÇÃO
task.spawn(function()
    criarPainel()
    addLog("Supreme Hub V4 Iniciado!", Color3.new(1,1,1))
    while true do
        task.wait(0.2)
        pcall(function()
            if getgenv().ChestFarm then
                for _, v in pairs(workspace:GetDescendants()) do
                    if getgenv().ChestFarm and v:IsA("TouchTransmitter") and v.Parent.Name:find("Chest") then
                        addLog("Indo para baú...", Color3.new(1,1,0))
                        local tw = toTween(v.Parent.CFrame)
                        tw.Completed:Wait()
                        task.wait(0.6)
                    end
                end
            end

            if getgenv().FruitScript then
                for _, f in pairs(workspace:GetChildren()) do
                    if f:IsA("Tool") and (f.Name:find("Fruit") or f:FindFirstChild("Handle")) then
                        addLog("Fruta detectada!", Color3.new(1, 0, 1))
                        toTween(f.Handle.CFrame).Completed:Wait()
                        player.Character.Humanoid:EquipTool(f)
                        task.wait(0.3)
                        -- VERIFICAÇÃO REAL DO SERVIDOR
                        local check = rs.Remotes.CommF_:InvokeServer("StoreFruit", f.Name, f)
                        if check then
                            addLog("✅ GUARDADA: "..f.Name, Color3.new(0, 1, 0))
                        else
                            addLog("❌ ERRO: Já possui "..f.Name.." no inventário!", Color3.new(1, 0, 0))
                        end
                        task.wait(1)
                    end
                end
            end
        end)
    end
end)
