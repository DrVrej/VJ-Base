/*--------------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
local defFlags = FCVAR_ARCHIVE
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Admin Settings ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CreateConVar("vj_npc_admin_properties", 0, defFlags, "Should the NPC properties menu be restricted to admins only?")
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ NPC Attack & Weapon Settings ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CreateConVar("vj_npc_range", 1, defFlags, "Can NPCs do range attacks?")
CreateConVar("vj_npc_leap", 1, defFlags, "Can NPCs do leap attacks?")
CreateConVar("vj_npc_melee", 1, defFlags, "Can NPCs do melee attacks?")
CreateConVar("vj_npc_melee_bleed", 1, defFlags, "Can NPCs deal bleeding to enemies on melee attack?")
CreateConVar("vj_npc_melee_propint", 1, defFlags, "Can NPCs damage or push props?")
CreateConVar("vj_npc_melee_ply_dsp", 1, defFlags, "Can NPC melee attacks cause DSP effects on players?")
CreateConVar("vj_npc_melee_ply_speed", 1, defFlags, "Can NPC melee attack modify player speed?")
CreateConVar("vj_npc_grenade", 1, defFlags, "Can NPCs do grenade attacks?")
CreateConVar("vj_npc_wep", 1, defFlags, "Can NPCs use weapons?")
CreateConVar("vj_npc_wep_reload", 1, defFlags, "Can NPCs reload their weapon?")
CreateConVar("vj_npc_wep_drop", 1, defFlags, "Should NPCs drop their weapon on death?")
CreateConVar("vj_npc_wep_ply_pickup", 1, defFlags, "Can players pick up NPC dropped weapons?")
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ NPC AI Settings ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CreateConVar("vj_npc_sight_distance", 0, defFlags, "Override all NPCs to use the set number as their sight distance | 0 = Don't override")
CreateConVar("vj_npc_sight_xray", 0, defFlags, "Should they have X-Ray vision with 360 FOV?")
CreateConVar("vj_npc_wander", 1, defFlags, "Can NPCs wander around?")
CreateConVar("vj_npc_chase", 1, defFlags, "Can NPCs chase enemies?")
CreateConVar("vj_npc_flinch", 1, defFlags, "Can NPCs play their flinch animations?")
CreateConVar("vj_npc_investigate", 1, defFlags, "Can NPCs detect and investigate disturbances?")
CreateConVar("vj_npc_callhelp", 1, defFlags, "Can NPCs call for help?")
CreateConVar("vj_npc_ply_follow", 1, defFlags, "Can NPCs follow players?")
CreateConVar("vj_npc_medic", 1, defFlags, "Can NPCs be medics?")
CreateConVar("vj_npc_eat", 1, defFlags, "Can NPCs eat things like corpses or gibs?")
CreateConVar("vj_npc_dangerdetection", 1, defFlags, "Can NPCs run from grenades/dangers")
CreateConVar("vj_npc_human_jump", 1, defFlags, "Can the human NPCs jump?")
CreateConVar("vj_npc_creature_opendoor", 1, defFlags, "Should Creatures open doors?")
CreateConVar("vj_npc_allies", 1, defFlags, "Can NPCs ally with other entities?")
CreateConVar("vj_npc_ply_betray", 1, defFlags, "Can friendly NPCs become enemy to allied players?")
CreateConVar("vj_npc_fri_base", 0, defFlags, "Makes all VJ NPCs friendly to other VJ NPCs")
CreateConVar("vj_npc_fri_player", 0, defFlags, "Makes all VJ NPCs friendly to Players")
CreateConVar("vj_npc_fri_zombie", 0, defFlags, "Makes all VJ NPCs friendly to Zombies")
CreateConVar("vj_npc_fri_antlion", 0, defFlags, "Makes all VJ NPCs friendly to Antlion")
CreateConVar("vj_npc_fri_combine", 0, defFlags, "Makes all VJ NPCs friendly to Combine")
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ General Settings ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CreateConVar("vj_npc_difficulty", 0, defFlags, "Difficulty of all NPCs")
CreateConVar("vj_npc_anim_death", 1, defFlags, "Can NPCs play death animation?")
CreateConVar("vj_npc_god", 0, defFlags, "Can NPCs take damage?")
CreateConVar("vj_npc_health", 0, defFlags, "Overrides the health of all NPCs | 0 = Don't override")
CreateConVar("vj_npc_blood", 1, defFlags, "Can NPCs bleed?")
CreateConVar("vj_npc_blood_pool", 1, defFlags, "Can corpses create blood pools?")
CreateConVar("vj_npc_blood_gmod", 0, defFlags, "Should Garry's Mod's blood decals be used whenever possible?")
CreateConVar("vj_npc_corpse", 1, defFlags, "Can NPCs create corpses?")
CreateConVar("vj_npc_corpse_limit", 32, defFlags, "What is the limit for NPC corpses on the ground? (When Keep Corpses is off)")
CreateConVar("vj_npc_corpse_collision", 0, defFlags, "Collision type for the NPC's corpse")
CreateConVar("vj_npc_corpse_fade", 0, defFlags, "Should NPC corpses fade?")
CreateConVar("vj_npc_corpse_fadetime", 10, defFlags, "Time until NPC corpses fade")
CreateConVar("vj_npc_corpse_undo", 0, defFlags, "Should corpses be undoable?")
CreateConVar("vj_npc_gib", 1, defFlags, "Can NPCs gib?")
CreateConVar("vj_npc_gib_vfx", 1, defFlags, "Can Gib VFX be created? | EX: particles, effects, decals, etc.")
CreateConVar("vj_npc_gib_collision", 0, defFlags, "Should gibs be collidable?")
CreateConVar("vj_npc_gib_fade", 1, defFlags, "Should Gibs Fade?")
CreateConVar("vj_npc_gib_fadetime", 90, defFlags, "Time until gibs fade out")
CreateConVar("vj_npc_loot", 1, defFlags, "Can NPCs drop loot on death?")
CreateConVar("vj_npc_ply_frag", 1, defFlags, "Disable frags (points) being added to player's scoreboard when a player kills an NPC")
CreateConVar("vj_npc_ply_chat", 1, defFlags, "Can NPC post in a player's chat? | EX: \"Scientist is now following you\"")
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ NPC Performance Settings ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CreateConVar("vj_npc_processtime", 1, defFlags, "How often does the NPC do performance-heavy processing?")
CreateConVar("vj_npc_poseparams", 1, defFlags, "Can NPCs have pose parameters?")
CreateConVar("vj_npc_shadows", 1, defFlags, "Should NPC shadows draw?")
CreateConVar("vj_npc_ikchains", 1, defFlags, "Can NPCs have IK chains?")
CreateConVar("vj_npc_forcelowlod", 0, defFlags, "Should NPCs be forced to use the lowest LOD?")
CreateConVar("vj_npc_reduce_vfx", 0, defFlags, "Reduces VFX, especially non-essential ones | EX: Eye glow, idle particles")
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ NPC Sound Settings ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CreateConVar("vj_npc_snd", 1, defFlags, "Can NPCs play sounds?")
CreateConVar("vj_npc_snd_track", 1, defFlags, "Can NPCs play soundtracks?")
CreateConVar("vj_npc_snd_idle", 1, defFlags, "Can NPCs play idle sounds?")
CreateConVar("vj_npc_snd_breath", 1, defFlags, "Can NPCs play breathing sounds?")
CreateConVar("vj_npc_snd_alert", 1, defFlags, "Can NPCs play alert sounds?")
CreateConVar("vj_npc_snd_pain", 1, defFlags, "Can NPCs play hurt sounds?")
CreateConVar("vj_npc_snd_death", 1, defFlags, "Can NPCs play death sounds?")
CreateConVar("vj_npc_snd_footstep", 1, defFlags, "Can NPCs play footstep sounds?")
CreateConVar("vj_npc_snd_melee", 1, defFlags, "Can NPCs play melee attack sounds?")
CreateConVar("vj_npc_snd_plyspeed", 1, defFlags, "Can NPCs play melee attack player speed modifier sounds?")
CreateConVar("vj_npc_snd_range", 1, defFlags, "Can NPCs play range Attack sounds?")
CreateConVar("vj_npc_snd_leap", 1, defFlags, "Can NPCs play leap Attack sounds?")
CreateConVar("vj_npc_snd_grenade", 1, defFlags, "Can NPCs play grenade attack sounds?")
CreateConVar("vj_npc_snd_gib", 1, defFlags, "Can NPCs play gib / dismemberment sounds?")
CreateConVar("vj_npc_snd_plyfollow", 1, defFlags, "Can NPCs play player follow and unfollow sounds?")
CreateConVar("vj_npc_snd_plybetrayal", 1, defFlags, "Can NPCs play player betrayal sounds?")
CreateConVar("vj_npc_snd_plysight", 1, defFlags, "Can NPCs play player sight sounds?")
CreateConVar("vj_npc_snd_plydamage", 1, defFlags, "Can NPCs play damage by player sounds?")
CreateConVar("vj_npc_snd_medic", 1, defFlags, "Can NPCs play medic sounds?")
CreateConVar("vj_npc_snd_callhelp", 1, defFlags, "Can NPCs play call for help sounds?")
CreateConVar("vj_npc_snd_receiveorder", 1, defFlags, "Can NPCs play on receive order sounds? | EX: When called to come help an ally")
CreateConVar("vj_npc_snd_danger", 1, defFlags, "Can NPCs play grenade and danger sight sounds?")
CreateConVar("vj_npc_snd_wep_reload", 1, defFlags, "Can NPCs play weapon reload call out sounds?")
CreateConVar("vj_npc_snd_wep_suppressing", 1, defFlags, "Can NPCs play suppressing callout sounds?")
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ NPC Developer Settings ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CreateConVar("vj_npc_debug", 0, FCVAR_NONE, "Enables NPC debugging mode | Required for other debug convars to work!")
CreateConVar("vj_npc_debug_engine", 0, defFlags, "Enables engine debugging")
CreateConVar("vj_npc_debug_attack", 0, defFlags, "Enables attack debugging")
CreateConVar("vj_npc_debug_damage", 0, defFlags, "Enables damage & death debugging")
CreateConVar("vj_npc_debug_touch", 0, defFlags, "Prints when something collides with an NPC")
CreateConVar("vj_npc_debug_enemy", 0, defFlags, "Enables enemy debugging")
CreateConVar("vj_npc_debug_resetenemy", 0, defFlags, "Prints whenever an NPC has rest its enemy")
CreateConVar("vj_npc_debug_lastseenenemytime", 0, defFlags, "Prints the value of \"LastSeenEnemy\"")
CreateConVar("vj_npc_debug_takingcover", 0, defFlags, "Prints whether an NPC is taking cover or not")
CreateConVar("vj_npc_debug_weapon", 0, defFlags, "Enables weapon debugging")
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ NPC Controller Settings ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
VJ.AddClientConVar("vj_npc_cont_hud", 1, "Display HUD when controlling NPCs")
VJ.AddClientConVar("vj_npc_cont_cam_zoom_dist", 5, "Distance that the zoom moves between each interval")
VJ.AddClientConVar("vj_npc_cont_cam_zoom_speed", 10, "How fast the camera zooms in & out")
VJ.AddClientConVar("vj_npc_cont_cam_speed", 6, "How fast the camera moves (lerping)")
VJ.AddClientConVar("vj_npc_cont_debug", 0, "Display developer entities")
VJ.AddClientConVar("vj_npc_cont_diewithnpc", 0, "Player should die with the NPC (Requires respawn!)")
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ NPC Client Settings ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
VJ.AddClientConVar("vj_npc_spawn_guard", 0, "Spawn all VJ NPCs with guarding behavior enabled", 0, 1, false)
VJ.AddClientConVar("vj_npc_snd_track_volume", 1, "Overrides the volume of all NPC soundtracks | 1 = Don't override (100%) | 0.5 = 50% | 3 = 300%", 0, 5)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Weapon Client Settings ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
VJ.AddClientConVar("vj_wep_muzzleflash", 1, "Should weapons make a muzzle flash?")
VJ.AddClientConVar("vj_wep_muzzleflash_light", 1, "Should weapons make a dynamic light when being fired?")
VJ.AddClientConVar("vj_wep_shells", 1, "Should weapons drop bullet shells?")
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Console Commands ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if SERVER then
	concommand.Add("vj_run_npc_num", function(ply, cmd, args)
		if IsValid(ply) && ply:IsAdmin() then
			local numNPC = 0
			local numVJ = 0
			local numNextBot = 0
			for _, v in ipairs(ents.GetAll()) do
				if v:IsNPC() then
					numNPC = numNPC + 1
					if v.IsVJBaseSNPC then
						numVJ = numVJ + 1
					end
				elseif v:IsNextBot() then
					numNextBot = numNextBot + 1
				end
			end
			ply:ChatPrint("Total NPCs: " .. numNPC .. " | VJ NPCs: " .. numVJ .. " | NextBots: " .. numNextBot)
		end
	end, nil, "Prints the number of NPCs in the map. It's admin only!", FCVAR_DONTRECORD)
	---------------------------------------------------------------------------------------------------------------------------------------------
	local cTypes = {
		vjnpcs = "VJ NPCs",
		npcs = "NPCs",
		spawners = "Spawners",
		corpses = "Corpses",
		gibs = "Gibs",
		groundweapons = "Ground Weapons",
		props = "Props",
		decals = "Removed All Decals",
		allweapons = "Removed All Your Weapons",
		allammo = "Removed All Your Ammo",
	}
	concommand.Add("vj_run_cleanup", function(ply, cmd, args)
		if IsValid(ply) && !ply:IsAdmin() then return end
		local cType = args[1]
		local i = 0
		if !cType then -- Not type given, so it means its a clean up all!
			game.CleanUpMap()
		elseif cType == "decals" then
			for _, v in ipairs(player.GetAll()) do
				v:ConCommand("r_cleardecals")
			end
		elseif IsValid(ply) && cType == "allweapons" then
			ply:StripWeapons()
		elseif IsValid(ply) && cType == "allammo" then
			ply:RemoveAllAmmo()
		else
			for _, v in ipairs(ents.GetAll()) do
				if (v:IsNPC() && (cType == "npcs" or (cType == "vjnpcs" && v.IsVJBaseSNPC))) or (cType == "spawners" && v.IsVJBaseSpawner) or (cType == "corpses" && (v.IsVJBaseCorpse or v.IsVJBaseCorpse_Gib)) or (cType == "gibs" && v.IsVJBaseCorpse_Gib) or (cType == "groundweapons" && v:IsWeapon() && v:GetOwner() == NULL) or (cType == "props" && v:GetClass() == "prop_physics" && (v:GetParent() == NULL or (IsValid(v:GetParent()) && v:GetParent():Health() <= 0 && (v:GetParent():IsNPC() or v:GetParent():IsPlayer())))) then
					//undo.ReplaceEntity(v, NULL)
					v:Remove()
					i = i + 1
				end
			end
			-- Clean up client side corpses
			-- DOES NOT WORK, FUNCTION IS BROKEN!
			//if cType == "corpses" then
				//game.RemoveRagdolls()
			//end
		end
		if IsValid(ply) then
			if !cType then
				ply:SendLua("GAMEMODE:AddNotify(\"Cleaned Up Everything!\", NOTIFY_CLEANUP, 5)")
			elseif cType == "decals" or cType == "allweapons" or cType == "allammo" then
				ply:SendLua("GAMEMODE:AddNotify(\"" .. cTypes[cType] .. "\", NOTIFY_CLEANUP, 5)")
			else
				ply:SendLua("GAMEMODE:AddNotify(\"Removed " .. i .. " " .. cTypes[cType] .. "\", NOTIFY_CLEANUP, 5)")
			end
			ply:EmitSound("buttons/button15.wav")
		end
	end, nil, "Used to cleanup various things in the map. It's admin only!", FCVAR_DONTRECORD)
	---------------------------------------------------------------------------------------------------------------------------------------------
elseif CLIENT then
	concommand.Add("vj_run_meme", function(ply, cmd, args)
		if ply:SteamID() == "STEAM_0:0:22688298" then
			net.Start("vj_meme_sv")
				net.WriteUInt(tonumber(args[1]) or 0, 1)
			net.SendToServer()
		end
	end, nil, "Used by DrVrej for friend servers.", FCVAR_DONTRECORD)
end