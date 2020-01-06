/*--------------------------------------------------
	=============== Weapon Stuff ===============
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
include('autorun/vj_controls.lua')

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Spawn Menu Creation ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local vCat = "VJ Base"
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
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Hooks ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("PlayerCanPickupWeapon","VJ_PLAYER_CANPICKUPWEAPON",function(ply,wep)
	//print(wep:GetWeaponWorldModel())
	if ply.VJ_CanBePickedUpWithOutUse == true && ply.VJ_CanBePickedUpWithOutUse_Class == wep:GetClass() then
		if wep.IsVJBaseWeapon == true && !ply:HasWeapon(wep:GetClass()) then
			ply.VJ_CanBePickedUpWithOutUse = false
			ply.VJ_CanBePickedUpWithOutUse_Class = nil
			return true
		else
			ply.VJ_CanBePickedUpWithOutUse = false
			ply.VJ_CanBePickedUpWithOutUse_Class = nil
		end
	end
	if wep.IsVJBaseWeapon == true then
		//if wep.VJ_CanBePickedUpWithOutUse == true then return true end
		if GetConVarNumber("vj_npc_plypickupdropwep") == 0 then return false end
		if ply:KeyPressed(IN_USE) && (ply:GetEyeTrace().Entity == wep) then
		return true else return false end
	end
end)
---------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("PlayerGiveSWEP","VJ_PLAYER_GIVESWEP",function(ply,class,swep)
	//if swep.IsVJBaseWeapon == true then
		ply.VJ_CanBePickedUpWithOutUse = true
		ply.VJ_CanBePickedUpWithOutUse_Class = class
		timer.Simple(0.1,function() if IsValid(ply) then ply.VJ_CanBePickedUpWithOutUse = false ply.VJ_CanBePickedUpWithOutUse_Class = nil end end)
		//PrintTable(swep)
	//end
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Client Convars ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local ConvarList = {}

ConvarList["vj_wep_nomuszzleflash"] = 0 -- Should weapons make a muzzle flash?
ConvarList["vj_wep_nomuszzleflash_dynamiclight"] = 0 -- Should weapons make a dynamic light when being fired?
ConvarList["vj_wep_nomuszzlesmoke"] = 0 -- Should weapons make a muzzle smoke?
ConvarList["vj_wep_nomuzzleheatwave"] = 0 -- Should weapons make a muzzle heat wave?
ConvarList["vj_wep_nobulletshells"] = 0 -- Should weapons drop bullet shells?

for k, v in pairs(ConvarList) do
	if !ConVarExists(k) then CreateClientConVar(k, v, true, false) end
end