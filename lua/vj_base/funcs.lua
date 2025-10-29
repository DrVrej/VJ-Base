/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
local CurTime = CurTime
local IsValid = IsValid
local CreateSound = CreateSound
local istable = istable
local isstring = isstring
local isnumber = isnumber
local tonumber = tonumber
local string_find = string.find
local string_gsub = string.gsub
local math_round = math.Round
local math_floor = math.floor
local math_min = math.min
local math_max = math.max
local math_rad = math.rad
local math_cos = math.cos
local math_sin = math.sin
local bShiftL = bit.lshift
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Takes a table and returns a random value from it | Expects the table to be sequentially indexed
		- tbl = The table to pick randomly from
	Returns
		- false, Table is empty or value is non existent
		- value, the randomly picked value from the table (Can be anything)
-----------------------------------------------------------]]
function VJ.PICK(values)
	if !values then return false end
	if istable(values) then
		return values[math.random(1, #values)] or false -- "or false" = To make sure it doesn't return nil when the table is empty!
	end
	return values -- Not a table, so just return it
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
	Takes a table and searches if the given value is inside it
		- tbl = The table to pick randomly from
		- val = The value to search inside the table
	Returns
		- boolean, whether or not it found the value
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
	Takes a sound and stops it, usually ones created by "CreateSound"
		- sdName = The CSoundPatch ID
-----------------------------------------------------------]]
function VJ.STOPSOUND(sdName)
	if sdName then sdName:Stop() end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function VJ.CreateSound(ent, sdFile, sdLevel, sdPitch, customFunc)
	if !sdFile then return end
	if istable(sdFile) then
		sdFile = sdFile[math.random(1, #sdFile)]
		if !sdFile then return end -- If the table is empty then end it
	end
	local funcCustom = ent.OnPlaySound; if funcCustom then sdFile = funcCustom(ent, sdFile) end -- Will allow people to alter sounds before they are played
	local sdID = CreateSound(ent, sdFile, VJ_RecipientFilter)
	sdID:SetSoundLevel(sdLevel or 75)
	if (customFunc) then customFunc(sdID) end
	sdID:PlayEx(1, sdPitch or 100)
	local funcCustom2 = ent.OnCreateSound; if funcCustom2 then funcCustom2(ent, sdID, sdFile) end
	return sdID
end
---------------------------------------------------------------------------------------------------------------------------------------------
function VJ.EmitSound(ent, sdFile, sdLevel, sdPitch, sdVolume, sdChannel)
	if !sdFile then return end
	if istable(sdFile) then
		sdFile = sdFile[math.random(1, #sdFile)]
		if !sdFile then return end -- If the table is empty then end it
	end
	local funcCustom = ent.OnPlaySound; if funcCustom then sdFile = funcCustom(ent, sdFile) end -- Will allow people to alter sounds before they are played
	ent:EmitSound(sdFile, sdLevel, sdPitch, sdVolume, sdChannel, 0, 0, VJ_RecipientFilter)
	local funcCustom2 = ent.OnEmitSound; if funcCustom2 then funcCustom2(ent, sdFile) end
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Returns the movement velocity of various different entities
	Returns
		- Vector, the best movement velocity found
-----------------------------------------------------------]]
function VJ.GetMoveVelocity(ent)
	-- NPCs
	if ent:IsNPC() then
		-- Ground nav uses walk frames based move velocity, while all other nav types use pure velocity
		if ent:GetNavType() == NAV_GROUND then
			return ent:GetMoveVelocity()
		end
	-- Players
	elseif ent:IsPlayer() then
		return ent:GetInternalVariable("m_vecSmoothedVelocity")
	end
	return ent:GetVelocity() -- If no overrides above then just return pure velocity
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Gets the forward vector that the NPC is moving towards and returns it
		- ignoreZ = Ignores the Z axis of the direction during calculations | DEFAULT = false
	Returns
		- Vector, direction the NPC is moving towards
		- false, currently NOT moving
-----------------------------------------------------------]]
function VJ.GetMoveDirection(ent, ignoreZ)
	if !ent:IsMoving() then return false end
	local entPos = ent:GetPos()
	local dir = ((ent:GetCurWaypointPos() or entPos) - entPos)
	if ignoreZ then dir.z = 0 end
	return (ent:GetAngles() - dir:Angle()):Forward()
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Finds the nearest position from the ent1 to ent2 AND from ent2 to the nearest ent1 position found previously, then returns both positions
		- ent1 = Entity 1 to find the nearest position of in respect to ent2
		- ent2 = Entity 2 to find the nearest position of in respect to ent1
		- centerEnt1 = Should the X & Y axis for the ent1 stay at its origin with ONLY the Z-axis changing? | DEFAULT: false
			- Example: Melee attacks only changing the Z-axis of the NPC to keep the attack at the same height as the target
	Returns
		1:
			- Vector, ent1's nearest position to ent2
		2:
			- Vector, ent2's nearest position to the ent1's nearest position
