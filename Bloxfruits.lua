-- Hub Ultra Completo com Rayfield (sem key)
-- Inspirado em Hoho Hub, mas feito do zero

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
   Name = "Hub Ultra Bruno",
   LoadingTitle = "Carregando Hub Ultra...",
   LoadingSubtitle = "Feito com Rayfield",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "HubUltraBruno",
      FileName = "Config"
   }
})

-- Função de Webhook
function SendWebhook(message)
    local HttpService = game:GetService("HttpService")
    local url = "https://discord.com/api/webhooks/1466207661639864362/E8Emrn_rC15_LJRjZuE0tM3y7JdsbvA8_vBDofO0OWnQ5Batq7KlqxuhwiCXx9cwhsSt" -- coloque seu webhook aqui

    local data = {["content"] = message}
    local jsonData = HttpService:JSONEncode(data)
    HttpService:PostAsync(url, jsonData, Enum.HttpContentType.ApplicationJson)
end

local VirtualUser = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)

-- 🗡️ Aba de Farm
local FarmTab = Window:CreateTab("Farm", 4483362458)

FarmTab:CreateToggle({
   Name = "Auto Farm Super Rápido",
   CurrentValue = false,
   Flag = "AutoFarmFast",
   Callback = function(state)
      _G.AutoFarmFast = state
      if state then
         spawn(function()
            while _G.AutoFarmFast do
               local hrp = game.Players.LocalPlayer.Character.HumanoidRootPart
               for _, enemy in pairs(workspace.Enemies:GetChildren()) do
                  if enemy:FindFirstChild("HumanoidRootPart") then
                     -- Bring mob até você
                     enemy.HumanoidRootPart.CFrame = hrp.CFrame + Vector3.new(math.random(-5,5),0,math.random(-5,5))
                     -- Simula ataque rápido
                     VirtualUser:Button1Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
                     wait(0.05)
                     VirtualUser:Button1Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
                  end
               end
               wait(0.2)
            end
         end)
      end
   end,
})

FarmTab:CreateButton({
   Name = "Bring Mobs",
   Callback = function()
      local hrp = game.Players.LocalPlayer.Character.HumanoidRootPart
      for _, enemy in pairs(workspace.Enemies:GetChildren()) do
         if enemy:FindFirstChild("HumanoidRootPart") then
            enemy.HumanoidRootPart.CFrame = hrp.CFrame + Vector3.new(math.random(-5,5),0,math.random(-5,5))
         end
      end
      SendWebhook("⚔️ Bring Mobs ativado, inimigos puxados até você!")
   end
})

-- 🌍 Aba de Teleporte (Sea 1, 2, 3)
local TeleportTab = Window:CreateTab("Teleportes", 4483362458)

TeleportTab:CreateDropdown({
   Name = "First Sea",
   Options = {"Marineford","Sky Island","Prison"},
   CurrentOption = "Marineford",
   Flag = "Sea1TP",
   Callback = function(Option)
      local locations = {
         ["Marineford"] = workspace.Marineford.SpawnLocation.CFrame,
         ["Sky Island"] = workspace.SkyIsland.SpawnLocation.CFrame,
         ["Prison"] = workspace.Prison.SpawnLocation.CFrame
      }
      game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = locations[Option]
      SendWebhook("🌍 Teleportado para: " .. Option)
   end,
})

TeleportTab:CreateDropdown({
   Name = "Second Sea",
   Options = {"Cafe","Colosseum","Green Zone"},
   CurrentOption = "Cafe",
   Flag = "Sea2TP",
   Callback = function(Option)
      local locations = {
         ["Cafe"] = workspace.Cafe.SpawnLocation.CFrame,
         ["Colosseum"] = workspace.Colosseum.SpawnLocation.CFrame,
         ["Green Zone"] = workspace.GreenZone.SpawnLocation.CFrame
      }
      game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = locations[Option]
      SendWebhook("🌍 Teleportado para: " .. Option)
   end,
})

TeleportTab:CreateDropdown({
   Name = "Third Sea",
   Options = {"Mansion","Hydra Island","Great Tree"},
   CurrentOption = "Mansion",
   Flag = "Sea3TP",
   Callback = function(Option)
      local locations = {
         ["Mansion"] = workspace.Mansion.SpawnLocation.CFrame,
         ["Hydra Island"] = workspace.HydraIsland.SpawnLocation.CFrame,
         ["Great Tree"] = workspace.GreatTree.SpawnLocation.CFrame
      }
      game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = locations[Option]
      SendWebhook("🌍 Teleportado para: " .. Option)
   end,
})

-- 🍇 Aba de Frutas (Fruit Sniper Inteligente)
local FruitTab = Window:CreateTab("Frutas", 4483362458)

local collectedFruits = {}

FruitTab:CreateToggle({
   Name = "Auto Fruit Sniper Inteligente",
   CurrentValue = false,
   Flag = "FruitSniperSmart",
   Callback = function(state)
      _G.FruitSniperSmart = state
      if state then
         spawn(function()
            while _G.FruitSniperSmart do
               local player = game.Players.LocalPlayer
               local hrp = player.Character:WaitForChild("HumanoidRootPart")
               for _, fruit in pairs(workspace:GetChildren()) do
                  if fruit:IsA("Tool") and fruit:FindFirstChild("Handle") then
                     if not collectedFruits[fruit.Name] then
                        fruit.Handle.CFrame = hrp.CFrame + Vector3.new(0,3,0)
                        collectedFruits[fruit.Name] = true
                        SendWebhook("🍇 Nova fruta coletada: " .. fruit.Name)
                     else
                        -- já coletada, joga fora
                        fruit:Destroy()
                        SendWebhook("🗑️ Fruta duplicada descartada: " .. fruit.Name)
                     end
                  end
               end
               wait(3)
            end
         end)
      end
   end
})
