/*-----------------------------------------------
	*** Copyright (c) 2012-2026 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
---------------------------------------------------------------------------------------------------------------------------------------------
-- TANK BASE --
ENT.VJ_ID_Boss = true
ENT.SightAngle = 360
ENT.TurningSpeed = 0 -- Tanks shouldn't use Source Engine turning!
ENT.HullType = HULL_LARGE
ENT.HasMeleeAttack = false
ENT.DisableWandering = true
ENT.CanReceiveOrders = false
ENT.DeathAllyResponse = "OnlyAlert"
ENT.DamageAllyResponse = false
ENT.CombatDamageResponse = false
ENT.YieldToAlliedPlayers = false
ENT.Bleeds = false
ENT.Immune_Dissolve = true
ENT.Immune_Toxic = true
ENT.Immune_Bullet = true
ENT.DeathCorpseCollisionType = COLLISION_GROUP_NONE
ENT.HasPainSounds = false
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SCHEDULE_FACE(faceType, customFunc) return end -- Tanks do NOT turn like normal NPCs!
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MaintainAlertBehavior(alwaysChase) return end -- Tanks do NOT chase like normal NPCs!
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDamaged(dmginfo, hitgroup, status)
	-- Skip gravity gun damage and crossbow bolts
	if status == "Init" then
		local dmgInflictor = dmginfo:GetInflictor()
		if dmginfo:IsDamageType(DMG_PHYSGUN) or (IsValid(dmgInflictor) && dmgInflictor:GetClass() == "crossbow_bolt") then
			dmginfo:SetDamage(0)
		end
	-- Skip melee damages unless it's caused by a boss and is strong enough
	elseif status == "PreDamage" && (dmginfo:IsDamageType(DMG_SLASH) or dmginfo:IsDamageType(DMG_CLUB) or dmginfo:IsDamageType(DMG_GENERIC)) then
		if dmginfo:GetDamage() >= 30 && dmginfo:GetAttacker().VJ_ID_Boss then
			dmginfo:SetDamage(dmginfo:GetDamage() / 2)
		else
			dmginfo:SetDamage(0)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Tank_AngleDiffuse(ang1, ang2)
	local outcome = ang1 - ang2
	if outcome < -180 then outcome = outcome + 360 end
	if outcome > 180 then outcome = outcome - 360 end
	return outcome
end