--[[ 
    👑 SUPREME HUB V10 - FARM DE FRUTAS AFK (FIXED)
    ✔ SEM ERROS
    ✔ SEM CRASH
    ✔ SERVER HOP ESTÁVEL
    ✔ WEBHOOK SEGURO
]]

getgenv().FruitScript = true

local player = game.Players.LocalPlayer
local rs = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

-- CONFIG WEBHOOK
local webhookURL = "https://discord.com/api/webhooks/1466207661639864362/E8Emrn_rC15_LJRjZuE0tM3y7JdsbvA8_vBDofO0OWnQ5Batq7KlqxuhwiCXx9cwhsSt"

local function sendWebhook(msg)
    if webhookURL == "" then return end
    pcall(function()
        HttpService:PostAsync(
            webhookURL,
            HttpService:JSONEncode({ content = msg }),
            Enum.HttpContentType.ApplicationJson
        )
    end)
end

-- LOG SIMPLES (SEM Color3 BUGADO)
getgenv().Logs = {}
local function addLog(msg)
    table.insert(getgenv().Logs, 1, "[" .. os.date("%H:%M:%S") .. "] " .. msg)
    if #getgenv().Logs > 15 then
        table.remove(getgenv().Logs)
    end
end

-- SERVER HOP
local hopping = false
local function serverHop()
    if hopping then return end
    hopping = true

    addLog("🔄 Server hop...")
    sendWebhook("🔄 Server hop...")

    local success, servers = pcall(function()
        return HttpService:JSONDecode(
            game:HttpGet(
                "https://games.roblox.com/v1/games/"
                .. game.PlaceId ..
                "/servers/Public?sortOrder=Asc&limit=100"
            )
        ).data
    end)

    if success then
        for _, v in pairs(servers) do
            if v.playing < v.maxPlayers and v.id ~= game.JobId then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, v.id)
                return
            end
        end
    end

    hopping = false
end

-- INÍCIO
addLog("🚀 Script iniciado")
sendWebhook("🚀 SUPREME HUB V10 INICIADO")

-- HEARTBEAT
task.spawn(function()
    while task.wait(600) do
        sendWebhook("⏳ Script ativo")
    end
end)

-- LOOP PRINCIPAL
task.spawn(function()
    while task.wait(5) do
        pcall(function()
            if not getgenv().FruitScript then return end

            local char = player.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local humanoid = char and char:FindFirstChildOfClass("Humanoid")
            if not (hrp and humanoid) then return end

            local encontrouFruta = false

            for _, item in pairs(workspace:GetChildren()) do
                if item:IsA("Tool")
                and item:FindFirstChild("Handle")
                and string.find(item.Name:lower(), "fruit") then

                    encontrouFruta = true

                    -- PUXA FRUTA
                    item.Handle.CFrame = hrp.CFrame + Vector3.new(0, 3, 0)
                    task.wait(0.3)
                    humanoid:EquipTool(item)
                    task.wait(0.5)

                    -- GUARDA
                    local ok = rs.Remotes.CommF_:InvokeServer(
                        "StoreFruit",
                        item.Name
                    )

                    if ok then
                        addLog("✅ Guardada: " .. item.Name)
                        sendWebhook("✅ Guardada: " .. item.Name)
                    else
                        addLog("❌ Inventário cheio: " .. item.Name)
                        sendWebhook("❌ Inventário cheio")
                    end

                    task.wait(1)
                end
            end

            -- SEM FRUTA → SERVER HOP
            if not encontrouFruta then
                serverHop()
            end
        end)
    end
end)
