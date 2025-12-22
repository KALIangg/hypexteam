-- BladeMenu Library v3.0
-- Library completa para interfaces Roblox com design BladeMenu

local BladeMenu = {}
BladeMenu.Version = "3.0.0"
BladeMenu.Author = "Blade Community"

-- Configurações padrão
BladeMenu.DefaultConfig = {
    Title = "__/BLADEMENU\\__",
    Size = {Width = 520, Height = 340},
    Position = {X = 0.33862, Y = 0.2896},
    Keybind = Enum.KeyCode.RightControl,
    Colors = {
        Background = Color3.fromRGB(27, 27, 27),
        Header = Color3.fromRGB(36, 36, 36),
        Sidebar = Color3.fromRGB(40, 40, 40),
        Content = Color3.fromRGB(48, 48, 48),
        Button = Color3.fromRGB(60, 60, 60),
        ButtonHover = Color3.fromRGB(80, 80, 80),
        Text = Color3.fromRGB(255, 255, 255),
        Accent = Color3.fromRGB(0, 170, 255),
        ToggleOn = Color3.fromRGB(50, 255, 50),
        ToggleOff = Color3.fromRGB(255, 50, 50)
    }
}

-- Serviços
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

-- Função auxiliar para criar instâncias
local function Create(className, props)
    local instance = Instance.new(className)
    for prop, value in pairs(props) do
        if prop == "Parent" then
            instance.Parent = value
        else
            instance[prop] = value
        end
    end
    return instance
end

-- Função para criar um UICorner
local function CreateCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 4)
    corner.Parent = parent
    return corner
end

-- Função para criar UIStroke
local function CreateStroke(parent, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color
    stroke.Thickness = thickness or 1
    stroke.Parent = parent
    return stroke
end

-- Função de notificação
local function ShowNotification(text, duration)
    duration = duration or 3
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Blade MENU",
        Text = text,
        Duration = duration
    })
    print("[Blade MENU] " .. text)
end

