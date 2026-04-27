-- // CreateTab.lua
-- // Uso:
-- // local UI = loadstring(...)()
-- // local window = UI.CreateWindow({ title, accent })
-- // local tab = window.CreateTab("Nome da Aba")
-- // tab.AddButton({ text, callback })
-- // tab.AddToggle({ text, default, callback })
-- // tab.AddSlider({ text, min, max, default, callback })
-- // tab.AddLabel(text)

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local GuiParent = CoreGui:FindFirstChild("RobloxGui") or LocalPlayer:WaitForChild("PlayerGui")

local UI = {}

function UI.CreateWindow(cfg)
    cfg = cfg or {}
    local title  = cfg.title  or "Script"
    local accent = cfg.accent or Color3.fromRGB(160, 100, 255)

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "TabUI_" .. title
    ScreenGui.DisplayOrder = 998
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = GuiParent

    -- Janela principal
    local Window = Instance.new("Frame", ScreenGui)
    Window.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    Window.Size = UDim2.new(0, 420, 0, 300)
    Window.Position = UDim2.new(0.5, -210, 0.5, -150)
    Window.BorderSizePixel = 0
    Instance.new("UICorner", Window).CornerRadius = UDim.new(0, 12)

    local Stroke = Instance.new("UIStroke", Window)
    Stroke.Color = Color3.fromRGB(45, 45, 45)
    Stroke.Thickness = 1.2

    -- Topbar
    local TopBar = Instance.new("Frame", Window)
    TopBar.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    TopBar.Size = UDim2.new(1, 0, 0, 38)
    TopBar.BorderSizePixel = 0
    Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 12)

    -- Linha accent no topo
    local AccentLine = Instance.new("Frame", TopBar)
    AccentLine.BackgroundColor3 = accent
    AccentLine.Size = UDim2.new(1, 0, 0, 2)
    AccentLine.Position = UDim2.new(0, 0, 0, 0)
    AccentLine.BorderSizePixel = 0
    Instance.new("UICorner", AccentLine).CornerRadius = UDim.new(0, 12)

    local TitleLabel = Instance.new("TextLabel", TopBar)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position = UDim2.new(0, 14, 0, 0)
    TitleLabel.Size = UDim2.new(1, -50, 1, 0)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Text = title
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextSize = 14
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

    -- Botão minimizar
    local MinBtn = Instance.new("TextButton", TopBar)
    MinBtn.BackgroundTransparency = 1
    MinBtn.Position = UDim2.new(1, -36, 0, 0)
    MinBtn.Size = UDim2.new(0, 36, 1, 0)
    MinBtn.Text = "−"
    MinBtn.TextColor3 = Color3.fromRGB(120, 120, 120)
    MinBtn.TextSize = 20

    -- Drag
    local dragging, dragStart, startPos
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Window.Position
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            Window.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    -- Minimizar
    local minimized = false
    local ContentFrame
    MinBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        TweenService:Create(Window, TweenInfo.new(0.3), {
            Size = minimized and UDim2.new(0, 420, 0, 38) or UDim2.new(0, 420, 0, 300)
        }):Play()
        MinBtn.Text = minimized and "+" or "−"
    end)

    -- Sidebar de abas
    local Sidebar = Instance.new("Frame", Window)
    Sidebar.BackgroundColor3 = Color3.fromRGB(16, 16, 16)
    Sidebar.Size = UDim2.new(0, 100, 1, -38)
    Sidebar.Position = UDim2.new(0, 0, 0, 38)
    Sidebar.BorderSizePixel = 0
    Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 12)

    local SidebarLayout = Instance.new("UIListLayout", Sidebar)
    SidebarLayout.Padding = UDim.new(0, 4)
    SidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    Instance.new("UIPadding", Sidebar).PaddingTop = UDim.new(0, 8)

    -- Área de conteúdo
    ContentFrame = Instance.new("Frame", Window)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Size = UDim2.new(1, -108, 1, -46)
    ContentFrame.Position = UDim2.new(0, 106, 0, 42)

    local activeTab = nil
    local activeBtn = nil

    local Window_API = {}

    function Window_API.CreateTab(tabName)
        -- Botão na sidebar
        local TabBtn = Instance.new("TextButton", Sidebar)
        TabBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
        TabBtn.Size = UDim2.new(1, -10, 0, 28)
        TabBtn.Font = Enum.Font.Gotham
        TabBtn.Text = tabName
        TabBtn.TextColor3 = Color3.fromRGB(140, 140, 140)
        TabBtn.TextSize = 11
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 7)

        -- Conteúdo da aba
        local TabContent = Instance.new("ScrollingFrame", ContentFrame)
        TabContent.BackgroundTransparency = 1
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabContent.ScrollBarThickness = 3
        TabContent.ScrollBarImageColor3 = accent
        TabContent.Visible = false
        TabContent.BorderSizePixel = 0

        local Layout = Instance.new("UIListLayout", TabContent)
        Layout.Padding = UDim.new(0, 6)
        Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        Instance.new("UIPadding", TabContent).PaddingTop = UDim.new(0, 6)

        Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabContent.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 12)
        end)

        local function SelectTab()
            if activeTab then activeTab.Visible = false end
            if activeBtn then
                activeBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
                activeBtn.TextColor3 = Color3.fromRGB(140, 140, 140)
            end
            TabContent.Visible = true
            TabBtn.BackgroundColor3 = Color3.fromRGB(30, 20, 45)
            TabBtn.TextColor3 = accent
            activeTab = TabContent
            activeBtn = TabBtn
        end

        TabBtn.MouseButton1Click:Connect(SelectTab)

        -- Seleciona a primeira aba automaticamente
        if not activeTab then SelectTab() end

        local Tab_API = {}

        local function MakeElement()
            local el = Instance.new("Frame", TabContent)
            el.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            el.Size = UDim2.new(1, -10, 0, 34)
            el.BorderSizePixel = 0
            Instance.new("UICorner", el).CornerRadius = UDim.new(0, 8)
            return el
        end

        function Tab_API.AddLabel(text)
            local el = MakeElement()
            el.BackgroundTransparency = 1
            el.Size = UDim2.new(1, -10, 0, 22)
            local lbl = Instance.new("TextLabel", el)
            lbl.BackgroundTransparency = 1
            lbl.Size = UDim2.new(1, -10, 1, 0)
            lbl.Position = UDim2.new(0, 8, 0, 0)
            lbl.Font = Enum.Font.GothamBold
            lbl.Text = text
            lbl.TextColor3 = accent
            lbl.TextSize = 11
            lbl.TextXAlignment = Enum.TextXAlignment.Left
        end

        function Tab_API.AddButton(cfg)
            cfg = cfg or {}
            local el = MakeElement()
            local btn = Instance.new("TextButton", el)
            btn.BackgroundTransparency = 1
            btn.Size = UDim2.new(1, 0, 1, 0)
            btn.Font = Enum.Font.Gotham
            btn.Text = cfg.text or "Button"
            btn.TextColor3 = Color3.fromRGB(220, 220, 220)
            btn.TextSize = 12

            btn.MouseEnter:Connect(function()
                TweenService:Create(el, TweenInfo.new(0.15), {
                    BackgroundColor3 = Color3.fromRGB(30, 20, 45)
                }):Play()
            end)
            btn.MouseLeave:Connect(function()
                TweenService:Create(el, TweenInfo.new(0.15), {
                    BackgroundColor3 = Color3.fromRGB(20, 20, 20)
                }):Play()
            end)
            btn.MouseButton1Click:Connect(function()
                if cfg.callback then pcall(cfg.callback) end
            end)
        end

        function Tab_API.AddToggle(cfg)
            cfg = cfg or {}
            local state = cfg.default or false
            local el = MakeElement()

            local lbl = Instance.new("TextLabel", el)
            lbl.BackgroundTransparency = 1
            lbl.Position = UDim2.new(0, 10, 0, 0)
            lbl.Size = UDim2.new(1, -60, 1, 0)
            lbl.Font = Enum.Font.Gotham
            lbl.Text = cfg.text or "Toggle"
            lbl.TextColor3 = Color3.fromRGB(200, 200, 200)
            lbl.TextSize = 12
            lbl.TextXAlignment = Enum.TextXAlignment.Left

            local ToggleBg = Instance.new("Frame", el)
            ToggleBg.Size = UDim2.new(0, 36, 0, 18)
            ToggleBg.Position = UDim2.new(1, -46, 0.5, -9)
            ToggleBg.BackgroundColor3 = state and accent or Color3.fromRGB(50, 50, 50)
            ToggleBg.BorderSizePixel = 0
            Instance.new("UICorner", ToggleBg).CornerRadius = UDim.new(1, 0)

            local Knob = Instance.new("Frame", ToggleBg)
            Knob.Size = UDim2.new(0, 14, 0, 14)
            Knob.Position = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
            Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Knob.BorderSizePixel = 0
            Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)

            local ClickArea = Instance.new("TextButton", el)
            ClickArea.BackgroundTransparency = 1
            ClickArea.Size = UDim2.new(1, 0, 1, 0)
            ClickArea.Text = ""
            ClickArea.MouseButton1Click:Connect(function()
                state = not state
                TweenService:Create(ToggleBg, TweenInfo.new(0.2), {
                    BackgroundColor3 = state and accent or Color3.fromRGB(50, 50, 50)
                }):Play()
                TweenService:Create(Knob, TweenInfo.new(0.2), {
                    Position = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
                }):Play()
                if cfg.callback then pcall(cfg.callback, state) end
            end)
        end

        function Tab_API.AddSlider(cfg)
            cfg = cfg or {}
            local min     = cfg.min     or 0
            local max     = cfg.max     or 100
            local default = cfg.default or min
            local value   = default

            local el = MakeElement()
            el.Size = UDim2.new(1, -10, 0, 48)

            local lbl = Instance.new("TextLabel", el)
            lbl.BackgroundTransparency = 1
            lbl.Position = UDim2.new(0, 10, 0, 4)
            lbl.Size = UDim2.new(1, -20, 0, 18)
            lbl.Font = Enum.Font.Gotham
            lbl.Text = (cfg.text or "Slider") .. ": " .. value
            lbl.TextColor3 = Color3.fromRGB(200, 200, 200)
            lbl.TextSize = 12
            lbl.TextXAlignment = Enum.TextXAlignment.Left

            local Track = Instance.new("Frame", el)
            Track.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            Track.Size = UDim2.new(1, -20, 0, 5)
            Track.Position = UDim2.new(0, 10, 0, 32)
            Track.BorderSizePixel = 0
            Instance.new("UICorner", Track).CornerRadius = UDim.new(1, 0)

            local Fill = Instance.new("Frame", Track)
            Fill.BackgroundColor3 = accent
            Fill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
            Fill.BorderSizePixel = 0
            Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)

            local Dragging = false
            Track.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = true end
            end)
            UIS.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = false end
            end)
            UIS.InputChanged:Connect(function(input)
                if Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local rel = math.clamp((input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
                    value = math.floor(min + (max - min) * rel)
                    Fill.Size = UDim2.new(rel, 0, 1, 0)
                    lbl.Text = (cfg.text or "Slider") .. ": " .. value
                    if cfg.callback then pcall(cfg.callback, value) end
                end
            end)
        end

        return Tab_API
    end

    return Window_API
end

return UI
