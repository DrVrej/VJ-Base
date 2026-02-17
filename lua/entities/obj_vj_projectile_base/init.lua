AddCSLuaFile("shared.lua")
include("shared.lua")
/*--------------------------------------------------
	=============== Projectile Base ===============
	*** Copyright (c) 2012-2026 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Core ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ENT.Model = false -- Model(s) to spawn with | Picks a random one if it's a table
ENT.ProjectileType = VJ.PROJ_TYPE_LINEAR -- What type of projectile is this?
ENT.CollisionBehavior = VJ.PROJ_COLLISION_REMOVE -- What should it do when it collides with something?
ENT.CollisionFilter = true -- Should the projectile attempt to go through certain entities when the owner is an NPC? | Examples: Entity is an ally or a player with no target
ENT.CollisionDecal = false -- Decals that paint when the projectile collides with something (string or table of strings) | false = to not paint anything
ENT.RemoveDelay = 0 -- Setting this greater than 0 will delay the entity's removal | Useful for lingering trail effects
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Damage ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- ====== Radius Damage ====== --
ENT.DoesRadiusDamage = false -- Should it deal radius damage when it collides with something?
ENT.RadiusDamageRadius = 250
ENT.RadiusDamageUseRealisticRadius = true -- Should the damage decrease the farther away the hit entity is from the radius origin?
ENT.RadiusDamage = 30
ENT.RadiusDamageType = DMG_BLAST
ENT.RadiusDamageForce = false -- Damage force to apply to the hit entity | false = Don't apply any force
ENT.RadiusDamageForce_Up = false -- How much up force should it have? | false = Let the base automatically decide the force using RadiusDamageForce value
ENT.RadiusDamageDisableVisibilityCheck = false -- Should it disable the visibility check? | true = Disables the visibility check
	-- ====== Direct Damage ====== --
ENT.DoesDirectDamage = false -- Should it deal direct damage when it collides with something?
ENT.DirectDamage = 30
ENT.DirectDamageType = DMG_SLASH
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Sound ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ENT.HasStartupSounds = true -- Does it make a sound when the projectile is created?
ENT.HasIdleSounds = true -- Does it have idle sounds?
ENT.HasOnCollideSounds = true -- Should it play a sound when it collides something?
ENT.HasOnRemoveSounds = true -- Should it play a sound when it gets removed?
	-- ====== Sound Paths ====== --
ENT.SoundTbl_Startup = false
ENT.SoundTbl_Idle = false -- Recommendation: Use looped wav files, otherwise use "OnThink" to control when it plays again
ENT.SoundTbl_OnCollide = false
ENT.SoundTbl_OnRemove = false
	-- ====== Sound Chance ====== --
	-- Higher number = less chance of playing | 1 = Always play
ENT.StartupSoundChance = 1
ENT.IdleSoundChance = 1
ENT.OnCollideSoundChance = 1
ENT.OnRemoveSoundChance = 1
	-- ====== Sound Timer ====== --
ENT.NextSoundTime_Idle = VJ.SET(0.2, 0.5)
	-- ====== Sound Level ====== --
	-- The proper number are usually range from 0 to 180, though it can go as high as 511
	-- More Information: https://developer.valvesoftware.com/wiki/Soundscripts#SoundLevel_Flags
ENT.StartupSoundLevel = 80
ENT.IdleSoundLevel = 80
ENT.OnCollideSoundLevel = 80
ENT.OnRemoveSoundLevel = 90
	-- ====== Sound Pitch ====== --
ENT.StartupSoundPitch = VJ.SET(90, 100)
ENT.IdleSoundPitch = VJ.SET(90, 100)
ENT.OnCollideSoundPitch = VJ.SET(90, 100)
ENT.OnRemoveSoundPitch = VJ.SET(90, 100)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Hooks ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--
-- Use the functions below to customize or add new systems and behaviors
-- Use "self.BaseClass.FuncName(self)" or "baseclass.Get(baseName).FuncName(self)" to run the base code as well when overriding functions not listed below
--
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PreInit() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:InitPhys() /* Example: self:PhysicsInitSphere(1, "metal_bouncy") */ end -- Called right after the entity's physics has been initialized | Return true to override the base code
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDamaged(dmginfo) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnCollision(data, phys) end -- Return true to override the base code
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnCollisionPersist(data, phys) end -- Called when collision behavior is set to "PROJ_COLLISION_PERSIST"
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDealDamage(data, phys, hitEnts) end -- "hitEnts" = Table of entities damage or false if it hit nothing
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDestroy(data, phys) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRemove() end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ ///// BASE IMPLEMENTATION BELOW — Override with caution and only when necessary! \\\\\ ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ENT.Dead = false
ENT.NextIdleSoundT = 0
ENT.PaintedFinalDecal = false
ENT.NextPersistCollisionT = 0

