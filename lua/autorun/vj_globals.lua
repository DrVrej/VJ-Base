/*--------------------------------------------------
	=============== Global Functions & Variables ===============
	*** Copyright (c) 2012-2022 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
include('autorun/vj_controls.lua')
-- Localized static values
local CurTime = CurTime
local IsValid = IsValid
local GetConVar = GetConVar
local CreateSound = CreateSound
local istable = istable
local isstring = isstring
local isnumber = isnumber
local tonumber = tonumber
local string_find = string.find
local string_Replace = string.Replace
local string_StartWith = string.StartWith
local string_lower = string.lower
local table_remove = table.remove
local math_clamp = math.Clamp
local math_random = math.random
local math_round = math.Round
local math_floor = math.floor
local bAND = bit.band
local bShiftL = bit.lshift
local bShiftR = bit.rshift
local defAng = Angle(0, 0, 0)
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

VJ_STATE_NONE = 0 -- No state is set, this is the default value
VJ_STATE_FREEZE = 1 -- AI Completely freezes, basically applies Disable AI on the NPC (Including relationship system!)
VJ_STATE_ONLY_ANIMATION = 100 -- Only plays animation tasks, attacks. Disables: Movements, turning and other non-animation tasks!
VJ_STATE_ONLY_ANIMATION_CONSTANT = 101 -- Same as VJ_STATE_ONLY_ANIMATION + Idle animation will not play!
VJ_STATE_ONLY_ANIMATION_NOATTACK = 102 -- Same as VJ_STATE_ONLY_ANIMATION + Attacks will be disabled

VJ_WEP_STATE_NONE = 0 -- No state is set
VJ_WEP_STATE_HOLSTERED = 1 -- Weapon is holstered
VJ_WEP_STATE_ANTI_ARMOR = 20 -- It's currently using its anti-armor weapon
VJ_WEP_STATE_MELEE = 21 -- It's currently using its melee weapon
---------------------------------------------------------------------------------------------------------------------------------------------
if SERVER then
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
		tbl = tbl[math_random(1, #tbl)]
		return tbl
	else
		return tbl -- Yete table che, veratartsour abranke
	end
	return false
end
-- !!!!!!!!!!!!!! DO NOT USE THIS FUNCTION !!!!!!!!!!!!!! [Backwards Compatibility!]
	function VJ_PICKRANDOMTABLE(tbl)
		if not tbl then return false end -- Yete table pame choone meche, veratartsour false!
		if istable(tbl) then
			if #tbl < 1 then return false end -- Yete table barabe (meg en aveli kich), getsoor!
			tbl = tbl[math_random(1,#tbl)]
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
	if math_round(num / multiple) == num / multiple then
		return num
	else
		return math_round(num / multiple) * multiple
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function VJ_Color2Byte(color)
	return bShiftL(math_floor(color.r*7/255), 5) + bShiftL(math_floor(color.g*7/255), 2) + math_floor(color.b*3/255)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function VJ_Color8Bit2Color(bits)
	return Color(bShiftR(bits,5)*255/7, bAND(bShiftR(bits,2), 0x07)*255/7, bAND(bits,0x03)*255/3)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function VJ_FindInCone(pos, dir, dist, deg, extraOptions)
	extraOptions = extraOptions or {}
		local allEntities = extraOptions.AllEntities or false -- Should it detect all types of entities? | False = NPCs and Players only!
	local foundEnts = {}
	local cosDeg = math.cos(math.rad(deg))
	for _,v in pairs(ents.FindInSphere(pos, dist)) do
		if ((allEntities == true) or (allEntities == false && ((v:IsNPC() or v:IsNextBot()) or v:IsPlayer()))) && (dir:Dot((v:GetPos() - pos):GetNormalized()) > cosDeg) then
			foundEnts[#foundEnts + 1] = v
		end
	end
	return foundEnts
end
---------------------------------------------------------------------------------------------------------------------------------------------
function VJ_CreateSound(ent, sd, sdLevel, sdPitch, customFunc)
	if not sd then return end
	if istable(sd) then
		if #sd < 1 then return end -- If the table is empty then end it
		sd = sd[math_random(1, #sd)]
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
		local result = ent:GetSequenceActivity(ent:LookupSequence(anim))
		if result == nil or result == -1 then
			return false
		else
			return result
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

	for _, v in ipairs(anim) do
		if isnumber(v) && v != -1 then v = ent:GetSequenceName(ent:SelectWeightedSequence(v)) end -- Translate activity to sequence
		if string_lower(v) == string_lower(ent:GetSequenceName(ent:GetSequence())) then
			return true
		end
	end
	//if anim == ent:GetSequenceName(ent:GetSequence()) then return true end
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function VJ_RemoveAnimExtensions(ent, anim)
	if string_find(anim, "vjseq_") then
		anim = string_Replace(anim, "vjseq_", "")
	end
	if string_find(anim, "vjges_") then
		anim = string_Replace(anim, "vjges_", "")
	end
	return anim
end
---------------------------------------------------------------------------------------------------------------------------------------------
local props = {prop_physics=true, prop_physics_multiplayer=true, prop_physics_respawnable=true}
--
function VJ_IsProp(ent)
	return props[ent:GetClass()] == true -- Without == check, it would return nil on false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function VJ_IsAlive(ent)
	return ent:Health() > 0 && !ent.Dead
end
---------------------------------------------------------------------------------------------------------------------------------------------
function VJ_DestroyCombineTurret(selfEnt, ent)
	if ent:GetClass() == "npc_turret_floor" then
		ent:Fire("selfdestruct")
		ent:SetHealth(0)
		local phys = ent:GetPhysicsObject()
		if IsValid(phys) then
			phys:EnableMotion(true)
			phys:ApplyForceCenter(selfEnt:GetForward()*10000)
		end
		return true
	end
	return false
end
--------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Applies speed effect to the given NPC/Player, if another speed effect is already applied, it will skip!
		- ent = The entity to apply the speed modification
		- speed = The speed, 1.0 is the normal speed
		- setTime = How long should this be in effect? | DEFAULT = 1
	Returns
		- false, effect did NOT apply
		- true, effect applied
-----------------------------------------------------------]]
function VJ_ApplySpeedEffect(ent, speed, setTime)
    ent.VJ_SpeedEffectT = ent.VJ_SpeedEffectT or 0
    if ent.VJ_SpeedEffectT < CurTime() then
        ent.VJ_SpeedEffectT = CurTime() + (setTime or 1)
		local orgPlayback = ent:GetPlaybackRate()
		local plyOrgWalk, plyOrgRun;
		if ent:IsPlayer() then
			plyOrgWalk = ent:GetWalkSpeed()
			plyOrgRun = ent:GetRunSpeed()
		end
        local hookName = "VJ_SpeedEffect" .. ent:EntIndex()
        hook.Add("Think", hookName, function()
            if !IsValid(ent) then
                hook.Remove("Think", hookName)
                return
			elseif (ent.VJ_SpeedEffectT < CurTime()) or (ent:Health() <= 0) then
                hook.Remove("Think", hookName)
				if ent.IsVJBaseSNPC then ent.AnimationPlaybackRate = orgPlayback end
				ent:SetPlaybackRate(orgPlayback)
				if ent:IsPlayer() then
					ent:SetWalkSpeed(plyOrgWalk)
					ent:SetRunSpeed(plyOrgRun)
				end
                return
            end
			if ent.IsVJBaseSNPC then ent.AnimationPlaybackRate = speed end
			ent:SetPlaybackRate(speed)
            if ent:IsPlayer() then
                ent:SetWalkSpeed(plyOrgWalk * speed)
                ent:SetRunSpeed(plyOrgRun * speed)
            end
        end)
		return true
    end
	return false
end
--------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Makes the entitiy in question utilize it's ragdoll for its' collision rather than the normal collision. Note that the collision bounds can still be set, however they won't be used for actual collision, only as data.
		- ent = The entity to apply the ragdoll collision
		- mdl = The model to override and use for the collision. By default it should be nil unless you're trying stuff
	Returns
		- false, bone follower as not created
		- Entity, the bone follower that was created
-----------------------------------------------------------]]
local boneFollowerClass = "phys_bone_follower"
--
function VJ_CreateBoneFollower(ent, mdl)
	if !IsValid(ent) then return false end
	local ragdoll = mdl or ent:GetModel()
	if !util.IsValidRagdoll(ragdoll) then return false end

	ent:SetCustomCollisionCheck(true)
	
	local boneFollower = ents.Create("sent_vj_bonefollower")
	boneFollower:SetModel(ragdoll)
	boneFollower:SetPos(ent:GetPos())
	boneFollower:SetAngles(ent:GetAngles())
	boneFollower:SetParent(ent)
	boneFollower:AddEffects(EF_BONEMERGE)
	boneFollower:Spawn()
	boneFollower:SetOwner(ent)
	ent:DeleteOnRemove(boneFollower)

	local hookName = "VJ_BoneFollower_DisableCollisions_" .. boneFollower:EntIndex()
	hook.Add("ShouldCollide",hookName,function(ent1,ent2)
		if !IsValid(boneFollower) or !IsValid(ent) then
			hook.Remove("ShouldCollide",hookName)
			return true
		end
		if ent1 == ent && ent2:GetClass() == boneFollowerClass or ent2 == ent && ent1:GetClass() == boneFollowerClass then
			return false
		end
		return true
	end)

	return boneFollower
end
---------------------------------------------------------------------------------------------------------------------------------------------
-- Run in Console: lua_run for k,v in ipairs(ents.GetAll()) do if v:GetClass() == "prop_dynamic" then v:Remove() end end
function VJ_CreateTestObject(pos, ang, color, time, mdl)
	local obj = ents.Create("prop_dynamic")
	obj:SetModel(mdl or "models/hunter/blocks/cube025x025x025.mdl")
	obj:SetPos(pos)
	obj:SetAngles(ang or defAng)
	obj:SetColor(color or Color(255, 0, 0))
	obj:Spawn()
	obj:Activate()
	timer.Simple(time or 3, function() if IsValid(obj) then obj:Remove() end end)
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
	ply:ChatPrint("#vjbase.print.npccontroller.entrance")
	if self.IsVJBaseSNPC == true then
		self:Controller_IntMsg(ply, controlEnt)
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
function NPC_MetaTable:VJ_GetNearestPointToVector(pos, sameZ)
	-- sameZ = Should the Z of the result pos (resPos) be the same as my Z ?
	local myZ = self:GetPos().z
	local resMe = self:NearestPoint(pos + self:OBBCenter())
	resMe.z = myZ
	local resPos = pos
	resPos.z = sameZ and myZ or pos.z
	return resMe, resPos
end
---------------------------------------------------------------------------------------------------------------------------------------------
function NPC_MetaTable:VJ_GetNearestPointToEntity(ent, sameZ)
	-- sameZ = Should the Z of the other entity's result pos (resEnt) be the same as my Z ?
	local myNearPoint = self:GetDynamicOrigin()
	local resMe = self:NearestPoint(ent:GetPos() + self:OBBCenter())
	resMe.z = myNearPoint.z
	local resEnt = ent:NearestPoint(myNearPoint + ent:OBBCenter())
	resEnt.z = sameZ and myNearPoint.z or ent:GetPos().z
	return resMe, resEnt
end
---------------------------------------------------------------------------------------------------------------------------------------------
function NPC_MetaTable:VJ_GetNearestPointToEntityDistance(ent)
	local entPos = ent:GetPos()
	local myNearPoint = self:GetDynamicOrigin()
	local resMe = self:NearestPoint(entPos + self:OBBCenter())
	resMe.z = myNearPoint.z
	local resEnt = ent:NearestPoint(myNearPoint + ent:OBBCenter())
	resEnt.z = entPos.z
	return resEnt:Distance(resMe)
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
function NPC_MetaTable:VJ_GetDifficultyValue(int)
	if self.SelectedDifficulty == -3 then
		return math_clamp(int - (int * 0.99), 1, int)
	elseif self.SelectedDifficulty == -2 then
		return math_clamp(int - (int * 0.75), 1, int)
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
		if GetConVar("ai_ignoreplayers"):GetInt() == 0 then
			local EntsTbl = ents.GetAll()
			for x = 1, #EntsTbl do
				local v = EntsTbl[x]
				if (v:IsNPC() or v:IsNextBot()) && v.IsVJBaseSNPC == true && (v.IsVJBaseSNPC_Human == true or v.IsVJBaseSNPC_Creature == true) then
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
local ignoreEnts = {monster_generic=true, monster_furniture=true, npc_furniture=true, monster_gman=true, npc_grenade_frag=true, bullseye_strider_focus=true, npc_bullseye=true, npc_enemyfinder=true, hornet=true}
--
hook.Add("OnEntityCreated", "VJ_OnEntityCreated", function(entity)
	if CLIENT or !(entity:IsNPC() or entity:IsNextBot()) then return end
	if !ignoreEnts[entity:GetClass()] then
		timer.Simple(0.1, function() -- Make sure the SNPC is initialized properly
			if IsValid(entity) then
				if entity.IsVJBaseSNPC == true && entity.CurrentPossibleEnemies == nil then entity.CurrentPossibleEnemies = {} end
				local EntsTbl = ents.GetAll()
				local count = 1
				local cvSeePlys = GetConVar("ai_ignoreplayers"):GetInt() == 0
				for x = 1, #EntsTbl do
					local v = EntsTbl[x]
					if ((v:IsNPC() or v:IsNextBot()) or v:IsPlayer()) && !ignoreEnts[v:GetClass()] then
						-- Add enemies to the created entity (if it's a VJ Base SNPC)
						if entity.IsVJBaseSNPC == true then
							entity:EntitiesToNoCollideCode(v)
							if ((v:IsNPC() or v:IsNextBot()) && (v:GetClass() != entity:GetClass() && (v.Behavior != VJ_BEHAVIOR_PASSIVE_NATURE)) && v:Health() > 0) or (v:IsPlayer() && cvSeePlys /*&& v:Alive()*/) then
								entity.CurrentPossibleEnemies[count] = v
								count = count + 1
							end
						end
						-- Add the created entity to the list of possible enemies of VJ Base SNPCs
						if v != entity && entity:GetClass() != v:GetClass() && v.IsVJBaseSNPC == true && (v.IsVJBaseSNPC_Human == true or v.IsVJBaseSNPC_Creature == true) && ((entity:IsNPC() or entity:IsNextBot()) && entity:Health() > 0 && (entity.Behavior != VJ_BEHAVIOR_PASSIVE_NATURE)) or (entity:IsPlayer()) then
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
		-- Investigate System
		if SERVER && (ent:IsPlayer() or (ent:IsNPC() or ent:IsNextBot())) && data.SoundLevel >= 75 then
			//print("---------------------------")
			//PrintTable(data)
			local quiet = (string_StartWith(data.OriginalSoundName, "player/footsteps") and (ent:IsPlayer() && (ent:Crouching() or ent:KeyDown(IN_WALK)))) or false
			if quiet != true && ent.Dead != true then
				ent.VJ_LastInvestigateSd = CurTime()
				ent.VJ_LastInvestigateSdLevel = (data.SoundLevel * data.Volume) + (((data.Volume <= 0.4) and 15) or 0)
			end
		-- Disable the built-in footstep sounds for the player footstep sound for VJ NPCs unless specified otherwise
			-- Plays only on client-side, making it useless to play material-specific
		elseif (ent:IsNPC() or ent:IsNextBot()) && ent.IsVJBaseSNPC == true && (string.EndsWith(data.OriginalSoundName, "stepleft") or string.EndsWith(data.OriginalSoundName, "stepright")) then
			return ent:MatFootStepQCEvent(data)
		end
	end
