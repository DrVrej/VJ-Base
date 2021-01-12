/*--------------------------------------------------
	=============== Entity Stuff ===============
	*** Copyright (c) 2012-2021 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
include('autorun/vj_controls.lua')

-- Localized static values
local CurTime = CurTime
local IsValid = IsValid
local GetConVarNumber = GetConVarNumber
local istable = istable
local isstring = isstring
local isnumber = isnumber
local tonumber = tonumber
local string_find = string.find
local string_Replace = string.Replace
local string_StartWith = string.StartWith
local table_remove = table.remove

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Spawn Menu Creation ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- ====== Category Information (Many are for popular categories used in both official and unofficial addons ====== --
	-- Steam\appcache\librarycache
VJ.AddCategoryInfo("Alien Swarm", {Icon = "vj_base/icons/alienswarm.png"})
VJ.AddCategoryInfo("Black Mesa", {Icon = "vj_base/icons/blackmesa.png"})
VJ.AddCategoryInfo("Cry Of Fear", {Icon = "vj_base/icons/cryoffear.png"})
VJ.AddCategoryInfo("Dark Messiah", {Icon = "vj_base/icons/darkmessiah.png"})
VJ.AddCategoryInfo("E.Y.E Divine Cybermancy", {Icon = "vj_base/icons/eyedc.png"})
VJ.AddCategoryInfo("Fallout", {Icon = "vj_base/icons/fallout.png"})
VJ.AddCategoryInfo("Killing Floor 1", {Icon = "vj_base/icons/kf1.png"})
VJ.AddCategoryInfo("Left 4 Dead", {Icon = "vj_base/icons/l4d.png"})
VJ.AddCategoryInfo("Mass Effect 3", {Icon = "vj_base/icons/masseffect3.png"})
VJ.AddCategoryInfo("Military", {Icon = "vj_base/icons/mil1.png"})
VJ.AddCategoryInfo("No More Room In Hell", {Icon = "vj_base/icons/nmrih.png"})
VJ.AddCategoryInfo("Star Wars", {Icon = "vj_base/icons/starwars.png"})
VJ.AddCategoryInfo("Zombies", {Icon = "vj_base/icons/zombies.png"})

	-- ====== NPCs ====== --
local vCat = "VJ Base"
VJ.AddNPC("VJ Test NPC","sent_vj_test",vCat,true)
VJ.AddNPC("Mortar Synth","npc_vj_mortarsynth",vCat)

	-- ====== Entities ====== --
VJ.AddEntity("Admin Health Kit","sent_vj_adminhealthkit","DrVrej",true,0,true,vCat)
VJ.AddEntity("Player Spawnpoint","sent_vj_ply_spawnpoint","DrVrej",true,0,true,vCat)
VJ.AddEntity("Fireplace","sent_vj_fireplace","DrVrej",false,0,true,vCat)
VJ.AddEntity("Wooden Board","sent_vj_board","DrVrej",false,0,true,vCat)
VJ.AddEntity("Grenade","obj_vj_grenade","DrVrej",false,0,true,vCat)
VJ.AddEntity("Flare Round","obj_vj_flareround","DrVrej",false,0,true,vCat)
VJ.AddEntity("Flag","prop_vj_flag","DrVrej",false,0,true,vCat)
//VJ.AddEntity("HL2 Grenade","npc_grenade_frag","DrVrej",false,50,true,vCat)
//VJ.AddEntity("Supply Box","item_dynamic_resupply","DrVrej",false,0,true,vCat)
//VJ.AddEntity("Supply Crate","item_ammo_crate","DrVrej",false,0,true,vCat)

	-- ====== NPC Weapons ====== --
//VJ.AddNPCWeapon("VJ_Package","weapon_citizenpackage")
//VJ.AddNPCWeapon("VJ_Suitcase","weapon_citizensuitcase")
VJ.AddNPCWeapon("VJ_AK-47","weapon_vj_ak47")
VJ.AddNPCWeapon("VJ_M4A1","weapon_vj_m16a1")
VJ.AddNPCWeapon("VJ_Glock17","weapon_vj_glock17")
VJ.AddNPCWeapon("VJ_MP40","weapon_vj_mp40")
VJ.AddNPCWeapon("VJ_Blaster","weapon_vj_blaster")
VJ.AddNPCWeapon("VJ_AR2","weapon_vj_ar2")
VJ.AddNPCWeapon("VJ_SMG1","weapon_vj_smg1")
VJ.AddNPCWeapon("VJ_9mmPistol","weapon_vj_9mmpistol")
VJ.AddNPCWeapon("VJ_SPAS-12","weapon_vj_spas12")
VJ.AddNPCWeapon("VJ_357","weapon_vj_357")
VJ.AddNPCWeapon("VJ_FlareGun","weapon_vj_flaregun")
VJ.AddNPCWeapon("VJ_RPG","weapon_vj_rpg")
VJ.AddNPCWeapon("VJ_K-3","weapon_vj_k3")
VJ.AddNPCWeapon("VJ_Crossbow","weapon_vj_crossbow")
VJ.AddNPCWeapon("VJ_SSG-08","weapon_vj_ssg08")
VJ.AddNPCWeapon("VJ_Crowbar","weapon_vj_crowbar")
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Global Functions & Variables ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
VJ_MOVETYPE_GROUND = 1
VJ_MOVETYPE_AERIAL = 2
VJ_MOVETYPE_AQUATIC = 3
VJ_MOVETYPE_STATIONARY = 4
VJ_MOVETYPE_PHYSICS = 5

VJ_BEHAVIOR_AGGRESSIVE = 1
VJ_BEHAVIOR_NEUTRAL = 2
VJ_BEHAVIOR_PASSIVE = 3
VJ_BEHAVIOR_PASSIVE_NATURE = 4

VJ_STATE_NONE = 0 -- No state is set
VJ_STATE_FREEZE = 1 -- AI Completely freezes
VJ_STATE_ONLY_ANIMATION = 100 -- It will only play animation tasks. Movements, turning and other tasks will not play!
VJ_STATE_ONLY_ANIMATION_CONSTANT = 101 -- Same as VJ_STATE_ONLY_ANIMATION but with the addition that idle animation will not play!
VJ_STATE_ONLY_ANIMATION_NOATTACK = 102 -- Same as VJ_STATE_ONLY_ANIMATION but with the addition that attacks will also not be performed by the NPC!

VJ_WEP_STATE_NONE = 0 -- No state is set
VJ_WEP_STATE_ANTI_ARMOR = 20 -- It's currently using its anti-armor weapon
VJ_WEP_STATE_MELEE = 21 -- It's currently using its melee weapon
---------------------------------------------------------------------------------------------------------------------------------------------
if (SERVER) then
	util.AddNetworkString("vj_music_run")
	
	require("ai_vj_schedule")
	local getSched = ai_vj_schedule.New
	function ai_vj_schedule.New(name)
		local actualSched = getSched(name)
		actualSched.Name = name
		return actualSched
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function VJ_PICK(tbl)
	if not tbl then return false end -- Yete table pame choone meche, veratartsour false!
	if istable(tbl) then
		if #tbl < 1 then return false end -- Yete table barabe (meg en aveli kich), getsoor!
		tbl = tbl[math.random(1,#tbl)]
		return tbl
	else
		return tbl -- Yete table che, veratartsour abranke
	end
	return false
end
-- Backwards compatibility, don't use!
	function VJ_PICKRANDOMTABLE(tbl)
		if not tbl then return false end -- Yete table pame choone meche, veratartsour false!
		if istable(tbl) then
			if #tbl < 1 then return false end -- Yete table barabe (meg en aveli kich), getsoor!
			tbl = tbl[math.random(1,#tbl)]
			return tbl
		else
			return tbl -- Yete table che, veratartsour abranke
		end
		return false
	end
---------------------------------------------------------------------------------------------------------------------------------------------
function VJ_STOPSOUND(sdName)
	if sdName then sdName:Stop() end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function VJ_Set(a, b) -- A set of 2 numbers: a, b
	return {a = a, b = b}
end
---------------------------------------------------------------------------------------------------------------------------------------------
function VJ_HasValue(tbl, val)
	if !istable(tbl) then return false end
	for x = 1, #tbl do
		if tbl[x] == val then
			return true
		end
	end
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function VJ_RoundToMultiple(num, multiple) -- Credits to Bizzclaw for pointing me to the right direction!
	if math.Round(num / multiple) == num / multiple then
		return num
	else
		return math.Round(num / multiple) * multiple
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function VJ_Color2Byte(color)
	return bit.lshift(math.floor(color.r*7/255), 5) + bit.lshift(math.floor(color.g*7/255), 2) + math.floor(color.b*3/255)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function VJ_Color8Bit2Color(bits)
	return Color(bit.rshift(bits,5)*255/7, bit.band(bit.rshift(bits,2), 0x07)*255/7, bit.band(bits,0x03)*255/3)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function VJ_FindInCone(pos, dir, dist, deg, extraOptions)
	extraOptions = extraOptions or {}
		local vTbl_AllEntities = extraOptions.AllEntities or false -- Should it detect all types of entities? | False = NPCs and Players only!
	local EntitiesFound = ents.FindInSphere(pos, dist)
	local Foundents = {}
	local CosineDegrees = math.cos(math.rad(deg))
	for _,v in pairs(EntitiesFound) do
	if ((vTbl_AllEntities == true) or (vTbl_AllEntities == false && (v:IsNPC() or v:IsPlayer()))) && (dir:Dot((v:GetPos() -Position):GetNormalized()) > CosineDegrees) then
			Foundents[#Foundents+1] = v
		end
	end
	return Foundents
end
---------------------------------------------------------------------------------------------------------------------------------------------
function VJ_CreateSound(ent, sd, sdLevel, sdPitch, customFunc)
	if not sd then return end
	if istable(sd) then
		if #sd < 1 then return end -- If the table is empty then end it
		sd = sd[math.random(1, #sd)]
	end
	local sdID = CreateSound(ent, sd)
	sdID:SetSoundLevel(sdLevel or 75)
	if (customFunc) then customFunc(sdID) end
	sdID:PlayEx(1, sdPitch or 100)
	ent.LastPlayedVJSound = sdID
	if ent.IsVJBaseSNPC == true then ent:OnPlayCreateSound(sdID, sd) end
	return sdID
end
---------------------------------------------------------------------------------------------------------------------------------------------
function VJ_EmitSound(ent, sd, sdLevel, sdPitch, sdVolume, sdChannel)
	local sdID = VJ_PICK(sd)
	if sdID == false then return end
	ent:EmitSound(sdID, sdLevel, sdPitch, sdVolume, sdChannel)
	ent.LastPlayedVJSound = sdID
	if ent.IsVJBaseSNPC == true then ent:OnPlayEmitSound(sdID) end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function VJ_AnimationExists(ent, anim)
	if anim == nil or isbool(anim) then return false end
	
	-- Get rid of the gesture prefix
	if string_find(anim, "vjges_") then
		anim = string_Replace(anim, "vjges_", "")
		if ent:LookupSequence(anim) == -1 then
			anim = tonumber(anim)
		end
	end
	
	if isnumber(anim) then -- Activity
		if (ent:SelectWeightedSequence(anim) == -1 or ent:SelectWeightedSequence(anim) == 0) && (ent:GetSequenceName(ent:SelectWeightedSequence(anim)) == "Not Found!" or ent:GetSequenceName(ent:SelectWeightedSequence(anim)) == "No model!") then
		return false end
	elseif isstring(anim) then -- Sequence
		if string_find(anim, "vjseq_") then anim = string_Replace(anim, "vjseq_", "") end
		if ent:LookupSequence(anim) == -1 then
		return false end
	end
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function VJ_GetSequenceDuration(ent, anim)
	if VJ_AnimationExists(ent, anim) == false then return 0 end -- Invalid animation, so 0
	
	-- Get rid of the gesture prefix
	if string_find(anim, "vjges_") then
		anim = string_Replace(anim, "vjges_", "")
		if ent:LookupSequence(anim) == -1 then
			anim = tonumber(anim)
		end
	end
	
	if isnumber(anim) then -- Activity
		return ent:SequenceDuration(ent:SelectWeightedSequence(anim))
	elseif isstring(anim) then -- Sequence
		if string_find(anim, "vjseq_") then
			anim = string_Replace(anim, "vjseq_", "")
		end
		return ent:SequenceDuration(ent:LookupSequence(anim))
	end
	return 0
end
---------------------------------------------------------------------------------------------------------------------------------------------
function VJ_GetSequenceName(ent, anim)
	if VJ_AnimationExists(ent, anim) == false then return 0 end -- Invalid animation, so 0
	if string_find(anim, "vjges_") then anim = string_Replace(anim,"vjges_","") if ent:LookupSequence(anim) == -1 then anim = tonumber(anim) end end
	if isnumber(anim) then return ent:GetSequenceName(ent:SelectWeightedSequence(anim)) end
	if isstring(anim) then if string_find(anim, "vjseq_") then anim = string_Replace(anim,"vjseq_","") end return ent:GetSequenceName(ent:LookupSequence(anim)) end
	return nil
end
---------------------------------------------------------------------------------------------------------------------------------------------
function VJ_SequenceToActivity(ent, anim)
	if isstring(anim) then -- Sequence
		local checkanim = ent:GetSequenceActivity(ent:LookupSequence(anim))
		if checkanim == nil or checkanim == -1 then
			return false
		else
			return checkanim
		end
	elseif isnumber(anim) then -- If it's a number, then it's already an activity!
		return anim
	else
		return false
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function VJ_IsCurrentAnimation(ent, anim)
	anim = anim or {}
	if istable(anim) then
		if #anim < 1 then return false end -- If the table is empty then end it
	else
		anim = {anim}
	end

	for _,v in ipairs(anim) do
		if isnumber(v) && v != -1 then v = ent:GetSequenceName(ent:SelectWeightedSequence(v)) end -- Translate activity to sequence
		if v == ent:GetSequenceName(ent:GetSequence()) then
			return true
		end
	end
	//if anim == ent:GetSequenceName(ent:GetSequence()) then return true end
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function VJ_IsProp(ent)
	if ent:GetClass() == "prop_physics" or ent:GetClass() == "prop_physics_multiplayer" or ent:GetClass() == "prop_physics_respawnable" then return true end
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function VJ_IsAlive(ent)
	if ent.Dead == true then return false end
	return ent:Health() > 0
end
---------------------------------------------------------------------------------------------------------------------------------------------
function VJ_DestroyCombineTurret(selfEnt, ent)
	if ent:GetClass() == "npc_turret_floor" && !ent.VJ_TurretDestroyed then
		ent:Fire("selfdestruct", "", 0)
		local phys = ent:GetPhysicsObject()
		if IsValid(phys) then
			phys:EnableMotion(true)
			phys:ApplyForceCenter(selfEnt:GetForward()*10000)
		end
		ent.VJ_TurretDestroyed = true
		return true
	end
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function VJ_CreateTestObject(pos, ang, color, time, mdl)
	ang = ang or Angle(0,0,0)
	color = color or Color(255,0,0)
	time = time or 3
	mdl = mdl or "models/hunter/blocks/cube025x025x025.mdl"
	
	local obj = ents.Create("prop_dynamic")
	obj:SetModel(mdl)
	obj:SetPos(pos)
	obj:SetAngles(ang)
	obj:SetColor(color)
	obj:Spawn()
	obj:Activate()
	timer.Simple(time, function() if IsValid(obj) then obj:Remove() end end)
	return obj
end
---------------------------------------------------------------------------------------------------------------------------------------------
/* Do multiple test and compare the 2 results using this: https://calculla.com/columnar_addition_calculator
	VJ_StressTest(1000, function()
	end)
*/
function VJ_StressTest(count, func)
	count = count or 1
	local startTime = SysTime()
    for _ = 1, count do
		func()
    end
	local totalTime = SysTime() - startTime
	print("Total: " .. string.format("%f", totalTime) .. " sec | Average: " .. string.format("%f", totalTime / count) .. " sec")
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ NPC / Player Functions ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local NPC_MetaTable = FindMetaTable("NPC")
//local Player_MetaTable = FindMetaTable("Player")
local Entity_MetaTable = FindMetaTable("Entity")

