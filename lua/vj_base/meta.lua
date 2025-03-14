/*--------------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/

local metaEntity = FindMetaTable("Entity")
local metaNPC = FindMetaTable("NPC")
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Meta Edits ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if !metaNPC.IsVJBaseEdited then
	metaNPC.IsVJBaseEdited = true
	---------------------------------------------------------------------------------------------------------------------------------------------
	local orgSetMaxLookDistance = metaNPC.SetMaxLookDistance
	-- Override to make sure all 3 values are on par at all times!
	function metaNPC:SetMaxLookDistance(dist)
		//self:Fire("SetMaxLookDistance", dist) -- Original "SetMaxLookDistance" handles it now (below)
		orgSetMaxLookDistance(self, dist) -- For engine sight & sensing distance
		self:SetSaveValue("m_flDistTooFar", dist) -- For certain engine attacks, weapons, and condition distances
		self.SightDistance = dist -- For VJ Base
	end
	---------------------------------------------------------------------------------------------------------------------------------------------
	local orgSetPlaybackRate = metaEntity.SetPlaybackRate
	-- Need this because "ai_blended_movement" will override it constantly and we won't know what the actual playback is supposed to be
	function metaNPC:SetPlaybackRate(num, skipTrueRate)
		if !skipTrueRate then
			self.AnimPlaybackRate = num
		end
		orgSetPlaybackRate(self, num)
	end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Meta Additions ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Variable:		self.VJ_NPC_Class
-- Access: 			self.VJ_NPC_Class.CLASS_COMBINE
-- Remove: 			self.VJ_NPC_Class.CLASS_COMBINE = nil
-- Add: 			self:VJ_CLASS_ADD("CLASS_COMBINE", "CLASS_ZOMBIE", ...)
--
/*local numericClasses = self.VJ_NPC_Class
self.VJ_NPC_Class = {}
for _, class in ipairs(numericClasses) do
	self:VJ_CLASS_ADD(class)
end*/

/*function metaEntity:VJ_CLASS_ADD(...)
	//PrintTable({...})
	for _, class in ipairs({...}) do
		self.VJ_NPC_Class[class] = true
	end
end*/
--[[---------------------------------------------------------
	Overrides how a VJ NPC should feel towards towards the calling entity (otherEnt)
	1. otherEnt [entity] : The other entity that is testing to see how it should feel towards us
	2. distance [nil | number] : Calculated distance from this entity to the other entity
	3. isFriendly [boolean] : Whether or not the other entity has calculated us as friendly
	Returns
		- [boolean | Disposition enum] : Return false to not override anything | Return a disposition enum to set as an override
-----------------------------------------------------------]]
-- Apply directly to the entity to use it
--function metaEntity:HandlePerceivedRelationship(otherEnt, distance, isFriendly)
--	VJ.DEBUG_Print(self, "HandlePerceivedRelationship", otherEnt, distance, isFriendly)
--	return
--end
--[[---------------------------------------------------------
	Determines whether or not this entity should be engaged by an enemy
	1. otherEnt [entity] : The other entity that is testing to see if it can engage this entity
	2. distance [nil | number] : Calculated distance from this entity to the other entity
	Returns
		- [boolean] : Return true if it should be engaged
-----------------------------------------------------------]]
-- Apply directly to the entity to use it
--function metaEntity:CanBeEngaged(otherEnt, distance)
--	VJ.DEBUG_Print(self, "CanBeEngaged", otherEnt, distance)
--	return true
--end
---------------------------------------------------------------------------------------------------------------------------------------------
-- !!!!!!!!!!!!!! DO NOT USE !!!!!!!!!!!!!! [Backwards Compatibility!]
function metaEntity:CalculateProjectile(algorithmType, startPos, targetPos, strength)
	if algorithmType == "Line" then
		return VJ.CalculateTrajectory(self, (self.IsVJBaseSNPC and IsValid(self:GetEnemy())) and self:GetEnemy() or NULL, "Line", startPos, self.IsVJBaseSNPC and 1 or targetPos, strength)
	elseif algorithmType == "Curve" then
		return VJ.CalculateTrajectory(self, (self.IsVJBaseSNPC and IsValid(self:GetEnemy())) and self:GetEnemy() or NULL, "CurveOld", startPos, targetPos, strength)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
/* Disabled for now as it causes significant performance loss, its purpose was to fix the same-model relationship bug in Garry's Mod
--
local AddEntityRelationship = metaNPC.AddEntityRelationship
function metaNPC:AddEntityRelationship(...)
	local args = {...}
	local ent = args[1]
	local disp = args[2]

	self.StoredDispositions = self.StoredDispositions or {}
	self.StoredDispositions[ent] = disp
	return AddEntityRelationship(self, ...)
end
---------------------------------------------------------------------------------------------------------------------------------------------
local Disposition = metaNPC.Disposition
function metaNPC:Disposition(...)
	local args = {...}
	local ent = args[1]

	self.StoredDispositions = self.StoredDispositions or {}
	if IsValid(ent) && self:GetModel() == ent:GetModel() then
		return self.StoredDispositions[ent] or D_ER
	end
	return Disposition(self, ...)
end
*/
---------------------------------------------------------------------------------------------------------------------------------------------
/* Disabled as this has now been replaced with a faster system
--
VJ_TAG_HEALING = 1 -- Ent is healing (either itself or by another ent)
VJ_TAG_EATING = 2 -- Ent is eating something (Ex: a corpse)
VJ_TAG_BEING_EATEN = 3 -- Ent is being eaten by something
VJ_TAG_VJ_FRIENDLY = 4 -- Friendly to VJ NPCs
VJ_TAG_SD_PLAYING_MUSIC = 10 -- Ent is playing a sound track
VJ_TAG_HEADCRAB = 20
VJ_TAG_POLICE = 21
VJ_TAG_CIVILIAN = 22
VJ_TAG_TURRET = 23
VJ_TAG_VEHICLE = 24
VJ_TAG_AIRCRAFT = 25
--
-- Variable:		self.VJTags
-- Access: 			self.VJTags[VJ_TAG_X]
-- Remove: 			self.VJTags[VJ_TAG_X] = nil
-- Add: 			self:VJTags_Add(VJ_TAG_X, VJ_TAG_Y, ...)
--
function metaEntity:VJTags_Add(...)
	if !self.VJTags then self.VJTags = {} end
	//PrintTable({...})
	for _, tag in ipairs({...}) do
		self.VJTags[tag] = true
	end
end
*/