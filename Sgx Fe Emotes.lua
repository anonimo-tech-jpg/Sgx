local CoreGui = game:GetService("CoreGui")

if CoreGui:FindFirstChild("EmotesGUI") then
	CoreGui.EmotesGUI:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "EmotesGUI"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- OPEN BUTTON

local Open = Instance.new("TextButton")
Open.Parent = ScreenGui
Open.Position = UDim2.fromScale(0.10,0.14)
Open.Size = UDim2.fromOffset(60,60)
Open.Text = "Close"
Open.TextScaled = true
Open.BackgroundColor3 = Color3.fromRGB(0,0,0)
Open.BackgroundTransparency = .4
Open.TextColor3 = Color3.new(1,1,1)
Open.AutoButtonColor = false
Open.Draggable = true

Instance.new("UICorner",Open).CornerRadius = UDim.new(1,0)

-- TOP BAR

local TopBar = Instance.new("Frame")
TopBar.Parent = ScreenGui
TopBar.Position = UDim2.fromScale(0.25,0.08)
TopBar.Size = UDim2.fromScale(0.5,0.07)
TopBar.BackgroundTransparency = 1

local Layout = Instance.new("UIListLayout")
Layout.Parent = TopBar
Layout.FillDirection = Enum.FillDirection.Horizontal
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
Layout.Padding = UDim.new(0,15)

-- BOTÃO FECHAR

local Kill = Instance.new("TextButton")
Kill.Parent = TopBar
Kill.Size = UDim2.fromOffset(120,40)
Kill.Text = "Fechar GUI"
Kill.TextScaled = true
Kill.BackgroundColor3 = Color3.fromRGB(120,0,0)
Kill.BackgroundTransparency = .3
Kill.TextColor3 = Color3.new(1,1,1)

Instance.new("UICorner",Kill)

-- SEARCH

local SearchBar = Instance.new("TextBox")
SearchBar.Parent = TopBar
SearchBar.Size = UDim2.fromOffset(300,40)
SearchBar.PlaceholderText = "Pesquisar..."
SearchBar.TextScaled = true
SearchBar.BackgroundColor3 = Color3.fromRGB(0,0,0)
SearchBar.BackgroundTransparency = .4
SearchBar.TextColor3 = Color3.new(1,1,1)

Instance.new("UICorner",SearchBar)

-- MOVIMENTO BUTTON

local Movimento = Instance.new("TextButton")
Movimento.Parent = TopBar
Movimento.Size = UDim2.fromOffset(150,40)
Movimento.Text = "Movimento: OFF"
Movimento.TextScaled = true
Movimento.BackgroundColor3 = Color3.fromRGB(0,0,0)
Movimento.BackgroundTransparency = .4
Movimento.TextColor3 = Color3.new(1,1,1)

Instance.new("UICorner",Movimento)

--------------------------------------------------
-- BOTÃO DE ALTERNÂNCIA DE MODO
--------------------------------------------------

local ModeToggle = Instance.new("TextButton")
ModeToggle.Parent = TopBar
ModeToggle.Size = UDim2.fromOffset(120,40)
ModeToggle.Text = "Anims"
ModeToggle.TextScaled = true
ModeToggle.BackgroundColor3 = Color3.fromRGB(0,0,0)
ModeToggle.BackgroundTransparency = .4
ModeToggle.TextColor3 = Color3.new(1,1,1)

Instance.new("UICorner", ModeToggle)

--------------------------------------------------
-- MOVIMENTO TOGGLE
--------------------------------------------------

local MovimentoAtivo = false

local function AtualizarMovimento()
	Movimento.Text = MovimentoAtivo and "Movimento: ON" or "Movimento: OFF"
end

AtualizarMovimento()

Movimento.MouseButton1Click:Connect(function()
	MovimentoAtivo = not MovimentoAtivo
	AtualizarMovimento()
end)

-- LABEL

local EmoteName = Instance.new("TextLabel")
EmoteName.Parent = ScreenGui
EmoteName.Position = UDim2.fromScale(0.2,0.5)
EmoteName.Size = UDim2.fromOffset(60,60)
EmoteName.Text = "Nome dos Emotes"
EmoteName.TextScaled = true
EmoteName.BackgroundColor3 = Color3.fromRGB(0,0,0)
EmoteName.BackgroundTransparency = .4
EmoteName.TextColor3 = Color3.new(1,1,1)

