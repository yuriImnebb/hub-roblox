
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Stats = game:GetService("Stats")
local MarketplaceService = game:GetService("MarketplaceService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")

local __apexPlayer = Players.LocalPlayer
if not __apexPlayer then
    warn("[APEX MONITOR] LocalPlayer indisponível. Este código precisa ser um LocalScript.")
    return
end

local __apexOk, __apexError = xpcall(function()
local player = __apexPlayer
local playerGui = player:WaitForChild("PlayerGui")
local Camera = Workspace.CurrentCamera
Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    Camera = Workspace.CurrentCamera
end)


local old = playerGui:FindFirstChild("ClientDashboardUI")
if old then old:Destroy() end


local C = {
    Background = Color3.fromRGB(0, 0, 0),
    Sidebar = Color3.fromRGB(0, 0, 0),
    Card = Color3.fromRGB(5, 5, 5),
    Card2 = Color3.fromRGB(9, 9, 9),
    Purple = Color3.fromRGB(255, 255, 255),
    PurpleDark = Color3.fromRGB(0, 0, 0),
    White = Color3.fromRGB(255, 255, 255),
    Gray = Color3.fromRGB(205, 205, 205),
    Green = Color3.fromRGB(255, 255, 255),
    Red = Color3.fromRGB(255, 255, 255),
    Border = Color3.fromRGB(105, 105, 105),
    Hover = Color3.fromRGB(12, 12, 12),
    Active = Color3.fromRGB(20, 20, 20)
}


local function create(class, props, parent)
    local obj = Instance.new(class)
    for k, v in pairs(props or {}) do
        obj[k] = v
    end
    obj.Parent = parent
    return obj
end

local function round(obj, radius)
    create("UICorner", {
        CornerRadius = UDim.new(0, radius or 8)
    }, obj)
end

local function stroke(obj, color, thickness)
    return create("UIStroke", {
        Color = color or C.Border,
        Thickness = thickness or 1,
        Transparency = 0.32
    }, obj)
end

local function label(parent, text, size, pos, dimensions, color, font)
    return create("TextLabel", {
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = color or C.White,
        TextSize = size or 12,
        Font = font or Enum.Font.Code,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
        Position = pos,
        Size = dimensions
    }, parent)
end

