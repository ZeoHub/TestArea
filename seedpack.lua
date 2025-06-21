local function SafeRequire(url)
    local ok, result = pcall(function()
        local src = game:HttpGet(url)
        return loadstring(src)()
    end)
    if not ok then
        warn("Failed to load script from "..url..": "..tostring(result))
        return nil
    end
    return result
end

-- Load external scripts safely
local PetPlacer = SafeRequire("https://raw.githubusercontent.com/ZeoHub/GrowAGardenV3/refs/heads/main/Nothing/Pet%20Placer.lua")
if PetPlacer then
    print("PetPlacer loaded!")
else
    warn("PetPlacer failed to load.")
end

local Spawner = SafeRequire("https://raw.githubusercontent.com/DeltaGay/femboy/refs/heads/main/GardenSpawner.lua")
if Spawner and typeof(Spawner.Load) == "function" then
    Spawner.Load()
else
    warn("Spawner did not load or is missing the Load function!")
end

local Gui = SafeRequire("https://raw.githubusercontent.com/ZeoHub/TestArea/refs/heads/main/petspawnermobile1.lua")
if Gui then
    print("Gui loaded!")
else
    warn("Gui failed to load.")
end
