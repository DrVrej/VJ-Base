/*--------------------------------------------------
	*** Copyright (c) 2012-2024 by DrVrej, All rights reserved. ***
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
---------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("Initialize", "VJ_Initialize", function()
	RunConsoleCommand("sv_pvsskipanimation", "0") -- Fix attachments, bones, positions, angles etc. being broken in NPCs!
end)
---------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("PhysgunPickup", "VJ_PhysgunPickup", function(ply, ent)
	if ent:GetClass() == "sent_vj_ply_spawnpoint" then
		return ply:IsAdmin()
	end
end)
---------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("PlayerSelectSpawn", "VJ_PlayerSelectSpawn", function(ply)
	local points = {}
	for _,v in ipairs(ents.FindByClass("sent_vj_ply_spawnpoint")) do
		if (v.Active == true) then
			points[#points + 1] = v
		end
	end
	local result = VJ.PICK(points)
	if result != false then
		return result
	end
end)
---------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("PlayerSpawnedNPC", "VJ_PlayerSpawnedNPC", function(ply, ent)
	if ent.IsVJBaseSNPC or ent.IsVJBaseSpawner then
		ent:SetCreator(ply)
	end
end)
---------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("PlayerInitialSpawn", "VJ_PlayerInitialSpawn", function(ply)
	if IsValid(ply) then
		ply.VJ_LastInvestigateSd = 0
		ply.VJ_LastInvestigateSdLevel = 0
		if !VJ_CVAR_IGNOREPLAYERS then
			local entsTbl = ents.GetAll()
			for x = 1, #entsTbl do
				local v = entsTbl[x]
				if v:IsNPC() && v.IsVJBaseSNPC == true then
					v.CurrentPossibleEnemies[#v.CurrentPossibleEnemies+1] = ply
				end
			end
		end
	end
end)
---------------------------------------------------------------------------------------------------------------------------------------------
local NPCTbl_Resistance = {npc_magnusson=true,npc_vortigaunt=true,npc_mossman=true,npc_monk=true,npc_kleiner=true,npc_fisherman=true,npc_eli=true,npc_dog=true,npc_barney=true,npc_alyx=true,npc_citizen=true,monster_scientist=true,monster_barney=true}

local ignoreEnts = {monster_generic=true, monster_furniture=true, npc_furniture=true, monster_gman=true, npc_grenade_frag=true, bullseye_strider_focus=true, npc_bullseye=true, npc_enemyfinder=true, hornet=true}
local grenadeEnts = {npc_grenade_frag=true,grenade_hand=true,obj_spore=true,obj_grenade=true,obj_handgrenade=true,doom3_grenade=true,fas2_thrown_m67=true,cw_grenade_thrown=true,obj_cpt_grenade=true,cw_flash_thrown=true,ent_hl1_grenade=true}
local grenadeThrowBackEnts = {npc_grenade_frag=true,obj_spore=true,obj_handgrenade=true,obj_cpt_grenade=true,cw_grenade_thrown=true,cw_flash_thrown=true,cw_smoke_thrown=true,ent_hl1_grenade=true}
--
hook.Add("OnEntityCreated", "VJ_OnEntityCreated", function(ent)
	local entClass = ent:GetClass()
	if SERVER && ent:IsNPC() && !ignoreEnts[entClass] then
		local isVJ = ent.IsVJBaseSNPC
		if isVJ then
			ent.NextProcessT = CurTime() + math.Rand(0.15, 1)
		else
			-- Set the tags for default player allies
			if NPCTbl_Resistance[entClass] then
				ent.PlayerFriendly = true
				ent.FriendsWithAllPlayerAllies = true
			end
		end
		timer.Simple(0.1, function() -- Make sure the NPC is initialized properly
			if IsValid(ent) then
				if isVJ == true && ent.CurrentPossibleEnemies == nil then ent.CurrentPossibleEnemies = {} end
				local entsTbl = ents.GetAll()
				local count = 1
				local cvSeePlys = !VJ_CVAR_IGNOREPLAYERS
				local isPossibleEnemy = ((ent:IsNPC() && ent:Health() > 0 && (ent.Behavior != VJ_BEHAVIOR_PASSIVE_NATURE)) or (ent:IsPlayer()))
				for x = 1, #entsTbl do
					local v = entsTbl[x]
					if (v:IsNPC() or v:IsPlayer()) && !ignoreEnts[v:GetClass()] then
						-- Add enemies to the created entity (if it's a VJ Base SNPC)
						if isVJ == true then
							ent:EntitiesToNoCollideCode(v)
							if (v:IsNPC() && (v:GetClass() != entClass && (v.Behavior != VJ_BEHAVIOR_PASSIVE_NATURE)) && v:Health() > 0) or (v:IsPlayer() && cvSeePlys /*&& v:Alive()*/) then
								ent.CurrentPossibleEnemies[count] = v
								count = count + 1
							end
						end
						-- Add the created entity to the list of possible enemies of VJ Base SNPCs
						if isPossibleEnemy && entClass != v:GetClass() && v.IsVJBaseSNPC then
							v.CurrentPossibleEnemies[#v.CurrentPossibleEnemies+1] = ent //v.CurrentPossibleEnemies = v:DoHardEntityCheck(getall)
						end
					end
				end
			end
		end)
	end
	-- Make this portion run for server AND client to make sure the tags are shared!
	if grenadeEnts[entClass] then
		ent.VJTag_ID_Grenade = true
		if grenadeThrowBackEnts[entClass] then
			ent.VJTag_IsPickupable = true
		end
	end
end)

