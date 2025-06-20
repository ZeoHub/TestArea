local PET_TOOL_NAMES = {
    "dragonfly", "raccoon", "disco bee", "purple dragonfly", "butterfly", "queen bee"
}

local MESSAGE_TEXT = "You are not holding an item!"
local MESSAGE_FONT = Enum.Font.GothamBold
local MESSAGE_SIZE = 14
local MESSAGE_COLOR = Color3.fromRGB(255,255,255)
local MESSAGE_BG_COLOR = Color3.fromRGB(0,0,0)
local MESSAGE_BG_TRANS = 0.9
local MESSAGE_STROKE_COLOR = Color3.fromRGB(0,0,0)
local MESSAGE_STROKE_TRANS = 0.5
local MESSAGE_FADE_TIME = 0.25
local MESSAGE_LIFETIME = 3.5
local BATCH_FADE_DELAY = 0.5
local SPAM_MAX = 20

local STACK_BATCH = 5
local MESSAGE_Y_START = 0.33
local MESSAGE_Y_STEP = 0.035
local MESSAGE_PADDING = 8
local MSG_COOLDOWN = 0.13

local player = game.Players.LocalPlayer
local gui = player:FindFirstChildOfClass("PlayerGui")
local msgGui = gui:FindFirstChild("PetToolMsgGui") or Instance.new("ScreenGui")
msgGui.Name = "PetToolMsgGui"
msgGui.ResetOnSpawn = false
msgGui.IgnoreGuiInset = true
msgGui.Parent = gui

local activeMessages = {} -- {frame=Frame, created=number, faded=false}
local lastMsgTime = 0
local batchFaderRunning = false

local function restackMessages()
    for i, msgTbl in ipairs(activeMessages) do
        local msgFrame = msgTbl.frame
        msgFrame.Position = UDim2.new(0.5, -200, MESSAGE_Y_START + ((i-1)*MESSAGE_Y_STEP), 0)
        msgFrame.Visible = true
    end
end

local function fadeBatch(batch)
    for _,msgTbl in ipairs(batch) do
        if not msgTbl.faded then
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
        end
    end
    task.wait(MESSAGE_FADE_TIME + 0.01)
    -- Remove faded from active
    for i = #activeMessages, 1, -1 do
        if activeMessages[i].faded then
            activeMessages[i].frame:Destroy()
            table.remove(activeMessages, i)
        end
    end
    restackMessages()
end

local function batchFader()
    if batchFaderRunning then return end
    batchFaderRunning = true
    task.spawn(function()
        while #activeMessages > 0 do
            -- Wait for the oldest batch's lifetime
            local now = tick()
            local batchCount = math.min(STACK_BATCH, #activeMessages)
            local oldest = activeMessages[1]
            local oldestCreated = oldest.created
            local toWait = MESSAGE_LIFETIME - (now - oldestCreated)
            if toWait > 0 then
                task.wait(toWait)
            end
            -- Fade the oldest batch
            local batch = {}
            for i = 1, math.min(STACK_BATCH, #activeMessages) do
                table.insert(batch, activeMessages[i])
            end
            fadeBatch(batch)
            if #activeMessages > 0 then
                task.wait(BATCH_FADE_DELAY)
            end
        end
        batchFaderRunning = false
    end)
end

local function showMessage(text)
    if #activeMessages >= SPAM_MAX then return end
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

    table.insert(activeMessages, {frame = bg, created = tick(), faded = false})
    restackMessages()
    batchFader()
end

-- Your input handling here (as before) ...
-- Use showMessage(MESSAGE_TEXT) on tap/click

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