Instance.new("UICorner",EmoteName)

-- SCROLL FRAME

local Frame = Instance.new("ScrollingFrame")
Frame.Parent = ScreenGui
Frame.Position = UDim2.fromScale(0.25,0.18)
Frame.Size = UDim2.fromScale(0.5,0.7)
Frame.BackgroundTransparency = 1
Frame.ScrollBarThickness = 6
Frame.AutomaticCanvasSize = Enum.AutomaticSize.Y

Frame.ScrollingDirection = Enum.ScrollingDirection.Y
Frame.HorizontalScrollBarInset = Enum.ScrollBarInset.None
Frame.CanvasSize = UDim2.new(0,0,0,0)

local Grid = Instance.new("UIGridLayout")
Grid.Parent = Frame
Grid.CellSize = UDim2.fromOffset(90,90)
Grid.CellPadding = UDim2.fromOffset(8,8)
Grid.SortOrder = Enum.SortOrder.LayoutOrder

--------------------------------------------------
-- FECHAR / ABRIR GUI
--------------------------------------------------

local GuiAberta = true

Open.MouseButton1Click:Connect(function()

	GuiAberta = not GuiAberta

	TopBar.Visible = GuiAberta
	Frame.Visible = GuiAberta
	EmoteName.Visible = GuiAberta

	if GuiAberta then
		Open.Text = "Close"
	else
		Open.Text = "Open"
	end

end)

--------------------------------------------------
-- BOTÃO FECHAR GUI
--------------------------------------------------

Kill.MouseButton1Click:Connect(function()
	ScreenGui:Destroy()
end)

--------------------------------------------------
-- PLAY EMOTE (OTIMIZADO - SEM CONGELAMENTO)
--------------------------------------------------

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local CurrentTrack
local AnimationCache = {} -- Cache para animações já carregadas

local function PlayEmote(assetId)
	if not assetId then return end

	local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	local Humanoid = Character:WaitForChild("Humanoid")

	if CurrentTrack then
		CurrentTrack:Stop()
		CurrentTrack = nil
	end

	-- Usa cache se disponível
	local AnimationId = AnimationCache[assetId]
	
	if not AnimationId then
		-- Carrega de forma assíncrona
		task.spawn(function()
			local success, objects = pcall(function()
				return game:GetObjects("rbxassetid://" .. tostring(assetId))
			end)

			if success and objects and #objects > 0 then
				local obj = objects[1]

				if obj:IsA("Animation") then
					AnimationId = obj.AnimationId
				elseif obj:FindFirstChildOfClass("Animation") then
					AnimationId = obj:FindFirstChildOfClass("Animation").AnimationId
				else
					AnimationId = "rbxassetid://" .. assetId
				end
			else
				AnimationId = "rbxassetid://" .. assetId
			end

			-- Salva no cache
			AnimationCache[assetId] = AnimationId

			-- Cria e toca a animação
			local Animation = Instance.new("Animation")
			Animation.AnimationId = AnimationId

			local Track = Humanoid:LoadAnimation(Animation)
			Track.Priority = Enum.AnimationPriority.Action
			Track.Looped = true
			Track:Play()

			CurrentTrack = Track
		end)
	else
		-- Usa cache diretamente
		local Animation = Instance.new("Animation")
		Animation.AnimationId = AnimationId

		local Track = Humanoid:LoadAnimation(Animation)
		Track.Priority = Enum.AnimationPriority.Action
		Track.Looped = true
		Track:Play()

		CurrentTrack = Track
	end
end

--------------------------------------------------
-- MECANISMO INJETOR AVANÇADO DE ANIMAÇÕES DO ESQUELETO
--------------------------------------------------

local LastEquippedPack = nil

