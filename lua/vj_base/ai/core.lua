/*--------------------------------------------------
	*** Copyright (c) 2012-2023 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.

	///// NOTES \\\\\
	- This file contains functions and variables shared between all the NPC bases.
	- There are useful functions that are commonly called when making custom code in an NPC. (Custom-Friendly Functions)
	- There are also functions that should be called with caution in a custom code. (General Functions)
--------------------------------------------------*/
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
##     ##    ###    ########  ####    ###    ########  ##       ########  ######
##     ##   ## ##   ##     ##  ##    ## ##   ##     ## ##       ##       ##    ##
##     ##  ##   ##  ##     ##  ##   ##   ##  ##     ## ##       ##       ##
##     ## ##     ## ########   ##  ##     ## ########  ##       ######    ######
 ##   ##  ######### ##   ##    ##  ######### ##     ## ##       ##             ##
  ## ##   ##     ## ##    ##   ##  ##     ## ##     ## ##       ##       ##    ##
   ###    ##     ## ##     ## #### ##     ## ########  ######## ########  ######
*/
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Localized static values
local NPCTbl_Animals = {npc_barnacle=true,npc_crow=true,npc_pigeon=true,npc_seagull=true,monster_cockroach=true}
local NPCTbl_Combine = {npc_stalker=true,npc_rollermine=true,npc_turret_ground=true,npc_turret_floor=true,npc_turret_ceiling=true,npc_strider=true,npc_sniper=true,npc_metropolice=true,npc_hunter=true,npc_breen=true,npc_combine_camera=true,npc_combine_s=true,npc_combinedropship=true,npc_combinegunship=true,npc_cscanner=true,npc_clawscanner=true,npc_helicopter=true,npc_manhack=true}
local NPCTbl_Zombies = {npc_fastzombie_torso=true,npc_zombine=true,npc_zombie_torso=true,npc_zombie=true,npc_poisonzombie=true,npc_headcrab_fast=true,npc_headcrab_black=true,npc_headcrab=true,npc_fastzombie=true,monster_zombie=true,monster_headcrab=true,monster_babycrab=true}
local NPCTbl_Antlions = {npc_antlion=true,npc_antlionguard=true,npc_antlion_worker=true}
local NPCTbl_Xen = {monster_bullchicken=true,monster_alien_grunt=true,monster_alien_slave=true,monster_alien_controller=true,monster_houndeye=true,monster_gargantua=true,monster_nihilanth=true}
local defPos = Vector(0, 0, 0)
local defAng = Angle(0, 0, 0)
local CurTime = CurTime
local IsValid = IsValid
local GetConVar = GetConVar
local istable = istable
local isnumber = isnumber
local isvector = isvector
local string_sub = string.sub
local table_remove = table.remove
local bAND = bit.band
local math_rad = math.rad
local math_cos = math.cos
local math_clamp = math.Clamp
local varCPly = "CLASS_PLAYER_ALLY"
local varCAnt = "CLASS_ANTLION"
local varCCom = "CLASS_COMBINE"
local varCXen = "CLASS_XEN"
local varCZom = "CLASS_ZOMBIE"
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
 ######  ##     ##  ######  ########  #######  ##     ##         ######## ########  #### ######## ##    ## ########  ##       ##    ##    ######## ##     ## ##    ##  ######  ######## ####  #######  ##    ##  ######
##    ## ##     ## ##    ##    ##    ##     ## ###   ###         ##       ##     ##  ##  ##       ###   ## ##     ## ##        ##  ##     ##       ##     ## ###   ## ##    ##    ##     ##  ##     ## ###   ## ##    ##
##       ##     ## ##          ##    ##     ## #### ####         ##       ##     ##  ##  ##       ####  ## ##     ## ##         ####      ##       ##     ## ####  ## ##          ##     ##  ##     ## ####  ## ##
##       ##     ##  ######     ##    ##     ## ## ### ## ####### ######   ########   ##  ######   ## ## ## ##     ## ##          ##       ######   ##     ## ## ## ## ##          ##     ##  ##     ## ## ## ##  ######
##       ##     ##       ##    ##    ##     ## ##     ##         ##       ##   ##    ##  ##       ##  #### ##     ## ##          ##       ##       ##     ## ##  #### ##          ##     ##  ##     ## ##  ####       ##
##    ## ##     ## ##    ##    ##    ##     ## ##     ##         ##       ##    ##   ##  ##       ##   ### ##     ## ##          ##       ##       ##     ## ##   ### ##    ##    ##     ##  ##     ## ##   ### ##    ##
 ######   #######   ######     ##     #######  ##     ##         ##       ##     ## #### ######## ##    ## ########  ########    ##       ##        #######  ##    ##  ######     ##    ####  #######  ##    ##  ######
*/
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Creates a extra corpse entity, use this function to create extra corpse entities when the NPC is killed
		- class = The object class to use, common types: "prop_ragdoll", "prop_physics"
		- models = Model(s) to use, can be a table which it will pick randomly from it OR a string | "None" = Doesn't set a model
		- extraOptions = Table that holds extra options to modify parts of the code
			- Pos = Sets the spawn position
			- Ang = Sets the spawn angle
			- Vel = Sets the velocity | "UseDamageForce" = To use the damage's force only | DEFAULT = Uses damage force
			- HasVel = If set to false, it won't set any velocity, allowing you to code your own in customFunc | DEFAULT = true
			- ShouldFade = Should it fade away after certain time | DEFAULT = false
			- ShouldFadeTime = How much time until the entity fades away | DEFAULT = 0
			- RemoveOnCorpseDelete = Should the entity get removed if the corpse is removed? | DEFAULT = true
		- customFunc(gib) = Use this to edit the entity which is given as parameter "gib"
-----------------------------------------------------------]]
local colorGrey = Color(90, 90, 90)
--
function ENT:CreateExtraDeathCorpse(class, models, extraOptions, customFunc)
	-- Should only be ran after self.Corpse has been created!
	if !IsValid(self.Corpse) then return end
	local dmginfo = self.Corpse.DamageInfo
	if dmginfo == nil then return end
	class = class or "prop_ragdoll"
	extraOptions = extraOptions or {}
	local ent = ents.Create(class)
	if models != "None" then ent:SetModel(VJ.PICK(models)) end
	ent:SetPos(extraOptions.Pos or self:GetPos())
	ent:SetAngles(extraOptions.Ang or self:GetAngles())
	ent:Spawn()
	ent:Activate()
	ent:SetColor(self.Corpse:GetColor())
	ent:SetMaterial(self.Corpse:GetMaterial())
	ent:SetCollisionGroup(self.DeathCorpseCollisionType)
	if self.Corpse:IsOnFire() then
		ent:Ignite(math.Rand(8,10),0)
		ent:SetColor(colorGrey)
	end
	if extraOptions.HasVel != false then
		local dmgForce = (self.SavedDmgInfo.force / 40) + self:GetMoveVelocity() + self:GetVelocity()
		if self.DeathAnimationCodeRan then
			dmgForce = self:GetMoveVelocity() == defPos and self:GetGroundSpeedVelocity() or self:GetMoveVelocity()
		end
		ent:GetPhysicsObject():AddVelocity(extraOptions.Vel or dmgForce)
	end
	if extraOptions.ShouldFade == true then
		local fadeTime = extraOptions.ShouldFadeTime or 0 
		if ent:GetClass() == "prop_ragdoll" then
			ent:Fire("FadeAndRemove", "", fadeTime)
		else
			ent:Fire("kill", "", fadeTime)
		end
	end
	if extraOptions.RemoveOnCorpseDelete != false then //self.Corpse:DeleteOnRemove(ent)
		self.Corpse.ChildEnts[#self.Corpse.ChildEnts + 1] = ent
	end
	if (customFunc) then customFunc(ent) end
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Creates a gib entity, use this function to create gib!
		- class = The object class to use, recommended to use "obj_vj_gib", and for ragdoll type of gib use "prop_ragdoll"
		- models = Model(s) to use, can be a table which it will pick randomly from it OR a string
			- Defined strings: "UseAlien_Small", "UseAlien_Big", "UseHuman_Small", "UseHuman_Big"
		- extraOptions = Table that holds extra options to modify parts of the code
			- Pos = Sets the spawn position
			- Ang = Sets the spawn angle | DEFAULT = Random angle
			- Vel = Sets the velocity | "UseDamageForce" = To use the damage's force only | DEFAULT = Random velocity
			- Vel_ApplyDmgForce = If set to false, it won't add the damage force to the given velocity | DEFAULT = true
			- AngVel = Angle velocity, basically the speed it rotates as it's flying | DEFAULT = Random velocity
			- BloodDecal = Decal it spawns when it collides with something | DEFAULT = Base decides
			- BloodType = Sets the blood type by overriding the BloodDecal option | Works only on "obj_vj_gib" and it uses the same values as a VJ NPC blood types!
			- CollideSound = The sound it plays when it collides with something | DEFAULT = Base decides
			- NoFade = Should it let the base make it fade & remove (Adjusted in the SNPC settings menu) | DEFAULT = false
			- RemoveOnCorpseDelete = Should the entity get removed if the corpse is removed? | DEFAULT = false
		- customFunc(gib) = Use this to edit the entity which is given as parameter "gib"
-----------------------------------------------------------]]
local gib_mdlAAll = {"models/gibs/xenians/sgib_01.mdl","models/gibs/xenians/sgib_02.mdl","models/gibs/xenians/sgib_03.mdl","models/gibs/xenians/mgib_01.mdl","models/gibs/xenians/mgib_02.mdl","models/gibs/xenians/mgib_03.mdl","models/gibs/xenians/mgib_04.mdl","models/gibs/xenians/mgib_05.mdl","models/gibs/xenians/mgib_06.mdl","models/gibs/xenians/mgib_07.mdl"}
local gib_mdlASmall = {"models/gibs/xenians/sgib_01.mdl","models/gibs/xenians/sgib_02.mdl","models/gibs/xenians/sgib_03.mdl"}
local gib_mdlABig = {"models/gibs/xenians/mgib_01.mdl","models/gibs/xenians/mgib_02.mdl","models/gibs/xenians/mgib_03.mdl","models/gibs/xenians/mgib_04.mdl","models/gibs/xenians/mgib_05.mdl","models/gibs/xenians/mgib_06.mdl","models/gibs/xenians/mgib_07.mdl"}
local gib_mdlHSmall = {"models/gibs/humans/sgib_01.mdl","models/gibs/humans/sgib_02.mdl","models/gibs/humans/sgib_03.mdl"}
local gib_mdlHBig = {"models/gibs/humans/mgib_01.mdl","models/gibs/humans/mgib_02.mdl","models/gibs/humans/mgib_03.mdl","models/gibs/humans/mgib_04.mdl","models/gibs/humans/mgib_05.mdl","models/gibs/humans/mgib_06.mdl","models/gibs/humans/mgib_07.mdl"}
--
function ENT:CreateGibEntity(class, models, extraOptions, customFunc)
	// self:CreateGibEntity("prop_ragdoll", "", {Pos=self:LocalToWorld(Vector(0,3,0)), Ang=self:GetAngles(), Vel=})
	if self.AllowedToGib == false then return end
	local bloodType = false
	class = class or "obj_vj_gib"
	if models == "UseAlien_Small" then
		models =  VJ.PICK(gib_mdlASmall)
		bloodType = "Yellow"
	elseif models == "UseAlien_Big" then
		models =  VJ.PICK(gib_mdlABig)
		bloodType = "Yellow"
	elseif models == "UseHuman_Small" then
		models =  VJ.PICK(gib_mdlHSmall)
		bloodType = "Red"
	elseif models == "UseHuman_Big" then
		models =  VJ.PICK(gib_mdlHBig)
		bloodType = "Red"
	else -- Custom models
		models = VJ.PICK(models)
		if VJ.HasValue(gib_mdlAAll, models) then
			bloodType = "Yellow"
		end
	end
	extraOptions = extraOptions or {}
		local vel = extraOptions.Vel or Vector(math.Rand(-100, 100), math.Rand(-100, 100), math.Rand(150, 250))
		if self.SavedDmgInfo then
			local dmgForce = self.SavedDmgInfo.force / 70
			if extraOptions.Vel_ApplyDmgForce != false && extraOptions.Vel != "UseDamageForce" then -- Use both damage force AND given velocity
				vel = vel + dmgForce
			elseif extraOptions.Vel == "UseDamageForce" then -- Use damage force
				vel = dmgForce
			end
		end
		bloodType = (extraOptions.BloodType or bloodType or self.BloodColor) -- Certain entities such as the VJ Gib entity, you can use this to set its gib type
		local removeOnCorpseDelete = extraOptions.RemoveOnCorpseDelete or false -- Should the entity get removed if the corpse is removed?
	local gib = ents.Create(class)
	gib:SetModel(models)
	gib:SetPos(extraOptions.Pos or (self:GetPos() + self:OBBCenter()))
	gib:SetAngles(extraOptions.Ang or Angle(math.Rand(-180, 180), math.Rand(-180, 180), math.Rand(-180, 180)))
	if gib:GetClass() == "obj_vj_gib" then
		gib.BloodType = bloodType
		gib.Collide_Decal = extraOptions.BloodDecal or "Default"
		gib.CollideSound = extraOptions.CollideSound or "Default"
		//gib.BloodData = {Color = bloodType, Particle = self.CustomBlood_Particle, Decal = self.Collide_Decal} -- For eating system
	end
	gib:Spawn()
	gib:Activate()
	gib.IsVJBaseCorpse_Gib = true
	if GetConVar("vj_npc_gibcollidable"):GetInt() == 0 then gib:SetCollisionGroup(1) end
	local phys = gib:GetPhysicsObject()
	if IsValid(phys) then
		phys:AddVelocity(vel)
		phys:AddAngleVelocity(extraOptions.AngVel or Vector(math.Rand(-200, 200), math.Rand(-200, 200), math.Rand(-200, 200)))
	end
	if extraOptions.NoFade != true && GetConVar("vj_npc_fadegibs"):GetInt() == 1 then
		if gib:GetClass() == "obj_vj_gib" then timer.Simple(GetConVar("vj_npc_fadegibstime"):GetInt(), function() SafeRemoveEntity(gib) end)
		elseif gib:GetClass() == "prop_ragdoll" then gib:Fire("FadeAndRemove", "", GetConVar("vj_npc_fadegibstime"):GetInt())
		elseif gib:GetClass() == "prop_physics" then gib:Fire("kill", "", GetConVar("vj_npc_fadegibstime"):GetInt()) end
	end
	if removeOnCorpseDelete == true then //self.Corpse:DeleteOnRemove(extraent)
		if !self.DeathCorpse_ChildEnts then self.DeathCorpse_ChildEnts = {} end -- If it doesn't exist, then create it!
		self.DeathCorpse_ChildEnts[#self.DeathCorpse_ChildEnts + 1] = gib
	end
	if (customFunc) then customFunc(gib) end
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
		- statusInfo = Status info to pass to "CustomOnEat" (info types defined in that function)
-----------------------------------------------------------]]
function ENT:EatingReset(statusInfo)
	local eatingData = self.EatingData
	self:SetState(VJ_STATE_NONE)
	self:CustomOnEat("StopEating", statusInfo)
	self.VJTag_IsEating = false
	self:SetIdleAnimation(eatingData.OldIdleTbl, true) -- Reset the idle animation table in case it changed!
	local food = eatingData.Ent
	if IsValid(food) then
		local foodData = food.FoodData
		-- if we are the last person eating, then reset the food data!
		if foodData.NumConsumers <= 1 then
			food.VJTag_IsBeingEaten = false
			foodData.NumConsumers = 0
			foodData.SizeRemaining = foodData.Size
		else
			foodData.NumConsumers = foodData.NumConsumers - 1
			foodData.SizeRemaining = foodData.SizeRemaining + self:OBBMaxs():Distance(self:OBBMins())
		end
	end
	self.EatingData = {Ent = NULL, NextCheck = eatingData.NextCheck, AnimStatus = "None", OldIdleTbl = nil}
	-- AnimStatus: "None" = Not prepared (Probably moving to food location) | "Prepared" = Prepared (Ex: Played crouch down anim) | "Eating" = Prepared and is actively eating
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Called every time a change occurs in the eating system
		- status = The change that occurred, possible changes:
			- "CheckFood"		= Possible food found, check if it's good
			- "StartBehavior"	= Food found, start the eating behavior
			- "BeginEating"		= Food location reached
			- "Eat"				= Actively eating food
			- "StopEating"		= Food may have moved, removed, or finished
		- statusInfo = Some status may have extra info, possible infos:
			- "CheckFood": SoundHintData table, more info: https://wiki.facepunch.com/gmod/Structures/SoundHintData
			- "StopEating":
				- "HaltOnly"	= This is ONLY a halt, not complete reset!		| Recommendation: Play normal get up anim
				- "Unspecified"	= Ex: Food suddenly removed or moved far away	| Recommendation: Play normal get up anim
				- "Devoured"	= Has completely devoured the food!				| Recommendation: Play normal get up anim and play a sound
				- "Enemy"		= Has been alerted or detected an enemy			| Recommendation: Play scared get up anim
				- "Injured"		= Has been injured by something					| Recommendation: Play scared get up anim
				- "Dead"		= Has died, usually called in "OnRemove"		| Recommendation: Do NOT play any animation!
	Returns
		- Boolean, ONLY used for "CheckFood", returning true will tell the base the possible food is valid
		- Number, Delay to add before moving to another status, useful to make sure animations aren't cut off!
