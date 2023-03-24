/*--------------------------------------------------
	*** Copyright (c) 2012-2023 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
if CLIENT then return end

print("VJ Base module: AI Schedules initialized!")

require("ai_vj_task")
local setmetatable = setmetatable
local tostring = tostring
local table = table
local ai_vj_task 		= ai_vj_task

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
	local NewTask = ai_vj_task.New()
	NewTask:InitEngine(taskName, taskData)
	table.insert(self.Tasks, NewTask)
	self.TaskCount = self.TaskCount + 1
end
---------------------------------------------------------------------------------------------------------------------------------------------
function Schedule:AddTask(funcName, data)
	local NewTask = ai_vj_task.New()
	NewTask:InitFunctionName("TaskStart_"..funcName, "Task_"..funcName, data)
	table.insert(self.Tasks, NewTask)
	//print(self.TaskCount.." AddTask has ran!")
	self.TaskCount = self.TaskCount + 1  -- Or else it will make an error saying NumTasks is a nil value
end
---------------------------------------------------------------------------------------------------------------------------------------------
function Schedule:AddTaskEx(startFunc, endFunc, data)
	local NewTask = ai_vj_task.New()
	NewTask:InitFunctionName(startFunc, endFunc, data)
	table.insert(self.Tasks, NewTask)
	self.TaskCount = self.TaskCount + 2  -- Or else it will make an error saying NumTasks is a nil value
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