local function extractValidAnimationTracks(assetId, descProp)
    local results = {}
    if not assetId or assetId == 0 then return results end

    local ok, _ = pcall(function()
        local desc = Instance.new("HumanoidDescription")
        desc[descProp] = tonumber(assetId)

        local dummy = Players:CreateHumanoidModelFromDescription(desc, Enum.HumanoidRigType.R15)
        local animate = dummy:FindFirstChild("Animate")

        if animate then
            local folderName = string.lower(string.gsub(descProp, "Animation", ""))
            local folder = animate:FindFirstChild(folderName)
            if folder then
                for _, child in ipairs(folder:GetChildren()) do
                    if child:IsA("Animation") and child.AnimationId ~= "" then
                        table.insert(results, child:Clone())
                    end
                end
            end
        end
        dummy:Destroy()
    end)

    if not ok or #results == 0 then
        local backupAnim = Instance.new("Animation")
        backupAnim.AnimationId = "rbxassetid://" .. tostring(assetId)
        table.insert(results, backupAnim)
    end

    return results
end

local function ApplyAnimationPack(pack)
    if not pack then return end
    LastEquippedPack = pack

    local character = LocalPlayer.Character
    if not character then return end
    
    local animateScript = character:FindFirstChild("Animate")
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not animateScript or not humanoid then return end

    for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
        pcall(function() track:Stop(0) end)
    end

    animateScript.Disabled = true

    local items = pack.bundledItems
    local mapping = {
        ["idle"]  = {id = items["Idle"],  prop = "IdleAnimation"},
        ["walk"]  = {id = items["Walk"],  prop = "WalkAnimation"},
        ["run"]   = {id = items["Run"],   prop = "RunAnimation"},
        ["jump"]  = {id = items["Jump"],  prop = "JumpAnimation"},
        ["fall"]  = {id = items["Fall"],  prop = "FallAnimation"},
        ["climb"] = {id = items["Climb"], prop = "ClimbAnimation"},
        ["swim"]  = {id = items["Swim"],  prop = "SwimAnimation"}
    }

    for folderName, info in pairs(mapping) do
        if info.id then
            local folder = animateScript:FindFirstChild(folderName)
            if folder then
                for _, child in ipairs(folder:GetChildren()) do
                    if child:IsA("Animation") then child:Destroy() end
                end

                local validTracks = extractValidAnimationTracks(info.id, info.prop)
                for _, track in ipairs(validTracks) do
                    track.Parent = folder
                end
            end
        end
    end

    task.wait(0.05)
    animateScript.Disabled = false
end

--------------------------------------------------
-- SISTEMA AUTO-EQUIPAR ANIMAÇÃO AO RENASCER
--------------------------------------------------

LocalPlayer.CharacterAdded:Connect(function(newCharacter)
	local animateScript = newCharacter:WaitForChild("Animate", 10)
	local humanoid = newCharacter:WaitForChild("Humanoid", 10)
	
	if animateScript and humanoid and LastEquippedPack then
		task.wait(0.5)
		ApplyAnimationPack(LastEquippedPack)
	end
end)

--------------------------------------------------
-- PARAR EMOTE AO ANDAR
--------------------------------------------------

local RunService = game:GetService("RunService")

RunService.Heartbeat:Connect(function()

	if MovimentoAtivo then
		return
	end

	if not CurrentTrack then
		return
	end

	local Character = LocalPlayer.Character
	if not Character then
		return
	end

	local Humanoid = Character:FindFirstChildOfClass("Humanoid")
	if not Humanoid then
		return
	end

	local Moving = Humanoid.MoveDirection.Magnitude > 0.1

	local State = Humanoid:GetState()

	local Jumping =
		State == Enum.HumanoidStateType.Jumping
		or State == Enum.HumanoidStateType.Freefall

	if Moving or Jumping then

		CurrentTrack:Stop()

		CurrentTrack = nil

	end

end)

--------------------------------------------------
-- SISTEMA DE SALVAMENTO DE FAVORITOS
--------------------------------------------------

local Favorites = {} 
local AnimFavorites = {}
local LoadedEmotes = {}
local LoadedAnims = {}

local HttpService = game:GetService("HttpService")
local FAVORITES_FILE = "EmoteFavorites.json"
local ANIM_FAVORITES_FILE = "AnimPacksFavorites.json"

