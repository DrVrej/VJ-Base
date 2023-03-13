if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2023 by DrVrej, All rights reserved. ***
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
ENT.ImmuneDamagesTable = {DMG_PHYSGUN} -- You can set Specific types of damages for the SNPC to be immune to
ENT.FindEnemy_UseSphere = true -- Should the SNPC be able to see all around him? (360) | Objects and walls can still block its sight!
ENT.GetDamageFromIsHugeMonster = true -- Should it get damaged no matter what by SNPCs that are tagged as VJ_IsHugeMonster?
ENT.DeathCorpseCollisionType = COLLISION_GROUP_NONE -- Collision type for the corpse | SNPC Options Menu can only override this value if it's set to COLLISION_GROUP_DEBRIS!
ENT.WaitBeforeDeathTime = 2 -- Time until the SNPC spawns its corpse and gets removed
ENT.HasMeleeAttack = false -- Should the SNPC have a melee attack?
ENT.DisableInitializeCapabilities = true -- If true, it will disable the initialize capabilities, this will allow you to add your own
ENT.DisableSelectSchedule = true -- Disables Schedule code, Custom Schedule can still work
ENT.DisableWandering = true -- Disables wandering when the SNPC is idle
ENT.BringFriendsOnDeath = false -- Should the SNPC's friends come to its position before it dies?
ENT.CallForBackUpOnDamage = false -- Should the SNPC call for help when damaged? (Only happens if the SNPC hasn't seen a enemy)
ENT.MoveOrHideOnDamageByEnemy = false -- Should the SNPC move or hide when being damaged by an enemy?
ENT.MoveOutOfFriendlyPlayersWay = false -- Should the SNPC move out of the way when a friendly player comes close to it?
ENT.CallForHelp = false -- Does the SNPC call for help?
ENT.HasPainSounds = false -- If set to false, it won't play the pain sounds
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_Breath = {"vj_vehicles/armored/engine_idle1.wav"}
ENT.SoundTbl_Death = {"vj_fire/explosion1.wav"}

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
ENT.Tank_GunnerENT = "" -- The SNPC that will be the gunner (The head of the tank)
ENT.Tank_AngleDiffuseNumber = 180 -- Used if the forward direction of the y-axis isn't correct on the model
	-- ====== Sight Variables ====== --
ENT.Tank_SeeClose = 1000 -- If the enemy is closer than this number, than move by either running over them or moving away for the gunner to fire
ENT.Tank_SeeFar = 6000 -- If the enemy is higher than this number, than move towards the enemy
ENT.Tank_DistRanOver = 500 -- If the enemy is within self.Tank_SeeClose & this number & not high up, then run over them!
	-- ====== Movement Variables ====== --
ENT.Tank_TurningSpeed = 1.5 -- How fast the chassis moves as it's driving
ENT.Tank_DrivingSpeed = 100 -- How fast the tank drives
	-- ====== Collision Variables ====== --
	-- Used when the NPC is spawned
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

ENT.Tank_DefaultSoundTbl_DrivingEngine = {"vj_vehicles/armored/engine_drive1.wav"}
ENT.Tank_DefaultSoundTbl_Track = {"vj_vehicles/armored/tracks1.wav"}
ENT.Tank_DefaultSoundTbl_RunOver = {"vj_gib/bones_snapping1.wav","vj_gib/bones_snapping2.wav","vj_gib/bones_snapping3.wav"}

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
function ENT:Tank_CustomOnRunOver(ent) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetNearDeathSparkPositions()
	local randPos = math.random(1, 2)
	if randPos == 1 then
		self.Spark1:SetLocalPos(self:GetPos() + self:GetForward()*100 + self:GetUp()*60)
	elseif randPos == 2 then
		self.Spark1:SetLocalPos(self:GetPos() + self:GetForward()*-100 + self:GetUp()*60)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Tank_CustomOnPriorToKilled(dmginfo, hitgroup) return true end -- Return false to disable the default base code
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Tank_CustomOnDeath_AfterCorpseSpawned(dmginfo, hitgroup, corpseEnt) return true end -- Return false to disable the default base code
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Tank_CustomOnDeath_AfterDeathSoldierSpawned(dmginfo, hitgroup, soldierCorpse) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Tank_CustomOnDeath_AfterCorpseSpawned_Effects(dmginfo, hitgroup, corpseEnt) return true end -- Return false to disable the default base code
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
ENT.Tank_IsMoving = false
ENT.Tank_Status = 1
ENT.Tank_NextLowHealthSparkT = 0
ENT.Tank_NextRunOverSoundT = 0
local runoverException = {npc_antlionguard=true,npc_turret_ceiling=true,monster_gargantua=true,monster_bigmomma=true,monster_nihilanth=true,npc_strider=true,npc_combine_camera=true,npc_helicopter=true,npc_combinegunship=true,npc_combinedropship=true,npc_rollermine=true}
local defAng = Angle(0, 0, 0)
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetImpactEnergyScale(0) -- Take no physics damage
	self.DeathAnimationCodeRan = true -- So corpse doesn't fly away on death (Take this out if not using death explosion sequence)
	self:VJTags_Add(VJ_TAG_VEHICLE)
	self:CustomInitialize_CustomTank()
	self:PhysicsInit(SOLID_BBOX) // SOLID_VPHYSICS
	self:SetSolid(SOLID_VPHYSICS)
	self:SetAngles(self:GetAngles() + Angle(0, -self.Tank_AngleDiffuseNumber, 0))
	//self:SetPos(self:GetPos()+Vector(0,0,90))
	self:SetCollisionBounds(Vector(self.Tank_CollisionBoundSize, self.Tank_CollisionBoundSize, self.Tank_CollisionBoundUp), Vector(-self.Tank_CollisionBoundSize, -self.Tank_CollisionBoundSize, self.Tank_CollisionBoundDown))

	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:Wake()
		phys:SetMass(30000)
	end
	
	-- Create the gunner NPC
	self.Gunner = ents.Create(self.Tank_GunnerENT)
	if IsValid(self.Gunner) then
		self.Gunner:SetPos(self:Tank_GunnerSpawnPosition())
		self.Gunner:SetAngles(self:GetAngles())
		self.Gunner:Spawn()
		self.Gunner:SetParent(self)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTouch(ent)
	if GetConVar("ai_disabled"):GetInt() == 1 then return end
	if self.Tank_Status == 0 then
		self:Tank_RunOver(ent)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Tank_RunOver(ent)
	if (!IsValid(ent)) or (GetConVar("vj_npc_nomelee"):GetInt() == 1 /*or self.HasMeleeAttack == false*/) or (self.VJ_IsBeingControlled && self.VJ_TheControllerBullseye == ent) then return end
	if self:Disposition(ent) == 1 && ent:Health() > 0 && self.Tank_IsMoving == true && (ent:IsNPC() && ent.VJ_IsHugeMonster != true && !runoverException[ent:GetClass()]) or (ent:IsPlayer() && self.PlayerFriendly == false && !VJ_CVAR_IGNOREPLAYERS) then
		self:Tank_CustomOnRunOver(ent)
		self:Tank_Sound_RunOver()
		ent:TakeDamage(self:VJ_GetDifficultyValue(8), self, self)
		VJ_DestroyCombineTurret(self,ent)
		ent:SetVelocity(ent:GetForward()*-200)
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
		if GetConVar("vj_npc_noidleparticle"):GetInt() == 1 then return end
		timer.Simple(0.1, function()
			if IsValid(self) && !self.Dead then
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

			/*local effectData = EffectData()
			effectData:SetOrigin(self:GetPos() +self:GetUp()*60 +self:GetForward()*100)
			effectData:SetNormal(Vector(0, 0, 0))
			effectData:SetMagnitude(5)
			effectData:SetScale(0.1)
			effectData:SetRadius(10)
			util.Effect("Sparks",effectData)*/
			self.Tank_NextLowHealthSparkT = CurTime() + math.random(4, 6)
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
local vec80z = Vector(0, 0, 80)
--
function ENT:CustomOnThink_AIEnabled()
	if self.Dead then return end
	//timer.Simple(0.1, function() if !self.Dead then ParticleEffect("smoke_exhaust_01",self:LocalToWorld(Vector(150,30,30)),defAng,self) end end)
	//timer.Simple(0.2, function() if !self.Dead then self:StopParticles() end end)
	for _, v in ipairs(ents.FindInSphere(self:GetPos(), 100)) do
		self:Tank_RunOver(v)
	end

	local tr = util.TraceEntity({start = self:GetPos(), endpos = self:GetPos() + self:GetUp()*-5, filter = self}, self)
	if (tr.Hit) then // HitWorld
		local phys = self:GetPhysicsObject()
		if IsValid(phys) && phys:GetVelocity():Length() > 10 && self.Tank_Status == 0 then -- Moving
			self.Tank_IsMoving = true
			self:Tank_Sound_Moving()
			self:StartMoveEffects()
		else -- Not moving
			VJ_STOPSOUND(self.CurrentTankMovingSound)
			VJ_STOPSOUND(self.CurrentTankTrackSound)
			self.Tank_IsMoving = false
		end
	end
	if (!tr.Hit) then -- Not moving
		VJ_STOPSOUND(self.CurrentTankMovingSound)
		VJ_STOPSOUND(self.CurrentTankTrackSound)
		self.Tank_IsMoving = false
	end

	self:CustomOnSchedule()
	
	if self.Tank_Status == 0 && tr.Hit then
		local ene = self:GetEnemy()
		if IsValid(ene) then
			local phys = self:GetPhysicsObject()
			if IsValid(phys) then
				local angEne = (ene:GetPos() - self:GetPos() + vec80z):Angle()
				local angDiffuse = self:AngleDiffuse(angEne.y, self:GetAngles().y + self.Tank_AngleDiffuseNumber)
				local heightRatio = (ene:GetPos().z - self:GetPos().z) / self:GetPos():Distance(Vector(ene:GetPos().x, ene:GetPos().y, self:GetPos().z))
				-- If the enemy's height isn't very high AND the enemy is ( within run over distance OR far away), then move towards the enemy!
				-- OR
				-- If the enemy is very high up, then move away from it to help the gunner fire!
				if (heightRatio < 0.15 && ((self.LatestEnemyDistance < self.Tank_DistRanOver) or (self.LatestEnemyDistance > self.Tank_SeeFar))) or (heightRatio > 0.15) then
					if angDiffuse > 15 then
						self:SetLocalAngles(self:GetLocalAngles() + Angle(0, self.Tank_TurningSpeed, 0))
						phys:SetAngles(self:GetAngles())
					elseif angDiffuse < -15 then
						self:SetLocalAngles(self:GetLocalAngles() + Angle(0, -self.Tank_TurningSpeed, 0))
						phys:SetAngles(self:GetAngles())
					end
					local moveVel = self:GetForward()
					moveVel:Rotate(Angle(0, self.Tank_AngleDiffuseNumber, 0))
					if heightRatio > 0.15 then -- Move away!
						phys:SetVelocity(moveVel:GetNormal()*-self.Tank_DrivingSpeed)
					else -- Move towards!
						phys:SetVelocity(moveVel:GetNormal()*self.Tank_DrivingSpeed)
					end
				end
			end
		else
			self.Tank_Status = 1
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnSchedule()
	if self:Health() <= 0 or self.Dead then return end

	self:IdleSoundCode()
	self:DoIdleAnimation()
	
	if IsValid(self:GetEnemy()) then
		if self.VJ_IsBeingControlled then
			if self.VJ_TheController:KeyDown(IN_FORWARD) then
				self.Tank_Status = 0
			else
				self.Tank_Status = 1
			end
		else
			if self.LatestEnemyDistance < self.Tank_SeeFar && self.LatestEnemyDistance > self.Tank_SeeClose then -- If between this two numbers, stay still
				self.Tank_Status = 1
			else
				self.Tank_Status = 0
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_BeforeDamage(dmginfo, hitgroup)
	if dmginfo:IsDamageType(DMG_SLASH) or dmginfo:IsDamageType(DMG_GENERIC) or dmginfo:IsDamageType(DMG_CLUB) then
		if dmginfo:GetDamage() >= 30 && !dmginfo:GetAttacker().VJ_IsHugeMonster then
			dmginfo:SetDamage(dmginfo:GetDamage() / 2)
		else
			dmginfo:SetDamage(0)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnPriorToKilled(dmginfo, hitgroup)
	if IsValid(self.Gunner) then
		self.Gunner.Dead = true
		if self:IsOnFire() then self.Gunner:Ignite(math.Rand(8, 10), 0) end
	end
	
	if self:Tank_CustomOnPriorToKilled(dmginfo, hitgroup) == true then
		for i=0, 1, 0.5 do
			timer.Simple(i, function()
				if IsValid(self) then
					local myPos = self:GetPos()
					VJ_EmitSound(self, "vj_fire/explosion2.wav", 100, 100)
					util.BlastDamage(self, self, myPos, 200, 40)
					util.ScreenShake(myPos, 100, 200, 1, 2500)
					if self.HasGibDeathParticles == true then ParticleEffect("vj_explosion2", myPos, defAng) end
				end
			end)
		end
		
		timer.Simple(1.5, function()
			if IsValid(self) then
				local myPos = self:GetPos()
				VJ_EmitSound(self,"vj_fire/explosion2.wav", 100, 100)
				VJ_EmitSound(self,"vj_fire/explosion3.wav", 100, 100)
				util.BlastDamage(self, self, myPos, 200, 40)
				util.ScreenShake(myPos, 100, 200, 1, 2500)
				if self.HasGibDeathParticles == true then ParticleEffect("vj_explosion2", myPos, defAng) end
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local vec500z = Vector(0, 0, 500)
local colorGray = Color(90, 90, 90)
--
function ENT:CustomOnDeath_AfterCorpseSpawned(dmginfo, hitgroup, corpseEnt)
	-- Spawn the gunner corpse
	if IsValid(self.Gunner) then
		self.Gunner.SavedDmgInfo = self.SavedDmgInfo
		local gunCorpse = self.Gunner:CreateDeathCorpse(dmginfo, hitgroup)
		if IsValid(gunCorpse) then corpseEnt.ExtraCorpsesToRemove[#corpseEnt.ExtraCorpsesToRemove+1] = gunCorpse end
	end
	
	if self:Tank_CustomOnDeath_AfterCorpseSpawned(dmginfo, hitgroup, corpseEnt) == true then
		local myPos = self:GetPos()
		
		util.BlastDamage(self, self, myPos, 400, 40)
		util.ScreenShake(myPos, 100, 200, 1, 2500)
	
		-- Spawn the death soldier corpse
		if math.random(1, self.Tank_DeathSoldierChance) == 1 then
			local soldierMDL = VJ_PICK(self.Tank_DeathSoldierModels)
			if soldierMDL != false then
				self:CreateExtraDeathCorpse("prop_ragdoll", soldierMDL, {Pos=myPos + self:GetUp()*90 + self:GetRight()*-30, Vel=Vector(math.Rand(-600, 600), math.Rand(-600, 600), 500)}, function(extraent)
					extraent:Ignite(math.Rand(8, 10), 0)
					extraent:SetColor(colorGray)
					self:Tank_CustomOnDeath_AfterDeathSoldierSpawned(dmginfo, hitgroup, extraent)
				end)
			end
		end

		self:SetPos(Vector(myPos.x, myPos.y, myPos.z + 4)) -- Because the NPC is too close to the ground
		myPos = self:GetPos()
		local tr = util.TraceLine({
			start = myPos,
			endpos = myPos - vec500z,
			filter = self
		})
		util.Decal(VJ_PICK(self.Tank_DeathDecal), tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal)

		if self.HasGibDeathParticles == true && self:Tank_CustomOnDeath_AfterCorpseSpawned_Effects(dmginfo, hitgroup, corpseEnt) == true then
			//self.FireEffect = ents.Create( "env_fire_trail" )
			//self.FireEffect:SetPos(myPos+self:GetUp()*70)
			//self.FireEffect:Spawn()
			//self.FireEffect:SetParent(corpseEnt)
			//ParticleEffectAttach("smoke_large_01b",PATTACH_ABSORIGIN_FOLLOW,corpseEnt,0)
			ParticleEffect("vj_explosion3", myPos, defAng)
			ParticleEffect("vj_explosion2", myPos + self:GetForward()*-130, defAng)
			ParticleEffect("vj_explosion2", myPos + self:GetForward()*130, defAng)
			ParticleEffectAttach("smoke_burning_engine_01", PATTACH_ABSORIGIN_FOLLOW, corpseEnt, 0)
			
			local effectExp = EffectData()
			effectExp:SetOrigin(myPos)
			util.Effect("VJ_Medium_Explosion1", effectExp)
			util.Effect("Explosion", effectExp)
			
			local effectDust = EffectData()
			effectDust:SetOrigin(myPos)
			effectDust:SetScale(800)
			util.Effect("ThumperDust", effectDust)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRemove()
	VJ_STOPSOUND(self.CurrentTankMovingSound)
	VJ_STOPSOUND(self.CurrentTankTrackSound)
	if IsValid(self.Gunner) then
		self.Gunner:Remove()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Tank_Sound_Moving()
	if self.HasSounds == false or self.HasFootStepSound == false then return end
	
	local sdtbl1 = VJ_PICK(self.Tank_SoundTbl_DrivingEngine)
	if sdtbl1 == false then sdtbl1 = VJ_PICK(self.Tank_DefaultSoundTbl_DrivingEngine) end -- Default table
	self.CurrentTankMovingSound = VJ_CreateSound(self, sdtbl1, 80, 100)
	//self.Tank_NextRunOverSoundT = CurTime() + 0.2
	
	local sdtbl2 = VJ_PICK(self.Tank_SoundTbl_Track)
	if sdtbl2 == false then sdtbl2 = VJ_PICK(self.Tank_DefaultSoundTbl_Track) end -- Default table
	self.CurrentTankTrackSound = VJ_CreateSound(self, sdtbl2, 70, 100)
	//self.Tank_NextRunOverSoundT = CurTime() + 0.2
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Tank_Sound_RunOver()
	if self.HasSounds == false or CurTime() < self.Tank_NextRunOverSoundT then return end
	
	local sdtbl = VJ_PICK(self.Tank_SoundTbl_RunOver)
	if sdtbl == false then sdtbl = VJ_PICK(self.Tank_DefaultSoundTbl_RunOver) end -- Default table
	self:EmitSound(sdtbl, 80, math.random(80, 100))
	self.Tank_NextRunOverSoundT = CurTime() + 0.2
end