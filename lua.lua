local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ProximityPromptService = game:GetService("ProximityPromptService")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local player = Players.LocalPlayer

local PlayerGui = player and player:WaitForChild("PlayerGui")
if not PlayerGui then
    return
end

local ConfigName = "rbxlxcfgsave.json"
local defaultConfig = {
    cameraBind = "B",
    autoFlashEnabled = false,
    autoFlashPercent = 91,
    xrayEnabled = false,
    autoKickEnabled = false
}

local Settings = {
    CameraBind = "B",
    AutoFlashEnabled = false,
    AutoFlashPercent = 91,
    XrayEnabled = false,
    AutoKickEnabled = false
}

local function SaveConfig()
    local data = {
        CameraBind = Settings.CameraBind,
        AutoFlashEnabled = Settings.AutoFlashEnabled,
        AutoFlashPercent = Settings.AutoFlashPercent,
        XrayEnabled = Settings.XrayEnabled,
        AutoKickEnabled = Settings.AutoKickEnabled
    }
    
    local success, json = pcall(function() 
        return HttpService:JSONEncode(data) 
    end)
    
    if success and writefile then
        pcall(function() 
            writefile(ConfigName, json) 
        end)
    end
end

local function LoadConfig()
    if not isfile or not readfile then return end
    
    pcall(function()
        if isfile(ConfigName) then
            local content = readfile(ConfigName)
            local success, result = pcall(function() 
                return HttpService:JSONDecode(content) 
            end)
            
            if success and result then
                if result.CameraBind then Settings.CameraBind = result.CameraBind end
                if result.AutoFlashEnabled ~= nil then Settings.AutoFlashEnabled = result.AutoFlashEnabled end
                if result.AutoFlashPercent then Settings.AutoFlashPercent = result.AutoFlashPercent end
                if result.XrayEnabled ~= nil then Settings.XrayEnabled = result.XrayEnabled end
                if result.AutoKickEnabled ~= nil then Settings.AutoKickEnabled = result.AutoKickEnabled end
            end
        end
    end)
end

LoadConfig()

local gui = Instance.new("ScreenGui")
gui.Name = "RbxlxHub"
gui.ResetOnSpawn = false
gui.Parent = PlayerGui

local NORMAL_HEIGHT = 260
local EXPANDED_HEIGHT = 300

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 240, 0, Settings.AutoFlashEnabled and EXPANDED_HEIGHT or NORMAL_HEIGHT)
mainFrame.Position = UDim2.new(0.5, -120, 0.5, -(Settings.AutoFlashEnabled and EXPANDED_HEIGHT or NORMAL_HEIGHT)/2)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 27, 33)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = gui
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.ClipsDescendants = true

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, -45, 0, 35)
title.Position = UDim2.new(0, 10, 0, 8)
title.BackgroundTransparency = 1
title.Text = "RbxlxHub"
title.TextColor3 = Color3.fromRGB(220, 220, 240)
title.Font = Enum.Font.GothamBold
title.TextSize = 15
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = mainFrame

local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Name = "Minimize"
minimizeBtn.Size = UDim2.new(0, 24, 0, 24)
minimizeBtn.Position = UDim2.new(1, -32, 0, 8)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(55, 58, 68)
minimizeBtn.Text = "−"
minimizeBtn.TextColor3 = Color3.fromRGB(200, 200, 220)
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 18
minimizeBtn.AutoButtonColor = false
minimizeBtn.Parent = mainFrame

local minimizeCorner = Instance.new("UICorner")
minimizeCorner.CornerRadius = UDim.new(0, 6)
minimizeCorner.Parent = minimizeBtn

local container = Instance.new("Frame")
container.Name = "Container"
container.Size = UDim2.new(1, -20, 1, -55)
container.Position = UDim2.new(0, 10, 0, 45)
container.BackgroundTransparency = 1
container.Parent = mainFrame
container.Visible = true

local minimizedFrame = Instance.new("Frame")
minimizedFrame.Name = "MinimizedFrame"
minimizedFrame.Size = UDim2.new(1, 0, 0, 35)
minimizedFrame.BackgroundColor3 = Color3.fromRGB(25, 27, 33)
minimizedFrame.BorderSizePixel = 0
minimizedFrame.Parent = mainFrame
minimizedFrame.Visible = false

local minimizedCorner = Instance.new("UICorner")
minimizedCorner.CornerRadius = UDim.new(0, 8)
minimizedCorner.Parent = minimizedFrame

local minimizedTitle = Instance.new("TextLabel")
minimizedTitle.Name = "Title"
minimizedTitle.Size = UDim2.new(1, -45, 1, 0)
minimizedTitle.Position = UDim2.new(0, 10, 0, 0)
minimizedTitle.BackgroundTransparency = 1
minimizedTitle.Text = "RbxlxHub"
minimizedTitle.TextColor3 = Color3.fromRGB(220, 220, 240)
minimizedTitle.Font = Enum.Font.GothamBold
minimizedTitle.TextSize = 15
minimizedTitle.TextXAlignment = Enum.TextXAlignment.Left
minimizedTitle.Parent = minimizedFrame

