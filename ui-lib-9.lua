--[[
    NetroUI - Ultimate UI Library (V5.0 Enhanced)
    Status: Premium Enhanced Version with Complete Features
]]

local Netro65UI = {}
Netro65UI.Flags = {}
Netro65UI.Setters = {}
Netro65UI.ThemeObjects = {}
Netro65UI.Keybinds = {}
Netro65UI.ConfigFolder = "Netro65UI_Configs"
Netro65UI.CurrentConfigFile = "default.json"
Netro65UI.Version = "5.0.0"
Netro65UI.IsVIP = false
Netro65UI.Language = "English" -- Sistem multi-language

--// Enhanced Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local TextService = game:GetService("TextService")
local MarketplaceService = game:GetService("MarketplaceService")
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Stats = game:GetService("Stats")

--// Constants
local MOUSE = Players.LocalPlayer:GetMouse()
local LocalPlayer = Players.LocalPlayer

--// Advanced Theme System with Gradient Support
Netro65UI.Theme = {
    Main        = Color3.fromRGB(20, 20, 20),
    Secondary   = Color3.fromRGB(28, 28, 28),
    Accent      = Color3.fromRGB(0, 140, 255),
    Accent2     = Color3.fromRGB(0, 180, 255), -- Secondary accent
    Outline     = Color3.fromRGB(50, 50, 50),
    Text        = Color3.fromRGB(240, 240, 240),
    TextDark    = Color3.fromRGB(160, 160, 160),
    Hover       = Color3.fromRGB(45, 45, 45),
    Success     = Color3.fromRGB(100, 255, 100),
    Warning     = Color3.fromRGB(255, 200, 60),
    Error       = Color3.fromRGB(255, 60, 60),
    Info        = Color3.fromRGB(60, 150, 255),
    Locked      = Color3.fromRGB(10, 10, 10),
    FontMain    = Enum.Font.GothamMedium,
    FontBold    = Enum.Font.GothamBold,
    FontCode    = Enum.Font.Code,
    UseGradient = false,
    Gradient    = {
        Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 140, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 180, 255))
        },
        Rotation = 45
    }
}

--// Enhanced Presets with Gradients
Netro65UI.Presets = {
    Default      = { 
        Main = Color3.fromRGB(20, 20, 20), 
        Accent = Color3.fromRGB(0, 140, 255),
        Gradient = {
            Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 140, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 180, 255))
            }
        }
    },
    Cyberpunk    = { 
        Main = Color3.fromRGB(10, 5, 20), 
        Accent = Color3.fromRGB(255, 0, 255),
        Gradient = {
            Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 255, 255))
            }
        }
    },
    Matrix       = { 
        Main = Color3.fromRGB(0, 20, 0), 
        Accent = Color3.fromRGB(0, 255, 0),
        Gradient = {
            Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 0)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 200, 0))
            }
        }
    },
    Sunset       = {
        Main = Color3.fromRGB(25, 15, 30),
        Accent = Color3.fromRGB(255, 100, 0),
        Gradient = {
            Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 100, 0)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 200, 50))
            }
        }
    },
    OceanDepth   = {
        Main = Color3.fromRGB(5, 10, 25),
        Accent = Color3.fromRGB(0, 200, 255),
        Gradient = {
            Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 100, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 255, 255))
            }
        }
    },
    NeonNight    = {
        Main = Color3.fromRGB(15, 0, 25),
        Accent = Color3.fromRGB(255, 20, 147),
        Gradient = {
            Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 20, 147)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 255, 255))
            }
        }
    }
}

--// Language System
Netro65UI.Languages = {
    English = {
        Save = "Save Config",
        Load = "Load Config",
        Delete = "Delete Config",
        Search = "Search...",
        Close = "Close",
        Minimize = "Minimize",
        Settings = "Settings",
        Theme = "Theme",
        Keybinds = "Keybinds",
        Configuration = "Configuration",
        Universal = "Universal Config",
        AutoSave = "Auto-Save",
        Rainbow = "Rainbow Mode",
        Acrylic = "Acrylic Blur",
        Watermark = "Watermark",
        CommandBar = "Command Bar",
        ServerInfo = "Server Info",
        Players = "Players",
        Ping = "Ping",
        FPS = "FPS",
        Locked = "Locked",
        VIPOnly = "VIP Only",
        FreeUser = "Free User",
        VIPUser = "VIP User",
        Notifications = "Notifications",
        Success = "Success",
        Error = "Error",
        Warning = "Warning",
        Info = "Information"
    },
    Indonesian = {
        Save = "Simpan Konfig",
        Load = "Muat Konfig",
        Delete = "Hapus Konfig",
        Search = "Cari...",
        Close = "Tutup",
        Minimize = "Minimalkan",
        Settings = "Pengaturan",
        Theme = "Tema",
        Keybinds = "Tombol Pintas",
        Configuration = "Konfigurasi",
        Universal = "Konfig Universal",
        AutoSave = "Simpan Otomatis",
        Rainbow = "Mode Pelangi",
        Acrylic = "Efek Buram",
        Watermark = "Watermark",
        CommandBar = "Baris Perintah",
        ServerInfo = "Info Server",
        Players = "Pemain",
        Ping = "Ping",
        FPS = "FPS",
        Locked = "Terkunci",
        VIPOnly = "Hanya VIP",
        FreeUser = "Pengguna Gratis",
        VIPUser = "Pengguna VIP",
        Notifications = "Notifikasi",
        Success = "Berhasil",
        Error = "Error",
        Warning = "Peringatan",
        Info = "Informasi"
    },
    Spanish = {
        Save = "Guardar Config",
        Load = "Cargar Config",
        Delete = "Eliminar Config",
        Search = "Buscar...",
        Close = "Cerrar",
        Minimize = "Minimizar",
        Settings = "Ajustes",
        Theme = "Tema",
        Keybinds = "Atajos",
        Configuration = "Configuración",
        Universal = "Config Universal",
        AutoSave = "Auto-Guardado",
        Rainbow = "Modo Arcoíris",
        Acrylic = "Efecto Acrílico",
        Watermark = "Marca de Agua",
        CommandBar = "Barra de Comandos",
        ServerInfo = "Info del Servidor",
        Players = "Jugadores",
        Ping = "Ping",
        FPS = "FPS",
        Locked = "Bloqueado",
        VIPOnly = "Solo VIP",
        FreeUser = "Usuario Gratis",
        VIPUser = "Usuario VIP",
        Notifications = "Notificaciones",
        Success = "Éxito",
        Error = "Error",
        Warning = "Advertencia",
        Info = "Información"
    }
}

function Netro65UI:SetLanguage(lang)
    if Netro65UI.Languages[lang] then
        Netro65UI.Language = lang
        -- Refresh UI with new language
        for _, obj in pairs(Netro65UI.ThemeObjects) do
            if obj.Instance and obj.Instance.Parent and obj.Type == "Text" then
                local textKey = obj.LangKey
                if textKey and Netro65UI.Languages[lang][textKey] then
                    obj.Instance.Text = Netro65UI.Languages[lang][textKey]
                end
            end
        end
    end
end

--// Enhanced Rainbow Mode with Multiple Effects
Netro65UI.RainbowMode = {
    Enabled = false,
    Speed = 1,
    Mode = "Standard", -- Standard, Wave, Pulse, Random
    Connection = nil,
    Hue = 0,
    PulseDirection = 1
}

function Netro65UI:ToggleRainbowMode(enabled, speed, mode)
    Netro65UI.RainbowMode.Enabled = enabled
    Netro65UI.RainbowMode.Speed = speed or 1
    Netro65UI.RainbowMode.Mode = mode or "Standard"
    
    if Netro65UI.RainbowMode.Connection then
        Netro65UI.RainbowMode.Connection:Disconnect()
        Netro65UI.RainbowMode.Connection = nil
    end
    
    if enabled then
        Netro65UI.RainbowMode.Connection = RunService.Heartbeat:Connect(function(delta)
            Netro65UI.RainbowMode.Hue = (Netro65UI.RainbowMode.Hue + delta * speed) % 1
            
            local rainbowColor
            if mode == "Wave" then
                local wave = math.sin(Netro65UI.RainbowMode.Hue * math.pi * 2) * 0.5 + 0.5
                rainbowColor = Color3.fromHSV(Netro65UI.RainbowMode.Hue, 0.8, wave)
            elseif mode == "Pulse" then
                Netro65UI.RainbowMode.Hue = (Netro65UI.RainbowMode.Hue + delta * speed * 0.5) % 1
                local pulse = math.abs(math.sin(Netro65UI.RainbowMode.Hue * math.pi * 2))
                rainbowColor = Color3.fromHSV(Netro65UI.RainbowMode.Hue, 0.8, 0.5 + pulse * 0.5)
            elseif mode == "Random" then
                rainbowColor = Color3.fromHSV(math.random(), 0.8, 1)
            else -- Standard
                rainbowColor = Color3.fromHSV(Netro65UI.RainbowMode.Hue, 0.8, 1)
            end
            
            -- Update all accent elements
            for _, obj in pairs(Netro65UI.ThemeObjects) do
                if obj.Instance and obj.Instance.Parent and obj.Type == "Accent" then
                    if obj.Property == "TextColor3" then
                        obj.Instance.TextColor3 = rainbowColor
                    elseif obj.Property == "ImageColor3" then
                        obj.Instance.ImageColor3 = rainbowColor
                    elseif obj.Property == "BackgroundColor3" then
                        obj.Instance.BackgroundColor3 = rainbowColor
                    elseif obj.Property == "ScrollBarImageColor3" then
                        obj.Instance.ScrollBarImageColor3 = rainbowColor
                    end
                end
            end
        end)
    else
        -- Reset to theme color
        for _, obj in pairs(Netro65UI.ThemeObjects) do
            if obj.Instance and obj.Instance.Parent and obj.Type == "Accent" then
                if obj.Property == "TextColor3" then 
                    obj.Instance.TextColor3 = Netro65UI.Theme.Accent 
                elseif obj.Property == "ImageColor3" then
                    obj.Instance.ImageColor3 = Netro65UI.Theme.Accent
                elseif obj.Property == "BackgroundColor3" then
                    obj.Instance.BackgroundColor3 = Netro65UI.Theme.Accent
                elseif obj.Property == "ScrollBarImageColor3" then
                    obj.Instance.ScrollBarImageColor3 = Netro65UI.Theme.Accent
                end
            end
        end
    end
end

function Netro65UI:SetTheme(presetName)
    local preset = Netro65UI.Presets[presetName] or Netro65UI.Presets.Default
    Netro65UI.Theme.Main = preset.Main
    Netro65UI.Theme.Accent = preset.Accent
    Netro65UI.Theme.Gradient = preset.Gradient or Netro65UI.Theme.Gradient
    
    if Netro65UI.RainbowMode.Enabled then
        Netro65UI:ToggleRainbowMode(false)
    end
    
    for _, obj in pairs(Netro65UI.ThemeObjects) do
        if obj.Instance and obj.Instance.Parent then
            if obj.Type == "Main" then 
                obj.Instance.BackgroundColor3 = Netro65UI.Theme.Main 
            elseif obj.Type == "Accent" then 
                if obj.Property == "TextColor3" then 
                    obj.Instance.TextColor3 = Netro65UI.Theme.Accent 
                elseif obj.Property == "ImageColor3" then
                    obj.Instance.ImageColor3 = Netro65UI.Theme.Accent
                elseif obj.Property == "BackgroundColor3" then
                    obj.Instance.BackgroundColor3 = Netro65UI.Theme.Accent
                elseif obj.Property == "ScrollBarImageColor3" then
                    obj.Instance.ScrollBarImageColor3 = Netro65UI.Theme.Accent
                end
            elseif obj.Type == "Gradient" then
                if obj.Instance:IsA("UIGradient") then
                    obj.Instance.Color = Netro65UI.Theme.Gradient.Color
                    obj.Instance.Rotation = Netro65UI.Theme.Gradient.Rotation
                end
            end
        end
    end
end

--// Enhanced Acrylic Module with Multiple Effects
local Acrylic = { 
    Active = true, 
    BlurSize = 15,
    Transparency = 0.95,
    Color = Color3.fromRGB(0, 0, 0),
    Type = "Blur" -- Blur, Transparent, Color
}

function Acrylic:Enable()
    if not Acrylic.Active then return end
    
    if Acrylic.Type == "Blur" then
        local Effect = Lighting:FindFirstChild("NetroAcrylicBlur")
        if not Effect then
            Effect = Instance.new("BlurEffect")
            Effect.Name = "NetroAcrylicBlur"
            Effect.Size = 0
            Effect.Parent = Lighting
        end
        TweenService:Create(Effect, TweenInfo.new(0.5), {Size = Acrylic.BlurSize}):Play()
    elseif Acrylic.Type == "Color" then
        -- Create color overlay
        local overlay = ScreenGui:FindFirstChild("AcrylicOverlay")
        if not overlay then
            overlay = Instance.new("Frame")
            overlay.Name = "AcrylicOverlay"
            overlay.BackgroundColor3 = Acrylic.Color
            overlay.BackgroundTransparency = 0.8
            overlay.Size = UDim2.new(1, 0, 1, 0)
            overlay.ZIndex = 1
            overlay.Parent = ScreenGui
        end
    end
end

function Acrylic:Disable()
    if Acrylic.Type == "Blur" then
        local Effect = Lighting:FindFirstChild("NetroAcrylicBlur")
        if Effect then
            TweenService:Create(Effect, TweenInfo.new(0.5), {Size = 0}):Play()
            task.delay(0.5, function() 
                if Effect then Effect:Destroy() end
            end)
        end
    else
        local overlay = ScreenGui:FindFirstChild("AcrylicOverlay")
        if overlay then
            overlay:Destroy()
        end
    end
end

--// Main UI Container with Protection
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Netro65UI_Ultimate_V5"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true

-- Protection system
if gethui then
    ScreenGui.Parent = gethui()
elseif syn and syn.protect_gui then
    syn.protect_gui(ScreenGui)
    ScreenGui.Parent = CoreGui
elseif CoreGui:FindFirstChild("RobloxGui") then
    ScreenGui.Parent = CoreGui:FindFirstChild("RobloxGui")
else
    ScreenGui.Parent = CoreGui
end

ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

