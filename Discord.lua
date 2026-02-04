--==================================================
-- BLOX FRUITS ULTIMATE MONITOR v2.4 (BR)
-- Leopard removida → Tiger adicionada
-- Frutas inexistentes removidas
--==================================================

local Config = {
    Webhook = "https://discord.com/api/webhooks/1468450683832242373/FjjQxp03SB8sk1J-sBUsWbr2LYjd9AJEFppolEArJjlYL0WgKXQz-7GzrTsNoaqXJeaf", -- COLOQUE SEU WEBHOOK AQUI
    Footer = "Blox Fruits Bot Notifier",
    Icon = "https://imgur.com/gallery/blox-fruits-NsWk189#Vi1TUFQ"
}

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer

---------------------------------------------------
-- CATEGORIAS ATUALIZADAS (UPDATE ATUAL)
---------------------------------------------------
local FruitData = {
    Mythical = {
        Color = 0xff0000,
        List = {
            "Kitsune",
            "Tiger",      -- Leopard substituída
            "Dragon",
            "Spirit",
            "Control",
            "Venom",
            "Shadow",
            "Dough",
            "T Rex",
            "Gravity"
        }
    },

    Legendary = {
        Color = 0xff00ff,
        List = {
            "Mammoth",
            "Blizzard",
            "Pain",
            "Rumble",
            "Portal",
            "Phoenix",
            "Sound",
            "Spider",
            "Love",
            "Buddha"
        }
    },

    Rare = {
        Color = 0x0099ff,
        List = {
            "Quake",
            "Magma",
            "Ghost",
            "Barrier",
            "Rubber",
            "Light",
            "Diamond"
        }
    },

    Uncommon = {
        Color = 0x00ff99,
        List = {
            "Dark",
            "Sand",
            "Ice",
            "Falcon",
            "Flame",
            "Spike",
            "Smoke"
        }
    },

    Common = {
        Color = 0xcccccc,
        List = {
            "Rocket",
            "Spin",
            "Chop",
            "Spring",
            "Bomb"
        }
    }
}

---------------------------------------------------
-- FUNÇÃO DE IDENTIFICAÇÃO DE FRUTA
---------------------------------------------------
local function getFruitInfo(name)
    local cleanName = name
        :gsub(" Fruit", "")
        :gsub(" fruta", "")
        :gsub("Fruta ", "")
        :gsub("-", " ")
        :lower()

    for category, data in pairs(FruitData) do
        for _, fName in ipairs(data.List) do
            if cleanName:find(fName:lower()) then
                return category, data.Color, fName
            end
        end
    end

    return "Desconhecido", 0xffffff, name
end

---------------------------------------------------
-- WEBHOOK DISCORD
---------------------------------------------------
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

    pcall(function()
        local req = syn and syn.request or http_request or request
        if req then
            req({
                Url = Config.Webhook,
                Method = "POST",
                Headers = { ["Content-Type"] = "application/json" },
                Body = HttpService:JSONEncode(data)
            })
        end
    end)
end

---------------------------------------------------
-- DETECTOR DE FRUTAS NO INVENTÁRIO
---------------------------------------------------
player.Backpack.ChildAdded:Connect(function(item)
    if not item:IsA("Tool") then return end

    local lname = item.Name:lower()
    if not (lname:find("fruit") or lname:find("fruta")) then return end

    local category, color, realName = getFruitInfo(item.Name)

    sendDiscord("🍎 Nova Fruta Detectada!", {
        { name = "🏷️ Fruta:", value = "**" .. realName .. "**", inline = true },
        { name = "💎 Raridade:", value = category, inline = true },
        { name = "👤 Jogador:", value = player.Name, inline = false },
        { name = "🆔 JobId:", value = game.JobId, inline = false }
    }, color)
end)

---------------------------------------------------
-- STATUS INICIAL
---------------------------------------------------
sendDiscord("🟢 Bot Online", {
    { name = "Status:", value = "Monitorando frutas do Blox Fruits", inline = true },
    { name = "Jogador:", value = player.Name, inline = true }
}, 0x00ff00)
