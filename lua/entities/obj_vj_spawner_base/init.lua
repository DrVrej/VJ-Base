AddCSLuaFile("shared.lua")
include("shared.lua")
/*--------------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Core Variables ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ENT.SingleSpawner = false -- If set to true, it will spawn the entities once then remove itself
ENT.VJBaseSpawnerDisabled = false -- If set to true, it will stop spawning the entities
ENT.OverrideDisableOnSpawn = false -- If set to true, the spawner will create entities on initialize even if it's disabled!
ENT.Model = {} -- Model(s) to spawn with | Picks a random one if it's a table
ENT.EntitiesToSpawn = {}
/*	Example (3 NPCs):
		ENT.EntitiesToSpawn = {
			{Entities = {"npc_name_one"}},
			{SpawnPosition = Vector(0, -100, 0), Entities = {"npc_name_one:1", "npc_name_two:5"}},
			{SpawnPosition = Vector(0, 100, 0), Entities = {"npc_name_three", "npc_name_one:1", "npc_name_two:5"}},
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
ENT.TimedSpawn_Time = 3 -- How much time until it spawns another SNPC?
ENT.TimedSpawn_OnlyOne = true -- If it's true then it will only have one SNPC spawned at a time
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Sound Variables ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Sounds to play while idle
ENT.SoundTbl_Idle = {} -- false = Don't play any sounds | string or table of strings = Sounds to play
ENT.IdleSoundChance = 1 -- How much chance to play the sound? | 1 = Always
ENT.IdleSoundLevel = 80
ENT.IdleSoundPitch = VJ.SET(80, 100)
ENT.NextSoundTime_Idle = VJ.SET(4, 10)

-- Sounds to play when it spawns an entity
ENT.SoundTbl_SpawnEntity = {} -- false = Don't play any sounds | string or table of strings = Sounds to play
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
	Called when an entity spawns.
		- ent = The entity it spawned
		- spawnKey = The key or the position in the table of the current entity it spawned
		- spawnTbl = Table of information for the entity it spawned including class names, spawn position, weapons, etc.
		- initSpawn = Was this an initial spawn? Used by the base during initialization
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
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Spawns an entity from the given information, recommended to not manually call this function!
		- spawnKey = The key or the position in the table of the current entity to spawn
		- spawnTbl = Table of information for the entity to spawn including class names, spawn position, weapons, etc.
		- initSpawn = Is this a initial spawn? Used by the base during initialization | DEFAULT: false
-----------------------------------------------------------]]
function ENT:SpawnEntity(spawnKey, spawnTbl, initSpawn)
	local initOverrideDisable = (initSpawn == true && self.OverrideDisableOnSpawn)
	if self.VJBaseSpawnerDisabled && initOverrideDisable == false then return end
	
	local spawnPos = spawnTbl.SpawnPosition or defPos
	local spawnAng = spawnTbl.SpawnAngle or defAng
	local spawnEnts = spawnTbl.Entities
	local spawnNPCClass = spawnTbl.NPC_Class or ""
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
	local ent = ents.Create(entPicked)
	if IsValid(self:GetCreator()) then
		ent:SetCreator(self:GetCreator())
	end
	ent:SetPos(self:GetPos() + spawnPos)
	ent:SetAngles(spawnAng + self:GetAngles())
	ent:Spawn()
	ent:Activate()
	if spawnNPCClass != "" then
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
	
	self.CurrentEntities[spawnKey] = {Entities=spawnEnts, SpawnPosition=spawnPos, SpawnAngle=spawnAng, WeaponsList=spawnTbl.WeaponsList, NPC_Class=spawnNPCClass, FriToPlyAllies=spawnFriToPlyAllies, Ent=ent, Dead=false}
	//table_remove(self.CurrentEntities, spawnKey) 
	//table.insert(self.CurrentEntities, spawnKey, {SpawnPosition=spawnPos, Entities=spawnEnts, WeaponsList=wepList, Ent=ent, Dead=false})
	self:OnSpawnEntity(ent, spawnKey, spawnTbl, initSpawn)
	local sdTbl = self.SoundTbl_SpawnEntity
	if sdTbl && math.random(1, self.SpawnEntitySoundChance) then
		VJ.EmitSound(self, sdTbl, self.SpawnEntitySoundLevel, math.random(self.SpawnEntitySoundPitch.a, self.SpawnEntitySoundPitch.b))
	end
	timer.Simple(0.1, function() if IsValid(self) && self.SingleSpawner then self:DoSingleSpawn() end end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Initialize()
	self:Init()
	if self.CustomOnInitialize then self:CustomOnInitialize() end -- !!!!!!!!!!!!!! DO NOT USE !!!!!!!!!!!!!! [Backwards Compatibility!]
	if self.CustomOnThink then self.OnThink = function() self:CustomOnThink() end end -- !!!!!!!!!!!!!! DO NOT USE !!!!!!!!!!!!!! [Backwards Compatibility!]
	if self:GetModel() == "models/error.mdl" then -- No model was detected
		local mdls = VJ.PICK(self.Model)
		if mdls && mdl !="models/props_junk/popcan01a.mdl" then
			self:SetModel(mdls)
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
// lua_run for spawnKey,spawnTbl in ipairs(ents.GetAll()) do if spawnTbl.IsVJBaseSpawner then spawnTbl.VJBaseSpawnerDisabled = false end end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Think()
	//print("-----------------------------------------------------------")
	//PrintTable(self.CurrentEntities)
	local selfData = self:GetTable()
	self:OnThink()
	
	-- Idle sound
	local sdTbl = selfData.SoundTbl_Idle
	if sdTbl && CurTime() > selfData.NextIdleSoundT then
		if math.random(1, selfData.IdleSoundChance) == 1 then
			VJ.STOPSOUND(selfData.CurrentIdleSound)
			selfData.CurrentIdleSound = VJ.CreateSound(self, sdTbl, selfData.IdleSoundLevel, math.random(selfData.IdleSoundPitch.a, selfData.IdleSoundPitch.b))
		end
		selfData.NextIdleSoundT = CurTime() + math.Rand(selfData.NextSoundTime_Idle.a, selfData.NextSoundTime_Idle.b)
	end
	
	-- If it's a continuous spawner then make sure to respawn any entity that has been removed
	if !selfData.VJBaseSpawnerDisabled && !selfData.SingleSpawner then
		for spawnKey, spawnTbl in ipairs(selfData.CurrentEntities) do
			-- If entity is removed AND we are NOT already respawning it, then respawn!
			if !IsValid(spawnTbl.Ent) && !spawnTbl.Dead then
				spawnTbl.Dead = true -- To make sure we do NOT respawn it more than once!
				timer.Simple(selfData.TimedSpawn_Time, function()
					if IsValid(self) then
						self:SpawnEntity(spawnKey, spawnTbl, false)
					end
				end)
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoSingleSpawn()
	if self.Dead then return end
	if IsValid(self:GetCreator()) then
		for _, spawnTbl in ipairs(self.CurrentEntities) do
			if IsValid(spawnTbl.Ent) then
				undo.Create(spawnTbl.Ent:GetName())
				undo.AddEntity(spawnTbl.Ent)
				undo.SetPlayer(self:GetCreator())
				undo.Finish()
			end
		end
	end
	self.Dead = true
	VJ.STOPSOUND(self.CurrentIdleSound)
	self:Remove()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRemove()
	self:CustomOnRemove()
	self.Dead = true
	VJ.STOPSOUND(self.CurrentIdleSound)
	
	-- If it's a continuous spawner then remove all the spawned entities!
	if self.SingleSpawner == false && self.CurrentEntities != nil then
		for _, spawnTbl in ipairs(self.CurrentEntities) do
			if IsValid(spawnTbl.Ent) then
				spawnTbl.Ent:Remove()
			end
		end
	end
end