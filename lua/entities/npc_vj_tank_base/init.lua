if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
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
ENT.StartHealth = 200
ENT.HullType = HULL_LARGE
ENT.VJ_IsHugeMonster = true -- Is this a huge monster?
ENT.MovementType = VJ_MOVETYPE_PHYSICS -- How does the SNPC move?
ENT.Bleeds = false -- Does the SNPC bleed? (Blood decal, particle, etc.)
ENT.Immune_Dissolve = true -- Immune to Dissolving | Example: Combine Ball
ENT.Immune_AcidPoisonRadiation = true -- Immune to Acid, Poison and Radiation
ENT.Immune_Bullet = true -- Immune to Bullets
ENT.Immune_Physics = true -- Immune to Physics
ENT.ImmuneDamagesTable = {DMG_BULLET,DMG_BUCKSHOT,DMG_PHYSGUN} -- You can set Specific types of damages for the SNPC to be immune to
ENT.FindEnemy_UseSphere = true -- Should the SNPC be able to see all around him? (360) | Objects and walls can still block its sight!
ENT.GetDamageFromIsHugeMonster = true -- Should it get damaged no matter what by SNPCs that are tagged as VJ_IsHugeMonster?
ENT.DeathCorpseAlwaysCollide = true -- Should the corpse always collide?
ENT.WaitBeforeDeathTime = 2 -- Time until the SNPC spawns its corpse and gets removed
ENT.HasMeleeAttack = false -- Should the SNPC have a melee attack?
ENT.DisableInitializeCapabilities = true -- If true, it will disable the initialize capabilities, this will allow you to add your own
ENT.DisableSelectSchedule = true -- Disables Schedule code, Custom Schedule can still work
ENT.DisableWandering = true -- Disables wandering when the SNPC is idle
ENT.BringFriendsOnDeath = false -- Should the SNPC's friends come to its position before it dies?
ENT.CallForBackUpOnDamage = false -- Should the SNPC call for help when damaged? (Only happens if the SNPC hasn't seen a enemy)
ENT.MoveOrHideOnDamageByEnemy = false -- Should the SNPC move or hide when being damaged by an enemy?
ENT.CallForHelp = false -- Does the SNPC call for help?
ENT.HasPainSounds = false -- If set to false, it won't play the pain sounds
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_Breath = {"vj_mili_tank/tankidle1.wav"}
ENT.SoundTbl_Death = {"vj_mili_tank/tank_death1.wav"}

ENT.AlertSoundLevel = 70
ENT.IdleSoundLevel = 70
ENT.CombatIdleSoundLevel = 70
ENT.BreathSoundLevel = 80
ENT.DeathSoundLevel = 100

ENT.GeneralSoundPitch1 = 90
ENT.GeneralSoundPitch2 = 100
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Tank Base Variables ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ENT.Tank_GunnerENT = "npc_vj_tankg_base" -- The SNPC that will be the gunner (The head of the tank)
ENT.Tank_SpawningAngle = 180
ENT.Tank_AngleDiffuseNumber = 180
ENT.Tank_UseGetRightForSpeed = false -- Should it use GetRight instead of GetForward when driving?
	-- ====== Sight Variables ====== --
ENT.Tank_SeeClose = 500 -- If the enemy is closer than this number, than move!
ENT.Tank_SeeFar = 4000 -- If the enemy is higher than this number, than move!
ENT.Tank_SeeLimit = 6000 -- How far can it see?
	-- ====== Tank Movement Variables ====== --
ENT.Tank_TurningSpeed = 1.5 -- Turning Speed
ENT.Tank_ForwardSpead = 70 -- Forward speed
ENT.Tank_MoveAwaySpeed = -70 -- Move away speed
	-- ====== Collision Variables ====== --
ENT.Tank_CollisionBoundSize = 90
ENT.Tank_CollisionBoundUp = 100
ENT.Tank_CollisionBoundDown = -10
	-- ====== Death Variables ====== --
ENT.Tank_DeathSoldierModels = {} -- The corpses it will spawn on death (Example: A soldier) | false = Don't spawn anything
ENT.Tank_DeathSoldierChance = 3 -- The chance that the soldier spawns | 1 = always
ENT.Tank_DeathDecal = {"Scorch"} -- The decal that it places on the ground when it dies
	-- ====== Sound Variables ====== --
ENT.Tank_SoundTbl_DrivingEngine = {}
ENT.Tank_SoundTbl_Track = {}
ENT.Tank_SoundTbl_RunOver = {}

ENT.Tank_DefaultSoundTbl_DrivingEngine = {"vj_mili_tank/tankdriving1.wav"}
ENT.Tank_DefaultSoundTbl_Track = {"vj_mili_tank/tanktrack1.wav"}
ENT.Tank_DefaultSoundTbl_RunOver = {"vj_gib/bones_snapping.wav","vj_gib/bones_snapping2.wav","vj_gib/bones_snapping3.wav"}

//util.AddNetworkString("vj_tank_base_spawneffects")
//util.AddNetworkString("vj_tank_base_moveeffects")
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Customization Functions ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- Use the functions below to customize certain parts of the base or to add new custom systems
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomInitialize_CustomTank() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Tank_GunnerSpawnPosition()
	return self:GetPos()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Tank_CustomOnThink() return true end -- Return false to disable the default base code
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Tank_CustomOnRunOver(argent) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetNearDeathSparkPositions()
	local randpos = math.random(1,7)
	if randpos == 1 then self.Spark1:SetLocalPos(self:GetPos() +self:GetForward()*100 +self:GetUp()*60)
	elseif randpos == 2 then self.Spark1:SetLocalPos(self:GetPos() +self:GetForward()*30 +self:GetUp()*60)
	elseif randpos == 3 then self.Spark1:SetLocalPos(self.WhiteLight1:GetPos())
	elseif randpos == 4 then self.Spark1:SetLocalPos(self.WhiteLight2:GetPos())
	elseif randpos == 5 then self.Spark1:SetLocalPos(self:GetPos() +self:GetForward()*10 +self:GetUp()*60 +self:GetRight()*50)
	elseif randpos == 6 then self.Spark1:SetLocalPos(self:GetPos() +self:GetForward()*80 +self:GetUp()*60 +self:GetRight()*-50)
	elseif randpos == 7 then self.Spark1:SetLocalPos(self:GetPos() +self:GetForward()*-20 +self:GetUp()*60 +self:GetRight()*-30)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Tank_CustomOnPriorToKilled(dmginfo,hitgroup) return true end -- Return false to disable the default base code
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Tank_CustomOnDeath_AfterCorpseSpawned(dmginfo,hitgroup,GetCorpse) return true end -- Return false to disable the default base code
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Tank_CustomOnDeath_AfterDeathSoldierSpawned(dmginfo,hitgroup,SoldierCorpse) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Tank_CustomOnDeath_AfterCorpseSpawned_Effects(dmginfo,hitgroup,GetCorpse) return true end -- Return false to disable the default base code
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:StartSpawnEffects()
	/* Example:
	net.Start("vj_tank_base_spawneffects")
	net.WriteEntity(self)
	net.Broadcast()
	*/
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:StartMoveEffects()
	/* Example:
	net.Start("vj_tank_base_moveeffects")
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
ENT.Tank_ResetedEnemy = false
ENT.Tank_IsMoving = false
ENT.Tank_Status = 1
ENT.Tank_NextLowHealthSparkT = 0
ENT.Tank_NextRunOverSoundT = 0
ENT.TankTbl_DontRunOver = {npc_antlionguard=true,npc_turret_ceiling=true,monster_gargantua=true,monster_bigmomma=true,monster_nihilanth=true,npc_strider=true,npc_combine_camera=true,npc_helicopter=true,npc_combinegunship=true,npc_combinedropship=true,npc_rollermine=true}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:CustomInitialize_CustomTank()
	self:PhysicsInit(SOLID_BBOX) // SOLID_VPHYSICS
	self:SetSolid(SOLID_VPHYSICS)
	self:SetAngles(self:GetAngles() + Angle(0,self.Tank_SpawningAngle,0))
	//self:SetPos(self:GetPos()+Vector(0,0,90))
	self:SetCollisionBounds(Vector(self.Tank_CollisionBoundSize, self.Tank_CollisionBoundSize, self.Tank_CollisionBoundUp), Vector(-self.Tank_CollisionBoundSize, -self.Tank_CollisionBoundSize, self.Tank_CollisionBoundDown))

	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:SetMass(30000)
	end

	self.Gunner = ents.Create(self.Tank_GunnerENT)
	self.Gunner:Spawn()
	self.Gunner:SetPos(self:Tank_GunnerSpawnPosition())
	self.Gunner:SetAngles(self:GetAngles())
	self.Gunner:SetParent(self)

	/*local angrypapir = Vector(-100, -25, 50)
	self.ActualLight1 = ents.Create("env_projectedtexture")
	self.ActualLight1:SetLocalPos( self:GetPos() + (self:GetForward() * angrypapir.x ) + ( self:GetRight() * angrypapir.y ) + ( self:GetUp() * angrypapir.z ) )
	self.ActualLight1:SetLocalAngles( self:GetAngles() +Angle(0,180,0) )
	self.ActualLight1:SetParent( self )
	self.ActualLight1:SetKeyValue( "enableshadows", 1 )
	self.ActualLight1:SetKeyValue( "LightWorld", 1 )
	self.ActualLight1:SetKeyValue( "farz", 1000 )
	self.ActualLight1:SetKeyValue( "nearz", 1 )
	self.ActualLight1:SetKeyValue( "lightfov", 50 )
	self.ActualLight1:SetKeyValue( "lightcolor", "255 255 255" )
	self.ActualLight1:Spawn()
	self.ActualLight1:Input( "SpotlightTexture", NULL, NULL, "effects/flashlight001" )
	self:DeleteOnRemove(self.ActualLight1)*/
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTouch(entity)
	if GetConVarNumber("ai_disabled") == 1 then return end
	if self.Tank_Status == 0 then
		self:Tank_RunOver(entity)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Tank_RunOver(argent)
	if (!IsValid(argent)) or (GetConVarNumber("vj_npc_nomelee") == 1 /*or self.HasMeleeAttack == false*/) or (self.VJ_IsBeingControlled == true && self.VJ_TheControllerBullseye == argent) then return end
	if self:Disposition(argent) == 1 && argent:Health() > 0 then
		if (argent:IsNPC() && argent.VJ_IsHugeMonster != true && !self.TankTbl_DontRunOver[argent:GetClass()]) or (argent:IsPlayer() && self.PlayerFriendly == false && GetConVarNumber("ai_ignoreplayers") == 0 && argent:Alive() && self.Tank_IsMoving == true) then
			self:Tank_CustomOnRunOver(argent)
			argent:TakeDamage(self:VJ_GetDifficultyValue(8),self,self)
			VJ_DestroyCombineTurret(self,argent)
			argent:SetVelocity(argent:GetForward()*-200)
			self:Tank_Sound_RunOver()
		end
	end
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
		if GetConVarNumber("vj_npc_noidleparticle") == 1 then return end
		timer.Simple(0.1,function()
			if IsValid(self) && self.Dead == false then
				self:StartSpawnEffects()
			end
		end)

		if self:Health() < (self.StartHealth*0.30) && CurTime() > self.Tank_NextLowHealthSparkT then
			//ParticleEffectAttach("vj_rpg2_smoke2", PATTACH_ABSORIGIN_FOLLOW, self, 0)

			self.Spark1 = ents.Create("env_spark")
			self.Spark1:SetKeyValue("MaxDelay",0.01)
			self.Spark1:SetKeyValue("Magnitude","8")
			self.Spark1:SetKeyValue("Spark Trail Length","3")
			self:GetNearDeathSparkPositions()
			self.Spark1:SetAngles(self:GetAngles())
			//self.Spark1:Fire("LightColor", "255 255 255")
			self.Spark1:SetParent(self)
			self.Spark1:Spawn()
			self.Spark1:Activate()
			self.Spark1:Fire("StartSpark", "", 0)
			self.Spark1:Fire("kill", "", 0.1)
			self:DeleteOnRemove(self.Spark1)

			/*local effectdata = EffectData()
			effectdata:SetOrigin(self:GetPos() +self:GetUp()*60 +self:GetForward()*100)
			effectdata:SetNormal(Vector(0,0,0))
			effectdata:SetMagnitude(5)
			effectdata:SetScale(0.1)
			effectdata:SetRadius(10)
			util.Effect("Sparks",effectdata)*/
			self.Tank_NextLowHealthSparkT = CurTime() + math.random(4,6)
		end

		/*if self:Health() <= 150 then
		self.FireEffect = ents.Create("env_fire_trail")
		self.FireEffect:SetPos(self:GetPos()+self:GetUp()*100)
		self.FireEffect:Spawn()
		self.FireEffect:SetParent(self)
		end*/
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink_AIEnabled()
	if self.Dead == true then return end
	//timer.Simple(0.1, function() if self.Dead == false then ParticleEffect("smoke_exhaust_01",self:LocalToWorld(Vector(150,30,30)),Angle(0,0,0),self) end end)
	//timer.Simple(0.2, function() if self.Dead == false then self:StopParticles() end end)
	for k,v in pairs(ents.FindInSphere(self:GetPos(),100)) do
		self:Tank_RunOver(v)
	end

	local tr = util.TraceEntity({start = self:GetPos(), endpos = self:GetPos() + self:GetUp()*-5, filter = self}, self)
	if (tr.Hit) then // HitWorld
		local phys = self:GetPhysicsObject()
		if phys:IsValid() && phys:GetVelocity():Length() > 10 && self.Tank_Status == 0 then -- Moving
			self.Tank_IsMoving = true
			self:Tank_Sound_Moving()
			self:StartMoveEffects()
		else -- Not moving
			VJ_STOPSOUND(self.tank_movingsd)
			VJ_STOPSOUND(self.tank_tracksd)
			self.Tank_IsMoving = false
		end
	end
	if (!tr.Hit) then -- Not moving
		VJ_STOPSOUND(self.tank_movingsd)
		VJ_STOPSOUND(self.tank_tracksd)
		self.Tank_IsMoving = false
	end

	self:CustomOnSchedule()

	if self.Tank_Status == 0 && tr.Hit then
		if !IsValid(self:GetEnemy()) then
			self.Tank_Status = 1
		else
			//print((self:GetEnemy():GetPos() -self:GetPos() +Vector(0,0,80)):Angle())
			-- To make it go opposite:
				-- Change the +15 to -15 and -15 to 15
				-- Change the forwad spead(Tank_ForwardSpead) to their opposite quotation(+ to -)
				-- Change the turning speed(Tank_TurningSpeed) to their opposite quotation(+ to -)
			local phys = self:GetPhysicsObject()
			if phys:IsValid() then
				local Angle_Enemy = (self:GetEnemy():GetPos() - self:GetPos() +Vector(0,0,80)):Angle()
				local Angle_Current = self:GetAngles()
				local Angle_Diffuse = self:AngleDiffuse(Angle_Enemy.y,Angle_Current.y+self.Tank_AngleDiffuseNumber)
				local Heigh_Ratio = (self:GetEnemy():GetPos().z - self:GetPos().z ) / self:GetPos():Distance(Vector(self:GetEnemy():GetPos().x,self:GetEnemy():GetPos().y,self:GetPos().z))

				if Heigh_Ratio < 0.15 then -- If it is that high than move away from it
					-- To help the gunner shoot
					if self.Tank_UseGetRightForSpeed == true then
					phys:SetVelocity(self:GetRight():GetNormal()*self.Tank_MoveAwaySpeed) else
					phys:SetVelocity(self:GetForward():GetNormal()*self.Tank_MoveAwaySpeed) end
					if Angle_Diffuse > 15 then
						self:SetLocalAngles( self:GetLocalAngles() + Angle(0,self.Tank_TurningSpeed,0))
						phys:SetAngles(self:GetAngles())
					elseif Angle_Diffuse < -15 then
						self:SetLocalAngles( self:GetLocalAngles() + Angle(0,-self.Tank_TurningSpeed,0))
						phys:SetAngles(self:GetAngles())
					end
				//if self:GetEnemy().VJ_IsHugeMonster == false then
				elseif math.abs(Heigh_Ratio) > 1 && math.abs(Heigh_Ratio) < 0.6 then -- If it is that high than move toward it
					-- Run over
					if self.Tank_UseGetRightForSpeed == true then
					phys:SetVelocity(self:GetRight():GetNormal()*self.Tank_MoveAwaySpeed) else
					phys:SetVelocity(self:GetForward():GetNormal()*self.Tank_MoveAwaySpeed) end
					if Angle_Diffuse > 15 then
						self:SetLocalAngles( self:GetLocalAngles() + Angle(0,self.Tank_TurningSpeed,0))
						phys:SetAngles(self:GetAngles())
					elseif Angle_Diffuse < -15 then
						self:SetLocalAngles( self:GetLocalAngles() + Angle(0,-self.Tank_TurningSpeed,0))
						phys:SetAngles(self:GetAngles())
					end
				end
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnSchedule()
	if self:Health() <= 0 or self.Dead == true then return end

	self:IdleSoundCode()
	self:DoIdleAnimation()
	
	if !IsValid(self:GetEnemy()) then
		if self.Tank_ResetedEnemy == false then
			self.Tank_ResetedEnemy = true
			self:ResetEnemy()
		end
	else
		local EnemyPos = self:GetEnemy():GetPos()
		local EnemyPosToSelf = self:GetPos():Distance(EnemyPos)
		if self.VJ_IsBeingControlled == true then
			if self.VJ_TheController:KeyDown(IN_FORWARD) then
				self.Tank_Status = 0
			else
				self.Tank_Status = 1
			end
		elseif self.VJ_IsBeingControlled == false then
			if EnemyPosToSelf > self.Tank_SeeLimit then -- If larger than this number than, move
				self.Tank_Status = 0
			elseif EnemyPosToSelf < self.Tank_SeeFar && EnemyPosToSelf > self.Tank_SeeClose then -- If between this two numbers, stay still
				self.Tank_Status = 1
			else
				self.Tank_Status = 0
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_BeforeDamage(dmginfo,hitgroup)
	local dmgtype = dmginfo:GetDamageType()
	if (dmgtype == DMG_SLASH or dmgtype == DMG_GENERIC or dmgtype == DMG_CLUB) then
		if dmginfo:GetDamage() >= 30 && dmginfo:GetAttacker().VJ_IsHugeMonster != true then
			dmginfo:SetDamage(dmginfo:GetDamage()/2)
		else
			dmginfo:SetDamage(0)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnPriorToKilled(dmginfo,hitgroup)
	if IsValid(self.Gunner) then
		self.Gunner.Dead = true
		if self:IsOnFire() then self.Gunner:Ignite(math.Rand(8,10),0) end
	end
	
	if self:Tank_CustomOnPriorToKilled(dmginfo,hitgroup) == true then
		for i=0,1,0.5 do
			timer.Simple(i,function()
				if IsValid(self) then
					VJ_EmitSound(self,"vj_mili_tank/tank_death2.wav",100,100)
					util.BlastDamage(self,self,self:GetPos(),200,40)
					util.ScreenShake(self:GetPos(), 100, 200, 1, 2500)
					if self.HasGibDeathParticles == true then ParticleEffect("vj_explosion2",self:GetPos(),Angle(0,0,0),nil) end
				end
			end)
		end
		
		timer.Simple(1.5,function()
			if IsValid(self) then
				VJ_EmitSound(self,"vj_mili_tank/tank_death2.wav",100,100)
				VJ_EmitSound(self,"vj_mili_tank/tank_death3.wav",100,100)
				util.BlastDamage(self,self,self:GetPos(),200,40)
				util.ScreenShake(self:GetPos(), 100, 200, 1, 2500)
				if self.HasGibDeathParticles == true then ParticleEffect("vj_explosion2",self:GetPos(),Angle(0,0,0),nil) end
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDeath_AfterCorpseSpawned(dmginfo,hitgroup,GetCorpse)
	if IsValid(self.Gunner) then -- Spawn the gunner
		local gunnercorpse = self.Gunner:CreateDeathCorpse(dmginfo,hitgroup)
		if IsValid(gunnercorpse) then GetCorpse.ExtraCorpsesToRemove[#GetCorpse.ExtraCorpsesToRemove+1] = gunnercorpse end
	end
	
	if self:Tank_CustomOnDeath_AfterCorpseSpawned(dmginfo,hitgroup,GetCorpse) == true then
		util.BlastDamage(self, self, self:GetPos(), 400, 40)
		util.ScreenShake(self:GetPos(), 100, 200, 1, 2500)
	
		-- Spawn the death soldier
		local smdl = VJ_PICK(self.Tank_DeathSoldierModels)
		if smdl != false && math.random(1,self.Tank_DeathSoldierChance) == 1 then
			self:CreateExtraDeathCorpse("prop_ragdoll",smdl,{Pos=self:GetPos()+self:GetUp()*90+self:GetRight()*-30,Vel=Vector(math.Rand(-600,600), math.Rand(-600,600),500)},function(extraent) extraent:Ignite(math.Rand(8,10),0); extraent:SetColor(Color(90,90,90)); self:Tank_CustomOnDeath_AfterDeathSoldierSpawned(dmginfo,hitgroup,extraent) end)
		end

		self:SetPos(Vector(self:GetPos().x,self:GetPos().y,self:GetPos().z +4)) -- Because the NPC is too close to the ground
		local tr = util.TraceLine({
			start = self:GetPos(),
			endpos = self:GetPos() - Vector(0, 0, 500),
			filter = self
		})
		util.Decal(VJ_PICK(self.Tank_DeathDecal), tr.HitPos+tr.HitNormal, tr.HitPos-tr.HitNormal)

		if self.HasGibDeathParticles == true then
			if self:Tank_CustomOnDeath_AfterCorpseSpawned_Effects(dmginfo,hitgroup,GetCorpse) == true then
				//self.FireEffect = ents.Create( "env_fire_trail" )
				//self.FireEffect:SetPos(self:GetPos()+self:GetUp()*70)
				//self.FireEffect:Spawn()
				//self.FireEffect:SetParent(GetCorpse)
				//ParticleEffectAttach("smoke_large_01b",PATTACH_ABSORIGIN_FOLLOW,GetCorpse,0)
				ParticleEffect("vj_explosion3",self:GetPos(),Angle(0,0,0),nil)
				ParticleEffect("vj_explosion2",self:GetPos() +self:GetForward()*-130,Angle(0,0,0),nil)
				ParticleEffect("vj_explosion2",self:GetPos() +self:GetForward()*130,Angle(0,0,0),nil)
				ParticleEffectAttach("smoke_burning_engine_01",PATTACH_ABSORIGIN_FOLLOW,GetCorpse,0)
				
				local explosioneffect = EffectData()
				explosioneffect:SetOrigin(self:GetPos())
				util.Effect("VJ_Medium_Explosion1",explosioneffect)
				util.Effect("Explosion", explosioneffect)
				
				local dusteffect = EffectData()
				dusteffect:SetOrigin(self:GetPos())
				dusteffect:SetScale(800)
				util.Effect("ThumperDust",dusteffect)
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRemove()
	VJ_STOPSOUND(self.tank_movingsd)
	VJ_STOPSOUND(self.tank_tracksd)
	if IsValid(self.Gunner) then
		self.Gunner:Remove()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Tank_Sound_Moving()
	if self.HasSounds == false or self.HasFootStepSound == false then return end
	
	local sdtbl1 = VJ_PICK(self.Tank_SoundTbl_DrivingEngine)
	if sdtbl1 == false then sdtbl1 = VJ_PICK(self.Tank_DefaultSoundTbl_DrivingEngine) end -- Default table
	self.tank_movingsd = VJ_CreateSound(self,sdtbl1,80,100)
	self.Tank_NextRunOverSoundT = CurTime() + 0.2
	
	local sdtbl2 = VJ_PICK(self.Tank_SoundTbl_Track)
	if sdtbl2 == false then sdtbl2 = VJ_PICK(self.Tank_DefaultSoundTbl_Track) end -- Default table
	self.tank_tracksd = VJ_CreateSound(self,sdtbl2,70,100)
	self.Tank_NextRunOverSoundT = CurTime() + 0.2
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Tank_Sound_RunOver()
	if self.HasSounds == false or CurTime() < self.Tank_NextRunOverSoundT then return end
	
	local sdtbl = VJ_PICK(self.Tank_SoundTbl_RunOver)
	if sdtbl == false then sdtbl = VJ_PICK(self.Tank_DefaultSoundTbl_RunOver) end -- Default table
	self:EmitSound(sdtbl,80,math.random(80,100))
	self.Tank_NextRunOverSoundT = CurTime() + 0.2
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/