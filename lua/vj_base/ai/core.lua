/*-----------------------------------------------
	*** Copyright (c) 2012-2026 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
---------------------------------------------------------------------------------------------------------------------------------------------
/*
	This file contains functions and variables shared between all the NPC bases.
	
	-- Change movement speed:
	self:SetLocalVelocity(self:GetMoveVelocity() * 1.5)
	
	-- Debugging eye and head directions:
	debugoverlay.Box(self:EyePos() + self:GetHeadDirection(), Vector(-2, -2, -2), Vector(2, 2, 2), 0.2)
	debugoverlay.Line(self:EyePos() + self:GetHeadDirection(), self:EyePos() + self:GetHeadDirection() * 100, 0.2)
	debugoverlay.Box(self:EyePos() + self:GetEyeDirection(), Vector(-2, -2, -2), Vector(2, 2, 2), 0.2, VJ.COLOR_RED)
	debugoverlay.Line(self:EyePos() + self:GetEyeDirection(), self:EyePos() + self:GetEyeDirection() * 100, 0.2, VJ.COLOR_RED)
	
	-- Eye offset example:
	local newEyeOffset = self:WorldToLocal(self:GetAttachment(self:LookupAttachment("mouth")).Pos)
	self:SetViewOffset(newEyeOffset)
	self:SetSaveValue("m_vDefaultEyeOffset", newEyeOffset)
*/
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
AccessorFunc(ENT, "m_iClass", "NPCClass", FORCE_NUMBER)
AccessorFunc(ENT, "m_fMaxYawSpeed", "MaxYawSpeed", FORCE_NUMBER)

local metaEntity = FindMetaTable("Entity")
local funcGetTable = metaEntity.GetTable
local funcSetSaveValue = metaEntity.SetSaveValue
local funcGetCycle = metaEntity.GetCycle
local funcGetSequenceActivity = metaEntity.GetSequenceActivity
local funcVisible = metaEntity.Visible
local funcGetClass = metaEntity.GetClass

local metaNPC = FindMetaTable("NPC")
local funcGetEnemy = metaNPC.GetEnemy
local funcGetIdealActivity = metaNPC.GetIdealActivity
local funcGetActivity = metaNPC.GetActivity
local funcGetIdealSequence = metaNPC.GetIdealSequence
local funcSetIdealActivity = metaNPC.SetIdealActivity
local funcAddEntityRelationship = metaNPC.AddEntityRelationship
local funcIsInViewCone = metaNPC.IsInViewCone

local defPos = Vector()
local defAng = Angle()
local CurTime = CurTime
local IsValid = IsValid
local GetConVar = GetConVar
local isnumber = isnumber
local isvector = isvector
local isstring = isstring
local tonumber = tonumber
local table_remove = table.remove
local bAND = bit.band
local math_rad = math.rad
local math_deg = math.deg
local math_cos = math.cos
local math_atan2 = math.atan2
local math_min = math.min
local math_max = math.max
local math_angDif = math.AngleDifference
local StopSD = VJ.STOPSOUND
local PICK = VJ.PICK
local VJ_STATE_NONE = VJ_STATE_NONE
local VJ_STATE_FREEZE = VJ_STATE_FREEZE
local VJ_STATE_ONLY_ANIMATION_CONSTANT = VJ_STATE_ONLY_ANIMATION_CONSTANT
local VJ_BEHAVIOR_PASSIVE = VJ_BEHAVIOR_PASSIVE
local VJ_BEHAVIOR_PASSIVE_NATURE = VJ_BEHAVIOR_PASSIVE_NATURE
local VJ_MOVETYPE_GROUND = VJ_MOVETYPE_GROUND
local VJ_MOVETYPE_AERIAL = VJ_MOVETYPE_AERIAL
local VJ_MOVETYPE_AQUATIC = VJ_MOVETYPE_AQUATIC
local VJ_MOVETYPE_STATIONARY = VJ_MOVETYPE_STATIONARY
local VJ_MOVETYPE_PHYSICS = VJ_MOVETYPE_PHYSICS
local ALERT_STATE_READY = VJ.ALERT_STATE_READY
local ALERT_STATE_ENEMY = VJ.ALERT_STATE_ENEMY
local ANIM_TYPE_NONE = VJ.ANIM_TYPE_NONE
local ANIM_TYPE_ACTIVITY = VJ.ANIM_TYPE_ACTIVITY
local ANIM_TYPE_SEQUENCE = VJ.ANIM_TYPE_SEQUENCE
local ANIM_TYPE_GESTURE = VJ.ANIM_TYPE_GESTURE
local MEM_OVERRIDE_DISPOSITION = VJ.MEM_OVERRIDE_DISPOSITION
local MEM_CACHE_CLASSES = VJ.MEM_CACHE_CLASSES
local MEM_CACHE_DISPOSITION = VJ.MEM_CACHE_DISPOSITION
local MEM_CACHE_ENT_TYPE = VJ.MEM_CACHE_ENT_TYPE

-- Convars
local vj_npc_blood_gmod = GetConVar("vj_npc_blood_gmod")
local vj_npc_gib_collision = GetConVar("vj_npc_gib_collision")
local vj_npc_gib_fade = GetConVar("vj_npc_gib_fade")
local vj_npc_gib_fadetime = GetConVar("vj_npc_gib_fadetime")
local vj_npc_human_jump = GetConVar("vj_npc_human_jump")

ENT.VJ_ID_Healable = true

-- Data & control variables
ENT.VJ_DEBUG = false
ENT.VJ_IsBeingControlled = false
ENT.VJ_IsBeingControlled_Tool = false
ENT.VJ_TheController = NULL
ENT.VJ_TheControllerEntity = NULL
ENT.VJ_TheControllerBullseye = NULL
ENT.SelectedDifficulty = VJ.DIFFICULTY_NORMAL
ENT.AIState = VJ_STATE_NONE
ENT.NextProcessT = 0
ENT.MedicData = {
	Status = false, -- false = Not active | "Active" = Attempting to heal ally (Going after etc.) | "Healing" = Has reached ally and is healing it
	Target = NULL, -- Entity that it's healing
	Prop = NULL, -- Prop that it spawned while healing
	Cooldown = 0 -- Next time it can heal an ally again
}
ENT.IsFollowing = false
ENT.FollowData = {
	Target = NULL, -- Target that it's following
	MinDist = 0,
	Moving = false,
	StopAct = false,
	NextUpdateT = 0
}
ENT.EnemyData = {
	Target = NULL, -- Enemy entity | Cached value of "GetEnemy()", use it when you're already retrieving the "EnemyData"
	Distance = 0, -- Distance to the enemy
	DistanceNearest = 0, -- Nearest position distance to the enemy
	TimeSet = 0, -- Last time an enemy was set | Updated whenever "ForceSetEnemy" is ran successfully
	TimeAcquired = 0, -- Time since it acquired an enemy | Switching enemies does NOT reset this!
	Visible = false, -- Is the enemy visible? | Updated every "Think" run!
	VisibleCount = 0, -- Number of visible enemies
	VisibleTime = 0, -- Last time the enemy was visible (CurTime)
	VisiblePos = Vector(), -- Last visible position of the enemy, based on "EyePos", for origin call "self:GetEnemyLastSeenPos()"
	VisiblePosReal = Vector(), -- Last calculated visible position of the enemy, it's often wrong! | Mostly a backend variable
	Reset = true -- Enemy has reset | Mostly a backend variable
}
ENT.TurnData = {
	Type = VJ.FACE_NONE,
	Target = nil,
	StopOnFace = false,
	IsSchedule = false,
	LastYaw = 0
}
ENT.GuardData = {
	Position = false, -- Position that it's set to guard
	Direction = false -- Direction to face while guarding
}
ENT.PauseAttacks = false
ENT.AnimLockTime = 0
ENT.AnimPlaybackRate = 1
ENT.AnimModelSet = VJ.ANIM_SET_NONE
ENT.LastAnimSeed = 0
ENT.LastAnimType = VJ.ANIM_TYPE_NONE
ENT.AttackSeed = 0
ENT.AttackType = VJ.ATTACK_TYPE_NONE
ENT.AttackState = VJ.ATTACK_STATE_NONE
ENT.AttackAnim = ACT_INVALID
ENT.AttackAnimDuration = 0
ENT.AttackAnimTime = 0
ENT.NextDoAnyAttackT = 0
ENT.IsAbleToMeleeAttack = true
ENT.MeleeAttack_IsPropAttack = false
ENT.NextIdleTime = 0
ENT.NextWanderTime = 0
ENT.NextChaseTime = 0
ENT.Alerted = false
ENT.Flinching = false
ENT.NextFlinchT = 0
ENT.HealthRegenDelayT = 0
ENT.NextCombineBallDmgT = 0
ENT.Dead = false
ENT.GibbedOnDeath = false
ENT.DeathAnimationCodeRan = false
ENT.TakingCoverT = 0
ENT.NextOnPlayerSightT = 0
ENT.LastHiddenZone_CanWander = true
ENT.LastHiddenZoneT = 0
ENT.NextInvestigationMove = 0
ENT.NextInvestigateSoundT = 0
ENT.NextFootstepSoundT = 0
ENT.NextBreathSoundT = 0
ENT.NextIdleSoundT = 0
ENT.IdleSoundBlockTime = 0 -- Set by other sounds, it keeps the actual idle sound delay intact while blocking it from playing until it expires
ENT.NextAlertSoundT = 0
ENT.NextCallForHelpT = 0
ENT.NextCallForHelpAnimationT = 0
ENT.NextLostEnemySoundT = 0
ENT.NextAllyDeathSoundT = 0
ENT.NextKilledEnemySoundT = 0
ENT.NextDamageAllyResponseT = 0
ENT.NextDamageByPlayerSoundT = 0
ENT.NextPainSoundT = 0
ENT.MainSoundPitchValue = 0
ENT.TimersToRemove = {
    "state_reset",
    "wep_state_reset",
    "turn_reset",
    "flinch_reset",
	"alert_reset",
    "attack_pause_reset",
    "attack_melee_start",
    "attack_melee_reset",
    "attack_melee_reset_able",
    "attack_range_start",
    "attack_range_reset",
    "attack_range_reset_able",
    "attack_leap_jump",
    "attack_leap_start",
    "attack_leap_reset",
    "attack_leap_reset_able",
	"attack_grenade_start",
    "attack_grenade_reset",
    "attack_grenade_reset_able"
}
//ENT.SavedDmgInfo = {} -- Set later
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Creates a extra corpse entity, use this function to create extra corpse entities when the NPC is killed
		- class = The object class to use, common types: "prop_ragdoll", "prop_physics"
		- models = Model(s) to use, can be a table which it will pick randomly from it OR a string | "None" = Doesn't set a model
		- extra = Table that holds extra options to modify parts of the code
			- Pos = Sets the spawn position
			- Ang = Sets the spawn angle
			- Vel = Sets the velocity | DEFAULT = Uses damage force + NPC velocity
			- HasVel = If set to false, it won't set any velocity, allowing you to code your own in customFunc | DEFAULT = true
			- ShouldFade = Should it fade away after certain time | DEFAULT = false
			- ShouldFadeTime = How much time until the entity fades away | DEFAULT = 0
			- RemoveOnCorpseDelete = Should the entity get removed if the corpse is removed? | DEFAULT = true
		- customFunc(ent) = Use this to edit the entity which is given as parameter "ent"
-----------------------------------------------------------]]
local colorGrey = Color(90, 90, 90)
--
function ENT:CreateExtraDeathCorpse(class, models, extra, customFunc)
	-- Should only be ran after self.Corpse has been created!
	local corpse = self.Corpse
	if !IsValid(corpse) then return end
	local dmginfo = corpse.DamageInfo
	if !dmginfo then return end
	extra = extra or {}
	local ent = ents.Create(class or "prop_ragdoll")
	if models != "None" then ent:SetModel(PICK(models)) end
	ent:SetPos(extra.Pos or self:GetPos())
	ent:SetAngles(extra.Ang or self:GetAngles())
	ent:Spawn()
	ent:Activate()
	ent:SetColor(corpse:GetColor())
	ent:SetMaterial(corpse:GetMaterial())
	ent:SetCollisionGroup(self.DeathCorpseCollisionType)
	if corpse:IsOnFire() then
		ent:Ignite(math.Rand(8, 10), 0)
		ent:SetColor(colorGrey)
	end
	if extra.HasVel != false then
		local dmgForce = (self.SavedDmgInfo.force / 40) + self:GetMoveVelocity() + self:GetVelocity()
		if self.DeathAnimationCodeRan then
			dmgForce = self:GetGroundSpeedVelocity()
		end
		ent:GetPhysicsObject():AddVelocity(extra.Vel or dmgForce)
	end
	if extra.ShouldFade == true then
		local fadeTime = extra.ShouldFadeTime or 0
		if funcGetClass(ent) == "prop_ragdoll" then
			ent:Fire("FadeAndRemove", nil, fadeTime)
		else
			ent:Fire("kill", nil, fadeTime)
		end
	end
	if extra.RemoveOnCorpseDelete != false then //corpse:DeleteOnRemove(ent)
		corpse.ChildEnts[#corpse.ChildEnts + 1] = ent
	end
	if (customFunc) then customFunc(ent) end
	return ent
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Creates a gib entity, use this function to create gib!
		- class = The object class to use, recommended to use "obj_vj_gib", and for ragdoll type of gib use "prop_ragdoll"
		- models = Model(s) to use, can be a table which it will pick randomly from it OR a string
			- Defined strings: "UseAlien_Small", "UseAlien_Big", "UseHuman_Small", "UseHuman_Big"
		- extra = Table that holds extra options to modify parts of the code
			- Pos = Sets the spawn position
			- Ang = Sets the spawn angle | DEFAULT = Random angle
			- Vel = Sets the velocity | "UseDamageForce" = To use the damage's force only | DEFAULT = Random velocity
			- Vel_ApplyDmgForce = If set to false, it won't add the damage force to the given velocity | DEFAULT = true
			- AngVel = Angle velocity, basically the speed it rotates as it's flying | DEFAULT = Random velocity
			- BloodType = Sets the blood type of the gib | Overrides "CollisionDecal" option | Works only with "obj_vj_gib"
			- CollisionDecal = Decal it spawns when it collides with something | false = Disable decals | DEFAULT = Base decides
			- CollisionSound = Sound(s) it plays when it collides with something | false = Disable collision sounds | DEFAULT = Base decides
			- NoFade = Should it let the base make it fade & remove (Adjusted in the NPC settings menu) | DEFAULT = false
			- RemoveOnCorpseDelete = Should the entity get removed if the corpse is removed? | DEFAULT = false
		- customFunc(gib) = Use this to edit the entity which is given as parameter "gib"
-----------------------------------------------------------]]
local gib_mdlAAll = {"models/vj_base/gibs/alien/gib_small1.mdl", "models/vj_base/gibs/alien/gib_small2.mdl", "models/vj_base/gibs/alien/gib_small3.mdl", "models/vj_base/gibs/alien/gib1.mdl", "models/vj_base/gibs/alien/gib2.mdl", "models/vj_base/gibs/alien/gib3.mdl", "models/vj_base/gibs/alien/gib4.mdl", "models/vj_base/gibs/alien/gib5.mdl", "models/vj_base/gibs/alien/gib6.mdl", "models/vj_base/gibs/alien/gib7.mdl"}
local gib_mdlASmall = {"models/vj_base/gibs/alien/gib_small1.mdl", "models/vj_base/gibs/alien/gib_small2.mdl", "models/vj_base/gibs/alien/gib_small3.mdl"}
local gib_mdlABig = {"models/vj_base/gibs/alien/gib1.mdl", "models/vj_base/gibs/alien/gib2.mdl", "models/vj_base/gibs/alien/gib3.mdl", "models/vj_base/gibs/alien/gib4.mdl", "models/vj_base/gibs/alien/gib5.mdl", "models/vj_base/gibs/alien/gib6.mdl", "models/vj_base/gibs/alien/gib7.mdl"}
local gib_mdlHSmall = {"models/vj_base/gibs/human/gib_small1.mdl", "models/vj_base/gibs/human/gib_small2.mdl", "models/vj_base/gibs/human/gib_small3.mdl"}
local gib_mdlHBig = {"models/vj_base/gibs/human/gib1.mdl", "models/vj_base/gibs/human/gib2.mdl", "models/vj_base/gibs/human/gib3.mdl", "models/vj_base/gibs/human/gib4.mdl", "models/vj_base/gibs/human/gib5.mdl", "models/vj_base/gibs/human/gib6.mdl", "models/vj_base/gibs/human/gib7.mdl"}
--
function ENT:CreateGibEntity(class, models, extra, customFunc)
	if !self.CanGib then return end
	local bloodType = false
	if models == "UseAlien_Small" then
		models =  PICK(gib_mdlASmall)
		bloodType = VJ.BLOOD_COLOR_YELLOW
	elseif models == "UseAlien_Big" then
		models =  PICK(gib_mdlABig)
		bloodType = VJ.BLOOD_COLOR_YELLOW
	elseif models == "UseHuman_Small" then
		models =  PICK(gib_mdlHSmall)
		bloodType = VJ.BLOOD_COLOR_RED
	elseif models == "UseHuman_Big" then
		models =  PICK(gib_mdlHBig)
		bloodType = VJ.BLOOD_COLOR_RED
	else -- Custom models
		models = PICK(models)
		if VJ.HasValue(gib_mdlAAll, models) then
			bloodType = VJ.BLOOD_COLOR_YELLOW
		end
	end
	extra = extra or {}
		local vel = extra.Vel or Vector(math.Rand(-100, 100), math.Rand(-100, 100), math.Rand(150, 250))
		if self.SavedDmgInfo then
			local dmgForce = self.SavedDmgInfo.force / 70
			if extra.Vel_ApplyDmgForce != false && extra.Vel != "UseDamageForce" then -- Use both damage force AND given velocity
				vel = vel + dmgForce
			elseif extra.Vel == "UseDamageForce" then -- Use damage force
				vel = dmgForce
			end
		end
		bloodType = (extra.BloodType or bloodType or self.BloodColor) -- Certain entities such as the VJ Gib entity, you can use this to set its gib type
	
	local gib = ents.Create(class or "obj_vj_gib")
	gib:SetModel(models)
	gib:SetPos(extra.Pos or (self:GetPos() + self:OBBCenter()))
	gib:SetAngles(extra.Ang or Angle(math.Rand(-180, 180), math.Rand(-180, 180), math.Rand(-180, 180)))
	if funcGetClass(gib) == "obj_vj_gib" then
		gib.BloodType = bloodType
		if extra.CollisionDecal != nil then
			gib.CollisionDecal = extra.CollisionDecal
		elseif extra.BloodDecal then -- Backwards compatibility
			gib.CollisionDecal = extra.BloodDecal
		end
		if extra.CollisionSound != nil then
			gib.CollisionSound = extra.CollisionSound
		elseif extra.CollideSound then -- Backwards compatibility
			gib.CollisionSound = extra.CollideSound
		end
		//gib.BloodData = {Color = bloodType, Particle = self.BloodParticle, Decal = self.CollisionDecal} -- For eating system
	end
	gib:Spawn()
	gib:Activate()
	gib.IsVJBaseCorpse_Gib = true
	if vj_npc_gib_collision:GetInt() == 0 then gib:SetCollisionGroup(COLLISION_GROUP_DEBRIS) end
	local phys = gib:GetPhysicsObject()
	if IsValid(phys) then
		phys:AddVelocity(vel)
		phys:AddAngleVelocity(extra.AngVel or Vector(math.Rand(-200, 200), math.Rand(-200, 200), math.Rand(-200, 200)))
	end
	if extra.NoFade != true && vj_npc_gib_fade:GetInt() == 1 then
		local gibClass = funcGetClass(gib)
		if gibClass == "obj_vj_gib" then
			timer.Simple(vj_npc_gib_fadetime:GetInt(), function() if IsValid(gib) then gib:Remove() end end)
		elseif gibClass == "prop_ragdoll" then
			gib:Fire("FadeAndRemove", nil, vj_npc_gib_fadetime:GetInt())
		elseif gibClass == "prop_physics" then
			gib:Fire("kill", nil, vj_npc_gib_fadetime:GetInt())
		end
	end
	if extra.RemoveOnCorpseDelete then //self.Corpse:DeleteOnRemove(extraent)
		if !self.DeathCorpse_ChildEnts then self.DeathCorpse_ChildEnts = {} end -- If it doesn't exist, then create it!
		self.DeathCorpse_ChildEnts[#self.DeathCorpse_ChildEnts + 1] = gib
	end
	if (customFunc) then customFunc(gib) end
	return gib
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[
More info about sound hints: https://github.com/DrVrej/VJ-Base/wiki/Developer-Notes#sound-hints
-- Condition --					-- Sound bit --								-- Suggested Use --
COND_HEAR_DANGER				SOUND_DANGER								Danger
COND_HEAR_PHYSICS_DANGER		SOUND_PHYSICS_DANGER						Danger
COND_HEAR_MOVE_AWAY				SOUND_MOVE_AWAY								Danger
COND_HEAR_COMBAT				SOUND_COMBAT								Interest
COND_HEAR_WORLD					SOUND_WORLD									Interest
COND_HEAR_BULLET_IMPACT			SOUND_BULLET_IMPACT							Interest
COND_HEAR_PLAYER				SOUND_PLAYER								Interest
COND_SMELL						SOUND_CARCASS/SOUND_MEAT/SOUND_GARBAGE		Smell
COND_HEAR_THUMPER				SOUND_THUMPER								Special case
COND_HEAR_BUGBAIT				SOUND_BUGBAIT								Special case
COND_NO_HEAR_DANGER				none										No danger detected
COND_HEAR_SPOOKY 				none										Not possible in GMod due to the missing SOUNDENT_CHANNEL_SPOOKY_NOISE
--]]
local sdInterests = bit.bor(SOUND_COMBAT, SOUND_DANGER, SOUND_BULLET_IMPACT, SOUND_PHYSICS_DANGER, SOUND_MOVE_AWAY, SOUND_PLAYER_VEHICLE, SOUND_PLAYER, SOUND_WORLD, SOUND_CARCASS, SOUND_MEAT, SOUND_GARBAGE)
--
function ENT:GetSoundInterests()
	return sdInterests
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Reset and stop the eating behavior
		- statusData = Status info to pass to "OnEat" (info types defined in that function)
-----------------------------------------------------------]]
function ENT:ResetEatingBehavior(statusData)
	local eatingData = self.EatingData
	self:SetState(VJ_STATE_NONE)
	self:OnEat("StopEating", statusData)
	self.VJ_ST_Eating = false
	self.AnimationTranslations[ACT_IDLE] = eatingData.OrgIdle -- Reset the idle animation table in case it changed!
	local food = eatingData.Target
	if IsValid(food) then
		local foodData = food.FoodData
		-- if we are the last person eating, then reset the food data!
		if foodData.NumConsumers <= 1 then
			food.VJ_ST_BeingEaten = false
			foodData.NumConsumers = 0
			foodData.SizeRemaining = foodData.Size
		else
			foodData.NumConsumers = foodData.NumConsumers - 1
			foodData.SizeRemaining = foodData.SizeRemaining + self:OBBMaxs():Distance(self:OBBMins())
		end
	end
	self.EatingData = {Target = NULL, NextCheck = eatingData.NextCheck, AnimStatus = "None", OrgIdle = nil}
	-- AnimStatus: "None" = Not prepared (Probably moving to food location) | "Prepared" = Prepared (Ex: Played crouch down anim) | "Eating" = Prepared and is actively eating
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Called every time a change occurs in the eating system
		- status = Type of update that is occurring, holds one of the following states:
			- "CheckFood"		= Possible food found, check if it's good
			- "StartBehavior"	= Food found, start the eating behavior
			- "BeginEating"		= Food location reached
			- "Eat"				= Actively eating food
			- "StopEating"		= Food may have moved, removed, or finished
		- statusData = Some status may have extra data:
			- "CheckFood": SoundHintData table, more info: https://wiki.facepunch.com/gmod/Structures/SoundHintData
			- "StopEating": String, holding one of the following states:
				- "HaltOnly"	= This is ONLY a halt, not complete reset!		| Recommendation: Play normal get up anim
				- "Unspecified"	= Ex: Food suddenly removed or moved far away	| Recommendation: Play normal get up anim
				- "Devoured"	= Has completely devoured the food!				| Recommendation: Play normal get up anim and play a sound
				- "Enemy"		= Has been alerted or detected an enemy			| Recommendation: Play startled get up anim
				- "Injured"		= Has been injured by something					| Recommendation: Play startled get up anim
				- "Dead"		= Has died, usually called in "OnRemove"		| Recommendation: Do NOT play any animation!
	Returns
		- Boolean, ONLY used for "CheckFood", returning true will tell the base the possible food is valid
		- Number, Delay to add before moving to another status, useful to make sure animations aren't cut off!
-----------------------------------------------------------]]
local vecZ50 = Vector(0, 0, -50)
--
function ENT:OnEat(status, statusData)
	-- NOTE: The following code is a ideal example based on Half-Life 1 Zombie
	//VJ.DEBUG_Print(self, "OnEat", status, statusData)
	if status == "CheckFood" then
		return true //statusData.owner.BloodData && statusData.owner.BloodData.Color == VJ.BLOOD_COLOR_RED
	elseif status == "BeginEating" then
		self.AnimationTranslations[ACT_IDLE] = ACT_GESTURE_RANGE_ATTACK1 -- Eating animation
		return select(2, self:PlayAnim(ACT_ARM, true, false))
	elseif status == "Eat" then
		VJ.EmitSound(self, "barnacle/bcl_chew" .. math.random(1, 3) .. ".wav", 55)
		-- Health changes
		local food = self.EatingData.Target
		local damage = 15 -- How much damage food will receive
		local foodHP = food:Health() -- Food's health
		local myHP = self:Health() -- NPC's current health
		self:SetHealth(math.Clamp(myHP + ((damage > foodHP and foodHP) or damage), myHP, self:GetMaxHealth() < myHP and myHP or self:GetMaxHealth())) -- Give health to the NPC
		food:SetHealth(foodHP - damage) -- Decrease corpse health
		-- Blood effects
		local bloodData = food.BloodData
		if bloodData then
			local bloodPos = food:GetPos() + food:OBBCenter()
			local bloodParticle = PICK(bloodData.Particle)
			if bloodParticle then
				ParticleEffect(bloodParticle, bloodPos, self:GetAngles())
			end
			local bloodDecal = PICK(bloodData.Decal)
			if bloodDecal then
				local tr = util.TraceLine({start = bloodPos, endpos = bloodPos + vecZ50, filter = {food, self}})
				util.Decal(bloodDecal, tr.HitPos + tr.HitNormal + Vector(math.random(-45, 45), math.random(-45, 45), 0), tr.HitPos - tr.HitNormal, food)
			end
		end
		return 2 -- Eat every this seconds
	elseif status == "StopEating" then
		if statusData != "Dead" && self.EatingData.AnimStatus != "None" then -- Do NOT play anim while dead or has NOT prepared to eat
			return select(2, self:PlayAnim(ACT_DISARM, true, false))
		end
	end
	return 0
