--[[====================================================
 👑 PLS DONATE SUPREME HUB ULTRA MAX 2026 👑
 SCRIPT COMPLETO • CORRIGIDO • SEM REMOVER NADA
====================================================]]

-- UI
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TextChatService = game:GetService("TextChatService")
local HttpService = game:GetService("HttpService")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

--------------------------------------------------
-- CONFIG
--------------------------------------------------
local CFG = {
    Language = "AUTO",

    AutoChat = true,
    ChatDelayMin = 20,
    ChatDelayMax = 35,
    AntiSpam = true,

    Goal = 1000,
    TotalRaised = 0,
    LastRaised = 0,

    Spin = false,
    SpinSpeed = 4,
    SpinRandom = false,

    Heli = false,
    HeliPower = 35,

    Jump = false,

    AFK = true,
    AFKCamera = true,
    AFKJump = true,

    HUD = true,
    Panic = false,

    Webhook = "https://discord.com/api/webhooks/1465940670144446642/xDBCFN6nM8hqYjnFRiFD57D62wPUwtL55LlsUJWhvl5ALp3KGmVZmQhpwSQGoMXFqdxd",

    LastMsg = "",
    LastMsgTime = 0,
    LastWebhook = 0
}

--------------------------------------------------
-- TEXTOS
--------------------------------------------------
local TEXT = {
    PT = {
        idle = {
            "Qualquer Robux ajuda 💎",
            "1 Robux já faz diferença ❤️",
            "Meta ativa! 💰",
            "Doa se puder 🙏",
            "Ajuda o pobre 😅",
            "Tentando bater a meta 👑",
            "Qualquer valor já ajuda 💸"
        },
        thanks = {
            "Obrigado pela doação 💎",
            "Valeu demais 🔥",
            "Gratidão ❤️",
            "Ajudou muito 🙏",
            "Deus te abençoe 👑",
            "Muito obrigado mesmo 💰"
        }
    },
    EN = {
        idle = {
            "Any Robux helps 💎",
            "1 Robux already helps ❤️",
            "Goal active! 💰",
            "Donate if you can 🙏",
            "Support please 😅",
            "Trying to reach the goal 👑"
        },
        thanks = {
            "Thanks for the donation 💎",
            "Much love 🔥",
            "Appreciate it ❤️",
            "Helps a lot 🙏",
            "God bless you 👑"
        }
    }
}

--------------------------------------------------
-- FUNÇÕES
--------------------------------------------------
local function GetLang()
    if CFG.Language == "AUTO" then
        return "PT"
    end
    return CFG.Language
end

--------------------------------------------------
-- WEBHOOK
--------------------------------------------------
local function SendWebhook(title, color, fields)
    if CFG.Webhook == "" then return end
    if os.clock() - CFG.LastWebhook < 2 then return end
    CFG.LastWebhook = os.clock()

    local req = (syn and syn.request) or request or http_request
    if not req then return end

    req({
        Url = CFG.Webhook,
        Method = "POST",
        Headers = {["Content-Type"] = "application/json"},
        Body = HttpService:JSONEncode({
            embeds = {{
                title = title,
                color = color,
                fields = fields,
                footer = {text = "PLS DONATE • SUPREME HUB ULTRA MAX"},
                timestamp = DateTime.now():ToIsoDate()
            }}
        })
    })
end

--------------------------------------------------
-- CHAT
--------------------------------------------------
local function SendChat(msg)
    if CFG.Panic then return end
    if CFG.AntiSpam then
        if msg == CFG.LastMsg then return end
        if os.clock() - CFG.LastMsgTime < 4 then return end
    end

    CFG.LastMsg = msg
    CFG.LastMsgTime = os.clock()

    if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
        TextChatService.TextChannels.RBXGeneral:SendAsync(msg)
    else
        game.ReplicatedStorage.SayMessageRequest:FireServer(msg, "All")
    end
end

--------------------------------------------------
-- HUD
--------------------------------------------------
local HUD = Drawing.new("Text")
HUD.Size = 18
HUD.Center = true
HUD.Outline = true
HUD.Position = Vector2.new(500, 40)

--------------------------------------------------
-- ANTI AFK
--------------------------------------------------
LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

