-- ===== FISH IT DELTA EXECUTOR FULL GUI =====
-- Author: ChatGPT
-- Semua fitur lengkap: Fishing, Auto Sell, Player, Buy Weather, Teleport, Event, Settings
-- GUI native Roblox, pop-up, minimize, close konfirmasi Yes/No
-- Kompatibel Delta Executor

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local rs = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

-- ===== SETTINGS =====
local settings = {
    autoCatch=false, autoPerfect=false, autoAmazing=false,
    autoSell=false, sellThreshold=0,
    floatOnWater=false, tradeNoDelay=false,
    infinityJump=false, unlimitedJump=false,
    walkSpeed=16, autoBuyWeather=false,
    antiAFK=true, autoFarmEvent=false
}

-- ===== GUI SETUP =====
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FishItDeltaGUI"
screenGui.Parent = game.CoreGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0,600,0,400)
mainFrame.Position = UDim2.new(0.5,-300,0.5,-200)
mainFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Text = "Fish It! Delta GUI"
title.Size = UDim2.new(1,0,0,30)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.SourceSansBold
title.TextScaled = true
title.Parent = mainFrame

-- ===== TABS =====
local tabs = {"Fishing","Auto Sell","Player","Buy Weather","Teleport","Event","Settings"}
local tabFrames = {}
for i,tabName in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0,80,0,30)
    btn.Position = UDim2.new(0,10+(i-1)*85,0,35)
    btn.Text = tabName
    btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Parent = mainFrame

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1,-20,1,-70)
    frame.Position = UDim2.new(0,10,0,70)
    frame.BackgroundColor3 = Color3.fromRGB(40,40,40)
    frame.Visible = false
    frame.Parent = mainFrame
    tabFrames[tabName] = frame

    btn.MouseButton1Click:Connect(function()
        for _,f in pairs(tabFrames) do f.Visible = false end
        frame.Visible = true
    end)
end

-- ===== MINIMIZE & CLOSE =====
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0,30,0,30)
minimizeBtn.Position = UDim2.new(1,-35,0,0)
minimizeBtn.Text = "_"
minimizeBtn.BackgroundColor3 = Color3.fromRGB(80,80,80)
minimizeBtn.TextColor3 = Color3.new(1,1,1)
minimizeBtn.Parent = mainFrame
local isMinimized=false
minimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then mainFrame.Size = UDim2.new(0,200,0,35)
    else mainFrame.Size = UDim2.new(0,600,0,400) end
end)

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0,30,0,30)
closeBtn.Position = UDim2.new(1,-70,0,0)
closeBtn.Text = "X"
closeBtn.BackgroundColor3 = Color3.fromRGB(200,50,50)
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.Parent = mainFrame
closeBtn.MouseButton1Click:Connect(function()
    local confirmFrame = Instance.new("Frame")
    confirmFrame.Size = UDim2.new(0,250,0,100)
    confirmFrame.Position = UDim2.new(0.5,-125,0.5,-50)
    confirmFrame.BackgroundColor3 = Color3.fromRGB(50,50,50)
    confirmFrame.Parent = screenGui

    local txt = Instance.new("TextLabel")
    txt.Text = "Close GUI?"
    txt.Size = UDim2.new(1,0,0.5,0)
    txt.BackgroundTransparency = 1
    txt.TextColor3 = Color3.new(1,1,1)
    txt.TextScaled = true
    txt.Parent = confirmFrame

    local yesBtn = Instance.new("TextButton")
    yesBtn.Size = UDim2.new(0.4,0,0.3,0)
    yesBtn.Position = UDim2.new(0.05,0,0.6,0)
    yesBtn.Text = "Yes"
    yesBtn.BackgroundColor3 = Color3.fromRGB(50,200,50)
    yesBtn.Parent = confirmFrame
    yesBtn.MouseButton1Click:Connect(function() screenGui:Destroy() end)

    local noBtn = Instance.new("TextButton")
    noBtn.Size = UDim2.new(0.4,0,0.3,0)
    noBtn.Position = UDim2.new(0.55,0,0.6,0)
    noBtn.Text = "No"
    noBtn.BackgroundColor3 = Color3.fromRGB(200,50,50)
    noBtn.Parent = confirmFrame
    noBtn.MouseButton1Click:Connect(function() confirmFrame:Destroy() end)
end)

-- ===== FISHING TAB =====
local fishingTab = tabFrames["Fishing"]
local function addToggle(parent,posY,text,settingName)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0,150,0,40)
    btn.Position = UDim2.new(0,10,0,posY)
    btn.Text = text..": OFF"
    btn.BackgroundColor3 = Color3.fromRGB(70,70,70)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Parent = parent
    btn.MouseButton1Click:Connect(function()
        settings[settingName] = not settings[settingName]
        btn.Text = text..": "..(settings[settingName] and "ON" or "OFF")
    end)
