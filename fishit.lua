-- ============================================
--  NSMOD FISH IT PRO v5.0 FULL
--  KÊNH TEL: t.me/sonchoigame23
--  40+ FEATURES - 7 TABS
-- ============================================

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local SG = game:GetService("StarterGui")
local L = game:GetService("Lighting")
local W = game:GetService("Workspace")
local VU = game:GetService("VirtualUser")
local HS = game:GetService("HttpService")
local TS = game:GetService("TeleportService")
local LP = Players.LocalPlayer
local Cam = W.CurrentCamera

local C = {
    autoFish=false, autoSell=false, autoQuest=false, autoBuyRod=false,
    autoSkill=false, autoReel=false, autoRebirth=false,
    autoClaimDaily=false, autoUseBooster=false,
    useRemote=true, useClick=true, clickDelay=2.5,
    fishDelay=2.0, sellInterval=30, questInterval=5,
    antiBan=true, antiAFK=true, hideOnAdmin=true, randomDelay=true, antiCrash=true,
    fpsBoost=true, removeEffects=false, fullBright=false, noFog=false,
    espFish=false, espNPC=false, espChest=false, espCoin=false,
    speedHack=false, speedValue=50, jumpPower=false, jumpValue=100,
    dayNight=false, dayNightTime=14,
    totalCaught=0, totalSold=0, totalQuest=0, totalRebirth=0,
    totalClicks=0, adminsFound=0, sessionTime=0, startTime=tick()
}

local function nf(t,x,d) pcall(function() SG:SetCore("SendNotification",{Title=t,Text=x,Duration=d or 3}) end) end
nf("NSMOD v5.0","Loading...",2)

local ADMINS = {"dev_fishit","admin_fishit","mod_fishit","Owner","Admin","Moderator","Mod","Dev","Roblox","FishItDev","FishItAdmin","FishItMod","Staff"}
local function isAdmin(p)
    if not p then return false end
    for _,n in ipairs(ADMINS) do
        if p.Name:lower():find(n:lower()) or p.DisplayName:lower():find(n:lower()) then return true end
    end
    return false
end

LP.Idled:Connect(function() if C.antiAFK then VU:CaptureController(); VU:ClickButton2(Vector2.new()) end end)

Players.PlayerAdded:Connect(function(p)
    if C.hideOnAdmin and isAdmin(p) then
        C.adminsFound = C.adminsFound + 1
        nf("Anti-Ban","Admin: "..p.Name,4)
        if getgenv().UI then getgenv().UI.Enabled = false end
    end
end)
for _,p in ipairs(Players:GetPlayers()) do
    if p~=LP and isAdmin(p) then C.adminsFound = C.adminsFound + 1 end
end

if C.fpsBoost then
    pcall(function()
        L.GlobalShadows = false
        L.FogEnd = 1e6
        for _,v in pairs(L:GetChildren()) do
            if v:IsA("PostEffect") or v:IsA("Atmosphere") then v:Destroy() end
        end
    end)
    for _,v in pairs(W:GetDescendants()) do
        pcall(function()
            if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") then v.Enabled=false end
            if v:IsA("BasePart") then v.CastShadow=false; v.Material=Enum.Material.SmoothPlastic end
        end)
    end
    pcall(function() settings().Rendering.QualityLevel = "Level01" end)
end

local function getR(n) local ok,r=pcall(function() return RS.Packages.Net:RemoteFunction(n) end); return ok and r or nil end
local Charge = getR('ChargeFishingRod')
local Minigame = getR('RequestFishingMinigameStarted')
local Catch = getR('CatchFishCompleted')

local function rw() if C.randomDelay then task.wait(math.random(150,350)/100) else task.wait(C.fishDelay) end end

task.spawn(function()
    while task.wait(0.3) do
        if not C.autoFish or not C.useRemote then continue end
        if not LP.Character or (C.adminsFound>0 and C.hideOnAdmin) then continue end
        pcall(function()
            local t = W:GetServerTimeNow()
            if Charge then Charge:InvokeServer(nil,nil,t,nil) end
            rw()
            if Minigame then Minigame:InvokeServer(0,0.5,W:GetServerTimeNow()) end
            rw()
            if Catch then Catch:InvokeServer() end
            C.totalCaught = C.totalCaught + 1
        end)
    end
end)

