/*-----------------------------------------------
	*** Copyright (c) 2012-2026 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
if CLIENT then return end

require("vj_ai_task")
local setmetatable = setmetatable
local tostring = tostring
local table = table
local MsgC = MsgC
local vj_ai_task = vj_ai_task
local VJ = VJ

local tasksMove = {TASK_WAIT_FOR_MOVEMENT = true, TASK_MOVE_TO_TARGET_RANGE = true, TASK_MOVE_TO_GOAL_RANGE = true, TASK_WALK_PATH = true, TASK_WALK_PATH_TIMED = true, TASK_WALK_PATH_FOR_UNITS = true, TASK_WALK_PATH_WITHIN_DIST = true, TASK_RUN_PATH = true, TASK_RUN_PATH_FLEE = true, TASK_RUN_PATH_TIMED = true, TASK_RUN_PATH_FOR_UNITS = true, TASK_RUN_PATH_WITHIN_DIST = true, TASK_WEAPON_RUN_PATH = true, TASK_ITEM_RUN_PATH = true}
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Begin Metatable ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
module("vj_ai_schedule")
local Schedule = {}
Schedule.__index = Schedule
---------------------------------------------------------------------------------------------------------------------------------------------
function Schedule:Init(Name)
	self.Name = tostring(Name)
	self.Tasks = {}
	self.TaskCount = 0
	self.HasMovement = false -- Does this schedule contain a movement task?
	self.ResetOnFail = false -- Should the NPC stop moving if one of the tasks fail?
	self.CanBeInterrupted = false -- Can this schedule be interrupted? Especially by regular things like idle / alert maintain
	self.CanShootWhenMoving = false -- Can the NPC fire its active weapon while doing this schedule?
	self.RunCode_OnFail = nil -- Code that will run ONLY when it fails!
	self.RunCode_OnFinish = nil -- Code that will run once the task finished (Will run even if failed)
	self.OnFailExecuted = false
	self.OnFinishExecuted = false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function Schedule:EngTask(taskName, taskData) -- Set an engine defined task
	local newTask = vj_ai_task.New()
	newTask:InitEngine(taskName, taskData)
	self.TaskCount = table.insert(self.Tasks, newTask)
	-- Handle movement tasks
	if tasksMove[taskName] then
		self.HasMovement = true
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function Schedule:AddTask(taskName, data) -- Set a custom task where the task name, start function, and run function are all named the same
	local newTask = vj_ai_task.New()
	newTask:InitCustom(taskName, taskName, taskName, data)
	self.TaskCount = table.insert(self.Tasks, newTask)
	-- Handle movement tasks
	if tasksMove[taskName] then
		self.HasMovement = true
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function Schedule:AddTaskEx(taskName, startFunc, runFunc, data) -- Set a custom task with custom start and run function names
	local newTask = vj_ai_task.New()
	newTask:InitCustom(taskName, startFunc, runFunc, data)
	self.TaskCount = table.insert(self.Tasks, newTask)
	-- Handle movement tasks
	if tasksMove[taskName] then
		self.HasMovement = true
	end
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
function New(Name)
	local newSchedule = {}
	setmetatable(newSchedule, Schedule)
	newSchedule:Init(Name)
	return newSchedule
end

MsgC(VJ.COLOR_LOGO_ORANGE_LIGHT, "VJ Base [AI Schedule module]: ", VJ.COLOR_SERVER, "Successfully initialized!\n")