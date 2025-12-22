-- BladeMenu Library v2.0
-- Uma library moderna para interfaces Roblox com a aparência do BladeMenu

local BladeMenu = {}
BladeMenu.__index = BladeMenu

-- Configurações padrão
BladeMenu.Colors = {
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

BladeMenu.Version = "2.1.250"
BladeMenu.Author = "Blade Community"

-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Função de inicialização (sem setmetatable, usando abordagem explícita)
function BladeMenu.Init(config)
    local self = {}
    
    -- Configurações
    self.Settings = {
        Title = config and config.Title or "__/BLADEMENU\\__",
        Size = config and config.Size or {Width = 520, Height = 340},
        Position = config and config.Position or {X = 0.33862, Y = 0.2896},
        Colors = config and config.Colors or BladeMenu.Colors,
        Keybind = config and config.Keybind or Enum.KeyCode.RightControl
    }
    
    -- Elementos da UI
    self.GUI = nil
    self.MainFrame = nil
    self.Header = nil
    self.TabHolder = nil
    self.ContentPage = nil
    
    -- Tabs
    self.Tabs = {}
    self.CurrentTab = nil
    
    -- Inicializar a interface
    self:CreateUI()
    
    -- Configurar keybind
    if self.Settings.Keybind then
        UserInputService.InputBegan:Connect(function(input)
            if input.KeyCode == self.Settings.Keybind then
                self:Toggle()
            end
        end)
    end
    
    -- Notificação inicial
    self:Notify("Blade MENU v" .. BladeMenu.Version .. " carregado!", 5)
    
    return self
end

-- Função para criar a UI base
function BladeMenu:CreateUI()
    -- ScreenGui
    self.GUI = Instance.new("ScreenGui")
    self.GUI.Name = "BladeMenu"
    self.GUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.GUI.Parent = LocalPlayer:WaitForChild("PlayerGui")
    
    -- Main Frame
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Name = "main"
    self.MainFrame.Size = UDim2.new(0, self.Settings.Size.Width, 0, self.Settings.Size.Height)
    self.MainFrame.Position = UDim2.new(self.Settings.Position.X, 0, self.Settings.Position.Y, 0)
    self.MainFrame.BackgroundColor3 = self.Settings.Colors.Background
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.Active = true
    self.MainFrame.Draggable = true
    self.MainFrame.Parent = self.GUI
    
    -- Header
    self.Header = Instance.new("Frame")
    self.Header.Name = "header"
    self.Header.Size = UDim2.new(1, 0, 0, 33)
    self.Header.BackgroundColor3 = self.Settings.Colors.Header
    self.Header.BorderSizePixel = 0
    self.Header.Parent = self.MainFrame
    
    local title = Instance.new("TextLabel")
    title.Text = self.Settings.Title
    title.Size = UDim2.new(0, 200, 1, 0)
    title.Position = UDim2.new(0.06923, 0, 0, 0)
    title.BackgroundTransparency = 1
    title.TextColor3 = self.Settings.Colors.Text
    title.Font = Enum.Font.SourceSans
    title.TextSize = 24
    title.Parent = self.Header
    
    local closeBtn = Instance.new("ImageButton")
    closeBtn.Name = "close"
    closeBtn.Size = UDim2.new(0, 24, 0, 28)
    closeBtn.Position = UDim2.new(0.93846, 0, 0.15152, 0)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Image = "rbxassetid://86827862123860"
    closeBtn.Parent = self.Header
    
    local minBtn = Instance.new("ImageButton")
    minBtn.Name = "min"
    minBtn.Size = UDim2.new(0, 24, 0, 28)
    minBtn.Position = UDim2.new(0.88077, 0, 0.15152, 0)
    minBtn.BackgroundTransparency = 1
    minBtn.Image = "rbxassetid://116825826868178"
    minBtn.Parent = self.Header
    
    -- Tab Holder (sidebar)
    self.TabHolder = Instance.new("Frame")
    self.TabHolder.Name = "tabholder"
    self.TabHolder.Size = UDim2.new(0, 90, 0, 292)
    self.TabHolder.Position = UDim2.new(0.01346, 0, 0.11765, 0)
    self.TabHolder.BackgroundColor3 = self.Settings.Colors.Sidebar
    self.TabHolder.BorderSizePixel = 0
    self.TabHolder.Parent = self.MainFrame
    
    -- Content Page
    self.ContentPage = Instance.new("Frame")
    self.ContentPage.Name = "contentpage"
    self.ContentPage.Size = UDim2.new(0, 406, 0, 292)
    self.ContentPage.Position = UDim2.new(0.20385, 0, 0.11765, 0)
    self.ContentPage.BackgroundColor3 = self.Settings.Colors.Content
    self.ContentPage.BorderSizePixel = 0
    self.ContentPage.ClipsDescendants = true
    self.ContentPage.Parent = self.MainFrame
    
    -- Configurar eventos dos botões do header
    closeBtn.MouseButton1Click:Connect(function()
        self.GUI.Enabled = false
    end)
    
    minBtn.MouseButton1Click:Connect(function()
        if self.MainFrame.Size.Y.Offset == 33 then
            self.MainFrame.Size = UDim2.new(0, self.Settings.Size.Width, 0, self.Settings.Size.Height)
        else
            self.MainFrame.Size = UDim2.new(0, self.Settings.Size.Width, 0, 33)
        end
    end)
end

-- Função para criar uma nova aba
function BladeMenu:CreateTab(name, icon)
    local tabButton = Instance.new("TextButton")
    tabButton.Name = name
    tabButton.Size = UDim2.new(0, 77, 0, 21)
    tabButton.Position = UDim2.new(0.06667, 0, 0, (#self.TabHolder:GetChildren() - 1) * 25 + 10)
    tabButton.BackgroundColor3 = self.Settings.Colors.Button
    tabButton.TextColor3 = Color3.fromRGB(0, 0, 0)
    tabButton.Text = name
    tabButton.Font = Enum.Font.SourceSans
    tabButton.TextSize = 14
    tabButton.Parent = self.TabHolder
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = tabButton
    
    -- Criar frame de conteúdo para a aba
    local tabContent = Instance.new("ScrollingFrame")
    tabContent.Name = name
    tabContent.Size = UDim2.new(1, 0, 1, 0)
    tabContent.BackgroundTransparency = 1
    tabContent.Visible = false
    tabContent.ScrollBarThickness = 6
    tabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
    tabContent.Parent = self.ContentPage
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 5)
    layout.Parent = tabContent
    
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 10)
    padding.PaddingLeft = UDim.new(0, 10)
    padding.Parent = tabContent
    
    -- Efeito hover
    tabButton.MouseEnter:Connect(function()
        tabButton.BackgroundColor3 = self.Settings.Colors.ButtonHover
    end)
    
    tabButton.MouseLeave:Connect(function()
        tabButton.BackgroundColor3 = self.Settings.Colors.Button
    end)
    
    -- Sistema de navegação entre abas
    local function showTab()
        for _, child in pairs(self.ContentPage:GetChildren()) do
            if child:IsA("ScrollingFrame") then
                child.Visible = false
            end
        end
        tabContent.Visible = true
        self.CurrentTab = name
    end
    
    tabButton.MouseButton1Click:Connect(showTab)
    
    -- Adicionar à lista de tabs
    self.Tabs[name] = {
        Button = tabButton,
        Content = tabContent,
        Elements = {}
    }
    
    -- Retornar métodos para adicionar elementos
    local tabMethods = {}
    
    function tabMethods:AddButton(text, callback)
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(0, 150, 0, 30)
        button.BackgroundColor3 = self.Settings.Colors.Button
        button.TextColor3 = self.Settings.Colors.Text
        button.Text = text
        button.Font = Enum.Font.SourceSansBold
        button.TextSize = 14
        button.Parent = tabContent
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 4)
        corner.Parent = button
        
        button.MouseEnter:Connect(function()
            button.BackgroundColor3 = self.Settings.Colors.ButtonHover
        end)
        
        button.MouseLeave:Connect(function()
            button.BackgroundColor3 = self.Settings.Colors.Button
        end)
        
        button.MouseButton1Click:Connect(callback)
        
        table.insert(self.Tabs[name].Elements, button)
        return button
    end
    
    function tabMethods:AddToggle(text, default, callback)
        local toggleFrame = Instance.new("Frame")
        toggleFrame.Size = UDim2.new(0, 150, 0, 30)
        toggleFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        toggleFrame.Parent = tabContent
        
        local toggleText = Instance.new("TextLabel")
        toggleText.Size = UDim2.new(0.7, 0, 1, 0)
        toggleText.BackgroundTransparency = 1
        toggleText.TextColor3 = self.Settings.Colors.Text
        toggleText.Text = text
        toggleText.Font = Enum.Font.SourceSans
        toggleText.TextSize = 14
        toggleText.TextXAlignment = Enum.TextXAlignment.Left
        toggleText.Parent = toggleFrame
        
        local toggleButton = Instance.new("TextButton")
        toggleButton.Size = UDim2.new(0, 30, 0, 20)
        toggleButton.Position = UDim2.new(0.8, -15, 0.5, -10)
        toggleButton.BackgroundColor3 = default and self.Settings.Colors.ToggleOn or self.Settings.Colors.ToggleOff
        toggleButton.Text = ""
        toggleButton.Parent = toggleFrame
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 4)
        corner.Parent = toggleButton
        
        local state = default or false
        
        local function updateToggle()
            if state then
                toggleButton.BackgroundColor3 = self.Settings.Colors.ToggleOn
            else
                toggleButton.BackgroundColor3 = self.Settings.Colors.ToggleOff
            end
        end
        
        toggleButton.MouseButton1Click:Connect(function()
            state = not state
            updateToggle()
            if callback then callback(state) end
        end)
        
        table.insert(self.Tabs[name].Elements, toggleFrame)
        return toggleFrame
    end
    
    function tabMethods:AddLabel(text)
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0, 150, 0, 25)
        label.BackgroundTransparency = 1
        label.TextColor3 = self.Settings.Colors.Text
        label.Text = text
        label.Font = Enum.Font.SourceSansBold
        label.TextSize = 16
        label.Parent = tabContent
        
        table.insert(self.Tabs[name].Elements, label)
        return label
    end
    
    function tabMethods:AddSlider(name, min, max, default, callback)
        local sliderFrame = Instance.new("Frame")
        sliderFrame.Size = UDim2.new(0, 150, 0, 50)
        sliderFrame.BackgroundTransparency = 1
        sliderFrame.Parent = tabContent
        
        local sliderName = Instance.new("TextLabel")
        sliderName.Size = UDim2.new(1, 0, 0, 20)
        sliderName.BackgroundTransparency = 1
        sliderName.TextColor3 = self.Settings.Colors.Text
        sliderName.Text = name
        sliderName.Font = Enum.Font.SourceSans
        sliderName.TextSize = 14
        sliderName.Parent = sliderFrame
        
        local sliderTrack = Instance.new("Frame")
        sliderTrack.Size = UDim2.new(1, 0, 0, 5)
        sliderTrack.Position = UDim2.new(0, 0, 0, 25)
        sliderTrack.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        sliderTrack.Parent = sliderFrame
        
        local sliderFill = Instance.new("Frame")
        sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
        sliderFill.BackgroundColor3 = self.Settings.Colors.Accent
        sliderFill.Parent = sliderTrack
        
        local sliderButton = Instance.new("TextButton")
        sliderButton.Size = UDim2.new(0, 15, 0, 15)
        sliderButton.Position = UDim2.new((default - min) / (max - min), -7, 0.5, -7)
        sliderButton.BackgroundColor3 = self.Settings.Colors.Text
        sliderButton.Text = ""
        sliderButton.Parent = sliderFrame
        
        local sliderValue = Instance.new("TextLabel")
        sliderValue.Size = UDim2.new(1, 0, 0, 15)
        sliderValue.Position = UDim2.new(0, 0, 0, 35)
        sliderValue.BackgroundTransparency = 1
        sliderValue.TextColor3 = self.Settings.Colors.Text
        sliderValue.Text = tostring(default)
        sliderValue.Font = Enum.Font.SourceSans
        sliderValue.TextSize = 12
        sliderValue.Parent = sliderFrame
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 7)
        corner.Parent = sliderButton
        
        local dragging = false
        local currentValue = default
        
        local function updateSlider(value)
            value = math.clamp(value, min, max)
            currentValue = value
            sliderFill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
            sliderButton.Position = UDim2.new((value - min) / (max - min), -7, 0.5, -7)
            sliderValue.Text = tostring(math.floor(value * 100) / 100)
            
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
            local percentage = relativeX / sliderTrack.AbsoluteSize.X
            updateSlider(min + (max - min) * percentage)
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local relativeX = input.Position.X - sliderTrack.AbsolutePosition.X
                local percentage = math.clamp(relativeX / sliderTrack.AbsoluteSize.X, 0, 1)
                updateSlider(min + (max - min) * percentage)
            end
        end)
        
        table.insert(self.Tabs[name].Elements, sliderFrame)
        return sliderFrame
    end
    
    function tabMethods:AddDropdown(name, options, callback)
        local dropdownFrame = Instance.new("Frame")
        dropdownFrame.Size = UDim2.new(0, 150, 0, 30)
        dropdownFrame.BackgroundColor3 = self.Settings.Colors.Button
        dropdownFrame.Parent = tabContent
        
        local dropdownText = Instance.new("TextLabel")
        dropdownText.Size = UDim2.new(0.8, 0, 1, 0)
        dropdownText.BackgroundTransparency = 1
        dropdownText.TextColor3 = self.Settings.Colors.Text
        dropdownText.Text = name .. ": " .. options[1]
        dropdownText.Font = Enum.Font.SourceSans
        dropdownText.TextSize = 14
        dropdownText.TextXAlignment = Enum.TextXAlignment.Left
        dropdownText.Parent = dropdownFrame
        
        local dropdownButton = Instance.new("TextButton")
        dropdownButton.Size = UDim2.new(0, 30, 0, 30)
        dropdownButton.Position = UDim2.new(0.8, 0, 0, 0)
        dropdownButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        dropdownButton.Text = "▼"
        dropdownButton.TextColor3 = self.Settings.Colors.Text
        dropdownButton.Font = Enum.Font.SourceSansBold
        dropdownButton.TextSize = 12
        dropdownButton.Parent = dropdownFrame
        
        local dropdownList = Instance.new("ScrollingFrame")
        dropdownList.Size = UDim2.new(1, 0, 0, 0)
        dropdownList.Position = UDim2.new(0, 0, 1, 2)
        dropdownList.BackgroundColor3 = self.Settings.Colors.Button
        dropdownList.Visible = false
        dropdownList.ScrollBarThickness = 4
        dropdownList.Parent = dropdownFrame
        
        local listLayout = Instance.new("UIListLayout")
        listLayout.Parent = dropdownList
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 4)
        corner.Parent = dropdownFrame
        
        local isOpen = false
        local selectedOption = options[1]
        
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
            local optionButton = Instance.new("TextButton")
            optionButton.Size = UDim2.new(1, 0, 0, 25)
            optionButton.Position = UDim2.new(0, 0, 0, (i-1)*25)
            optionButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            optionButton.TextColor3 = self.Settings.Colors.Text
            optionButton.Text = option
            optionButton.Font = Enum.Font.SourceSans
            optionButton.TextSize = 12
            optionButton.Parent = dropdownList
            
            optionButton.MouseButton1Click:Connect(function()
                selectedOption = option
                updateDropdown()
                toggleDropdown()
                if callback then callback(option) end
            end)
        end
        
        dropdownButton.MouseButton1Click:Connect(toggleDropdown)
        
        table.insert(self.Tabs[name].Elements, dropdownFrame)
        return dropdownFrame
    end
    
    function tabMethods:AddTextBox(placeholder, callback)
        local textBoxFrame = Instance.new("Frame")
        textBoxFrame.Size = UDim2.new(0, 150, 0, 30)
        textBoxFrame.BackgroundColor3 = self.Settings.Colors.Button
        textBoxFrame.Parent = tabContent
        
        local textBox = Instance.new("TextBox")
        textBox.Size = UDim2.new(1, -10, 1, -10)
        textBox.Position = UDim2.new(0, 5, 0, 5)
        textBox.BackgroundTransparency = 1
        textBox.TextColor3 = self.Settings.Colors.Text
        textBox.PlaceholderText = placeholder
        textBox.Font = Enum.Font.SourceSans
        textBox.TextSize = 14
        textBox.ClearTextOnFocus = false
        textBox.Parent = textBoxFrame
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 4)
        corner.Parent = textBoxFrame
        
        textBox.FocusLost:Connect(function(enterPressed)
            if enterPressed and callback then
                callback(textBox.Text)
            end
        end)
        
        table.insert(self.Tabs[name].Elements, textBoxFrame)
        return textBox
    end
    
    function tabMethods:AddSeparator()
        local separator = Instance.new("Frame")
        separator.Size = UDim2.new(0, 150, 0, 1)
        separator.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        separator.Parent = tabContent
        
        table.insert(self.Tabs[name].Elements, separator)
        return separator
    end
    
    -- Mostrar a primeira aba criada
    if not self.CurrentTab then
        showTab()
    end
    
    return tabMethods
