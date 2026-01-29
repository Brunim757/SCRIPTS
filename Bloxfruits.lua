--[[ 
👑 SUPREME HUB V10 MOBILE – FIXED
📱 Server Hop Otimizado + Timer Realtime
]]

getgenv().FruitScript = true

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

-- ================= WEBHOOK =================
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
                Body = HttpService:JSONEncode({content = msg, username = "Supreme Hub"})
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

-- ================= SERVER HOP MELHORADO =================
local function serverHop()
    if hopping then return end
    hopping = true
    sendWebhook("🔄 Procurando novo servidor...")

    local url = "https://games.roblox.com" .. game.PlaceId .. "/servers/Public?sortOrder=Desc&limit=100"
    
    local function getServers(cursor)
        local raw = game:HttpGet(url .. (cursor and "&cursor=" .. cursor or ""))
        return HttpService:JSONDecode(raw)
    end

    local serverList = getServers()
    for _, s in pairs(serverList.data) do
        -- Só entra se houver pelo menos 3 vagas livres para evitar erro de 'Cheio'
        if s.playing < (s.maxPlayers - 3) and s.id ~= game.JobId then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id)
            task.wait(5)
        end
    end
    hopping = false
end

-- ================= LOOP DE COLETA =================
task.spawn(function()
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    
    while task.wait(5) do
        local encontrouFruta = false
        
        for _, tool in pairs(workspace:GetChildren()) do
            if tool:IsA("Tool") and tool.Name:lower():find("fruit") then
                encontrouFruta = true
                getgenv().FruitCount += 1
                lblCollected.Text = "🍏 Coletadas: "..getgenv().FruitCount
                
                tool.Handle.CFrame = hrp.CFrame
                task.wait(0.5)
                char.Humanoid:EquipTool(tool)
                
                local ok = RS.Remotes.CommF_:InvokeServer("StoreFruit", tool.Name)
                if ok then
                    getgenv().StoredCount += 1
                    lblStored.Text = "📦 Guardadas: "..getgenv().StoredCount
                else
                    getgenv().FailCount += 1
                    lblFailed.Text = "❌ Falhas: "..getgenv().FailCount
                end
            end
        end
        
        -- Condição de Hop
        if (tick() - enteredServerAt) >= MIN_SERVER_TIME then
            if not encontrouFruta then
                serverHop()
            end
        end
    end
end)

sendWebhook("🚀 Script Iniciado!")
