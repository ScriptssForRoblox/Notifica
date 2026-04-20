local GoldLib = {} -- Cria a tabela da biblioteca

local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local GuiParent = CoreGui:FindFirstChild("RobloxGui") or LocalPlayer:WaitForChild("PlayerGui")

local NotifyGui = GuiParent:FindFirstChild("GoldNotifyGui")
if not NotifyGui then
    NotifyGui = Instance.new("ScreenGui")
    NotifyGui.Name = "GoldNotifyGui"
    NotifyGui.DisplayOrder = 999
    NotifyGui.Parent = GuiParent
end

-- A função agora faz parte da GoldLib
function GoldLib:Notify(title, message, duration, customIcon)
    local assetId = customIcon or "rbxthumb://type=Asset&id=9267155972&w=150&h=150"
    local spacing = 75

    for _, existingFrame in ipairs(NotifyGui:GetChildren()) do
        if existingFrame:IsA("Frame") then
            TweenService:Create(existingFrame, TweenInfo.new(0.3), {
                Position = existingFrame.Position - UDim2.new(0, 0, 0, spacing)
            }):Play()
        end
    end

    local NotifyFrame = Instance.new("Frame")
    NotifyFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    NotifyFrame.Size = UDim2.new(0, 280, 0, 65)
    NotifyFrame.Position = UDim2.new(1, 30, 1, -100)
    NotifyFrame.Parent = NotifyGui
    Instance.new("UICorner", NotifyFrame).CornerRadius = UDim.new(0, 10)
    local Stroke = Instance.new("UIStroke", NotifyFrame)
    Stroke.Color = Color3.fromRGB(45, 45, 45)
    Stroke.Thickness = 1.2

    local Icon = Instance.new("ImageLabel", NotifyFrame)
    Icon.BackgroundTransparency = 1
    Icon.Position = UDim2.new(0, 12, 0, 12)
    Icon.Size = UDim2.new(0, 24, 0, 24)
    Icon.Image = assetId 
    if customIcon then Instance.new("UICorner", Icon).CornerRadius = UDim.new(1, 0) end

    local TitleLabel = Instance.new("TextLabel", NotifyFrame)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position = UDim2.new(0, 42, 0, 12)
    TitleLabel.Size = UDim2.new(0, 180, 0, 24)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Text = title
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextSize = 14
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

    local TextLabel = Instance.new("TextLabel", NotifyFrame)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Position = UDim2.new(0, 12, 0, 38)
    TextLabel.Size = UDim2.new(1, -24, 0, 20)
    TextLabel.Font = Enum.Font.Gotham
    TextLabel.Text = message
    TextLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    TextLabel.TextSize = 11
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left

    local function Exit()
        local currentY = NotifyFrame.Position.Y.Offset
        for _, otherFrame in ipairs(NotifyGui:GetChildren()) do
            if otherFrame:IsA("Frame") and otherFrame ~= NotifyFrame then
                if otherFrame.Position.Y.Offset < currentY then
                    TweenService:Create(otherFrame, TweenInfo.new(0.3), {
                        Position = otherFrame.Position + UDim2.new(0, 0, 0, spacing)
                    }):Play()
                end
            end
        end
        local t = TweenService:Create(NotifyFrame, TweenInfo.new(0.4), {Position = NotifyFrame.Position + UDim2.new(0, 350, 0, 0)})
        t:Play()
        t.Completed:Connect(function() NotifyFrame:Destroy() end)
    end

    local CloseBtn = Instance.new("TextButton", NotifyFrame)
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Position = UDim2.new(1, -30, 0, 8)
    CloseBtn.Size = UDim2.new(0, 25, 0, 25)
    CloseBtn.Text = "×"
    CloseBtn.TextColor3 = Color3.fromRGB(120, 120, 120)
    CloseBtn.TextSize = 22
    CloseBtn.MouseButton1Click:Connect(Exit)

    TweenService:Create(NotifyFrame, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(1, -300, 1, -100)}):Play()
    task.delay(duration or 5, function() if NotifyFrame.Parent then Exit() end end)
end

return GoldLib -- Importante: permite que outros scripts usem a Lib
