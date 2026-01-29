-- GUI Simples para Steal a Brainrot
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local NoclipBtn = Instance.new("TextButton")
local AutoBaseBtn = Instance.new("TextButton")
local Title = Instance.new("TextLabel")

-- Configurações da Interface
ScreenGui.Parent = game.CoreGui
Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Frame.Position = UDim2.new(0.5, -100, 0.5, -75)
Frame.Size = UDim2.new(0, 200, 0, 150)
Frame.Active = true
Frame.Draggable = true

Title.Parent = Frame
Title.Text = "Brainrot Hack v1"
Title.Size = UDim2.new(1, 0, 0, 30)
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundTransparency = 1

-- 1. Botão Noclip
NoclipBtn.Parent = Frame
NoclipBtn.Text = "Noclip: OFF"
NoclipBtn.Position = UDim2.new(0.1, 0, 0.3, 0)
NoclipBtn.Size = UDim2.new(0.8, 0, 0.25, 0)

local noclip = false
NoclipBtn.MouseButton1Click:Connect(function()
    noclip = not noclip
    NoclipBtn.Text = "Noclip: " .. (noclip and "ON" or "OFF")
    game:GetService("RunService").Stepped:Connect(function()
        if noclip then
            for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
    end)
end)

-- 2. Botão Auto Base (Teleporte ao pegar Brainrot)
AutoBaseBtn.Parent = Frame
AutoBaseBtn.Text = "Auto-Base: OFF"
AutoBaseBtn.Position = UDim2.new(0.1, 0, 0.6, 0)
AutoBaseBtn.Size = UDim2.new(0.8, 0, 0.25, 0)

local autoBase = false
AutoBaseBtn.MouseButton1Click:Connect(function()
    autoBase = not autoBase
    AutoBaseBtn.Text = "Auto-Base: " .. (autoBase and "ON" or "OFF")
end)

-- Lógica para detectar Brainrot e ir para a base
game.Players.LocalPlayer.Character.ChildAdded:Connect(function(child)
    if autoBase and child:IsA("Tool") then -- Assume que o Brainrot é um Tool ao ser pego
        local base = workspace:FindFirstChild(game.Players.LocalPlayer.Name .. " Base") -- Altere conforme o nome da base no jogo
        if base then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = base.PrimaryPart.CFrame
        end
    end
end)