local defVec = Vector(0, 0, 0)
local PICK = VJ.PICK
local PROJ_COLLISION_REMOVE = VJ.PROJ_COLLISION_REMOVE
local PROJ_COLLISION_PERSIST = VJ.PROJ_COLLISION_PERSIST
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Initialize()
	self:PreInit()
	if self.CustomOnPreInitialize then self:CustomOnPreInitialize() end -- !!!!!!!!!!!!!! DO NOT USE !!!!!!!!!!!!!! [Backwards Compatibility!]
	if self:GetModel() == "models/error.mdl" && PICK(self.Model) then self:SetModel(PICK(self.Model)) end
	
	local projType = self.ProjectileType
	-- Some models do NOT have a physics mesh, so let's initialize a basic sphere physics
	if !self:PhysicsInit(MOVETYPE_VPHYSICS) then
		local boundsMin, boundsMax = self:GetModelRenderBounds()
		local radius = (boundsMax - boundsMin):Length() * 0.5
		self:PhysicsInitSphere(radius, "metal_bouncy")
	end
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetMoveCollide(MOVECOLLIDE_FLY_BOUNCE)
	self:SetSolid(SOLID_BBOX)
	
	if self.CustomOnInitializeBeforePhys then self:CustomOnInitializeBeforePhys() end -- !!!!!!!!!!!!!! DO NOT USE !!!!!!!!!!!!!! [Backwards Compatibility!]
	if self.CustomPhysicsObjectOnInitialize then local phys = self:GetPhysicsObject() if IsValid(phys) then self.InitPhys = function() return true end self:CustomPhysicsObjectOnInitialize(phys) end end
	if !self:InitPhys() then
		local phys = self:GetPhysicsObject()
		if IsValid(phys) then
			phys:Wake()
			if projType == VJ.PROJ_TYPE_LINEAR then
				phys:SetMass(1)
				phys:EnableGravity(false)
				phys:EnableDrag(false)
			elseif projType == VJ.PROJ_TYPE_GRAVITY then
				phys:SetMass(1)
				phys:EnableGravity(true)
				phys:EnableDrag(false)
			elseif projType == VJ.PROJ_TYPE_PROP then
				phys:EnableGravity(true)
				phys:EnableDrag(true)
			end
			//phys:AddGameFlag(FVPHYSICS_NO_IMPACT_DMG)
			phys:SetBuoyancyRatio(0)
		end
	end
	
	if projType == VJ.PROJ_TYPE_PROP then
		self:SetCollisionGroup(COLLISION_GROUP_NONE)
	else
		self:SetTrigger(true)
		-- Set a trigger bound for models that do NOT have a physics mesh, otherwise they will not hit collision-based entities (ex: NPCs, players)
		if !util.IsValidProp(self:GetModel()) then
			local boundsMin, boundsMax = self:GetModelRenderBounds()
			local radius = math.max(2, (boundsMax - boundsMin):Length() * 0.05)
			self:UseTriggerBounds(true, radius)
		end
		self:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)
	end
	self:AddEFlags(EFL_DONTBLOCKLOS)
	self:AddEFlags(EFL_DONTWALKON)
	self:AddSolidFlags(FSOLID_NOT_STANDABLE)
	self:SetUseType(SIMPLE_USE)
	self:PlaySound("Startup")
	self:Init()
	
	-- !!!!!!!!!!!!!! DO NOT USE !!!!!!!!!!!!!! [Backwards Compatibility!]
	if self.IdleSoundPitch1 then self.IdleSoundPitch = VJ.SET(self.IdleSoundPitch1, self.IdleSoundPitch2) end
	if self.CustomOnInitialize then self:CustomOnInitialize() end
	if self.CustomOnThink then self.OnThink = function() self:CustomOnThink() end end
	if self.CustomOnPhysicsCollide then self.OnCollision = function(_, data, phys2) self:CustomOnPhysicsCollide(data, phys2) end end
	if self.CustomOnCollideWithoutRemove then self.OnCollisionPersist = function(_, data, phys2) self:CustomOnCollideWithoutRemove(data, phys2) end end
	if self.DeathEffects then self.OnDestroy = function(_, data, phys2) self:DeathEffects(data, phys2) end end
	if self.CustomOnDoDamage then self.OnDealDamage = function(_, data, phys2, hitEnts) self:CustomOnDoDamage(data, phys2, hitEnts) end end
	if self.CustomOnDoDamage_Direct then self.OnDealDamage = function(_, data, phys2, hitEnts) self:CustomOnDoDamage_Direct(data, phys2, hitEnts and hitEnts[1] or nil) end end
	if self.DecalTbl_OnCollideDecals then self.CollisionDecal = self.DecalTbl_OnCollideDecals end
	if self.DecalTbl_DeathDecals then self.CollisionDecal = self.DecalTbl_DeathDecals end
	if self.RemoveOnHit then self.CollisionBehavior = PROJ_COLLISION_REMOVE end
	if self.CollideCodeWithoutRemoving then self.CollisionBehavior = PROJ_COLLISION_PERSIST end
	--
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Think()
	if self.Dead then VJ.STOPSOUND(self.CurrentIdleSound) return end
	//self:SetAngles(self:GetVelocity():GetNormal():Angle())
	self:OnThink()
	self:PlaySound("Idle")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnTakeDamage(dmginfo)
	self:OnDamaged(dmginfo)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DealDamage(data, phys)
	local owner = self:GetOwner()
	local ownerValid = IsValid(owner)
	local dataEnt = data and data.HitEntity
	local hitEnts = false -- Entities that have been damaged (direct or radius)
	local dmgPos = (data and data.HitPos) or self:GetPos()
	if IsValid(dataEnt) && ((dataEnt.IsVJBaseBullseye && dataEnt.VJ_IsBeingControlled) or dataEnt.VJ_IsControllingNPC) then return end -- Don't damage bulleyes used by the NPC controller OR entities that are controlling others (Usually players)
	local selfData = self:GetTable()
	
	if selfData.DoesRadiusDamage then
		local attackEnt = ownerValid and owner or self -- The entity that will be set as the attacker
		-- If the projectile is picked up (Such as a grenade picked up by a human NPC), then the damage position is the parent's position
		if selfData.VJ_ST_Grabbed then
			local parent = self:GetParent()
			if IsValid(parent) && parent:IsNPC() then
				dmgPos = parent:GetPos()
			end
		end
		hitEnts = VJ.ApplyRadiusDamage(attackEnt, attackEnt, dmgPos, selfData.RadiusDamageRadius, selfData.RadiusDamage, selfData.RadiusDamageType, ownerValid && !owner:IsPlayer(), selfData.RadiusDamageUseRealisticRadius, {DisableVisibilityCheck=selfData.RadiusDamageDisableVisibilityCheck, Force=selfData.RadiusDamageForce, UpForce=selfData.RadiusDamageForce_Up, DamageAttacker=owner:IsPlayer()})
	end
	
	if selfData.DoesDirectDamage then
		if ownerValid then
			-- Accepts one of the 3 cases:
			-- Entity is not NPC/player
			-- Entity is NPC and not same class and (owner is a player OR not an ally NPC -- Players can still damage NPCs while NPCs can't damage other friendly NPCs)
			-- Entity is player and alive and (owner is player OR (ignore players is off and no target is off) -- Players can still damage each other while NPCs can't when ignore players is on)
			if IsValid(dataEnt) && ((!dataEnt:IsNPC() && !dataEnt:IsPlayer()) or (dataEnt:IsNPC() && dataEnt:GetClass() != owner:GetClass() && (owner:IsPlayer() or (owner:IsNPC() && owner:Disposition(dataEnt) != D_LI))) or (dataEnt:IsPlayer() && dataEnt:Alive() && (owner:IsPlayer() or (!VJ_CVAR_IGNOREPLAYERS && !dataEnt:IsFlagSet(FL_NOTARGET))))) then
				if hitEnts then
					hitEnts[#hitEnts + 1] = dataEnt
				else
					hitEnts = {dataEnt}
				end
				local dmgInfo = DamageInfo()
				dmgInfo:SetDamage(selfData.DirectDamage)
				dmgInfo:SetDamageType(selfData.DirectDamageType)
				dmgInfo:SetAttacker(owner)
				dmgInfo:SetInflictor(self)
				dmgInfo:SetDamagePosition(dmgPos)
				VJ.DamageSpecialEnts(owner, dataEnt, dmgInfo)
				dataEnt:TakeDamageInfo(dmgInfo, self)
			end
		else
			if hitEnts then
				hitEnts[#hitEnts + 1] = dataEnt
			else
				hitEnts = {dataEnt}
			end
			local dmgInfo = DamageInfo()
			dmgInfo:SetDamage(selfData.DirectDamage)
			dmgInfo:SetDamageType(selfData.DirectDamageType)
			dmgInfo:SetAttacker(self)
			dmgInfo:SetInflictor(self)
			dmgInfo:SetDamagePosition(dmgPos)
			VJ.DamageSpecialEnts(self, dataEnt, dmgInfo)
			dataEnt:TakeDamageInfo(dmgInfo, self)
		end
	end
	
	self:OnDealDamage(data, phys, hitEnts)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:StartTouch(ent)
	//print("START TOUCH", ent)
	-- Filter out entities that shouldn't be hit (such as clips or triggers)
	if !ent:IsPlayer() && !ent:IsNPC() && !ent:IsNextBot() && !ent:IsFlagSet(FL_OBJECT) /*&& ent:GetSolid() != SOLID_VPHYSICS*/ then return end
	if ent.IsVJBaseBullseye && ent.VJ_IsBeingControlled then return end
	local owner = self:GetOwner()
	-- Skip the following cases:
	-- Owner is the ent
	-- Owner is an NPC:
		-- Owner is the same class as ent
		-- Owner is friendly to ent
		-- Ent is a parent of the owner
		-- Ent is a player AND is dead OR ignore players is on OR has no target
	if IsValid(owner) && owner == ent or (self.CollisionFilter && owner:IsNPC() && (owner:GetClass() == ent:GetClass() or owner:Disposition(ent) == D_LI or owner:GetParent() == ent or (ent:IsPlayer() && (!ent:Alive() or VJ_CVAR_IGNOREPLAYERS or ent:IsFlagSet(FL_NOTARGET))))) then
		//print("START TOUCH - SKIPPPPP")
		return
	end
	//print("PASS", ent)
	
	-- Translate TraceResult --> CollisionData
	local trace = self:GetTouchTrace()
	local myPhys = self:GetPhysicsObject()
	local myVel = myPhys:GetVelocity()
	local myAngVel = myPhys:GetAngleVelocity()
	local entPhys = ent:GetPhysicsObject()
	local entVel;
	local entAngVel;
	if IsValid(entPhys) then
		entVel = entPhys:GetVelocity()
		entAngVel = entPhys:GetAngleVelocity()
	else
		entVel = ent:GetVelocity()
		entAngVel = entVel
	end
	if trace.HitNormal == defVec then -- Touch functions tend to return an invalid normal, so calculate it using the velocity
		trace.HitNormal = myVel:GetNormalized()
	end
	trace.PhysObject = myPhys
	trace.HitEntity = ent
	trace.HitObject = entPhys
	trace.HitSpeed = (myVel - entVel):Length()
	trace.Speed = myVel:Length()
	trace.DeltaTime = 1
	trace.OurSurfaceProps = trace.SurfaceProps
	trace.OurOldVelocity = myVel
	trace.OurOldAngularVelocity = myAngVel
	trace.OurNewVelocity = myVel
	trace.TheirSurfaceProps = trace.SurfaceProps
	trace.TheirOldVelocity = entVel
	trace.TheirOldAngularVelocity = entAngVel
	trace.TheirNewVelocity = entVel
	trace.HitPos = self:GetPos() -- Fake it until you make it
	
	self:PhysicsCollide(trace, myPhys)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PhysicsCollide(data, phys)
	local selfData = self:GetTable()
	if selfData.Dead then return end
	
	if !self:OnCollision(data, phys) then
		local colBehavior = selfData.CollisionBehavior
		if !colBehavior then return end
		if colBehavior == PROJ_COLLISION_REMOVE then
			selfData.Dead = true
			self:DealDamage(data, phys)
			self:PlaySound("OnCollide")
			if !selfData.PaintedFinalDecal then
				local decals = PICK(selfData.CollisionDecal)
				if decals then
					selfData.PaintedFinalDecal = true
					util.Decal(decals, data.HitPos + data.HitNormal * -15, data.HitPos - data.HitNormal * -2)
				end
			end
			
			-- Remove the entity
			if selfData.ShakeWorldOnDeath then util.ScreenShake(data.HitPos, selfData.ShakeWorldOnDeathAmplitude or 16, selfData.ShakeWorldOnDeathFrequency or 200, selfData.ShakeWorldOnDeathDuration or 1, selfData.ShakeWorldOnDeathRadius or 3000) end -- !!!!!!!!!!!!!! DO NOT USE THIS VARIABLE !!!!!!!!!!!!!! [Backwards Compatibility!]
			self:Destroy(data, phys)
		elseif colBehavior == PROJ_COLLISION_PERSIST then
			if CurTime() < selfData.NextPersistCollisionT then return end
			self:DealDamage(data, phys)
			self:PlaySound("OnCollide")
			if !selfData.PaintedFinalDecal then
				local decals = PICK(selfData.CollisionDecal)
				if decals then
					util.Decal(decals, data.HitPos + data.HitNormal * -15, data.HitPos - data.HitNormal * -2)
				end
			end
			-- Avoids "Changing collision rules within a callback is likely to cause crashes!"
			timer.Simple(0, function()
				if IsValid(self) then
					self:OnCollisionPersist(data, phys)
				end
			end)
			selfData.NextPersistCollisionT = CurTime() + 1 -- Add a delay so we don't spam it!
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Destroy(data, phys)
	phys = phys or self:GetPhysicsObject()
	self.Dead = true
	self:StopParticles()
	VJ.STOPSOUND(self.CurrentIdleSound)
	self:OnDestroy(data, phys)
	
	-- Handle removal
	if self.RemoveDelay > 0 then
		self:SetNoDraw(true)
		-- Avoids "Changing collision rules within a callback is likely to cause crashes!"
		timer.Simple(0, function()
			if IsValid(self) then
				self:SetMoveType(MOVETYPE_NONE)
				self:SetSolid(SOLID_NONE)
				self:AddSolidFlags(FSOLID_NOT_SOLID)
			end
		end)
		phys:EnableMotion(false)
		phys:SetVelocityInstantaneous(defVec)
		timer.Simple(self.RemoveDelay, function()
			if IsValid(self) then
				self:Remove()
			end
		end)
		self:OnRemove()
	else
		self:Remove()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRemove()
	self.Dead = true
	VJ.STOPSOUND(self.CurrentIdleSound)
	self:PlaySound("OnRemove")
	self:CustomOnRemove()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PlaySound(sdSet)
	if !sdSet then return end
	local selfData = self:GetTable()
	if sdSet == "Startup" then
		if selfData.HasStartupSounds && math.random(1, selfData.StartupSoundChance) == 1 then
			VJ.EmitSound(self, selfData.SoundTbl_Startup, selfData.StartupSoundLevel, math.random(selfData.StartupSoundPitch.a, selfData.StartupSoundPitch.b))
		end
	elseif sdSet == "Idle" then
		local curIdleSD = selfData.CurrentIdleSound
		if selfData.HasIdleSounds && (!curIdleSD or (curIdleSD && !curIdleSD:IsPlaying())) && CurTime() > selfData.NextIdleSoundT then
			if math.random(1, selfData.IdleSoundChance) == 1 then
				VJ.STOPSOUND(selfData.CurrentIdleSound)
				selfData.CurrentIdleSound = VJ.CreateSound(self, selfData.SoundTbl_Idle, selfData.IdleSoundLevel, math.random(selfData.IdleSoundPitch.a, selfData.IdleSoundPitch.b))
			end
			selfData.NextIdleSoundT = CurTime() + math.Rand(selfData.NextSoundTime_Idle.a , selfData.NextSoundTime_Idle.b)
		end
	elseif sdSet == "OnCollide" then
		if selfData.HasOnCollideSounds && math.random(1, selfData.OnCollideSoundChance) == 1 then
			VJ.EmitSound(self, selfData.SoundTbl_OnCollide, selfData.OnCollideSoundLevel, math.random(selfData.OnCollideSoundPitch.a, selfData.OnCollideSoundPitch.b))
		end
	elseif sdSet == "OnRemove" then
		if selfData.HasOnRemoveSounds && math.random(1, selfData.OnRemoveSoundChance) == 1 then
			VJ.EmitSound(self, selfData.SoundTbl_OnRemove, selfData.OnRemoveSoundLevel, math.random(selfData.OnRemoveSoundPitch.a, selfData.OnRemoveSoundPitch.b))
		end
	end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ ///// OBSOLETE FUNCTIONS | Do not to use! \\\\\ ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- !!!!!!!!!!!!!! DO NOT USE THESE !!!!!!!!!!!!!! [Backwards Compatibility!]
function ENT:OnCollideSoundCode() self:PlaySound("OnCollide") end
function ENT:DoDamageCode(data, phys) self:DealDamage(data, phys) end
function ENT:SetDeathVariablesTrue(data, phys, runOnDestroy)
	self.Dead = true
	self:StopParticles()
	VJ.STOPSOUND(self.CurrentIdleSound)
	if runOnDestroy then self:OnDestroy(data, phys or self:GetPhysicsObject()) end
end