--[[ 
    👑 SUPREME HUB V10 - FARM DE FRUTAS AFK COMPLETO
    FOCO: PUXAR FRUTA + GUARDAR + SERVER HOP AUTOMÁTICO + WEBHOOK
]]

getgenv().FruitScript = true
local player = game.Players.LocalPlayer
local rs = game:GetService("ReplicatedStorage")
local sg = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

-- CONFIGURAÇÃO DO WEBHOOK
local webhookURL = "https://discord.com/api/webhooks/1466207661639864362/E8Emrn_rC15_LJRjZuE0tM3y7JdsbvA8_vBDofO0OWnQ5Batq7KlqxuhwiCXx9cwhsSt"

local function sendWebhook(msg)
    local data = {["content"] = msg}
    local jsonData = HttpService:JSONEncode(data)
    HttpService:PostAsync(webhookURL, jsonData, Enum.HttpContentType.ApplicationJson)
end

-- LOGS
getgenv().Logs = {}
local function addLog(msg, cor)
    table.insert(getgenv().Logs, 1, "<b>["..os.date("%H:%M").."]</b> <font color='#"..cor:ToHex().."'>"..msg.."</font>")
    if #getgenv().Logs > 12 then table.remove(getgenv().Logs, #getgenv().Logs) end
end

-- SERVER HOP AUTOMÁTICO
local function serverHop()
    addLog("🔄 Trocando de servidor...", Color3.new(1,0.5,0))
    sendWebhook("🔄 Trocando de servidor...")
    local success, result = pcall(function()
        return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100")).data
    end)
    if success then
        for _, v in pairs(result) do
            if v.playing < v.maxPlayers and v.id ~= game.JobId then
                game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, v.id)
                return
            end
        end
    end
    addLog("❌ Erro na API do Roblox", Color3.new(1,0,0))
    sendWebhook("❌ Erro na API do Roblox")
end

-- LOOP PRINCIPAL
task.spawn(function()
    while true do
        task.wait(5) -- espera entre checagens
        pcall(function()
            local char = player.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local encontrouFruta = false

            if getgenv().FruitScript and hrp then
                for _, f in pairs(workspace:GetChildren()) do
                    if f:IsA("Tool") and (f.Name:find("Fruit") or f:FindFirstChild("Handle")) then
                        encontrouFruta = true
                        if f:FindFirstChild("Handle") then
                            -- Puxa fruta até você
                            f.Handle.CFrame = hrp.CFrame + Vector3.new(0, 3, 0)
                            task.wait(0.3)
                            char.Humanoid:EquipTool(f)
                            task.wait(0.5)

                            local guardou = rs.Remotes.CommF_:InvokeServer("StoreFruit", f.Name, f)
                            if guardou == true then
                                addLog("✅ GUARDADA: "..f.Name, Color3.new(0,1,0))
                                sendWebhook("✅ GUARDADA: "..f.Name)
                            else
                                addLog("❌ INVENTÁRIO CHEIO: "..f.Name, Color3.new(1,0,0))
                                sendWebhook("❌ INVENTÁRIO CHEIO: "..f.Name)
                            end
                        end
                    end
                end
            end

            -- Se não encontrou fruta, troca de servidor
            if not encontrouFruta then
                serverHop()
            else
                -- Espera um pouco antes de decidir trocar
                task.wait(10)
                local aindaTem = false
                for _, f in pairs(workspace:GetChildren()) do
                    if f:IsA("Tool") and (f.Name:find("Fruit") or f:FindFirstChild("Handle")) then
                        aindaTem = true
                        break
                    end
                end
                if not aindaTem then
                    serverHop()
                end
            end
        end)
    end
end)
