local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ProximityPromptService = game:GetService("ProximityPromptService")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer

local ConfigName = "rbxlxcfgsave.json"
local defaultConfig = {
    cameraBind = "B",
    autoFlashEnabled = false
}

local Settings = {
    CameraBind = "B",
    AutoFlashEnabled = false
}

local function SaveConfig()
    local data = {
        CameraBind = Settings.CameraBind,
        AutoFlashEnabled = Settings.AutoFlashEnabled
    }
   
    local success, json = pcall(function() return HttpService:JSONEncode(data) end)
    if success then
        if writefile then
            writefile(ConfigName, json)
        end
    end
end

local function LoadConfig()
    if not isfile or not readfile then return end
    if isfile(ConfigName) then
        local content = readfile(ConfigName)
        local success, result = pcall(function() return HttpService:JSONDecode(content) end)
       
        if success and result then
            if result.CameraBind then Settings.CameraBind = result.CameraBind end
            if result.AutoFlashEnabled ~= nil then Settings.AutoFlashEnabled = result.AutoFlashEnabled end
        end
    end
end

LoadConfig()

local gui = Instance.new("ScreenGui")
gui.Name = "RbxlxHub"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 240, 0, 180)
mainFrame.Position = UDim2.new(0.5, -120, 0.5, -90)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 27, 33)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = gui
mainFrame.Active = true
mainFrame.Draggable = true

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

local cameraBind = Settings.CameraBind
local cameraConnection = nil

