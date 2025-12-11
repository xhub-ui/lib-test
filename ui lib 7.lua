--[[
    Netro65UI - Professional Modular UI Library (Enhanced Edition V3.5.3)
    Status: COMPLETE & DRAGGABLE FIXED
    
    Fixed by: AI Assistant
    - Added: Smooth Draggable System (Tween based)
    - Window Size: 600x400 (Compact)
    - Padding/Spacing: Adjusted
    - Search Bar: Fixed Position
]]

local Netro65UI = {}
Netro65UI.Flags = {}
Netro65UI.ConfigFolder = "Netro65UI_Configs"
Netro65UI.ThemeFolder = "Netro65UI_Themes"
Netro65UI.CurrentConfigFile = "default.json"
Netro65UI.Version = "3.5.3"

--// Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

--// Constants
local MOUSE = Players.LocalPlayer:GetMouse()
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

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
        task.delay(0.5, function() Effect:Destroy() end)
    end
end

--// Main UI Container
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Netro65UI_V3_Refined"
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

--// [NEW] FUNCTION: SMOOTH DRAGGABLE SYSTEM
function Utility:MakeDraggable(frame, handle)
    handle = handle or frame
    local dragging = false
    local dragInput, mousePos, framePos

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            mousePos = input.Position
            framePos = frame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            -- Menggunakan Tween agar pergerakan halus (Smooth Drag)
            Utility:Tween(frame, {0.05, Enum.EasingStyle.Sine}, {
                Position = UDim2.new(
                    framePos.X.Scale, framePos.X.Offset + delta.X,
                    framePos.Y.Scale, framePos.Y.Offset + delta.Y
                )
            })
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

--// ToolTip System
local ToolTipFrame = nil
function Utility:AddToolTip(hoverObject, text)
    if not text then return end
    hoverObject.MouseEnter:Connect(function()
        if ToolTipFrame then ToolTipFrame:Destroy() end
        ToolTipFrame = Utility:Create("Frame", {
            Parent = ScreenGui,
            BackgroundColor3 = Color3.fromRGB(30, 30, 30),
            Size = UDim2.new(0, 0, 0, 24),
            AutomaticSize = Enum.AutomaticSize.X,
            ZIndex = 300,
            Visible = false,
            BorderSizePixel = 0
        }, {
            Utility:Create("UICorner", {CornerRadius = UDim.new(0, 4)}),
            Utility:Create("UIStroke", {Color = Netro65UI.Theme.Accent, Thickness = 1, Transparency = 0.5}),
            Utility:Create("TextLabel", {
                Text = text,
                Font = Netro65UI.Theme.FontMain,
                TextSize = 12,
                TextColor3 = Netro65UI.Theme.Text,
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 0, 1, 0),
                AutomaticSize = Enum.AutomaticSize.X,
                Position = UDim2.new(0, 8, 0, 0)
            }),
            Utility:Create("UIPadding", {PaddingRight = UDim.new(0, 8)})
        })
        ToolTipFrame.Visible = true
        local moveConn = RunService.RenderStepped:Connect(function()
            if not hoverObject.Parent or not ToolTipFrame then return end
            local mPos = UserInputService:GetMouseLocation()
            ToolTipFrame.Position = UDim2.new(0, mPos.X + 15, 0, mPos.Y - 20)
        end)
        hoverObject.MouseLeave:Connect(function()
            if ToolTipFrame then ToolTipFrame:Destroy() end
            if moveConn then moveConn:Disconnect() end
        end)
    end)
end

--// ESP Module
local ESP = {
    Enabled = false, Boxes = false, Names = false, 
    Tracers = false, HealthBar = false, TeamCheck = false,
    Objects = {}
}

function ESP:Toggle(state)
    ESP.Enabled = state
    if not state then
        for _, v in pairs(ESP.Objects) do
            for _, drawing in pairs(v) do drawing.Visible = false end
        end
    end
end

