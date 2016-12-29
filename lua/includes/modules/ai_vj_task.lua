/*--------------------------------------------------
	=============== VJ AI Task Module ===============
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
INFO: This is mostly Garry's code, except I improved and organized.
NOTES: This is server side only!
NOTES: A lot of the fix is from: https://github.com/garrynewman/garrysmod/pull/524
--------------------------------------------------*/
if (CLIENT) then return end

local setmetatable 		= setmetatable
local tostring 			= tostring
local table				= table
local Msg				= Msg
local Error				= Error

local TaskList = {
["TASK_INVALID"] = 0,
["TASK_RESET_ACTIVITY"] = 1,
["TASK_WAIT"] = 2,
["TASK_ANNOUNCE_ATTACK"] = 3,
["TASK_WAIT_FACE_ENEMY"] = 4,
["TASK_WAIT_FACE_ENEMY_RANDOM"] = 5,
["TASK_WAIT_PVS"] = 6,
["TASK_SUGGEST_STATE"] = 7,
["TASK_TARGET_PLAYER"] = 8,
["TASK_SCRIPT_WALK_TO_TARGET"] = 9,
["TASK_SCRIPT_RUN_TO_TARGET"] = 10,
["TASK_SCRIPT_CUSTOM_MOVE_TO_TARGET"] = 11,
["TASK_MOVE_TO_TARGET_RANGE"] = 12,
["TASK_MOVE_TO_GOAL_RANGE"] = 13,
["TASK_MOVE_AWAY_PATH"] = 14,
["TASK_GET_PATH_AWAY_FROM_BEST_SOUND"] = 15,
["TASK_SET_GOAL"] = 16,
["TASK_GET_PATH_TO_GOAL"] = 17,
["TASK_GET_PATH_TO_ENEMY"] = 18,
["TASK_GET_PATH_TO_ENEMY_LKP"] = 19,
["TASK_GET_CHASE_PATH_TO_ENEMY"] = 20,
["TASK_GET_PATH_TO_ENEMY_LKP_LOS"] = 21,
["TASK_GET_PATH_TO_ENEMY_CORPSE"] = 22,
["TASK_GET_PATH_TO_PLAYER"] = 23,
["TASK_GET_PATH_TO_ENEMY_LOS"] = 24,
["TASK_GET_FLANK_RADIUS_PATH_TO_ENEMY_LOS"] = 25,
["TASK_GET_FLANK_ARC_PATH_TO_ENEMY_LOS"] = 26,
["TASK_GET_PATH_TO_RANGE_ENEMY_LKP_LOS"] = 27,
["TASK_GET_PATH_TO_TARGET"] = 28,
["TASK_GET_PATH_TO_TARGET_WEAPON"] = 29,
["TASK_CREATE_PENDING_WEAPON"] = 30,
["TASK_GET_PATH_TO_HINTNODE"] = 31,
["TASK_STORE_LASTPOSITION"] = 32,
["TASK_CLEAR_LASTPOSITION"] = 33,
["TASK_STORE_POSITION_IN_SAVEPOSITION"] = 34,
["TASK_STORE_BESTSOUND_IN_SAVEPOSITION"] = 35,
["TASK_STORE_BESTSOUND_REACTORIGIN_IN_SAVEPOSITION"] = 36,
["TASK_REACT_TO_COMBAT_SOUND"] = 37,
["TASK_STORE_ENEMY_POSITION_IN_SAVEPOSITION"] = 38,
["TASK_GET_PATH_TO_COMMAND_GOAL"] = 39,
["TASK_MARK_COMMAND_GOAL_POS"] = 40,
["TASK_CLEAR_COMMAND_GOAL"] = 41,
["TASK_GET_PATH_TO_LASTPOSITION"] = 42,
["TASK_GET_PATH_TO_SAVEPOSITION"] = 43,
["TASK_GET_PATH_TO_SAVEPOSITION_LOS"] = 44,
["TASK_GET_PATH_TO_RANDOM_NODE"] = 45,
["TASK_GET_PATH_TO_BESTSOUND"] = 46,
["TASK_GET_PATH_TO_BESTSCENT"] = 47,
["TASK_RUN_PATH"] = 48,
["TASK_WALK_PATH"] = 49, 
["TASK_WALK_PATH_TIMED"] = 50,
["TASK_WALK_PATH_WITHIN_DIST"] = 51,
["TASK_WALK_PATH_FOR_UNITS"] = 52,
["TASK_RUN_PATH_FLEE"] = 53,
["TASK_RUN_PATH_TIMED"] = 54,
["TASK_RUN_PATH_FOR_UNITS"] = 55,
["TASK_RUN_PATH_WITHIN_DIST"] = 56,
["TASK_STRAFE_PATH"] = 57,
["TASK_CLEAR_MOVE_WAIT"] = 58,
["TASK_SMALL_FLINCH"] = 59,
["TASK_BIG_FLINCH"] = 60,
["TASK_DEFER_DODGE"] = 61,
["TASK_FACE_IDEAL"] = 62,
["TASK_FACE_REASONABLE"] = 63,
["TASK_FACE_PATH"] = 64,
["TASK_FACE_PLAYER"] = 65,
["TASK_FACE_ENEMY"] = 66,
["TASK_FACE_HINTNODE"] = 67,
["TASK_PLAY_HINT_ACTIVITY"] = 68,
["TASK_FACE_TARGET"] = 69,
["TASK_FACE_LASTPOSITION"] = 70,
["TASK_FACE_SAVEPOSITION"] = 71,
["TASK_FACE_AWAY_FROM_SAVEPOSITION"] = 72,
["TASK_SET_IDEAL_YAW_TO_CURRENT"] = 73,
["TASK_RANGE_ATTACK1"] = 74,
["TASK_RANGE_ATTACK2"] = 75,
["TASK_MELEE_ATTACK1"] = 76,
["TASK_MELEE_ATTACK2"] = 77,
["TASK_RELOAD"] = 78,
["TASK_SPECIAL_ATTACK1"] = 79,
["TASK_SPECIAL_ATTACK2"] = 80,
["TASK_FIND_HINTNODE"] = 81,
["TASK_FIND_LOCK_HINTNODE"] = 82,
["TASK_CLEAR_HINTNODE"] = 83,
["TASK_LOCK_HINTNODE"] = 84,
["TASK_SOUND_ANGRY"] = 85,
["TASK_SOUND_DEATH"] = 86,
["TASK_SOUND_IDLE"] = 87,
["TASK_SOUND_WAKE"] = 88,
["TASK_SOUND_PAIN"] = 89,
["TASK_SOUND_DIE"] = 90,
["TASK_SPEAK_SENTENCE"] = 91,
["TASK_WAIT_FOR_SPEAK_FINISH"] = 92,
["TASK_SET_ACTIVITY"] = 93,
["TASK_RANDOMIZE_FRAMERATE"] = 94,
["TASK_SET_SCHEDULE"] = 95,
["TASK_SET_FAIL_SCHEDULE"] = 96,
["TASK_SET_TOLERANCE_DISTANCE"] = 97,
["TASK_SET_ROUTE_SEARCH_TIME"] = 98,
["TASK_CLEAR_FAIL_SCHEDULE"] = 99,
["TASK_PLAY_SEQUENCE"] = 100,
["TASK_PLAY_PRIVATE_SEQUENCE"] = 101,
["TASK_PLAY_PRIVATE_SEQUENCE_FACE_ENEMY"] = 102,
["TASK_PLAY_SEQUENCE_FACE_ENEMY"] = 103,
["TASK_PLAY_SEQUENCE_FACE_TARGET"] = 104,
["TASK_FIND_COVER_FROM_BEST_SOUND"] = 105,
["TASK_FIND_COVER_FROM_ENEMY"] = 106,
["TASK_FIND_LATERAL_COVER_FROM_ENEMY"] = 107,
["TASK_FIND_BACKAWAY_FROM_SAVEPOSITION"] = 108,
["TASK_FIND_NODE_COVER_FROM_ENEMY"] = 109,
["TASK_FIND_NEAR_NODE_COVER_FROM_ENEMY"] = 110,
["TASK_FIND_FAR_NODE_COVER_FROM_ENEMY"] = 111,
["TASK_FIND_COVER_FROM_ORIGIN"] = 112,
["TASK_DIE"] = 113,
["TASK_WAIT_FOR_SCRIPT"] = 114,
["TASK_PUSH_SCRIPT_ARRIVAL_ACTIVITY"] = 115,
["TASK_PLAY_SCRIPT"] = 116,
["TASK_PLAY_SCRIPT_POST_IDLE"] = 117,
["TASK_ENABLE_SCRIPT"] = 118,
["TASK_PLANT_ON_SCRIPT"] = 119,
["TASK_FACE_SCRIPT"] = 120,
["TASK_PLAY_SCENE"] = 121,
["TASK_WAIT_RANDOM"] = 122,
["TASK_WAIT_INDEFINITE"] = 123,
["TASK_STOP_MOVING"] = 124,
["TASK_TURN_LEFT"] = 125,
["TASK_TURN_RIGHT"] = 126,
["TASK_REMEMBER"] = 127,
["TASK_FORGET"] = 128,
["TASK_WAIT_FOR_MOVEMENT"] = 129,
["TASK_WAIT_FOR_MOVEMENT_STEP"] = 130,
["TASK_WAIT_UNTIL_NO_DANGER_SOUND"] = 131,
["TASK_WEAPON_FIND"] = 132,
["TASK_WEAPON_PICKUP"] = 133,
["TASK_WEAPON_RUN_PATH"] = 134,
["TASK_WEAPON_CREATE"] = 135,
["TASK_ITEM_PICKUP"] = 136,
["TASK_ITEM_RUN_PATH"] = 137,
["TASK_USE_SMALL_HULL"] = 138,
["TASK_FALL_TO_GROUND"] = 139,
["TASK_WANDER"] = 140,
["TASK_FREEZE"] = 141,
["TASK_GATHER_CONDITIONS"] = 142,
["TASK_IGNORE_OLD_ENEMIES"] = 143,
["TASK_DEBUG_BREAK"] = 144,
["TASK_ADD_HEALTH"] = 145,
["TASK_ADD_GESTURE_WAIT"] = 146,
["TASK_ADD_GESTURE"] = 147,
["TASK_GET_PATH_TO_INTERACTION_PARTNER"] = 148,
["TASK_PRE_SCRIPT"] = 149, 
}

