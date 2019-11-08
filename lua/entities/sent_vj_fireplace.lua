/*--------------------------------------------------
	*** Copyright (c) 2012-2019 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
AddCSLuaFile()
if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end

ENT.Base 			= "base_gmodentity"
ENT.Type 			= "anim"
ENT.PrintName 		= "FirePlace"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Purpose 		= "Gives a warm feeling, especially in snowy maps."
ENT.Instructions 	= "Don't change anything."
ENT.Category		= "VJ Base"

ENT.Spawnable = true
ENT.AdminOnly = false
---------------------------------------------------------------------------------------------------------------------------------------------
if (CLIENT) then
	function ENT:Draw()
		self:DrawModel()
	end
	---------------------------------------------------------------------------------------------------------------------------------------------
	net.Receive("vj_fireplace_turnon1", function()
		local ent = net.ReadEntity()
		if !IsValid(ent) or ent:GetClass() != "sent_vj_fireplace" then return end
		ent.FireLight1 = DynamicLight(ent:EntIndex())
		if (ent.FireLight1) then
			ent.FireLight1.Pos = ent:GetPos() +ent:GetUp() * 15
			ent.FireLight1.r = 255
			ent.FireLight1.g = 100
			ent.FireLight1.b = 0
			ent.FireLight1.Brightness = 2
			ent.FireLight1.Size = 400
			ent.FireLight1.Decay = 400
			ent.FireLight1.DieTime = CurTime() + 1
		end
	end)
	---------------------------------------------------------------------------------------------------------------------------------------------
	net.Receive("vj_fireplace_turnon2", function()
		local ent = net.ReadEntity()
		if !IsValid(ent) or ent:GetClass() != "sent_vj_fireplace" then return end
		ParticleEffectAttach("env_fire_tiny_smoke",PATTACH_ABSORIGIN_FOLLOW,ent,0)
		ParticleEffectAttach("env_embers_large",PATTACH_ABSORIGIN_FOLLOW,ent,0)
	end)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if !(SERVER) then return end

ENT.FirePlaceOn = false
ENT.FirePlaceDoneParticle = false
ENT.FirePlaceTurnOn2T = 0

util.AddNetworkString("vj_fireplace_turnon1")
util.AddNetworkString("vj_fireplace_turnon2")
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Initialize()
	self:SetModel("models/vj_props/fireplace.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	
	self:SetCollisionBounds(Vector(25,25,25),Vector(-25,-25,1))
	//timer.Simple(0,function() self:SetPos(self:GetPos() +self:GetUp()*-2.5) end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Think()
	if self.FirePlaceOn == true then
		if self.FirePlaceDoneParticle == false then
			self.FirePlaceDoneParticle = true
			net.Start("vj_fireplace_turnon2")
			net.WriteEntity(self)
			net.Broadcast()
		end
		net.Start("vj_fireplace_turnon1")
		net.WriteEntity(self)
		net.Broadcast()
	else
		VJ_STOPSOUND(self.firesd)
		self:StopParticles()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Use(activator, caller)
	if self.FirePlaceOn == false then
		self.FirePlaceOn = true
		self.FirePlaceDoneParticle = false
		self:EmitSound(Sound("ambient/fire/mtov_flame2.wav"),60,100)
		self.firesd = CreateSound(self,"ambient/fire/fire_small_loop1.wav") self.firesd:SetSoundLevel(60)
		self.firesd:PlayEx(1,100)
		activator:PrintMessage(HUD_PRINTTALK, "You turned on the fireplace.") 
	else
		activator:PrintMessage(HUD_PRINTTALK, "You turned off the fireplace.")
		self.FirePlaceOn = false
		self:StopParticles()
		VJ_STOPSOUND(self.firesd)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnTakeDamage(dmginfo)
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Touch(entity)
	if (IsValid(entity) && entity:GetPos():Distance(self:GetPos()) <= 38 && self.FirePlaceOn == true) && (entity:IsNPC() or entity:IsPlayer()) then
		entity:Ignite(math.Rand(3,5))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PhysicsCollide(data, physobj)
	//self:EmitSound("physics/cardboard/cardboard_box_impact_soft"..math.random(1,5)..".wav")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRemove()
	self:StopParticles()
	VJ_STOPSOUND(self.firesd)
end
/*--------------------------------------------------
	*** Copyright (c) 2012-2019 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/