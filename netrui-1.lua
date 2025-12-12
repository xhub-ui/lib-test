--[[
    Netro65UI - Professional Modular UI Library (Ultimate Revolution V4.5)
    Status: COMPLETE, MERGED & UPGRADED
    
    Merged Features:
    + Fixed Layouts (Headers, Spacing, Text Truncation) [From V3.9]
    + Robust Key System & Notification System [From V3.9]
    + Profile Card & Search Bar in Header [From V3.9]
    + Configuration System (Save/Load/AutoLoad) [From V4.0]
    + Searchable Dropdowns & Accordion Animation [From V4.0]
    + Dynamic Theme Switcher & Presets [From V4.0]
    + Automatic Settings Tab Generation [From V4.0]
]]

local Netro65UI = {}
Netro65UI.Flags = {}
Netro65UI.Setters = {} -- Registry for config updates
Netro65UI.ThemeObjects = {} -- Registry for realtime theme updates
Netro65UI.ConfigFolder = "Netro65UI_Configs"
Netro65UI.CurrentConfigFile = "default.json"
Netro65UI.Version = "4.5.0" 
Netro65UI.IsVIP = false 

--// Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")

--// Constants
local MOUSE = Players.LocalPlayer:GetMouse()
local LocalPlayer = Players.LocalPlayer

--// Theme System & Presets
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
}

function Netro65UI:SetTheme(presetName)
    local preset = Netro65UI.Presets[presetName] or Netro65UI.Presets.Default
    Netro65UI.Theme.Main = preset.Main
    Netro65UI.Theme.Accent = preset.Accent
    
    -- Update existing elements
    for _, obj in pairs(Netro65UI.ThemeObjects) do
        if obj.Instance and obj.Instance.Parent then
            if obj.Type == "Main" then obj.Instance.BackgroundColor3 = Netro65UI.Theme.Main end
            if obj.Type == "Accent" then 
                if obj.Property == "TextColor3" then 
                    obj.Instance.TextColor3 = Netro65UI.Theme.Accent 
                elseif obj.Property == "ImageColor3" then
                     obj.Instance.ImageColor3 = Netro65UI.Theme.Accent
                else 
                    obj.Instance.BackgroundColor3 = Netro65UI.Theme.Accent 
                end
            end
        end
    end
end

--// Acrylic Module
local Acrylic = { Active = true, BlurSize = 15 }

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
ScreenGui.Name = "Netro65UI_Ultimate_V4"
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

--// Utility Functions
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
    -- Placeholder for ToolTip logic
end

--// Notification System (From V3.9 - Better Layout)
local NotificationContainer = Utility:Create("Frame", {
    Name = "Notifications",
    Parent = ScreenGui,
    BackgroundTransparency = 1,
    Position = UDim2.new(1, -280, 0, 30),
    Size = UDim2.new(0, 260, 1, -30),
    ZIndex = 500
}, {
    Utility:Create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder, 
        Padding = UDim.new(0, 8), 
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
            Text = title, Font = Netro65UI.Theme.FontBold, TextSize = 14, 
            TextColor3 = Netro65UI.Theme.Text, BackgroundTransparency = 1, 
            Position = UDim2.new(0, 12, 0, 8), Size = UDim2.new(1, -24, 0, 18), 
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd
        }),
        Utility:Create("TextLabel", {
            Text = content, Font = Netro65UI.Theme.FontMain, TextSize = 12, 
            TextColor3 = Netro65UI.Theme.TextDark, BackgroundTransparency = 1, 
            Position = UDim2.new(0, 12, 0, 28), Size = UDim2.new(1, -24, 1, -32), 
            TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true, TextYAlignment = Enum.TextYAlignment.Top
        }),
        Utility:Create("Frame", {
            Name = "Timer", BackgroundColor3 = typeColor, 
            Size = UDim2.new(1, 0, 0, 3), Position = UDim2.new(0, 0, 1, -3), 
            BorderSizePixel = 0
        })
    })

    Utility:Tween(NotifFrame, {0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out}, {Size = UDim2.new(1, 0, 0, 75)})
    Utility:Tween(NotifFrame.Timer, {duration, Enum.EasingStyle.Linear}, {Size = UDim2.new(0, 0, 0, 3)})
    
    task.delay(duration, function() 
        if NotifFrame then 
            Utility:Tween(NotifFrame, {0.3}, {Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1}) 
            wait(0.3) 
            NotifFrame:Destroy() 
        end 
    end)
end

--// Config System Logic (From V4.0)
function Netro65UI:SaveConfig(name, isUniversal)
    local folder = Netro65UI.ConfigFolder
    if not isfolder(folder) then makefolder(folder) end
    
    local path = folder .. "/" .. (isUniversal and "Universal" or tostring(game.PlaceId))
    if not isfolder(path) then makefolder(path) end
    
    local success, err = pcall(function()
        writefile(path .. "/" .. name .. ".json", HttpService:JSONEncode(Netro65UI.Flags))
    end)
    
    if success then Netro65UI:Notify({Title = "Config Saved", Content = "Saved: " .. name, Type = "Success"})
    else Netro65UI:Notify({Title = "Save Failed", Content = err, Type = "Error"}) end
end

function Netro65UI:LoadConfig(name, isUniversal)
    local path = Netro65UI.ConfigFolder .. "/" .. (isUniversal and "Universal" or tostring(game.PlaceId)) .. "/" .. name .. ".json"
    if not isfile(path) then 
        Netro65UI:Notify({Title = "Error", Content = "Config file not found.", Type = "Error"}) 
        return 
    end

    local success, content = pcall(function() return readfile(path) end)
    if success then
        local data = HttpService:JSONDecode(content)
        for flag, value in pairs(data) do
            Netro65UI.Flags[flag] = value
            if Netro65UI.Setters and Netro65UI.Setters[flag] then
                Netro65UI.Setters[flag](value)
            end
        end
        Netro65UI:Notify({Title = "Config Loaded", Content = "Loaded: " .. name, Type = "Success"})
    else
        Netro65UI:Notify({Title = "Load Failed", Content = "Corrupted JSON.", Type = "Error"})
    end
end

