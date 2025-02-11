AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/mortarsynth.mdl"
	// models/gunship.mdl // models/combine_helicopter.mdl
ENT.StartHealth = 150
ENT.HullType = HULL_TINY
ENT.MovementType = VJ_MOVETYPE_AERIAL
ENT.Aerial_AnimTbl_Calm = "mortar_back"
ENT.Aerial_AnimTbl_Alerted = "mortar_forward"
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_COMBINE"}
ENT.BloodColor = VJ.BLOOD_COLOR_OIL
ENT.HasDeathCorpse = false

ENT.HasMeleeAttack = true
ENT.AnimTbl_MeleeAttack = ACT_RANGE_ATTACK1
ENT.MeleeAttackDistance = 60
ENT.MeleeAttackDamageDistance = 80
ENT.TimeUntilMeleeAttackDamage = 0.7
ENT.NextAnyAttackTime_Melee = false
ENT.MeleeAttackDamage = 30
ENT.HasExtraMeleeAttackSounds = true
	-- ====== Sound Paths ====== --
ENT.SoundTbl_Breath = "npc/scanner/scanner_combat_loop1.wav"
ENT.SoundTbl_Idle = {"npc/scanner/scanner_talk1.wav", "npc/scanner/scanner_talk2.wav"}
ENT.SoundTbl_Alert = "npc/scanner/combat_scan5.wav"
ENT.SoundTbl_MeleeAttack = "npc/scanner/scanner_electric1.wav"
ENT.SoundTbl_MeleeAttackMiss = {"npc/zombie/claw_miss1.wav", "npc/zombie/claw_miss2.wav"}
ENT.SoundTbl_Pain = {"npc/scanner/scanner_pain1.wav", "npc/scanner/scanner_pain2.wav"}
ENT.SoundTbl_Death = "npc/waste_scanner/grenade_fire.wav"
---------------------------------------------------------------------------------------------------------------------------------------------
local spawnPos = Vector(0, 0, 10)
--
function ENT:Init()
	self:SetCollisionBounds(Vector(33, 33, 26), Vector(-33, -33, -30))
	self:SetPos(self:GetPos() + spawnPos)
end
---------------------------------------------------------------------------------------------------------------------------------------------
local defAng = Angle(0, 0, 0)
--
function ENT:OnDeath(dmginfo, hitgroup, status)
	if status == "Initial" then
		local myPos = self:GetPos()
		ParticleEffect("explosion_turret_break", myPos, defAng)
		util.BlastDamage(self, self, myPos, 80, 20)
	end
end