/*--------------------------------------------------
	*** Copyright (c) 2012-2026 by DrVrej, All rights reserved. ***
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
	self.Type = nil
end
---------------------------------------------------------------------------------------------------------------------------------------------
function Task:InitEngine(name, data) -- Creates an engine based task
	self.Name = name
	self.Data = data or 0 -- Engine data must be a number
	self.Type = TYPE_ENGINE
	//self.EngineID -- Set later
end
---------------------------------------------------------------------------------------------------------------------------------------------
function Task:InitCustom(name, startFunc, endFunc, data) -- Create a custom task
	self.Name = name
	self.Data = data
	self.Type = TYPE_CUSTOM
	self.CustomStart = startFunc
	self.CustomRun = endFunc
end
---------------------------------------------------------------------------------------------------------------------------------------------
function Task:Start(ent)
	if self.Type == TYPE_CUSTOM then
		if !self.CustomStart then return end
		ent[self.CustomStart](ent, TASKSTATUS_NEW, self.Data)
	elseif self.Type == TYPE_ENGINE then
		self.EngineID = ai.GetTaskID(self.Name) -- Must be delayed otherwise it can return -1
		ent:StartEngineTask(self.EngineID, self.Data)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function Task:Run(ent)
	if self.Type == TYPE_CUSTOM then
		if !self.CustomRun then return end
		ent[self.CustomRun](ent, TASKSTATUS_RUN_TASK, self.Data)
	elseif self.Type == TYPE_ENGINE then
		ent:RunEngineTask(self.EngineID, self.Data)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function Task:IsEngineType()
	return self.Type == TYPE_ENGINE
end
---------------------------------------------------------------------------------------------------------------------------------------------
function Task:IsCustomType()
	return self.Type == TYPE_CUSTOM
end
---------------------------------------------------------------------------------------------------------------------------------------------
function New()
	local newTask = {}
	setmetatable(newTask, Task)
	newTask:Init()
	return newTask
end

MsgC(VJ.COLOR_LOGO_ORANGE_LIGHT, "VJ Base [AI Task module]: ", VJ.COLOR_SERVER, "Successfully initialized!\n")