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
ENT.StartHealth = 200
ENT.SightDistance = 10000
ENT.MovementType = VJ_MOVETYPE_PHYSICS -- How the NPC moves around
ENT.ForceDamageFromBosses = true -- Should the NPC get damaged by bosses regardless if it's not supposed to by skipping immunity checks, etc. | Bosses are attackers tagged with "VJ_ID_Boss"
ENT.DeathDelayTime = 2 -- Time until the NPC spawns the corpse, removes itself, etc.
ENT.AlertFriendsOnDeath = true -- Should the NPC's allies get alerted while it's dying? | Its allies will also need to have this variable set to true!
	-- ====== Sound Paths ====== --
ENT.SoundTbl_Breath = "vj_base/vehicles/armored/engine_idle.wav"
ENT.SoundTbl_Death = "VJ.Explosion"

ENT.BreathSoundLevel = 80
ENT.IdleSoundLevel = 70
ENT.CombatIdleSoundLevel = 70
ENT.AlertSoundLevel = 70
ENT.DeathSoundLevel = 100
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Tank Base ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ENT.Tank_GunnerENT = false -- Gunner entity of the tank | false = No gunner | string = class name of the gunner
ENT.Tank_AngleOffset = 0 -- Use to offset the forward angle if the model's y-axis isn't facing the correct direction
	-- ====== Sight ====== --
ENT.Tank_DriveAwayDistance = 1000 -- If the enemy is closer than this number, than move by either running over them or moving away for the gunner to fire
ENT.Tank_DriveTowardsDistance = 2000 -- If the enemy is higher than this number, than move towards the enemy
ENT.Tank_RanOverDistance = 500 -- If the enemy is within self.Tank_DriveAwayDistance & this number & not high up, then run over them!
	-- ====== Movement ====== --
ENT.Tank_TurningSpeed = 1.5 -- How fast the chassis moves as it's driving
ENT.Tank_DrivingSpeed = 100 -- How fast the tank drives
	-- ====== Collision ====== --
	-- Used when the NPC is spawned
ENT.Tank_CollisionBoundSize = 90
ENT.Tank_CollisionBoundUp = 100
ENT.Tank_CollisionBoundDown = -10
	-- ====== Death ====== --
ENT.Tank_DeathDriverCorpse = false -- Driver corpse to spawn on death | false = Don't spawn anything
ENT.Tank_DeathDriverCorpseChance = 3 -- Chance that the driver corpse spawns | 1 = always
ENT.Tank_DeathDecal = "Scorch" -- Decal to spawn under the tank's location on death
	-- ====== Sound ====== --
