local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Camera = game.Workspace.CurrentCamera
local TweenService = game:GetService("TweenService")

-- Drawing API для FOV-круга
local Drawing = loadstring(game:HttpGet("https://raw.githubusercontent.com/Roblox/Core-Scripts/master/CorePackages/Drawing.lua")) or Drawing

-- Настройки
local settings = {
    guiColor = Color3.fromRGB(255, 100, 100),
    fontSize = 16,
    thirdPersonDistance = 10,
    worldColor = Color3.fromRGB(255, 255, 255), -- Цвет объектов мира
    ambientColor = Color3.fromRGB(128, 128, 128), -- Ambient
    brightness = 1, -- Яркость
    fogStart = 0, -- Начало тумана
    fogEnd = 1000, -- Конец тумана
    antiAimSpeed = 1, -- Скорость Anti-Aim
    antiAimOffset = 0 -- Смещение Anti-Aim
}

-- Флаги и переменные
local espEnabled = false
local aimbotEnabled = false
local teamCheckEnabled = false
local crosshairEnabled = false
local speedHackEnabled = false
local bunnyhopEnabled = false
local antiAimEnabled = false
local wallbangEnabled = false
local noRecoilEnabled = false
local flyEnabled = false
local infiniteJumpEnabled = false
local infiniteAmmoEnabled = false
local fastShotEnabled = false
local fastRoundEnabled = false
local optimizationEnabled = false
local thirdPersonEnabled = false
local wallCheckEnabled = false
local tracerEnabled = false
local triggerbotEnabled = false
local autoReloadEnabled = false
local silentAimEnabled = false
local bulletTracerEnabled = false
local tpKillEnabled = false
local massKillEnabled = false
local crashServerEnabled = false

local espMode = "Box"
local boxESPColor = Color3.fromRGB(0, 255, 0)
local aimbotMode = "Legit"
local aimbotFOV = 200
local aimbotSmoothing = 0.10
local aimbotBone = "Head"
local boostedSpeed = 50
local defaultSpeed = 16
local fovCircleEnabled = false
local lastTriggerTime = 0
local lockedTarget = nil
local lastBhop = 0
local bhopDelay = 0.05
local espObjects = {}
local defaultCameraOffset = Vector3.new(0, 0, 0)
local addons = {}
local lastJumpTime = 0
local jumpCooldown = 0.2
local antiAimYaw = "Spin" -- Spin, Static, Jitter, FakeLag, Reverse
local antiAimPitch = "Down" -- Up, Down, Random, JitterPitch, FakeUp
local antiAimRandom = true
local antiAimSpeed = 1
local antiAimOffset = 0

-- Drawing API для незакрашенного FOV-круга
local fovCircleDrawing = Drawing.new("Circle")
fovCircleDrawing.Visible = false
fovCircleDrawing.Radius = aimbotFOV
fovCircleDrawing.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
fovCircleDrawing.Thickness = 2
fovCircleDrawing.Color = settings.guiColor
fovCircleDrawing.Filled = false
fovCircleDrawing.Transparency = 0.8

------------------------ СОЗДАНИЕ GUI ------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FelWareGUI"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false
ScreenGui.Enabled = false

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 450, 0, 0)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner", MainFrame)
MainCorner.CornerRadius = UDim.new(0, 15)
local MainGradient = Instance.new("UIGradient", MainFrame)
MainGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 45)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 10, 15))
})
MainGradient.Rotation = 45
local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = settings.guiColor
MainStroke.Thickness = 2
local MainShadow = Instance.new("ImageLabel", MainFrame)
MainShadow.Name = "Shadow"
MainShadow.Size = UDim2.new(1, 20, 1, 20)
MainShadow.Position = UDim2.new(0, -10, 0, -10)
MainShadow.BackgroundTransparency = 1
MainShadow.Image = "rbxassetid://1316045217"
MainShadow.ImageTransparency = 0.7
MainShadow.ZIndex = -1

local TitleLabel = Instance.new("TextLabel", MainFrame)
TitleLabel.Size = UDim2.new(1, 0, 0, 50)
TitleLabel.Position = UDim2.new(0, 0, 0, 5)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "FelWare"
TitleLabel.TextColor3 = settings.guiColor
TitleLabel.Font = Enum.Font.GothamBlack
TitleLabel.TextSize = 28
TitleLabel.TextStrokeTransparency = 0.8

local closeButton = Instance.new("TextButton", MainFrame)
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -40, 0, 10)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 18
local closeCorner = Instance.new("UICorner", closeButton)
closeCorner.CornerRadius = UDim.new(0, 8)

local TabButtonsFrame = Instance.new("Frame", MainFrame)
TabButtonsFrame.Size = UDim2.new(1, -20, 0, 40)
TabButtonsFrame.Position = UDim2.new(0, 10, 0, 60)
TabButtonsFrame.BackgroundTransparency = 1

local function createTabButton(name, posX)
    local btn = Instance.new("TextButton", TabButtonsFrame)
    btn.Name = name .. "Button"
    btn.Size = UDim2.new(0, 100, 1, 0)
    btn.Position = UDim2.new(0, posX, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 18
    local btnCorner = Instance.new("UICorner", btn)
    btnCorner.CornerRadius = UDim.new(0, 10)
    local btnStroke = Instance.new("UIStroke", btn)
    btnStroke.Color = settings.guiColor
    btnStroke.Thickness = 1
    local btnGradient = Instance.new("UIGradient", btn)
    btnGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(70, 70, 75)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 40, 45))
    })
    return btn
end

local espTabButton = createTabButton("ESP", 0)
local aimbotTabButton = createTabButton("Aimbot", 110)
local miscTabButton = createTabButton("Misc", 220)
local settingsTabButton = createTabButton("Settings", 330)

local espFrame = Instance.new("Frame", MainFrame)
espFrame.Name = "ESPFrame"
espFrame.Size = UDim2.new(1, -20, 1, -120)
espFrame.Position = UDim2.new(0, 10, 0, 110)
espFrame.BackgroundTransparency = 1

local aimbotFrame = Instance.new("Frame", MainFrame)
aimbotFrame.Name = "AimbotFrame"
aimbotFrame.Size = UDim2.new(1, -20, 1, -120)
aimbotFrame.Position = UDim2.new(0, 10, 0, 110)
aimbotFrame.BackgroundTransparency = 1
aimbotFrame.Visible = false

local miscFrame = Instance.new("ScrollingFrame", MainFrame)
miscFrame.Name = "MiscFrame"
miscFrame.Size = UDim2.new(1, -20, 1, -120)
miscFrame.Position = UDim2.new(0, 10, 0, 110)
miscFrame.BackgroundTransparency = 1
miscFrame.CanvasSize = UDim2.new(0, 0, 0, 1400)
miscFrame.ScrollBarThickness = 8
miscFrame.ScrollBarImageColor3 = settings.guiColor
miscFrame.Visible = false

local settingsFrame = Instance.new("ScrollingFrame", MainFrame)
settingsFrame.Name = "SettingsFrame"
settingsFrame.Size = UDim2.new(1, -20, 1, -120)
settingsFrame.Position = UDim2.new(0, 10, 0, 110)
settingsFrame.BackgroundTransparency = 1
settingsFrame.CanvasSize = UDim2.new(0, 0, 0, 800)
settingsFrame.ScrollBarThickness = 8
settingsFrame.ScrollBarImageColor3 = settings.guiColor
settingsFrame.Visible = false

local function addListLayout(parent)
    local layout = Instance.new("UIListLayout", parent)
    layout.Padding = UDim.new(0, 8)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
end
addListLayout(espFrame)
addListLayout(aimbotFrame)
addListLayout(miscFrame)
addListLayout(settingsFrame)