local function findBtn()
    local pg = LP:FindFirstChild("PlayerGui")
    if not pg then return nil end
    local kws = {"cast","fish","câu","catch","reel","hook","throw","quăng"}
    for _,v in pairs(pg:GetDescendants()) do
        if (v:IsA("TextButton") or v:IsA("ImageButton")) and v.Visible and v.Active then
            local n,t = v.Name:lower(),""
            pcall(function() t=(v.Text or ""):lower() end)
            for _,kw in ipairs(kws) do
                if n:find(kw) or t:find(kw) then return v end
            end
        end
    end
    return nil
end

task.spawn(function()
    while task.wait(C.clickDelay) do
        if not C.autoFish or not C.useClick or (C.adminsFound>0 and C.hideOnAdmin) then continue end
        pcall(function()
            local b = findBtn()
            if b and b.Visible then
                VU:CaptureController()
                VU:ClickButton1(b.AbsolutePosition + b.AbsoluteSize/2)
                C.totalClicks = C.totalClicks + 1
            end
        end)
    end
end)

task.spawn(function()
    while task.wait(C.sellInterval) do
        if C.autoSell then pcall(function() local S=getR('SellAllFish') or getR('SellAll'); if S then S:InvokeServer(); C.totalSold=C.totalSold+1 end end) end
    end
end)

task.spawn(function()
    while task.wait(C.questInterval) do
        if C.autoQuest then pcall(function() local Q=getR('ClaimQuestReward') or getR('CompleteQuest'); if Q then Q:InvokeServer(); C.totalQuest=C.totalQuest+1 end end) end
    end
end)

task.spawn(function()
    while task.wait(15) do
        if C.autoBuyRod then pcall(function() local B=getR('BuyRod') or getR('PurchaseRod'); if B then B:InvokeServer() end end) end
    end
end)

task.spawn(function()
    while task.wait(3) do
        if C.autoSkill then pcall(function() local S=getR('UseSkill') or getR('ActivateSkill'); if S then S:InvokeServer() end end) end
    end
end)

task.spawn(function()
    while task.wait(1) do
        if C.autoReel then pcall(function() local R=getR('ReelIn') or getR('CompleteFishing'); if R then R:InvokeServer() end end) end
    end
end)

task.spawn(function()
    while task.wait(10) do
        if C.autoRebirth then pcall(function() local R=getR('Rebirth') or getR('DoRebirth'); if R then R:InvokeServer(); C.totalRebirth=C.totalRebirth+1 end end) end
    end
end)

task.spawn(function()
    while task.wait(60) do
        if C.autoClaimDaily then pcall(function() local D=getR('ClaimDaily') or getR('ClaimReward'); if D then D:InvokeServer() end end) end
    end
end)

task.spawn(function()
    while task.wait(30) do
        if C.autoUseBooster then pcall(function() local U=getR('UseBooster') or getR('ActivateBoost'); if U then U:InvokeServer() end end) end
    end
end)

task.spawn(function()
    while task.wait(5) do
        if C.antiCrash and LP.Character then
            pcall(function()
                local h = LP.Character:FindFirstChildOfClass("Humanoid")
                if h and h.Health<=0 then LP.Character:BreakJoints() end
            end)
        end
    end
end)

local function tp(pos)
    pcall(function()
        if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
            LP.Character.HumanoidRootPart.CFrame = CFrame.new(pos)
        end
    end)
end

local function findPos(kw)
    for _,v in pairs(W:GetDescendants()) do
        if v:IsA("BasePart") and v.Name:lower():find(kw:lower()) then return v.Position end
    end
    return nil
end

local tpFn = {
    spawn = function() local sp=W:FindFirstChildOfClass("SpawnLocation"); if sp then tp(sp.Position+Vector3.new(0,3,0)); return true end end,
    shop = function() local p=findPos("shop") or findPos("store") or findPos("market"); if p then tp(p+Vector3.new(0,3,0)); return true end end,
    npc = function() local p=findPos("npc") or findPos("quest"); if p then tp(p+Vector3.new(0,3,0)); return true end end,
    zone = function() local p=findPos("fish") or findPos("water") or findPos("pond"); if p then tp(p+Vector3.new(0,5,0)); return true end end
}

local function applySJ()
    if LP.Character then
        local h = LP.Character:FindFirstChildOfClass("Humanoid")
        if h then
            h.WalkSpeed = C.speedHack and C.speedValue or 16
            h.UseJumpPower = true
            h.JumpPower = C.jumpPower and C.jumpValue or 50
        end
    end