--// Advanced Watermark System
local Watermark = nil
function Netro65UI:CreateWatermark(text)
    if Watermark then Watermark:Destroy() end
    
    Watermark = Instance.new("Frame")
    Watermark.Name = "Watermark"
    Watermark.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Watermark.BackgroundTransparency = 0.7
    Watermark.Size = UDim2.new(0, 220, 0, 35)
    Watermark.Position = UDim2.new(0, 10, 0, 10)
    Watermark.Parent = ScreenGui
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = Watermark
    
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Netro65UI.Theme.Accent
    UIStroke.Thickness = 2
    UIStroke.Transparency = 0.5
    UIStroke.Parent = Watermark
    
    -- Gradient effect
    local Gradient = Instance.new("UIGradient")
    Gradient.Color = Netro65UI.Theme.Gradient.Color
    Gradient.Rotation = Netro65UI.Theme.Gradient.Rotation
    Gradient.Parent = UIStroke
    
    local Label = Instance.new("TextLabel")
    Label.Text = text or "NetroUI V5.0 | " .. LocalPlayer.Name
    Label.Font = Netro65UI.Theme.FontBold
    Label.TextSize = 12
    Label.TextColor3 = Color3.new(1, 1, 1)
    Label.BackgroundTransparency = 1
    Label.Size = UDim2.new(1, 0, 1, 0)
    Label.Parent = Watermark
    
    -- FPS counter
    local FPSLabel = Instance.new("TextLabel")
    FPSLabel.Text = "FPS: 60"
    FPSLabel.Font = Netro65UI.Theme.FontMain
    FPSLabel.TextSize = 10
    FPSLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    FPSLabel.BackgroundTransparency = 1
    FPSLabel.Size = UDim2.new(0, 50, 0, 15)
    FPSLabel.Position = UDim2.new(1, -55, 1, -20)
    FPSLabel.TextXAlignment = Enum.TextXAlignment.Right
    FPSLabel.Parent = Watermark
    
    -- Update FPS
    spawn(function()
        while Watermark and Watermark.Parent do
            local fps = math.floor(1/RunService.RenderStepped:Wait())
            FPSLabel.Text = "FPS: " .. fps
            wait(1)
        end
    end)
    
    -- Make draggable
    local dragging, dragInput, dragStart, startPos
    Label.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Watermark.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    Label.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            Watermark.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    -- Auto-hide/show on mouse
    local hidden = false
    Watermark.MouseEnter:Connect(function()
        if hidden then
            hidden = false
            TweenService:Create(Watermark, TweenInfo.new(0.3), {BackgroundTransparency = 0.7}):Play()
        end
    end)
    
    Watermark.MouseLeave:Connect(function()
        if not hidden then
            hidden = true
            TweenService:Create(Watermark, TweenInfo.new(0.3), {BackgroundTransparency = 0.9}):Play()
        end
    end)
    
    return Watermark
end

--// Enhanced Utility Functions
local Utility = {}

function Utility:Create(className, properties, children)
    local instance = Instance.new(className)
    for k, v in pairs(properties or {}) do
        instance[k] = v
    end
    for _, child in pairs(children or {}) do
        child.Parent = instance
    end
    return instance
end

function Utility:Tween(instance, info, goals)
    local tweenInfo = type(info) == "table" and TweenInfo.new(unpack(info)) or info
    local tween = TweenService:Create(instance, tweenInfo, goals)
    tween:Play()
    return tween
end

function Utility:MakeDraggable(frame, handle)
    handle = handle or frame
    local dragging, dragInput, dragStart, startPos
    
    local function update(input)
        local delta = input.Position - dragStart
        TweenService:Create(frame, TweenInfo.new(0.1), {
            Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X, 
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        }):Play()
    end
    
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then 
                    dragging = false 
                end
            end)
        end
    end)
    
    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

function Utility:Ripple(button)
    spawn(function()
        local ripple = Utility:Create("Frame", {
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 0.85,
            BorderSizePixel = 0,
            Position = UDim2.new(0, MOUSE.X - button.AbsolutePosition.X, 0, MOUSE.Y - button.AbsolutePosition.Y),
            Size = UDim2.new(0, 0, 0, 0),
            ZIndex = 10,
            Parent = button
        }, {
            Utility:Create("UICorner", {CornerRadius = UDim.new(1, 0)})
        })
        
        button.ClipsDescendants = true
        Utility:Tween(ripple, {0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out}, {
            Size = UDim2.new(0, 500, 0, 500),
            Position = UDim2.new(0.5, -250, 0.5, -250),
            BackgroundTransparency = 1
        })
        task.wait(0.6)
        if ripple then ripple:Destroy() end
    end)
end

function Utility:AddToolTip(element, text)
    local tooltip = nil
    local debounce = false
    
    element.MouseEnter:Connect(function()
        if debounce then return end
        debounce = true
        
        tooltip = Utility:Create("Frame", {
            Name = "Tooltip",
            BackgroundColor3 = Netro65UI.Theme.Main,
            BorderSizePixel = 0,
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0, element.AbsolutePosition.X + element.AbsoluteSize.X + 5, 0, element.AbsolutePosition.Y),
            ZIndex = 1000,
            Parent = ScreenGui
        }, {
            Utility:Create("UICorner", {CornerRadius = UDim.new(0, 6)}),
            Utility:Create("UIStroke", {Color = Netro65UI.Theme.Accent, Thickness = 1}),
            Utility:Create("UIGradient", {
                Color = Netro65UI.Theme.Gradient.Color,
                Rotation = Netro65UI.Theme.Gradient.Rotation
            }),
            Utility:Create("TextLabel", {
                Text = text,
                Font = Netro65UI.Theme.FontMain,
                TextSize = 12,
                TextColor3 = Netro65UI.Theme.Text,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -10, 1, -10),
                Position = UDim2.new(0, 5, 0, 5),
                TextWrapped = true
            })
        })
        
        -- Calculate text size
        local textSize = TextService:GetTextSize(text, 12, Netro65UI.Theme.FontMain, Vector2.new(200, math.huge))
        Utility:Tween(tooltip, {0.2}, {
            Size = UDim2.new(0, textSize.X + 20, 0, textSize.Y + 10)
        })
    end)
    
    element.MouseLeave:Connect(function()
        debounce = false
        if tooltip then
            Utility:Tween(tooltip, {0.2}, {Size = UDim2.new(0, 0, 0, 0)})
            task.wait(0.2)
            tooltip:Destroy()
        end
    end)
end

--// Advanced Color Picker System
function Utility:ColorPicker(defaultColor, callback)
    local colorPicker = {}
    local currentColor = defaultColor or Color3.new(1, 1, 1)
    local hue, sat, val = currentColor:ToHSV()
    
    local ColorFrame = Utility:Create("Frame", {
        Parent = ScreenGui,
        BackgroundColor3 = Netro65UI.Theme.Main,
        Size = UDim2.new(0, 300, 0, 350),
        Position = UDim2.new(0.5, -150, 0.5, -175),
        ZIndex = 2000
    }, {
        Utility:Create("UICorner", {CornerRadius = UDim.new(0, 12)}),
        Utility:Create("UIStroke", {Color = Netro65UI.Theme.Accent, Thickness = 2}),
        Utility:Create("UIGradient", {
            Color = Netro65UI.Theme.Gradient.Color,
            Rotation = Netro65UI.Theme.Gradient.Rotation
        }),
        Utility:Create("TextLabel", {
            Text = "Color Picker",
            Font = Netro65UI.Theme.FontBold,
            TextSize = 18,
            TextColor3 = Netro65UI.Theme.Text,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 40),
            Position = UDim2.new(0, 0, 0, 10)
        })
    })
    
    -- Color preview
    local Preview = Utility:Create("Frame", {
        Parent = ColorFrame,
        BackgroundColor3 = currentColor,
        Size = UDim2.new(0.8, 0, 0, 50),
        Position = UDim2.new(0.1, 0, 0, 60)
    }, {
        Utility:Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
        Utility:Create("UIStroke", {Color = Netro65UI.Theme.Outline, Thickness = 1})
    })
    
    -- HEX input
    local HexBox = Utility:Create("TextBox", {
        Parent = ColorFrame,
        Text = Utility:RGBToHex(currentColor),
        Font = Netro65UI.Theme.FontMain,
        TextSize = 12,
        TextColor3 = Netro65UI.Theme.Text,
        BackgroundColor3 = Netro65UI.Theme.Secondary,
        Size = UDim2.new(0.8, 0, 0, 30),
        Position = UDim2.new(0.1, 0, 0, 120),
        PlaceholderText = "HEX Color"
    }, {
        Utility:Create("UICorner", {CornerRadius = UDim.new(0, 6)})
    })
    
    -- Hue slider
    local HueSlider = Utility:Create("Frame", {
        Parent = ColorFrame,
        BackgroundColor3 = Color3.new(1, 1, 1),
        Size = UDim2.new(0.8, 0, 0, 20),
        Position = UDim2.new(0.1, 0, 0, 160)
    }, {
        Utility:Create("UIGradient", {
            Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
                ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 0, 255)),
                ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 0, 255)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
                ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 255, 0)),
                ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 255, 0)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
            }
        }),
        Utility:Create("UICorner", {CornerRadius = UDim.new(0, 4)})
    })
    
    local HueKnob = Utility:Create("Frame", {
        Parent = HueSlider,
        BackgroundColor3 = Color3.new(1, 1, 1),
        Size = UDim2.new(0, 10, 1, 4),
        Position = UDim2.new(hue, -5, 0, -2),
        ZIndex = 2
    }, {
        Utility:Create("UICorner", {CornerRadius = UDim.new(0, 4)}),
        Utility:Create("UIStroke", {Color = Color3.new(0, 0, 0), Thickness = 2})
    })
    
    -- Saturation/Value picker
    local SVPicker = Utility:Create("ImageLabel", {
        Parent = ColorFrame,
        Image = "rbxassetid://4155801252",
        Size = UDim2.new(0, 150, 0, 150),
        Position = UDim2.new(0.1, 0, 0, 190),
        BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
    }, {
        Utility:Create("UICorner", {CornerRadius = UDim.new(0, 4)})
    })
    
    local SVKnob = Utility:Create("Frame", {
        Parent = SVPicker,
        BackgroundColor3 = Color3.new(1, 1, 1),
        Size = UDim2.new(0, 10, 0, 10),
        Position = UDim2.new(sat, -5, 1-val, -5),
        ZIndex = 2
    }, {
        Utility:Create("UICorner", {CornerRadius = UDim.new(1, 0)}),
        Utility:Create("UIStroke", {Color = Color3.new(0, 0, 0), Thickness = 2})
    })
    
    -- Preset colors
    local presets = {
        Color3.fromRGB(255, 0, 0),    -- Red
        Color3.fromRGB(0, 255, 0),    -- Green
        Color3.fromRGB(0, 0, 255),    -- Blue
        Color3.fromRGB(255, 255, 0),  -- Yellow
        Color3.fromRGB(255, 0, 255),  -- Magenta
        Color3.fromRGB(0, 255, 255),  -- Cyan
        Color3.fromRGB(255, 255, 255),-- White
        Color3.fromRGB(0, 0, 0)       -- Black
    }
    
    local PresetContainer = Utility:Create("Frame", {
        Parent = ColorFrame,
        BackgroundTransparency = 1,
        Size = UDim2.new(0.8, 0, 0, 30),
        Position = UDim2.new(0.1, 0, 0, 350)
    })
    
    for i, color in ipairs(presets) do
        local PresetBtn = Utility:Create("TextButton", {
            Parent = PresetContainer,
            BackgroundColor3 = color,
            Size = UDim2.new(0, 25, 0, 25),
            Position = UDim2.new(0, (i-1)*30, 0, 0),
            AutoButtonColor = false
        }, {
            Utility:Create("UICorner", {CornerRadius = UDim.new(0, 4)}),
            Utility:Create("UIStroke", {Color = Netro65UI.Theme.Outline, Thickness = 1})
        })
        
        PresetBtn.MouseButton1Click:Connect(function()
            currentColor = color
            Preview.BackgroundColor3 = color
            HexBox.Text = Utility:RGBToHex(color)
            if callback then callback(color) end
        end)
    end
    
    -- Buttons
    local ButtonContainer = Utility:Create("Frame", {
        Parent = ColorFrame,
        BackgroundTransparency = 1,
        Size = UDim2.new(0.8, 0, 0, 40),
        Position = UDim2.new(0.1, 0, 1, -60)
    })
    
    local ApplyBtn = Utility:Create("TextButton", {
        Parent = ButtonContainer,
        Text = "Apply",
        Font = Netro65UI.Theme.FontBold,
        TextSize = 14,
        TextColor3 = Netro65UI.Theme.Text,
        BackgroundColor3 = Netro65UI.Theme.Success,
        Size = UDim2.new(0.48, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        AutoButtonColor = false
    }, {
        Utility:Create("UICorner", {CornerRadius = UDim.new(0, 6)})
    })
    
    local CancelBtn = Utility:Create("TextButton", {
        Parent = ButtonContainer,
        Text = "Cancel",
        Font = Netro65UI.Theme.FontBold,
        TextSize = 14,
        TextColor3 = Netro65UI.Theme.Text,
        BackgroundColor3 = Netro65UI.Theme.Error,
        Size = UDim2.new(0.48, 0, 1, 0),
        Position = UDim2.new(0.52, 0, 0, 0),
        AutoButtonColor = false
    }, {
        Utility:Create("UICorner", {CornerRadius = UDim.new(0, 6)})
    })
    
    local function updateColor()
        Preview.BackgroundColor3 = currentColor
        HexBox.Text = Utility:RGBToHex(currentColor)
        if callback then callback(currentColor) end
    end
    
    local function updateFromHSV(h, s, v)
        currentColor = Color3.fromHSV(h, s, v)
        SVPicker.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
        updateColor()
    end
    
    -- Hue slider interaction
    local hueDragging = false
    HueSlider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            hueDragging = true
            local percent = (input.Position.X - HueSlider.AbsolutePosition.X) / HueSlider.AbsoluteSize.X
            hue = math.clamp(percent, 0, 1)
            HueKnob.Position = UDim2.new(hue, -5, 0, -2)
            updateFromHSV(hue, sat, val)
        end
    end)
    
    HueSlider.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            hueDragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if hueDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local percent = (input.Position.X - HueSlider.AbsolutePosition.X) / HueSlider.AbsoluteSize.X
            hue = math.clamp(percent, 0, 1)
            HueKnob.Position = UDim2.new(hue, -5, 0, -2)
            updateFromHSV(hue, sat, val)
        end
    end)
    
    -- SV picker interaction
    local svDragging = false
    SVPicker.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            svDragging = true
            local x = (input.Position.X - SVPicker.AbsolutePosition.X) / SVPicker.AbsoluteSize.X
            local y = (input.Position.Y - SVPicker.AbsolutePosition.Y) / SVPicker.AbsoluteSize.Y
            sat = math.clamp(x, 0, 1)
            val = 1 - math.clamp(y, 0, 1)
            SVKnob.Position = UDim2.new(sat, -5, 1-val, -5)
            updateFromHSV(hue, sat, val)
        end
    end)
    
    SVPicker.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            svDragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if svDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local x = (input.Position.X - SVPicker.AbsolutePosition.X) / SVPicker.AbsoluteSize.X
            local y = (input.Position.Y - SVPicker.AbsolutePosition.Y) / SVPicker.AbsoluteSize.Y
            sat = math.clamp(x, 0, 1)
            val = 1 - math.clamp(y, 0, 1)
            SVKnob.Position = UDim2.new(sat, -5, 1-val, -5)
            updateFromHSV(hue, sat, val)
        end
    end)
    
    -- HEX input
    HexBox.FocusLost:Connect(function()
        local hex = HexBox.Text:gsub("#", "")
        if #hex == 6 then
            local r = tonumber("0x"..hex:sub(1,2)) / 255
            local g = tonumber("0x"..hex:sub(3,4)) / 255
            local b = tonumber("0x"..hex:sub(5,6)) / 255
            if r and g and b then
                currentColor = Color3.new(r, g, b)
                hue, sat, val = currentColor:ToHSV()
                HueKnob.Position = UDim2.new(hue, -5, 0, -2)
                SVKnob.Position = UDim2.new(sat, -5, 1-val, -5)
                SVPicker.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
                updateColor()
            end
        end
    end)
    
    -- Button events
    ApplyBtn.MouseButton1Click:Connect(function()
        updateColor()
        ColorFrame:Destroy()
    end)
    
    CancelBtn.MouseButton1Click:Connect(function()
        ColorFrame:Destroy()
    end)
    
    Utility:MakeDraggable(ColorFrame)
    
    return colorPicker
