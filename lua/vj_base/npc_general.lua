/*--------------------------------------------------
	*** Copyright (c) 2012-2021 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.

	///// NOTES \\\\\
	- This file contains functions and variables shared between all the NPC bases.
	- There are useful functions that are commonly called when making custom code in an NPC. (Custom-Friendly Functions)
	- There are also functions that should not called in a custom code. (General Functions)
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
local NPCTbl_Resistance = {npc_magnusson=true,npc_vortigaunt=true,npc_mossman=true,npc_monk=true,npc_kleiner=true,npc_fisherman=true,npc_eli=true,npc_dog=true,npc_barney=true,npc_alyx=true,npc_citizen=true,monster_scientist=true,monster_barney=true}
local NPCTbl_Combine = {npc_stalker=true,npc_rollermine=true,npc_turret_ground=true,npc_turret_floor=true,npc_turret_ceiling=true,npc_strider=true,npc_sniper=true,npc_metropolice=true,npc_hunter=true,npc_breen=true,npc_combine_camera=true,npc_combine_s=true,npc_combinedropship=true,npc_combinegunship=true,npc_cscanner=true,npc_clawscanner=true,npc_helicopter=true,npc_manhack=true}
local NPCTbl_Zombies = {npc_fastzombie_torso=true,npc_zombine=true,npc_zombie_torso=true,npc_zombie=true,npc_poisonzombie=true,npc_headcrab_fast=true,npc_headcrab_black=true,npc_headcrab=true,npc_fastzombie=true,monster_zombie=true,monster_headcrab=true,monster_babycrab=true}
local NPCTbl_Antlions = {npc_antlion=true,npc_antlionguard=true,npc_antlion_worker=true}
local NPCTbl_Xen = {monster_bullchicken=true,monster_alien_grunt=true,monster_alien_slave=true,monster_alien_controller=true,monster_houndeye=true,monster_gargantua=true,monster_nihilanth=true}
local defPos = Vector(0, 0, 0)
local defAng = Angle(0, 0, 0)
local CurTime = CurTime
local IsValid = IsValid
local GetConVarNumber = GetConVarNumber
local istable = istable
local isstring = isstring
local isnumber = isnumber
local tonumber = tonumber
local string_find = string.find
local string_Replace = string.Replace
local table_remove = table.remove
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
function ENT:CreateExtraDeathCorpse(class, models, extraOptions, customFunc)
	-- Should only be ran after self.Corpse has been created!
	if !IsValid(self.Corpse) then return end
	local dmginfo = self.Corpse.DamageInfo
	if dmginfo == nil then return end
	local dmgforce = dmginfo:GetDamageForce()
	class = class or "prop_ragdoll"
	extraOptions = extraOptions or {}
	local ent = ents.Create(class)
	if models != "None" then ent:SetModel(VJ_PICK(models)) end
	ent:SetPos(extraOptions.Pos or self:GetPos())
	ent:SetAngles(extraOptions.Ang or self:GetAngles())
	ent:Spawn()
	ent:Activate()
	ent:SetColor(self.Corpse:GetColor())
	ent:SetMaterial(self.Corpse:GetMaterial())
	ent:SetCollisionGroup(self.DeathCorpseCollisionType)
	if self.Corpse:IsOnFire() then
		ent:Ignite(math.Rand(8,10),0)
		ent:SetColor(Color(90,90,90))
	end
	if extraOptions.HasVel != false then ent:GetPhysicsObject():AddVelocity(extraOptions.Vel or dmgforce / 40) end
	if extraOptions.ShouldFade == true then
		local fadeTime = extraOptions.ShouldFadeTime or 0 
		if ent:GetClass() == "prop_ragdoll" then
			ent:Fire("FadeAndRemove", "", fadeTime)
		else
			ent:Fire("kill", "", fadeTime)
		end
	end
	if extraOptions.RemoveOnCorpseDelete != false then//self.Corpse:DeleteOnRemove(ent)
		self.Corpse.ExtraCorpsesToRemove[#self.Corpse.ExtraCorpsesToRemove + 1] = ent
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
function ENT:CreateGibEntity(class, models, extraOptions, customFunc)
	// self:CreateGibEntity("prop_ragdoll", "", {Pos=self:LocalToWorld(Vector(0,3,0)), Ang=self:GetAngles(), Vel=})
	if self.AllowedToGib == false then return end
	local bloodType = "Red"
	class = class or "obj_vj_gib"
	if models == "UseAlien_Small" then
		models =  VJ_PICK(gib_mdlASmall)
		bloodType = "Yellow"
	elseif models == "UseAlien_Big" then
		models =  VJ_PICK(gib_mdlABig)
		bloodType = "Yellow"
	elseif models == "UseHuman_Small" then
		models =  VJ_PICK(gib_mdlHSmall)
	elseif models == "UseHuman_Big" then
		models =  VJ_PICK(gib_mdlHBig)
	else -- Custom models
		models = VJ_PICK(models)
		if VJ_HasValue(gib_mdlAAll, models) then
			bloodType = "Yellow"
		end
	end
	extraOptions = extraOptions or {}
		local vel = extraOptions.Vel or Vector(math.Rand(-100, 100), math.Rand(-100, 100), math.Rand(150, 250))
		if self.LatestDmgInfo != nil then
			local dmgForce = self.LatestDmgInfo:GetDamageForce() / 70
			if extraOptions.Vel_ApplyDmgForce != false && extraOptions.Vel != "UseDamageForce" then -- Use both damage force AND given velocity
				vel = vel + dmgForce
			elseif extraOptions.Vel == "UseDamageForce" then -- Use damage force
				vel = dmgForce
			end
		end
		bloodType = extraOptions.BloodType or bloodType -- Certain entities such as the VJ Gib entity, you can use this to set its gib type
		local removeOnCorpseDelete = extraOptions.RemoveOnCorpseDelete or false -- Should the entity get removed if the corpse is removed?
	local gib = ents.Create(class)
	gib:SetModel(models)
	gib:SetPos(extraOptions.Pos or (self:GetPos() + self:OBBCenter()))
	gib:SetAngles(extraOptions.Ang or Angle(math.Rand(-180, 180), math.Rand(-180, 180), math.Rand(-180, 180)))
	if gib:GetClass() == "obj_vj_gib" then
		gib.BloodType = bloodType
		gib.Collide_Decal = extraOptions.BloodDecal or "Default"
		gib.CollideSound = extraOptions.CollideSound or "Default"
	end
	gib:Spawn()
	gib:Activate()
	gib.IsVJBase_Gib = true
	gib.RemoveOnCorpseDelete = removeOnCorpseDelete
	if GetConVarNumber("vj_npc_gibcollidable") == 0 then gib:SetCollisionGroup(1) end
	local phys = gib:GetPhysicsObject()
	if IsValid(phys) then
		phys:AddVelocity(vel)
		phys:AddAngleVelocity(extraOptions.AngVel or Vector(math.Rand(-200, 200), math.Rand(-200, 200), math.Rand(-200, 200)))
	end
	if extraOptions.NoFade != true && GetConVarNumber("vj_npc_fadegibs") == 1 then
		if gib:GetClass() == "obj_vj_gib" then timer.Simple(GetConVarNumber("vj_npc_fadegibstime"), function() SafeRemoveEntity(gib) end)
		elseif gib:GetClass() == "prop_ragdoll" then gib:Fire("FadeAndRemove", "", GetConVarNumber("vj_npc_fadegibstime"))
		elseif gib:GetClass() == "prop_physics" then gib:Fire("kill", "", GetConVarNumber("vj_npc_fadegibstime")) end
	end
	if removeOnCorpseDelete == true then //self.Corpse:DeleteOnRemove(extraent)
		self.ExtraCorpsesToRemove_Transition[#self.ExtraCorpsesToRemove_Transition + 1] = gib
	end
	if (customFunc) then customFunc(gib) end
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Checks if the NPC is playing an animation that shouldn't be interrupted OR is playing an attack!
	Returns
		- false, NOT busy
		- true, Busy
-----------------------------------------------------------]]
function ENT:BusyWithActivity()
	return self.vACT_StopAttacks == true or self.PlayingAttackAnimation == true
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
	Checks the relationship with the given entity. Use with caution, it can cause reduce performance!
		- ent = The entity to check its relation with
	Returns
		- false, Entity is friendly
		- "Neutral", Entity is neutral, 
		- true, Entity is hostile
-----------------------------------------------------------]]
function ENT:DoRelationshipCheck(ent)
	local nt_bool, nt_be = self:VJ_HasNoTarget(ent)
	if nt_be == 1 then return true end
	if nt_bool == true or NPCTbl_Animals[ent:GetClass()] then return "Neutral" end
	if self:GetClass() == ent:GetClass() then return false end
	if ent:Health() > 0 && self:Disposition(ent) != D_LI then
		if ent:IsPlayer() && GetConVarNumber("ai_ignoreplayers") == 1 then return "Neutral" end
		if VJ_HasValue(self.VJ_AddCertainEntityAsFriendly,ent) then return false end
		if VJ_HasValue(self.VJ_AddCertainEntityAsEnemy,ent) then return true end
		if (ent:IsNPC() && !ent.FriendlyToVJSNPCs && ((ent:Disposition(self) == D_HT) or (ent:Disposition(self) == D_NU && ent.VJ_IsBeingControlled == true))) or (ent:IsPlayer() && self.PlayerFriendly == false && ent:Alive()) then
			//if ent.VJ_NoTarget == false then
			//if (ent.VJ_NoTarget) then if ent.VJ_NoTarget == false then continue end end
			return true
		else
			return "Neutral"
		end
	end
	return false
end
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
	local picknum = self.UseTheSameGeneralSoundPitch_PickedNumber
	-- If the NPC is set to use the same sound pitch all the time and it's not 0 then use that pitch
	if self.UseTheSameGeneralSoundPitch == true && picknum != 0 then
		finalPitch1 = picknum
		finalPitch2 = picknum
	end
	if pitch1 != false && isnumber(pitch1) then finalPitch1 = pitch1 end
	if pitch2 != false && isnumber(pitch2) then finalPitch2 = pitch2 end
	return math.random(finalPitch1, finalPitch2)
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
	if self.TurningUseAllAxis == true then
		return Angle(ang.x, ang.y, ang.z)
	end
	return Angle(0, ang.y, 0)
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Makes the NPC face a certain position
		- pos = Position to face
		- time = How long should it face that position? | DEFAULT = 0
	Returns
		- Angle, the angle it's going to face
-----------------------------------------------------------]]
function ENT:FaceCertainPosition(pos, time)
	local setangs = Angle(0, ((pos or defPos) - self:GetPos()):Angle().y, 0)
	self:SetAngles(Angle(setangs.p, self:GetAngles().y, setangs.r))
	self:SetIdealYawAndUpdate(setangs.y, speed)
	self.IsDoingFacePosition = setangs
	timer.Create("timer_face_position"..self:EntIndex(), time or 0, 1, function() self.IsDoingFacePosition = false end)
	return setangs
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Makes the NPC face a certain entity
		- ent = Entity to face
		- onlyEnemy = Will only face if the entity is an enemy
		- faceEnemyTime = How long should it face the enemy? | DEFAULT = 0
	Returns
		- Angle, the angle it's going to face
		- false, if it didn't face the enemy
-----------------------------------------------------------]]
function ENT:FaceCertainEntity(ent, onlyEnemy, faceEnemyTime)
	if !IsValid(ent) or GetConVarNumber("ai_disabled") == 1 or (self.MovementType == VJ_MOVETYPE_STATIONARY && self.CanTurnWhileStationary == false) then return false end
	if onlyEnemy == true && IsValid(self:GetEnemy()) then
		self.IsDoingFaceEnemy = true
		timer.Create("timer_face_enemy"..self:EntIndex(), faceEnemyTime or 0, 1, function() self.IsDoingFaceEnemy = false end)
		local setangs = self:GetFaceAngle((ent:GetPos() - self:GetPos()):Angle())
		self:SetIdealYawAndUpdate(setangs.y)
		self:SetAngles(Angle(setangs.p, self:GetAngles().y, setangs.r))
		return setangs //SetLocalAngles
	else
		local setangs = self:GetFaceAngle((ent:GetPos() - self:GetPos()):Angle())
		self:SetIdealYawAndUpdate(setangs.y)
		self:SetAngles(Angle(setangs.p, self:GetAngles().y, setangs.r))
		//self:SetIdealYawAndUpdate(setangs.y)
		return setangs
	end
	return false
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
	if !IsValid(self:GetEnemy()) then return false, {} end
	startPos = startPos or self:GetPos() + self:OBBCenter()
	endPos = endPos or self:GetEnemy():EyePos()
	acceptWorld = acceptWorld or false
	extraOptions = extraOptions or {}
		local setLastHiddenTime = extraOptions.SetLastHiddenTime or false
	local hitEnt = false
	tr = util.TraceLine({
		start = startPos,
		endpos = endPos,
		filter = self
	})
	if extraOptions.Debug == true then
		print("--------------------------------------------")
		PrintTable(tr)
		VJ_CreateTestObject(tr.HitPos)
	end
	-- Sometimes the trace isn't 100%, a tiny find in sphere check fixes this issue...
	for _,v in pairs(ents.FindInSphere(tr.HitPos, 5)) do
		if v == self:GetEnemy() or self:Disposition(v) == 1 or self:Disposition(v) == 2 then
			hitEnt = true
		end
	end
	
	-- Not a hiding zone, it hit an enemy NPC OR it's far from the hit position
	if hitEnt == true or endPos:Distance(tr.HitPos) <= 10 then
		if setLastHiddenTime == true then self.LastHiddenZoneT = 0 end
		return false, tr
	-- Hiding zone detected, it hit world and it's close
	elseif tr.HitWorld == true && self:GetPos():Distance(tr.HitPos) < 200 then
		if setLastHiddenTime == true then self.LastHiddenZoneT = 20 end
		return true, tr
	end

	-- More in depth look...
	if tr.Entity == self:GetEnemy() or (acceptWorld == false && tr.HitWorld == true) then
		if setLastHiddenTime == true then self.LastHiddenZoneT = 0 end
		return false, tr
	else -- Hidden!
		if setLastHiddenTime == true then self.LastHiddenZoneT = CurTime() + 20 end
		return true, tr
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Checks all 4 sides around the NPC
		- checkDist = How far should each trace go? | DEFAULT = 200
	Returns
		- Table dictionary, includes 4 values, if true then that side isn't blocked!
			- Values: Forward, Backward, Right, Left
-----------------------------------------------------------]]
function ENT:VJ_CheckAllFourSides(checkDist)
	checkDist = checkDist or 200
	local result = {Forward=false, Backward=false, Right=false, Left=false}
	local i = 0
	local myPos = self:GetPos() + self:OBBCenter()
	for _, v in ipairs({self:GetForward(), -self:GetForward(), self:GetRight(), -self:GetRight()}) do
		i = i + 1
		tr = util.TraceLine({
			start = myPos,
			endpos = myPos + v*checkDist,
			filter = self
		})
		if self:GetPos():Distance(tr.HitPos) >= checkDist then
			if i == 1 then result.Forward = true end
			if i == 2 then result.Backward = true end
			if i == 3 then result.Right = true end
			if i == 4 then result.Left = true  end
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
	if !IsValid(ent) or self.Behavior == VJ_BEHAVIOR_PASSIVE_NATURE or ent:Health() <= 0 or (ent:IsPlayer() && (!ent:Alive() or GetConVarNumber("ai_ignoreplayers") == 1)) then return end
	stopMoving = stopMoving or false -- Will not run if doQuickIfActiveEnemy passes!
	doQuickIfActiveEnemy = doQuickIfActiveEnemy or false -- It will run a much quicker set enemy without resetting everything (Only if it has an active enemy!)
	if IsValid(self.Medic_CurrentEntToHeal) && self.Medic_CurrentEntToHeal == ent then self:DoMedicCode_Reset() end
	self.TimeSinceLastSeenEnemy = 0
	self:AddEntityRelationship(ent, D_HT, 99)
	self:UpdateEnemyMemory(ent, ent:GetPos())
	if doQuickIfActiveEnemy == true && IsValid(self:GetEnemy()) then self:SetEnemy(ent) return end -- End it here if it's a minor set enemy
	self:SetEnemy(ent)
	self.TimeSinceEnemyAcquired = CurTime()
	self.NextResetEnemyT = CurTime() + 0.5 //2
	if stopMoving == true then
		self:ClearGoal()
		self:StopMoving()
	end
	if self.Alerted == false then
		self.LatestEnemyDistance = self:GetPos():Distance(ent:GetPos())
		self:DoAlert(ent)
	end
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
function ENT:IsJumpLegal(startPos, apex, endPos)
	/*print("---------------------")
	print(startPos)
	print(apex)
	print(endPos)*/
	local result = self:CustomOnIsJumpLegal(startPos, apex, endPos)
	if result != nil then if result == true then self.JumpLegalLandingTime = CurTime() + (endPos:Distance(startPos) / 190) end return result end
	local dist_apex = startPos:Distance(apex)
	local dist_end = startPos:Distance(endPos)
	local maxdist = self.MaxJumpLegalDistance.a -- Var gam Ver | Arachin tive varva hamar ter
	-- Aravel = Ver, Nevaz = Var
	if endPos.z - startPos.z <= 0 then maxdist = self.MaxJumpLegalDistance.b end -- Ver bidi tsadke
	/*print("---------------------")
	print(endPos.z - startPos.z)
	print("Apex: "..dist_apex)
	print("End Pos: "..dist_end)*/
	if dist_apex > maxdist then return nil end
	if dist_end > maxdist then return nil end
	self.JumpLegalLandingTime = CurTime() + (endPos:Distance(startPos) / 190)
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnChangeActivity(newAct)
	//print(newAct)
	self:CustomOnChangeActivity(newAct)
	if newAct == ACT_TURN_LEFT or newAct == ACT_TURN_RIGHT then
		self.NextIdleStandTime = CurTime() + VJ_GetSequenceDuration(self, self:GetSequenceName(self:GetSequence()))
		//self.NextIdleStandTime = CurTime() + 1.2
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:AcceptInput(key, activator, caller, data)
	self:CustomOnAcceptInput(key, activator, caller, data)
	if key == self.FollowPlayerKey then self:FollowPlayerCode(key, activator, caller, data) end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HandleAnimEvent(ev, evTime, evCycle, evType, evOptions)
	self:CustomOnHandleAnimEvent(ev, evTime, evCycle, evType, evOptions)
	/*
	print("----------------------------")
	print(ev)
	print(evTime)
	print(evCycle)
	print(evType)
	print(evOptions)
	*/
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnCondition(cond)
	self:CustomOnCondition(cond)
	//if cond == 36 then print("sched done!") end
	//if cond != 15 && cond != 60 then
	//if cond != 1 then
		//print(self," Condition: ",cond," - ",self:ConditionName(cond))
	//end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Touch(entity)
	if self.VJDEBUG_SNPC_ENABLED == true && GetConVarNumber("vj_npc_printontouch") == 1 then print(self:GetClass().." Has Touched "..entity:GetClass()) end
	self:CustomOnTouch(entity)
	if GetConVarNumber("ai_disabled") == 1 or self.VJ_IsBeingControlled == true then return end
	
	-- If it's a passive SNPC...
	if self.Behavior == VJ_BEHAVIOR_PASSIVE or self.Behavior == VJ_BEHAVIOR_PASSIVE_NATURE then
		if self.Passive_RunOnTouch == true && CurTime() > self.Passive_NextRunOnTouchT && entity.Behavior != VJ_BEHAVIOR_PASSIVE && entity.Behavior != VJ_BEHAVIOR_PASSIVE_NATURE && self:DoRelationshipCheck(entity) != false && (entity:IsNPC() or entity:IsPlayer()) then
			self:VJ_TASK_COVER_FROM_ENEMY("TASK_RUN_PATH")
			self:PlaySoundSystem("Alert")
			self.Passive_NextRunOnTouchT = CurTime() + math.Rand(self.Passive_NextRunOnTouchTime.a, self.Passive_NextRunOnTouchTime.b)
		end
	elseif self.DisableTouchFindEnemy == false && !IsValid(self:GetEnemy()) && self.FollowingPlayer == false && (entity:IsNPC() or entity:IsPlayer()) && self:DoRelationshipCheck(entity) != false then
		self:StopMoving()
		self:SetTarget(entity)
		self:VJ_TASK_FACE_X("TASK_FACE_TARGET")
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:FollowPlayerReset()
	if self.AllowPrintingInChat == true && self.FollowPlayerChat == true then
		if self.Dead == true then
			self.FollowPlayer_Entity:PrintMessage(HUD_PRINTTALK, self:GetName().." has been killed.")
		else
			self.FollowPlayer_Entity:PrintMessage(HUD_PRINTTALK, self:GetName().." is no longer following you.")
		end
	end
	self.FollowingPlayer = false
	self.FollowPlayer_GoingAfter = false
	self.FollowPlayer_Entity = NULL
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:FollowPlayerCode(key, activator, caller, data)
	if self.Dead == true or self.FollowPlayer == false or GetConVarNumber("ai_disabled") == 1 or GetConVarNumber("ai_ignoreplayers") == 1 then return end
	
	if IsValid(activator) && activator:IsPlayer() && activator:Alive() then
		if self:Disposition(activator) == D_HT then -- If it's an enemy
			if self.AllowPrintingInChat == true && self.FollowPlayerChat == true then
				activator:PrintMessage(HUD_PRINTTALK, self:GetName().." is hostile to you, therefore it won't follow you.")
			end
			return
		elseif self:Disposition(activator) == D_NU then -- If it's neutral
			if self.AllowPrintingInChat == true && self.FollowPlayerChat == true then
				activator:PrintMessage(HUD_PRINTTALK, self:GetName().." is neutral to you, therefore it won't follow you.")
			end
			return
		elseif self.FollowingPlayer == true && activator != self.FollowPlayer_Entity then -- Already following a player
			if self.AllowPrintingInChat == true && self.FollowPlayerChat == true then
				activator:PrintMessage(HUD_PRINTTALK, self:GetName().." is already following another player, therefore it won't follow you.")
			end
			return
		end
		
		self:CustomOnFollowPlayer(key, activator, caller, data)
		if self.MovementType == VJ_MOVETYPE_STATIONARY or self.MovementType == VJ_MOVETYPE_PHYSICS then
			if self.AllowPrintingInChat == true && self.FollowPlayerChat == true then
				activator:PrintMessage(HUD_PRINTTALK, self:GetName().." is currently stationary, therefore it's unable follow you.")
			end
			return
		end
		
		if self.FollowingPlayer == false then
			if self.AllowPrintingInChat == true && self.FollowPlayerChat == true then
				activator:PrintMessage(HUD_PRINTTALK, self:GetName().." is now following you.")
			end
			self.GuardingPosition = nil -- Reset the guarding position
			self.GuardingFacePosition = nil
			self.FollowPlayer_Entity = activator
			self.FollowingPlayer = true
			self:PlaySoundSystem("FollowPlayer")
			self:SetTarget(activator)
			if self:BusyWithActivity() == false then -- Face the player and then walk or run to it
				self:StopMoving()
				self:VJ_TASK_FACE_X("TASK_FACE_TARGET", function(x)
					x.RunCode_OnFinish = function()
						local movet = ((self:GetPos():Distance(self.FollowPlayer_Entity:GetPos()) < 220) and "TASK_WALK_PATH") or "TASK_RUN_PATH"
						self:VJ_TASK_GOTO_TARGET(movet, function(y) y.CanShootWhenMoving = true y.ConstantlyFaceEnemy = true end) 
					end
				end)
			end
		else -- Unfollow the player
			self:PlaySoundSystem("UnFollowPlayer")
			self:StopMoving()
			self.NextWanderTime = CurTime() + 2
			if self:BusyWithActivity() == false then
				self:VJ_TASK_FACE_X("TASK_FACE_TARGET")
			end
			self:FollowPlayerReset()
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoMedicCode_Reset()
	self:CustomOnMedic_OnReset()
	if IsValid(self.Medic_CurrentEntToHeal) then self.Medic_CurrentEntToHeal.AlreadyBeingHealedByMedic = false end
	if IsValid(self.Medic_SpawnedProp) then self.Medic_SpawnedProp:Remove() end
	self.Medic_NextHealT = CurTime() + math.Rand(self.Medic_NextHealTime.a, self.Medic_NextHealTime.b)
	self.Medic_IsHealingAlly = false
	self.AlreadyDoneMedicThinkCode = false
	self.Medic_CurrentEntToHeal = NULL
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoMedicCode()
	if self.IsMedicSNPC == false or self.NoWeapon_UseScaredBehavior_Active == true then return end
	if self.Medic_IsHealingAlly == false then
		if CurTime() < self.Medic_NextHealT or self.VJ_IsBeingControlled == true then return end
		for _,v in pairs(ents.FindInSphere(self:GetPos(), self.Medic_CheckDistance)) do
			if v.IsVJBaseSNPC != true && !v:IsPlayer() then continue end -- If it's not a VJ Base SNPC or a player, then move on
			if v:EntIndex() != self:EntIndex() && v.AlreadyBeingHealedByMedic != true && (!v.IsVJBaseSNPC_Tank) && (v:Health() <= v:GetMaxHealth() * 0.75) && ((v.Medic_CanBeHealed == true && !IsValid(self:GetEnemy()) && !IsValid(v:GetEnemy())) or (v:IsPlayer() && GetConVarNumber("ai_ignoreplayers") == 0)) && self:DoRelationshipCheck(v) == false then
				self.Medic_CurrentEntToHeal = v
				self.Medic_IsHealingAlly = true
				self.AlreadyDoneMedicThinkCode = false
				v.AlreadyBeingHealedByMedic = true
				self:StopMoving()
				self:SetTarget(v)
				self:VJ_TASK_GOTO_TARGET()
				return
			end
		end
	elseif self.AlreadyDoneMedicThinkCode == false then
		if !IsValid(self.Medic_CurrentEntToHeal) or VJ_IsAlive(self.Medic_CurrentEntToHeal) != true or (self.Medic_CurrentEntToHeal:Health() > self.Medic_CurrentEntToHeal:GetMaxHealth() * 0.75) then self:DoMedicCode_Reset() return end
		if self:GetPos():Distance(self.Medic_CurrentEntToHeal:GetPos()) <= self.Medic_HealDistance then -- Are we in healing distance?
			self.AlreadyDoneMedicThinkCode = true
			self:CustomOnMedic_BeforeHeal()
			self:PlaySoundSystem("MedicBeforeHeal")
			
			-- Spawn the prop
			if self.Medic_SpawnPropOnHeal == true && self:LookupAttachment(self.Medic_SpawnPropOnHealAttachment) != 0 then
				self.Medic_SpawnedProp = ents.Create("prop_physics")
				self.Medic_SpawnedProp:SetModel(self.Medic_SpawnPropOnHealModel)
				self.Medic_SpawnedProp:SetLocalPos(self:GetPos())
				self.Medic_SpawnedProp:SetOwner(self)
				self.Medic_SpawnedProp:SetParent(self)
				self.Medic_SpawnedProp:Fire("SetParentAttachment", self.Medic_SpawnPropOnHealAttachment)
				self.Medic_SpawnedProp:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
				self.Medic_SpawnedProp:Spawn()
				self.Medic_SpawnedProp:Activate()
				self.Medic_SpawnedProp:SetSolid(SOLID_NONE)
				//self.Medic_SpawnedProp:AddEffects(EF_BONEMERGE)
				self.Medic_SpawnedProp:SetRenderMode(RENDERMODE_TRANSALPHA)
				self:DeleteOnRemove(self.Medic_SpawnedProp)
			end
			
			local anim = VJ_PICK(self.AnimTbl_Medic_GiveHealth)
			self:FaceCertainEntity(self.Medic_CurrentEntToHeal, false)
			if self.Medic_DisableAnimation != true then
				self:VJ_ACT_PLAYACTIVITY(anim, true, false, false)
			end
			
			-- Make the ally turn and look at me
			local noturn = (self.Medic_CurrentEntToHeal.MovementType == VJ_MOVETYPE_STATIONARY and self.Medic_CurrentEntToHeal.CanTurnWhileStationary == false) or false
			if !self.Medic_CurrentEntToHeal:IsPlayer() && noturn == false then
				self.NextWanderTime = CurTime() + 2
				self.NextChaseTime = CurTime() + 2
				self.Medic_CurrentEntToHeal:StopMoving()
				self.Medic_CurrentEntToHeal:SetTarget(self)
				self.Medic_CurrentEntToHeal:VJ_TASK_FACE_X("TASK_FACE_TARGET")
			end
			
			timer.Simple(self:DecideAnimationLength(anim, self.Medic_TimeUntilHeal, 0), function()
				if IsValid(self) then
					if !IsValid(self.Medic_CurrentEntToHeal) then -- Ally doesn't exist anymore, reset
						self:DoMedicCode_Reset()
					else -- If it exists...
						if self:GetPos():Distance(self.Medic_CurrentEntToHeal:GetPos()) <= self.Medic_HealDistance then -- Are we still in healing distance?
							self:CustomOnMedic_OnHeal()
							self:PlaySoundSystem("MedicOnHeal")
							if self.Medic_CurrentEntToHeal.IsVJBaseSNPC == true then
								self.Medic_CurrentEntToHeal:PlaySoundSystem("MedicReceiveHeal")
							end
							self.Medic_CurrentEntToHeal:RemoveAllDecals()
							local fricurhp = self.Medic_CurrentEntToHeal:Health()
							self.Medic_CurrentEntToHeal:SetHealth(math.Clamp(fricurhp + self.Medic_HealthAmount, fricurhp, self.Medic_CurrentEntToHeal:GetMaxHealth()))
							self:DoMedicCode_Reset()
						else -- If we are no longer in healing distance, go after the ally again
							self.AlreadyDoneMedicThinkCode = false
							if IsValid(self.Medic_SpawnedProp) then self.Medic_SpawnedProp:Remove() end
							self:CustomOnMedic_OnReset()
						end
					end
				end
			end)
		else -- If we aren't in healing distance, then go after the ally
			self.NextIdleTime = CurTime() + 4
			self.NextChaseTime = CurTime() + 4
			self:SetTarget(self.Medic_CurrentEntToHeal)
			self:VJ_TASK_GOTO_TARGET()
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoConstantlyFaceEnemyCode()
	if self.VJ_IsBeingControlled == true or self.ConstantlyFaceEnemy != true then return false end
	if self:GetEnemy():GetPos():Distance(self:GetPos()) < self.ConstantlyFaceEnemyDistance then
		if self.ConstantlyFaceEnemy_IfVisible == true && !self:Visible(self:GetEnemy()) then return false end -- Only face if the enemy is visible!
		if self.ConstantlyFaceEnemy_IfAttacking == false && (self.MeleeAttacking == true or self.LeapAttacking == true or self.RangeAttacking == true or self.ThrowingGrenade == true) then return false end
		if (self.ConstantlyFaceEnemy_Postures == "Both") or (self.ConstantlyFaceEnemy_Postures == "Moving" && self:IsMoving()) or (self.ConstantlyFaceEnemy_Postures == "Standing" && !self:IsMoving()) then
			self:FaceCertainEntity(self:GetEnemy())
			return true
		end
	end
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:VJ_PlaySequence(seq, playbackRate, wait, waitTime, interruptible)
	if !seq then return end
	if interruptible == true then
		self.VJ_PlayingSequence = false
		self.VJ_PlayingInterruptSequence = true
	else
		self.VJ_PlayingSequence = true
		self.VJ_PlayingInterruptSequence = false
	end
	
	self:ClearSchedule()
	self:StopMoving()
	self:ResetSequence(self:LookupSequence(VJ_PICK(seq)))
	self:ResetSequenceInfo()
	self:SetCycle(0) -- Start from the beginning
	if isnumber(playbackRate) then
		self.AnimationPlaybackRate = playbackRate
		self:SetPlaybackRate(playbackRate)
	end
	if wait == true then
		timer.Create("timer_act_seq_wait"..self:EntIndex(), waitTime, 1, function()
			self.VJ_PlayingInterruptSequence = false
			self.VJ_PlayingSequence = false
			//self.vACT_StopAttacks = false
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoAlert(ent)
	if !IsValid(self:GetEnemy()) or self.Alerted == true then return end
	self.Alerted = true
	self.LastSeenEnemyTime = 0
	self:CustomOnAlert(ent)
	if CurTime() > self.NextAlertSoundT then
		self:PlaySoundSystem("Alert")
		if self.AlertSounds_OnlyOnce == true then
			self.HasAlertSounds = false
		end
		self.NextAlertSoundT = CurTime() + math.Rand(self.NextSoundTime_Alert1,self.NextSoundTime_Alert2)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoEntityRelationshipCheck()
	if self.Behavior == VJ_BEHAVIOR_PASSIVE_NATURE /*or self.Behavior == VJ_BEHAVIOR_PASSIVE*/ then return false end
	local posenemies = self.CurrentPossibleEnemies
	if posenemies == nil then return false end
	//if CurTime() > self.NextHardEntityCheckT then
		//self.CurrentPossibleEnemies = self:DoHardEntityCheck()
	//self.NextHardEntityCheckT = CurTime() + math.random(self.NextHardEntityCheck1,self.NextHardEntityCheck2) end
	//print(self:GetName().."'s Enemies:")
	//PrintTable(posenemies)

	/*if table.Count(self.CurrentPossibleEnemies) == 0 && CurTime() > self.NextHardEntityCheckT then
		self.CurrentPossibleEnemies = self:DoHardEntityCheck()
	self.NextHardEntityCheckT = CurTime() + math.random(50,70) end*/
	
	self.ReachableEnemyCount = 0
	//local distlist = {}
	local eneSeen = false
	local myPos = self:GetPos()
	local nearestDist = nil
	local mySDir = self:GetSightDirection()
	local mySAng = math.cos(math.rad(self.SightAngle))
	local it = 1
	//for k, v in ipairs(posenemies) do
	//for it = 1, #posenemies do
	while it <= #posenemies do
		local v = posenemies[it]
		if !IsValid(v) then
			table_remove(posenemies, it)
		else
			it = it + 1
			//if !IsValid(v) then table_remove(self.CurrentPossibleEnemies,tonumber(v)) continue end
			//if !IsValid(v) then continue end
			if self:VJ_HasNoTarget(v) == true then
				if IsValid(self:GetEnemy()) && self:GetEnemy() == v then
					self:ResetEnemy(false)
				end
				continue
			end
			//if v:Health() <= 0 then table_remove(self.CurrentPossibleEnemies,k) continue end
			local vPos = v:GetPos()
			local vDistanceToMy = vPos:Distance(myPos)
			local sightDist = self.SightDistance
			if vDistanceToMy > sightDist then continue end
			local entFri = false
			local vClass = v:GetClass()
			local vNPC = v:IsNPC()
			local vPlayer = v:IsPlayer()
			if vClass != self:GetClass() && (vNPC or vPlayer) && (v.Behavior != VJ_BEHAVIOR_PASSIVE_NATURE) /*&& MyVisibleTov && self:Disposition(v) != D_LI*/ then
				local inEneTbl = VJ_HasValue(self.VJ_AddCertainEntityAsEnemy, v)
				if self.HasAllies == true && inEneTbl == false then
					for _,friclass in ipairs(self.VJ_NPC_Class) do
						if friclass == varCPly && self.PlayerFriendly == false then self.PlayerFriendly = true end -- If player ally then set the PlayerFriendly to true
						if (friclass == varCCom && NPCTbl_Combine[vClass]) or (friclass == varCZom && NPCTbl_Zombies[vClass]) or (friclass == varCAnt && NPCTbl_Antlions[vClass]) or (friclass == varCXen && NPCTbl_Xen[vClass]) then
							v:AddEntityRelationship(self, D_LI, 99)
							self:AddEntityRelationship(v, D_LI, 99)
							entFri = true
						end
						if (v.VJ_NPC_Class && VJ_HasValue(v.VJ_NPC_Class, friclass)) or (entFri == true) then
							if friclass == varCPly then -- If we have the player ally class then check if we both of us are supposed to be friends
								if self.FriendsWithAllPlayerAllies == true && v.FriendsWithAllPlayerAllies == true then
									entFri = true
									if vNPC then v:AddEntityRelationship(self, D_LI, 99) end
									self:AddEntityRelationship(v, D_LI, 99)
								end
							else
								entFri = true
								-- If I am enemy to it, then reset it!
								if IsValid(self:GetEnemy()) && self:GetEnemy() == v then
									self.ResetedEnemy = true
									self:ResetEnemy(false)
								end
								if vNPC then v:AddEntityRelationship(self, D_LI, 99) end
								self:AddEntityRelationship(v, D_LI, 99)
							end
						end
					end
					if vNPC && !entFri then
						-- Deprecated system
						/*for _,fritbl in ipairs(self.VJ_FriendlyNPCsGroup) do
							if string_find(vClass, fritbl) then
								entFri = true
								v:AddEntityRelationship(self, D_LI, 99)
								self:AddEntityRelationship(v, D_LI, 99)
							end
						end
						if VJ_HasValue(self.VJ_FriendlyNPCsSingle,vClass) then
							entFri = true
							v:AddEntityRelationship(self, D_LI, 99)
							self:AddEntityRelationship(v, D_LI, 99)
						end*/
						-- Mostly used for non-VJ friendly NPCs
						if self.PlayerFriendly == true && (NPCTbl_Resistance[vClass] or (self.FriendsWithAllPlayerAllies == true && v.PlayerFriendly == true && v.FriendsWithAllPlayerAllies == true)) then
							v:AddEntityRelationship(self, D_LI, 99)
							self:AddEntityRelationship(v, D_LI, 99)
							entFri = true
						end
						if self.VJFriendly == true && v.IsVJBaseSNPC == true then
							v:AddEntityRelationship(self, D_LI, 99)
							self:AddEntityRelationship(v, D_LI, 99)
							entFri = true
						end
					end
				end
				if entFri == false && vNPC /*&& MyVisibleTov*/ && self.DisableMakingSelfEnemyToNPCs == false && (v.VJ_IsBeingControlled != true) then v:AddEntityRelationship(self, D_HT, 99) end
				if vPlayer && (self.PlayerFriendly == true or entFri == true) then
					if inEneTbl == false then
						entFri = true
						self:AddEntityRelationship(v, D_LI, 99)
						//DoPlayerSight()
					else
						entFri = false
					end
				end
				-- Investigation detection systems, including sound, movement and flashlight
				if (!self.IsVJBaseSNPC_Tank) && !IsValid(self:GetEnemy()) && entFri == false then
					if vPlayer then
						if entFri == false then self:AddEntityRelationship(v, D_NU, 99) end
						if v:Crouching() && v:GetMoveType() != MOVETYPE_NOCLIP then
							sightDist = self.VJ_IsHugeMonster == true and 5000 or 2000
						end
						if vDistanceToMy < 350 && v:FlashlightIsOn() == true && (v:GetForward():Dot((myPos - vPos):GetNormalized()) > math.cos(math.rad(20))) then
							//			   Asiga hoser ^ (!v:Crouching() && v:GetVelocity():Length() > 0 && v:GetMoveType() != MOVETYPE_NOCLIP && ((!v:KeyDown(IN_WALK) && (v:KeyDown(IN_FORWARD) or v:KeyDown(IN_BACK) or v:KeyDown(IN_MOVELEFT) or v:KeyDown(IN_MOVERIGHT))) or (v:KeyDown(IN_SPEED) or v:KeyDown(IN_JUMP)))) or
							self:SetTarget(v)
							self:VJ_TASK_FACE_X("TASK_FACE_TARGET")
						end
					end
					if v.VJ_LastInvestigateSdLevel && vDistanceToMy < (self.InvestigateSoundDistance * v.VJ_LastInvestigateSdLevel) && ((CurTime() - v.VJ_LastInvestigateSd) <= 1) && self.NextInvestigateSoundMove < CurTime() then
						if self:Visible(v) then
							self:StopMoving()
							self:SetTarget(v)
							self:VJ_TASK_FACE_X("TASK_FACE_TARGET")
						elseif self.FollowingPlayer == false then
							self:SetLastPosition(vPos)
							self:VJ_TASK_GOTO_LASTPOS("TASK_WALK_PATH")
						end
						self:CustomOnInvestigate(v)
						self:PlaySoundSystem("InvestigateSound")
						self.NextInvestigateSoundMove = CurTime() + 2
					end
				end
			end
			/*print("----------")
			print(self:HasEnemyEluded(v))
			print(self:HasEnemyMemory(v))
			print(CurTime() - self:GetEnemyLastTimeSeen(v))
			print(CurTime() - self:GetEnemyFirstTimeSeen(v))*/
			-- We have to do this here so we make sure non-VJ NPCs can still target this SNPC!
			if self.VJ_IsBeingControlled == true && self.VJ_TheControllerBullseye != v then
				//self:AddEntityRelationship(v, D_NU, 99)
				v = self.VJ_TheControllerBullseye
				vPlayer = false
			end
			local radiusoverride = 0
			if self.DisableFindEnemy == false && ((self.Behavior == VJ_BEHAVIOR_NEUTRAL && self.Alerted == true) or self.Behavior != VJ_BEHAVIOR_NEUTRAL) && ((self.FindEnemy_CanSeeThroughWalls == true) or (self:Visible(v) && (vDistanceToMy < sightDist))) && ((self.FindEnemy_UseSphere == false && radiusoverride == 0 && (mySDir:Dot((vPos - myPos):GetNormalized()) > mySAng)) or (self.FindEnemy_UseSphere == true or radiusoverride == 1)) then
				local check = self:DoRelationshipCheck(v)
				if check == true then -- Is enemy
					eneSeen = true
					self.ReachableEnemyCount = self.ReachableEnemyCount + 1
					self:AddEntityRelationship(v, D_HT, 99)
					-- If the detected enemy is closer than the previous enemy, the set this as the enemy!
					if (nearestDist == nil) or (vDistanceToMy < nearestDist) then
						nearestDist = vDistanceToMy
						self:VJ_DoSetEnemy(v, true, true)
					end
				-- If the current enemy is a friendly player, then reset the enemy!
				elseif check == false && vPlayer && IsValid(self:GetEnemy()) && self:GetEnemy() == v then
					self.ResetedEnemy = true
					self:ResetEnemy(false)
				end
			end
			if vPlayer then
				if entFri == true && self.MoveOutOfFriendlyPlayersWay == true && self.IsGuard == false && !self:IsMoving() && CurTime() > self.TakingCoverT && self.VJ_IsBeingControlled == false && (!self.IsVJBaseSNPC_Tank) && self:BusyWithActivity() == false then
					local dist = 20
					if self.FollowingPlayer == true then dist = 10 end
					if /*self:Disposition(v) == D_LI &&*/ (self:VJ_GetNearestPointToEntityDistance(v) < dist) && v:GetVelocity():Length() > 0 && v:GetMoveType() != MOVETYPE_NOCLIP then
						self.NextFollowPlayerT = CurTime() + 2
						self:PlaySoundSystem("MoveOutOfPlayersWay")
						//self:SetLastPosition(self:GetPos() + self:GetRight()*math.random(-50,-50))
						self:SetMovementActivity(VJ_PICK(self.AnimTbl_Run))
						local vsched = ai_vj_schedule.New("vj_move_away")
						vsched:EngTask("TASK_MOVE_AWAY_PATH", 120)
						vsched:EngTask("TASK_RUN_PATH", 0)
						vsched:EngTask("TASK_WAIT_FOR_MOVEMENT", 0)
						/*vsched.RunCode_OnFinish = function()
							timer.Simple(0.1,function()
								if IsValid(self) then
									self:SetTarget(v)
									local vschedMoveAwayFail = ai_vj_schedule.New("vj_move_away_fail")
									vschedMoveAwayFail:EngTask("TASK_FACE_TARGET", 0)
									self:StartSchedule(vschedMoveAwayFail)
								end
							end)
						end*/
						//vsched.CanShootWhenMoving = true
						//vsched.ConstantlyFaceEnemy = true
						vsched.IsMovingTask = true
						vsched.IsMovingTask_Run = true
						self:StartSchedule(vsched)
						self.TakingCoverT = CurTime() + 0.2
					end
				end
				
				-- HasOnPlayerSight system, used to do certain actions when it sees the player
				if self.HasOnPlayerSight == true && v:Alive() &&(CurTime() > self.OnPlayerSightNextT) && (v:GetPos():Distance(self:GetPos()) < self.OnPlayerSightDistance) && self:Visible(v) && (self:GetSightDirection():Dot((v:GetPos() - self:GetPos()):GetNormalized()) > math.cos(math.rad(self.SightAngle))) then
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
			self:CustomOnEntityRelationshipCheck(v, entFri, vDistanceToMy)
		end
		//return true
	end
	if eneSeen == true then return true else return false end
	//return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Allies_CallHelp(dist)
	if self.CallForHelp == false or self.ThrowingGrenade == true then return false end
	local entsTbl = ents.FindInSphere(self:GetPos(), dist)
	if (!entsTbl) then return false end
	for _,v in pairs(entsTbl) do
		if v:IsNPC() && v != self && v.IsVJBaseSNPC == true && VJ_IsAlive(v) == true && (v:GetClass() == self:GetClass() or v:Disposition(self) == D_LI) && v.Behavior != VJ_BEHAVIOR_PASSIVE_NATURE /*&& v.FollowingPlayer == false*/ && v.VJ_IsBeingControlled == false && (!v.IsVJBaseSNPC_Tank) && v.CallForHelp == true then
			local ene = self:GetEnemy()
			if IsValid(ene) then
				if v:GetPos():Distance(ene:GetPos()) > v.SightDistance then continue end -- Enemy to far away for ally, discontinue!
				//if v:DoRelationshipCheck(ene) == true then
				if !IsValid(v:GetEnemy()) && ((!ene:IsPlayer() && v:Disposition(ene) != D_LI) or (ene:IsPlayer())) then
					if v.IsGuard == true && !v:Visible(ene) then continue end -- If it's guarding and enemy is not visible, then don't call!
					self:CustomOnCallForHelp(v)
					self:PlaySoundSystem("CallForHelp")
					-- Play the animation
					if self.HasCallForHelpAnimation == true && CurTime() > self.NextCallForHelpAnimationT then
						local pickanim = VJ_PICK(self.AnimTbl_CallForHelp)
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
	if (!entsTbl) then return end
	local FoundAlliesTbl = {}
	local it = 0
	for _, v in pairs(entsTbl) do
		if VJ_IsAlive(v) == true && v:IsNPC() && v != self && (v:GetClass() == self:GetClass() or (v:Disposition(self) == D_LI or v.Behavior == VJ_BEHAVIOR_PASSIVE_NATURE)) && (v.BringFriendsOnDeath == true or v.CallForBackUpOnDamage == true or v.CallForHelp == true) then
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
		return nil
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
	local it = 0
	for _, v in pairs(entsTbl) do
		if VJ_IsAlive(v) == true && v:IsNPC() && v != self && (v:GetClass() == self:GetClass() or v:Disposition(self) == D_LI) && v.Behavior != VJ_BEHAVIOR_PASSIVE && v.Behavior != VJ_BEHAVIOR_PASSIVE_NATURE && v.FollowingPlayer == false && v.VJ_IsBeingControlled == false && (!v.IsVJBaseSNPC_Tank) && (v.BringFriendsOnDeath == true or v.CallForBackUpOnDamage == true or v.CallForHelp == true) then
			if onlyVis == true && !v:Visible(self) then continue end
			if !IsValid(v:GetEnemy()) && self:GetPos():Distance(v:GetPos()) < dist then
				self.NextWanderTime = CurTime() + 8
				v.NextWanderTime = CurTime() + 8
				it = it + 1
				-- Formation
				if formType == "Random" then
					local randpos = math.random(1, 4)
					if randpos == 1 then
						v:SetLastPosition(self:GetPos() + self:GetRight()*math.random(20, 50))
					elseif randpos == 2 then
						v:SetLastPosition(self:GetPos() + self:GetRight()*math.random(-20, -50))
					elseif randpos == 3 then
						v:SetLastPosition(self:GetPos() + self:GetForward()*math.random(20, 50))
					elseif randpos == 4 then
						v:SetLastPosition(self:GetPos() + self:GetForward()*math.random(-20, -50))
					end
				elseif formType == "Diamond" then
					v:DoGroupFormation("Diamond", self, it)
				end
				-- Move type
				if v.IsVJBaseSNPC_Human == true && !IsValid(v:GetActiveWeapon()) then
					v:VJ_TASK_COVER_FROM_ENEMY("TASK_RUN_PATH")
				else
					v:VJ_TASK_GOTO_LASTPOS("TASK_WALK_PATH", function(x) x.CanShootWhenMoving = true x.ConstantlyFaceEnemy = true end)
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
			result = animDur - (untilDamage / self:GetPlaybackRate())
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
	if (self.OnlyDoKillEnemyWhenClear == false) or (self.OnlyDoKillEnemyWhenClear == true && (!IsValid(self:GetEnemy()) or (self.ReachableEnemyCount <= 1))) then
		self:CustomOnDoKilledEnemy(ent, attacker, inflictor)
		self:PlaySoundSystem("OnKilledEnemy")
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoFlinch(dmginfo, hitgroup)
	if self.CanFlinch == 0 or self.Flinching == true or self.TakingCoverT > CurTime() or self.NextFlinchT > CurTime() or (IsValid(dmginfo:GetInflictor()) && IsValid(dmginfo:GetAttacker()) && dmginfo:GetInflictor():GetClass() == "entityflame" && dmginfo:GetAttacker():GetClass() == "entityflame") then return end

	local function RunFlinchCode(HitBoxInfo)
		self.Flinching = true
		self:StopAttacks(true)
		self.PlayingAttackAnimation = false
		local animtbl = self.AnimTbl_Flinch
		if HitBoxInfo != nil then animtbl = HitBoxInfo.Animation end
		local anim = VJ_PICK(animtbl)
		local animdur = self:DecideAnimationLength(anim, false, self.FlinchAnimationDecreaseLengthAmount)
		if self.NextMoveAfterFlinchTime != "LetBaseDecide" && self.NextMoveAfterFlinchTime != false then animdur = self.NextMoveAfterFlinchTime end -- "LetBaseDecide" = Backwards compatibility
		self:VJ_ACT_PLAYACTIVITY(anim, true, animdur, false, 0, {SequenceDuration=animdur, PlayBackRateCalculated=true})
		timer.Create("timer_act_flinching"..self:EntIndex(), animdur, 1, function() self.Flinching = false end)
		self:CustomOnFlinch_AfterFlinch(dmginfo, hitgroup)
		self.NextFlinchT = CurTime() + self.NextFlinchTime
	end

	if math.random(1, self.FlinchChance) == 1 && ((self.CanFlinch == 1) or (self.CanFlinch == 2 && VJ_HasValue(self.FlinchDamageTypes, dmginfo:GetDamageType()))) then
		if self:CustomOnFlinch_BeforeFlinch(dmginfo, hitgroup) == false then return end
		if self.HasHitGroupFlinching == true then -- Hitgroup flinching
			local HitGroupFound = false
			-- Search through the hitgroup tables
			for _, v in ipairs(self.HitGroupFlinching_Values) do
				if VJ_HasValue(v.HitGroup, hitgroup) then
					HitGroupFound = true
					RunFlinchCode(v)
				end
			end
			if HitGroupFound == false && self.HitGroupFlinching_DefaultWhenNotHit == true then
				RunFlinchCode(nil)
			end
		else -- Non-hitgroup
			RunFlinchCode(nil)
		end
	end
end
/*
	self.CurrentChoosenBlood_Particle, self.CurrentChoosenBlood_Decal, self.CurrentChoosenBlood_Pool = {}
*/
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetupBloodColor()
	local Type = self.BloodColor
	if Type == "" then return end
	if Type == "Red" then
		if VJ_PICK(self.CustomBlood_Particle) == false then self.CustomBlood_Particle = {"blood_impact_red_01"} end // vj_impact1_red
		if VJ_PICK(self.CustomBlood_Decal) == false then
			if self.BloodDecalUseGMod == true then
				self.CustomBlood_Decal = {"Blood"}
			else
				self.CustomBlood_Decal = {"VJ_Blood_Red"}
			end
		end
		if VJ_PICK(self.CustomBlood_Pool) == false then
			if self.BloodPoolSize == "Small" then
				self.CustomBlood_Pool = {"vj_bleedout_red_small"}
			elseif self.BloodPoolSize == "Tiny" then
				self.CustomBlood_Pool = {"vj_bleedout_red_tiny"}
			else
				self.CustomBlood_Pool = {"vj_bleedout_red"}
			end
		end
	elseif Type == "Yellow" then
		if VJ_PICK(self.CustomBlood_Particle) == false then self.CustomBlood_Particle = {"blood_impact_yellow_01"} end // vj_impact1_yellow
		if VJ_PICK(self.CustomBlood_Decal) == false then
			if self.BloodDecalUseGMod == true then
				self.CustomBlood_Decal = {"YellowBlood"}
			else
				self.CustomBlood_Decal = {"VJ_Blood_Yellow"}
			end
		end
		if VJ_PICK(self.CustomBlood_Pool) == false then
			if self.BloodPoolSize == "Small" then
				self.CustomBlood_Pool = {"vj_bleedout_yellow_small"}
			elseif self.BloodPoolSize == "Tiny" then
				self.CustomBlood_Pool = {"vj_bleedout_yellow_tiny"}
			else
				self.CustomBlood_Pool = {"vj_bleedout_yellow"}
			end
		end
	elseif Type == "Green" then
		if VJ_PICK(self.CustomBlood_Particle) == false then self.CustomBlood_Particle = {"vj_impact1_green"} end
		if VJ_PICK(self.CustomBlood_Decal) == false then self.CustomBlood_Decal = {"VJ_Blood_Green"} end
		if VJ_PICK(self.CustomBlood_Pool) == false then
			if self.BloodPoolSize == "Small" then
				self.CustomBlood_Pool = {"vj_bleedout_green_small"}
			elseif self.BloodPoolSize == "Tiny" then
				self.CustomBlood_Pool = {"vj_bleedout_green_tiny"}
			else
				self.CustomBlood_Pool = {"vj_bleedout_green"}
			end
		end
	elseif Type == "Orange" then
		if VJ_PICK(self.CustomBlood_Particle) == false then self.CustomBlood_Particle = {"vj_impact1_orange"} end
		if VJ_PICK(self.CustomBlood_Decal) == false then self.CustomBlood_Decal = {"VJ_Blood_Orange"} end
		if VJ_PICK(self.CustomBlood_Pool) == false then
			if self.BloodPoolSize == "Small" then
				self.CustomBlood_Pool = {"vj_bleedout_orange_small"}
			elseif self.BloodPoolSize == "Tiny" then
				self.CustomBlood_Pool = {"vj_bleedout_orange_tiny"}
			else
				self.CustomBlood_Pool = {"vj_bleedout_orange"}
			end
		end
	elseif Type == "Blue" then
		if VJ_PICK(self.CustomBlood_Particle) == false then self.CustomBlood_Particle = {"vj_impact1_blue"} end
		if VJ_PICK(self.CustomBlood_Decal) == false then self.CustomBlood_Decal = {"VJ_Blood_Blue"} end
		if VJ_PICK(self.CustomBlood_Pool) == false then
			if self.BloodPoolSize == "Small" then
				self.CustomBlood_Pool = {"vj_bleedout_blue_small"}
			elseif self.BloodPoolSize == "Tiny" then
				self.CustomBlood_Pool = {"vj_bleedout_blue_tiny"}
			else
				self.CustomBlood_Pool = {"vj_bleedout_blue"}
			end
		end
	elseif Type == "Purple" then
		if VJ_PICK(self.CustomBlood_Particle) == false then self.CustomBlood_Particle = {"vj_impact1_purple"} end
		if VJ_PICK(self.CustomBlood_Decal) == false then self.CustomBlood_Decal = {"VJ_Blood_Purple"} end
		if VJ_PICK(self.CustomBlood_Pool) == false then
			if self.BloodPoolSize == "Small" then
				self.CustomBlood_Pool = {"vj_bleedout_purple_small"}
			elseif self.BloodPoolSize == "Tiny" then
				self.CustomBlood_Pool = {"vj_bleedout_purple_tiny"}
			else
				self.CustomBlood_Pool = {"vj_bleedout_purple"}
			end
		end
	elseif Type == "White" then
		if VJ_PICK(self.CustomBlood_Particle) == false then self.CustomBlood_Particle = {"vj_impact1_white"} end
		if VJ_PICK(self.CustomBlood_Decal) == false then self.CustomBlood_Decal = {"VJ_Blood_White"} end
		if VJ_PICK(self.CustomBlood_Pool) == false then
			if self.BloodPoolSize == "Small" then
				self.CustomBlood_Pool = {"vj_bleedout_white_small"}
			elseif self.BloodPoolSize == "Tiny" then
				self.CustomBlood_Pool = {"vj_bleedout_white_tiny"}
			else
				self.CustomBlood_Pool = {"vj_bleedout_white"}
			end
		end
	elseif Type == "Oil" then
		if VJ_PICK(self.CustomBlood_Particle) == false then self.CustomBlood_Particle = {"vj_impact1_black"} end
		if VJ_PICK(self.CustomBlood_Decal) == false then self.CustomBlood_Decal = {"VJ_Blood_Oil"} end
		if VJ_PICK(self.CustomBlood_Pool) == false then
			if self.BloodPoolSize == "Small" then
				self.CustomBlood_Pool = {"vj_bleedout_oil_small"}
			elseif self.BloodPoolSize == "Tiny" then
				self.CustomBlood_Pool = {"vj_bleedout_oil_tiny"}
			else
				self.CustomBlood_Pool = {"vj_bleedout_oil"}
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SpawnBloodParticles(dmginfo, hitgroup)
	local name = VJ_PICK(self.CustomBlood_Particle)
	if name == false then return end
	
	local pos = dmginfo:GetDamagePosition()
	if pos == defPos then pos = self:GetPos() + self:OBBCenter() end
	
	local spawnparticle = ents.Create("info_particle_system")
	spawnparticle:SetKeyValue("effect_name", name)
	spawnparticle:SetPos(pos)
	spawnparticle:Spawn()
	spawnparticle:Activate()
	spawnparticle:Fire("Start")
	spawnparticle:Fire("Kill", "", 0.1)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SpawnBloodDecal(dmginfo, hitgroup)
	if VJ_PICK(self.CustomBlood_Decal) == false then return end
	local force = dmginfo:GetDamageForce()
	local pos = dmginfo:GetDamagePosition()
	if pos == defPos then pos = self:GetPos() + self:OBBCenter() end
	
	-- Badi ayroun
	local tr = util.TraceLine({start = pos, endpos = pos + force:GetNormal() * math.Clamp(force:Length() * 10, 100, self.BloodDecalDistance), filter = self})
	//if !tr.HitWorld then return end
	local trNormalP = tr.HitPos + tr.HitNormal
	local trNormalN = tr.HitPos - tr.HitNormal
	util.Decal(VJ_PICK(self.CustomBlood_Decal), trNormalP, trNormalN, self)
	for _ = 1, 2 do
		if math.random(1,2) == 1 then util.Decal(VJ_PICK(self.CustomBlood_Decal), trNormalP + Vector(math.random(-70,70), math.random(-70,70), 0), trNormalN, self) end
	end
	
	-- Kedni ayroun
	if math.random(1,2) == 1 then
		local d2_endpos = pos + Vector(0, 0, -math.Clamp(force:Length() * 10, 100, self.BloodDecalDistance))
		util.Decal(VJ_PICK(self.CustomBlood_Decal), pos, d2_endpos, self)
		if math.random(1,2) == 1 then util.Decal(VJ_PICK(self.CustomBlood_Decal), pos, d2_endpos + Vector(math.random(-120,120), math.random(-120,120), 0), self) end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local vecZ30 = Vector(0, 0, 30)
local vecZ1 = Vector(0, 0, 1)
--
function ENT:SpawnBloodPool(dmginfo, hitgroup)
	if !IsValid(self.Corpse) then return end
	local corpseEnt = self.Corpse
	local GetBloodPool = VJ_PICK(self.CustomBlood_Pool)
	if GetBloodPool == false then return end
	timer.Simple(2.2, function()
		if IsValid(corpseEnt) then
			local tr = util.TraceLine({
				start = corpseEnt:GetPos() + corpseEnt:OBBCenter(),
				endpos = corpseEnt:GetPos() + corpseEnt:OBBCenter() - vecZ30,
				filter = corpseEnt, //function( ent ) if ( ent:GetClass() == "prop_physics" ) then return true end end
				mask = CONTENTS_SOLID
			})
			-- (X,Y,Z) | (Ver, Var, Goghme)
			if tr.HitWorld && (tr.HitNormal == vecZ1) then // (tr.Fraction <= 0.405)
				ParticleEffect(GetBloodPool, tr.HitPos, defAng, nil)
			end
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:IdleSoundCode(CustomTbl,Type)
	if self.HasSounds == false or self.HasIdleSounds == false or self.Dead == true then return end
	if (self.NextIdleSoundT_RegularChange < CurTime()) && (CurTime() > self.NextIdleSoundT) then
		Type = Type or VJ_CreateSound
		
		local hasenemy = false -- Ayo yete teshnami ouni
		if IsValid(self:GetEnemy()) then
			hasenemy = true
			-- Yete CombatIdle tsayn chouni YEV gerna barz tsayn hanel, ere vor barz tsayn han e
			if VJ_PICK(self.SoundTbl_CombatIdle) == false && self.IdleSounds_NoRegularIdleOnAlerted == false then
				hasenemy = false
			end
		end
		
		local ctbl = VJ_PICK(CustomTbl)
		local setT = true
		if hasenemy == true then
			local sdtbl = VJ_PICK(self.SoundTbl_CombatIdle)
			if (math.random(1,self.CombatIdleSoundChance) == 1 && sdtbl != false) or (ctbl != false) then
				if ctbl != false then sdtbl = ctbl end
				self.CurrentIdleSound = Type(self,sdtbl,self.CombatIdleSoundLevel,self:VJ_DecideSoundPitch(self.CombatIdleSoundPitch.a,self.CombatIdleSoundPitch.b))
			end
		else
			local sdtbl = VJ_PICK(self.SoundTbl_Idle)
			local sdtbl2 = VJ_PICK(self.SoundTbl_IdleDialogue)
			local sdrand = math.random(1,self.IdleSoundChance)
			local function RegularIdle()
				if (sdrand == 1 && sdtbl != false) or (ctbl != false) then
					if ctbl != false then sdtbl = ctbl end
					self.CurrentIdleSound = Type(self, sdtbl, self.IdleSoundLevel, self:VJ_DecideSoundPitch(self.IdleSoundPitch.a, self.IdleSoundPitch.b))
				end
			end
			if sdtbl2 != false && sdrand == 1 && self.HasIdleDialogueSounds == true && math.random(1,2) == 1 then
				local testent, testvj = self:IdleDialogueSoundCodeTest()
				if testent != false then
					if self:CustomOnIdleDialogue(testent, testvj) == false then
						RegularIdle()
					else
						self.CurrentIdleSound = Type(self, sdtbl2, self.IdleDialogueSoundLevel, self:VJ_DecideSoundPitch(self.IdleDialogueSoundPitch.a, self.IdleDialogueSoundPitch.b))
						if testvj == true then -- If we have a VJ SNPC
							local dur = SoundDuration(sdtbl2)
							if dur == 0 then dur = 3 end -- Since some file types don't return a duration =(
							
							setT = false
							self.NextIdleSoundT = CurTime() + (dur + 0.5)
							self.NextWanderTime = CurTime() + (dur + 0.5)
							testent.NextIdleSoundT = CurTime() + (dur + 0.5)
							testent.NextWanderTime = CurTime() + (dur + 0.5)
							
							if self.IdleDialogueCanTurn == true then
								self:StopMoving()
								self:SetTarget(testent)
								self:VJ_TASK_FACE_X("TASK_FACE_TARGET")
							end
							if testent.IdleDialogueCanTurn == true then
								testent:StopMoving()
								testent:SetTarget(self)
								testent:VJ_TASK_FACE_X("TASK_FACE_TARGET")
							end
							
							-- For the other SNPC to answer back:
							timer.Simple(dur + 0.3, function()
								if IsValid(self) && IsValid(testent) then
									testent:CustomOnIdleDialogueAnswer(self)
									local response = testent:IdleDialogueAnswerSoundCode()
									if response > 0 then -- If the ally responded, then make sure both SNPCs stand still & don't play another idle sound until the whole conversation is finished!
										self.NextIdleSoundT = CurTime() + (response + 0.5)
										self.NextWanderTime = CurTime() + (response + 1)
										testent.NextIdleSoundT = CurTime() + (response + 0.5)
										testent.NextWanderTime = CurTime() + (response + 1)
									end
								end
							end)
						end
					end
				else
					RegularIdle()
				end
			else
				RegularIdle()
			end
		end
		if setT == true then
			self.NextIdleSoundT = CurTime() + math.Rand(self.NextSoundTime_Idle1,self.NextSoundTime_Idle2)
		end
	end
end
--------------------------------------------------------------------------------------------------------------------------------------------
function ENT:IdleDialogueSoundCodeTest()
	-- Don't break the loop unless we hit a VJ SNPC
	-- If no VJ SNPC is hit, then just simply return the last checked friendly player or NPC
	local ret = false
	for _, v in ipairs(ents.FindInSphere(self:GetPos(), self.IdleDialogueDistance)) do
		if v:IsPlayer() && self:DoRelationshipCheck(v) == false then
			ret = v
		elseif v != self && ((self:GetClass() == v:GetClass()) or (v:IsNPC() && self:DoRelationshipCheck(v) == false)) && self:Visible(v) then
			ret = v
			if v.IsVJBaseSNPC == true && v.Dead == false && VJ_PICK(v.SoundTbl_IdleDialogueAnswer) != false then
				return v, true -- Yete VJ NPC e, ere vor function-e gena
			end
		end
	end
	return ret, false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:IdleDialogueAnswerSoundCode(CustomTbl,Type)
	if self.Dead == true or self.HasSounds == false or self.HasIdleDialogueAnswerSounds == false then return 0 end
	Type = Type or VJ_CreateSound
	local ctbl = VJ_PICK(CustomTbl)
	local sdtbl = VJ_PICK(self.SoundTbl_IdleDialogueAnswer)
	if (math.random(1,self.IdleDialogueAnswerSoundChance) == 1 && sdtbl != false) or (ctbl != false) then
		if ctbl != false then sdtbl = ctbl end
		self:StopAllCommonSpeechSounds()
		self.NextIdleSoundT_RegularChange = CurTime() + math.random(2,3)
		self.CurrentIdleDialogueAnswerSound = Type(self,sdtbl,self.IdleDialogueAnswerSoundLevel,self:VJ_DecideSoundPitch(self.IdleDialogueAnswerSoundPitch.a,self.IdleDialogueAnswerSoundPitch.b))
		return SoundDuration(sdtbl) -- Return the duration of the sound, which will be used to make the other SNPC stand still
	else
		return 0
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RemoveAttackTimers()
	for _,v in ipairs(self.TimersToRemove) do
		timer.Remove(v..self:EntIndex())
	end
	for _,v in ipairs(self.AttackTimersCustom) do
		timer.Remove(v..self:EntIndex())
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:EntitiesToNoCollideCode(ent)
	if self.HasEntitiesToNoCollide != true or !istable(self.EntitiesToNoCollide) or !IsValid(ent) then return end
	for x=1, #self.EntitiesToNoCollide do
		if self.EntitiesToNoCollide[x] == ent:GetClass() then
			constraint.NoCollide(self,ent,0,0)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:VJ_SetSchedule(schedID)
	if self.VJ_PlayingSequence == true then return end
	self.VJ_PlayingInterruptSequence = false
	//if self.MovementType == VJ_MOVETYPE_AERIAL or self.MovementType == VJ_MOVETYPE_AQUATIC then return end
	//print(self:GetName().." - "..schedID)
	self:SetSchedule(schedID)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RunGibOnDeathCode(dmginfo, hitgroup, extraOptions)
	if self.AllowedToGib == false or self.HasGibOnDeath == false or self.HasBeenGibbedOnDeath == true then return end
	extraOptions = extraOptions or {}
	local dmgTbl = extraOptions.CustomDmgTbl or self.GibOnDeathDamagesTable
	local dmgType = dmginfo:GetDamageType()
	local dmgAny = false
	local useDefault = false
	if VJ_HasValue(dmgTbl,"UseDefault") then useDefault = true end
	if useDefault == false && (#dmgTbl <= 0 or VJ_HasValue(dmgTbl,"All")) then dmgAny = true end
	if (dmgAny == true) or (useDefault == true && VJ_HasValue(self.DefaultGibDamageTypes,dmgType)) or (useDefault == false && VJ_HasValue(dmgTbl,dmgType)) then
		local setupgib, setupgib_extra = self:SetUpGibesOnDeath(dmginfo, hitgroup)
		if setupgib_extra == nil then setupgib_extra = {} end
		if setupgib == true then
			if setupgib_extra.AllowCorpse != true then self.HasDeathRagdoll = false end
			if setupgib_extra.DeathAnim != true then self.HasDeathAnimation = false end
			self.HasBeenGibbedOnDeath = true
			self:PlayGibOnDeathSounds(dmginfo, hitgroup)
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
		VJ_EmitSound(self, gib_sd1, 90, math.random(80, 100))
		VJ_EmitSound(self, gib_sd2, 90, math.random(80, 100))
		VJ_EmitSound(self, gib_sd3, 90, math.random(80, 100))
		VJ_EmitSound(self, gib_sd4, 90, math.random(80, 100))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:StartSoundTrack()
	if self.HasSounds == false or self.HasSoundTrack == false then return end
	if math.random(1, self.SoundTrackChance) == 1 then
		self.VJ_IsPlayingSoundTrack = true
		net.Start("vj_music_run")
		net.WriteEntity(self)
		net.WriteTable(self.SoundTbl_SoundTrack)
		net.WriteFloat(self.SoundTrackVolume)
		net.WriteFloat(self.SoundTrackPlaybackRate)
		//net.WriteFloat(self.SoundTrackFadeOutTime)
		net.Broadcast()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RunItemDropsOnDeathCode(dmginfo, hitgroup)
	if self.HasItemDropsOnDeath == false then return end
	if math.random(1,self.ItemDropsOnDeathChance) == 1 then
		self:CustomRareDropsOnDeathCode(dmginfo, hitgroup)
		local entlist = VJ_PICK(self.ItemDropsOnDeath_EntityList)
		if entlist != false then
			local randdrop = ents.Create(entlist)
			randdrop:SetPos(self:GetPos() + self:OBBCenter())
			randdrop:SetAngles(self:GetAngles())
			randdrop:Spawn()
			randdrop:Activate()
			local phys = randdrop:GetPhysicsObject()
			if IsValid(phys) then
				phys:SetMass(60)
				phys:ApplyForceCenter(dmginfo:GetDamageForce())
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRemove()
	self:CustomOnRemove()
	self.Dead = true
	
	if self.Medic_IsHealingAlly == true then self:DoMedicCode_Reset() end
	self:StopAllCommonSounds()
	self:RemoveAttackTimers()
	self:StopParticles()
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ ///// OBSOLETE FUNCTIONS | Recommended not to use! \\\\\ ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
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
		if (v:IsNPC() && v:GetClass() != self:GetClass() && v:GetClass() != "npc_grenade_frag" && v:GetClass() != "bullseye_strider_focus" && v:GetClass() != "npc_bullseye" && v:GetClass() != "npc_enemyfinder" && v:GetClass() != "hornet" && (!v.IsVJBaseSNPC_Animal) && (v.Behavior != VJ_BEHAVIOR_PASSIVE_NATURE) && v:Health() > 0) or (v:IsPlayer() && GetConVarNumber("ai_ignoreplayers") == 0) then
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
	for k, v in pairs (ents.GetAll()) do
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
local EnemyTargets = VJ_FindInCone(self:GetPos(),self:GetForward(),self.SightDistance,self.SightAngle)
//local LocalTargetTable = {}
if (!EnemyTargets) then return end
//table.Add(EnemyTargets)
for k,v in pairs(EnemyTargets) do
	//if (v:GetClass() != self:GetClass() && v:GetClass() != "npc_grenade_frag") && v:IsNPC() or (v:IsPlayer() && self.PlayerFriendly == false && GetConVarNumber("ai_ignoreplayers") == 0) && self:Visible(v) then
	//if self.CombineFriendly == true then if VJ_HasValue(NPCTbl_Combine,v:GetClass()) then return end end
	//if self.ZombieFriendly == true then if VJ_HasValue(NPCTbl_Zombies,v:GetClass()) then return end end
	//if self.AntlionFriendly == true then if VJ_HasValue(NPCTbl_Antlions,v:GetClass()) then return end end
	//if self.PlayerFriendly == true then if VJ_HasValue(NPCTbl_Resistance,v:GetClass()) then return end end
	//if GetConVarNumber("vj_npc_vjfriendly") == 1 then
	//local frivj = ents.FindByClass("npc_vj_*") table.Add(frivj) for _, x in pairs(frivj) do return end end
	//local vjanimalfriendly = ents.FindByClass("npc_vjanimal_*") table.Add(vjanimalfriendly) for _, x in pairs(vjanimalfriendly) do return end
	//self:AddEntityRelationship( v, D_HT, 99 )
	//if !v:IsPlayer() then if self:Visible(v) then v:AddEntityRelationship( self, D_HT, 99 ) end end
	if self:DoRelationshipCheck(v) == true && self:Visible(v) then
	self.ResetedEnemy = true
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
for k,v in pairs(EnemyTargets) do
	if self:DoRelationshipCheck(v) == true && self:Visible(v) then
	self.ResetedEnemy = true
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
	if IsValid(self:GetEnemy()) && self.Dead == false then
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
if GetConVarNumber("vj_npc_sd_nosounds") == 0 then
if GetConVarNumber("vj_npc_sd_soundtrack") == 0 then
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
	for _,x in pairs( friendslist ) do
	local hl_friendlys = ents.FindByClass( x )
	for _,x in pairs( hl_friendlys ) do
	if entity == x then
	return D_LI
	end
  end
 end

	local groupone = ents.FindByClass("npc_vj_example_*") -- Group
	table.Add(groupone)
	for _, x in pairs(groupone) do
	if entity == x then
	return D_LI
	end
 end

	local groupone = ents.FindByClass("npc_vj_example") -- Single
	for _, x in pairs(groupone) do
	if entity == x then
	return D_LI
	end
 end
end*/