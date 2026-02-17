/*-----------------------------------------------
	*** Copyright (c) 2012-2026 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
AddCSLuaFile()

ENT.Base 			= "base_anim"
ENT.Type 			= "anim"
ENT.PrintName 		= "Wooden Board"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Information 	= "Physics entity that VJ NPCs can attack.\nUseful for barricading an area."
ENT.Category		= "VJ Base"
ENT.Spawnable		= true

ENT.PhysicsSounds = true
ENT.VJ_ID_Attackable = true

scripted_ents.Alias("sent_vj_board", "prop_vj_board") -- !! Backwards Compatibility !!
---------------------------------------------------------------------------------------------------------------------------------------------
if CLIENT then
	VJ.AddKillIcon("prop_vj_board", ENT.PrintName, VJ.KILLICON_TYPE_ALIAS, "prop_physics")
	
	function ENT:Draw()
		self:DrawModel()
	end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if !SERVER then return end

ENT.StartHealth = 50
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Initialize()
	self:SetModel("models/props_debris/wood_board05a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:SetMaxHealth(self.StartHealth)
	self:SetHealth(self.StartHealth)
	
	local phys = self:GetPhysicsObject()
	if phys and IsValid(phys) then
		phys:Wake()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Use(activator, caller)
	if IsValid(activator) && activator:IsPlayer() then
		activator:PickupObject(self)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnTakeDamage(dmginfo)
	self:GetPhysicsObject():AddVelocity(dmginfo:GetDamageForce() * 0.05)
	self:SetHealth(self:Health() - dmginfo:GetDamage())
	if self:Health() <= 0 then
		local effectData = EffectData()
		effectData:SetOrigin(self:GetPos())
		util.Effect("VJ_Dust_Small", effectData)
		self:Remove()
	end
end