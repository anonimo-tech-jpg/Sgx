
-- ====================================================================
-- 🌍 TRADUTOR SIMPLIFICADO — SAGAZx HUB
-- ====================================================================

local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")

local TARGET_GUI = "SAGAZx HUB"
local LANG_FILE = "SAGAZx HUB Lib/language.json"

-- ========== CARREGAMENTO DAS TRADUÇÕES REMOTE ==========
local Translations = { Frases = { ["pt"] = {}, ["en"] = {}, ["es"] = {}, ["it"] = {} } }

local ok, remoteTable = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/psychoSAGAZ/SAGAZx-HUB/refs/heads/main/Teste%20part%20Redz"))()
end)

if ok and type(remoteTable) == "table" then
    Translations.Frases = remoteTable
end

-- Determina idioma padrão do jogo ou do arquivo salvo
local defaultLocale = (game.Players.LocalPlayer.LocaleId or "en-US"):sub(1, 2):lower()
Translations.Idioma = Translations.Frases[defaultLocale] and defaultLocale or "en"

local function SaveLanguage(lang)
    if writefile then
        pcall(function() writefile(LANG_FILE, HttpService:JSONEncode({ language = lang })) end)
    end
end

local function LoadLanguage()
    if isfile and isfile(LANG_FILE) then
        local s, data = pcall(function() return HttpService:JSONEncode(readfile(LANG_FILE)) end)
        if s and data and data.language and Translations.Frases[data.language] then
            return data.language
        end
    end
end

Translations.Idioma = LoadLanguage() or Translations.Idioma

-- ====================================================================
-- ⚙️ MOTOR DE TRADUÇÃO DAS GUIS
-- ====================================================================

local function TranslateText(text)
    if not text or text == "" then return text end
    local dic = Translations.Frases[Translations.Idioma]
    return (dic and dic[text]) or text
end

