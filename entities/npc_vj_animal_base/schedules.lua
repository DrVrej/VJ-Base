require("ai_vj_schedule")
/*-----------------------------------------------
	*** Copyright (c) 2012-2016 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
function ENT:RunAI(strExp) -- Called from the engine every 0.1 seconds
	//print("Running the RunAI")
	//self:SetArrivalActivity(ACT_COWER)
	//self:SetArrivalSpeed(1000)
	if (self:IsRunningBehavior()) then return true end
	if (self:DoingEngineSchedule()) then return true end -- SCHED_
	//if VJ_IsCurrentAnimation(self,ACT_IDLE) && self.VJ_PlayingSequence == false && self.VJ_IsPlayingInterruptSequence == false then print("is ACT_IDLE!") self:VJ_ACT_PLAYACTIVITY(ACT_COWER,false,0,true,0,{AlwaysUseSequence=true,SequenceDuration=false,SequenceInterruptible=true}) end
	if (!self.CurrentSchedule) && self.VJ_PlayingSequence == false /*&& self.VJ_IsPlayingInterruptSequence == false*/ then self:SelectSchedule() end
	if (self.CurrentSchedule) then self:DoSchedule(self.CurrentSchedule) end
	if self.VJ_PlayingSequence == false && self.VJ_IsPlayingInterruptSequence == false && self.ShouldBeFlying == false /*&& self:GetSequence() != self.AerialCurrentAnim && self.MovementType != VJ_MOVETYPE_AERIAL*/ then self:MaintainActivity() end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SelectSchedule(iNPCState)
	if self.VJ_PlayingSequence == true /*or self.VJ_IsPlayingInterruptSequence == true*/ then return end
	//if self.MovementType == VJ_MOVETYPE_AERIAL then return end
	//self:VJ_SetSchedule(SCHED_IDLE_STAND)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:StartSchedule(schedule)
	self.CurrentSchedule 	= schedule
	self.CurrentTaskID 		= 1
	self.GetNumberOfTasks = tonumber(schedule:NumTasks()) -- Or else nil
	self:SetTask(schedule:GetTask(1))
end
---------------------------------------------------------------------------------------------------------------------------------------------
/*function ENT:DoSchedule(schedule)
	if (self.CurrentTask) then self:RunTask(self.CurrentTask) end
	if (self:TaskFinished()) then self:NextTask(schedule) end
end*/
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ScheduleFinished()
	self.CurrentSchedule 	= nil
	self.CurrentTask 		= nil
	self.CurrentTaskID 		= nil
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetTask(task)
	self.CurrentTask 	= task
	self.bTaskComplete 	= false
	self.TaskStartTime 	= CurTime()
	self:StartTask(self.CurrentTask)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:NextTask(schedule)
	//print(self.GetNumberOfTasks)
	//print(self.CurrentTaskID)
	if !schedule or !self then return end
	
	if self.GetNumberOfTasks == nil then //1
	print("WARNING: VJ BASE ANIMATION SYSTEM IS BROKEN!") end
	//self:ScheduleFinished(schedule)
	//return end
	
	//if self.CurrentTaskID > 3 then return end -- if CurrentTaskID more than 3, should we tell then game not to run it? Still have to figure it out
	//print("Running NextTask")
	self.CurrentTaskID = self.CurrentTaskID +1
	//if self.CurrentTaskID != nil then
	if (self.CurrentTaskID > self.GetNumberOfTasks) then
		self:ScheduleFinished(schedule)
		return
	end //end
	self:SetTask(schedule:GetTask(self.CurrentTaskID))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:StartTask(task) if task == nil or !task or !self then return end task:Start(self) end
function ENT:RunTask(task) if !task or !self then return end task:Run(self) end
function ENT:TaskTime() return CurTime() - self.TaskStartTime end
function ENT:OnTaskComplete() self.bTaskComplete = true end
function ENT:TaskFinished() return self.bTaskComplete end
function ENT:StartEngineTask(iTaskID,TaskData) end
function ENT:RunEngineTask(iTaskID,TaskData) end
function ENT:StartEngineSchedule(scheduleID) self:ScheduleFinished() self.bDoingEngineSchedule = true end
function ENT:EngineScheduleFinish() self.bDoingEngineSchedule = nil end
function ENT:DoingEngineSchedule() return self.bDoingEngineSchedule end
function ENT:OnCondition(iCondition) end
/*-----------------------------------------------
	*** Copyright (c) 2012-2016 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/