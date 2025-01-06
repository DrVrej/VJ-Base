AddCSLuaFile("shared.lua")
include("shared.lua")
include("vj_base/ai/base_tank.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Core Variables ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ENT.StartHealth = 0
ENT.HasSetSolid = false -- set to false to disable SetSolid
ENT.MovementType = VJ_MOVETYPE_STATIONARY -- How the NPC moves around
ENT.CanTurnWhileStationary = false -- If set to true, the SNPC will be able to turn while it's a stationary SNPC
ENT.GodMode = true -- Immune to everything
ENT.DisableFindEnemy = true -- Disables FindEnemy code, friendly code still works though
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
ENT.Tank_TurningSoundPitch = VJ.SET(100, 100)
--
ENT.HasFireShellSound = true
ENT.Tank_SoundTbl_ReloadShell = {}
ENT.Tank_ReloadShellSoundLevel = 90
ENT.Tank_ReloadShellSoundPitch = VJ.SET(100, 100)
--
ENT.Tank_SoundTbl_FireShell = {}

ENT.Tank_DefaultSoundTbl_Turning = "vj_base/vehicles/armored/gun_move2.wav"
ENT.Tank_DefaultSoundTbl_ReloadShell = "vehicles/tank_readyfire1.wav"
ENT.Tank_DefaultSoundTbl_FireShell = {"vj_base/vehicles/armored/gun_main_fire1.wav", "vj_base/vehicles/armored/gun_main_fire2.wav", "vj_base/vehicles/armored/gun_main_fire3.wav", "vj_base/vehicles/armored/gun_main_fire4.wav"}

//util.AddNetworkString("vj_tankg_base_spawneffects")
//util.AddNetworkString("vj_tankg_base_shooteffects")
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Customization Functions ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- Use the functions below to customize certain parts of the base or to add new custom systems
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Tank_Init() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Tank_OnThink() end -- Return true to disable the default base code (Its just the StartSpawnEffects)
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Tank_OnThinkActive() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Tank_OnPrepareShell() end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[
Called when the tank is firing its shell

=-=-=| PARAMETERS |=-=-=
	1. status [string] : Type of update that is occurring, holds one of the following states:
		-> "Initial" : Before the shell is created, can be used to override the shell entity code
				USAGE EXAMPLES -> Create completely custom shell entity code
				PARAMETERS
					5. statusData [nil]
				RETURNS
					-> [nil | bool] : Returning true will NOT let the base shell execute, effectively overriding it entirely (Effects still run!)
		-> "OnCreate" : Right after the shell is created but before it's spawned
				USAGE EXAMPLES -> Set an spawn value for the projectile, such various types of shells inside a single projectile class
				PARAMETERS
					5. statusData [entity] : The newly created shell entity (but not spawned!)
				RETURNS
					-> [nil]
		-> "OnSpawn" : After the shell has spawned
				USAGE EXAMPLES -> Override the default velocity
				PARAMETERS
					5. statusData [entity] : The newly spawned shell entity
				RETURNS
					-> [nil | bool] : Returning true will NOT let the base velocity apply
		-> "Effects" : Firing effects including dynamic light, particles, muzzle flash, world shake, etc.
				USAGE EXAMPLES -> Add extra effects | Override the base effects completely
				PARAMETERS
					5. statusData [nil]
				RETURNS
					-> [nil | bool] : Returning true will NOT let the base effects be created
	2. statusData [nil | entity] : Depends on `status` value, refer to it for more details

=-=-=| RETURNS |=-=-=
	-> [nil | bool] : Depends on `status` value, refer to it for more details
--]]
function ENT:Tank_OnFireShell(status, statusData) end
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
	/* Example: Note: This is ran many times (~40) when the tank fires!
	net.Start("vj_tankg_base_shooteffects")
	net.WriteEntity(self)
	net.Broadcast()
	*/
end
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
ENT.Tank_Status = 0 -- 0 = Can fire | 1 = Can NOT fire
ENT.Tank_Shell_NextFireT = 0
ENT.Tank_TurningLerp = nil

