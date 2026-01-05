require("vj_ai_schedule")
/*-----------------------------------------------
	*** Copyright (c) 2012-2026 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
local VJ_MOVETYPE_AERIAL = VJ_MOVETYPE_AERIAL
local VJ_MOVETYPE_AQUATIC = VJ_MOVETYPE_AQUATIC
local VJ_MOVETYPE_STATIONARY = VJ_MOVETYPE_STATIONARY

local metaEntity = FindMetaTable("Entity")
local funcGetTable = metaEntity.GetTable
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SCHEDULE_FACE(faceTask, customFunc)
	-- Types: TASK_FACE_TARGET | TASK_FACE_ENEMY | TASK_FACE_PLAYER | TASK_FACE_LASTPOSITION | TASK_FACE_SAVEPOSITION | TASK_FACE_PATH | TASK_FACE_HINTNODE | TASK_FACE_IDEAL | TASK_FACE_REASONABLE
	if self.MovementType == VJ_MOVETYPE_STATIONARY && !self.CanTurnWhileStationary then return end
	local schedule = vj_ai_schedule.New("SCHEDULE_FACE")
	schedule:EngTask(faceTask or "TASK_FACE_TARGET", 0)
	if customFunc then customFunc(schedule) end
	self:StartSchedule(schedule)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SCHEDULE_GOTO_POSITION(moveTask, customFunc)
	local moveType = self.MovementType
	if moveType == VJ_MOVETYPE_AERIAL or moveType == VJ_MOVETYPE_AQUATIC then
		self:AA_MoveTo(self:GetLastPosition(), true, (moveTask == "TASK_RUN_PATH" and "Alert") or "Calm")
		return
	end
	local schedule = vj_ai_schedule.New("SCHEDULE_GOTO_POSITION")
	//schedule:EngTask("TASK_SET_TOLERANCE_DISTANCE", 48) -- Will cause the NPC not move at all in many cases!
	//schedule:EngTask("TASK_SET_ROUTE_SEARCH_TIME", 3)
	schedule:EngTask("TASK_GET_PATH_TO_LASTPOSITION", 0)
	schedule:EngTask(moveTask or "TASK_RUN_PATH", 0)
	schedule:EngTask("TASK_WAIT_FOR_MOVEMENT", 0)
	if customFunc then customFunc(schedule) end
	self:StartSchedule(schedule)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SCHEDULE_GOTO_TARGET(moveTask, customFunc)
	local moveType = self.MovementType
	if moveType == VJ_MOVETYPE_AERIAL or moveType == VJ_MOVETYPE_AQUATIC then
		self:AA_MoveTo(self:GetTarget(), true, (moveTask == "TASK_RUN_PATH" and "Alert") or "Calm")
		return
	end
	local schedule = vj_ai_schedule.New("SCHEDULE_GOTO_TARGET")
	schedule:EngTask("TASK_GET_PATH_TO_TARGET", 0)
	schedule:EngTask(moveTask or "TASK_RUN_PATH", 0)
	schedule:EngTask("TASK_WAIT_FOR_MOVEMENT", 0)
	schedule:EngTask("TASK_FACE_TARGET", 1)
	if customFunc then customFunc(schedule) end
	self:StartSchedule(schedule)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SCHEDULE_COVER_ENEMY(moveTask, customFunc)
	local moveType = self.MovementType; if moveType == VJ_MOVETYPE_AERIAL or moveType == VJ_MOVETYPE_AQUATIC then self:AA_IdleWander() return end
	local schedule = vj_ai_schedule.New("SCHEDULE_COVER_ENEMY")
	schedule:EngTask("TASK_FIND_COVER_FROM_ORIGIN", 0)
	schedule:EngTask(moveTask or "TASK_RUN_PATH", 0)
	schedule:EngTask("TASK_WAIT_FOR_MOVEMENT", 0)
	schedule.RunCode_OnFail = function()
		//VJ.DEBUG_Print(self, "SCHEDULE_COVER_ENEMY", "warn", "Failed to find cover!")
		local schedFail = vj_ai_schedule.New("SCHEDULE_COVER_ENEMY_FAIL")
		schedFail:EngTask("TASK_SET_ROUTE_SEARCH_TIME", 2)
		schedFail:EngTask("TASK_GET_PATH_TO_RANDOM_NODE", 500)
		schedFail:EngTask(moveTask or "TASK_RUN_PATH", 0)
		schedFail:EngTask("TASK_WAIT_FOR_MOVEMENT", 0)
		if customFunc then customFunc(schedFail) end
		self:StartSchedule(schedFail)
	end
	if customFunc then customFunc(schedule) end
	self:StartSchedule(schedule)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SCHEDULE_COVER_ORIGIN(moveTask, customFunc)
	local moveType = self.MovementType; if moveType == VJ_MOVETYPE_AERIAL or moveType == VJ_MOVETYPE_AQUATIC then self:AA_IdleWander() return end
	local schedule = vj_ai_schedule.New("SCHEDULE_COVER_ORIGIN")
	schedule:EngTask("TASK_FIND_COVER_FROM_ORIGIN", 0)
	schedule:EngTask(moveTask or "TASK_RUN_PATH", 0)
	schedule:EngTask("TASK_WAIT_FOR_MOVEMENT", 0)
	schedule.RunCode_OnFail = function()
		local schedFail = vj_ai_schedule.New("SCHEDULE_COVER_ORIGIN_FAIL")
		schedFail:EngTask("TASK_SET_ROUTE_SEARCH_TIME", 2)
		schedFail:EngTask("TASK_GET_PATH_TO_RANDOM_NODE", 500)
		schedFail:EngTask(moveTask or "TASK_RUN_PATH", 0)
		schedFail:EngTask("TASK_WAIT_FOR_MOVEMENT", 0)
		if customFunc then customFunc(schedFail) end
		self:StartSchedule(schedFail)
	end
	if customFunc then customFunc(schedule) end
	self:StartSchedule(schedule)
end
---------------------------------------------------------------------------------------------------------------------------------------------
local schedule_wander = vj_ai_schedule.New("SCHEDULE_IDLE_WANDER")
	//schedule_wander:EngTask("TASK_SET_ROUTE_SEARCH_TIME", 0)
	//schedule_wander:EngTask("TASK_GET_PATH_TO_LASTPOSITION", 0)
	schedule_wander:EngTask("TASK_GET_PATH_TO_RANDOM_NODE", 350)
	schedule_wander:EngTask("TASK_WALK_PATH", 0)
	schedule_wander:EngTask("TASK_WAIT_FOR_MOVEMENT", 0)
	schedule_wander.ResetOnFail = true
	schedule_wander.CanBeInterrupted = true
--
function ENT:SCHEDULE_IDLE_WANDER()
	local moveType = self.MovementType; if moveType == VJ_MOVETYPE_AERIAL or moveType == VJ_MOVETYPE_AQUATIC then self:AA_IdleWander() return end
	self:StartSchedule(schedule_wander)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SCHEDULE_IDLE_STAND()
	local selfData = funcGetTable(self)
	if self:IsMoving() or selfData.NextIdleTime > CurTime() then return end
	local navType = self:GetNavType(); if navType == NAV_JUMP or navType == NAV_CLIMB then return end
	local moveType = selfData.MovementType; if (moveType == VJ_MOVETYPE_AERIAL or moveType == VJ_MOVETYPE_AQUATIC) && (selfData.AA_CurrentMoveTime > CurTime() or self:IsBusy("Activities")) then return end // self:GetVelocity():Length() > 0
	self:MaintainIdleAnimation(self:GetIdealActivity() != ACT_IDLE)
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:TASK_VJ_PLAY_ACTIVITY(taskStatus, data)
	if taskStatus == TASKSTATUS_NEW then
		//VJ.DEBUG_Print(self, "TASK_VJ_PLAY_ACTIVITY", "Start -", data.duration)
		local playbackRate = data.playbackRate or self.AnimPlaybackRate -- Since setting a new animation resets the playback rate, make sure to capture it before anything!
		self:ResetIdealActivity(data.animation)
		self:SetActivity(data.animation) -- Avoids "MaintainActivity" from selecting another sequence from the activity (if it has multiple sequences tied to it)
		self:SetPlaybackRate(playbackRate, true)
		if !isnumber(data.duration) then
			data.duration = self:SequenceDuration(self:GetIdealSequence()) / playbackRate
		end
		data.animEndTime = CurTime() + data.duration
		//self:AutoMovement(self:GetAnimTimeInterval()) -- Causes extra walk frame to be applied, especially when switching from movement to animation
	else
		//self:AutoMovement(self:GetAnimTimeInterval())
		if (CurTime() > data.animEndTime) or (self:IsSequenceFinished() && self:GetSequence() == self:GetIdealSequence()) then
			//VJ.DEBUG_Print(self, "TASK_VJ_PLAY_ACTIVITY", "Stop")
			if data.playbackRate then self:SetPlaybackRate(self.AnimPlaybackRate, true) end
			self:TaskComplete()
			return
		else
			//VJ.DEBUG_Print(self, "TASK_VJ_PLAY_ACTIVITY", "Run")
			if data.playbackRate then self:SetPlaybackRate(data.playbackRate, true) end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:TASK_VJ_PLAY_SEQUENCE(taskStatus, data)
	if taskStatus == TASKSTATUS_NEW then
		//VJ.DEBUG_Print(self, "TASK_VJ_PLAY_SEQUENCE", "Start -", data.duration)
		local playbackRate = data.playbackRate or self.AnimPlaybackRate -- Since setting a new animation resets the playback rate, make sure to capture it before anything!
		data.seqID = self:PlaySequence(data.animation)
		self:SetPlaybackRate(playbackRate, true)
		data.animEndTime = CurTime() + data.duration
	else
		if (CurTime() > data.animEndTime) or (self:IsSequenceFinished()) or (data.seqID != self:GetSequence()) then
			//VJ.DEBUG_Print(self, "TASK_VJ_PLAY_SEQUENCE", "Stop")
			if data.playbackRate then self:SetPlaybackRate(self.AnimPlaybackRate, true) end
			self:TaskComplete()
			return
		else
			//VJ.DEBUG_Print(self, "TASK_VJ_PLAY_SEQUENCE", "Run")
			if data.playbackRate then self:SetPlaybackRate(data.playbackRate, true) end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RunAI() -- Called from the engine every 0.1 seconds
	if self:GetState() == VJ_STATE_FREEZE or self:IsEFlagSet(EFL_IS_BEING_LIFTED_BY_BARNACLE) then self:MaintainActivity() return end
	local selfData = funcGetTable(self)
	if self:IsRunningBehavior() or selfData.bDoingEngineSchedule then return true end -- true = Run "MaintainSchedule" in engine
	//self:SetArrivalActivity(ACT_COWER)
	//self:SetArrivalSpeed(1000)
	local isMoving = self:IsMoving()
	
	-- Apply walk frames to both activities and sequences
	-- Parts of it replicate TASK_PLAY_SEQUENCE - https://github.com/ValveSoftware/source-sdk-2013/blob/master/src/game/server/ai_basenpc_schedule.cpp#L3312
	if !isMoving && self:GetSequenceMoveDist(self:GetSequence()) > 0 && !self:IsSequenceFinished() && ((self:GetSequence() == self:GetIdealSequence()) or (self:GetActivity() == ACT_DO_NOT_DISTURB)) && selfData.MovementType != VJ_MOVETYPE_AERIAL && selfData.MovementType != VJ_MOVETYPE_AQUATIC then
		self:AutoMovement(self:GetAnimTimeInterval())
	end
	
	-- If we are currently running a schedule then run it otherwise call "SelectSchedule" to decide what to do next
	local curSchedule = selfData.CurrentSchedule
	if curSchedule then
		-- Handle movement animations
			-- 1. Make sure the movement activity is the current activity
			-- 2. Compare the current movement sequence to the current ideal sequence, if they don't match then the movement activity may be outdated depending on the next check!
			-- 3. Compare their activities and continue if they don't match! A single activity can have multiple sequences tied to it, without this check it will cause it to bug out!
			-- 4. Force the ideal sequence to be the actual movement activity's sequence (including translated)
			-- This is needed because:
				-- 1. Often times translating alone will NOT update the movement animation!
				-- 2. Half of the time, the engine will NOT even call the translate function!
		if isMoving then
			local moveAct = self:GetMovementActivity()
			if self:GetActivity() == moveAct then
				self:SetMovementActivity(moveAct) -- Force update the movement sequence, aka "m_sequence" in the engine
				local moveSeq = self:GetMovementSequence()
				local idealSeq = self:GetIdealSequence()
				if moveSeq != idealSeq && self:GetSequenceActivity(moveSeq) != self:GetSequenceActivity(idealSeq) then
					self:SetIdealSequence(moveSeq)
				end
			end
		end
		
		self:DoSchedule(curSchedule)
		if curSchedule.CanBeInterrupted or self:IsScheduleFinished(curSchedule) or (curSchedule.HasMovement && !self:IsMoving()) then
			self:SelectSchedule()
		end
	else
		self:SelectSchedule()
	end
	
	//if !selfData.VJ_PlayingSequence then -- No longer needed for sequences as it is handled by ACT_DO_NOT_DISTURB
	self:MaintainActivity()
	//end
	
	-- Handle turning / facing
	local turnData = selfData.TurnData
	local ene = self:GetEnemy()
	local eneValid = IsValid(ene)
	
	if eneValid && !selfData.Dead then
		-- Handle "ConstantlyFaceEnemy"
		if selfData.ConstantlyFaceEnemy && self:MaintainConstantlyFaceEnemy() then
			return
		end
		-- Face enemy for stationary types OR attacks
		if (selfData.MovementType == VJ_MOVETYPE_STATIONARY && selfData.CanTurnWhileStationary) or (selfData.AttackType && ((selfData.MeleeAttackAnimationFaceEnemy && !selfData.MeleeAttack_IsPropAttack && selfData.AttackType == VJ.ATTACK_TYPE_MELEE) or (selfData.GrenadeAttackAnimationFaceEnemy && selfData.AttackType == VJ.ATTACK_TYPE_GRENADE && selfData.EnemyData.Visible) or (selfData.RangeAttackAnimationFaceEnemy && selfData.AttackType == VJ.ATTACK_TYPE_RANGE) or ((selfData.LeapAttackAnimationFaceEnemy or (selfData.LeapAttackAnimationFaceEnemy == 2 && !selfData.LeapAttackHasJumped)) && selfData.AttackType == VJ.ATTACK_TYPE_LEAP))) then
			self:SetTurnTarget("Enemy")
			return
		end
	end
	
	if turnData.Type then
		-- If StopOnFace flag is set AND (Something has requested to take over by checking "ideal yaw != last set yaw") OR (we are facing ideal) then finish it!
		if turnData.StopOnFace && (self:GetIdealYaw() != turnData.LastYaw or self:IsFacingIdealYaw()) then
			self:ResetTurnTarget()
		else
			turnData.LastYaw = 0 -- To make sure the turning maintain works correctly
			local turnTarget = turnData.Target
			if turnData.Type == VJ.FACE_POSITION or (turnData.Type == VJ.FACE_POSITION_VISIBLE && self:VisibleVec(turnTarget)) then
				local resultAng = self:GetTurnAngle((turnTarget - self:GetPos()):Angle())
				if selfData.TurningUseAllAxis then
					local myAng = self:GetAngles()
					self:SetAngles(LerpAngle(FrameTime() * self:GetMaxYawSpeed(), myAng, Angle(resultAng.p, myAng.y, resultAng.r)))
				end
				self:SetIdealYawAndUpdate(resultAng.y)
				turnData.LastYaw = resultAng.y
			elseif IsValid(turnTarget) && (turnData.Type == VJ.FACE_ENTITY or (turnData.Type == VJ.FACE_ENTITY_VISIBLE && self:Visible(turnTarget))) then
				local resultAng;
				if selfData.TurningUseAllAxis then
					local myAng = self:GetAngles()
					resultAng = self:GetTurnAngle(((turnTarget:GetPos() + turnTarget:OBBCenter()) - self:GetPos()):Angle())
					self:SetAngles(LerpAngle(FrameTime() * self:GetMaxYawSpeed(), myAng, Angle(resultAng.p, myAng.y, resultAng.r)))
				else
					resultAng = self:GetTurnAngle((turnTarget:GetPos() - self:GetPos()):Angle())
				end
				self:SetIdealYawAndUpdate(resultAng.y)
				turnData.LastYaw = resultAng.y
			elseif eneValid && !selfData.Dead && (turnData.Type == VJ.FACE_ENEMY or (turnData.Type == VJ.FACE_ENEMY_VISIBLE && selfData.EnemyData.Visible)) then
				local resultAng;
				if selfData.TurningUseAllAxis then
					local myAng = self:GetAngles()
					resultAng = self:GetTurnAngle(((ene:GetPos() + ene:OBBCenter()) - self:GetPos()):Angle())
					self:SetAngles(LerpAngle(FrameTime() * self:GetMaxYawSpeed(), myAng, Angle(resultAng.p, myAng.y, resultAng.r)))
				else
					resultAng = self:GetTurnAngle((ene:GetPos() - self:GetPos()):Angle())
				end
				self:SetIdealYawAndUpdate(resultAng.y)
				turnData.LastYaw = resultAng.y
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Called whenever a task fails
-----------------------------------------------------------]]
function ENT:OnTaskFailed(failCode, failString)
	//VJ.DEBUG_Print(self, "OnTaskFailed", "warn", failCode, failString)
	local curSchedule = self.CurrentSchedule
	if curSchedule then
		//VJ.DEBUG_Print(self, "OnTaskFailed", "warn", "Run fail")
		-- Give it a very small delay to let the engine set its values before we continue
		timer.Simple(0.05, function()
			if IsValid(self) then
				local curScheduleNew = self.CurrentSchedule
				if curScheduleNew && curSchedule == curScheduleNew then -- Make sure the schedule hasn't changed!
					curSchedule = curScheduleNew
					if curSchedule.ResetOnFail then
						curSchedule.FailureHandled = true
						self:StopMoving()
						//self:SelectSchedule()
						//self:ClearCondition(COND_TASK_FAILED) -- Won't do anything, engine will set COND_TASK_FAILED right after
					end
					if failCode != 14 or (failCode == 14 && !self.UsePoseParameterMovement) then -- Skip this part for "FAIL_NO_ROUTE_ILLEGAL" to allow things like player model movement to work
						self:ClearGoal() -- Otherwise we may get stuck in movement (if schedule had a movement!)
						self:NextTask(curSchedule) -- Attempt to move on to the next task!
					end
					-- Handle "RunCode_OnFail"
					if !curSchedule.OnFailExecuted && curSchedule.RunCode_OnFail != nil then
						curSchedule.OnFailExecuted = true
						curSchedule.RunCode_OnFail(failCode, failString)
					end
				end
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnMovementFailed()
	//VJ.DEBUG_Print(self, "OnMovementFailed", "warn")
	-- Now handled in `OnTaskFailed`
	/*local curSchedule = self.CurrentSchedule
	if curSchedule != nil then
		if self:DoRunCode_OnFail(curSchedule) == true then
			self:ClearCondition(COND_TASK_FAILED)
		end
		if curSchedule.ResetOnFail then
			curSchedule.FailureHandled = true
			self:ClearCondition(COND_TASK_FAILED)
			self:StopMoving()
			//self:SelectSchedule()
		end
	end*/
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnMovementComplete()
	//VJ.DEBUG_Print(self, "OnMovementComplete")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnStateChange(oldState, newState)
	//VJ.DEBUG_Print(self, "OnStateChange", oldState, newState)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:TranslateNavGoal(ent, goal)
	//VJ.DEBUG_Print(self, "TranslateNavGoal", ent, goal)
	//VJ.DEBUG_TempEnt(goal)
	-- For "GOALTYPE_ENEMY" only
		-- Called every 0.1 seconds from here: https://github.com/ValveSoftware/source-sdk-2013/blob/master/src/game/server/ai_basenpc.cpp#L5790
		-- Use "GetPos", otherwise it will use "GetEnemyLastKnownPos", which is often incorrect location especially when sight is blocked!
	if self:GetCurGoalType() == 2 then
		//if self.EnemyData.Distance < 500 then // 120 for "SetArrivalDistance"
			-- Disabled for now as it causes movement stuttering when near the enemy
				-- Makes "GetGoalRepathTolerance" return 0 as seen here: https://github.com/ValveSoftware/source-sdk-2013/blob/master/src/game/server/ai_basenpc.cpp#L5756
				-- Otherwise it will go to the enemy only if certain tolerance is passed!
			//self:SetArrivalDistance((self:GetPos() - goal):Length())
			//return ent:GetPos() + ent:GetVelocity() -- Causes NPCs to move backwards when the enemy is moving towards them head on
		//end
		return ent:GetPos()
	end
	//return goal + ent:GetForward()*math.random(-100, 100)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:StartSchedule(schedule)
	local selfData = funcGetTable(self)
	if selfData.MovementType == VJ_MOVETYPE_STATIONARY && schedule.HasMovement then return end -- It's stationary therefore it should not move!
	-- Certain states should ONLY do animation schedules!
	if !schedule.IsPlayActivity then
		local curState = self:GetState()
		if curState >= VJ_STATE_ONLY_ANIMATION then return end
	end
	local curSchedule = selfData.CurrentSchedule
	if curSchedule then
		-- If it's the same task AND it's opening a door OR doing a move wait then cancel the new schedule!
		if schedule.Name == curSchedule.Name && (IsValid(self:GetInternalVariable("m_hOpeningDoor")) or self:GetMoveDelay() > 0) then
			return
		end
		-- Clean up any schedule it may have been doing
		if !selfData.Dead then
			self:ScheduleFinished(curSchedule)
		end
	end
	self:ClearCondition(COND_TASK_FAILED)
	//VJ.DEBUG_Print(self, "StartSchedule", schedule.Name)
	
	-- This stops movements from running if another NPC is stuck in it
	-- Pros:
		-- Successfully reduces lag when many NPCs are stuck in each other
	-- Cons:
		-- When using "BOUNDS_HITBOXES" for "SetSurroundingBoundsType", NPCs often end up inside each other, and this check causes movements to not run (NPCs end up freezing)
		-- Needed very rarely, not worth running a trace hull and table has value check for every movement task
	/*if schedule.HasMovement then
		local tr_addVec = Vector(0, 0, 2)
		local tr = util.TraceHull({
			start = self:GetPos(),
			endpos = self:GetPos(),
			mins = self:OBBMins() + tr_addVec,
			maxs = self:OBBMaxs() + tr_addVec,
			filter = self
		})
		if IsValid(tr.Entity) && tr.Entity:IsNPC() && !VJ.HasValue(selfData.EntitiesToNoCollide, tr.Entity:GetClass()) then
			self:DoRunCode_OnFail(schedule)
			return
		end
	end*/
	
	-- No longer needed, `TranslateActivity` handles it now
	//if schedule.CanShootWhenMoving && selfData.WeaponAttackAnim != nil && IsValid(self:GetEnemy()) then
		//self:DoWeaponAttackMovementCode(true, (schedule.MoveType == 0 and 1) or 0) -- Send 1 if the current task is walking!
		//self:SetArrivalActivity(selfData.WeaponAttackAnim)
	//end
	
	-- Handle facing data sent by schedule's "TurnData"
		-- Type = Type of facing it should do | Target = The vector/ent to face (Not required for enemy facing!)
	local turnData = schedule.TurnData
	if turnData then
		local faceType = turnData.Type
		if !selfData.CanTurnWhileMoving or !faceType then
			turnData = nil
		else
			local turnTarget = turnData.Target
			self:ResetTurnTarget()
			selfData.TurnData.Type = faceType
			selfData.TurnData.Target = isvector(turnTarget) and self:GetTurnAngle((turnTarget - self:GetPos()):Angle()) or turnTarget
			selfData.TurnData.IsSchedule = true
			selfData.TurnData.LastYaw = 1 -- So it doesn't face movement direction between move schedules, but should it be kept??
		end
	end
	
	-- Conditions that the NPC will ignore as long as this schedule is active, these will reset after schedule is finished!
	-- if you don't want it to reset on schedule finish then set & remove the conditions yourself outside of the schedule
	if schedule.IgnoreConditions then
		self:SetIgnoreConditions(schedule.IgnoreConditions)
	end
	
	-- Clear certain systems that should be notified that we have moved
	if schedule.HasMovement then
		selfData.LastHiddenZoneT = 0
		if !schedule.CanShootWhenMoving or selfData.WeaponAttackState == VJ.WEP_ATTACK_STATE_FIRE_STAND then // selfData.WeaponAttackState && selfData.WeaponAttackState >= VJ.WEP_ATTACK_STATE_FIRE
			selfData.WeaponAttackState = VJ.WEP_ATTACK_STATE_NONE
		end
		-- Movements shouldn't interrupt gestures
		if selfData.LastAnimType != VJ.ANIM_TYPE_GESTURE then
			selfData.LastAnimSeed = 0
		end
	end
	
	//if selfData.VJ_DEBUG then PrintTable(schedule) end
	selfData.CurrentSchedule = schedule
	selfData.CurrentScheduleName = schedule.Name
	selfData.CurrentTaskID = 1
	self:SetTask(schedule:GetTask(1))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoSchedule(schedule)
	if self:TaskFinished() then self:NextTask(schedule) end
	local curTask = self.CurrentTask
	if curTask then self:RunTask(curTask) end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:StopCurrentSchedule()
	local selfData = funcGetTable(self)
	local schedule = selfData.CurrentSchedule
	//VJ.DEBUG_Print(self, "StopCurrentSchedule", schedule)
	if schedule then
		timer.Remove("attack_pause_reset" .. self:EntIndex())
		selfData.NextIdleTime = 0
		selfData.NextChaseTime = 0
		selfData.AnimLockTime = 0
		self:ClearSchedule()
		self:ClearGoal()
		self:ScheduleFinished(schedule)
		//self:SelectSchedule()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ScheduleFinished(schedule)
	//VJ.DEBUG_Print(self, "ScheduleFinished", schedule)
	local selfData = funcGetTable(self)
	if schedule then
		-- Handle "RunCode_OnFinish"
		if !schedule.OnFinishExecuted && schedule.RunCode_OnFinish != nil then
			schedule.OnFinishExecuted = true
			schedule.RunCode_OnFinish()
		end
		-- Handle COND_TASK_FAILED, unless we have handled the failure case, we should keep the failure condition forever until it's handled or new schedule is ran
		if schedule.FailureHandled then
			self:ClearCondition(COND_TASK_FAILED)
		end
		-- Reset facing data if its based on a schedule!
		if selfData.TurnData.IsSchedule then
			self:ResetTurnTarget()
		end
		-- Clear ignored conditions from this schedule
		if schedule.IgnoreConditions then
			self:RemoveIgnoreConditions(schedule.IgnoreConditions)
		end
	end
	selfData.CurrentSchedule = nil
	selfData.CurrentScheduleName = nil
	selfData.CurrentTask = nil
	selfData.CurrentTaskID = nil
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetTask(task)
	local selfData = funcGetTable(self)
	selfData.CurrentTask = task
	selfData.CurrentTaskComplete = false
	selfData.TaskStartTime = CurTime()
	self:StartTask(selfData.CurrentTask)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:NextTask(schedule)
	//VJ.DEBUG_Print(self, "NextTask", schedule)
	local taskID = self.CurrentTaskID
	taskID = taskID + 1
	if taskID > schedule:NumTasks() then -- If this was the last task then finish up
		self:ScheduleFinished(schedule)
		return
	end
	self.CurrentTaskID = taskID
	self:SetTask(schedule:GetTask(taskID)) -- Switch to the next task
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Called every time a task is completed before moving onto to the next task
-----------------------------------------------------------]]
function ENT:OnTaskComplete()
	self.CurrentTaskComplete = true
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Whether or not the current task is finished
	Returns
		- boolean, true = task is finished
-----------------------------------------------------------]]
function ENT:TaskFinished()
	return self.CurrentTaskComplete
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Whether or not the current schedule is fully finished | Used internally by the base
		- schedule = The schedule to check for, should always be given "self.CurrentSchedule"!
	Returns
		- boolean, true = Schedule is finished
-----------------------------------------------------------]]
function ENT:IsScheduleFinished(schedule)
	local selfData = funcGetTable(self)
	return selfData.CurrentTaskComplete && (!selfData.CurrentTaskID or selfData.CurrentTaskID >= schedule:NumTasks())
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:StartTask(task)
	task:Start(self)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RunTask(task)
	task:Run(self)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:TaskTime()
	return CurTime() - self.TaskStartTime
end
-- Engine tasks / schedules ---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:StartEngineTask(iTaskID, taskData) end
function ENT:RunEngineTask(iTaskID, taskData) end
function ENT:StartEngineSchedule(scheduleID) self:ScheduleFinished() self.bDoingEngineSchedule = true end
function ENT:EngineScheduleFinish() self.bDoingEngineSchedule = nil end
function ENT:DoingEngineSchedule() return self.bDoingEngineSchedule end