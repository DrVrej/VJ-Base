/*--------------------------------------------------
	=============== VJ Base Autorun ===============
	*** Copyright (c) 2012-2019 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.

	██    ██      ██     ██████   █████  ███████ ███████
	██    ██      ██     ██   ██ ██   ██ ██      ██
	██    ██      ██     ██████  ███████ ███████ █████
	 ██  ██  ██   ██     ██   ██ ██   ██      ██ ██
	  ████    █████      ██████  ██   ██ ███████ ███████

--------------------------------------------------*/
if (CLIENT) then print("Loading VJ Base (Client)...") else print("Loading VJ Base (Server)...") end

VJBASE_VERSION = "2.9.0"
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

-- Modules --
AddCSLuaFile("includes/modules/ai_vj_schedule.lua")
AddCSLuaFile("includes/modules/ai_vj_task.lua")
AddCSLuaFile("includes/modules/sound_vj_track.lua")
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Main Hooks / Functions ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
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
---------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("PlayerInitialSpawn", "drvrejplayerInitialSpawn", function(ply,command,arguements)
	//if game.SinglePlayer() then return end
	if (ply:SteamID() == "STEAM_0:0:22688298") then
		PrintMessage(HUD_PRINTTALK,"DrVrej Has Joined The Game!")
		PrintMessage(HUD_PRINTCENTER,"DrVrej Has Joined The Game!")
		local sd = CreateSound(game.GetWorld(),"vj_illuminati/Illuminati Confirmed.mp3")
		sd:SetSoundLevel(0)
		sd:Play()
		timer.Simple(10,function() if sd then sd:Stop() end end)
	end
end)
---------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("PlayerInitialSpawn", "VJBaseSpawn", function(ply)
	timer.Simple(1, function()
		net.Start("VJWelcome")
		net.Send(ply)
		//print(engine.GetGames())
	end)
end)
---------------------------------------------------------------------------------------------------------------------------------------------
net.Receive("VJSay",function(len,pl)
	if pl:IsPlayer() && pl:SteamID() == "STEAM_0:0:22688298" then
		PrintMessage(HUD_PRINTTALK,"The creator of VJ Base, DrVrej is in the server!")
		local sd = CreateSound(game.GetWorld(),"vj_illuminati/Illuminati Confirmed.mp3")
		sd:SetSoundLevel(0)
		sd:Play()
	end
end)
---------------------------------------------------------------------------------------------------------------------------------------------
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