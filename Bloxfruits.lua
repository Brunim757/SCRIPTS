--[[ 
👑 SUPREME HUB V10 MOBILE – FIX FALHAS
📱 Webhook Delta + Nome da Fruta + Filtro de Itens
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

-- ================= TIMER =================
task.spawn(function()
    while true do
        lblTimer.Text = "⏳ Tempo no server: "..math.floor(tick() - enteredServerAt).."s"
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
task.spawn(function()
    local attempts = 0
    repeat
        task.wait(2)
        pcall(function() RS.Remotes.CommF_:InvokeServer("SetTeam", "Pirates") end)
        attempts = attempts + 1
    until (player.Team ~= nil) or attempts > 10
end)

-- ================= LOOP PRINCIPAL (FIXED) =================
task.spawn(function()
    while task.wait(5) do
        if not getgenv().FruitScript then return end
        
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")

        if hrp then
            -- Procura frutas APENAS no Workspace (frutas spawnadas)
            for _, item in pairs(workspace:GetChildren()) do
                -- Verifica se é uma fruta real pelo nome e se tem o "Handle" (item físico)
                if item:IsA("Tool") and item.Name:lower():find("fruit") and item:FindFirstChild("Handle") then
                    local fruitName = item.Name
                    
                    getgenv().FruitCount += 1
                    lblCollected.Text = "🍏 Coletadas: "..getgenv().FruitCount
                    
                    -- Puxa e equipa
                    item.Handle.CFrame = hrp.CFrame
                    task.wait(0.5)
                    char.Humanoid:EquipTool(item)
                    task.wait(0.7) -- Delay para garantir que equipou

                    -- Só tenta guardar se o item estiver na mão agora
                    local toolInHand = char:FindFirstChildOfClass("Tool")
                    if toolInHand and toolInHand.Name == fruitName then
                        local ok = RS.Remotes.CommF_:InvokeServer("StoreFruit", fruitName)
                        if ok then
                            getgenv().StoredCount += 1
                            lblStored.Text = "📦 Guardadas: "..getgenv().StoredCount
                            sendWebhook("✅ **Fruta Guardada:** " .. fruitName)
                        else
                            getgenv().FailCount += 1
                            lblFailed.Text = "❌ Falhas: "..getgenv().FailCount
                            sendWebhook("⚠️ **Inventário Cheio para:** " .. fruitName)
                        end
                    end
                    task.wait(1)
                end
            end
        end
    end
end)
