/*--------------------------------------------------
	=============== VJ Base Autorun ===============
	*** Copyright (c) 2012-2021 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.

	██    ██      ██     ██████   █████  ███████ ███████
	██    ██      ██     ██   ██ ██   ██ ██      ██
	██    ██      ██     ██████  ███████ ███████ █████
	 ██  ██  ██   ██     ██   ██ ██   ██      ██ ██
	  ████    █████      ██████  ██   ██ ███████ ███████

--------------------------------------------------*/
if (CLIENT) then print("Loading VJ Base (Client)...") else print("Loading VJ Base (Server)...") end

VJBASE_VERSION = "2.13.1"
VJBASE_GETNAME = "VJ Base"

-- Shared --
include("autorun/vj_menu_spawn.lua")
AddCSLuaFile("autorun/vj_base_autorun.lua")
AddCSLuaFile("autorun/vj_controls.lua")
AddCSLuaFile("autorun/vj_entities.lua")
AddCSLuaFile("autorun/vj_entities_cmds.lua")
AddCSLuaFile("autorun/vj_files.lua")
AddCSLuaFile("autorun/vj_files_language.lua")
AddCSLuaFile("autorun/vj_files_particles.lua")
AddCSLuaFile("autorun/vj_menu_main.lua")
AddCSLuaFile("autorun/vj_menu_properties.lua")
AddCSLuaFile("autorun/vj_util.lua")
AddCSLuaFile("autorun/vj_weapons.lua")

-- Client --
AddCSLuaFile("autorun/client/vj_menu_main_client.lua")
AddCSLuaFile("autorun/client/vj_menu_plugins.lua")
AddCSLuaFile("autorun/client/vj_menu_snpc.lua")
AddCSLuaFile("autorun/client/vj_menu_weapon.lua")

-- Modules --
AddCSLuaFile("includes/modules/ai_vj_schedule.lua")
AddCSLuaFile("includes/modules/ai_vj_task.lua")
//AddCSLuaFile("includes/modules/sound_vj_track.lua")

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Main Hooks / Functions ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if (SERVER) then
	util.AddNetworkString("VJWelcome")
	util.AddNetworkString("VJSay")
elseif (CLIENT) then
	hook.Add("AddToolMenuTabs", "VJ_CREATETOOLTAB", function()
		spawnmenu.AddToolTab("DrVrej", "DrVrej", "vj_base/icons/vrejgaming.png") // "icon16/plugin.png"
		spawnmenu.AddToolCategory("DrVrej", "Main Menu", "#vjbase.menu.tabs.mainmenu")
		spawnmenu.AddToolCategory("DrVrej", "SNPCs", "#vjbase.menu.tabs.settings.snpc")
		spawnmenu.AddToolCategory("DrVrej", "Weapons", "#vjbase.menu.tabs.settings.weapon")
		spawnmenu.AddToolCategory("DrVrej", "HUDs", "#vjbase.menu.tabs.settings.hud")
		spawnmenu.AddToolCategory("DrVrej", "Tools", "#vjbase.menu.tabs.tools")
		spawnmenu.AddToolCategory("DrVrej", "SNPC Configures", "#vjbase.menu.tabs.configures.snpc")
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("PlayerInitialSpawn", "VJBaseSpawn", function(ply, transition)
	-- Simple message for the users
	timer.Simple(1, function()
		net.Start("VJWelcome")
		net.Send(ply)
	end)
	
	if (ply:SteamID() == "STEAM_0:0:22688298") then
		PrintMessage(HUD_PRINTTALK,"DrVrej Has Joined The Game!")
		PrintMessage(HUD_PRINTCENTER,"DrVrej Has Joined The Game!")
		local sd = CreateSound(game.GetWorld(),"vj_illuminati/Illuminati Confirmed.mp3")
		sd:SetSoundLevel(0)
		sd:Play()
		timer.Simple(10, function() if sd then sd:Stop() end end)
	end
end)
---------------------------------------------------------------------------------------------------------------------------------------------
net.Receive("VJSay", function(len, pl)
	if pl:IsPlayer() && pl:SteamID() == "STEAM_0:0:22688298" then
		PrintMessage(HUD_PRINTTALK, "DrVrej is in the server!")
		local sd = CreateSound(game.GetWorld(), "vj_illuminati/Illuminati Confirmed.mp3")
		sd:SetSoundLevel(0)
		sd:Play()
	end
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Outdated GMod Version Check ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if SERVER && !isfunction(FindMetaTable("NPC").SetIdealYawAndUpdate) then
	timer.Simple(1, function()
		if !VJ_WARN_GModOutdated then
			VJ_WARN_GModOutdated = true
			timer.Create("VJ_WARN_GModOutdated", 2, 0, function()
				PrintMessage(HUD_PRINTTALK, "--- Outdated version of Garry's Mod detected! ---")
				PrintMessage(HUD_PRINTTALK, "Opt out of the Chromium branch!")
			end)
		end
	end)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ SLV Base Check ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if (SLVBase) then
	timer.Simple(1, function()
		if !VJ_WARN_SLVBase then
			if (CLIENT) then
				chat.AddText(Color(255,100,0),"Confliction Detected!",
				Color(0,255,0)," VJ Base ",
				Color(0,200,200),"is being overridden by another addon!")
				chat.AddText(Color(0,200,200),"Incompatible Addons: http://steamcommunity.com/sharedfiles/filedetails/?id=1129493108")

				VJ_WARN_SLVBase = vgui.Create("DFrame")
				VJ_WARN_SLVBase:SetTitle("ERROR!")
				VJ_WARN_SLVBase:SetSize(790,560)
				VJ_WARN_SLVBase:SetPos((ScrW()-VJ_WARN_SLVBase:GetWide())/2, (ScrH()-VJ_WARN_SLVBase:GetTall())/2)
				VJ_WARN_SLVBase:MakePopup()
				VJ_WARN_SLVBase.Paint = function()
					draw.RoundedBox(8, 0, 0, VJ_WARN_SLVBase:GetWide(), VJ_WARN_SLVBase:GetTall(), Color(200,0,0,150))
				end

				local VJURL = vgui.Create("DHTML", VJ_WARN_SLVBase)
				VJURL:SetPos(VJ_WARN_SLVBase:GetWide()*0.005, VJ_WARN_SLVBase:GetTall()*0.03)
				VJURL:Dock(FILL)
				VJURL:SetAllowLua(true)
				VJURL:OpenURL("https://sites.google.com/site/vrejgaming/vjbaseconflict")
			elseif (SERVER) then
				timer.Create("VJ_WARN_SLVBase", 5, 0, function()
					print("VJ Base is being overridden by another addon! Incompatible Addons: http://steamcommunity.com/sharedfiles/filedetails/?id=1129493108")
				end)
			end
		end
	end)
end

if (CLIENT) then print("VJ Base client files initialized!") else print("VJ Base server files initialized!") end