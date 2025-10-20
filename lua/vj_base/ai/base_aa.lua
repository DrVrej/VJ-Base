/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
---------------------------------------------------------------------------------------------------------------------------------------------
-- AERIAL & AQUATIC BASE --
// MOVETYPE_FLY | MOVETYPE_FLYGRAVITY
ENT.AA_NextMoveAnimTime = 0
ENT.AA_CurrentMoveAnim = false -- false = No animation set | -1 = Don't play an animation
ENT.AA_CurrentMoveAnimType = "Calm" -- "Calm" | "Alert"
ENT.AA_CurrentMoveMaxSpeed = 0
ENT.AA_CurrentMoveTime = 0
ENT.AA_CurrentMoveType = 0 -- 0 = Undefined | 1 = Wander | 2 = Regular Move-to | 3 = Chase Enemy Move-to
ENT.AA_CurrentMovePos = nil
ENT.AA_CurrentMovePosDir = nil
ENT.AA_CurrentMoveDist = -1 -- Used to make sure we are making progress in case something blocks its path
ENT.AA_LastChasePos = nil
ENT.AA_DoingLastChasePos = false

local defPos = Vector(0, 0, 0)
local defAng = Angle(0, 0, 0)
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Stops the current NPC, similar to ground NPCs calling self:StopMoving()
-----------------------------------------------------------]]
function ENT:AA_StopMoving()
	if self:GetVelocity():Length() > 0 then
		local selfData = self:GetTable()
		selfData.AA_CurrentMoveMaxSpeed = 0
		selfData.AA_CurrentMoveTime = 0
		selfData.AA_CurrentMoveType = 0
		selfData.AA_CurrentMovePos = nil
		selfData.AA_CurrentMovePosDir = nil
		selfData.AA_CurrentMoveDist = -1
		self:SetLocalVelocity(defPos)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Moves to the provided destination (If it can)
		- dest = The destination to move to, it can be an entity or a vector
		- playAnim = Should it play movement animation? | DEFAULT: true
		- moveType = Type of movement animation it should do | DEFAULT: "Calm"
		- extraOptions = Table that holds extra options to modify parts of the code
			- AddPos = Position that will be added to the given destination | DEFAULT: Vector(0, 0, 0)
			- FaceDest = Should it face the destination? | DEFAULT: true
			- FaceDestTarget = If the destination is an entity, it will face the entity instead of the move position | DEFAULT: false
			- IgnoreGround = If true, it will not do any ground checks | DEFAULT: false