end
addToggle(fishingTab,10,"Auto Catch","autoCatch")
addToggle(fishingTab,60,"Auto Perfect","autoPerfect")
addToggle(fishingTab,110,"Auto Amazing","autoAmazing")

-- ===== AUTO SELL TAB =====
local sellTab = tabFrames["Auto Sell"]
addToggle(sellTab,10,"Auto Sell","autoSell")
local sellThresholdLabel = Instance.new("TextLabel")
sellThresholdLabel.Text = "Sell Threshold: 0"
sellThresholdLabel.Size = UDim2.new(0,150,0,20)
sellThresholdLabel.Position = UDim2.new(0,10,0,60)
sellThresholdLabel.TextColor3 = Color3.new(1,1,1)
sellThresholdLabel.BackgroundTransparency = 1
sellThresholdLabel.Parent = sellTab

local sellThresholdBtn = Instance.new("TextButton")
sellThresholdBtn.Size = UDim2.new(0,150,0,20)
sellThresholdBtn.Position = UDim2.new(0,10,0,80)
sellThresholdBtn.Text = "Increase Threshold +100"
sellThresholdBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)
sellThresholdBtn.TextColor3 = Color3.new(1,1,1)
sellThresholdBtn.Parent = sellTab
sellThresholdBtn.MouseButton1Click:Connect(function()
    settings.sellThreshold = settings.sellThreshold + 100
    sellThresholdLabel.Text = "Sell Threshold: "..settings.sellThreshold
end)

-- ===== PLAYER TAB =====
local playerTab = tabFrames["Player"]
addToggle(playerTab,10,"Float on Water","floatOnWater")
addToggle(playerTab,60,"Trade No Delay","tradeNoDelay")
addToggle(playerTab,110,"Infinity Jump","infinityJump")
addToggle(playerTab,160,"Unlimited Jump","unlimitedJump")

-- Walk Speed Slider
local walkLabel = Instance.new("TextLabel")
walkLabel.Text = "Walk Speed: "..settings.walkSpeed
walkLabel.Size = UDim2.new(0,150,0,20)
walkLabel.Position = UDim2.new(0,10,0,210)
walkLabel.TextColor3 = Color3.new(1,1,1)
walkLabel.BackgroundTransparency = 1
walkLabel.Parent = playerTab

local walkBtn = Instance.new("TextButton")
walkBtn.Size = UDim2.new(0,150,0,20)
walkBtn.Position = UDim2.new(0,10,0,230)
walkBtn.Text = "Increase WalkSpeed +5"
walkBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)
walkBtn.TextColor3 = Color3.new(1,1,1)
walkBtn.Parent = playerTab
walkBtn.MouseButton1Click:Connect(function()
    settings.walkSpeed = settings.walkSpeed + 5
    walkLabel.Text = "Walk Speed: "..settings.walkSpeed
    hum.WalkSpeed = settings.walkSpeed
end)

-- ===== BUY WEATHER TAB =====
local weatherTab = tabFrames["Buy Weather"]
local weatherTypes = {"Cloud","Storm","Wind","Radiant","Snow","Shark Hunt"}
for i,v in ipairs(weatherTypes) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0,120,0,30)
    btn.Position = UDim2.new(0,10,0,10+(i-1)*35)
    btn.Text = "Spawn "..v
    btn.BackgroundColor3 = Color3.fromRGB(70,70,70)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Parent = weatherTab
    btn.MouseButton1Click:Connect(function()
        pcall(function()
            rs.Remotes.SpawnWeather:FireServer(v)
        end)
    end)
end
addToggle(weatherTab,250,"Auto Buy Weather","autoBuyWeather")

-- ===== TELEPORT TAB =====
local teleportTab = tabFrames["Teleport"]
local teleports = {
    CoralReefs = Vector3.new(-2945,66,2248),
    Kohana = Vector3.new(-645,16,606),
    WeatherMachine = Vector3.new(-1535,2,1917),
    LostIsle_Sisypuhus = Vector3.new(-3703,-136,-1019),
    WinterFest = Vector3.new(1616,4,3280),
    EsotericDepths = Vector3.new(3214,-1303,1411),
    TropicalGrove = Vector3.new(-2047,6,3662),
    StingrayShores = Vector3.new(2,4,2839),
    LostIsle_Treasure = Vector3.new(-3594,-285,-1635),
    LostIsle_LostShore = Vector3.new(-3672,70,-912),
    KohanaVolcano = Vector3.new(-512,24,191),
    CraterIsland = Vector3.new(1019,20,5071)
}
local yPos=10
for name,pos in pairs(teleports) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0,180,0,30)
    btn.Position = UDim2.new(0,10,0,yPos)
    btn.Text = "Teleport "..name
    btn.BackgroundColor3 = Color3.fromRGB(70,70,70)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Parent = teleportTab
    yPos=yPos+35
    btn.MouseButton1Click:Connect(function()
        char:SetPrimaryPartCFrame(CFrame.new(pos))
    end)