end
---------------------------------------------------------------------------------------------------------------------------------------------
local capBitsGround = bit.bor(CAP_MOVE_GROUND, CAP_MOVE_JUMP, CAP_MOVE_CLIMB, CAP_MOVE_SHOOT)
local capBitsShared = bit.bor(CAP_MOVE_GROUND, CAP_MOVE_JUMP, CAP_MOVE_CLIMB, CAP_MOVE_SHOOT, CAP_MOVE_FLY)
--
function ENT:DoChangeMovementType(movType)
	if !movType then return end
	self.MovementType = movType
	if movType == VJ_MOVETYPE_GROUND then
		self:RemoveFlags(FL_FLY)
		self:CapabilitiesRemove(CAP_MOVE_FLY)
		self:SetNavType(NAV_GROUND)
		self:SetMoveType(MOVETYPE_STEP)
		self:CapabilitiesAdd(CAP_MOVE_GROUND)
		-- NOTE: Humans don't set CAP_MOVE_CLIMB by default!
		if self.IsVJBaseSNPC_Human then
			if (VJ.AnimExists(self, ACT_JUMP) && vj_npc_human_jump:GetInt() == 1) or self.UsePoseParameterMovement then
				self:CapabilitiesAdd(CAP_MOVE_JUMP)
			end
			if !self.Weapon_Disabled && self.Weapon_CanMoveFire then
				self:CapabilitiesAdd(CAP_MOVE_SHOOT)
			end
		else
			if VJ.AnimExists(self, ACT_JUMP) or self.UsePoseParameterMovement then
				self:CapabilitiesAdd(CAP_MOVE_JUMP)
			end
			if VJ.AnimExists(self, ACT_CLIMB_UP) then
				self:CapabilitiesAdd(CAP_MOVE_CLIMB)
			end
		end
	elseif movType == VJ_MOVETYPE_AERIAL or movType == VJ_MOVETYPE_AQUATIC then
		self:CapabilitiesRemove(capBitsGround)
		self:SetGroundEntity(NULL)
		self:AddFlags(FL_FLY)
		self:SetNavType(NAV_FLY)
		self:SetMoveType(MOVETYPE_STEP) // MOVETYPE_FLY = causes issues like Lerp functions not being smooth
		self:CapabilitiesAdd(CAP_MOVE_FLY)
	elseif movType == VJ_MOVETYPE_STATIONARY then
		self:RemoveFlags(FL_FLY)
		self:CapabilitiesRemove(capBitsShared)
		self:SetNavType(NAV_NONE)
		if !IsValid(self:GetParent()) then -- Only set move type if it does NOT have a parent!
			self:SetMoveType(MOVETYPE_FLY)
		end
	elseif movType == VJ_MOVETYPE_PHYSICS then
		self:RemoveFlags(FL_FLY)
		self:CapabilitiesRemove(capBitsShared)
		self:SetNavType(NAV_NONE)
		self:SetMoveType(MOVETYPE_VPHYSICS)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:UpdateAnimationTranslations(wepHoldType)
	-- Decide what type of animation set to use
	if !self.AnimModelSet then
		if VJ.AnimExists(self, "signal_takecover") && VJ.AnimExists(self, "grenthrow") && VJ.AnimExists(self, "bugbait_hit") then
			self.AnimModelSet = VJ.ANIM_SET_COMBINE -- Combine
		elseif VJ.AnimExists(self, ACT_WALK_AIM_PISTOL) && VJ.AnimExists(self, ACT_RUN_AIM_PISTOL) && VJ.AnimExists(self, ACT_POLICE_HARASS1) then
			self.AnimModelSet = VJ.ANIM_SET_METROCOP -- Metrocop
		elseif VJ.AnimExists(self, "coverlow_r") && VJ.AnimExists(self, "wave_smg1") && VJ.AnimExists(self, ACT_BUSY_SIT_GROUND) then
			self.AnimModelSet = VJ.ANIM_SET_REBEL -- Rebel
		elseif VJ.AnimExists(self, "gmod_breath_layer") then
			self.AnimModelSet = VJ.ANIM_SET_PLAYER -- Player
		end
	end
	self.AnimationTranslations = {} -- Reset all translated animations
	self:SetAnimationTranslations(wepHoldType)
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Helper function used in `TranslateActivity` when randomly picking from a table
	NOTE: ALWAYS use this when overriding ACT_IDLE from a table!
		- tbl = Table to retrieve an animation from
	Returns
		- Activity it picked
-----------------------------------------------------------]]
function ENT:ResolveAnimation(tbl)
	-- Returns the current animation if it's found in the table and is not done playing it
	if funcGetCycle(self) < 0.99 then
		local curAnim = funcGetSequenceActivity(self, funcGetIdealSequence(self))
		for _, anim in ipairs(tbl) do
			if curAnim == anim then
				return anim
			end
		end
	end
	return tbl[math.random(1, #tbl)]
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Maintains and applies the idle animation
		- force = Forcibly apply the idle animation without checking if it's already playing ACT_IDLE
-----------------------------------------------------------]]
function ENT:MaintainIdleAnimation(force)
	-- Animation cycle needs to be set to 0 to make sure engine does NOT attempt to switch sequence multiple times in this code: https://github.com/ValveSoftware/source-sdk-2013/blob/master/src/game/server/ai_basenpc.cpp#L2987
	-- "self:IsSequenceFinished()" should NOT be used as it's broken, it returns "true" even though the animation hasn't finished, especially for non-looped animations
	//bit.band(self:GetSequenceInfo(self:GetSequence()).flags, 1) == 0 -- Checks if animation is none-looping
	//print(self:GetIdealActivity(), self:GetActivity(), self:GetSequenceName(self:GetIdealSequence()), self:GetSequenceName(self:GetSequence()), self:IsSequenceFinished(), self:GetInternalVariable("m_bSequenceLoops"), self:GetCycle())
	if force then
		//VJ.DEBUG_Print(self, "MaintainIdleAnimation", "force")
		local selfData = funcGetTable(self)
		if selfData.LastAnimType != ANIM_TYPE_GESTURE then -- Don't interrupt gestures
			selfData.LastAnimSeed = 0
		end
		funcSetIdealActivity(self, ACT_IDLE) // ResetIdealActivity
		-- Need this check otherwise it may quickly repeat the last animation that was NOT an ACT_IDLE !
		if funcGetIdealActivity(self) == ACT_IDLE && funcGetActivity(self) == ACT_IDLE then
			self:SetCycle(0) -- This is to make sure this destructive code doesn't override it: https://github.com/ValveSoftware/source-sdk-2013/blob/master/src/game/server/ai_basenpc.cpp#L2987
			funcSetSaveValue(self, "m_bSequenceLoops", false) -- Otherwise it will stutter and play an idle sequence at 999x playback speed for 0.001 second when changing from one idle to another!
		end
	elseif funcGetIdealActivity(self) == ACT_IDLE && funcGetActivity(self) == ACT_IDLE then -- Check both ideal and current to make sure we are 100% playing an idle, otherwise transitions, certain movements, and animations will break!
		-- If animation has finished OR idle animation has changed then play a new idle!
		if (funcGetCycle(self) >= 0.98) or (self:TranslateActivity(ACT_IDLE) != funcGetSequenceActivity(self, funcGetIdealSequence(self))) then
			//VJ.DEBUG_Print(self, "MaintainIdleAnimation", "auto")
			local selfData = funcGetTable(self)
			if selfData.LastAnimType != ANIM_TYPE_GESTURE then -- Don't interrupt gestures
				selfData.LastAnimSeed = 0
			end
			funcSetIdealActivity(self, ACT_IDLE) // ResetIdealActivity
			self:SetCycle(0) -- This is to make sure this destructive code doesn't override it: https://github.com/ValveSoftware/source-sdk-2013/blob/master/src/game/server/ai_basenpc.cpp#L2987
			funcSetSaveValue(self, "m_bSequenceLoops", false) -- Otherwise it will stutter and play an idle sequence at 999x playback speed for 0.001 second when changing from one idle to another!
		else
			funcSetSaveValue(self, "m_bSequenceLoops", true) -- "m_bSequenceLoops" has to be true because non-looped animations tend to cut off near the end, usually after the cycle passes 0.8
		end
	end
	
	-- Alternative system: Directly sets the translated activity, but has other downsides such as not being able to detect if the NPC is idling by checking for ACT_IDLE
	//if self.CurrentIdleAnimation != self:GetIdealSequence() or CurTime() > self.NextIdleStandTime then
		//self.CurrentIdleAnimation = self:GetIdealSequence()
		//self.NextIdleStandTime = CurTime() + (self:SequenceDuration(self:GetIdealSequence()) / self:GetPlaybackRate())
		//self:ResetIdealActivity(self:TranslateActivity(ACT_IDLE))
	//end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MaintainIdleBehavior(idleType) -- idleType: nil = Random | 1 = Wander | 2 = Stand
	local curTime = CurTime()
	local selfData = funcGetTable(self)
	if selfData.Dead or selfData.VJ_IsBeingControlled or (selfData.AttackAnimTime > curTime) or (selfData.NextIdleTime > curTime) or selfData.AA_CurrentMovePos or self:GetState() == VJ_STATE_ONLY_ANIMATION_CONSTANT then return end
	
	-- Things that override can't bypass, Forces the NPC to ONLY idle stand!
	if self:IsGoalActive() or selfData.DisableWandering or selfData.IsGuard or selfData.MovementType == VJ_MOVETYPE_STATIONARY or !selfData.LastHiddenZone_CanWander or selfData.NextWanderTime > curTime or selfData.IsFollowing or selfData.MedicData.Status then
		self:SCHEDULE_IDLE_STAND()
		return -- Don't set NextWanderTime below
	end
	
	-- Random (Wander & Stand)
	if !idleType then
		if selfData.IdleAlwaysWander or math.random(1, 3) == 1 then
			self:SCHEDULE_IDLE_WANDER()
		else
			self:SCHEDULE_IDLE_STAND()
		end
	-- Forced: Wander
	elseif idleType == 1 then
		self:SCHEDULE_IDLE_WANDER()
	-- Forced: Stand
	elseif idleType == 2 then
		self:SCHEDULE_IDLE_STAND()
		return -- Don't set NextWanderTime below
	end
	
	selfData.NextWanderTime = curTime + math.Rand(3, 6) // self.NextIdleTime
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	The main animation function, it can play activities, sequences and gestures
		- animation = The animation to play, it can be a table OR string OR ACT_*
			- Adding "vjseq_" to a string will make it play as a sequence
			- Adding "vjges_" to a string will make it play as a gesture
			- If it's a string AND "vjseq_" or "vjges_" is NOT added:
				- The base will attempt to convert it activity, if it fails, it will play it as a sequence
				- This behavior can be overridden by AlwaysUseSequence & AlwaysUseGesture options
		- lockAnim = Should the animation be locked and not interrupted? | Includes activities, behaviors, idle, chasing, attacking, etc. | DEFAULT: false
			- NOTE: This automatically turns off for gestures, it only works for activities and sequences!
			- false = Interruptible by everything!
			- true = Interruptible by nothing, completely locked!
			- "LetAttacks" = Interruptible ONLY by attacks!
		- lockAnimTime = How long should it lock the animation? | DEFAULT: false
			- false = Base calculates the time (recommended)
		- faceEnemy = Should it constantly face the enemy while playing this animation? | DEFAULT: false
			- false = Don't face the enemy
			- true = Constantly face the enemy even behind walls, objects, etc.
			- "Visible" = Only face the enemy while it's visible
		- delay = Delays the animation by the given amount of time | DEFAULT: 0
		- extra = Table that holds extra options to modify parts of the code
			- OnFinish(interrupted, anim) = A function that runs when the animation finishes | DEFAULT: nil
				- interrupted = Was the animation cut off? (Something stopped it before the animation completed)
				- anim = Animation it played, can be a string or an activity enum
			- AlwaysUseSequence = Force attempt to play this animation as a sequence regardless of the other options | DEFAULT: false
			- AlwaysUseGesture = Force attempt to play this animation as a gesture regardless of the other options | DEFAULT: false
				- NOTE: Combining "AlwaysUseSequence" and "AlwaysUseGesture" will force it to play a gesture-sequence
			- PlayBackRate = How fast should the animation play? | DEFAULT: Whatever the current playback rate is
			- PlayBackRateCalculated = If the playback rate is already calculated in the "lockAnimTime", then set this to true! | DEFAULT: false
		- customFunc(schedule, animation) = TODO: NOT FINISHED
	Returns
		- Animation, this may be an activity number or a string depending on how the animation played
			- ACT_INVALID = No animation was played or found
		- Number, Accurate animation play time after taking everything in account
			- WARNING: If "delay" parameter is used, result may be inaccurate!
		- Enum, Type of animation it played, such as activity, sequence, and gesture
			- Enums are VJ.ANIM_TYPE_*
-----------------------------------------------------------]]
local emptyTbl = {}
--
function ENT:PlayAnim(animation, lockAnim, lockAnimTime, faceEnemy, delay, extra, customFunc)
	animation = PICK(animation)
	if !animation then return ACT_INVALID, 0, ANIM_TYPE_NONE end
	
	lockAnim = lockAnim or false
	lockAnimTime = lockAnimTime or false
	faceEnemy = faceEnemy or false
	delay = tonumber(delay) or 0
	extra = extra or emptyTbl
	local isString = isstring(animation)
	local isSequence = false
	local isGesture = false
	local isRecheck = false
	
	::recheck::
	-- Handle tags
	if isString then
		local stripString, stripSequence, stripGesture = VJ.StripAnimTags(animation)
		if !stripString then
			return ACT_INVALID, 0, ANIM_TYPE_NONE
		end
		animation = stripString
		isSequence = stripSequence
		isGesture = stripGesture
		-- If animation is -1 then it's probably an activity, so turn it into a number to be checked later
		-- EX: "vjges_" .. ACT_MELEE_ATTACK1
		if isGesture && !isSequence && self:LookupSequence(animation) == -1 then
			animation = tonumber(animation)
			isString = false
		end
	end
	
	if extra.AlwaysUseGesture then isGesture = true end
	if extra.AlwaysUseSequence then -- Must play as a sequence
		//isGesture = false -- Leave this alone to allow gesture-sequences to play even when "AlwaysUseSequence" is true!
		isSequence = true
		if isnumber(animation) then -- If it's an activity, then convert it to a sequence
			animation = self:GetSequenceName(self:SelectWeightedSequence(animation))
			isString = true
		end
	elseif isString && !isSequence then -- Only for regular & gesture strings
		-- If it can be played as an activity, then convert it!
		local result = funcGetSequenceActivity(self, self:LookupSequence(animation))
		if !result or result == -1 then -- Leave it as string
			isSequence = true
		else -- Set it as an activity
			animation = result
			isString = false
		end
	end
	
	-- Activity translations
	if !isString && !isRecheck then
		local translation = self:TranslateActivity(animation)
		if translation != animation then
			animation = translation
			-- The translation is a string, recheck as it might be a gesture activity
			if isstring(translation) then
				isString = true
				isRecheck = true
				goto recheck
			end
		end
	end
	
	-- Double check if the animation actually exists
	if !VJ.AnimExists(self, animation) then
		return ACT_INVALID, 0, ANIM_TYPE_NONE
	end
	
	local animType = ((isGesture and ANIM_TYPE_GESTURE) or isSequence and ANIM_TYPE_SEQUENCE) or ANIM_TYPE_ACTIVITY -- Find the animation type
	local seed = CurTime() -- Seed the current animation, used for animation delaying & on complete check
	self.LastAnimType = animType
	self.LastAnimSeed = seed
	
	local function PlayAct()
		local originalPlaybackRate = self.AnimPlaybackRate
		local customPlaybackRate = extra.PlayBackRate
		local playbackRate = customPlaybackRate or originalPlaybackRate
		self:SetPlaybackRate(playbackRate) -- Call this to change "self.AnimPlaybackRate" so "VJ.AnimDurationEx" can be calculated correctly
		local animTime = VJ.AnimDurationEx(self, animation, false)
		self.AnimPlaybackRate = originalPlaybackRate -- Change it back to the true rate
		local doRealAnimTime = true -- Only for activities, recalculate the animTime after the schedule starts to get the real sequence time, if `lockAnimTime` is NOT set!
		
		if lockAnim && !isGesture then
			if isbool(lockAnimTime) then -- false = Let the base calculate the time
				lockAnimTime = animTime
			else -- Manually calculated
				doRealAnimTime = false
				if !extra.PlayBackRateCalculated then -- Make sure not to calculate the playback rate when it already has!
					lockAnimTime = lockAnimTime / playbackRate
				end
				animTime = lockAnimTime
			end
			
			local time = CurTime() + lockAnimTime
			self.NextChaseTime = time
			self.NextIdleTime = time
			self.AnimLockTime = time
			
			if lockAnim != "LetAttacks" then
				self:StopAttacks(true)
				self.PauseAttacks = true
				timer.Create("attack_pause_reset" .. self:EntIndex(), lockAnimTime, 1, function() self.PauseAttacks = false end)
			end
		end
		self.LastAnimSeed = seed -- We need to set it again because self:StopAttacks() above will reset it when it calls to chase enemy!
		
		if isGesture then
			-- If it's an activity gesture AND it's already playing it, then remove it! Fixes same activity gestures bugging out when played right after each other!
			if !isSequence && self:IsPlayingGesture(animation) then
				self:RemoveGesture(animation)
				//self:RemoveAllGestures() -- Disallows the ability to layer multiple gestures!
			end
			local gesture = isSequence and self:AddGestureSequence(self:LookupSequence(animation)) or self:AddGesture(animation)
			if gesture != -1 then
				self:SetLayerPriority(gesture, 1) // 2
				//self:SetLayerWeight(gesture, 1)
				self:SetLayerPlaybackRate(gesture, playbackRate * 0.5)
			end
		else -- Sequences & Activities
			local schedule = vj_ai_schedule.New("PlayAnim_" .. animation)
			
			-- For humans NPCs, internally the base will set these variables back to true after this function if it's called by weapon attack animations!
			self.WeaponAttackState = VJ.WEP_ATTACK_STATE_NONE
			
			//self:StartEngineTask(ai.GetTaskID("TASK_RESET_ACTIVITY"), 0) //schedule:EngTask("TASK_RESET_ACTIVITY", 0)
			//if self.Dead then schedule:EngTask("TASK_STOP_MOVING", 0) end
			//self:FrameAdvance(0)
			self:TaskComplete()
			self:StopMoving()
			self:ClearSchedule()
			self:ClearGoal()
			
			if isSequence then
				doRealAnimTime = false -- Sequences already have the correct time
				local seqID = self:LookupSequence(animation)
				--
				-- START: Experimental transition system for sequences
				local transitionAnim = self:FindTransitionSequence(self:GetSequence(), seqID) -- Find the transition sequence
				local transitionAnimTime = 0
				if transitionAnim != -1 && seqID != transitionAnim then -- If it exists AND it's not the same as the animation
					transitionAnimTime = self:SequenceDuration(transitionAnim) / playbackRate
					schedule:AddTask("TASK_VJ_PLAY_SEQUENCE", {
						animation = transitionAnim,
						playbackRate = customPlaybackRate or false,
						duration = transitionAnimTime
					})
				end
				-- END: Experimental transition system for sequences
				--
				schedule:AddTask("TASK_VJ_PLAY_SEQUENCE", {
					animation = animation,
					playbackRate = customPlaybackRate or false,
					duration = animTime
				})
				//self:PlaySequence(animation, playbackRate, extra.SequenceDuration != false, dur)
				animTime = animTime + transitionAnimTime -- Adjust the animation time in case we have a transition animation!
			else -- Activity
				//self:SetActivity(ACT_RESET)
				schedule:AddTask("TASK_VJ_PLAY_ACTIVITY", {
					animation = animation,
					playbackRate = customPlaybackRate or false,
					duration = doRealAnimTime or animTime
				})
				-- Old engine task animation system
				/*if self.MovementType == VJ_MOVETYPE_AERIAL or self.MovementType == VJ_MOVETYPE_AQUATIC then
					self:ResetIdealActivity(animation)
					//schedule:EngTask("TASK_SET_ACTIVITY", animation) -- To avoid AutoMovement stopping the velocity
				//elseif faceEnemy == true then
					//schedule:EngTask("TASK_PLAY_SEQUENCE_FACE_ENEMY", animation)
				else
					-- Engine's default animation task
					-- REQUIRED FOR TASK_PLAY_SEQUENCE: It fixes animations NOT applying walk frames if the previous animation was the same!
					if self:GetActivity() == animation then
						self:ResetSequenceInfo()
						self:SetSaveValue("sequence", 0)
					end
					schedule:EngTask("TASK_PLAY_SEQUENCE", animation)
				end*/
			end
			schedule.IsPlayAnim = true
			schedule.CanBeInterrupted = !lockAnim
			if customFunc then customFunc(schedule, animation) end
			self:StartSchedule(schedule)
			if doRealAnimTime then -- Get the calculated duration (Only done in Activity type)
				animTime = self.CurrentTask.Data.duration
			end
			if faceEnemy then
				self:SetTurnTarget("Enemy", animTime, false, faceEnemy == "Visible")
			end
		end
		
		-- If it has a OnFinish function, then set the timer to run it when it finishes!
		if extra.OnFinish then
			timer.Simple(animTime, function()
				if IsValid(self) && !self.Dead then
					extra.OnFinish(self.LastAnimSeed != seed, animation)
				end
			end)
		end
		return animTime
	end
	
	-- For delay system
	if delay > 0 then
		timer.Simple(delay, function()
			if IsValid(self) && self.LastAnimSeed == seed then
				PlayAct()
			end
		end)
		return animation, delay + VJ.AnimDurationEx(self, animation, false), animType -- Approximation, this may be inaccurate!
	end
	return animation, PlayAct(), animType
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Checks if the NPC is busy with an animation or activity or behavior
		- checkType = Type of busy check should it do | DEFAULT = false (all)
			-- "Behaviors" = Behaviors only such as following a player or moving to heal an ally
			-- "Activities" = Activities only such playing an animation that shouldn't be interrupted OR playing an attack animation!
				--- NAV_JUMP & NAV_CLIMB is based on "IsInterruptable" from engine: https://github.com/ValveSoftware/source-sdk-2013/blob/master/src/game/server/ai_navigator.h#L397
	Returns
		- false, NPC is NOT busy
		- true, NPC is Busy
-----------------------------------------------------------]]
function ENT:IsBusy(checkType)
	local checkAll = !checkType
	local selfData = funcGetTable(self)
	
	-- Behaviors
	if checkAll then
		if selfData.FollowData.Moving or selfData.MedicData.Status then return true end
	elseif checkType == "Behaviors" then
		return selfData.FollowData.Moving or selfData.MedicData.Status
	end
	
	-- Activities
	if checkAll or checkType == "Activities" then
		if selfData.PauseAttacks then return true end
		local curTime = CurTime()
		if selfData.AnimLockTime > curTime or selfData.AttackAnimTime > curTime then return true end
		local navType = self:GetNavType()
		return navType == NAV_JUMP or navType == NAV_CLIMB
	end
	
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Sets the state of the NPC, states are prefixed with VJ_STATE_*
		- state = The state it should set it to | DEFAULT = VJ_STATE_NONE
		- time = How long should the state apply before it's reset to VJ_STATE_NONE?  | DEFAULT = -1
			-1 = State stays indefinitely until reset or changed
-----------------------------------------------------------]]
function ENT:SetState(state, time)
	state = state or VJ_STATE_NONE
	time = time or -1
	self.AIState = state
	if state == VJ_STATE_FREEZE or self:IsEFlagSet(EFL_IS_BEING_LIFTED_BY_BARNACLE) then -- Reset the tasks
		self:TaskComplete()
		self:SCHEDULE_IDLE_STAND()
	end
	if time >= 0 then
		timer.Create("state_reset" .. self:EntIndex(), time, 1, function()
			self:SetState()
		end)
	else
		timer.Remove("state_reset" .. self:EntIndex())
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Returns the current state of the NPC
-----------------------------------------------------------]]
function ENT:GetState()
	return self.AIState
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Decides the pitch for the NPC, very useful for speech-type of sounds!
		- pitchVar = Pitch value to check
	Returns
		- Number, the chosen pitch number
-----------------------------------------------------------]]
function ENT:GetSoundPitch(pitchVar)
	-- false/nil given, use general sound pitch
	if !pitchVar then
		-- It's set to use the same sound pitch all the time, so check if we have it
		local selfData = funcGetTable(self)
		local pickedNum = selfData.MainSoundPitchValue
		if pickedNum != 0 && selfData.MainSoundPitchStatic then
			return pickedNum
		end
		local mainPitch = selfData.MainSoundPitch
		return istable(mainPitch) and math.random(mainPitch.a, mainPitch.b) or mainPitch
	-- Table given (VJ.SET), pick randomly between them
	elseif istable(pitchVar) then
		return math.random(pitchVar.a, pitchVar.b)
	end
	-- Most likely a number, just return it
	return pitchVar
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Decides the attack time
		- mainTime = Main time to base this the timer off of
		- executionTime = Used for timer-based attacks, decreases mainTime
		- animDur = Used when mainTime is set to "false"
			-- NOTE: Assumes playback rate is already calculated for this!
	Returns
		- Number, the decided time
-----------------------------------------------------------]]
function ENT:GetAttackTimer(mainTime, executionTime, animDur)
	-- Let the base decide
	if !mainTime then
		-- Execution was event-based
		if executionTime == false then
			return animDur
		-- Execution was timer-based
		else
			-- If it's 0 or less, then this attack probably did NOT play an animation, discard "animDur"
			if animDur <= 0 then
				return executionTime / self.AnimPlaybackRate
			else
				return animDur - (executionTime / self.AnimPlaybackRate)
			end
		end
	-- Table given, discard "executionTime" and "animDur", then pick randomly
	elseif istable(mainTime) then
		return math.Rand(mainTime.a, mainTime.b) / self.AnimPlaybackRate
	end
	-- Number given, discard "executionTime" and "animDur"
	return mainTime / self.AnimPlaybackRate
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Stops most sounds played by the NPC | Excludes: Death, impact, attack misses, attack impacts
-----------------------------------------------------------]]
function ENT:StopAllSounds()
	local selfData = funcGetTable(self)
	StopSD(selfData.CurrentSpeechSound)
	StopSD(selfData.CurrentExtraSpeechSound)
	StopSD(selfData.CurrentBreathSound)
	StopSD(selfData.CurrentIdleSound)
	StopSD(selfData.CurrentMedicAfterHealSound)
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Quickly patches the given angle to the rotations the NPC is allowed to use (pitch, yaw, roll)
		- ang = The angle to patch
	Returns
		- Angle, the turn angle it should use
-----------------------------------------------------------]]
function ENT:GetTurnAngle(ang)
	return self.TurningUseAllAxis and ang or Angle(0, ang.y, 0)
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Resets the current turn target
-----------------------------------------------------------]]
function ENT:ResetTurnTarget()
	local turnData = self.TurnData
	turnData.Type = VJ.FACE_NONE
	turnData.Target = nil
	turnData.StopOnFace = false
	turnData.IsSchedule = false
	turnData.LastYaw = 0
	timer.Remove("turn_reset" .. self:EntIndex())
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Makes the NPC turn and face the given target
		- target = The turn target | Valid inputs: Entity, Vector, "Enemy"
		- faceTime = How long should it face the given target? | DEFAULT = 0 | -1 : face forever unless overridden, 0 : Only set it for a single frame!
		- stopOnFace = If at any point the NPC ends up facing the target it will complete the facing! | DEFAULT: false
			- This will also be triggered if something else (ex: movements) overrides the ideal yaw!
			- If called on "Enemy" target and there is currently no active enemy, this will be triggered instantly!
		- visibleOnly = Should it only face if the given target is visible? | DEFAULT: false
	Returns
		- Angle, the final angle it's going to face
		- false, turning failed
-----------------------------------------------------------]]
function ENT:SetTurnTarget(target, faceTime, stopOnFace, visibleOnly)
	local selfData = funcGetTable(self)
	if selfData.MovementType == VJ_MOVETYPE_STATIONARY && !selfData.CanTurnWhileStationary then return false end
	local resultAng = false -- The final angle it's going to face
	local updateTurn = true -- An override to disallow applying the angle now
	local turnData = selfData.TurnData
	-- Enemy facing
	if target == "Enemy" then
		//VJ.DEBUG_Print(self, "SetTurnTarget", "ENEMY")
		self:ResetTurnTarget()
		local ene = funcGetEnemy(self)
		-- If enemy is valid do normal facing otherwise return my angles because we didn't actually face an enemy
		if IsValid(ene) then
			if selfData.TurningUseAllAxis then
				resultAng = self:GetTurnAngle(((ene:GetPos() + ene:OBBCenter()) - self:GetPos()):Angle())
			else
				resultAng = self:GetTurnAngle((ene:GetPos() - self:GetPos()):Angle())
			end
		else
			resultAng = self:GetTurnAngle(self:GetAngles())
			updateTurn = false
		end
		if faceTime then -- 0 = Face only this frame, so don't actually set turning data!
			turnData.Type = visibleOnly and VJ.FACE_ENEMY_VISIBLE or VJ.FACE_ENEMY
		end
	-- Vector facing
	elseif isvector(target) then
		//VJ.DEBUG_Print(self, "SetTurnTarget", "VECTOR")
		self:ResetTurnTarget()
		resultAng = self:GetTurnAngle((target - self:GetPos()):Angle())
		if faceTime then -- 0 = Face only this frame, so don't actually set turning data!
			turnData.Type = visibleOnly and VJ.FACE_POSITION_VISIBLE or VJ.FACE_POSITION
			turnData.Target = target
		end
	-- Entity facing
	elseif IsValid(target) then
		//VJ.DEBUG_Print(self, "SetTurnTarget", "ENTITY")
		self:ResetTurnTarget()
		if selfData.TurningUseAllAxis then
			resultAng = self:GetTurnAngle(((target:GetPos() + target:OBBCenter()) - self:GetPos()):Angle())
		else
			resultAng = self:GetTurnAngle((target:GetPos() - self:GetPos()):Angle())
		end
		if faceTime then -- 0 = Face only this frame, so don't actually set turning data!
			turnData.Type = visibleOnly and VJ.FACE_ENTITY_VISIBLE or VJ.FACE_ENTITY
			turnData.Target = target
		end
	end
	if resultAng then
		if updateTurn then
			if selfData.TurningUseAllAxis then
				local myAng = self:GetAngles()
				self:SetAngles(LerpAngle(FrameTime() * self:GetMaxYawSpeed(), myAng, Angle(resultAng.p, myAng.y, resultAng.r)))
			end
			self:SetIdealYawAndUpdate(resultAng.y)
			//if self:IsSequenceFinished() then self:UpdateTurnActivity() end
		else -- Only set it, do NOT update it!
			self:SetIdealYaw(resultAng.y)
		end
		if faceTime then -- 0 = Face only this frame, so don't actually set turning data!
			turnData.StopOnFace = stopOnFace or false
			turnData.LastYaw = resultAng.y
			if faceTime != -1 then -- -1 = Face forever and never reset unless overridden
				timer.Create("turn_reset" .. self:EntIndex(), faceTime, 1, function()
					self:ResetTurnTarget()
				end)
			end
		end
	end
	return resultAng
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DeltaIdealYaw() -- Based on: https://github.com/ValveSoftware/source-sdk-2013/blob/master/sp/src/game/server/ai_motor.cpp#L780
    local flCurrentYaw = (360 / 65536) * (math.floor(self:GetLocalAngles().y * (65536 / 360)) % 65535)
    if flCurrentYaw == self:GetIdealYaw() then
        return 0
    end
    return math_angDif(self:GetIdealYaw(), flCurrentYaw)