if writefile and not isfile(FAVORITES_FILE) then writefile(FAVORITES_FILE, "{}") end
if readfile and isfile(FAVORITES_FILE) then
	local success, data = pcall(function() return HttpService:JSONDecode(readfile(FAVORITES_FILE)) end)
	if success and type(data) == "table" then Favorites = data end
end

if writefile and not isfile(ANIM_FAVORITES_FILE) then writefile(ANIM_FAVORITES_FILE, "{}") end
if readfile and isfile(ANIM_FAVORITES_FILE) then
	local success, data = pcall(function() return HttpService:JSONDecode(readfile(ANIM_FAVORITES_FILE)) end)
	if success and type(data) == "table" then AnimFavorites = data end
end

local function SaveFavorites(mode)
	if writefile then
		if mode == "Emotes" then
			writefile(FAVORITES_FILE, HttpService:JSONEncode(Favorites))
		else
			writefile(ANIM_FAVORITES_FILE, HttpService:JSONEncode(AnimFavorites))
		end
	end
end

local function RefreshLayout()
	Frame.CanvasSize = UDim2.new(0,0,0,Grid.AbsoluteContentSize.Y + 10)
end

--------------------------------------------------
-- REORGANIZAÇÃO EM TEMPO REAL (ORDEM DOS BOTÕES)
--------------------------------------------------

local currentMode = "Emotes"

local function ReorderItems()
	local FavOrder = 0
	local NormalOrder = 10000

	for _, obj in ipairs(Frame:GetChildren()) do
		if obj:IsA("ImageButton") then
			local itemMode = obj:GetAttribute("ItemMode")
			if itemMode == currentMode then
				local isFav = (currentMode == "Emotes" and Favorites[obj.Name]) or (currentMode == "Animations" and AnimFavorites[obj.Name])
				if isFav then
					FavOrder += 1
					obj.LayoutOrder = FavOrder
				else
					NormalOrder += 1
					obj.LayoutOrder = NormalOrder
				end
			end
		end
	end
end

--------------------------------------------------
-- MUDANÇA DE VISIBILIDADE POR MODO (ULTRA OTIMIZADO)
--------------------------------------------------

local function SwitchMode(mode)
	currentMode = mode
	SearchBar.Text = ""
	
	for _, obj in ipairs(Frame:GetChildren()) do
		if obj:IsA("ImageButton") then
			local itemMode = obj:GetAttribute("ItemMode")
			
			if itemMode == mode then
				obj.Visible = true
			else
				obj.Visible = false
			end
		end
	end
	
	ReorderItems()
	RefreshLayout()
end

ModeToggle.MouseButton1Click:Connect(function()
	if currentMode == "Emotes" then
		ModeToggle.Text = "Emotes"
		EmoteName.Text = "Nome das Animações"
		SwitchMode("Animations")
	else
		ModeToggle.Text = "Anims"
		EmoteName.Text = "Nome dos Emotes"
		SwitchMode("Emotes")
	end
end)

--------------------------------------------------
-- CRIAÇÃO DOS BOTÕES DE EMOTE (OTIMIZADO)
--------------------------------------------------

local function CreateEmote(asset)
	local assetIdStr = tostring(asset.id)
	if LoadedEmotes[assetIdStr] then return end
	LoadedEmotes[assetIdStr] = true

	local Emote = Instance.new("ImageButton")
	Emote.Parent = Frame
	Emote.Size = UDim2.fromOffset(90,90)
	Emote.BackgroundColor3 = Color3.fromRGB(0,0,0)
	Emote.BackgroundTransparency = .5
	Emote.Name = assetIdStr

	Emote:SetAttribute("EmoteName", asset.name)
	Emote:SetAttribute("ItemMode", "Emotes")
	Emote.Visible = (currentMode == "Emotes")

	Emote.Image = "rbxthumb://type=Asset&id=" .. assetIdStr .. "&w=150&h=150"
	Instance.new("UICorner", Emote)
	
	local Star = Instance.new("TextButton")
	Star.Parent = Emote
	Star.Size = UDim2.new(0,22,0,22)
	Star.Position = UDim2.new(1,-24,0,2)
	Star.BackgroundTransparency = 1
	Star.Text = Favorites[assetIdStr] and "★" or "☆"
	Star.TextScaled = true
	Star.TextColor3 = Color3.fromRGB(255,220,0)

	Star.MouseButton1Click:Connect(function()
		if Favorites[assetIdStr] then
			Favorites[assetIdStr] = nil
			Star.Text = "☆"
		else
			Favorites[assetIdStr] = asset.name
			Star.Text = "★"
		end
		SaveFavorites("Emotes")
		ReorderItems()
	end)

	Emote.MouseEnter:Connect(function()
		if currentMode == "Emotes" then EmoteName.Text = asset.name end
	end)

	Emote.MouseButton1Click:Connect(function()
		if currentMode == "Emotes" then
			EmoteName.Text = asset.name
			PlayEmote(tonumber(assetIdStr))
		end
	end)