local function tween(obj, duration, properties)
    local animation = TweenService:Create(
        obj,
        TweenInfo.new(duration, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        properties
    )
    animation:Play()
    return animation
end

local function button(parent, text, pos, dimensions, color)

    local b = create("TextButton", {
        Text = text,
        Position = pos,
        Size = dimensions,
        BackgroundColor3 = C.Background,
        BackgroundTransparency = 1,
        TextColor3 = C.White,
        TextSize = 11,
        Font = Enum.Font.Code,
        TextStrokeTransparency = 1,
        TextStrokeColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 1,
        BorderColor3 = C.Border,
        AutoButtonColor = false,
        Selectable = false
    }, parent)
    round(b, 5)
    return b
end

local function textbox(parent, pos, dimensions, value, placeholder)
    local box = create("TextBox", {
        Position = pos,
        Size = dimensions,
        BackgroundColor3 = C.Background,
        BackgroundTransparency = 0,
        TextColor3 = C.White,
        PlaceholderColor3 = C.Gray,
        Text = tostring(value or ""),
        PlaceholderText = placeholder or "",
        TextSize = 12,
        Font = Enum.Font.Code,
        ClearTextOnFocus = false,
        BorderSizePixel = 0
    }, parent)
    round(box, 5)
    local outline = stroke(box, C.Border, 1)
    outline.Transparency = 0.18
    return box
end

local function section(parent, title, height)
    local f = create("Frame", {
        Size = UDim2.new(1, 0, 0, height),
        BackgroundColor3 = C.Card,
        BorderSizePixel = 0
    }, parent)
    round(f, 6)
    local outline = stroke(f, C.Border, 1)
    outline.Transparency = 0.35
    label(f, title:upper(), 10,
        UDim2.fromOffset(14, 8),
        UDim2.new(1, -28, 0, 22),
        C.Gray, Enum.Font.Code)
    return f
end

local function getHumanoid(plr)
    local char = (plr or player).Character
    return char and char:FindFirstChildOfClass("Humanoid")
end

local function getRoot(plr)
    local char = (plr or player).Character
    return char and char:FindFirstChild("HumanoidRootPart")
end


local gui = create("ScreenGui", {
    Name = "ClientDashboardUI",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    DisplayOrder = 10000,
    Enabled = true
}, playerGui)

local main = create("Frame", {
    Name = "Main",
    Size = UDim2.fromOffset(900, 570),
    Position = UDim2.new(0.5, -450, 0.5, -285),
    BackgroundColor3 = C.Background,
    BorderSizePixel = 0,
    ClipsDescendants = true,
    Visible = true,
    Active = true,
    ZIndex = 10
}, gui)

round(main, 12)
local mainOutline = stroke(main, C.Border, 1)
mainOutline.Transparency = 0.28

create("UISizeConstraint", {
    MinSize = Vector2.new(650, 430),
    MaxSize = Vector2.new(1500, 1000)
}, main)


local sidebar = create("Frame", {
    Size = UDim2.new(0, 185, 1, 0),
    BackgroundColor3 = C.Sidebar,
    BorderSizePixel = 0
}, main)

create("Frame", {
    Position = UDim2.new(1, -1, 0, 0),
    Size = UDim2.new(0, 1, 1, 0),
    BackgroundColor3 = C.Border,
    BackgroundTransparency = 0.45,
    BorderSizePixel = 0
}, sidebar)

local sidebarAvatar = create("ImageLabel", {
    Position = UDim2.fromOffset(20, 61),
    Size = UDim2.fromOffset(38, 38),
    BackgroundColor3 = C.Card2,
    BorderSizePixel = 0,
    ScaleType = Enum.ScaleType.Crop
}, sidebar)

round(sidebarAvatar, 50)
stroke(sidebarAvatar, C.Purple, 1.3)

label(sidebar, player.DisplayName, 11,
    UDim2.fromOffset(68, 62),
    UDim2.new(1, -78, 0, 18),
    C.White, Enum.Font.Code)

label(sidebar, "@" .. player.Name, 9,
    UDim2.fromOffset(68, 81),
    UDim2.new(1, -78, 0, 16),
    C.Gray)

task.spawn(function()
    local ok, image = pcall(function()
        return Players:GetUserThumbnailAsync(
            player.UserId,
            Enum.ThumbnailType.HeadShot,
            Enum.ThumbnailSize.Size150x150
        )
    end)
    if ok then sidebarAvatar.Image = image end
end)


local content = create("Frame", {
    Position = UDim2.fromOffset(185, 0),
    Size = UDim2.new(1, -185, 1, 0),
    BackgroundTransparency = 1,
    ClipsDescendants = true
}, main)

local header = create("Frame", {
    Size = UDim2.new(1, 0, 0, 65),
    BackgroundTransparency = 1,
    Active = true
}, content)

local pageTitle = label(header, "", 16,
    UDim2.fromOffset(23, 10),
    UDim2.new(0.7, 0, 0, 27),
    C.White, Enum.Font.Code)

label(header, "Live game monitoring", 9,
    UDim2.fromOffset(24, 37),
    UDim2.new(0.7, 0, 0, 17),
    C.Gray)

local closeButton = button(header, "X",
    UDim2.new(1, -48, 0, 15),
    UDim2.fromOffset(30, 30), C.Card2)
closeButton.TextSize = 17
closeButton.Visible = true
closeButton.Active = true
closeButton.ZIndex = 50

-- O painel é controlado exclusivamente pelo RightShift.
closeButton.Activated:Connect(function()
    main.Visible = false
end)

do
    local dragging = false
    local dragStart
    local startPosition

    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPosition = main.Position
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            main.Position = UDim2.new(
                startPosition.X.Scale,
                startPosition.X.Offset + delta.X,
                startPosition.Y.Scale,
                startPosition.Y.Offset + delta.Y
            )
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end


local resizeHandle = create("TextButton", {
    AnchorPoint = Vector2.new(1, 1),
    Position = UDim2.new(1, -2, 1, -2),
    Size = UDim2.fromOffset(22, 22),
    BackgroundColor3 = C.Card2,
    Text = "◢",
    TextColor3 = C.Gray,
    TextSize = 13,
    BorderSizePixel = 0,
    ZIndex = 20
}, main)
round(resizeHandle, 5)

do
    local resizing = false
    local startPoint
    local startSize

    resizeHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing = true
            startPoint = input.Position
            startSize = main.AbsoluteSize
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - startPoint
            main.Size = UDim2.fromOffset(
                math.clamp(startSize.X + delta.X, 650, 1500),
                math.clamp(startSize.Y + delta.Y, 430, 1000)
            )
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing = false
        end
    end)
end


local pageNames = {
    "Dashboard",
    "Game Monitor",
    "Player",
    "Analytics",
    "Players",
    "History",
    "Settings"
}

local pages = {}
local navButtons = {}

local navigation = create("Frame", {
    Position = UDim2.fromOffset(12, 119),
    Size = UDim2.new(1, -24, 1, -130),
    BackgroundTransparency = 1
}, sidebar)

create("UIListLayout", {
    Padding = UDim.new(0, 7),
    SortOrder = Enum.SortOrder.LayoutOrder
}, navigation)

for _, name in ipairs(pageNames) do
    local page = create("ScrollingFrame", {
        Name = name,
        Position = UDim2.fromOffset(20, 70),
        Size = UDim2.new(1, -40, 1, -85),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = C.Purple,
        CanvasSize = UDim2.new()
    }, content)

    local layout = create("UIListLayout", {
        Padding = UDim.new(0, 7),
        SortOrder = Enum.SortOrder.LayoutOrder
    }, page)

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.fromOffset(
            0, layout.AbsoluteContentSize.Y + 15
        )
    end)

    pages[name] = page
end

local function openPage(name)
    for pageName, page in pairs(pages) do
        page.Visible = pageName == name
    end

    -- A navegação não muda peso, contorno, tamanho ou fonte ao selecionar.
    -- Todas as opções mantêm exatamente a mesma aparência.
    for _, navButton in pairs(navButtons) do
        navButton.BackgroundTransparency = 1
        navButton.TextColor3 = C.White
        navButton.TextStrokeTransparency = 1
        navButton.Font = Enum.Font.Code
        navButton.TextSize = 10
        navButton.BorderSizePixel = 0
    end

    pageTitle.Text = name
end

