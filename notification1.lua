local PET_TOOL_NAMES = {
    "dragonfly", "raccoon", "disco bee", "purple dragonfly", "butterfly", "queen bee"
}

local MESSAGE_TEXT = "You need a divine pet to make it work"
local MESSAGE_HOLD_PET = "Hold your pet!"

-- UI APPEARANCE
local MESSAGE_FONT = Enum.Font.ComicSans -- Playful, rounded font!
local MESSAGE_SIZE = 26
local MESSAGE_COLOR = Color3.fromRGB(255,255,255)
local MESSAGE_STROKE_COLOR = Color3.fromRGB(0,0,0)
local MESSAGE_STROKE_TRANS = 0.1 -- Slightly visible stroke
local MESSAGE_FADE_TIME = 0.3
local MESSAGE_LIFETIME = 1.3

-- MESSAGE Y OFFSET
local MESSAGE_Y_START = 0.33

local player = game.Players.LocalPlayer
local gui = player:FindFirstChildOfClass("PlayerGui")
local msgGui = gui:FindFirstChild("PetToolMsgGui") or Instance.new("ScreenGui")
msgGui.Name = "PetToolMsgGui"
msgGui.ResetOnSpawn = false
msgGui.IgnoreGuiInset = true
msgGui.Parent = gui

local lastMsgTime = 0
local MSG_COOLDOWN = 0.3
local messageActive = false

local function isPetTool(tool)
    if not tool or not tool.Name then return false end
    local name = string.lower(tool.Name)
    for _,pet in ipairs(PET_TOOL_NAMES) do
        if name == pet or string.find(name, pet, 1, true) then
            return true
        end
    end
    return false
end

local function showMessage(text)
    if messageActive then return end
    if tick() - lastMsgTime < MSG_COOLDOWN then return end
    lastMsgTime = tick()
    messageActive = true

    local msg = Instance.new("TextLabel")
    msg.Size = UDim2.new(1,0,0,40)
    msg.Position = UDim2.new(0,0,MESSAGE_Y_START,0)
    msg.BackgroundTransparency = 1
    msg.Text = text
    msg.Font = MESSAGE_FONT
    msg.TextSize = MESSAGE_SIZE
    msg.TextColor3 = MESSAGE_COLOR
    msg.TextStrokeTransparency = MESSAGE_STROKE_TRANS -- Now: visible stroke!
    msg.TextStrokeColor3 = MESSAGE_STROKE_COLOR
    msg.TextWrapped = true
    msg.ZIndex = 100
    msg.Parent = msgGui

    msg.TextTransparency = 1
    msg.TextStrokeTransparency = 1
    game.TweenService:Create(msg, TweenInfo.new(MESSAGE_FADE_TIME), {
        TextTransparency = 0,
        TextStrokeTransparency = MESSAGE_STROKE_TRANS
    }):Play()

    task.delay(MESSAGE_LIFETIME, function()
        game.TweenService:Create(msg, TweenInfo.new(MESSAGE_FADE_TIME), {
            TextTransparency = 1,
            TextStrokeTransparency = 1
        }):Play()
        task.wait(MESSAGE_FADE_TIME + 0.05)
        msg:Destroy()
        messageActive = false
    end)
end

-- Utility: returns true if input is on a GUI button
local function isOnGuiButton(pos)
    for _,ui in ipairs(gui:GetDescendants()) do
        if ui:IsA("GuiButton") and ui.Visible and ui.AbsoluteSize.Magnitude > 0 then
            local abs = ui.AbsolutePosition
            local size = ui.AbsoluteSize
            if pos.X >= abs.X and pos.X <= abs.X+size.X and pos.Y >= abs.Y and pos.Y <= abs.Y+size.Y then
                return true
            end
        end
    end
    return false
end

-- Utility: returns true if input is on the mobile joystick (checks for common joystick UI)
local function isOnJoystick(pos)
    for _,ui in ipairs(gui:GetDescendants()) do
        if (ui:IsA("ImageButton") or ui:IsA("Frame")) and ui.Visible and ui.AbsoluteSize.Magnitude > 0 then
            local n = ui.Name:lower()
            if n:find("joystick") or n:find("thumb") then
                local abs = ui.AbsolutePosition
                local size = ui.AbsoluteSize
                if pos.X >= abs.X and pos.X <= abs.X+size.X and pos.Y >= abs.Y and pos.Y <= abs.Y+size.Y then
                    return true
                end
            end
        end
    end
    return false
end

-- Main input handler
local UserInputService = game:GetService("UserInputService")
local mouse = player:GetMouse()

local function handleInput(pos)
    if isOnGuiButton(pos) then return end
    if isOnJoystick(pos) then return end

    local char = player.Character
    if not char then showMessage(MESSAGE_HOLD_PET) return end
    local tool = char:FindFirstChildOfClass("Tool")
    if tool and isPetTool(tool) then
        showMessage(MESSAGE_TEXT)
    else
        showMessage(MESSAGE_HOLD_PET)
    end
end

-- Mouse (desktop)
mouse.Button1Down:Connect(function()
    local mousePos = UserInputService:GetMouseLocation()
    handleInput(mousePos)
end)

-- Touch (mobile)
UserInputService.TouchTap:Connect(function(touchPositions, processed)
    if not touchPositions or #touchPositions == 0 then return end
    local touchPos = Vector2.new(touchPositions[1].X, touchPositions[1].Y)
    handleInput(touchPos)
end)

-- Tool.Activated (keyboard/console)
local function connectTool(tool)
    if tool:IsA("Tool") and isPetTool(tool) then
        tool.Activated:Connect(function()
            showMessage(MESSAGE_TEXT)
        end)
    end
end

if player.Character then
    for _,tool in ipairs(player.Character:GetChildren()) do
        connectTool(tool)
    end
end
player.CharacterAdded:Connect(function(char)
    char.ChildAdded:Connect(connectTool)
end)

-- TEST BUTTON (for easy testing)
do
    local testBtn = Instance.new("TextButton")
    testBtn.Name = "TestPetMsgBtn"
    testBtn.Parent = msgGui
    testBtn.Size = UDim2.new(0, 200, 0, 40)
    testBtn.Position = UDim2.new(0.5, -100, 1, -70)
    testBtn.BackgroundColor3 = Color3.fromRGB(30,30,30)
    testBtn.BorderColor3 = Color3.fromRGB(48, 48, 48)
    testBtn.Text = "Test Popup Message"
    testBtn.TextColor3 = Color3.fromRGB(255,255,255)
    testBtn.TextSize = 18
    testBtn.Font = Enum.Font.ComicSans
    testBtn.AutoButtonColor = true
    local uic = Instance.new("UICorner", testBtn)
    uic.CornerRadius = UDim.new(0,12)
    testBtn.MouseButton1Click:Connect(function()
        local char = player.Character
        if char then
            local tool = char:FindFirstChildOfClass("Tool")
            if tool and isPetTool(tool) then
                showMessage(MESSAGE_TEXT)
            else
                showMessage(MESSAGE_HOLD_PET)
            end
        else
            showMessage(MESSAGE_HOLD_PET)
        end
    end)
end
