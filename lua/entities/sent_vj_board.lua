/*--------------------------------------------------
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
AddCSLuaFile()
if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end

ENT.Base 			= "base_gmodentity"
ENT.Type 			= "anim"
ENT.PrintName 		= "Wooden Board"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Purpose 		= "Used for defending a certain area from enemies, SNPCs will attack it when close."
ENT.Instructions 	= "Don't change anything."
ENT.Category		= "VJ Base"

ENT.Spawnable = true
ENT.AdminOnly = false
---------------------------------------------------------------------------------------------------------------------------------------------
if (CLIENT) then
	function ENT:Draw()
		self:DrawModel()
	end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if !(SERVER) then return end

ENT.VJ_AddEntityToSNPCAttackList = true
ENT.Model = {"models/props_debris/wood_board05a.mdl"}
ENT.StartHealth = 10
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Initialize()
	if self:GetModel() == "models/error.mdl" then
	self:SetModel(Model(VJ_PICK(self.Model))) end
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	//self:SetCollisionGroup(COLLISION_GROUP_NONE)
	self:SetUseType(SIMPLE_USE)
	self:SetHealth(self.StartHealth)
	
	local phys = self:GetPhysicsObject()
	if phys and phys:IsValid() then
		phys:Wake()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PhysicsCollide(data, physobj)
	//self:EmitSound("physics/cardboard/cardboard_box_impact_soft"..math.random(1,5)..".wav")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Think()
	
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Use(activator, caller)

end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnTakeDamage(dmginfo)
	self:SetHealth(self:Health() - dmginfo:GetDamage())
	if self:Health() <= 0 then self:DoDeath() end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoDeath()
	local effectdata = EffectData()
	effectdata:SetOrigin(self:GetPos())
	//effectdata:SetScale( 500 )
	util.Effect("VJ_Small_Dust1", effectdata)
	self:Remove()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRemove()
	self:StopParticles()
end
/*--------------------------------------------------
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/