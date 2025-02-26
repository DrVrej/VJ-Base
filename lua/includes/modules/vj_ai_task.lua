/*--------------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
NOTES: Some fixes are from: https://github.com/garrynewman/garrysmod/pull/524
--------------------------------------------------*/
if CLIENT then return end

local setmetatable = setmetatable
local MsgC = MsgC
local ai = ai
local VJ = VJ
local TASKSTATUS_NEW = TASKSTATUS_NEW
local TASKSTATUS_RUN_TASK = TASKSTATUS_RUN_TASK
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Begin Metatable ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
module("vj_ai_task")
local Task = {}
Task.__index = Task

-- Types of tasks
local TYPE_ENGINE = 1
local TYPE_CUSTOM = 2
---------------------------------------------------------------------------------------------------------------------------------------------
function Task:Init()
	self.TaskType = nil
end
---------------------------------------------------------------------------------------------------------------------------------------------
function Task:InitEngine(taskName, taskData) -- Creates an engine based task
	self.TaskName = taskName
	self.TaskID = nil
	self.TaskData = taskData
	self.TaskType = TYPE_ENGINE
end
---------------------------------------------------------------------------------------------------------------------------------------------
function Task:InitCustom(taskName, startFunc, endFunc, taskData) -- Create a custom task
	self.TaskName = taskName
	self.TaskFunc_Start = startFunc
	self.TaskFunc_Run = endFunc
	self.TaskID = nil -- Custom function do NOT have an ID!
	self.TaskData = taskData
	self.TaskType = TYPE_CUSTOM
end
---------------------------------------------------------------------------------------------------------------------------------------------
function Task:Start(npc)
	if self.TaskType == TYPE_CUSTOM then
		if (!self.TaskFunc_Start) then return end
		npc[self.TaskFunc_Start](npc, TASKSTATUS_NEW, self.TaskData)
	elseif self.TaskType == TYPE_ENGINE then
		if (!self.TaskID) then self.TaskID = ai.GetTaskID(self.TaskName) end
		npc:StartEngineTask(self.TaskID, self.TaskData or 0)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function Task:Run(npc)
	if self.TaskType == TYPE_CUSTOM then
		if (!self.TaskFunc_Run) then return end
		npc[self.TaskFunc_Run](npc, TASKSTATUS_RUN_TASK, self.TaskData)
	elseif self.TaskType == TYPE_ENGINE then
		npc:RunEngineTask(self.TaskID, self.TaskData or 0)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function Task:IsEngineType()
	return self.TaskType == TYPE_ENGINE
end
---------------------------------------------------------------------------------------------------------------------------------------------
function Task:IsCustomType()
	return self.TaskType == TYPE_CUSTOM
end
---------------------------------------------------------------------------------------------------------------------------------------------
function New()
	local newTask = {}
	setmetatable(newTask, Task)
	newTask:Init()
	return newTask
end

MsgC(VJ.COLOR_LOGO_ORANGE_LIGHT, "VJ Base [AI Task module]: ", VJ.COLOR_SERVER, "Successfully initialized!\n")