-----------------------------------------------------------]]
local vecZ50 = Vector(0, 0, -50)
--
function ENT:CustomOnEat(status, statusInfo)
	-- The following code is a ideal example based on Half-Life 1 Zombie
	//print(self, "Eating Status: ", status, statusInfo)
	if status == "CheckFood" then
		return true //statusInfo.owner.BloodData && statusInfo.owner.BloodData.Color == "Red"
	elseif status == "BeginEating" then
		self:SetIdleAnimation({ACT_GESTURE_RANGE_ATTACK1}, true)
		return select(2, self:VJ_ACT_PLAYACTIVITY(ACT_ARM, true, false))
	elseif status == "Eat" then
		VJ.EmitSound(self, "barnacle/bcl_chew"..math.random(1, 3)..".wav", 55)
		-- Health changes
		local food = self.EatingData.Ent
		local damage = 15 -- How much damage food will receive
		local foodHP = food:Health() -- Food's health
		local myHP = self:Health() -- NPC's current health
		self:SetHealth(math.Clamp(myHP + ((damage > foodHP and foodHP) or damage), myHP, self:GetMaxHealth() < myHP and myHP or self:GetMaxHealth())) -- Give health to the NPC
		food:SetHealth(foodHP - damage) -- Decrease corpse health
		-- Blood effects
		local bloodData = food.BloodData
		if bloodData then
			local bloodPos = food:GetPos() + food:OBBCenter()
			local bloodParticle = VJ.PICK(bloodData.Particle)
			if bloodParticle then
				ParticleEffect(bloodParticle, bloodPos, self:GetAngles())
			end
			local bloodDecal = VJ.PICK(bloodData.Decal)
			if bloodDecal then
				local tr = util.TraceLine({start = bloodPos, endpos = bloodPos + vecZ50, filter = {food, self}})
				util.Decal(bloodDecal, tr.HitPos + tr.HitNormal + Vector(math.random(-45, 45), math.random(-45, 45), 0), tr.HitPos - tr.HitNormal, food)
			end
		end
		return 2 -- Eat every this seconds
	elseif status == "StopEating" then
		if statusInfo != "Dead" && self.EatingData.AnimStatus != "None" then -- Do NOT play anim while dead or has NOT prepared to eat
			return select(2, self:VJ_ACT_PLAYACTIVITY(ACT_DISARM, true, false))
		end
	end
	return 0
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Sets the NPC's idle animation table
		- anims = Table with animation(s)
		- reset = Should it reset the idle animation?
-----------------------------------------------------------]]
function ENT:SetIdleAnimation(anims, reset)
	self.AnimTbl_IdleStand = anims
	if reset then
		self.CurrentIdleAnimation = -1
		//self.NextIdleStandTime = 0
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Checks if the NPC is playing an animation that shouldn't be interrupted OR is playing an attack!
	NAV_JUMP & NAV_CLIMB is based on "IsInterruptable()" from engine: https://github.com/ValveSoftware/source-sdk-2013/blob/master/mp/src/game/server/ai_navigator.h#L397
	Returns
		- false, NOT busy
		- true, Busy
-----------------------------------------------------------]]
function ENT:BusyWithActivity()
	return self.vACT_StopAttacks or self.CurrentAttackAnimationTime > CurTime() or self:GetNavType() == NAV_JUMP or self:GetNavType() == NAV_CLIMB
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Checks if the NPC is busy with advanced behaviors like following player or moving to heal an ally
	Returns
		- false, NOT busy
		- true, Busy
-----------------------------------------------------------]]
function ENT:IsBusyWithBehavior()
	return self.FollowData.Moving or self.Medic_Status
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Checks if the NPC is busy with an animation or activity AND if it's busy with an advanced behavior
	Returns
		- false, NOT busy
		- true, Busy
-----------------------------------------------------------]]
function ENT:IsBusy()
	return self:BusyWithActivity() or self:IsBusyWithBehavior()
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
		self:VJ_TASK_IDLE_STAND()
	end
	if time >= 0 then
		timer.Create("timer_state_reset"..self:EntIndex(), time, 1, function()
			self:SetState()
		end)
	else
		timer.Remove("timer_state_reset"..self:EntIndex())
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
	Checks the relationship with the given entity | Use with caution, it can reduce performance!
		- ent = The entity to check its relation with
	Returns
		- Disposition value, list: https://wiki.facepunch.com/gmod/Enums/D
-----------------------------------------------------------]]
function ENT:CheckRelationship(ent)
	if ent.VJ_AlwaysEnemyToEnt == self then return D_HT end -- Always enemy to me (Used by the bullseye under certain circumstances)
	if ent:IsFlagSet(FL_NOTARGET) or ent.VJ_NoTarget or NPCTbl_Animals[ent:GetClass()] then return D_NU end
	if self:GetClass() == ent:GetClass() then return D_LI end
	if ent:Health() > 0 && self:Disposition(ent) != D_LI then
		local isPly = ent:IsPlayer()
		if isPly && VJ_CVAR_IGNOREPLAYERS then return D_NU end
		if VJ.HasValue(self.VJ_AddCertainEntityAsFriendly, ent) then return D_LI end
		if VJ.HasValue(self.VJ_AddCertainEntityAsEnemy, ent) then return D_HT end
		local entDisp = ent.Disposition and ent:Disposition(self)
		if (ent:IsNPC() && ((entDisp == D_HT) or (entDisp == D_NU && ent.VJ_IsBeingControlled))) or (isPly && !self.PlayerFriendly && ent:Alive()) then
			return D_HT
		else
			return D_NU
		end
	end
	return D_LI
end
-- !!!!!!!!!!!!!! DO NOT USE THESE !!!!!!!!!!!!!! [Backwards Compatibility!]
local dispToVal = {[D_LI] = false, [D_HT] = true, [D_NU] = "Neutral"}
function ENT:DoRelationshipCheck(ent) return dispToVal[self:CheckRelationship(ent)] end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Helps you decide the pitch for the NPC, very useful for speech-type of sounds!
		- pitch1 = Random min, set to false to self.GeneralSoundPitch1 | DEFAULT = self.GeneralSoundPitch1
		- pitch2 = Random max, set to false to self.GeneralSoundPitch2 | DEFAULT = self.GeneralSoundPitch2
		NOTE: if self.UseTheSameGeneralSoundPitch is true then the default values will be self.UseTheSameGeneralSoundPitch_PickedNumber
	Returns
		- Number, the randomized number between pitch1 & pitch2
-----------------------------------------------------------]]
function ENT:VJ_DecideSoundPitch(pitch1, pitch2)
	local finalPitch1 = self.GeneralSoundPitch1
	local finalPitch2 = self.GeneralSoundPitch2
	local pickedNum = self.UseTheSameGeneralSoundPitch_PickedNumber
	-- If the NPC is set to use the same sound pitch all the time and it's not 0 then use that pitch
	if self.UseTheSameGeneralSoundPitch == true && pickedNum != 0 then
		finalPitch1 = pickedNum
		finalPitch2 = pickedNum
	end
	if pitch1 != false && isnumber(pitch1) then finalPitch1 = pitch1 end
	if pitch2 != false && isnumber(pitch2) then finalPitch2 = pitch2 end
	return math.random(finalPitch1, finalPitch2)
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Gets the forward vector that the NPC is moving towards and returns it
		- ignoreZ = Ignores the Z axis of the direction during calculations | DEFAULT = false
	Returns
		- Vector, direction the NPC is moving towards
		- false, currently NOT moving
-----------------------------------------------------------]]
function ENT:GetMoveDirection(ignoreZ)
	if !self:IsMoving() then return false end
	local myPos = self:GetPos()
	local dir = ((self:GetCurWaypointPos() or myPos) - myPos)
	if ignoreZ then dir.z = 0 end
	return (self:GetAngles() - dir:Angle()):Forward()
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Gets all the pose the parameters of the NPC and returns it.
		- prt = Prints the pose parameters
	Returns
		- table of all the pose parameters
-----------------------------------------------------------]]
function ENT:GetPoseParameters(prt)
	local result = {}
	for i = 0, self:GetNumPoseParameters() - 1 do
		if prt == true then
			local min, max = self:GetPoseParameterRange(i)
			print(self:GetPoseParameterName(i)..' '..min.." / "..max)
		end
		table.insert(result, self:GetPoseParameterName(i))
	end
	return result
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetFaceAngle(ang)
	return self.TurningUseAllAxis and ang or Angle(0, ang.y, 0)
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Resets the current turn target
-----------------------------------------------------------]]
function ENT:ResetTurnTarget()
	self.TurnData.Type = VJ.NPC_FACE_NONE
	self.TurnData.Target = nil
	self.TurnData.StopOnFace = false
	self.TurnData.IsSchedule = false
	self.TurnData.LastYaw = 0
	timer.Remove("timer_turning"..self:EntIndex())
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
	if (self.MovementType == VJ_MOVETYPE_STATIONARY && !self.CanTurnWhileStationary) then return false end
	local resultAng = false -- The final angle it's going to face
	local updateTurn = true -- An override to disallow applying the angle now
	-- Enemy facing
	if target == "Enemy" then
		//print("Face: ENEMY")
		self:ResetTurnTarget()
		local ene = self:GetEnemy()
		-- If enemy is valid do normal facing otherwise return my angles because we didn't actually face an enemy
		if IsValid(ene) then
			resultAng = self:GetFaceAngle((ene:GetPos() - self:GetPos()):Angle())
		else
			resultAng = self:GetFaceAngle(self:GetAngles())
			updateTurn = false
		end
		if faceTime != 0 then -- 0 = Face only this frame, so don't actually set turning data!
			self.TurnData.Type = visibleOnly and VJ.NPC_FACE_ENEMY_VISIBLE or VJ.NPC_FACE_ENEMY
		end
	-- Vector facing
	elseif isvector(target) then
		//print("Face: VECTOR")
		self:ResetTurnTarget()
		resultAng = self:GetFaceAngle((target - self:GetPos()):Angle())
		if faceTime != 0 then -- 0 = Face only this frame, so don't actually set turning data!
			self.TurnData.Type = visibleOnly and VJ.NPC_FACE_POSITION_VISIBLE or VJ.NPC_FACE_POSITION
			self.TurnData.Target = target
		end
	-- Entity facing
	elseif IsValid(target) then
		//print("Face: ENTITY")
		self:ResetTurnTarget()
		resultAng = self:GetFaceAngle((target:GetPos() - self:GetPos()):Angle())
		if faceTime != 0 then -- 0 = Face only this frame, so don't actually set turning data!
			self.TurnData.Type = visibleOnly and VJ.NPC_FACE_ENTITY_VISIBLE or VJ.NPC_FACE_ENTITY
			self.TurnData.Target = target
		end
	end
	if resultAng then
		if updateTurn then
			if self.TurningUseAllAxis == true then
				local myAng = self:GetAngles()
				self:SetAngles(LerpAngle(FrameTime()*self.TurningSpeed, myAng, Angle(resultAng.p, myAng.y, resultAng.r)))
			end
			self:SetIdealYawAndUpdate(resultAng.y)
			//if self:IsSequenceFinished() then self:UpdateTurnActivity() end
		else -- Only set it, do NOT update it!
			self:SetIdealYaw(resultAng.y)
		end
		if faceTime != 0 then -- 0 = Face only this frame, so don't actually set turning data!
			self.TurnData.StopOnFace = stopOnFace or false
			self.TurnData.LastYaw = resultAng.y
			if faceTime != -1 then -- -1 = Face forever and never reset unless overridden
				timer.Create("timer_turning"..self:EntIndex(), faceTime or 0, 1, function()
					self:ResetTurnTarget()
				end)
			end
		end
	end
	return resultAng
