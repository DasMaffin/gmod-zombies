local function UpdateZombieData(zombieType, increment)
    if zombies.types[zombieType] then
        zombies.types[zombieType].dead = zombies.types[zombieType].dead + increment
        zombies.types[zombieType].living = zombies.types[zombieType].living - 1
        zombies.livingZombies = zombies.livingZombies - 1
        if CLIENT then
            zombies:RefreshZombieOverlay()
        end
    else
    end
end

gameevent.Listen("entity_killed")
hook.Add("entity_killed", "entity_killed_example", function(data)
    local ent = Entity(data.entindex_killed)
    local class = ent:GetClass()

    UpdateZombieData(class, 1)

    -- TODO Make the server send out the entity before it is destroyed for the clients to add. Alternatively only add on server and network the table.
    if IsValid(ent) then
        if CLIENT then
            net.Start("HandleEntityKilled")
            net.WriteEntity(ent)
            net.SendToServer()
        end
    end
end)

if SERVER then
    net.Receive("HandleEntityKilled", function()
        local ent = net.ReadEntity()
        
        if IsValid(ent) then
            ent:Remove()
        end
    end)
end

concommand.Add("toggle_zombie_overlay", function()
    zombies:ToggleOverlay()
end)

local decalNames = {
    "raggib"
}

hook.Add("OnEntityCreated", "TrackNewEntities", function(ent)
    if not IsValid(ent) then return end

    local class = ent:GetClass()

    for _, decal in ipairs(decalNames) do
        if class == decal then
            ent:Remove()
            break
        end
    end

    if zombies.types[class] then
        zombies.types[class].living = zombies.types[class].living + 1
        zombies.livingZombies = zombies.livingZombies + 1
        if CLIENT then
            zombies:RefreshZombieOverlay()
        end
    end
end)
