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


local MyLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/anonimo-tech-jpg/Redz-Lib/refs/heads/main/Redz%20lib%20Skins.lua"))()

local Window = MyLibrary:MakeWindow({
    Title = "SAGAZx Hub Skins",
    SubTitle = "by SAGAZx😎",
    SaveFolder = "SAGAZxConfigSkins"
})

----------------------------------------------------------------------------------------------------------------
-----------------------------------------Aba Avatar---------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
local Tab1 = Window:MakeTab({ "| Avatar", "shirt" })

-- ====================================================================
-- SKIN MANAGER CATALOG (TAB1)
-- ====================================================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

local SKINS_FILE = "SAGAZxAvataLoadCatalog.json"

local Skins = {}

-- ==========================================
-- CÓDIGOS DE CORPO (TOPO)
-- ==========================================
local bodyCodes = {
    ["Corpo Normal"]          = "BH-AE-b13ebf33569a4d909d1995f401511ba6",
    ["Corpo Normal Esticado"] = "BH-AE-00e12b1c7a95401398d1a0f8ffdc2eda",
    ["Corpo Alto Fino"]       = "BH-AE-a6dc40c61d634003b173e343aa5c880a"
}

-- ==========================================
-- CARREGAR / SALVAR ARQUIVO LOCAL
-- ==========================================
local function LoadDataFile()
    if isfile(SKINS_FILE) then
        pcall(function()
            Skins = HttpService:JSONDecode(readfile(SKINS_FILE))
        end)
    else
        writefile(SKINS_FILE, "{}")
    end
end
LoadDataFile()

local function SaveSkinsFile()
    writefile(SKINS_FILE, HttpService:JSONEncode(Skins))
end

-- ==========================================
-- DETECTAR REMOTES E AVATAR DO CATALOG
-- ==========================================
local Remotes
local IsBrookhaven = false

pcall(function()
    Remotes = ReplicatedStorage:FindFirstChild("Remotes")
    if Remotes then
        IsBrookhaven = true
        print("Brookhaven detectado")
    else
        print("Catalog Avatar detectado")
    end
end)

local function GetCatalogHumanoid()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Humanoid") then
            local model = obj.Parent
            if model
            and model ~= LocalPlayer.Character
            and model:FindFirstChild("HumanoidRootPart")
            and model:FindFirstChild("Head") then
                local plr = Players:GetPlayerFromCharacter(model)
                if not plr then
                    return obj
                end
            end
        end
    end
    return nil
end

-- ==========================================
-- CAPTURAR DADOS DO AVATAR ATUAL
-- ==========================================
local function GetCurrentAvatarData()
    local Humanoid
    local Character

    local CatalogHumanoid = GetCatalogHumanoid()
    if CatalogHumanoid then
        Humanoid = CatalogHumanoid
        Character = CatalogHumanoid.Parent
        print("Avatar do Catalog detectado")
    else
        Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        Humanoid = Character:FindFirstChildOfClass("Humanoid")
        print("Avatar do jogo detectado")
    end

    if not Humanoid then return nil end

    local Desc = Humanoid:GetAppliedDescription()

    local SkinData = {
        Body = {
            Torso = Desc.Torso,
            RightArm = Desc.RightArm,
            LeftArm = Desc.LeftArm,
            RightLeg = Desc.RightLeg,
            LeftLeg = Desc.LeftLeg,
            Head = Desc.Head
        },
        Clothing = {
            Shirt = Desc.Shirt,
            Pants = Desc.Pants,
            Face = Desc.Face
        },
        Accessories = {},
        Animations = {
            Idle = Desc.IdleAnimation,
            Walk = Desc.WalkAnimation,
            Run = Desc.RunAnimation,
            Jump = Desc.JumpAnimation,
            Fall = Desc.FallAnimation,
            Climb = Desc.ClimbAnimation,
            Swim = Desc.SwimAnimation
        }
    }

    for _, acc in ipairs(Desc:GetAccessories(true)) do
        if acc.AssetId and tonumber(acc.AssetId) then
            table.insert(SkinData.Accessories, tonumber(acc.AssetId))
        end
    end

    local BodyColor = Character:FindFirstChild("Body Colors")
    if BodyColor then
        SkinData.BodyColor = tostring(BodyColor.HeadColor)
    end

    return SkinData
end