end
-- !!!!!!!!!!!!!! DO NOT USE THESE FUNCTIONS !!!!!!!!!!!!!! [Backwards Compatibility!]
function ENT:FaceCertainPosition(target, faceTime) return self:SetTurnTarget(target, faceTime, false, false) end
function ENT:FaceCertainEntity(target, faceCurEnemy, faceTime) return self:SetTurnTarget(faceCurEnemy and "Enemy" or target, faceTime, false, false) end
---------------------------------------------------------------------------------------------------------------------------------------------
-- Based on: https://github.com/ValveSoftware/source-sdk-2013/blob/master/sp/src/game/server/ai_motor.cpp#L780
function ENT:DeltaIdealYaw()
    local    flCurrentYaw;
    flCurrentYaw = (360 / 65536) * (math.floor(self:GetLocalAngles().y * (65536 / 360)) % 65535)
    if flCurrentYaw == self:GetIdealYaw() then
        return 0;
    end
    return math.AngleDifference(self:GetIdealYaw(), flCurrentYaw)
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Get the position set by the function "self:SetLastPosition(vec)""
	Returns
		- Vector, the last position
-----------------------------------------------------------]]
function ENT:GetLastPosition()
	return self:GetInternalVariable("m_vecLastPosition")
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Get the aim position of the given entity for the NPC to aim at | EX: Position the NPC should fire at
		- target = The entity to aim at
		- aimOrigin = The starting point of the aim | EX: Muzzle of a gun the NPC is holding
		- predictionRate = Predication rate | DEFAULT = 0
			-- <= 0 : No prediction   |   0 < to > 1 : Closer to target   |   1 : Perfect prediction   |   1 < : Ahead of the prediction (will be very ahead/inaccurate)
		- projectileSpeed = Used if prediction is being used, helps it properly calculate the predicted aim position | DEFAULT = 1
	Returns
		- Vector, the best aim position it found | Normalize this return to get the aim direction!
-----------------------------------------------------------]]
function ENT:GetAimPosition(target, aimOrigin, predictionRate, projectileSpeed)
	local result;
	if self:Visible(target) then
		result = target:BodyTarget(aimOrigin)
		if target:IsPlayer() then -- Decrease player's Z axis as it's placed very high by the engine
			result.z = result.z - 15
		end
		if !self:VisibleVec(result) then
			result = target:HeadTarget(aimOrigin)
		end
	else -- If not visible, use the last known position!
		result = self.EnemyData.LastVisiblePos
		predictionRate = 0 -- Enemy is not visible, do NOT predict!
	end
	if (predictionRate or 0) > 0 then -- If prediction is enabled
		-- 1. Calculate the distance between the origin and enemy position
		-- 2. Calculate the time it takes for the projectile to reach the enemy
		-- 3. Calculate the predicted enemy position based on their current position and velocity
		result = result + (target:GetMovementVelocity() * ((aimOrigin - result):Length() / (projectileSpeed or 1))) * predictionRate
	end
	return result
end
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
		-- Other modifiers
		13. Multiply it by the owner's weapon accuracy (WeaponSpread)
		14. Apply the modifier parameter, if any
-----------------------------------------------------------]]
-- To convert division to multiplication do (1 / division_number) | NOTE: Multiplication a bit faster!
local aimMaxDist = 0.0000001 -- Distance at which the bullet spread is at its max (most inaccurate) | Equivalent = Dividing by 10000000
local aimMaxMove = 0.0000001 -- Move speed at which the bullet spread is at its max (most inaccurate) | Equivalent = Dividing by 10000000
local damageCooldown = 4 -- Cooldown time in seconds, amount of time until this modifier no longer affects the spread
--
function ENT:CalcAimSpread(target, goalPos, modifier)
	local result = math.min(self:GetPos():DistToSqr(goalPos) * aimMaxDist, 0.05) -- Target distance modifier
	if target then
		result = result + math.min(target:GetMovementVelocity():LengthSqr() * aimMaxMove, 0.05) -- Target movement modifier
		result = result * (2.5 - math.min((CurTime() - self:GetLastDamageTime()) / damageCooldown, 1.5)) -- Suppression modifier (Inverse effect over time)
	end
	return result * (self.WeaponSpread or 1) * modifier
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
			self:SetLastPosition(baseEnt:GetPos() + baseEnt:GetForward()*spacing + baseEnt:GetRight()*spacing)
		elseif it == 1 then
			self:SetLastPosition(baseEnt:GetPos() + baseEnt:GetForward()*-spacing + baseEnt:GetRight()*spacing)
		elseif it == 2 then
			self:SetLastPosition(baseEnt:GetPos() + baseEnt:GetForward()*spacing + baseEnt:GetRight()*-spacing)
		elseif it == 3 then
			self:SetLastPosition(baseEnt:GetPos() + baseEnt:GetForward()*-spacing + baseEnt:GetRight()*-spacing)
		else
			self:SetLastPosition(baseEnt:GetPos() + baseEnt:GetForward()*(spacing + (3 * it)) + baseEnt:GetRight()*(spacing + (3 * it)))
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Checks if the front of the NPC can be used to take cover.
		- startPos = Start position of the trace | DEFAULT = Center of the NPC
		- endPos = End position of the trace | DEFAULT = Enemy's eye position
		- acceptWorld = If it hits the world, it will accept it as a cover | DEFAULT = false
		- extraOptions = Table that holds extra options to modify parts of the code
			- SetLastHiddenTime = If true, it will reset the "LastHidden" time, which makes the NPC stick to a position if it's well covered | DEFAULT = false
			- Debug = Used for debugging, spawns a cube at the hit position and prints the trace result | DEFAULT = false
	Returns 2 values
		- 1:
			- true, Hidden
			- false, NOT hidden
		- 2:
			- Table, trace result
-----------------------------------------------------------]]
function ENT:VJ_ForwardIsHidingZone(startPos, endPos, acceptWorld, extraOptions)
	local ene = self:GetEnemy()
	if !IsValid(ene) then return false, {} end
	startPos = startPos or self:GetPos() + self:OBBCenter()
	endPos = endPos or ene:EyePos()
	acceptWorld = acceptWorld or false
	extraOptions = extraOptions or {}
		local setLastHiddenTime = extraOptions.SetLastHiddenTime or false
	local tr = util.TraceLine({
		start = startPos,
		endpos = endPos,
		filter = self
	})
	local hitPos = tr.HitPos
	local hitEnt = tr.Entity
	if extraOptions.Debug == true then
		print("--------------------------------------------")
		PrintTable(tr)
		VJ.DEBUG_TempEnt(hitPos)
	end
	-- Sometimes the trace isn't 100%, a tiny find in sphere check fixes this issue...
	local sphereInvalidate = false
	for _,v in ipairs(ents.FindInSphere(hitPos, 5)) do
		if v == ene or v:IsNPC() or v:IsPlayer() then
			sphereInvalidate = true
		end
	end
	
	-- Not a hiding zone: (Sphere found an enemy/NPC/Player) OR (Trace ent is an enemy/NPC/Player) OR (End pos is far from the hit position) OR (World is NOT accepted as a hiding zone)
	if sphereInvalidate or (IsValid(hitEnt) && (hitEnt == ene or hitEnt:IsNPC() or hitEnt:IsPlayer() or hitEnt:GetVelocity():LengthSqr() > 1000)) or endPos:Distance(hitPos) <= 10 or (acceptWorld == false && tr.HitWorld == true) then
		if setLastHiddenTime == true then self.LastHiddenZoneT = 0 end
		return false, tr
	-- Hiding zone: It hit world AND it's close, override "acceptWorld" option!
	elseif tr.HitWorld == true && self:GetPos():Distance(hitPos) < 200 then
		if setLastHiddenTime == true then self.LastHiddenZoneT = CurTime() + 20 end
		return true, tr
	else -- Hidden!
		if setLastHiddenTime == true then self.LastHiddenZoneT = CurTime() + 20 end
		return true, tr
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Checks all 4 sides around the NPC
		- checkDist = How far should each trace go? | DEFAULT = 200
		- returnPos = Instead of returning a table of sides, it will return a table of actual positions | DEFAULT: false
			- Use this whenever possible as it is much more optimized to utilize!
		- sides = Use this to disable checking certain positions by setting the 1 to 0, "Forward-Backward-Right-Left" | DEFAULT = "1111"
	Returns
		- When returnPos is true:
			- Table of positions (4 max)
		- When returnPos is false:
			- Table dictionary, includes 4 values, if true then that side isn't blocked!
				- Values: Forward, Backward, Right, Left
-----------------------------------------------------------]]
local str1111 = "1111"
local str1 = "1"
--
function ENT:VJ_CheckAllFourSides(checkDist, returnPos, sides)
	checkDist = checkDist or 200
	sides = sides or str1111
	local result = returnPos == true and {} or {Forward=false, Backward=false, Right=false, Left=false}
	local i = 0
	local myPos = self:GetPos()
	local myPosCentered = myPos + self:OBBCenter()
	local myForward = self:GetForward()
	local myRight = self:GetRight()
	local positions = { -- Set the positions that we need to check
		string_sub(sides, 1, 1) == str1 and myForward or 0,
		string_sub(sides, 2, 2) == str1 and -myForward or 0,
		string_sub(sides, 3, 3) == str1 and myRight or 0,
		string_sub(sides, 4, 4) == str1 and -myRight or 0
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
			if returnPos == true then
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
--[[---------------------------------------------------------
	Sets the enemy for the NPC, this function should always be used over the default GMod self:SetEnemy()!
		- ent = The entity to set as the enemy
		- stopMoving = Should it stop moving? Will not run if doQuickIfActiveEnemy passes! | DEFAULT = false
		- doQuickIfActiveEnemy = Runs a quicker set enemy without resetting everything, it must have a active enemy! | DEFAULT = false
-----------------------------------------------------------]]
function ENT:VJ_DoSetEnemy(ent, stopMoving, doQuickIfActiveEnemy)
	if !IsValid(ent) or self.Behavior == VJ_BEHAVIOR_PASSIVE_NATURE or ent:Health() <= 0 or (ent:IsPlayer() && (!ent:Alive() or VJ_CVAR_IGNOREPLAYERS)) then return end
	if IsValid(self.Medic_CurrentEntToHeal) && self.Medic_CurrentEntToHeal == ent then self:DoMedicReset() end
	local eneData = self.EnemyData
	eneData.TimeSet = CurTime()
	self:AddEntityRelationship(ent, D_HT, 0)
	self:UpdateEnemyMemory(ent, ent:GetPos())
	self:SetNPCState(NPC_STATE_COMBAT)
	if doQuickIfActiveEnemy && IsValid(self:GetEnemy()) then
		self:SetEnemy(ent)
		return -- End it here if it's a minor set enemy
	end
	self:SetEnemy(ent)
	eneData.TimeSinceAcquired = CurTime()
	//self.NextResetEnemyT = CurTime() + 0.5 //2
	if stopMoving then
		self:ClearGoal()
		self:StopMoving()
	end
	if self.Alerted == false then
		self.LatestEnemyDistance = self:GetPos():Distance(ent:GetPos())
		self:DoAlert(ent)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Forces the NPC to jump.
		- vel = Velocity for the jump
	EX: Force the NPC to jump to the location of another entity:
		self:ForceMoveJump((activator:GetPos() - self:GetPos()):GetNormal()*200 + Vector(0, 0, 300))
-----------------------------------------------------------]]
function ENT:ForceMoveJump(vel)
	self.NextIdleStandTime = 0
	self:SetNavType(NAV_JUMP)
	self:MoveJumpStart(vel)
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Checks if the given damage type(s) contains 1 or more of the default gibbing damage types.
		- dmgType = The damage type(s) to check for
			EX: dmginfo:GetDamageType()
	Returns
		- true, At least 1 damage type is included
		- false, NO damage type is included
-----------------------------------------------------------]]
// - DMG_DIRECT = Disabled because fire uses it!
// - DMG_ALWAYSGIB = Make sure damage is NOT a bullet because GMod sets DMG_ALWAYSGIB randomly for certain bullets (Maybe if the damage is high?)
function ENT:IsDefaultGibDamageType(dmgType)
	return (bAND(dmgType, DMG_ALWAYSGIB) != 0 && bAND(dmgType, DMG_BULLET) == 0) or bAND(dmgType, DMG_ENERGYBEAM) != 0 or bAND(dmgType, DMG_BLAST) != 0 or bAND(dmgType, DMG_VEHICLE) != 0 or bAND(dmgType, DMG_CRUSH) != 0 or bAND(dmgType, DMG_DISSOLVE) != 0 or bAND(dmgType, DMG_SLOWBURN) != 0 or bAND(dmgType, DMG_PHYSGUN) != 0 or bAND(dmgType, DMG_PLASMA) != 0 or bAND(dmgType, DMG_SONIC) != 0
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
	Time since the NPC has been damaged (Used CurTime!)
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
function ENT:SetImpactEnergyScale(scale)
	self:SetSaveValue("m_impactEnergyScale", scale)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:VJ_GetNearestPointToVector(pos, sameZ)
	-- sameZ = Should the Z of the result pos (resPos) be the same as my Z ?
	local myZ = self:GetPos().z
	local resMe = self:NearestPoint(pos + self:OBBCenter())
	resMe.z = myZ
	local resPos = pos
	resPos.z = sameZ and myZ or pos.z
	return resMe, resPos
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:VJ_GetNearestPointToEntity(ent, sameZ)
	-- sameZ = Should the Z of the other entity's result pos (resEnt) be the same as my Z ?
	local myNearPoint = self:GetDynamicOrigin()
	local resMe = self:NearestPoint(ent:GetPos() + self:OBBCenter())
	resMe.z = myNearPoint.z
	local resEnt = ent:NearestPoint(myNearPoint + ent:OBBCenter())
	resEnt.z = sameZ and myNearPoint.z or ent:GetPos().z
	return resMe, resEnt
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:VJ_GetNearestPointToEntityDistance(ent)
	local entPos = ent:GetPos()
	local myNearPoint = self:GetDynamicOrigin()
	local resMe = self:NearestPoint(entPos + self:OBBCenter())
	resMe.z = myNearPoint.z
	local resEnt = ent:NearestPoint(myNearPoint + ent:OBBCenter())
	resEnt.z = entPos.z
	return resEnt:Distance(resMe)
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Takes the given number and returns a scaled number according to the difficulty that NPC is set to
		- int = The number to scale
	Returns
		- number, the scaled number
