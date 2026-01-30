--[[
👑 SUPREME HUB ELITE V23 - ULTRA BULLETPROOF
⚡ Magnet, AutoChest parado, ESP, NoClip, GodSpeed
🛠 Estrutura robusta, loops otimizados, fallback seguro
🎨 GUI profissional com abas reais e indicadores de status
🚀 Loading Screen adicionado
]]

repeat task.wait() until game:IsLoaded()

-- SERVICES
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

-- ================= LOADING SCREEN =================
local sgLoading = Instance.new("ScreenGui", player.PlayerGui)
sgLoading.Name = "SupremeLoading"; sgLoading.ResetOnSpawn = false

local loadingFrame = Instance.new("Frame", sgLoading)
loadingFrame.Size = UDim2.new(0,400,0,150)
loadingFrame.Position = UDim2.new(0.5,-200,0.5,-75)
loadingFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
Instance.new("UICorner", loadingFrame)

local title = Instance.new("TextLabel", loadingFrame)
title.Size = UDim2.new(1,0,0,70)
title.Position = UDim2.new(0,0,0,10)
title.BackgroundTransparency = 1
title.Text = "Supreme Hub"
title.TextColor3 = Color3.fromRGB(0,255,150)
title.TextScaled = true
title.Font = Enum.Font.SourceSansBold

local subtitle = Instance.new("TextLabel", loadingFrame)
subtitle.Size = UDim2.new(1,0,0,50)
subtitle.Position = UDim2.new(0,0,0,80)
subtitle.BackgroundTransparency = 1
subtitle.Text = "Loading ..."
subtitle.TextColor3 = Color3.fromRGB(200,200,200)
subtitle.TextScaled = true
subtitle.Font = Enum.Font.SourceSans

task.wait(2)
sgLoading:Destroy() -- remove a tela de loading

-- ================= CONFIG =================
getgenv().Supreme = {
    Magnet = true,
    ChestFarm = false,
    ESP = false,
    NoClip = false,
    GodSpeed = false,
    WalkSpeed = 16,
    JumpPower = 50,
    FruitsFound = 0,
    ChestsFound = 0,
    StartTime = os.time(),
    ThemeColor = Color3.fromRGB(0,255,150),
    ThemeName = "Green",
    Cooldowns = {
        Magnet = 0.2,
        Chest = 0.5,
        ESP = 1
    },
    State = "IDLE",
    Debug = true
}

-- ================= UTIL =================
local ESPBoxes = {}
local function safeCall(func)
    local ok, err = pcall(func)
    if not ok and getgenv().Supreme.Debug then
        warn("[SupremeHub] Error: "..tostring(err))
    end
end

local function makeDraggable(frame)
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
            dragging=true
            dragStart=input.Position
            startPos=frame.Position
        end
    end)
    frame.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
            local delta=input.Position-dragStart
            frame.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,startPos.Y.Scale,startPos.Y.Offset+delta.Y)
        end
    end)
    frame.InputEnded:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
            dragging=false
        end
    end)
end

local function saveConfig()
    safeCall(function()
        writefile("SupremeHubV23.json", HttpService:JSONEncode(getgenv().Supreme))
    end)
end

local function loadConfig()
    safeCall(function()
        if isfile("SupremeHubV23.json") then
            local data=HttpService:JSONDecode(readfile("SupremeHubV23.json"))
            for k,v in pairs(data) do
                getgenv().Supreme[k]=v
            end
        end
    end)
end

loadConfig()

-- ================= GUI =================
local sg = Instance.new("ScreenGui",player.PlayerGui)
sg.Name="SupremeV23"; sg.ResetOnSpawn=false

-- MINI BUTTON
local ball = Instance.new("Frame",sg)
ball.Size=UDim2.new(0,50,0,50); ball.Position=UDim2.new(0,10,0.5,0)
ball.BackgroundColor3=Color3.fromRGB(15,15,15); ball.Visible=false; Instance.new("UICorner",ball).CornerRadius=UDim.new(1,0)
local ballBtn = Instance.new("TextButton",ball)
ballBtn.Size=UDim2.new(1,0,1,0); ballBtn.Text="👑"; ballBtn.TextColor3=Color3.new(1,1,1); ballBtn.TextSize=26; ballBtn.BackgroundTransparency=1
makeDraggable(ball)

-- MAIN DASHBOARD
local main = Instance.new("Frame",sg)
main.Size=UDim2.new(0,550,0,420); main.Position=UDim2.new(0.5,-275,0.5,-210)
main.BackgroundColor3=Color3.fromRGB(20,20,20); main.Active=true; Instance.new("UICorner",main)
makeDraggable(main)

