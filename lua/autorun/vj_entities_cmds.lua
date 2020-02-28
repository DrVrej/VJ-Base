/*--------------------------------------------------
	=============== Entity Commands ===============
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
include('autorun/vj_controls.lua')

local ConvarList = {}
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Admin Settings ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ConvarList["vj_npc_admin_properties"] = 0 -- Should the properties menu be restricted to admins only?
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Settings ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ConvarList["vj_npc_nocorpses"] = 0 -- Remove ragdolls on Death
ConvarList["vj_npc_nobleed"] = 0 -- Should the SNPC bleed?
ConvarList["vj_npc_nomelee"] = 0 -- Disables Melee Attacks
ConvarList["vj_npc_noflinching"] = 0 -- Disable Flinching
ConvarList["vj_npc_noallies"] = 0 -- Disable alliance
ConvarList["vj_npc_nowandering"] = 0 -- They won't wander around when idle
ConvarList["vj_npc_nogib"] = 0 -- Disable gibbing
ConvarList["vj_npc_nodeathanimation"] = 0 -- Disable death animation
ConvarList["vj_npc_nogibdeathparticles"] = 0 -- Disable gib particles and effects
ConvarList["vj_npc_noidleparticle"] = 0 -- Disable idle particles and effects
ConvarList["vj_npc_nogibdecals"] = 0 -- Disable gib decals
ConvarList["vj_npc_nobecomeenemytoply"] = 0 -- Disable friendly SNPCs becoming enemy to player
ConvarList["vj_npc_nofollowplayer"] = 0 -- Disable SNPCs following players
ConvarList["vj_npc_nobloodpool"] = 0 -- Disables the blood pools spawned on death
ConvarList["vj_npc_nochasingenemy"] = 0 -- Disables the SNPCs chasing the enemy
ConvarList["vj_npc_nosnpcchat"] = 0 -- Disables the SNPCs printing things like "Scientist is now following you"
ConvarList["vj_npc_nomedics"] = 0 -- Disables medic SNPCs
	-- ====== Creature Settings ====== --
ConvarList["vj_npc_norange"] = 0 -- Disables range attacks
ConvarList["vj_npc_noleap"] = 0 -- Disables leap attacks
ConvarList["vj_npc_slowplayer"] = 0 -- Disables SNPCs slowing down player's speed on melee attack
ConvarList["vj_npc_bleedenemyonmelee"] = 0 -- Disable SNPCs bleeding their enemy on melee attack
ConvarList["vj_npc_noproppush"] = 0 -- Disable SNPCs pushing props
ConvarList["vj_npc_nopropattack"] = 0 -- Disable SNPCs attacking props
ConvarList["vj_npc_nomeleedmgdsp"] = 0 -- Disables the melee attack DSP effect on heavy damages
	-- ====== Human Settings ====== --
ConvarList["vj_npc_noweapon"] = 0 -- No Weapon - Human
ConvarList["vj_npc_noscarednade"] = 0 -- Disable running from grenades
ConvarList["vj_npc_noreload"] = 0 -- Disable reloading
ConvarList["vj_npc_nothrowgrenade"] = 0 -- Disable humans SNPCs throwing grenades
	-- ====== Animal Settings ====== --
ConvarList["vj_npc_animal_runontouch"] = 0 -- Disable animals running away on touch
ConvarList["vj_npc_animal_runonhit"] = 0 -- Disable animals running away when hit
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Options ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ConvarList["vj_npc_godmodesnpc"] = 0 -- The SNPC will never die!
ConvarList["vj_npc_difficulty"] = 0 -- Difficulty of the SNPCs
ConvarList["vj_npc_vjfriendly"] = 0 -- Makes the SNPC Friendly to all VJ SNPCs
ConvarList["vj_npc_playerfriendly"] = 0 -- Makes the SNPC Friendly to Players
ConvarList["vj_npc_zombiefriendly"] = 0 -- Makes the SNPC Friendly to Zombies
ConvarList["vj_npc_antlionfriendly"] = 0 -- Makes the SNPC Friendly to Antlion
ConvarList["vj_npc_combinefriendly"] = 0 -- Makes the SNPC Friendly to Combine
ConvarList["vj_npc_corpsefade"] = 0 -- Make Corpses fade
ConvarList["vj_npc_corpsefadetime"] = 10 -- Time until Corpses fade
ConvarList["vj_npc_undocorpse"] = 0 -- Make corpses undoable
ConvarList["vj_npc_allhealth"] = 0 -- Health Changer
ConvarList["vj_npc_gibcollidable"] = 0 -- Collidable Gibs?
ConvarList["vj_npc_fadegibs"] = 1 -- Should Gibs Fade or not?
ConvarList["vj_npc_fadegibstime"] = 30 -- Gib Fade Time
ConvarList["vj_npc_addfrags"] = 1 -- Disable frags(points) being added to player's scoreboard
ConvarList["vj_npc_showhudonkilled"] = 1 -- Show HUD display when the SNPC dies
ConvarList["vj_npc_itemdrops"] = 1 -- item drops on death?
ConvarList["vj_npc_seedistance"] = 0 -- How far can the SNPCs see? 0 = The distance that the SNPC uses
ConvarList["vj_npc_globalcorpselimit"] = 32 -- What is the limit for SNPC corpses on the ground? (When Keep Corpses is off)
ConvarList["vj_npc_processtime"] = 1 -- How much time it takes for an SNPC to process something
ConvarList["vj_npc_usegmoddecals"] = 0 -- Should it use Garry's Mod's current blood decals?
ConvarList["vj_npc_knowenemylocation"] = 0 -- Should they always know where their enemies are?
	-- ====== Creature Options ====== --
ConvarList["vj_npc_creatureopendoor"] = 1 -- Should Creatures open doors?
	-- ====== Human Options ====== --
ConvarList["vj_npc_dropweapon"] = 1 -- Drop Weapon on death?
ConvarList["vj_npc_human_canjump"] = 1 -- Can the human SNPCs jump?
ConvarList["vj_npc_plypickupdropwep"] = 1 -- Can players pick up dropped weapons?
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Sound Settings ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ConvarList["vj_npc_sd_nosounds"] = 0 -- Disables Sounds
ConvarList["vj_npc_sd_soundtrack"] = 0 -- Disable Theme Musics
ConvarList["vj_npc_sd_idle"] = 0 -- Disable idle sounds
ConvarList["vj_npc_sd_breath"] = 0 -- Disable breathing sounds
ConvarList["vj_npc_sd_alert"] = 0 -- Disable alert Sounds
ConvarList["vj_npc_sd_pain"] = 0 -- Disable hurt Sounds
ConvarList["vj_npc_sd_death"] = 0 -- Disable death Sounds
ConvarList["vj_npc_sd_footstep"] = 0 -- Disable footstep sounds
ConvarList["vj_npc_sd_meleeattack"] = 0 -- If set to false, it won't play the melee attack sound
ConvarList["vj_npc_sd_meleeattackmiss"] = 0 -- Disable melee miss sounds
ConvarList["vj_npc_sd_gibbing"] = 0 -- Disable gibbing sounds
ConvarList["vj_npc_sd_followplayer"] = 0 -- Disable the sounds that play when the player makes the SNPC follow/unfollow
ConvarList["vj_npc_sd_becomenemytoply"] = 0 -- Disable sounds that play when a friendly SNPC become enemy to the player
ConvarList["vj_npc_sd_onplayersight"] = 0 -- Disable saw player Sounds
ConvarList["vj_npc_sd_damagebyplayer"] = 0 -- Disable damage by player Sounds
ConvarList["vj_npc_sd_medic"] = 0 -- Disable medic sounds
ConvarList["vj_npc_sd_callforhelp"] = 0 -- Disable call for help sounds
ConvarList["vj_npc_sd_onreceiveorder"] = 0 -- Disable on receive order sounds (Ex: When called to come help an ally)
	-- ====== Creature Sound Settings ====== --
ConvarList["vj_npc_sd_rangeattack"] = 0 -- Disable Range Attack Sounds
ConvarList["vj_npc_sd_leapattack"] = 0 -- Disable Leap Attack Sounds
ConvarList["vj_npc_sd_slowplayer"] = 0 -- Disables Slow Player Melee sounds
	-- ====== Human Sound Settings ====== --
ConvarList["vj_npc_sd_ongrenadesight"] = 0 -- Disable on grenade sight Sounds
ConvarList["vj_npc_sd_reload"] = 0 -- Disable medic sounds
ConvarList["vj_npc_sd_grenadeattack"] = 0 -- Disable grenade attack sounds
ConvarList["vj_npc_sd_suppressing"] = 0 -- Disable suppressing callout sounds
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Developer Settings ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ConvarList["vj_npc_usedevcommands"] = 0 -- Should it use Dev Commands?
ConvarList["vj_npc_printdied"] = 0 -- Prints Died when the SNPC dies
ConvarList["vj_npc_printondamage"] = 0 -- Prints when the SNPC gets damaged
ConvarList["vj_npc_printontouch"] = 0 -- Prints when something touches the SNPC
ConvarList["vj_npc_printstoppedattacks"] = 0 -- Prints when the SNPC stops its attacks
ConvarList["vj_npc_printresetenemy"] = 0 -- Prints something when the SNPC has rested its enemy
ConvarList["vj_npc_printlastseenenemy"] = 0 -- Prints the 'LastSeenEnemy' time
ConvarList["vj_npc_printcurenemy"] = 0 -- Prints the current enemy
	-- ====== Human Options ====== --
ConvarList["vj_npc_printammo"] = 0 -- Prints amount of ammo in the console
ConvarList["vj_npc_printweapon"] = 0 -- Prints the weapon its using
ConvarList["vj_npc_printaccuracy"] = 0 -- Prints how accurate the SNPC is with weapons
ConvarList["vj_npc_printtakingcover"] = 0 -- Prints whether the SNPC is taking cover or not
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ NPC Controller Settings ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
VJ.AddClientConVar("vj_npc_cont_hud", 1, "Display HUD") -- Display HUD (When controlling)
VJ.AddClientConVar("vj_npc_cont_zoomdist", 5, "Zoom distance") -- The distance that the zoom moves
VJ.AddClientConVar("vj_npc_cont_devents", 0, "Display developer entities") -- Display developer entities
---------------------------------------------------------------------------------------------------------------------------
for k, v in pairs(ConvarList) do
	if !ConVarExists(k) then CreateConVar(k, v, {FCVAR_ARCHIVE}) end
end