-----------------------------------------------------------]]
function VJ.GetNearestPositions(ent1, ent2, centerEnt1)
	local ent1NearPos = ent1:NearestPoint(ent2:GetPos() + ent2:OBBCenter())
	if centerEnt1 then
		local ent1Pos = ent1:GetPos()
		ent1NearPos.x = ent1Pos.x
		ent1NearPos.y = ent1Pos.y
	//elseif groundedZ then -- No need to have it built-in, can just be grounded after the function call
		//ent1NearPos.z = ent1Pos.z
		//ent2NearPos.z = ent1Pos.z
	end
	local ent2NearPos = ent2:NearestPoint(ent1NearPos)
	//VJ.DEBUG_TempEnt(ent1NearPos, Angle(0, 0, 0), VJ.COLOR_GREEN)
	//VJ.DEBUG_TempEnt(ent2NearPos)
	return ent1NearPos, ent2NearPos
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Finds the nearest position from the ent1 to ent2 AND from ent2 to the nearest ent1 position found previously, then returns the distance between them
		NOTE: Identical to "VJ.GetNearestPositions", this is just a convenience function
		- ent1 = Entity 1 to find the nearest position of in respect to ent2
		- ent2 = Entity 2 to find the nearest position of in respect to ent1
		- centerEnt1 = Should the X & Y axis for the ent1 stay at its origin with ONLY the Z-axis changing? | DEFAULT: false
			- Example: Melee attacks only changing the Z-axis of the NPC to keep the attack at the same height as the target
	Returns
		number, The distance from the NPC nearest position to the given NPC's nearest position
-----------------------------------------------------------]]
function VJ.GetNearestDistance(ent1, ent2, centerEnt1)
	local ent1NearPos = ent1:NearestPoint(ent2:GetPos() + ent2:OBBCenter())
	if centerEnt1 then
		local ent1Pos = ent1:GetPos()
		ent1NearPos.x = ent1Pos.x
		ent1NearPos.y = ent1Pos.y
	end
	local ent2NearPos = ent2:NearestPoint(ent1NearPos)
	//VJ.DEBUG_TempEnt(ent1NearPos, Angle(0, 0, 0), VJ.COLOR_GREEN)
	//VJ.DEBUG_TempEnt(ent2NearPos)
	return ent2NearPos:Distance(ent1NearPos)
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Runs traces around the entity based on the number of given directions
		- trType [string] = Type of trace to perform
			- "Quick" = High performance, but limited to 4 or 8 directions
			- "Radial" = Traces in a circular pattern based on "numDirections"
		- maxDist [number] = Max distance a trace can travel | DEFAULT = 200
		- requireFullDist [boolean] = If true, only traces reaching "maxDist" or beyond are included | DEFAULT = false
			- Useful for checking if a direction is obstructed
			- WARNING: Enabling this reduces performance
		- returnAsDict [boolean] = If true, returns results as a dictionary table classified by directions | DEFAULT = false
			- WARNING: Enabling this reduces performance compared to returning a flat table of positions
		- numDirections [number] = Number of directions to trace | DEFAULT = 4
		- excludeForward [boolean] = If true, it will exclude positions within the forward direction | DEFAULT = false
		- excludeBack [boolean] = If true, it will exclude positions within the backward direction | DEFAULT = false
		- excludeLeft [boolean] = If true, it will exclude positions within the left direction | DEFAULT = false
		- excludeRight [boolean] = If true, it will exclude positions within the right direction | DEFAULT = false
	Returns
		- Based on "returnAsDict"
