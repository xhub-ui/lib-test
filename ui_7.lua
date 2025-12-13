--[[
    NetroUI - UI Library 
    Status: (v5.3.0 Revised)
    Updates: Compact Window, Hybrid Layout System (Normal/Side), Fixed Player Info
]]

local Netro65UI = {}
Netro65UI.Flags = {}
Netro65UI.Setters = {}
Netro65UI.ThemeObjects = {}
Netro65UI.Keybinds = {}
Netro65UI.ConfigFolder = "Netro65UI_Configs"
Netro65UI.CurrentConfigFile = "default.json"
Netro65UI.Version = "5.3.0" 
Netro65UI.IsVIP = false

--// Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local TextService = game:GetService("TextService")

--// Constants
local MOUSE = Players.LocalPlayer:GetMouse()
local LocalPlayer = Players.LocalPlayer

--// Advanced Theme System
Netro65UI.Theme = {
    Main        = Color3.fromRGB(20, 20, 20),
    Secondary   = Color3.fromRGB(28, 28, 28),
    Accent      = Color3.fromRGB(0, 140, 255),
    Outline     = Color3.fromRGB(50, 50, 50),
    Text        = Color3.fromRGB(240, 240, 240),
    TextDark    = Color3.fromRGB(160, 160, 160),
    Hover       = Color3.fromRGB(45, 45, 45),
    Success     = Color3.fromRGB(100, 255, 100),
    Warning     = Color3.fromRGB(255, 200, 60),
    Error       = Color3.fromRGB(255, 60, 60),
    Locked      = Color3.fromRGB(10, 10, 10),
    FontMain    = Enum.Font.GothamMedium,
    FontBold    = Enum.Font.GothamBold,
    FontCode    = Enum.Font.Code,
    FontBlack   = Enum.Font.GothamBlack
}

Netro65UI.Presets = {
    Default      = { Main = Color3.fromRGB(20, 20, 20), Accent = Color3.fromRGB(0, 140, 255) },
    PeachPuff    = { Main = Color3.fromRGB(40, 30, 30), Accent = Color3.fromRGB(255, 218, 185) },
    DarkBlue     = { Main = Color3.fromRGB(15, 15, 30), Accent = Color3.fromRGB(0, 0, 139) },
    Violet       = { Main = Color3.fromRGB(25, 20, 30), Accent = Color3.fromRGB(138, 43, 226) },
    MidnightBlue = { Main = Color3.fromRGB(10, 10, 25), Accent = Color3.fromRGB(25, 25, 112) },
    Honeydew     = { Main = Color3.fromRGB(20, 30, 20), Accent = Color3.fromRGB(144, 238, 144) },
    Volcano      = { Main = Color3.fromRGB(30, 15, 15), Accent = Color3.fromRGB(255, 69, 0) },
    Ocean        = { Main = Color3.fromRGB(10, 25, 30), Accent = Color3.fromRGB(0, 206, 209) },
    Cyberpunk    = { Main = Color3.fromRGB(10, 5, 20), Accent = Color3.fromRGB(255, 0, 255) },
    Matrix       = { Main = Color3.fromRGB(0, 20, 0), Accent = Color3.fromRGB(0, 255, 0) },
    Golden       = { Main = Color3.fromRGB(20, 15, 0), Accent = Color3.fromRGB(255, 215, 0) },
}

--// Rainbow Mode System
Netro65UI.RainbowMode = {
    Enabled = false,
    Speed = 1,
    Connection = nil,
    Hue = 0
}

function Netro65UI:ToggleRainbowMode(enabled, speed)
    Netro65UI.RainbowMode.Enabled = enabled
    Netro65UI.RainbowMode.Speed = speed or 1
    
    if Netro65UI.RainbowMode.Connection then
        Netro65UI.RainbowMode.Connection:Disconnect()
        Netro65UI.RainbowMode.Connection = nil
    end
    
    if enabled then
        Netro65UI.RainbowMode.Connection = RunService.Heartbeat:Connect(function(delta)
            Netro65UI.RainbowMode.Hue = (Netro65UI.RainbowMode.Hue + delta * (Netro65UI.RainbowMode.Speed * 0.1)) % 1
            local rainbowColor = Color3.fromHSV(Netro65UI.RainbowMode.Hue, 0.8, 1)
            
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
                    elseif obj.Property == "Color" then
                        obj.Instance.Color = rainbowColor
                    end
                end
            end
        end)
    end
end

function Netro65UI:SetTheme(presetName)
    local preset = Netro65UI.Presets[presetName] or Netro65UI.Presets.Default
    Netro65UI.Theme.Main = preset.Main
    Netro65UI.Theme.Accent = preset.Accent
    
    if Netro65UI.RainbowMode.Enabled then
        Netro65UI:ToggleRainbowMode(false)
    end
    
    for _, obj in pairs(Netro65UI.ThemeObjects) do
        if obj.Instance and obj.Instance.Parent then
            if obj.Type == "Main" then 
                obj.Instance.BackgroundColor3 = Netro65UI.Theme.Main 
            end
            if obj.Type == "Secondary" then 
                obj.Instance.BackgroundColor3 = Netro65UI.Theme.Secondary 
            end
            if obj.Type == "Accent" then 
                if obj.Property == "TextColor3" then 
                    obj.Instance.TextColor3 = Netro65UI.Theme.Accent 
                elseif obj.Property == "ImageColor3" then
                    obj.Instance.ImageColor3 = Netro65UI.Theme.Accent
                elseif obj.Property == "BackgroundColor3" then
                    obj.Instance.BackgroundColor3 = Netro65UI.Theme.Accent
                elseif obj.Property == "ScrollBarImageColor3" then
                    obj.Instance.ScrollBarImageColor3 = Netro65UI.Theme.Accent
                elseif obj.Property == "Color" then
                    obj.Instance.Color = Netro65UI.Theme.Accent
                end
            end
        end
    end
end

--// Enhanced Acrylic Module
local Acrylic = { 
    Active = true, 
    BlurSize = 15,
    Transparency = 0.95
}

function Acrylic:Enable()
    if not Acrylic.Active then return end
    local Effect = Lighting:FindFirstChild("NetroAcrylicBlur")
    if not Effect then
        Effect = Instance.new("BlurEffect")
        Effect.Name = "NetroAcrylicBlur"
        Effect.Size = 0
        Effect.Parent = Lighting
    end
    TweenService:Create(Effect, TweenInfo.new(0.5), {Size = Acrylic.BlurSize}):Play()
end

function Acrylic:Disable()
    local Effect = Lighting:FindFirstChild("NetroAcrylicBlur")
    if Effect then
        TweenService:Create(Effect, TweenInfo.new(0.5), {Size = 0}):Play()
        task.delay(0.5, function() 
            if Effect then Effect:Destroy() end
        end)
    end
end

--// Main UI Container
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Netro65UI_Revised"
if gethui then
    ScreenGui.Parent = gethui()
elseif syn and syn.protect_gui then
    syn.protect_gui(ScreenGui)
    ScreenGui.Parent = CoreGui
else
    ScreenGui.Parent = CoreGui
end
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true

--// Watermark System
local Watermark = nil
function Netro65UI:CreateWatermark(text)
    if Watermark then Watermark:Destroy() end
    
    Watermark = Instance.new("Frame")
    Watermark.Name = "Watermark"
    Watermark.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Watermark.BackgroundTransparency = 0.7
    Watermark.Size = UDim2.new(0, 200, 0, 30)
    Watermark.Position = UDim2.new(0, 10, 0, 10)
    Watermark.Parent = ScreenGui
    Watermark.Visible = true
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 6)
    UICorner.Parent = Watermark
    
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Netro65UI.Theme.Accent
    UIStroke.Thickness = 1
    UIStroke.Parent = Watermark
    table.insert(Netro65UI.ThemeObjects, {Instance = UIStroke, Type = "Accent", Property = "Color"})
    
    local Label = Instance.new("TextLabel")
    Label.Text = text or "NetroUI V5.0 | " .. LocalPlayer.Name
    Label.Font = Netro65UI.Theme.FontBold
    Label.TextSize = 12
    Label.TextColor3 = Color3.new(1, 1, 1)
    Label.BackgroundTransparency = 1
    Label.Size = UDim2.new(1, 0, 1, 0)
    Label.Parent = Watermark
    
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
            local delta = input.Position - dragStart
            TweenService:Create(frame, TweenInfo.new(0.1), {
                Position = UDim2.new(
                    startPos.X.Scale, startPos.X.Offset + delta.X, 
                    startPos.Y.Scale, startPos.Y.Offset + delta.Y
                )
            }):Play()
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
            Utility:Create("UICorner", {CornerRadius = UDim.new(0, 4)}),
            Utility:Create("UIStroke", {Color = Netro65UI.Theme.Accent, Thickness = 1}),
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

--// Locking System
function Utility:LockElement(instance, text, reasonType)
    local lockColor = Color3.fromRGB(200, 200, 200)
    if reasonType == "Error" then 
        lockColor = Netro65UI.Theme.Error 
    elseif reasonType == "VIP" then 
        lockColor = Color3.fromRGB(255, 215, 0) 
    elseif reasonType == "Update" then 
        lockColor = Netro65UI.Theme.Accent 
    end
    
    local existingOverlay = instance:FindFirstChild("LockOverlay")
    
    if existingOverlay then
        local lbl = existingOverlay:FindFirstChild("LockLabel")
        if lbl then 
            lbl.Text = text or "Locked"
            lbl.TextColor3 = lockColor 
        end
        return
    end

    local Overlay = Utility:Create("Frame", {
        Name = "LockOverlay", 
        Parent = instance,
        BackgroundColor3 = Color3.fromRGB(10, 10, 10), 
        BackgroundTransparency = 0.2,
        Size = UDim2.new(1, 0, 1, 0), 
        ZIndex = 100, 
        Active = true
    }, {
        Utility:Create("UICorner", {CornerRadius = UDim.new(0, 6)}),
        Utility:Create("TextLabel", {
            Name = "LockLabel",
            Text = text or "Locked", 
            Font = Netro65UI.Theme.FontBold, 
            TextSize = 12,
            TextColor3 = lockColor, 
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            Position = UDim2.new(0, 0, 0, 0), 
            TextXAlignment = Enum.TextXAlignment.Center,
            TextYAlignment = Enum.TextYAlignment.Center,
            ZIndex = 101
        })
    })
end

function Utility:UnlockElement(instance)
    local overlay = instance:FindFirstChild("LockOverlay")
    if overlay then
        overlay:Destroy()
    end
end

function Utility:CheckLock(instance)
    if instance:FindFirstChild("LockOverlay") then
        Netro65UI:Notify({
            Title = "Access Denied",
            Content = "This feature is locked.",
            Type = "Error",
            Duration = 3
        })
        return true
    end
    return false
end

--// Keybind System
function Netro65UI:CreateKeybind(name, defaultKey, callback)
    local keybind = {
        Name = name,
        Key = defaultKey,
        Callback = callback,
        Connection = nil
    }
    
    Netro65UI.Keybinds[name] = keybind
    
    keybind.Connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == keybind.Key then
            callback()
        end
    end)
    
    return keybind
end