function Netro65UI:DeleteConfig(name, isUniversal)
    local path = Netro65UI.ConfigFolder .. "/" .. (isUniversal and "Universal" or tostring(game.PlaceId)) .. "/" .. name .. ".json"
    if isfile(path) then
        delfile(path)
        Netro65UI:Notify({Title = "Deleted", Content = "Config deleted successfully.", Type = "Success"})
    else
        Netro65UI:Notify({Title = "Error", Content = "File does not exist.", Type = "Error"})
    end
end

function Netro65UI:GetConfigs(isUniversal)
    local path = Netro65UI.ConfigFolder .. "/" .. (isUniversal and "Universal" or tostring(game.PlaceId))
    if not isfolder(path) then return {} end
    local files = listfiles(path)
    local names = {}
    for _, file in pairs(files) do
        local name = file:match("([^/\\]+)%.json$")
        if name then table.insert(names, name) end
    end
    return names
end

--// Internal Utils
local function CheckIDInList(content, userId)
    local idString = tostring(userId)
    local found = false
    if content:match("^%s*%[") or content:match("^%s*{") then
        local success, json = pcall(function() return HttpService:JSONDecode(content) end)
        if success and type(json) == "table" then
            for _, v in pairs(json) do
                if tostring(v) == idString then found = true break end
            end
        end
    else
        for line in content:gmatch("[^%s,]+") do
            if line == idString then found = true break end
        end
    end
    return found
end

--// Key System (From V3.9 - Complete)
function Netro65UI:TriggerKeySystem(settings, onComplete)
    local KeySettings = {
        KeyURL = settings.KeyURL or "",
        GetKeyLink = settings.KeyLink or "https://google.com",
        Title = settings.Title or "Key System",
        Subtitle = "Support us by getting a key!",
        Callback = onComplete or function() end
    }

    local KeyFrame = Utility:Create("Frame", {
        Name = "KeySystem", Parent = ScreenGui, BackgroundColor3 = Netro65UI.Theme.Main,
        Size = UDim2.new(0, 400, 0, 240), 
        Position = UDim2.new(0.5, -200, 0.5, -120),
        BorderSizePixel = 0, ZIndex = 2000, BackgroundTransparency = 0.05
    }, {
        Utility:Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
        Utility:Create("UIStroke", {Color = Netro65UI.Theme.Outline, Thickness = 2}),
        -- Header
        Utility:Create("TextLabel", {
            Text = KeySettings.Title, Font = Netro65UI.Theme.FontBold, TextSize = 22, 
            TextColor3 = Netro65UI.Theme.Text, BackgroundTransparency = 1, 
            Size = UDim2.new(1, -40, 0, 30), Position = UDim2.new(0, 20, 0, 15), 
            TextXAlignment = Enum.TextXAlignment.Left
        }),
        Utility:Create("TextLabel", {
            Text = KeySettings.Subtitle, Font = Netro65UI.Theme.FontMain, TextSize = 14, 
            TextColor3 = Netro65UI.Theme.TextDark, BackgroundTransparency = 1, 
            Size = UDim2.new(1, -40, 0, 20), Position = UDim2.new(0, 20, 0, 50),
            TextXAlignment = Enum.TextXAlignment.Left
        }),
        -- Close Button
        Utility:Create("TextButton", {
            Text = "X", Font = Netro65UI.Theme.FontBold, TextSize = 16, 
            TextColor3 = Netro65UI.Theme.Error, BackgroundTransparency = 1, 
            Size = UDim2.new(0, 40, 0, 40), Position = UDim2.new(1, -40, 0, 5), Name = "CloseBtn"
        })
    })

    local InputBox = Utility:Create("TextBox", {
        Parent = KeyFrame, BackgroundColor3 = Netro65UI.Theme.Secondary,
        Size = UDim2.new(0.9, 0, 0, 45), Position = UDim2.new(0.05, 0, 0, 90),
        Font = Netro65UI.Theme.FontMain, TextSize = 14, TextColor3 = Netro65UI.Theme.Text,
        PlaceholderText = "Paste Key Here...", PlaceholderColor3 = Netro65UI.Theme.TextDark,
        Text = "", ClearTextOnFocus = false, TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Center
    }, {
        Utility:Create("UICorner", {CornerRadius = UDim.new(0, 6)}),
        Utility:Create("UIStroke", {Color = Netro65UI.Theme.Outline, Thickness = 1})
    })

    local BtnContainer = Utility:Create("Frame", {
        Parent = KeyFrame, BackgroundTransparency = 1, 
        Size = UDim2.new(0.9, 0, 0, 40), Position = UDim2.new(0.05, 0, 0, 160)
    })
    
    local ConfirmBtn = Utility:Create("TextButton", {
        Parent = BtnContainer, Text = "Verify Key", Font = Netro65UI.Theme.FontBold, TextSize = 14, 
        TextColor3 = Netro65UI.Theme.Main, BackgroundColor3 = Netro65UI.Theme.Success, 
        Size = UDim2.new(0.48, 0, 1, 0), Position = UDim2.new(0, 0, 0, 0), AutoButtonColor = false
    }, {Utility:Create("UICorner", {CornerRadius = UDim.new(0, 6)})})

    local GetKeyBtn = Utility:Create("TextButton", {
        Parent = BtnContainer, Text = "Get Key Link", Font = Netro65UI.Theme.FontBold, TextSize = 14, 
        TextColor3 = Netro65UI.Theme.Text, BackgroundColor3 = Netro65UI.Theme.Secondary, 
        Size = UDim2.new(0.48, 0, 1, 0), Position = UDim2.new(0.52, 0, 0, 0), AutoButtonColor = false
    }, {Utility:Create("UICorner", {CornerRadius = UDim.new(0, 6)}), Utility:Create("UIStroke", {Color = Netro65UI.Theme.Outline, Thickness = 1})})

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
            Netro65UI:Notify({Title = "Copied", Content = "Key link copied to clipboard!", Type = "Success"})
        else
            Netro65UI:Notify({Title = "Error", Content = "Your executor doesn't support setclipboard.", Type = "Error"})
        end
    end)

    ConfirmBtn.MouseButton1Click:Connect(function()
        Utility:Ripple(ConfirmBtn)
        local inputKey = InputBox.Text
        if inputKey:gsub(" ", "") == "" then return end
        
        ConfirmBtn.Text = "Checking..."
        
        local success, response = pcall(function() return game:HttpGet(KeySettings.KeyURL) end)
        if not success then
            Netro65UI:Notify({Title = "Connection Error", Content = "Failed to fetch valid keys.", Type = "Error"})
            ConfirmBtn.Text = "Verify Key"
            return
        end

        local isValid = CheckIDInList(response, inputKey)

        if isValid then
            Netro65UI:Notify({Title = "Success", Content = "Key Verified! Loading UI...", Type = "Success"})
            Utility:Tween(KeyFrame, {0.3}, {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1})
            task.wait(0.3)
            Acrylic:Disable()
            KeyFrame:Destroy()
            KeySettings.Callback()
        else
            Netro65UI:Notify({Title = "Invalid", Content = "The key you entered is incorrect.", Type = "Error"})
            ConfirmBtn.Text = "Verify Key"
            InputBox.Text = ""
        end
    end)
