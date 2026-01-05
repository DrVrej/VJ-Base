AddCSLuaFile("shared.lua")
include("shared.lua")
/*--------------------------------------------------
	*** Copyright (c) 2012-2026 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Core Variables ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ENT.Model = {} -- Model(s) to spawn with | Picks a random one if it's a table
ENT.SingleSpawner = false -- Should it will spawn the entities once then remove itself?
ENT.PauseSpawning = false -- When set to true, it stops spawning the entities until set to false again
ENT.RespawnCooldown = 3 -- Cooldown time until a removed entity can respawn
ENT.EntitiesToSpawn = {}
/*	Example (3 NPCs):
		ENT.EntitiesToSpawn = {
			{Entities = {"npc_name_one"}},
			{Entities = {"npc_name_one:1", "npc_name_two:5"}, SpawnPosition = Vector(0, -100, 0)},
			{Entities = {"npc_name_three", "npc_name_one:1", "npc_name_two:5"}, SpawnPosition = Vector(0, 100, 0)},
		}
	Options:
		Entities = {} -- The table of entities it spawns randomly, REQUIRED!
			- ":" = Add at the end to apply a chance, it starts from 1
				- ":1" = Spawn always or leave it empty
				- WARNING: If no entity is left empty or set to ":1" then during randomization, the base will spawn the last NPC it checks if no other passes!
		SpawnPosition = Vector(0, 0, 0) -- Spawn position of the entity based on the spawner's position | OPTIONAL | DEFAULT: Origin of the spawner
		SpawnAngle = Angle(0, 0, 0) -- Spawn angle of the entity based on the spawner's angle | OPTIONAL | DEFAULT: Spawners current angle
		WeaponsList = {} -- List of weapons it can randomly spawn with | OPTIONAL | DEFAULT: Empty table
			- "default" = Spawns the NPC with its default weapons list from the spawn menu
		NPC_Class = "" or {} -- Overrides the NPC's relation class with the given string or table | OPTIONAL | DEFAULT: ""
		FriToPlyAllies = false or true -- If set to true, the NPC will be allied with the player, must have NPC class "CLASS_PLAYER_ALLY" | OPTIONAL | DEFAULT: false
*/
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Sound Variables ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Sounds to play while idle
ENT.SoundTbl_Idle = false -- false = Don't play any sounds | string or table of strings = Sounds to play
ENT.IdleSoundChance = 1 -- How much chance to play the sound? | 1 = Always
ENT.IdleSoundLevel = 80
ENT.IdleSoundPitch = VJ.SET(80, 100)
ENT.IdleSoundCooldown = VJ.SET(4, 10)

-- Sounds to play when it spawns an entity
ENT.SoundTbl_SpawnEntity = false -- false = Don't play any sounds | string or table of strings = Sounds to play
ENT.SpawnEntitySoundChance = 1 -- How much chance to play the sound? | 1 = Always
ENT.SpawnEntitySoundLevel = 80
ENT.SpawnEntitySoundPitch = VJ.SET(80, 100)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Customization Functions ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- Use the functions below to customize certain parts of the base or to add new custom systems
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init() end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Called when an entity spawns
		- ent [entity] = Entity it spawned
		- spawnKey [number] = Table key for "self.CurrentEntities"
		- spawnTbl [table] = Information it passed to "self.CurrentEntities"
		- initSpawn [boolean] = Was this an initial spawn? Used by the base during initialization
-----------------------------------------------------------]]
function ENT:OnSpawnEntity(ent, spawnKey, spawnTbl, initSpawn) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRemove() end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ ///// WARNING: Don't touch anything below this line! \\\\\ ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ENT.Dead = false
ENT.NextIdleSoundT = 0

local string_explode = string.Explode
local defPos = Vector(0, 0, 0)
local defAng = Angle(0, 0, 0)