-----------------------------------------------------------]]
local vecStart = Vector(0, 0, 30)
local vecEnd = Vector(0, 0, 40)
--
function ENT:AA_MoveTo(dest, playAnim, moveType, extraOptions)
	local destVec = isvector(dest) and dest
	local selfData = self:GetTable()
	if selfData.Dead or (!destVec && !IsValid(dest)) then return end
	moveType = moveType or "Calm" -- "Calm" | "Alert"
	extraOptions = extraOptions or {}
		local addPos = extraOptions.AddPos or defPos -- This will be added to the given entity's position
		local chaseEnemy = extraOptions.ChaseEnemy or false -- Used internally by ChaseEnemy, enables code that's used only for that
	local moveSpeed = (moveType == "Calm" and selfData.Aerial_FlyingSpeed_Calm) or selfData.Aerial_FlyingSpeed_Alerted
	local debug = selfData.VJ_DEBUG
	local myPos = self:GetPos()
	local trFilter = {self, isentity(dest) and dest or NULL, "phys_bone_follower"} -- Pass in NULL when "dest" is not an entity otherwise filter will ignore everything after it!
	
	-- Initial checks for aquatic NPCs
	if selfData.MovementType == VJ_MOVETYPE_AQUATIC then
		moveSpeed = (moveType == "Calm" and selfData.Aquatic_SwimmingSpeed_Calm) or selfData.Aquatic_SwimmingSpeed_Alerted
		if debug then
			print("----------------")
			print("[MoveTo] My WaterLevel: " .. self:WaterLevel())
			if !destVec then print("[MoveTo] dest WaterLevel: " .. dest:WaterLevel()) end
		end
		-- NPC not fully in water, so forget the destination, instead wander OR go deeper into the war
		if self:WaterLevel() <= 2 then self:MaintainIdleBehavior(1) return end
		-- If the destination is a vector then make sure it's in the water
		if destVec then
			local tr_aquatic = util.TraceLine({
				start = myPos,
				endpos = destVec,
				filter = trFilter,
				mask = MASK_WATER
			})
			if !tr_aquatic.Hit then self:MaintainIdleBehavior(1) return end
			//print(tr_aquatic.Hit)
			//debugoverlay.Box(tr_aquatic.HitPos, Vector(-2, -2, -2), Vector(2, 2, 2), 5, VJ.COLOR_YELLOW)
		-- If the destination is not a vector, then make sure it's reachable
		else
			if dest:WaterLevel() <= 1 then
				-- Destination not in water, so forget the destination, instead wander OR go deeper into the war
				if dest:WaterLevel() == 0 then self:MaintainIdleBehavior(1) return end
				local trene = util.TraceLine({
					start = dest:GetPos() + self:OBBCenter(),
					endpos = (dest:GetPos() + self:OBBCenter()) + dest:GetUp()*-20,
					filter = trFilter
				})
				//PrintTable(trene)
				//debugoverlay.Box(trene.HitPos, Vector(-2, -2, -2), Vector(2, 2, 2), 5, VJ.COLOR_GREEN)
				if trene.Hit == true then return end
				//if IsValid(trene.Entity) && trene.Entity == dest then return end
			end
		end
	end
	
	-- Movement Calculations
	// local nearpos = self:GetNearestPositions(dest)
	local startPos = myPos + self:OBBCenter() + vecStart // nearpos.MyPosition
	local endPos = destVec or dest:GetPos() + dest:OBBCenter() + vecEnd // nearpos.EnemyPosition
	local tr = util.TraceHull({
		start = startPos,
		endpos = endPos,
		filter = trFilter,
		mins = self:OBBMins(),
		maxs = self:OBBMaxs()
	})
	local trHitPos = tr.HitPos
	//local groundLimited = false -- If true, it limited the ground because it was too close
	-- Preform ground check if:
		-- It's an aerial NPC AND it is not ignoring ground AND-
		-- It's NOT a chase enemy OR it is but the NPC doesn't have a melee attack
	if selfData.MovementType == VJ_MOVETYPE_AERIAL && extraOptions.IgnoreGround != true && ((!chaseEnemy) or (chaseEnemy && !selfData.HasMeleeAttack)) then
		local tr_check1 = util.TraceLine({start = startPos, endpos = startPos + Vector(0, 0, -selfData.AA_GroundLimit), filter = trFilter})
		local tr_check2 = util.TraceLine({start = trHitPos, endpos = trHitPos + Vector(0, 0, -selfData.AA_GroundLimit), filter = trFilter})
		if debug then
			print("[MoveTo] checking...")
			debugoverlay.Box(startPos, Vector(-2, -2, -2), Vector(2, 2, 2), 5, Color(145, 255, 0))
			debugoverlay.Box(tr_check1.HitPos, Vector(-2, -2, -2), Vector(2, 2, 2), 5, Color(0, 183, 255))
		end
		-- If it hit the world, then we are too close to the ground, replace "tr" with a new position!
		if tr_check1.Hit == true or (tr_check2.Hit == true && !tr_check2.Entity:IsNPC()) then
			if debug then print("[MoveTo] Ground Hit!", tr_check1.HitPos:Distance(startPos)) end
			//groundLimited = true
			endPos.z = (tr_check1.Hit and myPos.z or endPos.z) + selfData.AA_GroundLimit
			tr = util.TraceHull({
				start = startPos,
				endpos = endPos,
				filter = trFilter,
				mins = self:OBBMins(),
				maxs = self:OBBMaxs()
			})
			trHitPos = tr.HitPos
		end
	end
	
	if !destVec then
		-- If world is hit then our hitbox can't fully fit through the path to the destination
		if tr.HitWorld then
			if debug then print("[MoveTo] hitworld") end
			-- If we are already going to the last destination...
			if selfData.AA_DoingLastChasePos then
				-- Its movement is finished, therefore it's not moving there anymore!
				if selfData.AA_CurrentMoveTime < CurTime() then
					selfData.AA_DoingLastChasePos = false
					selfData.AA_LastChasePos = nil
				-- It's moving there, don't interrupt!
				else
					return
				end
			-- If we have a last destination then move there!
			elseif selfData.AA_LastChasePos != nil then
				if debug then debugoverlay.Box(selfData.AA_LastChasePos, Vector(-2, -2, -2), Vector(2, 2, 2), 5, Color(0, 68, 255)) end
				selfData.AA_DoingLastChasePos = true
				tr = util.TraceHull({
					start = startPos,
					endpos = selfData.AA_LastChasePos,
					filter = trFilter,
					mins = self:OBBMins(),
					maxs = self:OBBMaxs()
				})
			end
		else
			selfData.AA_DoingLastChasePos = false
			selfData.AA_LastChasePos = trHitPos
		end
	end
	trHitPos = tr.HitPos
	local trDistStart = startPos:Distance(trHitPos)
	if debug then
		util.ParticleTracerEx("Weapon_Combine_Ion_Cannon_Beam", tr.StartPos, trHitPos, false, self:EntIndex(), 0) //vortigaunt_beam
		debugoverlay.Box(trHitPos, Vector(-2, -2, -2), Vector(2, 2, 2), 5, Color(212, 0, 255))
	end
	
	local finalPos = trHitPos
	if trDistStart <= 16 && tr.HitWorld == true then
		if debug then print("[MoveTo] Forward Blocked!") end
		finalPos = endPos
		-- Make sure the trace actually went somewhere...
		if tr.Fraction > 0 then
			selfData.AA_LastChasePos = endPos
		end
	end
	if destVec then
		finalPos = finalPos + addPos
	-- If the enemy is a bit above water, try to go for its GetPos, which is usually at its feet
	elseif selfData.MovementType == VJ_MOVETYPE_AQUATIC && dest:WaterLevel() < 3 then
		finalPos = dest:GetPos() + dest:GetForward()*addPos.x + dest:GetRight()*addPos.y + dest:GetUp()*addPos.z
	else
		finalPos = finalPos + dest:GetForward()*addPos.x + dest:GetRight()*addPos.y + dest:GetUp()*addPos.z
	end
	if debug then ParticleEffect("vj_impact_dirty", finalPos, defAng, self) end
	
	-- Z Calculations
	-- BUG: Causes the NPC to go up / down VERY quickly!
	/*local velUp = 0
	local distZFinal = finalPos.z - startPos.z -- Distance between the hit position and the start position
	if !groundLimited then
		if distZFinal > 5 then -- Up
			if debug then print("[MoveTo] GOING UP") end
			velUp = math.Clamp(distZFinal, 20, moveSpeed)
		elseif distZFinal < 5 then -- Down
			if debug then print("[MoveTo] GOING DOWN") end
			velUp = -math.Clamp(math.abs(distZFinal), 20, moveSpeed)
		end
	end*/
	
	selfData.AA_CurrentMoveMaxSpeed = moveSpeed
	if selfData.AA_MoveAccelerate > 0 then moveSpeed = Lerp(FrameTime()*2, self:GetVelocity():Length(), moveSpeed) end
	
	-- Set the velocity
	local velPos = (finalPos - startPos):GetNormal()*moveSpeed //+ self:GetUp()*velUp + self:GetForward()
	local velTime = finalPos:Distance(startPos) / velPos:Length()
	local velTimeCur = CurTime() + velTime
	if velTimeCur == velTimeCur then -- Check for NaN
		selfData.AA_CurrentMoveTime = velTimeCur
		//selfData.NextIdleTime = velTimeCur
	end
	if extraOptions.FaceDest != false then
		if extraOptions.FaceDestTarget == true then
			self:SetTurnTarget((chaseEnemy && selfData.CanTurnWhileMoving) and "Enemy" or dest, velTime)
		else
			-- Offset the arrival position so it does NOT turn 180 degrees back from where it traveled from
			local offsetFacing = finalPos + (finalPos - self:GetPos()):GetNormalized() * (selfData.AA_CurrentMoveMaxSpeed / 50)
			offsetFacing.z = finalPos.z
			self:SetTurnTarget(offsetFacing, velTime)
		end
		//selfData.AA_CurrentTurnAng = chaseEnemy and false or self:GetTurnAngle(self:GetTurnAngle((velPos):Angle()))
	end
	selfData.AA_CurrentMoveType = chaseEnemy and 3 or 2
	selfData.AA_CurrentMovePos = finalPos
	selfData.AA_CurrentMovePosDir = finalPos - startPos
	selfData.AA_CurrentMoveDist = -1
	self:SetLocalVelocity(velPos)
	
	-- Animations
	if playAnim != false then
		if selfData.AA_CurrentMoveAnimType != moveType then
			selfData.AA_CurrentMoveAnim = false
			selfData.AA_CurrentMoveAnimType = moveType
		end
	else
		selfData.AA_CurrentMoveAnim = -1
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Makes the NPC wander, if it's aquatic then it will move deeper into water if it finds it necessary
		- playAnim = Should it play movement animation? | DEFAULT: true
		- moveType = Type of movement animation it should do | DEFAULT: "Calm"
		- extraOptions = Table that holds extra options to modify parts of the code
			- FaceDest = Should it face the destination? | DEFAULT: true
			- IgnoreGround = If true, it will not do any ground checks | DEFAULT: false