local function ApplyTranslation(obj)
    if not (obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox")) then return end

    -- TextLabel e TextButton
    if obj:IsA("TextLabel") or obj:IsA("TextButton") then
        if not obj:GetAttribute("_OriginalText") and obj.Text ~= "" then
            obj:SetAttribute("_OriginalText", obj.Text)
        end

        local original = obj:GetAttribute("_OriginalText")
        if original then
            obj.Text = TranslateText(original)
        end
    end

    -- TextBox (Apenas Placeholder)
    if obj:IsA("TextBox") then
        if not obj:GetAttribute("_OriginalPlaceholder") and obj.PlaceholderText ~= "" then
            obj:SetAttribute("_OriginalPlaceholder", obj.PlaceholderText)
        end

        local origPh = obj:GetAttribute("_OriginalPlaceholder")
        if origPh and not obj:IsFocused() then
            obj.PlaceholderText = TranslateText(origPh)
        end
    end
end

local function TranslateAll()
    local gui = CoreGui:FindFirstChild(TARGET_GUI) or CoreGui:FindFirstChild("Redz Library")
    if not gui then return end

    for _, descendant in ipairs(gui:GetDescendants()) do
        ApplyTranslation(descendant)
    end
end

-- ====================================================================
-- 🌐 API PÚBLICA (Translator)
-- ====================================================================

getgenv().Translator = {
    GetLanguage = function() 
        return Translations.Idioma 
    end,

    SetLanguage = function(lang)
        if not Translations.Frases[lang] then return end
        Translations.Idioma = lang
        SaveLanguage(lang)
        TranslateAll()
    end,

    Translate = TranslateText
}

-- ====================================================================
-- 🚀 AUTOLOAD E CONEXÕES
-- ====================================================================

task.spawn(function()
    local gui = CoreGui:WaitForChild(TARGET_GUI, 10) or CoreGui:WaitForChild("Redz Library", 5)
    if not gui then return end

    -- Tradução Inicial
    TranslateAll()

    -- Traduz dinamicamente novos elementos inseridos (Dropdowns, Notificações, etc)
    gui.DescendantAdded:Connect(function(descendant)
        task.wait(0.05)
        ApplyTranslation(descendant)
    end)
end)


----------------------------------------------------------------------------------------------------------------
-----------------------------------------Aba Redz Lib-----------------------------------------------------
----------------------------------------------------------------------------------------------------------------
local MyLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/anonimo-tech-jpg/Redz-Lib/refs/heads/main/Redz%20lib.lua"))()

local Window = MyLibrary:MakeWindow({
    Title = "SAGAZx Hub",
    SubTitle = "by SAGAZx😎",
    SaveFolder = "SAGAZxConfig"
})


----------------------------------------------------------------------------------------------------------------
-----------------------------------------Aba Home-----------------------------------------------------
----------------------------------------------------------------------------------------------------------------
local Tab1 = Window:MakeTab({ "| Início", "menu" })


Tab1:AddDiscordInvite({
    Name = "SAGAZx",
    Description = "",
    Logo = "rbxassetid://86050226751861",
    ["Tik Tok"] = "tiktok.com/@sagazx_xd",
    Discord = "https://discord.gg/JHHZUtUeT8"
})

Tab1:AddSection({Name = "Perfil"})


local function detectExecutor()
    if identifyexecutor then
        return identifyexecutor()
    elseif syn then
        return "Synapse X4"
    elseif KRNL_LOADED then
        return "KRNL4"
    elseif is_sirhurt_closure then
        return "SirHurt"
    elseif pebc_execute then
        return "ProtoSmasher"
    elseif getexecutorname then
        return getexecutorname()
    else
        return "Executor Desconhecido"
    end
end

local executorName = detectExecutor()



local Paragraph = Tab1:AddParagraph({"Execultor", executorName})

local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Pega nickname do jogador
local nickname = player.Name 

-- Novo bloco igual ao do Executor
Tab1:AddParagraph({"Nickname", nickname})
Tab1:AddParagraph({"Versão", "3.0.1"})

Tab1:AddSection({Name = "Outros"}) 
Tab1:AddButton({
    Name = "Deletar Brookhaven News",
    Description = "Faz Muira Zuada",
    Callback = function()
        local obj = workspace:FindFirstChild("BrookavenNewsSign")

        if obj then
            obj:Destroy()
            print("BrookavenNewsSign deletado!")
        else
            warn("Objeto não encontrado.")
        end
    end
})

----------------------------------------------------------------------------------------------------------------
-----------------------------------------Aba Cliente-----------------------------------------------------
----------------------------------------------------------------------------------------------------------------

-- ==========================================
-- SERVIÇOS E VARIÁVEIS GLOBAIS (OTIMIZADOS)
-- ==========================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local cam = workspace.CurrentCamera

-- Variaveis de Controle Geral
local InfiniteJumpEnabled = false
local noclipEnabled = false
local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

LocalPlayer.CharacterAdded:Connect(function(char)
    character = char
end)

-- Loop do Noclip (Unificado)
RunService.Stepped:Connect(function()
    if noclipEnabled and character then
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end)

-- ==========================================
-- ABA 2 - CLIENTE
-- ==========================================
local Tab2 = Window:MakeTab({ "| Cliente", "user" })

Tab2:AddSlider({
    Name = "VELOCIDADE",
    Increase = 1,
    MinValue = 16,
    MaxValue = 1000,
    Default = 16,
    Callback = function(Value)
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then humanoid.WalkSpeed = Value end
    end
})
 
Tab2:AddSlider({
    Name = "PULO",
    Increase = 1,
    MinValue = 50,
    MaxValue = 500,
    Default = 50,
    Callback = function(Value)
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then humanoid.JumpPower = Value end
    end
})
 
Tab2:AddSlider({
    Name = "GRAVIDADE",
    Increase = 1,
    MinValue = 0,
    MaxValue = 10000,
    Default = 196.2,
    Callback = function(Value)
        Workspace.Gravity = Value
    end
})

-- Loop Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if InfiniteJumpEnabled and character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

Tab2:AddButton({
    Name = "REDEFINIR VELOCIDADE/GRAVIDADE/ PULO",
    Callback = function()
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = 16
            humanoid.JumpPower = 50
        end
        Workspace.Gravity = 196.2
        InfiniteJumpEnabled = false
    end
})

Tab2:AddSection({ Name = "Outros" })

local SpinConnection
local SpinSpeed = 0.5

Tab2:AddTextBox({
    Name = "Velocidade do Spin",
    PlaceholderText = "Digite a velocidade",
    ClearText = false,
    Callback = function(Value)
        local Number = tonumber(Value)
        if Number then SpinSpeed = Number end
    end
})

Tab2:AddToggle({
    Name = "Spin",
    Description = "Gira o Personagem Infinitamente",
    Default = false,
    Callback = function(Value)
        if SpinConnection then SpinConnection:Disconnect() end
        if Value then
            SpinConnection = RunService.RenderStepped:Connect(function(dt)
                local Root = character and character:FindFirstChild("HumanoidRootPart")
                if Root then
                    Root.CFrame = Root.CFrame * CFrame.Angles(0, math.rad(360 * SpinSpeed * dt), 0)
                end
            end)
        else
            SpinConnection = nil
        end
    end
})

Tab2:AddToggle({
    Name = "PULO INFINITO",
    Default = false,
    Callback = function(Value)
       InfiniteJumpEnabled = Value
    end
})

----------------------------------------------------
-- FLOAT V1 + V2 (SAGAZx HUB) - autocontido
----------------------------------------------------
do
    local Players     = game:GetService("Players")
    local RunService  = game:GetService("RunService")
    local LocalPlayer = Players.LocalPlayer

    local function makeFloat(isV2)
        local state = {
            Enabled = false,
            Part = nil,
            Render = nil,
            Jump = nil,
            TargetY = 0,
            IsV2 = isV2
        }

        local function disconnectAll()
            if state.Render then state.Render:Disconnect(); state.Render = nil end
            if state.Jump   then state.Jump:Disconnect();   state.Jump   = nil end
        end

        local function disable()
            state.Enabled = false
            disconnectAll()
            if state.Part then state.Part:Destroy(); state.Part = nil end
        end

        local function enable()
            if state.Enabled then return end
            local char = LocalPlayer.Character
            if not char then return end

            local root = char:FindFirstChild("HumanoidRootPart")
            local hum  = char:FindFirstChildOfClass("Humanoid")
            if not root or not hum then return end

            state.Enabled = true
            state.TargetY = root.Position.Y - (hum.HipHeight + 1.5)

            state.Part = Instance.new("Part")
            state.Part.Name          = "SAGAZ_Float_" .. (isV2 and "V2" or "V1")
            state.Part.Size          = Vector3.new(7, 1, 7)
            state.Part.Transparency  = 1
            state.Part.Anchored      = true
            state.Part.CanCollide    = true
            state.Part.Parent        = workspace

            -- Pulo
            state.Jump = hum.Jumping:Connect(function()
                if not state.Part then return end
                state.Part.CanCollide = false

                task.spawn(function()
                    local r = root
                    while r and r.Parent and r.AssemblyLinearVelocity.Y > 0 do
                        task.wait()
                    end
                    if state.Part then
                        if not isV2 and r and r.Parent then
                            local h = char:FindFirstChildOfClass("Humanoid")
                            if h then
                                state.TargetY = r.Position.Y - (h.HipHeight + 1.5)
                            end
                        end
                        state.Part.CanCollide = true
                    end
                end)
            end)

            -- Render
            state.Render = RunService.RenderStepped:Connect(function()
                local c = LocalPlayer.Character
                if not state.Part or not c then return end
                local r = c:FindFirstChild("HumanoidRootPart")
                local h = c:FindFirstChildOfClass("Humanoid")
                if not r or not h then return end

                state.Part.Position = Vector3.new(r.Position.X, state.TargetY, r.Position.Z)

                local st = h:GetState()
                local grounded =
                    st == Enum.HumanoidStateType.Running
                    or st == Enum.HumanoidStateType.RunningNoPhysics
                    or st == Enum.HumanoidStateType.Landed
                    or st == Enum.HumanoidStateType.Seated

                if grounded and state.Part.CanCollide then
                    r.AssemblyLinearVelocity =
                        Vector3.new(r.AssemblyLinearVelocity.X, 0, r.AssemblyLinearVelocity.Z)
                end
            end)
        end

        return {
            SetState = function(v) if v then enable() else disable() end end,
            Disable  = disable
        }
    end

    local FloatV1 = makeFloat(false)
    local FloatV2 = makeFloat(true)

    LocalPlayer.CharacterAdded:Connect(function()
        FloatV1.Disable()
        FloatV2.Disable()
    end)

    Tab2:AddToggle({
        Name = "Float",
        Default = false,
        Callback = function(v) FloatV1.SetState(v) end
    })

    Tab2:AddToggle({
        Name = "Float v2",
        Default = false,
        Callback = function(v) FloatV2.SetState(v) end
    })
end

Tab2:AddToggle({
    Name = "NOCLIP",
    Description = "ATRAVESSA PAREDES",
    Default = false,
    Callback = function(v)
        noclipEnabled = v
    end
})

Tab2:AddToggle({
    Name = "FullBright",
    Description = "Deixa o Mapa iluminado",
    Default = false,
    Callback = function(Value)
        if Value then
            Lighting.Ambient = Color3.fromRGB(255, 255, 255)
            Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
            Lighting.Brightness = 2
        else
            Lighting.Ambient = Color3.fromRGB(127, 127, 127)
            Lighting.OutdoorAmbient = Color3.fromRGB(127, 127, 127)
            Lighting.Brightness = 1
        end
    end
})

local Swimming = false
local OldGravity = Workspace.Gravity
local SwimBeat
local GravReset

Tab2:AddToggle({
    Name = "Swim",
    Description = "Nadar Sem Água",
    Default = false,
    Callback = function(Value)
        if not character then return end
        local Humanoid = character:FindFirstChildWhichIsA("Humanoid")
        local Root = character:FindFirstChild("HumanoidRootPart")
        if not Humanoid or not Root then return end

        if Value then
            OldGravity = Workspace.Gravity
            Workspace.Gravity = 0

            GravReset = Humanoid.Died:Connect(function()
                Workspace.Gravity = OldGravity
                Swimming = false
            end)

            for _, State in ipairs(Enum.HumanoidStateType:GetEnumItems()) do
                if State ~= Enum.HumanoidStateType.None then
                    Humanoid:SetStateEnabled(State, false)
                end
            end

            Humanoid:ChangeState(Enum.HumanoidStateType.Swimming)

            SwimBeat = RunService.Heartbeat:Connect(function()
                if Humanoid.MoveDirection.Magnitude > 0 then
                    Root.Velocity = Humanoid.MoveDirection * 20
                elseif UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    Root.Velocity = Vector3.new(0, 20, 0)
                else
                    Root.Velocity = Vector3.zero
                end
                Humanoid:ChangeState(Enum.HumanoidStateType.Swimming)
            end)
            Swimming = true
        else
            Workspace.Gravity = OldGravity
            Swimming = false

            if GravReset then GravReset:Disconnect() GravReset = nil end
            if SwimBeat then SwimBeat:Disconnect() SwimBeat = nil end

            for _, State in ipairs(Enum.HumanoidStateType:GetEnumItems()) do
                if State ~= Enum.HumanoidStateType.None then
                    Humanoid:SetStateEnabled(State, true)
                end
            end
        end
    end
})

local LayConnection
Tab2:AddToggle({
    Name = "Deitar",
    Description = "Deita no Chão",
    Default = false,
    Callback = function(Value)
        if not character then return end
        local Humanoid = character:FindFirstChildWhichIsA("Humanoid")
        local Root = character:FindFirstChild("HumanoidRootPart")
        if not Humanoid or not Root then return end

        if Value then
            LayConnection = RunService.Heartbeat:Connect(function()
                Humanoid.PlatformStand = true
                Root.CFrame = CFrame.new(Root.Position) * CFrame.Angles(math.rad(90), Root.Orientation.Y * math.pi / 180, 0)
            end)
        else
            if LayConnection then LayConnection:Disconnect() LayConnection = nil end
            Humanoid.PlatformStand = false
            Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
    end
})

Tab2:AddButton({
    Name = "Jerk",
    Callback = function()
        loadstring(game:HttpGet("https://pastefy.app/YZoglOyJ/raw"))()
    end
})

Tab2:AddButton({
    Name = "Sit",
    Description = "Faz o Personagem Sentar",
    Callback = function()
        if character then
            local Humanoid = character:FindFirstChildWhichIsA("Humanoid")
            if Humanoid then Humanoid.Sit = true end
        end
    end
})

Tab2:AddButton({
    Name = "Tp Tool",
    Description = "Teleporta Você Para Onde Você Clicar",
    Callback = function()
        if LocalPlayer.Backpack:FindFirstChild("Tp Tool") then return end
        local Mouse = LocalPlayer:GetMouse()
        local Tool = Instance.new("Tool")
        Tool.Name = "Tp Tool"
        Tool.RequiresHandle = false
        Tool.TextureId = "rbxassetid://1234567890"

        Tool.Activated:Connect(function()
            local Root = character and character:FindFirstChild("HumanoidRootPart")
            if Root then
                Root.CFrame = CFrame.new(Mouse.Hit.Position + Vector3.new(0, 2.5, 0))
            end
        end)
        Tool.Parent = LocalPlayer.Backpack
    end
})

-- ==========================================
-- SEÇÃO ESPIÃO (COLOCADA NA COREGUI)
-- ==========================================
Tab2:AddSection({ Name = "Espião" })

local viewing = false
local playerList = {}
local currentIndex = 1
local screenGui
local lastPlayerName = nil

local function UpdatePlayerList()
    playerList = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            table.insert(playerList, plr)
        end
    end
    table.sort(playerList, function(a, b) return a.Name < b.Name end)
end

local function GetCurrentPlayer()
    return playerList[currentIndex]
end

local function Spectate(plr)
    if not plr then return end
    local char = plr.Character or plr.CharacterAdded:Wait()
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        cam.CameraSubject = hum
    end
end

local function ResetCamera()
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            cam.CameraSubject = hum
        end
    end
end

local function CreateUI()
    if screenGui then screenGui:Destroy() end

    screenGui = Instance.new("ScreenGui")
    screenGui.Name = "EspiaoCoreGui"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = (gethui and gethui()) or CoreGui

    local back = Instance.new("TextButton")
    back.Size = UDim2.new(0, 60, 0, 60)
    back.Position = UDim2.new(0, 412, 0, 425)
    back.Text = "<"
    back.TextSize = 50
    back.BackgroundColor3 = Color3.fromRGB(108, 108, 108)
    back.Parent = screenGui
    Instance.new("UICorner", back)

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 200, 0, 60)
    frame.Position = UDim2.new(1, -688, 0, 425)
    frame.BackgroundColor3 = Color3.fromRGB(108, 108, 108)
    frame.Parent = screenGui
    Instance.new("UICorner", frame)

    local img = Instance.new("ImageLabel")
    img.Size = UDim2.new(0, 40, 0, 40)
    img.Position = UDim2.new(0, 10, 0, 10)
    img.BackgroundTransparency = 1
    img.Parent = frame

    local titulo = Instance.new("TextLabel")
    titulo.Size = UDim2.new(1, -60, 0, 20)
    titulo.Position = UDim2.new(0, 60, 0, 8)
    titulo.Text = "Espionando:"
    titulo.TextColor3 = Color3.new(1, 1, 1)
    titulo.BackgroundTransparency = 1
    titulo.Font = Enum.Font.GothamBold
    titulo.TextSize = 15
    titulo.TextXAlignment = Enum.TextXAlignment.Left
    titulo.Parent = frame

    local username = Instance.new("TextLabel")
    username.Size = UDim2.new(1, -60, 0, 18)
    username.Position = UDim2.new(0, 60, 0, 30)
    username.BackgroundTransparency = 1
    username.TextColor3 = Color3.new(1, 1, 1)
    username.Font = Enum.Font.Gotham
    username.TextSize = 12
    username.TextXAlignment = Enum.TextXAlignment.Left
    username.Parent = frame

    local nextBtn = Instance.new("TextButton")
    nextBtn.Size = UDim2.new(0, 60, 0, 60)
    nextBtn.Position = UDim2.new(0, 685, 0, 425)
    nextBtn.Text = ">"
    nextBtn.TextSize = 50
    nextBtn.BackgroundColor3 = Color3.fromRGB(108, 108, 108)
    nextBtn.Parent = screenGui
    Instance.new("UICorner", nextBtn)

    local function UpdateUI()
        local plr = GetCurrentPlayer()
        if not plr then
            username.Text = "Nenhum player"
            img.Image = ""
            return
        end
        lastPlayerName = plr.Name
        username.Text = "@" .. plr.Name
        img.Image = string.format(
            "https://www.roblox.com/headshot-thumbnail/image?userId=%d&width=150&height=150&format=png",
            plr.UserId
        )
        Spectate(plr)
    end

    back.MouseButton1Click:Connect(function()
        if #playerList == 0 then return end
        currentIndex = currentIndex - 1
        if currentIndex < 1 then currentIndex = #playerList end
        UpdateUI()
    end)

    nextBtn.MouseButton1Click:Connect(function()
        if #playerList == 0 then return end
        currentIndex = currentIndex + 1
        if currentIndex > #playerList then currentIndex = 1 end
        UpdateUI()
    end)

    UpdateUI()