-----------------------------------------------------------]]
function VJ.TraceDirections(ent, trType, maxDist, requireFullDist, returnAsDict, numDirections, excludeForward, excludeBack, excludeLeft, excludeRight)
    maxDist = maxDist or 200
    numDirections = numDirections or 4
    local entPos = ent:GetPos()
    local entPosZ = entPos.z
    local entPosCentered = entPos + ent:OBBCenter()
	local myForward = ent:GetForward()
    local myRight = ent:GetRight()
	local trData = {start = entPosCentered, endpos = entPosCentered, filter = ent} -- For optimization purposes
	local resultIndex = 1 -- For optimization purposes
	if trType == "Quick" then
		local result = returnAsDict and {Forward=false, Back=false, Left=false, Right=false, ForwardLeft=false, ForwardRight=false, BackLeft=false, BackRight=false} or {}
		
		-- Helper function for tracing a direction
		local function runTrace(dir, dirName)
			trData.endpos = entPosCentered + (dir * maxDist)
			local tr = util.TraceLine(trData)
			local hitPos = tr.HitPos
			if !requireFullDist or entPos:Distance(hitPos) >= maxDist then
				//VJ.DEBUG_TempEnt(hitPos)
				hitPos.z = entPosZ -- Reset it to ent:GetPos() z-axis
				if returnAsDict then
					result[dirName] = hitPos
				else
					result[resultIndex] = hitPos
					resultIndex = resultIndex + 1
				end
			end
		end
		
		-- Run the traces (Up to 8)
		if !excludeForward then
			runTrace(myForward, "Forward")
			if numDirections >= 5 then
				runTrace((myForward - myRight):GetNormalized(), "ForwardLeft")
				runTrace((myForward + myRight):GetNormalized(), "ForwardRight")
			end
		end
		if !excludeBack then
			runTrace(-myForward, "Back")
			if numDirections >= 5 then
				runTrace((-myForward - myRight):GetNormalized(), "BackLeft")
				runTrace((-myForward + myRight):GetNormalized(), "BackRight")
			end
		end
		if !excludeLeft then
			runTrace(-myRight, "Left")
		end
		if !excludeRight then
			runTrace(myRight, "Right")
		end
		return result
	else -- "Radial"
		local result = returnAsDict and {Forward = {}, Back = {}, Left = {}, Right = {}} or {}
		local angleIncrement = (2 * math.pi) / numDirections -- Angle increment based on the number of directions

		-- Calculate all directions and run traces
		for i = 0, numDirections - 1 do
			local angle = i * angleIncrement
			local dir = myForward * math_cos(angle) + myRight * math_sin(angle)
			local forwardDot = dir:Dot(myForward)
            local rightDot = dir:Dot(myRight)
			
			-- Check which sides we are allowed to calculate
			if (excludeForward && forwardDot > 0.7) or (excludeBack && forwardDot < -0.7) or (excludeLeft && rightDot < -0.7) or (excludeRight && rightDot > 0.7) then
				continue
			end

			trData.endpos = entPosCentered + (dir * maxDist)
			local tr = util.TraceLine(trData)
			local hitPos = tr.HitPos
			if !requireFullDist or entPos:Distance(hitPos) >= maxDist then
				//VJ.DEBUG_TempEnt(hitPos)
				hitPos.z = entPosZ -- Reset it to ent:GetPos() z-axis
				if returnAsDict then
					if forwardDot > 0.7 then
						local resultForward = result.Forward
						resultForward[#resultForward + 1] = hitPos
					elseif forwardDot < -0.7 then
						local resultBack = result.Back
						resultBack[#resultBack + 1] = hitPos
					elseif rightDot < -0.7 then
						local resultLeft = result.Left
						resultLeft[#resultLeft + 1] = hitPos
					elseif rightDot > 0.7 then
						local resultRight = result.Right
						resultRight[#resultRight + 1] = hitPos
					end
				else
					result[resultIndex] = hitPos
					resultIndex = resultIndex + 1
				end
			end
		end
		return result
	end
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
	local animType = false
	if isnumber(anim) then
		animType = 1
	elseif isstring(anim) then
		animType = 2
	else
		return false
	end
	
	-- Get rid of the gesture prefix
	if animType == 2 && string_find(anim, "vjges_") then
		anim = string_gsub(anim, "vjges_", "")
		-- Convert to activity if possible
		if ent:LookupSequence(anim) == -1 then
			anim = tonumber(anim)
			animType = 1
		end
	end
	
	if animType == 1 then -- Activity
		local seqID = ent:SelectWeightedSequence(anim)
		if (seqID == -1 or seqID == 0) && (ent:GetSequenceName(seqID) == "Not Found!" or ent:GetSequenceName(seqID) == "No model!") then
			return false
		end
	else -- Sequence
		if string_find(anim, "vjseq_") then anim = string_gsub(anim, "vjseq_", "") end
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
	if !VJ.AnimExists(ent, anim) then return 0 end -- Invalid animation
	
	if isnumber(anim) then -- Activity
		return ent:SequenceDuration(ent:SelectWeightedSequence(anim))
	elseif isstring(anim) then -- Sequence / Gesture
		-- Get rid of the gesture prefix
		if string_find(anim, "vjges_") then
			anim = string_gsub(anim, "vjges_", "")
			if ent:LookupSequence(anim) == -1 then
				return ent:SequenceDuration(ent:SelectWeightedSequence(tonumber(anim)))
			end
		end
		if string_find(anim, "vjseq_") then
			anim = string_gsub(anim, "vjseq_", "")
		end
		return ent:SequenceDuration(ent:LookupSequence(anim))
	end
	return 0
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Decides the length of the animation using the given parameters (Useful for variables that allow "false" to let the base decide the time)
		- anim = Animation to use when determining the length
		- override = Whether to override the animation duration | DEFAULT = false
			-- false = Let the base decide the duration
			-- number = Override the duration by the given number
		- decrease = Decreases the duration by the given amount | DEFAULT = 0
			-- Will NOT decrease it if "override" is set to a number!
-----------------------------------------------------------]]
function VJ.AnimDurationEx(ent, anim, override, decrease)
	if isbool(anim) then return 0 end
	if !override then -- Base decides
		return (VJ.AnimDuration(ent, anim) - (decrease or 0)) / ent.AnimPlaybackRate
	elseif isnumber(override) then -- User decides
		return override / ent.AnimPlaybackRate
	else
		return 0
	end
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
		if !result or result == -1 then
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
function VJ.IsCurrentAnim(ent, anim)
	if istable(anim) then
		local curSeq = ent:GetSequence()
		local curAct = ent:GetActivity()
		for _, v in ipairs(anim) do
			if isnumber(v) then
				if v != -1 && v == curAct then
					return true
				end
			elseif ent:LookupSequence(v) == curSeq then
				return true
			end
		end
	else
		if anim == -1 then return false end
		if isnumber(anim) then -- For numbers do an activity check because an activity can have more than 1 sequence!
			local curAct = ent:GetActivity()
			return (anim == curAct) or (ent:TranslateActivity(anim) == curAct)
		end
		return ent:LookupSequence(anim) == ent:GetSequence()
	end
	return false
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
		if prt then
			local min, max = ent:GetPoseParameterRange(i)
			print(ent:GetPoseParameterName(i) .. " " .. min .. " / " .. max)
		end
		table.insert(result, ent:GetPoseParameterName(i))
	end
	return result
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
		local verticalAdjustment = math.abs(startPos.z - targetPos.z) + (applyDist and math_min(math_max(strength, -dist), dist) or strength) //+ math.Clamp(strength, -dist, dist / 4) //midPoint:Length() * (strength / (startPos:Distance(targetPos)))
		if dist > (strength * 9.5) && dist > 2000 then -- Bulletin #4 above
			if self.VJ_DEBUG then VJ.DEBUG_Print(self, "CalculateTrajectory", "warn", "Target is too far for the given arc strength, applying adjustment to avoid failure!") end
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
			if self.VJ_DEBUG then VJ.DEBUG_Print(self, "CalculateTrajectory", "warn", "Blocked by ceiling, decreasing arc to avoid hitting it!"); debugoverlay.Cross(tr.HitPos, 6, 5, VJ.COLOR_RED); debugoverlay.Text(tr.HitPos, "Ceiling - tr.HitPos", 5, false) end
			midPoint = tr.HitPos - self:GetUp() * 25
		else
			midPoint.z = midPoint.z + verticalAdjustment
		end
		
		-- Failed to find enough trajectory space | EX: There is an object between the midPoint and targetPos
		if (midPoint.z < startPos.z || midPoint.z < targetPos.z) then
			if self.VJ_DEBUG then VJ.DEBUG_Print(self, "CalculateTrajectory", "warn", "Not enough space, applying fail case velocity!") end
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
			if time1 < 0.1 then VJ.DEBUG_Print(self, "CalculateTrajectory", "error", "Probably failed because the trajectory time is below 0.1!") end
			local apexPos = startPos + (result * time1) -- The peak of the velocity
			apexPos.z = midPoint.z
			debugoverlay.Cross(startPos, 6, 5, VJ.COLOR_GREEN)
			debugoverlay.Text(startPos, "startPos", 5, false)
			//debugoverlay.Cross(targetPos, 6, 5, VJ.COLOR_YELLOW)
			//debugoverlay.Text(targetPos, "targetPos", 5, false)
			debugoverlay.Cross(apexPos, 6, 5, VJ.COLOR_RED)
			debugoverlay.Text(apexPos, "apexPos", 5, false)
			debugoverlay.Cross(midPoint, 6, 5, VJ.COLOR_ORANGE)
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
	else
		VJ.DEBUG_Print(self, "CalculateTrajectory", "error", "Called without a valid algorithm type!")
		return false
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
		local orgPlayback = ent.IsVJBaseSNPC and ent.AnimPlaybackRate or ent:GetPlaybackRate()
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
	Applies radius damage with the given parameters
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
			- UseConeDegree = Set to a number to use a cone-based radius | DEFAULT = nil
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
	for _, ent in ipairs((isnumber(extraOptions.UseConeDegree) and ents.FindInCone(startPos, extraOptions.UseConeDirection or attacker:GetForward(), dmgRadius, math_cos(math_rad(extraOptions.UseConeDegree or 90)))) or ents.FindInSphere(startPos, dmgRadius)) do
		if (ent.IsVJBaseBullseye && ent.VJ_IsBeingControlled) or ent.VJ_IsControllingNPC then continue end -- Don't damage bulleyes used by the NPC controller OR entities that are controlling others (Usually players)
		local nearestPos = ent:NearestPoint(startPos) -- From the enemy position to the given position
		if realisticRadius != false then -- Decrease damage from the nearest point all the way to the enemy point then clamp it!
			dmgFinal = math_min(math_max(dmgFinal * ((dmgRadius - startPos:Distance(nearestPos)) + 150) / dmgRadius, dmgMax / 2), dmgFinal)
		end
		
		if disableVisibilityCheck or (!disableVisibilityCheck && (ent:VisibleVec(startPos) or ent:Visible(attacker))) then
			local function DealDamage()
				if (customFunc) then customFunc(ent) end
				hitEnts[#hitEnts + 1] = ent
				if specialDmgEnts[ent:GetClass()] then
					ent:TakeDamage(dmgFinal, attacker, inflictor)
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
						if VJ.IsProp(ent) or ent:GetClass() == "prop_ragdoll" then
							local phys = ent:GetPhysicsObject()
							if IsValid(phys) then
								if forceUp == false then forceUp = force / 9.4 end
								if ent:GetClass() == "prop_ragdoll" then force = force * 1.5 end
								phys:ApplyForceCenter(((ent:GetPos() + ent:OBBCenter() + ent:GetUp() * forceUp) - startPos) * force)
							end
						else
							force = force * 1.2
							if forceUp == false then forceUp = force end
							dmgInfo:SetDamageForce(((ent:GetPos() + ent:OBBCenter() + ent:GetUp() * forceUp) - startPos) * force)
						end
					end
					VJ.DamageSpecialEnts(attacker, ent, dmgInfo)
					ent:TakeDamageInfo(dmgInfo)
				end
			end
			-- Self
			if ent == attacker then
				if extraOptions.DamageAttacker then DealDamage() end -- If it can't self hit, then skip
			-- Other entities
			elseif (ignoreInnocents == false) or (!ent:IsNPC() && !ent:IsPlayer()) or (ent:IsNPC() && ent:GetClass() != attacker:GetClass() && ent:Alive() && (attacker:IsPlayer() or (attacker:IsNPC() && attacker:Disposition(ent) != D_LI))) or (ent:IsPlayer() && ent:Alive() && (attacker:IsPlayer() or (!VJ_CVAR_IGNOREPLAYERS && !ent:IsFlagSet(FL_NOTARGET)))) then
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
		local phys = ent:GetPhysicsObject()
		if IsValid(phys) then
			phys:EnableMotion(true)
			phys:ApplyForceCenter(attacker:GetForward() * 1000)
		end
	end
end
--------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Helper function that attempts to find the name of the given entity
		- ent [entity] = The entity to find the name for
		- useClassFallback [boolean] = Should it return the class name if no name was found? | DEFAULT = true
	Returns
		- string, the name of the entity or its class name if no name was found and useClassFallback is true
		- false, only if name couldn't be found and useClassFallback is false
	Calculation
		1. Check for "targetname" keyvalue used by engine's I/O system using "ent:GetName()"
		2. Check for the variable "ent.PrintName"
		3. Check for the name assigned to the class in the NPC spawn menu list
		4. Check for the name assigned to the class in the Weapon spawn menu list
		5. Check for the name assigned to the class in the Entities spawn menu list
		6. Check if the client has a language translation for the entity's class
		7. If all above fails and useClassFallback is true, return the entity's class
-----------------------------------------------------------]]
function VJ.GetName(ent, useClassFallback)
	local getNameFunc = ent.GetName
	if getNameFunc then
		local targetName = ent:GetName()
		if targetName != "" then
			return CLIENT and language.GetPhrase(targetName) or targetName
		end
	end
	
	local printName = ent.PrintName
	if printName && printName != "" then
		return CLIENT and language.GetPhrase(printName) or printName
	end
	
	local entClass = ent:GetClass()
	local menuName_NPC = list.GetEntry("NPC", entClass)
	if menuName_NPC then
		return CLIENT and language.GetPhrase(menuName_NPC.Name) or menuName_NPC.Name
	end
	
	local menuName_Wep = list.GetEntry("Weapon", entClass)
	if menuName_Wep then
		return CLIENT and language.GetPhrase(menuName_Wep.PrintName) or menuName_Wep.PrintName
	end
	
	local menuName_Ent = list.GetEntry("SpawnableEntities", entClass)
	if menuName_Ent then
		return CLIENT and language.GetPhrase(menuName_Ent.PrintName) or menuName_Ent.PrintName
	end
	
	if CLIENT then
		local className = language.GetPhrase(entClass)
		if className != entClass then
			return className
		end
	end
	if useClassFallback == false then
		return false
	end
	return entClass
end
--------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Checks if the given entity is a prop
		- ent = The entity to check if it's a prop
	Returns
		- Boolean, true = entity is considered a prop
-----------------------------------------------------------]]
local props = {prop_physics = true, prop_physics_multiplayer = true, prop_physics_respawnable = true, prop_physics_override = true, prop_sphere = true}
--
function VJ.IsProp(ent)
	return props[ent:GetClass()] == true -- Without == check, it would return nil on false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function VJ.RoundToMultiple(num, multiple)
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
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Meta Edits ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local metaEntity = FindMetaTable("Entity")
local metaNPC = FindMetaTable("NPC")
--
if !metaNPC.IsVJBaseEdited then
	metaNPC.IsVJBaseEdited = true
	---------------------------------------------------------------------------------------------------------------------------------------------
	local orgSetMaxLookDistance = metaNPC.SetMaxLookDistance
	-- Override to make sure all 3 values are on par at all times!
	function metaNPC:SetMaxLookDistance(dist)
		//self:Fire("SetMaxLookDistance", dist) -- Original "SetMaxLookDistance" handles it now (below)
		orgSetMaxLookDistance(self, dist) -- For engine sight & sensing distance
		self:SetSaveValue("m_flDistTooFar", dist) -- For certain engine attacks, weapons, and condition distances
		self.SightDistance = dist -- For VJ Base
	end
	---------------------------------------------------------------------------------------------------------------------------------------------
	local orgSetPlaybackRate = metaEntity.SetPlaybackRate
	-- Need this because "ai_blended_movement" will override it constantly and we won't know what the actual playback is supposed to be
	function metaNPC:SetPlaybackRate(num, skipTrueRate)
		if !skipTrueRate then
			self.AnimPlaybackRate = num
		end
		orgSetPlaybackRate(self, num)
	end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Meta Additions ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Variable:		self.VJ_NPC_Class
