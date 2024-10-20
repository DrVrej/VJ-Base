/*--------------------------------------------------
	*** Copyright (c) 2012-2024 by DrVrej, All rights reserved. ***
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
------ Settings ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
cvarList["vj_npc_nocorpses"] = 0 -- Remove ragdolls on Death
cvarList["vj_npc_nobleed"] = 0 -- Should the NPC bleed?
cvarList["vj_npc_nomelee"] = 0 -- Disables Melee Attacks
cvarList["vj_npc_noflinching"] = 0 -- Disable Flinching
cvarList["vj_npc_noallies"] = 0 -- Disable alliance
cvarList["vj_npc_nowandering"] = 0 -- They won't wander around when idle
cvarList["vj_npc_nogib"] = 0 -- Disable gibbing
cvarList["vj_npc_nodeathanimation"] = 0 -- Disable death animation
cvarList["vj_npc_novfx_gibdeath"] = 0 -- Disable gib or death VFX (particles, effects, decals, etc.)
cvarList["vj_npc_noidleparticle"] = 0 -- Disable idle particles and effects
cvarList["vj_npc_nobecomeenemytoply"] = 0 -- Disable friendly NPCs becoming enemy to player
cvarList["vj_npc_nocallhelp"] = 0 -- Disable NPCs calling for help
cvarList["vj_npc_noinvestigate"] = 0 -- Disable NPCs detecting and investigating disturbances
cvarList["vj_npc_nofollowplayer"] = 0 -- Disable NPCs following players
cvarList["vj_npc_nobloodpool"] = 0 -- Disables the blood pools spawned on death
cvarList["vj_npc_nochasingenemy"] = 0 -- Disables the NPCs chasing the enemy
cvarList["vj_npc_nosnpcchat"] = 0 -- Disables the NPCs printing things like "Scientist is now following you"
cvarList["vj_npc_nomedics"] = 0 -- Disables medic NPCs
cvarList["vj_npc_noeating"] = 0 -- Disable NPCs eating things like corpses or gibs
	-- ====== Creature Settings ====== --
cvarList["vj_npc_norange"] = 0 -- Disables range attacks
cvarList["vj_npc_noleap"] = 0 -- Disables leap attacks
cvarList["vj_npc_slowplayer"] = 0 -- Disables NPCs slowing down player's speed on melee attack
cvarList["vj_npc_bleedenemyonmelee"] = 0 -- Disable NPCs bleeding their enemy on melee attack
cvarList["vj_npc_noproppush"] = 0 -- Disable NPCs pushing props
cvarList["vj_npc_nopropattack"] = 0 -- Disable NPCs attacking props
cvarList["vj_npc_nomeleedmgdsp"] = 0 -- Disables the melee attack DSP effect on heavy damages
	-- ====== Human Settings ====== --
cvarList["vj_npc_noweapon"] = 0 -- No Weapon - Human
cvarList["vj_npc_nodangerdetection"] = 0 -- Disable running from grenades/dangers
cvarList["vj_npc_noreload"] = 0 -- Disable reloading
cvarList["vj_npc_nothrowgrenade"] = 0 -- Disable humans NPCs throwing grenades
	-- ====== Passive Settings ====== --
cvarList["vj_npc_no_runontouch"] = 0 -- Disable passive NPCs running away on touch
cvarList["vj_npc_no_runonhit"] = 0 -- Disable passive NPCs running away when hit
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Options ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
cvarList["vj_npc_godmodesnpc"] = 0 -- The NPC will never die!
cvarList["vj_npc_difficulty"] = 0 -- Difficulty of the NPCs
cvarList["vj_npc_vjfriendly"] = 0 -- Makes the NPC Friendly to all VJ NPCs
cvarList["vj_npc_playerfriendly"] = 0 -- Makes the NPC Friendly to Players
cvarList["vj_npc_zombiefriendly"] = 0 -- Makes the NPC Friendly to Zombies
cvarList["vj_npc_antlionfriendly"] = 0 -- Makes the NPC Friendly to Antlion
cvarList["vj_npc_combinefriendly"] = 0 -- Makes the NPC Friendly to Combine
cvarList["vj_npc_corpsecollision"] = 0 -- Collision type for the NPC's corpse
cvarList["vj_npc_corpsefade"] = 0 -- Make Corpses fade
cvarList["vj_npc_corpsefadetime"] = 10 -- Time until Corpses fade
cvarList["vj_npc_undocorpse"] = 0 -- Make corpses undoable
cvarList["vj_npc_allhealth"] = 0 -- Health Changer
cvarList["vj_npc_gibcollidable"] = 0 -- Collidable Gibs?
cvarList["vj_npc_fadegibs"] = 1 -- Should Gibs Fade or not?
cvarList["vj_npc_fadegibstime"] = 90 -- Gib Fade Time
cvarList["vj_npc_addfrags"] = 1 -- Disable frags(points) being added to player's scoreboard
cvarList["vj_npc_itemdrops"] = 1 -- item drops on death?
cvarList["vj_npc_seedistance"] = 0 -- How far can the NPCs see? 0 = The distance that the NPC uses
cvarList["vj_npc_globalcorpselimit"] = 32 -- What is the limit for NPC corpses on the ground? (When Keep Corpses is off)
cvarList["vj_npc_processtime"] = 1 -- How much time it takes for an NPC to process something
cvarList["vj_npc_usegmoddecals"] = 0 -- Should it use Garry's Mod's current blood decals?
cvarList["vj_npc_knowenemylocation"] = 0 -- Should they always know where their enemies are?
	-- ====== Creature Options ====== --
cvarList["vj_npc_creatureopendoor"] = 1 -- Should Creatures open doors?
	-- ====== Human Options ====== --
cvarList["vj_npc_dropweapon"] = 1 -- Drop Weapon on death?
cvarList["vj_npc_human_canjump"] = 1 -- Can the human NPCs jump?
cvarList["vj_npc_plypickupdropwep"] = 1 -- Can players pick up dropped weapons?
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Sound Settings ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
cvarList["vj_npc_sd_nosounds"] = 0 -- Disables Sounds
cvarList["vj_npc_sd_soundtrack"] = 0 -- Disable sound track
cvarList["vj_npc_sd_idle"] = 0 -- Disable idle sounds
cvarList["vj_npc_sd_breath"] = 0 -- Disable breathing sounds
cvarList["vj_npc_sd_alert"] = 0 -- Disable alert Sounds
cvarList["vj_npc_sd_pain"] = 0 -- Disable hurt Sounds
cvarList["vj_npc_sd_death"] = 0 -- Disable death Sounds
cvarList["vj_npc_sd_footstep"] = 0 -- Disable footstep sounds
cvarList["vj_npc_sd_meleeattack"] = 0 -- If set to false, it won't play the melee attack sound
cvarList["vj_npc_sd_gibbing"] = 0 -- Disable gibbing sounds
cvarList["vj_npc_sd_followplayer"] = 0 -- Disable the sounds that play when the player makes the NPC follow/unfollow
cvarList["vj_npc_sd_becomenemytoply"] = 0 -- Disable sounds that play when a friendly NPC become enemy to the player
cvarList["vj_npc_sd_onplayersight"] = 0 -- Disable saw player Sounds
cvarList["vj_npc_sd_damagebyplayer"] = 0 -- Disable damage by player Sounds
cvarList["vj_npc_sd_medic"] = 0 -- Disable medic sounds
cvarList["vj_npc_sd_callforhelp"] = 0 -- Disable call for help sounds
cvarList["vj_npc_sd_onreceiveorder"] = 0 -- Disable on receive order sounds (Ex: When called to come help an ally)
	-- ====== Creature Sound Settings ====== --
cvarList["vj_npc_sd_rangeattack"] = 0 -- Disable Range Attack Sounds
cvarList["vj_npc_sd_leapattack"] = 0 -- Disable Leap Attack Sounds
cvarList["vj_npc_sd_slowplayer"] = 0 -- Disables Slow Player Melee sounds
	-- ====== Human Sound Settings ====== --
cvarList["vj_npc_sd_ondangersight"] = 0 -- Disable on grenade / danger sight Sounds
cvarList["vj_npc_sd_reload"] = 0 -- Disable medic sounds
cvarList["vj_npc_sd_grenadeattack"] = 0 -- Disable grenade attack sounds
cvarList["vj_npc_sd_suppressing"] = 0 -- Disable suppressing callout sounds
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Developer Settings ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CreateConVar("vj_npc_debug", 0) -- Should NPC debugging be active? | Required to make the dev option below work!
cvarList["vj_npc_debug_death"] = 0 -- Prints Died when the NPC dies
cvarList["vj_npc_debug_ondmg"] = 0 -- Prints when the NPC gets damaged
cvarList["vj_npc_debug_ontouch"] = 0 -- Prints when something touches the NPC
cvarList["vj_npc_debug_stopattacks"] = 0 -- Prints when the NPC stops its attacks
cvarList["vj_npc_debug_resetenemy"] = 0 -- Prints something when the NPC has rested its enemy
cvarList["vj_npc_debug_lastseenenemytime"] = 0 -- Prints the 'LastSeenEnemy' time
cvarList["vj_npc_debug_enemy"] = 0 -- Prints the current enemy
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
VJ.AddClientConVar("vj_npc_cont_devents", 0, "Display developer entities")
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
	CreateConVar(k, v, {FCVAR_ARCHIVE})
end