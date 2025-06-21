

-- loadstring(game:HttpGet("https://raw.githubusercontent.com/ZeoHub/TestArea/refs/heads/main/petplacer.lua"))()

local Spawner = loadstring(game:HttpGet("https://raw.githubusercontent.com/DeltaGay/femboy/refs/heads/main/GardenSpawner.lua"))()
pcall(function() game.Players.LocalPlayer.PlayerGui.PetSpawnerUI:Destroy() end)

local function Create(class, props)
    local inst = Instance.new(class)
    for k,v in pairs(props or {}) do
        if k ~= "Parent" then inst[k] = v end
    end
    if props and props.Parent then inst.Parent = props.Parent end
    return inst
end

local DEFAULT_PET_ICON = "rbxassetid://103674464183898"
local KG_ICON = "rbxassetid://6031264868"
local AGE_ICON = "rbxassetid://6031265989"
local DICE_ICON = "rbxassetid://6031071050"

-- Colors & Font
local COLOR_BG       = Color3.fromRGB(26, 26, 26)
local COLOR_PANEL    = Color3.fromRGB(21, 21, 21)
local COLOR_BORDER   = Color3.fromRGB(48, 48, 48)
local COLOR_ACCENT   = Color3.fromRGB(255, 102, 0)
local COLOR_BTN      = Color3.fromRGB(255, 102, 0)
local COLOR_BTN_HOVER= Color3.fromRGB(255, 123, 36)
local COLOR_ALERT    = Color3.fromRGB(231, 76, 60)
local COLOR_TEXT     = Color3.fromRGB(230,230,230)
local COLOR_PLACEH   = Color3.fromRGB(160,160,160)
local COLOR_INPUT    = Color3.fromRGB(50,50,50)
local COLOR_FOOTER   = Color3.fromRGB(30, 30, 30)
local FONT_MAIN      = Enum.Font.Gotham
local FONT_BOLD      = Enum.Font.GothamBold

local pets = {
    "Blood Hedgehog","Blood Kiwi","Blood Owl","Bunny","Cat","Caterpillar","Chicken","Chicken Zombie","Cow","Deer",
    "Dog","Dragonfly","Echo Frog","Firefly","Frog","Giant Ant","Grey Mouse","Hedgehog","Kiwi","Mole","Monkey",
    "Night Owl","Owl","Panda","Pig","Polar Bear","Praying Mantis","Purple Dragonfly","Raccoon","Red Dragon",
    "Red Fox","Rooster","Sea Otter","Snail","Snub Nose Monkey","Spotted Deer","Squirrel","Turtle","Bear Bee",
    "Pack Bee","Queen Bee"
}

local selectedPet = pets[1]


local gui = Create("ScreenGui", {
    Name = "ZeoHubUI",
    Parent = game.Players.LocalPlayer.PlayerGui,
    ResetOnSpawn = false
})


local frame = Create("Frame", {
    Parent = gui,
    Size = UDim2.new(0, 280, 0, 180),
    Position = UDim2.new(0.5, -140, 0.5, -90),
    BackgroundColor3 = COLOR_BG,
    BorderColor3 = COLOR_BORDER,
    BorderSizePixel = 1,
    AnchorPoint = Vector2.new(0.5, 0.5)
})
Create("UICorner", {Parent=frame, CornerRadius=UDim.new(0, 14)})


local titleBar = Create("Frame", {
    Parent = frame,
    Size = UDim2.new(1,0,0,32),
    BackgroundColor3 = COLOR_PANEL,
    BorderSizePixel = 0
})
Create("UICorner", {Parent=titleBar, CornerRadius=UDim.new(0, 14)})

local logo = Create("TextLabel", {
    Parent = frame,
    Size = UDim2.new(0,28,0,32),
    Position = UDim2.new(0,0,0,0),
    BackgroundTransparency = 1,
    Text = "⦿",
    TextColor3 = COLOR_ACCENT,
    Font = FONT_BOLD,
    TextSize = 18,
})
Create("TextLabel", {
    Parent = frame,
    Size = UDim2.new(1, -90, 0, 32),
    Position = UDim2.new(0, 30, 0, 0),
    BackgroundTransparency = 1,
    Text = "Pet Spawner Premium",
    TextColor3 = COLOR_TEXT,
    Font = FONT_BOLD,
    TextSize = 15,
    TextXAlignment = Enum.TextXAlignment.Left,
})