for index, name in ipairs(pageNames) do
    local b = button(navigation, "   " .. name,
        UDim2.new(), UDim2.new(1, 0, 0, 37), C.Sidebar)
    b.LayoutOrder = index
    b.TextXAlignment = Enum.TextXAlignment.Left
    b.TextStrokeTransparency = 1
    b.Font = Enum.Font.Code
    b.TextSize = 10
    b.BorderSizePixel = 0
    navButtons[name] = b
    b.MouseButton1Click:Connect(function()
        openPage(name)
    end)
end


local function makeMetric(parent, title, initial, subtitle)
    local f = create("Frame", {
        BackgroundColor3 = C.Card,
        BorderSizePixel = 0
    }, parent)

    round(f, 9)
    stroke(f)

    label(f, title:upper(), 9,
        UDim2.fromOffset(13, 7),
        UDim2.new(1, -25, 0, 13),
        C.Gray, Enum.Font.Code)

    local value = label(f, initial, 21,
        UDim2.fromOffset(13, 23),
        UDim2.new(1, -25, 0, 27),
        C.White, Enum.Font.Code)

    label(f, subtitle, 8,
        UDim2.fromOffset(13, 53),
        UDim2.new(1, -25, 0, 12), C.Gray)

    return value
end


local dashboard = pages.Dashboard

local metrics = create("Frame", {
    Size = UDim2.new(1, 0, 0, 151),
    BackgroundTransparency = 1
}, dashboard)

create("UIGridLayout", {
    CellSize = UDim2.new(0.5, -5, 0, 72),
    CellPadding = UDim2.fromOffset(8, 7),
    SortOrder = Enum.SortOrder.LayoutOrder
}, metrics)

local fpsValue = makeMetric(metrics, "FPS", "--", "Frames per second")
local pingValue = makeMetric(metrics, "PING", "--", "Network latency")
local memoryValue = makeMetric(metrics, "MEMORY", "--", "Roblox memory")
local playersValue = makeMetric(metrics, "PLAYERS", "--", "Players in server")

local experienceSection = section(dashboard, "CURRENT EXPERIENCE", 66)

local experienceName = label(experienceSection, "Loading experience...",
    13, UDim2.fromOffset(14, 31),
    UDim2.new(1, -28, 0, 18),
    C.White, Enum.Font.Code)

label(experienceSection, "Place ID: " .. tostring(game.PlaceId),
    8, UDim2.fromOffset(14, 49),
    UDim2.new(1, -28, 0, 12), C.Gray)

task.spawn(function()
    local ok, info = pcall(function()
        return MarketplaceService:GetProductInfo(game.PlaceId)
    end)

    experienceName.Text = ok and info.Name or ("Experience ID: " .. game.PlaceId)
end)


local monitor = pages["Game Monitor"]

local sessionSection = section(monitor, "SESSION OVERVIEW", 86)

local sessionInfo = label(sessionSection, "Collecting data...",
    11, UDim2.fromOffset(14, 32),
    UDim2.new(1, -28, 0, 46), C.Gray)

local monitorValues = section(monitor, "LIVE VALUES", 126)
local monitorFPS = label(monitorValues, "FPS: --", 11,
    UDim2.fromOffset(14, 34), UDim2.new(0.5, -18, 0, 18), C.White, Enum.Font.Code)
local monitorPing = label(monitorValues, "PING: --", 11,
    UDim2.new(0.5, 4, 0, 34), UDim2.new(0.5, -18, 0, 18), C.White, Enum.Font.Code)
local monitorMemory = label(monitorValues, "MEMORY: -- MB", 11,
    UDim2.fromOffset(14, 70), UDim2.new(0.5, -18, 0, 18), C.White, Enum.Font.Code)
local monitorPlayers = label(monitorValues, "PLAYERS: --", 11,
    UDim2.new(0.5, 4, 0, 70), UDim2.new(0.5, -18, 0, 18), C.White, Enum.Font.Code)

local playerPage = pages.Player

local profileSection = section(playerPage, "YOUR PLAYER", 125)

local avatar = create("ImageLabel", {
    Position = UDim2.fromOffset(14, 37),
    Size = UDim2.fromOffset(70, 70),
    BackgroundColor3 = C.Card2,
    BorderSizePixel = 0
}, profileSection)

round(avatar, 9)

task.spawn(function()
    local ok, image = pcall(function()
        return Players:GetUserThumbnailAsync(
            player.UserId,
            Enum.ThumbnailType.HeadShot,
            Enum.ThumbnailSize.Size150x150
        )
    end)

    if ok then avatar.Image = image end
end)

label(profileSection, player.DisplayName, 14,
    UDim2.fromOffset(95, 42),
    UDim2.new(1, -110, 0, 22),
    C.White, Enum.Font.Code)

label(profileSection, "@" .. player.Name, 10,
    UDim2.fromOffset(95, 65),
    UDim2.new(1, -110, 0, 18), C.Gray)

label(profileSection, "User ID: " .. player.UserId, 9,
    UDim2.fromOffset(95, 86),
    UDim2.new(1, -110, 0, 16), C.Gray)


local movementSection = section(playerPage, "MOVEMENT SETTINGS", 155)

label(movementSection, "WALKSPEED", 10,
    UDim2.fromOffset(14, 38),
    UDim2.fromOffset(100, 25), C.Gray, Enum.Font.Code)