-- Função para criar a UI base
local function CreateBaseUI(menu)
    -- ScreenGui principal
    menu.GUI = Create("ScreenGui", {
        Name = "BladeMenu",
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = LocalPlayer:WaitForChild("PlayerGui"),
        ResetOnSpawn = false
    })
    
    -- Frame principal
    menu.MainFrame = Create("Frame", {
        Name = "main",
        Size = UDim2.new(0, menu.Config.Size.Width, 0, menu.Config.Size.Height),
        Position = UDim2.new(menu.Config.Position.X, 0, menu.Config.Position.Y, 0),
        BackgroundColor3 = menu.Config.Colors.Background,
        BorderSizePixel = 0,
        Active = true,
        Draggable = true,
        Parent = menu.GUI
    })
    
    CreateCorner(menu.MainFrame, 8)
    CreateStroke(menu.MainFrame, Color3.fromRGB(60, 60, 60), 2)
    
    -- Header
    menu.Header = Create("Frame", {
        Name = "header",
        Size = UDim2.new(1, 0, 0, 33),
        BackgroundColor3 = menu.Config.Colors.Header,
        BorderSizePixel = 0,
        Parent = menu.MainFrame
    })
    
    CreateCorner(menu.Header, 8)
    
    -- Título
    menu.TitleLabel = Create("TextLabel", {
        Text = menu.Config.Title,
        Size = UDim2.new(0, 200, 1, 0),
        Position = UDim2.new(0.06923, 0, 0, 0),
        BackgroundTransparency = 1,
        TextColor3 = menu.Config.Colors.Text,
        Font = Enum.Font.SourceSansBold,
        TextSize = 20,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = menu.Header
    })
    
    -- Botão Minimizar
    menu.MinButton = Create("ImageButton", {
        Name = "min",
        Size = UDim2.new(0, 24, 0, 28),
        Position = UDim2.new(0.88077, 0, 0.15152, 0),
        BackgroundTransparency = 1,
        Image = "rbxassetid://116825826868178",
        ImageColor3 = menu.Config.Colors.Text,
        Parent = menu.Header
    })
    
    -- Botão Fechar
    menu.CloseButton = Create("ImageButton", {
        Name = "close",
        Size = UDim2.new(0, 24, 0, 28),
        Position = UDim2.new(0.93846, 0, 0.15152, 0),
        BackgroundTransparency = 1,
        Image = "rbxassetid://86827862123860",
        ImageColor3 = menu.Config.Colors.Text,
        Parent = menu.Header
    })
    
    -- Tab Holder (sidebar)
    menu.TabHolder = Create("Frame", {
        Name = "tabholder",
        Size = UDim2.new(0, 90, 0, 292),
        Position = UDim2.new(0.01346, 0, 0.11765, 0),
        BackgroundColor3 = menu.Config.Colors.Sidebar,
        BorderSizePixel = 0,
        Parent = menu.MainFrame
    })
    
    CreateCorner(menu.TabHolder, 6)
    CreateStroke(menu.TabHolder, Color3.fromRGB(60, 60, 60), 1)
    
    -- Content Page
    menu.ContentPage = Create("Frame", {
        Name = "contentpage",
        Size = UDim2.new(0, 406, 0, 292),
        Position = UDim2.new(0.20385, 0, 0.11765, 0),
        BackgroundColor3 = menu.Config.Colors.Content,
        BorderSizePixel = 0,
        Parent = menu.MainFrame
    })
    
    CreateCorner(menu.ContentPage, 6)
    CreateStroke(menu.ContentPage, Color3.fromRGB(60, 60, 60), 1)
    
    -- Content ScrollingFrame
    menu.ContentScroller = Create("ScrollingFrame", {
        Size = UDim2.new(1, -10, 1, -10),
        Position = UDim2.new(0, 5, 0, 5),
        BackgroundTransparency = 1,
        ScrollBarThickness = 6,
        ScrollBarImageColor3 = menu.Config.Colors.Accent,
        BorderSizePixel = 0,
        Parent = menu.ContentPage
    })
    
    menu.ContentLayout = Create("UIListLayout", {
        Padding = UDim.new(0, 10),
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Parent = menu.ContentScroller
    })
    
    menu.ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        menu.ContentScroller.CanvasSize = UDim2.new(0, 0, 0, menu.ContentLayout.AbsoluteContentSize.Y + 20)
    end)
end

-- Função para configurar eventos da UI
local function SetupEvents(menu)
    -- Botão Fechar
    menu.CloseButton.MouseButton1Click:Connect(function()
        menu.GUI.Enabled = false
    end)
    
    -- Botão Minimizar
    local isMinimized = false
    menu.MinButton.MouseButton1Click:Connect(function()
        if isMinimized then
            -- Restaurar
            menu.MainFrame.Size = UDim2.new(0, menu.Config.Size.Width, 0, menu.Config.Size.Height)
            menu.TabHolder.Visible = true
            menu.ContentPage.Visible = true
            isMinimized = false
        else
            -- Minimizar
            menu.MainFrame.Size = UDim2.new(0, menu.Config.Size.Width, 0, 33)
            menu.TabHolder.Visible = false
            menu.ContentPage.Visible = false
            isMinimized = true
        end
    end)
    
    -- Keybind para abrir/fechar
    if menu.Config.Keybind then
        UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if not gameProcessed and input.KeyCode == menu.Config.Keybind then
                menu.GUI.Enabled = not menu.GUI.Enabled
                ShowNotification("Menu " .. (menu.GUI.Enabled and "aberto" or "fechado"), 2)
            end
        end)
    end
    
    -- Fechar com ESC
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == Enum.KeyCode.Escape and menu.GUI.Enabled then
            menu.GUI.Enabled = false
        end
    end)
end

