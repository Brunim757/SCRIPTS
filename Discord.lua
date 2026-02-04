--==================================================
-- BLOX FRUITS FARM MONITOR - FULL + IMPROVED
-- Beli | Frutas (detecção dupla) | Sessão | Alertas
--==================================================

---------------- CONFIG ----------------
local Config = {
    Webhook = "https://discord.com/api/webhooks/1468450683832242373/FjjQxp03SB8sk1J-sBUsWbr2LYjd9AJEFppolEArJjlYL0WgKXQz-7GzrTsNoaqXJeaf",
    BeliMilestone = 1_000_000,
    BeliCheckDelay = 5,
    InventoryCheckDelay = 2,
    FooterText = "Blox Fruits Farm Monitor"
}

---------------- SERVICES ----------------
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer
local Backpack = player:WaitForChild("Backpack")

---------------- STATS ----------------
local Stats = {
    StartTime = os.time(),
    LastBeliMilestone = 0,
    LastMilestoneTime = os.time(),
    FruitsCollected = 0,
    LastInventoryCount = 0
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
            footer = { text = Config.FooterText },
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

---------------- START LOG ----------------
sendEmbed(
    "🟢 Farm iniciado",
    "Sistema de monitoramento ativo",
    {
        {name="Jogador", value=player.Name, inline=true},
        {name="Level", value=tostring(player.Data.Level.Value), inline=true}
    },
    0x00ff00
)

---------------- BELI MONITOR ----------------
task.spawn(function()
    while task.wait(Config.BeliCheckDelay) do
        local beli = player.Data.Beli.Value
        local milestone = math.floor(beli / Config.BeliMilestone)

        if milestone > Stats.LastBeliMilestone then
            local now = os.time()
            local delta = now - Stats.LastMilestoneTime

            Stats.LastBeliMilestone = milestone
            Stats.LastMilestoneTime = now

            sendEmbed(
                "💰 Novo marco de Beli",
                "Progresso detectado",
                {
                    {name="Beli atual", value=tostring(beli), inline=true},
                    {name="Marco", value=milestone .. "M", inline=true},
                    {name="Tempo p/ último 1M", value=formatTime(delta), inline=false},
                    {name="Tempo total", value=formatTime(now - Stats.StartTime), inline=false}
                },
                0x00ff00
            )
        end
    end
end)

---------------- FRUIT EVENT DETECTION ----------------
Backpack.ChildAdded:Connect(function(tool)
    if tool:IsA("Tool") and tool.Name:lower():find("fruit") then
        Stats.FruitsCollected += 1

        sendEmbed(
            "🍏 Fruta detectada",
            "Nova fruta apareceu no Backpack",
            {
                {name="Fruta", value=tool.Name, inline=true},
                {name="Total detectadas", value=tostring(Stats.FruitsCollected), inline=true}
            },
            0x00ff00
        )
    end
end)

---------------- INVENTORY COMPARISON (REAL CHECK) ----------------
local function countFruits()
    local count = 0
    for _, item in ipairs(Backpack:GetChildren()) do
        if item:IsA("Tool") and item.Name:lower():find("fruit") then
            count += 1
        end
    end
    return count
end

Stats.LastInventoryCount = countFruits()

task.spawn(function()
    while task.wait(Config.InventoryCheckDelay) do
        local currentCount = countFruits()

        if currentCount > Stats.LastInventoryCount then
            sendEmbed(
                "📦 Fruta guardada",
                "Inventário aumentou",
                {
                    {name="Antes", value=tostring(Stats.LastInventoryCount), inline=true},
                    {name="Agora", value=tostring(currentCount), inline=true},
                    {name="Beli atual", value=tostring(player.Data.Beli.Value), inline=true}
                },
                0x00ff00
            )
        elseif currentCount < Stats.LastInventoryCount then
            sendEmbed(
                "📉 Fruta removida",
                "Inventário diminuiu",
                {
                    {name="Antes", value=tostring(Stats.LastInventoryCount), inline=true},
                    {name="Agora", value=tostring(currentCount), inline=true}
                },
                0xff0000
            )
        end

        Stats.LastInventoryCount = currentCount
    end
end)

---------------- LEVEL UP ----------------
player.Data.Level:GetPropertyChangedSignal("Value"):Connect(function()
    sendEmbed(
        "⬆️ Level up",
        "Novo level alcançado",
        {
            {name="Level atual", value=tostring(player.Data.Level.Value), inline=true}
        },
        0x0099ff
    )
end)

---------------- TELEPORT / KICK ----------------
player.OnTeleport:Connect(function(state)
    if state == Enum.TeleportState.Failed then
        sendEmbed(
            "🚨 ALERTA",
            "Teleport falhou ou possível kick",
            {},
            0xff0000
        )
    end
end)

---------------- SESSION END ----------------
game:BindToClose(function()
    sendEmbed(
        "🔴 Farm finalizado",
        "Script encerrado ou jogo fechado",
        {
            {name="Tempo total", value=formatTime(os.time() - Stats.StartTime), inline=true},
            {name="Frutas detectadas", value=tostring(Stats.FruitsCollected), inline=true}
        },
        0xff0000
    )
end)