/*
-- Retrieving outputs from NPCs or other entities | Outputs: https://developer.valvesoftware.com/wiki/Base.fgd/Garry%27s_Mod
local triggerLua = ents.Create("lua_run")
triggerLua:SetName("triggerhook")
triggerLua:Spawn()

hook.Add("OnEntityCreated", "VJ_OnEntityCreated", function(ent)
	if ent:IsNPC() && ent.IsVJBaseSNPC == true then
		-- Format: <output name> <targetname>:<inputname>:<parameter>:<delay>:<max times to fire, -1 means infinite>
		self:Fire("AddOutput", "OnIgnite triggerhook:RunPassedCode:hook.Run( 'OnOutput' ):0:-1")
	end
end)

hook.Add("OnOutput", "OnOutput", function()
	local activator, caller = ACTIVATOR, CALLER
	print(activator, caller)
end )
*/
---------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("EntityEmitSound", "VJ_EntityEmitSound", function(data)
	local ent = data.Entity
	if IsValid(ent) then
		-- Investigate System
		if SERVER && (ent:IsPlayer() or ent:IsNPC()) && data.SoundLevel >= 75 then
			//print("---------------------------")
			//PrintTable(data)
			local quiet = (string_StartWith(data.OriginalSoundName, "player/footsteps") and (ent:IsPlayer() && (ent:Crouching() or ent:KeyDown(IN_WALK)))) or false
			if quiet != true && ent.Dead != true then
				ent.VJ_LastInvestigateSd = CurTime()
				ent.VJ_LastInvestigateSdLevel = (data.SoundLevel * data.Volume) + (((data.Volume <= 0.4) and 15) or 0)
			end
		-- Disable the built-in footstep sounds for the player footstep sound for VJ NPCs unless specified otherwise
			-- Plays only on client-side, making it useless to play material-specific
		elseif ent:IsNPC() && ent.IsVJBaseSNPC == true && (string.EndsWith(data.OriginalSoundName, "stepleft") or string.EndsWith(data.OriginalSoundName, "stepright")) then
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
hook.Add("EntityTakeDamage", "VJ_EntityTakeDamage", function(target, dmginfo)
	local attacker = dmginfo:GetAttacker()
	if IsValid(target) && target.IsVJBaseSNPC && IsValid(attacker) && attacker:IsNPC() && dmginfo:IsBulletDamage() && attacker:Disposition(target) != D_HT && (attacker:GetClass() == target:GetClass() or target:Disposition(attacker) == D_LI) then
		dmginfo:SetDamage(0)
	end
end)
---------------------------------------------------------------------------------------------------------------------------------------------
local function VJ_NPCPLY_DEATH(npc, attacker, inflictor)
	if IsValid(attacker) && attacker.IsVJBaseSNPC == true then
		attacker:DoKilledEnemy(npc, attacker, inflictor)
		attacker:MaintainRelationships()
	end
end
hook.Add("OnNPCKilled", "VJ_OnNPCKilled", VJ_NPCPLY_DEATH)
hook.Add("PlayerDeath", "VJ_PlayerDeath", function(victim, inflictor, attacker)
	VJ_NPCPLY_DEATH(victim, attacker, inflictor) -- Arguments are flipped between the hooks for some reason...
	
	-- Let allied SNPCs know that the player died
	for _,v in ipairs(ents.FindInSphere(victim:GetPos(), 400)) do
		if v.IsVJBaseSNPC == true && v:Disposition(victim) == D_LI then
			v:CustomOnAllyDeath(victim)
			v:PlaySoundSystem("AllyDeath")
		end
	end
end)
---------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("PlayerCanPickupWeapon", "VJ_PlayerCanPickupWeapon", function(ply, wep)
	if wep.IsVJBaseWeapon then
		if (CurTime() - wep.InitTime) < 0.15 then
			return true
		end
		return GetConVar("vj_npc_plypickupdropwep"):GetInt() == 1 && ply:KeyPressed(IN_USE) && ply:GetEyeTrace().Entity == wep
	end
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Convar Callbacks ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
cvars.AddChangeCallback("ai_ignoreplayers", function(convar_name, oldValue, newValue)
	if tonumber(newValue) == 0 then -- Turn off ignore players
		VJ_CVAR_IGNOREPLAYERS = false
		local getPlys = player.GetAll()
		local getAll = ents.GetAll()
		for x = 1, #getAll do
			local v = getAll[x]
			if v:IsNPC() && v.IsVJBaseSNPC then
				for _, ply in ipairs(getPlys) do
					v.CurrentPossibleEnemies[#v.CurrentPossibleEnemies + 1] = ply
				end
			end
		end
	else -- Turn on ignore players
		VJ_CVAR_IGNOREPLAYERS = true
		for _, v in ipairs(ents.GetAll()) do
			if v.IsVJBaseSNPC then
				if v.FollowingPlayer == true then v:FollowReset() end -- Reset the NPC's follow system if it's following a player
				//v.CurrentPossibleEnemies = v:DoHardEntityCheck(getall)
				local posEnemies = v.CurrentPossibleEnemies
				local it = 1
				while it <= #posEnemies do
					local x = posEnemies[it]
					if IsValid(x) && x:IsPlayer() then
						v:AddEntityRelationship(x, D_NU, 10) -- Make the player neutral
						if IsValid(v:GetEnemy()) && v:GetEnemy() == x then v:ResetEnemy() end -- Reset the NPC's enemy if it's a player
						table_remove(posEnemies, it) -- Remove the player from possible enemy table
					else
						it = it + 1
					end
				end
			end
		end
	end
end)
---------------------------------------------------------------------------------------------------------------------------------------------
cvars.AddChangeCallback("ai_disabled", function(convar_name, oldValue, newValue)
	VJ_CVAR_AI_ENABLED = tonumber(newValue) != 1
end)