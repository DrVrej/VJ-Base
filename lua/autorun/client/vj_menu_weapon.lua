/*--------------------------------------------------
	=============== Weapon Menu ===============
	*** Copyright (c) 2012-2023 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
include('autorun/client/vj_menu_plugins.lua') 
---------------------------------------------------------------------------------------------------------------------------------------------
local function VJ_WEAPON_CLIENTSETTINGS(Panel) -- Client Settings
	Panel:AddControl("Label", {Text = "#vjbase.menu.wep.clsettings.notice"})
	Panel:AddControl("Button",{Text = "#vjbase.menu.general.reset.everything", Command = "vj_wep_nomuszzleflash 0\n vj_wep_nobulletshells 0\n vj_wep_nomuszzleflash_dynamiclight 0"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.wep.clsettings.togglemuzzle", Command = "vj_wep_nomuszzleflash"})
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.wep.clsettings.togglemuzzlelight", Command = "vj_wep_nomuszzleflash_dynamiclight"})
	Panel:ControlHelp("#vjbase.menu.wep.clsettings.togglemuzzle.label")
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.wep.clsettings.togglemuzzlebulletshells", Command = "vj_wep_nobulletshells"})
end
---------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("PopulateToolMenu", "VJ_ADDTOMENU_WEAPON", function()
	spawnmenu.AddToolMenuOption("DrVrej", "Weapons", "vj_menu_wep_clsettings", "#vjbase.menu.wep.clsettings", "", "", VJ_WEAPON_CLIENTSETTINGS, {})
end)