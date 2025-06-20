local MESSAGE_TEXT = "You are not holding an item!"
local MESSAGE_FONT = Enum.Font.GothamBold
local MESSAGE_SIZE = 12
local MESSAGE_COLOR = Color3.fromRGB(255,255,255)
local MESSAGE_BG_COLOR = Color3.fromRGB(0,0,0)
local MESSAGE_BG_TRANS = 0.85
local MESSAGE_STROKE_COLOR = Color3.fromRGB(0,0,0)
local MESSAGE_STROKE_TRANS = 0.5
local MESSAGE_FADE_TIME = 0.25
local MESSAGE_LIFETIME = 1.2
local MSG_COOLDOWN = 0.13
local STACK_MAX = 20

local MESSAGE_Y_START = 0.33
local MESSAGE_Y_STEP = 0.035
local MESSAGE_PADDING = 8

local player = game.Players.LocalPlayer
local gui = player:FindFirstChildOfClass("PlayerGui")
local msgGui = gui:FindFirstChild("PetToolMsgGui") or Instance.new("ScreenGui")
msgGui.Name = "PetToolMsgGui"
msgGui.ResetOnSpawn = false
msgGui.IgnoreGuiInset = true
msgGui.Parent = gui

local activeBatch = {}
local lastMsgTime = 0
local batchTimerRunning = false
local batchStartTime = 0

local function restackMessages()
    for i, msgFrame in ipairs(activeBatch) do
        msgFrame.Position = UDim2.new(0.5, -200, MESSAGE_Y_START + ((i-1)*MESSAGE_Y_STEP), 0)
    end
end

local function fadeBatch()
    for _,msgFrame in ipairs(activeBatch) do
        local msg = msgFrame:FindFirstChildOfClass("TextLabel")
        game.TweenService:Create(msgFrame, TweenInfo.new(MESSAGE_FADE_TIME), {BackgroundTransparency = 1}):Play()
        if msg then
            game.TweenService:Create(msg, TweenInfo.new(MESSAGE_FADE_TIME), {
                TextTransparency = 1,
                TextStrokeTransparency = 1
            }):Play()
        end
    end
    task.wait(MESSAGE_FADE_TIME + 0.01)
    for _,msgFrame in ipairs(activeBatch) do
        msgFrame:Destroy()
    end
    table.clear(activeBatch)
    batchTimerRunning = false
end

local function startBatchTimer()
    if batchTimerRunning then return end
    batchTimerRunning = true
    batchStartTime = tick()
    task.spawn(function()
        task.wait(MESSAGE_LIFETIME)
        fadeBatch()
    end)
end

local function showMessage(text)
    if #activeBatch >= STACK_MAX then return end
    if tick() - lastMsgTime < MSG_COOLDOWN then return end
    lastMsgTime = tick()

    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(0, 400, 0, 18)
    bg.Position = UDim2.new(0.5, -200, MESSAGE_Y_START + (#activeBatch)*MESSAGE_Y_STEP, 0)
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

    table.insert(activeBatch, bg)
    restackMessages()
    startBatchTimer()
end

-- Example input hook:
local UserInputService = game:GetService("UserInputService")
local mouse = player:GetMouse()
mouse.Button1Down:Connect(function()
    showMessage(MESSAGE_TEXT)
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
        showMessage(MESSAGE_TEXT)
    end)
end
