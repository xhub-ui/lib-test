--[[
    Netro65UI - Professional Modular UI Library (Ultimate Edition V3.9)
    Status: COMPLETE & UPDATED
    
    Updates by AI Assistant:
    + Added: Modular Key System (JSON/TXT Support)
    + Added: VIP User System (Auto-ID Check via Raw URL)
    + Added: Locking System (Tabs, Buttons, Cards with Overlay/Blur)
    + Updated: Element returns Object for manipulation
]]

local Netro65UI = {}
Netro65UI.Flags = {}
Netro65UI.ConfigFolder = "Netro65UI_Configs"
Netro65UI.CurrentConfigFile = "default.json"
Netro65UI.Version = "3.9.0" 
Netro65UI.IsVIP = false -- Status VIP User

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

--// Theme System
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
            Effect:Destroy() 
        end)
    end
end

--// Main UI Container
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Netro65UI_Ultimate"
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
        ripple:Destroy()
    end)
end

function Utility:AddToolTip(element, text)
    -- Placeholder for ToolTip logic if needed
end

--// Notification System
local NotificationContainer = Utility:Create("Frame", {
    Name = "Notifications",
    Parent = ScreenGui,
    BackgroundTransparency = 1,
    Position = UDim2.new(1, -270, 0, 30),
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
        Parent = NotificationContainer, 
        BackgroundColor3 = Netro65UI.Theme.Secondary,
        Size = UDim2.new(1, 0, 0, 0), 
        BorderSizePixel = 0, 
        ClipsDescendants = true, 
        BackgroundTransparency = 0.05
    }, {
        Utility:Create("UICorner", {CornerRadius = UDim.new(0, 5)}),
        Utility:Create("UIStroke", {Color = typeColor, Thickness = 1, Transparency = 0.6}),
        Utility:Create("TextLabel", {
            Text = title, Font = Netro65UI.Theme.FontBold, TextSize = 13, 
            TextColor3 = Netro65UI.Theme.Text, BackgroundTransparency = 1, 
            Position = UDim2.new(0, 10, 0, 8), Size = UDim2.new(1, -20, 0, 15), 
            TextXAlignment = Enum.TextXAlignment.Left
        }),
        Utility:Create("TextLabel", {
            Text = content, Font = Netro65UI.Theme.FontMain, TextSize = 12, 
            TextColor3 = Netro65UI.Theme.TextDark, BackgroundTransparency = 1, 
            Position = UDim2.new(0, 10, 0, 25), Size = UDim2.new(1, -20, 0, 25), 
            TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true
        }),
        Utility:Create("Frame", {
            Name = "Timer", BackgroundColor3 = typeColor, 
            Size = UDim2.new(1, 0, 0, 2), Position = UDim2.new(0, 0, 1, -2), 
            BorderSizePixel = 0
        })
    })

    Utility:Tween(NotifFrame, {0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out}, {Size = UDim2.new(1, 0, 0, 60)})
    Utility:Tween(NotifFrame.Timer, {duration, Enum.EasingStyle.Linear}, {Size = UDim2.new(0, 0, 0, 2)})
    
    task.delay(duration, function() 
        if NotifFrame then 
            Utility:Tween(NotifFrame, {0.3}, {Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1}) 
            wait(0.3) 
            NotifFrame:Destroy() 
        end 
    end)
end

--// ------------------------------
--// INTERNAL UTILS FOR SYSTEM
--// ------------------------------

local function CheckIDInList(content, userId)
    local idString = tostring(userId)
    local found = false

    -- Cek jika format JSON
    if content:match("^%s*%[") or content:match("^%s*{") then
        local success, json = pcall(function() return HttpService:JSONDecode(content) end)
        if success and type(json) == "table" then
            for _, v in pairs(json) do
                if tostring(v) == idString then
                    found = true
                    break
                end
            end
        end
    else
        -- Cek jika format TXT (Baris per baris atau dipisah koma)
        for line in content:gmatch("[^%s,]+") do
            if line == idString then
                found = true
                break
            end
        end
    end
    return found
end

