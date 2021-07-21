/*--------------------------------------------------
	=============== Weapon Menu ===============
	*** Copyright (c) 2012-2021 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
include('autorun/client/vj_menu_plugins.lua') 
---------------------------------------------------------------------------------------------------------------------------------------------
local function VJ_WEAPON_CLIENTSETTINGS(Panel) -- Client Settings
	Panel:AddControl("Label", {Text = "#vjbase.menu.clweapon.notice"})
	Panel:AddControl("Button",{Text = "#vjbase.menu.general.reset.everything", Command = "vj_wep_nomuszzleflash 0\n vj_wep_nobulletshells 0\n vj_wep_nomuszzleflash_dynamiclight 0"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.clweapon.togglemuzzle", Command = "vj_wep_nomuszzleflash"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.clweapon.togglemuzzlelight", Command = "vj_wep_nomuszzleflash_dynamiclight"})
	Panel:ControlHelp("#vjbase.menu.clweapon.togglemuzzle.label")
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.clweapon.togglemuzzlebulletshells", Command = "vj_wep_nobulletshells"})
end
---------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("PopulateToolMenu", "VJ_ADDTOMENU_WEAPON", function()
	spawnmenu.AddToolMenuOption("DrVrej", "Weapons", "Weapon Client Settings", "#vjbase.menu.clweapon", "", "", VJ_WEAPON_CLIENTSETTINGS, {})
end)