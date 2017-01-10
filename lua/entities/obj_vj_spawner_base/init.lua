if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")
/*--------------------------------------------------
	=============== Spawner Base ===============
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
INFO: Used to make spawners.
--------------------------------------------------*/
ENT.IsVJBaseSpawner = true
ENT.VJBaseSpawnerDisabled = false -- If set to true, it will stop spawning the entities
ENT.SingleSpawner = false -- If set to true, it will spawn the entities once then remove itself
	-- General ---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Model = {""} -- The models it should spawn with | Picks a random one from the table
ENT.EntitiesToSpawn = {
	{EntityName = "NPC1",SpawnPosition = {vForward=0,vRight=0,vUp=0},Entities = {"npc_vj_name"}}, -- Extras: WeaponsList = {}
}
ENT.TimedSpawn_Time = 3 -- How much time until it spawns another SNPC?
ENT.TimedSpawn_OnlyOne = true -- If it's true then it will only have one SNPC spawned at a time
ENT.HasIdleSounds = true -- Does it have idle sounds?
ENT.SoundTbl_Idle = {}
ENT.IdleSoundChance = 1 -- How much chance to play the sound? 1 = always
ENT.IdleSoundLevel = 80
ENT.IdleSoundPitch1 = 80
ENT.IdleSoundPitch2 = 100
ENT.NextSoundTime_Idle1 = 0.2
ENT.NextSoundTime_Idle2 = 0.5
ENT.SoundTbl_SpawnEntity = {}
ENT.SpawnEntitySoundChance = 1 -- How much chance to play the sound? 1 = always
ENT.SpawnEntitySoundLevel = 80
ENT.SpawnEntitySoundPitch1 = 80
ENT.SpawnEntitySoundPitch2 = 100
	-- Independent Variables ---------------------------------------------------------------------------------------------------------------------------------------------
