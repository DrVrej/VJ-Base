/*--------------------------------------------------
	*** Copyright (c) 2012-2023 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.

	██    ██      ██     ██████   █████  ███████ ███████
	██    ██      ██     ██   ██ ██   ██ ██      ██
	██    ██      ██     ██████  ███████ ███████ █████
	 ██  ██  ██   ██     ██   ██ ██   ██      ██ ██
	  ████    █████      ██████  ██   ██ ███████ ███████

--------------------------------------------------*/
AddCSLuaFile()
if CLIENT then print("Loading VJ Base client files...") else print("Loading VJ Base server files...") end

local GetConVar = GetConVar
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Global Variables ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
VJBASE_VERSION = "2.17.0"

VJ_CVAR_IGNOREPLAYERS = GetConVar("ai_ignoreplayers"):GetInt() != 0
VJ_CVAR_AI_ENABLED = GetConVar("ai_disabled"):GetInt() != 1

-- NPC movement types
VJ_MOVETYPE_GROUND = 1
VJ_MOVETYPE_AERIAL = 2
VJ_MOVETYPE_AQUATIC = 3
VJ_MOVETYPE_STATIONARY = 4
VJ_MOVETYPE_PHYSICS = 5

-- NPC behavior types
VJ_BEHAVIOR_AGGRESSIVE = 1
VJ_BEHAVIOR_NEUTRAL = 2
VJ_BEHAVIOR_PASSIVE = 3
VJ_BEHAVIOR_PASSIVE_NATURE = 4

-- NPC AI states
VJ_STATE_NONE = 0 -- No state is set (Default)
VJ_STATE_FREEZE = 1 -- AI Completely freezes, basically applies Disable AI on the NPC (Including relationship system!)
VJ_STATE_ONLY_ANIMATION = 100 -- Only plays animation tasks, attacks. Disables: Movements, turning and other non-animation tasks!
VJ_STATE_ONLY_ANIMATION_CONSTANT = 101 -- Same as VJ_STATE_ONLY_ANIMATION + Idle animation will not play!
VJ_STATE_ONLY_ANIMATION_NOATTACK = 102 -- Same as VJ_STATE_ONLY_ANIMATION + Attacks will be disabled

-- These are finally defined in Garry's Mod itself, but unfortunately it requires an extra call, tests showed it's more optimized to call the ones below
COND_BEHIND_ENEMY = 29
COND_BETTER_WEAPON_AVAILABLE = 46
COND_CAN_MELEE_ATTACK1 = 23
COND_CAN_MELEE_ATTACK2 = 24
COND_CAN_RANGE_ATTACK1 = 21
COND_CAN_RANGE_ATTACK2 = 22
COND_ENEMY_DEAD = 30
COND_ENEMY_FACING_ME = 28
COND_ENEMY_OCCLUDED = 13
COND_ENEMY_TOO_FAR = 27
COND_ENEMY_UNREACHABLE = 31
COND_ENEMY_WENT_NULL = 12
COND_FLOATING_OFF_GROUND = 61
COND_GIVE_WAY = 48
COND_HAVE_ENEMY_LOS = 15
COND_HAVE_TARGET_LOS = 16
COND_HEALTH_ITEM_AVAILABLE = 47
COND_HEAR_BUGBAIT = 52
COND_HEAR_BULLET_IMPACT = 56
COND_HEAR_COMBAT = 53
COND_HEAR_DANGER = 50
COND_HEAR_MOVE_AWAY = 58
COND_HEAR_PHYSICS_DANGER = 57
COND_HEAR_PLAYER = 55
COND_HEAR_SPOOKY = 59
COND_HEAR_THUMPER = 51
COND_HEAR_WORLD = 54
COND_HEAVY_DAMAGE = 18
COND_IDLE_INTERRUPT = 2
COND_IN_PVS = 1
COND_LIGHT_DAMAGE = 17
COND_LOST_ENEMY = 11
COND_LOST_PLAYER = 33
COND_LOW_PRIMARY_AMMO = 3
COND_MOBBED_BY_ENEMIES = 62
COND_NEW_ENEMY = 26
COND_NO_CUSTOM_INTERRUPTS = 70
COND_NO_HEAR_DANGER = 60
COND_NO_PRIMARY_AMMO = 4
COND_NO_SECONDARY_AMMO = 5
COND_NO_WEAPON = 6
COND_NONE = 0
COND_NOT_FACING_ATTACK = 40
COND_NPC_FREEZE = 67
COND_NPC_UNFREEZE = 68
COND_PHYSICS_DAMAGE = 19
COND_PLAYER_ADDED_TO_SQUAD = 64
COND_PLAYER_PUSHING = 66
COND_PLAYER_REMOVED_FROM_SQUAD = 65
COND_PROVOKED = 25
COND_RECEIVED_ORDERS = 63
COND_REPEATED_DAMAGE = 20
COND_SCHEDULE_DONE = 36
COND_SEE_DISLIKE = 9
COND_SEE_ENEMY = 10
COND_SEE_FEAR = 8
COND_SEE_HATE = 7
COND_SEE_NEMESIS = 34
COND_SEE_PLAYER = 32
COND_SMELL = 37
COND_TALKER_RESPOND_TO_QUESTION = 69
COND_TARGET_OCCLUDED = 14
COND_TASK_FAILED = 35
COND_TOO_CLOSE_TO_ATTACK = 38
COND_TOO_FAR_TO_ATTACK = 39
COND_WAY_CLEAR = 49
COND_WEAPON_BLOCKED_BY_FRIEND = 42
COND_WEAPON_HAS_LOS = 41
COND_WEAPON_PLAYER_IN_SPREAD = 43
COND_WEAPON_PLAYER_NEAR_TARGET = 44
COND_WEAPON_SIGHT_OCCLUDED = 45
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ File Initialization ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- ====== Autorun ====== ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
AddCSLuaFile("autorun/vj_controls.lua")

	-- ====== Core ====== ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
