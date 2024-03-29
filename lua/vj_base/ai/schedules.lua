require("vj_ai_schedule")
/*-----------------------------------------------
	*** Copyright (c) 2012-2023 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:VJ_TASK_FACE_X(faceType, customFunc)
	-- Types: TASK_FACE_TARGET | TASK_FACE_ENEMY | TASK_FACE_PLAYER | TASK_FACE_LASTPOSITION | TASK_FACE_SAVEPOSITION | TASK_FACE_PATH | TASK_FACE_HINTNODE | TASK_FACE_IDEAL | TASK_FACE_REASONABLE
	if (self.MovementType == VJ_MOVETYPE_STATIONARY && self.CanTurnWhileStationary == false) or (self.IsVJBaseSNPC_Tank == true) then return end
	//self.NextIdleStandTime = CurTime() + 1.2
	local schedFace = vj_ai_schedule.New("vj_face_x")
	schedFace:EngTask(faceType or "TASK_FACE_TARGET", 0)
	if (customFunc) then customFunc(schedFace) end
	self:StartSchedule(schedFace)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:VJ_TASK_GOTO_LASTPOS(moveType, customFunc)
	if self.MovementType == VJ_MOVETYPE_AERIAL or self.MovementType == VJ_MOVETYPE_AQUATIC then
		self:AA_MoveTo(self:GetLastPosition(), true, (moveType == "TASK_RUN_PATH" and "Alert") or "Calm")
		return
	end
	local schedGoToLastPos = vj_ai_schedule.New("vj_goto_lastpos")
	schedGoToLastPos:EngTask("TASK_GET_PATH_TO_LASTPOSITION", 0)
	//schedGoToLastPos:EngTask(moveType, 0)
	schedGoToLastPos:EngTask("TASK_WAIT_FOR_MOVEMENT", 0)
	schedGoToLastPos.IsMovingTask = true
	if (moveType or "TASK_RUN_PATH") == "TASK_RUN_PATH" then self:SetMovementActivity(VJ.PICK(self.AnimTbl_Run)) schedGoToLastPos.MoveType = 1 else self:SetMovementActivity(VJ.PICK(self.AnimTbl_Walk)) schedGoToLastPos.MoveType = 0 end
	if (customFunc) then customFunc(schedGoToLastPos) end
	self:StartSchedule(schedGoToLastPos)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:VJ_TASK_GOTO_TARGET(moveType, customFunc)
	if self.MovementType == VJ_MOVETYPE_AERIAL or self.MovementType == VJ_MOVETYPE_AQUATIC then
		self:AA_MoveTo(self:GetTarget(), true, (moveType == "TASK_RUN_PATH" and "Alert") or "Calm")
		return
	end
	local schedGoToTarget = vj_ai_schedule.New("vj_goto_target")
	schedGoToTarget:EngTask("TASK_GET_PATH_TO_TARGET", 0)
	//schedGoToTarget:EngTask(moveType, 0)
	schedGoToTarget:EngTask("TASK_WAIT_FOR_MOVEMENT", 0)
	schedGoToTarget:EngTask("TASK_FACE_TARGET", 1)
	schedGoToTarget.IsMovingTask = true
	if (moveType or "TASK_RUN_PATH") == "TASK_RUN_PATH" then self:SetMovementActivity(VJ.PICK(self.AnimTbl_Run)) schedGoToTarget.MoveType = 1 else self:SetMovementActivity(VJ.PICK(self.AnimTbl_Walk)) schedGoToTarget.MoveType = 0 end
	if (customFunc) then customFunc(schedGoToTarget) end
	self:StartSchedule(schedGoToTarget)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:VJ_TASK_GOTO_PLAYER(moveType, customFunc)
	if self.MovementType == VJ_MOVETYPE_AERIAL or self.MovementType == VJ_MOVETYPE_AQUATIC then
		self:AA_MoveTo(self:GetTarget(), true, (moveType == "TASK_RUN_PATH" and "Alert") or "Calm")
		return
	end
	local schedGoToPlayer = vj_ai_schedule.New("vj_goto_player")
	schedGoToPlayer:EngTask("TASK_GET_PATH_TO_PLAYER", 0)
	//schedGoToPlayer:EngTask(moveType, 0)
	schedGoToPlayer:EngTask("TASK_WAIT_FOR_MOVEMENT", 0)
	schedGoToPlayer.IsMovingTask = true
	if (moveType or "TASK_RUN_PATH") == "TASK_RUN_PATH" then self:SetMovementActivity(VJ.PICK(self.AnimTbl_Run)) schedGoToPlayer.MoveType = 1 else self:SetMovementActivity(VJ.PICK(self.AnimTbl_Walk)) schedGoToPlayer.MoveType = 0 end
	if (customFunc) then customFunc(schedGoToPlayer) end
	self:StartSchedule(schedGoToPlayer)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:VJ_TASK_COVER_FROM_ENEMY(moveType, customFunc)
	if self.MovementType == VJ_MOVETYPE_AERIAL or self.MovementType == VJ_MOVETYPE_AQUATIC then self:AA_IdleWander() return end
	moveType = moveType or "TASK_RUN_PATH"
	local schedCoverFromEnemy = vj_ai_schedule.New("vj_cover_from_enemy")
	schedCoverFromEnemy:EngTask("TASK_FIND_COVER_FROM_ORIGIN", 0)
	//schedCoverFromEnemy:EngTask(moveType, 0)
	schedCoverFromEnemy:EngTask("TASK_WAIT_FOR_MOVEMENT", 0)
	schedCoverFromEnemy.IsMovingTask = true
	if moveType == "TASK_RUN_PATH" then self:SetMovementActivity(VJ.PICK(self.AnimTbl_Run)) schedCoverFromEnemy.MoveType = 1 else self:SetMovementActivity(VJ.PICK(self.AnimTbl_Walk)) schedCoverFromEnemy.MoveType = 0 end
	schedCoverFromEnemy.RunCode_OnFail = function()
		//print("Cover from enemy failed!")
		local schedFailCoverFromEnemy = vj_ai_schedule.New("vj_cover_from_enemy_fail")
		schedFailCoverFromEnemy:EngTask("TASK_SET_ROUTE_SEARCH_TIME", 2)
		schedFailCoverFromEnemy:EngTask("TASK_GET_PATH_TO_RANDOM_NODE", 500)
		//schedFailCoverFromEnemy:EngTask(moveType, 0)
		schedFailCoverFromEnemy:EngTask("TASK_WAIT_FOR_MOVEMENT", 0)
		schedFailCoverFromEnemy.IsMovingTask = true
		if moveType == "TASK_RUN_PATH" then self:SetMovementActivity(VJ.PICK(self.AnimTbl_Run)) schedFailCoverFromEnemy.MoveType = 1 else self:SetMovementActivity(VJ.PICK(self.AnimTbl_Walk)) schedFailCoverFromEnemy.MoveType = 0 end
		if (customFunc) then customFunc(schedFailCoverFromEnemy) end
		self:StartSchedule(schedFailCoverFromEnemy)
	end
	if (customFunc) then customFunc(schedCoverFromEnemy) end
	self:StartSchedule(schedCoverFromEnemy)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:VJ_TASK_COVER_FROM_ORIGIN(moveType, customFunc)
	if self.MovementType == VJ_MOVETYPE_AERIAL or self.MovementType == VJ_MOVETYPE_AQUATIC then self:AA_IdleWander() return end
	moveType = moveType or "TASK_RUN_PATH"
	local schedCoverFromOrigin = vj_ai_schedule.New("vj_cover_from_origin")
	schedCoverFromOrigin:EngTask("TASK_FIND_COVER_FROM_ORIGIN", 0)
	//schedCoverFromOrigin:EngTask(moveType, 0)
	schedCoverFromOrigin:EngTask("TASK_WAIT_FOR_MOVEMENT", 0)
	schedCoverFromOrigin.IsMovingTask = true
	if moveType == "TASK_RUN_PATH" then self:SetMovementActivity(VJ.PICK(self.AnimTbl_Run)) schedCoverFromOrigin.MoveType = 1 else self:SetMovementActivity(VJ.PICK(self.AnimTbl_Walk)) schedCoverFromOrigin.MoveType = 0 end
	schedCoverFromOrigin.RunCode_OnFail = function()
		local schedFailCoverFromOrigin = vj_ai_schedule.New("vj_cover_from_origin_fail")
		schedFailCoverFromOrigin:EngTask("TASK_SET_ROUTE_SEARCH_TIME", 2)
		schedFailCoverFromOrigin:EngTask("TASK_GET_PATH_TO_RANDOM_NODE", 500)
		//schedFailCoverFromOrigin:EngTask(moveType, 0)
		schedFailCoverFromOrigin:EngTask("TASK_WAIT_FOR_MOVEMENT", 0)
		schedFailCoverFromOrigin.IsMovingTask = true
		if moveType == "TASK_RUN_PATH" then self:SetMovementActivity(VJ.PICK(self.AnimTbl_Run)) schedFailCoverFromOrigin.MoveType = 1 else self:SetMovementActivity(VJ.PICK(self.AnimTbl_Walk)) schedFailCoverFromOrigin.MoveType = 0 end
		if (customFunc) then customFunc(schedFailCoverFromOrigin) end
		self:StartSchedule(schedFailCoverFromOrigin)
	end
	if (customFunc) then customFunc(schedCoverFromOrigin) end
	self:StartSchedule(schedCoverFromOrigin)
end
---------------------------------------------------------------------------------------------------------------------------------------------
local schedIdleWander = vj_ai_schedule.New("vj_idle_wander")
	//schedIdleWander:EngTask("TASK_SET_ROUTE_SEARCH_TIME", 0)
	//schedIdleWander:EngTask("TASK_GET_PATH_TO_LASTPOSITION", 0)
	schedIdleWander:EngTask("TASK_GET_PATH_TO_RANDOM_NODE", 350)
	//schedIdleWander:EngTask("TASK_WALK_PATH", 0)
	schedIdleWander:EngTask("TASK_WAIT_FOR_MOVEMENT", 0)
	schedIdleWander.ResetOnFail = true
	schedIdleWander.CanBeInterrupted = true
	schedIdleWander.IsMovingTask = true
	schedIdleWander.MoveType = 0
	
function ENT:VJ_TASK_IDLE_WANDER()
	if self.MovementType == VJ_MOVETYPE_AERIAL or self.MovementType == VJ_MOVETYPE_AQUATIC then self:AA_IdleWander() return end
	self:SetMovementActivity(VJ.PICK(self.AnimTbl_Walk))
	//self:SetLastPosition(self:GetPos() + self:GetForward() * 300)
	self:StartSchedule(schedIdleWander)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:TASK_VJ_PLAY_ACTIVITY(taskStatus, data)
	if taskStatus == TASKSTATUS_NEW then
		//print("TASK_VJ_PLAY_ACTIVITY: Start!", data.duration)
		self:ResetIdealActivity(data.animation)
		data.animEndTime = CurTime() + data.duration
		//self:AutoMovement(self:GetAnimTimeInterval()) -- Causes extra walk frame to be applied, especially when switching from movement to animation
	else
		//self:AutoMovement(self:GetAnimTimeInterval())
		if (CurTime() > data.animEndTime) or (self:IsSequenceFinished() && self:GetSequence() == self:GetInternalVariable("m_nIdealSequence")) then
			//print("TASK_VJ_PLAY_ACTIVITY: Stop!")
			self:TaskComplete()
			return
		end
		//print("TASK_VJ_PLAY_ACTIVITY: Run!")
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:TASK_VJ_PLAY_SEQUENCE(taskStatus, data)
	if taskStatus == TASKSTATUS_NEW then
		//print("TASK_VJ_PLAY_SEQUENCE: Start!", data.duration)
		data.seqID = self:VJ_PlaySequence(data.animation, data.playbackRate)
		data.animEndTime = CurTime() + data.duration
	else
		if (CurTime() > data.animEndTime) or (self:IsSequenceFinished()) or (data.seqID != self:GetSequence()) then
			//print("TASK_VJ_PLAY_SEQUENCE: Stop!")
			self:TaskComplete()
			return
		end
		//print("TASK_VJ_PLAY_SEQUENCE: Run!")
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RunAI(strExp) -- Called from the engine every 0.1 seconds
	if self:GetState() == VJ_STATE_FREEZE or self:IsEFlagSet(EFL_IS_BEING_LIFTED_BY_BARNACLE) then self:MaintainActivity() return end
	if self:IsRunningBehavior() or self:DoingEngineSchedule() then return true end -- true = Run "MaintainSchedule" in engine
	//self:SetArrivalActivity(ACT_COWER)
	//self:SetArrivalSpeed(1000)
	
	-- Maintain and handle jumping movements
	if self:GetNavType() == NAV_JUMP then
		if self:OnGround() then
			self:MoveJumpStop()
			if VJ.AnimExists(self, ACT_LAND) then
				self.NextIdleStandTime = CurTime() + self:SequenceDuration(self:GetSequence()) - 0.1
			end
			self:SetNavType(NAV_GROUND)
			self:ClearGoal()
		else
			self:MoveJumpExec()
		end
	end
	
	-- Apply walk frames to both activities and sequences
	-- Parts of it replicate TASK_PLAY_SEQUENCE - https://github.com/ValveSoftware/source-sdk-2013/blob/master/mp/src/game/server/ai_basenpc_schedule.cpp#L3312
	if !self:IsSequenceFinished() && !self:IsMoving() && ((self:GetSequence() == self:GetInternalVariable("m_nIdealSequence")) or (self:GetActivity() == ACT_DO_NOT_DISTURB)) && self:GetSequenceMoveDist(self:GetSequence()) > 0 && self.MovementType != VJ_MOVETYPE_AERIAL && self.MovementType != VJ_MOVETYPE_AQUATIC then
		self:AutoMovement(self:GetAnimTimeInterval())
	end
	
	local curSched = self.CurrentSchedule
	
	-- If we are currently running a schedule then run it otherwise call SelectSchedule to decide what to do next
	if curSched then
		self:DoSchedule(curSched)
		if curSched.CanBeInterrupted or (self:IsScheduleFinished(curSched)) or (curSched.IsMovingTask && !self:IsMoving()) then
			self:SelectSchedule()
		end
	else
		self:SelectSchedule()
	end
	
	//if !self.VJ_PlayingSequence then -- No longer needed for sequences as it is handled by ACT_DO_NOT_DISTURB
	self:MaintainActivity()
	//end
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Called whenever a task fails
		- failCode = 
-----------------------------------------------------------]]
function ENT:OnTaskFailed(failCode, failString)
	//print("task failed:", failCode, failString)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoRunCode_OnFail(schedule)
	if schedule == nil or schedule.AlreadyRanCode_OnFail == true then return false end
	if schedule.RunCode_OnFail != nil && IsValid(self) then schedule.AlreadyRanCode_OnFail = true schedule.RunCode_OnFail() return true end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnMovementFailed()
	//print("VJ Base: Movement Failed! "..self:GetName())
	local curSchedule = self.CurrentSchedule
	if curSchedule != nil then
		if self:DoRunCode_OnFail(curSchedule) == true then
			self:ClearCondition(COND_TASK_FAILED)
		end
		if curSchedule.ResetOnFail == true then
			self:ClearCondition(COND_TASK_FAILED)
			self:StopMoving()
			//self:SelectSchedule()
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnMovementComplete()
	//print("Movement completed!")
end
---------------------------------------------------------------------------------------------------------------------------------------------
-- lua_run PrintTable(Entity(1):GetEyeTrace().Entity.CurrentSchedule)
local tasksRun = {TASK_RUN_PATH=true, TASK_RUN_PATH_FLEE=true, TASK_RUN_PATH_TIMED=true, TASK_RUN_PATH_FOR_UNITS=true, TASK_RUN_PATH_WITHIN_DIST=true}
local tasksWalk = {TASK_WALK_PATH=true, TASK_WALK_PATH_TIMED=true, TASK_WALK_PATH_FOR_UNITS=true, TASK_WALK_PATH_WITHIN_DIST=true}
--
function ENT:StartSchedule(schedule)
	if self.MovementType == VJ_MOVETYPE_STATIONARY && schedule.IsMovingTask == true then return end -- It's stationary therefore should not move!
	if (self:GetState() == VJ_STATE_ONLY_ANIMATION or self:GetState() == VJ_STATE_ONLY_ANIMATION_CONSTANT or self:GetState() == VJ_STATE_ONLY_ANIMATION_NOATTACK) && !schedule.IsPlayActivity then return end
	local curSched = self.CurrentSchedule
	if (IsValid(self:GetInternalVariable("m_hOpeningDoor")) or self:GetInternalVariable("m_flMoveWaitFinished") > 0) && curSched && schedule.Name == curSched.Name then return end -- If it's the same task and it's opening a door, then DO NOT continue
	//print("StartSchedule:", schedule.Name)
	-- Clean up any schedule it may have been doing
	if curSched && !self.Dead then
		self:ScheduleFinished(self.CurrentSchedule)
	end
	self:ClearCondition(COND_TASK_FAILED)
	if (!schedule.RunCode_OnFail) then schedule.RunCode_OnFail = nil end -- Code that will run ONLY when it fails!
	if (!schedule.RunCode_OnFinish) then schedule.RunCode_OnFinish = nil end -- Code that will run once the task finished (Will run even if failed)
	if (!schedule.ResetOnFail) then schedule.ResetOnFail = false end -- Makes the NPC stop moving if it fails
	if (!schedule.StopScheduleIfNotMoving) then schedule.StopScheduleIfNotMoving = false end -- Will stop from certain entities, such as other NPCs
	if (!schedule.StopScheduleIfNotMoving_Any) then schedule.StopScheduleIfNotMoving_Any = false end -- Will stop from any blocking entity!
	if (!schedule.CanBeInterrupted) then schedule.CanBeInterrupted = false end
	if (!schedule.CanShootWhenMoving) then schedule.CanShootWhenMoving = false end -- Is it able to fire when moving?
	if !schedule.IsMovingTask then
		for _,v in ipairs(schedule.Tasks) do
			if tasksRun[v.TaskName] then
				schedule.IsMovingTask = true
				schedule.MoveType = 1
				break
			elseif tasksWalk[v.TaskName] then
				schedule.IsMovingTask = true
				schedule.MoveType = 0
				break
			else
				schedule.IsMovingTask = false
				schedule.MoveType = false
			end
		end
	end
	if schedule.IsMovingTask == nil then schedule.IsMovingTask = false end
	if schedule.MoveType == nil then schedule.MoveType = false end
	-- This stops movements from running if another NPC is stuck in it
	-- Pros:
		-- Successfully reduces lag when many NPCs are stuck in each other
	-- Cons:
		-- When using "BOUNDS_HITBOXES" for "SetSurroundingBoundsType", NPCs often end up inside each other, and this check causes movements to not run (NPCs end up freezing)
		-- Needed very rarely, not worth running a trace hull and table has value check for every movement task
	/*if schedule.IsMovingTask == true then
		local tr_addVec = Vector(0, 0, 2)
		local tr = util.TraceHull({
			start = self:GetPos(),
			endpos = self:GetPos(),
			mins = self:OBBMins() + tr_addVec,
			maxs = self:OBBMaxs() + tr_addVec,
			filter = self
		})
		if IsValid(tr.Entity) && tr.Entity:IsNPC() && !VJ.HasValue(self.EntitiesToNoCollide, tr.Entity:GetClass()) then
			self:DoRunCode_OnFail(schedule)
			return
		end
		self.LastHiddenZoneT = 0
		self.CurAnimationSeed = 0
	end*/
	if schedule.CanShootWhenMoving == true && self.CurrentWeaponAnimation != nil && IsValid(self:GetEnemy()) then
		self:DoWeaponAttackMovementCode(true, (schedule.MoveType == 0 and 1) or 0) -- Send 1 if the current task is walking!
		self:SetArrivalActivity(self.CurrentWeaponAnimation)
	end
	
	-- Handle facing data sent by "FaceData"
		-- Type = Type of facing it should do | Target = The vector/ent to face (Not required for enemy facing!)
	local turnData = schedule.FaceData
	if turnData then
		local faceType = turnData.Type
		if !self.CanTurnWhileMoving or !faceType then
			turnData = nil
		else
			local turnTarget = turnData.Target
			self:ResetTurnTarget()
			self.TurnData.Type = faceType
			self.TurnData.Target = isvector(turnTarget) and self:GetFaceAngle((turnTarget - self:GetPos()):Angle()) or turnTarget
			self.TurnData.IsSchedule = true
		end
	end
	
	-- Conditions that the NPC will ignore as long as this schedule is active, these will reset after schedule is finished!
	-- if you don't want it to reset on schedule finish then set & remove the conditions yourself outside of the schedule
	if schedule.IgnoreConditions then
		self:SetIgnoreConditions(schedule.IgnoreConditions)
	end
	
	schedule.AlreadyRanCode_OnFail = false
	schedule.AlreadyRanCode_OnFinish = false
	//if self.VJ_DEBUG == true then PrintTable(schedule) end
	self.CurrentSchedule = schedule
	self.CurrentTaskID = 1
	self:SetTask(schedule:GetTask(1))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoSchedule(schedule)
	if self:TaskFinished() then self:NextTask(schedule) end
	if self.CurrentTask then self:RunTask(self.CurrentTask) end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ScheduleFinished(schedule)
	if schedule then
		-- Handle "RunCode_OnFinish"
		if !schedule.AlreadyRanCode_OnFinish && schedule.RunCode_OnFinish != nil then
			schedule.AlreadyRanCode_OnFinish = true
			schedule.RunCode_OnFinish()
		end
		-- Reset facing data if its based on a schedule!
		if self.TurnData.IsSchedule then
			self:ResetTurnTarget()
		end
		-- Clear ignored conditions from this schedule
		if schedule.IgnoreConditions then
			self:RemoveIgnoreConditions(schedule.IgnoreConditions)
		end
	end
	self.CurrentSchedule = nil
	self.CurrentTask = nil
	self.CurrentTaskID = nil
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetTask(task)
	self.CurrentTask = task
	self.CurrentTaskComplete = false
	self.TaskStartTime = CurTime()
	self:StartTask(self.CurrentTask)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:NextTask(schedule)
	//print("Running NextTask")
	self.CurrentTaskID = self.CurrentTaskID + 1
	if (self.CurrentTaskID > schedule:NumTasks()) then -- If this was the last task then finish up
		self:ScheduleFinished(schedule)
		return
	end
	self:SetTask(schedule:GetTask(self.CurrentTaskID)) -- Switch to the next task
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
	return self.CurrentTaskComplete && (!self.CurrentTaskID or self.CurrentTaskID >= schedule:NumTasks())
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:StartTask(task) if !task or !self then return end task:Start(self) end
function ENT:RunTask(task) if !task or !self then return end task:Run(self) end
function ENT:TaskTime() return CurTime() - self.TaskStartTime end
-- Engine tasks / schedules ---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:StartEngineTask(iTaskID, taskData) end
function ENT:RunEngineTask(iTaskID, taskData) end
function ENT:StartEngineSchedule(scheduleID) self:ScheduleFinished() self.bDoingEngineSchedule = true end
function ENT:EngineScheduleFinish() self.bDoingEngineSchedule = nil end
function ENT:DoingEngineSchedule() return self.bDoingEngineSchedule end