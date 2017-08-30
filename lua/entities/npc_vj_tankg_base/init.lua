AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/

	-- Default ---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Model = {} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want 
ENT.StartHealth = 0
//ENT.MoveType = MOVETYPE_NONE
ENT.HullType = HULL_TINY
ENT.HullSizeNormal = false -- set to false to cancel out the self:SetHullSizeNormal()
ENT.HasSetSolid = false -- set to false to disable SetSolid
ENT.VJ_IsHugeMonster = true -- Is this a huge monster?
ENT.MovementType = VJ_MOVETYPE_STATIONARY -- How does the SNPC move?
ENT.CanTurnWhileStationary = false -- If set to true, the SNPC will be able to turn while it's a stationary SNPC
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.HasAllies = true -- Put to false if you want it not to have any allies
ENT.Bleeds = false -- Does the SNPC bleed? (Blood decal, particle, etc.)
ENT.HasMeleeAttack = false -- Should the SNPC have a melee attack?
ENT.DisableWeapons = true -- If set to true, it won't be able to use weapons
ENT.DisableInitializeCapabilities = true -- If true, it will disable the initialize capabilities, this will allow you to add your own
ENT.DisableSelectSchedule = true -- Disables Schedule code, Custom Schedule can still work
ENT.HasPainSounds = false -- If set to false, it won't play the pain sounds
ENT.GodMode = true -- Immune to everything
//ENT.HasDeathRagdoll = false -- If set to false, it will not spawn the regular ragdoll of the SNPC
ENT.CorpseAlwaysCollide = true -- Should the corpse always collide?
ENT.Immune_Dissolve = true -- Immune to Dissolving | Example: Combine Ball
ENT.Immune_AcidPoisonRadiation = true -- Immune to Acid, Poison and Radiation
ENT.Immune_Bullet = true -- Immune to Bullets
ENT.Immune_Freeze = true -- Immune to Freezing
ENT.Immune_Physics = true -- Immune to Physics
ENT.ImmuneDamagesTable = {DMG_SLASH,DMG_GENERIC,DMG_CLUB,DMG_BULLET,DMG_BUCKSHOT,DMG_PHYSGUN} -- You can set Specific types of damages for the SNPC to be immune to
ENT.DisableFindEnemy = true -- Disables FindEnemy code, friendly code still works though
ENT.FindEnemy_UseSphere = true -- Should the SNPC be able to see all around him? (360) | Objects and walls can still block its sight!
ENT.CallForHelp = false -- Does the SNPC call for help?
ENT.DisableWandering = true -- Disables wandering when the SNPC is idle
ENT.BringFriendsOnDeath = false -- Should the SNPC's friends come to its position before it dies?
ENT.CallForBackUpOnDamage = false -- Should the SNPC call for help when damaged? (Only happens if the SNPC hasn't seen a enemy)
ENT.MoveOrHideOnDamageByEnemy = false -- Should the SNPC move or hide when being damaged by an enemy?
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_Death = {"ambient/explosions/explode_2.wav"}

-- Tank Base
ENT.Tank_AngleDiffuseNumber = 180
ENT.Tank_UseNegativeAngleDiffuseNumber = false
ENT.Tank_AngleDiffuseGeneralNumber = 5
ENT.Tank_UsesRightAngles = false
ENT.Tank_SeeClose = 350 -- If the enemy is closer than this number, than don't shoot!
ENT.Tank_SeeFar = 5000 -- If the enemy is higher than this number, than don't shoot!
ENT.Tank_SeeLimit = 6000 -- How far can it see?

-- Tank Shell Variables
ENT.Tank_Shell_TimeUntilFire = 2 -- How much time until it fires the shell?
ENT.Tank_Shell_SpawnPos = Vector(-170,0,65)
ENT.Tank_Shell_EntityToSpawn = "obj_vj_tank_shell" -- The entity that is spawned when the shell is fired
ENT.Tank_Shell_VelocitySpeed = 5000 -- How fast should the tank shell travel?
ENT.Tank_Shell_DynamicLightPos = Vector(-200,0,0)
ENT.Tank_Shell_MuzzleFlashPos = Vector(0,-235,18)
ENT.Tank_Shell_ParticlePos = Vector(-205,00,72)

-- Independent Variables
ENT.Tank_FacingTarget = false -- Is it facing the enemy?
ENT.Tank_ShellReady = false -- Is the shell ready?
ENT.Tank_ProperHeightShoot = false -- Is the enemy position proper height for it to shoot?
ENT.Tank_ResetedEnemy = false
ENT.Tank_GunnerIsTurning = false
ENT.Tank_Status = 0

util.AddNetworkString("vj_tankg_base_spawneffects")
util.AddNetworkString("vj_tankg_base_shooteffects")
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomInitialize_CustomTank() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:TankBase_CustomOnShellFire(Shell) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:CustomInitialize_CustomTank()
	self.FiringShell = false
	self.Tank_ShellReady = false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:StartSpawnEffects()
	net.Start("vj_tankg_base_spawneffects")
	net.WriteEntity(self)
	net.Broadcast()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:StartShootEffects()
	net.Start("vj_tankg_base_shooteffects")
	net.WriteEntity(self)
	net.Broadcast()
end
---------------------------------------------------------------------------------------------------------------------------------------------
/*function ENT:GetRelationship(entity)
	if self.HasAllies == false then return end
	local friendslist = { "npc_vj_tank_base" } -- List
	for _,x in pairs( friendslist ) do
	local hl_friendlys = ents.FindByClass( x )
	for _,x in pairs( hl_friendlys ) do
	if entity == x then
	return D_LI
	end
  end
 end
end*/
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:AngleDiffuse(ang1, ang2)
	local outcome = ang1 - ang2
	if outcome < -180 then outcome = outcome + 360 end
	if outcome > 180 then outcome = outcome - 360 end
	return outcome
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	//if !self:GetParent() then self:Remove() end
	if GetConVarNumber("vj_npc_noidleparticle") == 1 then return end
	timer.Simple(0.1,function()
	if self.Dead == false then
	self:StartSpawnEffects() end end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink_AIEnabled()
	if self.Dead == true then return end
	self:SetEnemy(self:GetParent():GetEnemy())
	
	//print(self:GetEnemy())
	//if self.Tank_ShellReady == true then print("Tank_ShellReady = true") else print("Tank_ShellReady = false") end
	//if self.Tank_FacingTarget == true then print("Tank_FacingTarget = true") else print("Tank_FacingTarget = false") end
	//if self.FiringShell == true then print("FiringShell = true") else print("FiringShell = false") end

	//self:FindEnemySphere()
	//print(self:GetEnemy())
	
	if self.Tank_GunnerIsTurning == true then self:TANK_MOVINGSOUND() else VJ_STOPSOUND(self.tank_movingsd) end
	self:CustomOnSchedule()
	
	if self.Tank_FacingTarget == false then self.FiringShell = false end
	if self.Tank_ShellReady == false then self.FiringShell = false end
	if self.Tank_Status == 0 then
		if self:GetEnemy() == nil then
		self.Tank_Status = 1
		self.Tank_GunnerIsTurning = false
	else
	-- x = Forward | y = Right | z = Up
	local Angle_Enemy = (self:GetEnemy():GetPos() - self:GetPos() /*+ Vector(80,0,80)*/):Angle()
	local Angle_Current = self:GetAngles()
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
		self:RangeAttack_Base() end end
	elseif Angle_Diffuse > self.Tank_AngleDiffuseGeneralNumber then
		self:SetLocalAngles(self:GetLocalAngles() + Angle(0,2,0))
		self.Tank_GunnerIsTurning = true
		self.Tank_FacingTarget = false
		self.FiringShell = false
	elseif Angle_Diffuse < -self.Tank_AngleDiffuseGeneralNumber then
		self:SetLocalAngles(self:GetLocalAngles() + Angle(0,-2,0))
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

	if self:GetEnemy() == nil then
		if self.Tank_ResetedEnemy == false then
		self.Tank_ResetedEnemy = true
		self:ResetEnemy() end
		//self:FindEnemySphere()
	else
		self.Tank_ResetedEnemy = false
		EnemyPos = self:GetEnemy():GetPos()
		EnemyPosToSelf = self:GetPos():Distance(EnemyPos)
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
function ENT:TANK_MOVINGSOUND()
	if self.HasSounds == true then if GetConVarNumber("vj_npc_sd_footstep") == 0 then
	self.tank_movingsd = CreateSound(self, "vj_mili_tank/tank_gunnermove2_x.wav") self.tank_movingsd:SetSoundLevel(80)
	self.tank_movingsd:PlayEx(1,100)
	end
 end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttack_Base()
	if self.Tank_ProperHeightShoot == false then return end
	if self:GetParent().VJ_IsBeingControlled == true && !self:GetParent().VJ_TheController:KeyDown(IN_ATTACK2) then return end
	//if self.Tank_FacingTarget == true then
	//if (self:GetEnemy() != nil && self:GetEnemy() != NULL) then
		//if self:GetEnemy():IsNPC() then
			//self:GetEnemy():VJ_SetSchedule(SCHED_TAKE_COVER_FROM_ENEMY)
		//end
	//end

	local function Timer_ShellAttack()
		self:RangeAttack_Shell()
		self.FiringShell = false
	end

	if self.Tank_ShellReady == false then
		if self.HasSounds == true then
		if GetConVarNumber("vj_npc_sd_rangeattack") == 0 then
		self.shootsd1 = CreateSound(self, "vehicles/tank_readyfire1.wav") 
		self.shootsd1:SetSoundLevel(90)
		self.shootsd1:PlayEx(1,100) end end
		self.Tank_ShellReady = true
	end

	if self.Dead == false then timer.Create("timer_shell_attack"..self.Entity:EntIndex(),self.Tank_Shell_TimeUntilFire,1,Timer_ShellAttack) end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttack_Shell()
	if (self.Dead == true) or (self.Dead == false && GetConVarNumber("ai_disabled") == 1) or (self.Tank_ProperHeightShoot == false) then return end
	if IsValid(self:GetEnemy()) && self:GetEnemy() != NULL && self:GetEnemy() != nil /* && self.Tank_FacingTarget == true*/ then
		if self:Visible(self:GetEnemy()) then
			if self.HasSounds == true && GetConVarNumber("vj_npc_sd_rangeattack") == 0 then
				VJ_EmitSound(self,"vj_mili_tank/tank_fire"..math.random(1,4)..".wav",500,100)
			end
			
			//self:StartShootEffects()
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
			util.ScreenShake(self:GetPos(),100,200,1,2500)
			
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
			
			local ShootPos = (self:GetEnemy():GetPos()+self:GetEnemy():OBBCenter()-self:LocalToWorld(self.Tank_Shell_SpawnPos)):GetNormal()*self.Tank_Shell_VelocitySpeed
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
			
			self:TankBase_CustomOnShellFire(Projectile_Shell)
			self.Tank_ShellReady = false
			self.FiringShell = false
		else
			self.Tank_ShellReady = false
			self.FiringShell = false
			self.Tank_FacingTarget = false
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDeath_AfterCorpseSpawned(dmginfo,hitgroup,GetCorpse)
	GetCorpse:GetPhysicsObject():AddVelocity(Vector(math.Rand(-200,200), math.Rand(-200,200),math.Rand(200,400)))
	GetCorpse:GetPhysicsObject():AddAngleVelocity(Vector(math.Rand(-100,100),math.Rand(-100,100),math.Rand(-100,100)))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRemove()
	VJ_STOPSOUND(self.shootsd1)
	VJ_STOPSOUND(self.tank_movingsd)
	timer.Destroy("timer_shell_attack"..self.Entity:EntIndex())
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/