end

Players.PlayerAdded:Connect(UpdatePlayerList)
Players.PlayerRemoving:Connect(UpdatePlayerList)

-- ==========================================
-- GERENCIADOR DE ESP & CORES UNIFICADO
-- ==========================================
local selectedColor = "RGB"
local espEnabled = false
local billboardGuis = {}
local espConnections = {}

local function getESPColor()
    if selectedColor == "RGB" then
        local h = (tick() % 5) / 5
        return Color3.fromHSV(h, 1, 1)
    elseif selectedColor == "Preto" then return Color3.fromRGB(0, 0, 0)
    elseif selectedColor == "Branco" then return Color3.fromRGB(255, 255, 255)
    elseif selectedColor == "Vermelho" then return Color3.fromRGB(255, 0, 0)
    elseif selectedColor == "Verde" then return Color3.fromRGB(0, 255, 0)
    elseif selectedColor == "Azul" then return Color3.fromRGB(0, 170, 255)
    elseif selectedColor == "Amarelo" then return Color3.fromRGB(255, 255, 0)
    elseif selectedColor == "Rosa" then return Color3.fromRGB(255, 105, 180)
    elseif selectedColor == "Roxo" then return Color3.fromRGB(128, 0, 128)
    end
    return Color3.new(1, 1, 1)
