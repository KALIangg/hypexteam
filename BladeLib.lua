-- BladeMenu Library
-- Uma library moderna para interfaces Roblox com a aparência do BladeMenu

local BladeMenu = {}
BladeMenu.__index = BladeMenu

-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Cores padrão
BladeMenu.Colors = {
    Background = Color3.fromRGB(27, 27, 27),
    Header = Color3.fromRGB(36, 36, 36),
    Sidebar = Color3.fromRGB(40, 40, 40),
    Content = Color3.fromRGB(48, 48, 48),
    Button = Color3.fromRGB(60, 60, 60),
    ButtonHover = Color3.fromRGB(80, 80, 80),
    Text = Color3.fromRGB(255, 255, 255),
    Accent = Color3.fromRGB(0, 170, 255)
}

-- Notificações
local function createNotification(text, duration)
    duration = duration or 3
    game.StarterGui:SetCore("SendNotification", {
        Title = "Blade MENU",
        Text = text,
        Duration = duration
    })
    print("[Blade MENU] " .. text)
end

-- Função para criar a UI base
function BladeMenu:CreateUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "BladeMenu"
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    
    local main = Instance.new("Frame")
    main.Name = "main"
    main.Size = UDim2.new(0, 520, 0, 340)
    main.Position = UDim2.new(0.33862, 0, 0.2896, 0)
    main.BackgroundColor3 = self.Colors.Background
    main.BorderSizePixel = 0
    main.Active = true
    main.Draggable = true
    main.Parent = screenGui
    
    -- Header
    local header = Instance.new("Frame")
    header.Name = "header"
    header.Size = UDim2.new(1, 0, 0, 33)
    header.BackgroundColor3 = self.Colors.Header
    header.BorderSizePixel = 0
    header.Parent = main
    
    local title = Instance.new("TextLabel")
    title.Text = "__/BLADEMENU\\__"
    title.Size = UDim2.new(0, 200, 1, 0)
    title.Position = UDim2.new(0.06923, 0, 0, 0)
    title.BackgroundTransparency = 1
    title.TextColor3 = self.Colors.Text
    title.Font = Enum.Font.SourceSans
    title.TextSize = 24
    title.Parent = header
    
    local closeBtn = Instance.new("ImageButton")
    closeBtn.Name = "close"
    closeBtn.Size = UDim2.new(0, 24, 0, 28)
    closeBtn.Position = UDim2.new(0.93846, 0, 0.15152, 0)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Image = "rbxassetid://86827862123860"
    closeBtn.Parent = header
    
    local minBtn = Instance.new("ImageButton")
    minBtn.Name = "min"
    minBtn.Size = UDim2.new(0, 24, 0, 28)
    minBtn.Position = UDim2.new(0.88077, 0, 0.15152, 0)
    minBtn.BackgroundTransparency = 1
    minBtn.Image = "rbxassetid://116825826868178"
    minBtn.Parent = header
    
    -- Tab Holder
    local tabholder = Instance.new("Frame")
    tabholder.Name = "tabholder"
    tabholder.Size = UDim2.new(0, 90, 0, 292)
    tabholder.Position = UDim2.new(0.01346, 0, 0.11765, 0)
    tabholder.BackgroundColor3 = self.Colors.Sidebar
    tabholder.BorderSizePixel = 0
    tabholder.Parent = main
    
    -- Content Page
    local contentpage = Instance.new("Frame")
    contentpage.Name = "contentpage"
    contentpage.Size = UDim2.new(0, 406, 0, 292)
    contentpage.Position = UDim2.new(0.20385, 0, 0.11765, 0)
    contentpage.BackgroundColor3 = self.Colors.Content
    contentpage.BorderSizePixel = 0
    contentpage.ClipsDescendants = true
    contentpage.Parent = main
    
    self.GUI = screenGui
    self.Main = main
    self.Header = header
    self.TabHolder = tabholder
    self.ContentPage = contentpage
    
    -- Configurar eventos
    closeBtn.MouseButton1Click:Connect(function()
        screenGui.Enabled = false
    end)
    
    minBtn.MouseButton1Click:Connect(function()
        if main.Size.Y.Offset == 33 then
            main.Size = UDim2.new(0, 520, 0, 340)
        else
            main.Size = UDim2.new(0, 520, 0, 33)
        end
    end)
    
    return self
