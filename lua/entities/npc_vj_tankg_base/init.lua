AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
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
ENT.ImmuneDamagesTable = {DMG_SLASH,DMG_GENERIC,DMG_CLUB,DMG_BULLET,DMG_BUCKSHOT,DMG_PHYSGUN} -- You can set Specific types of damages for the SNPC to be immune to
ENT.FindEnemy_UseSphere = true -- Should the SNPC be able to see all around him? (360) | Objects and walls can still block its sight!
ENT.DeathCorpseAlwaysCollide = true -- Should the corpse always collide?
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
ENT.Tank_AngleDiffuseNumber = 180
ENT.Tank_UseNegativeAngleDiffuseNumber = false
ENT.Tank_AngleDiffuseGeneralNumber = 5
ENT.Tank_UsesRightAngles = false -- For models that are rotated towards the right side
	-- ====== Sight Variables ====== --
ENT.Tank_SeeClose = 350 -- If the enemy is closer than this number, than don't shoot!
ENT.Tank_SeeFar = 5000 -- If the enemy is higher than this number, than don't shoot!
ENT.Tank_SeeLimit = 6000 -- How far can it see?
	-- ====== Tank Shell Variables ====== --
ENT.Tank_Shell_TimeUntilFire = 2 -- How much time until it fires the shell?
ENT.Tank_Shell_SpawnPos = Vector(-170,0,65)
ENT.Tank_Shell_EntityToSpawn = "obj_vj_tank_shell" -- The entity that is spawned when the shell is fired
ENT.Tank_Shell_VelocitySpeed = 5000 -- How fast should the tank shell travel?
ENT.Tank_Shell_DynamicLightPos = Vector(-200,0,0)
ENT.Tank_Shell_MuzzleFlashPos = Vector(0,-235,18)
ENT.Tank_Shell_ParticlePos = Vector(-205,00,72)
	-- ====== Sound Variables ====== --