end
---------------------------------------------------------------------------------------------------------------------------------------------
local function UTIL_VecToYaw(vec) -- Based on: https://github.com/ValveSoftware/source-sdk-2013/blob/master/src/game/shared/util_shared.cpp#L44
	if vec.y == 0 && vec.x == 0 then return 0 end
	local yaw = math_deg(math_atan2(vec.y, vec.x))
	return yaw < 0 and yaw + 360 or yaw;
end
--
function ENT:OverrideMoveFacing(flInterval, move)
	local selfData = funcGetTable(self)
	if !selfData.DisableFootStepSoundTimer then self:PlayFootstepSound() end
	//VJ.DEBUG_Print(self, "OverrideMoveFacing", flInterval)
	//PrintTable(move)
	
	-- Maintain turning
	local curTurnData = selfData.TurnData
	if curTurnData.Type && curTurnData.LastYaw != 0 then
		self:UpdateYaw() -- Use "UpdateYaw" instead of "SetIdealYawAndUpdate" to avoid pose parameter glitches!
		self:SetPoseParameter("move_yaw", math_angDif(UTIL_VecToYaw(move.dir), self:GetLocalAngles().y))
		-- Need to set the yaw pose parameter, otherwise when face moving, certain directions will look broken (such as Combine soldier facing forward while moving backwards)
		-- Based on: "CAI_Motor::MoveFacing( const AILocalMoveGoal_t &move )" | Link: https://github.com/ValveSoftware/source-sdk-2013/blob/master/src/game/server/ai_motor.cpp#L631
		return true -- Disable engine move facing
	end
	
	-- Handle the unique movement system for player models | Only face move direction if I have NOT faced anything else!
	if selfData.UsePoseParameterMovement && selfData.MovementType == VJ_MOVETYPE_GROUND then
		//self:SetTurnTarget(self:GetCurWaypointPos()) -- Because it will reset the current turning (if any), this will break "firing while moving" turning
		local resultAng = self:GetTurnAngle((self:GetCurWaypointPos() - self:GetPos()):Angle())
		if selfData.TurningUseAllAxis then
			local myAng = self:GetAngles()
			self:SetAngles(LerpAngle(FrameTime() * self:GetMaxYawSpeed(), myAng, Angle(resultAng.p, myAng.y, resultAng.r)))
		end
		self:SetIdealYawAndUpdate(resultAng.y)
		return true -- Disable engine move facing
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OverrideMove(flInterval)
	-- Maintain and handle jumping movements | Handle here instead of "RunAI" to fix landing problems
	-- If (Nav type == NAV_JUMP and Goal type == GOALTYPE_NONE) then we are probably running a custom/forced jump! (non-task based jump)
	if self:GetNavType() == NAV_JUMP && self:GetCurGoalType() == 0 then
		if self:OnGround() then
			if self:MoveJumpStop() == AIMR_CHANGE_TYPE then -- Landed and completed ACT_LAND animation
				self:SetNavType(NAV_GROUND)
			else -- AIMR_OK, still landing or playing ACT_LAND animation
				self:MoveJumpExec()
			end
		else
			self:MoveJumpExec()
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Get the aim position of the given entity for the NPC to aim at | EX: Position the NPC should fire at
		- target = The entity to aim at
		- aimOrigin = The starting point of the aim | EX: Muzzle of a gun the NPC is holding
		- predictionRate = Predication rate | DEFAULT = 0
			-- 0 : No prediction   |   0 < to > 1 : Closer to target   |   1 : Perfect prediction   |   1 < : Ahead of the prediction (will be very ahead/inaccurate)
		- projectileSpeed = Used if prediction is being used, helps it properly calculate the predicted aim position | DEFAULT = 1
	Returns
		- Vector, the best aim position it found | Normalize this return to get the aim direction!
-----------------------------------------------------------]]
function ENT:GetAimPosition(target, aimOrigin, predictionRate, projectileSpeed)
	local result;
	if funcVisible(self, target) then
		result = target:BodyTarget(aimOrigin)
		if target:IsPlayer() then -- Decrease player's Z axis as it's placed very high by the engine
			result.z = result.z - 15
		end
		if !self:VisibleVec(result) then
			result = target:HeadTarget(aimOrigin) or target:EyePos() -- Certain non player/NPC targets will return nil, so just use "EyePos"
		end
	else -- If not visible, use the last known position!
		result = self.EnemyData.VisiblePos
		predictionRate = 0 -- Enemy is not visible, do NOT predict!
	end
	if (predictionRate or 0) > 0 then -- If prediction is enabled
		-- 1. Calculate the distance between the origin and enemy position
		-- 2. Calculate the time it takes for the projectile to reach the enemy
		-- 3. Calculate the predicted enemy position based on their current position and velocity
		result = result + (VJ.GetMoveVelocity(target) * ((aimOrigin - result):Length() / (projectileSpeed or 1))) * predictionRate
	end
	return result
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Calculate the aim spread of the NPC depending on the given factors (Useful for bullets!)
		- target = When given, it will apply more modifiers based on the given entity (Assumes its an enemy!) | DEFAULT: NULL
		- goalPos = Position we are trying to hit
		- modifier = Final spread will be multiplied by this number | DEFAULT = 1 (no change)
	Returns
		- Number, the aim spread
	Calculation
		-- Target distance modifier
		1. Get Distance from NPC to goal position
		2. Multiply it by the max distance at which the bullet spread is at its max
		3. Normalize it between the calculated value and 0.05 where 0 is bullseye and 0.05 is max inaccuracy from distance
		--
		-- Target movement modifier
		4. Get the given target's movement speed (If target exists)
		5. Multiply it by the move speed at which the bullet spread is at its max
		6. Normalize it between the calculated value and 0.05 where 0 is bullseye and 0.05 is max inaccuracy from move speed
		7. Add it to the spread result
		--
		-- Suppression modifier
		8. Get the elapsed time since the NPC was last damaged based on "CurTime"
		9. Divide it by the cooldown time, amount of time until this modifier no longer affects the spread
		10. Normalize it between the calculated value and 1.5 as it should never go above 1.5!
		11. Negate the calculated value and subtract it against 2.5
			-> This will make sure it will return 1 if cooldown is over, otherwise it will cause the final spread result to be 0!
		12. Multiply the spread result by the calculated value
		--
		-- Misc modifiers
		13. Multiply it by the owner's weapon accuracy (Weapon_Accuracy)
		14. Apply the modifier parameter, if any
-----------------------------------------------------------]]
-- To convert division to multiplication do (1 / division_number) | NOTE: Multiplication a bit faster!
local aimMaxDist = 0.0000001 -- Distance at which the bullet spread is at its max (most inaccurate) | Equivalent = Dividing by 10000000
local aimMaxMove = 0.0000001 -- Move speed at which the bullet spread is at its max (most inaccurate) | Equivalent = Dividing by 10000000
local damageCooldown = 4 -- Cooldown time in seconds, amount of time until this modifier no longer affects the spread
--
function ENT:GetAimSpread(target, goalPos, modifier)
	local result = math_min(self:GetPos():DistToSqr(goalPos) * aimMaxDist, 0.05) -- Target distance modifier
	if target then
		result = result + math_min(VJ.GetMoveVelocity(target):LengthSqr() * aimMaxMove, 0.05) -- Target movement modifier
		result = result * (2.5 - math_min((CurTime() - self:GetLastDamageTime()) / damageCooldown, 1.5)) -- Suppression modifier (Inverse effect over time)
	end
	return result * (self.Weapon_Accuracy or 1) * (modifier or 1)
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Performs a group formation
		- formType = Type of formation it should do
			- Types: "Diamond"
		- baseEnt = The entity to base its position on, should be the same for all the members in the group!
		- it = The place of the NPC in the group | DEFAULT = 0
		- spacing = How far apart should they be?  | DEFAULT = 50
-----------------------------------------------------------]]
function ENT:DoGroupFormation(formType, baseEnt, it, spacing)
	it = it or 0
	spacing = spacing or 50
	if formType == "Diamond" then
		if it == 0 then
			self:SetLastPosition(baseEnt:GetPos() + baseEnt:GetForward() * spacing + baseEnt:GetRight() * spacing)
		elseif it == 1 then
			self:SetLastPosition(baseEnt:GetPos() + baseEnt:GetForward() * -spacing + baseEnt:GetRight() * spacing)
		elseif it == 2 then
			self:SetLastPosition(baseEnt:GetPos() + baseEnt:GetForward() * spacing + baseEnt:GetRight() * -spacing)
		elseif it == 3 then
			self:SetLastPosition(baseEnt:GetPos() + baseEnt:GetForward() * -spacing + baseEnt:GetRight() * -spacing)
		else
			self:SetLastPosition(baseEnt:GetPos() + baseEnt:GetForward() * (spacing + (3 * it)) + baseEnt:GetRight() * (spacing + (3 * it)))
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Checks if the front of the NPC can be used to take cover.
		- startPos = Start position of the trace | DEFAULT = Center of the NPC
		- endPos = End position of the trace | DEFAULT = Enemy's eye position
		- acceptWorld = If it hits the world, it will accept it as a cover | DEFAULT = false
		- extra = Table that holds extra options to modify parts of the code
			- SetLastHiddenTime = If true, it will reset the "LastHidden" time, which makes the NPC stick to a position if it's well covered | DEFAULT = false
			- Debug = Used for debugging, spawns a cube at the hit position and prints the trace result | DEFAULT = false
	Returns 2 values
		- 1:
			- true, Hidden
			- false, NOT hidden
		- 2:
			- Table, trace result
-----------------------------------------------------------]]
function ENT:DoCoverTrace(startPos, endPos, acceptWorld, extra)
	local ene = funcGetEnemy(self)
	if !IsValid(ene) then return false, {} end
	startPos = startPos or (self:GetPos() + self:OBBCenter())
	endPos = endPos or ene:EyePos()
	extra = extra or {}
		local setLastHiddenTime = extra.SetLastHiddenTime or false
	local tr = util.TraceLine({
		start = startPos,
		endpos = endPos,
		filter = self,
		mask = MASK_SHOT, // bit.bor(CONTENTS_SOLID, CONTENTS_WINDOW, CONTENTS_BLOCKLOS, CONTENTS_MOVEABLE, CONTENTS_MONSTER)
		collisiongroup = COLLISION_GROUP_NPC -- Otherwise it will collide with debris, ground weapons, etc
	})
	local hitPos = tr.HitPos
	local hitEnt = tr.Entity
	if extra.Debug then
		debugoverlay.Box(startPos, Vector(-2, -2, -2), Vector(2, 2, 2), 1, VJ.COLOR_GREEN)
		debugoverlay.Text(startPos, "DoCoverTrace - startPos", 1)
		debugoverlay.Box(endPos, Vector(-2, -2, -2), Vector(2, 2, 2), 1, VJ.COLOR_RED)
		debugoverlay.Text(endPos, "DoCoverTrace - endPos", 1)
		debugoverlay.Box(hitPos, Vector(-2, -2, -2), Vector(2, 2, 2), 1, VJ.COLOR_YELLOW)
		debugoverlay.Line(startPos, hitPos, 1, VJ.COLOR_YELLOW)
		debugoverlay.Text(hitPos, "DoCoverTrace - tr.HitPos", 1)
	end
	
	-- Hiding zone: It hit world AND it's close, override "acceptWorld" option!
	if tr.HitWorld && startPos:Distance(hitPos) < 200 then
		if setLastHiddenTime then self.LastHiddenZoneT = CurTime() + 20 end
		return true, tr
	end
	
	-- Sometimes tracing isn't 100%, a tiny find in sphere check fixes this issue...
	local sphereInvalidate = false
	for _, v in ipairs(ents.FindInSphere(hitPos, 5)) do
		if v == ene or v.VJ_ID_Living then
			sphereInvalidate = true
			break
		end
	end
	
	-- Not a hiding zone: (Sphere found current enemy or a living entity) OR (World is NOT accepted as a hiding zone) OR (Trace ent is current enemy or a living entity or is moving fast) OR (Trace hit very close to the end position)
	if sphereInvalidate or (!acceptWorld && tr.HitWorld) or (IsValid(hitEnt) && (hitEnt == ene or hitEnt.VJ_ID_Living or hitEnt:GetVelocity():LengthSqr() > 1000)) or endPos:Distance(hitPos) <= 10 then
		if setLastHiddenTime then self.LastHiddenZoneT = 0 end
		return false, tr
	else -- Hidden!
		if setLastHiddenTime then self.LastHiddenZoneT = CurTime() + 20 end
		return true, tr
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Forces the NPC to jump.
		- vel = Velocity for the jump
	EX: Force the NPC to jump to the location of another entity:
		self:ForceMoveJump((activator:GetPos() - self:GetPos()):GetNormal() * 200 + Vector(0, 0, 300))
-----------------------------------------------------------]]
function ENT:ForceMoveJump(vel)
	self:SetNavType(NAV_JUMP)
	self:MoveJumpStart(vel)
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	The last damage hit group that the NPC received.
	Returns
		- number, the hit group
-----------------------------------------------------------]]
function ENT:GetLastDamageHitGroup()
	return self:GetInternalVariable("m_LastHitGroup")
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Time since the NPC has been damaged (Uses CurTime!)
	Returns
		- number, time
-----------------------------------------------------------]]
function ENT:GetLastDamageTime()
	return self:GetInternalVariable("m_flLastDamageTime")
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Number of times NPC has been damaged. Useful for tracking 1-shot kills
	Returns
		- number, the damage count
-----------------------------------------------------------]]
function ENT:GetTotalDamageCount()
	return self:GetInternalVariable("m_iDamageCount")
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Scale the amount of energy used to calculate damage this NPC takes due to physics
		- EXAMPLES: 0 = Take no physics damage | 0.001 = Take extremely minimum damage (manhack level) | 0.1 = Take little damage | 999999999 = Instant death
-----------------------------------------------------------]]
function ENT:SetPhysicsDamageScale(scale)
	funcSetSaveValue(self, "m_impactEnergyScale", scale)
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Takes the given number and returns a scaled number according to the difficulty that NPC is set to
		- num = The number to scale
	Returns
		- number, the scaled number
-----------------------------------------------------------]]
local difficultyScale = {
	[VJ.DIFFICULTY_NEANDERTHAL] = 0.01,
	[VJ.DIFFICULTY_PUNY] = 0.10,
	[VJ.DIFFICULTY_TRIVIAL] = 0.25,
	[VJ.DIFFICULTY_EASY] = 0.50,
	[VJ.DIFFICULTY_BEGINNER] = 0.75,
	[VJ.DIFFICULTY_DIFFICULT] = 1.25,
	[VJ.DIFFICULTY_HARD] = 1.5,
	[VJ.DIFFICULTY_EXPERT] = 1.75,
	[VJ.DIFFICULTY_INSANE] = 2,
	[VJ.DIFFICULTY_IMPOSSIBLE] = 2.5,
	[VJ.DIFFICULTY_LUNATIC] = 3,
	[VJ.DIFFICULTY_NIGHTMARE] = 3.5,
	[VJ.DIFFICULTY_HELL_ON_EARTH] = 4.5,
	[VJ.DIFFICULTY_TOTAL_ANNIHILATION] = 6,
	[VJ.DIFFICULTY_EXTINCTION] = 10,
}
--
function ENT:ScaleByDifficulty(num)
	return math_max(num * (difficultyScale[self.SelectedDifficulty] or 1), 1)
end
---------------------------------------------------------------------------------------------------------------------------------------------
local vecZN100 = Vector(0, 0, -100)
--
function ENT:IsJumpLegal(startPos, apex, endPos)
	local jumpData = self.JumpParams
	if !jumpData.Enabled then return false end
	if ((endPos.z - startPos.z) > jumpData.MaxRise) or ((apex.z - startPos.z) > jumpData.MaxRise) or ((startPos.z - endPos.z) > jumpData.MaxDrop) or (startPos:Distance(endPos) > jumpData.MaxDistance) then
		return false
	end
	
	-- Make sure there is a ground under where it will land!
	local tr = util.TraceLine({start = endPos, endpos = endPos + vecZN100})
	//VJ.DEBUG_TempEnt(startPos, defAng, VJ.COLOR_GREEN)
	//VJ.DEBUG_TempEnt(apex, defAng, Color(255, 115, 0))
	//VJ.DEBUG_TempEnt(endPos, defAng, VJ.COLOR_RED)
	//VJ.DEBUG_TempEnt(tr.HitPos, defAng, Color(132, 0, 255))
	return tr.Hit
end
---------------------------------------------------------------------------------------------------------------------------------------------
//function ENT:OnChangeActivity(newAct)
	//VJ.DEBUG_Print(self, "OnChangeActivity", newAct)
	//if newAct == ACT_TURN_LEFT or newAct == ACT_TURN_RIGHT then
		//self.NextIdleStandTime = CurTime() + VJ.AnimDuration(self, self:GetSequenceName(self:GetSequence()))
	//end
//end
---------------------------------------------------------------------------------------------------------------------------------------------
-- When engine saves or map transitions are loaded
function ENT:OnRestore()
	//VJ.DEBUG_Print(self, "OnRestore")
	self:StopMoving()
	self:ResetMoveCalc()
	-- Reset the current schedule because often times GMod attempts to run it before AI task modules have loaded!
	if self.CurrentSchedule then
		self.CurrentSchedule = nil
		self.CurrentScheduleName = nil
		self.CurrentTask = nil
		self.CurrentTaskID = nil
	end
	-- Readd the weapon think hook because the transition / save does NOT do it!
	local wep = self:GetActiveWeapon()
	if IsValid(wep) then
		hook.Add("Think", wep, wep.NPC_Think)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
-- When GMod saves or duplicator tool are loaded
//function ENT:OnDuplicated(entTable)
	//VJ.DEBUG_Print(self, "OnDuplicated")
//end
---------------------------------------------------------------------------------------------------------------------------------------------
-- When GMod saves or duplicator tool are used to copy this NPC
function ENT:OnEntityCopyTableFinish(data)
	//VJ.DEBUG_Print(self, "OnEntityCopyTableFinish")
	data.CurrentSchedule = nil
	data.CurrentScheduleName = nil
	data.CurrentTask = nil
	data.CurrentTaskID = nil
	data.RelationshipEnts = nil
	data.RelationshipMemory = nil
	data.PoseParameterLooking_Names = nil
	data.NextProcessT = nil
	data.TurnData = nil
	data.GuardData = nil
	data.PauseAttacks = nil
	data.AnimLockTime = nil
	data.AnimPlaybackRate = nil
	data.AnimModelSet = nil
	data.LastAnimSeed = nil
	data.LastAnimType = nil
	data.AttackSeed = nil
	data.AttackType = nil
	data.AttackState = nil
	data.AttackAnim = nil
	data.AttackAnimDuration = nil
	data.AttackAnimTime = nil
	data.NextDoAnyAttackT = nil
	data.IsAbleToMeleeAttack = nil
	data.MeleeAttack_IsPropAttack = nil
	data.NextIdleTime = nil
	data.NextWanderTime = nil
	data.NextChaseTime = nil
	data.EnemyData = nil
	data.Alerted = nil
	data.Flinching = nil
	data.NextFlinchT = nil
	data.HealthRegenDelayT = nil
	data.NextCombineBallDmgT = nil
	data.Dead = nil
	data.GibbedOnDeath = nil
	data.DeathAnimationCodeRan = nil
	data.TakingCoverT = nil
	data.NextOnPlayerSightT = nil
	data.LastHiddenZone_CanWander = nil
	data.LastHiddenZoneT = nil
	data.NextInvestigationMove = nil
	data.NextInvestigateSoundT = nil
	data.NextFootstepSoundT = nil
	data.NextBreathSoundT = nil
	data.NextIdleSoundT = nil
	data.IdleSoundBlockTime = nil
	data.NextAlertSoundT = nil
	data.NextCallForHelpT = nil
	data.NextCallForHelpAnimationT = nil
	data.NextLostEnemySoundT = nil
	data.NextAllyDeathSoundT = nil
	data.NextKilledEnemySoundT = nil
	data.NextDamageAllyResponseT = nil
	data.NextDamageByPlayerSoundT = nil
	data.NextPainSoundT = nil
	data.TimersToRemove = nil
	data.IsInitialized = nil
	
	-- Creature
	data.PropInteraction_Found = nil
	data.PropInteraction_NextCheckT = nil
	data.IsAbleToRangeAttack = nil
	data.IsAbleToLeapAttack = nil
	data.LeapAttackHasJumped = nil
	data.EatingData = nil
	
	-- Human
	data.WeaponInventory = nil
	data.UpdatedPoseParam = nil
	data.Weapon_UnarmedBehavior_Active = nil
	data.WeaponEntity = nil
	data.WeaponState = nil
	data.WeaponInventoryStatus = nil
	data.AllowWeaponOcclusionDelay = nil
	data.WeaponLastShotTime = nil
	data.WeaponAttackState = nil
	data.WeaponAttackAnim = nil
	data.Weapon_AimTurnDiff_Def = nil
	data.NextWeaponAttackT = nil
	data.NextWeaponAttackT_Base = nil
	data.NextWeaponStrafeT = nil
	data.NextMeleeWeaponAttackT = nil
	data.WeaponReloadSeed = nil
	data.NextMoveOnGunCoveredT = nil
	data.NextThrowGrenadeT = nil
	data.NextGrenadeAttackSoundT = nil
	data.NextSuppressingSoundT = nil
	data.NextDangerDetectionT = nil
	data.NextDangerSightSoundT = nil
	data.NextCombatDamageResponseT = nil
	
	-- AA move types
	data.AA_NextMoveAnimTime = nil
	data.AA_CurrentMoveAnim = nil
	data.AA_CurrentMoveAnimType = nil
	data.AA_CurrentMoveMaxSpeed = nil
	data.AA_CurrentMoveTime = nil
	data.AA_CurrentMoveType = nil
	data.AA_CurrentMovePos = nil
	data.AA_CurrentMovePosDir = nil
	data.AA_CurrentMoveDist = nil
	data.AA_LastChasePos = nil
	data.AA_DoingLastChasePos = nil
	
	-- Tank bases
	data.Tank_IsMoving = nil
	data.Tank_Status = nil
	data.Tank_NextLowHealthSpark = nil
	data.Tank_NextRunOver = nil
	data.Tank_NextRunOverSound = nil
	data.Tank_NextIdleParticles = nil
	data.Tank_FacingTarget = nil
	data.Tank_ReachableHeight = nil
	data.Tank_Shell_NextFireT = nil
	data.Tank_Shell_Status = nil
	data.Tank_TurningLerp = nil
	data.Gunner = nil

	-- Following should be saved because:
		-- Duplicator: Useful for duplicating NPCs without needing to set the behavior values individually (Ex: following another entity)
		-- Saves: Usually intended targets will be NULL, and so the respective systems will reset without errors
	//data.MedicData = nil
	//data.IsFollowing = nil
	//data.FollowData = nil
	//data.MainSoundPitchValue = nil
	//data.AnimationTranslations = nil
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:KeyValue(k, v)
	//VJ.DEBUG_Print(self, "KeyValue", k, v)
	if k[1] == "O" && k[2] == "n" then
		self:StoreOutput(k, v)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:AcceptInput(key, activator, caller, data)
	//VJ.DEBUG_Print(self, "AcceptInput", key, activator, caller, data)
	local funcCustom = self.OnInput; if funcCustom then funcCustom(self, key, activator, caller, data) end
	if key == "Use" then
		-- 1. Add a delay so the game registers other key presses
		-- 2. Check for mouse 1, mouse 2, and reload
		timer.Simple(0.1, function()
			if IsValid(self) && self.FollowPlayer && !activator:KeyDown(IN_ATTACK) && !activator:KeyDownLast(IN_ATTACK) && !activator:KeyPressed(IN_ATTACK) && !activator:KeyReleased(IN_ATTACK) && !activator:KeyDown(IN_ATTACK2) && !activator:KeyDownLast(IN_ATTACK2) && !activator:KeyPressed(IN_ATTACK2) && !activator:KeyReleased(IN_ATTACK2) && !activator:KeyDown(IN_RELOAD) && !activator:KeyDownLast(IN_RELOAD) && !activator:KeyPressed(IN_RELOAD) && !activator:KeyReleased(IN_RELOAD) then
				self:Follow(activator, true)
			end
		end)
	elseif key == "StartScripting" then
		self:SetState(VJ_STATE_FREEZE)
	elseif key == "StopScripting" then
		self:SetState(VJ_STATE_NONE)
	elseif key == "break" then
		local dmginfo = DamageInfo()
		dmginfo:SetDamage(self:Health())
		dmginfo:SetDamageType(DMG_ALWAYSGIB)
		dmginfo:SetAttacker(activator)
		dmginfo:SetInflictor(activator)
		self:TakeDamageInfo(dmginfo)
		return true
	//elseif key == "SetHealth" then
		//self:SetHealth(data)
		//self:SetMaxHealth(data)
	end
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HandleAnimEvent(ev, evTime, evCycle, evType, evOptions)
	//VJ.DEBUG_Print(self, "HandleAnimEvent", ev, evTime, evCycle, evType, evOptions)
	local funcCustom = self.OnAnimEvent; if funcCustom then funcCustom(self, ev, evTime, evCycle, evType, evOptions) end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Touch(entity)
	local selfData = funcGetTable(self)
	if selfData.VJ_DEBUG && GetConVar("vj_npc_debug_touch"):GetInt() == 1 then VJ.DEBUG_Print(self, "Touch", funcGetClass(entity)) end
	local funcCustom = self.OnTouch; if funcCustom then funcCustom(self, entity) end
	if !VJ_CVAR_AI_ENABLED or selfData.VJ_IsBeingControlled then return end
	
	-- If it's a passive SNPC...
	if selfData.Behavior == VJ_BEHAVIOR_PASSIVE or selfData.Behavior == VJ_BEHAVIOR_PASSIVE_NATURE then
		if selfData.Passive_RunOnTouch && entity.VJ_ID_Living && CurTime() > selfData.TakingCoverT && entity.Behavior != VJ_BEHAVIOR_PASSIVE && entity.Behavior != VJ_BEHAVIOR_PASSIVE_NATURE && self:CheckRelationship(entity) != D_LI then
			self:SCHEDULE_COVER_ORIGIN("TASK_RUN_PATH")
			self:PlaySoundSystem("Alert")
			selfData.TakingCoverT = CurTime() + math.Rand(3, 4)
			return
		end
	elseif selfData.EnemyTouchDetection && !selfData.IsFollowing && entity.VJ_ID_Living && !IsValid(funcGetEnemy(self)) && self:CheckRelationship(entity) != D_LI && !self:IsBusy() then
		self:StopMoving()
		self:SetTarget(entity)
		self:SCHEDULE_FACE("TASK_FACE_TARGET")
		return
	end
	
	-- Handle "YieldToAlliedPlayers" system
	if selfData.YieldToAlliedPlayers && !selfData.IsGuard then
		-- entity is player
		if entity:IsPlayer() then
			if self:CheckRelationship(entity) == D_LI then
				self:SetCondition(COND_PLAYER_PUSHING)
				if !IsValid(self:GetTarget()) then -- Only set the target if it does NOT have one to not interfere with other behaviors!
					self:SetTarget(entity)
				end
			end
		-- entity is held by a player
		elseif entity:IsPlayerHolding() then
			local findPly = entity:GetOwner()
			if !IsValid(findPly) then -- No owner found, try physics attacker
				findPly = entity:GetPhysicsAttacker()
				if !IsValid(findPly) then -- No physics attacker found, return it
					findPly = false
					return
				end
			end
			-- Player was found, check if we are allied
			if findPly && self:CheckRelationship(findPly) == D_LI then
				self:SetCondition(COND_PLAYER_PUSHING)
				if !IsValid(self:GetTarget()) then -- Only set the target if it does NOT have one to not interfere with other behaviors!
					self:SetTarget(findPly)
				end
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Resets and stops following the current entity (if any)
-----------------------------------------------------------]]
function ENT:ResetFollowBehavior()
	local followData = self.FollowData
	local followEnt = followData.Target
	if IsValid(followEnt) && followEnt:IsPlayer() && self.CanChatMessage then
		if self.Dead then
			followEnt:PrintMessage(HUD_PRINTTALK, VJ.GetName(self) .. " has been killed.")
		else
			followEnt:PrintMessage(HUD_PRINTTALK, VJ.GetName(self) .. " is no longer following you.")
		end
	end
	self.IsFollowing = false
	followData.Target = NULL
	followData.MinDist = 0
	followData.Moving = false
	followData.StopAct = false
	followData.NextUpdateT = 0
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Attempts to follow the given entity
		- ent = Entity to follow
		- doToggle = Should it stop following if it's already following the same entity? | DEFAULT = false
	Returns
		1 = Boolean
			- true, successfully started following the entity
			- false, failed or stopped following the entity
		2 = Failure reason (if it failed)
			0 = Unknown / misc reasons
			1 = NPC is stationary and unable to follow
			2 = NPC is already following another entity
			3 = NPC is hostile or neutral towards ent
