-- ═══════════════════════════════════════════════════════════
-- ระบบออโต้ฟาร์มมอน + ระบบเควส (รองรับมือถือ 100%)
-- ═══════════════════════════════════════════════════════════

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- ═══════════════════════════════════════════════════════════
-- ตัวแปรการตั้งค่า
-- ═══════════════════════════════════════════════════════════
local farmEnabled = true
local pullDistance = 10
local farmPosition = nil
local autoQuest = true
local farmSpeed = 500

-- ตัวแปรสำหรับ Delta Time
local lastUpdateTime = tick()
local deltaTime = 0

-- ═══════════════════════════════════════════════════════════
-- ข้อมูลเควสทั้งหมด
-- ═══════════════════════════════════════════════════════════
local QuestData = {
    {
        Name = "Quest_Thugs",
        NpcName = "Quest Npc 1",
        MinLevel = 1,
        MaxLevel = 9,
        QuestPos = Vector3.new(-659.931641, 5.87902355, 304.040009),
        MobPos = Vector3.new(-606.735779, 4.77173042, 221.682709),
        MobName = "Thug"
    },
     {
        Name = "Quest_MetalVandals",
        NpcName = "Quest Npc 3",
        MinLevel = 10,
        MaxLevel = 14,
        QuestPos = Vector3.new(-348.96463, 5.19995594, 590.627319, 0.507683218, 1.86258819e-09, -0.861543834, -9.38400007e-08, 1, -5.31353166e-08, 0.861543834, 1.07823183e-07, 0.507683218),
        MobPos = Vector3.new(-289.957733, 4.77173042, 633.297607, -0.293958724, 1.08485999e-07, -0.955818117, 1.35527767e-08, 1, 1.09332561e-07, 0.955818117, 1.91852703e-08, -0.293958724),
        MobName = "Metal Vandal"
    },
       {
        Name = "Quest_StolenCar",
        NpcName = "Quest Npc 4",
        MinLevel = 15,
        MaxLevel = 24,
        QuestPos = Vector3.new(-443.34375, 5.240767, 278.011932, 0.363448262, 8.49291126e-08, 0.931614399, -3.59806158e-08, 1, -7.71263515e-08, -0.931614399, -5.48862156e-09, 0.363448262),
        MobPos = Vector3.new(-387.91806, 4.71038961, 249.266663, 0.862937212, -6.4007935e-08, -0.505311131, 6.62577122e-08, 1, -1.35197746e-08, 0.505311131, -2.18140421e-08, 0.862937212),
        MobName = "Car Thief"
    },
      {
        Name = "Quest_Criminals",
        NpcName = "Quest Npc 5",
        MinLevel = 25,
        MaxLevel = 39,
        QuestPos = Vector3.new(11.0609426, 5.19995642, 654.748413, 0.953568459, -8.95932288e-08, -0.301176339, 6.96719127e-08, 1, -7.68861383e-08, 0.301176339, 5.23326662e-08, 0.953568459),
        MobPos = Vector3.new(66.256958, 4.77172995, 593.1073, 0.878698051, 5.8407398e-08, -0.477378011, -5.67883411e-08, 1, 1.78215043e-08, 0.477378011, 1.14497842e-08, 0.878698051),
        MobName = "Criminal"
    },
          {
        Name = "Quest_Suitcase",
        NpcName = "Quest Npc 7",
        MinLevel = 40,
        MaxLevel = 54,
        QuestPos = Vector3.new(-632.111816, 10.096302, 1457.58203, 0.476116061, 7.04158065e-10, 0.879382432, 2.23805063e-08, 1, -1.2918016e-08, -0.879382432, 2.58315005e-08, 0.476116061),
        MobPos = Vector3.new(-726.91571, 4.70053768, 1456.18677, 0.607256472, 5.21315435e-10, 0.794505894, -5.46352164e-09, 1, 3.51972651e-09, -0.794505894, -6.47817711e-09, 0.607256472),
        MobName = "Metal Vandal Suitcase"
    },
              {
        Name = "Quest_MetalVandalJunkYard",
        NpcName = "Quest Npc 8",
        MinLevel = 55,
        MaxLevel = 69,
        QuestPos = Vector3.new(-801.652588, 4.61632395, 1574.06042, -0.398498803, 7.69913484e-08, 0.917168856, -6.09085848e-09, 1, -8.65909797e-08, -0.917168856, -4.00927469e-08, -0.398498803),
        MobPos = Vector3.new(-852.25415, 4.61632395, 1769.42664, -0.157906681, -3.45743878e-08, -0.987454057, 8.40301482e-08, 1, -4.84511737e-08, 0.987454057, -9.06266706e-08, -0.157906681),
        MobName = "Metal Vandal Junk Yard"
    },
              {
        Name = "Quest_HenchmanSmugglers",
        NpcName = "Quest Npc 9",
        MinLevel = 70,
        MaxLevel = 79,
        QuestPos = Vector3.new(-803.456543, 4.71822119, 295.061462, 0.653490424, -3.04004146e-08, 0.756934762, 3.99149336e-09, 1, 3.67165214e-08, -0.756934762, -2.09725961e-08, 0.653490424),
        MobPos = Vector3.new(-835.649841, 4.88055849, 324.7323, 0.809742332, -7.44841389e-09, 0.586785614, 5.25067527e-08, 1, -5.97637779e-08, -0.586785614, 7.92034669e-08, 0.809742332),
        MobName = "Henchman Smuggler"
    },
              {
        Name = "Quest_Smugglers",
        NpcName = "Quest Npc 10",
        MinLevel = 80,
        MaxLevel = 94,
        QuestPos = Vector3.new(-891.342712, 4.88055849, 7.51156759, -0.273569405, 6.11145481e-08, -0.961852252, -4.64247805e-08, 1, 7.67425021e-08, 0.961852252, 6.56481802e-08, -0.273569405),
        MobPos = Vector3.new(-1065.92932, 4.57889605, -18.7315578, 0.838973045, -1.08131381e-07, -0.544173002, 8.75673081e-08, 1, -6.37017479e-08, 0.544173002, 5.79228798e-09, 0.838973045),
        MobName = "Smuggler"
    },
              {
        Name = "Quest_LesserSmugglers",
        NpcName = "Quest Npc 11",
        MinLevel = 95,
        MaxLevel = 114,
        QuestPos = Vector3.new(-1190.58936, 4.88055849, 42.0932388, -0.984900773, -1.0072295e-07, 0.173119888, -1.12780015e-07, 1, -5.98092527e-08, -0.173119888, -7.84306451e-08, -0.984900773),
        MobPos = Vector3.new(-1151.75305, 16.4867039, 163.69606, 0.994657695, -4.8016048e-08, 0.103228189, 5.26451345e-08, 1, -4.21187423e-08, -0.103228189, 4.73281929e-08, 0.994657695),
        MobName = "Lesser Smuggler"
    },
              {
        Name = "Quest_MidSmugglers",
        NpcName = "Quest Npc 12",
        MinLevel = 115,
        MaxLevel = 124,
        QuestPos = Vector3.new(-1008.36218, 4.95367956, 102.601234, -0.102730162, 5.34607167e-08, 0.994709253, -3.63845132e-08, 1, -5.75027386e-08, -0.994709253, -4.2099277e-08, -0.102730162),
        MobPos = Vector3.new(-1014.48102, 5.39058352, 120.154144, 0.10961666, -1.06741216e-09, 0.993973911, 6.21218965e-10, 1, 1.00537467e-09, -0.993973911, 5.07269615e-10, 0.10961666),
        MobName = "Mid Smuggler"
    },
              {
        Name = "Quest_ExpertSmugglers",
        NpcName = "Quest Npc 13",
        MinLevel = 125,
        MaxLevel = 159,
        QuestPos = Vector3.new(-1586.40234, 5.49385881, 422.442841, 0.739580154, -1.06988324e-07, -0.673068523, 8.1173873e-08, 1, -6.97607163e-08, 0.673068523, -3.04193448e-09, 0.739580154),
        MobPos = Vector3.new(-1736.20117, 4.88034105, 412.896606, 0.107092746, 2.07903739e-09, 0.994249046, 1.04716626e-08, 1, -3.21898863e-09, -0.994249046, 1.07561711e-08, 0.107092746),
        MobName = "Expert Smuggler"
    },
              {
        Name = "Quest_HammerHeadHencheman",
        NpcName = "Quest Npc 15",
        MinLevel = 160,
        MaxLevel = 169,
        QuestPos = Vector3.new(247.266159, 4.97061729, 1581.08545, 0.034007825, 6.55284538e-09, -0.999421537, -2.57681894e-08, 1, 5.67981084e-09, 0.999421537, 2.55601265e-08, 0.034007825),
        MobPos = Vector3.new(298.336182, 4.4204545, 1695.77783, 0.845281422, -7.44391393e-09, -0.534321368, 6.69076741e-08, 1, 9.19145364e-08, 0.534321368, -1.13443846e-07, 0.845281422),
        MobName = "Hammer Head Henchman"
    },
              {
        Name = "Quest_HammerHeadArmedHenchman",
        NpcName = "Quest Npc 16",
        MinLevel = 170,
        MaxLevel = 229,
        QuestPos = Vector3.new(-25.8854771, 4.67759991, 1557.00159, -0.0323758498, -2.0996076e-08, -0.999475777, 9.60478843e-08, 1, -2.411835e-08, 0.999475777, -9.67783862e-08, -0.0323758498),
        MobPos = Vector3.new(7.63645172, 4.67759991, 1603.43408, 0.352387995, -4.87174887e-08, -0.935854018, -2.91204323e-08, 1, -6.30217727e-08, 0.935854018, 4.94605885e-08, 0.352387995),
        MobName = "Hammer Head Armed Henchman"
    },
                  {
        Name = "Quest_SonicStudents",
        NpcName = "Quest Npc 19",
        MinLevel = 230,
        MaxLevel = 244,
        QuestPos = Vector3.new(1165.32446, 60.8144875, 990.216309, 0.254310697, 3.2174146e-08, -0.967122555, 1.98604795e-08, 1, 3.84903416e-08, 0.967122555, -2.89960234e-08, 0.254310697),
        MobPos = Vector3.new(1138.70544, 61.6458855, 1077.83533, 0.258055717, -1.09484233e-07, 0.966130018, 3.04409333e-08, 1, 1.0519161e-07, -0.966130018, 2.26460317e-09, 0.258055717),
        MobName = "Sonic Student"
    },
                  {
        Name = "Quest_ExperiencedSonicStudent",
        NpcName = "Quest Npc 20",
        MinLevel = 245,
        MaxLevel = 314,
        QuestPos = Vector3.new(1118.50146, 60.8144913, 1170.75928, -0.051415626, -3.74858722e-08, 0.998677313, -1.09584919e-09, 1, 3.74791007e-08, -0.998677313, 8.32611757e-10, -0.051415626),
        MobPos = Vector3.new(1157.26355, 61.646019, 1252.72864, -0.44661203, 2.6473943e-08, -0.894727707, 4.87474665e-08, 1, 5.25605515e-09, 0.894727707, -4.12682937e-08, -0.44661203),
        MobName = "Experienced Sonic Student"
    },
                  {
        Name = "Quest_AlienInvaders",
        NpcName = "Quest Npc 22",
        MinLevel = 315,
        MaxLevel = 99999999999,
        QuestPos = Vector3.new(146.447968, 2.88605499, 2142.03662, -0.763070822, 8.90073508e-08, -0.646314859, 7.51497442e-09, 1, 1.28842601e-07, 0.646314859, 9.34589934e-08, -0.763070822),
        MobPos = Vector3.new(-23.0928211, -0.226721138, 2269.96729, -0.642774463, 5.14917815e-08, 0.766055465, 7.45425444e-10, 1, -6.6591312e-08, -0.766055465, -4.22321591e-08, -0.642774463),
        MobName = "Alien Invader"
    },
}