-- driving movement sounds
ENT.HasMoveSound = true
ENT.Tank_SoundTbl_DrivingEngine = false
ENT.Tank_SoundTbl_Track = false
-- Run over sound
ENT.HasRunOverSound = true
ENT.Tank_SoundTbl_RunOver = false

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Customization Functions ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- Use the functions below to customize certain parts of the base or to add new custom systems
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Tank_Init() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Tank_GunnerSpawnPosition()
	return self:GetPos()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Tank_OnThink() end -- Return true to disable the default base code
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Tank_OnThinkActive() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Tank_OnRunOver(ent) end
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
function ENT:Tank_OnInitialDeath(dmginfo, hitgroup) end -- Return true to disable the default base code
---------------------------------------------------------------------------------------------------------------------------------------------
--[[
Called when the tank is about to spawn death soldier model, death effects, and death sounds

=-=-=| PARAMETERS |=-=-=
	1. dmginfo [object] = CTakeDamageInfo object
	2. hitgroup [number] = The hitgroup that it hit
	3. corpseEnt [entity] = The corpse entity of the tank
	4. status [string] : Type of update that is occurring, holds one of the following states:
		-> "Override" : Right before anything is create, can be used to override the entire function
				USAGE EXAMPLES -> Add extra gib pieces | Add extra blast
				PARAMETERS
					5. statusData [nil]
				RETURNS
					-> [nil | bool] : Returning true will NOT let the base code execute, effectively overriding it entirely
		-> "Soldier" : The soldier corpse that it created
				USAGE EXAMPLES -> Set a skin or bodygroup
				PARAMETERS
					5. statusData [entity] : Soldier corpse entity
				RETURNS
					-> [nil]
		-> "Effects" : Right before it's about to spawn the death effects
				USAGE EXAMPLES -> Add extra effects | Override the base effects entirely
				PARAMETERS
					5. statusData [nil]
				RETURNS
					-> [nil | bool] : Returning true will NOT let the base effects be created
	5. statusData [nil | entity] : Depends on `status` value, refer to it for more details

=-=-=| RETURNS |=-=-=
	-> [nil | bool] : Depends on `status` value, refer to it for more details
--]]
function ENT:Tank_OnDeathCorpse(dmginfo, hitgroup, corpseEnt, status, statusData) end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:UpdateIdleParticles()
	-- Example:
	//local effectData = EffectData()
	//effectData:SetScale(1)
	//effectData:SetEntity(self)
	//effectData:SetOrigin(self:GetPos() + self:GetForward() * -130 + self:GetRight() * 25  + self:GetUp() * 45)
	//util.Effect("VJ_VehicleExhaust", effectData, true, true)
	//effectData:SetOrigin(self:GetPos() + self:GetForward() * -130 + self:GetRight() * -28 + self:GetUp() * 45)
	//util.Effect("VJ_VehicleExhaust", effectData, true, true)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:UpdateMoveParticles()
	-- Example:
	//local effectData = EffectData()
	//effectData:SetScale(1)
	//effectData:SetEntity(self)
	//effectData:SetOrigin(self:GetPos() + self:GetForward() * -115 + self:GetRight() * 58)
	//util.Effect("VJ_VehicleMove", effectData, true, true)
	//effectData:SetOrigin(self:GetPos() + self:GetForward() * -115 + self:GetRight() * -58)
	//util.Effect("VJ_VehicleMove", effectData, true, true)
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
ENT.Tank_NextIdleParticles = 0
local runoverException = {npc_antlionguard=true,npc_turret_ceiling=true,monster_gargantua=true,monster_bigmomma=true,monster_nihilanth=true,npc_strider=true,npc_combine_camera=true,npc_helicopter=true,npc_combinegunship=true,npc_combinedropship=true,npc_rollermine=true}
local defAng = Angle(0, 0, 0)