end

--// System Loader
function Netro65UI:Load(config)
    local vipUrl = config.VIPUrl
    local useKeySystem = config.KeySystem
    local finalCallback = config.OnLoad or function() warn("No OnLoad callback provided!") end

    Netro65UI:Notify({Title = "System", Content = "Checking access...", Duration = 2})

    spawn(function()
        local isUserVIP = false
        if vipUrl then
            local success, res = pcall(function() return game:HttpGet(vipUrl) end)
            if success then isUserVIP = CheckIDInList(res, LocalPlayer.UserId) end
        end
        Netro65UI.IsVIP = isUserVIP

        if isUserVIP then
            Netro65UI:Notify({Title = "VIP Access", Content = "Welcome back, VIP User!", Type = "Success", Duration = 5})
            finalCallback()
        else
            if useKeySystem then
                Netro65UI:Notify({Title = "Access Required", Content = "You are not VIP. Key System required.", Type = "Warning"})
                wait(1)
                Netro65UI:TriggerKeySystem(config.KeySettings, finalCallback)
            else
                finalCallback()
            end
        end
    end)
end

--// Locking System (From V3.9)
function Utility:LockElement(instance, text, reasonType)
    if instance:FindFirstChild("LockOverlay") then instance.LockOverlay:Destroy() end

    local lockColor = Color3.fromRGB(200, 200, 200)
    if reasonType == "Error" then lockColor = Netro65UI.Theme.Error end
    if reasonType == "VIP" then lockColor = Color3.fromRGB(255, 215, 0) end
    if reasonType == "Update" then lockColor = Netro65UI.Theme.Accent end

    local Overlay = Utility:Create("Frame", {
        Name = "LockOverlay", Parent = instance,
        BackgroundColor3 = Color3.fromRGB(10, 10, 10), BackgroundTransparency = 0.2,
        Size = UDim2.new(1, 0, 1, 0), ZIndex = 100, Active = true
    }, {
        Utility:Create("UICorner", {CornerRadius = UDim.new(0, 6)}),
        Utility:Create("ImageLabel", {
            Image = "rbxassetid://3926305904", ImageRectOffset = Vector2.new(364, 284), ImageRectSize = Vector2.new(36, 36),
            BackgroundTransparency = 1, Size = UDim2.new(0, 24, 0, 24),
            Position = UDim2.new(0.5, -12, 0.5, -12), ImageColor3 = lockColor, ZIndex = 101
        }),
        Utility:Create("TextLabel", {
            Text = text or "Locked", Font = Netro65UI.Theme.FontBold, TextSize = 10,
            TextColor3 = lockColor, BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 20), Position = UDim2.new(0, 0, 0.5, 10), ZIndex = 101
        })
    })
end

function Utility:UnlockElement(instance)
    if instance:FindFirstChild("LockOverlay") then
        instance.LockOverlay:Destroy()
    end
end

--// ------------------------------
--// MAIN WINDOW SYSTEM (Hybrid V3.9 + V4.0)
--// ------------------------------

