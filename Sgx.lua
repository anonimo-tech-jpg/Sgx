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


-- ====================================================================
-- 🎒 PROP SAVER — DEBUG MODE
-- ====================================================================

local MyLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/anonimo-tech-jpg/Redz-Lib/refs/heads/main/Redz%20lib.lua"))()

local Window = MyLibrary:MakeWindow({
    Title = "Prop Saver",
    SubTitle = "DEBUG",
    SaveFolder = "PropSaverConfig"
})

--==================== TROLL MAP ====================--
local Tab8 = Window:MakeTab({"TROLL MAP", "rbxassetid://6862780932"})


local selectedPlayerOutros = nil

local DropdownJogadoresKid = Tab8:AddDropdownPlayer({
    Name = "Selecionar Jogador",
    Callback = function(Value)
        selectedPlayerOutros = Value
    end
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

--==================== BLACK HOLE (PADRÃO) ====================--
Tab8:AddSection({"BURACO NEGRO"})

local angle = 0
local radius = 10
local speed = 2
local randomness = 0
local active = false

local function setup()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    local folder = Instance.new("Folder", Workspace)
    local part = Instance.new("Part", folder)
    local att = Instance.new("Attachment", part)
    part.Anchored = true
    part.CanCollide = false
    part.Transparency = 1
    return hrp, att
end

local hrp, center = setup()

if not getgenv().Network then
    getgenv().Network = {BaseParts = {}, Velocity = Vector3.new(14,14,14)}
    RunService.Heartbeat:Connect(function()
        sethiddenproperty(LocalPlayer, "SimulationRadius", math.huge)
        for _, p in pairs(Network.BaseParts) do
            if p:IsDescendantOf(Workspace) then
                p.Velocity = Network.Velocity
            end
        end
    end)
end

local function force(v)
    if v:IsA("Part") and not v.Anchored and not v.Parent:FindFirstChild("Humanoid") and v.Name ~= "Handle" then
        v.CanCollide = false
        local t = Instance.new("Torque", v)
        t.Torque = Vector3.new(1e6, 1e6, 1e6)
        local ap = Instance.new("AlignPosition", v)
        local a = Instance.new("Attachment", v)
        t.Attachment0 = a
        ap.Attachment0 = a
        ap.Attachment1 = center
        ap.MaxForce = math.huge
        ap.Responsiveness = 500
    end
end

local function startHalo()
    for _, v in pairs(Workspace:GetDescendants()) do
        force(v)
    end
    task.spawn(function()
        while active do
            RunService.RenderStepped:Wait()
            angle += math.rad(speed)
            local rx = math.random(-randomness, randomness) / 10
            local rz = math.random(-randomness, randomness) / 10
            local x = math.cos(angle) * radius + rx
            local z = math.sin(angle) * radius + rz
            center.WorldCFrame = hrp.CFrame * CFrame.new(x, 0, z)
        end
    end)
end

LocalPlayer.CharacterAdded:Connect(function()
    hrp, center = setup()
    if active then startHalo() end
end)

Tab8:AddSlider({
    Name = "DIMENSÕES DO BURACO NEGRO",
    Min = 1,
    Max = 100,
    Default = 10,
    Callback = function(v)
        radius = v
    end
})

Tab8:AddSlider({
    Name = "VELOCIDADE DO GIRO",
    Min = 1,
    Max = 20,
    Default = 2,
    Callback = function(v)
        speed = v
    end
})

Tab8:AddSlider({
    Name = "TORNADO (ALEATORIEDADE)",
    Min = 0,
    Max = 20,
    Default = 0,
    Callback = function(v)
        randomness = v
    end
})

Tab8:AddToggle({
    Name = "LIGAR / DESLIGAR\nBURACO NEGRO",
    Default = false,
    Callback = function(v)
        active = v
        if v then
            startHalo()
        else
            center.WorldCFrame = CFrame.new(0, -1000, 0)
        end
    end
})

--==================== BLACK HOLE COM ALVO ====================--
Tab8:AddSection({"BURACO NEGRO NO ALVO"})

local targetPlayer = nil
local targetActive = false
local targetHrp
local DescendantAddedConnection

local Folder = Instance.new("Folder", Workspace)
local Part = Instance.new("Part", Folder)
local Attachment1 = Instance.new("Attachment", Part)
Part.Anchored = true
Part.CanCollide = false
Part.Transparency = 1

if not getgenv().Network then
    getgenv().Network = {
        BaseParts = {},
        Velocity = Vector3.new(14, 14, 14)
    }
    RunService.Heartbeat:Connect(function()
        sethiddenproperty(LocalPlayer, "SimulationRadius", math.huge)
        for _, p in pairs(Network.BaseParts) do
            if p:IsDescendantOf(Workspace) then
                p.Velocity = Network.Velocity
            end
        end
    end)
end

local function ForcePart(v)
    if v:IsA("BasePart") and not v.Anchored and not v.Parent:FindFirstChildOfClass("Humanoid") and v.Name ~= "Handle" then
        for _, x in ipairs(v:GetChildren()) do
            if x:IsA("BodyMover") or x:IsA("RocketPropulsion") then
                x:Destroy()
            end
        end
        v.CanCollide = false
        local t = Instance.new("Torque", v)
        t.Torque = Vector3.new(100000, 100000, 100000)
        local ap = Instance.new("AlignPosition", v)
        local a = Instance.new("Attachment", v)
        t.Attachment0 = a
        ap.Attachment0 = a
        ap.Attachment1 = Attachment1
        ap.MaxForce = math.huge
        ap.Responsiveness = 200
    end
end

-- Busca o jogador pelo nome/DisplayName (usando a variável do dropdown)
local function getPlayer(name)
    if not name then return nil end
    local n = string.lower(name)
    for _, p in pairs(Players:GetPlayers()) do
        if string.find(string.lower(p.Name), n, 1, true)
            or string.find(string.lower(p.DisplayName), n, 1, true) then
            return p
        end
    end
    return nil
end

local function start()
    targetPlayer = getPlayer(selectedPlayerOutros)
    if not targetPlayer then
        return
    end

    local char = targetPlayer.Character or targetPlayer.CharacterAdded:Wait()
    targetHrp = char:WaitForChild("HumanoidRootPart")

    for _, v in ipairs(Workspace:GetDescendants()) do
        ForcePart(v)
    end

    DescendantAddedConnection = Workspace.DescendantAdded:Connect(function(v)
        if targetActive then
            ForcePart(v)
        end
    end)

    task.spawn(function()
        while targetActive do
            RunService.RenderStepped:Wait()
            if targetHrp and targetHrp.Parent then
                Attachment1.WorldCFrame = targetHrp.CFrame
            end
        end
    end)
end

local function stop()
    if DescendantAddedConnection then
        DescendantAddedConnection:Disconnect()
        DescendantAddedConnection = nil
    end
    Attachment1.WorldCFrame = CFrame.new(0, -1000, 0)
end

Tab8:AddToggle({
    Name = "LIGAR / DESLIGAR\nBURACO NEGRO NO ALVO",
    Default = false,
    Callback = function(v)
        targetActive = v
        if v then
            start()
        else
            stop()
        end
    end
})