local cv_nomelee = GetConVar("vj_npc_melee")
local cv_noidleparticle = GetConVar("vj_npc_reduce_vfx")
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetPhysicsDamageScale(0) -- Take no physics damage
	self.Tank_NextIdleParticles = CurTime() + 1
	self.DeathAnimationCodeRan = true -- So corpse doesn't fly away on death (Take this out if not using death explosion sequence)
	self:Tank_Init()
	-- !!!!!!!!!!!!!! DO NOT USE THESE !!!!!!!!!!!!!! [Backwards Compatibility!]
	if self.CustomInitialize_CustomTank then self:CustomInitialize_CustomTank() end
	if self.Tank_DeathSoldierModels then self.Tank_DeathDriverCorpse = self.Tank_DeathSoldierModels end
	--
	self:PhysicsInit(SOLID_VPHYSICS) // SOLID_BBOX
	//self:SetSolid(SOLID_VPHYSICS)
	self:SetAngles(self:GetAngles() + Angle(0, -self.Tank_AngleOffset, 0))
	//self:SetPos(self:GetPos()+Vector(0,0,90))
	self:SetCollisionBounds(Vector(self.Tank_CollisionBoundSize, self.Tank_CollisionBoundSize, self.Tank_CollisionBoundUp), Vector(-self.Tank_CollisionBoundSize, -self.Tank_CollisionBoundSize, self.Tank_CollisionBoundDown))

	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:Wake()
		phys:SetMass(30000)
	end
	
	-- Create the gunner NPC
	if self.Tank_GunnerENT then
		local gunner = ents.Create(self.Tank_GunnerENT)
		if IsValid(gunner) then
			gunner:SetPos(self:Tank_GunnerSpawnPosition())
			gunner:SetAngles(self:GetAngles())
			gunner:SetOwner(self)
			gunner:SetParent(self)
			gunner.VJ_NPC_Class = self.VJ_NPC_Class
			gunner:Spawn()
			gunner:Activate()
			self.Gunner = gunner
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnTouch(ent)
	if !VJ_CVAR_AI_ENABLED then return end
	if self.Tank_Status == 0 then
		self:Tank_RunOver(ent)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Tank_RunOver(ent)
	if !self.Tank_IsMoving or !IsValid(ent) or (cv_nomelee:GetInt() == 0 /*or self.HasMeleeAttack == false*/) or (ent.IsVJBaseBullseye && ent.VJ_IsBeingControlled) then return end
	if self:Disposition(ent) == D_HT && ent:Health() > 0 && ((ent:IsNPC() && !runoverException[ent:GetClass()]) or (ent:IsPlayer() && !VJ_CVAR_IGNOREPLAYERS) or ent:IsNextBot()) && !ent.VJ_ID_Boss && !ent.VJ_ID_Vehicle && !ent.VJ_ID_Aircraft then
		self:Tank_OnRunOver(ent)
		self:Tank_PlaySoundSystem("RunOver")
		ent:TakeDamage(self:ScaleByDifficulty(8), self, self)
		VJ.DamageSpecialEnts(self, ent, nil)
		ent:SetVelocity(ent:GetForward()*-200)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThink()
	if self:Tank_OnThink() != true && cv_noidleparticle:GetInt() == 0 then
		if self.Tank_NextIdleParticles < CurTime() then
			self:UpdateIdleParticles()
			self.Tank_NextIdleParticles = CurTime() + 0.1
		end
	
		if self:Health() < (self.StartHealth*0.30) && CurTime() > self.Tank_NextLowHealthSparkT then
			//ParticleEffectAttach("vj_rocket_idle2_smoke2", PATTACH_ABSORIGIN_FOLLOW, self, 0)

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
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local vec80z = Vector(0, 0, 80)
local NPC_FACE_NONE = VJ.NPC_FACE_NONE
--
function ENT:OnThinkActive()
	if self.Dead then return end
	self.TurnData.Type = NPC_FACE_NONE -- This effectively makes it never face anything through Lua
	self:Tank_OnThinkActive()
	self:SelectSchedule()

	local hasMoved = false
	local myPos = self:GetPos()
	local tr = util.TraceLine({start = myPos + self:GetUp() * 20, endpos = myPos + self:GetUp() * -50, filter = self})
	if self.VJ_DEBUG then
		debugoverlay.Cross(tr.StartPos, 4, 2, VJ.COLOR_GREEN, true)
		debugoverlay.Cross(myPos + self:GetUp() * -50, 4, 2, VJ.COLOR_YELLOW, true)
		debugoverlay.Cross(tr.HitPos, 4, 2, VJ.COLOR_RED, true)
		debugoverlay.Line(tr.StartPos, tr.HitPos, 2, nil, true)
		VJ.DEBUG_Print(self, false, "Tank Status = ", self.Tank_Status, " | Trace HitNormal = ", tr.HitNormal)
	end
	if tr.Hit && self.Tank_Status == 0 then
		local phys = self:GetPhysicsObject()
		if IsValid(phys) && #phys:GetFrictionSnapshot() > 0 then
			local ene = self:GetEnemy()
			if IsValid(ene) then
				local enePos = ene:GetPos()
				local angEne = (enePos - myPos + vec80z):Angle()
				local angDiffuse = self:Tank_AngleDiffuse(angEne.y, self:GetAngles().y + self.Tank_AngleOffset)
				local heightRatio = (enePos.z - myPos.z) / myPos:Distance(Vector(enePos.x, enePos.y, myPos.z))
				-- If the enemy is very high up, then move away from it to help the gunner fire!
				-- OR
				-- If the enemy's height isn't very high AND the enemy is ( within run over distance OR far away), then move towards the enemy!
				if (heightRatio > 0.15) or (heightRatio < 0.15 && ((self.LatestEnemyDistance < self.Tank_RanOverDistance) or (self.LatestEnemyDistance > self.Tank_DriveTowardsDistance))) then
					-- Turning
					if angDiffuse > 15 then
						self:SetLocalAngles(self:GetLocalAngles() + Angle(0, self.Tank_TurningSpeed, 0))
						phys:SetAngles(self:GetAngles())
					elseif angDiffuse < -15 then
						self:SetLocalAngles(self:GetLocalAngles() + Angle(0, -self.Tank_TurningSpeed, 0))
						phys:SetAngles(self:GetAngles())
					end
					
					-- Movement : Have a little grace zone so it doesn't constantly switch between forward and backwards driving
					if heightRatio > 0.15 or heightRatio < 0.1490 then
						local driveSpeed = self.Tank_DrivingSpeed
						local moveVel = self:GetForward()
						moveVel:Rotate(Angle(0, self.Tank_AngleOffset, 0))
						
						-- Increase speed based on how steep the slope is
						local slopeFactor = tr.HitNormal.z
						if slopeFactor < 1 then
							driveSpeed = driveSpeed * (1.1 + (1 - slopeFactor))
						end
						
						-- Move away instead of towards the enemy!
						if heightRatio > 0.15 then
							driveSpeed = -driveSpeed
						end
						
						if self.VJ_DEBUG then VJ.DEBUG_Print(self, false, "Driving Speed = ", driveSpeed) end
						phys:SetVelocity(moveVel:GetNormal() * driveSpeed)
						hasMoved = true
					end
				end
			end
			
			if hasMoved or phys:GetVelocity():Length() > 10 then
				hasMoved = true
				self.Tank_IsMoving = true
				self:Tank_PlaySoundSystem("Movement")
				self:UpdateMoveParticles()
			end
		end
	end
	
	-- Not moving
	if !hasMoved then
		VJ.STOPSOUND(self.CurrentTankMovingSound)
		VJ.STOPSOUND(self.CurrentTankTrackSound)
		self.Tank_IsMoving = false
	end
	
	for _, v in ipairs(ents.FindInSphere(myPos, 100)) do
		self:Tank_RunOver(v)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SelectSchedule()
	if self:Health() <= 0 or self.Dead then return end

	self:IdleSoundCode()
	self:MaintainIdleBehavior()
	
	if IsValid(self:GetEnemy()) then
		if self.VJ_IsBeingControlled then
			if self.VJ_TheController:KeyDown(IN_FORWARD) then
				self.Tank_Status = 0
			else
				self.Tank_Status = 1
			end
		else
			if (self.LatestEnemyDistance < self.Tank_DriveTowardsDistance && self.LatestEnemyDistance > self.Tank_DriveAwayDistance) or self.IsGuard then -- If between this two numbers, stay still
				self.Tank_Status = 1
			else
				self.Tank_Status = 0
			end
		end
	else
		self.Tank_Status = 1
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDamaged(dmginfo, hitgroup, status)
	if status == "PreDamage" && dmginfo:IsDamageType(DMG_SLASH) or dmginfo:IsDamageType(DMG_GENERIC) or dmginfo:IsDamageType(DMG_CLUB) then
		if dmginfo:GetDamage() >= 30 && !dmginfo:GetAttacker().VJ_ID_Boss then
			dmginfo:SetDamage(dmginfo:GetDamage() / 2)
		else
			dmginfo:SetDamage(0)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDeath(dmginfo, hitgroup, status)
	if status == "Initial" then
		if IsValid(self.Gunner) then
			self.Gunner.Dead = true
			if self:IsOnFire() then self.Gunner:Ignite(math.Rand(8, 10), 0) end
		end
		
		if self:Tank_OnInitialDeath(dmginfo, hitgroup) != true then
			for i=0, 1.5, 0.5 do
				timer.Simple(i, function()
					if IsValid(self) then
						local myPos = self:GetPos()
						VJ.EmitSound(self, "VJ.Explosion")
						util.BlastDamage(self, self, myPos, 200, 40)
						util.ScreenShake(myPos, 100, 200, 1, 2500)
						if self.HasGibOnDeathEffects then ParticleEffect("vj_explosion2", myPos, defAng) end
					end
				end)
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local vec500z = Vector(0, 0, 500)
local colorGray = Color(90, 90, 90)
--
function ENT:OnCreateDeathCorpse(dmginfo, hitgroup, corpseEnt)
	-- Spawn the gunner corpse
	if IsValid(self.Gunner) then
		self.Gunner.SavedDmgInfo = self.SavedDmgInfo
		local gunCorpse = self.Gunner:CreateDeathCorpse(dmginfo, hitgroup)
		if IsValid(gunCorpse) then corpseEnt.ChildEnts[#corpseEnt.ChildEnts + 1] = gunCorpse end
	end
	
	if self:Tank_OnDeathCorpse(dmginfo, hitgroup, corpseEnt, "Override") != true then
		local myPos = self:GetPos()
		VJ.EmitSound(self, "VJ.Explosion")
		util.BlastDamage(self, self, myPos, 400, 40)
		util.ScreenShake(myPos, 100, 200, 1, 2500)
		local tr = util.TraceLine({
			start = myPos + self:GetUp() * 4,
			endpos = myPos - vec500z,
			filter = self
		})
		util.Decal(VJ.PICK(self.Tank_DeathDecal), tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal)
		
		-- Create soldier corpse
		if math.random(1, self.Tank_DeathDriverCorpseChance) == 1 then
			local soldierMDL = VJ.PICK(self.Tank_DeathDriverCorpse)
			if soldierMDL then
				self:CreateExtraDeathCorpse("prop_ragdoll", soldierMDL, {Pos=myPos + self:GetUp()*90 + self:GetRight()*-30, Vel=Vector(math.Rand(-600, 600), math.Rand(-600, 600), 500)}, function(ent)
					ent:Ignite(math.Rand(8, 10), 0)
					ent:SetColor(colorGray)
					self:Tank_OnDeathCorpse(dmginfo, hitgroup, corpseEnt, "Soldier", ent)
				end)
			end
		end

		-- Effects / Particles
		if self.HasGibOnDeathEffects && self:Tank_OnDeathCorpse(dmginfo, hitgroup, corpseEnt, "Effects") != true then
			ParticleEffect("vj_explosion3", myPos, defAng)
			ParticleEffect("vj_explosion2", myPos + self:GetForward()*-130, defAng)
			ParticleEffect("vj_explosion2", myPos + self:GetForward()*130, defAng)
			ParticleEffectAttach("smoke_burning_engine_01", PATTACH_ABSORIGIN_FOLLOW, corpseEnt, 0)
			local effectData = EffectData()
			effectData:SetOrigin(myPos)
			util.Effect("VJ_Medium_Explosion1", effectData)
			effectData:SetScale(800)
			util.Effect("ThumperDust", effectData)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRemove()
	VJ.STOPSOUND(self.CurrentTankMovingSound)
	VJ.STOPSOUND(self.CurrentTankTrackSound)
	if IsValid(self.Gunner) then
		self.Gunner:Remove()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Tank_PlaySoundSystem(sdSet)
	if !self.HasSounds or !sdSet then return end
	if sdSet == "Movement" then
		if self.HasMoveSound then
			-- Movement sound
			local curMoveSD = self.CurrentTankMovingSound
			if !curMoveSD or (curMoveSD && !curMoveSD:IsPlaying()) then
				VJ.STOPSOUND(curMoveSD)
				self.CurrentTankMovingSound = VJ.CreateSound(self, VJ.PICK(self.Tank_SoundTbl_DrivingEngine) or "vj_base/vehicles/armored/engine_drive.wav", 80, 100)
			end
			-- Track sound
			local curTrackSD = self.CurrentTankTrackSound
			if !curTrackSD or (curTrackSD && !curTrackSD:IsPlaying()) then
				VJ.STOPSOUND(curTrackSD)
				self.CurrentTankTrackSound = VJ.CreateSound(self, VJ.PICK(self.Tank_SoundTbl_Track) or "vj_base/vehicles/armored/chassis_tracks.wav", 70, 100)
			end
		end
	elseif sdSet == "RunOver" then
		if self.HasRunOverSound && CurTime() > self.Tank_NextRunOverSoundT then
			self:EmitSound(VJ.PICK(self.Tank_SoundTbl_RunOver) or "VJ.Gib.Bone_Snap", 80, math.random(80, 100))
			self.Tank_NextRunOverSoundT = CurTime() + 0.2
		end
	end
end