-- ==========================================
-- APLICAR SKIN COM 3 REVISÕES
-- ==========================================
local function AplicarSkin(data, silenciarNotif)
    if not data then return end

    local LChar = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local LHumanoid = LChar:FindFirstChildOfClass("Humanoid")
    if not LHumanoid then
        MyLibrary:Notify({
            Title = "Erro",
            Message = "Humanoid não encontrado",
            Duration = 4
        })
        return
    end

    local targetIDs = {}
    local function addTargetId(id)
        if id and tonumber(id) and tonumber(id) ~= 0 then
            targetIDs[tonumber(id)] = true
        end
    end

    if data.Clothing then
        addTargetId(data.Clothing.Shirt)
        addTargetId(data.Clothing.Pants)
        addTargetId(data.Clothing.Face)
    end
    if data.Accessories then
        for _, id in ipairs(data.Accessories) do
            addTargetId(id)
        end
    end

    local function SafeWear(assetId)
        if not assetId or assetId == 0 or assetId == "0" then return end
        pcall(function()
            Remotes.Wear:InvokeServer(tonumber(assetId))
        end)
        task.wait(0.35)
    end

    local chosenBody = _G.SelectedBodyTypeCatalog or "Corpo Normal"
    local code = bodyCodes[chosenBody] or bodyCodes["Corpo Normal"]

    pcall(function()
        Remotes.AvatarEditorOutfitCodes:InvokeServer("Load", code)
    end)
    task.wait(4)

    if data.Body then
        local argsBody = {
            [1] = {
                data.Body.Torso,
                data.Body.RightArm,
                data.Body.LeftArm,
                data.Body.RightLeg,
                data.Body.LeftLeg,
                data.Body.Head
            }
        }
        pcall(function()
            Remotes.ChangeCharacterBody:InvokeServer(unpack(argsBody))
        end)
        task.wait(0.5)
    end

    if data.Clothing then
        if targetIDs[tonumber(data.Clothing.Shirt)] then SafeWear(data.Clothing.Shirt) end
        if targetIDs[tonumber(data.Clothing.Pants)] then SafeWear(data.Clothing.Pants) end
        if targetIDs[tonumber(data.Clothing.Face)] then SafeWear(data.Clothing.Face) end
    end

    if data.Accessories then
        for _, id in ipairs(data.Accessories) do
            SafeWear(id)
        end
    end

    if data.BodyColor then
        pcall(function()
            Remotes.ChangeBodyColor:FireServer(tostring(data.BodyColor))
        end)
        task.wait(0.3)
    end

    local function RunSkinRevision(revisionNumber)
        local LDesc = LHumanoid:GetAppliedDescription()
        local myEquipped = {}
        local function addMyId(id)
            if id and tonumber(id) and tonumber(id) ~= 0 then
                myEquipped[tonumber(id)] = true
            end
        end

        addMyId(LDesc.Shirt)
        addMyId(LDesc.Pants)
        addMyId(LDesc.Face)
        for _, acc in ipairs(LDesc:GetAccessories(true)) do
            addMyId(acc.AssetId)
        end

        for id, _ in pairs(targetIDs) do
            if not myEquipped[id] then
                print("Revisão Catalog " .. revisionNumber .. ": Reequipando ID: " .. id)
                SafeWear(id)
            end
        end
    end

    task.wait(1.5)
    RunSkinRevision(2)

    task.wait(1.5)
    RunSkinRevision(3)

    if data.Animations then
        local animKeys = {"Idle", "Walk", "Run", "Jump", "Fall", "Climb", "Swim"}

        local function RunAnimationRevision(revisionNumber)
            local LDesc = LHumanoid:GetAppliedDescription()
            local currentAnims = {
                Idle = LDesc.IdleAnimation,
                Walk = LDesc.WalkAnimation,
                Run = LDesc.RunAnimation,
                Jump = LDesc.JumpAnimation,
                Fall = LDesc.FallAnimation,
                Climb = LDesc.ClimbAnimation,
                Swim = LDesc.SwimAnimation
            }

            for _, key in ipairs(animKeys) do
                local savedAnim = tonumber(data.Animations[key])
                local currentAnim = tonumber(currentAnims[key])

                if savedAnim and savedAnim ~= 0 then
                    if savedAnim ~= currentAnim then
                        print("Revisão Animação Catalog " .. revisionNumber .. ": Reequipando " .. key .. " ID: " .. savedAnim)
                        SafeWear(savedAnim)
                    end
                end
            end
        end

        for _, key in ipairs(animKeys) do
            local animId = data.Animations[key]
            if tonumber(animId) and tonumber(animId) ~= 0 then
                SafeWear(animId)
            end
        end

        task.wait(1.5)
        RunAnimationRevision(2)

        task.wait(1.5)
        RunAnimationRevision(3)
    end

    if not silenciarNotif then
        MyLibrary:Notify({
            Title = "Sucesso",
            Message = "Skin Aplicada com Sucesso!",
            Duration = 4
        })
    end
end

-- ==========================================
-- AUXILIARES E REFRESH DE DROPDOWNS
-- ==========================================
local SkinName = ""
local SelectedSkin = nil
local DropdownSkins

local function GetSkinList()
    local list = {}
    for name, _ in pairs(Skins) do
        table.insert(list, name)
    end
    table.sort(list)
    return list
end

