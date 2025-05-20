/*--------------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.

	██    ██      ██     ██████   █████  ███████ ███████
	██    ██      ██     ██   ██ ██   ██ ██      ██
	██    ██      ██     ██████  ███████ ███████ █████
	 ██  ██  ██   ██     ██   ██ ██   ██      ██ ██
	  ████    █████      ██████  ██   ██ ███████ ███████

--------------------------------------------------*/
AddCSLuaFile()

if CLIENT then MsgC(Color(255, 163, 121), "VJ Base: ", Color(255, 241, 122, 200), "Initializing client files...\n") else MsgC(Color(255, 163, 121), "VJ Base: ", Color(156, 241, 255, 200), "Initializing server files...\n") end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Global Variables ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
VJBASE_INSTALLED = true
VJBASE_VERSION = "3.1.0"

VJ_CVAR_IGNOREPLAYERS = GetConVar("ai_ignoreplayers"):GetInt() != 0
VJ_CVAR_AI_ENABLED = GetConVar("ai_disabled"):GetInt() != 1
if SERVER then VJ_RecipientFilter = RecipientFilter() VJ_RecipientFilter:AddAllPlayers() end
if !VJ then VJ = {} end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ File Initialization ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- ====== Autorun ====== ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
AddCSLuaFile("autorun/vj_controls.lua")
include("autorun/vj_controls.lua")

	-- ====== Core ====== ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
AddCSLuaFile("vj_base/enums.lua")
AddCSLuaFile("vj_base/convars.lua")
AddCSLuaFile("vj_base/debug.lua")
AddCSLuaFile("vj_base/funcs.lua")
AddCSLuaFile("vj_base/hooks.lua")

include("vj_base/convars.lua")
include("vj_base/debug.lua")
include("vj_base/enums.lua")
include("vj_base/funcs.lua")
include("vj_base/hooks.lua")

	-- ====== Menu ====== ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
AddCSLuaFile("vj_base/menu/main.lua")
AddCSLuaFile("vj_base/menu/spawn.lua")
AddCSLuaFile("vj_base/menu/entity_configures.lua")
AddCSLuaFile("vj_base/menu/entity_properties.lua")

include("vj_base/menu/main.lua")
include("vj_base/menu/spawn.lua")
include("vj_base/menu/entity_configures.lua")
include("vj_base/menu/entity_properties.lua")

	-- ====== Resources ====== ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
AddCSLuaFile("vj_base/resources/localization.lua")
AddCSLuaFile("vj_base/resources/main.lua")
AddCSLuaFile("vj_base/resources/particles.lua")
AddCSLuaFile("vj_base/resources/sounds.lua")

include("vj_base/resources/localization.lua")
include("vj_base/resources/main.lua")
include("vj_base/resources/particles.lua")
include("vj_base/resources/sounds.lua")

	-- ====== Extensions ====== ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
AddCSLuaFile("vj_base/extensions/corpse.lua")
AddCSLuaFile("vj_base/extensions/music.lua")

include("vj_base/extensions/corpse.lua")
include("vj_base/extensions/music.lua")

	-- ====== Modules ====== ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
AddCSLuaFile("includes/modules/vj_ai_nodegraph.lua")
AddCSLuaFile("includes/modules/vj_ai_schedule.lua")
AddCSLuaFile("includes/modules/vj_ai_task.lua")

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Default Spawn Menu ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local spawnCategory = "VJ Base"
	-- ====== Category Information (Many are for popular categories) ====== ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- Game icons can be found in: "Steam\appcache\librarycache"
