--==================================================
-- BLOX FRUITS FARM MONITOR - FULL SYSTEM
-- Beli | Frutas | Sessão | Alertas | Discord Embed
--==================================================

--============ CONFIG ============--
local Config = {
    Webhook = "https://discord.com/api/webhooks/1468450683832242373/FjjQxp03SB8sk1J-sBUsWbr2LYjd9AJEFppolEArJjlYL0WgKXQz-7GzrTsNoaqXJeaf",
    BeliMilestone = 1_000_000, -- 1M
    CheckDelay = 5,            -- segundos
    FooterText = "Blox Fruits Farm Monitor"
}

--============ SERVICES ============--
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer

--============ STATS ============--
local Stats = {
    StartTime = os.time(),
    LastBeliMilestone = 0,
    FruitsCollected = 0,
    LastMilestoneTime = os.time()
}

--============ UTILS ============--
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

--============ START LOG ============--
sendEmbed(
    "🟢 Farm iniciado",
    "Monitoramento iniciado com sucesso",
    {
        {name="Jogador", value=player.Name, inline=true},
        {name="Level", value=tostring(player.Data.Level.Value), inline=true}
    },
    0x00ff00
)

--============ BELI MONITOR ============--
task.spawn(function()
    while task.wait(Config.CheckDelay) do
        local beli = player.Data.Beli.Value
        local milestone = math.floor(beli / Config.BeliMilestone)

        if milestone > Stats.LastBeliMilestone then
            local now = os.time()
            local delta = now - Stats.LastMilestoneTime

            Stats.LastBeliMilestone = milestone
            Stats.LastMilestoneTime = now

            sendEmbed(
                "💰 Novo marco de Beli",
                "Progresso automático detectado",
                {
                    {name="Beli atual", value=string.format("%d", beli), inline=true},
                    {name="Marco", value=milestone .. "M", inline=true},
                    {name="Tempo p/ último 1M", value=formatTime(delta), inline=false},
                    {name="Tempo total farmando", value=formatTime(now - Stats.StartTime), inline=false}
                },
                0x00ff00
            )
        end
    end
end)

--============ FRUIT MONITOR ============--
local Backpack = player:WaitForChild("Backpack")

Backpack.ChildAdded:Connect(function(tool)
    if tool:IsA("Tool") and tool.Name:lower():find("fruit") then
        Stats.FruitsCollected += 1

        task.wait(2)
        local stored = tool.Parent == Backpack

        sendEmbed(
            "🍏 Fruta obtida",
            tool.Name,
            {
                {name="Status", value=stored and "✅ Guardada" or "❌ Não guardada", inline=true},
                {name="Total de frutas", value=tostring(Stats.FruitsCollected), inline=true},
                {name="Beli atual", value=tostring(player.Data.Beli.Value), inline=true}
            },
            stored and 0x00ff00 or 0xff0000
        )
    end
end)

--============ LEVEL CHANGE ============--
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

--============ TELEPORT / KICK ALERT ============--
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

--============ SCRIPT END FAILSAFE ============--
game:BindToClose(function()
    sendEmbed(
        "🔴 Farm finalizado",
        "Script encerrado ou jogo fechado",
        {
            {name="Tempo total", value=formatTime(os.time() - Stats.StartTime), inline=true},
            {name="Frutas coletadas", value=tostring(Stats.FruitsCollected), inline=true}
        },
        0xff0000
    )
end)
