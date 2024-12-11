/*-----------------------------------------------
	*** Copyright (c) 2012-2024 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
if !VJ then VJ = {} end -- If VJ isn't initialized, initialize it!

-- Localized static values
local IsValid = IsValid
local defAng = Angle(0, 0, 0)
local colorRed = Color(255, 0, 0)
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
	Note: To quickly remove all of them run "lua_run for k,v in ipairs(ents.GetAll()) do if v:GetClass() == "prop_dynamic" then v:Remove() end end"
		- WARNING: This will remove ALL dynamic objects
-----------------------------------------------------------]]
function VJ.DEBUG_TempEnt(pos, ang, color, time, mdl)
	local ent = ents.Create("prop_dynamic")
	ent:SetModel(mdl or "models/hunter/blocks/cube025x025x025.mdl")
	ent:SetPos(pos)
	ent:SetAngles(ang or defAng)
	ent:SetColor(color or colorRed)
	ent:Spawn()
	ent:Activate()
	timer.Simple(time or 3, function() if IsValid(ent) then ent:Remove() end end)
	return ent
end
--[[---------------------------------------------------------
	Runs the given function x amount of times and prints how long it took to run it
		- count = Number of times to execute the given function
		- func = Function to execute on every counter
	EXAMPLE:
		VJ_StressTest(1000, function()
			-- Some code
		end)
-----------------------------------------------------------]]
function VJ.DEBUG_Stress(count, func)
	local startTime = SysTime()
    for _ = 1, count do
		func()
    end
	local totalTime = SysTime() - startTime
	print("Total: " .. string.format("%f", totalTime) .. " sec | Average: " .. string.format("%f", totalTime / count) .. " sec")
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
	if example == true then
		return 1000
	else
		return metaNPC.GetIdealMoveSpeed(self)
	end
end

hook.Add("OnEntityCreated", "vjmetatabletest", function(ent)
	if scripted_ents.IsBasedOn(ent:GetClass(), "npc_vj_creature_base") or scripted_ents.IsBasedOn(ent:GetClass(), "npc_vj_human_base") then
		local mt = table.Merge({}, debug.getmetatable(ent)) -- Create a new table to avoid overflow!
		mt.__index = __index
		debug.setmetatable(ent, mt)
	end
end)
*/
---------------------------------------------------------------------------------------------------------------------------------------------
-- Version for individual NPCs
-- ISSUE: Performance loss
/*
local metaOrg = debug.getmetatable(self)
local metaVJ = {}
local function newIndex(ent, key)
	local val = metaVJ[key]
	if val != nil then return val end
	return metaOrg.__index(ent, key)
end
function metaVJ:SetMaxLookDistance(dist)
	metaOrg.SetMaxLookDistance(self, dist)
end
local mt = table.Merge({}, metaOrg) -- Create a new table to avoid overflow!
mt.__index = newIndex
debug.setmetatable(self, mt)
*/