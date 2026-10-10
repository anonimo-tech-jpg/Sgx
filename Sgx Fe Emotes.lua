-- SAGAZx SCRIPTS GUI
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

-- Remove GUI antiga se existir
pcall(function()
    if CoreGui:FindFirstChild("SAGAZxSCRIPTS") then
        CoreGui.SAGAZxSCRIPTS:Destroy()
    end
end)

-- Variáveis
local scripts = {
    {
        Name = "Fe Emotes",
        URL = "https://raw.githubusercontent.com/anonimo-tech-jpg/Sgx/refs/heads/main/temporario"
    },
    {
        Name = "SAGAZx Hub",
        URL = "https://pastebin.com/raw/GaM0BNjL"
    },
    {
        Name = "SAGAZx Hub Skins",
        URL = "https://pastebin.com/raw/i6jxs035"
    }
}

-- Criar ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SAGAZxSCRIPTS"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = CoreGui

-- Frame principal
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 320, 0, 380)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Cantos arredondados do frame
local FrameCorner = Instance.new("UICorner")
FrameCorner.CornerRadius = UDim.new(0, 12)
FrameCorner.Parent = MainFrame

-- Borda gradiente
local FrameStroke = Instance.new("UIStroke")
FrameStroke.Thickness = 1.5
FrameStroke.Color = Color3.fromRGB(120, 60, 200)
FrameStroke.Parent = MainFrame

local StrokeGradient = Instance.new("UIGradient")
StrokeGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(180, 80, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 40, 200))
}
StrokeGradient.Rotation = 45
StrokeGradient.Parent = FrameStroke

-- Fundo gradiente sutil
local BgGradient = Instance.new("UIGradient")
BgGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(28, 24, 38)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 13, 22))
}
BgGradient.Rotation = 90
BgGradient.Parent = MainFrame

-- Barra de topo
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 48)
TopBar.BackgroundColor3 = Color3.fromRGB(28, 24, 38)
TopBar.BackgroundTransparency = 0.3
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TopBarCorner = Instance.new("UICorner")
TopBarCorner.CornerRadius = UDim.new(0, 12)
TopBarCorner.Parent = TopBar

-- Mascarar cantos de baixo do topbar
local TopBarMask = Instance.new("Frame")
TopBarMask.Size = UDim2.new(1, 0, 0, 15)
TopBarMask.Position = UDim2.new(0, 0, 1, -15)
TopBarMask.BackgroundColor3 = Color3.fromRGB(28, 24, 38)
TopBarMask.BackgroundTransparency = 0.3
TopBarMask.BorderSizePixel = 0
TopBarMask.Parent = TopBar

-- Título
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, -60, 1, 0)
Title.Position = UDim2.new(0, 20, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "SAGAZx SCRIPTS"
Title.TextColor3 = Color3.fromRGB(230, 215, 255)
Title.TextSize = 20
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

local TitleGradient = Instance.new("UIGradient")
TitleGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 130, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(130, 80, 230))
}
TitleGradient.Parent = Title

-- Botão X
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 32, 0, 32)
CloseButton.Position = UDim2.new(1, -42, 0.5, -16)
CloseButton.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
CloseButton.BorderSizePixel = 0
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 18
CloseButton.Font = Enum.Font.GothamBold
CloseButton.AutoButtonColor = false
CloseButton.Parent = TopBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseButton

CloseButton.MouseEnter:Connect(function()
    TweenService:Create(CloseButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 80, 80)}):Play()
end)

CloseButton.MouseLeave:Connect(function()
    TweenService:Create(CloseButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(220, 60, 60)}):Play()
end)

CloseButton.MouseButton1Click:Connect(function()
    TweenService:Create(MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0)
    }):Play()
    task.wait(0.25)
    ScreenGui:Destroy()
end)

-- Container dos botões
local ButtonContainer = Instance.new("Frame")
ButtonContainer.Name = "ButtonContainer"
ButtonContainer.Size = UDim2.new(1, -30, 1, -78)
ButtonContainer.Position = UDim2.new(0, 15, 0, 63)
ButtonContainer.BackgroundTransparency = 1
ButtonContainer.Parent = MainFrame

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 12)
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.Parent = ButtonContainer