end

-- Função para mostrar/esconder o menu
function BladeMenu:Toggle()
    self.GUI.Enabled = not self.GUI.Enabled
end

-- Função para mostrar notificação
function BladeMenu:Notify(text, duration)
    duration = duration or 3
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Blade MENU",
        Text = text,
        Duration = duration
    })
    print("[Blade MENU] " .. text)
end

-- Função para obter uma aba pelo nome
function BladeMenu:GetTab(name)
    return self.Tabs[name]
end

-- Função para mostrar uma aba específica
function BladeMenu:ShowTab(name)
    local tab = self.Tabs[name]
    if tab then
        for tabName, tabData in pairs(self.Tabs) do
            tabData.Content.Visible = false
        end
        tab.Content.Visible = true
        self.CurrentTab = name
    end
end

-- Função para mudar o título
function BladeMenu:SetTitle(newTitle)
    self.Settings.Title = newTitle
    self.Header.TextLabel.Text = newTitle
end

-- Função para mudar o tamanho
function BladeMenu:SetSize(width, height)
    self.Settings.Size = {Width = width, Height = height}
    self.MainFrame.Size = UDim2.new(0, width, 0, height)
end

-- Função para mudar a posição
function BladeMenu:SetPosition(x, y)
    self.Settings.Position = {X = x, Y = y}
    self.MainFrame.Position = UDim2.new(x, 0, y, 0)
end

-- Função para mudar uma cor específica
function BladeMenu:SetColor(colorName, color)
    self.Settings.Colors[colorName] = color
    -- Aqui você pode adicionar a lógica para atualizar a UI dinamicamente se necessário
end

-- Função para mudar o keybind
function BladeMenu:SetKeybind(newKey)
    self.Settings.Keybind = newKey
end

-- Função para exportar como loadstring
local function LoadBladeMenu()
    return BladeMenu
end

return LoadBladeMenu()