-- Função para criar uma nova aba
local function CreateTab(menu, name, icon)
    -- Criar botão na sidebar
    local tabButton = Create("TextButton", {
        Name = name:lower(),
        Size = UDim2.new(0, 77, 0, 21),
        Position = UDim2.new(0.06667, 0, 0, (#menu.TabHolder:GetChildren() - 1) * 30 + 10),
        BackgroundColor3 = menu.Config.Colors.Button,
        TextColor3 = Color3.fromRGB(0, 0, 0),
        Text = name,
        Font = Enum.Font.SourceSansBold,
        TextSize = 14,
        Parent = menu.TabHolder
    })
    
    CreateCorner(tabButton, 4)
    
    -- Efeito hover
    tabButton.MouseEnter:Connect(function()
        tabButton.BackgroundColor3 = menu.Config.Colors.ButtonHover
    end)
    
    tabButton.MouseLeave:Connect(function()
        tabButton.BackgroundColor3 = menu.Config.Colors.Button
    end)
    
    -- Criar frame de conteúdo
    local tabContent = Create("ScrollingFrame", {
        Name = name:lower(),
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Visible = false,
        ScrollBarThickness = 6,
        ScrollBarImageColor3 = menu.Config.Colors.Accent,
        BorderSizePixel = 0,
        Parent = menu.ContentScroller
    })
    
    local layout = Create("UIListLayout", {
        Padding = UDim.new(0, 10),
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Parent = tabContent
    })
    
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tabContent.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 20)
    end)
    
    -- Mostrar essa aba ao clicar
    tabButton.MouseButton1Click:Connect(function()
        for _, child in pairs(menu.ContentScroller:GetChildren()) do
            if child:IsA("ScrollingFrame") and child.Name ~= "UIPadding" then
                child.Visible = false
            end
        end
        tabContent.Visible = true
        menu.ActiveTab = name:lower()
    end)
    
    -- Métodos da tab
    local tabMethods = {}
    
    function tabMethods:AddButton(text, callback)
        local button = Create("TextButton", {
            Size = UDim2.new(0, 150, 0, 30),
            BackgroundColor3 = menu.Config.Colors.Button,
            TextColor3 = menu.Config.Colors.Text,
            Text = text,
            Font = Enum.Font.SourceSansBold,
            TextSize = 14,
            Parent = tabContent
        })
        
        CreateCorner(button, 4)
        
        button.MouseEnter:Connect(function()
            button.BackgroundColor3 = menu.Config.Colors.ButtonHover
        end)
        
        button.MouseLeave:Connect(function()
            button.BackgroundColor3 = menu.Config.Colors.Button
        end)
        
        button.MouseButton1Click:Connect(callback)
        
        return button
    end
    
    function tabMethods:AddToggle(text, default, callback)
        local toggleFrame = Create("Frame", {
            Size = UDim2.new(0, 150, 0, 30),
            BackgroundTransparency = 1,
            Parent = tabContent
        })
        
        local toggleText = Create("TextLabel", {
            Size = UDim2.new(0.7, 0, 1, 0),
            BackgroundTransparency = 1,
            TextColor3 = menu.Config.Colors.Text,
            Text = text,
            Font = Enum.Font.SourceSans,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = toggleFrame
        })
        
        local toggleButton = Create("TextButton", {
            Size = UDim2.new(0, 30, 0, 20),
            Position = UDim2.new(0.8, -15, 0.5, -10),
            BackgroundColor3 = default and menu.Config.Colors.ToggleOn or menu.Config.Colors.ToggleOff,
            Text = "",
            Parent = toggleFrame
        })
        
        CreateCorner(toggleButton, 4)
        
        local state = default or false
        
        local function updateToggle()
            toggleButton.BackgroundColor3 = state and menu.Config.Colors.ToggleOn or menu.Config.Colors.ToggleOff
        end
        
        toggleButton.MouseButton1Click:Connect(function()
            state = not state
            updateToggle()
            if callback then callback(state) end
        end)
        
        return {Frame = toggleFrame, SetState = function(newState) state = newState; updateToggle() end, GetState = function() return state end}
    end
    
    function tabMethods:AddLabel(text, size)
        local label = Create("TextLabel", {
            Size = UDim2.new(0, 150, 0, size or 25),
            BackgroundTransparency = 1,
            TextColor3 = menu.Config.Colors.Text,
            Text = text,
            Font = Enum.Font.SourceSansBold,
            TextSize = size and math.min(size, 16) or 16,
            TextWrapped = true,
            Parent = tabContent
        })
        
        return label
    end
    
    function tabMethods:AddSlider(name, min, max, default, callback)
        local sliderFrame = Create("Frame", {
            Size = UDim2.new(0, 150, 0, 50),
            BackgroundTransparency = 1,
            Parent = tabContent
        })
        
        local sliderName = Create("TextLabel", {
            Size = UDim2.new(1, 0, 0, 20),
            BackgroundTransparency = 1,
            TextColor3 = menu.Config.Colors.Text,
            Text = name,
            Font = Enum.Font.SourceSans,
            TextSize = 14,
            Parent = sliderFrame
        })
        
        local sliderTrack = Create("Frame", {
            Size = UDim2.new(1, 0, 0, 5),
            Position = UDim2.new(0, 0, 0, 25),
            BackgroundColor3 = Color3.fromRGB(80, 80, 80),
            Parent = sliderFrame
        })
        
        CreateCorner(sliderTrack, 3)
        
        local sliderFill = Create("Frame", {
            Size = UDim2.new((default - min) / (max - min), 0, 1, 0),
            BackgroundColor3 = menu.Config.Colors.Accent,
            Parent = sliderTrack
        })
        
        CreateCorner(sliderFill, 3)
        
        local sliderButton = Create("TextButton", {
            Size = UDim2.new(0, 15, 0, 15),
            Position = UDim2.new((default - min) / (max - min), -7, 0.5, -7),
            BackgroundColor3 = menu.Config.Colors.Text,
            Text = "",
            Parent = sliderFrame
        })
        
        CreateCorner(sliderButton, 7)
        
        local sliderValue = Create("TextLabel", {
            Size = UDim2.new(1, 0, 0, 15),
            Position = UDim2.new(0, 0, 0, 35),
            BackgroundTransparency = 1,
            TextColor3 = menu.Config.Colors.Text,
            Text = tostring(default),
            Font = Enum.Font.SourceSans,
            TextSize = 12,
            Parent = sliderFrame
        })
        
        local dragging = false
        local currentValue = default
        
        local function updateSlider(value)
            value = math.clamp(value, min, max)
            currentValue = value
            sliderFill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
            sliderButton.Position = UDim2.new((value - min) / (max - min), -7, 0.5, -7)
            sliderValue.Text = string.format("%.2f", value)
            
            if callback then callback(value) end
        end
        
        sliderButton.MouseButton1Down:Connect(function()
            dragging = true
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        
        sliderTrack.MouseButton1Down:Connect(function(x, y)
            local relativeX = x - sliderTrack.AbsolutePosition.X
            local percentage = math.clamp(relativeX / sliderTrack.AbsoluteSize.X, 0, 1)
            updateSlider(min + (max - min) * percentage)
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local relativeX = input.Position.X - sliderTrack.AbsolutePosition.X
                local percentage = math.clamp(relativeX / sliderTrack.AbsoluteSize.X, 0, 1)
                updateSlider(min + (max - min) * percentage)
            end
        end)
        
        return {Frame = sliderFrame, GetValue = function() return currentValue end, SetValue = updateSlider}
    end
    
    function tabMethods:AddDropdown(name, options, defaultIndex, callback)
        local dropdownFrame = Create("Frame", {
            Size = UDim2.new(0, 150, 0, 30),
            BackgroundColor3 = menu.Config.Colors.Button,
            Parent = tabContent
        })
        
        CreateCorner(dropdownFrame, 4)
        
        local dropdownText = Create("TextLabel", {
            Size = UDim2.new(0.8, 0, 1, 0),
            BackgroundTransparency = 1,
            TextColor3 = menu.Config.Colors.Text,
            Text = name .. ": " .. (options[defaultIndex or 1] or ""),
            Font = Enum.Font.SourceSans,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = dropdownFrame
        })
        
        local dropdownButton = Create("TextButton", {
            Size = UDim2.new(0, 30, 0, 30),
            Position = UDim2.new(0.8, 0, 0, 0),
            BackgroundColor3 = Color3.fromRGB(70, 70, 70),
            Text = "▼",
            TextColor3 = menu.Config.Colors.Text,
            Font = Enum.Font.SourceSansBold,
            TextSize = 12,
            Parent = dropdownFrame
        })
        
        CreateCorner(dropdownButton, 4)
        
        local dropdownList = Create("ScrollingFrame", {
            Size = UDim2.new(1, 0, 0, 0),
            Position = UDim2.new(0, 0, 1, 2),
            BackgroundColor3 = menu.Config.Colors.Button,
            Visible = false,
            ScrollBarThickness = 4,
            BorderSizePixel = 0,
            Parent = dropdownFrame
        })
        
        CreateCorner(dropdownList, 4)
        
        local listLayout = Create("UIListLayout", {
            Parent = dropdownList
        })
        
        local isOpen = false
        local selectedOption = options[defaultIndex or 1]
        
        local function updateDropdown()
            dropdownText.Text = name .. ": " .. selectedOption
        end
        
        local function toggleDropdown()
            isOpen = not isOpen
            dropdownList.Visible = isOpen
            dropdownButton.Text = isOpen and "▲" or "▼"
            
            if isOpen then
                dropdownList.Size = UDim2.new(1, 0, 0, math.min(#options * 25, 150))
            else
                dropdownList.Size = UDim2.new(1, 0, 0, 0)
            end
        end
        
        -- Preencher opções
        for i, option in ipairs(options) do
            local optionButton = Create("TextButton", {
                Size = UDim2.new(1, -4, 0, 25),
                Position = UDim2.new(0, 2, 0, (i-1)*25),
                BackgroundColor3 = Color3.fromRGB(50, 50, 50),
                TextColor3 = menu.Config.Colors.Text,
                Text = option,
                Font = Enum.Font.SourceSans,
                TextSize = 12,
                Parent = dropdownList
            })
            
            CreateCorner(optionButton, 2)
            
            optionButton.MouseEnter:Connect(function()
                optionButton.BackgroundColor3 = menu.Config.Colors.ButtonHover
            end)
            
            optionButton.MouseLeave:Connect(function()
                optionButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            end)
            
            optionButton.MouseButton1Click:Connect(function()
                selectedOption = option
                updateDropdown()
                toggleDropdown()
                if callback then callback(option) end
            end)
        end
        
        dropdownButton.MouseButton1Click:Connect(toggleDropdown)
        
        -- Fechar dropdown ao clicar fora
        UserInputService.InputBegan:Connect(function(input)
            if isOpen and input.UserInputType == Enum.UserInputType.MouseButton1 then
                local mousePos = input.Position
                local framePos = dropdownFrame.AbsolutePosition
                local frameSize = dropdownFrame.AbsoluteSize
                
                if mousePos.X < framePos.X or mousePos.X > framePos.X + frameSize.X or
                   mousePos.Y < framePos.Y or mousePos.Y > framePos.Y + frameSize.Y + dropdownList.AbsoluteSize.Y then
                    toggleDropdown()
                end
            end
        end)
        
        updateDropdown()
        
        return {Frame = dropdownFrame, GetValue = function() return selectedOption end, SetValue = function(val) selectedOption = val; updateDropdown() end}
    end
    
    function tabMethods:AddTextBox(placeholder, callback)
        local textBoxFrame = Create("Frame", {
            Size = UDim2.new(0, 150, 0, 30),
            BackgroundColor3 = menu.Config.Colors.Button,
            Parent = tabContent
        })
        
        CreateCorner(textBoxFrame, 4)
        
        local textBox = Create("TextBox", {
            Size = UDim2.new(1, -10, 1, -10),
            Position = UDim2.new(0, 5, 0, 5),
            BackgroundTransparency = 1,
            TextColor3 = menu.Config.Colors.Text,
            PlaceholderText = placeholder,
            PlaceholderColor3 = Color3.fromRGB(150, 150, 150),
            Font = Enum.Font.SourceSans,
            TextSize = 14,
            ClearTextOnFocus = false,
            Parent = textBoxFrame
        })
        
        textBox.FocusLost:Connect(function(enterPressed)
            if enterPressed and callback then
                callback(textBox.Text)
                textBox.Text = ""
            end
        end)
        
        return {Frame = textBoxFrame, GetText = function() return textBox.Text end, SetText = function(text) textBox.Text = text end}
    end
    
    function tabMethods:AddSeparator()
        local separator = Create("Frame", {
            Size = UDim2.new(0, 150, 0, 1),
            BackgroundColor3 = Color3.fromRGB(100, 100, 100),
            Parent = tabContent
        })
        
        return separator
    end
    
    -- Armazenar referência da tab
    menu.Tabs[name:lower()] = {
        Button = tabButton,
        Content = tabContent,
        Methods = tabMethods
    }
    
    -- Se for a primeira tab, mostrar ela
    if #menu.TabHolder:GetChildren() == 1 then
        tabContent.Visible = true
        menu.ActiveTab = name:lower()
    end
    
    return tabMethods
end

-- Função principal de inicialização
function BladeMenu.Init(config)
    -- Mesclar configurações
    local mergedConfig = {}
    for k, v in pairs(BladeMenu.DefaultConfig) do
        mergedConfig[k] = v
    end
    
    if config then
        for k, v in pairs(config) do
            if k == "Colors" then
                mergedConfig.Colors = mergedConfig.Colors or {}
                for colorKey, colorValue in pairs(v) do
                    mergedConfig.Colors[colorKey] = colorValue
                end
            else
                mergedConfig[k] = v
            end
        end
    end
    
    -- Criar objeto do menu
    local menu = {
        Config = mergedConfig,
        GUI = nil,
        MainFrame = nil,
        Header = nil,
        TabHolder = nil,
        ContentPage = nil,
        ContentScroller = nil,
        ContentLayout = nil,
        TitleLabel = nil,
        MinButton = nil,
        CloseButton = nil,
        ActiveTab = nil,
        Tabs = {},
        IsEnabled = true
    }
    
    -- Métodos públicos
    function menu:CreateTab(name, icon)
        return CreateTab(self, name, icon)
    end
    
    function menu:Toggle()
        self.GUI.Enabled = not self.GUI.Enabled
        self.IsEnabled = self.GUI.Enabled
        ShowNotification("Menu " .. (self.GUI.Enabled and "aberto" or "fechado"), 2)
    end
    
    function menu:Show()
        self.GUI.Enabled = true
        self.IsEnabled = true
    end
    
    function menu:Hide()
        self.GUI.Enabled = false
        self.IsEnabled = false
    end
    
    function menu:IsVisible()
        return self.GUI.Enabled
    end
    
    function menu:Notify(text, duration)
        ShowNotification(text, duration)
    end
    
    function menu:SetTitle(title)
        self.Config.Title = title
        if self.TitleLabel then
            self.TitleLabel.Text = title
        end
    end
    
    function menu:SetSize(width, height)
        self.Config.Size = {Width = width, Height = height}
        if self.MainFrame then
            self.MainFrame.Size = UDim2.new(0, width, 0, height)
        end
    end
    
    function menu:SetPosition(x, y)
        self.Config.Position = {X = x, Y = y}
        if self.MainFrame then
            self.MainFrame.Position = UDim2.new(x, 0, y, 0)
        end
    end
    
    function menu:SetKeybind(key)
        self.Config.Keybind = key
    end
    
    function menu:GetTab(name)
        return self.Tabs[name:lower()] and self.Tabs[name:lower()].Methods or nil
    end
    
    function menu:ShowTab(name)
        for tabName, tabData in pairs(self.Tabs) do
            tabData.Content.Visible = (tabName == name:lower())
        end
        self.ActiveTab = name:lower()
    end
    
    function menu:Destroy()
        if self.GUI then
            self.GUI:Destroy()
        end
    end
    
    -- Criar a UI
    CreateBaseUI(menu)
    SetupEvents(menu)
    
    -- Notificação inicial
    ShowNotification("Blade MENU v" .. BladeMenu.Version .. " carregado!", 3)
    
    return menu
end

-- Exportar
return BladeMenu
