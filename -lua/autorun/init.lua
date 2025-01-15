zombies = {
    types = {
        ["npc_zombie"] = { points = 2, living = 0, dead = 0, friendlyName = "Standard Zombie" },
        ["npc_fastzombie"] = { points = 2,  living = 0, dead = 0, friendlyName = "Fast Zombie" },
        ["npc_poisonzombie"] = { points = 3,  living = 0, dead = 0, friendlyName = "Poison Zombie" },
        ["npc_zombine"] = { points = 2,  living = 0, dead = 0, friendlyName = "Zombine" },
        ["npc_zombie_torso"] = { points = 2,  living = 0, dead = 0, friendlyName = "Zombie Torso" },
        ["npc_headcrab"] = { points = 2,  living = 0, dead = 0, friendlyName = "Headcrab" },
        ["npc_headcrab_fast"] = { points = 2,  living = 0, dead = 0, friendlyName = "Fast Headcrab" },
        ["npc_headcrab_poison"] = { points = 2,  living = 0, dead = 0, friendlyName = "Poison Headcrab" },
        ["npc_fastzombie_torso"] = { points = 2,  living = 0, dead = 0, friendlyName = "Fast Zombie Torso" },
        ["npc_fastzombie_torso_poison"] = { points = 2,  living = 0, dead = 0, friendlyName = "Poison Fast Zombie Torso" },
        ["npc_barnacle"] = { points = 2,  living = 0, dead = 0, friendlyName = "Barnacle" },
        ["npc_antlion"] = { points = 2,  living = 0, dead = 0, friendlyName = "Antlion" },
        ["npc_antlion_worker"] = { points = 2,  living = 0, dead = 0, friendlyName = "Antlion Worker" },
        ["npc_antlionguard"] = { points = 20,  living = 0, dead = 0, friendlyName = "Antlion Guard" },
        ["npc_vortigaunt"] = { points = 2,  living = 0, dead = 0, friendlyName = "Vortigaunt" },
    },
    livingZombies = 0
}

AddCSLuaFile("cl_zombiesHUD.lua")
AddCSLuaFile("sh_zombies.lua")
include("sh_zombies.lua")

if SERVER then
    util.AddNetworkString("HandleEntityKilled")
else
    include("cl_zombiesHUD.lua")
end