local minimizeBtn2 = Instance.new("TextButton")
minimizeBtn2.Name = "Minimize"
minimizeBtn2.Size = UDim2.new(0, 24, 0, 24)
minimizeBtn2.Position = UDim2.new(1, -32, 0.5, -12)
minimizeBtn2.BackgroundColor3 = Color3.fromRGB(55, 58, 68)
minimizeBtn2.Text = "+"
minimizeBtn2.TextColor3 = Color3.fromRGB(200, 200, 220)
minimizeBtn2.Font = Enum.Font.GothamBold
minimizeBtn2.TextSize = 18
minimizeBtn2.AutoButtonColor = false
minimizeBtn2.Parent = minimizedFrame

local minimizeCorner2 = Instance.new("UICorner")
minimizeCorner2.CornerRadius = UDim.new(0, 6)
minimizeCorner2.Parent = minimizeBtn2

local function animateSize(targetHeight)
    local tweenInfo = TweenInfo.new(
        0.3,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.Out
    )
    
    local goal = {
        Size = UDim2.new(0, 240, 0, targetHeight)
    }
    
    local tween = TweenService:Create(mainFrame, tweenInfo, goal)
    tween:Play()
    
    local posTweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local posGoal = {
        Position = UDim2.new(0.5, -120, 0.5, -targetHeight/2)
    }
    local posTween = TweenService:Create(mainFrame, posTweenInfo, posGoal)
    posTween:Play()
end

local cameraBind = Settings.CameraBind
local cameraConnection = nil

local function setupCameraButton(btn, bindBtn)
    local camera = workspace.CurrentCamera
    
    local function activateCamera()
        if not camera then 
            camera = workspace.CurrentCamera
            if not camera then return end
        end
        
        pcall(function()
            local pos = camera.CFrame.Position
            local lookVector = camera.CFrame.LookVector
            local horizontalDir = Vector3.new(lookVector.X, 0, lookVector.Z).Unit
            
            if horizontalDir.Magnitude > 0 then
                local lookAtPoint = pos + horizontalDir * 100 + Vector3.new(0, 80, 0)
                local targetCFrame = CFrame.lookAt(pos, lookAtPoint)
                camera.CFrame = targetCFrame
            end
            
            if btn then
                local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                local goal = {BackgroundColor3 = Color3.fromRGB(70, 80, 120)}
                local tween = TweenService:Create(btn, tweenInfo, goal)
                tween:Play()
                
                task.wait(0.1)
                
                local goal2 = {BackgroundColor3 = Color3.fromRGB(45, 48, 58)}
                local tween2 = TweenService:Create(btn, tweenInfo, goal2)
                tween2:Play()
            end
        end)
    end
    
    if btn then
        btn.MouseButton1Click:Connect(activateCamera)
    end
    
    if bindBtn then
        bindBtn.Text = cameraBind or "B"
        
        bindBtn.MouseButton1Click:Connect(function()
            bindBtn.Text = "..."
            
            local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local goal = {BackgroundColor3 = Color3.fromRGB(90, 100, 150)}
            local tween = TweenService:Create(bindBtn, tweenInfo, goal)
            tween:Play()
            
            local connection
            connection = UserInputService.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Keyboard then
                    local keyName = tostring(input.KeyCode):gsub("Enum.KeyCode.", "")
                    cameraBind = keyName
                    bindBtn.Text = keyName
                    
                    local goal2 = {BackgroundColor3 = Color3.fromRGB(65, 68, 80)}
                    local tween2 = TweenService:Create(bindBtn, tweenInfo, goal2)
                    tween2:Play()
                    
                    Settings.CameraBind = keyName
                    SaveConfig()
                    
                    if connection then
                        connection:Disconnect()
                    end
                end
            end)
        end)
        
        local function onInputBegan(input)
            if input.UserInputType == Enum.UserInputType.Keyboard then
                local key = tostring(input.KeyCode):gsub("Enum.KeyCode.", "")
                if key == cameraBind then
                    activateCamera()
                end
            end
        end
        
        cameraConnection = UserInputService.InputBegan:Connect(onInputBegan)
    end
end

local function setupNoSoundCloneButton(btn)
    if not btn then return end
    
    btn.MouseButton1Click:Connect(function()
        pcall(function()
            local char = player.Character
            if not char then return end
            
            local humanoid = char:FindFirstChildWhichIsA("Humanoid")
            if not humanoid then return end
            
            local backpack = player:FindFirstChild("Backpack")
            if not backpack then return end
            
            local cloner = backpack:FindFirstChild("Quantum Cloner") or 
                          backpack:FindFirstChild("QuantumCloner") or
                          backpack:FindFirstChild("quantum cloner") or
                          backpack:FindFirstChild("quantumcloner")
            
            if not cloner then
                for _, item in pairs(backpack:GetChildren()) do
                    if item:IsA("Tool") then
                        local name = string.lower(item.Name)
                        if name:find("quantum") or name:find("cloner") or name:find("клон") then
                            cloner = item
                            break
                        end
                    end
                end
            end
            
            if cloner then
                humanoid:UnequipTools()
                task.wait(0.005)
                humanoid:EquipTool(cloner)
                task.wait(0.01)
                cloner:Activate()
                
                local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                local goal = {BackgroundColor3 = Color3.fromRGB(0, 150, 0)}
                local tween = TweenService:Create(btn, tweenInfo, goal)
                tween:Play()
                
                task.wait(0.2)
                
                local goal2 = {BackgroundColor3 = Color3.fromRGB(45, 48, 58)}
                local tween2 = TweenService:Create(btn, tweenInfo, goal2)
                tween2:Play()
                
                task.wait(0.0001)
                game:Shutdown()
            else
                local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                local goal = {BackgroundColor3 = Color3.fromRGB(150, 0, 0)}
                local tween = TweenService:Create(btn, tweenInfo, goal)
                tween:Play()
                
                task.wait(0.2)
                
                local goal2 = {BackgroundColor3 = Color3.fromRGB(45, 48, 58)}
                local tween2 = TweenService:Create(btn, tweenInfo, goal2)
                tween2:Play()
            end
        end)
    end)