end

Tab2:AddDropdown({
    Name = "COR DO ESP",
    Default = "RGB",
    Options = { "RGB", "Branco", "Preto", "Vermelho", "Verde", "Azul", "Amarelo", "Rosa", "Roxo" },
    Search = true,
    Callback = function(value)
        selectedColor = value
        local color = getESPColor()
        for _, gui in pairs(billboardGuis) do
            if gui and gui:FindFirstChild("TextLabel") then
                gui.TextLabel.TextColor3 = color
            end
        end
    end
})

Tab2:AddToggle({
    Name = "Espiona Todos Os Players",
    Default = false,
    Callback = function(Value)
        viewing = Value
        if viewing then
            UpdatePlayerList()
            if #playerList == 0 then return end
            currentIndex = 1
            if lastPlayerName then
                for i, plr in ipairs(playerList) do
                    if plr.Name == lastPlayerName then
                        currentIndex = i
                        break
                    end
                end
            end
            CreateUI()
            Spectate(GetCurrentPlayer())
        else
            if screenGui then
                screenGui:Destroy()
                screenGui = nil
            end
            ResetCamera()
        end
    end
})

-- Funções ESP Players
local function updateESP(player)
    if player == LocalPlayer or not espEnabled then return end
    local char = player.Character
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end

    local gui = billboardGuis[player]
    if gui and gui:FindFirstChild("TextLabel") then
        gui.TextLabel.TextColor3 = getESPColor()
        return
    elseif gui then
        gui:Destroy()
    end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP_Billboard"
    billboard.Adornee = head
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = head

    local textLabel = Instance.new("TextLabel")
    textLabel.Name = "TextLabel"
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.TextStrokeTransparency = 0.5
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.TextSize = 14
    textLabel.Text = player.Name .. " | " .. player.AccountAge .. " dias"
    textLabel.TextColor3 = getESPColor()
    textLabel.Parent = billboard

    billboardGuis[player] = billboard