-----------------------------------------------------------]]
function ENT:AA_IdleWander(playAnim, moveType, extraOptions)
	local selfData = self:GetTable()
	moveType = moveType or "Calm" -- "Calm" | "Alert"
	local moveSpeed = (moveType == "Calm" and selfData.Aerial_FlyingSpeed_Calm) or selfData.Aerial_FlyingSpeed_Alerted
	local moveDown = false -- Used by aquatic NPCs only, forces them to move down
	if selfData.MovementType == VJ_MOVETYPE_AQUATIC then
		-- If NOT Completely submerged
		if self:WaterLevel() < 3 then
			self:AA_StopMoving()
			moveDown = true
			if self:WaterLevel() == 0 then
				return
			end
		end
		moveSpeed = (moveType == "Calm" and selfData.Aquatic_SwimmingSpeed_Calm) or selfData.Aquatic_SwimmingSpeed_Alerted
	end
	
	local debug = selfData.VJ_DEBUG
	extraOptions = extraOptions or {}
	
	-- Movement Calculations
	local myPos = self:GetPos()
	local myMaxs = self:OBBMaxs():Length()
	local minDist = math.random(selfData.AA_MinWanderDist, selfData.AA_MinWanderDist + 150)
	local tr_endpos = myPos + self:GetForward()*((myMaxs + minDist)*(math.random(1, 2) == 1 and -1 or 1)) + self:GetRight()*((myMaxs + minDist)*(math.random(1, 2) == 1 and -1 or 1)) + self:GetUp()*((myMaxs + minDist)*(math.random(1, 2) == 1 and -1 or 1))
	if moveDown == true then
		tr_endpos = myPos + self:GetUp()*((myMaxs + math.random(100, 150))*-1)
	end
	local trFilter = {self, "phys_bone_follower"}
	local tr = util.TraceLine({start = myPos, endpos = tr_endpos, filter = trFilter})
	local finalPos = tr.HitPos
	//PrintTable(tr)
	-- If we aren't being forced to move down, then make sure we limit how close we get to the ground!
	if extraOptions.IgnoreGround != true && !moveDown && selfData.MovementType == VJ_MOVETYPE_AERIAL then
		local tr_check = util.TraceLine({start = finalPos, endpos = finalPos + Vector(0, 0, -selfData.AA_GroundLimit), filter = trFilter})
		if debug then
			print("[IdleWander] checking...")
			debugoverlay.Box(finalPos, Vector(-2, -2, -2), Vector(2, 2, 2), 5, VJ.COLOR_WHITE)
			debugoverlay.Box(tr_check.HitPos, Vector(-2, -2, -2), Vector(2, 2, 2), 5, Color(255, 0, 255))
		end
		-- If it hit the world, then we are too close to the ground, replace "tr" with a new position!
		if tr_check.HitWorld == true then
			if debug then print("[IdleWander] Ground Hit!", tr_check.HitPos:Distance(finalPos)) end
			tr_endpos.z = myPos.z + selfData.AA_GroundLimit
			tr = util.TraceLine({start = myPos, endpos = tr_endpos, filter = trFilter})
			finalPos = tr.HitPos
		end
	end
	
	if debug then
		util.ParticleTracerEx("Weapon_Combine_Ion_Cannon_Beam", tr.StartPos, finalPos, false, self:EntIndex(), 0)
		ParticleEffect("vj_impact_dirty", finalPos, defAng, self)
		debugoverlay.Box(finalPos, Vector(-2, -2, -2), Vector(2, 2, 2), 5, VJ.COLOR_CYAN)
	end
	
	selfData.AA_CurrentMoveMaxSpeed = moveSpeed
	if selfData.AA_MoveAccelerate > 0 then moveSpeed = Lerp(FrameTime()*2, self:GetVelocity():Length(), moveSpeed) end
	
	-- Set the velocity
	local velPos = (finalPos - myPos):GetNormal()*moveSpeed
	local velTime = finalPos:Distance(myPos) / velPos:Length()
	local velTimeCur = CurTime() + velTime
	if velTimeCur == velTimeCur then -- Check for NaN
		selfData.AA_CurrentMoveTime = velTimeCur
		//selfData.NextIdleTime = velTimeCur
	end
	if extraOptions.FaceDest != false then
		self:SetTurnTarget(finalPos, velTime)
		//selfData.AA_CurrentTurnAng = self:GetTurnAngle((finalPos - tr.StartPos):Angle())
		//self:SetLocalAngularVelocity(self:GetTurnAngle((finalPos-tr.StartPos):Angle()))
	end
	selfData.AA_CurrentMoveType = 1
	selfData.AA_CurrentMovePos = finalPos
	selfData.AA_CurrentMovePosDir = finalPos - myPos
	selfData.AA_CurrentMoveDist = -1
	self:SetLocalVelocity(velPos)
	
	-- Animations
	if playAnim != false then
		if selfData.AA_CurrentMoveAnimType != moveType then
			selfData.AA_CurrentMoveAnim = false
			selfData.AA_CurrentMoveAnimType = moveType
		end
	else
		selfData.AA_CurrentMoveAnim = -1
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Makes the NPC chase its current enemy (If it has one)
		- playAnim = Should it play movement animation? | DEFAULT: true
		- moveType = Type of movement animation it should do | DEFAULT: "Alert"