-- ═══════════════════════════════════════════════════════════
-- ฟังก์ชันรอแบบ Delta Time (สำหรับมือถือ)
-- ═══════════════════════════════════════════════════════════
local function smartWait(duration)
    local elapsed = 0
    local startTime = tick()
    
    while elapsed < duration do
        RunService.Heartbeat:Wait()
        elapsed = tick() - startTime
    end
end

-- ═══════════════════════════════════════════════════════════
-- ฟังก์ชันดึงเลเวลผู้เล่น
-- ═══════════════════════════════════════════════════════════
local function GetPlayerLevel()
    local success, level = pcall(function()
        return player.Build.DataStore.Level.Value
    end)
    
    if success and level then
        return level
    end
    
    warn("⚠️ ไม่สามารถดึงเลเวลได้ ใช้ค่าเริ่มต้น = 1")
    return 1
end

-- ═══════════════════════════════════════════════════════════
-- ฟังก์ชันหาเควสที่เหมาะสมจากเลเวล
-- ═══════════════════════════════════════════════════════════
local function GetSuitableQuest()
    local level = GetPlayerLevel()
    print("📊 เลเวลปัจจุบัน:", level)
    
    for _, quest in ipairs(QuestData) do
        if level >= quest.MinLevel and level <= quest.MaxLevel then
            print("✅ พบเควสที่เหมาะสม:", quest.Name)
            return quest
        end
    end
    
    warn("❌ ไม่มีเควสสำหรับเลเวล", level)
    return nil