AddCSLuaFile("vj_base/convars.lua")
AddCSLuaFile("vj_base/debug.lua")
AddCSLuaFile("vj_base/enums.lua")
AddCSLuaFile("vj_base/funcs.lua")
AddCSLuaFile("vj_base/hooks.lua")
AddCSLuaFile("vj_base/meta.lua")

include("vj_base/convars.lua")
include("vj_base/debug.lua")
include("vj_base/enums.lua")
include("vj_base/funcs.lua")
include("vj_base/hooks.lua")
include("vj_base/meta.lua")

 -- ====== Menu ====== ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
AddCSLuaFile("vj_base/menu/main.lua")
AddCSLuaFile("vj_base/menu/spawn.lua")
AddCSLuaFile("vj_base/menu/entity_configures.lua")
AddCSLuaFile("vj_base/menu/entity_properties.lua")

include("vj_base/menu/main.lua")
include("vj_base/menu/spawn.lua")
include("vj_base/menu/entity_configures.lua")
include("vj_base/menu/entity_properties.lua")

 -- ====== Resource ====== ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
AddCSLuaFile("vj_base/resource/localization.lua")
AddCSLuaFile("vj_base/resource/main.lua")
AddCSLuaFile("vj_base/resource/particles.lua")

include("vj_base/resource/localization.lua")
include("vj_base/resource/main.lua")
include("vj_base/resource/particles.lua")

	-- ====== Extension ====== ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
AddCSLuaFile("vj_base/extension/corpse.lua")
AddCSLuaFile("vj_base/extension/music.lua")

include("vj_base/extension/corpse.lua")
include("vj_base/extension/music.lua")

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
VJ.AddNPC("VJ Test NPC", "sent_vj_test", spawnCategory, true)
VJ.AddNPC_HUMAN("Player NPC", "npc_vj_test_humanply", {"weapon_vj_ak47","weapon_vj_glock17","weapon_vj_m16a1","weapon_vj_mp40","weapon_vj_9mmpistol","weapon_vj_357","weapon_vj_ar2","weapon_vj_blaster","weapon_vj_smg1","weapon_vj_spas12","weapon_vj_k3","weapon_vj_crossbow","weapon_vj_ssg08"}, spawnCategory)
	-- ====== Entities ====== ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