GetTaskList = function(name) return TaskList[name] or TaskList[0] end
local GetTaskID = GetTaskList
---------------------------------------------------------------------------------------------------------------------------------------------
module("ai_vj_task")

local TYPE_ENGINE		= 1
local TYPE_FNAME		= 2
local Task 				= {}
Task.__index 			= Task
---------------------------------------------------------------------------------------------------------------------------------------------
function Task:Init()
	self.Type = nil
end
---------------------------------------------------------------------------------------------------------------------------------------------
function Task:InitEngine(_taskname_, _taskdata_)
	self.TaskName 			= _taskname_
	self.TaskID				= nil
	self.TaskData 			= _taskdata_
	self.Type 				= TYPE_ENGINE
end
---------------------------------------------------------------------------------------------------------------------------------------------
function Task:InitFunctionName(_start,_end,_taskdata_)
	self.StartFunctionName 	= _start
	self.FunctionName 		= _end
	self.TaskData 			= _taskdata_
	self.Type 				= TYPE_FNAME
end
---------------------------------------------------------------------------------------------------------------------------------------------
function Task:IsEngineType()
	return (self.Type == TYPE_ENGINE)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function Task:IsFNameType()
	return (self.Type == TYPE_FNAME)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function Task:Start(npc)
	if (self:IsFNameType()) then self:Start_FName(npc) return end
	if (self:IsEngineType()) then
		if (!self.TaskID) then self.TaskID = GetTaskID(self.TaskName) end
		npc:StartEngineTask(self.TaskID,self.TaskData or 0)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function Task:Start_FName(npc)
	if (!self.StartFunctionName) then return end
	npc[ self.StartFunctionName ]( npc, self.TaskData )
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
	local pNewTask = {}
	setmetatable(pNewTask, Task)
	pNewTask:Init()
	return pNewTask
end