end

local flashSliderFrame = nil
local xrayToggle = nil
local autoKickToggle = nil

local function setupAutoUseFlashToggle(toggleFrame)
    if not toggleFrame then return end
    
    local toggleBtn = toggleFrame:FindFirstChild("Toggle")
    local circle = toggleBtn and toggleBtn:FindFirstChild("Circle")
    if not toggleBtn or not circle then return end
    
    local state = Settings.AutoFlashEnabled
    local flashConnection = nil
    local holdConnection = nil
    local flashPercent = Settings.AutoFlashPercent
    
    local function updateSliderPosition()
        if flashSliderFrame then
            if state then
                flashSliderFrame.Visible = true
                flashSliderFrame.Size = UDim2.new(1, 0, 0, 0)
                
                local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                local goal = {Size = UDim2.new(1, 0, 0, 30)}
                local tween = TweenService:Create(flashSliderFrame, tweenInfo, goal)
                tween:Play()
                
                if xrayToggle then
                    local xrayGoal = {Position = UDim2.new(0, 0, 0, 170)}
                    local xrayTween = TweenService:Create(xrayToggle, tweenInfo, xrayGoal)
                    xrayTween:Play()
                end
                if autoKickToggle then
                    local kickGoal = {Position = UDim2.new(0, 0, 0, 210)}
                    local kickTween = TweenService:Create(autoKickToggle, tweenInfo, kickGoal)
                    kickTween:Play()
                end
                
                animateSize(EXPANDED_HEIGHT)
            else
                local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                local goal = {Size = UDim2.new(1, 0, 0, 0)}
                local tween = TweenService:Create(flashSliderFrame, tweenInfo, goal)
                tween:Play()
                
                task.wait(0.15)
                flashSliderFrame.Visible = false
                
                if xrayToggle then
                    local xrayGoal = {Position = UDim2.new(0, 0, 0, 120)}
                    local xrayTween = TweenService:Create(xrayToggle, tweenInfo, xrayGoal)
                    xrayTween:Play()
                end
                if autoKickToggle then
                    local kickGoal = {Position = UDim2.new(0, 0, 0, 160)}
                    local kickTween = TweenService:Create(autoKickToggle, tweenInfo, kickGoal)
                    kickTween:Play()
                end
                
                animateSize(NORMAL_HEIGHT)
            end
        end
    end
    
    if flashSliderFrame then
        local percentLabel = flashSliderFrame:FindFirstChild("PercentLabel")
        if percentLabel then
            percentLabel.Text = flashPercent .. "%"
        end
    end
    
    local function useFlashTeleport()
        pcall(function()
            if player:GetAttribute("Stealing") then return end
            local char = player.Character
            if not char then return end
            local hum = char:FindFirstChildOfClass("Humanoid")
            if not hum then return end
            local tool = player.Backpack:FindFirstChild("Flash Teleport") or char:FindFirstChild("Flash Teleport")
            if not tool then return end
            
            hum:EquipTool(tool)
            local t = os.clock()
            while tool.Parent ~= char and os.clock() - t < 1.5 do
                RunService.RenderStepped:Wait()
            end
            if tool.Parent ~= char then return end
            
            for i = 1, 15 do
                RunService.RenderStepped:Wait()
            end
            
            tool:Activate()
        end)
    end
    
    local function setupConnections()
        if flashConnection then
            flashConnection:Disconnect()
            flashConnection = nil
        end
        if holdConnection then
            holdConnection:Disconnect()
            holdConnection = nil
        end
        
        local startTime = 0
        local duration = 1
        local used = false
        local holding = false
        
        flashConnection = ProximityPromptService.PromptButtonHoldBegan:Connect(function(prompt, plr)
            if plr ~= player then return end
            holding = true
            used = false
            startTime = os.clock()
            duration = prompt and prompt.HoldDuration or 1
            
            task.spawn(function()
                while holding do
                    if player:GetAttribute("Stealing") then break end
                    
                    local progress = (os.clock() - startTime) / duration
                    local threshold = flashPercent / 100
                    
                    if progress >= threshold and not used then
                        used = true
                        useFlashTeleport()
                    end
                    RunService.Heartbeat:Wait()
                end
            end)
        end)
        
        holdConnection = ProximityPromptService.PromptButtonHoldEnded:Connect(function(_, plr)
            if plr ~= player then return end
            holding = false
        end)
    end
    
    if state then
        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local goal = {BackgroundColor3 = Color3.fromRGB(90, 140, 255)}
        local tween = TweenService:Create(toggleBtn, tweenInfo, goal)
        tween:Play()
        
        local circleGoal = {Position = UDim2.new(1, -18, 0.5, -8)}
        local circleTween = TweenService:Create(circle, tweenInfo, circleGoal)
        circleTween:Play()
        
        setupConnections()
    else
        toggleBtn.BackgroundColor3 = Color3.fromRGB(100, 105, 120)
        circle.Position = UDim2.new(0, 2, 0.5, -8)
    end
    
    updateSliderPosition()
    
    toggleBtn.MouseButton1Click:Connect(function()
        state = not state
        Settings.AutoFlashEnabled = state
        SaveConfig()
        
        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        
        if state then
            local goal = {BackgroundColor3 = Color3.fromRGB(90, 140, 255)}
            local tween = TweenService:Create(toggleBtn, tweenInfo, goal)
            tween:Play()
            
            local circleGoal = {Position = UDim2.new(1, -18, 0.5, -8)}
            local circleTween = TweenService:Create(circle, tweenInfo, circleGoal)
            circleTween:Play()
            
            setupConnections()
        else
            local goal = {BackgroundColor3 = Color3.fromRGB(100, 105, 120)}
            local tween = TweenService:Create(toggleBtn, tweenInfo, goal)
            tween:Play()
            
            local circleGoal = {Position = UDim2.new(0, 2, 0.5, -8)}
            local circleTween = TweenService:Create(circle, tweenInfo, circleGoal)
            circleTween:Play()
            
            if flashConnection then
                flashConnection:Disconnect()
                flashConnection = nil
            end
            if holdConnection then
                holdConnection:Disconnect()
                holdConnection = nil
            end
        end
        
        updateSliderPosition()
    end)
