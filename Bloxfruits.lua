--[[ 
👑 SUPREME HUB V10 MOBILE – TOTALMENTE CORRIGIDO
📱 Webhook Delta + Server Hop Inteligente + Auto-Team
]]

getgenv().FruitScript = true

-- ================= SERVICES =================
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")

-- ================= CONFIG =================
local WEBHOOK = "https://discord.com/api/webhooks/1466207661639864362/E8Emrn_rC15_LJRjZuE0tM3y7JdsbvA8_vBDofO0OWnQ5Batq7KlqxuhwiCXx9cwhsSt"
local MIN_SERVER_TIME = 30 
local GUI_OFFSET_Y = 50 

getgenv().FruitCount = 0
getgenv().StoredCount = 0
getgenv().FailCount = 0
local enteredServerAt = tick()
local hopping = false

-- ================= WEBHOOK (DELTA COMPATIBLE) =================
local function sendWebhook(msg)
    if WEBHOOK == "" then return end
    local proxyURL = WEBHOOK:gsub("discord.com", "webhook.lewisakura.moe")
    local req = (syn and syn.request) or request or http_request
    if req then
        pcall(function()
            req({
                Url = proxyURL,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = HttpService:JSONEncode({
                    content = msg, 
                    username = "Supreme Hub Fruit"
                })
            })
        end)
    end
end

-- ================= GUI =================
local ScreenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
ScreenGui.Name = "SupremeHubGUI"
ScreenGui.ResetOnSpawn = false

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 220, 0, 100)
Frame.Position = UDim2.new(1, -230, 0, GUI_OFFSET_Y)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BackgroundTransparency = 0.3
Frame.BorderSizePixel = 0

local function makeLabel(text, posY)
    local lbl = Instance.new("TextLabel", Frame)
    lbl.Size = UDim2.new(1, -10, 0, 20)
    lbl.Position = UDim2.new(0, 5, 0, posY)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = Color3.fromRGB(0, 255, 0)
    lbl.TextScaled = true
    lbl.Font = Enum.Font.SourceSansBold
    lbl.Text = text
    return lbl
end

local lblCollected = makeLabel("🍏 Coletadas: 0", 0)
local lblStored = makeLabel("📦 Guardadas: 0", 20)
local lblFailed = makeLabel("❌ Falhas: 0", 40)
local lblTimer = makeLabel("⏳ Tempo: 0s", 60)

-- ================= TIMER REALTIME =================
task.spawn(function()
    while true do
        local tempo = math.floor(tick() - enteredServerAt)
        lblTimer.Text = "⏳ Tempo no server: "..tempo.."s"
        task.wait(1)
    end
end)

-- ================= ANTI-AFK =================
player.Idled:Connect(function()
    pcall(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end)

-- ================= AUTO PIRATA (REFORÇADO) =================
local function joinPirates()
    local attempts = 0
    repeat
        task.wait(2)
        pcall(function()
            RS.Remotes.CommF_:InvokeServer("SetTeam", "Pirates")
        end)
        attempts = attempts + 1
    until (player.Team ~= nil and player.Team.Name ~= "") or attempts > 15
    
    if player.Team then
        sendWebhook("🏴‍☠️ Time Pirata definido com sucesso!")
    end
end
task.spawn(joinPirates)

-- ================= SERVER HOP INTELIGENTE =================
local function serverHop()
    if hopping then return end
    hopping = true
    sendWebhook("🔄 Procurando novo servidor estável...")

    local url = "https://games.roblox.com" .. game.PlaceId .. "/servers/Public?sortOrder=Desc&limit=100"
    
    local function getServers()
        local ok, res = pcall(function() return game:HttpGet(url) end)
        if ok then return HttpService:JSONDecode(res) end
    end

    local serverList = getServers()
    if serverList and serverList.data then
        for _, s in pairs(serverList.data) do
            -- Garante 3 vagas livres para não dar erro de Server Full
            if s.playing < (s.maxPlayers - 3) and s.id ~= game.JobId then
                sendWebhook("🚀 Teleportando para servidor: " .. s.id)
                TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id)
                task.wait(10)
            end
        end
    end
    hopping = false
end

-- ================= LOOP PRINCIPAL =================
task.spawn(function()
    while task.wait(5) do
        if not getgenv().FruitScript then return end
        
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local foundInThisTurn = false

        if hrp then
            for _, tool in pairs(workspace:GetChildren()) do
                if tool:IsA("Tool") and tool:FindFirstChild("Handle") and tool.Name:lower():find("fruit") then
                    foundInThisTurn = true
                    getgenv().FruitCount += 1
                    lblCollected.Text = "🍏 Coletadas: "..getgenv().FruitCount
                    
                    -- Coleta
                    tool.Handle.CFrame = hrp.CFrame
                    task.wait(0.5)
                    char.Humanoid:EquipTool(tool)
                    task.wait(0.5)

                    -- Guarda
                    local ok = RS.Remotes.CommF_:InvokeServer("StoreFruit", tool.Name)
                    if ok then
                        getgenv().StoredCount += 1
                        lblStored.Text = "📦 Guardadas: "..getgenv().StoredCount
                        sendWebhook("✅ Fruta guardada: "..tool.Name)
                    else
                        getgenv().FailCount += 1
                        lblFailed.Text = "❌ Falhas: "..getgenv().FailCount
                        sendWebhook("⚠️ Inventário cheio!")
                    end
                    task.wait(1)
                end
            end
        end

        -- Lógica de Hop: Se passou o tempo mínimo e não tem fruta, pula.
        if (tick() - enteredServerAt) >= MIN_SERVER_TIME then
            if not foundInThisTurn then
                serverHop()
            end
        end
    end
end)

sendWebhook("🚀 SUPREME HUB V10 ATIVADO")