-- Função para criar botão
local function CreateButton(scriptData, order)
    local Button = Instance.new("TextButton")
    Button.Name = scriptData.Name
    Button.Size = UDim2.new(1, 0, 0, 58)
    Button.BackgroundColor3 = Color3.fromRGB(55, 48, 75)
    Button.BorderSizePixel = 0
    Button.Text = ""
    Button.AutoButtonColor = false
    Button.LayoutOrder = order
    Button.Parent = ButtonContainer

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 10)
    BtnCorner.Parent = Button

    -- Borda visível
    local BtnStroke = Instance.new("UIStroke")
    BtnStroke.Thickness = 1.8
    BtnStroke.Color = Color3.fromRGB(170, 100, 255)
    BtnStroke.Transparency = 0.2
    BtnStroke.Parent = Button

    local BtnGradient = Instance.new("UIGradient")
    BtnGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(65, 55, 90)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(45, 38, 65))
    }
    BtnGradient.Rotation = 45
    BtnGradient.Parent = Button

    -- Barrinha roxa no lado esquerdo
    local LeftBar = Instance.new("Frame")
    LeftBar.Name = "LeftBar"
    LeftBar.Size = UDim2.new(0, 5, 0.7, 0)
    LeftBar.Position = UDim2.new(0, 6, 0.15, 0)
    LeftBar.BackgroundColor3 = Color3.fromRGB(180, 90, 255)
    LeftBar.BorderSizePixel = 0
    LeftBar.ZIndex = 2
    LeftBar.Parent = Button

    local LeftBarCorner = Instance.new("UICorner")
    LeftBarCorner.CornerRadius = UDim.new(1, 0)
    LeftBarCorner.Parent = LeftBar

    local LeftBarGradient = Instance.new("UIGradient")
    LeftBarGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 130, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(130, 60, 230))
    }
    LeftBarGradient.Rotation = 90
    LeftBarGradient.Parent = LeftBar

    -- Brilho na barrinha
    local LeftBarGlow = Instance.new("UIStroke")
    LeftBarGlow.Thickness = 1
    LeftBarGlow.Color = Color3.fromRGB(220, 160, 255)
    LeftBarGlow.Transparency = 0.4
    LeftBarGlow.Parent = LeftBar

    local BtnLabel = Instance.new("TextLabel")
    BtnLabel.Size = UDim2.new(1, -30, 1, 0)
    BtnLabel.Position = UDim2.new(0, 22, 0, 0)
    BtnLabel.BackgroundTransparency = 1
    BtnLabel.Text = scriptData.Name
    BtnLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    BtnLabel.TextSize = 17
    BtnLabel.Font = Enum.Font.GothamBold
    BtnLabel.TextXAlignment = Enum.TextXAlignment.Left
    BtnLabel.ZIndex = 2
    BtnLabel.Parent = Button

    Button.MouseEnter:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(90, 70, 130)}):Play()
        TweenService:Create(BtnStroke, TweenInfo.new(0.2), {Transparency = 0, Color = Color3.fromRGB(200, 130, 255), Thickness = 2.5}):Play()
        TweenService:Create(LeftBar, TweenInfo.new(0.2), {Size = UDim2.new(0, 6, 0.85, 0), Position = UDim2.new(0, 6, 0.075, 0)}):Play()
    end)

    Button.MouseLeave:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(55, 48, 75)}):Play()
        TweenService:Create(BtnStroke, TweenInfo.new(0.2), {Transparency = 0.2, Color = Color3.fromRGB(170, 100, 255), Thickness = 1.8}):Play()
        TweenService:Create(LeftBar, TweenInfo.new(0.2), {Size = UDim2.new(0, 5, 0.7, 0), Position = UDim2.new(0, 6, 0.15, 0)}):Play()
    end)

    Button.MouseButton1Click:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.1), {Size = UDim2.new(0.97, 0, 0, 58)}):Play()
        task.wait(0.1)
        TweenService:Create(Button, TweenInfo.new(0.1), {Size = UDim2.new(1, 0, 0, 58)}):Play()

        pcall(function()
            loadstring(game:HttpGet(scriptData.URL))()
        end)
    end)

    return Button
end

-- Criar os botões
for i, scriptData in ipairs(scripts) do
    CreateButton(scriptData, i)
end