end

-- ═══════════════════════════════════════════════════════════
-- ฟังก์ชันเช็คว่ามีเควสอยู่หรือไม่
-- ═══════════════════════════════════════════════════════════
local function HasQuest()
    local success, result = pcall(function()
        local questUI = player.PlayerGui.MainUI.GameplayUI.Quest
        return questUI.Visible
    end)
    
    return success and result or false
end

-- ═══════════════════════════════════════════════════════════
-- ฟังก์ชัน Tween ไปยังตำแหน่ง
-- ═══════════════════════════════════════════════════════════
local function TweenToPosition(targetPos)
    if not character or not humanoidRootPart then 
        warn("❌ ไม่พบตัวละคร!")
        return 
    end
    
    humanoidRootPart.Anchored = false
    
    local distance = (humanoidRootPart.Position - targetPos).Magnitude
    local duration = distance / farmSpeed
    
    print(string.format("🚀 Tween → ระยะทาง: %.0f | เวลา: %.1f วิ", distance, duration))
    
    local targetCFrame = CFrame.new(targetPos)
    local tween = TweenService:Create(
        humanoidRootPart,
        TweenInfo.new(duration, Enum.EasingStyle.Linear),
        {CFrame = targetCFrame}
    )
    
    tween:Play()
    tween.Completed:Wait()
    smartWait(0.2)