local function createSettingButton(parent, text)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, -20, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(200, 200, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = settings.fontSize
    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 8)
    local btnStroke = Instance.new("UIStroke", btn)
    btnStroke.Color = settings.guiColor
    btnStroke.Thickness = 1
    local btnGradient = Instance.new("UIGradient", btn)
    btnGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 80, 85)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 50, 55))
    })
    return btn
end

-- Вкладка ESP
local espToggleButton = createSettingButton(espFrame, "ESP: OFF (E)")
local espModeButton = createSettingButton(espFrame, "ESP Mode: Box")
local espColorButton = createSettingButton(espFrame, "ESP Color: Green")
local teamCheckButton = createSettingButton(espFrame, "Team Check: OFF")
local tracerToggleButton = createSettingButton(espFrame, "Tracer ESP: OFF")

-- Вкладка Aimbot
local aimbotToggleButton = createSettingButton(aimbotFrame, "Aimbot: OFF (Q)")
local aimbotModeButton = createSettingButton(aimbotFrame, "Aimbot Mode: Legit")
local aimbotFOVButton = createSettingButton(aimbotFrame, "Aimbot FOV: 200")
local aimbotSmoothingButton = createSettingButton(aimbotFrame, "Aimbot Smoothing: 0.10")
local aimbotBoneButton = createSettingButton(aimbotFrame, "Aimbot Bone: Head")
local fovCircleToggleButton = createSettingButton(aimbotFrame, "FOV Circle: OFF")
local wallCheckToggleButton = createSettingButton(aimbotFrame, "Wall Check: OFF")
local triggerbotToggleButton = createSettingButton(aimbotFrame, "Triggerbot: OFF")
local silentAimToggleButton = createSettingButton(aimbotFrame, "Silent Aim: OFF")

-- Вкладка Misc
local crosshairToggleButton = createSettingButton(miscFrame, "Crosshair: OFF")
local speedHackToggleButton = createSettingButton(miscFrame, "Speed Hack: OFF")
local speedInput = Instance.new("TextBox", miscFrame)
speedInput.Size = UDim2.new(1, -20, 0, 35)
speedInput.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
speedInput.Text = tostring(boostedSpeed)
speedInput.TextColor3 = Color3.fromRGB(200, 200, 255)
speedInput.Font = Enum.Font.Gotham
speedInput.TextSize = settings.fontSize
speedInput.PlaceholderText = "Enter Speed (10-100)"
local speedCorner = Instance.new("UICorner", speedInput)
speedCorner.CornerRadius = UDim.new(0, 8)
local speedStroke = Instance.new("UIStroke", speedInput)
speedStroke.Color = settings.guiColor
speedStroke.Thickness = 1

local bunnyhopToggleButton = createSettingButton(miscFrame, "Bunnyhop: OFF")
local infiniteJumpToggleButton = createSettingButton(miscFrame, "Infinite Jump: OFF")
local antiAimToggleButton = createSettingButton(miscFrame, "Anti-Aim: OFF")
local antiAimYawButton = createSettingButton(miscFrame, "Anti-Aim Yaw: Spin")
local antiAimPitchButton = createSettingButton(miscFrame, "Anti-Aim Pitch: Down")
local antiAimRandomToggleButton = createSettingButton(miscFrame, "Anti-Aim Random: ON")
local antiAimSpeedButton = createSettingButton(miscFrame, "Anti-Aim Speed: 1")
local antiAimOffsetButton = createSettingButton(miscFrame, "Anti-Aim Offset: 0")
local wallbangToggleButton = createSettingButton(miscFrame, "Wallbang: OFF")
local noRecoilToggleButton = createSettingButton(miscFrame, "No Recoil: OFF")
local flyToggleButton = createSettingButton(miscFrame, "Fly: OFF")
local infiniteAmmoToggleButton = createSettingButton(miscFrame, "Infinite Ammo: OFF")
local fastShotToggleButton = createSettingButton(miscFrame, "Fast Shot: OFF")
local fastRoundToggleButton = createSettingButton(miscFrame, "Fast Round: OFF")
local optimizationToggleButton = createSettingButton(miscFrame, "Optimization: OFF")
local thirdPersonToggleButton = createSettingButton(miscFrame, "Third Person: OFF")
local autoReloadToggleButton = createSettingButton(miscFrame, "Auto Reload: OFF")
local bulletTracerToggleButton = createSettingButton(miscFrame, "Bullet Tracer: OFF")
local rageKillAuraToggleButton = createSettingButton(miscFrame, "[Rage] Kill Aura: OFF")
local rageRapidFireToggleButton = createSettingButton(miscFrame, "[Rage] Rapid Fire: OFF")
local legitSmoothReloadToggleButton = createSettingButton(miscFrame, "[Legit] Smooth Reload: OFF")
local legitFOVBoostToggleButton = createSettingButton(miscFrame, "[Legit] FOV Boost: OFF")
local tpKillToggleButton = createSettingButton(miscFrame, "[Rage] TP Kill: OFF")
local massKillToggleButton = createSettingButton(miscFrame, "[Rage] Mass Kill: OFF")
local crashServerToggleButton = createSettingButton(miscFrame, "[Rage] Crash Server: OFF")

-- Вкладка Settings
local guiColorButton = createSettingButton(settingsFrame, "GUI Color: Red")
local fontSizeButton = createSettingButton(settingsFrame, "Font Size: " .. settings.fontSize)
local thirdPersonDistButton = createSettingButton(settingsFrame, "Third Person Distance: " .. settings.thirdPersonDistance)
local worldColorButton = createSettingButton(settingsFrame, "World Color: White")
local ambientColorButton = createSettingButton(settingsFrame, "Ambient: Gray")
local brightnessButton = createSettingButton(settingsFrame, "Brightness: 1")
local fogStartButton = createSettingButton(settingsFrame, "Fog Start: 0")
local fogEndButton = createSettingButton(settingsFrame, "Fog End: 1000")

-- Анимация GUI
local openTween = TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = UDim2.new(0, 450, 0, 500)})
local closeTween = TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = UDim2.new(0, 450, 0, 0)})
closeButton.MouseButton1Click:Connect(function()
    closeTween:Play()
    wait(0.3)
    ScreenGui.Enabled = false
end)

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.N then
        if ScreenGui.Enabled then
            closeTween:Play()
            wait(0.3)
            ScreenGui.Enabled = false
        else
            ScreenGui.Enabled = true
            openTween:Play()
        end
    end
end)

-- Переключение вкладок
espTabButton.MouseButton1Click:Connect(function()
    espFrame.Visible = true
    aimbotFrame.Visible = false
    miscFrame.Visible = false
    settingsFrame.Visible = false
end)
aimbotTabButton.MouseButton1Click:Connect(function()
    espFrame.Visible = false
    aimbotFrame.Visible = true
    miscFrame.Visible = false
    settingsFrame.Visible = false
end)
miscTabButton.MouseButton1Click:Connect(function()
    espFrame.Visible = false
    aimbotFrame.Visible = false
    miscFrame.Visible = true
    settingsFrame.Visible = false
end)
settingsTabButton.MouseButton1Click:Connect(function()
    espFrame.Visible = false
    aimbotFrame.Visible = false
    miscFrame.Visible = false
    settingsFrame.Visible = true
end)

------------------------ ОБРАБОТЧИКИ GUI ------------------------
espToggleButton.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    espToggleButton.Text = "ESP: " .. (espEnabled and "ON" or "OFF") .. " (E)"
    if not espEnabled then
        for _, obj in pairs(espObjects) do
            for _, gui in pairs(obj) do
                if gui then gui:Destroy() end
            end
        end
        espObjects = {}
    end
end)

