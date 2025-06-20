-- Pet Tool Hold Message Popup (single and spam tap/click) by ZeoHub
-- Shows a center message like image 1 when player clicks/taps once with a pet tool,
-- and spams the message like image 2 if player spams click/tap.

-- CONFIGURABLE PET TOOL NAMES (case insensitive)
local PET_TOOL_NAMES = {
    "dragonfly", "raccoon", "disco bee", "purple dragonfly", "butterfly", "queen bee"
}

local MESSAGE_TEXT = "You can only place your pets in your garden!"

-- UI APPEARANCE
local MESSAGE_FONT = Enum.Font.GothamBold
local MESSAGE_SIZE = 26
local MESSAGE_COLOR = Color3.fromRGB(255,255,255)
local MESSAGE_STROKE_COLOR = Color3.fromRGB(0,0,0)
local MESSAGE_STROKE_THICKNESS = 2
local MESSAGE_FADE_TIME = 0.3
local MESSAGE_LIFETIME = 1.3
local SPAM_MAX = 10 -- how many messages max can be spammed

-- UTILITIES
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

-- UI ROOT
local player = game.Players.LocalPlayer
local gui = player:FindFirstChildOfClass("PlayerGui")
local msgGui = gui:FindFirstChild("PetToolMsgGui") or Instance.new("ScreenGui")
msgGui.Name = "PetToolMsgGui"
msgGui.ResetOnSpawn = false
msgGui.IgnoreGuiInset = true
msgGui.Parent = gui

-- MESSAGE POPUP FUNCTION
local activeMessages = {}
local function showMessage()
    -- Limit spam
    if #activeMessages >= SPAM_MAX then return end

    local msg = Instance.new("TextLabel")
    msg.Size = UDim2.new(1,0,0,40)
    msg.Position = UDim2.new(0,0,0.38 + (#activeMessages*0.04),0) -- stack if spammed
    msg.BackgroundTransparency = 1
    msg.Text = MESSAGE_TEXT
    msg.Font = MESSAGE_FONT
    msg.TextSize = MESSAGE_SIZE
    msg.TextColor3 = MESSAGE_COLOR
    msg.TextStrokeTransparency = 0
    msg.TextStrokeColor3 = MESSAGE_STROKE_COLOR
    msg.TextStrokeThickness = MESSAGE_STROKE_THICKNESS
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

-- HANDLE TOOL INPUT
local mouse = player:GetMouse()
local lastTool = nil

local function onInput()
    local char = player.Character
    if not char then return end
    local tool = char:FindFirstChildOfClass("Tool")
    if tool and isPetTool(tool) then
        showMessage()
    end
end

-- Listen for tool equipped (so it works immediately after switching tools)
player.CharacterAdded:Connect(function(char)
    char.ChildAdded:Connect(function(obj)
        if obj:IsA("Tool") and isPetTool(obj) then
            -- Optionally show a message on equip
            -- showMessage()
        end
    end)
end)

-- Listen for mouse click/tap
mouse.Button1Down:Connect(onInput)
game:GetService("UserInputService").TouchTap:Connect(onInput)

-- Also listen for Tool.Activated (covers keyboard/console)
local function connectTool(tool)
    if tool:IsA("Tool") and isPetTool(tool) then
        tool.Activated:Connect(showMessage)
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
