-- // Loading.lua
-- // Uso:
-- // local Loading = loadstring(...)()
-- // Loading.Show({ title, message, accent })
-- // Loading.Hide()

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local GuiParent = CoreGui:FindFirstChild("RobloxGui") or LocalPlayer:WaitForChild("PlayerGui")

local LoadingGui = GuiParent:FindFirstChild("LoadingGui_v2")
if not LoadingGui then
    LoadingGui = Instance.new("ScreenGui")
    LoadingGui.Name = "LoadingGui_v2"
    LoadingGui.DisplayOrder = 1000
    LoadingGui.ResetOnSpawn = false
    LoadingGui.Parent = GuiParent
end

local Loading = {}
local ActiveFrame = nil

function Loading.Show(cfg)
    cfg = cfg or {}
    local title   = cfg.title   or "Loading"
    local message = cfg.message or "Please wait..."
    local accent  = cfg.accent  or Color3.fromRGB(160, 100, 255)

    if ActiveFrame then ActiveFrame:Destroy() end

    -- Overlay escuro
    local Overlay = Instance.new("Frame", LoadingGui)
    Overlay.Name = "LoadingOverlay"
    Overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Overlay.BackgroundTransparency = 0.4
    Overlay.Size = UDim2.new(1, 0, 1, 0)
    Overlay.BorderSizePixel = 0
    ActiveFrame = Overlay

    -- Card central
    local Card = Instance.new("Frame", Overlay)
    Card.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    Card.Size = UDim2.new(0, 300, 0, 130)
    Card.Position = UDim2.new(0.5, -150, 0.5, -65)
    Card.BorderSizePixel = 0
    Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 14)

    local Stroke = Instance.new("UIStroke", Card)
    Stroke.Color = Color3.fromRGB(45, 45, 45)
    Stroke.Thickness = 1.2

    -- Linha accent no topo
    local TopBar = Instance.new("Frame", Card)
    TopBar.BackgroundColor3 = accent
    TopBar.Size = UDim2.new(1, 0, 0, 3)
    TopBar.Position = UDim2.new(0, 0, 0, 0)
    TopBar.BorderSizePixel = 0
    Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 14)

    -- Título
    local Title = Instance.new("TextLabel", Card)
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 20, 0, 18)
    Title.Size = UDim2.new(1, -40, 0, 26)
    Title.Font = Enum.Font.GothamBold
    Title.Text = title
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 16
    Title.TextXAlignment = Enum.TextXAlignment.Left

    -- Mensagem
    local Msg = Instance.new("TextLabel", Card)
    Msg.BackgroundTransparency = 1
    Msg.Position = UDim2.new(0, 20, 0, 48)
    Msg.Size = UDim2.new(1, -40, 0, 18)
    Msg.Font = Enum.Font.Gotham
    Msg.Text = message
    Msg.TextColor3 = Color3.fromRGB(150, 150, 150)
    Msg.TextSize = 12
    Msg.TextXAlignment = Enum.TextXAlignment.Left

    -- Barra de loading animada (loop)
    local BarBg = Instance.new("Frame", Card)
    BarBg.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    BarBg.Size = UDim2.new(1, -40, 0, 5)
    BarBg.Position = UDim2.new(0, 20, 0, 80)
    BarBg.BorderSizePixel = 0
    Instance.new("UICorner", BarBg).CornerRadius = UDim.new(1, 0)

    local Bar = Instance.new("Frame", BarBg)
    Bar.BackgroundColor3 = accent
    Bar.Size = UDim2.new(0, 0, 1, 0)
    Bar.BorderSizePixel = 0
    Instance.new("UICorner", Bar).CornerRadius = UDim.new(1, 0)

    -- Texto de status (atualizável)
    local Status = Instance.new("TextLabel", Card)
    Status.Name = "Status"
    Status.BackgroundTransparency = 1
    Status.Position = UDim2.new(0, 20, 0, 100)
    Status.Size = UDim2.new(1, -40, 0, 16)
    Status.Font = Enum.Font.Gotham
    Status.Text = "Initializing..."
    Status.TextColor3 = accent
    Status.TextSize = 11
    Status.TextXAlignment = Enum.TextXAlignment.Left

    -- Animação da barra em loop
    local running = true
    task.spawn(function()
        while running and Bar.Parent do
            TweenService:Create(Bar, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Size = UDim2.new(1, 0, 1, 0)
            }):Play()
            task.wait(0.65)
            TweenService:Create(Bar, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 0, 1, 0)
            }):Play()
            task.wait(0.45)
        end
    end)

    -- Fade in
    Overlay.BackgroundTransparency = 1
    TweenService:Create(Overlay, TweenInfo.new(0.4), {
        BackgroundTransparency = 0.4
    }):Play()

    -- Retorna referência para atualizar status
    return {
        SetStatus = function(text)
            if Status.Parent then Status.Text = text end
        end,
        SetMessage = function(text)
            if Msg.Parent then Msg.Text = text end
        end
    }
end

function Loading.Hide()
    if ActiveFrame then
        TweenService:Create(ActiveFrame, TweenInfo.new(0.4), {
            BackgroundTransparency = 1
        }):Play()
        task.delay(0.45, function()
            if ActiveFrame then
                ActiveFrame:Destroy()
                ActiveFrame = nil
            end
        end)
    end
end

return Loading