local function CreateDrawing(type, props)
    local draw = Drawing.new(type)
    for k, v in pairs(props) do draw[k] = v end
    return draw
end

function ESP:AddPlayer(player)
    if player == LocalPlayer then return end
    
    local Entry = {
        Box = CreateDrawing("Square", {Thickness = 1, Color = Color3.new(1,1,1), Filled = false}),
        BoxOutline = CreateDrawing("Square", {Thickness = 3, Color = Color3.new(0,0,0), Filled = false}),
        Name = CreateDrawing("Text", {Size = 13, Center = true, Outline = true, Color = Color3.new(1,1,1)}),
        HealthOutline = CreateDrawing("Line", {Thickness = 3, Color = Color3.new(0,0,0)}),
        Health = CreateDrawing("Line", {Thickness = 1, Color = Color3.new(0,1,0)}),
        Tracer = CreateDrawing("Line", {Thickness = 1, Color = Color3.new(1,1,1)})
    }
    
    ESP.Objects[player] = Entry
    
    local Connection
    Connection = RunService.RenderStepped:Connect(function()
        if not player.Parent or not ESP.Objects[player] then
            Connection:Disconnect()
            for _, v in pairs(Entry) do v:Remove() end
            ESP.Objects[player] = nil
            return
        end
        
        local Character = player.Character
        local RootPart = Character and Character:FindFirstChild("HumanoidRootPart")
        local Humanoid = Character and Character:FindFirstChild("Humanoid")
        
        if ESP.Enabled and Character and RootPart and Humanoid and Humanoid.Health > 0 then
            local ScreenPos, OnScreen = Camera:WorldToViewportPoint(RootPart.Position)
            local Distance = (Camera.CFrame.Position - RootPart.Position).Magnitude
            
            if ESP.TeamCheck and player.Team == LocalPlayer.Team then
                for _, v in pairs(Entry) do v.Visible = false end
                return
            end

            if OnScreen then
                local Scale = 1000 / Distance
                local BoxSize = Vector2.new(40 * Scale, 60 * Scale)
                local BoxPos = Vector2.new(ScreenPos.X - BoxSize.X / 2, ScreenPos.Y - BoxSize.Y / 2)
                
                -- Box
                if ESP.Boxes then
                    Entry.Box.Size = BoxSize
                    Entry.Box.Position = BoxPos
                    Entry.Box.Visible = true
                    Entry.BoxOutline.Size = BoxSize
                    Entry.BoxOutline.Position = BoxPos
                    Entry.BoxOutline.Visible = true
                else
                    Entry.Box.Visible = false
                    Entry.BoxOutline.Visible = false
                end
                
                -- Name
                if ESP.Names then
                    Entry.Name.Position = Vector2.new(ScreenPos.X, BoxPos.Y - 16)
                    Entry.Name.Text = player.DisplayName .. " [" .. math.floor(Distance) .. "m]"
                    Entry.Name.Visible = true
                else
                    Entry.Name.Visible = false
                end
                
                -- Health
                if ESP.HealthBar then
                    local HealthPct = Humanoid.Health / Humanoid.MaxHealth
                    local BarEnd = Vector2.new(BoxPos.X - 5, BoxPos.Y + BoxSize.Y - (BoxSize.Y * HealthPct))
                    Entry.HealthOutline.From = Vector2.new(BoxPos.X - 5, BoxPos.Y)
                    Entry.HealthOutline.To = Vector2.new(BoxPos.X - 5, BoxPos.Y + BoxSize.Y)
                    Entry.HealthOutline.Visible = true
                    Entry.Health.From = Vector2.new(BoxPos.X - 5, BoxPos.Y + BoxSize.Y)
                    Entry.Health.To = BarEnd
                    Entry.Health.Color = Color3.fromRGB(255, 0, 0):Lerp(Color3.fromRGB(0, 255, 0), HealthPct)
                    Entry.Health.Visible = true
                else
                    Entry.Health.Visible = false
                    Entry.HealthOutline.Visible = false
                end
                
                -- Tracers
                if ESP.Tracers then
                    Entry.Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                    Entry.Tracer.To = Vector2.new(ScreenPos.X, ScreenPos.Y)
                    Entry.Tracer.Visible = true
                else
                    Entry.Tracer.Visible = false
                end
            else
                for _, v in pairs(Entry) do v.Visible = false end
            end
        else
            for _, v in pairs(Entry) do v.Visible = false end
        end
    end)