-----------------------------------------------------------]]
function ENT:Follow(ent, doToggle)
	if !IsValid(ent) or self.Dead or !VJ_CVAR_AI_ENABLED or self == ent then return false, 0 end
	
	local isPly = ent:IsPlayer()
	local isLiving = ent.VJ_ID_Living
	if (!isLiving) or (ent:Alive() && ((isPly && !VJ_CVAR_IGNOREPLAYERS) or (!isPly))) then
		-- Refusals
		local followData = self.FollowData
		-- Check for enemy/neutral
		if isLiving && funcGetClass(self) != funcGetClass(ent) && (self:Disposition(ent) == D_HT or self:Disposition(ent) == D_NU) then
			if isPly && self.CanChatMessage then
				ent:PrintMessage(HUD_PRINTTALK, VJ.GetName(self) .. " isn't friendly so it won't follow you.")
			end
			return false, 3
		-- Check if it's already following another entity
		elseif self.IsFollowing && ent != followData.Target then
			if isPly && self.CanChatMessage then
				ent:PrintMessage(HUD_PRINTTALK, VJ.GetName(self) .. " is following another entity so it won't follow you.")
			end
			return false, 2
		-- Check for invalid move types
		elseif self.MovementType == VJ_MOVETYPE_STATIONARY or self.MovementType == VJ_MOVETYPE_PHYSICS then
			if isPly && self.CanChatMessage then
				ent:PrintMessage(HUD_PRINTTALK, VJ.GetName(self) .. " is currently stationary so it can't follow you.")
			end
			return false, 1
		end
		
		if !self.IsFollowing then
			if isPly then
				if self.CanChatMessage then
					ent:PrintMessage(HUD_PRINTTALK, VJ.GetName(self) .. " is now following you.")
				end
				self:PlaySoundSystem("FollowPlayer")
				-- Reset the guarding data
				self.GuardData.Position = false
				self.GuardData.Direction = false
			end
			followData.Target = ent
			followData.MinDist = self.FollowMinDistance + self:OBBMaxs().y + ent:OBBMaxs().y
			self.IsFollowing = true
			self:SetTarget(ent)
			if !self:IsBusy("Activities") then -- Face the entity and then move to it
				self:StopMoving()
				self:SCHEDULE_FACE("TASK_FACE_TARGET", function(x)
					x.RunCode_OnFinish = function()
						if IsValid(self.FollowData.Target) then
							self:SCHEDULE_GOTO_TARGET(((self:GetPos():Distance(self.FollowData.Target:GetPos()) < (followData.MinDist * 1.5)) and "TASK_WALK_PATH") or "TASK_RUN_PATH", function(y) y.CanShootWhenMoving = true y.TurnData = {Type = VJ.FACE_ENEMY} end)
						end
					end
				end)
			end
			self:OnFollow("Start", ent)
			return true, 0
		elseif doToggle then -- Unfollow the entity
			if isPly then
				self:PlaySoundSystem("UnFollowPlayer")
			end
			self:StopMoving()
			self.NextWanderTime = CurTime() + 2
			if !self:IsBusy("Activities") then
				self:SCHEDULE_FACE("TASK_FACE_TARGET")
			end
			self:ResetFollowBehavior()
			self:OnFollow("Stop", ent)
		end
	end
	return false, 0
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ResetMedicBehavior()
	self:OnMedicBehavior("OnReset", "End")
	local medicData = self.MedicData
	if IsValid(medicData.Target) then medicData.Target.VJ_ST_Healing = false end
	if IsValid(medicData.Prop) then medicData.Prop:Remove() end
	medicData.Status = false
	medicData.Target = NULL
	medicData.Cooldown = CurTime() + math.Rand(self.Medic_NextHealTime.a, self.Medic_NextHealTime.b)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MaintainMedicBehavior()
	local selfData = funcGetTable(self)
	if selfData.Weapon_UnarmedBehavior_Active then return end -- Do NOT heal if playing scared animations!
	local medicData = selfData.MedicData
	
	-- Not healing anyone, check around for allies
	if !medicData.Status then
		if CurTime() < medicData.Cooldown then return end
		for _, ent in ipairs(ents.FindInSphere(self:GetPos(), selfData.Medic_CheckDistance)) do
			local entData = funcGetTable(ent)
			if ent != self && ((entData.IsVJBaseSNPC && !entData.VJ_ID_Vehicle && !IsValid(funcGetEnemy(self)) && (!IsValid(funcGetEnemy(ent)) or entData.VJ_IsBeingControlled)) or (ent:IsPlayer() && !VJ_CVAR_IGNOREPLAYERS)) && entData.VJ_ID_Healable && !entData.VJ_ST_Healing && ent:Health() <= (ent:GetMaxHealth() * 0.75) && self:CheckRelationship(ent) == D_LI then
				medicData.Target = ent
				medicData.Status = "Active"
				entData.VJ_ST_Healing = true
				self:StopMoving()
				self:MaintainMedicBehavior()
				return
			end
		end
	elseif medicData.Status != "Healing" then
		local ally = medicData.Target
		if !IsValid(ally) or !ally:Alive() or (ally:Health() > ally:GetMaxHealth() * 0.75) or self:CheckRelationship(ally) != D_LI then self:ResetMedicBehavior() return end
		
		-- Heal them!
		if funcVisible(self, ally) && VJ.GetNearestDistance(self, ally) <= selfData.Medic_HealDistance then
			medicData.Status = "Healing"
			self:OnMedicBehavior("BeforeHeal")
			self:PlaySoundSystem("MedicBeforeHeal")
			
			-- Spawn the prop
			if selfData.Medic_SpawnPropOnHeal && self:LookupAttachment(selfData.Medic_SpawnPropOnHealAttachment) != 0 then
				local prop = ents.Create("prop_physics")
				prop:SetModel(selfData.Medic_SpawnPropOnHealModel)
				prop:SetLocalPos(self:GetPos())
				prop:SetOwner(self)
				prop:SetParent(self)
				prop:Fire("SetParentAttachment", selfData.Medic_SpawnPropOnHealAttachment)
				prop:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
				prop:Spawn()
				prop:Activate()
				prop:SetSolid(SOLID_NONE)
				//prop:AddEffects(EF_BONEMERGE)
				prop:SetRenderMode(RENDERMODE_TRANSALPHA)
				self:DeleteOnRemove(prop)
				medicData.Prop = prop
			end
			
			-- Handle the heal time and animation
			local timeUntilHeal = selfData.Medic_TimeUntilHeal
			local anims = selfData.AnimTbl_Medic_GiveHealth
			if anims then
				local _, animTime = self:PlayAnim(anims, true, false)
				if !timeUntilHeal then -- Only change the heal time if "self.Medic_TimeUntilHeal" is set to false!
					timeUntilHeal = animTime
				end
			end
			
			self:SetTurnTarget(ally, timeUntilHeal)
			
			-- Make the ally turn and look at me
			if !ally:IsPlayer() && (ally.MovementType != VJ_MOVETYPE_STATIONARY or (ally.MovementType == VJ_MOVETYPE_STATIONARY && ally.CanTurnWhileStationary)) then
				selfData.NextWanderTime = CurTime() + 2
				selfData.NextChaseTime = CurTime() + 2
				ally:StopMoving()
				ally:SetTarget(self)
				ally:SCHEDULE_FACE("TASK_FACE_TARGET")
			end
			
			timer.Simple(timeUntilHeal, function()
				if IsValid(self) then
					if !IsValid(ally) then -- Ally doesn't exist anymore, reset
						self:ResetMedicBehavior()
					else -- If it exists...
						if self:CheckRelationship(ally) != D_LI then self:ResetMedicBehavior() return end -- I no longer like them, stop healing them!
						if VJ.GetNearestDistance(self, ally) <= (selfData.Medic_HealDistance + 20) then -- Are we still in healing distance?
							if self:OnMedicBehavior("OnHeal", ally) != false then
								local friCurHP = ally:Health()
								ally:SetHealth(math_min(math_max(friCurHP + selfData.Medic_HealAmount, friCurHP), ally:GetMaxHealth()))
								timer.Remove("timer_melee_bleed" .. ally:EntIndex())
								timer.Adjust("timer_melee_slowply" .. ally:EntIndex(), 0)
								ally.VJ_SpeedEffectT = 0
								ally:RemoveAllDecals()
							end
							self:PlaySoundSystem("MedicOnHeal")
							if ally.IsVJBaseSNPC then
								ally:PlaySoundSystem("MedicReceiveHeal")
							end
							self:ResetMedicBehavior()
						else -- If we are no longer in healing distance, go after the ally again
							medicData.Status = "Active"
							if IsValid(medicData.Prop) then medicData.Prop:Remove() end
							self:OnMedicBehavior("OnReset", "Retry")
						end
					end
				end
			end)
		 -- We aren't in healing distance, go after the ally!
		elseif !self:IsBusy("Activities") then
			selfData.NextIdleTime = CurTime() + 4
			selfData.NextChaseTime = CurTime() + 4
			self:SetTarget(ally)
			self:SetMovementActivity(ACT_RUN) -- We run this constantly, set the movement activity constantly in case it never reaches "TASK_RUN_PATH"
			self:SCHEDULE_GOTO_TARGET("TASK_RUN_PATH")
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MaintainConstantlyFaceEnemy()
	local selfData = funcGetTable(self)
	local eneData = selfData.EnemyData
	if eneData.Distance < selfData.ConstantlyFaceEnemy_MinDistance && ((!selfData.ConstantlyFaceEnemy_IfVisible or eneData.Visible) or (!selfData.ConstantlyFaceEnemy_IfAttacking && selfData.AttackType)) then
		local postures = selfData.ConstantlyFaceEnemy_Postures
		if (postures == "Both") or (postures == "Moving" && self:IsMoving()) or (postures == "Standing" && !self:IsMoving()) then
			self:SetTurnTarget("Enemy")
			return true
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local angY45 = Angle(0, 45, 0)
local angYN45 = Angle(0, -45, 0)
local angY90 = Angle(0, 90, 0)
local angYN90 = Angle(0, -90, 0)
--
function ENT:Controller_Movement(cont, ply, bullseyePos)
	if self.MovementType == VJ_MOVETYPE_STATIONARY then return false end
	local aimVector = ply:GetAimVector()
	if ply:KeyDown(IN_FORWARD) then
		if self.MovementType == VJ_MOVETYPE_AERIAL or self.MovementType == VJ_MOVETYPE_AQUATIC then
			self:AA_MoveTo(cont.VJCE_Bullseye, true, ply:KeyDown(IN_SPEED) and "Alert" or "Calm", {IgnoreGround = true})
		else
			if ply:KeyDown(IN_MOVELEFT) then
				cont:StartMovement(aimVector, angY45)
			elseif ply:KeyDown(IN_MOVERIGHT) then
				cont:StartMovement(aimVector, angYN45)
			else
				cont:StartMovement(aimVector, defAng)
			end
		end
	elseif ply:KeyDown(IN_BACK) then
		if ply:KeyDown(IN_MOVELEFT) then
			cont:StartMovement(aimVector * -1, angYN45)
		elseif ply:KeyDown(IN_MOVERIGHT) then
			cont:StartMovement(aimVector * -1, angY45)
		else
			cont:StartMovement(aimVector * -1, defAng)
		end
	elseif ply:KeyDown(IN_MOVELEFT) then
		cont:StartMovement(aimVector, angY90)
	elseif ply:KeyDown(IN_MOVERIGHT) then
		cont:StartMovement(aimVector, angYN90)
	else
		self:StopMoving()
		if self.MovementType == VJ_MOVETYPE_AERIAL or self.MovementType == VJ_MOVETYPE_AQUATIC then
			self:AA_StopMoving()
		end
	end
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PlaySequence(animation)
	if !animation then return false end
	//self.VJ_PlayingSequence = true -- No longer needed as it is handled by ACT_DO_NOT_DISTURB
	self:SetActivity(ACT_DO_NOT_DISTURB) -- So `self:GetActivity()` will return the current result (alongside other immediate calls after `PlaySequence`)
	funcSetIdealActivity(self, ACT_DO_NOT_DISTURB) -- Avoids the engine from progressing to an ideal activity that was set very recently | EX: Fixes melee attack anims breaking when called right after `self:SCHEDULE_IDLE_STAND()`
		-- Keeps MaintainActivity from overriding sequences as seen here: https://github.com/ValveSoftware/source-sdk-2013/blob/master/src/game/server/ai_basenpc.cpp#L6331
		-- If `m_IdealActivity` is set to ACT_DO_NOT_DISTURB, the engine will understand it's a sequence and will avoid messing with it, described here: https://github.com/ValveSoftware/source-sdk-2013/blob/master/src/game/shared/ai_activity.h#L215
	local seqID = isstring(animation) and self:LookupSequence(animation) or animation
	self:ResetSequence(seqID)
	self:ResetSequenceInfo()
	self:SetCycle(0) -- Start from the beginning
	/*if useDuration then -- No longer needed as it is handled by ACT_DO_NOT_DISTURB
		timer.Create("timer_act_seqreset" .. self:EntIndex(), duration, 1, function()
			self.VJ_PlayingSequence = false
			//self.PauseAttacks = false
		end)
	end*/
	return seqID
end
--------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Creates more timers for an attack | Note: it calculates playback rate!
		- name = The name of the timer, ent index is concatenated at the end | DEFAULT: "timer_unknown"
		- time = How long until the timer expires | DEFAULT: 0.5
		- func = The function to run when timer expires
-----------------------------------------------------------]]
function ENT:AddExtraAttackTimer(name, time, func)
	name = name or "timer_unknown"
	self.TimersToRemove[#self.TimersToRemove + 1] = name
	timer.Create(name .. self:EntIndex(), (time or 0.5) / self.AnimPlaybackRate, 1, func)
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Forces the NPC to switch to the given entity as the enemy if certain criteria passes
		- ent = The entity to set as the enemy
		- stopMoving = Should it stop moving? Will not run it already has an enemy! | DEFAULT = false
		- maxPerf = Used in "MaintainRelationships", skips all the initial checks for max performance | DEFAULT = false
		- hasEnemy = Used alongside "maxPerf", determines if it has an enemy or not | DEFAULT = false
-----------------------------------------------------------]]
function ENT:ForceSetEnemy(ent, stopMoving, maxPerf, hasEnemy)
	if !maxPerf then
		if (!IsValid(ent) or self.Behavior == VJ_BEHAVIOR_PASSIVE_NATURE or !ent:Alive() or (ent:IsPlayer() && VJ_CVAR_IGNOREPLAYERS)) then return end
		hasEnemy = IsValid(funcGetEnemy(self))
		funcAddEntityRelationship(self, ent, D_HT, 0)
	end
	self:SetEnemy(ent)
	self:UpdateEnemyMemory(ent, ent:GetPos())
	-- Must be called after "UpdateEnemyMemory"
		-- Let the engine know that our reaction time is instant otherwise it will reset the enemy if it's the first time it has seen this
	self:IgnoreEnemyUntil(ent, 0)
	self:SetNPCState(NPC_STATE_COMBAT)
	self.EnemyData.TimeSet = CurTime()
	if !hasEnemy or self.Alerted != ALERT_STATE_ENEMY then
		if stopMoving && !self.Alerted then
			self:ClearGoal()
			self:StopMoving()
		end
		self:DoEnemyAlert(ent)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
-- Makes the NPC alerted but only as ready, useful when it's alerted by something unknown
function ENT:DoReadyAlert()
	local selfData = funcGetTable(self)
	selfData.EnemyData.Reset = false
	selfData.Alerted = ALERT_STATE_READY
	self:SetNPCState(NPC_STATE_ALERT)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoEnemyAlert(ent)
	//VJ.DEBUG_Print(self, "DoEnemyAlert", ent, funcGetEnemy(self), self.Alerted)
	local selfData = funcGetTable(self)
	local eneData = selfData.EnemyData
	eneData.Distance = self:GetPos():Distance(ent:GetPos())
	if selfData.Alerted == ALERT_STATE_ENEMY then return end
	local curTime = CurTime()
	selfData.Alerted = ALERT_STATE_ENEMY
	-- Fixes the NPC switching from combat to alert to combat after it sees an enemy because `DoEnemyAlert` is called after NPC_STATE_COMBAT is set
	if self:GetNPCState() != NPC_STATE_COMBAT then
		self:SetNPCState(NPC_STATE_ALERT)
	end
	eneData.TimeAcquired = curTime
	eneData.VisibleTime = curTime
	eneData.DistanceNearest = VJ.GetNearestDistance(self, ent, true)
	self:OnAlert(ent)
	if curTime > selfData.NextAlertSoundT then
		self:PlaySoundSystem("Alert")
		selfData.NextAlertSoundT = curTime + math.Rand(selfData.NextSoundTime_Alert.a, selfData.NextSoundTime_Alert.b)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Sets an specific data about the relationship between the NPC and another entity
		- ent = Entity to set the relationship data
		- memoryName = Name of the data (key)
		- memoryValue = Value of the data
-----------------------------------------------------------]]
function ENT:SetRelationshipMemory(ent, memoryName, memoryValue)
	if !IsValid(ent) then return end
	if !self.RelationshipMemory[ent] then self.RelationshipMemory[ent] = {} end
	self.RelationshipMemory[ent][memoryName] = memoryValue
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Checks the relationship towards the given entity and converts custom dispositions such as "D_VJ_INTEREST" to the closest default source engine disposition
		- ent = The entity to check its relation with
	Returns
		- Disposition value, list: https://wiki.facepunch.com/gmod/Enums/D
-----------------------------------------------------------]]
function ENT:CheckRelationship(ent)
	if ent:IsFlagSet(FL_NOTARGET) or !ent:Alive() or (ent:IsPlayer() && VJ_CVAR_IGNOREPLAYERS) then return D_ER end
	if funcGetClass(self) == funcGetClass(ent) then return D_LI end
	local myDisp = self:Disposition(ent)
	if myDisp == D_VJ_INTEREST then return D_HT end
	return myDisp
end
---------------------------------------------------------------------------------------------------------------------------------------------
local cosRad20 = math_cos(math_rad(20))
local ENT_TYPE_OTHER = 0
local ENT_TYPE_NPC = 1
local ENT_TYPE_PLAYER = 2
local ENT_TYPE_NEXTBOT = 3
--
-- Returns: Whether or not it found an enemy
function ENT:MaintainRelationships()
	local selfData = funcGetTable(self)
	local myBehavior = selfData.Behavior
	if myBehavior == VJ_BEHAVIOR_PASSIVE_NATURE then return false end
	local entities = selfData.RelationshipEnts
	if !entities then return false end
	local memories = selfData.RelationshipMemory
	//print("---------------------------------------")
	//VJ.DEBUG_Print(self, "MaintainRelationships")
	//PrintTable(entities)
	//print("----------")
	local myClasses = selfData.VJ_NPC_Class
	local myClassesChanged = false
	if selfData.CacheRelationshipClasses != myClasses then
		myClassesChanged = true
		selfData.CacheRelationshipClasses = myClasses
	end
	
	local eneVisCount = 0
	local myPos = self:GetPos()
	local mySightDist = self:GetMaxLookDistance()
	local myHandlePerceived = self.HandlePerceivedRelationship
	local myCanAlly = selfData.CanAlly
	local myFriPlyAllies = selfData.AlliedWithPlayerAllies
	local notIsNeutral = myBehavior != VJ_BEHAVIOR_NEUTRAL
	local customFunc = self.OnMaintainRelationships
	local nearestDist = false
	local it = 1
	while it <= #entities do //for it = 1, #entities do //for k, ent in ipairs(entities) do
		local ent = entities[it]
		local entMemory = memories[ent]
		if !IsValid(ent) then
			table_remove(entities, it)
			memories[ent] = nil
		else
			it = it + 1
			
			-- Handle no target and dead entities
			if ent:IsFlagSet(FL_NOTARGET) or !ent:Alive() then
				-- If ent is our current enemy then reset it!
				if funcGetEnemy(self) == ent then
					self:ResetEnemy(true, false)
				end
				funcAddEntityRelationship(self, ent, D_NU, 0)
				continue
			end
			
			local entPos = ent:GetPos()
			local distanceToEnt = myPos:Distance(entPos)
			if distanceToEnt > mySightDist then
				-- If ent is our current enemy then reset it!
				if funcGetEnemy(self) == ent then
					self:PlaySoundSystem("LostEnemy")
					self:ResetEnemy(true, false)
				end
				continue
			end
			local calculatedDisp = entMemory[MEM_OVERRIDE_DISPOSITION] or false
			local entType = entMemory[MEM_CACHE_ENT_TYPE]
			
			-- Handle entity type caching
			if !entType then
				if ent:IsNPC() then
					entType = ENT_TYPE_NPC
					self:SetRelationshipMemory(ent, MEM_CACHE_ENT_TYPE, ENT_TYPE_NPC)
				elseif ent:IsPlayer() then
					entType = ENT_TYPE_PLAYER
					self:SetRelationshipMemory(ent, MEM_CACHE_ENT_TYPE, ENT_TYPE_PLAYER)
				elseif ent:IsNextBot() then
					entType = ENT_TYPE_NEXTBOT
					self:SetRelationshipMemory(ent, MEM_CACHE_ENT_TYPE, ENT_TYPE_NEXTBOT)
				else
					entType = ENT_TYPE_OTHER
					self:SetRelationshipMemory(ent, MEM_CACHE_ENT_TYPE, ENT_TYPE_OTHER)
				end
			end
			
			//if entType != ENT_TYPE_PLAYER then
			//	print(ent:GetFOV())
			//	ent:SetSaveValue("m_debugOverlays", bit.bor(0x00000001, 0x00000002, 0x00000004, 0x00000008, 0x00000010, 0x00000020, 0x00000040, 0x00000080, 0x00000100, 0x00000200, 0x00001000, 0x00002000, 0x00004000, 0x00008000, 0x00020000, 0x00040000, 0x00080000, 0x00100000, 0x00200000, 0x00400000, 0x04000000, 0x08000000, 0x10000000, 0x20000000, 0x40000000))
			//end
			
			-- Handle alliances
			if myCanAlly && !calculatedDisp then // ent.VJ_ID_Living
				local entCachedClasses = entMemory[MEM_CACHE_CLASSES]
				local entClasses = ent.VJ_NPC_Class
				-- No cache found or the classes have changed, then recalculate the class disposition!
				if myClassesChanged or entCachedClasses != entClasses then
					-- Handle "self.VJ_NPC_Class"
					for _, friClass in ipairs(myClasses) do
						if entClasses && VJ.HasValue(entClasses, friClass) then
							if entType == ENT_TYPE_PLAYER then
								calculatedDisp = D_LI
							else
								-- If we both have "CLASS_PLAYER_ALLY" then do a special check if we both have "self.AlliedWithPlayerAllies"
								-- If we both do NOT have that, then we both like players but not each other!
								if friClass == "CLASS_PLAYER_ALLY" then
									if myFriPlyAllies && ent.AlliedWithPlayerAllies then
										calculatedDisp = D_LI
									end
								else
									calculatedDisp = D_LI
								end
							end
						end
					end
					
					-- Handle caching
					//VJ.DEBUG_Print(self, false, "not cached", ent, calculatedDisp)
					self:SetRelationshipMemory(ent, MEM_CACHE_CLASSES, entClasses)
					if calculatedDisp then
						self:SetRelationshipMemory(ent, MEM_CACHE_DISPOSITION, calculatedDisp)
					else -- No value set, then clear the cache!
						self:SetRelationshipMemory(ent, MEM_CACHE_DISPOSITION, nil)
					end
				else
					-- Class cache found! Check if we also have a disposition cache
					local entCachedDisposition = entMemory[MEM_CACHE_DISPOSITION]
					if entCachedDisposition then
						calculatedDisp = entCachedDisposition
					end
				end
			end
			
			//print(self:HasEnemyEluded(ent), self:HasEnemyMemory(ent))
			//print(CurTime() - self:GetEnemyLastTimeSeen(ent))
			//print(CurTime() - self:GetEnemyFirstTimeSeen(ent))
			
			local entHandlePerceived = ent.HandlePerceivedRelationship
            if entHandlePerceived then
                -- Return false to let rest of the function run otherwise return a disposition to override
				local result = entHandlePerceived(ent, self, distanceToEnt, calculatedDisp == D_LI)
                if result then
                    funcAddEntityRelationship(self, ent, result, 0)
					calculatedDisp = result
                    //continue
                end
            end
			
			-- If the ent is a friend then set the relation as D_LI
			if calculatedDisp == D_LI then
				//print("MaintainRelationships 2 - friendly!")
				-- Reset the enemy if it's currently this friendly ent
				if funcGetEnemy(self) == ent then
					self:ResetEnemy(true, false)
				end
				
				//ent:AddEntityRelationship(self, D_LI, 0)
				funcAddEntityRelationship(self, ent, D_LI, 0)
				
				-- Handle how non-VJ NPCs feel towards us
				if entType == ENT_TYPE_NPC && !ent.IsVJBaseSNPC then
					-- This is here to make sure non VJ NPCs will respect how entities should feel towards this NPC in case it's overridden
					if myHandlePerceived then
						local result = myHandlePerceived(self, ent, distanceToEnt, true)
						if result then
							ent:AddEntityRelationship(self, result, 0)
						else
							ent:AddEntityRelationship(self, D_LI, 0)
						end
					else
						ent:AddEntityRelationship(self, D_LI, 0)
					end
				end
				
				-- YieldToAlliedPlayers system, Based on:
					-- "CNPC_PlayerCompanion::PredictPlayerPush"	--> https://github.com/ValveSoftware/source-sdk-2013/blob/master/src/game/server/hl2/npc_playercompanion.cpp#L548
					-- "CAI_BaseNPC::TestPlayerPushing"				--> https://github.com/ValveSoftware/source-sdk-2013/blob/master/src/game/server/ai_basenpc.cpp#L12676
				if entType == ENT_TYPE_PLAYER && selfData.YieldToAlliedPlayers && !selfData.IsGuard && ent:GetMoveType() != MOVETYPE_NOCLIP then // && !self:IsBusy("Activities")
					local plyVel = ent:GetInternalVariable("m_vecSmoothedVelocity")
					if plyVel:LengthSqr() >= 19600 then -- 140 * 140 = 19600
						local delta = self:WorldSpaceCenter() - (ent:WorldSpaceCenter() + plyVel * 0.4);
						local myMaxs = self:OBBMaxs()
						local myMins = self:OBBMins()
						local zCalc = (myMaxs.z - myMins.z) * 0.5
						local yCalc = myMaxs.y - myMins.y
						-- (ply not under me) + (ply not very above me) + (ply is close to me)   |   All calculations depend on the NPC's collision size AND player's current speed
						if delta.z < zCalc && (delta.z + zCalc + 150) > zCalc && delta:Length2DSqr() < ((yCalc * yCalc) * 1.999396) then -- 1.414 * 1.414 = 1.999396
							self:SetCondition(COND_PLAYER_PUSHING)
							if !IsValid(self:GetTarget()) then -- Only set the target if it does NOT have one to not interfere with other behaviors!
								self:SetTarget(ent)
							end
						end
					end
				end
			else
				-- Handle how non-VJ NPCs feel towards us
				if entType == ENT_TYPE_NPC && !ent.IsVJBaseSNPC then
					-- This is here to make sure non VJ NPCs will respect how entities should feel towards this NPC in case it's overridden
					if myHandlePerceived then
						local result = myHandlePerceived(self, ent, distanceToEnt, false)
						if result then
							ent:AddEntityRelationship(self, result, 0)
						else
							ent:AddEntityRelationship(self, D_HT, 0)
						end
					else
						ent:AddEntityRelationship(self, D_HT, 0)
					end
				end
				
				local ene = funcGetEnemy(self)
				local eneValid = IsValid(ene)
				if !calculatedDisp or calculatedDisp == D_VJ_INTEREST or calculatedDisp == D_HT then
					-- Check if this NPC should be engaged, if not then set it as an interest but don't engage it
					-- Restriction: If the current enemy is this entity then skip as it we want to engage regardless
					local entCanEngage = ent.CanBeEngaged
					if entCanEngage && !entCanEngage(ent, self, distanceToEnt) && (!eneValid or ene != ent) then
						//print("MaintainRelationships 2 - entCanEngage")
						funcAddEntityRelationship(self, ent, D_VJ_INTEREST, 0)
						calculatedDisp = D_VJ_INTEREST
					else
						-- SetEnemy: In order - Can find enemy + Not neutral or Is alerted + Is visible + In sight cone
						if selfData.EnemyDetection && (notIsNeutral or selfData.Alerted == ALERT_STATE_ENEMY) && (selfData.EnemyXRayDetection or funcVisible(self, ent)) && funcIsInViewCone(self, entPos) then
							//print("MaintainRelationships 2 - set enemy")
							funcAddEntityRelationship(self, ent, D_HT, 0)
							calculatedDisp = D_HT
							eneValid = true
							eneVisCount = eneVisCount + 1
							-- If the detected enemy is closer than the previous enemies, the set this as the enemy!
							if !nearestDist or (distanceToEnt < nearestDist) then
								nearestDist = distanceToEnt
								self:ForceSetEnemy(ent, true, true, eneValid)
							end
						-- If all else failed then check if we hate this entity
						elseif self:Disposition(ent) != D_HT then
							-- Neutral NPCs will not engage enemies without a reason, so keep it as neutral
							if !notIsNeutral then
								//print("MaintainRelationships 2 - regular D_NU")
								funcAddEntityRelationship(self, ent, D_NU, 0)
								calculatedDisp = D_NU
							-- Everyone else will set potential enemies as interest
							else
								//print("MaintainRelationships 2 - regular D_VJ_INTEREST")
								funcAddEntityRelationship(self, ent, D_VJ_INTEREST, 0)
								calculatedDisp = D_VJ_INTEREST
							end
						end
					end
				else
					calculatedDisp = D_NU
				end
				
				-- Investigation detection: Sound and player flashlight systems
				if !eneValid && selfData.CanInvestigate && selfData.NextInvestigationMove < CurTime() then
					-- Investigation: Sound detection
					if ent.VJ_SD_InvestLevel && distanceToEnt < (selfData.InvestigateSoundMultiplier * ent.VJ_SD_InvestLevel) && ((CurTime() - ent.VJ_SD_InvestTime) <= 1) then
						self:DoReadyAlert()
						if funcVisible(self, ent) then
							self:StopMoving()
							self:SetTarget(ent)
							self:SCHEDULE_FACE("TASK_FACE_TARGET")
							selfData.NextInvestigationMove = CurTime() + 0.3 -- Short delay, since it's only turning
						elseif !selfData.IsFollowing then
							self:SetLastPosition(entPos)
							self:SCHEDULE_GOTO_POSITION("TASK_WALK_PATH", function(schedule)
								//if eneValid then schedule:EngTask("TASK_FORGET", ene) end
								//schedule:EngTask("TASK_IGNORE_OLD_ENEMIES", 0)
								schedule.CanShootWhenMoving = true
								//schedule.CanBeInterrupted = true
								schedule.TurnData = {Type = VJ.FACE_ENEMY}
							end)
							selfData.NextInvestigationMove = CurTime() + 2 -- Long delay, so it doesn't spam movement
						end
						self:OnInvestigate(ent)
						self:PlaySoundSystem("Investigate")
					-- Investigation: Player shining flashlight onto the NPC
					elseif entType == ENT_TYPE_PLAYER && distanceToEnt < 350 && ent:FlashlightIsOn() && (ent:GetForward():Dot((myPos - entPos):GetNormalized()) > cosRad20) then
						self:StopMoving()
						self:SetTarget(ent)
						self:SCHEDULE_FACE("TASK_FACE_TARGET")
						selfData.NextInvestigationMove = CurTime() + 0.1 -- Short delay, since it's only turning
					end
				end
			end
			
			-- HasOnPlayerSight system, used to do certain actions when it sees the player
			if entType == ENT_TYPE_PLAYER && selfData.HasOnPlayerSight && CurTime() > selfData.NextOnPlayerSightT && distanceToEnt < selfData.OnPlayerSightDistance && funcVisible(self, ent) && funcIsInViewCone(self, entPos) then
				-- 0 = Run it every time | 1 = Run it only when friendly to player | 2 = Run it only when enemy to player
				local disp = selfData.OnPlayerSightDispositionLevel
				if (disp == 0) or (disp == 1 && (self:Disposition(ent) == D_LI or self:Disposition(ent) == D_NU)) or (disp == 2 && self:Disposition(ent) != D_LI) then
					self:OnPlayerSight(ent)
					self:PlaySoundSystem("OnPlayerSight")
					if selfData.OnPlayerSightOnlyOnce then -- If it's only suppose to play it once then turn the system off
						selfData.HasOnPlayerSight = false
					else
						selfData.NextOnPlayerSightT = CurTime() + math.Rand(selfData.OnPlayerSightNextTime.a, selfData.OnPlayerSightNextTime.b)
					end
				end
			end
			
			if customFunc then customFunc(self, ent, calculatedDisp, distanceToEnt) end
		end
	end
	selfData.EnemyData.VisibleCount = eneVisCount
	//print("---------------------------------------")
	return eneVisCount > 0
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Checks allies around the NPC and call them to come to help the NPC
		- dist = Radius of the call | DEFAULT: 800