end

-- Helper function for color conversion
function Utility:RGBToHex(color)
    local r = math.floor(color.R * 255)
    local g = math.floor(color.G * 255)
    local b = math.floor(color.B * 255)
    return string.format("#%02X%02X%02X", r, g, b)
end

--// Advanced Notification System with Multiple Types
local NotificationContainer = Utility:Create("Frame", {
    Name = "Notifications",
    Parent = ScreenGui,
    BackgroundTransparency = 1,
    Position = UDim2.new(1, -300, 0, 30),
    Size = UDim2.new(0, 280, 1, -30),
    ZIndex = 500
}, {
    Utility:Create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder, 
        Padding = UDim.new(0, 10), 
        VerticalAlignment = Enum.VerticalAlignment.Bottom
    })
})

function Netro65UI:Notify(props)
    local title = props.Title or "Notification"
    local content = props.Content or "Information"
    local duration = props.Duration or 4
    local icon = props.Icon or "ℹ️"
    local typeColor = Netro65UI.Theme.Accent
    local sound = props.Sound or false
    
    -- Set icon and color based on type
    if props.Type == "Success" then 
        typeColor = Netro65UI.Theme.Success
        icon = "✅"
    elseif props.Type == "Warning" then 
        typeColor = Netro65UI.Theme.Warning
        icon = "⚠️"
    elseif props.Type == "Error" then 
        typeColor = Netro65UI.Theme.Error
        icon = "❌"
    elseif props.Type == "Info" then
        typeColor = Netro65UI.Theme.Info
        icon = "ℹ️"
    end

    local NotifFrame = Utility:Create("Frame", {
        Name = "Notification",
        Parent = NotificationContainer, 
        BackgroundColor3 = Netro65UI.Theme.Secondary,
        Size = UDim2.new(1, 0, 0, 0), 
        BorderSizePixel = 0, 
        ClipsDescendants = true, 
        BackgroundTransparency = 0.05
    }, {
        Utility:Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
        Utility:Create("UIStroke", {Color = typeColor, Thickness = 2, Transparency = 0.3}),
        Utility:Create("UIGradient", {
            Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, typeColor),
                ColorSequenceKeypoint.new(1, Netro65UI.Theme.Secondary)
            },
            Rotation = 90
        }),
        Utility:Create("TextLabel", {
            Text = icon .. " " .. title, 
            Font = Netro65UI.Theme.FontBold, 
            TextSize = 14, 
            TextColor3 = Netro65UI.Theme.Text, 
            BackgroundTransparency = 1, 
            Position = UDim2.new(0, 15, 0, 8), 
            Size = UDim2.new(1, -60, 0, 18), 
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd
        }),
        Utility:Create("TextLabel", {
            Text = content, 
            Font = Netro65UI.Theme.FontMain, 
            TextSize = 12, 
            TextColor3 = Netro65UI.Theme.TextDark, 
            BackgroundTransparency = 1, 
            Position = UDim2.new(0, 15, 0, 30), 
            Size = UDim2.new(1, -30, 1, -35), 
            TextXAlignment = Enum.TextXAlignment.Left, 
            TextWrapped = true, 
            TextYAlignment = Enum.TextYAlignment.Top
        }),
        Utility:Create("Frame", {
            Name = "Timer", 
            BackgroundColor3 = typeColor, 
            Size = UDim2.new(1, 0, 0, 3), 
            Position = UDim2.new(0, 0, 1, -3), 
            BorderSizePixel = 0
        }, {
            Utility:Create("UICorner", {CornerRadius = UDim.new(0, 6)})
        }),
        Utility:Create("TextButton", {
            Name = "CloseBtn",
            Text = "✕",
            Font = Netro65UI.Theme.FontBold,
            TextSize = 14,
            TextColor3 = Netro65UI.Theme.TextDark,
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 25, 0, 25),
            Position = UDim2.new(1, -30, 0, 5)
        })
    })

    -- Animation
    Utility:Tween(NotifFrame, {0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out}, {
        Size = UDim2.new(1, 0, 0, 80)
    })
    
    -- Timer animation
    Utility:Tween(NotifFrame.Timer, {duration, Enum.EasingStyle.Linear}, {
        Size = UDim2.new(0, 0, 0, 3)
    })
    
    -- Close button
    NotifFrame.CloseBtn.MouseButton1Click:Connect(function()
        Utility:Tween(NotifFrame, {0.3}, {
            Size = UDim2.new(1, 0, 0, 0), 
            BackgroundTransparency = 1
        })
        task.wait(0.3)
        NotifFrame:Destroy()
    end)
    
    -- Auto-remove after duration
    task.delay(duration, function() 
        if NotifFrame and NotifFrame.Parent then
            Utility:Tween(NotifFrame, {0.3}, {
                Size = UDim2.new(1, 0, 0, 0), 
                BackgroundTransparency = 1
            })
            task.wait(0.3)
            NotifFrame:Destroy()
        end
    end)
    
    -- Play sound if enabled
    if sound then
        -- Sound effect can be implemented here
    end
end

--// Advanced Keybind System with Modifiers
function Netro65UI:CreateKeybind(name, defaultKey, callback, modifiers)
    local keybind = {
        Name = name,
        Key = defaultKey,
        Modifiers = modifiers or {}, -- e.g., {"Ctrl", "Shift"}
        Callback = callback,
        Connection = nil,
        Active = true
    }
    
    Netro65UI.Keybinds[name] = keybind
    
    -- Listen for key presses with modifiers
    keybind.Connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed or not keybind.Active then return end
        
        local modifiersPressed = true
        if #keybind.Modifiers > 0 then
            for _, mod in ipairs(keybind.Modifiers) do
                if mod == "Ctrl" and not UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) and not UserInputService:IsKeyDown(Enum.KeyCode.RightControl) then
                    modifiersPressed = false
                elseif mod == "Shift" and not UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) and not UserInputService:IsKeyDown(Enum.KeyCode.RightShift) then
                    modifiersPressed = false
                elseif mod == "Alt" and not UserInputService:IsKeyDown(Enum.KeyCode.LeftAlt) and not UserInputService:IsKeyDown(Enum.KeyCode.RightAlt) then
                    modifiersPressed = false
                end
            end
        end
        
        if modifiersPressed and input.KeyCode == keybind.Key then
            callback()
        end
    end)
    
    return keybind
end

function Netro65UI:UpdateKeybind(name, newKey, newModifiers)
    if Netro65UI.Keybinds[name] then
        Netro65UI.Keybinds[name].Key = newKey
        Netro65UI.Keybinds[name].Modifiers = newModifiers or {}
    end
end

function Netro65UI:ToggleKeybind(name, state)
    if Netro65UI.Keybinds[name] then
        Netro65UI.Keybinds[name].Active = state
    end
end

function Netro65UI:RemoveKeybind(name)
    if Netro65UI.Keybinds[name] and Netro65UI.Keybinds[name].Connection then
        Netro65UI.Keybinds[name].Connection:Disconnect()
        Netro65UI.Keybinds[name] = nil
    end
end

--// Advanced Command System with Arguments
local CommandBar = nil
local Commands = {}

function Netro65UI:RegisterCommand(name, description, callback, usage)
    Commands[name:lower()] = {
        Name = name,
        Description = description,
        Callback = callback,
        Usage = usage or name,
        Aliases = {}
    }
end

function Netro65UI:RegisterCommandAlias(command, alias)
    if Commands[command:lower()] then
        table.insert(Commands[command:lower()].Aliases, alias:lower())
        Commands[alias:lower()] = Commands[command:lower()]
    end
end

function Netro65UI:ShowCommandBar()
    if CommandBar then CommandBar:Destroy() end
    
    CommandBar = Utility:Create("Frame", {
        Parent = ScreenGui,
        BackgroundColor3 = Netro65UI.Theme.Main,
        Size = UDim2.new(0, 500, 0, 50),
        Position = UDim2.new(0.5, -250, 0, -60),
        ZIndex = 3000
    }, {
        Utility:Create("UICorner", {CornerRadius = UDim.new(0, 12)}),
        Utility:Create("UIStroke", {Color = Netro65UI.Theme.Accent, Thickness = 2}),
        Utility:Create("UIGradient", {
            Color = Netro65UI.Theme.Gradient.Color,
            Rotation = Netro65UI.Theme.Gradient.Rotation
        }),
        Utility:Create("TextBox", {
            Name = "Input",
            PlaceholderText = "Type command... (Press 'F1' for help)",
            Font = Netro65UI.Theme.FontMain,
            TextSize = 14,
            TextColor3 = Netro65UI.Theme.Text,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -20, 1, 0),
            Position = UDim2.new(0, 15, 0, 0),
            TextXAlignment = Enum.TextXAlignment.Left
        })
    })
    
    Utility:Tween(CommandBar, {0.3}, {Position = UDim2.new(0.5, -250, 0, 20)})
    CommandBar.Input:CaptureFocus()
    
    -- Auto-complete suggestions
    local suggestionBox = nil
    CommandBar.Input:GetPropertyChangedSignal("Text"):Connect(function()
        if suggestionBox then suggestionBox:Destroy() end
        
        local text = CommandBar.Input.Text
        if #text > 0 then
            local suggestions = {}
            for cmdName, cmd in pairs(Commands) do
                if string.find(cmdName:lower(), text:lower()) == 1 then
                    table.insert(suggestions, cmd)
                end
            end
            
            if #suggestions > 0 then
                suggestionBox = Utility:Create("Frame", {
                    Parent = ScreenGui,
                    BackgroundColor3 = Netro65UI.Theme.Main,
                    Size = UDim2.new(0, 500, 0, #suggestions * 30 + 10),
                    Position = UDim2.new(0.5, -250, 0, 75),
                    ZIndex = 3001
                }, {
                    Utility:Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
                    Utility:Create("UIStroke", {Color = Netro65UI.Theme.Accent, Thickness = 1})
                })
                
                for i, cmd in ipairs(suggestions) do
                    local suggestion = Utility:Create("TextButton", {
                        Parent = suggestionBox,
                        Text = cmd.Usage,
                        Font = Netro65UI.Theme.FontMain,
                        TextSize = 12,
                        TextColor3 = Netro65UI.Theme.Text,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, 0, 0, 30),
                        Position = UDim2.new(0, 0, 0, (i-1)*30),
                        TextXAlignment = Enum.TextXAlignment.Left,
                        AutoButtonColor = false
                    })
                    
                    suggestion.MouseButton1Click:Connect(function()
                        CommandBar.Input.Text = cmd.Name .. " "
                        CommandBar.Input.CursorPosition = #CommandBar.Input.Text + 1
                        suggestionBox:Destroy()
                    end)
                end
            end
        end
    end)
    
    CommandBar.Input.FocusLost:Connect(function(enterPressed)
        if suggestionBox then suggestionBox:Destroy() end
        
        if enterPressed then
            local text = CommandBar.Input.Text:gsub("^%s*(.-)%s*$", "%1")
            local args = {}
            for arg in text:gmatch("%S+") do
                table.insert(args, arg)
            end
            
            if #args > 0 then
                local cmdName = args[1]:lower()
                table.remove(args, 1)
                
                if Commands[cmdName] then
                    local success, err = pcall(function()
                        Commands[cmdName].Callback(args)
                    end)
                    
                    if not success then
                        Netro65UI:Notify({
                            Title = "Command Error",
                            Content = err,
                            Type = "Error"
                        })
                    end
                else
                    Netro65UI:Notify({
                        Title = "Unknown Command",
                        Content = "Type 'help' for command list",
                        Type = "Warning"
                    })
                end
            end
            
            Utility:Tween(CommandBar, {0.3}, {Position = UDim2.new(0.5, -250, 0, -60)})
            task.wait(0.3)
            CommandBar:Destroy()
            CommandBar = nil
        end
    end)
    
    -- Auto-close on click outside
    local connection
    connection = UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local mousePos = UserInputService:GetMouseLocation()
            if not (CommandBar.AbsolutePosition.X <= mousePos.X and mousePos.X <= CommandBar.AbsolutePosition.X + CommandBar.AbsoluteSize.X and
                    CommandBar.AbsolutePosition.Y <= mousePos.Y and mousePos.Y <= CommandBar.AbsolutePosition.Y + CommandBar.AbsoluteSize.Y) then
                if CommandBar then
                    Utility:Tween(CommandBar, {0.3}, {Position = UDim2.new(0.5, -250, 0, -60)})
                    task.wait(0.3)
                    CommandBar:Destroy()
                    CommandBar = nil
                end
                connection:Disconnect()
            end
        end
    end)
end

