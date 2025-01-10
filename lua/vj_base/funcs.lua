/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
if !VJ then VJ = {} end -- If VJ isn't initialized, initialize it!

-- Localized static values
local CurTime = CurTime
local IsValid = IsValid
local CreateSound = CreateSound
local istable = istable
local isstring = isstring
local isnumber = isnumber
local tonumber = tonumber
local string_find = string.find
local string_Replace = string.Replace
local math_round = math.Round
local math_floor = math.floor
local math_clamp = math.Clamp
local bShiftL = bit.lshift
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Takes a table and returns a random value from it
		- tbl = The table to pick randomly from
	Returns
		- false, Table is empty or value is non existent
		- value, the randomly picked value from the table (Can be anything)
-----------------------------------------------------------]]
function VJ.PICK(values)
	if istable(values) then
		return values[math.random(1, #values)] or false -- "or false" = To make sure it doesn't return nil when the table is empty!
	end
	return values or false -- Not a table, so just return it
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Takes 2 values and returns a table containing them
		- a = Value 1
		- b = Value 2
	Returns
		- table, the 2 values as a table
-----------------------------------------------------------]]
function VJ.SET(a, b)
	return {a = a, b = b}
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Takes a sound and stops it, usually ones created by "CreateSound"
		- sdName = The CSoundPatch ID
-----------------------------------------------------------]]
function VJ.STOPSOUND(sdName)
	if sdName then sdName:Stop() end
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Takes a table and searches if the given value is inside it
		- tbl = The table to pick randomly from
		- val = The value to search inside the table
	Returns
		- false, Not a table or value not found in the table
		- true, Value was found in the table
-----------------------------------------------------------]]
function VJ.HasValue(tbl, val)
	if istable(tbl) then
		for x = 1, #tbl do
			if tbl[x] == val then
				return true
			end
		end
	else
		return tbl == val
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Using the given values, find entities in a cone
		- pos = Start position to search from
		- dir = Direction to search towards
		- dist = Maximum search distance from the start position
		- deg = Cone degrees, anything outside of it is not seen
		- extraOptions = Table that holds extra options to modify parts of the code
			- AllEntities = Should it detect all types of entities instead of only NPCs and Players? | DEFAULT: false
	Returns
		- table, contains all the found entities, may be empty if nothing was found