-----------------------------------------------------------]]
function ENT:Allies_CallHelp(dist)
	local selfData = funcGetTable(self)
	local ene = funcGetEnemy(self)
	local myClass = funcGetClass(self)
	local myPos = metaEntity.GetPos(self)
	local curTime = CurTime()
	local isFirst = true -- Is this the first ent that received a call?
	for _, ent in ipairs(ents.FindInSphere(myPos, dist or 800)) do
		local entData = funcGetTable(ent)
		if ent != self && entData.IsVJBaseSNPC && entData.CanReceiveOrders && metaEntity.Alive(ent) && (funcGetClass(ent) == myClass or metaNPC.Disposition(ent, self) == D_LI) && entData.Behavior != VJ_BEHAVIOR_PASSIVE_NATURE && funcGetClass(ene) != funcGetClass(ent) && !IsValid(funcGetEnemy(ent)) then
			-- If it's guarding and enemy is not visible, then don't call!
			if entData.IsGuard && !funcVisible(ent, ene) then continue end
			local eneIsPlayer = ene:IsPlayer()
			if ((!eneIsPlayer && metaNPC.Disposition(ent, ene) != D_LI) or eneIsPlayer) then
				-- Enemy too far away for ent
				local entsPos = metaEntity.GetPos(ent)
				if entsPos:Distance(metaEntity.GetPos(ene)) > metaNPC.GetMaxLookDistance(ent) then
					-- See if you can move to the ent's location to get closer
					if !entData.IsFollowing && !entData.IsBusy(ent) then
						-- If it's wandering, then just override it as it's not important
						if metaNPC.IsMoving(ent) && selfData.CurrentScheduleName != "SCHEDULE_IDLE_WANDER" then
							continue
						end
						metaNPC.SetLastPosition(ent, myPos + self:GetRight() * math.random(-50, 50) + self:GetForward() * math.random(-50, 50))
						entData.SCHEDULE_GOTO_POSITION(ent, "TASK_RUN_PATH", function(x) x.CanShootWhenMoving = true x.TurnData = {Type = VJ.FACE_ENEMY} end)
					else
						continue
					end
				else
					-- If the enemy is a player and the ent is player-friendly then make that player an enemy to the ent
					if eneIsPlayer && metaNPC.Disposition(ent, ene) == D_LI then
						entData.SetRelationshipMemory(ent, ene, VJ.MEM_OVERRIDE_DISPOSITION, D_HT)
					end
					entData.ForceSetEnemy(ent, ene, true)
					if curTime > entData.NextChaseTime then
						if entData.Behavior != VJ_BEHAVIOR_PASSIVE && funcVisible(ent, ene) then
							metaNPC.SetTarget(ent, ene)
							entData.SCHEDULE_FACE(ent, "TASK_FACE_TARGET")
						else
							entData.PlaySoundSystem(ent, "ReceiveOrder")
							entData.MaintainAlertBehavior(ent)
						end
					end
				end
				
				selfData.OnCallForHelp(self, ent, isFirst)
				selfData.PlaySoundSystem(self, "CallForHelp")
				-- Play the animation
				if curTime > selfData.AnimLockTime && curTime > selfData.NextCallForHelpAnimationT then
					local anims = selfData.AnimTbl_CallForHelp
					if anims then
						selfData.PlayAnim(self, anims, true, false, selfData.CallForHelpAnimFaceEnemy)
						selfData.NextCallForHelpAnimationT = curTime + selfData.CallForHelpAnimCooldown
					end
				end
				isFirst = false
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Checks allies around the NPC that can receive orders and return all of them as a table
		- dist = How far to check for allies | DEFAULT: 800
	Returns
		- false, Failed to find any allies
		- Table, table of allies it found
-----------------------------------------------------------]]
function ENT:Allies_Check(dist)
	local allies = {}
	local alliesNum = 0
	local isPassive = self.Behavior == VJ_BEHAVIOR_PASSIVE or self.Behavior == VJ_BEHAVIOR_PASSIVE_NATURE
	local myClass = funcGetClass(self)
	for _, ent in ipairs(ents.FindInSphere(self:GetPos(), dist or 800)) do
		local entData = funcGetTable(ent)
		if ent != self && entData.IsVJBaseSNPC && entData.CanReceiveOrders && entData.IsInitialized && ent:Alive() && (funcGetClass(ent) == myClass or (ent:Disposition(self) == D_LI or entData.Behavior == VJ_BEHAVIOR_PASSIVE_NATURE)) then
			if isPassive then
				if entData.Behavior == VJ_BEHAVIOR_PASSIVE or entData.Behavior == VJ_BEHAVIOR_PASSIVE_NATURE then
					alliesNum = alliesNum + 1
					allies[alliesNum] = ent
				end
			else
				alliesNum = alliesNum + 1
				allies[alliesNum] = ent
			end
		end
	end
	return alliesNum > 0 and allies or false
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Checks allies around the NPC and brings them to the NPC if they can receive orders
		- formType = Type of formation the allies should do | DEFAULT: "Random"
			- Types: "Random" | "Diamond"
		- dist = How far to check for allies | DEFAULT: 800
		- entsTbl = Pass in a table of entities to use, otherwise it will run a sphere check | DEFAULT: Sphere check
		- limit = How many allies can it bring? | DEFAULT: 3
			- 0 = Unlimited
		- onlyVis = Should it only allow allies that are visible? | DEFAULT: false
	Returns
		- false, Failed to find any allies
		- true, Found at least 1 ally
-----------------------------------------------------------]]
function ENT:Allies_Bring(formType, dist, entsTbl, limit, onlyVis)
	local myPos = self:GetPos()
	formType = formType or "Random"
	dist = dist or 800
	limit = limit or 3
	local myClass = funcGetClass(self)
	local it = 0
	local curTime = CurTime()
	for _, ent in ipairs(entsTbl or ents.FindInSphere(myPos, dist)) do
		local entData = funcGetTable(ent)
		if ent != self && entData.IsVJBaseSNPC && entData.CanReceiveOrders && ent:Alive() && (funcGetClass(ent) == myClass or ent:Disposition(self) == D_LI) && entData.Behavior != VJ_BEHAVIOR_PASSIVE && entData.Behavior != VJ_BEHAVIOR_PASSIVE_NATURE && !entData.IsFollowing && !entData.IsGuard && curTime > entData.TakingCoverT then
			if onlyVis && !funcVisible(ent, self) then continue end
			if !IsValid(funcGetEnemy(ent)) && myPos:Distance(ent:GetPos()) < dist then
				self.NextWanderTime = curTime + 8
				entData.NextWanderTime = curTime + 8
				it = it + 1
				-- Formation
				if formType == "Random" then
					local randPos = math.random(1, 4)
					if randPos == 1 then
						ent:SetLastPosition(myPos + self:GetRight() * math.random(20, 50))
					elseif randPos == 2 then
						ent:SetLastPosition(myPos + self:GetRight() * math.random(-50, -20))
					elseif randPos == 3 then
						ent:SetLastPosition(myPos + self:GetForward() * math.random(20, 50))
					elseif randPos == 4 then
						ent:SetLastPosition(myPos + self:GetForward() * math.random(-50, -20))
					end
				elseif formType == "Diamond" then
					ent:DoGroupFormation("Diamond", self, it)
				end
				-- Move type
				if entData.IsVJBaseSNPC_Human && !IsValid(ent:GetActiveWeapon()) then
					ent:SCHEDULE_COVER_ORIGIN("TASK_RUN_PATH", function(x) x.CanBeInterrupted = true end)
				else
					ent:SCHEDULE_GOTO_POSITION("TASK_WALK_PATH", function(x) x.CanShootWhenMoving = true x.TurnData = {Type = VJ.FACE_ENEMY} end)
				end
			end
			if limit != 0 && it >= limit then return true end -- Reached the limit
		end
	end
	return it > 0
end
---------------------------------------------------------------------------------------------------------------------------------------------
local function flinchDamageTypeCheck(checkTbl, dmgType)
	for k = 1, #checkTbl do
		if bAND(dmgType, checkTbl[k]) != 0 then
			return true
		end
	end
end
--
function ENT:Flinch(dmginfo, hitgroup)
	local curTime = CurTime()
	local selfData = funcGetTable(self)
	local flinchType = selfData.CanFlinch
	if !flinchType or flinchType == 0 or selfData.Flinching or selfData.AnimLockTime > curTime or selfData.NextFlinchT > curTime or self:GetNavType() == NAV_JUMP or self:GetNavType() == NAV_CLIMB or selfData.AttackType == VJ.ATTACK_TYPE_GRENADE then return end
	
	-- DMG_FORCE_FLINCH: Skip secondary checks, flinch chance, and damage types!
	local customDmgType = dmginfo:GetDamageCustom()
	if customDmgType == VJ.DMG_FORCE_FLINCH or (customDmgType != VJ.DMG_BLEED && selfData.TakingCoverT < curTime && math.random(1, selfData.FlinchChance) == 1 && (flinchType == true or flinchType == 1 or ((flinchType == "DamageTypes" or flinchType == 2) && flinchDamageTypeCheck(selfData.FlinchDamageTypes, dmginfo:GetDamageType())))) then
		if self:OnFlinch(dmginfo, hitgroup, "Init") then return end
		
		local function executeFlinch(hitgroupAnim)
			selfData.Flinching = true
			self:StopAttacks(true)
			selfData.AttackAnimTime = 0
			local _, animDur = self:PlayAnim(hitgroupAnim or selfData.AnimTbl_Flinch, true, false, false)
			timer.Create("flinch_reset" .. self:EntIndex(), animDur, 1, function() self.Flinching = false end)
			self:OnFlinch(dmginfo, hitgroup, "Execute")
			selfData.NextFlinchT = curTime + (!selfData.FlinchCooldown and animDur or selfData.FlinchCooldown)
		end
		
		local hitgroupTbl = selfData.FlinchHitGroupMap
		-- Hitgroup flinching
		if hitgroupTbl then
			for _, v in ipairs(hitgroupTbl) do
				local hitGroups = v.HitGroup
				if istable(hitGroups) then -- Sub-table hitgroup
					for hitgroupX = 1, #hitGroups do
						if hitGroups[hitgroupX] == hitgroup then
							executeFlinch(v.Animation)
							return
						end
					end
				else -- non-table hitgroup
					if hitGroups == hitgroup then
						executeFlinch(v.Animation)
						return
					end
				end
			end
			if selfData.FlinchHitGroupPlayDefault then
				executeFlinch()
			end
		-- Non-hitgroup flinching
		else
			executeFlinch()
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Sets the NPC's blood color (particle, decal, blood pool)
		- blColor = The blood color to set it to | Must be a string, check the list below
-----------------------------------------------------------]]
local bloodNames = {
	[VJ.BLOOD_COLOR_RED] = {
		particle = "blood_impact_red_01", // vj_blood_impact_red
		decal = "VJ_Blood_Red",
		decal_gmod = "Blood",
		pool = {
			[0] = "vj_blood_pool_red_tiny",
			[1] = "vj_blood_pool_red_small",
			[2] = "vj_blood_pool_red"
		}
	},
	[VJ.BLOOD_COLOR_YELLOW] = {
		particle = "blood_impact_yellow_01", // vj_blood_impact_yellow
		decal = "VJ_Blood_Yellow",
		decal_gmod = "YellowBlood",
		pool = {
			[0] = "vj_blood_pool_yellow_tiny",
			[1] = "vj_blood_pool_yellow_small",
			[2] = "vj_blood_pool_yellow"
		}
	},
	[VJ.BLOOD_COLOR_GREEN] = {
		particle = "vj_blood_impact_green",
		decal = "VJ_Blood_Green",
		pool = {
			[0] = "vj_blood_pool_green_tiny",
			[1] = "vj_blood_pool_green_small",
			[2] = "vj_blood_pool_green"
		}
	},
	[VJ.BLOOD_COLOR_ORANGE] = {
		particle = "vj_blood_impact_orange",
		decal = "VJ_Blood_Orange",
		pool = {
			[0] = "vj_blood_pool_orange_tiny",
			[1] = "vj_blood_pool_orange_small",
			[2] = "vj_blood_pool_orange"
		}
	},
	[VJ.BLOOD_COLOR_BLUE] = {
		particle = "vj_blood_impact_blue",
		decal = "VJ_Blood_Blue",
		pool = {
			[0] = "vj_blood_pool_blue_tiny",
			[1] = "vj_blood_pool_blue_small",
			[2] = "vj_blood_pool_blue"
		}
	},
	[VJ.BLOOD_COLOR_PURPLE] = {
		particle = "vj_blood_impact_purple",
		decal = "VJ_Blood_Purple",
		pool = {
			[0] = "vj_blood_pool_purple_tiny",
			[1] = "vj_blood_pool_purple_small",
			[2] = "vj_blood_pool_purple"
		}
	},
	[VJ.BLOOD_COLOR_WHITE] = {
		particle = "vj_blood_impact_white",
		decal = "VJ_Blood_White",
		pool = {
			[0] = "vj_blood_pool_white_tiny",
			[1] = "vj_blood_pool_white_small",
			[2] = "vj_blood_pool_white"
		}
	},
	[VJ.BLOOD_COLOR_OIL] = {
		particle = "vj_blood_impact_oil",
		decal = "VJ_Blood_Oil",
		pool = {
			[0] = "vj_blood_pool_oil_tiny",
			[1] = "vj_blood_pool_oil_small",
			[2] = "vj_blood_pool_oil"
		}
	},
}
--
function ENT:SetupBloodColor(blColor)
	if !isstring(blColor) then return end -- Only strings allowed!
	local npcSize = self:OBBMaxs():Distance(self:OBBMins())
	npcSize = ((npcSize < 25 and 0) or npcSize < 50 and 1) or 2 -- 0 = tiny | 1 = small | 2 = normal
	local blood = bloodNames[blColor]
	if blood then
		local selfData = funcGetTable(self)
		if !PICK(selfData.BloodParticle) then
			selfData.BloodParticle = blood.particle
		end
		if !PICK(selfData.BloodDecal) then
			selfData.BloodDecal = vj_npc_blood_gmod:GetInt() == 1 and blood.decal_gmod or blood.decal
		end
		if !PICK(selfData.BloodPool) then
			selfData.BloodPool = blood.pool[npcSize]
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SpawnBloodParticles(dmginfo, hitgroup)
	local particleName = PICK(self.BloodParticle)
	if !particleName then return end
	local dmgPos = dmginfo:GetDamagePosition()
	local particle = ents.Create("info_particle_system")
	particle:SetKeyValue("effect_name", particleName)
	particle:SetPos((dmgPos == defPos and (self:GetPos() + self:OBBCenter())) or dmgPos)
	particle:Spawn()
	particle:Activate()
	particle:Fire("Start")
	particle:Fire("Kill", nil, 0.1)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SpawnBloodDecals(dmginfo, hitgroup)
	local decals = self.BloodDecal
	local mainDecal = PICK(decals)
	if !mainDecal then return end
	
	local dmgForce = dmginfo:GetDamageForce()
	local dmgPos = dmginfo:GetDamagePosition()
	if dmgPos == defPos then dmgPos = self:GetPos() + self:OBBCenter() end
	local clampedLength = math_min(math_max(dmgForce:Length() * 10, 100), self.BloodDecalDistance)
	
	-- Badi ayroun
	local tr = util.TraceLine({start = dmgPos, endpos = dmgPos + dmgForce:GetNormal() * clampedLength, filter = self})
	local trNormalP = tr.HitPos + tr.HitNormal
	local trNormalN = tr.HitPos - tr.HitNormal
	util.Decal(mainDecal, trNormalP, trNormalN, self)
	for _ = 1, 2 do
		if math.random(1, 2) == 1 then
			util.Decal(PICK(decals), Vector(trNormalP.x + math.random(-70, 70), trNormalP.y + math.random(-70, 70), trNormalP.z), trNormalN, self)
		end
	end
	
	-- Kedni ayroun
	if math.random(1, 2) == 1 then
		local secEndPos = Vector(dmgPos.x, dmgPos.y, dmgPos.z - clampedLength)
		util.Decal(PICK(decals), dmgPos, secEndPos, self)
		if math.random(1, 2) == 1 then
			util.Decal(PICK(decals), dmgPos, Vector(secEndPos.x + math.random(-120, 120), secEndPos.y + math.random(-120, 120), secEndPos.z), self)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local vecZ30 = Vector(0, 0, 30)