--// Advanced Server Info Panel with More Stats
function Netro65UI:CreateServerInfoPanel()
    local panel = Utility:Create("Frame", {
        Parent = ScreenGui,
        BackgroundColor3 = Netro65UI.Theme.Main,
        Size = UDim2.new(0, 250, 0, 200),
        Position = UDim2.new(1, -260, 1, -210),
        ZIndex = 100
    }, {
        Utility:Create("UICorner", {CornerRadius = UDim.new(0, 12)}),
        Utility:Create("UIStroke", {Color = Netro65UI.Theme.Accent, Thickness = 2}),
        Utility:Create("UIGradient", {
            Color = Netro65UI.Theme.Gradient.Color,
            Rotation = Netro65UI.Theme.Gradient.Rotation
        }),
        Utility:Create("TextLabel", {
            Text = "📊 Server Info",
            Font = Netro65UI.Theme.FontBold,
            TextSize = 16,
            TextColor3 = Netro65UI.Theme.Accent,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 30),
            Position = UDim2.new(0, 15, 0, 10)
        })
    })
    
    local playerCount = #Players:GetPlayers()
    local maxPlayers = Players.MaxPlayers
    local placeId = game.PlaceId
    local jobId = game.JobId
    
    local stats = {
        Utility:Create("TextLabel", {
            Text = "👥 Players: " .. playerCount .. "/" .. maxPlayers,
            Font = Netro65UI.Theme.FontMain,
            TextSize = 13,
            TextColor3 = Netro65UI.Theme.Text,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -20, 0, 20),
            Position = UDim2.new(0, 15, 0, 50),
            TextXAlignment = Enum.TextXAlignment.Left
        }),
        Utility:Create("TextLabel", {
            Text = "📶 Ping: Calculating...",
            Font = Netro65UI.Theme.FontMain,
            TextSize = 13,
            TextColor3 = Netro65UI.Theme.Text,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -20, 0, 20),
            Position = UDim2.new(0, 15, 0, 75),
            TextXAlignment = Enum.TextXAlignment.Left
        }),
        Utility:Create("TextLabel", {
            Text = "🎮 FPS: 60",
            Font = Netro65UI.Theme.FontMain,
            TextSize = 13,
            TextColor3 = Netro65UI.Theme.Text,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -20, 0, 20),
            Position = UDim2.new(0, 15, 0, 100),
            TextXAlignment = Enum.TextXAlignment.Left
        }),
        Utility:Create("TextLabel", {
            Text = "🆔 Place ID: " .. placeId,
            Font = Netro65UI.Theme.FontMain,
            TextSize = 11,
            TextColor3 = Netro65UI.Theme.TextDark,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -20, 0, 20),
            Position = UDim2.new(0, 15, 0, 125),
            TextXAlignment = Enum.TextXAlignment.Left
        }),
        Utility:Create("TextButton", {
            Text = "📋 Copy Job ID",
            Font = Netro65UI.Theme.FontMain,
            TextSize = 11,
            TextColor3 = Netro65UI.Theme.Text,
            BackgroundColor3 = Netro65UI.Theme.Secondary,
            Size = UDim2.new(0.8, 0, 0, 25),
            Position = UDim2.new(0.1, 0, 0, 160),
            AutoButtonColor = false
        }, {
            Utility:Create("UICorner", {CornerRadius = UDim.new(0, 6)})
        })
    }
    
    for _, stat in pairs(stats) do
        stat.Parent = panel
    end
    
    -- Update info in real-time
    spawn(function()
        while panel and panel.Parent do
            playerCount = #Players:GetPlayers()
            stats[1].Text = "👥 Players: " .. playerCount .. "/" .. maxPlayers
            
            -- FPS counter
            local fps = math.floor(1/RunService.RenderStepped:Wait())
            stats[3].Text = "🎮 FPS: " .. fps
            
            wait(1)
        end
    end)
    
    -- Copy Job ID button
    stats[5].MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard(jobId)
            Netro65UI:Notify({
                Title = "Copied",
                Content = "Job ID copied to clipboard!",
                Type = "Success"
            })
        end
    end)
    
    -- Close button
    local CloseBtn = Utility:Create("TextButton", {
        Parent = panel,
        Text = "✕",
        Font = Netro65UI.Theme.FontBold,
        TextSize = 14,
        TextColor3 = Netro65UI.Theme.TextDark,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -35, 0, 5)
    })
    
    CloseBtn.MouseButton1Click:Connect(function()
        panel:Destroy()
    end)
    
    Utility:MakeDraggable(panel)
    
    return panel
end

--// Enhanced Auto-Save System with Versioning
local AutoSave = {
    Enabled = false,
    Interval = 60,
    MaxBackups = 5,
    Connection = nil,
    Version = "1.0"
}

function Netro65UI:ToggleAutoSave(enabled, interval, maxBackups)
    AutoSave.Enabled = enabled
    AutoSave.Interval = interval or 60
    AutoSave.MaxBackups = maxBackups or 5
    
    if AutoSave.Connection then
        AutoSave.Connection:Disconnect()
        AutoSave.Connection = nil
    end
    
    if enabled then
        AutoSave.Connection = RunService.Heartbeat:Connect(function()
            task.wait(interval)
            Netro65UI:SaveConfig("autosave_backup_" .. os.time(), false)
            
            -- Manage backup limit
            local backups = {}
            local path = Netro65UI.ConfigFolder .. "/" .. tostring(game.PlaceId)
            if isfolder(path) then
                local files = listfiles(path)
                for _, file in pairs(files) do
                    if string.find(file, "autosave_backup_") then
                        table.insert(backups, file)
                    end
                end
                
                if #backups > maxBackups then
                    table.sort(backups)
                    for i = 1, #backups - maxBackups do
                        delfile(backups[i])
                    end
                end
            end
        end)
    end
end

