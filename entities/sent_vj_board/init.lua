AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.VJ_AddEntityToSNPCAttackList = true



function ENT:Initialize()
	 
	self.Entity:SetModel("models/props_debris/wood_board02a.mdl")
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_NONE)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	self.Entity:DrawShadow(false)
	self.Entity:SetCollisionGroup(COLLISION_GROUP_INTERACTIVE)
	self.Entity:SetHealth(10)

	
	local phys = self.Entity:GetPhysicsObject()
	
	if (phys:IsValid()) then
		phys:Wake()
	end

	self.Entity:SetUseType(SIMPLE_USE)
end
function ENT:PhysicsCollide(data, physobj)
end
function ENT:OnTakeDamage(dmg)
self:SetHealth(self:Health() - dmg:GetDamage())
if self:Health() <= 0 then 
self.Entity:Remove() end
end 
function ENT:Think()

end
 function ENT:Touch(hitent)
end
function ENT:Use(activator, caller)
end