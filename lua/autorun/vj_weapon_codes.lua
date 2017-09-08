/*--------------------------------------------------
	=============== Weapon Stuff ===============
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
INFO: Used to load Weapon autorun codes for VJ Base
--------------------------------------------------*/
if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
include('autorun/vj_controls.lua')

-- Add Weapons -------------------------------------------------------------------------------------------------------------------------
local vCat = "VJ Base" //"VJ Base"
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
//VJ.AddWeapon("Physgun","weapon_physcannon",true,vCat)
//VJ.AddWeapon("Physcannon","weapon_physgun",true,vCat)
//VJ.AddWeapon("Tool Gun","gmod_tool",true,vCat)
//VJ.AddWeapon("Camera","gmod_camera",true,vCat)

-- Hooks ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function VJ_PLAYER_CANPICKUPWEAPON(ply,wep)
	//print(wep:GetWeaponWorldModel())
	if ply.VJ_CanBePickedUpWithOutUse == true && ply.VJ_CanBePickedUpWithOutUse_Class == wep:GetClass() then
		if wep.IsVJBaseWeapon == true && !(ply:HasWeapon(wep:GetClass())) then
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
		if (ply:KeyPressed(IN_USE)) && (ply:GetEyeTrace().Entity == wep) then 
		return true else return false end
	end
end
hook.Add("PlayerCanPickupWeapon","VJ_PLAYER_CANPICKUPWEAPON",VJ_PLAYER_CANPICKUPWEAPON)
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
local function VJ_PLAYER_GIVESWEP(ply,class,swep)
	//if swep.IsVJBaseWeapon == true then
		ply.VJ_CanBePickedUpWithOutUse = true
		ply.VJ_CanBePickedUpWithOutUse_Class = class
		timer.Simple(0.1,function() if IsValid(ply) then ply.VJ_CanBePickedUpWithOutUse = false ply.VJ_CanBePickedUpWithOutUse_Class = nil end end)
		//PrintTable(swep)
	//end
end
hook.Add("PlayerGiveSWEP","VJ_PLAYER_GIVESWEP",VJ_PLAYER_GIVESWEP)
-- Weapon ConVars ---------------------------------------------------------------------------------------------------------------------------
/*
AddConvars["rrrrrrrrrrrrrrrrrrrrrr"] = 0 -- 

RunConsoleCommand("command_name", "value")
*/
local AddConvars = {}

-- Setting Commands --
AddConvars["vj_wep_nomuszzleflash"] = 0 -- Should weapons make a muzzle flash?
AddConvars["vj_wep_nomuszzleflash_dynamiclight"] = 0 -- Should weapons make a dynamic light when being fired?
AddConvars["vj_wep_nomuszzlesmoke"] = 0 -- Should weapons make a muzzle smoke?
AddConvars["vj_wep_nomuzzleheatwave"] = 0 -- Should weapons make a muzzle heat wave?
AddConvars["vj_wep_nobulletshells"] = 0 -- Should weapons drop bullet shells?

for k, v in pairs(AddConvars) do
	if !ConVarExists( k ) then CreateClientConVar( k, v, true, false ) end
end