local metaEntity = FindMetaTable("Entity")
local funcGetTable = metaEntity.GetTable
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Spawns an entity from the given information, recommended to not manually call this function!
		- spawnKey = The key or the position in the table of the current entity to spawn
		- spawnTbl = Table of information for the entity to spawn including class names, spawn position, weapons, etc.
		- initSpawn = Is this a initial spawn? Used by the base during initialization | DEFAULT: false
-----------------------------------------------------------]]
function ENT:SpawnEntity(spawnKey, spawnTbl, initSpawn)
	if self.PauseSpawning then
		-- Add to the queue to spawn later
		self.CurrentQueue = self.CurrentQueue or {}
		table.insert(self.CurrentQueue, {spawnKey = spawnKey, spawnTbl = spawnTbl})
		return
	end
	
	local spawnCreator = self:GetCreator()
	local spawnPos = spawnTbl.SpawnPosition or defPos
	local spawnAng = spawnTbl.SpawnAngle or defAng
	local spawnEnts = spawnTbl.Entities
	local spawnNPCClass = spawnTbl.NPC_Class or false
	local spawnFriToPlyAllies = spawnTbl.FriToPlyAllies or false
	local spawnWepPicked = VJ.PICK(spawnTbl.WeaponsList)
	local entPicked; -- The entity that we will spawn
	local entsNum = #spawnEnts -- The number of entities
	local i = 0 -- If this number equals entsNum, then its the last entity
	for _, v in RandomPairs(spawnEnts) do
		i = i + 1
		local strExp = string_explode(":", v) -- Separates the entity class and the number after ":"
		//PrintTable(strExp)
		if strExp[2] then
			if i == entsNum then -- If we are the last entity, then just spawn it anyway
				entPicked = strExp[1]
				break
			elseif math.random(1, strExp[2]) == 1 then
				entPicked = strExp[1]
				break
			end
		else -- String does NOT contain ":", so just pick this
			entPicked = v
			break
		end
	end
	
	-- Create the entity
	local ent = ents.Create(entPicked)
	if IsValid(spawnCreator) then
		ent:SetCreator(spawnCreator)
	end
	ent:SetPos(self:GetPos() + spawnPos)
	ent:SetAngles(spawnAng + self:GetAngles())
	ent:Spawn()
	ent:Activate()
	if spawnNPCClass then
		ent.VJ_NPC_Class = istable(spawnNPCClass) && spawnNPCClass or {spawnNPCClass}
	end
	if spawnFriToPlyAllies then
		ent.AlliedWithPlayerAllies = true
	end
	if ent:IsNPC() && spawnWepPicked != false && string.lower(spawnWepPicked) != "none" then
		if string.lower(spawnWepPicked) == "default" then -- Default weapon from the spawn menu
			local getDefWep = VJ.PICK(list.Get("NPC")[ent:GetClass()].Weapons)
			if getDefWep then
				ent:Give(getDefWep)
			end
		else
			ent:Give(spawnWepPicked)
		end
	end
	if self.SingleSpawner then
		timer.Simple(0.1, function()
			if IsValid(self) then
				self:Remove()
			end
		end)
	else
		ent:CallOnRemove("vj_spawner_remove", function(dataEnt, dataSpawnKey)
			if IsValid(self) then
				local entSpawnTbl = self.CurrentEntities[dataSpawnKey]
				if !entSpawnTbl.Respawning then
					entSpawnTbl.Respawning = true -- To make sure it only respawns it once!
					timer.Simple(self.RespawnCooldown, function()
						if IsValid(self) then
							self:SpawnEntity(dataSpawnKey, entSpawnTbl, false)
						end
					end)
				end
			end
		end, spawnKey)
	end
	
	self.CurrentEntities[spawnKey] = {Entities = spawnEnts, SpawnPosition = spawnPos, SpawnAngle = spawnAng, WeaponsList = spawnTbl.WeaponsList, NPC_Class = spawnNPCClass, FriToPlyAllies = spawnFriToPlyAllies, Ent = ent, Respawning = false}
	self:OnSpawnEntity(ent, spawnKey, spawnTbl, initSpawn)
	
	-- Play spawn sound
	local sdTbl = self.SoundTbl_SpawnEntity
	if sdTbl && math.random(1, self.SpawnEntitySoundChance) then
		VJ.EmitSound(self, sdTbl, self.SpawnEntitySoundLevel, math.random(self.SpawnEntitySoundPitch.a, self.SpawnEntitySoundPitch.b))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Initialize()
	self:Init()
	if self.CustomOnInitialize then self:CustomOnInitialize() end -- !!!!!!!!!!!!!! DO NOT USE !!!!!!!!!!!!!! [Backwards Compatibility!]
	if self.CustomOnThink then self.OnThink = function() self:CustomOnThink() end end -- !!!!!!!!!!!!!! DO NOT USE !!!!!!!!!!!!!! [Backwards Compatibility!]
	if self:GetModel() == "models/error.mdl" then -- No model was detected
		local mdl = VJ.PICK(self.Model)
		if mdl && mdl != "models/props_junk/popcan01a.mdl" then
			self:SetModel(mdl)
		else -- No models found in self.Model
			self:DrawShadow(false)
			self:SetNoDraw(true)
			self:SetNotSolid(true)
		end
	end
	self.CurrentEntities = {}
	
	-- Delay to avoid issues such as the position of the spawner being offset
	timer.Simple(0.1, function()
		for spawnKey, spawnTbl in ipairs(self.EntitiesToSpawn) do
			local spawnPos = spawnTbl.SpawnPosition
			if istable(spawnPos) then -- !!!!!!!!!!!!!! DO NOT USE THESE VARIABLES !!!!!!!!!!!!!! [Backwards Compatibility!]
				spawnTbl.SpawnPosition = Vector(spawnPos.vForward or 0, spawnPos.vRight or 0, spawnPos.vUp or 0)
			end
			self:SpawnEntity(spawnKey, spawnTbl, true)
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Think()
	local curTime = CurTime()
	local selfData = funcGetTable(self)
	self:OnThink()
	
	-- Idle sound
	local sdTbl = selfData.SoundTbl_Idle
	if sdTbl && curTime > selfData.NextIdleSoundT then
		if math.random(1, selfData.IdleSoundChance) == 1 then
			VJ.STOPSOUND(selfData.CurrentIdleSound)
			selfData.CurrentIdleSound = VJ.CreateSound(self, sdTbl, selfData.IdleSoundLevel, math.random(selfData.IdleSoundPitch.a, selfData.IdleSoundPitch.b))
		end
		selfData.NextIdleSoundT = curTime + math.Rand(selfData.IdleSoundCooldown.a, selfData.IdleSoundCooldown.b)
	end
	
	-- Handle queued entities in case we were paused when they were supposed to spawn
	if !selfData.PauseSpawning then
		local queue = selfData.CurrentQueue
		if queue then
			for _, backData in ipairs(queue) do
				self:SpawnEntity(backData.spawnKey, backData.spawnTbl, false)
			end
			self.CurrentQueue = nil
		end
	end
	
	self:NextThink(curTime + 0.5)
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRemove()
	self:CustomOnRemove()
	self.Dead = true
	VJ.STOPSOUND(self.CurrentIdleSound)
	
	local curEnts = self.CurrentEntities
	if curEnts then
		-- SINGLE SPAWNERS: Add all the spawned entities the player's undo list
		if self.SingleSpawner then
			local creator = self:GetCreator()
			if IsValid(creator) then
				for _, spawnTbl in ipairs(curEnts) do
					local ent = spawnTbl.Ent
					if IsValid(ent) then
						undo.Create(ent:GetName())
						undo.AddEntity(ent)
						undo.SetPlayer(creator)
						undo.Finish()
					end
				end
			end
		-- CONTINUOUS SPAWNERS: Remove all spawned entities
		else
			for _, spawnTbl in ipairs(self.CurrentEntities) do
				if IsValid(spawnTbl.Ent) then
					spawnTbl.Ent:Remove()
				end
			end
		end
	end
end