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

-- 2. SERVER HOP
local function serverHop()
    local HttpService = game:GetService("HttpService")
    local TeleportService = game:GetService("TeleportService")
    local servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100")).data
    for _, v in pairs(servers) do
        if v.playing < v.maxTokens and v.id ~= game.JobId then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, v.id)
            break
        end
    end
end

-- 3. GUI COM BOLINHA E MINIMIZAR
local function criarPainel()
    local sg = Instance.new("ScreenGui", player.PlayerGui)
    sg.Name = "PainelPro"
    
    local main = Instance.new("Frame", sg)
    main.Size = UDim2.new(0, 180, 0, 280)
    main.Position = UDim2.new(0.1, 0, 0.4, 0)
    main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    main.Active = true
    main.Draggable = true

    local ball = Instance.new("TextButton", sg)
    ball.Size = UDim2.new(0, 50, 0, 50)
    ball.Position = main.Position
    ball.Visible = false
    ball.Text = "OPEN"
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
            elseif action then action() end
        end)
    end

    criarBotao("FRUTAS", UDim2.new(0, 10, 0, 40), "FruitScript")
    criarBotao("BAÚS", UDim2.new(0, 10, 0, 90), "ChestFarm")
    criarBotao("MOBS", UDim2.new(0, 10, 0, 140), "MobFarm")
    criarBotao("SERVER HOP", UDim2.new(0, 10, 0, 190), nil, serverHop)
end

-- 4. LOOP PRINCIPAL
task.spawn(function()
    criarPainel()
    while true do
        task.wait(0.1)
        pcall(function()
            local char = player.Character
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end

            -- FARM MOBS (Ajustado para ataque de FRENTE)
            if getgenv().MobFarm then
                local inimigos = workspace:FindFirstChild("Enemies") or workspace
                for _, m in pairs(inimigos:GetChildren()) do
                    if m:FindFirstChild("Humanoid") and m.Humanoid.Health > 0 and m:FindFirstChild("HumanoidRootPart") then
                        -- Teleporta para FRENTE do mob (não em cima)
                        hrp.CFrame = m.HumanoidRootPart.CFrame * CFrame.new(0, 0, 5) -- 5 studs de distância frontal
                        hrp.CFrame = CFrame.new(hrp.Position, m.HumanoidRootPart.Position) -- Aponta para o mob
                        
                        local tool = char:FindFirstChildOfClass("Tool")
                        if tool then tool:Activate() end
                        vu:Button1Down(Vector2.new(0,0))
                        break
                    end
                end
            end

            -- FARM BAÚS (Teleporte Seguro)
            if getgenv().ChestFarm then
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("TouchTransmitter") and v.Parent.Name:find("Chest") then
                        hrp.CFrame = v.Parent.CFrame
                        task.wait(1.8) -- Velocidade reduzida para não bugar
                        break
                    end
                end
            end

            -- FRUTAS (Auto-Store)
            if getgenv().FruitScript then
                for _, f in pairs(workspace:GetChildren()) do
                    if f:IsA("Tool") and (f.Name:find("Fruit") or f:FindFirstChild("Handle")) then
                        hrp.CFrame = f.Handle.CFrame
                        task.wait(0.5)
                        char.Humanoid:EquipTool(f)
                        rs.Remotes.CommF_:InvokeServer("StoreFruit", f.Name, f)
                        avisar("Fruta Guardada!", Color3.new(0,1,0))
                    end
                end
            end
        end)
    end
end)