--// Enhanced Config System with Encryption
function Netro65UI:SaveConfig(name, isUniversal, encrypt)
    local folder = Netro65UI.ConfigFolder
    if not isfolder(folder) then 
        if makefolder then
            makefolder(folder)
        else
            Netro65UI:Notify({
                Title = "Save Failed", 
                Content = "File system not supported", 
                Type = "Error"
            })
            return
        end
    end
    
    local path = folder .. "/" .. (isUniversal and "Universal" or tostring(game.PlaceId))
    if not isfolder(path) then 
        if makefolder then
            makefolder(path)
        end
    end
    
    -- Collect all data
    local saveData = {
        Version = Netro65UI.Version,
        Timestamp = os.time(),
        Flags = Netro65UI.Flags,
        Theme = {
            Main = {Netro65UI.Theme.Main.R, Netro65UI.Theme.Main.G, Netro65UI.Theme.Main.B},
            Accent = {Netro65UI.Theme.Accent.R, Netro65UI.Theme.Accent.G, Netro65UI.Theme.Accent.B},
            UseGradient = Netro65UI.Theme.UseGradient
        },
        Settings = {
            Acrylic = Acrylic.Active,
            RainbowMode = Netro65UI.RainbowMode.Enabled,
            Language = Netro65UI.Language
        }
    }
    
    -- Simple encryption (XOR)
    if encrypt then
        local key = "NetroUI2024"
        local dataStr = HttpService:JSONEncode(saveData)
        local encrypted = ""
        for i = 1, #dataStr do
            local char = string.sub(dataStr, i, i)
            local keyChar = string.sub(key, (i - 1) % #key + 1, (i - 1) % #key + 1)
            encrypted = encrypted .. string.char(bit32.bxor(string.byte(char), string.byte(keyChar)))
        end
        saveData = {Encrypted = encrypted}
    end
    
    local success, err = pcall(function()
        if writefile then
            writefile(path .. "/" .. name .. ".json", HttpService:JSONEncode(saveData))
            return true
        else
            return false, "File write not supported"
        end
    end)
    
    if success then 
        Netro65UI:Notify({
            Title = "Config Saved", 
            Content = "Saved: " .. name, 
            Type = "Success"
        })
    else
        Netro65UI:Notify({
            Title = "Save Failed", 
            Content = err, 
            Type = "Error"
        }) 
    end
end

function Netro65UI:LoadConfig(name, isUniversal)
    local path = Netro65UI.ConfigFolder .. "/" .. (isUniversal and "Universal" or tostring(game.PlaceId)) .. "/" .. name .. ".json"
    if not isfile(path) then 
        Netro65UI:Notify({
            Title = "Error", 
            Content = "Config file not found.", 
            Type = "Error"
        }) 
        return 
    end

    local success, content = pcall(function() 
        if readfile then
            return readfile(path) 
        else
            return nil, "File read not supported"
        end
    end)
    
    if success and content then
        local success2, data = pcall(function() 
            return HttpService:JSONDecode(content) 
        end)
        
        if success2 and data then
            -- Check if encrypted
            if data.Encrypted then
                local key = "NetroUI2024"
                local decrypted = ""
                for i = 1, #data.Encrypted do
                    local char = string.sub(data.Encrypted, i, i)
                    local keyChar = string.sub(key, (i - 1) % #key + 1, (i - 1) % #key + 1)
                    decrypted = decrypted .. string.char(bit32.bxor(string.byte(char), string.byte(keyChar)))
                end
                data = HttpService:JSONDecode(decrypted)
            end
            
            -- Load theme
            if data.Theme then
                Netro65UI.Theme.Main = Color3.new(unpack(data.Theme.Main))
                Netro65UI.Theme.Accent = Color3.new(unpack(data.Theme.Accent))
                Netro65UI.Theme.UseGradient = data.Theme.UseGradient or false
                Netro65UI:SetTheme("Default")
            end
            
            -- Load flags
            for flag, value in pairs(data.Flags or {}) do
                Netro65UI.Flags[flag] = value
                if Netro65UI.Setters[flag] then
                    Netro65UI.Setters[flag](value)
                end
            end
            
            -- Load settings
            if data.Settings then
                Acrylic.Active = data.Settings.Acrylic or true
                Netro65UI:ToggleRainbowMode(data.Settings.RainbowMode or false)
                Netro65UI:SetLanguage(data.Settings.Language or "English")
            end
            
            Netro65UI:Notify({
                Title = "Config Loaded", 
                Content = "Loaded: " .. name, 
                Type = "Success"
            })
        else
            Netro65UI:Notify({
                Title = "Load Failed", 
                Content = "Corrupted JSON.", 
                Type = "Error"
            })
        end
    else
        Netro65UI:Notify({
            Title = "Load Failed", 
            Content = "Could not read file.", 
            Type = "Error"
        })
    end
end

--// Enhanced Window Creation with Modern Design
function Netro65UI:CreateWindow(props)
    local WindowObj = {}
    props = props or {}
    local windowWidth = props.Width or 600
    local windowHeight = props.Height or 400
    local titleText = props.Title or "Netro65UI V5.0"
    local icon = props.Icon or "⚡"
    
    Acrylic:Enable()
    
    -- Create watermark
    Netro65UI:CreateWatermark("NetroUI V5.0 | " .. LocalPlayer.Name)

    local MainFrame = Utility:Create("Frame", {
        Name = "MainWindow", 
        Parent = ScreenGui, 
        BackgroundColor3 = Netro65UI.Theme.Main, 
        Position = UDim2.new(0.5, -windowWidth/2, 0.5, -windowHeight/2), 
        Size = UDim2.fromOffset(windowWidth, windowHeight), 
        BorderSizePixel = 0, 
        BackgroundTransparency = 0.05
    }, {
        Utility:Create("UICorner", {CornerRadius = UDim.new(0, 12)}), 
        Utility:Create("UIStroke", {Color = Netro65UI.Theme.Accent, Thickness = 2}),
        Utility:Create("UIGradient", {
            Color = Netro65UI.Theme.Gradient.Color,
            Rotation = Netro65UI.Theme.Gradient.Rotation,
            Transparency = NumberSequence.new(0.5)
        })
    })
    
    table.insert(Netro65UI.ThemeObjects, {
        Instance = MainFrame, 
        Type = "Main"
    })

    local Header = Utility:Create("Frame", {
        Name = "Header", 
        Parent = MainFrame, 
        BackgroundColor3 = Netro65UI.Theme.Secondary, 
        Size = UDim2.new(1, 0, 0, 50), 
        BorderSizePixel = 0, 
        BackgroundTransparency = 0.3
    }, {
        Utility:Create("UICorner", {CornerRadius = UDim.new(0, 12)}),
        Utility:Create("UIGradient", {
            Color = Netro65UI.Theme.Gradient.Color,
            Rotation = Netro65UI.Theme.Gradient.Rotation,
            Transparency = NumberSequence.new(0.7)
        }),
        Utility:Create("TextLabel", {
            Text = icon .. " " .. titleText, 
            Font = Netro65UI.Theme.FontBold, 
            TextSize = 18, 
            TextColor3 = Netro65UI.Theme.Text, 
            BackgroundTransparency = 1, 
            Size = UDim2.new(0, 300, 1, 0), 
            Position = UDim2.new(0, 20, 0, 0), 
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd 
        }),
        Utility:Create("TextLabel", {
            Text = "v"..Netro65UI.Version, 
            Font = Netro65UI.Theme.FontMain, 
            TextSize = 12, 
            TextColor3 = Netro65UI.Theme.Accent, 
            BackgroundTransparency = 1, 
            Size = UDim2.new(0, 60, 1, 0), 
            Position = UDim2.new(0, 320, 0, 0), 
            TextXAlignment = Enum.TextXAlignment.Left
        })
    })
    
    table.insert(Netro65UI.ThemeObjects, {
        Instance = Header.TextLabel, 
        Type = "Accent", 
        Property = "TextColor3"
    })
    
    Utility:MakeDraggable(MainFrame, Header)

    -- Search Bar with enhanced features
    local SearchBar = Utility:Create("Frame", {
        Parent = Header, 
        BackgroundColor3 = Netro65UI.Theme.Main, 
        Size = UDim2.new(0, 180, 0, 32), 
        Position = UDim2.new(1, -230, 0.5, -16), 
        BackgroundTransparency = 0.5
    }, {
        Utility:Create("UICorner", {CornerRadius = UDim.new(0, 8)}), 
        Utility:Create("UIStroke", {Color = Netro65UI.Theme.Outline, Thickness = 1}), 
        Utility:Create("ImageLabel", {
            Image = "rbxassetid://6031094668", 
            BackgroundTransparency = 1, 
            Size = UDim2.new(0, 18, 0, 18), 
            Position = UDim2.new(0, 10, 0.5, -9), 
            ImageColor3 = Netro65UI.Theme.TextDark
        })
    })
    
    table.insert(Netro65UI.ThemeObjects, {
        Instance = SearchBar, 
        Type = "Main"
    })
    
    local SearchInput = Utility:Create("TextBox", {
        Parent = SearchBar, 
        BackgroundTransparency = 1, 
        Size = UDim2.new(1, -35, 1, 0), 
        Position = UDim2.new(0, 35, 0, 0), 
        Font = Netro65UI.Theme.FontMain, 
        TextSize = 13, 
        TextColor3 = Netro65UI.Theme.Text, 
        PlaceholderText = Netro65UI.Languages[Netro65UI.Language].Search, 
        PlaceholderColor3 = Netro65UI.Theme.TextDark, 
        TextXAlignment = Enum.TextXAlignment.Left,
        ClearTextOnFocus = false
    })

    -- Window controls
    local CloseBtn = Utility:Create("TextButton", {
        Parent = Header, 
        Text = "✕", 
        Font = Netro65UI.Theme.FontBold,
        TextSize = 16,
        TextColor3 = Netro65UI.Theme.Text,
        BackgroundColor3 = Color3.fromRGB(255, 80, 80), 
        Size = UDim2.new(0, 32, 0, 32), 
        Position = UDim2.new(1, -40, 0.5, -16), 
        AutoButtonColor = false
    }, {
        Utility:Create("UICorner", {CornerRadius = UDim.new(1,0)})
    })
    
    local MinBtn = Utility:Create("TextButton", {
        Parent = Header, 
        Text = "─", 
        Font = Netro65UI.Theme.FontBold,
        TextSize = 16,
        TextColor3 = Netro65UI.Theme.Text,
        BackgroundColor3 = Color3.fromRGB(255, 200, 80), 
        Size = UDim2.new(0, 32, 0, 32), 
        Position = UDim2.new(1, -80, 0.5, -16), 
        AutoButtonColor = false
    }, {
        Utility:Create("UICorner", {CornerRadius = UDim.new(1,0)})
    })

    -- Window control events
    CloseBtn.MouseButton1Click:Connect(function() 
        Acrylic:Disable() 
        Utility:Tween(MainFrame, {0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In}, {
            Size = UDim2.new(0,0,0,0),
            BackgroundTransparency = 1
        }) 
        task.wait(0.3) 
        ScreenGui:Destroy() 
    end)
    
    local IsMin = false
    MinBtn.MouseButton1Click:Connect(function() 
        IsMin = not IsMin 
        if IsMin then 
            Utility:Tween(MainFrame, {0.4}, {
                Size = UDim2.new(0, windowWidth, 0, 50)
            }) 
            MainFrame.Content.Visible = false 
            MinBtn.Text = "🗖"
        else 
            MainFrame.Content.Visible = true 
            Utility:Tween(MainFrame, {0.4}, {
                Size = UDim2.new(0, windowWidth, 0, windowHeight)
            }) 
            MinBtn.Text = "─"
        end 
    end)

    -- Main content
    local ContentContainer = Utility:Create("Frame", {
        Name = "Content", 
        Parent = MainFrame, 
        BackgroundTransparency = 1, 
        Position = UDim2.new(0, 0, 0, 50), 
        Size = UDim2.new(1, 0, 1, -50), 
        ClipsDescendants = true
    })
    
    -- Navigation with modern design
    local NavWidth = 160 
    local NavContainer = Utility:Create("ScrollingFrame", {
        Name = "Navigation", 
        Parent = ContentContainer, 
        BackgroundColor3 = Netro65UI.Theme.Secondary,
        BackgroundTransparency = 0.3,
        Size = UDim2.new(0, NavWidth, 1, -80), 
        Position = UDim2.new(0, 0, 0, 10), 
        ScrollBarThickness = 0, 
        CanvasSize = UDim2.new(0,0,0,0),
        BorderSizePixel = 0
    }, {
        Utility:Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
        Utility:Create("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder, 
            Padding = UDim.new(0, 8)
        }), 
        Utility:Create("UIPadding", {
            PaddingLeft = UDim.new(0, 10), 
            PaddingTop = UDim.new(0, 10),
            PaddingRight = UDim.new(0, 10)
        })
    })
    
    -- Profile Card with enhanced features
    local ProfileCard = Utility:Create("Frame", {
        Parent = ContentContainer, 
        BackgroundColor3 = Netro65UI.Theme.Secondary, 
        Size = UDim2.new(0, NavWidth - 20, 0, 60), 
        Position = UDim2.new(0, 10, 1, -70), 
        BorderSizePixel = 0, 
        BackgroundTransparency = 0.3
    }, {
        Utility:Create("UICorner", {CornerRadius = UDim.new(0, 8)}), 
        Utility:Create("UIStroke", {Color = Netro65UI.Theme.Outline, Thickness = 1}), 
        Utility:Create("ImageLabel", {
            Image = Players:GetUserThumbnailAsync(
                LocalPlayer.UserId, 
                Enum.ThumbnailType.HeadShot, 
                Enum.ThumbnailSize.Size60x60
            ), 
            Size = UDim2.new(0, 40, 0, 40), 
            Position = UDim2.new(0, 10, 0.5, -20), 
            BackgroundColor3 = Netro65UI.Theme.Main
        }, {
            Utility:Create("UICorner", {CornerRadius = UDim.new(1, 0)}),
            Utility:Create("UIStroke", {Color = Netro65UI.Theme.Accent, Thickness = 2})
        }), 
        Utility:Create("TextLabel", {
            Text = LocalPlayer.DisplayName, 
            Font = Netro65UI.Theme.FontBold, 
            TextSize = 13, 
            TextColor3 = Netro65UI.Theme.Text, 
            BackgroundTransparency = 1, 
            Position = UDim2.new(0, 60, 0, 10), 
            Size = UDim2.new(1, -65, 0, 18), 
            TextXAlignment = Enum.TextXAlignment.Left, 
            TextTruncate = Enum.TextTruncate.AtEnd
        }), 
        Utility:Create("TextLabel", {
            Text = Netro65UI.IsVIP and Netro65UI.Languages[Netro65UI.Language].VIPUser or Netro65UI.Languages[Netro65UI.Language].FreeUser, 
            Font = Netro65UI.Theme.FontMain, 
            TextSize = 11, 
            TextColor3 = Netro65UI.IsVIP and Color3.fromRGB(255, 215, 0) or Netro65UI.Theme.Accent, 
            BackgroundTransparency = 1, 
            Position = UDim2.new(0, 60, 0, 30), 
            Size = UDim2.new(1, -65, 0, 15), 
            TextXAlignment = Enum.TextXAlignment.Left
        })
    })
    
    -- Pages container
    local Pages = Utility:Create("Frame", {
        Name = "Pages", 
        Parent = ContentContainer, 
        BackgroundTransparency = 1, 
        Position = UDim2.new(0, NavWidth + 10, 0, 0), 
        Size = UDim2.new(1, -(NavWidth + 10), 1, 0), 
        ClipsDescendants = true
    })
    
    -- Search functionality
    local SearchableElements = {}
    SearchInput:GetPropertyChangedSignal("Text"):Connect(function() 
        local query = SearchInput.Text:lower() 
        for _, item in pairs(SearchableElements) do 
            if item.Element then 
                item.Element.Visible = (query == "" or string.find(item.Keywords:lower(), query)) 
            end 
        end 
    end)

    -- Tab management
    local tabs = {}
    
    function WindowObj:AddTab(name, icon)
        local Tab = {}
        local TabBtn = Utility:Create("TextButton", {
            Parent = NavContainer, 
            Text = (icon or "📁") .. " " .. name, 
            Font = Netro65UI.Theme.FontMain, 
            TextSize = 13, 
            TextColor3 = Netro65UI.Theme.TextDark, 
            BackgroundColor3 = Netro65UI.Theme.Main, 
            BackgroundTransparency = 0.8, 
            Size = UDim2.new(1, 0, 0, 40), 
            AutoButtonColor = false, 
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd
        }, {
            Utility:Create("UIPadding", {PaddingLeft = UDim.new(0, 15)}), 
            Utility:Create("UICorner", {CornerRadius = UDim.new(0, 8)}), 
            Utility:Create("UIStroke", {
                Color = Netro65UI.Theme.Accent,
                Thickness = 0,
                Transparency = 1
            }),
            Utility:Create("Frame", {
                Name = "ActiveIndicator", 
                BackgroundColor3 = Netro65UI.Theme.Accent, 
                Size = UDim2.new(0, 4, 0, 20), 
                Position = UDim2.new(0, 5, 0.5, -10), 
                Visible = false
            }, {
                Utility:Create("UICorner", {CornerRadius = UDim.new(0, 2)})
            })
        })
        
        table.insert(Netro65UI.ThemeObjects, {
            Instance = TabBtn.ActiveIndicator, 
            Type = "Accent"
        })
        
        local Page = Utility:Create("ScrollingFrame", {
            Name = name.."_Page", 
            Parent = Pages, 
            BackgroundTransparency = 1, 
            Size = UDim2.new(1, 0, 1, 0), 
            Visible = false, 
            ScrollBarThickness = 4, 
            ScrollBarImageColor3 = Netro65UI.Theme.Accent, 
            CanvasSize = UDim2.new(0,0,0,0),
            BorderSizePixel = 0
        }, {
            Utility:Create("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder, 
                Padding = UDim.new(0, 15), 
                HorizontalAlignment = Enum.HorizontalAlignment.Center
            }), 
            Utility:Create("UIPadding", {
                PaddingTop = UDim.new(0, 15), 
                PaddingBottom = UDim.new(0, 15), 
                PaddingRight = UDim.new(0, 5)
            })
        })
        
        table.insert(Netro65UI.ThemeObjects, {
            Instance = Page, 
            Type = "Accent", 
            Property = "ScrollBarImageColor3"
        })
        
        Page.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() 
            Page.CanvasSize = UDim2.new(
                0, 0, 
                0, Page.UIListLayout.AbsoluteContentSize.Y + 30
            ) 
        end)
        
        -- Tab click event
        TabBtn.MouseButton1Click:Connect(function() 
            if TabBtn:FindFirstChild("LockOverlay") then return end
            for _, t in pairs(tabs) do 
                t.Btn.ActiveIndicator.Visible = false 
                Utility:Tween(t.Btn.UIStroke, {0.2}, {
                    Thickness = 0,
                    Transparency = 1
                }) 
                Utility:Tween(t.Btn, {0.2}, {
                    BackgroundTransparency = 0.8, 
                    TextColor3 = Netro65UI.Theme.TextDark
                }) 
                t.Page.Visible = false 
            end 
            TabBtn.ActiveIndicator.Visible = true 
            Utility:Tween(TabBtn.UIStroke, {0.2}, {
                Thickness = 2,
                Transparency = 0
            })
            Utility:Tween(TabBtn, {0.2}, {
                BackgroundTransparency = 0.5, 
                TextColor3 = Netro65UI.Theme.Text
            }) 
            Page.Visible = true 
        end)
        
        -- First tab active
        if #tabs == 0 then 
            TabBtn.ActiveIndicator.Visible = true 
            TabBtn.UIStroke.Thickness = 2
            TabBtn.UIStroke.Transparency = 0
            TabBtn.BackgroundTransparency = 0.5 
            TabBtn.TextColor3 = Netro65UI.Theme.Text 
            Page.Visible = true 
        end
        
        table.insert(tabs, {Btn = TabBtn, Page = Page})

        -- Tab methods
        function Tab:Lock(text, reason) 
            Utility:LockElement(TabBtn, text, reason) 
        end
        
        function Tab:Unlock() 
            Utility:UnlockElement(TabBtn) 
        end

        -- Section creation
        function Tab:AddSection(sectionName, icon)
            local Section = {}
            local SectionFrame = Utility:Create("Frame", {
                Parent = Page, 
                BackgroundColor3 = Netro65UI.Theme.Secondary, 
                Size = UDim2.new(0.96, 0, 0, 0), 
                BorderSizePixel = 0, 
                BackgroundTransparency = 0.3
            }, {
                Utility:Create("UICorner", {CornerRadius = UDim.new(0, 12)}), 
                Utility:Create("UIStroke", {Color = Netro65UI.Theme.Outline, Thickness = 1}), 
                Utility:Create("TextLabel", {
                    Text = (icon or "📦") .. " " .. sectionName, 
                    Font = Netro65UI.Theme.FontBold, 
                    TextSize = 14, 
                    TextColor3 = Netro65UI.Theme.Accent, 
                    BackgroundTransparency = 1, 
                    Size = UDim2.new(1, -20, 0, 35), 
                    Position = UDim2.new(0, 15, 0, 0), 
                    TextXAlignment = Enum.TextXAlignment.Left
                }), 
                Utility:Create("Frame", {
                    Name = "Container", 
                    BackgroundTransparency = 1, 
                    Position = UDim2.new(0, 0, 0, 35), 
                    Size = UDim2.new(1, 0, 0, 0)
                }, {
                    Utility:Create("UIListLayout", {
                        SortOrder = Enum.SortOrder.LayoutOrder, 
                        Padding = UDim.new(0, 10), 
                        HorizontalAlignment = Enum.HorizontalAlignment.Center
                    }), 
                    Utility:Create("UIPadding", {
                        PaddingTop = UDim.new(0, 10),
                        PaddingBottom = UDim.new(0, 15),
                        PaddingLeft = UDim.new(0, 15),
                        PaddingRight = UDim.new(0, 15)
                    })
                })
            })
            
            table.insert(Netro65UI.ThemeObjects, {
                Instance = SectionFrame.TextLabel, 
                Type = "Accent", 
                Property = "TextColor3"
            })
            
            local ItemContainer = SectionFrame.Container
            ItemContainer.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() 
                SectionFrame.Size = UDim2.new(
                    0.96, 0, 
                    0, ItemContainer.UIListLayout.AbsoluteContentSize.Y + 50
                ) 
            end)

            -- Enhanced Button
            function Section:AddButton(bProps)
                local btnObj = {}
                local btnText = bProps.Name or "Button"
                local callback = bProps.Callback or function() end
                local icon = bProps.Icon or "▶️"
                
                local Button = Utility:Create("TextButton", {
                    Parent = ItemContainer, 
                    Text = icon .. " " .. btnText, 
                    Font = Netro65UI.Theme.FontMain, 
                    TextSize = 13, 
                    TextColor3 = Netro65UI.Theme.Text, 
                    BackgroundColor3 = Netro65UI.Theme.Main, 
                    Size = UDim2.new(1, 0, 0, 38),
                    AutoButtonColor = false, 
                    BorderSizePixel = 0
                }, {
                    Utility:Create("UICorner", {CornerRadius = UDim.new(0, 8)}), 
                    Utility:Create("UIStroke", {Color = Netro65UI.Theme.Outline, Thickness = 1})
                })
                
                table.insert(Netro65UI.ThemeObjects, {
                    Instance = Button, 
                    Type = "Main"
                })
                
                if bProps.Info then 
                    Utility:AddToolTip(Button, bProps.Info) 
                end 
                
                table.insert(SearchableElements, {
                    Element = Button, 
                    Keywords = btnText
                })
                
                -- Hover effects
                Button.MouseEnter:Connect(function() 
                    Utility:Tween(Button, {0.2}, {
                        BackgroundColor3 = Netro65UI.Theme.Hover,
                        TextColor3 = Netro65UI.Theme.Accent
                    }) 
                    Utility:Tween(Button.UIStroke, {0.2}, {
                        Color = Netro65UI.Theme.Accent
                    })
                end)
                
                Button.MouseLeave:Connect(function() 
                    Utility:Tween(Button, {0.2}, {
                        BackgroundColor3 = Netro65UI.Theme.Main,
                        TextColor3 = Netro65UI.Theme.Text
                    }) 
                    Utility:Tween(Button.UIStroke, {0.2}, {
                        Color = Netro65UI.Theme.Outline
                    })
                end)
                
                -- Click event
                Button.MouseButton1Click:Connect(function() 
                    if Button:FindFirstChild("LockOverlay") then return end
                    Utility:Ripple(Button) 
                    callback() 
                end)
                
                -- Button methods
                function btnObj:Lock(text, reason) 
                    Utility:LockElement(Button, text, reason) 
                end
                
                function btnObj:Unlock() 
                    Utility:UnlockElement(Button) 
                end
                
                return btnObj
            end

            -- Enhanced Toggle
            function Section:AddToggle(tProps)
                local togObj = {}
                local tName = tProps.Name or "Toggle"
                local state = tProps.Default or false 
                local flag = tProps.Flag
                local callback = tProps.Callback or function() end
                local icon = tProps.Icon or "🔘"
                
                if flag and Netro65UI.Flags[flag] ~= nil then 
                    state = Netro65UI.Flags[flag] 
                end
                
                local ToggleFrame = Utility:Create("Frame", {
                    Parent = ItemContainer, 
                    BackgroundTransparency = 1, 
                    Size = UDim2.new(1, 0, 0, 38)
                })
                
                Utility:Create("TextLabel", {
                    Parent = ToggleFrame, 
                    Text = icon .. " " .. tName, 
                    Font = Netro65UI.Theme.FontMain, 
                    TextSize = 13, 
                    TextColor3 = Netro65UI.Theme.Text, 
                    BackgroundTransparency = 1, 
                    Size = UDim2.new(1, -60, 1, 0), 
                    Position = UDim2.new(0, 0, 0, 0),
                    TextXAlignment = Enum.TextXAlignment.Left, 
                    TextTruncate = Enum.TextTruncate.AtEnd
                })
                
                local Switch = Utility:Create("TextButton", {
                    Parent = ToggleFrame, 
                    Text = "", 
                    BackgroundColor3 = state and Netro65UI.Theme.Accent or Netro65UI.Theme.Main, 
                    Size = UDim2.new(0, 50, 0, 25), 
                    Position = UDim2.new(1, -55, 0.5, -12.5), 
                    AutoButtonColor = false
                }, {
                    Utility:Create("UICorner", {CornerRadius = UDim.new(1, 0)}), 
                    Utility:Create("UIStroke", {Color = Netro65UI.Theme.Outline, Thickness = 1})
                })
                
                local Knob = Utility:Create("Frame", {
                    Parent = Switch, 
                    BackgroundColor3 = Color3.new(1,1,1), 
                    Size = UDim2.new(0, 21, 0, 21), 
                    Position = state and UDim2.new(1, -23, 0.5, -10.5) or UDim2.new(0, 2, 0.5, -10.5)
                }, {
                    Utility:Create("UICorner", {CornerRadius = UDim.new(1, 0)})
                })
                
                table.insert(SearchableElements, {
                    Element = ToggleFrame, 
                    Keywords = tName
                })
                
                local function Update(val) 
                    state = val 
                    Utility:Tween(Knob, {0.2}, {
                        Position = state and UDim2.new(1, -23, 0.5, -10.5) or UDim2.new(0, 2, 0.5, -10.5)
                    }) 
                    Utility:Tween(Switch, {0.2}, {
                        BackgroundColor3 = state and Netro65UI.Theme.Accent or Netro65UI.Theme.Main
                    }) 
                    if flag then 
                        Netro65UI.Flags[flag] = state 
                    end 
                    callback(state) 
                end
                
                Switch.MouseButton1Click:Connect(function() 
                    if ToggleFrame:FindFirstChild("LockOverlay") then return end
                    Update(not state) 
                end) 
                
                if flag then 
                    Netro65UI.Flags[flag] = state 
                    Netro65UI.Setters[flag] = Update
                end 
                
                Update(state)

                function togObj:Lock(text, reason) 
                    Utility:LockElement(ToggleFrame, text, reason) 
                end
                
                function togObj:Unlock() 
                    Utility:UnlockElement(ToggleFrame) 
                end
                
                return togObj
            end

            -- Enhanced Slider
            function Section:AddSlider(sProps)
                local sldObj = {}
                local sName = sProps.Name or "Slider"
                local min, max = sProps.Min or 0, sProps.Max or 100
                local default = sProps.Default or min
                local flag = sProps.Flag
                local callback = sProps.Callback or function() end
                local value = default
                local suffix = sProps.Suffix or ""
                local icon = sProps.Icon or "📏"
                
                if flag and Netro65UI.Flags[flag] ~= nil then 
                    value = Netro65UI.Flags[flag] 
                end
                
                local SliderFrame = Utility:Create("Frame", {
                    Parent = ItemContainer, 
                    BackgroundTransparency = 1, 
                    Size = UDim2.new(1, 0, 0, 55)
                })
                
                Utility:Create("TextLabel", {
                    Parent = SliderFrame, 
                    Text = icon .. " " .. sName, 
                    Font = Netro65UI.Theme.FontMain, 
                    TextSize = 13, 
                    TextColor3 = Netro65UI.Theme.Text, 
                    BackgroundTransparency = 1, 
                    Size = UDim2.new(1, -60, 0, 20), 
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextTruncate = Enum.TextTruncate.AtEnd
                })
                
                local ValueBox = Utility:Create("TextBox", {
                    Parent = SliderFrame, 
                    Text = tostring(value) .. suffix, 
                    Font = Netro65UI.Theme.FontBold, 
                    TextSize = 13, 
                    TextColor3 = Netro65UI.Theme.Accent, 
                    BackgroundTransparency = 1, 
                    Size = UDim2.new(0, 50, 0, 20), 
                    Position = UDim2.new(1, -50, 0, 0), 
                    TextXAlignment = Enum.TextXAlignment.Right, 
                    ClearTextOnFocus = false
                })
                
                table.insert(Netro65UI.ThemeObjects, {
                    Instance = ValueBox, 
                    Type = "Accent", 
                    Property = "TextColor3"
                })
                
                local Track = Utility:Create("Frame", {
                    Parent = SliderFrame, 
                    BackgroundColor3 = Netro65UI.Theme.Main, 
                    Size = UDim2.new(1, 0, 0, 8), 
                    Position = UDim2.new(0, 0, 0, 35)
                }, {
                    Utility:Create("UICorner", {CornerRadius = UDim.new(1, 0)}), 
                    Utility:Create("UIStroke", {Color = Netro65UI.Theme.Outline, Thickness = 1})
                })
                
                table.insert(Netro65UI.ThemeObjects, {
                    Instance = Track, 
                    Type = "Main"
                })
                
                local Fill = Utility:Create("Frame", {
                    Parent = Track, 
                    BackgroundColor3 = Netro65UI.Theme.Accent, 
                    Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
                }, {
                    Utility:Create("UICorner", {CornerRadius = UDim.new(1, 0)}),
                    Utility:Create("UIGradient", {
                        Color = Netro65UI.Theme.Gradient.Color,
                        Rotation = Netro65UI.Theme.Gradient.Rotation
                    })
                })
                
                table.insert(Netro65UI.ThemeObjects, {
                    Instance = Fill, 
                    Type = "Accent"
                })
                
                local Hitbox = Utility:Create("TextButton", {
                    Parent = SliderFrame, 
                    BackgroundTransparency = 1, 
                    Text = "", 
                    Size = UDim2.new(1, 0, 0, 20), 
                    Position = UDim2.new(0, 0, 0, 30), 
                    ZIndex = 5
                })
                
                table.insert(SearchableElements, {
                    Element = SliderFrame, 
                    Keywords = sName
                })
                
                local function UpdateSlider(inputVal)
                    value = math.clamp(inputVal, min, max)
                    ValueBox.Text = tostring(value) .. suffix
                    Utility:Tween(Fill, {0.1}, {
                        Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
                    })
                    if flag then 
                        Netro65UI.Flags[flag] = value 
                    end 
                    callback(value)
                end

                local isDragging = false
                Hitbox.InputBegan:Connect(function(input)
                    if SliderFrame:FindFirstChild("LockOverlay") then return end
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        isDragging = true
                        local mousePos = UserInputService:GetMouseLocation()
                        local relativePos = mousePos.X - Track.AbsolutePosition.X
                        local percent = math.clamp(relativePos / Track.AbsoluteSize.X, 0, 1)
                        UpdateSlider(math.floor(min + ((max - min) * percent)))
                    end
                end)
                
                Hitbox.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        isDragging = false
                    end
                end)
                
                UserInputService.InputChanged:Connect(function(input)
                    if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        local mousePos = UserInputService:GetMouseLocation()
                        local relativePos = mousePos.X - Track.AbsolutePosition.X
                        local percent = math.clamp(relativePos / Track.AbsoluteSize.X, 0, 1)
                        UpdateSlider(math.floor(min + ((max - min) * percent)))
                    end
                end)

                ValueBox.FocusLost:Connect(function() 
                    local text = ValueBox.Text:gsub(suffix, "")
                    local num = tonumber(text) 
                    if num then 
                        UpdateSlider(num) 
                    end 
                    ValueBox.Text = tostring(value) .. suffix
                end)
                
                if flag then 
                    Netro65UI.Flags[flag] = value 
                    Netro65UI.Setters[flag] = UpdateSlider
                end 
                
                UpdateSlider(value)

                function sldObj:Lock(text, reason) 
                    Utility:LockElement(SliderFrame, text, reason) 
                end
                
                function sldObj:Unlock() 
                    Utility:UnlockElement(SliderFrame) 
                end
                
                return sldObj
            end

            -- Enhanced Dropdown
            function Section:AddDropdown(dProps)
                local dName = dProps.Name or "Dropdown"
                local items = dProps.Items or {}
                local default = dProps.Default or items[1]
                local flag = dProps.Flag
                local callback = dProps.Callback or function() end
                local isOpen = false
                local icon = dProps.Icon or "📁"

                if flag and Netro65UI.Flags[flag] ~= nil then 
                    default = Netro65UI.Flags[flag] 
                end

                local DropdownFrame = Utility:Create("Frame", {
                    Parent = ItemContainer, 
                    BackgroundTransparency = 1, 
                    Size = UDim2.new(1, 0, 0, 55), 
                    ClipsDescendants = true
                })
                
                table.insert(SearchableElements, {
                    Element = DropdownFrame, 
                    Keywords = dName
                })
                
                local HeaderBtn = Utility:Create("TextButton", {
                    Parent = DropdownFrame, 
                    BackgroundColor3 = Netro65UI.Theme.Main, 
                    Size = UDim2.new(1, 0, 0, 38), 
                    Text = "", 
                    AutoButtonColor = false
                }, {
                    Utility:Create("UICorner", {CornerRadius = UDim.new(0, 8)}), 
                    Utility:Create("UIStroke", {Color = Netro65UI.Theme.Outline, Thickness = 1}),
                    Utility:Create("TextLabel", {
                        Text = icon .. " " .. dName, 
                        Font = Netro65UI.Theme.FontMain, 
                        TextSize = 13, 
                        TextColor3 = Netro65UI.Theme.Text, 
                        BackgroundTransparency = 1, 
                        Size = UDim2.new(0.7, 0, 1, 0), 
                        Position = UDim2.new(0, 10, 0, 0), 
                        TextXAlignment = Enum.TextXAlignment.Left
                    }),
                    Utility:Create("TextLabel", {
                        Name = "CurrentVal", 
                        Text = tostring(default), 
                        Font = Netro65UI.Theme.FontBold, 
                        TextSize = 13, 
                        TextColor3 = Netro65UI.Theme.Accent, 
                        BackgroundTransparency = 1, 
                        Size = UDim2.new(0.25, 0, 1, 0), 
                        Position = UDim2.new(0.75, -35, 0, 0), 
                        TextXAlignment = Enum.TextXAlignment.Right
                    }),
                    Utility:Create("ImageLabel", {
                        Image = "rbxassetid://6031090990", 
                        BackgroundTransparency = 1, 
                        Size = UDim2.new(0, 20, 0, 20), 
                        Position = UDim2.new(1, -25, 0.5, -10), 
                        ImageColor3 = Netro65UI.Theme.TextDark
                    })
                })
                
                table.insert(Netro65UI.ThemeObjects, {
                    Instance = HeaderBtn, 
                    Type = "Main"
                })
                
                table.insert(Netro65UI.ThemeObjects, {
                    Instance = HeaderBtn.CurrentVal, 
                    Type = "Accent", 
                    Property = "TextColor3"
                })

                local ListFrame = Utility:Create("ScrollingFrame", {
                    Parent = DropdownFrame, 
                    BackgroundColor3 = Netro65UI.Theme.Secondary, 
                    Size = UDim2.new(1, 0, 0, 0), 
                    Position = UDim2.new(0, 0, 0, 43), 
                    CanvasSize = UDim2.new(0,0,0,0), 
                    ScrollBarThickness = 3, 
                    ScrollBarImageColor3 = Netro65UI.Theme.Accent,
                    BorderSizePixel = 0,
                    BackgroundTransparency = 0.3
                }, {
                    Utility:Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
                    Utility:Create("UIListLayout", {
                        SortOrder = Enum.SortOrder.LayoutOrder, 
                        Padding = UDim.new(0, 5)
                    }),
                    Utility:Create("UIPadding", {
                        PaddingTop = UDim.new(0, 5), 
                        PaddingBottom = UDim.new(0, 5),
                        PaddingLeft = UDim.new(0, 5),
                        PaddingRight = UDim.new(0, 5)
                    })
                })
                
                table.insert(Netro65UI.ThemeObjects, {
                    Instance = ListFrame, 
                    Type = "Accent", 
                    Property = "ScrollBarImageColor3"
                })

                local function RefreshList(filter)
                    for _, c in pairs(ListFrame:GetChildren()) do 
                        if c:IsA("TextButton") then 
                            c:Destroy() 
                        end 
                    end
                    
                    for _, item in pairs(items) do
                        if not filter or string.find(tostring(item):lower(), filter:lower()) then
                            local ItemBtn = Utility:Create("TextButton", {
                                Parent = ListFrame, 
                                Text = tostring(item), 
                                Size = UDim2.new(1, 0, 0, 30),
                                BackgroundColor3 = Netro65UI.Theme.Main,
                                BackgroundTransparency = 0.7,
                                TextColor3 = Netro65UI.Theme.Text, 
                                Font = Netro65UI.Theme.FontMain, 
                                TextSize = 12,
                                AutoButtonColor = false
                            }, {
                                Utility:Create("UICorner", {CornerRadius = UDim.new(0, 6)}),
                                Utility:Create("UIStroke", {Color = Netro65UI.Theme.Outline, Thickness = 1})
                            })
                            
                            ItemBtn.MouseEnter:Connect(function()
                                Utility:Tween(ItemBtn, {0.2}, {
                                    BackgroundTransparency = 0.5,
                                    TextColor3 = Netro65UI.Theme.Accent
                                })
                            end)
                            
                            ItemBtn.MouseLeave:Connect(function()
                                Utility:Tween(ItemBtn, {0.2}, {
                                    BackgroundTransparency = 0.7,
                                    TextColor3 = Netro65UI.Theme.Text
                                })
                            end)
                            
                            ItemBtn.MouseButton1Click:Connect(function()
                                HeaderBtn.CurrentVal.Text = tostring(item)
                                if flag then 
                                    Netro65UI.Flags[flag] = item 
                                end
                                callback(item)
                                isOpen = false
                                Utility:Tween(DropdownFrame, {0.3}, {
                                    Size = UDim2.new(1, 0, 0, 55)
                                })
                                Utility:Tween(ListFrame, {0.3}, {
                                    Size = UDim2.new(1, 0, 0, 0)
                                })
                                Utility:Tween(HeaderBtn.ImageLabel, {0.3}, {Rotation = 0})
                            end)
                        end
                    end
                    
                    ListFrame.CanvasSize = UDim2.new(
                        0, 0, 
                        0, ListFrame.UIListLayout.AbsoluteContentSize.Y + 10
                    )
                end
                
                RefreshList()

                HeaderBtn.MouseButton1Click:Connect(function()
                    isOpen = not isOpen
                    local listHeight = math.min(#items * 35 + 10, 200)
                    Utility:Tween(DropdownFrame, {0.3}, {
                        Size = isOpen and UDim2.new(1, 0, 0, 43 + listHeight) or UDim2.new(1, 0, 0, 55)
                    })
                    Utility:Tween(ListFrame, {0.3}, {
                        Size = isOpen and UDim2.new(1, 0, 0, listHeight) or UDim2.new(1, 0, 0, 0)
                    })
                    Utility:Tween(HeaderBtn.ImageLabel, {0.3}, {
                        Rotation = isOpen and 180 or 0
                    })
                end)

                if flag then 
                    Netro65UI.Flags[flag] = default
                    Netro65UI.Setters[flag] = function(v) 
                        HeaderBtn.CurrentVal.Text = v
                        callback(v) 
                    end 
                end
                
                return {
                    Refresh = function(newItems)
                        items = newItems or items
                        RefreshList()
                    end,
                    AddItem = function(item)
                        table.insert(items, item)
                        RefreshList()
                    end,
                    RemoveItem = function(item)
                        for i, v in ipairs(items) do
                            if v == item then
                                table.remove(items, i)
                                break
                            end
                        end
                        RefreshList()
                    end
                }
            end

            -- Enhanced Textbox
            function Section:AddTextbox(tbProps)
                local tbName = tbProps.Name or "Textbox"
                local default = tbProps.Default or ""
                local placeholder = tbProps.Placeholder or "Input..."
                local numOnly = tbProps.NumberOnly or false
                local flag = tbProps.Flag
                local callback = tbProps.Callback or function() end
                local icon = tbProps.Icon or "📝"

                local TbFrame = Utility:Create("Frame", {
                    Parent = ItemContainer, 
                    BackgroundTransparency = 1, 
                    Size = UDim2.new(1, 0, 0, 45)
                })
                
                table.insert(SearchableElements, {
                    Element = TbFrame, 
                    Keywords = tbName
                })
                
                Utility:Create("TextLabel", {
                    Parent = TbFrame, 
                    Text = icon .. " " .. tbName, 
                    Font = Netro65UI.Theme.FontMain, 
                    TextSize = 13,
                    TextColor3 = Netro65UI.Theme.Text, 
                    BackgroundTransparency = 1, 
                    Size = UDim2.new(0.5, 0, 1, 0), 
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                local Box = Utility:Create("TextBox", {
                    Parent = TbFrame, 
                    Text = default, 
                    PlaceholderText = placeholder, 
                    Font = Netro65UI.Theme.FontMain,
                    TextSize = 13, 
                    TextColor3 = Netro65UI.Theme.Text, 
                    BackgroundColor3 = Netro65UI.Theme.Main,
                    Size = UDim2.new(0.45, 0, 0, 32), 
                    Position = UDim2.new(0.55, 0, 0.5, -16), 
                    ClearTextOnFocus = false
                }, {
                    Utility:Create("UICorner", {CornerRadius = UDim.new(0, 8)}), 
                    Utility:Create("UIStroke", {Color = Netro65UI.Theme.Outline, Thickness = 1})
                })
                
                table.insert(Netro65UI.ThemeObjects, {
                    Instance = Box, 
                    Type = "Main"
                })
                
                -- Focus effects
                Box.Focused:Connect(function()
                    Utility:Tween(Box.UIStroke, {0.2}, {
                        Color = Netro65UI.Theme.Accent,
                        Thickness = 2
                    })
                end)
                
                Box.FocusLost:Connect(function()
                    Utility:Tween(Box.UIStroke, {0.2}, {
                        Color = Netro65UI.Theme.Outline,
                        Thickness = 1
                    })
                    if numOnly then 
                        Box.Text = Box.Text:gsub("[^%d.-]", "") 
                    end
                    if flag then 
                        Netro65UI.Flags[flag] = Box.Text 
                    end
                    callback(Box.Text)
                end)

                if flag then 
                    Netro65UI.Flags[flag] = default 
                    Netro65UI.Setters[flag] = function(v) 
                        Box.Text = v 
                    end
                end
                
                return {
                    SetText = function(text)
                        Box.Text = text
                        if flag then Netro65UI.Flags[flag] = text end
                        callback(text)
                    end,
                    Clear = function()
                        Box.Text = ""
                        if flag then Netro65UI.Flags[flag] = "" end
                        callback("")
                    end
                }
            end

            -- Enhanced Keybind
            function Section:AddKeybind(kbProps)
                local kbName = kbProps.Name or "Keybind"
                local default = kbProps.Default or Enum.KeyCode.F
                local flag = kbProps.Flag
                local callback = kbProps.Callback or function() end
                local icon = kbProps.Icon or "⌨️"
                local currentKey = default

                local KbFrame = Utility:Create("Frame", {
                    Parent = ItemContainer,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 40)
                })
                
                table.insert(SearchableElements, {
                    Element = KbFrame,
                    Keywords = kbName
                })

                Utility:Create("TextLabel", {
                    Parent = KbFrame,
                    Text = icon .. " " .. kbName,
                    Font = Netro65UI.Theme.FontMain,
                    TextSize = 13,
                    TextColor3 = Netro65UI.Theme.Text,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0.6, 0, 1, 0),
                    Position = UDim2.new(0, 0, 0, 0),
                    TextXAlignment = Enum.TextXAlignment.Left
                })

                local KeyButton = Utility:Create("TextButton", {
                    Parent = KbFrame,
                    Text = tostring(default):gsub("Enum.KeyCode.", ""),
                    Font = Netro65UI.Theme.FontBold,
                    TextSize = 12,
                    TextColor3 = Netro65UI.Theme.Text,
                    BackgroundColor3 = Netro65UI.Theme.Main,
                    Size = UDim2.new(0, 80, 0, 28),
                    Position = UDim2.new(0.65, 0, 0.5, -14),
                    AutoButtonColor = false
                }, {
                    Utility:Create("UICorner", {CornerRadius = UDim.new(0, 6)}),
                    Utility:Create("UIStroke", {Color = Netro65UI.Theme.Outline, Thickness = 1})
                })

                local listening = false
                KeyButton.MouseButton1Click:Connect(function()
                    listening = not listening
                    if listening then
                        KeyButton.Text = "..."
                        KeyButton.BackgroundColor3 = Netro65UI.Theme.Accent
                        
                        local connection
                        connection = UserInputService.InputBegan:Connect(function(input)
                            if input.UserInputType == Enum.UserInputType.Keyboard then
                                currentKey = input.KeyCode
                                KeyButton.Text = tostring(currentKey):gsub("Enum.KeyCode.", "")
                                KeyButton.BackgroundColor3 = Netro65UI.Theme.Main
                                listening = false
                                
                                if flag then
                                    Netro65UI.Flags[flag] = currentKey
                                end
                                
                                callback(currentKey)
                                connection:Disconnect()
                            elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
                                currentKey = Enum.KeyCode.LeftControl
                                KeyButton.Text = "Mouse1"
                                KeyButton.BackgroundColor3 = Netro65UI.Theme.Main
                                listening = false
                                
                                if flag then
                                    Netro65UI.Flags[flag] = currentKey
                                end
                                
                                callback(currentKey)
                                connection:Disconnect()
                            end
                        end)
                    else
                        KeyButton.Text = tostring(currentKey):gsub("Enum.KeyCode.", "")
                        KeyButton.BackgroundColor3 = Netro65UI.Theme.Main
                    end
                end)

                if flag then
                    Netro65UI.Flags[flag] = currentKey
                    Netro65UI.Setters[flag] = function(key)
                        currentKey = key
                        KeyButton.Text = tostring(key):gsub("Enum.KeyCode.", "")
                        callback(key)
                    end
                end
                
                return {
                    SetKey = function(key)
                        currentKey = key
                        KeyButton.Text = tostring(key):gsub("Enum.KeyCode.", "")
                        if flag then Netro65UI.Flags[flag] = key end
                        callback(key)
                    end,
                    GetKey = function()
                        return currentKey
                    end
                }
            end

            -- Enhanced Color Picker
            function Section:AddColorPicker(cpProps)
                local cpName = cpProps.Name or "Color Picker"
                local default = cpProps.Default or Color3.fromRGB(255, 255, 255)
                local flag = cpProps.Flag
                local callback = cpProps.Callback or function() end
                local icon = cpProps.Icon or "🎨"
                local currentColor = default

                local CpFrame = Utility:Create("Frame", {
                    Parent = ItemContainer,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 40)
                })
                
                table.insert(SearchableElements, {
                    Element = CpFrame,
                    Keywords = cpName
                })

                Utility:Create("TextLabel", {
                    Parent = CpFrame,
                    Text = icon .. " " .. cpName,
                    Font = Netro65UI.Theme.FontMain,
                    TextSize = 13,
                    TextColor3 = Netro65UI.Theme.Text,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0.6, 0, 1, 0),
                    Position = UDim2.new(0, 0, 0, 0),
                    TextXAlignment = Enum.TextXAlignment.Left
                })

                local ColorButton = Utility:Create("TextButton", {
                    Parent = CpFrame,
                    Text = "",
                    BackgroundColor3 = currentColor,
                    Size = UDim2.new(0, 80, 0, 28),
                    Position = UDim2.new(0.65, 0, 0.5, -14),
                    AutoButtonColor = false
                }, {
                    Utility:Create("UICorner", {CornerRadius = UDim.new(0, 6)}),
                    Utility:Create("UIStroke", {Color = Netro65UI.Theme.Outline, Thickness = 1})
                })

                ColorButton.MouseButton1Click:Connect(function()
                    Utility:ColorPicker(currentColor, function(newColor)
                        currentColor = newColor
                        ColorButton.BackgroundColor3 = newColor
                        
                        if flag then
                            Netro65UI.Flags[flag] = newColor
                        end
                        
                        callback(newColor)
                    end)
                end)

                if flag then
                    Netro65UI.Flags[flag] = currentColor
                    Netro65UI.Setters[flag] = function(color)
                        currentColor = color
                        ColorButton.BackgroundColor3 = color
                        callback(color)
                    end
                end
                
                return {
                    SetColor = function(color)
                        currentColor = color
                        ColorButton.BackgroundColor3 = color
                        if flag then Netro65UI.Flags[flag] = color end
                        callback(color)
                    end,
                    GetColor = function()
                        return currentColor
                    end
                }
            end

            -- Label (for text display)
            function Section:AddLabel(text, icon)
                local LabelFrame = Utility:Create("Frame", {
                    Parent = ItemContainer,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 30)
                })
                
                Utility:Create("TextLabel", {
                    Parent = LabelFrame,
                    Text = (icon or "📄") .. " " .. text,
                    Font = Netro65UI.Theme.FontMain,
                    TextSize = 13,
                    TextColor3 = Netro65UI.Theme.TextDark,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextWrapped = true
                })
                
                return LabelFrame
            end

            -- Separator
            function Section:AddSeparator()
                local Separator = Utility:Create("Frame", {
                    Parent = ItemContainer,
                    BackgroundColor3 = Netro65UI.Theme.Outline,
                    BackgroundTransparency = 0.5,
                    Size = UDim2.new(1, 0, 0, 1),
                    BorderSizePixel = 0
                }, {
                    Utility:Create("UICorner", {CornerRadius = UDim.new(1, 0)})
                })
                
                return Separator
            end

            return Section
        end
        
        return Tab
    end

    --// AUTO-GENERATE SETTINGS TAB WITH ENHANCED FEATURES
    local SettingsTab = WindowObj:AddTab("⚙️ Settings")
    
    -- Configuration Section
    local ConfigSection = SettingsTab:AddSection("💾 Configuration")
    
    local ConfigName = ""
    local UniversalConfig = false

    ConfigSection:AddTextbox({
        Name = "Config Name", 
        Placeholder = "Type name here...", 
        Default = "my_config",
        Callback = function(v) 
            ConfigName = v 
        end
    })
    
    ConfigSection:AddToggle({
        Name = "Universal Config", 
        Default = false, 
        Callback = function(v) 
            UniversalConfig = v 
        end
    })
    
    ConfigSection:AddButton({
        Name = "💾 Save Config",
        Callback = function() 
            if ConfigName ~= "" then 
                Netro65UI:SaveConfig(ConfigName, UniversalConfig, true) 
            else 
                Netro65UI:Notify({
                    Title = "Error", 
                    Content = "Enter config name!", 
                    Type = "Error"
                }) 
            end 
        end
    })
    
    local loadDropdown = ConfigSection:AddDropdown({
        Name = "📂 Load Config", 
        Items = Netro65UI:GetConfigs(UniversalConfig), 
        Callback = function(v) 
            ConfigName = v
            Netro65UI:LoadConfig(v, UniversalConfig) 
        end
    })
    
    ConfigSection:AddButton({
        Name = "🔄 Refresh Configs",
        Callback = function()
            loadDropdown.Refresh(Netro65UI:GetConfigs(UniversalConfig))
        end
    })

    ConfigSection:AddButton({
        Name = "🗑️ Delete Config", 
        Callback = function() 
            if ConfigName ~= "" then 
                Netro65UI:DeleteConfig(ConfigName, UniversalConfig) 
            else 
                Netro65UI:Notify({
                    Title = "Error", 
                    Content = "Enter config name or select from load.", 
                    Type = "Error"
                }) 
            end 
        end
    })
    
    ConfigSection:AddToggle({
        Name = "⏱️ Auto-Save (60s)", 
        Default = false,
        Callback = function(v)
            Netro65UI:ToggleAutoSave(v, 60)
        end
    })
    
    -- Theme Section
    local ThemeSection = SettingsTab:AddSection("🎨 Theme Customization")
    local ThemesList = {}
    
    for name, _ in pairs(Netro65UI.Presets) do 
        table.insert(ThemesList, name) 
    end
    
    table.sort(ThemesList)
    
    local themeDropdown = ThemeSection:AddDropdown({
        Name = "🎭 Select Theme", 
        Items = ThemesList, 
        Default = "Default",
        Callback = function(v) 
            Netro65UI:SetTheme(v) 
        end
    })
    
    local rainbowToggle = ThemeSection:AddToggle({
        Name = "🌈 Rainbow Mode",
        Default = false,
        Callback = function(v)
            Netro65UI:ToggleRainbowMode(v, 1, "Standard")
        end
    })
    
    local rainbowMode = ThemeSection:AddDropdown({
        Name = "🌈 Rainbow Effect",
        Items = {"Standard", "Wave", "Pulse", "Random"},
        Default = "Standard",
        Callback = function(v)
            if Netro65UI.RainbowMode.Enabled then
                Netro65UI:ToggleRainbowMode(true, Netro65UI.RainbowMode.Speed, v)
            end
        end
    })
    
    ThemeSection:AddSlider({
        Name = "🌈 Rainbow Speed",
        Min = 0.1,
        Max = 5,
        Default = 1,
        Callback = function(v)
            if Netro65UI.RainbowMode.Enabled then
                Netro65UI:ToggleRainbowMode(true, v, Netro65UI.RainbowMode.Mode)
            end
        end
    })
    
    ThemeSection:AddColorPicker({
        Name = "🎨 Custom Accent Color",
        Default = Netro65UI.Theme.Accent,
        Callback = function(color)
            Netro65UI.Theme.Accent = color
            Netro65UI:SetTheme("Default")
        end
    })
    
    ThemeSection:AddToggle({
        Name = "✨ Gradient Effects",
        Default = Netro65UI.Theme.UseGradient,
        Callback = function(v)
            Netro65UI.Theme.UseGradient = v
            Netro65UI:SetTheme("Default")
        end
    })
    
    -- UI Settings Section
    local UISettings = SettingsTab:AddSection("🖥️ UI Settings")
    
    UISettings:AddToggle({
        Name = "🔮 Acrylic Blur",
        Default = true,
        Callback = function(v)
            Acrylic.Active = v
            if not v then
                Acrylic:Disable()
            else
                Acrylic:Enable()
            end
        end
    })
    
    UISettings:AddSlider({
        Name = "🔮 Blur Intensity",
        Min = 1,
        Max = 50,
        Default = 15,
        Callback = function(v)
            Acrylic.BlurSize = v
        end
    })
    
    UISettings:AddButton({
        Name = "💧 Toggle Watermark",
        Callback = function()
            if Watermark then
                Watermark.Visible = not Watermark.Visible
            end
        end
    })
    
    UISettings:AddButton({
        Name = "⌨️ Show Command Bar (F1)",
        Callback = function()
            Netro65UI:ShowCommandBar()
        end
    })
    
    -- Language Settings
    local LanguageSection = SettingsTab:AddSection("🌐 Language")
    
    LanguageSection:AddDropdown({
        Name = "🌍 Select Language",
        Items = {"English", "Indonesian", "Spanish"},
        Default = Netro65UI.Language,
        Callback = function(v)
            Netro65UI:SetLanguage(v)
        end
    })
    
    -- Keybinds Section
    local KeybindsSection = SettingsTab:AddSection("⌨️ Keybinds")
    
    -- Register default keybinds
    Netro65UI:CreateKeybind("ToggleUI", Enum.KeyCode.RightControl, function()
        MainFrame.Visible = not MainFrame.Visible
        Netro65UI:Notify({
            Title = "UI Toggled",
            Content = "UI is now " .. (MainFrame.Visible and "visible" or "hidden"),
            Type = "Info"
        })
    end)
    
    Netro65UI:CreateKeybind("CommandBar", Enum.KeyCode.F1, function()
        Netro65UI:ShowCommandBar()
    end)
    
    Netro65UI:CreateKeybind("Screenshot", Enum.KeyCode.F2, function()
        Netro65UI:Notify({
            Title = "Screenshot",
            Content = "Screenshot feature coming soon!",
            Type = "Info"
        })
    end, {"Ctrl"})
    
    KeybindsSection:AddKeybind({
        Name = "🖥️ Toggle UI",
        Default = Enum.KeyCode.RightControl,
        Flag = "ToggleUIKey",
        Callback = function(key)
            Netro65UI:UpdateKeybind("ToggleUI", key)
        end
    })
    
    KeybindsSection:AddKeybind({
        Name = "⌨️ Command Bar",
        Default = Enum.KeyCode.F1,
        Flag = "CommandBarKey",
        Callback = function(key)
            Netro65UI:UpdateKeybind("CommandBar", key)
        end
    })
    
    KeybindsSection:AddKeybind({
        Name = "📸 Screenshot",
        Default = Enum.KeyCode.F2,
        Flag = "ScreenshotKey",
        Callback = function(key)
            Netro65UI:UpdateKeybind("Screenshot", key, {"Ctrl"})
        end
    })
    
    -- Info Section
    local InfoSection = SettingsTab:AddSection("ℹ️ Information")
    
    InfoSection:AddButton({
        Name = "📊 Server Info Panel",
        Callback = function()
            Netro65UI:CreateServerInfoPanel()
        end
    })
    
    InfoSection:AddButton({
        Name = "🆕 Check for Updates",
        Callback = function()
            Netro65UI:Notify({
                Title = "Update Check",
                Content = "You're using the latest version!",
                Type = "Success"
            })
        end
    })
    
    InfoSection:AddLabel("NetroUI Version: " .. Netro65UI.Version)
    InfoSection:AddLabel("Player: " .. LocalPlayer.Name)
    InfoSection:AddLabel("Status: " .. (Netro65UI.IsVIP and "VIP User" or "Free User"))
    
    -- Setup keybinds
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        -- Toggle UI
        if input.KeyCode == Netro65UI.Keybinds["ToggleUI"] and Netro65UI.Keybinds["ToggleUI"].Key then
            MainFrame.Visible = not MainFrame.Visible
        end
        
        -- Command Bar
        if input.KeyCode == Netro65UI.Keybinds["CommandBar"] and Netro65UI.Keybinds["CommandBar"].Key then
            Netro65UI:ShowCommandBar()
        end
        
        -- Screenshot with Ctrl modifier
        if input.KeyCode == Netro65UI.Keybinds["Screenshot"] and Netro65UI.Keybinds["Screenshot"].Key then
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.RightControl) then
                Netro65UI:Notify({
                    Title = "Screenshot",
                    Content = "Screenshot feature coming soon!",
                    Type = "Info"
                })
            end
        end
    end)
    
    -- Register enhanced commands
    Netro65UI:RegisterCommand("clear", "Clear all notifications", function(args)
        for _, child in pairs(ScreenGui:GetChildren()) do
            if child.Name == "Notification" then
                child:Destroy()
            end
        end
        Netro65UI:Notify({
            Title = "Cleared",
            Content = "All notifications cleared",
            Type = "Success"
        })
    end)
    
    Netro65UI:RegisterCommand("theme", "Change theme", function(args)
        if args[1] and Netro65UI.Presets[args[1]] then
            Netro65UI:SetTheme(args[1])
            Netro65UI:Notify({
                Title = "Theme Changed",
                Content = "Theme set to: " .. args[1],
                Type = "Success"
            })
        else
            local themes = table.concat(ThemesList, ", ")
            Netro65UI:Notify({
                Title = "Available Themes",
                Content = themes,
                Duration = 5
            })
        end
    end)
    
    Netro65UI:RegisterCommand("rainbow", "Toggle rainbow mode", function(args)
        local mode = args[1] or "Standard"
        if table.find({"Standard", "Wave", "Pulse", "Random"}, mode) then
            local enabled = not Netro65UI.RainbowMode.Enabled
            Netro65UI:ToggleRainbowMode(enabled, 1, mode)
            Netro65UI:Notify({
                Title = "Rainbow Mode",
                Content = (enabled and "Enabled" or "Disabled") .. " (" .. mode .. ")",
                Type = "Success"
            })
        end
    end)
    
    Netro65UI:RegisterCommand("language", "Change language", function(args)
        if args[1] and Netro65UI.Languages[args[1]] then
            Netro65UI:SetLanguage(args[1])
            Netro65UI:Notify({
                Title = "Language Changed",
                Content = "Language set to: " .. args[1],
                Type = "Success"
            })
        end
    end)
    
    Netro65UI:RegisterCommand("save", "Save config", function(args)
        local name = args[1] or "quick_save"
        Netro65UI:SaveConfig(name, false, true)
    end)
    
    Netro65UI:RegisterCommand("load", "Load config", function(args)
        local name = args[1] or "quick_save"
        Netro65UI:LoadConfig(name, false)
    end)
    
    Netro65UI:RegisterCommand("serverinfo", "Show server info", function(args)
        Netro65UI:CreateServerInfoPanel()
    end)
    
    Netro65UI:RegisterCommand("watermark", "Toggle watermark", function(args)
        if Watermark then
            Watermark.Visible = not Watermark.Visible
            Netro65UI:Notify({
                Title = "Watermark",
                Content = Watermark.Visible and "Visible" or "Hidden",
                Type = "Success"
            })
        end
    end)
    
    Netro65UI:RegisterCommand("help", "Show all commands", function(args)
        local message = "Available Commands:\n"
        for _, cmd in pairs(Commands) do
            message = message .. string.format("/%s - %s\n", cmd.Name, cmd.Description)
        end
        Netro65UI:Notify({
            Title = "Command Help",
            Content = message,
            Duration = 10,
            Type = "Info"
        })
    end)

    return WindowObj
