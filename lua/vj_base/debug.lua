/*-----------------------------------------------
	*** Copyright (c) 2012-2026 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
local IsValid = IsValid
local defAng = Angle(0, 0, 0)
local MsgC = MsgC
local colorEnt = Color(255, 255, 255, 150)
--------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Prints the giving arguments in a organized fashion
		- ent = Entity that the debug is being called from | DEFAULT = NULL
		- callName = Name of the call, usually the name of the function | DEFAULT = false
		- type = Type of debug | If it doesn't match one of the following types then it will just act as another print value
			-> "error" | "warn"
-----------------------------------------------------------]]
function VJ.DEBUG_Print(ent, callName, type, ...)
	-- Check if a type was given
	local colorType = CLIENT and VJ.COLOR_CLIENT or VJ.COLOR_SERVER
	local typeGiven = false -- Was a valid type given?
    if type == "error" then
		typeGiven = true
        colorType = VJ.COLOR_RED
    elseif type == "warn" then
		typeGiven = true
        colorType = VJ.COLOR_ORANGE
    end
	
	-- Unpack the arguments
    local args = {...}
	local printTbl = {}
	if !typeGiven then
		table.insert(args, 1, type)
	end
    for _, arg in ipairs(args) do
		if isstring(arg) then
        	table.insert(printTbl, " " .. arg .. " ")
		else
        	table.insert(printTbl, arg)
		end
    end
	
	-- Output
    MsgC(colorEnt, ent, callName and (" | " .. callName) or "", " : ", colorType, unpack(printTbl))
	MsgC(colorType, "\n")
end
--------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Creates a test entity, useful to test trace or hit positions
		- pos = Spawn position
		- ang = Spawn angle | DEFAULT: 0, 0, 0
		- color = Color of the entity | DEFAULT: 255, 0, 0
		- time = How long until the entity is removed | DEFAULT: 3
		- mdl = Model of the entity | DEFAULT: Small cube
			- Small cube: "models/hunter/blocks/cube025x025x025.mdl"
			- Tiny cube: "models/hunter/plates/plate.mdl"
	Returns
		- Entity, the created test entity
	Note: To quickly remove all of them run "lua_run for k, v in ipairs(ents.GetAll()) do if v:GetClass() == "prop_dynamic" then v:Remove() end end"
		- WARNING: This will remove ALL dynamic objects
-----------------------------------------------------------]]
function VJ.DEBUG_TempEnt(pos, ang, color, time, mdl)
	local ent = ents.Create("prop_dynamic")
	ent:SetModel(mdl or "models/hunter/blocks/cube025x025x025.mdl")
	ent:SetPos(pos)
	ent:SetAngles(ang or defAng)
	ent:SetColor(color or VJ.COLOR_RED)
	ent:Spawn()
	ent:Activate()
	timer.Simple(time or 3, function() if IsValid(ent) then ent:Remove() end end)
	return ent
end
--------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Runs the given function x amount of times and prints how long it took to run it
		- count = Number of times to execute the given function
		- func = Function to execute on every counter
	EXAMPLE:
		VJ.DEBUG_Stress(1000, function()
			-- code
		end)
-----------------------------------------------------------]]
function VJ.DEBUG_Stress(count, func)
	local memStart = collectgarbage("count")
	local startTime = SysTime()
    for _ = 1, count do
		func()
    end
	local totalTime = SysTime() - startTime
	local memEnd = collectgarbage("count")
	collectgarbage("collect")
	print(string.format("TOTAL (%d) = %f sec | AVG = %f sec | MEMORY = %.2f -> %.2f kb (%.2f kb)", count, totalTime, totalTime / count, memStart, memEnd, memEnd - memStart))
end
---------------------------------------------------------------------------------------------------------------------------------------------
-- Version for all VJ NPCs
-- ISSUE: Performance loss
/*
local metaNPC = FindMetaTable("NPC")
local metaVJ = {}
local function __index(self, key)
	local val = metaVJ[key]
	if val != nil then return val end
	//if ( key == "Example1" ) then return self.Example2 end
	return metaNPC.__index(self, key)
end

function metaVJ:GetIdealMoveSpeed(example)
	if example then
		return 1000
	else
		return metaNPC.GetIdealMoveSpeed(self)
	end
end

hook.Add("OnEntityCreated", "VJ_OnEntityCreated_Test", function(ent)
	if scripted_ents.IsBasedOn(ent:GetClass(), "npc_vj_creature_base") or scripted_ents.IsBasedOn(ent:GetClass(), "npc_vj_human_base") then
		local mt = table.Merge({}, debug.getmetatable(ent)) -- Create a new table to avoid overflow!
		mt.__index = __index
		debug.setmetatable(ent, mt)
	end
end)
*/
---------------------------------------------------------------------------------------------------------------------------------------------
-- Retrieving outputs from NPCs or other entities | Outputs: https://developer.valvesoftware.com/wiki/Base.fgd/Garry%27s_Mod
/*
local triggerLua = ents.Create("lua_run")
triggerLua:SetName("triggerhook")
triggerLua:Spawn()

hook.Add("OnEntityCreated", "VJ_OnEntityCreated_Outputs", function(ent)
	if ent:IsNPC() && ent.IsVJBaseSNPC then
		-- Format: <output name> <targetname>:<inputname>:<parameter>:<delay>:<max times to fire, -1 means infinite>
		self:Fire("AddOutput", "OnIgnite triggerhook:RunPassedCode:hook.Run( 'OnOutput' ):0:-1")
	end
end)

hook.Add("OnOutput", "VJ_OnOutput", function()
	local activator, caller = ACTIVATOR, CALLER
	print(activator, caller)
end )
*/