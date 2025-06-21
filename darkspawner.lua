-- ts file was generated at discord.gg/25ms

local genv = getgenv()
local fenv = getfenv()
local _ = fenv.Ray
local _Vector3new3 = Vector3.new
local _ = TweenInfo.new
local _ = Enum.EasingStyle
local _ = Enum.EasingDirection
local _Instancenew7 = Instance.new
local _CFramenew8 = CFrame.new
local _ = genv.Executed
genv.Executed = true
local _call11 = game:GetService("ReplicatedStorage")
game:GetService("TweenService")
game:GetService("Workspace")
local _call19 = game:GetService("Players")
require(_call11.Data.PetRegistry)
local _callrequire26 = require(_call11.Data.PetRegistry.PetList)
require(_call11.Modules.SeedPackController)
local _callrequire32 = require(_call11.Data.SeedPackData)
local _callrequire35 = require(_call11.Data.SeedData)
require(_call11.Modules.Notification)
local _Idx41 = game:GetObjects("rbxassetid://118358827691673")[1]
local _Idx44 = game:GetObjects("rbxassetid://125869296102137")[1]
for _47, _47_2 in _Idx41:GetChildren() do
    local _ = _47_2.Name
end
for _51, _51_2 in _Idx44:GetChildren() do
    local _ = _51_2.Name