--// ------------------------------
--// KEY SYSTEM (MODULAR)
--// ------------------------------

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
        Size = UDim2.new(0, 350, 0, 200), Position = UDim2.new(0.5, -175, 0.5, -100),
        BorderSizePixel = 0, ZIndex = 2000, BackgroundTransparency = 0.05
    }, {
        Utility:Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
        Utility:Create("UIStroke", {Color = Netro65UI.Theme.Outline, Thickness = 2}),
        -- Header
        Utility:Create("TextLabel", {Text = KeySettings.Title, Font = Netro65UI.Theme.FontBold, TextSize = 20, TextColor3 = Netro65UI.Theme.Text, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 30), Position = UDim2.new(0, 0, 0, 15)}),
        Utility:Create("TextLabel", {Text = KeySettings.Subtitle, Font = Netro65UI.Theme.FontMain, TextSize = 13, TextColor3 = Netro65UI.Theme.TextDark, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 20), Position = UDim2.new(0, 0, 0, 45)}),
        -- Close Button (Optional, usually Key Systems enforce completion)
        Utility:Create("TextButton", {Text = "X", Font = Netro65UI.Theme.FontBold, TextSize = 14, TextColor3 = Netro65UI.Theme.Error, BackgroundTransparency = 1, Size = UDim2.new(0, 30, 0, 30), Position = UDim2.new(1, -30, 0, 0), Name = "CloseBtn"})
    })

    -- Input Box
    local InputBox = Utility:Create("TextBox", {
        Parent = KeyFrame, BackgroundColor3 = Netro65UI.Theme.Secondary,
        Size = UDim2.new(0.85, 0, 0, 40), Position = UDim2.new(0.075, 0, 0, 80),
        Font = Netro65UI.Theme.FontMain, TextSize = 14, TextColor3 = Netro65UI.Theme.Text,
        PlaceholderText = "Paste Key Here...", PlaceholderColor3 = Netro65UI.Theme.TextDark,
        Text = "", ClearTextOnFocus = false, TextWrapped = true
    }, {
        Utility:Create("UICorner", {CornerRadius = UDim.new(0, 6)}),
        Utility:Create("UIStroke", {Color = Netro65UI.Theme.Outline, Thickness = 1})
    })

    -- Buttons
    local BtnContainer = Utility:Create("Frame", {Parent = KeyFrame, BackgroundTransparency = 1, Size = UDim2.new(0.85, 0, 0, 35), Position = UDim2.new(0.075, 0, 0, 140)})
    
    local ConfirmBtn = Utility:Create("TextButton", {
        Parent = BtnContainer, Text = "Verify Key", Font = Netro65UI.Theme.FontBold, TextSize = 13, 
        TextColor3 = Netro65UI.Theme.Main, BackgroundColor3 = Netro65UI.Theme.Success, 
        Size = UDim2.new(0.48, 0, 1, 0), Position = UDim2.new(0, 0, 0, 0), AutoButtonColor = false
    }, {Utility:Create("UICorner", {CornerRadius = UDim.new(0, 6)})})

    local GetKeyBtn = Utility:Create("TextButton", {
        Parent = BtnContainer, Text = "Get Key Link", Font = Netro65UI.Theme.FontBold, TextSize = 13, 
        TextColor3 = Netro65UI.Theme.Text, BackgroundColor3 = Netro65UI.Theme.Secondary, 
        Size = UDim2.new(0.48, 0, 1, 0), Position = UDim2.new(0.52, 0, 0, 0), AutoButtonColor = false
    }, {Utility:Create("UICorner", {CornerRadius = UDim.new(0, 6)}), Utility:Create("UIStroke", {Color = Netro65UI.Theme.Outline, Thickness = 1})})

    Utility:MakeDraggable(KeyFrame)
    Acrylic:Enable()

    -- Events
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

        local isValid = CheckIDInList(response, inputKey) -- Reusing check function logic for keys

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

--// ------------------------------
--// SYSTEM LOADER (VIP + KEY CHECK)
--// ------------------------------