end

-- ===== EVENT TAB =====
local eventTab = tabFrames["Event"]
addToggle(eventTab,10,"Auto Farm Event","autoFarmEvent")
local refreshBtn = Instance.new("TextButton")
refreshBtn.Size = UDim2.new(0,150,0,40)
refreshBtn.Position = UDim2.new(0,10,0,60)
refreshBtn.Text = "Refresh Event List"
refreshBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)
refreshBtn.TextColor3 = Color3.new(1,1,1)
refreshBtn.Parent = eventTab
refreshBtn.MouseButton1Click:Connect(function()
    pcall(function() rs.Remotes.RefreshEvent:FireServer() end)
end)

-- ===== SETTINGS TAB =====
local settingsTab = tabFrames["Settings"]
addToggle(settingsTab,10,"Anti AFK","antiAFK")
addToggle(settingsTab,60,"Anti Lag/Low Texture","antiLag")
local rejoinBtn = Instance.new("TextButton")
rejoinBtn.Size = UDim2.new(0,150,0,40)
rejoinBtn.Position = UDim2.new(0,10,0,110)
rejoinBtn.Text = "Rejoin Server"
rejoinBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)
rejoinBtn.TextColor3 = Color3.new(1,1,1)
rejoinBtn.Parent = settingsTab
rejoinBtn.MouseButton1Click:Connect(function()
    game:GetService("TeleportService"):Teleport(game.PlaceId,LocalPlayer)
end)
local buyRodBtn = Instance.new("TextButton")
buyRodBtn.Size = UDim2.new(0,150,0,40)
buyRodBtn.Position = UDim2.new(0,10,0,160)
buyRodBtn.Text = "Buy Rod"
buyRodBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)
buyRodBtn.TextColor3 = Color3.new(1,1,1)
buyRodBtn.Parent = settingsTab
buyRodBtn.MouseButton1Click:Connect(function()
    pcall(function() rs.Remotes.BuyRod:FireServer() end)
end)
local buyBaitBtn = Instance.new("TextButton")
buyBaitBtn.Size = UDim2.new(0,150,0,40)
buyBaitBtn.Position = UDim2.new(0,10,0,210)
buyBaitBtn.Text = "Buy Bait"
buyBaitBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)
buyBaitBtn.TextColor3 = Color3.new(1,1,1)
buyBaitBtn.Parent = settingsTab
buyBaitBtn.MouseButton1Click:Connect(function()
    pcall(function() rs.Remotes.BuyBait:FireServer() end)
end)
local spawnBoatBtn = Instance.new("TextButton")
spawnBoatBtn.Size = UDim2.new(0,150,0,40)
spawnBoatBtn.Position = UDim2.new(0,10,0,260)
spawnBoatBtn.Text = "Spawn Boat"
spawnBoatBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)
spawnBoatBtn.TextColor3 = Color3.new(1,1,1)
spawnBoatBtn.Parent = settingsTab
spawnBoatBtn.MouseButton1Click:Connect(function()
    pcall(function() rs.Remotes.SpawnBoat:FireServer() end)
end)

-- ===== AUTO LOOP =====
spawn(function()
    while wait(0.1) do
        if settings.autoCatch then pcall(function() rs.Remotes.CatchFish:FireServer() end) end
        if settings.autoPerfect then pcall(function() rs.Remotes.AutoPerfect:FireServer() end) end
        if settings.autoAmazing then pcall(function() rs.Remotes.AutoAmazing:FireServer() end) end
        if settings.autoSell then pcall(function() rs.Remotes.SellFish:InvokeServer(settings.sellThreshold) end) end
    end
end)

-- ===== INFINITY & UNLIMITED JUMP =====
UIS.JumpRequest:Connect(function()
    if settings.infinityJump or settings.unlimitedJump then
        hum:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- ===== ANTI AFK =====
if settings.antiAFK then
    local vu = game:GetService("VirtualUser")
    LocalPlayer.Idled:Connect(function()
        vu:Button2Down(Vector2.new(0,0),workspace