end

--// Enhanced System Loader
function Netro65UI:Load(config)
    local vipUrl = config.VIPUrl
    local useKeySystem = config.KeySystem
    local finalCallback = config.OnLoad or function() 
        Netro65UI:Notify({
            Title = "Welcome",
            Content = "NetroUI V5.0 Loaded Successfully!",
            Type = "Success",
            Duration = 3
        })
    end

    Netro65UI:Notify({
        Title = "System", 
        Content = "Checking access...", 
        Duration = 2,
        Type = "Info"
    })

    spawn(function()
        local isUserVIP = false
        if vipUrl then
            local success, res = pcall(function() 
                return game:HttpGet(vipUrl) 
            end)
            if success then
                local function CheckIDInList(content, userId)
                    local idString = tostring(userId)
                    local found = false
                    if content:match("^%s*%[") or content:match("^%s*{") then
                        local success, json = pcall(function() 
                            return HttpService:JSONDecode(content) 
                        end)
                        if success and type(json) == "table" then
                            for _, v in pairs(json) do
                                if tostring(v) == idString then 
                                    found = true 
                                    break 
                                end
                            end
                        end
                    else
                        for line in content:gmatch("[^%s,]+") do
                            if line == idString then 
                                found = true 
                                break 
                            end
                        end
                    end
                    return found
                end
                isUserVIP = CheckIDInList(res, LocalPlayer.UserId)
            end
        end
        Netro65UI.IsVIP = isUserVIP

        if isUserVIP then
            Netro65UI:Notify({
                Title = "VIP Access", 
                Content = "Welcome back, VIP User!", 
                Type = "Success", 
                Duration = 5
            })
            finalCallback()
        else
            if useKeySystem then
                Netro65UI:Notify({
                    Title = "Access Required", 
                    Content = "You are not VIP. Key System required.", 
                    Type = "Warning"
                })
                wait(1)
                Netro65UI:TriggerKeySystem(config.KeySettings, finalCallback)
            else
                finalCallback()
            end
        end
    end)
