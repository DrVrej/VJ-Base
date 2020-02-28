/*--------------------------------------------------
	=============== Language Files ===============
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
include('autorun/vj_controls.lua')

/*
	How it works:
	* Looks for the current set language and translates all the strings that are given.
	* If a string isn't translated, it will automatically default to English.
	* When a updated while in a map, it will try to refresh some of the menus, but many menus requires a map restart!
*/

if (CLIENT) then
	local function add(name, str) -- Aveli tirountsnelou hamar e
		language.Add(name, str)
	end
	
	function VJ_REFRESH_LANGUAGE()
		local conv = GetConVar("vj_language"):GetString()
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ ///// WARNING: Don't touch anything above this line! \\\\\ ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		
		-- General Menu (Used everywhere)
		add("vjbase.menugeneral.default", "Default")
		add("vjbase.menugeneral.admin.only", "Notice: Only admins can use this menu.")
		add("vjbase.menugeneral.admin.not", "You are not a admin!")
		add("vjbase.menugeneral.reset.everything", "Reset Everything")
		add("vjbase.menugeneral.reset.everything.colon", "Reset Everything:")
		
		-- Main Menu
		add("vjbase.menu.cleanup", "Clean Up")
		add("vjbase.menu.cleanup.everything", "Clean Up Everything")
		add("vjbase.menu.cleanup.stopsounds", "Stop all Sounds")
		add("vjbase.menu.cleanup.remove.vjnpcs", "Remove all VJ SNPCs")
		add("vjbase.menu.cleanup.remove.npcs", "Remove all (S)NPCs")
		add("vjbase.menu.cleanup.remove.spawners", "Remove all Spawners")
		add("vjbase.menu.cleanup.remove.corpses", "Remove all Corpses")
		add("vjbase.menu.cleanup.remove.vjgibs", "Remove all VJ Gibs")
		add("vjbase.menu.cleanup.remove.groundweapons", "Remove all Ground Weapons")
		add("vjbase.menu.cleanup.remove.props", "Remove all Props")
		add("vjbase.menu.cleanup.remove.decals", "Remove all Decals")
		add("vjbase.menu.cleanup.remove.allweapons", "Remove all of your Weapons")
		add("vjbase.menu.cleanup.remove.allammo", "Remove all of your Ammo")
		
		add("vjbase.menu.helpsupport", "Contact and Support")
		add("vjbase.menu.helpsupport.reportbug", "Report a Bug")
		add("vjbase.menu.helpsupport.suggestion", "Suggest Something")
		add("vjbase.menu.helpsupport.discord", "Join me on Discord!")
		add("vjbase.menu.helpsupport.steam", "Join me on Steam!")
		add("vjbase.menu.helpsupport.youtube", "Subscribe me on YouTube!")
		add("vjbase.menu.helpsupport.twtiter", "Follow me on Twitter!")
		add("vjbase.menu.helpsupport.patron", "Donate me on Patron!")
		add("vjbase.menu.helpsupport.label1", "Follow one of these links to get updates about my addons!")
		add("vjbase.menu.helpsupport.label2", "Donations help and encourage me to continue making/updating addons! Thank you!")
		add("vjbase.menu.helpsupport.thanks", "Thanks for your support!")
		
		add("vjbase.menu.svsettings", "Admin Server Settings")
		add("vjbase.menu.svsettings.label", "WARNING: SOME SETTINGS NEED CHEATS ENABLED!")
		add("vjbase.menu.svsettings.admin.npcproperties", "Restrict SNPC Properties to Admins Only")
		add("vjbase.menu.svsettings.noclip", "Allow NoClip")
		add("vjbase.menu.svsettings.weapons", "Allow Weapons")
		add("vjbase.menu.svsettings.pvp", "Allow PvP")
		add("vjbase.menu.svsettings.godmode", "God Mode (Everyone)")
		add("vjbase.menu.svsettings.bonemanip.npcs", "Bone Manipulate NPCs")
		add("vjbase.menu.svsettings.bonemanip.players", "Bone Manipulate Players")
		add("vjbase.menu.svsettings.bonemanip.others", "Bone Manipulate Others")
		add("vjbase.menu.svsettings.timescale.general", "General TimeScale")
		add("vjbase.menu.svsettings.timescale.physics", "Physics TimeScale")
		add("vjbase.menu.svsettings.gravity", "General Gravity")
		add("vjbase.menu.svsettings.maxentsprops", "Max Props/Entities:")
		
		add("vjbase.menu.clsettings", "Client Settings")
		add("vjbase.menu.clsettings.label", "Use this menu to customize your client settings, servers can't change these settings!")
		add("vjbase.menu.clsettings.labellang", "Select the Language:")
		add("vjbase.menu.clsettings.notify.lang", "VJ Base Language Set To:")
		
		add("vjbase.menu.info", "Information")
		
		add("vjbase.menu.plugins", "Installed Plugins")
		add("vjbase.menu.plugins.label", "List of installed VJ Base plugins.")
		add("vjbase.menu.plugins.version", "Version:")
		add("vjbase.menu.plugins.totalplugins", "Total Plugins:")
		add("vjbase.menu.plugins.notfound", "No Plugins Found.")
		add("vjbase.menu.plugins.changelog", "Changelog")
		add("vjbase.menu.plugins.makeaddon", "Want to make an addon? Click Here!")
		
		-- SNPC Menu
		add("vjbase.menu.snpc.options", "Options")
		
		add("vjbase.menu.snpc.settings", "Settings")
		
		add("vjbase.menu.snpc.sdsettings", "Sound Settings")
		
		add("vjbase.menu.snpc.devsettings", "Developer Settings")
		
		add("vjbase.menu.snpc.consettings", "Controller Settings")
		
		add("vjbase.menudifficulty.neanderthal", "Neanderthal | -99% Health and Damage")
		add("vjbase.menudifficulty.childs_play", "Child's Play | -75% Health and Damage")
		add("vjbase.menudifficulty.easy", "Easy | -50% Health and Damage")
		add("vjbase.menudifficulty.normal", "Normal | Original Health and Damage")
		add("vjbase.menudifficulty.hard", "Hard | +50% Health and Damage")
		add("vjbase.menudifficulty.insane", "Insane | +100% Health and Damage")
		add("vjbase.menudifficulty.impossible", "Impossible | +150% Health and Damage")
		add("vjbase.menudifficulty.nightmare", "Nightmare | +250% Health and Damage")
		add("vjbase.menudifficulty.hell_on_earth", "Hell On Earth | +350% Health and Damage")
		add("vjbase.menudifficulty.total_annihilation", "Total Annihilation | +500% Health and Damage")
		
		-- Weapon Client Settings
		add("vjbase.menu.clweapon", "Client Settings")
		add("vjbase.menu.clweapon.notice", "Notice: This settings are client, meaning it won't change for other people!")
		add("vjbase.menu.clweapon.togglemuzzle", "Disable Muzzle Flash")
		add("vjbase.menu.clweapon.togglemuzzlelight", "Disable Muzzle Flash Dynamic Light")
		add("vjbase.menu.clweapon.togglemuzzle.label", "Disabling muzzle flash will also disable this")
		add("vjbase.menu.clweapon.togglemuzzlesmoke", "Disable Muzzle Smoke")
		add("vjbase.menu.clweapon.togglemuzzleheatwave", "Disable Muzzle Heat Wave")
		add("vjbase.menu.clweapon.togglebulletshells", "Disable Bullet Shells")
		
		-- NPC Properties (C Menu)
		add("vjbase.menuproperties.control", "TAKE CONTROL")
		add("vjbase.menuproperties.guard", "Toggle Guarding")
		add("vjbase.menuproperties.wander", "Toggle Wandering")
		add("vjbase.menuproperties.medic", "Make Medic (Toggle)")
		add("vjbase.menuproperties.allyme", "Ally To Me")
		add("vjbase.menuproperties.hostileme", "Hostile To Me")
		add("vjbase.menuproperties.slay", "Slay")
		add("vjbase.menuproperties.gib", "Gib (If Valid)")
		add("vjbase.menuproperties.devmode", "Toggle Developer Mode")
		
		if conv == "armenian" then
			
		elseif conv == "russian" then
			
		elseif conv == "german" then
			
		elseif conv == "french" then
			
		elseif conv == "lithuanian" then
			
		elseif conv == "spanish_lt" then
			
		elseif conv == "portuguese_br" then
			
		end
		
		print("VJ Base Language Set To: "..conv)
	end
	
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ ///// WARNING: Don't touch anything below this line! \\\\\ ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	VJ_REFRESH_LANGUAGE() -- Arachin ankam ganch e, garevor e asiga!
end