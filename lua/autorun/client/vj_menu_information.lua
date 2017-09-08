/*--------------------------------------------------
	=============== Information Menu ===============
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
INFO: Used to load Information Menu for VJ Base
--------------------------------------------------*/
if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
include('autorun/client/vj_menu_plugins.lua')

local function VJ_INFORMATION(Panel)
	local client = LocalPlayer() -- Local Player
	Panel:AddControl( "Label", {Text = "About VJ Base:"})
	Panel:ControlHelp("VJ Base is made by DrVrej. The main purpose of this base is for the sake of simplicity. It provides many types of bases including a very advanced artificial intelligent NPC base.")
	
	Panel:ControlHelp("==============================")
	
	Panel:AddControl( "Label", {Text = "User Information:"})
	
	if game.SinglePlayer() then -- SMP or SSP
	Panel:ControlHelp("Game - SinglePlayer") else
	Panel:ControlHelp("Game - Multiplayer") end
	Panel:ControlHelp("VJ Base Version - "..VJBASE_VERSION)
	Panel:ControlHelp("Number of VJ Addons - "..VJBASE_GETADDONAMOUNT)
	Panel:ControlHelp("Gamemode - "..gmod.GetGamemode().Name)
	Panel:ControlHelp("Map - "..game.GetMap())
	Panel:ControlHelp("Date - "..os.date("%m %d, 20%y"))
	Panel:ControlHelp("Country - "..system.GetCountry()) -- Country
	Panel:ControlHelp("Steam Name - "..client:Nick()) -- Steam Name
	Panel:ControlHelp("Steam ID - "..client:SteamID()) -- Steam ID
	Panel:ControlHelp("Screen Resolution - "..ScrW().."x"..ScrH()) -- Player's Resolution
	-- Check the Operation System
	if system.IsWindows() then Panel:ControlHelp("Operating System - Windows")
	elseif system.IsOSX() then Panel:ControlHelp("Operating System - OSX")
	elseif system.IsLinux() then Panel:ControlHelp("Operating System - Linux") end
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
	
	Panel:AddControl( "Label", {Text = "Command Information:"})
	Panel:ControlHelp("--- All Commands Start with 'vj_' ---")
	Panel:ControlHelp("--- '*' means etc. ---")
	Panel:ControlHelp("")
	Panel:ControlHelp("Base Commands - First prefix usually starts with 'vj_*'")
	Panel:ControlHelp("")
	Panel:ControlHelp("SNPC Settings/Options - Second prefix starts with 'npc_*'")
	Panel:ControlHelp("")
	Panel:ControlHelp("SNPC Health/Damage - Second prefix starts with the name initials of the addon")
	Panel:ControlHelp("")
	Panel:ControlHelp("Weapons - Second prefix starts with 'wep_*'")
	Panel:ControlHelp("")
	Panel:ControlHelp("HUD - Second prefix starts with 'hud_*'")
	Panel:ControlHelp("")
	Panel:ControlHelp("Crosshair - Second prefix starts with 'hud_ch_*'")
	
	Panel:ControlHelp("==============================")
	
	Panel:AddControl( "Label", {Text = "Credits:"})
	Panel:ControlHelp("Orion - Helping with AI coding.")
	Panel:ControlHelp("Cpt. Hazama - Helping and giving many good suggestions.")
	Panel:ControlHelp("Robert Twigs - Giving many good suggestions.")
	Panel:ControlHelp("EnlistedDiabetus - For the huge support!")
	
	Panel:ControlHelp("")
	Panel:ControlHelp("==============================")
	
	Panel:ControlHelp("Copyright (c) "..os.date("20%y").." by DrVrej, All rights reserved.")
	Panel:ControlHelp("No parts of this base or any of its contents may be reproduced, copied, modified or adapted, without the prior written consent of the author, unless otherwise indicated for stand-alone materials.")
end
----=================================----
function VJ_ADDTOMENU_INFORMATION()
	spawnmenu.AddToolMenuOption( "DrVrej", "Main Menu", "Information", "Information", "", "", VJ_INFORMATION, {} )
end
hook.Add( "PopulateToolMenu", "VJ_ADDTOMENU_INFORMATION", VJ_ADDTOMENU_INFORMATION )