--==================================================
-- 👑 BLOX FRUITS ELITE MONITOR v9.0 (ULTRA PRO)
--==================================================

local HttpService = game:GetService("HttpService")
local FileName = "EliteMonitor_Config.json"

-- Função para Gerenciar o Arquivo de Configuração
local function SaveWebhook(url)
    writefile(FileName, HttpService:JSONEncode({Webhook = url}))
end

local function LoadWebhook()
    if isfile(FileName) then
        local success, data = pcall(function() return HttpService:JSONDecode(readfile(FileName)) end)
        if success and data.Webhook then return data.Webhook end
    end
    return nil
end

local SavedWebhook = LoadWebhook()

---------------- INTERFACE DE CONFIGURAÇÃO ----------------
if not SavedWebhook then
    local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
    local Main = Instance.new("Frame", ScreenGui)
    local Title = Instance.new("TextLabel", Main)
    local WebInput = Instance.new("TextBox", Main)
    local SaveBtn = Instance.new("TextButton", Main)
    
    -- Design da Telinha
    Main.Size = UDim2.new(0, 300, 0, 150)
    Main.Position = UDim2.new(0.5, -150, 0.5, -75)
    Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Main.BorderSizePixel = 0
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.BackgroundTransparency = 1
    Title.Text = "ELITE MONITOR CONFIG"
    Title.TextColor3 = Color3.fromRGB(255, 215, 0)
    Title.TextSize = 16
    Title.Font = Enum.Font.GothamBold

    WebInput.Size = UDim2.new(0, 260, 0, 35)
    WebInput.Position = UDim2.new(0, 20, 0, 50)
    WebInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    WebInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    WebInput.PlaceholderText = "Cole seu Webhook aqui"
    WebInput.Text = ""
    Instance.new("UICorner", WebInput)

    SaveBtn.Size = UDim2.new(0, 260, 0, 40)
    SaveBtn.Position = UDim2.new(0, 20, 0, 100)
    SaveBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 50)
    SaveBtn.Text = "SALVAR WEBHOOK"
    SaveBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    SaveBtn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", SaveBtn)

    SaveBtn.MouseButton1Click:Connect(function()
        if WebInput.Text:find("discord") then
            SaveWebhook(WebInput.Text)
            
            -- Enviar Notificação de Sucesso para o Discord
            local data = {
                embeds = {{
                    title = "✅ Webhook Configurado com Sucesso!",
                    description = "O monitor agora está ativo para este servidor.",
                    color = 0x00ff00,
                    footer = { text = "Blox Fruits Elite Monitor" }
                }}
            }
            local req = (syn and syn.request) or (http and http.request) or http_request or request
            req({
                Url = WebInput.Text,
                Method = "POST",
                Headers = { ["Content-Type"] = "application/json" },
                Body = HttpService:JSONEncode(data)
            })

            ScreenGui:Destroy()
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Elite Monitor",
                Text = "Webhook Salvo! Re-execute o script ou aguarde.",
                Duration = 5
            })
            -- Reinicia o script com a nova config
            SavedWebhook = WebInput.Text
            wait(1)
        end
    end)
    
    repeat task.wait() until SavedWebhook
end

---------------- CONFIG ----------------
local Config = {
Webhook = SavedWebhook,
Footer = "Blox Fruits Elite Monitor",
Icon = "https://i.imgur.com",

FruitCooldown = 5,
BeliMilestone = 1_000_000,
BeliCheckDelay = 5,
FruitNameCooldown = 10,
SessionReportDelay = 1800
}

---------------- SERVICES ----------------
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local Data = player:WaitForChild("Data", 20)
local Backpack = player:WaitForChild("Backpack", 20)

---------------- DATA TABLES ----------------
local FruitData = {
Mythical = { Color = 0xff0000, List = {"Kitsune","Tiger","Dragon","Spirit","Control","Venom","Shadow","Dough","T Rex","Gravity"}},
Legendary = { Color = 0xff00ff, List = {"Mammoth","Blizzard","Pain","Rumble","Portal","Phoenix","Sound","Spider","Love","Buddha"}},
Rare = { Color = 0x0099ff, List = {"Quake","Magma","Ghost","Barrier","Rubber","Light","Diamond"}},
Uncommon = { Color = 0x00ff99, List = {"Dark","Sand","Ice","Falcon","Flame","Spike","Smoke"}},
Common = { Color = 0xcccccc, List = {"Rocket","Spin","Chop","Spring","Bomb"}}
}

---------------- STATS ----------------
local Stats = {
StartTime = os.time(),
LastFruitSent = 0,
FruitCount = 0,
LastFruitByName = {},
LastBeliMilestone = math.floor(Data.Beli.Value / Config.BeliMilestone),
BeliStart = Data.Beli.Value,
Deaths = 0,
ServerId = game.JobId
}

---------------- UTILS ----------------
local function notifyRoblox(text)
pcall(function()
StarterGui:SetCore("SendNotification", {
Title = "Monitor Elite",
Text = text,
Duration = 5,
Icon = "rbxassetid://10614139557"
})
end)
end

local function formatTime(sec)
return string.format("%02dh %02dm %02ds",
math.floor(sec/3600),
math.floor((sec%3600)/60),
sec%60
)
end

