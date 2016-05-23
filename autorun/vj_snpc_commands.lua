/*--------------------------------------------------
	=============== SNPC Commands ===============
	*** Copyright (c) 2012-2016 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
INFO: Used to load SNPC Commands for VJ Base
--------------------------------------------------*/
if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end

/*
AddConvars["rrrrrrrrrrrrrrrrrrrrrr"] = 0 -- 

RunConsoleCommand("command_name", "value")
*/
local AddConvars = {}
---------------------------------------------------------------------------------------------------------------------------
-- Setting Commands --
AddConvars["vj_npc_nocorpses"] = 0 -- Remove ragdolls on Death
AddConvars["vj_npc_nobleed"] = 0 -- Should the SNPC bleed?
AddConvars["vj_npc_nomelee"] = 0 -- Disables Melee Attacks
AddConvars["vj_npc_noflinching"] = 0 -- Disable Flinching
AddConvars["vj_npc_noallies"] = 0 -- Disable alliance
AddConvars["vj_npc_nowandering"] = 0 -- They won't wander around when idle
AddConvars["vj_npc_nogib"] = 0 -- Disable gibbing
AddConvars["vj_npc_nodeathanimation"] = 0 -- Disable death animation
AddConvars["vj_npc_nogibdeathparticles"] = 0 -- Disable gib particles and effects
AddConvars["vj_npc_noidleparticle"] = 0 -- Disable idle particles and effects
AddConvars["vj_npc_nogibdecals"] = 0 -- Disable gib decals
AddConvars["vj_npc_nobecomeenemytoply"] = 0 -- Disable friendly SNPCs becoming enemy to player
AddConvars["vj_npc_nofollowplayer"] = 0 -- Disable SNPCs following players
AddConvars["vj_npc_nobloodpool"] = 0 -- Disables the blood pools spawned on death
AddConvars["vj_npc_nochasingenemy"] = 0 -- Disables the SNPCs chasing the enemy
AddConvars["vj_npc_nosnpcchat"] = 0 -- Disables the SNPCs printing things like "Scientist is now following you"
AddConvars["vj_npc_nomedics"] = 0 -- Disables medic SNPCs
	-- Creature Settings ----------------------------------------------------------------------------------------------------
AddConvars["vj_npc_norange"] = 0 -- Disables range attacks
AddConvars["vj_npc_noleap"] = 0 -- Disables leap attacks
AddConvars["vj_npc_slowplayer"] = 0 -- Disables SNPCs slowing down player's speed on melee attack
AddConvars["vj_npc_bleedenemyonmelee"] = 0 -- Disable SNPCs bleeding their enemy on melee attack
AddConvars["vj_npc_noproppush"] = 0 -- Disable SNPCs pushing props
AddConvars["vj_npc_nopropattack"] = 0 -- Disable SNPCs attacking props
	-- Human Settings ----------------------------------------------------------------------------------------------------
AddConvars["vj_npc_noweapon"] = 0 -- No Weapon - Human
AddConvars["vj_npc_noforeverammo"] = 0 -- No unlimited ammo - Human
AddConvars["vj_npc_noscarednade"] = 0 -- Disable running from grenades
AddConvars["vj_npc_noreload"] = 0 -- Disable reloading
AddConvars["vj_npc_nouseregulator"] = 0 -- Disables CAP_USE_SHOT_REGULATOR
AddConvars["vj_npc_nothrowgrenade"] = 0 -- Disable humans SNPCs throwing grenades
	-- Animal Settings ----------------------------------------------------------------------------------------------------
AddConvars["vj_npc_animal_runontouch"] = 0 -- Disable animals running away on touch
AddConvars["vj_npc_animal_runonhit"] = 0 -- Disable animals running away when hit
---------------------------------------------------------------------------------------------------------------------------
-- Option Commands --
AddConvars["vj_npc_godmodesnpc"] = 0 -- The SNPC will never die!
AddConvars["vj_npc_vjfriendly"] = 0 -- Makes the SNPC Friendly to all VJ SNPCs
AddConvars["vj_npc_playerfriendly"] = 0 -- Makes the SNPC Friendly to Players
AddConvars["vj_npc_zombiefriendly"] = 0 -- Makes the SNPC Friendly to Zombies
AddConvars["vj_npc_antlionfriendly"] = 0 -- Makes the SNPC Friendly to Antlion
AddConvars["vj_npc_combinefriendly"] = 0 -- Makes the SNPC Friendly to Combine
AddConvars["vj_npc_corpsefade"] = 0 -- Make Corpses fade
AddConvars["vj_npc_corpsefadetime"] = 10 -- Time until Corpses fade
AddConvars["vj_npc_undocorpse"] = 0 -- Make corpses undoable
AddConvars["vj_npc_allhealth"] = 0 -- Health Changer
AddConvars["vj_npc_gibcollidable"] = 0 -- Collidable Gibs?
AddConvars["vj_npc_fadegibs"] = 1 -- Should Gibs Fade or not?
AddConvars["vj_npc_fadegibstime"] = 30 -- Gib Fade Time
AddConvars["vj_npc_dif_easy"] = 0 -- Difficulty: Easy
AddConvars["vj_npc_dif_normal"] = 1 -- Difficulty: Normal
AddConvars["vj_npc_dif_hard"] = 0 -- Difficulty: Hard
AddConvars["vj_npc_dif_hellonearth"] = 0 -- Difficulty: Hell On Earth
AddConvars["vj_npc_addfrags"] = 1 -- Disable frags(points) being added to player's scoreboard
AddConvars["vj_npc_showhudonkilled"] = 1 -- Show HUD display when the SNPC dies
AddConvars["vj_npc_itemdrops"] = 1 -- item drops on death?
AddConvars["vj_npc_seedistance"] = 0 -- How far can the SNPCs see? 0 = The distance that the SNPC uses
AddConvars["vj_npc_globalcorpselimit"] = 32 -- What is the limit for SNPC corpses on the ground? (When Keep Corpses is off)
AddConvars["vj_npc_processtime"] = 1 -- How much time it takes for an SNPC to process something
	-- Creature Options ----------------------------------------------------------------------------------------------------