function Netro65UI:Load(config)
    --[[
        Config Structure:
        {
            VIPUrl = "https://raw.github.../vip.json", (Optional)
            KeySystem = true/false,
            KeySettings = {
                KeyURL = "...",
                KeyLink = "...",
                Title = "..."
            },
            OnLoad = function() ... end (Required: This is where you put your Window creation)
        }
    ]]
    
    local vipUrl = config.VIPUrl
    local useKeySystem = config.KeySystem
    local finalCallback = config.OnLoad or function() warn("No OnLoad callback provided!") end

    -- Indikator Loading awal
    Netro65UI:Notify({Title = "System", Content = "Checking access...", Duration = 2})

    spawn(function()
        local isUserVIP = false

        -- 1. Check VIP jika URL disediakan
        if vipUrl then
            local success, res = pcall(function() return game:HttpGet(vipUrl) end)
            if success then
                isUserVIP = CheckIDInList(res, LocalPlayer.UserId)
            else
                warn("Failed to fetch VIP List")
            end
        end

        Netro65UI.IsVIP = isUserVIP

        if isUserVIP then
            -- 2. Jika VIP, Bypass Key System
            Netro65UI:Notify({Title = "VIP Access", Content = "Welcome back, VIP User!", Type = "Success", Duration = 5})
            finalCallback()
        else
            -- 3. Jika Bukan VIP, Cek apakah Key System aktif
            if useKeySystem then
                Netro65UI:Notify({Title = "Access Required", Content = "You are not VIP. Key System required.", Type = "Warning"})
                wait(1)
                Netro65UI:TriggerKeySystem(config.KeySettings, finalCallback)
            else
                -- Jika tidak ada key system dan bukan VIP, load saja (Free version)
                finalCallback()
            end
        end
    end)
end

--// ------------------------------
--// LOCKING SYSTEM FUNCTION
--// ------------------------------
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
--// MAIN WINDOW SYSTEM
--// ------------------------------

