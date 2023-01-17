/*--------------------------------------------------
	=============== Spawn Menu Information ===============
	*** Copyright (c) 2012-2023 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
include('autorun/vj_controls.lua')

local vCat = "VJ Base"
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Category Information ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- ====== Category Information (Many are for popular categories used in both official and unofficial addons ====== --
	-- Steam\appcache\librarycache
VJ.AddCategoryInfo("Alien Swarm", {Icon = "vj_base/icons/alienswarm.png"})
VJ.AddCategoryInfo("Black Mesa", {Icon = "vj_base/icons/blackmesa.png"})
VJ.AddCategoryInfo("Cry Of Fear", {Icon = "vj_base/icons/cryoffear.png"})
VJ.AddCategoryInfo("Dark Messiah", {Icon = "vj_base/icons/darkmessiah.png"})
VJ.AddCategoryInfo("E.Y.E Divine Cybermancy", {Icon = "vj_base/icons/eyedc.png"})
VJ.AddCategoryInfo("Fallout", {Icon = "vj_base/icons/fallout.png"})
VJ.AddCategoryInfo("Killing Floor 1", {Icon = "vj_base/icons/kf1.png"})
VJ.AddCategoryInfo("Left 4 Dead", {Icon = "vj_base/icons/l4d.png"})
VJ.AddCategoryInfo("Mass Effect 3", {Icon = "vj_base/icons/masseffect3.png"})
VJ.AddCategoryInfo("Military", {Icon = "vj_base/icons/mil1.png"})
VJ.AddCategoryInfo("No More Room In Hell", {Icon = "vj_base/icons/nmrih.png"})
VJ.AddCategoryInfo("Star Wars", {Icon = "vj_base/icons/starwars.png"})
VJ.AddCategoryInfo("Zombies", {Icon = "vj_base/icons/zombies.png"})
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ NPCs ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
VJ.AddNPC("VJ Test NPC", "sent_vj_test", vCat, true)
VJ.AddNPC_HUMAN("Player NPC", "npc_vj_test_humanply", {"weapon_vj_ak47","weapon_vj_glock17","weapon_vj_m16a1","weapon_vj_mp40","weapon_vj_9mmpistol","weapon_vj_357","weapon_vj_ar2","weapon_vj_blaster","weapon_vj_smg1","weapon_vj_spas12","weapon_vj_k3","weapon_vj_crossbow","weapon_vj_ssg08"}, vCat)
VJ.AddNPC("Aerial NPC", "npc_vj_test_aerial", vCat)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Entities ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
VJ.AddEntity("Admin Health Kit","sent_vj_adminhealthkit","DrVrej",true,0,true,vCat)
VJ.AddEntity("Player Spawnpoint","sent_vj_ply_spawnpoint","DrVrej",true,0,true,vCat)
VJ.AddEntity("Fireplace","sent_vj_fireplace","DrVrej",false,0,true,vCat)
VJ.AddEntity("Wooden Board","sent_vj_board","DrVrej",false,0,true,vCat)
VJ.AddEntity("Grenade","obj_vj_grenade","DrVrej",false,0,true,vCat)
VJ.AddEntity("Flare Round","obj_vj_flareround","DrVrej",false,0,true,vCat)
VJ.AddEntity("Flag","prop_vj_flag","DrVrej",false,0,true,vCat)
//VJ.AddEntity("HL2 Grenade","npc_grenade_frag","DrVrej",false,50,true,vCat)
//VJ.AddEntity("Supply Box","item_dynamic_resupply","DrVrej",false,0,true,vCat)
//VJ.AddEntity("Supply Crate","item_ammo_crate","DrVrej",false,0,true,vCat)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Weapons ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- ====== Weapons ====== --
VJ.AddWeapon("AK-47","weapon_vj_ak47",false,vCat)
VJ.AddWeapon("Glock 17","weapon_vj_glock17",false,vCat)
VJ.AddWeapon("M16A1","weapon_vj_m16a1",false,vCat)
VJ.AddWeapon("MP 40","weapon_vj_mp40",false,vCat)
VJ.AddWeapon("9mm Pistol","weapon_vj_9mmpistol",false,vCat)
VJ.AddWeapon(".357 Magnum","weapon_vj_357",false,vCat)
VJ.AddWeapon("AR2","weapon_vj_ar2",false,vCat)
VJ.AddWeapon("Blaster","weapon_vj_blaster",false,vCat)
VJ.AddWeapon("VJ NPC Controller","weapon_vj_npccontroller",false,vCat)
VJ.AddWeapon("Flare Gun","weapon_vj_flaregun",false,vCat)
VJ.AddWeapon("SMG1","weapon_vj_smg1",false,vCat)
VJ.AddWeapon("SPAS-12","weapon_vj_spas12",false,vCat)
VJ.AddWeapon("RPG","weapon_vj_rpg",false,vCat)
	-- ====== NPC Weapons ====== --
//VJ.AddNPCWeapon("VJ_Package","weapon_citizenpackage")
//VJ.AddNPCWeapon("VJ_Suitcase","weapon_citizensuitcase")
VJ.AddNPCWeapon("VJ_AK-47","weapon_vj_ak47")
VJ.AddNPCWeapon("VJ_M4A1","weapon_vj_m16a1")
VJ.AddNPCWeapon("VJ_Glock17","weapon_vj_glock17")
VJ.AddNPCWeapon("VJ_MP40","weapon_vj_mp40")
VJ.AddNPCWeapon("VJ_Blaster","weapon_vj_blaster")
VJ.AddNPCWeapon("VJ_AR2","weapon_vj_ar2")
VJ.AddNPCWeapon("VJ_SMG1","weapon_vj_smg1")
VJ.AddNPCWeapon("VJ_9mmPistol","weapon_vj_9mmpistol")
VJ.AddNPCWeapon("VJ_SPAS-12","weapon_vj_spas12")
VJ.AddNPCWeapon("VJ_357","weapon_vj_357")
VJ.AddNPCWeapon("VJ_FlareGun","weapon_vj_flaregun")
VJ.AddNPCWeapon("VJ_RPG","weapon_vj_rpg")
VJ.AddNPCWeapon("VJ_K-3","weapon_vj_k3")
VJ.AddNPCWeapon("VJ_Crossbow","weapon_vj_crossbow")
VJ.AddNPCWeapon("VJ_SSG-08","weapon_vj_ssg08")
VJ.AddNPCWeapon("VJ_Crowbar","weapon_vj_crowbar")