end
LP.CharacterAdded:Connect(function() task.wait(1); applySJ() end)

task.spawn(function()
    while task.wait(0.5) do
        applySJ()
        if C.dayNight then pcall(function() L.ClockTime = C.dayNightTime end) end
    end
end)

task.spawn(function()
    while task.wait(2) do
        pcall(function()
            for _,v in pairs(W:GetDescendants()) do
                if v:IsA("Model") then
                    local n = v.Name:lower()
                    if C.espFish and n:find("fish") and not v:FindFirstChild("NSMOD_F") then
                        local h=Instance.new("Highlight"); h.Name="NSMOD_F"; h.FillColor=Color3.fromRGB(0,245,212); h.FillTransparency=0.5; h.Parent=v
                    end
                    if C.espNPC and (n:find("npc") or n:find("shop")) and not v:FindFirstChild("NSMOD_N") then
                        local h=Instance.new("Highlight"); h.Name="NSMOD_N"; h.FillColor=Color3.fromRGB(196,113,255); h.FillTransparency=0.5; h.Parent=v
                    end
                    if C.espChest and (n:find("chest") or n:find("crate")) and not v:FindFirstChild("NSMOD_C") then
                        local h=Instance.new("Highlight"); h.Name="NSMOD_C"; h.FillColor=Color3.fromRGB(254,228,64); h.FillTransparency=0.5; h.Parent=v
                    end
                end
                if v:IsA("BasePart") and C.espCoin then
                    local n=v.Name:lower()
                    if (n:find("coin") or n:find("money") or n:find("cash")) and not v:FindFirstChild("NSMOD_COIN") then
                        local h=Instance.new("Highlight"); h.Name="NSMOD_COIN"; h.FillColor=Color3.fromRGB(254,228,64); h.FillTransparency=0.5; h.Parent=v
                    end
                end
            end
        end)
    end
end)

task.spawn(function()
    while task.wait(1) do
        if C.fullBright then pcall(function() L.Brightness=5; L.ClockTime=14; L.Ambient=Color3.fromRGB(255,255,255); L.OutdoorAmbient=Color3.fromRGB(255,255,255) end) end
        if C.noFog then pcall(function() L.FogEnd=1e6; L.FogStart=1e6 end) end
    end
end)

pcall(function()
    local old = LP:WaitForChild("PlayerGui"):FindFirstChild("NSMOD_PRO")
    if old then old:Destroy() end
end)

local UI = Instance.new("ScreenGui")
UI.Name = "NSMOD_PRO"
UI.ResetOnSpawn = false
UI.Parent = LP:WaitForChild("PlayerGui")
getgenv().UI = UI

local M = Instance.new("Frame")
M.Size = UDim2.new(0,340,0,420)
M.Position = UDim2.new(0,20,0,20)
M.BackgroundColor3 = Color3.fromRGB(10,4,32)
M.BackgroundTransparency = 0.05
M.BorderSizePixel = 0
M.Parent = UI
Instance.new("UICorner",M).CornerRadius = UDim.new(0,12)

local St = Instance.new("UIStroke")
St.Color = Color3.fromRGB(0,245,212)
St.Thickness = 1.5
St.Parent = M

local TB = Instance.new("Frame")
TB.Size = UDim2.new(1,0,0,36)
TB.BackgroundColor3 = Color3.fromRGB(0,245,212)
TB.BackgroundTransparency = 0.85
TB.BorderSizePixel = 0
TB.Parent = M
Instance.new("UICorner",TB).CornerRadius = UDim.new(0,12)

local T = Instance.new("TextLabel")
T.Size = UDim2.new(1,-70,1,0)
T.Position = UDim2.new(0,12,0,0)
T.BackgroundTransparency = 1
T.Text = "⚡ NSMOD FISH IT PRO v5.0"
T.TextColor3 = Color3.fromRGB(0,245,212)
T.Font = Enum.Font.Code
T.TextSize = 13
T.TextXAlignment = Enum.TextXAlignment.Left
T.Parent = TB

local Mn = Instance.new("TextButton")
Mn.Size = UDim2.new(0,26,0,26)
Mn.Position = UDim2.new(1,-62,0,5)
Mn.BackgroundColor3 = Color3.fromRGB(254,228,64)
Mn.Text = "−"
Mn.TextColor3 = Color3.fromRGB(0,0,0)
Mn.Font = Enum.Font.Code
Mn.TextSize = 18
Mn.Parent = TB
Instance.new("UICorner",Mn).CornerRadius = UDim.new(0,6)