ENT.Tank_SoundTbl_Turning = {}
ENT.Tank_SoundTbl_ReloadShell = {}
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
function ENT:Tank_CustomOnThink() return true end -- Return false to disable the default base code
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Tank_CustomOnShellFire(Shell) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Tank_CustomOnDeath_AfterCorpseSpawned(dmginfo,hitgroup,GetCorpse) end
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
ENT.Tank_ShellReady = false -- Is the shell ready?
ENT.Tank_ProperHeightShoot = false -- Is the enemy position proper height for it to shoot?
ENT.Tank_ResetedEnemy = false
ENT.Tank_GunnerIsTurning = false
ENT.Tank_Status = 0
ENT.Tank_TurningLerp = nil
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:CustomInitialize_CustomTank()
	self.FiringShell = false
	self.Tank_ShellReady = false
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
	if self:Tank_CustomOnThink() == true then
		//if !self:GetParent() then self:Remove() end
		if GetConVarNumber("vj_npc_noidleparticle") == 1 then return end
		timer.Simple(0.1,function()
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

	//if self.Tank_ShellReady == true then print("Tank_ShellReady = true") else print("Tank_ShellReady = false") end
	//if self.Tank_FacingTarget == true then print("Tank_FacingTarget = true") else print("Tank_FacingTarget = false") end
	//if self.FiringShell == true then print("FiringShell = true") else print("FiringShell = false") end

	//self:FindEnemySphere()
	//print(self:GetEnemy())

	if self.Tank_GunnerIsTurning == true then self:Tank_Sound_Moving() else VJ_STOPSOUND(self.tank_movingsd) end
	self:CustomOnSchedule()

	if self.Tank_FacingTarget == false then self.FiringShell = false end
	if self.Tank_ShellReady == false then self.FiringShell = false end
	if self.Tank_Status == 0 then
		if !IsValid(self:GetEnemy()) then
			self.Tank_Status = 1
			self.Tank_GunnerIsTurning = false
		else
			local Angle_Enemy = (self:GetEnemy():GetPos() - self:GetPos() /*+ Vector(80,0,80)*/):Angle()
			local Angle_Current = self:GetAngles()
			local Angle_Diffuse;
			if self.Tank_UseNegativeAngleDiffuseNumber == true then
			Angle_Diffuse = self:AngleDiffuse(Angle_Enemy.y,Angle_Current.y-self.Tank_AngleDiffuseNumber) else -- Cannon looking direction
			Angle_Diffuse = self:AngleDiffuse(Angle_Enemy.y,Angle_Current.y+self.Tank_AngleDiffuseNumber) end -- Cannon looking direction
			local Heigh_Ratio = (self:GetEnemy():GetPos().z - self:GetPos().z ) / self:GetPos():Distance(Vector(self:GetEnemy():GetPos().x,self:GetEnemy():GetPos().y,self:GetPos().z))
			-- ^^^ How high it can shoot ^^^ --
			if math.abs(Heigh_Ratio) < 0.15 then self.Tank_ProperHeightShoot = true else self.Tank_ProperHeightShoot = false end
			self.Tank_GunnerIsTurning = false
			if math.abs(Angle_Diffuse) < self.Tank_AngleDiffuseGeneralNumber && self.FiringShell == false && math.abs(Heigh_Ratio) < 0.15 && self:GetPos():Distance(self:GetEnemy():GetPos()) > self.Tank_SeeClose then
			-- If the diffuse and the height and the enemy distance is higher than the self.Tank_SeeClose than shoot!
				self.Tank_GunnerIsTurning = false
				self.FiringShell = true
				self.Tank_FacingTarget = true
				if self:Visible(self:GetEnemy()) then
				if GetConVarNumber("vj_npc_norange") == 0 then
				self:Tank_PrepareShell() end end
			elseif Angle_Diffuse > self.Tank_AngleDiffuseGeneralNumber then
				if self.Tank_TurningLerp == nil then self.Tank_TurningLerp = self:GetLocalAngles() end
				self.Tank_TurningLerp = LerpAngle(1, self.Tank_TurningLerp, self.Tank_TurningLerp + Angle(0, math.Clamp(Angle_Diffuse, 0, 5), 0))
				self:SetLocalAngles(self.Tank_TurningLerp)
				//self:SetLocalAngles(self:GetLocalAngles() + Angle(0,5,0))
				self.Tank_GunnerIsTurning = true
				self.Tank_FacingTarget = false
				self.FiringShell = false
			elseif Angle_Diffuse < -self.Tank_AngleDiffuseGeneralNumber then
				if self.Tank_TurningLerp == nil then self.Tank_TurningLerp = self:GetLocalAngles() end
				self.Tank_TurningLerp = LerpAngle(1, self.Tank_TurningLerp, self.Tank_TurningLerp + Angle(0, -math.Clamp(math.abs(Angle_Diffuse), 0, 5), 0))
				self:SetLocalAngles(self.Tank_TurningLerp)
				//self:SetLocalAngles(self:GetLocalAngles() + Angle(0,-5,0))
				self.Tank_GunnerIsTurning = true
				self.Tank_FacingTarget = false
				self.FiringShell = false
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnSchedule()
	if self.Dead == true then return end
	
	self:IdleSoundCode()
	self:DoIdleAnimation()
	
	if !IsValid(self:GetEnemy()) then
		if self.Tank_ResetedEnemy == false then
		self.Tank_ResetedEnemy = true
		self:ResetEnemy() end
		//self:FindEnemySphere()
	else
		self.Tank_ResetedEnemy = false
		local EnemyPos = self:GetEnemy():GetPos()
		local EnemyPosToSelf = self:GetPos():Distance(EnemyPos)
		if self:GetParent().VJ_IsBeingControlled == true then
			self.Tank_Status = 0
		elseif self:GetParent().VJ_IsBeingControlled == false then
			if EnemyPosToSelf > self.Tank_SeeLimit then -- If more than this, Don't fire!
				self.Tank_Status = 1
			elseif EnemyPosToSelf < self.Tank_SeeFar && EnemyPosToSelf > self.Tank_SeeClose then -- Between this two numbers than fire!
				self.Tank_Status = 0
			else
				self.Tank_Status = 0
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Tank_PrepareShell()
	if self.Tank_ProperHeightShoot == false or (self:GetParent().VJ_IsBeingControlled == true && !self:GetParent().VJ_TheController:KeyDown(IN_ATTACK2)) then return end
	/*if self.Tank_FacingTarget == true && IsValid(self:GetEnemy() && IsValid(self:GetEnemy()) && self:GetEnemy():IsNPC() then
		self:GetEnemy():VJ_SetSchedule(SCHED_TAKE_COVER_FROM_ENEMY)
	end*/

	if self.Tank_ShellReady == false then
		self:Tank_Sound_ReloadShell()
		self.Tank_ShellReady = true
	end

	if self.Dead == false then
		timer.Create("timer_shell_attack"..self:EntIndex(),self.Tank_Shell_TimeUntilFire,1,function()
			self:Tank_FireShell()
			self.FiringShell = false
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Tank_FireShell()
	if (self.Dead == true) or (GetConVarNumber("ai_disabled") == 1) or (self.Tank_ProperHeightShoot == false) or (!IsValid(self:GetEnemy())) then return end // self.Tank_FacingTarget != true
	if self:Visible(self:GetEnemy()) then
		self:Tank_Sound_FireShell()
		
		self.Tank_FireLight1 = ents.Create("light_dynamic")
		self.Tank_FireLight1:SetKeyValue("brightness", "4")
		self.Tank_FireLight1:SetKeyValue("distance", "400")
		self.Tank_FireLight1:SetPos(self:LocalToWorld(self.Tank_Shell_DynamicLightPos))
		self.Tank_FireLight1:SetLocalAngles(self:GetAngles())
		self.Tank_FireLight1:Fire("Color", "255 150 60")
		self.Tank_FireLight1:SetParent(self)
		self.Tank_FireLight1:Spawn()
		self.Tank_FireLight1:Activate()
		self.Tank_FireLight1:Fire("TurnOn","",0)
		self.Tank_FireLight1:Fire("Kill","",0.1)
		self:DeleteOnRemove(self.Tank_FireLight1)

		local counter_effect = 0
		for i=1,40 do
			counter_effect = counter_effect + 0.1
			timer.Simple(counter_effect,function() if self.Dead == false then self:StartShootEffects() end end)
		end

		local particle_smoke = ents.Create("info_particle_system")
		particle_smoke:SetKeyValue("effect_name","smoke_exhaust_01a")
		particle_smoke:SetPos(self:LocalToWorld(self.Tank_Shell_ParticlePos))
		particle_smoke:SetAngles(Angle(self:GetAngles().x,-self:GetAngles().y,self:GetAngles().z))
		particle_smoke:SetParent(self)
		particle_smoke:Spawn()
		particle_smoke:Activate()
		particle_smoke:Fire("Start","",0)
		particle_smoke:Fire("Kill","",4)

		local particle_whitesmoke = ents.Create("info_particle_system")
		particle_whitesmoke:SetKeyValue("effect_name","Advisor_Pod_Steam_Continuous")
		particle_whitesmoke:SetPos(self:LocalToWorld(self.Tank_Shell_ParticlePos))
		particle_whitesmoke:SetAngles(Angle(self:GetAngles().x,-self:GetAngles().y,self:GetAngles().z))
		particle_whitesmoke:SetParent(self)
		particle_whitesmoke:Spawn()
		particle_whitesmoke:Activate()
		particle_whitesmoke:Fire("Start","",0)
		particle_whitesmoke:Fire("Kill","",4)

		local flash = ents.Create("env_muzzleflash")
		flash:SetPos(self:LocalToWorld(self.Tank_Shell_MuzzleFlashPos))
		flash:SetKeyValue("scale","6")
		if self.Tank_UsesRightAngles == true then
		flash:SetKeyValue("angles",tostring(self:GetRight():Angle())) else
		flash:SetKeyValue("angles",tostring(self:GetForward():Angle())) end
		flash:Fire("Fire",0,0)

		local dust = EffectData()
		dust:SetOrigin(self:GetParent():GetPos())
		dust:SetScale(500)
		util.Effect("ThumperDust",dust)
		util.ScreenShake(self:GetPos(),100,200,1,2500)
		
		local ShootPos = (self:GetEnemy():GetPos() + self:GetEnemy():OBBCenter() - self:LocalToWorld(self.Tank_Shell_SpawnPos)):GetNormal()*self.Tank_Shell_VelocitySpeed
		if self.Tank_FacingTarget == false then
			if self.Tank_UsesRightAngles == true then
				ShootPos = self:GetRight()*ShootPos:Length()
			else
				ShootPos = self:GetForward()*-ShootPos:Length()
			end
		end
		local Projectile_Shell = ents.Create(self.Tank_Shell_EntityToSpawn)
		Projectile_Shell:SetPos(self:LocalToWorld(self.Tank_Shell_SpawnPos))
		Projectile_Shell:SetAngles(ShootPos:Angle())
		Projectile_Shell:Spawn()
		Projectile_Shell:Activate()
		Projectile_Shell:SetOwner(self)
		local phys = Projectile_Shell:GetPhysicsObject()
		if phys:IsValid() then
			phys:SetVelocity(Vector(ShootPos.x,ShootPos.y,math.Clamp(ShootPos.z,self.Tank_Shell_SpawnPos.z+-735,self.Tank_Shell_SpawnPos.z+335)))
		end
		
		self:Tank_CustomOnShellFire(Projectile_Shell)
	else
		self.Tank_FacingTarget = false
	end
	self.Tank_ShellReady = false
	self.FiringShell = false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDeath_AfterCorpseSpawned(dmginfo,hitgroup,GetCorpse)
	if self:Tank_CustomOnDeath_AfterCorpseSpawned(dmginfo,hitgroup,GetCorpse) == true then
		GetCorpse:GetPhysicsObject():AddVelocity(Vector(math.Rand(-200,200), math.Rand(-200,200),math.Rand(200,400)))
		GetCorpse:GetPhysicsObject():AddAngleVelocity(Vector(math.Rand(-100,100),math.Rand(-100,100),math.Rand(-100,100)))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRemove()
	VJ_STOPSOUND(self.shootsd1)
	VJ_STOPSOUND(self.tank_movingsd)
	timer.Destroy("timer_shell_attack"..self:EntIndex())
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Tank_Sound_Moving()
	if self.HasSounds == false or self.HasFootStepSound == false then return end
	
	local sdtbl = VJ_PICK(self.Tank_SoundTbl_Turning)
	if sdtbl == false then sdtbl = VJ_PICK(self.Tank_DefaultSoundTbl_Turning) end -- Default table
	self.tank_movingsd = VJ_CreateSound(self,sdtbl,80,100)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Tank_Sound_ReloadShell()
	if self.HasSounds == false or self.HasRangeAttackSound == false then return end
	
	local sdtbl = VJ_PICK(self.Tank_SoundTbl_ReloadShell)
	if sdtbl == false then sdtbl = VJ_PICK(self.Tank_DefaultSoundTbl_ReloadShell) end -- Default table
	self.shootsd1 = VJ_CreateSound(self,sdtbl,90,100)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Tank_Sound_FireShell()
	if self.HasSounds == false or self.HasRangeAttackSound == false then return end
	
	local sdtbl = VJ_PICK(self.Tank_SoundTbl_FireShell)
	if sdtbl == false then sdtbl = VJ_PICK(self.Tank_DefaultSoundTbl_FireShell) end -- Default table
	VJ_EmitSound(self,sdtbl,500,100)
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/