--[[ 
👑 SUPREME HUB V10 MOBILE – SEM SERVER HOP
📱 Webhook Delta + Coleta Infinita + Auto-Team
]]

getgenv().FruitScript = true

-- ================= SERVICES =================
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local VirtualUser = game:GetService("VirtualUser")

-- ================= CONFIG =================
local WEBHOOK = "https://discord.com/api/webhooks/1466207661639864362/E8Emrn_rC15_LJRjZuE0tM3y7JdsbvA8_vBDofO0OWnQ5Batq7KlqxuhwiCXx9cwhsSt"
local GUI_OFFSET_Y = 50 

getgenv().FruitCount = 0
getgenv().StoredCount = 0
getgenv().FailCount = 0
local enteredServerAt = tick()

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

-- ================= LOOP PRINCIPAL (COLETA APENAS) =================
task.spawn(function()
    while task.wait(5) do
        if not getgenv().FruitScript then return end
        
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")

        if hrp then
            for _, tool in pairs(workspace:GetChildren()) do
                if tool:IsA("Tool") and tool:FindFirstChild("Handle") and tool.Name:lower():find("fruit") then
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
    end
end)

-- ================= HEARTBEAT (STATUS A CADA 10 MINUTOS) =================
task.spawn(function()
    while task.wait(600) do
        sendWebhook(
            "📊 STATUS ATUAL\n"..
            "🍏 Coletadas: "..getgenv().FruitCount..
            "\n📦 Guardadas: "..getgenv().StoredCount..
            "\n❌ Falhas: "..getgenv().FailCount
        )
    end
end)

sendWebhook("🚀 SUPREME HUB V10 ATIVADO (MODO PERMANENTE)")