end

-- ═══════════════════════════════════════════════════════════
-- ฟังก์ชันรับเควส
-- ═══════════════════════════════════════════════════════════
local function AcceptQuest(questInfo)
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    print("🎯 กำลังรับเควส:", questInfo.Name)
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    
    TweenToPosition(questInfo.QuestPos)
    smartWait(0.5)
    
    local success = pcall(function()
        local npc = workspace.World.Characters.Interactable:FindFirstChild(questInfo.NpcName)
        if not npc then
            error("ไม่พบ NPC: " .. questInfo.NpcName)
        end
        
        print("📞 ส่งคำขอรับเควส...")
        player.Build.Remotes.ServerRequest:FireServer(
            "_callQuests",
            npc,
            questInfo.Name
        )
    end)
    
    if success then
        print("✅ ส่งคำขอรับเควสแล้ว รอตรวจสอบ...")
        smartWait(1)
        
        if HasQuest() then
            print("🎉 รับเควสสำเร็จ!")
            return true
        else
            warn("⚠️ เควสยังไม่ขึ้น รอเพิ่ม...")
            smartWait(1)
            return false
        end
    else
        warn("❌ เกิดข้อผิดพลาดในการรับเควส!")
        return false
    end
end

-- ═══════════════════════════════════════════════════════════
-- ฟังก์ชันวาปติดมอน
-- ═══════════════════════════════════════════════════════════
local function teleportToMonster(monster)
    local monsterRoot = monster:FindFirstChild("HumanoidRootPart")
    
    if monsterRoot and humanoidRootPart then
        local targetPos = monsterRoot.Position + (monsterRoot.CFrame.LookVector * pullDistance)
        humanoidRootPart.CFrame = CFrame.new(targetPos, monsterRoot.Position)
        farmPosition = humanoidRootPart.CFrame
        return true
    end
    
    return false