VJ.AddCategoryInfo(spawnCategory, {Icon = "vj_base/icons/vrejgaming.png"})
VJ.AddCategoryInfo("Alien Swarm", {Icon = "vj_base/icons/alienswarm.png"})
VJ.AddCategoryInfo("Black Mesa", {Icon = "vj_base/icons/blackmesa.png"})
VJ.AddCategoryInfo("Cry Of Fear", {Icon = "vj_base/icons/cryoffear.png"})
VJ.AddCategoryInfo("Dark Messiah", {Icon = "vj_base/icons/darkmessiah.png"})
VJ.AddCategoryInfo("E.Y.E Divine Cybermancy", {Icon = "vj_base/icons/eyedc.png"})
VJ.AddCategoryInfo("Fallout", {Icon = "vj_base/icons/fallout.png"})
VJ.AddCategoryInfo("Left 4 Dead", {Icon = "vj_base/icons/l4d.png"})
VJ.AddCategoryInfo("Military", {Icon = "vj_base/icons/mil1.png"})
VJ.AddCategoryInfo("No More Room In Hell", {Icon = "vj_base/icons/nmrih.png"})
VJ.AddCategoryInfo("Star Wars", {Icon = "vj_base/icons/starwars.png"})
VJ.AddCategoryInfo("Zombies", {Icon = "vj_base/icons/zombies.png"})
	-- ====== NPCs ====== ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
VJ.AddNPC("Aerial NPC", "npc_vj_test_aerial", spawnCategory)
VJ.AddNPC("Interactive NPC", "npc_vj_test_interactive", spawnCategory, true)
VJ.AddNPC_HUMAN("Player NPC", "npc_vj_test_player", {"weapon_vj_ak47", "weapon_vj_glock17", "weapon_vj_m16a1", "weapon_vj_mp40", "weapon_vj_9mmpistol", "weapon_vj_357", "weapon_vj_ar2", "weapon_vj_blaster", "weapon_vj_smg1", "weapon_vj_spas12", "weapon_vj_k3", "weapon_vj_crossbow", "weapon_vj_ssg08"}, spawnCategory)
	-- ====== Entities ====== ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
VJ.AddEntity("Admin Health Kit", "sent_vj_ply_healthkit", "DrVrej", true, 0, true, spawnCategory)
VJ.AddEntity("Player Spawnpoint", "sent_vj_ply_spawn", "DrVrej", true, 0, true, spawnCategory)
VJ.AddEntity("Campfire", "sent_vj_campfire", "DrVrej", false, 0, true, spawnCategory)
VJ.AddEntity("Wooden Board", "prop_vj_board", "DrVrej", false, 0, true, spawnCategory)
VJ.AddEntity("Grenade", "obj_vj_grenade", "DrVrej", false, 0, true, spawnCategory)
VJ.AddEntity("Flare Round", "obj_vj_flareround", "DrVrej", false, 0, true, spawnCategory)
VJ.AddEntity("Flag", "prop_vj_flag", "DrVrej", false, 0, true, spawnCategory)
	-- ====== Weapons ====== ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
VJ.AddWeapon("AK-47", "weapon_vj_ak47", false, spawnCategory)
VJ.AddWeapon("Glock 17", "weapon_vj_glock17", false, spawnCategory)
VJ.AddWeapon("M16A1", "weapon_vj_m16a1", false, spawnCategory)
VJ.AddWeapon("MP 40", "weapon_vj_mp40", false, spawnCategory)
VJ.AddWeapon("9mm Pistol", "weapon_vj_9mmpistol", false, spawnCategory)
VJ.AddWeapon(".357 Magnum", "weapon_vj_357", false, spawnCategory)
VJ.AddWeapon("AR2", "weapon_vj_ar2", false, spawnCategory)
VJ.AddWeapon("Blaster", "weapon_vj_blaster", false, spawnCategory)
VJ.AddWeapon("NPC Controller", "weapon_vj_controller", false, spawnCategory)
VJ.AddWeapon("Flare Gun", "weapon_vj_flaregun", false, spawnCategory)
VJ.AddWeapon("SMG1", "weapon_vj_smg1", false, spawnCategory)
VJ.AddWeapon("SPAS-12", "weapon_vj_spas12", false, spawnCategory)
VJ.AddWeapon("RPG", "weapon_vj_rpg", false, spawnCategory)
	-- ====== NPC Weapons ====== ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
