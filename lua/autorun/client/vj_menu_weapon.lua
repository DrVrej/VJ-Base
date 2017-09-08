/*--------------------------------------------------
	=============== Weapon Menu ===============
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
INFO: Used to load the Weapon Menu for VJ Base 
--------------------------------------------------*/
if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
include('autorun/client/vj_menu_plugins.lua')
---------------------------------------------------------------------------------------------------------------------------------------------
local function VJ_WEAPON_CLIENTSETTINGS(Panel) -- Settings
	/*if !LocalPlayer():IsAdmin() or !LocalPlayer():IsSuperAdmin() then
		Panel:AddControl( "Label", {Text = "You are not an admin!"})
		Panel:ControlHelp("Notice: Only admins can change this settings")
		return
	end*/

	Panel:AddControl( "Label", {Text = "Notice: This settings are client, meaning it won't change for other people!"})
	local vj_settings_reset = {Options = {}, CVars = {}, Label = "Reset Everything:", MenuButton = "0"}
	vj_settings_reset.Options["#vjbase.menugeneral.default"] = { 
	vj_wep_nomuszzleflash = "0",
	vj_wep_nomuszzlesmoke = "0",
	vj_wep_nomuzzleheatwave = "0",
	vj_wep_nobulletshells = "0",
	vj_wep_nomuszzleflash_dynamiclight = "0",
	}
	Panel:AddControl("ComboBox", vj_settings_reset)
	Panel:AddControl("Checkbox", {Label = "Disable Muzzle Flash", Command = "vj_wep_nomuszzleflash"})
	Panel:AddControl("Checkbox", {Label = "Disable Muzzle Flash Dynamic Light", Command = "vj_wep_nomuszzleflash_dynamiclight"})
	Panel:ControlHelp("Disabling muzzle flash will also disable this")
	Panel:AddControl("Checkbox", {Label = "Disable Muzzle Smoke", Command = "vj_wep_nomuszzlesmoke"})
	Panel:AddControl("Checkbox", {Label = "Disable Muzzle Heat Wave", Command = "vj_wep_nomuzzleheatwave"})
	Panel:AddControl("Checkbox", {Label = "Disable Bullet Shells", Command = "vj_wep_nobulletshells"})
	//Panel:ControlHelp("Example: No more allies, all the SNPCs will kill each other")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function VJ_ADDTOMENU_WEAPON()
	spawnmenu.AddToolMenuOption( "DrVrej", "Weapons", "Weapon Client Settings", "Client Settings", "", "", VJ_WEAPON_CLIENTSETTINGS, {} )
end
hook.Add( "PopulateToolMenu", "VJ_ADDTOMENU_WEAPON", VJ_ADDTOMENU_WEAPON )