end

if Drawing then 
    for _, plr in pairs(Players:GetPlayers()) do ESP:AddPlayer(plr) end
    Players.PlayerAdded:Connect(function(plr) ESP:AddPlayer(plr) end)
    Players.PlayerRemoving:Connect(function(plr) 
        if ESP.Objects[plr] then
            for _, v in pairs(ESP.Objects[plr]) do v:Remove() end
            ESP.Objects[plr] = nil
        end
    end)
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
            Text = title,
            Font = Netro65UI.Theme.FontBold,
            TextSize = 13,
            TextColor3 = Netro65UI.Theme.Text,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 10, 0, 8),
            Size = UDim2.new(1, -20, 0, 15),
            TextXAlignment = Enum.TextXAlignment.Left
        }),
        Utility:Create("TextLabel", {
            Text = content,
            Font = Netro65UI.Theme.FontMain,
            TextSize = 12,
            TextColor3 = Netro65UI.Theme.TextDark,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 10, 0, 25),
            Size = UDim2.new(1, -20, 0, 25),
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true
        }),
        Utility:Create("Frame", {
            Name = "Timer",
            BackgroundColor3 = typeColor,
            Size = UDim2.new(1, 0, 0, 2),
            Position = UDim2.new(0, 0, 1, -2),
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

--// Window System
function Netro65UI:CreateWindow(props)
    local WindowObj = {}
    props = props or {}
    
    local windowWidth = props.Width or 600
    local windowHeight = props.Height or 400
    local titleText = props.Title or "Netro65UI"
    local configName = props.ConfigName or "Default"
    
    Acrylic:Enable()

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
        Utility:Create("UIStroke", {Color = Netro65UI.Theme.Outline, Thickness = 1.5}),
        Utility:Create("ImageLabel", {
            Name = "Shadow",
            BackgroundTransparency = 1,
            Image = "rbxassetid://5028857472",
            SliceCenter = Rect.new(24,24,276,276),
            ScaleType = Enum.ScaleType.Slice,
            Size = UDim2.new(1, 40, 1, 40),
            Position = UDim2.new(0, -20, 0, -20),
            ImageColor3 = Color3.new(0,0,0),
            ImageTransparency = 0.4,
            ZIndex = -1
        })
    })

    -- Header
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
            Size = UDim2.new(0, 200, 1, 0),
            Position = UDim2.new(0, 15, 0, 0),
            TextXAlignment = Enum.TextXAlignment.Left
        }),
        Utility:Create("TextLabel", {
            Text = "v"..Netro65UI.Version,
            Font = Netro65UI.Theme.FontMain,
            TextSize = 11,
            TextColor3 = Netro65UI.Theme.Accent,
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 50, 1, 0),
            Position = UDim2.new(0, 15 + (#titleText * 9) + 10, 0, 0),
            TextXAlignment = Enum.TextXAlignment.Left
        })
    })

    -- [APPLY DRAGGABLE HERE]
    Utility:MakeDraggable(MainFrame, Header)

    -- Search Bar
    local SearchBar = Utility:Create("Frame", {
        Parent = Header,
        BackgroundColor3 = Netro65UI.Theme.Main,
        Size = UDim2.new(0, 160, 0, 26),
        Position = UDim2.new(1, -190, 0.5, -13),
        BackgroundTransparency = 0.5
    }, {
        Utility:Create("UICorner", {CornerRadius = UDim.new(0, 5)}),
        Utility:Create("UIStroke", {Color = Netro65UI.Theme.Outline, Thickness = 1}),
        Utility:Create("ImageLabel", {
            Image = "rbxassetid://5036549785",
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 14, 0, 14),
            Position = UDim2.new(0, 6, 0.5, -7),
            ImageColor3 = Netro65UI.Theme.TextDark
        })
    })

    local SearchInput = Utility:Create("TextBox", {
        Parent = SearchBar,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -26, 1, 0),
        Position = UDim2.new(0, 26, 0, 0),
        Font = Netro65UI.Theme.FontMain,
        TextSize = 13,
        TextColor3 = Netro65UI.Theme.Text,
        PlaceholderText = "Search...",
        PlaceholderColor3 = Netro65UI.Theme.TextDark,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    -- Controls
    local CloseBtn = Utility:Create("TextButton", {
        Parent = Header, Text = "", BackgroundColor3 = Color3.fromRGB(255, 80, 80),
        Size = UDim2.new(0, 12, 0, 12), Position = UDim2.new(1, -25, 0, 17),
        AutoButtonColor = false
    }, {Utility:Create("UICorner", {CornerRadius = UDim.new(1,0)})})

    local MinBtn = Utility:Create("TextButton", {
        Parent = Header, Text = "", BackgroundColor3 = Color3.fromRGB(255, 200, 80),
        Size = UDim2.new(0, 12, 0, 12), Position = UDim2.new(1, -45, 0, 17),
        AutoButtonColor = false
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

    -- Content
    local ContentContainer = Utility:Create("Frame", {
        Name = "Content",
        Parent = MainFrame, BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 45), Size = UDim2.new(1, 0, 1, -45),
        ClipsDescendants = true
    })

    -- Navigation
    local NavWidth = 150
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

    -- Profile Card
    local ProfileCard = Utility:Create("Frame", {
        Parent = ContentContainer, BackgroundColor3 = Netro65UI.Theme.Secondary,
        Size = UDim2.new(0, NavWidth - 20, 0, 45), Position = UDim2.new(0, 10, 1, -50),
        BorderSizePixel = 0, BackgroundTransparency = 0.3
    }, {
        Utility:Create("UICorner", {CornerRadius = UDim.new(0, 6)}),
        Utility:Create("UIStroke", {Color = Netro65UI.Theme.Outline, Thickness = 1}),
        Utility:Create("ImageLabel", {
            Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48),
            Size = UDim2.new(0, 32, 0, 32), Position = UDim2.new(0, 6, 0, 6),
            BackgroundColor3 = Netro65UI.Theme.Main
        }, {Utility:Create("UICorner", {CornerRadius = UDim.new(1, 0)})}),
        Utility:Create("TextLabel", {
            Text = LocalPlayer.DisplayName, Font = Netro65UI.Theme.FontBold,
            TextSize = 12, TextColor3 = Netro65UI.Theme.Text, BackgroundTransparency = 1,
            Position = UDim2.new(0, 46, 0, 6), Size = UDim2.new(0, 80, 0, 14),
            TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd
        }),
        Utility:Create("TextLabel", {
            Text = "User", Font = Netro65UI.Theme.FontMain,
            TextSize = 11, TextColor3 = Netro65UI.Theme.Accent, BackgroundTransparency = 1,
            Position = UDim2.new(0, 46, 0, 22), Size = UDim2.new(0, 80, 0, 14),
            TextXAlignment = Enum.TextXAlignment.Left
        })
    })

    -- Pages
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
            Parent = NavContainer, Text = name, Font = Netro65UI.Theme.FontMain,
            TextSize = 13, TextColor3 = Netro65UI.Theme.TextDark, BackgroundColor3 = Netro65UI.Theme.Main,
            BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 32),
            AutoButtonColor = false, TextXAlignment = Enum.TextXAlignment.Left
        }, {
            Utility:Create("UIPadding", {PaddingLeft = UDim.new(0, 10)}),
            Utility:Create("UICorner", {CornerRadius = UDim.new(0, 5)}),
            Utility:Create("ImageLabel", {
                Name = "ActiveBar", BackgroundColor3 = Netro65UI.Theme.Accent,
                Size = UDim2.new(0, 3, 0, 16), Position = UDim2.new(0, -10, 0.5, -8),
                Visible = false
            }, {Utility:Create("UICorner", {CornerRadius = UDim.new(0, 2)})})
        })

        local Page = Utility:Create("ScrollingFrame", {
            Name = name.."_Page", Parent = Pages, BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0), Visible = false,
            ScrollBarThickness = 3, ScrollBarImageColor3 = Netro65UI.Theme.Accent,
            CanvasSize = UDim2.new(0,0,0,0)
        }, {
            Utility:Create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 10), HorizontalAlignment = Enum.HorizontalAlignment.Center}),
            Utility:Create("UIPadding", {PaddingTop = UDim.new(0, 15), PaddingBottom = UDim.new(0, 15), PaddingRight = UDim.new(0, 5)})
        })
        
        Page.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Page.CanvasSize = UDim2.new(0, 0, 0, Page.UIListLayout.AbsoluteContentSize.Y + 30)
        end)

        TabBtn.MouseButton1Click:Connect(function()
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
                    Utility:Create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 6), HorizontalAlignment = Enum.HorizontalAlignment.Center}),
                    Utility:Create("UIPadding", {PaddingBottom = UDim.new(0, 10)})
                })
            })

            local ItemContainer = SectionFrame.Container
            ItemContainer.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                SectionFrame.Size = UDim2.new(1, -20, 0, ItemContainer.UIListLayout.AbsoluteContentSize.Y + 38)
            end)

            function Section:AddButton(bProps)
                local btnText = bProps.Name or "Button"
                local callback = bProps.Callback or function() end
                
                local Button = Utility:Create("TextButton", {
                    Parent = ItemContainer, Text = btnText, Font = Netro65UI.Theme.FontMain,
                    TextSize = 13, TextColor3 = Netro65UI.Theme.Text, BackgroundColor3 = Netro65UI.Theme.Main,
                    Size = UDim2.new(1, -16, 0, 32), AutoButtonColor = false, BorderSizePixel = 0
                }, {
                    Utility:Create("UICorner", {CornerRadius = UDim.new(0, 4)}),
                    Utility:Create("UIStroke", {Color = Netro65UI.Theme.Outline, Thickness = 1})
                })
                
                if bProps.Info then Utility:AddToolTip(Button, bProps.Info) end
                table.insert(SearchableElements, {Element = Button, Keywords = btnText})
                
                Button.MouseButton1Click:Connect(function() Utility:Ripple(Button) callback() end)
                Button.MouseEnter:Connect(function() Utility:Tween(Button, {0.2}, {BackgroundColor3 = Netro65UI.Theme.Hover}) end)
                Button.MouseLeave:Connect(function() Utility:Tween(Button, {0.2}, {BackgroundColor3 = Netro65UI.Theme.Main}) end)
            end

            function Section:AddToggle(tProps)
                local tName, state = tProps.Name or "Toggle", tProps.Default or false
                local flag, callback = tProps.Flag, tProps.Callback or function() end
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
                    Parent = ToggleFrame, Text = "", BackgroundColor3 = state and Netro65UI.Theme.Accent or Netro65UI.Theme.Main,
                    Size = UDim2.new(0, 40, 0, 20), Position = UDim2.new(1, -40, 0.5, -10),
                    AutoButtonColor = false
                }, {
                    Utility:Create("UICorner", {CornerRadius = UDim.new(1, 0)}),
                    Utility:Create("UIStroke", {Color = Netro65UI.Theme.Outline, Thickness = 1})
                })
                local Knob = Utility:Create("Frame", {
                    Parent = Switch, BackgroundColor3 = Color3.new(1,1,1),
                    Size = UDim2.new(0, 16, 0, 16), Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                }, {Utility:Create("UICorner", {CornerRadius = UDim.new(1, 0)})})
                
                table.insert(SearchableElements, {Element = ToggleFrame, Keywords = tName})
                
                local function Update(val)
                    state = val
                    Utility:Tween(Knob, {0.2}, {Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)})
                    Utility:Tween(Switch, {0.2}, {BackgroundColor3 = state and Netro65UI.Theme.Accent or Netro65UI.Theme.Main})
                    if flag then Netro65UI.Flags[flag] = state end
                    callback(state)
                end
                Switch.MouseButton1Click:Connect(function() Update(not state) end)
                if flag then Netro65UI.Flags[flag] = state end
                callback(state)
            end

            function Section:AddSlider(sProps)
                local sName, min, max = sProps.Name or "Slider", sProps.Min or 0, sProps.Max or 100
                local default, flag = sProps.Default or min, sProps.Flag
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
                
                table.insert(SearchableElements, {Element = SliderFrame, Keywords = sName})
                
                local isDragging = false
                local function UpdateFromScale(scale)
                    scale = math.clamp(scale, 0, 1)
                    value = math.floor(min + ((max - min) * scale))
                    ValueBox.Text = tostring(value)
                    Utility:Tween(Fill, {0.05}, {Size = UDim2.new(scale, 0, 1, 0)})
                    if flag then Netro65UI.Flags[flag] = value end
                    callback(value)
                end
                
                Track.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        isDragging = true
                        UpdateFromScale((input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X)
                    end
                end)
                UserInputService.InputChanged:Connect(function(input)
                    if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        UpdateFromScale((input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X)
                    end
                end)
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then isDragging = false end
                end)
                if flag then Netro65UI.Flags[flag] = value end
                callback(value)
            end

            function Section:AddMultiDropdown(dProps)
                local dName, options = dProps.Name or "Dropdown", dProps.Options or {}
                local flag, callback = dProps.Flag, dProps.Callback or function() end
                local selected, isOpen = {}, false

                local DropFrame = Utility:Create("Frame", {
                    Parent = ItemContainer, BackgroundTransparency = 1,
                    Size = UDim2.new(1, -16, 0, 46), ClipsDescendants = true, ZIndex = 2
                })
                Utility:Create("TextLabel", {
                    Parent = DropFrame, Text = dName, Font = Netro65UI.Theme.FontMain,
                    TextSize = 13, TextColor3 = Netro65UI.Theme.Text, BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 18), TextXAlignment = Enum.TextXAlignment.Left
                })
                local MainBtn = Utility:Create("TextButton", {
                    Parent = DropFrame, Text = "None", Font = Netro65UI.Theme.FontMain,
                    TextSize = 13, TextColor3 = Netro65UI.Theme.TextDark, BackgroundColor3 = Netro65UI.Theme.Main,
                    Size = UDim2.new(1, 0, 0, 26), Position = UDim2.new(0, 0, 0, 20),
                    TextXAlignment = Enum.TextXAlignment.Left, AutoButtonColor = false
                }, {
                    Utility:Create("UICorner", {CornerRadius = UDim.new(0, 4)}),
                    Utility:Create("UIStroke", {Color = Netro65UI.Theme.Outline, Thickness = 1}),
                    Utility:Create("UIPadding", {PaddingLeft = UDim.new(0, 8)}),
                    Utility:Create("TextLabel", {
                        Text = "▼", BackgroundTransparency = 1, TextColor3 = Netro65UI.Theme.TextDark,
                        Size = UDim2.new(0, 30, 1, 0), Position = UDim2.new(1, -30, 0, 0), TextSize = 10
                    })
                })
                table.insert(SearchableElements, {Element = DropFrame, Keywords = dName})
                
                local List = Utility:Create("ScrollingFrame", {
                    Parent = DropFrame, BackgroundColor3 = Netro65UI.Theme.Main,
                    Size = UDim2.new(1, 0, 0, 0), Position = UDim2.new(0, 0, 0, 50),
                    BorderSizePixel = 0, ScrollBarThickness = 2, CanvasSize = UDim2.new(0,0,0,0)
                }, {Utility:Create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0,1)})})

                local function Refresh()
                    local count = 0
                    for _, v in pairs(selected) do if v then count = count + 1 end end
                    MainBtn.Text = count == 0 and "None" or count .. " Selected"
                    callback(selected)
                    if flag then Netro65UI.Flags[flag] = selected end
                end

                for _, opt in pairs(options) do
                    local Item = Utility:Create("TextButton", {
                        Parent = List, Text = opt, Font = Netro65UI.Theme.FontMain,
                        TextSize = 12, TextColor3 = Netro65UI.Theme.TextDark,
                        BackgroundColor3 = Netro65UI.Theme.Secondary, Size = UDim2.new(1, 0, 0, 24), AutoButtonColor = false
                    })
                    Item.MouseButton1Click:Connect(function()
                        selected[opt] = not selected[opt]
                        Item.TextColor3 = selected[opt] and Netro65UI.Theme.Accent or Netro65UI.Theme.TextDark
                        Refresh()
                    end)
                end
                
                List.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                    List.CanvasSize = UDim2.new(0,0,0, List.UIListLayout.AbsoluteContentSize.Y)
                end)
                MainBtn.MouseButton1Click:Connect(function()
                    isOpen = not isOpen
                    local maxH = math.min(120, (#options * 25))
                    Utility:Tween(DropFrame, {0.3}, {Size = UDim2.new(1, -16, 0, isOpen and (50 + maxH) or 46)})
                    Utility:Tween(List, {0.3}, {Size = UDim2.new(1, 0, 0, isOpen and maxH or 0)})
                end)
            end
            return Section
        end
        return Tab
    end
    
    --// AUTO-INIT STANDARD TABS
    local SettingsTab = WindowObj:AddTab("Visuals")
    local ESPSection = SettingsTab:AddSection("ESP Settings")
    ESPSection:AddToggle({Name = "Enable ESP", Flag = "ESP_Enabled", Callback = function(v) ESP:Toggle(v) end})
    ESPSection:AddToggle({Name = "Boxes", Flag = "ESP_Boxes", Callback = function(v) ESP.Boxes = v end})
    ESPSection:AddToggle({Name = "Names", Flag = "ESP_Names", Callback = function(v) ESP.Names = v end})
    ESPSection:AddToggle({Name = "Health", Flag = "ESP_Health", Callback = function(v) ESP.HealthBar = v end})
    ESPSection:AddToggle({Name = "Tracers", Flag = "ESP_Tracers", Callback = function(v) ESP.Tracers = v end})
    
    local ConfigTab = WindowObj:AddTab("Settings")
    local MainCfg = ConfigTab:AddSection("Configuration")
    MainCfg:AddButton({Name = "Save Config", Callback = function() 
        if writefile then writefile(Netro65UI.ConfigFolder.."/"..configName..".json", HttpService:JSONEncode(Netro65UI.Flags)) end
        Netro65UI:Notify({Title = "Config", Content = "Configuration Saved!", Type = "Success"})
    end})
    MainCfg:AddButton({Name = "Unload UI", Callback = function() 
        Acrylic:Disable() ScreenGui:Destroy() 
    end})
    
    return WindowObj
end

--// INIT
if not isfolder(Netro65UI.ConfigFolder) and makefolder then makefolder(Netro65UI.ConfigFolder) end
Netro65UI:Notify({Title = "Netro65UI V3", Content = "Loaded successfully. Draggable System Active.", Duration = 5})

return Netro65UI
