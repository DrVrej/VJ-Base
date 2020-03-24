/*--------------------------------------------------
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
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
	ENT.NextActivationCheckT = 0
	ENT.NextFireLightT = 0
	ENT.DoneFireParticles = false
	
	function ENT:Draw()
		self:DrawModel()
	end
	
	function ENT:Think()
		if CurTime() > self.NextActivationCheckT then
			if self:GetNWBool("VJ_FirePlace_Activated") == true then
				if self.DoneFireParticles == false then
					self.DoneFireParticles = true
					ParticleEffectAttach("env_fire_tiny_smoke",PATTACH_ABSORIGIN_FOLLOW,self,0)
					ParticleEffectAttach("env_embers_large",PATTACH_ABSORIGIN_FOLLOW,self,0)
				end
				if CurTime() > self.NextFireLightT then
					local FireLight1 = DynamicLight(self:EntIndex())
					if (FireLight1) then
						FireLight1.Pos = self:GetPos() +self:GetUp() * 15
						FireLight1.R = 255
						FireLight1.G = 100
						FireLight1.B = 0
						FireLight1.Brightness = 2
						FireLight1.Size = 400
						FireLight1.Decay = 400
						FireLight1.DieTime = CurTime() + 1
					end
					self.NextFireLightT = CurTime() + 0.2
				end
			else
				self.DoneFireParticles = false
			end
			self.NextActivationCheckT = CurTime() + 0.1
		end
	end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if !(SERVER) then return end

ENT.FirePlaceOn = false

---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Initialize()
	self:SetNWBool("VJ_FirePlace_Activated", false)
	self:SetModel("models/vj_props/fireplace.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	
	self:SetCollisionBounds(Vector(25,25,25),Vector(-25,-25,1))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Think()
	if self.FirePlaceOn == false then
		VJ_STOPSOUND(self.firesd)
		self:StopParticles()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Use(activator, caller)
	if self.FirePlaceOn == false then
		self:SetNWBool("VJ_FirePlace_Activated", true)
		self.FirePlaceOn = true
		self:EmitSound(Sound("ambient/fire/mtov_flame2.wav"),60,100)
		self.firesd = CreateSound(self,"ambient/fire/fire_small_loop1.wav") self.firesd:SetSoundLevel(60)
		self.firesd:PlayEx(1,100)
		activator:PrintMessage(HUD_PRINTTALK, "You turned on the fireplace.") 
	else
		self:SetNWBool("VJ_FirePlace_Activated", false)
		self.FirePlaceOn = false
		self:StopParticles()
		VJ_STOPSOUND(self.firesd)
		activator:PrintMessage(HUD_PRINTTALK, "You turned off the fireplace.")
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
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/