--[[ 
👑 SUPREME HUB V10 - FRUIT FARM MOBILE
📱 MOBILE SAFE
📊 CONTADOR
🛡 BYPASS BÁSICO
]]

getgenv().FruitScript = true

-- SERVICES
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")

-- CONFIG
local WEBHOOK = "https://discord.com/api/webhooks/1466207661639864362/E8Emrn_rC15_LJRjZuE0tM3y7JdsbvA8_vBDofO0OWnQ5Batq7KlqxuhwiCXx9cwhsSt"

-- CONTADORES
getgenv().FruitCount = 0
getgenv().StoredCount = 0
getgenv().FailCount = 0

-- ================= WEBHOOK SAFE =================
local function sendWebhook(msg)
    if WEBHOOK == "" then return end
    pcall(function()
        HttpService:PostAsync(
            WEBHOOK,
            HttpService:JSONEncode({ content = msg }),
            Enum.HttpContentType.ApplicationJson
        )
    end)
end

sendWebhook("📱 SUPREME HUB MOBILE INICIADO")

-- ================= ANTI AFK (MOBILE) =================
player.Idled:Connect(function()
    pcall(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end)

-- ================= AUTO PIRATE =================
task.delay(3, function()
    pcall(function()
        RS.Remotes.CommF_:InvokeServer("SetTeam", "Pirates")
    end)
end)

-- ================= SERVER HOP (SAFE) =================
local hopping = false
local lastHop = 0

local function serverHop()
    if hopping then return end
    if tick() - lastHop < 15 then return end -- bypass
    hopping = true
    lastHop = tick()

    sendWebhook("🔄 Server hop (mobile safe)")

    local ok, servers = pcall(function()
        return HttpService:JSONDecode(
            game:HttpGet(
                "https://games.roblox.com/v1/games/"
                .. game.PlaceId ..
                "/servers/Public?sortOrder=Asc&limit=100"
            )
        ).data
    end)

    if ok then
        for _, v in pairs(servers) do
            if v.playing < v.maxPlayers - 1 and v.id ~= game.JobId then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, v.id)
                return
            end
        end
    end

    hopping = false
end

-- ================= LOOP PRINCIPAL =================
task.spawn(function()
    while task.wait(6) do -- MOBILE DELAY
        if not getgenv().FruitScript then return end

        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")
        if not (hrp and humanoid) then continue end

        local encontrou = false
        local guardou = false

        for _, tool in pairs(workspace:GetChildren()) do
            if tool:IsA("Tool")
            and tool:FindFirstChild("Handle")
            and tool.Name:lower():find("fruit") then

                encontrou = true
                getgenv().FruitCount += 1

                -- PUXA
                tool.Handle.CFrame = hrp.CFrame + Vector3.new(0,3,0)
                task.wait(0.5)

                humanoid:EquipTool(tool)
                task.wait(0.6)

                -- STORE
                local ok = RS.Remotes.CommF_:InvokeServer(
                    "StoreFruit",
                    tool.Name
                )

                if ok then
                    guardou = true
                    getgenv().StoredCount += 1
                    sendWebhook("✅ Guardada: "..tool.Name.." | Total: "..getgenv().StoredCount)
                else
                    getgenv().FailCount += 1
                    sendWebhook("⚠ Inventário cheio | Falhas: "..getgenv().FailCount)
                    task.wait(10)
                end

                task.wait(2) -- BYPASS HUMANO
            end
        end

        -- DECISÃO
        if not encontrou then
            serverHop()
        elseif encontrou and not guardou then
            serverHop()
        end
    end
end)

-- ================= STATUS =================
task.spawn(function()
    while task.wait(300) do
        sendWebhook(
            "📊 STATUS\n"..
            "🍏 Coletadas: "..getgenv().FruitCount..
            "\n📦 Guardadas: "..getgenv().StoredCount..
            "\n❌ Falhas: "..getgenv().FailCount
        )
    end
end)