-----------------------------------------------------------]]
function VJ.FindInCone(pos, dir, dist, deg, extraOptions)
	extraOptions = extraOptions or {}
		local allEntities = extraOptions.AllEntities or false
	local foundEnts = {}
	local cosDeg = math.cos(math.rad(deg))
	for _,v in ipairs(ents.FindInSphere(pos, dist)) do
		if (allEntities or (!allEntities && (v:IsNPC() or v:IsPlayer()))) && (dir:Dot((v:GetPos() - pos):GetNormalized()) > cosDeg) then
			foundEnts[#foundEnts + 1] = v
		end
	end
	return foundEnts
end
---------------------------------------------------------------------------------------------------------------------------------------------
function VJ.RoundToMultiple(num, multiple) -- Credits to Bizzclaw for pointing me to the right direction!
	if math_round(num / multiple) == num / multiple then
		return num
	else
		return math_round(num / multiple) * multiple
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function VJ.Color2Byte(color)
	return bShiftL(math_floor(color.r * 7 / 255), 5) + bShiftL(math_floor(color.g * 7 / 255), 2) + math_floor(color.b * 3 / 255)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function VJ.CreateSound(ent, sdFile, sdLevel, sdPitch, customFunc)
	if !sdFile then return end
	if istable(sdFile) then
		if #sdFile < 1 then return end -- If the table is empty then end it
		sdFile = sdFile[math.random(1, #sdFile)]
	end
	local funcCustom = ent.OnPlaySound; if funcCustom then sdFile = funcCustom(ent, sdFile) end -- Will allow people to alter sounds before they are played
	local sdID = CreateSound(ent, sdFile, VJ_RecipientFilter)
	sdID:SetSoundLevel(sdLevel or 75)
	if (customFunc) then customFunc(sdID) end
	sdID:PlayEx(1, sdPitch or 100)
	ent.LastPlayedVJSound = sdID
	local funcCustom2 = ent.OnPlayCreateSound; if funcCustom2 then funcCustom2(ent, sdID, sdFile) end
	return sdID
end
---------------------------------------------------------------------------------------------------------------------------------------------
function VJ.EmitSound(ent, sdFile, sdLevel, sdPitch, sdVolume, sdChannel)
	if !sdFile then return end
	if istable(sdFile) then
		if #sdFile < 1 then return end -- If the table is empty then end it
		sdFile = sdFile[math.random(1, #sdFile)]
	end
	local funcCustom = ent.OnPlaySound; if funcCustom then sdFile = funcCustom(ent, sdFile) end -- Will allow people to alter sounds before they are played
	ent:EmitSound(sdFile, sdLevel, sdPitch, sdVolume, sdChannel, 0, 0, VJ_RecipientFilter)
	ent.LastPlayedVJSound = sdFile
	local funcCustom2 = ent.OnPlayEmitSound; if funcCustom2 then funcCustom2(ent, sdFile) end
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Takes the given animation and checks if it exists inside the given entity's model
		- ent = Entity to use
		- anim = The animation to search for
	Returns
		- false, Given animation couldn't be found
		- true, Animation was exists and was found inside the entity's model
-----------------------------------------------------------]]
function VJ.AnimExists(ent, anim)
	if !anim or isbool(anim) then return false end
	
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
--[[---------------------------------------------------------
	Takes the given animation and attempts to find its duration
		- ent = Entity to use
		- anim = The animation to find its duration
	Returns
		- 0, Animation was invalid or no duration could be found
		- number, Animation duration
-----------------------------------------------------------]]
function VJ.AnimDuration(ent, anim)
	if VJ.AnimExists(ent, anim) == false then return 0 end -- Invalid animation
	
	if isnumber(anim) then -- Activity
		return ent:SequenceDuration(ent:SelectWeightedSequence(anim))
	elseif isstring(anim) then -- Sequence / Gesture
		-- Get rid of the gesture prefix
		if string_find(anim, "vjges_") then
			anim = string_Replace(anim, "vjges_", "")
			if ent:LookupSequence(anim) == -1 then
				return ent:SequenceDuration(ent:SelectWeightedSequence(tonumber(anim)))
			end
		end
		if string_find(anim, "vjseq_") then
			anim = string_Replace(anim, "vjseq_", "")
		end
		return ent:SequenceDuration(ent:LookupSequence(anim))
	end
	return 0
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Takes the given value and attempts to convert it to an activity (ACT_)
		- ent = Entity to use
		- anim = The animation to convert
	Returns
		- false, Given animation couldn't be converted
		- number, converted activity (ACT_)
-----------------------------------------------------------]]
function VJ.SequenceToActivity(ent, anim)
	if isnumber(anim) then -- Already an activity, just return!
		return anim
	elseif isstring(anim) then -- Sequence
		local result = ent:GetSequenceActivity(ent:LookupSequence(anim))
		if result == nil or result == -1 then
			return false
		else
			return result
		end
	end
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Takes the given value or table and checks if it's the current animation
		- ent = Entity to use
		- anim = The value or table to check for
	Returns
		- false, Given animation is not the current animation
		- true, Given animation is the current animation
-----------------------------------------------------------]]
function VJ.IsCurrentAnimation(ent, anim)
	if istable(anim) then
		local curSeq = ent:GetSequence()
		for _, v in ipairs(anim) do
			if isnumber(v) then
				if v != -1 && ent:SelectWeightedSequence(v) == curSeq then -- Translate activity to sequence
					return true
				end
			elseif ent:LookupSequence(v) == curSeq then
				return true
			end
		end
	else
		if isnumber(anim) then -- For numbers do an activity check because an activity can have more than 1 sequence!
			return anim != -1 && anim == ent:GetActivity()
		end
		return ent:LookupSequence(anim) == ent:GetSequence()
	end
	return false
end
--------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Checks if the given entity is a prop
		- ent = The entity to check if it's a prop
	Returns
		- Boolean, true = entity is considered a prop
-----------------------------------------------------------]]
local props = {prop_physics=true, prop_physics_multiplayer=true, prop_physics_respawnable=true}
--
function VJ.IsProp(ent)
	return props[ent:GetClass()] == true -- Without == check, it would return nil on false
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Retrieves all the pose the parameters of the entity and returns it.
		- ent = The entity to retrieve pose parameters
		- prt = Should it print the pose parameters? | DEFAULT: true
	Returns
		- table of all the pose parameters