//NPC_MetaTable.VJ_NoTarget = false
//Player_MetaTable.VJ_NoTarget = false

//NPC_MetaTable.VJ_NPC_Class = {}
---------------------------------------------------------------------------------------------------------------------------------------------
function NPC_MetaTable:VJ_Controller_InitialMessage(ply)
	if !IsValid(ply) then return end
	if self.IsVJBaseSNPC == true then
		ply:ChatPrint("For controls, check \"Controller Settings\" under \"DrVrej\" tab")
		self:Controller_IntMsg(ply)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function NPC_MetaTable:VJ_HasNoTarget(ent)
	if ent:GetClass() == "obj_vj_bullseye" && (ent.EnemyToIndividual == true) && (ent.EnemyToIndividualEnt == self) then
		return false, 1
	end
	if (ent.VJ_NoTarget == true) or (ent:IsFlagSet(FL_NOTARGET) == true) then
		return true, 0
	else
		return false, 0
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function NPC_MetaTable:VJ_DecideSoundPitch(pitch1, pitch2)
	//if pitch1 == nil then return end
	local getpitch1 = self.GeneralSoundPitch1
	local getpitch2 = self.GeneralSoundPitch2
	local picknum = self.UseTheSameGeneralSoundPitch_PickedNumber
	if self.UseTheSameGeneralSoundPitch == true && picknum != 0 then
		getpitch1 = picknum
		getpitch2 = picknum
	end
	if pitch1 != false && isnumber(pitch1) then getpitch1 = pitch1 end
	if pitch2 != false && isnumber(pitch2) then getpitch2 = pitch2 end
	return math.random(getpitch1, getpitch2)