-- These should be left as they are
ENT.Dead = false
ENT.AlreadyDoneVJBaseSpawnerDisabled = true
ENT.NextIdleSoundT = 0
ENT.NextTimedSpawnT = 0
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnEntitySpawn(EntityName,SpawnPosition,Entities,TheEntity) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize_BeforeNPCSpawn() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize_AfterNPCSpawn() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink_BeforeAliveChecks() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink_AfterAliveChecks() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SpawnAnEntity(keys,values,initspawn)
	local k = keys
	local v = values
	local initspawn = initspawn or false
	local overridedisable = false
	local hasweps = false
	local wepslist = {}
	if initspawn == true then overridedisable = true end
	if self.VJBaseSpawnerDisabled == true && overridedisable == false then return end
	
	local getthename = v.EntityName
	local spawnpos = v.SpawnPosition
	local getthename = ents.Create(VJ_PICKRANDOMTABLE(v.Entities))
	getthename:SetPos(self:GetPos() +self:GetForward()*spawnpos.vForward +self:GetRight()*spawnpos.vRight +self:GetUp()*spawnpos.vUp)
	getthename:SetAngles(self:GetAngles())
	getthename:Spawn()
	getthename:Activate()
	if v.WeaponsList != nil && VJ_PICKRANDOMTABLE(v.WeaponsList) != false && VJ_PICKRANDOMTABLE(v.WeaponsList) != NULL && VJ_PICKRANDOMTABLE(v.WeaponsList) != "None" && VJ_PICKRANDOMTABLE(v.WeaponsList) != "none" then hasweps = true wepslist = v.WeaponsList end
	if hasweps == true then getthename:Give(VJ_PICKRANDOMTABLE(v.WeaponsList)) end
	if initspawn == false then table.remove(self.CurrentEntities,k) end
	table.insert(self.CurrentEntities,k,{EntityName=v.EntityName,SpawnPosition=v.SpawnPosition,Entities=v.Entities,TheEntity=getthename,WeaponsList=wepslist,Dead=false/*NextTimedSpawnT=CurTime()+self.TimedSpawn_Time*/})
	self:SpawnEntitySoundCode()
	if self.VJBaseSpawnerDisabled == true && overridedisable == true then getthename:Remove() return end
	self:CustomOnEntitySpawn(v.EntityName,v.SpawnPosition,v.Entities,TheEntity)
	timer.Simple(0.1,function() if IsValid(self) then if self.SingleSpawner == true then self:DoSingleSpawnerRemove() end end end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Initialize()
	if self:GetModel() == "models/error.mdl" then
	self:SetModel(VJ_PICKRANDOMTABLE(self.Model)) end
	self:DrawShadow(false)
	self:SetNoDraw(true)
	self:SetNotSolid(true)
	self.CurrentEntities = {}
	self:CustomOnInitialize_BeforeNPCSpawn()
	self.NumberOfEntitiesToSpawn =  table.Count(self.EntitiesToSpawn)
	for k,v in ipairs(self.EntitiesToSpawn) do self:SpawnAnEntity(k,v,true) end
	self:CustomOnInitialize_AfterNPCSpawn()
end
// lua_run for k,v in ipairs(ents.GetAll()) do if v.IsVJBaseSpawner == true then v.VJBaseSpawnerDisabled = false end end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Think()
	if self.Dead == true then VJ_STOPSOUND(self.CurrentIdleSound) return end
	if self.VJBaseSpawnerDisabled == true then self.AlreadyDoneVJBaseSpawnerDisabled = false end
	//PrintTable(self.CurrentEntities)
	//print("-----------------------------------------------------------")
	self:CustomOnThink_BeforeAliveChecks()
	self:IdleSoundCode()
	
	/*if self.VJBaseSpawnerDisabled == false && self.AlreadyDoneVJBaseSpawnerDisabled == false && table.Count(self.CurrentEntities) < self.NumberOfEntitiesToSpawn then
		self.AlreadyDoneVJBaseSpawnerDisabled = true
		for k,v in ipairs(self.EntitiesToSpawn) do self:SpawnAnEntity(k,v) end
	end*/
	
	if self.VJBaseSpawnerDisabled == false && self.SingleSpawner == false then
		for k,v in ipairs(self.CurrentEntities) do
			if !IsValid(v.TheEntity) && v.Dead == false /*&& v.NextTimedSpawnT < CurTime()*/ then
				v.Dead = true
				timer.Simple(self.TimedSpawn_Time,function() if IsValid(self) then /*table.remove(self.CurrentEntities,k)*/ self:SpawnAnEntity(k,v,false) end end)
			end
		end
	end
	self:CustomOnThink_AfterAliveChecks()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:IdleSoundCode()
	if self.HasIdleSounds == false then return end
	if CurTime() > self.NextIdleSoundT then
		local randomidlesound = math.random(1,self.IdleSoundChance)
		if randomidlesound == 1 /*&& self:VJ_IsPlayingSoundFromTable(self.SoundTbl_Idle) == false*/ then
			self.CurrentIdleSound = VJ_CreateSound(self,self.SoundTbl_Idle,self.IdleSoundLevel,math.random(self.IdleSoundPitch1,self.IdleSoundPitch2))
		end
		self.NextIdleSoundT = CurTime() + math.Rand(self.NextSoundTime_Idle1,self.NextSoundTime_Idle2)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SpawnEntitySoundCode()
	if self.HasIdleSounds == false then return end
	local randomidlesound = math.random(1,self.SpawnEntitySoundChance)
	if randomidlesound == 1 /*&& self:VJ_IsPlayingSoundFromTable(self.SoundTbl_Idle) == false*/ then
		self.CurrentSpawnEntitySound = VJ_CreateSound(self,self.SoundTbl_SpawnEntity,self.SpawnEntitySoundLevel,math.random(self.SpawnEntitySoundPitch1,self.SpawnEntitySoundPitch2))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoSingleSpawnerRemove()
	for k,v in ipairs(self.CurrentEntities) do
		if IsValid(v.TheEntity) && self:GetCreator() != nil then
			//cleanup.ReplaceEntity(self,v.TheEntity)
			//undo.ReplaceEntity(self,v.TheEntity)
			undo.Create(v.TheEntity:GetName())
			undo.AddEntity(v.TheEntity)
			undo.SetPlayer(self:GetCreator())
			undo.Finish()
		end
	end
	self.Dead = true
	VJ_STOPSOUND(self.CurrentIdleSound)
	self:Remove()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRemove()
	self.Dead = true
	VJ_STOPSOUND(self.CurrentIdleSound)
	if self.SingleSpawner == false && self.CurrentEntities != nil then
		for k,v in ipairs(self.CurrentEntities) do
			if IsValid(v.TheEntity) && v.TheEntity then v.TheEntity:Remove() end
		end
	end
end
/*--------------------------------------------------
	=============== Spawner Base ===============
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
INFO: Used to make spawners.
--------------------------------------------------*/