end

local function removeESP(player)
    if billboardGuis[player] then
        billboardGuis[player]:Destroy()
        billboardGuis[player] = nil
    end
end

Tab2:AddToggle({
    Name = "ESP PLAYERS",
    Description = "MOSTRA NOME E DIAS DOS PLAYERS",
    Default = false,
    Callback = function(value)
        espEnabled = value

        -- Desconecta tudo antes, independente de ligar ou desligar
        for _, conn in pairs(espConnections) do
            if typeof(conn) == "RBXScriptConnection" then
                conn:Disconnect()
            end
        end
        espConnections = {}

        if espEnabled then
            for _, player in pairs(Players:GetPlayers()) do
                updateESP(player)
            end

            table.insert(espConnections, Players.PlayerAdded:Connect(function(p)
                updateESP(p)
                table.insert(espConnections, p.CharacterAdded:Connect(function()
                    updateESP(p)
                end))
            end))

            table.insert(espConnections, Players.PlayerRemoving:Connect(removeESP))

            -- Atualiza RGB
            task.spawn(function()
                while espEnabled do
                    if selectedColor == "RGB" then
                        local color = getESPColor()
                        for _, gui in pairs(billboardGuis) do
                            if gui and gui:FindFirstChild("TextLabel") then
                                gui.TextLabel.TextColor3 = color
                            end
                        end
                    end
                    task.wait(0.1)
                end
            end)
        else
            for _, player in pairs(Players:GetPlayers()) do
                removeESP(player)
            end
            billboardGuis = {}
        end
    end
})
----------------------------------------------------------------------------------------------------------------
-----------------------------------------Aba Jogadores-----------------------------------------------------
----------------------------------------------------------------------------------------------------------------

