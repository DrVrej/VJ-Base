AddCSLuaFile("shared.lua")
include("shared.lua")
include("vj_base/ai/base_tank.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Core ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ENT.StartHealth = 0
ENT.SightDistance = 10000
ENT.MovementType = VJ_MOVETYPE_STATIONARY
ENT.CanTurnWhileStationary = false
ENT.GodMode = true
ENT.EnemyDetection = false
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Tank Base ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ENT.Tank_AngleOffset = 0 -- Use to offset the forward angle if the model's y-axis isn't facing the correct direction
ENT.Tank_AngleDiffuseFiringLimit = 5 -- Firing angle diffuse limit, useful for larger barrel tanks by increasing it | lower number = More specific the barrel has to aim to fire
	-- ====== Movement ====== --
ENT.Tank_TurningSpeed = 5 -- How fast the gun moves as it's aiming towards an enemy
	-- ====== Projectile Shell ====== --
ENT.Tank_Shell_FireMin = 350 -- If the enemy is closer than this number, than don't shoot!
ENT.Tank_Shell_FireMax = ENT.SightDistance -- If the enemy is higher than this number, than don't shoot!
ENT.Tank_Shell_NextFireTime = 0 -- Delay between each fire, triggered the moment when the shell leaves the tank | It can NOT even reload if this delay is active!
ENT.Tank_Shell_TimeUntilFire = 2.5 -- Delay until it fires the shell (Ran after reloading) | If Failure: it will instantly fire it the moment it's facing the enemy again!
ENT.Tank_Shell_SpawnPos = Vector(-170, 0, 65)
ENT.Tank_Shell_Entity = "obj_vj_rocket" -- Shell entity to spawn
ENT.Tank_Shell_VelocitySpeed = 4000 -- How fast should the shell travel?
ENT.Tank_Shell_MuzzleFlashPos = Vector(0, -235, 18)
ENT.Tank_Shell_ParticlePos = Vector(-205, 0, 72)
	-- ====== Sounds ====== --
-- Gun turning movement sound
ENT.HasMoveSound = true
ENT.Tank_SoundTbl_Turning = false
ENT.Tank_TurningSoundLevel = 80
ENT.Tank_TurningSoundPitch = VJ.SET(100, 100)
-- Shell reload sound
ENT.HasReloadShellSound = true
ENT.Tank_SoundTbl_ReloadShell = false
ENT.Tank_ReloadShellSoundLevel = 75
ENT.Tank_ReloadShellSoundPitch = VJ.SET(90, 100)
-- Shell fire sound
ENT.HasFireShellSound = true
ENT.Tank_SoundTbl_FireShell = false
ENT.Tank_FireShellSoundLevel = 140
ENT.Tank_FireShellSoundPitch = VJ.SET(90, 100)

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Customization Functions ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- Use the functions below to customize certain parts of the base or to add new custom systems
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Tank_Init() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Tank_OnThink() end -- Return true to disable the default base code (Its just the Tank_UpdateIdleParticles)
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Tank_OnThinkActive() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Tank_OnPrepareShell() end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[
Called when the tank is firing its shell

=-=-=| PARAMETERS |=-=-=
	1. status [string] : Type of update that is occurring, holds one of the following states:
		-> "Init" : Before the shell is created, can be used to override the shell entity code
				USAGE EXAMPLES -> Create completely custom shell entity code
				PARAMETERS
					5. statusData [nil]
				RETURNS
					-> [nil | bool] : Returning true will NOT let the base shell execute, effectively overriding it entirely (Effects still run!)
		-> "OnCreate" : Right after the shell is created but before anything is set
				USAGE EXAMPLES -> Set an spawn value for the projectile, such various types of shells inside a single projectile class
				PARAMETERS
					5. statusData [entity] : The newly created shell entity (but not spawned!)
				RETURNS
					-> [nil | vector] : Returning a vector to override the spawn position
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
	-> [nil | bool | vector] : Depends on `status` value, refer to it for more details
--]]
function ENT:Tank_OnFireShell(status, statusData) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Tank_UpdateIdleParticles()
	-- Example:
	//local effectData = EffectData()
	//effectData:SetScale(1)
	//effectData:SetEntity(self)
	//effectData:SetOrigin(self:GetPos() + self:GetForward() * -130 + self:GetRight() * 25  + self:GetUp() * 45)
	//util.Effect("VJ_VehicleExhaust", effectData, true, true)
	//effectData:SetOrigin(self:GetPos() + self:GetForward() * -130 + self:GetRight() * -28 + self:GetUp() * 45)
	//util.Effect("VJ_VehicleExhaust", effectData, true, true)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ ///// WARNING: Don't touch anything below this line! \\\\\ ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ENT.Tank_FacingTarget = false -- Is it facing the enemy?
