-- ULX Zombie Spawning Script

-- Helper function to spawn a zombie
local function SpawnZombie(calling_ply, zombie_type, position)
    local zombie = ents.Create(zombie_type) -- Create the NPC with the given type
    if not IsValid(zombie) then
        ULib.tsayError(calling_ply, "Invalid zombie type: " .. tostring(zombie_type))
        return
    end

    -- Set spawn position and other properties
    zombie:SetPos(position or calling_ply:GetEyeTrace().HitPos + Vector(0, 0, 10)) -- Spawn in front of the admin
    zombie:Spawn()    
    zombie:SetBloodColor(0)
    
    ULib.tsay(calling_ply, "Spawned " .. zombie_type .. " at " .. tostring(zombie:GetPos()))
end

valid_zombies = {
    ["npc_zombie"] = true,
    ["npc_fastzombie"] = true,
    ["npc_poisonzombie"] = true,
    ["npc_zombine"] = true,
    ["npc_zombie_torso"] = true,
    ["npc_headcrab"] = true,
    ["npc_headcrab_fast"] = true,
    ["npc_headcrab_poison"] = true,
    ["npc_fastzombie_torso"] = true,
    ["npc_fastzombie_torso_poison"] = true,
    ["npc_barnacle"] = true,
    ["npc_antlion"] = true,
    ["npc_antlion_worker"] = true,
    ["npc_antlionguard"] = true,
    ["npc_vortigaunt"] = true,
}

local zombieList = {
    "npc_zombie",
    "npc_fastzombie",
    "npc_poisonzombie",
    "npc_zombine",
    "npc_zombie_torso",
    "npc_headcrab",
    "npc_headcrab_fast",
    "npc_headcrab_poison",
    "npc_fastzombie_torso",
    "npc_fastzombie_torso_poison",
    "npc_barnacle",
    "npc_antlion",
    "npc_antlion_worker",
    "npc_antlionguard",
    "npc_vortigaunt"
}

-- ULX command for spawning zombies
function ulx.spawnzombie(calling_ply, zombie_type)
    -- Check if the type is valid
    if not valid_zombies[zombie_type] then
        ULib.tsayError(calling_ply, "Invalid zombie type! Valid types are: npc_zombie, npc_fastzombie, npc_poisonzombie.")
        return
    end

    -- Spawn the zombie
    SpawnZombie(calling_ply, zombie_type)
end

-- Register the ULX command
local spawnzombie = ulx.command("Fun", "ulx spawnzombie", ulx.spawnzombie, "!spawnzombie")
spawnzombie:addParam{ type = ULib.cmds.StringArg, completes = zombieList, hint = "npc_zombie" }
spawnzombie:defaultAccess(ULib.ACCESS_ADMIN)
spawnzombie:help("Spawns a zombie of the specified type.")

-- ULX command for spawning multiple zombies with offset positions
function ulx.spawnzombies(calling_ply, zombie_type, count)
    -- Check if the type is valid
    if not valid_zombies[zombie_type] then
        ULib.tsayError(calling_ply, "Invalid zombie type! Valid types are: npc_zombie, npc_fastzombie, npc_poisonzombie.")
        return
    end

    if count <= 0 then
        ULib.tsayError(calling_ply, "You must spawn at least one zombie.")
        return
    end

    -- Spawn the zombies with offsets
    local base_position = calling_ply:GetEyeTrace().HitPos + Vector(0, 0, 10) -- Base position to spawn zombies
    local offset_distance = 50 -- Distance to offset each zombie
    local current_angle = 0 -- Angle for circular placement

    for i = 1, count do
        -- Calculate offset position
        local offset = Vector(
            math.cos(math.rad(current_angle)) * offset_distance,
            math.sin(math.rad(current_angle)) * offset_distance,
            0
        )
        local spawn_position = base_position + offset

        -- Spawn the zombie
        SpawnZombie(calling_ply, zombie_type, spawn_position)

        -- Update angle for the next zombie
        current_angle = current_angle + (360 / count)
    end

    ULib.tsay(calling_ply, "Spawned " .. count .. " " .. zombie_type .. "(s).")
end

-- Register the ULX command for multiple zombies
local spawnzombies = ulx.command("Fun", "ulx spawnzombies", ulx.spawnzombies, "!spawnzombies")
spawnzombies:addParam{ type = ULib.cmds.StringArg, completes = zombieList, hint = "npc_zombie" }
spawnzombies:addParam{ type = ULib.cmds.NumArg, hint = "number of zombies to spawn", min = 1, default = 1, ULib.cmds.optional }
spawnzombies:defaultAccess(ULib.ACCESS_ADMIN)
spawnzombies:help("Spawns multiple zombies of the specified type.")
