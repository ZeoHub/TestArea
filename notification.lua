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

local PetPlacer = SafeRequire("https://raw.githubusercontent.com/ZeoHub/GrowAGardenV3/refs/heads/main/Nothing/Pet%20Placer.lua")
print("PetPlacer:", PetPlacer)

local Spawner = SafeRequire("https://raw.githubusercontent.com/DeltaGay/femboy/refs/heads/main/GardenSpawner.lua")
print("Spawner:", Spawner)
if Spawner and typeof(Spawner.Load) == "function" then
    print("Calling Spawner.Load()")
    Spawner.Load()
else
    warn("Spawner did not load or is missing the Load function!")
end
