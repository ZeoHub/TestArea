local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local SeedPackController = require(ReplicatedStorage.Modules.SeedPackController)
local SeedPackData = require(ReplicatedStorage.Data.SeedPackData)

-- Main GUI
local ScreenGui = Instance.new("ScreenGui", playerGui)
ScreenGui.Name = "IngeniousScriptSeedOpenerGUI"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local Frame = Instance.new("Frame", ScreenGui)
Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Frame.Position = UDim2.new(0.4, 0, 0.35, 0)
Frame.Size = UDim2.new(0, 260, 0, 180)
Frame.Active = true
Frame.Draggable = true
Frame.BorderSizePixel = 0

local UICorner = Instance.new("UICorner", Frame)
UICorner.CornerRadius = UDim.new(0, 16)

-- Title Box
local TitleBox = Instance.new("TextLabel", Frame)
TitleBox.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TitleBox.BackgroundTransparency = 0.4
TitleBox.Position = UDim2.new(0.07, 0, 0.03, 0)
TitleBox.Size = UDim2.new(0.86, 0, 0.2, 0)
TitleBox.Font = Enum.Font.Gotham
TitleBox.Text = "Ingenious Script Seed Pack Opener"
TitleBox.TextColor3 = Color3.fromRGB(255, 215, 0)
TitleBox.TextScaled = true
TitleBox.TextStrokeTransparency = 0.7
TitleBox.TextTransparency = 0.05
TitleBox.BorderSizePixel = 0

local titleCorner = Instance.new("UICorner", TitleBox)
titleCorner.CornerRadius = UDim.new(0, 12)

-- Gold Texture
local goldTexture = Instance.new("ImageLabel", TitleBox)
goldTexture.Image = "rbxassetid://11478733258"
goldTexture.Size = UDim2.new(1, 0, 1, 0)
goldTexture.BackgroundTransparency = 1
goldTexture.ZIndex = 0

-- Shiny line animation
local ShineLine = Instance.new("Frame", TitleBox)
ShineLine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ShineLine.Size = UDim2.new(0.08, 0, 1, 0)
ShineLine.Position = UDim2.new(-0.1, 0, 0, 0)
ShineLine.BackgroundTransparency = 0.6
ShineLine.BorderSizePixel = 0

task.spawn(function()
	while true do
		ShineLine.Position = UDim2.new(-0.1, 0, 0, 0)
		ShineLine:TweenPosition(UDim2.new(1.1, 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Linear, 0.7, true)
		task.wait(1)
	end
end)

-- Seed Pack Input
local packInput = Instance.new("TextBox", Frame)
packInput.Position = UDim2.new(0.07, 0, 0.3, 0)
packInput.Size = UDim2.new(0.86, 0, 0.15, 0)
packInput.PlaceholderText = "Seed Pack Name"
packInput.Text = ""
packInput.Font = Enum.Font.Gotham
packInput.TextSize = 14
packInput.TextColor3 = Color3.fromRGB(0, 0, 0)
packInput.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
packInput.BorderSizePixel = 0
Instance.new("UICorner", packInput).CornerRadius = UDim.new(0, 8)

-- Seed Name Input
local seedInput = Instance.new("TextBox", Frame)
seedInput.Position = UDim2.new(0.07, 0, 0.5, 0)
seedInput.Size = UDim2.new(0.86, 0, 0.15, 0)
seedInput.PlaceholderText = "Seed Name"
seedInput.Text = ""
seedInput.Font = Enum.Font.Gotham
seedInput.TextSize = 14
seedInput.TextColor3 = Color3.fromRGB(0, 0, 0)
seedInput.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
seedInput.BorderSizePixel = 0
Instance.new("UICorner", seedInput).CornerRadius = UDim.new(0, 8)

-- Open Button
local Button = Instance.new("TextButton", Frame)
Button.Position = UDim2.new(0.07, 0, 0.7, 0)
Button.Size = UDim2.new(0.86, 0, 0.2, 0)
Button.Text = "Open"
Button.Font = Enum.Font.GothamBold
Button.TextSize = 20
Button.TextColor3 = Color3.new(1, 1, 1)
Button.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
Button.BorderSizePixel = 0
Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 12)

-- Open Logic
Button.MouseButton1Click:Connect(function()
	local packName = packInput.Text
	local seedName = seedInput.Text

	local pack = SeedPackData.Packs[packName]
	if not pack then
		Button.Text = "❌ Invalid Pack"
		Button.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
		task.wait(1.5)
		Button.Text = "Open"
		Button.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
		return
	end

	local index = nil
	for i, item in ipairs(pack.Items) do
		if item.Name == seedName or item.RewardId == seedName then
			index = i
			break
		end
	end

	if not index then
		Button.Text = "❌ Seed Not Found"
		Button.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
		task.wait(1.5)
		Button.Text = "Open"
		Button.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
		return
	end

	-- Do the spin
	SeedPackController:Spin({
		seedPackType = packName,
		resultIndex = index
	})

	Button.Text = "✅ Opened!"
	Button.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
	task.wait(1.2)
	Button.Text = "Open"
	Button.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
end)
