/*--------------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/

-- Localized static values
local CurTime = CurTime
local IsValid = IsValid
local GetConVar = GetConVar
local tonumber = tonumber
local string_StartWith = string.StartWith
local table_remove = table.remove

local vj_npc_wep_ply_pickup = GetConVar("vj_npc_wep_ply_pickup")

---------------------------------------------------------------------------------------------------------------------------------------------
local entInfos = {
	-- Resistance NPCs
	npc_citizen = {classNPC = "CLASS_PLAYER_ALLY", func = function(ent)
		if ent:HasSpawnFlags(SF_CITIZEN_MEDIC) then -- Medic rebels
			ent.IsMedic = true
		end
		for key, val in pairs(ent:GetKeyValues()) do
			if key == "hostile" && val == 1 then -- Enemy / Combine Rebels
				return "CLASS_COMBINE"
			end
		end
	end},
	npc_vortigaunt = {classNPC = "CLASS_PLAYER_ALLY"},
	npc_monk = {classNPC = "CLASS_PLAYER_ALLY"},
	npc_dog = {classNPC = "CLASS_PLAYER_ALLY"},
	npc_barney = {classNPC = "CLASS_PLAYER_ALLY"},
	npc_alyx = {classNPC = "CLASS_PLAYER_ALLY"},
	npc_magnusson = {classNPC = "CLASS_PLAYER_ALLY", func = function(ent) ent.VJ_ID_Civilian = true end},
	npc_mossman = {classNPC = "CLASS_PLAYER_ALLY", func = function(ent) ent.VJ_ID_Civilian = true end},
	npc_kleiner = {classNPC = "CLASS_PLAYER_ALLY", func = function(ent) ent.VJ_ID_Civilian = true end},
	npc_fisherman = {classNPC = "CLASS_PLAYER_ALLY", func = function(ent) ent.VJ_ID_Civilian = true end},
	npc_eli = {classNPC = "CLASS_PLAYER_ALLY", func = function(ent) ent.VJ_ID_Civilian = true end},
	monster_barney = {classNPC = "CLASS_PLAYER_ALLY"},
	monster_scientist = {classNPC = "CLASS_PLAYER_ALLY", func = function(ent) ent.VJ_ID_Civilian = true end},
	monster_sitting_scientist = {classNPC = "CLASS_PLAYER_ALLY", func = function(ent) ent.VJ_ID_Civilian = true end},
	
	-- Combine NPCs
	npc_breen = {classNPC = "CLASS_COMBINE"},
	npc_combine_s = {classNPC = "CLASS_COMBINE"},
	npc_sniper = {classNPC = "CLASS_COMBINE"},
	npc_metropolice = {classNPC = "CLASS_COMBINE", func = function(ent) ent.VJ_ID_Police = true end},
	npc_stalker = {classNPC = "CLASS_COMBINE"},
	npc_strider = {classNPC = "CLASS_COMBINE", func = function(ent) ent.VJ_ID_Boss = true end},
	npc_hunter = {classNPC = "CLASS_COMBINE"},
	npc_cscanner = {classNPC = "CLASS_COMBINE", func = function(ent) ent.MovementType = VJ_MOVETYPE_AERIAL end},
	npc_clawscanner = {classNPC = "CLASS_COMBINE", func = function(ent) ent.MovementType = VJ_MOVETYPE_AERIAL end},
	npc_manhack = {classNPC = "CLASS_COMBINE", func = function(ent) ent.MovementType = VJ_MOVETYPE_AERIAL end},
	npc_apcdriver = {classNPC = "CLASS_COMBINE", func = function(ent) ent.VJ_ID_Vehicle = true ent.VJ_ID_Boss = true end},
	npc_combinedropship = {classNPC = "CLASS_COMBINE", func = function(ent) ent.VJ_ID_Vehicle = true ent.VJ_ID_Aircraft = true ent.VJ_ID_Boss = true ent.MovementType = VJ_MOVETYPE_AERIAL end},
	npc_combinegunship = {classNPC = "CLASS_COMBINE", func = function(ent) ent.VJ_ID_Vehicle = true ent.VJ_ID_Aircraft = true ent.VJ_ID_Boss = true ent.MovementType = VJ_MOVETYPE_AERIAL end},
	npc_helicopter = {classNPC = "CLASS_COMBINE", func = function(ent) ent.VJ_ID_Vehicle = true ent.VJ_ID_Aircraft = true ent.VJ_ID_Boss = true ent.MovementType = VJ_MOVETYPE_AERIAL end},
	npc_advisor = {classNPC = "CLASS_COMBINE", func = function(ent) ent.VJ_ID_Boss = true ent.MovementType = VJ_MOVETYPE_AERIAL end},
	npc_rollermine = {classNPC = "CLASS_COMBINE", func = function(ent)
		ent.CanBeEngaged = function(_, otherEnt, distance)
			return distance <= 256
		end
		if ent:HasSpawnFlags(262144) then -- Hacked rollermine (262144 = SF_ROLLERMINE_HACKED)
			return "CLASS_PLAYER_ALLY"
		elseif ent:HasSpawnFlags(SF_ROLLERMINE_FRIENDLY) then -- Harmless rollermine
			ent.Behavior = VJ_BEHAVIOR_PASSIVE_NATURE
		end
	end},
	npc_turret_ground = {classNPC = "CLASS_COMBINE", func = function(ent) ent.VJ_ID_Turret = true end},
	npc_turret_floor = {classNPC = "CLASS_COMBINE", func = function(ent)
		ent.VJ_ID_Turret = true
		if ent:HasSpawnFlags(SF_FLOOR_TURRET_CITIZEN) then -- Resistance turret
			return "CLASS_PLAYER_ALLY"
		end
	end},
	npc_turret_ceiling = {classNPC = "CLASS_COMBINE", func = function(ent) ent.VJ_ID_Turret = true end},
	npc_combine_camera = {classNPC = "CLASS_COMBINE"},
	npc_enemyfinder_combinecannon = {classNPC = "CLASS_COMBINE"},
	
	-- Zombie NPCs
	npc_zombie_torso = {classNPC = "CLASS_ZOMBIE"},
	npc_zombie = {classNPC = "CLASS_ZOMBIE"},
	npc_fastzombie = {classNPC = "CLASS_ZOMBIE"},
	npc_fastzombie_torso = {classNPC = "CLASS_ZOMBIE"},
	npc_poisonzombie = {classNPC = "CLASS_ZOMBIE"},
	npc_zombine = {classNPC = "CLASS_ZOMBIE"},
	npc_headcrab_fast = {classNPC = "CLASS_ZOMBIE", func = function(ent) ent.VJ_ID_Headcrab = true end},
	npc_headcrab_black = {classNPC = "CLASS_ZOMBIE", func = function(ent) ent.VJ_ID_Headcrab = true end},
	npc_headcrab_poison = {classNPC = "CLASS_ZOMBIE", func = function(ent) ent.VJ_ID_Headcrab = true end},
	npc_headcrab = {classNPC = "CLASS_ZOMBIE", func = function(ent) ent.VJ_ID_Headcrab = true end},
	monster_zombie = {classNPC = "CLASS_ZOMBIE"},
	monster_bigmomma = {classNPC = "CLASS_ZOMBIE", func = function(ent) ent.VJ_ID_Boss = true end},
	monster_headcrab = {classNPC = "CLASS_ZOMBIE", func = function(ent) ent.VJ_ID_Headcrab = true end},
	monster_babycrab = {classNPC = "CLASS_ZOMBIE", func = function(ent) ent.VJ_ID_Headcrab = true end},
	
	-- Antlion NPCs
	npc_antlion = {classNPC = "CLASS_ANTLION"},
	npc_antlionguard = {classNPC = "CLASS_ANTLION"},
	npc_antlion_worker = {classNPC = "CLASS_ANTLION"},
	npc_antlion_grub = {classNPC = "CLASS_ANTLION"},

	-- Xen NPCs
	npc_ichthyosaur = {classNPC = "CLASS_XEN"},
	monster_bullchicken = {classNPC = "CLASS_XEN"},
	monster_alien_grunt = {classNPC = "CLASS_XEN"},
	monster_alien_slave = {classNPC = "CLASS_XEN"},
	monster_alien_controller = {classNPC = "CLASS_XEN", func = function(ent) ent.MovementType = VJ_MOVETYPE_AERIAL end},
	monster_houndeye = {classNPC = "CLASS_XEN"},
	monster_gargantua = {classNPC = "CLASS_XEN", func = function(ent) ent.VJ_ID_Boss = true end},
	monster_nihilanth = {classNPC = "CLASS_XEN", func = function(ent) ent.VJ_ID_Boss = true ent.MovementType = VJ_MOVETYPE_AERIAL end},
	monster_tentacle = {classNPC = "CLASS_XEN"},
	monster_ichthyosaur = {classNPC = "CLASS_XEN", func = function(ent) ent.MovementType = VJ_MOVETYPE_AQUATIC end},
	monster_leech = {classNPC = "CLASS_XEN", func = function(ent) ent.MovementType = VJ_MOVETYPE_AQUATIC end},
	
	-- HECU NPCs
	monster_human_grunt = {classNPC = "CLASS_UNITED_STATES"},
	monster_sentry = {classNPC = "CLASS_UNITED_STATES", func = function(ent) ent.VJ_ID_Turret = true end},
	monster_apache = {classNPC = "CLASS_UNITED_STATES", func = function(ent) ent.VJ_ID_Vehicle = true ent.VJ_ID_Aircraft = true ent.VJ_ID_Boss = true ent.MovementType = VJ_MOVETYPE_AERIAL end},
	monster_osprey = {classNPC = "CLASS_UNITED_STATES", func = function(ent) ent.VJ_ID_Vehicle = true ent.VJ_ID_Aircraft = true ent.VJ_ID_Boss = true ent.MovementType = VJ_MOVETYPE_AERIAL end},
	
	-- Black Ops NPCs
	monster_human_assassin = {classNPC = "CLASS_BLACKOPS"},
	
	-- Portal NPCs
	npc_portal_turret_floor = {classNPC = "CLASS_APERTURE", func = function(ent) ent.VJ_ID_Turret = true end},
	npc_rocket_turret = {classNPC = "CLASS_APERTURE"},
	npc_security_camera = {classNPC = "CLASS_APERTURE"},
	npc_wheatley_boss = {classNPC = "CLASS_APERTURE", func = function(ent) ent.VJ_ID_Boss = true end},
	
	-- Hostile to all NPCs
	npc_barnacle = {func = function(ent)
		ent.CanBeEngaged = function(_, otherEnt, distance)
			if otherEnt.IsVJBaseSNPC_Human then
				return distance <= 800
			else
				return (otherEnt.HasRangeAttack && distance <= 800) or (distance <= math.max(otherEnt.MeleeAttackDamageDistance or 120))
			end
		end
	end},
	monster_barnacle = {func = function(ent)
		ent.CanBeEngaged = function(_, otherEnt, distance)
			if otherEnt.IsVJBaseSNPC_Human then
				return distance <= 800
			else
				return (otherEnt.HasRangeAttack && distance <= 800) or (distance <= math.max(otherEnt.MeleeAttackDamageDistance or 120))
			end
		end
	end},
	
	-- Nature NPCs (Passive animals)
	npc_crow = {func = function(ent) ent.Behavior = VJ_BEHAVIOR_PASSIVE_NATURE ent.MovementType = VJ_MOVETYPE_AERIAL end},
	npc_pigeon = {func = function(ent) ent.Behavior = VJ_BEHAVIOR_PASSIVE_NATURE ent.MovementType = VJ_MOVETYPE_AERIAL end},
	npc_seagull = {func = function(ent) ent.Behavior = VJ_BEHAVIOR_PASSIVE_NATURE ent.MovementType = VJ_MOVETYPE_AERIAL end},
	monster_cockroach = {func = function(ent) ent.Behavior = VJ_BEHAVIOR_PASSIVE_NATURE end},
	monster_flyer = {func = function(ent) ent.Behavior = VJ_BEHAVIOR_PASSIVE_NATURE ent.MovementType = VJ_MOVETYPE_AERIAL end},
}

local ignoredNPCs = {npc_cranedriver = true, npc_missiledefense = true, monster_generic = true, monster_furniture = true, npc_furniture = true, npc_helicoptersensor = true, monster_gman = true, npc_grenade_frag = true, bullseye_strider_focus = true, npc_bullseye = true, npc_enemyfinder = true, hornet = true}
local grenadeEnts = {npc_grenade_frag = true, grenade_hand = true, obj_spore = true, obj_grenade = true, obj_handgrenade = true, doom3_grenade = true, fas2_thrown_m67 = true, cw_grenade_thrown = true, obj_cpt_grenade = true, cw_flash_thrown = true, ent_hl1_grenade = true, rtbr_grenade_frag = true}
local grenadeGrabbableEnts = {npc_grenade_frag = true, obj_spore = true, obj_handgrenade = true, obj_cpt_grenade = true, cw_grenade_thrown = true, cw_flash_thrown = true, cw_smoke_thrown = true, ent_hl1_grenade = true, rtbr_grenade_frag = true}
local attackableEnts = {prop_physics = true, prop_physics_multiplayer = true, prop_physics_respawnable = true, func_breakable = true, func_physbox = true, prop_door_rotating = true, item_item_crate = true, prop_glados_core = true, weapon_striderbuster = true}
local destructibleEnts = {func_breakable_surf = true, sent_sakariashelicopter = true}
--
hook.Add("OnEntityCreated", "VJ_OnEntityCreated", function(ent)
	local entClass = ent:GetClass()
	local entInfo = entInfos[entClass]
	
	if ent:IsNPC() or ent:IsNextBot() then
		ent.VJ_ID_Living = true
		if SERVER && !ignoredNPCs[entClass] then
			local entIsVJ = ent.IsVJBaseSNPC
			if entIsVJ then
				ent.NextProcessT = CurTime() + math.Rand(0.15, 1)
			elseif entInfo then
				ent.IsDefaultNPC = true
			end
			-- Wait 0.1 seconds to make sure the NPC is initialized properly (key values, spawn flags, etc.)
			timer.Simple(0.1, function()
				if IsValid(ent) then
					if entIsVJ then
						if !ent.RelationshipEnts then ent.RelationshipEnts = {} end
						if !ent.RelationshipMemory then ent.RelationshipMemory = {} end
					-- Apply the appropriate class for non-VJ NPCs
					else
						local entInfoClass = false
						if entInfo then
							entInfoClass = entInfo.classNPC
							if entInfo.func then
								local classOverride = entInfo.func(ent)
								if classOverride then
									entInfoClass = classOverride
								end
							end
						end
						if !ent.VJ_NPC_Class && entInfoClass then
							ent.VJ_NPC_Class = {entInfoClass}
							if entInfoClass == "CLASS_PLAYER_ALLY" then
								ent.AlliedWithPlayerAllies = true
							end
						end
					end
					
					local cvSeePlys = !VJ_CVAR_IGNOREPLAYERS
					local entEneCount = 1
					local entIsNature = false
					if ent:IsNPC() && ent.Behavior == VJ_BEHAVIOR_PASSIVE_NATURE then
						entIsNature = true
					end
					for _, other in ipairs(ents.GetAll()) do
						if other.VJ_ID_Living && !ignoredNPCs[other:GetClass()] then
							-- Add enemies to the created entity if it's a VJ Base NPC
							if entIsVJ then
								ent:ValidateNoCollide(other)
								if (other:IsNPC() && entClass != other:GetClass() && other.Behavior != VJ_BEHAVIOR_PASSIVE_NATURE) or (other:IsPlayer() && cvSeePlys) or (other:IsNextBot()) then
									ent.RelationshipEnts[entEneCount] = other
									if !ent.RelationshipMemory[other] then ent.RelationshipMemory[other] = {} end
									entEneCount = entEneCount + 1
								end
							end
							-- Add the created entity to the list of possible enemies of existing VJ Base NPCs
							if !entIsNature && other.IsVJBaseSNPC && entClass != other:GetClass() then
								other.RelationshipEnts[#other.RelationshipEnts + 1] = ent
								if !other.RelationshipMemory[ent] then other.RelationshipMemory[ent] = {} end
							end
						end
					end
				end
			end)
		end
	else
		-- Run for server AND client to make sure the tags are shared!
		if grenadeEnts[entClass] then
			ent.VJ_ID_Grenade = true
			if grenadeGrabbableEnts[entClass] then
				ent.VJ_ID_Grabbable = true
			end
		end
		if attackableEnts[entClass] then
			ent.VJ_ID_Attackable = true
		end
		if destructibleEnts[entClass] or ent.IsScar then
			ent.VJ_ID_Destructible = true
		end
	end
end)
---------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("Initialize", "VJ_Initialize", function()
	RunConsoleCommand("sv_pvsskipanimation", "0") -- Fix attachments, bones, positions, angles etc. being broken in NPCs!
end)
---------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("PlayerSelectSpawn", "VJ_PlayerSelectSpawn", function(ply)
	local points = {}
	for _, sPoint in ipairs(ents.FindByClass("sent_vj_ply_spawn")) do
		if sPoint.Active then
			points[#points + 1] = sPoint
		end
	end
	local result = VJ.PICK(points)
	if result then
		return result
	end
end)
---------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("PlayerInitialSpawn", "VJ_PlayerInitialSpawn", function(ply)
	if IsValid(ply) then
		ply.VJ_ID_Living = true
		ply.VJ_ID_Healable = true
		ply.VJ_SD_InvestTime = 0
		ply.VJ_SD_InvestLevel = 0
		if SERVER then
			if !ply.VJ_NPC_Class then
				ply.VJ_NPC_Class = {"CLASS_PLAYER_ALLY"}
			end
			
			if !VJ_CVAR_IGNOREPLAYERS then
				for _, ent in ipairs(ents.GetAll()) do
					if ent:IsNPC() && ent.IsVJBaseSNPC then
						ent.RelationshipEnts[#ent.RelationshipEnts + 1] = ply
						ent.RelationshipMemory[ply] = {}
					end
				end
			end
			
			if !VJ_RecipientFilter then -- Just in case it wasn't created
				VJ_RecipientFilter = RecipientFilter()
			end
			VJ_RecipientFilter:AddAllPlayers()
		end
	end
end)
---------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("EntityEmitSound", "VJ_EntityEmitSound", function(data)
	local ent = data.Entity
	if IsValid(ent) then
		local isPly = ent:IsPlayer()
		local isNPC = ent:IsNPC()
		-- Investigate System
		if SERVER && (isPly or isNPC) && data.SoundLevel >= 75 then
			//print("---------------------------")
			//PrintTable(data)
			local quiet = (string_StartWith(data.OriginalSoundName, "player/footsteps") and (isPly && (ent:Crouching() or ent:KeyDown(IN_WALK)))) or false
			if quiet != true && ent.Dead != true then
				ent.VJ_SD_InvestTime = CurTime()
				ent.VJ_SD_InvestLevel = (data.SoundLevel * data.Volume) + (((data.Volume <= 0.4) and 15) or 0)
			end
		-- Disable the built-in footstep sounds for the player footstep sound for VJ NPCs unless specified otherwise
			-- Plays only on client-side, making it useless to play material-specific
		elseif isNPC && ent.IsVJBaseSNPC && (string.EndsWith(data.OriginalSoundName, "stepleft") or string.EndsWith(data.OriginalSoundName, "stepright")) then
			return ent:MatFootStepQCEvent(data)
		end
	end
end)
---------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("EntityFireBullets", "VJ_EntityFireBullets", function(ent, data)
	if IsValid(ent) && ent:IsNPC() && ent.IsVJBaseSNPC then
		local funcCustom = ent.OnFireBullet; if funcCustom then funcCustom(ent, data) end
	end
end)
---------------------------------------------------------------------------------------------------------------------------------------------
local function VJ_NPCPLY_DEATH(ent, attacker, inflictor)
	if ent != attacker && IsValid(attacker) && attacker.IsVJBaseSNPC then
		local wasLast = (!IsValid(attacker:GetEnemy()) or (attacker.EnemyData.VisibleCount <= 1))
		attacker:OnKilledEnemy(ent, inflictor, wasLast)
		-- If its the last enemy then --> (If there no valid enemy) OR (The number of enemies is 1 or less)
		if (!attacker.KilledEnemySoundLast) or (wasLast && attacker.KilledEnemySoundLast) then
			attacker:PlaySoundSystem("KilledEnemy")
		end
		attacker:MaintainRelationships()
	end
end
hook.Add("OnNPCKilled", "VJ_OnNPCKilled", VJ_NPCPLY_DEATH)
hook.Add("PlayerDeath", "VJ_PlayerDeath", function(victim, inflictor, attacker)
	VJ_NPCPLY_DEATH(victim, attacker, inflictor) -- Arguments are flipped between the hooks for some reason...
	
	-- Let allied VJ NPCs know that the player died
	for _, ent in ipairs(ents.FindInSphere(victim:GetPos(), 800)) do
		if ent.IsVJBaseSNPC && ent:Disposition(victim) == D_LI then
			ent:OnAllyKilled(victim)
			ent:PlaySoundSystem("AllyDeath")
		end
	end
end)
---------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("PlayerCanPickupWeapon", "VJ_PlayerCanPickupWeapon", function(ply, wep)
	if wep.IsVJBaseWeapon then
		if (CurTime() - wep.InitTime) < 0.15 then
			return true
		end
		return vj_npc_wep_ply_pickup:GetInt() == 1 && ply:KeyPressed(IN_USE) && ply:GetEyeTrace().Entity == wep
	end
end)
---------------------------------------------------------------------------------------------------------------------------------------------
if CLIENT then
	hook.Add("SpawnmenuIconMenuOpen", "VJ_SpawnmenuIconMenuOpen", function(menu, icon, contentType)
		if contentType == "npc" then
			//PrintTable(icon:GetTable())
			local NPCinfo = scripted_ents.Get(icon:GetSpawnName())
			if NPCinfo && (NPCinfo.IsVJBaseSNPC or NPCinfo.IsVJBaseSpawner) then
				//PrintTable(NPCinfo)
				menu:AddSpacer()
				menu:AddSpacer()
				menu:AddSpacer()
				menu:AddSpacer()
				menu:AddSpacer()
				
				local titleText = ""
				-- Add Information
				local entInfo = NPCinfo.Information
				if entInfo && entInfo != "" then
					titleText = entInfo .. "\n \n"
				end
				-- Add Author
				local entAuthor = NPCinfo.Author
				if entAuthor && entAuthor != "" then
					titleText = titleText .. "⁃ Author: " .. entAuthor .. "\n"
				end
				-- Add base type
				if NPCinfo.IsVJBaseSNPC_Creature then
					titleText = titleText .. "⁃ Base: Creature\n"
				elseif NPCinfo.IsVJBaseSNPC_Human then
					titleText = titleText .. "⁃ Base: Human\n"
				elseif NPCinfo.IsVJBaseSpawner then
					titleText = titleText .. "⁃ Base: Spawner\n"
				end
				-- Add parent (actual base)
				if NPCinfo.Base != "npc_vj_creature_base" && NPCinfo.Base != "npc_vj_human_base" && NPCinfo.Base != "obj_vj_spawner_base" then
					titleText = titleText .. "⁃ Parent: " .. NPCinfo.Base .. "\n"
				end
				-- Add weapons list
				if !table.IsEmpty(icon:GetNPCWeapon()) then
					titleText = titleText .. "⁃ Weapons (" .. #icon:GetNPCWeapon() .. "):\n  • " .. table.concat(icon:GetNPCWeapon(), "\n  • ")
				end
				local title = vgui.Create("RichText")
					title:SetText(titleText)
					//title:SetDark(true)
					//title:SetTextInset(10, 10)
					title:SetWrap(true)
					title:SetContentAlignment(7)
					title:SetTooltip("Entity's information")
					title:SetVerticalScrollbarEnabled(false)
					-- Wait until the internals of RichText have initialized
					function title:PerformLayout()
						if self:GetFont() != "VJBaseTinySmall" then self:SetFontInternal("VJBaseTinySmall") end
						self:SetFGColor(1, 1, 1, 255)
						
						surface.SetFont("VJBaseTinySmall")
						local textWidth = self:GetWide()
						local _, textHeight = surface.GetTextSize("hello") -- Get the height of the font (give a random text to calculate it)
						local lines = 0
						for word in string.gmatch(self:GetText(), "[^\n,]+") do
							local w = surface.GetTextSize(word) * 1.2
							textWidth = math.max(textWidth, w)
							lines = lines + 1
						end
						//print("textWidth", textWidth)
						self:SetSize(math.min(textWidth, 400), math.min((lines * textHeight) + 5, 200))
						local _, height = self:GetSize()
						if height >= 200 then
							self:SetVerticalScrollbarEnabled(true)
						end
					end
				menu:AddPanel(title)
				
				menu:AddSpacer()
				
				menu:AddOption("Open Documentation", function()
					gui.OpenURL("https://drvrej.com/" .. icon:GetSpawnName())
				end):SetIcon("icon16/help.png")
				
				menu:AddOption("Copy Name", function()
					SetClipboardText(icon.m_NiceName)
				end):SetIcon("icon16/tag_blue_add.png")
				
				menu:AddSpacer()
				
				menu:AddOption("Spawn a Squad", function()
					SetClipboardText(icon.m_NiceName)
				end):SetIcon("icon16/tag_blue_add.png")
				
				local ply = LocalPlayer()
				local wep = ply:GetWeapon("gmod_tool")
				if !IsValid(wep) then return end
				
				menu:AddOption("Select in NPC Spawner", function()
					RunConsoleCommand("vj_tool_spawner_spawnent", icon:GetSpawnName())
					timer.Simple(0.05, function() -- Otherwise it will not update the values in time
						local getPanel = controlpanel.Get("vj_tool_spawner")
						getPanel:Clear()
						ply:GetTool("vj_tool_spawner").BuildCPanel(getPanel)
					end)
				end):SetIcon("icon16/report_user.png")
				
				menu:AddOption("Quick add to NPC Spawner", function()
					RunConsoleCommand("vj_tool_spawner_spawnent", icon:GetSpawnName())
					if !table.IsEmpty(icon:GetNPCWeapon()) then
						local wepOverride = GetConVar("gmod_npcweapon"):GetString()
						RunConsoleCommand("vj_tool_spawner_weaponequip", wepOverride == "" and "Default" or wepOverride)
					end
					RunConsoleCommand("vj_tool_spawner_update")
					RunConsoleCommand("vj_tool_spawner_spawnent", "None")
					RunConsoleCommand("vj_tool_spawner_weaponequip", "None")
				end):SetIcon("icon16/user_go.png")
			end
		end
	end)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Convar Callbacks ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
cvars.AddChangeCallback("ai_ignoreplayers", function(name, oldValue, newValue)
	if tonumber(newValue) == 0 then -- Turn off ignore players
		VJ_CVAR_IGNOREPLAYERS = false
		if SERVER then
			local getPlys = player.GetAll()
			local getAll = ents.GetAll()
			for x = 1, #getAll do
				local ent = getAll[x]
				if ent:IsNPC() && ent.IsVJBaseSNPC then
					for _, ply in ipairs(getPlys) do
						ent.RelationshipEnts[#ent.RelationshipEnts + 1] = ply
						if !ent.RelationshipMemory[ply] then
							ent.RelationshipMemory[ply] = {}
						end
					end
				end
			end
		end
	else -- Turn on ignore players
		VJ_CVAR_IGNOREPLAYERS = true
		if SERVER then
			for _, ent in ipairs(ents.GetAll()) do
				if ent.IsVJBaseSNPC then
					if ent.IsFollowing && ent.FollowData.Target:IsPlayer() then ent:ResetFollowBehavior() end -- Reset the NPC's follow system if it's following a player
					local relationEnts = ent.RelationshipEnts
					//local relationData = ent.RelationshipMemory -- Keep the relationship data
					local it = 1
					while it <= #relationEnts do
						local relationEnt = relationEnts[it]
						if IsValid(relationEnt) && relationEnt:IsPlayer() then
							ent:AddEntityRelationship(relationEnt, D_NU, 10) -- Make the player neutral
							-- Reset the NPC's enemy if it's a player
							if IsValid(ent:GetEnemy()) && ent:GetEnemy() == relationEnt then
								ent:ResetEnemy()
							end
							table_remove(relationEnts, it) -- Remove the player from possible enemy table
							//relationData[relationEnt] = nil
						else
							it = it + 1
						end
					end
				end
			end
		end
	end
end)
---------------------------------------------------------------------------------------------------------------------------------------------
cvars.AddChangeCallback("ai_disabled", function(name, oldValue, newValue)
	VJ_CVAR_AI_ENABLED = tonumber(newValue) != 1
end)