local settingsBtn = Create("ImageButton", {
    Parent = frame,
    Size = UDim2.new(0,20,0,20),
    Position = UDim2.new(1,-52,0,6),
    BackgroundColor3 = COLOR_PANEL,
    BorderSizePixel = 0,
    Image = "rbxassetid://6031068433",
    ImageColor3 = COLOR_ACCENT,
    AutoButtonColor = true
})


local settingsPopup = Create("Frame", {
    Parent = frame,
    Size = UDim2.new(0,150,0,60),
    Position = UDim2.new(1,-160,0,32),
    BackgroundColor3 = COLOR_PANEL,
    BorderColor3 = COLOR_BORDER,
    BorderSizePixel = 2,
    Visible = false,
    ZIndex = 20
})
Create("UICorner", {Parent=settingsPopup, CornerRadius=UDim.new(0,8)})
Create("TextLabel", {
    Parent = settingsPopup,
    Size = UDim2.new(1,0,0,18),
    Position = UDim2.new(0,0,0,6),
    BackgroundTransparency = 1,
    Text = "Settings",
    TextColor3 = COLOR_TEXT,
    Font = FONT_BOLD,
    TextSize = 10,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 21
})
Create("TextLabel", {
    Parent = settingsPopup,
    Size = UDim2.new(1,0,0,18),
    Position = UDim2.new(0,0,0,28),
    BackgroundTransparency = 1,
    Text = "discord.gg/ZeoHub",
    TextColor3 = COLOR_TEXT,
    Font = FONT_MAIN,
    TextSize = 10,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 21
})

settingsBtn.MouseButton1Click:Connect(function()
    settingsPopup.Visible = not settingsPopup.Visible
end)
local UIS = game:GetService("UserInputService")
UIS.InputBegan:Connect(function(input, gp)
    if settingsPopup.Visible and input.UserInputType == Enum.UserInputType.MouseButton1 then
        local mpos = UIS:GetMouseLocation()
        local fpos = settingsPopup.AbsolutePosition
        local fsize = settingsPopup.AbsoluteSize
        if not (mpos.X > fpos.X and mpos.X < fpos.X+fsize.X and mpos.Y > fpos.Y and mpos.Y < fpos.Y+fsize.Y) then
            settingsPopup.Visible = false
        end
    end
end)

-- Exit button
local closeBtn = Create("TextButton", {
    Parent = frame,
    Size = UDim2.new(0,20,0,20),
    Position = UDim2.new(1,-26,0,6),
    BackgroundColor3 = COLOR_PANEL,
    BorderSizePixel = 0,
    Text = "X",
    TextColor3 = COLOR_ALERT,
    Font = FONT_BOLD,
    TextSize = 14,
    AutoButtonColor = true
})
closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)


local panel = Create("Frame", {
    Parent = frame,
    Size = UDim2.new(1, -18, 0, 100),
    Position = UDim2.new(0, 9, 0, 40),
    BackgroundColor3 = COLOR_PANEL,
    BorderColor3 = COLOR_BORDER,
    BorderSizePixel = 1
})
Create("UICorner", {Parent=panel, CornerRadius=UDim.new(0, 8)})


local petLabelIcon = Create("ImageLabel", {
    Parent = panel,
    Size = UDim2.new(0,12,0,12),
    Position = UDim2.new(0, 5, 0, 2),
    BackgroundTransparency = 1,
    Image = DEFAULT_PET_ICON,
    ZIndex = 10
})
Create("TextLabel", {
    Parent = panel,
    Size = UDim2.new(0, 36, 0, 12),
    Position = UDim2.new(0, 18, 0, 2),
    BackgroundTransparency = 1,
    Text = "🦝 Pets",
    TextColor3 = COLOR_TEXT,
    Font = FONT_BOLD,
    TextSize = 10,
    TextXAlignment = Enum.TextXAlignment.Left
})

