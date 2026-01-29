--[[ 
    👑 SUPREME HUB V10 - ANTI-BUG EDITION
    FIX: VALIDAÇÃO REAL DE INVENTÁRIO + SERVER HOP CORRIGIDO
    TIMER AJUSTADO PARA SPAWN REAL DE FRUTAS
]]

getgenv().FruitScript = false
getgenv().ChestFarm = false

local player = game.Players.LocalPlayer
local rs = game:GetService("ReplicatedStorage")
local ts = game:GetService("TweenService")
local sg = game:GetService("RunService")

-- 1. CRONÔMETRO REGRESSIVO (REAL)
local function criarTimer()
    local ui = Instance.new("ScreenGui")
    ui.Parent = player:WaitForChild("PlayerGui")

    local label = Instance.new("TextLabel")
    label.Parent = ui
    label.Size = UDim2.new(0, 250, 0, 35)
    label.Position = UDim2.new(0.5, -125, 0, 15)
    label.BackgroundColor3 = Color3.new(0,0,0)
    label.BackgroundTransparency = 0.5
    label.TextColor3 = Color3.new(0, 1, 1)
    label.Font = Enum.Font.SourceSansBold
    label.TextSize = 20
    Instance.new("UICorner").Parent = label

    local ciclo = (os.date("%w") == "0" or os.date("%w") == "6") and 2700 or 3600
    local inicio = workspace.DistributedGameTime

    task.spawn(function()
        while task.wait(1) do
            local falta = ciclo - (math.floor(workspace.DistributedGameTime - inicio) % ciclo)
            label.Text = string.format("Próximo Spawn em: %02d:%02d", math.floor(falta/60), falta%60)
            label.TextColor3 = (falta < 300) and Color3.new(1,0,0) or Color3.new(0,1,1)
        end
    end)

    -- Reinicia contador quando uma fruta spawnar
    workspace.ChildAdded:Connect(function(obj)
        if obj:IsA("Tool") and (obj.Name:find("Fruit") or obj:FindFirstChild("Handle")) then
            inicio = workspace.DistributedGameTime
        end
    end)
end

-- 2. LOGS
getgenv().Logs = {}
local function addLog(msg, cor)
    table.insert(getgenv().Logs, 1, "<b>["..os.date("%H:%M").."]</b> <font color='#" .. cor:ToHex() .. "'>"..msg.."</font>")
    if #getgenv().Logs > 12 then table.remove(getgenv().Logs, #getgenv().Logs) end
end

-- 3. TWEEN PARA BAÚS
local function toTween(targetCF)
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local tween = ts:Create(hrp, TweenInfo.new((hrp.Position - targetCF.Position).Magnitude/300, Enum.EasingStyle.Linear), {Position = targetCF.Position})
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

-- 4. SERVER HOP CORRIGIDO
local function serverHop()
    addLog("Buscando novo servidor...", Color3.new(1,0.5,0))
    local HttpService = game:GetService("HttpService")
    local success, result = pcall(function()
        return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100")).data
    end)
    
    if success then
        for _, v in pairs(result) do
            if v.playing < v.maxPlayers and v.id ~= game.JobId then
                game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, v.id)
                return
            end
        end
    end
    addLog("Erro na API do Roblox", Color3.new(1,0,0))
end

-- 5. INTERFACE
local function criarPainel()
    local ui = Instance.new("ScreenGui")
    ui.Parent = player:WaitForChild("PlayerGui")

    local main = Instance.new("Frame")
    main.Parent = ui
    main.Size = UDim2.new(0, 180, 0, 260)
    main.Position = UDim2.new(0.1, 0, 0.4, 0)
    main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    main.Active = true
    main.Draggable = true
    Instance.new("UICorner").Parent = main

    local logP = Instance.new("Frame")
    logP.Parent = ui
    logP.Size = UDim2.new(0, 280, 0, 120)
    logP.Position = UDim2.new(0.4, 0, 0.4, 0)
    logP.BackgroundColor3 = Color3.new(0, 0, 0)
    logP.BackgroundTransparency = 0.6
    logP.Visible = false

    local logL = Instance.new("TextLabel")
    logL.Parent = logP
    logL.Size = UDim2.new(1, -10, 1, -10)
    logL.Position = UDim2.new(0, 5, 0, 5)
    logL.BackgroundTransparency = 1
    logL.TextColor3 = Color3.new(1, 1, 1)
    logL.RichText = true
    logL.TextXAlignment = Enum.TextXAlignment.Left
    logL.TextYAlignment = Enum.TextYAlignment.Top

    sg.RenderStepped:Connect(function() 
        if logP.Visible then 
            logL.Text = table.concat(getgenv().Logs, "\n") 
        end 
    end)

    local function btn(t, p, v, a)
        local b = Instance.new("TextButton")
        b.Parent = main
        b.Size = UDim2.new(0, 160, 0, 35)
        b.Position = p
        b.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        b.Text = t .. (v and ": OFF" or "")
        b.TextColor3 = Color3.new(1, 1, 1)
        b.MouseButton1Click:Connect(function()
            if v then 
                getgenv()[v] = not getgenv()[v]
                b.Text = t .. (getgenv()[v] and ": ON" or ": OFF")
                b.BackgroundColor3 = getgenv()[v] and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(40, 40, 40)
            else 
                a() 
            end
        end)
    end

    btn("SNIPER FRUTA", UDim2.new(0, 10, 0, 40), "FruitScript")
    btn("TWEEN BAÚS", UDim2.new(0, 10, 0, 85), "ChestFarm")
    btn("SERVER HOP", UDim2.new(0, 10, 0, 130), nil, serverHop)
    btn("LOGS", UDim2.new(0, 10, 0, 175), nil, function() logP.Visible = not logP.Visible end)
end

-- 6. LOOP PRINCIPAL
task.spawn(function()
    criarPainel(); criarTimer()
    while true do
        task.wait(0.5)
        pcall(function()
            local char = player.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            
            -- BAÚS
            if getgenv().ChestFarm then
                for _, v in pairs(workspace:GetDescendants()) do
                    if getgenv().ChestFarm and v:IsA("TouchTransmitter") and v.Parent.Name:find("Chest") then
                        toTween(v.Parent.CFrame).Completed:Wait()
                        task.wait(0.8)
                    end
                end
            end

            -- FRUTAS COM VALIDAÇÃO REAL
            if getgenv().FruitScript then
                for _, f in pairs(workspace:GetChildren()) do
                    if f:IsA("Tool") and (f.Name:find("Fruit") or f:FindFirstChild("Handle")) then
                        f.Handle.CFrame = hrp.CFrame
                        task.wait(0.3)
                        char.Humanoid:EquipTool(f)
                        task.wait(0.5)
                        
                        local guardou = rs.Remotes.CommF_:InvokeServer("StoreFruit", f.Name, f)
                        if guardou == true then
                            addLog("✅ GUARDADA: "..f.Name, Color3.new(0,1,0))
                        else
                            addLog("❌ INVENTÁRIO CHEIO: "..f.Name, Color3.new(1,0,0))
                        end
                    end
                end
            end
        end)
    end
end)
