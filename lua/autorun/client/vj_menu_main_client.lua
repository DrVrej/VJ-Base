/*--------------------------------------------------
	=============== Client Main Menu ===============
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
include('autorun/client/vj_menu_plugins.lua')

local function VJ_INFORMATION(Panel)
	local client = LocalPlayer() -- Local Player
	Panel:AddControl("Label", {Text = "About VJ Base:"})
	Panel:ControlHelp("VJ Base is made by DrVrej. The main purpose of this base is for the sake of simplicity. It provides many types of bases including a very advanced artificial intelligent NPC base.")
	
	Panel:ControlHelp("==============================")
	
	Panel:AddControl("Label", {Text = "User Information:"})
	
	Panel:ControlHelp("Date - "..os.date("%m %d, 20%y"))
	Panel:ControlHelp("Country - "..system.GetCountry())
	Panel:ControlHelp("Steam Name - "..client:Nick()) -- Steam Name
	Panel:ControlHelp("Steam ID - "..client:SteamID()) -- Steam ID
	if game.SinglePlayer() then -- SMP or SSP
	Panel:ControlHelp("Game - SinglePlayer") else
	Panel:ControlHelp("Game - Multiplayer") end
	Panel:ControlHelp("Gamemode - "..gmod.GetGamemode().Name)
	Panel:ControlHelp("Map - "..game.GetMap())
	Panel:ControlHelp("VJ Base Version - "..VJBASE_VERSION)
	Panel:ControlHelp("Number of VJ Plugins - "..VJBASE_TOTALPLUGINS)
	-- Check the Operation System
	if system.IsWindows() then Panel:ControlHelp("Operating System - Windows")
	elseif system.IsOSX() then Panel:ControlHelp("Operating System - OSX")
	elseif system.IsLinux() then Panel:ControlHelp("Operating System - Linux") end
	Panel:ControlHelp("Screen Resolution - "..ScrW().."x"..ScrH()) -- Player's Resolution
	Panel:ControlHelp("")
	-- Check Mounted Games
	if IsMounted( "hl1" ) then -- Is Half Life 1 Source mounted? Or not?
	Panel:ControlHelp("Half Life 1 Source - Mounted") else
	Panel:ControlHelp("Half Life 1 Source - Not Mounted") end
	if IsMounted( "episodic" ) then -- Is HL2 EP1 mounted? Or not?
	Panel:ControlHelp("Half Life 2 Episode 1 - Mounted") else
	Panel:ControlHelp("Half Life 2 Episode 1 - Not Mounted") end
	if IsMounted( "ep2" ) then -- Is HL2 EP2 mounted? Or not?
	Panel:ControlHelp("Half Life 2 Episode 2 - Mounted") else
	Panel:ControlHelp("Half Life 2 Episode 2 - Not Mounted") end
	if IsMounted( "cstrike" ) then -- Is Counter Strike Source mounted? Or not?
	Panel:ControlHelp("Counter Strike Source - Mounted") else
	Panel:ControlHelp("Counter Strike Source - Not Mounted") end
	
	Panel:ControlHelp("==============================")
	
	Panel:AddControl("Label", {Text = "Command Information:"})
	Panel:ControlHelp("--- All Commands Start with 'vj_' ---")
	Panel:ControlHelp("")
	Panel:ControlHelp("Base Commands - First prefix usually starts with 'vj_*'")
	Panel:ControlHelp("")
	Panel:ControlHelp("SNPC Configurations - Second prefix starts with 'npc_*'")
	Panel:ControlHelp("")
	Panel:ControlHelp("SNPC Health/Damage - Second prefix starts with the initials of the addon's name")
	Panel:ControlHelp("")
	Panel:ControlHelp("Weapons - Second prefix starts with 'wep_*'")
	Panel:ControlHelp("")
	Panel:ControlHelp("HUD - Second prefix starts with 'hud_*'")
	Panel:ControlHelp("")
	Panel:ControlHelp("Crosshair - Second prefix starts with 'hud_ch_*'")
	
	Panel:ControlHelp("==============================")
	
	Panel:AddControl("Label", {Text = "Credits:"})
	Panel:ControlHelp("DrVrej(Me) - Everything, from coding to fixing models and materials to sound editing")
	Panel:ControlHelp("Black Mesa Source - Original non-edited gib models, blood pool texture, and glock 17 model")
	Panel:ControlHelp("Valve - AK-47, M16A1 and MP40 models")
	Panel:ControlHelp("Orion - Helped in the first version of the base (2011-2012)")
	Panel:ControlHelp("Cpt. Hazama - Suggestions + testing")
	Panel:ControlHelp("Oteek - Bloodpool textures + testing")
	Panel:ControlHelp("China-Mandem - Original K-3 Model")
	
	
	Panel:ControlHelp("")
	Panel:ControlHelp("==============================")
	
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
	vj_combo_box:AddChoice("Հայերեն", "armenian", false, "flags16/am.png")
	vj_combo_box:AddChoice("Русский", "russian", false, "flags16/ru.png")
	vj_combo_box:AddChoice("Deutsche", "german", false, "flags16/de.png")
	vj_combo_box:AddChoice("Français", "french", false, "flags16/fr.png")
	vj_combo_box:AddChoice("Lietuvių", "lithuanian", false, "flags16/lt.png")
	vj_combo_box:AddChoice("Español (Latino Americano)", "spanish_lt", false, "flags16/mx.png")
	vj_combo_box:AddChoice("Português (Brasileiro)", "portuguese_br", false, "flags16/br.png")
	vj_combo_box.OnSelect = function(data, index, text)
		RunConsoleCommand("vj_language", vj_combo_box:GetOptionData(index))
		chat.AddText(Color(255,215,0), "#vjbase.menu.clsettings.notify.lang", " ", Color(30,200,255), text)
		timer.Simple(0.2,function() VJ_REFRESH_LANGUAGE(val) end) -- Bedke kichme espasenk minchevor command-e update ela
	end
	Panel:AddPanel(vj_combo_box)
end
----=================================----
hook.Add("PopulateToolMenu", "VJ_ADDTOMENU_INFORMATION", function()
	spawnmenu.AddToolMenuOption("DrVrej", "Main Menu", "Information", "#vjbase.menu.info", "", "", VJ_INFORMATION, {})
	spawnmenu.AddToolMenuOption("DrVrej", "Main Menu", "Client Settings", "#vjbase.menu.clsettings", "", "", VJ_MAINMENU_CLIENT, {})
end)