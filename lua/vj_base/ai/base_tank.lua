/*-----------------------------------------------
	*** Copyright (c) 2012-2024 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
---------------------------------------------------------------------------------------------------------------------------------------------
-- TANK BASE --
ENT.VJTag_ID_Boss = true
ENT.SightAngle = 360
ENT.HullType = HULL_LARGE
ENT.HasMeleeAttack = false
ENT.DisableWandering = true
ENT.CanReceiveOrders = false
ENT.BringFriendsOnDeath = false
ENT.CallForBackUpOnDamage = false
ENT.MoveOrHideOnDamageByEnemy = false
ENT.MoveOutOfFriendlyPlayersWay = false
ENT.Bleeds = false
ENT.Immune_Dissolve = true
ENT.Immune_AcidPoisonRadiation = true
ENT.Immune_Bullet = true
ENT.ImmuneDamagesTable = {DMG_PHYSGUN}
ENT.DeathCorpseCollisionType = COLLISION_GROUP_NONE
ENT.HasPainSounds = false
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SCHEDULE_FACE(faceType, customFunc) return end -- Tanks can NOT turn!
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MaintainAlertBehavior(alwaysChase) return end -- Tanks can NOT chase!
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Tank_AngleDiffuse(ang1, ang2)
	local outcome = ang1 - ang2
	if outcome < -180 then outcome = outcome + 360 end
	if outcome > 180 then outcome = outcome - 360 end
	return outcome
end