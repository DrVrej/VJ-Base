/*--------------------------------------------------
	*** Copyright (c) 2012-2024 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
AddCSLuaFile()

ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= "Flare Round"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Information		= "Projectile, usually used for NPCs & Weapons"
ENT.Category		= "VJ Base"

ENT.Spawnable = true
ENT.AdminOnly = false
---------------------------------------------------------------------------------------------------------------------------------------------
if CLIENT then
	language.Add("obj_vj_flareround", "Flare Round")
	killicon.Add("obj_vj_flareround","HUD/killicons/default",Color(255,80,0,255))

	language.Add("#obj_vj_flareround", "Flare Round")
	killicon.Add("#obj_vj_flareround","HUD/killicons/default",Color(255,80,0,255))
	
	function ENT:Draw()
		//self:DrawModel()
	end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if !SERVER then return end

ENT.FuseTime = 60
---------------------------------------------------------------------------------------------------------------------------------------------
local colorRed = Color(255, 0, 0)
local colorTrailRed = Color(155, 0, 0, 150)
--
function ENT:Initialize()
	self:SetModel("models/items/ar2_grenade.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetColor(colorRed)
	self:SetUseType(SIMPLE_USE)
	self:SetModelScale(0.5)

	-- Physics
	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:Wake()
		phys:EnableGravity(true)
		phys:SetBuoyancyRatio(0)
	end

	-- Effects
	//util.SpriteTrail(self, 0, Color(90,90,90,255), false, 10, 1, 3, 1/(15+1)*0.5, "trails/smoke.vmt")
	//ParticleEffectAttach("vj_rpg1_smoke", PATTACH_ABSORIGIN_FOLLOW, self, 0)
	//ParticleEffectAttach("vj_rpg2_smoke2", PATTACH_ABSORIGIN_FOLLOW, self, 0)
	util.SpriteTrail(self, 0, colorTrailRed, false, 1, 100, 5, 5 / ((2 + 10) * 0.5), "trails/smoke.vmt")

	-- No longer needed, light is created by env_flare
	/*self.StartLight1 = ents.Create("light_dynamic")
	self.StartLight1:SetKeyValue("brightness", "0.01")
	self.StartLight1:SetKeyValue("distance", "1500")
	self.StartLight1:SetLocalPos(self:GetPos())
	self.StartLight1:SetLocalAngles( self:GetAngles() )
	self.StartLight1:Fire("Color", "255 0 0")
	self.StartLight1:SetParent(self)
	self.StartLight1:Spawn()
	self.StartLight1:Activate()
	self.StartLight1:Fire("TurnOn", "", 0)
	self:DeleteOnRemove(self.StartLight1)*/

	local envFlare = ents.Create("env_flare")
	envFlare:SetPos(self:GetPos())
	envFlare:SetAngles(self:GetAngles())
	envFlare:SetParent(self)
	envFlare:SetKeyValue("Scale","5")
	envFlare:SetKeyValue("spawnflags","4")
	envFlare:Spawn()
	envFlare:Fire("Start", tostring(self.FuseTime))
	envFlare:SetOwner(self)
	
	envFlare:SetColor(colorRed)

	self.CurrentIdleSound = CreateSound(self, "weapons/flaregun/burn.wav")
	self.CurrentIdleSound:SetSoundLevel(60)
	self.CurrentIdleSound:PlayEx(1, 100)
	
	-- Make it drop after some time in the air
	timer.Simple(2, function()
		if IsValid(self) then
			phys = self:GetPhysicsObject()
			if IsValid(phys) && phys:GetVelocity():Length() > 500 then
				phys:SetMass(0.005)
				timer.Simple(10, function()
					if IsValid(self) then
						phys:SetMass(5)
					end
				end)
			end
		end
	end)
	
	-- Remove after fuse time
	timer.Simple(self.FuseTime, function()
		if IsValid(self) then
			self:Remove()
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Use(activator, caller)
	if IsValid(activator) && activator:IsPlayer() then
		activator:PickupObject(self)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PhysicsCollide(data, physobj)
	-- Make players and NPCs take damage
	local hitEnt = data.HitEntity
	if IsValid(hitEnt) && (hitEnt:IsNPC() or hitEnt:IsPlayer()) then
		//hitEnt:Ignite(1)
		local dmg = DamageInfo()
		dmg:SetDamage(math.random(4, 8))
		dmg:SetDamageType(DMG_BURN)
		dmg:SetAttacker(self)
		dmg:SetInflictor(self)
		dmg:SetDamagePosition(data.HitPos)
		hitEnt:TakeDamageInfo(dmg, self)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnTakeDamage(dmginfo)
	self:GetPhysicsObject():AddVelocity(dmginfo:GetDamageForce() * 0.1)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRemove()
	if self.CurrentIdleSound then self.CurrentIdleSound:Stop() end
	self:StopParticles()
end