local vecZ1 = Vector(0, 0, 1)
--
function ENT:SpawnBloodPool(dmginfo, hitgroup, corpse)
	local particleName = PICK(self.BloodPool)
	if !particleName then return end
	timer.Simple(2.2, function()
		if IsValid(corpse) then
			local pos = corpse:GetPos() + corpse:OBBCenter()
			local tr = util.TraceLine({
				start = pos,
				endpos = pos - vecZ30,
				filter = corpse,
				mask = CONTENTS_SOLID
			})
			if tr.HitWorld && tr.HitNormal == vecZ1 then // tr.Fraction <= 0.405
				ParticleEffect(particleName, tr.HitPos, defAng, nil)
			end
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PlayFootstepSound(customSD)
	local selfData = funcGetTable(self)
	if !selfData.HasSounds or !selfData.HasFootstepSounds or selfData.MovementType == VJ_MOVETYPE_STATIONARY or !self:IsOnGround() then return end
	local footstepType = false
	if selfData.DisableFootStepSoundTimer then
		footstepType = "Event"
	elseif self:IsMoving() && CurTime() > selfData.NextFootstepSoundT && self:GetMoveDelay() <= 0 then
		local movementAct = self:GetMovementActivity()
		if movementAct == ACT_RUN then
			footstepType = "Run"
			selfData.NextFootstepSoundT = CurTime() + selfData.FootstepSoundTimerRun
		elseif movementAct == ACT_WALK then
			footstepType = "Walk"
			selfData.NextFootstepSoundT = CurTime() + selfData.FootstepSoundTimerWalk
		end
	end
	if footstepType then
		local pickedSD = customSD and PICK(customSD) or PICK(selfData.SoundTbl_FootStep)
		if pickedSD then
			VJ.EmitSound(self, pickedSD, selfData.FootstepSoundLevel, self:GetSoundPitch(selfData.FootstepSoundPitch))
			local funcCustom = self.OnFootstepSound; if funcCustom then funcCustom(self, footstepType, pickedSD) end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
-- combatIdle = Play combat idle if possible
function ENT:PlayIdleSound(combatIdle)
	local selfData = funcGetTable(self)
	if !selfData.HasSounds or !selfData.HasIdleSounds then return end
	local curTime = CurTime()
	if selfData.IdleSoundBlockTime > curTime or selfData.NextIdleSoundT > curTime then return end
	
	combatIdle = combatIdle and PICK(selfData.SoundTbl_CombatIdle)
	if combatIdle then
		if combatIdle && math.random(1, selfData.CombatIdleSoundChance) == 1 then
			StopSD(selfData.CurrentIdleSound)
			selfData.CurrentIdleSound = VJ.CreateSound(self, combatIdle, selfData.CombatIdleSoundLevel, self:GetSoundPitch(selfData.CombatIdleSoundPitch))
		end
	elseif math.random(1, selfData.IdleSoundChance) == 1 then
		local playRegular = true
		local pickedSD = PICK(selfData.SoundTbl_IdleDialogue)
		if pickedSD && selfData.HasIdleDialogueSounds && math.random(1, 2) == 1 then
			local foundEnt;
			local canAnswer = false
			-- Don't break the loop unless we hit a VJ NPC that can answer back otherwise just return a living entity that is friendly
			for _, ent in ipairs(ents.FindInSphere(self:GetPos(), selfData.IdleDialogueDistance)) do
				local entData = funcGetTable(ent)
				if ent != self && entData.VJ_ID_Living && self:CheckRelationship(ent) == D_LI && funcVisible(self, ent) then
					if entData.IsVJBaseSNPC then
						local hasDialogueAnswer = PICK(entData.SoundTbl_IdleDialogueAnswer)
						if !self:OnIdleDialogue(ent, "CheckEnt", hasDialogueAnswer) then
							foundEnt = ent
							if hasDialogueAnswer && !entData.VJ_IsBeingControlled then
								canAnswer = true
								break
							end
						end
					elseif !self:OnIdleDialogue(ent, "CheckEnt", false) then
						foundEnt = ent
					end
				end
			end
			if foundEnt then
				playRegular = false
				StopSD(selfData.CurrentIdleSound)
				selfData.CurrentIdleSound = VJ.CreateSound(self, pickedSD, selfData.IdleDialogueSoundLevel, self:GetSoundPitch(selfData.IdleDialogueSoundPitch))
				if canAnswer then -- If we have a VJ NPC that can answer
					local dur = SoundDuration(pickedSD)
					if dur == 0 then dur = 3 end -- For non-WAV sound files
					local talkTime = curTime + (dur + 0.5)
					selfData.NextIdleSoundT = talkTime
					selfData.NextWanderTime = talkTime
					foundEnt.NextIdleSoundT = talkTime
					foundEnt.NextWanderTime = talkTime
					self:OnIdleDialogue(foundEnt, "Speak", talkTime)
					
					-- Stop moving and face each other
					if selfData.IdleDialogueCanTurn then
						self:StopMoving()
						self:SetTarget(foundEnt)
						self:SCHEDULE_FACE("TASK_FACE_TARGET")
					end
					if foundEnt.IdleDialogueCanTurn && foundEnt:GetNPCState() == NPC_STATE_IDLE then
						foundEnt:StopMoving()
						foundEnt:SetTarget(self)
						foundEnt:SCHEDULE_FACE("TASK_FACE_TARGET")
					end
					
					-- For the other NPC to answer back
					timer.Simple(dur + 0.3, function()
						if IsValid(self) && IsValid(foundEnt) && !foundEnt:OnIdleDialogue(self, "Answer") then
							local response = foundEnt:PlaySoundSystem("IdleDialogueAnswer") or 0
							if response > 0 then -- If the ally responded, then make sure both NPCs stand still & don't play another idle sound until the whole conversation is finished!
								local curTime2 = CurTime()
								selfData.NextIdleSoundT = curTime2 + response + 0.5
								selfData.NextWanderTime = curTime2 + response + 1
								foundEnt.NextIdleSoundT = curTime2 + response + 0.5
								foundEnt.NextWanderTime = curTime2 + response + 1
							end
						end
					end)
					return -- Don't set the timer below
				end
			end
		end
		-- Didn't play a dialogue so play regular
		if playRegular then
			pickedSD = PICK(selfData.SoundTbl_Idle)
			if pickedSD then
				StopSD(selfData.CurrentIdleSound)
				selfData.CurrentIdleSound = VJ.CreateSound(self, pickedSD, selfData.IdleSoundLevel, self:GetSoundPitch(selfData.IdleSoundPitch))
			end
		end
	end
	selfData.NextIdleSoundT = curTime + math.Rand(selfData.NextSoundTime_Idle.a, selfData.NextSoundTime_Idle.b)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PlaySoundSystem(sdSet, customSD, sdType)
	local selfData = funcGetTable(self)
	if !selfData.HasSounds or !sdSet then return false end
	if customSD then
		customSD = PICK(customSD)
	end
	
	if sdSet == "IdleDialogueAnswer" then
		if selfData.HasIdleDialogueAnswerSounds then
			local pickedSD = PICK(selfData.SoundTbl_IdleDialogueAnswer)
			if (pickedSD && math.random(1, selfData.IdleDialogueAnswerSoundChance) == 1) or customSD then
				if customSD then pickedSD = customSD end
				StopSD(selfData.CurrentSpeechSound)
				StopSD(selfData.CurrentExtraSpeechSound)
				StopSD(selfData.CurrentIdleSound)
				selfData.IdleSoundBlockTime = CurTime() + math.random(2, 3)
				selfData.CurrentSpeechSound = (sdType or VJ.CreateSound)(self, pickedSD, selfData.IdleDialogueSoundLevel, self:GetSoundPitch(selfData.IdleDialogueSoundPitch))
				return SoundDuration(pickedSD) -- Return the duration of the sound, which will be used to make the other NPC stand still
			end
			return 0
		end
		return 0
	elseif sdSet == "FollowPlayer" then
		if selfData.HasFollowPlayerSounds then
			local pickedSD = PICK(selfData.SoundTbl_FollowPlayer)
			if (pickedSD && math.random(1, selfData.FollowPlayerSoundChance) == 1) or customSD then
				if customSD then pickedSD = customSD end
				StopSD(selfData.CurrentSpeechSound)
				StopSD(selfData.CurrentIdleSound)
				selfData.IdleSoundBlockTime = CurTime() + math.random(3, 4)
				selfData.CurrentSpeechSound = (sdType or VJ.CreateSound)(self, pickedSD, selfData.FollowPlayerSoundLevel, self:GetSoundPitch(selfData.FollowPlayerSoundPitch))
			end
		end
	elseif sdSet == "UnFollowPlayer" then
		if selfData.HasFollowPlayerSounds then
			local pickedSD = PICK(selfData.SoundTbl_UnFollowPlayer)
			if (pickedSD && math.random(1, selfData.FollowPlayerSoundChance) == 1) or customSD then
				if customSD then pickedSD = customSD end
				StopSD(selfData.CurrentSpeechSound)
				StopSD(selfData.CurrentIdleSound)
				selfData.IdleSoundBlockTime = CurTime() + math.random(3, 4)
				selfData.CurrentSpeechSound = (sdType or VJ.CreateSound)(self, pickedSD, selfData.FollowPlayerSoundLevel, self:GetSoundPitch(selfData.FollowPlayerSoundPitch))
			end
		end
	elseif sdSet == "ReceiveOrder" then
		if selfData.HasReceiveOrderSounds then
			local pickedSD = PICK(selfData.SoundTbl_ReceiveOrder)
			if (pickedSD && math.random(1, selfData.ReceiveOrderSoundChance) == 1) or customSD then
				if customSD then pickedSD = customSD end
				StopSD(selfData.CurrentSpeechSound)
				StopSD(selfData.CurrentIdleSound)
				selfData.NextIdleSoundT = selfData.NextIdleSoundT + 2
				selfData.NextAlertSoundT = CurTime() + 2
				selfData.CurrentSpeechSound = (sdType or VJ.CreateSound)(self, pickedSD, selfData.ReceiveOrderSoundLevel, self:GetSoundPitch(selfData.ReceiveOrderSoundPitch))
			end
		end
	elseif sdSet == "YieldToPlayer" then
		if selfData.HasYieldToPlayerSounds then
			local pickedSD = PICK(selfData.SoundTbl_YieldToPlayer)
			if (pickedSD && math.random(1, selfData.YieldToPlayerSoundChance) == 1) or customSD then
				if customSD then pickedSD = customSD end
				StopSD(selfData.CurrentSpeechSound)
				StopSD(selfData.CurrentIdleSound)
				selfData.IdleSoundBlockTime = CurTime() + math.random(3, 4)
				selfData.CurrentSpeechSound = (sdType or VJ.CreateSound)(self, pickedSD, selfData.YieldToPlayerSoundLevel, self:GetSoundPitch(selfData.YieldToPlayerSoundPitch))
			end
		end
	elseif sdSet == "MedicBeforeHeal" then
		if selfData.HasMedicSounds then
			local pickedSD = PICK(selfData.SoundTbl_MedicBeforeHeal)
			if (pickedSD && math.random(1, selfData.MedicBeforeHealSoundChance) == 1) or customSD then
				if customSD then pickedSD = customSD end
				StopSD(selfData.CurrentSpeechSound)
				StopSD(selfData.CurrentIdleSound)
				selfData.IdleSoundBlockTime = CurTime() + math.random(3, 4)
				selfData.CurrentSpeechSound = (sdType or VJ.CreateSound)(self, pickedSD, selfData.MedicBeforeHealSoundLevel, self:GetSoundPitch(selfData.MedicBeforeHealSoundPitch))
			end
		end
	elseif sdSet == "MedicOnHeal" then
		if selfData.HasMedicSounds then
			local pickedSD = PICK(selfData.SoundTbl_MedicOnHeal)
			if (pickedSD && math.random(1, selfData.MedicOnHealSoundChance) == 1) or customSD then
				if customSD then pickedSD = customSD end
				selfData.IdleSoundBlockTime = CurTime() + math.random(3, 4)
				selfData.CurrentMedicAfterHealSound = (sdType or VJ.EmitSound)(self, pickedSD, selfData.MedicOnHealSoundLevel, self:GetSoundPitch(selfData.MedicOnHealSoundPitch))
			end
		end
	elseif sdSet == "MedicReceiveHeal" then
		if selfData.HasMedicSounds then
			local pickedSD = PICK(selfData.SoundTbl_MedicReceiveHeal)
			if (pickedSD && math.random(1, selfData.MedicReceiveHealSoundChance) == 1) or customSD then
				if customSD then pickedSD = customSD end
				StopSD(selfData.CurrentSpeechSound)
				StopSD(selfData.CurrentIdleSound)
				selfData.IdleSoundBlockTime = CurTime() + math.random(3, 4)
				selfData.CurrentSpeechSound = (sdType or VJ.CreateSound)(self, pickedSD, selfData.MedicReceiveHealSoundLevel, self:GetSoundPitch(selfData.MedicReceiveHealSoundPitch))
			end
		end
	elseif sdSet == "OnPlayerSight" then
		if selfData.HasOnPlayerSightSounds then
			local pickedSD = PICK(selfData.SoundTbl_OnPlayerSight)
			if (pickedSD && math.random(1, selfData.OnPlayerSightSoundChance) == 1) or customSD then
				if customSD then pickedSD = customSD end
				StopSD(selfData.CurrentSpeechSound)
				StopSD(selfData.CurrentIdleSound)
				local durLen = SoundDuration(pickedSD)
				local dur = CurTime() + ((((durLen > 0) and durLen) or 3.5) + 1)
				selfData.IdleSoundBlockTime = dur
				selfData.NextAlertSoundT = CurTime() + math.random(1, 2)
				selfData.CurrentSpeechSound = (sdType or VJ.CreateSound)(self, pickedSD, selfData.OnPlayerSightSoundLevel, self:GetSoundPitch(selfData.OnPlayerSightSoundPitch))
			end
		end
	elseif sdSet == "Investigate" then
		if selfData.HasInvestigateSounds && CurTime() > selfData.NextInvestigateSoundT then
			local pickedSD = PICK(selfData.SoundTbl_Investigate)
			if (pickedSD && math.random(1, selfData.InvestigateSoundChance) == 1) or customSD then
				if customSD then pickedSD = customSD end
				StopSD(selfData.CurrentSpeechSound)
				StopSD(selfData.CurrentIdleSound)
				selfData.NextIdleSoundT = selfData.NextIdleSoundT + 2
				selfData.CurrentSpeechSound = (sdType or VJ.CreateSound)(self, pickedSD, selfData.InvestigateSoundLevel, self:GetSoundPitch(selfData.InvestigateSoundPitch))
			end
			selfData.NextInvestigateSoundT = CurTime() + math.Rand(selfData.NextSoundTime_Investigate.a, selfData.NextSoundTime_Investigate.b)
		end
	elseif sdSet == "LostEnemy" then
		if selfData.HasLostEnemySounds && CurTime() > selfData.NextLostEnemySoundT then
			local pickedSD = PICK(selfData.SoundTbl_LostEnemy)
			if (pickedSD && math.random(1, selfData.LostEnemySoundChance) == 1) or customSD then
				if customSD then pickedSD = customSD end
				StopSD(selfData.CurrentSpeechSound)
				StopSD(selfData.CurrentIdleSound)
				selfData.NextIdleSoundT = selfData.NextIdleSoundT + 2
				selfData.CurrentSpeechSound = (sdType or VJ.CreateSound)(self, pickedSD, selfData.LostEnemySoundLevel, self:GetSoundPitch(selfData.LostEnemySoundPitch))
			end
			selfData.NextLostEnemySoundT = CurTime() + math.Rand(selfData.NextSoundTime_LostEnemy.a, selfData.NextSoundTime_LostEnemy.b)
		end
	elseif sdSet == "Alert" then
		if selfData.HasAlertSounds then
			local pickedSD = PICK(selfData.SoundTbl_Alert)
			if (pickedSD && math.random(1, selfData.AlertSoundChance) == 1) or customSD then
				if customSD then pickedSD = customSD end
				StopSD(selfData.CurrentSpeechSound)
				StopSD(selfData.CurrentIdleSound)
				local curTime = CurTime()
				local durLen = SoundDuration(pickedSD)
				local dur = curTime + (((durLen > 0) and durLen) or 2) + 1
				selfData.NextIdleSoundT = dur
				selfData.NextPainSoundT = dur
				selfData.NextSuppressingSoundT = curTime + 4
				selfData.NextAlertSoundT = curTime + math.Rand(selfData.NextSoundTime_Alert.a, selfData.NextSoundTime_Alert.b)
				selfData.CurrentSpeechSound = (sdType or VJ.CreateSound)(self, pickedSD, selfData.AlertSoundLevel, self:GetSoundPitch(selfData.AlertSoundPitch))
			end
		end
	elseif sdSet == "CallForHelp" then
		if selfData.HasCallForHelpSounds then
			local pickedSD = PICK(selfData.SoundTbl_CallForHelp)
			if (pickedSD && math.random(1, selfData.CallForHelpSoundChance) == 1) or customSD then
				if customSD then pickedSD = customSD end
				StopSD(selfData.CurrentSpeechSound)
				StopSD(selfData.CurrentIdleSound)
				selfData.NextIdleSoundT = selfData.NextIdleSoundT + 2
				selfData.NextSuppressingSoundT = CurTime() + math.random(2.5, 4)
				selfData.CurrentSpeechSound = (sdType or VJ.CreateSound)(self, pickedSD, selfData.CallForHelpSoundLevel, self:GetSoundPitch(selfData.CallForHelpSoundPitch))
			end
		end
	elseif sdSet == "BeforeMeleeAttack" then
		if selfData.HasMeleeAttackSounds then
			local pickedSD = PICK(selfData.SoundTbl_BeforeMeleeAttack)
			if (pickedSD && math.random(1, selfData.BeforeMeleeAttackSoundChance) == 1) or customSD then
				if customSD then pickedSD = customSD end
				StopSD(selfData.CurrentSpeechSound)
				StopSD(selfData.CurrentExtraSpeechSound)
				if selfData.IdleSoundsWhileAttacking == false then StopSD(selfData.CurrentIdleSound) end -- Don't stop idle sounds if we aren't suppose to
				selfData.IdleSoundBlockTime = CurTime() + 1
				selfData.CurrentExtraSpeechSound = (sdType or VJ.CreateSound)(self, pickedSD, selfData.BeforeMeleeAttackSoundLevel, self:GetSoundPitch(selfData.BeforeMeleeAttackSoundPitch))
			end
		end
	elseif sdSet == "MeleeAttack" then
		if selfData.HasMeleeAttackSounds then
			local pickedSD = PICK(selfData.SoundTbl_MeleeAttack)
			if (pickedSD && math.random(1, selfData.MeleeAttackSoundChance) == 1) or customSD then
				if customSD then pickedSD = customSD end
				StopSD(selfData.CurrentSpeechSound)
				if selfData.IdleSoundsWhileAttacking == false then StopSD(selfData.CurrentIdleSound) end -- Don't stop idle sounds if we aren't suppose to
				selfData.IdleSoundBlockTime = CurTime() + 1
				selfData.CurrentSpeechSound = (sdType or VJ.CreateSound)(self, pickedSD, selfData.MeleeAttackSoundLevel, self:GetSoundPitch(selfData.MeleeAttackSoundPitch))
			end
			if selfData.HasExtraMeleeAttackSounds then
				pickedSD = PICK(selfData.SoundTbl_MeleeAttackExtra)
				if (pickedSD && math.random(1, selfData.ExtraMeleeSoundChance) == 1) or customSD then
					if selfData.IdleSoundsWhileAttacking == false then StopSD(selfData.CurrentIdleSound) end -- Don't stop idle sounds if we aren't suppose to
					VJ.EmitSound(self, pickedSD, selfData.ExtraMeleeAttackSoundLevel, self:GetSoundPitch(selfData.ExtraMeleeSoundPitch))
				end
			end
		end
	elseif sdSet == "MeleeAttackMiss" then
		if selfData.HasMeleeAttackMissSounds then
			local pickedSD = PICK(selfData.SoundTbl_MeleeAttackMiss)
			if (pickedSD && math.random(1, selfData.MeleeAttackMissSoundChance) == 1) or customSD then
				if customSD then pickedSD = customSD end
				if selfData.IdleSoundsWhileAttacking == false then StopSD(selfData.CurrentIdleSound) end -- Don't stop idle sounds if we aren't suppose to
				StopSD(selfData.CurrentMeleeAttackMissSound)
				selfData.IdleSoundBlockTime = CurTime() + 1
				selfData.CurrentMeleeAttackMissSound = (sdType or VJ.EmitSound)(self, pickedSD, selfData.MeleeAttackMissSoundLevel, self:GetSoundPitch(selfData.MeleeAttackMissSoundPitch))
			end
		end
	elseif sdSet == "BecomeEnemyToPlayer" then
		if selfData.HasBecomeEnemyToPlayerSounds then
			local pickedSD = PICK(selfData.SoundTbl_BecomeEnemyToPlayer)
			if (pickedSD && math.random(1, selfData.BecomeEnemyToPlayerChance) == 1) or customSD then
				if customSD then pickedSD = customSD end
				StopSD(selfData.CurrentSpeechSound)
				StopSD(selfData.CurrentIdleSound)
				local durLen = SoundDuration(pickedSD)
				local curTime = CurTime()
				local dur = curTime + (((durLen > 0) and durLen) or 2) + 1
				selfData.NextPainSoundT = dur
				selfData.NextAlertSoundT = dur
				selfData.NextInvestigateSoundT = curTime + 2
				selfData.IdleSoundBlockTime = curTime + math.random(2, 3)
				selfData.NextSuppressingSoundT = curTime + math.random(2.5, 4)
				selfData.CurrentSpeechSound = (sdType or VJ.CreateSound)(self, pickedSD, selfData.BecomeEnemyToPlayerSoundLevel, self:GetSoundPitch(selfData.BecomeEnemyToPlayerSoundPitch))
			end
		end
	elseif sdSet == "KilledEnemy" then
		if selfData.HasKilledEnemySounds && CurTime() > selfData.NextKilledEnemySoundT then
			local pickedSD = PICK(selfData.SoundTbl_KilledEnemy)
			if (pickedSD && math.random(1, selfData.KilledEnemySoundChance) == 1) or customSD then
				if customSD then pickedSD = customSD end
				StopSD(selfData.CurrentSpeechSound)
				StopSD(selfData.CurrentIdleSound)
				selfData.NextIdleSoundT = selfData.NextIdleSoundT + 2
				selfData.CurrentSpeechSound = (sdType or VJ.CreateSound)(self, pickedSD, selfData.KilledEnemySoundLevel, self:GetSoundPitch(selfData.KilledEnemySoundPitch))
			end
			selfData.NextKilledEnemySoundT = CurTime() + math.Rand(selfData.NextSoundTime_KilledEnemy.a, selfData.NextSoundTime_KilledEnemy.b)
		end
	elseif sdSet == "AllyDeath" then
		if selfData.HasAllyDeathSounds && CurTime() > selfData.NextAllyDeathSoundT then
			local pickedSD = PICK(selfData.SoundTbl_AllyDeath)
			if (pickedSD && math.random(1, selfData.AllyDeathSoundChance) == 1) or customSD then
				if customSD then pickedSD = customSD end
				StopSD(selfData.CurrentSpeechSound)
				StopSD(selfData.CurrentIdleSound)
				selfData.NextIdleSoundT = selfData.NextIdleSoundT + 2
				selfData.CurrentSpeechSound = (sdType or VJ.CreateSound)(self, pickedSD, selfData.AllyDeathSoundLevel, self:GetSoundPitch(selfData.AllyDeathSoundPitch))
			end
			selfData.NextAllyDeathSoundT = CurTime() + math.Rand(selfData.NextSoundTime_AllyDeath.a, selfData.NextSoundTime_AllyDeath.b)
		end
	elseif sdSet == "Pain" then
		local curTime = CurTime()
		if selfData.HasPainSounds && curTime > selfData.NextPainSoundT then
			local pickedSD = PICK(selfData.SoundTbl_Pain)
			local sdDur = 2
			if (pickedSD && math.random(1, selfData.PainSoundChance) == 1) or customSD then
				if customSD then pickedSD = customSD end
				StopSD(selfData.CurrentSpeechSound)
				StopSD(selfData.CurrentIdleSound)
				selfData.IdleSoundBlockTime = curTime + 1
				selfData.CurrentSpeechSound = (sdType or VJ.CreateSound)(self, pickedSD, selfData.PainSoundLevel, self:GetSoundPitch(selfData.PainSoundPitch))
				local durLen = SoundDuration(pickedSD)
				sdDur = (durLen > 0 and durLen) or sdDur
			end
			selfData.NextPainSoundT = curTime + sdDur
		end
	elseif sdSet == "Impact" then
		if selfData.HasImpactSounds then
			local pickedSD = PICK(selfData.SoundTbl_Impact)
			if (pickedSD && math.random(1, selfData.ImpactSoundChance) == 1) or customSD then
				if customSD then pickedSD = customSD end
				selfData.CurrentImpactSound = (sdType or VJ.EmitSound)(self, pickedSD, selfData.ImpactSoundLevel, self:GetSoundPitch(selfData.ImpactSoundPitch))
			end
		end
	elseif sdSet == "DamageByPlayer" then
		//if selfData.HasDamageByPlayerSounds && CurTime() > selfData.NextDamageByPlayerSoundT then -- This is done in the call instead
			local pickedSD = PICK(selfData.SoundTbl_DamageByPlayer)
			local curTime = CurTime()
			local sdDur = 2
			if (pickedSD && math.random(1, selfData.DamageByPlayerSoundChance) == 1) or customSD then
				if customSD then pickedSD = customSD end
				StopSD(selfData.CurrentSpeechSound)
				StopSD(selfData.CurrentIdleSound)
				local durLen = SoundDuration(pickedSD)
				sdDur = (durLen > 0 and durLen) or sdDur
				selfData.NextPainSoundT = curTime + sdDur
				selfData.IdleSoundBlockTime = curTime + sdDur
				selfData.CurrentSpeechSound = (sdType or VJ.CreateSound)(self, pickedSD, selfData.DamageByPlayerSoundLevel, self:GetSoundPitch(selfData.DamageByPlayerSoundPitch))
			end
			selfData.NextDamageByPlayerSoundT = curTime + sdDur
		//end
	elseif sdSet == "Death" then
		if selfData.HasDeathSounds then
			local pickedSD = PICK(selfData.SoundTbl_Death)
			if (pickedSD && math.random(1, selfData.DeathSoundChance) == 1) or customSD then
				if customSD then pickedSD = customSD end
				(sdType or VJ.EmitSound)(self, pickedSD, selfData.DeathSoundLevel, self:GetSoundPitch(selfData.DeathSoundPitch))
			end
		end
	elseif sdSet == "Gib" then
		if selfData.HasGibOnDeathSounds then
			sdType = VJ.EmitSound
			if customSD then
				sdType(self, customSD, 80, math.random(80, 100))
			else
				sdType(self, "vj_base/gib/splat.wav", 80, math.random(85, 100))
				sdType(self, "vj_base/gib/break1.wav", 80, math.random(85, 100))
				sdType(self, "vj_base/gib/break2.wav", 80, math.random(85, 100))
				sdType(self, "vj_base/gib/break3.wav", 80, math.random(85, 100))
			end
		end
	--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-- Creature Base Sound Systems --=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
	elseif sdSet == "BeforeRangeAttack" then
		if selfData.HasRangeAttackSounds then
			local pickedSD = PICK(selfData.SoundTbl_BeforeRangeAttack)
			if (pickedSD && math.random(1, selfData.BeforeRangeAttackSoundChance) == 1) or customSD then
				if customSD then pickedSD = customSD end
				StopSD(selfData.CurrentSpeechSound)
				StopSD(selfData.CurrentExtraSpeechSound)
				if selfData.IdleSoundsWhileAttacking == false then StopSD(selfData.CurrentIdleSound) end -- Don't stop idle sounds if we aren't suppose to
				selfData.IdleSoundBlockTime = CurTime() + 1
				selfData.CurrentExtraSpeechSound = (sdType or VJ.CreateSound)(self, pickedSD, selfData.BeforeRangeAttackSoundLevel, self:GetSoundPitch(selfData.BeforeRangeAttackSoundPitch))
			end
		end
	elseif sdSet == "RangeAttack" then
		if selfData.HasRangeAttackSounds then
			local pickedSD = PICK(selfData.SoundTbl_RangeAttack)
			if (pickedSD && math.random(1, selfData.RangeAttackSoundChance) == 1) or customSD then
				if customSD then pickedSD = customSD end
				StopSD(selfData.CurrentSpeechSound)
				if selfData.IdleSoundsWhileAttacking == false then StopSD(selfData.CurrentIdleSound) end -- Don't stop idle sounds if we aren't suppose to
				selfData.IdleSoundBlockTime = CurTime() + 1
				selfData.CurrentSpeechSound = (sdType or VJ.CreateSound)(self, pickedSD, selfData.RangeAttackSoundLevel, self:GetSoundPitch(selfData.RangeAttackSoundPitch))
			end
		end
	elseif sdSet == "BeforeLeapAttack" then
		if selfData.HasLeapAttackSounds then
			local pickedSD = PICK(selfData.SoundTbl_BeforeLeapAttack)
			if (pickedSD && math.random(1, selfData.BeforeLeapAttackSoundChance) == 1) or customSD then
				if customSD then pickedSD = customSD end
				StopSD(selfData.CurrentSpeechSound)
				StopSD(selfData.CurrentExtraSpeechSound)
				if selfData.IdleSoundsWhileAttacking == false then StopSD(selfData.CurrentIdleSound) end -- Don't stop idle sounds if we aren't suppose to
				selfData.IdleSoundBlockTime = CurTime() + 1
				selfData.CurrentExtraSpeechSound = (sdType or VJ.CreateSound)(self, pickedSD, selfData.BeforeLeapAttackSoundLevel, self:GetSoundPitch(selfData.BeforeLeapAttackSoundPitch))
			end
		end
	elseif sdSet == "LeapAttackJump" then
		if selfData.HasLeapAttackSounds then
			local pickedSD = PICK(selfData.SoundTbl_LeapAttackJump)
			if (pickedSD && math.random(1, selfData.LeapAttackJumpSoundChance) == 1) or customSD then
				if customSD then pickedSD = customSD end
				StopSD(selfData.CurrentSpeechSound)
				if selfData.IdleSoundsWhileAttacking == false then StopSD(selfData.CurrentIdleSound) end -- Don't stop idle sounds if we aren't suppose to
				selfData.IdleSoundBlockTime = CurTime() + 1
				selfData.CurrentSpeechSound = (sdType or VJ.CreateSound)(self, pickedSD, selfData.LeapAttackJumpSoundLevel, self:GetSoundPitch(selfData.LeapAttackJumpSoundPitch))
			end
		end
	elseif sdSet == "LeapAttackDamage" then
		if selfData.HasLeapAttackSounds then
			local pickedSD = PICK(selfData.SoundTbl_LeapAttackDamage)
			if (pickedSD && math.random(1, selfData.LeapAttackDamageSoundChance) == 1) or customSD then
				if customSD then pickedSD = customSD end
				if selfData.IdleSoundsWhileAttacking == false then StopSD(selfData.CurrentIdleSound) end -- Don't stop idle sounds if we aren't suppose to
				StopSD(selfData.CurrentSpeechSound)
				selfData.IdleSoundBlockTime = CurTime() + 1
				selfData.CurrentSpeechSound = (sdType or VJ.EmitSound)(self, pickedSD, selfData.LeapAttackDamageSoundLevel, self:GetSoundPitch(selfData.LeapAttackDamageSoundPitch))
			end
		end
	elseif sdSet == "LeapAttackDamageMiss" then
		if selfData.HasLeapAttackSounds then
			local pickedSD = PICK(selfData.SoundTbl_LeapAttackDamageMiss)
			if (pickedSD && math.random(1, selfData.LeapAttackDamageMissSoundChance) == 1) or customSD then
				if customSD then pickedSD = customSD end
				if selfData.IdleSoundsWhileAttacking == false then StopSD(selfData.CurrentIdleSound) end -- Don't stop idle sounds if we aren't suppose to
				selfData.IdleSoundBlockTime = CurTime() + 1
				selfData.CurrentLeapAttackDamageMissSound = (sdType or VJ.EmitSound)(self, pickedSD, selfData.LeapAttackDamageMissSoundLevel, self:GetSoundPitch(selfData.LeapAttackDamageMissSoundPitch))
			end
		end
	--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-- Human Base Sound Systems --=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
	elseif sdSet == "Suppressing" then
		local curTime = CurTime()
		if selfData.HasSuppressingSounds && curTime > selfData.NextSuppressingSoundT then
			local pickedSD = PICK(selfData.SoundTbl_Suppressing)
			if (pickedSD && math.random(1, selfData.SuppressingSoundChance) == 1) or customSD then
				if customSD then pickedSD = customSD end
				StopSD(selfData.CurrentSpeechSound)
				StopSD(selfData.CurrentIdleSound)
				selfData.IdleSoundBlockTime = curTime + 2
				selfData.CurrentSpeechSound = (sdType or VJ.CreateSound)(self, pickedSD, selfData.SuppressingSoundLevel, self:GetSoundPitch(selfData.SuppressingSoundPitch))
			end
			selfData.NextSuppressingSoundT = curTime + math.Rand(selfData.NextSoundTime_Suppressing.a, selfData.NextSoundTime_Suppressing.b)
		end
	elseif sdSet == "WeaponReload" then
		if selfData.HasWeaponReloadSounds then
			local pickedSD = PICK(selfData.SoundTbl_WeaponReload)
			if (pickedSD && math.random(1, selfData.WeaponReloadSoundChance) == 1) or customSD then
				if customSD then pickedSD = customSD end
				StopSD(selfData.CurrentSpeechSound)
				StopSD(selfData.CurrentIdleSound)
				local durLen = SoundDuration(pickedSD)
				selfData.IdleSoundBlockTime = CurTime() + ((durLen > 0 and durLen) or 3.5)
				selfData.CurrentSpeechSound = (sdType or VJ.CreateSound)(self, pickedSD, selfData.WeaponReloadSoundLevel, self:GetSoundPitch(selfData.WeaponReloadSoundPitch))
			end
		end
	elseif sdSet == "GrenadeAttack" then
		if selfData.HasGrenadeAttackSounds && CurTime() > selfData.NextGrenadeAttackSoundT then
			local pickedSD = PICK(selfData.SoundTbl_GrenadeAttack)
			if (pickedSD && math.random(1, selfData.GrenadeAttackSoundChance) == 1) or customSD then
				if customSD then pickedSD = customSD end
				StopSD(selfData.CurrentSpeechSound)
				if selfData.IdleSoundsWhileAttacking == false then StopSD(selfData.CurrentIdleSound) end -- Don't stop idle sounds if we aren't suppose to
				selfData.IdleSoundBlockTime = CurTime() + math.random(3, 4)
				selfData.CurrentSpeechSound = (sdType or VJ.CreateSound)(self, pickedSD, selfData.GrenadeAttackSoundLevel, self:GetSoundPitch(selfData.GrenadeAttackSoundPitch))
			end
		end
	elseif sdSet == "DangerSight" or sdSet == "GrenadeSight" then
		if selfData.HasDangerSightSounds && CurTime() > selfData.NextDangerSightSoundT then
			local pickedSD = PICK(selfData.SoundTbl_DangerSight)
			if sdSet == "GrenadeSight" then
				local grenSDs = PICK(selfData.SoundTbl_GrenadeSight)
				if grenSDs then
					pickedSD = grenSDs
				end
			end
			local sdDur = 3
			if (pickedSD && math.random(1, selfData.DangerSightSoundChance) == 1) or customSD then
				if customSD then pickedSD = customSD end
				StopSD(selfData.CurrentSpeechSound)
				StopSD(selfData.CurrentIdleSound)
				local durLen = SoundDuration(pickedSD)
				sdDur = (durLen > 0 and durLen) or sdDur
				selfData.IdleSoundBlockTime = CurTime() + sdDur
				selfData.CurrentSpeechSound = (sdType or VJ.CreateSound)(self, pickedSD, selfData.DangerSightSoundLevel, self:GetSoundPitch(selfData.DangerSightSoundPitch))
			end
			selfData.NextDangerSightSoundT = CurTime() + sdDur
		end
	else -- Such as "Speech"
		if customSD then
			StopSD(selfData.CurrentSpeechSound)
			StopSD(selfData.CurrentIdleSound)
			local durLen = SoundDuration(customSD)
			selfData.IdleSoundBlockTime = CurTime() + ((((durLen > 0) and durLen) or 2) + 1)
			selfData.CurrentSpeechSound = (sdType or VJ.CreateSound)(self, customSD, 80, self:GetSoundPitch(false))
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RemoveTimers()
	local myIndex = self:EntIndex()
	for _, name in ipairs(self.TimersToRemove) do
		timer.Remove(name .. myIndex)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Check if the given entity is in the "self.EntitiesToNoCollide" table, if it's then apply no collide
		- ent = Entity to check and apply no collide to if it's in the table
-----------------------------------------------------------]]
function ENT:ValidateNoCollide(ent)
	local noCollTbl = self.EntitiesToNoCollide
	if noCollTbl && self != ent then
		local entClass = funcGetClass(ent)
		for i = 1, #noCollTbl do
			if noCollTbl[i] == entClass then
				-- TODO: The returned logic_collision_pair created here could be removed as it continues working without issues, but I have no idea
				-- what kind of side effects it could cause, best to leave as is until further testing or someone with more info can confirm it's safe
				-- Alternatively, Facepunch should just directly bind "PhysEnableEntityCollisions" and "PhysDisableEntityCollisions" to Lua, which is
				-- what Valve uses for the default NPCs: https://github.com/ValveSoftware/source-sdk-2013/blob/master/src/game/shared/physics_shared.h#L142
				constraint.NoCollide(self, ent, 0, 0)
				-- Check for bone followers
				local boneFollowers = ent:GetBoneFollowers()
				if #boneFollowers > 0 then
					for _, v in ipairs(boneFollowers) do
						constraint.NoCollide(self, v.follower, 0, 0)
					end
				end
				break
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Checks if the given damage type(s) contains 1 or more of the default gibbing damage types
		- dmgType = Damage type(s) to check | EX: dmginfo:GetDamageType()
	Returns
		- true, At least 1 damage type is included
		- false, NO damage type is included
	Notes
		- DMG_ALWAYSGIB = Skip if it's a bullet because engine sets DMG_ALWAYSGIB for "FireBullets" if it's more than 16 otherwise it sets DMG_NEVERGIB
		- DMG_DIRECT -- Disabled because default fire and related weapons use it!
