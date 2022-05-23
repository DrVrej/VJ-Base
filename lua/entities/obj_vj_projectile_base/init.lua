if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
AddCSLuaFile("shared.lua")
include("shared.lua")
/*--------------------------------------------------
	=============== Projectile Base ===============
	*** Copyright (c) 2012-2022 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Core Variables ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ENT.Model = {""} -- The models it should spawn with | Picks a random one from the table
ENT.PhysicsInitType = SOLID_VPHYSICS
ENT.MoveType = MOVETYPE_VPHYSICS
ENT.MoveCollideType = MOVECOLLIDE_FLY_BOUNCE
ENT.CollisionGroupType = COLLISION_GROUP_PROJECTILE
ENT.SolidType = SOLID_CUSTOM
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Collision / Damage Variables ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ENT.RemoveOnHit = true -- Should it remove itself when it touches something? | It will run the hit sound, place a decal, etc.
ENT.PaintDecalOnCollide = true -- Should it paint decals when it collides with something? | Use this only when using a projectile that doesn't get removed when it collides with something
ENT.DecalTbl_OnCollideDecals = {} -- Decals that paint when the projectile collides with something | It picks a random one from this table
ENT.CollideCodeWithoutRemoving = false -- If RemoveOnHit is set to false, you can still make the projectile deal damage, place a decal, etc.
ENT.NextCollideWithoutRemove = VJ_Set(1,1) -- Time until it can run the code again
	-- ====== Shake World On Death Variables ====== --
ENT.ShakeWorldOnDeath = false -- Should the world shake when the projectile hits something?
ENT.ShakeWorldOnDeathAmplitude = 16 -- How much the screen will shake | From 1 to 16, 1 = really low 16 = really high
ENT.ShakeWorldOnDeathRadius = 3000 -- How far the screen shake goes, in world units
ENT.ShakeWorldOnDeathDuration = 1 -- How long the screen shake will last, in seconds
ENT.ShakeWorldOnDeathFrequency = 200 -- The frequency
	-- ====== Radius Damage Variables ====== --
ENT.DoesRadiusDamage = false -- Should it do a blast damage when it hits something?
ENT.RadiusDamageRadius = 250 -- How far the damage go? The farther away it's from its enemy, the less damage it will do | Counted in world units
ENT.RadiusDamageUseRealisticRadius = true -- Should the damage decrease the farther away the enemy is from the position that the projectile hit?
ENT.RadiusDamage = 30 -- How much damage should it deal? Remember this is a radius damage, therefore it will do less damage the farther away the entity is from its enemy
ENT.RadiusDamageType = DMG_BLAST -- Damage type
ENT.RadiusDamageForce = false -- Put the force amount it should apply | false = Don't apply any force
ENT.RadiusDamageForce_Up = false -- How much up force should it have? | false = Let the base automatically decide the force using RadiusDamageForce value
ENT.RadiusDamageDisableVisibilityCheck = false -- Should it disable the visibility check? | true = Disables the visibility check
	-- ====== Direct Damage Variables ====== --
ENT.DoesDirectDamage = false -- Should it do a direct damage when it hits something?
ENT.DirectDamage = 30 -- How much damage should it do when it hits something
ENT.DirectDamageType = DMG_SLASH -- Damage type
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Killed / Remove Variables ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ENT.PaintDecalOnDeath = true -- Should it paint a decal when it hits something?
ENT.DecalTbl_DeathDecals = {} -- Decals that paint when the projectile dies | It picks a random one from this table
ENT.DelayedRemove = 0 -- Change this to a number greater than 0 to delay the removal of the entity
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Sound Variables ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ENT.HasStartupSounds = true -- Does it make a sound when the projectile is created?
ENT.HasIdleSounds = true -- Does it have idle sounds?
ENT.HasOnCollideSounds = true -- Should it play a sound when it collides something?
ENT.HasOnRemoveSounds = true -- Should it play a sound when it gets removed?
	-- ====== File Path Variables ====== --
	-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_Startup = {}
ENT.SoundTbl_Idle = {}
ENT.SoundTbl_OnCollide = {}
ENT.SoundTbl_OnRemove = {}
	-- ====== Sound Chance Variables ====== --
	-- Higher number = less chance of playing | 1 = Always play
ENT.StartupSoundChance = 1
ENT.IdleSoundChance = 1
ENT.OnCollideSoundChance = 1
ENT.OnRemoveSoundChance = 1
	-- ====== Timer Variables ====== --
ENT.NextSoundTime_Idle = VJ_Set(0.2, 0.5)
	-- ====== Sound Level Variables ====== --
	-- The proper number are usually range from 0 to 180, though it can go as high as 511
	-- More Information: https://developer.valvesoftware.com/wiki/Soundscripts#SoundLevel_Flags
ENT.StartupSoundLevel = 80
ENT.IdleSoundLevel = 80
ENT.OnCollideSoundLevel = 80
ENT.OnRemoveSoundLevel = 90
	-- ====== Sound Pitch Variables ====== --
ENT.StartupSoundPitch = VJ_Set(90, 100)
ENT.IdleSoundPitch = VJ_Set(90, 100)
ENT.OnCollideSoundPitch = VJ_Set(90, 100)
ENT.OnRemoveSoundPitch = VJ_Set(90, 100)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Customization Functions ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- Use the functions below to customize certain parts of the base or to add new custom systems
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnPreInitialize() end
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
function ENT:CustomOnPhysicsCollide(data, phys) end -- Return false to disable the base functions from running
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnCollideWithoutRemove(data, phys) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDoDamage(data, phys, hitEnt) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDoDamage_Direct(data, phys, hitEnt) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DeathEffects(data, phys) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRemove() end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ ///// WARNING: Don't touch anything below this line! \\\\\ ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ENT.AlreadyPaintedDeathDecal = false
ENT.Dead = false
ENT.NextIdleSoundT = 0
ENT.NextCollideWithoutRemoveT = 0
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Initialize()
	self:CustomOnPreInitialize()
	if self:GetModel() == "models/error.mdl" then self:SetModel(VJ_PICK(self.Model)) end
	self:PhysicsInit(self.PhysicsInitType)
	self:SetMoveType(self.MoveType)
	self:SetMoveCollide(self.MoveCollideType)
	self:SetCollisionGroup(self.CollisionGroupType)
	self:SetSolid(self.SolidType)
	
	self:CustomOnInitializeBeforePhys()
	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		self:CustomPhysicsObjectOnInitialize(phys)
	end
	
	self:StartupSoundCode()
	if self.IdleSoundPitch1 then self.IdleSoundPitch = VJ_Set(self.IdleSoundPitch1, self.IdleSoundPitch2) end -- !!!!!!!!!!!!!! DO NOT USE THIS VARIABLE !!!!!!!!!!!!!! [Backwards Compatibility!]
	
	self:CustomOnInitialize()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Think()
	if self.Dead == true then VJ_STOPSOUND(self.CurrentIdleSound) return end
	
	//self:SetAngles(self:GetVelocity():GetNormal():Angle())
	
	self:CustomOnThink()
	self:IdleSoundCode()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnTakeDamage(dmginfo)
	self:CustomOnTakeDamage(dmginfo)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoDamageCode(data, phys)
	local owner = self:GetOwner()
	local hitEnt = NULL
	local dmgPos = (data != nil and data.HitPos) or self:GetPos()
	
	if self.DoesDirectDamage == true then
		hitEnt = data.HitEntity
		//if hitEnt:IsNPC() or hitEnt:IsPlayer() then
		if IsValid(owner) then
			if (VJ_IsProp(hitEnt)) or (hitEnt:IsNPC() && (hitEnt:Disposition(owner) == D_HT or hitEnt:Disposition(owner) == D_FR) && hitEnt:Health() > 0 && (hitEnt != owner) && (hitEnt:GetClass() != owner:GetClass())) or (hitEnt:IsPlayer() && GetConVar("ai_ignoreplayers"):GetInt() == 0 && hitEnt:Alive() && hitEnt:Health() > 0) then
				self:CustomOnDoDamage_Direct(data, phys, hitEnt)
				local damagecode = DamageInfo()
				damagecode:SetDamage(self.DirectDamage)
				damagecode:SetDamageType(self.DirectDamageType)
				damagecode:SetAttacker(owner)
				damagecode:SetInflictor(self)
				damagecode:SetDamagePosition(dmgPos)
				hitEnt:TakeDamageInfo(damagecode, self)
				VJ_DestroyCombineTurret(owner, hitEnt)
			end
		else
			self:CustomOnDoDamage_Direct(data, phys, hitEnt)
			local damagecode = DamageInfo()
			damagecode:SetDamage(self.DirectDamage)
			damagecode:SetDamageType(self.DirectDamageType)
			damagecode:SetAttacker(self)
			damagecode:SetInflictor(self)
			damagecode:SetDamagePosition(dmgPos)
			hitEnt:TakeDamageInfo(damagecode, self)
			VJ_DestroyCombineTurret(self, hitEnt)
		end
	end
	
	if self.DoesRadiusDamage == true then
		local DoEntCheck = false
		local attackEnt = owner
		if IsValid(owner) then
			DoEntCheck = !owner:IsPlayer()
		else
			attackEnt = self
		end
		if self.VJ_IsPickedUpDanger == true && IsValid(self:GetParent()) && self:GetParent():IsNPC() then dmgPos = self:GetParent():GetPos() end -- If the projectile is picked up (Such as a grenade picked up by human SNPC), then the damage position is the parent's position
		hitEnt = util.VJ_SphereDamage(attackEnt, attackEnt, dmgPos, self.RadiusDamageRadius, self.RadiusDamage, self.RadiusDamageType, DoEntCheck, self.RadiusDamageUseRealisticRadius, {DisableVisibilityCheck=self.RadiusDamageDisableVisibilityCheck, Force=self.RadiusDamageForce, UpForce=self.RadiusDamageForce_Up, DamageAttacker=owner:IsPlayer()})
	end
	
	self:CustomOnDoDamage(data, phys, hitEnt)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PhysicsCollide(data, phys)
	if self.Dead == true then return end
	//self.Dead = true
	if self:CustomOnPhysicsCollide(data, phys) != false then
		if self.RemoveOnHit == true then
			self.Dead = true
			self:DoDamageCode(data, phys)
			self:OnCollideSoundCode()
			if self.PaintDecalOnDeath == true && VJ_PICK(self.DecalTbl_DeathDecals) != false && self.AlreadyPaintedDeathDecal == false then
				self.AlreadyPaintedDeathDecal = true
				util.Decal(VJ_PICK(self.DecalTbl_DeathDecals), data.HitPos + data.HitNormal, data.HitPos - data.HitNormal)
			end
			if self.ShakeWorldOnDeath == true then util.ScreenShake(data.HitPos, self.ShakeWorldOnDeathAmplitude, self.ShakeWorldOnDeathFrequency, self.ShakeWorldOnDeathDuration, self.ShakeWorldOnDeathRadius) end
			self:SetDeathVariablesTrue(data, phys, true)
			if self.DelayedRemove > 0 then
				self:SetNoDraw(true)
				self:SetMoveType(MOVETYPE_NONE)
				self:AddSolidFlags(FSOLID_NOT_SOLID)
				self:SetLocalVelocity(Vector())
				SafeRemoveEntityDelayed(self, self.DelayedRemove)
				self:OnRemove()
			else
				self:Remove()
			end
		end
		
		if self.CollideCodeWithoutRemoving == true && CurTime() > self.NextCollideWithoutRemoveT then
			self:DoDamageCode(data, phys)
			self:OnCollideSoundCode()
			if self.PaintDecalOnCollide == true && VJ_PICK(self.DecalTbl_OnCollideDecals) != false && self.AlreadyPaintedDeathDecal == false then
				util.Decal(VJ_PICK(self.DecalTbl_OnCollideDecals), data.HitPos + data.HitNormal, data.HitPos - data.HitNormal)
			end
			self:CustomOnCollideWithoutRemove(data, phys)
			self.NextCollideWithoutRemoveT = CurTime() + math.Rand(self.NextCollideWithoutRemove.a, self.NextCollideWithoutRemove.b)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRemove()
	self.Dead = true
	VJ_STOPSOUND(self.CurrentIdleSound)
	self:OnRemoveSoundCode()
	self:CustomOnRemove()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetDeathVariablesTrue(data, phys, RunDeathEffects)
	self.Dead = true
	self:StopParticles()
	VJ_STOPSOUND(self.CurrentIdleSound)
	if RunDeathEffects == true then self:DeathEffects(data, phys or self:GetPhysicsObject()) end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:StartupSoundCode()
	if self.HasStartupSounds == false then return end
	if CurTime() > self.NextIdleSoundT && math.random(1, self.StartupSoundChance) == 1 then
		self.CurrentStartupSound = VJ_CreateSound(self, self.SoundTbl_Startup, self.StartupSoundLevel, math.random(self.StartupSoundPitch.a, self.StartupSoundPitch.b))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:IdleSoundCode()
	if self.HasIdleSounds == false then return end
	if CurTime() > self.NextIdleSoundT then
		if math.random(1, self.IdleSoundChance) == 1 then
			self.CurrentIdleSound = VJ_CreateSound(self, self.SoundTbl_Idle, self.IdleSoundLevel, math.random(self.IdleSoundPitch.a, self.IdleSoundPitch.b))
		end
		self.NextIdleSoundT = CurTime() + math.Rand(self.NextSoundTime_Idle.a ,self.NextSoundTime_Idle.b)
	end
end
--------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnCollideSoundCode()
	if self.HasOnCollideSounds == false then return end
	if math.random(1, self.OnCollideSoundChance) == 1 then
		self.CurrentDeathSound = VJ_CreateSound(self, self.SoundTbl_OnCollide, self.OnCollideSoundLevel, math.random(self.OnCollideSoundPitch.a, self.OnCollideSoundPitch.b))
	end
end
--------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRemoveSoundCode()
	if self.HasOnRemoveSounds == false then return end
	if math.random(1, self.OnRemoveSoundChance) == 1 then
		self.CurrentDeathSound = VJ_CreateSound(self, self.SoundTbl_OnRemove, self.OnRemoveSoundLevel, math.random(self.OnRemoveSoundPitch.a, self.OnRemoveSoundPitch.b))
	end
end