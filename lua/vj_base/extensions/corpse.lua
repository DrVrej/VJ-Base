/*--------------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
if !SERVER then return end
---------------------------------------------------------------------------------------------------------------------------------------------
if !VJ then VJ = {} end -- If VJ isn't initialized, initialize it!

local stinkyMatTypes = {alienflesh = true, antlion = true, armorflesh = true, bloodyflesh = true, flesh = true, zombieflesh = true, player = true}
	-- Material types: https://developer.valvesoftware.com/wiki/Material_surface_properties
-- Localized static values
local IsValid = IsValid
local table_remove = table.remove
local sdEmitHint = sound.EmitHint

local vj_npc_corpse_limit = GetConVar("vj_npc_corpse_limit")

VJ.Corpse_Ents = {}
VJ.Corpse_StinkyEnts = {}
---------------------------------------------------------------------------------------------------------------------------------------------
local function Stink_StartThink()
	timer.Create("vj_corpse_stink", 0.3, 0, function()
		for k, ent in RandomPairs(VJ.Corpse_StinkyEnts) do
			if IsValid(ent) then
				sdEmitHint(SOUND_CARCASS, ent:GetPos(), 400, 0.15, ent)
			else -- No longer valid, remove it from the list
				table_remove(VJ.Corpse_StinkyEnts, k)
				if #VJ.Corpse_StinkyEnts == 0 then -- If this is the last stinky ent then destroy the timer!
					timer.Remove("vj_corpse_stink")
				end
			end
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Adds an entity to the stinky entity list and makes it produce a stink
		- ent = The entity to add to the list
		- checkMat = Should it check the entity's material type?
	Returns
		- false, Entity NOT added to stinky the list
		- true, Entity added to the stinky list
-----------------------------------------------------------]]
function VJ.Corpse_AddStinky(ent, checkMat)
	local physObj = ent:GetPhysicsObject()
	-- Clear out all removed ents from the table
	for k, v in ipairs(VJ.Corpse_StinkyEnts) do
		if !IsValid(v) then
			table_remove(VJ.Corpse_StinkyEnts, k)
		end
	end
	-- Add the entity to the stinky list (if possible)
	if (!checkMat) or (IsValid(physObj) && stinkyMatTypes[physObj:GetMaterial()]) then
		VJ.Corpse_StinkyEnts[#VJ.Corpse_StinkyEnts + 1] = ent -- Add entity to the table
		if !timer.Exists("vj_corpse_stink") then Stink_StartThink() end -- Start the stinky timer if it does NOT exist
		return true
	end
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[---------------------------------------------------------
	Adds an entity to the VJ corpse list (Entities here respect all VJ rules including corpse limit!)
		- ent = The entity to add to the corpse list
-----------------------------------------------------------]]
function VJ.Corpse_Add(ent)
	-- Clear out all removed corpses from the table
	for k, v in ipairs(VJ.Corpse_Ents) do
		if !IsValid(v) then
			table_remove(VJ.Corpse_Ents, k)
		end
	end
	
	local count = #VJ.Corpse_Ents + 1
	VJ.Corpse_Ents[count] = ent
	
	-- Check if we surpassed the limit, if we did, remove the oldest corpse
	if count > vj_npc_corpse_limit:GetInt() then
		local oldestCorpse = table_remove(VJ.Corpse_Ents, 1)
		if IsValid(oldestCorpse) then
			local fadeType = oldestCorpse.FadeCorpseType
			if fadeType then oldestCorpse:Fire(fadeType, "", 0) end -- Fade out
			timer.Simple(1, function() if IsValid(oldestCorpse) then oldestCorpse:Remove() end end) -- Make sure it's removed
		end
	end
end