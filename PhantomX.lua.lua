local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- GUI رئيسي
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PhantomX"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local langFrame = Instance.new("Frame", screenGui)
langFrame.Size = UDim2.new(0, 220, 0, 140)
langFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
langFrame.AnchorPoint = Vector2.new(0.5, 0.5)
langFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
langFrame.BorderSizePixel = 0
Instance.new("UICorner", langFrame)

local function createButton(parent, text, posY)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0.8, 0, 0, 50)
    btn.Position = UDim2.new(0.1, 0, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 20
    btn.Text = text
    btn.AutoButtonColor = true
    Instance.new("UICorner", btn)
    return btn
end

local arabicBtn = createButton(langFrame, "عربي", 10)
local englishBtn = createButton(langFrame, "English", 70)

local function startGUI(language)
    langFrame:Destroy()

    local texts = {
        title = language == "ar" and "PhantomX\nمطور السكربت: ياسين" or "PhantomX\nScript by: Yaseen",
        setPos = language == "ar" and "تحديد الموقع" or "Set Location",
        gotoPos = language == "ar" and "تنقل للموقع" or "Teleport to Location",
        speed = language == "ar" and "السرعة" or "Speed",
        up = language == "ar" and "تنقل فوق الماب" or "Teleport above map",
        tpEnemy = language == "ar" and "الانتقال للخصم" or "Teleport to Enemy",
        noSlip = language == "ar" and "منع التزحلق ❄️" or "No Slip ❄️",
        touchFlingOn = language == "ar" and "تشغيل تطير اللعيبة" or "Enable Touch Fling",
        touchFlingOff = language == "ar" and "إيقاف تطير اللعيبة" or "Disable Touch Fling",
        close = "×"
    }

    local successMsg = Instance.new("TextLabel")
    successMsg.Size = UDim2.new(0, 250, 0, 50)
    successMsg.Position = UDim2.new(0, -260, 1, -60)
    successMsg.AnchorPoint = Vector2.new(0, 1)
    successMsg.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    successMsg.BackgroundTransparency = 0.3
    successMsg.TextColor3 = Color3.fromRGB(255, 255, 255)
    successMsg.Font = Enum.Font.GothamBold
    successMsg.TextSize = 16
    successMsg.Text = language == "ar" and "✅ تم تشغيل السكربت بنجاح" or "✅ Script started successfully"
    successMsg.Parent = screenGui
    Instance.new("UICorner", successMsg)
    TweenService:Create(successMsg, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {
        Position = UDim2.new(1, -260, 1, -60)
    }):Play()
    task.delay(5, function() successMsg:Destroy() end)

    -- الإطار الرئيسي مع Scroll
    local Frame = Instance.new("Frame", screenGui)
    Frame.Size = UDim2.new(0, 240, 0, 380)
    Frame.Position = UDim2.new(-0.5, 0, 0.3, 0)
    Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Frame.Active = true
    Frame.Draggable = true
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 10)
    Instance.new("UIStroke", Frame).Color = Color3.fromRGB(0, 170, 255)
    TweenService:Create(Frame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {
        Position = UDim2.new(0, 20, 0.3, 0)
    }):Play()

    -- ScrollFrame
    local scroll = Instance.new("ScrollingFrame", Frame)
    scroll.Size = UDim2.new(1, 0, 1, -40)
    scroll.Position = UDim2.new(0, 0, 0, 40)
    scroll.CanvasSize = UDim2.new(0, 0, 3, 0) -- 3x height to allow scrolling for many buttons
    scroll.ScrollBarThickness = 6
    scroll.BackgroundTransparency = 1

    local titleLabel = Instance.new("TextLabel", Frame)
    titleLabel.Size = UDim2.new(1, 0, 0, 40)
    titleLabel.Position = UDim2.new(0, 0, 0, 0)
    titleLabel.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    titleLabel.Text = texts.title
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 18
    titleLabel.TextWrapped = true
    titleLabel.TextYAlignment = Enum.TextYAlignment.Top
    Instance.new("UICorner", titleLabel)

    -- أزرار
    local function createButtonScroll(text, posY)
        local btn = Instance.new("TextButton", scroll)
        btn.Size = UDim2.new(0.9, 0, 0, 40)
        btn.Position = UDim2.new(0.05, 0, 0, posY)
        btn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 16
        btn.Text = text
        Instance.new("UICorner", btn)
        return btn
    end

    -- حفظ موقع
    local lastPos = nil
    local btnSet = createButtonScroll(texts.setPos, 10)
    btnSet.MouseButton1Click:Connect(function()
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if hrp then lastPos = hrp.CFrame end
    end)

    -- التنقل للموقع المحفوظ
    local btnGoto = createButtonScroll(texts.gotoPos, 60)
    btnGoto.MouseButton1Click:Connect(function()
        local character = player.Character
        if character and lastPos then
            local hrp = character:FindFirstChild("HumanoidRootPart")
            local hum = character:FindFirstChild("Humanoid")
            if hrp and hum then
                hum.PlatformStand = true
                local startPos = hrp.Position
                local endPos = lastPos.Position
                local steps = 30
                for i = 1, steps do
                    local alpha = i / steps
                    local interpPos = startPos:Lerp(endPos, alpha)
                    hrp.CFrame = CFrame.new(interpPos)
                    task.wait(0.03)
                end
                hrp.CFrame = lastPos
                task.wait(0.1)
                hum.PlatformStand = false
            end
        end
    end)

    -- مربع سرعة
    local inputBox = Instance.new("TextBox", scroll)
    inputBox.PlaceholderText = language == "ar" and "اكتب السرعة هنا (1-10)" or "Enter speed here (1-10)"
    inputBox.Size = UDim2.new(0.9, 0, 0, 30)
    inputBox.Position = UDim2.new(0.05, 0, 0, 110)
    inputBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    inputBox.TextColor3 = Color3.fromRGB(0, 0, 0)
    inputBox.Font = Enum.Font.Gotham
    inputBox.TextSize = 14
    inputBox.ClearTextOnFocus = false
    Instance.new("UICorner", inputBox)

    -- زر السرعة مع تفعيل وتعطيل
    local speedActive = false
    local speedLevel = 1
    local conn
    local btnSpeed = createButtonScroll(texts.speed, 150)
    btnSpeed.MouseButton1Click:Connect(function()
        speedActive = not speedActive
        btnSpeed.Text = speedActive and (language == "ar" and "السرعة: ON" or "Speed: ON") or texts.speed

        if speedActive then
            local input = tonumber(inputBox.Text)
            if input and input >= 1 and input <= 10 then
                speedLevel = input
            else
                speedLevel = 1
                inputBox.Text = "1"
            end
            if conn then conn:Disconnect() end
            conn = RunService.RenderStepped:Connect(function()
                local hum = player.Character and player.Character:FindFirstChild("Humanoid")
                local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                if hum and root and hum.MoveDirection.Magnitude > 0 then
                    local moveSpeed = 0
                    if speedLevel == 1 then
                        moveSpeed = 0.02
                    else
                        moveSpeed = 0.02 + (speedLevel - 2) * 0.02
                    end
                    root.CFrame = root.CFrame + hum.MoveDirection * moveSpeed
                end
            end)
        else
            if conn then conn:Disconnect() end
        end
    end)

    -- زر التنقل فوق الماب
    local btnUp = createButtonScroll(texts.up, 200)
    btnUp.MouseButton1Click:Connect(function()
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if hrp then hrp.CFrame = hrp.CFrame + Vector3.new(0, 150, 0) end
    end)

    -- دالة للتحقق من اللون الأخضر أو هايلايت
    local function isGreenOrHighlight(target)
        for _, part in pairs(target:GetDescendants()) do
            if part:IsA("BasePart") then
                local color = part.Color
                if (color.G > 0.5 and color.R < 0.5 and color.B < 0.5) then
                    return true
                end
            elseif part:IsA("Highlight") then
                local highlightColor = part.FillColor
                if highlightColor.G > 0.5 and highlightColor.R < 0.5 and highlightColor.B < 0.5 then
                    return true
                end
            end
        end
        return false
    end

    -- زر التنقل لأقرب خصم
    local btnEnemy = createButtonScroll(texts.tpEnemy, 250)
    btnEnemy.MouseButton1Click:Connect(function()
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        local nearest, dist = nil, math.huge
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") then
                local target = p.Character
                if not isGreenOrHighlight(target) and target.Humanoid.Health > 0 then
                    local d = (hrp.Position - target.HumanoidRootPart.Position).Magnitude
                    if d < dist then
                        dist = d
                        nearest = target
                    end
                end
            end
        end

        if nearest then
            local direction = (nearest.HumanoidRootPart.Position - hrp.Position).Unit
            hrp.CFrame = CFrame.new(nearest.HumanoidRootPart.Position - direction * 3, nearest.HumanoidRootPart.Position)
        end
    end)

    -- زر منع التزحلق ❄️
    local noSlipActive = false
    local modifiedParts = {}

    local btnNoSlip = createButtonScroll(texts.noSlip, 300)
    btnNoSlip.MouseButton1Click:Connect(function()
        noSlipActive = not noSlipActive
        btnNoSlip.Text = noSlipActive and (language == "ar" and "إيقاف منع التزحلق" or "Disable No Slip") or texts.noSlip

        if not noSlipActive then
            -- إعادة الخصائص الأصلية
            for part, originalProps in pairs(modifiedParts) do
                if part and part:IsA("BasePart") then
                    part.CustomPhysicalProperties = originalProps
                end
            end
            modifiedParts = {}
        end
    end)

    -- تعديل خصائص الأرض الجليدية لمنع التزحلق
    RunService.Heartbeat:Connect(function()
        if not noSlipActive then return end

        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        local params = RaycastParams.new()
        params.FilterDescendantsInstances = {char}
        params.FilterType = Enum.RaycastFilterType.Blacklist

        local result = workspace:Raycast(hrp.Position, Vector3.new(0, -5, 0), params)
        if result and result.Instance and result.Instance.Material == Enum.Material.Ice then
            local part = result.Instance
            if part:IsA("BasePart") and not modifiedParts[part] then
                modifiedParts[part] = part.CustomPhysicalProperties
                part.CustomPhysicalProperties = PhysicalProperties.new(1, 1, 0, 1, 1)
            end
        end
    end)

    -- زر تطير اللاعبين باللمس (Touch Fling)
    local flingActive = false
    local flingThread

    local btnTouchFling = createButtonScroll(texts.touchFlingOn, 350)
    btnTouchFling.MouseButton1Click:Connect(function()
        flingActive = not flingActive
        btnTouchFling.Text = flingActive and texts.touchFlingOff or texts.touchFlingOn

        if flingActive then
            flingThread = coroutine.create(function()
                local hrp, vel, movel = nil, nil, 0.1
                while flingActive do
                    RunService.Heartbeat:Wait()
                    local char = player.Character
                    if char then
                        hrp = char:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            vel = hrp.Velocity
                            hrp.Velocity = vel * 99999 + Vector3.new(0, 15000, 0)
                            RunService.RenderStepped:Wait()
                            hrp.Velocity = vel
                            RunService.Stepped:Wait()
                            hrp.Velocity = vel + Vector3.new(0, movel, 0)
                            movel = -movel
                        end
                    end
                end
            end)
            coroutine.resume(flingThread)
        end
    end)

    -- زر إغلاق الواجهة
    local btnClose = Instance.new("TextButton", Frame)
    btnClose.Size = UDim2.new(0, 30, 0, 30)
    btnClose.Position = UDim2.new(1, -35, 0, 5)
    btnClose.Text = texts.close
    btnClose.TextColor3 = Color3.fromRGB(255, 0, 0)
    btnClose.BackgroundTransparency = 1
    btnClose.Font = Enum.Font.GothamBold
    btnClose.TextSize = 20
    btnClose.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)
end

arabicBtn.MouseButton1Click:Connect(function()
    startGUI("ar")
end)

englishBtn.MouseButton1Click:Connect(function()
    startGUI("en")
end)