local Cl = Instance.new("TextButton")
Cl.Size = UDim2.new(0,26,0,26)
Cl.Position = UDim2.new(1,-32,0,5)
Cl.BackgroundColor3 = Color3.fromRGB(247,37,133)
Cl.Text = "✖"
Cl.TextColor3 = Color3.new(1,1,1)
Cl.Font = Enum.Font.Code
Cl.TextSize = 14
Cl.Parent = TB
Instance.new("UICorner",Cl).CornerRadius = UDim.new(0,6)

local TBar = Instance.new("Frame")
TBar.Size = UDim2.new(1,-16,0,30)
TBar.Position = UDim2.new(0,8,0,42)
TBar.BackgroundTransparency = 1
TBar.Parent = M

local TL = Instance.new("UIListLayout")
TL.FillDirection = Enum.FillDirection.Horizontal
TL.Padding = UDim.new(0,3)
TL.SortOrder = Enum.SortOrder.LayoutOrder
TL.Parent = TBar

local CT = Instance.new("Frame")
CT.Size = UDim2.new(1,-16,1,-120)
CT.Position = UDim2.new(0,8,0,78)
CT.BackgroundTransparency = 1
CT.Parent = M

local SB = Instance.new("TextLabel")
SB.Size = UDim2.new(1,-16,0,36)
SB.Position = UDim2.new(0,8,1,-42)
SB.BackgroundColor3 = Color3.fromRGB(0,0,0)
SB.BackgroundTransparency = 0.5
SB.Text = ""
SB.TextColor3 = Color3.fromRGB(0,245,212)
SB.Font = Enum.Font.Code
SB.TextSize = 10
SB.TextWrapped = true
SB.Parent = M
Instance.new("UICorner",SB).CornerRadius = UDim.new(0,6)

local Tabs, Pages = {}, {}

local function newTab(name, order)
    local TB2 = Instance.new("TextButton")
    TB2.Size = UDim2.new(0,48,1,0)
    TB2.BackgroundColor3 = Color3.fromRGB(20,10,45)
    TB2.Text = name
    TB2.TextColor3 = Color3.fromRGB(180,160,220)
    TB2.Font = Enum.Font.Code
    TB2.TextSize = 10
    TB2.LayoutOrder = order
    TB2.Parent = TBar
    Instance.new("UICorner",TB2).CornerRadius = UDim.new(0,6)

    local P = Instance.new("ScrollingFrame")
    P.Size = UDim2.new(1,0,1,0)
    P.BackgroundTransparency = 1
    P.BorderSizePixel = 0
    P.ScrollBarThickness = 4
    P.ScrollBarImageColor3 = Color3.fromRGB(0,245,212)
    P.CanvasSize = UDim2.new(0,0,0,0)
    P.AutomaticCanvasSize = Enum.AutomaticSize.Y
    P.Visible = false
    P.Parent = CT

    local LL = Instance.new("UIListLayout")
    LL.Padding = UDim.new(0,4)
    LL.SortOrder = Enum.SortOrder.LayoutOrder
    LL.Parent = P

    table.insert(Tabs, TB2)
    Pages[name] = P

    TB2.MouseButton1Click:Connect(function()
        for _,x in ipairs(Tabs) do x.BackgroundColor3 = Color3.fromRGB(20,10,45); x.TextColor3 = Color3.fromRGB(180,160,220) end
        for _,x in pairs(Pages) do x.Visible = false end
        TB2.BackgroundColor3 = Color3.fromRGB(0,100,80)
        TB2.TextColor3 = Color3.fromRGB(0,245,212)
        P.Visible = true
    end)

    return P
end

