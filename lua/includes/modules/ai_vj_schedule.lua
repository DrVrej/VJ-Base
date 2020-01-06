/*--------------------------------------------------
	=============== VJ AI Schedule Module ===============
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
INFO: This is mostly Garry's code, except I improved and organized.
NOTES: This is server side only!
--------------------------------------------------*/
if (CLIENT) then return end

print("VJ Base A.I. module initialized!")

local setmetatable 	= setmetatable
local tostring 		= tostring
local table			= table

require("ai_vj_task")
local ai_vj_task 		= ai_vj_task
module("ai_vj_schedule")

local Schedule		= {}
Schedule.__index 	= Schedule
---------------------------------------------------------------------------------------------------------------------------------------------
function Schedule:Init(_debugname_)
	self.DebugName 	= tostring(_debugname_)
	self.Tasks 		= {}
	self.TaskCount 	= 0
end
---------------------------------------------------------------------------------------------------------------------------------------------
function Schedule:EngTask(_taskname_,_taskdata_)
	local NewTask = ai_vj_task.New()
	NewTask:InitEngine(_taskname_,_taskdata_)
	table.insert(self.Tasks,NewTask)
	self.TaskCount = self.TaskCount + 1
end
---------------------------------------------------------------------------------------------------------------------------------------------
function Schedule:AddTask(_functionname_,_data_)
	local NewTask = ai_vj_task.New()
	NewTask:InitFunctionName("TaskStart_".._functionname_,"Task_".._functionname_,_data_)
	table.insert(self.Tasks,NewTask)
	//print(self.TaskCount.." AddTask has ran!")
	self.TaskCount = self.TaskCount + 1  -- Or else it will make an error saying NumTasks is a nil value
end
---------------------------------------------------------------------------------------------------------------------------------------------
function Schedule:AddTaskEx(_start,_run,_data_)
	local NewTask = ai_vj_task.New()
	NewTask:InitFunctionName(_start, _run, _data_)
	table.insert(self.Tasks,NewTask)
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
function New(debugname)
	local pNewSchedule = {}
	setmetatable(pNewSchedule,Schedule)
	pNewSchedule:Init(debugname)
	return pNewSchedule
end