end

--// Enhanced Locking System
function Utility:LockElement(instance, text, reasonType)
    if instance:FindFirstChild("LockOverlay") then 
        instance.LockOverlay:Destroy() 
    end

    local lockColor = Color3.fromRGB(200, 200, 200)
    local icon = "🔒"
    
    if reasonType == "Error" then 
        lockColor = Netro65UI.Theme.Error
        icon = "❌"
    elseif reasonType == "VIP" then 
        lockColor = Color3.fromRGB(255, 215, 0)
        icon = "⭐"
    elseif reasonType == "Update" then 
        lockColor = Netro65UI.Theme.Accent
        icon = "🔄"
    elseif reasonType == "Premium" then
        lockColor = Color3.fromRGB(180, 160, 255)
        icon = "💎"
    end

    local Overlay = Utility:Create("Frame", {
        Name = "LockOverlay", 
        Parent = instance,
        BackgroundColor3 = Color3.fromRGB(10, 10, 10), 
        BackgroundTransparency = 0.1,
        Size = UDim2.new(1, 0, 1, 0), 
        ZIndex = 100, 
        Active = true
    }, {
        Utility:Create("UICorner", {CornerRadius = UDim.new(0, 6)}),
        Utility:Create("TextLabel", {
            Text = icon, 
            Font = Enum.Font.GothamBold,
            TextSize = 20,
            BackgroundTransparency = 1, 
            Size = UDim2.new(0, 30, 0, 30),
            Position = UDim2.new(0.5, -15, 0.5, -25), 
            TextColor3 = lockColor, 
            ZIndex = 101
        }),
        Utility:Create("TextLabel", {
            Text = text or "Locked", 
            Font = Netro65UI.Theme.FontBold, 
            TextSize = 10,
            TextColor3 = lockColor, 
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 20), 
            Position = UDim2.new(0, 0, 0.5, 5), 
            ZIndex = 101
        })
    })
end

function Utility:UnlockElement(instance)
    if instance:FindFirstChild("LockOverlay") then
        instance.LockOverlay:Destroy()
    end
end

--// Final initialization
Netro65UI:Notify({
    Title = "NetroUI V5.0",
    Content = "Enhanced UI Library Loaded Successfully!",
    Type = "Success",
    Duration = 3,
    Icon = "⚡"
})

return Netro65UI