local Tab3= Window:MakeTab({ "| Jogadores", "users" })

--==============================================================
-- 🎯 SEÇÃO: DROPDOWNS
--==============================================================

local selectedPlayer = nil -- Nome do jogador selecionado

-- 🎯 DROPDOWN DE TARGET
Tab3:AddDropdownPlayer({
    Name = "Selecionar Jogador",
    Callback = function(Value)
        selectedPlayer = (typeof(Value) == "Instance") and Value.Name or tostring(Value)
    end
})

--==============================================================
-- 🎥 SEÇÃO: VIEW PLAYER
--==============================================================

local viewing = false
local cam = workspace.CurrentCamera
local player = game.Players.LocalPlayer

-- Notificação de entrada (visualizando jogador)
local function ShowPlayerNotification(plr)
    local username    = plr.Name
    local displayname = plr.DisplayName
    local thumbUrl    = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. plr.UserId .. "&width=150&height=150&format=png"

    local playerGui = player:WaitForChild("PlayerGui")
    local screenGui = playerGui:FindFirstChild("AnexedNotificationUI")
    if not screenGui then
        screenGui = Instance.new("ScreenGui")
        screenGui.IgnoreGuiInset = true
        screenGui.Name = "AnexedNotificationUI"
        screenGui.ResetOnSpawn = false
        screenGui.Parent = playerGui
    end

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 200, 0, 60)
    frame.Position = UDim2.new(1, 0, 0, -10)
    frame.AnchorPoint = Vector2.new(1, 0)
    frame.BackgroundTransparency = 1
    frame.BorderSizePixel = 0
    frame.ZIndex = 20
    frame.Parent = screenGui

    local image = Instance.new("ImageLabel", frame)
    image.Size = UDim2.new(0, 40, 0, 40)
    image.Position = UDim2.new(0, 10, 0, 10)
    image.BackgroundTransparency = 1
    image.Image = thumbUrl

    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(1, -60, 0, 20)
    title.Position = UDim2.new(0, 60, 0, 8)
    title.BackgroundTransparency = 1
    title.Text = "Visualizando " .. displayname
    title.TextColor3 = Color3.new(1, 1, 1)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 14
    title.TextXAlignment = Enum.TextXAlignment.Left

    local subtitle = Instance.new("TextLabel", frame)
    subtitle.Size = UDim2.new(1, -60, 0, 18)
    subtitle.Position = UDim2.new(0, 60, 0, 30)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = "@" .. username
    subtitle.TextColor3 = Color3.new(1, 1, 1)
    subtitle.Font = Enum.Font.Gotham
    subtitle.TextSize = 12
    subtitle.TextXAlignment = Enum.TextXAlignment.Left

    local TweenService = game:GetService("TweenService")
    TweenService:Create(frame, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {
        Position = UDim2.new(1, -10, 0, 10)
    }):Play()

    task.delay(3, function()
        local exitTween = TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Position = UDim2.new(1, 0, 0, -60)
        })
        exitTween:Play()
        exitTween.Completed:Wait()
        frame:Destroy()
    end)
end

-- Notificação de saída
local function ShowLeaveNotification(playerName)
    local playerGui = player:WaitForChild("PlayerGui")
    local screenGui = playerGui:FindFirstChild("AnexedNotificationUI")
    if not screenGui then
        screenGui = Instance.new("ScreenGui")
        screenGui.IgnoreGuiInset = true
        screenGui.Name = "AnexedNotificationUI"
        screenGui.ResetOnSpawn = false
        screenGui.Parent = playerGui
    end

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 240, 0, 40)
    frame.Position = UDim2.new(1, 0, 0, -10)
    frame.AnchorPoint = Vector2.new(1, 0)
    frame.BackgroundTransparency = 1
    frame.BorderSizePixel = 0
    frame.ZIndex = 20
    frame.Parent = screenGui

    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(1, -20, 1, -10)
    title.Position = UDim2.new(0, 10, 0, 5)
    title.BackgroundTransparency = 1
    title.Text = "@" .. playerName .. " saiu do jogo"
    title.TextColor3 = Color3.fromRGB(255, 120, 120)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 14
    title.TextXAlignment = Enum.TextXAlignment.Left

    local TweenService = game:GetService("TweenService")
    TweenService:Create(frame, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {
        Position = UDim2.new(1, -10, 0, 10)
    }):Play()

    task.delay(3, function()
        local exitTween = TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Position = UDim2.new(1, 0, 0, -60)
        })
        exitTween:Play()
        exitTween.Completed:Wait()
        frame:Destroy()
    end)
end

