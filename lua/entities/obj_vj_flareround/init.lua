AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.IdleSound1 = Sound("weapons/flaregun/burn.wav")
ENT.TouchSound = Sound("weapons/hegrenade/he_bounce-1.wav")
ENT.TouchSoundv = 75
ENT.Decal = "Scorch"
ENT.AlreadyPaintedDeathDecal = false
ENT.Dead = false
ENT.FussTime = 10
ENT.NextTouchSound = 0
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Initialize()
	//print(self:GetModel())
	if self:GetModel() == "models/error.mdl" then
	self:SetModel("models/items/ar2_grenade.mdl") end
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	//self:SetMoveCollide(COLLISION_GROUP_INTERACTIVE)
	//self:SetCollisionGroup(COLLISION_GROUP_INTERACTIVE)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetOwner(self:GetOwner())
	self:SetColor(Color(255,0,0))
	
	-- Physics Functions
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:EnableGravity(true)
		phys:SetBuoyancyRatio(0)
	end

	-- Misc Functions
	//util.SpriteTrail(self, 0, Color(90,90,90,255), false, 10, 1, 3, 1/(15+1)*0.5, "trails/smoke.vmt")
	//ParticleEffectAttach("vj_rpg1_smoke", PATTACH_ABSORIGIN_FOLLOW, self, 0)
	//ParticleEffectAttach("vj_rpg2_smoke2", PATTACH_ABSORIGIN_FOLLOW, self, 0)
	util.SpriteTrail(self.Entity, 0, Color(155, 0, 0, 150), false, 1, 100, 5, 5 / ((2 + 10) * 0.5), "trails/smoke.vmt")


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
	
	if self:GetOwner():IsValid() && (self:GetOwner().FlareAttackFussTime) then
		timer.Simple(self:GetOwner().FlareAttackFussTime,function() if IsValid(self) then self:DoDeath() end end) else
		timer.Simple(60,function() if IsValid(self) then self:DoDeath() end end)
	end
	
	self.ENVFlare = ents.Create("env_flare")
	self.ENVFlare:SetPos(self:GetPos())
	self.ENVFlare:SetAngles(self:GetAngles())
	self.ENVFlare:SetParent(self)
	self.ENVFlare:SetKeyValue("Scale","5")
	self.ENVFlare:SetKeyValue("spawnflags","4")
	self.ENVFlare:Spawn()
	self.ENVFlare:SetColor(Color(255,0,0))
	
	self.idlesoundc = CreateSound(self, self.IdleSound1)
	self.idlesoundc:SetSoundLevel(60)
	self.idlesoundc:PlayEx(1, 100)
	
	timer.Simple(2,function()
	if IsValid(self) then
		local phys = self.Entity:GetPhysicsObject()
		if (phys:IsValid()) && phys:GetVelocity():Length() > 500 then
		phys:SetMass(0.005)
		timer.Simple(10,function()
			if IsValid(self) then
			phys:SetMass(5)
			end
		end)
	 end
	end
 end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Think()
//print(self:GetOwner())
if self.Dead == true then if self.idlesoundc then self.idlesoundc:Stop() end end
/*if self:IsValid() then
if self.Dead == false then
	self.idlesoundc = CreateSound(self, self.IdleSound1)
	self.idlesoundc:SetSoundLevel(60)
	self.idlesoundc:PlayEx(1, 100)
	end
 end*/
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnTakeDamage(dmginfo)
	self:GetPhysicsObject():AddVelocity(dmginfo:GetDamageForce() * 0.1)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PhysicsCollide(data,physobj)
	if IsValid(data.HitEntity) && (data.HitEntity:IsNPC() or data.HitEntity:IsPlayer()) then
		//data.HitEntity:Ignite(1)
		local damagecode = DamageInfo()
		damagecode:SetDamage(math.random(4,8))
		damagecode:SetDamageType(DMG_BURN)
		damagecode:SetAttacker(self)
		damagecode:SetInflictor(self)
		damagecode:SetDamagePosition(data.HitPos)
		data.HitEntity:TakeDamageInfo(damagecode, self)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoDeath()
	-- Removes
	self.Dead = true
	if self.idlesoundc then self.idlesoundc:Stop() end
	self:StopParticles()

	-- Damages
	timer.Simple(2,function() 
	if self != NULL then 
		self:Remove() 
		end 
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRemove()
	self.Dead = true
	if self.idlesoundc then self.idlesoundc:Stop() end
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/