local function RefreshSkinsDropdown()
    if not DropdownSkins then return end
    local novaLista = GetSkinList()
    if DropdownSkins.Set then
        DropdownSkins:Set(novaLista)
    elseif DropdownSkins.Refresh then
        DropdownSkins:Refresh(novaLista, true)
    end
    SelectedSkin = nil
end

-- ==========================================
-- RENDERIZAÇÃO DA INTERFACE (TAB1)
-- ==========================================

Tab1:AddTextBox({
    Name = "Nome da Skin",
    PlaceholderText = "Digite o nome...",
    Callback = function(value)
        SkinName = value
    end
})

DropdownSkins = Tab1:AddDropdown({
    Name = "Skins Salvas",
    Options = GetSkinList(),
    Callback = function(option)
        SelectedSkin = option
    end
})

Tab1:AddDropdown({
    Name = "Tipo de Corpo",
    Description = "Selecione o corpo base para carregar a skin",
    Options = {"Corpo Normal", "Corpo Normal Esticado", "Corpo Alto Fino"},
    Default = "Corpo Normal",
    Flag = "body_type_dropdown_catalog",
    Callback = function(Value)
        _G.SelectedBodyTypeCatalog = Value
        print("Corpo base do Catalog alterado para: " .. Value)
    end
})

-- ==========================================
-- BOTÕES DE INTERAÇÃO
-- ==========================================

Tab1:AddButton({
    Name = "Salvar Skin do Catalogo",
    Callback = function()
        local nomeLimpo = tostring(SkinName):gsub("^%s*(.-)%s*$", "%1")

        if nomeLimpo == "" then
            MyLibrary:Notify({
                Title = "Aviso",
                Message = "Digite um nome válido na TextBox.",
                Duration = 4
            })
            return
        end

        local data = GetCurrentAvatarData()
        if not data then return end

        Skins[nomeLimpo] = data
        SaveSkinsFile()
        RefreshSkinsDropdown()

        MyLibrary:Notify({
            Title = "Sucesso",
            Message = "Skin salva: " .. nomeLimpo,
            Duration = 4
        })
    end
})

Tab1:AddButton({
    Name = "Salvar Skin Atual na Opção Selecionada",
    Callback = function()
        if not SelectedSkin then
            MyLibrary:Notify({
                Title = "Aviso",
                Message = "Selecione uma skin na Dropdown primeiro!",
                Duration = 4
            })
            return
        end

        local CurrentData = GetCurrentAvatarData()
        if not CurrentData then return end

        Skins[SelectedSkin] = CurrentData
        SaveSkinsFile()

        MyLibrary:Notify({
            Title = "Sucesso",
            Message = "Skin '" .. SelectedSkin .. "' Atualizada!",
            Duration = 4
        })
    end
})

Tab1:AddButton({
    Name = "Carregar Skin no Brookhaven",
    Callback = function()
        if SelectedSkin and Skins[SelectedSkin] then
            AplicarSkin(Skins[SelectedSkin], false)
        else
            MyLibrary:Notify({
                Title = "Aviso",
                Message = "Nenhuma skin selecionada.",
                Duration = 4
            })
        end
    end
})

Tab1:AddButton({
    Name = "Deletar Skin Selecionada",
    Callback = function()
        if SelectedSkin and Skins[SelectedSkin] then
            Skins[SelectedSkin] = nil
            SaveSkinsFile()
            SelectedSkin = nil
            RefreshSkinsDropdown()

            MyLibrary:Notify({
                Title = "Sucesso",
                Message = "Skin deletada.",
                Duration = 4
            })
        else
            MyLibrary:Notify({
                Title = "Aviso",
                Message = "Selecione uma skin para deletar.",
                Duration = 4
            })
        end
    end
})
----------------------------------------------------------------------------------------------------------------
-----------------------------------------Aba Corpos---------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
local Tab3= Window:MakeTab({ "| Corpos", "shirt" })

Tab3:AddSection({ " Corpos Femininos" })

Tab3:AddButton({
	Name = "Mulher Fina",
	Callback = function()
		game:GetService("ReplicatedStorage")
			:WaitForChild("Remotes")
			:WaitForChild("ChangeCharacterBody")
			:InvokeServer({
				96491916349570, -- Torso
				86499698,       -- Braço Direito
				86499716,       -- Braço Esquerdo
				0,              -- Perna Direita
				0,              -- Perna Esquerda
				0
			})
	end
})





Tab3:AddSection({ " Corpos Masculinos" })

Tab3:AddButton({
	Name = "Homem Fino",
	Callback = function()
		game:GetService("ReplicatedStorage")
			.Remotes.ChangeCharacterBody:InvokeServer({
				82491774691726,
				99519402284266,
				115905570886697,
				84418052877367,
				124343282827669,
				0
			})
	end
})