local walkSpeedInput = textbox(movementSection,
    UDim2.fromOffset(120, 35),
    UDim2.fromOffset(90, 30), "16", "16")

local applyWalkSpeed = button(movementSection, "APPLY",
    UDim2.fromOffset(220, 35),
    UDim2.fromOffset(85, 30), C.PurpleDark)

local currentWalkSpeed = 16

applyWalkSpeed.MouseButton1Click:Connect(function()
    local n = tonumber(walkSpeedInput.Text)

    if n then
        currentWalkSpeed = math.clamp(n, 0, 200)

        local hum = getHumanoid()
        if hum then hum.WalkSpeed = currentWalkSpeed end

        walkSpeedInput.Text = tostring(currentWalkSpeed)
    end
end)

label(movementSection, "FOV", 10,
    UDim2.fromOffset(14, 88),
    UDim2.fromOffset(100, 25), C.Gray, Enum.Font.Code)

local defaultFOV = Camera.FieldOfView

local fovInput = textbox(movementSection,
    UDim2.fromOffset(120, 85),
    UDim2.fromOffset(90, 30), tostring(defaultFOV), "70")

local fovButton = button(movementSection, "APPLY FOV",
    UDim2.fromOffset(220, 85),
    UDim2.fromOffset(85, 30), C.PurpleDark)

fovButton.MouseButton1Click:Connect(function()
    Camera.FieldOfView = math.clamp(
        tonumber(fovInput.Text) or defaultFOV,
        40, 120
    )
end)


local flySection = section(playerPage, "FLY CONTROL", 180)

local flyStatus = label(flySection, "STATUS: DISABLED", 10,
    UDim2.fromOffset(14, 34),
    UDim2.new(1, -28, 0, 20),
    C.Red, Enum.Font.Code)

local flyButton = button(flySection, "ENABLE FLY",
    UDim2.fromOffset(14, 58),
    UDim2.new(1, -28, 0, 34), C.PurpleDark)

label(flySection, "FLY SPEED (1 - 500)", 9,
    UDim2.fromOffset(14, 105),
    UDim2.new(0.6, 0, 0, 25),
    C.Gray, Enum.Font.Code)

local flySpeedInput = textbox(flySection,
    UDim2.new(1, -100, 0, 102),
    UDim2.fromOffset(86, 30), "65", "65")

label(flySection, "WASD: move | Space/Ctrl: up/down | F: toggle",
    9, UDim2.fromOffset(14, 143),
    UDim2.new(1, -28, 0, 20), C.Gray)

local flyEnabled = false
local flying = false
local flySpeed = 65
local flyConnection
local oldAutoRotate

local function stopFly()
    flying = false

    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end

    local root = getRoot()
    local hum = getHumanoid()

    if root then
        for _, name in ipairs({
            "ApexFlyVelocity",
            "ApexFlyOrientation",
            "ApexFlyAttachment"
        }) do
            local obj = root:FindFirstChild(name)
            if obj then obj:Destroy() end
        end
    end

    if hum then
        hum.PlatformStand = false

        if oldAutoRotate ~= nil then
            hum.AutoRotate = oldAutoRotate
        else
            hum.AutoRotate = true
        end

        hum:ChangeState(Enum.HumanoidStateType.GettingUp)
    end
end

local function startFly()
    if not flyEnabled or flying then return end

    local hum = getHumanoid()
    local root = getRoot()

    if not hum or not root or hum.Health <= 0 then return end

    stopFly()
    flying = true

    oldAutoRotate = hum.AutoRotate
    hum.AutoRotate = false
    hum.PlatformStand = false

    local attachment = Instance.new("Attachment")
    attachment.Name = "ApexFlyAttachment"
    attachment.Parent = root

    local velocity = Instance.new("LinearVelocity")
    velocity.Name = "ApexFlyVelocity"
    velocity.Attachment0 = attachment
    velocity.RelativeTo = Enum.ActuatorRelativeTo.World
    velocity.MaxForce = math.huge
    velocity.VectorVelocity = Vector3.zero
    velocity.Parent = root

    local orientation = Instance.new("AlignOrientation")
    orientation.Name = "ApexFlyOrientation"
    orientation.Attachment0 = attachment
    orientation.Mode = Enum.OrientationAlignmentMode.OneAttachment
    orientation.MaxTorque = math.huge
    orientation.Responsiveness = 10
    orientation.Parent = root

    flyConnection = RunService.RenderStepped:Connect(function()
        if not flying or not root.Parent or hum.Health <= 0 then
            stopFly()
            return
        end

        local camera = Workspace.CurrentCamera
        if not camera then return end

        local look = camera.CFrame.LookVector
        local right = camera.CFrame.RightVector
        local movement = Vector3.zero

        if UIS:IsKeyDown(Enum.KeyCode.W) then movement += look end
        if UIS:IsKeyDown(Enum.KeyCode.S) then movement -= look end
        if UIS:IsKeyDown(Enum.KeyCode.D) then movement += right end
        if UIS:IsKeyDown(Enum.KeyCode.A) then movement -= right end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then movement += Vector3.yAxis end
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then movement -= Vector3.yAxis end

        if movement.Magnitude > 0 then
            movement = movement.Unit
        end

        velocity.VectorVelocity = movement * flySpeed
        orientation.CFrame = CFrame.lookAt(Vector3.zero, look)
    end)