end

-- ฟังก์ชันล็อคตัวเรา
local function lockPlayer()
    if humanoidRootPart and farmPosition then
        humanoidRootPart.CFrame = farmPosition
        humanoidRootPart.Velocity = Vector3.new(0, 0, 0)
        humanoidRootPart.RotVelocity = Vector3.new(0, 0, 0)
    end
end

-- ฟังก์ชันตีมอน
local function attackMonster(monster)
    if not monster or not monster.Parent then return false end
    
    local success, err = pcall(function()
        local args = {
            "_callCombat",
            2,
            {monster},
            {},
            false
        }
        
        player:WaitForChild("Build"):WaitForChild("Remotes"):WaitForChild("ServerRequest"):FireServer(unpack(args))
    end)
    
    return success
end

-- ฟังก์ชันหามอนทั้งหมด
local function getAllMonsters(mobName)
    local monsters = {}
    
    if workspace:FindFirstChild("World") and workspace.World:FindFirstChild("Characters") then
        local npc = workspace.World.Characters:FindFirstChild("Non Player Character")
        
        if npc then
            for _, child in ipairs(npc:GetChildren()) do
                if child.Name == mobName then
                    table.insert(monsters, child)
                end
            end
        end
    end
    
    return monsters
end

-- ═══════════════════════════════════════════════════════════
-- ฟังก์ชันประมวลผลมอนตัวเดียว (ใช้ซอสเดิม + ปรับให้มือถือเล่นได้)
-- ═══════════════════════════════════════════════════════════
local function processMonster(monster)
    -- เช็คว่ามอนยังอยู่ไหม
    if not monster or not monster.Parent then 
        return false 
    end
    
    local humanoid = monster:FindFirstChild("Humanoid")
    local isDead = monster:FindFirstChild("Died")
    
    -- เช็คว่าตายแล้วหรือยัง
    if isDead then
        return true
    end
    
    if not humanoid then
        return true
    end
    
    -- วาปติดมอน
    if not teleportToMonster(monster) then
        return false
    end
    smartWait(0.1)
    
    -- เช็คเลือดปัจจุบัน
    local currentHealth = humanoid.Health
    
    -- 🔴 กรณีที่ 1: เลือดมากกว่า 100
    if currentHealth > 100 then
        local initialHealth = currentHealth
        local maxAttempts = 50
        local attempts = 0
        local healthDropped = false
        
        while attempts < maxAttempts and not healthDropped do
            attempts = attempts + 1
            
            lockPlayer()
            attackMonster(monster)
            
            smartWait(0.15)
            
            -- เช็คเลือดว่ายุบหรือยัง
            if humanoid.Health < initialHealth then
                healthDropped = true
            end
        end
        
        if healthDropped then
            smartWait(0.1)
            -- ใช้วิธีเดิม: set เลือดตรงๆ
            humanoid.Health = 0
        end
    
    -- 🔴 กรณีที่ 2: เลือด = 0
    elseif currentHealth <= 0 then
        -- ใช้วิธีเดิม: set เลือดตรงๆ
        humanoid.Health = 1
        smartWait(0.1)
        
        -- ตีมอน 3 ครั้ง
        for i = 1, 3 do
            lockPlayer()
            attackMonster(monster)
            smartWait(0.03)
        end
    
    -- 🔴 กรณีที่ 3: เลือด = 1
    elseif currentHealth == 1 then
        -- ตีมอน 3 ครั้ง
        for i = 1, 3 do
            lockPlayer()
            attackMonster(monster)
            smartWait(0.03)
        end
    end
    
    return true