-- SIDE NAVIGATION
local side = Instance.new("Frame",main)
side.Size=UDim2.new(0,140,1,0); side.BackgroundColor3=Color3.fromRGB(35,35,35); Instance.new("UICorner",side)

-- CONTENT AREA
local content = Instance.new("Frame",main)
content.Size=UDim2.new(1,-150,1,-20); content.Position=UDim2.new(0,150,0,10)
content.BackgroundTransparency=1

local pages = {}
local currentPage=nil

local function clearContent()
    for _,v in pairs(content:GetChildren()) do
        v:Destroy()
    end
end

local function switchPage(page)
    if currentPage then currentPage.Visible=false end
    currentPage=page
    currentPage.Visible=true
end

-- ================= DISABLE FEATURE =================
local function disableFeature(key)
    if key=="ESP" then
        for _,box in pairs(ESPBoxes) do
            safeCall(function() box:Destroy() end)
        end
        ESPBoxes={}
    elseif key=="NoClip" then
        local char=player.Character
        if char then
            for _,p in pairs(char:GetDescendants()) do
                if p:IsA("BasePart") then
                    p.CanCollide=true
                end
            end
        end
    elseif key=="Magnet" then
        -- nothing special needed
    elseif key=="ChestFarm" then
        -- nothing special needed
    end
end

-- ================= TOGGLES =================
local function createToggle(parent,name,key)
    local btn = Instance.new("TextButton",parent)
    btn.Size=UDim2.new(0.95,0,0,40)
    btn.Font=Enum.Font.SourceSansBold; btn.TextSize=14
    local statusLabel = Instance.new("TextLabel",btn)
    statusLabel.Size=UDim2.new(0,80,1,0)
    statusLabel.Position=UDim2.new(1,5,0,0)
    statusLabel.BackgroundTransparency=1
    statusLabel.TextColor3=Color3.fromRGB(255,255,0)
    statusLabel.Text="IDLE"

    local function updateStatus()
        if getgenv().Supreme[key] then
            statusLabel.Text="ON"
            btn.BackgroundColor3=Color3.fromRGB(0,150,100)
        else
            statusLabel.Text="OFF"
            btn.BackgroundColor3=Color3.fromRGB(50,50,50)
        end
    end

    btn.MouseButton1Click:Connect(function()
        getgenv().Supreme[key]=not getgenv().Supreme[key]
        if not getgenv().Supreme[key] then
            disableFeature(key)
        end
        updateStatus()
        saveConfig()
    end)

    task.spawn(updateStatus)
    btn.Parent=parent
    return btn, statusLabel
end

local function createButton(parent,name,func)
    local btn = Instance.new("TextButton",parent)
    btn.Size=UDim2.new(0.95,0,0,35)
    btn.Font=Enum.Font.SourceSansBold; btn.TextSize=14
    btn.Text=name
    btn.BackgroundColor3=Color3.fromRGB(40,40,40)
    btn.TextColor3=Color3.new(1,1,1)
    Instance.new("UICorner",btn)
    btn.MouseButton1Click:Connect(func)
    btn.Parent=parent
end

-- ================= PAGES =================
local function createPage(name)
    local f = Instance.new("Frame",content)
    f.Size=UDim2.new(1,0,1,0); f.BackgroundTransparency=1; f.Visible=false
    pages[name]=f
    return f
end

local pageHome=createPage("Home")
local pageESP=createPage("ESP")
local pageSettings=createPage("Settings")

-- NAV BUTTONS
local function createNav(name,page,pos)
    local btn=Instance.new("TextButton",side)
    btn.Size=UDim2.new(1,-10,0,35); btn.Position=UDim2.new(0,5,0,pos)
    btn.Text=name; btn.BackgroundColor3=Color3.fromRGB(50,50,50); btn.TextColor3=Color3.new(1,1,1)
    Instance.new("UICorner",btn)
    btn.Font=Enum.Font.SourceSansBold
    btn.TextSize=14
    btn.MouseButton1Click:Connect(function()
        switchPage(page)
    end)
end

createNav("Home",pageHome,10)
createNav("ESP",pageESP,60)
createNav("Settings",pageSettings,110)

switchPage(pageHome)

-- ================= HOME CONTENT =================
createToggle(pageHome,"🧲 Magnet","Magnet")
createToggle(pageHome,"💰 AutoChest Parado","ChestFarm")
createToggle(pageHome,"👁 Fruit ESP","ESP")
createToggle(pageHome,"⚡ GodSpeed","GodSpeed")
createToggle(pageHome,"👻 NoClip","NoClip")

createButton(pageHome,"Resetar Contador de Frutas",function()
    getgenv().Supreme.FruitsFound=0
end)

