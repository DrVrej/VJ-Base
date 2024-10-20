AddCSLuaFile("shared.lua")
include("shared.lua")
/*--------------------------------------------------
	=============== Projectile Base ===============
	*** Copyright (c) 2012-2024 by DrVrej, All rights reserved. ***
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
ENT.SolidType = SOLID_VPHYSICS
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Collision / Damage Variables ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ENT.RemoveOnHit = true -- Should it remove itself when it touches something? | It will run the hit sound, place a decal, etc.
ENT.PaintDecalOnCollide = true -- Should it paint decals when it collides with something? | Use this only when using a projectile that doesn't get removed when it collides with something
ENT.DecalTbl_OnCollideDecals = {} -- Decals that paint when the projectile collides with something | It picks a random one from this table
ENT.CollideCodeWithoutRemoving = false -- If RemoveOnHit is set to false, you can still make the projectile deal damage, place a decal, etc.
ENT.NextCollideWithoutRemove = VJ.SET(1, 1) -- Time until it can run the code again
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
	-- ====== Sound Paths ====== --
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
ENT.NextSoundTime_Idle = VJ.SET(0.2, 0.5)
	-- ====== Sound Level Variables ====== --
	-- The proper number are usually range from 0 to 180, though it can go as high as 511
	-- More Information: https://developer.valvesoftware.com/wiki/Soundscripts#SoundLevel_Flags
ENT.StartupSoundLevel = 80
ENT.IdleSoundLevel = 80
ENT.OnCollideSoundLevel = 80
ENT.OnRemoveSoundLevel = 90
	-- ====== Sound Pitch Variables ====== --
ENT.StartupSoundPitch = VJ.SET(90, 100)
ENT.IdleSoundPitch = VJ.SET(90, 100)
ENT.OnCollideSoundPitch = VJ.SET(90, 100)
ENT.OnRemoveSoundPitch = VJ.SET(90, 100)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Customization Functions ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- Use the functions below to customize certain parts of the base or to add new custom systems
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PreInit() end
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
function ENT:Init() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink() end
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

local defVec = Vector(0, 0, 0)
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Initialize()
	self:PreInit()
	if self.CustomOnPreInitialize then self:CustomOnPreInitialize() end -- !!!!!!!!!!!!!! DO NOT USE !!!!!!!!!!!!!! [Backwards Compatibility!]
	if self:GetModel() == "models/error.mdl" then self:SetModel(VJ.PICK(self.Model)) end
	self:PhysicsInit(self.PhysicsInitType)
	self:SetMoveType(self.MoveType)
	self:SetMoveCollide(self.MoveCollideType)
	self:SetCollisionGroup(self.CollisionGroupType)
	self:SetSolid(self.SolidType)
	//self:SetTrigger(true)
	self:SetUseType(SIMPLE_USE)
	
	self:CustomOnInitializeBeforePhys()
	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		self:CustomPhysicsObjectOnInitialize(phys)
	end
	
	self:StartupSoundCode()
	if self.IdleSoundPitch1 then self.IdleSoundPitch = VJ.SET(self.IdleSoundPitch1, self.IdleSoundPitch2) end -- !!!!!!!!!!!!!! DO NOT USE THIS VARIABLE !!!!!!!!!!!!!! [Backwards Compatibility!]
	
	self:Init()
	if self.CustomOnInitialize then self:CustomOnInitialize() end -- !!!!!!!!!!!!!! DO NOT USE !!!!!!!!!!!!!! [Backwards Compatibility!]
	if self.CustomOnThink then self.OnThink = function() self:CustomOnThink() end end -- !!!!!!!!!!!!!! DO NOT USE !!!!!!!!!!!!!! [Backwards Compatibility!]
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Think()
	if self.Dead then VJ.STOPSOUND(self.CurrentIdleSound) return end
	
	//self:SetAngles(self:GetVelocity():GetNormal():Angle())
	
	self:OnThink()
	self:IdleSoundCode()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnTakeDamage(dmginfo)
	self:CustomOnTakeDamage(dmginfo)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoDamageCode(data, phys)
	local owner = self:GetOwner()
	local ownerValid = IsValid(owner)
	local dataEnt = data and data.HitEntity
	local hitEnt = nil -- Entity that has been damaged either by direct or radius damages
	local dmgPos = (data != nil and data.HitPos) or self:GetPos()
	if IsValid(dataEnt) && ((dataEnt.IsVJBaseBullseye && dataEnt.VJ_IsBeingControlled) or dataEnt.VJTag_IsControllingNPC) then return end -- Don't damage bulleyes used by the NPC controller OR entities that are controlling others (Usually players)
	
	if self.DoesDirectDamage == true then
		if ownerValid then
			-- Accepts one of the 3 cases:
			-- Entity is not NPC/player
			-- Entity is NPC and not same class and (owner is a player OR not an ally NPC -- Players can still damage NPCs while NPCs can't damage other friendly NPCs)
			-- Entity is player and alive and (owner is player OR (ignore players is off and no target is off) -- Players can still damage each other while NPCs can't when ignore players is on)
			if IsValid(dataEnt) && ((!dataEnt:IsNPC() && !dataEnt:IsPlayer()) or (dataEnt:IsNPC() && dataEnt:GetClass() != owner:GetClass() && (owner:IsPlayer() or (owner:IsNPC() && owner:Disposition(dataEnt) != D_LI))) or (dataEnt:IsPlayer() && dataEnt:Alive() && (owner:IsPlayer() or (!VJ_CVAR_IGNOREPLAYERS && !dataEnt:IsFlagSet(FL_NOTARGET))))) then
				hitEnt = dataEnt
				self:CustomOnDoDamage_Direct(data, phys, hitEnt)
				local dmgInfo = DamageInfo()
				dmgInfo:SetDamage(self.DirectDamage)
				dmgInfo:SetDamageType(self.DirectDamageType)
				dmgInfo:SetAttacker(owner)
				dmgInfo:SetInflictor(self)
				dmgInfo:SetDamagePosition(dmgPos)
				VJ.DamageSpecialEnts(owner, hitEnt, dmgInfo)
				hitEnt:TakeDamageInfo(dmgInfo, self)
			end
		else
			hitEnt = dataEnt
			self:CustomOnDoDamage_Direct(data, phys, hitEnt)
			local dmgInfo = DamageInfo()
			dmgInfo:SetDamage(self.DirectDamage)
			dmgInfo:SetDamageType(self.DirectDamageType)
			dmgInfo:SetAttacker(self)
			dmgInfo:SetInflictor(self)
			dmgInfo:SetDamagePosition(dmgPos)
			VJ.DamageSpecialEnts(self, hitEnt, dmgInfo)
			hitEnt:TakeDamageInfo(dmgInfo, self)
		end
	end
	
	if self.DoesRadiusDamage == true then
		local attackEnt = ownerValid and owner or self -- The entity that will be set as the attacker
		-- If the projectile is picked up (Such as a grenade picked up by a human NPC), then the damage position is the parent's position
		if self.VJTag_IsPickedUp == true then
			local parent = self:GetParent()
			if IsValid(parent) && parent:IsNPC() then
				dmgPos = parent:GetPos()
			end
		end
		hitEnt = VJ.ApplyRadiusDamage(attackEnt, attackEnt, dmgPos, self.RadiusDamageRadius, self.RadiusDamage, self.RadiusDamageType, ownerValid && !owner:IsPlayer(), self.RadiusDamageUseRealisticRadius, {DisableVisibilityCheck=self.RadiusDamageDisableVisibilityCheck, Force=self.RadiusDamageForce, UpForce=self.RadiusDamageForce_Up, DamageAttacker=owner:IsPlayer()})
	end
	
	self:CustomOnDoDamage(data, phys, hitEnt)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PhysicsCollide(data, phys)
	if self.Dead then return end
	//self.Dead = true
	if self:CustomOnPhysicsCollide(data, phys) != false then
		if self.RemoveOnHit == true then
			self.Dead = true
			self:DoDamageCode(data, phys)
			self:OnCollideSoundCode()
			if self.PaintDecalOnDeath == true && VJ.PICK(self.DecalTbl_DeathDecals) != false && self.AlreadyPaintedDeathDecal == false then
				self.AlreadyPaintedDeathDecal = true
				util.Decal(VJ.PICK(self.DecalTbl_DeathDecals), data.HitPos + data.HitNormal, data.HitPos - data.HitNormal)
			end
			if self.ShakeWorldOnDeath == true then util.ScreenShake(data.HitPos, self.ShakeWorldOnDeathAmplitude or 16, self.ShakeWorldOnDeathFrequency or 200, self.ShakeWorldOnDeathDuration or 1, self.ShakeWorldOnDeathRadius or 3000) end -- !!!!!!!!!!!!!! DO NOT USE THIS VARIABLE !!!!!!!!!!!!!! [Backwards Compatibility!]
			self:SetDeathVariablesTrue(data, phys, true)
			if self.DelayedRemove > 0 then
				self:SetNoDraw(true)
				self:SetMoveType(MOVETYPE_NONE)
				self:AddSolidFlags(FSOLID_NOT_SOLID)
				self:SetLocalVelocity(defVec)
				SafeRemoveEntityDelayed(self, self.DelayedRemove)
				self:OnRemove()
			else
				self:Remove()
			end
		end
		
		if self.CollideCodeWithoutRemoving == true && CurTime() > self.NextCollideWithoutRemoveT then
			self:DoDamageCode(data, phys)
			self:OnCollideSoundCode()
			if self.PaintDecalOnCollide == true && VJ.PICK(self.DecalTbl_OnCollideDecals) != false && self.AlreadyPaintedDeathDecal == false then
				util.Decal(VJ.PICK(self.DecalTbl_OnCollideDecals), data.HitPos + data.HitNormal, data.HitPos - data.HitNormal)
			end
			self:CustomOnCollideWithoutRemove(data, phys)
			self.NextCollideWithoutRemoveT = CurTime() + math.Rand(self.NextCollideWithoutRemove.a, self.NextCollideWithoutRemove.b)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRemove()
	self.Dead = true
	VJ.STOPSOUND(self.CurrentIdleSound)
	self:OnRemoveSoundCode()
	self:CustomOnRemove()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetDeathVariablesTrue(data, phys, runDeathEffects)
	self.Dead = true
	self:StopParticles()
	VJ.STOPSOUND(self.CurrentIdleSound)
	if runDeathEffects == true then self:DeathEffects(data, phys or self:GetPhysicsObject()) end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:StartupSoundCode()
	if self.HasStartupSounds == false then return end
	if CurTime() > self.NextIdleSoundT && math.random(1, self.StartupSoundChance) == 1 then
		self.CurrentStartupSound = VJ.CreateSound(self, self.SoundTbl_Startup, self.StartupSoundLevel, math.random(self.StartupSoundPitch.a, self.StartupSoundPitch.b))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:IdleSoundCode()
	if self.HasIdleSounds == false then return end
	if CurTime() > self.NextIdleSoundT then
		if math.random(1, self.IdleSoundChance) == 1 then
			self.CurrentIdleSound = VJ.CreateSound(self, self.SoundTbl_Idle, self.IdleSoundLevel, math.random(self.IdleSoundPitch.a, self.IdleSoundPitch.b))
		end
		self.NextIdleSoundT = CurTime() + math.Rand(self.NextSoundTime_Idle.a ,self.NextSoundTime_Idle.b)
	end
end
--------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnCollideSoundCode()
	if self.HasOnCollideSounds == false then return end
	if math.random(1, self.OnCollideSoundChance) == 1 then
		self.CurrentDeathSound = VJ.CreateSound(self, self.SoundTbl_OnCollide, self.OnCollideSoundLevel, math.random(self.OnCollideSoundPitch.a, self.OnCollideSoundPitch.b))
	end
end
--------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRemoveSoundCode()
	if self.HasOnRemoveSounds == false then return end
	if math.random(1, self.OnRemoveSoundChance) == 1 then
		self.CurrentDeathSound = VJ.CreateSound(self, self.SoundTbl_OnRemove, self.OnRemoveSoundLevel, math.random(self.OnRemoveSoundPitch.a, self.OnRemoveSoundPitch.b))
	end
end