end

-- ═══════════════════════════════════════════════════════════
-- ลูปล็อคตัวเราตลอดเวลา (ใช้ RenderStepped สำหรับมือถือ)
-- ═══════════════════════════════════════════════════════════
RunService.RenderStepped:Connect(function(delta)
    deltaTime = delta
    
    if farmEnabled and farmPosition then
        lockPlayer()
    end
end)

-- ═══════════════════════════════════════════════════════════
-- ลูปหลัก (ใช้ Heartbeat)
-- ═══════════════════════════════════════════════════════════
spawn(function()
    while true do
        RunService.Heartbeat:Wait()
        
        if not farmEnabled then 
            smartWait(0.5)
            continue 
        end
        
        -- อัพเดท character
        character = player.Character
        if not character then 
            smartWait(0.5)
            continue 
        end
        
        humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then 
            smartWait(0.5)
            continue 
        end
        
        -- ═══════════════════════════════════════════════════════════
        -- เช็คระบบเควส (ถ้าเปิด)
        -- ═══════════════════════════════════════════════════════════
        if autoQuest then
            -- หาเควสที่เหมาะสม
            local quest = GetSuitableQuest()
            if not quest then
                warn("❌ ไม่มีเควสสำหรับเลเวลนี้ รอ 3 วิ...")
                smartWait(3)
                continue
            end
            
            -- เช็คว่ามีเควสอยู่หรือไม่
            local hasQuest = HasQuest()
            
            -- ถ้าไม่มีเควส → ไปรับ
            if not hasQuest then
                AcceptQuest(quest)
                smartWait(1)
                hasQuest = HasQuest()
                
                if not hasQuest then
                    warn("❌ รับเควสไม่สำเร็จ ลองใหม่ใน 3 วิ...")
                    smartWait(3)
                    continue
                end
            end
            
            -- ถ้ายังไม่มีเควส → ห้ามฟาร์ม
            if not hasQuest then
                smartWait(1)
                continue
            end
            
            -- ไปยังตำแหน่งฟาร์ม
            TweenToPosition(quest.MobPos)
            smartWait(0.5)
            
            -- หามอนตามชื่อในเควส
            local monsters = getAllMonsters(quest.MobName)
            
            if #monsters == 0 then
                farmPosition = nil
                smartWait(1)
                continue
            end
            
            -- วนลูปประมวลผลมอนทีละตัว
            for i = 1, #monsters do
                if not farmEnabled then break end
                
                -- เช็คว่ายังมีเควสไหม (ถ้าหมด → หยุด)
                if not HasQuest() then
                    farmPosition = nil
                    break
                end
                
                local monster = monsters[i]
                processMonster(monster)
                smartWait(0.2)
            end
            
            farmPosition = nil
            smartWait(0.5)
        else
            -- ถ้าปิดระบบเควส → ฟาร์มแบบธรรมดา
            local monsters = getAllMonsters("Thug")
            
            if #monsters == 0 then
                farmPosition = nil
                smartWait(1)
                continue
            end
            
            for i = 1, #monsters do
                if not farmEnabled then break end
                
                local monster = monsters[i]
                processMonster(monster)
                smartWait(0.2)
            end
            
            farmPosition = nil
            smartWait(0.5)
        end
    end
end)

-- ═══════════════════════════════════════════════════════════
-- ฟังก์ชันเปิด/ปิด
-- ═══════════════════════════════════════════════════════════
local function toggleFarm()
    farmEnabled = not farmEnabled
    print("=====================================")
    print("🎮 ระบบฟาร์ม: " .. (farmEnabled and "เปิด ✅" or "ปิด ❌"))
    print("=====================================")
    
    if not farmEnabled then
        farmPosition = nil
    end