local function newToggle(p, txt, key)
    local B = Instance.new("TextButton")
    B.Size = UDim2.new(1,0,0,30)
    B.BackgroundColor3 = Color3.fromRGB(20,10,45)
    B.Text = "  "..txt.."  [ OFF ]"
    B.TextColor3 = Color3.fromRGB(180,160,220)
    B.Font = Enum.Font.Code
    B.TextSize = 11
    B.TextXAlignment = Enum.TextXAlignment.Left
    B.Parent = p
    Instance.new("UICorner",B).CornerRadius = UDim.new(0,6)

    local on = C[key] or false
    if on then B.Text="  "..txt.."  [ ON ]"; B.TextColor3=Color3.fromRGB(0,245,212); B.BackgroundColor3=Color3.fromRGB(0,80,60) end

    B.MouseButton1Click:Connect(function()
        on = not on
        C[key] = on
        if on then B.Text="  "..txt.."  [ ON ]"; B.TextColor3=Color3.fromRGB(0,245,212); B.BackgroundColor3=Color3.fromRGB(0,80,60)
        else B.Text="  "..txt.."  [ OFF ]"; B.TextColor3=Color3.fromRGB(180,160,220); B.BackgroundColor3=Color3.fromRGB(20,10,45) end
    end)
end

local function newSlider(p, txt, key, mn, mx, def)
    local F = Instance.new("Frame")
    F.Size = UDim2.new(1,0,0,44)
    F.BackgroundColor3 = Color3.fromRGB(20,10,45)
    F.BorderSizePixel = 0
    F.Parent = p
    Instance.new("UICorner",F).CornerRadius = UDim.new(0,6)

    local Lb = Instance.new("TextLabel")
    Lb.Size = UDim2.new(1,-12,0,18)
    Lb.Position = UDim2.new(0,8,0,2)
    Lb.BackgroundTransparency = 1
    Lb.Text = txt..": "..tostring(def)
    Lb.TextColor3 = Color3.fromRGB(200,180,240)
    Lb.Font = Enum.Font.Code
    Lb.TextSize = 11
    Lb.TextXAlignment = Enum.TextXAlignment.Left
    Lb.Parent = F

    local Bar = Instance.new("Frame")
    Bar.Size = UDim2.new(1,-16,0,8)
    Bar.Position = UDim2.new(0,8,0,26)
    Bar.BackgroundColor3 = Color3.fromRGB(40,20,80)
    Bar.BorderSizePixel = 0
    Bar.Parent = F
    Instance.new("UICorner",Bar).CornerRadius = UDim.new(0,4)

    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new((def-mn)/(mx-mn),0,1,0)
    Fill.BackgroundColor3 = Color3.fromRGB(0,245,212)
    Fill.BorderSizePixel = 0
    Fill.Parent = Bar
    Instance.new("UICorner",Fill).CornerRadius = UDim.new(0,4)

    local Inp = Instance.new("TextButton")
    Inp.Size = UDim2.new(1,0,1,0)
    Inp.BackgroundTransparency = 1
    Inp.Text = ""
    Inp.Parent = Bar

    local drag = false
    local function upd(x)
        local rel = math.clamp((x-Bar.AbsolutePosition.X)/Bar.AbsoluteSize.X, 0, 1)
        local val = math.floor((mn+rel*(mx-mn))*10)/10
        Fill.Size = UDim2.new(rel,0,1,0)
        Lb.Text = txt..": "..tostring(val)
        C[key] = val
    end

    Inp.MouseButton1Down:Connect(function() drag=true; upd(UIS:GetMouseLocation().X) end)
    UIS.InputChanged:Connect(function(i) if drag and i.UserInputType==Enum.UserInputType.MouseMovement then upd(i.Position.X) end end)
    UIS.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then drag=false end end)
end

local function newLabel(p, txt)
    local Lb = Instance.new("TextLabel")
    Lb.Size = UDim2.new(1,0,0,18)
    Lb.BackgroundTransparency = 1
    Lb.Text = "  "..txt
    Lb.TextColor3 = Color3.fromRGB(196,113,255)
    Lb.Font = Enum.Font.Code
    Lb.TextSize = 11
    Lb.TextXAlignment = Enum.TextXAlignment.Left
    Lb.Parent = p
end

local function newBtn(p, txt, cb)
    local B = Instance.new("TextButton")
    B.Size = UDim2.new(1,0,0,32)
    B.BackgroundColor3 = Color3.fromRGB(30,15,60)
    B.Text = "  "..txt
    B.TextColor3 = Color3.fromRGB(0,245,212)
    B.Font = Enum.Font.Code
    B.TextSize = 11
    B.TextXAlignment = Enum.TextXAlignment.Left
    B.Parent = p
    Instance.new("UICorner",B).CornerRadius = UDim.new(0,6)
    B.MouseButton1Click:Connect(cb)
end