-----------------------------------------------------------]]
function ENT:VJ_GetDifficultyValue(int)
	if self.SelectedDifficulty == -3 then
		return math_clamp(int - (int * 0.99), 1, int)
	elseif self.SelectedDifficulty == -2 then
		return math_clamp(int - (int * 0.75), 1, int)
	elseif self.SelectedDifficulty == -1 then
		return int / 2
	elseif self.SelectedDifficulty == 1 then
		return int + (int * 0.5)
	elseif self.SelectedDifficulty == 2 then
		return int * 2
	elseif self.SelectedDifficulty == 3 then
		return int + (int * 1.5)
	elseif self.SelectedDifficulty == 4 then
		return int + (int * 2.5)
	elseif self.SelectedDifficulty == 5 then
		return int + (int * 3.5)
	elseif self.SelectedDifficulty == 6 then
		return int + (int * 5.0)
	end
	return int -- Normal (default)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
 ######   ######## ##    ## ######## ########     ###    ##          ######## ##     ## ##    ##  ######  ######## ####  #######  ##    ##  ######
##    ##  ##       ###   ## ##       ##     ##   ## ##   ##          ##       ##     ## ###   ## ##    ##    ##     ##  ##     ## ###   ## ##    ##
##        ##       ####  ## ##       ##     ##  ##   ##  ##          ##       ##     ## ####  ## ##          ##     ##  ##     ## ####  ## ##
##   #### ######   ## ## ## ######   ########  ##     ## ##          ######   ##     ## ## ## ## ##          ##     ##  ##     ## ## ## ##  ######
##    ##  ##       ##  #### ##       ##   ##   ######### ##          ##       ##     ## ##  #### ##          ##     ##  ##     ## ##  ####       ##
##    ##  ##       ##   ### ##       ##    ##  ##     ## ##          ##       ##     ## ##   ### ##    ##    ##     ##  ##     ## ##   ### ##    ##
 ######   ######## ##    ## ######## ##     ## ##     ## ########    ##        #######  ##    ##  ######     ##    ####  #######  ##    ##  ######
*/
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
local vecZN100 = Vector(0, 0, -100)
--
function ENT:IsJumpLegal(startPos, apex, endPos)
	/*if !self.AllowMovementJumping then return false end
	local result = self:CustomOnIsJumpLegal(startPos, apex, endPos)
	if result != nil then
		return result
	end
	local dist_apex = startPos:Distance(apex)
	local dist_end = startPos:Distance(endPos)
	local maxDist = self.MaxJumpLegalDistance.a -- Var gam Ver | Arachin tive varva hamar ter
	-- Aravel = Ver, Nevaz = Var
	if (endPos.z - startPos.z) <= 0 then maxDist = self.MaxJumpLegalDistance.b end -- Ver bidi tsadke
	print("---------------------")
	print(endPos.z - startPos.z)
	print("Apex Dist: "..dist_apex)
	print("End Pos: "..dist_end)
	VJ.DEBUG_TempEnt(startPos, Angle(0,0,0), Color(0,255,0))
	VJ.DEBUG_TempEnt(apex, Angle(0,0,0), Color(255,115,0))
	VJ.DEBUG_TempEnt(endPos, Angle(0,0,0), Color(255,0,0))
	if (dist_apex > maxDist) or (dist_end > maxDist) then return false end
	return true*/
	
	if !self.AllowMovementJumping then return false end
	local jumpData = self.JumpVars
	if ((endPos.z - startPos.z) > jumpData.MaxRise) or ((apex.z - startPos.z) > jumpData.MaxRise) or ((startPos.z - endPos.z) > jumpData.MaxDrop) or (startPos:Distance(endPos) > jumpData.MaxDistance) then
		return false
	end
	local tr = util.TraceLine({
		start = endPos,
		endpos = endPos + vecZN100,
	})
	/*VJ.DEBUG_TempEnt(startPos, Angle(0,0,0), Color(0,255,0))
	VJ.DEBUG_TempEnt(apex, Angle(0,0,0), Color(255,115,0))
	VJ.DEBUG_TempEnt(endPos, Angle(0,0,0), Color(255,0,0))
	VJ.DEBUG_TempEnt(tr.HitPos, Angle(0,0,0), Color(132,0,255))*/
	if !tr.Hit then return false end
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnChangeActivity(newAct)
	//print(newAct)
	if newAct == ACT_TURN_LEFT or newAct == ACT_TURN_RIGHT then
		self.NextIdleStandTime = CurTime() + VJ.AnimDuration(self, self:GetSequenceName(self:GetSequence()))
		//self.NextIdleStandTime = CurTime() + 1.2
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:KeyValue(key, value)
	//print(self, key, value)
end
---------------------------------------------------------------------------------------------------------------------------------------------
local defIdleTbl = {ACT_IDLE}
--
// lua_run PrintTable(Entity(1):GetEyeTrace().Entity:GetTable())
function ENT:OnRestore()
	//print("RELOAD:", self)
	self:StopMoving()
	self:ResetMoveCalc()
	if !istable(self.AnimTbl_IdleStand) then self.AnimTbl_IdleStand = defIdleTbl end -- Resets to nil for some reason...
	-- Reset the current schedule because often times GMod attempts to run it before AI task modules have loaded!
	if self.CurrentSchedule then
		self.CurrentSchedule = nil
		self.CurrentTask = nil
		self.CurrentTaskID = nil
	end
	-- Readd the weapon think hook because the transition / save does NOT do it!
	local wep = self:GetActiveWeapon()
	if IsValid(wep) then
		hook.Add("Think", wep, wep.NPC_ServerNextFire)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:AcceptInput(key, activator, caller, data)
	//print(self, key, activator, caller, data)
	local funcCustom = self.CustomOnAcceptInput; if funcCustom then funcCustom(self, key, activator, caller, data) end
	if key == "Use" then
		if self.FollowPlayer then
			self:Follow(activator, true)
		end
	elseif key == "StartScripting" then
		self:SetState(VJ_STATE_FREEZE)
	elseif key == "StopScripting" then
		self:SetState(VJ_STATE_NONE)
	elseif key == "SetHealth" then
		self:SetHealth(data)
		self:SetMaxHealth(data)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HandleAnimEvent(ev, evTime, evCycle, evType, evOptions)
	//print(ev, evTime, evCycle, evType, evOptions)
	local funcCustom = self.CustomOnHandleAnimEvent; if funcCustom then funcCustom(self, ev, evTime, evCycle, evType, evOptions) end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Touch(entity)
	if self.VJ_DEBUG == true && GetConVar("vj_npc_printontouch"):GetInt() == 1 then print(self:GetClass().." Has Touched "..entity:GetClass()) end
	self:CustomOnTouch(entity)
	if GetConVar("ai_disabled"):GetInt() == 1 or self.VJ_IsBeingControlled then return end
	
	-- If it's a passive SNPC...
	if self.Behavior == VJ_BEHAVIOR_PASSIVE or self.Behavior == VJ_BEHAVIOR_PASSIVE_NATURE then
		if self.Passive_RunOnTouch == true && (entity:IsNPC() or entity:IsPlayer()) && CurTime() > self.TakingCoverT && entity.Behavior != VJ_BEHAVIOR_PASSIVE && entity.Behavior != VJ_BEHAVIOR_PASSIVE_NATURE && self:CheckRelationship(entity) != D_LI then
			self:VJ_TASK_COVER_FROM_ORIGIN("TASK_RUN_PATH")
			self:PlaySoundSystem("Alert")
			self.TakingCoverT = CurTime() + math.Rand(self.Passive_NextRunOnTouchTime.a, self.Passive_NextRunOnTouchTime.b)
			return
		end
	elseif self.DisableTouchFindEnemy == false && !IsValid(self:GetEnemy()) && self.IsFollowing == false && (entity:IsNPC() or entity:IsPlayer()) && self:CheckRelationship(entity) != D_LI then
		self:StopMoving()
		self:SetTarget(entity)
		self:VJ_TASK_FACE_X("TASK_FACE_TARGET")
		return
	end
	
	-- Handle "MoveOutOfFriendlyPlayersWay" system
	if self.MoveOutOfFriendlyPlayersWay && !self.IsGuard then
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
	Resets and stops following the current entity (If it's following any)
-----------------------------------------------------------]]
function ENT:FollowReset()
	local followData = self.FollowData
	local followEnt = followData.Ent
	if IsValid(followEnt) && followEnt:IsPlayer() && self.AllowPrintingInChat then
		if self.Dead then
			followEnt:PrintMessage(HUD_PRINTTALK, self:GetName().." has been killed.")
		else
			followEnt:PrintMessage(HUD_PRINTTALK, self:GetName().." is no longer following you.")
		end
	end
	self.IsFollowing = false
	self.FollowingPlayer = false
	followData.Ent = NULL -- Need to recall it here because localized can't update the table
	followData.MinDist = 0
	followData.Moving = false
	followData.StopAct = false
	followData.IsLiving = false
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Attempts to start following an entity, if it's already following another entity, it will return false!
		- ent = Entity to follow
		- stopIfFollowing = If true, it will stop following if it's already following the same entity
	Returns
		1 = Boolean
			- true, successfully started following the entity
			- false, failed or stopped following the entity
		2 = Failure reason (If it failed)
			0 = Unknown reason
			1 = NPC is stationary and unable to follow
			2 = NPC is already following another entity
			3 = NPC is hostile or neutral the entity