-----------------------------------------------------------]]
function VJ.GetPoseParameters(ent, prt)
	local result = {}
	for i = 0, ent:GetNumPoseParameters() - 1 do
		if prt != false then
			local min, max = ent:GetPoseParameterRange(i)
			print(ent:GetPoseParameterName(i)..' '..min.." / "..max)
		end
		table.insert(result, ent:GetPoseParameterName(i))
	end
	return result
end
--------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Checks if the given entity is alive (not dead)
		- ent = The entity to check if alive
	Returns
		- Boolean, true = entity is alive
-----------------------------------------------------------]]
function VJ.IsAlive(ent)
	return ent:Health() > 0 && !ent.Dead
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Calculates and returns a trajectory velocity that can be used to throw projectiles, props, etc.
		- self = Entity that's throwing the object
		- target = Target that self is trying to throw at | DEFAULT: NULL | This isn't required especially when NOT using prediction
		- algorithmType = Type of algorithm to use for the calculation
			-- "Line" = Creates a straight line with the given speed
				--- Ignores gravity		|   Ignores "ApplyDist" option
			-- "Curve" = Creates a curved velocity with the given arc strength, prefer this over the other curve algorithms
				--- Obeys gravity		|   Obeys "ApplyDist" option
			-- "CurveAntlion" = Alternative to "Curve", it uses the Antlion Worker trajectory algorithm from Episode 2
				--- Obeys gravity    	|   Ignores "ApplyDist" option
			-- "CurveOld" = Much older version of "Curve" made prior to VJ Base revamp | Recommended to NOT use!
				--- Semi-Obeys gravity  |   Ignores "ApplyDist" option
		- startPos = Position that the velocity starts from
		- targetPos = Position to land the object | DEFAULT: 1
			-- Vector = Uses this position as the landing position
			-- Number = Let the base calculate with prediction where the number is the prediction rate
				--- 0 : No prediction   |   0 < to > 1 : Closer to target   |   1 : Perfect prediction   |   1 < : Ahead of the prediction (will be very ahead/inaccurate)
				--- EX: Adjust land position to the head of the target if its body is covered + predict where the target will be if prediction is enabled
				--- REQUIRED: Valid target entity
				--- WARNING: Prediction is only for VJ NPCs, anything else is set to the target's center position
				--- WARNING: Prediction will mess up when using a curved algorithm with a large arc
		- strength = How strong or fast the velocity should be (Depends on the algorithm type)
			-- For "Line" it's the speed, for all others it's the arc of the curve
		- extraOptions = Table that holds extra options to modify parts of the code
			- ApplyDist = Instead of only applying the given strength to the arc, it will also account for the distance between the start and target positions | DEFAULT: true
				-- NOTE: If the base detects that the projectile can't reach, it will override this option to true! | EX: Strength is set to very low number and enemy is very far away
	Returns
		- Vector, the calculated velocity
