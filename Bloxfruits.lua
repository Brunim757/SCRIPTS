--[[ 
👑 SUPREME HUB V10 MOBILE – NOMES DAS FRUTAS
📱 Webhook Delta + Nome da Fruta + Sem Server Hop
]]

getgenv().FruitScript = true

-- ================= SERVICES =================
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local VirtualUser = game:GetService("VirtualUser")

-- ================= CONFIG =================
-- LEMBRETE: Use um novo link de webhook se o antigo foi deletado
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
                    username = "Supreme Hub Finder"
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

-- ================= AUTO PIRATA =================
local function joinPirates()
    local attempts = 0
    repeat
        task.wait(2)
        pcall(function()
            RS.Remotes.CommF_:InvokeServer("SetTeam", "Pirates")
        end)
        attempts = attempts + 1
    until (player.Team ~= nil and player.Team.Name ~= "") or attempts > 15
end
task.spawn(joinPirates)

-- ================= LOOP PRINCIPAL (NOMES DAS FRUTAS) =================
task.spawn(function()
    while task.wait(5) do
        if not getgenv().FruitScript then return end
        
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")

        if hrp then
            for _, tool in pairs(workspace:GetChildren()) do
                -- Verifica se é uma fruta pelo nome ou classe
                if tool:IsA("Tool") and (tool.Name:lower():find("fruit") or tool:FindFirstChild("Handle")) then
                    local fruitName = tool.Name
                    
                    getgenv().FruitCount += 1
                    lblCollected.Text = "🍏 Coletadas: "..getgenv().FruitCount
                    
                    -- Teleporta a fruta e equipa
                    tool.Handle.CFrame = hrp.CFrame
                    task.wait(0.5)
                    char.Humanoid:EquipTool(tool)
                    task.wait(0.5)

                    -- Tenta guardar no inventário
                    local ok = RS.Remotes.CommF_:InvokeServer("StoreFruit", fruitName)
                    if ok then
                        getgenv().StoredCount += 1
                        lblStored.Text = "📦 Guardadas: "..getgenv().StoredCount
                        sendWebhook("✅ **Fruta Coletada:** " .. fruitName .. " (Guardada com sucesso!)")
                    else
                        getgenv().FailCount += 1
                        lblFailed.Text = "❌ Falhas: "..getgenv().FailCount
                        sendWebhook("⚠️ **Falha ao guardar:** " .. fruitName .. " (Inventário cheio ou erro)")
                    end
                    task.wait(1)
                end
            end
        end
    end
end)

sendWebhook("🚀 **SUPREME HUB V10 ATIVADO**\nMonitorando frutas neste servidor...")
