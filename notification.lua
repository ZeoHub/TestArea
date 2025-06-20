-- Pet Tool Hold Message Popup (with test button), also reminds to "hold your pet" if not holding a pet

local PET_TOOL_NAMES = {
    "dragonfly", "raccoon", "disco bee", "purple dragonfly", "butterfly", "queen bee"
}

local MESSAGE_TEXT = "You need have a original pet to dupe this pet spawner!"
local MESSAGE_HOLD_PET = "Hold your pet!"

-- UI APPEARANCE
local MESSAGE_FONT = Enum.Font.GothamBold
local MESSAGE_SIZE = 15
local MESSAGE_COLOR = Color3.fromRGB(255,255,255)
local MESSAGE_STROKE_COLOR = Color3.fromRGB(0,0,0)
local MESSAGE_FADE_TIME = 0.3
local MESSAGE_LIFETIME = 1.3
local SPAM_MAX = 10

-- Helper to check if tool is a configured pet tool
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

-- Setup UI root
local player = game.Players.LocalPlayer
local gui = player:FindFirstChildOfClass("PlayerGui")
local msgGui = gui:FindFirstChild("PetToolMsgGui") or Instance.new("ScreenGui")
msgGui.Name = "PetToolMsgGui"
msgGui.ResetOnSpawn = false
msgGui.IgnoreGuiInset = true
msgGui.Parent = gui

-- Message popup
local activeMessages = {}
local function showMessage(text)
    if #activeMessages >= SPAM_MAX then return end
    local msg = Instance.new("TextLabel")
    msg.Size = UDim2.new(1,0,0,40)
    msg.Position = UDim2.new(0,0,0.38 + (#activeMessages*0.04),0)
    msg.BackgroundTransparency = 1
    msg.Text = text
    msg.Font = MESSAGE_FONT
    msg.TextSize = MESSAGE_SIZE
    msg.TextColor3 = MESSAGE_COLOR
    msg.TextStrokeTransparency = 0
    msg.TextStrokeColor3 = MESSAGE_STROKE_COLOR
    msg.TextWrapped = true
    msg.ZIndex = 100
    msg.Parent = msgGui
    table.insert(activeMessages, msg)

    -- Fade in
    msg.TextTransparency = 1
    msg.TextStrokeTransparency = 1
    game.TweenService:Create(msg, TweenInfo.new(MESSAGE_FADE_TIME), {
        TextTransparency = 0,
        TextStrokeTransparency = 0
    }):Play()
    -- Fade out after a bit
    task.delay(MESSAGE_LIFETIME, function()
        game.TweenService:Create(msg, TweenInfo.new(MESSAGE_FADE_TIME), {
            TextTransparency = 1,
            TextStrokeTransparency = 1
        }):Play()
        task.wait(MESSAGE_FADE_TIME + 0.05)
        msg:Destroy()
        table.remove(activeMessages, 1)
    end)
end

-- TEST BUTTON
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
        -- Simulate both cases: with and without pet tool
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

-- HANDLE TOOL INPUT
local mouse = player:GetMouse()

local function onInput()
    local char = player.Character
    if not char then return end
    local tool = char:FindFirstChildOfClass("Tool")
    if tool and isPetTool(tool) then
        showMessage(MESSAGE_TEXT)
    else
        showMessage(MESSAGE_HOLD_PET)
    end
end

-- Listen for mouse click/tap
mouse.Button1Down:Connect(onInput)
game:GetService("UserInputService").TouchTap:Connect(onInput)

-- Also listen for Tool.Activated (covers keyboard/console)
local function connectTool(tool)
    if tool:IsA("Tool") and isPetTool(tool) then
        tool.Activated:Connect(function() showMessage(MESSAGE_TEXT) end)
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