Tab3:AddToggle({
    Name = "Visualizar Jogador",
    Callback = function(Value)
        viewing = Value
        if viewing then
            task.spawn(function()
                local watched = selectedPlayer -- snapshot pra evitar race condition
                local shown = false
                while viewing and watched == selectedPlayer do
                    local target = game.Players:FindFirstChild(watched)
                    if target then
                        if not shown then
                            ShowPlayerNotification(target)
                            shown = true
                        end
                        local character = target.Character or target.CharacterAdded:Wait()
                        local humanoid = character:FindFirstChild("Humanoid")
                        if humanoid then
                            cam.CameraSubject = humanoid
                        end
                    else
                        ShowLeaveNotification(watched)
                        viewing = false
                        local myChar = player.Character
                        if myChar and myChar:FindFirstChild("Humanoid") then
                            cam.CameraSubject = myChar.Humanoid
                        end
                        break
                    end
                    task.wait(0.1)
                end
            end)
        else
            local myChar = player.Character
            if myChar and myChar:FindFirstChild("Humanoid") then
                cam.CameraSubject = myChar.Humanoid
            end
        end
    end
})

--==============================================================
-- 🚀 SEÇÃO: BOTÃO TP JOGADOR
--==============================================================

Tab3:AddButton({
    Name = "Tp Jogador",
    Callback = function()
        if not selectedPlayer then
            MyLibrary:Notify({ Title = "Notificação", Message = "Nenhum jogador selecionado!", Duration = 3 })
            return
        end

        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer
        local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local HRP = Character:FindFirstChild("HumanoidRootPart")

        local target = Players:FindFirstChild(selectedPlayer)
        if not target or not target.Character or not target.Character:FindFirstChild("HumanoidRootPart") then
            MyLibrary:Notify({ Title = "Notificação", Message = "Jogador não encontrado!", Duration = 3 })
            return
        end

        local targetHRP = target.Character:FindFirstChild("HumanoidRootPart")
        HRP.CFrame = targetHRP.CFrame + Vector3.new(0, 3, 0)
    end
})

Tab3:AddToggle({
    Name = "Head Sit (Cavalinho)",
    Default = false,
    Callback = function(bool)
        local Players = game:GetService("Players")
        local RunService = game:GetService("RunService")

        local player = Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
        local humanoid = character:WaitForChild("Humanoid")

        if bool then
            if not selectedPlayer then
                warn("Nenhum jogador selecionado!")
                return false
            end

            humanoid.Sit = true

            -- Anti fling
            humanoidRootPart.AssemblyLinearVelocity = Vector3.zero
            humanoidRootPart.AssemblyAngularVelocity = Vector3.zero

            if headSitConnection then
                headSitConnection:Disconnect()
            end

            headSitConnection = RunService.Heartbeat:Connect(function()
                -- Atualiza o alvo em tempo real
                local targetPlayer = Players:FindFirstChild(selectedPlayer)

                if targetPlayer
                    and targetPlayer.Character
                    and targetPlayer.Character:FindFirstChild("Head") then

                    -- Continua sentado mesmo se apertar espaço
                    if not humanoid.Sit then
                        humanoid.Sit = true
                    end

                    local head = targetPlayer.Character.Head

                    humanoidRootPart.CFrame =
                        head.CFrame * CFrame.new(0, 1.6, 0.4)

                    -- Anti fling
                    humanoidRootPart.AssemblyLinearVelocity = Vector3.zero
                    humanoidRootPart.AssemblyAngularVelocity = Vector3.zero
                else
                    if headSitConnection then
                        headSitConnection:Disconnect()
                        headSitConnection = nil
                    end

                    humanoid.Sit = false
                end
            end)
        else
            if headSitConnection then
                headSitConnection:Disconnect()
                headSitConnection = nil
            end

            humanoid.Sit = false
            humanoidRootPart.AssemblyLinearVelocity = Vector3.zero
            humanoidRootPart.AssemblyAngularVelocity = Vector3.zero
        end
    end
})
----------------------------------------------------------------------------------------------------------------
-----------------------------------------Aba Antis-----------------------------------------------------
----------------------------------------------------------------------------------------------------------------

local Tab4= Window:MakeTab({ "| Antis", "shield" })

local antiSitEnabled = false
local antiSitLoop

Tab4:AddToggle({
    Name = "Anti-Sit",
    Description = "Impede o jogador de sentar",
    Default = false,
    Callback = function(state)
        antiSitEnabled = state

        if state then
            antiSitLoop = task.spawn(function()
                while antiSitEnabled do
                    local character = game.Players.LocalPlayer.Character

                    if character then
                        local humanoid = character:FindFirstChildOfClass("Humanoid")

                        if humanoid then
                            humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)

                            if humanoid.Sit then
                                humanoid.Sit = false
                                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                            end
                        end
                    end

                    task.wait()
                end
            end)
        else
            local character = game.Players.LocalPlayer.Character

            if character then
                local humanoid = character:FindFirstChildOfClass("Humanoid")

                if humanoid then
                    humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
                end
            end
        end
    end
})


-- Toggle na RedzLib
Tab4:AddToggle({
	Name = "Anti Void",
	Description = "Não deixar você morrer para o void",
	Default = false,
	Callback = function(Value)
		ToggleVoidProtection(Value)
	end
})
---------------------------------------------------------------------------------------------------------------------------------
                                          -- === Tab Script === --