end

local function updateFlyUI()
    if not flyEnabled then
        flyStatus.Text = "STATUS: DISABLED"
        flyStatus.TextColor3 = C.Red
        flyButton.Text = "ENABLE FLY"
        flyButton.BackgroundColor3 = C.PurpleDark
    elseif flying then
        flyStatus.Text = "STATUS: FLYING"
        flyStatus.TextColor3 = C.Green
        flyButton.Text = "DISABLE FLY"
        flyButton.BackgroundColor3 = C.Green
    else
        flyStatus.Text = "STATUS: ENABLED - PRESS F"
        flyStatus.TextColor3 = C.Green
        flyButton.Text = "FLY ENABLED"
        flyButton.BackgroundColor3 = C.PurpleDark
    end
end

flyButton.MouseButton1Click:Connect(function()
    flyEnabled = not flyEnabled

    if flyEnabled then
        startFly()
    else
        stopFly()
    end

    updateFlyUI()
end)

flySpeedInput.FocusLost:Connect(function()
    flySpeed = math.clamp(tonumber(flySpeedInput.Text) or 65, 1, 500)
    flySpeedInput.Text = tostring(flySpeed)
end)


local utilitySection = section(playerPage, "EXTRA MOVEMENT", 125)

local noclipEnabled = false
local voidProtection = false
local noclipConnection
local lastSafeCFrame

local noclipButton = button(utilitySection, "NOCLIP: OFF",
    UDim2.fromOffset(14, 38),
    UDim2.new(0.5, -20, 0, 32), C.Card2)

local voidButton = button(utilitySection, "VOID PROTECTION: OFF",
    UDim2.new(0.5, 6, 0, 38),
    UDim2.new(0.5, -20, 0, 32), C.Card2)

local function setNoclip(state)
    noclipEnabled = state

    if noclipConnection then
        noclipConnection:Disconnect()
        noclipConnection = nil
    end

    if state then
        noclipConnection = RunService.Stepped:Connect(function()
            local char = player.Character
            if not char then return end

            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end)

        noclipButton.Text = "NOCLIP: ON"
        noclipButton.BackgroundColor3 = C.PurpleDark
    else
        local char = player.Character

        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.CanCollide = true
                end
            end
        end

        noclipButton.Text = "NOCLIP: OFF"
        noclipButton.BackgroundColor3 = C.Card2
    end
end

noclipButton.MouseButton1Click:Connect(function()
    setNoclip(not noclipEnabled)
end)

voidButton.MouseButton1Click:Connect(function()
    voidProtection = not voidProtection

    voidButton.Text = voidProtection
        and "VOID PROTECTION: ON"
        or "VOID PROTECTION: OFF"

    voidButton.BackgroundColor3 = voidProtection
        and C.PurpleDark or C.Card2
end)

local voidCheckAccumulator = 0
RunService.Heartbeat:Connect(function(dt)
    if not voidProtection then return end
    voidCheckAccumulator += dt
    if voidCheckAccumulator < 0.25 then return end
    voidCheckAccumulator = 0

    local root = getRoot()
    if not root then return end

    if root.Position.Y > -100 then
        lastSafeCFrame = root.CFrame
    elseif lastSafeCFrame then
        root.AssemblyLinearVelocity = Vector3.zero
        root.CFrame = lastSafeCFrame + Vector3.new(0, 5, 0)
    end
end)


local playersPage = pages.Players

local searchInput = textbox(
    playersPage,
    UDim2.new(),
    UDim2.new(1, 0, 0, 32),
    "",
    "Search player..."
)

local playerList = create("Frame", {
    Size = UDim2.new(1, 0, 0, 10),
    BackgroundTransparency = 1
}, playersPage)

local playerListLayout = create("UIListLayout", {
    Padding = UDim.new(0, 6),
    SortOrder = Enum.SortOrder.LayoutOrder
}, playerList)

local spectatingPlayer = nil
local espEnabled = {}
local espObjects = {}
local locatedPlayer = nil
local locateObjects = {}

local function clearLocate()
    for _, obj in ipairs(locateObjects) do
        if obj and obj.Parent then obj:Destroy() end
    end
    table.clear(locateObjects)
    locatedPlayer = nil
end