VJ.AddEntity("Admin Health Kit", "sent_vj_adminhealthkit", "DrVrej", true, 0, true, spawnCategory)
VJ.AddEntity("Player Spawnpoint", "sent_vj_ply_spawnpoint", "DrVrej", true, 0, true, spawnCategory)
VJ.AddEntity("Fireplace", "sent_vj_fireplace", "DrVrej", false, 0, true, spawnCategory)
VJ.AddEntity("Wooden Board", "sent_vj_board", "DrVrej", false, 0, true, spawnCategory)
VJ.AddEntity("Grenade", "obj_vj_grenade", "DrVrej", false, 0, true, spawnCategory)
VJ.AddEntity("Flare Round", "obj_vj_flareround", "DrVrej", false, 0, true, spawnCategory)
VJ.AddEntity("Flag", "prop_vj_flag", "DrVrej", false, 0, true, spawnCategory)
//VJ.AddEntity("HL2 Grenade", "npc_grenade_frag", "DrVrej", false, 50, true, spawnCategory)
//VJ.AddEntity("Supply Box", "item_dynamic_resupply", "DrVrej", false, 0, true, spawnCategory)
//VJ.AddEntity("Supply Crate", "item_ammo_crate", "DrVrej", false, 0, true, spawnCategory)
	-- ====== Weapons ====== ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
VJ.AddWeapon("AK-47", "weapon_vj_ak47", false, spawnCategory)
VJ.AddWeapon("Glock 17", "weapon_vj_glock17", false, spawnCategory)
VJ.AddWeapon("M16A1", "weapon_vj_m16a1", false, spawnCategory)
VJ.AddWeapon("MP 40", "weapon_vj_mp40", false, spawnCategory)
VJ.AddWeapon("9mm Pistol", "weapon_vj_9mmpistol", false, spawnCategory)
VJ.AddWeapon(".357 Magnum", "weapon_vj_357", false, spawnCategory)
VJ.AddWeapon("AR2", "weapon_vj_ar2", false, spawnCategory)
VJ.AddWeapon("Blaster", "weapon_vj_blaster", false, spawnCategory)
VJ.AddWeapon("VJ NPC Controller", "weapon_vj_npccontroller", false, spawnCategory)
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
//VJ.AddNPCWeapon("VJ_Package", "weapon_citizenpackage")
//VJ.AddNPCWeapon("VJ_Suitcase", "weapon_citizensuitcase")
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Main Hooks / Functions ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if SERVER then
	util.AddNetworkString("vj_welcome_msg")
	util.AddNetworkString("vj_meme")
	
	-- Initialize AI Schedule and Task systems
	require("vj_ai_schedule")
	
	-- Initialize AI Nodegraph system
	require("vj_ai_nodegraph")
	timer.Simple(1, function() -- To make sure world is initialized otherwise things like traces will return nil because "worldspawn" doesn't exist
		VJ_Nodegraph = vj_ai_nodegraph.New()
		-- If it failed to read the nodegraph, wait and try again in case nodegraph file hasn't generated yet
		if VJ_Nodegraph:GetNodegraph().Version == -1 then
			print("VJ Base AI Nodegraph module: Failed to read nodegraph, will attempt again soon...")
			timer.Simple(4, function()
				print("VJ Base AI Nodegraph module: Running second read attempt...")
				VJ_Nodegraph.Data = VJ_Nodegraph:ReadNodegraph()
				if VJ_Nodegraph:GetNodegraph().Version == -1 then
					print("VJ Base AI Nodegraph module: Second read attempt was failure, aborting!")
				else
					print("VJ Base AI Nodegraph module: Second read attempt was successful!")
				end
			end)
		end
	end)
elseif CLIENT then
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
		net.Start("vj_welcome_msg")
		net.Send(ply)
	end)
	
	if !game.SinglePlayer() && ply:SteamID() == "STEAM_0:0:22688298" then
		PrintMessage(HUD_PRINTTALK, "DrVrej Has Joined The Game!")
		PrintMessage(HUD_PRINTCENTER, "DrVrej Has Joined The Game!")
		local sd = CreateSound(game.GetWorld(), "vj_misc/illuminati_confirmed.mp3")
		sd:SetSoundLevel(0)
		sd:Play()
		timer.Simple(10, function() if sd then sd:Stop() end end)
	end
