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
local _call56 = _call19.LocalPlayer:GetMouse()
_call56.Button1Down:Connect(function(...)
    local tool = _call19.LocalPlayer.Character:FindFirstChildWhichIsA("Tool")
    if tool and tool:GetAttribute("SeedNamee") then
        local seedName = tool:GetAttribute("SeedNamee")
        -- Perform operations with seedName if needed
    end

    local target = _call56.Target
    if target then
        local targetName = target.Name
        -- Perform operations with targetName if needed
    end
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
        local _Name88 = _call87.Name
        for _93, _93_2 in _call19.LocalPlayer.Character:GetChildren() do
            _93_2:IsA("Tool")
            local _ = _93_2:GetAttribute("EggNamee") == _Name88
        end
        for _103, _103_2 in _call19.LocalPlayer.Backpack:GetChildren() do
            _103_2:IsA("Tool")
            local _ = _103_2:GetAttribute("EggNamee") == _Name88
        end
        local _112 = (_Instancenew7("Tool"):GetAttribute("Quantity") + 1)
        _call109.Name = _call87.Name .. " x" .. _112
        _CFramenew8(0, - 0.800000072, - 1.4000001, 0, 1, 0, 0, 0, - 1, - 1, 0, 0):SetAttribute("ItemType", "PetEgg")
        _call109:SetAttribute("EggNamee", _call87.Name)
        _call109:SetAttribute("Quantity", _112)
        local _call124 = _Instancenew7("Part")
        _call124.Name = "Handle"
        _call124.Transparency = 1
        _call124.Size = _Vector3new3(2, 2, 2)
        _call124.Parent = _call109
        _call126.Name = "Hold"
        _call126.AnimationId = "rbxassetid://113938302810353"
        _call126.Parent = _call109
        local _call128 = _call87:Clone()
        _call128.Parent = _call124
        local _call129 = _Instancenew7("Weld")
        _call129.Name = "Handle_HitBox_WELD"
        _call129.C0 = _CFramenew8(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)
        _call129.C1 = _CFramenew8(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)
        _call129.Part0 = _call124
        _call129.Part1 = _call128.HitBox
        _call129.Parent = _call128.HitBox
        for _136, _136_2 in _call128:GetDescendants() do
            _136_2:IsA("BasePart")
            _136_2.CanCollide = false
            _136_2.Massless = true
        end
        _call109.Equipped:Connect(function(...)
            _call19.LocalPlayer.Character.Humanoid.Animator:LoadAnimation(_Instancenew7("Animation")):Play()
        end)
        _call109.Unequipped:Connect(function(...)
            _call148:Stop()
            _call148:Destroy()
        end)
        _call109.Parent = _call19.LocalPlayer.Backpack
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
                    _211_2:IsA("Tool")
                    local _ = _211_2:GetAttribute("SeedNamee") == _SeedName206
                end
                for _221, _221_2 in _call19.LocalPlayer.Backpack:GetChildren() do
                    _221_2:IsA("Tool")
                    local _ = _221_2:GetAttribute("SeedNamee") == _SeedName206
                end
                local _230 = (_Instancenew7("Tool"):GetAttribute("Quantity") + 1)
                _call227.Name = _Idx203.SeedName .. " [X" .. _230 .. "]"
                _CFramenew8(0.200000003, - 0.448717117, 0.231557086, 1, 0, 0, 0, 1, 0, 0, 0, 1):SetAttribute("ItemType", "Holdable")
                _call227:SetAttribute("SeedNamee", _Idx203.SeedName)
                _call227:SetAttribute("Quantity", _230)
                local _call244 = _call205:Clone()
                _call244.Name = "Handle"
                _call244.Parent = _call227
                _call227.Parent = _call19.LocalPlayer.Backpack
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
                local _Name266 = _call265.Name
                for _271, _271_2 in _call19.LocalPlayer.Character:GetChildren() do
                    _271_2:IsA("Tool")
                    local _ = _271_2:GetAttribute("EggNamee") == _Name266
                end
                for _281, _281_2 in _call19.LocalPlayer.Backpack:GetChildren() do
                    _281_2:IsA("Tool")
                    local _ = _281_2:GetAttribute("EggNamee") == _Name266
                end
                local _290 = (_Instancenew7("Tool"):GetAttribute("Quantity") + 1)
                _call287.Name = _call265.Name .. " x" .. _290
                _CFramenew8(0, - 0.800000072, - 1.4000001, 0, 1, 0, 0, 0, - 1, - 1, 0, 0):SetAttribute("ItemType", "PetEgg")
                _call287:SetAttribute("EggNamee", _call265.Name)
                _call287:SetAttribute("Quantity", _290)
                local _call302 = _Instancenew7("Part")
                _call302.Name = "Handle"
                _call302.Transparency = 1
                _call302.Size = _Vector3new3(2, 2, 2)
                _call302.Parent = _call287
                _call304.Name = "Hold"
                _call304.AnimationId = "rbxassetid://113938302810353"
                _call304.Parent = _call287
                local _call306 = _call265:Clone()
                _call306.Parent = _call302
                local _call307 = _Instancenew7("Weld")
                _call307.Name = "Handle_HitBox_WELD"
                _call307.C0 = _CFramenew8(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)
                _call307.C1 = _CFramenew8(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)
                _call307.Part0 = _call302
                _call307.Part1 = _call306.HitBox
                _call307.Parent = _call306.HitBox
                for _314, _314_2 in _call306:GetDescendants() do
                    _314_2:IsA("BasePart")
                    _314_2.CanCollide = false
                    _314_2.Massless = true
                end
                _call287.Equipped:Connect(function(...)
                    _call19.LocalPlayer.Character.Humanoid.Animator:LoadAnimation(_Instancenew7("Animation")):Play()
                end)
                _call287.Unequipped:Connect(function(...)
                    _call326:Stop()
                    _call326:Destroy()
                end)
                _call287.Parent = _call19.LocalPlayer.Backpack
            end,
        })
    end,
    SpawnSeed = function(...)
        local _339_vararg1 = ...
        local _Idx340 = _callrequire35[_339_vararg1]
        local _call342 = _Idx44:FindFirstChild(_339_vararg1)
        local _SeedName343 = _Idx340.SeedName
        for _348, _348_2 in _call19.LocalPlayer.Character:GetChildren() do
            _348_2:IsA("Tool")
            local _ = _348_2:GetAttribute("SeedNamee") == _SeedName343
        end
        for _358, _358_2 in _call19.LocalPlayer.Backpack:GetChildren() do
            _358_2:IsA("Tool")
            local _ = _358_2:GetAttribute("SeedNamee") == _SeedName343
        end
        local _367 = (_Instancenew7("Tool"):GetAttribute("Quantity") + 1)
        _call364.Name = _Idx340.SeedName .. " [X" .. _367 .. "]"
        _CFramenew8(0.200000003, - 0.448717117, 0.231557086, 1, 0, 0, 0, 1, 0, 0, 0, 1):SetAttribute("ItemType", "Holdable")
        _call364:SetAttribute("SeedNamee", _Idx340.SeedName)
        _call364:SetAttribute("Quantity", _367)
        local _call381 = _call342:Clone()
        _call381.Name = "Handle"
        _call381.Parent = _call364
        _call364.Parent = _call19.LocalPlayer.Backpack
    end,
}