---------------------------------------------------------------------------------------------------------------------------------
local TabScript = Window:MakeTab({"| Scripts ", "code"})

TabScript:AddSection({ Name = "Aprimoramentos" })

TabScript:AddButton({
    Name = "FE Emotes SAGAZx",
    Description = "",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/psychoSAGAZ/SAGAZx-HUB/refs/heads/main/FE%20Emotes%20do%20SAGAZx%20HUB"))()
    end
})

TabScript:AddButton({
    Name = "Expand Hotbar",
    Description = "Expande Sua Hotbar de 10 Ate 20 Slots",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/psychoSAGAZ/SAGAZx-HUB/refs/heads/main/Expand%20Hotbar%20"))()
    end
})

TabScript:AddButton({
    Name = "Fly Car",
    Description = "Faz Você Voar Com o Carro",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/raelhubfunctions/Save-scripts/refs/heads/main/CarMobile.lua"))()
    end
})

local FlyGui = loadstring(game:HttpGet("https://raw.githubusercontent.com/psychoSAGAZ/SAGAZx-HUB/refs/heads/main/FLY%20GUI%20V3"))()

TabScript:AddToggle({
    Name = "Fly GUI",
    Description = "Faz Você Voar",
    Default = false,
    Callback = function(Value)
        if FlyGui then
            FlyGui.Enabled = Value
        end
    end
})

loadstring(game:HttpGet("https://raw.githubusercontent.com/psychoSAGAZ/SAGAZx-HUB/refs/heads/main/DRONE"))()

TabScript:AddToggle({
  Name = "Drone",
  Default = false,
  Callback = function(Value)
    Frame.Visible = Value -- Se Value for true, aparece. Se for false, some.
  end
})

local InvisLoaded = false

TabScript:AddToggle({
    Name = "FE Invisível",
    Description = "Deixa Você Invisível",
    Default = false,
    Callback = function(Value)
        if Value then
            if not InvisLoaded then
                InvisLoaded = true
                loadstring(game:HttpGet("https://raw.githubusercontent.com/psychoSAGAZ/SAGAZx-HUB/refs/heads/main/FE%20Invisible%20"))()
            end

            game:GetService("CoreGui").InvisButtonGui.Enabled = true
        else
            if game:GetService("CoreGui"):FindFirstChild("InvisButtonGui") then
                game:GetService("CoreGui").InvisButtonGui.Enabled = false
            end
        end
    end
})

loadstring(game:HttpGet("https://raw.githubusercontent.com/psychoSAGAZ/SAGAZx-HUB/refs/heads/main/Shiftlock%20"))()

TabScript:AddToggle({
    Name = "Shiftlock",
    Default = true, -- Mudado para true para o design do toggle começar ativado
    Callback = function(Value)
        if getgenv().ToggleShiftlockButton then
            if Value == true then
                getgenv().ToggleShiftlockButton(true)
            else
                -- Força o botão a sumir imediatamente, independente do shiftlock estar ativo ou não
                local CoreGui = game:GetService("CoreGui")
                local gui = CoreGui:FindFirstChild("Shiftlock (CoreGui)")
                if gui then
                    gui.Enabled = false
                end
            end
        end
    end
})

local ChatConnections = {}
local ChatEnabled = false

TabScript:AddToggle({
    Name = "Oculta Chat Global ",
    Description = "Certifique de Colocar o Chat em ''Aqui'' ",
    CurrentValue = false,
    Callback = function(Value)
        ChatEnabled = Value

        -- Desconecta tudo ao desativar
        if not Value then
            for _, Connection in ipairs(ChatConnections) do
                if Connection then
                    Connection:Disconnect()
                end
            end
            table.clear(ChatConnections)
            return
        end

        local CoreGui = game:GetService("CoreGui")

        local function RemoveChatParts()
            if not ChatEnabled then return end

            local Chat = CoreGui:FindFirstChild("ExperienceChat")
            if not Chat then return end

            local AppLayout = Chat:FindFirstChild("appLayout")
            if not AppLayout then return end

            local TopPadding = AppLayout:FindFirstChild("topPadding")
            if TopPadding then
                TopPadding:Destroy()
            end

            local ChannelBar = AppLayout:FindFirstChild("channelBar")
            if ChannelBar then
                ChannelBar:Destroy()
            end
        end

        RemoveChatParts()

        table.insert(ChatConnections, CoreGui.ChildAdded:Connect(function(Child)
            if not ChatEnabled then return end

            if Child.Name == "ExperienceChat" then
                task.wait()
                RemoveChatParts()

                local AppLayout = Child:FindFirstChild("appLayout") or Child:WaitForChild("appLayout", 10)
                if AppLayout then
                    table.insert(ChatConnections, AppLayout.ChildAdded:Connect(function()
                        if ChatEnabled then
                            task.wait()
                            RemoveChatParts()
                        end
                    end))
                end
            end
        end))

        local Chat = CoreGui:FindFirstChild("ExperienceChat")
        if Chat then
            local AppLayout = Chat:FindFirstChild("appLayout")
            if AppLayout then
                table.insert(ChatConnections, AppLayout.ChildAdded:Connect(function()
                    if ChatEnabled then
                        task.wait()
                        RemoveChatParts()
                    end
                end))
            end
        end
    end
})