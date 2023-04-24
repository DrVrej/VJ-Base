/*--------------------------------------------------
	=============== Global Functions & Variables ===============
	*** Copyright (c) 2012-2023 by DrVrej, All rights reserved. ***
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
local sdEmitHint = sound.EmitHint
local defAng = Angle(0, 0, 0)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Global Functions & Variables ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
VJ_CVAR_IGNOREPLAYERS = GetConVar("ai_ignoreplayers"):GetInt() != 0

-- NPC movement types, information is located inside the NPC bases...
VJ_MOVETYPE_GROUND = 1
VJ_MOVETYPE_AERIAL = 2
VJ_MOVETYPE_AQUATIC = 3
VJ_MOVETYPE_STATIONARY = 4
VJ_MOVETYPE_PHYSICS = 5

-- NPC behavior types, information is located inside the NPC bases...
VJ_BEHAVIOR_AGGRESSIVE = 1
VJ_BEHAVIOR_NEUTRAL = 2
VJ_BEHAVIOR_PASSIVE = 3
VJ_BEHAVIOR_PASSIVE_NATURE = 4

-- NPC AI states
VJ_STATE_NONE = 0 -- No state is set (Default)
VJ_STATE_FREEZE = 1 -- AI Completely freezes, basically applies Disable AI on the NPC (Including relationship system!)
VJ_STATE_ONLY_ANIMATION = 100 -- Only plays animation tasks, attacks. Disables: Movements, turning and other non-animation tasks!
VJ_STATE_ONLY_ANIMATION_CONSTANT = 101 -- Same as VJ_STATE_ONLY_ANIMATION + Idle animation will not play!
VJ_STATE_ONLY_ANIMATION_NOATTACK = 102 -- Same as VJ_STATE_ONLY_ANIMATION + Attacks will be disabled

-- NPC attack type
VJ_ATTACK_NONE = 0 -- No state is set (Default)
VJ_ATTACK_CUSTOM = 1 -- Custom attack (Used by developers to make custom attacks)
VJ_ATTACK_MELEE = 2 -- Melee attack
VJ_ATTACK_RANGE = 3 -- Ranged attack
VJ_ATTACK_LEAP = 4 -- Leap attack
VJ_ATTACK_GRENADE = 5 -- Grenade attack

-- NPC attack status
VJ_ATTACK_STATUS_NONE = 0 -- No state is set (Default)
VJ_ATTACK_STATUS_DONE = 1 -- The current attack has been executed completely and is marked as done
VJ_ATTACK_STATUS_STARTED = 2 -- The current attack has started and is expected to execute soon
VJ_ATTACK_STATUS_EXECUTED = 10 -- The current attack has been executed at least once
VJ_ATTACK_STATUS_EXECUTED_HIT = 11 -- The current attack has been executed at least once AND hit an entity at least once (Melee & Leap attacks)

-- NPC weapon states for the human base
VJ_WEP_STATE_READY = 0 -- No state is set (Default)
VJ_WEP_STATE_HOLSTERED = 1 -- Weapon is holstered
VJ_WEP_STATE_RELOADING = 2 -- Weapon is reloading

-- NPC weapon inventory status
VJ_WEP_INVENTORY_NONE = 0 -- Currently using no weapon (Default)
VJ_WEP_INVENTORY_PRIMARY = 1 -- Currently using its primary weapon
VJ_WEP_INVENTORY_SECONDARY = 2 -- Currently using its secondary weapon
VJ_WEP_INVENTORY_MELEE = 3 -- Currently using its melee weapon
VJ_WEP_INVENTORY_ANTI_ARMOR = 4 -- Currently using its anti-armor weapon

-- NPC facing status
VJ_FACING_NONE = 0 -- No status is set (Default)
VJ_FACING_ENEMY = 1 -- Currently attempting to face the enemy
VJ_FACING_ENTITY = 2 -- Currently attempting to face a specific entity
VJ_FACING_POSITION = 3 -- Currently attempting to face a specific position

-- NPC model animation set
VJ_MODEL_ANIMSET_NONE = 0 -- No model animation set detected (Default)
VJ_MODEL_ANIMSET_COMBINE = 1 -- Current model's animation set is combine
VJ_MODEL_ANIMSET_METROCOP = 2 -- Current model's animation set is metrocop
VJ_MODEL_ANIMSET_REBEL = 3 -- Current model's animation set is citizen / rebel
VJ_MODEL_ANIMSET_PLAYER = 4 -- Current model's animation set is player
VJ_MODEL_ANIMSET_CUSTOM = 10 -- Use this when defining a custom model set

-- Source NPC condition definitions because they are not defined in GMod for some reason ??
COND_BEHIND_ENEMY = 29
COND_BETTER_WEAPON_AVAILABLE = 46
COND_CAN_MELEE_ATTACK1 = 23
COND_CAN_MELEE_ATTACK2 = 24
COND_CAN_RANGE_ATTACK1 = 21
COND_CAN_RANGE_ATTACK2 = 22
COND_ENEMY_DEAD = 30
COND_ENEMY_FACING_ME = 28
COND_ENEMY_OCCLUDED = 13
COND_ENEMY_TOO_FAR = 27
COND_ENEMY_UNREACHABLE = 31
COND_ENEMY_WENT_NULL = 12
COND_FLOATING_OFF_GROUND = 61
COND_GIVE_WAY = 48
COND_HAVE_ENEMY_LOS = 15
COND_HAVE_TARGET_LOS = 16
COND_HEALTH_ITEM_AVAILABLE = 47
COND_HEAR_BUGBAIT = 52
COND_HEAR_BULLET_IMPACT = 56
COND_HEAR_COMBAT = 53
COND_HEAR_DANGER = 50
COND_HEAR_MOVE_AWAY = 58
COND_HEAR_PHYSICS_DANGER = 57
COND_HEAR_PLAYER = 55
COND_HEAR_SPOOKY = 59
COND_HEAR_THUMPER = 51
COND_HEAR_WORLD = 54
COND_HEAVY_DAMAGE = 18
COND_IDLE_INTERRUPT = 2
COND_IN_PVS = 1
COND_LIGHT_DAMAGE = 17
COND_LOST_ENEMY = 11
COND_LOST_PLAYER = 33
COND_LOW_PRIMARY_AMMO = 3
COND_MOBBED_BY_ENEMIES = 62
COND_NEW_ENEMY = 26
COND_NO_CUSTOM_INTERRUPTS = 70
COND_NO_HEAR_DANGER = 60
COND_NO_PRIMARY_AMMO = 4
COND_NO_SECONDARY_AMMO = 5
COND_NO_WEAPON = 6
COND_NONE = 0
COND_NOT_FACING_ATTACK = 40
COND_NPC_FREEZE = 67
COND_NPC_UNFREEZE = 68
COND_PHYSICS_DAMAGE = 19
COND_PLAYER_ADDED_TO_SQUAD = 64
COND_PLAYER_PUSHING = 66
COND_PLAYER_REMOVED_FROM_SQUAD = 65
COND_PROVOKED = 25
COND_RECEIVED_ORDERS = 63
COND_REPEATED_DAMAGE = 20
COND_SCHEDULE_DONE = 36
COND_SEE_DISLIKE = 9
COND_SEE_ENEMY = 10
COND_SEE_FEAR = 8
COND_SEE_HATE = 7
COND_SEE_NEMESIS = 34
COND_SEE_PLAYER = 32
COND_SMELL = 37
COND_TALKER_RESPOND_TO_QUESTION = 69
COND_TARGET_OCCLUDED = 14
COND_TASK_FAILED = 35
COND_TOO_CLOSE_TO_ATTACK = 38
COND_TOO_FAR_TO_ATTACK = 39
COND_WAY_CLEAR = 49
COND_WEAPON_BLOCKED_BY_FRIEND = 42
COND_WEAPON_HAS_LOS = 41
COND_WEAPON_PLAYER_IN_SPREAD = 43
COND_WEAPON_PLAYER_NEAR_TARGET = 44
COND_WEAPON_SIGHT_OCCLUDED = 45
---------------------------------------------------------------------------------------------------------------------------------------------
if SERVER then
	util.AddNetworkString("vj_music_run")
	
	-- Initialize AI schedule & task system
	require("vj_ai_schedule")
	local orgFunc = vj_ai_schedule.New
	function vj_ai_schedule.New(name)
		local actualFunc = orgFunc(name)
		actualFunc.Name = name
		return actualFunc
	end
	
	-- Initialize AI Nodegraph system
	require("vj_ai_nodegraph")
	timer.Simple(1, function() -- To make sure world is initialized otherwise things like traces will return nil because worldspawn doesn't exist
		vj_ai_nodegraph = vj_ai_nodegraph.New()
		-- If it failed to read the nodegraph, wait and try again in case nodegraph file hasn't generated yet
		if vj_ai_nodegraph:GetNodegraph().Version == -1 then
			print("VJ Base AI Nodegraph: Nodegraph file couldn't be loaded, attempting again...")
			timer.Simple(4, function()
				print("VJ Base AI Nodegraph: Running second read attempt...")
				vj_ai_nodegraph.Data = vj_ai_nodegraph:ReadNodegraph()
				
				if vj_ai_nodegraph:GetNodegraph().Version == -1 then
					print("VJ Base AI Nodegraph: Second read attempt has also failed.")
				else
					print("VJ Base AI Nodegraph: Second read attempt successfully worked!")
				end
			end)
		end
	end)
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
function VJ_PICKRANDOMTABLE(tbl) VJ_PICK(tbl) end -- !!!!!!!!!!!!!! DO NOT USE THIS FUNCTION !!!!!!!!!!!!!! [Backwards Compatibility!]
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
	for _,v in ipairs(ents.FindInSphere(pos, dist)) do
		if ((allEntities == true) or (allEntities == false && (v:IsNPC() or v:IsPlayer()))) && (dir:Dot((v:GetPos() - pos):GetNormalized()) > cosDeg) then
			foundEnts[#foundEnts + 1] = v
		end
	end
	return foundEnts
end
---------------------------------------------------------------------------------------------------------------------------------------------
function VJ_CreateSound(ent, sdFile, sdLevel, sdPitch, customFunc)
	if not sdFile then return end
	if istable(sdFile) then
		if #sdFile < 1 then return end -- If the table is empty then end it
		sdFile = sdFile[math_random(1, #sdFile)]
	end
	if ent.OnCreateSound then -- Will allow people to alter sounds before they are played
		sdFile = ent:OnCreateSound(sdFile)
	end
	local sdID = CreateSound(ent, sdFile)
	sdID:SetSoundLevel(sdLevel or 75)
	if (customFunc) then customFunc(sdID) end
	sdID:PlayEx(1, sdPitch or 100)
	ent.LastPlayedVJSound = sdID
	if ent.OnPlayCreateSound then
		ent:OnPlayCreateSound(sdID, sdFile)
	end
	return sdID
end
---------------------------------------------------------------------------------------------------------------------------------------------
function VJ_EmitSound(ent, sdFile, sdLevel, sdPitch, sdVolume, sdChannel)
	if not sdFile then return end
	if istable(sdFile) then
		if #sdFile < 1 then return end -- If the table is empty then end it
		sdFile = sdFile[math_random(1, #sdFile)]
	end
	if ent.OnCreateSound then -- Will allow people to alter sounds before they are played
		sdFile = ent:OnCreateSound(sdFile)
	end
	ent:EmitSound(sdFile, sdLevel, sdPitch, sdVolume, sdChannel)
	ent.LastPlayedVJSound = sdFile
	if ent.OnPlayEmitSound then ent:OnPlayEmitSound(sdFile) end
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
			return false
		end
	elseif isstring(anim) then -- Sequence
		if string_find(anim, "vjseq_") then anim = string_Replace(anim, "vjseq_", "") end
		if ent:LookupSequence(anim) == -1 then return false end
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
--[[---------------------------------------------------------
	Causes a Combine turret to self destruct, useful to run this in attacks to make sure turrets can be destroyed
		- selfEnt = The entity that is destroying the turret
		- ent = The turret to destroy (If it's NOT a turret, it will return false)
	Returns
		- false, turret was NOT destroyed
		- true, turret was destroyed
-----------------------------------------------------------]]
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
	Makes the entity utilize its ragdoll for collisions rather than the normal box collision.
		Note: Collision bounds should still be set, otherwise certain position functions will not work correctly!
		- ent = The entity to apply the ragdoll collision
		- mdl = The model to override and use for the collision. By default it should be nil unless you're trying stuff
	Returns
		- false, bone follower as NOT created
		- Entity, the bone follower entity that was created
-----------------------------------------------------------]]
local boneFollowerClass = "phys_bone_follower"
--
function VJ_CreateBoneFollower(ent, mdl)
	if !IsValid(ent) then return false end
	local ragdoll = mdl or ent:GetModel()
	if !util.IsValidRagdoll(ragdoll) then return false end

	ent:SetCustomCollisionCheck(true) -- Required for the "ShouldCollide" hook!
	
	local boneFollower = ents.Create("obj_vj_bonefollower")
	boneFollower:SetModel(ragdoll)
	boneFollower:SetPos(ent:GetPos())
	boneFollower:SetAngles(ent:GetAngles())
	boneFollower:SetParent(ent)
	boneFollower:AddEffects(EF_BONEMERGE)
	boneFollower:Spawn()
	boneFollower:SetOwner(ent)
	ent:DeleteOnRemove(boneFollower)
	ent.VJ_BoneFollowerEntity = boneFollower
	
	hook.Add("ShouldCollide", boneFollower, function(self, ent1, ent2)
		if (ent1 == ent && ent2:GetClass() == boneFollowerClass) or (ent2 == ent && ent1:GetClass() == boneFollowerClass) then
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
local Entity_MetaTable = FindMetaTable("Entity")
local NPC_MetaTable = FindMetaTable("NPC")
//local Player_MetaTable = FindMetaTable("Player")
---------------------------------------------------------------------------------------------------------------------------------------------
function NPC_MetaTable:VJ_Controller_InitialMessage(ply)
	if !IsValid(ply) then return end
	ply:ChatPrint("#vjbase.print.npccontroller.entrance")
	if self.IsVJBaseSNPC == true then
		self:Controller_IntMsg(ply, controlEnt)
	end
end
/* Disabled for now until further testing (especially performance-wise)
---------------------------------------------------------------------------------------------------------------------------------------------
local AddEntityRelationship = NPC_MetaTable.AddEntityRelationship
function NPC_MetaTable:AddEntityRelationship(...)
	local args = {...}
	local ent = args[1]
	local disp = args[2]

	self.StoredDispositions = self.StoredDispositions or {}
	self.StoredDispositions[ent] = disp
	return AddEntityRelationship(self,...)
end
---------------------------------------------------------------------------------------------------------------------------------------------
local Disposition = NPC_MetaTable.Disposition
function NPC_MetaTable:Disposition(...)
	local args = {...}
	local ent = args[1]

	self.StoredDispositions = self.StoredDispositions or {}
	if IsValid(ent) && self:GetModel() == ent:GetModel() then
		return self.StoredDispositions[ent] or D_ER
	end
	return Disposition(self,...)
end
*/
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
--[[---------------------------------------------------------
	Uses the given number to return a scaled number that accounts for the selected difficulty
		- int = The number to scale
	Returns
		- number, the scaled number
-----------------------------------------------------------]]
function NPC_MetaTable:VJ_GetDifficultyValue(int)
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
	return int -- Normal
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Tags ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
-- Variables that are used by VJ Base as tags --
[Variable]							[Description]
VJ_IsBeingControlled				NPC that is being controlled by the VJ NPC Controller
VJ_IsBeingControlled_Tool			NPC that is being controlled by the VJ NPC Mover Tool
VJ_AddEntityToSNPCAttackList		Entity that should be attacked by Creature NPCs if it's in the way
VJ_IsDetectableDanger				Entity that should be detected as danger by human NPCs
VJ_IsDetectableGrenade				Entity that should be detected as a grenade danger by human NPCs
VJ_IsPickupableDanger				Entity that CAN be picked up by human NPCs (Ex: Grenades)
VJ_IsPickedUpDanger					Entity that is currently picked up by a human NPC and most likely throwing it away (Ex: Grenades)
VJ_LastInvestigateSd				Last time this NPC/Player has made a sound that should be investigated by enemy NPCs
VJ_LastInvestigateSdLevel			The sound level of the above variable
VJ_IsHugeMonster					NPC that is considered to be very large or a boss
*/