end
---------------------------------------------------------------------------------------------------------------------------------------------
-- override = Used internally by the base, overrides the result and returns Val instead (Useful for variables that allow "false" to let the base decide the time)
function NPC_MetaTable:DecideAnimationLength(anim, override, decrease)
	if isbool(anim) then return 0 end
	
	if override == false then -- Base decides
		return (VJ_GetSequenceDuration(self, anim) - (decrease or 0)) / self:GetPlaybackRate()
	elseif isnumber(override) then -- User decides
		return override / self:GetPlaybackRate()
	else
		return 0
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
-- timer2 = Use for randomization, leave to "false" to just use timer1
-- untilDamage = Used for timer-based attacks, decreases timer1
-- animDur = Used when timer1 is set to "false", it over takes timer1
function NPC_MetaTable:DecideAttackTimer(timer1, timer2, untilDamage, animDur)
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
function NPC_MetaTable:VJ_PlaySequence(seq, playbackRate, wait, waitTime, interruptible)
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
function NPC_MetaTable:VJ_GetAllPoseParameters(prt)
	local result = {}
	prt = prt or false
	for i = 0, self:GetNumPoseParameters() - 1 do
		local min, max = self:GetPoseParameterRange(i)
		if prt == true then
			print(self:GetPoseParameterName(i)..' '..min.." / "..max)
		end
		table.insert(result,self:GetPoseParameterName(i))
	end
	return result
