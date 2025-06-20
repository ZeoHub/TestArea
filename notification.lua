local PET_TOOL_NAMES = {
    "dragonfly", "raccoon", "disco bee", "purple dragonfly", "butterfly", "queen bee"
}

local MESSAGE_TEXT = "You can only place your pets in your garden!"
local MESSAGE_HOLD_PET = "Hold your pet!"

local MESSAGE_FONT = Enum.Font.GothamBold
local MESSAGE_SIZE = 12
local MESSAGE_COLOR = Color3.fromRGB(255,255,255)
local MESSAGE_BG_COLOR = Color3.fromRGB(0,0,0)
local MESSAGE_BG_TRANS = 0.85
local MESSAGE_STROKE_COLOR = Color3.fromRGB(0,0,0)
local MESSAGE_STROKE_TRANS = 0.5
local MESSAGE_FADE_TIME = 0.25
local MESSAGE_LIFETIME = 1.2
local MAX_VISIBLE_STACK = 5
local SPAM_MAX = 20

local MESSAGE_Y_START = 0.33
local MESSAGE_Y_STEP = 0.04
local MESSAGE_PADDING = 8
local MSG_COOLDOWN = 0.13

local player = game.Players.LocalPlayer
local gui = player:FindFirstChildOfClass("PlayerGui")
local msgGui = gui:FindFirstChild("PetToolMsgGui") or Instance.new("ScreenGui")
msgGui.Name = "PetToolMsgGui"
msgGui.ResetOnSpawn = false
msgGui.IgnoreGuiInset = true
msgGui.Parent = gui

local activeMessages = {}
local lastMsgTime = 0

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

local function restackMessages()
    for i, msgFrame in ipairs(activeMessages) do
        msgFrame.Position = UDim2.new(0.5, -200, MESSAGE_Y_START + ((i-1)*MESSAGE_Y_STEP), 0)
    end
end

local function fadeAndRemoveMessage(msgFrame)
    local msg = msgFrame:FindFirstChildOfClass("TextLabel")
    game.TweenService:Create(msgFrame, TweenInfo.new(MESSAGE_FADE_TIME), {BackgroundTransparency = 1}):Play()
    if msg then
        game.TweenService:Create(msg, TweenInfo.new(MESSAGE_FADE_TIME), {
            TextTransparency = 1,
            TextStrokeTransparency = 1
        }):Play()
    end
    task.wait(MESSAGE_FADE_TIME + 0.01)
    msgFrame:Destroy()
    for i, m in ipairs(activeMessages) do
        if m == msgFrame then
            table.remove(activeMessages, i)
            break
        end
    end
    restackMessages()
end

local function showMessage(text)
    if #activeMessages >= SPAM_MAX then return end
    if tick() - lastMsgTime < MSG_COOLDOWN then return end
    lastMsgTime = tick()

    restackMessages()

    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(0, 400, 0, 18)
    bg.Position = UDim2.new(0.5, -200, MESSAGE_Y_START + ((#activeMessages)*MESSAGE_Y_STEP), 0)
    bg.BackgroundColor3 = MESSAGE_BG_COLOR
    bg.BackgroundTransparency = 1
    bg.BorderSizePixel = 0
    bg.ZIndex = 100
    bg.Parent = msgGui

    local pad = Instance.new("UIPadding")
    pad.PaddingLeft = UDim.new(0, MESSAGE_PADDING)
    pad.PaddingRight = UDim.new(0, MESSAGE_PADDING)
    pad.Parent = bg

    local msg = Instance.new("TextLabel")
    msg.Size = UDim2.new(1, 0, 1, 0)
    msg.BackgroundTransparency = 1
    msg.Text = text
    msg.Font = MESSAGE_FONT
    msg.TextSize = MESSAGE_SIZE
    msg.TextColor3 = MESSAGE_COLOR
    msg.TextStrokeTransparency = MESSAGE_STROKE_TRANS
    msg.TextStrokeColor3 = MESSAGE_STROKE_COLOR
    msg.TextWrapped = true
    msg.ZIndex = 101
    msg.Parent = bg

    -- Fade in
    game.TweenService:Create(bg, TweenInfo.new(MESSAGE_FADE_TIME), {BackgroundTransparency = MESSAGE_BG_TRANS}):Play()
    msg.TextTransparency = 1
    msg.TextStrokeTransparency = 1
    game.TweenService:Create(msg, TweenInfo.new(MESSAGE_FADE_TIME), {
        TextTransparency = 0,
        TextStrokeTransparency = MESSAGE_STROKE_TRANS
    }):Play()

    table.insert(activeMessages, bg)

    -- If stack exceeds max visible, fade out the bottom-most (oldest) message
    if #activeMessages > MAX_VISIBLE_STACK then
        local toFade = activeMessages[1]
        task.spawn(function()
            fadeAndRemoveMessage(toFade)
        end)
    end

    -- Auto-fade after lifetime
    task.delay(MESSAGE_LIFETIME, function()
        if bg.Parent then
            fadeAndRemoveMessage(bg)
        end
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

mouse.Button1Down:Connect(function()
    local mousePos = UserInputService:GetMouseLocation()
    handleInput(mousePos)
end)

UserInputService.TouchTap:Connect(function(touchPositions, processed)
    if not touchPositions or #touchPositions == 0 then return end
    local touchPos = Vector2.new(touchPositions[1].X, touchPositions[1].Y)
    handleInput(touchPos)
end)

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
    testBtn.Font = Enum.Font.GothamBold
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
