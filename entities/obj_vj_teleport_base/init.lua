if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")
/*--------------------------------------------------
	=============== Spawner Base ===============
	*** Copyright (c) 2012-2016 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
INFO: Used to make spawners.
--------------------------------------------------*/
ENT.IsVJBaseTeleport = true
	-- General ---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Model = {""} -- The models it should spawn with | Picks a random one from the table
ENT.HasInvisibleModel = false -- Should the entity spawn with a invisible model?
ENT.EntityToTeleportTo = ""
ENT.ReceiverName = ""

	-- Sounds ---------------------------------------------------------------------------------------------------------------------------------------------
ENT.HasIdleSounds = true -- Does it have idle sounds?
ENT.SoundTbl_Idle = {}
ENT.IdleSoundChance = 1 -- How much chance to play the sound? 1 = always
ENT.IdleSoundLevel = 80
ENT.IdleSoundPitch1 = 80
ENT.IdleSoundPitch2 = 100
ENT.NextSoundTime_Idle1 = 0.2
ENT.NextSoundTime_Idle2 = 0.5
	-- Independent Variables ---------------------------------------------------------------------------------------------------------------------------------------------
-- These should be left as they are
ENT.Dead = false
ENT.NextIdleSoundT = 0
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTeleport() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRemove() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Initialize()
	if self:GetModel() == "models/error.mdl" then
	self:SetModel(VJ_PICKRANDOMTABLE(self.Model)) end
	if self.HasInvisibleModel == true then
		self:DrawShadow(false)
		self:SetNoDraw(true)
		self:SetNotSolid(true)
	end
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetUseType(SIMPLE_USE)
	self:CustomOnInitialize()
	
	/*local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:EnableGravity(false)
		phys:EnableDrag(false)
		phys:SetBuoyancyRatio(0)
	end*/
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Use(activator, caller)
	if activator:IsPlayer() then
		self:DoTeleport(activator)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoTeleport(activator)
	print(activator)
	local getallents = ents.GetAll()
	for k,v in ipairs(getallents) do
		if v:GetClass() == self.EntityToTeleportTo && IsValid(v) then
			self:CustomOnTeleport()
			local enttele = v
			activator:SetPos(enttele:GetPos())
			activator:PrintMessage(HUD_PRINTTALK, "You have teleported!")
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Think()
	if self.Dead == true then VJ_STOPSOUND(self.CurrentIdleSound) return end
	self:IdleSoundCode()
	self:CustomOnThink()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:IdleSoundCode()
if self.HasIdleSounds == false then return end
if CurTime() > self.NextIdleSoundT then
	local randomidlesound = math.random(1,self.IdleSoundChance)
	if randomidlesound == 1 /*&& self:VJ_IsPlayingSoundFromTable(self.SoundTbl_Idle) == false*/ then
		self.CurrentIdleSound = VJ_CreateSound(self,self.SoundTbl_Idle,self.IdleSoundLevel,math.random(self.IdleSoundPitch1,self.IdleSoundPitch2)) end
		self.NextIdleSoundT = CurTime() + math.Rand(self.NextSoundTime_Idle1,self.NextSoundTime_Idle2)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRemove()
	self.Dead = true
	VJ_STOPSOUND(self.CurrentIdleSound)
	self:CustomOnRemove()
end
/*--------------------------------------------------
	=============== Spawner Base ===============
	*** Copyright (c) 2012-2016 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
INFO: Used to make spawners.
--------------------------------------------------*/