local P1 = newTab("FARM",1)
newToggle(P1,"🎣 Auto Fish","autoFish")
newToggle(P1,"💰 Auto Sell","autoSell")
newToggle(P1,"📜 Auto Quest","autoQuest")
newToggle(P1,"🎯 Auto Buy Rod","autoBuyRod")
newToggle(P1,"⚡ Auto Skill","autoSkill")
newToggle(P1,"🎣 Auto Reel","autoReel")
newToggle(P1,"🔄 Auto Rebirth","autoRebirth")
newToggle(P1,"📅 Auto Daily","autoClaimDaily")
newToggle(P1,"🚀 Auto Booster","autoUseBooster")
newSlider(P1,"Fish Delay","fishDelay",0.5,5,2.0)
newSlider(P1,"Sell Interval","sellInterval",10,120,30)

local P2 = newTab("CLICK",2)
newToggle(P2,"🔧 Remote Function","useRemote")
newToggle(P2,"🖱️ VirtualUser Click","useClick")
newSlider(P2,"Click Delay","clickDelay",1,6,2.5)
newBtn(P2,"🔍 Test tìm nút",function()
    local b = findBtn()
    if b then nf("Test","Tìm thấy: "..b.Name,3) else nf("Test","Không tìm thấy",3) end
end)

local P3 = newTab("TP",3)
newLabel(P3,"─── Địa điểm ───")
newBtn(P3,"🏠 Spawn",function() if tpFn.spawn() then nf("TP","Đã tới spawn",2) end end)
newBtn(P3,"🏪 Shop",function() if tpFn.shop() then nf("TP","Đã tới shop",2) end end)
newBtn(P3,"🧙 NPC",function() if tpFn.npc() then nf("TP","Đã tới NPC",2) end end)
newBtn(P3,"🌊 Vùng Câu",function() if tpFn.zone() then nf("TP","Đã tới vùng câu",2) end end)
newLabel(P3,"─── Server ───")
newBtn(P3,"🔌 Server Hop",function()
    pcall(function()
        local srvs = HS:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
        for _,s in ipairs(srvs.data) do
            if s.playing<s.maxPlayers and s.id~=game.JobId then TS:TeleportToPlaceInstance(game.PlaceId,s.id,LP); return end
        end
    end)
end)
newBtn(P3,"🚪 Rejoin",function() pcall(function() TS:Teleport(game.PlaceId,LP) end) end)

local P4 = newTab("ITEM",4)
newBtn(P4,"⭐ Auto Equip Rod tốt nhất",function()
    pcall(function()
        local E = RS.Packages.Net:RemoteFunction('EquipRod') or RS.Packages.Net:RemoteFunction('EquipBestRod')
        if E then E:InvokeServer() end
    end)
    nf("Item","Đã equip",2)
end)
newLabel(P4,"─── Sell by Rarity ───")
newBtn(P4,"Sell Common",function()
    pcall(function() local S=RS.Packages.Net:RemoteFunction('SellByRarity') or RS.Packages.Net:RemoteFunction('SellFish'); if S then S:InvokeServer("Common") end end)
end)
newBtn(P4,"Sell Rare",function()
    pcall(function() local S=RS.Packages.Net:RemoteFunction('SellByRarity') or RS.Packages.Net:RemoteFunction('SellFish'); if S then S:InvokeServer("Rare") end end)
end)
newBtn(P4,"Sell Legendary",function()
    pcall(function() local S=RS.Packages.Net:RemoteFunction('SellByRarity') or RS.Packages.Net:RemoteFunction('SellFish'); if S then S:InvokeServer("Legendary") end end)
end)

local P5 = newTab("VIS",5)
newToggle(P5,"👁️ ESP Fish","espFish")
newToggle(P5,"🧙 ESP NPC","espNPC")
newToggle(P5,"📦 ESP Chest","espChest")
newToggle(P5,"🪙 ESP Coin","espCoin")
newToggle(P5,"💡 Full Bright","fullBright")
newToggle(P5,"🌫️ No Fog","noFog")
newToggle(P5,"⚡ FPS Boost","fpsBoost")
newToggle(P5,"🚫 Remove Effects","removeEffects")

local P6 = newTab("MISC",6)
newToggle(P6,"🏃 Speed Hack","speedHack")
newSlider(P6,"Speed Value","speedValue",16,200,50)
newToggle(P6,"🦘 Jump Power","jumpPower")
newSlider(P6,"Jump Value","jumpValue",50,500,100)
newToggle(P6,"🌗 Day/Night","dayNight")
newSlider(P6,"Time","dayNightTime",0,24,14)
newToggle(P6,"🛡️ Anti-Crash","antiCrash")

