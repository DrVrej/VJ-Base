if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/

	-- Default ---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Model = {} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want 
ENT.StartHealth = 200
//ENT.MoveType = MOVETYPE_VPHYSICS
ENT.HullType = HULL_LARGE
ENT.VJ_IsHugeMonster = true -- Is this a huge monster?
ENT.MovementType = VJ_MOVETYPE_PHYSICS -- How does the SNPC move?
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.HasAllies = true -- Put to false if you want it not to have any allies
ENT.Bleeds = false -- Does the SNPC bleed? (Blood decal, particle, etc.)
ENT.HasMeleeAttack = false -- Should the SNPC have a melee attack?
ENT.DisableWeapons = true -- If set to true, it won't be able to use weapons
ENT.DisableInitializeCapabilities = true -- If true, it will disable the initialize capabilities, this will allow you to add your own
ENT.DisableSelectSchedule = true -- Disables Schedule code, Custom Schedule can still work
//ENT.HasIdleSounds = false -- If set to false, it won't play the idle sounds
ENT.HasPainSounds = false -- If set to false, it won't play the pain sounds
ENT.CorpseAlwaysCollide = true -- Should the corpse always collide?
ENT.Immune_Dissolve = true -- Immune to Dissolving | Example: Combine Ball
ENT.Immune_AcidPoisonRadiation = true -- Immune to Acid, Poison and Radiation
ENT.Immune_Bullet = true -- Immune to Bullets
ENT.Immune_Freeze = true -- Immune to Freezing
ENT.Immune_Physics = true -- Immune to Physics
ENT.ImmuneDamagesTable = {DMG_BULLET,DMG_BUCKSHOT,DMG_PHYSGUN} -- You can set Specific types of damages for the SNPC to be immune to
//ENT.DisableFindEnemy = true -- Disables FindEnemy code, friendly code still works though
ENT.FindEnemy_UseSphere = true -- Should the SNPC be able to see all around him? (360) | Objects and walls can still block its sight!
ENT.CallForHelp = false -- Does the SNPC call for help?
ENT.WaitBeforeDeathTime = 2 -- Time until the SNPC spawns its corpse and gets removedz
ENT.GetDamageFromIsHugeMonster = true -- Should it get damaged no matter what by SNPCs that are tagged as VJ_IsHugeMonster?
ENT.DisableWandering = true -- Disables wandering when the SNPC is idle
ENT.BringFriendsOnDeath = false -- Should the SNPC's friends come to its position before it dies?
ENT.CallForBackUpOnDamage = false -- Should the SNPC call for help when damaged? (Only happens if the SNPC hasn't seen a enemy)
ENT.MoveOrHideOnDamageByEnemy = false -- Should the SNPC move or hide when being damaged by an enemy?
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_Breath = {"vj_mili_tank/tankidle1.wav"}
ENT.SoundTbl_Death = {"vj_mili_tank/tank_death1.wav"}

ENT.AlertSoundLevel = 70
ENT.IdleSoundLevel = 70
ENT.CombatIdleSoundLevel = 70
ENT.BreathSoundLevel = 70
ENT.DeathSoundLevel = 100

ENT.GeneralSoundPitch1 = 90
ENT.GeneralSoundPitch2 = 100

//ENT.NextSoundTime_Breath1 = 6.1 -- Time until it plays the sound again

-- Tank Base
ENT.Tank_GunnerENT = "npc_vj_tankg_base"
ENT.Tank_SpawningAngle = 180
ENT.Tank_AngleDiffuseNumber = 180
ENT.Tank_TurningSpeed = 1.5 -- Turning Speed
ENT.Tank_ForwardSpead = 70 -- Forward speed
ENT.Tank_MoveAwaySpeed = -70 -- Move away speed
ENT.Tank_UseGetRightForSpeed = false -- Should it use GetRight instead of GetForward when driving?
ENT.Tank_SeeClose = 500 -- If the enemy is closer than this number, than move!
ENT.Tank_SeeFar = 4000 -- If the enemy is higher than this number, than move!
ENT.Tank_SeeLimit = 6000 -- How far can it see?
ENT.Tank_DeathSoldierModels = {}

//ENT.Tank_CollisionBound_Back = 90
//ENT.Tank_CollisionBound_Front = 90
//ENT.Tank_CollisionBound_Right = 90
//ENT.Tank_CollisionBound_Left = 90
ENT.Tank_CollisionBoundSize = 90
ENT.Tank_CollisionBoundUp = 100

ENT.Tank_ResetedEnemy = false
ENT.Tank_IsMoving = false
ENT.Tank_Status = 0
ENT.Tank_NextLowHealthSmokeT = 0
ENT.Tank_NextRunOverSoundT = 0
ENT.TankTbl_DontRunOver = {"npc_antlionguard","npc_turret_ceiling","monster_gargantua","monster_bigmomma","monster_nihilanth","npc_strider","npc_combine_camera","npc_helicopter","npc_combinegunship","npc_combinedropship","npc_rollermine"}

util.AddNetworkString("vj_tank_base_spawneffects")
util.AddNetworkString("vj_tank_base_moveeffects")
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomInitialize_CustomTank() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Tank_GunnerSpawnPosition()
	return self:GetPos()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:CustomInitialize_CustomTank()
	self:PhysicsInit(SOLID_BBOX) // SOLID_VPHYSICS
	//self:CapabilitiesAdd(bit.bor(CAP_ANIMATEDFACE)) -- Breaks some SNPCs, avoid using it!
	self:CapabilitiesAdd(bit.bor(CAP_MOVE_GROUND))
	self:SetAngles(self:GetAngles()+Angle(0,self.Tank_SpawningAngle,0))
	//self:SetPos(self:GetPos()+Vector(0,0,90))
	self:SetCollisionBounds(Vector(self.Tank_CollisionBoundSize, self.Tank_CollisionBoundSize, self.Tank_CollisionBoundUp), Vector(-self.Tank_CollisionBoundSize, -self.Tank_CollisionBoundSize, 0))
	//self:SetCollisionBounds(Vector(self.Tank_CollisionBound_Back, self.Tank_CollisionBound_Right, self.Tank_CollisionBoundUp), Vector(-self.Tank_CollisionBound_Front, -self.Tank_CollisionBound_Left, 0))
	
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:SetMass(30000)
	end

	self.Gunner = ents.Create(self.Tank_GunnerENT)
	self.Gunner:Spawn()
	self.Gunner:SetPos(self:Tank_GunnerSpawnPosition())
	self.Gunner:SetAngles(self:GetAngles())
	self.Gunner:SetParent(self)
	//self:DropToFloor()
	
	/*local angrypapir = Vector(-100, -25, 50)
	self.ActualLight1 = ents.Create( "env_projectedtexture" )
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
function ENT:StartSpawnEffects()
	net.Start("vj_tank_base_spawneffects")
	net.WriteEntity(self)
	net.Broadcast()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:StartMoveEffects()
	net.Start("vj_tank_base_moveeffects")
	net.WriteEntity(self)
	net.Broadcast()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetNearDeathSparkPositions()
	local randpos = math.random(1,7)
	if randpos == 1 then return self.Spark1:SetLocalPos(self:GetPos() +self:GetForward()*100 +self:GetUp()*60) else
	if randpos == 2 then return self.Spark1:SetLocalPos(self:GetPos() +self:GetForward()*30 +self:GetUp()*60) end
	if randpos == 3 then return self.Spark1:SetLocalPos(self.WhiteLight1:GetPos()) end 
	if randpos == 4 then return self.Spark1:SetLocalPos(self.WhiteLight2:GetPos()) end
	if randpos == 5 then return self.Spark1:SetLocalPos(self:GetPos() +self:GetForward()*10 +self:GetUp()*60 +self:GetRight()*50) end
	if randpos == 6 then return self.Spark1:SetLocalPos(self:GetPos() +self:GetForward()*80 +self:GetUp()*60 +self:GetRight()*-50) end
	if randpos == 7 then return self.Spark1:SetLocalPos(self:GetPos() +self:GetForward()*-20 +self:GetUp()*60 +self:GetRight()*-30) end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
/*function ENT:GetRelationship(entity)
	if self.HasAllies == false then return end
	local friendslist = { "npc_vj_mili_m1a1abramsg_base" } -- List
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
function ENT:CustomOnTouch(entity)
if GetConVarNumber("ai_disabled") == 1 then return end
	if self.Tank_Status == 0 then
		self:TANK_RUNOVER_DAMAGECODE(entity)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:TANK_RUNOVER_DAMAGECODE(argent)
// if self.HasMeleeAttack == false then return end
if argent == NULL or argent == nil then return end
if GetConVarNumber("vj_npc_nomelee") == 1 then return end
if self.VJ_IsBeingControlled == true && self.VJ_TheControllerBullseye == argent then return end

local function Tank_DoDamage()
	if GetConVarNumber("vj_npc_dif_normal") == 1 then argent:TakeDamage(8,self,self) end -- Normal
	if GetConVarNumber("vj_npc_dif_easy") == 1 then argent:TakeDamage(8 /2,self,self) end -- Easy
	if GetConVarNumber("vj_npc_dif_hard") == 1 then argent:TakeDamage(8 *1.5,self,self) end -- Hard
	if GetConVarNumber("vj_npc_dif_hellonearth") == 1 then argent:TakeDamage(8 *2.5,self,self) end  -- Hell On Earth
	VJ_DestroyCombineTurret(self,argent)
	argent:SetVelocity(self:GetForward()*-800)
end

	if (argent:IsNPC() && argent:Disposition(self) == 1 && argent:Health() > 0) then
	if !argent:IsPlayer() && argent.IsVJBaseSNPC == true && argent.VJ_IsHugeMonster == false then
		Tank_DoDamage()
		self:TANK_RUNOVER_SOUND()
	end
	if (argent:IsNPC() && argent.IsVJBaseSNPC != true && !table.HasValue(self.TankTbl_DontRunOver,argent:GetClass())) or (argent:IsPlayer() && self.PlayerFriendly == false && GetConVarNumber("ai_ignoreplayers") == 0 && argent:Alive() && self.Tank_IsMoving == true) then
		Tank_DoDamage()
		self:TANK_RUNOVER_SOUND()
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
	if GetConVarNumber("vj_npc_noidleparticle") == 1 then return end
	timer.Simple(0.1,function()
	if self.Dead == false then
	self:StartSpawnEffects() end end)
	
	if self:Health() < (self.StartHealth*0.30) then
	if CurTime() > self.Tank_NextLowHealthSmokeT then
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
	self:DeleteOnRemove(self.Spark1)
	
	/*local effectdata = EffectData()
	effectdata:SetOrigin(self:GetPos() +self:GetUp()*60 +self:GetForward()*100)
	effectdata:SetNormal(Vector(0,0,0))
	effectdata:SetMagnitude(5)
	effectdata:SetScale(0.1)
	effectdata:SetRadius(10)
	util.Effect("Sparks",effectdata)*/
	timer.Simple(0.1,function()
	if self:IsValid() then
	if self.Spark1:IsValid() then
	self.Spark1:Remove() end
	 end
	end)
	self.Tank_NextLowHealthSmokeT = CurTime() + math.random(4,6) //9999999999999999 * 999999999999999999 * 999999
	 end
	end
	
	/*if self:Health() < (self.StartHealth*0.30) then
	if CurTime() > self.Tank_NextLowHealthSmokeT then
	ParticleEffectAttach("vj_rpg2_smoke2", PATTACH_ABSORIGIN_FOLLOW, self, 0)
	self.Tank_NextLowHealthSmokeT = CurTime() + 9999999999999999 * 999999999999999999 * 999999
	 end
	end*/
	
	/*if self:Health() <= 150 then
	print("BELOW 150!!!!!!!!!!!")
	self.FireEffect = ents.Create( "env_fire_trail" )
	self.FireEffect:SetPos(self:GetPos()+self:GetUp()*100)
	self.FireEffect:Spawn()
	self.FireEffect:SetParent(self)
	end*/
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink_AIEnabled()
	if self.Dead == true then return end
	//timer.Simple(0.1, function() if self.Dead == false then ParticleEffect("smoke_exhaust_01",self:LocalToWorld(Vector(150,30,30)),Angle(0,0,0),self) end end)
	//timer.Simple(0.2, function() if self.Dead == false then self:StopParticles() end end)
	for k,v in pairs(ents.FindInSphere(self:GetPos(),100)) do
		self:TANK_RUNOVER_DAMAGECODE(v)
	end

	local fucktraces = { start = self:GetPos(), endpos = self:GetPos() + self:GetUp()*-5, filter = self }
	local tr = util.TraceEntity( fucktraces, self ) 
	if ( tr.HitWorld ) then
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
	if phys:GetVelocity():Length() > 10 then  /*print("This fucking tank is moving")*/
	self.Tank_IsMoving = true
	self:TANK_MOVINGSOUND()
	self:StartMoveEffects()
	else VJ_STOPSOUND(self.tank_movingsd) self.Tank_IsMoving = false /*print(self:GetClass().." Is not fucking Moving!")*/ end end end
	if ( !tr.HitWorld ) then
	VJ_STOPSOUND(self.tank_movingsd) self.Tank_IsMoving = false /*print(self:GetClass().." Is not fucking Moving!")*/ end
	
/*
	//local fucktraces = { start = self:GetPos(), endpos = self:GetPos() + self:GetUp()*-5, filter = self }
	//local tr = util.TraceEntity( fucktraces, self ) 
	//if ( tr.HitWorld ) then
	if self:IsFalling() == false then
		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
		if phys:GetVelocity():Length() > 10 then
			self.Tank_IsMoving = true
			self:TANK_MOVINGSOUND()
			self:StartMoveEffects()
		else 
			VJ_STOPSOUND(self.tank_movingsd) 
			self.Tank_IsMoving = false
			end
		 //end
		end
	else
		VJ_STOPSOUND(self.tank_movingsd) 
		self.Tank_IsMoving = false
	end
*/
	self:CustomOnSchedule()
	
	if self.Tank_Status == 0 then
		if self:GetEnemy() == nil then
		self.Tank_Status = 1
	else
	//print((self:GetEnemy():GetPos() -self:GetPos() +Vector(0,0,80)):Angle())
	//print(self:GetAngles())
	-- x = Forward | y = Right | z = Up | {x,y,z}
	-- To make it go opposite:
		-- Change the +15 to -15 and -15 to 15 
		-- Change the forwad spead(Tank_ForwardSpead) to their opposite quotation(+ to -)
		-- Change the turning speed(Tank_TurningSpeed) to their opposite quotation(+ to -)
	local phys = self:GetPhysicsObject()
	local Angle_Enemy = (self:GetEnemy():GetPos() -self:GetPos() +Vector(0,0,80)):Angle()
	local Angle_Current = self:GetAngles()
	local Angle_Diffuse = self:AngleDiffuse(Angle_Enemy.y,Angle_Current.y+self.Tank_AngleDiffuseNumber)
	local Heigh_Ratio = (self:GetEnemy():GetPos().z - self:GetPos().z ) / self:GetPos():Distance(Vector(self:GetEnemy():GetPos().x,self:GetEnemy():GetPos().y,self:GetPos().z))

	//local fucktraces = { start = self:GetPos(), endpos = self:GetPos() + self:GetUp()*-5, filter = self }
	//local tr = util.TraceEntity( fucktraces, self )
	//if ( tr.HitWorld ) then
	if Heigh_Ratio < 0.15 then -- If it is that high than move away from it
		if phys:IsValid() then -- To help the gunner shoot
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
	//if self:GetEnemy().VJ_IsHugeMonster == false then
	elseif math.abs(Heigh_Ratio) > 1 && math.abs(Heigh_Ratio) < 0.6 then -- If it is that high than move toward it
		if phys:IsValid() then -- Run over
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
	 // end
	 end
	end
  // end
  end
 end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnSchedule()
	if self:Health() <= 0 or self.Dead == true then return end

	self:IdleSoundCode()

	if self:GetEnemy() == nil then
		if self.Tank_ResetedEnemy == false then
		self.Tank_ResetedEnemy = true
		self:ResetEnemy() end
	else
		EnemyPos = self:GetEnemy():GetPos()
		EnemyPosToSelf = self:GetPos():Distance(EnemyPos)
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
function ENT:TANK_MOVINGSOUND()
	if self.HasSounds == true && GetConVarNumber("vj_npc_sd_footstep") == 0 then
	self.tank_movingsd = CreateSound(self,"vj_mili_tank/tankdrive1.wav") self.tank_movingsd:SetSoundLevel(80)
	self.tank_movingsd:PlayEx(1,100)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:TANK_RUNOVER_SOUND()
	if self.HasSounds == true && CurTime() > self.Tank_NextRunOverSoundT then
		VJ_EmitSound(self,"vj_gib/bones_snapping"..math.random(1,3)..".wav",80,math.random(80,100))
		self.Tank_NextRunOverSoundT = CurTime() + 0.2
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_BeforeDamage(dmginfo,hitgroup)
	local panis = dmginfo:GetDamageType()
	if (panis == DMG_SLASH or panis == DMG_GENERIC or panis == DMG_CLUB) then
		if dmginfo:GetDamage() >= 30 && dmginfo:GetAttacker().VJ_IsHugeMonster != true then
		//dmginfo:ScaleDamage(0.5)
			dmginfo:SetDamage(dmginfo:GetDamage() /2)
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
	
	timer.Simple(0,function()
		if self:IsValid() then
			VJ_EmitSound(self,"vj_mili_tank/tank_death2.wav",100,100)
			util.BlastDamage(self,self,self:GetPos(),200,40)
			util.ScreenShake(self:GetPos(), 100, 200, 1, 2500)
			if self.HasGibDeathParticles == true then ParticleEffect("vj_explosion2",self:GetPos(),Angle(0,0,0),nil) end
		end
	end)
	
	timer.Simple(0.5,function()
		if self:IsValid() then
			VJ_EmitSound(self,"vj_mili_tank/tank_death2.wav",100,100)
			util.BlastDamage(self,self,self:GetPos(),200,40)
			util.ScreenShake(self:GetPos(), 100, 200, 1, 2500)
			if self.HasGibDeathParticles == true then ParticleEffect("vj_explosion2",self:GetPos(),Angle(0,0,0),nil) end
		end
	end)
	
	timer.Simple(1,function()
		if self:IsValid() then
			VJ_EmitSound(self,"vj_mili_tank/tank_death2.wav",100,100)
			util.BlastDamage(self,self,self:GetPos(),200,40)
			util.ScreenShake(self:GetPos(), 100, 200, 1, 2500)
			if self.HasGibDeathParticles == true then ParticleEffect("vj_explosion2",self:GetPos(),Angle(0,0,0),nil) end
		end
	end)
	
	timer.Simple(1.5,function()
		if self:IsValid() then
			VJ_EmitSound(self,"vj_mili_tank/tank_death2.wav",100,100)
			VJ_EmitSound(self,"vj_mili_tank/tank_death3.wav",100,100)
			util.BlastDamage(self,self,self:GetPos(),200,40)
			util.ScreenShake(self:GetPos(), 100, 200, 1, 2500)
			if self.HasGibDeathParticles == true then ParticleEffect("vj_explosion2",self:GetPos(),Angle(0,0,0),nil) end
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDeath_AfterCorpseSpawned(dmginfo,hitgroup,GetCorpse)
	util.BlastDamage( self, self, self:GetPos(),400, 40)
	util.ScreenShake(self:GetPos(), 100, 200, 1, 2500)
	
	-- Spawn the gunner
	if IsValid(self.Gunner) then
		local gunnercorpse = self.Gunner:CreateDeathCorpse(dmginfo,hitgroup)
		if IsValid(gunnercorpse) then table.insert(GetCorpse.ExtraCorpsesToRemove,gunnercorpse) end
	end

	-- Spawn the Soldier
	local panisrand = math.random(1,3)
	if panisrand == 1 then
		self:CreateExtraDeathCorpse("prop_ragdoll",VJ_PICKRANDOMTABLE(self.Tank_DeathSoldierModels),{Pos=self:GetPos()+self:GetUp()*90+self:GetRight()*-30,Vel=Vector(math.Rand(-600,600), math.Rand(-600,600),500)},function(extraent) extraent:Ignite(math.Rand(8,10),0) extraent:SetColor(Color(90,90,90)) end)
	end
	
	self:SetPos(Vector(self:GetPos().x,self:GetPos().y,self:GetPos().z +4)) -- Because the NPC is too close to the ground
	local tr = util.TraceLine({
		start = self:GetPos(),
		endpos = self:GetPos() - Vector(0, 0, 500),
		filter = self
	})
	util.Decal("Scorch",tr.HitPos+tr.HitNormal,tr.HitPos-tr.HitNormal)
	
	if self.HasGibDeathParticles == true then
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
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRemove()
	VJ_STOPSOUND(self.tank_movingsd)
	if IsValid(self.Gunner) then
		self.Gunner:Remove()
	end
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/