local function getFruitInfo(name)
local clean = name:lower():gsub(" fruit",""):gsub(" fruta",""):gsub("fruta ",""):gsub("-", " ")
for cat, data in pairs(FruitData) do
for _, f in ipairs(data.List) do
if clean:find(f:lower()) then
return cat, data.Color, f
end
end
end
return "Desconhecido", 0xffffff, name
end

local function sendDiscord(title, fields, color)
local data = {
embeds = {{
title = "✨ " .. title,
color = color,
fields = fields,
thumbnail = { url = Config.Icon },
footer = { text = Config.Footer },
timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
}}
}

local req = syn and syn.request or http_request or request
if req then
pcall(function()
req({
Url = Config.Webhook,
Method = "POST",
Headers = { ["Content-Type"] = "application/json" },
Body = HttpService:JSONEncode(data)
})
end)
end
end

---------------- FRUIT BACKPACK MONITOR ----------------
Backpack.ChildAdded:Connect(function(item)
if not item:IsA("Tool") then return end
local lname = item.Name:lower()
if not (lname:find("fruit") or lname:find("fruta")) then return end

if os.time() - Stats.LastFruitSent < Config.FruitCooldown then return end
Stats.LastFruitSent = os.time()
Stats.FruitCount += 1

local category, color, realName = getFruitInfo(item.Name)
notifyRoblox("🍎 Fruta Coletada: " .. realName)

sendDiscord("Fruta Coletada", {
{ name = "🍎 Nome", value = ""..realName.."", inline = true },
{ name = "💎 Raridade", value = category, inline = true },
{ name = "📊 Sessão", value = tostring(Stats.FruitCount), inline = true },
{ name = "🌐 Server", value = ""..game.JobId.."", inline = false }
}, color)
end)

---------------- FRUIT DROP MONITOR ----------------
Workspace.ChildAdded:Connect(function(obj)
if not obj:IsA("Tool") then return end
local lname = obj.Name:lower()
if not (lname:find("fruit") or lname:find("fruta")) then return end

local last = Stats.LastFruitByName[lname] or 0
if os.time() - last < Config.FruitNameCooldown then return end
Stats.LastFruitByName[lname] = os.time()

local category, color, realName = getFruitInfo(obj.Name)

sendDiscord("🍃 Fruta Spawnada", {
{ name = "🍎 Fruta", value = ""..realName.."", inline = true },
{ name = "💎 Raridade", value = category, inline = true },
{ name = "📍 Local", value = "Mapa", inline = true }
}, color)
end)

---------------- BELI MONITOR ----------------
task.spawn(function()
while task.wait(Config.BeliCheckDelay) do
local beli = Data.Beli.Value
local milestone = math.floor(beli / Config.BeliMilestone)

if milestone > Stats.LastBeliMilestone then
Stats.LastBeliMilestone = milestone
notifyRoblox("💰 Novo Marco: "..milestone.."M Beli")    

    sendDiscord("Marco Financeiro", {    
        { name = "💰 Saldo", value = "$"..tostring(beli), inline = true },    
        { name = "🏆 Marco", value = milestone.."M", inline = true },    
        { name = "⏳ Tempo", value = formatTime(os.time() - Stats.StartTime), inline = false }    
    }, 0x2ecc71)    
end
end
end)

---------------- LEVEL MONITOR ----------------
Data.Level:GetPropertyChangedSignal("Value"):Connect(function()
notifyRoblox("🆙 Level Up: "..Data.Level.Value)

sendDiscord("Level Up", {
{ name = "🆙 Novo Level", value = tostring(Data.Level.Value), inline = true },
{ name = "👤 Jogador", value = player.Name, inline = true }
}, 0x3498db)
end)

---------------- DEATH MONITOR ----------------
player.CharacterAdded:Connect(function(char)
local hum = char:WaitForChild("Humanoid")
hum.Died:Connect(function()
Stats.Deaths += 1

sendDiscord("☠️ Jogador Morto", {
{ name = "👤 Usuário", value = player.Name, inline = true },
{ name = "💀 Mortes", value = tostring(Stats.Deaths), inline = true },
{ name = "⏳ Online", value = formatTime(os.time() - Stats.StartTime), inline = false }
}, 0xe74c3c)
end)
end)

---------------- SESSION REPORT ----------------
task.spawn(function()
while task.wait(Config.SessionReportDelay) do
local time = os.time() - Stats.StartTime
local beliGain = Data.Beli.Value - Stats.BeliStart
local fruitsPerHour = math.floor((Stats.FruitCount / math.max(time,1)) * 3600)

sendDiscord("📊 Relatório de Sessão", {
{ name = "⏳ Tempo", value = formatTime(time), inline = true },
{ name = "🍎 Frutas", value = tostring(Stats.FruitCount), inline = true },
{ name = "⚡ Frutas/H", value = tostring(fruitsPerHour), inline = true },
{ name = "💰 Beli Ganhado", value = "$"..tostring(beliGain), inline = true },
{ name = "☠️ Mortes", value = tostring(Stats.Deaths), inline = true }
}, 0x9b59b6)
end
end)

---------------- STARTUP ----------------
task.wait(2)
notifyRoblox("✅ Monitor Elite Iniciado")

sendDiscord("🚀 Monitor Online", {
{ name = "👤 Usuário", value = player.Name, inline = true },
{ name = "📊 Level", value = tostring(Data.Level.Value), inline = true },
{ name = "🌐 Server", value = ""..game.JobId.."", inline = false }
}, 0x27ae60)