local cv_norange = GetConVar("vj_npc_norange")
local cv_noidleparticle = GetConVar("vj_npc_noidleparticle")
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self.DeathAnimationCodeRan = true -- So corpse doesn't fly away on death (Take this out if not using death explosion sequence)
	self:SetPhysicsDamageScale(0) -- Take no physics damage
	self:Tank_Init()
	if self.CustomInitialize_CustomTank then self:CustomInitialize_CustomTank() end -- !!!!!!!!!!!!!! DO NOT USE !!!!!!!!!!!!!! [Backwards Compatibility!]
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	if self:Tank_OnThink() != true && cv_noidleparticle:GetInt() == 0 then
		timer.Simple(0.1, function()
			if IsValid(self) && !self.Dead then
				self:StartSpawnEffects()
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThinkActive()
	if self.Dead then return end
	self:SetEnemy(self:GetParent():GetEnemy())
	self:Tank_OnThinkActive()

	if self.Tank_GunnerIsTurning == true then self:Tank_Sound_Moving() else VJ.STOPSOUND(self.CurrentTankMovingSound) end
	self:SelectSchedule()
	
	if self.Tank_Status == 0 then
		local ene = self:GetEnemy()
		if IsValid(ene) then
			self.Tank_GunnerIsTurning = false
			local angEne = (ene:GetPos() - self:GetPos()):Angle()
			local angDiffuse = self:Tank_AngleDiffuse(angEne.y, self:GetAngles().y + self.Tank_AngleDiffuseNumber) -- Cannon looking direction
			local heightRatio = (ene:GetPos().z - self:GetPos().z) / self:GetPos():Distance(Vector(ene:GetPos().x, ene:GetPos().y, self:GetPos().z))
			self.Tank_ProperHeightShoot = math.abs(heightRatio) < 0.15 and true or false -- How high it can fire
			-- If the enemy is within the barrel firing limit AND not already firing a shell AND its height is is reachable AND the enemy is not extremely close, then FIRE!
			if math.abs(angDiffuse) < self.Tank_AngleDiffuseFiringLimit && self.Tank_ProperHeightShoot && self.LatestEnemyDistance > self.Tank_SeeClose then
				self.Tank_FacingTarget = true
				if self:Visible(ene) && cv_norange:GetInt() == 0 then
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
function ENT:SelectSchedule()
	if self.Dead then return end
	
	self:IdleSoundCode()
	self:MaintainIdleBehavior()
	
	if IsValid(self:GetEnemy()) then
		-- Can always fire when being controlled
		if self:GetParent().VJ_IsBeingControlled then
			self.Tank_Status = 0
		else
			-- Between these 2 limits it can fire! --
			if self.LatestEnemyDistance < self.Tank_SeeFar && self.LatestEnemyDistance > self.Tank_SeeClose then
				self.Tank_Status = 0
			-- Out of range, can't fire!
			else
				self.Tank_Status = 1
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Tank_PrepareShell()
	if (CurTime() < self.Tank_Shell_NextFireT) or (self:GetParent().VJ_IsBeingControlled && !self:GetParent().VJ_TheController:KeyDown(IN_ATTACK2)) then return end
	
	-- If it's already ready, then just fire it!
	if self.Tank_Shell_Status == 2 then
		self:Tank_FireShell()
	-- Otherwise reload and fire
	elseif self.Tank_Shell_Status == 0 then
		self:Tank_OnPrepareShell()
		self:Tank_Sound_ReloadShell()
		self.Tank_Shell_Status = 1
		local ene = self:GetEnemy()
		if (!ene:IsNPC()) or (ene:IsNPC() && ene:GetEnemy() == self:GetParent()) then -- Don't run away when you don't even know that the tank exists!
			sound.EmitHint(SOUND_DANGER, ene:GetPos() + ene:OBBCenter(), 80, self.Tank_Shell_TimeUntilFire, self)
		end
		timer.Create("timer_shell_attack"..self:EntIndex(), self.Tank_Shell_TimeUntilFire, 1, function()
			self.Tank_Shell_Status = 2
			self:Tank_FireShell()
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Tank_FireShell()
	local ene = self:GetEnemy()
	if !VJ_CVAR_AI_ENABLED or self.Dead or (!self.Tank_ProperHeightShoot) or (!IsValid(ene)) or (!self.Tank_FacingTarget) then return end // self.Tank_FacingTarget != true
	if self:Visible(ene) then
		self:Tank_Sound_FireShell()
		
		if self:Tank_OnFireShell("Initial") != true then
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
			self:Tank_OnFireShell("OnCreate", shell)
			shell:Spawn()
			shell:Activate()
			shell:SetOwner(self)
			if self:Tank_OnFireShell("OnSpawn", shell) != true then
				local phys = shell:GetPhysicsObject()
				if IsValid(phys) then
					phys:SetVelocity(Vector(calculatedVel.x, calculatedVel.y, math.Clamp(calculatedVel.z, self.Tank_Shell_SpawnPos.z - 735, self.Tank_Shell_SpawnPos.z + 335)))
				end
			end
		end
		if self:Tank_OnFireShell("Effects") != true then
			local myAng = self:GetAngles()
			util.ScreenShake(self:GetPos(), 100, 200, 1, 2500)
			
			-- Dynamic light
			local lightFire = ents.Create("light_dynamic")
			lightFire:SetKeyValue("brightness", "4")
			lightFire:SetKeyValue("distance", "400")
			lightFire:SetPos(self:LocalToWorld(self.Tank_Shell_DynamicLightPos))
			lightFire:SetLocalAngles(myAng)
			lightFire:Fire("Color", "255 150 60")
			lightFire:SetParent(self)
			lightFire:Spawn()
			lightFire:Activate()
			lightFire:Fire("TurnOn")
			lightFire:Fire("Kill", "", 0.1)
			self:DeleteOnRemove(lightFire)
			
			-- Muzzle flash effect
			local muzzleFlash = ents.Create("env_muzzleflash")
			muzzleFlash:SetPos(self:LocalToWorld(self.Tank_Shell_MuzzleFlashPos))
			muzzleFlash:SetAngles(myAng + Angle(0, self.Tank_AngleDiffuseNumber, 0))
			muzzleFlash:SetKeyValue("scale", "6")
			muzzleFlash:Fire("Fire", 0, 0)
			
			-- Smoke effects
			local smokeAngle = Angle(myAng.x, -myAng.y, myAng.z)
			local smoke = ents.Create("info_particle_system")
			smoke:SetKeyValue("effect_name", "smoke_exhaust_01a")
			smoke:SetPos(self:LocalToWorld(self.Tank_Shell_ParticlePos))
			smoke:SetAngles(smokeAngle)
			smoke:SetParent(self)
			smoke:Spawn()
			smoke:Activate()
			smoke:Fire("Start")
			smoke:Fire("Kill", "", 4)
			local smokeWhite = ents.Create("info_particle_system")
			smokeWhite:SetKeyValue("effect_name", "vj_steam_narrow_continuous")
			smokeWhite:SetPos(self:LocalToWorld(self.Tank_Shell_ParticlePos))
			smokeWhite:SetAngles(smokeAngle)
			smokeWhite:SetParent(self)
			smokeWhite:Spawn()
			smokeWhite:Activate()
			smokeWhite:Fire("Start")
			smokeWhite:Fire("Kill", "", 4)
			
			-- Dust effects
			local dust = EffectData()
			dust:SetOrigin(self:GetParent():GetPos())
			dust:SetScale(500)
			util.Effect("ThumperDust", dust)
			
			-- Custom firing effects
			local iClientEffect = 0
			for _ = 1, 40 do
				iClientEffect = iClientEffect + 0.1
				timer.Simple(iClientEffect, function() if IsValid(self) && !self.Dead then self:StartShootEffects() end end)
			end
		end
		self.Tank_Shell_Status = 0
		self.Tank_Shell_NextFireT = CurTime() + self.Tank_Shell_NextFireTime
	else -- Not visible
		self.Tank_FacingTarget = false
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnCreateDeathCorpse(dmginfo, hitgroup, corpseEnt)
	local corpsePhys = corpseEnt:GetPhysicsObject()
	if IsValid(corpsePhys) then
		corpsePhys:AddVelocity(Vector(math.Rand(-200, 200), math.Rand(-200, 200), math.Rand(200, 400)))
		corpsePhys:AddAngleVelocity(Vector(math.Rand(-100, 100), math.Rand(-100, 100), math.Rand(-100, 100)))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRemove()
	VJ.STOPSOUND(self.CurrentTankMovingSound)
	timer.Destroy("timer_shell_attack" .. self:EntIndex())
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Tank_Sound_Moving()
	if self.HasSounds == false or self.HasFootStepSound == false then return end
	
	local sdTbl = VJ.PICK(self.Tank_SoundTbl_Turning)
	if sdTbl == false then sdTbl = VJ.PICK(self.Tank_DefaultSoundTbl_Turning) end -- Default table
	self.CurrentTankMovingSound = VJ.CreateSound(self, sdTbl, self.Tank_TurningSoundLevel, math.random(self.Tank_TurningSoundPitch.a, self.Tank_TurningSoundPitch.b))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Tank_Sound_ReloadShell()
	if self.HasSounds == false or self.HasReloadShellSound == false then return end
	
	local sdTbl = VJ.PICK(self.Tank_SoundTbl_ReloadShell)
	if sdTbl == false then sdTbl = VJ.PICK(self.Tank_DefaultSoundTbl_ReloadShell) end -- Default table
	//self.CurrentTankFiringSound = VJ.CreateSound(self, sdTbl, self.Tank_ReloadShellSoundLevel, math.random(self.Tank_ReloadShellSoundPitch.a, self.Tank_ReloadShellSoundPitch.b))
	VJ.EmitSound(self, sdTbl, self.Tank_ReloadShellSoundLevel, math.random(self.Tank_ReloadShellSoundPitch.a, self.Tank_ReloadShellSoundPitch.b))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Tank_Sound_FireShell()
	if self.HasSounds == false or self.HasFireShellSound == false then return end
	
	local sdTbl = VJ.PICK(self.Tank_SoundTbl_FireShell)
	if sdTbl == false then sdTbl = VJ.PICK(self.Tank_DefaultSoundTbl_FireShell) end -- Default table
	VJ.EmitSound(self, sdTbl, 500, 100)
end