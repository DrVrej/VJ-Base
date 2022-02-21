require("ai_vj_schedule")
/*-----------------------------------------------
	*** Copyright (c) 2012-2022 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:VJ_TASK_FACE_X(faceType, customFunc)
	-- Types: TASK_FACE_TARGET | TASK_FACE_ENEMY | TASK_FACE_PLAYER | TASK_FACE_LASTPOSITION | TASK_FACE_SAVEPOSITION | TASK_FACE_PATH | TASK_FACE_HINTNODE | TASK_FACE_IDEAL | TASK_FACE_REASONABLE
	if (self.MovementType == VJ_MOVETYPE_STATIONARY && self.CanTurnWhileStationary == false) or (self.IsVJBaseSNPC_Tank == true) then return end
	//self.NextIdleStandTime = CurTime() + 1.2
	local vschedFaceX = ai_vj_schedule.New("vj_face_x")
	vschedFaceX:EngTask(faceType or "TASK_FACE_TARGET", 0)
	if (customFunc) then customFunc(vschedFaceX) end
	self:StartSchedule(vschedFaceX)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:VJ_TASK_GOTO_LASTPOS(moveType, customFunc)
	if self.MovementType == VJ_MOVETYPE_AERIAL or self.MovementType == VJ_MOVETYPE_AQUATIC then
		self:AA_MoveTo(self:GetLastPosition(), true, (moveType == "TASK_RUN_PATH" and "Alert") or "Calm")
		return
	end
	local vsched = ai_vj_schedule.New("vj_goto_lastpos")
	vsched:EngTask("TASK_GET_PATH_TO_LASTPOSITION", 0)
	//vsched:EngTask(moveType, 0)
	vsched:EngTask("TASK_WAIT_FOR_MOVEMENT", 0)
	vsched.IsMovingTask = true
	if (moveType or "TASK_RUN_PATH") == "TASK_RUN_PATH" then self:SetMovementActivity(VJ_PICK(self.AnimTbl_Run)) vsched.MoveType = 1 else self:SetMovementActivity(VJ_PICK(self.AnimTbl_Walk)) vsched.MoveType = 0 end
	//self.CanDoSelectScheduleAgain = false
	//vsched.RunCode_OnFinish = function()
		//self.CanDoSelectScheduleAgain = true
	//end
	if (customFunc) then customFunc(vsched) end
	self:StartSchedule(vsched)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:VJ_TASK_GOTO_TARGET(moveType, customFunc)
	if self.MovementType == VJ_MOVETYPE_AERIAL or self.MovementType == VJ_MOVETYPE_AQUATIC then
		self:AA_MoveTo(self:GetTarget(), true, (moveType == "TASK_RUN_PATH" and "Alert") or "Calm")
		return
	end
	local vsched = ai_vj_schedule.New("vj_goto_target")
	vsched:EngTask("TASK_GET_PATH_TO_TARGET", 0)
	//vsched:EngTask(moveType, 0)
	vsched:EngTask("TASK_WAIT_FOR_MOVEMENT", 0)
	vsched:EngTask("TASK_FACE_TARGET", 1)
	vsched.IsMovingTask = true
	if (moveType or "TASK_RUN_PATH") == "TASK_RUN_PATH" then self:SetMovementActivity(VJ_PICK(self.AnimTbl_Run)) vsched.MoveType = 1 else self:SetMovementActivity(VJ_PICK(self.AnimTbl_Walk)) vsched.MoveType = 0 end
	if (customFunc) then customFunc(vsched) end
	self:StartSchedule(vsched)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:VJ_TASK_GOTO_PLAYER(moveType, customFunc)
	if self.MovementType == VJ_MOVETYPE_AERIAL or self.MovementType == VJ_MOVETYPE_AQUATIC then
		self:AA_MoveTo(self:GetTarget(), true, (moveType == "TASK_RUN_PATH" and "Alert") or "Calm")
		return
	end
	local vsched = ai_vj_schedule.New("vj_goto_player")
	vsched:EngTask("TASK_GET_PATH_TO_PLAYER", 0)
	//vsched:EngTask(moveType, 0)
	vsched:EngTask("TASK_WAIT_FOR_MOVEMENT", 0)
	vsched.IsMovingTask = true
	if (moveType or "TASK_RUN_PATH") == "TASK_RUN_PATH" then self:SetMovementActivity(VJ_PICK(self.AnimTbl_Run)) vsched.MoveType = 1 else self:SetMovementActivity(VJ_PICK(self.AnimTbl_Walk)) vsched.MoveType = 0 end
	if (customFunc) then customFunc(vsched) end
	self:StartSchedule(vsched)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:VJ_TASK_COVER_FROM_ENEMY(moveType, customFunc)
	if self.MovementType == VJ_MOVETYPE_AERIAL or self.MovementType == VJ_MOVETYPE_AQUATIC then self:AA_IdleWander() return end
	moveType = moveType or "TASK_RUN_PATH"
	local vsched = ai_vj_schedule.New("vj_cover_from_enemy")
	vsched:EngTask("TASK_FIND_COVER_FROM_ENEMY", 0)
	//vsched:EngTask(moveType, 0)
	vsched:EngTask("TASK_WAIT_FOR_MOVEMENT", 0)
	vsched.IsMovingTask = true
	if moveType == "TASK_RUN_PATH" then self:SetMovementActivity(VJ_PICK(self.AnimTbl_Run)) vsched.MoveType = 1 else self:SetMovementActivity(VJ_PICK(self.AnimTbl_Walk)) vsched.MoveType = 0 end
	vsched.RunCode_OnFail = function()
		//print("Cover from enemy failed!")
		local vschedFail = ai_vj_schedule.New("vj_cover_from_enemy_fail")
		vschedFail:EngTask("TASK_SET_ROUTE_SEARCH_TIME", 2)
		vschedFail:EngTask("TASK_GET_PATH_TO_RANDOM_NODE", 500)
		//vschedFail:EngTask(moveType, 0)
		vschedFail:EngTask("TASK_WAIT_FOR_MOVEMENT", 0)
		vschedFail.IsMovingTask = true
		if moveType == "TASK_RUN_PATH" then self:SetMovementActivity(VJ_PICK(self.AnimTbl_Run)) vschedFail.MoveType = 1 else self:SetMovementActivity(VJ_PICK(self.AnimTbl_Walk)) vschedFail.MoveType = 0 end
		if (customFunc) then customFunc(vschedFail) end
		self:StartSchedule(vschedFail)
	end
	if (customFunc) then customFunc(vsched) end
	self:StartSchedule(vsched)
end
---------------------------------------------------------------------------------------------------------------------------------------------
local task_idleWander = ai_vj_schedule.New("vj_idle_wander")
	//task_idleWander:EngTask("TASK_SET_ROUTE_SEARCH_TIME", 0)
	//task_idleWander:EngTask("TASK_GET_PATH_TO_LASTPOSITION", 0)
	task_idleWander:EngTask("TASK_GET_PATH_TO_RANDOM_NODE", 350)
	//task_idleWander:EngTask("TASK_WALK_PATH", 0)
	task_idleWander:EngTask("TASK_WAIT_FOR_MOVEMENT", 0)
	task_idleWander.ResetOnFail = true
	task_idleWander.CanBeInterrupted = true
	task_idleWander.IsMovingTask = true
	task_idleWander.MoveType = 0
	
function ENT:VJ_TASK_IDLE_WANDER()
	if self.MovementType == VJ_MOVETYPE_AERIAL or self.MovementType == VJ_MOVETYPE_AQUATIC then self:AA_IdleWander() return end
	self:SetMovementActivity(VJ_PICK(self.AnimTbl_Walk))
	//self:SetLastPosition(self:GetPos() + self:GetForward() * 300)
	self:StartSchedule(task_idleWander)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RunAI(strExp) -- Called from the engine every 0.1 seconds
	if self:GetState() == VJ_STATE_FREEZE or self:IsEFlagSet(EFL_IS_BEING_LIFTED_BY_BARNACLE) then self:MaintainActivity() return end
	//print("Running the RunAI")
	//self:SetArrivalActivity(ACT_COWER)
	//self:SetArrivalSpeed(1000)
	if self:IsRunningBehavior() or self:DoingEngineSchedule() then return true end
	-- Apply walk frames to sequences
	//print(self:GetSequenceMoveDist(self:GetSequence()))
	if self.VJ_PlayingSequence && self:GetSequenceMoveDist(self:GetSequence()) > 0 && !self:IsMoving() && !self:IsSequenceFinished() && self.MovementType != VJ_MOVETYPE_AERIAL && self.MovementType != VJ_MOVETYPE_AQUATIC then
		self:AutoMovement(self:GetAnimTimeInterval())
	end
	self:RunAIMoveJump()
	if (!self.CurrentSchedule or (self.CurrentSchedule != nil && ((self:IsMoving() && self.CurrentSchedule.CanBeInterrupted == true) or (!self:IsMoving())))) && ((self.VJ_PlayingSequence == false) or (self.VJ_PlayingSequence == true && self.VJ_PlayingInterruptSequence == true)) then self:SelectSchedule() end
	if (self.CurrentSchedule) then self:DoSchedule(self.CurrentSchedule) end
	if self.VJ_PlayingSequence == false && self.VJ_PlayingInterruptSequence == false then self:MaintainActivity() end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RunAIMoveJump()
	if self:GetNavType() != NAV_JUMP then return end
	if self:OnGround() then
		self:MoveJumpStop()
		if VJ_AnimationExists(self, ACT_LAND) then
			self.NextIdleStandTime = CurTime() + self:SequenceDuration(self:GetSequence()) - 0.1
		end
		self:SetNavType(NAV_GROUND)
		self:ClearGoal()
	else
		self:MoveJumpExec()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoRunCode_OnFail(schedule)
	if schedule == nil or schedule.AlreadyRanCode_OnFail == true then return false end
	if schedule.RunCode_OnFail != nil && IsValid(self) then schedule.AlreadyRanCode_OnFail = true schedule.RunCode_OnFail() return true end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoRunCode_OnFinish(schedule)
	if schedule == nil or schedule.AlreadyRanCode_OnFinish == true then return false end
	if schedule.RunCode_OnFinish != nil && IsValid(self) then schedule.AlreadyRanCode_OnFinish = true schedule.RunCode_OnFinish() return true end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnMovementFailed()
	//print("VJ Base: Movement Failed! "..self:GetName())
	local curSchedule = self.CurrentSchedule
	if curSchedule != nil then
		if self:DoRunCode_OnFail(curSchedule) == true then
			self:ClearCondition(35)
		end
		if curSchedule.ResetOnFail == true then
			self:ClearCondition(35)
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
local tr_addvec = Vector(0, 0, 2)
local tasksRun = {TASK_RUN_PATH=true, TASK_RUN_PATH_FLEE=true, TASK_RUN_PATH_TIMED=true, TASK_RUN_PATH_FOR_UNITS=true, TASK_RUN_PATH_WITHIN_DIST=true}
local tasksWalk = {TASK_WALK_PATH=true, TASK_WALK_PATH_TIMED=true, TASK_WALK_PATH_FOR_UNITS=true, TASK_WALK_PATH_WITHIN_DIST=true}
--
function ENT:StartSchedule(schedule)
	if self.MovementType == VJ_MOVETYPE_STATIONARY && schedule.IsMovingTask == true then return end -- It's stationary therefore should not move!
	if (self:GetState() == VJ_STATE_ONLY_ANIMATION or self:GetState() == VJ_STATE_ONLY_ANIMATION_CONSTANT or self:GetState() == VJ_STATE_ONLY_ANIMATION_NOATTACK) && schedule.IsPlayActivity != true then return end
	if (IsValid(self:GetInternalVariable("m_hOpeningDoor")) or self:GetInternalVariable("m_flMoveWaitFinished") > 0) && self.CurrentSchedule != nil && schedule.Name == self.CurrentSchedule.Name then return end -- If it's the same task and it's opening a door, then DO NOT continue
	self:ClearCondition(35)
	if (!schedule.RunCode_OnFail) then schedule.RunCode_OnFail = nil end -- Code that will run ONLY when it fails!
	if (!schedule.RunCode_OnFinish) then schedule.RunCode_OnFinish = nil end -- Code that will run once the task finished (Will run even if failed)
	if (!schedule.ResetOnFail) then schedule.ResetOnFail = false end -- Makes the NPC stop moving if it fails
	if (!schedule.StopScheduleIfNotMoving) then schedule.StopScheduleIfNotMoving = false end -- Will stop from certain entities, such as other NPCs
	if (!schedule.StopScheduleIfNotMoving_Any) then schedule.StopScheduleIfNotMoving_Any = false end -- Will stop from any blocking entity!
	if (!schedule.CanBeInterrupted) then schedule.CanBeInterrupted = false end
	if (!schedule.ConstantlyFaceEnemy) then schedule.ConstantlyFaceEnemy = false end -- Constantly face the enemy while doing this task
	if (!schedule.ConstantlyFaceEnemyVisible) then schedule.ConstantlyFaceEnemyVisible = false end
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
	if schedule.IsMovingTask == true then
		local tr = util.TraceHull({
			start = self:GetPos(),
			endpos = self:GetPos(),
			mins = self:OBBMins() + tr_addvec,
			maxs = self:OBBMaxs() + tr_addvec,
			filter = self
		})
		if IsValid(tr.Entity) && tr.Entity:IsNPC() && !VJ_HasValue(self.EntitiesToNoCollide, tr.Entity:GetClass()) then
			self:DoRunCode_OnFail(schedule)
			return
		end
		self.LastHiddenZoneT = 0
		self.CurAnimationSeed = 0
	end
	if schedule.CanShootWhenMoving == true && self.CurrentWeaponAnimation != nil && IsValid(self:GetEnemy()) then
		self:DoWeaponAttackMovementCode(true, (schedule.MoveType == 0 and 1) or 0) -- Send 1 if the current task is walking!
		self:SetArrivalActivity(self.CurrentWeaponAnimation)
	end
	schedule.AlreadyRanCode_OnFail = false
	schedule.AlreadyRanCode_OnFinish = false
	// lua_run PrintTable(Entity(1):GetEyeTrace().Entity.CurrentSchedule)
	//PrintTable(schedule)
	//if schedule.Name != "vj_chase_enemy" then PrintTable(schedule) end
	if self.Dead == false then self:DoRunCode_OnFinish(self.CurrentSchedule) end -- Yete arten schedule garne, verchatsoor
	self.CurrentSchedule = schedule
	self.CurrentTaskID = 1
	self.GetNumberOfTasks = tonumber(schedule:NumTasks()) -- Or else nil
	self:SetTask(schedule:GetTask(1))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoSchedule(schedule)
	if self:TaskFinished() then self:NextTask(schedule) end
	if self.CurrentTask then self:RunTask(self.CurrentTask) end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ScheduleFinished(schedule)
	schedule = schedule or self.CurrentSchedule
	self:DoRunCode_OnFinish(schedule)
	self.CurrentSchedule = nil
	self.CurrentTask = nil
	self.CurrentTaskID = nil
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetTask(task)
	self.CurrentTask = task
	self.bTaskComplete = false
	self.TaskStartTime = CurTime()
	self:StartTask(self.CurrentTask)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:NextTask(schedule)
	//print(self.GetNumberOfTasks)
	//print(self.CurrentTaskID)
	if !schedule or !self then return end
	if self.GetNumberOfTasks == nil then //1
		print("VJ Base Schedules: Number of tasks is nil!")
	end
	//print("Running NextTask")
	self.CurrentTaskID = self.CurrentTaskID + 1
	if (self.CurrentTaskID > self.GetNumberOfTasks) then
		self:ScheduleFinished(schedule)
		return
	end
	self:SetTask(schedule:GetTask(self.CurrentTaskID))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnTaskComplete()
	//self:DoRunCode_OnFinish(self.CurrentSchedule) -- Will break many movement tasks (Ex: Humans Taking cover to reload)
	self.bTaskComplete = true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:StartTask(task) if task == nil or !task or !self then return end task:Start(self) end
function ENT:RunTask(task) if !task or !self then return end task:Run(self) end
function ENT:TaskTime() return CurTime() - self.TaskStartTime end
function ENT:TaskFinished() return self.bTaskComplete end
function ENT:StartEngineTask(iTaskID,TaskData) end
function ENT:RunEngineTask(iTaskID,TaskData) end
function ENT:StartEngineSchedule(scheduleID) self:ScheduleFinished() self.bDoingEngineSchedule = true end
function ENT:EngineScheduleFinish() self.bDoingEngineSchedule = nil end
function ENT:DoingEngineSchedule() return self.bDoingEngineSchedule end