function Netro65UI:UpdateKeybind(name, newKey)
    if Netro65UI.Keybinds[name] then
        Netro65UI.Keybinds[name].Key = newKey
    end
end

function Netro65UI:RemoveKeybind(name)
    if Netro65UI.Keybinds[name] and Netro65UI.Keybinds[name].Connection then
        Netro65UI.Keybinds[name].Connection:Disconnect()
        Netro65UI.Keybinds[name] = nil
    end
end

--// Color Picker System
function Utility:ColorPicker(defaultColor, callback)
    local colorPicker = {}
    local currentColor = defaultColor or Color3.new(1, 1, 1)
    
    local ColorFrame = Utility:Create("Frame", {
        Parent = ScreenGui,
        BackgroundColor3 = Netro65UI.Theme.Main,
        Size = UDim2.new(0, 250, 0, 300),
        Position = UDim2.new(0.5, -125, 0.5, -150),
        ZIndex = 2000
    }, {
        Utility:Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
        Utility:Create("UIStroke", {Color = Netro65UI.Theme.Accent, Thickness = 2}),
        Utility:Create("TextLabel", {
            Text = "Color Picker",
            Font = Netro65UI.Theme.FontBold,
            TextSize = 16,
            TextColor3 = Netro65UI.Theme.Text,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 30),
            Position = UDim2.new(0, 0, 0, 10)
        })
    })
    
    -- Color preview
    local Preview = Utility:Create("Frame", {
        Parent = ColorFrame,
        BackgroundColor3 = currentColor,
        Size = UDim2.new(0.8, 0, 0, 40),
        Position = UDim2.new(0.1, 0, 0, 50)
    }, {
        Utility:Create("UICorner", {CornerRadius = UDim.new(0, 6)}),
        Utility:Create("UIStroke", {Color = Netro65UI.Theme.Outline, Thickness = 1})
    })
    
    -- RGB sliders
    local sliders = {}
    local rgbLabels = {"R", "G", "B"}
    
    for i = 1, 3 do
        local yPos = 100 + (i-1) * 50
        local label = Utility:Create("TextLabel", {
            Parent = ColorFrame,
            Text = rgbLabels[i],
            Font = Netro65UI.Theme.FontBold,
            TextSize = 14,
            TextColor3 = Netro65UI.Theme.Text,
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 20, 0, 20),
            Position = UDim2.new(0.1, 0, 0, yPos),
            TextXAlignment = Enum.TextXAlignment.Left
        })
        
        local valueBox = Utility:Create("TextBox", {
            Parent = ColorFrame,
            Text = tostring(math.floor(currentColor[rgbLabels[i]:lower()] * 255)),
            Font = Netro65UI.Theme.FontMain,
            TextSize = 12,
            TextColor3 = Netro65UI.Theme.Text,
            BackgroundColor3 = Netro65UI.Theme.Secondary,
            Size = UDim2.new(0, 40, 0, 25),
            Position = UDim2.new(0.8, 0, 0, yPos - 3)
        }, {
            Utility:Create("UICorner", {CornerRadius = UDim.new(0, 4)})
        })
        
        local track = Utility:Create("Frame", {
            Parent = ColorFrame,
            BackgroundColor3 = Netro65UI.Theme.Secondary,
            Size = UDim2.new(0.6, 0, 0, 10),
            Position = UDim2.new(0.2, 0, 0, yPos + 5)
        }, {
            Utility:Create("UICorner", {CornerRadius = UDim.new(1, 0)})
        })
        
        local fill = Utility:Create("Frame", {
            Parent = track,
            BackgroundColor3 = i == 1 and Color3.new(1,0,0) or i == 2 and Color3.new(0,1,0) or Color3.new(0,0,1),
            Size = UDim2.new(currentColor[rgbLabels[i]:lower()], 0, 1, 0)
        }, {
            Utility:Create("UICorner", {CornerRadius = UDim.new(1, 0)})
        })
        
        sliders[i] = {
            Track = track,
            Fill = fill,
            ValueBox = valueBox,
            Index = i
        }
    end
    
    -- Close button
    local CloseBtn = Utility:Create("TextButton", {
        Parent = ColorFrame,
        Text = "Apply & Close",
        Font = Netro65UI.Theme.FontBold,
        TextSize = 14,
        TextColor3 = Netro65UI.Theme.Text,
        BackgroundColor3 = Netro65UI.Theme.Accent,
        Size = UDim2.new(0.8, 0, 0, 35),
        Position = UDim2.new(0.1, 0, 1, -50),
        AutoButtonColor = false
    }, {
        Utility:Create("UICorner", {CornerRadius = UDim.new(0, 6)})
    })
    
    local function updateColor()
        local r = sliders[1].Fill.Size.X.Scale
        local g = sliders[2].Fill.Size.X.Scale
        local b = sliders[3].Fill.Size.X.Scale
        
        currentColor = Color3.new(r, g, b)
        Preview.BackgroundColor3 = currentColor
        
        if callback then
            callback(currentColor)
        end
    end
    
    for i, slider in pairs(sliders) do
        local function updateSlider(value)
            value = math.clamp(value, 0, 1)
            slider.Fill.Size = UDim2.new(value, 0, 1, 0)
            slider.ValueBox.Text = tostring(math.floor(value * 255))
            updateColor()
        end
        
        -- Value box input
        slider.ValueBox.FocusLost:Connect(function()
            local num = tonumber(slider.ValueBox.Text)
            if num then
                updateSlider(num / 255)
            end
        end)
        
        -- Slider dragging
        local dragging = false
        slider.Track.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                local mousePos = UserInputService:GetMouseLocation()
                local relative = (mousePos.X - slider.Track.AbsolutePosition.X) / slider.Track.AbsoluteSize.X
                updateSlider(relative)
            end
        end)
        
        slider.Track.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local mousePos = UserInputService:GetMouseLocation()
                local relative = (mousePos.X - slider.Track.AbsolutePosition.X) / slider.Track.AbsoluteSize.X
                updateSlider(relative)
            end
        end)
    end
    
    CloseBtn.MouseButton1Click:Connect(function()
        ColorFrame:Destroy()
    end)
    
    Utility:MakeDraggable(ColorFrame)
    
    return colorPicker
end

--// Command Bar System
local CommandBar = nil
local Commands = {}

function Netro65UI:RegisterCommand(name, description, callback)
    Commands[name:lower()] = {
        Name = name,
        Description = description,
        Callback = callback
    }
end

function Netro65UI:ShowCommandBar()
    if CommandBar then CommandBar:Destroy() end
    
    CommandBar = Utility:Create("Frame", {
        Parent = ScreenGui,
        BackgroundColor3 = Netro65UI.Theme.Main,
        Size = UDim2.new(0, 400, 0, 40),
        Position = UDim2.new(0.5, -200, 0, -50),
        ZIndex = 3000
    }, {
        Utility:Create("UICorner", {CornerRadius = UDim.new(0, 6)}),
        Utility:Create("UIStroke", {Color = Netro65UI.Theme.Accent, Thickness = 2}),
        Utility:Create("TextBox", {
            Name = "Input",
            PlaceholderText = "Type command... (Press '/' to focus)",
            Font = Netro65UI.Theme.FontMain,
            TextSize = 14,
            TextColor3 = Netro65UI.Theme.Text,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -20, 1, 0),
            Position = UDim2.new(0, 10, 0, 0),
            TextXAlignment = Enum.TextXAlignment.Left
        })
    })
    
    Utility:Tween(CommandBar, {0.3}, {Position = UDim2.new(0.5, -200, 0, 20)})
    
    CommandBar.Input:CaptureFocus()
    
    CommandBar.Input.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            local text = CommandBar.Input.Text
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
            
            Utility:Tween(CommandBar, {0.3}, {Position = UDim2.new(0.5, -200, 0, -50)})
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
                    Utility:Tween(CommandBar, {0.3}, {Position = UDim2.new(0.5, -200, 0, -50)})
                    task.wait(0.3)
                    CommandBar:Destroy()
                    CommandBar = nil
                end
                connection:Disconnect()
            end
        end
    end)
end

--// Enhanced Notification System (Reduced Size)
local NotificationContainer = Utility:Create("Frame", {
    Name = "Notifications",
    Parent = ScreenGui,
    BackgroundTransparency = 1,
    Position = UDim2.new(1, -260, 0, 30),
    Size = UDim2.new(0, 250, 1, -30),
    ZIndex = 500
}, {
    Utility:Create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder, 
        Padding = UDim.new(0, 6), 
        VerticalAlignment = Enum.VerticalAlignment.Bottom
    })
})

function Netro65UI:Notify(props)
    local title = props.Title or "Notification"
    local content = props.Content or "Information"
    local duration = props.Duration or 4
    local typeColor = Netro65UI.Theme.Accent
    
    if props.Type == "Success" then typeColor = Netro65UI.Theme.Success 
    elseif props.Type == "Warning" then typeColor = Netro65UI.Theme.Warning 
    elseif props.Type == "Error" then typeColor = Netro65UI.Theme.Error end

    local NotifFrame = Utility:Create("Frame", {
        Name = "Notification",
        Parent = NotificationContainer, 
        BackgroundColor3 = Netro65UI.Theme.Secondary,
        Size = UDim2.new(1, 0, 0, 0), 
        BorderSizePixel = 0, 
        ClipsDescendants = true, 
        BackgroundTransparency = 0.05
    }, {
        Utility:Create("UICorner", {CornerRadius = UDim.new(0, 6)}),
        Utility:Create("UIStroke", {Color = typeColor, Thickness = 1.5, Transparency = 0.5}),
        Utility:Create("TextLabel", {
            Text = title, 
            Font = Netro65UI.Theme.FontBold, 
            TextSize = 13, 
            TextColor3 = Netro65UI.Theme.Text, 
            BackgroundTransparency = 1, 
            Position = UDim2.new(0, 10, 0, 6), 
            Size = UDim2.new(1, -20, 0, 16), 
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd
        }),
        Utility:Create("TextLabel", {
            Text = content, 
            Font = Netro65UI.Theme.FontMain, 
            TextSize = 11, 
            TextColor3 = Netro65UI.Theme.TextDark, 
            BackgroundTransparency = 1, 
            Position = UDim2.new(0, 10, 0, 24), 
            Size = UDim2.new(1, -20, 1, -28), 
            TextXAlignment = Enum.TextXAlignment.Left, 
            TextWrapped = true, 
            TextYAlignment = Enum.TextYAlignment.Top
        }),
        Utility:Create("Frame", {
            Name = "Timer", 
            BackgroundColor3 = typeColor, 
            Size = UDim2.new(1, 0, 0, 2), 
            Position = UDim2.new(0, 0, 1, -2), 
            BorderSizePixel = 0
        }, {
            Utility:Create("UICorner", {CornerRadius = UDim.new(0, 6)})
        }),
        Utility:Create("TextButton", {
            Name = "CloseBtn",
            Text = "✕",
            Font = Netro65UI.Theme.FontBold,
            TextSize = 10,
            TextColor3 = Netro65UI.Theme.TextDark,
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 18, 0, 18),
            Position = UDim2.new(1, -20, 0, 4)
        })
    })

    Utility:Tween(NotifFrame, {0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out}, {
        Size = UDim2.new(1, 0, 0, 55)
    })
    
    Utility:Tween(NotifFrame.Timer, {duration, Enum.EasingStyle.Linear}, {
        Size = UDim2.new(0, 0, 0, 2)
    })
    
    NotifFrame.CloseBtn.MouseButton1Click:Connect(function()
        Utility:Tween(NotifFrame, {0.3}, {
            Size = UDim2.new(1, 0, 0, 0), 
            BackgroundTransparency = 1
        })
        task.wait(0.3)
        NotifFrame:Destroy()
    end)
    
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
end

