if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")
/*--------------------------------------------------
	=============== Projectile Base ===============
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
INFO: Used to make projectiles.
--------------------------------------------------*/
	-- General ---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Model = {""} -- The models it should spawn with | Picks a random one from the table
ENT.PhysicsInitType = SOLID_VPHYSICS
ENT.MoveType = MOVETYPE_VPHYSICS -- Move type, recommended to keep it as it is
ENT.MoveCollideType = MOVECOLLIDE_DEFAULT -- Move type | Some examples: MOVECOLLIDE_FLY_BOUNCE, MOVECOLLIDE_FLY_SLIDE
ENT.CollisionGroupType = COLLISION_GROUP_PROJECTILE -- Collision type, recommended to keep it as it is
ENT.SolidType = SOLID_CUSTOM -- Solid type, recommended to keep it as it is
ENT.ShouldSetOwner = true -- Should it set a owner?
ENT.RemoveOnHit = true -- Should it remove itself when it touches something? | It will run the hit sound, place a decal, etc.
ENT.PaintDecalOnCollide = true -- Should it paint decals when it collides with something? | Use this only when using a projectile that doesn't get removed when it collides with something
ENT.DecalTbl_OnCollideDecals = {} -- Decals that paint when the projectile collides with something | It picks a random one from this table
ENT.CollideCodeWithoutRemoving = false -- If RemoveOnHit is set to false, you can still make the projectile deal damage, place a decal, etc.
ENT.NextCollideCodeWithoutRemovingTime1 = 1 -- Time until it can run the code again | First number in math.random
ENT.NextCollideCodeWithoutRemovingTime2 = 1 -- Time until it can run the code again | Second number in math.random
ENT.ShakeWorldOnDeath = false -- Should the world shake when the projectile hits something?
ENT.ShakeWorldOnDeathAmplitude = 16 -- How much the screen will shake | From 1 to 16, 1 = really low 16 = really high
ENT.ShakeWorldOnDeathRadius = 3000 -- How far the screen shake goes, in world units
ENT.ShakeWorldOnDeathtDuration = 1 -- How long the screen shake will last, in seconds
ENT.ShakeWorldOnDeathFrequency = 200 -- The frequency
ENT.DoesRadiusDamage = false -- Should it do a blast damage when it hits something?
ENT.RadiusDamageRadius = 250 -- How far the damage go? The farther away it's from its enemy, the less damage it will do | Counted in world units
ENT.RadiusDamageUseRealisticRadius = true -- Should the damage decrease the farther away the enemy is from the position that the projectile hit?
ENT.RadiusDamage = 30 -- How much damage should it deal? Remember this is a radius damage, therefore it will do less damage the farther away the entity is from its enemy
ENT.RadiusDamageType = DMG_BLAST -- Damage type
ENT.RadiusDamageForce = false -- Put the force amount it should apply | false = Don't apply any force
ENT.RadiusDamageForce_Up = false -- How much up force should it have? | false = Let the base automatically decide the force using RadiusDamageForce value
ENT.DoesDirectDamage = false -- Should it do a direct damage when it hits something?
ENT.DirectDamage = 30 -- How much damage should it do when it hits something
ENT.DirectDamageType = DMG_SLASH -- Damage type
ENT.PaintDecalOnDeath = true -- Should it paint a decal when it hits something?
ENT.DecalTbl_DeathDecals = {} -- Decals that paint when the projectile dies | It picks a random one from this table
	-- Sounds ---------------------------------------------------------------------------------------------------------------------------------------------
ENT.HasStartupSounds = true -- Does it make a sound when the projectile is created?
ENT.SoundTbl_Startup = {}
ENT.StartupSoundChance = 1 -- How much chance to play the sound? 1 = always
ENT.StartupSoundLevel = 80
ENT.StartupSoundPitch1 = 80
ENT.StartupSoundPitch2 = 100
ENT.HasIdleSounds = true -- Does it have idle sounds?
ENT.SoundTbl_Idle = {}
ENT.IdleSoundChance = 1 -- How much chance to play the sound? 1 = always
ENT.IdleSoundLevel = 80
ENT.IdleSoundPitch1 = 80
ENT.IdleSoundPitch2 = 100
ENT.NextSoundTime_Idle1 = 0.2
ENT.NextSoundTime_Idle2 = 0.5
ENT.HasOnCollideSounds = true -- Should it play a sound when it collides something?
ENT.SoundTbl_OnCollide = {}
ENT.OnCollideSoundChance = 1 -- How much chance to play the sound? 1 = always
ENT.OnCollideSoundLevel = 80
ENT.OnCollideSoundPitch1 = 80
ENT.OnCollideSoundPitch2 = 100
	-- Independent Variables ---------------------------------------------------------------------------------------------------------------------------------------------