-----------------------------------------------------------]]
function ENT:AA_ChaseEnemy(playAnim, moveType)
	if self.Dead or (self.NextChaseTime > CurTime()) then return false end
	local ene = self:GetEnemy()
	if !IsValid(ene) then return false end
	self:AA_MoveTo(ene, playAnim != false, moveType or "Alert", {FaceDestTarget=true, ChaseEnemy=true})
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Internal function, handles the movement animations
-----------------------------------------------------------]]
-- Activities that should be played as sequences otherwise the engine will override it and set it back to idle | Issue: https://github.com/ValveSoftware/source-sdk-2013/blob/master/src/game/server/ai_basenpc.cpp#L3023
local badACTs = {[ACT_WALK] = true, [ACT_WALK_AIM] = true, [ACT_RUN] = true, [ACT_RUN_AIM] = true}
--
function ENT:AA_MoveAnimation()
	-- NOTE: Unique condition used for directional flying animations in TranslateActivity:
		--  if "AA_CurrentMoveAnim" is current sequence AND current activity is not a sequence AND translated activity does not equal current sequence's activity
	local selfData = self:GetTable()
	local curSeq = self:GetSequence()
	local curACT = self:GetActivity()
	if ((CurTime() > selfData.AA_NextMoveAnimTime) or (curSeq != selfData.AA_CurrentMoveAnim or (curACT != ACT_DO_NOT_DISTURB && self:GetSequenceActivity(curSeq) != self:TranslateActivity(curACT)))) && !self:IsBusy("Activities") then
		local chosenAnim = false
		if selfData.AA_CurrentMoveAnimType == "Calm" then
			chosenAnim = (selfData.MovementType == VJ_MOVETYPE_AQUATIC and selfData.Aquatic_AnimTbl_Calm) or selfData.Aerial_AnimTbl_Calm
		elseif selfData.AA_CurrentMoveAnimType == "Alert" then
			chosenAnim = (selfData.MovementType == VJ_MOVETYPE_AQUATIC and selfData.Aquatic_AnimTbl_Alerted) or selfData.Aerial_AnimTbl_Alerted
		end
		chosenAnim = VJ.PICK(chosenAnim)
		local _, animDur = self:PlayAnim(chosenAnim, false, 0, false, 0, {AlwaysUseSequence = badACTs[chosenAnim] or false})
		selfData.AA_CurrentMoveAnim = self:GetActivity() == ACT_DO_NOT_DISTURB and self:GetSequence() or self:GetIdealSequence() -- In case we played a non-sequence
		selfData.AA_NextMoveAnimTime = CurTime() + animDur -- animDur will always be accurate
	end
end