-----------------------------------------------------------]]
local GIB_DAMAGE_MASK = bit.bor(DMG_ALWAYSGIB, DMG_ENERGYBEAM, DMG_BLAST, DMG_VEHICLE, DMG_CRUSH, DMG_DISSOLVE, DMG_SLOWBURN, DMG_PHYSGUN, DMG_PLASMA, DMG_SONIC)
--
function ENT:IsGibDamage(dmgType)
	return bAND(dmgType, DMG_NEVERGIB) == 0 && bAND(dmgType, GIB_DAMAGE_MASK) != 0 && (bAND(dmgType, DMG_ALWAYSGIB) == 0 || bAND(dmgType, DMG_BULLET) == 0)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GibOnDeath(dmginfo, hitgroup)
	local selfData = funcGetTable(self)
	if !selfData.CanGib or !selfData.CanGibOnDeath or selfData.GibbedOnDeath then return false end
	if !selfData.GibOnDeathFilter or (selfData.GibOnDeathFilter && self:IsGibDamage(dmginfo:GetDamageType())) then
		local gibbed, overrides = self:HandleGibOnDeath(dmginfo, hitgroup)
		if gibbed then
			selfData.GibbedOnDeath = true
			if overrides then
				if !overrides.AllowCorpse then selfData.HasDeathCorpse = false end
				if !overrides.AllowAnim then selfData.HasDeathAnimation = false end
				if overrides.AllowSound != false then self:PlaySoundSystem("Gib") end -- nil/true = Play gib sound
			else -- Default
				selfData.HasDeathCorpse = false
				selfData.HasDeathAnimation = false
				self:PlaySoundSystem("Gib")
			end
			return true
		end
	end
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CreateDeathLoot(dmginfo, hitgroup)
	local selfData = funcGetTable(self)
	if math.random(1, selfData.DeathLootChance) != 1 then return end
	local pickedEnt = PICK(selfData.DeathLoot)
	if !pickedEnt then return end
	local ent = ents.Create(pickedEnt)
	ent:SetPos(self:GetPos() + self:OBBCenter())
	ent:SetAngles(self:GetAngles())
	ent:Spawn()
	ent:Activate()
	local phys = ent:GetPhysicsObject()
	if IsValid(phys) then
		local dmgForce = (selfData.SavedDmgInfo.force / 40) + self:GetMoveVelocity() + self:GetVelocity()
		if selfData.DeathAnimationCodeRan then
			dmgForce = self:GetGroundSpeedVelocity()
		end
		phys:SetMass(1)
		phys:ApplyForceCenter(dmgForce)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRemove()
	self:CustomOnRemove()
	hook.Remove("Think", self)
	self.Dead = true
	if self.MedicData.Status then self:ResetMedicBehavior() end
	if self.VJ_ST_Eating then self:ResetEatingBehavior("Dead") end
	self:RemoveTimers()
	self:StopAllSounds()
	self:StopParticles()
	self:DestroyBoneFollowers()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:StartSoundTrack()
	local selfData = funcGetTable(self)
	if selfData.HasSounds && selfData.HasSoundTrack && math.random(1, selfData.SoundTrackChance) == 1 then
		selfData.VJ_SD_PlayingMusic = true
		net.Start("vj_music_cl")
			net.WriteEntity(self)
			net.WriteString(PICK(selfData.SoundTbl_SoundTrack))
			net.WriteFloat(selfData.SoundTrackVolume)
			net.WriteFloat(selfData.SoundTrackPlaybackRate)
		net.Broadcast()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local menuCVs = {
	creature_opendoor = GetConVar("vj_npc_creature_opendoor"),
	debug = GetConVar("vj_npc_debug"),
	poseparams = GetConVar("vj_npc_poseparams"),
	shadows = GetConVar("vj_npc_shadows"),
	snd = GetConVar("vj_npc_snd"),
	fri_base = GetConVar("vj_npc_fri_base"),
	fri_player = GetConVar("vj_npc_fri_player"),
	fri_antlion = GetConVar("vj_npc_fri_antlion"),
	fri_combine = GetConVar("vj_npc_fri_combine"),
	fri_zombie = GetConVar("vj_npc_fri_zombie"),
	allies = GetConVar("vj_npc_allies"),
	anim_death = GetConVar("vj_npc_anim_death"),
	corpse = GetConVar("vj_npc_corpse"),
	loot = GetConVar("vj_npc_loot"),
	wander = GetConVar("vj_npc_wander"),
	chase = GetConVar("vj_npc_chase"),
	flinch = GetConVar("vj_npc_flinch"),
	melee = GetConVar("vj_npc_melee"),
	blood = GetConVar("vj_npc_blood"),
	god = GetConVar("vj_npc_god"),
	wep_reload = GetConVar("vj_npc_wep_reload"),
	ply_betray = GetConVar("vj_npc_ply_betray"),
	callhelp = GetConVar("vj_npc_callhelp"),
	investigate = GetConVar("vj_npc_investigate"),
	eat = GetConVar("vj_npc_eat"),
	ply_follow = GetConVar("vj_npc_ply_follow"),
	ply_chat = GetConVar("vj_npc_ply_chat"),
	medic = GetConVar("vj_npc_medic"),
	wep = GetConVar("vj_npc_wep"),
	wep_secondary = GetConVar("vj_npc_wep_secondary"),
	grenade = GetConVar("vj_npc_grenade"),
	dangerdetection = GetConVar("vj_npc_dangerdetection"),
	wep_drop = GetConVar("vj_npc_wep_drop"),
	gib_vfx = GetConVar("vj_npc_gib_vfx"),
	gib = GetConVar("vj_npc_gib"),
	sight_xray = GetConVar("vj_npc_sight_xray"),
	snd_gib = GetConVar("vj_npc_snd_gib"),
	snd_track = GetConVar("vj_npc_snd_track"),
	snd_footstep = GetConVar("vj_npc_snd_footstep"),
	snd_idle = GetConVar("vj_npc_snd_idle"),
	snd_breath = GetConVar("vj_npc_snd_breath"),
	snd_alert = GetConVar("vj_npc_snd_alert"),
	snd_danger = GetConVar("vj_npc_snd_danger"),
	snd_melee = GetConVar("vj_npc_snd_melee"),
	melee_bleed = GetConVar("vj_npc_melee_bleed"),
	melee_ply_speed = GetConVar("vj_npc_melee_ply_speed"),
	melee_propint = GetConVar("vj_npc_melee_propint"),
	melee_ply_dsp = GetConVar("vj_npc_melee_ply_dsp"),
	range = GetConVar("vj_npc_range"),
	leap = GetConVar("vj_npc_leap"),
	snd_pain = GetConVar("vj_npc_snd_pain"),
	snd_death = GetConVar("vj_npc_snd_death"),
	snd_plyfollow = GetConVar("vj_npc_snd_plyfollow"),
	snd_plybetrayal = GetConVar("vj_npc_snd_plybetrayal"),
	snd_plydamage = GetConVar("vj_npc_snd_plydamage"),
	snd_plysight = GetConVar("vj_npc_snd_plysight"),
	snd_medic = GetConVar("vj_npc_snd_medic"),
	snd_wep_reload = GetConVar("vj_npc_snd_wep_reload"),
	snd_grenade = GetConVar("vj_npc_snd_grenade"),
	snd_wep_suppressing = GetConVar("vj_npc_snd_wep_suppressing"),
	snd_callhelp = GetConVar("vj_npc_snd_callhelp"),
	snd_receiveorder = GetConVar("vj_npc_snd_receiveorder"),
	snd_plyspeed = GetConVar("vj_npc_snd_plyspeed"),
	snd_range = GetConVar("vj_npc_snd_range"),
	snd_leap = GetConVar("vj_npc_snd_leap"),
	corpse_collision = GetConVar("vj_npc_corpse_collision"),
	debug_engine = GetConVar("vj_npc_debug_engine"),
}
--
function ENT:InitConvars()
	local c = menuCVs
	local selfData = funcGetTable(self)
	if c.debug:GetInt() == 1 then selfData.VJ_DEBUG = true end
	if c.poseparams:GetInt() == 0 && !selfData.OnUpdatePoseParamTracking then selfData.HasPoseParameterLooking = false end
	if c.shadows:GetInt() == 0 then self:DrawShadow(false) end
	if c.snd:GetInt() == 0 then selfData.HasSounds = false end
	if c.fri_base:GetInt() == 1 then selfData.VJ_NPC_Class[#selfData.VJ_NPC_Class + 1] = "CLASS_VJ_BASE" end
	if c.fri_player:GetInt() == 1 then selfData.VJ_NPC_Class[#selfData.VJ_NPC_Class + 1] = "CLASS_PLAYER_ALLY" end
	if c.fri_antlion:GetInt() == 1 then selfData.VJ_NPC_Class[#selfData.VJ_NPC_Class + 1] = "CLASS_ANTLION" end
	if c.fri_combine:GetInt() == 1 then selfData.VJ_NPC_Class[#selfData.VJ_NPC_Class + 1] = "CLASS_COMBINE" end
	if c.fri_zombie:GetInt() == 1 then selfData.VJ_NPC_Class[#selfData.VJ_NPC_Class + 1] = "CLASS_ZOMBIE" end
	if c.allies:GetInt() == 0 then selfData.CanAlly = false end
	if c.anim_death:GetInt() == 0 then selfData.HasDeathAnimation = false end
	if c.corpse:GetInt() == 0 then selfData.HasDeathCorpse = false end
	if c.loot:GetInt() == 0 then selfData.DropDeathLoot = false end
	if c.wander:GetInt() == 0 then selfData.DisableWandering = true end
	if c.chase:GetInt() == 0 then selfData.DisableChasingEnemy = true end
	if c.flinch:GetInt() == 0 then selfData.CanFlinch = false end
	if c.melee:GetInt() == 0 then selfData.HasMeleeAttack = false end
	if c.blood:GetInt() == 0 then selfData.Bleeds = false end
	if c.god:GetInt() == 1 then selfData.GodMode = true end
	if c.ply_betray:GetInt() == 0 then selfData.BecomeEnemyToPlayer = false end
	if c.callhelp:GetInt() == 0 then selfData.CallForHelp = false end
	if c.investigate:GetInt() == 0 then selfData.CanInvestigate = false end
	if c.eat:GetInt() == 0 then selfData.CanEat = false end
	if c.ply_follow:GetInt() == 0 then selfData.FollowPlayer = false end
	if c.ply_chat:GetInt() == 0 then selfData.CanChatMessage = false end
	if c.medic:GetInt() == 0 then selfData.IsMedic = false end
	if c.gib_vfx:GetInt() == 0 then selfData.HasGibOnDeathEffects = false end
	if c.gib:GetInt() == 0 then selfData.CanGib = false selfData.CanGibOnDeath = false end
	if c.sight_xray:GetInt() == 1 then selfData.SightAngle = 360 selfData.EnemyXRayDetection = true end
	if c.snd_gib:GetInt() == 0 then selfData.HasGibOnDeathSounds = false end
	if c.snd_track:GetInt() == 0 then selfData.HasSoundTrack = false end
	if c.snd_footstep:GetInt() == 0 then selfData.HasFootstepSounds = false end
	if c.snd_idle:GetInt() == 0 then selfData.HasIdleSounds = false end
	if c.snd_breath:GetInt() == 0 then selfData.HasBreathSound = false end
	if c.snd_alert:GetInt() == 0 then selfData.HasAlertSounds = false end
	if c.snd_melee:GetInt() == 0 then selfData.HasMeleeAttackSounds = false selfData.HasExtraMeleeAttackSounds = false selfData.HasMeleeAttackMissSounds = false end
	if c.snd_pain:GetInt() == 0 then selfData.HasPainSounds = false end
	if c.snd_death:GetInt() == 0 then selfData.HasDeathSounds = false end
	if c.snd_plyfollow:GetInt() == 0 then selfData.HasFollowPlayerSounds = false end
	if c.snd_plybetrayal:GetInt() == 0 then selfData.HasBecomeEnemyToPlayerSounds = false end
	if c.snd_plydamage:GetInt() == 0 then selfData.HasDamageByPlayerSounds = false end
	if c.snd_plysight:GetInt() == 0 then selfData.HasOnPlayerSightSounds = false end
	if c.snd_medic:GetInt() == 0 then selfData.HasMedicSounds = false end
	if c.snd_callhelp:GetInt() == 0 then selfData.HasCallForHelpSounds = false end
	if c.snd_receiveorder:GetInt() == 0 then selfData.HasReceiveOrderSounds = false end
	local corpseCollision = c.corpse_collision:GetInt()
	if corpseCollision != 0 && selfData.DeathCorpseCollisionType == COLLISION_GROUP_DEBRIS then
		if corpseCollision == 1 then
			selfData.DeathCorpseCollisionType = COLLISION_GROUP_NONE
		elseif corpseCollision == 2 then
			selfData.DeathCorpseCollisionType = COLLISION_GROUP_WORLD
		elseif corpseCollision == 3 then
			selfData.DeathCorpseCollisionType = COLLISION_GROUP_INTERACTIVE
		elseif corpseCollision == 4 then
			selfData.DeathCorpseCollisionType = COLLISION_GROUP_WEAPON
		elseif corpseCollision == 5 then
			selfData.DeathCorpseCollisionType = COLLISION_GROUP_PASSABLE_DOOR
		end
	end
	-- Enables source engine debug overlays (some commands like 'npc_conditions' need it)
	if selfData.VJ_DEBUG && c.debug_engine:GetInt() == 1 then
		self:SetSaveValue("m_debugOverlays", bit.bor(0x00000001, 0x00000002, 0x00000004, 0x00000008, 0x00000010, 0x00000020, 0x00000040, 0x00000080, 0x00000100, 0x00000200, 0x00001000, 0x00002000, 0x00004000, 0x00008000, 0x00020000, 0x00040000, 0x00080000, 0x00100000, 0x00200000, 0x00400000, 0x04000000, 0x08000000, 0x10000000, 0x20000000, 0x40000000))
	end
	
	-- Base specific
	if selfData.IsVJBaseSNPC_Creature then
		if c.creature_opendoor:GetInt() == 0 then selfData.CanOpenDoors = false end
		if c.melee_bleed:GetInt() == 0 then selfData.MeleeAttackBleedEnemy = false end
		if c.melee_ply_dsp:GetInt() == 0 then selfData.MeleeAttackDSP = false end
		if c.melee_ply_speed:GetInt() == 0 then selfData.MeleeAttackPlayerSpeed = false end
		if c.range:GetInt() == 0 then selfData.HasRangeAttack = false end
		if c.leap:GetInt() == 0 then selfData.HasLeapAttack = false end
		if c.snd_plyspeed:GetInt() == 0 then selfData.HasMeleeAttackPlayerSpeedSounds = false end
		if c.snd_range:GetInt() == 0 then selfData.HasRangeAttackSounds = false end
		if c.snd_leap:GetInt() == 0 then selfData.HasLeapAttackSounds = false end
		local propAPType = c.melee_propint:GetInt()
		if propAPType != 1 then
			if propAPType == 0 then -- Disable
				selfData.PropInteraction = false
			elseif propAPType == 2 && selfData.PropInteraction != "OnlyPush" then -- Only damage
				if selfData.PropInteraction == "OnlyDamage" then
					selfData.PropInteraction = false
				else
					selfData.PropInteraction = "OnlyDamage"
				end
			elseif propAPType == 3 && selfData.PropInteraction != "OnlyDamage" then -- Only push
				if selfData.PropInteraction == "OnlyPush" then
					selfData.PropInteraction = false
				else
					selfData.PropInteraction = "OnlyPush"
				end
			end
		end
	elseif selfData.IsVJBaseSNPC_Human then
		if c.wep:GetInt() == 0 then selfData.Weapon_Disabled = true end
		if c.wep_secondary:GetInt() == 0 then selfData.Weapon_CanSecondaryFire = false end
		if c.wep_reload:GetInt() == 0 then selfData.Weapon_CanReload = false end
		if c.wep_drop:GetInt() == 0 then selfData.DropWeaponOnDeath = false end
		if c.grenade:GetInt() == 0 then selfData.HasGrenadeAttack = false end
		if c.dangerdetection:GetInt() == 0 then selfData.CanDetectDangers = false end
		if c.snd_danger:GetInt() == 0 then selfData.HasDangerSightSounds = false end
		if c.snd_wep_reload:GetInt() == 0 then selfData.HasWeaponReloadSounds = false end
		if c.snd_wep_suppressing:GetInt() == 0 then selfData.HasSuppressingSounds = false end
		if c.snd_grenade:GetInt() == 0 then selfData.HasGrenadeAttackSounds = false end
	end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ ///// Backwards Compatibility | Do not to use! \\\\\ ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local dispToVal = {[D_LI] = false, [D_HT] = true, [D_NU] = "Neutral"}
function ENT:DoRelationshipCheck(ent) return dispToVal[self:CheckRelationship(ent)] end
function ENT:FaceCertainPosition(target, faceTime) return self:SetTurnTarget(target, faceTime) end
function ENT:FaceCertainEntity(target, faceCurEnemy, faceTime) return self:SetTurnTarget(faceCurEnemy and "Enemy" or target, faceTime) end
function ENT:VJ_DoSetEnemy(ent, stopMoving, doQuickIfActiveEnemy) return self:ForceSetEnemy(ent, stopMoving) end
function ENT:DoChaseAnimation(alwaysChase) self:MaintainAlertBehavior(alwaysChase) end
function ENT:VJ_TASK_CHASE_ENEMY(doLOSChase) self:SCHEDULE_ALERT_CHASE(doLOSChase) end
function ENT:VJ_TASK_FACE_X(faceType, customFunc) self:SCHEDULE_FACE(faceType, customFunc) end
function ENT:VJ_TASK_GOTO_LASTPOS(moveType, customFunc) self:SCHEDULE_GOTO_POSITION(moveType, customFunc) end
function ENT:VJ_TASK_GOTO_TARGET(moveType, customFunc) self:SCHEDULE_GOTO_TARGET(moveType, customFunc) end
function ENT:VJ_TASK_COVER_FROM_ENEMY(moveType, customFunc) self:SCHEDULE_COVER_ENEMY(moveType, customFunc) end
function ENT:VJ_TASK_COVER_FROM_ORIGIN(moveType, customFunc) self:SCHEDULE_COVER_ORIGIN(moveType, customFunc) end
function ENT:VJ_TASK_IDLE_WANDER() self:SCHEDULE_IDLE_WANDER() end
function ENT:VJ_TASK_IDLE_STAND() self:SCHEDULE_IDLE_STAND() end
function ENT:VJ_ACT_PLAYACTIVITY(animation, lockAnim, lockAnimTime, faceEnemy, delay, extra, customFunc) return self:PlayAnim(animation, lockAnim, lockAnimTime, faceEnemy, delay, extra, customFunc) end
function ENT:VJ_DecideSoundPitch(pitch1, pitch2) return self:GetSoundPitch(pitch1) end
function ENT:VJ_GetDifficultyValue(num) return self:ScaleByDifficulty(num) end
function ENT:VJ_GetNearestPointToEntity(ent, centerNPC) return VJ.GetNearestPositions(self, ent, centerNPC) end
function ENT:VJ_GetNearestPointToEntityDistance(ent, centerNPC) return VJ.GetNearestDistance(self, ent, centerNPC) end
function ENT:BusyWithActivity() return self:IsBusy("Activities") end
function ENT:IsBusyWithBehavior() return self:IsBusy("Behaviors") end
function ENT:FootStepSoundCode(customSD) self:PlayFootstepSound(customSD) end
function ENT:MeleeAttackCode(isPropAttack) self:ExecuteMeleeAttack(isPropAttack) end
function ENT:RangeAttackCode() self:ExecuteRangeAttack() end
function ENT:LeapDamageCode() self:ExecuteLeapAttack() end
function ENT:DecideAnimationLength(anim, override, decrease) return VJ.AnimDurationEx(self, anim, override, decrease) end
function ENT:StopAllCommonSpeechSounds() self:StopAllSounds() end
function ENT:GetFaceAngle(ang) return self:GetTurnAngle(ang) end
function ENT:DoFlinch(dmginfo, hitgroup) self:Flinch(dmginfo, hitgroup) end
ENT.LatestEnemyDistance = 0 -- Only here to avoid errors
ENT.NearestPointToEnemyDistance = 0 -- Only here to avoid errors
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:VJ_CheckAllFourSides(checkDist, returnPos, sides)
	checkDist = checkDist or 200
	sides = sides or "1111"
	local result = returnPos == true and {} or {Forward = false, Backward = false, Right = false, Left = false}
	local i = 0
	local myPos = self:GetPos()
	local myPosCentered = myPos + self:OBBCenter()
	local myForward = self:GetForward()
	local myRight = self:GetRight()
	local positions = { -- Set the positions that we need to check
		string.sub(sides, 1, 1) == "1" and myForward or 0,
		string.sub(sides, 2, 2) == "1" and -myForward or 0,
		string.sub(sides, 3, 3) == "1" and myRight or 0,
		string.sub(sides, 4, 4) == "1" and -myRight or 0
	}
	for _, v in ipairs(positions) do
		i = i + 1
		if v == 0 then continue end -- If 0 then we have the tag to skip this!
		local tr = util.TraceLine({
			start = myPosCentered,
			endpos = myPosCentered + v*checkDist,
			filter = self
		})
		local hitPos = tr.HitPos
		if myPos:Distance(hitPos) >= checkDist then
			if returnPos then
				hitPos.z = myPos.z -- Reset it to self:GetPos() z-axis
				result[#result + 1] = hitPos
			elseif i == 1 then
				result.Forward = true
			elseif i == 2 then
				result.Backward = true
			elseif i == 3 then
				result.Right = true
			elseif i == 4 then
				result.Left = true
			end
		end
	end
	return result
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ApplyBackwardsCompatibility()
	if self.CustomOnInitialize then self:CustomOnInitialize() end
	if self.CustomInitialize then self:CustomInitialize() end
	if self.CustomOn_PoseParameterLookingCode then self.OnUpdatePoseParamTracking = function(_, pitch, yaw, roll) self:CustomOn_PoseParameterLookingCode(pitch, yaw, roll) end end
	if self.CustomOnAlert then self.OnAlert = function(_, ent) self:CustomOnAlert(ent) end end
	if self.CustomOnInvestigate then self.OnInvestigate = function(_, ent) self:CustomOnInvestigate(ent) end end
	if self.CustomOnFootStepSound then self.OnFootstepSound = function(_, moveType, sdFile) self:CustomOnFootStepSound(moveType, sdFile) end end
	if self.CustomOnCallForHelp then self.OnCallForHelp = function(_, ally, isFirst) self:CustomOnCallForHelp(ally, isFirst) end end
	if self.CustomOnPlayerSight then self.OnPlayerSight = function(_, ent) self:CustomOnPlayerSight(ent) end end
	if self.CustomOnThink then self.OnThink = function() self:CustomOnThink() end end
	if self.CustomOnThink_AIEnabled then self.OnThinkActive = function() self:CustomOnThink_AIEnabled() end end
	if self.CustomOnTakeDamage_OnBleed then self.OnBleed = function(_, dmginfo, hitgroup) self:CustomOnTakeDamage_OnBleed(dmginfo, hitgroup) end end
	if self.CustomOnAcceptInput then self.OnInput = function(_, key, activator, caller, data) self:CustomOnAcceptInput(key, activator, caller, data) end end
	if self.CustomOnHandleAnimEvent then self.OnAnimEvent = function(_, ev, evTime, evCycle, evType, evOptions) self:CustomOnHandleAnimEvent(ev, evTime, evCycle, evType, evOptions) end end
	if self.CustomOnDeath_AfterCorpseSpawned then self.OnCreateDeathCorpse = function(_, dmginfo, hitgroup, corpse) self:CustomOnDeath_AfterCorpseSpawned(dmginfo, hitgroup, corpse) end end
	if self.PlayerFriendly == true then self.VJ_NPC_Class[#self.VJ_NPC_Class + 1] = "CLASS_PLAYER_ALLY" end
	if self.HasHealthRegeneration then self.HealthRegenParams.Enabled = true end
	if self.HealthRegenerationAmount then self.HealthRegenParams.Amount = self.HealthRegenerationAmount end
	if self.HealthRegenerationDelay then self.HealthRegenParams.Delay = self.HealthRegenerationDelay end
	if self.HealthRegenerationResetOnDmg != nil then self.HealthRegenParams.ResetOnDmg = self.HealthRegenerationResetOnDmg end
	if self.FriendsWithAllPlayerAllies != nil then self.AlliedWithPlayerAllies = self.FriendsWithAllPlayerAllies end
	if self.Medic_CanBeHealed == false then self.VJ_ID_Healable = false end
	if self.Immune_AcidPoisonRadiation != nil then self.Immune_Toxic = self.Immune_AcidPoisonRadiation end
	if self.Immune_Blast != nil then self.Immune_Explosive = self.Immune_Blast end
	if self.FindEnemy_CanSeeThroughWalls == true then self.EnemyXRayDetection = true end
	if self.DisableFindEnemy == true then self.EnemyDetection = false end
	if self.DisableTouchFindEnemy == true then self.EnemyTouchDetection = false end
	if self.HasFootStepSound != nil then self.HasFootstepSounds = self.HasFootStepSound end
	if self.FootStepPitch then self.FootstepSoundPitch = self.FootStepPitch else self.FootStepPitch = VJ.SET(80, 100) end
	if self.FootStepSoundLevel then self.FootstepSoundLevel = self.FootStepSoundLevel end
	if self.FootStepTimeWalk then self.FootstepSoundTimerWalk = self.FootStepTimeWalk end
	if self.FootStepTimeRun then self.FootstepSoundTimerRun = self.FootStepTimeRun end
	if self.HitGroupFlinching_Values then self.FlinchHitGroupMap = self.HitGroupFlinching_Values end
	if self.HitGroupFlinching_DefaultWhenNotHit != nil then self.FlinchHitGroupPlayDefault = self.HitGroupFlinching_DefaultWhenNotHit end
	if self.NextFlinchTime != nil then self.FlinchCooldown = self.NextFlinchTime end
	if self.NextCallForHelpTime then self.CallForHelpCooldown = self.NextCallForHelpTime end
	if self.CallForHelpAnimationFaceEnemy != nil then self.CallForHelpAnimFaceEnemy = self.CallForHelpAnimationFaceEnemy end
	if self.NextCallForHelpAnimationTime != nil then self.CallForHelpAnimCooldown = self.NextCallForHelpAnimationTime end
	if self.InvestigateSoundDistance != nil then self.InvestigateSoundMultiplier = self.InvestigateSoundDistance end
	if self.SoundTbl_OnKilledEnemy != nil then self.SoundTbl_KilledEnemy = self.SoundTbl_OnKilledEnemy end
	if self.HasOnKilledEnemySounds != nil then self.HasKilledEnemySounds = self.HasOnKilledEnemySounds end
	if self.OnKilledEnemySoundChance then self.KilledEnemySoundChance = self.OnKilledEnemySoundChance end
	if self.NextSoundTime_OnKilledEnemy then self.NextSoundTime_KilledEnemy = self.NextSoundTime_OnKilledEnemy end
	if self.OnKilledEnemySoundLevel then self.KilledEnemySoundLevel = self.OnKilledEnemySoundLevel end
	if self.OnKilledEnemySoundPitch != nil then self.KilledEnemySoundPitch = self.OnKilledEnemySoundPitch end
	if self.IdleSounds_PlayOnAttacks != nil then self.IdleSoundsWhileAttacking = self.IdleSounds_PlayOnAttacks end
	if self.HasOnReceiveOrderSounds != nil then self.HasReceiveOrderSounds = self.HasOnReceiveOrderSounds end
	if self.SoundTbl_OnReceiveOrder != nil then self.SoundTbl_ReceiveOrder = self.SoundTbl_OnReceiveOrder end
	if self.OnReceiveOrderSoundChance != nil then self.ReceiveOrderSoundChance = self.OnReceiveOrderSoundChance end
	if self.OnReceiveOrderSoundLevel != nil then self.ReceiveOrderSoundLevel = self.OnReceiveOrderSoundLevel end
	if self.OnReceiveOrderSoundPitch != nil then self.ReceiveOrderSoundPitch = self.OnReceiveOrderSoundPitch end
	if self.SoundTbl_MedicAfterHeal != nil then self.SoundTbl_MedicOnHeal = self.SoundTbl_MedicAfterHeal end
	if self.MedicAfterHealSoundChance != nil then self.MedicOnHealSoundChance = self.MedicAfterHealSoundChance end
	if self.BeforeHealSoundLevel != nil then self.MedicBeforeHealSoundLevel = self.BeforeHealSoundLevel end
	if self.AfterHealSoundLevel != nil then self.MedicOnHealSoundLevel = self.AfterHealSoundLevel end
	if self.BeforeHealSoundPitch != nil then self.MedicBeforeHealSoundPitch = self.BeforeHealSoundPitch end
	if self.AfterHealSoundPitch != nil then self.MedicOnHealSoundPitch = self.AfterHealSoundPitch end
	if self.Immune_Physics then self:SetPhysicsDamageScale(0) end
	if self.StopMeleeAttackAfterFirstHit != nil then self.MeleeAttackStopOnHit = self.StopMeleeAttackAfterFirstHit end
	if self.DisableMeleeAttackAnimation == true then self.AnimTbl_MeleeAttack = false end
	if self.Passive_RunOnDamage == false then self.DamageResponse = false end
	if self.HideOnUnknownDamage == false then self.DamageResponse = "OnlySearch" end
	if self.DisableTakeDamageFindEnemy == true then if self.HideOnUnknownDamage == false then self.DamageResponse = false else self.DamageResponse = "OnlyMove" end end
	if self.CanFlinch == 0 then self.CanFlinch = false
	elseif self.CanFlinch == 1 then self.CanFlinch = true
	elseif self.CanFlinch == 2 then self.CanFlinch = "DamageTypes" end
	if self.BringFriendsOnDeath != nil or self.AlertFriendsOnDeath != nil then
		if self.AlertFriendsOnDeath == true && (self.BringFriendsOnDeath == false or self.BringFriendsOnDeath == nil) then
			self.DeathAllyResponse = "OnlyAlert"
		elseif self.BringFriendsOnDeath == false && self.AlertFriendsOnDeath == false then
			self.DeathAllyResponse = false
		end
	end
	if self.BringFriendsOnDeathLimit then self.DeathAllyResponse_MoveLimit = self.BringFriendsOnDeathLimit end
	if self.VJC_Data then self.ControllerParams = self.VJC_Data end
	if self.HasCallForHelpAnimation == false then self.AnimTbl_CallForHelp = false end
	if self.Medic_DisableAnimation == true then self.AnimTbl_Medic_GiveHealth = false end
	if self.ConstantlyFaceEnemyDistance then self.ConstantlyFaceEnemy_MinDistance = self.ConstantlyFaceEnemyDistance end
	if self.CallForBackUpOnDamage != nil then self.DamageAllyResponse = self.CallForBackUpOnDamage end
	if self.NextCallForBackUpOnDamageTime then self.DamageAllyResponse_Cooldown = self.NextCallForBackUpOnDamageTime end
	if self.CallForBackUpOnDamageAnimation then self.AnimTbl_DamageAllyResponse = self.CallForBackUpOnDamageAnimation end
	if self.UseTheSameGeneralSoundPitch != nil then self.MainSoundPitchStatic = self.UseTheSameGeneralSoundPitch end
	if self.GeneralSoundPitch1 or self.GeneralSoundPitch2 then self.MainSoundPitch = VJ.SET(self.GeneralSoundPitch1 or 90, self.GeneralSoundPitch2 or 100) end
	if self.AlertedToIdleTime then self.AlertTimeout = self.AlertedToIdleTime end
	if self.SoundTbl_MoveOutOfPlayersWay then self.SoundTbl_YieldToPlayer = self.SoundTbl_MoveOutOfPlayersWay end
	if self.MaxJumpLegalDistance then self.JumpParams.MaxRise = self.MaxJumpLegalDistance.a; self.JumpParams.MaxDrop = self.MaxJumpLegalDistance.b end
	if self.VJ_IsHugeMonster then self.VJ_ID_Boss = self.VJ_IsHugeMonster end
	if self.Medic_HealthAmount then self.Medic_HealAmount = self.Medic_HealthAmount end
	if self.UsePlayerModelMovement then self.UsePoseParameterMovement = true end
	if self.MoveOutOfFriendlyPlayersWay != nil then self.YieldToAlliedPlayers = self.MoveOutOfFriendlyPlayersWay end
	if self.WaitBeforeDeathTime then self.DeathDelayTime = self.WaitBeforeDeathTime end
	if self.HasDeathRagdoll != nil then self.HasDeathCorpse = self.HasDeathRagdoll end
	if self.AllowedToGib != nil then self.CanGib = self.AllowedToGib end
	if self.HasGibOnDeath != nil then self.CanGibOnDeath = self.HasGibOnDeath end
	if self.HasGibDeathParticles != nil then self.HasGibOnDeathEffects = self.HasGibDeathParticles else self.HasGibDeathParticles = self.HasGibOnDeathEffects end
	if self.HasItemDropsOnDeath != nil then self.DropDeathLoot = self.HasItemDropsOnDeath end
	if self.ItemDropsOnDeathChance != nil then self.DeathLootChance = self.ItemDropsOnDeathChance end
	if self.ItemDropsOnDeath_EntityList != nil then self.DeathLoot = self.ItemDropsOnDeath_EntityList end
	if self.AllowMovementJumping != nil then self.JumpParams.Enabled = self.AllowMovementJumping end
	if self.OnlyDoKillEnemyWhenClear != nil then self.KilledEnemySoundLast = self.OnlyDoKillEnemyWhenClear end
	if self.DisableFootStepOnWalk then self.FootstepSoundTimerWalk = false end
	if self.DisableFootStepOnRun then self.FootstepSoundTimerRun = false end
	if self.FindEnemy_UseSphere then self.SightAngle = 360 end
	if self.IsMedicSNPC then self.IsMedic = self.IsMedicSNPC end
	if self.BecomeEnemyToPlayer == true then self.BecomeEnemyToPlayer = self.BecomeEnemyToPlayerLevel or 2 end
	if self.CustomBlood_Particle then self.BloodParticle = self.CustomBlood_Particle end
	if self.CustomBlood_Pool then self.BloodPool = self.CustomBlood_Pool end
	if self.CustomBlood_Decal then self.BloodDecal = self.CustomBlood_Decal end
	if self.GibOnDeathDamagesTable then
		for _, v in ipairs(self.GibOnDeathDamagesTable) do
			if v == "All" then
				self.GibOnDeathFilter = false
			end
		end
	end
	if self.SetUpGibesOnDeath then
		self.HandleGibOnDeath = function(_, dmginfo, hitgroup)
			local gibbed, overrides = self:SetUpGibesOnDeath(dmginfo, hitgroup)
			local tbl = {}
			if overrides then
				if overrides.AllowCorpse then tbl.AllowCorpse = true end
				if overrides.DeathAnim then tbl.AllowAnim = true end
			end
			if self.CustomGibOnDeathSounds && !self:CustomGibOnDeathSounds(dmginfo, hitgroup) then
				tbl.AllowSound = false
			end
			return gibbed, tbl
		end
	end
	if self.CustomOnDoKilledEnemy then
		self.OnKilledEnemy = function(_, ent, inflictor, wasLast)
			if (self.KilledEnemySoundLast == false) or (self.KilledEnemySoundLast == true && wasLast) then
				self:CustomOnDoKilledEnemy(ent, self, inflictor)
			end
		end
	end
	if self.CustomOnMedic_BeforeHeal or self.CustomOnMedic_OnHeal or self.CustomOnMedic_OnReset then
		self.OnMedicBehavior = function(_, status, statusData)
			if status == "BeforeHeal" && self.CustomOnMedic_BeforeHeal then
				self:CustomOnMedic_BeforeHeal()
			elseif status == "OnHeal" && self.CustomOnMedic_OnHeal then
				return self:CustomOnMedic_OnHeal(statusData)
			elseif status == "OnReset" && self.CustomOnMedic_OnReset then
				self:CustomOnMedic_OnReset()
			end
		end
	end
	if self.CustomOnTakeDamage_BeforeImmuneChecks or self.CustomOnTakeDamage_BeforeDamage or self.CustomOnTakeDamage_AfterDamage then
		self.OnDamaged = function(_, dmginfo, hitgroup, status)
			if status == "Init" && self.CustomOnTakeDamage_BeforeImmuneChecks then
				self:CustomOnTakeDamage_BeforeImmuneChecks(dmginfo, hitgroup)
			elseif status == "PreDamage" && self.CustomOnTakeDamage_BeforeDamage then
				self:CustomOnTakeDamage_BeforeDamage(dmginfo, hitgroup)
			elseif status == "PostDamage" && self.CustomOnTakeDamage_AfterDamage then
				self:CustomOnTakeDamage_AfterDamage(dmginfo, hitgroup)
			end
		end
	end
	if self.CustomOnFlinch_BeforeFlinch or self.CustomOnFlinch_AfterFlinch then
		self.OnFlinch = function(_, dmginfo, hitgroup, status)
			if status == "Init" then
				if self.CustomOnFlinch_BeforeFlinch then
					return !self:CustomOnFlinch_BeforeFlinch(dmginfo, hitgroup)
				end
			elseif status == "Execute" then
				if self.CustomOnFlinch_AfterFlinch then
					self:CustomOnFlinch_AfterFlinch(dmginfo, hitgroup)
				end
			end
		end
	end
	if self.CustomOnInitialKilled or self.CustomOnPriorToKilled or self.CustomDeathAnimationCode or self.CustomOnKilled or self.CustomOnDeath_BeforeCorpseSpawned then
		self.OnDeath = function(_, dmginfo, hitgroup, status)
			if status == "Init" then
				if self.CustomOnInitialKilled then
					self:CustomOnInitialKilled(dmginfo, hitgroup)
				end
				if self.CustomOnPriorToKilled then
					self:CustomOnPriorToKilled(dmginfo, hitgroup)
				end
			elseif status == "DeathAnim" && self.CustomDeathAnimationCode then
				self:CustomDeathAnimationCode(dmginfo, hitgroup)
			elseif status == "Finish" then
				if self.CustomOnKilled then
					self:CustomOnKilled(dmginfo, hitgroup)
				end
				if self.CustomOnDeath_BeforeCorpseSpawned then
					self:CustomOnDeath_BeforeCorpseSpawned(dmginfo, hitgroup)
				end
			end
		end
	end
	if self.HasWorldShakeOnMove && !self.OnFootstepSound then -- Only do this if "self.OnFootstepSound" isn't already being used
		self.OnFootstepSound = function()
			util.ScreenShake(self:GetPos(), self.WorldShakeOnMoveAmplitude or 10, self.WorldShakeOnMoveFrequency or 100, self.WorldShakeOnMoveDuration or 0.4, self.WorldShakeOnMoveRadius or 1000)
		end
	end
	if self.DeathCorpseSkin && self.DeathCorpseSkin != -1 then
		local orgFunc = self.OnCreateDeathCorpse
		self.OnCreateDeathCorpse = function(_, dmginfo, hitgroup, corpse)
			orgFunc(self, dmginfo, hitgroup, corpse)
			corpse:SetSkin(self.DeathCorpseSkin)
		end
	end
	if self.CustomOnTouch then
		self.OnTouch = function(_, ent)
			self:CustomOnTouch(ent)
		end
	end
	if self.CustomAttackCheck_MeleeAttack or self.CustomOnMeleeAttack_BeforeStartTimer or self.CustomOnMeleeAttack_AfterStartTimer then
		self.OnMeleeAttack = function(_, status, enemy)
			if status == "PreInit" && self.CustomAttackCheck_MeleeAttack then
				return !self:CustomAttackCheck_MeleeAttack(enemy)
			elseif status == "Init" && self.CustomOnMeleeAttack_BeforeStartTimer then
				self:CustomOnMeleeAttack_BeforeStartTimer(self.AttackSeed)
			elseif status == "PostInit" && self.CustomOnMeleeAttack_AfterStartTimer then
				self:CustomOnMeleeAttack_AfterStartTimer(self.AttackSeed)
			end
		end
	end
	if self.DisableDefaultMeleeAttackCode or self.MeleeAttackWorldShakeOnMiss or self.CustomOnMeleeAttack_BeforeChecks or self.CustomOnMeleeAttack_AfterChecks or self.CustomOnMeleeAttack_Miss then
		self.OnMeleeAttackExecute = function(_, status, ent, isProp)
			if status == "Init" && (self.CustomOnMeleeAttack_BeforeChecks or self.DisableDefaultMeleeAttackCode) then
				if self.CustomOnMeleeAttack_BeforeChecks then
					self:CustomOnMeleeAttack_BeforeChecks()
				end
				if self.DisableDefaultMeleeAttackCode then
					return true
				end
			elseif status == "PreDamage" && self.CustomOnMeleeAttack_AfterChecks then
				return self:CustomOnMeleeAttack_AfterChecks(ent, isProp)
			elseif status == "Miss" && (self.CustomOnMeleeAttack_Miss or self.MeleeAttackWorldShakeOnMiss) then
				if self.CustomOnMeleeAttack_Miss then
					self:CustomOnMeleeAttack_Miss()
				end
				if self.MeleeAttackWorldShakeOnMiss then
					util.ScreenShake(self:GetPos(), self.MeleeAttackWorldShakeOnMissAmplitude or 16, 100, self.MeleeAttackWorldShakeOnMissDuration or 1, self.MeleeAttackWorldShakeOnMissRadius or 2000)
				end
			end
		end
	end
	if self.GetMeleeAttackDamageOrigin then
		self.MeleeAttackTraceOrigin = function()
			return self:GetMeleeAttackDamageOrigin()
		end
	end
	
	-- Base specific
	if self.IsVJBaseSNPC_Creature then
		if self.SlowPlayerOnMeleeAttack then self.MeleeAttackPlayerSpeed = true end
		if self.SlowPlayerOnMeleeAttack_WalkSpeed then self.MeleeAttackPlayerSpeedWalk = self.SlowPlayerOnMeleeAttack_WalkSpeed end
		if self.SlowPlayerOnMeleeAttack_RunSpeed then self.MeleeAttackPlayerSpeedRun = self.SlowPlayerOnMeleeAttack_RunSpeed end
		if self.SlowPlayerOnMeleeAttackTime then self.MeleeAttackPlayerSpeedTime = self.SlowPlayerOnMeleeAttackTime end
		if self.HasMeleeAttackSlowPlayerSound != nil then self.HasMeleeAttackPlayerSpeedSounds = self.HasMeleeAttackSlowPlayerSound end
		if self.SoundTbl_MeleeAttackSlowPlayer != nil then self.SoundTbl_MeleeAttackPlayerSpeed = self.SoundTbl_MeleeAttackSlowPlayer end
		if self.MeleeAttackSlowPlayerSoundLevel != nil then self.MeleeAttackPlayerSpeedSoundLevel = self.MeleeAttackSlowPlayerSoundLevel end
		if self.StopLeapAttackAfterFirstHit != nil then self.LeapAttackStopOnHit = self.StopLeapAttackAfterFirstHit end
		if self.NextLeapAttackTime_DoRand then self.NextLeapAttackTime = VJ.SET(self.NextLeapAttackTime, self.NextLeapAttackTime_DoRand) end
		if self.NextAnyAttackTime_Leap_DoRand then self.NextAnyAttackTime_Leap = VJ.SET(self.NextAnyAttackTime_Leap, self.NextAnyAttackTime_Leap_DoRand) end
		if self.NextRangeAttackTime_DoRand then self.NextRangeAttackTime = VJ.SET(self.NextRangeAttackTime, self.NextRangeAttackTime_DoRand) end
		if self.NextAnyAttackTime_Range_DoRand then self.NextAnyAttackTime_Range = VJ.SET(self.NextAnyAttackTime_Range, self.NextAnyAttackTime_Range_DoRand) end
		if self.MeleeAttackDSPSoundType != nil then self.MeleeAttackDSP = self.MeleeAttackDSPSoundType end
		if self.MeleeAttackDSPSoundUseDamage == false then self.MeleeAttackDSPLimit = false end
		if self.MeleeAttackDSPSoundUseDamageAmount then self.MeleeAttackDSPLimit = self.MeleeAttackDSPSoundUseDamageAmount end
		if self.DisableRangeAttackAnimation == true then self.AnimTbl_RangeAttack = false end
		if self.DisableLeapAttackAnimation == true then self.AnimTbl_LeapAttack = false end
		if self.RangeAttackEntityToSpawn then self.RangeAttackProjectiles = self.RangeAttackEntityToSpawn end
		if self.RangeDistance then self.RangeAttackMaxDistance = self.RangeDistance end
		if self.RangeToMeleeDistance then self.RangeAttackMinDistance = self.RangeToMeleeDistance end
		if self.LeapDistance then self.LeapAttackMaxDistance = self.LeapDistance end
		if self.LeapToMeleeDistance then self.LeapAttackMinDistance = self.LeapToMeleeDistance end
		if self.RangeAttackPitch then self.RangeAttackSoundPitch = self.RangeAttackPitch end
		if self.PropAP_MaxSize then self.PropInteraction_MaxScale = self.PropAP_MaxSize end
		if self.AttackProps == false or self.PushProps == false then
			if self.AttackProps == false && self.PushProps == false then
				self.PropInteraction = false
			elseif self.AttackProps == false then
				self.PropInteraction = "OnlyPush"
			elseif self.PushProps == false then
				self.PropInteraction = "OnlyDamage"
			end
		end
		if self.NoChaseAfterCertainRange then self.LimitChaseDistance = self.NoChaseAfterCertainRange end
		if self.NoChaseAfterCertainRange_CloseDistance then self.LimitChaseDistance_Min = self.NoChaseAfterCertainRange_CloseDistance end
		if self.NoChaseAfterCertainRange_FarDistance then self.LimitChaseDistance_Max = self.NoChaseAfterCertainRange_FarDistance end
		if self.NoChaseAfterCertainRange_Type then
			if self.NoChaseAfterCertainRange_Type == "Regular" then
				self.LimitChaseDistance = true
			elseif self.NoChaseAfterCertainRange_Type == "OnlyRange" then
				self.LimitChaseDistance = "OnlyRange"
			end
		end
		if self.MeleeAttackKnockBack_Forward1 or self.MeleeAttackKnockBack_Forward2 or self.MeleeAttackKnockBack_Up1 or self.MeleeAttackKnockBack_Up2 then
			self.MeleeAttackKnockbackVelocity = function()
				return self:GetForward()*math.random(self.MeleeAttackKnockBack_Forward1 or 100, self.MeleeAttackKnockBack_Forward2 or 100) + self:GetUp()*math.random(self.MeleeAttackKnockBack_Up1 or 10, self.MeleeAttackKnockBack_Up2 or 10) + self:GetRight()*math.random(self.MeleeAttackKnockBack_Right1 or 0, self.MeleeAttackKnockBack_Right2 or 0)
			end
		end
		if self.RangeUseAttachmentForPos then
			self.RangeAttackProjPos = function(_, projectile)
				return self:GetAttachment(self:LookupAttachment(self.RangeUseAttachmentForPosID)).Pos
			end
		elseif self.RangeAttackPos_Up or self.RangeAttackPos_Forward or self.RangeAttackPos_Right then
			self.RangeAttackProjPos = function(_, projectile)
				return self:GetPos() + self:GetUp()*(self.RangeAttackPos_Up or 20) + self:GetForward()*(self.RangeAttackPos_Forward or 0) + self:GetRight()*(self.RangeAttackPos_Right or 0)
			end
		end
		if self.RangeAttackCode_GetShootPos then
			self.RangeAttackProjVel = function(_, projectile)
				return self.RangeAttackCode_GetShootPos(self, projectile)
			end
		end
		if self.LeapAttackVelocityForward or self.LeapAttackVelocityUp or self.CustomAttackCheck_LeapAttack or self.CustomOnLeapAttack_BeforeStartTimer or self.CustomOnLeapAttack_AfterStartTimer then
			self.OnLeapAttack = function(_, status, enemy)
				if status == "PreInit" && self.CustomAttackCheck_LeapAttack then
					return !self:CustomAttackCheck_LeapAttack(enemy)
				elseif status == "Init" && self.CustomOnLeapAttack_BeforeStartTimer then
					self:CustomOnLeapAttack_BeforeStartTimer(self.AttackSeed)
				elseif status == "PostInit" && self.CustomOnLeapAttack_AfterStartTimer then
					self:CustomOnLeapAttack_AfterStartTimer(self.AttackSeed)
				elseif status == "Jump" && (self.LeapAttackVelocityForward or self.LeapAttackVelocityUp) then
					local ene = funcGetEnemy(self)
					return ((ene:GetPos() + ene:OBBCenter()) - (self:GetPos() + self:OBBCenter())):GetNormal()*400 + self:GetForward()*(self.LeapAttackVelocityForward or 2000) + self:GetUp()*(self.LeapAttackVelocityUp or 200)
				end
			end
		end
		if self.CustomOnLeapAttack_BeforeChecks or self.CustomOnLeapAttack_AfterChecks or self.CustomOnLeapAttack_Miss then
			self.OnLeapAttackExecute = function(_, status, ent)
				if status == "Init" && self.CustomOnLeapAttack_BeforeChecks then
					self:CustomOnLeapAttack_BeforeChecks()
				elseif status == "PreDamage" && self.CustomOnLeapAttack_AfterChecks then
					self:CustomOnLeapAttack_AfterChecks(ent)
				elseif status == "Miss" && self.CustomOnLeapAttack_Miss then
					self:CustomOnLeapAttack_Miss()
				end
			end
		end
		if self.CustomAttack or self.MultipleMeleeAttacks or self.MultipleRangeAttacks or self.MultipleLeapAttacks then
			self.OnThinkAttack = function(_, isAttacking, enemy)
				if self.CustomAttack then self:CustomAttack(enemy, self.EnemyData.Visible) end
				if isAttacking then return end
				if self.MultipleMeleeAttacks then self:MultipleMeleeAttacks() end
				if self.MultipleRangeAttacks then self:MultipleRangeAttacks() end
				if self.MultipleLeapAttacks then self:MultipleLeapAttacks() end
			end
		end
		if self.CustomAttackCheck_RangeAttack or self.CustomOnRangeAttack_BeforeStartTimer or self.CustomOnRangeAttack_AfterStartTimer then
			self.OnRangeAttack = function(_, status, enemy)
				if status == "PreInit" && self.CustomAttackCheck_RangeAttack then
					return !self:CustomAttackCheck_RangeAttack(enemy)
				elseif status == "Init" && self.CustomOnRangeAttack_BeforeStartTimer then
					self:CustomOnRangeAttack_BeforeStartTimer(self.AttackSeed)
				elseif status == "PostInit" && self.CustomOnRangeAttack_AfterStartTimer then
					self:CustomOnRangeAttack_AfterStartTimer(self.AttackSeed)
				end
			end
		end
		if self.DisableDefaultRangeAttackCode or self.CustomRangeAttackCode or self.CustomRangeAttackCode_BeforeProjectileSpawn or self.CustomRangeAttackCode_AfterProjectileSpawn then
			self.OnRangeAttackExecute = function(_, status, enemy, projectile)
				if status == "Init" && (self.CustomRangeAttackCode or self.DisableDefaultRangeAttackCode) then
					if self.CustomRangeAttackCode then
						self:CustomRangeAttackCode()
					end
					if self.DisableDefaultRangeAttackCode then
						return true
					end
				elseif status == "PreSpawn" && self.CustomRangeAttackCode_BeforeProjectileSpawn then
					self:CustomRangeAttackCode_BeforeProjectileSpawn(projectile)
				elseif status == "PostSpawn" && self.CustomRangeAttackCode_AfterProjectileSpawn then
					self:CustomRangeAttackCode_AfterProjectileSpawn(projectile)
				end
			end
		end
	elseif self.IsVJBaseSNPC_Human then
		if self.CustomOnMoveRandomlyWhenShooting then self.OnWeaponStrafe = function() return self:CustomOnMoveRandomlyWhenShooting() end end
		if self.CustomOnWeaponReload then self.OnWeaponReload = function() self:CustomOnWeaponReload() end end
		if self.CustomOnWeaponAttack then self.OnWeaponAttack = function() self:CustomOnWeaponAttack() end end
		if self.CustomOnDropWeapon then self.OnDeathWeaponDrop = function(_, dmginfo, hitgroup, wepEnt) self:CustomOnDropWeapon(dmginfo, hitgroup, wepEnt) end end
		if self.MoveRandomlyWhenShooting != nil then self.Weapon_Strafe = self.MoveRandomlyWhenShooting end
		if self.GrenadeAttackThrowDistance then self.GrenadeAttackMaxDistance = self.GrenadeAttackThrowDistance end
		if self.GrenadeAttackThrowDistanceClose then self.GrenadeAttackMinDistance = self.GrenadeAttackThrowDistanceClose end
		if self.NextThrowGrenadeTime != nil then self.NextGrenadeAttackTime = self.NextThrowGrenadeTime end
		if self.TimeUntilGrenadeIsReleased != nil then self.GrenadeAttackThrowTime = self.TimeUntilGrenadeIsReleased end
		if self.NextMoveRandomlyWhenShootingTime1 or self.NextMoveRandomlyWhenShootingTime2 then self.Weapon_StrafeCooldown = VJ.SET(self.NextMoveRandomlyWhenShootingTime1 or 3, self.NextMoveRandomlyWhenShootingTime2 or 6) end
		if self.WaitForEnemyToComeOut != nil then self.Weapon_OcclusionDelay = self.WaitForEnemyToComeOut end
		if self.WaitForEnemyToComeOutTime then self.Weapon_OcclusionDelayTime = self.WaitForEnemyToComeOutTime end
		if self.MoveOrHideOnDamageByEnemy != nil then self.CombatDamageResponse = self.MoveOrHideOnDamageByEnemy end
		if self.MoveOrHideOnDamageByEnemy_HideTime then self.CombatDamageResponse_CoverTime = self.MoveOrHideOnDamageByEnemy_HideTime end
		if self.DisableWeaponFiringGesture == true then self.AnimTbl_WeaponAttackGesture = false end
		if self.CanThrowBackDetectedGrenades != nil then self.CanRedirectGrenades = self.CanThrowBackDetectedGrenades end
		if self.OnGrenadeSightSoundLevel != nil then self.DangerSightSoundLevel = self.OnGrenadeSightSoundLevel end
		if self.SoundTbl_OnDangerSight != nil then self.SoundTbl_DangerSight = self.SoundTbl_OnDangerSight end
		if self.SoundTbl_OnGrenadeSight != nil then self.SoundTbl_GrenadeSight = self.SoundTbl_OnGrenadeSight end
		if self.Weapon_FiringDistanceClose then self.Weapon_MinDistance = self.Weapon_FiringDistanceClose end
		if self.Weapon_FiringDistanceFar then self.Weapon_MaxDistance = self.Weapon_FiringDistanceFar end
		if self.DisableWeapons != nil then self.Weapon_Disabled = self.DisableWeapons end
		if self.HasShootWhileMoving == false then self.Weapon_CanMoveFire = false end
		if self.HasWeaponBackAway == false then self.Weapon_RetreatDistance = 0 end
		if self.WeaponBackAway_Distance then self.Weapon_RetreatDistance = self.WeaponBackAway_Distance end
		if self.WeaponSpread then self.Weapon_Accuracy = self.WeaponSpread end
		if self.AllowWeaponReloading != nil then self.Weapon_CanReload = self.AllowWeaponReloading end
		if self.WeaponReload_FindCover != nil then self.Weapon_FindCoverOnReload = self.WeaponReload_FindCover end
		if self.ThrowGrenadeChance then self.GrenadeAttackChance = self.ThrowGrenadeChance end
		if self.NoWeapon_UseScaredBehavior != nil then self.Weapon_UnarmedBehavior = self.NoWeapon_UseScaredBehavior end
		if self.CanCrouchOnWeaponAttack != nil then self.Weapon_CanCrouchAttack = self.CanCrouchOnWeaponAttack end
		if self.CanCrouchOnWeaponAttackChance != nil then self.Weapon_CrouchAttackChance = self.CanCrouchOnWeaponAttackChance end
		if self.AnimTbl_WeaponAttackFiringGesture != nil then self.AnimTbl_WeaponAttackGesture = self.AnimTbl_WeaponAttackFiringGesture end
		if self.CanUseSecondaryOnWeaponAttack != nil then self.Weapon_CanSecondaryFire = self.CanUseSecondaryOnWeaponAttack end
		if self.WeaponAttackSecondaryTimeUntilFire != nil then self.Weapon_SecondaryFireTime = self.WeaponAttackSecondaryTimeUntilFire end
		if self.CustomAttack then
			self.OnThinkAttack = function(_, isAttacking, enemy)
				if self.CustomAttack then self:CustomAttack(enemy, self.EnemyData.Visible) end
			end
		end
	end
end