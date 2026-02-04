--==================================================
-- BLOX FRUITS ULTIMATE MONITOR v3.0 (BR)
-- Frutas | Categorias | Anti-Spam | Beli 1M | Sessão
--==================================================

---------------- CONFIG ----------------
local Config = {
    Webhook = "https://discord.com/api/webhooks/1468450683832242373/FjjQxp03SB8sk1J-sBUsWbr2LYjd9AJEFppolEArJjlYL0WgKXQz-7GzrTsNoaqXJeaf",
    Footer = "Blox Fruits Ultimate Monitor",
    Icon = "https://imgur.com/gallery/blox-fruits-NsWk189#Vi1TUFQ",

    FruitCooldown = 5,      -- segundos
    BeliMilestone = 1_000_000,
    BeliCheckDelay = 5
}

---------------- SERVICES ----------------
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local Backpack = player:WaitForChild("Backpack")
local Data = player:WaitForChild("Data")

---------------- FRUIT DATA ----------------
local FruitData = {
    Mythical = { Color = 0xff0000, List = {
        "Kitsune","Tiger","Dragon","Spirit","Control",
        "Venom","Shadow","Dough","T Rex","Gravity"
    }},
    Legendary = { Color = 0xff00ff, List = {
        "Mammoth","Blizzard","Pain","Rumble","Portal",
        "Phoenix","Sound","Spider","Love","Buddha"
    }},
    Rare = { Color = 0x0099ff, List = {
        "Quake","Magma","Ghost","Barrier","Rubber",
        "Light","Diamond"
    }},
    Uncommon = { Color = 0x00ff99, List = {
        "Dark","Sand","Ice","Falcon","Flame",
        "Spike","Smoke"
    }},
    Common = { Color = 0xcccccc, List = {
        "Rocket","Spin","Chop","Spring","Bomb"
    }}
}

---------------- STATS ----------------
local Stats = {
    StartTime = os.time(),
    LastFruitTime = 0,
    LastFruitSent = 0,
    FruitCount = 0,
    LastBeliMilestone = 0
}

---------------- UTILS ----------------
local function formatTime(sec)
    local h = math.floor(sec / 3600)
    local m = math.floor((sec % 3600) / 60)
    local s = sec % 60
    return string.format("%02dh %02dm %02ds", h, m, s)
end

local function normalizeName(name)
    return name
        :gsub(" Fruit","")
        :gsub(" fruta","")
        :gsub("Fruta ","")
        :gsub("-", " ")
        :lower()
end

local function getFruitInfo(name)
    local clean = normalizeName(name)

    for category, data in pairs(FruitData) do
        for _, fname in ipairs(data.List) do
            if clean:find(fname:lower()) then
                return category, data.Color, fname
            end
        end
    end

    return "Desconhecido", 0xffffff, name
end

local function sendDiscord(title, fields, color)
    local data = {
        embeds = {{
            title = title,
            color = color,
            fields = fields,
            thumbnail = { url = Config.Icon },
            footer = { text = Config.Footer },
            timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }}
    }

    local req = syn and syn.request or http_request or request
    if not req then return end

    pcall(function()
        req({
            Url = Config.Webhook,
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = HttpService:JSONEncode(data)
        })
    end)
end

---------------- SESSION START ----------------
sendDiscord("🟢 Bot Online", {
    { name = "Jogador", value = player.Name, inline = true },
    { name = "Level", value = tostring(Data.Level.Value), inline = true },
    { name = "JobId", value = game.JobId, inline = false }
}, 0x00ff00)

---------------- FRUIT MONITOR ----------------
Backpack.ChildAdded:Connect(function(item)
    if not item:IsA("Tool") then return end

    local lname = item.Name:lower()
    if not (lname:find("fruit") or lname:find("fruta")) then return end

    local now = os.time()
    if now - Stats.LastFruitSent < Config.FruitCooldown then return end
    Stats.LastFruitSent = now

    Stats.FruitCount += 1
    local sinceLast = Stats.LastFruitTime > 0 and (now - Stats.LastFruitTime) or 0
    Stats.LastFruitTime = now

    local category, color, realName = getFruitInfo(item.Name)

    sendDiscord("🍎 Fruta Detectada", {
        { name = "Fruta", value = realName, inline = true },
        { name = "Raridade", value = category, inline = true },
        { name = "Total na sessão", value = tostring(Stats.FruitCount), inline = true },
        { name = "Tempo desde última", value = sinceLast > 0 and formatTime(sinceLast) or "Primeira fruta", inline = false }
    }, color)
end)

---------------- BELI MONITOR ----------------
task.spawn(function()
    while task.wait(Config.BeliCheckDelay) do
        local beli = Data.Beli.Value
        local milestone = math.floor(beli / Config.BeliMilestone)

        if milestone > Stats.LastBeliMilestone then
            Stats.LastBeliMilestone = milestone

            sendDiscord("💰 Marco de Beli", {
                { name = "Beli atual", value = tostring(beli), inline = true },
                { name = "Marco", value = milestone .. "M", inline = true },
                { name = "Tempo farmando", value = formatTime(os.time() - Stats.StartTime), inline = false }
            }, 0x00ff00)
        end
    end
end)

---------------- LEVEL UP ----------------
Data.Level:GetPropertyChangedSignal("Value"):Connect(function()
    sendDiscord("⬆️ Level Up", {
        { name = "Novo level", value = tostring(Data.Level.Value), inline = true }
    }, 0x0099ff)
end)