end

local xrayEnabled = Settings.XrayEnabled
local xrayConnection = nil
local xrayToggleFrame = nil

local ignoreFolders = {
    AnimalPodiums = true,
    Decorations = true,
    InvisibleWalls = true,
    Laser = true,
    LaserHitbox = true,
    Purchases = true,
    Skin = true,
    Unlock = true
}

local ignoreParts = {
    AnimalTarget = true,
    DeliveryHitbox = true,
    MainRoot = true,
    Multiplier = true,
    PlotSign = true,
    Slope = true,
    Spawn = true,
    StealHitbox = true
}

local ignoreModels = {
    FriendPanel = true,
    CashPad = true
}

local lastUpdate = 0
local partsCache = {}
local cacheTime = 0

local function shouldIgnore(obj)
    if not obj then return true end
    
    local objName = obj.Name
    
    if obj:IsA("Model") and ignoreModels[objName] then
        return true
    end
    
    if obj:IsA("Folder") and ignoreFolders[objName] then
        return true
    end
    
    if obj:IsA("BasePart") and ignoreParts[objName] then
        return true
    end
    
    local parent = obj.Parent
    while parent do
        local parentName = parent.Name
        
        if parent:IsA("Folder") and ignoreFolders[parentName] then
            return true
        end
        
        if parent:IsA("Model") and ignoreModels[parentName] then
            return true
        end
        
        parent = parent.Parent
    end
    
    return false
end

local function getAllParts()
    local currentTime = tick()
    
    if not next(partsCache) or currentTime - cacheTime > 5 then
        local plots = Workspace:FindFirstChild("Plots")
        local newParts = {}
        cacheTime = currentTime
        
        if plots then
            local function collectParts(instance)
                if shouldIgnore(instance) then
                    return
                end
                
                if instance:IsA("BasePart") then
                    table.insert(newParts, instance)
                end
                
                for _, child in ipairs(instance:GetChildren()) do
                    collectParts(child)
                end
            end
            
            pcall(function() collectParts(plots) end)
        end
        
        partsCache = newParts
    end
    
    return partsCache
end

local function enableXray()
    xrayEnabled = true
    cacheTime = 0
    
    if xrayToggleFrame then
        local toggleBtn = xrayToggleFrame:FindFirstChild("Toggle")
        local circle = toggleBtn and toggleBtn:FindFirstChild("Circle")
        if toggleBtn and circle then
            local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local goal = {BackgroundColor3 = Color3.fromRGB(90, 140, 255)}
            local tween = TweenService:Create(toggleBtn, tweenInfo, goal)
            tween:Play()
            
            local circleGoal = {Position = UDim2.new(1, -18, 0.5, -8)}
            local circleTween = TweenService:Create(circle, tweenInfo, circleGoal)
            circleTween:Play()
        end
    end
end

