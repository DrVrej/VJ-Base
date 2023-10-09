/*--------------------------------------------------
	*** Copyright (c) 2012-2023 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
NOTES: Some fixes are from: https://github.com/garrynewman/garrysmod/pull/524
--------------------------------------------------*/
if CLIENT then return end

local setmetatable = setmetatable
local print = print
local ai = ai
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
	if (self:IsCustomType()) then
		if (!self.TaskFunc_Start) then return end
		npc[self.TaskFunc_Start](npc, TASKSTATUS_NEW, self.TaskData)
		return
	end
	if (self:IsEngineType()) then
		if (!self.TaskID) then self.TaskID = ai.GetTaskID(self.TaskName) end
		npc:StartEngineTask(self.TaskID, self.TaskData or 0)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function Task:Run(npc)
	if (self:IsCustomType()) then
		if (!self.TaskFunc_Run) then return end
		npc[self.TaskFunc_Run](npc, TASKSTATUS_RUN_TASK, self.TaskData)
		return
	end
	if (self:IsEngineType()) then
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

print("VJ Base AI Task module: Successfully initialized!")