-----------------------------------------------------------]]
function ENT:Follow(ent, stopIfFollowing)
	if !IsValid(ent) or self.Dead or GetConVar("ai_disabled"):GetInt() == 1 or self == ent then return false, 0 end
	
	local isPly = ent:IsPlayer()
	local isLiving = isPly or ent:IsNPC() -- Is it a living entity?
	if (!isLiving) or (VJ.IsAlive(ent) && ((isPly && !VJ_CVAR_IGNOREPLAYERS) or (!isPly))) then
		local followData = self.FollowData
		-- Refusal messages
		if isLiving && self:GetClass() != ent:GetClass() && (self:Disposition(ent) == D_HT or self:Disposition(ent) == D_NU) then -- Check for enemy/neutral
			if isPly && self.AllowPrintingInChat then
				ent:PrintMessage(HUD_PRINTTALK, self:GetName().." isn't friendly to you, therefore it won't follow you.")
			end
			return false, 3
		elseif self.IsFollowing == true && ent != followData.Ent then -- Already following another entity
			if isPly && self.AllowPrintingInChat then
				ent:PrintMessage(HUD_PRINTTALK, self:GetName().." is already following another entity, therefore it won't follow you.")
			end
			return false, 2
		elseif self.MovementType == VJ_MOVETYPE_STATIONARY or self.MovementType == VJ_MOVETYPE_PHYSICS then
			if isPly && self.AllowPrintingInChat then
				ent:PrintMessage(HUD_PRINTTALK, self:GetName().." is currently stationary, therefore it's unable follow you.")
			end
			return false, 1
		end
		
		if !self.IsFollowing then
			if isPly then
				if self.AllowPrintingInChat then
					ent:PrintMessage(HUD_PRINTTALK, self:GetName().." is now following you.")
				end
				self.GuardingPosition = nil -- Reset the guarding position
				self.GuardingFacePosition = nil
				self.FollowingPlayer = true
				self:PlaySoundSystem("FollowPlayer")
			end
			followData.Ent = ent
			followData.MinDist = self.FollowMinDistance + (self:OBBMaxs().y * 3)
			followData.IsLiving = isLiving
			self.IsFollowing = true
			self:SetTarget(ent)
			if !self:BusyWithActivity() then -- Face the entity and then move to it
				self:StopMoving()
				self:VJ_TASK_FACE_X("TASK_FACE_TARGET", function(x)
					x.RunCode_OnFinish = function()
						if IsValid(self.FollowData.Ent) then
							self:VJ_TASK_GOTO_TARGET(((self:GetPos():Distance(self.FollowData.Ent:GetPos()) < (followData.MinDist * 1.5)) and "TASK_WALK_PATH") or "TASK_RUN_PATH", function(y) y.CanShootWhenMoving = true y.FaceData = {Type = VJ.NPC_FACE_ENEMY} end)
						end
					end
				end)
			end
			self:OnFollow("Start", ent)
			return true, 0
		elseif stopIfFollowing then -- Unfollow the entity
			if isPly then
				self:PlaySoundSystem("UnFollowPlayer")
			end
			self:StopMoving()
			self.NextWanderTime = CurTime() + 2
			if !self:BusyWithActivity() then
				self:VJ_TASK_FACE_X("TASK_FACE_TARGET")
			end
			self:FollowReset()
			self:OnFollow("Stop", ent)
		end
	end
	return false, 0
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoMedicReset()
	self:CustomOnMedic_OnReset()
	if IsValid(self.Medic_CurrentEntToHeal) then self.Medic_CurrentEntToHeal.VJTag_IsHealing = false end
	if IsValid(self.Medic_SpawnedProp) then self.Medic_SpawnedProp:Remove() end
	self.Medic_NextHealT = CurTime() + math.Rand(self.Medic_NextHealTime.a, self.Medic_NextHealTime.b)
	self.Medic_Status = false
	self.Medic_CurrentEntToHeal = NULL
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MaintainMedicBehavior()
	if !self.IsMedicSNPC or self.NoWeapon_UseScaredBehavior_Active then return end -- Do NOT heal if playing scared animations!
	if !self.Medic_Status then -- Not healing anyone, so check around for allies
		if CurTime() < self.Medic_NextHealT or self.VJ_IsBeingControlled then return end
		for _,v in ipairs(ents.FindInSphere(self:GetPos(), self.Medic_CheckDistance)) do
			-- Only allow VJ Base NPCs and players
			if (v.IsVJBaseSNPC or v:IsPlayer()) && v != self && !v.VJTag_IsHealing && !v.VJTag_ID_Vehicle && (v:Health() <= v:GetMaxHealth() * 0.75) && ((v.Medic_CanBeHealed == true && !IsValid(self:GetEnemy()) && !IsValid(v:GetEnemy())) or (v:IsPlayer() && !VJ_CVAR_IGNOREPLAYERS)) && self:CheckRelationship(v) == D_LI then
				self.Medic_CurrentEntToHeal = v
				self.Medic_Status = "Active"
				v.VJTag_IsHealing = true
				self:StopMoving()
				self:MaintainMedicBehavior()
				return
			end
		end
	elseif self.Medic_Status != "Healing" then
		local ally = self.Medic_CurrentEntToHeal
		if !IsValid(ally) or !VJ.IsAlive(ally) or (ally:Health() > ally:GetMaxHealth() * 0.75) then self:DoMedicReset() return end
		if self:Visible(ally) && self:VJ_GetNearestPointToEntityDistance(ally) <= self.Medic_HealDistance then -- Are we in healing distance?
			self.Medic_Status = "Healing"
			self:CustomOnMedic_BeforeHeal()
			self:PlaySoundSystem("MedicBeforeHeal")
			
			-- Spawn the prop
			if self.Medic_SpawnPropOnHeal == true && self:LookupAttachment(self.Medic_SpawnPropOnHealAttachment) != 0 then
				prop = ents.Create("prop_physics")
				prop:SetModel(self.Medic_SpawnPropOnHealModel)
				prop:SetLocalPos(self:GetPos())
				prop:SetOwner(self)
				prop:SetParent(self)
				prop:Fire("SetParentAttachment", self.Medic_SpawnPropOnHealAttachment)
				prop:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
				prop:Spawn()
				prop:Activate()
				prop:SetSolid(SOLID_NONE)
				//prop:AddEffects(EF_BONEMERGE)
				prop:SetRenderMode(RENDERMODE_TRANSALPHA)
				self:DeleteOnRemove(prop)
				self.Medic_SpawnedProp = prop
			end
			
			-- Handle the heal time and animation
			local timeUntilHeal = self.Medic_TimeUntilHeal
			if !self.Medic_DisableAnimation then
				local _, animTime = self:VJ_ACT_PLAYACTIVITY(self.AnimTbl_Medic_GiveHealth, true, self.Medic_TimeUntilHeal or false)
				timeUntilHeal = animTime
			end
			
			self:SetTurnTarget(ally, timeUntilHeal)
			
			-- Make the ally turn and look at me
			if !ally:IsPlayer() && (ally.MovementType != VJ_MOVETYPE_STATIONARY or (ally.MovementType == VJ_MOVETYPE_STATIONARY && ally.CanTurnWhileStationary == false)) then
				self.NextWanderTime = CurTime() + 2
				self.NextChaseTime = CurTime() + 2
				ally:StopMoving()
				ally:SetTarget(self)
				ally:VJ_TASK_FACE_X("TASK_FACE_TARGET")
			end
			
			timer.Simple(timeUntilHeal, function()
				if IsValid(self) then
					if !IsValid(ally) then -- Ally doesn't exist anymore, reset
						self:DoMedicReset()
					else -- If it exists...
						if self:VJ_GetNearestPointToEntityDistance(ally) <= (self.Medic_HealDistance + 20) then -- Are we still in healing distance?
							if self:CustomOnMedic_OnHeal(ally) != false then
								local friCurHP = ally:Health()
								ally:SetHealth(math_clamp(friCurHP + self.Medic_HealthAmount, friCurHP, ally:GetMaxHealth()))
								ally:RemoveAllDecals()
							end
							self:PlaySoundSystem("MedicOnHeal")
							if ally.IsVJBaseSNPC == true then
								ally:PlaySoundSystem("MedicReceiveHeal")
							end
							self:DoMedicReset()
						else -- If we are no longer in healing distance, go after the ally again
							self.Medic_Status = "Active"
							if IsValid(self.Medic_SpawnedProp) then self.Medic_SpawnedProp:Remove() end
							self:CustomOnMedic_OnReset()
						end
					end
				end
			end)
		elseif !self:BusyWithActivity() then -- If we aren't in healing distance, then go after the ally
			self.NextIdleTime = CurTime() + 4
			self.NextChaseTime = CurTime() + 4
			self:SetTarget(ally)
			self:VJ_TASK_GOTO_TARGET()
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoConstantlyFaceEnemy()
	if self.VJ_IsBeingControlled then return false end
	if self.LatestEnemyDistance < self.ConstantlyFaceEnemyDistance then
		-- Only face if the enemy is visible ?
		if self.ConstantlyFaceEnemy_IfVisible && !self.EnemyData.IsVisible then
			return false
		-- Do NOT face if attacking ?
		elseif self.ConstantlyFaceEnemy_IfAttacking == false && self.AttackType != VJ.ATTACK_TYPE_NONE then
			return false
		elseif (self.ConstantlyFaceEnemy_Postures == "Both") or (self.ConstantlyFaceEnemy_Postures == "Moving" && self:IsMoving()) or (self.ConstantlyFaceEnemy_Postures == "Standing" && !self:IsMoving()) then
			self:SetTurnTarget("Enemy")
			return true
		end
	end
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
local angY45 = Angle(0, 45, 0)
local angYN45 = Angle(0, -45, 0)
local angY90 = Angle(0, 90, 0)
local angYN90 = Angle(0, -90, 0)
--
function ENT:Controller_Movement(cont, ply, bullseyePos)
	if self.MovementType != VJ_MOVETYPE_STATIONARY then
		local gerta_lef = ply:KeyDown(IN_MOVELEFT)
		local gerta_rig = ply:KeyDown(IN_MOVERIGHT)
		local gerta_arak = ply:KeyDown(IN_SPEED)
		local aimVector = ply:GetAimVector()
		
		if ply:KeyDown(IN_FORWARD) then
			if self.MovementType == VJ_MOVETYPE_AERIAL or self.MovementType == VJ_MOVETYPE_AQUATIC then
				self:AA_MoveTo(cont.VJCE_Bullseye, true, gerta_arak and "Alert" or "Calm", {IgnoreGround=true})
			else
				if gerta_lef then
					cont:StartMovement(aimVector, angY45)
				elseif gerta_rig then
					cont:StartMovement(aimVector, angYN45)
				else
					cont:StartMovement(aimVector, defAng)
				end
			end
		elseif ply:KeyDown(IN_BACK) then
			if gerta_lef then
				cont:StartMovement(aimVector*-1, angYN45)
			elseif gerta_rig then
				cont:StartMovement(aimVector*-1, angY45)
			else
				cont:StartMovement(aimVector*-1, defAng)
			end
		elseif gerta_lef then
			cont:StartMovement(aimVector, angY90)
		elseif gerta_rig then
			cont:StartMovement(aimVector, angYN90)
		else
			self:StopMoving()
			if self.MovementType == VJ_MOVETYPE_AERIAL or self.MovementType == VJ_MOVETYPE_AQUATIC then
				self:AA_StopMoving()
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:VJ_PlaySequence(animation, playbackRate)
	if !animation then return false end
	//self.VJ_PlayingSequence = true -- No longer needed as it is handled by ACT_DO_NOT_DISTURB
	
	self:SetActivity(ACT_DO_NOT_DISTURB)
		-- Keeps MaintainActivity from overriding sequences as seen here: https://github.com/ValveSoftware/source-sdk-2013/blob/master/mp/src/game/server/ai_basenpc.cpp#L6331
		-- If "m_IdealActivity" is set to ACT_DO_NOT_DISTURB, the engine will understand it's a sequence and will avoid messing with it, described here: https://github.com/ValveSoftware/source-sdk-2013/blob/master/mp/src/game/shared/ai_activity.h#L215
		// self:SetIdealActivity(ACT_DO_NOT_DISTURB) -- Engine uses SetIdealActivity, but this resulted in self:GetActivity() returning wrong activity!
	local seqID = isstring(animation) and self:LookupSequence(animation) or animation
	self:ResetSequence(seqID)
	self:ResetSequenceInfo()
	self:SetCycle(0) -- Start from the beginning
	if isnumber(playbackRate) then
		self.AnimationPlaybackRate = playbackRate
		self:SetPlaybackRate(playbackRate)
	end
	/*if useDuration == true then -- No longer needed as it is handled by ACT_DO_NOT_DISTURB
		timer.Create("timer_act_seqreset"..self:EntIndex(), duration, 1, function()
			self.VJ_PlayingSequence = false
			//self.vACT_StopAttacks = false
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
function ENT:DoAddExtraAttackTimers(name, time, func)
	name = name or "timer_unknown"
	self.TimersToRemove[#self.TimersToRemove + 1] = name
	timer.Create(name..self:EntIndex(), (time or 0.5) / self:GetPlaybackRate(), 1, func)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoAlert(ent)
	if !IsValid(self:GetEnemy()) or self.Alerted == true then return end
	self.Alerted = true
	self:SetNPCState(NPC_STATE_ALERT)
	self.EnemyData.LastVisibleTime = CurTime()
	self:CustomOnAlert(ent)
	if CurTime() > self.NextAlertSoundT then
		self:PlaySoundSystem("Alert")
		if self.AlertSounds_OnlyOnce == true then
			self.HasAlertSounds = false
		end
		self.NextAlertSoundT = CurTime() + math.Rand(self.NextSoundTime_Alert.a, self.NextSoundTime_Alert.b)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local cosRad20 = math_cos(math_rad(20))
--
function ENT:MaintainRelationships()
	if self.Behavior == VJ_BEHAVIOR_PASSIVE_NATURE /*or self.Behavior == VJ_BEHAVIOR_PASSIVE*/ then return false end
	local posEnemies = self.CurrentPossibleEnemies
	if posEnemies == nil then return false end
	//if CurTime() > self.NextHardEntityCheckT then
		//self.CurrentPossibleEnemies = self:DoHardEntityCheck()
	//self.NextHardEntityCheckT = CurTime() + math.random(self.NextHardEntityCheck1,self.NextHardEntityCheck2) end
	//print(self:GetName().."'s Enemies:")
	//PrintTable(posEnemies)

	/*if table.Count(self.CurrentPossibleEnemies) == 0 && CurTime() > self.NextHardEntityCheckT then
		self.CurrentPossibleEnemies = self:DoHardEntityCheck()
	self.NextHardEntityCheckT = CurTime() + math.random(50,70) end*/
	
	local eneData = self.EnemyData
	eneData.VisibleCount = 0
	//local distlist = {}
	local eneSeen = false
	local myPos = self:GetPos()
	local nearestDist = nil
	local mySDir = self:GetSightDirection()
	local mySightDist = self:GetMaxLookDistance()
	local mySightAng = math_cos(math_rad(self.SightAngle))
	local plyControlled = self.VJ_IsBeingControlled
	local sdHintBullet = sound.GetLoudestSoundHint(SOUND_BULLET_IMPACT, myPos)
	local sdHintBulletOwner = nil;
	if sdHintBullet then
		sdHintBulletOwner = sdHintBullet.owner
	end
	local it = 1
	//for k, v in ipairs(posEnemies) do
	//for it = 1, #posEnemies do
	while it <= #posEnemies do
		local v = posEnemies[it]
		if !IsValid(v) then
			table_remove(posEnemies, it)
		else
			it = it + 1
			//if !IsValid(v) then table_remove(self.CurrentPossibleEnemies,tonumber(v)) continue end
			//if !IsValid(v) then continue end
			if v:IsFlagSet(FL_NOTARGET) or v.VJ_NoTarget or (v.VJ_AlwaysEnemyToEnt && v.VJ_AlwaysEnemyToEnt != self) then
				if IsValid(self:GetEnemy()) && self:GetEnemy() == v then
					self:ResetEnemy(false)
				end
				continue
			end
			//if v:Health() <= 0 then table_remove(self.CurrentPossibleEnemies,k) continue end
			local vPos = v:GetPos()
			local vDistanceToMy = vPos:Distance(myPos)
			if vDistanceToMy > mySightDist then continue end
			local entFri = false
			local vClass = v:GetClass()
			local vNPC = v:IsNPC()
			local vPlayer = v:IsPlayer()
			if vClass != self:GetClass() && (vPlayer or (vNPC && v.Behavior != VJ_BEHAVIOR_PASSIVE_NATURE)) /*&& MyVisibleTov && self:Disposition(v) != D_LI*/ then
				local inEneTbl = VJ.HasValue(self.VJ_AddCertainEntityAsEnemy, v)
				if self.HasAllies == true && inEneTbl == false then
					for _,friClass in ipairs(self.VJ_NPC_Class) do
						if friClass == varCPly && self.PlayerFriendly == false then self.PlayerFriendly = true end -- If player ally then set the PlayerFriendly to true
						-- Handle common class types
						if (friClass == varCCom && NPCTbl_Combine[vClass]) or (friClass == varCZom && NPCTbl_Zombies[vClass]) or (friClass == varCAnt && NPCTbl_Antlions[vClass]) or (friClass == varCXen && NPCTbl_Xen[vClass]) then
							v:AddEntityRelationship(self, D_LI, 0)
							self:AddEntityRelationship(v, D_LI, 0)
							entFri = true
						end
						if (v.VJ_NPC_Class && VJ.HasValue(v.VJ_NPC_Class, friClass)) or (entFri == true) then
							if friClass == varCPly then -- If we have the player ally class then check if we both of us are supposed to be friends
								if self.FriendsWithAllPlayerAllies == true && v.FriendsWithAllPlayerAllies == true then
									entFri = true
									if vNPC then v:AddEntityRelationship(self, D_LI, 0) end
									self:AddEntityRelationship(v, D_LI, 0)
								end
							else
								entFri = true
								-- If I am enemy to it, then reset it!
								if IsValid(self:GetEnemy()) && self:GetEnemy() == v then
									eneData.Reset = true
									self:ResetEnemy(false)
								end
								if vNPC then v:AddEntityRelationship(self, D_LI, 0) end
								self:AddEntityRelationship(v, D_LI, 0)
							end
						end
					end
					-- Handle self.VJ Friendly AND self.FriendsWithAllPlayerAllies
					if vNPC && !entFri && ((self.VJTag_IsBaseFriendly && v.IsVJBaseSNPC == true) or (self.PlayerFriendly == true && self.FriendsWithAllPlayerAllies == true && v.PlayerFriendly == true && v.FriendsWithAllPlayerAllies == true)) then
						v:AddEntityRelationship(self, D_LI, 0)
						self:AddEntityRelationship(v, D_LI, 0)
						entFri = true
					end
				end
				if !entFri && vNPC /*&& MyVisibleTov*/ && !self.DisableMakingSelfEnemyToNPCs && (v.VJ_IsBeingControlled != true) then v:AddEntityRelationship(self, D_HT, 0) end
				if vPlayer && (self.PlayerFriendly == true or entFri == true) then
					if inEneTbl == false then
						entFri = true
						self:AddEntityRelationship(v, D_LI, 0)
						//DoPlayerSight()
					else
						entFri = false
					end
				end
				-- Investigation detection systems, including sound, movement and flashlight
				if !IsValid(self:GetEnemy()) && !entFri then
					if vPlayer then
						self:AddEntityRelationship(v, D_NU, 0) -- Make the player neutral since it's not supposed to be a friend
						//if v:Crouching() && v:GetMoveType() != MOVETYPE_NOCLIP then -- Old and broken
							//mySightDist = self.VJ_IsHugeMonster == true and 5000 or 2000
						//end
					end
					if self.CanInvestigate && self.NextInvestigationMove < CurTime() then
						-- When a sound is detected
						if v.VJ_LastInvestigateSdLevel && vDistanceToMy < (self.InvestigateSoundDistance * v.VJ_LastInvestigateSdLevel) && ((CurTime() - v.VJ_LastInvestigateSd) <= 1) then
							if self:Visible(v) then
								self:StopMoving()
								self:SetTarget(v)
								self:VJ_TASK_FACE_X("TASK_FACE_TARGET")
								self.NextInvestigationMove = CurTime() + 0.3 -- Short delay, since it's only turning
							elseif self.IsFollowing == false then
								self:SetLastPosition(vPos)
								self:VJ_TASK_GOTO_LASTPOS("TASK_WALK_PATH")
								self.NextInvestigationMove = CurTime() + 2 -- Long delay, so it doesn't spam movement
							end
							self:CustomOnInvestigate(v)
							self:PlaySoundSystem("InvestigateSound")
						-- When a bullet hit is detected
						elseif IsValid(sdHintBulletOwner) && sdHintBulletOwner == v then
							self:StopMoving()
							self:SetLastPosition(sdHintBullet.origin)
							self:VJ_TASK_FACE_X("TASK_FACE_LASTPOSITION")
							self:CustomOnInvestigate(v)
							self:PlaySoundSystem("InvestigateSound")
							self.NextInvestigationMove = CurTime() + 0.3 -- Short delay because many bullets could hit
						-- PLAYER ONLY: Flashlight shining on the NPC
						elseif vPlayer && vDistanceToMy < 350 && v:FlashlightIsOn() && (v:GetForward():Dot((myPos - vPos):GetNormalized()) > cosRad20) then
							//			   Asiga hoser ^ (!v:Crouching() && v:GetVelocity():Length() > 0 && v:GetMoveType() != MOVETYPE_NOCLIP && ((!v:KeyDown(IN_WALK) && (v:KeyDown(IN_FORWARD) or v:KeyDown(IN_BACK) or v:KeyDown(IN_MOVELEFT) or v:KeyDown(IN_MOVERIGHT))) or (v:KeyDown(IN_SPEED) or v:KeyDown(IN_JUMP)))) or
							self:StopMoving()
							self:SetTarget(v)
							self:VJ_TASK_FACE_X("TASK_FACE_TARGET")
							self.NextInvestigationMove = CurTime() + 0.1 -- Short delay, since it's only turning
						end
					end
				end
			end
			/*print("----------")
			print(self:HasEnemyEluded(v))
			print(self:HasEnemyMemory(v))
			print(CurTime() - self:GetEnemyLastTimeSeen(v))
			print(CurTime() - self:GetEnemyFirstTimeSeen(v))*/
			-- We have to do this here so we make sure non-VJ NPCs can still target this NPC, even if it's being controlled!
			if plyControlled && self.VJ_TheControllerBullseye != v then
				//self:AddEntityRelationship(v, D_NU, 0)
				v = self.VJ_TheControllerBullseye
				vPlayer = false
			end
			-- Check in order: Can find enemy + Neutral or not + Is visible + In sight
			if self.DisableFindEnemy == false && (self.Behavior != VJ_BEHAVIOR_NEUTRAL or self.Alerted) && (self.FindEnemy_CanSeeThroughWalls or self:Visible(v)) && (self.FindEnemy_UseSphere or (mySDir:Dot((vPos - myPos):GetNormalized()) > mySightAng)) then
				local check = self:CheckRelationship(v)
				if check == D_HT then -- Is enemy
					eneSeen = true
					eneData.VisibleCount = eneData.VisibleCount + 1
					self:AddEntityRelationship(v, D_HT, 0)
					-- If the detected enemy is closer than the previous enemy, the set this as the enemy!
					if (nearestDist == nil) or (vDistanceToMy < nearestDist) then
						nearestDist = vDistanceToMy
						self:VJ_DoSetEnemy(v, true, true)
					end
				-- If the current enemy is a friendly player, then reset the enemy!
				elseif check == D_LI && vPlayer && IsValid(self:GetEnemy()) && self:GetEnemy() == v then
					eneData.Reset = true
					self:ResetEnemy(false)
				end
			end
			if vPlayer then
				-- MoveOutOfFriendlyPlayersWay system, Based on:
					-- "CNPC_PlayerCompanion::PredictPlayerPush"	--> https://github.com/ValveSoftware/source-sdk-2013/blob/master/mp/src/game/server/hl2/npc_playercompanion.cpp#L548
					-- "CAI_BaseNPC::TestPlayerPushing"				--> https://github.com/ValveSoftware/source-sdk-2013/blob/master/mp/src/game/server/ai_basenpc.cpp#L12676
				// && !self:BusyWithActivity()
				if entFri && self.MoveOutOfFriendlyPlayersWay && !self.IsGuard && v:GetMoveType() != MOVETYPE_NOCLIP then
					local plyVel = v:GetInternalVariable("m_vecSmoothedVelocity")
					if plyVel:LengthSqr() >= 19600 then -- 140 * 140 = 19600
						local delta = self:WorldSpaceCenter() - (v:WorldSpaceCenter() + plyVel * 0.4);
						local myMaxs = self:OBBMaxs()
						local myMins = self:OBBMins()
						local zCalc = (myMaxs.z - myMins.z) * 0.5
						local yCalc = myMaxs.y - myMins.y
						-- (ply not under me) + (ply not very above me) + (ply is close to me)   |   All calculations depend on the NPC's collision size AND player's current speed
						if delta.z < zCalc && (delta.z + zCalc + 150) > zCalc && delta:Length2DSqr() < ((yCalc * yCalc) * 1.999396) then -- 1.414 * 1.414 = 1.999396
							self:SetCondition(COND_PLAYER_PUSHING)
							if !IsValid(self:GetTarget()) then -- Only set the target if it does NOT have one to not interfere with other behaviors!
								self:SetTarget(v)
							end
						end
					end
				end
				-- HasOnPlayerSight system, used to do certain actions when it sees the player
				if self.HasOnPlayerSight == true && v:Alive() &&(CurTime() > self.OnPlayerSightNextT) && (vDistanceToMy < self.OnPlayerSightDistance) && self:Visible(v) && (mySDir:Dot((v:GetPos() - myPos):GetNormalized()) > mySightAng) then
					-- 0 = Run it every time | 1 = Run it only when friendly to player | 2 = Run it only when enemy to player
					local disp = self.OnPlayerSightDispositionLevel
					if (disp == 0) or (disp == 1 && (self:Disposition(v) == D_LI or self:Disposition(v) == D_NU)) or (disp == 2 && self:Disposition(v) != D_LI) then
						self:CustomOnPlayerSight(v)
						self:PlaySoundSystem("OnPlayerSight")
						if self.OnPlayerSightOnlyOnce == true then -- If it's only suppose to play it once then turn the system off
							self.HasOnPlayerSight = false
						else
							self.OnPlayerSightNextT = CurTime() + math.Rand(self.OnPlayerSightNextTime.a, self.OnPlayerSightNextTime.b)
						end
					end
				end
			end
			local funcCustom = self.CustomOnMaintainRelationships; if funcCustom then funcCustom(self, v, entFri, vDistanceToMy) end
		end
		//return true
	end
	if eneSeen == true then return true else return false end
	//return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Allies_CallHelp(dist)
	if !self.CallForHelp or self.AttackType == VJ.ATTACK_TYPE_GRENADE then return false end
	local entsTbl = ents.FindInSphere(self:GetPos(), dist)
	if (!entsTbl) then return false end
	local myClass = self:GetClass()
	for _,v in ipairs(entsTbl) do
		if v:IsNPC() && v != self && v.IsVJBaseSNPC && VJ.IsAlive(v) && (v:GetClass() == myClass or v:Disposition(self) == D_LI) && v.Behavior != VJ_BEHAVIOR_PASSIVE_NATURE /*&& v.IsFollowing == false*/ && !v.VJ_IsBeingControlled && (!v.IsVJBaseSNPC_Tank) && v.CallForHelp then
			local ene = self:GetEnemy()
			if IsValid(ene) then
				if v:GetPos():Distance(ene:GetPos()) > v:GetMaxLookDistance() then continue end -- Enemy to far away for ally, discontinue!
				//if v:CheckRelationship(ene) == D_HT then
				if !IsValid(v:GetEnemy()) && ((!ene:IsPlayer() && v:Disposition(ene) != D_LI) or (ene:IsPlayer())) then
					if v.IsGuard == true && !v:Visible(ene) then continue end -- If it's guarding and enemy is not visible, then don't call!
					self:CustomOnCallForHelp(v)
					self:PlaySoundSystem("CallForHelp")
					-- Play the animation
					if self.HasCallForHelpAnimation == true && CurTime() > self.NextCallForHelpAnimationT then
						local pickanim = VJ.PICK(self.AnimTbl_CallForHelp)
						self:VJ_ACT_PLAYACTIVITY(pickanim, self.CallForHelpStopAnimations, self:DecideAnimationLength(pickanim, self.CallForHelpStopAnimationsTime), self.CallForHelpAnimationFaceEnemy, self.CallForHelpAnimationDelay, {PlayBackRate=self.CallForHelpAnimationPlayBackRate, PlayBackRateCalculated=true})
						self.NextCallForHelpAnimationT = CurTime() + self.NextCallForHelpAnimationTime
					end
					-- If the enemy is a player and the ally is player-friendly then make that player an enemy to the ally
					if ene:IsPlayer() && v.PlayerFriendly == true then
						v.VJ_AddCertainEntityAsEnemy[#v.VJ_AddCertainEntityAsEnemy + 1] = ene
					end
					v:VJ_DoSetEnemy(ene, true)
					if CurTime() > v.NextChaseTime then
						if v.Behavior != VJ_BEHAVIOR_PASSIVE && v:Visible(ene) then
							v:SetTarget(ene)
							v:VJ_TASK_FACE_X("TASK_FACE_TARGET")
						else
							v:PlaySoundSystem("OnReceiveOrder")
							v:DoChaseAnimation()
						end
					end
				end
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Allies_Check(dist)
	dist = dist or 800 -- How far can it check for allies
	local entsTbl = ents.FindInSphere(self:GetPos(), dist)
	if (!entsTbl) then return false end
	local FoundAlliesTbl = {}
	local it = 0
	for _, v in ipairs(entsTbl) do
		if VJ.IsAlive(v) == true && v:IsNPC() && v != self && (v:GetClass() == self:GetClass() or (v:Disposition(self) == D_LI or v.Behavior == VJ_BEHAVIOR_PASSIVE_NATURE)) && (v.BringFriendsOnDeath == true or v.CallForBackUpOnDamage == true or v.CallForHelp == true) then
			if self.Behavior == VJ_BEHAVIOR_PASSIVE or self.Behavior == VJ_BEHAVIOR_PASSIVE_NATURE then
				if v.Behavior == VJ_BEHAVIOR_PASSIVE or v.Behavior == VJ_BEHAVIOR_PASSIVE_NATURE then
					it = it + 1
					FoundAlliesTbl[it] = v
				end
			else
				it = it + 1
				FoundAlliesTbl[it] = v
			end
		end
	end
	if it > 0 then
		return FoundAlliesTbl
	else
		return false
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Allies_Bring(formType, dist, entsTbl, limit, onlyVis)
	formType = formType or "Random" -- Formation type: "Random" || "Diamond"
	dist = dist or 800 -- How far can it check for allies
	entsTbl = entsTbl or ents.FindInSphere(self:GetPos(), dist)
	limit = limit or 3 -- Setting to 0 will automatically become 1
	onlyVis = onlyVis or false -- Check only entities that are visible
	if (!entsTbl) then return false end
	local myClass = self:GetClass()
	local it = 0
	for _, v in ipairs(entsTbl) do
		if VJ.IsAlive(v) == true && v:IsNPC() && v != self && (v:GetClass() == myClass or v:Disposition(self) == D_LI) && v.Behavior != VJ_BEHAVIOR_PASSIVE && v.Behavior != VJ_BEHAVIOR_PASSIVE_NATURE && v.IsFollowing == false && v.VJ_IsBeingControlled == false && !v.IsGuard && (!v.IsVJBaseSNPC_Tank) && (v.BringFriendsOnDeath == true or v.CallForBackUpOnDamage == true or v.CallForHelp == true) then
			if onlyVis == true && !v:Visible(self) then continue end
			if !IsValid(v:GetEnemy()) && self:GetPos():Distance(v:GetPos()) < dist then
				self.NextWanderTime = CurTime() + 8
				v.NextWanderTime = CurTime() + 8
				it = it + 1
				-- Formation
				if formType == "Random" then
					local randPos = math.random(1, 4)
					if randPos == 1 then
						v:SetLastPosition(self:GetPos() + self:GetRight()*math.random(20, 50))
					elseif randPos == 2 then
						v:SetLastPosition(self:GetPos() + self:GetRight()*math.random(-20, -50))
					elseif randPos == 3 then
						v:SetLastPosition(self:GetPos() + self:GetForward()*math.random(20, 50))
					elseif randPos == 4 then
						v:SetLastPosition(self:GetPos() + self:GetForward()*math.random(-20, -50))
					end
				elseif formType == "Diamond" then
					v:DoGroupFormation("Diamond", self, it)
				end
				-- Move type
				if v.IsVJBaseSNPC_Human == true && !IsValid(v:GetActiveWeapon()) then
					v:VJ_TASK_COVER_FROM_ORIGIN("TASK_RUN_PATH")
				else
					v:VJ_TASK_GOTO_LASTPOS("TASK_WALK_PATH", function(x) x.CanShootWhenMoving = true x.FaceData = {Type = VJ.NPC_FACE_ENEMY} end)
				end
			end
			if limit != 0 && it >= limit then return true end -- Return true if it reached the limit
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Decides the attack time.
		- timer2 = Use for randomization, leave to "false" to just use timer1
		- untilDamage = Used for timer-based attacks, decreases timer1
		- animDur = Used when timer1 is set to "false", it over takes timer1
	Returns
		- Number, the decided time
-----------------------------------------------------------]]
function ENT:DecideAttackTimer(timer1, timer2, untilDamage, animDur)
	local result = timer1
	-- animDur has already calculated the playback rate!
	if timer1 == false then -- Let the base decide..
		if untilDamage == false then -- Event-based
			result = animDur
		else -- Timer-based
			if animDur <= 0 then -- If it's 0 or less, then this attack probably did NOT play an animation, so don't use animDur!
				result = untilDamage / self:GetPlaybackRate()
			else
				result = animDur - (untilDamage / self:GetPlaybackRate())
			end
		end
	else -- If a specific number has been put then make sure to calculate its playback rate
		result = result / self:GetPlaybackRate()
	end
	
	-- If a 2nd value is given (Used for randomization), calculate its playback rate as well and then get a random value between it and the result
	if isnumber(timer2) then
		result = math.Rand(result, timer2 / self:GetPlaybackRate())
	end
	
	return result // / self:GetPlaybackRate() -- No need, playback is already calculated above
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoKilledEnemy(ent, attacker, inflictor)
	if !IsValid(ent) then return end
	-- If it can only do it if there is no enemies left then check --> (If there no valid enemy) OR (The number of enemies is 1 or less)
	if (self.OnlyDoKillEnemyWhenClear == false) or (self.OnlyDoKillEnemyWhenClear == true && (!IsValid(self:GetEnemy()) or (self.EnemyData.VisibleCount <= 1))) then
		self:CustomOnDoKilledEnemy(ent, attacker, inflictor)
		self:PlaySoundSystem("OnKilledEnemy")
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local function FlinchDamageTypeCheck(checkTbl, dmgType)
	for k = 1, #checkTbl do
		if bAND(dmgType, checkTbl[k]) != 0 then
			return true
		end
	end
