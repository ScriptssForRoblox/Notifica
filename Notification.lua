-- // Notification.lua
-- // Uso: local Notify = loadstring(...)() ou require(...)
-- // Notify.Send({ title, message, duration, type, icon })

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local GuiParent = CoreGui:FindFirstChild("RobloxGui") or LocalPlayer:WaitForChild("PlayerGui")

local SPACING = 75
local DEFAULT_ICON = "rbxthumb://type=Asset&id=9267155972&w=150&h=150"

-- Cores por tipo
local TYPES = {
    info    = Color3.fromRGB(80, 140, 255),
    success = Color3.fromRGB(80, 220, 120),
    warning = Color3.fromRGB(255, 200, 60),
    error   = Color3.fromRGB(255, 80, 80),
    default = Color3.fromRGB(160, 100, 255),
}

local NotifyGui = GuiParent:FindFirstChild("NotifyGui_v2")
if not NotifyGui then
    NotifyGui = Instance.new("ScreenGui")
    NotifyGui.Name = "NotifyGui_v2"
    NotifyGui.DisplayOrder = 999
    NotifyGui.ResetOnSpawn = false
    NotifyGui.Parent = GuiParent
end

local Notification = {}

function Notification.Send(cfg)
    local title    = cfg.title    or "Notification"
    local message  = cfg.message  or ""
    local duration = cfg.duration or 5
    local ntype    = cfg.type     or "default"
    local icon     = cfg.icon     or DEFAULT_ICON
    local accent   = TYPES[ntype] or TYPES.default

    -- Empurra notificações existentes para cima
    for _, f in ipairs(NotifyGui:GetChildren()) do
        if f:IsA("Frame") then
            TweenService:Create(f, TweenInfo.new(0.3), {
                Position = f.Position - UDim2.new(0, 0, 0, SPACING)
            }):Play()
        end
    end

    -- Frame principal
    local Frame = Instance.new("Frame")
    Frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Frame.Size = UDim2.new(0, 290, 0, 68)
    Frame.Position = UDim2.new(1, 30, 1, -100)
    Frame.ClipsDescendants = true
    Frame.Parent = NotifyGui
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 10)

    local Stroke = Instance.new("UIStroke", Frame)
    Stroke.Color = Color3.fromRGB(40, 40, 40)
    Stroke.Thickness = 1.2

    -- Linha lateral colorida (accent)
    local Accent = Instance.new("Frame", Frame)
    Accent.BackgroundColor3 = accent
    Accent.Size = UDim2.new(0, 3, 1, 0)
    Accent.Position = UDim2.new(0, 0, 0, 0)
    Accent.BorderSizePixel = 0
    Instance.new("UICorner", Accent).CornerRadius = UDim.new(0, 10)

    -- Ícone
    local Icon = Instance.new("ImageLabel", Frame)
    Icon.BackgroundTransparency = 1
    Icon.Position = UDim2.new(0, 14, 0, 13)
    Icon.Size = UDim2.new(0, 26, 0, 26)
    Icon.Image = icon
    Instance.new("UICorner", Icon).CornerRadius = UDim.new(1, 0)

    -- Título
    local Title = Instance.new("TextLabel", Frame)
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 48, 0, 10)
    Title.Size = UDim2.new(0, 190, 0, 22)
    Title.Font = Enum.Font.GothamBold
    Title.Text = title
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 13
    Title.TextXAlignment = Enum.TextXAlignment.Left

    -- Tipo badge (ex: "SUCCESS")
    local Badge = Instance.new("TextLabel", Frame)
    Badge.BackgroundTransparency = 1
    Badge.Position = UDim2.new(0, 48, 0, 10)
    Badge.Size = UDim2.new(1, -55, 0, 22)
    Badge.Font = Enum.Font.GothamBold
    Badge.Text = string.upper(ntype)
    Badge.TextColor3 = accent
    Badge.TextSize = 10
    Badge.TextXAlignment = Enum.TextXAlignment.Right

    -- Mensagem
    local Msg = Instance.new("TextLabel", Frame)
    Msg.BackgroundTransparency = 1
    Msg.Position = UDim2.new(0, 14, 0, 36)
    Msg.Size = UDim2.new(1, -28, 0, 20)
    Msg.Font = Enum.Font.Gotham
    Msg.Text = message
    Msg.TextColor3 = Color3.fromRGB(170, 170, 170)
    Msg.TextSize = 11
    Msg.TextXAlignment = Enum.TextXAlignment.Left

    -- Barra de progresso
    local BarBg = Instance.new("Frame", Frame)
    BarBg.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    BarBg.Size = UDim2.new(1, 0, 0, 3)
    BarBg.Position = UDim2.new(0, 0, 1, -3)
    BarBg.BorderSizePixel = 0

    local Bar = Instance.new("Frame", BarBg)
    Bar.BackgroundColor3 = accent
    Bar.Size = UDim2.new(1, 0, 1, 0)
    Bar.BorderSizePixel = 0

    -- Botão fechar
    local Close = Instance.new("TextButton", Frame)
    Close.BackgroundTransparency = 1
    Close.Position = UDim2.new(1, -28, 0, 6)
    Close.Size = UDim2.new(0, 22, 0, 22)
    Close.Text = "×"
    Close.TextColor3 = Color3.fromRGB(100, 100, 100)
    Close.TextSize = 20

    local function Exit()
        local currentY = Frame.Position.Y.Offset
        for _, f in ipairs(NotifyGui:GetChildren()) do
            if f:IsA("Frame") and f ~= Frame and f.Position.Y.Offset < currentY then
                TweenService:Create(f, TweenInfo.new(0.3), {
                    Position = f.Position + UDim2.new(0, 0, 0, SPACING)
                }):Play()
            end
        end
        local t = TweenService:Create(Frame, TweenInfo.new(0.4), {
            Position = Frame.Position + UDim2.new(0, 350, 0, 0)
        })
        t:Play()
        t.Completed:Connect(function() Frame:Destroy() end)
    end

    Close.MouseButton1Click:Connect(Exit)

    -- Slide in
    TweenService:Create(Frame, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(1, -305, 1, -100)
    }):Play()

    -- Barra de progresso animada
    TweenService:Create(Bar, TweenInfo.new(duration, Enum.EasingStyle.Linear), {
        Size = UDim2.new(0, 0, 1, 0)
    }):Play()

    task.delay(duration, function()
        if Frame.Parent then Exit() end
    end)
end

return Notification