espModeButton.MouseButton1Click:Connect(function()
    espMode = (espMode == "Box") and "Highlight" or "Box"
    espModeButton.Text = "ESP Mode: " .. espMode
    for _, obj in pairs(espObjects) do
        for _, gui in pairs(obj) do
            if gui then gui:Destroy() end
        end
    end
    espObjects = {}
end)

local colorPresets = {
    {name = "Green", color = Color3.fromRGB(0, 255, 0)},
    {name = "Red", color = Color3.fromRGB(255, 0, 0)},
    {name = "Blue", color = Color3.fromRGB(0, 0, 255)},
    {name = "Yellow", color = Color3.fromRGB(255, 255, 0)}
}
local currentColorIndex = 1
espColorButton.MouseButton1Click:Connect(function()
    currentColorIndex = (currentColorIndex % #colorPresets) + 1
    local preset = colorPresets[currentColorIndex]
    boxESPColor = preset.color
    espColorButton.Text = "ESP Color: " .. preset.name
end)

teamCheckButton.MouseButton1Click:Connect(function()
    teamCheckEnabled = not teamCheckEnabled
    teamCheckButton.Text = "Team Check: " .. (teamCheckEnabled and "ON" or "OFF")
    if espEnabled then
        for _, obj in pairs(espObjects) do
            for _, gui in pairs(obj) do
                if gui then gui:Destroy() end
            end
        end
        espObjects = {}
    end
end)

tracerToggleButton.MouseButton1Click:Connect(function()
    tracerEnabled = not tracerEnabled
    tracerToggleButton.Text = "Tracer ESP: " .. (tracerEnabled and "ON" or "OFF")
    if tracerEnabled and addons["TracerESP"] then addons["TracerESP"]() end
end)

aimbotToggleButton.MouseButton1Click:Connect(function()
    aimbotEnabled = not aimbotEnabled
    aimbotToggleButton.Text = "Aimbot: " .. (aimbotEnabled and "ON" or "OFF") .. " (Q)"
end)

aimbotModeButton.MouseButton1Click:Connect(function()
    if aimbotMode == "Legit" then
        aimbotMode = "Rage"
    elseif aimbotMode == "Rage" then
        aimbotMode = "Triggerbot"
    else
        aimbotMode = "Legit"
    end
    aimbotModeButton.Text = "Aimbot Mode: " .. aimbotMode
end)

aimbotFOVButton.MouseButton1Click:Connect(function()
    aimbotFOV = aimbotFOV + 50
    if aimbotFOV > 500 then aimbotFOV = 50 end
    aimbotFOVButton.Text = "Aimbot FOV: " .. aimbotFOV
end)

aimbotSmoothingButton.MouseButton1Click:Connect(function()
    aimbotSmoothing = aimbotSmoothing + 0.05
    if aimbotSmoothing > 1 then aimbotSmoothing = 0.05 end
    aimbotSmoothingButton.Text = "Aimbot Smoothing: " .. string.format("%.2f", aimbotSmoothing)
end)

aimbotBoneButton.MouseButton1Click:Connect(function()
    if aimbotBone == "Head" then
        aimbotBone = "Torso"
    elseif aimbotBone == "Torso" then
        aimbotBone = "Random"
    else
        aimbotBone = "Head"
    end
    aimbotBoneButton.Text = "Aimbot Bone: " .. aimbotBone
end)

fovCircleToggleButton.MouseButton1Click:Connect(function()
    fovCircleEnabled = not fovCircleEnabled
    fovCircleToggleButton.Text = "FOV Circle: " .. (fovCircleEnabled and "ON" or "OFF")
end)

wallCheckToggleButton.MouseButton1Click:Connect(function()
    wallCheckEnabled = not wallCheckEnabled
    wallCheckToggleButton.Text = "Wall Check: " .. (wallCheckEnabled and "ON" or "OFF")
end)

triggerbotToggleButton.MouseButton1Click:Connect(function()
    triggerbotEnabled = not triggerbotEnabled
    triggerbotToggleButton.Text = "Triggerbot: " .. (triggerbotEnabled and "ON" or "OFF")
end)

silentAimToggleButton.MouseButton1Click:Connect(function()
    silentAimEnabled = not silentAimEnabled
    silentAimToggleButton.Text = "Silent Aim: " .. (silentAimEnabled and "ON" or "OFF")
end)

crosshairToggleButton.MouseButton1Click:Connect(function()
    crosshairEnabled = not crosshairEnabled
    crosshairToggleButton.Text = "Crosshair: " .. (crosshairEnabled and "ON" or "OFF")
    if crosshairEnabled then createCrosshair() else removeCrosshair() end
end)

speedHackToggleButton.MouseButton1Click:Connect(function()
    speedHackEnabled = not speedHackEnabled
    speedHackToggleButton.Text = "Speed Hack: " .. (speedHackEnabled and "ON" or "OFF")
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local humanoidRootPart = LocalPlayer.Character.HumanoidRootPart
        if speedHackEnabled then
            local velocity = Instance.new("BodyVelocity")
            velocity.Name = "SpeedHackVelocity"
            velocity.MaxForce = Vector3.new(math.huge, 0, math.huge)
            velocity.Velocity = Vector3.new(0, 0, 0)
            velocity.Parent = humanoidRootPart
        else
            if humanoidRootPart:FindFirstChild("SpeedHackVelocity") then
                humanoidRootPart.SpeedHackVelocity:Destroy()
            end
        end
    end
end)

speedInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local value = tonumber(speedInput.Text)
        if value and value >= 10 and value <= 100 then
            boostedSpeed = value
        else
            speedInput.Text = tostring(boostedSpeed)
        end
    end
end)

bunnyhopToggleButton.MouseButton1Click:Connect(function()
    bunnyhopEnabled = not bunnyhopEnabled
    bunnyhopToggleButton.Text = "Bunnyhop: " .. (bunnyhopEnabled and "ON" or "OFF")
end)

infiniteJumpToggleButton.MouseButton1Click:Connect(function()
    infiniteJumpEnabled = not infiniteJumpEnabled
    infiniteJumpToggleButton.Text = "Infinite Jump: " .. (infiniteJumpEnabled and "ON" or "OFF")
end)

antiAimToggleButton.MouseButton1Click:Connect(function()
    antiAimEnabled = not antiAimEnabled
    antiAimToggleButton.Text = "Anti-Aim: " .. (antiAimEnabled and "ON" or "OFF")
end)

antiAimYawButton.MouseButton1Click:Connect(function()
    if antiAimYaw == "Spin" then
        antiAimYaw = "Static"
    elseif antiAimYaw == "Static" then
        antiAimYaw = "Jitter"
    elseif antiAimYaw == "Jitter" then
        antiAimYaw = "FakeLag"
    elseif antiAimYaw == "FakeLag" then
        antiAimYaw = "Reverse"
    else
        antiAimYaw = "Spin"
    end
    antiAimYawButton.Text = "Anti-Aim Yaw: " .. antiAimYaw
end)

antiAimPitchButton.MouseButton1Click:Connect(function()
    if antiAimPitch == "Down" then
        antiAimPitch = "Up"
    elseif antiAimPitch == "Up" then
        antiAimPitch = "Random"
    elseif antiAimPitch == "Random" then
        antiAimPitch = "JitterPitch"
    elseif antiAimPitch == "JitterPitch" then
        antiAimPitch = "FakeUp"
    else
        antiAimPitch = "Down"
    end
    antiAimPitchButton.Text = "Anti-Aim Pitch: " .. antiAimPitch
end)

antiAimRandomToggleButton.MouseButton1Click:Connect(function()
    antiAimRandom = not antiAimRandom
    antiAimRandomToggleButton.Text = "Anti-Aim Random: " .. (antiAimRandom and "ON" or "OFF")
end)

