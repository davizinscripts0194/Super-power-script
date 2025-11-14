-- Cria a GUI
local player = game.Players.LocalPlayer
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DavizinScripts"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Cria o painel pequeno e quadrado
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 250) -- pequeno e quadrado, espaço para checkboxes
frame.Position = UDim2.new(0.4, 0, 0.35, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Parent = screenGui
frame.Active = true
frame.Draggable = true

-- Função para efeito RGB no painel
spawn(function()
    local hue = 0
    while true do
        hue = (hue + 1) % 360
        frame.BackgroundColor3 = Color3.fromHSV(hue/360, 1, 1)
        wait(0.02)
    end
end)

-- Cria título
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0.2, 0)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "DavizinScripts"
title.TextScaled = true
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.SourceSansBold
title.Parent = frame

-- Lista de treinos
local trainList = {"Strength", "Endurance", "Psychic"}
local selectedTrains = {}

-- Cria checkboxes para cada treino
for i, train in ipairs(trainList) do
    local checkbox = Instance.new("TextButton")
    checkbox.Size = UDim2.new(0.8, 0, 0.15, 0)
    checkbox.Position = UDim2.new(0.1, 0, 0.2 + (i-1)*0.15, 0)
    checkbox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    checkbox.TextColor3 = Color3.fromRGB(255, 255, 255)
    checkbox.TextScaled = true
    checkbox.Font = Enum.Font.SourceSansBold
    checkbox.Text = train .. ": OFF"
    checkbox.Parent = frame

    selectedTrains[train] = false

    checkbox.MouseButton1Click:Connect(function()
        selectedTrains[train] = not selectedTrains[train]
        checkbox.Text = train .. (selectedTrains[train] and ": ON" or ": OFF")
        checkbox.BackgroundColor3 = selectedTrains[train] and Color3.fromRGB(0,170,255) or Color3.fromRGB(50,50,50)
    end)
end

-- Botão de ativar/desativar Auto Farm
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0.8, 0, 0.15, 0)
toggleButton.Position = UDim2.new(0.1, 0, 0.7, 0)
toggleButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.TextScaled = true
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.Text = "Ativar Auto Farm"
toggleButton.Parent = frame

-- Função do Auto Farm
local autoFarmActive = false

local function toggleAutoFarm()
    autoFarmActive = not autoFarmActive
    if autoFarmActive then
        toggleButton.Text = "Desativar Auto Farm"
        spawn(function()
            while autoFarmActive do
                for train, isSelected in pairs(selectedTrains) do
                    if isSelected then
                        game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Train"):FireServer(train)
                    end
                end
                wait(0.1)
            end
        end)
    else
        toggleButton.Text = "Ativar Auto Farm"
    end
end

toggleButton.MouseButton1Click:Connect(toggleAutoFarm)