end)
---------------------------------------------------------------------------------------------------------------------------------------------
net.Receive("vj_meme", function(len, pl)
	if pl:IsPlayer() && pl:SteamID() == "STEAM_0:0:22688298" then
		PrintMessage(HUD_PRINTTALK, "DrVrej is in the server!")
		local sd = CreateSound(game.GetWorld(), "vj_misc/illuminati_confirmed.mp3")
		sd:SetSoundLevel(0)
		sd:Play()
	end
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Outdated GMod Version Check ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if SERVER && !isfunction(FindMetaTable("Entity").SetSurroundingBoundsType) then
	timer.Simple(1, function()
		if !VJBASE_ERROR_GAME_OUTDATED then
			VJBASE_ERROR_GAME_OUTDATED = true
			timer.Create("VJBASE_ERROR_GAME_OUTDATED", 2, 1, function()
				PrintMessage(HUD_PRINTTALK, "--- Outdated version of Garry's Mod detected! ---")
				PrintMessage(HUD_PRINTTALK, "Parts of VJ Base are now disabled! Expect errors & AI issues!")
				PrintMessage(HUD_PRINTTALK, "REASON: Game is running on an old version or is pirated!")
			end)
		end
	end)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ SLV Base Check ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if (SLVBase) then
	timer.Simple(1, function()
		if !VJBASE_ERROR_CONFLICT then
			VJBASE_ERROR_CONFLICT = true
			if CLIENT then
				chat.AddText(Color(255,100,0),"Confliction Detected!",
				Color(0,255,0)," VJ Base ",
				Color(255,255,255),"is being overridden by another addon!")
				chat.AddText(Color(0,200,200),"Incompatible Addons: http://steamcommunity.com/sharedfiles/filedetails/?id=1129493108")

				local frame = vgui.Create("DFrame")
				frame:SetSize(600, 200)
				frame:SetPos((ScrW() - frame:GetWide()) / 2, (ScrH() - frame:GetTall()) / 2)
				frame:SetTitle("VJ Base Error: Confliction Detected!")
				frame:SetBackgroundBlur(true)
				frame:MakePopup()
	
				local labelTitle = vgui.Create("DLabel", frame)
				labelTitle:SetPos(130, 30)
				labelTitle:SetText("CONFLICTION DETECTED!")
				labelTitle:SetFont("VJFont_Trebuchet24_Large")
				labelTitle:SetTextColor(Color(255,128,128))
				labelTitle:SizeToContents()
				
				local label1 = vgui.Create("DLabel", frame)
				label1:SetPos(70, 70)
				label1:SetText("VJ Base is being overridden by another addon!")
				label1:SetFont("VJFont_Trebuchet24_Medium")
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
				buttonClose:SetText("CLOSE")
				buttonClose:SetPos(260, 160)
				buttonClose:SetSize(80, 35)
				buttonClose.DoClick = function()
					frame:Close()
				end
			elseif SERVER then
				timer.Create("VJBASE_ERROR_CONFLICT", 5, 0, function()
					print("VJ Base is being overridden by another addon! Incompatible Addons: http://steamcommunity.com/sharedfiles/filedetails/?id=1129493108")
				end)
			end
		end
	end)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Backwards Compatibility ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- !!!!!!!!!!!!!! DO NOT USE THESE !!!!!!!!!!!!!! [Backwards Compatibility!]
VJ_PICK						= VJ.PICK
VJ_PICKRANDOMTABLE			= VJ.PICK
VJ_STOPSOUND				= VJ.STOPSOUND
VJ_Set						= VJ.SET
VJ_HasValue					= VJ.HasValue
VJ_RoundToMultiple			= VJ.RoundToMultiple
VJ_Color2Byte				= VJ.Color2Byte
VJ_FindInCone				= VJ.FindInCone
VJ_CreateSound				= VJ.CreateSound
VJ_EmitSound				= VJ.EmitSound
VJ_AnimationExists			= VJ.AnimExists
VJ_GetSequenceDuration		= VJ.AnimDuration
VJ_SequenceToActivity		= VJ.SequenceToActivity
VJ_IsCurrentAnimation		= VJ.IsCurrentAnimation
VJ_IsProp					= VJ.IsProp
VJ_IsAlive					= VJ.IsAlive
VJ_DestroyCombineTurret		= VJ.DamageSpecialEnts
util.VJ_SphereDamage		= VJ.ApplyRadiusDamage
-- !!!!!!!!!!!!!! DO NOT USE THESE !!!!!!!!!!!!!!
---------------------------------------------------------------------------------------------------------------------------------------------
if CLIENT then print("VJ Base client files initialized!") else print("VJ Base server files initialized!") end