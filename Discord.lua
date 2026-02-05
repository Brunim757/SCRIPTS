--==================================================
-- 👑 BLOX FRUITS ELITE MONITOR v8.5 (PRO)
-- Frutas | Beli | Level | Session | HUD Notify
--==================================================

local Config = {
    Webhook = "https://discord.com/api/webhooks/1468450683832242373/FjjQxp03SB8sk1J-sBUsWbr2LYjd9AJEFppolEArJjlYL0WgKXQz-7GzrTsNoaqXJeaf",
    Footer = "Blox Fruits Elite Monitor",
    Icon = "https://imgur.com/gallery/blox-fruits-NsWk189#Vi1TUFQ",

    FruitCooldown = 5,
    BeliMilestone = 1_000_000,
    BeliCheckDelay = 5
}

---------------- SERVICES ----------------
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")
local player = Players.LocalPlayer

-- Garantia de carregamento dos dados
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

local Stats = {
    StartTime = os.time(),
    LastFruitSent = 0,
    FruitCount = 0,
    LastBeliMilestone = math.floor(Data.Beli.Value / Config.BeliMilestone)
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
    return string.format("%02dh %02dm %02ds", math.floor(sec/3600), math.floor((sec%3600)/60), sec%60)
end

local function getFruitInfo(name)
    local clean = name:lower():gsub(" fruit",""):gsub(" fruta",""):gsub("fruta ",""):gsub("-", " ")
    for cat, data in pairs(FruitData) do
        for _, f in ipairs(data.List) do
            if clean:find(f:lower()) then return cat, data.Color, f end
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

---------------- MONITORS ----------------

-- [FRUIT MONITOR]
Backpack.ChildAdded:Connect(function(item)
    if not item:IsA("Tool") then return end
    local name = item.Name:lower()
    if not (name:find("fruit") or name:find("fruta")) then return end
    
    if os.time() - Stats.LastFruitSent < Config.FruitCooldown then return end
    Stats.LastFruitSent = os.time()
    Stats.FruitCount += 1

    local category, color, realName = getFruitInfo(item.Name)
    
    -- Notificação Discreta no Roblox
    notifyRoblox("Fruta Coletada: " .. realName)

    sendDiscord("Fruta Detectada", {
        { name = "🍎 Nome", value = "**" .. realName .. "**", inline = true },
        { name = "💎 Raridade", value = category, inline = true },
        { name = "📊 Sessão", value = "Total: " .. Stats.FruitCount, inline = true },
        { name = "🔗 Servidor", value = "[Clique aqui](https://www.roblox.com"..game.JobId..")", inline = false }
    }, color)
end)

-- [BELI MONITOR]
task.spawn(function()
    while task.wait(Config.BeliCheckDelay) do
        local currentBeli = Data.Beli.Value
        local milestone = math.floor(currentBeli / Config.BeliMilestone)

        if milestone > Stats.LastBeliMilestone then
            Stats.LastBeliMilestone = milestone
            
            notifyRoblox("Novo Marco: " .. milestone .. "M Beli!")
            
            sendDiscord("Marco Financeiro", {
                { name = "💰 Saldo", value = "**$" .. tostring(currentBeli) .. "**", inline = true },
                { name = "🏆 Marco", value = milestone .. "M", inline = true },
                { name = "⏳ Tempo", value = formatTime(os.time() - Stats.StartTime), inline = false }
            }, 0x2ecc71)
        end
    end
end)

-- [LEVEL MONITOR]
Data.Level:GetPropertyChangedSignal("Value"):Connect(function()
    notifyRoblox("Level Up! Novo nível: " .. Data.Level.Value)
    
    sendDiscord("Evolução de Nível", {
        { name = "🆙 Novo Level", value = "**" .. tostring(Data.Level.Value) .. "**", inline = true },
        { name = "👤 Jogador", value = player.Name, inline = true }
    }, 0x3498db)
end)

---------------- STARTUP ----------------
task.wait(2) -- Espera o HUD carregar
notifyRoblox("Monitor Iniciado com Sucesso!")

sendDiscord("Monitor Profissional Online", {
    { name = "👤 Usuário", value = player.Name, inline = true },
    { name = "📊 Level Atual", value = tostring(Data.Level.Value), inline = true },
    { name = "🌐 Server ID", value = "```" .. game.JobId .. "```", inline = false }
}, 0x27ae60)