end

-- Função para criar uma nova aba
function BladeMenu:CreateTab(name)
    local tabButton = Instance.new("TextButton")
    tabButton.Name = name:lower()
    tabButton.Size = UDim2.new(0, 77, 0, 21)
    tabButton.Position = UDim2.new(0.06667, 0, 0, (#self.TabHolder:GetChildren() - 1) * 25 + 10)
    tabButton.BackgroundColor3 = self.Colors.Button
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
    
    -- Efeito hover
    tabButton.MouseEnter:Connect(function()
        tabButton.BackgroundColor3 = self.Colors.ButtonHover
    end)
    
    tabButton.MouseLeave:Connect(function()
        tabButton.BackgroundColor3 = self.Colors.Button
    end)
    
    -- Sistema de navegação entre abas
    local function showTab()
        for _, child in pairs(self.ContentPage:GetChildren()) do
            if child:IsA("ScrollingFrame") then
                child.Visible = false
            end
        end
        tabContent.Visible = true
    end
    
    tabButton.MouseButton1Click:Connect(showTab)
    
    -- Retornar métodos para adicionar elementos
    local tabMethods = {}
    
    function tabMethods:AddButton(text, callback)
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(0, 150, 0, 30)
        button.Position = UDim2.new(0, 10, 0, (#tabContent:GetChildren() - 1) * 35 + 10)
        button.BackgroundColor3 = self.Colors.Button
        button.TextColor3 = self.Colors.Text
        button.Text = text
        button.Font = Enum.Font.SourceSansBold
        button.TextSize = 14
        button.Parent = tabContent
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 4)
        corner.Parent = button
        
        button.MouseEnter:Connect(function()
            button.BackgroundColor3 = self.Colors.ButtonHover
        end)
        
        button.MouseLeave:Connect(function()
            button.BackgroundColor3 = self.Colors.Button
        end)
        
        button.MouseButton1Click:Connect(callback)
        
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
        toggleText.TextColor3 = self.Colors.Text
        toggleText.Text = text
        toggleText.Font = Enum.Font.SourceSans
        toggleText.TextSize = 14
        toggleText.TextXAlignment = Enum.TextXAlignment.Left
        toggleText.Parent = toggleFrame
        
        local toggleButton = Instance.new("TextButton")
        toggleButton.Size = UDim2.new(0, 30, 0, 20)
        toggleButton.Position = UDim2.new(0.8, -15, 0.5, -10)
        toggleButton.BackgroundColor3 = default and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50)
        toggleButton.Text = ""
        toggleButton.Parent = toggleFrame
        
        local state = default or false
        
        local function updateToggle()
            if state then
                toggleButton.BackgroundColor3 = Color3.fromRGB(50, 255, 50)
            else
                toggleButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
            end
        end
        
        toggleButton.MouseButton1Click:Connect(function()
            state = not state
            updateToggle()
            if callback then callback(state) end
        end)
        
        return toggleFrame
    end
    
    function tabMethods:AddLabel(text)
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0, 150, 0, 25)
        label.BackgroundTransparency = 1
        label.TextColor3 = self.Colors.Text
        label.Text = text
        label.Font = Enum.Font.SourceSansBold
        label.TextSize = 16
        label.Parent = tabContent
        
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
        sliderName.TextColor3 = self.Colors.Text
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
        sliderFill.BackgroundColor3 = self.Colors.Accent
        sliderFill.Parent = sliderTrack
        
        local sliderButton = Instance.new("TextButton")
        sliderButton.Size = UDim2.new(0, 15, 0, 15)
        sliderButton.Position = UDim2.new((default - min) / (max - min), -7, 0.5, -7)
        sliderButton.BackgroundColor3 = self.Colors.Text
        sliderButton.Text = ""
        sliderButton.Parent = sliderFrame
        
        local sliderValue = Instance.new("TextLabel")
        sliderValue.Size = UDim2.new(1, 0, 0, 15)
        sliderValue.Position = UDim2.new(0, 0, 0, 35)
        sliderValue.BackgroundTransparency = 1
        sliderValue.TextColor3 = self.Colors.Text
        sliderValue.Text = tostring(default)
        sliderValue.Font = Enum.Font.SourceSans
        sliderValue.TextSize = 12
        sliderValue.Parent = sliderFrame
        
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
        
        return sliderFrame
    end
    
    function tabMethods:AddDropdown(name, options, callback)
        local dropdownFrame = Instance.new("Frame")
        dropdownFrame.Size = UDim2.new(0, 150, 0, 30)
        dropdownFrame.BackgroundColor3 = self.Colors.Button
        dropdownFrame.Parent = tabContent
        
        local dropdownText = Instance.new("TextLabel")
        dropdownText.Size = UDim2.new(0.8, 0, 1, 0)
        dropdownText.BackgroundTransparency = 1
        dropdownText.TextColor3 = self.Colors.Text
        dropdownText.Text = name
        dropdownText.Font = Enum.Font.SourceSans
        dropdownText.TextSize = 14
        dropdownText.TextXAlignment = Enum.TextXAlignment.Left
        dropdownText.Parent = dropdownFrame
        
        local dropdownButton = Instance.new("TextButton")
        dropdownButton.Size = UDim2.new(0, 30, 0, 30)
        dropdownButton.Position = UDim2.new(0.8, 0, 0, 0)
        dropdownButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        dropdownButton.Text = "▼"
        dropdownButton.TextColor3 = self.Colors.Text
        dropdownButton.Font = Enum.Font.SourceSansBold
        dropdownButton.TextSize = 12
        dropdownButton.Parent = dropdownFrame
        
        local dropdownList = Instance.new("ScrollingFrame")
        dropdownList.Size = UDim2.new(1, 0, 0, 0)
        dropdownList.Position = UDim2.new(0, 0, 1, 2)
        dropdownList.BackgroundColor3 = self.Colors.Button
        dropdownList.Visible = false
        dropdownList.ScrollBarThickness = 4
        dropdownList.Parent = dropdownFrame
        
        local listLayout = Instance.new("UIListLayout")
        listLayout.Parent = dropdownList
        
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
            optionButton.TextColor3 = self.Colors.Text
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
        updateDropdown()
        
        return dropdownFrame
    end
    
    function tabMethods:AddTextBox(placeholder, callback)
        local textBoxFrame = Instance.new("Frame")
        textBoxFrame.Size = UDim2.new(0, 150, 0, 30)
        textBoxFrame.BackgroundColor3 = self.Colors.Button
        textBoxFrame.Parent = tabContent
        
        local textBox = Instance.new("TextBox")
        textBox.Size = UDim2.new(1, -10, 1, -10)
        textBox.Position = UDim2.new(0, 5, 0, 5)
        textBox.BackgroundTransparency = 1
        textBox.TextColor3 = self.Colors.Text
        textBox.PlaceholderText = placeholder
        textBox.Font = Enum.Font.SourceSans
        textBox.TextSize = 14
        textBox.ClearTextOnFocus = false
        textBox.Parent = textBoxFrame
        
        textBox.FocusLost:Connect(function(enterPressed)
            if enterPressed and callback then
                callback(textBox.Text)
            end
        end)
        
        return textBox
    end
    
    function tabMethods:AddSeparator()
        local separator = Instance.new("Frame")
        separator.Size = UDim2.new(0, 150, 0, 1)
        separator.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        separator.Parent = tabContent
        
        return separator
    end
    
    return tabMethods
end

-- Função para mostrar/esconder o menu
function BladeMenu:Toggle()
    self.GUI.Enabled = not self.GUI.Enabled
end

-- Função para mostrar notificação
function BladeMenu:Notify(text, duration)
    createNotification(text, duration)
end

-- Função para inicializar a library
function BladeMenu:Init()
    local self = setmetatable({}, BladeMenu)
    self:CreateUI()
    return self
end

-- Função de loadstring
local function loadBladeMenu()
    return BladeMenu:Init()
end

-- Exportar
return loadBladeMenu