end)
---------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("EntityFireBullets", "VJ_NPC_FIREBULLET", function(ent, data)
	if IsValid(ent) && (ent:IsNPC() or ent:IsNextBot()) && ent.IsVJBaseSNPC == true then
		local wep = ent:GetActiveWeapon()
		local ene = ent:GetEnemy()
		local edited = false
		if IsValid(wep) && IsValid(ene) then
			if wep.IsVJBaseWeapon then
				-- Ammo counter for VJ weapons
				wep:SetClip1(wep:Clip1() - 1)
				//ent.Weapon_TimeSinceLastShot = 0 -- We don't want to change this here!
			else
				-- Bullet spawn for non-VJ weapons
				data.Src = util.VJ_GetWeaponPos(ent)
			end
			
			-- Bullet spread
			// ent:GetPos():Distance(ent.VJ_TheController:GetEyeTrace().HitPos) -- Was used when NPC was being controlled
			local fSpread = (ent:GetPos():Distance(ene:GetPos()) / 28) * (ent.WeaponSpread or 1) * (wep.NPC_CustomSpread or 1)
			data.Spread = Vector(fSpread, fSpread, 0)
			
			-- Bullet direction
			// data.Dir = ent.VJ_TheController:GetAimVector() -- Was used when NPC was being controlled
			if ent.WeaponUseEnemyEyePos == true then
				data.Dir = (ene:EyePos() + ene:GetUp()*-5) - data.Src
			else
				data.Dir = (ene:GetPos() + ene:OBBCenter()) -  data.Src
			end
			//ent.WeaponUseEnemyEyePos = false
			edited = true
		end
		ent:OnFireBullet(ent, data)
		if edited then return true end
	end
end)
---------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("EntityTakeDamage", "VJ_EntityTakeDamage", function(target, dmginfo)
	local attacker = dmginfo:GetAttacker()
	if IsValid(target) && IsValid(attacker) && target.IsVJBaseSNPC == true && (attacker:IsNPC() or attacker:IsNextBot()) && dmginfo:IsBulletDamage() && attacker:Disposition(target) != D_HT && (attacker:GetClass() == target:GetClass() or target:Disposition(attacker) == D_LI /*or target:Disposition(attacker) == 4*/) then
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
--
hook.Add("VJ_CreateSNPCCorpse", "VJ_CreateSNPCCorpse", function(corpse, owner)
	if IsValid(corpse) && corpse.IsVJBaseCorpse == true then
		-- Clear out all removed corpses from the table
		for k, v in pairs(VJ_Corpses) do
			if !IsValid(v) then
				table_remove(VJ_Corpses, k)
			end
		end
		
		local count = #VJ_Corpses + 1
		VJ_Corpses[count] = corpse
		
		-- Check if we surpassed the limit!
		if count > GetConVar("vj_npc_globalcorpselimit"):GetInt() then
			local oldestCorpse = table_remove(VJ_Corpses, 1)
			if IsValid(oldestCorpse) then
				oldestCorpse:Fire(oldestCorpse.FadeCorpseType, "", 0) -- Fade out
				timer.Simple(1, function() if IsValid(oldestCorpse) then oldestCorpse:Remove() end end) -- Make sure it's removed
			end
		end
	end
end)
---------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("PlayerCanPickupWeapon", "VJ_PLAYER_CANPICKUPWEAPON", function(ply, wep)
	//print(wep:GetWeaponWorldModel())
	if ply.VJ_CanBePickedUpWithOutUse == true && ply.VJ_CanBePickedUpWithOutUse_Class == wep:GetClass() then
		if wep.IsVJBaseWeapon == true && !ply:HasWeapon(wep:GetClass()) then
			ply.VJ_CanBePickedUpWithOutUse = false
			ply.VJ_CanBePickedUpWithOutUse_Class = nil
			return true
		else
			ply.VJ_CanBePickedUpWithOutUse = false
			ply.VJ_CanBePickedUpWithOutUse_Class = nil
		end
	end
	if wep.IsVJBaseWeapon == true then
		//if wep.VJ_CanBePickedUpWithOutUse == true then return true end
		if GetConVar("vj_npc_plypickupdropwep"):GetInt() == 0 then return false end
		if ply:KeyPressed(IN_USE) && (ply:GetEyeTrace().Entity == wep) then
		return true else return false end
	end
end)
---------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("PlayerGiveSWEP", "VJ_PLAYER_GIVESWEP", function(ply, class, swep)
	//if swep.IsVJBaseWeapon == true then
		ply.VJ_CanBePickedUpWithOutUse = true
		ply.VJ_CanBePickedUpWithOutUse_Class = class
		timer.Simple(0.1,function() if IsValid(ply) then ply.VJ_CanBePickedUpWithOutUse = false ply.VJ_CanBePickedUpWithOutUse_Class = nil end end)
		//PrintTable(swep)
	//end
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
			if (v:IsNPC() or v:IsNextBot()) && v.IsVJBaseSNPC == true && (v.IsVJBaseSNPC_Human == true or v.IsVJBaseSNPC_Creature == true) then
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
if CLIENT then
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
/*if CLIENT then
	require("sound_vj_track")
	sound_vj_track.Add("VJ_SpiderQueenThemeMusic","vj_dm_spidermonster/Dark Messiah - Avatar of the Spider Goddess.wav",161)
end*/
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Utility Functions ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Customizable function that deals radius damage with the given properties
		- attacker = The entity that is dealing the damage | REQUIRED
		- inflictor = The entity that is inflicting the damage | REQUIRED
		- startPos = Start position of the radius | DEFAULT = attacker:GetPos()
		- dmgRadius = How far the damage radius goes | DEFAULT = 150
		- dmgMax = Maximum amount of damage it deals to an entity | DEFAULT = 15
		- dmgType = The damage type | DEFAULT = DMG_BLAST
		- ignoreInnocents = Should it ignore NPCs/Players that are friendly OR have no-target on (Including ignore players) | DEFAULT = true
		- realisticRadius = Should it use a realistic radius? Entities farther away receive less damage and force | DEFAULT = true
		- extraOptions = Table that holds extra options to modify parts of the code
			- DisableVisibilityCheck = Should it disable the visibility check? | DEFAULT = false
			- Force = The force to apply when damage is applied | DEFAULT = false
			- UpForce = Optional setting for extraOptions.Force that override the up force | DEFAULT = extraOptions.Force
			- DamageAttacker = Should it damage the attacker as well? | DEFAULT = false
			- UseConeDegree = If set to a number, it will use a cone-based radius | DEFAULT = nil
			- UseConeDirection = The direction (position) the cone goes to | DEFAULT = attacker:GetForward()
		- customFunc(gib) = Use this to edit the entity which is given as parameter "gib"
	Returns
		- table, the entities it damaged (Can be empty!)
-----------------------------------------------------------]]
local specialDmgEnts = {npc_strider=true, npc_combinedropship=true, npc_combinegunship=true, npc_helicopter=true}
--
function util.VJ_SphereDamage(attacker, inflictor, startPos, dmgRadius, dmgMax, dmgType, ignoreInnocents, realisticRadius, extraOptions, customFunc)
	startPos = startPos or attacker:GetPos()
	dmgRadius = dmgRadius or 150
	dmgMax = dmgMax or 15
	extraOptions = extraOptions or {}
		local disableVisibilityCheck = extraOptions.DisableVisibilityCheck or false
		local baseForce = extraOptions.Force or false
	local dmgFinal = dmgMax
	local hitEnts = {}
	for _,v in pairs((isnumber(extraOptions.UseConeDegree) and VJ_FindInCone(startPos, extraOptions.UseConeDirection or attacker:GetForward(), dmgRadius, extraOptions.UseConeDegree or 90, {AllEntities=true})) or ents.FindInSphere(startPos, dmgRadius)) do
		if (attacker.VJ_IsBeingControlled == true && attacker.VJ_TheControllerBullseye == v) or (v:IsPlayer() && v.IsControlingNPC == true) then continue end -- Don't damage controller bullseye and player
		local nearestPos = v:NearestPoint(startPos) -- From the enemy position to the given position
		if realisticRadius != false then -- Decrease damage from the nearest point all the way to the enemy point then clamp it!
			dmgFinal = math_clamp(dmgFinal * ((dmgRadius - startPos:Distance(nearestPos)) + 150) / dmgRadius, dmgMax / 2, dmgFinal)
		end
		
		if (disableVisibilityCheck == false && (v:VisibleVec(startPos) or v:Visible(attacker))) or (disableVisibilityCheck == true) then
			local function DoDamageCode()
				if (customFunc) then customFunc(v) end
				hitEnts[#hitEnts + 1] = v
				if specialDmgEnts[v:GetClass()] then
					v:TakeDamage(dmgFinal, attacker, inflictor)
				else
					local dmgInfo = DamageInfo()
					dmgInfo:SetDamage(dmgFinal)
					dmgInfo:SetAttacker(attacker)
					dmgInfo:SetInflictor(inflictor)
					dmgInfo:SetDamageType(dmgType or DMG_BLAST)
					dmgInfo:SetDamagePosition(nearestPos)
					if baseForce != false then
						local force = baseForce
						local forceUp = extraOptions.UpForce or false
						if VJ_IsProp(v) or v:GetClass() == "prop_ragdoll" then
							local phys = v:GetPhysicsObject()
							if IsValid(phys) then
								if forceUp == false then forceUp = force / 9.4 end
								//v:SetVelocity(v:GetUp()*100000)
								if v:GetClass() == "prop_ragdoll" then force = force * 1.5 end
								phys:ApplyForceCenter(((v:GetPos() + v:OBBCenter() + v:GetUp() * forceUp) - startPos) * force) //+attacker:GetForward()*vForcePropPhysics
							end
						else
							force = force * 1.2
							if forceUp == false then forceUp = force end
							dmgInfo:SetDamageForce(((v:GetPos() + v:OBBCenter() + v:GetUp() * forceUp) - startPos) * force)
						end
					end
					v:TakeDamageInfo(dmgInfo)
					VJ_DestroyCombineTurret(attacker, v)
				end
			end
			
			-- Self
			if v:EntIndex() == attacker:EntIndex() then
				if extraOptions.DamageAttacker then DoDamageCode() end -- If it can't self hit, then skip
			-- NPCs / Players
			elseif (ignoreInnocents == false) or (v:IsNPC() && v:Disposition(attacker) != D_LI && v:Health() > 0 && (v:GetClass() != attacker:GetClass())) or (v:IsPlayer() && GetConVar("ai_ignoreplayers"):GetInt() == 0 && v:Alive() && !v:IsFlagSet(FL_NOTARGET)) then
				DoDamageCode()
			-- Other types of entities
			elseif !v:IsNPC() && !v:IsPlayer() then
				DoDamageCode()
			end
		end
	end
	return hitEnts
end
---------------------------------------------------------------------------------------------------------------------------------------------
function util.VJ_GetWeaponPos(GetClassEntity)
	if GetClassEntity:GetActiveWeapon() == NULL then return false end
	local wep = GetClassEntity:GetActiveWeapon()
	local getmuzzle;
	if (wep:IsValid()) then
		for i = 1, #wep:GetAttachments() do
			if wep:GetAttachments()[i].name == "muzzle" then
				getmuzzle = "muzzle" break
			elseif wep:GetAttachments()[i].name == "muzzleA" then
				getmuzzle = "muzzleA" break
			elseif wep:GetAttachments()[i].name == "muzzle_flash" then
				getmuzzle = "muzzle_flash" break
			elseif wep:GetAttachments()[i].name == "muzzle_flash1" then
				getmuzzle = "muzzle_flash1" break
			elseif wep:GetAttachments()[i].name == "muzzle_flash2" then
				getmuzzle = "muzzle_flash2" break
			elseif wep:GetAttachments()[i].name == "ValveBiped.muzzle" then
				getmuzzle = "ValveBiped.muzzle" break
			else 
				getmuzzle = false
			end
		end
		if (getmuzzle == false) or getmuzzle == nil then
			if GetClassEntity:LookupBone("ValveBiped.Bip01_R_Hand") != nil then
				return GetClassEntity:GetBonePosition(GetClassEntity:LookupBone("ValveBiped.Bip01_R_Hand"))
			else
				print("WARNING: "..GetClassEntity:GetName().."'s weapon doesn't have a proper attachment or bone!")
				return GetClassEntity:EyePos()
			end
		end
		//print("It has a proper attachment.")
		return wep:GetAttachment(wep:LookupAttachment(getmuzzle)).Pos //+ GetClassEntity:GetUp()*-45
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
-- Working test but no uses at the moment
/*
local metaNPC = FindMetaTable("NPC")
local metaVJ = {}
local function __index(self, key)
	local val = metaVJ[key]
	if val != nil then return val end
	//if ( key == "Example1" ) then return self.Example2 end
	return metaNPC.__index(self, key)
end

function metaVJ:GetIdealMoveSpeed(example)
	if example == true then
		return 1000
	else
		return metaNPC.GetIdealMoveSpeed(self)
	end
end

hook.Add("OnEntityCreated", "vjmetatabletest", function(ent)
	if scripted_ents.IsBasedOn(ent:GetClass(), "npc_vj_creature_base") or scripted_ents.IsBasedOn(ent:GetClass(), "npc_vj_human_base") then
		local mt = table.Merge({}, debug.getmetatable(ent))
		mt.__index = __index
		debug.setmetatable(ent, mt)
	end
end)
*/