end

--------------------------------------------------
-- CRIAÇÃO DOS BOTÕES DE PACK DE ANIMAÇÃO (OTIMIZADO)
--------------------------------------------------

local function CreateAnimationCard(pack)
	local packIdStr = tostring(pack.id)
	if LoadedAnims[packIdStr] then return end
	LoadedAnims[packIdStr] = true

	local Card = Instance.new("ImageButton")
	Card.Parent = Frame
	Card.Size = UDim2.fromOffset(90,90)
	Card.BackgroundColor3 = Color3.fromRGB(0,0,0)
	Card.BackgroundTransparency = .5
	Card.Name = packIdStr

	Card:SetAttribute("EmoteName", pack.name)
	Card:SetAttribute("ItemMode", "Animations")
	Card.Visible = (currentMode == "Animations")

	Card.Image = "rbxthumb://type=BundleThumbnail&id=" .. packIdStr .. "&w=150&h=150"
	Instance.new("UICorner", Card)

	local Star = Instance.new("TextButton")
	Star.Parent = Card
	Star.Size = UDim2.new(0,22,0,22)
	Star.Position = UDim2.new(1,-24,0,2)
	Star.BackgroundTransparency = 1
	Star.Text = AnimFavorites[packIdStr] and "★" or "☆"
	Star.TextScaled = true
	Star.TextColor3 = Color3.fromRGB(255,220,0)

	Star.MouseButton1Click:Connect(function()
		if AnimFavorites[packIdStr] then
			AnimFavorites[packIdStr] = nil
			Star.Text = "☆"
		else
			AnimFavorites[packIdStr] = pack.name
			Star.Text = "★"
		end
		SaveFavorites("Animations")
		ReorderItems()
	end)

	Card.MouseEnter:Connect(function()
		if currentMode == "Animations" then EmoteName.Text = pack.name end
	end)

	Card.MouseButton1Click:Connect(function()
		if currentMode == "Animations" then
			EmoteName.Text = pack.name
			ApplyAnimationPack(pack)
		end
	end)
end

--------------------------------------------------
-- SISTEMA DE FILTRAGEM POR DIGITAÇÃO (PESQUISA COMPLETA)
--------------------------------------------------

-- Arrays para armazenar todos os dados do catálogo
local AllEmotesData = {}
local AllAnimsData = {}

