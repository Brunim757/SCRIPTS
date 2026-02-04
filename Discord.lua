--==================================================
-- BLOX FRUITS ADVANCED LOGGER v1.0
-- Frutas | Categorias | Tempo | Anti-spam | Beli
--==================================================

---------------- CONFIG ----------------
local Config = {
    Webhook = "https://discord.com/api/webhooks/1468450683832242373/FjjQxp03SB8sk1J-sBUsWbr2LYjd9AJEFppolEArJjlYL0WgKXQz-7GzrTsNoaqXJeaf",
    BeliMilestone = 1_000_000,
    BeliCheckDelay = 5,
    FruitSpamCooldown = 5, -- segundos
    Footer = "Blox Fruits Advanced Logger"
}

---------------- SERVICES ----------------
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local Backpack = player:WaitForChild("Backpack")
local Data = player:WaitForChild("Data")

---------------- FRUIT CATEGORIES ----------------
local FruitCategories = {
    Mythical = {
        "Leopard","Kitsune","Dragon","Spirit","Control"
    },
    Legendary = {
        "Dough","Venom","Shadow","Blizzard","Gravity","Mammoth"
    },
    Rare = {
        "Phoenix","Portal","Rumble","Buddha","String","Pain"
    },
    Uncommon = {
        "Light","Dark","Magma","Quake","Barrier"
    }
}

local function getFruitCategory(name)
    for category, list in pairs(FruitCategories) do
        for _, fruit in ipairs(list) do
            if name:lower():find(fruit:lower()) then
                return category
            end
        end
    end
    return "Common"
end

local CategoryColors = {
    Mythical = 0xff0000,
    Legendary = 0xff00ff,
    Rare = 0x0099ff,
    Uncommon = 0x00ff99,
    Common = 0xffffff
}

---------------- SESSION STATS ----------------
local Stats = {
    StartTime = os.time(),
    LastFruitTime = nil,
    LastFruitSent = 0,
    FruitCount = 0,
    FruitsByCategory = {
        Mythical = 0,
        Legendary = 0,
        Rare = 0,
        Uncommon = 0,
        Common = 0
    },
    LastBeliMilestone = 0
}

---------------- UTILS ----------------
local function formatTime(sec)
    local h = math.floor(sec / 3600)
    local m = math.floor((sec % 3600) / 60)
    local s = sec % 60
    return string.format("%02dh %02dm %02ds", h, m, s)
end

local function sendEmbed(title, description, fields, color)
    local data = {
        embeds = {{
            title = title,
            description = description,
            color = color or 0x00ff00,
            fields = fields or {},
            footer = { text = Config.Footer },
            timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }}
    }

    pcall(function()
        request({
            Url = Config.Webhook,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode(data)
        })
    end)
end

---------------- SESSION START ----------------
sendEmbed(
    "🟢 Sessão iniciada",
    "Logger ativo",
    {
        {name="Jogador", value=player.Name, inline=true},
        {name="Level", value=tostring(Data.Level.Value), inline=true}
    },
    0x00ff00
)

---------------- BELI MONITOR ----------------
task.spawn(function()
    while task.wait(Config.BeliCheckDelay) do
        local beli = Data.Beli.Value
        local milestone = math.floor(beli / Config.BeliMilestone)

        if milestone > Stats.LastBeliMilestone then
            Stats.LastBeliMilestone = milestone
            sendEmbed(
                "💰 Marco de Beli",
                "Novo marco alcançado",
                {
                    {name="Beli", value=tostring(beli), inline=true},
                    {name="Milhões", value=milestone .. "M", inline=true},
                    {name="Tempo", value=formatTime(os.time() - Stats.StartTime), inline=false}
                },
                0x00ff00
            )
        end
    end
end)

---------------- FRUIT DETECTION ----------------
Backpack.ChildAdded:Connect(function(tool)
    if not tool:IsA("Tool") then return end
    if not tool.Name:lower():find("fruit") then return end

    local now = os.time()
    if now - Stats.LastFruitSent < Config.FruitSpamCooldown then
        return
    end

    Stats.LastFruitSent = now
    Stats.FruitCount += 1

    local category = getFruitCategory(tool.Name)
    Stats.FruitsByCategory[category] += 1

    local timeSinceLast = Stats.LastFruitTime and (now - Stats.LastFruitTime) or 0
    Stats.LastFruitTime = now

    sendEmbed(
        "🍏 Fruta coletada",
        "Nova fruta obtida",
        {
            {name="Fruta", value=tool.Name, inline=true},
            {name="Categoria", value=category, inline=true},
            {name="Total na sessão", value=tostring(Stats.FruitCount), inline=true},
            {name="Tempo desde a última", value=timeSinceLast > 0 and formatTime(timeSinceLast) or "Primeira fruta", inline=false}
        },
        CategoryColors[category]
    )
end)

---------------- LEVEL UP ----------------
Data.Level:GetPropertyChangedSignal("Value"):Connect(function()
    sendEmbed(
        "⬆️ Level Up",
        "Novo level alcançado",
        {
            {name="Level atual", value=tostring(Data.Level.Value), inline=true}
        },
        0x0099ff
    )
end)

---------------- SESSION END ----------------
game:BindToClose(function()
    sendEmbed(
        "🔴 Sessão finalizada",
        "Resumo da sessão",
        {
            {name="Tempo total", value=formatTime(os.time() - Stats.StartTime), inline=false},
            {name="Beli final", value=tostring(Data.Beli.Value), inline=true},
            {name="Frutas totais", value=tostring(Stats.FruitCount), inline=true},
            {name="Mythical", value=tostring(Stats.FruitsByCategory.Mythical), inline=true},
            {name="Legendary", value=tostring(Stats.FruitsByCategory.Legendary), inline=true},
            {name="Rare", value=tostring(Stats.FruitsByCategory.Rare), inline=true}
        },
        0xff0000
    )
end)
