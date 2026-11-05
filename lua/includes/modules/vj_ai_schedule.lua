/*-----------------------------------------------
	*** Copyright (c) 2012-2026 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
if CLIENT then return end

require("vj_ai_task")
local setmetatable = setmetatable
local tostring = tostring
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
--[[---------------------------------------------------------
    Schedule Variables & Flags

    -- Core
    Name                = Schedule name / identifier
    Tasks               = Table containing all tasks in execution order
    TaskCount           = Total number of tasks in the schedule

    -- Behavior Flags
    HasMovement         = Whether the schedule contains a movement task | Automatically set when adding movement tasks
    ResetOnFail         = Stop the NPC's movement and mark the failure as handled when a task fails
    CanBeInterrupted    = Allow the NPC's AI to interrupt the schedule for other behaviors
    CanShootWhenMoving  = Allow the NPC to maintain weapon firing while performing movement tasks
    IsPlayAnim          = Marks an animation schedule so it can run during animation-only AI states

    -- Optional Settings
    TurnData            = Table controlling the NPC's facing direction while performing the schedule
        Type            = Facing behavior | Uses VJ.FACE_* enums
        Target          = Entity or position to face | Not required when facing an enemy
    IgnoreConditions    = Conditions the NPC should ignore while the schedule is active | Removed when the schedule finishes

    -- Callbacks
    RunCode_OnFail      = Function called once when a task fails
    RunCode_OnFinish    = Function called once when the schedule finishes, including when interrupted or failed

    -- Execution Flags (Reset on each start)
    OnFailExecuted      = Whether RunCode_OnFail has already executed
    OnFinishExecuted    = Whether RunCode_OnFinish has already executed
    FailureHandled      = Whether the task failure was handled by ResetOnFail
-----------------------------------------------------------]]
---------------------------------------------------------------------------------------------------------------------------------------------
function Schedule:Init(Name)
	self.Name = tostring(Name)
	self.Tasks = {}
	self.TaskCount = 0
end
---------------------------------------------------------------------------------------------------------------------------------------------
function Schedule:Reset()
    self.OnFailExecuted = false
    self.OnFinishExecuted = false
    self.FailureHandled = false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function Schedule:EngTask(taskName, taskData) -- Set an engine defined task
	local newTask = vj_ai_task.New()
	newTask:InitEngine(taskName, taskData)
	local count = #self.Tasks + 1
	self.Tasks[count] = newTask
	self.TaskCount = count
	if tasksMove[taskName] then -- Handle movement tasks
		self.HasMovement = true
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function Schedule:AddTask(taskName, taskData) -- Set a custom task where the task name, start function, and run function are all named the same
	self:AddTaskEx(taskName, taskName, taskName, taskData)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function Schedule:AddTaskEx(taskName, startFunc, runFunc, taskData) -- Set a custom task with custom start and run function names
	local newTask = vj_ai_task.New()
	newTask:InitCustom(taskName, startFunc, runFunc, taskData)
	local count = #self.Tasks + 1
	self.Tasks[count] = newTask
	self.TaskCount = count
	if tasksMove[taskName] then -- Handle movement tasks
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