local function UpdateSearch()
	local Texto = string.lower(SearchBar.Text)
	
	if Texto == "" then
		-- Se pesquisa vazia, mostra apenas os itens já carregados
		for _,obj in ipairs(Frame:GetChildren()) do
			if obj:IsA("ImageButton") then
				local itemMode = obj:GetAttribute("ItemMode")
				if itemMode == currentMode then
					obj.Visible = true
				else
					obj.Visible = false
				end
			end
		end
		ReorderItems()
		RefreshLayout()
		return
	end
	
	-- Se há pesquisa, procura em TODA a lista
	local dataToSearch = currentMode == "Emotes" and AllEmotesData or AllAnimsData
	local isEmoteMode = currentMode == "Emotes"
	
	-- Esconde todos os botões primeiro
	for _,obj in ipairs(Frame:GetChildren()) do
		if obj:IsA("ImageButton") then
			obj.Visible = false
		end
	end
	
	-- Procura e cria botões para itens que correspondem à pesquisa
	local searchResults = {}
	
	for _, item in ipairs(dataToSearch) do
		local itemName = string.lower(item.name or "")
		local itemId = tostring(item.id)
		
		if string.find(itemName, Texto, 1, true) or string.find(itemId, Texto, 1, true) then
			table.insert(searchResults, item)
		end
	end
	
	-- Cria botões para os resultados da pesquisa
	for _, item in ipairs(searchResults) do
		if isEmoteMode then
			CreateEmote(item)
		else
			CreateAnimationCard(item)
		end
	end
	
	-- Mostra apenas os resultados da pesquisa
	local searchIds = {}
	for _, item in ipairs(searchResults) do
		searchIds[tostring(item.id)] = true
	end
	
	for _,obj in ipairs(Frame:GetChildren()) do
		if obj:IsA("ImageButton") then
			local itemMode = obj:GetAttribute("ItemMode")
			if itemMode == currentMode and searchIds[obj.Name] then
				obj.Visible = true
			end
		end
	end
	
	ReorderItems()
	RefreshLayout()
end

SearchBar:GetPropertyChangedSignal("Text"):Connect(UpdateSearch)

--------------------------------------------------
-- CARREGAMENTO ASSÍNCRONO OTIMIZADO
--------------------------------------------------

-- 1. Carrega Emotes (500 últimos)
task.spawn(function()
	local url = "https://raw.githubusercontent.com/psychoSAGAZ/Anima-es-e-emotes/refs/heads/main/EmoteSniper.json"
	local success, response = pcall(function() return game:HttpGet(url) end)

	if success and response then
		local parsed = HttpService:JSONDecode(response)
		if parsed and parsed.data then
			-- Salva TODOS os dados para pesquisa
			AllEmotesData = parsed.data
			
			local CatalogLookup = {}
			for _, asset in ipairs(parsed.data) do CatalogLookup[tostring(asset.id)] = asset.name end

			-- Instancia os favoritos salvos locais primeiro
			for favId, favValue in pairs(Favorites) do
				local name = type(favValue) == "string" and favValue or CatalogLookup[tostring(favId)] or "Emote Desconhecido"
				CreateEmote({id = favId, name = name})
			end
			
			-- Carrega apenas os últimos 500 emotes
			local totalEmotes = #parsed.data
			local startIndex = math.max(1, totalEmotes - 499)
			
			for i = startIndex, totalEmotes do
				local asset = parsed.data[i]
				if asset and not Favorites[tostring(asset.id)] then
					CreateEmote(asset)
				end
			end
			
			ReorderItems()
			RefreshLayout()
		end
	end
end)

-- 2. Carrega Packs de Animação
task.spawn(function()
	local url = "https://raw.githubusercontent.com/psychoSAGAZ/Anima-es-e-emotes/refs/heads/main/AnimationSniper.json"
	local success, response = pcall(function() return game:HttpGet(url) end)

	if success and response then
		local parsed = HttpService:JSONDecode(response)
		if parsed and parsed.data then
			-- Salva TODOS os dados para pesquisa
			AllAnimsData = parsed.data
			
			local CatalogLookup = {}
			for _, pack in ipairs(parsed.data) do CatalogLookup[tostring(pack.id)] = pack.name end

			-- Instancia os favoritos primeiro
			for favId, favValue in pairs(AnimFavorites) do
				local name = type(favValue) == "string" and favValue or CatalogLookup[tostring(favId)] or "Pack Desconhecido"
				local matchedPack = nil
				for _, p in ipairs(parsed.data) do
					if tostring(p.id) == tostring(favId) then matchedPack = p break end
				end
				CreateAnimationCard(matchedPack or {id = favId, name = name, bundledItems = {}})
			end
			
			-- Carrega todos os packs
			for _, pack in ipairs(parsed.data) do
				if not AnimFavorites[tostring(pack.id)] then
					CreateAnimationCard(pack)
				end
			end
			
			ReorderItems()
			RefreshLayout()
		end
	end
end)

task.wait(0.5)
Frame.CanvasPosition = Vector2.new(0,1)
Frame.CanvasPosition = Vector2.new(0,0)