function Netro65UI:CreateWindow(props)
    local WindowObj = {}
    props = props or {}
    local windowWidth = props.Width or 550
    local windowHeight = props.Height or 350
    local titleText = props.Title or "Netro65UI"
    Acrylic:Enable()

    local MainFrame = Utility:Create("Frame", {
        Name = "MainWindow", Parent = ScreenGui, 
        BackgroundColor3 = Netro65UI.Theme.Main, 
        Position = UDim2.new(0.5, -windowWidth/2, 0.5, -windowHeight/2), 
        Size = UDim2.fromOffset(windowWidth, windowHeight), 
        BorderSizePixel = 0, BackgroundTransparency = 0.05
    }, {
        Utility:Create("UICorner", {CornerRadius = UDim.new(0, 6)}), 
        Utility:Create("UIStroke", {Color = Netro65UI.Theme.Outline, Thickness = 1.5})
    })
    table.insert(Netro65UI.ThemeObjects, {Instance = MainFrame, Type = "Main"})

    local Header = Utility:Create("Frame", {
        Name = "Header", Parent = MainFrame, 
        BackgroundColor3 = Netro65UI.Theme.Secondary, 
        Size = UDim2.new(1, 0, 0, 45), BorderSizePixel = 0, BackgroundTransparency = 0.5
    }, {
        Utility:Create("UICorner", {CornerRadius = UDim.new(0, 6)}),
        Utility:Create("Frame", {
            BackgroundColor3 = Netro65UI.Theme.Secondary, 
            Size = UDim2.new(1, 0, 0, 10), Position = UDim2.new(0, 0, 1, -10), 
            BorderSizePixel = 0, BackgroundTransparency = 0.5
        }),
        Utility:Create("TextLabel", {
            Text = titleText, Font = Netro65UI.Theme.FontBold, TextSize = 16, 
            TextColor3 = Netro65UI.Theme.Text, BackgroundTransparency = 1, 
            Size = UDim2.new(0, 180, 1, 0), Position = UDim2.new(0, 15, 0, 0), 
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd 
        }),
        Utility:Create("TextLabel", {
            Text = "v"..Netro65UI.Version, Font = Netro65UI.Theme.FontMain, TextSize = 11, 
            TextColor3 = Netro65UI.Theme.Accent, BackgroundTransparency = 1, 
            Size = UDim2.new(0, 40, 1, 0), Position = UDim2.new(0, 200, 0, 0), 
            TextXAlignment = Enum.TextXAlignment.Left
        })
    })
    table.insert(Netro65UI.ThemeObjects, {Instance = Header.TextLabel, Type = "Accent", Property = "TextColor3"}) -- Version label
    Utility:MakeDraggable(MainFrame, Header)

    -- Search Bar (V3.9)
    local SearchBar = Utility:Create("Frame", {
        Parent = Header, BackgroundColor3 = Netro65UI.Theme.Main, 
        Size = UDim2.new(0, 160, 0, 28), Position = UDim2.new(1, -225, 0.5, -14), 
        BackgroundTransparency = 0.5
    }, {
        Utility:Create("UICorner", {CornerRadius = UDim.new(0, 5)}), 
        Utility:Create("UIStroke", {Color = Netro65UI.Theme.Outline, Thickness = 1}), 
        Utility:Create("ImageLabel", {
            Image = "rbxassetid://5036549785", BackgroundTransparency = 1, 
            Size = UDim2.new(0, 14, 0, 14), Position = UDim2.new(0, 8, 0.5, -7), 
            ImageColor3 = Netro65UI.Theme.TextDark
        })
    })
    table.insert(Netro65UI.ThemeObjects, {Instance = SearchBar, Type = "Main"})
    
    local SearchInput = Utility:Create("TextBox", {
        Parent = SearchBar, BackgroundTransparency = 1, 
        Size = UDim2.new(1, -30, 1, 0), Position = UDim2.new(0, 28, 0, 0), 
        Font = Netro65UI.Theme.FontMain, TextSize = 13, 
        TextColor3 = Netro65UI.Theme.Text, PlaceholderText = "Search...", 
        PlaceholderColor3 = Netro65UI.Theme.TextDark, TextXAlignment = Enum.TextXAlignment.Left
    })

    local CloseBtn = Utility:Create("TextButton", {
        Parent = Header, Text = "", BackgroundColor3 = Color3.fromRGB(255, 80, 80), 
        Size = UDim2.new(0, 12, 0, 12), Position = UDim2.new(1, -25, 0, 17), AutoButtonColor = false
    }, {Utility:Create("UICorner", {CornerRadius = UDim.new(1,0)})})
    
    local MinBtn = Utility:Create("TextButton", {
        Parent = Header, Text = "", BackgroundColor3 = Color3.fromRGB(255, 200, 80), 
        Size = UDim2.new(0, 12, 0, 12), Position = UDim2.new(1, -45, 0, 17), AutoButtonColor = false
    }, {Utility:Create("UICorner", {CornerRadius = UDim.new(1,0)})})

    CloseBtn.MouseButton1Click:Connect(function() 
        Acrylic:Disable() 
        Utility:Tween(MainFrame, {0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In}, {Size = UDim2.new(0,0,0,0)}) 
        wait(0.3) 
        ScreenGui:Destroy() 
    end)
    
    local IsMin = false
    MinBtn.MouseButton1Click:Connect(function() 
        IsMin = not IsMin 
        if IsMin then 
            Utility:Tween(MainFrame, {0.4}, {Size = UDim2.new(0, windowWidth, 0, 45)}) 
            MainFrame.Content.Visible = false 
        else 
            MainFrame.Content.Visible = true 
            Utility:Tween(MainFrame, {0.4}, {Size = UDim2.new(0, windowWidth, 0, windowHeight)}) 
        end 
    end)

    local ContentContainer = Utility:Create("Frame", {
        Name = "Content", Parent = MainFrame, BackgroundTransparency = 1, 
        Position = UDim2.new(0, 0, 0, 45), Size = UDim2.new(1, 0, 1, -45), ClipsDescendants = true
    })
    
    local NavWidth = 150 
    local NavContainer = Utility:Create("ScrollingFrame", {
        Name = "Navigation", Parent = ContentContainer, BackgroundTransparency = 1, 
        Size = UDim2.new(0, NavWidth, 1, -65), Position = UDim2.new(0, 0, 0, 10), 
        ScrollBarThickness = 0, CanvasSize = UDim2.new(0,0,0,0)
    }, {
        Utility:Create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 6)}), 
        Utility:Create("UIPadding", {PaddingLeft = UDim.new(0, 10), PaddingTop = UDim.new(0, 5)})
    })
    
    Utility:Create("Frame", {
        Parent = ContentContainer, BackgroundColor3 = Netro65UI.Theme.Outline, 
        Size = UDim2.new(0, 1, 1, -20), Position = UDim2.new(0, NavWidth, 0, 10), 
        BorderSizePixel = 0
    })

    -- Profile Card (V3.9)
    local ProfileCard = Utility:Create("Frame", {
        Parent = ContentContainer, BackgroundColor3 = Netro65UI.Theme.Secondary, 
        Size = UDim2.new(0, NavWidth - 20, 0, 45), Position = UDim2.new(0, 10, 1, -50), 
        BorderSizePixel = 0, BackgroundTransparency = 0.3
    }, {
        Utility:Create("UICorner", {CornerRadius = UDim.new(0, 6)}), 
        Utility:Create("UIStroke", {Color = Netro65UI.Theme.Outline, Thickness = 1}), 
        Utility:Create("ImageLabel", {
            Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48), 
            Size = UDim2.new(0, 32, 0, 32), Position = UDim2.new(0, 6, 0.5, -16), 
            BackgroundColor3 = Netro65UI.Theme.Main
        }, {Utility:Create("UICorner", {CornerRadius = UDim.new(1, 0)})}), 
        
        Utility:Create("TextLabel", {
            Text = LocalPlayer.DisplayName, Font = Netro65UI.Theme.FontBold, TextSize = 12, 
            TextColor3 = Netro65UI.Theme.Text, BackgroundTransparency = 1, 
            Position = UDim2.new(0, 46, 0, 8), Size = UDim2.new(1, -50, 0, 14), 
            TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd
        }), 
        Utility:Create("TextLabel", {
            Text = Netro65UI.IsVIP and "VIP User" or "Free User", 
            Font = Netro65UI.Theme.FontMain, TextSize = 10, 
            TextColor3 = Netro65UI.Theme.Accent, BackgroundTransparency = 1, 
            Position = UDim2.new(0, 46, 0, 24), Size = UDim2.new(1, -50, 0, 12), 
            TextXAlignment = Enum.TextXAlignment.Left
        })
    })
    table.insert(Netro65UI.ThemeObjects, {Instance = ProfileCard.ImageLabel, Type = "Main"})
    if not Netro65UI.IsVIP then
        table.insert(Netro65UI.ThemeObjects, {Instance = ProfileCard:WaitForChild("TextLabel"), Type = "Accent", Property = "TextColor3"})
    else
        ProfileCard:WaitForChild("TextLabel").TextColor3 = Color3.fromRGB(255, 215, 0)
    end

    local Pages = Utility:Create("Frame", {
        Name = "Pages", Parent = ContentContainer, BackgroundTransparency = 1, 
        Position = UDim2.new(0, NavWidth + 10, 0, 0), Size = UDim2.new(1, -(NavWidth + 10), 1, 0), 
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
    function WindowObj:AddTab(name)
        local Tab = {}
        local TabBtn = Utility:Create("TextButton", {
            Parent = NavContainer, Text = name, Font = Netro65UI.Theme.FontMain, TextSize = 13, 
            TextColor3 = Netro65UI.Theme.TextDark, BackgroundColor3 = Netro65UI.Theme.Main, 
            BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 34), 
            AutoButtonColor = false, TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd
        }, {
            Utility:Create("UIPadding", {PaddingLeft = UDim.new(0, 10)}), 
            Utility:Create("UICorner", {CornerRadius = UDim.new(0, 5)}), 
            Utility:Create("ImageLabel", {
                Name = "ActiveBar", BackgroundColor3 = Netro65UI.Theme.Accent, 
                Size = UDim2.new(0, 3, 0, 18), Position = UDim2.new(0, -10, 0.5, -9), Visible = false
            }, {Utility:Create("UICorner", {CornerRadius = UDim.new(0, 2)})})
        })
        table.insert(Netro65UI.ThemeObjects, {Instance = TabBtn.ActiveBar, Type = "Accent"})
        
        local Page = Utility:Create("ScrollingFrame", {
            Name = name.."_Page", Parent = Pages, BackgroundTransparency = 1, 
            Size = UDim2.new(1, 0, 1, 0), Visible = false, ScrollBarThickness = 3, 
            ScrollBarImageColor3 = Netro65UI.Theme.Accent, CanvasSize = UDim2.new(0,0,0,0)
        }, {
            Utility:Create("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 12), 
                HorizontalAlignment = Enum.HorizontalAlignment.Center
            }), 
            Utility:Create("UIPadding", {
                PaddingTop = UDim.new(0, 15), PaddingBottom = UDim.new(0, 15), PaddingRight = UDim.new(0, 5)
            })
        })
        table.insert(Netro65UI.ThemeObjects, {Instance = Page, Type = "Accent", Property = "ScrollBarImageColor3"})
        
        Page.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() 
            Page.CanvasSize = UDim2.new(0, 0, 0, Page.UIListLayout.AbsoluteContentSize.Y + 30) 
        end)
        
        TabBtn.MouseButton1Click:Connect(function() 
            if TabBtn:FindFirstChild("LockOverlay") then return end
            for _, t in pairs(tabs) do 
                t.Btn.ActiveBar.Visible = false 
                Utility:Tween(t.Btn, {0.2}, {BackgroundTransparency = 1, TextColor3 = Netro65UI.Theme.TextDark}) 
                t.Page.Visible = false 
            end 
            TabBtn.ActiveBar.Visible = true 
            Utility:Tween(TabBtn, {0.2}, {BackgroundTransparency = 0.92, BackgroundColor3 = Netro65UI.Theme.Accent, TextColor3 = Netro65UI.Theme.Text}) 
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

        function Tab:Lock(text, reason) Utility:LockElement(TabBtn, text, reason) end
        function Tab:Unlock() Utility:UnlockElement(TabBtn) end

        function Tab:AddSection(sectionName)
            local Section = {}
            local SectionFrame = Utility:Create("Frame", {
                Parent = Page, BackgroundColor3 = Netro65UI.Theme.Secondary, 
                Size = UDim2.new(0.96, 0, 0, 0), BorderSizePixel = 0, BackgroundTransparency = 0.5
            }, {
                Utility:Create("UICorner", {CornerRadius = UDim.new(0, 6)}), 
                Utility:Create("UIStroke", {Color = Netro65UI.Theme.Outline, Thickness = 1}), 
                Utility:Create("TextLabel", {
                    Text = sectionName, Font = Netro65UI.Theme.FontBold, TextSize = 13, 
                    TextColor3 = Netro65UI.Theme.Accent, BackgroundTransparency = 1, 
                    Size = UDim2.new(1, -20, 0, 32), Position = UDim2.new(0, 12, 0, 0), 
                    TextXAlignment = Enum.TextXAlignment.Left
                }), 
                Utility:Create("Frame", {
                    Name = "Container", BackgroundTransparency = 1, 
                    Position = UDim2.new(0, 0, 0, 32), Size = UDim2.new(1, 0, 0, 0)
                }, {
                    Utility:Create("UIListLayout", {
                        SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 8), 
                        HorizontalAlignment = Enum.HorizontalAlignment.Center
                    }), 
                    Utility:Create("UIPadding", {PaddingBottom = UDim.new(0, 12)})
                })
            })
            table.insert(Netro65UI.ThemeObjects, {Instance = SectionFrame.TextLabel, Type = "Accent", Property = "TextColor3"})
            
            local ItemContainer = SectionFrame.Container
            ItemContainer.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() 
                SectionFrame.Size = UDim2.new(0.96, 0, 0, ItemContainer.UIListLayout.AbsoluteContentSize.Y + 45) 
            end)

            -- [Button]
            function Section:AddButton(bProps)
                local btnObj = {}
                local btnText = bProps.Name or "Button"
                local callback = bProps.Callback or function() end
                
                local Button = Utility:Create("TextButton", {
                    Parent = ItemContainer, Text = btnText, Font = Netro65UI.Theme.FontMain, 
                    TextSize = 13, TextColor3 = Netro65UI.Theme.Text, 
                    BackgroundColor3 = Netro65UI.Theme.Main, Size = UDim2.new(0.94, 0, 0, 34),
                    AutoButtonColor = false, BorderSizePixel = 0
                }, {
                    Utility:Create("UICorner", {CornerRadius = UDim.new(0, 4)}), 
                    Utility:Create("UIStroke", {Color = Netro65UI.Theme.Outline, Thickness = 1})
                })
                table.insert(Netro65UI.ThemeObjects, {Instance = Button, Type = "Main"})
                
                if bProps.Info then Utility:AddToolTip(Button, bProps.Info) end 
                table.insert(SearchableElements, {Element = Button, Keywords = btnText})
                
                Button.MouseButton1Click:Connect(function() 
                    if Button:FindFirstChild("LockOverlay") then return end
                    Utility:Ripple(Button) 
                    callback() 
                end)
                
                Button.MouseEnter:Connect(function() Utility:Tween(Button, {0.2}, {BackgroundColor3 = Netro65UI.Theme.Hover}) end)
                Button.MouseLeave:Connect(function() Utility:Tween(Button, {0.2}, {BackgroundColor3 = Netro65UI.Theme.Main}) end)
                
                function btnObj:Lock(text, reason) Utility:LockElement(Button, text, reason) end
                function btnObj:Unlock() Utility:UnlockElement(Button) end
                return btnObj
            end

            -- [Toggle]
            function Section:AddToggle(tProps)
                local togObj = {}
                local tName = tProps.Name or "Toggle"
                local state = tProps.Default or false 
                local flag = tProps.Flag
                local callback = tProps.Callback or function() end
                
                if flag and Netro65UI.Flags[flag] ~= nil then state = Netro65UI.Flags[flag] end
                
                local ToggleFrame = Utility:Create("Frame", {
                    Parent = ItemContainer, BackgroundTransparency = 1, Size = UDim2.new(0.94, 0, 0, 34)
                })
                
                Utility:Create("TextLabel", {
                    Parent = ToggleFrame, Text = tName, Font = Netro65UI.Theme.FontMain, 
                    TextSize = 13, TextColor3 = Netro65UI.Theme.Text, BackgroundTransparency = 1, 
                    Size = UDim2.new(1, -55, 1, 0), Position = UDim2.new(0, 0, 0, 0),
                    TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd
                })
                
                local Switch = Utility:Create("TextButton", {
                    Parent = ToggleFrame, Text = "", 
                    BackgroundColor3 = state and Netro65UI.Theme.Accent or Netro65UI.Theme.Main, 
                    Size = UDim2.new(0, 42, 0, 22), Position = UDim2.new(1, -42, 0.5, -11), 
                    AutoButtonColor = false
                }, {
                    Utility:Create("UICorner", {CornerRadius = UDim.new(1, 0)}), 
                    Utility:Create("UIStroke", {Color = Netro65UI.Theme.Outline, Thickness = 1})
                })
                
                local Knob = Utility:Create("Frame", {
                    Parent = Switch, BackgroundColor3 = Color3.new(1,1,1), Size = UDim2.new(0, 18, 0, 18), 
                    Position = state and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
                }, {Utility:Create("UICorner", {CornerRadius = UDim.new(1, 0)})})
                
                table.insert(SearchableElements, {Element = ToggleFrame, Keywords = tName})
                
                local function Update(val) 
                    state = val 
                    Utility:Tween(Knob, {0.2}, {Position = state and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)}) 
                    Utility:Tween(Switch, {0.2}, {BackgroundColor3 = state and Netro65UI.Theme.Accent or Netro65UI.Theme.Main}) 
                    if flag then Netro65UI.Flags[flag] = state end 
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
                -- Initial visual update without callback loop (handled manually above)
                Knob.Position = state and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
                Switch.BackgroundColor3 = state and Netro65UI.Theme.Accent or Netro65UI.Theme.Main
                callback(state)

                function togObj:Lock(text, reason) Utility:LockElement(ToggleFrame, text, reason) end
                function togObj:Unlock() Utility:UnlockElement(ToggleFrame) end
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
                
                if flag and Netro65UI.Flags[flag] ~= nil then value = Netro65UI.Flags[flag] end
                
                local SliderFrame = Utility:Create("Frame", {
                    Parent = ItemContainer, BackgroundTransparency = 1, Size = UDim2.new(0.94, 0, 0, 50)
                })
                
                Utility:Create("TextLabel", {
                    Parent = SliderFrame, Text = sName, Font = Netro65UI.Theme.FontMain, 
                    TextSize = 13, TextColor3 = Netro65UI.Theme.Text, BackgroundTransparency = 1, 
                    Size = UDim2.new(1, -50, 0, 20), TextXAlignment = Enum.TextXAlignment.Left,
                    TextTruncate = Enum.TextTruncate.AtEnd
                })
                
                local ValueBox = Utility:Create("TextBox", {
                    Parent = SliderFrame, Text = tostring(value), Font = Netro65UI.Theme.FontBold, 
                    TextSize = 13, TextColor3 = Netro65UI.Theme.Accent, BackgroundTransparency = 1, 
                    Size = UDim2.new(0, 40, 0, 20), Position = UDim2.new(1, -40, 0, 0), 
                    TextXAlignment = Enum.TextXAlignment.Right, ClearTextOnFocus = false
                })
                table.insert(Netro65UI.ThemeObjects, {Instance = ValueBox, Type = "Accent", Property = "TextColor3"})
                
                local Track = Utility:Create("Frame", {
                    Parent = SliderFrame, BackgroundColor3 = Netro65UI.Theme.Main, 
                    Size = UDim2.new(1, 0, 0, 6), Position = UDim2.new(0, 0, 0, 32)
                }, {
                    Utility:Create("UICorner", {CornerRadius = UDim.new(1, 0)}), 
                    Utility:Create("UIStroke", {Color = Netro65UI.Theme.Outline, Thickness = 1})
                })
                table.insert(Netro65UI.ThemeObjects, {Instance = Track, Type = "Main"})
                
                local Fill = Utility:Create("Frame", {
                    Parent = Track, BackgroundColor3 = Netro65UI.Theme.Accent, 
                    Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
                }, {Utility:Create("UICorner", {CornerRadius = UDim.new(1, 0)})})
                table.insert(Netro65UI.ThemeObjects, {Instance = Fill, Type = "Accent"})
                
                local Hitbox = Utility:Create("TextButton", {
                    Parent = SliderFrame, BackgroundTransparency = 1, Text = "", 
                    Size = UDim2.new(1, 0, 0, 24), Position = UDim2.new(0, 0, 0, 24), ZIndex = 5
                })
                
                table.insert(SearchableElements, {Element = SliderFrame, Keywords = sName})
                
                local function UpdateSlider(inputVal)
                    value = math.clamp(inputVal, min, max)
                    ValueBox.Text = tostring(value)
                    Utility:Tween(Fill, {0.05}, {Size = UDim2.new((value - min) / (max - min), 0, 1, 0)})
                    if flag then Netro65UI.Flags[flag] = value end 
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
                                if moveConn then moveConn:Disconnect() end
                                if releaseConn then releaseConn:Disconnect() end
                            end
                        end)
                    end
                end)

                ValueBox.FocusLost:Connect(function() 
                    local num = tonumber(ValueBox.Text) 
                    if num then UpdateSlider(num) end 
                    ValueBox.Text = tostring(value) 
                end)
                
                if flag then 
                    Netro65UI.Flags[flag] = value 
                    Netro65UI.Setters[flag] = UpdateSlider
                end 
                UpdateSlider(value)

                function sldObj:Lock(text, reason) Utility:LockElement(SliderFrame, text, reason) end
                function sldObj:Unlock() Utility:UnlockElement(SliderFrame) end
                return sldObj
            end

            -- [Dropdown - V4.0 Feature]
            function Section:AddDropdown(dProps)
                local dName = dProps.Name or "Dropdown"
                local items = dProps.Items or {}
                local default = dProps.Default or items[1]
                local flag = dProps.Flag
                local callback = dProps.Callback or function() end
                local isOpen = false

                if flag and Netro65UI.Flags[flag] ~= nil then default = Netro65UI.Flags[flag] end

                local DropdownFrame = Utility:Create("Frame", {
                    Parent = ItemContainer, BackgroundTransparency = 1, 
                    Size = UDim2.new(0.94, 0, 0, 50), ClipsDescendants = true
                })
                table.insert(SearchableElements, {Element = DropdownFrame, Keywords = dName})
                
                local HeaderBtn = Utility:Create("TextButton", {
                    Parent = DropdownFrame, BackgroundColor3 = Netro65UI.Theme.Main, 
                    Size = UDim2.new(1, 0, 0, 34), Text = "", AutoButtonColor = false
                }, {
                    Utility:Create("UICorner", {CornerRadius = UDim.new(0, 4)}), 
                    Utility:Create("UIStroke", {Color = Netro65UI.Theme.Outline, Thickness = 1}),
                    Utility:Create("TextLabel", {
                        Text = dName, Font = Netro65UI.Theme.FontMain, TextSize = 13, 
                        TextColor3 = Netro65UI.Theme.Text, BackgroundTransparency = 1, 
                        Size = UDim2.new(0.5, 0, 1, 0), Position = UDim2.new(0, 10, 0, 0), 
                        TextXAlignment = Enum.TextXAlignment.Left
                    }),
                    Utility:Create("TextLabel", {
                        Name = "CurrentVal", Text = tostring(default), Font = Netro65UI.Theme.FontBold, 
                        TextSize = 13, TextColor3 = Netro65UI.Theme.Accent, BackgroundTransparency = 1, 
                        Size = UDim2.new(0.4, 0, 1, 0), Position = UDim2.new(0.6, -25, 0, 0), 
                        TextXAlignment = Enum.TextXAlignment.Right
                    }),
                    Utility:Create("ImageLabel", {
                        Image = "rbxassetid://6031090990", BackgroundTransparency = 1, 
                        Size = UDim2.new(0, 20, 0, 20), Position = UDim2.new(1, -25, 0.5, -10), 
                        ImageColor3 = Netro65UI.Theme.TextDark
                    })
                })
                table.insert(Netro65UI.ThemeObjects, {Instance = HeaderBtn, Type = "Main"})
                table.insert(Netro65UI.ThemeObjects, {Instance = HeaderBtn.CurrentVal, Type = "Accent", Property = "TextColor3"})

                local ListFrame = Utility:Create("ScrollingFrame", {
                    Parent = DropdownFrame, BackgroundColor3 = Netro65UI.Theme.Secondary, 
                    Size = UDim2.new(1, 0, 0, 0), Position = UDim2.new(0, 0, 0, 40), 
                    CanvasSize = UDim2.new(0,0,0,0), ScrollBarThickness = 2, BorderSizePixel = 0
                }, {
                    Utility:Create("UICorner", {CornerRadius = UDim.new(0, 4)}),
                    Utility:Create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 5), HorizontalAlignment = Enum.HorizontalAlignment.Center}),
                    Utility:Create("UIPadding", {PaddingTop = UDim.new(0, 5), PaddingBottom = UDim.new(0, 5)})
                })

                -- Search Bar inside Dropdown
                local SearchBox = Utility:Create("TextBox", {
                    Parent = ListFrame, PlaceholderText = "Search...", Text = "", 
                    BackgroundColor3 = Netro65UI.Theme.Main, Size = UDim2.new(0.9, 0, 0, 25), 
                    Font = Netro65UI.Theme.FontMain, TextColor3 = Netro65UI.Theme.Text, TextSize = 12
                }, {Utility:Create("UICorner", {CornerRadius = UDim.new(0, 4)})})
                table.insert(Netro65UI.ThemeObjects, {Instance = SearchBox, Type = "Main"})

                local function RefreshList(filter)
                    for _, c in pairs(ListFrame:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
                    for _, item in pairs(items) do
                        if not filter or string.find(tostring(item):lower(), filter:lower()) then
                            local ItemBtn = Utility:Create("TextButton", {
                                Parent = ListFrame, Text = tostring(item), Size = UDim2.new(0.9, 0, 0, 25),
                                BackgroundTransparency = 1, TextColor3 = Netro65UI.Theme.TextDark, 
                                Font = Netro65UI.Theme.FontMain, TextSize = 12
                            })
                            ItemBtn.MouseButton1Click:Connect(function()
                                HeaderBtn.CurrentVal.Text = tostring(item)
                                if flag then Netro65UI.Flags[flag] = item end
                                callback(item)
                                isOpen = false
                                Utility:Tween(DropdownFrame, {0.3}, {Size = UDim2.new(0.94, 0, 0, 50)})
                                Utility:Tween(ListFrame, {0.3}, {Size = UDim2.new(1, 0, 0, 0)})
                                Utility:Tween(HeaderBtn.ImageLabel, {0.3}, {Rotation = 0})
                            end)
                        end
                    end
                    ListFrame.CanvasSize = UDim2.new(0,0,0, ListFrame.UIListLayout.AbsoluteContentSize.Y + 10)
                end
                RefreshList()

                SearchBox:GetPropertyChangedSignal("Text"):Connect(function() RefreshList(SearchBox.Text) end)

                HeaderBtn.MouseButton1Click:Connect(function()
                    isOpen = not isOpen
                    local listHeight = math.min(#items * 30 + 35, 150)
                    Utility:Tween(DropdownFrame, {0.3}, {Size = isOpen and UDim2.new(0.94, 0, 0, 40 + listHeight) or UDim2.new(0.94, 0, 0, 50)})
                    Utility:Tween(ListFrame, {0.3}, {Size = isOpen and UDim2.new(1, 0, 0, listHeight) or UDim2.new(1, 0, 0, 0)})
                    Utility:Tween(HeaderBtn.ImageLabel, {0.3}, {Rotation = isOpen and 180 or 0})
                end)

                if flag then 
                    Netro65UI.Flags[flag] = default
                    Netro65UI.Setters[flag] = function(v) HeaderBtn.CurrentVal.Text = v; callback(v) end 
                end
            end

            -- [Textbox - V4.0 Feature]
            function Section:AddTextbox(tbProps)
                local tbName = tbProps.Name or "Textbox"
                local default = tbProps.Default or ""
                local placeholder = tbProps.Placeholder or "Input..."
                local numOnly = tbProps.NumberOnly or false
                local flag = tbProps.Flag
                local callback = tbProps.Callback or function() end

                local TbFrame = Utility:Create("Frame", {
                    Parent = ItemContainer, BackgroundTransparency = 1, Size = UDim2.new(0.94, 0, 0, 40)
                })
                table.insert(SearchableElements, {Element = TbFrame, Keywords = tbName})
                
                Utility:Create("TextLabel", {
                    Parent = TbFrame, Text = tbName, Font = Netro65UI.Theme.FontMain, TextSize = 13,
                    TextColor3 = Netro65UI.Theme.Text, BackgroundTransparency = 1, 
                    Size = UDim2.new(0.5, 0, 1, 0), TextXAlignment = Enum.TextXAlignment.Left
                })
                
                local Box = Utility:Create("TextBox", {
                    Parent = TbFrame, Text = default, PlaceholderText = placeholder, Font = Netro65UI.Theme.FontMain,
                    TextSize = 13, TextColor3 = Netro65UI.Theme.Text, BackgroundColor3 = Netro65UI.Theme.Main,
                    Size = UDim2.new(0.45, 0, 0, 28), Position = UDim2.new(0.55, 0, 0.5, -14), ClearTextOnFocus = false
                }, {
                    Utility:Create("UICorner", {CornerRadius = UDim.new(0, 4)}), 
                    Utility:Create("UIStroke", {Color = Netro65UI.Theme.Outline, Thickness = 1})
                })
                table.insert(Netro65UI.ThemeObjects, {Instance = Box, Type = "Main"})

                Box.FocusLost:Connect(function()
                    if numOnly then Box.Text = Box.Text:gsub("[^%d.-]", "") end
                    if flag then Netro65UI.Flags[flag] = Box.Text end
                    callback(Box.Text)
                end)

                if flag then 
                    Netro65UI.Flags[flag] = default 
                    Netro65UI.Setters[flag] = function(v) Box.Text = v end
                end
            end

            return Section
        end
        return Tab
    end

    --// AUTO-GENERATE SETTINGS TAB (V4.0)
    local SettingsTab = WindowObj:AddTab("Settings")
    local ConfigSection = SettingsTab:AddSection("Configuration")
    
    local ConfigName = ""
    local UniversalConfig = false

    ConfigSection:AddTextbox({Name = "Config Name", Placeholder = "Type name here...", Callback = function(v) ConfigName = v end})
    ConfigSection:AddToggle({Name = "Universal Config", Default = false, Callback = function(v) UniversalConfig = v end})
    
    ConfigSection:AddButton({Name = "Save Config", Callback = function() 
        if ConfigName ~= "" then Netro65UI:SaveConfig(ConfigName, UniversalConfig) 
        else Netro65UI:Notify({Title = "Error", Content = "Enter config name!", Type = "Error"}) end 
    end})
    
    ConfigSection:AddDropdown({Name = "Load Config", Items = Netro65UI:GetConfigs(UniversalConfig), Callback = function(v) 
        ConfigName = v; Netro65UI:LoadConfig(v, UniversalConfig) 
    end})

    ConfigSection:AddButton({Name = "Delete Config", Callback = function() 
        if ConfigName ~= "" then Netro65UI:DeleteConfig(ConfigName, UniversalConfig) 
        else Netro65UI:Notify({Title = "Error", Content = "Enter config name or select from load.", Type = "Error"}) end 
    end})
    
    ConfigSection:AddButton({Name = "Refresh Config List", Callback = function() 
        Netro65UI:Notify({Title = "Info", Content = "Please reload UI to refresh dropdown for now.", Type = "Warning"})
    end})

    local ThemeSection = SettingsTab:AddSection("Theme Switcher")
    local ThemesList = {}
    for name, _ in pairs(Netro65UI.Presets) do table.insert(ThemesList, name) end
    table.sort(ThemesList)
    
    ThemeSection:AddDropdown({
        Name = "Select Theme", Items = ThemesList, Default = "Default",
        Callback = function(v) Netro65UI:SetTheme(v) end
    })

    return WindowObj
end

--// INIT
if not isfolder(Netro65UI.ConfigFolder) and makefolder then 
    makefolder(Netro65UI.ConfigFolder) 
end

return Netro65UI