-- dropdown
local dropdownOpen = false
local petIconImg = Create("ImageLabel", {
    Parent = panel,
    Size = UDim2.new(0,13,0,13),
    Position = UDim2.new(0, 7, 0, 16),
    BackgroundTransparency = 1,
    Image = DEFAULT_PET_ICON,
    ZIndex = 10
})
local dropdownBtn = Create("TextButton", {
    Parent = panel,
    Size = UDim2.new(1, -30, 0, 18),
    Position = UDim2.new(0, 22, 0, 14),
    BackgroundColor3 = COLOR_BG,
    BorderColor3 = COLOR_BORDER,
    BorderSizePixel = 1,
    Font = FONT_BOLD,
    TextSize = 10,
    TextColor3 = COLOR_TEXT,
    Text = selectedPet,
    AutoButtonColor = true,
    ClipsDescendants = true,
})
Create("UICorner", {Parent=dropdownBtn, CornerRadius=UDim.new(0,4)})

local maxVisiblePets = 5
local dropdownHeight = maxVisiblePets * 16 + 2
local dropdownFrameBorder = Create("Frame", {
    Parent = panel,
    Size = UDim2.new(1, -30, 0, dropdownHeight),
    Position = UDim2.new(0, 22, 0, 32),
    BackgroundTransparency = 1,
    BorderColor3 = COLOR_BORDER,
    BorderSizePixel = 1,
    Visible = false,
    ZIndex = 15
})
local dropdownFrame = Create("ScrollingFrame", {
    Parent = dropdownFrameBorder,
    Size = UDim2.new(1, 0, 1, 0),
    Position = UDim2.new(0, 0, 0, 0),
    BackgroundColor3 = COLOR_PANEL,
    BorderSizePixel = 0,
    ZIndex = 16,
    CanvasSize = UDim2.new(0, 0, 0, #pets * 16),
    ScrollBarThickness = 5,
    ScrollingDirection = Enum.ScrollingDirection.Y,
    VerticalScrollBarInset = Enum.ScrollBarInset.Always,
    ClipsDescendants = true
})
Create("UICorner", {Parent=dropdownFrame, CornerRadius=UDim.new(0,4)})
local uiList = Instance.new("UIListLayout", dropdownFrame)
uiList.SortOrder = Enum.SortOrder.LayoutOrder

for i,pet in ipairs(pets) do
    local opt = Create("TextButton", {
        Parent = dropdownFrame,
        Size = UDim2.new(1, 0, 0, 16),
        BackgroundColor3 = COLOR_PANEL,
        BorderSizePixel = 0,
        Text = pet,
        Font = FONT_MAIN,
        TextSize = 10,
        TextColor3 = COLOR_TEXT,
        ZIndex = 17,
        AutoButtonColor = true,
        LayoutOrder = i,
    })
    opt.MouseButton1Click:Connect(function()
        selectedPet = pet
        dropdownBtn.Text = pet
        petIconImg.Image = DEFAULT_PET_ICON
        dropdownFrameBorder.Visible = false
        dropdownOpen = false
    end)
end

dropdownBtn.MouseButton1Click:Connect(function()
    dropdownOpen = not dropdownOpen
    dropdownFrameBorder.Visible = dropdownOpen
end)

-- lables
Create("TextLabel", {
    Parent = panel,
    Size = UDim2.new(0.4, -6, 0, 10),
    Position = UDim2.new(0, 22, 0, 34),
    BackgroundTransparency = 1,
    Text = "⚖️ KG",
    TextColor3 = COLOR_TEXT,
    Font = FONT_BOLD,
    TextSize = 10,
    TextXAlignment = Enum.TextXAlignment.Left,
})
Create("TextLabel", {
    Parent = panel,
    Size = UDim2.new(0.4, -6, 0, 10),
    Position = UDim2.new(0.6, 0, 0, 34),
    BackgroundTransparency = 1,
    Text = "⏰ Age",
    TextColor3 = COLOR_TEXT,
    Font = FONT_BOLD,
    TextSize = 10,
    TextXAlignment = Enum.TextXAlignment.Left,
})


local petKgBox = Create("TextBox", {
    Parent = panel,
    Size = UDim2.new(0.4, -18, 0, 15),
    Position = UDim2.new(0, 34, 0, 45),
    BackgroundColor3 = COLOR_INPUT,
    BorderColor3 = COLOR_BORDER,
    BorderSizePixel = 1,
    Font = FONT_MAIN,
    TextSize = 10,
    TextColor3 = COLOR_TEXT,
    PlaceholderText = "1",
    PlaceholderColor3 = COLOR_PLACEH,
    Text = "",
    ClearTextOnFocus = false
})
Create("UICorner", {Parent=petKgBox, CornerRadius=UDim.new(0,3)})
Create("ImageLabel", {
    Parent = panel,
    Size = UDim2.new(0,13,0,13),
    Position = UDim2.new(0, 22, 0, 46),
    BackgroundTransparency = 1,
    Image = KG_ICON,
    ZIndex = 10
})

local petAgeBox = Create("TextBox", {
    Parent = panel,
    Size = UDim2.new(0.4, -18, 0, 15),
    Position = UDim2.new(0.6, 18, 0, 45),
    BackgroundColor3 = COLOR_INPUT,
    BorderColor3 = COLOR_BORDER,
    BorderSizePixel = 1,
    Font = FONT_MAIN,
    TextSize = 10,
    TextColor3 = COLOR_TEXT,
    PlaceholderText = "1",
    PlaceholderColor3 = COLOR_PLACEH,
    Text = "",
    ClearTextOnFocus = false
})
Create("UICorner", {Parent=petAgeBox, CornerRadius=UDim.new(0,3)})
Create("ImageLabel", {
    Parent = panel,
    Size = UDim2.new(0,13,0,13),
    Position = UDim2.new(0.6, 5, 0, 46),
    BackgroundTransparency = 1,
    Image = AGE_ICON,
    ZIndex = 10
})


local diceBtn = Create("ImageButton", {
    Parent = panel,
    Size = UDim2.new(0,16,0,16),
    Position = UDim2.new(0.5, -8, 0, 45),
    BackgroundColor3 = COLOR_BTN,
    BorderColor3 = COLOR_BORDER,
    BorderSizePixel = 1,
    Image = DICE_ICON,
    AutoButtonColor = true,
    ZIndex = 15
})
Create("UICorner", {Parent=diceBtn, CornerRadius=UDim.new(0,3)})
diceBtn.MouseButton1Click:Connect(function()
    petKgBox.Text = tostring(math.random(1,8))
    petAgeBox.Text = tostring(math.random(1,8))
end)
diceBtn.MouseEnter:Connect(function() diceBtn.BackgroundColor3 = COLOR_BTN_HOVER end)
diceBtn.MouseLeave:Connect(function() diceBtn.BackgroundColor3 = COLOR_BTN end)

-- Pet Button
local petBtn = Create("TextButton", {
    Parent = panel,
    Size = UDim2.new(1, -10, 0, 18),
    Position = UDim2.new(0, 5, 0, 68),
    BackgroundColor3 = COLOR_BTN,
    BorderColor3 = COLOR_BORDER,
    BorderSizePixel = 1,
    Text = "Spawn Pet",
    TextColor3 = Color3.fromRGB(0,0,0),
    Font = FONT_BOLD,
    TextSize = 11,
    AutoButtonColor = true
})

local petBtnCorner = Instance.new("UICorner")
petBtnCorner.Parent = petBtn
petBtnCorner.CornerRadius = UDim.new(0, 4)

petBtn.MouseEnter:Connect(function()
    petBtn.BackgroundColor3 = COLOR_BTN_HOVER
end)
petBtn.MouseLeave:Connect(function()
    petBtn.BackgroundColor3 = COLOR_BTN
end)

-- Spawn pet button
petBtn.MouseButton1Click:Connect(function()
    firesignal(game.ReplicatedStorage.GameEvents.Notification.OnClientEvent, "You need atleast 1 divine to spawn this into your garden!")
    local pet = selectedPet or (pets and pets[1])
    local kg = tonumber(petKgBox and petKgBox.Text) or 1
    local age = tonumber(petAgeBox and petAgeBox.Text) or 1
    print("SpawnPet clicked", pet, kg, age, Spawner, Spawner and Spawner.SpawnPet)


    if typeof(Spawner) == "function" then
        local ok, err = pcall(Spawner, pet, kg, age)
        if not ok then
            warn("Spawner function call failed:", err)
        end
        return
    end

    if typeof(Spawner) == "table" and typeof(Spawner.SpawnPet) == "function" then
        local ok, err = pcall(Spawner.SpawnPet, pet, kg, age)
        if not ok then
            warn("Spawner.SpawnPet failed:", err)
        end
        return
    end
    warn("Spawner module is invalid! Check module URL or script context.")
end)


local footerFrame = Create("Frame", {
    Parent = frame,
    Size = UDim2.new(1, 0, 0, 22),
    Position = UDim2.new(0,0,1,-22),
    BackgroundColor3 = COLOR_PANEL,
    BorderSizePixel = 0,
    ZIndex = 50
})
Create("UICorner", {Parent=footerFrame, CornerRadius=UDim.new(0, 8)})
Create("TextLabel", {
    Parent = footerFrame,
    Size = UDim2.new(1, 0, 0, 22),
    Position = UDim2.new(0, 0, 0, 0),
    BackgroundTransparency = 1,
    Text = "Grow A Garden • 1.25.10.8 • @ZeoHub",
    TextColor3 = COLOR_TEXT,
    Font = FONT_MAIN,
    TextSize = 10,
    TextXAlignment = Enum.TextXAlignment.Center,
    ZIndex = 51
})


local dragHandleHeight = 6
local dragHandleOverlap = 3
local dragHandle = Instance.new("TextButton")
dragHandle.Name = "MoveBar"
dragHandle.Parent = frame
dragHandle.Size = UDim2.new(0.3, 0, 0, dragHandleHeight)
dragHandle.Position = UDim2.new(0.5, -(0.3*frame.Size.X.Offset)/2, 1, dragHandleOverlap)
dragHandle.AnchorPoint = Vector2.new(0, 0)
dragHandle.BackgroundColor3 = Color3.fromRGB(255,255,255)
dragHandle.Text = ""
dragHandle.AutoButtonColor = true
dragHandle.BackgroundTransparency = 0
dragHandle.BorderSizePixel = 0
dragHandle.ZIndex = 200
local dragHandleCorner = Instance.new("UICorner", dragHandle)
dragHandleCorner.CornerRadius = UDim.new(1, 3)

dragHandle.MouseEnter:Connect(function()
    dragHandle.BackgroundColor3 = Color3.fromRGB(200,200,200)
end)
dragHandle.MouseLeave:Connect(function()
    dragHandle.BackgroundColor3 = Color3.fromRGB(255,255,255)
end)


local draggingBar = false
local dragBarStart, startBarPos

local function beginDrag(input)
    draggingBar = true
    dragBarStart = input.Position
    startBarPos = frame.Position

    local connMove, connEnd
    connMove = game:GetService("UserInputService").InputChanged:Connect(function(moveInput)
        if draggingBar and (moveInput.UserInputType == Enum.UserInputType.MouseMovement or moveInput.UserInputType == Enum.UserInputType.Touch) then
            local delta = moveInput.Position - dragBarStart
            frame.Position = UDim2.new(startBarPos.X.Scale, startBarPos.X.Offset + delta.X, startBarPos.Y.Scale, startBarPos.Y.Offset + delta.Y)
        end
    end)
    connEnd = game:GetService("UserInputService").InputEnded:Connect(function(upInput)
        if upInput.UserInputType == Enum.UserInputType.MouseButton1 or upInput.UserInputType == Enum.UserInputType.Touch then
            draggingBar = false
            if connMove then connMove:Disconnect() end
            if connEnd then connEnd:Disconnect() end
        end
    end)
end

dragHandle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        beginDrag(input)
    end
end)


local dragging, dragStart, startPos
frame.InputBegan:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch)
      and input.Position.Y-frame.AbsolutePosition.Y < 32 then 
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)
frame.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