local function disableXray()
    xrayEnabled = false
    
    pcall(function()
        for _, part in ipairs(partsCache) do
            if part and part.Parent then
                part.Transparency = 0
            end
        end
    end)
    
    if xrayToggleFrame then
        local toggleBtn = xrayToggleFrame:FindFirstChild("Toggle")
        local circle = toggleBtn and toggleBtn:FindFirstChild("Circle")
        if toggleBtn and circle then
            local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local goal = {BackgroundColor3 = Color3.fromRGB(100, 105, 120)}
            local tween = TweenService:Create(toggleBtn, tweenInfo, goal)
            tween:Play()
            
            local circleGoal = {Position = UDim2.new(0, 2, 0.5, -8)}
            local circleTween = TweenService:Create(circle, tweenInfo, circleGoal)
            circleTween:Play()
        end
    end
end

local function setupXrayToggle(toggleFrame)
    if not toggleFrame then return end
    
    xrayToggleFrame = toggleFrame
    local toggleBtn = toggleFrame:FindFirstChild("Toggle")
    local circle = toggleBtn and toggleBtn:FindFirstChild("Circle")
    if not toggleBtn or not circle then return end
    
    local state = xrayEnabled
    
    if state then
        toggleBtn.BackgroundColor3 = Color3.fromRGB(90, 140, 255)
        circle.Position = UDim2.new(1, -18, 0.5, -8)
    else
        toggleBtn.BackgroundColor3 = Color3.fromRGB(100, 105, 120)
        circle.Position = UDim2.new(0, 2, 0.5, -8)
    end
    
    if state then
        xrayConnection = RunService.Heartbeat:Connect(function()
            local currentTime = tick()
            
            if currentTime - lastUpdate >= 0.01 then
                lastUpdate = currentTime
                
                if xrayEnabled then
                    local parts = getAllParts()
                    
                    pcall(function()
                        for _, part in ipairs(parts) do
                            if part and part.Parent then
                                part.Transparency = 0.95
                            end
                        end
                    end)
                end
            end
        end)
    end
    
    toggleBtn.MouseButton1Click:Connect(function()
        state = not state
        Settings.XrayEnabled = state
        SaveConfig()
        
        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        
        if state then
            local goal = {BackgroundColor3 = Color3.fromRGB(90, 140, 255)}
            local tween = TweenService:Create(toggleBtn, tweenInfo, goal)
            tween:Play()
            
            local circleGoal = {Position = UDim2.new(1, -18, 0.5, -8)}
            local circleTween = TweenService:Create(circle, tweenInfo, circleGoal)
            circleTween:Play()
            
            enableXray()
            
            if not xrayConnection then
                xrayConnection = RunService.Heartbeat:Connect(function()
                    local currentTime = tick()
                    
                    if currentTime - lastUpdate >= 0.01 then
                        lastUpdate = currentTime
                        
                        if xrayEnabled then
                            local parts = getAllParts()
                            
                            pcall(function()
                                for _, part in ipairs(parts) do
                                    if part and part.Parent then
                                        part.Transparency = 0.95
                                    end
                                end
                            end)
                        end
                    end
                end)
            end
        else
            local goal = {BackgroundColor3 = Color3.fromRGB(100, 105, 120)}
            local tween = TweenService:Create(toggleBtn, tweenInfo, goal)
            tween:Play()
            
            local circleGoal = {Position = UDim2.new(0, 2, 0.5, -8)}
            local circleTween = TweenService:Create(circle, tweenInfo, circleGoal)
            circleTween:Play()
            
            disableXray()
            
            if xrayConnection then
                xrayConnection:Disconnect()
                xrayConnection = nil
            end
        end
    end)
    
    task.spawn(function()
        task.wait(1)
        getAllParts()
    end)
end

local autoKickEnabled = Settings.AutoKickEnabled
local autoKickConnections = {}
local KEYWORD = "you stole"
local KICK_MESSAGE = "инвайт в нави"

local function kick()
    pcall(function()
        player:Kick(KICK_MESSAGE)
    end)
end

local function hasKeyword(text)
    if typeof(text) ~= "string" then return false end
    return string.find(string.lower(text), KEYWORD) ~= nil
end

