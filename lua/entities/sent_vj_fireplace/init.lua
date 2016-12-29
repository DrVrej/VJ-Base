local VJExists = "lua/autorun/vj_base_autorun.lua"
if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
/*--------------------------------------------------
	=============== Fireplace ===============
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
INFO: Gives a warm feeling, specially in snowy maps.
--------------------------------------------------*/
ENT.FirePlaceOn = false
ENT.FirePlaceTurnOn2T = 0

util.AddNetworkString("vj_fireplace_turnon1")
util.AddNetworkString("vj_fireplace_turnon2")
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Initialize()
	self:SetModel("models/vj_props/Fireplace.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_VPHYSICS)
	//self:SetCollisionGroup(COLLISION_GROUP_NONE)
	self:SetUseType(SIMPLE_USE)
	
	local phys = self:GetPhysicsObject()
	if phys and phys:IsValid() then
		//phys:Wake()
	end
	timer.Simple(0,function() self:SetPos(self:GetPos() +self:GetUp()*-2.5) end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PhysicsCollide(data, physobj)
	//self.Entity:EmitSound("physics/cardboard/cardboard_box_impact_soft"..math.random(1,5)..".wav")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Think()
	if self.FirePlaceOn == true then
	if CurTime() > self.FirePlaceTurnOn2T then
		net.Start("vj_fireplace_turnon2")
		net.WriteEntity(self)
		net.Broadcast()
	self.FirePlaceTurnOn2T = CurTime() + 99999999999999999999 *9999999999999999999 end
		net.Start("vj_fireplace_turnon1")
		net.WriteEntity(self)
		net.Broadcast()
		else
		if self.firesound1 then self.firesound1:Stop() end
		self:StopParticles()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Use(activator, caller)
	//if activator:IsPlayer() then
	if self.FirePlaceOn == false then
		self.FirePlaceOn = true
		self.FirePlaceTurnOn2T = 0
		self:EmitSound(Sound("ambient/fire/mtov_flame2.wav"),60,100)
		self.firesound1 = CreateSound(self,"ambient/fire/fire_small_loop1.wav") self.firesound1:SetSoundLevel(60)
		self.firesound1:PlayEx(1,100)
		//activator:SetHealth(activator:Health() +1000000)
		activator:PrintMessage(HUD_PRINTTALK, "You turned the fireplace on.") 
	else
		activator:PrintMessage(HUD_PRINTTALK, "You turned the fireplace off")
		self.FirePlaceOn = false
		self:StopParticles()
		if self.firesound1 then self.firesound1:Stop() end
		//self.FireLight1:Remove()
		end
	//end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnTakeDamage(dmginfo)
	//self:GetPhysicsObject():AddVelocity(dmginfo:GetDamageForce() * 0.1)
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Touch(entity)
	if (IsValid(entity) && entity:GetPos():Distance(self:GetPos()) <= 38 && self.FirePlaceOn == true) && (entity:IsNPC() or entity:IsPlayer()) then
		entity:Ignite(math.Rand(3,5))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRemove()
	self:StopParticles()
	if self.firesound1 then self.firesound1:Stop() end
end
/*--------------------------------------------------
	=============== Admin Health Kit ===============
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
INFO: Used to quickly give admins a lot health
--------------------------------------------------*/
