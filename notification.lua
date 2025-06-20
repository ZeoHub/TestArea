local MESSAGE_TEXT = "You are not holding an item!"
local MESSAGE_FONT = Enum.Font.GothamBold
local MESSAGE_SIZE = 14
local MESSAGE_COLOR = Color3.fromRGB(255,255,255)
local MESSAGE_BG_COLOR = Color3.fromRGB(0,0,0)
local MESSAGE_BG_TRANS = 0.85
local MESSAGE_STROKE_COLOR = Color3.fromRGB(0,0,0)
local MESSAGE_STROKE_TRANS = 0.5
local MESSAGE_FADE_TIME = 0.25
local MESSAGE_LIFETIME = 3.5
local BATCH_FADE_DELAY = 0.5
local MSG_COOLDOWN = 0.13
local STACK_MAX = 20
local BATCH_SIZE = 5

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

local activeMessages = {} -- {frame, created, faded}
local lastMsgTime = 0
local batchFaderRunning = false

local function restackMessages()
    for i, msgTbl in ipairs(activeMessages) do
        local msgFrame = msgTbl.frame
        msgFrame.Position = UDim2.new(0.5, -200, MESSAGE_Y_START + ((i-1)*MESSAGE_Y_STEP), 0)
        msgFrame.Visible = true
    end
end

local function fadeMessage(msgTbl)
    if msgTbl.faded then return end
    local msgFrame = msgTbl.frame
    local msg = msgFrame:FindFirstChildOfClass("TextLabel")
    game.TweenService:Create(msgFrame, TweenInfo.new(MESSAGE_FADE_TIME), {BackgroundTransparency = 1}):Play()
    if msg then
        game.TweenService:Create(msg, TweenInfo.new(MESSAGE_FADE_TIME), {
            TextTransparency = 1,
            TextStrokeTransparency = 1
        }):Play()
    end
    msgTbl.faded = true
    task.wait(MESSAGE_FADE_TIME + 0.01)
    msgFrame:Destroy()
    for i, m in ipairs(activeMessages) do
        if m == msgTbl then
            table.remove(activeMessages, i)
            break
        end
    end
    restackMessages()
end

local function batchFader()
    if batchFaderRunning then return end
    batchFaderRunning = true
    task.spawn(function()
        while #activeMessages >= BATCH_SIZE do
            -- Always fade the oldest batch of 5
            local batch = {}
            for i = 1, BATCH_SIZE do
                batch[i] = activeMessages[i]
            end
            local oldest = batch[1]
            local timeToWait = MESSAGE_LIFETIME - (tick() - oldest.created)
            if timeToWait > 0 then task.wait(timeToWait) end
            for _, msg in ipairs(batch) do
                fadeMessage(msg)
            end
            if #activeMessages >= BATCH_SIZE then
                task.wait(BATCH_FADE_DELAY)
            end
        end
        batchFaderRunning = false
    end)
end

local function showMessage(text)
    if #activeMessages >= STACK_MAX then return end
    if tick() - lastMsgTime < MSG_COOLDOWN then return end
    lastMsgTime = tick()

    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(0, 400, 0, 18)
    bg.Position = UDim2.new(0.5, -200, MESSAGE_Y_START + (#activeMessages)*MESSAGE_Y_STEP, 0)
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

    local msgTbl = {frame = bg, created = tick(), faded = false}
    table.insert(activeMessages, msgTbl)
    restackMessages()

    if #activeMessages < BATCH_SIZE then
        -- Fade individually
        task.spawn(function()
            task.wait(MESSAGE_LIFETIME)
            if not msgTbl.faded and #activeMessages < BATCH_SIZE and table.find(activeMessages, msgTbl) then
                fadeMessage(msgTbl)
            end
        end)
    else
        -- Start or continue the batch fader for any new batch
        batchFader()
    end
end

-- Example input hook for testing:
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