local function watchObject(obj)
    if not obj then return end
    if not (obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox")) then
        return
    end
    
    pcall(function()
        if hasKeyword(obj.Text) then
            kick()
            return
        end
        
        local conn = obj:GetPropertyChangedSignal("Text"):Connect(function()
            if hasKeyword(obj.Text) then
                kick()
            end
        end)
        table.insert(autoKickConnections, conn)
    end)
end

local function scan(parent)
    if not parent then return end
    pcall(function()
        for _, obj in ipairs(parent:GetDescendants()) do
            watchObject(obj)
        end
    end)
end

local function watchGui(gui)
    if not gui then return end
    scan(gui)
    
    local conn = gui.DescendantAdded:Connect(function(desc)
        watchObject(desc)
    end)
    table.insert(autoKickConnections, conn)
end

local function enableAutoKick()
    autoKickEnabled = true
    
    for _, conn in ipairs(autoKickConnections) do
        pcall(function() conn:Disconnect() end)
    end
    autoKickConnections = {}
    
    pcall(function()
        for _, gui in ipairs(PlayerGui:GetChildren()) do
            watchGui(gui)
        end
        
        local conn = PlayerGui.ChildAdded:Connect(function(gui)
            watchGui(gui)
        end)
        table.insert(autoKickConnections, conn)
    end)
end

local function disableAutoKick()
    autoKickEnabled = false
    
    for _, conn in ipairs(autoKickConnections) do
        pcall(function() conn:Disconnect() end)
    end
    autoKickConnections = {}
end

local function setupAutoKickToggle(toggleFrame)
    if not toggleFrame then return end
    
    local toggleBtn = toggleFrame:FindFirstChild("Toggle")
    local circle = toggleBtn and toggleBtn:FindFirstChild("Circle")
    if not toggleBtn or not circle then return end
    
    local state = autoKickEnabled
    
    if state then
        toggleBtn.BackgroundColor3 = Color3.fromRGB(90, 140, 255)
        circle.Position = UDim2.new(1, -18, 0.5, -8)
        task.spawn(enableAutoKick)
    else
        toggleBtn.BackgroundColor3 = Color3.fromRGB(100, 105, 120)
        circle.Position = UDim2.new(0, 2, 0.5, -8)
    end
    
    toggleBtn.MouseButton1Click:Connect(function()
        state = not state
        Settings.AutoKickEnabled = state
        SaveConfig()
        
        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        
        if state then
            local goal = {BackgroundColor3 = Color3.fromRGB(90, 140, 255)}
            local tween = TweenService:Create(toggleBtn, tweenInfo, goal)
            tween:Play()
            
            local circleGoal = {Position = UDim2.new(1, -18, 0.5, -8)}
            local circleTween = TweenService:Create(circle, tweenInfo, circleGoal)
            circleTween:Play()
            
            task.spawn(enableAutoKick)
        else
            local goal = {BackgroundColor3 = Color3.fromRGB(100, 105, 120)}
            local tween = TweenService:Create(toggleBtn, tweenInfo, goal)
            tween:Play()
            
            local circleGoal = {Position = UDim2.new(0, 2, 0.5, -8)}
            local circleTween = TweenService:Create(circle, tweenInfo, circleGoal)
            circleTween:Play()
            
            task.spawn(disableAutoKick)
        end
    end)
end

local function createSlider()
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Name = "AutoFlashSlider"
    sliderFrame.Size = UDim2.new(1, 0, 0, 30)
    sliderFrame.Position = UDim2.new(0, 0, 0, 120)
    sliderFrame.BackgroundTransparency = 1
    sliderFrame.Parent = container
    sliderFrame.Visible = Settings.AutoFlashEnabled
    sliderFrame.ClipsDescendants = true
    
    local sliderBg = Instance.new("Frame")
    sliderBg.Name = "Background"
    sliderBg.Size = UDim2.new(0, 160, 0, 6)
    sliderBg.Position = UDim2.new(0, 28, 0.5, -3)
    sliderBg.BackgroundColor3 = Color3.fromRGB(65, 68, 80)
    sliderBg.Parent = sliderFrame
    
    local bgCorner = Instance.new("UICorner")
    bgCorner.CornerRadius = UDim.new(1, 0)
    bgCorner.Parent = sliderBg
    
    local fill = Instance.new("Frame")
    fill.Name = "Fill"
    fill.Size = UDim2.new(Settings.AutoFlashPercent / 100, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(90, 140, 255)
    fill.Parent = sliderBg
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = fill
    
    local sliderButton = Instance.new("TextButton")
    sliderButton.Name = "SliderButton"
    sliderButton.Size = UDim2.new(0, 16, 0, 16)
    sliderButton.Position = UDim2.new(Settings.AutoFlashPercent / 100, -8, 0.5, -8)
    sliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    sliderButton.Text = ""
    sliderButton.AutoButtonColor = false
    sliderButton.Parent = sliderBg
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(1, 0)
    buttonCorner.Parent = sliderButton
    
    local percentLabel = Instance.new("TextLabel")
    percentLabel.Name = "PercentLabel"
    percentLabel.Size = UDim2.new(0, 40, 1, 0)
    percentLabel.Position = UDim2.new(1, -45, 0, 0)
    percentLabel.BackgroundTransparency = 1
    percentLabel.Text = Settings.AutoFlashPercent .. "%"
    percentLabel.TextColor3 = Color3.fromRGB(170, 180, 255)
    percentLabel.Font = Enum.Font.GothamBold
    percentLabel.TextSize = 12
    percentLabel.TextXAlignment = Enum.TextXAlignment.Right
    percentLabel.Parent = sliderFrame
    
    local dragging = false
    
    local function updateSlider(input)
        local mousePos = input.Position
        local bgPos = sliderBg.AbsolutePosition
        local bgSize = sliderBg.AbsoluteSize.X
        
        local relativeX = math.clamp(mousePos.X - bgPos.X, 0, bgSize)
        local percent = math.floor((relativeX / bgSize) * 100)
        percent = math.clamp(percent, 1, 100)
        
        local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local fillGoal = {Size = UDim2.new(percent / 100, 0, 1, 0)}
        local fillTween = TweenService:Create(fill, tweenInfo, fillGoal)
        fillTween:Play()
        
        local buttonGoal = {Position = UDim2.new(percent / 100, -8, 0.5, -8)}
        local buttonTween = TweenService:Create(sliderButton, tweenInfo, buttonGoal)
        buttonTween:Play()
        
        percentLabel.Text = percent .. "%"
        
        Settings.AutoFlashPercent = percent
        SaveConfig()
    end
    
    sliderButton.MouseButton1Down:Connect(function()
        dragging = true
        
        local connection
        connection = UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                updateSlider(input)
            end
        end)
        
        local releaseConn
        releaseConn = UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
                connection:Disconnect()
                releaseConn:Disconnect()
            end
        end)
    end)
    
    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            updateSlider(input)
        end
    end)
    
    return sliderFrame