Tab3:AddSection({ " Corpos Pequenos" })

Tab3:AddButton({
	Name = "Pequeno Gordin",
	Callback = function()
		game:GetService("ReplicatedStorage")
			.Remotes.ChangeCharacterBody:InvokeServer({
				14579958702,
				14579959062,
				14579959191,
				14579959249,
				14579963667,
				0
			})
	end
})

Tab3:AddButton({
	Name = "PequenoFino",
	Callback = function()
		game:GetService("ReplicatedStorage")
			.Remotes.ChangeCharacterBody:InvokeServer({
				101678129797722,
				74948603903648,
				114267907635155,
				101387518276175,
				100840538291335,
				0
			})
	end
})

Tab3:AddButton({
	Name = "Pequeno das Pernas Gordinha",
	Callback = function()
		game:GetService("ReplicatedStorage")
		.Remotes.ChangeCharacterBody:InvokeServer({
			14826000631,
			14826000850,
			14826000632,
			14579959249,
			14579963667,
			0		})
	end
})


Tab3:AddButton({
	Name = "Cachorro",
	Callback = function()
		game:GetService("ReplicatedStorage")
		.Remotes.ChangeCharacterBody:InvokeServer({
			17267677772,
			17267677732,
			17267677707,
			17267677652,
			17267677787,
			0		})
	end
})



Tab3:AddButton({
	Name = "Pequeno das Pernas Grandes",
	Callback = function()
		game:GetService("ReplicatedStorage")
		.Remotes.ChangeCharacterBody:InvokeServer({
			82318122660907,
			86770305706868,
			105392627824391,
			0,
			0,
			0		})
	end
})



Tab3:AddSection({ " Corpos Musculosos e Gigantes" })

Tab3:AddButton({
	Name = "Homem Musculoso",
	Callback = function()
		game:GetService("ReplicatedStorage")
		.Remotes.ChangeCharacterBody:InvokeServer({
			18178775358,
			18178775182,
			18178775725,
			18178777453,
			18178775695,
			0		})
	end
})

Tab3:AddButton({
	Name = "Homem de Musculos Grande",
	Callback = function()
		game:GetService("ReplicatedStorage")
		.Remotes.ChangeCharacterBody:InvokeServer({
			106646306961776,
			72951123742968,
			81248622873061,
			87666174812433,
			95036381784666,
			0		})
	end
})

Tab3:AddButton({
	Name = "Braços Grandes",
	Callback = function()
		game:GetService("ReplicatedStorage")
		.Remotes.ChangeCharacterBody:InvokeServer({
			77616785544978,
			89618098969398,
			0,
			80245769527311,
			0,
			0		})
	end
})

Tab3:AddButton({
	Name = "Taix Carla",
	Callback = function()
		game:GetService("ReplicatedStorage")
		.Remotes.ChangeCharacterBody:InvokeServer({
			17713016036,
			17713016151,
			17713015861,
			17713021340,
			17713016191,
			134082579		})
	end
})

Tab3:AddButton({
	Name = "Braço Direito Grande",
	Callback = function()
		game:GetService("ReplicatedStorage")
		.Remotes.ChangeCharacterBody:InvokeServer({
			0,
			17713016151,
			0,
			139607718,
			0,
			134082579		})
	end
})

Tab3:AddButton({
	Name = "Gigante",
	Callback = function()
		game:GetService("ReplicatedStorage")
		.Remotes.ChangeCharacterBody:InvokeServer({
			81881085814072,
			77616785544978,
			89618098969398,
			106740492797177,
			81153927159685,
			15021889465		})
	end
})


Tab3:AddSection({ " Corpos Estranhos" })

Tab3:AddButton({
	Name = "Tipo Banco",
	Callback = function()
		game:GetService("ReplicatedStorage")
		.Remotes.ChangeCharacterBody:InvokeServer({
			17061950321,
			17061950752,
			17061950749,
			17061950868,
			17061954240,
			0		})
	end
})

Tab3:AddButton({
	Name = "Gorila",
	Callback = function()
		game:GetService("ReplicatedStorage")
		.Remotes.ChangeCharacterBody:InvokeServer({
			16766192865,
			16766190802,
			16766190790,
			16766190782,
			16766190791,
			0		})
	end
})

Tab3:AddButton({
	Name = "Mãos Grandes",
	Callback = function()
		game:GetService("ReplicatedStorage")
		.Remotes.ChangeCharacterBody:InvokeServer({
			18666976564,
			18666976661,
			18666976631,
			18666976759,
			18666976467,
			0		})
	end
})

Tab3:AddButton({
	Name = "Gordo",
	Callback = function()
		game:GetService("ReplicatedStorage")
		.Remotes.ChangeCharacterBody:InvokeServer({
			16305051918,
			16305053205,
			16305051718,
			16305051982,
			16305053865,
			0		})
	end
})