--// Config System Functions
function Netro65UI:GetConfigs(isUniversal)
    local configs = {}
    local path = Netro65UI.ConfigFolder .. "/" .. (isUniversal and "Universal" or tostring(game.PlaceId))
    
    if not isfolder(Netro65UI.ConfigFolder) then
        if makefolder then
            makefolder(Netro65UI.ConfigFolder)
        else
            return {"No folder support"}
        end
    end
    
    if not isfolder(path) then
        if makefolder then
            makefolder(path)
        end
        return {"default"}
    end
    
    -- List all JSON files in the folder
    local success, files = pcall(function()
        if listfiles then
            return listfiles(path)
        end
        return {}
    end)
    
    if success and files then
        for _, file in pairs(files) do
            if string.match(file, "%.json$") then
                local configName = string.match(file, "([^/\\]+)%.json$")
                if configName then
                    table.insert(configs, configName)
                end
            end
        end
    end
    
    if #configs == 0 then
        return {"No configs found"}
    end
    
    table.sort(configs)
    return configs
end

function Netro65UI:DeleteConfig(name, isUniversal)
    local path = Netro65UI.ConfigFolder .. "/" .. (isUniversal and "Universal" or tostring(game.PlaceId)) .. "/" .. name .. ".json"
    
    if not isfile(path) then
        Netro65UI:Notify({
            Title = "Error", 
            Content = "Config file not found!", 
            Type = "Error"
        })
        return
    end
    
    local success, err = pcall(function()
        if delfile then
            delfile(path)
            return true
        else
            return false, "File system not supported"
        end
    end)
    
    if success then
        Netro65UI:Notify({
            Title = "Config Deleted", 
            Content = "Deleted: " .. name, 
            Type = "Success"
        })
    else
        Netro65UI:Notify({
            Title = "Delete Failed", 
            Content = err, 
            Type = "Error"
        })
    end
end

function Netro65UI:SaveConfig(name, isUniversal)
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
    
    -- Include keybinds in saved config
    local keybindsData = {}
    for name, kb in pairs(Netro65UI.Keybinds) do
        keybindsData[name] = {
            Key = kb.Key,
            Name = kb.Name
        }
    end
    
    local saveData = {
        Flags = Netro65UI.Flags,
        Keybinds = keybindsData,
        Theme = {
            r = Netro65UI.Theme.Accent.R,
            g = Netro65UI.Theme.Accent.G,
            b = Netro65UI.Theme.Accent.B
        }
    }
    
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
            -- Load flags
            for flag, value in pairs(data.Flags or {}) do
                Netro65UI.Flags[flag] = value
                if Netro65UI.Setters[flag] then
                    Netro65UI.Setters[flag](value)
                end
            end
            
            -- Load keybinds
            for name, keybindData in pairs(data.Keybinds or {}) do
                if keybindData.Key then
                    Netro65UI:UpdateKeybind(name, keybindData.Key)
                end
            end
            
            -- Load theme if present
            if data.Theme then
                Netro65UI.Theme.Accent = Color3.new(data.Theme.r, data.Theme.g, data.Theme.b)
                Netro65UI:SetTheme("Default") -- Refresh theme
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

--// Key System
function Netro65UI:TriggerKeySystem(settings, onComplete)
    local KeySettings = {
        KeyURL = settings.KeyURL or "",
        GetKeyLink = settings.KeyLink or "https://google.com",
        Title = settings.Title or "Key System",
        Subtitle = "Support us by getting a key!",
        Callback = onComplete or function() end
    }

    local KeyFrame = Utility:Create("Frame", {
        Name = "KeySystem", 
        Parent = ScreenGui, 
        BackgroundColor3 = Netro65UI.Theme.Main,
        Size = UDim2.new(0, 400, 0, 240), 
        Position = UDim2.new(0.5, -200, 0.5, -120),
        BorderSizePixel = 0, 
        ZIndex = 2000, 
        BackgroundTransparency = 0.05
    }, {
        Utility:Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
        Utility:Create("UIStroke", {Color = Netro65UI.Theme.Outline, Thickness = 2}),
        Utility:Create("TextLabel", {
            Text = KeySettings.Title, 
            Font = Netro65UI.Theme.FontBold, 
            TextSize = 22, 
            TextColor3 = Netro65UI.Theme.Text, 
            BackgroundTransparency = 1, 
            Size = UDim2.new(1, -40, 0, 30), 
            Position = UDim2.new(0, 20, 0, 15), 
            TextXAlignment = Enum.TextXAlignment.Left
        }),
        Utility:Create("TextLabel", {
            Text = KeySettings.Subtitle, 
            Font = Netro65UI.Theme.FontMain, 
            TextSize = 14, 
            TextColor3 = Netro65UI.Theme.TextDark, 
            BackgroundTransparency = 1, 
            Size = UDim2.new(1, -40, 0, 20), 
            Position = UDim2.new(0, 20, 0, 50),
            TextXAlignment = Enum.TextXAlignment.Left
        }),
        Utility:Create("TextButton", {
            Text = "X", 
            Font = Netro65UI.Theme.FontBold, 
            TextSize = 16, 
            TextColor3 = Netro65UI.Theme.Error, 
            BackgroundTransparency = 1, 
            Size = UDim2.new(0, 40, 0, 40), 
            Position = UDim2.new(1, -40, 0, 5), 
            Name = "CloseBtn"
        })
    })

    local InputBox = Utility:Create("TextBox", {
        Parent = KeyFrame, 
        BackgroundColor3 = Netro65UI.Theme.Secondary,
        Size = UDim2.new(0.9, 0, 0, 45), 
        Position = UDim2.new(0.05, 0, 0, 90),
        Font = Netro65UI.Theme.FontMain, 
        TextSize = 14, 
        TextColor3 = Netro65UI.Theme.Text,
        PlaceholderText = "Paste Key Here...", 
        PlaceholderColor3 = Netro65UI.Theme.TextDark,
        Text = "", 
        ClearTextOnFocus = false, 
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Center
    }, {
        Utility:Create("UICorner", {CornerRadius = UDim.new(0, 6)}),
        Utility:Create("UIStroke", {Color = Netro65UI.Theme.Outline, Thickness = 1})
    })

    local BtnContainer = Utility:Create("Frame", {
        Parent = KeyFrame, 
        BackgroundTransparency = 1, 
        Size = UDim2.new(0.9, 0, 0, 40), 
        Position = UDim2.new(0.05, 0, 0, 160)
    })
    
    local ConfirmBtn = Utility:Create("TextButton", {
        Parent = BtnContainer, 
        Text = "Verify Key", 
        Font = Netro65UI.Theme.FontBold, 
        TextSize = 14, 
        TextColor3 = Netro65UI.Theme.Main, 
        BackgroundColor3 = Netro65UI.Theme.Success, 
        Size = UDim2.new(0.48, 0, 1, 0), 
        Position = UDim2.new(0, 0, 0, 0), 
        AutoButtonColor = false
    }, {
        Utility:Create("UICorner", {CornerRadius = UDim.new(0, 6)})
    })

    local GetKeyBtn = Utility:Create("TextButton", {
        Parent = BtnContainer, 
        Text = "Get Key Link", 
        Font = Netro65UI.Theme.FontBold, 
        TextSize = 14, 
        TextColor3 = Netro65UI.Theme.Text, 
        BackgroundColor3 = Netro65UI.Theme.Secondary, 
        Size = UDim2.new(0.48, 0, 1, 0), 
        Position = UDim2.new(0.52, 0, 0, 0), 
        AutoButtonColor = false
    }, {
        Utility:Create("UICorner", {CornerRadius = UDim.new(0, 6)}), 
        Utility:Create("UIStroke", {Color = Netro65UI.Theme.Outline, Thickness = 1})
    })

    Utility:MakeDraggable(KeyFrame)
    Acrylic:Enable()

    KeyFrame.CloseBtn.MouseButton1Click:Connect(function()
        Acrylic:Disable()
        KeyFrame:Destroy()
    end)

    GetKeyBtn.MouseButton1Click:Connect(function()
        Utility:Ripple(GetKeyBtn)
        if setclipboard then
            setclipboard(KeySettings.GetKeyLink)
            Netro65UI:Notify({
                Title = "Copied", 
                Content = "Key link copied to clipboard!", 
                Type = "Success"
            })
        else
            Netro65UI:Notify({
                Title = "Error", 
                Content = "Your executor doesn't support setclipboard.", 
                Type = "Error"
            })
        end
    end)

    ConfirmBtn.MouseButton1Click:Connect(function()
        Utility:Ripple(ConfirmBtn)
        local inputKey = InputBox.Text
        if inputKey:gsub(" ", "") == "" then return end
        
        ConfirmBtn.Text = "Checking..."
        
        local success, response = pcall(function() 
            return game:HttpGet(KeySettings.KeyURL) 
        end)
        
        if not success then
            Netro65UI:Notify({
                Title = "Connection Error", 
                Content = "Failed to fetch valid keys.", 
                Type = "Error"
            })
            ConfirmBtn.Text = "Verify Key"
            return
        end

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

        local isValid = CheckIDInList(response, inputKey)

        if isValid then
            Netro65UI:Notify({
                Title = "Success", 
                Content = "Key Verified! Loading UI...", 
                Type = "Success"
            })
            Utility:Tween(KeyFrame, {0.3}, {
                Size = UDim2.new(0, 0, 0, 0), 
                BackgroundTransparency = 1
            })
            task.wait(0.3)
            Acrylic:Disable()
            KeyFrame:Destroy()
            KeySettings.Callback()
        else
            Netro65UI:Notify({
                Title = "Invalid", 
                Content = "The key you entered is incorrect.", 
                Type = "Error"
            })
            ConfirmBtn.Text = "Verify Key"
            InputBox.Text = ""
        end
    end)
end

