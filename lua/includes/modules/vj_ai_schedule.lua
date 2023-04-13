/*--------------------------------------------------
	*** Copyright (c) 2012-2023 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
if CLIENT then return end

require("vj_ai_task")
local setmetatable = setmetatable
local tostring = tostring
local table = table
local print = print
local vj_ai_task = vj_ai_task

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Begin Metatable ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
module("ai_vj_schedule")
local Schedule = {}
Schedule.__index = Schedule
---------------------------------------------------------------------------------------------------------------------------------------------
function Schedule:Init(debugName)
	self.debugName = tostring(debugName)
	self.Tasks = {}
	self.TaskCount = 0
end
---------------------------------------------------------------------------------------------------------------------------------------------
function Schedule:EngTask(taskName, taskData)
	local NewTask = vj_ai_task.New()
	NewTask:InitEngine(taskName, taskData)
	self.TaskCount = table.insert(self.Tasks, NewTask)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function Schedule:AddTask(funcName, data)
	local NewTask = vj_ai_task.New()
	NewTask:InitFunctionName("TaskStart_"..funcName, "Task_"..funcName, data)
	self.TaskCount = table.insert(self.Tasks, NewTask)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function Schedule:AddTaskEx(startFunc, endFunc, data)
	local NewTask = vj_ai_task.New()
	NewTask:InitFunctionName(startFunc, endFunc, data)
	self.TaskCount = table.insert(self.Tasks, NewTask)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function Schedule:NumTasks()
	return self.TaskCount
end
---------------------------------------------------------------------------------------------------------------------------------------------
function Schedule:GetTask(num)
	return self.Tasks[num]
end
---------------------------------------------------------------------------------------------------------------------------------------------
function New(debugName)
	local newSchedule = {}
	setmetatable(newSchedule, Schedule)
	newSchedule:Init(debugName)
	return newSchedule
end

print("VJ Base AI Schedule module: Successfully initialized!")