local function locate(target)
    clearLocate()
    local char = target.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    locatedPlayer = target
    local highlight = Instance.new("Highlight")
    highlight.Name = "ApexLocateHighlight"
    highlight.Adornee = char
    highlight.FillColor = C.Purple
    highlight.OutlineColor = Color3.fromRGB(220, 220, 220)
    highlight.FillTransparency = 0.78
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = gui

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ApexLocateDistance"
    billboard.Adornee = root
    billboard.Size = UDim2.fromOffset(170, 30)
    billboard.StudsOffset = Vector3.new(0, 4.2, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = gui

    local distanceLabel = create("TextLabel", {
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        TextColor3 = C.White,
        TextStrokeTransparency = 1,
        Text = target.DisplayName .. " | -- studs",
        Font = Enum.Font.Code,
        TextSize = 12
    }, billboard)

    table.insert(locateObjects, highlight)
    table.insert(locateObjects, billboard)

    task.spawn(function()
        while locatedPlayer == target and billboard.Parent do
            local myRoot = getRoot()
            local targetRoot = getRoot(target)
            if not target.Parent or not targetRoot then break end
            if myRoot then
                local distance = (myRoot.Position - targetRoot.Position).Magnitude
                distanceLabel.Text = string.format("%s | %d studs", target.DisplayName, math.floor(distance + 0.5))
            end
            task.wait(1)
        end
        if locatedPlayer == target then clearLocate() end
    end)
end

local function stopSpectate()
    spectatingPlayer = nil

    local hum = getHumanoid()
    if hum then Camera.CameraSubject = hum end
end

local function spectate(target)
    local hum = getHumanoid(target)
    if not hum then return end

    spectatingPlayer = target
    Camera.CameraSubject = hum
end

local function teleportTo(target)
    local myRoot = getRoot()
    local targetRoot = getRoot(target)

    if myRoot and targetRoot then
        myRoot.CFrame = targetRoot.CFrame * CFrame.new(0, 0, 4)
    end
end

local function clearESP(target)
    local objects = espObjects[target]

    if objects then
        for _, obj in ipairs(objects) do
            if obj and obj.Parent then obj:Destroy() end
        end
    end

    espObjects[target] = nil
end

local function setESP(target, state)
    clearESP(target)
    espEnabled[target] = state

    if not state then return end

    local char = target.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")

    if not char or not root then return end

    local box = Instance.new("BoxHandleAdornment")
    box.Name = "ApexPlayerESP"
    box.Adornee = root
    box.Size = char:GetExtentsSize()
    box.AlwaysOnTop = true
    box.ZIndex = 5
    box.Transparency = 0.65
    box.Color3 = C.Purple
    box.Parent = root

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ApexPlayerName"
    billboard.Adornee = root
    billboard.Size = UDim2.fromOffset(150, 28)
    billboard.StudsOffset = Vector3.new(0, 3.5, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = root

    create("TextLabel", {
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Text = target.DisplayName,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextStrokeTransparency = 1,
        Font = Enum.Font.Code,
        TextSize = 12
    }, billboard)

    espObjects[target] = {box, billboard}
end

local function refreshPlayerList()
    for _, child in ipairs(playerList:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end

    local query = string.lower(searchInput.Text)
    local count = 0

    for _, target in ipairs(Players:GetPlayers()) do
        if target ~= player then
            local username = string.lower(target.Name)
            local display = string.lower(target.DisplayName)
            if query == "" or string.find(username, query, 1, true)
                or string.find(display, query, 1, true)
                or string.find(tostring(target.UserId), query, 1, true) then

                count += 1
                local row = create("Frame", {
                    Size = UDim2.new(1, 0, 0, 104),
                    BackgroundColor3 = C.Card,
                    BorderSizePixel = 0,
                    LayoutOrder = count
                }, playerList)
                round(row, 5)
                local rowStroke = stroke(row, C.Border, 1)
                rowStroke.Transparency = 0.55

                local headshot = create("ImageLabel", {
                    Name = "PlayerAvatar",
                    Position = UDim2.fromOffset(9, 10),
                    Size = UDim2.fromOffset(54, 54),
                    BackgroundColor3 = C.Card2,
                    BorderSizePixel = 0,
                    ScaleType = Enum.ScaleType.Crop
                }, row)
                round(headshot, 4)
                task.spawn(function()
                    local ok, image = pcall(function()
                        return Players:GetUserThumbnailAsync(
                            target.UserId,
                            Enum.ThumbnailType.HeadShot,
                            Enum.ThumbnailSize.Size150x150
                        )
                    end)
                    if ok and headshot.Parent then headshot.Image = image end
                end)

                label(row, target.DisplayName, 12,
                    UDim2.fromOffset(72, 7), UDim2.new(0.43, -72, 0, 18), C.White)
                label(row, "@" .. target.Name, 10,
                    UDim2.fromOffset(72, 26), UDim2.new(0.43, -72, 0, 15), C.Gray)
                label(row, "ID: " .. tostring(target.UserId), 9,
                    UDim2.fromOffset(72, 43), UDim2.new(0.43, -72, 0, 14), C.Gray)

                local humanoid = getHumanoid(target)
                local healthText = humanoid
                    and string.format("HP: %d/%d", math.floor(humanoid.Health), math.floor(humanoid.MaxHealth))
                    or "HP: unavailable"
                local teamText = target.Team and ("Team: " .. target.Team.Name) or "Team: none"
                local statusText = string.format("%s  |  %s  |  Age: %d days",
                    healthText, teamText, target.AccountAge)
                label(row, statusText, 9,
                    UDim2.fromOffset(72, 61), UDim2.new(1, -82, 0, 14), C.Gray)

                local actions = create("Frame", {
                    Position = UDim2.new(0.45, 0, 0, 10),
                    Size = UDim2.new(0.55, -10, 0, 27),
                    BackgroundTransparency = 1
                }, row)
                create("UIListLayout", {
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalAlignment = Enum.HorizontalAlignment.Right,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    Padding = UDim.new(0, 5),
                    SortOrder = Enum.SortOrder.LayoutOrder
                }, actions)

                local function actionButton(caption, width, callback)
                    local b = button(actions, caption, UDim2.new(), UDim2.fromOffset(width, 26), C.Background)
                    b.TextStrokeTransparency = 1
                    b.LayoutOrder = #actions:GetChildren()
                    b.Activated:Connect(callback)
                    return b
                end

                actionButton("LOCATE", 57, function() locate(target) end)
                actionButton("SPECTATE", 72, function() spectate(target) end)
                actionButton("TP", 38, function() teleportTo(target) end)
                local espButton
                espButton = actionButton(espEnabled[target] and "ESP ON" or "ESP OFF", 62, function()
                    local state = not espEnabled[target]
                    setESP(target, state)
                    if espButton then
                        espButton.Text = state and "ESP ON" or "ESP OFF"
                    end
                end)
            end
        end
    end

    playerList.Size = UDim2.new(1, 0, 0, count * 111)
end

local searchRefreshToken = 0
searchInput:GetPropertyChangedSignal("Text"):Connect(function()
    searchRefreshToken += 1
    local token = searchRefreshToken
    task.delay(0.25, function()
        if token == searchRefreshToken then
            refreshPlayerList()
        end
    end)
end)

Players.PlayerAdded:Connect(function(target)
    task.wait(0.2)
    refreshPlayerList()

    target.CharacterAdded:Connect(function()
        task.wait(1)
        if espEnabled[target] then
            setESP(target, true)
        end
    end)
end)

Players.PlayerRemoving:Connect(function(target)
    clearESP(target)
    espEnabled[target] = nil
    if locatedPlayer == target then clearLocate() end

    if spectatingPlayer == target then
        stopSpectate()
    end

    refreshPlayerList()
end)


local analyticsPage = pages.Analytics

local analyticsSection = section(analyticsPage, "LIVE ANALYTICS", 155)

local analyticsText = label(
    analyticsSection,
    "Collecting performance data...",
    11,
    UDim2.fromOffset(14, 38),
    UDim2.new(1, -28, 0, 100),
    C.Gray
)

local analyticsValues = section(analyticsPage, "CURRENT VALUES", 112)
local analyticsFPSValue = label(analyticsValues, "FPS: --", 11,
    UDim2.fromOffset(14, 34), UDim2.new(0.5, -18, 0, 18), C.White, Enum.Font.Code)
local analyticsPingValue = label(analyticsValues, "PING: --", 11,
    UDim2.new(0.5, 4, 0, 34), UDim2.new(0.5, -18, 0, 18), C.White, Enum.Font.Code)
local analyticsMemoryValue = label(analyticsValues, "MEMORY: -- MB", 11,
    UDim2.fromOffset(14, 68), UDim2.new(0.5, -18, 0, 18), C.White, Enum.Font.Code)
local analyticsPlayersValue = label(analyticsValues, "PLAYERS: --", 11,
    UDim2.new(0.5, 4, 0, 68), UDim2.new(0.5, -18, 0, 18), C.White, Enum.Font.Code)

local historyPage = pages.History

local historySection = section(historyPage, "SERVER EVENTS", 350)

local historyList = create("ScrollingFrame", {
    Position = UDim2.fromOffset(12, 35),
    Size = UDim2.new(1, -24, 1, -45),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ScrollBarThickness = 3,
    CanvasSize = UDim2.new()
}, historySection)

local historyLayout = create("UIListLayout", {
    Padding = UDim.new(0, 5),
    SortOrder = Enum.SortOrder.LayoutOrder
}, historyList)

local historyCount = 0

local function addHistory(message, color)
    historyCount += 1

    local entry = label(
        historyList,
        os.date("%H:%M:%S") .. "  |  " .. message,
        10,
        UDim2.new(),
        UDim2.new(1, -8, 0, 22),
        color or C.Gray
    )

    entry.LayoutOrder = -historyCount

    task.defer(function()
        historyList.CanvasSize = UDim2.fromOffset(
            0, historyLayout.AbsoluteContentSize.Y + 8
        )
    end)
end

addHistory("Monitor iniciado", C.Purple)

Players.PlayerAdded:Connect(function(target)
    addHistory(target.Name .. " entrou no servidor", C.Green)
end)

Players.PlayerRemoving:Connect(function(target)
    addHistory(target.Name .. " saiu do servidor", C.Red)
end)


local settingsPage = pages.Settings
local settingsSection = section(settingsPage, "INTERFACE SETTINGS", 145)

local settingsClose = button(settingsSection, "CLOSE DASHBOARD",
    UDim2.fromOffset(14, 42),
    UDim2.new(1, -28, 0, 35), C.PurpleDark)

settingsClose.Activated:Connect(function()
    main.Visible = false
end)

label(settingsSection, "Pressione RIGHT SHIFT para abrir/fechar.",
    9, UDim2.fromOffset(14, 83),
    UDim2.new(1, -28, 0, 18), C.Gray)

local stopSpectateButton = button(settingsSection, "STOP SPECTATING",
    UDim2.fromOffset(14, 108),
    UDim2.fromOffset(140, 28), C.Card2)

stopSpectateButton.MouseButton1Click:Connect(stopSpectate)


local frameCounter = 0
local elapsed = 0
local fps = 0
local sessionStart = os.clock()

local function getPing()
    local result = 0

    pcall(function()
        result = math.floor(
            Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
        )
    end)

    return result
end

local function getMemory()
    local result = 0

    pcall(function()
        result = math.floor(Stats:GetTotalMemoryUsageMb())
    end)

    return result
end

RunService.RenderStepped:Connect(function(dt)
    frameCounter += 1
    elapsed += dt

    if elapsed >= 1 then
        fps = math.floor(frameCounter / elapsed + 0.5)
        frameCounter = 0
        elapsed = 0
    end
end)


local liveAccumulator = 0
local currentPing = 0
local currentMemory = 0
local currentPlayerCount = #Players:GetPlayers()

RunService.Heartbeat:Connect(function(dt)
    liveAccumulator += dt
    if liveAccumulator < 1 then return end
    liveAccumulator = 0

    currentPing = getPing()
    currentMemory = getMemory()
    currentPlayerCount = #Players:GetPlayers()

    fpsValue.Text = tostring(fps)
    pingValue.Text = currentPing > 0 and (currentPing .. " ms") or "--"
    memoryValue.Text = currentMemory .. " MB"
    playersValue.Text = tostring(currentPlayerCount)

    monitorFPS.Text = "FPS: " .. tostring(fps)
    monitorPing.Text = "PING: " .. (currentPing > 0 and (tostring(currentPing) .. " ms") or "--")
    monitorMemory.Text = "MEMORY: " .. tostring(currentMemory) .. " MB"
    monitorPlayers.Text = "PLAYERS: " .. tostring(currentPlayerCount)

    analyticsFPSValue.Text = "FPS: " .. tostring(fps)
    analyticsPingValue.Text = "PING: " .. (currentPing > 0 and (tostring(currentPing) .. " ms") or "--")
    analyticsMemoryValue.Text = "MEMORY: " .. tostring(currentMemory) .. " MB"
    analyticsPlayersValue.Text = "PLAYERS: " .. tostring(currentPlayerCount)

    local uptime = math.floor(os.clock() - sessionStart)
    local minutes = math.floor(uptime / 60)
    local seconds = uptime % 60

    sessionInfo.Text = string.format(
        "Session: %d min %d sec\nPlayers: %d\nFPS: %d    Ping: %s ms\nMemory: %d MB",
        minutes,
        seconds,
        currentPlayerCount,
        fps,
        currentPing > 0 and tostring(currentPing) or "--",
        currentMemory
    )

    analyticsText.Text = string.format(
        "FPS: %d\nPing: %s ms\nMemory: %d MB\nPlayers: %d",
        fps,
        currentPing > 0 and tostring(currentPing) or "--",
        currentMemory,
        currentPlayerCount
    )
end)


player.CharacterAdded:Connect(function(char)
    stopFly()
    task.wait(0.5)

    local hum = char:WaitForChild("Humanoid")
    hum.WalkSpeed = currentWalkSpeed

    if not spectatingPlayer then
        Camera.CameraSubject = hum
    end

    if noclipEnabled then
        setNoclip(true)
    end
end)


UIS.InputBegan:Connect(function(input, processed)
    if UIS:GetFocusedTextBox() then return end

    if input.KeyCode == Enum.KeyCode.RightShift then
        main.Visible = not main.Visible
        return
    end

    if input.KeyCode == Enum.KeyCode.F and flyEnabled then
        if flying then
            stopFly()
        else
            startFly()
        end

        updateFlyUI()
    end
end)


gui.Enabled = true
main.Visible = true
refreshPlayerList()
openPage("Dashboard")
updateFlyUI()

print("[APEX MONITOR] Complete Edition loaded successfully.")

end, function(err)
    return debug.traceback(tostring(err), 2)
end)

if not __apexOk then
    warn("[APEX MONITOR] ERRO AO INICIAR:\n" .. tostring(__apexError))
    local player = Players.LocalPlayer
    if player then
        local playerGui = player:FindFirstChildOfClass("PlayerGui") or player:WaitForChild("PlayerGui", 10)
        if playerGui then
            local oldErrorGui = playerGui:FindFirstChild("ApexMonitorError")
            if oldErrorGui then oldErrorGui:Destroy() end
            local errorGui = Instance.new("ScreenGui")
            errorGui.Name = "ApexMonitorError"
            errorGui.ResetOnSpawn = false
            errorGui.DisplayOrder = 30000
            errorGui.Parent = playerGui

            local panel = Instance.new("Frame")
            panel.Size = UDim2.new(0, 620, 0, 250)
            panel.Position = UDim2.new(0.5, -310, 0.5, -125)
            panel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            panel.BorderSizePixel = 0
            panel.Parent = errorGui
            Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 10)

            local title = Instance.new("TextLabel")
            title.Size = UDim2.new(1, -30, 0, 35)
            title.Position = UDim2.fromOffset(15, 10)
            title.BackgroundTransparency = 1
            title.Font = Enum.Font.Code
            title.TextSize = 16
            title.TextXAlignment = Enum.TextXAlignment.Left
            title.TextColor3 = Color3.fromRGB(255, 255, 255)
            title.Text = "FALHA NA INICIALIZAÇÃO"
            title.Parent = panel

            local details = Instance.new("TextLabel")
            details.Size = UDim2.new(1, -30, 1, -58)
            details.Position = UDim2.fromOffset(15, 48)
            details.BackgroundTransparency = 1
            details.Font = Enum.Font.Code
            details.TextSize = 11
            details.TextWrapped = true
            details.TextYAlignment = Enum.TextYAlignment.Top
            details.TextXAlignment = Enum.TextXAlignment.Left
            details.TextColor3 = Color3.fromRGB(255, 255, 255)
            details.Text = tostring(__apexError)
            details.Parent = panel
        end
    end
end