ENT.Tank_ProperHeightShoot = false -- Is the enemy position proper height for it to shoot?
ENT.Tank_GunnerIsTurning = false
ENT.Tank_Status = 0 -- 0 = Can fire | 1 = Can NOT fire
ENT.Tank_Shell_NextFireT = 0
ENT.Tank_TurningLerp = nil
ENT.Tank_NextIdleParticles = 0

local TANK_SHELL_STATUS_EMPTY = 0
local TANK_SHELL_STATUS_RELOADING = 1
local TANK_SHELL_STATUS_READY = 2
ENT.Tank_Shell_Status = TANK_SHELL_STATUS_EMPTY

local vj_npc_range = GetConVar("vj_npc_range")
local vj_npc_reduce_vfx = GetConVar("vj_npc_reduce_vfx")

local metaEntity = FindMetaTable("Entity")
local funcGetTable = metaEntity.GetTable
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetSolid(SOLID_NONE)
	self.Tank_NextIdleParticles = CurTime() + 1
	self.DeathAnimationCodeRan = true -- So corpse doesn't fly away on death (Take this out if not using death explosion sequence)
	self:SetPhysicsDamageScale(0) -- Take no physics damage
	self:Tank_Init()
	if self.CustomInitialize_CustomTank then self:CustomInitialize_CustomTank() end -- !!!!!!!!!!!!!! DO NOT USE !!!!!!!!!!!!!! [Backwards Compatibility!]
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	if self:Tank_OnThink() != true && vj_npc_reduce_vfx:GetInt() == 0 && self.Tank_NextIdleParticles < CurTime() then
		self:Tank_UpdateIdleParticles()
		self.Tank_NextIdleParticles = CurTime() + 0.1
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThinkActive()
	local selfData = funcGetTable(self)
	if selfData.Dead then return end
	local parent = self:GetParent()
	if !IsValid(parent) then return end
	if selfData.VJ_NPC_Class != parent.VJ_NPC_Class then
		selfData.VJ_NPC_Class = parent.VJ_NPC_Class
	end
	local ene = parent:GetEnemy()
	self:SetEnemy(ene)
	self:Tank_OnThinkActive()
	self:SelectSchedule()
	
	if selfData.Tank_Status == 0 then
		if IsValid(ene) then
			selfData.Tank_GunnerIsTurning = false
			local myPos = self:GetPos()
			local enePos = ene:GetPos()
			local angEne = (enePos - myPos):Angle()
			local angDiffuse = self:Tank_AngleDiffuse(angEne.y, self:GetAngles().y + selfData.Tank_AngleOffset) -- Cannon looking direction
			local heightRatio = (enePos.z - myPos.z) / myPos:Distance(Vector(enePos.x, enePos.y, myPos.z))
			selfData.Tank_ProperHeightShoot = math.abs(heightRatio) < 0.15 and true or false -- How high it can fire
			-- If the enemy is within the barrel firing limit AND not already firing a shell AND its height is is reachable AND the enemy is not extremely close, then FIRE!
			if math.abs(angDiffuse) < selfData.Tank_AngleDiffuseFiringLimit && selfData.Tank_ProperHeightShoot && selfData.EnemyData.Distance > selfData.Tank_Shell_FireMin then
				selfData.Tank_FacingTarget = true
				if self:Visible(ene) && vj_npc_range:GetInt() == 1 then
					self:Tank_PrepareShell()
				end
			-- Turn Left
			elseif angDiffuse > selfData.Tank_AngleDiffuseFiringLimit then
				if selfData.Tank_TurningLerp == nil then selfData.Tank_TurningLerp = self:GetLocalAngles() end
				selfData.Tank_TurningLerp = LerpAngle(1, selfData.Tank_TurningLerp, selfData.Tank_TurningLerp + Angle(0, math.Clamp(angDiffuse, 0, selfData.Tank_TurningSpeed), 0))
				self:SetLocalAngles(selfData.Tank_TurningLerp)
				selfData.Tank_GunnerIsTurning = true
				selfData.Tank_FacingTarget = false
			-- Turn Right
			elseif angDiffuse < -selfData.Tank_AngleDiffuseFiringLimit then
				if selfData.Tank_TurningLerp == nil then selfData.Tank_TurningLerp = self:GetLocalAngles() end
				selfData.Tank_TurningLerp = LerpAngle(1, selfData.Tank_TurningLerp, selfData.Tank_TurningLerp + Angle(0, -math.Clamp(math.abs(angDiffuse), 0, selfData.Tank_TurningSpeed), 0))
				self:SetLocalAngles(selfData.Tank_TurningLerp)
				selfData.Tank_GunnerIsTurning = true
				selfData.Tank_FacingTarget = false
			end
		else
			selfData.Tank_Status = 1
			selfData.Tank_GunnerIsTurning = false
		end
	end
	
	if selfData.Tank_GunnerIsTurning then self:Tank_PlaySoundSystem("Movement") else VJ.STOPSOUND(selfData.CurrentTankMovingSound) end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SelectSchedule()
	local selfData = funcGetTable(self)
	if selfData.Dead then return end
	
	local eneValid = IsValid(self:GetEnemy())
	self:PlayIdleSound(nil, nil, eneValid)
	self:MaintainIdleBehavior()
	
	if eneValid then
		-- Can always fire when being controlled
		if self:GetParent().VJ_IsBeingControlled then
			selfData.Tank_Status = 0
		else
			-- Between these 2 limits it can fire! --
			local eneData = selfData.EnemyData
			if eneData.Distance < selfData.Tank_Shell_FireMax && eneData.Distance > selfData.Tank_Shell_FireMin then
				selfData.Tank_Status = 0
			-- Out of range, can't fire!
			else
				selfData.Tank_Status = 1
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Tank_PrepareShell()
	if (CurTime() < self.Tank_Shell_NextFireT) or (self:GetParent().VJ_IsBeingControlled && !self:GetParent().VJ_TheController:KeyDown(IN_ATTACK2)) then return end
	
	-- If it's already ready, then just fire it!
	if self.Tank_Shell_Status == TANK_SHELL_STATUS_READY then
		self:Tank_FireShell()
	-- Otherwise reload and fire
	elseif self.Tank_Shell_Status == TANK_SHELL_STATUS_EMPTY then
		self:Tank_OnPrepareShell()
		self:Tank_PlaySoundSystem("ShellReload")
		self.Tank_Shell_Status = TANK_SHELL_STATUS_RELOADING
		local ene = self:GetEnemy()
		if !ene:IsNPC() or (ene:IsNPC() && ene:GetEnemy() == self:GetParent()) then -- Don't run away when you don't even know that the tank exists!
			sound.EmitHint(SOUND_DANGER, ene:GetPos() + ene:OBBCenter(), 80, self.Tank_Shell_TimeUntilFire, self)
		end
		timer.Create("timer_shell_attack" .. self:EntIndex(), self.Tank_Shell_TimeUntilFire, 1, function()
			self.Tank_Shell_Status = TANK_SHELL_STATUS_READY
			self:Tank_FireShell()
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Tank_FireShell()
	local selfData = funcGetTable(self)
	local ene = self:GetEnemy()
	if !VJ_CVAR_AI_ENABLED or selfData.Dead or !selfData.Tank_ProperHeightShoot or !selfData.Tank_FacingTarget or !IsValid(ene) then return end // selfData.Tank_FacingTarget != true
	if self:Visible(ene) then
		self:Tank_PlaySoundSystem("ShellFire")
		
		if self:Tank_OnFireShell("Init") != true then
			local shell = ents.Create(selfData.Tank_Shell_Entity)
			local spawnPos;
			local onCreateCall = self:Tank_OnFireShell("OnCreate", shell)
			if isvector(onCreateCall) then
				spawnPos = onCreateCall
			else
				spawnPos = self:LocalToWorld(selfData.Tank_Shell_SpawnPos)
			end
			local calculatedVel = (ene:GetPos() + ene:OBBCenter() - spawnPos):GetNormal()*selfData.Tank_Shell_VelocitySpeed
			-- If not facing, then just shoot straight ahead
			if !selfData.Tank_FacingTarget then
				calculatedVel = self:GetForward()
				calculatedVel:Rotate(Angle(0, selfData.Tank_AngleOffset, 0))
				calculatedVel = calculatedVel * selfData.Tank_Shell_VelocitySpeed
			end
			shell:SetPos(spawnPos)
			shell:SetAngles(calculatedVel:Angle())
			shell:Spawn()
			shell:Activate()
			shell:SetOwner(self)
			if self:Tank_OnFireShell("OnSpawn", shell) != true then
				local phys = shell:GetPhysicsObject()
				if IsValid(phys) then
					phys:SetVelocity(calculatedVel)
				end
			end
		end
		if self:Tank_OnFireShell("Effects") != true then
			local myAng = self:GetAngles()
			local myAngForward = myAng + Angle(0, selfData.Tank_AngleOffset, 0)
			util.ScreenShake(self:GetPos(), 100, 200, 1, 2500)
			
			-- Muzzle flash
			local muzzleFlashPos = self:LocalToWorld(selfData.Tank_Shell_MuzzleFlashPos)
			local muzzleFlash = ents.Create("env_muzzleflash")
			muzzleFlash:SetPos(muzzleFlashPos)
			muzzleFlash:SetAngles(myAngForward)
			muzzleFlash:SetKeyValue("scale", "10")
			muzzleFlash:Fire("Fire")
			local lightFire = ents.Create("light_dynamic")
			lightFire:SetKeyValue("brightness", "4")
			lightFire:SetKeyValue("distance", "400")
			lightFire:SetPos(muzzleFlashPos)
			lightFire:SetLocalAngles(myAng)
			lightFire:Fire("Color", "255 150 60")
			lightFire:SetParent(self)
			lightFire:Spawn()
			lightFire:Activate()
			lightFire:Fire("TurnOn")
			lightFire:Fire("Kill", nil, 0.1)
			self:DeleteOnRemove(lightFire)
			
			-- Smoke effect
			local smokePos = self:LocalToWorld(selfData.Tank_Shell_ParticlePos)
			local smokeWhite = ents.Create("info_particle_system")
			smokeWhite:SetKeyValue("effect_name", "vj_smoke_white_medium")
			smokeWhite:SetPos(smokePos)
			smokeWhite:SetAngles(myAngForward)
			smokeWhite:SetParent(self)
			smokeWhite:Spawn()
			smokeWhite:Activate()
			smokeWhite:Fire("Start")
			smokeWhite:Fire("Kill", nil, 6)
			
			-- Dust effect
			local dust = EffectData()
			dust:SetOrigin(self:GetParent():GetPos())
			dust:SetScale(800)
			util.Effect("ThumperDust", dust)
			
			//local smoke = ents.Create("env_smoketrail")
			//smoke:SetPos(self:LocalToWorld(selfData.Tank_Shell_ParticlePos))
			//smoke:SetAngles(myAngForward)
			//smoke:SetKeyValue("opacity", "1")
			//smoke:SetKeyValue("spawnrate", "15")
			//smoke:SetKeyValue("lifetime", "5")
			//smoke:SetKeyValue("startsize", "1")
			//smoke:SetKeyValue("endsize", "50")
			//smoke:SetKeyValue("spawnradius", "5")
			//smoke:SetKeyValue("startcolor", "255 255 255 255")
			//smoke:SetKeyValue("endcolor", "255 255 255 255")
			//smoke:SetKeyValue("minspeed", "30")
			//smoke:SetKeyValue("maxspeed", "50")
			//smoke:SetKeyValue("mindirectedspeed", "50")
			//smoke:SetKeyValue("maxdirectedspeed", "75")
			//smoke:SetParent(self)
			//smoke:Spawn()
			//smoke:Activate()
			//smoke:Fire("Kill", nil, 4)
		end
		selfData.Tank_Shell_Status = TANK_SHELL_STATUS_EMPTY
		selfData.Tank_Shell_NextFireT = CurTime() + selfData.Tank_Shell_NextFireTime
	else -- Not visible
		selfData.Tank_FacingTarget = false
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnCreateDeathCorpse(dmginfo, hitgroup, corpse)
	local corpsePhys = corpse:GetPhysicsObject()
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
function ENT:Tank_PlaySoundSystem(sdSet)
	local selfData = funcGetTable(self)
	if !selfData.HasSounds or !sdSet then return end
	if sdSet == "Movement" then
		if selfData.HasMoveSound then
			local curMoveSD = selfData.CurrentTankMovingSound
			if !curMoveSD or (curMoveSD && !curMoveSD:IsPlaying()) then
				VJ.STOPSOUND(curMoveSD)
				selfData.CurrentTankMovingSound = VJ.CreateSound(self, VJ.PICK(selfData.Tank_SoundTbl_Turning) or "vj_base/vehicles/armored/gun_move2.wav", selfData.Tank_TurningSoundLevel, math.random(selfData.Tank_TurningSoundPitch.a, selfData.Tank_TurningSoundPitch.b))
			end
		end
	elseif sdSet == "ShellFire" then
		if selfData.HasFireShellSound then
			VJ.EmitSound(self, VJ.PICK(selfData.Tank_SoundTbl_FireShell) or "VJ.NPC_Tank.Fire", selfData.Tank_FireShellSoundLevel, math.random(selfData.Tank_FireShellSoundPitch.a, selfData.Tank_FireShellSoundPitch.b))
		end
	elseif sdSet == "ShellReload" then
		if selfData.HasReloadShellSound then
			VJ.EmitSound(self, VJ.PICK(selfData.Tank_SoundTbl_ReloadShell) or "vj_base/vehicles/armored/gun_reload.wav", selfData.Tank_ReloadShellSoundLevel, math.random(selfData.Tank_ReloadShellSoundPitch.a, selfData.Tank_ReloadShellSoundPitch.b))
		end
	end
end