-----------------------------------------------------------]]
function VJ.CalculateTrajectory(self, target, algorithmType, startPos, targetPos, strength, extraOptions)
	extraOptions = extraOptions or {}
	local predict = false
	local predictProjSpeed = 1
	if isnumber(targetPos) then
		if IsValid(target) then
			if self.IsVJBaseSNPC then -- Only VJ NPCs can adjust based on target's visibility and only they can predict!
				if targetPos > 0 then -- Set to predict, so save the prediction rate!
					predict = targetPos
				end
				targetPos = self:GetAimPosition(target, startPos)
			else -- Non-VJ entities will just get the target's center
				targetPos = target:GetPos() + target:OBBCenter()
			end
		else -- Fail safe in case we are given a number as the target position with no valid target
			targetPos = self:GetPos() + self:GetForward() * 200
		end
	end
	local result; -- Final result that will be used as the velocity

	if algorithmType == "Line" then -- Suggested to disable gravity!
		result = ((targetPos - startPos):GetNormal()) * strength
		predictProjSpeed = result:Length() * 0.8
	elseif algorithmType == "Curve" then
		local gravity = math.abs(physenv.GetGravity().z)
		local dist = startPos:Distance(targetPos)
		local midPoint = startPos + (targetPos - startPos) * 0.5 -- The halfway point of the start and end positions, basically the RIGHT side of a triangle
		local applyDist = extraOptions.ApplyDist; if applyDist == nil then applyDist = true end
		-- Adjust the Z-axis to account for the following:
			-- 1. How high/low the end position is
			-- 2. Apply the strength to adjust the size of the arc
			-- 3. Adjust the strength's arc if "ApplyDist" is enabled to make it arc less when closer
			-- 4. Apply further adjustments if base detects that it won't hit the target (Usually happens when target is too far for the given arc strength)
		local verticalAdjustment = math.abs(startPos.z - targetPos.z) + (applyDist and math.Clamp(strength, -dist, dist) or strength) //+ math.Clamp(strength, -dist, dist / 4) //midPoint:Length() * (strength / (startPos:Distance(targetPos)))
		if dist > (strength * 9.5) && dist > 2000 then -- Bulletin #4 above
			if self.VJ_DEBUG then print(self, "CalculateTrajectory: Target is too far for the given arc strength, applying adjustment to avoid failure!") end
			verticalAdjustment = verticalAdjustment + (dist * 0.1) //((dist * 0.001) * 30) + strength^(dist * 0.0003)
		end
		
		-- Handle situations where it might hit a ceiling
		local tr = util.TraceLine({
			start = startPos,
			endpos = midPoint + Vector(0, 0, verticalAdjustment),
			mask = MASK_SOLID_BRUSHONLY,
		})
		//midPoint = tr.HitPos
		if tr.Fraction != 1 then
			if self.VJ_DEBUG then print(self, "CalculateTrajectory: Blocked by ceiling, decreasing arc to avoid hitting it!"); debugoverlay.Text(tr.HitPos, "Ceiling tr.HitPos", 5, false) end
			midPoint = tr.HitPos - self:GetUp() * 25
		else
			midPoint.z = midPoint.z + verticalAdjustment
		end
		
		-- Failed to find enough trajectory space | EX: There is an object between the midPoint and targetPos
		if (midPoint.z < startPos.z || midPoint.z < targetPos.z) then
			if self.VJ_DEBUG then print(self, "CalculateTrajectory: Not enough space, applying fail case velocity!") end
			midPoint = targetPos -- Fail case, will still fail in many situations but is better than nothing!
		end
		
		-- How high should the projectile travel to reach the apex
		local distance1 = midPoint.z - startPos.z
		local distance2 = midPoint.z - targetPos.z

		-- How long will it take for the projectile to travel this distance
		local time1 = math.sqrt(distance1 / (0.5 * gravity))
		local time2 = math.sqrt(distance2 / (0.5 * gravity))
		
		result = (targetPos - startPos) / (time1 + time2) -- How hard to throw sideways to get there in time
		result.z = gravity * time1 -- How hard upwards to reach the apex at the right time
		predictProjSpeed = result:Length() * 0.9
		
		if self.VJ_DEBUG then
			if time1 < 0.1 then print(self, "CalculateTrajectory: Probably failed because the trajectory time is below 0.1!") end
			local apexPos = startPos + (result * time1) -- The peak of the velocity
			apexPos.z = midPoint.z
			debugoverlay.Cross(apexPos, 8, 5, Color(255, 0, 0))
			debugoverlay.Text(midPoint, "Apex", 5, false)
			debugoverlay.Cross(midPoint, 8, 5, Color(0, 255, 0))
			debugoverlay.Text(midPoint, "midPoint", 5, false)
		end
	elseif algorithmType == "CurveOld" then
		-- Oknoutyoun: https://gamedev.stackexchange.com/questions/53552/how-can-i-find-a-projectiles-launch-angle
		-- Negar: https://wikimedia.org/api/rest_v1/media/math/render/svg/4db61cb4c3140b763d9480e51f90050967288397
		result = Vector(targetPos.x - startPos.x, targetPos.y - startPos.y, 0) -- Verchnagan deghe
		local pos_x = result:Length()
		local pos_y = targetPos.z - startPos.z
		local grav = physenv.GetGravity():Length()
		local sqrtcalc1 = (strength * strength * strength * strength)
		local sqrtcalc2 = grav * ((grav * (pos_x * pos_x)) + (2 * pos_y * (strength * strength)))
		local calcsum = sqrtcalc1 - sqrtcalc2 -- Yergou tevere aveltsour
		if calcsum < 0 then -- Yete teve nevas e, ooremen sharnage
			calcsum = math.abs(calcsum)
		end
		local angsqrt =  math.sqrt(calcsum)
		local angpos = math.atan(((strength * strength) + angsqrt) / (grav * pos_x))
		local angneg = math.atan(((strength * strength) - angsqrt) / (grav * pos_x))
		local pitch = 1
		if angpos > angneg then
			pitch = angneg -- Yete asiga angpos enes ne, aveli ver gele
		else
			pitch = angpos
		end
		result.z = math.tan(pitch) * pos_x
		result = result:GetNormal() * strength
		predictProjSpeed = strength
	elseif algorithmType == "CurveAntlion" then
		local gravity = math.abs(physenv.GetGravity().z)
		result = targetPos - startPos
		local time = result:Length() / strength -- Throw at a constant time
		result = result * (1.0 / time)
		result.z = result.z + (gravity * time * 0.5) -- Adjust upward toss to compensate for gravity loss
		predictProjSpeed = strength
	end
	
	-- Return the result and redo it with prediction if needed!
	if predict then
		//print(predictProjSpeed, startPos:Distance(target:GetPos()))
		return VJ.CalculateTrajectory(self, target, algorithmType, startPos, self:GetAimPosition(target, startPos, predict, predictProjSpeed), strength, extraOptions)
	else
		return result
	end
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
function VJ.ApplySpeedEffect(ent, speed, setTime)
    ent.VJ_SpeedEffectT = ent.VJ_SpeedEffectT or 0
    if ent.VJ_SpeedEffectT < CurTime() then
        ent.VJ_SpeedEffectT = CurTime() + (setTime or 1)
		local orgPlayback = ent.IsVJBaseSNPC and ent.TruePlaybackRate or ent:GetPlaybackRate()
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
				ent:SetPlaybackRate(orgPlayback)
				if ent:IsPlayer() then
					ent:SetWalkSpeed(plyOrgWalk)
					ent:SetRunSpeed(plyOrgRun)
				end
                return
            end
			ent:SetPlaybackRate(speed)
            if ent:IsPlayer() then
                ent:SetWalkSpeed(plyOrgWalk * speed)
                ent:SetRunSpeed(plyOrgRun * speed)
            end
        end)
	-- We already have a speed effect, so edit the existing one instead
	else
		ent.VJ_SpeedEffectT = CurTime() + (setTime or 1)
    end