end

local function createButton(name, text, icon, row, hasBind)
    local yPos = (row - 1) * 40
    
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = UDim2.new(1, 0, 0, 32)
    btn.Position = UDim2.new(0, 0, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(45, 48, 58)
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.Parent = container
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn
    
    local iconLabel = Instance.new("TextLabel")
    iconLabel.Name = "Icon"
    iconLabel.Size = UDim2.new(0, 24, 1, 0)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Text = icon
    iconLabel.TextColor3 = Color3.fromRGB(170, 180, 255)
    iconLabel.Font = Enum.Font.GothamBold
    iconLabel.TextSize = 16
    iconLabel.Parent = btn
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Name = "Text"
    textLabel.Size = UDim2.new(1, -70, 1, 0)
    textLabel.Position = UDim2.new(0, 28, 0, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = text
    textLabel.TextColor3 = Color3.fromRGB(230, 230, 250)
    textLabel.Font = Enum.Font.Gotham
    textLabel.TextSize = 13
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.Parent = btn
    
    local bindBtn = nil
    if hasBind then
        bindBtn = Instance.new("TextButton")
        bindBtn.Name = "Bind"
        bindBtn.Size = UDim2.new(0, 30, 0, 22)
        bindBtn.Position = UDim2.new(1, -35, 0.5, -11)
        bindBtn.BackgroundColor3 = Color3.fromRGB(65, 68, 80)
        bindBtn.Text = Settings.CameraBind or "B"
        bindBtn.TextColor3 = Color3.fromRGB(200, 210, 255)
        bindBtn.Font = Enum.Font.GothamBold
        bindBtn.TextSize = 12
        bindBtn.AutoButtonColor = false
        bindBtn.Parent = btn
        
        local bindCorner = Instance.new("UICorner")
        bindCorner.CornerRadius = UDim.new(0, 4)
        bindCorner.Parent = bindBtn
    end
    
    btn.MouseEnter:Connect(function()
        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local goal = {BackgroundColor3 = Color3.fromRGB(55, 58, 70)}
        local tween = TweenService:Create(btn, tweenInfo, goal)
        tween:Play()
    end)
    
    btn.MouseLeave:Connect(function()
        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local goal = {BackgroundColor3 = Color3.fromRGB(45, 48, 58)}
        local tween = TweenService:Create(btn, tweenInfo, goal)
        tween:Play()
    end)
    
    if name == "CameraButton" then
        setupCameraButton(btn, bindBtn)
    elseif name == "NoSoundClone" then
        setupNoSoundCloneButton(btn)
    end
    
    return btn
end

local function createToggle(name, text, icon, row)
    local yPos = (row - 1) * 40
    
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Name = name.."Frame"
    toggleFrame.Size = UDim2.new(1, 0, 0, 32)
    toggleFrame.Position = UDim2.new(0, 0, 0, yPos)
    toggleFrame.BackgroundColor3 = Color3.fromRGB(45, 48, 58)
    toggleFrame.Parent = container
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 6)
    toggleCorner.Parent = toggleFrame
    
    local iconLabel = Instance.new("TextLabel")
    iconLabel.Name = "Icon"
    iconLabel.Size = UDim2.new(0, 24, 1, 0)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Text = icon
    iconLabel.TextColor3 = Color3.fromRGB(170, 180, 255)
    iconLabel.Font = Enum.Font.GothamBold
    iconLabel.TextSize = 16
    iconLabel.Parent = toggleFrame
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Name = "Text"
    textLabel.Size = UDim2.new(1, -70, 1, 0)
    textLabel.Position = UDim2.new(0, 28, 0, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = text
    textLabel.TextColor3 = Color3.fromRGB(230, 230, 250)
    textLabel.Font = Enum.Font.Gotham
    textLabel.TextSize = 13
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.Parent = toggleFrame
    
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Name = "Toggle"
    toggleBtn.Size = UDim2.new(0, 40, 0, 20)
    toggleBtn.Position = UDim2.new(1, -45, 0.5, -10)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(100, 105, 120)
    toggleBtn.Text = ""
    toggleBtn.AutoButtonColor = false
    toggleBtn.Parent = toggleFrame
    
    local toggleCorner2 = Instance.new("UICorner")
    toggleCorner2.CornerRadius = UDim.new(1, 0)
    toggleCorner2.Parent = toggleBtn
    
    local circle = Instance.new("Frame")
    circle.Name = "Circle"
    circle.Size = UDim2.new(0, 16, 0, 16)
    circle.Position = UDim2.new(0, 2, 0.5, -8)
    circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    circle.BorderSizePixel = 0
    circle.Parent = toggleBtn
    
    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(1, 0)
    circleCorner.Parent = circle
    
    toggleFrame.MouseEnter:Connect(function()
        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local goal = {BackgroundColor3 = Color3.fromRGB(55, 58, 70)}
        local tween = TweenService:Create(toggleFrame, tweenInfo, goal)
        tween:Play()
    end)
    
    toggleFrame.MouseLeave:Connect(function()
        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local goal = {BackgroundColor3 = Color3.fromRGB(45, 48, 58)}
        local tween = TweenService:Create(toggleFrame, tweenInfo, goal)
        tween:Play()
    end)
    
    return toggleFrame
end

if container then
    createButton("CameraButton", "Camera", "📷", 1, true)
    createButton("NoSoundClone", "No Sound Clone", "🔇", 2, false)
    
    local autoFlashFrame = createToggle("AutoUseFlash", "Auto Use Flash", "⚡", 3)
    setupAutoUseFlashToggle(autoFlashFrame)
    
    flashSliderFrame = createSlider()
    
    xrayToggle = createToggle("Xray", "Xray", "👁️", 4)
    setupXrayToggle(xrayToggle)
    
    autoKickToggle = createToggle("AutoKick", "Auto Kick", "🦵", 5)
    setupAutoKickToggle(autoKickToggle)
    
    if Settings.AutoFlashEnabled then
        xrayToggle.Position = UDim2.new(0, 0, 0, 170)
        autoKickToggle.Position = UDim2.new(0, 0, 0, 210)
    else
        xrayToggle.Position = UDim2.new(0, 0, 0, 120)
        autoKickToggle.Position = UDim2.new(0, 0, 0, 160)
    end
end

local minimized = false

local function minimize()
    minimized = true
    container.Visible = false
    
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local goal = {Size = UDim2.new(0, 240, 0, 35)}
    local tween = TweenService:Create(mainFrame, tweenInfo, goal)
    tween:Play()
    
    tween.Completed:Connect(function()
        minimizedFrame.Visible = true
    end)
end

local function maximize()
    minimized = false
    minimizedFrame.Visible = false
    
    local newHeight = Settings.AutoFlashEnabled and EXPANDED_HEIGHT or NORMAL_HEIGHT
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local goal = {Size = UDim2.new(0, 240, 0, newHeight)}
    local tween = TweenService:Create(mainFrame, tweenInfo, goal)
    tween:Play()
    
    local posGoal = {Position = UDim2.new(0.5, -120, 0.5, -newHeight/2)}
    local posTween = TweenService:Create(mainFrame, tweenInfo, posGoal)
    posTween:Play()
    
    tween.Completed:Connect(function()
        container.Visible = true
    end)
end

if minimizeBtn and minimizeBtn2 then
    minimizeBtn.MouseButton1Click:Connect(minimize)
    minimizeBtn2.MouseButton1Click:Connect(maximize)
    
    minimizeBtn.MouseEnter:Connect(function()
        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local goal = {BackgroundColor3 = Color3.fromRGB(75, 78, 90)}
        local tween = TweenService:Create(minimizeBtn, tweenInfo, goal)
        tween:Play()
    end)
    
    minimizeBtn.MouseLeave:Connect(function()
        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local goal = {BackgroundColor3 = Color3.fromRGB(55, 58, 68)}
        local tween = TweenService:Create(minimizeBtn, tweenInfo, goal)
        tween:Play()
    end)
    
    minimizeBtn2.MouseEnter:Connect(function()
        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local goal = {BackgroundColor3 = Color3.fromRGB(75, 78, 90)}
        local tween = TweenService:Create(minimizeBtn2, tweenInfo, goal)
        tween:Play()
    end)
    
    minimizeBtn2.MouseLeave:Connect(function()
        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local goal = {BackgroundColor3 = Color3.fromRGB(55, 58, 68)}
        local tween = TweenService:Create(minimizeBtn2, tweenInfo, goal)
        tween:Play()
    end)
end

gui.Destroying:Connect(function()
    if cameraConnection then
        cameraConnection:Disconnect()
    end
    if xrayConnection then
        xrayConnection:Disconnect()
    end
    for _, conn in ipairs(autoKickConnections) do
        pcall(function() conn:Disconnect() end)
    end
end)

task.spawn(function()
    task.wait(0.5)
    
    if Settings.AutoKickEnabled then
        pcall(enableAutoKick)
    end
    
    if Settings.XrayEnabled then
        pcall(enableXray)
        if not xrayConnection then
            xrayConnection = RunService.Heartbeat:Connect(function()
                local currentTime = tick()
                
                if currentTime - lastUpdate >= 0.01 then
                    lastUpdate = currentTime
                    
                    if xrayEnabled then
                        local parts = getAllParts()
                        
                        pcall(function()
                            for _, part in ipairs(parts) do
                                if part and part.Parent then
                                    part.Transparency = 0.95
                                end
                            end
                        end)
                    end
                end
            end)
        end
    end
end)
