AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2021 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Core Variables ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ENT.StartHealth = 0
ENT.HullType = HULL_TINY
ENT.HullSizeNormal = false -- set to false to cancel out the self:SetHullSizeNormal()
ENT.HasSetSolid = false -- set to false to disable SetSolid
ENT.VJ_IsHugeMonster = true -- Is this a huge monster?
ENT.MovementType = VJ_MOVETYPE_STATIONARY -- How does the SNPC move?
ENT.CanTurnWhileStationary = false -- If set to true, the SNPC will be able to turn while it's a stationary SNPC
ENT.Stationary_UseNoneMoveType = true -- Technical variable, use this if there is any issues with the SNPC's position, though it does have its downsides, so use it only when needed
ENT.GodMode = true -- Immune to everything
ENT.Bleeds = false -- Does the SNPC bleed? (Blood decal, particle, etc.)
ENT.Immune_Dissolve = true -- Immune to Dissolving | Example: Combine Ball
ENT.Immune_AcidPoisonRadiation = true -- Immune to Acid, Poison and Radiation
ENT.Immune_Bullet = true -- Immune to Bullets
ENT.Immune_Physics = true -- Immune to Physics
ENT.ImmuneDamagesTable = {DMG_SLASH,DMG_GENERIC,DMG_CLUB,DMG_PHYSGUN} -- You can set Specific types of damages for the SNPC to be immune to
ENT.FindEnemy_UseSphere = true -- Should the SNPC be able to see all around him? (360) | Objects and walls can still block its sight!
ENT.DeathCorpseCollisionType = COLLISION_GROUP_NONE -- Collision type for the corpse | SNPC Options Menu can only override this value if it's set to COLLISION_GROUP_DEBRIS!
ENT.HasMeleeAttack = false -- Should the SNPC have a melee attack?
ENT.DisableInitializeCapabilities = true -- If true, it will disable the initialize capabilities, this will allow you to add your own
ENT.DisableSelectSchedule = true -- Disables Schedule code, Custom Schedule can still work
ENT.DisableWandering = true -- Disables wandering when the SNPC is idle
ENT.DisableFindEnemy = true -- Disables FindEnemy code, friendly code still works though
ENT.BringFriendsOnDeath = false -- Should the SNPC's friends come to its position before it dies?
ENT.CallForBackUpOnDamage = false -- Should the SNPC call for help when damaged? (Only happens if the SNPC hasn't seen a enemy)
ENT.MoveOrHideOnDamageByEnemy = false -- Should the SNPC move or hide when being damaged by an enemy?
ENT.CallForHelp = false -- Does the SNPC call for help?
ENT.HasPainSounds = false -- If set to false, it won't play the pain sounds
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Tank Base Variables ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ENT.Tank_AngleDiffuseNumber = 180 -- Used if the forward direction of the y-axis isn't correct on the model
ENT.Tank_AngleDiffuseFiringLimit = 5 -- Firing angle diffuse limit, useful for larger barrel tanks by increasing it | lower number = More specific the barrel has to aim to fire
	-- ====== Sight Variables ====== --
ENT.Tank_SeeClose = 350 -- If the enemy is closer than this number, than don't shoot!
ENT.Tank_SeeFar = 6500 -- If the enemy is higher than this number, than don't shoot!
	-- ====== Movement Variables ====== --
ENT.Tank_TurningSpeed = 5 -- How fast the gun moves as it's aiming towards an enemy
	-- ====== Projectile Shell Variables ====== --
ENT.Tank_Shell_NextFireTime = 0 -- Delay between each fire, triggered the moment when the shell leaves the tank | It can NOT even reload if this delay is active!
ENT.Tank_Shell_TimeUntilFire = 2 -- Delay until it fires the shell (Ran after reloading) | If Failure: it will instantly fire it the moment it's facing the enemy again!
ENT.Tank_Shell_SpawnPos = Vector(-170, 0, 65)
ENT.Tank_Shell_EntityToSpawn = "obj_vj_tank_shell" -- The entity that is spawned when the shell is fired
ENT.Tank_Shell_VelocitySpeed = 5000 -- How fast should the tank shell travel?
ENT.Tank_Shell_DynamicLightPos = Vector(-200, 0, 0)
ENT.Tank_Shell_MuzzleFlashPos = Vector(0, -235, 18)
ENT.Tank_Shell_ParticlePos = Vector(-205, 00, 72)
	-- ====== Sound Variables ====== --
ENT.HasReloadShellSound = true
ENT.Tank_SoundTbl_Turning = {}
ENT.Tank_TurningSoundLevel = 80
ENT.Tank_TurningSoundPitch = VJ_Set(100, 100)
--
ENT.HasFireShellSound = true
ENT.Tank_SoundTbl_ReloadShell = {}
ENT.Tank_ReloadShellSoundLevel = 90
ENT.Tank_ReloadShellSoundPitch = VJ_Set(100, 100)
--
ENT.Tank_SoundTbl_FireShell = {}

ENT.Tank_DefaultSoundTbl_Turning = {"vj_mili_tank/tank_gunnermove2_x.wav"}
ENT.Tank_DefaultSoundTbl_ReloadShell = {"vehicles/tank_readyfire1.wav"}
ENT.Tank_DefaultSoundTbl_FireShell = {"vj_mili_tank/tank_fire1.wav","vj_mili_tank/tank_fire2.wav","vj_mili_tank/tank_fire3.wav","vj_mili_tank/tank_fire4.wav"}

//util.AddNetworkString("vj_tankg_base_spawneffects")
//util.AddNetworkString("vj_tankg_base_shooteffects")
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Customization Functions ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- Use the functions below to customize certain parts of the base or to add new custom systems
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomInitialize_CustomTank() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Tank_CustomOnThink() return true end -- Return false to disable think code (Its just the StartSpawnEffects)
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Tank_CustomOnThink_AIEnabled() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Tank_CustomOnReloadShell() end
---------------------------------------------------------------------------------------------------------------------------------------------
-- Use this function to set your own effects or to change the existing ones
function ENT:Tank_ShellFireEffects()
	local myAng = self:GetAngles()
	
	local lightFire = ents.Create("light_dynamic")
	lightFire:SetKeyValue("brightness", "4")
	lightFire:SetKeyValue("distance", "400")
	lightFire:SetPos(self:LocalToWorld(self.Tank_Shell_DynamicLightPos))
	lightFire:SetLocalAngles(myAng)
	lightFire:Fire("Color", "255 150 60")
	lightFire:SetParent(self)
	lightFire:Spawn()
	lightFire:Activate()
	lightFire:Fire("TurnOn", "", 0)
	lightFire:Fire("Kill", "", 0.1)
	self:DeleteOnRemove(lightFire)
	
	local muzzleFlash = ents.Create("env_muzzleflash")
	muzzleFlash:SetPos(self:LocalToWorld(self.Tank_Shell_MuzzleFlashPos))
	muzzleFlash:SetAngles(self:GetAngles() + Angle(0, self.Tank_AngleDiffuseNumber, 0))
	muzzleFlash:SetKeyValue("scale", "6")
	muzzleFlash:Fire("Fire", 0, 0)

	local iClientEffect = 0
	for _ = 1, 40 do
		iClientEffect = iClientEffect + 0.1
		timer.Simple(iClientEffect, function() if self.Dead == false then self:StartShootEffects() end end)
	end
	
	local smokeAngle = Angle(myAng.x, -myAng.y, myAng.z)
	local particleSmoke = ents.Create("info_particle_system")
	particleSmoke:SetKeyValue("effect_name", "smoke_exhaust_01a")
	particleSmoke:SetPos(self:LocalToWorld(self.Tank_Shell_ParticlePos))
	particleSmoke:SetAngles(smokeAngle)
	particleSmoke:SetParent(self)
	particleSmoke:Spawn()
	particleSmoke:Activate()
	particleSmoke:Fire("Start", "", 0)
	particleSmoke:Fire("Kill", "", 4)
	
	local particleSmokeWhite = ents.Create("info_particle_system")
	particleSmokeWhite:SetKeyValue("effect_name", "Advisor_Pod_Steam_Continuous")
	particleSmokeWhite:SetPos(self:LocalToWorld(self.Tank_Shell_ParticlePos))
	particleSmokeWhite:SetAngles(smokeAngle)
	particleSmokeWhite:SetParent(self)
	particleSmokeWhite:Spawn()
	particleSmokeWhite:Activate()
	particleSmokeWhite:Fire("Start", "", 0)
	particleSmokeWhite:Fire("Kill", "", 4)
		
	local dust = EffectData()
	dust:SetOrigin(self:GetParent():GetPos())
	dust:SetScale(500)
	util.Effect("ThumperDust", dust)
	
	util.ScreenShake(self:GetPos(), 100, 200, 1, 2500)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Tank_CustomOnShellFire_BeforeShellCreate() return true end -- Return false to not create the default shell
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Tank_CustomOnShellFire_BeforeShellSpawn(shell, spawnPos) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Tank_ShellFireVelocity(shell, spawnPos, calculatedVel, phys)
	-- Use this override the firing shell velocity, calculatedVel is not required but is a helpful variable to utilize
	phys:SetVelocity(Vector(calculatedVel.x, calculatedVel.y, math.Clamp(calculatedVel.z, self.Tank_Shell_SpawnPos.z - 735, self.Tank_Shell_SpawnPos.z + 335)))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Tank_CustomOnShellFire(shell) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:StartSpawnEffects()
	/* Example:
	net.Start("vj_tankg_base_spawneffects")
	net.WriteEntity(self)
	net.Broadcast()
	*/
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:StartShootEffects()
	/* Example:
	-- Note: This is ran many times (~40) when the tank fires!
	net.Start("vj_tankg_base_shooteffects")
	net.WriteEntity(self)
	net.Broadcast()
	*/
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Tank_CustomOnDeath_AfterCorpseSpawned(dmginfo, hitgroup, corpseEnt) end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ ///// WARNING: Don't touch anything below this line! \\\\\ ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ENT.Tank_FacingTarget = false -- Is it facing the enemy?
ENT.Tank_Shell_Status = 0 -- 0 = Not reloaded or ready | 1 = Reloading | 2 = Reloaded & ready
ENT.Tank_ProperHeightShoot = false -- Is the enemy position proper height for it to shoot?
ENT.Tank_GunnerIsTurning = false
ENT.Tank_Status = 0
ENT.Tank_Shell_NextFireT = 0
ENT.Tank_TurningLerp = nil
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:CustomInitialize_CustomTank()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:AngleDiffuse(ang1, ang2)
	local outcome = ang1 - ang2
	if outcome < -180 then outcome = outcome + 360 end
	if outcome > 180 then outcome = outcome - 360 end
	return outcome
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	if self:Tank_CustomOnThink() == true && GetConVar("vj_npc_noidleparticle"):GetInt() == 0 then
		timer.Simple(0.1, function()
			if IsValid(self) && self.Dead == false then
				self:StartSpawnEffects()
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink_AIEnabled()
	if self.Dead == true then return end
	self:SetEnemy(self:GetParent():GetEnemy())
	self:Tank_CustomOnThink_AIEnabled()

	if self.Tank_GunnerIsTurning == true then self:Tank_Sound_Moving() else VJ_STOPSOUND(self.CurrentTankMovingSound) end
	self:CustomOnSchedule()
	
	if self.Tank_Status == 0 then
		local ene = self:GetEnemy()
		if IsValid(ene) && self.LatestEnemyDistance < self.Tank_SeeFar then
			self.Tank_GunnerIsTurning = false
			local angEne = (ene:GetPos() - self:GetPos()):Angle()
			local angDiffuse = self:AngleDiffuse(angEne.y, self:GetAngles().y + self.Tank_AngleDiffuseNumber) -- Cannon looking direction
			local heightRatio = (ene:GetPos().z - self:GetPos().z) / self:GetPos():Distance(Vector(ene:GetPos().x, ene:GetPos().y, self:GetPos().z))
			self.Tank_ProperHeightShoot = math.abs(heightRatio) < 0.15 and true or false -- How high it can fire
			-- If the enemy is within the barrel firing limit AND not already firing a shell AND its height is is reachable AND the enemy is not extremely close, then FIRE!
			if math.abs(angDiffuse) < self.Tank_AngleDiffuseFiringLimit && self.Tank_ProperHeightShoot && self.LatestEnemyDistance > self.Tank_SeeClose then
				self.Tank_FacingTarget = true
				if self:Visible(ene) && GetConVar("vj_npc_norange"):GetInt() == 0 then
					self:Tank_PrepareShell() 
				end
			-- Turn Left
			elseif angDiffuse > self.Tank_AngleDiffuseFiringLimit then
				if self.Tank_TurningLerp == nil then self.Tank_TurningLerp = self:GetLocalAngles() end
				self.Tank_TurningLerp = LerpAngle(1, self.Tank_TurningLerp, self.Tank_TurningLerp + Angle(0, math.Clamp(angDiffuse, 0, self.Tank_TurningSpeed), 0))
				self:SetLocalAngles(self.Tank_TurningLerp)
				self.Tank_GunnerIsTurning = true
				self.Tank_FacingTarget = false
			-- Turn Right
			elseif angDiffuse < -self.Tank_AngleDiffuseFiringLimit then
				if self.Tank_TurningLerp == nil then self.Tank_TurningLerp = self:GetLocalAngles() end
				self.Tank_TurningLerp = LerpAngle(1, self.Tank_TurningLerp, self.Tank_TurningLerp + Angle(0, -math.Clamp(math.abs(angDiffuse), 0, self.Tank_TurningSpeed), 0))
				self:SetLocalAngles(self.Tank_TurningLerp)
				self.Tank_GunnerIsTurning = true
				self.Tank_FacingTarget = false
			end
		else
			self.Tank_Status = 1
			self.Tank_GunnerIsTurning = false
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnSchedule()
	if self.Dead == true then return end
	
	self:IdleSoundCode()
	self:DoIdleAnimation()
	
	if IsValid(self:GetEnemy()) then
		if self:GetParent().VJ_IsBeingControlled == true then
			self.Tank_Status = 0
		else
			if self.LatestEnemyDistance < self.Tank_SeeFar && self.LatestEnemyDistance > self.Tank_SeeClose then -- Between this two numbers than fire!
				self.Tank_Status = 0
			else
				self.Tank_Status = 0
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Tank_PrepareShell()
	if (CurTime() < self.Tank_Shell_NextFireT) or (self:GetParent().VJ_IsBeingControlled == true && !self:GetParent().VJ_TheController:KeyDown(IN_ATTACK2)) then return end
	
	-- If it's already ready, then just fire it!
	if self.Tank_Shell_Status == 2 then
		self:Tank_FireShell()
	-- Otherwise reload and fire
	elseif self.Tank_Shell_Status == 0 then
		self:Tank_CustomOnReloadShell()
		self:Tank_Sound_ReloadShell()
		self.Tank_Shell_Status = 1
		timer.Create("timer_shell_attack"..self:EntIndex(), self.Tank_Shell_TimeUntilFire, 1, function()
			self.Tank_Shell_Status = 2
			self:Tank_FireShell()
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Tank_FireShell()
	local ene = self:GetEnemy()
	if (GetConVar("ai_disabled"):GetInt() == 1) or (self.Dead == true) or (!self.Tank_ProperHeightShoot) or (!IsValid(ene)) or (!self.Tank_FacingTarget) then return end // self.Tank_FacingTarget != true
	if self:Visible(ene) then
		self:Tank_Sound_FireShell()
		self:Tank_ShellFireEffects()
		
		if self:Tank_CustomOnShellFire_BeforeShellCreate() == true then
			local spawnPos = self:LocalToWorld(self.Tank_Shell_SpawnPos)
			local calculatedVel = (ene:GetPos() + ene:OBBCenter() - spawnPos):GetNormal()*self.Tank_Shell_VelocitySpeed
			-- If not facing, then just shoot straight ahead
			if !self.Tank_FacingTarget then
				calculatedVel = self:GetForward()
				calculatedVel:Rotate(Angle(0, self.Tank_AngleDiffuseNumber, 0))
				calculatedVel = calculatedVel*self.Tank_Shell_VelocitySpeed
			end
			local shell = ents.Create(self.Tank_Shell_EntityToSpawn)
			shell:SetPos(spawnPos)
			shell:SetAngles(calculatedVel:Angle())
			self:Tank_CustomOnShellFire_BeforeShellSpawn(shell, spawnPos)
			shell:Spawn()
			shell:Activate()
			shell:SetOwner(self)
			local phys = shell:GetPhysicsObject()
			if IsValid(phys) then
				self:Tank_ShellFireVelocity(shell, spawnPos, calculatedVel, phys)
			end
			self:Tank_CustomOnShellFire(shell)
		end
		self.Tank_Shell_Status = 0
		self.Tank_Shell_NextFireT = CurTime() + self.Tank_Shell_NextFireTime
	else -- Not visible
		self.Tank_FacingTarget = false
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDeath_AfterCorpseSpawned(dmginfo, hitgroup, corpseEnt)
	if self:Tank_CustomOnDeath_AfterCorpseSpawned(dmginfo, hitgroup, corpseEnt) == true then
		corpseEnt:GetPhysicsObject():AddVelocity(Vector(math.Rand(-200, 200), math.Rand(-200, 200), math.Rand(200, 400)))
		corpseEnt:GetPhysicsObject():AddAngleVelocity(Vector(math.Rand(-100, 100), math.Rand(-100, 100), math.Rand(-100, 100)))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRemove()
	VJ_STOPSOUND(self.CurrentTankMovingSound)
	timer.Destroy("timer_shell_attack" .. self:EntIndex())
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Tank_Sound_Moving()
	if self.HasSounds == false or self.HasFootStepSound == false then return end
	
	local sdTbl = VJ_PICK(self.Tank_SoundTbl_Turning)
	if sdTbl == false then sdTbl = VJ_PICK(self.Tank_DefaultSoundTbl_Turning) end -- Default table
	self.CurrentTankMovingSound = VJ_CreateSound(self, sdTbl, self.Tank_TurningSoundLevel, math.random(self.Tank_TurningSoundPitch.a, self.Tank_TurningSoundPitch.b))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Tank_Sound_ReloadShell()
	if self.HasSounds == false or self.HasReloadShellSound == false then return end
	
	local sdTbl = VJ_PICK(self.Tank_SoundTbl_ReloadShell)
	if sdTbl == false then sdTbl = VJ_PICK(self.Tank_DefaultSoundTbl_ReloadShell) end -- Default table
	//self.CurrentTankFiringSound = VJ_CreateSound(self, sdTbl, self.Tank_ReloadShellSoundLevel, math.random(self.Tank_ReloadShellSoundPitch.a, self.Tank_ReloadShellSoundPitch.b))
	VJ_EmitSound(self, sdTbl, self.Tank_ReloadShellSoundLevel, math.random(self.Tank_ReloadShellSoundPitch.a, self.Tank_ReloadShellSoundPitch.b))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Tank_Sound_FireShell()
	if self.HasSounds == false or self.HasFireShellSound == false then return end
	
	local sdTbl = VJ_PICK(self.Tank_SoundTbl_FireShell)
	if sdTbl == false then sdTbl = VJ_PICK(self.Tank_DefaultSoundTbl_FireShell) end -- Default table
	VJ_EmitSound(self, sdTbl, 500, 100)
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2021 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/