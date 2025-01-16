/*--------------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
include("autorun/vj_controls.lua")

local cvarList = {}
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Admin Settings ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
cvarList["vj_npc_admin_properties"] = 0 -- Should the properties menu be restricted to admins only?
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ NPC Attack & Weapon Settings ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
cvarList["vj_npc_range"] = 1 -- Can NPCs do range attacks?
cvarList["vj_npc_leap"] = 1 -- Can NPCs do leap attacks?
cvarList["vj_npc_melee"] = 1 -- Can NPCs do melee attacks?
cvarList["vj_npc_melee_ply_slow"] = 1 -- Can NPCs slow down players on melee attack?
cvarList["vj_npc_melee_bleed"] = 1 -- Can NPCs deal bleeding to enemies on melee attack?
cvarList["vj_npc_melee_prop_push"] = 1 -- Can NPCs push props away using their melee attack?
cvarList["vj_npc_melee_prop_attack"] = 1 -- Can NPCs attack props away using their melee attack?
cvarList["vj_npc_melee_ply_dsp"] = 1 -- Should melee attacks cause DSP effect on heavy damages?
cvarList["vj_npc_grenade"] = 1 -- Can NPCs do grenade attacks?
cvarList["vj_npc_wep"] = 1 -- Can NPCs use weapons?
cvarList["vj_npc_wep_reload"] = 1 -- Can NPCs reload their weapon?
cvarList["vj_npc_wep_drop"] = 1 -- Should NPCs drop their weapon on death?
cvarList["vj_npc_wep_ply_pickup"] = 1 -- Can players pick up NPC dropped weapons?
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ NPC AI Settings ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
cvarList["vj_npc_sight_distance"] = 0 -- Override all NPCs to use the set number as their sight distance | 0 = Don't override
cvarList["vj_npc_sight_xray"] = 0 -- Should they have X-Ray vision with 360 FOV?
cvarList["vj_npc_wander"] = 1 -- Can NPCs wander around?
cvarList["vj_npc_chase"] = 1 -- Can NPCs chase enemies?
cvarList["vj_npc_flinch"] = 1 -- Can NPCs play their flinch animations?
cvarList["vj_npc_investigate"] = 1 -- Can NPCs detect and investigate disturbances?
cvarList["vj_npc_callhelp"] = 1 -- Can NPCs call for help?
cvarList["vj_npc_ply_follow"] = 1 -- Can NPCs follow players?
cvarList["vj_npc_medic"] = 1 -- Can NPCs be medics?
cvarList["vj_npc_eat"] = 1 -- Can NPCs eat things like corpses or gibs?
cvarList["vj_npc_dangerdetection"] = 1 -- Can NPCs run from grenades/dangers
cvarList["vj_npc_runontouch"] = 1 -- Can passive NPCs run away on touch?
cvarList["vj_npc_runonhit"] = 1 -- Can passive NPCs run away when damaged?
cvarList["vj_npc_human_jump"] = 1 -- Can the human NPCs jump?
cvarList["vj_npc_creature_opendoor"] = 1 -- Should Creatures open doors?
cvarList["vj_npc_allies"] = 1 -- Can NPCs ally to other entities?
cvarList["vj_npc_ply_betray"] = 1 -- Can friendly NPCs become enemy to players?
cvarList["vj_npc_fri_base"] = 0 -- Makes the NPC Friendly to all VJ NPCs
cvarList["vj_npc_fri_player"] = 0 -- Makes the NPC Friendly to Players
cvarList["vj_npc_fri_zombie"] = 0 -- Makes the NPC Friendly to Zombies
cvarList["vj_npc_fri_antlion"] = 0 -- Makes the NPC Friendly to Antlion
cvarList["vj_npc_fri_combine"] = 0 -- Makes the NPC Friendly to Combine
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ General Settings ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
cvarList["vj_npc_difficulty"] = 0 -- Difficulty of the NPCs
cvarList["vj_npc_anim_death"] = 1 -- Can NPCs play death animation?
cvarList["vj_npc_god"] = 0 -- The NPC will never die!
cvarList["vj_npc_health"] = 0 -- Health Changer
cvarList["vj_npc_blood"] = 1 -- Can NPCs bleed?
cvarList["vj_npc_blood_pool"] = 1 -- Can corpses spawn blood pools?
cvarList["vj_npc_blood_gmod"] = 0 -- Should Garry's Mod's blood decals be used whenever possible?
cvarList["vj_npc_corpse"] = 1 -- Can NPCs create corpses?
cvarList["vj_npc_corpse_limit"] = 32 -- What is the limit for NPC corpses on the ground? (When Keep Corpses is off)
cvarList["vj_npc_corpse_collision"] = 0 -- Collision type for the NPC's corpse
cvarList["vj_npc_corpse_fade"] = 0 -- Make Corpses fade
cvarList["vj_npc_corpse_fadetime"] = 10 -- Time until Corpses fade
cvarList["vj_npc_corpse_undo"] = 0 -- Make corpses undoable
cvarList["vj_npc_gib"] = 1 -- Can NPCs gib?
cvarList["vj_npc_gib_vfx"] = 1 -- Gib VFX (particles, effects, decals, etc.)
cvarList["vj_npc_gib_collision"] = 0 -- Collidable Gibs?
cvarList["vj_npc_gib_fade"] = 1 -- Should Gibs Fade or not?
cvarList["vj_npc_gib_fadetime"] = 90 -- Gib Fade Time
cvarList["vj_npc_loot"] = 1 -- Can NPCs drop loot on death?
cvarList["vj_npc_ply_frag"] = 1 -- Disable frags (points) being added to player's scoreboard
cvarList["vj_npc_ply_chat"] = 1 -- Can NPC post in a player's chat? | EX: "Scientist is now following you"
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ NPC Performance Settings ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
cvarList["vj_npc_processtime"] = 1 -- How often does the NPC do performance-heavy processing?
cvarList["vj_npc_poseparams"] = 1 -- Can NPCs have pose parameters?
cvarList["vj_npc_shadows"] = 1 -- Should NPC shadows draw?
cvarList["vj_npc_ikchains"] = 1 -- Can NPCs have IK chains?
cvarList["vj_npc_forcelowlod"] = 0 -- Should NPCs be forced to use the lowest LOD?
cvarList["vj_npc_reduce_vfx"] = 0 -- Reduces VFX, especially non-essential ones | EX: Eye glow, idle particles
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ NPC Sound Settings ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
cvarList["vj_npc_snd"] = 1 -- Can NPCs play a sound?
cvarList["vj_npc_snd_track"] = 1 -- Sound track
cvarList["vj_npc_snd_idle"] = 1 -- Idle sounds
cvarList["vj_npc_snd_breath"] = 1 -- Breathing sounds
cvarList["vj_npc_snd_alert"] = 1 -- Alert Sounds
cvarList["vj_npc_snd_pain"] = 1 -- Hurt Sounds
cvarList["vj_npc_snd_death"] = 1 -- Death Sounds
cvarList["vj_npc_snd_footstep"] = 1 -- Footstep sounds
cvarList["vj_npc_snd_melee"] = 1 -- Melee attack sounds
cvarList["vj_npc_snd_gib"] = 1 -- Gibbing sounds
cvarList["vj_npc_snd_plyfollow"] = 1 -- NPC follows/unfollows a player
cvarList["vj_npc_snd_plybetrayal"] = 1 -- When a friendly NPC become enemy to the player
cvarList["vj_npc_snd_plysight"] = 1 -- Sw player Sounds
cvarList["vj_npc_snd_plydamage"] = 1 -- Damage by player Sounds
cvarList["vj_npc_snd_medic"] = 1 -- Medic sounds
cvarList["vj_npc_snd_callhelp"] = 1 -- Call for help sounds
cvarList["vj_npc_snd_receiveorder"] = 1 -- On receive order sounds (Ex: When called to come help an ally)
	-- ====== Creature Sound Settings ====== --
cvarList["vj_npc_snd_range"] = 1 -- Range Attack Sounds
cvarList["vj_npc_snd_leap"] = 1 -- Leap Attack Sounds
cvarList["vj_npc_snd_plyslow"] = 1 -- Slow Player Melee sounds
	-- ====== Human Sound Settings ====== --
cvarList["vj_npc_snd_danger"] = 1 -- Grenade / danger sight Sounds
cvarList["vj_npc_snd_grenade"] = 1 -- Grenade attack sounds
cvarList["vj_npc_snd_wep_reload"] = 1 -- Weapon reload call out sounds
cvarList["vj_npc_snd_wep_suppressing"] = 1 -- Suppressing callout sounds
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ NPC Developer Settings ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CreateConVar("vj_npc_debug", 0) -- Should NPC debugging be active? | Required to make the dev option below work!
cvarList["vj_npc_debug_engine"] = 0 -- Enables engine debugging
cvarList["vj_npc_debug_attack"] = 0 -- Enables attack debugging
cvarList["vj_npc_debug_death"] = 0 -- Prints Died when the NPC dies
cvarList["vj_npc_debug_damage"] = 0 -- Prints when the NPC gets damaged
cvarList["vj_npc_debug_touch"] = 0 -- Prints when something touches the NPC
cvarList["vj_npc_debug_enemy"] = 0 -- Prints the current enemy
cvarList["vj_npc_debug_resetenemy"] = 0 -- Prints something when the NPC has rested its enemy
cvarList["vj_npc_debug_lastseenenemytime"] = 0 -- Prints the 'LastSeenEnemy' time
cvarList["vj_npc_debug_takingcover"] = 0 -- Prints whether the NPC is taking cover or not
	-- ====== Human Options ====== --
cvarList["vj_npc_debug_weapon"] = 0 -- Prints weapon-related information
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ NPC Controller Settings ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
VJ.AddClientConVar("vj_npc_cont_hud", 1, "Display HUD when controlling NPCs")
VJ.AddClientConVar("vj_npc_cont_zoomdist", 5, "Distance that the zoom moves between each interval")
VJ.AddClientConVar("vj_npc_cont_cam_zoomspeed", 10, "How fast the camera zooms in & out")
VJ.AddClientConVar("vj_npc_cont_cam_speed", 6, "How fast the camera moves (lerping)")
VJ.AddClientConVar("vj_npc_cont_debug", 0, "Display developer entities")
VJ.AddClientConVar("vj_npc_cont_diewithnpc", 0, "Player should die with the NPC (Requires respawn!)")
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ NPC Client Menu Settings ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
VJ.AddClientConVar("vj_npc_spawn_guard", 0, "Spawn all VJ NPCs with guarding enabled")
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Weapon Client Settings ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
VJ.AddClientConVar("vj_wep_nomuszzleflash", 0, "Should weapons make a muzzle flash?")
VJ.AddClientConVar("vj_wep_nomuszzleflash_dynamiclight", 0, "Should weapons make a dynamic light when being fired?")
VJ.AddClientConVar("vj_wep_nobulletshells", 0, "Should weapons drop bullet shells?")
---------------------------------------------------------------------------------------------------------------------------
for k, v in pairs(cvarList) do
	CreateConVar(k, v, FCVAR_ARCHIVE)
end