VJ.AddNPCWeapon("VJ_AK-47", "weapon_vj_ak47")
VJ.AddNPCWeapon("VJ_M4A1", "weapon_vj_m16a1")
VJ.AddNPCWeapon("VJ_Glock17", "weapon_vj_glock17")
VJ.AddNPCWeapon("VJ_MP40", "weapon_vj_mp40")
VJ.AddNPCWeapon("VJ_Blaster", "weapon_vj_blaster")
VJ.AddNPCWeapon("VJ_AR2", "weapon_vj_ar2")
VJ.AddNPCWeapon("VJ_SMG1", "weapon_vj_smg1")
VJ.AddNPCWeapon("VJ_9mmPistol", "weapon_vj_9mmpistol")
VJ.AddNPCWeapon("VJ_SPAS-12", "weapon_vj_spas12")
VJ.AddNPCWeapon("VJ_357", "weapon_vj_357")
VJ.AddNPCWeapon("VJ_FlareGun", "weapon_vj_flaregun")
VJ.AddNPCWeapon("VJ_RPG", "weapon_vj_rpg")
VJ.AddNPCWeapon("VJ_K-3", "weapon_vj_k3")
VJ.AddNPCWeapon("VJ_Crossbow", "weapon_vj_crossbow")
VJ.AddNPCWeapon("VJ_SSG-08", "weapon_vj_ssg08")
VJ.AddNPCWeapon("VJ_Crowbar", "weapon_vj_crowbar")
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Main Hooks / Functions ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if SERVER then
	util.AddNetworkString("vj_welcome")
	util.AddNetworkString("vj_meme")
	
	-- Initialize AI Schedule and Task systems
	require("vj_ai_schedule")
	
	-- Initialize AI Nodegraph system
	require("vj_ai_nodegraph")
	timer.Simple(1, function() -- To make sure world is initialized otherwise things like traces will return nil because "worldspawn" doesn't exist
		VJ_Nodegraph = vj_ai_nodegraph.New()
		-- If it failed to read the nodegraph, wait and try again in case nodegraph file hasn't generated yet
		if VJ_Nodegraph:GetNodegraph().Version == -1 then
			MsgC(VJ.COLOR_LOGO_ORANGE_LIGHT, "VJ Base [AI Nodegraph module]: ", VJ.COLOR_RED_LIGHT, "Failed to read nodegraph, will attempt again soon...\n")
			timer.Simple(4, function()
				MsgC(VJ.COLOR_LOGO_ORANGE_LIGHT, "VJ Base [AI Nodegraph module]: ", VJ.COLOR_SERVER, "Running second read attempt...\n")
				VJ_Nodegraph.Data = VJ_Nodegraph:ReadNodegraph()
				if VJ_Nodegraph:GetNodegraph().Version == -1 then
					MsgC(VJ.COLOR_LOGO_ORANGE_LIGHT, "VJ Base [AI Nodegraph module]: ", VJ.COLOR_RED, "Second read attempt was failure, aborting!\n")
				else
					MsgC(VJ.COLOR_LOGO_ORANGE_LIGHT, "VJ Base [AI Nodegraph module]: ", VJ.COLOR_GREEN, "Second read attempt was successful!\n")
				end
			end)
		end
	end)