local P7 = newTab("BAN",7)
newToggle(P7,"🛡️ Anti-Ban","antiBan")
newToggle(P7,"💤 Anti-AFK","antiAFK")
newToggle(P7,"👁️ Hide on Admin","hideOnAdmin")
newToggle(P7,"🎲 Random Delay","randomDelay")
local BI = Instance.new("TextLabel")
BI.Size = UDim2.new(1,0,0,40)
BI.BackgroundColor3 = Color3.fromRGB(0,0,0)
BI.BackgroundTransparency = 0.5
BI.Text = "Admins: 0"
BI.TextColor3 = Color3.fromRGB(0,245,212)
BI.Font = Enum.Font.Code
BI.TextSize = 10
BI.Parent = P7
Instance.new("UICorner",BI).CornerRadius = UDim.new(0,6)

Tabs[1].BackgroundColor3 = Color3.fromRGB(0,100,80)
Tabs[1].TextColor3 = Color3.fromRGB(0,245,212)
Pages["FARM"].Visible = true

task.spawn(function()
    while task.wait(1) do
        pcall(function()
            C.sessionTime = math.floor(tick()-C.startTime)
            local m = math.floor(C.sessionTime/60)
            local s = C.sessionTime % 60
            SB.Text = string.format("🎣%d 🖱%d 💰%d 📜%d 🔄%d ⚠%d ⏱%02d:%02d",
                C.totalCaught,C.totalClicks,C.totalSold,C.totalQuest,C.totalRebirth,C.adminsFound,m,s)
            SB.TextColor3 = C.adminsFound>0 and Color3.fromRGB(247,37,133) or Color3.fromRGB(0,245,212)
            BI.Text = "Admins: "..C.adminsFound
        end)
    end
end)

local mini = false
Mn.MouseButton1Click:Connect(function()
    mini = not mini
    M.Size = mini and UDim2.new(0,340,0,36) or UDim2.new(0,340,0,420)
    Mn.Text = mini and "+" or "−"
end)

Cl.MouseButton1Click:Connect(function()
    UI.Enabled = false
    nf("NSMOD","RightCtrl để mở lại",2)
end)

local drg, dSt, sPo
TB.InputBegan:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
        drg=true; dSt=i.Position; sPo=M.Position
    end
end)
UIS.InputChanged:Connect(function(i)
    if drg and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
        local d = i.Position-dSt
        M.Position = UDim2.new(sPo.X.Scale,sPo.X.Offset+d.X,sPo.Y.Scale,sPo.Y.Offset+d.Y)
    end
end)
UIS.InputEnded:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then drg=false end
end)

UIS.InputBegan:Connect(function(i, pr)
    if pr then return end
    if i.KeyCode==Enum.KeyCode.RightControl then UI.Enabled = not UI.Enabled end
    if i.KeyCode==Enum.KeyCode.F1 then
        C.autoFish = not C.autoFish
        nf("Auto Fish",C.autoFish and "ON" or "OFF",1)
    end
end)

local FG = Instance.new("ScreenGui")
FG.Name = "NSMOD_FPS"
FG.ResetOnSpawn = false
FG.Parent = LP:WaitForChild("PlayerGui")

local FL = Instance.new("TextLabel")
FL.Size = UDim2.new(0,160,0,22)
FL.Position = UDim2.new(0,10,0,445)
FL.BackgroundColor3 = Color3.fromRGB(10,4,32)
FL.BackgroundTransparency = 0.2
FL.TextColor3 = Color3.fromRGB(0,245,212)
FL.Font = Enum.Font.Code
FL.TextSize = 12
FL.Text = "FPS: --"
FL.Parent = FG
Instance.new("UICorner",FL).CornerRadius = UDim.new(0,6)

local fc, ft = 0, tick()
RunService.RenderStepped:Connect(function()
    fc = fc + 1
    if tick()-ft >= 1 then
        FL.Text = "FPS: "..fc.." | NSMOD"
        fc = 0; ft = tick()
    end
end)

task.wait(0.5)
nf("NSMOD Fish It Pro v5.0","✅ 40+ features loaded!",5)
print("[NSMOD] ✅ Fish It Pro v5.0 FULL loaded")
print("[NSMOD] KÊNH TEL: t.me/sonchoigame23")
