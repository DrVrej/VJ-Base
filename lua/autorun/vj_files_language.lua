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

		add("vjbase.menugeneral.default", "Default")
		
		add("vjbase.menu.cleanup.everything", "Clean Up Everything")
		
		add("vjbase.menu.clsettings.label", "Use this menu to customize your client settings, servers can't change these settings!")
		add("vjbase.menu.clsettings.labellang", "Select the Language:")
		
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