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
ENT.Information 	= "Gives a warm feeling, especially in cold maps."
ENT.Category		= "VJ Base"
ENT.Spawnable		= true

scripted_ents.Alias("sent_vj_fireplace", "sent_vj_campfire") -- !! Backwards Compatibility !!
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetupDataTables()
	self:NetworkVar("Bool", "Activated")
	if SERVER then
		self:SetActivated(false)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
if CLIENT then
	ENT.NextActivationCheckT = 0
	ENT.CreatedParticles = false
	---------------------------------------------------------------------------------------------------------------------------------------------
	function ENT:Draw()
		self:DrawModel()
	end
	---------------------------------------------------------------------------------------------------------------------------------------------
	function ENT:Think()
		local curTime = CurTime()
		if curTime > self.NextActivationCheckT then
			if self:GetActivated() then
				-- Needs to be done here instead of server side due to a GMod bug where particles don't show for the server host and certain clients while in multiplayer
				if !self.CreatedParticles then
					ParticleEffectAttach("env_fire_tiny_smoke", PATTACH_ABSORIGIN_FOLLOW, self, 0)
					ParticleEffectAttach("env_embers_large", PATTACH_ABSORIGIN_FOLLOW, self, 0)
					self.CreatedParticles = true
				end
				local dynLight = DynamicLight(self:EntIndex())
				if dynLight then
					dynLight.pos = self:GetPos() + self:GetUp() * 15
					dynLight.r = 255
					dynLight.g = 100
					dynLight.b = 0
					dynLight.brightness = 2
					dynLight.size = 400
					dynLight.decay = 400
					dynLight.dietime = curTime + 1
				end
			elseif self.CreatedParticles then
				self:StopParticles() -- Sometimes server side call doesn't work while in multiplayer
				self.CreatedParticles = false
			end
			self.NextActivationCheckT = curTime + 0.2
		end
	end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if !SERVER then return end

ENT.IsOn = false
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Initialize()
	self:SetModel("models/vj_base/fireplace.mdl")
	//self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:SetCollisionBounds(Vector(25, 25, 25), Vector(-25, -25, 1))
	
	-- Supports spawning it activated (such as saves or duplicator)
	if self:GetActivated() then
		self:CampfireToggle(true)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CampfireToggle(activate)
	if activate then
		self:SetActivated(true)
		self.IsOn = true
		self:EmitSound("ambient/fire/ignite.wav", 60, 100)
		self.CurrentFireSound = CreateSound(self, "ambient/fire/fire_small_loop1.wav")
		self.CurrentFireSound:SetSoundLevel(60)
		self.CurrentFireSound:PlayEx(1, 100)
	else
		self:SetActivated(false)
		self.IsOn = false
		self:EmitSound("ambient/fire/mtov_flame2.wav", 60, 100)
		self:StopParticles()
		VJ.STOPSOUND(self.CurrentFireSound)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Use(activator, caller, useType, value)
	if !self.IsOn then
		self:CampfireToggle(true)
		if IsValid(activator) then
			activator:PrintMessage(HUD_PRINTTALK, "#vjbase.campfire.print.activated")
		end
	else
		self:CampfireToggle(false)
		if IsValid(activator) then
			activator:PrintMessage(HUD_PRINTTALK, "#vjbase.campfire.print.deactivated")
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Touch(entity)
	if IsValid(entity) && self.IsOn && entity.VJ_ID_Living && entity:GetPos():Distance(self:GetPos()) <= 38 then
		entity:Ignite(math.Rand(3, 5))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRemove()
	self:StopParticles()
	VJ.STOPSOUND(self.CurrentFireSound)
end