local function setupCameraButton(btn, bindBtn)
    local camera = workspace.CurrentCamera
    
    local function activateCamera()
        local pos = camera.CFrame.Position
        local lookVector = camera.CFrame.LookVector
        local horizontalDir = Vector3.new(lookVector.X, 0, lookVector.Z).Unit
        
        if horizontalDir.Magnitude > 0 then
            local lookAtPoint = pos + horizontalDir * 100 + Vector3.new(0, 80, 0)
            local targetCFrame = CFrame.lookAt(pos, lookAtPoint)
            camera.CFrame = targetCFrame
        end
        
        btn.BackgroundColor3 = Color3.fromRGB(70, 80, 120)
        task.wait(0.1)
        btn.BackgroundColor3 = Color3.fromRGB(45, 48, 58)
    end
    
    btn.MouseButton1Click:Connect(activateCamera)
    
    if bindBtn then
        bindBtn.Text = cameraBind
        
        bindBtn.MouseButton1Click:Connect(function()
            bindBtn.Text = "..."
            bindBtn.BackgroundColor3 = Color3.fromRGB(90, 100, 150)
            
            local connection
            connection = UserInputService.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Keyboard then
                    cameraBind = tostring(input.KeyCode):gsub("Enum.KeyCode.", "")
                    bindBtn.Text = cameraBind
                    bindBtn.BackgroundColor3 = Color3.fromRGB(65, 68, 80)
                    
                    Settings.CameraBind = cameraBind
                    SaveConfig()
                    
                    connection:Disconnect()
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
    btn.MouseButton1Click:Connect(function()
        local function useQuantumCloner()
            pcall(function()
                local char = player.Character
                if not char then return end
                
                local humanoid = char:FindFirstChild("Humanoid")
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
                    
                    btn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
                    task.wait(0.2)
                    btn.BackgroundColor3 = Color3.fromRGB(45, 48, 58)
                    
                    task.wait(0.0001)
                    game:Shutdown()
                    return true
                else
                    btn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
                    task.wait(0.2)
                    btn.BackgroundColor3 = Color3.fromRGB(45, 48, 58)
                    return false
                end
            end)
        end
        
        useQuantumCloner()
    end)
end

local function setupAutoUseFlashToggle(toggleFrame)
    local toggleBtn = toggleFrame:FindFirstChild("Toggle")
    local circle = toggleBtn:FindFirstChild("Circle")
    local state = Settings.AutoFlashEnabled
    local flashConnection = nil
    local holdConnection = nil
    
    local function useFlashTeleport()
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
        
        pcall(function()
            tool:Activate()
        end)
    end
    
    if state then
        toggleBtn.BackgroundColor3 = Color3.fromRGB(90, 140, 255)
        circle.Position = UDim2.new(1, -18, 0.5, -8)
        
        local startTime = 0
        local duration = 1
        local used = false
        local holding = false
        
        flashConnection = ProximityPromptService.PromptButtonHoldBegan:Connect(function(prompt, plr)
            if plr ~= player then return end
            holding = true
            used = false
            startTime = os.clock()
            duration = prompt.HoldDuration or 1
            
            task.spawn(function()
                while holding do
                    if player:GetAttribute("Stealing") then break end
                    
                    local progress = (os.clock() - startTime) / duration
                    if progress >= 0.91 and not used then
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
    
    toggleBtn.MouseButton1Click:Connect(function()
        state = not state
        if state then
            toggleBtn.BackgroundColor3 = Color3.fromRGB(90, 140, 255)
            circle.Position = UDim2.new(1, -18, 0.5, -8)
            
            local startTime = 0
            local duration = 1
            local used = false
            local holding = false
            
            flashConnection = ProximityPromptService.PromptButtonHoldBegan:Connect(function(prompt, plr)
                if plr ~= player then return end
                holding = true
                used = false
                startTime = os.clock()
                duration = prompt.HoldDuration or 1
                
                task.spawn(function()
                    while holding do
                        if player:GetAttribute("Stealing") then break end
                        
                        local progress = (os.clock() - startTime) / duration
                        if progress >= 0.91 and not used then
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
            
        else
            toggleBtn.BackgroundColor3 = Color3.fromRGB(100, 105, 120)
            circle.Position = UDim2.new(0, 2, 0.5, -8)
            
            if flashConnection then
                flashConnection:Disconnect()
                flashConnection = nil
            end
            if holdConnection then
                holdConnection:Disconnect()
                holdConnection = nil
            end
        end
        
        Settings.AutoFlashEnabled = state
        SaveConfig()
    end)
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
		bindBtn.Text = "B"
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
		btn.BackgroundColor3 = Color3.fromRGB(55, 58, 70)
	end)
	
	btn.MouseLeave:Connect(function()
		btn.BackgroundColor3 = Color3.fromRGB(45, 48, 58)
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
		toggleFrame.BackgroundColor3 = Color3.fromRGB(55, 58, 70)
	end)
	
	toggleFrame.MouseLeave:Connect(function()
		toggleFrame.BackgroundColor3 = Color3.fromRGB(45, 48, 58)
	end)
	
	if name == "AutoUseFlash" then
		setupAutoUseFlashToggle(toggleFrame)
	end
	
	return toggleFrame
end

createButton("CameraButton", "Camera", "📷", 1, true)
createButton("NoSoundClone", "No Sound Clone", "🔇", 2, false)
createToggle("AutoUseFlash", "Auto Use Flash", "⚡", 3)

local minimized = false

local function minimize()
	minimized = true
	mainFrame.Size = UDim2.new(0, 240, 0, 35)
	container.Visible = false
	minimizedFrame.Visible = true
end

local function maximize()
	minimized = false
	mainFrame.Size = UDim2.new(0, 240, 0, 180)
	container.Visible = true
	minimizedFrame.Visible = false
end

minimizeBtn.MouseButton1Click:Connect(minimize)
minimizeBtn2.MouseButton1Click:Connect(maximize)

minimizeBtn.MouseEnter:Connect(function()
	minimizeBtn.BackgroundColor3 = Color3.fromRGB(75, 78, 90)
end)

minimizeBtn.MouseLeave:Connect(function()
	minimizeBtn.BackgroundColor3 = Color3.fromRGB(55, 58, 68)
end)

minimizeBtn2.MouseEnter:Connect(function()
	minimizeBtn2.BackgroundColor3 = Color3.fromRGB(75, 78, 90)
end)

minimizeBtn2.MouseLeave:Connect(function()
	minimizeBtn2.BackgroundColor3 = Color3.fromRGB(55, 58, 68)
end)

gui.Destroying:Connect(function()
    if cameraConnection then
        cameraConnection:Disconnect()
    end
end)
