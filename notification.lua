local MESSAGE_TEXT = "You are not holding an item!"
local MESSAGE_FONT = Enum.Font.ComicSans -- Playful, rounded font
local MESSAGE_SIZE = 15
local MESSAGE_COLOR = Color3.fromRGB(255,255,255)
local MESSAGE_BG_COLOR = Color3.fromRGB(18,18,20) -- Subtle dark background
local MESSAGE_BG_TRANS = 0.92 -- High transparency for a subtle look
local MESSAGE_STROKE_COLOR = Color3.fromRGB(0,0,0)
local MESSAGE_STROKE_TRANS = 0.22 -- Less transparent = more visible stroke
local MESSAGE_FADE_TIME = 0.25
local MESSAGE_LIFETIME = 3.5
local BATCH_FADE_DELAY = 0.5
local MSG_COOLDOWN = 0.13
local STACK_MAX = 20
local BATCH_SIZE = 5

local MESSAGE_Y_START = 0.33
local MESSAGE_Y_STEP = 0.035
local MESSAGE_PADDING = 12 -- More padding for a softer look

local player = game.Players.LocalPlayer
local gui = player:FindFirstChildOfClass("PlayerGui")
local msgGui = gui:FindFirstChild("PetToolMsgGui") or Instance.new("ScreenGui")
msgGui.Name = "PetToolMsgGui"
msgGui.ResetOnSpawn = false
msgGui.IgnoreGuiInset = true
msgGui.Parent = gui

local activeMessages = {} -- {frame, created, faded, claimed}
local lastMsgTime = 0

local function restackMessages()
    for i, msgTbl in ipairs(activeMessages) do
        local msgFrame = msgTbl.frame
        msgFrame.Position = UDim2.new(0.5, -125, MESSAGE_Y_START + ((i-1)*MESSAGE_Y_STEP), 0)
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

-- Start the forever batch fader coroutine exactly once!
local batchFaderStarted = false
local function startBatchFader()
    if batchFaderStarted then return end
    batchFaderStarted = true
    task.spawn(function()
        while true do
            -- Only fade full batches
            while #activeMessages >= BATCH_SIZE do
                -- Only claim the first unclaimed batch
                local batch = {}
                for i = 1, BATCH_SIZE do
                    local msg = activeMessages[i]
                    batch[i] = msg
                    msg.claimed = true
                end
                -- Wait for lifetime of oldest in batch
                local oldest = batch[1]
                local toWait = MESSAGE_LIFETIME - (tick() - oldest.created)
                if toWait > 0 then task.wait(toWait) end
                -- Fade whole batch at once
                for _, msg in ipairs(batch) do
                    fadeMessage(msg)
                end
                if #activeMessages >= BATCH_SIZE then
                    task.wait(BATCH_FADE_DELAY)
                end
            end
            -- No full batch available, check every 0.1s
            task.wait(0.1)
        end
    end)
end

local function showMessage(text)
    if #activeMessages >= STACK_MAX then return end
    if tick() - lastMsgTime < MSG_COOLDOWN then return end
    lastMsgTime = tick()

    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(0, 250, 0, 17)
    bg.Position = UDim2.new(0.5, -125, MESSAGE_Y_START + (#activeMessages)*MESSAGE_Y_STEP, 0)
    bg.BackgroundColor3 = MESSAGE_BG_COLOR
    bg.BackgroundTransparency = 1 -- will fade in!
    bg.BorderSizePixel = 0
    bg.ZIndex = 100
    bg.Parent = msgGui

    -- Rounded corners
    local uic = Instance.new("UICorner")
    uic.CornerRadius = UDim.new(0, 22) -- Maximum roundness for pill shape
    uic.Parent = bg

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

    -- Add a little bit of stroke (border) to the background
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(40,40,40)
    stroke.Thickness = 1.5
    stroke.Transparency = 0.2 -- 0 = solid, 1 = invisible (so 0.2 is a little bit visible)
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = bg

    -- Fade in
    game.TweenService:Create(bg, TweenInfo.new(MESSAGE_FADE_TIME), {BackgroundTransparency = MESSAGE_BG_TRANS}):Play()
    msg.TextTransparency = 1
    msg.TextStrokeTransparency = 1
    game.TweenService:Create(msg, TweenInfo.new(MESSAGE_FADE_TIME), {
        TextTransparency = 0,
        TextStrokeTransparency = MESSAGE_STROKE_TRANS
    }):Play()

    local msgTbl = {frame = bg, created = tick(), faded = false, claimed = false}
    table.insert(activeMessages, msgTbl)
    restackMessages()

    -- Always ensure batch fader is running
    startBatchFader()

    -- If not claimed by a batch after MESSAGE_LIFETIME, fade individually
    task.spawn(function()
        task.wait(MESSAGE_LIFETIME)
        if not msgTbl.faded and not msgTbl.claimed then
            fadeMessage(msgTbl)
        end
    end)
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
    testBtn.Font = Enum.Font.ComicSans -- Playful, rounded font for test button too!
    testBtn.AutoButtonColor = true
    local uic = Instance.new("UICorner", testBtn)
    uic.CornerRadius = UDim.new(0,12)
    testBtn.MouseButton1Click:Connect(function()
        showMessage(MESSAGE_TEXT)
    end)
end
