/*--------------------------------------------------
	*** Copyright (c) 2012-2023 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
NOTES: Some fixes are from: https://github.com/garrynewman/garrysmod/pull/524
--------------------------------------------------*/
if CLIENT then return end

local setmetatable = setmetatable
local ai = ai
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Begin Metatable ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
module("ai_vj_task")
local Task = {}
Task.__index = Task

-- Type of task it is
local TYPE_ENGINE = 1
local TYPE_FNAME = 2
---------------------------------------------------------------------------------------------------------------------------------------------
function Task:Init()
	self.Type = nil
end
---------------------------------------------------------------------------------------------------------------------------------------------
function Task:InitEngine(taskName, taskData) -- Creates an engine based task
	self.TaskName = taskName
	self.TaskID = nil
	self.TaskData = taskData
	self.Type = TYPE_ENGINE
end
---------------------------------------------------------------------------------------------------------------------------------------------
function Task:InitFunctionName(startFunc, endFunc, taskData)
	self.StartFunctionName = startFunc
	self.FunctionName = endFunc
	self.TaskData = taskData
	self.Type = TYPE_FNAME
end
---------------------------------------------------------------------------------------------------------------------------------------------
function Task:IsEngineType()
	return self.Type == TYPE_ENGINE
end
---------------------------------------------------------------------------------------------------------------------------------------------
function Task:IsFNameType()
	return self.Type == TYPE_FNAME
end
---------------------------------------------------------------------------------------------------------------------------------------------
function Task:Start(npc)
	if (self:IsFNameType()) then self:Start_FName(npc) return end
	if (self:IsEngineType()) then
		if (!self.TaskID) then self.TaskID = ai.GetTaskID(self.TaskName) end
		npc:StartEngineTask(self.TaskID, self.TaskData or 0)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function Task:Start_FName(npc)
	if (!self.StartFunctionName) then return end
	npc[self.StartFunctionName](npc, self.TaskData)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function Task:Run(npc)
	if (self:IsFNameType()) then self:Run_FName(npc) return end
	if (self:IsEngineType()) then
		npc:RunEngineTask(self.TaskID, self.TaskData or 0)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function Task:Run_FName(npc)
	if (!self.FunctionName) then return end
	npc[self.FunctionName](npc,self.TaskData)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function New()
	local newTask = {}
	setmetatable(newTask, Task)
	newTask:Init()
	return newTask
end