elseif CLIENT then
	hook.Add("AddToolMenuTabs", "VJ_CREATETOOLTAB", function()
		spawnmenu.AddToolTab("DrVrej", "DrVrej", "vj_base/icons/vrejgaming.png")
		spawnmenu.AddToolCategory("DrVrej", "Main", "#vjbase.menu.tabs.main")
		spawnmenu.AddToolCategory("DrVrej", "NPCs", "#vjbase.menu.tabs.npc")
		spawnmenu.AddToolCategory("DrVrej", "Weapons", "#vjbase.menu.tabs.weapon")
		spawnmenu.AddToolCategory("DrVrej", "HUDs", "#vjbase.menu.tabs.hud")
		spawnmenu.AddToolCategory("DrVrej", "Tools", "#vjbase.menu.tabs.tool")
		spawnmenu.AddToolCategory("DrVrej", "SNPC Configures", "#vjbase.menu.tabs.npc.plugins")
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("PlayerInitialSpawn", "VJ_PlayerInitialSpawn_Msg", function(ply, transition)
	timer.Simple(1, function()
		net.Start("vj_welcome")
		net.Send(ply)
		
		if !game.SinglePlayer() && ply:SteamID() == "STEAM_0:0:22688298" then
			PrintMessage(HUD_PRINTTALK, "DrVrej has joined the game!")
			PrintMessage(HUD_PRINTCENTER, "DrVrej has joined the game!")
			local sd = CreateSound(game.GetWorld(), "vj_base/player/illuminati.mp3", VJ_RecipientFilter)
			sd:SetSoundLevel(0)
			sd:Play()
			timer.Simple(10, function() if sd then sd:Stop() end end)
		end
	end)
end)
---------------------------------------------------------------------------------------------------------------------------------------------
net.Receive("vj_meme", function(len, ply)
	if ply:IsPlayer() && ply:SteamID() == "STEAM_0:0:22688298" then
		PrintMessage(HUD_PRINTTALK, "DrVrej is in the server!")
		local sd = CreateSound(game.GetWorld(), "vj_base/player/illuminati.mp3", VJ_RecipientFilter)
		sd:SetSoundLevel(0)
		sd:Play()
	end
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Outdated Game Check ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if SERVER && (!isfunction(FindMetaTable("Entity").SetSurroundingBoundsType) or !isfunction(FindMetaTable("NPC").GetMoveDelay)) then
	timer.Simple(1, function()
		if !VJBASE_ERROR_GAME_OUTDATED then
			VJBASE_ERROR_GAME_OUTDATED = true
			timer.Create("VJBASE_ERROR_GAME_OUTDATED", 2, 1, function()
				PrintMessage(HUD_PRINTTALK, "--- VJ Base Error! ---")
				PrintMessage(HUD_PRINTTALK, "Game is running on an old unsupported version!")
				PrintMessage(HUD_PRINTTALK, "Expect errors, bugs, and crashes!")
			end)
		end
	end)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Confliction Check ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if SLVBase then
	timer.Simple(1, function()
		if !VJBASE_ERROR_CONFLICT then
			VJBASE_ERROR_CONFLICT = true
			if CLIENT then
				chat.AddText(Color(255, 100, 0), "Confliction Detected!",
				Color(0, 255, 0), " VJ Base ",
				Color(255, 255, 255), "is being overridden by another addon!")
				chat.AddText(Color(0, 200, 200), "Incompatible Addons: http://steamcommunity.com/sharedfiles/filedetails/?id=1129493108")

				local frame = vgui.Create("DFrame")
				frame:SetSize(600, 200)
				frame:SetPos((ScrW() - frame:GetWide()) / 2, (ScrH() - frame:GetTall()) / 2)
				frame:SetTitle("VJ Base Error: Confliction Detected!")
				frame:SetBackgroundBlur(true)
				frame:MakePopup()
	
				local labelTitle = vgui.Create("DLabel", frame)
				labelTitle:SetPos(130, 30)
				labelTitle:SetText("CONFLICTION DETECTED!")
				labelTitle:SetFont("VJBaseLarge")
				labelTitle:SetTextColor(Color(255, 128, 128))
				labelTitle:SizeToContents()
				
				local label1 = vgui.Create("DLabel", frame)
				label1:SetPos(70, 70)
				label1:SetText("VJ Base is being overridden by another addon!")
				label1:SetFont("VJBaseMedium")
				label1:SizeToContents()
				
				local label2 = vgui.Create("DLabel", frame)
				label2:SetPos(10, 100)
				label2:SetText("You have an addon installed that is overriding something in VJ Base. Uninstall the conflicting addon, and then restart your\n game to fix it. Click the link below to view all known incompatible addons. If you find any addons that are conflicting with\n                    VJ Base, be sure to leave a comment in the collection with a link to the incompatible addon!")
				label2:SizeToContents()
				
				local link = vgui.Create("DLabelURL", frame)
				link:SetSize(300, 20)
				link:SetPos(180, 140)
				link:SetText("Incompatible_addons_(Steam_Workshop_Collection)")
				link:SetURL("http://steamcommunity.com/sharedfiles/filedetails/?id=1129493108")
				
				local buttonClose = vgui.Create("DButton", frame)
				buttonClose:SetText("UNDERSTOOD")
				buttonClose:SetPos(260, 160)
				buttonClose:SetSize(80, 35)
				buttonClose.DoClick = function()
					frame:Close()
				end
			elseif SERVER then
				timer.Create("VJBASE_ERROR_CONFLICT", 5, 0, function()
					MsgC(VJ.COLOR_LOGO_ORANGE_LIGHT, "VJ Base: ", VJ.COLOR_RED, "Error! Incompatible addon detected! Check this link for list of incompatible addons: http://steamcommunity.com/sharedfiles/filedetails/?id=1129493108\n")
				end)
			end
		end
	end)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Backwards Compatibility ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- !!!!!!!!!!!!!! DO NOT USE THESE !!!!!!!!!!!!!!
VJ_PICK						= VJ.PICK
VJ_PICKRANDOMTABLE			= VJ.PICK
VJ_STOPSOUND				= VJ.STOPSOUND
VJ_Set						= VJ.SET
VJ_HasValue					= VJ.HasValue
VJ_Color2Byte				= VJ.Color2Byte
VJ_CreateSound				= VJ.CreateSound
VJ_EmitSound				= VJ.EmitSound
VJ_AnimationExists			= VJ.AnimExists
VJ_GetSequenceDuration		= VJ.AnimDuration
VJ_SequenceToActivity		= VJ.SequenceToActivity
VJ_IsCurrentAnimation		= VJ.IsCurrentAnim
VJ_IsProp					= VJ.IsProp
VJ_DestroyCombineTurret		= VJ.DamageSpecialEnts
util.VJ_SphereDamage		= VJ.ApplyRadiusDamage
-- !!!!!!!!!!!!!! DO NOT USE THESE !!!!!!!!!!!!!!
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Plugin Initialization ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if CLIENT then MsgC(VJ.COLOR_LOGO_ORANGE_LIGHT, "VJ Base: ", VJ.COLOR_CLIENT, "Initializing plugins...\n") else MsgC(VJ.COLOR_LOGO_ORANGE_LIGHT, "VJ Base: ", VJ.COLOR_SERVER, "Initializing plugins...\n") end

local files, _ = file.Find("vj_base/plugins/*.lua", "LUA")
for _, f in ipairs(files) do
	local fileName = "vj_base/plugins/" .. f
	AddCSLuaFile(fileName)
	include(fileName)
	if CLIENT then MsgC(VJ.COLOR_LOGO_ORANGE_LIGHT, "VJ Base: ", VJ.COLOR_CLIENT, "Added plugin -> ", VJ.COLOR_GREEN, f, "\n") else MsgC(VJ.COLOR_LOGO_ORANGE_LIGHT, "VJ Base: ", VJ.COLOR_SERVER, "Added plugin -> ", VJ.COLOR_GREEN, f, "\n") end
end
---------------------------------------------------------------------------------------------------------------------------------------------
if CLIENT then MsgC(VJ.COLOR_LOGO_ORANGE_LIGHT, "VJ Base: ", VJ.COLOR_CLIENT, "Client files initialized!\n") else MsgC(VJ.COLOR_LOGO_ORANGE_LIGHT, "VJ Base: ", VJ.COLOR_SERVER, "Server files initialized!\n") end