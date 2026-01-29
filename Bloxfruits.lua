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

    local data = {
        ["content"] = message
    }

    local jsonData = HttpService:JSONEncode(data)
    HttpService:PostAsync(url, jsonData, Enum.HttpContentType.ApplicationJson)
end

-- 🗡️ Aba de Farm
local FarmTab = Window:CreateTab("Farm", 4483362458)
FarmTab:CreateToggle({
   Name = "Auto Farm",
   CurrentValue = false,
   Flag = "AutoFarm",
   Callback = function(state)
      _G.AutoFarm = state
      if state then
         spawn(function()
            while _G.AutoFarm do
               for _, enemy in pairs(workspace.Enemies:GetChildren()) do
                  if enemy:FindFirstChild("HumanoidRootPart") then
                     game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0,5,0)
                     game:GetService("ReplicatedStorage").Remotes.Attack:FireServer(enemy)
                     SendWebhook("⚔️ Auto Farm derrotou: " .. enemy.Name)
                  end
               end
               wait(1)
            end
         end)
      end
   end,
})

FarmTab:CreateDropdown({
   Name = "Escolher Boss",
   Options = {"Marine Boss", "Sky Boss", "Ice Admiral"},
   CurrentOption = "Marine Boss",
   Flag = "BossSelect",
   Callback = function(Option)
      SendWebhook("👑 Boss selecionado para farm: " .. Option)
   end,
})

-- 🌍 Aba de Teleporte
local TeleportTab = Window:CreateTab("Teleportes", 4483362458)
TeleportTab:CreateButton({
   Name = "Marineford",
   Callback = function()
      game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.Marineford.SpawnLocation.CFrame
      SendWebhook("🌍 Teleportado para Marineford")
   end
})
TeleportTab:CreateButton({
   Name = "Sky Island",
   Callback = function()
      game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.SkyIsland.SpawnLocation.CFrame
      SendWebhook("🌍 Teleportado para Sky Island")
   end
})

-- 🕊️ Aba de Movimento
local MoveTab = Window:CreateTab("Movimento", 4483362458)
MoveTab:CreateSlider({
   Name = "Velocidade",
   Range = {16, 200},
   Increment = 1,
   CurrentValue = 16,
   Flag = "WalkSpeed",
   Callback = function(Value)
      game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
      SendWebhook("🏃 Velocidade ajustada para: " .. Value)
   end,
})
MoveTab:CreateSlider({
   Name = "Jump Power",
   Range = {50, 300},
   Increment = 10,
   CurrentValue = 50,
   Flag = "JumpPower",
   Callback = function(Value)
      game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
      SendWebhook("🦘 Jump Power ajustado para: " .. Value)
   end,
})

-- 🍇 Aba de Frutas (Fruit Sniper Teleport to Player)
local FruitTab = Window:CreateTab("Frutas", 4483362458)
FruitTab:CreateToggle({
   Name = "Auto Fruit Sniper",
   CurrentValue = false,
   Flag = "FruitSniper",
   Callback = function(state)
      _G.FruitSniper = state
      if state then
         spawn(function()
            while _G.FruitSniper do
               local player = game.Players.LocalPlayer
               local hrp = player.Character:WaitForChild("HumanoidRootPart")
               for _, fruit in pairs(workspace:GetChildren()) do
                  if fruit:IsA("Tool") and fruit:FindFirstChild("Handle") then
                     fruit.Handle.CFrame = hrp.CFrame + Vector3.new(0,3,0)
                     SendWebhook("🍇 Fruta puxada até você: " .. fruit.Name)
                  end
               end
               wait(2)
            end
         end)
      end
   end
})

-- ⚔️ Aba de Raids
local RaidTab = Window:CreateTab("Raids", 4483362458)
RaidTab:CreateToggle({
   Name = "Auto Raid",
   CurrentValue = false,
   Flag = "AutoRaid",
   Callback = function(state)
      _G.AutoRaid = state
      if state then
         spawn(function()
            while _G.AutoRaid do
               SendWebhook("🔥 Raid iniciada automaticamente")
               wait(10)
            end
         end)
      end
   end,
})

-- 👤 Aba de Player
local PlayerTab = Window:CreateTab("Player", 4483362458)
PlayerTab:CreateKeybind({
   Name = "Teleport Rápido",
   CurrentKeybind = "Q",
   Flag = "QuickTP",
   Callback = function()
      game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.SpawnLocation.CFrame
      SendWebhook("⚡ Teleporte rápido usado (Q)")
   end,
})

PlayerTab:CreateSlider({
   Name = "Zoom da Câmera",
   Range = {70, 200},
   Increment = 10,
   CurrentValue = 70,
   Flag = "CameraZoom",
   Callback = function(Value)
      game.Players.LocalPlayer.CameraMaxZoomDistance = Value
      SendWebhook("🎥 Zoom da câmera ajustado para: " .. Value)
   end,
})

-- 📦 Aba de Extras
local ExtraTab = Window:CreateTab("Extras", 4483362458)
ExtraTab:CreateButton({
   Name = "Auto Chest",
   Callback = function()
      for _, chest in pairs(workspace:GetChildren()) do
         if chest.Name:lower():find("chest") then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = chest.CFrame
            SendWebhook("💰 Baú coletado automaticamente: " .. chest.Name)
         end
      end
   end
})

ExtraTab:CreateNotification({
   Title = "Hub Ultra Bruno",
   Content = "Carregado com sucesso! Aproveite.",
   Duration = 5
})