antiAimSpeedButton.MouseButton1Click:Connect(function()
    antiAimSpeed = antiAimSpeed + 0.5
    if antiAimSpeed > 5 then antiAimSpeed = 0.5 end
    antiAimSpeedButton.Text = "Anti-Aim Speed: " .. antiAimSpeed
end)

antiAimOffsetButton.MouseButton1Click:Connect(function()
    antiAimOffset = antiAimOffset + 10
    if antiAimOffset > 90 then antiAimOffset = -90 end
    antiAimOffsetButton.Text = "Anti-Aim Offset: " .. antiAimOffset
end)

wallbangToggleButton.MouseButton1Click:Connect(function()
    wallbangEnabled = not wallbangEnabled
    wallbangToggleButton.Text = "Wallbang: " .. (wallbangEnabled and "ON" or "OFF")
    if wallbangEnabled then
        for _, part in pairs(game.Workspace:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.Transparency = 0.9
                part.CanCollide = false
            end
        end
    else
        for _, part in pairs(game.Workspace:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = 0
                part.CanCollide = true
            end
        end
    end
end)

noRecoilToggleButton.MouseButton1Click:Connect(function()
    noRecoilEnabled = not noRecoilEnabled
    noRecoilToggleButton.Text = "No Recoil: " .. (noRecoilEnabled and "ON" or "OFF")
end)

flyToggleButton.MouseButton1Click:Connect(function()
    flyEnabled = not flyEnabled
    flyToggleButton.Text = "Fly: " .. (flyEnabled and "ON" or "OFF")
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local humanoidRootPart = LocalPlayer.Character.HumanoidRootPart
        if flyEnabled then
            local bv = Instance.new("BodyVelocity")
            bv.Name = "FlyVelocity"
            bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bv.Velocity = Vector3.new(0, 0, 0)
            bv.Parent = humanoidRootPart
        else
            if humanoidRootPart:FindFirstChild("FlyVelocity") then
                humanoidRootPart.FlyVelocity:Destroy()
            end
        end
    end
end)

infiniteAmmoToggleButton.MouseButton1Click:Connect(function()
    infiniteAmmoEnabled = not infiniteAmmoEnabled
    infiniteAmmoToggleButton.Text = "Infinite Ammo: " .. (infiniteAmmoEnabled and "ON" or "OFF")
end)

fastShotToggleButton.MouseButton1Click:Connect(function()
    fastShotEnabled = not fastShotEnabled
    fastShotToggleButton.Text = "Fast Shot: " .. (fastShotEnabled and "ON" or "OFF")
end)

fastRoundToggleButton.MouseButton1Click:Connect(function()
    fastRoundEnabled = not fastRoundEnabled
    fastRoundToggleButton.Text = "Fast Round: " .. (fastRoundEnabled and "ON" or "OFF")
end)

optimizationToggleButton.MouseButton1Click:Connect(function()
    optimizationEnabled = not optimizationEnabled
    optimizationToggleButton.Text = "Optimization: " .. (optimizationEnabled and "ON" or "OFF")
    if optimizationEnabled then
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 10000
        for _, part in pairs(game.Workspace:GetDescendants()) do
            if part:IsA("ParticleEmitter") or part:IsA("Smoke") or part:IsA("Fire") then
                part.Enabled = false
            end
            if part:IsA("BasePart") and not part.Parent:IsA("Model") then
                part.Material = Enum.Material.SmoothPlastic
                part.Reflectance = 0
            end
        end
    else
        Lighting.GlobalShadows = true
        Lighting.FogEnd = 1000
        for _, part in pairs(game.Workspace:GetDescendants()) do
            if part:IsA("ParticleEmitter") or part:IsA("Smoke") or part:IsA("Fire") then
                part.Enabled = true
            end
        end
    end
end)

thirdPersonToggleButton.MouseButton1Click:Connect(function()
    thirdPersonEnabled = not thirdPersonEnabled
    thirdPersonToggleButton.Text = "Third Person: " .. (thirdPersonEnabled and "ON" or "OFF")
    if thirdPersonEnabled then
        Camera.CameraType = Enum.CameraType.Scriptable
    else
        Camera.CameraType = Enum.CameraType.Custom
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.CameraOffset = defaultCameraOffset
        end
    end
end)

autoReloadToggleButton.MouseButton1Click:Connect(function()
    autoReloadEnabled = not autoReloadEnabled
    autoReloadToggleButton.Text = "Auto Reload: " .. (autoReloadEnabled and "ON" or "OFF")
end)

bulletTracerToggleButton.MouseButton1Click:Connect(function()
    bulletTracerEnabled = not bulletTracerEnabled
    bulletTracerToggleButton.Text = "Bullet Tracer: " .. (bulletTracerEnabled and "ON" or "OFF")
end)

rageKillAuraToggleButton.MouseButton1Click:Connect(function()
    killAuraEnabled = not killAuraEnabled
    rageKillAuraToggleButton.Text = "[Rage] Kill Aura: " .. (killAuraEnabled and "ON" or "OFF")
end)

rageRapidFireToggleButton.MouseButton1Click:Connect(function()
    rapidFireEnabled = not rapidFireEnabled
    rageRapidFireToggleButton.Text = "[Rage] Rapid Fire: " .. (rapidFireEnabled and "ON" or "OFF")
end)

legitSmoothReloadToggleButton.MouseButton1Click:Connect(function()
    smoothReloadEnabled = not smoothReloadEnabled
    legitSmoothReloadToggleButton.Text = "[Legit] Smooth Reload: " .. (smoothReloadEnabled and "ON" or "OFF")
end)

legitFOVBoostToggleButton.MouseButton1Click:Connect(function()
    fovBoostEnabled = not fovBoostEnabled
    legitFOVBoostToggleButton.Text = "[Legit] FOV Boost: " .. (fovBoostEnabled and "ON" or "OFF")
    if fovBoostEnabled then
        Camera.FieldOfView = 90
    else
        Camera.FieldOfView = 70
    end
end)

tpKillToggleButton.MouseButton1Click:Connect(function()
    tpKillEnabled = not tpKillEnabled
    tpKillToggleButton.Text = "[Rage] TP Kill: " .. (tpKillEnabled and "ON" or "OFF")
end)

massKillToggleButton.MouseButton1Click:Connect(function()
    massKillEnabled = not massKillEnabled
    massKillToggleButton.Text = "[Rage] Mass Kill: " .. (massKillEnabled and "ON" or "OFF")
end)

crashServerToggleButton.MouseButton1Click:Connect(function()
    crashServerEnabled = not crashServerEnabled
    crashServerToggleButton.Text = "[Rage] Crash Server: " .. (crashServerEnabled and "ON" or "OFF")
end)

guiColorButton.MouseButton1Click:Connect(function()
    local guiColorPresets = {
        {name = "Red", color = Color3.fromRGB(255, 100, 100)},
        {name = "Blue", color = Color3.fromRGB(100, 100, 255)},
        {name = "Green", color = Color3.fromRGB(100, 255, 100)},
        {name = "Purple", color = Color3.fromRGB(150, 0, 255)}
    }
    guiColorIndex = (guiColorIndex % #guiColorPresets) + 1
    settings.guiColor = guiColorPresets[guiColorIndex].color
    guiColorButton.Text = "GUI Color: " .. guiColorPresets[guiColorIndex].name
    MainStroke.Color = settings.guiColor
    miscFrame.ScrollBarImageColor3 = settings.guiColor
    settingsFrame.ScrollBarImageColor3 = settings.guiColor
    fovCircleDrawing.Color = settings.guiColor
    for _, frame in pairs({espFrame, aimbotFrame, miscFrame, settingsFrame}) do
        for _, btn in pairs(frame:GetChildren()) do
            if btn:IsA("TextButton") and btn:FindFirstChild("UIStroke") then
                btn.UIStroke.Color = settings.guiColor
            elseif btn:IsA("TextBox") and btn:FindFirstChild("UIStroke") then
                btn.UIStroke.Color = settings.guiColor
            end
        end
    end
end)

fontSizeButton.MouseButton1Click:Connect(function()
    settings.fontSize = settings.fontSize + 2
    if settings.fontSize > 24 then settings.fontSize = 12 end
    fontSizeButton.Text = "Font Size: " .. settings.fontSize
    for _, frame in pairs({espFrame, aimbotFrame, miscFrame, settingsFrame}) do
        for _, btn in pairs(frame:GetChildren()) do
            if btn:IsA("TextButton") then btn.TextSize = settings.fontSize end
            if btn:IsA("TextBox") then btn.TextSize = settings.fontSize end
        end
    end
end)

thirdPersonDistButton.MouseButton1Click:Connect(function()
    settings.thirdPersonDistance = settings.thirdPersonDistance + 2
    if settings.thirdPersonDistance > 20 then settings.thirdPersonDistance = 5 end
    thirdPersonDistButton.Text = "Third Person Distance: " .. settings.thirdPersonDistance
end)

worldColorButton.MouseButton1Click:Connect(function()
    local worldColorPresets = {
        {name = "White", color = Color3.fromRGB(255, 255, 255)},
        {name = "Red", color = Color3.fromRGB(255, 0, 0)},
        {name = "Blue", color = Color3.fromRGB(0, 0, 255)},
        {name = "Green", color = Color3.fromRGB(0, 255, 0)},
        {name = "Purple", color = Color3.fromRGB(150, 0, 255)}
    }
    worldColorIndex = (worldColorIndex % #worldColorPresets) + 1
    settings.worldColor = worldColorPresets[worldColorIndex].color
    worldColorButton.Text = "World Color: " .. worldColorPresets[worldColorIndex].name
    for _, part in pairs(game.Workspace:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Color = settings.worldColor
        end
    end
end)

ambientColorButton.MouseButton1Click:Connect(function()
    local ambientPresets = {
        {name = "Gray", color = Color3.fromRGB(128, 128, 128)},
        {name = "Dark", color = Color3.fromRGB(50, 50, 50)},
        {name = "Bright", color = Color3.fromRGB(200, 200, 200)},
        {name = "Purple", color = Color3.fromRGB(150, 0, 150)},
        {name = "Neon", color = Color3.fromRGB(0, 255, 255)}
    }
    ambientIndex = (ambientIndex % #ambientPresets) + 1
    settings.ambientColor = ambientPresets[ambientIndex].color
    ambientColorButton.Text = "Ambient: " .. ambientPresets[ambientIndex].name
    Lighting.Ambient = settings.ambientColor
end)

brightnessButton.MouseButton1Click:Connect(function()
    settings.brightness = settings.brightness + 0.5
    if settings.brightness > 3 then settings.brightness = 0 end
    brightnessButton.Text = "Brightness: " .. settings.brightness
    Lighting.Brightness = settings.brightness
end)

fogStartButton.MouseButton1Click:Connect(function()
    settings.fogStart = settings.fogStart + 50
    if settings.fogStart > 500 then settings.fogStart = 0 end
    fogStartButton.Text = "Fog Start: " .. settings.fogStart
    Lighting.FogStart = settings.fogStart
end)

fogEndButton.MouseButton1Click:Connect(function()
    settings.fogEnd = settings.fogEnd + 200
    if settings.fogEnd > 2000 then settings.fogEnd = 200 end
    fogEndButton.Text = "Fog End: " .. settings.fogEnd
    Lighting.FogEnd = settings.fogEnd
end)

------------------------ HOTKEYS ------------------------
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.E then
        espEnabled = not espEnabled
        espToggleButton.Text = "ESP: " .. (espEnabled and "ON" or "OFF") .. " (E)"
        if not espEnabled then
            for _, obj in pairs(espObjects) do
                for _, gui in pairs(obj) do
                    if gui then gui:Destroy() end
                end
            end
            espObjects = {}
        end
    elseif input.KeyCode == Enum.KeyCode.Q then
        aimbotEnabled = not aimbotEnabled
        aimbotToggleButton.Text = "Aimbot: " .. (aimbotEnabled and "ON" or "OFF") .. " (Q)"
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if thirdPersonEnabled and input.UserInputType == Enum.UserInputType.MouseWheel then
        settings.thirdPersonDistance = math.clamp(settings.thirdPersonDistance - input.Position.Z * 2, 5, 20)
        thirdPersonDistButton.Text = "Third Person Distance: " .. settings.thirdPersonDistance
    end
end)

------------------------ CROSSHAIR ФУНКЦИИ ------------------------
local crosshairUI = {}
local function createCrosshair()
    if crosshairUI.horizontal then return end
    local horizontal = Instance.new("Frame", ScreenGui)
    horizontal.Size = UDim2.new(0, 20, 0, 2)
    horizontal.Position = UDim2.new(0.5, -10, 0.5, -1)
    horizontal.BackgroundColor3 = settings.guiColor
    horizontal.BorderSizePixel = 0
    local vertical = Instance.new("Frame", ScreenGui)
    vertical.Size = UDim2.new(0, 2, 0, 20)
    vertical.Position = UDim2.new(0.5, -1, 0.5, -10)
    vertical.BackgroundColor3 = settings.guiColor
    vertical.BorderSizePixel = 0
    crosshairUI.horizontal = horizontal
    crosshairUI.vertical = vertical
end

local function removeCrosshair()
    if crosshairUI.horizontal then
        crosshairUI.horizontal:Destroy()
        crosshairUI.vertical:Destroy()
        crosshairUI = {}
    end
end

------------------------ ОСНОВНЫЕ ФУНКЦИИ ------------------------
local function updateESPForCharacter(character)
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    local targetPlayer = Players:GetPlayerFromCharacter(character)
    local isEnemy = true
    if teamCheckEnabled and targetPlayer and targetPlayer.Team == LocalPlayer.Team then
        isEnemy = false
    end

    if espMode == "Box" then
        local head = character:FindFirstChild("Head") or character.HumanoidRootPart
        local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
        if not espObjects[character] then
            espObjects[character] = {}
            local t = espObjects[character]
            local base = Instance.new("Frame")
            base.Name = "ESP_Base"
            base.Size = UDim2.new(0, 80, 0, 120)
            base.BackgroundTransparency = 0.4
            base.BorderSizePixel = 0
            local baseCorner = Instance.new("UICorner", base)
            baseCorner.CornerRadius = UDim.new(0, 8)
            local baseStroke = Instance.new("UIStroke", base)
            baseStroke.Color = Color3.fromRGB(255, 255, 255)
            baseStroke.Thickness = 2
            baseStroke.Transparency = 0.2
            t.base = base
            base.Parent = ScreenGui
            
            local glow = Instance.new("UIStroke", base)
            glow.Name = "ESP_Glow"
            glow.Thickness = 4
            glow.Color = boxESPColor
            glow.Transparency = 0.6
            
            local nameLabel = Instance.new("TextLabel")
            nameLabel.Name = "ESP_Name"
            nameLabel.Size = UDim2.new(0, 100, 0, 20)
            nameLabel.BackgroundTransparency = 1
            nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            nameLabel.TextStrokeTransparency = 0.5
            nameLabel.Font = Enum.Font.GothamBold
            nameLabel.TextSize = 16
            t.name = nameLabel
            nameLabel.Parent = ScreenGui
            
            local healthBar = Instance.new("Frame")
            healthBar.Name = "ESP_HealthBar"
            healthBar.Size = UDim2.new(0, 5, 0, 100)
            healthBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
            healthBar.BorderSizePixel = 0
            local healthCorner = Instance.new("UICorner", healthBar)
            healthCorner.CornerRadius = UDim.new(0, 4)
            t.health = healthBar
            healthBar.Parent = ScreenGui
        end
        
        local t = espObjects[character]
        if espEnabled and onScreen and isEnemy then
            t.base.Visible = true
            t.base.BackgroundColor3 = boxESPColor
            t.base.Position = UDim2.new(0, screenPos.X - t.base.Size.X.Offset/2, 0, screenPos.Y - t.base.Size.Y.Offset/2)
            
            t.name.Visible = true
            t.name.Text = character.Name
            t.name.Position = UDim2.new(0, screenPos.X - t.name.Size.X.Offset/2, 0, screenPos.Y - t.base.Size.Y.Offset/2 - 25)
            
            t.health.Visible = true
            local humanoid = character:FindFirstChild("Humanoid")
            local healthPercent = humanoid and (humanoid.Health / humanoid.MaxHealth) or 0
            t.health.Size = UDim2.new(0, 5, 0, 100 * healthPercent)
            t.health.Position = UDim2.new(0, screenPos.X - t.base.Size.X.Offset/2 - 10, 0, screenPos.Y - t.base.Size.Y.Offset/2 + (100 * (1 - healthPercent)))
            t.health.BackgroundColor3 = Color3.fromRGB(255 * (1 - healthPercent), 255 * healthPercent, 0)
        else
            if espObjects[character] then
                for _, gui in pairs(espObjects[character]) do
                    if gui then gui.Visible = false end
                end
            end
        end
        
    elseif espMode == "Highlight" then
        if espEnabled and isEnemy then
            local highlight = character:FindFirstChild("ESP_Highlight")
            if not highlight then
                highlight = Instance.new("Highlight")
                highlight.Name = "ESP_Highlight"
                highlight.FillTransparency = 0.5
                highlight.OutlineTransparency = 0
                highlight.FillColor = boxESPColor
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                highlight.Parent = character
            end
            highlight.FillColor = boxESPColor
        else
            local highlight = character:FindFirstChild("ESP_Highlight")
            if highlight then highlight:Destroy() end
        end
    end
end

local function isVisible(targetPos)
    if not wallCheckEnabled then return true end
    local origin = Camera.CFrame.Position
    local direction = (targetPos - origin).Unit * (targetPos - origin).Magnitude
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character}
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    local raycastResult = workspace:Raycast(origin, direction, raycastParams)
    return not raycastResult or raycastResult.Instance:IsDescendantOf(lockedTarget and lockedTarget.Parent)
end

local function getTargetPart(character)
    if aimbotBone == "Head" then
        return character:FindFirstChild("Head") or character.HumanoidRootPart
    elseif aimbotBone == "Torso" then
        return character.HumanoidRootPart
    else
        local parts = {character:FindFirstChild("Head"), character.HumanoidRootPart}
        return parts[math.random(1, #parts)] or character.HumanoidRootPart
    end
end

local function updateAimbot()
    if not aimbotEnabled or not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
        lockedTarget = nil
        return
    end

    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    if lockedTarget and lockedTarget.Parent and lockedTarget.Parent:FindFirstChild("Humanoid") then
        local targetScreenPos, onScreen = Camera:WorldToViewportPoint(lockedTarget.Position)
        local distToCenter = (Vector2.new(targetScreenPos.X, targetScreenPos.Y) - screenCenter).Magnitude
        if onScreen and distToCenter <= aimbotFOV and (not wallCheckEnabled or isVisible(lockedTarget.Position)) then
            local targetCFrame = CFrame.new(Camera.CFrame.Position, lockedTarget.Position)
            if aimbotMode == "Legit" then
                Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, aimbotSmoothing)
            elseif aimbotMode == "Rage" then
                Camera.CFrame = targetCFrame
            end
            return
        else
            lockedTarget = nil
        end
    end

    local closestEnemy = nil
    local shortestDistance = math.huge
    for _, obj in pairs(Players:GetPlayers()) do
        if obj ~= LocalPlayer and obj.Character and obj.Character:FindFirstChild("HumanoidRootPart") then
            if teamCheckEnabled and obj.Team == LocalPlayer.Team then continue end
            local targetPart = getTargetPart(obj.Character)
            local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
            local distToCenter = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
            local distance = (Camera.CFrame.Position - targetPart.Position).Magnitude
            if onScreen and distToCenter <= aimbotFOV and distance < shortestDistance and (not wallCheckEnabled or isVisible(targetPart.Position)) then
                closestEnemy = targetPart
                shortestDistance = distance
            end
        end
    end

    if closestEnemy then
        lockedTarget = closestEnemy
        local targetCFrame = CFrame.new(Camera.CFrame.Position, lockedTarget.Position)
        if aimbotMode == "Legit" then
            Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, aimbotSmoothing)
        elseif aimbotMode == "Rage" then
            Camera.CFrame = targetCFrame
        end
    end
end

local function updateTriggerbot()
    if triggerbotEnabled and LocalPlayer.Character then
        local mousePos = UserInputService:GetMouseLocation()
        local ray = Camera:ViewportPointToRay(mousePos.X, mousePos.Y)
        local raycastParams = RaycastParams.new()
        raycastParams.FilterDescendantsInstances = {LocalPlayer.Character}
        raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
        local raycastResult = workspace:Raycast(ray.Origin, ray.Direction * 1000, raycastParams)
        
        if raycastResult and raycastResult.Instance then
            local target = raycastResult.Instance.Parent
            local humanoid = target:FindFirstChild("Humanoid")
            local targetPlayer = Players:GetPlayerFromCharacter(target)
            if humanoid and targetPlayer and targetPlayer ~= LocalPlayer then
                if teamCheckEnabled and targetPlayer.Team == LocalPlayer.Team then return end
                if humanoid.Health > 0 then
                    local currentTime = tick()
                    if currentTime - lastTriggerTime >= 0.05 then
                        lastTriggerTime = currentTime
                        for _, tool in pairs(LocalPlayer.Character:GetChildren()) do
                            if tool:IsA("Tool") then
                                local fireEvent = tool:FindFirstChild("Fire") or tool:FindFirstChild("Shoot")
                                if fireEvent and fireEvent:IsA("RemoteEvent") then
                                    fireEvent:FireServer(raycastResult.Position)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

local function updateSilentAim()
    if silentAimEnabled and LocalPlayer.Character then
        local closestEnemy = nil
        local shortestDistance = math.huge
        for _, obj in pairs(Players:GetPlayers()) do
            if obj ~= LocalPlayer and obj.Character and obj.Character:FindFirstChild("HumanoidRootPart") then
                if teamCheckEnabled and obj.Team == LocalPlayer.Team then continue end
                local targetPart = getTargetPart(obj.Character)
                local distance = (Camera.CFrame.Position - targetPart.Position).Magnitude
                if distance < shortestDistance and (not wallCheckEnabled or isVisible(targetPart.Position)) then
                    closestEnemy = targetPart
                    shortestDistance = distance
                end
            end
        end
        if closestEnemy then
            for _, tool in pairs(LocalPlayer.Character:GetChildren()) do
                if tool:IsA("Tool") then
                    local fireEvent = tool:FindFirstChild("Fire") or tool:FindFirstChild("Shoot")
                    if fireEvent and fireEvent:IsA("RemoteEvent") then
                        fireEvent:FireServer(closestEnemy.Position + Vector3.new(math.random(-1, 1), math.random(-1, 1), math.random(-1, 1))) -- Легкая рандомизация для обхода
                    end
                end
            end
        end
    end
end

local function updateAntiAim()
    if antiAimEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
        local yawAngle = 0
        local pitchAngle = 0
        local t = tick() * antiAimSpeed

        if antiAimYaw == "Spin" then
            yawAngle = math.rad(t * 360) % 360
        elseif antiAimYaw == "Static" then
            yawAngle = math.rad(90 + antiAimOffset)
        elseif antiAimYaw == "Jitter" then
            yawAngle = math.rad(math.random(-180, 180) + antiAimOffset)
        elseif antiAimYaw == "FakeLag" then
            yawAngle = math.rad(math.sin(t * 10) * 90 + antiAimOffset)
        elseif antiAimYaw == "Reverse" then
            yawAngle = math.rad(-Camera.CFrame:ToEulerAnglesYXZ() + antiAimOffset)
        end
        if antiAimRandom then
            yawAngle = yawAngle + math.rad(math.random(-10, 10))
        end

        if antiAimPitch == "Up" then
            pitchAngle = math.rad(-30 + antiAimOffset)
        elseif antiAimPitch == "Down" then
            pitchAngle = math.rad(30 + antiAimOffset)
        elseif antiAimPitch == "Random" then
            pitchAngle = math.rad(math.random(-30, 30) + antiAimOffset)
        elseif antiAimPitch == "JitterPitch" then
            pitchAngle = math.rad(math.random(-90, 90) + antiAimOffset)
        elseif antiAimPitch == "FakeUp" then
            pitchAngle = math.rad(-90 + math.sin(t * 5) * 45 + antiAimOffset)
        end
        if antiAimRandom then
            pitchAngle = pitchAngle + math.rad(math.random(-5, 5))
        end

        local baseCFrame = CFrame.new(hrp.Position)
        hrp.CFrame = baseCFrame * CFrame.Angles(pitchAngle, yawAngle, 0)
        if humanoid then
            humanoid.PlatformStand = false
        end
    end
end

local function updateBunnyhop()
    if bunnyhopEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        local humanoid = LocalPlayer.Character.Humanoid
        local hrp = LocalPlayer.Character.HumanoidRootPart
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            local currentTime = tick()
            local state = humanoid:GetState()
            if state == Enum.HumanoidStateType.Landed and (currentTime - lastBhop >= bhopDelay) then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                local moveDirection = humanoid.MoveDirection
                if moveDirection.Magnitude > 0 then
                    local velocity = Instance.new("BodyVelocity")
                    velocity.MaxForce = Vector3.new(10000, 0, 10000)
                    velocity.Velocity = moveDirection * boostedSpeed
                    velocity.Parent = hrp
                    game.Debris:AddItem(velocity, 0.1)
                end
                lastBhop = currentTime
            end
        end
    end
end

local function updateInfiniteJump()
    if infiniteJumpEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        local currentTime = tick()
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) and (currentTime - lastJumpTime >= jumpCooldown) then
            LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            lastJumpTime = currentTime
        end
    end
end

local function updateNoRecoil()
    if noRecoilEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        Camera.CFrame = Camera.CFrame * CFrame.Angles(0, 0, 0)
    end
end

local function updateInfiniteAmmo()
    if infiniteAmmoEnabled and LocalPlayer.Character then
        for _, tool in pairs(LocalPlayer.Character:GetChildren()) do
            if tool:IsA("Tool") then
                local ammo = tool:FindFirstChild("Ammo") or tool:FindFirstChild("Clip")
                if ammo then
                    ammo.Value = 9999
                end
            end
        end
        for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
            if tool:IsA("Tool") then
                local ammo = tool:FindFirstChild("Ammo") or tool:FindFirstChild("Clip")
                if ammo then
                    ammo.Value = 9999
                end
            end
        end
    end
end

local function updateFastShot()
    if fastShotEnabled and LocalPlayer.Character then
        for _, tool in pairs(LocalPlayer.Character:GetChildren()) do
            if tool:IsA("Tool") then
                local fireRate = tool:FindFirstChild("FireRate") or tool:FindFirstChild("Rate")
                if fireRate then
                    fireRate.Value = 0.01 -- Максимальная скорострельность
                end
                for _, anim in pairs(tool:GetDescendants()) do
                    if anim:IsA("Animation") then
                        local animTrack = LocalPlayer.Character.Humanoid:LoadAnimation(anim)
                        animTrack:AdjustSpeed(5)
                    end
                end
            end
        end
    end
end

local function updateFastRound()
    if fastRoundEnabled then
        local roundTime = game.Workspace:FindFirstChild("RoundTime") or game.ReplicatedStorage:FindFirstChild("RoundTime")
        if roundTime and roundTime:IsA("IntValue") then
            roundTime.Value = 1 -- Ускорение раунда
        end
    end
end

local function updateAutoReload()
    if autoReloadEnabled and LocalPlayer.Character then
        for _, tool in pairs(LocalPlayer.Character:GetChildren()) do
            if tool:IsA("Tool") then
                local ammo = tool:FindFirstChild("Ammo") or tool:FindFirstChild("Clip")
                if ammo and ammo.Value <= 0 then
                    local reloadEvent = tool:FindFirstChild("Reload")
                    if reloadEvent and reloadEvent:IsA("RemoteEvent") then
                        reloadEvent:FireServer()
                    end
                end
            end
        end
    end
end

local function updateSpeedHack()
    if speedHackEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local humanoidRootPart = LocalPlayer.Character.HumanoidRootPart
        local velocity = humanoidRootPart:FindFirstChild("SpeedHackVelocity")
        if velocity then
            local moveDirection = LocalPlayer.Character.Humanoid.MoveDirection * boostedSpeed
            velocity.Velocity = Vector3.new(moveDirection.X, 0, moveDirection.Z)
        end
    end
end

local function updateFly()
    if flyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local humanoidRootPart = LocalPlayer.Character.HumanoidRootPart
        local bv = humanoidRootPart:FindFirstChild("FlyVelocity")
        if bv then
            local direction = Vector3.new(0, 0, 0)
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                direction = direction + Vector3.new(0, 50, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                direction = direction - Vector3.new(0, 50, 0)
            end
            direction = direction + (Camera.CFrame.LookVector * LocalPlayer.Character.Humanoid.MoveDirection.Magnitude * 50)
            bv.Velocity = direction
        end
    end
end

local function updateThirdPerson()
    if thirdPersonEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        local head = LocalPlayer.Character:FindFirstChild("Head")
        local camPos = hrp.Position - (Camera.CFrame.LookVector * settings.thirdPersonDistance) + Vector3.new(0, 3, 0)
        local lookAt = head and head.Position or hrp.Position
        Camera.CFrame = CFrame.new(camPos, lookAt)
    end
end

local function updateBulletTracer()
    if bulletTracerEnabled and LocalPlayer.Character then
        for _, tool in pairs(LocalPlayer.Character:GetChildren()) do
            if tool:IsA("Tool") and tool:FindFirstChild("Handle") then
                local fireEvent = tool:FindFirstChild("Fire") or tool:FindFirstChild("Shoot")
                if fireEvent and fireEvent:IsA("RemoteEvent") then
                    local connection
                    connection = fireEvent.OnClientEvent:Connect(function(targetPos)
                        local startPos = tool.Handle.Position
                        local tracer = Instance.new("Part")
                        tracer.Anchored = true
                        tracer.CanCollide = false
                        tracer.Size = Vector3.new(0.1, 0.1, (startPos - targetPos).Magnitude)
                        tracer.CFrame = CFrame.new(startPos, targetPos) * CFrame.new(0, 0, -(startPos - targetPos).Magnitude / 2)
                        tracer.Color = Color3.fromRGB(255, 0, 0)
                        tracer.Material = Enum.Material.Neon
                        tracer.Parent = game.Workspace
                        game.Debris:AddItem(tracer, 0.5)
                    end)
                    tool.AncestryChanged:Connect(function()
                        if not tool:IsDescendantOf(LocalPlayer.Character) then
                            connection:Disconnect()
                        end
                    end)
                end
            end
        end
    end
end

local function updateKillAura()
    if killAuraEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        for _, obj in pairs(Players:GetPlayers()) do
            if obj ~= LocalPlayer and obj.Character and obj.Character:FindFirstChild("HumanoidRootPart") then
                local targetHrp = obj.Character.HumanoidRootPart
                local distance = (hrp.Position - targetHrp.Position).Magnitude
                if distance <= 10 then
                    local humanoid = obj.Character:FindFirstChild("Humanoid")
                    if humanoid and humanoid.Health > 0 then
                        for _, tool in pairs(LocalPlayer.Character:GetChildren()) do
                            if tool:IsA("Tool") then
                                local fireEvent = tool:FindFirstChild("Fire") or tool:FindFirstChild("Shoot")
                                if fireEvent and fireEvent:IsA("RemoteEvent") then
                                    fireEvent:FireServer(targetHrp.Position + Vector3.new(math.random(-1, 1), math.random(-1, 1), math.random(-1, 1)))
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

local function updateRapidFire()
    if rapidFireEnabled and LocalPlayer.Character then
        for _, tool in pairs(LocalPlayer.Character:GetChildren()) do
            if tool:IsA("Tool") then
                local fireEvent = tool:FindFirstChild("Fire") or tool:FindFirstChild("Shoot")
                if fireEvent and fireEvent:IsA("RemoteEvent") then
                    spawn(function()
                        while rapidFireEnabled and tool:IsDescendantOf(LocalPlayer.Character) do
                            fireEvent:FireServer(Camera.CFrame.Position + Camera.CFrame.LookVector * 100 + Vector3.new(math.random(-1, 1), math.random(-1, 1), math.random(-1, 1)))
                            wait(0.05)
                        end
                    end)
                end
            end
        end
    end
end

local function updateSmoothReload()
    if smoothReloadEnabled and LocalPlayer.Character then
        for _, tool in pairs(LocalPlayer.Character:GetChildren()) do
            if tool:IsA("Tool") then
                local ammo = tool:FindFirstChild("Ammo") or tool:FindFirstChild("Clip")
                if ammo and ammo.Value <= 0 then
                    local reloadEvent = tool:FindFirstChild("Reload")
                    if reloadEvent and reloadEvent:IsA("RemoteEvent") then
                        spawn(function()
                            local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
                            if humanoid then
                                humanoid.WalkSpeed = defaultSpeed * 0.8
                                reloadEvent:FireServer()
                                wait(0.5)
                                humanoid.WalkSpeed = defaultSpeed
                            end
                        end)
                    end
                end
            end
        end
    end
end

local function updateTPKill()
    if tpKillEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        for _, obj in pairs(Players:GetPlayers()) do
            if obj ~= LocalPlayer and obj.Character and obj.Character:FindFirstChild("HumanoidRootPart") then
                local targetHrp = obj.Character.HumanoidRootPart
                local humanoid = obj.Character:FindFirstChild("Humanoid")
                if humanoid and humanoid.Health > 0 then
                    hrp.CFrame = CFrame.new(targetHrp.Position + Vector3.new(math.random(-2, 2), math.random(0, 2), math.random(-2, 2)))
                    for _, tool in pairs(LocalPlayer.Character:GetChildren()) do
                        if tool:IsA("Tool") then
                            local fireEvent = tool:FindFirstChild("Fire") or tool:FindFirstChild("Shoot")
                            if fireEvent and fireEvent:IsA("RemoteEvent") then
                                fireEvent:FireServer(targetHrp.Position)
                            end
                        end
                    end
                    wait(0.1)
                end
            end
        end
    end
end

local function updateMassKill()
    if massKillEnabled and LocalPlayer.Character then
        for _, obj in pairs(Players:GetPlayers()) do
            if obj ~= LocalPlayer and obj.Character and obj.Character:FindFirstChild("HumanoidRootPart") then
                local targetHrp = obj.Character.HumanoidRootPart
                local humanoid = obj.Character:FindFirstChild("Humanoid")
                if humanoid and humanoid.Health > 0 then
                    for _, tool in pairs(LocalPlayer.Character:GetChildren()) do
                        if tool:IsA("Tool") then
                            local fireEvent = tool:FindFirstChild("Fire") or tool:FindFirstChild("Shoot")
                            if fireEvent and fireEvent:IsA("RemoteEvent") then
                                for i = 1, 50 do
                                    fireEvent:FireServer(targetHrp.Position + Vector3.new(math.random(-1, 1), math.random(-1, 1), math.random(-1, 1)))
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

local function updateCrashServer()
    if crashServerEnabled and LocalPlayer.Character then
        for _, tool in pairs(LocalPlayer.Character:GetChildren()) do
            if tool:IsA("Tool") then
                local fireEvent = tool:FindFirstChild("Fire") or tool:FindFirstChild("Shoot")
                if fireEvent and fireEvent:IsA("RemoteEvent") then
                    spawn(function()
                        while crashServerEnabled do
                            for i = 1, 1000 do
                                fireEvent:FireServer(Vector3.new(math.random(-1000, 1000), math.random(-1000, 1000), math.random(-1000, 1000)))
                            end
                            wait()
                        end
                    end)
                end
            end
        end
    end
end

------------------------ АДДОНЫ ------------------------
local function registerAddon(name, func)
    addons[name] = func
    print("Аддон загружен: " .. name)
end

registerAddon("TracerESP", function()
    local tracers = {}
    RunService.RenderStepped:Connect(function()
        for _, tracer in pairs(tracers) do tracer:Destroy() end
        tracers = {}
        if espEnabled and tracerEnabled then
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local hrp = player.Character.HumanoidRootPart
                    local screenPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                    if onScreen then
                        local tracer = Instance.new("Frame")
                        tracer.Size = UDim2.new(0, 1, 0, (Camera.ViewportSize.Y / 2 - screenPos.Y))
                        tracer.Position = UDim2.new(0, Camera.ViewportSize.X / 2, 0, Camera.ViewportSize.Y / 2)
                        tracer.BackgroundColor3 = boxESPColor
                        tracer.BorderSizePixel = 0
                        tracer.Parent = ScreenGui
                        table.insert(tracers, tracer)
                    end
                end
            end
        end
    end)
end)

------------------------ ОСНОВНОЙ ЦИКЛ ------------------------
RunService.RenderStepped:Connect(function(dt)
    local success, err = pcall(function()
        if espEnabled then
            for _, obj in pairs(Players:GetPlayers()) do
                if obj ~= LocalPlayer and obj.Character then
                    updateESPForCharacter(obj.Character)
                end
            end
        end
        updateAimbot()
        updateTriggerbot()
        updateSilentAim()
        updateAntiAim()
        updateBunnyhop()
        updateInfiniteJump()
        updateNoRecoil()
        updateInfiniteAmmo()
        updateFastShot()
        updateFastRound()
        updateAutoReload()
        updateSpeedHack()
        updateFly()
        updateThirdPerson()
        updateBulletTracer()
        updateKillAura()
        updateRapidFire()
        updateSmoothReload()
        updateTPKill()
        updateMassKill()
        updateCrashServer()
        
        fovCircleDrawing.Radius = aimbotFOV
        fovCircleDrawing.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        fovCircleDrawing.Visible = fovCircleEnabled and aimbotEnabled
    end)
    if not success then warn("Ошибка в цикле: " .. err) end
end)

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        if espEnabled then
            updateESPForCharacter(character)
        end
    end)
end)

Players.PlayerRemoving:Connect(function(player)
    if espObjects[player.Character] then
        for _, gui in pairs(espObjects[player.Character]) do
            if gui then gui:Destroy() end
        end
        espObjects[player.Character] = nil
    end
end)

print("FelWare загружен! Нажми Insert для открытия/закрытия GUI.")