-- Access: 			self.VJ_NPC_Class.CLASS_COMBINE
-- Remove: 			self.VJ_NPC_Class.CLASS_COMBINE = nil
-- Add: 			self:VJ_CLASS_ADD("CLASS_COMBINE", "CLASS_ZOMBIE", ...)
--
/*local numericClasses = self.VJ_NPC_Class
self.VJ_NPC_Class = {}
for _, class in ipairs(numericClasses) do
	self:VJ_CLASS_ADD(class)
end*/

/*function metaEntity:VJ_CLASS_ADD(...)
	//PrintTable({...})
	for _, class in ipairs({...}) do
		self.VJ_NPC_Class[class] = true
	end
end*/
--[[---------------------------------------------------------
	Overrides how a VJ NPC should feel towards towards the calling entity (otherEnt)
	1. otherEnt [entity] : The other entity that is testing to see how it should feel towards us
	2. distance [nil | number] : Calculated distance from this entity to the other entity
	3. isFriendly [boolean] : Whether or not the other entity has calculated us as friendly
	Returns
		- [boolean | Disposition enum] : Return false to not override anything | Return a disposition enum to set as an override
-----------------------------------------------------------]]
-- Apply directly to the entity to use it
--function metaEntity:HandlePerceivedRelationship(otherEnt, distance, isFriendly)
--	VJ.DEBUG_Print(self, "HandlePerceivedRelationship", otherEnt, distance, isFriendly)
--	return
--end
--[[---------------------------------------------------------
	Determines whether or not this entity should be engaged by an enemy
	1. otherEnt [entity] : The other entity that is testing to see if it can engage this entity
	2. distance [nil | number] : Calculated distance from this entity to the other entity
	Returns
		- [boolean] : Return true if it should be engaged
-----------------------------------------------------------]]
-- Apply directly to the entity to use it
--function metaEntity:CanBeEngaged(otherEnt, distance)
--	VJ.DEBUG_Print(self, "CanBeEngaged", otherEnt, distance)
--	return true
--end
---------------------------------------------------------------------------------------------------------------------------------------------
-- !!!!!!!!!!!!!! DO NOT USE !!!!!!!!!!!!!! [Backwards Compatibility!]
function metaEntity:CalculateProjectile(algorithmType, startPos, targetPos, strength)
	local ene = self:GetEnemy()
	if algorithmType == "Line" then
		return VJ.CalculateTrajectory(self, (self.IsVJBaseSNPC and IsValid(ene)) and ene or NULL, "Line", startPos, self.IsVJBaseSNPC and 1 or targetPos, strength)
	elseif algorithmType == "Curve" then
		return VJ.CalculateTrajectory(self, (self.IsVJBaseSNPC and IsValid(ene)) and ene or NULL, "CurveOld", startPos, targetPos, strength)
	end
end