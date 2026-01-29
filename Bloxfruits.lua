--[[ 
    👑 SUPREME HUB V6 - HYBRID EDITION
    FIX: FRUIT TO PLAYER, SERVER HOP PROXY, ANTI-SHAKE
]]

getgenv().FruitScript = false
getgenv().ChestFarm = false

local player = game.Players.LocalPlayer
local rs = game:GetService("ReplicatedStorage")
local ts = game:GetService("TweenService")
local sg = game:GetService("RunService")

getgenv().Logs = {}

-- 1. SISTEMA DE LOGS COM TIME STAMP
local function addLog(msg, cor)
    local t = os.date("%H:%M")
    local hex = string.format("#%02X%02X%02X", cor.R*255, cor.G*255, cor.B*255)
    table.insert(getgenv().Logs, 1, "<b>["..t.."]</b> <font color='"..hex.."'>"..msg.."</font>")
    if #getgenv().Logs > 30 then table.remove(getgenv().Logs, #getgenv().Logs) end
end

-- 2. SERVER HOP (PROXY ATUALIZADO)
local function serverHop()
    addLog("Buscando servidor via Proxy...", Color3.new(1, 0.6, 0))
    local HttpService = game:GetService("HttpService")
    local TeleportService = game:GetService("TeleportService")
    
    local success, result = pcall(function()
        -- Usando API direta de servidores do Roblox
        return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100")).data
    end)

    if success and result then
        for _, server in pairs(result) do
            if server.playing < server.maxTokens and server.id ~= game.JobId then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id)
                return
            end
        end
    else
        addLog("❌ Erro de Conexão API", Color3.new(1, 0, 0))
    end
end

-- 3. MOVIMENTAÇÃO TWEEN (BAÚS)
local function toTween(targetCF)
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local dist = (hrp.Position - targetCF.Position).Magnitude
    local tween = ts:Create(hrp, TweenInfo.new(dist/300, Enum.EasingStyle.Linear), {CFrame = targetCF})
    
    -- NoClip para não tremer ao bater em objetos
    local nc = sg.Stepped:Connect(function()
        if player.Character then
            for _, v in pairs(player.Character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
    end)
    
    tween:Play()
    tween.Completed:Connect(function() nc:Disconnect() end)
    return tween
end

-- 4. GUI (MENU E LOG)
local function criarPainel()
    local ui = Instance.new("ScreenGui", player.PlayerGui); ui.Name = "SupremeV6"
    local main = Instance.new("Frame", ui)
    main.Size = UDim2.new(0, 180, 0, 260); main.Position = UDim2.new(0.1, 0, 0.4, 0)
    main.BackgroundColor3 = Color3.fromRGB(20, 20, 20); main.Draggable = true; main.Active = true
    Instance.new("UICorner", main)

    local ball = Instance.new("TextButton", ui)
    ball.Size = UDim2.new(0, 50, 0, 50); ball.Visible = false; ball.Text = "HUB"
    ball.BackgroundColor3 = Color3.fromRGB(0, 120, 255); ball.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", ball).CornerRadius = UDim.new(1, 0); ball.Draggable = true

    local logP = Instance.new("Frame", ui)
    logP.Size = UDim2.new(0, 280, 0, 180); logP.Position = UDim2.new(0.4, 0, 0.4, 0)
    logP.BackgroundColor3 = Color3.new(0, 0, 0); logP.BackgroundTransparency = 0.6
    logP.Visible = false; logP.Draggable = true; logP.Active = true
    
    local logL = Instance.new("TextLabel", logP)
    logL.Size = UDim2.new(1, -10, 1, -10); logL.Position = UDim2.new(0, 5, 0, 5)
    logL.BackgroundTransparency = 1; logL.TextColor3 = Color3.new(1, 1, 1)
    logL.TextSize = 11; logL.RichText = true; logL.TextXAlignment = "Left"; logL.TextYAlignment = "Top"
    logL.Font = Enum.Font.Code

    sg.RenderStepped:Connect(function()
        if logP.Visible then logL.Text = table.concat(getgenv().Logs, "\n") end
    end)

    local function btn(t, p, v, a)
        local b = Instance.new("TextButton", main)
        b.Size = UDim2.new(0, 160, 0, 35); b.Position = p
        b.BackgroundColor3 = Color3.fromRGB(40, 40, 40); b.Text = t .. (v and ": OFF" or "")
        b.TextColor3 = Color3.new(1, 1, 1); b.Font = Enum.Font.SourceSansBold
        b.MouseButton1Click:Connect(function()
            if v then
                getgenv()[v] = not getgenv()[v]
                b.Text = t .. (getgenv()[v] and ": ON" or ": OFF")
                b.BackgroundColor3 = getgenv()[v] and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(40, 40, 40)
            else a() end
        end)
    end

    btn("SNIPER FRUTA", UDim2.new(0, 10, 0, 40), "FruitScript")
    btn("TWEEN BAÚS", UDim2.new(0, 10, 0, 85), "ChestFarm")
    btn("SERVER HOP", UDim2.new(0, 10, 0, 130), nil, serverHop)
    btn("LOGS", UDim2.new(0, 10, 0, 175), nil, function() logP.Visible = not logP.Visible end)
    
    local x = Instance.new("TextButton", main)
    x.Size = UDim2.new(0, 30, 0, 30); x.Position = UDim2.new(1, -30, 0, 0); x.Text = "X"
    x.BackgroundTransparency = 1; x.TextColor3 = Color3.new(1,0,0)
    x.MouseButton1Click:Connect(function() main.Visible = false; ball.Visible = true; ball.Position = main.Position end)
    ball.MouseButton1Click:Connect(function() main.Visible = true; ball.Visible = false; main.Position = ball.Position end)
end

-- 5. LOOP DE EXECUÇÃO
task.spawn(function()
    criarPainel()
    addLog("Supreme Hub V6 Ativo", Color3.new(1, 1, 1))
    while true do
        task.wait(0.5)
        pcall(function()
            local hrp = player.Character.HumanoidRootPart
            
            -- FARM BAÚS (TWEEN)
            if getgenv().ChestFarm then
                for _, v in pairs(workspace:GetDescendants()) do
                    if getgenv().ChestFarm and v:IsA("TouchTransmitter") and v.Parent.Name:find("Chest") then
                        local tw = toTween(v.Parent.CFrame)
                        if tw then tw.Completed:Wait() end
                        task.wait(0.8)
                    end
                end
            end

            -- SNIPER FRUTAS (TRAZER FRUTA ATÉ O PLAYER)
            if getgenv().FruitScript then
                for _, f in pairs(workspace:GetChildren()) do
                    if f:IsA("Tool") and (f.Name:find("Fruit") or f:FindFirstChild("Handle")) then
                        addLog("Fruta detectada: "..f.Name, Color3.new(1, 0, 1))
                        -- Traz a fruta até você em vez de você ir até ela
                        f.Handle.CFrame = hrp.CFrame 
                        task.wait(0.2)
                        player.Character.Humanoid:EquipTool(f)
                        task.wait(0.3)
                        local s = rs.Remotes.CommF_:InvokeServer("StoreFruit", f.Name, f)
                        if s then addLog("✅ GUARDADA: "..f.Name, Color3.new(0, 1, 0))
                        else addLog("❌ JÁ POSSUI: "..f.Name, Color3.new(1, 0, 0)) end
                    end
                end
            end
        end)
    end
end)