end
--------------------------------------------------------------------------------------------------------------------------------------------
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
local specialDmgEnts = {npc_strider=true, npc_combinedropship=true, npc_combinegunship=true, npc_helicopter=true} -- Entities that need special code to be damaged
--
function VJ.ApplyRadiusDamage(attacker, inflictor, startPos, dmgRadius, dmgMax, dmgType, ignoreInnocents, realisticRadius, extraOptions, customFunc)
	startPos = startPos or attacker:GetPos()
	dmgRadius = dmgRadius or 150
	dmgMax = dmgMax or 15
	extraOptions = extraOptions or {}
		local disableVisibilityCheck = extraOptions.DisableVisibilityCheck or false
		local baseForce = extraOptions.Force or false
	local dmgFinal = dmgMax
	local hitEnts = {}
	for _, v in ipairs((isnumber(extraOptions.UseConeDegree) and VJ.FindInCone(startPos, extraOptions.UseConeDirection or attacker:GetForward(), dmgRadius, extraOptions.UseConeDegree or 90, {AllEntities=true})) or ents.FindInSphere(startPos, dmgRadius)) do
		if (v.IsVJBaseBullseye && v.VJ_IsBeingControlled) or v.VJ_IsControllingNPC then continue end -- Don't damage bulleyes used by the NPC controller OR entities that are controlling others (Usually players)
		local nearestPos = v:NearestPoint(startPos) -- From the enemy position to the given position
		if realisticRadius != false then -- Decrease damage from the nearest point all the way to the enemy point then clamp it!
			dmgFinal = math_clamp(dmgFinal * ((dmgRadius - startPos:Distance(nearestPos)) + 150) / dmgRadius, dmgMax / 2, dmgFinal)
		end
		
		if disableVisibilityCheck or (!disableVisibilityCheck && (v:VisibleVec(startPos) or v:Visible(attacker))) then
			local function DealDamage()
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
						if VJ.IsProp(v) or v:GetClass() == "prop_ragdoll" then
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
					VJ.DamageSpecialEnts(attacker, v, dmgInfo)
					v:TakeDamageInfo(dmgInfo)
				end
			end
			-- Self
			if v:EntIndex() == attacker:EntIndex() then
				if extraOptions.DamageAttacker then DealDamage() end -- If it can't self hit, then skip
			-- Other entities
			elseif (ignoreInnocents == false) or (!v:IsNPC() && !v:IsPlayer()) or (v:IsNPC() && v:GetClass() != attacker:GetClass() && v:Health() > 0 && (attacker:IsPlayer() or (attacker:IsNPC() && attacker:Disposition(v) != D_LI))) or (v:IsPlayer() && v:Alive() && (attacker:IsPlayer() or (!VJ_CVAR_IGNOREPLAYERS && !v:IsFlagSet(FL_NOTARGET)))) then
				DealDamage()
			end
		end
	end
	return hitEnts
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Helper function that causes unique entities to receive damage, such Combine turrets
		- attacker = The entity that is causing the damage
		- ent = The entity to damage
		- dmgInfo = Damage information