--// System Loader
function Netro65UI:Load(config)
    local vipUrl = config.VIPUrl
    local useKeySystem = config.KeySystem
    local finalCallback = config.OnLoad or function() 
        warn("No OnLoad callback provided!") 
    end

    Netro65UI:Notify({
        Title = "System", 
        Content = "Checking access...", 
        Duration = 2
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

--// Register default commands
Netro65UI:RegisterCommand("help", "Show all commands", function(args)
    local message = "Available Commands:\n"
    for name, cmd in pairs(Commands) do
        message = message .. string.format("/%s - %s\n", cmd.Name, cmd.Description)
    end
    Netro65UI:Notify({
        Title = "Command Help",
        Content = message,
        Duration = 10
    })
end)

Netro65UI:RegisterCommand("clear", "Clear all notifications", function(args)
    for _, child in pairs(ScreenGui:GetChildren()) do
        if child.Name == "Notification" then
            child:Destroy()
        end
    end
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
        local themes = ""
        for name, _ in pairs(Netro65UI.Presets) do
            themes = themes .. name .. ", "
        end
        Netro65UI:Notify({
            Title = "Available Themes",
            Content = themes,
            Duration = 5
        })
    end
end)

Netro65UI:RegisterCommand("rainbow", "Toggle rainbow mode", function(args)
    local enabled = not Netro65UI.RainbowMode.Enabled
    Netro65UI:ToggleRainbowMode(enabled, 1)
    Netro65UI:Notify({
        Title = "Rainbow Mode",
        Content = enabled and "Enabled" or "Disabled",
        Type = "Success"
    })
end)

Netro65UI:RegisterCommand("save", "Save current config", function(args)
    local name = args[1] or "quick_save"
    Netro65UI:SaveConfig(name, false)
end)

Netro65UI:RegisterCommand("load", "Load config", function(args)
    local name = args[1] or "quick_save"
    Netro65UI:LoadConfig(name, false)
end)

--// Enhanced Window Creation
function Netro65UI:CreateWindow(props)
    local WindowObj = {}
    props = props or {}
    -- Updated dimensions: Compact, not too wide/tall
    local windowWidth = props.Width or 500 
    local windowHeight = props.Height or 350
    local titleText = props.Title or "Netro65UI"
    
    local marketingData = props.Marketing or {}
    local finalUpgradeText = marketingData.ButtonText or "Upgrade to VIP Script"
    local finalUpgradeLink = marketingData.Link or "https://discord.gg/RpYcMdzzwd"
    
    local bubbleConfig = props.Bubble or {
        Type = "Text",
        Content = "NetroUI", 
        Color = Netro65UI.Theme.Accent
    }
    
    local TabCount = 0
    local isWindowVisible = true
    
    Acrylic:Enable()
    
    Netro65UI:CreateWatermark("NetroUI V5.3 | " .. LocalPlayer.Name)

    --// MAIN WINDOW FRAME //
    local MainFrame = Utility:Create("Frame", {
        Name = "MainWindow", 
        Parent = ScreenGui, 
        BackgroundColor3 = Netro65UI.Theme.Main, 
        Position = UDim2.new(0.5, -windowWidth/2, 0.5, -windowHeight/2), 
        Size = UDim2.fromOffset(windowWidth, windowHeight), 
        BorderSizePixel = 0, 
        BackgroundTransparency = 0.05
    }, {
        Utility:Create("UICorner", {CornerRadius = UDim.new(0, 6)}), 
        Utility:Create("UIStroke", {Color = Netro65UI.Theme.Outline, Thickness = 1.5})
    })
    
    table.insert(Netro65UI.ThemeObjects, {
        Instance = MainFrame, 
        Type = "Main"
    })

    --// BUBBLE BUTTON //
    local BubbleButton = Utility:Create("TextButton", {
        Name = "BubbleButton",
        Parent = ScreenGui,
        Size = UDim2.fromOffset(50, 50),
        Position = UDim2.new(0.1, 0, 0.1, 0),
        BackgroundColor3 = bubbleConfig.Color or Netro65UI.Theme.Accent,
        Visible = false,
        Text = "",
        AutoButtonColor = false,
        ZIndex = 5000
    }, {
        Utility:Create("UICorner", {CornerRadius = UDim.new(0, 14)}),
        Utility:Create("UIStroke", {Color = Netro65UI.Theme.Outline, Thickness = 1.5})
    })
    
    local BubbleContent
    if bubbleConfig.Type == "Image" then
        BubbleButton.BackgroundTransparency = 1 
        BubbleButton.BackgroundColor3 = Color3.new(1,1,1)
        BubbleContent = Utility:Create("ImageLabel", {
            Parent = BubbleButton,
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Image = bubbleConfig.Content,
            ImageColor3 = Color3.new(1,1,1)
        })
    elseif bubbleConfig.Type == "Text" or bubbleConfig.Type == "Emoji" then
        BubbleButton.BackgroundTransparency = 0
        table.insert(Netro65UI.ThemeObjects, {Instance = BubbleButton, Type = "Accent", Property = "BackgroundColor3"})
        BubbleContent = Utility:Create("TextLabel", {
            Parent = BubbleButton,
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Text = bubbleConfig.Content,
            TextColor3 = Netro65UI.Theme.Text,
            Font = Netro65UI.Theme.FontBold,
            TextSize = (bubbleConfig.Type == "Emoji") and 28 or 12,
            TextWrapped = true
        })
    end
    
    Utility:MakeDraggable(BubbleButton)

    local function ToggleWindow(showWindow)
        isWindowVisible = showWindow
        if showWindow then
            MainFrame.Visible = true
            BubbleButton.Visible = false
            Acrylic:Enable()
            Utility:Tween(MainFrame, {0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out}, {
                Size = UDim2.fromOffset(windowWidth, windowHeight),
                BackgroundTransparency = 0.05
            })
            for _, child in pairs(MainFrame:GetChildren()) do
                if child:IsA("GuiObject") then child.Visible = true end
            end
        else
            BubbleButton.Visible = true
            Utility:Tween(MainFrame, {0.2}, {
                Size = UDim2.fromOffset(windowWidth, 0),
                BackgroundTransparency = 1
            })
            task.wait(0.2)
            MainFrame.Visible = false
            Acrylic:Disable()
        end
    end
    
    BubbleButton.MouseButton1Click:Connect(function()
        ToggleWindow(true)
    end)

    local Header = Utility:Create("Frame", {
        Name = "Header", 
        Parent = MainFrame, 
        BackgroundColor3 = Netro65UI.Theme.Secondary, 
        Size = UDim2.new(1, 0, 0, 45), 
        BorderSizePixel = 0, 
        BackgroundTransparency = 0.5
    }, {
        Utility:Create("UICorner", {CornerRadius = UDim.new(0, 6)}),
        Utility:Create("Frame", {
            BackgroundColor3 = Netro65UI.Theme.Secondary, 
            Size = UDim2.new(1, 0, 0, 10), 
            Position = UDim2.new(0, 0, 1, -10), 
            BorderSizePixel = 0, 
            BackgroundTransparency = 0.5
        }),
        Utility:Create("TextLabel", {
            Text = titleText, 
            Font = Netro65UI.Theme.FontBold, 
            TextSize = 16, 
            TextColor3 = Netro65UI.Theme.Text, 
            BackgroundTransparency = 1, 
            Size = UDim2.new(0, 180, 1, 0), 
            Position = UDim2.new(0, 15, 0, 0), 
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd 
        }),
        Utility:Create("TextLabel", {
            Text = "v"..Netro65UI.Version, 
            Font = Netro65UI.Theme.FontMain, 
            TextSize = 11, 
            TextColor3 = Netro65UI.Theme.Accent, 
            BackgroundTransparency = 1, 
            Size = UDim2.new(0, 40, 1, 0), 
            Position = UDim2.new(0, 200, 0, 0), 
            TextXAlignment = Enum.TextXAlignment.Left
        })
    })
    
    table.insert(Netro65UI.ThemeObjects, {
        Instance = Header.TextLabel, 
        Type = "Accent", 
        Property = "TextColor3"
    })
    
    Utility:MakeDraggable(MainFrame, Header)

    local SearchBar = Utility:Create("Frame", {
        Parent = Header, 
        BackgroundColor3 = Netro65UI.Theme.Main, 
        Size = UDim2.new(0, 160, 0, 28), 
        Position = UDim2.new(1, -225, 0.5, -14), 
        BackgroundTransparency = 0.5
    }, {
        Utility:Create("UICorner", {CornerRadius = UDim.new(0, 5)}), 
        Utility:Create("UIStroke", {Color = Netro65UI.Theme.Outline, Thickness = 1}), 
        Utility:Create("ImageLabel", {
            Image = "rbxassetid://5036549785", 
            BackgroundTransparency = 1, 
            Size = UDim2.new(0, 14, 0, 14), 
            Position = UDim2.new(0, 8, 0.5, -7), 
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
        Size = UDim2.new(1, -30, 1, 0), 
        Position = UDim2.new(0, 28, 0, 0), 
        Font = Netro65UI.Theme.FontMain, 
        TextSize = 13, 
        TextColor3 = Netro65UI.Theme.Text, 
        PlaceholderText = "Search...", 
        PlaceholderColor3 = Netro65UI.Theme.TextDark, 
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local CloseBtn = Utility:Create("TextButton", {
        Parent = Header, 
        Text = "", 
        BackgroundColor3 = Color3.fromRGB(255, 80, 80), 
        Size = UDim2.new(0, 12, 0, 12), 
        Position = UDim2.new(1, -25, 0, 17), 
        AutoButtonColor = false
    }, {
        Utility:Create("UICorner", {CornerRadius = UDim.new(1,0)})
    })
    
    local MinBtn = Utility:Create("TextButton", {
        Parent = Header, 
        Text = "", 
        BackgroundColor3 = Color3.fromRGB(255, 200, 80), 
        Size = UDim2.new(0, 12, 0, 12), 
        Position = UDim2.new(1, -45, 0, 17), 
        AutoButtonColor = false
    }, {
        Utility:Create("UICorner", {CornerRadius = UDim.new(1,0)})
    })
    
    CloseBtn.MouseButton1Click:Connect(function() 
        Acrylic:Disable() 
        Utility:Tween(MainFrame, {0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In}, {
            Size = UDim2.new(0,0,0,0)
        }) 
        if BubbleButton then BubbleButton:Destroy() end
        wait(0.3) 
        ScreenGui:Destroy() 
    end)
    
    MinBtn.MouseButton1Click:Connect(function() 
        ToggleWindow(false)
    end)

    local ContentContainer = Utility:Create("Frame", {
        Name = "Content", 
        Parent = MainFrame, 
        BackgroundTransparency = 1, 
        Position = UDim2.new(0, 0, 0, 45), 
        Size = UDim2.new(1, 0, 1, -45), 
        ClipsDescendants = true
    })
    
    local NavWidth = 140 -- Slightly smaller for compact feel
    local NavContainer = Utility:Create("ScrollingFrame", {
        Name = "Navigation", 
        Parent = ContentContainer, 
        BackgroundTransparency = 1, 
        Size = UDim2.new(0, NavWidth, 1, -75), 
        Position = UDim2.new(0, 0, 0, 10), 
        ScrollBarThickness = 0, 
        CanvasSize = UDim2.new(0,0,0,0)
    }, {
        Utility:Create("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder, 
            Padding = UDim.new(0, 6)
        }), 
        Utility:Create("UIPadding", {
            PaddingLeft = UDim.new(0, 10), 
            PaddingTop = UDim.new(0, 5)
        })
    })
    
    Utility:Create("Frame", {
        Parent = ContentContainer, 
        BackgroundColor3 = Netro65UI.Theme.Outline, 
        Size = UDim2.new(0, 1, 1, -20), 
        Position = UDim2.new(0, NavWidth, 0, 10), 
        BorderSizePixel = 0
    })

    local ProfileCard = Utility:Create("Frame", {
        Parent = ContentContainer, 
        BackgroundColor3 = Netro65UI.Theme.Secondary, 
        Size = UDim2.new(0, NavWidth - 20, 0, 45), 
        Position = UDim2.new(0, 10, 1, -60),
        BorderSizePixel = 0, 
        BackgroundTransparency = 0.3
    }, {
        Utility:Create("UICorner", {CornerRadius = UDim.new(0, 6)}), 
        Utility:Create("UIStroke", {Color = Netro65UI.Theme.Outline, Thickness = 1}), 
        Utility:Create("ImageLabel", {
            Image = Players:GetUserThumbnailAsync(
                LocalPlayer.UserId, 
                Enum.ThumbnailType.HeadShot, 
                Enum.ThumbnailSize.Size48x48
            ), 
            Size = UDim2.new(0, 32, 0, 32), 
            Position = UDim2.new(0, 6, 0.5, -16), 
            BackgroundColor3 = Netro65UI.Theme.Main
        }, {
            Utility:Create("UICorner", {CornerRadius = UDim.new(1, 0)})
        }), 
        Utility:Create("TextLabel", {
            Text = LocalPlayer.DisplayName, 
            Font = Netro65UI.Theme.FontBold, 
            TextSize = 12, 
            TextColor3 = Netro65UI.Theme.Text, 
            BackgroundTransparency = 1, 
            Position = UDim2.new(0, 46, 0, 8), 
            Size = UDim2.new(1, -50, 0, 14), 
            TextXAlignment = Enum.TextXAlignment.Left, 
            TextTruncate = Enum.TextTruncate.AtEnd
        }), 
        Utility:Create("TextLabel", {
            Text = Netro65UI.IsVIP and "VIP User" or "Free User", 
            Font = Netro65UI.Theme.FontMain, 
            TextSize = 10, 
            TextColor3 = Netro65UI.Theme.Accent, 
            BackgroundTransparency = 1, 
            Position = UDim2.new(0, 46, 0, 24), 
            Size = UDim2.new(1, -50, 0, 12), 
            TextXAlignment = Enum.TextXAlignment.Left
        })
    })
    
    table.insert(Netro65UI.ThemeObjects, {
        Instance = ProfileCard.ImageLabel, 
        Type = "Main"
    })
    
    if not Netro65UI.IsVIP then
        table.insert(Netro65UI.ThemeObjects, {
            Instance = ProfileCard:WaitForChild("TextLabel"), 
            Type = "Accent", 
            Property = "TextColor3"
        })
    else
        ProfileCard:WaitForChild("TextLabel").TextColor3 = Color3.fromRGB(255, 215, 0)
    end

    local Pages = Utility:Create("Frame", {
        Name = "Pages", 
        Parent = ContentContainer, 
        BackgroundTransparency = 1, 
        Position = UDim2.new(0, NavWidth + 10, 0, 0), 
        Size = UDim2.new(1, -(NavWidth + 10), 1, 0), 
        ClipsDescendants = true
    })
    
    local SearchableElements = {}
    SearchInput:GetPropertyChangedSignal("Text"):Connect(function() 
        local query = SearchInput.Text:lower() 
        for _, item in pairs(SearchableElements) do 
            if item.Element then 
                item.Element.Visible = (query == "" or string.find(item.Keywords:lower(), query)) 
            end 
        end 
    end)

    local tabs = {}
    
    function WindowObj:AddTab(name, layoutOrder)
        TabCount = TabCount + 1
        local currentOrder = layoutOrder or TabCount
        
        local Tab = {}
        local TabBtn = Utility:Create("TextButton", {
            Parent = NavContainer, 
            Text = name, 
            Font = Netro65UI.Theme.FontMain, 
            TextSize = 13, 
            TextColor3 = Netro65UI.Theme.TextDark, 
            BackgroundColor3 = Netro65UI.Theme.Main, 
            BackgroundTransparency = 1, 
            Size = UDim2.new(1, 0, 0, 34), 
            AutoButtonColor = false, 
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
            LayoutOrder = currentOrder
        }, {
            Utility:Create("UIPadding", {PaddingLeft = UDim.new(0, 10)}), 
            Utility:Create("UICorner", {CornerRadius = UDim.new(0, 5)}), 
            Utility:Create("ImageLabel", {
                Name = "ActiveBar", 
                BackgroundColor3 = Netro65UI.Theme.Accent, 
                Size = UDim2.new(0, 3, 0, 18), 
                Position = UDim2.new(0, -10, 0.5, -9), 
                Visible = false
            }, {
                Utility:Create("UICorner", {CornerRadius = UDim.new(0, 2)})
            })
        })
        
        table.insert(Netro65UI.ThemeObjects, {
            Instance = TabBtn.ActiveBar, 
            Type = "Accent"
        })
        
        --// HYBRID LAYOUT SYSTEM //
        local Page = Utility:Create("ScrollingFrame", {
            Name = name.."_Page", 
            Parent = Pages, 
            BackgroundTransparency = 1, 
            Size = UDim2.new(1, 0, 1, 0), 
            Visible = false, 
            ScrollBarThickness = 3, 
            ScrollBarImageColor3 = Netro65UI.Theme.Accent, 
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            CanvasSize = UDim2.new(0,0,0,0)
        }, {
            Utility:Create("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 10),
                HorizontalAlignment = Enum.HorizontalAlignment.Center
            }),
            Utility:Create("UIPadding", {
                PaddingTop = UDim.new(0, 10),
                PaddingBottom = UDim.new(0, 10),
                PaddingLeft = UDim.new(0, 2),
                PaddingRight = UDim.new(0, 6) -- Extra padding for scrollbar
            })
        })
        
        table.insert(Netro65UI.ThemeObjects, {
            Instance = Page, 
            Type = "Accent", 
            Property = "ScrollBarImageColor3"
        })

        TabBtn.MouseButton1Click:Connect(function() 
            if Utility:CheckLock(TabBtn) then return end
            for _, t in pairs(tabs) do 
                t.Btn.ActiveBar.Visible = false 
                Utility:Tween(t.Btn, {0.2}, {
                    BackgroundTransparency = 1, 
                    TextColor3 = Netro65UI.Theme.TextDark
                }) 
                t.Page.Visible = false 
            end 
            TabBtn.ActiveBar.Visible = true 
            Utility:Tween(TabBtn, {0.2}, {
                BackgroundTransparency = 0.92, 
                BackgroundColor3 = Netro65UI.Theme.Accent, 
                TextColor3 = Netro65UI.Theme.Text
            }) 
            Page.Visible = true 
        end)
        
        if #tabs == 0 then 
            TabBtn.ActiveBar.Visible = true 
            TabBtn.BackgroundTransparency = 0.92 
            TabBtn.BackgroundColor3 = Netro65UI.Theme.Accent 
            TabBtn.TextColor3 = Netro65UI.Theme.Text 
            Page.Visible = true 
        end
        
        table.insert(tabs, {Btn = TabBtn, Page = Page})

        function Tab:Lock(text, reason) 
            Utility:LockElement(TabBtn, text, reason) 
        end
        
        function Tab:Unlock() 
            Utility:UnlockElement(TabBtn) 
        end
        
        Tab.PageInstance = Page -- For direct access if needed
        Tab.LastRow = nil

        --// New AddSection with Layout Options
        function Tab:AddSection(sectionName, side)
            -- side options: "Normal" (default), "Left", "Right"
            side = side or "Normal"
            local Section = {}
            local parentContainer

            if side == "Normal" then
                -- Direct child of Page, full width
                parentContainer = Page
                Tab.LastRow = nil -- Reset row logic
            else
                -- Side-by-side logic
                if not Tab.LastRow then
                    -- Create a new container row
                    Tab.LastRow = Utility:Create("Frame", {
                        Name = "DualRow",
                        Parent = Page,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(0.98, 0, 0, 0), -- Width slightly less than 1 to fit padding
                        AutomaticSize = Enum.AutomaticSize.Y
                    }, {
                        Utility:Create("Frame", {
                            Name = "LeftCol",
                            Size = UDim2.new(0.48, 0, 0, 0),
                            Position = UDim2.new(0, 0, 0, 0),
                            BackgroundTransparency = 1,
                            AutomaticSize = Enum.AutomaticSize.Y
                        }, {
                            Utility:Create("UIListLayout", {
                                SortOrder = Enum.SortOrder.LayoutOrder,
                                Padding = UDim.new(0, 10)
                            })
                        }),
                        Utility:Create("Frame", {
                            Name = "RightCol",
                            Size = UDim2.new(0.48, 0, 0, 0),
                            Position = UDim2.new(0.52, 0, 0, 0),
                            BackgroundTransparency = 1,
                            AutomaticSize = Enum.AutomaticSize.Y
                        }, {
                            Utility:Create("UIListLayout", {
                                SortOrder = Enum.SortOrder.LayoutOrder,
                                Padding = UDim.new(0, 10)
                            })
                        })
                    })
                end
                
                if side == "Left" then
                    parentContainer = Tab.LastRow.LeftCol
                else
                    parentContainer = Tab.LastRow.RightCol
                end
            end

            local SectionFrame = Utility:Create("Frame", {
                Parent = parentContainer, 
                BackgroundColor3 = Netro65UI.Theme.Secondary, 
                Size = UDim2.new(side == "Normal" and 0.98 or 1, 0, 0, 0), 
                BorderSizePixel = 0, 
                BackgroundTransparency = 0.5,
                AutomaticSize = Enum.AutomaticSize.Y
            }, {
                Utility:Create("UICorner", {CornerRadius = UDim.new(0, 6)}), 
                Utility:Create("UIStroke", {Color = Netro65UI.Theme.Outline, Thickness = 1}), 
                Utility:Create("TextLabel", {
                    Text = sectionName, 
                    Font = Netro65UI.Theme.FontBold, 
                    TextSize = 13, 
                    TextColor3 = Netro65UI.Theme.Accent, 
                    BackgroundTransparency = 1, 
                    Size = UDim2.new(1, -20, 0, 35), 
                    Position = UDim2.new(0, 12, 0, 0), 
                    TextXAlignment = Enum.TextXAlignment.Left
                }), 
                Utility:Create("Frame", {
                    Name = "Container", 
                    BackgroundTransparency = 1, 
                    Position = UDim2.new(0, 0, 0, 40), 
                    Size = UDim2.new(1, 0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.Y
                }, {
                    Utility:Create("UIListLayout", {
                        SortOrder = Enum.SortOrder.LayoutOrder, 
                        Padding = UDim.new(0, 8), 
                        HorizontalAlignment = Enum.HorizontalAlignment.Center
                    }), 
                    Utility:Create("UIPadding", {PaddingBottom = UDim.new(0, 12)})
                })
            })
            
            table.insert(Netro65UI.ThemeObjects, {
                Instance = SectionFrame.TextLabel, 
                Type = "Accent", 
                Property = "TextColor3"
            })
            
            local ItemContainer = SectionFrame.Container

            -- [Button]
            function Section:AddButton(bProps)
                local btnObj = {}
                local btnText = bProps.Name or "Button"
                local callback = bProps.Callback or function() end
                
                local Button = Utility:Create("TextButton", {
                    Parent = ItemContainer, 
                    Text = btnText, 
                    Font = Netro65UI.Theme.FontMain, 
                    TextSize = 13, 
                    TextColor3 = Netro65UI.Theme.Text, 
                    BackgroundColor3 = Netro65UI.Theme.Main, 
                    Size = UDim2.new(0.94, 0, 0, 34),
                    AutoButtonColor = false, 
                    BorderSizePixel = 0
                }, {
                    Utility:Create("UICorner", {CornerRadius = UDim.new(0, 4)}), 
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
                
                Button.MouseButton1Click:Connect(function() 
                    if Utility:CheckLock(Button) then return end
                    Utility:Ripple(Button) 
                    callback() 
                end)
                
                Button.MouseEnter:Connect(function() 
                    Utility:Tween(Button, {0.2}, {
                        BackgroundColor3 = Netro65UI.Theme.Hover
                    }) 
                end)
                
                Button.MouseLeave:Connect(function() 
                    Utility:Tween(Button, {0.2}, {
                        BackgroundColor3 = Netro65UI.Theme.Main
                    }) 
                end)
                
                function btnObj:Lock(text, reason) 
                    Utility:LockElement(Button, text, reason) 
                end
                
                function btnObj:Unlock() 
                    Utility:UnlockElement(Button) 
                end
                
                return btnObj
            end

            -- [Cooldown Button]
            function Section:AddCooldownButton(cProps)
                local btnObj = {}
                local btnText = cProps.Name or "Cooldown Button"
                local duration = cProps.Time or 3
                local callback = cProps.Callback or function() end
                
                local Button = Utility:Create("TextButton", {
                    Parent = ItemContainer, 
                    Text = btnText, 
                    Font = Netro65UI.Theme.FontMain, 
                    TextSize = 13, 
                    TextColor3 = Netro65UI.Theme.Text, 
                    BackgroundColor3 = Netro65UI.Theme.Main, 
                    Size = UDim2.new(0.94, 0, 0, 34),
                    AutoButtonColor = false, 
                    BorderSizePixel = 0,
                    ClipsDescendants = true
                }, {
                    Utility:Create("UICorner", {CornerRadius = UDim.new(0, 4)}), 
                    Utility:Create("UIStroke", {Color = Netro65UI.Theme.Outline, Thickness = 1})
                })

                -- Progress Bar
                local ProgressBar = Utility:Create("Frame", {
                    Parent = Button,
                    BackgroundColor3 = Netro65UI.Theme.Accent,
                    BackgroundTransparency = 0.7,
                    Size = UDim2.new(0, 0, 1, 0),
                    ZIndex = 1,
                    BorderSizePixel = 0
                })
                
                table.insert(Netro65UI.ThemeObjects, {
                    Instance = Button, 
                    Type = "Main"
                })
                table.insert(Netro65UI.ThemeObjects, {
                    Instance = ProgressBar, 
                    Type = "Accent",
                    Property = "BackgroundColor3"
                })
                
                table.insert(SearchableElements, {
                    Element = Button, 
                    Keywords = btnText
                })
                
                local debounce = false

                Button.MouseButton1Click:Connect(function() 
                    if debounce then return end
                    if Utility:CheckLock(Button) then return end
                    
                    debounce = true
                    Utility:Ripple(Button)
                    callback() 
                    
                    -- Start Animation
                    local tween = TweenService:Create(ProgressBar, TweenInfo.new(duration, Enum.EasingStyle.Linear), {
                        Size = UDim2.new(1, 0, 1, 0)
                    })
                    tween:Play()
                    
                    local originalText = Button.Text
                    -- Optional: Countdown text
                    spawn(function()
                        for i = duration, 1, -1 do
                            if not debounce then break end
                            Button.Text = originalText .. " (" .. i .. ")"
                            wait(1)
                        end
                    end)

                    tween.Completed:Wait()
                    
                    -- Reset
                    ProgressBar.Size = UDim2.new(0, 0, 1, 0)
                    Button.Text = originalText
                    debounce = false
                end)
                
                return btnObj
            end

            -- [Toggle]
            function Section:AddToggle(tProps)
                local togObj = {}
                local tName = tProps.Name or "Toggle"
                local state = tProps.Default or false 
                local flag = tProps.Flag
                local callback = tProps.Callback or function() end
                
                if flag and Netro65UI.Flags[flag] ~= nil then 
                    state = Netro65UI.Flags[flag] 
                end
                
                local ToggleFrame = Utility:Create("Frame", {
                    Parent = ItemContainer, 
                    BackgroundTransparency = 1, 
                    Size = UDim2.new(0.94, 0, 0, 34)
                })
                
                Utility:Create("TextLabel", {
                    Parent = ToggleFrame, 
                    Text = tName, 
                    Font = Netro65UI.Theme.FontMain, 
                    TextSize = 13, 
                    TextColor3 = Netro65UI.Theme.Text, 
                    BackgroundTransparency = 1, 
                    Size = UDim2.new(1, -55, 1, 0), 
                    Position = UDim2.new(0, 0, 0, 0),
                    TextXAlignment = Enum.TextXAlignment.Left, 
                    TextTruncate = Enum.TextTruncate.AtEnd
                })
                
                local Switch = Utility:Create("TextButton", {
                    Parent = ToggleFrame, 
                    Text = "", 
                    BackgroundColor3 = state and Netro65UI.Theme.Accent or Netro65UI.Theme.Main, 
                    Size = UDim2.new(0, 42, 0, 22), 
                    Position = UDim2.new(1, -42, 0.5, -11), 
                    AutoButtonColor = false
                }, {
                    Utility:Create("UICorner", {CornerRadius = UDim.new(1, 0)}), 
                    Utility:Create("UIStroke", {Color = Netro65UI.Theme.Outline, Thickness = 1})
                })
                
                local Knob = Utility:Create("Frame", {
                    Parent = Switch, 
                    BackgroundColor3 = Color3.new(1,1,1), 
                    Size = UDim2.new(0, 18, 0, 18), 
                    Position = state and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
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
                        Position = state and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
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
                    if Utility:CheckLock(ToggleFrame) then return end
                    Update(not state) 
                end) 
                
                if flag then 
                    Netro65UI.Flags[flag] = state 
                    Netro65UI.Setters[flag] = Update
                end 
                
                Knob.Position = state and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
                Switch.BackgroundColor3 = state and Netro65UI.Theme.Accent or Netro65UI.Theme.Main
                callback(state)

                function togObj:Lock(text, reason) 
                    Utility:LockElement(ToggleFrame, text, reason) 
                end
                
                function togObj:Unlock() 
                    Utility:UnlockElement(ToggleFrame) 
                end
                
                return togObj
            end

            -- [Slider]
            function Section:AddSlider(sProps)
                local sldObj = {}
                local sName = sProps.Name or "Slider"
                local min, max = sProps.Min or 0, sProps.Max or 100
                local default = sProps.Default or min
                local flag = sProps.Flag
                local callback = sProps.Callback or function() end
                local value = default
                
                if flag and Netro65UI.Flags[flag] ~= nil then 
                    value = Netro65UI.Flags[flag] 
                end
                
                local SliderFrame = Utility:Create("Frame", {
                    Parent = ItemContainer, 
                    BackgroundTransparency = 1, 
                    Size = UDim2.new(0.94, 0, 0, 50)
                })
                
                Utility:Create("TextLabel", {
                    Parent = SliderFrame, 
                    Text = sName, 
                    Font = Netro65UI.Theme.FontMain, 
                    TextSize = 13, 
                    TextColor3 = Netro65UI.Theme.Text, 
                    BackgroundTransparency = 1, 
                    Size = UDim2.new(1, -50, 0, 20), 
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextTruncate = Enum.TextTruncate.AtEnd
                })
                
                local ValueBox = Utility:Create("TextBox", {
                    Parent = SliderFrame, 
                    Text = tostring(value), 
                    Font = Netro65UI.Theme.FontBold, 
                    TextSize = 13, 
                    TextColor3 = Netro65UI.Theme.Accent, 
                    BackgroundTransparency = 1, 
                    Size = UDim2.new(0, 40, 0, 20), 
                    Position = UDim2.new(1, -40, 0, 0), 
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
                    Size = UDim2.new(1, 0, 0, 6), 
                    Position = UDim2.new(0, 0, 0, 32)
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
                    Utility:Create("UICorner", {CornerRadius = UDim.new(1, 0)})
                })
                
                table.insert(Netro65UI.ThemeObjects, {
                    Instance = Fill, 
                    Type = "Accent"
                })
                
                local Hitbox = Utility:Create("TextButton", {
                    Parent = SliderFrame, 
                    BackgroundTransparency = 1, 
                    Text = "", 
                    Size = UDim2.new(1, 0, 0, 24), 
                    Position = UDim2.new(0, 0, 0, 24), 
                    ZIndex = 5
                })
                
                table.insert(SearchableElements, {
                    Element = SliderFrame, 
                    Keywords = sName
                })
                
                local function UpdateSlider(inputVal)
                    value = math.clamp(inputVal, min, max)
                    ValueBox.Text = tostring(value)
                    Utility:Tween(Fill, {0.05}, {
                        Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
                    })
                    if flag then 
                        Netro65UI.Flags[flag] = value 
                    end 
                    callback(value)
                end

                local isDragging = false
                Hitbox.InputBegan:Connect(function(input)
                    if Utility:CheckLock(SliderFrame) then return end
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        isDragging = true
                        local mousePos = UserInputService:GetMouseLocation()
                        local relativePos = mousePos.X - Track.AbsolutePosition.X
                        local percent = math.clamp(relativePos / Track.AbsoluteSize.X, 0, 1)
                        UpdateSlider(math.floor(min + ((max - min) * percent)))

                        local moveConn, releaseConn
                        moveConn = UserInputService.InputChanged:Connect(function(moveInput)
                            if (moveInput.UserInputType == Enum.UserInputType.MouseMovement or moveInput.UserInputType == Enum.UserInputType.Touch) and isDragging then
                                local mPos = UserInputService:GetMouseLocation()
                                local rel = mPos.X - Track.AbsolutePosition.X
                                local p = math.clamp(rel / Track.AbsoluteSize.X, 0, 1)
                                UpdateSlider(math.floor(min + ((max - min) * p)))
                            end
                        end)
                        
                        releaseConn = UserInputService.InputEnded:Connect(function(endInput)
                            if endInput.UserInputType == Enum.UserInputType.MouseButton1 or endInput.UserInputType == Enum.UserInputType.Touch then
                                isDragging = false
                                if moveConn then 
                                    moveConn:Disconnect() 
                                end
                                if releaseConn then 
                                    releaseConn:Disconnect() 
                                end
                            end
                        end)
                    end
                end)

                ValueBox.FocusLost:Connect(function() 
                    local num = tonumber(ValueBox.Text) 
                    if num then 
                        UpdateSlider(num) 
                    end 
                    ValueBox.Text = tostring(value) 
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

            -- [Dropdown]
            function Section:AddDropdown(dProps)
                local dName = dProps.Name or "Dropdown"
                local items = dProps.Items or {}
                local default = dProps.Default or items[1]
                local flag = dProps.Flag
                local callback = dProps.Callback or function() end
                local isOpen = false

                if flag and Netro65UI.Flags[flag] ~= nil then 
                    default = Netro65UI.Flags[flag] 
                end

                local DropdownFrame = Utility:Create("Frame", {
                    Parent = ItemContainer, 
                    BackgroundTransparency = 1, 
                    Size = UDim2.new(0.94, 0, 0, 50), 
                    ClipsDescendants = true,
                    ZIndex = 5
                })
                
                table.insert(SearchableElements, {
                    Element = DropdownFrame, 
                    Keywords = dName
                })
                
                local HeaderBtn = Utility:Create("TextButton", {
                    Parent = DropdownFrame, 
                    BackgroundColor3 = Netro65UI.Theme.Main, 
                    Size = UDim2.new(1, 0, 0, 34), 
                    Text = "", 
                    AutoButtonColor = false
                }, {
                    Utility:Create("UICorner", {CornerRadius = UDim.new(0, 4)}), 
                    Utility:Create("UIStroke", {Color = Netro65UI.Theme.Outline, Thickness = 1}),
                    Utility:Create("TextLabel", {
                        Text = dName, 
                        Font = Netro65UI.Theme.FontMain, 
                        TextSize = 13, 
                        TextColor3 = Netro65UI.Theme.Text, 
                        BackgroundTransparency = 1, 
                        Size = UDim2.new(0.5, 0, 1, 0), 
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
                        Size = UDim2.new(0.4, 0, 1, 0), 
                        Position = UDim2.new(0.6, -25, 0, 0), 
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
                    Position = UDim2.new(0, 0, 0, 40), 
                    CanvasSize = UDim2.new(0,0,0,0), 
                    ScrollBarThickness = 2, 
                    BorderSizePixel = 0,
                    ZIndex = 6
                }, {
                    Utility:Create("UICorner", {CornerRadius = UDim.new(0, 4)}),
                    Utility:Create("UIListLayout", {
                        SortOrder = Enum.SortOrder.LayoutOrder, 
                        Padding = UDim.new(0, 5), 
                        HorizontalAlignment = Enum.HorizontalAlignment.Center
                    }),
                    Utility:Create("UIPadding", {
                        PaddingTop = UDim.new(0, 5), 
                        PaddingBottom = UDim.new(0, 5)
                    })
                })

                -- Search Bar inside Dropdown
                local SearchBox = Utility:Create("TextBox", {
                    Parent = ListFrame, 
                    PlaceholderText = "Search...", 
                    Text = "", 
                    BackgroundColor3 = Netro65UI.Theme.Main, 
                    Size = UDim2.new(0.9, 0, 0, 25), 
                    Font = Netro65UI.Theme.FontMain, 
                    TextColor3 = Netro65UI.Theme.Text, 
                    TextSize = 12
                }, {
                    Utility:Create("UICorner", {CornerRadius = UDim.new(0, 4)})
                })
                
                table.insert(Netro65UI.ThemeObjects, {
                    Instance = SearchBox, 
                    Type = "Main"
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
                                Size = UDim2.new(0.9, 0, 0, 25),
                                BackgroundTransparency = 1, 
                                TextColor3 = Netro65UI.Theme.TextDark, 
                                Font = Netro65UI.Theme.FontMain, 
                                TextSize = 12,
                                ZIndex = 7
                            })
                            
                            ItemBtn.MouseButton1Click:Connect(function()
                                HeaderBtn.CurrentVal.Text = tostring(item)
                                if flag then 
                                    Netro65UI.Flags[flag] = item 
                                end
                                callback(item)
                                isOpen = false
                                Utility:Tween(DropdownFrame, {0.3}, {
                                    Size = UDim2.new(0.94, 0, 0, 50)
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

                SearchBox:GetPropertyChangedSignal("Text"):Connect(function() 
                    RefreshList(SearchBox.Text) 
                end)

                HeaderBtn.MouseButton1Click:Connect(function()
                    if Utility:CheckLock(DropdownFrame) then return end
                    isOpen = not isOpen
                    local listHeight = math.min(#items * 30 + 35, 150)
                    Utility:Tween(DropdownFrame, {0.3}, {
                        Size = isOpen and UDim2.new(0.94, 0, 0, 40 + listHeight) or UDim2.new(0.94, 0, 0, 50)
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
            end

            -- [Textbox]
            function Section:AddTextbox(tbProps)
                local tbName = tbProps.Name or "Textbox"
                local default = tbProps.Default or ""
                local placeholder = tbProps.Placeholder or "Input..."
                local numOnly = tbProps.NumberOnly or false
                local flag = tbProps.Flag
                local callback = tbProps.Callback or function() end

                local TbFrame = Utility:Create("Frame", {
                    Parent = ItemContainer, 
                    BackgroundTransparency = 1, 
                    Size = UDim2.new(0.94, 0, 0, 40)
                })
                
                table.insert(SearchableElements, {
                    Element = TbFrame, 
                    Keywords = tbName
                })
                
                Utility:Create("TextLabel", {
                    Parent = TbFrame, 
                    Text = tbName, 
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
                    Size = UDim2.new(0.45, 0, 0, 28), 
                    Position = UDim2.new(0.55, 0, 0.5, -14), 
                    ClearTextOnFocus = false
                }, {
                    Utility:Create("UICorner", {CornerRadius = UDim.new(0, 4)}), 
                    Utility:Create("UIStroke", {Color = Netro65UI.Theme.Outline, Thickness = 1})
                })
                
                table.insert(Netro65UI.ThemeObjects, {
                    Instance = Box, 
                    Type = "Main"
                })

                Box.Focused:Connect(function()
                    if Utility:CheckLock(TbFrame) then
                        Box:ReleaseFocus()
                    end
                end)

                Box.FocusLost:Connect(function()
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
            end

            -- [Keybind]
            function Section:AddKeybind(kbProps)
                local kbName = kbProps.Name or "Keybind"
                local default = kbProps.Default or Enum.KeyCode.F
                local flag = kbProps.Flag
                local callback = kbProps.Callback or function() end
                local currentKey = default

                local KbFrame = Utility:Create("Frame", {
                    Parent = ItemContainer,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0.94, 0, 0, 34)
                })
                
                table.insert(SearchableElements, {
                    Element = KbFrame,
                    Keywords = kbName
                })

                Utility:Create("TextLabel", {
                    Parent = KbFrame,
                    Text = kbName,
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
                    Size = UDim2.new(0, 80, 0, 25),
                    Position = UDim2.new(0.65, 0, 0.5, -12.5),
                    AutoButtonColor = false
                }, {
                    Utility:Create("UICorner", {CornerRadius = UDim.new(0, 4)}),
                    Utility:Create("UIStroke", {Color = Netro65UI.Theme.Outline, Thickness = 1})
                })

                local listening = false
                KeyButton.MouseButton1Click:Connect(function()
                    if Utility:CheckLock(KbFrame) then return end
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
            end

            -- [Color Picker]
            function Section:AddColorPicker(cpProps)
                local cpName = cpProps.Name or "Color Picker"
                local default = cpProps.Default or Color3.fromRGB(255, 255, 255)
                local flag = cpProps.Flag
                local callback = cpProps.Callback or function() end
                local currentColor = default

                local CpFrame = Utility:Create("Frame", {
                    Parent = ItemContainer,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0.94, 0, 0, 34)
                })
                
                table.insert(SearchableElements, {
                    Element = CpFrame,
                    Keywords = cpName
                })

                Utility:Create("TextLabel", {
                    Parent = CpFrame,
                    Text = cpName,
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
                    Size = UDim2.new(0, 80, 0, 25),
                    Position = UDim2.new(0.65, 0, 0.5, -12.5),
                    AutoButtonColor = false
                }, {
                    Utility:Create("UICorner", {CornerRadius = UDim.new(0, 4)}),
                    Utility:Create("UIStroke", {Color = Netro65UI.Theme.Outline, Thickness = 1})
                })

                ColorButton.MouseButton1Click:Connect(function()
                    if Utility:CheckLock(CpFrame) then return end
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
            end

            return Section
        end
        
        return Tab
    end

    -- // AUTO-GENERATE TAB: Players Info //
    local function GeneratePlayerInfo(parentPage)
        local function getCurrentTime()
            local date = os.date("*t")
            return ("%02d:%02d:%02d"):format(date.hour, date.min, date.sec)
        end

        local function getCurrentDate()
            local date = os.date("*t")
            local months = {"Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"}
            return ("%s %02d, %d"):format(months[date.month], date.day, date.year)
        end
        
        -- Use full width container directly to avoid Bento column issues
        local PlayerContainer = Utility:Create("Frame", {
            Parent = parentPage,
            Size = UDim2.new(0.98, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1
        }, {
             Utility:Create("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 10),
                HorizontalAlignment = Enum.HorizontalAlignment.Center
            })
        })

        -- [BAGIAN 1] Profile Card
        local ProfileCard = Utility:Create("Frame", {
            Parent = PlayerContainer,
            Size = UDim2.new(1, 0, 0, 85),
            BackgroundColor3 = Netro65UI.Theme.Secondary,
            BackgroundTransparency = 0.2,
            LayoutOrder = 1
        }, {
            Utility:Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
            Utility:Create("UIStroke", {Color = Color3.fromRGB(60, 60, 70), Thickness = 1}),
            Utility:Create("UIGradient", {Rotation = 45, Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.new(1,1,1)), 
                ColorSequenceKeypoint.new(1, Color3.fromRGB(150,150,150))
            }})
        })
        table.insert(Netro65UI.ThemeObjects, {Instance = ProfileCard, Type = "Secondary"})

        local InfoContainer = Utility:Create("Frame", {
            Parent = ProfileCard,
            Size = UDim2.new(1, -30, 1, -20),
            Position = UDim2.new(0, 15, 0, 15),
            BackgroundTransparency = 1
        }, {
            Utility:Create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 2)})
        })

        local function addTextLine(text, size, font, color, layoutOrder, parent)
            return Utility:Create("TextLabel", {
                Parent = parent,
                Size = UDim2.new(1, 0, 0, size + 4),
                BackgroundTransparency = 1,
                Text = text,
                TextSize = size,
                Font = font,
                TextColor3 = color,
                TextXAlignment = Enum.TextXAlignment.Left,
                LayoutOrder = layoutOrder
            })
        end

        addTextLine("Username: @" .. LocalPlayer.Name, 14, Netro65UI.Theme.FontBold, Color3.new(1,1,1), 1, InfoContainer)

        local IdRow = Utility:Create("Frame", {
            Parent = InfoContainer,
            Size = UDim2.new(1, 0, 0, 24),
            BackgroundTransparency = 1,
            LayoutOrder = 2
        }, {
            Utility:Create("UIListLayout", {
                FillDirection = Enum.FillDirection.Horizontal, 
                SortOrder = Enum.SortOrder.LayoutOrder, 
                Padding = UDim.new(0, 8), 
                VerticalAlignment = Enum.VerticalAlignment.Center
            })
        })

        Utility:Create("TextLabel", {
            Parent = IdRow,
            AutomaticSize = Enum.AutomaticSize.X,
            Size = UDim2.new(0, 0, 1, 0),
            BackgroundTransparency = 1,
            Text = "ID: " .. LocalPlayer.UserId,
            TextSize = 11,
            Font = Netro65UI.Theme.FontCode,
            TextColor3 = Color3.fromRGB(150,150,150),
            LayoutOrder = 1
        })

        local CopyBtn = Utility:Create("TextButton", {
            Parent = IdRow,
            Size = UDim2.new(0, 45, 0, 20),
            BackgroundColor3 = Color3.fromRGB(60,60,70),
            Text = "Copy",
            Font = Netro65UI.Theme.FontBold,
            TextSize = 10,
            TextColor3 = Color3.new(1,1,1),
            LayoutOrder = 3
        }, {
            Utility:Create("UICorner", {CornerRadius = UDim.new(0, 4)}),
            Utility:Create("UIStroke", {Color = Color3.fromRGB(90,90,100), Thickness = 1})
        })

        CopyBtn.MouseButton1Click:Connect(function()
            if setclipboard then
                setclipboard(tostring(LocalPlayer.UserId))
                local oldText = CopyBtn.Text
                CopyBtn.Text = "Copied"
                CopyBtn.BackgroundColor3 = Netro65UI.Theme.Success
                task.wait(1)
                CopyBtn.Text = oldText
                CopyBtn.BackgroundColor3 = Color3.fromRGB(60,60,70)
            end
        end)

        -- [BAGIAN 2] Stats Row
        local StatsRow = Utility:Create("Frame", {
            Parent = PlayerContainer,
            Size = UDim2.new(1, 0, 0, 55),
            BackgroundTransparency = 1,
            LayoutOrder = 2
        }, {
            Utility:Create("UIListLayout", {
                FillDirection = Enum.FillDirection.Horizontal,
                Padding = UDim.new(0.04, 0),
                HorizontalAlignment = Enum.HorizontalAlignment.Center
            })
        })

        local function createMiniCard(title, valueText, valueColor, isTimeCard)
            local card = Utility:Create("Frame", {
                Parent = StatsRow,
                Size = UDim2.new(0.48, 0, 1, 0),
                BackgroundColor3 = Netro65UI.Theme.Secondary,
                BackgroundTransparency = 0.2
            }, {
                Utility:Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
                Utility:Create("UIStroke", {Color = Color3.fromRGB(60,60,70), Thickness = 1}),
                Utility:Create("UIGradient", {Rotation = 45, Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.new(1,1,1)), 
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(150,150,150))
                }})
            })
            table.insert(Netro65UI.ThemeObjects, {Instance = card, Type = "Secondary"})

            Utility:Create("TextLabel", {
                Parent = card,
                Size = UDim2.new(1, -20, 0, 15),
                Position = UDim2.new(0, 10, 0, 5),
                BackgroundTransparency = 1,
                Text = title,
                Font = Netro65UI.Theme.FontBold,
                TextSize = 9,
                TextColor3 = Color3.fromRGB(150,150,150),
                TextXAlignment = Enum.TextXAlignment.Left
            })

            local v = Utility:Create("TextLabel", {
                Parent = card,
                Size = UDim2.new(1, -20, 0, 20),
                Position = UDim2.new(0, 10, 0.4, 0),
                BackgroundTransparency = 1,
                Text = valueText,
                Font = Netro65UI.Theme.FontBold,
                TextSize = 14,
                TextColor3 = valueColor,
                TextXAlignment = Enum.TextXAlignment.Left
            })

            if isTimeCard then
                table.insert(Netro65UI.ThemeObjects, {Instance = v, Type = "Accent", Property = "TextColor3"})
                v.Size = UDim2.new(0.5, -10, 0, 20)
                v.Position = UDim2.new(0.5, 5, 0.4, 0)
                v.TextXAlignment = Enum.TextXAlignment.Right

                Utility:Create("TextLabel", {
                    Name = "DateLabel",
                    Parent = card,
                    Size = UDim2.new(0.5, -10, 0, 20),
                    Position = UDim2.new(0, 10, 0.4, 0),
                    BackgroundTransparency = 1,
                    Text = getCurrentDate(),
                    Font = Netro65UI.Theme.FontCode,
                    TextSize = 11,
                    TextColor3 = Color3.fromRGB(200,200,200),
                    TextXAlignment = Enum.TextXAlignment.Left
                })
            end
            return v
        end

        local statusVal = Netro65UI.IsVIP and "VIP MEMBER" or "FREE USER"
        local statusCol = Netro65UI.IsVIP and Color3.fromRGB(255, 215, 0) or Color3.fromRGB(200, 200, 200)
        createMiniCard("ACCOUNT", statusVal, statusCol, false)

        local timeLabel = createMiniCard("LOCAL TIME", "00:00:00", Netro65UI.Theme.Accent, true)
        local dateLabel = timeLabel.Parent:FindFirstChild("DateLabel")

        spawn(function()
            while MainFrame.Parent do
                timeLabel.Text = getCurrentTime()
                if dateLabel then dateLabel.Text = getCurrentDate() end
                task.wait(1)
            end
        end)

        -- [BAGIAN 3] Marketing Card
        local MarketingCard = Utility:Create("Frame", {
            Parent = PlayerContainer,
            Size = UDim2.new(1, 0, 0, 115),
            BackgroundColor3 = Netro65UI.Theme.Secondary,
            BackgroundTransparency = 0.2,
            LayoutOrder = 3
        }, {
            Utility:Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
            Utility:Create("UIStroke", {Color = Netro65UI.Theme.Accent, Thickness = 1})
        })
        table.insert(Netro65UI.ThemeObjects, {Instance = MarketingCard, Type = "Secondary"})
        local mStroke = MarketingCard:FindFirstChild("UIStroke")
        if mStroke then
            table.insert(Netro65UI.ThemeObjects, {Instance = mStroke, Type = "Accent", Property = "Color"})
        end

        Utility:Create("ImageLabel", {
            Parent = MarketingCard,
            Size = UDim2.new(0, 25, 0, 25),
            Position = UDim2.new(0, 10, 0, 10),
            BackgroundTransparency = 1,
            Image = "rbxassetid://3926305904",
            ImageColor3 = Color3.fromRGB(255, 215, 0)
        })

        Utility:Create("TextLabel", {
            Parent = MarketingCard,
            Size = UDim2.new(1, -50, 0, 25),
            Position = UDim2.new(0, 40, 0, 10),
            BackgroundTransparency = 1,
            Text = "UNLOCK VIP POWER",
            TextColor3 = Color3.fromRGB(255, 215, 0),
            Font = Netro65UI.Theme.FontBlack,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left
        })

        Utility:Create("TextLabel", {
            Parent = MarketingCard,
            Size = UDim2.new(1, -20, 0, 40),
            Position = UDim2.new(0, 10, 0, 35),
            BackgroundTransparency = 1,
            Text = "Get exclusive access to premium scripts, faster updates, and priority support. Upgrade now to dominate the game!",
            TextColor3 = Color3.fromRGB(200, 200, 200),
            Font = Netro65UI.Theme.FontMain,
            TextSize = 11,
            TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top
        })

        local UpgradeBtn = Utility:Create("TextButton", {
            Parent = MarketingCard,
            Size = UDim2.new(1, -20, 0, 30),
            Position = UDim2.new(0, 10, 1, -40),
            BackgroundColor3 = Netro65UI.Theme.Accent,
            Text = finalUpgradeText, 
            TextColor3 = Color3.new(1,1,1),
            Font = Netro65UI.Theme.FontBold,
            TextSize = 12
        }, {
            Utility:Create("UICorner", {CornerRadius = UDim.new(0, 6)})
        })
        table.insert(Netro65UI.ThemeObjects, {Instance = UpgradeBtn, Type = "Accent", Property = "BackgroundColor3"})

        UpgradeBtn.MouseEnter:Connect(function()
            TweenService:Create(UpgradeBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0.2}):Play()
        end)
        UpgradeBtn.MouseLeave:Connect(function()
            TweenService:Create(UpgradeBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
        end)

        UpgradeBtn.MouseButton1Click:Connect(function()
            if setclipboard then
                setclipboard(finalUpgradeLink) 
                Netro65UI:Notify({Title="VIP Upgrade", Content="Purchase link copied!", Type="Success", Duration=3})
                UpgradeBtn.Text = "Link Copied!"
                task.wait(1)
                UpgradeBtn.Text = finalUpgradeText 
            end
        end)
    end
    
    local PlayersInfoTab = WindowObj:AddTab("Players Info", -9999)
    GeneratePlayerInfo(PlayersInfoTab.PageInstance)

    --// AUTO-GENERATE SETTINGS TAB
    local SettingsTab = WindowObj:AddTab("UI Settings", 99999)
    
    -- Using the "Left" and "Right" system now properly supported
    local ConfigSection = SettingsTab:AddSection("Configuration", "Left")
    
    local ConfigName = ""

    ConfigSection:AddTextbox({
        Name = "Config Name", 
        Placeholder = "Type name here...", 
        Callback = function(v) 
            ConfigName = v 
        end
    })
    
    ConfigSection:AddButton({
        Name = "Save Config", 
        Callback = function() 
            if ConfigName ~= "" then 
                Netro65UI:SaveConfig(ConfigName, false) 
            else 
                Netro65UI:Notify({
                    Title = "Error", 
                    Content = "Enter config name!", 
                    Type = "Error"
                }) 
            end 
        end
    })
    
    ConfigSection:AddDropdown({
        Name = "Load Config", 
        Items = Netro65UI:GetConfigs(false), 
        Callback = function(v) 
            ConfigName = v
            Netro65UI:LoadConfig(v, false) 
        end
    })

    ConfigSection:AddButton({
        Name = "Delete Config", 
        Callback = function() 
            if ConfigName ~= "" then 
                Netro65UI:DeleteConfig(ConfigName, false) 
            else 
                Netro65UI:Notify({
                    Title = "Error", 
                    Content = "Enter config name or select from load.", 
                    Type = "Error"
                }) 
            end 
        end
    })
    
    local ThemeSection = SettingsTab:AddSection("Theme Switcher", "Right")
    local ThemesList = {}
    
    for name, _ in pairs(Netro65UI.Presets) do 
        table.insert(ThemesList, name) 
    end
    
    table.sort(ThemesList)
    
    ThemeSection:AddDropdown({
        Name = "Select Theme", 
        Items = ThemesList, 
        Default = "Default",
        Callback = function(v) 
            Netro65UI:SetTheme(v) 
        end
    })
    
    ThemeSection:AddToggle({
        Name = "Rainbow Mode",
        Default = false,
        Callback = function(v)
            Netro65UI:ToggleRainbowMode(v, 1)
        end
    })
    
    ThemeSection:AddSlider({
        Name = "Rainbow Speed",
        Min = 0.1,
        Max = 5,
        Default = 1,
        Callback = function(v)
            if Netro65UI.RainbowMode.Enabled then
                Netro65UI:ToggleRainbowMode(true, v)
            end
        end
    })
    
    -- Demonstrate Normal Layout (Full Width) underneath split columns
    local UISettings = SettingsTab:AddSection("UI Effects", "Normal")
    
    UISettings:AddToggle({
        Name = "Acrylic Blur",
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
        Name = "Blur Intensity",
        Min = 1,
        Max = 50,
        Default = 15,
        Callback = function(v)
            Acrylic.BlurSize = v
            if Acrylic.Active then
                local Effect = Lighting:FindFirstChild("NetroAcrylicBlur")
                if Effect then Effect.Size = v end
            end
        end
    })
    
    Netro65UI:CreateKeybind("ToggleUI", Enum.KeyCode.RightControl, function()
        ToggleWindow(not isWindowVisible)
    end)
    
    return WindowObj
end

return Netro65UI