AddConvars["vj_npc_creatureopendoor"] = 1 -- Should Creatures open doors?
	-- Human Options ----------------------------------------------------------------------------------------------------
AddConvars["vj_npc_dropweapon"] = 1 -- Drop Weapon on death?
AddConvars["vj_npc_accuracy_poor"] = 1 -- Accuracy = Poor
AddConvars["vj_npc_accuracy_average"] = 0 -- Accuracy = Average
AddConvars["vj_npc_accuracy_good"] = 0 -- Accuracy = Good
AddConvars["vj_npc_accuracy_verygood"] = 0 -- Accuracy = Very Good
AddConvars["vj_npc_accuracy_perfect"] = 0 -- Accuracy = Perfect
---------------------------------------------------------------------------------------------------------------------------
-- Sound Commands --
AddConvars["vj_npc_sd_nosounds"] = 0 -- Disables Sounds
AddConvars["vj_npc_sd_soundtrack"] = 0 -- Disable Theme Musics
AddConvars["vj_npc_sd_idle"] = 0 -- Disable idle sounds
//AddConvars["vj_npc_sd_combatidle"] = 0 -- Disable combat idle sounds
AddConvars["vj_npc_sd_breath"] = 0 -- Disable breathing sounds
AddConvars["vj_npc_sd_alert"] = 0 -- Disable alert Sounds
AddConvars["vj_npc_sd_pain"] = 0 -- Disable hurt Sounds
AddConvars["vj_npc_sd_death"] = 0 -- Disable death Sounds
AddConvars["vj_npc_sd_footstep"] = 0 -- Disable footstep sounds
AddConvars["vj_npc_sd_meleeattack"] = 0 -- If set to false, it won't play the melee attack sound
AddConvars["vj_npc_sd_meleeattackmiss"] = 0 -- Disable melee miss sounds
AddConvars["vj_npc_sd_gibbing"] = 0 -- Disable gibbing sounds
AddConvars["vj_npc_sd_followplayer"] = 0 -- Disable the sounds that play when the player makes the SNPC follow/unfollow
AddConvars["vj_npc_sd_becomenemytoply"] = 0 -- Disable sounds that play when a friendly SNPC become enemy to the player
AddConvars["vj_npc_sd_onplayersight"] = 0 -- Disable saw player Sounds
AddConvars["vj_npc_sd_damagebyplayer"] = 0 -- Disable damage by player Sounds
AddConvars["vj_npc_sd_medic"] = 0 -- Disable medic sounds
	-- Creature Sound Settings ----------------------------------------------------------------------------------------------------
AddConvars["vj_npc_sd_rangeattack"] = 0 -- Disable Range Attack Sounds
AddConvars["vj_npc_sd_leapattack"] = 0 -- Disable Leap Attack Sounds
AddConvars["vj_npc_sd_slowplayer"] = 0 -- Disables Slow Player Melee sounds
	-- Human Sound Settings ----------------------------------------------------------------------------------------------------
AddConvars["vj_npc_sd_ongrenadesight"] = 0 -- Disable on grenade sight Sounds
AddConvars["vj_npc_sd_reload"] = 0 -- Disable medic sounds
AddConvars["vj_npc_sd_grenadeattack"] = 0 -- Disable grenade attack sounds
---------------------------------------------------------------------------------------------------------------------------
-- Developer Settings --
AddConvars["vj_npc_usedevcommands"] = 0 -- Should it use Dev Commands?
AddConvars["vj_npc_printalerted"] = 0 -- Prints its Alerted status, is it alerted? Or not?
AddConvars["vj_npc_printseenenemy"] = 0 -- Prints if it sees an enemy or not
AddConvars["vj_npc_printdied"] = 0 -- Prints Died when the SNPC dies
AddConvars["vj_npc_printondamage"] = 0 -- Prints when the SNPC gets damaged
AddConvars["vj_npc_printontouch"] = 0 -- Prints when something touches the SNPC
AddConvars["vj_npc_printstoppedattacks"] = 0 -- Prints when the SNPC stops its attacks
AddConvars["vj_npc_printenemyclass"] = 0 -- Prints the current enemy class
AddConvars["vj_npc_drvrejfriendly"] = 0 -- Makes the SNPC Friendly to DrVrej! =D
AddConvars["vj_npc_printresteenemy"] = 0 -- Prints something when the SNPC has rested its enemy
AddConvars["vj_npc_printlastseenenemy"] = 0 -- Prints the 'LastSeenEnemy' time
	-- Human Options ----------------------------------------------------------------------------------------------------
AddConvars["vj_npc_printammo"] = 0 -- Prints amount of ammo in the console
AddConvars["vj_npc_printweapon"] = 0 -- Prints the weapon its using
AddConvars["vj_npc_printaccuracy"] = 0 -- Prints how accurate the SNPC is with weapons
AddConvars["vj_npc_printtakingcover"] = 0 -- Prints whether the SNPC is taking cover or not
---------------------------------------------------------------------------------------------------------------------------
for k, v in pairs(AddConvars) do
	if !ConVarExists( k ) then CreateConVar( k, v, {FCVAR_ARCHIVE} ) end
end