end
--
function ENT:DoFlinch(dmginfo, hitgroup)
	if self.CanFlinch == 0 or self.Flinching == true or self.TakingCoverT > CurTime() or self.NextFlinchT > CurTime() or self:GetNavType() == NAV_JUMP or self:GetNavType() == NAV_CLIMB or (IsValid(dmginfo:GetInflictor()) && IsValid(dmginfo:GetAttacker()) && dmginfo:GetInflictor():GetClass() == "entityflame" && dmginfo:GetAttacker():GetClass() == "entityflame") then return end

	local function RunFlinchCode(HitgroupInfo)
		self.Flinching = true
		self:StopAttacks(true)
		self.CurrentAttackAnimationTime = 0
		local animTbl = self.AnimTbl_Flinch
		if HitgroupInfo != nil then animTbl = HitgroupInfo.Animation end
		local anim = VJ.PICK(animTbl)
		local animDur = self.NextMoveAfterFlinchTime == false and self:DecideAnimationLength(anim, false, self.FlinchAnimationDecreaseLengthAmount) or self.NextMoveAfterFlinchTime
		self:VJ_ACT_PLAYACTIVITY(anim, true, animDur, false, 0, {PlayBackRateCalculated=true})
		timer.Create("timer_act_flinching"..self:EntIndex(), animDur, 1, function() self.Flinching = false end)
		self:CustomOnFlinch_AfterFlinch(dmginfo, hitgroup)
		self.NextFlinchT = CurTime() + self.NextFlinchTime
	end
	
	if math.random(1, self.FlinchChance) == 1 && ((self.CanFlinch == 1) or (self.CanFlinch == 2 && FlinchDamageTypeCheck(self.FlinchDamageTypes, dmginfo:GetDamageType()))) then
		if self:CustomOnFlinch_BeforeFlinch(dmginfo, hitgroup) == false then return end
		
		local hitgroupTbl = self.HitGroupFlinching_Values
		-- Hitgroup flinching
		if istable(hitgroupTbl) then
			for _, v in ipairs(hitgroupTbl) do
				local hitGroups = v.HitGroup
				-- Sub-table of hitGroups
				for hitgroupX = 1, #hitGroups do
					if hitGroups[hitgroupX] == hitgroup then
						RunFlinchCode(v)
						return
					end
				end
			end
			if self.HitGroupFlinching_DefaultWhenNotHit == true then
				RunFlinchCode(nil)
			end
		-- Non-hitgroup flinching
		else
			RunFlinchCode(nil)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Sets the NPC's blood color (particle, decal, blood pool)
		- blColor = The blood color to set it to | Must be a string, check the list below