-----------------------------------------------------------]]
function VJ.DamageSpecialEnts(attacker, ent, dmgInfo)
	if ent:GetClass() == "npc_turret_floor" then
		ent:Fire("selfdestruct")
		ent.Dead = true
		//ent:SetHealth(0) -- Causes the turret to randomly no collide through everything, AVOID!
		local phys = ent:GetPhysicsObject()
		if IsValid(phys) then
			phys:EnableMotion(true)
			phys:ApplyForceCenter(attacker:GetForward()*1000)
		end
	end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ ///// OBSOLETE CONTENT | Do not to use! \\\\\ ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Makes the entity utilize its ragdoll for collisions rather than the normal box collision.
		Note: Collision bounds should still be set, otherwise certain position functions will not work correctly!
		- ent = The entity to apply the ragdoll collision
		- mdl = The model to override and use for the collision. By default it should be nil unless you're trying stuff
	Returns
		- false, bone follower as NOT created
		- Entity, the bone follower entity that was created
-----------------------------------------------------------]]
/*local boneFollowerClass = "phys_bone_follower"
--
function VJ.CreateBoneFollower(ent, mdl)
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

-- obj_vj_bonefollower
AddCSLuaFile()
ENT.Base = "base_anim"
ENT.Type = "anim"
ENT.Spawnable = false
ENT.AdminOnly = false
ENT.AutomaticFrameAdvance = true
ENT.IsVJBaseBoneFollower = true
--
if CLIENT then
	function ENT:Initialize()
		local ent = self:GetParent()
		if IsValid(ent) then -- For some reason doesn't work?
			ent:SetIK(false) -- Until we can find a way to prevent IK chains from detecting the bone followers, we will have to disable IK on the parent.
		end
	end
end
--
if !SERVER then return end
--
function ENT:Initialize()
    self:SetSolid(SOLID_NONE)
    self:AddFlags(FL_NOTARGET)
    self:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
    self:SetCustomCollisionCheck(true)
    self:AddEFlags(EFL_DONTBLOCKLOS)

    self.BoneFollowers = {}

    hook.Add("OnEntityCreated", self, function(self,ent)
        if ent:GetClass() == "phys_bone_follower" then
            table.insert(self.BoneFollowers, ent)
        end
    end)
    hook.Add("PhysgunPickup", self, function(self,ply,ent)
        if ent:GetClass() == "phys_bone_follower" or ent == self then
            return false
        end
    end)

    timer.Simple(0.1, function()
        if IsValid(self) then
            self:CreateBoneFollowers()
            self.SetToRemove = true
            for _, v in ipairs(self.BoneFollowers) do
                v.IsVJBaseBoneFollower = true
                v:SetCollisionGroup(COLLISION_GROUP_NONE)
                v:SetCustomCollisionCheck(true)
                v:AddEFlags(EFL_DONTBLOCKLOS)
                self:DeleteOnRemove(v)
            end
        end
    end)
end
--
function ENT:OnTakeDamage(dmginfo)
	-- Make its owner entity (usually an NPC) take damage as if it was its own body
    local owner = self:GetOwner()
    if IsValid(owner) then
        owner:TakeDamageInfo(dmginfo)
    end
end
--
function ENT:Think()
    self:UpdateBoneFollowers()
    self:NextThink(CurTime() + (0.069696968793869 + FrameTime()))
    if self.SetToRemove then
        self.SetToRemove = false
        hook.Remove("OnEntityCreated", self)
    end
    return true
end
--
function ENT:OnRemove() self:DestroyBoneFollowers() end
*/