--------------------------------------------------
-- DONATION DETECTOR
--------------------------------------------------
task.spawn(function()
    local raised = LocalPlayer:WaitForChild("leaderstats"):WaitForChild("Raised")
    CFG.LastRaised = raised.Value
    CFG.TotalRaised = raised.Value

    raised.Changed:Connect(function(v)
        local diff = v - CFG.LastRaised
        if diff <= 0 then return end

        CFG.LastRaised = v
        CFG.TotalRaised = v

        local lang = GetLang()
        SendChat(TEXT[lang].thanks[math.random(#TEXT[lang].thanks)])

        SendWebhook("💎 NOVA DOAÇÃO", 65280, {
            {name="Valor", value=diff.." Robux", inline=true},
            {name="Total", value=v.." / "..CFG.Goal, inline=true},
            {name="Progresso", value=math.floor((v/CFG.Goal)*100).."%", inline=false}
        })
    end)
end)

--------------------------------------------------
-- AFK ENGINE (CORRIGIDO)
--------------------------------------------------
task.spawn(function()
    while true do
        task.wait(math.random(15,30))
        if CFG.AFK and not CFG.Panic then
            if CFG.AFKCamera then
                Camera.CFrame *= CFrame.Angles(0, math.rad(math.random(-6,6)), 0)
            end
            if CFG.AFKJump and LocalPlayer.Character then
                local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end
        end
    end
end)

--------------------------------------------------
-- PHYSICS
--------------------------------------------------
RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")

    if CFG.Spin and hrp then
        local s = CFG.SpinRandom and math.random(1,CFG.SpinSpeed) or CFG.SpinSpeed
        hrp.CFrame *= CFrame.Angles(0, math.rad(s), 0)
    end

    if CFG.Heli and hrp then
        hrp.AssemblyLinearVelocity = Vector3.new(0, CFG.HeliPower, 0)
    end

    HUD.Visible = CFG.HUD
    HUD.Text = string.format("💎 %d / %d (%.1f%%)", CFG.TotalRaised, CFG.Goal, (CFG.TotalRaised/CFG.Goal)*100)
end)

--------------------------------------------------
-- AUTO CHAT (FUNCIONAL)
--------------------------------------------------
task.spawn(function()
    while true do
        task.wait(math.random(CFG.ChatDelayMin, CFG.ChatDelayMax))
        if CFG.AutoChat and not CFG.Panic then
            local lang = GetLang()
            SendChat(TEXT[lang].idle[math.random(#TEXT[lang].idle)])
        end
    end
end)

--------------------------------------------------
-- UI
--------------------------------------------------
local Window = Rayfield:CreateWindow({
    Name = "👑 SUPREME HUB ULTRA MAX",
    LoadingTitle = "PLS DONATE",
    LoadingSubtitle = "ABSOLUTE FINAL"
})

local Main     = Window:CreateTab("🏠 Principal")
local ChatTab  = Window:CreateTab("💬 Auto Chat")
local LangTab  = Window:CreateTab("🌍 Idioma")
local Donate   = Window:CreateTab("💎 Doações")
local AFKTab   = Window:CreateTab("🛌 AFK")
local Phys     = Window:CreateTab("🌀 Física")
local HUDTab   = Window:CreateTab("📊 HUD")
local Security = Window:CreateTab("🔒 Segurança")

Main:CreateToggle({Name="Auto Chat",CurrentValue=CFG.AutoChat,Callback=function(v)CFG.AutoChat=v end})
Main:CreateToggle({Name="AFK Geral",CurrentValue=CFG.AFK,Callback=function(v)CFG.AFK=v end})
Main:CreateToggle({Name="HUD",CurrentValue=CFG.HUD,Callback=function(v)CFG.HUD=v end})

ChatTab:CreateToggle({Name="Anti-Spam",CurrentValue=CFG.AntiSpam,Callback=function(v)CFG.AntiSpam=v end})
ChatTab:CreateSlider({Name="Delay Min",Range={5,60},CurrentValue=CFG.ChatDelayMin,Callback=function(v)CFG.ChatDelayMin=v end})
ChatTab:CreateSlider({Name="Delay Max",Range={10,120},CurrentValue=CFG.ChatDelayMax,Callback=function(v)CFG.ChatDelayMax=v end})

LangTab:CreateDropdown({
    Name="Idioma",
    Options={"AUTO","PT","EN"},
    CurrentOption={CFG.Language},
    Callback=function(v)
        CFG.Language = v[1]
    end
})

Donate:CreateSlider({Name="Meta",Range={10,50000},CurrentValue=CFG.Goal,Callback=function(v)CFG.Goal=v end})

AFKTab:CreateToggle({Name="Mover Câmera",CurrentValue=CFG.AFKCamera,Callback=function(v)CFG.AFKCamera=v end})
AFKTab:CreateToggle({Name="Pular AFK",CurrentValue=CFG.AFKJump,Callback=function(v)CFG.AFKJump=v end})

Phys:CreateToggle({Name="Spin",CurrentValue=CFG.Spin,Callback=function(v)CFG.Spin=v end})
Phys:CreateSlider({Name="Velocidade Spin",Range={1,30},CurrentValue=CFG.SpinSpeed,Callback=function(v)CFG.SpinSpeed=v end})
Phys:CreateToggle({Name="Spin Aleatório",CurrentValue=CFG.SpinRandom,Callback=function(v)CFG.SpinRandom=v end})
Phys:CreateToggle({Name="Heli",CurrentValue=CFG.Heli,Callback=function(v)CFG.Heli=v end})
Phys:CreateSlider({Name="Força Heli",Range={10,150},CurrentValue=CFG.HeliPower,Callback=function(v)CFG.HeliPower=v end})

HUDTab:CreateToggle({Name="Mostrar HUD",CurrentValue=CFG.HUD,Callback=function(v)CFG.HUD=v end})

Security:CreateButton({
    Name="🚨 PANIC MODE",
    Callback=function()
        CFG.Panic = true
        for k,v in pairs(CFG) do
            if type(v)=="boolean" then CFG[k]=false end
        end
    end
})

Rayfield:Notify({
    Title="SUPREME HUB ULTRA MAX",
    Content="CARREGADO • SEM ERROS 👑"
})
