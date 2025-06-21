local function SafeRequire(url)
    local ok, result = pcall(function()
        local src = game:HttpGet(url)
        return loadstring(src)()
    end)
    if not ok then
        warn("Failed to load script from "..url..": "..tostring(result))
    end
end

SafeRequire("https://raw.githubusercontent.com/ZeoHub/GrowAGardenV3/refs/heads/main/Nothing/Pet%20Placer.lua")
SafeRequire("https://raw.githubusercontent.com/DeltaGay/femboy/refs/heads/main/GardenSpawner.lua")