-----------------------------------------------------------]]
local bloodNames = {
	["Red"] = {
		particle = "blood_impact_red_01", // vj_impact1_red
		decal = "VJ_Blood_Red",
		decal_gmod = "Blood",
		pool = {
			[0] = "vj_bleedout_red_tiny",
			[1] = "vj_bleedout_red_small",
			[2] = "vj_bleedout_red"
		}
	},
	["Yellow"] = {
		particle = "blood_impact_yellow_01", // vj_impact1_yellow
		decal = "VJ_Blood_Yellow",
		decal_gmod = "YellowBlood",
		pool = {
			[0] = "vj_bleedout_yellow_tiny",
			[1] = "vj_bleedout_yellow_small",
			[2] = "vj_bleedout_yellow"
		}
	},
	["Green"] = {
		particle = "vj_impact1_green",
		decal = "VJ_Blood_Green",
		pool = {
			[0] = "vj_bleedout_green_tiny",
			[1] = "vj_bleedout_green_small",
			[2] = "vj_bleedout_green"
		}
	},
	["Orange"] = {
		particle = "vj_impact1_orange",
		decal = "VJ_Blood_Orange",
		pool = {
			[0] = "vj_bleedout_orange_tiny",
			[1] = "vj_bleedout_orange_small",
			[2] = "vj_bleedout_orange"
		}
	},
	["Blue"] = {
		particle = "vj_impact1_blue",
		decal = "VJ_Blood_Blue",
		pool = {
			[0] = "vj_bleedout_blue_tiny",
			[1] = "vj_bleedout_blue_small",
			[2] = "vj_bleedout_blue"
		}
	},
	["Purple"] = {
		particle = "vj_impact1_purple",
		decal = "VJ_Blood_Purple",
		pool = {
			[0] = "vj_bleedout_purple_tiny",
			[1] = "vj_bleedout_purple_small",
			[2] = "vj_bleedout_purple"
		}
	},
	["White"] = {
		particle = "vj_impact1_white",
		decal = "VJ_Blood_White",
		pool = {
			[0] = "vj_bleedout_white_tiny",
			[1] = "vj_bleedout_white_small",
			[2] = "vj_bleedout_white"
		}
	},
	["Oil"] = {
		particle = "vj_impact1_oil",
		decal = "VJ_Blood_Oil",
		pool = {
			[0] = "vj_bleedout_oil_tiny",
			[1] = "vj_bleedout_oil_small",
			[2] = "vj_bleedout_oil"
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
		if !VJ.PICK(self.CustomBlood_Particle) then
			self.CustomBlood_Particle = blood.particle
		end
		if !VJ.PICK(self.CustomBlood_Decal) then
			self.CustomBlood_Decal = self.BloodDecalUseGMod and blood.decal_gmod or blood.decal
		end
		if !VJ.PICK(self.CustomBlood_Pool) then
			self.CustomBlood_Pool = blood.pool[npcSize]
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SpawnBloodParticles(dmginfo, hitgroup)
	local name = VJ.PICK(self.CustomBlood_Particle)
	if name == false then return end
	
	local pos = dmginfo:GetDamagePosition()
	if pos == defPos then pos = self:GetPos() + self:OBBCenter() end
	
	local particle = ents.Create("info_particle_system")
	particle:SetKeyValue("effect_name", name)
	particle:SetPos(pos)
	particle:Spawn()
	particle:Activate()
	particle:Fire("Start")
	particle:Fire("Kill", "", 0.1)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SpawnBloodDecal(dmginfo, hitgroup)
	if VJ.PICK(self.CustomBlood_Decal) == false then return end
	local force = dmginfo:GetDamageForce()
	local pos = dmginfo:GetDamagePosition()
	if pos == defPos then pos = self:GetPos() + self:OBBCenter() end
	
	-- Badi ayroun
	local tr = util.TraceLine({start = pos, endpos = pos + force:GetNormal() * math_clamp(force:Length() * 10, 100, self.BloodDecalDistance), filter = self})
	//if !tr.HitWorld then return end
	local trNormalP = tr.HitPos + tr.HitNormal
	local trNormalN = tr.HitPos - tr.HitNormal
	util.Decal(VJ.PICK(self.CustomBlood_Decal), trNormalP, trNormalN, self)
	for _ = 1, 2 do
		if math.random(1, 2) == 1 then util.Decal(VJ.PICK(self.CustomBlood_Decal), trNormalP + Vector(math.random(-70, 70), math.random(-70, 70), 0), trNormalN, self) end
	end
	
	-- Kedni ayroun
	if math.random(1, 2) == 1 then
		local d2_endpos = pos + Vector(0, 0, - math_clamp(force:Length() * 10, 100, self.BloodDecalDistance))
		util.Decal(VJ.PICK(self.CustomBlood_Decal), pos, d2_endpos, self)
		if math.random(1, 2) == 1 then util.Decal(VJ.PICK(self.CustomBlood_Decal), pos, d2_endpos + Vector(math.random(-120, 120), math.random(-120, 120), 0), self) end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local vecZ30 = Vector(0, 0, 30)
local vecZ1 = Vector(0, 0, 1)
--
function ENT:SpawnBloodPool(dmginfo, hitgroup)
	local corpseEnt = self.Corpse
	if !IsValid(corpseEnt) then return end
	local getBloodPool = VJ.PICK(self.CustomBlood_Pool)
	if getBloodPool then
		timer.Simple(2.2, function()
			if IsValid(corpseEnt) then
				local pos = corpseEnt:GetPos() + corpseEnt:OBBCenter()
				local tr = util.TraceLine({
					start = pos,
					endpos = pos - vecZ30,
					filter = corpseEnt, //function( ent ) if ( ent:GetClass() == "prop_physics" ) then return true end end
					mask = CONTENTS_SOLID
				})
				if tr.HitWorld && (tr.HitNormal == vecZ1) then // (tr.Fraction <= 0.405)
					ParticleEffect(getBloodPool, tr.HitPos, defAng, nil)
				end
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:IdleSoundCode(customSd, sdType)
	if !self.HasSounds or !self.HasIdleSounds or self.Dead then return end
	if (self.NextIdleSoundT_RegularChange < CurTime()) && (CurTime() > self.NextIdleSoundT) then
		sdType = sdType or VJ.CreateSound
		
		local hasEnemy = IsValid(self:GetEnemy()) -- Ayo yete teshnami ouni
		-- Yete CombatIdle tsayn chouni YEV gerna barz tsayn hanel, ere vor barz tsayn han e
		if hasEnemy && VJ.PICK(self.SoundTbl_CombatIdle) == false && !self.IdleSounds_NoRegularIdleOnAlerted then
			hasEnemy = false
		end
		
		local cTbl = VJ.PICK(customSd)
		local setTimer = true
		if hasEnemy == true then
			local sdtbl = VJ.PICK(self.SoundTbl_CombatIdle)
			if (math.random(1,self.CombatIdleSoundChance) == 1 && sdtbl != false) or (cTbl != false) then
				if cTbl != false then sdtbl = cTbl end
				self.CurrentIdleSound = sdType(self, sdtbl, self.CombatIdleSoundLevel, self:VJ_DecideSoundPitch(self.CombatIdleSoundPitch.a, self.CombatIdleSoundPitch.b))
			end
		else
			local sdtbl = VJ.PICK(self.SoundTbl_Idle)
			local sdtbl2 = VJ.PICK(self.SoundTbl_IdleDialogue)
			local sdrand = math.random(1, self.IdleSoundChance)
			local function RegularIdle()
				if (sdrand == 1 && sdtbl != false) or (cTbl != false) then
					if cTbl != false then sdtbl = cTbl end
					self.CurrentIdleSound = sdType(self, sdtbl, self.IdleSoundLevel, self:VJ_DecideSoundPitch(self.IdleSoundPitch.a, self.IdleSoundPitch.b))
				end
			end
			if sdtbl2 != false && sdrand == 1 && self.HasIdleDialogueSounds == true && math.random(1, 2) == 1 then
				local foundEnt, canAnswer = self:IdleDialogueFindEnt()
				if foundEnt != false then
					self.CurrentIdleSound = sdType(self, sdtbl2, self.IdleDialogueSoundLevel, self:VJ_DecideSoundPitch(self.IdleDialogueSoundPitch.a, self.IdleDialogueSoundPitch.b))
					if canAnswer == true then -- If we have a VJ NPC that can answer
						local dur = SoundDuration(sdtbl2)
						if dur == 0 then dur = 3 end -- Since some file types don't return a proper duration =(
						local talkTime = CurTime() + (dur + 0.5)
						setTimer = false
						self.NextIdleSoundT = talkTime
						self.NextWanderTime = talkTime
						foundEnt.NextIdleSoundT = talkTime
						foundEnt.NextWanderTime = talkTime
						
						self:CustomOnIdleDialogue(foundEnt, "Speak", talkTime)
						
						-- Stop moving and look at each other
						if self.IdleDialogueCanTurn == true then
							self:StopMoving()
							self:SetTarget(foundEnt)
							self:VJ_TASK_FACE_X("TASK_FACE_TARGET")
						end
						if foundEnt.IdleDialogueCanTurn == true then
							foundEnt:StopMoving()
							foundEnt:SetTarget(self)
							foundEnt:VJ_TASK_FACE_X("TASK_FACE_TARGET")
						end
						
						-- For the other SNPC to answer back:
						timer.Simple(dur + 0.3, function()
							if IsValid(self) && IsValid(foundEnt) && !foundEnt:CustomOnIdleDialogue(self, "Answer") then
								local response = foundEnt:IdleDialogueAnswerSoundCode()
								if response > 0 then -- If the ally responded, then make sure both SNPCs stand still & don't play another idle sound until the whole conversation is finished!
									local curTime = CurTime()
									self.NextIdleSoundT = curTime + (response + 0.5)
									self.NextWanderTime = curTime + (response + 1)
									foundEnt.NextIdleSoundT = curTime + (response + 0.5)
									foundEnt.NextWanderTime = curTime + (response + 1)
								end
							end
						end)
					end
				else
					RegularIdle()
				end
			else
				RegularIdle()
			end
		end
		if setTimer == true then
			self.NextIdleSoundT = CurTime() + math.Rand(self.NextSoundTime_Idle.a, self.NextSoundTime_Idle.b)
		end
	end
end
--------------------------------------------------------------------------------------------------------------------------------------------
function ENT:IdleDialogueFindEnt()
	-- Don't break the loop unless we hit a VJ SNPC
	-- If no VJ SNPC is hit, then just simply return the last checked friendly player or NPC
	local returnEnt = false
	for _, v in ipairs(ents.FindInSphere(self:GetPos(), self.IdleDialogueDistance)) do
		if v:IsPlayer() then
			if self:CheckRelationship(v) == D_LI && !self:CustomOnIdleDialogue(v, "CheckEnt", false) then
				returnEnt = v
			end
		elseif v != self && ((self:GetClass() == v:GetClass()) or (v:IsNPC() && self:CheckRelationship(v) == D_LI)) && self:Visible(v) then
			local canAnswer = (v.IsVJBaseSNPC and VJ.PICK(v.SoundTbl_IdleDialogueAnswer)) or false
			if !self:CustomOnIdleDialogue(v, "CheckEnt", canAnswer) then
				returnEnt = v
				if v.IsVJBaseSNPC && !v.Dead && canAnswer then -- VJ NPC hit!
					return v, true
				end
			end
		end
	end
	return returnEnt, false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:IdleDialogueAnswerSoundCode(customSd, sdType)
	if self.Dead or self.HasSounds == false or self.HasIdleDialogueAnswerSounds == false then return 0 end
	sdType = sdType or VJ.CreateSound
	local cTbl = VJ.PICK(customSd)
	local sdtbl = VJ.PICK(self.SoundTbl_IdleDialogueAnswer)
	if (math.random(1,self.IdleDialogueAnswerSoundChance) == 1 && sdtbl != false) or (cTbl != false) then
		if cTbl != false then sdtbl = cTbl end
		self:StopAllCommonSpeechSounds()
		self.NextIdleSoundT_RegularChange = CurTime() + math.random(2, 3)
		self.CurrentIdleDialogueAnswerSound = sdType(self, sdtbl, self.IdleDialogueAnswerSoundLevel, self:VJ_DecideSoundPitch(self.IdleDialogueAnswerSoundPitch.a, self.IdleDialogueAnswerSoundPitch.b))
		return SoundDuration(sdtbl) -- Return the duration of the sound, which will be used to make the other SNPC stand still
	else
		return 0
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RemoveTimers()
	local myIndex = self:EntIndex()
	for _,v in ipairs(self.TimersToRemove) do
		timer.Remove(v .. myIndex)
	end
	if self.AttackTimersCustom then -- !!!!!!!!!!!!!! DO NOT USE THIS VARIABLE !!!!!!!!!!!!!! [Backwards Compatibility!]
		for _,v in ipairs(self.AttackTimersCustom) do
			timer.Remove(v .. myIndex)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:EntitiesToNoCollideCode(ent)
	if !self.HasEntitiesToNoCollide or !istable(self.EntitiesToNoCollide) or !IsValid(ent) then return end
	for i = 1, #self.EntitiesToNoCollide do
		if self.EntitiesToNoCollide[i] == ent:GetClass() then
			constraint.NoCollide(self, ent, 0, 0)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RunGibOnDeathCode(dmginfo, hitgroup, extraOptions)
	if !self.AllowedToGib or !self.HasGibOnDeath or self.HasBeenGibbedOnDeath then return end
	extraOptions = extraOptions or {}
	local dmgTbl = extraOptions.CustomDmgTbl or self.GibOnDeathDamagesTable
	local dmgType = dmginfo:GetDamageType()
	for k = 1, #dmgTbl do
		local v = dmgTbl[k]
		if (v == "All") or (v == "UseDefault" && self:IsDefaultGibDamageType(dmgType) && bAND(dmgType, DMG_NEVERGIB) == 0) or (v != "UseDefault" && bAND(dmgType, v) != 0) then
			local setupGibs, setupGibsExtra = self:SetUpGibesOnDeath(dmginfo, hitgroup)
			if setupGibsExtra == nil then setupGibsExtra = {} end
			if setupGibs == true then
				if setupGibsExtra.AllowCorpse != true then self.HasDeathRagdoll = false end
				if setupGibsExtra.DeathAnim != true then self.HasDeathAnimation = false end
				self.HasBeenGibbedOnDeath = true
				self:PlayGibOnDeathSounds(dmginfo, hitgroup)
			end
			break
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local gib_sd1 = "vj_gib/default_gib_splat.wav"
local gib_sd2 = "vj_gib/gibbing1.wav"
local gib_sd3 = "vj_gib/gibbing2.wav"
local gib_sd4 = "vj_gib/gibbing3.wav"
--
function ENT:PlayGibOnDeathSounds(dmginfo, hitgroup)
	if self.HasGibOnDeathSounds == false then return end
	if self:CustomGibOnDeathSounds(dmginfo, hitgroup) == true then
		VJ.EmitSound(self, gib_sd1, 90, math.random(80, 100))
		VJ.EmitSound(self, gib_sd2, 90, math.random(80, 100))
		VJ.EmitSound(self, gib_sd3, 90, math.random(80, 100))
		VJ.EmitSound(self, gib_sd4, 90, math.random(80, 100))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:StartSoundTrack()
	if self.HasSounds == false or self.HasSoundTrack == false then return end
	if math.random(1, self.SoundTrackChance) == 1 then
		self.VJTag_SD_PlayingMusic = true
		net.Start("vj_music_run")
			net.WriteEntity(self)
			net.WriteString(VJ.PICK(self.SoundTbl_SoundTrack))
			net.WriteFloat(self.SoundTrackVolume)
			net.WriteFloat(self.SoundTrackPlaybackRate)
			//net.WriteFloat(self.SoundTrackFadeOutTime)
		net.Broadcast()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RunItemDropsOnDeathCode(dmginfo, hitgroup)
	if self.HasItemDropsOnDeath == false then return end
	if math.random(1, self.ItemDropsOnDeathChance) == 1 then
		self:CustomRareDropsOnDeathCode(dmginfo, hitgroup)
		local pickedEnt = VJ.PICK(self.ItemDropsOnDeath_EntityList)
		if pickedEnt != false then
			local ent = ents.Create(pickedEnt)
			ent:SetPos(self:GetPos() + self:OBBCenter())
			ent:SetAngles(self:GetAngles())
			ent:Spawn()
			ent:Activate()
			local phys = ent:GetPhysicsObject()
			if IsValid(phys) then
				local dmgForce = (self.SavedDmgInfo.force / 40) + self:GetMoveVelocity() + self:GetVelocity()
				if self.DeathAnimationCodeRan then
					dmgForce = self:GetMoveVelocity() == defPos and self:GetGroundSpeedVelocity() or self:GetMoveVelocity()
				end
				phys:SetMass(1)
				phys:ApplyForceCenter(dmgForce)
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRemove()
	self:CustomOnRemove()
	self.Dead = true
	if self.Medic_Status then self:DoMedicReset() end
	if self.VJTag_IsEating then self:EatingReset("Dead") end
	self:RemoveTimers()
	self:StopAllCommonSounds()
	self:StopParticles()
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ ///// OBSOLETE FUNCTIONS | Do not to use! \\\\\ ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
function ENT:DoHardEntityCheck(CustomTbl)
	local EntsTbl = CustomTbl or ents.GetAll()
	local EntsFinal = {}
	local count = 1
	//for k, v in ipairs(CustomTbl) do //ents.FindInSphere(self:GetPos(),30000)
	for x=1, #EntsTbl do
		if !EntsTbl[x]:IsNPC() && !EntsTbl[x]:IsPlayer() then continue end
		local v = EntsTbl[x]
		self:EntitiesToNoCollideCode(v)
		if (v:IsNPC() && v:GetClass() != self:GetClass() && v:GetClass() != "npc_grenade_frag" && v:GetClass() != "bullseye_strider_focus" && v:GetClass() != "npc_bullseye" && v:GetClass() != "npc_enemyfinder" && v:GetClass() != "hornet" && (!v.IsVJBaseSNPC_Animal) && (v.Behavior != VJ_BEHAVIOR_PASSIVE_NATURE) && v:Health() > 0) or (v:IsPlayer() && !VJ_CVAR_IGNOREPLAYERS) then
			EntsFinal[count] = v
			count = count + 1
		end
	end
	//table.Merge(EntsFinal,self.CurrentPossibleEnemies)
	return EntsFinal
end
*/
---------------------------------------------------------------------------------------------------------------------------------------------
/*
function ENT:NoCollide_CombineBall()
	for k, v in ipairs(ents.GetAll()) do
		if v:GetClass() == "prop_combine_ball" then
			constraint.NoCollide(self, v, 0, 0)
		end
	end
end
*/
---------------------------------------------------------------------------------------------------------------------------------------------
/*function ENT:FindEnemy()
//self:AddRelationship( "npc_barnacle  D_LI  99" )
if self.FindEnemy_UseSphere == true then
	self:FindEnemySphere()
end
//if self.UseConeForFindEnemy == false then return end -- NOTE: This function got crossed out because the option at the top got deleted!
local EnemyTargets = VJ.FindInCone(self:GetPos(),self:GetForward(),self.SightDistance,self.SightAngle)
//local LocalTargetTable = {}
if (!EnemyTargets) then return end
//table.Add(EnemyTargets)
for k,v in ipairs(EnemyTargets) do
	//if (v:GetClass() != self:GetClass() && v:GetClass() != "npc_grenade_frag") && v:IsNPC() or (v:IsPlayer() && self.PlayerFriendly == false && !VJ_CVAR_IGNOREPLAYERS) && self:Visible(v) then
	//if self.CombineFriendly == true then if VJ.HasValue(NPCTbl_Combine,v:GetClass()) then return end end
	//if self.ZombieFriendly == true then if VJ.HasValue(NPCTbl_Zombies,v:GetClass()) then return end end
	//if self.AntlionFriendly == true then if VJ.HasValue(NPCTbl_Antlions,v:GetClass()) then return end end
	//if self.PlayerFriendly == true then if VJ.HasValue(NPCTbl_Resistance,v:GetClass()) then return end end
	//if GetConVar("vj_npc_vjfriendly"):GetInt() == 1 then
	//local frivj = ents.FindByClass("npc_vj_*") table.Add(frivj) for _, x in ipairs(frivj) do return end end
	//local vjanimalfriendly = ents.FindByClass("npc_vjanimal_*") table.Add(vjanimalfriendly) for _, x in ipairs(vjanimalfriendly) do return end
	//self:AddEntityRelationship( v, D_HT, 99 )
	//if !v:IsPlayer() then if self:Visible(v) then v:AddEntityRelationship( self, D_HT, 99 ) end end
	if self:DoRelationshipCheck(v) == true && self:Visible(v) then
	self.EnemyReset = true
	self:AddEntityRelationship(v,D_HT,99)
	if !IsValid(self:GetEnemy()) then
		self:SetEnemy(v) //self:GetClosestInTable(EnemyTargets)
		self.MyEnemy = v
		self:UpdateEnemyMemory(v,v:GetPos())
	end
	//table.insert(LocalTargetTable,v)
	//self.EnemyTable = LocalTargetTable
	self:DoAlert()
	//return
  end
 end
 //self:ResetEnemy()
end*/
---------------------------------------------------------------------------------------------------------------------------------------------
/*function ENT:FindEnemySphere()
local EnemyTargets = ents.FindInSphere(self:GetPos(),self.SightDistance)
if (!EnemyTargets) then return end
table.Add(EnemyTargets)
for k,v in ipairs(EnemyTargets) do
	if self:DoRelationshipCheck(v) == true && self:Visible(v) then
	self.EnemyReset = true
	if !IsValid(self:GetEnemy()) then
		self:SetEnemy(v)
		self.MyEnemy = v
		self:UpdateEnemyMemory(v,v:GetPos())
	end
	self:DoAlert()
	//return
  end
 end
end*/
---------------------------------------------------------------------------------------------------------------------------------------------
/*function ENT:VJ_EyeTrace(GetUpNum)
	GetUpNum = GetUpNum or 50
	if IsValid(self:GetEnemy()) && !self.Dead then
		local tr = util.TraceLine({
			start = self:NearestPoint(self:GetEnemy():GetPos() +self:GetEnemy():OBBCenter() +self:GetUp()*GetUpNum),
			endpos = self:GetEnemy():GetPos() +self:GetEnemy():OBBCenter(),
			filter = self
		})
		//if tr.Entity != NULL then print(tr.Entity) end
		//print(tr.Entity)
		//local testprop = ents.Create("prop_dynamic")
		//testprop:SetModel("models/props_wasteland/dockplank01b.mdl")
		//testprop:SetPos(self:NearestPoint(self:GetEnemy():GetPos() +self:GetEnemy():OBBMaxs() +self:GetUp()*50))
		//testprop:Spawn()
		//if tr.HitWorld == false && tr.Entity != NULL && tr.Entity:GetClass() != "prop_physics" then
		//print("true") return true else
		//print("false") return false end
		//print("false") return false
		if tr.HitWorld == true then return false end
		if tr.Entity != NULL then
			return tr
		else
			return false
		end
	 end
	 return false
end*/
---------------------------------------------------------------------------------------------------------------------------------------------
/*function ENT:ThemeMusicCode()
if GetConVar("vj_npc_sd_nosounds"):GetInt() == 0 then
if GetConVar("vj_npc_sd_soundtrack"):GetInt() == 0 then
	self.thememusicsd = CreateSound( player.GetByID( 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,71,72,73,74,75,76,77,78,79,80,81,82,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100 ), self.Theme )
	self.thememusicsd:Play();
	self.thememusicsd:Stop();
	self.thememusicsd:SetSoundLevel( self.SoundTrackLevel )
	if self.thememusicsd:IsPlaying() == false then self.thememusicsd:Play();
   end
  end
 end
end*/
--------------------------------------------------------------------------------------------------------------------------------------------
/*function ENT:GetRelationship(entity)
	if self.HasAllies == false then return end

	local friendslist = {"", "", "", "", "", ""} -- List
	for _,x in ipairs( friendslist ) do
	local hl_friendlys = ents.FindByClass( x )
	for _,x in ipairs( hl_friendlys ) do
	if entity == x then
	return D_LI
	end
  end
 end

	local groupone = ents.FindByClass("npc_vj_example_*") -- Group
	table.Add(groupone)
	for _, x in ipairs(groupone) do
	if entity == x then
	return D_LI
	end
 end

	local groupone = ents.FindByClass("npc_vj_example") -- Single
	for _, x in ipairs(groupone) do
	if entity == x then
	return D_LI
	end
 end
end*/