end

local function toggleAutoQuest()
    autoQuest = not autoQuest
    print("=====================================")
    print("📋 ระบบเควสอัตโนมัติ: " .. (autoQuest and "เปิด ✅" or "ปิด ❌"))
    print("=====================================")
end

-- ═══════════════════════════════════════════════════════════
-- ปุ่มสำหรับมือถือ (TouchGui)
-- ═══════════════════════════════════════════════════════════
local function createMobileUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "FarmControlUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = player:WaitForChild("PlayerGui")
    
    -- ปุ่มเปิด/ปิดฟาร์ม
    local FarmButton = Instance.new("TextButton")
    FarmButton.Name = "FarmButton"
    FarmButton.Size = UDim2.new(0, 100, 0, 50)
    FarmButton.Position = UDim2.new(0, 10, 0, 10)
    FarmButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
    FarmButton.Text = "Farm: ON"
    FarmButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    FarmButton.TextSize = 18
    FarmButton.Font = Enum.Font.GothamBold
    FarmButton.Parent = ScreenGui
    
    -- ปุ่มเปิด/ปิดเควส
    local QuestButton = Instance.new("TextButton")
    QuestButton.Name = "QuestButton"
    QuestButton.Size = UDim2.new(0, 100, 0, 50)
    QuestButton.Position = UDim2.new(0, 10, 0, 70)
    QuestButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
    QuestButton.Text = "Quest: ON"
    QuestButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    QuestButton.TextSize = 18
    QuestButton.Font = Enum.Font.GothamBold
    QuestButton.Parent = ScreenGui
    
    -- ฟังก์ชันปุ่มฟาร์ม
    FarmButton.MouseButton1Click:Connect(function()
        toggleFarm()
        if farmEnabled then
            FarmButton.Text = "Farm: ON"
            FarmButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
        else
            FarmButton.Text = "Farm: OFF"
            FarmButton.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
        end
    end)
    
    -- ฟังก์ชันปุ่มเควส
    QuestButton.MouseButton1Click:Connect(function()
        toggleAutoQuest()
        if autoQuest then
            QuestButton.Text = "Quest: ON"
            QuestButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
        else
            QuestButton.Text = "Quest: OFF"
            QuestButton.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
        end
    end)
    
    print("📱 สร้างปุ่มมือถือเรียบร้อย!")
end

-- เช็คว่าเป็นมือถือหรือไม่
local UserInputService = game:GetService("UserInputService")

if UserInputService.TouchEnabled then
    print("📱 ตรวจพบอุปกรณ์มือถือ - สร้างปุ่ม UI")
    createMobileUI()
else
    print("💻 ตรวจพบ PC - ใช้คีย์บอร์ด")
    -- กด F เพื่อเปิด/ปิดฟาร์ม | กด Q เพื่อเปิด/ปิดเควส
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == Enum.KeyCode.F then
            toggleFarm()
        elseif input.KeyCode == Enum.KeyCode.Q then
            toggleAutoQuest()
        end
    end)
end

-- ═══════════════════════════════════════════════════════════
-- แสดงข้อมูล
-- ═══════════════════════════════════════════════════════════
print("=====================================")
print("⚡ ระบบออโต้ฟาร์ม (รองรับมือถือ 100%)")
print("=====================================")
if UserInputService.TouchEnabled then
    print("📱 มือถือ: ใช้ปุ่มบนหน้าจอ")
else
    print("💻 PC: กด F (ฟาร์ม) | Q (เควส)")
end
print("")
print("🔧 ปรับปรุง:")
print("  - ใช้ RunService.Heartbeat แทน wait()")
print("  - ปรับเลือดด้วย Heartbeat Loop")
print("  - ล็อคตัวด้วย RenderStepped")
print("  - เพิ่มปุ่ม UI สำหรับมือถือ")
print("")
print("✅ ระบบฟาร์มเปิดอยู่")
print("✅ ระบบเควสเปิดอยู่")
print("=====================================")
