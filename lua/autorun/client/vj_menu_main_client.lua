/*--------------------------------------------------
	=============== Client Main Menu ===============
	*** Copyright (c) 2012-2021 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
include('autorun/client/vj_menu_plugins.lua')

local function VJ_INFORMATION(Panel)
	local client = LocalPlayer() -- Local Player
	Panel:AddControl("Label", {Text = "About VJ Base:"})
	Panel:ControlHelp("VJ Base is made by DrVrej. The main purpose of this base is for the sake of simplicity. It provides many types of bases including a very advanced artificial intelligent NPC base.")
	--
	--
	Panel:AddControl("Label", {Text = "User Information:"})
	Panel:ControlHelp("Date - "..os.date("%b %d, %Y - %I:%M %p")) -- Date
	Panel:ControlHelp("Name - "..client:Nick().." ("..client:SteamID()..")") -- Name + Steam ID
	Panel:ControlHelp("Session - "..(game.SinglePlayer() and "SinglePlayer" or "Multiplayer")..", "..gmod.GetGamemode().Name.." ("..game.GetMap()..")") -- Game Session
	Panel:ControlHelp("VJ Base - "..VJBASE_VERSION..", "..VJBASE_TOTALPLUGINS.." plugins, "..GetConVar("vj_language"):GetString()) -- VJ Base Information
	Panel:ControlHelp("System - "..(system.IsLinux() and "Linux" or (system.IsOSX() and "OSX" or "Windows")).." ("..ScrW().."x"..ScrH()..")") // system.IsWindows() -- System
	--
	--
	Panel:AddControl("Label", {Text = "Mounted Games:"})
	Panel:ControlHelp("HL1S - "..tostring(IsMounted("hl1")))
	Panel:ControlHelp("HL2 - "..tostring(IsMounted("hl2")))
	Panel:ControlHelp("HL2Ep1 - "..tostring(IsMounted("episodic")))
	Panel:ControlHelp("HL2Ep2 - "..tostring(IsMounted("ep2")))
	Panel:ControlHelp("CSS - "..tostring(IsMounted("cstrike")))
	Panel:ControlHelp("DoD - "..tostring(IsMounted("dod")))
	Panel:ControlHelp("TF2 - "..tostring(IsMounted("tf")))
	--
	--
	Panel:AddControl("Label", {Text = "Command Information:"})
	Panel:ControlHelp("SNPC Configurations - 'vj_npc_*'")
	Panel:ControlHelp("Weapons - 'vj_wep_*'")
	Panel:ControlHelp("HUD - 'vj_hud_*'")
	Panel:ControlHelp("Crosshair - 'vj_hud_ch_*'")
	--
	--
	Panel:AddControl("Label", {Text = "Credits:"})
	Panel:ControlHelp("DrVrej(Me) - Everything, from coding to fixing models and materials to sound editing")
	Panel:ControlHelp("Black Mesa Source - Original non-edited gib models, blood pool texture, and glock 17 model")
	Panel:ControlHelp("Valve - AK-47, M16A1 and MP40 models")
	Panel:ControlHelp("Orion - Helped create first version of the base (2011-2012)")
	Panel:ControlHelp("Cpt. Hazama - Suggestions + testing")
	Panel:ControlHelp("Oteek - Bloodpool textures + testing")
	Panel:ControlHelp("China-Mandem - Original K-3 Model")
	
	Panel:ControlHelp("")
	Panel:ControlHelp("============================")
	
	Panel:ControlHelp("Copyright (c) "..os.date("20%y").." by DrVrej, All rights reserved.")
	Panel:ControlHelp("No parts of this base or any of its contents may be reproduced, copied, modified or adapted, without the prior written consent of the author, unless otherwise indicated for stand-alone materials.")
end
----=================================----
local function VJ_MAINMENU_CLIENT(Panel)
	Panel:AddControl("Label", {Text = "#vjbase.menu.clsettings.label"})
	
	-- Icons: https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2
	local vj_combo_box = vgui.Create("DComboBox")
	vj_combo_box:SetSize(100, 30)
	vj_combo_box:SetValue("#vjbase.menu.clsettings.labellang")
	vj_combo_box:AddChoice("English", "english", false, "flags16/us.png")
	vj_combo_box:AddChoice("简体中文", "schinese", false, "flags16/cn.png")
	vj_combo_box:AddChoice("Հայերեն *", "armenian", false, "flags16/am.png")
	vj_combo_box:AddChoice("Русский", "russian", false, "flags16/ru.png")
	vj_combo_box:AddChoice("Deutsche *", "german", false, "flags16/de.png")
	vj_combo_box:AddChoice("Français *", "french", false, "flags16/fr.png")
	vj_combo_box:AddChoice("Lietuvių", "lithuanian", false, "flags16/lt.png")
	vj_combo_box:AddChoice("Español (Latino Americano) *", "spanish_lt", false, "flags16/mx.png")
	vj_combo_box:AddChoice("Português (Brasileiro) *", "portuguese_br", false, "flags16/br.png")
	vj_combo_box.OnSelect = function(data, index, text)
		RunConsoleCommand("vj_language", vj_combo_box:GetOptionData(index))
		chat.AddText(Color(255, 215, 0), "#vjbase.menu.clsettings.notify.lang", " ", Color(30, 200, 255), text)
		timer.Simple(0.2, function() VJ_REFRESH_LANGUAGE(val) RunConsoleCommand("spawnmenu_reload") end) -- Bedke kichme espasenk minchevor command-e update ela
	end
	Panel:AddPanel(vj_combo_box)
	Panel:ControlHelp("* stands for unfinished translation!")
	Panel:AddControl("Checkbox", {Label = "#vjbase.menu.clsettings.lang.auto", Command = "vj_language_auto"})
	Panel:ControlHelp("#vjbase.menu.clsettings.lang.auto.label")
end
----=================================----
hook.Add("PopulateToolMenu", "VJ_ADDTOMENU_INFORMATION", function()
	spawnmenu.AddToolMenuOption("DrVrej", "Main Menu", "Information", "#vjbase.menu.info", "", "", VJ_INFORMATION, {})
	spawnmenu.AddToolMenuOption("DrVrej", "Main Menu", "Client Settings", "#vjbase.menu.clsettings", "", "", VJ_MAINMENU_CLIENT, {})
end)
