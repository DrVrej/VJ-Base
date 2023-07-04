/*--------------------------------------------------
	*** Copyright (c) 2012-2023 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/

-- Localized static values
local isnumber = isnumber

local metaEntity = FindMetaTable("Entity")
local metaNPC = FindMetaTable("NPC")
//local Player_MetaTable = FindMetaTable("Player")
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Meta Edits ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if !metaNPC.IsVJBaseEdited then
	metaNPC.IsVJBaseEdited = true
	---------------------------------------------------------------------------------------------------------------------------------------------
	local orgSetMaxLookDistance = metaNPC.SetMaxLookDistance
	--
	function metaNPC:SetMaxLookDistance(dist)
		//self:Fire("SetMaxLookDistance", dist) -- For Source sensing distance (OLD)
		orgSetMaxLookDistance(self, dist)
		//self:SetMaxLookDistance(dist) -- For Source sight & sensing distance
		self:SetSaveValue("m_flDistTooFar", dist) -- For certain Source attack, weapon, and condition distances
		self.SightDistance = dist -- For VJ Base
		//print(self:GetInternalVariable("m_flDistTooFar"), self:GetMaxLookDistance())
	end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Meta Additions ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local vj_animdur = VJ.AnimDuration
--
-- override = Used internally by the base, overrides the result and returns Val instead (Useful for variables that allow "false" to let the base decide the time)
function metaNPC:DecideAnimationLength(anim, override, decrease)
	if isbool(anim) then return 0 end
	
	if override == false then -- Base decides
		return (vj_animdur(self, anim) - (decrease or 0)) / self:GetPlaybackRate()
	elseif isnumber(override) then -- User decides
		return override / self:GetPlaybackRate()
	else
		return 0
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function metaEntity:CalculateProjectile(projType, startPos, endPos, projVel)
	if projType == "Line" then -- Suggested to disable gravity!
		return ((endPos - startPos):GetNormal()) * projVel
	elseif projType == "Curve" then
		-- Oknoutyoun: https://gamedev.stackexchange.com/questions/53552/how-can-i-find-a-projectiles-launch-angle
		-- Negar: https://wikimedia.org/api/rest_v1/media/math/render/svg/4db61cb4c3140b763d9480e51f90050967288397
		local result = Vector(endPos.x - startPos.x, endPos.y - startPos.y, 0) -- Verchnagan deghe
		local pos_x = result:Length()
		local pos_y = endPos.z - startPos.z
		local grav = physenv.GetGravity():Length()
		local sqrtcalc1 = (projVel * projVel * projVel * projVel)
		local sqrtcalc2 = grav * ((grav * (pos_x * pos_x)) + (2 * pos_y * (projVel * projVel)))
		local calcsum = sqrtcalc1 - sqrtcalc2 -- Yergou tevere aveltsour
		if calcsum < 0 then -- Yete teve nevas e, ooremen sharnage
			calcsum = math.abs(calcsum)
		end
		local angsqrt =  math.sqrt(calcsum)
		local angpos = math.atan(((projVel * projVel) + angsqrt) / (grav * pos_x))
		local angneg = math.atan(((projVel * projVel) - angsqrt) / (grav * pos_x))
		local pitch = 1
		if angpos > angneg then
			pitch = angneg -- Yete asiga angpos enes ne, aveli veregele
		else
			pitch = angpos
		end
		result.z = math.tan(pitch) * pos_x
		return result:GetNormal() * projVel
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
	return AddEntityRelationship(self,...)
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
	return Disposition(self,...)
end
*/
---------------------------------------------------------------------------------------------------------------------------------------------
/* Disabled as this has now been replaced with a better system
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