ENT.AlreadyPaintedDeathDecal = false
ENT.Dead = false
ENT.NextIdleSoundT = 0
ENT.NextCollideCodeWithoutRemovingT = 0
ENT.ParentsEnemy = nil
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitializeBeforePhys() /* Example: self:PhysicsInitSphere(1, "metal_bouncy") */ end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomPhysicsObjectOnInitialize(phys)
	phys:Wake()
	phys:EnableGravity(false)
	phys:EnableDrag(false)
	phys:SetBuoyancyRatio(0)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage(dmginfo) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnPhysicsCollide(data,phys) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnCollideWithoutRemove(data,phys) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDoDamage(data,phys,hitent) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DeathEffects(data,phys) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRemove() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Initialize()
	if self:GetModel() == "models/error.mdl" then
	self:SetModel(VJ_PICKRANDOMTABLE(self.Model)) end
	self:PhysicsInit(self.PhysicsInitType)
	self:SetMoveType(self.MoveType)
	self:SetMoveCollide(self.MoveCollideType)
	self:SetCollisionGroup(self.CollisionGroupType)
	self:SetSolid(self.SolidType)
	if self.ShouldSetOwner == true then 
		self:SetOwner(self:GetOwner())
		self.GetOwnerIndex = self:GetOwner()
	end
	
	self:CustomOnInitializeBeforePhys()

	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		self:CustomPhysicsObjectOnInitialize(phys)
	end
	
	if self.HasStartupSounds == true then self:StartupSoundCode() end
	
	self:CustomOnInitialize()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Think()
	if !IsValid(self) then return end
	if self.Dead == true then VJ_STOPSOUND(self.CurrentIdleSound) return end
	
	//self:SetAngles(self:GetVelocity():GetNormal():Angle())
	if IsValid(self.Owner) && self.Owner:IsNPC() then self.ParentsEnemy = self.Owner:GetEnemy() end

	//print(self:GetOwner())
	self:CustomOnThink()
	self:IdleSoundCode()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnTakeDamage(dmginfo)
	self:CustomOnTakeDamage(dmginfo)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoDamageCode(data,phys)
	local gethitpos = self:GetPos()
	local hitent = NULL
	if data != nil then
		gethitpos = data.HitPos
	end
	
	if self.DoesRadiusDamage == true then
		local DoEntCheck = true
		local DamageAttacker = true
		local AttackEnt = self:GetOwner()
		if self:GetOwner():IsPlayer() == true then DoEntCheck = false DamageAttacker = true end
		if self.VJHumanTossingAway == true && IsValid(self:GetParent()) && self:GetParent():IsNPC() then gethitpos = self:GetParent():GetPos() end
		if self:GetOwner() == NULL then AttackEnt = self DoEntCheck = false end
		//util.VJ_SphereDamage(AttackEnt,AttackEnt,gethitpos,self.RadiusDamageRadius,self.RadiusDamage,self.RadiusDamageType,DoEntCheck,self.RadiusDamageUseRealisticRadius,self.RadiusDamageForce,self.RadiusDamageForceTowardsRagdolls,self.RadiusDamageForceTowardsPhysics)
		hitent = util.VJ_SphereDamage(AttackEnt,AttackEnt,gethitpos,self.RadiusDamageRadius,self.RadiusDamage,self.RadiusDamageType,DoEntCheck,self.RadiusDamageUseRealisticRadius,{Force=self.RadiusDamageForce,UpForce=self.RadiusDamageForce_Up,DamageAttacker=DamageAttacker})
	end
	
	if self.DoesDirectDamage == true then
		hitent = data.HitEntity
		//if hitent:IsNPC() or hitent:IsPlayer() then
		if self:GetOwner() != NULL then
			if (VJ_IsProp(hitent)) or (hitent:IsNPC() && (hitent:Disposition(self:GetOwner()) == 1 or hitent:Disposition(self:GetOwner()) == 2) && hitent:Health() > 0 && (hitent != self:GetOwner()) && (hitent:GetClass() != self:GetOwner():GetClass())) or (hitent:IsPlayer() && GetConVarNumber("ai_ignoreplayers") == 0 && hitent:Alive() && hitent:Health() > 0) then
				local damagecode = DamageInfo()
				damagecode:SetDamage(self.DirectDamage)
				damagecode:SetDamageType(self.DirectDamageType)
				damagecode:SetAttacker(self:GetOwner())
				damagecode:SetAttacker(self:GetOwner())
				damagecode:SetDamagePosition(data.HitPos)
				hitent:TakeDamageInfo(damagecode, self)
				VJ_DestroyCombineTurret(self:GetOwner(),hitent)
			end
		else
			local damagecode = DamageInfo()
			damagecode:SetDamage(self.DirectDamage)
			damagecode:SetDamageType(self.DirectDamageType)
			damagecode:SetAttacker(self)
			damagecode:SetInflictor(self)
			damagecode:SetDamagePosition(data.HitPos)
			hitent:TakeDamageInfo(damagecode, self)
			VJ_DestroyCombineTurret(self,hitent)
		end
	end
	self:CustomOnDoDamage(data,phys,hitent)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PhysicsCollide(data,phys)
	//self.Dead = true
	self:CustomOnPhysicsCollide(data,phys)
	
	if self.RemoveOnHit == true then
		if self.Dead == false then
			self.Dead = true
			self:DoDamageCode(data,phys)
			if self.PaintDecalOnDeath == true && VJ_PICKRANDOMTABLE(self.DecalTbl_DeathDecals) != false then
				timer.Simple(0.07,function() if IsValid(self) then if self.AlreadyPaintedDeathDecal == false then self.AlreadyPaintedDeathDecal = true util.Decal(VJ_PICKRANDOMTABLE(self.DecalTbl_DeathDecals), data.HitPos +data.HitNormal, data.HitPos -data.HitNormal) end end
			 end)
			end
			if self.ShakeWorldOnDeath == true then util.ScreenShake(data.HitPos, self.ShakeWorldOnDeathAmplitude, self.ShakeWorldOnDeathFrequency, self.ShakeWorldOnDeathtDuration, self.ShakeWorldOnDeathRadius) end
			self:OnCollideSoundCode()
		end
		self:SetDeathVariablesTrue(data,phys,true)
		timer.Simple(0.07,function() if IsValid(self) then self:Remove() end end)
	end
	
	if self.Dead == false && self.CollideCodeWithoutRemoving == true && CurTime() > self.NextCollideCodeWithoutRemovingT then
		self:DoDamageCode(data,phys)
		self:OnCollideSoundCode()
		if self.PaintDecalOnCollide == true && VJ_PICKRANDOMTABLE(self.DecalTbl_OnCollideDecals) != false && self.AlreadyPaintedDeathDecal == false then
			util.Decal(VJ_PICKRANDOMTABLE(self.DecalTbl_OnCollideDecals), data.HitPos +data.HitNormal, data.HitPos -data.HitNormal)
		end
		self:CustomOnCollideWithoutRemove(data,phys)
		self.NextCollideCodeWithoutRemovingT = CurTime() + math.Rand(self.NextCollideCodeWithoutRemovingTime1,self.NextCollideCodeWithoutRemovingTime2)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRemove()
	self.Dead = true
	VJ_STOPSOUND(self.CurrentIdleSound)
	self:CustomOnRemove()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetDeathVariablesTrue(data,phys,RunDeathEffects)
	local gethitpos = self:GetPos()
	local getphys = self:GetPhysicsObject()
	if data != nil then gethitpos = data end
	if getphys != nil then getphys = phys end
	
	self.Dead = true
	self:StopParticles()
	VJ_STOPSOUND(self.CurrentIdleSound)
	if RunDeathEffects == true then self:DeathEffects(gethitpos,getphys) end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:StartupSoundCode()
	if self.HasIdleSounds == false then return end
	if CurTime() > self.NextIdleSoundT then
		local randomstartupsound = math.random(1,self.StartupSoundChance)
		if randomstartupsound == 1 then
			self.CurrentStartupSound = VJ_CreateSound(self,self.SoundTbl_Startup,self.StartupSoundLevel,math.random(self.StartupSoundPitch1,self.StartupSoundPitch2))
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:IdleSoundCode()
	if self.HasIdleSounds == false then return end
	if CurTime() > self.NextIdleSoundT then
		local randomidlesound = math.random(1,self.IdleSoundChance)
		if randomidlesound == 1 /*&& self:VJ_IsPlayingSoundFromTable(self.SoundTbl_Idle) == false*/ then
			self.CurrentIdleSound = VJ_CreateSound(self,self.SoundTbl_Idle,self.IdleSoundLevel,math.random(self.IdleSoundPitch1,self.IdleSoundPitch2))
		end
		self.NextIdleSoundT = CurTime() + math.Rand(self.NextSoundTime_Idle1,self.NextSoundTime_Idle2)
	end
end
--------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnCollideSoundCode()
	if self.HasOnCollideSounds == false then return end
	local randomdeathsound = math.random(1,self.OnCollideSoundChance)
	if randomdeathsound == 1 then
		self.CurrentDeathSound = VJ_CreateSound(self,self.SoundTbl_OnCollide,self.OnCollideSoundLevel,math.random(self.OnCollideSoundPitch1,self.OnCollideSoundPitch2))
	end
end
/*--------------------------------------------------
	=============== Projectile Base ===============
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
INFO: Used to make projectiles.
--------------------------------------------------*/