-- Fruit Counter
local counter = Instance.new("TextLabel",pageHome)
counter.Size=UDim2.new(0.95,0,0,25); counter.Position=UDim2.new(0,10,0,250)
counter.BackgroundTransparency=1; counter.TextColor3=Color3.fromRGB(0,255,150)
counter.Font=Enum.Font.SourceSansBold; counter.TextSize=18

task.spawn(function()
    while true do
        if pageHome.Visible then
            counter.Text="Frutas Coletadas: "..getgenv().Supreme.FruitsFound.." | Chests: "..getgenv().Supreme.ChestsFound
        end
        task.wait(1)
    end
end)

-- ================= CORE LOGIC =================
local lastPosition=nil
local lastMagnet=os.clock()
local lastChest=os.clock()
local lastESP=os.clock()

-- Helper: get character safely
local function getChar()
    if not player.Character then return nil end
    return player.Character:FindFirstChild("HumanoidRootPart") and player.Character or nil
end

-- Character respawn handling
player.CharacterAdded:Connect(function(char)
    safeCall(function()
        lastPosition=nil
    end)
end)

-- MAGNET
RunService.Heartbeat:Connect(function()
    local char=getChar()
    if not char or not getgenv().Supreme.Magnet then return end
    if os.clock()-lastMagnet<getgenv().Supreme.Cooldowns.Magnet then return end
    lastMagnet=os.clock()
    local hum=char:FindFirstChildOfClass("Humanoid")
    for _,tool in pairs(workspace:GetChildren()) do
        if tool:IsA("Tool") and tool:FindFirstChild("Handle") and tool.Name:lower():find("fruit") then
            safeCall(function()
                tool.Handle.CanCollide=false
                tool.Handle.Velocity=Vector3.zero
                tool.Handle.CFrame=char.HumanoidRootPart.CFrame
                hum:EquipTool(tool)
                pcall(function()
                    RS.Remotes.CommF:InvokeServer("StoreFruit",tool.Name)
                end)
                getgenv().Supreme.FruitsFound+=1
            end)
        end
    end
end)

-- AUTO CHEST PARADO
task.spawn(function()
    while task.wait(0.5) do
        if not getgenv().Supreme.ChestFarm then continue end
        local char=getChar()
        if not char then continue end
        local hrp=char.HumanoidRootPart
        if not lastPosition then lastPosition=hrp.CFrame end
        for _,v in pairs(workspace:GetDescendants()) do
            if v:IsA("TouchTransmitter") and v.Parent.Name:find("Chest") then
                hrp.CFrame=v.Parent.CFrame + Vector3.new(0,3,0)
                getgenv().Supreme.ChestsFound+=1
                task.wait(0.2)
            end
        end
        hrp.CFrame=lastPosition
    end
end)

-- WALK/JUMP/NOCLIP/GODSPEED
RunService.Stepped:Connect(function()
    local char=getChar()
    if not char then return end
    local hum=char:FindFirstChildOfClass("Humanoid")
    local hrp=char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then return end
    hum.WalkSpeed=getgenv().Supreme.WalkSpeed
    hum.JumpPower=getgenv().Supreme.JumpPower
    if getgenv().Supreme.NoClip then
        for _,p in pairs(char:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide=false
        end
    end
    if getgenv().Supreme.GodSpeed then
        safeCall(function() hum.Health=math.huge end)
    end
end)

-- ESP
task.spawn(function()
    while task.wait(1) do
        if not getgenv().Supreme.ESP then continue end
        if os.clock()-lastESP<getgenv().Supreme.Cooldowns.ESP then continue end
        lastESP=os.clock()
        for _, tool in pairs(workspace:GetChildren()) do
            if tool:IsA("Tool") and tool.Name:lower():find("fruit") and tool:FindFirstChild("Handle") then
                if not ESPBoxes[tool] then
                    local box=Instance.new("BoxHandleAdornment")
                    box.Adornee=tool.Handle
                    box.Size=tool.Handle.Size+Vector3.new(0.5,0.5,0.5)
                    box.Color=BrickColor.new("Bright green")
                    box.AlwaysOnTop=true
                    box.ZIndex=10
                    box.Name="ESPBox"
                    box.Parent=tool.Handle
                    ESPBoxes[tool]=box
                end
            end
        end
    end
end)

-- ANTI-IDLE
player.Idled:Connect(function()
    game:GetService("VirtualUser"):CaptureController()
    game:GetService("VirtualUser"):ClickButton2(Vector2.new())
end)

-- MINI BUTTON FUNCIONAL
ballBtn.MouseButton1Click:Connect(function()
    main.Visible=true
    ball.Visible=false
    if currentPage then currentPage.Visible=true end
end)

print("✅ Supreme Hub V23 carregado! Ultra bulletproof, Magnet, AutoChest parado, ESP, NoClip, GodSpeed otimizados.")
