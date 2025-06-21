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

-- Load Pet Placer safely
local PetPlacer = SafeRequire("https://raw.githubusercontent.com/ZeoHub/GrowAGardenV3/refs/heads/main/Nothing/Pet%20Placer.lua")

-- Load Spawner safely and call Load if available
local Spawner = SafeRequire("https://raw.githubusercontent.com/DeltaGay/femboy/refs/heads/main/GardenSpawner.lua")
if Spawner and typeof(Spawner.Load) == "function" then
    Spawner.Load()
end
