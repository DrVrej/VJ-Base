/*--------------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
AddCSLuaFile()

ENT.Base 			= "base_anim"
ENT.Type 			= "anim"
ENT.PrintName 		= "Campfire"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Purpose 		= "Gives a warm feeling, especially in snowy maps."
ENT.Instructions 	= "Don't change anything."
ENT.Category		= "VJ Base"

ENT.Spawnable = true
ENT.AdminOnly = false

scripted_ents.Alias("sent_vj_fireplace", "sent_vj_campfire") -- !! Backwards Compatibility !!
---------------------------------------------------------------------------------------------------------------------------------------------
if CLIENT then
	ENT.NextActivationCheckT = 0
	ENT.NextFireLightT = 0
	ENT.DoneFireParticles = false
	---------------------------------------------------------------------------------------------------------------------------------------------
	function ENT:Draw()
		self:DrawModel()
	end
	---------------------------------------------------------------------------------------------------------------------------------------------
	function ENT:Think()
		local curTime = CurTime()
		if curTime > self.NextActivationCheckT then
			if self:GetNW2Bool("VJ_FirePlace_Activated") == true then
				if !self.DoneFireParticles then
					self.DoneFireParticles = true
					ParticleEffectAttach("env_fire_tiny_smoke", PATTACH_ABSORIGIN_FOLLOW, self, 0)
					ParticleEffectAttach("env_embers_large", PATTACH_ABSORIGIN_FOLLOW, self, 0)
				end
				if curTime > self.NextFireLightT then
					local dynLight = DynamicLight(self:EntIndex())
					if (dynLight) then
						dynLight.Pos = self:GetPos() + self:GetUp() * 15
						dynLight.R = 255
						dynLight.G = 100
						dynLight.B = 0
						dynLight.Brightness = 2
						dynLight.Size = 400
						dynLight.Decay = 400
						dynLight.DieTime = curTime + 1
					end
					self.NextFireLightT = curTime + 0.2
				end
			else
				self.DoneFireParticles = false
			end
			self.NextActivationCheckT = curTime + 0.1
		end
	end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if !SERVER then return end

ENT.IsOn = false
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Initialize()
	self:SetNW2Bool("VJ_FirePlace_Activated", false)
	self:SetModel("models/vj_base/fireplace.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	
	self:SetCollisionBounds(Vector(25, 25, 25), Vector(-25, -25, 1))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Think()
	if !self.IsOn then
		VJ.STOPSOUND(self.fireLoopSD)
		self:StopParticles()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Use(activator, caller)
	if self.IsOn == false then
		self:SetNW2Bool("VJ_FirePlace_Activated", true)
		self.IsOn = true
		self:EmitSound("ambient/fire/mtov_flame2.wav", 60, 100)
		self.fireLoopSD = CreateSound(self, "ambient/fire/fire_small_loop1.wav")
		self.fireLoopSD:SetSoundLevel(60)
		self.fireLoopSD:PlayEx(1,100)
		activator:PrintMessage(HUD_PRINTTALK, "#vjbase.print.fireplace.activated") 
	else
		self:SetNW2Bool("VJ_FirePlace_Activated", false)
		self.IsOn = false
		self:StopParticles()
		VJ.STOPSOUND(self.fireLoopSD)
		activator:PrintMessage(HUD_PRINTTALK, "#vjbase.print.fireplace.deactivated")
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Touch(entity)
	if IsValid(entity) && entity:GetPos():Distance(self:GetPos()) <= 38 && self.IsOn && (entity:IsNPC() or entity:IsPlayer() or entity:IsNextBot()) then
		entity:Ignite(math.Rand(3, 5))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRemove()
	self:StopParticles()
	VJ.STOPSOUND(self.fireLoopSD)
end