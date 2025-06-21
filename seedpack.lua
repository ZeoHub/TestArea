local Spawner = SafeRequire("https://raw.githubusercontent.com/DeltaGay/femboy/refs/heads/main/GardenSpawner.lua")
print("Spawner is:", Spawner)
print("Type of Spawner:", typeof(Spawner))
if Spawner then
    print("Spawner.Load is:", Spawner.Load)
    print("Type of Spawner.Load:", typeof(Spawner.Load))
end
if Spawner and typeof(Spawner.Load) == "function" then
    Spawner.Load()
else
    warn("Spawner did not load or is missing the Load function!")
end