end
---------------------------------------------------------------------------------------------------------------------------------------------
function NPC_MetaTable:VJ_ReturnAngle(ang)
	if self.TurningUseAllAxis == true then
		return Angle(ang.x, ang.y, ang.z)
	end
	return Angle(0, ang.y, 0)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function NPC_MetaTable:FaceCertainPosition(pos, time)
	pos = pos or Vector(0,0,0)
	time = time or 0
	local setangs = Angle(0,(pos - self:GetPos()):Angle().y,0)
	self:SetAngles(Angle(setangs.p, self:GetAngles().y, setangs.r))
	self:SetIdealYawAndUpdate(setangs.y, speed)
	self.IsDoingFacePosition = setangs
	timer.Create("timer_face_position"..self:EntIndex(), time, 1, function() self.IsDoingFacePosition = false end)
	return setangs
end
---------------------------------------------------------------------------------------------------------------------------------------------
-- onlyEnemy = Will only face the entity if it's an enemy
-- faceEnemyTime = How long should it face the enemy?
function NPC_MetaTable:FaceCertainEntity(ent, onlyEnemy, faceEnemyTime)
	if !IsValid(ent) or GetConVarNumber("ai_disabled") == 1 or (self.MovementType == VJ_MOVETYPE_STATIONARY && self.CanTurnWhileStationary == false) then return false end
	if onlyEnemy == true && IsValid(self:GetEnemy()) then
		self.IsDoingFaceEnemy = true
		timer.Create("timer_face_enemy"..self:EntIndex(), faceEnemyTime or 0, 1, function() self.IsDoingFaceEnemy = false end)
		local setangs = self:VJ_ReturnAngle((ent:GetPos() - self:GetPos()):Angle())
		self:SetIdealYawAndUpdate(setangs.y)
		self:SetAngles(Angle(setangs.p, self:GetAngles().y, setangs.r))
		return setangs //SetLocalAngles
	else
		local setangs = self:VJ_ReturnAngle((ent:GetPos() - self:GetPos()):Angle())
		self:SetIdealYawAndUpdate(setangs.y)
		self:SetAngles(Angle(setangs.p, self:GetAngles().y, setangs.r))
		//self:SetIdealYawAndUpdate(setangs.y)
		return setangs
	end
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function NPC_MetaTable:VJ_GetNearestPointToVector(pos, sameZ)
	sameZ = sameZ or false -- Should the Z of the pos be the same as the NPC's?
	local NearestPositions = {MyPosition=Vector(0,0,0), PointPosition=Vector(0,0,0)}
	local Pos_Point, Pos_Self = pos, self:NearestPoint(pos +self:OBBCenter())
	Pos_Point.z, Pos_Self.z = pos.z, self:GetPos().z
	if sameZ == true then Pos_Point.z = self:GetPos().z end
	NearestPositions.MyPosition = Pos_Self
	NearestPositions.PointPosition = Pos_Point
	return NearestPositions
end
---------------------------------------------------------------------------------------------------------------------------------------------
function NPC_MetaTable:VJ_GetNearestPointToEntity(ent, sameZ)
	if !IsValid(ent) then return end
	sameZ = sameZ or false -- Should the Z of the pos be the same as the NPC's?
	local NearestPositions = {MyPosition=Vector(0,0,0), EnemyPosition=Vector(0,0,0)}
	local Pos_Enemy, Pos_Self = ent:NearestPoint(self:SetNearestPointToEntityPosition() + ent:OBBCenter()), self:NearestPoint(ent:GetPos() + self:OBBCenter())
	Pos_Enemy.z, Pos_Self.z = ent:GetPos().z, self:SetNearestPointToEntityPosition().z
	if sameZ == true then
		Pos_Enemy = Vector(Pos_Enemy.x,Pos_Enemy.y,self:SetNearestPointToEntityPosition().z)
		Pos_Self = Vector(Pos_Self.x,Pos_Self.y,self:SetNearestPointToEntityPosition().z)
	end
	NearestPositions.MyPosition = Pos_Self
	NearestPositions.EnemyPosition = Pos_Enemy
	//local Pos_Distance = Pos_Enemy:Distance(Pos_Self)
	return NearestPositions
