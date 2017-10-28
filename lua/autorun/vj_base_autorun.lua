/*--------------------------------------------------
	=============== VJ Base Autorun ===============
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
INFO: Main Autorun file for VJ Base
--------------------------------------------------*/
if (CLIENT) then print("Loading VJ Base (Client)...") else print("Loading VJ Base (Server)...") end

VJBASE_VERSION = "2.4.4"
VJBASE_GETNAME = "VJ Base"

-- Shared --
include("autorun/vj_menu_spawn.lua")
AddCSLuaFile("autorun/vj_base_autorun.lua")
AddCSLuaFile("autorun/vj_controls.lua")
AddCSLuaFile("autorun/vj_entity_codes.lua")
AddCSLuaFile("autorun/vj_files.lua")
AddCSLuaFile("autorun/vj_menu_main.lua")
AddCSLuaFile("autorun/vj_particles.lua")
AddCSLuaFile("autorun/vj_snpc_commands.lua")
AddCSLuaFile("autorun/vj_util.lua")
AddCSLuaFile("autorun/vj_weapon_codes.lua")

-- Client --
AddCSLuaFile("autorun/client/vj_menu_information.lua")
AddCSLuaFile("autorun/client/vj_menu_plugins.lua")
AddCSLuaFile("autorun/client/vj_menu_snpc.lua")
AddCSLuaFile("autorun/client/vj_menu_weapon.lua")

-- Server --
AddCSLuaFile("autorun/server/vj_functions.lua")

-- Modules
AddCSLuaFile("includes/modules/ai_vj_schedule.lua")
AddCSLuaFile("includes/modules/ai_vj_task.lua")
AddCSLuaFile("includes/modules/sound_vj_track.lua")
----=================================----
if (SERVER) then
	util.AddNetworkString("VJWelcome")
	util.AddNetworkString("VJSay")
elseif (CLIENT) then
	hook.Add("AddToolMenuTabs", "VJ_CREATETOOLTAB", function()
		spawnmenu.AddToolTab("DrVrej", "DrVrej", "icon16/plugin.png")
		spawnmenu.AddToolCategory("DrVrej", "Main Menu", "Main Menu")
		spawnmenu.AddToolCategory("DrVrej", "SNPCs", "SNPC Settings")
		spawnmenu.AddToolCategory("DrVrej", "Weapons", "Weapon Settings")
		spawnmenu.AddToolCategory("DrVrej", "HUDs", "HUD Settings")
		spawnmenu.AddToolCategory("DrVrej", "Tools", "Tools")
		spawnmenu.AddToolCategory("DrVrej", "SNPC Configures", "SNPC Configures")
	end)
end

function DoWelcomeDrVrej(ply, command, arguements)
	//if game.SinglePlayer() then return end
	if (ply:SteamID() == "STEAM_0:0:22688298") then
		PrintMessage(HUD_PRINTTALK,"DrVrej Has Joined The Game!")
		PrintMessage(HUD_PRINTCENTER,"DrVrej Has Joined The Game!")
		local sd = CreateSound(game.GetWorld(),"vj_illuminati/Illuminati Confirmed.mp3")
		sd:SetSoundLevel(0)
		sd:Play()
		timer.Simple(10,function() if sd then sd:Stop() end end)
	end
end
hook.Add("PlayerInitialSpawn", "drvrejplayerInitialSpawn", DoWelcomeDrVrej)

function VJSpawn(ply)
	timer.Simple(1, function()
	net.Start("VJWelcome")
	net.Send(ply)
	//print(engine.GetGames())
	end)
end
hook.Add("PlayerInitialSpawn", "VJBaseSpawn", VJSpawn)

net.Receive("VJSay",function(len,pl)
	if pl:IsPlayer() && pl:SteamID() == "STEAM_0:0:22688298" then
		PrintMessage(HUD_PRINTTALK,"The creator of VJ Base, DrVrej is in the server!")
		local sd = CreateSound(game.GetWorld(),"vj_illuminati/Illuminati Confirmed.mp3")
		sd:SetSoundLevel(0)
		sd:Play()
	end
end)

if (SLVBase) then
	timer.Simple(1,function()
		if not VJCONFLICT then
			if (CLIENT) then
				chat.AddText(Color(255,100,0),"Confliction Detected!",
				Color(0,255,0)," VJ Base ",
				Color(0,200,200),"is being overridden by another addon!")
				chat.AddText(Color(0,200,200),"Incompatible Addons: http://steamcommunity.com/sharedfiles/filedetails/?id=1129493108")
		
				VJCONFLICT = vgui.Create("DFrame")
				VJCONFLICT:SetTitle("ERROR!")
				VJCONFLICT:SetSize(790,560)
				VJCONFLICT:SetPos((ScrW()-VJCONFLICT:GetWide())/2,(ScrH()-VJCONFLICT:GetTall())/2)
				VJCONFLICT:MakePopup()
				VJCONFLICT.Paint = function()
					draw.RoundedBox(8,0,0,VJCONFLICT:GetWide(),VJCONFLICT:GetTall(),Color(200,0,0,150))
				end
				
				local VJURL = vgui.Create("DHTML",VJCONFLICT)
				VJURL:SetPos(VJCONFLICT:GetWide()*0.005, VJCONFLICT:GetTall()*0.03)
				VJURL:Dock(FILL)
				VJURL:SetAllowLua(true)
				VJURL:OpenURL("https://sites.google.com/site/vrejgaming/vjbaseconflict")
			elseif (SERVER) then
				timer.Create("VJBASEMissing",5,0,function() print("VJ Base is being overridden by another addon! Incompatible Addons: http://steamcommunity.com/sharedfiles/filedetails/?id=1129493108") end)
			end
		end
	end)
end

if (CLIENT) then print("VJ Base client files initialized!") else print("VJ Base server files initialized!") end
-- Raps and Sounds -------------------------------------------------------------------------------------------------------------------------
/*
/_-_-_-_-_-_-_-_-_-_ Official Song of The True Coders -_-_-_-_-_-_-_-_-_-_-_-_\
|------------------- By: DrVrej, Cpt. Hazama, and Orion ------------------------|
|-_-_-_-_-_-_-_-_-_-_- Remake of Hey There Delilah -_-_-_-_-_-_-_-_-_-_-_-_-_-|
\__________________________________________________________________________/
//Hey there AI Base, with your messy lines and broken functions 
//Trying hard to give a shit, because the base is year-old useless shiiiiit todaaay 
//It's like EA made this fucking code, this is baaad 
//Hey there Silverlan and Magenta, Sucking cocks and swapping accounts 
//Just so you can get five stars in every fucking addon, yes it's true... 
//Just keep trolling you stupid cunts, fat elephants. 
//Ooooh, it's how you coded meeee! Oh, it's how you coded meeeee! 
//Ooooh, it's how you coded meeee! You fucking cunts, it's how you coded meeeee! 
//I travelled over a thousand miles but all I did was run in circles, coded by a fucking stupid prick. 
//I tried to make a working addon but never mind, it's fucking broken, coded by a Silverlan-ish dick. -codedbypiratecatty 
//Nyan cat and other shit that's 8-bit shitty fucking creepers, coded by a 12 year old shit. 
//Crazy-Louis and other faggots stealing stuff from VJ base and fucking gmod workshop in the ass. 
//Fucking gmod workshop in the ass. 
//Fucking it in the ass. 
//Fucking it in the ass. 
//Ooooh, it's how you coded meeee! Ohhhh, it's how you coded meeeee! 
//Ooooh, it's how you coded meeee! You fucking cunts, it's how you coded meeeee! it's how you coded me!
*/