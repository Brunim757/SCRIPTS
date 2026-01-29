
--[[ 
👑 SUPREME HUB V10 MOBILE – GUI FINAL (VERSÃO DELTA)
📱 Contador + Timer + Webhook + AFK + Server Hop
]]

getgenv().FruitScript = true

-- ================= SERVICES =================
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- ================= CONFIG =================
local WEBHOOK = "https://discord.com/api/webhooks/1466207661639864362/E8Emrn_rC15_LJRjZuE0tM3y7JdsbvA8_vBDofO0OWnQ5Batq7KlqxuhwiCXx9cwhsSt"
local MIN_SERVER_TIME = 30 
local GUI_OFFSET_Y = 50 

-- ================= CONTADORES =================
getgenv().FruitCount = 0
getgenv().StoredCount = 0
getgenv().FailCount = 0
local enteredServerAt = tick()
local hopping = false
local lastHop = 0

-- ================= WEBHOOK CORRIGIDO (DELTA) =================
local function sendWebhook(msg)
    if WEBHOOK == "" then return end
    
    -- Ajuste automático para Proxy (resolve bloqueio do Discord)
    local proxyURL = WEBHOOK:gsub("discord.com", "webhook.lewisakura.moe")
    
    -- Detecta a função do Delta/Executores
    local req = (syn and syn.request) or request or http_request or (http and http.request)
    
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
    else
        -- Fallback simples para debug
        warn("Executor não suporta 'request'")
    end
end

sendWebhook("🚀 SUPREME HUB MOBILE INICIADO COM GUI")

-- ================= ANTI-AFK =================
player.Idled:Connect(function()
    pcall(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end)

-- ================= GUI =================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SupremeHubGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 220, 0, 100)
Frame.Position = UDim2.new(1, -230, 0, GUI_OFFSET_Y)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BackgroundTransparency = 0.3
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui

local function makeLabel(text, posY)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -10, 0, 20)
    lbl.Position = UDim2.new(0, 5, 0, posY)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = Color3.fromRGB(0, 255, 0)
    lbl.TextScaled = true
    lbl.Font = Enum.Font.SourceSansBold
    lbl.Text = text
    lbl.Parent = Frame
    return lbl
end

local lblCollected = makeLabel("🍏 Coletadas: 0", 0)
local lblStored = makeLabel("📦 Guardadas: 0", 20)
local lblFailed = makeLabel("❌ Falhas: 0", 40)
local lblTimer = makeLabel("⏳ Aguardando spawn...", 60)

-- ================= ESPERAR PERSONAGEM =================
local function waitCharacter()
    local char = player.Character or player.CharacterAdded:Wait()
    char:WaitForChild("HumanoidRootPart")
    char:WaitForChild("Humanoid")
    return char
end

-- ================= AUTO PIRATA =================
task.delay(2, function()
    pcall(function()
        RS.Remotes.CommF_:InvokeServer("SetTeam", "Pirates")
        sendWebhook("🏴‍☠️ Time Pirata definido")
    end)
end)

-- ================= SERVER HOP =================
local function serverHop()
    if hopping then return end
    if tick() - lastHop < 20 then return end
    hopping = true
    lastHop = tick()

    sendWebhook("🔄 Server hop iniciado")

    local ok, servers = pcall(function()
        return HttpService:JSONDecode(
            game:HttpGet(
                "https://games.roblox.com/v1/games/"
                .. game.PlaceId ..
                "/servers/Public?sortOrder=Asc&limit=100"
            )
        ).data
    end)

    if ok then
        for _, v in pairs(servers) do
            if v.playing < v.maxPlayers - 1 and v.id ~= game.JobId then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, v.id)
                return
            end
        end
    end

    hopping = false
end

-- ================= LOOP PRINCIPAL =================
task.spawn(function()
    local char = waitCharacter()
    local hrp = char:WaitForChild("HumanoidRootPart")
    local humanoid = char:WaitForChild("Humanoid")

    task.wait(3) 

    while task.wait(6) do
        if not getgenv().FruitScript then return end

        local encontrou = false
        local guardou = false

        local tempoNoServer = math.floor(tick() - enteredServerAt)
        lblTimer.Text = "⏳ Tempo no server: "..tempoNoServer.."s"

        for _, tool in pairs(workspace:GetChildren()) do
            if tool:IsA("Tool") and tool:FindFirstChild("Handle") and tool.Name:lower():find("fruit") then
                encontrou = true
                getgenv().FruitCount += 1
                lblCollected.Text = "🍏 Coletadas: "..getgenv().FruitCount

                tool.Handle.CFrame = hrp.CFrame + Vector3.new(0,3,0)
                task.wait(0.5)
                humanoid:EquipTool(tool)
                task.wait(0.6)

                local ok = RS.Remotes.CommF_:InvokeServer("StoreFruit", tool.Name)
                if ok then
                    guardou = true
                    getgenv().StoredCount += 1
                    lblStored.Text = "📦 Guardadas: "..getgenv().StoredCount
                    sendWebhook("✅ Guardada: "..tool.Name)
                else
                    getgenv().FailCount += 1
                    lblFailed.Text = "❌ Falhas: "..getgenv().FailCount
                    sendWebhook("⚠ Inventário cheio — aguardando 10s")
                    task.wait(10)
                end
                task.wait(2) 
            end
        end

        if tempoNoServer >= MIN_SERVER_TIME then
            if not encontrou or (encontrou and not guardou) then
                serverHop()
            end
        end
    end
end)

-- ================= HEARTBEAT (STATUS) =================
task.spawn(function()
    while task.wait(300) do
        sendWebhook(
            "📊 STATUS\n"..
            "🍏 Coletadas: "..getgenv().FruitCount..
            "\n📦 Guardadas: "..getgenv().StoredCount..
            "\n❌ Falhas: "..getgenv().FailCount
        )
    end
end)