function Netro65UI:CreateWindow(props)
    local WindowObj = {}
    props = props or {}
    local windowWidth = props.Width or 500
    local windowHeight = props.Height or 330
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
            Size = UDim2.new(0, 200, 1, 0), Position = UDim2.new(0, 15, 0, 0), 
            TextXAlignment = Enum.TextXAlignment.Left
        }),
        Utility:Create("TextLabel", {
            Text = "v"..Netro65UI.Version, Font = Netro65UI.Theme.FontMain, TextSize = 11, 
            TextColor3 = Netro65UI.Theme.Accent, BackgroundTransparency = 1, 
            Size = UDim2.new(0, 50, 1, 0), Position = UDim2.new(0, 15 + (#titleText * 9) + 10, 0, 0), 
            TextXAlignment = Enum.TextXAlignment.Left
        })
    })
    Utility:MakeDraggable(MainFrame, Header)

    local SearchBar = Utility:Create("Frame", {
        Parent = Header, BackgroundColor3 = Netro65UI.Theme.Main, 
        Size = UDim2.new(0, 150, 0, 26), Position = UDim2.new(1, -205, 0.5, -13), 
        BackgroundTransparency = 0.5
    }, {
        Utility:Create("UICorner", {CornerRadius = UDim.new(0, 5)}), 
        Utility:Create("UIStroke", {Color = Netro65UI.Theme.Outline, Thickness = 1}), 
        Utility:Create("ImageLabel", {
            Image = "rbxassetid://5036549785", BackgroundTransparency = 1, 
            Size = UDim2.new(0, 14, 0, 14), Position = UDim2.new(0, 6, 0.5, -7), 
            ImageColor3 = Netro65UI.Theme.TextDark
        })
    })
    
    local SearchInput = Utility:Create("TextBox", {
        Parent = SearchBar, BackgroundTransparency = 1, 
        Size = UDim2.new(1, -26, 1, 0), Position = UDim2.new(0, 26, 0, 0), 
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
    
    local NavWidth = 140
    local NavContainer = Utility:Create("ScrollingFrame", {
        Name = "Navigation", Parent = ContentContainer, BackgroundTransparency = 1, 
        Size = UDim2.new(0, NavWidth, 1, -55), Position = UDim2.new(0, 0, 0, 10), 
        ScrollBarThickness = 0, CanvasSize = UDim2.new(0,0,0,0)
    }, {
        Utility:Create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 4)}), 
        Utility:Create("UIPadding", {PaddingLeft = UDim.new(0, 10), PaddingTop = UDim.new(0, 5)})
    })
    
    Utility:Create("Frame", {
        Parent = ContentContainer, BackgroundColor3 = Netro65UI.Theme.Outline, 
        Size = UDim2.new(0, 1, 1, -20), Position = UDim2.new(0, NavWidth, 0, 10), 
        BorderSizePixel = 0
    })

    -- Update Profile Card with VIP Status
    local ProfileCard = Utility:Create("Frame", {
        Parent = ContentContainer, BackgroundColor3 = Netro65UI.Theme.Secondary, 
        Size = UDim2.new(0, NavWidth - 20, 0, 40), Position = UDim2.new(0, 10, 1, -45), 
        BorderSizePixel = 0, BackgroundTransparency = 0.3
    }, {
        Utility:Create("UICorner", {CornerRadius = UDim.new(0, 6)}), 
        Utility:Create("UIStroke", {Color = Netro65UI.Theme.Outline, Thickness = 1}), 
        Utility:Create("ImageLabel", {
            Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48), 
            Size = UDim2.new(0, 28, 0, 28), Position = UDim2.new(0, 6, 0, 6), 
            BackgroundColor3 = Netro65UI.Theme.Main
        }, {Utility:Create("UICorner", {CornerRadius = UDim.new(1, 0)})}), 
        Utility:Create("TextLabel", {
            Text = LocalPlayer.DisplayName, Font = Netro65UI.Theme.FontBold, TextSize = 11, 
            TextColor3 = Netro65UI.Theme.Text, BackgroundTransparency = 1, 
            Position = UDim2.new(0, 42, 0, 4), Size = UDim2.new(0, 80, 0, 14), 
            TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd
        }), 
        Utility:Create("TextLabel", {
            Text = Netro65UI.IsVIP and "VIP User" or "Free User", 
            Font = Netro65UI.Theme.FontMain, TextSize = 10, 
            TextColor3 = Netro65UI.Theme.Accent, BackgroundTransparency = 1, 
            Position = UDim2.new(0, 42, 0, 18), Size = UDim2.new(0, 80, 0, 14), 
            TextXAlignment = Enum.TextXAlignment.Left
        })
    })
    
    if Netro65UI.IsVIP then ProfileCard.TextLabel.TextColor3 = Color3.fromRGB(255, 215, 0) end

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
            BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 32), 
            AutoButtonColor = false, TextXAlignment = Enum.TextXAlignment.Left
        }, {
            Utility:Create("UIPadding", {PaddingLeft = UDim.new(0, 10)}), 
            Utility:Create("UICorner", {CornerRadius = UDim.new(0, 5)}), 
            Utility:Create("ImageLabel", {
                Name = "ActiveBar", BackgroundColor3 = Netro65UI.Theme.Accent, 
                Size = UDim2.new(0, 3, 0, 16), Position = UDim2.new(0, -10, 0.5, -8), Visible = false
            }, {Utility:Create("UICorner", {CornerRadius = UDim.new(0, 2)})})
        })
        
        local Page = Utility:Create("ScrollingFrame", {
            Name = name.."_Page", Parent = Pages, BackgroundTransparency = 1, 
            Size = UDim2.new(1, 0, 1, 0), Visible = false, ScrollBarThickness = 3, 
            ScrollBarImageColor3 = Netro65UI.Theme.Accent, CanvasSize = UDim2.new(0,0,0,0)
        }, {
            Utility:Create("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 10), 
                HorizontalAlignment = Enum.HorizontalAlignment.Center
            }), 
            Utility:Create("UIPadding", {
                PaddingTop = UDim.new(0, 15), PaddingBottom = UDim.new(0, 15), PaddingRight = UDim.new(0, 5)
            })
        })
        
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
                Size = UDim2.new(1, -20, 0, 0), BorderSizePixel = 0, BackgroundTransparency = 0.5
            }, {
                Utility:Create("UICorner", {CornerRadius = UDim.new(0, 6)}), 
                Utility:Create("UIStroke", {Color = Netro65UI.Theme.Outline, Thickness = 1}), 
                Utility:Create("TextLabel", {
                    Text = sectionName, Font = Netro65UI.Theme.FontBold, TextSize = 12, 
                    TextColor3 = Netro65UI.Theme.Accent, BackgroundTransparency = 1, 
                    Size = UDim2.new(1, -20, 0, 28), Position = UDim2.new(0, 10, 0, 0), 
                    TextXAlignment = Enum.TextXAlignment.Left
                }), 
                Utility:Create("Frame", {
                    Name = "Container", BackgroundTransparency = 1, 
                    Position = UDim2.new(0, 0, 0, 28), Size = UDim2.new(1, 0, 0, 0)
                }, {
                    Utility:Create("UIListLayout", {
                        SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 6), 
                        HorizontalAlignment = Enum.HorizontalAlignment.Center
                    }), 
                    Utility:Create("UIPadding", {PaddingBottom = UDim.new(0, 10)})
                })
            })
            
            local ItemContainer = SectionFrame.Container
            ItemContainer.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() 
                SectionFrame.Size = UDim2.new(1, -20, 0, ItemContainer.UIListLayout.AbsoluteContentSize.Y + 38) 
            end)

            function Section:AddButton(bProps)
                local btnObj = {}
                local btnText = bProps.Name or "Button"
                local callback = bProps.Callback or function() end
                
                local Button = Utility:Create("TextButton", {
                    Parent = ItemContainer, Text = btnText, Font = Netro65UI.Theme.FontMain, 
                    TextSize = 13, TextColor3 = Netro65UI.Theme.Text, 
                    BackgroundColor3 = Netro65UI.Theme.Main, Size = UDim2.new(1, -16, 0, 32), 
                    AutoButtonColor = false, BorderSizePixel = 0
                }, {
                    Utility:Create("UICorner", {CornerRadius = UDim.new(0, 4)}), 
                    Utility:Create("UIStroke", {Color = Netro65UI.Theme.Outline, Thickness = 1})
                })
                
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

            function Section:AddToggle(tProps)
                local togObj = {}
                local tName = tProps.Name or "Toggle"
                local state = tProps.Default or false 
                local flag = tProps.Flag
                local callback = tProps.Callback or function() end
                
                if flag and Netro65UI.Flags[flag] ~= nil then state = Netro65UI.Flags[flag] end
                
                local ToggleFrame = Utility:Create("Frame", {
                    Parent = ItemContainer, BackgroundTransparency = 1, Size = UDim2.new(1, -16, 0, 32)
                })
                
                Utility:Create("TextLabel", {
                    Parent = ToggleFrame, Text = tName, Font = Netro65UI.Theme.FontMain, 
                    TextSize = 13, TextColor3 = Netro65UI.Theme.Text, BackgroundTransparency = 1, 
                    Size = UDim2.new(0.7, 0, 1, 0), TextXAlignment = Enum.TextXAlignment.Left
                })
                
                local Switch = Utility:Create("TextButton", {
                    Parent = ToggleFrame, Text = "", 
                    BackgroundColor3 = state and Netro65UI.Theme.Accent or Netro65UI.Theme.Main, 
                    Size = UDim2.new(0, 40, 0, 20), Position = UDim2.new(1, -40, 0.5, -10), 
                    AutoButtonColor = false
                }, {
                    Utility:Create("UICorner", {CornerRadius = UDim.new(1, 0)}), 
                    Utility:Create("UIStroke", {Color = Netro65UI.Theme.Outline, Thickness = 1})
                })
                
                local Knob = Utility:Create("Frame", {
                    Parent = Switch, BackgroundColor3 = Color3.new(1,1,1), Size = UDim2.new(0, 16, 0, 16), 
                    Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                }, {Utility:Create("UICorner", {CornerRadius = UDim.new(1, 0)})})
                
                table.insert(SearchableElements, {Element = ToggleFrame, Keywords = tName})
                
                local function Update(val) 
                    state = val 
                    Utility:Tween(Knob, {0.2}, {Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}) 
                    Utility:Tween(Switch, {0.2}, {BackgroundColor3 = state and Netro65UI.Theme.Accent or Netro65UI.Theme.Main}) 
                    if flag then Netro65UI.Flags[flag] = state end 
                    callback(state) 
                end
                
                Switch.MouseButton1Click:Connect(function() 
                    if ToggleFrame:FindFirstChild("LockOverlay") then return end
                    Update(not state) 
                end) 
                
                if flag then Netro65UI.Flags[flag] = state end 
                callback(state)
                
                function togObj:Lock(text, reason) Utility:LockElement(ToggleFrame, text, reason) end
                function togObj:Unlock() Utility:UnlockElement(ToggleFrame) end
                return togObj
            end

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
                    Parent = ItemContainer, BackgroundTransparency = 1, Size = UDim2.new(1, -16, 0, 44)
                })
                
                Utility:Create("TextLabel", {
                    Parent = SliderFrame, Text = sName, Font = Netro65UI.Theme.FontMain, 
                    TextSize = 13, TextColor3 = Netro65UI.Theme.Text, BackgroundTransparency = 1, 
                    Size = UDim2.new(1, 0, 0, 20), TextXAlignment = Enum.TextXAlignment.Left
                })
                
                local ValueBox = Utility:Create("TextBox", {
                    Parent = SliderFrame, Text = tostring(value), Font = Netro65UI.Theme.FontBold, 
                    TextSize = 13, TextColor3 = Netro65UI.Theme.Accent, BackgroundTransparency = 1, 
                    Size = UDim2.new(0, 40, 0, 20), Position = UDim2.new(1, -40, 0, 0), 
                    TextXAlignment = Enum.TextXAlignment.Right, ClearTextOnFocus = false
                })
                
                local Track = Utility:Create("Frame", {
                    Parent = SliderFrame, BackgroundColor3 = Netro65UI.Theme.Main, 
                    Size = UDim2.new(1, 0, 0, 6), Position = UDim2.new(0, 0, 0, 28)
                }, {
                    Utility:Create("UICorner", {CornerRadius = UDim.new(1, 0)}), 
                    Utility:Create("UIStroke", {Color = Netro65UI.Theme.Outline, Thickness = 1})
                })
                
                local Fill = Utility:Create("Frame", {
                    Parent = Track, BackgroundColor3 = Netro65UI.Theme.Accent, 
                    Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
                }, {Utility:Create("UICorner", {CornerRadius = UDim.new(1, 0)})})
                
                local Hitbox = Utility:Create("TextButton", {
                    Parent = SliderFrame, BackgroundTransparency = 1, Text = "", 
                    Size = UDim2.new(1, 0, 0, 20), Position = UDim2.new(0, 0, 0, 22), ZIndex = 5
                })
                
                table.insert(SearchableElements, {Element = SliderFrame, Keywords = sName})
                
                local function UpdateSlider()
                    if not Track.Parent then return end
                    local mousePos = UserInputService:GetMouseLocation()
                    local relativePos = mousePos.X - Track.AbsolutePosition.X
                    local percent = math.clamp(relativePos / Track.AbsoluteSize.X, 0, 1)
                    value = math.floor(min + ((max - min) * percent))
                    ValueBox.Text = tostring(value)
                    Utility:Tween(Fill, {0.05}, {Size = UDim2.new(percent, 0, 1, 0)})
                    if flag then Netro65UI.Flags[flag] = value end 
                    callback(value)
                end

                local isDragging = false
                Hitbox.InputBegan:Connect(function(input)
                    if SliderFrame:FindFirstChild("LockOverlay") then return end
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        isDragging = true
                        UpdateSlider()
                        local moveConn, releaseConn
                        moveConn = UserInputService.InputChanged:Connect(function(moveInput)
                            if (moveInput.UserInputType == Enum.UserInputType.MouseMovement or moveInput.UserInputType == Enum.UserInputType.Touch) and isDragging then
                                UpdateSlider()
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
                    if num then 
                        value = math.clamp(num, min, max) 
                        local percent = (value - min) / (max - min) 
                        Utility:Tween(Fill, {0.2}, {Size = UDim2.new(percent, 0, 1, 0)}) 
                        if flag then Netro65UI.Flags[flag] = value end 
                        callback(value) 
                    end 
                    ValueBox.Text = tostring(value) 
                end)
                
                if flag then Netro65UI.Flags[flag] = value end 
                callback(value)

                function sldObj:Lock(text, reason) Utility:LockElement(SliderFrame, text, reason) end
                function sldObj:Unlock() Utility:UnlockElement(SliderFrame) end
                return sldObj
            end

            return Section
        end
        return Tab
    end
    
    return WindowObj
end

--// INIT
if not isfolder(Netro65UI.ConfigFolder) and makefolder then 
    makefolder(Netro65UI.ConfigFolder) 
end

return Netro65UI