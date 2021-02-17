if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
AddCSLuaFile("shared.lua")
include("shared.lua")
/*--------------------------------------------------
	*** Copyright (c) 2012-2021 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Core Variables ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJBaseSpawnerDisabled = false -- If set to true, it will stop spawning the entities
ENT.OverrideDisableOnSpawn = false -- If set to true, the spawner will create entities on initialize even if it's disabled!
ENT.SingleSpawner = false -- If set to true, it will spawn the entities once then remove itself
ENT.Model = {} -- The models it should spawn with | Picks a random one from the table
ENT.EntitiesToSpawn = {}
/*	Example (2 NPCs):
		ENT.EntitiesToSpawn = {
			{SpawnPosition = {vForward=0, vRight=0, vUp=0}, Entities = {"npc_name1"}},
			{SpawnPosition = {vForward=0, vRight=0, vUp=0}, Entities = {"npc_name1", "npc_name2"}},
		}
	Options:
		- SpawnPosition = {vForward=0, vRight=0, vUp=0} -- This defines the spawn position of the entity
		- Entities = {"npc_name"} -- This defines the table of entities it spawns randomly
		- WeaponsList = {"weapon_name"} -- Use "default" to make it spawn the NPC with its default weapons
*/
ENT.TimedSpawn_Time = 1//3 -- How much time until it spawns another SNPC?
ENT.TimedSpawn_OnlyOne = true -- If it's true then it will only have one SNPC spawned at a time
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Sound Variables ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Idle
ENT.HasIdleSounds = true -- Does it have idle sounds?
ENT.SoundTbl_Idle = {}
ENT.IdleSoundChance = 1 -- How much chance to play the sound? 1 = always
ENT.IdleSoundLevel = 80
ENT.IdleSoundPitch = VJ_Set(80, 100)
ENT.NextSoundTime_Idle = VJ_Set(0.2, 0.5)
-- On Entity Spawn
ENT.HasSpawnEntitySound = true -- Does it play a sound on entity spawn?
ENT.SoundTbl_SpawnEntity = {}
ENT.SpawnEntitySoundChance = 1 -- How much chance to play the sound? 1 = always
ENT.SpawnEntitySoundLevel = 80
ENT.SpawnEntitySoundPitch = VJ_Set(80, 100)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Customization Functions ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- Use the functions below to customize certain parts of the base or to add new custom systems
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnEntitySpawn(ent, spawnKey, spawnTbl, initSpawn) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize_AfterNPCSpawn() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink_AfterAliveChecks() end
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
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SpawnAnEntity(spawnKey, spawnTbl, initSpawn)
	local initOverrideDisable = (initSpawn == true && self.OverrideDisableOnSpawn)
	if self.VJBaseSpawnerDisabled == true && initOverrideDisable == false then return end
	
	local spawnPos = spawnTbl.SpawnPosition
	local spawnEnts = spawnTbl.Entities
	local spawnWepPicked = VJ_PICK(spawnTbl.WeaponsList)
	local ent = ents.Create(VJ_PICK(spawnEnts))
	ent:SetPos(self:GetPos() + self:GetForward()*spawnPos.vForward + self:GetRight()*spawnPos.vRight + self:GetUp()*spawnPos.vUp)
	ent:SetAngles(self:GetAngles())
	ent:Spawn()
	ent:Activate()
	if spawnWepPicked != false && string.lower(spawnWepPicked) != "none" then
		if string.lower(spawnWepPicked) == "default" then
			ent:Give(VJ_PICK(list.Get("NPC")[ent:GetClass()].Weapons))
		else
			ent:Give(spawnWepPicked)
		end
	end
	
	self.CurrentEntities[spawnKey] = {SpawnPosition=spawnPos, Entities=spawnEnts, WeaponsList=spawnTbl.WeaponsList, Ent=ent, Dead=false}
	//table_remove(self.CurrentEntities, spawnKey) 
	//table.insert(self.CurrentEntities, spawnKey, {SpawnPosition=spawnPos, Entities=spawnEnts, WeaponsList=wepList, Ent=ent, Dead=false})
	self:CustomOnEntitySpawn(ent, spawnKey, spawnTbl, initSpawn)
	self:SpawnEntitySoundCode()
	timer.Simple(0.1, function() if IsValid(self) && self.SingleSpawner == true then self:DoSingleSpawnerRemove() end end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Initialize()
	self:CustomOnInitialize()
	self:CustomOnInitialize_BeforeNPCSpawn() -- !!!!!!!!!!!!!! DO NOT USE THIS VARIABLE !!!!!!!!!!!!!! [Backwards Compatibility!]
	if self:GetModel() == "models/error.mdl" then -- No model was detected
		local mdls = VJ_PICK(self.Model)
		if mdls && mdl !="models/props_junk/popcan01a.mdl" then
			self:SetModel(mdls)
		else -- No models found in self.Model
			self:DrawShadow(false)
			self:SetNoDraw(true)
			self:SetNotSolid(true)
		end
	end
	self.CurrentEntities = {}
	for spawnKey, spawnTbl in ipairs(self.EntitiesToSpawn) do
		self:SpawnAnEntity(spawnKey, spawnTbl, true)
	end
	self:CustomOnInitialize_AfterNPCSpawn()
end
function ENT:CustomOnInitialize_BeforeNPCSpawn() end -- !!!!!!!!!!!!!! DO NOT USE THIS VARIABLE !!!!!!!!!!!!!! [Backwards Compatibility!]
// lua_run for spawnKey,spawnTbl in ipairs(ents.GetAll()) do if spawnTbl.IsVJBaseSpawner == true then spawnTbl.VJBaseSpawnerDisabled = false end end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Think()
	//print("-----------------------------------------------------------")
	//PrintTable(self.CurrentEntities)
	self:CustomOnThink()
	self:IdleSoundCode()
	
	-- If it's a continuous spawner then make sure to respawn any entity that has been removed
	if self.VJBaseSpawnerDisabled == false && self.SingleSpawner == false then
		for spawnKey, spawnTbl in ipairs(self.CurrentEntities) do
			-- If entity is removed AND we are NOT already respawning it, then respawn!
			if !IsValid(spawnTbl.Ent) && spawnTbl.Dead == false then
				spawnTbl.Dead = true -- To make sure we do NOT respawn it more than once!
				timer.Simple(self.TimedSpawn_Time, function()
					if IsValid(self) then
						self:SpawnAnEntity(spawnKey, spawnTbl, false)
					end
				end)
			end
		end
	end
	self:CustomOnThink_AfterAliveChecks()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoSingleSpawnerRemove()
	for _, spawnTbl in ipairs(self.CurrentEntities) do
		if IsValid(spawnTbl.Ent) && self:GetCreator() != nil then
			undo.Create(spawnTbl.Ent:GetName())
			undo.AddEntity(spawnTbl.Ent)
			undo.SetPlayer(self:GetCreator())
			undo.Finish()
		end
	end
	self.Dead = true
	VJ_STOPSOUND(self.CurrentIdleSound)
	self:Remove()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:IdleSoundCode()
	if self.HasIdleSounds == false then return end
	if CurTime() > self.NextIdleSoundT then
		if math.random(1, self.IdleSoundChance) == 1 then
			self.CurrentIdleSound = VJ_CreateSound(self, self.SoundTbl_Idle, self.IdleSoundLevel, math.random(self.IdleSoundPitch.a, self.IdleSoundPitch.b))
		end
		self.NextIdleSoundT = CurTime() + math.Rand(self.NextSoundTime_Idle.a, self.NextSoundTime_Idle.b)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SpawnEntitySoundCode()
	if self.HasSpawnEntitySound == false then return end
	if math.random(1, self.SpawnEntitySoundChance) then
		self.CurrentSpawnEntitySound = VJ_CreateSound(self, self.SoundTbl_SpawnEntity, self.SpawnEntitySoundLevel, math.random(self.SpawnEntitySoundPitch.a, self.SpawnEntitySoundPitch.b))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRemove()
	self:CustomOnRemove()
	self.Dead = true
	VJ_STOPSOUND(self.CurrentIdleSound)
	
	-- If it's a continuous spawner then remove all the spawned entities!
	if self.SingleSpawner == false && self.CurrentEntities != nil then
		for _, spawnTbl in ipairs(self.CurrentEntities) do
			if IsValid(spawnTbl.Ent) then
				spawnTbl.Ent:Remove()
			end
		end
	end
end