end
local _ = game:GetService("UserInputService").TouchEnabled
local _call56 = _call19.LocalPlayer:GetMouse()
_call56.Button1Down:Connect(function(...)
    local tool = _call19.LocalPlayer.Character and _call19.LocalPlayer.Character:FindFirstChildWhichIsA("Tool")
    if tool and tool.GetAttribute then
        local attr = tool:GetAttribute("SeedNamee")
        -- do stuff with attr if needed
    end
    local _ = _call56.Target
    local _ = _call56.Target and _call56.Target.Name
end)
return {
    GetPets = function(...)
        return {
            [1] = _Name48,
        }
    end,
    Spin = function(...)
        for _73, _73_2 in _callrequire32.Packs do
            for _75, _75_2 in _73_2.Items do
                local _ = _75_2.Type
            end
        end
    end,
    GetSeeds = function(...)
        return {
            [1] = _Name52,
        }
    end,
    SpawnPet = function(...)
        local _78_vararg1 = ...
        local _ = _callrequire26[_78_vararg1]
        _Idx41:FindFirstChild(_78_vararg1)
    end,
    SpawnEgg = function(...)
        local _82_vararg1 = ...
        local _call87 = _call11.Assets.Models.EggModels:FindFirstChild(_82_vararg1)
        local _Name88 = _call87 and _call87.Name
        if not _call87 then return end
        for _93, _93_2 in _call19.LocalPlayer.Character:GetChildren() do
            if _93_2 and _93_2:IsA("Tool") and _93_2.GetAttribute then
                local _ = _93_2:GetAttribute("EggNamee") == _Name88
            end
        end
        for _103, _103_2 in _call19.LocalPlayer.Backpack:GetChildren() do
            if _103_2 and _103_2:IsA("Tool") and _103_2.GetAttribute then
                local _ = _103_2:GetAttribute("EggNamee") == _Name88
            end
        end
        local _newTool = _Instancenew7("Tool")
        local _currQ = (_newTool:GetAttribute("Quantity") or 0) + 1
        _newTool.Name = _call87.Name .. " x" .. _currQ
        _CFramenew8(0, -0.800000072, -1.4000001, 0, 1, 0, 0, 0, -1, -1, 0, 0):SetAttribute("ItemType", "PetEgg")
        _newTool:SetAttribute("EggNamee", _call87.Name)
        _newTool:SetAttribute("Quantity", _currQ)
        local _call124 = _Instancenew7("Part")
        _call124.Name = "Handle"
        _call124.Transparency = 1
        _call124.Size = _Vector3new3(2, 2, 2)
        _call124.Parent = _newTool
        -- Hold animation (dummy, can be adjusted)
        local _call126 = _Instancenew7("Animation")
        _call126.Name = "Hold"
        _call126.AnimationId = "rbxassetid://113938302810353"
        _call126.Parent = _newTool
        local _call128 = _call87:Clone()
        _call128.Parent = _call124
        local hitbox = _call128:FindFirstChild("HitBox")
        if hitbox then
            local _call129 = _Instancenew7("Weld")
            _call129.Name = "Handle_HitBox_WELD"
            _call129.C0 = _CFramenew8(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)
            _call129.C1 = _CFramenew8(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)
            _call129.Part0 = _call124
            _call129.Part1 = hitbox
            _call129.Parent = hitbox
        end
        for _, desc in ipairs(_call128:GetDescendants()) do
            if desc:IsA("BasePart") then
                desc.CanCollide = false
                desc.Massless = true
            end
        end
        _newTool.Equipped:Connect(function(...)
            local humanoid = _call19.LocalPlayer.Character and _call19.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Animator then
                local anim = _Instancenew7("Animation")
                -- Set AnimationId if you have a real one
                local track = humanoid.Animator:LoadAnimation(anim)
                track:Play()
            end
        end)
        _newTool.Unequipped:Connect(function(...)
            -- Cleanup logic if needed
        end)
        _newTool.Parent = _call19.LocalPlayer.Backpack
    end,
    Load = function(...)
        local _call167 = loadstring(game:HttpGet("https://sirius.menu/rayfield"))():CreateWindow({
            LoadingTitle = "Dark Spawner",
            LoadingSubtitle = "Made by whqtt",
            Name = "Dark Spawner",
            Theme = "Default",
        })
        _call167:CreateTab("Pet Spawner", 136232391555861):CreateSection("Pet Spawner")
        _call167:CreateTab("Seed Spawner", 111869302762063):CreateSection("Seed Spawner")
        _call167:CreateTab("Egg Spawner", 133763620419151):CreateSection("Egg Spawner")
        _call169:CreateDropdown({
            Callback = function(...)
                local _182_vararg1 = ...
                local _ = _182_vararg1[1]
            end,
            Options = {
                [1] = _Name48,
            },
            Name = "Pet",
        })
        _call169:CreateInput({
            RemoveTextAfterFocusLost = false,
            CurrentValue = "",
            PlaceholderText = "1",
            Callback = function(...)
            end,
            Name = "Pet Weight",
        })
        _call169:CreateInput({
            RemoveTextAfterFocusLost = false,
            CurrentValue = "",
            PlaceholderText = "1",
            Callback = function(...)
            end,
            Name = "Pet Age",
        })
        _call169:CreateButton({
            Name = "Spawn",
            Callback = function(...)
                local _ = _callrequire26[_Idx183]
                _Idx41:FindFirstChild(_Idx183)
            end,
        })
        _call173:CreateDropdown({
            Callback = function(...)
                local _198_vararg1 = ...
                local _ = _198_vararg1[1]
            end,
            Options = {
                [1] = _Name52,
            },
            Name = "Seed",
        })
        _call173:CreateButton({
            Name = "Spawn",
            Callback = function(...)
                local _Idx203 = _callrequire35[_Idx199]
                local _call205 = _Idx44:FindFirstChild(_Idx199)
                local _SeedName206 = _Idx203.SeedName
                for _211, _211_2 in _call19.LocalPlayer.Character:GetChildren() do
                    if _211_2 and _211_2:IsA("Tool") and _211_2.GetAttribute then
                        local _ = _211_2:GetAttribute("SeedNamee") == _SeedName206
                    end
                end
                for _221, _221_2 in _call19.LocalPlayer.Backpack:GetChildren() do
                    if _221_2 and _221_2:IsA("Tool") and _221_2.GetAttribute then
                        local _ = _221_2:GetAttribute("SeedNamee") == _SeedName206
                    end
                end
                local _newTool = _Instancenew7("Tool")
                local _currQ = (_newTool:GetAttribute("Quantity") or 0) + 1
                _newTool.Name = _Idx203.SeedName .. " [X" .. _currQ .. "]"
                _CFramenew8(0.200000003, -0.448717117, 0.231557086, 1, 0, 0, 0, 1, 0, 0, 0, 1):SetAttribute("ItemType", "Holdable")
                _newTool:SetAttribute("SeedNamee", _Idx203.SeedName)
                _newTool:SetAttribute("Quantity", _currQ)
                local _call244 = _call205:Clone()
                _call244.Name = "Handle"
                _call244.Parent = _newTool
                _newTool.Parent = _call19.LocalPlayer.Backpack
            end,
        })
        _call173:CreateButton({
            Name = "Spin",
            Callback = function(...)
                for _251, _251_2 in _callrequire32.Packs do
                    for _253, _253_2 in _251_2.Items do
                        local _ = _253_2.Type
                    end
                end
            end,
        })
        _call177:CreateInput({
            RemoveTextAfterFocusLost = false,
            CurrentValue = "",
            PlaceholderText = "Night Egg",
            Callback = function(...)
            end,
            Name = "Egg Name",
        })
        _call177:CreateButton({
            Name = "Spawn",
            Callback = function(...)
                local _call265 = _call11.Assets.Models.EggModels:FindFirstChild(_257_vararg1)
                local _Name266 = _call265 and _call265.Name
                if not _call265 then return end
                for _271, _271_2 in _call19.LocalPlayer.Character:GetChildren() do
                    if _271_2 and _271_2:IsA("Tool") and _271_2.GetAttribute then
                        local _ = _271_2:GetAttribute("EggNamee") == _Name266
                    end
                end
                for _281, _281_2 in _call19.LocalPlayer.Backpack:GetChildren() do
                    if _281_2 and _281_2:IsA("Tool") and _281_2.GetAttribute then
                        local _ = _281_2:GetAttribute("EggNamee") == _Name266
                    end
                end
                local _newTool = _Instancenew7("Tool")
                local _currQ = (_newTool:GetAttribute("Quantity") or 0) + 1
                _newTool.Name = _call265.Name .. " x" .. _currQ
                _CFramenew8(0, -0.800000072, -1.4000001, 0, 1, 0, 0, 0, -1, -1, 0, 0):SetAttribute("ItemType", "PetEgg")
                _newTool:SetAttribute("EggNamee", _call265.Name)
                _newTool:SetAttribute("Quantity", _currQ)
                local _call302 = _Instancenew7("Part")
                _call302.Name = "Handle"
                _call302.Transparency = 1
                _call302.Size = _Vector3new3(2, 2, 2)
                _call302.Parent = _newTool
                local _call304 = _Instancenew7("Animation")
                _call304.Name = "Hold"
                _call304.AnimationId = "rbxassetid://113938302810353"
                _call304.Parent = _newTool
                local _call306 = _call265:Clone()
                _call306.Parent = _call302
                local hitbox = _call306:FindFirstChild("HitBox")
                if hitbox then
                    local _call307 = _Instancenew7("Weld")
                    _call307.Name = "Handle_HitBox_WELD"
                    _call307.C0 = _CFramenew8(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)
                    _call307.C1 = _CFramenew8(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)
                    _call307.Part0 = _call302
                    _call307.Part1 = hitbox
                    _call307.Parent = hitbox
                end
                for _, desc in ipairs(_call306:GetDescendants()) do
                    if desc:IsA("BasePart") then
                        desc.CanCollide = false
                        desc.Massless = true
                    end
                end
                _newTool.Equipped:Connect(function(...)
                    local humanoid = _call19.LocalPlayer.Character and _call19.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                    if humanoid and humanoid.Animator then
                        local anim = _Instancenew7("Animation")
                        -- Set AnimationId if you have a real one
                        local track = humanoid.Animator:LoadAnimation(anim)
                        track:Play()
                    end
                end)
                _newTool.Unequipped:Connect(function(...)
                    -- Cleanup logic if needed
                end)
                _newTool.Parent = _call19.LocalPlayer.Backpack
            end,
        })
    end,
    SpawnSeed = function(...)
        local _339_vararg1 = ...
        local _Idx340 = _callrequire35[_339_vararg1]
        local _call342 = _Idx44:FindFirstChild(_339_vararg1)
        local _SeedName343 = _Idx340.SeedName
        for _348, _348_2 in _call19.LocalPlayer.Character:GetChildren() do
            if _348_2 and _348_2:IsA("Tool") and _348_2.GetAttribute then
                local _ = _348_2:GetAttribute("SeedNamee") == _SeedName343
            end
        end
        for _358, _358_2 in _call19.LocalPlayer.Backpack:GetChildren() do
            if _358_2 and _358_2:IsA("Tool") and _358_2.GetAttribute then
                local _ = _358_2:GetAttribute("SeedNamee") == _SeedName343
            end
        end
        local _newTool = _Instancenew7("Tool")
        local _currQ = (_newTool:GetAttribute("Quantity") or 0) + 1
        _newTool.Name = _Idx340.SeedName .. " [X" .. _currQ .. "]"
        _CFramenew8(0.200000003, -0.448717117, 0.231557086, 1, 0, 0, 0, 1, 0, 0, 0, 1):SetAttribute("ItemType", "Holdable")
        _newTool:SetAttribute("SeedNamee", _Idx340.SeedName)
        _newTool:SetAttribute("Quantity", _currQ)
        local _call381 = _call342:Clone()
        _call381.Name = "Handle"
        _call381.Parent = _newTool
        _newTool.Parent = _call19.LocalPlayer.Backpack
    end,
}