end
---------------------------------------------------------------------------------------------------------------------------------------------
function NPC_MetaTable:VJ_GetNearestPointToEntityDistance(ent, onlySelfGetPos)
	if !IsValid(ent) then return end
	onlySelfGetPos = onlySelfGetPos or false -- Should it only do its self position for the local entity?
	local Pos_Enemy = ent:NearestPoint(self:SetNearestPointToEntityPosition() + ent:OBBCenter())
	local Pos_Self = self:NearestPoint(ent:GetPos() + self:OBBCenter())
	if onlySelfGetPos == true then Pos_Self = self:SetNearestPointToEntityPosition() end
	Pos_Enemy.z, Pos_Self.z = ent:GetPos().z, self:SetNearestPointToEntityPosition().z
	//local Pos_Distance = Pos_Enemy:Distance(Pos_Self)
	return Pos_Enemy:Distance(Pos_Self) // math.Distance(Pos_Enemy.x,Pos_Enemy.y,Pos_Self.x,Pos_Self.y)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function NPC_MetaTable:VJ_ForwardIsHidingZone(startPos, endPos, acceptWorld, extraOptions)
	if !IsValid(self:GetEnemy()) then return false, {} end
	startPos = startPos or self:NearestPoint(self:GetPos() + self:OBBCenter())
	endPos = endPos or self:GetEnemy():EyePos()
	acceptWorld = acceptWorld or false
	extraOptions = extraOptions or {}
		local vTbl_SetLastHiddenTime = extraOptions.SetLastHiddenTime or false -- Should it set the last hidden time? (Mostly used for humans)
		local vTbl_SpawnTestCube = extraOptions.SpawnTestCube or false -- Should it spawn a cube where the trace hit?
	local hitent = false
	tr = util.TraceLine({
		start = startPos,
		endpos = endPos,
		filter = self
	})
	//print("--------------------------------------------")
	//print(tr.Entity)
	//PrintTable(tr)
	if vTbl_SpawnTestCube == true then
		-- Run in Console: lua_run for k,v in ipairs(ents.GetAll()) do if v:GetClass() == "prop_dynamic" then v:Remove() end end
		local cube = ents.Create("prop_dynamic")
		cube:SetModel("models/hunter/blocks/cube025x025x025.mdl")
		cube:SetPos(tr.HitPos)
		cube:SetAngles(self:GetAngles())
		cube:SetColor(Color(255,0,0))
		cube:Spawn()
		cube:Activate()
		timer.Simple(3,function() if IsValid(cube) then cube:Remove() end end)
	end

	for _,v in ipairs(ents.FindInSphere(tr.HitPos,5)) do
		//if vTbl_SpawnTestCube == true then print(v) end
		if v == self:GetEnemy() or self:Disposition(v) == 1 or self:Disposition(v) == 2 then
			hitent = true
			//if vTbl_SpawnTestCube == true then print("it hit") end
		end
	end

	if hitent == true then if vTbl_SetLastHiddenTime == true then self.LastHiddenZoneT = 0 end return false, tr end
	if endPos:Distance(tr.HitPos) <= 10 then if vTbl_SetLastHiddenTime == true then self.LastHiddenZoneT = 0 end return false, tr end
	if tr.HitWorld == true && self:GetPos():Distance(tr.HitPos) < 200 then if vTbl_SetLastHiddenTime == true then self.LastHiddenZoneT = CurTime() + 20 end return true, tr end
	if /*tr.Entity == NULL or tr.Entity:IsNPC() or tr.Entity:IsPlayer() or*/ tr.Entity == self:GetEnemy() or (acceptWorld == false && tr.HitWorld == true) then
	if vTbl_SetLastHiddenTime == true then self.LastHiddenZoneT = 0 end return false, tr else if vTbl_SetLastHiddenTime == true then self.LastHiddenZoneT = CurTime() + 20 end return true, tr end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function NPC_MetaTable:VJ_CheckAllFourSides(checkDist)
	checkDist = checkDist or 200
	local result = {Forward=false, Backward=false, Right=false, Left=false}
	local i = 0
	for _, v in ipairs({self:GetForward(), -self:GetForward(), self:GetRight(), -self:GetRight()}) do
		i = i + 1
		tr = util.TraceLine({
			start = self:GetPos() + self:OBBCenter(),
			endpos = self:GetPos() + self:OBBCenter() + v*checkDist,
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
function NPC_MetaTable:VJ_DoSetEnemy(ent, stopMoving, doMinorIfActiveEnemy)
	if !IsValid(ent) or self.Behavior == VJ_BEHAVIOR_PASSIVE_NATURE or ent:Health() <= 0 or (ent:IsPlayer() && (!ent:Alive() or GetConVarNumber("ai_ignoreplayers") == 1)) then return end
	stopMoving = stopMoving or false -- Will not run if doMinorIfActiveEnemy passes!
	doMinorIfActiveEnemy = doMinorIfActiveEnemy or false -- It will run a much quicker set enemy without resetting everything (Only if it has an active enemy!)
	if IsValid(self.Medic_CurrentEntToHeal) && self.Medic_CurrentEntToHeal == ent then self:DoMedicCode_Reset() end
	self.TimeSinceLastSeenEnemy = 0
	self:AddEntityRelationship(ent, D_HT, 99)
	self:UpdateEnemyMemory(ent, ent:GetPos())
	if doMinorIfActiveEnemy == true && IsValid(self:GetEnemy()) then self:SetEnemy(ent) return end -- End it here if it's a minor set enemy
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
---------------------------------------------------------------------------------------------------------------------------------------------
function Entity_MetaTable:CalculateProjectile(projType, startPos, endPos, projVel)
	if projType == "Line" then -- Suggested to disable gravity!
		return ((endPos - startPos):GetNormal()) * projVel
	elseif projType == "Curve" then
		-- Oknoutyoun: https://gamedev.stackexchange.com/questions/53552/how-can-i-find-a-projectiles-launch-angle
		-- Negar: https://wikimedia.org/api/rest_v1/media/math/render/svg/4db61cb4c3140b763d9480e51f90050967288397
		local result = Vector(endPos.x - startPos.x, endPos.y - startPos.y, 0) -- Verchnagan deghe
		local pos_x = result:Length()
		local pos_y = endPos.z - startPos.z
		local grav = physenv.GetGravity():Length()
		local sqrtcalc1 = (projVel * projVel * projVel * projVel)
		local sqrtcalc2 = grav * ((grav * (pos_x * pos_x)) + (2 * pos_y * (projVel * projVel)))
		local calcsum = sqrtcalc1 - sqrtcalc2 -- Yergou tevere aveltsour
		if calcsum < 0 then -- Yete teve nevas e, ooremen sharnage
			calcsum = math.abs(calcsum)
		end
		local angsqrt =  math.sqrt(calcsum)
		local angpos = math.atan(((projVel * projVel) + angsqrt) / (grav * pos_x))
		local angneg = math.atan(((projVel * projVel) - angsqrt) / (grav * pos_x))
		local pitch = 1
		if angpos > angneg then
			pitch = angneg -- Yete asiga angpos enes ne, aveli veregele
		else
			pitch = angpos
		end
		result.z = math.tan(pitch) * pos_x
		return result:GetNormal() * projVel
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function NPC_MetaTable:DoFormation_Diamond(ent, it, spacing)
	it = it or 0
	spacing = spacing or 50
	if it == 0 then
		ent:SetLastPosition(self:GetPos() + self:GetForward()*spacing + self:GetRight()*spacing)
	elseif it == 1 then
		ent:SetLastPosition(self:GetPos() + self:GetForward()*-spacing + self:GetRight()*spacing)
	elseif it == 2 then
		ent:SetLastPosition(self:GetPos() + self:GetForward()*spacing + self:GetRight()*-spacing)
	elseif it == 3 then
		ent:SetLastPosition(self:GetPos() + self:GetForward()*-spacing + self:GetRight()*-spacing)
	else
		ent:SetLastPosition(self:GetPos() + self:GetForward()*(spacing + (3 * it)) + self:GetRight()*(spacing + (3 * it)))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function NPC_MetaTable:VJ_GetDifficultyValue(int)
	if self.SelectedDifficulty == -3 then
		return math.Clamp(int - (int * 0.99),1,int)
	elseif self.SelectedDifficulty == -2 then
		return math.Clamp(int - (int * 0.75),1,int)
	elseif self.SelectedDifficulty == -1 then
		return int / 2
	elseif self.SelectedDifficulty == 0 then -- Normal
		return int
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
	return int
end
---------------------------------------------------------------------------------------------------------------------------------------------
function NPC_MetaTable:VJ_SetSchedule(schedID)
	if self.VJ_PlayingSequence == true then return end
	self.VJ_PlayingInterruptSequence = false
	//if self.MovementType == VJ_MOVETYPE_AERIAL or self.MovementType == VJ_MOVETYPE_AQUATIC then return end
	//print(self:GetName().." - "..schedID)
	self:SetSchedule(schedID)
end
---------------------------------------------------------------------------------------------------------------------------------------------
 -- !!!!! Deprecated Function !!!!! --
/*function NPC_MetaTable:VJ_GetCurrentSchedule()
	for s = 0, LAST_SHARED_SCHEDULE-1 do
		if (self:IsCurrentSchedule(s)) then return s end
	end
	return 0
end*/
---------------------------------------------------------------------------------------------------------------------------------------------
 -- !!!!! Deprecated Function !!!!! --
/*function NPC_MetaTable:VJ_IsCurrentSchedule(idcheck)
	if istable(idcheck) == true then
		for k,v in ipairs(idcheck) do
			if self:IsCurrentSchedule(v) == true then
				return true
			end
		end
	else
		if self:IsCurrentSchedule(idcheck) == true then return true end
	end
	return false
end*/
---------------------------------------------------------------------------------------------------------------------------------------------
 -- !!!!! Deprecated Function !!!!! --
/*function NPC_MetaTable:VJ_StopSoundTable(tbl)
	if not tbl then return end
	if istable(tbl) then
	for k, v in ipairs(tbl) do
		if string_find(tostring(self.CurrentSound), v) then self.CurrentSound:Stop() end
		end
	end
end*/
---------------------------------------------------------------------------------------------------------------------------------------------
 -- !!!!! Deprecated Function | Broken! !!!!! --
/*function NPC_MetaTable:VJ_IsPlayingSoundFromTable(tbl) -- Get whether if a sound is playing from a certain table
	if not tbl then return false end
	if istable(tbl) then
	for k, v in ipairs(tbl) do
		if string_find(tostring(self.CurrentSound), v) then
		return true end
		end
	end
	return false
end*/
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Hooks ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("Initialize", "VJ_Initialize", function()
	RunConsoleCommand("sv_pvsskipanimation", "0") -- Fix attachments, bones, positions, angles etc. being broken in NPCs!
end)
---------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("PhysgunPickup", "VJ_PhysgunPickup", function(ply, ent)
	if ent:GetClass() == "sent_vj_ply_spawnpoint" then
		if ply:IsAdmin() then
			return true
		else
			return false
		end
	end
end)
---------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("PlayerSelectSpawn", "VJ_PlayerSelectSpawn", function(ply)
	local points = {}
	for _,v in ipairs(ents.FindByClass("sent_vj_ply_spawnpoint")) do
		if (v.Active == true) then
			points[#points + 1] = v
		end
	end
	local result = VJ_PICK(points)
	if result != false then
		return result
	end
end)
---------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("PlayerSpawnedNPC", "VJ_PlayerSpawnedNPC", function(ply, ent)
	if ent.IsVJBaseSNPC == true or ent.IsVJBaseSpawner == true then
		ent:SetCreator(ply)
	end
end)
---------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("PlayerInitialSpawn", "VJ_PlayerInitialSpawn", function(ply)
	if IsValid(ply) then
		ply.VJ_LastInvestigateSd = 0
		ply.VJ_LastInvestigateSdLevel = 0
		if GetConVarNumber("ai_ignoreplayers") == 0 then
			local EntsTbl = ents.GetAll()
			for x = 1, #EntsTbl do
				local v = EntsTbl[x]
				if v:IsNPC() && v.IsVJBaseSNPC == true && (v.IsVJBaseSNPC_Human == true or v.IsVJBaseSNPC_Creature == true) then
					v.CurrentPossibleEnemies[#v.CurrentPossibleEnemies+1] = ply
				end
			end
		end
	end
	-- Old system
	/*local getall = ents.GetAll()
	for k,v in ipairs(getall) do
		v.VJ_LastInvestigateSd = 0
		v.VJ_LastInvestigateSdLevel = 0
		if v.IsVJBaseSNPC == true && (v.IsVJBaseSNPC_Human == true or v.IsVJBaseSNPC_Creature == true) then
			v.CurrentPossibleEnemies = v:DoHardEntityCheck(getall)
		end
	end*/
end)
---------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("OnEntityCreated", "VJ_OnEntityCreated", function(entity)
	if CLIENT or !entity:IsNPC() then return end
	if entity:GetClass() != "monster_gman" && entity:GetClass() != "npc_grenade_frag" && entity:GetClass() != "bullseye_strider_focus" && entity:GetClass() != "npc_bullseye" && entity:GetClass() != "npc_enemyfinder" && entity:GetClass() != "hornet" then
		timer.Simple(0.1, function() -- Make sure the SNPC is initialized properly
			if IsValid(entity) then
				if entity.IsVJBaseSNPC == true && entity.CurrentPossibleEnemies == nil then entity.CurrentPossibleEnemies = {} end
				local EntsTbl = ents.GetAll()
				local count = 1
				for x = 1, #EntsTbl do
					local v = EntsTbl[x]
					if v:IsNPC() or v:IsPlayer() then
						-- Add enemies to the created entity (if it's a VJ Base SNPC)
						if entity.IsVJBaseSNPC == true then
							entity:EntitiesToNoCollideCode(v)
							if (v:IsNPC() && (v:GetClass() != entity:GetClass() && entity:GetClass() != "monster_gman" && v:GetClass() != "npc_grenade_frag" && v:GetClass() != "bullseye_strider_focus" && v:GetClass() != "npc_bullseye" && v:GetClass() != "npc_enemyfinder" && v:GetClass() != "hornet" && (v.Behavior != VJ_BEHAVIOR_PASSIVE_NATURE)) && v:Health() > 0) or (v:IsPlayer() && GetConVarNumber("ai_ignoreplayers") == 0 /*&& v:Alive()*/) then
								entity.CurrentPossibleEnemies[count] = v
								count = count + 1
							end
						end
						-- Add the created entity to the list of possible enemies of VJ Base SNPCs
						if v != entity && entity:GetClass() != v:GetClass() && v.IsVJBaseSNPC == true && (v.IsVJBaseSNPC_Human == true or v.IsVJBaseSNPC_Creature == true) && (entity:IsNPC() && entity:Health() > 0 && (entity.Behavior != VJ_BEHAVIOR_PASSIVE_NATURE)) or (entity:IsPlayer()) then
							v.CurrentPossibleEnemies[#v.CurrentPossibleEnemies+1] = entity //v.CurrentPossibleEnemies = v:DoHardEntityCheck(getall)
						end
					end
				end
			end
		end)
	end
	-- Old system
	/*if entity:GetClass() != "npc_grenade_frag" && entity:GetClass() != "bullseye_strider_focus" && entity:GetClass() != "npc_bullseye" && entity:GetClass() != "npc_enemyfinder" && entity:GetClass() != "hornet" then
		timer.Simple(0.15,function()
			if IsValid(entity) then
				local getall = ents.GetAll()
				for k,v in pairs(getall) do
					if IsValid(v) && v != entity && v.IsVJBaseSNPC == true && (v.IsVJBaseSNPC_Human == true or v.IsVJBaseSNPC_Creature == true) then
						v.CurrentPossibleEnemies = v:DoHardEntityCheck(getall)
					end
				end
			end
		end)
	end*/
end)
---------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("EntityEmitSound", "VJ_EntityEmitSound", function(data)
	local ent = data.Entity
	if IsValid(ent) then
		//PrintTable(data)
		
		-- Investigate System
		if SERVER && ent:IsPlayer() && data.SoundLevel >= 75 then
			//print("---------------------------")
			//PrintTable(data)
			local quiet = (string_StartWith(data.OriginalSoundName, "player/footsteps") and (ent:Crouching() or ent:KeyDown(IN_WALK))) or false
			if quiet == false then
				ent.VJ_LastInvestigateSd = CurTime()
				ent.VJ_LastInvestigateSdLevel = (data.SoundLevel * data.Volume) + (((data.Volume <= 0.4) and 15) or 0)
			end
		end
		
		-- Disable the built-in footstep sounds for the player footstep sound for VJ NPCs unless specified otherwise
			-- Plays only on client-side, making it useless to play material-specific
		if ent:IsNPC() && ent.IsVJBaseSNPC == true && (string.EndsWith(data.OriginalSoundName, "stepleft") or string.EndsWith(data.OriginalSoundName, "stepright")) then
			return ent:MatFootStepQCEvent(data)
		end
	end
end)
---------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("EntityFireBullets", "VJ_NPC_FIREBULLET", function(ent, data)
	if IsValid(ent) && !ent:IsPlayer() && ent.IsVJBaseSNPC == true then
		local ret = nil
		local wep = ent:GetActiveWeapon()
		local ene = ent:GetEnemy()
		if IsValid(wep) && IsValid(ene) then
			-- Bullet spawn
			//data.Src = util.VJ_GetWeaponPos(ent) -- Not needed, done inside the weapon base instead
			if wep.IsVJBaseWeapon != true then
				data.Src = util.VJ_GetWeaponPos(ent)
			end
			
			-- Bullet spread
			// ent:GetPos():Distance(ent.VJ_TheController:GetEyeTrace().HitPos) -- Was used when NPC was being controlled
			local fSpread = (ent:GetPos():Distance(ene:GetPos()) / 28) * ent.WeaponSpread
			if wep.IsVJBaseWeapon == true then -- Apply the VJ Base weapon spread
				fSpread = fSpread * wep.NPC_CustomSpread
			end
			data.Spread = Vector(fSpread, fSpread, 0)
			
			-- Bullet direction
			// data.Dir = ent.VJ_TheController:GetAimVector() -- Was used when NPC was being controlled
			if ent.WeaponUseEnemyEyePos == true then
				data.Dir = (ene:EyePos() + ene:GetUp()*-5) - data.Src
			else
				data.Dir = (ene:GetPos() + ene:OBBCenter()) -  data.Src
			end
			//ent.WeaponUseEnemyEyePos = false
			
			-- Ammo counter
			if wep.IsVJBaseWeapon == true then
				wep:SetClip1(wep:Clip1() - 1)
			end
			//ent.Weapon_TimeSinceLastShot = 0 -- We don't want to change this here!
			ret = true
		end
		if ent.IsVJBaseSNPC == true then
			ent:OnFireBullet(ent, data)
		end
		if ret == true then return true end
	end
end)
---------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("ScaleNPCDamage", "VJ_ScaleHitGroupHook", function(npc, hitgroup, dmginfo)
	npc.VJ_ScaleHitGroupDamage = hitgroup
end)
---------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("EntityTakeDamage", "VJ_EntityTakeDamage", function(target, dmginfo)
	if IsValid(target) && IsValid(dmginfo:GetAttacker()) && target.IsVJBaseSNPC == true && dmginfo:GetAttacker():IsNPC() && dmginfo:IsBulletDamage() && dmginfo:GetAttacker():Disposition(target) != 1 && (dmginfo:GetAttacker():GetClass() == target:GetClass() or target:Disposition(dmginfo:GetAttacker()) == 3 /*or target:Disposition(dmginfo:GetAttacker()) == 4*/) then
		dmginfo:SetDamage(0)
	end
end)
---------------------------------------------------------------------------------------------------------------------------------------------
local function VJ_NPCPLY_DEATH(npc, attacker, inflictor)
	if attacker.IsVJBaseSNPC == true && (attacker.IsVJBaseSNPC_Human == true or attacker.IsVJBaseSNPC_Creature == true) then
		attacker:DoKilledEnemy(npc, attacker, inflictor)
		attacker:DoEntityRelationshipCheck()
	end
end
hook.Add("OnNPCKilled", "VJ_OnNPCKilled", VJ_NPCPLY_DEATH)
hook.Add("PlayerDeath", "VJ_PlayerDeath", function(victim, inflictor, attacker)
	VJ_NPCPLY_DEATH(victim, attacker, inflictor) -- Arguments are flipped between the hooks for some reason...
	
	-- Let allied SNPCs know that the player died
	for _,v in ipairs(ents.FindInSphere(victim:GetPos(), 400)) do
		if v.IsVJBaseSNPC == true && v:Disposition(victim) == D_LI then
			v:CustomOnAllyDeath(victim)
			v:PlaySoundSystem("AllyDeath")
		end
	end
end)
---------------------------------------------------------------------------------------------------------------------------------------------
VJ_Corpses = {}
hook.Add("VJ_CreateSNPCCorpse", "VJ_CreateSNPCCorpse", function(corpse, owner)
	if IsValid(corpse) && corpse.IsVJBaseCorpse == true then
		-- Clear out all removed corpses from the table
		for k, v in pairs(VJ_Corpses) do
			if !IsValid(v) then
				table_remove(VJ_Corpses, k)
			end
		end
		
		local count = #VJ_Corpses
		VJ_Corpses[count + 1] = corpse
		count = count + 1 -- Since we added one above
		
		-- Check if we surpassed the limit!
		if count > GetConVarNumber("vj_npc_globalcorpselimit") then
			local GetTheFirstValue = table.GetFirstValue(VJ_Corpses)
			table_remove(VJ_Corpses, table.GetFirstKey(VJ_Corpses))
			if IsValid(GetTheFirstValue) then
				GetTheFirstValue:Fire(GetTheFirstValue.FadeCorpseType, "", 0.5) -- Fade out
				timer.Simple(1, function() if IsValid(GetTheFirstValue) then GetTheFirstValue:Remove() end end) -- Make sure it's removed
			end
		end
	end
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Convar Callbacks ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
cvars.AddChangeCallback("ai_ignoreplayers", function(convar_name, oldValue, newValue)
	if tonumber(newValue) == 0 then
		local getplys = player.GetAll()
		local getall = ents.GetAll()
		for x = 1, #getall do
			local v = getall[x]
			if v:IsNPC() && v.IsVJBaseSNPC == true && (v.IsVJBaseSNPC_Human == true or v.IsVJBaseSNPC_Creature == true) then
				for _, ply in pairs(getplys) do
					v.CurrentPossibleEnemies[#v.CurrentPossibleEnemies+1] = ply
				end
			end
		end
	else
		for _, v in pairs(ents.GetAll()) do
			if v.IsVJBaseSNPC == true then
				if v.FollowingPlayer == true then v:FollowPlayerReset() end -- Reset if it's following the player
				//v.CurrentPossibleEnemies = v:DoHardEntityCheck(getall)
				local posenemies = v.CurrentPossibleEnemies
				local it = 1
				while it <= #posenemies do
					local x = posenemies[it]
					if IsValid(x) && x:IsPlayer() then
						v:AddEntityRelationship(x, D_NU, 10) -- Make the player neutral
						if IsValid(v:GetEnemy()) && v:GetEnemy() == x then v:ResetEnemy() end -- Reset the NPC's enemy if it's a player
						table_remove(posenemies, it) -- Remove the player from possible enemy table
					else
						it = it + 1
					end
				end
			end
		end
	end
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Net Messages ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if (CLIENT) then
	net.Receive("vj_music_run",function(len)
		VJ_CL_MUSIC_CURRENT = VJ_CL_MUSIC_CURRENT or {}
		local ent = net.ReadEntity()
		local sdtbl = net.ReadTable()
		local sdvol = net.ReadFloat()
		local sdspeed = net.ReadFloat()
		//local sdfadet = net.ReadFloat()
		//local entindex = ent:EntIndex()
		//print(ent)
		sound.PlayFile("sound/"..VJ_PICK(sdtbl), "noplay", function(soundchannel, errorID, errorName)
			if IsValid(soundchannel) then
				if #VJ_CL_MUSIC_CURRENT <= 0 then soundchannel:Play() end
				soundchannel:EnableLooping(true)
				soundchannel:SetVolume(sdvol)
				soundchannel:SetPlaybackRate(sdspeed)
				table.insert(VJ_CL_MUSIC_CURRENT,{npc=ent,channel=soundchannel})
			end
		end)
		timer.Create("vj_music_think",1,0,function()
			//PrintTable(VJ_CL_MUSIC_CURRENT)
			for k,v in pairs(VJ_CL_MUSIC_CURRENT) do
				//PrintTable(v)
				//if v.npc == entindex then
				if !IsValid(v.npc) then
					v.channel:Stop()
					v.channel = nil
					table_remove(VJ_CL_MUSIC_CURRENT,k)
				end
			end
			if #VJ_CL_MUSIC_CURRENT <= 0 then
				timer.Remove("vj_music_think")
				VJ_CL_MUSIC_CURRENT = {}
			else
				for _,v in pairs(VJ_CL_MUSIC_CURRENT) do
					if IsValid(v.npc) && IsValid(v.channel) then
						v.channel:Play() break
					end
				end
			end
		end)
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
/*if (CLIENT) then
	require("sound_vj_track")
	sound_vj_track.Add("VJ_SpiderQueenThemeMusic","vj_dm_spidermonster/Dark Messiah - Avatar of the Spider Goddess.wav",161)
end*/