-- Variable:		self.VJTags
-- Access: 			self.VJTags[VJ_TAG_X]
-- Remove: 			self.VJTags[VJ_TAG_X] = nil
-- Add: 			self:VJTags_Add(VJ_TAG_X, VJ_TAG_Y, ...)

-- Enums
VJ_TAG_HEALING = 1 -- Ent is healing (either itself or by another ent)
VJ_TAG_EATING = 2 -- Ent is eating something (Ex: a corpse)
VJ_TAG_BEING_EATEN = 3 -- Ent is being eaten by something
VJ_TAG_VJ_FRIENDLY = 4 -- Friendly to VJ NPCs

VJ_TAG_SD_PLAYING_MUSIC = 10 -- Ent is playing a sound track

VJ_TAG_HEADCRAB = 20
VJ_TAG_POLICE = 21
VJ_TAG_CIVILIAN = 22
VJ_TAG_TURRET = 23
VJ_TAG_VEHICLE = 24
VJ_TAG_AIRCRAFT = 25

---------------------------------------------------------------------------------------------------------------------------------------------
function Entity_MetaTable:VJTags_Add(...)
	if !self.VJTags then self.VJTags = {} end
	//PrintTable({...})
	for _, tag in ipairs({...}) do
		self.VJTags[tag] = true
	end
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
		return ply:IsAdmin()
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
		ply.VJTags = {}
		ply.VJ_LastInvestigateSd = 0
		ply.VJ_LastInvestigateSdLevel = 0
		if !VJ_CVAR_IGNOREPLAYERS then
			local EntsTbl = ents.GetAll()
			for x = 1, #EntsTbl do
				local v = EntsTbl[x]
				if v:IsNPC() && v.IsVJBaseSNPC == true then
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
if SERVER then
	local ignoreEnts = {monster_generic=true, monster_furniture=true, npc_furniture=true, monster_gman=true, npc_grenade_frag=true, bullseye_strider_focus=true, npc_bullseye=true, npc_enemyfinder=true, hornet=true}
	local grenadeEnts = {npc_grenade_frag=true,grenade_hand=true,obj_spore=true,obj_grenade=true,obj_handgrenade=true,doom3_grenade=true,fas2_thrown_m67=true,cw_grenade_thrown=true,obj_cpt_grenade=true,cw_flash_thrown=true,ent_hl1_grenade=true}
	local grenadeThrowBackEnts = {npc_grenade_frag=true,obj_spore=true,obj_handgrenade=true,obj_cpt_grenade=true,cw_grenade_thrown=true,cw_flash_thrown=true,cw_smoke_thrown=true,ent_hl1_grenade=true}
	--
	hook.Add("OnEntityCreated", "VJ_OnEntityCreated", function(ent)
		local myClass = ent:GetClass()
		ent.VJTags = {}
		if ent:IsNPC() then
			if !ignoreEnts[myClass] then
				local isVJ = ent.IsVJBaseSNPC
				if isVJ then
					ent.NextProcessT = CurTime() + 0.15
				end
				timer.Simple(0.1, function() -- Make sure the NPC is initialized properly
					if IsValid(ent) then
						if isVJ == true && ent.CurrentPossibleEnemies == nil then ent.CurrentPossibleEnemies = {} end
						local EntsTbl = ents.GetAll()
						local count = 1
						local cvSeePlys = !VJ_CVAR_IGNOREPLAYERS
						local isPossibleEnemy = ((ent:IsNPC() && ent:Health() > 0 && (ent.Behavior != VJ_BEHAVIOR_PASSIVE_NATURE)) or (ent:IsPlayer()))
						for x = 1, #EntsTbl do
							local v = EntsTbl[x]
							if (v:IsNPC() or v:IsPlayer()) && !ignoreEnts[v:GetClass()] then
								-- Add enemies to the created entity (if it's a VJ Base SNPC)
								if isVJ == true then
									ent:EntitiesToNoCollideCode(v)
									if (v:IsNPC() && (v:GetClass() != myClass && (v.Behavior != VJ_BEHAVIOR_PASSIVE_NATURE)) && v:Health() > 0) or (v:IsPlayer() && cvSeePlys /*&& v:Alive()*/) then
										ent.CurrentPossibleEnemies[count] = v
										count = count + 1
									end
								end
								-- Add the created entity to the list of possible enemies of VJ Base SNPCs
								if isPossibleEnemy && myClass != v:GetClass() && v.IsVJBaseSNPC then
									v.CurrentPossibleEnemies[#v.CurrentPossibleEnemies+1] = ent //v.CurrentPossibleEnemies = v:DoHardEntityCheck(getall)
								end
							end
						end
					end
				end)
			end
		elseif grenadeEnts[myClass] then
			ent.VJ_IsDetectableGrenade = true
			if grenadeThrowBackEnts[myClass] then
				ent.VJ_IsPickupableDanger = true
			end
		end
		-- Old system
		/*if ent:GetClass() != "npc_grenade_frag" && ent:GetClass() != "bullseye_strider_focus" && ent:GetClass() != "npc_bullseye" && ent:GetClass() != "npc_enemyfinder" && ent:GetClass() != "hornet" then
			timer.Simple(0.15,function()
				if IsValid(ent) then
					local getall = ents.GetAll()
					for k,v in ipairs(getall) do
						if IsValid(v) && v != ent && v.IsVJBaseSNPC == true && (v.IsVJBaseSNPC_Human == true or v.IsVJBaseSNPC_Creature == true) then
							v.CurrentPossibleEnemies = v:DoHardEntityCheck(getall)
						end
					end
				end
			end)
		end*/
	end)
	
	/*
	-- Retrieving outputs from NPCs or other entities | Outputs: https://developer.valvesoftware.com/wiki/Base.fgd/Garry%27s_Mod
	local triggerLua = ents.Create("lua_run")
	triggerLua:SetName("triggerhook")
	triggerLua:Spawn()
	
	hook.Add("OnEntityCreated", "VJ_OnEntityCreated", function(ent)
		if ent:IsNPC() && ent.IsVJBaseSNPC == true then
			-- Format: <output name> <targetname>:<inputname>:<parameter>:<delay>:<max times to fire, -1 means infinite>
			self:Fire("AddOutput", "OnIgnite triggerhook:RunPassedCode:hook.Run( 'OnOutput' ):0:-1")
		end
	end)

	hook.Add("OnOutput", "OnOutput", function()
		local activator, caller = ACTIVATOR, CALLER
		print(activator, caller)
	end )
	*/
end
---------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("EntityEmitSound", "VJ_EntityEmitSound", function(data)
	local ent = data.Entity
	if IsValid(ent) then
		-- Investigate System
		if SERVER && (ent:IsPlayer() or ent:IsNPC()) && data.SoundLevel >= 75 then
			//print("---------------------------")
			//PrintTable(data)
			local quiet = (string_StartWith(data.OriginalSoundName, "player/footsteps") and (ent:IsPlayer() && (ent:Crouching() or ent:KeyDown(IN_WALK)))) or false
			if quiet != true && ent.Dead != true then
				ent.VJ_LastInvestigateSd = CurTime()
				ent.VJ_LastInvestigateSdLevel = (data.SoundLevel * data.Volume) + (((data.Volume <= 0.4) and 15) or 0)
			end
		-- Disable the built-in footstep sounds for the player footstep sound for VJ NPCs unless specified otherwise
			-- Plays only on client-side, making it useless to play material-specific
		elseif ent:IsNPC() && ent.IsVJBaseSNPC == true && (string.EndsWith(data.OriginalSoundName, "stepleft") or string.EndsWith(data.OriginalSoundName, "stepright")) then
			return ent:MatFootStepQCEvent(data)
		end
	end
end)
---------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("EntityFireBullets", "VJ_NPC_FIREBULLET", function(ent, data)
	if IsValid(ent) && ent:IsNPC() && ent.IsVJBaseSNPC == true then
		local wep = ent:GetActiveWeapon()
		local ene = ent:GetEnemy()
		local edited = false
		if IsValid(wep) && IsValid(ene) then
			if wep.IsVJBaseWeapon then
				-- Ammo counter for VJ weapons
				wep:SetClip1(wep:Clip1() - 1)
				//ent.Weapon_TimeSinceLastShot = CurTime() -- We don't want to change this here!
			else
				-- START: Bullet spawn for non-VJ weapons --
				local getmuzzle;
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
				if !getmuzzle then
					if ent:LookupBone("ValveBiped.Bip01_R_Hand") then
						data.Src = ent:GetBonePosition(ent:LookupBone("ValveBiped.Bip01_R_Hand"))
					else -- No attachment found, just use eye pos
						data.Src = ent:EyePos()
					end
				else
					data.Src = wep:GetAttachment(wep:LookupAttachment(getmuzzle)).Pos
				end
				-- END: Bullet spawn for non-VJ weapons --
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
	if IsValid(target) && IsValid(attacker) && target.IsVJBaseSNPC && attacker:IsNPC() && dmginfo:IsBulletDamage() && attacker:Disposition(target) != D_HT && (attacker:GetClass() == target:GetClass() or target:Disposition(attacker) == D_LI /*or target:Disposition(attacker) == 4*/) then
		dmginfo:SetDamage(0)
	end
end)
---------------------------------------------------------------------------------------------------------------------------------------------
local function VJ_NPCPLY_DEATH(npc, attacker, inflictor)
	if IsValid(attacker) && attacker.IsVJBaseSNPC == true then
		attacker:DoKilledEnemy(npc, attacker, inflictor)
		attacker:SetupRelationships()
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
hook.Add("PlayerCanPickupWeapon", "VJ_PLAYER_CANPICKUPWEAPON", function(ply, wep)
	if wep.IsVJBaseWeapon then
		if ply.VJ_CurPickupWithoutUse == wep:GetClass() && !ply:HasWeapon(wep:GetClass()) then
			ply.VJ_CurPickupWithoutUse = nil
			return true
		end
		//if wep.VJ_CurPickupWithoutUse then return true end
		return GetConVar("vj_npc_plypickupdropwep"):GetInt() == 1 && ply:KeyPressed(IN_USE) && ply:GetEyeTrace().Entity == wep
	end
end)
---------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("PlayerGiveSWEP", "VJ_PLAYER_GIVESWEP", function(ply, class, swep)
	//PrintTable(swep)
	//if swep.IsVJBaseWeapon == true then
		ply.VJ_CurPickupWithoutUse = class
		timer.Simple(0.1, function() if IsValid(ply) then ply.VJ_CurPickupWithoutUse = nil end end)
	//end
end)
---------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Corpse & Stink System ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if SERVER then
	VJ_Corpses = {}
	VJ_StinkyEnts = {}
	--
	local function VJ_Stink_StartThink()
		timer.Create("vj_stink_think", 0.3, 0, function()
			for k, ent in RandomPairs(VJ_StinkyEnts) do
				if IsValid(ent) then
					sdEmitHint(SOUND_CARCASS, ent:GetPos(), 400, 0.15, ent)
				else -- No longer valid, remove it from the list
					table_remove(VJ_StinkyEnts, k)
					if #VJ_StinkyEnts == 0 then -- If this is the last stinky ent then destroy the timer!
						timer.Remove("vj_stink_think")
					end
				end
			end
		end)
	end
	---------------------------------------------------------------------------------------------------------------------------------------------
	local stinkyMatTypes = {alienflesh=true, antlion=true, armorflesh=true, bloodyflesh=true, flesh=true, zombieflesh=true, player=true}
	-- Material types: https://developer.valvesoftware.com/wiki/Material_surface_properties
	--
	--[[---------------------------------------------------------
		Adds an entity to the stinky entity list and makes it produce a stink
			- ent = The entity to add to the list
			- checkMat = Should it check the entity's material type?
		Returns
			- false, Entity NOT added to stinky the list
			- true, Entity added to the stinky list
	-----------------------------------------------------------]]
	function VJ_AddStinkyEnt(ent, checkMat)
		local physObj = ent:GetPhysicsObject()
		-- Clear out all removed ents from the table
		for k, v in ipairs(VJ_StinkyEnts) do
			if !IsValid(v) then
				table_remove(VJ_StinkyEnts, k)
			end
		end
		-- Add the entity to the stinky list (if possible)
		if (!checkMat) or (IsValid(physObj) && stinkyMatTypes[physObj:GetMaterial()]) then
			VJ_StinkyEnts[#VJ_StinkyEnts + 1] = ent -- Add entity to the table
			if !timer.Exists("vj_stink_think") then VJ_Stink_StartThink() end -- Start the stinky timer if it does NOT exist
			return true
		end
		return false
	end
	---------------------------------------------------------------------------------------------------------------------------------------------
	--[[---------------------------------------------------------
		Adds an entity to the VJ corpse list (Entities here respect all VJ rules including corpse limit!)
			- ent = The entity to add to the corpse list
	-----------------------------------------------------------]]
	function VJ_AddCorpse(ent)
		-- Clear out all removed corpses from the table
		for k, v in ipairs(VJ_Corpses) do
			if !IsValid(v) then
				table_remove(VJ_Corpses, k)
			end
		end
		
		local count = #VJ_Corpses + 1
		VJ_Corpses[count] = ent
		
		-- Check if we surpassed the limit, if we did, remove the oldest corpse
		if count > GetConVar("vj_npc_globalcorpselimit"):GetInt() then
			local oldestCorpse = table_remove(VJ_Corpses, 1)
			if IsValid(oldestCorpse) then
				local fadeType = oldestCorpse.FadeCorpseType
				if fadeType then oldestCorpse:Fire(fadeType, "", 0) end -- Fade out
				timer.Simple(1, function() if IsValid(oldestCorpse) then oldestCorpse:Remove() end end) -- Make sure it's removed
			end
		end
	end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Convar Callbacks ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
cvars.AddChangeCallback("ai_ignoreplayers", function(convar_name, oldValue, newValue)
	if tonumber(newValue) == 0 then -- Turn off ignore players
		VJ_CVAR_IGNOREPLAYERS = false
		local getPlys = player.GetAll()
		local getAll = ents.GetAll()
		for x = 1, #getAll do
			local v = getAll[x]
			if v:IsNPC() && v.IsVJBaseSNPC then
				for _, ply in ipairs(getPlys) do
					v.CurrentPossibleEnemies[#v.CurrentPossibleEnemies + 1] = ply
				end
			end
		end
	else -- Turn on ignore players
		VJ_CVAR_IGNOREPLAYERS = true
		for _, v in ipairs(ents.GetAll()) do
			if v.IsVJBaseSNPC then
				if v.FollowingPlayer == true then v:FollowReset() end -- Reset the NPC's follow system if it's following a player
				//v.CurrentPossibleEnemies = v:DoHardEntityCheck(getall)
				local posEnemies = v.CurrentPossibleEnemies
				local it = 1
				while it <= #posEnemies do
					local x = posEnemies[it]
					if IsValid(x) && x:IsPlayer() then
						v:AddEntityRelationship(x, D_NU, 10) -- Make the player neutral
						if IsValid(v:GetEnemy()) && v:GetEnemy() == x then v:ResetEnemy() end -- Reset the NPC's enemy if it's a player
						table_remove(posEnemies, it) -- Remove the player from possible enemy table
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
		VJ_MUSIC_QUEUE_LIST = VJ_MUSIC_QUEUE_LIST or {}
		local ent = net.ReadEntity()
		local sdTbl = net.ReadTable()
		local sdVol = net.ReadFloat()
		local sdPlayback = net.ReadFloat()
		-- Flags: "noplay" = Forces the sound not to play as soon as this function is called
		sound.PlayFile("sound/" .. VJ_PICK(sdTbl), "noplay", function(sdChan, errorID, errorName)
			if IsValid(sdChan) then
				if #VJ_MUSIC_QUEUE_LIST <= 0 then sdChan:Play() end
				sdChan:EnableLooping(true)
				sdChan:SetVolume(sdVol)
				sdChan:SetPlaybackRate(sdPlayback)
				table.insert(VJ_MUSIC_QUEUE_LIST, {npc=ent, channel=sdChan})
			else
				print("[VJ Base Music] Error adding sound track!", errorID, errorName)
			end
		end)
		timer.Create("vj_music_think", 1, 0, function()
			//PrintTable(VJ_MUSIC_QUEUE_LIST)
			for k, v in pairs(VJ_MUSIC_QUEUE_LIST) do
				//PrintTable(v)
				if !IsValid(v.npc) then
					v.channel:Stop()
					v.channel = nil
					table_remove(VJ_MUSIC_QUEUE_LIST, k)
				end
			end
			if #VJ_MUSIC_QUEUE_LIST <= 0 then
				timer.Remove("vj_music_think")
				VJ_MUSIC_QUEUE_LIST = {}
			else
				for _,v in pairs(VJ_MUSIC_QUEUE_LIST) do
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
	require("vj_sound_track")
	vj_sound_track.Add("VJ_SpiderQueenThemeMusic","vj_dm_spidermonster/Dark Messiah - Avatar of the Spider Goddess.wav",161)
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
		- customFunc(ent) = Use this to edit the entity which is given as parameter "ent"
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
	for _, v in ipairs((isnumber(extraOptions.UseConeDegree) and VJ_FindInCone(startPos, extraOptions.UseConeDirection or attacker:GetForward(), dmgRadius, extraOptions.UseConeDegree or 90, {AllEntities=true})) or ents.FindInSphere(startPos, dmgRadius)) do
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
			elseif (ignoreInnocents == false) or (v:IsNPC() && v:Disposition(attacker) != D_LI && v:Health() > 0 && (v:GetClass() != attacker:GetClass())) or (v:IsPlayer() && !VJ_CVAR_IGNOREPLAYERS && v:Alive() && !v:IsFlagSet(FL_NOTARGET)) then
				DoDamageCode()
			-- Other types of entities
			elseif !v:IsNPC() && !v:IsPlayer() then
				DoDamageCode()
			end
		end
	end
	return hitEnts
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Tests ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
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
		local mt = table.Merge({}, debug.getmetatable(ent)) -- Create a new table to avoid overflow!
		mt.__index = __index
		debug.setmetatable(ent, mt)
	end
end)
*/

-- Version for individual NPCs (Tests show loss of performance, avoid)
/*
local metaOrg = debug.getmetatable(self)
local metaVJ = {}
local function newIndex(ent, key)
	local val = metaVJ[key]
	if val != nil then return val end
	return metaOrg.__index(ent, key)
end
function metaVJ:SetMaxLookDistance(dist)
	metaOrg.SetMaxLookDistance(self, dist)
end
local mt = table.Merge({}, metaOrg) -- Create a new table to avoid overflow!
mt.__index = newIndex
debug.setmetatable(self, mt)
*/